extends Node2D
class_name MapScene
## Base for every map. A map owns its interactables and the scene logic for
## the chapter it covers. Main wires interactables to `on_interact`.

## Pixel size of the map, used to clamp the camera.
@export var map_size := Vector2i(960, 544)

var main: Node
## Ambient light for the map. Main applies it with a CanvasModulate.
var ambient := Color.WHITE

var ui: DialogueBox:
	get: return main.dialogue
var psyon: PsyonWindow:
	get: return main.psyon
var closeup: CloseUp:
	get: return main.closeup
var player: Player:
	get: return main.player


var _glyph_props: Array = []


func _ready() -> void:
	var actors := get_node_or_null("Actors")
	if actors:
		for node in actors.get_children():
			if node is Sprite2D and node.has_meta("glyph_deep"):
				_glyph_props.append(node)
	_update_glyphs()


## Called by Main once the map is on screen.
func start() -> void:
	pass


## Main wires every interactable here. Hidden glyphs are handled for all maps;
## everything else goes to the scene's own on_interact.
func _route_interact(id: String) -> void:
	if id.begins_with("glyph:"):
		await _examine_glyph(id)
	elif _has_line(id):
		await _say_line(id)
	else:
		on_interact(id)
		if not Game.incident_on(String(name), id).is_empty():
			main._show_toast("The frames flagged this. Scan it (F).")


## Ambient people and machines placed with metadata/say just talk; machines
## with an open incident on them tell Carl to scan.
func _has_line(id: String) -> bool:
	var node := interactable(id)
	return node != null and node.has_meta("say")


func _say_line(id: String) -> void:
	var node := interactable(id)
	var inc := Game.incident_on(String(name), id)
	if not inc.is_empty():
		await ui.think(String(node.get_meta("say")) + " The frames wanted a look at it. Scan it.")
		ui.close()
		return
	if node is NPC:
		if node.has_meta("speaker"):
			await ui.say(String(node.get_meta("speaker")), String(node.get_meta("say")))
		else:
			await ui.say("", String(node.get_meta("say")))
		var st := Game.stance()
		if not st.is_empty() and randf() < 0.3:
			await ui.say("", STANCE_LINES[st][randi() % STANCE_LINES[st].size()])
	else:
		await ui.think(String(node.get_meta("say")))
	ui.close()


## What people on the street add once the file has a word for Carl.
const STANCE_LINES := {
	"company": ["You're one of theirs. I can see the badge from here. Tell them the lamps are still out on Fargona.", "Company man. My cousin had a wellness flag too. Nobody's seen him since the tower sent a car."],
	"investigator": ["You're the one asking questions. Careful who hears you ask them.", "They say there's an investigator going round who doesn't file everything. Is that you? Good."],
	"sleeper": ["You look tired. Have you been dreaming? You hum it when you walk, you know.", "I saw you bow on the Spine. Don't be ashamed. Everyone bows eventually."],
}


func interactable(id: String) -> Node:
	for node in get_tree().get_nodes_in_group("interactable"):
		if node.id == id:
			return node
	return null


## The scan key: identify whatever Carl faces with the frames on.
func scan(target: Node) -> void:
	if not Game.glasses_on:
		await ui.think("Nothing to identify without the frames. Just a street, and people on it.")
		ui.close()
		return
	if target == null:
		main.show_scan("nothing in frame", "point the frames at someone. Or something.")
		return
	var id: String = target.id
	if Game.outage:
		main.show_scan("NO SIGNAL", "static\nstatic\nstatic", true)
		return
	var inc := Game.incident_on(String(name), id)
	if not inc.is_empty():
		main.show_scan(Game.INCIDENTS[inc]["title"], Game.INCIDENTS[inc]["card"], true)
		Game.scan_found(id)
		Game.input_locked = true
		await get_tree().create_timer(1.2).timeout
		Game.input_locked = false
		await _run_incident(inc)
		return
	var card := ""
	var bad := false
	if Game.connection >= 50.0 and randf() < 0.3:
		card = ["IDENTIFY: CARL DRAKE\nPsyonic Integrations  ·  Human-AI\nsync: 100%\nstatus: ON THE PATH", "SUBJECT\nplease convene\nplease convene\nplease convene", "UNIT: SLEEPER\nfrequency: MATCHED\nfacing: THE TOWER"][randi() % 3]
		bad = true
	elif target.has_meta("scan"):
		card = String(target.get_meta("scan"))
		bad = target.has_meta("scan_bad")
	elif target is NPC:
		card = "UNREGISTERED\nno ORA frames detected\nPsyon: none"
	else:
		card = "OBJECT\nno network ID"
	var who := id.capitalize()
	if target.has_meta("scan_name"):
		who = String(target.get_meta("scan_name"))
	main.show_scan(who, card, bad)
	if Game.scan_found(id):
		on_scanned(id)


## A scene hook for the first scan of something. Override.
func on_scanned(_id: String) -> void:
	pass


## An incident found: the three calls, each with its own cost.
func _run_incident(inc: String) -> void:
	var data: Dictionary = Game.INCIDENTS[inc]
	await ui.think(data["found"])
	var pick := await ui.choose(["Interface with it.", "Report it to Turan.", "Bury it.", "Let it run."])
	if pick == 0:
		ui.close()
		main.hide_scan()
		var solved := await interface(inc, String(data["title"]))
		if not solved:
			await ui.think("I pulled the frames off before it finished with me. The machine kept doing what it was doing.")
			ui.close()
			return
		await ui.think(data["fix"])
		ui.close()
		Game.resolve_incident(inc, "fixed")
		return
	var outcome: String = ["reported", "buried", "ran"][pick - 1]
	await ui.think(data[["report", "bury", "run"][pick - 1]])
	ui.close()
	Game.resolve_incident(inc, outcome)
	main.hide_scan()


## Jack into a machine through the frames: a puzzle set by whatever is in it.
## Returns true when it was solved. Solving teaches a line of the chant.
func interface(id: String, title: String) -> bool:
	if not Game.glasses_on:
		await ui.think("No frames, no interface. Just a machine, doing the wrong thing.")
		ui.close()
		return false
	var deep := Game.connection >= 50.0
	await ui.think("I put my hand on it and the frames took the rest. The street went away." if not deep else "I didn't decide to touch it. The frames were already in.")
	ui.close()
	Game.input_locked = true  # nothing fires again while the view fades in
	await main.filter.flash(0.1)
	var pz: Array = Game.puzzle_for(id, title)
	var ok: bool = await main.iface.run(pz[0], pz[1])
	if ok:
		Game.interface_solved(id)
		if deep:
			await ui.say("Psyon", "You already knew.", "psyon")
			ui.close()
	return ok


## An arcade machine: the same puzzles the broken devices set, played as a
## game. Without the frames it pays tickets; with them it is an interface
## like any other, and the arcade knows it.
func play_game(id: String, title: String, kind: String, info := {}) -> bool:
	Game.input_locked = true
	await main.filter.flash(0.06)
	var pz: Array = Game.puzzle_for(id, title)
	if not kind.is_empty() and pz[0] != kind:
		pz[0] = kind
		if kind == "chant":
			pz[1].merge(Game.RIDDLES.get(id, Game.RIDDLES["generic"]))
		elif kind == "dreamer":
			pz[1].merge(Game.QUESTIONS.get(id, Game.QUESTIONS["freudbot"]))
	for k in info:
		pz[1][k] = info[k]
	var ok: bool = await main.iface.run(pz[0], pz[1])
	if ok and Game.glasses_on:
		Game.interface_solved(id)
	return ok


func _examine_glyph(id: String) -> void:
	if not Game.glasses_on:
		await ui.think("Bare wall. Whatever was there, I couldn't see it without the frames.")
		ui.close()
		return
	var p := prop(id)
	if p and not p.visible:
		await ui.think("Something in the brick, almost. The frames couldn't resolve it. Not yet.")
		ui.close()
		return
	var line := Game.find_glyph(id)
	if line.is_empty():
		await ui.think("The same rings. Already logged.")
		ui.close()
		return
	await main.filter.flash(0.08)
	await ui.say("", "The rings turned once, and the frames parsed a line of it:\n\"" + line + "\"")
	ui.close()


## Hidden glyphs only draw with the frames on; deep ones need a high connection.
func _update_glyphs() -> void:
	for p in _glyph_props:
		var deep: bool = p.get_meta("glyph_deep", false)
		p.visible = Game.glasses_on and (not deep or Game.can_see_deep_glyphs())


## Walk through an exit of this map, as listed in World.EXITS.
func travel(exit_id: String) -> void:
	var e = World.EXITS.get(String(name), {}).get(exit_id)
	if e == null:
		push_warning("no exit " + exit_id + " from " + String(name))
		return
	Game.last_place = String(name)
	main._start_tile = e[1]
	await main.change_map("res://scenes/maps/" + e[0] + ".tscn")


## Leave an interior for the street outside, with the next plot beat marked.
func go_to_street(next_map: String) -> void:
	Game.next_beat = next_map
	await travel("exit")
## One line telling the player what to do next; shown under the HUD.
func objective_text() -> String:
	return ""


var _last_objective := "\u0001"
var _waypoint: Waypoint


## The interactable the objective is pointing at, marked on the map with a
## bouncing chevron so a doorway reads as a doorway. "" for none.
func waypoint_id() -> String:
	return "exit" if objective_text().begins_with("Leave") else ""


func _update_waypoint() -> void:
	if _waypoint == null:
		_waypoint = Waypoint.new()
		add_child(_waypoint)
	var id := waypoint_id()
	var node: Node = interactable(id) if not id.is_empty() else null
	if node == null or not node.visible:
		_waypoint.visible = false
		return
	var shape: CollisionShape2D = node.get_node_or_null("Shape")
	var size := Vector2(32, 32)
	if shape and shape.shape is RectangleShape2D:
		size = shape.shape.size
	_waypoint.visible = true
	_waypoint.global_position = node.global_position + Vector2(size.x / 2.0, -size.y / 2.0 - 12.0)


func _physics_process(_delta: float) -> void:
	if main == null:
		return
	_update_glyphs()
	var o := objective_text()
	if o != _last_objective:
		_last_objective = o
		main.filter.set_objective(o)
	_update_waypoint()


## Called for every examine, talk, and floor trigger in this map.
func on_interact(_id: String) -> void:
	pass


func remove_interactable(id: String) -> void:
	for node in get_tree().get_nodes_in_group("interactable"):
		if node.id == id:
			node.queue_free()


func npc(id: String) -> NPC:
	for node in get_tree().get_nodes_in_group("interactable"):
		if node is NPC and node.id == id:
			return node
	return null


## Props placed by tools/gen_maps.py with an id can be shown, hidden or removed.
func prop(id: String) -> Sprite2D:
	var actors := get_node_or_null("Actors")
	if actors:
		for node in actors.get_children():
			if node is Sprite2D and node.get_meta("prop_id", "") == id:
				return node
	return null


func show_prop(id: String, shown := true) -> void:
	var p := prop(id)
	if p:
		p.visible = shown


func remove_prop(id: String) -> void:
	var p := prop(id)
	if p:
		p.queue_free()


## Short pause that the autoplay can skip through.
func beat(seconds := 0.6) -> void:
	await get_tree().create_timer(seconds).timeout
