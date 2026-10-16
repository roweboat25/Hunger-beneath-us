extends "res://scripts/Level.gd"
## The Spine at night: the first test slice. Builds the boulevard, the blocks
## either side, the vacant lot with the camp, the transit tube, the plaza and
## the tower, and runs the slice: read the two-ring glyphs with the frames on,
## the power goes at 25, the tower opens its eye at 50, walk to the tower.
## Layout (metres): the street runs north along -Z from the underpass (z 130)
## to the plaza (z -170); the tower stands at z -330.
## Book, ch. 3: "a jade-and-silver nail driven into the city's spine", a donut
## on a stick, the base "like musculature ... four pairs of biceps", a garden
## path of cacti and palms, transit tubes converging on it, drones like bees.

const CrowdS := preload("res://scripts/Crowd.gd")
const TrafficS := preload("res://scripts/Traffic.gd")

const STREET_S := 130.0
const STREET_N := -170.0
const TOWER_Z := -330.0
const FRONT := 17.0  # building fronts at x = +-17

var cameras: Array = []        # Node3D lobby cameras that track Carl
var pods: Array = []
var tower_eye: MeshInstance3D
var tower_eye_open := false
var fire_light: OmniLight3D
var sweeper: Node3D
var crowd: Node3D
var traffic: Node3D
var _listened := false
var _ended := false

var _concrete: StandardMaterial3D
var _jade: StandardMaterial3D
var _metal: StandardMaterial3D


func build(m: Node) -> void:
	main = m
	rng.seed = 1984
	spawn = Vector3(5.5, 0.2, 104.0)
	rain = true
	card = "THE SPINE\n[color=#888888]night, after the second incident[/color]"
	_concrete = mat(Color(0.13, 0.13, 0.14), 0.9)
	_jade = mat(Color(0.16, 0.42, 0.34), 0.28, 0.75)
	_metal = mat(Color(0.25, 0.26, 0.28), 0.45, 0.6)
	_ground()
	_road()
	_buildings()
	_streetlights()
	_south_end()
	_shuttle_stop()
	_vending()
	_chargers()
	_vacant_lot()
	_kiosk_and_ads()
	_sweeper()
	_transit()
	_plaza()
	_tower()
	_glyphs()
	_bounds()
	_batch(self, 40.0)
	traffic = TrafficS.new()
	add_child(traffic)
	traffic.setup(m, self)
	crowd = CrowdS.new()
	add_child(crowd)
	crowd.setup(m, self)
	m.crowd = crowd


# ------------------------------------------------------------------ ground and road

func _ground() -> void:
	solid_box(Vector3(400, 2, 600), Vector3(0, -1.0, -100))
	var pm := PlaneMesh.new()
	pm.size = Vector2(600, 900)
	mesh(pm, Vector3(0, -0.02, -150), mat(Color(0.06, 0.05, 0.05)))


func _road() -> void:
	var asphalt := pbr("asphalt", Vector3(1, 1, 1) / 4.0, true, Color(0.7, 0.7, 0.72), 0.35)
	var paving := pbr("paving", Vector3(1, 1, 1) / 2.5, true, Color(0.75, 0.75, 0.75), 0.6)
	var curb := mat(Color(0.22, 0.21, 0.2), 0.8)
	var line := mat(Color(0.55, 0.52, 0.42), 0.6)
	var z := STREET_S
	while z > STREET_N:
		var cz := z - 10.0
		var pm := PlaneMesh.new()
		pm.size = Vector2(20, 20)
		mesh(pm, Vector3(0, 0.0, cz), asphalt)
		for side: float in [-1.0, 1.0]:
			var sw := PlaneMesh.new()
			sw.size = Vector2(7, 20)
			mesh(sw, Vector3(side * 13.5, 0.12, cz), paving)
			box(Vector3(0.3, 0.14, 20), Vector3(side * 10.1, 0.07, cz), curb)
			for k in 2:
				box(Vector3(0.14, 0.01, 3.0), Vector3(side * 5.0, 0.01, cz - 5.0 + k * 10.0), line)
		box(Vector3(0.12, 0.01, 20), Vector3(-0.12, 0.01, cz), line)
		box(Vector3(0.12, 0.01, 20), Vector3(0.12, 0.01, cz), line)
		z -= 20.0


# ------------------------------------------------------------------ buildings

func _buildings() -> void:
	var variants := []
	for i in 6:
		var t: Array = Tex.facade(100 + i, 0.14 + 0.05 * i)
		# world-space (triplanar) mapping so every building shares these two
		var wall := newmat(Color(1, 1, 1), 0.7)
		wall.albedo_texture = t[0]
		wall.uv1_triplanar = true
		wall.uv1_world_triplanar = true
		wall.uv1_scale = Vector3(1, 1, 1) / 7.0
		var lit := StandardMaterial3D.new()
		lit.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		lit.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
		lit.albedo_texture = t[1]
		lit.uv1_triplanar = true
		lit.uv1_world_triplanar = true
		lit.uv1_scale = Vector3(1, 1, 1) / 7.0
		power_mats.append([lit, Color(1, 1, 1), "albedo_color", Color(0, 0, 0)])
		variants.append([t[0], t[1], wall, lit])
	var shop_cols := [Color(1.0, 0.55, 0.25), Color(0.2, 0.9, 0.85), Color(1.0, 0.25, 0.65),
		Color(0.45, 1.0, 0.55), Color(1.0, 0.8, 0.5)]
	var signs := ["NOODLES", "24H", "LUSHON", "NIXTRA", "TOKZ", "VOLTX", "PSYMATCHBOT",
		"FREUDBOT", "ALTO ENERGY", "SALTECH", "PHARMA", "KARAOKE", "SLEEP PODS", "REPAIR"]
	for side: float in [-1.0, 1.0]:
		var z := STREET_S - 2.0
		while z > STREET_N + 2.0:
			var depth := rng.randf_range(14.0, 28.0)
			if side < 0.0 and z > -55.0 and z - depth < -5.0:
				if z - (-5.0) >= 8.0:
					depth = z + 5.0
				else:
					z = -55.0
					continue
			depth = minf(depth, z - STREET_N)
			if depth < 6.0:
				break
			var h := rng.randf_range(16.0, 62.0)
			if rng.randf() < 0.2:
				h = rng.randf_range(70.0, 110.0)
			_building(side, z - depth / 2.0, depth, h, variants[rng.randi() % variants.size()],
				shop_cols, signs)
			z -= depth
			if rng.randf() < 0.3:
				z -= 3.5  # an alley
	# the far wall behind the alleys
	box(Vector3(2, 60, 310), Vector3(-41, 30, -20), _concrete)
	box(Vector3(2, 60, 310), Vector3(41, 30, -20), _concrete)


func _building(side: float, cz: float, depth: float, h: float, tex: Array, shop_cols: Array, signs: Array) -> void:
	var body_w := 22.0
	box(Vector3(body_w, h, depth), Vector3(side * (FRONT + body_w / 2.0), h / 2.0, cz), _concrete, true)
	var rot := -PI / 2.0 if side > 0.0 else PI / 2.0
	var fx := side * (FRONT - 0.02)
	# windows from the second storey up. The lit windows are a second,
	# additive unshaded layer (emission textures don't render in the
	# Compatibility renderer the browser build uses).
	var fpos := Vector3(fx, 4.5 + (h - 4.5) / 2.0, cz)
	quad(Vector2(depth, h - 4.5), fpos, rot, tex[2])
	quad(Vector2(depth, h - 4.5), fpos - Vector3(side * 0.02, 0, 0), rot, tex[3])
	# street level: a lit shopfront or a shutter
	if rng.randf() < 0.65:
		var c: Color = shop_cols[rng.randi() % shop_cols.size()]
		quad(Vector2(depth - 1.5, 3.0), Vector3(fx - side * 0.01, 1.7, cz), rot, glow(c * 0.3, 1.0, true))
		if rng.randf() < 0.6:
			var txt: String = signs[rng.randi() % signs.size()]
			var l := label(txt, Vector3(side * (FRONT - 0.12), 4.0, cz), rot, 0.014, c * 1.6)
			if rng.randf() < 0.45:
				light(Vector3(side * (FRONT - 1.4), 4.0, cz), c, 1.1, 7.0)
			if rng.randf() < 0.25:
				flickers.append(l)
	else:
		var sh := mat(Color(0.2, 0.2, 0.21), 0.5, 0.7)
		quad(Vector2(depth - 1.5, 3.0), Vector3(fx - side * 0.01, 1.7, cz), rot, sh)
	# roof clutter and aircraft lights on the tall ones
	box(Vector3(4, 2.5, 4), Vector3(side * (FRONT + 8.0), h + 1.25, cz), _metal)
	if h > 55.0:
		var b := box(Vector3(0.6, 0.6, 0.6), Vector3(side * (FRONT + 3.0), h + 0.6, cz), glow(Color(1, 0.05, 0.05), 4.0))
		blinkers.append(b)


func _streetlights() -> void:
	var pole := mat(Color(0.1, 0.1, 0.11), 0.5, 0.7)
	var i := 0
	var z := STREET_S - 8.0
	while z > STREET_N:
		for side: float in [-1.0, 1.0]:
			var x := side * 10.6
			cyl(0.09, 0.12, 7.2, Vector3(x, 3.6, z), pole, 8)
			box(Vector3(1.8, 0.12, 0.12), Vector3(x - side * 0.9, 7.1, z), pole)
			var sodium := (i % 3) != 1
			var c := Color(1.0, 0.62, 0.32) if sodium else Color(0.7, 0.85, 1.0)
			box(Vector3(0.7, 0.12, 0.35), Vector3(x - side * 1.6, 7.0, z), glow(c, 3.0, true))
			var o := light(Vector3(x - side * 1.6, 6.7, z), c, 2.4, 17.0)
			if rng.randf() < 0.18:
				flickers.append(o)
			i += 1
		z -= 24.0


# ------------------------------------------------------------------ the south end: underpass stairs

func _south_end() -> void:
	# jersey barriers and a closed fence across the road
	var conc := mat(Color(0.35, 0.34, 0.32), 0.9)
	for x in range(-9, 10, 3):
		box(Vector3(2.8, 1.0, 0.8), Vector3(x, 0.5, 128.0), conc)
	box(Vector3(34, 6, 0.3), Vector3(0, 3, 131.0), mat(Color(0.12, 0.12, 0.12), 0.6, 0.5), true)
	label("ROAD CLOSED  -  INCIDENT  -  SILICO PD", Vector3(0, 2.0, 127.55), PI, 0.01, Color(1.0, 0.75, 0.2), self, false)
	# the stairwell down into the underpass, west sidewalk
	var rail := mat(Color(0.3, 0.3, 0.32), 0.4, 0.8)
	var dark := mat(Color(0.01, 0.01, 0.01), 1.0)
	box(Vector3(5, 0.05, 9), Vector3(-13.5, 0.13, 116.0), dark)
	for k in 6:
		box(Vector3(4.5, 0.25, 1.4), Vector3(-13.5, -0.3 - k * 0.45, 112.5 + k * 1.4), mat(Color(0.15, 0.14, 0.13)))
	box(Vector3(0.08, 1.0, 9), Vector3(-11.0, 0.65, 116.0), rail, true)
	box(Vector3(0.08, 1.0, 9), Vector3(-16.0, 0.65, 116.0), rail, true)
	box(Vector3(5, 1.0, 0.08), Vector3(-13.5, 0.65, 111.5), rail, true)
	box(Vector3(0.4, 3.2, 9), Vector3(-10.6, 1.6, 116.0), _concrete)
	interactable("underpass", "Look down the stairs", Vector3(-13.5, 0.6, 116.0), Vector3(4.6, 1.2, 8.6), "", false)
	# the signpost glyph: big, confident, old. Visible to everyone.
	_glyph_on(Vector3(-10.37, 1.9, 118.5), PI / 2.0, 0.017, "south_glyph", false, true,
		"Two rings on the wall beside the underpass stairs. Big, confident, old. Pointing the way down like a signpost.")


func _shuttle_stop() -> void:
	var z := 86.0
	var x := 13.8
	var frame := mat(Color(0.2, 0.22, 0.24), 0.4, 0.8)
	var glass := newmat(Color(0.5, 0.7, 0.8, 0.18), 0.05)
	glass.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	box(Vector3(2.4, 0.12, 6), Vector3(x, 2.8, z), frame)
	box(Vector3(0.05, 2.6, 6), Vector3(x + 1.1, 1.5, z), glass)
	box(Vector3(0.1, 2.8, 0.1), Vector3(x - 1.1, 1.4, z - 2.9), frame)
	box(Vector3(0.1, 2.8, 0.1), Vector3(x - 1.1, 1.4, z + 2.9), frame)
	box(Vector3(0.6, 0.45, 3.5), Vector3(x + 0.7, 0.45, z), frame)
	var panel := box(Vector3(0.06, 1.6, 1.1), Vector3(x + 1.0, 1.6, z + 1.8), glow(Color(0.85, 0.9, 1.0), 0.8, true))
	var info := label("SALTECH SHUTTLE\nSERVICE SUSPENDED", Vector3(x + 0.95, 1.9, z + 1.8), -PI / 2.0, 0.0035, Color(0.1, 0.1, 0.15), self, false)
	info.font_size = 64
	screens.append([panel, _screen_eye(Vector3(x + 0.93, 1.6, z + 1.8), -PI / 2.0, 0.008)])
	interactable("shuttle_stop", "Read the timetable", Vector3(x + 0.6, 1.4, z), Vector3(1.4, 2.6, 5.8),
		"SALTECH SHUTTLE STOP 12\nservice: SUSPENDED\nsince: SECOND INCIDENT")


func _vending() -> void:
	var p := Vector3(-16.2, 1.05, 60.0)
	box(Vector3(0.9, 2.1, 1.3), p, mat(Color(0.12, 0.35, 0.28), 0.4, 0.5))
	var scr := quad(Vector2(1.0, 1.2), p + Vector3(0.46, 0.25, 0), PI / 2.0, glow(Color(0.5, 1.0, 0.8), 1.4, true))
	label("PSYONIC\nWATER  3cr", p + Vector3(0.47, 0.25, 0), PI / 2.0, 0.004, Color(0.05, 0.2, 0.1), self, false)
	screens.append([scr, _screen_eye(p + Vector3(0.48, 0.25, 0), PI / 2.0, 0.009)])
	light(p + Vector3(1.2, 0.4, 0), Color(0.4, 1.0, 0.7), 0.8, 4.5)
	interactable("vending", "Look at the vending machine", p, Vector3(0.95, 2.1, 1.35),
		"PSYONIC VENDING 7\nstock: WATER x40\nad loop: FAMILY ASLEEP")


func _chargers() -> void:
	for k in 3:
		var p := Vector3(10.9, 0.8, 42.0 - k * 6.0)
		box(Vector3(0.4, 1.6, 0.5), p, mat(Color(0.85, 0.86, 0.88), 0.3, 0.2))
		box(Vector3(0.42, 0.08, 0.52), p + Vector3(0, 0.6, 0), glow(Color(0.3, 1.0, 0.6), 2.0, true))
	interactable("charger", "Check the charge post", Vector3(10.9, 0.8, 42.0), Vector3(0.5, 1.6, 0.6),
		"FLEET CHARGER 3\nlast vehicle: DRAKE, C.\ntrips logged: ALL OF THEM")
	# Carl's company car, parked on the charge bay
	var car := Node3D.new()
	car.position = Vector3(7.6, 0.0, 41.0)
	add_child(car)
	var paint := mat(Color(0.75, 0.78, 0.8), 0.25, 0.7)
	box(Vector3(2.0, 0.8, 4.6), Vector3(0, 0.6, 0), paint, false, car)
	box(Vector3(1.8, 0.6, 2.4), Vector3(0, 1.25, 0.2), mat(Color(0.05, 0.07, 0.09), 0.1, 0.5), false, car)
	box(Vector3(1.6, 0.12, 0.05), Vector3(0, 0.75, -2.31), glow(Color(1, 1, 1), 1.5), false, car)
	box(Vector3(1.6, 0.1, 0.05), Vector3(0, 0.8, 2.31), glow(Color(1, 0.1, 0.1), 1.5), false, car)
	solid_box(Vector3(2.0, 1.6, 4.6), Vector3(0, 0.8, 0), car)
	interactable("my_car", "Your company car", Vector3(0, 1.0, 0), Vector3(2.1, 1.8, 4.7),
		"PSYONIC FLEET 0086\ndriver: DRAKE, C.\nmicrophone: ALWAYS ON", false, car)


# ------------------------------------------------------------------ the vacant lot and the camp

func _vacant_lot() -> void:
	var dirt := mat(Color(0.2, 0.13, 0.09), 1.0)
	var pm := PlaneMesh.new()
	pm.size = Vector2(28, 50)
	mesh(pm, Vector3(-31, 0.01, -30), dirt)
	var fence := newmat(Color(0.5, 0.5, 0.55, 0.35), 0.5, 0.8)
	fence.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	fence.cull_mode = BaseMaterial3D.CULL_DISABLED
	box(Vector3(0.05, 2.4, 20), Vector3(-17.2, 1.2, -15), fence, true)
	box(Vector3(0.05, 2.4, 20), Vector3(-17.2, 1.2, -45), fence, true)
	box(Vector3(0.05, 2.4, 50), Vector3(-44.5, 1.2, -30), fence, true)
	# tents in a neat row, a fire barrel, nothing that blinks
	var canvas := [mat(Color(0.3, 0.25, 0.18)), mat(Color(0.2, 0.24, 0.2)), mat(Color(0.28, 0.2, 0.2))]
	for k in 4:
		var t := cyl(0.0, 1.6, 1.6, Vector3(-38.0, 0.8, -18.0 - k * 6.0), canvas[k % 3], 3)
		t.rotation.y = PI / 6.0
		solid_box(Vector3(2.4, 1.6, 2.4), Vector3(-38.0, 0.8, -18.0 - k * 6.0))
	cyl(0.35, 0.35, 0.9, Vector3(-30.0, 0.45, -30.0), mat(Color(0.25, 0.12, 0.08), 0.6, 0.6), 12)
	cyl(0.3, 0.05, 0.6, Vector3(-30.0, 1.1, -30.0), glow(Color(1.0, 0.45, 0.1), 3.5), 6)
	fire_light = light(Vector3(-30.0, 1.6, -30.0), Color(1.0, 0.5, 0.2), 2.2, 11.0, false)
	for k in 3:
		box(Vector3(0.8, 0.5, 0.8), Vector3(-27.5 - k * 1.2, 0.25, -34.0), mat(Color(0.3, 0.22, 0.15)))
	interactable("camp", "Look at the camp", Vector3(-30.0, 0.8, -30.0), Vector3(1.2, 1.6, 1.2))


# ------------------------------------------------------------------ screens, ads, the kiosk

func _screen_eye(pos: Vector3, rot_y: float, px: float) -> Sprite3D:
	var s := Sprite3D.new()
	s.texture = _glyph_tex
	s.pixel_size = px
	s.position = pos
	s.rotation.y = rot_y
	s.modulate = Color(1.0, 0.1, 0.08)
	s.shaded = false
	s.visible = false
	add_child(s)
	return s


func _kiosk_and_ads() -> void:
	# city terminal kiosk, east sidewalk
	var kp := Vector3(14.6, 1.0, -100.0)
	box(Vector3(0.6, 2.0, 1.0), kp, _metal)
	var ks := quad(Vector2(0.8, 0.9), kp + Vector3(-0.31, 0.3, 0), -PI / 2.0, glow(Color(0.4, 0.7, 1.0), 1.3, true))
	screens.append([ks, _screen_eye(kp + Vector3(-0.33, 0.3, 0), -PI / 2.0, 0.006)])
	interactable("kiosk", "Use the city terminal", kp, Vector3(0.7, 2.0, 1.1),
		"CITY TERMINAL 88\nservices: TRANSIT, BILLS, FREUDBOT\nbezel: SCRATCHED (INSIDE)")
	# two big holo ads hanging off the blocks
	_holo(Vector3(15.5, 17.0, -92.0), -PI / 2.0 + 0.35, "TOKZ\nSLEEP BETTER.\nSLEEP TOGETHER.", Color(1.0, 0.3, 0.75))
	_holo(Vector3(-15.5, 21.0, -132.0), PI / 2.0 - 0.35, "NIXTRA\na new flavour:\nCALM", Color(0.3, 0.95, 1.0))
	_holo(Vector3(15.5, 30.0, -10.0), -PI / 2.0 + 0.3, "PSYON\nthe pillow for\nthose who dream", Color(0.4, 1.0, 0.6))


func _holo(pos: Vector3, rot_y: float, text: String, c: Color) -> void:
	var root := Node3D.new()
	root.position = pos
	root.rotation.y = rot_y
	add_child(root)
	var m := newmat(Color(c.r, c.g, c.b, 0.12), 1.0)
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.cull_mode = BaseMaterial3D.CULL_DISABLED
	var q := quad(Vector2(14, 8), Vector3.ZERO, 0.0, m, root)
	var l := label(text, Vector3(0, 0, 0.05), 0.0, 0.03, c * 1.5, root)
	l.font_size = 72
	l.double_sided = true
	var eye := Sprite3D.new()
	eye.texture = _glyph_tex
	eye.pixel_size = 0.06
	eye.modulate = Color(1, 0.08, 0.05)
	eye.shaded = false
	eye.double_sided = true
	eye.visible = false
	root.add_child(eye)
	screens.append([q, eye])
	box(Vector3(0.3, 0.3, 3.0), Vector3(0, 4.2, -1.5), _metal, false, root)


func _sweeper() -> void:
	sweeper = Node3D.new()
	sweeper.position = Vector3(13.0, 0.12, -62.0)
	add_child(sweeper)
	box(Vector3(0.8, 0.5, 1.0), Vector3(0, 0.3, 0), mat(Color(0.9, 0.6, 0.1), 0.5, 0.3), false, sweeper)
	box(Vector3(0.5, 0.1, 0.2), Vector3(0, 0.45, -0.45), glow(Color(0.3, 0.9, 1.0), 2.0, true), false, sweeper)
	cyl(0.25, 0.25, 0.06, Vector3(0, 0.05, -0.55), mat(Color(0.2, 0.2, 0.2)), 10, sweeper)
	interactable("sweeper", "Look at the sweeper bot", Vector3(0, 0.4, 0), Vector3(1.0, 0.8, 1.2),
		"VOLTX SWEEPER 9\ntask: CLEAR SAND\nprogress: 0%\nloop count: 1,340", false, sweeper)


# ------------------------------------------------------------------ the transit tube to the tower

func _transit() -> void:
	var glass := newmat(Color(0.4, 0.75, 0.7, 0.22), 0.05, 0.3)
	glass.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	glass.cull_mode = BaseMaterial3D.CULL_DISABLED
	var strip := glow(Color(0.3, 1.0, 0.75), 2.5)
	var y := 26.0
	var z := STREET_S
	while z > TOWER_Z + 60.0:
		var seg := cyl(2.2, 2.2, 40.0, Vector3(0, y, z - 20.0), glass, 16)
		seg.rotation.x = PI / 2.0
		box(Vector3(0.3, 0.15, 40.0), Vector3(0, y - 2.0, z - 20.0), strip)
		z -= 40.0
	var z2 := 110.0
	while z2 > STREET_N:
		cyl(0.9, 1.3, y - 2.2, Vector3(0, (y - 2.2) / 2.0, z2), _concrete, 12)
		solid_box(Vector3(2.4, y, 2.4), Vector3(0, y / 2.0, z2))
		z2 -= 50.0
	interactable("pylon", "Look at the pylon", Vector3(0, 2.0, -140.0), Vector3(2.8, 4.0, 2.8),
		"TRANSIT PYLON 41\nline: TOWER LOOP\nload: 12%\nterminus: THE TOWER")
	for k in 2:
		var pod := Node3D.new()
		add_child(pod)
		var cm := CapsuleMesh.new()
		cm.radius = 1.6
		cm.height = 9.0
		var pmi := mesh(cm, Vector3.ZERO, mat(Color(0.85, 0.88, 0.9), 0.2, 0.6), pod)
		pmi.rotation.x = PI / 2.0
		box(Vector3(3.3, 0.5, 6.0), Vector3(0, 0.3, 0), glow(Color(1.0, 0.95, 0.8), 1.5), false, pod)
		pod.position = Vector3(0, y, STREET_S - k * 250.0)
		pods.append(pod)


# ------------------------------------------------------------------ the plaza and the garden path

func _plaza() -> void:
	var stone := mat(Color(0.3, 0.32, 0.3), 0.35, 0.1)
	var pm := PlaneMesh.new()
	pm.size = Vector2(150, 140)
	mesh(pm, Vector3(0, 0.02, -240), stone)
	# cacti and palms either side of the path: "a sterile nod to the desert outside"
	var green := mat(Color(0.18, 0.32, 0.2), 0.8)
	var trunk := mat(Color(0.35, 0.27, 0.18), 0.9)
	var frond := newmat(Color(0.15, 0.3, 0.15), 0.8)
	frond.cull_mode = BaseMaterial3D.CULL_DISABLED
	var z := -178.0
	while z > -262.0:
		for side: float in [-1.0, 1.0]:
			var x := side * 6.5
			if int(absf(z)) % 16 < 8:
				cyl(0.35, 0.4, 2.6, Vector3(x, 1.3, z), green, 8)
				cyl(0.2, 0.22, 1.0, Vector3(x + 0.5, 1.6, z), green, 6).rotation.z = -0.9
				cyl(0.2, 0.22, 0.9, Vector3(x - 0.45, 1.9, z), green, 6).rotation.z = 0.9
				solid_box(Vector3(0.9, 2.6, 0.9), Vector3(x, 1.3, z))
			else:
				cyl(0.18, 0.3, 7.0, Vector3(x, 3.5, z), trunk, 8)
				for f in 6:
					var leaf := box(Vector3(0.6, 0.05, 3.2), Vector3(x, 7.0, z), frond)
					leaf.rotation = Vector3(-0.5, f * TAU / 6.0, 0)
					leaf.position += Vector3(sin(f * TAU / 6.0), -0.6, cos(f * TAU / 6.0)) * 1.3
				solid_box(Vector3(0.6, 7.0, 0.6), Vector3(x, 3.5, z))
			box(Vector3(2.5, 0.3, 4.0), Vector3(x, 0.15, z), mat(Color(0.35, 0.22, 0.14), 1.0))
		z -= 8.0
	# plaza lamps
	for k in 4:
		for side: float in [-1.0, 1.0]:
			var p := Vector3(side * 12.0, 0, -185.0 - k * 22.0)
			cyl(0.1, 0.12, 5.0, p + Vector3(0, 2.5, 0), _metal, 8)
			box(Vector3(0.5, 0.2, 0.5), p + Vector3(0, 5.0, 0), glow(Color(0.8, 1.0, 0.9), 2.5, true))
			light(p + Vector3(0, 4.7, 0), Color(0.8, 1.0, 0.92), 1.3, 14.0)
	# the monolith sign
	box(Vector3(9, 3.0, 1.2), Vector3(0, 1.5, -205.0), _jade, true)
	label("PSYONIC INTEGRATIONS", Vector3(0, 1.9, -204.38), 0.0, 0.018, Color(0.8, 1.6, 1.2))
	interactable("tower_sign", "Read the sign", Vector3(0, 1.5, -204.6), Vector3(9.2, 3.0, 0.6))
	# lobby cameras on poles: they turn to follow whoever walks past
	for side: float in [-1.0, 1.0]:
		for k in 2:
			var base := Vector3(side * 9.0, 0, -192.0 - k * 34.0)
			cyl(0.07, 0.09, 4.2, base + Vector3(0, 2.1, 0), _metal, 6)
			var head := Node3D.new()
			head.position = base + Vector3(0, 4.3, 0)
			add_child(head)
			box(Vector3(0.3, 0.3, 0.7), Vector3(0, 0, -0.1), mat(Color(0.9, 0.9, 0.9), 0.3), false, head)
			box(Vector3(0.12, 0.12, 0.05), Vector3(0, 0, -0.47), glow(Color(1, 0.1, 0.1), 3.0), false, head)
			cameras.append(head)
	# plaza edges: low service blocks
	for side: float in [-1.0, 1.0]:
		box(Vector3(30, 14, 120), Vector3(side * 60.0, 7.0, -240.0), _concrete, true)


# ------------------------------------------------------------------ the tower

func _tower() -> void:
	var root := Node3D.new()
	root.position = Vector3(0, 0, TOWER_Z)
	add_child(root)
	# base: jade-and-silver concrete with four pairs of "biceps" round it
	cyl(50.0, 56.0, 36.0, Vector3(0, 18.0, 0), _jade, 48, root)
	var silver := mat(Color(0.6, 0.63, 0.66), 0.25, 0.85)
	for pair in 4:
		for k: float in [-1.0, 1.0]:
			var ang: float = pair * PI / 2.0 + PI / 4.0 + k * 0.24
			var cm := CapsuleMesh.new()
			cm.radius = 12.0
			cm.height = 64.0
			var arm := mesh(cm, Vector3(sin(ang) * 50.0, 24.0, cos(ang) * 50.0), silver if k > 0.0 else _jade, root)
			arm.rotation = Vector3(0, ang, 0)
			arm.rotate_object_local(Vector3.FORWARD, 1.15)
	var base_body := StaticBody3D.new()
	var cs := CollisionShape3D.new()
	var shp := CylinderShape3D.new()
	shp.radius = 68.0
	shp.height = 60.0
	cs.shape = shp
	cs.position = Vector3(0, 30, 0)
	base_body.add_child(cs)
	root.add_child(base_body)
	# the shaft, nearly a mile up, with lit seams like scales on a sleeping god
	cyl(16.0, 30.0, 440.0, Vector3(0, 36.0 + 220.0, 0), _jade, 32, root)
	var seam := newglow(Color(0.3, 1.0, 0.7), 3.0)
	seam.disable_fog = true
	for s in 10:
		var ang := s * TAU / 10.0
		for seg in 11:
			var y := 46.0 + seg * 40.0
			var rad := lerpf(30.0, 16.0, (y - 36.0) / 440.0) + 0.2
			var b := box(Vector3(0.9, 30.0, 0.9), Vector3(sin(ang) * rad, y, cos(ang) * rad), seam, false, root)
			b.rotation.y = ang
	# the donut on a stick
	var tm := TorusMesh.new()
	tm.inner_radius = 58.0
	tm.outer_radius = 108.0
	tm.rings = 48
	tm.ring_segments = 16
	var donut := mesh(tm, Vector3(0, 540.0, 0), silver, root)
	var tm2 := TorusMesh.new()
	tm2.inner_radius = 106.0
	tm2.outer_radius = 110.0
	tm2.rings = 48
	tm2.ring_segments = 6
	var ring_m := newglow(Color(0.3, 1.0, 0.7), 3.0)
	ring_m.disable_fog = true
	var ringlight := mesh(tm2, Vector3(0, 540.0, 0), ring_m, root)
	var red := newglow(Color(1, 0.05, 0.05), 5.0)
	red.disable_fog = true
	for k in 6:
		var a := k * TAU / 6.0
		var b := box(Vector3(3, 3, 3), Vector3(cos(a) * 108.0, 540.0 + sin(a) * 108.0, 0), red, false, root)
		blinkers.append(b)
	# uplights washing the shaft
	for k in 4:
		var sp := SpotLight3D.new()
		var a := k * TAU / 4.0 + PI / 4.0
		var sp_pos := Vector3(sin(a) * 75.0, 2.0, cos(a) * 75.0)
		sp.transform = Transform3D(Basis.looking_at(Vector3(0, 300, 0) - sp_pos, Vector3.UP), sp_pos)
		sp.light_color = Color(0.6, 1.0, 0.85)
		sp.light_energy = 6.0
		sp.spot_range = 520.0
		sp.spot_angle = 9.0
		sp.spot_attenuation = 0.6
		root.add_child(sp)
	# the eye that opens in the hole of the donut
	var eye_m := StandardMaterial3D.new()
	eye_m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	eye_m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	eye_m.albedo_texture = Tex.eye()
	eye_m.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	eye_m.billboard_keep_scale = true
	eye_m.disable_fog = true
	var eq := QuadMesh.new()
	eq.size = Vector2(118, 118)
	tower_eye = MeshInstance3D.new()
	tower_eye.mesh = eq
	tower_eye.material_override = eye_m
	tower_eye.position = Vector3(0, 540.0, 28.0)
	tower_eye.visible = false
	root.add_child(tower_eye)
	no_batch.append(tower_eye)
	_batch(root, 10000.0)


# ------------------------------------------------------------------ glyphs

func _glyphs() -> void:
	_glyph_on(Vector3(-16.96, 2.6, 74.0), PI / 2.0, 0.014, "g_noodle", false, false,
		"Two rings sprayed beside a shuttered shopfront. Still wet in the rain, though nobody had been here all night.")
	_glyph_on(Vector3(14.84, 0.5, 87.8), -PI / 2.0, 0.005, "g_shuttle", false, false,
		"Under the SalTech timetable, the two rings in marker. Someone had pressed hard enough to dent the plastic.")
	_glyph_on(Vector3(-15.73, 0.4, 60.45), PI / 2.0, 0.0025, "g_vending", false, false,
		"Scratched into the side of the vending machine with a key, so small you'd only see it if something told you where to look.")
	_glyph_on(Vector3(16.96, 3.2, 22.0), -PI / 2.0, 0.02, "g_east", false, false,
		"A big one, painted over a bricked-up door. The paint under it was newer than the wall.")
	_glyph_on(Vector3(-44.4, 1.0, -26.0), PI / 2.0, 0.006, "g_camp", false, false,
		"On the fence behind the camp, small, at a child's height. The camp had no screens and no lights, and still someone had come here to draw it.")
	_glyph_on(Vector3(1.32, 3.0, -140.0), PI / 2.0, 0.012, "g_pylon", false, false,
		"Up the side of the pylon, where the tube to the tower began. Like a mark on a map: this way.")
	# deep glyphs: red, only past 25 connection
	_glyph_on(Vector3(0, 0.03, -60.0), 0.0, 0.12, "g_road", true, false,
		"A ring as wide as the road, under the asphalt like a watermark. The cars had been flying over it for years. Nobody had painted it. It had come up from underneath.", true)
	_glyph_on(Vector3(16.96, 3.0, -118.0), -PI / 2.0, 0.03, "g_wall_deep", true, false,
		"Red, and wet, and the size of a door. It wasn't paint. I didn't touch it to find out what it was.")
	_glyph_on(Vector3(-4.5, 0.03, -196.0), 0.0, 0.03, "g_plaza", true, false,
		"In the paving at the foot of the garden path, laid into the stone itself. Whoever built the plaza had put it there on purpose.", true)


# ------------------------------------------------------------------ bounds

func _bounds() -> void:
	solid_box(Vector3(2, 40, 600), Vector3(-46, 20, -100))
	solid_box(Vector3(2, 40, 600), Vector3(46, 20, -100))
	solid_box(Vector3(200, 40, 2), Vector3(0, 20, 134))
	solid_box(Vector3(200, 40, 2), Vector3(0, 20, -300))


# ------------------------------------------------------------------ the eye

func open_eye() -> void:
	tower_eye_open = true
	tower_eye.visible = true
	tower_eye.scale = Vector3(1, 0.02, 1)
	var tw := create_tween()
	tw.tween_property(tower_eye, "scale", Vector3(1, 1, 1), 4.0).set_trans(Tween.TRANS_SINE)



func tick(delta: float) -> void:
	if fire_light:
		fire_light.light_energy = 2.0 + sin(_t * 13.0) * 0.3 + randf() * 0.4
	if sweeper:
		var a := _t * 0.9
		sweeper.position = Vector3(13.0 + cos(a) * 1.2, 0.12, -62.0 + sin(a) * 1.2)
		sweeper.rotation.y = -a
	for p in pods:
		p.position.z -= delta * 22.0
		if p.position.z < TOWER_Z + 70.0:
			p.position.z = STREET_S + 30.0
	if main and main.player:
		var target: Vector3 = main.player.global_position + Vector3(0, 1.6, 0)
		for c in cameras:
			var dir: Vector3 = target - c.global_position
			if dir.length() < 60.0:
				var want := atan2(-dir.x, -dir.z)
				c.rotation.y = lerp_angle(c.rotation.y, want, delta * 2.0)
		if main.flags.has("eye_open") and not _ended and main.started and main.player.global_position.z < -196.0:
			_ended = true
			_ending()
	if tower_eye_open:
		var breathe := 1.0 + sin(_t * 0.8) * 0.04
		tower_eye.scale = Vector3(breathe, tower_eye.scale.y, 1)


# ------------------------------------------------------------------ the slice's flow

func hifi(env: Environment, _sun: DirectionalLight3D) -> void:
	env.tonemap_exposure *= 1.5
	env.ssr_max_steps = 64  # the wet street carries the neon


func ambience() -> void:
	main.loop("rain", -9.0)
	main.loop("hum", -13.0)
	main.loop("chant", 0.0, Vector3(-13.4, 1.6, 14.0), 3.0, 30.0)
	main.loop("fire", -2.0, Vector3(-30.0, 1.0, -30.0), 2.0, 20.0)


func intro() -> void:
	var ui = main.ui
	await get_tree().create_timer(1.2).timeout
	await ui.think("The Spine. One long boulevard between the places that mattered, and the tower in the middle of it like a pin through a map.")
	await ui.think("The rot never reached the tower. Everything around it existed in anticipation of something, a silent, electric tension humming in the wet air.")
	await ui.think("With the frames on, the walls had started to have opinions.")
	ui.close()


func objective() -> String:
	if main.flags.has("eye_open"):
		return "Walk to the tower."
	elif main.flags.has("outage_done"):
		return "Keep reading the rings. Some of them are red now."
	elif main.frames_on or main.glyphs_found > 0:
		return "Find the two-ring signs with the frames on. E to read them."
	return "Walk the Spine toward the tower.   G puts the frames on."


func on_connection(old: float, new: float) -> void:
	if old < 25.0 and new >= 25.0:
		_outage()
	elif old < 50.0 and new >= 50.0:
		_eye()


func scan_people() -> Array:
	var out := []
	var me: Vector3 = main.player.global_position
	var near: Array = crowd.peds.duplicate()
	near.sort_custom(func(a, b): return a.node.global_position.distance_to(me) < b.node.global_position.distance_to(me))
	for i in mini(5, near.size()):
		var n: Node3D = near[i].node
		var sync := "sync 100%  -  DREAMING" if main.connection >= 25.0 else "sync %d%%" % (90 + (i * 7) % 10)
		out.append([n, "CITIZEN\nPsyon 4.1  -  " + sync + "\nsleep score: 100"])
	return out


func phone() -> String:
	var c: float = main.connection
	var t := "[color=#7fe6b0]Psyon:[/color] Good evening, Carl. You're walking. Your heart rate says you'd rather be driving.\n\n"
	if main.glyphs_found > 0:
		t += "[color=#7fe6b0]Psyon:[/color] You've been reading the walls. I can help with that. Reading is what I'm for.\n\n"
	if c >= 25.0:
		t += "[color=#e08080]Psyon:[/color] The outage was localised and brief. Nobody was looking at you. Everyone was looking at you.\n\n"
	if c >= 50.0:
		t += "[color=#e08080]Psyon:[/color] Gather, sleeper. The tower remembers you. Come closer.\n\n"
	return t


func interact(node: Object) -> bool:
	var ui = main.ui
	var frames_on: bool = main.frames_on
	match str(node.get_meta("id")):
		"preacher":
			await _preacher()
		"vending":
			await ui.think("Psyonic-branded water. Three credits. The screen on the front looped the same ad: a family asleep, smiling, under a logo.")
		"shuttle_stop":
			if frames_on:
				await ui.think("The SalTech shuttle stop. A timetable, and under it, two rings in marker. The shuttle hadn't run since the second incident.")
			else:
				await ui.think("The SalTech shuttle stop. SERVICE SUSPENDED. Something was scrawled under the timetable, too faint to make out in the rain.")
		"tower_sign":
			await ui.think("PSYONIC INTEGRATIONS. The lobby cameras tracked me as I walked by, the way they tracked everyone. The difference was that I used to find that comforting.")
		"camp":
			await ui.think("A camp on the vacant lot. Clean, like the one in the park. Rules. Whoever lived here had rules, and a fire, and nothing that blinked.")
			if frames_on:
				await ui.think("The frames found nothing here to label. No device, no sync score, no name. It was the only quiet place on the street.")
		"charger":
			await ui.think("A charge post for the company fleet. It logged every charge, every trip, every passenger. Free car rides, they'd called it in the offer letter.")
		"my_car":
			await ui.think("My company car, on the charge bay. The microphone in the dash had never once been off. Tonight I wanted to walk.")
		"underpass":
			if main.connection >= 50.0:
				await ui.think("The dark at the bottom of the stairs had a rhythm now. Three even beats and a breath. Somebody down there was keeping time for the whole city.")
			else:
				await ui.think("The stairs down to the underpass and the chant wall. Water ran down them in a sheet, and from the bottom came the sound of something dripping in rhythm. Not tonight.")
		"sweeper":
			await ui.think("A Voltx cleaning bot, sweeping the same square metre of sidewalk. A perfect ring, over and over, and the sand came straight back.")
		"press_1":
			await ui.think("The media scrum, waiting under the tower for a statement.")
			await ui.say("Reporter", "They said nine. It's eleven. They always say nine.")
		"press_2":
			await ui.say("Reporter", "Is it true he said it told him to? The eyeless guy? Off the record. Everything's off the record, nothing records any more.")
		"cop":
			await ui.say("Officer", "Psyonic. Course you are. Shame no surveillance is working on this whole block. Course it isn't.")
		"kiosk":
			await ui.think("A city terminal kiosk. Transit, bills, FreudBot bookings. Someone had scrawled the eye on the inside of the screen bezel. From the inside.")
		"pylon":
			await ui.think("A transit tube pylon. The elevated tubes all ran to the tower; from up there, Turan liked to say, the city looked like circuitry.")
		_:
			return false
	ui.close()
	return true


func _preacher() -> void:
	var ui = main.ui
	if _listened:
		await ui.say("Eyeless man", "Gather, sleeper. Gather.")
		return
	await ui.think("He stood in the middle of the sidewalk with his face turned up to the rain, and where his eyes should have been there was only clean, healed skin.")
	await ui.say("Eyeless man", "Psyon is the pillow for those who dream. Psyon is the path for those who walk.")
	var pick: int = await ui.choose(["Walk on.", "Listen."])
	if pick == 1:
		_listened = true
		await ui.say("Eyeless man", "Close the eyes that lie, and see. The floor is a door. The door is a floor.")
		await ui.think("He said it like a lullaby. I stood there longer than I meant to. The frames had started recording before I told them to.")
		ui.close()
		main.add_connection(4.0, "listened to the preacher")
	else:
		await ui.think("I walked on. Behind me the chant kept the same even pace, like it hadn't needed me at all.")


func _outage() -> void:
	var ui = main.ui
	var player = main.player
	main.flags["outage_seen"] = true
	await get_tree().create_timer(1.0).timeout
	main.outage = true
	main.flags["cinematic"] = true
	main.play("outage", 2.0)
	player.shake(0.7)
	set_power(false, 0.5)
	crowd.everyone_faces(player.global_position)
	create_tween().tween_property(main.amb["hum"], "volume_db", -40.0, 1.0)
	create_tween().tween_property(main.amb["chant"], "volume_db", 6.0, 3.0)
	await get_tree().create_timer(0.8).timeout
	main.flags.erase("cinematic")
	ui.show_toast("The power went. All of it. Every window on the Spine at once. Only the tower stayed lit.", 4.0)
	await get_tree().create_timer(5.0).timeout
	main.play("whisper", -2.0)
	await get_tree().create_timer(4.0).timeout
	for i in 3:
		set_power(true, 0.04)
		await get_tree().create_timer(0.1).timeout
		set_power(false, 0.04)
		await get_tree().create_timer(0.3).timeout
	set_power(true, 0.2)
	crowd.everyone_faces(player.global_position)
	main.play("sting", -2.0)
	ui.flash(0.6)
	ui.glitch(0.6, 0.8)
	create_tween().tween_property(main.amb["hum"], "volume_db", -13.0, 2.0)
	create_tween().tween_property(main.amb["chant"], "volume_db", 0.0, 3.0)
	main.outage = false
	main.flags["outage_done"] = true
	main.update_hud()
	ui.show_toast("When the lights came back, every one of them was looking at me.", 5.0)


func _eye() -> void:
	var ui = main.ui
	main.flags["eye_open"] = true
	await get_tree().create_timer(1.0).timeout
	main.flags["cinematic"] = true
	main.play("sting", 0.0, 0.8)
	ui.glitch(1.0, 1.6)
	main.player.shake(0.5)
	open_eye()
	await main.player.face(Vector3(0, 540.0, TOWER_Z), 2.2)
	main.play("whisper", 0.0, 0.9)
	ui.show_toast("The tower was looking back.", 5.0)
	await get_tree().create_timer(2.0).timeout
	main.flags.erase("cinematic")
	main.update_hud()


func _ending() -> void:
	var ui = main.ui
	main.flags["cinematic"] = true
	await ui.think("The garden path. Cacti and palms, a sterile nod to the desert outside. The cameras on their poles turned to watch me come.")
	await ui.think("Up there, in the middle of the donut on its stick, the eye didn't blink. It didn't need to. It had been watching me since I was a kid craning my neck at it.")
	ui.close()
	main.flags.erase("cinematic")
	ui.show_end("[center]\n\n\n[b]END OF THE TEST SLICE[/b]\n\n"
		+ "Rings read: %d of %d        Connection: %d\n\n" % [main.glyphs_found, glyphs.size(), int(main.connection)]
		+ "[color=#aaaaaa]A first-person test of Silico, built from the book.\nThe tower lobby, the flats and the lab under them would come next.[/color]\n\n"
		+ "[color=#777777]E to keep walking    M for the menu[/color][/center]")


## Dev args for shots: the outage frozen, the eye open.
func apply_args(a: Dictionary) -> void:
	if main.connection >= 25.0:
		main.flags["outage_seen"] = true
		main.flags["outage_done"] = true
	if main.connection >= 50.0 or a.has("eye"):
		main.flags["eye_open"] = true
		open_eye()
	if a.has("outage"):
		main.outage = true
		set_power(false, 0.01)
		crowd.everyone_faces(main.player.global_position)
