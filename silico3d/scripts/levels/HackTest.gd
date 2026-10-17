extends "res://scripts/Level.gd"
## A bare test room for the hack, stealth and melee systems (Main --hacks=1;
## also --level=HackTest for screenshots). Not in the story. Along the line
## z = -2, one of each kind of target: a civic speaker, a screen, a badge
## reader with its door, a door that says not yet, a camera, a drone, and
## one of the eyeless. Behind them a guard at his post, a robed watcher
## behind a wall, two addicts by the east wall, and two devices a level
## would script: one the level's on_hack takes, one that takes only hush.

const Enc := preload("res://scripts/Encounters.gd")
const HackS := preload("res://scripts/Hack.gd")

const LINES := {
	"objective": "Test room: Q on anything bracketed. C to crouch, V to strike.",
	"scripted": "The panel did what the level told it to.",
	"prompts": {"terminal": "The screen", "reader": "The badge reader", "eyeless": "The eyeless", "panel": "The scripted panel", "picky": "The picky box"},
}

var t := {}            # kind -> [subject, body]
var guard: Node3D
var robe: Node3D
var addict_a: Node3D
var addict_b: Node3D
var eyeless: Node3D
var _fails := 0


func build(m: Node) -> void:
	main = m
	kit_day = false
	spawn = Vector3(0, 0.1, 8.0)
	spawn_yaw = 0.0
	var conc := pbr("concrete", Vector3(1, 1, 1) / 3.0, true, Color(0.55, 0.55, 0.58))
	solid_box(Vector3(40, 2, 50), Vector3(0, -1.0, -6.0))
	floor_quad(Vector2(32, 42), Vector3(0, 0.0, -6.0), 0.0, conc)
	var wall := mat(Color(0.2, 0.2, 0.22), 0.8)
	box(Vector3(32, 6, 0.4), Vector3(0, 3, -27.0), wall, true)
	box(Vector3(32, 6, 0.4), Vector3(0, 3, 15.0), wall, true)
	box(Vector3(0.4, 6, 42), Vector3(-16.0, 3, -6.0), wall, true)
	box(Vector3(0.4, 6, 42), Vector3(16.0, 3, -6.0), wall, true)
	for p: Vector3 in [Vector3(0, 5.0, 4.0), Vector3(-8, 5.0, -4.0), Vector3(8, 5.0, -4.0), Vector3(0, 5.0, -15.0), Vector3(-10, 5.0, -15.0), Vector3(12, 5.0, -9.0)]:
		light(p, Color(1.0, 0.85, 0.65), 1.6, 14.0)
	box(Vector3(30, 0.02, 0.1), Vector3(0, 0.01, -2.6), glow(Color(0.25, 0.88, 0.54), 1.0))
	# the row of targets
	var sp := Enc.speaker(self, Vector3(-9.0, 2.2, -2.0), PI, "test_speaker")
	cyl(0.05, 0.05, 2.0, Vector3(-9.0, 1.0, -2.0), mat(Color(0.12, 0.12, 0.13), 0.5, 0.7), 6)
	t["speaker"] = [_body(sp), _body(sp)]
	box(Vector3(0.9, 0.6, 0.08), Vector3(-6.0, 1.3, -2.0), mat(Color(0.05, 0.05, 0.06), 0.3))
	box(Vector3(0.8, 0.5, 0.02), Vector3(-6.0, 1.3, -1.95), glow(Color(0.4, 0.9, 1.0), 1.4))
	var tm := interactable("test_terminal", LINES["prompts"]["terminal"], Vector3(-6.0, 1.3, -1.9), Vector3(0.9, 0.6, 0.2), "FREUDBOT DISPLAY 9\nfirmware: 2031", false)
	tm.set_meta("hackable", true)
	tm.set_meta("hack_kind", "terminal")
	t["terminal"] = [tm, tm]
	var rd_door: Array = Enc.door(self, Vector3(-2.6, 0, -2.1), 0.0, 1.1, "reader_door")
	(rd_door[1] as Node).set_meta("hackable", false)
	box(Vector3(0.14, 0.22, 0.06), Vector3(-3.1, 1.3, -1.98), mat(Color(0.85, 0.86, 0.88), 0.3))
	var rd := interactable("test_reader", LINES["prompts"]["reader"], Vector3(-3.1, 1.3, -1.9), Vector3(0.3, 0.35, 0.2), "BADGE READER\naccepts: COMPANY BADGE", false)
	rd.set_meta("hackable", true)
	rd.set_meta("hack_kind", "reader")
	rd.set_meta("door_node", rd_door[0])
	t["reader"] = [rd, rd]
	var dr: Array = Enc.door(self, Vector3(-0.4, 0, -2.1), 0.0, 1.1, "test_door")
	t["door"] = [dr[1], dr[1]]
	var cam := Enc.camera(self, Vector3(3.0, 3.2, -2.0), PI, {"zone": AABB(Vector3(1.5, -1, 1.5), Vector3(3, 4, 3)), "sweep": 0.5, "safe": Vector3(0, 0.1, 10.0)}, true, "test_camera")
	t["camera"] = [cam, _body(cam)]
	var dn := Enc.drone(self, Vector3(6.0, 3.0, -2.0), {"passive": true}, "test_drone")
	t["drone"] = [dn, _body(dn)]
	eyeless = figure(Color(0.12, 0.12, 0.13), Color(0.7, 0.66, 0.62), {"arms": true, "knees": true, "hair": Color(0.05, 0.05, 0.05)})
	eyeless.position = Vector3(9.0, 0.0, -2.0)
	eyeless.rotation.y = PI
	add_child(eyeless)
	var hd: Node3D = eyeless.get_meta("head")
	for s: float in [-1.0, 1.0]:
		sphere(0.03, Vector3(s * 0.04, 0.03, -0.1), mat(Color(0.02, 0.0, 0.0)), 6, hd)
	eyeless.set_meta("eyeless", true)
	var eb := person("test_eyeless", LINES["prompts"]["eyeless"], eyeless, "SUBJECT 0\nFRAMES SIGNAL: TRACKING")
	t["eyeless"] = [eyeless, eb]
	# the scripted beats: one the level takes, one that only takes hush
	box(Vector3(0.6, 0.8, 0.3), Vector3(-12.0, 1.2, -2.0), mat(Color(0.3, 0.3, 0.32), 0.5, 0.5))
	var pn := interactable("scripted_panel", LINES["prompts"]["panel"], Vector3(-12.0, 1.2, -1.8), Vector3(0.7, 0.9, 0.3), "TEST PANEL\non_hack: LEVEL", false)
	pn.set_meta("hackable", true)
	t["scripted"] = [pn, pn]
	box(Vector3(0.6, 0.6, 0.6), Vector3(-14.0, 0.3, -2.0), mat(Color(0.5, 0.42, 0.3), 0.8))
	var pk := interactable("picky_box", LINES["prompts"]["picky"], Vector3(-14.0, 0.3, -2.0), Vector3(0.7, 0.7, 0.7), "PICKY BOX\nhack_words: HUSH", false)
	pk.set_meta("hackable", true)
	pk.set_meta("hack_words", ["hush"])
	t["picky"] = [pk, pk]
	# the people
	guard = Enc.guard(self, Vector3(0.0, 0.0, -16.0), PI, {"fov": 120.0, "unless": "test_quiet", "safe": Vector3(0, 0.1, 10.0)}, "test_guard")
	t["guard"] = [guard, _body(guard)]
	robe = Enc.cultist(self, Vector3(-9.0, 0.0, -14.0), PI, {"unless": "test_quiet", "safe": Vector3(-3.0, 0.1, 10.0)}, "test_robe")
	t["cultist"] = [robe, _body(robe)]
	box(Vector3(2.0, 3.0, 0.3), Vector3(-9.0, 1.5, -10.0), wall, true)
	addict_a = Enc.addict(self, Vector3(12.0, 0.0, -6.0), PI, {"aggro": "never"}, "test_addict")
	t["addict"] = [addict_a, _body(addict_a)]
	addict_b = Enc.addict(self, Vector3(13.0, 0.0, -13.0), PI, {"aggro": "never"}, "test_addict2")


func _body(n: Node) -> Node:
	for c in n.get_children():
		if c is CollisionObject3D and c.has_meta("id"):
			return c
	return n


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	env.ambient_light_energy = 0.25
	env.fog_density = 0.002
	sun.light_energy = 0.0


func objective() -> String:
	return LINES["objective"]


## A level's own say over a word (the hook Hack.gd calls first).
func on_hack(node: Object, word: String) -> bool:
	if str(node.get_meta("id", "")) == "scripted_panel":
		main.flags["test_on_hack"] = word
		main.hack.charge(node, word)
		main.hack.say_line(LINES["scripted"])
		return true
	return false


## Screenshots: --face=speaker|camera|guard|eyeless... turns Carl to it.
func apply_args(a: Dictionary) -> void:
	if a.has("face") and t.has(str(a["face"])):
		var n: Node3D = t[str(a["face"])][1]
		var p := n.global_position
		main.player.yaw = atan2(-(p.x - main.player.position.x), -(p.z - main.player.position.z))
		var d: Vector3 = p - (main.player.position + Vector3(0, 1.66, 0))
		main.player.pitch = atan2(d.y, Vector2(d.x, d.z).length())


# ------------------------------------------------------------------ the test

func _ok(name: String, cond: bool, info := "") -> void:
	print("HACKS %s %s %s" % ["ok  " if cond else "FAIL", name, info])
	if not cond:
		_fails += 1


func _until(cond: Callable, secs: float) -> bool:
	var e := 0.0
	while not cond.call():
		await get_tree().process_frame
		e += get_process_delta_time()
		if e > secs:
			return false
	return true


func _wait(secs: float) -> void:
	await get_tree().create_timer(secs).timeout


func _put(p: Vector3, look: Vector3) -> void:
	var pl = main.player
	pl.global_position = p
	pl.velocity = Vector3.ZERO
	var d := look - (p + Vector3(0, 1.66, 0))
	pl.yaw = atan2(-d.x, -d.z)
	pl.pitch = atan2(d.y, Vector2(d.x, d.z).length())
	pl.rotation.y = pl.yaw
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().process_frame


func _reset_watchers() -> void:
	var st = main.stealth
	for w: Dictionary in st.watchers:
		var n: Node3D = w["node"]
		if w["managed"] and w["kind"] in ["guard", "cultist"]:
			n.global_position = w["post"]
			n.rotation.y = float(w["post_yaw"])
		w["sus"] = 0.0
		w["inv_until"] = 0.0
		w["seen_t"] = -10.0
		w["state"] = "patrol"
	main.hack.states.clear()


func hack_test() -> int:
	_fails = 0
	var h = main.hack
	var st = main.stealth
	var mel = main.melee
	main.frames_on = true
	main.ui.set_frames(1.0, 30.0)
	main.connection = 30.0
	main.flags["test_quiet"] = true
	main.hacks = HackS.ORDER.duplicate()
	_ok("watchers registered", st.watchers.size() >= 4, "n=%d" % st.watchers.size())
	_ok("addicts registered", mel.addicts.size() == 2, "n=%d" % mel.addicts.size())
	# --- the crosshair finds the speaker, the wheel opens, hush fires
	await _put(Vector3(-9.0, 0.1, 3.0), Vector3(-9.0, 2.2, -2.0))
	h._find_target()
	_ok("target: speaker under the crosshair", h.target == t["speaker"][0], "kind=%s" % h.target_kind)
	main.connection = 20.0
	_ok("wheel locked under 25", not h.try_open() and not h.wheel_open)
	main.connection = 30.0
	_ok("wheel opens", h.try_open() and h.wheel_open, "words=%s" % [h.wheel_words])
	_ok("time crawls on the wheel", Engine.time_scale < 2.0, "scale=%.2f" % Engine.time_scale)
	h.pick(0)
	_ok("time back after the wheel", Engine.time_scale > 3.0)
	await _until(func(): return not h.busy and str(h.last.get("word", "")) == "hush", 3.0)
	_ok("hush from the wheel mutes the speaker", h.has_state(t["speaker"][0], "hushed"))
	# --- every word on every kind
	var kinds := ["speaker", "camera", "guard", "cultist", "drone", "door", "reader", "terminal", "addict"]
	var matrix_fails := 0
	h.backtalk = false
	for word: String in HackS.ORDER:
		var row := []
		for k: String in kinds:
			h.states.clear()
			main.connection = 65.0 if word == "mimic" else 30.0
			main.pressure = 20.0
			var c0: float = main.connection
			var s: Node = t[k][0]
			await h.fire(s, word, t[k][1])
			var good: bool = _effect(word, k, s)
			var cost_ok: bool = absf(main.connection - c0 - float(HackS.WORDS[word][0])) < 0.01
			var company: bool = h.is_company(s, h.kind_of(s, t[k][1]))
			var st_ok: bool = (main.pressure > 22.9) == company
			if not (good and cost_ok and st_ok):
				matrix_fails += 1
				print("HACKS FAIL  %s on %s: effect=%s cost=%s standing=%s line=%s" % [word, k, good, cost_ok, st_ok, h.last.get("line", "")])
			row.append("%s%s" % [k, "+" if h.works(word, k) else "-"])
		print("HACKS row %s: %s" % [word, " ".join(row)])
	_ok("every word on every kind (%d hacks)" % (HackS.ORDER.size() * kinds.size()), matrix_fails == 0, "fails=%d" % matrix_fails)
	_fails += matrix_fails
	h.backtalk = true
	# --- the eyeless refuse
	h.states.clear()
	main.connection = 30.0
	await _put(Vector3(9.0, 0.1, 3.0), Vector3(9.0, 1.4, -2.0))
	h._find_target()
	_ok("eyeless bracketed red", h.target_kind == "eyeless")
	_ok("eyeless: no wheel", not h.try_open() and not h.wheel_open)
	await h.fire(eyeless, "sleeper", t["eyeless"][1])
	_ok("eyeless: refused, nothing spent", str(h.last.get("kind", "")) == "eyeless" and main.connection == 30.0 and not h.has_state(eyeless, "asleep"))
	# --- the level keeps control
	main.flags.erase("test_on_hack")
	await h.fire(t["scripted"][0], "hush", t["scripted"][1])
	_ok("level on_hack takes the word", main.flags.get("test_on_hack", "") == "hush" and h.last.get("handled", false) and not h.has_state(t["scripted"][0], "hushed"))
	await h.fire(t["picky"][0], "sleeper", t["picky"][1])
	_ok("hack_words: other words refused", str(h.last.get("line", "")).contains("Not here") and not h.has_state(t["picky"][0], "asleep"))
	await h.fire(t["picky"][0], "hush", t["picky"][1])
	_ok("hack_words: its word works", h.has_state(t["picky"][0], "hushed"))
	# --- the recorder
	main.recording = false
	main.pressure = 20.0
	await h.fire(t["camera"][0], "look away", t["camera"][1])
	_ok("recorder off: company hack costs no Standing", main.pressure == 20.0)
	main.recording = true
	# --- Psyon hacks back
	main.connection = 80.0
	var diff := 0
	for i in 300:
		if h.hackback("hush") != "hush":
			diff += 1
	_ok("past 50 about one in ten fires another word", diff > 8 and diff < 60, "%d/300" % diff)
	var lies := 0
	for i in 30:
		h.open_wheel(h.held())
		for j in h.wheel_words.size():
			if h.wheel_labels[j] != h.wheel_words[j]:
				lies += 1
		h.close_wheel()
	_ok("past 75 the wheel lies sometimes", lies > 0 and lies < 30, "%d/30" % lies)
	main.connection = 30.0
	main.connection = 30.0
	# --- the guard sees Carl and walks him back
	main.flags.erase("test_quiet")
	_reset_watchers()
	var gw: Dictionary = st.watcher_of(guard)
	_ok("guard is a watcher", not gw.is_empty() and gw["managed"])
	main.player.sneak = false
	await _put(Vector3(0.0, 0.1, -11.0), Vector3(0.0, 1.6, -16.0))
	await _wait(0.4)
	_ok("guard's cone drawn with the frames on", (gw["cone"] as MeshInstance3D).visible)
	var s_close := float(gw["sus"])
	_ok("suspicion rises in the cone", s_close > 0.05, "sus=%.2f" % s_close)
	# crouching, same spot
	_reset_watchers()
	await _put(Vector3(0.0, 0.1, -11.0), Vector3(0.0, 1.6, -16.0))
	var c1 := await _sus_over(gw, 0.5, false)
	var c2 := await _sus_over(gw, 0.5, true)
	_ok("crouching is harder to see (5 m)", c2 < c1 * 0.8, "stand=%.2f crouch=%.2f" % [c1, c2])
	await _put(Vector3(0.0, 0.1, -7.5), Vector3(0.0, 1.6, -16.0))
	var f1 := await _sus_over(gw, 0.5, false)
	var f2 := await _sus_over(gw, 0.5, true)
	_ok("crouched past his range (8.5 m): unseen", f1 > 0.02 and f2 == 0.0, "stand=%.2f crouch=%.2f" % [f1, f2])
	main.player.sneak = false
	# noise: running behind him is heard, crouching is not
	var pv: Vector3 = main.player.velocity
	st._mask_until = 0.0
	h.states.clear()
	main.player.global_position = Vector3(0.0, 0.1, -19.0)
	main.player.velocity = Vector3(4.2, 0, 0)
	var loud: float = st._noise(gw, main.player.global_position)
	main.player.sneak = true
	main.player.velocity = Vector3(1.2, 0, 0)
	var quiet: float = st._noise(gw, main.player.global_position)
	main.player.sneak = false
	main.player.velocity = pv
	_ok("running is heard, crouching is not", loud > 0.0 and quiet == 0.0, "loud=%.2f quiet=%.2f" % [loud, quiet])
	# we: his frames read Carl as one of them
	_reset_watchers()
	h.set_state(guard, "we", 10.0)
	await _put(Vector3(0.0, 0.1, -12.0), Vector3(0.0, 1.6, -16.0))
	await _wait(0.6)
	_ok("we: seen but not suspected", float(gw["sus"]) == 0.0)
	h.states.clear()
	# caught
	_reset_watchers()
	var p0: float = main.pressure
	var k0: int = st.catches
	await _put(Vector3(0.0, 0.1, -10.0), Vector3(0.0, 1.6, -16.0))
	var got: bool = await _until(func(): return st.catches > k0 and not st.catching, 12.0)
	_ok("guard spots Carl: caught", got)
	_ok("caught by security: +5 pressure", absf(main.pressure - p0 - 5.0) < 0.01, "%.0f -> %.0f" % [p0, main.pressure])
	_ok("walked back to the safe point", main.player.global_position.distance_to(Vector3(0, 0.1, 10.0)) < 1.2, str(main.player.global_position))
	# walls: the robe can't see through the wall, then can
	var rw: Dictionary = st.watcher_of(robe)
	_reset_watchers()
	await _put(Vector3(-9.0, 0.1, -6.5), Vector3(-9.0, 1.6, -14.0))
	await _wait(0.6)
	_ok("behind the wall: unseen", float(rw["sus"]) == 0.0, "sus=%.2f" % float(rw["sus"]))
	var c0b: float = main.connection
	var k1: int = st.catches
	await _put(Vector3(-12.0, 0.1, -9.0), Vector3(-9.0, 1.6, -14.0))
	got = await _until(func(): return st.catches > k1 and not st.catching, 12.0)
	_ok("the robe sees past the wall: caught", got)
	_ok("caught by the cult: +5 Connection", main.connection >= c0b + 4.99, "%.0f -> %.0f" % [c0b, main.connection])
	# look away on the guard: Carl walks past
	_reset_watchers()
	await h.fire(guard, "look away", t["guard"][1])
	await _put(Vector3(0.0, 0.1, -12.0), Vector3(0.0, 1.6, -16.0))
	await _wait(0.8)
	_ok("look away: the guard turns his back", float(gw["sus"]) < 0.05, "sus=%.2f" % float(gw["sus"]))
	h.states.clear()
	main.flags["test_quiet"] = true
	# --- melee
	var aa: Dictionary = mel.addict_of(addict_a)
	await _put(Vector3(12.0, 0.1, -4.6), Vector3(12.0, 1.2, -6.0))
	var c_m: float = main.connection
	var t0: int = mel.touches
	var hits := 0
	for i in 3:
		await _put(addict_a.global_position + Vector3(0, 0.1, 1.3), addict_a.global_position + Vector3(0, 1.2, 0))
		if mel.strike():
			hits += 1
		await _wait(0.8)
	_ok("three strikes land", hits == 3, "hits=%d" % hits)
	_ok("he goes down", str(aa["state"]) == "down")
	_ok("takedown: +2 Connection", main.connection >= c_m + 1.99, "%.0f -> %.0f" % [c_m, main.connection])
	_ok("it costs Carl too (hit back)", mel.touches > t0, "touches=%d" % mel.touches)
	_ok("the eye where he fell", aa.has("eye") and is_instance_valid(aa["eye"]))
	await _put(Vector3(0.0, 0.1, 8.0), Vector3(0.0, 1.6, 0.0))
	_ok("nobody in reach: no strike", not mel.strike())
	# overwhelmed: the god saves Carl
	var ab: Dictionary = mel.addict_of(addict_b)
	var c_o: float = main.connection
	mel.touches = 2
	mel.hit_carl(ab)
	got = await _until(func(): return not mel._busy, 10.0)
	_ok("overwhelmed: saved, +10 Connection, a debt", got and main.connection >= c_o + 9.99 and main.ledger.any(func(l): return l["kind"] == "debt"))
	# talk him down
	ab["state"] = "idle"
	await main.interact(_body(addict_b))
	_ok("talked down (the cash)", str(ab["state"]) == "calm")
	# sleeper through an addict's phone
	ab["state"] = "idle"
	await h.fire(addict_b, "sleeper", _body(addict_b))
	_ok("sleeper sits an addict down", h.has_state(addict_b, "asleep"))
	main.flags.erase("test_quiet")
	return _fails


func _sus_over(w: Dictionary, secs: float, crouched: bool) -> float:
	main.player.sneak = crouched
	w["sus"] = 0.0
	w["seen_t"] = -10.0
	var n: Node3D = w["node"]
	n.global_position = w["post"]
	n.rotation.y = float(w["post_yaw"])
	var e := 0.0
	while e < secs:
		await get_tree().physics_frame
		e += get_physics_process_delta_time()
	var v := float(w["sus"])
	w["sus"] = 0.0
	return v


func _effect(word: String, k: String, s: Node) -> bool:
	var h = main.hack
	if not h.works(word, k):
		return str(h.last.get("line", "")).contains("nothing came back")
	match word:
		"hush":
			return h.has_state(s, "deaf") or h.has_state(s, "hushed")
		"look away":
			return h.has_state(s, "blind")
		"convene":
			return str(h.last.get("line", "")).begins_with("convene")
		"sleeper":
			return h.has_state(s, "asleep")
		"dreamer":
			return h.has_state(s, "opened")
		"we":
			return h.has_state(s, "we") or h.has_state(s, "spoofed")
		"mimic":
			return h.has_state(s, "calledoff") or h.has_state(s, "bow") or str(h.last.get("line", "")).begins_with("mimic")
	return false


## The open city's encounters, from Main (static: the room is gone by then).
static func street_test(main: Node) -> int:
	var fails := 0
	var st = main.stealth
	main.frames_on = true
	main.connection = 30.0
	main.city.district = "spine"
	main.hour = 22
	main.faith["spine"] = 0
	await main.load_level("Street")
	var g := {}
	for w: Dictionary in st.watchers:
		if w["kind"] == "guard" and not w["passive"]:
			g = w
	print("HACKS %s street: a guard on the tape at the Spine, 22:00" % ("ok  " if not g.is_empty() else "FAIL"))
	if g.is_empty():
		fails += 1
	var hk := 0
	for n in main._all_with_meta(main.level, "hackable"):
		hk += 1
	print("HACKS %s street: hackable devices (%d)" % ["ok  " if hk >= 4 else "FAIL", hk])
	if hk < 4:
		fails += 1
	if not g.is_empty():
		# trespass under the tape, in front of him
		var gn: Node3D = g["node"]
		var p0: float = main.pressure
		var k0: int = st.catches
		var f: Vector3 = Vector3(-sin(gn.global_rotation.y), 0, -cos(gn.global_rotation.y))
		var e := 0.0
		while (st.catches == k0 or st.catching) and e < 14.0:
			if not st.catching and not main.ui.busy:
				main.player.global_position = gn.global_position + f * 4.0 + Vector3(0, 0.1, 0)
				main.player.velocity = Vector3.ZERO
			await main.get_tree().process_frame
			e += main.get_process_delta_time()
		var ok: bool = st.catches > k0 and main.pressure >= p0 + 4.99 and main.player.global_position.distance_to(Vector3(3.0, 0.1, -46.0)) < 1.5
		print("HACKS %s street: caught under the tape, escorted out (%.0f -> %.0f)" % ["ok  " if ok else "FAIL", p0, main.pressure])
		if not ok:
			fails += 1
	main.city.district = "red_rock"
	main.hour = 23
	await main.load_level("Street")
	var n_add: int = main.melee.addicts.size()
	print("HACKS %s street: addicts in Red Rock at night (%d)" % ["ok  " if n_add >= 1 else "FAIL", n_add])
	if n_add < 1:
		fails += 1
	else:
		var a: Dictionary = main.melee.addicts[0]
		var an: Node3D = a["node"]
		main.player.global_position = an.global_position + Vector3(1.2, 0.1, 0)
		main.player.yaw = PI / 2.0
		main.player.pitch = 0.0
		main.frames_on = true
		var e2 := 0.0
		while str(a["state"]) != "approach" and e2 < 4.0:
			await main.get_tree().process_frame
			e2 += main.get_process_delta_time()
		print("HACKS %s street: frames on, the addict comes at Carl" % ("ok  " if str(a["state"]) == "approach" else "FAIL"))
		if str(a["state"]) != "approach":
			fails += 1
	return fails
