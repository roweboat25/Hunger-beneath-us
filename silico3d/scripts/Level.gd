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
## The city kit (cyber_block and friends) builds into this node; set it to a
## child node to batch a district separately, and kit_day for daylight.
var kit_parent: Node
var kit_day := true
var kit_dead := false
var _kit := {}
var _fo := Vector3.ZERO
var _fr := 0.0


func _init() -> void:
	_glyph_tex = Tex.glyph()
	kit_parent = self


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
## Extra tuning for the desktop renderer (shadowed lamps and the like).
func hifi(_env: Environment, _sun: DirectionalLight3D) -> void:
	pass


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


## A prop from the free kit in assets/kit/ (CC0 Poly Haven scans, photo-box
## machines, TripoSR drones; names in levels/PropKit.gd, `level=PropKit` to
## review). Scale 1 is real size. `solid` adds a box collider from the mesh
## bounds so the player cannot walk through it. Returns null if missing.
func prop(name: String, pos: Vector3, rot_y := 0.0, scale := 1.0, solid := true, parent: Node = self) -> Node3D:
	var scene: PackedScene = load("res://assets/kit/%s.glb" % name)
	if scene == null:
		push_warning("kit prop missing: " + name)
		return null
	var n: Node3D = scene.instantiate()
	n.position = pos
	n.rotation.y = rot_y
	n.scale = Vector3.ONE * scale
	parent.add_child(n)
	if solid:
		var bb := AABB()
		for mi in n.find_children("*", "MeshInstance3D", true, false):
			var m := mi as MeshInstance3D
			var a := m.get_aabb()
			a.position = m.position + a.position * m.scale
			a.size *= m.scale
			bb = a if bb.size == Vector3.ZERO else bb.merge(a)
		if bb.size != Vector3.ZERO:
			var body := StaticBody3D.new()
			var cs := CollisionShape3D.new()
			var sh := BoxShape3D.new()
			sh.size = bb.size * scale
			cs.shape = sh
			cs.position = (bb.position + bb.size * 0.5) * scale
			body.add_child(cs)
			body.position = pos
			body.rotation.y = rot_y
			parent.add_child(body)
	return n


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
	if not opts.get("old", false):
		return Body.build(self, coat, skin, opts)
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


## A photographed PBR material from assets/pbr/<name> (ambientCG, CC0):
## colour, normal and roughness maps. `scale` repeats it per metre when
## triplanar, or per quad otherwise.
func pbr(name: String, scale := Vector3.ONE, triplanar := false, tint := Color(1, 1, 1), rough_mul := 1.0) -> StandardMaterial3D:
	var key := "pbr%s|%s|%s|%s|%.2f" % [name, scale, triplanar, tint, rough_mul]
	if _mat_cache.has(key):
		return _mat_cache[key]
	var base := "res://assets/pbr/%s/" % name
	var m := StandardMaterial3D.new()
	m.albedo_texture = load(base + "albedo.jpg")
	m.albedo_color = tint
	m.normal_enabled = true
	m.normal_texture = load(base + "normal.jpg")
	m.normal_scale = 1.0
	m.roughness_texture = load(base + "rough.jpg")
	m.roughness = rough_mul
	if ResourceLoader.exists(base + "metal.jpg"):
		m.metallic_texture = load(base + "metal.jpg")
		m.metallic = 1.0
	m.uv1_scale = scale
	if triplanar:
		m.uv1_triplanar = true
		m.uv1_world_triplanar = true
	m.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	_mat_cache[key] = m
	return m


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


## The browser renderer goes blank past ~1000 draw calls. After build(), if a
## level still shows more than LATE_BATCH_AT meshes, merge the ones nothing can
## touch again: unnamed, no script, no meta, no children, not held by any of
## the level's variables (arrays and dictionaries included), and with no
## ancestor carrying a script or meta (figures, interactables). Merged meshes
## stay under the same parent, so area groups still show and hide together.
const LATE_BATCH_AT := 700
var _held_mats := {}


func late_batch(chunk := 200.0) -> int:
	var all := find_children("*", "MeshInstance3D", true, false)
	if all.size() <= LATE_BATCH_AT:
		return 0
	var held := {}
	for pr in get_property_list():
		if pr["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE:
			_collect_held(get(pr["name"]), held, 0)
	var groups := {}
	var sigs := {}
	for n in all:
		var mi := n as MeshInstance3D
		if held.has(mi) or mi.mesh == null or mi.material_override == null or not mi.visible:
			continue
		if not str(mi.name).begins_with("@") or mi.get_script() != null or mi.get_child_count() > 0 or mi.get_meta_list().size() > 0:
			continue
		if mi.mesh.get_surface_count() != 1:
			continue
		var ok := true
		var a := mi.get_parent()
		while a != self:
			if a == null or a.get_script() != null or a.get_meta_list().size() > 0 or not (a is Node3D) or a is MultiMeshInstance3D:
				ok = false
				break
			a = a.get_parent()
		if not ok:
			continue
		var par := mi.get_parent()
		var key := "%d:%s:%d:%d" % [par.get_instance_id(), _mat_sig(mi.material_override, sigs), int(floor(mi.position.x / chunk)), int(floor(mi.position.z / chunk))]
		if not groups.has(key):
			groups[key] = []
		groups[key].append(mi)
	if OS.get_cmdline_user_args().has("--batchdiag"):
		var single := 0
		var mats := {}
		for key in groups:
			if groups[key].size() == 1:
				single += 1
			mats[groups[key][0].material_override] = true
		var nheld := 0
		for n in all:
			if held.has(n):
				nheld += 1
		var sigset := {}
		var tex := 0
		for m in sigs:
			sigset[sigs[m]] = true
			if m is StandardMaterial3D and (m.albedo_texture != null or m.emission_texture != null):
				tex += 1
		var ycount := {}
		for key in groups:
			if groups[key].size() == 1:
				var parts: PackedStringArray = key.split(":")
				var k2 := parts[0] + ":" + parts[1]
				ycount[k2] = ycount.get(k2, 0) + 1
		var multi := 0
		for k2 in ycount:
			if ycount[k2] > 1:
				multi += ycount[k2]
		print("batchdiag sigs=", sigset.size(), " textured=", tex, " singles sharing a sig with another single=", multi)
		print("batchdiag all=", all.size(), " held=", nheld, " groups=", groups.size(), " singles=", single, " materials=", mats.size())
	var freed := 0
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
		merged.cast_shadow = list[0].cast_shadow
		var par: Node = list[0].get_parent()
		par.add_child(merged)
		for mi in list:
			par.remove_child(mi)
			mi.free()
		freed += list.size() - 1
	return freed


## Materials made one per call with the same settings draw the same, so
## they merge as one. Anything held elsewhere (tweens, power_mats) keeps its
## own identity through the instance id of held materials in the signature.
func _mat_sig(m: Material, sigs: Dictionary) -> String:
	if sigs.has(m):
		return sigs[m]
	var sig := str(m.get_instance_id())
	if m is StandardMaterial3D and not _held_mats.has(m):
		var parts := PackedStringArray()
		for pr in m.get_property_list():
			if pr["usage"] & PROPERTY_USAGE_STORAGE:
				var v = m.get(pr["name"])
				parts.append(str(v.get_instance_id()) if v is Object else str(v))
		sig = "S" + str(hash("|".join(parts)))
	sigs[m] = sig
	return sig


func _collect_held(v, held: Dictionary, depth: int) -> void:
	if depth > 4:
		return
	if v is Object:
		if is_instance_valid(v) and v is Node:
			held[v] = true
		elif is_instance_valid(v) and v is Material:
			_held_mats[v] = true
	elif v is Array:
		for x in v:
			_collect_held(x, held, depth + 1)
	elif v is Dictionary:
		for k in v:
			_collect_held(k, held, depth + 1)
			_collect_held(v[k], held, depth + 1)


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


# ------------------------------------------------------------------ city kit

## Every block in Silico sells something. Brands from the book (Psyonic,
## Voltx, Nixtra, Tokz, Freudbot, Psymatchbot, SalTech, Ionware, Virtec,
## Alto Energy, Lushon) and the street trades AI left people with.
const KIT_SHOPS := ["NOODLES", "24H", "REPAIR", "SLEEP PODS", "PHARMA", "KARAOKE", "PAWN", "DUMPLINGS",
	"CHARGE", "CLINIC", "LUSHON", "VOLTX", "NIXTRA", "TOKZ", "FREUDBOT", "SALTECH", "IONWARE", "VIRTEC",
	"PSYON STORE", "PARTS", "RAMEN", "LIQUOR"]
const KIT_BLADES := ["PSYON", "TOKZ", "HOTEL", "NIXTRA", "24H", "SALTECH", "BAR", "VOLTX", "PODS",
	"ORA", "IONWARE", "LUSHON", "CLINIC", "VIRTEC"]
const KIT_ADS := [["PSYON", "the pillow for those who dream"], ["SILICO", "where AI solves every problem"],
	["ORA", "always watching over you"], ["NIXTRA", "a new flavour: CALM"],
	["TOKZ", "sleep better. sleep together."], ["FREUDBOT", "talk to someone who listens"],
	["VOLTX", "the grid that never sleeps"], ["PSYMATCHBOT", "she already knows you"],
	["SALTECH", "your body, optimized"], ["ALTO ENERGY", "clean power, clean conscience"],
	["PSYONIC", "customer satisfaction is our greatest priority"], ["IONWARE", "think faster"]]
const KIT_NEON := [Color(1.0, 0.18, 0.62), Color(0.1, 0.92, 1.0), Color(1.0, 0.5, 0.12),
	Color(0.62, 0.28, 1.0), Color(0.3, 1.0, 0.5), Color(1.0, 0.85, 0.25), Color(1.0, 0.12, 0.15)]


func _kit_mats() -> Dictionary:
	var key := "day" if kit_day else "night"
	if _kit.has(key):
		return _kit[key]
	var d := {}
	var walls := []
	var lits := []
	var tints := [Color(1.05, 1.0, 0.95), Color(0.95, 1.0, 1.05), Color(1.0, 1.0, 1.0),
		Color(1.12, 1.02, 0.9), Color(0.9, 0.95, 1.0), Color(1.0, 0.92, 0.9)]
	for i in 6:
		var style := i % 3
		# painted facades (tools/gen_facades.py): 10.5 m a tile, three floors of four bays
		var fb := "res://assets/facades/f%d_" % i
		var w := newmat(tints[i] * (0.85 if kit_day else 0.55), 1.0, 0.3 if style == 1 else 0.0)
		w.albedo_texture = load(fb + "albedo.png")
		w.normal_enabled = true
		w.normal_texture = load(fb + "normal.png")
		w.roughness_texture = load(fb + "rough.png")
		w.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
		w.uv1_triplanar = true
		w.uv1_world_triplanar = true
		w.uv1_scale = Vector3(1, 1, 1) / 10.5
		var lit := StandardMaterial3D.new()
		lit.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		lit.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
		lit.albedo_texture = load(fb + "emit.png")
		lit.uv1_triplanar = true
		lit.uv1_world_triplanar = true
		lit.uv1_scale = Vector3(1, 1, 1) / 10.5
		lit.albedo_color = Color(0.5, 0.5, 0.5) if kit_day else Color(1, 1, 1)
		lit.disable_fog = true  # fog on an additive layer adds the fog colour to the whole face
		power_mats.append([lit, lit.albedo_color, "albedo_color", Color(0, 0, 0)])
		walls.append(w)
		lits.append(lit)
	d["walls"] = walls
	d["lits"] = lits
	d["metal"] = mat(Color(0.32, 0.33, 0.35), 0.5, 0.6)
	d["dark"] = mat(Color(0.06, 0.06, 0.07), 0.6, 0.3)
	d["rust"] = mat(Color(0.36, 0.24, 0.17), 0.8, 0.3)
	d["cable"] = mat(Color(0.04, 0.04, 0.04), 0.7)
	var gl := StandardMaterial3D.new()
	gl.albedo_color = Color(0.05, 0.08, 0.1, 0.3)
	gl.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	gl.roughness = 0.05
	gl.metallic = 0.6
	gl.cull_mode = BaseMaterial3D.CULL_DISABLED
	d["glass"] = gl
	d["plinth"] = pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.6, 0.58, 0.55))
	_kit[key] = d
	return d


## A lit shop behind glass on the current kit face (_fo/_fr): painted
## interior, glass, mullions, a door. `w` is the glass width.
func kit_shop(w: float, c: Color) -> void:
	var k := _kit_mats()
	_fquad(Vector2(w, 2.8), 0, 1.6, 0.03, _shop_mat(rng.randi() % 4, c))
	_fquad(Vector2(w, 2.8), 0, 1.6, 0.16, k["glass"])
	var nm := maxi(1, int(w / 2.6))
	for mi in range(1, nm + 1):
		_fbox(Vector3(0.06, 2.8, 0.08), -w / 2.0 + w * mi / (nm + 1), 1.6, 0.17, k["dark"])
	_fbox(Vector3(0.9, 2.2, 0.08), -w / 2.0 + 0.9, 1.1, 0.2, k["dark"])
	_fbox(Vector3(0.04, 0.3, 0.04), -w / 2.0 + 1.25, 1.05, 0.26, k["metal"])


## Shop interior N, unlit (the painted room is already lit), dark in an outage.
func _shop_mat(n: int, c: Color) -> StandardMaterial3D:
	var key := "shop%d|%s|%s" % [n, c, kit_dead]
	if _mat_cache.has(key):
		return _mat_cache[key]
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.albedo_texture = load("res://assets/facades/shop%d_emit.png" % n)
	m.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	var on := Color(1, 1, 1).lerp(c, 0.2) * (1.7 if kit_day else 1.3)
	m.albedo_color = Color(0.08, 0.08, 0.09) if kit_dead else on
	if not kit_dead:
		power_mats.append([m, on, "albedo_color", Color(0.08, 0.08, 0.09)])
	_mat_cache[key] = m
	return m


## A tree: textured trunk, limbs, a canopy of leaf cards round a few spheres.
func tree(p: Vector3, h: float, bark: Material, leaf_mats: Array, parent: Node = self) -> void:
	cyl(0.32, 0.55, h, p + Vector3(0, h / 2.0, 0), bark, 9, parent)
	for k in 3:
		var a := rng.randf() * TAU
		var s := p + Vector3(0, h * 0.55, 0)
		stick(s, s + Vector3(cos(a) * 2.0, 1.0, sin(a) * 2.0), 0.12, bark, parent)
	for k in 3:
		var off := Vector3(rng.randf_range(-1.6, 1.6), h + rng.randf_range(-0.5, 1.2), rng.randf_range(-1.6, 1.6))
		sphere(rng.randf_range(1.6, 2.4), p + off, leaf_mats[k % leaf_mats.size()], 8, parent)
	for k in 12:
		var off := Vector3(rng.randf_range(-2.2, 2.2), h + rng.randf_range(-1.2, 1.8), rng.randf_range(-2.2, 2.2))
		var q := quad(Vector2(4.6, 4.6) * rng.randf_range(0.8, 1.2), p + off, 0.0, _leaf_card(), parent)
		q.rotation = Vector3(rng.randf_range(-0.7, 0.7), rng.randf() * TAU, rng.randf_range(-0.5, 0.5))


func _leaf_card() -> StandardMaterial3D:
	if _mat_cache.has("leafcard"):
		return _mat_cache["leafcard"]
	var m := StandardMaterial3D.new()
	m.albedo_texture = load("res://assets/facades/leaves.png")
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	m.alpha_scissor_threshold = 0.5
	m.cull_mode = BaseMaterial3D.CULL_DISABLED
	m.roughness = 0.9
	m.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	_mat_cache["leafcard"] = m
	return m


func _neon(c: Color) -> StandardMaterial3D:
	return _kglow(c, 3.2 if kit_day else 2.6)


## Glow, unless kit_dead is set (a block with its power cut).
func _kglow(c: Color, e: float) -> StandardMaterial3D:
	if kit_dead:
		return mat(Color(c.r, c.g, c.b) * 0.12 + Color(0.05, 0.05, 0.05), 0.6)
	return glow(c, e, true)


func _kc() -> Color:
	return KIT_NEON[rng.randi() % KIT_NEON.size()]


func _fp(x: float, y: float, z: float) -> Vector3:
	return _fo + Basis(Vector3.UP, _fr) * Vector3(x, y, z)


func _fbox(size: Vector3, x: float, y: float, z: float, m: Material, solid := false, extra_rot := 0.0) -> MeshInstance3D:
	var p := _fp(x, y, z)
	var mi := box(size, p, m, false, kit_parent)
	mi.rotation.y = _fr + extra_rot
	if solid:
		solid_box(size, p, kit_parent).rotation.y = _fr + extra_rot
	return mi


func _fquad(size: Vector2, x: float, y: float, z: float, m: Material, extra_rot := 0.0) -> MeshInstance3D:
	return quad(size, _fp(x, y, z), _fr + extra_rot, m, kit_parent)


## Glowing sign lettering as a real mesh (TextMesh), so it batches with the
## rest of the street instead of costing a draw each like a Label3D.
func neon_text(text: String, pos: Vector3, rot_y: float, height: float, c: Color, energy := -1.0, parent: Node = null) -> MeshInstance3D:
	var tm := TextMesh.new()
	tm.text = text
	tm.font_size = 32
	tm.pixel_size = height / 32.0
	tm.depth = 0.0
	tm.curve_step = 2.5
	var mi := MeshInstance3D.new()
	mi.mesh = tm
	mi.material_override = _kglow(c, energy if energy > 0.0 else (3.2 if kit_day else 2.6))
	mi.position = pos
	mi.rotation.y = rot_y
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	(parent if parent else kit_parent).add_child(mi)
	return mi


func _fit(text: String, width: float, height: float) -> float:
	return minf(height, width / maxf(1.0, text.length() * 0.62))


## A block whose street face is centred at `o` (ground level), facing rot_y
## (0 faces +Z): w wide, h tall, d deep, dressed for the street.
func cyber_block(o: Vector3, rot_y: float, w: float, h: float, d: float, solid := true, lod := 0) -> void:
	_fo = o
	_fr = rot_y
	var k := _kit_mats()
	var wi := rng.randi() % (k["walls"] as Array).size()
	_fbox(Vector3(w, h, d), 0, h / 2.0, -d / 2.0, k["walls"][wi], solid)
	if h > 6.0 and not kit_dead:
		_fquad(Vector2(w - 0.1, h - 4.4), 0, 4.4 + (h - 4.4) / 2.0, 0.015, k["lits"][wi])
	# cornice and parapet at the roof line, a plinth at the pavement
	_fbox(Vector3(w + 0.5, 0.7, 0.55), 0, h - 0.35, 0.2, k["dark"])
	_fbox(Vector3(w + 0.3, 0.12, 0.7), 0, h - 0.8, 0.25, k["metal"])
	if lod == 0:
		_fbox(Vector3(w, 0.5, 0.25), 0, 0.25, 0.1, k["plinth"])
	if h > 32.0 and rng.randf() < 0.4:
		var h2 := rng.randf_range(12.0, 45.0)
		var w2 := w * rng.randf_range(0.45, 0.7)
		var d2 := d * 0.6
		var wj := rng.randi() % (k["walls"] as Array).size()
		var zf := -d / 2.0 + d2 / 2.0
		_fbox(Vector3(w2, h2, d2), 0, h + h2 / 2.0, -d / 2.0, k["walls"][wj])
		if not kit_dead:
			_fquad(Vector2(w2, h2), 0, h + h2 / 2.0, zf + 0.015, k["lits"][wj])
		if rng.randf() < 0.6:
			_fbox(Vector3(w2, 0.35, 0.12), 0, h + h2 - 0.5, zf + 0.07, _neon(_kc()))
	cyber_dress(o, rot_y, w, h, lod)


## Signs, screens and clutter on a face (also for faces built by hand).
func cyber_dress(o: Vector3, rot_y: float, w: float, h: float, lod := 0, shop := true) -> void:
	_fo = o
	_fr = rot_y
	var k := _kit_mats()
	var c := _kc()
	if shop and lod == 0:
		if rng.randf() < 0.75:
			kit_shop(w - 1.2, c)
		else:
			_fquad(Vector2(w - 1.2, 2.8), 0, 1.6, 0.03, k["metal"])
	if rng.randf() < 0.5:
		var sc := _kc()
		for i in rng.randi_range(1, 3):
			_fbox(Vector3(w, 0.14, 0.1), 0, rng.randf_range(6.0, maxf(6.5, h - 2.0)), 0.06, _neon(sc))
	if rng.randf() < 0.3:
		var vc := _kc()
		for sd: float in [-1.0, 1.0]:
			_fbox(Vector3(0.16, h - 4.0, 0.16), sd * (w / 2.0 - 0.1), 4.0 + (h - 4.0) / 2.0, 0.08, _neon(vc))
	if lod == 0:
		for i in clampi(int(w * h / 70.0), 2, 12):
			_fbox(Vector3(0.9, 0.6, 0.5), rng.randf_range(-w / 2.0 + 1.0, w / 2.0 - 1.0), rng.randf_range(5.0, maxf(5.5, h - 1.0)), 0.25, k["metal"])
		if rng.randf() < 0.6:
			_fbox(Vector3(0.18, h, 0.18), rng.randf_range(-w / 2.0 + 0.5, w / 2.0 - 0.5), h / 2.0, 0.12, k["rust"])
		if rng.randf() < 0.65 and h > 11.0:
			var bt: String = KIT_BLADES[rng.randi() % KIT_BLADES.size()]
			var ln := minf(h - 6.0, bt.length() * 1.25 + 0.8)
			var bx := (w / 2.0 - 1.2) * (1.0 if rng.randf() < 0.5 else -1.0)
			var bc := _kc()
			var by := 5.0 + ln / 2.0
			_fbox(Vector3(0.25, ln, 1.5), bx, by, 0.85, k["dark"])
			_fbox(Vector3(0.32, ln + 0.1, 0.07), bx, by, 1.62, _neon(bc))
			var vt := ""
			for i in bt.length():
				vt += bt[i] + ("\n" if i < bt.length() - 1 else "")
			for sd: float in [-1.0, 1.0]:
				neon_text(vt, _fp(bx + sd * 0.14, by, 0.85), _fr + sd * PI / 2.0, minf(1.0, ln / bt.length() * 0.7), bc)
	if h > 22.0 and w > 9.0 and rng.randf() < (0.45 if lod == 0 else 0.3):
		var ad: Array = KIT_ADS[rng.randi() % KIT_ADS.size()]
		var sw := minf(w - 3.0, 18.0)
		var sh := sw * 0.56
		var sy := rng.randf_range(9.0 + sh / 2.0, maxf(9.5 + sh / 2.0, h - sh / 2.0 - 1.0))
		var ac := _kc()
		_fbox(Vector3(sw + 0.6, sh + 0.6, 0.3), 0, sy, 0.15, k["dark"])
		_fquad(Vector2(sw, sh), 0, sy, 0.31, _kglow(ac * 0.4, 1.4))
		neon_text(ad[0], _fp(0, sy + sh * 0.12, 0.34), _fr, _fit(ad[0], sw * 0.9, sh * 0.3), Color(1, 1, 1).lerp(ac, 0.25), 2.6)
		neon_text(ad[1], _fp(0, sy - sh * 0.24, 0.34), _fr, _fit(ad[1], sw * 0.9, sh * 0.1), Color(1, 0.97, 0.92), 2.2)
	# the roof: plant, a mast with its light on the tall ones, sometimes a sign
	_fbox(Vector3(3, 2, 3), rng.randf_range(-w / 2.0 + 2.0, w / 2.0 - 2.0), h + 1.0, -3.0, k["metal"])
	if h > 45.0 and lod == 0:
		_fbox(Vector3(0.15, 8.0, 0.15), w * 0.25, h + 4.0, -2.0, k["metal"])
		if not kit_dead:
			var bl := _fbox(Vector3(0.5, 0.5, 0.5), w * 0.25, h + 8.2, -2.0, glow(Color(1, 0.05, 0.05), 4.0))
			blinkers.append(bl)
	elif h < 40.0 and rng.randf() < 0.22:
		var rt: String = KIT_ADS[rng.randi() % KIT_ADS.size()][0]
		var rc := _kc()
		var th := _fit(rt, w - 1.0, 3.0)
		_fbox(Vector3(w * 0.8, 0.15, 0.15), 0, h + 0.4, -0.6, k["metal"])
		neon_text(rt, _fp(0, h + 0.6 + th * 0.6, -0.6), _fr, th, rc)


## A sagging cable between two points.
func cable(a: Vector3, b: Vector3, sag: float) -> void:
	var k := _kit_mats()
	var prev := a
	for i in range(1, 7):
		var t := i / 6.0
		var p := a.lerp(b, t) - Vector3(0, sag * 4.0 * t * (1.0 - t), 0)
		stick(prev, p, 0.03, k["cable"], kit_parent)
		prev = p


## A walkway between two blocks at height y, with a lit underside.
func skybridge(a: Vector3, b: Vector3, width: float) -> void:
	var k := _kit_mats()
	var mid := (a + b) / 2.0
	var ln := a.distance_to(b)
	var ry := atan2(b.x - a.x, b.z - a.z)
	var c := _kc()
	var bx := box(Vector3(width, 3.0, ln), mid, k["walls"][2], false, kit_parent)
	bx.rotation.y = ry
	var st := box(Vector3(width * 0.8, 0.1, ln), mid - Vector3(0, 1.55, 0), _neon(c), false, kit_parent)
	st.rotation.y = ry
	var gl := box(Vector3(width + 0.05, 1.0, ln), mid + Vector3(0, 0.3, 0), _kglow(c * 0.25, 1.2), false, kit_parent)
	gl.rotation.y = ry


## A see-through hologram ad hanging in the air.
func kit_holo(pos: Vector3, rot_y: float, title: String, tag: String, c: Color, w := 12.0) -> void:
	var key := "holo%s" % c
	if not _mat_cache.has(key):
		var m := newmat(Color(c.r, c.g, c.b, 0.14), 1.0)
		m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		m.cull_mode = BaseMaterial3D.CULL_DISABLED
		_mat_cache[key] = m
	var h := w * 0.55
	quad(Vector2(w, h), pos, rot_y, _mat_cache[key], kit_parent).cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var fwd := Basis(Vector3.UP, rot_y) * Vector3(0, 0, 0.05)
	neon_text(title, pos + fwd + Vector3(0, h * 0.12, 0), rot_y, _fit(title, w * 0.9, h * 0.32), c, 3.0)
	neon_text(tag, pos + fwd - Vector3(0, h * 0.24, 0), rot_y, _fit(tag, w * 0.9, h * 0.1), c.lightened(0.4), 2.5)
	neon_text(title, pos - fwd + Vector3(0, h * 0.12, 0), rot_y + PI, _fit(title, w * 0.9, h * 0.32), c, 3.0)


# ------------------------------------------------------------------ walkability (selftest)

## What the last probe_walk saw, for the selftest's line when it fails.
var probe_info := ""
var _probe_label := ""
var _probe_hit: Object
## People who walk with Carl (or step aside for him): their colliders are
## left out of probe_walk, since the selftest leaves them wherever it last
## put them, not a step behind him.
var walk_ignore: Array = []


## Can Carl walk from `from` to within `reach` metres of `to` (and see it,
## as the interact ray must: it reaches 3.6 m from his eyes)?
## A flood fill over a `step` grid inside `bounds` (x, z, width, depth; empty
## = a box around both points) with a capsule a little fatter than his,
## against layer 1. Each cell finds its floor with a ray down, so ramps and
## stairs count; a rise of more than 0.8 of a step between cells is a wall,
## a drop of more than 2.5 a fall, and the capsule rides 0.3 m up, over lips
## (and at the upper height when stepping down off one). Selftests teleport
## Carl, so only this finds a prop, a counter or a closed door standing
## across the only way through. `--walkmap=dir` maps the failures.
func probe_walk(from: Vector3, to: Vector3, bounds := Rect2(), step := 0.5, reach := 1.8) -> bool:
	await get_tree().physics_frame
	await get_tree().physics_frame
	if bounds.size == Vector2.ZERO:
		bounds = Rect2(Vector2(minf(from.x, to.x), minf(from.z, to.z)), Vector2.ZERO)
		bounds = bounds.expand(Vector2(maxf(from.x, to.x), maxf(from.z, to.z))).grow(40.0)
	var space := get_world_3d().direct_space_state
	var cap := CapsuleShape3D.new()
	cap.radius = 0.36
	cap.height = 1.6
	var q := PhysicsShapeQueryParameters3D.new()
	q.shape = cap
	q.collision_mask = 1
	var rq := PhysicsRayQueryParameters3D.new()
	rq.collision_mask = 1
	var ex: Array[RID] = []
	for w in walk_ignore:
		if is_instance_valid(w):
			if w is CollisionObject3D:
				ex.append((w as CollisionObject3D).get_rid())
			for c in (w as Node).find_children("*", "CollisionObject3D", true, false):
				ex.append((c as CollisionObject3D).get_rid())
	q.exclude = ex
	rq.exclude = ex
	var nx := int(bounds.size.x / step) + 1
	var nz := int(bounds.size.y / step) + 1
	# a cell: [floor y] or [] (no floor, or no room); keyed by column and storey
	var floor_at := func(ix: int, iz: int, ref_y: float) -> Array:
		var x := bounds.position.x + ix * step
		var z := bounds.position.y + iz * step
		rq.from = Vector3(x, ref_y + 0.55, z)
		rq.to = Vector3(x, ref_y - 2.6, z)
		var hit := space.intersect_ray(rq)
		if hit.is_empty():
			return []
		if hit.normal.y < 0.6:
			_probe_hit = hit.collider
			return []
		var fy: float = hit.position.y
		if fy - ref_y > step * 0.8:
			_probe_hit = hit.collider
		q.transform = Transform3D(Basis.IDENTITY, Vector3(x, fy + 0.3 + cap.height * 0.5, z))
		var hits := space.intersect_shape(q, 1)
		if not hits.is_empty() and fy < ref_y - 0.05:
			# stepping down off a lip: he is still at the upper height
			q.transform.origin.y = ref_y + 0.3 + cap.height * 0.5
			hits = space.intersect_shape(q, 1)
		if not hits.is_empty():
			_probe_hit = hits[0].collider
			return []
		return [fy]
	var sx := clampi(roundi((from.x - bounds.position.x) / step), 0, nx - 1)
	var sz := clampi(roundi((from.z - bounds.position.y) / step), 0, nz - 1)
	var first: Array = floor_at.call(sx, sz, from.y + 0.6)
	if first.is_empty():
		# spawned against something: take the nearest free cell around him
		for r in [1, 2]:
			for dx in range(-r, r + 1):
				for dz in range(-r, r + 1):
					if first.is_empty() and sx + dx >= 0 and sx + dx < nx and sz + dz >= 0 and sz + dz < nz:
						first = floor_at.call(sx + dx, sz + dz, from.y + 0.6)
						if not first.is_empty():
							sx += dx
							sz += dz
	if first.is_empty():
		var bn := _probe_hit as Node3D
		probe_info = "(no room to stand at the start %s: %s)" % [from, "no floor" if bn == null else "%s at %s id=%s" % [bn.name, bn.global_position.snapped(Vector3(0.1, 0.1, 0.1)), bn.get_meta("id", "")]]
		return false
	var key := func(ix: int, iz: int, y: float) -> Vector3i:
		return Vector3i(ix, iz, roundi(y * 2.0))
	var seen := {key.call(sx, sz, first[0]): true}
	var queue: Array = [[sx, sz, first[0]]]
	var best := INF
	var best_at := Vector3.ZERO
	var dirs := [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]
	var walls := {}
	var blockers := {}
	_probe_hit = null
	while not queue.is_empty():
		var c: Array = queue.pop_front()
		var p := Vector3(bounds.position.x + c[0] * step, c[2], bounds.position.y + c[1] * step)
		var d := Vector2(p.x - to.x, p.z - to.z).length()
		if d < best:
			best = d
			best_at = p
		if d <= reach and absf(to.y - p.y - 1.66) < 2.5:
			rq.from = p + Vector3(0, 1.6, 0)
			rq.to = to
			var los := space.intersect_ray(rq)
			if los.is_empty() or los.position.distance_to(to) < 1.2 or (los.collider as Object).has_meta("id"):
				probe_info = "(cells %d)" % seen.size()
				return true
		for dv: Vector2i in dirs:
			var n := Vector2i(c[0], c[1]) + dv
			if n.x < 0 or n.y < 0 or n.x >= nx or n.y >= nz:
				continue
			var f: Array = floor_at.call(n.x, n.y, c[2])
			if f.is_empty() or f[0] - c[2] > step * 0.8:
				walls[n] = true
				if _probe_hit:
					blockers[_probe_hit] = blockers.get(_probe_hit, 0) + 1
				_probe_hit = null
				continue
			var k: Vector3i = key.call(n.x, n.y, f[0])
			if seen.has(k):
				continue
			seen[k] = true
			queue.append([n.x, n.y, f[0]])
	probe_info = "(cells %d, closest %.1f m at %s)" % [seen.size(), best, best_at.snapped(Vector3(0.1, 0.1, 0.1))]
	# --walkmap=dir: the cells reached (a digit per storey), the walls met
	# (#), start S and goal G, north up, one file per failed probe
	if main and main._args.has("walkmap"):
		var grid := {}
		for k: Vector3i in seen:
			grid[Vector2i(k.x, k.y)] = str(posmod(floori(k.z / 6.0), 10))
		for k: Vector2i in walls:
			if not grid.has(k):
				grid[k] = "#"
		grid[Vector2i(sx, sz)] = "S"
		grid[Vector2i(roundi((to.x - bounds.position.x) / step), roundi((to.z - bounds.position.y) / step))] = "G"
		var txt := "%s step %.2f x0 %.1f z0 %.1f %s\n" % [_probe_label, step, bounds.position.x, bounds.position.y, probe_info]
		for b: Object in blockers:
			if is_instance_valid(b):
				var bn := b as Node3D
				txt += "  blocker %s %s at %s id=%s parent=%s x%d\n" % [bn.name, bn.get_class(), bn.global_position.snapped(Vector3(0.1, 0.1, 0.1)), bn.get_meta("id", ""), bn.get_parent().name, blockers[b]]
		for iz in nz:
			var row := ""
			for ix in nx:
				row += grid.get(Vector2i(ix, iz), " ")
			txt += row.rstrip(" ") + "\n"
		var fa := FileAccess.open("%s/%s_%s.txt" % [main._args["walkmap"], main.level_name, _probe_label.validate_filename()], FileAccess.WRITE)
		if fa:
			fa.store_string(txt)
	return false


## The interactable with this id (a node with meta "id"), or null.
func by_id(id: String) -> Node3D:
	for n in main._all_with_meta(self, "id"):
		if is_instance_valid(n) and str(n.get_meta("id")) == id:
			return n
	return null


## Print `ok walkable <label>: <bool>` for Carl's way from `from` (default:
## the spawn) to `to`, a position, a node or an interactable's id.
func check_walk(label: String, to, from = null, bounds := Rect2(), reach := 2.5) -> bool:
	var target := Vector3.ZERO
	if to is String:
		var n := by_id(to)
		if n == null:
			print("MISSING walkable target ", to)
			return false
		target = n.global_position
	elif to is Node3D:
		target = (to as Node3D).global_position
	else:
		target = to
	var start: Vector3 = spawn if from == null else (from.global_position if from is Node3D else from)
	_probe_label = label
	var ok: bool = await probe_walk(start, target, bounds, 0.5, reach)
	if not ok:
		# a doorway narrower than the coarse grid can line up with
		ok = await probe_walk(start, target, bounds, 0.25, reach)
	print("ok walkable ", label, ": ", ok, "" if ok else " " + probe_info)
	return ok
