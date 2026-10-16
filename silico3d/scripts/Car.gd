class_name Car
## Silico's cars, GTA III style: a swept body with a sloped hood and boot, a
## glass cabin with pillars and roof, bumpers, grille, lamps, mirrors, door
## seams, handles, plates, and either wheels with hubs or hover pods.
## Everything is merged into one mesh per material (paint, trim, chrome,
## glass, lamps), so a street of them stays cheap.
##
## opts: "head"/"tail" (lamp materials; default dim glows), "hover" (pods, no
## wheels), "plate" (text on the rear plate, ground cars only).

static var _mats := {}


## A tube swept along z through `sections` ([z, PackedVector2Array]), each
## with the same number of (x, y) points, ends capped.
static func sweep(st: SurfaceTool, sections: Array, xf := Transform3D(), caps := true) -> void:
	var n: int = (sections[0][1] as PackedVector2Array).size()
	for i in sections.size() - 1:
		var a: PackedVector2Array = sections[i][1]
		var b: PackedVector2Array = sections[i + 1][1]
		var za: float = sections[i][0]
		var zb: float = sections[i + 1][0]
		for j in n:
			var k := (j + 1) % n
			var p0 := xf * Vector3(a[j].x, a[j].y, za)
			var p1 := xf * Vector3(a[k].x, a[k].y, za)
			var p2 := xf * Vector3(b[k].x, b[k].y, zb)
			var p3 := xf * Vector3(b[j].x, b[j].y, zb)
			_quad(st, p0, p1, p2, p3)
	if caps:
		for e in [0, sections.size() - 1]:
			var pts: PackedVector2Array = sections[e][1]
			var z: float = sections[e][0]
			var c := Vector2.ZERO
			for p in pts:
				c += p
			c /= pts.size()
			for j in n:
				var k := (j + 1) % n
				var q0 := xf * Vector3(c.x, c.y, z)
				var q1 := xf * Vector3(pts[j].x, pts[j].y, z)
				var q2 := xf * Vector3(pts[k].x, pts[k].y, z)
				if e == 0:
					_tri(st, q0, q1, q2)
				else:
					_tri(st, q0, q2, q1)


static func _tri(st: SurfaceTool, a: Vector3, b: Vector3, c: Vector3) -> void:
	st.set_uv(Vector2(a.x, a.y))
	st.add_vertex(a)
	st.set_uv(Vector2(b.x, b.y))
	st.add_vertex(b)
	st.set_uv(Vector2(c.x, c.y))
	st.add_vertex(c)


static func _quad(st: SurfaceTool, a: Vector3, b: Vector3, c: Vector3, d: Vector3) -> void:
	_tri(st, a, b, c)
	_tri(st, a, c, d)


static func box(st: SurfaceTool, size: Vector3, centre: Vector3, xf := Transform3D()) -> void:
	Body.ubox(st, size, centre, Rect2(0, 0, 1, 1), xf)


## Body cross-section: rounded slab from b (sill) to t (shoulder line).
static func _slab(w: float, b: float, t: float) -> PackedVector2Array:
	return PackedVector2Array([Vector2(-w * 0.9, b), Vector2(-w, b + 0.12), Vector2(-w, t - 0.14),
		Vector2(-w * 0.97, t - 0.04), Vector2(-w * 0.86, t), Vector2(w * 0.86, t), Vector2(w * 0.97, t - 0.04),
		Vector2(w, t - 0.14), Vector2(w, b + 0.12), Vector2(w * 0.9, b)])


static func _cabin(w: float, b: float, t: float) -> PackedVector2Array:
	return PackedVector2Array([Vector2(-w, b), Vector2(-w * 0.82, t), Vector2(w * 0.82, t), Vector2(w, b)])


static func _mat(key: String, c: Color, rough: float, metal: float, clear := false) -> StandardMaterial3D:
	if not _mats.has(key):
		var m := StandardMaterial3D.new()
		m.albedo_color = c
		m.roughness = rough
		m.metallic = metal
		if clear:
			m.clearcoat_enabled = true
			m.clearcoat = 0.8
			m.clearcoat_roughness = 0.15
		_mats[key] = m
	return _mats[key]


static func build(lvl: Node, paint_c: Color, opts := {}) -> Node3D:
	var car := Node3D.new()
	var hover: bool = opts.get("hover", false)
	var lift := 0.0 if not hover else -0.15
	var sts := {}
	for k in ["paint", "trim", "chrome", "glass", "head", "tail", "plate", "tyre"]:
		var st := SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		sts[k] = st
	var up := Transform3D(Basis(), Vector3(0, lift, 0))
	if opts.get("van", false):
		# delivery van: a tall box with a short raked nose and a big windscreen
		sweep(sts.paint, [[-2.5, _slab(0.92, 0.32, 0.88)], [-2.3, _slab(1.0, 0.28, 1.15)],
			[-1.75, _slab(1.05, 0.27, 2.35)], [2.45, _slab(1.05, 0.27, 2.38)], [2.52, _slab(1.0, 0.3, 2.3)]], up)
		var ws := Transform3D(Basis(Vector3(1, 0, 0), -0.5), Vector3(0, 1.75, -2.04))
		box(sts.glass, Vector3(1.86, 1.0, 0.04), Vector3.ZERO, ws)
		for s: float in [-1.0, 1.0]:
			box(sts.glass, Vector3(0.02, 0.6, 0.8), Vector3(s * 1.055, 1.75, -1.3), up)
			box(sts.trim, Vector3(0.012, 1.9, 0.02), Vector3(s * 1.055, 1.3, -0.8), up)
			box(sts.chrome, Vector3(0.03, 0.04, 0.18), Vector3(s * 1.06, 1.1, -1.1), up)
			box(sts.trim, Vector3(0.06, 0.22, 0.12), Vector3(s * 1.12, 1.8, -1.85), up)
			box(sts.trim, Vector3(0.02, 0.1, 4.6), Vector3(s * 1.055, 0.42, 0.0), up)
		box(sts.trim, Vector3(0.012, 1.9, 0.02), Vector3(0, 1.3, 2.53), up)
	else:
		# lower body: nose low, hood rising to the windscreen, a flat boot
		sweep(sts.paint, [
			[-2.27, _slab(0.8, 0.34, 0.66)], [-2.12, _slab(0.9, 0.27, 0.74)], [-1.4, _slab(0.95, 0.24, 0.84)],
			[-0.9, _slab(0.95, 0.23, 0.9)], [0.9, _slab(0.95, 0.23, 0.92)], [1.85, _slab(0.94, 0.25, 0.92)],
			[2.18, _slab(0.88, 0.3, 0.88)], [2.28, _slab(0.8, 0.36, 0.8)]], up)
		# the glass cabin, and its roof and pillars in paint
		sweep(sts.glass, [[-0.95, _cabin(0.86, 0.88, 0.92)], [-0.25, _cabin(0.8, 0.9, 1.4)],
			[0.85, _cabin(0.8, 0.9, 1.4)], [1.65, _cabin(0.84, 0.9, 0.95)]], up)
		sweep(sts.paint, [[-0.27, _cabin(0.68, 1.39, 1.45)], [0.87, _cabin(0.68, 1.39, 1.45)]], up)
		for s: float in [-1.0, 1.0]:
			_strut(sts.paint, Vector3(s * 0.84, 0.9 + lift, -0.93), Vector3(s * 0.67, 1.41 + lift, -0.25), 0.05)
			_strut(sts.paint, Vector3(s * 0.81, 0.9 + lift, 0.3), Vector3(s * 0.67, 1.41 + lift, 0.3), 0.06)
			_strut(sts.paint, Vector3(s * 0.83, 0.9 + lift, 1.6), Vector3(s * 0.67, 1.41 + lift, 0.85), 0.07)
			# door seams, handles, mirror, side trim
			for z: float in [-0.95, 0.3, 1.45]:
				box(sts.trim, Vector3(0.012, 0.6, 0.02), Vector3(s * 0.955, 0.6, z), up)
			for z: float in [-0.2, 0.95]:
				box(sts.chrome, Vector3(0.03, 0.035, 0.16), Vector3(s * 0.965, 0.8, z), up)
			box(sts.trim, Vector3(0.02, 0.07, 3.7), Vector3(s * 0.958, 0.42, 0.05), up)
			box(sts.paint, Vector3(0.16, 0.1, 0.12), Vector3(s * 0.98, 0.98, -0.82), up)
			box(sts.glass, Vector3(0.012, 0.08, 0.1), Vector3(s * 1.06, 0.98, -0.82), up)
	var fz := -0.26 if opts.get("van", false) else 0.0
	var rz := 0.26 if opts.get("van", false) else 0.0
	# bumpers, grille, lamps, plates
	box(sts.trim, Vector3(1.86, 0.18, 0.16), Vector3(0, 0.36, -2.22 + fz), up)
	box(sts.trim, Vector3(1.86, 0.18, 0.16), Vector3(0, 0.4, 2.22 + rz), up)
	box(sts.trim, Vector3(0.9, 0.16, 0.04), Vector3(0, 0.56, -2.24 + fz), up)
	for i in 4:
		box(sts.chrome, Vector3(0.88, 0.012, 0.045), Vector3(0, 0.5 + i * 0.04, -2.245 + fz), up)
	for s: float in [-1.0, 1.0]:
		box(sts.head, Vector3(0.36, 0.09, 0.05), Vector3(s * 0.66, 0.6, -2.2 + fz), up)
		box(sts.chrome, Vector3(0.4, 0.13, 0.03), Vector3(s * 0.66, 0.6, -2.19 + fz), up)
		box(sts.tail, Vector3(0.42, 0.1, 0.05), Vector3(s * 0.62, 0.72, 2.25 + rz), up)
	box(sts.tail, Vector3(0.8, 0.03, 0.04), Vector3(0, 0.76, 2.26 + rz), up)
	box(sts.plate, Vector3(0.48, 0.13, 0.02), Vector3(0, 0.42, -2.31 + fz), up)
	box(sts.plate, Vector3(0.48, 0.13, 0.02), Vector3(0, 0.55, 2.29 + rz), up)
	if hover:
		# four thruster pods, glowing at the throat
		for x: float in [-0.92, 0.92]:
			for z: float in [-1.5, 1.45]:
				var pod := CylinderMesh.new()
				pod.top_radius = 0.26
				pod.bottom_radius = 0.2
				pod.height = 0.22
				pod.radial_segments = 12
				pod.rings = 1
				sts.trim.append_from(pod, 0, Transform3D(Basis(), Vector3(x, 0.08 + lift, z)))
	else:
		for x: float in [-0.84, 0.84]:
			for z: float in ([-1.75, 1.7] if opts.get("van", false) else [-1.42, 1.48]):
				var t := Transform3D(Basis(Vector3(0, 0, 1), PI / 2.0), Vector3(x, 0.34, z))
				var tyre := CylinderMesh.new()
				tyre.top_radius = 0.34
				tyre.bottom_radius = 0.34
				tyre.height = 0.24
				tyre.radial_segments = 16
				tyre.rings = 1
				sts.tyre.append_from(tyre, 0, t)
				var hub := CylinderMesh.new()
				hub.top_radius = 0.2
				hub.bottom_radius = 0.2
				hub.height = 0.25
				hub.radial_segments = 10
				hub.rings = 1
				sts.chrome.append_from(hub, 0, t)
				# arch: dark lip over each wheel
				box(sts.trim, Vector3(0.05, 0.06, 0.86), Vector3(signf(x) * 0.95, 0.72, z))
	var mats := {
		"paint": _mat("p%s" % paint_c, paint_c, 0.28, 0.55, true),
		"trim": _mat("trim", Color(0.04, 0.04, 0.045), 0.7, 0.0),
		"chrome": _mat("chrome", Color(0.75, 0.76, 0.78), 0.15, 1.0),
		"glass": _mat("glass", Color(0.03, 0.045, 0.06), 0.04, 0.6),
		"head": opts.get("head", lvl.glow(Color(1, 0.97, 0.9), 1.0)),
		"tail": opts.get("tail", lvl.glow(Color(0.9, 0.05, 0.05), 1.0)),
		"plate": _mat("plate", Color(0.85, 0.85, 0.8), 0.6, 0.0),
		"tyre": _mat("tyre", Color(0.03, 0.03, 0.03), 0.9, 0.0),
	}
	for k: String in sts:
		var st: SurfaceTool = sts[k]
		st.generate_normals()
		var m := st.commit()
		if m.get_surface_count() == 0:
			continue
		var mi := MeshInstance3D.new()
		mi.mesh = m
		mi.material_override = mats[k]
		car.add_child(mi)
	if not hover and String(opts.get("plate", "")) != "":
		var l := Label3D.new()
		l.text = String(opts["plate"])
		l.font_size = 40
		l.pixel_size = 0.0022
		l.modulate = Color(0.05, 0.08, 0.2)
		l.outline_size = 0
		l.position = Vector3(0, 0.55, 2.302 + rz)
		car.add_child(l)
	return car


static func _strut(st: SurfaceTool, a: Vector3, b: Vector3, r: float) -> void:
	var d := b - a
	var y := d.normalized()
	var x := y.cross(Vector3(0, 0, 1)).normalized() if absf(y.z) < 0.95 else Vector3(1, 0, 0)
	var z := x.cross(y)
	Body.ubox(st, Vector3(r, d.length(), r), Vector3.ZERO, Rect2(0, 0, 1, 1), Transform3D(Basis(x, y, z), (a + b) * 0.5))
