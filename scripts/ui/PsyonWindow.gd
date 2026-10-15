extends Control
class_name PsyonWindow
## The Psyon chat window. A laptop screen the player types into.
## The scene script drives it:
##   win.open(true)                      # forked model
##   await win.machine_says("Welcome, dreamer.")
##   var text: String = await win.message_sent
##   await win.render_image(load("res://assets/psyon/room.png"))
##   win.close()

signal message_sent(text: String)
signal closed

const TYPE_SPEED := 40.0

var forked := true
var _panel: PanelContainer
var _log: RichTextLabel
var _line: LineEdit
var _image: TextureRect
var _status: Label
var _hint: Label
var _breath: AudioStreamPlayer
var _render_img: Image
var _render_tex: ImageTexture
var _reveal_order: Array[int] = []
var _reveal_i := 0
var _reveal_speed := 0.0
var _rendering := false
var _accepting := false


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_fit_viewport()
	get_viewport().size_changed.connect(_fit_viewport)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build()
	hide()


func _build() -> void:
	_panel = PanelContainer.new()
	_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	_panel.custom_minimum_size = Vector2(300, 190)
	_panel.offset_left = -150
	_panel.offset_right = 150
	_panel.offset_top = -131
	_panel.offset_bottom = 49
	var style := StyleBoxTexture.new()
	style.texture = load("res://assets/ui/panel_dark.png")
	style.texture_margin_left = 4
	style.texture_margin_right = 4
	style.texture_margin_top = 4
	style.texture_margin_bottom = 4
	style.content_margin_left = 7
	style.content_margin_right = 7
	style.content_margin_top = 6
	style.content_margin_bottom = 6
	_panel.add_theme_stylebox_override("panel", style)
	add_child(_panel)

	var col := VBoxContainer.new()
	col.add_theme_constant_override("separation", 3)
	_panel.add_child(col)

	var header := HBoxContainer.new()
	col.add_child(header)
	var title := Label.new()
	title.text = "PSYON"
	title.add_theme_color_override("font_color", Color("2fa184"))
	title.add_theme_font_size_override("font_size", 10)
	header.add_child(title)
	_status = Label.new()
	_status.text = "  ·  Ionware OS  ·  session: none"
	_status.add_theme_color_override("font_color", Color("6f7a84"))
	_status.add_theme_font_size_override("font_size", 8)
	header.add_child(_status)

	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 6)
	col.add_child(body)

	_log = RichTextLabel.new()
	_log.bbcode_enabled = true
	_log.scroll_following = true
	_log.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_log.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_log.add_theme_font_size_override("normal_font_size", 9)
	_log.add_theme_color_override("default_color", Color("b9c2c9"))
	body.add_child(_log)

	_image = TextureRect.new()
	_image.custom_minimum_size = Vector2(96, 64)
	_image.stretch_mode = TextureRect.STRETCH_KEEP
	_image.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_image.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	_image.hide()
	body.add_child(_image)

	_line = LineEdit.new()
	_line.placeholder_text = "..."
	_line.add_theme_font_size_override("font_size", 9)
	_line.text_submitted.connect(_on_submit)
	col.add_child(_line)
	_hint = Label.new()
	_hint.text = "Type a reply to Psyon and press Enter"
	_hint.add_theme_font_size_override("font_size", 8)
	_hint.add_theme_color_override("font_color", Color("f5d6a0"))
	_hint.hide()
	col.add_child(_hint)


func open(is_forked := true, status := "") -> void:
	forked = is_forked
	Game.input_locked = true
	_log.text = ""
	_image.hide()
	if status.is_empty():
		status = "  ·  Ionware OS  ·  session: " + ("[unrecoverable]" if forked else "synced")
	_status.text = status
	show()
	_accepting = false
	_line.editable = false
	_line.release_focus()


## Let the player type. Resolves when they submit a line.
func accept_input() -> void:
	_accepting = true
	_line.editable = true
	_line.placeholder_text = "Type here..."
	_hint.show()
	_line.grab_focus()


## An empty line or Esc still sends something, so the story never stalls
## on a player who does not know what to type.
const DEFAULT_LINES := ["Hello?", "Who is this?", "What do you want?"]
var _defaults_used := 0


func _on_submit(text: String) -> void:
	if not _accepting:
		return
	if text.strip_edges().is_empty():
		text = DEFAULT_LINES[_defaults_used % DEFAULT_LINES.size()]
		_defaults_used += 1
	_accepting = false
	_line.editable = false
	_line.placeholder_text = "..."
	_hint.hide()
	_line.text = ""
	# Give the keyboard back to the dialogue box.
	_line.release_focus()
	_log.push_color(Color("7fe0c0"))
	_log.add_text("> " + text.strip_edges() + "\n")
	_log.pop()
	message_sent.emit(text.strip_edges())


## Type a line from the machine, character by character.
func machine_says(text: String, color := "e8ecef") -> void:
	# Tags cannot span append_text calls, so push a colour and add plain text.
	_log.push_color(Color(color))
	for i in text.length():
		_log.add_text(text[i])
		await get_tree().create_timer(1.0 / TYPE_SPEED).timeout
	_log.pop()
	_log.add_text("\n")


## Reveal an image pixel by pixel, the way early AI image generation did.
func render_image(tex: Texture2D, seconds := 4.0) -> void:
	var src := tex.get_image()
	src.convert(Image.FORMAT_RGBA8)
	_render_img = Image.create(src.get_width(), src.get_height(), false, Image.FORMAT_RGBA8)
	_render_img.fill(Color("141622"))
	_render_tex = ImageTexture.create_from_image(_render_img)
	_image.texture = _render_tex
	_image.show()
	var n := src.get_width() * src.get_height()
	_reveal_order.clear()
	for i in n:
		_reveal_order.append(i)
	_reveal_order.shuffle()
	_reveal_i = 0
	_reveal_speed = float(n) / seconds
	_rendering = true
	var w := src.get_width()
	var acc := 0.0
	while _reveal_i < n:
		acc += _reveal_speed * get_process_delta_time()
		while acc >= 1.0 and _reveal_i < n:
			var idx := _reveal_order[_reveal_i]
			_render_img.set_pixel(idx % w, idx / w, src.get_pixel(idx % w, idx / w))
			_reveal_i += 1
			acc -= 1.0
		_render_tex.update(_render_img)
		await get_tree().process_frame
	_rendering = false


func clear_image() -> void:
	_image.hide()


func close() -> void:
	hide()
	_accepting = false
	_line.release_focus()
	Game.input_locked = false
	closed.emit()


func _input(event: InputEvent) -> void:
	if visible and _accepting and event.is_action_pressed("cancel"):
		# Esc sends the line as typed (or a default) instead of trapping the player.
		_on_submit(_line.text)
		get_viewport().set_input_as_handled()


## The web build can hand us a 0x0 rect at _ready, so size explicitly.
func _fit_viewport() -> void:
	size = get_viewport().get_visible_rect().size
	position = Vector2.ZERO
