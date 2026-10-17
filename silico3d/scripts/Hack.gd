extends Node
## The quick-hack (bible-1 "Quick-hack wheel (Q)", "Quick-hack (Q)";
## combat.md "Three ways to hack", "Words are the abilities", "What it
## costs", "When Psyon hacks back"). Frames on and Connection 25 or more:
## whatever device or person under the crosshair the frames can reach is
## bracketed in Psyon green. Hold Q: time crawls and the wheel of held words
## (main.hacks) comes up round it, each with its cost. Move the mouse toward a
## word (or press its number) and release Q: about half a second later the
## word fires, with a glitch burst on the target.
##
## Costs: the word's Connection every time (hush and look away 1, convene,
## sleeper, dreamer and we 2, mimic 5 and only from 60), and +3 pressure when
## the target is company property and the recorder (R) is on.
## Psyon hacks back: from 50 one hack in ten fires a word Carl did not pick;
## from 75 one label on the wheel may be wrong. The eyeless and the pursuer
## cannot be hacked at all: the wheel will not come up on them.
##
## Levels keep control of their scripted beats two ways:
##   node.set_meta("hack_words", ["hush", ...])  only these words take here;
##   func on_hack(node, word) -> bool  in the level: called first with the
##     interactable (its "id" meta) and the word. Return true when the level
##     has played the effect and charged the cost itself (main.hack.charge()
##     does the standard charge); false lets the generic effect run.
## The generic effects are states on the target (has_state(node, "blind")),
## which Stealth.gd and Melee.gd read: hush = deaf / alarm dead / muted,
## look away = blind, sleeper = asleep, we = reads Carl as one of them,
## mimic = called off (guards) or bowing (cultists), dreamer / we open doors
## with a "door_node" meta, convene pulls the people Stealth and Melee drive.
##
## Every line here is (game): written for the game, not from the book; ian
## rewrites them.

const ORDER := ["hush", "look away", "convene", "sleeper", "dreamer", "we", "mimic"]
## word -> [Connection cost, Connection needed]
const WORDS := {"hush": [1, 0], "look away": [1, 0], "convene": [2, 0], "sleeper": [2, 0],
	"dreamer": [2, 0], "we": [2, 0], "mimic": [5, 60]}
## Which kinds of target each word does something to (the generic table).
const WORKS := {
	"hush": ["speaker", "camera", "guard", "cultist", "drone", "terminal", "device", "door"],
	"look away": ["camera", "drone", "guard", "cultist"],
	"convene": ["speaker", "camera", "guard", "cultist", "drone", "terminal", "device", "door", "reader", "addict"],
	"sleeper": ["guard", "addict", "drone", "camera", "terminal", "cultist"],
	"dreamer": ["door", "terminal"],
	"we": ["reader", "guard", "camera", "drone", "cultist"],
	"mimic": ["guard", "cultist", "speaker"],
}
## Seconds each state lasts (bible-1: look away 6, we 10, mimic 8, hush masks steps 5).
const DUR := {"deaf": 10.0, "hushed": 30.0, "blind": 6.0, "asleep": 20.0, "we": 10.0, "calledoff": 8.0,
	"bow": 8.0, "opened": 600.0, "spoofed": 600.0}
const REACH := 20.0
const KEYS := ["eyeless", "pursuer", "hackable", "guard", "camera", "drone", "cultist", "addict", "stealth"]
const GREEN := Color(0.25, 0.88, 0.54)
const RED := Color(1.0, 0.18, 0.12)

const LINES := {
	"kinds": {"speaker": "SPEAKER", "camera": "CAMERA", "drone": "DRONE", "guard": "SECURITY", "cultist": "FRAMES (CULT)",
		"addict": "PHONE", "door": "LOCK", "reader": "READER", "terminal": "SCREEN", "device": "DEVICE", "eyeless": "NO SIGNAL"},
	"hint": "Q   quick-hack",
	"company": "company property",
	"recording": "on the record",
	"locked": "The frames weren't mine to command. Not yet.",
	"frames_off": "Frames off. Nothing to hack with.",
	"no_target": "Nothing under the crosshair that would listen.",
	"no_words": "I didn't have the words for it.",
	"needs": "needs %d",
	"no_effect": "no effect",
	"refuse": ["Nothing in the frames. No device, no signal. Only it, looking back.",
		"The wheel would not come up. There was nothing in there to talk to. It was listening anyway.",
		"I reached for it with the frames and the frames came back empty, the way a hand comes back from deep water."],
	"refuse_tag": "NO SIGNAL  -  IT CANNOT BE HACKED",
	"wrong": "I meant %s. The frames said %s.",
	"lied": "The wheel had said %s.",
	"nothing": "%s. The word went in and nothing came back.",
	"not_here": "%s. It took the word and gave it back. Not here.",
	"convene_none": "convene. The word went out and nobody came. That was worse, somehow.",
	"rec_on": "Recorder on. ORA keeps what the frames see.",
	"rec_off": "Recorder off. Nothing I do now is evidence.",
	"why": "quick-hack: %s",
	"why_company": "hacked company property on the record",
	"log": "Quick-hack %s on %s.",
	"fx": {
		"hush": {"speaker": "hush. The speaker swallowed the rest of its sentence.",
			"camera": "hush. The camera's alarm went quiet. It could still see me. It just couldn't say so.",
			"guard": "hush. His earpiece filled with nothing. For a while he wouldn't hear me coming.",
			"cultist": "hush. The hymn in her frames stopped. Her mouth kept moving as if it hadn't.",
			"drone": "hush. The drone's siren died in its throat.",
			"_": "hush. It stopped talking. Everything had been talking."},
		"look away": {"camera": "look away. The camera turned to the wall like a child told to.",
			"drone": "look away. The drone tilted and stared at the street instead.",
			"guard": "look away. His frames gave him something more interesting to look at.",
			"cultist": "look away. Her head turned. Her eyes took a moment longer.",
			"_": "look away. It looked away."},
		"convene": {"_": "convene. Heads came up. Something had called them, and it had used my voice."},
		"sleeper": {"guard": "sleeper. His chin went down onto his chest. Standing, the way the patients slept in Ward A.",
			"addict": "sleeper. His phone said it, and he did it. He sat down where he was.",
			"drone": "sleeper. The drone forgot it could fly.",
			"camera": "sleeper. The camera's red light went out.",
			"terminal": "sleeper. The screen froze mid-word.",
			"cultist": "sleeper. She knelt. She had been waiting for somebody to say it.",
			"_": "sleeper. It slept."},
		"dreamer": {"door": "dreamer. The lock thought about it, and then it let me in.",
			"terminal": "dreamer. Welcome, dreamer, the screen said, the way Dufredy's laptop had.",
			"_": "dreamer. Something opened."},
		"we": {"reader": "we. The reader read me as one of them. Green light.",
			"guard": "we. His frames put a company tag over my face. He nodded to me.",
			"camera": "we. The camera logged me as staff.",
			"drone": "we. The drone filed me under friendly.",
			"cultist": "we. She smiled at me like family.",
			"_": "we. It knew me."},
		"mimic": {"guard": "mimic. His radio spoke in his sergeant's voice. He went.",
			"cultist": "mimic. The eye opened over my frames, and they bowed.",
			"speaker": "mimic. The speaker said my words in somebody else's voice, and people turned to it.",
			"_": "mimic. It wore my voice for a moment."},
	},
}

var main: Node
var hud: Control
var rng := RandomNumberGenerator.new()
## What the crosshair is on: the subject (the node with the hack metas), the
## collider that was hit, its kind. Empty when nothing hackable is there.
var target: Node = null
var target_body: Node = null
var target_kind := ""
var wheel_open := false
var wheel_words: Array = []
var wheel_labels: Array = []
var sel := -1
var busy := false
## Psyon's talk-back on the wheel (tests switch it off for determinism).
var backtalk := true
## The last hack fired: {subject, word, picked, kind, handled, line}
var last := {}
var states := {}          # instance id -> {state: until (Stealth clock)}
var _aim := Vector2.ZERO
var _ts := 1.0
var _line := ""
var _line_t := 0.0
var _flash_t := 0.0
var _scan_t := 0
var _lie_i := -1


func setup(m: Node) -> void:
	main = m
	rng.randomize()
	hud = HUD.new()
	hud.hack = self
	hud.mouse_filter = Control.MOUSE_FILTER_IGNORE
	main.ui.root.add_child(hud)
	main.ui.root.move_child(hud, main.ui.fade.get_index())


func on_level(_lv: Node) -> void:
	states.clear()
	target = null
	target_body = null
	last = {}
	busy = false
	if wheel_open:
		close_wheel()


func now() -> float:
	return main.stealth.now if main.stealth else 0.0


# ------------------------------------------------------------------ states

func set_state(n: Node, s: String, secs := -1.0) -> void:
	if n == null:
		return
	var id := n.get_instance_id()
	if not states.has(id):
		states[id] = {}
	states[id][s] = now() + (DUR.get(s, 8.0) if secs < 0.0 else secs)


func has_state(n: Node, s: String) -> bool:
	return state_left(n, s) > 0.0


func state_left(n: Node, s: String) -> float:
	if n == null:
		return 0.0
	var d: Dictionary = states.get(n.get_instance_id(), {})
	return maxf(0.0, float(d.get(s, 0.0)) - now())


func clear_state(n: Node, s: String) -> void:
	if n and states.has(n.get_instance_id()):
		(states[n.get_instance_id()] as Dictionary).erase(s)


# ------------------------------------------------------------------ what a node is

## A meta or null (get_meta with a null default still complains).
static func gm(n: Node, k: String) -> Variant:
	return n.get_meta(k) if n != null and n.has_meta(k) else null


static func m(n: Node, k: String) -> bool:
	if n == null or not n.has_meta(k):
		return false
	var v = n.get_meta(k)
	return v != null and not (v is bool and v == false)


## The node the hack metas live on, from whatever the ray hit: the collider
## itself, or the figure / camera pivot it belongs to.
func subject_of(c: Node) -> Node:
	var n := c
	for i in 4:
		if n == null or n == main.level or not (n is Node3D):
			return null
		for k: String in KEYS:
			if m(n, k):
				# a person's collider: the figure above it carries the state
				var p := n.get_parent()
				if n is CollisionObject3D and p and p != main.level and p is Node3D:
					for k2: String in KEYS:
						if m(p, k2):
							return p
				return n
		n = n.get_parent()
	return null


func kind_of(n: Node, body: Node = null) -> String:
	if n == null:
		return ""
	if n.has_meta("hack_kind"):
		return str(n.get_meta("hack_kind"))
	if m(n, "eyeless") or m(n, "pursuer") or (body and (m(body, "eyeless") or m(body, "pursuer"))):
		return "eyeless"
	if m(n, "drone"):
		return "drone"
	if m(n, "camera"):
		return "camera"
	if m(n, "addict"):
		return "addict"
	if m(n, "cultist"):
		return "cultist"
	if m(n, "guard"):
		return "guard"
	var st = gm(n, "stealth")
	if st is Dictionary and (st as Dictionary).has("kind"):
		return str(st["kind"])
	var b: Node = body if body else n
	var text := (str(b.get_meta("id", "")) + " " + str(b.get_meta("prompt", "")) + " " + str(b.get_meta("scan", ""))).to_lower()
	for pair: Array in [[["speaker", "alarm", " pa ", "radio", "siren"], "speaker"], [["camera"], "camera"], [["drone"], "drone"],
			[["reader", "badge"], "reader"], [["door", "gate", "lock", "lift", "shutter", "hatch", "valve"], "door"],
			[["terminal", "laptop", "screen", "kiosk", "tablet", "hub", "freudbot", "display", "tv", "monitor", " ad", "phone", "headset", "frames"], "terminal"]]:
		for w: String in pair[0]:
			if text.contains(w):
				return pair[1]
	return "device"


func hackable(n: Node, body: Node = null) -> bool:
	if n == null:
		return false
	if n.has_meta("hackable") and n.get_meta("hackable") is bool and n.get_meta("hackable") == false:
		return false
	return kind_of(n, body) != ""


func is_company(n: Node, kind: String) -> bool:
	if n.has_meta("company"):
		return m(n, "company")
	var st = gm(n, "stealth")
	if st is Dictionary and (st as Dictionary).has("faction"):
		return str(st["faction"]) == "company"
	return kind in ["camera", "drone", "reader", "guard"]


func works(word: String, kind: String) -> bool:
	return kind in WORKS.get(word, [])


## The words on the wheel: the quick-hack words Carl holds, in lexicon order.
func held() -> Array:
	var out := []
	for w: String in ORDER:
		if main.hacks.has(w):
			out.append(w)
	return out


func unlocked() -> bool:
	return main.frames_on and main.connection >= 25.0


# ------------------------------------------------------------------ the crosshair

func _process(delta: float) -> void:
	var rd := delta / maxf(0.05, Engine.time_scale)
	_line_t = maxf(0.0, _line_t - rd)
	_flash_t = maxf(0.0, _flash_t - rd)
	if not main.started or not main.level or main.loading:
		target = null
		hud.queue_redraw()
		return
	if wheel_open:
		if not is_instance_valid(target) or main.ui.busy:
			close_wheel()
		hud.queue_redraw()
		return
	_scan_t += 1
	if _scan_t % 2 == 0:
		_find_target()
	hud.queue_redraw()


func _find_target() -> void:
	target = null
	target_body = null
	target_kind = ""
	if not unlocked() or main.ui.busy or main.player.seated or main.ui.title.visible:
		return
	var cam: Camera3D = main.player.cam
	var space: PhysicsDirectSpaceState3D = main.player.get_world_3d().direct_space_state
	var o := cam.global_position
	var fwd := -cam.global_basis.z
	var right := cam.global_basis.x
	var up := cam.global_basis.y
	for off: Vector2 in [Vector2.ZERO, Vector2(0.018, 0), Vector2(-0.018, 0), Vector2(0, 0.018), Vector2(0, -0.018)]:
		var dir := (fwd + right * off.x + up * off.y).normalized()
		var q := PhysicsRayQueryParameters3D.create(o, o + dir * REACH, 1 | 2, [main.player.get_rid()])
		q.collide_with_areas = true
		var hit: Dictionary = space.intersect_ray(q)
		if hit.is_empty():
			continue
		var c: Node = hit["collider"]
		var s := subject_of(c)
		if s and hackable(s, c):
			target = s
			target_body = c
			target_kind = kind_of(s, c)
			return


# ------------------------------------------------------------------ the wheel

func _input(e: InputEvent) -> void:
	if not main or not main.started or main.loading:
		return
	if wheel_open:
		if e is InputEventMouseMotion:
			_aim += (e as InputEventMouseMotion).relative
			if _aim.length() > 220.0:
				_aim = _aim.normalized() * 220.0
			if _aim.length() > 26.0:
				var a := atan2(_aim.y, _aim.x) + PI / 2.0
				sel = int(round(wrapf(a, 0.0, TAU) / (TAU / wheel_words.size()))) % wheel_words.size()
			get_viewport().set_input_as_handled()
		elif e.is_action_released("hack"):
			get_viewport().set_input_as_handled()
			if sel >= 0:
				pick(sel)
			else:
				close_wheel()
		elif e is InputEventKey and e.pressed and not e.echo:
			var k := (e as InputEventKey).physical_keycode
			if k >= KEY_1 and k < KEY_1 + wheel_words.size():
				pick(int(k - KEY_1))
			elif k == KEY_ESCAPE:
				close_wheel()
			get_viewport().set_input_as_handled()
		elif e is InputEventMouseButton and e.pressed:
			if (e as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT and sel >= 0:
				pick(sel)
			elif (e as InputEventMouseButton).button_index == MOUSE_BUTTON_RIGHT:
				close_wheel()
			get_viewport().set_input_as_handled()
		return
	if e.is_action_pressed("hack") and not e.is_echo():
		if main.ui.busy or main.player.locked or main.ui.title.visible:
			return
		get_viewport().set_input_as_handled()
		try_open()


## Q pressed: open the wheel on the target, or say why not.
func try_open() -> bool:
	if not main.frames_on:
		say_line(LINES["frames_off"])
		return false
	if main.connection < 25.0:
		say_line(LINES["locked"])
		return false
	if target == null or not is_instance_valid(target):
		_find_target()
	if target == null:
		say_line(LINES["no_target"])
		return false
	if target_kind == "eyeless":
		refuse()
		return false
	var words := held()
	if words.is_empty():
		say_line(LINES["no_words"])
		return false
	open_wheel(words)
	return true


func open_wheel(words: Array) -> void:
	wheel_words = words
	wheel_labels = words.duplicate()
	# past 75 the wheel lies: one label may name another word
	_lie_i = -1
	if main.connection >= 75.0 and words.size() > 1 and rng.randf() < 0.5:
		_lie_i = rng.randi() % words.size()
		var other: String = words[(_lie_i + 1 + rng.randi() % (words.size() - 1)) % words.size()]
		wheel_labels[_lie_i] = other
	sel = -1
	_aim = Vector2.ZERO
	wheel_open = true
	_ts = Engine.time_scale
	Engine.time_scale = _ts * 0.3
	main.play("on", -14.0, 1.6)


func close_wheel() -> void:
	if not wheel_open:
		return
	wheel_open = false
	Engine.time_scale = _ts


## A word chosen on the wheel.
func pick(i: int) -> void:
	if i < 0 or i >= wheel_words.size():
		close_wheel()
		return
	var word: String = wheel_words[i]
	var shown: String = wheel_labels[i]
	var s := target
	var b := target_body
	close_wheel()
	if int(WORDS[word][1]) > int(main.connection):
		say_line(LINES["needs"] % int(WORDS[word][1]))
		return
	fire(s, word, b, shown)


## The wheel's choice after Psyon has had its say: past 50, one in ten is
## another held word.
func hackback(word: String) -> String:
	var hs := held()
	if backtalk and main.connection >= 50.0 and hs.size() > 1 and rng.randf() < 0.1:
		var others := hs.filter(func(w): return w != word and int(WORDS[w][1]) <= int(main.connection))
		if not others.is_empty():
			return others[rng.randi() % others.size()]
	return word


# ------------------------------------------------------------------ firing

func refuse() -> void:
	main.play("static", -10.0, 0.7)
	main.ui.glitch(0.5, 0.5)
	var r: Array = LINES["refuse"]
	say_line(r[rng.randi() % r.size()], 3.5)
	last = {"subject": target, "word": "", "picked": "", "kind": "eyeless", "handled": false, "line": "refuse"}


## Fire a word at a target: the cast, the level's say, the effect, the cost.
func fire(s: Node, picked: String, body: Node = null, shown := "") -> void:
	if busy or s == null or not is_instance_valid(s):
		return
	if body == null:
		body = s
	var kind := kind_of(s, body)
	if kind == "eyeless":
		target = s
		refuse()
		return
	busy = true
	var word := hackback(picked)
	main.play("glitch", -9.0, 1.25)
	main.ui.glitch(0.35, 0.35)
	_flash_t = 0.5
	target = s
	await main.get_tree().create_timer(0.45).timeout
	if not is_instance_valid(s):
		busy = false
		return
	var handled := false
	var id_node: Node = body if body.has_meta("id") else s
	if main.level and main.level.has_method("on_hack"):
		handled = await main.level.on_hack(id_node, word)
	var line := ""
	if not handled:
		var allowed = gm(s, "hack_words") if s.has_meta("hack_words") else gm(body, "hack_words")
		if allowed is Array and not (allowed as Array).has(word):
			line = LINES["not_here"] % word
		else:
			line = apply(s, word, kind)
		charge(s, word, kind)
		if shown != "" and shown != word and shown != picked:
			line = (LINES["lied"] % shown) + "  " + line
		elif word != picked:
			line = (LINES["wrong"] % [picked, word]) + "  " + line
		say_line(line, 3.2)
	main.log_line("hack", LINES["log"] % [word, LINES["kinds"].get(kind, kind).to_lower()])
	last = {"subject": s, "word": word, "picked": picked, "kind": kind, "handled": handled, "line": line}
	busy = false


## The standard cost: the word's Connection; +3 pressure for company
## property on the record.
func charge(s: Node, word: String, kind := "") -> void:
	if kind == "":
		kind = kind_of(s)
	main.add_connection(float(WORDS[word][0]), LINES["why"] % word)
	if is_company(s, kind) and main.recording:
		main.add_pressure(3.0, LINES["why_company"])


## The generic effect of a word on a kind of target; returns the line.
func apply(s: Node, word: String, kind: String) -> String:
	var fx: Dictionary = LINES["fx"][word]
	var line: String = str(fx.get(kind, fx["_"]))
	if not works(word, kind):
		return LINES["nothing"] % word
	var st = main.stealth
	match word:
		"hush":
			if kind in ["guard", "cultist"]:
				set_state(s, "deaf")
			else:
				set_state(s, "hushed", 20.0 if kind == "camera" else -1.0)
				_mute(s, true)
			st.mask_steps(5.0)
		"look away":
			set_state(s, "blind")
			st.turn_away(s)
		"convene":
			var n: int = st.convene((s as Node3D).global_position, 16.0, 8.0, s)
			n += main.melee.convene((s as Node3D).global_position, 16.0, 8.0)
			if n == 0 and kind not in ["guard", "cultist", "addict"]:
				line = LINES["convene_none"]
		"sleeper":
			var secs: float = {"drone": 25.0, "camera": 12.0, "terminal": 30.0, "cultist": 12.0}.get(kind, 20.0)
			set_state(s, "asleep", secs)
			if kind == "addict":
				main.melee.sleep(s, secs)
			else:
				st.sleep(s, secs)
		"dreamer":
			set_state(s, "opened")
			_open(s)
		"we":
			if kind == "reader":
				set_state(s, "spoofed")
				_open(s)
			else:
				set_state(s, "we")
		"mimic":
			if kind == "cultist":
				set_state(s, "bow")
				st.bow_near((s as Node3D).global_position, 10.0, DUR["bow"])
			elif kind == "guard":
				set_state(s, "calledoff")
				st.call_off(s)
			else:
				st.convene((s as Node3D).global_position, 16.0, 8.0, s)
	return line


## A door that a hack can open: the target (or its "door_node") swings.
func _open(s: Node) -> void:
	var d = gm(s, "door_node")
	if d is Node3D and is_instance_valid(d):
		var dn := d as Node3D
		main.play("door", -6.0, 0.9)
		var tw := dn.create_tween()
		tw.tween_property(dn, "rotation:y", dn.rotation.y + float(s.get_meta("door_angle", -1.6)), 1.0).set_trans(Tween.TRANS_SINE)
	var blk = gm(s, "door_block")
	if blk is CollisionObject3D and is_instance_valid(blk):
		(blk as CollisionObject3D).collision_layer = 0


## Hush a talking thing: every sound under it goes quiet for a while.
func _mute(s: Node, on: bool) -> void:
	for c in s.find_children("*", "AudioStreamPlayer3D", true, false):
		var ap := c as AudioStreamPlayer3D
		if on:
			ap.stream_paused = true
			var secs := state_left(s, "hushed")
			main.get_tree().create_timer(maxf(1.0, secs)).timeout.connect(func():
				if is_instance_valid(ap):
					ap.stream_paused = false)


func say_line(t: String, secs := 2.6) -> void:
	_line = t.trim_prefix("(game) ")
	_line_t = secs


func toggle_recorder() -> void:
	main.recording = not main.recording
	main.play("on" if main.recording else "off", -12.0, 1.3)
	say_line(LINES["rec_on"] if main.recording else LINES["rec_off"])


# ------------------------------------------------------------------ drawing

## The overlay: brackets on the target, the wheel, the hack line, the REC dot.
class HUD extends Control:
	var hack: Node

	func _draw() -> void:
		if hack == null or hack.main == null:
			return
		var main: Node = hack.main
		var ui: Node = main.ui
		var vs := get_viewport_rect().size
		size = vs
		if not main.started or ui.title.visible or not ui.overlay.visible:
			return
		var on_map: bool = main.city != null and ((main.city.map != null and main.city.map.visible) or (main.city.terminal != null and main.city.terminal.visible))
		if on_map:
			return
		var font := ThemeDB.fallback_font
		var c := vs / 2.0
		# the recorder's red dot, frames on
		if main.frames_on and main.recording:
			draw_circle(Vector2(vs.x - 30.0, 58.0), 5.0, Color(1.0, 0.15, 0.1, 0.9))
			draw_string(font, Vector2(vs.x - 72.0, 63.0), "REC", HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color(1.0, 0.4, 0.35, 0.8))
		var t: Node = hack.target
		if t and is_instance_valid(t) and not ui.busy:
			var r := _rect_of(hack.target_body if hack.target_body and is_instance_valid(hack.target_body) else t)
			if r.size.x > 0.0:
				var refuse: bool = hack.target_kind == "eyeless"
				var col: Color = RED if refuse else GREEN
				if hack._flash_t > 0.0:
					col = col.lerp(Color(1, 1, 1), 0.6 * sin(hack._flash_t * 40.0) * 0.5 + 0.3)
					r = r.grow(sin(hack._flash_t * 30.0) * 4.0)
				_brackets(r, col)
				var tag: String = LINES["refuse_tag"] if refuse else (LINES["hint"] + "   ·   " + str(LINES["kinds"].get(hack.target_kind, "DEVICE")))
				if not refuse:
					var st := _state_tag(t)
					if st != "":
						tag += "   ·   " + st
					elif hack.is_company(t, hack.target_kind) and main.recording:
						tag += "   ·   " + LINES["company"]
				var tw := font.get_string_size(tag, HORIZONTAL_ALIGNMENT_LEFT, -1, 14).x
				var tp := Vector2(clampf(r.position.x + r.size.x / 2.0 - tw / 2.0, 8.0, vs.x - tw - 8.0), minf(r.end.y + 20.0, vs.y - 60.0))
				if not hack.wheel_open:
					draw_rect(Rect2(tp + Vector2(-6, -15), Vector2(tw + 12, 21)), Color(0.0, 0.0, 0.0, 0.55))
					draw_string(font, tp, tag, HORIZONTAL_ALIGNMENT_LEFT, -1, 14, col)
		if hack.wheel_open:
			_wheel(c, font)
		if hack._line_t > 0.0 and hack._line != "":
			var a := clampf(hack._line_t / 0.5, 0.0, 1.0)
			var w := minf(760.0, vs.x - 80.0)
			var lines := _wrap(font, hack._line, w, 18)
			var y := vs.y * 0.66
			for ln: String in lines:
				var lw := font.get_string_size(ln, HORIZONTAL_ALIGNMENT_LEFT, -1, 18).x
				draw_string(font, Vector2(c.x - lw / 2.0 + 2, y + 2), ln, HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(0, 0, 0, 0.85 * a))
				draw_string(font, Vector2(c.x - lw / 2.0, y), ln, HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(0.75, 1.0, 0.85, a))
				y += 24.0

	func _state_tag(t: Node) -> String:
		for s: String in ["asleep", "blind", "we", "deaf", "hushed", "calledoff", "bow"]:
			var left: float = hack.state_left(t, s)
			if left > 0.0:
				return "%s %ds" % [s.to_upper(), int(ceil(left))]
		return ""

	func _wrap(font: Font, text: String, w: float, fs: int) -> Array:
		var out := []
		var cur := ""
		for word: String in text.split(" "):
			var tryl := word if cur == "" else cur + " " + word
			if font.get_string_size(tryl, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x > w and cur != "":
				out.append(cur)
				cur = word
			else:
				cur = tryl
		if cur != "":
			out.append(cur)
		return out

	## The target's box on screen, from its collision box (or a person's height).
	func _rect_of(n: Node) -> Rect2:
		var cam: Camera3D = hack.main.player.cam
		var pts := []
		var shape_found := false
		if n is CollisionObject3D:
			for cs in n.get_children():
				if cs is CollisionShape3D and (cs as CollisionShape3D).shape is BoxShape3D:
					var e: Vector3 = ((cs as CollisionShape3D).shape as BoxShape3D).size / 2.0
					var xf: Transform3D = (cs as CollisionShape3D).global_transform
					for sx: float in [-1.0, 1.0]:
						for sy: float in [-1.0, 1.0]:
							for sz: float in [-1.0, 1.0]:
								pts.append(xf * Vector3(e.x * sx, e.y * sy, e.z * sz))
					shape_found = true
					break
		if not shape_found and n is Node3D:
			var p: Vector3 = (n as Node3D).global_position
			for sy: float in [0.0, 1.8]:
				for sx: float in [-0.35, 0.35]:
					pts.append(p + cam.global_basis.x * sx + Vector3(0, sy, 0))
		var r := Rect2()
		var first := true
		for p: Vector3 in pts:
			if cam.is_position_behind(p):
				continue
			var sp := cam.unproject_position(p)
			if first:
				r = Rect2(sp, Vector2.ZERO)
				first = false
			else:
				r = r.expand(sp)
		if first:
			return Rect2()
		var vs := get_viewport_rect().size
		r = r.grow(6.0)
		if r.size.x < 30.0:
			r = r.grow_individual((30.0 - r.size.x) / 2.0, 0, (30.0 - r.size.x) / 2.0, 0)
		if r.size.y < 30.0:
			r = r.grow_individual(0, (30.0 - r.size.y) / 2.0, 0, (30.0 - r.size.y) / 2.0)
		r = r.intersection(Rect2(Vector2(8, 8), vs - Vector2(16, 16)))
		return r

	func _brackets(r: Rect2, col: Color) -> void:
		var l := minf(18.0, minf(r.size.x, r.size.y) * 0.35)
		var w := 2.0
		for cx: float in [0.0, 1.0]:
			for cy: float in [0.0, 1.0]:
				var p := r.position + Vector2(r.size.x * cx, r.size.y * cy)
				var dx := l if cx == 0.0 else -l
				var dy := l if cy == 0.0 else -l
				draw_line(p, p + Vector2(dx, 0), col, w)
				draw_line(p, p + Vector2(0, dy), col, w)
		draw_rect(r, Color(col.r, col.g, col.b, 0.06), true)

	func _wheel(c: Vector2, font: Font) -> void:
		var words: Array = hack.wheel_words
		var n := words.size()
		# an ellipse, wide enough that seven slots never touch
		var rad := Vector2(212.0, 150.0)
		var rim := PackedVector2Array()
		for k in 65:
			var ra := TAU * k / 64.0
			rim.append(c + Vector2(cos(ra) * (rad.x + 92.0), sin(ra) * (rad.y + 42.0)))
		draw_colored_polygon(rim, Color(0.0, 0.02, 0.02, 0.5))
		draw_polyline(rim, Color(GREEN.r, GREEN.g, GREEN.b, 0.35), 1.5)
		draw_arc(c, 42.0, 0.0, TAU, 48, Color(GREEN.r, GREEN.g, GREEN.b, 0.6), 1.5)
		var kind_t: String = str(LINES["kinds"].get(hack.target_kind, "DEVICE"))
		var kw := font.get_string_size(kind_t, HORIZONTAL_ALIGNMENT_LEFT, -1, 13).x
		draw_string(font, c + Vector2(-kw / 2.0, 5.0), kind_t, HORIZONTAL_ALIGNMENT_LEFT, -1, 13, GREEN)
		if hack._aim.length() > 26.0:
			draw_line(c + hack._aim.normalized() * 44.0, c + hack._aim.normalized() * 70.0, GREEN, 2.0)
		var conn: float = hack.main.connection
		var company: bool = hack.target and is_instance_valid(hack.target) and hack.is_company(hack.target, hack.target_kind) and hack.main.recording
		for i in n:
			var a := -PI / 2.0 + TAU * i / n
			var p := c + Vector2(cos(a) * rad.x, sin(a) * rad.y)
			var word: String = words[i]
			var label: String = hack.wheel_labels[i]
			var need: int = int(WORDS[word][1])
			var ok: bool = hack.works(word, hack.target_kind) and conn >= need
			var on: bool = i == hack.sel
			var box := Rect2(p - Vector2(76, 26), Vector2(152, 52))
			draw_rect(box, Color(0.02, 0.08, 0.05, 0.92) if on else Color(0.0, 0.0, 0.0, 0.7))
			draw_rect(box, GREEN if on else Color(GREEN.r, GREEN.g, GREEN.b, 0.35), false, 2.0 if on else 1.0)
			var tc: Color = (Color(0.9, 1.0, 0.94) if on else GREEN) if ok else Color(0.55, 0.6, 0.58, 0.8)
			var lt := "%d  %s" % [i + 1, label]
			var lw := font.get_string_size(lt, HORIZONTAL_ALIGNMENT_LEFT, -1, 19).x
			draw_string(font, Vector2(p.x - lw / 2.0, p.y - 2.0), lt, HORIZONTAL_ALIGNMENT_LEFT, -1, 19, tc)
			var sub := ""
			if conn < need:
				sub = LINES["needs"] % need
			elif not hack.works(word, hack.target_kind):
				sub = LINES["no_effect"]
			else:
				sub = "+%d Connection" % int(WORDS[word][0])
				if company:
					sub += "  - Standing"
			var sw := font.get_string_size(sub, HORIZONTAL_ALIGNMENT_LEFT, -1, 12).x
			draw_string(font, Vector2(p.x - sw / 2.0, p.y + 16.0), sub, HORIZONTAL_ALIGNMENT_LEFT, -1, 12,
				Color(1.0, 0.72, 0.35, 0.9) if (company and ok) else Color(0.7, 0.8, 0.75, 0.75))
