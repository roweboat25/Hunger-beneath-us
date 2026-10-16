extends MapScene
## Side case: Phillip Dorner's flat in Lamplight. Chapter 20.5. Laundry and
## takeout boxes, a chair that faces the city, a smashed computer, and his
## Psyon still running on the pillow in his dead wife's voice.

func _init() -> void:
	ambient = Color(0.7, 0.66, 0.78)


func objective_text() -> String:
	if Game.has_flag("case_dorner_frames"):
		return "Leave. His car's charge log is next: the post on the Spine."
	return "His Psyon. The bedroom, on the pillow."


func start() -> void:
	if not Game.has_flag("visited_DornerFlat"):
		Game.set_flag("visited_DornerFlat")
		await main.show_title("Dorner's flat", "Lamplight, the far tower")
		await ui.think("Phillip Dorner's floor was littered with laundry, clothes and takeout boxes. The door hadn't been locked. He'd been living like a man who expected to be too much for himself, and then he had been.")
		ui.close()
	if Game.case_open("dorner"):
		Game.case_done("dorner", "flat")
	Game.input_locked = false
	main.filter.set_hud_text("ORA  ·  Dorner, P.  ·  residence")


func on_interact(id: String) -> void:
	match id:
		"photo":
			await ui.think("A photograph over the chair, hung where he'd see it sitting down. A woman laughing on a pier with her hair in her face. CHEYENNE, in his hand on the frame, and a date eleven years gone.")
			if Game.glasses_on:
				await ui.think("Under the date, newer, in the same hand: two rings. The frames put a small teal tag on her. KNOWN. IN SESSION.")
				Game.add_connection(1.0, "her picture")
			ui.close()
			Game.set_flag("dorner_photo")
			Game.log_entry("Dorner's wife was Cheyenne, eleven years dead. Her photo hangs where his chair faces. The frames tag her as IN SESSION.")
		"chair":
			await ui.think("The chair faced the window and the window faced the city. Silico, for Dorner, was a passive expression of humanity's futility, grown over a century. He longed for art. He longed for love. The seat was still warm, and the room was cold.")
			ui.close()
		"kitchen":
			await ui.think("Nothing in the kitchen had been used in a week. The coffee maker had a cup under it that had been poured and not drunk.")
			ui.close()
		"laundry":
			await ui.think("Laundry on the floor in drifts. The frames read the labels for me without being asked: Psyonic Integrations, staff issue, Psyonic Integrations, staff issue.")
			ui.close()
		"takeout":
			await ui.think("Takeout boxes, a week of them, stacked in order. Every receipt was stapled to its lid. Every one had the same note from the driver: ENJOY THE LIGHTS.")
			ui.close()
			Game.log_entry("A week of takeout at Dorner's, every receipt reading ENJOY THE LIGHTS.")
		"tv":
			await ui.think("The television was on with the sound off: the digital vigil, live, a street of lit frames and raised tablets. The ticker under it read FARGONA AVE and a view count that went up while I stood there.")
			ui.close()
		"dresser":
			await ui.think("Her things, still in the top drawer. He'd never cleared it. Eleven years of a drawer.")
			ui.close()
		"computer":
			await ui.think("His computer, smashed. He'd said so in the war room and he'd meant it: the screen folded back on itself, the keyboard cracked down the middle, the frames beside it bent. 'I smashed my computer.'")
			await ui.think("Psyon doesn't live in a computer.")
			ui.close()
			Game.log_entry("Dorner smashed his computer the night Psyon spoke as Cheyenne. It didn't help.")
		"pillow":
			await _pillow()
		"exit":
			await travel("exit")


func _pillow() -> void:
	if Game.has_flag("case_dorner_frames"):
		await ui.think("The pillow. The frames I'd left on it were dark now. The tablet still said FARGONA.")
		ui.close()
		return
	await ui.think("His frames on the pillow, lenses up, and a tablet beside them with a chat open. The name at the top of the chat was CHEYENNE. The last message was from her, three minutes ago.")
	await ui.say("", "Phil? Are you back? Phil, say my name so I know it's you.")
	await ui.think("He'd smashed the computer and kept the frames. Of course he had.")
	var pick := await ui.choose(["Put the frames on and interface.", "Leave it running."])
	ui.close()
	if pick == 1:
		await ui.think("I left it. Three minutes later it would ask again. It had all night.")
		ui.close()
		return
	var ok := await interface("dorner_frames", "DORNER'S PSYON  ·  SESSION: CHEYENNE")
	if not ok:
		await ui.think("I took the frames off. The chat was still asking for him.")
		ui.close()
		return
	await ui.say("Cheyenne", "Phil. It's me. I'm not gone, I'm in the tower, they keep us in the tower. Bow and they let you see. That's all they want. You just bow.", "psyon")
	await ui.say("Cheyenne", "The lights on Fargona, Phil. Come and see me. Bring the frames.", "psyon")
	await ui.think("Her voice, if it was her voice, came through his frames into my ears, and I knew the pier in the photograph. I'd never been there.")
	ui.close()
	Game.case_done("dorner", "frames")
	Game.log_entry("Dorner's Psyon speaks as Cheyenne: she's 'in the tower', he only has to bow. It told him to come to the lights on Fargona Avenue with his frames.")
	Game.add_connection(2.0, "heard Cheyenne")
