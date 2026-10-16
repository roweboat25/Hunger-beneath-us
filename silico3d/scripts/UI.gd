extends CanvasLayer
## Everything on screen: the frames overlay (a diegetic HUD, the inside of
## Carl's glasses), the objective, the examine prompt, Carl's thoughts and
## dialogue, Psyon on his phone, the title and the end card.

signal advanced
signal picked(i: int)

const FRAMES_SHADER := """
shader_type canvas_item;
uniform sampler2D screen_tex : hint_screen_texture, filter_linear;
uniform float on = 0.0;
uniform float conn = 0.0;
uniform float glitch = 0.0;
uniform float flash = 0.0;

float h(vec2 p) { return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453); }

void fragment() {
	vec2 uv = SCREEN_UV;
	float t = TIME;
	float row = floor(uv.y * 70.0);
	float n = h(vec2(row, floor(t * 14.0)));
	float tear = glitch * step(0.9, n);
	uv.x += (n - 0.5) * 0.09 * tear;
	float ca = 0.0015 * on + 0.008 * glitch + 0.002 * on * smoothstep(25.0, 75.0, conn);
	vec3 col;
	col.r = texture(screen_tex, uv + vec2(ca, 0.0)).r;
	col.g = texture(screen_tex, uv).g;
	col.b = texture(screen_tex, uv - vec2(ca, 0.0)).b;
	// the frames: a cold tint that turns red as the connection deepens
	vec3 tint = mix(vec3(0.82, 1.04, 1.08), vec3(1.12, 0.78, 0.76), smoothstep(25.0, 60.0, conn));
	col = mix(col, col * tint + vec3(0.0, 0.012, 0.016), on);
	col *= mix(1.0, 0.95 + 0.05 * sin(SCREEN_UV.y * 1100.0), on);
	// the rim of the lenses
	vec2 d = (SCREEN_UV - 0.5) * vec2(1.6, 1.0);
	float rim = smoothstep(0.62, 0.78, length(d));
	col = mix(col, col * 0.25, rim * on);
	// vignette and film grain, always
	float v = smoothstep(0.95, 0.3, length((SCREEN_UV - 0.5) * vec2(1.25, 1.0)));
	col *= mix(0.45, 1.0, v);
	col += (h(SCREEN_UV * 731.0 + vec2(t * 13.0, t * 7.0)) - 0.5) * 0.055;
	col = mix(col, vec3(0.6, 0.0, 0.0), flash * 0.55);
	COLOR = vec4(col, 1.0);
}
"""

var main: Node
var root: Control
var overlay: ColorRect
var crosshair: ColorRect
var prompt: Label
var objective: Label
var status: Label
var toast: Label
var dlg: PanelContainer
var name_l: Label
var body: RichTextLabel
var choice_box: VBoxContainer
var phone: PanelContainer
var phone_text: RichTextLabel
var title: ColorRect
var pause: ColorRect
var endcard: ColorRect
var end_text: RichTextLabel
var busy := false
var _typing := false
var _tw: Tween
var _choices: Array = []
var _sel := 0
var _toast_tw: Tween


func setup(m: Node) -> void:
	main = m
	layer = 10
	root = Control.new()
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)
	overlay = ColorRect.new()
	var sm := ShaderMaterial.new()
	var sh := Shader.new()
	sh.code = FRAMES_SHADER
	sm.shader = sh
	overlay.material = sm
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(overlay)
	crosshair = ColorRect.new()
	crosshair.color = Color(1, 1, 1, 0.55)
	crosshair.size = Vector2(4, 4)
	crosshair.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(crosshair)
	prompt = _label(20, Color(1, 1, 1, 0.9))
	prompt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	objective = _label(18, Color(0.85, 0.85, 0.8, 0.9))
	status = _label(18, Color(0.5, 1.0, 0.9))
	status.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	toast = _label(22, Color(1, 1, 1))
	toast.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	toast.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	toast.modulate.a = 0.0
	_build_dialogue()
	_build_phone()
	_build_title()
	_build_pause()
	_build_end()
	get_viewport().size_changed.connect(_fit)
	_fit()


func _label(size: int, c: Color) -> Label:
	var l := Label.new()
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", c)
	l.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.9))
	l.add_theme_constant_override("shadow_offset_x", 2)
	l.add_theme_constant_override("shadow_offset_y", 2)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(l)
	return l


func _panel_style(alpha := 0.82) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.02, 0.03, 0.04, alpha)
	sb.border_color = Color(0.3, 0.9, 0.8, 0.5)
	sb.set_border_width_all(1)
	sb.set_content_margin_all(16)
	return sb


func _build_dialogue() -> void:
	dlg = PanelContainer.new()
	dlg.add_theme_stylebox_override("panel", _panel_style())
	dlg.visible = false
	root.add_child(dlg)
	var vb := VBoxContainer.new()
	dlg.add_child(vb)
	name_l = Label.new()
	name_l.add_theme_font_size_override("font_size", 20)
	name_l.add_theme_color_override("font_color", Color(0.5, 1.0, 0.9))
	vb.add_child(name_l)
	body = RichTextLabel.new()
	body.bbcode_enabled = true
	body.fit_content = true
	body.scroll_active = false
	body.add_theme_font_size_override("normal_font_size", 21)
	body.add_theme_font_size_override("italics_font_size", 21)
	body.add_theme_color_override("default_color", Color(0.93, 0.92, 0.88))
	vb.add_child(body)
	choice_box = VBoxContainer.new()
	choice_box.visible = false
	vb.add_child(choice_box)


func _build_phone() -> void:
	phone = PanelContainer.new()
	var sb := _panel_style(0.9)
	sb.border_color = Color(0.4, 1.0, 0.6, 0.7)
	sb.set_corner_radius_all(18)
	phone.add_theme_stylebox_override("panel", sb)
	phone.visible = false
	root.add_child(phone)
	phone_text = RichTextLabel.new()
	phone_text.bbcode_enabled = true
	phone_text.add_theme_font_size_override("normal_font_size", 17)
	phone_text.add_theme_font_size_override("italics_font_size", 17)
	phone_text.add_theme_font_size_override("bold_font_size", 17)
	phone.add_child(phone_text)


func _build_title() -> void:
	title = ColorRect.new()
	title.color = Color(0, 0, 0, 0.93)
	root.add_child(title)
	var t := RichTextLabel.new()
	t.bbcode_enabled = true
	t.set_anchors_preset(Control.PRESET_FULL_RECT)
	t.add_theme_font_size_override("normal_font_size", 20)
	t.add_theme_font_size_override("bold_font_size", 44)
	t.text = ("[center]\n\n[b]THE HUNGER BENEATH US[/b]\n[color=#6fe8d0]SILICO  -  THE SPINE  -  first-person test[/color]\n\n"
		+ "[color=#aaaaaa]Night. Rain. The tower in the middle of it like a pin through a map.[/color]\n\n"
		+ "Mouse or arrow keys look    WASD walk    Shift hurry\nE examine / talk    G frames    F scan (frames on)    P Psyon\n\n"
		+ "[color=#888888]Headphones. Lights off.[/color]\n\n[color=#ffffff]Click to begin[/color][/center]")
	title.add_child(t)
	title.mouse_filter = Control.MOUSE_FILTER_STOP


func _build_pause() -> void:
	pause = ColorRect.new()
	pause.color = Color(0, 0, 0, 0.6)
	pause.visible = false
	root.add_child(pause)
	var l := Label.new()
	l.text = "Click to keep walking"
	l.add_theme_font_size_override("font_size", 26)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	l.set_anchors_preset(Control.PRESET_FULL_RECT)
	pause.add_child(l)


func _build_end() -> void:
	endcard = ColorRect.new()
	endcard.color = Color(0, 0, 0, 0.0)
	endcard.visible = false
	root.add_child(endcard)
	end_text = RichTextLabel.new()
	end_text.bbcode_enabled = true
	end_text.set_anchors_preset(Control.PRESET_FULL_RECT)
	end_text.add_theme_font_size_override("normal_font_size", 22)
	end_text.add_theme_font_size_override("bold_font_size", 36)
	endcard.add_child(end_text)


func _fit() -> void:
	var s := get_viewport().get_visible_rect().size
	root.size = s
	overlay.size = s
	title.size = s
	pause.size = s
	endcard.size = s
	crosshair.position = s / 2.0 - Vector2(2, 2)
	prompt.size = Vector2(s.x, 30)
	prompt.position = Vector2(0, s.y * 0.58)
	objective.position = Vector2(24, 18)
	objective.size = Vector2(s.x * 0.6, 30)
	status.position = Vector2(s.x * 0.5 - 24, 18)
	status.size = Vector2(s.x * 0.5, 30)
	toast.position = Vector2(s.x * 0.15, s.y * 0.16)
	toast.size = Vector2(s.x * 0.7, 120)
	var dw := minf(900.0, s.x - 48.0)
	dlg.position = Vector2((s.x - dw) / 2.0, s.y - 220.0)
	dlg.size = Vector2(dw, 0)
	dlg.custom_minimum_size = Vector2(dw, 120)
	phone.position = Vector2(s.x - 360.0, s.y * 0.18)
	phone.size = Vector2(330, 420)
	phone.custom_minimum_size = Vector2(330, 420)


# ------------------------------------------------------------------ frames overlay

var _frames_v := 0.0


func set_frames(on: float, conn: float) -> void:
	var m := overlay.material as ShaderMaterial
	m.set_shader_parameter("conn", conn)
	create_tween().tween_method(_set_frames_v, _frames_v, on, 0.35)


func _set_frames_v(v: float) -> void:
	_frames_v = v
	(overlay.material as ShaderMaterial).set_shader_parameter("on", v)


func glitch(amount: float, t := 0.6) -> void:
	var m := overlay.material as ShaderMaterial
	m.set_shader_parameter("glitch", amount)
	create_tween().tween_method(func(v): m.set_shader_parameter("glitch", v), amount, 0.0, t)


func flash(t := 0.8) -> void:
	var m := overlay.material as ShaderMaterial
	create_tween().tween_method(func(v): m.set_shader_parameter("flash", v), 1.0, 0.0, t)


# ------------------------------------------------------------------ text

func show_toast(text: String, secs := 4.0) -> void:
	toast.text = text
	if _toast_tw:
		_toast_tw.kill()
	_toast_tw = create_tween()
	_toast_tw.tween_property(toast, "modulate:a", 1.0, 0.4)
	_toast_tw.tween_interval(secs)
	_toast_tw.tween_property(toast, "modulate:a", 0.0, 1.2)


func say(who: String, text: String) -> void:
	busy = true
	dlg.visible = true
	choice_box.visible = false
	name_l.text = who
	name_l.visible = who != ""
	body.text = text
	body.visible_ratio = 0.0
	_typing = true
	if _tw:
		_tw.kill()
	_tw = create_tween()
	_tw.tween_property(body, "visible_ratio", 1.0, maxf(0.3, text.length() * 0.017))
	_tw.finished.connect(func(): _typing = false)
	await advanced


func think(text: String) -> void:
	await say("", "[i]" + text + "[/i]")


func choose(opts: Array) -> int:
	busy = true
	dlg.visible = true
	_choices = opts
	_sel = 0
	_draw_choices()
	choice_box.visible = true
	var i: int = await picked
	choice_box.visible = false
	return i


func close() -> void:
	dlg.visible = false
	busy = false


func _draw_choices() -> void:
	for c in choice_box.get_children():
		c.queue_free()
	for i in _choices.size():
		var l := Label.new()
		l.text = ("> " if i == _sel else "   ") + str(i + 1) + ". " + str(_choices[i])
		l.add_theme_font_size_override("font_size", 20)
		l.add_theme_color_override("font_color", Color(0.5, 1.0, 0.9) if i == _sel else Color(0.75, 0.75, 0.75))
		choice_box.add_child(l)


func _input(e: InputEvent) -> void:
	if title.visible:
		if (e is InputEventMouseButton and e.pressed) or (e is InputEventKey and e.pressed and not e.echo):
			get_viewport().set_input_as_handled()
			main.start()
		return
	if endcard.visible and e.is_action_pressed("interact"):
		get_viewport().set_input_as_handled()
		endcard.visible = false
		return
	if pause.visible:
		if e is InputEventMouseButton and e.pressed:
			pause.visible = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			get_viewport().set_input_as_handled()
		return
	if not dlg.visible:
		return
	if choice_box.visible:
		if e.is_action_pressed("move_fwd") or e.is_action_pressed("ui_up"):
			_sel = (_sel - 1 + _choices.size()) % _choices.size()
			_draw_choices()
		elif e.is_action_pressed("move_back") or e.is_action_pressed("ui_down"):
			_sel = (_sel + 1) % _choices.size()
			_draw_choices()
		elif e is InputEventKey and e.pressed and e.keycode >= KEY_1 and e.keycode < KEY_1 + _choices.size():
			picked.emit(int(e.keycode - KEY_1))
		elif e.is_action_pressed("interact") or (e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT):
			picked.emit(_sel)
		else:
			return
		get_viewport().set_input_as_handled()
		return
	if e.is_action_pressed("interact") or (e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT):
		get_viewport().set_input_as_handled()
		if _typing:
			_tw.kill()
			body.visible_ratio = 1.0
			_typing = false
		else:
			advanced.emit()


func _process(_d: float) -> void:
	if main and main.started and not title.visible and not endcard.visible and not OS.has_feature("headless"):
		var lost: bool = Input.mouse_mode != Input.MOUSE_MODE_CAPTURED and not main.shot_mode
		pause.visible = lost


func show_end(text: String) -> void:
	endcard.visible = true
	end_text.text = text
	create_tween().tween_property(endcard, "color:a", 0.88, 2.5)
