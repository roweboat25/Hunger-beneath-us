class_name Anim
## Procedural animation for Body figures, driven from each level's
## _process: walk cycles with knees and counter-swinging arms, a torso bob,
## idles that breathe and shift weight, and heads that track a point.
## Everything is a pose set from a clock, so it is stateless and cheap.

const HEAD_Y := 1.72


## A walking pose at clock `t` (seconds times stride rate; speed 1 = a
## stroll). `phase` offsets people so a crowd does not march in step.
static func walk(fig: Node3D, t: float, speed := 1.0, phase := 0.0, amp := 1.0) -> void:
	var c := t * speed * 4.5 + phase
	var legs: Array = fig.get_meta("legs", [])
	var knees: Array = fig.get_meta("knees", [])
	var arms: Array = fig.get_meta("arms", [])
	var sw := sin(c) * 0.45 * amp
	for i in legs.size():
		var s := 1.0 if i == 0 else -1.0
		(legs[i] as Node3D).rotation.x = sw * s
		if i < knees.size():
			# the knee bends on the swing-through, straight when planted
			var k := maxf(0.0, -sin(c + PI * 0.5) * s)
			(knees[i] as Node3D).rotation.x = k * 0.9 * amp
	for i in arms.size():
		var s := 1.0 if i == 0 else -1.0
		var a := arms[i] as Node3D
		a.rotation.x = -sw * 0.7 * s  # against the legs
		a.rotation.z = (0.1 if a.position.x > 0.0 else -0.1)
	var body: Node3D = fig.get_meta("body", null)
	if body:
		body.position.y = absf(sin(c)) * 0.03 * amp
		body.rotation.y = sin(c) * 0.06 * amp
		body.rotation.z = sin(c) * 0.025 * amp
	var head: Node3D = fig.get_meta("head", null)
	if head:
		head.position.y = HEAD_Y + absf(sin(c)) * 0.03 * amp


## Standing still: breathing, a small sway, the weight shifting every few
## seconds. `phase` keeps a crowd out of sync.
static func idle(fig: Node3D, t: float, phase := 0.0) -> void:
	var c := t + phase
	for l in fig.get_meta("legs", []):
		(l as Node3D).rotation.x = lerpf((l as Node3D).rotation.x, 0.0, 0.2)
	for k in fig.get_meta("knees", []):
		(k as Node3D).rotation.x = lerpf((k as Node3D).rotation.x, 0.0, 0.2)
	var shift := sin(c * 0.35) * 0.5 + 0.5
	for a in fig.get_meta("arms", []):
		var n := a as Node3D
		n.rotation.x = lerpf(n.rotation.x, sin(c * 0.9) * 0.03, 0.2)
		n.rotation.z = (0.08 if n.position.x > 0.0 else -0.08) + sin(c * 0.6) * 0.02
	var body: Node3D = fig.get_meta("body", null)
	if body:
		body.position.y = sin(c * 1.4) * 0.006
		body.scale.y = 1.0 + sin(c * 1.4) * 0.006  # breathing
		body.rotation.z = (shift - 0.5) * 0.05
		body.position.x = (shift - 0.5) * 0.03
	var head: Node3D = fig.get_meta("head", null)
	if head:
		head.position.y = HEAD_Y + sin(c * 1.4) * 0.006
		head.position.x = (shift - 0.5) * 0.03


## Turn the head toward a world point, within human limits, blending over
## `k` (0..1 per call). `amount` 0 returns it to straight ahead.
static func look(fig: Node3D, target: Vector3, amount := 1.0, k := 0.1) -> void:
	var head: Node3D = fig.get_meta("head", null)
	if not head:
		return
	var local := fig.to_local(target) - Vector3(0, HEAD_Y, 0)
	var yaw := clampf(atan2(-local.x, -local.z), -1.2, 1.2) * amount
	var pitch := clampf(atan2(local.y, Vector2(local.x, local.z).length()), -0.6, 0.5) * amount
	head.rotation.y = lerp_angle(head.rotation.y, yaw, k)
	head.rotation.x = lerp_angle(head.rotation.x, -pitch, k)
	# the shoulders follow a little
	var body: Node3D = fig.get_meta("body", null)
	if body:
		body.rotation.y = lerp_angle(body.rotation.y, yaw * 0.25, k)


## Seated, legs forward at the knee; `lean` tilts the torso back a little.
static func sit(fig: Node3D, lean := 0.1) -> void:
	for l in fig.get_meta("legs", []):
		(l as Node3D).rotation.x = PI / 2.0
	for k in fig.get_meta("knees", []):
		(k as Node3D).rotation.x = -PI / 2.0
	var body: Node3D = fig.get_meta("body", null)
	if body:
		body.rotation.x = -lean
	for a in fig.get_meta("arms", []):
		(a as Node3D).rotation.x = -0.6


## Crouched on the balls of the feet, as Seth is at the bench.
static func crouch(fig: Node3D) -> void:
	for l in fig.get_meta("legs", []):
		(l as Node3D).rotation.x = 1.6
	for k in fig.get_meta("knees", []):
		(k as Node3D).rotation.x = -2.3
	var body: Node3D = fig.get_meta("body", null)
	if body:
		body.rotation.x = 0.35
		body.position.y = -0.55
	var head: Node3D = fig.get_meta("head", null)
	if head:
		head.position.y = HEAD_Y - 0.6
