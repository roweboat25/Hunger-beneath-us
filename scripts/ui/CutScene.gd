extends Control
class_name CutScene
## Painted cut scenes: full-screen panels (assets/closeups/*.png) with a slow
## camera move, letterbox bars and a caption that advances with E or Enter.
## Esc skips the whole scene. A panel is a Dictionary:
##   {"image": "cs_opening_1", "lines": [...], "move": "zoom"|"pan"|"pan_left"|"flicker"|"still"}
## play(panels) is awaited by the scene that triggers it; play(panels, true)
## leaves the last panel on screen for a choice drawn over it, until finish().

const PANELS := {
	"opening": [
		{"image": "cs_opening_1", "move": "zoom", "lines": [
			"Silico, after midnight. The elevated road into Lamplight, sand drifting across the lane the way it always did when the wind came off the flats.",
			"Every window in the tower lit teal. Psyonic Integrations never slept. Neither, lately, did I."]},
		{"image": "cs_opening_2", "move": "flicker", "lines": [
			"The dashboard rebooted twice between the flyover and the exit. The ORA frames on the passenger seat lit up on their own, as if something had been waiting for me to look.",
			"One job. Protect the brand. A retired man had gouged out his eyes, and the company needed it to be anything but Psyon."]},
		{"image": "cs_opening_3", "move": "pan", "lines": [
			"Dufredy's building. A police cruiser at the kerb, lights off. One dark window high up among all the lit ones.",
			"A thin line of sand ran along the pavement to the door. I put the frames on. ORA said good evening."]},
	],
	"outage": [
		{"image": "cs_outage_1", "move": "pan_left", "lines": [
			"It went in sequence. Every screen on the boulevard cut to static in the same second, and then the lamps died one after another, down the street, toward the tower.",
			"The tower was the only light left in Silico."]},
		{"image": "cs_outage_2", "move": "zoom", "lines": [
			"Nobody ran. Everyone on the pavement turned the same way and tilted their faces up, lit only by their frames.",
			"They were all looking at the tower. Its windows made a shape I knew. I closed my eyes until the lamps came back."]},
	],
}

signal finished

var _bg: ColorRect
var _frame: Control
var _img: TextureRect
var _caption: Label
var _band: ColorRect
var _bars: Array[ColorRect] = []
var _playing := false
var _advance := false
var _skipped := false
var _tween: Tween
var _flicker := false
## True once the current panel has faded in (the flicker must not fight the fade).
var _shown := false
var _time := 0.0
var _hint: Label


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_bg = ColorRect.new()
	_bg.color = Color("050608")
	_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_bg)
	_frame = Control.new()
	_frame.clip_contents = true
	_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_frame)
	_img = TextureRect.new()
	_img.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_img.stretch_mode = TextureRect.STRETCH_SCALE
	_img.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_img.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_frame.add_child(_img)
	for i in 2:
		var bar := ColorRect.new()
		bar.color = Color("050608")
		bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(bar)
		_bars.append(bar)
	_band = ColorRect.new()
	_band.color = Color("050608", 0.72)
	_band.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_band)
	_caption = Label.new()
	_caption.add_theme_font_size_override("font_size", 10)
	_caption.add_theme_color_override("font_color", Color("e8ecef"))
	_caption.add_theme_color_override("font_shadow_color", Color("050608"))
	_caption.add_theme_constant_override("shadow_offset_x", 1)
	_caption.add_theme_constant_override("shadow_offset_y", 1)
	_caption.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_caption.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	add_child(_caption)
	_hint = Label.new()
	_hint.text = "E next   ·   Esc skip"
	_hint.add_theme_font_size_override("font_size", 8)
	_hint.add_theme_color_override("font_color", Color("b9c2c9", 0.8))
	_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	add_child(_hint)
	_fit()
	get_viewport().size_changed.connect(_fit)
	hide()


func _fit() -> void:
	var s: Vector2 = get_viewport().get_visible_rect().size
	position = Vector2.ZERO
	size = s
	_bg.position = Vector2.ZERO
	_bg.size = s
	_frame.position = Vector2.ZERO
	_frame.size = s
	_img.size = s
	_img.pivot_offset = s / 2.0
	var bar_h := s.y * 0.1
	_bars[0].position = Vector2.ZERO
	_bars[0].size = Vector2(s.x, bar_h)
	_bars[1].position = Vector2(0, s.y - bar_h)
	_bars[1].size = Vector2(s.x, bar_h)
	_band.position = Vector2(0, s.y - bar_h - 56)
	_band.size = Vector2(s.x, 56)
	_caption.position = Vector2(s.x * 0.06, s.y - bar_h - 56)
	_caption.size = Vector2(s.x * 0.88, 56)
	_hint.position = Vector2(s.x - 200, s.y - bar_h + 4)
	_hint.size = Vector2(190, 12)


## Plays a scene by name from PANELS, or an Array of panels.
func play(what, keep := false) -> void:
	var panels: Array = PANELS[what] if what is String else what
	_playing = true
	_skipped = false
	_advance = false
	Game.input_locked = true
	_caption.text = ""
	_img.modulate.a = 0.0
	show()
	for panel in panels:
		if _skipped:
			break
		await _show_panel(panel)
		for line in panel.get("lines", []):
			if _skipped:
				break
			_caption.text = line
			_caption.modulate.a = 0.0
			var t := create_tween()
			t.tween_property(_caption, "modulate:a", 1.0, 0.4)
			await _wait(2.6 + 0.045 * line.length())
		_shown = false
		if not _skipped and not keep:
			var f := create_tween()
			f.tween_property(_img, "modulate:a", 0.0, 0.5)
			await f.finished
	_playing = false
	if keep and not _skipped:
		_caption.text = ""
		return
	await finish()


## Takes the scene down (after a choice drawn over a kept panel).
func finish() -> void:
	if _tween:
		_tween.kill()
	_flicker = false
	var f := create_tween()
	f.tween_property(_img, "modulate:a", 0.0, 0.4)
	await f.finished
	_caption.text = ""
	hide()
	Game.input_locked = false
	finished.emit()


func skip() -> void:
	_skipped = true


func _show_panel(panel: Dictionary) -> void:
	var tex := load("res://assets/closeups/" + String(panel["image"]) + ".png")
	_img.texture = tex
	if _tween:
		_tween.kill()
	_flicker = false
	var s: Vector2 = _frame.size
	_img.position = Vector2.ZERO
	_img.scale = Vector2.ONE
	var move := String(panel.get("move", "zoom"))
	var lines: Array = panel.get("lines", [])
	var dur: float = 2.6 * lines.size() + 4.0
	_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	match move:
		"zoom":
			_img.scale = Vector2(1.12, 1.12)
			_tween.tween_property(_img, "scale", Vector2(1.0, 1.0), dur)
		"pan":
			_img.scale = Vector2(1.15, 1.15)
			_img.position = Vector2(-s.x * 0.075, 0)
			_tween.tween_property(_img, "position", Vector2(s.x * 0.075, 0), dur)
		"pan_left":
			_img.scale = Vector2(1.15, 1.15)
			_img.position = Vector2(s.x * 0.075, 0)
			_tween.tween_property(_img, "position", Vector2(-s.x * 0.075, 0), dur)
		"flicker":
			_img.scale = Vector2(1.06, 1.06)
			_tween.tween_property(_img, "scale", Vector2(1.0, 1.0), dur)
			_flicker = true
		_:
			_tween.tween_interval(dur)
	_shown = false
	var f := create_tween()
	f.tween_property(_img, "modulate:a", 1.0, 0.7)
	await _wait(0.7)
	_img.modulate.a = 1.0
	_shown = true


func _wait(seconds: float) -> void:
	var t := 0.0
	while t < seconds and not _advance and not _skipped:
		await get_tree().process_frame
		t += get_process_delta_time()
	_advance = false


func _process(delta: float) -> void:
	if not visible:
		return
	_time += delta
	if _flicker and _playing and _shown:
		_img.modulate.a = 0.55 if (fmod(_time, 1.7) < 0.08 or fmod(_time, 2.9) < 0.05) else 1.0


func _unhandled_input(event: InputEvent) -> void:
	if not visible or not _playing:
		return
	if event.is_action_pressed("cancel"):
		get_viewport().set_input_as_handled()
		_skipped = true
	elif event.is_action_pressed("interact") or event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		_advance = true
