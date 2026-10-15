extends Node
## Headless playthrough of the apartment for CI-style checks:
##   godot --headless -- --autoplay
## Drives dialogue, choices, the Psyon window and one real interact press.

var main: Node


func _ready() -> void:
	main = get_parent()
	call_deferred("run")


func run() -> void:
	await get_tree().create_timer(0.5).timeout
	await _drive("intro")
	for id in ["debris", "balcony", "cardboard", "eyes", "stick", "under_eye", "desk"]:
		main.map.on_interact(id)
		await _drive(id)
	# A real interact press on the laptop, through the player's zone.
	main.player.global_position = Vector2(28 * 16 + 8, 5 * 16 + 8)
	main.player.face_toward(Vector2(28 * 16 + 8, 4 * 16 + 8))
	await get_tree().create_timer(0.3).timeout
	Input.action_press("interact")
	await get_tree().process_frame
	Input.action_release("interact")
	await _drive("laptop (key press)")
	assert(Game.has_flag("laptop_bagged"), "laptop should be bagged")
	main.map.on_interact("exit")
	await _drive("exit")
	print("AUTOPLAY DONE  connection=", Game.connection, "  log entries=", Game.case_log.size(),
		"  evidence=", Game.evidence, "  flags=", Game.flags.keys())
	get_tree().quit()


## Keep advancing whatever UI is up until the game is idle for a moment.
func _drive(label: String) -> void:
	var idle := 0.0
	var elapsed := 0.0
	while elapsed < 60.0:
		await get_tree().create_timer(0.12).timeout
		elapsed += 0.12
		var d: DialogueBox = main.dialogue
		var p: PsyonWindow = main.psyon
		if d.visible:
			if not d._choice_buttons.is_empty():
				d._pick(0)
			elif d._typing:
				d._typing = false
			else:
				d.advanced.emit()
			idle = 0.0
		elif p.visible and p._accepting:
			p._on_submit(["who are you", "what did you say to Dufredy", "show me the transcript"][Psyon.transcript.size() % 3])
			idle = 0.0
		elif Game.input_locked:
			idle = 0.0
		else:
			idle += 0.12
			if idle > 0.8:
				break
	print("autoplay: finished '", label, "' after ", snapped(elapsed, 0.1), "s")
