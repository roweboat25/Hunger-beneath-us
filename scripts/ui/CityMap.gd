extends Control
class_name CityMap
## The city map (Tab): Silico drawn from World.EXITS, with where Carl is,
## where the objective is, the route between them, and anything open on the
## side (incidents, case steps) marked. Nothing here is a picture; it is the
## real street graph, so a new map only needs a spot in LAYOUT.

const TEAL := Color("7fe0c0")
const AMBER := Color("f5d6a0")
const RED := Color("e0453a")
const DIM := Color("5a6b70")
const INK := Color("d8e2e6")

## map -> position in 640x360 space. Streets are big dots, interiors small.
const LAYOUT := {
	"Hospital": Vector2(120, 62), "HillRoad": Vector2(200, 62), "Heights": Vector2(330, 62), "Home": Vector2(392, 44),
	"Flyover": Vector2(330, 112),
	"Apartment": Vector2(76, 148), "Lamplight": Vector2(120, 172), "DornerFlat": Vector2(166, 148),
	"WarRoom": Vector2(330, 142), "Spine": Vector2(330, 172),
	"LynxApartment": Vector2(440, 142), "ZetaPark": Vector2(440, 172),
	"Fargona": Vector2(520, 122), "ParkAve": Vector2(520, 172),
	"CognizoStation": Vector2(600, 142), "Cognizo": Vector2(600, 172),
	"CanalWalk": Vector2(120, 222), "Park": Vector2(120, 262),
	"Underpass": Vector2(330, 232), "RailCut": Vector2(520, 242),
	"Factory": Vector2(276, 312), "Southtown": Vector2(330, 292),
	"RestrictedRoad": Vector2(450, 312), "Desert": Vector2(560, 312), "Mirror": Vector2(606, 336),
}

const SHORT := {
	"Hospital": "SalTech", "HillRoad": "Hill Rd", "Heights": "the Heights", "Home": "home", "Flyover": "Flyover",
	"Apartment": "Dufredy", "Lamplight": "Lamplight", "DornerFlat": "Dorner", "WarRoom": "the tower", "Spine": "the Spine",
	"LynxApartment": "Lynx", "ZetaPark": "Zeta & Park", "Fargona": "Fargona Ave", "ParkAve": "Park Ave",
	"CognizoStation": "subway", "Cognizo": "Cognizo", "CanalWalk": "Canal Walk", "Park": "Harmony Green",
	"Underpass": "Underpass", "RailCut": "Rail Cut", "Factory": "factory", "Southtown": "Southtown",
	"RestrictedRoad": "Restricted Rd", "Desert": "sand flats", "Mirror": "the mirror",
}

var _root: Control
var _time := 0.0


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root = Control.new()
	_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.draw.connect(_draw_map)
	add_child(_root)
	_fit()
	get_viewport().size_changed.connect(_fit)
	hide()


func _fit() -> void:
	var s: Vector2 = get_viewport().get_visible_rect().size
	position = Vector2.ZERO
	size = s
	_root.position = Vector2.ZERO
	_root.size = s


func open() -> void:
	show()
	Game.input_locked = true
	_root.queue_redraw()


func close() -> void:
	hide()
	Game.input_locked = false


func _process(delta: float) -> void:
	if visible:
		_time += delta
		_root.queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("city_map") or event.is_action_pressed("cancel") or event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		close()


## The maps a route passes through, from the exit ids World.route returns.
static func route_maps(from: String, to: String) -> Array:
	var out := [from]
	var at := from
	for exit_id in World.route(from, to):
		at = World.EXITS[at][exit_id][0]
		out.append(at)
	return out


## Where every open side thing is: map -> list of short labels.
static func marks() -> Dictionary:
	var out := {}
	for id in Game.incidents:
		if Game.incidents[id] == "open":
			var m: String = Game.INCIDENTS[id]["map"]
			out[m] = out.get(m, []) + ["! " + Game.INCIDENTS[id]["title"]]
	for id in Game.cases:
		if Game.cases[id] != "open":
			continue
		var step: int = Game.case_step(id)
		if step < 0:
			continue
		var s: Array = Game.CASES[id]["steps"][step]
		if s.size() > 2:
			out[s[2]] = out.get(s[2], []) + ["> " + Game.CASES[id]["title"] + ": " + s[1]]
	return out


func _draw_map() -> void:
	var c := _root
	var font := get_theme_default_font()
	c.draw_rect(Rect2(0, 0, 640, 360), Color("07090c", 0.94))
	for y in range(0, 360, 4):
		c.draw_line(Vector2(0, y), Vector2(640, y), Color(0, 0, 0, 0.2), 1.0)
	c.draw_string(font, Vector2(10, 20), "SILICO  ·  ORA city map", HORIZONTAL_ALIGNMENT_LEFT, -1, 11, TEAL)
	c.draw_string(font, Vector2(400, 20), "Tab or Esc closes", HORIZONTAL_ALIGNMENT_RIGHT, 230, 9, Color("b9c2c9"))
	var here := String(Game.current_map)
	var goal := Game.next_beat
	var route: Array = route_maps(here, goal) if here in LAYOUT and goal in LAYOUT else []
	# streets and the links between them
	var drawn := {}
	for a in World.EXITS:
		if not a in LAYOUT:
			continue
		for exit_id in World.EXITS[a]:
			var b: String = World.EXITS[a][exit_id][0]
			if not b in LAYOUT:
				continue
			var key: String = a + "|" + b if a < b else b + "|" + a
			if drawn.has(key):
				continue
			drawn[key] = true
			var on_route := route.has(a) and route.has(b) and absi(route.find(a) - route.find(b)) == 1
			var col := AMBER if on_route else Color(0.35, 0.42, 0.46)
			c.draw_line(LAYOUT[a], LAYOUT[b], col, 3.0 if on_route else 1.5)
	var mk := marks()
	for m in LAYOUT:
		var p: Vector2 = LAYOUT[m]
		var street: bool = m in World.STREETS
		var visited: bool = Game.has_flag("visited_" + m) or m == here
		var r := 6.0 if street else 3.5
		var col := INK if visited else DIM
		if m == goal:
			col = AMBER
		c.draw_circle(p, r, Color("07090c"))
		c.draw_circle(p, r - 1.0, col)
		if m == here:
			var pulse := 0.5 + 0.5 * sin(_time * 5.0)
			c.draw_arc(p, r + 4.0 + 3.0 * pulse, 0, TAU, 32, TEAL, 2.0)
		if m == goal:
			c.draw_arc(p, r + 5.0, 0, TAU, 32, AMBER, 1.5)
		if mk.has(m):
			c.draw_circle(p + Vector2(r + 2, -r - 2), 3.5, RED)
		var label: String = SHORT.get(m, m)
		var w := font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, 8).x
		var lp := p + Vector2(-w / 2.0, r + 11.0)
		if not street:
			lp = p + Vector2(r + 3.0, 3.0)
			if p.x > 560:
				lp = p + Vector2(-w - r - 3.0, 3.0)
		c.draw_string(font, lp, label, HORIZONTAL_ALIGNMENT_LEFT, -1, 8, col if m != here else TEAL)
	# the legend: where you are, where you're going, what's open
	var y := 300.0
	c.draw_circle(Vector2(16, y - 3), 4.0, TEAL)
	c.draw_string(font, Vector2(26, y), "you: " + World.place(here), HORIZONTAL_ALIGNMENT_LEFT, -1, 9, TEAL)
	y += 14
	c.draw_circle(Vector2(16, y - 3), 4.0, AMBER)
	c.draw_string(font, Vector2(26, y), "objective: " + World.place(goal), HORIZONTAL_ALIGNMENT_LEFT, -1, 9, AMBER)
	y += 14
	var side := []
	for m in mk:
		for s in mk[m]:
			side.append(String(s) + "  (" + String(SHORT.get(m, m)) + ")")
	if side.is_empty():
		c.draw_string(font, Vector2(26, y), "nothing open on the side", HORIZONTAL_ALIGNMENT_LEFT, -1, 9, DIM)
	else:
		c.draw_circle(Vector2(16, y - 3), 3.5, RED)
		for i in mini(side.size(), 3):
			c.draw_string(font, Vector2(26, y), side[i], HORIZONTAL_ALIGNMENT_LEFT, 600, 9, Color("e8b4ae"))
			y += 12
	# the chant, as much as Carl knows, along the bottom
	if Game.glyphs_found.size() > 0 and Game.glasses_on:
		var line: String = Game.CHANT[(Game.glyphs_found.size() - 1) % Game.CHANT.size()]
		c.draw_string(font, Vector2(400, 350), line, HORIZONTAL_ALIGNMENT_RIGHT, 230, 8, Color(RED, 0.6))
