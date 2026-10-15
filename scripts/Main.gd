extends Node
## Root of the game. Owns the UI layers and swaps maps in and out.

var dialogue: DialogueBox
var psyon: PsyonWindow
var filter: GlassesFilter
var map: MapScene
var player: Player

var _ui: CanvasLayer
var _start_tile := Vector2i(-1, -1)
var _shot_path := ""
var _toast: Label
var _title: Control
var _title_label: Label
var _title_sub: Label
var _log_panel: PanelContainer
var _log_text: RichTextLabel
var _fade: ColorRect
var _glyph: TextureRect
var _modulate: CanvasModulate


func _ready() -> void:
	filter = GlassesFilter.new()
	add_child(filter)

	_ui = CanvasLayer.new()
	_ui.layer = 20
	add_child(_ui)

	# The laptop window goes under the dialogue box so narration stays readable.
	psyon = PsyonWindow.new()
	_ui.add_child(psyon)
	dialogue = DialogueBox.new()
	_ui.add_child(dialogue)

	_toast = Label.new()
	_toast.add_theme_font_size_override("font_size", 8)
	_toast.add_theme_color_override("font_color", Color("f5d6a0"))
	_toast.position = Vector2(6, 258)
	_toast.modulate.a = 0.0
	_ui.add_child(_toast)
	Game.log_added.connect(_on_log)
	Game.evidence_added.connect(func(item): _show_toast("Evidence bagged: " + item))

	_build_log_panel()
	_build_title()

	_fade = ColorRect.new()
	_fade.color = Color.BLACK
	_fade.set_anchors_preset(Control.PRESET_FULL_RECT)
	_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var fade_layer := CanvasLayer.new()
	fade_layer.layer = 30
	add_child(fade_layer)
	fade_layer.add_child(_fade)

	_glyph = TextureRect.new()
	_glyph.texture = load("res://assets/ui/eye_glyph_red.png")
	_glyph.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_glyph.scale = Vector2(3, 3)
	_glyph.position = Vector2(320 - 48, 180 - 48)
	_glyph.modulate.a = 0.0
	fade_layer.add_child(_glyph)

	_modulate = CanvasModulate.new()
	add_child(_modulate)

	var first := "res://scenes/maps/Apartment.tscn"
	var skip_title := "--autoplay" in OS.get_cmdline_user_args()
	var start_tile := Vector2i(-1, -1)
	var args: PackedStringArray = OS.get_cmdline_user_args()
	if OS.has_feature("web"):
		# dev shortcuts: index.html?map=Park&at=12,5
		var search: String = str(JavaScriptBridge.eval("window.location.search", true))
		for part in search.trim_prefix("?").split("&"):
			args.append("--" + part)
	for arg in args:
		if arg.begins_with("--map="):
			first = "res://scenes/maps/" + arg.trim_prefix("--map=") + ".tscn"
			skip_title = true
		elif arg.begins_with("--at="):
			var xy := arg.trim_prefix("--at=").split(",")
			if xy.size() == 2:
				start_tile = Vector2i(int(xy[0]), int(xy[1]))
	_start_tile = start_tile
	for arg in args:
		if arg.begins_with("--shot="):
			_shot_path = arg.trim_prefix("--shot=")
	if not skip_title:
		await _title_screen()
	await load_map(first)
	if "--autoplay" in OS.get_cmdline_user_args():
		var auto: Node = load("res://tools/autoplay.gd").new()
		add_child(auto)


func load_map(path: String) -> void:
	if map:
		map.queue_free()
		await map.tree_exited
	map = load(path).instantiate()
	map.main = self
	add_child(map)
	move_child(map, 0)
	set_ambient(map.ambient)
	player = map.get_node_or_null("Actors/Player")
	if player and _start_tile.x >= 0:
		player.position = Vector2(_start_tile * 32) + Vector2(16, 28)
		_start_tile = Vector2i(-1, -1)
	for node in get_tree().get_nodes_in_group("interactable"):
		if node.is_inside_tree() and map.is_ancestor_of(node):
			node.interacted.connect(map.on_interact)
	if player:
		var cam: Camera2D = player.get_node("Camera2D")
		cam.limit_left = 0
		cam.limit_top = 0
		cam.limit_right = map.map_size.x
		cam.limit_bottom = map.map_size.y
		cam.reset_smoothing()
	await fade_in()
	map.start()
	if not _shot_path.is_empty():
		# dev: --shot=path.png saves a frame of this map and quits
		await get_tree().create_timer(6.0).timeout
		get_viewport().get_texture().get_image().save_png(_shot_path)
		get_tree().quit()


func set_ambient(c: Color) -> void:
	_modulate.color = c


## The title screen: the tower, the name, press Enter.
func _title_screen() -> void:
	Game.input_locked = true
	var layer := CanvasLayer.new()
	layer.layer = 25
	add_child(layer)
	var bg := TextureRect.new()
	bg.texture = load("res://assets/ui/title.png")
	bg.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	bg.size = Vector2(640, 360)
	layer.add_child(bg)
	var name_label := Label.new()
	name_label.text = "THE HUNGER BENEATH US"
	name_label.add_theme_font_size_override("font_size", 28)
	name_label.add_theme_color_override("font_color", Color("7fe0c0"))
	name_label.add_theme_color_override("font_shadow_color", Color("0b0e1a"))
	name_label.add_theme_constant_override("shadow_offset_x", 2)
	name_label.add_theme_constant_override("shadow_offset_y", 2)
	name_label.add_theme_constant_override("outline_size", 4)
	name_label.add_theme_color_override("font_outline_color", Color("0b0e1a"))
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.position = Vector2(0, 150)
	name_label.size = Vector2(640, 40)
	layer.add_child(name_label)
	var sub := Label.new()
	sub.text = "a Psyonic Integrations case file"
	sub.add_theme_font_size_override("font_size", 9)
	sub.add_theme_color_override("font_color", Color("b9c2c9"))
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub.position = Vector2(0, 196)
	sub.size = Vector2(640, 16)
	layer.add_child(sub)
	var prompt := Label.new()
	prompt.text = "press Enter"
	prompt.add_theme_font_size_override("font_size", 9)
	prompt.add_theme_color_override("font_color", Color("f5d6a0"))
	prompt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prompt.position = Vector2(0, 326)
	prompt.size = Vector2(640, 16)
	layer.add_child(prompt)
	var blink := create_tween().set_loops()
	blink.tween_property(prompt, "modulate:a", 0.15, 0.7)
	blink.tween_property(prompt, "modulate:a", 1.0, 0.7)
	_fade.modulate.a = 0.0
	while true:
		await get_tree().process_frame
		if Input.is_action_just_pressed("interact"):
			break
	blink.kill()
	await fade_out(0.8)
	layer.queue_free()


## Fade to black, swap the map, fade back in and run the new map's start().
func change_map(path: String) -> void:
	Game.input_locked = true
	await fade_out()
	await load_map(path)


## The eye, slowly rotating on black. Used for the elevator hallucination.
func show_glyph(seconds := 2.0) -> void:
	_glyph.pivot_offset = Vector2(16, 16)
	_glyph.modulate.a = 1.0
	var t := create_tween()
	t.tween_property(_glyph, "rotation", TAU * 0.25, seconds)
	t.parallel().tween_property(_glyph, "modulate:a", 0.0, seconds).set_delay(seconds * 0.6)
	await t.finished
	_glyph.rotation = 0.0


func fade_out(seconds := 0.6) -> void:
	var t := create_tween()
	t.tween_property(_fade, "modulate:a", 1.0, seconds)
	await t.finished


func fade_in(seconds := 0.6) -> void:
	var t := create_tween()
	t.tween_property(_fade, "modulate:a", 0.0, seconds)
	await t.finished


func _on_log(entry: String) -> void:
	_show_toast("Case log: " + entry)
	_log_text.append_text("· " + entry + "\n")


func _show_toast(text: String) -> void:
	_toast.text = text
	_toast.modulate.a = 1.0
	var t := create_tween()
	t.tween_interval(2.2)
	t.tween_property(_toast, "modulate:a", 0.0, 0.6)


func _build_log_panel() -> void:
	_log_panel = PanelContainer.new()
	_log_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	_log_panel.offset_left = -130
	_log_panel.offset_right = 130
	_log_panel.offset_top = -90
	_log_panel.offset_bottom = 90
	var style := StyleBoxTexture.new()
	style.texture = load("res://assets/ui/panel.png")
	style.texture_margin_left = 6
	style.texture_margin_right = 6
	style.texture_margin_top = 6
	style.texture_margin_bottom = 6
	style.content_margin_left = 9
	style.content_margin_right = 9
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	_log_panel.add_theme_stylebox_override("panel", style)
	var col := VBoxContainer.new()
	_log_panel.add_child(col)
	var h := Label.new()
	h.text = "CASE LOG  ·  Dufredy, H.  ·  press L to close"
	h.add_theme_font_size_override("font_size", 9)
	h.add_theme_color_override("font_color", Color("f5d6a0"))
	col.add_child(h)
	_log_text = RichTextLabel.new()
	_log_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_log_text.add_theme_font_size_override("normal_font_size", 9)
	col.add_child(_log_text)
	_log_panel.hide()
	_ui.add_child(_log_panel)


func _build_title() -> void:
	_title = Control.new()
	_title.set_anchors_preset(Control.PRESET_FULL_RECT)
	_title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var bg := ColorRect.new()
	bg.color = Color("050608")
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	_title.add_child(bg)
	var v := VBoxContainer.new()
	v.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	v.alignment = BoxContainer.ALIGNMENT_CENTER
	_title.add_child(v)
	_title_label = Label.new()
	_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title_label.add_theme_font_size_override("font_size", 16)
	_title_label.add_theme_color_override("font_color", Color("7fe0c0"))
	_title_label.add_theme_constant_override("outline_size", 3)
	_title_label.add_theme_color_override("font_outline_color", Color("0b1f1a"))
	v.add_child(_title_label)
	_title_sub = Label.new()
	_title_sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title_sub.add_theme_font_size_override("font_size", 9)
	_title_sub.add_theme_color_override("font_color", Color("b9c2c9"))
	v.add_child(_title_sub)
	_title.modulate.a = 0.0
	_title.hide()
	_ui.add_child(_title)


## Black card with a title, held for a moment.
func show_title(text: String, sub := "", hold := 2.0) -> void:
	Game.input_locked = true
	_title_label.text = text
	_title_sub.text = sub
	_title.size = get_viewport().get_visible_rect().size
	_title.position = Vector2.ZERO
	_title.show()
	var t := create_tween()
	t.tween_property(_title, "modulate:a", 1.0, 0.5)
	t.tween_interval(hold)
	t.tween_property(_title, "modulate:a", 0.0, 0.7)
	await t.finished
	_title.hide()
	Game.input_locked = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("case_log") and not dialogue.visible and not psyon.visible:
		_log_panel.visible = not _log_panel.visible
		Game.input_locked = _log_panel.visible
