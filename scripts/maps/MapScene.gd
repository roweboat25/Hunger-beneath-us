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
	else:
		await ui.think(String(node.get_meta("say")))
	ui.close()


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
	var pick := await ui.choose(["Report it to Turan.", "Bury it.", "Let it run."])
	var outcome: String = ["reported", "buried", "ran"][pick]
	await ui.think(data[["report", "bury", "run"][pick]])
	ui.close()
	Game.resolve_incident(inc, outcome)
	main.hide_scan()


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


func _physics_process(_delta: float) -> void:
	if main == null:
		return
	_update_glyphs()
	var o := objective_text()
	if o != _last_objective:
		_last_objective = o
		main.filter.set_objective(o)


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
