extends Control
class_name EndingScreen
## The one-screen case file at the end of the act: what the file says Carl
## is, what he pinned, what he reported and buried, who he protected.
## E or Esc closes it.

signal closed

var _panel: PanelContainer
var _text: RichTextLabel


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var bg := ColorRect.new()
	bg.color = Color("050608", 0.92)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)
	_panel = PanelContainer.new()
	_panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	_panel.offset_left = -200
	_panel.offset_right = 200
	_panel.offset_top = -120
	_panel.offset_bottom = 120
	var style := StyleBoxTexture.new()
	style.texture = load("res://assets/ui/panel.png")
	for side in ["left", "right", "top", "bottom"]:
		style.set("texture_margin_" + side, 6)
		style.set("content_margin_" + side, 10)
	_panel.add_theme_stylebox_override("panel", style)
	add_child(_panel)
	_text = RichTextLabel.new()
	_text.bbcode_enabled = true
	_text.add_theme_font_size_override("normal_font_size", 9)
	_text.add_theme_font_size_override("bold_font_size", 9)
	_text.scroll_following = false
	_panel.add_child(_text)
	_fit()
	get_viewport().size_changed.connect(_fit)
	hide()


func _fit() -> void:
	var s: Vector2 = get_viewport().get_visible_rect().size
	position = Vector2.ZERO
	size = s
	_panel.position = (s - Vector2(400, 240)) / 2.0
	_panel.size = Vector2(400, 240)


## Shows the file and waits for E or Esc.
func show_file() -> void:
	_text.text = build_text()
	Game.input_locked = true
	show()
	await closed


func close() -> void:
	if not visible:
		return
	hide()
	Game.input_locked = false
	closed.emit()


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept") or event.is_action_pressed("cancel"):
		get_viewport().set_input_as_handled()
		close()


static func build_text() -> String:
	var t := "[color=f5d6a0]CASE FILE  ·  DRAKE, C.  ·  end of Act 1[/color]\n"
	t += "[color=8fa0a8]%s  ·  connection %d  ·  company pressure %d[/color]\n\n" % [Game.clock_text(), int(Game.connection), Game.pressure]
	var st := Game.stance()
	if st.is_empty():
		t += "[color=f5d6a0]THE FILE SAYS[/color]   nothing yet. Undecided.\n"
	else:
		t += "[color=f5d6a0]THE FILE SAYS[/color]   [color=7fe0c0]%s[/color]  \"%s\"\n" % [Game.STANCES[st][0], Game.STANCES[st][1]]
	var th := "none pinned"
	if not Game.theory.is_empty():
		th = String(Game.THEORIES[Game.theory]["name"])
	t += "[color=f5d6a0]THEORY[/color]   %s\n" % th
	var counts := {"reported": 0, "buried": 0, "ran": 0, "fixed": 0}
	for id in Game.incidents:
		var o: String = Game.incidents[id]
		if o in counts:
			counts[o] += 1
	t += "[color=f5d6a0]INCIDENTS[/color]   %d reported, %d buried, %d let run, %d fixed\n" % [counts["reported"], counts["buried"], counts["ran"], counts["fixed"]]
	t += "[color=f5d6a0]CASES[/color]"
	var any := false
	for id in Game.cases:
		if Game.cases[id] != "open":
			t += "   %s: %s" % [Game.CASES[id]["title"], Game.cases[id]]
			any = true
	if not any:
		t += "   none closed"
	t += "\n[color=f5d6a0]PROTECTED[/color]   "
	var who := []
	if Game.has_flag("called_monica"): who.append("Monica (called her first)")
	if Game.cases.get("dorner", "") == "walked": who.append("Dorner (walked him home)")
	if Game.cases.get("dorner", "") == "covered": who.append("Dorner (covered for him)")
	if Game.cases.get("nathan", "") == "kept": who.append("Lynx (kept Nathan from her)")
	if Game.cases.get("nathan", "") == "told": who.append("Lynx (told her the truth)")
	if Game.has_flag("refused_turan"): who.append("himself (refused Turan once)")
	if Game.has_flag("hesitated_at_door"): who.append("himself (frames off at the door)")
	if Game.has_flag("rr_mimic_refused"): who.append("himself (tore the frames off at the mimic)")
	t += ", ".join(who) if not who.is_empty() else "nobody. The brand."
	t += "\n[color=f5d6a0]GIVEN[/color]   "
	var gave := []
	if Game.has_flag("gave_frames"): gave.append("his frames to the preacher")
	if Game.bowed > 0: gave.append("%d bow%s in dreams" % [Game.bowed, "" if Game.bowed == 1 else "s"])
	if Game.interfaces.size() > 0: gave.append("%d machines interfaced" % Game.interfaces.size())
	if Game.has_flag("told_turan_name"): gave.append("Mira's name to Turan")
	t += ", ".join(gave) if not gave.is_empty() else "nothing it asked for"
	t += "\n[color=f5d6a0]GLYPHS[/color]   %d found  ·  %d days in Silico\n" % [Game.glyphs_found.size(), Game.day]
	t += "\n[color=8fa0a8]E closes. L reopens the full log.[/color]"
	return t
