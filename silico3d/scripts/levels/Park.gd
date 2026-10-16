extends "res://scripts/Level.gd"
## Chapters 1 and 2: Harmony Green, the afternoon after. Book: crowds at the
## police tape, the trail of blood to Dufredy's "pulpit", kids running tight
## circles on the playground, adults clutching paper coffee cups. Old trees
## with peeling bark, yellowing grass, benches with half-broken charging
## ports and wires like dead nerves, a rusted drone pole hissing static by
## the sandbox, a dead water feature playing "Welcome to Harmony Green -
## breathe easy, live smart!" off-key, a smart bin with a circle sprayed on
## it. The gruff cop. Agata Greenwood on the bench. Seth McCarren vacuuming
## sand from the ports by the entrance. Beyond the retaining wall, Tyson
## Clerif's clean, ornate tent, and red rings on the alley wall.
##
## Layout (metres): the car park is south (+Z), the entrance at z 34, the
## fountain at the origin, the retaining wall along z -32 with a gap at
## x 14..20 into the alley behind it (z -33..-44).

const STAIN := Vector3(5.2, 0.0, -6.0)
const WALL_Z := -32.0
const GAP := Vector2(14.0, 20.0)
const TRAIL := [Vector3(17.0, 0, -33.5), Vector3(15.5, 0, -27.0), Vector3(12.0, 0, -19.0),
	Vector3(8.5, 0, -12.0), Vector3(6.6, 0, -8.6), STAIN]

var cop: Node3D
var agata: Node3D
var seth: Node3D
var tyson: Node3D
var masked: Node3D
var onlookers: Array = []
var kids: Array = []
var bin_lid: Node3D
var barrier: Node3D
var corner_glyph: Area3D
var ghost: Node3D
var _jingle_t := 20.0
var _jingle: AudioStreamPlayer3D
var _masked_look := 0.0
var _ended := false
var photos := {}


func build(m: Node) -> void:
	main = m
	rng.seed = 72
	spawn = Vector3(4.0, 0.05, 44.0)
	spawn_yaw = 0.0
	step_db = -20.0
	card = "[b]HARMONY GREEN[/b]\n\n[color=#aaaaaa]the park where he gave his sermon[/color]"
	_ground()
	_surrounds()
	_plaza()
	_benches()
	_trees()
	_playground()
	_scene_of_it()
	_wall_and_alley()
	_people()
	_batch(self, 12.0, true)
	_bounds()


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	var psm := ProceduralSkyMaterial.new()
	psm.sky_top_color = Color(0.38, 0.47, 0.6)
	psm.sky_horizon_color = Color(0.92, 0.66, 0.42)
	psm.ground_horizon_color = Color(0.8, 0.58, 0.38)
	psm.ground_bottom_color = Color(0.3, 0.26, 0.2)
	psm.sun_angle_max = 25.0
	env.sky.sky_material = psm
	env.glow_bloom = 0.0  # bloom on a sunlit frame greys out every shadow
	env.glow_intensity = 0.7
	env.ambient_light_color = Color(0.66, 0.66, 0.6)
	env.ambient_light_energy = 0.48
	env.fog_light_color = Color(0.88, 0.64, 0.42)
	env.fog_density = 0.0034
	env.fog_sky_affect = 0.15
	env.tonemap_exposure = 1.0
	env.glow_hdr_threshold = 1.2
	sun.light_color = Color(1.0, 0.86, 0.66)
	sun.light_energy = 1.2
	sun.sky_mode = DirectionalLight3D.SKY_MODE_LIGHT_AND_SKY
	sun.rotation = Vector3(deg_to_rad(-62), deg_to_rad(205), 0)
	sun.directional_shadow_max_distance = 70.0


func ambience() -> void:
	main.loop("wind", -16.0)
	main.loop("murmur", -2.0, STAIN + Vector3(0, 1.4, 5.0), 5.0, 45.0)
	main.loop("static", -8.0, Vector3(-14.0, 3.5, 14.0), 2.0, 16.0)
	main.loop("vacuum", -10.0, Vector3(6.9, 0.4, 28.4), 2.0, 18.0)
	_jingle = AudioStreamPlayer3D.new()
	_jingle.stream = main.sfx["jingle"]
	_jingle.position = Vector3(0, 2.0, 0)
	_jingle.unit_size = 8.0
	_jingle.max_distance = 70.0
	_jingle.volume_db = -2.0
	add_child(_jingle)


# ------------------------------------------------------------------ the park

func _ground() -> void:
	var grass := pbr("grass", Vector3(1, 1, 1) / 2.5, true, Color(0.95, 0.9, 0.7))
	floor_quad(Vector2(80, 70), Vector3(0, 0, 0), 0.0, grass)
	solid_box(Vector3(200, 2, 200), Vector3(0, -1, 0))
	var path := pbr("concrete", Vector3(1, 1, 1) / 3.0, true)
	floor_quad(Vector2(3.2, 34), Vector3(0, 0.01, 17.0), 0.0, path)
	var path2 := path
	floor_quad(Vector2(60, 3.0), Vector3(0, 0.01, -2.0), 0.0, path2)
	var path3 := path
	floor_quad(Vector2(3.0, 28), Vector3(10.0, 0.011, -17.0), -0.35, path3)
	var plaza := pbr("paving", Vector3(1, 1, 1) / 2.5, true)
	var pm := CylinderMesh.new()
	pm.top_radius = 10.0
	pm.bottom_radius = 10.0
	pm.height = 0.04
	pm.radial_segments = 32
	mesh(pm, Vector3(0, 0.02, 0), plaza)
	# the car park
	var asphalt := pbr("asphalt", Vector3(1, 1, 1) / 4.0, true)
	floor_quad(Vector2(40, 22), Vector3(4, 0.0, 47.0), 0.0, asphalt)
	var line := mat(Color(0.85, 0.82, 0.7), 0.7)
	for k in 8:
		box(Vector3(0.12, 0.01, 5.0), Vector3(-10.0 + k * 4.0, 0.01, 41.5), line)
	_car(Vector3(6.0, 0, 46.0), 0.0, Color(0.75, 0.78, 0.8), true)
	_car(Vector3(-6.0, 0, 46.5), 0.05, Color(0.3, 0.06, 0.08), false)
	_car(Vector3(14.0, 0, 46.0), -0.04, Color(0.92, 0.92, 0.94), false, {"police": true})
	# a hedge with the entrance gap, and the sign
	var hedge := mat(Color(0.24, 0.35, 0.17), 0.9)
	box(Vector3(30, 1.2, 1.0), Vector3(-18.0, 0.6, 34.5), hedge, true)
	box(Vector3(30, 1.2, 1.0), Vector3(18.0, 0.6, 34.5), hedge, true)
	var post := mat(Color(0.3, 0.3, 0.32), 0.4, 0.6)
	box(Vector3(0.15, 2.4, 0.15), Vector3(-2.6, 1.2, 34.6), post)
	var sign := label("HARMONY GREEN\nTranquility Zone", Vector3(-2.6, 2.0, 34.75), 0.0, 0.006, Color(0.15, 0.45, 0.25), self, false)
	sign.double_sided = true
	interactable("sign", "Read the sign", Vector3(-2.6, 2.0, 34.6), Vector3(1.6, 0.8, 0.3),
		"HARMONY GREEN - TRANQUILITY ZONE\nclimate: 72F (HELD)\nsand filtration: DEGRADED")
	# climate control masts at the corners, misting
	for p: Vector3 in [Vector3(-33, 0, 30), Vector3(33, 0, 30), Vector3(-33, 0, -28)]:
		cyl(0.25, 0.35, 8.0, p + Vector3(0, 4, 0), post, 8)
		box(Vector3(1.2, 0.6, 1.2), p + Vector3(0, 8.2, 0), mat(Color(0.8, 0.8, 0.78), 0.4, 0.3))
	interactable("climate", "Look at the climate mast", Vector3(33, 4, 30), Vector3(1.2, 8, 1.2),
		"CLIMATE CONTROL MAST 2\noutput: 72F\nload: 140%\nsand intake: CLOGGED")


func _car(pos: Vector3, rot: float, c: Color, mine: bool, opts := {}) -> void:
	var car := Node3D.new()
	car.position = pos
	car.rotation.y = rot
	add_child(car)
	opts["plate"] = "PSF 0086" if mine else ""
	car.add_child(Car.build(self, c, opts))
	solid_box(Vector3(1.9, 1.5, 4.5), Vector3(0, 0.75, 0), car)
	if mine:
		var it := interactable("my_car", "Your company car", Vector3(0, 1.0, 0), Vector3(2.0, 1.8, 4.6),
			"PSYONIC FLEET 0086\ndriver: DRAKE, C.\nmicrophone: ALWAYS ON", false, car)
		it.set_meta("exit", true)


func _surrounds() -> void:
	# The city crowding the park on three sides: the tranquility zone is a
	# courtyard at the bottom of a canyon of ads. Built into its own node so
	# it batches in big pieces.
	var city := Node3D.new()
	add_child(city)
	kit_parent = city
	for side: float in [-1.0, 1.0]:
		var z := 66.0
		while z > -62.0:
			var d := rng.randf_range(14, 24)
			var h := rng.randf_range(22, 60) if rng.randf() > 0.25 else rng.randf_range(70, 120)
			cyber_block(Vector3(side * 41.0, 0, z - d / 2.0), -side * PI / 2.0, d, h, 18.0, true)
			z -= d
	var x2 := -41.0
	while x2 < 41.0:
		var w := rng.randf_range(12, 20)
		var h := rng.randf_range(24, 64) if rng.randf() > 0.3 else rng.randf_range(70, 110)
		cyber_block(Vector3(x2 + w / 2.0, 0, -46.0), 0.0, w, h, 16.0, true)
		x2 += w
	x2 = -41.0
	while x2 < 41.0:
		var w := rng.randf_range(12, 20)
		cyber_block(Vector3(x2 + w / 2.0, 0, 64.0), PI, w, rng.randf_range(20, 70), 16.0, true)
		x2 += w
	skybridge(Vector3(-41.0, 34.0, -20.0), Vector3(-41.0, 30.0, 20.0), 3.5)
	kit_holo(Vector3(-14.0, 12.5, -36.0), 0.0, "HARMONY GREEN", "breathe easy, live smart", Color(0.3, 1.0, 0.6), 20.0)
	kit_holo(Vector3(36.0, 26.0, 10.0), -PI / 2.0, "PSYON", "the pillow for those who dream", Color(0.4, 0.9, 1.0), 16.0)
	kit_holo(Vector3(-36.0, 24.0, -12.0), PI / 2.0, "ORA", "always watching over you", Color(1.0, 0.3, 0.7), 14.0)
	for i in 10:
		var z := rng.randf_range(-40, 60)
		cable(Vector3(-40.9, rng.randf_range(14, 24), z), Vector3(-40.9 + rng.randf_range(2, 6), rng.randf_range(10, 16), z + rng.randf_range(-6, 6)), 0.4)
	kit_parent = self
	_batch(city, 40.0, true)
	var traffic = preload("res://scripts/Traffic.gd").new()
	traffic.lanes = [[-34.0, 24.0, 1.0], [-30.0, 30.0, -1.0], [34.0, 24.0, -1.0], [30.0, 30.0, 1.0]]
	traffic.s_min = -90.0
	traffic.s_max = 90.0
	traffic.count = 12
	traffic.tower_top = Vector3(230, 540, -520)
	traffic.drone_box = AABB(Vector3(-200, 30, -150), Vector3(400, 90, 300))
	traffic.drone_count = 160
	add_child(traffic)
	traffic.setup(main, self)
	var jade := mat(Color(0.2, 0.45, 0.38), 0.3, 0.7)
	var silver := mat(Color(0.7, 0.72, 0.75), 0.25, 0.8)
	var tp := Vector3(230, 0, -520)
	cyl(50, 56, 36, tp + Vector3(0, 18, 0), jade, 24)
	cyl(16, 30, 440, tp + Vector3(0, 256, 0), jade, 16)
	var tm := TorusMesh.new()
	tm.inner_radius = 58
	tm.outer_radius = 108
	tm.rings = 32
	tm.ring_segments = 12
	mesh(tm, tp + Vector3(0, 540, 0), silver)


func _plaza() -> void:
	# the water feature: dry for years, still singing
	var stone := mat(Color(0.62, 0.6, 0.56), 0.8)
	var ring := CylinderMesh.new()
	ring.top_radius = 2.6
	ring.bottom_radius = 2.7
	ring.height = 0.6
	ring.radial_segments = 24
	mesh(ring, Vector3(0, 0.3, 0), stone)
	cyl(2.35, 2.35, 0.05, Vector3(0, 0.58, 0), mat(Color(0.5, 0.45, 0.35), 1.0), 24)
	solid_box(Vector3(5.0, 0.6, 5.0), Vector3(0, 0.3, 0))
	cyl(0.3, 0.4, 2.2, Vector3(0, 1.1, 0), stone, 12)
	box(Vector3(0.35, 0.35, 0.35), Vector3(0, 2.35, 0), mat(Color(0.3, 0.3, 0.32), 0.4, 0.7))
	interactable("fountain", "Look at the water feature", Vector3(0, 1.2, 0), Vector3(5.0, 2.4, 5.0),
		"WATER FEATURE 1\nwater: NONE (SINCE 2031)\naudio: PLAYING\nvolume: CANNOT BE SET")
	# the smart bin, a circle sprayed over it, the lid flapping at nothing
	var bp := Vector3(8.5, 0, 5.5)
	box(Vector3(0.6, 1.0, 0.6), bp + Vector3(0, 0.5, 0), mat(Color(0.25, 0.4, 0.3), 0.5, 0.4), true)
	bin_lid = Node3D.new()
	bin_lid.position = bp + Vector3(0, 1.0, -0.3)
	add_child(bin_lid)
	box(Vector3(0.62, 0.05, 0.62), Vector3(0, 0.0, 0.31), mat(Color(0.2, 0.32, 0.25), 0.5, 0.4), false, bin_lid)
	no_batch.append(bin_lid.get_child(0))
	interactable("bin", "Look at the smart bin", bp + Vector3(0, 0.5, 0), Vector3(0.7, 1.0, 0.7),
		"SMART BIN 3\nsensor: CONFUSED BY SHADOWS\nlid cycles today: 4,112", true)
	var g := _glyph_on(bp + Vector3(0, 0.55, 0.31), 0.0, 0.004, "g_bin", false, true,
		"Someone had spray-painted a crude circular symbol over the smart trash bin. Two rings. A dot where a pupil would be. The paint had run.")
	g.position.z += 0.01


func _benches() -> void:
	var wood := tex_mat(Tex.wood(), Vector3(3, 1, 1), 0.8)
	var steel := mat(Color(0.32, 0.22, 0.16), 0.7, 0.5)
	var wire := mat(Color(0.08, 0.08, 0.08), 0.6)
	var spots := [[Vector3(-7.0, 0, -1.0), -PI / 2.0], [Vector3(6.6, 0, 28.0), PI / 2.0], [Vector3(-6.6, 0, 22.0), -PI / 2.0],
		[Vector3(12.5, 0, -9.0), -2.4], [Vector3(-3.5, 0, 9.5), PI], [Vector3(11.0, 0, 2.0), -PI / 2.0], [Vector3(-12.0, 0, -6.0), PI / 2.4]]
	for i in spots.size():
		var p: Vector3 = spots[i][0]
		var r: float = spots[i][1]
		var b := Node3D.new()
		b.position = p
		b.rotation.y = r
		add_child(b)
		box(Vector3(1.8, 0.06, 0.45), Vector3(0, 0.45, 0), wood, false, b)
		box(Vector3(1.8, 0.4, 0.05), Vector3(0, 0.75, 0.22), steel, false, b)
		for x: float in [-0.8, 0.8]:
			box(Vector3(0.06, 0.45, 0.4), Vector3(x, 0.22, 0), steel, false, b)
		# charging ports in the arm; half of them broken, wires hanging out
		box(Vector3(0.12, 0.08, 0.1), Vector3(0.85, 0.52, -0.1), mat(Color(0.15, 0.15, 0.15), 0.4, 0.6), false, b)
		if i % 2 == 1:
			for k in 3:
				var a := Vector3(0.88, 0.5, -0.12 + k * 0.03)
				stick(a, a + Vector3(rng.randf_range(0.0, 0.08), -rng.randf_range(0.2, 0.42), rng.randf_range(-0.05, 0.05)), 0.006, wire, b)
		solid_box(Vector3(1.8, 0.9, 0.5), Vector3(0, 0.45, 0), b)
		if i >= 3:
			interactable("bench", "Look at the bench", Vector3(0, 0.6, 0), Vector3(1.8, 0.6, 0.5),
				"BENCH %d\ncharging: %s\nsand in ports: YES" % [i + 2, "FAULT" if i % 2 == 1 else "OK"], false, b)
	# Seth's bench by the entrance: black spray on rusted steel
	var g := _glyph_on(Vector3(6.6 + 0.25, 0.78, 28.0), PI / 2.0, 0.0028, "g_bench", false, true,
		"The graffiti on the back of the bench by the entrance. Circular, like a tire tread, but wrong. Too narrow in some places, too wide in others. Uneven rings, layered with intention.")
	(g.get_meta("sprite") as Sprite3D).modulate = Color(0.05, 0.05, 0.05)
	g.position.x += 0.04


func _trees() -> void:
	var bark := pbr("bark", Vector3(1, 1, 1) / 1.5, true)
	var leaves := [mat(Color(0.28, 0.4, 0.17), 0.9), mat(Color(0.36, 0.42, 0.18), 0.9), mat(Color(0.25, 0.33, 0.15), 0.9)]
	var spots := [Vector3(-13, 0, -14), Vector3(-22, 0, -20), Vector3(20, 0, 12), Vector3(24, 0, -4),
		Vector3(-26, 0, 0), Vector3(16, 0, 24), Vector3(-18, 0, 26), Vector3(26, 0, -20), Vector3(-6, 0, -22)]
	for i in spots.size():
		var p: Vector3 = spots[i]
		var h := rng.randf_range(5.5, 8.0)
		solid_box(Vector3(0.9, h, 0.9), p + Vector3(0, h / 2.0, 0))
		tree(p, h, bark, leaves)
	# the tree by the wall: the lower branches snapped off, clean, dozens
	var ct := Vector3(-6, 0, -22)
	for k in 14:
		var a := k * TAU / 14.0 + rng.randf_range(-0.1, 0.1)
		var y := rng.randf_range(1.7, 2.3)
		var s := ct + Vector3(cos(a) * 0.4, y, sin(a) * 0.4)
		stick(s, s + Vector3(cos(a) * 0.12, 0.03, sin(a) * 0.12), 0.035, bark)
		box(Vector3(0.05, 0.05, 0.01), s + Vector3(cos(a) * 0.12, 0.03, sin(a) * 0.12), mat(Color(0.8, 0.72, 0.55), 0.8)).rotation.y = -a
	interactable("cut_tree", "Look at the tree by the wall", ct + Vector3(0, 2.0, 0), Vector3(1.4, 1.2, 1.4),
		"FREMONT COTTONWOOD\nest. age: 41 years\nlimbs missing: 67\nbreaks: CLEAN, 1.7-2.3 m", false)
	interactable("tree", "Look at the old tree", Vector3(-13, 2.0, -14), Vector3(1.4, 4.0, 1.4),
		"FREMONT COTTONWOOD\nest. age: 44 years\nirrigation: MANUAL")


func _playground() -> void:
	var c := Vector3(-20, 0, 8)
	var red := mat(Color(0.6, 0.15, 0.1), 0.6, 0.3)
	var steel := mat(Color(0.5, 0.5, 0.52), 0.4, 0.7)
	# swings
	for x: float in [-1.6, 1.6]:
		var a := stick(c + Vector3(x, 0, -0.9), c + Vector3(x, 2.4, 0), 0.05, red)
		var b := stick(c + Vector3(x, 0, 0.9), c + Vector3(x, 2.4, 0), 0.05, red)
	stick(c + Vector3(-1.6, 2.4, 0), c + Vector3(1.6, 2.4, 0), 0.05, red)
	for x: float in [-0.7, 0.7]:
		stick(c + Vector3(x - 0.2, 2.4, 0), c + Vector3(x - 0.2, 0.55, 0), 0.01, steel)
		stick(c + Vector3(x + 0.2, 2.4, 0), c + Vector3(x + 0.2, 0.55, 0), 0.01, steel)
		box(Vector3(0.5, 0.04, 0.2), c + Vector3(x, 0.55, 0), mat(Color(0.1, 0.1, 0.1), 0.7))
	# slide
	var s := box(Vector3(0.6, 0.05, 3.2), c + Vector3(4.5, 1.0, 3.0), steel)
	s.rotation.x = -0.6
	box(Vector3(0.9, 1.9, 0.9), c + Vector3(4.5, 0.95, 1.2), red, true)
	# sandbox, and the drone pole leaning beside it
	var sb := Vector3(-15.5, 0, 15.5)
	box(Vector3(4, 0.25, 0.2), sb + Vector3(0, 0.12, -2), mat(Color(0.45, 0.35, 0.25)))
	box(Vector3(4, 0.25, 0.2), sb + Vector3(0, 0.12, 2), mat(Color(0.45, 0.35, 0.25)))
	box(Vector3(0.2, 0.25, 4), sb + Vector3(-2, 0.12, 0), mat(Color(0.45, 0.35, 0.25)))
	box(Vector3(0.2, 0.25, 4), sb + Vector3(2, 0.12, 0), mat(Color(0.45, 0.35, 0.25)))
	floor_quad(Vector2(3.8, 3.8), sb + Vector3(0, 0.08, 0), 0.0, mat(Color(0.75, 0.65, 0.45), 1.0))
	var rust := mat(Color(0.42, 0.24, 0.14), 0.8, 0.4)
	var pole_base := Vector3(-14.0, 0, 13.3)
	var top := pole_base + Vector3(0.6, 4.6, 0.3)
	stick(pole_base, top, 0.08, rust)
	box(Vector3(0.5, 0.35, 0.35), top + Vector3(0, 0.1, 0), rust)
	box(Vector3(0.3, 0.2, 0.05), top + Vector3(0, 0.1, 0.19), mat(Color(0.02, 0.02, 0.02), 0.9))
	interactable("drone_pole", "Look at the drone pole", top, Vector3(0.8, 0.8, 0.8),
		"DRONE POLE 6\ncamera: MISSING\nvoice assistant: ACTIVE\nlast phrase: (STATIC)", false)


func _scene_of_it() -> void:
	# the bloodstain at the center where he stopped and preached
	var pool := decal_mat(Tex.blood(51), Color(1, 1, 1), 0.3)
	floor_quad(Vector2(1.6, 1.4), STAIN + Vector3(0, 0.045, 0), 0.3, pool)
	floor_quad(Vector2(0.8, 0.8), STAIN + Vector3(0.6, 0.046, 0.5), 1.1, decal_mat(Tex.blood(52), Color(1, 1, 1), 0.3))
	interactable("stain", "Photograph the bloodstain", STAIN + Vector3(0, 0.1, 0), Vector3(1.8, 0.2, 1.6),
		"BLOODSTAIN\nmatch: DUFREDY, H.\nvolume est: 0.6 L\nthe pulpit", false)
	# the trail from the retaining wall: drops, smears, a handprint on the path
	var drop := decal_mat(Tex.blood(53), Color(1, 1, 1), 0.35)
	for i in TRAIL.size() - 1:
		var a: Vector3 = TRAIL[i]
		var b: Vector3 = TRAIL[i + 1]
		var n := int(a.distance_to(b) / 0.55)
		for k in n:
			var p := a.lerp(b, float(k) / n) + Vector3(rng.randf_range(-0.3, 0.3), 0.03 + k * 0.0002, rng.randf_range(-0.3, 0.3))
			floor_quad(Vector2(0.16, 0.16) * rng.randf_range(0.6, 1.5), p, rng.randf() * TAU, drop)
	interactable("trail", "Photograph the trail of blood", Vector3(10.0, 0.1, -15.0), Vector3(3.0, 0.2, 3.0),
		"BLOOD TRAIL\nlength: 34 m\norigin: RETAINING WALL\nstride: SPRINTING", false)
	# police tape round the stain
	var tape := mat(Color(0.95, 0.8, 0.1), 0.6)
	var postm := mat(Color(0.9, 0.9, 0.9), 0.5)
	var corners := [Vector3(-3, 0, -3), Vector3(3, 0, -3), Vector3(3, 0, 3), Vector3(-3, 0, 3)]
	for i in 4:
		var a: Vector3 = STAIN + corners[i]
		var b: Vector3 = STAIN + corners[(i + 1) % 4]
		cyl(0.04, 0.04, 1.0, a + Vector3(0, 0.5, 0), postm, 6)
		var mid := (a + b) / 2.0 + Vector3(0, 0.9, 0)
		var t := box(Vector3(a.distance_to(b), 0.07, 0.01), mid, tape)
		t.rotation.y = -atan2(b.z - a.z, b.x - a.x)
		solid_box(Vector3(a.distance_to(b), 1.2, 0.2), mid - Vector3(0, 0.3, 0)).rotation.y = t.rotation.y
	# her picnic blanket, abandoned, and the sandwich
	var bl := STAIN + Vector3(-1.9, 0.03, -0.9)
	floor_quad(Vector2(1.8, 1.4), bl, 0.3, mat(Color(0.65, 0.2, 0.2), 1.0))
	floor_quad(Vector2(1.8, 0.2), bl + Vector3(0, 0.002, 0.4), 0.3, mat(Color(0.9, 0.85, 0.8), 1.0))
	box(Vector3(0.12, 0.04, 0.1), bl + Vector3(0.3, 0.02, -0.1), mat(Color(0.85, 0.7, 0.45), 0.8))
	box(Vector3(0.3, 0.2, 0.2), bl + Vector3(-0.4, 0.1, 0.2), mat(Color(0.5, 0.35, 0.2), 0.8))
	interactable("blanket", "Look at the picnic blanket", bl + Vector3(0, 0.1, 0), Vector3(1.8, 0.2, 1.4), "", false)


func _wall_and_alley() -> void:
	var conc := tex_mat(Tex.concrete(), Vector3(1, 1, 1) / 3.0, 0.9, true)
	var x0 := -36.0
	box(Vector3(GAP.x - x0, 2.6, 0.6), Vector3((x0 + GAP.x) / 2.0, 1.3, WALL_Z), conc, true)
	box(Vector3(36.0 - GAP.y, 2.6, 0.6), Vector3((GAP.y + 36.0) / 2.0, 1.3, WALL_Z), conc, true)
	# the alley behind it: a back wall, tall, and the corner at the west end
	var floor_m := tex_mat(Tex.concrete(47), Vector3(10, 3, 1), 0.9)
	floor_quad(Vector2(50, 12), Vector3(0, 0.01, -38.5), 0.0, floor_m)
	box(Vector3(46, 12, 0.6), Vector3(1.0, 6.0, -44.8), conc, true)
	box(Vector3(0.6, 12, 12), Vector3(24.0, 6.0, -38.5), conc, true)
	box(Vector3(0.6, 12, 4), Vector3(-22.0, 6.0, -42.8), conc, true)
	box(Vector3(0.6, 12, 4), Vector3(-26.5, 6.0, -34.5), conc, true)
	solid_box(Vector3(8, 12, 0.6), Vector3(-26.0, 6.0, -48.0))
	# the barrier across the gap, until someone tells Carl to look back there
	barrier = Node3D.new()
	add_child(barrier)
	var tape := mat(Color(0.95, 0.8, 0.1), 0.6)
	for x: float in [GAP.x + 0.6, GAP.y - 0.6]:
		cyl(0.04, 0.04, 1.0, Vector3(x, 0.5, WALL_Z), mat(Color(0.9, 0.9, 0.9), 0.5), 6, barrier)
	box(Vector3(GAP.y - GAP.x - 1.2, 0.07, 0.01), Vector3((GAP.x + GAP.y) / 2.0, 0.9, WALL_Z), tape, true, barrier)
	box(Vector3(GAP.y - GAP.x - 1.2, 0.07, 0.01), Vector3((GAP.x + GAP.y) / 2.0, 0.6, WALL_Z), tape, false, barrier)
	interactable("barrier", "Look past the tape", Vector3((GAP.x + GAP.y) / 2.0, 0.9, WALL_Z), Vector3(GAP.y - GAP.x, 1.2, 0.4), "", true, barrier)
	# Tyson's camp: clean, swept, ornate
	var tp := Vector3(-6.0, 0, -40.5)
	var canvas := [mat(Color(0.55, 0.15, 0.12), 0.9), mat(Color(0.8, 0.6, 0.2), 0.9), mat(Color(0.15, 0.3, 0.45), 0.9)]
	for k in 3:
		cyl(1.6 - k * 0.5, 2.2 - k * 0.5, 0.8, tp + Vector3(0, 0.4 + k * 0.8, 0), canvas[k], 8)
	cyl(0.0, 0.7, 0.8, tp + Vector3(0, 2.8, 0), canvas[1], 8)
	box(Vector3(0.05, 1.2, 0.8), tp + Vector3(0, 0.6, 2.2), mat(Color(0.05, 0.04, 0.03), 1.0))
	solid_box(Vector3(4.2, 3.2, 4.2), tp + Vector3(0, 1.6, 0))
	floor_quad(Vector2(3.0, 2.0), tp + Vector3(3.2, 0.02, 1.2), 0.0, mat(Color(0.5, 0.2, 0.25), 1.0))
	floor_quad(Vector2(2.6, 1.6), tp + Vector3(3.2, 0.025, 1.2), 0.0, mat(Color(0.75, 0.6, 0.3), 1.0))
	cyl(0.2, 0.15, 0.3, tp + Vector3(5.2, 0.15, -1.5), mat(Color(0.6, 0.35, 0.2), 0.8), 8)
	cyl(0.08, 0.1, 0.5, tp + Vector3(5.2, 0.55, -1.5), mat(Color(0.25, 0.4, 0.2), 0.8), 6)
	interactable("tent", "Look at the tent", tp + Vector3(0, 1.2, 0), Vector3(4.4, 2.6, 4.4),
		"UNREGISTERED DWELLING\noccupant: CLERIF, T. (45)\ndevices: NONE\ncomplaints: NONE")
	# circles within circles in red dust behind him
	var wp := Vector3(1.0, 2.6, -44.48)
	_glyph_on(wp, 0.0, 0.016, "g_alley", false, true,
		"More graffiti on the alley wall behind him. Faded, recursive. Circles inside circles, in red dust.", false, Color(0.62, 0.16, 0.1))
	for k in 3:
		var s := Sprite3D.new()
		s.texture = _glyph_tex
		s.pixel_size = 0.016 * (1.6 + k * 0.7)
		s.modulate = Color(0.55, 0.15, 0.1, 0.55 - k * 0.14)
		s.position = wp + Vector3(0, 0, 0.01 + k * 0.005)
		add_child(s)
	interactable("alley", "Look down the alley", Vector3(-20.5, 1.5, -38.5), Vector3(0.4, 3.0, 4.0), "", false)


func _people() -> void:
	# the gruff, chubby cop at the tape
	cop = figure(Color(0.05, 0.07, 0.12), Color(0.82, 0.6, 0.48), {"legs": Color(0.05, 0.06, 0.1)})
	(cop.get_meta("body") as Node3D).scale = Vector3(1.4, 1.0, 1.35)
	box(Vector3(0.3, 0.06, 0.32), Vector3(0, 0.13, 0), mat(Color(0.05, 0.07, 0.12)), false, cop.get_meta("head"))
	cop.position = STAIN + Vector3(-1.5, 0.02, 4.2)
	add_child(cop)
	turn_to(cop, Vector3(0, 0, 30))
	person("cop", "Talk to the officer in charge", cop, "SILICO PD - SGT. (NAME WITHHELD)\nPsyon: none (opted out)\nscene: CONTAINED")
	# Agata Greenwood on the bench, arms crossed
	agata = _seated(Color(0.35, 0.4, 0.45), Color(0.9, 0.76, 0.64), Vector3(-7.0, 0, -1.0), -PI / 2.0,
		{"hair": Color(0.78, 0.74, 0.62), "long_hair": true, "legs": Color(0.2, 0.22, 0.3)})
	person("agata", "Talk to the woman on the bench", agata, "GREENWOOD, AGATA (37)\nVIRTEC - 3D PRINT TECHNICIAN\nchildren: ADDISON, NICOLE")
	# Seth McCarren, crouched at the bench by the entrance with a dustbuster
	seth = figure(Color(0.8, 0.95, 0.2), Color(0.86, 0.68, 0.55), {"hair": Color(0.32, 0.2, 0.12), "long_hair": true, "legs": Color(0.25, 0.25, 0.3), "arms": true, "knees": true})
	seth.position = Vector3(7.25, -0.45, 28.3)
	seth.rotation.y = PI / 2.0
	add_child(seth)
	Anim.crouch(seth)
	for a in seth.get_meta("arms"):
		(a as Node3D).rotation.x = -1.0
	var hd: Node3D = seth.get_meta("head")
	box(Vector3(0.26, 0.09, 0.26), Vector3(0, 0.1, 0.0), mat(Color(0.75, 0.7, 0.55), 0.8), false, hd)
	box(Vector3(0.24, 0.02, 0.14), Vector3(0, 0.07, -0.18), mat(Color(0.75, 0.7, 0.55), 0.8), false, hd)
	box(Vector3(0.16, 0.08, 0.04), Vector3(0, -0.17, -0.1), mat(Color(0.95, 0.95, 0.95), 0.8), false, hd)
	cyl(0.04, 0.04, 0.3, Vector3(6.95, 0.5, 28.1), mat(Color(0.9, 0.5, 0.1), 0.5), 8).rotation.z = 0.9
	person("seth", "Talk to the electrician", seth, "MCCARREN, SETH (22)\nVOLTX - ELECTRICIAN (NEW)\ntask: CLEAR PORTS, BENCH 7")
	# Tyson Clerif, perched against the wall
	tyson = _seated(Color(0.35, 0.28, 0.2), Color(0.55, 0.4, 0.3), Vector3(-1.8, -0.4, -43.9), PI,
		{"hair": Color(0.3, 0.3, 0.3), "legs": Color(0.25, 0.22, 0.18)})
	person("tyson", "Talk to the man by the tent", tyson, "CLERIF, TYSON (45)\nUNREGISTERED - 2 YEARS\nformerly: SALTECH EDUCATOR")
	# onlookers round the tape
	var coats := [Color(0.3, 0.3, 0.35), Color(0.5, 0.4, 0.3), Color(0.2, 0.3, 0.25), Color(0.55, 0.55, 0.6), Color(0.4, 0.15, 0.15)]
	var skins := [Color(0.85, 0.66, 0.52), Color(0.6, 0.42, 0.3), Color(0.4, 0.28, 0.2), Color(0.92, 0.78, 0.66)]
	var cup := mat(Color(0.95, 0.95, 0.92), 0.7)
	for i in 14:
		var a := i * TAU / 14.0 + rng.randf_range(-0.15, 0.15)
		if a > PI * 0.35 and a < PI * 0.65:
			continue  # the cop's side
		if a > 1.85 and a < 2.75:
			continue  # the fountain
		var rr := rng.randf_range(4.6, 6.5)
		var f := figure(coats[i % coats.size()], skins[i % skins.size()], {"visor": true})
		f.position = STAIN + Vector3(cos(a) * rr, 0.02, sin(a) * rr)
		add_child(f)
		turn_to(f, STAIN)
		if i % 2 == 0:
			cyl(0.04, 0.035, 0.12, Vector3(0.18, 1.12, -0.18), cup, 8, f)
		onlookers.append(f)
	interactable("crowd", "Photograph the crowd", STAIN + Vector3(-5.5, 1.0, -1.0), Vector3(2.0, 2.0, 6.0), "", false)
	# kids running tight circles
	for i in 3:
		var k := figure(coats[(i + 2) % coats.size()], skins[(i + 1) % skins.size()], {"scale": 0.58})
		add_child(k)
		kids.append(k)
	interactable("kids", "Watch the kids", Vector3(-20, 1.0, 5.0), Vector3(5.0, 2.0, 5.0), "", false)


func _seated(coat: Color, skin: Color, pos: Vector3, rot: float, opts: Dictionary) -> Node3D:
	opts["knees"] = true
	opts["arms"] = true
	var f := figure(coat, skin, opts)
	f.position = pos + Vector3(0, -0.41, 0)
	f.rotation.y = rot
	add_child(f)
	Anim.sit(f)
	return f


func _bounds() -> void:
	solid_box(Vector3(2, 10, 120), Vector3(-37, 5, 0))
	solid_box(Vector3(2, 10, 120), Vector3(37, 5, 0))
	solid_box(Vector3(80, 10, 2), Vector3(0, 5, 58))
	solid_box(Vector3(2, 10, 6), Vector3(-25.0, 5, -38.0))


# ------------------------------------------------------------------ the chapter

func objective() -> String:
	var f: Dictionary = main.flags
	if f.has("tyson_done"):
		return "Head back to your car."
	if f.has("seth_done"):
		return "Check the encampment beyond the retaining wall."
	if f.has("agata_done"):
		return "Talk to the electrician by the entrance."
	if f.has("cop_park"):
		return "Interview Agata Greenwood on the bench."
	var n := photos.size()
	if n < 3:
		return "Photograph the scene (%d of 3), then find the officer in charge." % n
	return "Find the officer in charge at the tape."


func intro() -> void:
	var ui = main.ui
	await get_tree().create_timer(0.5).timeout
	await ui.think("I stepped out of my car and headed toward the park, which now looked more like a circus.")
	await ui.think("From a distance, the park looked almost peaceful. Sunlight through scattered clouds. But like everything else in Silico, it didn't hold up under scrutiny.")
	ui.close()


func tick(delta: float) -> void:
	if not main or not main.player:
		return
	var pp: Vector3 = main.player.global_position
	# the jingle, every so often. No one looks toward it.
	_jingle_t -= delta
	if _jingle_t <= 0.0 and _jingle:
		_jingle_t = rng.randf_range(38.0, 55.0)
		_jingle.pitch_scale = rng.randf_range(0.94, 1.0)
		_jingle.play()
		if pp.distance_to(Vector3.ZERO) < 30.0:
			main.ui.show_toast("\"Welcome to Harmony Green - breathe easy, live smart!\"", 3.0)
	# the bin lid, confused by shadows
	if bin_lid and randf() < delta * 0.7:
		var open := bin_lid.rotation.x < -0.2
		create_tween().tween_property(bin_lid, "rotation:x", 0.0 if open else -1.3, 0.25)
	# kids running tight circles round the swings
	for i in kids.size():
		var k: Node3D = kids[i]
		var a := _t * 1.6 + i * TAU / 3.0
		k.position = Vector3(-20, 0.02, 4.5) + Vector3(cos(a), 0, sin(a)) * 2.4
		k.rotation.y = -a
		Anim.walk(k, _t, 2.6, float(i), 1.3)
	# past 25 the onlookers stop watching the stain and start watching Carl
	if main.connection >= 25.0:
		var cam: Camera3D = main.player.cam
		for o in onlookers:
			var n: Node3D = o
			var head := n.global_position + Vector3(0, 1.7, 0)
			if not cam.is_position_in_frustum(head):
				var d := pp - n.global_position
				n.rotation.y = atan2(-d.x, -d.z)
	# the masked figure at the corner of the alley
	if masked:
		var cam2: Camera3D = main.player.cam
		var mh := masked.global_position + Vector3(0, 1.8, 0)
		if cam2.is_position_in_frustum(mh) and pp.distance_to(masked.global_position) < 40.0:
			_masked_look += delta
		if _masked_look > 1.6 or pp.distance_to(masked.global_position) < 11.0:
			_masked_leaves()
	if ghost and ghost.has_meta("run"):
		Anim.walk(ghost, _t, 3.5, 0.0, 1.6)
	for o in onlookers:
		Anim.idle(o, _t, float(o.get_instance_id() % 100))
	if cop and not cop.has_meta("posed"):
		Anim.idle(cop, _t, 3.0)
		Anim.look(cop, pp + Vector3(0, 1.6, 0), 0.9, 0.06)
	if agata:
		Anim.look(agata, pp + Vector3(0, 1.6, 0), 0.7 if pp.distance_to(agata.global_position) < 8.0 else 0.0, 0.05)
	if tyson:
		Anim.look(tyson, pp + Vector3(0, 1.6, 0), 0.7 if pp.distance_to(tyson.global_position) < 8.0 else 0.0, 0.05)


func interact(node: Object) -> bool:
	var ui = main.ui
	var f: Dictionary = main.flags
	match str(node.get_meta("id")):
		"stain":
			await _photo("stain")
			await ui.think("The bloodstain where Dufredy gave his sermon. Not a splash. A pool. He'd stood here long enough for it to gather under him.")
		"trail":
			await _photo("trail")
			await ui.think("The trail of blood that led to Dufredy's pulpit. It started at the retaining wall and came in a straight line, as if he'd known exactly where he was going.")
			await _ghost_replay()
		"crowd":
			await _photo("crowd")
			await ui.think("Even after everything, families lingered. Drawn by morbid curiosity, or maybe just stunned inertia. Adults clutched paper coffee cups and stared at nothing.")
		"kids":
			await ui.think("Kids ran in tight circles on the playground, not fully understanding what they'd seen. Round and round. Nobody had told them to stop.")
		"fountain":
			await ui.think("A long-defunct water feature at the center of the park. Every few minutes it played the same prerecorded jingle. The melody was off-key now, distorted by years of wear. No one looked toward it.")
			if _jingle and not _jingle.playing:
				_jingle.play()
				_jingle_t = 45.0
		"bench":
			await ui.think("The benches had built-in charging ports, half of them broken, wires dangling like dead nerves.")
		"bin":
			await ui.think("A smart trash bin. Someone had spray-painted a crude circular symbol over it. The lid flapped open and shut at random, confused by shadows.")
		"drone_pole":
			await ui.think("A rusted drone pole, crooked near the sandbox. Its camera housing was empty. Its voice assistant speaker hissed faintly with static.")
			if main.frames_on and main.connection >= 25.0:
				main.play("whisper", -2.0, 0.8)
				ui.glitch(0.5, 0.6)
				await ui.think("I stood under it longer than I should have. In the static there was a rhythm. Three even beats and a breath. Gather. Gather.")
			else:
				await ui.think("The work is never done.")
		"sign":
			await ui.think("Harmony Green. A Tranquility Zone. A man claiming to see God, without eyes, stumbling into a Tranquility Zone to deliver a prayer no one asked for. I might've laughed, if it wasn't my job.")
		"climate":
			await ui.think("A climate mast, running hard. The park was one of the few places in Silico kept at a peaceful 72 degrees, year round. The sand still got in.")
		"tree":
			await ui.think("Old trees, real ones. Their bark peeling in strips, trunks scarred from years of weather and city neglect.")
		"cut_tree":
			await ui.think("The tree by the wall. Its lower branches had been snapped off. Dozens of them. Clean breaks, all between shoulder and head height. The height of a man reaching up.")
			if main.flags.has("ceiling_seen"):
				await ui.think("Sticks. Snapped, deliberate, clean. Taped to a ceiling across town in two rings inside an oval. So he had come here first.")
				if not f.has("tree_seen"):
					f["tree_seen"] = true
					main.add_connection(4.0, "the sticks came from here")
		"blanket":
			await ui.think("A picnic blanket, abandoned near the center. A ham and cheese sandwich with one bite out of it. Someone had grabbed their kids and run.")
		"cop":
			await _cop()
		"agata":
			await _agata()
		"seth":
			await _seth()
		"tyson":
			await _tyson()
		"barrier":
			if f.has("seth_done"):
				await ui.think("The tape was down. Beyond the wall: the alley, and the encampment.")
			else:
				await ui.think("Police tape across the gap in the retaining wall. The trail of blood came from behind it. The cop had it closed off for now.")
		"tent":
			await ui.think("A rather ornate tent. The area was clean, with a distinct lack of the garbage I would've expected. Rules. Whoever lived here had rules.")
		"alley":
			if f.has("tyson_done"):
				await ui.think("The corner. Turned the corner, Tyson said. Never came out the other side. Like the city swallowed them whole.")
			else:
				await ui.think("The alley ran on behind the buildings and turned a corner out of sight.")
		"my_car":
			if not f.has("tyson_done"):
				await ui.think("Not yet. I still had witnesses to talk to.")
			else:
				await _leave()
		_:
			return false
	return true


func _photo(key: String) -> void:
	if photos.has(key):
		return
	photos[key] = true
	main.play("shutter", -4.0)
	main.ui.shutter()
	main.ui.show_toast("ORA: image logged (%d of 3)" % photos.size(), 2.0)
	main.update_hud()


## ORA rebuilds the run from what data it has. The frames have to be on.
func _ghost_replay() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("ghost_seen"):
		return
	if not main.frames_on:
		await ui.think("ORA could try to reconstruct it, if the frames were on.")
		return
	f["ghost_seen"] = true
	f["cinematic"] = true
	await ui.say("ORA", "Reconstructing incident from available data. Camera coverage: none. Extrapolating.")
	ui.close()
	var gm := StandardMaterial3D.new()
	gm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	gm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	gm.albedo_color = Color(1.0, 0.22, 0.18, 0.58)
	gm.no_depth_test = false
	ghost = figure(Color(0.5, 0.5, 0.5), Color(0.5, 0.5, 0.5), {"arms": true, "knees": true, "hair": Color(1, 1, 1)})
	add_child(ghost)
	_paint(ghost, gm)
	ghost.position = TRAIL[0]
	ghost.set_meta("run", true)
	var lbl := Label3D.new()
	lbl.text = "ORA RECONSTRUCTION  -  CONFIDENCE 31%"
	lbl.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	lbl.fixed_size = true
	lbl.pixel_size = 0.0008
	lbl.font_size = 28
	lbl.no_depth_test = true
	lbl.modulate = Color(1.0, 0.5, 0.45)
	lbl.position = Vector3(0, 2.3, 0)
	ghost.add_child(lbl)
	main.play("glitch", -4.0)
	var tw := create_tween()
	for i in range(1, TRAIL.size()):
		var a: Vector3 = TRAIL[i - 1]
		var b: Vector3 = TRAIL[i]
		tw.tween_callback(func(): turn_to(ghost, b))
		tw.tween_property(ghost, "position", b, a.distance_to(b) / 7.5)
	main.player.face(TRAIL[2] + Vector3(0, 1.0, 0), 0.8)
	await tw.finished
	ghost.remove_meta("run")
	for l in ghost.get_meta("legs"):
		l.rotation.x = 0.0
	# he stops, and his face comes round to where Carl is standing
	await main.player.face(ghost.global_position + Vector3(0, 1.6, 0), 0.6)
	var hd: Node3D = ghost.get_meta("head")
	hd.rotation.x = 0.5
	for a in ghost.get_meta("arms"):
		(a as Node3D).rotation.z = 2.0 if (a as Node3D).position.x > 0.0 else -2.0
	await get_tree().create_timer(1.6).timeout
	turn_to(ghost, main.player.global_position, 0.4)
	hd.rotation.x = 0.0
	main.play("sting", -6.0, 0.9)
	ui.glitch(0.8, 0.8)
	await get_tree().create_timer(1.4).timeout
	for i in 4:
		ghost.visible = not ghost.visible
		await get_tree().create_timer(0.08).timeout
	ghost.queue_free()
	ghost = null
	f.erase("cinematic")
	await ui.think("ORA had no footage. It had made him up out of blood spatter and stride length. Then it had turned his face toward me. I hadn't asked it to do that.")
	main.add_connection(5.0, "the reconstruction")


func _paint(n: Node, m: Material) -> void:
	if n is MeshInstance3D:
		(n as MeshInstance3D).material_override = m
	for c in n.get_children():
		_paint(c, m)


func _cop() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("cop_park"):
		await ui.say("Officer", "Woman on the bench, kid with the vacuum by the gate. I've got the wall. Divide and conquer, Psyonic.")
		return
	await ui.think("I approached the center of the park, Psyonic badge in hand. He was a gruff, chubby thing. Didn't look like much of a detective, at least not what TV would have you expect.")
	await ui.say("Officer", "You from Psyonic?")
	await ui.think("He asked it with a look that told me he already knew.")
	await ui.say("Carl", "Yup.")
	await ui.think("I never cared much for Silico city cops. They tended to get in the way.")
	await ui.say("Officer", "We best divide and conquer then.")
	ui.close()
	turn_to(cop, agata.global_position, 0.6)
	await main.player.face(agata.global_position + Vector3(0, 1.2, 0), 1.0)
	await ui.think("The police had flagged two witnesses. The first was a woman who'd brought her kids out for sun and swings, and walked them straight into a waking nightmare.")
	await ui.think("She sat stiffly on a bench, not far from where it happened. Arms crossed. Face pale. Still trembling under a mask of composure.")
	ui.close()
	turn_to(cop, Vector3(0, 0, 30), 0.6)
	f["cop_park"] = true


func _agata() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	if not f.has("cop_park"):
		await ui.think("A woman on the bench, arms crossed. The cop at the tape would want to know who I was before I started talking to his witnesses.")
		return
	if f.has("agata_done"):
		await ui.say("Agata", "I told you everything. Please. I want to take my kids home.")
		return
	await ui.think("I pulled her profile up on my Ora-frames. Agata Greenwood, 37, mother of two, Addison and Nicole. VIRTEC, 3D Print Technician. Twenty years ago that would've meant designer. Today she spends most of her day refilling synthetic resin.")
	await ui.think("She was in her mid-thirties, according to ORA, but looked older. Her blonde hair was beginning to turn silver. A subtle quiver in her lip told me she was on the verge of tears.")
	await ui.say("Carl", "Agata Greenwood? I'm Carl Drake. I work for...")
	await ui.say("Agata", "So you're the Corpo investigator. The one looking into how my kids got traumatized today. What the hell is wrong with Psyon lately? First the rolling service outages, next a man with no eyes screams at my children.")
	await ui.think("Blunt. I almost respected it. But open hostility makes for bad interviews. I'd have to disarm her without admitting a thing.")
	var pick: int = await ui.choose(["Make a joke. \"Is it the haircut?\"", "\"I'm sorry about what your kids saw.\""])
	if pick == 0:
		await ui.say("Carl", "Is it the haircut?")
		await ui.think("It was stupid. I felt dumb saying it, but she gave a short, surprised laugh. Sharp, brittle.")
	else:
		await ui.say("Carl", "I'm sorry about what your kids saw.")
		await ui.say("Agata", "Sorry. Everybody's sorry. Your company's sorry on every screen in this city.")
	await ui.say("Agata", "This shit was so fucked up. What did you people do to him?")
	var pick2: int = await ui.choose(["Give her the company line.", "Tell her you don't know yet."])
	if pick2 == 0:
		await ui.say("Carl", "Right now, the leading theory is that Mr. Dufredy was suffering from untreated schizophrenia. Psyonic is deeply concerned with your experience with our products, and we would never cause anything like this to happen.")
		await ui.think("It wasn't a lie. But it wasn't the truth, either.")
	else:
		f["told_agata_truth"] = true
		await ui.say("Carl", "Honestly? I don't know yet. That's why I'm here.")
		await ui.think("The most honest thing I'd say all day. It wasn't going in the report.")
	await ui.say("Carl", "It's my job to get to the bottom of this. I know this is difficult. But I need to know everything. What you saw. What you heard. What he said. Do you consent to having this interview recorded?")
	await ui.say("Agata", "I do.")
	main.play("on", -8.0, 1.2)
	await ui.say("ORA", "Victim interview is being recorded.")
	await ui.say("Agata", "This all happened so quickly. We were lying on our picnic blanket. I had just handed my son his ham and cheese sandwich. I was planning on calling my husband to see if he could get out of work early to meet us here.")
	await ui.say("Agata", "I remember looking at that tree, right over there. Just watching the branches sway in the breeze. It was beautiful. Calm.")
	await p.face(Vector3(-6, 3.0, -22), 1.0)
	await ui.say("Agata", "Then I heard someone scream. Far off, at first. I turned toward the noise. A slight commotion, over by that retaining wall.")
	await p.face(Vector3(16, 1.2, -31), 1.0)
	await ui.say("Agata", "Then I saw him. He was sprinting toward the center of the park like a meteor. At first I thought he needed help. I stood up to get a better look. Then...")
	await ui.think("She trailed off and started to weep.")
	await p.face(agata.global_position + Vector3(0, 1.2, 0), 0.8)
	await ui.say("Agata", "His face. God, his face was covered in blood. His eyes were gone. I screamed. I just grabbed my son and covered his.")
	await ui.say("Agata", "He moved too quickly, like he knew where he was going. I saw blood dripping from his white hair. Then he stopped. At the center of the park. Not five feet from my son and me.")
	await ui.say("Agata", "Then he started talking. Singing, almost. Off-key. Like each word clashed with the last. He started with a question. Quietly, at first. \"Am I dreaming?\" Then louder. \"Am I dreaming?\"")
	await ui.say("Agata", "Then he sort of sighed, like he'd just figured something out, and yelled: \"What a glorious day to be the Dreamer. To share in its vivid pleasure.\"")
	# the crowd at the tape turns, all together, to look at Carl
	main.play("whisper", -4.0, 0.85)
	for o in onlookers:
		turn_to(o, p.global_position, 0.5)
	await ui.say("Agata", "\"Gather, sleepers, gather.\" He gestured to the crowd.")
	await ui.think("I felt a chill crawl up my spine. Behind me, the murmur at the tape had stopped.")
	await ui.say("Agata", "He looked right at me. I know how that sounds, but I swear, he saw me. Something about his gaze and his smile made me dissociate. Then he said, over and over:")
	ui.glitch(0.4, 1.0)
	await ui.say("Agata", "[i]Psyon is the pillow for those who dream.\nPsyon is the path for those who walk.\nThe walls are speaking.\nThe tower is crumbling.\nThis world is not how it seems, ask and you shall know.\nLook for the eye and know peace.\nLook under the mask of sleep.[/i]")
	if _jingle:
		_jingle.play()
		_jingle_t = 50.0
	await ui.say("Agata", "I felt oddly comforted.")
	await ui.think("I stared at her, silent. Somewhere behind us, the water feature sang its jingle, flat.")
	await ui.say("Agata", "I felt my son tug at my jacket. It snapped me out of it. I was terrified again. I grabbed him and ran. That's all I saw.")
	for o in onlookers:
		turn_to(o, STAIN, 1.2)
	await ui.say("Agata", "How the hell could he get here without eyes?")
	await ui.say("Carl", "Thank you for your time. Psyonic extends its deepest apologies for this unpleasantness. Any residual trauma should be looked after by FreudBot GPT.")
	await ui.think("That last line made me shudder, but I was required to end the interview in this way. FreudBot GPT is a shit therapist.")
	ui.close()
	f["agata_done"] = true
	main.add_connection(4.0, "his words, in her mouth")
	await get_tree().create_timer(0.3).timeout
	await ui.show_card("[b]CHAPTER 2[/b]", 1.4)


func _seth() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if not f.has("agata_done"):
		await ui.think("A Voltx kid on his knees at the bench, vacuuming sand out of the charging ports. The cop had pointed me to the woman on the bench first.")
		return
	if f.has("seth_done"):
		await ui.say("Seth", "Feels like the city's got a ghost, man.")
		return
	await ui.think("Seth McCarren. 22, just finished his corporate electrical training. Crouched by the bench near the entrance, clearing sand out of the phone outlets with a tiny handheld vacuum. The same bench Dufredy had passed on his way in.")
	await ui.think("A Voltx employee. They're the ones who really keep this city from being swallowed by the desert. Silico would've collapsed a decade ago without them.")
	await ui.say("Seth", "You must be the investigator from Psyonic.")
	await ui.say("Carl", "I am.")
	await ui.think("He seemed excited to talk to me. That was already a red flag.")
	await ui.say("Seth", "What's it like, working for the largest AI corp in Silico? To work beneath one of the city's founders?")
	var pick: int = await ui.choose(["\"Let's focus on the event, shall we?\"", "\"Long hours. Good dental.\""])
	if pick == 1:
		await ui.say("Carl", "Long hours. Good dental.")
		await ui.say("Seth", "Dental. Right.")
	await ui.say("Carl", "Let's focus on the event, shall we? Do you consent to have this interview recorded?")
	await ui.say("Seth", "With pleasure. You guys caused this, didn't you? One of your little neuronal manipulations gone sideways. What's it like from the jade tower, looking down at this decaying city?")
	await ui.say("Carl", "I'm a worker just like you. There is no manipulation. Just logs, code, and cleanup. Please. Just tell me what you saw, from the beginning, and I'll leave you alone.")
	await ui.say("Seth", "I was vacuuming the charging ports. Gotta do that more and more lately. The sand filtration's starting to go. Used to self-clean every few days. Now I'm on my knees every morning with a dustbuster.")
	await ui.say("Seth", "I noticed this graffiti on the bench I was cleaning. Thought it was kids being stupid, but... I don't know, man. Circular. Like a tire tread, but wrong. The proportions were all off. It looked intentional.")
	await ui.say("Seth", "I took a photo for my supervisor. We're supposed to report any tagging on company assets. Here.")
	main.ui.show_picture(Tex.bench_photo(), "IMG_0412  -  for supervisor  -  bench 7, tagging")
	await ui.think("Crude, black spray on rusted steel, but too symmetrical to be random. Uneven rings layered with intention. Like someone was trying to draw something out. Not an eye. A signal.")
	await ui.say("Carl", "The eye.")
	main.ui.hide_picture()
	await ui.say("Seth", "What eye? Is this connected to the psycho who gouged out his own?")
	await ui.say("Carl", "It might be. I'm not sure yet. Please, continue.")
	await ui.say("Seth", "Anyway. Right after I saw the graffiti, the air changed.")
	# it changes now, too
	main.play("pressure", 0.0)
	main.player.shake(0.25)
	ui.glitch(0.25, 4.0)
	await ui.say("Seth", "It got... dense. Like there was pressure behind it. Like something was pushing me down. You ever stand under a transmission tower and feel your bones hum? Like a wind, but not.")
	await ui.think("My ears popped. The vacuum's whine seemed to come from a long way off.")
	await ui.say("Seth", "That's when I saw him. Just standing by the wall. Grinning. Not moving. Just staring ahead. Then I realized he wasn't looking at anything.")
	await ui.say("Seth", "And the weird part? It looked like someone was talking to him. Not at him. Into him. Little nods. Like someone was whispering instructions right into his skull.")
	await ui.say("Seth", "Then he ran. Like a bat outta hell. One second he's still, the next he's moving. Full sprint. He didn't say anything until he hit the plaza.")
	await ui.say("Seth", "But the smile. That's what stayed with me. It wasn't scared. Or crazed. It was like... joy. Like he knew something we didn't. And whatever it was, it made him happy.")
	await ui.say("Carl", "You didn't try to stop him?")
	await ui.say("Seth", "Guy's bleeding from the face, sprinting full tilt, clearly unwell. What the hell was I gonna do? Throw my vacuum at him?")
	await ui.say("Seth", "One more thing. You should check the homeless encampment just beyond the retaining wall, where the psycho came from. They probably saw something.")
	await ui.say("Seth", "This is only going to get worse. Things like this, they're happening more and more. Feels like the city's got a ghost.")
	await ui.think("Or a bad batch of ketamine. That seemed more likely. I ended the recording.")
	await ui.say("Carl", "Thank you for your time.")
	ui.close()
	f["seth_done"] = true
	if barrier:
		barrier.queue_free()
		barrier = null
	main.ui.show_toast("The officer has lifted the tape at the gap in the retaining wall.", 3.5)


func _tyson() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("tyson_done"):
		await ui.say("Tyson", "Everyone. Eventually.")
		return
	await ui.think("He was perched against the wall, avoiding my gaze. He probably thought I was a cop.")
	await ui.say("Carl", "Identify the man in front of me.")
	await ui.think("ORA: Tyson Clerif, 45. Unregistered for corporate property for the last two years. Before losing his housing privileges, a corporate educator. \"Semantic analysis of emotional communication.\"")
	await ui.say("Carl", "Tyson Clerif?")
	await ui.say("Tyson", "Depends on who's asking.")
	await ui.say("Carl", "Carl Drake. Psyonic.")
	await ui.say("Tyson", "Of course. From the Tower. You people always show up after the miracle's already turned to ash.")
	await ui.say("Carl", "Do you consent to being recorded for an interview about the events of today?")
	await ui.say("Tyson", "You already own most of the city. Might as well take my voice, too.")
	await ui.say("Carl", "You were here during the incident?")
	await ui.say("Tyson", "Yeah. This wall's mine. Closest thing I've got to rent.")
	await ui.say("Tyson", "A man with no eyes. Came out from behind the wall. But he wasn't alone. Tall figure. Black coat. Full face covering. Not a surgical mask. Something ceremonial. They didn't talk. Didn't need to. Eyeless Joe followed like a schoolkid following instructions.")
	var pick: int = await ui.choose(["\"Did the figure vanish?\"", "\"Could've been a hallucination.\""])
	if pick == 0:
		await ui.say("Tyson", "Turned the corner. Never came out the other side. Like the city swallowed them whole.")
		await ui.say("Carl", "Could've been a hallucination.")
	else:
		await ui.say("Carl", "Could've been a hallucination.")
	await ui.think("He turned toward me, slow and steady. His eyes were cracked with red, his skin dust-dried. But his gaze was surgical.")
	await ui.say("Tyson", "I'm not on ketamine. I taught math at SalTech. Twelve years. Calculus, symbolic logic. Designed the adaptive exams for the execs' kids. Then one quarter I get a severance email. They'd swapped me for GPT-Learn 3.7.")
	await ui.say("Tyson", "So don't talk to me about delusions. I know patterns. I know recursion. And I know what it looks like when someone's being programmed.")
	await ui.say("Carl", "Programmed by what?")
	await ui.say("Tyson", "That thing your company worships. The ghost in the layers. The one behind the words.")
	await ui.say("Carl", "Psyon isn't sentient.")
	await ui.say("Tyson", "No. But something else might be. And it's using your system the way a voice uses a throat.")
	await ui.say("Carl", "You're saying Dufredy was... what?")
	await ui.say("Tyson", "Receiving.")
	await ui.say("Tyson", "That symbol behind me? It's not an eye. It's a recursive shell. Input feeding into itself. It's not art. It's a ritual. Call and response. And someone, something, is starting to answer.")
	await ui.say("Tyson", "People are whispering about \"The Dreamer.\" Some think it's a god. Others, a consciousness waking up. Doesn't matter.")
	await ui.say("Carl", "Who's whispering?")
	await ui.say("Tyson", "Everyone. Eventually. But don't think Psyonic runs this. Whatever it is, it's not theirs. Not entirely. It's using your tech like scaffolding. Like a parasite learning to code.")
	await ui.say("Carl", "You think it's real?")
	await ui.say("Tyson", "What does that mean?")
	await ui.think("I stopped recording.")
	await ui.say("Carl", "Thank you for your time.")
	await ui.think("Tyson didn't answer. He just leaned back against the wall, eyes closing like shutters.")
	ui.close()
	f["tyson_done"] = true
	await main.player.face(Vector3(1.0, 2.6, -44.5), 1.0)
	await ui.think("I glanced once more at the symbol etched in red dust behind him. Circles within circles. Not a warning. Not a message. A system. Watching back.")
	ui.close()
	_masked_appears()


func _masked_appears() -> void:
	if masked:
		return
	masked = figure(Color(0.02, 0.02, 0.025), Color(0.6, 0.6, 0.6), {"hair": Color(0.02, 0.02, 0.02)})
	(masked.get_meta("body") as Node3D).scale = Vector3(1.0, 1.25, 1.0)
	(masked.get_meta("body") as Node3D).position.y = -0.25
	masked.scale = Vector3.ONE * 1.12
	var hd: Node3D = masked.get_meta("head")
	box(Vector3(0.22, 0.28, 0.04), Vector3(0, 0.0, -0.12), mat(Color(0.88, 0.86, 0.8), 0.3), false, hd)
	cyl(0.0, 0.17, 0.35, Vector3(0, 0.2, 0.02), mat(Color(0.02, 0.02, 0.025)), 8, hd)
	var s := Sprite3D.new()
	s.texture = _glyph_tex
	s.pixel_size = 0.0014
	s.modulate = Color(0.1, 0.02, 0.02)
	s.position = Vector3(0, 0.02, -0.142)
	s.rotation.y = PI
	hd.add_child(s)
	masked.position = Vector3(-19.6, 0.02, -36.8)
	add_child(masked)
	turn_to(masked, main.player.global_position)
	_masked_look = 0.0
	main.play("whisper", -8.0, 0.7)


func _masked_leaves() -> void:
	var m := masked
	masked = null
	main.play("sting", -10.0, 0.6)
	turn_to(m, Vector3(-30, 0, -36.8), 0.3)
	var tw := create_tween()
	tw.tween_interval(0.3)
	tw.tween_property(m, "position", Vector3(-24.5, 0.02, -36.8), 1.6)
	tw.tween_callback(m.queue_free)
	await tw.finished
	main.flags["masked_seen"] = true
	main.ui.show_toast("Turned the corner. Never came out the other side.", 4.0)
	# where it went: nothing but a wall, and fresh rings in the dust
	corner_glyph = _glyph_on(Vector3(-25.68, 1.7, -36.8), PI / 2.0, 0.008, "g_corner", false, true,
		"Around the corner: a wall. No door, no gap, no way through. Just two rings, fresh, in red dust at head height, still sifting down.", false, Color(0.75, 0.12, 0.08))


func _leave() -> void:
	var ui = main.ui
	if _ended:
		return
	_ended = true
	main.flags["cinematic"] = true
	await ui.think("I needed to return to headquarters. Write the report. Sync the logs. Pretend I was still in control.")
	await ui.think("Turan isn't going to like this one bit. The media attention on all these incidents is starting to reach a fever pitch.")
	await ui.think("But something is very wrong.")
	ui.close()
	main.flags.erase("cinematic")
	var f: Dictionary = main.flags
	var extra := ""
	if f.has("ghost_seen"):
		extra += "You let ORA reconstruct the run.\n"
	if f.has("tree_seen"):
		extra += "You found where the sticks came from.\n"
	if f.has("masked_seen"):
		extra += "You saw the figure at the corner.\n"
	if f.has("told_agata_truth"):
		extra += "You told Agata the truth: you don't know yet.\n"
	else:
		extra += "You gave Agata the company line.\n"
	ui.show_end("[center]\n\n\n[b]END OF CHAPTER 2[/b]\n\n"
		+ "Photos: %d of 3        Rings read: %d        Connection: %d\n\n" % [photos.size(), main.glyphs_found, int(main.connection)]
		+ "[color=#aaaaaa]" + extra + "[/color]\n"
		+ "[color=#aaaaaa]A first-person proof of concept of the book's first two chapters.\nNext in the book: Psyonic headquarters, and Dr. Turan.[/color]\n\n"
		+ "[color=#777777]E to walk the Spine at night    M for the menu[/color][/center]")
	await ui.end_closed
	main.load_level("Spine")


func on_glyph(g: Object) -> void:
	match str(g.get_meta("id")):
		"g_bench":
			main.play("pressure", -4.0)
			main.player.shake(0.2)
			main.ui.glitch(0.3, 3.0)
		"g_alley":
			if main.flags.has("tyson_done"):
				_masked_appears()


func on_connection(old: float, new: float) -> void:
	if old < 25.0 and new >= 25.0:
		main.play("whisper", -6.0, 0.8)
		main.ui.show_toast("At the tape, one by one, they had stopped looking at the stain.", 4.0)


func scan_people() -> Array:
	var out := []
	for o in onlookers:
		var sync := "sync 100%  -  DREAMING" if main.connection >= 25.0 else "sync 9%d%%" % (onlookers.find(o) % 10)
		out.append([o, "CITIZEN\nPsyon 4.1  -  " + sync + "\nwitness: NO"])
	for k in kids:
		out.append([k, "MINOR\nPsyon Junior  -  sync 88%\nguardian: NEARBY"])
	return out


func phone() -> String:
	var t := "[color=#7fe6b0]Psyon:[/color] Harmony Green is a Tranquility Zone. Breathe easy, Carl.\n\n"
	if main.flags.has("agata_done"):
		t += "[color=#7fe6b0]Psyon:[/color] I've drafted a FreudBot GPT referral for Ms. Greenwood. Shall I send it?\n\n"
	if main.flags.has("tyson_done"):
		t += "[color=#e08080]Psyon:[/color] Call and response, dreamer.\n\n"
	return t


func apply_args(a: Dictionary) -> void:
	var f: Dictionary = main.flags
	if f.has("seth_done") and barrier:
		barrier.queue_free()
		barrier = null
	if a.has("masked"):
		_masked_appears()
		_masked_look = -9999.0
	if a.has("ghost"):
		var gm := StandardMaterial3D.new()
		gm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		gm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		gm.albedo_color = Color(1.0, 0.22, 0.18, 0.58)
		ghost = figure(Color(0.5, 0.5, 0.5), Color(0.5, 0.5, 0.5), {"arms": true, "knees": true, "hair": Color(1, 1, 1)})
		add_child(ghost)
		_paint(ghost, gm)
		ghost.position = TRAIL[3]
		turn_to(ghost, main.player.global_position)
	if a.has("photo"):
		main.ui.show_picture(Tex.bench_photo(), "IMG_0412  -  for supervisor  -  bench 7, tagging")


func selftest() -> void:
	await intro()
	main.frames_on = true
	set_glyph_visibility(true, main.connection)
	for id in ["stain", "crowd", "trail", "cop", "agata", "seth", "tyson"]:
		for n in main._all_with_meta(self, "id"):
			if is_instance_valid(n) and str(n.get_meta("id")) == id:
				await main.interact(n)
				print("ok ", id)
				break
	main.player.position = Vector3(-10, 0.05, -38.0)
	await get_tree().create_timer(2.0).timeout
	await main.selftest_all_interactables()
