extends Node
## Root of the game. Owns the UI layers and swaps maps in and out.

var dialogue: DialogueBox
var psyon: PsyonWindow
var closeup: CloseUp
var cutscene: CutScene
var ending: EndingScreen
var iface: InterfaceView
var city_map: CityMap
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
var _feed: Label
var _feed_timer := 0.0
var _scan_panel: PanelContainer
var _scan_text: RichTextLabel
var _scan_timer := 0.0
var _menu: SceneMenu
var _menu_jump := ""
var _menu_closeup := false
var _on_title := false


func _ready() -> void:
	filter = GlassesFilter.new()
	add_child(filter)

	_ui = CanvasLayer.new()
	_ui.layer = 20
	add_child(_ui)

	# Close-up view under the laptop window, which goes under the dialogue box.
	closeup = CloseUp.new()
	_ui.add_child(closeup)
	iface = InterfaceView.new()
	_ui.add_child(iface)
	city_map = CityMap.new()
	_ui.add_child(city_map)
	cutscene = CutScene.new()
	_ui.add_child(cutscene)
	ending = EndingScreen.new()
	_ui.add_child(ending)
	psyon = PsyonWindow.new()
	_ui.add_child(psyon)
	dialogue = DialogueBox.new()
	_ui.add_child(dialogue)

	_toast = Label.new()
	_toast.add_theme_font_size_override("font_size", 8)
	_toast.add_theme_color_override("font_color", Color("f5d6a0"))
	_toast.position = Vector2(6, 224)
	_toast.modulate.a = 0.0
	_ui.add_child(_toast)
	Game.log_added.connect(_on_log)
	Game.evidence_added.connect(func(item): _show_toast("Evidence bagged: " + item))
	Game.glyph_found.connect(func(_id, n): _show_toast("Glyph %d  ·  a line of the chant decoded" % n))
	Game.threshold_crossed.connect(_on_threshold)
	Game.theory_changed.connect(func(t): _show_toast("Working theory: " + Game.THEORIES[t]["name"]))
	Game.incident_opened.connect(func(id): _show_feed("INCIDENT  ·  " + Game.INCIDENTS[id]["title"] + "  ·  " + World.place(Game.INCIDENTS[id]["map"]).get_slice(",", 0), true))
	Game.incident_resolved.connect(func(id, outcome): _show_toast("Incident %s: %s" % [outcome, Game.INCIDENTS[id]["title"]]))
	Game.case_opened.connect(func(id): _show_feed(Game.CASES[id]["notice"], true))
	Game.case_resolved.connect(func(id, outcome): _show_toast("Case closed: %s (%s)" % [Game.CASES[id]["title"], outcome]))
	Game.interfaced.connect(func(_id, line): _show_toast("Interfaced. A line of the chant, learned by hand." if line.is_empty() else "Interfaced. \"" + line + "\""))
	Game.evidence_added.connect(func(_item): _show_feed("ORA: evidence of a crime detected. Police notified.", true))
	Game.stance_changed.connect(func(st): _show_toast("The file reads you as undecided again." if st.is_empty() else "The file has a word for you now: %s. \"%s\"" % [Game.STANCES[st][0], Game.STANCES[st][1]]))
	Game.time_changed.connect(_on_time)
	Game.outage_changed.connect(func(on): _show_feed("VOLTX: rolling outage in this quadrant. Services may be unresponsive." if on else "VOLTX: service restored.", true))

	# the ORA feed: what the frames push at Carl while he walks
	_feed = Label.new()
	_feed.add_theme_font_size_override("font_size", 8)
	_feed.add_theme_color_override("font_color", Color("7fe0c0", 0.9))
	_feed.add_theme_color_override("font_shadow_color", Color("050608", 0.9))
	_feed.add_theme_constant_override("shadow_offset_x", 1)
	_feed.add_theme_constant_override("shadow_offset_y", 1)
	_feed.position = Vector2(6, 30)
	_feed.modulate.a = 0.0
	_ui.add_child(_feed)
	_build_scan_panel()
	_menu = SceneMenu.new()
	_menu.jump.connect(_on_menu_jump)
	add_child(_menu)

	_build_log_panel()
	_build_title()

	_fade = ColorRect.new()
	_fade.color = Color.BLACK
	_fade.set_anchors_preset(Control.PRESET_FULL_RECT)
	_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var fade_layer := CanvasLayer.new()
	fade_layer.layer = 15  # above the world and filter, below the UI so dialogue stays readable on black
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
		elif arg.begins_with("--flags="):
			# dev: ?flags=scene1_done,warroom1_done sets story flags before the map loads
			for f in arg.trim_prefix("--flags=").split(","):
				if not f.is_empty():
					Game.set_flag(f)
		elif arg.begins_with("--conn="):
			Game.connection = float(arg.trim_prefix("--conn="))
		elif arg.begins_with("--hour="):
			# dev: ?hour=22 starts the clock there (night is 20..5)
			Game.hour = int(arg.trim_prefix("--hour="))
		elif arg.begins_with("--map=") and not arg.ends_with("Apartment"):
			Game.set_flag("opening_seen")
	_start_tile = start_tile
	for arg in args:
		if arg.begins_with("--shot="):
			_shot_path = arg.trim_prefix("--shot=")
	if not skip_title:
		await _title_screen()
		if not _menu_jump.is_empty():
			first = _menu_jump
	await load_map(first)
	if "--autoplay" in OS.get_cmdline_user_args():
		var auto: Node = load("res://tools/autoplay.gd").new()
		add_child(auto)


func load_map(path: String) -> void:
	closeup.hide_view()
	if map:
		map.queue_free()
		await map.tree_exited
	map = load(path).instantiate()
	map.main = self
	Game.current_map = String(map.name)
	if String(map.name) in World.STREETS:
		Game.advance_time(1)
	add_child(map)
	move_child(map, 0)
	set_ambient(map.ambient)
	player = map.get_node_or_null("Actors/Player")
	if player and _start_tile.x >= 0:
		player.position = Vector2(_start_tile * 32) + Vector2(16, 28)
		_start_tile = Vector2i(-1, -1)
	for node in get_tree().get_nodes_in_group("interactable"):
		if node.is_inside_tree() and map.is_ancestor_of(node):
			node.interacted.connect(map._route_interact)
	if player:
		var cam: Camera2D = player.get_node("Camera2D")
		cam.limit_left = 0
		cam.limit_top = 0
		cam.limit_right = map.map_size.x
		cam.limit_bottom = map.map_size.y
		cam.reset_smoothing()
	await fade_in()
	map.start()
	if String(map.name) in World.STREETS and not Game.has_flag("keys_hinted"):
		Game.set_flag("keys_hinted")
		_show_toast("Tab: city map  ·  L: case file  ·  F: scan  ·  G: frames  ·  M: scenes")
	if not _shot_path.is_empty():
		# dev: --shot=path.png saves a frame of this map and quits; --scan=id shows that thing's card first
		await get_tree().create_timer(5.0).timeout
		for arg in OS.get_cmdline_user_args():
			if arg.begins_with("--scan="):
				dialogue.close()
				Game.input_locked = false
				map.scan(map.interactable(arg.trim_prefix("--scan=")))
				await get_tree().create_timer(1.0).timeout
			elif arg.begins_with("--iface="):
				# --iface=kind[,id] opens that interface puzzle for the shot
				var parts := arg.trim_prefix("--iface=").split(",")
				var pid: String = parts[1] if parts.size() > 1 else "generic"
				dialogue.close()
				var pz: Array = Game.puzzle_for(pid, "VOLTX FILTRATION UNIT 7")
				iface.run(parts[0], pz[1])
				await get_tree().create_timer(1.6).timeout
			elif arg.begins_with("--cutscene="):
				# --cutscene=opening,1 shows that panel of that scene for the shot
				var cp := arg.trim_prefix("--cutscene=").split(",")
				var idx: int = int(cp[1]) if cp.size() > 1 else 0
				dialogue.close()
				cutscene.play([CutScene.PANELS[cp[0]][idx]], true)
				await get_tree().create_timer(2.5).timeout
			elif arg == "--dream":
				dialogue.close()
				dream()
				await get_tree().create_timer(2.5).timeout
			elif arg == "--citymap":
				city_map.open()
				await get_tree().create_timer(0.3).timeout
			elif arg == "--board":
				_log_panel.show()
				_refresh_board()
				await get_tree().create_timer(0.3).timeout
			elif arg == "--endfile":
				dialogue.close()
				ending.show_file()
				await get_tree().create_timer(0.3).timeout
		get_viewport().get_texture().get_image().save_png(_shot_path)
		get_tree().quit()


## Sleep. A Hypnogogue dream: a painted panel, a voice, and the one choice it
## always offers. Past connection 50 Carl no longer gets the choice.
const DREAMS := [
	{"image": "dream_desk", "move": "zoom", "lines": [
		"The woods near my parents' house. Pine and damp earth. Among the trees: Mr. Dufredy's desk, pristine, unblemished by rot or dust.",
		"The eye symbol carved into its surface, pulsing faintly. A breeze whispered something I almost heard."],
		"voice": "You know the song. You have always known it."},
	{"image": "dream_chamber", "move": "still", "lines": [
		"A chamber, hexagonal, warm. Five floating figures, slightly blurred, like they hadn't fully resolved. A robed philosopher. A chrome-skinned child. A librarian with eyes made of stars.",
		"The librarian opened her mouth, and it was Mira's voice that came out."],
		"voice": "Daddy. It's warm in here. Come and see."},
	{"image": "dream_door", "move": "pan", "lines": [
		"The flats at dawn. The door in the cliff, the eye scorched into it. A small figure in a pale yellow top standing at it with her back to me.",
		"She didn't turn around. She didn't have to. I knew the curls. I knew the song she was humming."],
		"voice": "The path is long. Walk it with her, or walk it alone."},
]


func dream() -> void:
	var d: Dictionary = DREAMS[Game.dreams % DREAMS.size()]
	Game.dreams += 1
	await fade_out(1.0)
	await cutscene.play([d], true)
	_fade.modulate.a = 0.0
	await dialogue.say("???", String(d["voice"]), "psyon")
	var pick := 0
	if Game.connection >= 50.0:
		await dialogue.think("I bowed. I don't remember deciding to.")
	else:
		pick = await dialogue.choose(["Bow.", "Wake up."])
	dialogue.close()
	if pick == 0:
		Game.bowed += 1
		Game.add_connection(3.0, "bowed in a dream")
		var line := Game.find_glyph("dream:%d" % Game.dreams)
		await dialogue.say("", "I knelt in the dream, and the song finished a line I hadn't known. " + ("\"" + line + "\"" if not line.is_empty() else ""))
	else:
		Game.add_connection(1.0, "woke from a dream")
		await dialogue.say("", "I woke with my jaw clenched and the four notes still in my teeth. It would be there again tomorrow. It was patient.")
	dialogue.close()
	await cutscene.finish()
	Game.sleep()
	Game.check_stance()
	Game.log_entry("Day %d. Slept. Dreamed." % Game.day)


func _on_time(d: int, h: int) -> void:
	if h == 7:
		_show_toast("Day %d." % d)
	elif h == 20:
		_show_toast("Night. The streets change; the vigil gathers; the car will take you to sleep.")


func set_ambient(c: Color) -> void:
	_modulate.color = c


## The title screen: the tower, the name, press Enter.
func _title_screen() -> void:
	Game.input_locked = true
	var layer := CanvasLayer.new()
	layer.layer = 12
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
	prompt.text = "press Enter   ·   in game: Tab city map, L case file, M scenes"
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
	_menu_jump = ""
	_on_title = true
	while true:
		await get_tree().process_frame
		if _menu.visible:
			continue
		if not _menu_jump.is_empty():
			break
		if Input.is_action_just_pressed("interact"):
			break
		if Input.is_action_just_pressed("scene_menu"):
			_menu.open()
	_on_title = false
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


const THRESHOLD_LINES := {
	25: "The frames know your face now. Deeper glyphs resolve.",
	50: "ORA is not the only thing recording. The city whispers back.",
	75: "Something has to break first.",
}


func _on_threshold(level: int) -> void:
	await filter.flash(0.12)
	_show_toast("Connection %d  ·  %s" % [level, THRESHOLD_LINES[level]])
	if level >= 50:
		filter.set_hud_text("ORA  ·  recording  ·  gather, sleeper")


func _on_log(entry: String) -> void:
	_show_toast("Case log: " + entry)
	if _log_panel.visible:
		_refresh_board()


## The deduction board: three theories, how much of the log backs each, the
## evidence bagged, then the log itself.
func _refresh_board() -> void:
	var t := ""
	t += "[color=8fa0a8]%s[/color]\n" % Game.clock_text()
	var st := Game.stance()
	if st.is_empty():
		t += "[color=f5d6a0]STANCE[/color]   undecided. The file will decide from what you do.\n"
	else:
		t += "[color=f5d6a0]STANCE[/color]   [color=7fe0c0]%s[/color]  \"%s\"\n" % [Game.STANCES[st][0], Game.STANCES[st][1]]
	t += "[color=f5d6a0]THEORIES[/color]   pin one; Turan hears the pinned one\n"
	var i := 1
	for id in Game.THEORIES:
		var th: Dictionary = Game.THEORIES[id]
		var have: int = Game.theory_progress(id)
		var total: int = th["clues"].size()
		var bar := ""
		for k in total:
			bar += "#" if k < have else "-"
		var pin := "> " if Game.theory == id else "  "
		var col := "7fe0c0" if Game.theory == id else "e8ecef"
		t += "[color=%s]%s%d. %-32s %s %d/%d[/color]\n" % [col, pin, i, th["name"], bar, have, total]
		i += 1
	t += "\n[color=f5d6a0]INCIDENTS[/color]  %d of %d closed" % [Game.incidents_closed(), Game.INCIDENTS.size()]
	for id in Game.incidents:
		var state: String = Game.incidents[id]
		var col := "f5d6a0" if state == "open" else "8fa0a8"
		t += "\n  [color=%s]%s  %s  (%s)[/color]" % [col, "!" if state == "open" else "x", Game.INCIDENTS[id]["title"], World.place(Game.INCIDENTS[id]["map"]).get_slice(",", 0) if state == "open" else state]
	t += "\n[color=f5d6a0]CASES[/color]  %d of %d closed" % [Game.cases_closed(), Game.CASES.size()]
	if Game.cases.is_empty():
		t += "\n  nothing on the side yet"
	for id in Game.cases:
		var cs: Dictionary = Game.CASES[id]
		var state: String = Game.cases[id]
		if state != "open":
			t += "\n  [color=8fa0a8]x  %s  (%s)[/color]" % [cs["title"], state]
			continue
		var step: int = Game.case_step(id)
		t += "\n  [color=f5d6a0]!  %s  ·  %s[/color]" % [cs["title"], cs["subtitle"]]
		var steps: Array = cs["steps"]
		for k in steps.size():
			var mark := "x" if k < step or step == -1 else (">" if k == step else "-")
			var col := "8fa0a8" if mark == "x" else ("7fe0c0" if mark == ">" else "5a6b70")
			t += "\n     [color=%s]%s %s[/color]" % [col, mark, steps[k][1] if mark != "-" else "..."]
	t += "\n[color=f5d6a0]EVIDENCE[/color]  " + (", ".join(Game.evidence) if Game.evidence.size() else "nothing bagged yet")
	t += "\n[color=f5d6a0]GLYPHS[/color]  %d found  ·  connection %d  ·  company pressure %d\n" % [Game.glyphs_found.size(), int(Game.connection), Game.pressure]
	t += "\n[color=f5d6a0]LOG[/color]\n"
	for entry in Game.case_log:
		t += "\u00b7 " + entry + "\n"
	_log_text.text = t


## A line on the ORA feed under the objective. Urgent ones hold longer.
func _show_feed(text: String, urgent := false) -> void:
	if not Game.glasses_on and not urgent:
		return
	_feed.text = "ORA > " + text
	_feed.modulate.a = 1.0
	var t := create_tween()
	t.tween_interval(4.5 if urgent else 3.2)
	t.tween_property(_feed, "modulate:a", 0.0, 0.8)


func _build_scan_panel() -> void:
	_scan_panel = PanelContainer.new()
	_scan_panel.position = Vector2(170, 44)
	_scan_panel.custom_minimum_size = Vector2(300, 0)
	var style := StyleBoxFlat.new()
	style.bg_color = Color("06100e", 0.92)
	style.border_color = Color("7fe0c0", 0.9)
	style.set_border_width_all(1)
	style.set_content_margin_all(6)
	_scan_panel.add_theme_stylebox_override("panel", style)
	_scan_text = RichTextLabel.new()
	_scan_text.bbcode_enabled = true
	_scan_text.fit_content = true
	_scan_text.scroll_active = false
	_scan_text.custom_minimum_size = Vector2(288, 0)
	_scan_text.add_theme_font_size_override("normal_font_size", 8)
	_scan_text.add_theme_font_size_override("bold_font_size", 8)
	_scan_text.add_theme_color_override("default_color", Color("d8f3ea"))
	_scan_panel.add_child(_scan_text)
	_scan_panel.hide()
	_ui.add_child(_scan_panel)


## The ORA identification card: what the frames make of whatever Carl faces.
func show_scan(title: String, body: String, bad := false) -> void:
	var col := "e0453a" if bad else "7fe0c0"
	# the card's font has no middle dot, so cards use a dash
	_scan_text.text = "[color=%s]ORA ID  -  %s[/color]\n%s" % [col, title.replace("\u00b7", "-"), body.replace("\u00b7", "-")]
	_scan_panel.modulate.a = 1.0
	_scan_panel.show()
	_scan_timer = 3.6


func hide_scan() -> void:
	_scan_panel.hide()
	_scan_timer = 0.0


func _process(delta: float) -> void:
	if _scan_timer > 0.0:
		_scan_timer -= delta
		if _scan_timer <= 0.0:
			var t := create_tween()
			t.tween_property(_scan_panel, "modulate:a", 0.0, 0.4)
			t.tween_callback(_scan_panel.hide)
	# the feed only runs while Carl is out on a street with nothing else up
	if map is StreetScene and not Game.input_locked and not dialogue.visible and not psyon.visible:
		_feed_timer -= delta
		if _feed_timer <= 0.0:
			_feed_timer = randf_range(16.0, 30.0)
			var line: String = map.feed_line()
			if not line.is_empty():
				_show_feed(line)


func _show_toast(text: String) -> void:
	_toast.text = text
	_toast.modulate.a = 1.0
	var t := create_tween()
	t.tween_interval(2.2)
	t.tween_property(_toast, "modulate:a", 0.0, 0.6)


func _build_log_panel() -> void:
	_log_panel = PanelContainer.new()
	_log_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	_log_panel.offset_left = -175
	_log_panel.offset_right = 175
	_log_panel.offset_top = -105
	_log_panel.offset_bottom = 105
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
	h.text = "CASE FILE  ·  Dufredy, H.  ·  1/2/3 pins a theory  ·  L closes"
	h.add_theme_font_size_override("font_size", 9)
	h.add_theme_color_override("font_color", Color("f5d6a0"))
	col.add_child(h)
	_log_text = RichTextLabel.new()
	_log_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_log_text.add_theme_font_size_override("normal_font_size", 9)
	_log_text.add_theme_font_size_override("bold_font_size", 9)
	_log_text.bbcode_enabled = true
	_log_text.scroll_following = false
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


## A pick on the scene menu. Maps load with their door open and every incident
## live; close-ups just show the painting until Esc.
func _on_menu_jump(kind: String, target: String) -> void:
	if kind == "cutscene":
		if _on_title:
			return
		if target == "dream":
			dream()
		else:
			cutscene.play(target)
		return
	if kind == "closeup":
		_menu_closeup = true
		Game.input_locked = true
		closeup.show_view(target.replace("_", " "), "res://assets/closeups/" + target + ".png")
		return
	Game.set_glasses(true)
	if target in World.EXITS and not target in World.STREETS:
		Game.next_beat = target
	for id in Game.INCIDENTS:
		if not id in Game.incidents:
			Game.incidents[id] = "open"
	_start_tile = Vector2i(-1, -1)
	var path := "res://scenes/maps/" + target + ".tscn"
	if map == null or _on_title:
		_menu_jump = path
		return
	await change_map(path)


func _unhandled_input(event: InputEvent) -> void:
	if _menu_closeup and (event.is_action_pressed("cancel") or event.is_action_pressed("interact")):
		_menu_closeup = false
		closeup.hide_view()
		Game.input_locked = false
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("city_map") and not city_map.visible and not _menu.visible and not dialogue.visible and not psyon.visible and not closeup.visible and not iface.visible and not cutscene.visible and map:
		if _log_panel.visible:
			_log_panel.hide()
		city_map.open()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("scene_menu") and not _menu.visible and not dialogue.visible and not psyon.visible and not closeup.visible and not iface.visible and not city_map.visible and not cutscene.visible and not cutscene.visible:
		if _log_panel.visible:
			_log_panel.hide()
		_menu.open()
	elif event.is_action_pressed("case_log") and not dialogue.visible and not psyon.visible and not closeup.visible and not iface.visible and not city_map.visible and not cutscene.visible:
		_log_panel.visible = not _log_panel.visible
		Game.input_locked = _log_panel.visible
		if _log_panel.visible:
			_refresh_board()
	elif event.is_action_pressed("scan") and map and not Game.input_locked and not dialogue.visible and not psyon.visible and not closeup.visible and not iface.visible and not city_map.visible and not cutscene.visible and not _log_panel.visible:
		var target: Node = player.nearest_interactable()
		map.scan(target)
	elif _log_panel.visible and event is InputEventKey and event.pressed and not event.echo:
		var keys := {KEY_1: "drugs", KEY_2: "hacker", KEY_3: "beneath"}
		if event.keycode in keys:
			Game.set_theory(keys[event.keycode])
			_refresh_board()
