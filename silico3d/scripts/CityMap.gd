extends Control
## The city map (Tab), bible-1 "City map (Tab)": the districts as a
## schematic with the tower at the centre, each tinted by Faith (0 grey,
## 1 amber, 2 orange, 3 red), open incidents as an eye, the next story beat
## pulsing, where Carl is; the feed along the bottom names the district that
## changed. In the open city, pick a place and travel there (the hours it
## costs are shown: on foot, the company car, the subway). Past 75 one
## district is mislabelled per day. Arrows / WASD or the mouse pick, E
## travels (or waits an hour where you are), Tab or Esc closes.

const BG := Color(0.02, 0.03, 0.04, 0.96)
const INK := Color(0.85, 0.9, 0.92)
const DIM := Color(0.42, 0.5, 0.54)
const CYAN := Color(0.37, 0.91, 1.0)
const GREEN := Color(0.25, 0.88, 0.54)
const MAGENTA := Color(1.0, 0.31, 0.85)
const AMBER := Color(0.96, 0.78, 0.45)
const FAITH := [Color(0.36, 0.4, 0.43), Color(0.88, 0.66, 0.23), Color(0.9, 0.42, 0.16), Color(0.82, 0.13, 0.12)]

## Places in a 1280x720 frame. The tower stands on the Spine.
const LAYOUT := {
	"hill_road": Vector2(170, 130), "heights": Vector2(400, 120),
	"lamplight": Vector2(170, 330), "spine": Vector2(400, 330), "home": Vector2(400, 222),
	"zeta_park": Vector2(560, 330), "park_ave": Vector2(700, 330), "fargona": Vector2(700, 200), "cognizo": Vector2(830, 330),
	"canal_walk": Vector2(170, 455), "harmony_green": Vector2(170, 590),
	"southtown": Vector2(400, 560), "rail_cut": Vector2(700, 470), "red_rock": Vector2(830, 590),
	"restricted_road": Vector2(560, 625),
}

const LINES := {
	"title": "SILICO  ·  ORA CITY MAP",
	"keys": "arrows pick   ·   E travel   ·   Tab close",
	"keys_here": "arrows pick   ·   E wait an hour   ·   Tab close",
	"keys_locked": "Tab close",
	"you": "you are here",
	"faith": "FAITH %d",
	"beat_here": "STORY  %s  ·  open now",
	"beat_later": "STORY  %s  ·  %s",
	"incident": "INCIDENT  %s",
	"by": "%s  ·  %s",
	"hours": "%d h", "hour": "1 h", "zero": "no time",
	"no_travel": "(game) The map only moves you in the open city. Finish what's in front of you.",
	"locked": "(game) Not on the map I'm allowed. Not yet.",
	"legend": ["FAITH 0", "1", "2", "3"],
	"tower": "PSYONIC TOWER",
	"devotion": "devotion %d",
	"feed": "ORA FEED",
}

var main: Node
var city: Node
var sel := "spine"
var _t := 0.0
var _font: Font
var _cursor := Vector2(640, 360)
var _was_busy := false


func setup(m: Node, c: Node) -> void:
	main = m
	city = c
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_font = ThemeDB.fallback_font
	visible = false
	get_viewport().size_changed.connect(_fit)
	_fit()


func _fit() -> void:
	size = get_viewport().get_visible_rect().size


func open() -> void:
	if visible:
		return
	visible = true
	_was_busy = main.ui.busy
	main.ui.busy = true
	sel = city.district if LAYOUT.has(city.district) else "spine"
	_cursor = _to_screen(LAYOUT[sel])
	main.play("on", -12.0, 1.2)
	queue_redraw()


func close() -> void:
	if not visible:
		return
	visible = false
	main.ui.busy = _was_busy
	main.play("off", -12.0, 1.2)


func select(id: String) -> void:
	if LAYOUT.has(id):
		sel = id
		queue_redraw()


func _process(delta: float) -> void:
	if visible:
		_t += delta
		queue_redraw()


# ------------------------------------------------------------------ input

func _input(e: InputEvent) -> void:
	if not visible:
		return
	var vp := get_viewport()
	if e.is_action_pressed("map") or e.is_action_pressed("release"):
		vp.set_input_as_handled()
		close()
		return
	var dir := Vector2.ZERO
	if e.is_action_pressed("move_fwd") or e.is_action_pressed("ui_up"):
		dir = Vector2.UP
	elif e.is_action_pressed("move_back") or e.is_action_pressed("ui_down"):
		dir = Vector2.DOWN
	elif e.is_action_pressed("move_left") or e.is_action_pressed("turn_left") or e.is_action_pressed("ui_left"):
		dir = Vector2.LEFT
	elif e.is_action_pressed("move_right") or e.is_action_pressed("turn_right") or e.is_action_pressed("ui_right"):
		dir = Vector2.RIGHT
	if dir != Vector2.ZERO:
		_step(dir)
		_cursor = _to_screen(LAYOUT[sel])
		vp.set_input_as_handled()
		return
	if e is InputEventMouseMotion:
		# the mouse stays captured; its motion steers a cursor over the map
		_cursor += (e as InputEventMouseMotion).relative
		_cursor = _cursor.clamp(Vector2.ZERO, size)
		var best := ""
		var bd := 60.0
		for id in LAYOUT:
			var d := _to_screen(LAYOUT[id]).distance_to(_cursor)
			if d < bd:
				bd = d
				best = id
		if best != "":
			sel = best
		vp.set_input_as_handled()
		return
	if e.is_action_pressed("interact") or (e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT):
		vp.set_input_as_handled()
		_go()
		return
	if e is InputEventKey:
		vp.set_input_as_handled()


## Pick the nearest place in a direction.
func _step(dir: Vector2) -> void:
	var p: Vector2 = LAYOUT[sel]
	var best := ""
	var bs := INF
	for id in LAYOUT:
		if id == sel:
			continue
		var d: Vector2 = LAYOUT[id] - p
		var along := d.dot(dir)
		if along <= 10.0:
			continue
		var score := along + absf(d.dot(Vector2(dir.y, -dir.x))) * 2.2
		if score < bs:
			bs = score
			best = id
	if best != "":
		sel = best
		main.play("tap", -18.0, 1.6)


func _go() -> void:
	if not city.in_hub():
		main.ui.show_toast(LINES["no_travel"], 2.5)
		return
	if not city.can_travel(sel):
		main.ui.show_toast(LINES["locked"], 2.5)
		return
	close()
	if sel == city.district:
		await city.wait_hour()
		return
	await city.travel(sel)


# ------------------------------------------------------------------ drawing

var _scale := 1.0
var _off := Vector2.ZERO


func _to_screen(p: Vector2) -> Vector2:
	return _off + p * _scale


func _names() -> Dictionary:
	# past 75 the map lies: one district per day wears another's name
	var n := {}
	for id in LAYOUT:
		n[id] = city.district_name(id)
	if main.connection >= 75.0:
		var ids: Array = city.DISTRICT_IDS
		var a: String = ids[int(main.day) % ids.size()]
		var b: String = ids[(int(main.day) * 5 + 3) % ids.size()]
		if a != b:
			var t: String = n[a]
			n[a] = n[b]
			n[b] = t
	return n


func _draw() -> void:
	var s := size
	_scale = minf(s.x / 1280.0, s.y / 720.0)
	_off = (s - Vector2(1280, 720) * _scale) / 2.0
	draw_rect(Rect2(Vector2.ZERO, s), BG)
	for y in range(0, int(s.y), 3):
		draw_line(Vector2(0, y), Vector2(s.x, y), Color(0, 0, 0, 0.25), 1.0)
	var fs := int(16 * _scale)
	var f := _font
	_text(Vector2(40, 46), LINES["title"], 22, GREEN)
	_text(Vector2(40, 72), city.clock_text() + "   ·   " + LINES["devotion"] % int(main.devotion), 16, INK)
	# the streets between places
	for r: Array in city.ROADS:
		var a: Vector2 = LAYOUT[r[0]]
		var b: Vector2 = LAYOUT[r[1]]
		var col := Color(0.25, 0.4, 0.42, 0.9)
		draw_line(_to_screen(a), _to_screen(b), col, 3.0 * _scale)
		if int(r[2]) >= 2:
			draw_circle(_to_screen((a + b) / 2.0), 3.0 * _scale, col)
	# the subway, dashed
	var sub: Array = city.SUBWAY
	for i in sub.size():
		for j in range(i + 1, sub.size()):
			_dash(_to_screen(LAYOUT[sub[i]]), _to_screen(LAYOUT[sub[j]]), Color(MAGENTA, 0.35))
	# the tower on the Spine
	var tp := _to_screen(LAYOUT["spine"])
	draw_circle(tp, 40.0 * _scale, Color(0.08, 0.3, 0.24, 0.5))
	draw_arc(tp, 40.0 * _scale, 0, TAU, 48, Color(GREEN, 0.6), 2.0 * _scale)
	draw_arc(tp, 52.0 * _scale + sin(_t * 1.3) * 3.0, 0, TAU, 48, Color(GREEN, 0.25), 1.5 * _scale)
	_text(LAYOUT["spine"] + Vector2(-58, -48), LINES["tower"], 12, Color(GREEN, 0.8))
	var names := _names()
	var marks := _marks()
	var beat_places := {}
	for b: Dictionary in city.pending():
		beat_places[b["place"]] = b
	for id in LAYOUT:
		var p := _to_screen(LAYOUT[id])
		var r := (22.0 if id != "home" else 13.0) * _scale
		var fa: int = city.faith_of(id) if id != "home" else 0
		var col: Color = FAITH[fa]
		var locked: bool = not city.can_travel(id)
		if locked:
			col = col.darkened(0.55)
		draw_circle(p, r, Color(col, 0.85))
		draw_arc(p, r, 0, TAU, 32, Color(0, 0, 0, 0.9), 2.0 * _scale)
		if beat_places.has(id):
			var open: bool = city.is_open(beat_places[id])
			var pulse := 0.5 + 0.5 * sin(_t * (5.0 if open else 2.0))
			draw_arc(p, r + (7.0 + 5.0 * pulse) * _scale, 0, TAU, 40, Color(AMBER, 0.5 + 0.5 * pulse), 2.5 * _scale)
		if id == city.district:
			var pulse2 := 0.5 + 0.5 * sin(_t * 4.0)
			draw_arc(p, r + 4.0 * _scale, 0, TAU, 40, CYAN, 3.0 * _scale)
			draw_circle(p, 5.0 * _scale + pulse2 * 2.0, CYAN)
		if id == sel:
			draw_arc(p, r + 15.0 * _scale, 0, TAU, 40, Color(1, 1, 1, 0.9), 1.5 * _scale)
		if marks.has(id):
			_eye(p + Vector2(r * 0.95, -r * 0.95), 9.0 * _scale)
		var nm: String = names[id]
		var w := f.get_string_size(nm, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
		var lc := INK if not locked else DIM
		if id == sel:
			lc = Color(1, 1, 1)
		draw_string(f, p + Vector2(-w / 2.0, r + 20.0 * _scale), nm, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, lc)
	_panel(names, marks, beat_places)
	_legend()
	_feed()
	draw_circle(_cursor, 3.0 * _scale, Color(1, 1, 1, 0.5))


func _text(p: Vector2, t: String, sz: int, c: Color, maxw := -1.0) -> void:
	draw_string(_font, _to_screen(p), t, HORIZONTAL_ALIGNMENT_LEFT, maxw * _scale if maxw > 0.0 else -1.0, int(sz * _scale), c)


func _dash(a: Vector2, b: Vector2, c: Color) -> void:
	var n := int(a.distance_to(b) / (10.0 * _scale))
	for i in range(0, n, 2):
		draw_line(a.lerp(b, float(i) / n), a.lerp(b, float(i + 1) / n), c, 2.0 * _scale)


## The eye icon for an open incident: an almond and a pupil, red.
func _eye(p: Vector2, r: float) -> void:
	var pts := PackedVector2Array()
	for i in 17:
		var a := PI * i / 16.0
		pts.append(p + Vector2(cos(a) * r * 1.4, -sin(a) * r * 0.75))
	for i in range(1, 16):
		var a := PI + PI * i / 16.0
		pts.append(p + Vector2(cos(a) * r * 1.4, -sin(a) * r * 0.75))
	draw_colored_polygon(pts, Color(0.05, 0.0, 0.0, 0.95))
	draw_polyline(pts + PackedVector2Array([pts[0]]), Color(1.0, 0.2, 0.15), 1.5 * _scale)
	draw_circle(p, r * 0.42, Color(1.0, 0.15, 0.1))


func _marks() -> Dictionary:
	var out := {}
	for id in main.incidents:
		var inc: Dictionary = main.incidents[id]
		if inc["state"] == "open":
			out[inc["district"]] = out.get(inc["district"], []) + [inc]
	return out


## The right-hand panel: the selected place, its Faith, what's open there,
## and what getting there costs.
func _panel(names: Dictionary, marks: Dictionary, beat_places: Dictionary) -> void:
	var x := 960.0
	var y := 120.0
	draw_rect(Rect2(_to_screen(Vector2(x - 20, y - 36)), Vector2(320, 520) * _scale), Color(0.0, 0.02, 0.02, 0.85))
	draw_rect(Rect2(_to_screen(Vector2(x - 20, y - 36)), Vector2(320, 520) * _scale), Color(GREEN, 0.4), false, 1.0)
	_text(Vector2(x, y), str(names[sel]).to_upper(), 22, Color(1, 1, 1))
	y += 30
	if sel != "home":
		var fa: int = city.faith_of(sel)
		_text(Vector2(x, y), LINES["faith"] % fa, 15, FAITH[fa].lightened(0.2))
		y += 24
		for ln in _wrap(city._faith_line(sel), 34):
			_text(Vector2(x, y), ln, 14, INK)
			y += 19
	y += 10
	if beat_places.has(sel):
		var b: Dictionary = beat_places[sel]
		var where: String = city.LINES["beats"][b["step"]][0]
		var t: String
		if city.is_open(b):
			t = LINES["beat_here"] % where
		else:
			var when: String = city.LINES["card"]["from"] % int(b["from"]) if int(b["day"]) == int(main.day) else city.LINES["card"]["day_from"] % [int(b["day"]), int(b["from"])]
			t = LINES["beat_later"] % [where, when]
		for ln in _wrap(t, 34):
			_text(Vector2(x, y), ln, 15, AMBER)
			y += 20
		y += 6
	if marks.has(sel):
		for inc: Dictionary in marks[sel]:
			for ln in _wrap(LINES["incident"] % inc["title"], 34):
				_text(Vector2(x, y), ln, 15, Color(1.0, 0.45, 0.4))
				y += 20
		y += 6
	y = maxf(y, 380.0)
	var keys: String = LINES["keys"]
	if sel == city.district:
		_text(Vector2(x, y), LINES["you"], 16, CYAN)
		keys = LINES["keys_here"]
	elif not city.can_travel(sel):
		_text(Vector2(x, y), city.LINES["travel"]["locked"], 14, DIM, 290)
	elif city.in_hub():
		var r: Array = city.route(sel)
		var h := int(r[0])
		var hs: String = LINES["zero"] if h == 0 else (LINES["hour"] if h == 1 else LINES["hours"] % h)
		_text(Vector2(x, y), LINES["by"] % [city.LINES["travel"][r[1]], hs], 17, CYAN)
	if not city.in_hub():
		keys = LINES["keys_locked"]
	_text(Vector2(x, 600), keys, 13, DIM)


func _wrap(t: String, n: int) -> Array:
	var out := []
	var cur := ""
	for w in t.split(" "):
		if cur.length() + w.length() + 1 > n and cur != "":
			out.append(cur)
			cur = w
		else:
			cur = w if cur == "" else cur + " " + w
	if cur != "":
		out.append(cur)
	return out


func _legend() -> void:
	var x := 40.0
	var y := 690.0
	var lg: Array = LINES["legend"]
	for i in 4:
		draw_circle(_to_screen(Vector2(x + 8, y - 5)), 7.0 * _scale, FAITH[i])
		_text(Vector2(x + 20, y), lg[i], 13, INK)
		x += 50.0 if i > 0 else 90.0


func _feed() -> void:
	var lines: Array = main.ui.feed_lines
	var y := 690.0
	var x := 330.0
	if lines.is_empty():
		return
	_text(Vector2(x, y), LINES["feed"], 13, Color(MAGENTA, 0.9))
	if lines.size() > 0:
		_text(Vector2(x + 80, y), str(lines[lines.size() - 1]), 13, INK, 820)
	if lines.size() > 1:
		_text(Vector2(x + 80, y - 20), str(lines[lines.size() - 2]), 12, DIM, 820)
