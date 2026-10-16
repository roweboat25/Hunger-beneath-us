extends Node3D
## Base for every place Carl can stand in: the build helpers (shared
## materials, boxes, labels, lights, things to examine, glyphs, people),
## mesh batching for the browser build, the power grid, and the hooks Main
## calls (intro, interact, objective, connection thresholds, the phone).

const Tex := preload("res://scripts/Tex.gd")

var main: Node
var rng := RandomNumberGenerator.new()

## Where Carl stands when the level loads, and which way he faces (degrees).
var spawn := Vector3.ZERO
var spawn_yaw := 0.0
## Rain on the player, and the chapter card shown on load.
var rain := false
var card := ""
## Footstep loudness: carpet and grass are quieter than wet concrete.
var step_db := -16.0

var lamps: Array = []          # [OmniLight3D, base energy]
var power_mats: Array = []     # [material, on value, property, off value]
var neon_labels: Array = []    # [Label3D, base modulate]
var screens: Array = []        # [Node3D normal content, Sprite3D eye glyph]
var flickers: Array = []       # nodes that stutter
var blinkers: Array = []       # red aircraft lights
var glyphs: Array = []         # Area3D
var no_batch: Array = []       # meshes that move or change, kept out of _batch
var powered := true
var _t := 0.0
var _glyph_tex: Texture2D
var _mat_cache := {}


func _init() -> void:
	_glyph_tex = Tex.glyph()


# ------------------------------------------------------------------ level hooks (override)

func build(m: Node) -> void:
	main = m


## Sky, fog and light for this place. Main resets to night first.
func setup_env(_env: Environment, _sun: DirectionalLight3D) -> void:
	pass


## Looping sounds, via main.loop().
func ambience() -> void:
	pass


## Runs once Carl can move.
func intro() -> void:
	pass


## Return true if the level handled it.
func interact(_node: Object) -> bool:
	return false


func objective() -> String:
	return ""


func on_connection(_old: float, _new: float) -> void:
	pass


## The Psyon chat on Carl's phone (P).
func phone() -> String:
	return "[b]PSYON[/b]\n\n[color=#7fe6b0]Psyon:[/color] Good afternoon, Carl.\n\n"


## People for the scan to label: [[Node3D, text], ...]
func scan_people() -> Array:
	return []


func tick(_delta: float) -> void:
	pass


func on_glyph(_g: Object) -> void:
	pass


## Dev args (see Main.gd) after the level has loaded.
func apply_args(_a: Dictionary) -> void:
	pass


## Headless run of the level's scenes (Main.selftest).
func selftest() -> void:
	await main.selftest_all_interactables()


# ------------------------------------------------------------------ helpers

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


func tex_mat(t: Texture2D, scale := Vector3.ONE, rough := 0.85, triplanar := false) -> StandardMaterial3D:
	var m := newmat(Color(1, 1, 1), rough)
	m.albedo_texture = t
	m.uv1_scale = scale
	if triplanar:
		m.uv1_triplanar = true
		m.uv1_world_triplanar = true
	return m


## A see-through decal-like material (blood, sand, paint) with alpha.
func decal_mat(t: Texture2D, c: Color, rough := 0.6) -> StandardMaterial3D:
	var m := newmat(c, rough)
	m.albedo_texture = t
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
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


func sphere(r: float, pos: Vector3, material: Material, segs := 12, parent: Node = self) -> MeshInstance3D:
	var sm := SphereMesh.new()
	sm.radius = r
	sm.height = r * 2.0
	sm.radial_segments = segs
	sm.rings = maxi(4, segs / 2)
	return mesh(sm, pos, material, parent)


func quad(size: Vector2, pos: Vector3, rot_y: float, material: Material, parent: Node = self) -> MeshInstance3D:
	var qm := QuadMesh.new()
	qm.size = size
	var mi := mesh(qm, pos, material, parent)
	mi.rotation.y = rot_y
	return mi


## A flat quad lying on the floor (or stuck to a ceiling when up is false).
func floor_quad(size: Vector2, pos: Vector3, rot_y: float, material: Material, parent: Node = self, up := true) -> MeshInstance3D:
	var pm := PlaneMesh.new()
	pm.size = size
	if not up:
		pm.flip_faces = true
	var mi := mesh(pm, pos, material, parent)
	mi.rotation.y = rot_y
	return mi


## A thin stick from a to b (sticks, wires, optic nerves, tape).
func stick(a: Vector3, b: Vector3, r: float, material: Material, parent: Node = self) -> MeshInstance3D:
	var cm := CylinderMesh.new()
	cm.top_radius = r
	cm.bottom_radius = r
	cm.height = a.distance_to(b)
	cm.radial_segments = 5
	cm.rings = 1
	var mi := MeshInstance3D.new()
	mi.mesh = cm
	mi.material_override = material
	var mid := (a + b) / 2.0
	var dir := (b - a).normalized()
	var up := Vector3.UP
	var axis := up.cross(dir)
	var basis := Basis()
	if axis.length() > 0.0001:
		basis = Basis(axis.normalized(), up.angle_to(dir))
	elif dir.y < 0.0:
		basis = Basis(Vector3.RIGHT, PI)
	mi.transform = Transform3D(basis, mid)
	parent.add_child(mi)
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


## Turn an interactable on or off (hidden ones can't be looked at).
func set_active(body: CollisionObject3D, on: bool) -> void:
	if body is StaticBody3D:
		body.collision_layer = (1 | 2) if on else 1
	else:
		body.collision_layer = 2 if on else 0


# ------------------------------------------------------------------ people

## A low-poly person facing -Z. Deliberately plain: placeholders for real
## models. opts: visor (bool), arms (separate, posable), hair (Color),
## long_hair, legs (Color), scale.
func figure(coat: Color, skin: Color, opts := {}) -> Node3D:
	var root := Node3D.new()
	var coat_m: StandardMaterial3D = mat(coat, 0.7)
	var skin_m: StandardMaterial3D = mat(skin, 0.6)
	var leg_m: StandardMaterial3D = mat(opts.get("legs", Color(0.06, 0.06, 0.07)))
	var legs := []
	for side: float in [-1.0, 1.0]:
		var hip := Node3D.new()
		hip.position = Vector3(side * 0.1, 0.86, 0)
		root.add_child(hip)
		box(Vector3(0.14, 0.86, 0.16), Vector3(0, -0.43, 0), leg_m, false, hip)
		legs.append(hip)
	# coat, torso and (for walkers) arms as one mesh: fewer draw calls
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var skirt := CylinderMesh.new()
	skirt.top_radius = 0.22
	skirt.bottom_radius = 0.3
	skirt.height = 0.55
	skirt.radial_segments = 10
	skirt.rings = 1
	st.append_from(skirt, 0, Transform3D(Basis(), Vector3(0, 0.95, 0)))
	var cm := CapsuleMesh.new()
	cm.radius = 0.21
	cm.height = 0.75
	cm.radial_segments = 10
	cm.rings = 4
	st.append_from(cm, 0, Transform3D(Basis(), Vector3(0, 1.3, 0)))
	var am := CapsuleMesh.new()
	am.radius = 0.065
	am.height = 0.7
	am.radial_segments = 6
	am.rings = 2
	var arms := []
	for side: float in [-1.0, 1.0]:
		if opts.get("arms", false):
			var sh := Node3D.new()
			sh.position = Vector3(side * 0.26, 1.55, 0)
			root.add_child(sh)
			mesh(am, Vector3(0, -0.33, 0), coat_m, sh)
			arms.append(sh)
		else:
			st.append_from(am, 0, Transform3D(Basis(), Vector3(side * 0.26, 1.22, 0)))
	var body := MeshInstance3D.new()
	body.mesh = st.commit()
	body.material_override = coat_m
	root.add_child(body)
	var head := Node3D.new()
	head.position = Vector3(0, 1.72, 0)
	root.add_child(head)
	var hm := SphereMesh.new()
	hm.radius = 0.12
	hm.height = 0.27
	hm.radial_segments = 12
	hm.rings = 6
	mesh(hm, Vector3.ZERO, skin_m, head)
	var hair_c: Color = opts.get("hair", Color(0.05, 0.04, 0.04))
	var hair := SphereMesh.new()
	hair.radius = 0.125
	hair.height = 0.16
	hair.radial_segments = 12
	hair.rings = 4
	mesh(hair, Vector3(0, 0.07, 0.02), mat(hair_c, 0.9), head)
	if opts.get("long_hair", false):
		box(Vector3(0.24, 0.32, 0.08), Vector3(0, -0.1, 0.1), mat(hair_c, 0.9), false, head)
	var v: MeshInstance3D = null
	if opts.get("visor", false):
		v = box(Vector3(0.21, 0.045, 0.03), Vector3(0, 0.02, -0.11), glow(Color(0.3, 0.95, 1.0), 3.0), false, head)
	root.set_meta("legs", legs)
	root.set_meta("arms", arms)
	root.set_meta("head", head)
	root.set_meta("visor", v)
	root.set_meta("body", body)
	if opts.has("scale"):
		root.scale = Vector3.ONE * float(opts["scale"])
	return root


## Something for Carl to talk to, wrapped around a figure.
func person(id: String, prompt: String, fig: Node3D, scan := "") -> CollisionObject3D:
	return interactable(id, prompt, Vector3(0, 0.9, 0), Vector3(0.7, 1.9, 0.7), scan, true, fig)


## Turn a figure to face a point, over t seconds (0 = at once).
func turn_to(fig: Node3D, point: Vector3, t := 0.0) -> void:
	var d := point - fig.global_position
	var want := atan2(-d.x, -d.z)
	if t <= 0.0:
		fig.rotation.y = want
	else:
		create_tween().tween_property(fig, "rotation:y", fig.rotation.y + wrapf(want - fig.rotation.y, -PI, PI), t)


# ------------------------------------------------------------------ batching

## Merge static meshes that share a material into one mesh per stretch of
## `chunk` metres. Fewer draw calls keeps the browser build alive (it went
## blank past ~1000 objects), and the stretches stay small enough for the
## per-object light limit.
func _batch(parent: Node, chunk: float, by_x := false) -> void:
	var skip := {}
	for b in blinkers:
		skip[b] = true
	for sc in screens:
		skip[sc[0]] = true
	for n in no_batch:
		skip[n] = true
	var groups := {}
	for c in parent.get_children():
		if not (c is MeshInstance3D) or skip.has(c) or c.material_override == null:
			continue
		var mi := c as MeshInstance3D
		var cx := int(floor(mi.position.x / chunk)) if by_x else 0
		var key := "%d:%d:%d" % [mi.material_override.get_instance_id(), int(floor(mi.position.z / chunk)), cx]
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

func _glyph_on(pos: Vector3, rot_y: float, px: float, id: String, deep: bool, always: bool, desc: String, flat := false, tint := Color(0, 0, 0, 0)) -> Area3D:
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
	s.shaded = always
	s.double_sided = false
	s.modulate = Color(1.0, 0.12, 0.08) if deep else (Color(0.85, 0.85, 0.8) if always else Color(0.35, 1.0, 0.9))
	if tint.a > 0.0:
		s.modulate = tint
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
	return a


func set_glyph_visibility(frames_on: bool, connection: float) -> void:
	for g in glyphs:
		var vis: bool = g.get_meta("always") or (frames_on and (not g.get_meta("deep") or connection >= 25.0))
		(g.get_meta("sprite") as Sprite3D).visible = vis
		g.collision_layer = 2 if vis else 0


# ------------------------------------------------------------------ power

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
	tick(delta)
