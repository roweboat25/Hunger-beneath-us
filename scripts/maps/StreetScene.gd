extends MapScene
class_name StreetScene
## An outdoor map of Silico: a district street or a route between two.
## Exits lead to other streets freely; doors into interiors only open when
## that interior is the next plot beat. The objective line routes the
## player through the world graph in World.gd.

## Title card shown the first time Carl enters this map.
var title := ""
var subtitle := ""
var ambient_tint := Color(0.88, 0.84, 0.92)


func _init() -> void:
	ambient = ambient_tint


func objective_text() -> String:
	var path := World.route(String(name), Game.next_beat)
	var line := "Go to " + World.place(Game.next_beat) + "."
	if not path.is_empty():
		line += "  " + World.hint(String(name), path[0])
	return line


## The exit the objective is pointing at, for the autoplay.
func recommended_exit() -> String:
	var path := World.route(String(name), Game.next_beat)
	return path[0] if not path.is_empty() else ""


var _outage_left := 0.0
var _ambient_base: Color


func start() -> void:
	_ambient_base = ambient
	var first := not Game.has_flag("visited_" + String(name))
	if not title.is_empty() and first:
		Game.set_flag("visited_" + String(name))
		await main.show_title(title, subtitle)
		await intro()
	Game.input_locked = false
	main.filter.set_hud_text("ORA  ·  " + World.place(String(name)).get_slice(",", 0))
	_start_drones()
	if not first and Game.has_flag("warroom1_done") and randf() < 0.22 + Game.connection / 250.0:
		_begin_outage()


## A rolling Psyon outage: the street goes dark, every screen to static, and
## everyone on it turns to face the tower until the service comes back.
func _begin_outage() -> void:
	Game.set_outage(true)
	_outage_left = randf_range(25.0, 40.0)
	main.set_ambient(_ambient_base * Color(0.45, 0.42, 0.55))
	main.filter.set_hud_text("ORA  ·  NO SIGNAL")
	_swap_props("ad_screen", "ad_screen_static", true)
	_swap_props("kiosk", "kiosk_static", true)
	var actors := get_node_or_null("Actors")
	if actors:
		for node in actors.get_children():
			if node is NPC and node.visible:
				node.face("up")


func _end_outage() -> void:
	Game.set_outage(false)
	main.set_ambient(_ambient_base)
	main.filter.set_hud_text("ORA  ·  " + World.place(String(name)).get_slice(",", 0))
	_swap_props("ad_screen", "ad_screen_static", false)
	_swap_props("kiosk", "kiosk_static", false)


## Props placed as pairs (an `x` and an `x_static` at the same spot) swap over.
func _swap_props(normal: String, broken: String, to_broken: bool) -> void:
	var actors := get_node_or_null("Actors")
	if actors == null:
		return
	for node in actors.get_children():
		if node is Sprite2D and node.has_meta("pair"):
			var pair := String(node.get_meta("pair"))
			if pair == normal:
				node.visible = not to_broken
			elif pair == broken:
				node.visible = to_broken


## Drones bob in place; the swarm's ring turns.
func _start_drones() -> void:
	var actors := get_node_or_null("Actors")
	if actors == null:
		return
	for node in actors.get_children():
		if node is Sprite2D and node.has_meta("drone"):
			var t := create_tween().set_loops()
			var dy := randf_range(3.0, 6.0)
			t.tween_property(node, "offset:y", node.offset.y - dy, randf_range(0.9, 1.6)).set_trans(Tween.TRANS_SINE)
			t.tween_property(node, "offset:y", node.offset.y, randf_range(0.9, 1.6)).set_trans(Tween.TRANS_SINE)


## A line for the ORA feed. Streets add their own; "" means nothing this time.
func feed_line() -> String:
	return Game.feed_line()


## Lines on first arrival, after the title card. Override.
func intro() -> void:
	pass


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	_update_gated_npcs()
	if _outage_left > 0.0:
		_outage_left -= delta
		if _outage_left <= 0.0:
			_end_outage()


func _exit_tree() -> void:
	if Game.outage:
		Game.set_outage(false)
		main.set_ambient(Color.WHITE)


## NPCs placed with metadata/min_connection only exist once Carl is far enough in.
func _update_gated_npcs() -> void:
	var actors := get_node_or_null("Actors")
	if actors == null:
		return
	for node in actors.get_children():
		if node is NPC and node.has_meta("min_connection") and not node.has_meta("gone"):
			var show: bool = Game.connection >= float(node.get_meta("min_connection"))
			if node.visible != show:
				node.visible = show
				node.set_deferred("monitorable", show)


func _route_interact(id: String) -> void:
	if id.begins_with("exit:"):
		await travel(id)
	elif id.begins_with("door:"):
		await _door(id)
	else:
		await super._route_interact(id)


func _door(id: String) -> void:
	var target: String = World.EXITS[String(name)][id][0]
	if target in World.GATES:
		var gate: Array = World.GATES[target]
		if Game.has_flag(gate[0]):
			await travel(id)
		else:
			await ui.think(gate[1])
			ui.close()
			player.position += Vector2(0, 12)
		return
	if target == Game.next_beat or target in World.SIDE_INTERIORS:
		await travel(id)
		return
	if target == Game.last_place:
		await ui.think("I'd just come from " + World.place(target).get_slice(",", 0) + ". Nothing left for me there right now.")
	else:
		await ui.think("Not yet. " + objective_text())
	ui.close()
	# step back off the doorway so it can fire again
	player.position += Vector2(0, 12)


## True when an NPC exists and is visible (gated ones hide until connection allows).
func npc_visible(id: String) -> bool:
	var n := npc(id)
	return n != null and n.visible


## A confrontation: not a fight. Three verbs, up to three rounds. `lines` holds
## the encounter's text: intro, look_on, look_off, speak_known, speak_unknown,
## run, closer, touched. Returns "seen", "spoken", "ran" or "touched".
func confront(lines: Dictionary) -> String:
	await ui.say("", lines["intro"])
	var pressure := 0
	for round_i in 3:
		var pick := await ui.choose(["Look.", "Speak.", "Run."])
		match pick:
			0:
				if Game.glasses_on:
					await ui.say("", lines["look_on"])
					Game.add_connection(1.0, "looked at it")
					if Game.connection < 50.0:
						ui.close()
						return "seen"
					pressure += 1
				else:
					await ui.say("", lines["look_off"])
					pressure += 1
			1:
				if Game.glyphs_found.size() >= 3 or Game.has_flag("chant_wall_done"):
					await ui.say("", lines["speak_known"])
					ui.close()
					Game.add_connection(2.0, "spoke to it")
					return "spoken"
				await ui.say("", lines["speak_unknown"])
				pressure += 1
			2:
				await ui.say("", lines["run"])
				ui.close()
				Game.add_connection(1.0, "ran")
				return "ran"
		if pressure >= 2:
			await main.filter.flash(0.15)
			await ui.say("", lines["touched"])
			ui.close()
			Game.add_connection(5.0, "it touched me")
			return "touched"
		await ui.say("", lines["closer"])
	ui.close()
	return "touched"


## The company car: fast travel between districts Carl has walked, once Turan
## has sent him out on the company's business.
func fast_travel() -> void:
	if not Game.has_flag("warroom1_done"):
		await ui.think("My sedan. Company plates, company logs. Everywhere I drove it, the tower knew.")
		ui.close()
		return
	var options := []
	var targets := []
	for map_name in World.CAR_SPOTS:
		if map_name != String(name) and Game.has_flag("visited_" + map_name):
			options.append("Drive to " + World.place(map_name).get_slice(",", 0) + ".")
			targets.append(map_name)
	if options.is_empty():
		await ui.think("Nowhere I'd been yet that the car could take me.")
		ui.close()
		return
	options.append("Stay.")
	await ui.think("The car. The logs would show the trip; the logs showed everything.")
	var pick := await ui.choose(options)
	ui.close()
	if pick >= targets.size():
		return
	Game.last_place = String(name)
	main._start_tile = World.CAR_SPOTS[targets[pick]]
	await main.change_map("res://scenes/maps/" + targets[pick] + ".tscn")
