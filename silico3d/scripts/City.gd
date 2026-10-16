extends Node3D
## Builds the Spine from code: the boulevard, the blocks either side, the
## vacant lot with the camp, the transit tube, the plaza and the tower.
## Layout (metres): the street runs north along -Z from the underpass (z 130)
## to the plaza (z -170); the tower stands at z -330.
## Book, ch. 3: "a jade-and-silver nail driven into the city's spine", a donut
## on a stick, the base "like musculature ... four pairs of biceps", a garden
## path of cacti and palms, transit tubes converging on it, drones like bees.

const Tex := preload("res://scripts/Tex.gd")

const STREET_S := 130.0
const STREET_N := -170.0
const TOWER_Z := -330.0
const FRONT := 17.0  # building fronts at x = +-17

var main: Node
var rng := RandomNumberGenerator.new()

var lamps: Array = []          # [OmniLight3D, base energy]
var power_mats: Array = []     # [StandardMaterial3D, base emission energy]
var neon_labels: Array = []    # [Label3D, base modulate]
var screens: Array = []        # [Node3D normal content, Sprite3D eye glyph]
var flickers: Array = []       # OmniLight3D that stutter
var blinkers: Array = []       # MeshInstance3D red aircraft lights
var cameras: Array = []        # Node3D lobby cameras that track Carl
var glyphs: Array = []         # Area3D
var pods: Array = []
var tower_eye: MeshInstance3D
var tower_eye_open := false
var fire_light: OmniLight3D
var sweeper: Node3D
var powered := true
var _t := 0.0

var _concrete: StandardMaterial3D
var _jade: StandardMaterial3D
var _metal: StandardMaterial3D
var _glyph_tex: Texture2D


func build(m: Node) -> void:
	main = m
	rng.seed = 1984
	_glyph_tex = Tex.glyph()
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


# ------------------------------------------------------------------ helpers

var _mat_cache := {}


## Shared materials: the browser renderer falls over with hundreds of unique
## materials, so identical ones are reused. Use newmat/newglow to mutate.
func mat(c: Color, rough := 0.85, metal := 0.0) -> StandardMaterial3D:
	var key := "m%s|%.2f|%.2f" % [c, rough, metal]
	if not _mat_cache.has(key):
		_mat_cache[key] = newmat(c, rough, metal)
	return _mat_cache[key]


func newmat(c: Color, rough := 0.85, metal := 0.0) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = c
	m.roughness = rough
	m.metallic = metal
	return m


func glow(c: Color, energy := 2.0, powered_by_grid := false) -> StandardMaterial3D:
	var key := "g%s|%.2f|%s" % [c, energy, powered_by_grid]
	if not _mat_cache.has(key):
		_mat_cache[key] = newglow(c, energy, powered_by_grid)
	return _mat_cache[key]


func newglow(c: Color, energy := 2.0, powered_by_grid := false) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = Color(0, 0, 0)
	m.emission_enabled = true
	m.emission = c
	m.emission_energy_multiplier = energy
	if powered_by_grid:
		power_mats.append([m, energy, "emission_energy_multiplier", 0.02])
	return m


func mesh(mesh_res: Mesh, pos: Vector3, material: Material, parent: Node = self) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.mesh = mesh_res
	mi.position = pos
	mi.material_override = material
	parent.add_child(mi)
	return mi


func box(size: Vector3, pos: Vector3, material: Material, solid := false, parent: Node = self) -> MeshInstance3D:
	var bm := BoxMesh.new()
	bm.size = size
	var mi := mesh(bm, pos, material, parent)
	if solid:
		solid_box(size, pos, parent)
	return mi


func solid_box(size: Vector3, pos: Vector3, parent: Node = self) -> StaticBody3D:
	var sb := StaticBody3D.new()
	sb.collision_layer = 1
	sb.position = pos
	var cs := CollisionShape3D.new()
	var sh := BoxShape3D.new()
	sh.size = size
	cs.shape = sh
	sb.add_child(cs)
	parent.add_child(sb)
	return sb


func cyl(r_top: float, r_bot: float, h: float, pos: Vector3, material: Material, segs := 16, parent: Node = self) -> MeshInstance3D:
	var cm := CylinderMesh.new()
	cm.top_radius = r_top
	cm.bottom_radius = r_bot
	cm.height = h
	cm.radial_segments = segs
	cm.rings = 1
	return mesh(cm, pos, material, parent)


func quad(size: Vector2, pos: Vector3, rot_y: float, material: Material, parent: Node = self) -> MeshInstance3D:
	var qm := QuadMesh.new()
	qm.size = size
	var mi := mesh(qm, pos, material, parent)
	mi.rotation.y = rot_y
	return mi


func label(text: String, pos: Vector3, rot_y: float, px: float, color: Color, parent: Node = self, neon := true) -> Label3D:
	var l := Label3D.new()
	l.text = text
	l.position = pos
	l.rotation.y = rot_y
	l.pixel_size = px
	l.font_size = 96
	l.outline_size = 0
	l.modulate = color
	l.double_sided = false
	parent.add_child(l)
	if neon:
		neon_labels.append([l, color])
	return l


func light(pos: Vector3, c: Color, energy: float, rng_m: float, on_grid := true) -> OmniLight3D:
	var o := OmniLight3D.new()
	o.position = pos
	o.light_color = c
	o.light_energy = energy
	o.omni_range = rng_m
	o.omni_attenuation = 1.4
	o.shadow_enabled = false
	add_child(o)
	if on_grid:
		lamps.append([o, energy])
	return o


## Something Carl can look at and examine with E. Solid ones block walking.
func interactable(id: String, prompt: String, pos: Vector3, size: Vector3, scan := "", solid := true, parent: Node = self) -> CollisionObject3D:
	var body: CollisionObject3D
	if solid:
		body = StaticBody3D.new()
		body.collision_layer = 1 | 2
	else:
		body = Area3D.new()
		body.collision_layer = 2
		body.collision_mask = 0
		(body as Area3D).monitoring = false
	body.position = pos
	var cs := CollisionShape3D.new()
	var sh := BoxShape3D.new()
	sh.size = size
	cs.shape = sh
	body.add_child(cs)
	body.set_meta("id", id)
	body.set_meta("prompt", prompt)
	if scan != "":
		body.set_meta("scan", scan)
	parent.add_child(body)
	return body


# ------------------------------------------------------------------ ground and road

func _ground() -> void:
	solid_box(Vector3(400, 2, 600), Vector3(0, -1.0, -100))
	var pm := PlaneMesh.new()
	pm.size = Vector2(600, 900)
	mesh(pm, Vector3(0, -0.02, -150), mat(Color(0.06, 0.05, 0.05)))


func _road() -> void:
	var asphalt := newmat(Color(1, 1, 1), 0.22)
	asphalt.albedo_texture = Tex.asphalt()
	asphalt.uv1_scale = Vector3(2.5, 2.5, 1)
	var paving := newmat(Color(1, 1, 1), 0.5)
	paving.albedo_texture = Tex.paving()
	paving.uv1_scale = Vector3(1.75, 5.0, 1)
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
	_batch(root, 10000.0)


# ------------------------------------------------------------------ batching

## Merge static meshes that share a material into one mesh per 40 m stretch.
## Fewer draw calls keeps the browser build alive (it went blank past ~1000
## objects), and the stretches stay small enough for the per-object light
## limit, so streetlights still light the pieces near them.
func _batch(parent: Node, chunk: float) -> void:
	var skip := {}
	for b in blinkers:
		skip[b] = true
	for sc in screens:
		skip[sc[0]] = true
	if tower_eye:
		skip[tower_eye] = true
	var groups := {}
	for c in parent.get_children():
		if not (c is MeshInstance3D) or skip.has(c) or c.material_override == null:
			continue
		var mi := c as MeshInstance3D
		var key := "%d:%d" % [mi.material_override.get_instance_id(), int(floor(mi.position.z / chunk))]
		if not groups.has(key):
			groups[key] = []
		groups[key].append(mi)
	for key in groups:
		var list: Array = groups[key]
		if list.size() < 2:
			continue
		var st := SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		for mi in list:
			st.append_from(mi.mesh, 0, mi.transform)
		var merged := MeshInstance3D.new()
		merged.mesh = st.commit()
		merged.material_override = list[0].material_override
		parent.add_child(merged)
		for mi in list:
			parent.remove_child(mi)
			mi.free()


# ------------------------------------------------------------------ glyphs

func _glyph_on(pos: Vector3, rot_y: float, px: float, id: String, deep: bool, always: bool, desc: String, flat := false) -> void:
	var a := Area3D.new()
	a.collision_layer = 2
	a.collision_mask = 0
	a.monitoring = false
	a.position = pos
	var cs := CollisionShape3D.new()
	var sh := BoxShape3D.new()
	var w := 128.0 * px
	sh.size = Vector3(w, 0.4, w) if flat else Vector3(w, w, 0.4)
	cs.shape = sh
	a.add_child(cs)
	var s := Sprite3D.new()
	s.texture = _glyph_tex
	s.pixel_size = px
	s.shaded = false
	s.double_sided = false
	s.modulate = Color(1.0, 0.12, 0.08) if deep else (Color(0.85, 0.85, 0.8) if always else Color(0.35, 1.0, 0.9))
	if flat:
		s.rotation.x = -PI / 2.0
	a.add_child(s)
	a.rotation.y = rot_y
	a.set_meta("id", id)
	a.set_meta("glyph", true)
	a.set_meta("deep", deep)
	a.set_meta("always", always)
	a.set_meta("desc", desc)
	a.set_meta("prompt", "Examine the rings")
	a.set_meta("found", false)
	a.set_meta("sprite", s)
	add_child(a)
	glyphs.append(a)


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


func set_glyph_visibility(frames_on: bool, connection: float) -> void:
	for g in glyphs:
		var vis: bool = g.get_meta("always") or (frames_on and (not g.get_meta("deep") or connection >= 25.0))
		(g.get_meta("sprite") as Sprite3D).visible = vis
		g.collision_layer = 2 if vis else 0


# ------------------------------------------------------------------ bounds

func _bounds() -> void:
	solid_box(Vector3(2, 40, 600), Vector3(-46, 20, -100))
	solid_box(Vector3(2, 40, 600), Vector3(46, 20, -100))
	solid_box(Vector3(200, 40, 2), Vector3(0, 20, 134))
	solid_box(Vector3(200, 40, 2), Vector3(0, 20, -300))


# ------------------------------------------------------------------ power and the eye

func set_power(on: bool, t := 1.5) -> void:
	powered = on
	var tw := create_tween().set_parallel(true)
	for l in lamps:
		tw.tween_property(l[0], "light_energy", l[1] if on else 0.0, t)
	for m in power_mats:
		tw.tween_property(m[0], m[2], m[1] if on else m[3], t)
	for n in neon_labels:
		tw.tween_property(n[0], "modulate", n[1] if on else Color(0.04, 0.04, 0.05), t)
	for s in screens:
		s[1].visible = not on


func open_eye() -> void:
	tower_eye_open = true
	tower_eye.visible = true
	tower_eye.scale = Vector3(1, 0.02, 1)
	var tw := create_tween()
	tw.tween_property(tower_eye, "scale", Vector3(1, 1, 1), 4.0).set_trans(Tween.TRANS_SINE)


func _process(delta: float) -> void:
	_t += delta
	var blink := fmod(_t, 1.6) < 0.25
	for b in blinkers:
		b.visible = blink
	if powered:
		for f in flickers:
			if randf() < 0.04:
				f.visible = not f.visible
			elif not f.visible and randf() < 0.2:
				f.visible = true
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
	if tower_eye_open:
		var breathe := 1.0 + sin(_t * 0.8) * 0.04
		tower_eye.scale = Vector3(breathe, tower_eye.scale.y, 1)
