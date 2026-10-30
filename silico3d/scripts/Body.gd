class_name Body
## People, GTA III style: lofted bodies (shoulders, waist, knees, elbows,
## hands, shoes, a real jaw and nose) wrapped in painted textures (faces with
## eyes, brows and lips; coats with collars, seams, pockets and buttons).
## Two materials per person, cached by colour, so a crowd stays cheap.
##
## The rig is the same as the old capsule people: hips swing on x, shoulders
## swing on x/z, a head node at 1.72 m. Ask for {"knees": true} to get a
## bendable lower leg (seated and crouched people).

const SEG := 16
static var _tex := {}
## Prototype: look=cine swaps in Face's 1024 px face and its 3D eyes and mouth.
static var cine := false
static var _noise: Image
static var _strands: Image


# ------------------------------------------------------------------ meshes

## A tube through `rings` ([y, rx, rz, zoff, xoff]), front facing -Z at u = 0.5,
## textured from `uv` (top ring at the top of the rect).
static func loft(st: SurfaceTool, rings: Array, uv: Rect2, xf := Transform3D(), cap_last := false, cap_first := false, seg := SEG) -> void:
	var y0: float = rings[0][0]
	var y1: float = rings[rings.size() - 1][0]
	var desc := y1 < y0
	var ytop := maxf(y0, y1)
	var span := maxf(absf(y1 - y0), 0.0001)
	var pts := []
	for r: Array in rings:
		var row := []
		var zo: float = r[3] if r.size() > 3 else 0.0
		var xo: float = r[4] if r.size() > 4 else 0.0
		var v: float = uv.position.y + uv.size.y * (ytop - float(r[0])) / span
		for j in seg + 1:
			var a := -PI + TAU * j / seg
			var p := Vector3(sin(a) * float(r[1]) + xo, float(r[0]), -cos(a) * float(r[2]) + zo)
			row.append([xf * p, Vector2(uv.position.x + uv.size.x * j / seg, v)])
		pts.append(row)
	for i in pts.size() - 1:
		for j in seg:
			var a: Array = pts[i][j]
			var b: Array = pts[i][j + 1]
			var c: Array = pts[i + 1][j + 1]
			var d: Array = pts[i + 1][j]
			if desc:
				_tri(st, a, b, c)
				_tri(st, a, c, d)
			else:
				_tri(st, a, c, b)
				_tri(st, a, d, c)
	var top_v := uv.position.y if not desc else uv.end.y
	var bot_v := uv.end.y if not desc else uv.position.y
	if cap_last:
		var r: Array = rings[rings.size() - 1]
		_cap(st, pts[pts.size() - 1], xf * Vector3(_xo(r), y1, _zo(r)), Vector2(uv.get_center().x, top_v), not desc)
	if cap_first:
		_cap(st, pts[0], xf * Vector3(_xo(rings[0]), y0, _zo(rings[0])), Vector2(uv.get_center().x, bot_v), desc)


static func _xo(r: Array) -> float:
	return r[4] if r.size() > 4 else 0.0


static func _zo(r: Array) -> float:
	return r[3] if r.size() > 3 else 0.0


static func _tri(st: SurfaceTool, a: Array, b: Array, c: Array) -> void:
	for p: Array in [a, c, b]:  # Godot's front faces wind clockwise
		st.set_uv(p[1])
		st.add_vertex(p[0])


## `up`: the cap faces +y (the top of a tube going up).
static func _cap(st: SurfaceTool, row: Array, centre: Vector3, cuv: Vector2, up: bool) -> void:
	var c := [centre, cuv]
	for j in row.size() - 1:
		if not up:
			_tri(st, c, row[j], row[j + 1])
		else:
			_tri(st, c, row[j + 1], row[j])


## A box whose every face samples one rect of the atlas.
static func ubox(st: SurfaceTool, size: Vector3, centre: Vector3, uv: Rect2, xf := Transform3D()) -> void:
	var h := size * 0.5
	var faces := [
		[Vector3(0, 0, -1), Vector3(1, 0, 0), Vector3(0, 1, 0)],
		[Vector3(0, 0, 1), Vector3(-1, 0, 0), Vector3(0, 1, 0)],
		[Vector3(1, 0, 0), Vector3(0, 0, 1), Vector3(0, 1, 0)],
		[Vector3(-1, 0, 0), Vector3(0, 0, -1), Vector3(0, 1, 0)],
		[Vector3(0, 1, 0), Vector3(1, 0, 0), Vector3(0, 0, 1)],
		[Vector3(0, -1, 0), Vector3(1, 0, 0), Vector3(0, 0, -1)]]
	for f: Array in faces:
		var n: Vector3 = f[0]
		var r: Vector3 = f[1]
		var u: Vector3 = f[2]
		var c := centre + n * h.abs()
		var rr := r * h.abs()
		var uu := u * h.abs()
		var p0 := [xf * (c - rr - uu), uv.position + Vector2(0, uv.size.y)]
		var p1 := [xf * (c + rr - uu), uv.end]
		var p2 := [xf * (c + rr + uu), uv.position + Vector2(uv.size.x, 0)]
		var p3 := [xf * (c - rr + uu), uv.position]
		_tri(st, p0, p2, p1)
		_tri(st, p0, p3, p2)


static func _commit(st: SurfaceTool) -> ArrayMesh:
	st.generate_normals()
	return st.commit()


# ------------------------------------------------------------------ the person

static func build(lvl: Node, coat: Color, skin: Color, opts: Dictionary) -> Node3D:
	var root := Node3D.new()
	var hair_c: Color = opts.get("hair", Color(0.05, 0.04, 0.04))
	var legs_c: Color = opts.get("legs", Color(0.06, 0.06, 0.07))
	var fem: bool = opts.get("long_hair", false)
	var seed := hash([_q(coat), _q(skin), _q(hair_c), fem])
	var uniform := coat.r < 0.08 and coat.g < 0.1 and coat.b > coat.r * 1.6 and coat.b < 0.2
	var hivis := coat.g > 0.8 and coat.r > 0.6 and coat.b < 0.35
	var long_coat: bool = opts.get("long_coat", not uniform and not hivis and seed % 3 != 0)
	var cloth := clothes_mat(coat, legs_c, skin, seed, uniform, hivis, long_coat)
	var face := Face.face_mat_hd(skin, hair_c, fem, seed) if cine else face_mat(skin, hair_c, fem, seed)
	var w := 0.92 if fem else 1.0
	var hipw := 1.06 if fem else 1.0

	# legs: thigh to shoe, one mesh each (two with knees)
	var legs := []
	var knees := []
	var knee_y := -0.43
	var thigh := [[0.0, 0.088 * hipw, 0.095], [-0.12, 0.083 * hipw, 0.088], [knee_y, 0.058, 0.064, -0.004]]
	var shin := [[knee_y, 0.058, 0.064, -0.004], [-0.5, 0.061, 0.07, 0.004], [-0.62, 0.052, 0.058, 0.006],
		[-0.77, 0.04, 0.043], [-0.8, 0.041, 0.045]]
	var leg_uv := Rect2(0, 0.5, 0.5, 0.375)
	var shoe_uv := Rect2(0.02, 0.9, 0.46, 0.08)
	for side: float in [-1.0, 1.0]:
		var hip := Node3D.new()
		hip.position = Vector3(side * 0.1, 0.86, 0)
		root.add_child(hip)
		var st := SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		if opts.get("knees", false):
			loft(st, thigh, Rect2(0, 0.5, 0.5, 0.18), Transform3D(), false, false, 12)
			_mi(_commit(st), cloth, hip)
			var knee := Node3D.new()
			knee.position = Vector3(0, knee_y, 0)
			hip.add_child(knee)
			st = SurfaceTool.new()
			st.begin(Mesh.PRIMITIVE_TRIANGLES)
			_lower(st, shin, Transform3D(Basis(), Vector3(0, -knee_y, 0)), shoe_uv)
			_mi(_commit(st), cloth, knee)
			knees.append(knee)
		else:
			loft(st, thigh + shin.slice(1), leg_uv, Transform3D(), false, false, 12)
			_lower(st, [], Transform3D(), shoe_uv)
			_mi(_commit(st), cloth, hip)
		legs.append(hip)

	# torso (and arms, unless they move)
	var hem := 0.5 if long_coat else 0.8
	var torso := [[hem, 0.25 if long_coat else 0.2, 0.19 if long_coat else 0.14]]
	if long_coat:
		torso.append([0.7, 0.215, 0.158])
	torso += [[0.86, 0.19 * hipw, 0.135], [1.02, 0.165 * w, 0.115], [1.2, 0.19 * w, 0.126, -0.006],
		[1.36, 0.21 * w, 0.127, -0.01], [1.46, 0.218 * w, 0.118, -0.004], [1.52, 0.2 * w, 0.1],
		[1.57, 0.13 * w, 0.082], [1.6, 0.07, 0.06, 0.004]]
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	loft(st, torso, Rect2(0, 0, 1, 0.5), Transform3D(), true, true)
	var arms := []
	var sx := 0.228 * w
	for side: float in [-1.0, 1.0]:
		if opts.get("arms", false):
			var sh := Node3D.new()
			sh.position = Vector3(side * sx, 1.49, 0)
			root.add_child(sh)
			var ast := SurfaceTool.new()
			ast.begin(Mesh.PRIMITIVE_TRIANGLES)
			_arm(ast, Transform3D(), side)
			_mi(_commit(ast), cloth, sh)
			arms.append(sh)
		else:
			var b := Basis(Vector3(0, 0, 1), side * 0.07) * Basis(Vector3(1, 0, 0), 0.05)
			_arm(st, Transform3D(b, Vector3(side * sx, 1.49, 0)), side)
	var body := _mi(_commit(st), cloth, root)

	# head: skull, jaw, neck, nose, ears and hair as one mesh
	var head := Node3D.new()
	head.position = Vector3(0, 1.72, 0)
	if cine:
		head.scale = Vector3.ONE * 1.1  # prototype: a touch larger, so faces read
	root.add_child(head)
	var hs := 0.96 if fem else 1.0
	var skull := [[-0.2, 0.055, 0.055, 0.012], [-0.125, 0.057 * hs, 0.058, 0.012], [-0.1, 0.05 * hs, 0.07, -0.022],
		[-0.075, 0.07 * hs, 0.088, -0.012], [-0.035, 0.083 * hs, 0.099, -0.006], [0.0, 0.088 * hs, 0.104, -0.002],
		[0.03, 0.09 * hs, 0.106, 0.0], [0.07, 0.088 * hs, 0.106, 0.004], [0.105, 0.079 * hs, 0.097, 0.008],
		[0.135, 0.06 * hs, 0.078, 0.01], [0.155, 0.032 * hs, 0.046, 0.01]]
	var hst := SurfaceTool.new()
	hst.begin(Mesh.PRIMITIVE_TRIANGLES)
	var skin_uv := Rect2(0.46, 0.955, 0.08, 0.03)
	if cine:
		Face.sculpt(hst, skull)  # prototype: sockets, brow, a real nose, lips, chin
	else:
		loft(hst, skull, Rect2(0, 0, 1, 1), Transform3D(), true, false, 20)
	# nose: a wedge off the face
	var fz := -0.104 if not cine else 1.0
	var nose := [[Vector3(0, 0.03, fz + 0.012), skin_uv.position], [Vector3(0, -0.022, fz - 0.026), skin_uv.position],
		[Vector3(-0.02, -0.03, fz + 0.004), skin_uv.end], [Vector3(0.02, -0.03, fz + 0.004), skin_uv.end],
		[Vector3(0, -0.032, fz - 0.012), skin_uv.end]]
	if not cine:
		_tri(hst, nose[0], nose[1], nose[2])
		_tri(hst, nose[0], nose[3], nose[1])
		_tri(hst, nose[1], nose[4], nose[2])
		_tri(hst, nose[1], nose[3], nose[4])
	for side: float in [-1.0, 1.0]:
		loft(hst, [[-0.026, 0.006, 0.012], [-0.01, 0.009, 0.019], [0.018, 0.009, 0.02], [0.03, 0.005, 0.012]], skin_uv,
			Transform3D(Basis(Vector3(0, 1, 0), side * 0.3), Vector3(side * 0.088 * hs * (Face.WIDE if cine else 1.0), 0.0, 0.014)), true, true, 6)
	# hair: a cap with some volume over the painted hairline, and a fall at the back
	var hair_uv := Rect2(0.0, 0.0, 1.0, 0.08)
	var cap := []
	for r: Array in skull.slice(7):
		cap.append([r[0] + 0.006, r[1] * 1.08 * (Face.WIDE if cine else 1.0), r[2] * 1.08, r[3] + 0.006])
	loft(hst, cap, hair_uv, Transform3D(), true, false, 20)
	if fem:
		loft(hst, [[-0.26, 0.105, 0.05, 0.075], [-0.1, 0.1, 0.065, 0.06], [0.02, 0.098, 0.085, 0.04], [0.1, 0.086, 0.085, 0.02]],
			hair_uv, Transform3D(), true, true)
	if cine:
		hst.index()  # shared vertices, so the sculpt shades smooth
	_mi(_commit(hst), face, head)
	if cine and not opts.get("visor", false):
		root.set_meta("face", Face.rig(head, skin, hair_c, seed, skull))
	var v: MeshInstance3D = null
	if opts.get("visor", false):
		v = lvl.box(Vector3(0.2, 0.034, 0.03), Vector3(0, 0.025, -0.112), lvl.glow(Color(0.3, 0.95, 1.0), 3.0), false, head)
	root.set_meta("legs", legs)
	root.set_meta("knees", knees)
	root.set_meta("arms", arms)
	root.set_meta("head", head)
	root.set_meta("visor", v)
	root.set_meta("body", body)
	if opts.has("scale"):
		root.scale = Vector3.ONE * float(opts["scale"])
	return root


## Shin and shoe; `shin` empty means the shin is already in the thigh loft.
static func _lower(st: SurfaceTool, shin: Array, xf: Transform3D, shoe_uv: Rect2) -> void:
	if not shin.is_empty():
		loft(st, shin, Rect2(0, 0.68, 0.5, 0.195), xf, false, false, 12)
	ubox(st, Vector3(0.095, 0.07, 0.24), Vector3(0, -0.825, -0.045), shoe_uv, xf)
	ubox(st, Vector3(0.085, 0.05, 0.07), Vector3(0, -0.835, -0.175), shoe_uv, xf)
	ubox(st, Vector3(0.1, 0.018, 0.29), Vector3(0, -0.851, -0.055), Rect2(shoe_uv.position + Vector2(0, shoe_uv.size.y * 0.8), shoe_uv.size * Vector2(1, 0.2)), xf)


## Sleeve, cuff and hand, hanging from the shoulder joint.
static func _arm(st: SurfaceTool, xf: Transform3D, side: float) -> void:
	var sleeve := [[0.055, 0.02, 0.025], [0.035, 0.046, 0.048], [0.0, 0.056, 0.056], [-0.06, 0.053, 0.054], [-0.28, 0.042, 0.045], [-0.31, 0.044, 0.047, -0.004],
		[-0.5, 0.037, 0.041, -0.006], [-0.555, 0.042, 0.046, -0.006]]
	loft(st, sleeve, Rect2(0.5, 0.5, 0.5, 0.375), xf, false, true, 10)
	var hand := [[-0.54, 0.022, 0.036, -0.006], [-0.6, 0.02, 0.046, -0.01], [-0.67, 0.018, 0.043, -0.012],
		[-0.71, 0.014, 0.034, -0.012], [-0.73, 0.006, 0.016, -0.012]]
	loft(st, hand, Rect2(0.5, 0.9, 0.5, 0.08), xf, true, false, 8)
	# thumb, forward and in
	ubox(st, Vector3(0.016, 0.055, 0.018), Vector3(-side * 0.01, -0.6, -0.042), Rect2(0.5, 0.9, 0.5, 0.08), xf)


static func _mi(m: Mesh, mt: Material, parent: Node3D) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.mesh = m
	mi.material_override = mt
	parent.add_child(mi)
	return mi


static func _q(c: Color) -> Vector3i:
	return Vector3i(int(c.r * 12.0), int(c.g * 12.0), int(c.b * 12.0))


# ------------------------------------------------------------------ painting

static func _base_noise() -> void:
	if _noise:
		return
	var rng := RandomNumberGenerator.new()
	rng.seed = 404
	_noise = Image.create(256, 256, false, Image.FORMAT_RGBA8)
	for y in 256:
		for x in 256:
			var n := rng.randf()
			_noise.set_pixel(x, y, Color(0, 0, 0, n * 0.16) if n > 0.4 else Color(1, 1, 1, (0.4 - n) * 0.12))
	_strands = Image.create(256, 256, false, Image.FORMAT_RGBA8)
	for x in 256:
		var dark := rng.randf() * 0.5
		var light := rng.randf() < 0.18
		for y in 256:
			var a := dark * (0.6 + 0.4 * sin(y * 0.3 + x))
			_strands.set_pixel(x, y, Color(1, 1, 1, 0.14) if light else Color(0, 0, 0, a))


static func _rect(img: Image, x: float, y: float, w: float, h: float, c: Color) -> void:
	var r := Rect2i(int(x), int(y), maxi(1, int(w)), maxi(1, int(h))).intersection(Rect2i(0, 0, img.get_width(), img.get_height()))
	if r.size.x <= 0 or r.size.y <= 0:
		return
	if c.a >= 0.999:
		img.fill_rect(r, c)
		return
	for yy in range(r.position.y, r.end.y):
		for xx in range(r.position.x, r.end.x):
			img.set_pixel(xx, yy, img.get_pixel(xx, yy).lerp(Color(c, 1.0), c.a))


static func _ell(img: Image, cx: float, cy: float, rx: float, ry: float, c: Color, soft := 0.0) -> void:
	for yy in range(int(cy - ry) - 1, int(cy + ry) + 2):
		for xx in range(int(cx - rx) - 1, int(cx + rx) + 2):
			if xx < 0 or yy < 0 or xx >= img.get_width() or yy >= img.get_height():
				continue
			var d := Vector2((xx + 0.5 - cx) / rx, (yy + 0.5 - cy) / ry).length()
			if d > 1.0:
				continue
			var a := c.a * (clampf((1.0 - d) / soft, 0.0, 1.0) if soft > 0.0 else 1.0)
			img.set_pixel(xx, yy, img.get_pixel(xx, yy).lerp(Color(c, 1.0), a))


static func _finish(img: Image) -> ImageTexture:
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


static func _material(tex: Texture2D, rough: float) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_texture = tex
	m.roughness = rough
	m.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	return m


## Atlas (256 px): torso top half; trousers, shoes bottom-left; sleeves, hands bottom-right.
static func clothes_mat(coat: Color, legs: Color, skin: Color, seed: int, uniform: bool, hivis: bool, long_coat: bool) -> StandardMaterial3D:
	var key := "c%s%s%s%s%s%s" % [_q(coat), _q(legs), _q(skin), seed % 4, uniform, hivis]
	if _tex.has(key):
		return _tex[key]
	_base_noise()
	var img := Image.create(256, 256, false, Image.FORMAT_RGBA8)
	var dark := coat.darkened(0.35)
	var lite := coat.lightened(0.12)
	img.fill_rect(Rect2i(0, 0, 256, 128), coat)
	# torso: v 0 = neck, v 128 = hem. Front centre is x 128, back x 0/256.
	var hem := 0.5 if long_coat else 0.8
	var vy := func(y: float) -> float: return (1.6 - y) / (1.6 - hem) * 128.0
	_rect(img, 0, 0, 256, 3, dark)  # neckline
	for sx: float in [64.0, 192.0, 0.0, 255.0]:
		_rect(img, sx - 1, 0, 2, 128, Color(dark, 0.6))  # side and back seams
	_rect(img, 0, vy.call(1.5), 256, 1, Color(dark, 0.5))  # shoulder seam
	var shirt := Color(0.82, 0.8, 0.76) if seed % 2 == 0 else Color(0.18, 0.2, 0.24)
	if uniform:
		# Silico PD: shirt and tie under the jacket, badge, belt, radio
		_tri_fill(img, 128, vy.call(1.58), 14, vy.call(1.38), Color(0.62, 0.66, 0.72))
		_rect(img, 127, vy.call(1.56), 3, vy.call(1.38) - vy.call(1.56), Color(0.04, 0.04, 0.06))
		_ell(img, 146, vy.call(1.4), 4, 5, Color(0.85, 0.72, 0.3))
		_rect(img, 104, vy.call(1.43), 10, 3, Color(0.75, 0.75, 0.78))
		_rect(img, 0, vy.call(1.0), 256, 7, Color(0.03, 0.03, 0.03))
		_rect(img, 125, vy.call(1.0), 6, 7, Color(0.7, 0.7, 0.72))
		_rect(img, 166, vy.call(1.02), 12, 12, Color(0.05, 0.05, 0.05))
		for sx: float in [64.0, 192.0]:
			_rect(img, sx - 6, vy.call(1.5), 12, 10, Color(0.15, 0.2, 0.35))  # shoulder patches
	else:
		# open collar or lapels showing the shirt underneath
		_tri_fill(img, 128, vy.call(1.6), 12 if long_coat else 8, vy.call(1.34 if long_coat else 1.44), shirt)
		_tri_fill(img, 128, vy.call(1.6), 18, vy.call(1.3), Color(dark, 0.0))
		for s: float in [-1.0, 1.0]:
			_line(img, 128 + s * 13, vy.call(1.6), 128 + s * 2, vy.call(1.3), lite, 2)  # lapel edge
		_rect(img, 127, vy.call(1.3), 2, 128, Color(dark, 0.9))  # front opening
		for i in 4:
			_ell(img, 124, vy.call(1.25 - i * 0.12), 1.5, 1.5, Color(0.08, 0.08, 0.08))
		for s: float in [-1.0, 1.0]:
			# hip pockets with flaps
			var px := 128 + s * 30
			_rect(img, px - 11, vy.call(0.98), 22, 2, dark)
			_rect(img, px - 11, vy.call(0.98) + 2, 22, 5, Color(dark, 0.35))
			_rect(img, px - 12, vy.call(1.3), 1, 0, dark)
		if not long_coat:
			_rect(img, 0, 118, 256, 10, coat.darkened(0.2))  # waistband
		if hivis:
			for y: float in [1.1, 1.3]:
				_rect(img, 0, vy.call(y), 256, 6, Color(0.85, 0.86, 0.8))  # reflective bands
	# folds: soft vertical shading
	for i in 14:
		var x := float((seed * 7 + i * 37) % 256)
		_rect(img, x, vy.call(1.25), 3, 128, Color(dark, 0.18))
	img.blend_rect(_noise, Rect2i(0, 0, 256, 128), Vector2i(0, 0))
	# trousers (0..128, 128..224): crease at the front, knees, hems
	img.fill_rect(Rect2i(0, 128, 128, 96), legs)
	_rect(img, 63, 128, 2, 96, Color(legs.lightened(0.2), 0.5))
	for sx: float in [32.0, 96.0]:
		_rect(img, sx, 128, 1, 96, Color(legs.darkened(0.4), 0.7))
	for i in 5:
		_rect(img, 40 + i * 3, 168 + i * 2, 18, 1, Color(legs.darkened(0.3), 0.5))
	_rect(img, 0, 128, 128, 4, legs.darkened(0.4))  # belt line
	_rect(img, 0, 220, 128, 4, legs.darkened(0.3))
	# shoes (0..128, 224..256)
	var shoe := Color(0.05, 0.045, 0.04) if seed % 3 != 1 else Color(0.32, 0.2, 0.12)
	img.fill_rect(Rect2i(0, 224, 128, 32), shoe)
	_rect(img, 0, 224, 128, 2, shoe.lightened(0.25))
	_rect(img, 0, 250, 128, 6, Color(0.6, 0.58, 0.55) if seed % 2 == 0 else Color(0.08, 0.08, 0.08))
	# sleeves (128..256, 128..224) and cuffs
	img.fill_rect(Rect2i(128, 128, 128, 96), coat)
	_rect(img, 128, 128, 128, 2, dark)
	_rect(img, 128, 210, 128, 14, coat.darkened(0.2))
	_rect(img, 128, 208, 128, 2, dark)
	for i in 4:
		_rect(img, 170 + i * 5, 176 + i, 30, 1, Color(dark, 0.6))  # elbow creases
	if hivis:
		_rect(img, 128, 190, 128, 6, Color(0.85, 0.86, 0.8))
	# hands (128..256, 224..256), with the neck-coloured patch the head uses
	img.fill_rect(Rect2i(128, 224, 128, 32), skin)
	for i in 4:
		_rect(img, 150 + i * 22, 240, 12, 1, Color(skin.darkened(0.25), 0.6))
	img.blend_rect(_noise, Rect2i(0, 128, 256, 128), Vector2i(0, 128))
	var m := _material(_finish(img), 0.82)
	_tex[key] = m
	return m


## Face atlas (256 px) wrapped round the head loft: v 0 = crown, v 256 = neck
## (head-local y 0.155 .. -0.2); front centre at x 128.
static func face_mat(skin: Color, hair: Color, fem: bool, seed: int) -> StandardMaterial3D:
	var key := "f%s%s%s%s" % [_q(skin), _q(hair), fem, seed % 5]
	if _tex.has(key):
		return _tex[key]
	_base_noise()
	var img := Image.create(256, 256, false, Image.FORMAT_RGBA8)
	img.fill(skin)
	var vy := func(y: float) -> float: return (0.155 - y) / 0.355 * 256.0
	var ux := func(x: float) -> float: return 128.0 + asin(clampf(x / 0.088, -1.0, 1.0)) / TAU * 256.0
	var shade := skin.darkened(0.28)
	var warm := skin.lerp(Color(0.85, 0.35, 0.3), 0.18)
	# shadows that shape the face under flat light
	_ell(img, 128, vy.call(-0.14), 60, 20, Color(shade, 0.7), 0.8)  # under the jaw
	_ell(img, 128, vy.call(0.005), 22, 10, Color(shade, 0.35), 0.9)  # eye sockets
	for s: float in [-1.0, 1.0]:
		_ell(img, ux.call(s * 0.05), vy.call(-0.03), 10, 9, Color(warm, 0.5), 1.0)  # cheeks
		_ell(img, ux.call(s * 0.072), vy.call(-0.06), 8, 16, Color(shade, 0.3), 1.0)  # cheekbone hollow
	_ell(img, 128, vy.call(-0.02), 5, 12, Color(skin.lightened(0.12), 0.5), 1.0)  # nose ridge
	_ell(img, 128, vy.call(-0.035), 9, 3, Color(shade, 0.5), 0.8)  # under the nose
	if not fem and seed % 2 == 0:
		_ell(img, 128, vy.call(-0.07), 34, 22, Color(hair.darkened(0.1), 0.25), 0.6)  # stubble
	# eyes
	for s: float in [-1.0, 1.0]:
		var ex: float = ux.call(s * 0.034)
		var ey: float = vy.call(0.022)
		_ell(img, ex, ey, 7.5, 3.6, Color(0.92, 0.9, 0.86))
		var iris: Color = [Color(0.25, 0.15, 0.08), Color(0.2, 0.35, 0.45), Color(0.3, 0.25, 0.12), Color(0.12, 0.08, 0.05)][seed % 4]
		_ell(img, ex + s * 0.5, ey, 3.2, 3.2, iris)
		_ell(img, ex + s * 0.5, ey, 1.4, 1.4, Color(0.02, 0.02, 0.02))
		_rect(img, ex - 7, ey - 4, 15, 1.5, Color(0.08, 0.05, 0.04, 0.9))  # upper lid line
		_rect(img, ex - 6, ey + 3, 13, 1, Color(shade, 0.6))
		_rect(img, ex + 1, ey - 2, 1, 1, Color(1, 1, 1))  # catchlight
		# brows
		_line(img, ex - s * 8, vy.call(0.045), ex + s * 8, vy.call(0.042) - 1, hair.darkened(0.15), 3 if not fem else 2)
	# mouth
	var lips := skin.lerp(Color(0.55, 0.18, 0.18), 0.45 if fem else 0.3)
	var my: float = vy.call(-0.058)
	_ell(img, 128, my - 1.5, 11, 2.2, lips)
	_ell(img, 128, my + 2.2, 9, 2.6, lips.lightened(0.08))
	_rect(img, 117, my, 22, 1, Color(0.18, 0.06, 0.05))
	_ell(img, 128, vy.call(-0.08), 6, 3, Color(shade, 0.4), 1.0)  # chin dimple
	# ears
	for ex: float in [64.0, 192.0]:
		_ell(img, ex, vy.call(0.0), 9, 15, Color(warm.darkened(0.1), 0.8))
		_ell(img, ex, vy.call(0.0), 4, 9, Color(shade, 0.6))
	# hair: a hairline round the head, lower at the back; long hair falls past the ears
	var mask := Image.create(256, 256, false, Image.FORMAT_RGBA8)
	for x in 256:
		var a := (x / 256.0) * TAU - PI
		var t := (1.0 - cos(a)) * 0.5
		var line := lerpf(vy.call(0.082), vy.call(-0.075 if not fem else -0.2), pow(t, 1.4))
		if fem and absf(a) > 0.55:
			line = maxf(line, lerpf(vy.call(-0.02), vy.call(-0.2), clampf((absf(a) - 0.55) * 2.0, 0.0, 1.0)))
		line += sin(x * 0.7 + seed) * 1.5
		if absf(absf(a) - PI * 0.5) < 0.22 and not fem:
			line = minf(line, vy.call(0.035))  # clear the ears
		img.fill_rect(Rect2i(x, 0, 1, int(line)), hair)
		mask.fill_rect(Rect2i(x, 0, 1, int(line)), Color(1, 1, 1, 1))
		_rect(img, x, line, 1, 2, Color(hair, 0.5))
	img.blend_rect_mask(_strands, mask, Rect2i(0, 0, 256, 256), Vector2i(0, 0))
	img.blend_rect(_noise, Rect2i(0, 0, 256, 256), Vector2i(0, 0))
	# solid skin for the nose and ears (atlas 0.46..0.54, 0.955..0.985)
	img.fill_rect(Rect2i(118, 245, 20, 7), skin.darkened(0.04))
	var m := _material(_finish(img), 0.6)
	_tex[key] = m
	return m


static func _line(img: Image, x0: float, y0: float, x1: float, y1: float, c: Color, wdt: int) -> void:
	var n := int(maxf(absf(x1 - x0), absf(y1 - y0))) + 1
	for i in n + 1:
		var t := float(i) / n
		_rect(img, lerpf(x0, x1, t) - wdt * 0.5, lerpf(y0, y1, t) - wdt * 0.5, wdt, wdt, c)


## Filled V: apex at (cx, top) widening to half-width hw at `bottom`... drawn
## the other way up: widest at the top (a neckline opening).
static func _tri_fill(img: Image, cx: float, top: float, hw: float, bottom: float, c: Color) -> void:
	if c.a <= 0.0:
		return
	var h := maxf(1.0, bottom - top)
	for y in range(int(top), int(bottom)):
		var t := 1.0 - (y - top) / h
		_rect(img, cx - hw * t, y, hw * 2.0 * t + 1, 1, c)
