extends Control
class_name CloseUp
## First-person close-up view: a painted backdrop with a few hotspots Carl can
## examine with the arrow keys and E. Esc steps back to the map. Dialogue and
## the Psyon window draw on top of it, so scene scripts can run their usual
## lines while the close-up stays behind.
##
## Two modes:
##   show(title, image)                      cinematic backdrop, no hotspots
##   run(title, image, hotspots, handler)    interactive; handler(id) is awaited
##                                           for every hotspot the player picks
## A hotspot is {"id": String, "label": String, "rect": Rect2} in 640x360 space.

signal picked(id: String)

var _bg: TextureRect
var _marks: Control
var _caption: Label
var _hint: Label
var _hotspots: Array = []
var _done: Dictionary = {}
var _sel := 0
var _accepting := false
var _time := 0.0


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_fit_viewport()
	get_viewport().size_changed.connect(_fit_viewport)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_bg = TextureRect.new()
	_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_bg.stretch_mode = TextureRect.STRETCH_SCALE
	_bg.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_bg)
	_marks = Control.new()
	_marks.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_marks.draw.connect(_draw_marks)
	add_child(_marks)
	_caption = Label.new()
	_caption.add_theme_font_size_override("font_size", 10)
	_caption.add_theme_color_override("font_color", Color("7fe0c0"))
	_caption.add_theme_color_override("font_shadow_color", Color("050608"))
	_caption.add_theme_constant_override("shadow_offset_x", 1)
	_caption.add_theme_constant_override("shadow_offset_y", 1)
	_caption.position = Vector2(8, 18)
	add_child(_caption)
	_hint = Label.new()
	_hint.add_theme_font_size_override("font_size", 9)
	_hint.add_theme_color_override("font_color", Color("b9c2c9"))
	_hint.add_theme_color_override("font_shadow_color", Color("050608"))
	_hint.add_theme_constant_override("shadow_offset_x", 1)
	_hint.add_theme_constant_override("shadow_offset_y", 1)
	_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_hint.position = Vector2(320, 18)
	_hint.size = Vector2(312, 14)
	add_child(_hint)
	hide()


func _fit_viewport() -> void:
	var s: Vector2 = get_viewport().get_visible_rect().size
	position = Vector2.ZERO
	size = s
	if _bg:
		_bg.position = Vector2.ZERO
		_bg.size = s
		_marks.position = Vector2.ZERO
		_marks.size = s


## Cinematic backdrop with no hotspots. Stays until hide_view() or close().
func show_view(title: String, image: String) -> void:
	_set_image(image)
	_hotspots = []
	_done = {}
	_caption.text = title
	_hint.text = ""
	_accepting = false
	show()


func hide_view() -> void:
	_accepting = false
	hide()


## Interactive close-up. Returns when the player steps back (or the view is closed).
func run(title: String, image: String, hotspots: Array, handler: Callable) -> void:
	_set_image(image)
	_hotspots = hotspots
	_done = {}
	_sel = 0
	_caption.text = title
	show()
	Game.input_locked = true
	while true:
		_accepting = true
		_hint.text = "arrows choose  ·  E examine  ·  Esc step back"
		_marks.queue_redraw()
		var id: String = await picked
		_accepting = false
		if id.is_empty() or not visible:
			break
		await handler.call(id)
		_done[id] = true
		if not visible:
			break
		Game.input_locked = true
	close()


func close() -> void:
	_accepting = false
	_hotspots = []
	hide()
	Game.input_locked = false


func _set_image(image: String) -> void:
	_bg.texture = load(image) if ResourceLoader.exists(image) else null


func _process(delta: float) -> void:
	if visible:
		_time += delta
		_marks.queue_redraw()


func _can_take_input() -> bool:
	if not visible or not _accepting or _hotspots.is_empty():
		return false
	var main: Node = get_parent().get_parent()
	if main.dialogue.visible or main.psyon.visible:
		return false
	return true


func _unhandled_input(event: InputEvent) -> void:
	if not _can_take_input():
		return
	if event.is_action_pressed("move_right") or event.is_action_pressed("move_down"):
		_sel = (_sel + 1) % _hotspots.size()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("move_left") or event.is_action_pressed("move_up"):
		_sel = (_sel - 1 + _hotspots.size()) % _hotspots.size()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		picked.emit(_hotspots[_sel]["id"])
	elif event.is_action_pressed("cancel"):
		get_viewport().set_input_as_handled()
		picked.emit("")


## Used by tools/autoplay.gd: examine the next unexamined hotspot, else step back.
func autoplay_step() -> void:
	if not _accepting:
		return
	for i in _hotspots.size():
		if not _done.has(_hotspots[i]["id"]):
			_sel = i
			picked.emit(_hotspots[i]["id"])
			return
	picked.emit("")


func _draw_marks() -> void:
	if _hotspots.is_empty():
		return
	var pulse := 0.5 + 0.5 * sin(_time * 4.0)
	for i in _hotspots.size():
		var h: Dictionary = _hotspots[i]
		var r: Rect2 = h["rect"]
		var selected := i == _sel
		var done: bool = _done.has(h["id"])
		var col := Color("7fe0c0") if selected else (Color("5a6b70", 0.7) if done else Color("f5d6a0", 0.75))
		var grow := 3.0 * pulse if selected else 0.0
		r = r.grow(grow)
		var L := 7.0
		var pts := [
			[r.position, r.position + Vector2(L, 0), r.position + Vector2(0, L)],
			[Vector2(r.end.x, r.position.y), Vector2(r.end.x - L, r.position.y), Vector2(r.end.x, r.position.y + L)],
			[Vector2(r.position.x, r.end.y), Vector2(r.position.x + L, r.end.y), Vector2(r.position.x, r.end.y - L)],
			[r.end, r.end - Vector2(L, 0), r.end - Vector2(0, L)],
		]
		for p in pts:
			_marks.draw_line(p[0], p[1], col, 1.0)
			_marks.draw_line(p[0], p[2], col, 1.0)
		if selected:
			var label: String = h["label"]
			var font := get_theme_default_font()
			var w := font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, 9).x
			var lp := Vector2(r.position.x + r.size.x / 2 - w / 2 - 4, r.end.y + 4)
			lp.x = clampf(lp.x, 4, 640 - w - 12)
			lp.y = minf(lp.y, 220)
			_marks.draw_rect(Rect2(lp, Vector2(w + 8, 13)), Color("0b0e1a", 0.85))
			_marks.draw_string(font, lp + Vector2(4, 10), label, HORIZONTAL_ALIGNMENT_LEFT, -1, 9, col)
