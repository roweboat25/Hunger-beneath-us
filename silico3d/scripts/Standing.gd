extends Node
## Standing's three thresholds and what each one does to Carl's city
## (bible-1 "Meters and state": the Standing table, pressure 60 / 80 / 100;
## bible-3 "The open city (Days 4-6)": the PIP route and Deregistered;
## bible-1 "Characters": Tyson Clerif), and the street side of Carl's Tower
## (Memory's playback). City.standing; Main owns the state.
##
## - 60 (50 when Turan's trust is -2 or lower): Turan's audit, the next
##   morning. The case file against the ledger: every incident buried, every
##   man put down in the street, every debt is a discrepancy, and each one is
##   T:turan -1. Telling her why is Standing +5.
## - 80: the PIP (the holding cell gives it in the story; Standing can get
##   there first). The company car recalled, the lift stops at 86 (the war
##   room above it is closed), a FreudBot session each morning (sessions 2
##   and 3 of 3: a dive with the lie detector), the spa on Day 5 night.
## - 100: Deregistered. The tower locks behind Carl the next time he leaves
##   it; home is the encampment at Harmony Green (levels/Encampment.gd), and
##   every district has one he can sleep in; Tyson is the handler (his lines
##   take Turan's: the incident question each morning, the report); the street
##   says "I saw you with the unregistered"; the Refuse ending closes and Burn
##   opens whatever the Connection if Tyson is alive (levels/Chair.gd).
## The thresholds belong to Act 2 (act1_done), as the table says. Each
## transition is a scene (a card, lines, a ledger line), played the first
## moment Carl is in the open city with nothing else on screen.
##
## Flags: audit_due (the day it fell due), audit_done, audit_n, pip_active,
## pip_standing, freudbot_d5 / freudbot_d6, deregistered, dereg_exit (the
## tower lets him out once), tyson_told_d<N>.
##
## Every line is (game) unless marked; ian rewrites them. Lines marked
## (book) are the novel's (ch.2 Tyson at his wall, ch.19.5 the train,
## ch.17-18 the FreudBot).

const MemoryRoomS := preload("res://scripts/MemoryRoom.gd")

const LINES := {
	"audit": {
		"card": "[b]THE AUDIT[/b]\n\n[color=#aaaaaa]Integrations, floor 96  ·  Dr. Turan, on the frames\n%s[/color]",
		"open": "Carl. Your Standing came across my desk this morning before my coffee did. I'm checking your case file against your frames' log. Line by line.",   # (game)
		"clean": "It matches. Every line. I don't like clean, Carl. Clean means you're good at this.",   # (game)
		"count": "%d things your frames saw that your file didn't.",   # (game)
		"item": "%s",   # (game)
		"d_buried": "%s, %s. Your file says resolved. Your frames say you closed the ticket yourself and walked away.",
		"d_takedown": "A man on the pavement and an eye painted where he fell. That isn't in your file either.",
		"d_debt": "Four hours your frames can't account for, and a line in your log that just says debt. Debt to who, Carl?",
		"choices": ["It's all in the file.", "I left things out. I had reasons."],
		"file_carl": "It's all in the file.",
		"file": "Then the file's wrong, and it's got your name on it. Every one of these goes upstairs.",   # (game)
		"truth_carl": "I left things out. I had reasons. I can't put them in a report yet.",
		"truth": "Yet. Fine. I'll sit on it a day. One day. That's what being your friend costs this week.",   # (game)
		"why_truth": "the truth, to Turan",
		"log": "Turan's audit: the case file against the ledger, %d discrepancies flagged upstairs.",
	},
	"pip": {
		"card": "[b]PIP ACTIVE[/b]\n\n[color=#aaaaaa]Standing %d  ·  company car recalled  ·  floors above 86 locked\nFreudBot each morning[/color]",
		"hr": ["Carl Drake. This is an automated notice from Psyonic People and Culture. Your Standing has fallen below the threshold for unsupervised fieldwork.",   # (game)
			"Effective immediately you are placed on a Performance Improvement Plan. Your company vehicle has been recalled. Your badge is restricted to floors 86 and below.",   # (game)
			"You will attend a FreudBot wellness session every morning before 09:00. Honesty is the first step."],   # (game)
		"who": "Psyonic HR",
		"car": "Somewhere under the Spine the car I'd driven for six years beeped twice and drove itself home without me.",   # (game)
		"turan": "Integrations was on 96. My badge stopped at 86 now. Turan was ten floors and a whole career away.",   # (game)
		"log": "PIP: Standing too low. The car recalled, floors above 86 locked, FreudBot every morning.",
		"toast": "PIP   no car  ·  walk or the subway",
	},
	"freudbot": {
		"card": "[b]FREUDBOT GPT[/b]\n\n[color=#aaaaaa]SALTECH × PSYONIC  ·  session %d of 3  ·  remote[/color]",
		"who": "FREUDBOT",
		"hello": "Good morning, Carl. Your Performance Improvement Plan requires a session before 09:00. Please remain where you are. This will only take a moment.",   # (game)
		"dive": "The frames took the street away and put a white room round me. The same white room. It had kept it for me.",   # (game)
		"sleep_q": "Did you sleep, Carl?",   # (game)
		"sleep_c": ["No.", "I slept."],
		"report_q": "Did you report everything you saw yesterday?",   # (game)
		"report_c": ["Everything.", "No. Not everything."],
		"dream_q": "What did you dream about, Carl?",   # (game)
		"dream_c": ["Nothing.", "%s."],
		"lie": "I detected lies, Carl. Therapy only works if you're honest with me.",
		"lie_text": "The text displayed on the screen in a small font: \"Lie detected.\"",
		"honest": "Thank you for your honesty, Carl. That has been noted for your supervisor.",
		"why_lie": "lie detected",
		"why_dive": "FreudBot session",
		"close": "Recognizing the problem is the first step.",
		"soon": "I'll talk with you soon, Carly.",
		"after": "The white room folded itself away. The morning came back, a little brighter than I'd left it.",   # (game)
		"log": "FreudBot session %d of 3 (remote): %d lies detected.",
	},
	"dereg": {
		"card": "[b]DEREGISTERED[/b]\n\n[color=#aaaaaa]ORA citizen registry  ·  DRAKE, C.\nhousing: WITHDRAWN  ·  badge: VOID  ·  Standing 0[/color]",
		"ora": ["Citizen registry notice. DRAKE, CARL. Housing privileges: withdrawn. Psyonic credentials: void.",   # (game)
			"Company property in your possession will be recovered at your convenience. Thank you for living in Silico."],   # (game)
		"who": "ORA",
		"scan": "The frames ran their card on me, the way they'd run it on a man against a wall in Harmony Green. UNREGISTERED. No photo.",   # (game)
		"tyson": "Unregistered for corporate property. I'd read that line off Tyson Clerif four days ago and felt sorry for him. Now he had a wall, and I didn't.",   # (game)
		"stay": "Nothing in 86D changed. The lights stayed on. The flat would let me stay until I left it. It would let me leave once.",   # (game)
		"log": "Deregistered: housing withdrawn, badge void. The tower will lock behind me.",
		"toast": "Deregistered   home is the encampment, Harmony Green",
		"exit": ["The door let me out. Then it made a sound I'd never heard it make in six years. It locked.",   # (game)
			"Eighty-six floors down, the lobby reader had my face on it in red."],   # (game)
		"exit_log": "The tower locked behind me.",
	},
	"tyson": {
		"call": "Tell Tyson.   [no Standing left to lose]",
		"report": "You're telling me like I'm your boss. Fine. I'll write it on the wall. The wall remembers better than your company did.",   # (game)
		"report_more": "I know patterns, Corpo. That one's a loop. It'll be back tomorrow two streets over.",   # (game)
		"nobody": "There was nobody to tell. His wall was still there. The books were gone.",   # (game)
		"log": "Told Tyson about %s.",
	},
	"street": {
		"lift_dereg": "The residential entrance (locked to me)",
		"lift_scan_dereg": "PSYONIC TOWER  -  RESIDENTIAL\nbadge: DRAKE, C.  -  VOID\nresident: NO",
		"lift_scan_pip": "PSYONIC TOWER  -  RESIDENTIAL\nlift: FLOORS 40-86 (PIP)\nbadge: DRAKE, C.  -  RESTRICTED",
		"lift_no": ["The reader looked at me and thought about it for a long time. Then it went red, and the doors stayed a wall.",   # (game)
			"Eighty-six floors up there was a couch facing the glass. Somewhere else there was a wall in Harmony Green with my name on it now."],   # (game)
		"war_room": "The lift wouldn't take me past 86. The war room was ten floors up and a Performance Improvement Plan away. Turan would have to find me.",   # (game)
		"camp_prompt": "The encampment: somewhere to sleep",
		"camp_scan": "UNREGISTERED DWELLINGS\nresidents: %d\ndevices: NONE\ncomplaints: NONE",
		"camp_sign": "NO FRAMES PAST HERE",
		"people": ["I saw you with the unregistered.", "You used to have a badge. I remember. You looked straight through me with it.",   # (game)
			"I saw you with the unregistered. Your face was on the feed this morning, with the red bar.", "They took your flat? They took my sister's. She sleeps under the Fargona screens now. Says it's warm."],   # (game)
	},
	"memory": {
		"phone": "[color=#c8a0ff]MEMORY  ·  played back[/color]\n%s\n\n",
		"row": "[color=#b0a8c8]%s[/color]",
	},
}

var main: Node
var city: Node
## Tests run the scenes themselves; in play they run on their own.
var test_auto := false
var _running := false
var _t := 0.0
var _said_i := 0


func setup(m: Node, c: Node) -> void:
	main = m
	city = c


# ------------------------------------------------------------------ state

func act2() -> bool:
	return main.flags.has("act1_done")


func pip() -> bool:
	return main.flags.has("pip_active")


func dereg() -> bool:
	return main.flags.has("deregistered")


## The audit's threshold: 60, or 50 if Turan already distrusts him (bible-1 "Characters").
func audit_at() -> float:
	return 50.0 if int(main.trust.get("turan", 0)) <= -2 else 60.0


## Tyson is alive for the endings if nobody gave him to the god and he didn't leave.
func tyson_alive() -> bool:
	for g in main.given:
		if str(g).to_lower() == "tyson":
			return false
	return not main.flags.has("burn_closed")


## Note the morning the audit falls due (it plays the next one).
func mark() -> void:
	var f: Dictionary = main.flags
	if act2() and not dereg() and main.pressure >= audit_at() and not f.has("audit_done") and not f.has("audit_due"):
		f["audit_due"] = int(main.day)


## The scene that is due now, or "".
func due() -> String:
	var f: Dictionary = main.flags
	if not act2():
		return ""
	if main.pressure >= 100.0 and not dereg():
		return "dereg"
	if main.pressure >= 80.0 and not pip() and not dereg():
		return "pip"
	var morning := int(main.hour) % 24 < 12 and int(main.hour) < 24
	if f.has("audit_due") and not f.has("audit_done") and not dereg() and int(main.day) > int(f["audit_due"]) and morning:
		return "audit"
	if pip() and not dereg() and int(main.day) in [5, 6] and morning and not f.has("freudbot_d%d" % int(main.day)):
		return "freudbot"
	return ""


func _process(delta: float) -> void:
	if main == null or not main.started or main.loading or main.level == null:
		return
	_t += delta
	if _t < 0.5:
		return
	_t = 0.0
	mark()
	if _running or main.shot_mode or (main._selftest and not test_auto):
		return
	if not city.in_hub() or main.ui.busy or main.player.locked or city.map.visible or city.terminal.visible:
		return
	var d := due()
	if d != "":
		run(d)


func run(kind: String) -> void:
	if _running:
		return
	_running = true
	match kind:
		"audit":
			await _audit()
		"pip":
			await _pip()
		"freudbot":
			await _freudbot()
		"dereg":
			await _dereg()
	_running = false
	main.update_hud()


# ------------------------------------------------------------------ 60: the audit

## What the frames saw that the case file doesn't say.
func discrepancies() -> Array:
	var A: Dictionary = LINES["audit"]
	var out := []
	for id in main.incidents:
		var inc: Dictionary = main.incidents[id]
		if str(inc.get("state", "")) == "buried":
			out.append(A["d_buried"] % [inc["title"], city.district_name(inc["district"])])
	for e in main.ledger:
		match str(e.get("kind", "")):
			"takedown":
				out.append(A["d_takedown"])
			"debt":
				out.append(A["d_debt"])
	return out


func _audit() -> void:
	var ui = main.ui
	var A: Dictionary = LINES["audit"]
	var f: Dictionary = main.flags
	f["audit_done"] = true
	main.play("ding", -8.0, 1.0)
	await ui.show_card(A["card"] % city.clock_text(), 2.2)
	await ui.say("Turan", A["open"])
	var found := discrepancies()
	if found.is_empty():
		await ui.say("Turan", A["clean"])
	else:
		await ui.say("Turan", A["count"] % found.size())
		for i in mini(3, found.size()):
			await ui.say("Turan", A["item"] % found[i])
		# each discrepancy costs Turan -1 (bible-1, the Standing table)
		main.add_trust("turan", -found.size())
	var c: int = await ui.choose(A["choices"])
	if c == 1:
		await ui.say("Carl", A["truth_carl"])
		await ui.say("Turan", A["truth"])
		main.add_pressure(-5.0, A["why_truth"])
	else:
		await ui.say("Carl", A["file_carl"])
		await ui.say("Turan", A["file"])
	ui.close()
	f["audit_n"] = found.size()
	main.log_line("audit", A["log"] % found.size())


# ------------------------------------------------------------------ 80: the PIP

func _pip() -> void:
	var ui = main.ui
	var P: Dictionary = LINES["pip"]
	var f: Dictionary = main.flags
	f["pip_active"] = true
	f["pip_standing"] = true
	main.play("sting", -10.0, 0.8)
	ui.glitch(0.4, 0.5)
	await ui.show_card(P["card"] % int(100.0 - main.pressure), 2.8)
	for l: String in P["hr"]:
		await ui.say(P["who"], l)
	await ui.think(P["car"])
	await ui.think(P["turan"])
	ui.close()
	main.log_line("scene", P["log"])
	ui.show_toast(P["toast"], 4.0)


# ------------------------------------------------------------------ the FreudBot mornings (PIP)

## Session 2 (Day 5) or 3 (Day 6) of the three the holding cell began: a dive
## (+3) with the lie detector reading the ledger, like session 1.
func _freudbot() -> void:
	var ui = main.ui
	var F: Dictionary = LINES["freudbot"]
	var f: Dictionary = main.flags
	var d := int(main.day)
	var n := clampi(d - 3, 2, 3)
	f["freudbot_d%d" % d] = true
	main.play("on", -8.0, 0.6)
	await ui.show_card(F["card"] % n, 2.0)
	await ui.say(F["who"], F["hello"])
	main.play("glitch", -8.0, 0.7)
	ui.glitch(0.7, 0.8)
	await ui.think(F["dive"])
	main.add_connection(3.0, F["why_dive"])
	var lies := 0
	# 1. sleep: the ledger knows whether he slept into today
	var slept := false
	for e in main.ledger:
		if str(e.get("kind", "")) == "sleep" and ("Day %d" % d) in str(e.get("text", "")):
			slept = true
	await ui.say(F["who"], F["sleep_q"])
	var a: int = await ui.choose(F["sleep_c"])
	if (a == 1) != slept:
		lies += await _lie()
	# 2. yesterday: anything buried, let run, put down or owed
	var hid := false
	for id in main.incidents:
		var inc: Dictionary = main.incidents[id]
		if int(inc.get("call_day", -1)) == d - 1 and str(inc.get("state", "")) in ["buried", "let_run"]:
			hid = true
	for e in main.ledger:
		if int(e.get("day", 0)) == d - 1 and str(e.get("kind", "")) in ["takedown", "debt"]:
			hid = true
	await ui.say(F["who"], F["report_q"])
	a = await ui.choose(F["report_c"])
	if a == 0 and hid:
		lies += await _lie()
	# 3. the dream the fork repeats
	await ui.say(F["who"], F["dream_q"])
	var dream: String = city.dream_line
	var opts: Array = [F["dream_c"][0], F["dream_c"][1] % (dream.capitalize() if dream != "" else "Nothing")]
	a = await ui.choose(opts)
	if a == 0 and dream != "":
		lies += await _lie()
	if lies == 0:
		await ui.say(F["who"], F["honest"])
	await ui.say(F["who"], F["close"])
	if main.connection >= 25.0:
		await ui.say("", "[shake rate=24 level=8]%s[/shake]" % F["soon"])
	main.play("off", -8.0, 0.6)
	await ui.think(F["after"])
	ui.close()
	main.log_line("freudbot", F["log"] % [n, lies])


func _lie() -> int:
	var ui = main.ui
	var F: Dictionary = LINES["freudbot"]
	main.play("sting", -12.0, 1.4)
	await ui.say(F["who"], F["lie"])
	await ui.think(F["lie_text"])
	main.add_pressure(3.0, F["why_lie"])
	return 1


# ------------------------------------------------------------------ 100: deregistered

func _dereg() -> void:
	var ui = main.ui
	var D: Dictionary = LINES["dereg"]
	var f: Dictionary = main.flags
	f["deregistered"] = true
	f["pip_active"] = true
	main.play("sting", -6.0, 0.55)
	main.play("off", -6.0, 0.5)
	ui.glitch(1.0, 1.2)
	await ui.show_card(D["card"], 3.0)
	for l: String in D["ora"]:
		await ui.say(D["who"], l)
	await ui.think(D["scan"])
	await ui.think(D["tyson"])
	if main.level_name == "Home":
		f["dereg_exit"] = true
		await ui.think(D["stay"])
	ui.close()
	main.log_line("scene", D["log"])
	ui.show_toast(D["toast"], 4.5)


## Leaving 86D after the notice: the tower locks behind him (City.home_interact).
func lock_on_exit() -> void:
	if not main.flags.has("dereg_exit"):
		return
	main.flags.erase("dereg_exit")
	main.play("slam", -8.0, 0.6)
	for l: String in LINES["dereg"]["exit"]:
		await main.ui.think(l)
	main.ui.close()
	main.log_line("scene", LINES["dereg"]["exit_log"])


## Home is the encampment: the one at Harmony Green, or the one on this street.
func enter_camp(d: String) -> void:
	city.district = d
	city.free_home = false
	main.load_level("Encampment")


## The four incident calls; deregistered, the report goes to Tyson.
func calls() -> Array:
	var c: Array = (city.LINES["calls"] as Array).duplicate()
	if dereg():
		c[1] = LINES["tyson"]["call"]
	return c


## Tyson's line for a report (his lines take Turan's): T:tyson +1 once a day.
func report_to_tyson(inc: Dictionary) -> void:
	var ui = main.ui
	var T: Dictionary = LINES["tyson"]
	if not tyson_alive():
		await ui.think(T["nobody"])
		ui.close()
		return
	await ui.say("Tyson", T["report"])
	await ui.say("Tyson", T["report_more"])
	ui.close()
	var key := "tyson_told_d%d" % int(main.day)
	if not main.flags.has(key):
		main.flags[key] = true
		main.add_trust("tyson", 1)
	main.log_line("report", T["log"] % str(inc.get("title", "")))


# ------------------------------------------------------------------ the street (levels/Street.gd hooks)

## After a street is built: the residential lift's card under PIP or
## deregistered, and the encampment's way in when he has no home.
func street_build(st: Node) -> void:
	var S: Dictionary = LINES["street"]
	var lift: Node = st.by_id("home_lift")
	if lift:
		if dereg():
			lift.set_meta("prompt", S["lift_dereg"])
			lift.set_meta("scan", S["lift_scan_dereg"])
		elif pip():
			lift.set_meta("scan", S["lift_scan_pip"])
	if dereg():
		_camp_door(st)


## A tarp lean-to against the east facade, a drum fire, a hand-painted sign:
## the way through to the encampment behind the block.
func _camp_door(st: Node) -> void:
	var S: Dictionary = LINES["street"]
	var p := Vector3(11.4, 0.12, 0.0)
	var tarp: Material = st.mat(Color(0.18, 0.24, 0.3), 0.9)
	var tarp2: Material = st.mat(Color(0.42, 0.3, 0.16), 0.9)
	var pole: Material = st.mat(Color(0.3, 0.3, 0.3), 0.5, 0.7)
	st.box(Vector3(2.6, 0.04, 3.4), p + Vector3(0.3, 2.0, 0), tarp).rotation.z = 0.5
	st.box(Vector3(0.04, 1.8, 3.2), p + Vector3(1.45, 0.95, 0), tarp2)
	for z: float in [-1.6, 1.6]:
		st.cyl(0.03, 0.03, 2.0, p + Vector3(-0.8, 1.0, z), pole, 5)
	st.prop("Barrel_01", p + Vector3(-1.4, 0.0, 2.3), 0.0, 1.0, true)
	st.box(Vector3(0.45, 0.06, 0.45), p + Vector3(-1.4, 0.98, 2.3), st.glow(Color(1.0, 0.45, 0.12), 3.0))
	var fl: OmniLight3D = st.light(p + Vector3(-1.4, 1.5, 2.3), Color(1.0, 0.5, 0.2), 1.3, 6.0, false)
	st.flickers.append(fl)
	st.prop("cardboard_box_01", p + Vector3(0.4, 0.0, -2.2), 0.3, 1.0, false)
	st.prop("plastic_crate_03", p + Vector3(-0.2, 0.0, -2.4), 0.0, 1.0, false)
	st.label(S["camp_sign"], p + Vector3(1.4, 1.9, 0), -PI / 2.0, 0.004, Color(0.95, 0.92, 0.8), st, false)
	var door: CollisionObject3D = st.interactable("camp_door", S["camp_prompt"], p + Vector3(0.2, 1.1, 0), Vector3(1.6, 2.2, 3.0),
		S["camp_scan"] % (6 + absi(hash(str(st.did))) % 9), false)
	door.set_meta("exit", true)


## Street interactions that belong to Standing; true when handled.
func street_interact(st: Node, id: String) -> bool:
	var ui = main.ui
	var S: Dictionary = LINES["street"]
	match id:
		"camp_door":
			ui.close()
			enter_camp(str(st.did))
			return true
		"home_lift":
			if dereg():
				for l: String in S["lift_no"]:
					await ui.think(l)
				return true
		"beat_door":
			var b: Dictionary = st._beat
			if pip() and not b.is_empty() and str(b.get("level", "")) == "WarRoom":
				await ui.think(S["war_room"])
				return true
	return false


## What the street says to a man without a registration (its own count, so
## the Faith lines in between don't skip the first).
func street_line(_i: int) -> String:
	var pool: Array = LINES["street"]["people"]
	_said_i += 1
	return str(pool[(_said_i - 1) % pool.size()])


## Carl's Tower, Memory: E in the room behind 86D's hall (MemoryRoom.gd).
func memory_interact(id: String) -> bool:
	return await MemoryRoomS.interact(main, id)


## Carl's Tower, Memory: the frames play back the last things he was told.
func remember() -> String:
	if not main.tower_rooms.has("memory"):
		return ""
	var M: Dictionary = LINES["memory"]
	var blank: String = city.terminal.LINES["trade"]["blank"]
	var rows := []
	for i in range(main.ledger.size() - 1, -1, -1):
		var e: Dictionary = main.ledger[i]
		var t := str(e.get("text", ""))
		if str(e.get("kind", "")) in ["testimony", "person", "said", "clue", "evidence", "lead", "memory"] and t != blank and t != "":
			rows.append(M["row"] % t)
			if rows.size() >= 2:
				break
	if rows.is_empty():
		return ""
	return M["phone"] % "\n".join(rows)


# ------------------------------------------------------------------ the systems test (--systems=1)

## Called at the end of City.selftest_systems (Day 5, 23:00, Red Rock on
## screen): Carl's Tower on the street (Focus, Calm, Memory, Courage), the
## Memory room, the trades in 86D, then Standing 60 / 80 / 100 with their
## scenes, the encampments, and the endings' gates.
func selftest() -> void:
	var ok: Callable = city._ok
	var f: Dictionary = main.flags
	# let Red Rock's arrival finish, then close the beat so nothing forces it back
	var t0 := Time.get_ticks_msec()
	while not f.has("rr_arrived") and Time.get_ticks_msec() - t0 < 60000:
		await get_tree().process_frame
	f["lushons_done"] = true
	main.ui.close()
	# ---- Carl's Tower on the street
	city.go("spine")
	ok.call("tower: on the street", await city._await_level("Street", 90.0), main.level_name)
	main.devotion = 30
	for id: String in ["calm", "memory", "courage"]:
		await city._sys("tower: " + id, func(): await city.terminal.build_room(id), 20.0)
	ok.call("tower: four rooms", main.tower_rooms.size() == 4, str(main.tower_rooms))
	# Focus: a scan card at 33 m reads only with the room
	main.frames_on = true
	var probe := Node3D.new()
	probe.set_meta("scan", "FOCUS PROBE")
	main.level.add_child(probe)
	probe.global_position = main.player.global_position + Vector3(0, 0, -33.0)
	var seen := func() -> bool:
		main.scan()
		for l in main._scan_labels:
			if is_instance_valid(l) and (l as Label3D).text.ends_with("FOCUS PROBE"):
				return true
		return false
	var with_focus: bool = seen.call()
	main.tower_rooms.erase("focus")
	var without: bool = seen.call()
	main.tower_rooms.push_front("focus")
	ok.call("focus: scans reach half again as far", with_focus and not without, "with %s without %s" % [with_focus, without])
	probe.queue_free()
	# Calm: the frames take one less in the open city
	var c0: float = main.connection
	main.add_connection(3.0, "calm test")
	ok.call("calm: +3 reads +2 on the street", absf(main.connection - c0 - 2.0) < 0.01, "%.0f -> %.0f" % [c0, main.connection])
	# Courage: steadier hands in a fight
	ok.call("courage: overwhelmed at four touches", main.melee.overwhelm_at() == 4, str(main.melee.overwhelm_at()))
	# Memory: the phone plays back what he was told
	main.log_line("testimony", "Tyson: a tall figure, a black coat, a ceremonial mask")
	ok.call("memory: the phone plays it back", "ceremonial mask" in str(main.level.phone()), main.level.phone().replace("\n", " | "))
	# ---- 86D: the traded memory gone, the Memory room behind the bedroom door
	if not main.traded.has("lion"):
		await city._sys("trade lion", func(): await city.terminal.trade("dreamer", "lion"), 20.0)
	# a look at the trophy goes in the ledger; trading it blacks the line out
	# and keeps it ("was") for the lectern
	if not main.traded.has("trophy"):
		MemoryRoomS.note(main, "trophy")
		var word := ""
		for w: String in city.terminal.LINES["words"]:
			if not main.hacks.has(w):
				word = w
				break
		if word != "":
			await city._sys("trade trophy", func(): await city.terminal.trade(word, "trophy"), 20.0)
	city.go("home")
	ok.call("home (free visit)", await city._await_level("Home", 90.0) and city.free_home, main.level_name)
	var h: Node = main.level
	var objs := {"drawing": h.drawing, "photo": h.photo, "lion": h.lion_node, "trophy": h.trophy}
	var gone := true
	for k: String in objs:
		if (objs[k] as Node3D).visible == main.traded.has(k):
			gone = false
	ok.call("trade: what was traded is gone from 86D, the rest is there", gone and main.traded.size() >= 2, str(main.traded))
	await h.check_walk("86D spawn->memory room door", "mem_door")
	await h.check_walk("86D spawn->memory lectern", "mem_lectern")
	await h.check_walk("86D spawn->memory frame (lion)", "mem_lion")
	await h.check_walk("86D spawn->memory frame (trophy)", "mem_trophy")
	var hung := true
	for k: String in objs:
		var fr: Node = h.by_id("mem_" + k)
		if fr == null or bool(fr.get_meta("filled", false)) != main.traded.has(k):
			hung = false
	ok.call("memory room: what was traded hangs there, the other hooks empty", hung, str(main.traded))
	for id: String in ["mem_door", "mem_photo", "mem_trophy", "mem_lectern", "mem_council"]:
		var n: Node = h.by_id(id)
		if n:
			await main.interact(n)
			print("ok ", id)
	var restored := false
	for e in main.ledger:
		if e.has("was"):
			restored = true
	ok.call("trade: blanked lines kept for the Memory room", restored, MemoryRoomS._book_text(main).replace("\n", " | "))
	# ---- Standing 60: the audit, the morning after it falls due
	main.incidents["gen_audit"] = {"id": "gen_audit", "title": "Kiosk chanting", "district": "lamplight", "device": "kiosk",
		"fault": "chant", "state": "buried", "opened": city.now_abs() - 30, "gen": true, "call_day": int(main.day)}
	main.pressure = 50.0
	main.add_pressure(11.0, "test")
	mark()
	ok.call("audit falls due, not today", f.has("audit_due") and due() != "audit", "due %s pressure %d" % [f.get("audit_due"), int(main.pressure)])
	f["audit_due"] = int(main.day) - 1
	main.hour = 9
	var tr0 := int(main.trust.get("turan", 0))
	ok.call("audit due the next morning", due() == "audit", due())
	await city._sys("audit", func(): await run("audit"), 60.0)
	ok.call("audit: each discrepancy costs Turan", f.has("audit_done") and int(main.trust["turan"]) <= tr0 - 1, "n %s turan %d -> %d" % [f.get("audit_n"), tr0, int(main.trust["turan"])])
	# ---- Standing 80: the PIP as its own scene
	f.erase("pip_active")
	main.pressure = 79.0
	main.add_pressure(2.0, "test")
	ok.call("pip due at 80", due() == "pip", due())
	await city._sys("pip", func(): await run("pip"), 60.0)
	ok.call("pip: car gone", f.has("pip_active") and f.has("pip_standing") and not city.car_ok(), str(city.route("red_rock")))
	# the FreudBot morning
	f.erase("freudbot_d%d" % int(main.day))
	main.day = 6
	main.hour = 8
	ok.call("freudbot due on a PIP morning", due() == "freudbot", due())
	var c1: float = main.connection
	await city._sys("freudbot", func(): await run("freudbot"), 90.0)
	ok.call("freudbot: a dive, logged", f.has("freudbot_d6") and main.connection > c1, "conn %.0f -> %.0f" % [c1, main.connection])
	# ---- Standing 100: deregistered at home; the tower locks on the way out
	main.pressure = 98.0
	main.add_pressure(5.0, "test")
	ok.call("deregistered due at 100", due() == "dereg", due())
	await city._sys("dereg", func(): await run("dereg"), 60.0)
	ok.call("deregistered", dereg() and f.has("dereg_exit"), "")
	await city._sys("leave 86D", func(): await city.home_interact("front_door"), 60.0)
	ok.call("tower locked behind him", await city._await_level("Street", 90.0) and not f.has("dereg_exit"), main.level_name)
	ok.call("street: the lift refuses", str(main.level.by_id("home_lift").get_meta("prompt")) == LINES["street"]["lift_dereg"], "")
	ok.call("street: the unregistered line", "unregistered" in main.level._street_line() or "unregistered" in main.level._street_line(), "")
	ok.call("incident report goes to Tyson", "Tyson" in str(calls()[1]), str(calls()))
	# home is the encampment at Harmony Green
	await city._sys("travel home (camp)", func(): await city.travel("home"), 30.0)
	ok.call("home is the encampment", await city._await_level("Encampment", 90.0) and city.district == "harmony_green", "%s %s" % [main.level_name, city.district])
	await city._sys("encampment selftest", func(): await main.level.selftest(), 240.0)
	# a camp on another street
	await city._sys("travel lamplight", func(): await city.travel("lamplight"), 30.0)
	ok.call("lamplight street", await city._await_level("Street", 90.0), main.level_name)
	await main.level.check_walk("street spawn->camp_door", "camp_door")
	var cd: Node = main.level.by_id("camp_door")
	if cd:
		await main.interact(cd)
	ok.call("a camp on any street", await city._await_level("Encampment", 90.0) and city.district == "lamplight", city.district)
	# sleep in the camp: Calm makes it +2
	var p0: float = main.pressure
	main.pressure = 50.0
	await city._sys("sleep in the camp", func(): await city.sleep_now(), 60.0)
	ok.call("camp sleep, Calm +2", await city._await_level("Encampment", 90.0) and absf(main.pressure - 52.0) < 0.01, "%s pressure %.0f" % [main.level_name, main.pressure])
	main.pressure = p0
	# ---- the endings read it: Refuse closed, Burn open whatever the Connection while Tyson lives
	var chair: Node = main.LEVELS["Chair"].new()
	chair.main = main
	var cc: float = main.connection
	main.connection = 95.0
	# (Tyson may have left the city by now: SideCases closes Burn then; test him alive)
	var closed: bool = main.flags.has("burn_closed")
	main.flags.erase("burn_closed")
	var burn1: bool = chair._burn_ok()
	var ref1: bool = chair._refuse_ok()
	main.given.append("tyson")
	var burn2: bool = chair._burn_ok()
	main.given.erase("tyson")
	main.flags["burn_closed"] = true
	var burn3: bool = chair._burn_ok()
	if not closed:
		main.flags.erase("burn_closed")
	main.connection = cc
	chair.free()
	ok.call("chair: refuse closed, burn open (tyson alive), shut (given)", burn1 and not ref1 and not burn2 and not burn3, "burn %s refuse %s burn-given %s burn-left %s" % [burn1, ref1, burn2, burn3])
