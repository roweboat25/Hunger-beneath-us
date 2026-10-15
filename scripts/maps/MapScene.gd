extends Node2D
class_name MapScene
## Base for every map. A map owns its interactables and the scene logic for
## the chapter it covers. Main wires interactables to `on_interact`.

## Pixel size of the map, used to clamp the camera.
@export var map_size := Vector2i(480, 272)

var main: Node

var ui: DialogueBox:
	get: return main.dialogue
var psyon: PsyonWindow:
	get: return main.psyon
var player: Player:
	get: return main.player


## Called by Main once the map is on screen.
func start() -> void:
	pass


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


## Swap one tile on the Objects layer (e.g. remove a prop after it is taken).
func set_object_tile(cell: Vector2i, atlas: Vector2i) -> void:
	var objects: TileMapLayer = get_node_or_null("Objects")
	if objects:
		objects.set_cell(cell, 0, atlas)


func erase_object_tile(cell: Vector2i) -> void:
	var objects: TileMapLayer = get_node_or_null("Objects")
	if objects:
		objects.erase_cell(cell)


## Short pause that the autoplay can skip through.
func beat(seconds := 0.6) -> void:
	await get_tree().create_timer(seconds).timeout
