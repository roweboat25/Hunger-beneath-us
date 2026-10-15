extends Node
## Headless playthrough for CI-style checks:
##   godot --headless --path . -- --autoplay
## Walks every map in order: calls every interactable in the current map
## (twice, so gated ones fire once their prerequisite has run), drives all
## dialogue, choices and the Psyon window, and expects each map to hand
## off to the next one. Stops when the act1_done flag is set.

var main: Node
var _choice := 0


func _ready() -> void:
	main = get_parent()
	call_deferred("run")


func run() -> void:
	await get_tree().create_timer(0.5).timeout
	await _drive("intro")
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--tour="):
			await _tour(arg.trim_prefix("--tour=").split(","))
			return
	var maps_seen := 0
	while not Game.has_flag("act1_done") and maps_seen < 80:
		var map: Node = main.map
		var map_name := String(map.name)
		maps_seen += 1
		print("autoplay: map ", map_name)
		for pass_i in 3:
			if main.map != map or Game.has_flag("act1_done"):
				break
			for node in _live_interactables(map):
				if main.map != map or Game.has_flag("act1_done"):
					break
				if not is_instance_valid(node):
					continue
				var id: String = node.id
				if id == "laptop" and map_name == "Apartment":
					await _laptop_keypress()
				else:
					map._route_interact(id)
				await _drive(map_name + "/" + id)
		if main.map == map and not Game.has_flag("act1_done"):
			push_error("autoplay: stuck in map " + map_name)
			get_tree().quit(1)
			return
	assert(Game.has_flag("act1_done"), "act 1 should finish")
	print("AUTOPLAY DONE  connection=", Game.connection, "  log entries=", Game.case_log.size(),
		"  evidence=", Game.evidence, "  trust=", Game.trust, "  flags=", Game.flags.keys())
	get_tree().quit()


func _live_interactables(map: Node) -> Array:
	var out := []
	var holder: Node = map.get_node_or_null("Interactables")
	if holder == null:
		return out
	var children: Array = holder.get_children()
	var actors: Node = map.get_node_or_null("Actors")
	if actors:
		for node in actors.get_children():
			if node is NPC:
				children.append(node)
	# plain triggers first, people last, exits very last
	var exits := []
	var people := []
	for node in children:
		if node is NPC:
			people.append(node)
		elif node.id == "exit" or node.id.begins_with("exit:") or node.id.begins_with("door:") or node.id == "door" and String(map.name) == "Desert":
			if map.has_method("recommended_exit") and node.id != map.recommended_exit():
				continue  # streets: only take the exit the objective points at
			exits.append(node)
		else:
			out.append(node)
	return out + people + exits


## A real interact press on the apartment laptop, through the player's zone.
func _laptop_keypress() -> void:
	main.player.global_position = Vector2(28 * 32 + 16, 6 * 32 + 28)
	main.player.face_toward(Vector2(28 * 32 + 16, 5 * 32 + 16))
	await get_tree().create_timer(0.3).timeout
	Input.action_press("interact")
	await get_tree().process_frame
	Input.action_release("interact")


## Keep advancing whatever UI is up until the game is idle for a moment.
func _drive(label: String) -> void:
	var idle := 0.0
	var elapsed := 0.0
	while elapsed < 120.0:
		await get_tree().create_timer(0.1).timeout
		elapsed += 0.1
		var d: DialogueBox = main.dialogue
		var p: PsyonWindow = main.psyon
		if d.visible:
			if not d._choice_buttons.is_empty():
				# alternate choices so more branches get exercised
				d._pick(_choice % d._choice_buttons.size())
				_choice += 1
			elif d._typing:
				d._typing = false
			else:
				d.advanced.emit()
			idle = 0.0
		elif p.visible and p._accepting:
			p._on_submit(["who are you", "what did you say to Dufredy", "show me the transcript", "yes"][Psyon.transcript.size() % 4])
			idle = 0.0
		elif main.closeup.visible and main.closeup._accepting:
			main.closeup.autoplay_step()
			idle = 0.0
		elif Game.input_locked:
			idle = 0.0
		else:
			idle += 0.1
			if idle > 0.6:
				break
	if elapsed >= 120.0:
		push_error("autoplay: timed out in " + label)
		get_tree().quit(1)
	else:
		print("autoplay: finished '", label, "' after ", snapped(elapsed, 0.1), "s")


## Side-content check: visit each named map, fire every interactable except
## exits and doors (twice, for gated ones), then quit.
func _tour(maps: PackedStringArray) -> void:
	for map_name in maps:
		Game.connection = 60.0  # so connection-gated figures and happenings exist
		await main.change_map("res://scenes/maps/" + map_name + ".tscn")
		await _drive(map_name + "/start")
		var map: Node = main.map
		print("tour: map ", map_name)
		for pass_i in 2:
			if not is_instance_valid(map) or main.map != map:
				break  # a plot door moved us on; the next map is listed or not
			for node in _live_interactables(map):
				if not is_instance_valid(node) or main.map != map:
					continue
				var id: String = node.id
				if id == "exit" or id.begins_with("exit:") or id.begins_with("door:"):
					continue
				map._route_interact(id)
				await _drive(map_name + "/" + id)
	print("TOUR DONE  connection=", Game.connection, "  log entries=", Game.case_log.size())
	get_tree().quit()
