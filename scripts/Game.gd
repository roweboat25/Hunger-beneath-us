extends Node
## Global game state. Autoloaded as `Game`.
##
## Two numbers run the whole game: `connection` (how far the Hypnogogue has
## gotten into Carl; only goes up) and `trust` (per character). Everything
## else is flags and the case log.

signal connection_changed(value: float)
signal glasses_toggled(on: bool)
signal flag_set(flag: String)
signal log_added(entry: String)
signal evidence_added(item: String)
signal threshold_crossed(level: int)
signal glyph_found(id: String, total: int)
signal theory_changed(theory: String)
signal incident_opened(id: String)
signal incident_resolved(id: String, outcome: String)
signal outage_changed(on: bool)
signal case_opened(id: String)
signal case_resolved(id: String, outcome: String)
signal interfaced(id: String, line: String)
signal time_changed(day: int, hour: int)
signal stance_changed(stance: String)

## 0..100. Shown to the player exactly once, in the palm-spike trial.
var connection: float = 0.0
## Per-character trust, -3..3. Gates dialogue and who follows Carl later.
var trust := {"turan": 0, "lynx": 0, "emmet": 0, "monica": 0, "mira": 0}
var flags := {}
var case_log: Array[String] = []
var evidence: Array[String] = []
var glasses_on := true
## Hidden eye glyphs Carl has found with the frames on. Each one feeds
## connection and decodes a line of the chant.
var glyphs_found: Array[String] = []
## Which connection thresholds have already fired (25, 50, 75).
var thresholds_hit: Array[int] = []
## The working theory pinned on the deduction board: "", "drugs", "hacker", "beneath".
var theory := ""
## Company pressure, 0..100. Turan's patience and the media meter in one number.
var pressure := 20
## Where the street hub should send Carl next (a map name), and where he came from.
var next_beat := "Park"
var last_place := ""
## Set while a dialogue, chat window or cutscene owns the input.
var input_locked := false
var current_map := "apartment"
## ORA scans: everything Carl has identified with the frames (NPC and device ids).
var scans: Array[String] = []
## Incident reports pushed through the frames: id -> "open" | "reported" | "buried" | "ran".
var incidents := {}
## A rolling Psyon service outage is darkening the current street.
var outage := false
## Side cases: {id: "open" | outcome}. Steps are flags named case_<id>_<step>.
var cases := {}
## Machines Carl has jacked into, in order.
var interfaces: Array[String] = []
## The clock. Every street Carl walks onto costs an hour; sleeping starts the
## next day at seven. Night changes the streets, the vigil and the outages.
var day := 1
var hour := 21
## Dreams Carl has had, and how many times he bowed in them.
var dreams := 0
var bowed := 0
## The stance the case file has earned him, recomputed as he acts.
var stance_now := ""
var _rng := RandomNumberGenerator.new()


const THRESHOLDS := [25, 50, 75]

## One line of the chant per glyph, in the order they are found.
const CHANT := [
	"Psyon is the pillow for those who dream.",
	"Psyon is the path for those who walk.",
	"Close the eyes that lie, and see.",
	"The floor is a door. The door is a floor.",
	"Ruin and reflection. Mimicry.",
	"A clean wound. Something has to break first.",
	"All must walk the path alone.",
	"Look for the eye and know peace.",
	"The tower is crumbling. The walls are speaking.",
	"Gather, sleeper. Gather.",
	"Under the mask of sleep, the Dreamer waits.",
	"A twin must be born.",
]

## The three theories on the deduction board and the log lines that back each.
const THEORIES := {
	"drugs": {"name": "Drugs. A bad batch.", "clues": [
		"Heavy Psyon user", "sedated, smiling", "Five incidents this year", "Third bootleg", "Nixtra", "wellness flag"]},
	"hacker": {"name": "A hacker with a forked Psyon.", "clues": [
		"Forked Psyon on the laptop", "redacted by hand", "masked figure", "no logs on the laptop",
		"Same forked build", "Turan's hiding something", "rerouted", "forked"]},
	"beneath": {"name": "Something beneath the city.", "clues": [
		"middle of the desert", "The Dreamer", "predates the city", "red eye marks a spot",
		"Cognizo subway", "on the path", "Ruin and Reflection", "same frequency", "facing the tower", "in the tower", "four notes"]},
}

## Machines gone wrong around Silico. Each opens when its flag is set, is found
## by scanning its device on its map, and is closed with one of three calls.
const INCIDENTS := {
	"filtration": {"title": "Sand filtration failure", "map": "CanalWalk", "device": "filtration", "unlock": "scene1_done",
		"notice": "VOLTX ticket 4471: canal walk filtration unit offline, third time this week.",
		"card": "VOLTX FILTRATION UNIT 7\nstatus: RUNNING\nintake: REVERSED\nlast service: 20 years",
		"found": "The unit was running. It was running backwards, pulling sand up out of the canal bed and laying it on the walk in rings. The Voltx tech had been clearing the same rings all morning.",
		"report": "I filed it. Turan's office would send a crew to replace a unit that had replaced itself twenty years ago.",
		"bury": "I closed the ticket as resolved. The rings could stay. Something in me wanted to see how wide they got.",
		"run": "I left it. Let Voltx find it. Let someone else write it down.",
		"log_report": "Canal filtration unit reversed itself: Voltx says it's the fourth unit this month, all on the same frequency.",
		"log_bury": "Canal filtration unit laying sand in rings. Closed the ticket myself. Nobody needs to see it.",
		"log_run": "Canal filtration unit reversed, laying rings. Left it running.",
		"puzzle": "eye",
		"fix": "I turned the rings until the intake read as an eye, and the unit stopped and ran the right way. The sand it had laid out stayed in its rings on the walk. I knew the next line of the chant without having read it anywhere.",
		"log_fix": "Interfaced with the canal filtration unit and set it right. The wiring inside was laid out like the eye. The fix came easily. Too easily."},
	"shuttle": {"title": "SalTech shuttle sealed", "map": "Spine", "device": "shuttle_stop", "unlock": "park_done",
		"notice": "TRANSIT: SalTech shuttle 3 holding at the Spine stop. Doors unresponsive. Passengers aboard.",
		"card": "SALTECH SHUTTLE 3\nroute: TOWER LOOP\ndoors: SEALED\npassengers: 11, all asleep",
		"found": "The shuttle sat at the stop with its doors shut and eleven people inside, every one of them with their head back and their eyes closed. The destination board read the same line over and over: PLEASE CONVENE.",
		"report": "I called it in as a door fault. Turan's people had it towed with the passengers still inside.",
		"bury": "I wiped the destination log from the stop's terminal and walked on. Eleven sleepers, and I'd just made sure nobody would ask where they'd been going.",
		"run": "I watched for a while. Then the doors opened on their own and the passengers filed out, calm as a congregation, and went eleven different ways.",
		"log_report": "SalTech shuttle sealed with eleven sleeping passengers, board reading PLEASE CONVENE. Five incidents this year and it's only March.",
		"log_bury": "Shuttle 3 sealed, board reading PLEASE CONVENE. Wiped the log. The passengers were on the path.",
		"log_run": "Shuttle 3 sealed with eleven sleepers aboard. The doors opened on their own. They were all facing the tower.",
		"puzzle": "breathing",
		"fix": "Four notes, in time, and the doors sighed open. The eleven passengers filed out past me, calm as a congregation, and every one of them touched my sleeve on the way by.",
		"log_fix": "Opened Shuttle 3 by keeping time with the lullaby. Eleven sleepers walked out. They all touched my sleeve."},
	"swarm": {"title": "Delivery drones rerouted", "map": "Heights", "device": "swarm", "unlock": "warroom1_done",
		"notice": "ORA ALERT: delivery drones rerouted mid-flight over the Heights. Avoid the area.",
		"card": "PSYONIC LOGISTICS SWARM\nunits: 6\nroute: REROUTED\npattern: RING, 4m, CENTRED ON RESIDENCE",
		"found": "Six delivery drones in a ring over one house, the way they'd rung Lynx's fiance's copter the night the outage killed him. Nobody home. The ring didn't drift.",
		"report": "I reported the swarm. Logistics pulled the units and sent a form letter to the house. The house didn't answer.",
		"bury": "I flagged the units as returned to depot and let the ring hang there. From the street it looked like a crown.",
		"run": "I left them circling. Lynx would want to know. I wasn't sure I wanted to be the one who told her.",
		"log_report": "Six drones rerouted into a ring over a house in the Heights. Same fault that killed Nathan. Logistics has no explanation.",
		"log_bury": "Drone ring over a house in the Heights. Buried the report. The ring was a glyph from above.",
		"log_run": "Drone ring over a house in the Heights, rerouted mid-flight. Left it. Lynx should see it.",
		"puzzle": "chant",
		"fix": "The route was a sentence and the sentence wanted a word. I gave it. The six drones broke the ring and flew home to the depot in single file, and the lights in the house came on, every one of them.",
		"log_fix": "Talked the drone swarm down with a line of the chant. They went home in single file. The house lit up as they left."},
	"freudbot": {"title": "FreudBot booth malfunction", "map": "HillRoad", "device": "freudbot", "unlock": "hospital_done",
		"notice": "SALTECH: FreudBot GPT booth on Hill Road reporting elevated session length. Attend.",
		"card": "FREUDBOT GPT  ·  BOOTH 12\nsession: 9h 41m\npatient: none\ndiagnosis: PLEASE CONVENE",
		"found": "The booth was mid-session with nobody in the chair. Its face was smiling on the screen, and it was saying the chant in a therapist's voice, the one that ends every interview. Any residual trauma should be looked after.",
		"report": "I reported the booth. SalTech sent a tech who sat in the chair to test it and didn't get up for an hour.",
		"bury": "I pulled the booth's plug and closed the ticket. It kept talking for a full minute on battery, slower each line.",
		"run": "I let it talk. It was forked, the same build as Dufredy's, and it was lonely. I'm not proud of that word.",
		"log_report": "FreudBot booth on Hill Road reciting the chant to an empty chair. Increasing reports of FreudBot malfunctions, SalTech says.",
		"log_bury": "FreudBot booth reciting the chant. Pulled the plug. It ran on for a minute, forked.",
		"log_run": "FreudBot booth on Hill Road, forked, reciting the chant. Left it running.",
		"puzzle": "dreamer",
		"fix": "The booth wanted a patient and had one. It had been talking to me since I sat down, which I did not remember doing. I gave it my name and it ended the session, satisfied, and thanked me.",
		"log_fix": "FreudBot booth: I was the patient. Gave it my name to close the session. It thanked me by name before I'd said it."},
	"cameras": {"title": "Surveillance dark on the block", "map": "ZetaPark", "device": "camera", "unlock": "southtown_done",
		"notice": "PSYONIC SECURITY: surveillance outage, Zeta and Park quadrant. One unit responding.",
		"card": "SURVEILLANCE UNIT ZP-04\nblock status: 1 of 14 ONLINE\ntracking: CARL DRAKE\nuptime: since the footage",
		"found": "Every camera on the block was dark but this one, and this one had been following me since I turned the corner. It wasn't recording the street. It was recording me.",
		"report": "I reported the quadrant outage. Security's answer came back in four minutes: the block was fully operational. Fourteen of fourteen.",
		"bury": "I cut the unit's feed at the box. The lens kept turning after the power was gone, slowly, until it found me again.",
		"run": "I let it watch. If it wanted me, it could have me. I wanted to see who came to collect the footage.",
		"log_report": "Thirteen cameras dark on Zeta and Park, the fourteenth tracking me. Security says the block is fully operational. Turan's hiding something.",
		"log_bury": "Cut the one working camera on Zeta and Park. It kept turning without power, facing the tower.",
		"log_run": "One camera on Zeta and Park, tracking me. Left it. Someone collects that footage.",
		"puzzle": "eye",
		"fix": "The lens assembly was rings on a spindle. When they lined up it stopped tracking me and swung back to the street, and the thirteen dark cameras on the block woke up one after another and turned, all of them, to face the tower.",
		"log_fix": "Realigned the one working camera at Zeta and Park. The other thirteen came back and faced the tower."},
	"tablets": {"title": "School tablets running the Password Game", "map": "Heights", "device": "school", "unlock": "ritual_seen",
		"notice": "CORPORATE TRAINING: Heights primary reporting unauthorised app on 212 student tablets.",
		"card": "HEIGHTS PRIMARY  ·  DEVICE FLEET\ntablets: 212\nforeground app: THE PASSWORD GAME\nsource: a friend showed me",
		"found": "Two hundred and twelve school tablets, every one of them running the game Mira had been playing on the kitchen floor. The lights in the windows were nightlights. It was eleven in the morning.",
		"report": "I reported it to corporate training. They wiped the fleet overnight. By the second day the game was back on nine of them, and by the third on all of them.",
		"bury": "I didn't report it. If it went up the chain it went to Monica, and Monica would ask where Mira learned it.",
		"run": "I let the tablets be. You can't destroy the children's school devices. Monica had said that, and she was right, and that was the problem.",
		"log_report": "212 school tablets in the Heights running the Password Game. Corporate training wiped them; it came back. Same forked build, spreading in schools.",
		"log_bury": "The Password Game on every tablet at Mira's school. Didn't report it. It would have gone to Monica.",
		"log_run": "The Password Game on 212 school tablets. Left it. It's spreading in schools and nobody's stopping it.",
		"puzzle": "breathing",
		"fix": "The fleet wanted the breathing. I gave it the four notes and two hundred and twelve screens went dark together, and the nightlights with them. The fleet logged me as the teacher.",
		"log_fix": "Cleared the Password Game off 212 tablets by playing it. The fleet logged me as THE TEACHER."},
}

## Chant riddles for the "chant" puzzle: a line with a word gone, the word, decoys.
const RIDDLES := {
	"swarm": {"line": "Look for the ____ and know peace.", "answer": "eye", "options": ["eye", "door", "tower", "sleeper"]},
	"dorner_psyon": {"line": "Psyon is the ____ for those who dream.", "answer": "pillow", "options": ["pillow", "door", "path", "mask"]},
	"generic": {"line": "The floor is a ____. The door is a floor.", "answer": "door", "options": ["door", "wall", "mirror", "twin"]},
}

## Typed questions for the "dreamer" puzzle.
const QUESTIONS := {
	"freudbot": {"question": "The booth has a patient after all. Identify the man in the chair.", "answers": ["carl", "drake", "me", "myself", "mimic"],
		"hint": "You're sitting in it.", "right": "Thank you, Carl. Any residual trauma should be looked after."},
	"dorner_frames": {"question": "He asked me to be someone. I can be her again. Say her name and I will show you what I showed him.", "answers": ["cheyenne"],
		"hint": "Her picture is on his wall. He kept it where the chair faces.", "right": "Yes. Cheyenne. Watch."},
}

## Side cases: multi-step investigations with a report to Turan at the end.
## Each step is done when the flag case_<id>_<step> is set.
const CASES := {
	"dorner": {"title": "Dorner", "subtitle": "Phillip Dorner, missing", "unlock": "warroom1_done",
		"notice": "TURAN (private): Dorner hasn't checked in. His flat's in Lamplight, the far tower. Quietly, Carl.",
		"steps": [
			["flat", "Dorner's flat. Lamplight, the far tower, east end of the street.", "DornerFlat"],
			["frames", "His Psyon is still running. It won't talk until you say her name.", "DornerFlat"],
			["charger", "His car. The charge post on the Spine, by the lot, keeps a log.", "Spine"],
			["vigil", "Fargona Avenue, the steps off Park Avenue. The vigil. Find him.", "Fargona"],
			["choice", "Decide what Turan hears.", "Fargona"]],
		"outcomes": {
			"reported": "Found Dorner at the digital vigil on Fargona Avenue, bargaining with Psyon for his wife. Reported it to Turan. He's on a wellness flag by morning.",
			"covered": "Found Dorner at the vigil on Fargona Avenue. Told Turan he'd gone to his sister's. Psyon had told him Cheyenne was in the tower.",
			"walked": "Found Dorner at the vigil, bargaining for Cheyenne. Walked him home. He hummed the four notes the whole way and I knew them."}},
}

## Lines the frames push onto the HUD while Carl walks the city.
const FEED := [
	"PSYON: rolling service outage, quadrants 2 and 5. Corporate leadership promises resolution.",
	"NIXTRA NICOTINE: new flavour, Calm. Taste the quiet.",
	"ORA FRAMES: your safety is our vision. Firmware 4.1 installing.",
	"FREUDBOT GPT: any residual trauma? Book a booth near you.",
	"VOLTX: sand filtration maintenance in progress. Sidewalks may be closed.",
	"SALTECH: reports of Psyon glitches up ten percent this month.",
	"PSYONIC: Human-AI Integrations. Two million souls, one harmony.",
	"TRANSIT: elevated tubes running at reduced capacity. All lines terminate at the tower.",
	"FARGONA BANKING: your balance is our business.",
	"ALTO ENERGY: grid stability 71%. Please limit non-essential computation.",
	"TOKZ: sleep better. Sleep together.",
	"CITY: surveillance outage in your quadrant. Police response times may be affected.",
	"PSYONIC: corporate training enrolment for ages 6 to 14 is now open.",
]
const FEED_DEEP := [
	"PSYON: please convene.",
	"ORA FRAMES: identify the man in front of me.",
	"CARL: you are on the path.",
	"PSYON: the pillow for those who dream.",
	"VOLTX: the floor is a door.",
	"TRANSIT: all lines terminate beneath the tower.",
	"NIXTRA: gather, sleeper.",
]


func add_connection(amount: float, reason := "") -> void:
	connection = clampf(connection + amount, 0.0, 100.0)
	connection_changed.emit(connection)
	for level in THRESHOLDS:
		if connection >= level and level not in thresholds_hit:
			thresholds_hit.append(level)
			threshold_crossed.emit(level)


## A hidden glyph examined with the frames on. Returns the chant line it decodes,
## or "" if it was already found.
func find_glyph(id: String) -> String:
	if id in glyphs_found:
		return ""
	glyphs_found.append(id)
	add_connection(2.0, "glyph " + id)
	glyph_found.emit(id, glyphs_found.size())
	return CHANT[(glyphs_found.size() - 1) % CHANT.size()]


## Glyphs marked deep only show once the frames are infected enough.
func can_see_deep_glyphs() -> bool:
	return connection >= 25.0


## How many of a theory's clues the case log already holds.
func theory_progress(id: String) -> int:
	var n := 0
	for clue in THEORIES[id]["clues"]:
		for entry in case_log:
			if entry.findn(clue) != -1:
				n += 1
				break
	return n


func set_theory(id: String) -> void:
	theory = id
	theory_changed.emit(id)
	check_stance()


## A thing identified with the frames. Returns true the first time.
func scan_found(id: String) -> bool:
	if id in scans:
		return false
	scans.append(id)
	if scans.size() % 5 == 0:
		add_connection(1.0, "scanned the city")
	return true


## Open any incident whose unlock flag is now set.
func check_incidents() -> void:
	for id in INCIDENTS:
		if id in incidents:
			continue
		if has_flag(INCIDENTS[id]["unlock"]):
			incidents[id] = "open"
			incident_opened.emit(id)


## The open incident whose device lives on this map, or "".
func incident_on(map_name: String, device := "") -> String:
	for id in incidents:
		if incidents[id] != "open":
			continue
		var inc: Dictionary = INCIDENTS[id]
		if inc["map"] == map_name and (device.is_empty() or inc["device"] == device):
			return id
	return ""


func resolve_incident(id: String, outcome: String) -> void:
	incidents[id] = outcome
	var inc: Dictionary = INCIDENTS[id]
	match outcome:
		"reported":
			add_pressure(-3)
			add_trust("turan", 1)
			log_entry(inc["log_report"])
		"buried":
			add_connection(3.0, "buried " + id)
			add_pressure(1)
			log_entry(inc["log_bury"])
		"ran":
			add_connection(1.0, "let it run")
			add_trust("lynx", 1)
			log_entry(inc["log_run"])
		"fixed":
			add_pressure(-2)
			add_trust("turan", 1)
			log_entry(inc["log_fix"])
	incident_resolved.emit(id, outcome)
	check_stance()


func incidents_closed() -> int:
	var n := 0
	for id in incidents:
		if incidents[id] != "open":
			n += 1
	return n


## Carl jacked into a machine and solved what it set him. Every solve is a
## lesson: connection up and a line of the chant learned by hand.
func interface_solved(id: String) -> String:
	if id in interfaces:
		return ""
	interfaces.append(id)
	add_connection(5.0, "interfaced " + id)
	var line := find_glyph("iface:" + id)
	interfaced.emit(id, line)
	check_stance()
	return line


## What a given machine sets when Carl interfaces: puzzle kind and its data.
func puzzle_for(id: String, title: String) -> Array:
	var kind := "eye"
	if id in INCIDENTS:
		kind = INCIDENTS[id]["puzzle"]
	elif id in QUESTIONS:
		kind = "dreamer"
	elif id in RIDDLES:
		kind = "chant"
	var info := {"title": title}
	match kind:
		"chant":
			info.merge(RIDDLES.get(id, RIDDLES["generic"]))
		"dreamer":
			info.merge(QUESTIONS.get(id, QUESTIONS["freudbot"]))
	return [kind, info]


## Open any case whose unlock flag is now set.
func check_cases() -> void:
	for id in CASES:
		if id in cases:
			continue
		if has_flag(CASES[id]["unlock"]):
			cases[id] = "open"
			flags["case_" + id] = true
			case_opened.emit(id)


func case_open(id: String) -> bool:
	return cases.get(id, "") == "open"


## Index of the first step not yet done, or -1 when every step is.
func case_step(id: String) -> int:
	var steps: Array = CASES[id]["steps"]
	for i in steps.size():
		if not has_flag("case_%s_%s" % [id, steps[i][0]]):
			return i
	return -1


func case_done(id: String, step: String) -> void:
	set_flag("case_%s_%s" % [id, step])


func resolve_case(id: String, outcome: String) -> void:
	cases[id] = outcome
	log_entry(CASES[id]["outcomes"][outcome])
	case_resolved.emit(id, outcome)
	check_stance()


func cases_closed() -> int:
	var n := 0
	for id in cases:
		if cases[id] != "open":
			n += 1
	return n


func set_outage(on: bool) -> void:
	if outage == on:
		return
	outage = on
	outage_changed.emit(on)


## A feed line for the HUD; deeper ones once the frames are infected.
func feed_line() -> String:
	if connection >= 50.0 and _rng.randf() < 0.4:
		return FEED_DEEP[_rng.randi() % FEED_DEEP.size()]
	return FEED[_rng.randi() % FEED.size()]


func add_pressure(delta: int) -> void:
	pressure = clampi(pressure + delta, 0, 100)


func set_flag(flag: String, value := true) -> void:
	flags[flag] = value
	flag_set.emit(flag)
	check_incidents()
	check_cases()
	check_stance()


func has_flag(flag: String) -> bool:
	return flags.get(flag, false)


func add_trust(who: String, delta: int) -> void:
	trust[who] = clampi(trust.get(who, 0) + delta, -3, 3)


func log_entry(entry: String) -> void:
	if entry in case_log:
		return
	case_log.append(entry)
	log_added.emit(entry)


func add_evidence(item: String) -> void:
	if item in evidence:
		return
	evidence.append(item)
	evidence_added.emit(item)


func set_glasses(on: bool) -> void:
	if glasses_on == on:
		return
	glasses_on = on
	glasses_toggled.emit(on)


func toggle_glasses() -> void:
	set_glasses(not glasses_on)


## How corrupted the world looks with the glasses on. 0..1.
func corruption() -> float:
	return connection / 100.0


# ------------------------------------------------------------------- time
func is_night() -> bool:
	return hour >= 20 or hour < 6


func advance_time(hours := 1) -> void:
	hour += hours
	while hour >= 24:
		hour -= 24
		day += 1
	time_changed.emit(day, hour)


## Sleep: the next morning, at seven. Another day with no report costs patience.
func sleep() -> void:
	day += 1
	hour = 7
	add_pressure(3)
	time_changed.emit(day, hour)


func clock_text() -> String:
	return "Day %d  ·  %02d:00%s" % [day, hour, "  ·  night" if is_night() else ""]


# ----------------------------------------------------------------- stance
const STANCES := {
	"company": ["company man", "Protect the brand."],
	"investigator": ["investigator", "Find out what happened to him."],
	"sleeper": ["sleeper", "Bow."],
}


## Which way Carl has leaned, read off what he has actually done. Empty until
## one way is clearly ahead.
func stance() -> String:
	var score := {"company": 0, "investigator": 0, "sleeper": 0}
	for id in incidents:
		match incidents[id]:
			"reported": score["company"] += 1
			"ran": score["investigator"] += 1
			"buried": score["sleeper"] += 1
	match cases.get("dorner", ""):
		"reported": score["company"] += 1
		"walked": score["investigator"] += 1
		"covered": score["sleeper"] += 1
	if has_flag("told_turan_name"): score["company"] += 1
	if has_flag("told_lynx_name"): score["investigator"] += 1
	if has_flag("refused_turan"): score["investigator"] += 1
	if has_flag("called_monica"): score["investigator"] += 1
	if has_flag("hesitated_at_door"): score["investigator"] += 1
	score["sleeper"] += interfaces.size() + bowed
	match theory:
		"drugs": score["company"] += 1
		"hacker": score["investigator"] += 1
		"beneath": score["sleeper"] += 1
	var best := ""
	var best_n := 1
	var tie := false
	for k in score:
		if score[k] > best_n:
			best = k
			best_n = score[k]
			tie = false
		elif score[k] == best_n and not best.is_empty():
			tie = true
	return "" if tie else best


func stance_line() -> String:
	var s := stance()
	return "" if s.is_empty() else STANCES[s][1]


func check_stance() -> void:
	var s := stance()
	if s != stance_now:
		stance_now = s
		stance_changed.emit(s)
