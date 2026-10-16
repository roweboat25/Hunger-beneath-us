extends Control
class_name InterfaceView
## Interfacing: Carl jacks into a broken machine through the frames and the
## screen becomes the inside of it. Something in there sets a puzzle. Four
## kinds, all from the book:
##   "eye"       rotate the rings of the circuit until the wiring forms the eye
##   "breathing" keep time with the lullaby; four notes, faster each time
##   "chant"     a line of the chant with a word missing; pick the word
##   "dreamer"   a typed answer in the Psyon window; the question knows your name
## Every solve is the Hypnogogue teaching Carl a little more of the chant, so
## solving is how the thing gets in. Past connection 50 the puzzles solve
## themselves before he touches them.
##
##   var ok: bool = await main.iface.run("eye", {"title": "FILTRATION UNIT 7"})
## Returns true when solved (always, eventually: there is no fail state), or
## false when the player steps back with Esc.

signal finished(solved: bool)

const W := 640.0
const H := 360.0
const TEAL := Color("7fe0c0")
const AMBER := Color("f5d6a0")
const RED := Color("e0453a")
const DIM := Color("5a6b70")

var kind := ""
var data := {}
var solved := false
var _active := false
var _auto := false
var _time := 0.0
var _rng := RandomNumberGenerator.new()
var _veins: Array = []
var _caption: Label
var _hint: Label
var _msg: Label
var _canvas: Control

# eye
var _rings: Array[int] = []
var _sel := 0
var _moves := 0
# breathing
var _phase := 0.0
var _period := 2.2
var _hits := 0
var _miss_flash := 0.0
var _hit_flash := 0.0
var _last_hit_phase := -10.0
# chant
var _options: Array = []
var _wrong := 0
var _shake := 0.0
# dreamer
var _answered := false
# the password game: a sequence of four sticks, repeated back
var _seq: Array[int] = []
var _pos := 0
var _round := 0
var _showing := true
var _show_t := 0.0
var _lit := -1
const PW_ROUNDS := 4
const PW_NAMES := ["up", "down", "left", "right"]


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_canvas = Control.new()
	_canvas.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_canvas.draw.connect(_draw_view)
	add_child(_canvas)
	_caption = _label(10, Vector2(8, 30), TEAL)
	_hint = _label(9, Vector2(320, 30), Color("b9c2c9"))
	_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_hint.size = Vector2(312, 14)
	_msg = _label(10, Vector2(0, 318), AMBER)
	_msg.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_msg.size = Vector2(640, 16)
	_fit()
	get_viewport().size_changed.connect(_fit)
	hide()


func _label(sz: int, pos: Vector2, col: Color) -> Label:
	var l := Label.new()
	l.add_theme_font_size_override("font_size", sz)
	l.add_theme_color_override("font_color", col)
	l.add_theme_color_override("font_shadow_color", Color("050608"))
	l.add_theme_constant_override("shadow_offset_x", 1)
	l.add_theme_constant_override("shadow_offset_y", 1)
	l.position = pos
	add_child(l)
	return l


func _fit() -> void:
	var s: Vector2 = get_viewport().get_visible_rect().size
	position = Vector2.ZERO
	size = s
	_canvas.position = Vector2.ZERO
	_canvas.size = s


## Run one puzzle. `data` may carry title, line/answer/options (chant),
## question/answers/hint (dreamer). Awaits until solved or stepped back.
func run(puzzle: String, info: Dictionary) -> bool:
	kind = puzzle
	data = info
	solved = false
	_auto = Game.connection >= 50.0
	_rng.seed = hash(String(info.get("title", "")) + puzzle)
	_veins = _make_veins()
	_caption.text = "INTERFACE  ·  " + String(info.get("title", "UNKNOWN DEVICE"))
	_msg.text = ""
	_time = 0.0
	Game.input_locked = true
	show()
	await get_tree().create_timer(0.3).timeout
	match kind:
		"eye":
			_setup_eye()
		"breathing":
			_setup_breathing()
		"chant":
			_setup_chant()
		"dreamer":
			pass
		"password":
			_setup_password()
	_active = true
	if _auto:
		await _auto_solve()
	elif kind == "dreamer":
		await _run_dreamer()
	else:
		var ok: bool = await finished
		if not ok:
			_active = false
			hide()
			Game.input_locked = false
			return false
	# the solved beat: the thing in the machine looks back
	_active = false
	_hint.text = ""
	_msg.text = "the eye opened" if kind == "eye" else ("the door opened a crack" if kind == "password" else "it was listening")
	await get_tree().create_timer(1.1).timeout
	hide()
	Game.input_locked = false
	return true


## Past connection 50 the puzzle solves itself; Carl's hands aren't his.
func _auto_solve() -> void:
	_hint.text = ""
	_msg.text = "my hands were already moving"
	await get_tree().create_timer(0.8).timeout
	match kind:
		"eye":
			while _rings.any(func(r): return r != 0):
				for i in _rings.size():
					if _rings[i] != 0:
						_sel = i
						_rings[i] = (_rings[i] + 1) % 4
						await get_tree().create_timer(0.14).timeout
						break
		"breathing":
			while _hits < 4:
				await get_tree().create_timer(_period * 0.55).timeout
				_hits += 1
				_hit_flash = 1.0
				_period = maxf(0.9, _period * 0.8)
		"chant":
			var ans: String = data["answer"]
			while _options[_sel] != ans:
				_sel = (_sel + 1) % _options.size()
				await get_tree().create_timer(0.22).timeout
			await get_tree().create_timer(0.5).timeout
		"password":
			while _round < PW_ROUNDS:
				_showing = false
				_lit = -1
				for k in _seq:
					_lit = k
					await get_tree().create_timer(0.2).timeout
					_lit = -1
					await get_tree().create_timer(0.1).timeout
				_next_round()
		"dreamer":
			var p: PsyonWindow = get_parent().get_parent().psyon
			p.open(true, "  ·  INTERFACE  ·  session: the Dreamer")
			await p.machine_says(String(data["question"]))
			await get_tree().create_timer(0.6).timeout
			var ans: String = data["answers"][0]
			p._log.push_color(TEAL)
			p._log.add_text("> " + ans + "\n")
			p._log.pop()
			await p.machine_says("You already knew.")
			await get_tree().create_timer(0.8).timeout
			p.close()
			Game.input_locked = true
	solved = true


# ----------------------------------------------------------------- the eye
## Six pieces: four quarter arcs of the outer ring, two half arcs of the inner.
## Turning a piece also turns the one after it, so the rings fight you.
func _setup_eye() -> void:
	_rings = [0, 0, 0, 0, 0, 0]
	_sel = 0
	_moves = 0
	var n := 7 + _rng.randi_range(0, 4)
	for i in n:
		_turn(_rng.randi_range(0, 5))
	if _rings.all(func(r): return r == 0):
		_turn(0)
	_hint.text = "arrows choose a piece  ·  E turns it (and the next)  ·  Esc step back"


func _turn(i: int) -> void:
	_rings[i] = (_rings[i] + 1) % 4
	var j := (i + 1) % _rings.size()
	_rings[j] = (_rings[j] + 1) % 4


# ----------------------------------------------------------- the breathing
func _setup_breathing() -> void:
	_phase = 0.0
	_period = 2.2
	_hits = 0
	_hint.text = "E on the top of the breath, four times  ·  Esc step back"
	_msg.text = "the same four notes. breathe with it."


func _breath() -> float:
	return 0.5 - 0.5 * cos(_phase * TAU)


func _try_hit() -> void:
	var b := _breath()
	if _phase - _last_hit_phase < 0.5:
		return
	if b > 0.86:
		_hits += 1
		_hit_flash = 1.0
		_last_hit_phase = _phase
		_period = maxf(0.9, _period * 0.8)
		_msg.text = ["one.", "two.", "three.", "four."][mini(_hits, 4) - 1]
		if _hits >= 4:
			solved = true
			finished.emit(true)
	else:
		_miss_flash = 1.0
		_hits = 0
		_period = 2.2
		_msg.text = "too soon" if sin(_phase * TAU) > 0 else "too late"


# ---------------------------------------------------------------- the chant
func _setup_chant() -> void:
	_options = Array(data["options"]).duplicate()
	_options.shuffle()
	_sel = 0
	_wrong = 0
	_hint.text = "arrows choose  ·  E say it  ·  Esc step back"


func _try_chant() -> void:
	if _options[_sel] == data["answer"]:
		solved = true
		finished.emit(true)
		return
	_wrong += 1
	_shake = 1.0
	_msg.text = ["closer.", "no. listen.", "it's a line you've heard."][mini(_wrong, 3) - 1]
	if _wrong >= 3:
		# the fork takes the wrong word off the list; no one is stuck here
		_options.remove_at(_sel)
		_sel = 0


# ------------------------------------------------------------- the password
## Mira's game: four sticks, lit in an order that grows a step each round.
## Watch, then step it back. A wrong step replays the same round; no one
## is stuck on a children's game.
func _setup_password() -> void:
	_rng.seed = hash(String(data.get("title", "")) + "password")
	_seq = []
	_round = 0
	_next_round()
	_hint.text = "watch  ·  then arrows repeat it  ·  Esc step back"


func _next_round() -> void:
	_round += 1
	_seq.append(_rng.randi_range(0, 3))
	if _round == 1:
		_seq.append(_rng.randi_range(0, 3))
	_pos = 0
	_showing = true
	_show_t = 0.0
	_lit = -1


func _try_step(k: int) -> void:
	if _showing:
		return
	_lit = k
	_show_t = 0.0
	if k != _seq[_pos]:
		_miss_flash = 1.0
		_shake = 1.0
		_msg.text = ["again.", "she said you'd be bad at it.", "watch the sticks, not the screen."][mini(_round, 3) - 1]
		_pos = 0
		_showing = true
		return
	_pos += 1
	_hit_flash = 0.5
	if _pos >= _seq.size():
		if _round >= PW_ROUNDS:
			_msg.text = ""
			solved = true
			finished.emit(true)
		else:
			_msg.text = "round " + str(_round + 1)
			_next_round()


# -------------------------------------------------------------- the dreamer
func _run_dreamer() -> void:
	var p: PsyonWindow = get_parent().get_parent().psyon
	_hint.text = "type the answer  ·  Enter sends"
	p.open(true, "  ·  INTERFACE  ·  session: the Dreamer")
	await p.machine_says(String(data["question"]))
	var tries := 0
	while true:
		p.accept_input()
		var text: String = (await p.message_sent).to_lower()
		var ok := false
		for a in data["answers"]:
			if text.contains(String(a)):
				ok = true
		if ok:
			await p.machine_says(String(data.get("right", "Yes.")))
			break
		tries += 1
		if tries >= 3:
			await p.machine_says("You already knew. " + String(data["answers"][0]).capitalize() + ".")
			break
		await p.machine_says(String(data.get("hint", "Closer.")) if tries == 2 else "No. Say it like you mean it.")
	await get_tree().create_timer(0.7).timeout
	p.close()
	Game.input_locked = true
	solved = true


# ------------------------------------------------------------------- input
func _can_take_input() -> bool:
	if not visible or not _active or _auto or kind == "dreamer":
		return false
	var main: Node = get_parent().get_parent()
	return not main.dialogue.visible and not main.psyon.visible


func _unhandled_input(event: InputEvent) -> void:
	if not _can_take_input():
		return
	if event.is_action_pressed("cancel"):
		get_viewport().set_input_as_handled()
		finished.emit(false)
		return
	match kind:
		"eye":
			if event.is_action_pressed("move_right") or event.is_action_pressed("move_down"):
				_sel = (_sel + 1) % _rings.size()
			elif event.is_action_pressed("move_left") or event.is_action_pressed("move_up"):
				_sel = (_sel - 1 + _rings.size()) % _rings.size()
			elif event.is_action_pressed("interact"):
				_turn(_sel)
				_moves += 1
				if _rings.all(func(r): return r == 0):
					solved = true
					finished.emit(true)
			else:
				return
			get_viewport().set_input_as_handled()
		"breathing":
			if event.is_action_pressed("interact"):
				_try_hit()
				get_viewport().set_input_as_handled()
		"chant":
			if event.is_action_pressed("move_right") or event.is_action_pressed("move_down"):
				_sel = (_sel + 1) % _options.size()
			elif event.is_action_pressed("move_left") or event.is_action_pressed("move_up"):
				_sel = (_sel - 1 + _options.size()) % _options.size()
			elif event.is_action_pressed("interact"):
				_try_chant()
			else:
				return
			get_viewport().set_input_as_handled()
		"password":
			for i in 4:
				if event.is_action_pressed("move_" + PW_NAMES[i]):
					_try_step(i)
					get_viewport().set_input_as_handled()
					return


## Used by tools/autoplay.gd: play the current puzzle correctly.
func autoplay_step() -> void:
	if not _active or _auto or solved:
		return
	match kind:
		"eye":
			# undo the shuffle the honest way: keep turning until clean
			for i in _rings.size():
				if _rings[i] != 0:
					_turn(i)
					break
			if _rings.all(func(r): return r == 0):
				solved = true
				finished.emit(true)
		"breathing":
			if _breath() > 0.9 and _phase - _last_hit_phase >= 0.5:
				_try_hit()
		"chant":
			_sel = _options.find(data["answer"])
			_try_chant()
		"password":
			if not _showing:
				_try_step(_seq[_pos])


## The answer autoplay types for a dreamer question.
func autoplay_answer() -> String:
	return String(data.get("answers", ["yes"])[0])


# ----------------------------------------------------------------- drawing
func _process(delta: float) -> void:
	if not visible:
		return
	_time += delta
	if kind == "breathing" and _active:
		_phase += delta / _period
	if kind == "password" and _active and not _auto:
		_show_t += delta
		if _showing:
			# a beat of silence, then each stick for 0.45 s with a gap
			var i := int((_show_t - 0.6) / 0.6)
			var within := fmod(_show_t - 0.6, 0.6)
			if _show_t < 0.6:
				_lit = -1
			elif i < _seq.size():
				_lit = _seq[i] if within < 0.42 else -1
			else:
				_showing = false
				_lit = -1
				_show_t = 0.0
		elif _lit >= 0 and _show_t > 0.18:
			_lit = -1
	_miss_flash = maxf(0.0, _miss_flash - delta * 2.0)
	_hit_flash = maxf(0.0, _hit_flash - delta * 2.0)
	_shake = maxf(0.0, _shake - delta * 3.0)
	_canvas.queue_redraw()


func _make_veins() -> Array:
	var out := []
	for i in 14:
		var pts := PackedVector2Array()
		var p := Vector2(_rng.randf_range(0, W), _rng.randf_range(0, H))
		var dir := (Vector2(W / 2, H / 2) - p).normalized()
		for k in 9:
			pts.append(p)
			dir = dir.rotated(_rng.randf_range(-0.7, 0.7))
			p += dir * _rng.randf_range(18, 48)
		out.append(pts)
	return out


func _draw_view() -> void:
	var c := _canvas
	var pulse := 0.5 + 0.5 * sin(_time * 2.1)
	c.draw_rect(Rect2(0, 0, W, H), Color("07090c"))
	# scanlines and static
	for y in range(0, int(H), 4):
		c.draw_line(Vector2(0, y), Vector2(W, y), Color(0.0, 0.0, 0.0, 0.25), 1.0)
	for i in 40:
		var sx := fmod(float(i) * 97.3 + _time * 190.0, W)
		var sy := fmod(float(i) * 41.7 + _time * 37.0, H)
		c.draw_rect(Rect2(sx, sy, 2, 1), Color(0.6, 0.7, 0.7, 0.18))
	# veins: the wiring of the machine, which is not wiring
	for pts in _veins:
		var col := Color(0.42 + 0.2 * pulse, 0.08, 0.07, 0.75)
		c.draw_polyline(pts, col, 2.0)
		c.draw_polyline(pts, Color(TEAL, 0.12), 5.0)
	# vignette
	for i in 6:
		var a := 0.08 * (i + 1)
		var inset := 60.0 - i * 10.0
		c.draw_rect(Rect2(0, 0, W, inset), Color(0, 0, 0, a))
		c.draw_rect(Rect2(0, H - inset, W, inset), Color(0, 0, 0, a))
	var shake := Vector2(sin(_time * 60.0) * 6.0 * _shake, 0)
	match kind:
		"eye":
			_draw_eye(c, shake)
		"breathing":
			_draw_breathing(c)
		"chant":
			_draw_chant(c, shake)
		"dreamer":
			_draw_dreamer(c)
		"password":
			_draw_password(c, shake)
	if _miss_flash > 0.0:
		c.draw_rect(Rect2(0, 0, W, H), Color(RED, 0.25 * _miss_flash))
	if _hit_flash > 0.0:
		c.draw_rect(Rect2(0, 0, W, H), Color(TEAL, 0.12 * _hit_flash))


func _draw_eye(c: Control, shake: Vector2) -> void:
	var centre := Vector2(W / 2, H / 2 + 4) + shake
	var done := solved or (_rings.size() == 6 and _rings.all(func(r): return r == 0))
	for i in _rings.size():
		var outer := i < 4
		var radius := 92.0 if outer else 54.0
		var span := TAU / 4.0 if outer else TAU / 2.0
		var base := (float(i) if outer else float(i - 4)) * span
		var start := base + float(_rings[i]) * TAU / 4.0 - PI / 2.0
		var selected := i == _sel and _active and not _auto
		var col := TEAL if selected else (Color(0.86, 0.3, 0.24) if _rings[i] != 0 else Color(0.78, 0.74, 0.62))
		if done:
			col = RED
		var width := 7.0 if outer else 6.0
		if selected:
			width += 2.0 + 2.0 * (0.5 + 0.5 * sin(_time * 7.0))
		c.draw_arc(centre, radius, start + 0.04, start + span - 0.04, 40, col, width)
		# a tick at the start of each arc so a half-turned half ring reads as wrong
		var tick := centre + Vector2.from_angle(start + 0.04) * radius
		c.draw_line(tick, tick + Vector2.from_angle(start + 0.04) * (12.0 if outer else -12.0), col, 2.0)
	# the socket in the middle: empty until the rings line up
	if done:
		var p := 0.5 + 0.5 * sin(_time * 5.0)
		c.draw_circle(centre, 16.0 + 4.0 * p, Color(0.35, 0.03, 0.02))
		c.draw_circle(centre, 8.0, Color(0.02, 0.0, 0.0))
	else:
		c.draw_circle(centre, 14.0, Color(0.08, 0.06, 0.06))
		c.draw_arc(centre, 14.0, 0, TAU, 24, Color(0.25, 0.1, 0.1), 1.5)
	var font := get_theme_default_font()
	c.draw_string(font, Vector2(W / 2 - 110, 70), "the wiring isn't wiring. make it look back.", HORIZONTAL_ALIGNMENT_LEFT, -1, 9, DIM)


func _draw_breathing(c: Control) -> void:
	var centre := Vector2(W / 2, H / 2 + 8)
	var b := _breath()
	var r := 30.0 + 80.0 * b
	var target := 30.0 + 80.0 * 0.93
	var near := b > 0.86
	c.draw_arc(centre, target, 0, TAU, 64, Color(AMBER, 0.55), 1.5)
	c.draw_arc(centre, target + 8, 0, TAU, 64, Color(AMBER, 0.2), 1.0)
	c.draw_arc(centre, target - 8, 0, TAU, 64, Color(AMBER, 0.2), 1.0)
	var col := TEAL if near else Color(0.7, 0.2, 0.18)
	c.draw_circle(centre, r, Color(col, 0.10 + 0.2 * b))
	c.draw_arc(centre, r, 0, TAU, 64, col, 3.0)
	# the four notes
	for i in 4:
		var p := Vector2(W / 2 - 45 + i * 30, H / 2 + 125)
		if i < _hits:
			c.draw_circle(p, 6.0, TEAL)
		else:
			c.draw_arc(p, 6.0, 0, TAU, 16, DIM, 1.5)
	var font := get_theme_default_font()
	c.draw_string(font, Vector2(W / 2 - 96, 70), "a wordless lullaby. patient. the same four notes.", HORIZONTAL_ALIGNMENT_LEFT, -1, 9, DIM)


func _draw_chant(c: Control, shake: Vector2) -> void:
	var font := get_theme_default_font()
	var line: String = data["line"]
	var y := 118.0
	c.draw_rect(Rect2(60 + shake.x, y - 18, 520, 30), Color(0.0, 0.0, 0.0, 0.5))
	c.draw_string(font, Vector2(72, y) + shake, line, HORIZONTAL_ALIGNMENT_LEFT, 500, 12, AMBER)
	c.draw_string(font, Vector2(72, 80), "it had scratched a line of the chant into its own log. one word was gone.", HORIZONTAL_ALIGNMENT_LEFT, -1, 9, DIM)
	for i in _options.size():
		var oy := 170.0 + i * 26.0
		var selected := i == _sel
		var col := TEAL if selected else Color(0.78, 0.8, 0.8)
		if selected:
			c.draw_rect(Rect2(200, oy - 14, 240, 22), Color(TEAL, 0.12))
		c.draw_string(font, Vector2(212, oy), ("> " if selected else "  ") + String(_options[i]), HORIZONTAL_ALIGNMENT_LEFT, -1, 11, col)


func _draw_dreamer(c: Control) -> void:
	var centre := Vector2(W / 2, H / 2)
	var p := 0.5 + 0.5 * sin(_time * 1.3)
	c.draw_arc(centre, 120.0 + 10.0 * p, 0, TAU, 64, Color(0.4, 0.05, 0.04, 0.6), 4.0)
	c.draw_arc(centre, 70.0 - 6.0 * p, 0, TAU, 64, Color(0.4, 0.05, 0.04, 0.6), 4.0)


func _draw_password(c: Control, shake: Vector2) -> void:
	var centre := Vector2(W / 2, H / 2 + 10) + shake
	var font := get_theme_default_font()
	# the circle of sticks on the floor, as Mira laid them
	c.draw_arc(centre, 110.0, 0, TAU, 64, Color(0.5, 0.4, 0.3, 0.35), 2.0)
	var dirs := [Vector2(0, -1), Vector2(0, 1), Vector2(-1, 0), Vector2(1, 0)]
	for i in 4:
		var p: Vector2 = centre + dirs[i] * 70.0
		var lit := _lit == i
		var col := TEAL if lit else Color(0.55, 0.45, 0.32)
		var perp: Vector2 = dirs[i].orthogonal()
		# a stick: a short thick line, lit sticks glow
		if lit:
			c.draw_line(p - perp * 26.0, p + perp * 26.0, Color(TEAL, 0.25), 16.0)
		c.draw_line(p - perp * 24.0, p + perp * 24.0, col, 5.0)
		c.draw_line(p - perp * 24.0 + dirs[i] * 6.0, p + perp * 24.0 + dirs[i] * 6.0, Color(col, 0.5), 2.0)
		# the arrow key it answers to
		var lp: Vector2 = centre + dirs[i] * 100.0
		c.draw_string(font, lp + Vector2(-8, 4), ["^", "v", "<", ">"][i], HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color(col, 0.8))
	# the tablet in the middle, waiting for the chime
	c.draw_rect(Rect2(centre.x - 18, centre.y - 24, 36, 48), Color(0.05, 0.05, 0.08))
	c.draw_rect(Rect2(centre.x - 18, centre.y - 24, 36, 48), Color(0.4, 0.4, 0.5), false, 1.0)
	var p2 := 0.5 + 0.5 * sin(_time * 3.0)
	c.draw_circle(centre, 5.0 + 2.0 * p2, Color(RED, 0.6) if _showing else Color(TEAL, 0.5))
	# round markers
	for i in PW_ROUNDS:
		var rp := Vector2(W / 2 - 36 + i * 24, H - 62)
		if i < _round - 1 or solved:
			c.draw_circle(rp, 5.0, TEAL)
		elif i == _round - 1:
			c.draw_circle(rp, 5.0, Color(AMBER, 0.5 + 0.5 * p2))
		else:
			c.draw_arc(rp, 5.0, 0, TAU, 16, DIM, 1.5)
	var line := "watch the sticks." if _showing else "your turn. step it back."
	c.draw_string(font, Vector2(W / 2 - 60, 70), line, HORIZONTAL_ALIGNMENT_LEFT, -1, 10, AMBER if not _showing else DIM)
	c.draw_string(font, Vector2(W / 2 - 150, 86), "i give my gift. i close the door. but leave a crack to see once more.", HORIZONTAL_ALIGNMENT_LEFT, -1, 9, DIM)
