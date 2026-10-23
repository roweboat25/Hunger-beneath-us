class_name Face
extends Node3D
## Prototype (look=cine): faces that read at conversation distance, the way
## Fallout: New York's generated people did. Its creator's critics scored the
## first people "mannequins or dolls up close"; what fixed it was faces with
## real eyes that blink and look at you and mouths that move when they talk.
##
## Three changes over Body's 256 px painted face:
## - a 1024 px face texture (sockets, lid creases, nasolabial folds, lips,
##   brows in strokes, pores, stubble), painted with Body's helpers;
## - real eyes: a glossy eyeball, iris and pupil that turn to the camera,
##   and skin lids that blink;
## - a mouth that opens for speech (dark inside, a line of teeth).
## `rig()` adds them to a Body head; this node animates them.

const EYE_X := 0.035
const EYE_Y := 0.022
const EYE_Z := -0.085
const EYE_R := 0.0138
const MOUTH := Vector3(0, -0.06, -0.1)
const LID_REST := 0.34

## The sculpted head is this much wider than Body's skull: a broader face
const WIDE := 1.06

static var _hd := {}

var talking := false
## > 0 holds the mouth that open (for stills)
var hold_open := 0.0
var _lids: Array = []
var _irises: Array = []
var _mouth: Node3D
var _t := 0.0
var _next_blink := 1.0
var _blink := 0.0
var _seed := 0


## Called by Body.build with the head node, after the head mesh exists.
static func rig(head: Node3D, skin: Color, hair: Color, seed: int, skull: Array) -> Face:
	var f := Face.new()
	f.name = "Face"
	f._seed = seed
	head.add_child(f)
	var lid_m := StandardMaterial3D.new()
	lid_m.albedo_color = skin.darkened(0.06)
	lid_m.roughness = 0.55
	lid_m.cull_mode = BaseMaterial3D.CULL_DISABLED
	var white := StandardMaterial3D.new()
	white.albedo_color = Color(0.86, 0.84, 0.8)
	white.roughness = 0.12
	white.metallic_specular = 0.8
	var iris_c: Color = [Color(0.3, 0.17, 0.07), Color(0.22, 0.4, 0.52), Color(0.32, 0.36, 0.18), Color(0.13, 0.08, 0.05)][seed % 4]
	var iris := StandardMaterial3D.new()
	iris.albedo_color = iris_c
	iris.roughness = 0.08
	iris.metallic_specular = 1.0
	var pupil := StandardMaterial3D.new()
	pupil.albedo_color = Color(0.01, 0.01, 0.01)
	pupil.roughness = 0.05
	pupil.metallic_specular = 1.0
	for s: float in [-1.0, 1.0]:
		var eye := Node3D.new()
		# sat in its socket, a little proud of the floor
		eye.position = surf(skull, s * EYE_X, EYE_Y) + Vector3(0, 0, EYE_R * 0.4)
		f.add_child(eye)
		var ball := SphereMesh.new()
		ball.radius = EYE_R
		ball.height = EYE_R * 2.0
		ball.radial_segments = 16
		ball.rings = 8
		_mesh(eye, ball, white)
		# iris and pupil turn together inside the eye
		var look := Node3D.new()
		eye.add_child(look)
		var ir := SphereMesh.new()
		ir.radius = EYE_R * 0.6
		ir.height = EYE_R * 0.36
		ir.radial_segments = 14
		ir.rings = 4
		_mesh(look, ir, iris).position = Vector3(0, 0, -EYE_R * 0.9)
		var pu := SphereMesh.new()
		pu.radius = EYE_R * 0.24
		pu.height = EYE_R * 0.2
		pu.radial_segments = 10
		pu.rings = 3
		_mesh(look, pu, pupil).position = Vector3(0, 0, -EYE_R * 1.02)
		f._irises.append(look)
		# lids: an upper hemisphere that rolls down to blink, a fixed lower one
		for up: bool in [true, false]:
			var piv := Node3D.new()
			eye.add_child(piv)
			_mesh(piv, _dome(EYE_R * 1.12), lid_m)
			piv.rotation.x = LID_REST if up else PI - 0.5
			if up:
				f._lids.append(piv)
	# the mouth: dark inside, a row of teeth, both flat until he speaks
	f._mouth = Node3D.new()
	f._mouth.position = surf(skull, 0.0, MOUTH.y) + Vector3(0, 0, -0.0035)
	f.add_child(f._mouth)
	var inside := StandardMaterial3D.new()
	inside.albedo_color = Color(0.09, 0.02, 0.02)
	inside.roughness = 0.95
	var gap := SphereMesh.new()
	gap.radius = 0.0165
	gap.height = 0.033
	gap.radial_segments = 14
	gap.rings = 6
	_mesh(f._mouth, gap, inside).scale = Vector3(1.0, 0.5, 0.2)
	var teeth := StandardMaterial3D.new()
	teeth.albedo_color = Color(0.82, 0.78, 0.66)
	teeth.roughness = 0.3
	var tm := BoxMesh.new()
	tm.size = Vector3(0.022, 0.0045, 0.003)
	_mesh(f._mouth, tm, teeth).position = Vector3(0, 0.0045, -0.003)
	f._mouth.scale = Vector3(1, 0.05, 1)
	f._next_blink = 0.5 + (seed % 7) * 0.45
	return f


## The top half of a sphere, pole at +y (an eyelid before it is turned).
static func _dome(r: float) -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	const LON := 18
	const LAT := 6
	for i in LAT:
		for j in LON:
			var q := []
			for k: Vector2i in [Vector2i(i, j), Vector2i(i, j + 1), Vector2i(i + 1, j + 1), Vector2i(i + 1, j)]:
				var la := PI * 0.5 * k.x / LAT
				var lo := TAU * k.y / LON
				q.append([Vector3(sin(la) * cos(lo), cos(la), sin(la) * sin(lo)) * r, Vector2(float(k.y) / LON, float(k.x) / LAT)])
			Body._tri(st, q[0], q[1], q[2])
			Body._tri(st, q[0], q[2], q[3])
	st.generate_normals()
	return st.commit()


static func _mesh(parent: Node3D, m: Mesh, mt: Material) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.mesh = m
	mi.material_override = mt
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	parent.add_child(mi)
	return mi


func _process(delta: float) -> void:
	_t += delta
	# blink: down fast, up a little slower, every 2-6 s, sometimes twice
	_next_blink -= delta
	if _next_blink <= 0.0:
		_blink = 0.0001
		_next_blink = 2.0 + fmod(_t * 7.31 + _seed, 4.0)
	if _blink > 0.0:
		_blink += delta
		if _blink > 0.22:
			_blink = 0.0
	var close := 0.0
	if _blink > 0.0:
		close = _blink / 0.07 if _blink < 0.07 else 1.0 - (_blink - 0.07) / 0.15
	for l: Node3D in _lids:
		l.rotation.x = lerpf(LID_REST, -1.35, clampf(close, 0.0, 1.0))
	# eyes find the camera when it is in front of them
	var cam := get_viewport().get_camera_3d()
	if cam:
		for i: Node3D in _irises:
			var lp: Vector3 = i.get_parent().to_local(cam.global_position)
			if lp.z < -0.2:
				var want := Vector2(clampf(atan2(lp.y, -lp.z), -0.35, 0.3), clampf(atan2(-lp.x, -lp.z), -0.5, 0.5))
				i.rotation.x = lerpf(i.rotation.x, want.x, minf(delta * 10.0, 1.0))
				i.rotation.y = lerpf(i.rotation.y, want.y, minf(delta * 10.0, 1.0))
	# speech: two beating sines read as syllables
	var open := 0.05
	if talking:
		open = 0.12 + 0.88 * absf(sin(_t * 10.5) * sin(_t * 3.3 + 0.7))
	if hold_open > 0.0:
		open = hold_open
	_mouth.scale.y = lerpf(_mouth.scale.y, open, minf(delta * 22.0, 1.0))


# ------------------------------------------------------------------ the face texture

## The same layout as Body.face_mat (u round the head, front at 0.5; v from
## the crown at y 0.155 to the chin at -0.2), four times the resolution, with
## the eyes and inner mouth left to the 3D rig.
static func face_mat_hd(skin: Color, hair: Color, fem: bool, seed: int) -> StandardMaterial3D:
	var key := "hd%s%s%s%s" % [skin.to_html(), hair.to_html(), fem, seed % 5]
	if _hd.has(key):
		return _hd[key]
	const W := 1024
	var img := Image.create(W, W, false, Image.FORMAT_RGBA8)
	img.fill(skin)
	var vy := func(y: float) -> float: return (0.155 - y) / 0.355 * W
	var ux := func(x: float) -> float: return W * 0.5 + asin(clampf(x / 0.088, -1.0, 1.0)) / TAU * W
	var shade := skin.darkened(0.3)
	var deep := skin.darkened(0.5)
	var warm := skin.lerp(Color(0.85, 0.32, 0.28), 0.22)
	var lite := skin.lightened(0.14)
	# light from above: forehead and nose catch it, the jaw falls off
	Body._ell(img, W * 0.5, vy.call(0.07), 150, 60, Color(lite, 0.35), 1.0)
	Body._ell(img, W * 0.5, vy.call(-0.15), 260, 70, Color(shade, 0.7), 0.9)
	Body._ell(img, W * 0.5, vy.call(-0.1), 150, 30, Color(shade, 0.35), 1.0)
	for s: float in [-1.0, 1.0]:
		var ex: float = ux.call(s * EYE_X)
		var ey: float = vy.call(EYE_Y)
		# the socket the eyeball sits in, darker in the inner corner
		Body._ell(img, ex, ey, 46, 30, Color(deep, 0.6), 1.0)
		Body._ell(img, ex - s * 18, ey + 4, 16, 16, Color(deep, 0.45), 1.0)
		# lid crease and the bag under the eye
		for k in 3:
			Body._line(img, ex - 30, ey - 26 + k, ex + 30, ey - 26 + k, Color(shade, 0.18), 2)
		Body._ell(img, ex, ey + 28, 30, 9, Color(shade, 0.3), 1.0)
		# brow: a ridge of light under it, then strokes of hair
		Body._ell(img, ex, vy.call(0.052), 40, 10, Color(lite, 0.35), 1.0)
		var bx0: float = ex - s * 36
		var by0: float = vy.call(0.039)
		for k in 46:
			var t := k / 45.0
			var bx: float = lerpf(bx0, ex + s * 40, t)
			var by: float = by0 - sin(t * PI) * 10.0 + t * 6.0 - (2.0 if fem else 0.0)
			var len := 9.0 if not fem else 6.0
			Body._line(img, bx, by + 6, bx + s * len * 0.8, by - 3, Color(hair.darkened(0.3), 0.85), 3)
			Body._line(img, bx + 2, by + 9, bx + s * len, by + 1, Color(hair.darkened(0.2), 0.6), 2)
		# cheeks, cheekbones, the fold from nose to mouth
		Body._ell(img, ux.call(s * 0.052), vy.call(-0.028), 40, 34, Color(warm, 0.4), 1.0)
		Body._ell(img, ux.call(s * 0.074), vy.call(-0.058), 26, 60, Color(shade, 0.35), 1.0)
		for k in 22:
			var t := k / 21.0
			var fx: float = lerpf(ux.call(s * 0.02), ux.call(s * 0.03), t)
			var fy: float = lerpf(vy.call(-0.03), vy.call(-0.064), t)
			Body._ell(img, fx, fy, 5, 5, Color(shade, 0.22), 1.0)
		# nostril
		Body._ell(img, ux.call(s * 0.011), vy.call(-0.032), 9, 5, Color(deep, 0.7), 0.6)
	# nose: ridge highlight and the shadow under the tip
	Body._ell(img, W * 0.5, vy.call(-0.005), 12, 70, Color(lite, 0.45), 1.0)
	Body._ell(img, W * 0.5, vy.call(-0.04), 34, 10, Color(shade, 0.5), 1.0)
	# lips
	var lips := skin.lerp(Color(0.6, 0.2, 0.2), 0.5 if fem else 0.32)
	var my: float = vy.call(MOUTH.y)
	Body._ell(img, W * 0.5, my - 7, 44, 9, lips.darkened(0.1))
	Body._ell(img, W * 0.5, my + 9, 38, 11, lips)
	Body._ell(img, W * 0.5, my + 7, 18, 4, Color(lips.lightened(0.25), 0.6), 1.0)
	Body._rect(img, W * 0.5 - 44, my, 88, 3, Color(0.2, 0.07, 0.06))
	Body._ell(img, W * 0.5, my - 18, 10, 9, Color(shade, 0.3), 1.0)  # philtrum
	Body._ell(img, W * 0.5, vy.call(-0.085), 26, 12, Color(shade, 0.35), 1.0)  # chin
	if not fem and seed % 2 == 0:
		var rng := RandomNumberGenerator.new()
		rng.seed = seed
		for k in 2600:
			var a := rng.randf_range(-0.95, 0.95)
			var y := rng.randf_range(-0.12, -0.04)
			if absf(y - MOUTH.y) < 0.006 and absf(a) < 0.3:
				continue
			var px: float = W * 0.5 + a / TAU * W
			Body._rect(img, px, vy.call(y), 2, 2, Color(hair.darkened(0.2), 0.35))
	# ears
	for ex: float in [W * 0.25, W * 0.75]:
		Body._ell(img, ex, vy.call(0.0), 34, 60, Color(warm.darkened(0.1), 0.8))
		Body._ell(img, ex, vy.call(0.0), 16, 34, Color(shade, 0.6))
	# pores and blotches
	var nz := FastNoiseLite.new()
	nz.seed = seed
	nz.frequency = 0.06
	for y in range(0, W, 2):
		for x in range(0, W, 2):
			var n := nz.get_noise_2d(x, y)
			if absf(n) > 0.25:
				var c := img.get_pixel(x, y)
				img.fill_rect(Rect2i(x, y, 2, 2), c.darkened(0.06) if n > 0 else c.lightened(0.04))
	# hairline, as Body draws it, with strands
	for x in W:
		var a := (x / float(W)) * TAU - PI
		var t := (1.0 - cos(a)) * 0.5
		var line: float = lerpf(vy.call(0.082), vy.call(-0.075 if not fem else -0.2), pow(t, 1.4))
		if fem and absf(a) > 0.55:
			line = maxf(line, lerpf(vy.call(-0.02), vy.call(-0.2), clampf((absf(a) - 0.55) * 2.0, 0.0, 1.0)))
		line += sin(x * 0.18 + seed) * 6.0 + sin(x * 0.9) * 2.0
		if absf(absf(a) - PI * 0.5) < 0.22 and not fem:
			line = minf(line, vy.call(0.035))
		img.fill_rect(Rect2i(x, 0, 1, int(line)), hair)
		var st := hair.darkened(0.25) if (x * 7 + seed) % 5 < 2 else hair.lightened(0.12)
		if x % 3 == 0:
			img.fill_rect(Rect2i(x, 0, 1, int(line)), hair.lerp(st, 0.35))
		Body._rect(img, x, line, 1, 6, Color(hair, 0.45))
	# solid skin for the nose and ears atlas (Body's 0.46..0.54, 0.955..0.985)
	img.fill_rect(Rect2i(int(W * 0.46), int(W * 0.955), int(W * 0.08), int(W * 0.03)), skin.darkened(0.04))
	img.generate_mipmaps()
	var m := StandardMaterial3D.new()
	m.albedo_texture = ImageTexture.create_from_image(img)
	m.roughness = 0.62
	m.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
	# a little subsurface warmth on the desktop renderer
	m.subsurf_scatter_enabled = true
	m.subsurf_scatter_strength = 0.25
	m.subsurf_scatter_skin_mode = true
	_hd[key] = m
	return m


# ------------------------------------------------------------------ the head

## Body's skull rings ([y, rx, rz, zoff]) at height y, interpolated.
static func _ring(skull: Array, y: float) -> Array:
	for i in skull.size() - 1:
		var a: Array = skull[i]
		var b: Array = skull[i + 1]
		if y >= float(a[0]) and y <= float(b[0]):
			var t := (y - float(a[0])) / maxf(float(b[0]) - float(a[0]), 0.0001)
			var out := []
			for k in 4:
				out.append(lerpf(float(a[k]) if a.size() > k else 0.0, float(b[k]) if b.size() > k else 0.0, t))
			return out
	return skull[0] if y < float(skull[0][0]) else skull[skull.size() - 1]


static func _g(dx: float, dy: float, sx: float, sy: float) -> float:
	return exp(-(dx * dx) / (2.0 * sx * sx) - (dy * dy) / (2.0 * sy * sy))


## How far the face pushes forward (+) or sinks (-) at texture-space x
## (Body's face_mat measures x as 0.088 * sin(angle)) and height y.
static func _relief(x: float, y: float) -> float:
	var ax := absf(x)
	var d := 0.0
	d -= 0.011 * _g(ax - EYE_X, y - EYE_Y, 0.014, 0.011)  # eye sockets
	d += 0.006 * _g(ax - 0.03, y - 0.046, 0.026, 0.006)  # brow ridge
	d += 0.004 * _g(ax - 0.052, y + 0.012, 0.012, 0.014)  # cheekbones
	# the nose: a ridge growing to a tip, and its wings
	var ny := clampf((0.03 - y) / 0.06, 0.0, 1.0)
	d += (0.004 + 0.018 * ny * ny) * _g(x, 0.0, 0.006 + 0.006 * ny, 1.0) * (1.0 if y > -0.036 else _g(0.0, y + 0.036, 1.0, 0.004))
	d += 0.007 * _g(ax - 0.012, y + 0.031, 0.006, 0.005)
	d += 0.005 * _g(x, y - MOUTH.y + 0.004, 0.02, 0.006)  # upper lip
	d += 0.005 * _g(x, y - MOUTH.y - 0.008, 0.017, 0.005) * -1.0 + 0.004 * _g(x, y - MOUTH.y + 0.012, 0.018, 0.006)  # lips
	d += 0.008 * _g(x, y + 0.088, 0.018, 0.01)  # chin
	d -= 0.004 * _g(ax - 0.045, y + 0.06, 0.012, 0.016)  # under the cheekbones
	return d


## A point on the sculpted face at texture-space x, height y.
static func surf(skull: Array, x: float, y: float) -> Vector3:
	var r := _ring(skull, y)
	var a := asin(clampf(x / 0.088, -1.0, 1.0))
	var p := Vector3(sin(a) * float(r[1]) * WIDE, y, -cos(a) * float(r[2]) + float(r[3]))
	p.z -= _relief(x, y) * maxf(cos(a), 0.0)
	return p


## The head as one smooth sculpted surface with the same UVs as Body's skull
## loft (u round the head with the front at 0.5, v from crown to neck), so
## either face texture fits it.
static func sculpt(st: SurfaceTool, skull: Array) -> void:
	const COLS := 48
	const ROWS := 44
	var y0: float = skull[skull.size() - 1][0]
	var y1: float = skull[0][0]
	var pts := []
	for i in ROWS + 1:
		var y := lerpf(y0, y1, float(i) / ROWS)
		var r := _ring(skull, y)
		var row := []
		for j in COLS + 1:
			var a := -PI + TAU * j / COLS
			var p := Vector3(sin(a) * float(r[1]) * WIDE, y, -cos(a) * float(r[2]) + float(r[3]))
			p.z -= _relief(0.088 * sin(a), y) * maxf(cos(a), 0.0)
			row.append([p, Vector2(float(j) / COLS, (y0 - y) / (y0 - y1))])
		pts.append(row)
	for i in ROWS:
		for j in COLS:
			var a: Array = pts[i][j]
			var b: Array = pts[i][j + 1]
			var c: Array = pts[i + 1][j + 1]
			var d: Array = pts[i + 1][j]
			Body._tri(st, a, b, c)
			Body._tri(st, a, c, d)
	Body._cap(st, pts[0], Vector3(0, y0, float(_ring(skull, y0)[3])), Vector2(0.5, 0.0), true)
