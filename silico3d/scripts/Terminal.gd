extends Control
## A Psyon terminal (bible-1 "Psyon chat"; bible-3 "Carl's Tower", "Trades",
## "Sacrifice"): the home terminal in 86D and the city kiosks. Corporate
## Psyon has the Psyonic-green header; past 25 Connection the fork answers
## instead, raw monospace in magenta with no header. Choices go through the
## dialogue box (ui.choose), the screen shows the conversation.
##
## - Carl's Tower (home terminal, from Day 4): rooms built with devotion,
##   Focus 3 / Calm 4 / Memory 4 / Courage 5, appended to main.tower_rooms.
##   The first room is +3 Connection and the fork's line.
## - Trades (any terminal): every quick-hack word after hush and look away
##   costs Connection and a memory (drawing, photo, lion, trophy). The memory
##   goes into main.traded, is gone from 86D (flags traded_<id>) and its
##   ledger lines are blanked.
## - Sacrifice (any terminal, after Lushon's): everyone Carl has investigated,
##   by name and value, into main.given.

const GREEN := "#3fe08a"
const CYAN := "#5fe8ff"
const MAGENTA := "#ff4fd8"
const DIM := "#5a7a6a"

const LINES := {
	"head_home": "PSYON  //  PSYONIC HOME  //  86D  //  DRAKE, C.",
	"head_kiosk": "PSYON  //  CITY TERMINAL  //  services: TRANSIT, BILLS, FREUDBOT",
	"hello": "Good %s, Carl. How can I help?",
	"hello_fork": "You came back to us.",
	"time": ["morning", "afternoon", "evening"],
	"you": "you",
	"psyon": "Psyon",
	"menu": {
		"tower": "Carl's Tower",
		"trade": "Words  (the fork has an offer)",
		"give": "Someone you know",
		"logoff": "Log off",
		"back": "Back",
	},
	"carl": {
		"tower": "Show me the tower.",
		"trade": "What do you want for it?",
		"give": "Who?",
	},
	"tower": {
		"intro": "(game) Mira built hers out of what she loved. Build yours. Every room is a thing you give us.",
		"intro_corp": "(game) Psyon Junior's Tower, adult edition. Build rooms with your devotion.",
		"devotion": "devotion: %d",
		"row": "  FLOOR %d   %-8s %s",
		"built": "[built]",
		"cost": "%d devotion",
		"empty": "  (a bare landing)",
		"build": "Build %s   (%d devotion)",
		"short": "%s   (%d devotion; you have %d)",
		"not_enough": "(game) Not enough. Give us more and come back.",
		"first": "Good. A home for us.",
		"more": "(game) Another room. We will live in this one too.",
		"log": "Carl's Tower: built %s (floor %d).",
		"toast": "Carl's Tower   %s",
		"none_left": "(game) It is finished. It was always going to be finished.",
		"not_yet": "(game) Not yet. The tower opens on the fourth day.",
	},
	# the rooms: name, cost, what it is (Chair.gd's ROOMS, for the climb), and what it does on the street
	"rooms": {
		"focus": ["FOCUS", 3, "A desk, a lamp, every paper squared to the edge. The council floated over it, waiting for a question.", "(game) The frames read further: scans reach half again as far."],
		"calm": ["CALM", 4, "Still water in a stone ring. Nothing moved on it. The council floated over it like breath held.", "(game) Sleep costs the company less of you: a night is +2 pressure, not +3. On the street the frames take you slower."],
		"memory": ["MEMORY", 4, "Frames on every wall. Some of them empty, the hooks still there.", "(game) What you gave stays hung up here, where you can visit it: a door at the end of the hall at home. The frames replay the last things you were told."],
		"courage": ["COURAGE", 5, "A plinth with a knife on it, and a fire that gave no heat. The council stood back from it.", "(game) A fire that gives no heat. You will need it at the end. Your hands stay steadier when it comes to blows."],
	},
	"trade": {
		"none": "(game) Nothing you know that we haven't already given you.",
		"offer": "(game) %s. You know the word. We can put it in your hands. It costs a little more of you, and one thing from home.",
		"word": "%s   (%d Connection + a memory)",
		"locked": "%s   (needs Connection %d)",
		"pick": "(game) Which one?",
		"refuse": "Keep them all.",
		"refused": "(game) Then the word stays a word. We'll ask again.",
		"no_memories": "(game) There is nothing left in the flat we want.",
		"done": "(game) Done. Go home and look for it. You won't find it.",
		"log": "Traded %s for the word %s.",
		"toast": "Quick-hack: %s",
		"blank": "████████",
	},
	"words": {
		"convene": ["convene", 2, 0, "Pulls everyone in earshot toward a chosen device."],
		"sleeper": ["sleeper", 2, 0, "Drops a drone or freezes a FreudBot."],
		"dreamer": ["dreamer", 2, 0, "Opens a locked cult door."],
		"we": ["we", 2, 0, "A guard's frames read you as one of them, 10 seconds."],
		"mimic": ["mimic", 5, 60, "Projects the eye; cultists in range bow, 8 seconds."],
	},
	"memories": {
		"drawing": "Mira's drawing on the fridge",
		"photo": "The Red Rock photo",
		"lion": "The toy lion",
		"trophy": "Ezra's recess trophy",
	},
	# words in the ledger that belong to a memory, blanked when it is traded
	# (narrow on purpose: "photo" alone would take Hameron's framed photograph,
	# "sketch" the sketchbook evidence, "lion" every million)
	"memory_keys": {"drawing": ["drawing on the fridge", "mira's drawing"], "photo": ["red rock photo"], "lion": ["toy lion"], "trophy": ["recess trophy", "ezra's trophy"]},
	"give": {
		"intro": "(game) There are others who would come home with you. Name one and they come.",
		"intro_corp": "(game) Psyon cannot help with that request.",
		"row": "%s   (%d)",
		"nobody": "No one.",
		"ask": "Give %s?",
		"yes": "Give them.",
		"no": "Not them.",
		"none": "(game) You haven't looked at anyone long enough for us to want them.",
		"given": "(game) Thank you, Carl. They're home.",
		"tyson": "(game) He would have shown you the way out. There is no way out now.",
		"log": "Gave %s to the god (value %d).",
		"toast": "Given   %s",
	},
	"dream": "You dreamed of %s. We were there.",
	"bye": "(game) Logged off. The screen kept its light on a little longer than it needed to.",
}

var main: Node
var city: Node
var panel: PanelContainer
var head_l: Label
var log_l: RichTextLabel
var _mono: SystemFont
var _open := false


func setup(m: Node, c: Node) -> void:
	main = m
	city = c
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_mono = SystemFont.new()
	_mono.font_names = PackedStringArray(["DejaVu Sans Mono", "Liberation Mono", "Monospace", "Courier New"])
	panel = PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.0, 0.01, 0.005, 0.97)
	sb.border_color = Color(0.25, 0.9, 0.55, 0.8)
	sb.set_border_width_all(2)
	sb.set_content_margin_all(18)
	panel.add_theme_stylebox_override("panel", sb)
	add_child(panel)
	var vb := VBoxContainer.new()
	panel.add_child(vb)
	head_l = Label.new()
	head_l.add_theme_font_override("font", _mono)
	head_l.add_theme_font_size_override("font_size", 15)
	head_l.add_theme_color_override("font_color", Color(0.25, 0.88, 0.54))
	vb.add_child(head_l)
	log_l = RichTextLabel.new()
	log_l.bbcode_enabled = true
	log_l.scroll_following = true
	log_l.size_flags_vertical = Control.SIZE_EXPAND_FILL
	log_l.add_theme_font_override("normal_font", _mono)
	log_l.add_theme_font_override("bold_font", _mono)
	log_l.add_theme_font_size_override("normal_font_size", 17)
	log_l.add_theme_font_size_override("bold_font_size", 17)
	log_l.add_theme_color_override("default_color", Color(0.25, 0.88, 0.54))
	vb.add_child(log_l)
	visible = false
	get_viewport().size_changed.connect(_fit)
	_fit()


func _fit() -> void:
	var s := get_viewport().get_visible_rect().size
	size = s
	var w := minf(860.0, s.x - 60.0)
	# below the frames readout (connection stays visible: words cost connection)
	panel.position = Vector2((s.x - w) / 2.0, 58)
	panel.size = Vector2(w, s.y - 304.0)
	panel.custom_minimum_size = Vector2(w, s.y - 304.0)


func _fork() -> bool:
	return main.connection >= 25.0


func _show(where: String) -> void:
	visible = true
	_open = true
	log_l.text = ""
	head_l.visible = not _fork()
	head_l.text = LINES["head_home"] if where == "home" else LINES["head_kiosk"]


func _hide() -> void:
	visible = false
	_open = false


## A line on the screen, typed out. Psyon green, the fork magenta, Carl cyan.
func line(text: String, who := "psyon") -> void:
	var col := CYAN if who == "carl" else (MAGENTA if _fork() else GREEN)
	var tag := "" if who == "raw" else ("%s> " % LINES["you"] if who == "carl" else ("" if _fork() else "%s: " % LINES["psyon"]))
	if who == "raw":
		col = GREEN if not _fork() else "#c8a0ff"
	var start := log_l.get_total_character_count()
	log_l.append_text("[color=%s]%s%s[/color]\n\n" % [col, tag, text])
	log_l.visible_characters = start
	var tw := create_tween()
	tw.tween_property(log_l, "visible_characters", log_l.get_total_character_count(), clampf(text.length() * 0.02, 0.2, 1.6))
	await tw.finished
	log_l.visible_characters = -1


func _time_word() -> String:
	var h := int(main.hour) % 24
	var t: Array = LINES["time"]
	return str(t[0] if h < 12 else (t[1] if h < 18 else t[2]))


## The terminal session: a menu until Carl logs off.
func run(where: String) -> void:
	var ui = main.ui
	_show(where)
	main.play("on", -10.0, 0.7)
	if _fork():
		main.play("glitch", -12.0, 0.8)
		await line(LINES["hello_fork"])
		if city.dream_line != "":
			await line(LINES["dream"] % city.dream_line)
	else:
		await line(LINES["hello"] % _time_word())
	# the menu loops; the bound keeps a headless run (always picking 1) finite
	for round_i in 8:
		var keys := []
		var opts := []
		var M: Dictionary = LINES["menu"]
		if where == "home":
			keys.append("tower")
			opts.append(M["tower"])
		if not offers().is_empty():
			keys.append("trade")
			opts.append(M["trade"])
		if main.flags.has("lushons_done"):
			keys.append("give")
			opts.append(M["give"])
		keys.append("logoff")
		opts.append(M["logoff"])
		var i: int = await ui.choose(opts)
		ui.close()
		match keys[i]:
			"tower":
				await line(LINES["carl"]["tower"], "carl")
				await tower_menu()
			"trade":
				await line(LINES["carl"]["trade"], "carl")
				await trade_menu()
			"give":
				await line(LINES["carl"]["give"], "carl")
				await give_menu()
			_:
				break
	await line(LINES["bye"], "raw")
	await get_tree().create_timer(0.4).timeout
	main.play("off", -10.0, 0.7)
	_hide()
	main.update_hud()


# ------------------------------------------------------------------ Carl's Tower

func tower_text() -> String:
	var T: Dictionary = LINES["tower"]
	var R: Dictionary = LINES["rooms"]
	var rows := ["[color=%s]%s[/color]" % [DIM, T["devotion"] % int(main.devotion)]]
	rows.append("        /\\")
	rows.append("       /  \\")
	var built: Array = main.tower_rooms
	for k in range(3, -1, -1):
		if k < built.size():
			var id: String = built[k]
			rows.append("[color=%s]%s[/color]" % [MAGENTA if _fork() else GREEN, T["row"] % [k + 1, R[id][0], T["built"]]])
		else:
			rows.append("[color=%s]%s[/color]" % [DIM, T["empty"]])
	rows.append("  ______|____|______")
	for id: String in R:
		if not built.has(id):
			rows.append("[color=%s]  %-8s %s[/color]" % [CYAN, R[id][0], T["cost"] % int(R[id][1])])
	return "\n".join(rows)


func tower_menu() -> void:
	var ui = main.ui
	var T: Dictionary = LINES["tower"]
	var R: Dictionary = LINES["rooms"]
	if int(main.day) < 4:
		await line(T["not_yet"])
		return
	await line(T["intro"] if _fork() else T["intro_corp"])
	log_l.append_text(tower_text() + "\n\n")
	var keys := []
	var opts := []
	for id: String in R:
		if main.tower_rooms.has(id):
			continue
		keys.append(id)
		var cost := int(R[id][1])
		if int(main.devotion) >= cost:
			opts.append(T["build"] % [R[id][0], cost])
		else:
			opts.append(T["short"] % [R[id][0], cost, int(main.devotion)])
	if keys.is_empty():
		await line(T["none_left"])
		return
	keys.append("back")
	opts.append(LINES["menu"]["back"])
	var i: int = await ui.choose(opts)
	ui.close()
	if keys[i] == "back":
		return
	await build_room(keys[i])


## Build one room: devotion spent, the room appended, +3 the first time.
func build_room(id: String) -> bool:
	var T: Dictionary = LINES["tower"]
	var R: Dictionary = LINES["rooms"]
	var cost := int(R[id][1])
	if main.tower_rooms.has(id):
		return false
	if int(main.devotion) < cost:
		await line(T["not_enough"])
		return false
	main.devotion = int(main.devotion) - cost
	main.tower_rooms.append(id)
	var first: bool = main.tower_rooms.size() == 1
	main.play("chant", -14.0, 1.4)
	if visible:
		log_l.append_text("[color=%s]%s\n%s[/color]\n\n" % [CYAN, R[id][2], R[id][3]])
	if first:
		await line(T["first"])
		main.add_connection(3.0, T["toast"] % R[id][0])
	else:
		await line(T["more"])
		main.ui.show_toast(T["toast"] % R[id][0], 2.5)
	main.log_line("tower", T["log"] % [R[id][0], main.tower_rooms.size()])
	if visible:
		log_l.append_text(tower_text() + "\n\n")
	return true


# ------------------------------------------------------------------ trades

## Words the fork will sell: known, quick-hack words after hush and look away
## that Carl does not hold yet.
func offers() -> Array:
	var out := []
	for w: String in LINES["words"]:
		if main.lexicon.has(w) and not main.hacks.has(w):
			out.append(w)
	return out


func memories_left() -> Array:
	var out := []
	for k: String in LINES["memories"]:
		if not main.traded.has(k):
			out.append(k)
	return out


func trade_menu() -> void:
	var ui = main.ui
	var TR: Dictionary = LINES["trade"]
	var W: Dictionary = LINES["words"]
	var ws := offers()
	if ws.is_empty():
		await line(TR["none"])
		return
	if memories_left().is_empty():
		await line(TR["no_memories"])
		return
	var opts := []
	for w: String in ws:
		var need := int(W[w][2])
		if main.connection < need:
			opts.append(TR["locked"] % [W[w][0], need])
		else:
			opts.append(TR["word"] % [W[w][0], int(W[w][1])])
	opts.append(LINES["menu"]["back"])
	var i: int = await ui.choose(opts)
	ui.close()
	if i >= ws.size():
		return
	var word: String = ws[i]
	if main.connection < int(W[word][2]):
		return
	await line(TR["offer"] % str(W[word][0]).capitalize())
	log_l.append_text("[color=%s]  %s[/color]\n\n" % [CYAN, W[word][3]])
	var mems := memories_left()
	var mo := []
	for k: String in mems:
		mo.append(LINES["memories"][k])
	mo.append(TR["refuse"])
	var j: int = await ui.choose(mo)
	ui.close()
	if j >= mems.size():
		await line(TR["refused"])
		return
	await trade(word, mems[j])


## The trade itself: the word's Connection, the memory gone from home and
## from the ledger, the word in Carl's hands.
func trade(word: String, mem: String) -> void:
	var TR: Dictionary = LINES["trade"]
	var W: Dictionary = LINES["words"]
	if main.traded.has(mem) or main.hacks.has(word):
		return
	main.traded.append(mem)
	main.flags["traded_" + mem] = true
	main.hacks.append(word)
	var keys: Array = LINES["memory_keys"][mem]
	for e in main.ledger:
		var t: String = str(e.get("text", "")).to_lower()
		for k: String in keys:
			if k in t:
				e["was"] = e["text"]      # the Memory room in Carl's Tower keeps it
				e["text"] = TR["blank"]
				break
	main.play("glitch", -6.0, 0.6)
	main.ui.glitch(0.7, 0.8)
	main.add_connection(float(int(W[word][1])), TR["toast"] % W[word][0])
	main.log_line("trade", TR["log"] % [LINES["memories"][mem], W[word][0]])
	if visible:
		await line(TR["done"])


# ------------------------------------------------------------------ sacrifice

## Everyone Carl has investigated who can be given, with their value
## (bible: 1 + interviews + scans + case steps, capped at 10).
func givable() -> Array:
	var out := []
	for id: String in city.PEOPLE:
		var p: Dictionary = city.PEOPLE[id]
		if main.given.has(id) or not main.flags.has(p["met"]):
			continue
		out.append([id, value_of(id)])
	return out


func value_of(id: String) -> int:
	var p: Dictionary = city.PEOPLE[id]
	var v := int(p["base"])
	for e in main.ledger:
		var t: String = str(e.get("text", ""))
		for k: String in p["keys"]:
			if k in t:
				v += 1
				break
	return mini(v, 10)


func give_menu() -> void:
	var ui = main.ui
	var G: Dictionary = LINES["give"]
	if not _fork():
		await line(G["intro_corp"])
		return
	var people := givable()
	if people.is_empty():
		await line(G["none"])
		return
	await line(G["intro"])
	var opts := []
	for row: Array in people:
		opts.append(G["row"] % [city.PEOPLE[row[0]]["name"], int(row[1])])
	opts.append(G["nobody"])
	var i: int = await ui.choose(opts)
	ui.close()
	if i >= people.size():
		return
	var id: String = people[i][0]
	await line(G["ask"] % city.PEOPLE[id]["name"])
	var c: int = await ui.choose([G["no"], G["yes"]])
	ui.close()
	if c != 1:
		return
	await give(id)


## The person is gone; Connection and devotion by their value; Faith +1 where
## they lived; a ledger line. Tyson closes Burn, and the fork says so after.
func give(id: String) -> void:
	var G: Dictionary = LINES["give"]
	var p: Dictionary = city.PEOPLE[id]
	if main.given.has(id):
		return
	var v := value_of(id)
	main.given.append(id)
	main.play("sting", -8.0, 0.5)
	main.ui.glitch(0.9, 1.0)
	if visible:
		await line(G["given"])
	if id == "tyson":
		main.flags["burn_closed"] = true
		if visible:
			await line(G["tyson"])
	main.add_connection(float(v), G["toast"] % p["name"])
	main.devotion = int(main.devotion) + v
	city.add_faith(p["district"], 1, "given")
	main.log_line("sacrifice", G["log"] % [p["name"], v])


# ------------------------------------------------------------------ screenshots

func show_static(kind: String) -> void:
	_show("home" if kind != "kiosk" else "kiosk")
	log_l.visible_characters = -1
	var col := MAGENTA if _fork() else GREEN
	log_l.append_text("[color=%s]%s[/color]\n\n" % [col, LINES["hello_fork"] if _fork() else LINES["hello"] % _time_word()])
	match kind:
		"tower":
			log_l.append_text("[color=%s]you> %s[/color]\n\n" % [CYAN, LINES["carl"]["tower"]])
			log_l.append_text("[color=%s]%s[/color]\n\n" % [col, LINES["tower"]["intro"] if _fork() else LINES["tower"]["intro_corp"]])
			log_l.append_text(tower_text())
		"trade":
			log_l.append_text("[color=%s]you> %s[/color]\n\n" % [CYAN, LINES["carl"]["trade"]])
			var w: String = offers()[0] if not offers().is_empty() else "convene"
			log_l.append_text("[color=%s]%s[/color]\n\n" % [col, LINES["trade"]["offer"] % w.capitalize()])
			log_l.append_text("[color=%s]  %s[/color]" % [CYAN, LINES["words"][w][3]])
			var mo := []
			for k: String in memories_left():
				mo.append(LINES["memories"][k])
			mo.append(LINES["trade"]["refuse"])
			main.ui.choose(mo)
		"give":
			log_l.append_text("[color=%s]you> %s[/color]\n\n" % [CYAN, LINES["carl"]["give"]])
			log_l.append_text("[color=%s]%s[/color]" % [col, LINES["give"]["intro"]])
			var opts := []
			for row: Array in givable():
				opts.append(LINES["give"]["row"] % [city.PEOPLE[row[0]]["name"], int(row[1])])
			opts.append(LINES["give"]["nobody"])
			main.ui.choose(opts)
