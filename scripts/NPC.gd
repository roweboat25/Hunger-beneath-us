extends Interactable
class_name NPC
## A character standing in a map. Talk to them with the interact key.
## Builds its own sprite and a solid body so Carl can't walk through them.
## `sprite_sheet` is a 4x4 sheet like the player's (down, left, right, up).

@export var sprite_sheet: String = "res://assets/sprites/lynx.png"
@export var facing := "down"

const ROWS := {"down": 0, "left": 1, "right": 2, "up": 3}

var sprite: Sprite2D
var _body: StaticBody2D


func _ready() -> void:
	super._ready()
	sprite = Sprite2D.new()
	sprite.texture = load(sprite_sheet)
	sprite.hframes = 4
	sprite.vframes = 4
	sprite.frame = ROWS.get(facing, 0) * 4
	sprite.position = Vector2(0, -9)
	add_child(sprite)
	_body = StaticBody2D.new()
	_body.collision_layer = 1
	_body.collision_mask = 0
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(12, 10)
	shape.shape = rect
	_body.add_child(shape)
	add_child(_body)


func face(dir: String) -> void:
	facing = dir
	sprite.frame = ROWS.get(dir, 0) * 4


## Turn toward a world position.
func face_toward(target: Vector2) -> void:
	var d := target - global_position
	if absf(d.x) > absf(d.y):
		face("right" if d.x > 0.0 else "left")
	else:
		face("down" if d.y > 0.0 else "up")


## Walk away and disappear (used when someone leaves a scene).
func leave(offset: Vector2, seconds := 1.0) -> void:
	_body.queue_free()
	var t := create_tween()
	t.tween_property(self, "position", position + offset, seconds)
	t.parallel().tween_property(self, "modulate:a", 0.0, seconds)
	await t.finished
	queue_free()
