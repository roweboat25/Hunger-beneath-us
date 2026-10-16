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
