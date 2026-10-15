extends MapScene
## Scene 5: SalTech Hospital, far south side. Chapter 4, the interview.

var _checked_in := false
var _nurse_done := false
var _interviewed := false


func start() -> void:
	await main.show_title("SalTech Hospital", "Far south side")
	await ui.think("A brutal architectural metaphor for Silico itself. Shorter, utilitarian, hunkered down against the encroaching desert. More factory than place of healing.")
	ui.close()
	main.filter.set_hud_text("ORA  ·  SalTech  ·  check in at reception")


func on_interact(id: String) -> void:
	match id:
		"bot":
			await _bot()
		"screens":
			await ui.think("Several screens, each broadcasting a similar reception bot. The Platonic ideal of an uninspired hospital waiting room.")
			ui.close()
		"nurse":
			await _nurse()
		"room_door":
			if not _nurse_done:
				await ui.think("The nurse was still finishing his chart. I'd wait for her.")
				ui.close()
				player.position += Vector2(-20, 0)
			elif not _interviewed:
				await ui.think("The blinds were drawn tight, cloaking the room in a dim, cave-like gloom. Thick gauze pressed into the empty hollows of his eye sockets. And there it was. The smile.")
				ui.close()
		"blinds":
			await ui.think("Drawn tight, despite the midday sun. It felt intentional.")
			ui.close()
		"dufredy":
			await _dufredy()
		"exit":
			await _try_leave()


func _bot() -> void:
	if _checked_in:
		await ui.say("Reception", "If you need immediate emergency assistance, press the immediate help button below.", "bot")
		ui.close()
		return
	await ui.say("Carl", "Carl Drake, here to interview Harold Dufredy.", "carl")
	await ui.say("Reception", "We've been expecting you, Mr. Drake. Please wait a moment while we contact an associate.", "bot")
	await ui.say("Reception", "If you need immediate emergency assistance, press the immediate help button below.", "bot")
	await ui.think("Precisely five minutes later, a nurse entered, her stride hesitant, her uniform crisp and new.")
	ui.close()
	_checked_in = true
	var nurse := npc("nurse")
	nurse.position = Vector2(11 * 16 + 8, 8 * 16 + 8)
	nurse.face("left")
	main.filter.set_hud_text("ORA  ·  SalTech  ·  the nurse will walk you in")


func _nurse() -> void:
	var nurse := npc("nurse")
	nurse.face_toward(player.global_position)
	if not _checked_in:
		await ui.say("Nurse", "Reception first, please.", "nurse")
		ui.close()
		return
	if _nurse_done:
		await ui.say("Nurse", "I'll wait outside. Corporate policy.", "nurse")
		ui.close()
		return
	await ui.say("Nurse", "Welcome, Carl. I'll walk you to Mr. Dufredy's room. He's in an extremely fragile state. Please don't expect much. He hasn't said anything since he arrived yesterday.", "nurse")
	await ui.say("Nurse", "And worse... no one has come to visit him. You'd think someone would, wouldn't you? But people forget fast these days. They scroll past and move on. That's the problem with 'empathy at scale'.", "nurse")
	var pick := await ui.choose(["Describe his behaviour since he's been here.", "Has he spoken to FreudBot?"])
	if pick == 0:
		await ui.say("Nurse", "Honestly, we've had him pretty heavily sedated. In his brief moments of consciousness, he's just been smiling. It's... unnerving. The sedation should be wearing off soon.", "nurse")
	else:
		await ui.say("Nurse", "He hasn't even spoken to FreudBot yet, poor thing. It's programmed for therapeutic dialogue, but even it is having trouble breaking through.", "nurse")
	await ui.think("Her AR glasses flickered, a subtle flash of red, like a preprogrammed alert. Her posture became more formal.")
	await ui.say("Nurse", "This is it. I can wait outside if it's required under corporate policy.", "nurse")
	await ui.say("Carl", "That would be best.", "carl")
	ui.close()
	_nurse_done = true
	nurse.position = Vector2(17 * 16 + 8, 7 * 16 + 8)
	nurse.face("up")
	Game.log_entry("Nurse: Dufredy sedated, smiling, no visitors. Hasn't spoken to FreudBot.")
	main.filter.set_hud_text("ORA  ·  SalTech  ·  room at the end of the corridor")


func _dufredy() -> void:
	if _interviewed:
		await ui.think("He was humming. A wordless lullaby, ancient and alien. I didn't have the stomach for a second round.")
		ui.close()
		return
	await ui.think("Dufredy lay strapped to the bed, a mummy cocooned in restraints. His breathing was unnervingly slow, like a child pretending to sleep, suppressing a giggle.")
	await ui.say("Carl", "Mr. Dufredy. I'm with Psyonic Corp. I'm here to understand what happened at the park yesterday.", "carl")
	await ui.think("He remained utterly still. But the smile. That persistent, placid smile remained.")
	await ui.say("Carl", "I want to know what you were talking about. Why did you do this to yourself? I know you can hear me.", "carl")
	await ui.think("The smile widened, blooming across his face like a horrific aurora. His bandaged head tilted slightly, antenna-like, tuning into a signal only he could perceive.")
	await ui.say("Dufredy", "Carl Drake. The passenger who forgot how to drive.", "dufredy")
	await ui.say("Carl", "I... I didn't tell you my name.", "carl")
	await ui.say("Dufredy", "You did. Not with your mouth, Carl. You carry your name like a badge. You all do.", "dufredy")
	await ui.say("Dufredy", "But I'm not here to answer your questions. I've given enough. The rest... you'll need to see for yourself.", "dufredy")
	await ui.say("Carl", "See? Mr. Dufredy, you have no eyes.", "carl")
	await ui.say("Dufredy", "That's what made it possible.", "dufredy")
	Game.add_connection(1.0, "Dufredy knew my name")
	var asked := 0
	while asked < 3:
		var options := ["Why take your eyes?", "Who is the masked man?", "Show him the laptop.", "What makes someone ready?"]
		var pick := await ui.choose(options)
		asked += 1
		match pick:
			0:
				await ui.say("Carl", "Why did you do it? Why take your eyes?", "carl")
				await ui.say("Dufredy", "You don't pluck out sight. You shed it. Like skin. Like lies.", "dufredy")
			1:
				await ui.say("Carl", "Why Psyonic? Who else was involved? The masked man? The symbol?", "carl")
				await ui.say("Dufredy", "There are others. The masked man. The symbol.", "dufredy")
				await ui.think("He spoke of them as easily as naming street corners. Then silence. He became a wall.")
			2:
				await _show_laptop()
			3:
				await ui.say("Carl", "You keep saying I'm not ready. What makes someone ready?", "carl")
				await ui.say("Dufredy", "Ruin and Reflection. Mimicry. A clean wound. Something has to break first.", "dufredy")
				Game.add_connection(1.0, "ruin and reflection")
				Game.log_entry("Dufredy: 'Ruin and Reflection. Mimicry. A clean wound. Something has to break first.'")
	if not Game.has_flag("hospital_laptop"):
		await _show_laptop()
	await ui.say("Carl", "You're enjoying this.", "carl")
	await ui.say("Dufredy", "Of course I am. It's beautiful, Carl. You don't understand yet. But you will. You've already started to feel it.", "dufredy")
	await ui.say("Carl", "Do you remember this?", "carl")
	await ui.say("Dufredy", "The altar in your lap.", "dufredy")
	await ui.say("Carl", "Psyon?", "carl")
	await ui.say("Dufredy", "Psyon is the mask. It goes by many names.", "dufredy")
	await ui.say("Dufredy", "Take it back to the city. Bring it in front of the eye, and you will see. Then you'll have your tool. Your seer stone.", "dufredy")
	await ui.think("He turned away, slowly, like a prophet completing a prophecy. He began to hum. A wordless lullaby, ancient and alien, and it filled the stillness with a palpable sense of... homecoming.")
	await ui.say("Carl", "This isn't over, Dufredy! What is happening to this city? To me?", "carl")
	await ui.think("No answer. I was powerless here, the investigator who had walked into a prepared interrogation. The interview was over.")
	ui.close()
	_interviewed = true
	Game.add_connection(2.0, "the lullaby")
	Game.log_entry("Dufredy: 'Bring it in front of the eye, and you will see. Your seer stone.'")
	main.filter.set_hud_text("ORA  ·  SalTech  ·  leave. Call Lynx.")


func _show_laptop() -> void:
	if Game.has_flag("hospital_laptop"):
		await ui.say("Dufredy", "You're not ready to know.", "dufredy")
		return
	Game.set_flag("hospital_laptop")
	await ui.think("I pulled out his laptop and turned the screen toward him. His bandaged head reflexively oriented toward the familiar glow. Psyon launched instantly.")
	await ui.say("Carl", "Who gave you this version of Psyon? Why won't it respond to anyone else?", "carl")
	await ui.say("Dufredy", "You're not ready to know. You don't have the tools to see it yet, do you?", "dufredy")
	await ui.say("Carl", "What tools?", "carl")
	await ui.think("Silence. I needed to change my approach. Play his game.")


func _try_leave() -> void:
	if not _interviewed:
		await ui.think("I'd come all the way out here. I wasn't leaving without hearing him.")
		ui.close()
		return
	await ui.think("I left the sterile air of the hospital feeling not just faint, but profoundly unclean. An itch crawled beneath my skin, like something foreign had taken root in my throat.")
	await ui.think("A frog. A cough. A signal. Part of me yearned for whatever this was. Another part felt itself fraying.")
	ui.close()
	await main.fade_out(0.8)
	await ui.say("Lynx", "Carl. Did you learn anything from Dufredy?", "lynx")
	await ui.say("Carl", "I need your help. I want you to show me where you saw the symbols on the south side of town.", "carl")
	await ui.say("Lynx", "I'll meet you in front of Southwest Station. Thirty minutes.", "lynx")
	ui.close()
	Game.set_flag("hospital_done")
	await main.change_map("res://scenes/maps/Southtown.tscn")
