extends MapScene
## Scene 9a: the desert, the abandoned sedan, the door in the cliff.

var _sedan_done := false
var _at_door := false


func _init() -> void:
	ambient = Color(1.0, 0.9, 0.72)


func start() -> void:
	await main.show_title("The sand flats", "Restricted zone")
	await ui.think("The road cracked beneath my wheels. The horizon opened. Sand and silence swallowed everything. My ORA-frames flickered. Not a glitch. A filter. A signal shift. It was watching me.")
	await ui.think("The coordinates pinged. Perched at the edge of a rocky bluff: a Psyonic-issued sedan. No sand on the tires. No dust on the windshield. Recently abandoned.")
	await ui.say("Carl", "Lynx.", "carl")
	ui.close()
	main.filter.set_hud_text("ORA  ·  signal shift  ·  the sedan")


func on_interact(id: String) -> void:
	match id:
		"my_car":
			await ui.think("The corporate bubble of sanity. I could still get back in and drive home.")
			var pick := await ui.choose(["Stay.", "Drive home."])
			if pick == 1:
				await ui.think("I sat with the engine running for a full minute. Then I got out again. The path had already begun.")
				Game.add_connection(1.0, "couldn't leave")
			ui.close()
		"sedan":
			await _sedan()
		"door_approach":
			await _approach()
		"door":
			await _door()


func _sedan() -> void:
	if _sedan_done:
		await ui.think("A faint trace of her perfume, already vanishing into the heat.")
		ui.close()
		return
	await ui.think("I circled the vehicle slowly, hand hovering near my sidearm, half-expecting movement behind the tinted glass. Nothing. I opened the door.")
	await ui.think("No signs of a struggle. No blood. No bag. No tablet. Not even a coffee cup. Just a faint trace of her perfume. Something citrusy, distant, like memory evaporating.")
	var pick := await ui.choose(["Check the glove compartment.", "Check the dashboard.", "Check the mirror."])
	match pick:
		0:
			await ui.think("Empty.")
		1:
			await ui.think("Clean. Logs wiped. The center console blinked once, then dimmed, rebooting on a loop.")
		2:
			pass
	await ui.think("The only thing out of place: a fingerprint, smudged faintly on the rearview mirror. I touched it reflexively. Panic. Guilt. Something else.")
	await ui.say("Carl", "She was here. And now she isn't.", "carl")
	await ui.think("I looked out over the bluff, and saw it. The door. Carved into the cliffside. No handles. No keypad. Just the Eye, scorched into the metal like a scar. Waiting.")
	ui.close()
	_sedan_done = true
	Game.log_entry("Lynx's sedan abandoned at the bluff, logs wiped. A door in the cliff with the Eye scorched into it.")
	main.filter.set_hud_text("ORA  ·  signal shift  ·  the door")


func _approach() -> void:
	if not _sedan_done:
		await ui.think("The sedan first. If Lynx was out here, the car would say so.")
		ui.close()
		player.position += Vector2(-24, 0)
		return
	_at_door = true
	Game.input_locked = true
	await ui.think("Each footfall felt rehearsed. Then: static.")
	ui.close()
	await main.filter.flash(0.1)
	Game.set_glasses(false)
	await ui.think("My ORA-frames shut down. A scream of digital distortion ripped through my skull. I tore the glasses off. Silence.")
	await ui.think("I thought of Lynx. I thought of Mira, her voice bent and warped by the machine.")
	var pick := await ui.choose(["Put the glasses back on.", "Leave them off."])
	ui.close()
	if pick == 1:
		await ui.think("Without them the door was just a door. Metal in rock. No voice. No Eye. I stood there until the sun had moved, and then I put them on anyway, because the path had already begun.")
		Game.set_flag("hesitated_at_door")
	Game.set_glasses(true)
	await main.filter.flash(0.1)
	await ui.say("???", "BOW, SLEEPER.", "psyon")
	await ui.say("Carl", "Who are you?", "carl")
	await ui.think("A breath touched the back of my neck.")
	await ui.say("???", "BOW!", "psyon")
	await ui.think("The word detonated in my ear. My legs buckled. My knees hit the dust.")
	ui.close()
	Game.add_connection(2.0, "bowed")
	await main.filter.flash(0.2)
	set_object_tile(Vector2i(33, 8), Vector2i(7, 5))
	await ui.think("The door slid open.")
	ui.close()
	main.filter.set_hud_text("ORA  ·  ???  ·  walk in")


func _door() -> void:
	if not _at_door:
		await _approach()
		return
	await ui.think("I walked in. Because the path had already begun.")
	ui.close()
	Game.set_flag("desert_done")
	await main.change_map("res://scenes/maps/Mirror.tscn")
