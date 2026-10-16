extends CanvasLayer
class_name SceneMenu
## The playtest menu: jump to any map or close-up. M opens it anywhere,
## including the title screen. Arrows move, Enter jumps, Esc closes.

signal jump(kind: String, target: String)

const COLUMNS := [
	["PLOT BEATS", [
		["Apartment", "map", "Apartment"], ["Harmony Green (park)", "map", "Park"], ["War room", "map", "WarRoom"],
		["Home", "map", "Home"], ["SalTech ward", "map", "Hospital"], ["Southtown", "map", "Southtown"],
		["Lynx's flat", "map", "LynxApartment"], ["The sand flats", "map", "Desert"], ["The mirror", "map", "Mirror"],
		["Act 2: the facility", "map", "LabHall"], ["Sublevel 1", "map", "LabOffice"], ["Sublevel Two", "map", "LabPens"], ["The hangar", "map", "Hangar"]]],
	["DISTRICTS", [
		["Lamplight", "map", "Lamplight"], ["The Spine", "map", "Spine"], ["Zeta & Park", "map", "ZetaPark"],
		["The Heights", "map", "Heights"], ["Cognizo Quarter", "map", "Cognizo"], ["Cognizo station", "map", "CognizoStation"],
		["The factory", "map", "Factory"], ["Dorner's flat", "map", "DornerFlat"], ["Fargona Avenue", "map", "Fargona"],
		["Red Rock Plaza", "map", "RedRock"], ["The casino", "map", "Casino"], ["Lushon Tavern", "map", "Lushon"], ["The arcade", "map", "Arcade"]]],
	["ROADS", [
		["Canal Walk", "map", "CanalWalk"], ["Underpass", "map", "Underpass"], ["Flyover", "map", "Flyover"],
		["Hill Road", "map", "HillRoad"], ["Rail Cut", "map", "RailCut"], ["Park Avenue", "map", "ParkAve"],
		["Restricted Road", "map", "RestrictedRoad"]]],
	["CLOSE-UPS, CUT SCENES", [
		["Dufredy's desk", "closeup", "apartment_desk"], ["The bedroom floor", "closeup", "apartment_eyes"],
		["The ceiling", "closeup", "apartment_ceiling"], ["Mira's room", "closeup", "home_ritual"],
		["Room 108", "closeup", "hospital_dufredy"], ["Lynx's bed", "closeup", "lynx_laptop"],
		["The door", "closeup", "desert_door"], ["The mirror", "closeup", "mirror"],
		["Cut scene: the opening", "cutscene", "opening"], ["Cut scene: the outage", "cutscene", "outage"], ["Cut scene: a dream", "cutscene", "dream"],
		["Cut scene: the tower", "cutscene", "tower"], ["Cut scene: the drive", "cutscene", "drive"], ["Cut scene: leaving the vigil", "cutscene", "vigil"],
		["Ending: company man", "cutscene", "ending_company"], ["Ending: investigator", "cutscene", "ending_investigator"], ["Ending: sleeper", "cutscene", "ending_sleeper"],
		["Cut scene: the altar", "cutscene", "altar"], ["Cut scene: the ritual", "cutscene", "ritual_all"], ["Cut scene: Subject 41", "cutscene", "s41"], ["Cut scene: the escape", "cutscene", "escape"]]],
]

var _root: Control
var _labels: Array = []
var _col := 0
var _row := 0


func _ready() -> void:
	layer = 30
	_root = Control.new()
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_root)
	var bg := ColorRect.new()
	bg.color = Color("050608", 0.9)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.add_child(bg)
	var title := Label.new()
	title.text = "SCENE SELECT   -   arrows move, Enter jumps, Esc closes.  Jumping opens that place's door and every incident."
	title.position = Vector2(16, 10)
	title.add_theme_font_size_override("font_size", 8)
	title.add_theme_color_override("font_color", Color("f5d6a0"))
	_root.add_child(title)
	for i in COLUMNS.size():
		var l := RichTextLabel.new()
		l.bbcode_enabled = true
		l.scroll_active = false
		l.position = Vector2(16 + i * 156, 32)
		l.size = Vector2(152, 300)
		l.add_theme_font_size_override("normal_font_size", 8)
		l.add_theme_color_override("default_color", Color("d8f3ea"))
		_root.add_child(l)
		_labels.append(l)
	_fit()
	get_viewport().size_changed.connect(_fit)
	hide()


func _fit() -> void:
	_root.position = Vector2.ZERO
	_root.size = get_viewport().get_visible_rect().size


func open() -> void:
	Game.input_locked = true
	_refresh()
	show()


func close() -> void:
	hide()
	Game.input_locked = false


func _refresh() -> void:
	for i in COLUMNS.size():
		var t: String = "[color=7fe0c0]" + String(COLUMNS[i][0]) + "[/color]\n"
		var entries: Array = COLUMNS[i][1]
		for j in entries.size():
			var here := i == _col and j == _row
			t += ("[color=f5d6a0]> %s[/color]\n" % entries[j][0]) if here else ("  %s\n" % entries[j][0])
		_labels[i].text = t


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	var entries: Array = COLUMNS[_col][1]
	if event.is_action_pressed("cancel") or event.is_action_pressed("scene_menu"):
		close()
	elif event.is_action_pressed("move_down"):
		_row = (_row + 1) % entries.size()
	elif event.is_action_pressed("move_up"):
		_row = (_row - 1 + entries.size()) % entries.size()
	elif event.is_action_pressed("move_right"):
		_col = (_col + 1) % COLUMNS.size()
		_row = mini(_row, COLUMNS[_col][1].size() - 1)
	elif event.is_action_pressed("move_left"):
		_col = (_col - 1 + COLUMNS.size()) % COLUMNS.size()
		_row = mini(_row, COLUMNS[_col][1].size() - 1)
	elif event.is_action_pressed("interact"):
		var e: Array = entries[_row]
		close()
		get_viewport().set_input_as_handled()
		jump.emit(e[1], e[2])
		return
	else:
		return
	get_viewport().set_input_as_handled()
	_refresh()
