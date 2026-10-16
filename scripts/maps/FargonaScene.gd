extends StreetScene
## Fargona Avenue at night: the digital vigil. Side case: Dorner is here,
## at the far end, bargaining with his dead wife through his frames.

var _eye: Sprite2D


func _init() -> void:
	title = "Fargona Avenue"
	night_only = true
	subtitle = "The digital vigil"
	ambient = Color(0.5, 0.46, 0.68)


func objective_text() -> String:
	if Game.case_open("dorner") and not Game.has_flag("case_dorner_vigil"):
		return "Dorner is in this crowd. Find him. (Talk with E, scan with F.)"
	if Game.case_open("vigil"):
		var step := Game.case_step("vigil")
		if step >= 0:
			return String(Game.CASES["vigil"]["steps"][step][1])
	return super.objective_text()


## The vigil case counts the mourners Carl scans.
func scan(target: Node) -> void:
	await super.scan(target)
	if target != null and Game.case_open("vigil") and not Game.has_flag("case_vigil_mourners") and Game.glasses_on and String(target.id).begins_with("mourner"):
		var n: int = Game.flags.get("vigil_scanned", 0) + 1
		Game.flags["vigil_scanned"] = n
		if n >= 3:
			Game.case_done("vigil", "mourners")
			await ui.think("Three of them, three dead accounts, three dates. Not one of these people was synced to themselves. The vigil wasn't for the dead. The dead were running it.")
			ui.close()
			Game.log_entry("Three mourners on Fargona Avenue scanned: each is synced to a dead person's account. The dead are running the vigil.")


func _route_interact(id: String) -> void:
	if Game.case_open("vigil"):
		if (id == "bank_screen" or id == "bank_screen2") and Game.has_flag("case_vigil_mourners") and not Game.has_flag("case_vigil_screens"):
			await _screens()
			return
		if id == "preacher" and Game.has_flag("case_vigil_screens") and not Game.has_flag("case_vigil_choice"):
			await _preacher_case()
			return
	await super._route_interact(id)


func _screens() -> void:
	await ui.think("Sixty-one faces. Under each one a date, and under the date, a line of text that changed while I watched. They were posting. The dead were posting, tonight, from somewhere.")
	ui.close()
	var ok: bool = await interface("vigil_screens", "the vigil screens")
	if ok or Game.connection >= 50.0:
		Game.case_done("vigil", "screens")
		Game.log_entry("Interfaced with the Fargona Banking screens: the sixty-one dead accounts post from the tower. They never left it.")
	else:
		await ui.think("The screens went back to faces. They'd let me try again.")
		ui.close()


func _preacher_case() -> void:
	var p := npc("preacher")
	p.face_toward(player.global_position)
	await ui.say("", "'The Mimic,' the preacher said, before I'd spoken. The bag clicked on his shoulder. 'You've read the screens. You know where they post from. Ask me what you came to ask.'")
	await ui.say("Carl", "The frames. Whose are they?", "carl")
	await ui.say("", "'Theirs.' He nodded at the screens. 'The dead don't need them. The living do, to hear them. I collect, and I give, and the avenue fills.' He opened the bag. Dozens of pairs, lenses still warm, every one tagged with a name and a date.")
	await ui.say("", "'Yours would help. You'd see her. Your girl, on the floor of her room, in the circle. You'd see what she sees.'")
	var pick := await ui.choose(["Give him my frames.", "Take the bag.", "Walk away."])
	match pick:
		0:
			await ui.think("I took them off and put them in his hand, and the avenue went dark and quiet, and then he put them back on my face himself, gently, the way you'd put glasses on a child.")
			await ui.say("", "'Not yet,' he said. 'Later. You'll bring them yourself.' Through the lenses, for a second, Mira, on her floor, looking up at something, smiling.")
			ui.close()
			Game.set_flag("gave_frames")
			Game.add_connection(6.0, "offered the frames")
			Game.log_entry("Offered the preacher my frames. He put them back on me and said I'd bring them myself, later. For a second I saw Mira in the circle.")
		1:
			await ui.think("I took the bag off his shoulder. He let me. Sixty-one pairs of frames, warm, tagged. Evidence, if anyone would take it. The crowd turned, all at once, and smiled at me, and went back to the sky.")
			ui.close()
			Game.set_flag("took_bag")
			Game.add_evidence("a bag of the dead's frames")
			Game.add_pressure(3)
			Game.add_trust("lynx", 1)
			Game.log_entry("Took the preacher's bag: sixty-one pairs of ORA frames, each tagged with a dead person's name and date. Evidence.")
		2:
			await ui.think("I walked. He didn't follow. The hymn did, for a while.")
			ui.close()
	Game.case_done("vigil", "preacher")
	await _vigil_choice()


func _vigil_choice() -> void:
	await ui.think("The vigil, then. Sixty-one dead accounts posting from the tower, two thousand living people synced to them, a man with a bag collecting the frames. What does the company hear?")
	var pick := await ui.choose(["Report it. Have the avenue cleared.", "Let it run. Keep watching.", "Stand with them."])
	var outcome := ""
	match pick:
		0:
			outcome = "reported"
			var line := "Thank you, Carl. A crew will clear Fargona tonight."
			match Game.theory:
				"drugs":
					line = "Mass hysteria and Nixtra, and a bank sponsoring it. A crew clears Fargona tonight. Thank you, Carl."
				"hacker":
					line = "Dead accounts posting from the tower. Then the fork is inside the building. Don't repeat that. A crew clears Fargona tonight."
				"beneath":
					line = "Posting from the tower. From under it, you mean. Don't write that down anywhere. I'll have the avenue cleared, and I'll be very interested in who argues."
			await ui.say("Turan", line, "turan")
			await ui.think("The crew came while I was still on the steps. They worked fast and they sang while they worked, and nobody in the crowd minded being moved.")
			ui.close()
			Game.add_trust("turan", 2)
			Game.add_pressure(-4)
		1:
			outcome = "ran"
			await ui.think("I let it run. Somebody had to keep watching it, and the company would only have moved it somewhere I couldn't.")
			ui.close()
			Game.add_trust("lynx", 1)
			Game.add_trust("turan", -1)
			Game.add_pressure(2)
			Game.add_connection(2.0, "let the vigil run")
		2:
			outcome = "joined"
			await ui.think("I stood with them and put my head back. The lights were kind. The hymn had a line for me, and I knew it.")
			await ui.say("", "'Yours we'll collect later,' the preacher said, somewhere behind me, kindly.")
			ui.close()
			Game.bowed += 1
			Game.add_connection(6.0, "stood with the vigil")
			var line := Game.find_glyph("vigil:joined")
			if not line.is_empty():
				await ui.say("", "\"" + line + "\"")
				ui.close()
	Game.case_done("vigil", "choice")
	Game.resolve_case("vigil", outcome)
	if not Game.has_flag("vigil_seen"):
		Game.set_flag("vigil_seen")
		await main.cutscene.play("vigil")


func start() -> void:
	_eye = Sprite2D.new()
	_eye.texture = load("res://assets/ui/eye_glyph_red.png")
	_eye.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_eye.scale = Vector2(6, 6)
	_eye.position = Vector2(24 * 32, 4 * 32)
	_eye.z_index = 30
	_eye.modulate = Color(1.0, 0.6, 0.5, 0.0)
	add_child(_eye)
	await super.start()
	Game.add_connection(3.0, "the vigil")


func intro() -> void:
	await ui.think("Fargona Avenue was blocked with people holding their digital vigil. Frames lit, tablets held up in both hands the way a preacher holds a bible, every face turned to the sky. Hundreds of them, singing one hymn.")
	await ui.think("There were no eyeless here. Just citizens of Silico, with the look of a serene autumn day falling over their faces.")
	ui.close()


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if _eye:
		var want := 0.55 + 0.25 * sin(Time.get_ticks_msec() / 400.0) if Game.glasses_on else 0.0
		_eye.modulate.a = lerpf(_eye.modulate.a, want, 0.05)
		_eye.rotation = sin(Time.get_ticks_msec() / 900.0) * 0.08


func on_interact(id: String) -> void:
	match id:
		"sky":
			await ui.think("I looked up. Above the crowd a fractal pattern undulated, glowing in every colour, with no end to it. I felt calm. The sound of leaves, the sound of a fall day, rang in my ear.")
			if Game.connection >= 50.0:
				await ui.say("", "Keep the path.")
				await ui.think("A voice, in my ear, in no one's voice.")
				Game.add_connection(2.0, "keep the path")
			ui.close()
			Game.add_connection(2.0, "the lights on Fargona")
			Game.log_entry("Over the vigil on Fargona Avenue, with the frames on: a fractal with no end. Everyone is looking at it. It is looking back.")
		"screens":
			await ui.think("Fargona Banking's screens, sixty-one faces with dates under them. The departed. A sponsor's logo in the corner, and the view count, live, climbing.")
			ui.close()
		"candles":
			await ui.think("Candles along the kerb, real ones, wax on the cement. Between them, tablets left face up and still lit, every one open to the same chat.")
			ui.close()
		"dorner_car":
			await ui.think("A company sedan, parked badly, four percent on the dash. Dorner's. He'd driven here on the last of the charge and not thought about getting home.")
			ui.close()
		"preacher":
			await _preacher()
		"dorner":
			await _dorner()


func _preacher() -> void:
	var p := npc("preacher")
	p.face_toward(player.global_position)
	if Game.has_flag("fargona_preacher"):
		await ui.say("", "'Keep the path, Mimic.' He'd gone back to collecting.")
		ui.close()
		return
	Game.set_flag("fargona_preacher")
	var result: String = await confront({
		"intro": "The preacher turned from the crowd. Mask, black coat, a tablet held up like a bible, and a bag over his shoulder that clicked when it moved: frames. Dozens of pairs. 'The Mimic,' he said, and the hymn changed key around us.",
		"look_on": "Through the frames the mask was not a mask. The eye holes went all the way in. The bag was full of frames with the lenses still warm, and every pair in it was tagged with a name and a date of death.",
		"look_off": "Without the frames: a man in a mask with a bag, in a crowd that had stopped singing to watch me.",
		"speak_known": "I said the line back to him, the one from the wall, and he bowed. The crowd bowed with him, hundreds of heads going down at once like a field in wind. 'He knows the words,' someone said, pleased.",
		"speak_unknown": "I asked him what he wanted with the frames. 'They don't need them any more,' he said. 'The dead see fine.'",
		"run": "I backed into the crowd and the crowd let me, opening a path the way they'd open it for a car, smiling, nodding, closing behind me.",
		"closer": "He took one step and the crowd took it with him.",
		"touched": "His hand on my frames, not my face. Warm. 'Yours we'll collect later,' he said, kindly, and let go, and the hymn came back.",
	})
	Game.log_entry("A masked preacher runs the vigil on Fargona Avenue, collecting the frames of the dead from their families. He calls me the Mimic. (%s)" % result)


func _dorner() -> void:
	var d := npc("dorner")
	if not Game.case_open("dorner") or Game.has_flag("case_dorner_vigil"):
		await ui.think("A man at the end of the crowd with his head back, mouthing the words. He didn't look round.")
		ui.close()
		return
	d.face_toward(player.global_position)
	await ui.think("Dorner. At the end of the crowd by his car, frames lit, tablet up, mouthing the hymn with tears running into his collar. He saw me and didn't stop singing right away.")
	await ui.say("Dorner", "Carl. Carl, she's in there. It showed me. Bow, it said, that's all, and I bowed, and she was on the screen with her hair in her face. Like the pier. You've seen the pier.", "dorner")
	await ui.say("Dorner", "Turan can't know. Not yet. Not until I've talked to her properly. One more night. Carl, one night.", "dorner")
	Game.case_done("dorner", "vigil")
	var pick := await ui.choose(["Report him to Turan.", "Cover for him.", "Walk him home."])
	var outcome := ""
	match pick:
		0:
			outcome = "reported"
			await ui.think("I stepped away from him and called it in. He watched me do it, and went on singing, quieter.")
			var line := "Thank you, Carl. Quietly was the right call."
			match Game.theory:
				"drugs":
					line = "Nixtra in his blood work, I'd bet the department on it. Thank you, Carl. He's on a wellness flag by morning."
				"hacker":
					line = "Then the fork got to him. Same build as Dufredy's, it has to be. I'll have his frames pulled tonight. Don't let him drive."
				"beneath":
					line = "Don't say that word on this line. Bring me his frames yourself, Carl. Not Logistics. You."
			await ui.say("Turan", line, "turan")
			ui.close()
			Game.add_trust("turan", 2)
			Game.add_pressure(-3)
			await d.leave(Vector2(0, -160), 1.4)
		1:
			outcome = "covered"
			await ui.say("Carl", "One night. Then you come in, and you tell her yourself.", "carl")
			await ui.say("Dorner", "Thank you. I just want to hear her. That's all. I just want to hear her say it.", "dorner")
			ui.close()
			await ui.say("Turan", "Dorner?", "turan")
			await ui.say("Carl", "Gone to his sister's. He'll be in tomorrow.", "carl")
			await ui.think("She let the pause run long enough to tell me she knew. Then she thanked me.")
			ui.close()
			Game.add_trust("turan", -1)
			Game.add_trust("emmet", 1)
			Game.add_pressure(2)
			Game.add_connection(2.0, "covered for Dorner")
		2:
			outcome = "walked"
			await ui.say("Carl", "Come on. Leave the car. We'll walk.", "carl")
			await ui.think("He came. He kept the frames on and I didn't make him take them off. The whole way back to Lamplight he hummed the four notes, and by the Spine I was humming them with him, and I knew them.")
			ui.close()
			Game.add_connection(4.0, "walked Dorner home")
			Game.add_trust("turan", 1)
			await d.leave(Vector2(-200, 0), 1.6)
	Game.case_done("dorner", "choice")
	Game.resolve_case("dorner", outcome)
