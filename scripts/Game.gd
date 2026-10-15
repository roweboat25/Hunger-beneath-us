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
var last_place := "Apartment"
## Set while a dialogue, chat window or cutscene owns the input.
var input_locked := false
var current_map := "apartment"


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
		"Heavy Psyon user", "sedated, smiling", "Five incidents this year", "Third bootleg"]},
	"hacker": {"name": "A hacker with a forked Psyon.", "clues": [
		"Forked Psyon on the laptop", "redacted by hand", "masked figure", "no logs on the laptop",
		"Same forked build", "Turan's hiding something"]},
	"beneath": {"name": "Something beneath the city.", "clues": [
		"middle of the desert", "The Dreamer", "predates the city", "red eye marks a spot",
		"Cognizo subway", "on the path", "Ruin and Reflection"]},
}


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


func add_pressure(delta: int) -> void:
	pressure = clampi(pressure + delta, 0, 100)


func set_flag(flag: String, value := true) -> void:
	flags[flag] = value
	flag_set.emit(flag)


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
