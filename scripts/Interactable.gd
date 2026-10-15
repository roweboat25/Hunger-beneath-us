extends Area2D
class_name Interactable
## Something Carl can examine or talk to. Lives on collision layer 3 so the
## player's InteractZone can find it. Floor triggers set `on_enter` and fire
## when the player walks onto them instead.

signal interacted(id: String)

@export var id: String = ""
## When true this fires on body_entered instead of on the interact key.
@export var on_enter := false
## When true the trigger only fires once.
@export var once := true

var _fired := false


func _ready() -> void:
	collision_layer = 4
	collision_mask = 2 if on_enter else 0
	add_to_group("interactable")
	if on_enter:
		body_entered.connect(_on_body_entered)


func interact() -> void:
	if on_enter:
		return
	interacted.emit(id)


func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	if once and _fired:
		return
	_fired = true
	interacted.emit(id)
