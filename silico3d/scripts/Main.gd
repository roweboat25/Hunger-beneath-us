extends Node3D
## Silico in first person. Main owns what carries between places: Carl
## (the player), the screen (UI), the frames, the connection, story flags,
## sound, and loading levels. Each level (scripts/levels/) builds its place
## and runs its own scenes through the hooks in Level.gd.
##
## Chapters 1 and 2 of the book: Dufredy's apartment -> the officer at the
## door -> the drive -> Harmony Green park. Separately: the Spine at night.
##
## Dev/test arguments (after "--" on the command line, or ?key=value in the
## browser URL): level=Dufredy|Drive|Park|Spine, flags=a,b, conn=N,
## frames=1, at=x,y,z, yaw=deg, pitch=deg, eye=1, outage=1, scan=1,
## shot=path.png, wait=frames, selftest=1, debug=1.

const PlayerS := preload("res://scripts/Player.gd")
const UIS := preload("res://scripts/UI.gd")
const Synth := preload("res://scripts/Synth.gd")
const CityS := preload("res://scripts/City.gd")
const HackS := preload("res://scripts/Hack.gd")
const StealthS := preload("res://scripts/Stealth.gd")
const MeleeS := preload("res://scripts/Melee.gd")
const EncountersS := preload("res://scripts/Encounters.gd")
const NightS := preload("res://scripts/Night.gd")

const LEVELS := {
	"Dufredy": preload("res://scripts/levels/Dufredy.gd"),
	"Drive": preload("res://scripts/levels/Drive.gd"),
	"Park": preload("res://scripts/levels/Park.gd"),
	"Spine": preload("res://scripts/levels/Spine.gd"),
	"Home": preload("res://scripts/levels/Home.gd"),
	"WarRoom": preload("res://scripts/levels/WarRoom.gd"),
	"Hospital": preload("res://scripts/levels/Hospital.gd"),
	"Southtown": preload("res://scripts/levels/Southtown.gd"),
	"LynxFlat": preload("res://scripts/levels/LynxFlat.gd"),
	"Flats": preload("res://scripts/levels/Flats.gd"),
	"Mirror": preload("res://scripts/levels/Mirror.gd"),
	"Lineup": preload("res://scripts/levels/Lineup.gd"),
	"PropKit": preload("res://scripts/levels/PropKit.gd"),
	"Facility": preload("res://scripts/levels/Facility.gd"),
	"Hangar": preload("res://scripts/levels/Hangar.gd"),
	"Blackout": preload("res://scripts/levels/Blackout.gd"),
	"Observatory": preload("res://scripts/levels/Observatory.gd"),
	"HoldingCell": preload("res://scripts/levels/HoldingCell.gd"),
	"RedRock": preload("res://scripts/levels/RedRock.gd"),
	"Spa": preload("res://scripts/levels/Spa.gd"),
	"Cognizo": preload("res://scripts/levels/Cognizo.gd"),
	"Tunnels": preload("res://scripts/levels/Tunnels.gd"),
	"BronzeHands": preload("res://scripts/levels/BronzeHands.gd"),
	"Interlude": preload("res://scripts/levels/Interlude.gd"),
	"River": preload("res://scripts/levels/River.gd"),
	"Core": preload("res://scripts/levels/Core.gd"),
	"Chair": preload("res://scripts/levels/Chair.gd"),
	"Epilogue": preload("res://scripts/levels/Epilogue.gd"),
	# the open city: a district street (City.district picks which)
	"Street": preload("res://scripts/levels/Street.gd"),
	# deregistered: an encampment for a home (Standing.gd)
	"Encampment": preload("res://scripts/levels/Encampment.gd"),
	# a side case: Forner's flat in Lamplight (SideCases.gd)
	"FornerFlat": preload("res://scripts/levels/FornerFlat.gd"),
	# the hack / stealth / melee test room (--hacks=1); not in the story
	"HackTest": preload("res://scripts/levels/HackTest.gd"),
}

## Story order of the levels (the title menu and the self-test walk it).
const STORY := ["Dufredy", "Drive", "Park", "Spine", "Home", "WarRoom", "Hospital", "Southtown",
	"Home", "WarRoom", "LynxFlat", "Flats", "Mirror",
	"Facility", "Hangar", "Home", "Blackout", "Observatory", "HoldingCell", "RedRock", "Spa", "Cognizo", "Home",
	"Tunnels", "BronzeHands", "Interlude", "River", "Core", "Chair", "Epilogue"]

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

var level: Node3D
var level_name := ""
var player: CharacterBody3D
var ui: CanvasLayer
var retro: CanvasLayer
var crowd: Node3D
var env: Environment
var sun: DirectionalLight3D

var connection := 0.0
var frames_on := false
var flags := {}
# The bible's state (design/bible-1-systems-and-ui.md, "Meters and state").
# Standing is shown to the player as 100 - pressure. Trust runs -3..3.
var pressure := 20.0
var trust := {"turan": 0, "lynx": 0, "emmet": 0, "monica": 0, "mira": 0, "tyson": 0,
	"agata": 0, "nurse": 0, "officer": 0}
var stance_points := {"company_man": 0, "investigator": 0, "sleeper": 0}
var lexicon: Array = []  # words known, in the order learned
var first_typed := ""  # the first thing the player ever typed to Psyon
var ledger: Array = []  # [{level, kind, text}], the log the fork reads
var traded: Array = []       # memories paid for words: "drawing", "photo", "lion", "trophy"
var given: Array = []        # people given to the god by sacrifice (names, e.g. "tyson")
var tower_rooms: Array = []  # Carl's Tower rooms in build order: "focus", "calm", "memory", "courage"
# The clock and the open city (City.gd runs them). Hours past 23 belong to the
# same day until Carl sleeps; the Day card starts the next at 07:00.
var day := 1
var hour := 21
var faith := {}              # district id -> 0..3
var devotion := 0            # spent at Carl's Tower
var hacks: Array = []        # quick-hack words held: hush, look away, then the traded ones
var incidents := {}          # id -> {state, district, title, opened, ...}
var city: Node
# the hacking, stealth and melee systems (Hack.gd, Stealth.gd, Melee.gd)
var hack: Node
var stealth: Node
var melee: Node
## The recorder (R): hacking company property while it runs costs Standing.
var recording := true
var glyphs_found := 0
var outage := false
var started := false
var loading := false
var shot_mode := false
var sfx := {}
var amb := {}
var _sfx_pool: Array = []
var _scan_labels: Array = []
var _target: Object = null
var _phone_on := false
var _rain: CPUParticles3D
var _args := {}
var _selftest := false
## The desktop build runs Forward+ (bounced light, volumetric fog, SSR,
## SSAO); the browser falls back to Compatibility and skips all of it.
var hifi := false


func _ready() -> void:
	_setup_input()
	_args = _read_args()
	_make_sounds()
	_setup_env()
	player = PlayerS.new()
	add_child(player)
	player.locked = true
	player.stepped.connect(_on_step)
	_make_rain()
	ui = UIS.new()
	add_child(ui)
	ui.setup(self)
	retro = preload("res://scripts/Retro.gd").new()
	add_child(retro)
	retro.apply(_args)
	city = CityS.new()
	add_child(city)
	city.setup(self)
	stealth = StealthS.new()
	add_child(stealth)
	stealth.setup(self)
	melee = MeleeS.new()
	add_child(melee)
	melee.setup(self)
	hack = HackS.new()
	add_child(hack)
	hack.setup(self)
	if _args.has("shot") or _args.has("selftest") or _args.has("level") or _args.has("systems") or _args.has("hacks") or _args.has("night") or _args.has("cases"):
		_dev_start.call_deferred()


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
	_key("menu", [KEY_M])
	_key("map", [KEY_TAB])
	_key("release", [KEY_ESCAPE])
	_key("hack", [KEY_Q])
	_key("crouch", [KEY_C, KEY_CTRL])
	_key("attack", [KEY_V])
	_key("recorder", [KEY_R])


func _setup_env() -> void:
	hifi = RenderingServer.get_rendering_device() != null
	if hifi:
		get_viewport().msaa_3d = Viewport.MSAA_4X
		get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
		get_viewport().use_debanding = true
	env = Environment.new()
	var we := WorldEnvironment.new()
	we.environment = env
	add_child(we)
	sun = DirectionalLight3D.new()
	add_child(sun)
	_reset_env()


## Night on the Spine is the default; day levels override in setup_env.
func _reset_env() -> void:
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
	env.fog_density = 0.0036
	env.fog_sky_affect = 0.35
	sun.light_color = Color(0.55, 0.6, 0.8)
	sun.light_energy = 0.18
	sun.shadow_enabled = true
	sun.sky_mode = DirectionalLight3D.SKY_MODE_LIGHT_ONLY
	sun.rotation = Vector3(deg_to_rad(-48), deg_to_rad(35), 0)


func _make_rain() -> void:
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
	_rain = p


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
	sfx["flies"] = Synth.flies()
	sfx["snap"] = Synth.snap()
	sfx["tap"] = Synth.tap()
	sfx["ding"] = Synth.ding()
	sfx["keys"] = Synth.keys()
	sfx["slam"] = Synth.slam()
	sfx["siren"] = Synth.siren()
	sfx["engine"] = Synth.engine()
	sfx["wind"] = Synth.wind()
	sfx["murmur"] = Synth.murmur()
	sfx["jingle"] = Synth.jingle()
	sfx["static"] = Synth.static_hiss()
	sfx["vacuum"] = Synth.vacuum()
	sfx["pressure"] = Synth.pressure()
	sfx["shutter"] = Synth.shutter()
	sfx["door"] = Synth.door()
	sfx["room"] = Synth.room()
	for i in 8:
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


## A looping sound for the current level, flat or placed in the world.
func loop(key: String, db: float, at = null, unit := 4.0, max_d := 40.0, parent: Node = null) -> Node:
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
	(parent if parent else level).add_child(ap)
	var name_k := key
	var n := 2
	while amb.has(name_k):
		name_k = "%s%d" % [key, n]
		n += 1
	amb[name_k] = ap
	return ap


# ------------------------------------------------------------------ levels

## From the title menu: 0 = chapters 1 and 2, 1 = the Spine.
func pick(i: int) -> void:
	ui.show_title(false)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	started = true
	_reset_story()
	if i == 1 or i == 2:
		# Act 2 on its own: what Act 1 leaves behind
		for f in ["home1_done", "home2_done", "warroom1_done", "act1_done", "southtown_done", "ritual_seen", "mirror_done"]:
			flags[f] = true
		connection = 30.0
		for w in ["dreamer", "convene"]:
			if not lexicon.has(w):
				lexicon.append(w)
	if i == 2:
		# Act 3 on its own: a middle path through Act 2
		for f in ["facility_done", "hangar_done", "home3_done", "blackout_done", "observatory_done", "watched_observatory",
				"freudbot_1", "pip_active", "lushons_done", "forner_called", "spa_done", "broadcast_seen", "drone_ally",
				"ev_drive", "ev_knife", "ev_flashlight", "monica_choice_done", "home4_done"]:
			flags[f] = true
		connection = 60.0
		pressure = 40.0
		for w in ["hush", "look away", "sleeper", "we", "mimic", "bow"]:
			if not lexicon.has(w):
				lexicon.append(w)
		# the quick-hack words that middle path bought (hush and look away free)
		for w in ["hush", "look away", "sleeper", "we"]:
			if not hacks.has(w):
				hacks.append(w)
	load_level(["Dufredy", "Facility", "Tunnels", "Spine"][i])


func _reset_story() -> void:
	connection = 0.0
	frames_on = false
	flags = {}
	glyphs_found = 0
	outage = false
	pressure = 20.0
	for k in trust:
		trust[k] = 0
	for k in stance_points:
		stance_points[k] = 0
	lexicon = []
	ledger = []
	first_typed = ""
	traded = []
	given = []
	tower_rooms = []
	city.reset()
	ui.set_frames(0.0, 0.0)


func _apply_hifi() -> void:
	env.tonemap_mode = Environment.TONE_MAPPER_ACES
	env.tonemap_exposure *= 1.25
	env.sdfgi_energy = 1.3
	env.ssao_enabled = true
	env.ssao_radius = 1.4
	env.ssao_intensity = 2.2
	env.ssil_enabled = true
	env.ssil_intensity = 0.8
	env.ssr_enabled = true
	env.ssr_max_steps = 48
	env.sdfgi_enabled = true
	env.sdfgi_use_occlusion = true
	env.sdfgi_cascades = 4
	env.sdfgi_min_cell_size = 0.15
	env.volumetric_fog_enabled = true
	env.volumetric_fog_density = env.fog_density * 2.2
	env.volumetric_fog_albedo = env.fog_light_color
	env.volumetric_fog_length = 140.0
	env.volumetric_fog_anisotropy = 0.55
	env.volumetric_fog_ambient_inject = 0.35
	env.volumetric_fog_sky_affect = 0.4
	env.fog_density *= 0.45
	sun.shadow_blur = 1.4
	sun.directional_shadow_mode = DirectionalLight3D.SHADOW_PARALLEL_4_SPLITS
	sun.light_volumetric_fog_energy = 1.4
	level.hifi(env, sun)


func load_level(lname: String) -> void:
	if loading:
		return
	# the open city: a hand-off to a beat it opens goes to the city instead,
	# and every story level sits at its day and hour (City.before_load)
	lname = city.before_load(lname)
	loading = true
	player.locked = true
	if level and not shot_mode:
		await ui.fade_to(1.0, 0.8)
	ui.close()
	ui.laptop_open(false)
	ui.hide_picture()
	if _phone_on:
		toggle_phone()
	for l in _scan_labels:
		if is_instance_valid(l):
			l.queue_free()
	_scan_labels.clear()
	amb.clear()
	crowd = null
	stealth.clear()
	if level:
		remove_child(level)
		level.queue_free()
	_reset_env()
	level = LEVELS[lname].new()
	level_name = lname
	add_child(level)
	level.build(self)
	var merged: int = level.late_batch()
	if merged > 0:
		print("late_batch ", lname, ": ", merged, " meshes merged")
	stealth.on_level(level)
	melee.on_level(level)
	hack.on_level(level)
	player.sneak = false
	level.setup_env(env, sun)
	retro.tune(level.kit_day)
	if hifi:
		_apply_hifi()
	_rain.visible = level.rain
	_rain.emitting = level.rain
	player.seated = false
	player.velocity = Vector3.ZERO
	player.position = level.spawn
	player.yaw = deg_to_rad(level.spawn_yaw)
	player.pitch = 0.0
	player.rotation.y = player.yaw
	level.set_glyph_visibility(frames_on, connection)
	level.ambience()
	for k in amb:
		amb[k].play()
	update_hud()
	if shot_mode:
		ui.fade.color.a = 0.0
		loading = false
		return
	if level.card != "":
		await ui.show_card(level.card)
	else:
		await ui.fade_to(0.0, 0.8)
	loading = false
	level.intro()


# ------------------------------------------------------------------ input and the frame loop

func _unhandled_input(e: InputEvent) -> void:
	if not started:
		return
	if e.is_action_pressed("menu") and not ui.title.visible:
		ui.show_title(true)
		return
	if e.is_action_pressed("map") and not ui.title.visible and not ui.busy and not loading and level:
		city.open_map()
		return
	if e.is_action_pressed("release"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		return
	if e is InputEventMouseButton and e.pressed and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		return
	if ui.busy or player.locked or loading:
		return
	if e.is_action_pressed("interact") and _target:
		interact(_target)
	elif e.is_action_pressed("frames"):
		toggle_frames()
	elif e.is_action_pressed("scan"):
		scan()
	elif e.is_action_pressed("psyon"):
		toggle_phone()
	elif e.is_action_pressed("crouch"):
		player.sneak = not player.sneak
	elif e.is_action_pressed("recorder"):
		hack.toggle_recorder()
	elif e.is_action_pressed("attack") or (e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT):
		melee.strike()


func _process(_d: float) -> void:
	if not started or not level:
		return
	player.locked = ui.busy or flags.has("cinematic") or loading or ui.title.visible
	if player.global_position.y < -4.0:
		player.global_position = Vector3(player.global_position.x, 0.5, player.global_position.z)
		player.velocity = Vector3.ZERO
	if _args.has("debug") and Engine.get_process_frames() % 10 == 0:
		print("pos ", player.global_position, " fps ", Engine.get_frames_per_second())
	_target = null if (ui.busy or player.seated) else player.looked_at()
	if _target and is_instance_valid(_target):
		ui.prompt.text = "E   " + str(_target.get_meta("prompt"))
	else:
		ui.prompt.text = ""
	ui.crosshair.color.a = 0.9 if _target else 0.4


func toggle_frames() -> void:
	frames_on = not frames_on
	play("on" if frames_on else "off", -6.0)
	ui.set_frames(1.0 if frames_on else 0.0, connection)
	level.set_glyph_visibility(frames_on, connection)
	if frames_on:
		ui.glitch(0.4, 0.4)
	update_hud()


func add_connection(v: float, why: String) -> void:
	var old := connection
	# Carl's Tower, Calm: in the open city the frames take one less of him (never under 1)
	if v > 1.0 and tower_rooms.has("calm") and city.in_hub():
		v -= 1.0
	connection = minf(100.0, connection + v)
	ui.show_toast("Connection +%d   %s" % [int(v), why], 2.5)
	ui.set_frames(1.0 if frames_on else 0.0, connection)
	level.set_glyph_visibility(frames_on, connection)
	update_hud()
	level.on_connection(old, connection)


## The bible's effect shorthand: W:word, T:name, P, S:stance. Each is one
## call from a level; the toasts are the player's only feedback for now.
func learn(word: String) -> void:
	if word in lexicon:
		return
	lexicon.append(word)
	# hush and look away come free (bible-3 "Trades"); the rest are bought at a terminal
	if word in ["hush", "look away"] and not hacks.has(word):
		hacks.append(word)
	ui.show_toast("Word learned: %s" % word, 3.0)
	log_line("word", word)


func add_trust(who: String, d: int) -> void:
	trust[who] = clampi(int(trust.get(who, 0)) + d, -3, 3)
	log_line("trust", "%s %+d" % [who, d])


func add_pressure(d: float, why := "") -> void:
	pressure = clampf(pressure + d, 0.0, 100.0)
	if d > 0.0:
		ui.show_toast("Standing -%d   %s" % [int(d), why], 2.5)
	elif d < 0.0:
		ui.show_toast("Standing +%d   %s" % [int(-d), why], 2.5)
	log_line("standing", "%+d %s" % [int(-d), why])


func add_stance(s: String) -> void:
	stance_points[s] = int(stance_points.get(s, 0)) + 1


## The leader among the three stance columns, or "undecided" (needs 2, no tie).
func stance() -> String:
	var best := "undecided"
	var top := 1
	var tie := false
	for k in stance_points:
		if stance_points[k] > top:
			best = k
			top = stance_points[k]
			tie = false
		elif stance_points[k] == top and top > 1:
			tie = true
	return "undecided" if tie else best


func log_line(kind: String, text: String) -> void:
	ledger.append({"level": level_name, "kind": kind, "text": text, "day": day, "hour": hour % 24})


func update_hud() -> void:
	if not level:
		return
	# past 50 the objective sometimes reads "gather, sleeper" (Night.objective_text)
	ui.objective.text = NightS.objective_text(self, level.objective())
	ui.clock.text = city.clock_text()
	ui.clock.visible = level_name != "Epilogue"
	if frames_on:
		ui.status.text = "FRAMES ON    CONNECTION %d" % int(connection)
		ui.status.add_theme_color_override("font_color", Color(1.0, 0.35, 0.3) if connection >= 25.0 else Color(0.5, 1.0, 0.9))
	else:
		ui.status.text = "frames off"
		ui.status.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6, 0.7))


func _on_step() -> void:
	play("step", (level.step_db if level else -16.0) - (8.0 if player.sneak else 0.0), randf_range(0.85, 1.15))


# ------------------------------------------------------------------ interactions

func interact(node: Object) -> void:
	if node.has_meta("glyph"):
		await _glyph(node)
		return
	if node.has_meta("encounter"):
		await EncountersS.interact(self, node)
		ui.close()
		update_hud()
		return
	var handled: bool = await level.interact(node)
	if not handled:
		await ui.think("Nothing I could make sense of.")
	ui.close()
	update_hud()


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
	devotion += 1  # an examined glyph is an offering (bible-1 "Devotion")
	play("glitch", -4.0)
	ui.glitch(0.9, 0.7)
	await ui.think(str(g.get_meta("desc")))
	var line: String = CHANT[(glyphs_found - 1) % CHANT.size()]
	await ui.say("", "[color=#6fe8d0]The rings resolved the way a word does when you stop trying to read it.[/color]\n\n[b]" + line + "[/b]")
	ui.close()
	add_connection(6.0 if g.get_meta("deep") else 5.0, "the rings")
	level.on_glyph(g)


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
	# Carl's Tower, Focus: the frames read further
	var reach := 39.0 if tower_rooms.has("focus") else 26.0
	for n in _all_with_meta(level, "scan"):
		var p: Vector3 = (n as Node3D).global_position
		if p.distance_to(me) < reach:
			# past 50, 30% of people's cards are Carl's (Night.scan_text)
			_card(p + Vector3(0, 1.5, 0), NightS.scan_text(self, str(n.get_meta("scan")), n.get_parent() != null and n.get_parent().has_meta("head")))
	for pair in level.scan_people():
		var n: Node3D = pair[0]
		if n.global_position.distance_to(me) < reach:
			_card(n.global_position + Vector3(0, 2.2, 0), NightS.scan_text(self, str(pair[1])))
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
	t += level.phone()
	t += "[color=#888888](P to put the phone away)[/color]"
	ui.phone_text.text = t


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


func _dev_start() -> void:
	shot_mode = _args.has("shot") or _args.has("selftest")
	started = true
	ui.show_title(false)
	if _args.has("conn"):
		connection = float(_args["conn"])
	if _args.has("flags"):
		for f in str(_args["flags"]).split(","):
			flags[f] = true
	if _args.has("frames"):
		frames_on = true
		ui.set_frames(1.0, connection)
	city.apply_args(_args)
	if _args.has("hackwords"):
		for w in HackS.ORDER:
			if not hacks.has(w):
				hacks.append(w)
	if _args.has("nocatch"):
		stealth.no_catch = true
	if _args.has("hacks"):
		await _hacks_test()
		return
	if _args.has("systems"):
		_selftest = true
		await city.selftest_systems()
		return
	if _args.has("cases"):
		# the open city's side cases, each to each ending (SideCases.gd)
		_selftest = true
		await city.cases.selftest()
		return
	if _args.has("night"):
		# the night layer and the confrontations (Night.gd)
		_selftest = true
		await NightS.selftest(self)
		return
	if _args.has("selftest"):
		_selftest_all()
		return
	city.apply_time_args(_args)
	await load_level(str(_args.get("level", "Spine")))
	city.apply_time_args(_args)
	if not shot_mode:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
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
	level.apply_args(_args)
	if _args.has("crouch"):
		player.crouch = float(_args["crouch"])
	if _args.has("sneak"):
		player.sneak = true
	level.set_glyph_visibility(frames_on, connection)
	update_hud()
	if shot_mode:
		player.locked = false
		_run_test()


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
	if _args.has("count"):
		var c := {"mesh": 0, "visible_mesh": 0, "multimesh": 0, "omni": 0, "spot": 0}
		for n in level.find_children("*", "VisualInstance3D", true, false):
			if n is MeshInstance3D:
				c["mesh"] += 1
				if n.is_visible_in_tree():
					c["visible_mesh"] += 1
			elif n is MultiMeshInstance3D:
				c["multimesh"] += 1
			elif n is OmniLight3D and n.is_visible_in_tree():
				c["omni"] += 1
			elif n is SpotLight3D and n.is_visible_in_tree():
				c["spot"] += 1
		print("COUNT ", level_name, " ", c)
		if _args.has("countdetail"):
			var by := {}
			for n in level.find_children("*", "MeshInstance3D", true, false):
				if not n.is_visible_in_tree():
					continue
				var k := "%s|%s|ovr=%s|depth=%d" % [n.get_parent().name if n.get_parent() != level else "<level>", n.mesh.get_class() if n.mesh else "none", n.material_override != null, str(n.get_path()).count("/")]
				by[k] = by.get(k, 0) + 1
			var ks := by.keys()
			ks.sort_custom(func(a, b): return by[a] > by[b])
			for k in ks.slice(0, 25):
				print("  ", by[k], "  ", k)
	city.shot_args(_args)
	if _args.has("wheel"):
		hack._find_target()
		hack.try_open()
		if _args.has("wheelsel"):
			hack.sel = int(_args["wheelsel"])
		for i in 4:
			await get_tree().process_frame
	if _args.has("map") or _args.has("daycard") or _args.has("terminal"):
		for i in 20:
			await get_tree().process_frame
	if _args.has("shot"):
		var img := get_viewport().get_texture().get_image()
		img.save_png(str(_args["shot"]))
		print("SHOT ", _args["shot"])
	get_tree().quit()


## Plays every level headless with dialogue auto-advancing: each level's
## own scripted run (or every interactable twice, so the second pass gets
## past story gates), so a run catches script errors end to end.
func _selftest_all() -> void:
	_selftest = true
	Engine.time_scale = 4.0
	var pump := func():
		while _selftest:
			await get_tree().process_frame
			ui.advanced.emit()
			ui.picked.emit(1)
	pump.call()
	var only := str(_args.get("level", ""))
	var from := str(_args.get("from", ""))
	for lname in STORY:
		if only != "" and only != lname:
			continue
		if from != "":
			if from != lname:
				continue
			from = ""
		if lname == "Home" and flags.has("home1_done"):
			flags["southtown_done"] = true
		if lname == "WarRoom" and flags.has("warroom1_done"):
			flags["ritual_seen"] = true
		if lname == "Home" and flags.has("home2_done"):
			flags["act1_done"] = true
			flags["hangar_done"] = true
		if lname == "Home" and flags.has("home3_done"):
			flags["broadcast_seen"] = true
		await load_level(lname)
		print("LEVEL ", lname)
		if lname == "Spine":
			frames_on = true
			connection = 30.0
			flags["outage_done"] = true
			level.set_glyph_visibility(true, connection)
		await level.selftest()
		if lname == "Spine":
			scan()
			toggle_phone()
			toggle_phone()
			connection = 20.0
			flags.erase("outage_done")
			add_connection(6.0, "test")
			await get_tree().create_timer(16.0).timeout
			add_connection(30.0, "test")
			await get_tree().create_timer(6.0).timeout
			player.position = Vector3(0, 0.2, -200)
			await get_tree().create_timer(2.0).timeout
	print("SELFTEST DONE glyphs=", glyphs_found, " conn=", connection, " pressure=", pressure, " trust=", trust, " stance=", stance_points, " words=", lexicon, " flags=", flags.keys())
	_selftest = false
	get_tree().quit()


## The hack, stealth and melee test (--hacks=1): the test room exercises
## every word on every kind of target, a guard spotting and resetting Carl,
## crouching, walls, the eyeless refusing, the strike and the overwhelm; then
## two district streets are checked for their encounters.
func _hacks_test() -> void:
	_selftest = true
	shot_mode = true
	stealth.test_mode = true
	Engine.time_scale = 4.0
	var pump := func():
		while _selftest:
			await get_tree().process_frame
			ui.advanced.emit()
			ui.picked.emit(1)
	pump.call()
	await load_level("HackTest")
	var fails: int = await level.hack_test()
	fails += await LEVELS["HackTest"].street_test(self)
	print("HACKS DONE fails=", fails, " conn=", connection, " pressure=", pressure, " catches=", stealth.catches)
	_selftest = false
	get_tree().quit()


## Every interactable in the level, twice (the second pass gets past gates).
func selftest_all_interactables() -> void:
	for pass_i in 2:
		for n in _all_with_meta(level, "id"):
			if is_instance_valid(n) and not n.has_meta("exit"):
				await interact(n)
				print("ok ", n.get_meta("id"))
