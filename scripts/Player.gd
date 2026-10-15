extends CharacterBody2D
class_name Player
## Carl. Four-direction walking, a facing-sensitive interact zone, and the
## glasses toggle. The sprite sheet is 4 columns (frames) by 4 rows
## (down, left, right, up), 16x24 each.

@export var speed := 70.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var zone: Area2D = $InteractZone

var facing := Vector2.DOWN
var _anim_time := 0.0
var _frame := 0
## Frames to ignore the interact key after a dialogue closes, so the key
## that dismissed it doesn't immediately re-open something.
var _cooldown := 0

const ROW := {Vector2.DOWN: 0, Vector2.LEFT: 1, Vector2.RIGHT: 2, Vector2.UP: 3}


func _ready() -> void:
	add_to_group("player")
	var shadow := Sprite2D.new()
	shadow.texture = load("res://assets/sprites/shadow.png")
	shadow.position = Vector2(0, 2)
	shadow.z_index = -1
	add_child(shadow)
	move_child(shadow, 0)
	_apply_frame(false)


func _physics_process(delta: float) -> void:
	if Game.input_locked:
		velocity = Vector2.ZERO
		_animate(delta, false)
		_cooldown = 3
		return
	if _cooldown > 0:
		_cooldown -= 1
	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if dir.length() > 0.0:
		if absf(dir.x) > absf(dir.y):
			facing = Vector2.RIGHT if dir.x > 0.0 else Vector2.LEFT
		else:
			facing = Vector2.DOWN if dir.y > 0.0 else Vector2.UP
		zone.position = facing * 12.0
	velocity = dir.normalized() * speed
	move_and_slide()
	_animate(delta, dir.length() > 0.0)
	if Input.is_action_just_pressed("interact") and _cooldown == 0:
		_try_interact()
	if Input.is_action_just_pressed("toggle_glasses"):
		Game.toggle_glasses()


func _animate(delta: float, moving: bool) -> void:
	if moving:
		_anim_time += delta * 8.0
		_frame = int(_anim_time) % 4
	else:
		_anim_time = 0.0
		_frame = 0
	_apply_frame(moving)


func _apply_frame(_moving: bool) -> void:
	sprite.frame = ROW[facing] * 4 + _frame


func _try_interact() -> void:
	var best: Node = null
	var best_d := INF
	for area in zone.get_overlapping_areas():
		if area.has_method("interact"):
			var d := global_position.distance_to(area.global_position)
			if d < best_d:
				best_d = d
				best = area
	if best:
		best.interact()


## Face a world position (used by cutscenes).
func face_toward(target: Vector2) -> void:
	var d := target - global_position
	if absf(d.x) > absf(d.y):
		facing = Vector2.RIGHT if d.x > 0.0 else Vector2.LEFT
	else:
		facing = Vector2.DOWN if d.y > 0.0 else Vector2.UP
	zone.position = facing * 12.0
	_apply_frame(false)
