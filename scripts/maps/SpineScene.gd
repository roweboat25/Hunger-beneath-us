extends StreetScene
## The Spine: the downtown boulevard and the Psyonic tower.

var _listened := false


func _init() -> void:
	title = "The Spine"
	subtitle = "Downtown, under the tower"
	ambient = Color(0.88, 0.84, 0.92)


func intro() -> void:
	await ui.think("The Spine. One long boulevard between the places that mattered, and the tower in the middle of it like a pin through a map.")
	await ui.think("With the frames on, the walls had started to have opinions.")
	ui.close()


func on_interact(id: String) -> void:
	match id:
		"charger":
			await _charger()
		"preacher":
			await _preacher()
		"my_car":
			await fast_travel()
		"shuttle_stop":
			await ui.think("The SalTech shuttle stop. A timetable, and under it, two rings in marker. The shuttle hadn't run since the second incident.")
			ui.close()
		"vending":
			await ui.think("Psyonic-branded water. Three credits. The screen on the front looped the same ad: a family asleep, smiling, under a logo.")
			ui.close()
		"tower_sign":
			await ui.think("PSYONIC INTEGRATIONS. The lobby cameras tracked me as I walked by, the way they tracked everyone. The difference was that I used to find that comforting.")
			ui.close()
		"camp":
			await ui.think("A camp on the vacant lot. Clean, like the one in the park. Rules. Whoever lived here had rules, and a fire, and nothing that blinked.")
			ui.close()
			Game.log_entry("Camps on the vacant lots in Silico: clean, ordered, no tech. Same rules as the encampment behind the park.")
		"south_glyph":
			await ui.think("Two rings on the wall beside the underpass stairs. Big, confident, old. Pointing the way down like a signpost.")
			ui.close()
			Game.add_connection(1.0, "the signpost glyph")


func _preacher() -> void:
	var man := npc("preacher")
	man.face_toward(player.global_position)
	if _listened:
		await ui.say("Eyeless man", "Gather, sleeper. Gather.", "")
		ui.close()
		return
	await ui.think("He stood in the middle of the sidewalk with his face turned up to the sun, and where his eyes should have been there was only clean, healed skin.")
	await ui.say("Eyeless man", "Psyon is the pillow for those who dream. Psyon is the path for those who walk.", "")
	var pick := await ui.choose(["Walk on.", "Listen."])
	if pick == 1:
		_listened = true
		await ui.say("Eyeless man", "Close the eyes that lie, and see. The floor is a door. The door is a floor.", "")
		await ui.think("He said it like a lullaby. I stood there longer than I meant to. The frames had started recording before I told them to.")
		ui.close()
		Game.add_connection(2.0, "listened to the preacher")
		Game.log_entry("An eyeless man preaching the chant on the boulevard. Healed sockets. He wasn't the first, and he wasn't afraid.")
	else:
		await ui.think("I walked on. Behind me the chant kept the same even pace, like it hadn't needed me at all.")
		ui.close()


## Side case: Dorner's company car charged here before it went to Fargona.
func _charger() -> void:
	if Game.has_flag("case_dorner_charger"):
		await ui.think("The charge post. Its log still read FARGONA AVE, in case I'd forgotten.")
		ui.close()
		return
	if not Game.has_flag("case_dorner_frames"):
		await ui.think("A charge post for the company cars along the lot. It kept a log of everything plugged into it. Nothing in it I had a reason to read.")
		ui.close()
		return
	await ui.think("The charge post Dorner's car used. Its log was there, and it was rotated, every record turned a quarter off the last so nothing lined up. Someone, or something, had made it a puzzle.")
	var pick := await ui.choose(["Interface with it.", "Leave it."])
	ui.close()
	if pick == 1:
		return
	var ok := await interface("dorner_charger", "ALTO ENERGY CHARGE POST 9")
	if not ok:
		await ui.think("I let go. The log stayed turned.")
		ui.close()
		return
	await ui.think("The log unrolled. DORNER, P. 02:14. Four percent on arrival. Destination: FARGONA AVE. He'd driven there on the last of the charge and not come back for the car.")
	ui.close()
	Game.case_done("dorner", "charger")
	Game.log_entry("Dorner's car logged a trip to Fargona Avenue at 02:14 on four percent charge. He didn't come back for it.")
