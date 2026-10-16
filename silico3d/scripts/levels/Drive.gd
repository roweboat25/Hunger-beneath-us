extends "res://scripts/Level.gd"
## Chapter 1, the drive: from Dufredy's street to Harmony Green, seen from
## the driver's seat of Carl's company car. He can look around; the car
## drives itself (it's a Psyonic fleet car). Book, ch. 1: the broken
## promises that brought two million souls here; AI that can barely keep
## the stoplights working; everyone turned into janitors; moving here at 13;
## "a mechanical marvel in the middle of the New Mexican desert"; the rot is
## the reason he has a job. The road runs along -Z.

const LANE_X := 2.4
const SEAT := Vector3(-0.38, 0.0, 0.25)
const END_Z := -940.0
const STOP_Z := -180.0

var car: Node3D
var speed := 0.0
var want_speed := 0.0
var dash_label: Label3D
var dash_m: StandardMaterial3D
var signals: Array = []
var watchers: Array = []
var hazards: Array = []
var workers: Array = []
var _engine: AudioStreamPlayer
var _done := false


func build(m: Node) -> void:
	main = m
	rng.seed = 13
	card = ""
	_road()
	_blocks()
	_stoplight()
	_workers()
	_billboard()
	_outage_block()
	_park_edge()
	_tower()
	_batch(self, 40.0)
	_car()
	spawn = car.position + SEAT
	spawn_yaw = 0.0


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	var psm := ProceduralSkyMaterial.new()
	psm.sky_top_color = Color(0.3, 0.47, 0.72)
	psm.sky_horizon_color = Color(0.86, 0.74, 0.58)
	psm.ground_horizon_color = Color(0.76, 0.64, 0.48)
	psm.ground_bottom_color = Color(0.3, 0.24, 0.18)
	env.sky.sky_material = psm
	env.ambient_light_color = Color(0.68, 0.62, 0.55)
	env.ambient_light_energy = 0.45
	env.reflected_light_source = Environment.REFLECTION_SOURCE_DISABLED
	env.fog_light_color = Color(0.82, 0.7, 0.54)
	env.fog_density = 0.0016
	env.fog_sky_affect = 0.15
	env.tonemap_exposure = 1.0
	env.glow_hdr_threshold = 1.2
	sun.light_color = Color(1.0, 0.9, 0.76)
	sun.light_energy = 1.3
	sun.sky_mode = DirectionalLight3D.SKY_MODE_LIGHT_AND_SKY
	sun.rotation = Vector3(deg_to_rad(-38), deg_to_rad(130), 0)
	sun.directional_shadow_max_distance = 80.0


func ambience() -> void:
	_engine = main.loop("engine", -16.0)
	main.loop("hum", -24.0)


# ------------------------------------------------------------------ the city by day

func _road() -> void:
	var asphalt := tex_mat(Tex.asphalt(), Vector3(4, 200, 1), 0.6)
	asphalt.albedo_color = Color(1.5, 1.45, 1.4)
	floor_quad(Vector2(16, 1100), Vector3(0, 0, -450), 0.0, asphalt)
	var pave := tex_mat(Tex.paving(), Vector3(2, 160, 1), 0.8)
	pave.albedo_color = Color(2.1, 2.0, 1.85)
	for side: float in [-1.0, 1.0]:
		floor_quad(Vector2(6, 1100), Vector3(side * 11.0, 0.08, -450), 0.0, pave)
	var line := mat(Color(0.85, 0.8, 0.6), 0.6)
	var z := 20.0
	while z > -1000.0:
		box(Vector3(0.14, 0.01, 3.0), Vector3(0, 0.01, z), line)
		z -= 9.0
	var sand := decal_mat(Tex.sand(), Color(1, 1, 1), 1.0)
	for i in 50:
		floor_quad(Vector2(rng.randf_range(2, 5), rng.randf_range(1, 2)),
			Vector3((7.6 if i % 2 == 0 else -7.6) + rng.randf_range(-0.5, 0.5), 0.02 + i * 0.0002, rng.randf_range(-1000, 20)), rng.randf_range(-0.3, 0.3), sand)
	floor_quad(Vector2(2000, 2400), Vector3(0, -0.05, -600), 0.0, mat(Color(0.6, 0.5, 0.36), 1.0))


func _blocks() -> void:
	var walls := []
	for i in 5:
		var t: Array = Tex.facade(400 + i, 0.0)
		var w := newmat(Color(1.5, 1.45, 1.4).lerp(Color(1.7, 1.5, 1.3), i / 4.0), 0.8)
		w.albedo_texture = t[0]
		w.uv1_triplanar = true
		w.uv1_world_triplanar = true
		w.uv1_scale = Vector3(1, 1, 1) / 7.0
		walls.append(w)
	var shops := [mat(Color(0.6, 0.65, 0.7), 0.1, 0.5), mat(Color(0.25, 0.3, 0.32), 0.1, 0.5)]
	var roof := mat(Color(0.35, 0.33, 0.3), 0.8)
	for side: float in [-1.0, 1.0]:
		var z := 30.0
		while z > -960.0:
			var depth := rng.randf_range(14.0, 26.0)
			if side > 0.0 and z < -880.0:
				break  # the park on the right
			var h := rng.randf_range(10.0, 40.0)
			if rng.randf() < 0.15:
				h = rng.randf_range(50.0, 85.0)
			var cz := z - depth / 2.0
			var x := side * (14.0 + 11.0)
			box(Vector3(22, h, depth), Vector3(x, h / 2.0, cz), walls[rng.randi() % walls.size()])
			box(Vector3(0.1, 2.8, depth - 1.5), Vector3(side * 13.98, 1.6, cz), shops[rng.randi() % 2])
			box(Vector3(4, 2, 4), Vector3(side * 22.0, h + 1.0, cz), roof)
			z -= depth
			if rng.randf() < 0.25:
				z -= 4.0
	# streetlights, off in the day, and a few planters choked with sand
	var pole := mat(Color(0.25, 0.25, 0.27), 0.5, 0.6)
	var z2 := 10.0
	while z2 > -960.0:
		for side: float in [-1.0, 1.0]:
			cyl(0.08, 0.1, 6.5, Vector3(side * 8.6, 3.25, z2), pole, 6)
			box(Vector3(1.6, 0.1, 0.12), Vector3(side * 7.9, 6.4, z2), pole)
		z2 -= 30.0
	# people on the sidewalks, going about it
	for i in 26:
		var side := -1.0 if i % 2 == 0 else 1.0
		var fz := rng.randf_range(-900, 0)
		if fz < -590.0 and fz > -710.0:
			continue
		var f := figure(Color(rng.randf(), rng.randf(), rng.randf()) * 0.5, Color(0.8, 0.62, 0.48) * rng.randf_range(0.5, 1.1), {"visor": true})
		f.position = Vector3(side * rng.randf_range(9.2, 12.5), 0.08, fz)
		f.rotation.y = rng.randf() * TAU
		add_child(f)


## A broken signal over the intersection, every lamp lit at once, and a
## delivery van stalled in the middle with its hazards on.
func _stoplight() -> void:
	var z := -200.0
	var pole := mat(Color(0.2, 0.2, 0.22), 0.5, 0.6)
	cyl(0.14, 0.18, 7.0, Vector3(9.0, 3.5, z), pole, 8)
	box(Vector3(9.5, 0.25, 0.25), Vector3(4.4, 6.8, z), pole)
	for k in 2:
		var x := 2.4 - k * 4.8
		box(Vector3(0.45, 1.3, 0.35), Vector3(x, 6.1, z), mat(Color(0.08, 0.08, 0.08), 0.6))
		for j in 3:
			var c: Color = [Color(1, 0.1, 0.05), Color(1, 0.75, 0.1), Color(0.2, 1, 0.4)][j]
			var gm := newglow(c, 3.0)
			box(Vector3(0.26, 0.26, 0.05), Vector3(x, 6.5 - j * 0.38, z + 0.19), gm)
			signals.append(gm)
	# the cross street
	var asphalt := mat(Color(0.22, 0.22, 0.23), 0.6)
	floor_quad(Vector2(80, 14), Vector3(0, 0.005, z - 9.0), 0.0, asphalt)
	var van := Node3D.new()
	van.position = Vector3(-4.0, 0, z - 9.0)
	van.rotation.y = PI / 2.0 + 0.25
	add_child(van)
	box(Vector3(2.1, 2.2, 5.0), Vector3(0, 1.3, 0), mat(Color(0.85, 0.85, 0.82), 0.4), false, van)
	label("VOLTX DELIVERY", Vector3(1.06, 1.6, 0), PI / 2.0, 0.008, Color(0.1, 0.4, 0.2), van, false)
	for x: float in [-0.9, 0.9]:
		var hz := newglow(Color(1.0, 0.6, 0.1), 3.0)
		box(Vector3(0.2, 0.15, 0.05), Vector3(x, 0.8, 2.52), hz, false, van)
		box(Vector3(0.2, 0.15, 0.05), Vector3(x, 0.8, -2.52), hz, false, van)
		hazards.append(hz)


func _workers() -> void:
	# a crew on a scissor lift, opening a streetlight, and two more sweeping sand
	var lift := Node3D.new()
	lift.position = Vector3(-8.0, 0, -330.0)
	add_child(lift)
	var yel := mat(Color(0.9, 0.7, 0.1), 0.5, 0.3)
	box(Vector3(1.4, 0.6, 2.6), Vector3(0, 0.4, 0), yel, false, lift)
	for k in 4:
		var s := box(Vector3(0.08, 1.6, 0.08), Vector3(0, 1.2 + k * 1.1, 0), mat(Color(0.3, 0.3, 0.3), 0.5, 0.7), false, lift)
		s.rotation.x = 0.9 if k % 2 == 0 else -0.9
	box(Vector3(1.4, 0.1, 2.6), Vector3(0, 5.6, 0), yel, false, lift)
	box(Vector3(1.4, 0.9, 0.05), Vector3(0, 6.1, 1.3), yel, false, lift)
	var vis := mat(Color(0.75, 0.95, 0.15), 0.6)
	var w1 := figure(Color(0.75, 0.95, 0.15), Color(0.6, 0.42, 0.3), {"arms": true})
	w1.position = Vector3(0, 5.65, 0.3)
	w1.rotation.y = PI / 2.0
	lift.add_child(w1)
	for a in w1.get_meta("arms"):
		(a as Node3D).rotation.x = -2.6
	for k in 2:
		var w := figure(Color(0.75, 0.95, 0.15), Color(0.8, 0.62, 0.48) * (0.7 + k * 0.3), {"arms": true})
		w.position = Vector3(9.5 + k * 1.6, 0.08, -455.0 - k * 3.0)
		w.rotation.y = -PI / 2.0
		add_child(w)
		cyl(0.02, 0.02, 1.3, Vector3(9.0 + k * 1.6, 0.7, -455.0 - k * 3.0), vis, 5).rotation.z = 0.5
		workers.append(w)
	var cone := mat(Color(1.0, 0.4, 0.1), 0.6)
	for k in 4:
		cyl(0.02, 0.18, 0.6, Vector3(-6.5, 0.3, -322.0 - k * 5.0), cone, 8)


## "A futuristic haven, a technological paradise": the old poster, peeling.
func _billboard() -> void:
	var z := -485.0
	var pole := mat(Color(0.3, 0.3, 0.3), 0.5, 0.6)
	cyl(0.3, 0.3, 8.0, Vector3(-11.0, 4.0, z), pole, 8)
	var board := mat(Color(0.82, 0.76, 0.62), 0.9)
	var b := box(Vector3(0.3, 7.0, 16.0), Vector3(-10.6, 9.5, z), board)
	b.rotation.y = 0.35
	var root := Node3D.new()
	root.position = Vector3(-10.4, 9.5, z)
	root.rotation.y = PI / 2.0 + 0.35
	add_child(root)
	var l := label("SILICO", Vector3(0, 1.6, 0), 0.0, 0.03, Color(0.15, 0.4, 0.45), root, false)
	l.font_size = 120
	label("A TECHNOLOGICAL PARADISE", Vector3(0, -0.3, 0), 0.0, 0.016, Color(0.55, 0.25, 0.15), root, false)
	label("where AI solves every problem", Vector3(0, -1.6, 0), 0.0, 0.012, Color(0.3, 0.3, 0.3), root, false)
	var peel := mat(Color(0.3, 0.27, 0.22), 0.95)
	for i in 9:
		var q := quad(Vector2(rng.randf_range(0.8, 2.5), rng.randf_range(0.6, 2.0)), Vector3(rng.randf_range(-7, 7), rng.randf_range(-3, 3), 0.02), 0.0, peel, root)
		q.rotation.z = rng.randf_range(-0.4, 0.4)


## A block with the power out: dark shopfronts, and people in the doorways
## who turn to watch the car go by.
func _outage_block() -> void:
	var dead := mat(Color(0.05, 0.05, 0.06), 0.2, 0.4)
	for side: float in [-1.0, 1.0]:
		box(Vector3(0.12, 2.8, 110.0), Vector3(side * 13.9, 1.6, -650.0), dead)
	for i in 8:
		var side := -1.0 if i % 2 == 0 else 1.0
		var f := figure(Color(0.2, 0.2, 0.22) * rng.randf_range(0.5, 1.5), Color(0.75, 0.58, 0.45) * rng.randf_range(0.5, 1.1), {"visor": true})
		f.position = Vector3(side * rng.randf_range(10.0, 12.8), 0.08, -605.0 - i * 12.0)
		add_child(f)
		watchers.append(f)
	var sign := label("POWER OUTAGE - VOLTX CREW DISPATCHED - ETA UNKNOWN", Vector3(13.8, 3.6, -640.0), -PI / 2.0, 0.008, Color(1.0, 0.7, 0.2), self, false)
	sign.double_sided = true


func _park_edge() -> void:
	var hedge := mat(Color(0.22, 0.34, 0.16), 0.9)
	box(Vector3(1.2, 1.4, 90), Vector3(14.5, 0.7, -935.0), hedge)
	var bark := tex_mat(Tex.bark(), Vector3(1, 2, 1), 0.9)
	var leaf := mat(Color(0.25, 0.38, 0.17), 0.9)
	for i in 7:
		var p := Vector3(rng.randf_range(18, 40), 0, -895.0 - i * 13.0)
		cyl(0.3, 0.45, 6.0, p + Vector3(0, 3.0, 0), bark, 8)
		sphere(3.4, p + Vector3(0, 7.5, 0), leaf, 10)
		sphere(2.6, p + Vector3(1.5, 6.4, 1.0), leaf, 8)
	var post := mat(Color(0.3, 0.3, 0.32), 0.4, 0.6)
	box(Vector3(0.2, 2.5, 0.2), Vector3(13.6, 1.25, -905.0), post)
	var l := label("HARMONY GREEN\nTranquility Zone", Vector3(13.45, 2.2, -905.0), -PI / 2.0, 0.006, Color(0.2, 0.5, 0.3), self, false)
	l.double_sided = true
	floor_quad(Vector2(12, 30), Vector3(9.0, 0.09, -935.0), 0.0, mat(Color(0.3, 0.3, 0.3), 0.7))


func _tower() -> void:
	var jade := mat(Color(0.2, 0.45, 0.38), 0.3, 0.7)
	var silver := mat(Color(0.7, 0.72, 0.75), 0.25, 0.8)
	var tp := Vector3(240, 0, -1500)
	cyl(50, 56, 36, tp + Vector3(0, 18, 0), jade, 24)
	cyl(16, 30, 440, tp + Vector3(0, 256, 0), jade, 16)
	var tm := TorusMesh.new()
	tm.inner_radius = 58
	tm.outer_radius = 108
	tm.rings = 32
	tm.ring_segments = 12
	mesh(tm, tp + Vector3(0, 540, 0), silver)


# ------------------------------------------------------------------ the car

func _car() -> void:
	car = Node3D.new()
	car.position = Vector3(LANE_X, 0, 10.0)
	add_child(car)
	var trim := mat(Color(0.12, 0.12, 0.13), 0.6)
	var paint := mat(Color(0.75, 0.78, 0.8), 0.25, 0.6)
	# hood, dash, wheel, pillars, roof, doors
	box(Vector3(1.9, 0.25, 1.8), Vector3(0, 0.75, -1.9), paint, false, car)
	box(Vector3(1.7, 0.22, 0.55), Vector3(0, 0.88, -0.75), trim, false, car)
	box(Vector3(1.7, 0.06, 0.3), Vector3(0, 1.0, -0.62), mat(Color(0.18, 0.18, 0.2), 0.5), false, car)
	var wheel := TorusMesh.new()
	wheel.inner_radius = 0.15
	wheel.outer_radius = 0.18
	wheel.rings = 20
	wheel.ring_segments = 6
	var wm := mesh(wheel, Vector3(SEAT.x, 0.98, -0.42), trim, car)
	wm.rotation.x = PI / 2.0 - 0.45
	box(Vector3(0.04, 0.04, 0.3), Vector3(SEAT.x, 0.93, -0.55), trim, false, car)
	for x: float in [-0.82, 0.82]:
		stick(Vector3(x, 0.98, -0.95), Vector3(x, 1.8, -0.2), 0.035, trim, car)
		stick(Vector3(x, 0.98, 0.85), Vector3(x, 1.8, 0.65), 0.04, trim, car)
		box(Vector3(0.06, 0.06, 0.9), Vector3(x, 1.8, 0.22), trim, false, car)
		box(Vector3(0.08, 0.5, 2.0), Vector3(x * 1.02, 0.7, 0.0), mat(Color(0.2, 0.2, 0.22), 0.7), false, car)
	box(Vector3(1.7, 0.05, 0.9), Vector3(0, 1.82, 0.22), mat(Color(0.25, 0.25, 0.26), 0.9), false, car)
	box(Vector3(1.7, 0.6, 0.1), Vector3(0, 1.0, 1.0), trim, false, car)
	# the fleet screen in the dash, and the microphone that is never off
	dash_m = newglow(Color(0.25, 0.55, 0.5), 1.0)
	var scr := quad(Vector2(0.3, 0.17), Vector3(0.12, 1.06, -0.6), 0.0, dash_m, car)
	scr.rotation.x = -0.5
	dash_label = label("PSYONIC FLEET 0086\nNAV: HARMONY GREEN\n8 MIN", Vector3(0.12, 1.06, -0.592), 0.0, 0.00045, Color(0.05, 0.08, 0.08), car, false)
	dash_label.rotation.x = -0.5
	dash_label.font_size = 48
	var mic := box(Vector3(0.02, 0.02, 0.01), Vector3(-0.05, 1.04, -0.6), glow(Color(1, 0.1, 0.1), 3.0), false, car)
	mic.rotation.x = -0.5
	label("MIC", Vector3(-0.05, 1.065, -0.597), 0.0, 0.00025, Color(0.6, 0.15, 0.1), car, false).rotation.x = -0.5


# ------------------------------------------------------------------ the drive

func intro() -> void:
	_run()


func _cap(text: String, secs: float) -> void:
	await main.ui.caption(text, secs)


func _until(z: float) -> void:
	while car.position.z > z:
		await get_tree().process_frame


func _run() -> void:
	var p = main.player
	p.seated = true
	p.crouch = 0.5
	await get_tree().create_timer(1.0).timeout
	await _cap("I sat and stared forward at my steering wheel for a while, thinking about that last AI image.", 4.5)
	await _cap("My memory shifted to Dufredy's eyes, lazily lying on his bedroom floor. I was grateful I didn't eat a large lunch, or I would've contaminated the scene.", 5.5)
	await _cap("A custom Psyon model could be difficult to deal with, but I've done it before. But how the fuck did it know my name?", 5.0)
	want_speed = 14.0
	await _until(-40.0)
	await _cap("Driving through the streets of Silico almost filled me with purpose, but it was always tempered by the broken promises and lies that led two million souls to reside here.", 6.5)
	await _until(-140.0)
	await _cap("A city whose core infrastructure was coordinated by AI systems that were breaking at the seams.", 4.5)
	await _until(STOP_Z + 30.0)
	want_speed = 0.0
	await _until(STOP_Z + 2.0)
	await _cap("The AI that was supposed to manage everything now can barely keep the stoplights working.", 4.5)
	await _cap("Corporate leadership promised the outages would be resolved. They never were.", 3.5)
	want_speed = 14.0
	await _until(-300.0)
	await _cap("Nearly all the automated systems needed constant maintenance. Citizens and workers adapted.", 4.5)
	await _cap("It's funny in a way. AI took most jobs and turned everyone into janitors or, in my case, a babysitter. Maintenance work is the largest employer in the city.", 6.5)
	await _until(-455.0)
	await _cap("I moved here when I was 13. I remember reading about the construction of this city as a kid in corporate training. A futuristic haven. A technological paradise for the tech oligarchs and crypto billionaires to play without the rules of California.", 8.0)
	await _cap("A mechanical marvel in the middle of the New Mexican desert. That bit of propaganda sealed my fate. My parents took the bait, and bought it before the rug pull that always came.", 7.0)
	await _until(-600.0)
	await _cap("Power outages and computational breakdowns plagued the city most days. People were antsy. Corporate distrust was on the rise. This incident wouldn't help.", 6.0)
	_dash_glitch()
	await _until(-720.0)
	await _cap("I do need to remind myself that this rot is the reason I have a job. Psyonic would never have an AI integration investigator if the product worked as promised.", 6.5)
	await _until(-870.0)
	want_speed = 0.0
	await _until(END_Z + 3.0)
	await _cap("I parked in the lot next to the park. One of the few consistently inhabited places in Silico. Workers fought off the desert sand, and a hefty dose of climate control kept it at a peaceful 72 degrees, year round.", 7.0)
	_done = true
	main.flags["drive_done"] = true
	if not main._selftest:
		main.load_level("Park")


func _dash_glitch() -> void:
	await get_tree().create_timer(2.5).timeout
	main.play("glitch", -6.0)
	for i in 6:
		dash_m.emission = Color(0.6, 0.05, 0.05) if i % 2 == 0 else Color(0.25, 0.55, 0.5)
		dash_label.text = "Welcome, dreamer." if i % 2 == 0 else "PSYONIC FLEET 0086\nNAV: HARMONY GREEN\n3 MIN"
		await get_tree().create_timer(0.12).timeout
	dash_m.emission = Color(0.6, 0.05, 0.05)
	dash_label.text = "Welcome, dreamer."
	main.play("ding", -10.0, 0.9)
	await get_tree().create_timer(1.6).timeout
	dash_m.emission = Color(0.25, 0.55, 0.5)
	dash_label.text = "PSYONIC FLEET 0086\nNAV: HARMONY GREEN\n3 MIN"
	await _cap("The fleet screen flickered. For a second I could have sworn it said something else.", 4.0)


func tick(delta: float) -> void:
	if not car or not main or not main.player:
		return
	# ease toward the wanted speed; brake to land on the stop lines
	var target := want_speed
	if want_speed == 0.0 and speed > 0.0:
		var stop_at := STOP_Z if car.position.z > STOP_Z else END_Z
		var dist := car.position.z - stop_at
		target = clampf(dist * 0.6, 0.0, 14.0)
	speed = move_toward(speed, target, delta * 5.0)
	car.position.z -= speed * delta
	car.position.y = sin(_t * 9.0) * 0.004 * minf(1.0, speed / 6.0)
	main.player.position = car.position + SEAT
	if _engine:
		_engine.pitch_scale = 0.7 + speed / 14.0 * 0.6
		_engine.volume_db = -20.0 + speed / 14.0 * 8.0
	# the broken signal: every lamp at once, stuttering
	for i in signals.size():
		(signals[i] as StandardMaterial3D).emission_energy_multiplier = 3.0 if randf() < 0.6 else 0.1
	var on := fmod(_t, 1.0) < 0.5
	for h in hazards:
		(h as StandardMaterial3D).emission_energy_multiplier = 3.0 if on else 0.0
	# in the dark block they watch the car go by
	for w in watchers:
		var d: Vector3 = main.player.global_position - (w as Node3D).global_position
		if d.length() < 45.0:
			(w as Node3D).rotation.y = lerp_angle((w as Node3D).rotation.y, atan2(-d.x, -d.z), delta * 3.0)
	for w in workers:
		var arms: Array = (w as Node3D).get_meta("arms")
		arms[0].rotation.x = -0.6 + sin(_t * 3.0) * 0.4
		arms[1].rotation.x = -0.6 + sin(_t * 3.0) * 0.4


func objective() -> String:
	return "Look around. The car drives itself."


func phone() -> String:
	return "[color=#7fe6b0]Psyon:[/color] Route to Harmony Green. Traffic signals on your route are experiencing intermittent faults. Please remain patient.\n\n"


func selftest() -> void:
	_run()
	while not _done:
		await get_tree().process_frame
	print("ok drive")


func apply_args(a: Dictionary) -> void:
	if a.has("carz"):
		car.position.z = float(a["carz"])
		main.player.position = car.position + SEAT
	main.player.seated = true
	main.player.crouch = 0.5
