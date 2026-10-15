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


func start() -> void:
	if not title.is_empty() and not Game.has_flag("visited_" + String(name)):
		Game.set_flag("visited_" + String(name))
		await main.show_title(title, subtitle)
		await intro()
	Game.input_locked = false
	main.filter.set_hud_text("ORA  ·  " + World.place(String(name)).get_slice(",", 0))


## Lines on first arrival, after the title card. Override.
func intro() -> void:
	pass


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	_update_gated_npcs()


## NPCs placed with metadata/min_connection only exist once Carl is far enough in.
func _update_gated_npcs() -> void:
	var actors := get_node_or_null("Actors")
	if actors == null:
		return
	for node in actors.get_children():
		if node is NPC and node.has_meta("min_connection"):
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
	if target == Game.next_beat:
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
