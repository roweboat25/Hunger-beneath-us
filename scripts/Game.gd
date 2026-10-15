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

## 0..100. Shown to the player exactly once, in the palm-spike trial.
var connection: float = 0.0
## Per-character trust, -3..3. Gates dialogue and who follows Carl later.
var trust := {"turan": 0, "lynx": 0, "emmet": 0, "monica": 0, "mira": 0}
var flags := {}
var case_log: Array[String] = []
var evidence: Array[String] = []
var glasses_on := true
## Set while a dialogue, chat window or cutscene owns the input.
var input_locked := false
var current_map := "apartment"


func add_connection(amount: float, reason := "") -> void:
	connection = clampf(connection + amount, 0.0, 100.0)
	connection_changed.emit(connection)


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
