extends Control
class_name DialogueBox
## JRPG dialogue box: portrait on the left, name, typewriter text, choices.
## Use with `await`:
##   await box.say("Carl", "Sticks. In the middle of an apartment.", "carl")
##   var pick := await box.choose(["Is it the haircut?", "Say nothing"])

signal advanced
signal chosen(index: int)

const CHARS_PER_SEC := 45.0
const PORTRAIT_DIR := "res://assets/portraits/"

var _panel: PanelContainer
var _portrait: TextureRect
var _name: Label
var _text: RichTextLabel
var _choices: VBoxContainer
var _prompt: Label
var _typing := false
var _choice_buttons: Array[Button] = []
var _selected := 0


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_fit_viewport()
	get_viewport().size_changed.connect(_fit_viewport)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build()
	hide()


func _build() -> void:
	_panel = PanelContainer.new()
	_panel.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	_panel.offset_left = 8
	_panel.offset_right = -8
	_panel.offset_top = -82
	_panel.offset_bottom = -6
	var style := StyleBoxFlat.new()
	style.bg_color = Color("050608", 0.94)
	style.border_color = Color("2fa184")
	style.set_border_width_all(1)
	style.set_content_margin_all(6)
	_panel.add_theme_stylebox_override("panel", style)
	add_child(_panel)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	_panel.add_child(row)

	_portrait = TextureRect.new()
	_portrait.custom_minimum_size = Vector2(64, 64)
	_portrait.stretch_mode = TextureRect.STRETCH_KEEP
	_portrait.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	row.add_child(_portrait)

	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(col)

	_name = Label.new()
	_name.add_theme_color_override("font_color", Color("7fe0c0"))
	_name.add_theme_font_size_override("font_size", 10)
	col.add_child(_name)

	_text = RichTextLabel.new()
	_text.bbcode_enabled = true
	_text.scroll_active = false
	_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	for f in ["normal_font_size", "italics_font_size", "bold_font_size", "bold_italics_font_size"]:
		_text.add_theme_font_size_override(f, 10)
	_text.add_theme_color_override("default_color", Color("e8ecef"))
	col.add_child(_text)

	_choices = VBoxContainer.new()
	_choices.add_theme_constant_override("separation", 0)
	col.add_child(_choices)

	_prompt = Label.new()
	_prompt.text = "▼"
	_prompt.add_theme_font_size_override("font_size", 9)
	_prompt.add_theme_color_override("font_color", Color("2fa184"))
	_prompt.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	_prompt.offset_left = -16
	_prompt.offset_top = -14
	_panel.add_child(_prompt)


func _portrait_for(who: String) -> Texture2D:
	if who.is_empty():
		return null
	var path := PORTRAIT_DIR + who + ".png"
	if ResourceLoader.exists(path):
		return load(path)
	return null


## Show a line and wait for the player to advance it.
func say(speaker: String, text: String, portrait := "") -> void:
	Game.input_locked = true
	show()
	_clear_choices()
	_portrait.texture = _portrait_for(portrait)
	_portrait.visible = _portrait.texture != null
	_name.text = speaker
	_name.visible = not speaker.is_empty()
	_text.text = text
	_text.visible_characters = 0
	_prompt.hide()
	_typing = true
	var total := _text.get_total_character_count()
	var shown := 0.0
	while shown < total and _typing:
		shown += CHARS_PER_SEC * get_process_delta_time()
		_text.visible_characters = int(shown)
		await get_tree().process_frame
	_text.visible_characters = -1
	_typing = false
	_prompt.show()
	await advanced
	_prompt.hide()


## Show a thought from Carl (no portrait, italic).
func think(text: String) -> void:
	await say("", "[i]" + text + "[/i]")


## Present choices under the current text and wait for one.
func choose(options: Array) -> int:
	Game.input_locked = true
	show()
	_clear_choices()
	_prompt.hide()
	_selected = 0
	for i in options.size():
		var b := Button.new()
		b.text = "  " + str(options[i])
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.flat = true
		b.focus_mode = Control.FOCUS_NONE
		b.add_theme_font_size_override("font_size", 10)
		b.pressed.connect(func(): _pick(i))
		_choices.add_child(b)
		_choice_buttons.append(b)
	_highlight()
	var idx: int = await chosen
	_clear_choices()
	return idx


func close() -> void:
	hide()
	_clear_choices()
	Game.input_locked = false


func _clear_choices() -> void:
	for b in _choice_buttons:
		b.queue_free()
	_choice_buttons.clear()


func _highlight() -> void:
	for i in _choice_buttons.size():
		var b := _choice_buttons[i]
		b.text = ("> " if i == _selected else "  ") + b.text.substr(2)
		b.add_theme_color_override("font_color", Color("7fe0c0") if i == _selected else Color("b9c2c9"))


func _pick(i: int) -> void:
	chosen.emit(i)


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if not _choice_buttons.is_empty():
		if event.is_action_pressed("move_down"):
			_selected = (_selected + 1) % _choice_buttons.size()
			_highlight()
			get_viewport().set_input_as_handled()
		elif event.is_action_pressed("move_up"):
			_selected = (_selected - 1 + _choice_buttons.size()) % _choice_buttons.size()
			_highlight()
			get_viewport().set_input_as_handled()
		elif event.is_action_pressed("interact"):
			_pick(_selected)
			get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("interact"):
		if _typing:
			_typing = false
		else:
			advanced.emit()
		get_viewport().set_input_as_handled()


## The web build can hand us a 0x0 rect at _ready, so size explicitly.
func _fit_viewport() -> void:
	size = get_viewport().get_visible_rect().size
	position = Vector2.ZERO
