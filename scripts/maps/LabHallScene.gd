extends MapScene
## Act 2, scene 1 (book ch. 10): the entrance hall of the facility behind
## the mirror. The obsidian eye in the floor, twenty-five-year-old Ionware
## monitors, an American flag, and Lynx in an old office chair.


func _init() -> void:
	ambient = Color(0.62, 0.66, 0.72)


func objective_text() -> String:
	if not Game.has_flag("lab_lynx"):
		return "Lynx. By the desk, in the chair."
	return "The lift down. Top right."


func waypoint_id() -> String:
	return "lynx" if not Game.has_flag("lab_lynx") else "lift"


func start() -> void:
	main.filter.set_hud_text("ORA  ·  no signal  ·  recording")
	if not Game.has_flag("visited_LabHall"):
		Game.set_flag("visited_LabHall")
		Game.input_locked = true
		await main.show_title("The Facility", "behind the mirror")
		await ui.think("The cold metal floor gave me no comfort as my skin grazed it. I got to my feet and took in my surroundings.")
		await ui.think("Yes, the obsidian eye was the most prominent feature, but there was more. Old Ionware monitors, I would say about twenty-five years old. An American flag hung on the wall.")
		await ui.think("I hadn't seen one since the war. Since childhood. Since my parents left for Silico. Since my brother broke my arm.")
		await ui.think("Is this a military facility? I'm surprised the lights still worked.")
		ui.close()
	Game.input_locked = false


func on_interact(id: String) -> void:
	match id:
		"monitors", "monitors2":
			await ui.think("Ionware. Nobody had made an Ionware monitor in twenty-five years and every one of these was on, and every one of them was showing the same thing. Two rings. No pupil.")
			ui.close()
			if not Game.has_flag("lab_monitors"):
				Game.set_flag("lab_monitors")
				Game.log_entry("The facility's entrance hall: Ionware monitors a quarter of a century old, all on, all showing the eye.")
				Game.add_connection(1.0, "the monitors")
		"flag":
			await ui.think("An American flag, the colours gone to dust. The last one I'd seen had been on my brother's coffin. The company had sent a car to the funeral. It had waited outside with the engine running.")
			ui.close()
		"desk":
			if Game.has_flag("lab_visitor_book"):
				await ui.think("The visitor book. I didn't want to read my own handwriting again.")
				ui.close()
				return
			Game.set_flag("lab_visitor_book")
			await ui.think("A visitor book, the paper kind, open on the desk. Decades of names, each with two rings drawn beside it in the same hand.")
			await ui.think("The last line was dated three days ago. The name was mine. The handwriting was mine.")
			ui.close()
			Game.add_connection(3.0, "the visitor book")
			Game.log_entry("The facility's visitor book: my name, in my handwriting, dated three days ago. I have never been here.")
			Game.add_evidence("A page torn from the facility's visitor book")
		"racks":
			await ui.think("Server racks. Warm. Something down here had never once been switched off.")
			ui.close()
		"chair":
			await ui.think("An old office chair, still turning slowly on its stalk, the way a chair turns when somebody has just got out of it.")
			ui.close()
		"eye_floor":
			await main.filter.flash(0.12)
			await ui.think("The obsidian eye. Black glass set into the metal floor, two rings, and where the pupil should have been, a hole. The glass was warm.")
			ui.close()
			Game.add_connection(1.0, "the obsidian eye")
		"lynx":
			await _lynx()
		"lift":
			if not Game.has_flag("lab_lynx"):
				await ui.think("The lift. Lynx first. She'd called my name the way you call someone you'd thought was dead.")
				ui.close()
				return
			await ui.think("The lift only knew one number. Minus one.")
			ui.close()
			await travel("lift")
		"sealed":
			await ui.think("The doorway I'd come through from the mirror chamber had a door in it now, and the door had no handle on this side.")
			ui.close()


var _lynx_busy := false


func _lynx() -> void:
	if _lynx_busy:
		return
	if Game.has_flag("lab_lynx"):
		await ui.say("Lynx", "The lift's over there. Come on.", "lynx")
		ui.close()
		return
	Game.input_locked = true
	_lynx_busy = true
	await ui.say("Lynx", "CARL!", "lynx")
	await ui.think("She said it with care, like I was a friend she hadn't seen in months, not a coworker helping her unravel a mystery.")
	await ui.think("The thought lingered that something seemed off. I pushed it away.")
	await ui.say("Lynx", "I was trying to boot up a PC downstairs when I heard you scream. Are you hurt? You were in there an hour.", "lynx")
	var pick := await ui.choose(["\"An hour?\"", "\"What did you see down there?\"", "\"You look different.\""])
	match pick:
		0:
			await ui.say("Carl", "An hour? I walked up to the glass and it went dark. That's all.", "carl")
			await ui.say("Lynx", "An hour and ten. I timed it. I didn't go in. I'm not going in.", "lynx")
		1:
			await ui.say("Carl", "What did you see down there?", "carl")
			await ui.say("Lynx", "An office. Monitors. A whiteboard with a list on it. Nothing that explains Dufredy. Yet.", "lynx")
			Game.add_trust("lynx", 1)
		2:
			await ui.say("Carl", "You look different.", "carl")
			await ui.say("Lynx", "You look like you've been crying, so we're even. Come on.", "lynx")
			await ui.think("Her frames were in her pocket. Smashed. I'd seen her smash them. So why could I see the two rings reflected in her eyes?")
			Game.add_connection(2.0, "Lynx's eyes")
			Game.set_flag("lab_noticed_lynx")
	await ui.say("Lynx", "There's a lift. It only goes down. Whatever this place is, the answer's under it.", "lynx")
	ui.close()
	Game.set_flag("lab_lynx")
	Game.log_entry("Lynx was waiting in the entrance hall. She says I was in the mirror chamber an hour. She had been downstairs already.")
	var l := npc("lynx")
	if l:
		await l.leave(Vector2(96, -220), 1.4)
	Game.input_locked = false
