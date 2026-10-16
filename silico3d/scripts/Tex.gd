extends RefCounted
## Procedural textures, so the slice ships with no image files at all.
## Every one of these can be swapped for a real texture later.


static func _rng(s: int) -> RandomNumberGenerator:
	var r := RandomNumberGenerator.new()
	r.seed = s
	return r


## A tile of 4 x 4 windows (one tile = 12 m of facade). Returns [albedo, emission].
static func facade(s: int, lit_chance: float) -> Array:
	var r := _rng(s)
	var n := 128
	var alb := Image.create(n, n, false, Image.FORMAT_RGB8)
	var emi := Image.create(n, n, false, Image.FORMAT_RGB8)
	var base := Color(0.10, 0.10, 0.11).lerp(Color(0.17, 0.15, 0.14), r.randf())
	alb.fill(base)
	emi.fill(Color.BLACK)
	# streaks of grime running down the concrete
	for i in 18:
		var x := r.randi_range(0, n - 1)
		var y0 := r.randi_range(0, n - 1)
		var ln := r.randi_range(10, 60)
		for y in range(y0, mini(n, y0 + ln)):
			alb.set_pixel(x, y, base.darkened(0.35))
	var palette := [Color(1.0, 0.72, 0.42), Color(1.0, 0.85, 0.6), Color(0.55, 0.8, 1.0),
		Color(0.35, 1.0, 0.65), Color(0.9, 0.5, 1.0)]
	for cy in 4:
		for cx in 4:
			var x0 := cx * 32 + 6
			var y0 := cy * 32 + 7
			var lit := r.randf() < lit_chance
			var pick := r.randf()
			var ci := 0 if pick < 0.5 else (1 if pick < 0.75 else (2 if pick < 0.9 else (3 if pick < 0.96 else 4)))
			var col: Color = palette[ci] * r.randf_range(0.3, 0.75)
			var blind := r.randi_range(0, 12) if r.randf() < 0.5 else 0
			for y in range(y0, y0 + 19):
				for x in range(x0, x0 + 20):
					alb.set_pixel(x, y, Color(0.04, 0.05, 0.06))
					if lit and y >= y0 + blind:
						var f := 0.75 + 0.25 * float(y - y0) / 19.0
						emi.set_pixel(x, y, col * f)
			# frame and sill
			for x in range(x0 - 1, x0 + 21):
				alb.set_pixel(x, y0 + 19, base.lightened(0.15))
	alb.generate_mipmaps()
	emi.generate_mipmaps()
	return [ImageTexture.create_from_image(alb), ImageTexture.create_from_image(emi)]


static func asphalt() -> ImageTexture:
	var r := _rng(7)
	var n := 256
	var img := Image.create(n, n, false, Image.FORMAT_RGB8)
	for y in n:
		for x in n:
			var v := 0.13 + r.randf() * 0.06
			img.set_pixel(x, y, Color(v, v, v * 1.05))
	# cracks and patches
	for i in 14:
		var x := r.randi_range(0, n - 1)
		var y := r.randi_range(0, n - 1)
		for k in 40:
			x = (x + r.randi_range(-1, 1) + n) % n
			y = (y + r.randi_range(0, 1)) % n
			img.set_pixel(x, y, Color(0.03, 0.03, 0.03))
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


static func paving() -> ImageTexture:
	var r := _rng(11)
	var n := 128
	var img := Image.create(n, n, false, Image.FORMAT_RGB8)
	for y in n:
		for x in n:
			var v := 0.16 + r.randf() * 0.04
			if x % 32 == 0 or y % 32 == 0:
				v = 0.08
			img.set_pixel(x, y, Color(v * 1.05, v, v * 0.95))
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


## The two-ring eye glyph from the book. White on transparent; tinted by material.
static func glyph() -> ImageTexture:
	var n := 128
	var img := Image.create(n, n, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	var c := Vector2(n / 2.0, n / 2.0)
	var r := _rng(3)
	for y in n:
		for x in n:
			var d := Vector2(x, y).distance_to(c)
			var a := 0.0
			if absf(d - 54.0) < 4.5 or absf(d - 32.0) < 4.0:
				a = 1.0
			elif d < 10.0:
				a = 1.0
			if a > 0.0:
				a *= r.randf_range(0.65, 1.0)  # spray-paint grain
				img.set_pixel(x, y, Color(1, 1, 1, a))
	# drips
	for i in 6:
		var x := r.randi_range(30, 98)
		var y0 := 70 + r.randi_range(0, 40)
		for y in range(y0, mini(n, y0 + r.randi_range(6, 26))):
			img.set_pixel(x, y, Color(1, 1, 1, 0.8))
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


## The eye that opens in the tower: bloodshot sclera, jade iris, black pupil.
static func eye() -> ImageTexture:
	var n := 256
	var img := Image.create(n, n, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	var c := Vector2(n / 2.0, n / 2.0)
	var r := _rng(41)
	for y in n:
		for x in n:
			var p := Vector2(x, y) - c
			var d := p.length() / (n / 2.0)
			if d > 1.0:
				continue
			var col := Color(0.85, 0.78, 0.7)
			if d > 0.75:
				col = col.lerp(Color(0.5, 0.05, 0.05), (d - 0.75) * 4.0)
			var ang := atan2(p.y, p.x)
			if d < 0.48:
				var fib := 0.5 + 0.5 * sin(ang * 60.0 + r.randf())
				col = Color(0.15, 0.55, 0.38).lerp(Color(0.8, 0.12, 0.08), d * 1.4) * (0.6 + 0.5 * fib)
			if absf(p.x) < 10.0 * (1.0 - absf(p.y) / 64.0) and absf(p.y) < 64.0:
				col = Color(0.0, 0.0, 0.0)
			img.set_pixel(x, y, Color(col.r, col.g, col.b, 1.0))
	# veins
	for i in 30:
		var ang := r.randf() * TAU
		var pos := c + Vector2(cos(ang), sin(ang)) * 124.0
		for k in 40:
			ang += r.randf_range(-0.4, 0.4)
			pos -= Vector2(cos(ang), sin(ang)) * 1.2
			if pos.distance_to(c) < 64.0 or pos.x < 0.0 or pos.y < 0.0 or pos.x >= n or pos.y >= n:
				break
			img.set_pixelv(pos, Color(0.6, 0.02, 0.02, 1.0))
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


## Soft round blob, for drones and headlight flares.
static func blob() -> ImageTexture:
	var n := 32
	var img := Image.create(n, n, false, Image.FORMAT_RGBA8)
	for y in n:
		for x in n:
			var d := Vector2(x - 15.5, y - 15.5).length() / 15.5
			var a := clampf(1.0 - d, 0.0, 1.0)
			img.set_pixel(x, y, Color(1, 1, 1, a * a))
	return ImageTexture.create_from_image(img)


static func _noise_img(n: int, s: int, base: Color, var_amt: float, speck := 0.0, speck_c := Color.BLACK) -> Image:
	var r := _rng(s)
	var img := Image.create(n, n, false, Image.FORMAT_RGB8)
	for y in n:
		for x in n:
			var c := base * (1.0 + r.randf_range(-var_amt, var_amt))
			if speck > 0.0 and r.randf() < speck:
				c = speck_c
			img.set_pixel(x, y, Color(c.r, c.g, c.b))
	return img


static func _tex(img: Image) -> ImageTexture:
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


## Off-coloured grey wallpaper: a faint vertical pattern, water stains, damp.
static func wallpaper() -> ImageTexture:
	var r := _rng(21)
	var n := 128
	var img := _noise_img(n, 21, Color(0.52, 0.52, 0.48), 0.04)
	for y in n:
		for x in n:
			if x % 16 == 0 or (x % 16 == 8 and (y / 4) % 2 == 0):
				img.set_pixel(x, y, img.get_pixel(x, y).darkened(0.12))
	for i in 5:
		var c := Vector2(r.randi_range(0, n), r.randi_range(0, n))
		var rad := r.randf_range(10, 30)
		for y in n:
			for x in n:
				var d := Vector2(x, y).distance_to(c) / rad
				if d < 1.0:
					var p := img.get_pixel(x, y)
					img.set_pixel(x, y, p.lerp(Color(0.45, 0.4, 0.3), (1.0 - d) * 0.35))
	return _tex(img)


## Dusty brown carpet.
static func carpet() -> ImageTexture:
	return _tex(_noise_img(64, 22, Color(0.3, 0.22, 0.15), 0.18, 0.02, Color(0.45, 0.4, 0.32)))


## Laminate floor of a living room.
static func boards() -> ImageTexture:
	var r := _rng(23)
	var n := 128
	var img := Image.create(n, n, false, Image.FORMAT_RGB8)
	for y in n:
		var plank := y / 16
		var tone := 0.32 + r.randf_range(-0.04, 0.04) if y % 16 == 0 else 0.0
		for x in n:
			var c := Color(0.36, 0.3, 0.24) * (1.0 + 0.05 * sin(x * 0.3 + plank * 2.0) + r.randf_range(-0.03, 0.03))
			if y % 16 == 0 or (x + plank * 37) % 96 == 0:
				c = c.darkened(0.4)
			img.set_pixel(x, y, c)
	return _tex(img)


static func wood() -> ImageTexture:
	var r := _rng(24)
	var n := 64
	var img := Image.create(n, n, false, Image.FORMAT_RGB8)
	for y in n:
		for x in n:
			var g := sin(x * 0.5 + sin(y * 0.15) * 2.0) * 0.5 + 0.5
			img.set_pixel(x, y, Color(0.45, 0.32, 0.2) * (0.85 + g * 0.2 + r.randf_range(-0.03, 0.03)))
	return _tex(img)


## Dried blood: a dark irregular splat with a crusted edge and spatter.
static func blood(s := 31) -> ImageTexture:
	var r := _rng(s)
	var n := 128
	var img := Image.create(n, n, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	var c := Vector2(n / 2.0, n / 2.0)
	var lobes := []
	for i in 7:
		lobes.append([c + Vector2(r.randf_range(-22, 22), r.randf_range(-22, 22)), r.randf_range(14, 30)])
	for y in n:
		for x in n:
			var p := Vector2(x, y)
			var best := 9.0
			for l in lobes:
				best = minf(best, p.distance_to(l[0]) / l[1])
			if best < 1.0:
				var edge := smoothstep(0.75, 1.0, best)
				var col := Color(0.2, 0.01, 0.01).lerp(Color(0.32, 0.03, 0.02), edge)
				col = col * (1.0 + r.randf_range(-0.12, 0.12))
				img.set_pixel(x, y, Color(col.r, col.g, col.b, 0.95 - 0.2 * edge))
	for i in 40:
		var a := r.randf() * TAU
		var d := r.randf_range(40, 62)
		var sp := c + Vector2(cos(a), sin(a)) * d
		var rad := r.randf_range(0.8, 2.6)
		for y in range(int(sp.y - 3), int(sp.y + 4)):
			for x in range(int(sp.x - 3), int(sp.x + 4)):
				if x >= 0 and y >= 0 and x < n and y < n and Vector2(x, y).distance_to(sp) < rad:
					img.set_pixel(x, y, Color(0.22, 0.01, 0.01, 0.9))
	return _tex(img)


## A sheet of paper, or a food wrapper: a coloured rectangle with print.
static func paper(s: int) -> ImageTexture:
	var r := _rng(s)
	var n := 32
	var base := Color(0.85, 0.84, 0.8) if r.randf() < 0.6 else Color(r.randf(), r.randf(), r.randf()) * 0.8
	var img := _noise_img(n, s, base, 0.03)
	for row in range(4, n - 4, 3):
		if r.randf() < 0.8:
			for x in range(4, r.randi_range(10, n - 4)):
				img.set_pixel(x, row, base.darkened(0.5))
	return _tex(img)


## Patchy park grass going yellow.
static func grass() -> ImageTexture:
	var r := _rng(41)
	var n := 128
	var img := Image.create(n, n, false, Image.FORMAT_RGB8)
	var patches := []
	for i in 9:
		patches.append([Vector2(r.randi_range(0, n), r.randi_range(0, n)), r.randf_range(8, 26)])
	for y in n:
		for x in n:
			var c := Color(0.3, 0.42, 0.16) * (1.0 + r.randf_range(-0.2, 0.2))
			for p in patches:
				var d: float = Vector2(x, y).distance_to(p[0]) / p[1]
				if d < 1.0:
					c = c.lerp(Color(0.62, 0.55, 0.3) * (1.0 + r.randf_range(-0.1, 0.1)), (1.0 - d) * 0.9)
			img.set_pixel(x, y, c)
	return _tex(img)


## Cracked concrete path.
static func cracked() -> ImageTexture:
	var r := _rng(42)
	var n := 128
	var img := _noise_img(n, 42, Color(0.56, 0.54, 0.5), 0.06)
	for i in 6:
		var p := Vector2(r.randi_range(0, n), r.randi_range(0, n))
		var a := r.randf() * TAU
		for k in 60:
			a += r.randf_range(-0.5, 0.5)
			p += Vector2(cos(a), sin(a))
			var q := Vector2i(posmod(int(p.x), n), posmod(int(p.y), n))
			img.set_pixelv(q, Color(0.25, 0.24, 0.22))
	for y in n:
		if y % 64 == 0:
			for x in n:
				img.set_pixel(x, y, Color(0.35, 0.34, 0.32))
	return _tex(img)


static func bark() -> ImageTexture:
	var r := _rng(43)
	var n := 64
	var img := Image.create(n, n, false, Image.FORMAT_RGB8)
	for y in n:
		for x in n:
			var g := absf(sin(x * 0.6 + sin(y * 0.2) * 1.5))
			var c := Color(0.3, 0.24, 0.18) * (0.6 + g * 0.5 + r.randf_range(-0.05, 0.05))
			# strips peeling away to pale wood
			if (x / 6 + y / 20) % 7 == 0:
				c = Color(0.62, 0.55, 0.42)
			img.set_pixel(x, y, c)
	return _tex(img)


static func concrete(s := 44) -> ImageTexture:
	return _tex(_noise_img(64, s, Color(0.5, 0.48, 0.45), 0.08, 0.01, Color(0.35, 0.33, 0.3)))


static func sand() -> ImageTexture:
	var r := _rng(45)
	var n := 64
	var img := Image.create(n, n, false, Image.FORMAT_RGBA8)
	for y in n:
		for x in n:
			var d := Vector2(x - 31.5, y - 31.5).length() / 32.0
			var a := clampf(1.0 - d, 0.0, 1.0) * (0.6 + r.randf() * 0.4)
			img.set_pixel(x, y, Color(0.72, 0.62, 0.44, a))
	return _tex(img)


## Seth's phone photo: the ring symbol in black spray on rusted bench steel.
static func bench_photo() -> ImageTexture:
	var r := _rng(46)
	var w := 320
	var h := 220
	var img := Image.create(w, h, false, Image.FORMAT_RGB8)
	for y in h:
		for x in w:
			var rust := Color(0.42, 0.24, 0.14).lerp(Color(0.3, 0.3, 0.32), 0.5 + 0.5 * sin(x * 0.05 + y * 0.03))
			if (y / 22) % 2 == 0 and y % 22 < 2:
				rust = rust.darkened(0.6)  # gaps between slats
			img.set_pixel(x, y, rust * (1.0 + r.randf_range(-0.15, 0.15)))
	var c := Vector2(w / 2.0, h / 2.0)
	# uneven rings: "too narrow in some places, too wide in others"
	for y in h:
		for x in w:
			var p := Vector2(x, y) - c
			var a := atan2(p.y, p.x)
			var d := p.length()
			var r1 := 80.0 + sin(a * 3.0) * 7.0
			var r2 := 48.0 + sin(a * 2.0 + 1.0) * 6.0
			var w1 := 6.0 + 4.0 * sin(a * 5.0)
			var w2 := 5.0 + 3.0 * sin(a * 4.0 + 2.0)
			if absf(d - r1) < w1 or absf(d - r2) < w2:
				if r.randf() < 0.85:
					img.set_pixel(x, y, Color(0.03, 0.03, 0.03))
	return _tex(img)
