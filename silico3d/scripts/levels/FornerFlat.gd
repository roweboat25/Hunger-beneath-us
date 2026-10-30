extends "res://scripts/Level.gd"
## Forner's flat (the open city, a side case: SideCases.gd "forner").
## Lamplight, the far tower, high up. One room and a bedroom, the window
## facing the city, the chair facing the window. The door on Lamplight
## (SideCases._forner_door) brings Carl here; the pillow runs the case's
## Psyon step (SideCases.forner_psyon); the door takes him back out.

const LINES := {
	"objective": "His Psyon. The bedroom, on the pillow.",
	"objective_done": "Leave. His car's charge log is next: the post on the Spine.",
	"first": "Phillip Forner's floor was littered with laundry, clothes and takeout boxes. The door hadn't been locked. He'd been living like a man who expected to be too much for himself, and then he had been.",
	"photo": "A photograph over the chair, hung where he'd see it sitting down. A woman laughing on a pier with her hair in her face. CHEYENNE, in his hand on the frame, and a date eleven years gone.",
	"photo_frames": "Under the date, newer, in the same hand: two rings. The frames put a small teal tag on her. KNOWN. IN SESSION.",
	"photo_log": "Forner's wife was Cheyenne, eleven years dead. Her photo hangs where his chair faces. The frames tag her as IN SESSION.",
	"chair": "The chair faced the window and the window faced the city. Silico, for Forner, was a passive expression of humanity's futility, grown over a century. He longed for art. He longed for love. The seat was still warm, and the room was cold.",
	"kitchen": "Nothing in the kitchen had been used in a week. The coffee maker had a cup under it that had been poured and not drunk.",
	"pills": "(game) A SalTech blister pack by the sink, half punched out. The label had his name and a word the frames translated for me without being asked: palliative.",
	"pills_log": "(game) SalTech palliatives at Forner's, half gone. He was sick before any of this.",
	"laundry": "Laundry on the floor in drifts. The frames read the labels for me without being asked: Psyonic Integrations, staff issue, Psyonic Integrations, staff issue.",
	"takeout": "Takeout boxes, a week of them, stacked in order. Every receipt was stapled to its lid. Every one had the same note from the driver: ENJOY THE LIGHTS.",
	"takeout_log": "A week of takeout at Forner's, every receipt reading ENJOY THE LIGHTS.",
	"tv": "The television was on with the sound off: the digital vigil, live, a street of lit frames and raised tablets. The ticker under it read FARGONA AVE and a view count that went up while I stood there.",
	"dresser": "Her things, still in the top drawer. He'd never cleared it. Eleven years of a drawer.",
	"computer": "His computer, smashed. He'd said so in the war room and he'd meant it: the screen folded back on itself, the keyboard cracked down the middle, the frames beside it bent. 'I smashed my computer.'",
	"computer2": "Psyon doesn't live in a computer.",
	"computer_log": "Forner smashed his computer the night Psyon spoke as Cheyenne. It didn't help.",
	"hub": "(game) His home hub, unplugged, the cord wrapped round it twice and knotted. Whatever it had said to him, he'd wanted it to stop.",
	"window": "(game) The city from forty floors: the Spine's blades, the tower's red lights going up the shaft, and Fargona to the south where a street had turned the colour of a screen.",
	"exit": "(game) I left the door the way I'd found it. Unlocked.",
	"hud": "ORA  ·  Forner, P.  ·  residence",
	"phone": "[b]PSYON[/b]\n\n[color=#7fe6b0]Psyon:[/color] You're in a stranger's home, Carl. He'd want you to make yourself comfortable.\n\n",
	"p": {"photo": "Look at the photograph", "chair": "Look at the chair", "kitchen": "Look at the kitchen", "pills": "Look at the pills",
		"laundry": "Look at the laundry", "takeout": "Look at the takeout", "tv": "Look at the television", "dresser": "Open the dresser",
		"computer": "Look at the computer", "hub": "Look at the home hub", "window": "Look out of the window",
		"pillow": "The pillow", "flat_exit": "Leave"},
	"s": {"photo": "PHOTO  ·  CHEYENNE FORNER  ·  IN SESSION", "pillow": "PSYON TABLET  ·  SESSION OPEN  ·  CHEYENNE",
		"tv": "SILICO LIVE  ·  FARGONA AVE  ·  VIEWERS RISING", "pills": "SALTECH  ·  PALLIATIVE  ·  FORNER, P."},
	"tv_ticker": "FARGONA AVE  ·  LIVE",
	"takeout_lid": "ENJOY THE LIGHTS",
}

const W := 5.0           # half width
const ZN := -6.0         # the window wall
const ZS := 4.0          # the door wall
const H := 2.8
const GROUND := -110.0   # the street, forty floors down

var _tv_light: OmniLight3D
var _tv_t := 0.0


func build(m: Node) -> void:
	main = m
	rng.seed = 4040
	kit_day = false
	spawn = Vector3(0.0, 0.1, 3.0)
	spawn_yaw = 0.0
	_shell()
	_living()
	_bedroom()
	_kitchen()
	_city()
	_batch(self, 30.0)


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	var psm := ProceduralSkyMaterial.new()
	psm.sky_top_color = Color(0.01, 0.01, 0.03)
	psm.sky_horizon_color = Color(0.2, 0.08, 0.14)
	psm.ground_horizon_color = Color(0.16, 0.06, 0.1)
	psm.ground_bottom_color = Color(0.02, 0.015, 0.02)
	psm.sky_curve = 0.14
	env.sky.sky_material = psm
	env.ambient_light_color = Color(0.2, 0.2, 0.3)
	env.ambient_light_energy = 0.22
	env.fog_light_color = Color(0.14, 0.06, 0.12)
	env.fog_density = 0.004
	env.fog_sky_affect = 0.3
	env.glow_bloom = 0.06
	env.tonemap_exposure = 1.1
	sun.light_color = Color(0.5, 0.55, 0.8)
	sun.light_energy = 0.12
	sun.sky_mode = DirectionalLight3D.SKY_MODE_LIGHT_ONLY
	sun.rotation = Vector3(deg_to_rad(-40), deg_to_rad(170), 0)


func ambience() -> void:
	main.loop("wind", -30.0)


# ------------------------------------------------------------------ the room

func _wall(size: Vector3, pos: Vector3, m: Material) -> void:
	box(size, pos, m, true)


func _shell() -> void:
	var plaster := pbr("plaster", Vector3(4, 2, 1), false, Color(0.62, 0.6, 0.58))
	var floor_m := pbr("woodfloor", Vector3(5, 5, 1), false, Color(0.55, 0.5, 0.46))
	box(Vector3(W * 2.0 + 0.4, 0.2, ZS - ZN + 0.4), Vector3(0, -0.1, (ZS + ZN) / 2.0), floor_m, true)
	box(Vector3(W * 2.0 + 0.4, 0.2, ZS - ZN + 0.4), Vector3(0, H + 0.1, (ZS + ZN) / 2.0), mat(Color(0.3, 0.3, 0.32)), false)
	# west, east, south (with the door), the window wall
	_wall(Vector3(0.2, H, ZS - ZN), Vector3(-W - 0.1, H / 2.0, (ZS + ZN) / 2.0), plaster)
	_wall(Vector3(0.2, H, ZS - ZN), Vector3(W + 0.1, H / 2.0, (ZS + ZN) / 2.0), plaster)
	_wall(Vector3(W - 0.6, H, 0.2), Vector3(-(W + 0.6) / 2.0, H / 2.0, ZS + 0.1), plaster)
	_wall(Vector3(W - 0.6, H, 0.2), Vector3((W + 0.6) / 2.0, H / 2.0, ZS + 0.1), plaster)
	_wall(Vector3(1.2, H - 2.2, 0.2), Vector3(0, 2.2 + (H - 2.2) / 2.0, ZS + 0.1), plaster)
	var door := box(Vector3(1.1, 2.15, 0.08), Vector3(0, 1.08, ZS + 0.02), mat(Color(0.2, 0.17, 0.15), 0.6), false)
	door.name = "door"
	box(Vector3(0.06, 0.06, 0.12), Vector3(0.42, 1.0, ZS - 0.05), mat(Color(0.7, 0.68, 0.6), 0.3, 0.8), false)
	var ex := interactable("flat_exit", LINES["p"]["flat_exit"], Vector3(0, 1.1, ZS - 0.2), Vector3(1.2, 2.2, 0.4))
	ex.set_meta("exit", true)
	# the window: sill, head, mullions, glass; a hidden wall in the glass
	_wall(Vector3(0.5, H, 0.2), Vector3(-W + 0.25, H / 2.0, ZN - 0.1), plaster)
	_wall(Vector3(W - 1.0, H, 0.2), Vector3(1.0 + (W - 1.0) / 2.0, H / 2.0, ZN - 0.1), plaster)
	_wall(Vector3(5.5, 0.7, 0.2), Vector3(-1.75, 0.35, ZN - 0.1), plaster)
	_wall(Vector3(5.5, 0.4, 0.2), Vector3(-1.75, H - 0.2, ZN - 0.1), plaster)
	solid_box(Vector3(5.5, H, 0.1), Vector3(-1.75, H / 2.0, ZN - 0.12))
	var frame := mat(Color(0.12, 0.12, 0.14), 0.4, 0.6)
	for x in [-4.5, -2.65, -0.85, 1.0]:
		box(Vector3(0.06, 1.7, 0.08), Vector3(x, 1.55, ZN - 0.05), frame, false)
	box(Vector3(5.5, 0.06, 0.08), Vector3(-1.75, 0.72, ZN - 0.05), frame, false)
	var glass := StandardMaterial3D.new()
	glass.albedo_color = Color(0.25, 0.32, 0.4, 0.14)
	glass.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	glass.roughness = 0.05
	glass.metallic = 0.4
	quad(Vector2(5.5, 1.7), Vector3(-1.75, 1.55, ZN - 0.08), 0.0, glass)
	interactable("window", LINES["p"]["window"], Vector3(-3.4, 1.5, ZN + 0.2), Vector3(1.6, 1.2, 0.3), "", false)
	# a dead ceiling lamp, a skirting line
	cyl(0.22, 0.3, 0.16, Vector3(-1.0, H - 0.1, -1.5), mat(Color(0.5, 0.48, 0.42)), 10)
	box(Vector3(W * 2.0, 0.08, 0.02), Vector3(0, 0.04, ZS - 0.01), mat(Color(0.2, 0.18, 0.16)), false)
	# the light: the city through the glass, a lamp by the door
	light(Vector3(-1.8, 2.0, ZN + 1.0), Color(0.5, 0.45, 0.9), 1.3, 7.5, false)
	light(Vector3(0.0, 2.3, ZS - 0.8), Color(1.0, 0.72, 0.5), 0.45, 4.5, false)


func _living() -> void:
	var fabric := pbr("fabric", Vector3(1, 1, 1), false, Color(0.32, 0.22, 0.2))
	# the chair facing the window
	var cx := -1.6
	var cz := -3.8
	box(Vector3(0.9, 0.42, 0.85), Vector3(cx, 0.21, cz), fabric, false)
	box(Vector3(0.9, 0.75, 0.2), Vector3(cx, 0.72, cz + 0.42), fabric, false)
	box(Vector3(0.16, 0.25, 0.85), Vector3(cx - 0.45, 0.55, cz), fabric, false)
	box(Vector3(0.16, 0.25, 0.85), Vector3(cx + 0.45, 0.55, cz), fabric, false)
	interactable("chair", LINES["p"]["chair"], Vector3(cx, 0.5, cz), Vector3(1.1, 1.0, 1.0))
	# her photograph on the west wall, where he'd see it sitting down
	box(Vector3(0.04, 0.62, 0.82), Vector3(-W + 0.03, 1.6, -3.4), mat(Color(0.35, 0.28, 0.18), 0.5), false)
	var pic := Image.create(32, 24, false, Image.FORMAT_RGB8)
	for y in 24:
		for x in 32:
			var sky := y < 12
			var c := Color(0.55, 0.62, 0.72) if sky else Color(0.2, 0.28, 0.36)
			if x > 12 and x < 20 and y > 6:
				c = Color(0.85, 0.66, 0.55) if y < 11 else Color(0.8, 0.3, 0.25)
			if x > 11 and x < 21 and y > 4 and y < 8:
				c = Color(0.25, 0.16, 0.1)
			if y == 16 or (x > 2 and x < 10 and y > 15):
				c = Color(0.36, 0.26, 0.18)
			pic.set_pixel(x, y, c)
	var pm := StandardMaterial3D.new()
	pm.albedo_texture = ImageTexture.create_from_image(pic)
	pm.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	quad(Vector2(0.72, 0.52), Vector3(-W + 0.06, 1.62, -3.4), PI / 2.0, pm)
	label("CHEYENNE", Vector3(-W + 0.07, 1.31, -3.4), PI / 2.0, 0.0016, Color(0.9, 0.85, 0.7), self, false)
	interactable("photo", LINES["p"]["photo"], Vector3(-W + 0.25, 1.6, -3.4), Vector3(0.4, 0.8, 1.0), LINES["s"]["photo"], false)
	# the television on the bedroom wall, the vigil with the sound off
	box(Vector3(0.08, 0.86, 1.46), Vector3(1.45, 1.42, -4.3), mat(Color(0.04, 0.04, 0.05), 0.3, 0.4), false)
	var tvm := StandardMaterial3D.new()
	tvm.albedo_texture = _vigil_tex()
	tvm.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	tvm.emission_enabled = true
	tvm.emission_texture = tvm.albedo_texture
	tvm.emission_energy_multiplier = 1.4
	quad(Vector2(1.36, 0.76), Vector3(1.4, 1.42, -4.3), -PI / 2.0, tvm)
	label(LINES["tv_ticker"], Vector3(1.39, 1.1, -4.3), -PI / 2.0, 0.0012, Color(1.0, 0.85, 0.3))
	interactable("tv", LINES["p"]["tv"], Vector3(1.2, 1.4, -4.3), Vector3(0.4, 0.9, 1.5), LINES["s"]["tv"], false)
	_glyph_on(Vector3(1.39, 1.62, -3.85), -PI / 2.0, 0.0025, "forner_tv", false, false, "an eye in the corner of the broadcast")
	_tv_light = light(Vector3(0.6, 1.4, -4.3), Color(0.45, 0.6, 1.0), 0.9, 4.0, false)
	# the desk and what he did to the computer
	var wood := pbr("woodfloor", Vector3(1, 1, 1), false, Color(0.35, 0.26, 0.2))
	box(Vector3(0.8, 0.06, 1.7), Vector3(-W + 0.45, 0.75, 1.0), wood, false)
	for dz in [0.2, 1.8]:
		box(Vector3(0.7, 0.72, 0.05), Vector3(-W + 0.45, 0.36, dz), wood, false)
	var scr := box(Vector3(0.05, 0.42, 0.66), Vector3(-W + 0.42, 0.95, 1.2), mat(Color(0.05, 0.05, 0.06), 0.3, 0.3), false)
	scr.rotation = Vector3(0.0, 0.0, 1.1)
	var kb1 := box(Vector3(0.18, 0.03, 0.22), Vector3(-W + 0.6, 0.795, 0.82), mat(Color(0.14, 0.14, 0.15)), false)
	kb1.rotation.y = 0.3
	var kb2 := box(Vector3(0.18, 0.03, 0.22), Vector3(-W + 0.66, 0.795, 0.58), mat(Color(0.14, 0.14, 0.15)), false)
	kb2.rotation = Vector3(0.1, -0.25, 0.0)
	box(Vector3(0.05, 0.04, 0.16), Vector3(-W + 0.75, 0.8, 1.55), mat(Color(0.1, 0.1, 0.1), 0.3, 0.6), false)
	for i in 6:
		var shard := box(Vector3(0.05, 0.005, 0.04), Vector3(-W + 0.9 + rng.randf() * 0.5, 0.005, 0.6 + rng.randf() * 0.9), mat(Color(0.5, 0.6, 0.7), 0.1, 0.5), false)
		shard.rotation.y = rng.randf() * TAU
	interactable("computer", LINES["p"]["computer"], Vector3(-W + 0.45, 0.9, 1.0), Vector3(0.9, 0.5, 1.2))
	# the home hub, unplugged and knotted
	cyl(0.08, 0.09, 0.12, Vector3(-W + 0.35, 0.84, 1.75), mat(Color(0.22, 0.22, 0.24), 0.4, 0.3), 10)
	interactable("hub", LINES["p"]["hub"], Vector3(-W + 0.35, 0.9, 1.75), Vector3(0.3, 0.3, 0.3), "", false)
	# laundry in drifts
	var cloth := [Color(0.25, 0.27, 0.32), Color(0.4, 0.38, 0.34), Color(0.18, 0.2, 0.22), Color(0.5, 0.48, 0.45)]
	for p in [Vector3(-2.6, 0, -0.6), Vector3(-0.2, 0, 0.9), Vector3(-1.2, 0, -2.2), Vector3(0.6, 0, -1.4), Vector3(-3.4, 0, 1.6), Vector3(2.8, 0, -2.0)]:
		for k in 3:
			var b := box(Vector3(0.5 + rng.randf() * 0.3, 0.05 + rng.randf() * 0.06, 0.35 + rng.randf() * 0.3),
				p + Vector3(rng.randf_range(-0.3, 0.3), 0.03 + k * 0.03, rng.randf_range(-0.3, 0.3)), mat(cloth[(k + int(p.x * 3.0)) % 4]), false)
			b.rotation.y = rng.randf() * TAU
	interactable("laundry", LINES["p"]["laundry"], Vector3(-1.2, 0.3, -1.6), Vector3(1.2, 0.6, 1.2), "", false)
	# a week of takeout by the door
	var lid := mat(Color(0.78, 0.74, 0.66))
	for i in 7:
		var tb := box(Vector3(0.34, 0.12, 0.26), Vector3(-2.7 + (i % 2) * 0.05, 0.06 + i * 0.12, 3.4), lid, false)
		tb.rotation.y = rng.randf_range(-0.15, 0.15)
	label(LINES["takeout_lid"], Vector3(-2.7, 0.75, 3.26), 0.0, 0.0009, Color(0.8, 0.2, 0.2), self, false)
	interactable("takeout", LINES["p"]["takeout"], Vector3(-2.7, 0.5, 3.4), Vector3(0.6, 1.0, 0.5))


func _bedroom() -> void:
	var plaster := pbr("plaster", Vector3(3, 2, 1), false, Color(0.55, 0.53, 0.52))
	# the partition: a door gap at z -2.7..-1.3
	_wall(Vector3(0.12, H, 3.3), Vector3(1.5, H / 2.0, -4.35), plaster)
	_wall(Vector3(0.12, H, 0.8), Vector3(1.5, H / 2.0, -0.9), plaster)
	_wall(Vector3(0.12, H - 2.2, 1.4), Vector3(1.5, 2.2 + (H - 2.2) / 2.0, -2.0), plaster)
	_wall(Vector3(3.5, H, 0.12), Vector3(3.25, H / 2.0, -0.5), plaster)
	# the bed, unmade; the pillow; his frames and the tablet on it
	var fabric := pbr("fabric", Vector3(1, 1, 1), false, Color(0.3, 0.32, 0.38))
	box(Vector3(2.0, 0.45, 2.2), Vector3(3.6, 0.225, -4.7), mat(Color(0.18, 0.15, 0.13)), true)
	var sheet := box(Vector3(1.9, 0.08, 1.6), Vector3(3.55, 0.49, -4.35), fabric, false)
	sheet.rotation.y = 0.06
	box(Vector3(1.2, 0.14, 0.45), Vector3(3.6, 0.53, -5.45), mat(Color(0.8, 0.8, 0.78)), false)
	box(Vector3(0.14, 0.02, 0.05), Vector3(3.45, 0.61, -5.4), mat(Color(0.1, 0.1, 0.1), 0.2, 0.7), false)
	box(Vector3(0.14, 0.02, 0.05), Vector3(3.62, 0.61, -5.4), mat(Color(0.1, 0.1, 0.1), 0.2, 0.7), false)
	var tab := box(Vector3(0.24, 0.015, 0.17), Vector3(3.9, 0.61, -5.35), glow(Color(0.3, 1.0, 0.85), 1.6), false)
	tab.rotation.y = 0.2
	var tl := label("CHEYENNE", Vector3(3.9, 0.63, -5.35), 0.0, 0.0008, Color(0.6, 1.0, 0.9), self, false)
	tl.rotation = Vector3(-PI / 2.0, 0.2, 0)
	box(Vector3(2.0, 0.9, 0.12), Vector3(3.6, 0.65, -5.85), mat(Color(0.16, 0.13, 0.11)), false)
	interactable("pillow", LINES["p"]["pillow"], Vector3(3.6, 0.7, -5.2), Vector3(1.2, 0.6, 0.7), LINES["s"]["pillow"], false)
	light(Vector3(3.8, 0.95, -5.0), Color(0.3, 1.0, 0.85), 0.7, 2.6, false)
	# the dresser: her things in the top drawer
	var wood := pbr("woodfloor", Vector3(1, 1, 1), false, Color(0.3, 0.22, 0.17))
	box(Vector3(0.6, 1.0, 1.2), Vector3(W - 0.3, 0.5, -1.4), wood, true)
	for y in [0.25, 0.55, 0.85]:
		box(Vector3(0.02, 0.22, 1.0), Vector3(W - 0.61, y, -1.4), mat(Color(0.25, 0.18, 0.13)), false)
	interactable("dresser", LINES["p"]["dresser"], Vector3(W - 0.55, 0.7, -1.4), Vector3(0.3, 0.6, 1.2), "", false)


func _kitchen() -> void:
	var top := pbr("concrete", Vector3(1, 1, 1), false, Color(0.5, 0.5, 0.52))
	box(Vector3(0.7, 0.92, 3.0), Vector3(W - 0.35, 0.46, 2.1), mat(Color(0.22, 0.22, 0.24)), true)
	box(Vector3(0.74, 0.05, 3.04), Vector3(W - 0.35, 0.945, 2.1), top, false)
	box(Vector3(0.3, 0.36, 0.26), Vector3(W - 0.3, 1.15, 1.0), mat(Color(0.1, 0.1, 0.11), 0.4, 0.5), false)
	cyl(0.045, 0.04, 0.1, Vector3(W - 0.35, 1.02, 0.96), mat(Color(0.85, 0.85, 0.82)), 10)
	interactable("kitchen", LINES["p"]["kitchen"], Vector3(W - 0.4, 1.1, 1.0), Vector3(0.6, 0.5, 0.6), "", false)
	box(Vector3(0.12, 0.02, 0.07), Vector3(W - 0.4, 0.98, 2.7), mat(Color(0.75, 0.78, 0.82), 0.3, 0.6), false)
	box(Vector3(0.12, 0.02, 0.07), Vector3(W - 0.46, 0.98, 2.82), mat(Color(0.75, 0.78, 0.82), 0.3, 0.6), false)
	interactable("pills", LINES["p"]["pills"], Vector3(W - 0.42, 1.05, 2.76), Vector3(0.4, 0.3, 0.4), LINES["s"]["pills"], false)
	# under-cabinet strip, half dead
	box(Vector3(0.05, 0.02, 2.4), Vector3(W - 0.2, 1.8, 2.1), glow(Color(1.0, 0.8, 0.55), 0.8), false)
	box(Vector3(0.4, 0.6, 3.0), Vector3(W - 0.2, 2.1, 2.1), mat(Color(0.24, 0.24, 0.26)), false)
	light(Vector3(W - 0.8, 1.7, 2.1), Color(1.0, 0.78, 0.55), 0.55, 3.6, false)


## The city through the glass: blocks to the horizon, the tower's red lights.
func _city() -> void:
	var c := Node3D.new()
	c.name = "city"
	add_child(c)
	kit_parent = c
	floor_quad(Vector2(1600, 1600), Vector3(0, GROUND, -400), 0.0, mat(Color(0.08, 0.06, 0.08), 1.0), c)
	for i in 46:
		var px := rng.randf_range(-320.0, 320.0)
		var pz := rng.randf_range(-480.0, -60.0)
		var h := rng.randf_range(50.0, 170.0)
		if rng.randf() < 0.2:
			h = rng.randf_range(190.0, 260.0)
		cyber_block(Vector3(px, GROUND, pz), 0.0, rng.randf_range(16.0, 32.0), h, rng.randf_range(16.0, 30.0), false, 1)
	kit_holo(Vector3(-60, -10, -120), 0.2, "PSYON", "the pillow for those who dream", Color(0.4, 1.0, 0.6), 22.0)
	kit_holo(Vector3(90, 20, -220), -0.3, "TOKZ", "sleep better. sleep together.", Color(1.0, 0.25, 0.7), 26.0)
	# the tower, far off, its red lights going up the shaft
	var jade := mat(Color(0.2, 0.45, 0.38), 0.3, 0.7)
	var tp := Vector3(160, GROUND, -520)
	cyl(9, 16, 320, tp + Vector3(0, 160, 0), jade, 16, c)
	for i in 10:
		box(Vector3(1.2, 3.0, 1.2), tp + Vector3(cos(i * 0.6) * 10.0, 40 + i * 28, sin(i * 0.6) * 10.0), glow(Color(1, 0.05, 0.05), 3.0), false, c)
	# Fargona to the south-west: a street the colour of a screen
	box(Vector3(10.0, 0.5, 260.0), Vector3(-140, GROUND + 0.3, -300), glow(Color(0.35, 0.8, 1.0), 2.2), false, c)
	kit_parent = self
	_batch(c, 80.0, true)


func _vigil_tex() -> ImageTexture:
	var img := Image.create(48, 27, false, Image.FORMAT_RGB8)
	var r := RandomNumberGenerator.new()
	r.seed = 7
	for y in 27:
		for x in 48:
			var base := Color(0.03, 0.04, 0.08).lerp(Color(0.1, 0.12, 0.2), float(y) / 27.0)
			img.set_pixel(x, y, base)
	for i in 40:
		var x := r.randi_range(1, 46)
		var y := r.randi_range(10, 22)
		img.set_pixel(x, y, Color(0.4, 0.9, 1.0))
		img.set_pixel(x, y - 1, Color(0.2, 0.5, 0.7))
	for x in 48:
		img.set_pixel(x, 24, Color(0.9, 0.7, 0.2))
		img.set_pixel(x, 25, Color(0.9, 0.7, 0.2))
	return ImageTexture.create_from_image(img)


# ------------------------------------------------------------------ the hooks

func tick(delta: float) -> void:
	_tv_t += delta
	if is_instance_valid(_tv_light):
		_tv_light.light_energy = 0.75 + 0.25 * sin(_tv_t * 7.0) * sin(_tv_t * 2.3)


func intro() -> void:
	if main.flags.has("forner_flat_seen") or main._selftest:
		main.flags["forner_flat_seen"] = true
		return
	main.flags["forner_flat_seen"] = true
	await main.ui.think(LINES["first"])
	main.ui.close()


func objective() -> String:
	var cs = main.city.get("cases")
	if cs and cs.done("forner", "psyon"):
		return LINES["objective_done"]
	return LINES["objective"]


func phone() -> String:
	return LINES["phone"]


func interact(node: Object) -> bool:
	var ui = main.ui
	var f: Dictionary = main.flags
	var id: String = str(node.get_meta("id"))
	match id:
		"pillow":
			await main.city.cases.forner_psyon()
		"flat_exit":
			await ui.think(LINES["exit"])
			ui.close()
			main.city.cases.leave_flat()
		"photo":
			await ui.think(LINES["photo"])
			if main.frames_on and not f.has("forner_photo"):
				await ui.think(LINES["photo_frames"])
				main.add_connection(1.0, "her picture")
			ui.close()
			if not f.has("forner_photo"):
				f["forner_photo"] = true
				main.log_line("evidence", LINES["photo_log"])
		"computer":
			await ui.think(LINES["computer"])
			await ui.think(LINES["computer2"])
			ui.close()
			if not f.has("forner_computer"):
				f["forner_computer"] = true
				main.log_line("evidence", LINES["computer_log"])
		"takeout":
			await ui.think(LINES["takeout"])
			ui.close()
			if not f.has("forner_takeout"):
				f["forner_takeout"] = true
				main.log_line("evidence", LINES["takeout_log"])
		"pills":
			await ui.think(_strip(LINES["pills"]))
			ui.close()
			if not f.has("forner_pills"):
				f["forner_pills"] = true
				main.log_line("evidence", _strip(LINES["pills_log"]))
		"chair", "kitchen", "laundry", "tv", "dresser", "hub", "window":
			await ui.think(_strip(LINES[id]))
			ui.close()
		_:
			return false
	main.update_hud()
	return true


func _strip(t: String) -> String:
	return t.trim_prefix("(game) ")


## Every flavour item once (the side-case test: SideCases.selftest).
func selftest_items() -> void:
	for id in ["photo", "chair", "kitchen", "pills", "laundry", "takeout", "tv", "dresser", "computer", "hub", "window"]:
		var n := by_id(id)
		if n == null:
			print("CASES missing flat item ", id)
			continue
		await main.interact(n)
	await check_walk("forner flat: spawn->bedroom (pillow side)", Vector3(3.6, 0.0, -3.1), null, Rect2(-W, ZN, W * 2.0, ZS - ZN), 1.0)
	await check_walk("forner flat: spawn->kitchen", "kitchen")
	await check_walk("forner flat: spawn->takeout", "takeout")


func selftest() -> void:
	for id in ["pillow", "photo", "computer", "chair", "flat_exit", "tv", "dresser", "window"]:
		await check_walk("forner flat: " + id, id)
	await selftest_items()
