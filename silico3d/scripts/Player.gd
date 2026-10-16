extends CharacterBody3D
## Carl, in first person. Mouse or arrow keys to look, WASD to walk,
## Shift to hurry. The camera ray finds whatever he is looking at.

signal stepped

const WALK := 2.6
const RUN := 4.8
const EYE := 1.66
const SENS := 0.0024

var cam: Camera3D
var ray: RayCast3D
var yaw := 0.0
var pitch := 0.0
var locked := false
## In the car: he can look around but not walk.
var seated := false
## Lowers the eyes: kneeling by something on the floor, or sitting.
var crouch := 0.0
var _bob := 0.0
var _step_acc := 0.0
var _shake := 0.0


func _ready() -> void:
	collision_layer = 0
	collision_mask = 1
	var cs := CollisionShape3D.new()
	var cap := CapsuleShape3D.new()
	cap.radius = 0.32
	cap.height = 1.75
	cs.shape = cap
	cs.position.y = 0.875
	add_child(cs)
	cam = Camera3D.new()
	cam.position.y = EYE
	cam.fov = 72.0
	cam.near = 0.05
	cam.far = 1600.0
	cam.cull_mask &= ~(1 << 19)  # layer 20: only Psyon's pictures see it
	add_child(cam)
	ray = RayCast3D.new()
	ray.target_position = Vector3(0, 0, -3.6)
	ray.collision_mask = 2
	ray.collide_with_areas = true
	ray.collide_with_bodies = true
	cam.add_child(ray)
	floor_snap_length = 0.3


func _unhandled_input(e: InputEvent) -> void:
	if locked:
		return
	if e is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		yaw -= e.relative.x * SENS
		pitch = clampf(pitch - e.relative.y * SENS, -1.45, 1.45)


func shake(amount: float) -> void:
	_shake = maxf(_shake, amount)


func looked_at() -> Object:
	if ray.is_colliding():
		var c := ray.get_collider()
		if c and c.has_meta("id"):
			return c
	return null


## Turn smoothly to face a point (used when something makes Carl look).
func face(point: Vector3, t := 1.2) -> void:
	var d := point - cam.global_position
	var want_yaw := atan2(-d.x, -d.z)
	var want_pitch := atan2(d.y, Vector2(d.x, d.z).length())
	var tw := create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE)
	tw.tween_property(self, "yaw", yaw + wrapf(want_yaw - yaw, -PI, PI), t)
	tw.tween_property(self, "pitch", clampf(want_pitch, -1.45, 1.45), t)
	await tw.finished


func _physics_process(delta: float) -> void:
	if seated:
		rotation.y = yaw
		if not locked:
			var tn := Input.get_axis("turn_right", "turn_left")
			yaw += tn * 2.2 * delta
		cam.position = Vector3(0, EYE - crouch, 0)
		cam.rotation = Vector3(pitch, 0, 0)
		if _shake > 0.0:
			cam.position += Vector3(randf_range(-1, 1), randf_range(-1, 1), 0) * _shake * 0.05
			_shake = maxf(0.0, _shake - delta * 1.5)
		return
	if not is_on_floor():
		velocity.y -= 18.0 * delta
	var input := Vector2.ZERO
	if not locked:
		input = Input.get_vector("move_left", "move_right", "move_fwd", "move_back")
		var turn := Input.get_axis("turn_right", "turn_left")
		yaw += turn * 2.2 * delta
		var tilt := Input.get_axis("look_down", "look_up")
		pitch = clampf(pitch + tilt * 1.6 * delta, -1.45, 1.45)
	var speed := RUN if Input.is_action_pressed("run") else WALK
	var dir := (Basis(Vector3.UP, yaw) * Vector3(input.x, 0, input.y))
	velocity.x = lerpf(velocity.x, dir.x * speed, minf(1.0, delta * 10.0))
	velocity.z = lerpf(velocity.z, dir.z * speed, minf(1.0, delta * 10.0))
	move_and_slide()
	rotation.y = yaw
	var moving := Vector2(velocity.x, velocity.z).length()
	if moving > 0.4 and is_on_floor():
		_bob += delta * moving * 2.6
		_step_acc += delta * moving
		if _step_acc > 1.5:
			_step_acc = 0.0
			stepped.emit()
	var shake_v := Vector3.ZERO
	if _shake > 0.0:
		shake_v = Vector3(randf_range(-1, 1), randf_range(-1, 1), 0) * _shake * 0.05
		_shake = maxf(0.0, _shake - delta * 1.5)
	cam.position = Vector3(cos(_bob * 0.5) * 0.025, EYE - crouch + absf(sin(_bob)) * 0.045, 0) + shake_v
	cam.rotation = Vector3(pitch, 0, sin(_bob * 0.5) * 0.004)
