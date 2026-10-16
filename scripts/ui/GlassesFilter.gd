extends CanvasLayer
class_name GlassesFilter
## Full-screen shader driven by Game.glasses_on and Game.connection, plus the
## ORA HUD chrome that only exists with the glasses on.

var _rect: ColorRect
var _mat: ShaderMaterial
var _hud: Control
var _hud_label: Label
var _objective: Label
var _meter_label: Label
var _meter_bg: ColorRect
var _meter_fill: ColorRect
var _glasses_value := 1.0
var _target := 1.0


func _ready() -> void:
	layer = 10
	_rect = ColorRect.new()
	_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_mat = ShaderMaterial.new()
	_mat.shader = load("res://assets/shaders/glasses.gdshader")
	_rect.material = _mat
	add_child(_rect)

	_hud = Control.new()
	_hud.set_anchors_preset(Control.PRESET_FULL_RECT)
	_hud.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_hud)
	_hud_label = Label.new()
	_hud_label.position = Vector2(6, 4)
	_hud_label.add_theme_font_size_override("font_size", 8)
	_hud_label.add_theme_color_override("font_color", Color("7fe0c0", 0.85))
	_hud_label.add_theme_color_override("font_shadow_color", Color("050608", 0.9))
	_hud_label.add_theme_constant_override("shadow_offset_x", 1)
	_hud_label.add_theme_constant_override("shadow_offset_y", 1)
	_hud.add_child(_hud_label)
	_objective = Label.new()
	_objective.position = Vector2(6, 16)
	_objective.add_theme_font_size_override("font_size", 10)
	_objective.add_theme_color_override("font_color", Color("f5d6a0"))
	_objective.add_theme_color_override("font_shadow_color", Color("050608", 0.9))
	_objective.add_theme_constant_override("shadow_offset_x", 1)
	_objective.add_theme_constant_override("shadow_offset_y", 1)
	add_child(_objective)
	_fit_viewport()
	get_viewport().size_changed.connect(_fit_viewport)
	var corner := TextureRect.new()
	corner.texture = load("res://assets/ui/eye_glyph.png")
	corner.modulate = Color("7fe0c0", 0.0)
	corner.name = "Glyph"
	corner.position = Vector2(640 - 40, 4)
	_hud.add_child(corner)
	# connection meter, top right, only with the frames on
	_meter_label = Label.new()
	_meter_label.position = Vector2(640 - 190, 4)
	_meter_label.add_theme_font_size_override("font_size", 8)
	_meter_label.add_theme_color_override("font_color", Color("7fe0c0", 0.85))
	_meter_label.add_theme_color_override("font_shadow_color", Color("050608", 0.9))
	_meter_label.add_theme_constant_override("shadow_offset_x", 1)
	_meter_label.add_theme_constant_override("shadow_offset_y", 1)
	_hud.add_child(_meter_label)
	_meter_bg = ColorRect.new()
	_meter_bg.position = Vector2(640 - 190, 15)
	_meter_bg.size = Vector2(140, 4)
	_meter_bg.color = Color("050608", 0.7)
	_hud.add_child(_meter_bg)
	_meter_fill = ColorRect.new()
	_meter_fill.position = Vector2(640 - 190, 15)
	_meter_fill.size = Vector2(0, 4)
	_meter_fill.color = Color("7fe0c0")
	_hud.add_child(_meter_fill)
	for level in Game.THRESHOLDS:
		var tick := ColorRect.new()
		tick.position = Vector2(640 - 190 + 140 * level / 100.0, 14)
		tick.size = Vector2(1, 6)
		tick.color = Color("f5d6a0", 0.6)
		_hud.add_child(tick)

	Game.glasses_toggled.connect(_on_toggled)
	Game.connection_changed.connect(_on_connection)
	_on_connection(Game.connection)
	set_hud_text("ORA  ·  recording")


func set_hud_text(t: String) -> void:
	_hud_label.text = t


## The current goal, shown under the HUD line whatever the glasses state.
func set_objective(t: String) -> void:
	_objective.text = "" if t.is_empty() else "> " + t


func _on_toggled(on: bool) -> void:
	_target = 1.0 if on else 0.0


func _on_connection(v: float) -> void:
	_mat.set_shader_parameter("corruption", v / 100.0)
	# the glyph in the corner only shows once the frames are infected
	_hud.get_node("Glyph").modulate.a = clampf((v - 10.0) / 40.0, 0.0, 0.6)
	if _meter_fill:
		var t := create_tween()
		t.tween_property(_meter_fill, "size:x", 140.0 * v / 100.0, 0.4)
		_meter_fill.color = Color("7fe0c0").lerp(Color("e0453a"), clampf(v / 100.0, 0.0, 1.0))
		_meter_label.text = "CONNECTION  %d" % int(v) + ("   ·  glyphs %d" % Game.glyphs_found.size() if Game.glyphs_found.size() else "")


func _process(delta: float) -> void:
	_glasses_value = move_toward(_glasses_value, _target, delta * 6.0)
	_mat.set_shader_parameter("glasses", _glasses_value)
	_hud.visible = _glasses_value > 0.5


## White-out for a beat. Used by rituals.
func flash(seconds := 0.25) -> void:
	_mat.set_shader_parameter("flash", 1.0)
	await get_tree().create_timer(seconds).timeout
	var t := create_tween()
	t.tween_method(func(v): _mat.set_shader_parameter("flash", v), 1.0, 0.0, 0.4)
	await t.finished


## The web build can hand controls a 0x0 rect at _ready, so size explicitly.
func _fit_viewport() -> void:
	var s: Vector2 = get_viewport().get_visible_rect().size
	for c in [_rect, _hud]:
		c.position = Vector2.ZERO
		c.size = s
