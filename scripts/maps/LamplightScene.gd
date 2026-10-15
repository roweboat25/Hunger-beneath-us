extends StreetScene
## Lamplight: Dufredy's block. Old towers, a cruiser that never leaves.

func _init() -> void:
	title = "Lamplight"
	subtitle = "Dufredy's block"
	ambient = Color(0.9, 0.84, 0.9)


func intro() -> void:
	await ui.think("Lamplight. Towers from the first boom, when the company still built homes. The lamps the block was named for had been off for years; the frames lit the street for me instead.")
	ui.close()


func on_interact(id: String) -> void:
	match id:
		"neighbour":
			await ui.think("A door with the peephole taped over. From inside, humming. A wordless lullaby, patient, the same four notes.")
			if Game.has_flag("hospital_done"):
				await ui.think("The same four notes Dufredy had hummed. I didn't knock.")
				Game.add_connection(1.0, "the neighbour's lullaby")
			ui.close()
			Game.log_entry("Dufredy's neighbour hums the lullaby behind a taped-over door.")
		"mailboxes":
			await ui.think("Names scratched off half the boxes. Someone had drawn two rings around DUFREDY in marker, then tried to rub them out.")
			ui.close()
		"cruiser":
			await ui.think("The cruiser from the first night, still parked. Engine off, dash cam on. The officer inside was asleep with his mouth open.")
			ui.close()
		"officer":
			var cop := npc("officer")
			cop.face_toward(player.global_position)
			if Game.has_flag("hospital_done"):
				await ui.say("Officer", "Every camera on this block went down for forty minutes the night your guy ran. Psyonic cameras. You want to tell me that's a coincidence, Drake?", "officer")
				await ui.think("I didn't. He already knew what I'd say.")
				ui.close()
				Game.add_pressure(5)
				return
			await ui.say("Officer", "Media's camped outside the tower. Third one this month. If Psyonic wants my opinion, something in those glasses is cooking people.", "officer")
			await ui.think("Nobody at Psyonic wanted his opinion. That was starting to feel like the problem.")
			ui.close()
		"stairs_sign":
			await ui.think("CANAL WALK, an arrow down. The canal dried the year the desert got in. People still called it the walk.")
			ui.close()
