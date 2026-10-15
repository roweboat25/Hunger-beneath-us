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
