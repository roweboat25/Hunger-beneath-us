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


## Called by Main once the map is on screen.
func start() -> void:
	pass


## One line telling the player what to do next; shown under the HUD.
func objective_text() -> String:
	return ""


var _last_objective := "\u0001"


func _physics_process(_delta: float) -> void:
	if main == null:
		return
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
