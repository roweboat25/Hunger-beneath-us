extends Node3D
## Silico in first person: a test slice of the Spine at night.
## Carl walks the boulevard toward the Psyonic tower. With the frames on (G)
## he reads the two-ring glyphs; each decodes a line of the chant and raises
## the connection. At 25 the power goes and the crowd turns to watch him. At
## 50 the tower opens its eye. Walking the garden path to the tower ends it.
##
## Dev/test arguments (after "--" on the command line, or ?key=value in the
## browser URL): conn=N, frames=1, at=x,y,z, yaw=deg, pitch=deg, eye=1,
## outage=1, scan=1, shot=path.png, wait=frames, selftest=1.

const CityS := preload("res://scripts/City.gd")
const PlayerS := preload("res://scripts/Player.gd")
const UIS := preload("res://scripts/UI.gd")
const CrowdS := preload("res://scripts/Crowd.gd")
const TrafficS := preload("res://scripts/Traffic.gd")
const Synth := preload("res://scripts/Synth.gd")

## Same chant as the 2D game (scripts/Game.gd), in the same order.
const CHANT := [
	"Psyon is the pillow for those who dream.",
	"Psyon is the path for those who walk.",
	"Close the eyes that lie, and see.",
	"The floor is a door. The door is a floor.",
	"Ruin and reflection. Mimicry.",
	"A clean wound. Something has to break first.",
	"All must walk the path alone.",
	"Look for the eye and know peace.",
	"The tower is crumbling. The walls are speaking.",
	"Gather, sleeper. Gather.",
]

var city: Node3D
var player: CharacterBody3D
var ui: CanvasLayer
var crowd: Node3D
var traffic: Node3D
var env: Environment

var connection := 0.0
var frames_on := false
var flags := {}
var glyphs_found := 0
var outage := false
var started := false
var shot_mode := false
var sfx := {}
var _sfx_pool: Array = []
var _amb := {}
var _scan_labels: Array = []
var _target: Object = null
var _ended := false
var _phone_on := false
var _listened := false
var _args := {}
var _selftest := false


func _ready() -> void:
	_setup_input()
	_args = _read_args()
	_make_sounds()
	_setup_env()
	city = CityS.new()
	add_child(city)
	city.build(self)
	player = PlayerS.new()
	add_child(player)
	player.position = Vector3(5.5, 0.2, 104.0)
	player.locked = true
	player.stepped.connect(_on_step)
	traffic = TrafficS.new()
	add_child(traffic)
	traffic.setup(self)
	crowd = CrowdS.new()
	add_child(crowd)
	crowd.setup(self)
	_rain()
	ui = UIS.new()
	add_child(ui)
	ui.setup(self)
	city.set_glyph_visibility(false, 0.0)
	_ambience()
	_update_hud()
	if not _args.is_empty():
		_apply_args()


# ------------------------------------------------------------------ setup

func _key(action: String, keys: Array) -> void:
	if not InputMap.has_action(action):
		InputMap.add_action(action)
	for k in keys:
		var ev := InputEventKey.new()
		ev.physical_keycode = k
		InputMap.action_add_event(action, ev)


func _setup_input() -> void:
	_key("move_fwd", [KEY_W, KEY_UP])
	_key("move_back", [KEY_S, KEY_DOWN])
	_key("move_left", [KEY_A])
	_key("move_right", [KEY_D])
	_key("turn_left", [KEY_LEFT])
	_key("turn_right", [KEY_RIGHT])
	_key("look_up", [KEY_PAGEUP])
	_key("look_down", [KEY_PAGEDOWN])
	_key("run", [KEY_SHIFT])
	_key("interact", [KEY_E, KEY_ENTER, KEY_SPACE])
	_key("frames", [KEY_G])
	_key("scan", [KEY_F])
	_key("psyon", [KEY_P])
	_key("release", [KEY_ESCAPE])


func _setup_env() -> void:
	env = Environment.new()
	env.background_mode = Environment.BG_SKY
	var sky := Sky.new()
	var psm := ProceduralSkyMaterial.new()
	psm.sky_top_color = Color(0.012, 0.014, 0.035)
	psm.sky_horizon_color = Color(0.2, 0.08, 0.06)
	psm.ground_horizon_color = Color(0.2, 0.08, 0.06)
	psm.ground_bottom_color = Color(0.02, 0.015, 0.015)
	psm.sky_curve = 0.08
	sky.sky_material = psm
	env.sky = sky
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.22, 0.22, 0.3)
	env.ambient_light_energy = 0.45
	env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	env.tonemap_exposure = 1.1
	env.glow_enabled = true
	env.glow_intensity = 0.9
	env.glow_strength = 1.0
	env.glow_bloom = 0.04
	env.glow_hdr_threshold = 0.85
	env.glow_blend_mode = Environment.GLOW_BLEND_MODE_SCREEN
	env.fog_enabled = true
	env.fog_light_color = Color(0.16, 0.11, 0.12)
	env.fog_density = 0.0055
	env.fog_sky_affect = 0.35
	var we := WorldEnvironment.new()
	we.environment = env
	add_child(we)
	var moon := DirectionalLight3D.new()
	moon.light_color = Color(0.55, 0.6, 0.8)
	moon.light_energy = 0.18
	moon.shadow_enabled = true
	moon.sky_mode = DirectionalLight3D.SKY_MODE_LIGHT_ONLY
	moon.rotation = Vector3(deg_to_rad(-48), deg_to_rad(35), 0)
	add_child(moon)


func _rain() -> void:
	var p := CPUParticles3D.new()
	p.amount = 2200
	p.lifetime = 0.9
	p.preprocess = 1.0
	p.local_coords = false
	p.emission_shape = CPUParticles3D.EMISSION_SHAPE_BOX
	p.emission_box_extents = Vector3(20, 0.5, 20)
	p.direction = Vector3(0.08, -1, 0.02)
	p.spread = 2.0
	p.gravity = Vector3.ZERO
	p.initial_velocity_min = 17.0
	p.initial_velocity_max = 21.0
	var q := QuadMesh.new()
	q.size = Vector2(0.012, 0.5)
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	m.albedo_color = Color(0.7, 0.8, 0.9, 0.28)
	m.billboard_mode = BaseMaterial3D.BILLBOARD_FIXED_Y
	m.billboard_keep_scale = true
	q.material = m
	p.mesh = q
	p.position = Vector3(0, 14, -6)
	player.add_child(p)


func _make_sounds() -> void:
	sfx["rain"] = Synth.rain()
	sfx["hum"] = Synth.hum()
	sfx["chant"] = Synth.chant()
	sfx["step"] = Synth.step()
	sfx["outage"] = Synth.outage()
	sfx["sting"] = Synth.sting()
	sfx["on"] = Synth.blip(true)
	sfx["off"] = Synth.blip(false)
	sfx["glitch"] = Synth.glitch()
	sfx["whisper"] = Synth.whisper()
	sfx["car"] = Synth.car()
	sfx["fire"] = Synth.fire()
	for i in 6:
		var ap := AudioStreamPlayer.new()
		add_child(ap)
		_sfx_pool.append(ap)


func play(key: String, db := 0.0, pitch := 1.0) -> void:
	for ap in _sfx_pool:
		if not ap.playing:
			ap.stream = sfx[key]
			ap.volume_db = db
			ap.pitch_scale = pitch
			ap.play()
			return


func _loop(key: String, db: float, at = null, unit := 4.0, max_d := 40.0) -> Node:
	var ap: Node
	if at == null:
		ap = AudioStreamPlayer.new()
		ap.volume_db = db
	else:
		ap = AudioStreamPlayer3D.new()
		ap.volume_db = db
		ap.unit_size = unit
		ap.max_distance = max_d
		ap.position = at
	ap.stream = sfx[key]
	add_child(ap)
	_amb[key] = ap
	return ap


func _ambience() -> void:
	_loop("rain", -9.0)
	_loop("hum", -13.0)
	_loop("chant", 0.0, Vector3(-13.4, 1.6, 14.0), 3.0, 30.0)
	_loop("fire", -2.0, Vector3(-30.0, 1.0, -30.0), 2.0, 20.0)


func _start_ambience() -> void:
	for k in _amb:
		_amb[k].play()


# ------------------------------------------------------------------ flow

func start() -> void:
	if started:
		return
	started = true
	ui.title.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player.locked = false
	_start_ambience()
	await get_tree().create_timer(1.2).timeout
	await ui.think("The Spine. One long boulevard between the places that mattered, and the tower in the middle of it like a pin through a map.")
	await ui.think("The rot never reached the tower. Everything around it existed in anticipation of something, a silent, electric tension humming in the wet air.")
	await ui.think("With the frames on, the walls had started to have opinions.")
	ui.close()


func _unhandled_input(e: InputEvent) -> void:
	if not started:
		return
	if e.is_action_pressed("release"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		return
	if e is InputEventMouseButton and e.pressed and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		return
	if ui.busy or player.locked:
		return
	if e.is_action_pressed("interact") and _target:
		interact(_target)
	elif e.is_action_pressed("frames"):
		toggle_frames()
	elif e.is_action_pressed("scan"):
		scan()
	elif e.is_action_pressed("psyon"):
		toggle_phone()


func _process(_d: float) -> void:
	if not started:
		return
	player.locked = ui.busy or flags.has("cinematic")
	if player.global_position.y < -4.0:
		player.global_position = Vector3(player.global_position.x, 0.5, player.global_position.z)
		player.velocity = Vector3.ZERO
	if _args.has("debug") and Engine.get_process_frames() % 10 == 0:
		print("pos ", player.global_position, " fps ", Engine.get_frames_per_second())
	_target = null if ui.busy else player.looked_at()
	if _target and is_instance_valid(_target):
		ui.prompt.text = "E   " + str(_target.get_meta("prompt"))
	else:
		ui.prompt.text = ""
	ui.crosshair.color.a = 0.9 if _target else 0.4
	if flags.has("eye_open") and not _ended and player.global_position.z < -196.0:
		_ended = true
		_ending()


func toggle_frames() -> void:
	frames_on = not frames_on
	play("on" if frames_on else "off", -6.0)
	ui.set_frames(1.0 if frames_on else 0.0, connection)
	city.set_glyph_visibility(frames_on, connection)
	if frames_on:
		ui.glitch(0.4, 0.4)
	_update_hud()


func add_connection(v: float, why: String) -> void:
	var old := connection
	connection = minf(100.0, connection + v)
	ui.show_toast("Connection +%d   %s" % [int(v), why], 2.5)
	ui.set_frames(1.0 if frames_on else 0.0, connection)
	city.set_glyph_visibility(frames_on, connection)
	_update_hud()
	if old < 25.0 and connection >= 25.0:
		_outage()
	elif old < 50.0 and connection >= 50.0:
		_eye()


func _update_hud() -> void:
	var obj := ""
	if flags.has("eye_open"):
		obj = "Walk to the tower."
	elif flags.has("outage_done"):
		obj = "Keep reading the rings. Some of them are red now."
	elif frames_on or glyphs_found > 0:
		obj = "Find the two-ring signs with the frames on. E to read them."
	else:
		obj = "Walk the Spine toward the tower.   G puts the frames on."
	ui.objective.text = obj
	if frames_on:
		ui.status.text = "FRAMES ON    CONNECTION %d" % int(connection)
		ui.status.add_theme_color_override("font_color", Color(1.0, 0.35, 0.3) if connection >= 25.0 else Color(0.5, 1.0, 0.9))
	else:
		ui.status.text = "frames off"
		ui.status.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6, 0.7))


func _on_step() -> void:
	play("step", -16.0, randf_range(0.85, 1.15))


# ------------------------------------------------------------------ interactions

func interact(node: Object) -> void:
	var id: String = node.get_meta("id")
	if node.has_meta("glyph"):
		await _glyph(node)
		return
	match id:
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
			if connection >= 50.0:
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
			await ui.think("Nothing I could make sense of.")
	ui.close()


func _glyph(g: Object) -> void:
	if g.get_meta("found"):
		await ui.think("The rings. I'd already read them. They had already read me.")
		ui.close()
		return
	if not frames_on:
		await ui.think(str(g.get_meta("desc")))
		await ui.think("Without the frames on, they were just rings.")
		ui.close()
		return
	g.set_meta("found", true)
	glyphs_found += 1
	play("glitch", -4.0)
	ui.glitch(0.9, 0.7)
	await ui.think(str(g.get_meta("desc")))
	var line: String = CHANT[(glyphs_found - 1) % CHANT.size()]
	await ui.say("", "[color=#6fe8d0]The rings resolved the way a word does when you stop trying to read it.[/color]\n\n[b]" + line + "[/b]")
	ui.close()
	add_connection(6.0 if g.get_meta("deep") else 5.0, "the rings")


func _preacher() -> void:
	if _listened:
		await ui.say("Eyeless man", "Gather, sleeper. Gather.")
		ui.close()
		return
	await ui.think("He stood in the middle of the sidewalk with his face turned up to the rain, and where his eyes should have been there was only clean, healed skin.")
	await ui.say("Eyeless man", "Psyon is the pillow for those who dream. Psyon is the path for those who walk.")
	var pick: int = await ui.choose(["Walk on.", "Listen."])
	if pick == 1:
		_listened = true
		await ui.say("Eyeless man", "Close the eyes that lie, and see. The floor is a door. The door is a floor.")
		await ui.think("He said it like a lullaby. I stood there longer than I meant to. The frames had started recording before I told them to.")
		ui.close()
		add_connection(4.0, "listened to the preacher")
	else:
		await ui.think("I walked on. Behind me the chant kept the same even pace, like it hadn't needed me at all.")
		ui.close()


func scan() -> void:
	if not frames_on:
		ui.show_toast("The frames have to be on to scan (G).", 2.0)
		return
	for l in _scan_labels:
		if is_instance_valid(l):
			l.queue_free()
	_scan_labels.clear()
	play("on", -10.0, 1.4)
	var me := player.global_position
	for n in _all_with_meta(city, "scan"):
		var p: Vector3 = (n as Node3D).global_position
		if p.distance_to(me) < 26.0:
			_card(p + Vector3(0, 1.5, 0), str(n.get_meta("scan")))
	var near: Array = crowd.peds.duplicate()
	near.sort_custom(func(a, b): return a.node.global_position.distance_to(me) < b.node.global_position.distance_to(me))
	for i in mini(5, near.size()):
		var n: Node3D = near[i].node
		if n.global_position.distance_to(me) < 26.0:
			var sync := "sync 100%  -  DREAMING" if connection >= 25.0 else "sync %d%%" % (90 + (i * 7) % 10)
			_card(n.global_position + Vector3(0, 2.2, 0), "CITIZEN\nPsyon 4.1  -  " + sync + "\nsleep score: 100")
	get_tree().create_timer(7.0).timeout.connect(func():
		for l in _scan_labels:
			if is_instance_valid(l):
				l.queue_free()
		_scan_labels.clear())


func _card(p: Vector3, text: String) -> void:
	var l := Label3D.new()
	l.text = "ORA  //  " + text
	l.position = p
	l.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	l.no_depth_test = true
	l.fixed_size = true
	l.pixel_size = 0.0009
	l.font_size = 28
	l.outline_size = 8
	l.outline_modulate = Color(0, 0, 0, 0.8)
	l.modulate = Color(1.0, 0.5, 0.45) if connection >= 25.0 else Color(0.55, 1.0, 0.9)
	add_child(l)
	_scan_labels.append(l)


func _all_with_meta(n: Node, key: String) -> Array:
	var out := []
	for c in n.get_children():
		if c.has_meta(key):
			out.append(c)
		out.append_array(_all_with_meta(c, key))
	return out


func toggle_phone() -> void:
	_phone_on = not _phone_on
	ui.phone.visible = _phone_on
	play("on" if _phone_on else "off", -12.0, 0.8)
	if not _phone_on:
		return
	var sync := 94 + int(connection / 10.0)
	var t := "[b]PSYON[/b]   [color=#888888]sync %d%%[/color]\n\n" % mini(sync, 100)
	t += "[color=#7fe6b0]Psyon:[/color] Good evening, Carl. You're walking. Your heart rate says you'd rather be driving.\n\n"
	if glyphs_found > 0:
		t += "[color=#7fe6b0]Psyon:[/color] You've been reading the walls. I can help with that. Reading is what I'm for.\n\n"
	if connection >= 25.0:
		t += "[color=#e08080]Psyon:[/color] The outage was localised and brief. Nobody was looking at you. Everyone was looking at you.\n\n"
	if connection >= 50.0:
		t += "[color=#e08080]Psyon:[/color] Gather, sleeper. The tower remembers you. Come closer.\n\n"
	t += "[color=#888888](P to put the phone away)[/color]"
	ui.phone_text.text = t


# ------------------------------------------------------------------ set pieces

func _outage() -> void:
	flags["outage_seen"] = true
	await get_tree().create_timer(1.0).timeout
	outage = true
	flags["cinematic"] = true
	play("outage", 2.0)
	player.shake(0.7)
	city.set_power(false, 0.5)
	crowd.everyone_faces(player.global_position)
	create_tween().tween_property(_amb["hum"], "volume_db", -40.0, 1.0)
	create_tween().tween_property(_amb["chant"], "volume_db", 6.0, 3.0)
	await get_tree().create_timer(0.8).timeout
	flags.erase("cinematic")
	ui.show_toast("The power went. All of it. Every window on the Spine at once. Only the tower stayed lit.", 4.0)
	await get_tree().create_timer(5.0).timeout
	play("whisper", -2.0)
	await get_tree().create_timer(4.0).timeout
	for i in 3:
		city.set_power(true, 0.04)
		await get_tree().create_timer(0.1).timeout
		city.set_power(false, 0.04)
		await get_tree().create_timer(0.3).timeout
	city.set_power(true, 0.2)
	crowd.everyone_faces(player.global_position)
	play("sting", -2.0)
	ui.flash(0.6)
	ui.glitch(0.6, 0.8)
	create_tween().tween_property(_amb["hum"], "volume_db", -13.0, 2.0)
	create_tween().tween_property(_amb["chant"], "volume_db", 0.0, 3.0)
	outage = false
	flags["outage_done"] = true
	_update_hud()
	ui.show_toast("When the lights came back, every one of them was looking at me.", 5.0)


func _eye() -> void:
	flags["eye_open"] = true
	await get_tree().create_timer(1.0).timeout
	flags["cinematic"] = true
	play("sting", 0.0, 0.8)
	ui.glitch(1.0, 1.6)
	player.shake(0.5)
	city.open_eye()
	await player.face(Vector3(0, 540.0, city.TOWER_Z), 2.2)
	play("whisper", 0.0, 0.9)
	ui.show_toast("The tower was looking back.", 5.0)
	await get_tree().create_timer(2.0).timeout
	flags.erase("cinematic")
	_update_hud()


func _ending() -> void:
	flags["cinematic"] = true
	await ui.think("The garden path. Cacti and palms, a sterile nod to the desert outside. The cameras on their poles turned to watch me come.")
	await ui.think("Up there, in the middle of the donut on its stick, the eye didn't blink. It didn't need to. It had been watching me since I was a kid craning my neck at it.")
	ui.close()
	flags.erase("cinematic")
	ui.show_end("[center]\n\n\n[b]END OF THE TEST SLICE[/b]\n\n"
		+ "Rings read: %d of %d        Connection: %d\n\n" % [glyphs_found, city.glyphs.size(), int(connection)]
		+ "[color=#aaaaaa]A first-person test of Silico, built from the book.\nThe tower lobby, the flats and the lab under them would come next.[/color]\n\n"
		+ "[color=#777777]E to keep walking[/color][/center]")


# ------------------------------------------------------------------ dev args and screenshots

func _read_args() -> Dictionary:
	var a := {}
	for s in OS.get_cmdline_user_args():
		var kv := s.trim_prefix("--").split("=", true, 1)
		a[kv[0]] = kv[1] if kv.size() > 1 else "1"
	if OS.has_feature("web"):
		var q = JavaScriptBridge.eval("window.location.search", true)
		if q is String and q.length() > 1:
			for part in (q as String).substr(1).split("&"):
				var kv := part.split("=", true, 1)
				a[kv[0]] = kv[1].uri_decode() if kv.size() > 1 else "1"
	return a


func _apply_args() -> void:
	if _args.has("noglow"):
		env.glow_enabled = false
	if _args.has("nofog"):
		env.fog_enabled = false
	if _args.has("noui"):
		ui.overlay.visible = false
	if _args.has("at"):
		var v: PackedStringArray = str(_args["at"]).split(",")
		if v.size() == 3:
			player.position = Vector3(float(v[0]), float(v[1]), float(v[2]))
	if _args.has("yaw"):
		player.yaw = deg_to_rad(float(_args["yaw"]))
	if _args.has("pitch"):
		player.pitch = deg_to_rad(float(_args["pitch"]))
	if _args.has("conn"):
		connection = float(_args["conn"])
		if connection >= 25.0:
			flags["outage_seen"] = true
			flags["outage_done"] = true
		if connection >= 50.0:
			flags["eye_open"] = true
			city.open_eye()
	if _args.has("eye"):
		flags["eye_open"] = true
		city.open_eye()
	if _args.has("frames"):
		frames_on = true
		ui.set_frames(1.0, connection)
	city.set_glyph_visibility(frames_on, connection)
	if _args.has("outage"):
		outage = true
		city.set_power(false, 0.01)
		crowd.everyone_faces(player.global_position)
	_update_hud()
	if _args.has("shot") or _args.has("selftest"):
		shot_mode = true
		started = true
		ui.title.visible = false
		player.locked = false
		_run_test.call_deferred()


func _run_test() -> void:
	var wait := int(_args.get("wait", "90"))
	for i in wait:
		await get_tree().process_frame
	if _args.has("scan"):
		scan()
		for i in 5:
			await get_tree().process_frame
	if _args.has("say"):
		ui.say("", "[i]" + str(_args["say"]) + "[/i]")
		await get_tree().create_timer(2.0).timeout
	if _args.has("shot"):
		var img := get_viewport().get_texture().get_image()
		img.save_png(str(_args["shot"]))
		print("SHOT ", _args["shot"])
	if _args.has("selftest"):
		await _selftest_all()
	get_tree().quit()


## Fires every interactable and glyph with dialogue auto-advancing, then
## drives the outage and the eye, so a headless run catches script errors.
func _selftest_all() -> void:
	_selftest = true
	var pump := func():
		while _selftest:
			await get_tree().process_frame
			ui.advanced.emit()
			ui.picked.emit(1)
	pump.call()
	frames_on = true
	connection = 30.0
	city.set_glyph_visibility(true, connection)
	var nodes := _all_with_meta(city, "id") + _all_with_meta(crowd, "id")
	for n in nodes:
		await interact(n)
		print("ok ", n.get_meta("id"))
	scan()
	toggle_phone()
	toggle_phone()
	connection = 20.0
	add_connection(6.0, "test")
	await get_tree().create_timer(16.0).timeout
	add_connection(30.0, "test")
	await get_tree().create_timer(6.0).timeout
	player.position = Vector3(0, 0.2, -200)
	await get_tree().create_timer(1.0).timeout
	_process(0.016)
	await get_tree().create_timer(1.0).timeout
	print("SELFTEST DONE glyphs=", glyphs_found, " conn=", connection, " flags=", flags.keys())
	_selftest = false
