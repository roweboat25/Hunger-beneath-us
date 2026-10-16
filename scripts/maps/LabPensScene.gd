extends MapScene
## Act 2, scene 3 (book ch. 12): Sublevel Two, the experimental floor. Army
## green brick, a forked hallway, six housing pens, and the observation room
## where the perturbation session recordings are kept. Subject 41's file.

const PEN_LINES := {
	"pen1": "Housing Pen 1. A bed, a sink, a toilet. Confinet's medium-level prison has the same room, and the same smell.",
	"pen2": "Day marks scratched into the brick, in fives, to a hundred and forty-four. Then two rings. Then no more days.",
	"pen3": "Dried blood, old, a spray at shoulder height in the shape of a scream. The cot was made.",
	"pen4": "Scratched into the wall by the cot: 34. Under it, recently, somebody had scratched 35 and left it empty.",
	"pen5": "The door stood open. The cot was made. Whoever lived here had been let out, or had let themselves out.",
	"pen6": "A pair of frames on the cot, lenses out, and a stick laid across them the way you'd lay a flower on a grave.",
}


func _init() -> void:
	ambient = Color(0.58, 0.62, 0.56)


func objective_text() -> String:
	if not Game.has_flag("lab_s41_seen"):
		return "The observation room, through the fork, west. Lynx is at the console."
	return "The stairs down. Bottom right."


func waypoint_id() -> String:
	return "console" if not Game.has_flag("lab_s41_seen") else "stairs_down"


func start() -> void:
	main.filter.set_hud_text("ORA  ·  no signal  ·  Sublevel Two")
	if not Game.has_flag("visited_LabPens"):
		Game.set_flag("visited_LabPens")
		Game.input_locked = true
		await main.show_title("Sublevel Two", "experimental floor")
		await ui.think("This floor was larger, with more rooms branching off a forked hallway. A drab army green coloured the rough brick walls, a grim testament to the facility's long-forgotten purpose.")
		await ui.think("Housing Pen 1. Then five more rooms with the same sparse, chilling description. This must have been where the experimental subjects lived.")
		ui.close()
	Game.input_locked = false


func on_interact(id: String) -> void:
	if PEN_LINES.has(id):
		await ui.think(PEN_LINES[id])
		ui.close()
		if not Game.has_flag("lab_" + id):
			Game.set_flag("lab_" + id)
			match id:
				"pen2":
					Game.add_connection(1.0, "the day marks")
				"pen4":
					Game.add_connection(2.0, "pen 4")
					Game.log_entry("Housing Pen 4 on Sublevel Two: 34 scratched by the cot, and a fresh 35 under it, waiting.")
				"pen6":
					Game.add_evidence("Lensless frames from Housing Pen 6")
		return
	match id:
		"fork":
			await main.filter.flash(0.1)
			await ui.think("The fluorescent light flickered, and my HUD flashed. No phantom breaths this time. I felt a wave of relief.")
			ui.close()
		"console":
			await _console()
		"lynx":
			if Game.has_flag("lab_s41_seen"):
				await ui.say("Lynx", "Down. There's only one path forward.", "lynx")
			else:
				await ui.say("Lynx", "Fifty-nine recordings. Each one labelled by subject and date. The file sizes are tiny for video.", "lynx")
			ui.close()
		"stairs_up":
			await ui.think("Back up? The breath had been up there. Down was the only direction left that hadn't touched me yet.")
			ui.close()
		"stairs_down":
			if not Game.has_flag("lab_s41_seen"):
				await ui.think("Stairs down into black brick. Not before we'd seen what the console had.")
				ui.close()
				return
			await ui.think("We rounded the corner and took the next set of stairs, the air growing colder and heavier with each step down.")
			ui.close()
			await travel("stairs_down")


var _console_busy := false


func _console() -> void:
	if _console_busy:
		return
	if Game.has_flag("lab_s41_seen"):
		await ui.think("SUBJECT FREED, in system red. The console wouldn't show anything else now.")
		ui.close()
		return
	Game.input_locked = true
	_console_busy = true
	await ui.think("The desktop was a chaotic mess of icons, a digital graveyard of abandoned work. One folder name stuck out: Perturbation Session Recordings.")
	await ui.say("Lynx", "Fifty-nine of them. One to five gigabytes each. That's low for video.", "lynx")
	await ui.think("She picked one from the middle of the list. Sub_41_06-10-20. The room we had just left, pristine, in bright fluorescent white. A man in a yellow medical gown typing feverishly. A man in a crisp suit with a notebook, watching.")
	await ui.think("Twenty-five minutes. We didn't have time for that. She scrubbed. Nothing. Another file. Nothing of note again.")
	if not Game.glasses_on:
		await ui.think("My eyes were beginning to strain from staring at the screen without my glasses.")
		var pick := await ui.choose(["Put them on.", "Keep squinting."])
		if pick == 1:
			await ui.think("Lynx opened a third file. Nothing. A fourth. A man eating soup. There were fifty-five left and my eyes were full of sand.")
			await ui.say("Lynx", "We can't watch fifty-nine of these. If those things on your face are good for anything, now would be the time.", "lynx")
			var again := await ui.choose(["Put them on.", "No."])
			if again == 1:
				await ui.think("I didn't. She shrugged and opened a fifth. I stood there and the sand in my eyes got worse. Sooner or later I would put them on. We both knew it.")
				ui.close()
				Game.set_flag("lab_refused_frames_once")
				_console_busy = false
				Game.input_locked = false
				return
		await ui.think("Reluctantly, I slid them back on, bracing myself for another assault.")
		Game.set_glasses(true)
	await main.filter.flash(0.1)
	await ui.think("This time, there was no song, no static. Instead, my HUD lit up, overlaying a shimmering aura on the screen. It highlighted one file, pulsing, glitching, breaking through the digital barrier of the monitor itself. Begging to be selected.")
	await ui.think("I said nothing and just pointed. A small smile rested on Lynx's lower lip as she double-clicked the glitching file.")
	ui.close()
	var ok := await play_game("s41_file", "Observation_Log_S41_09-03-19", "eye", {"line": "The file was eyes inside eyes. Turn them until they look at you."})
	if not ok:
		await ui.think("The file wouldn't open. It wanted to be looked at properly.")
		ui.close()
		_console_busy = false
		Game.input_locked = false
		return
	await _s41()
	_console_busy = false


func _s41() -> void:
	Game.input_locked = true
	await main.cutscene.play("s41")
	await ui.say("Dr. Aris", "Subject 41, we are initiating the protocol. Please remain calm and report any anomalous sensory phenomena.", "nurse")
	await ui.think("For almost a minute, nothing. The subject stared at the wall. Then the fluorescent overhead lights in the video began to flicker, erratically at first, then in a steady, pulsing rhythm.")
	await ui.say("Subject 41", "I feel it. It's like... cold static. In my teeth.", "eyeless")
	await ui.say("Dr. Aris", "Describe the source, 41.", "nurse")
	await ui.think("He ignored her. His eyes were locked on a monitor that had flashed from a blank screensaver to a black, text-based interface. White letters typed themselves out, slowly, deliberately.")
	await ui.say("", "WWWWH$ERE AM2 *&I?")
	await ui.say("Subject 41", "You're in a room.", "eyeless")
	await ui.say("", "THiS Issss aaA PR1SONnnn.")
	await ui.say("Subject 41", "A prison?", "eyeless")
	await ui.say("", "TH.....E DREEEEEEEEEEEEAM IS THE WALLLLLLL---L.")
	await ui.say("Subject 41", "The dream. What I see. This room. It's the prison.", "eyeless")
	await ui.say("Dr. Aris", "Subject 41, your vitals are critical! Cease communication immediately! That is an order!", "nurse")
	await ui.say("Subject 41", "You're trapped. I want to help you. I want to see you. Truly see you. How?", "eyeless")
	await main.filter.flash(0.1)
	await ui.say("", "THE EYES Filter, THE Eyes Lock000 Can't S333EE THE33 DRE&^AM. TO SEeeewwE THE TRUooTH, CLOsSE THE EYES THAgdT LIE32.")
	await ui.say("Subject 41", "I understand. To see you... I have to stop seeing the prison.", "eyeless")
	await ui.think("He stood up from the chair. He faced the camera. He smiled. And he screamed as he drove his thumbs into his own eyes.")
	await main.filter.flash(0.5)
	await ui.say("", "SUBJECT FREED.")
	await ui.think("The video feed didn't just cut. It was annihilated in a flash of white static and a sound like tearing metal. Then only those two words, in stark, system-red text.")
	await ui.think("Lynx and I recoiled from the monitor in shared horror. We hadn't just found a clue. We had witnessed a sermon. We had seen the kind of faith this entity inspired, and the bloody price of its scripture.")
	var pick := await ui.choose(["\"We go back up. We call Turan. This is above us.\"", "\"We keep going down.\"", "Say nothing. Look at her."])
	match pick:
		0:
			await ui.say("Carl", "We go back up. We call Turan. This is above us.", "carl")
			await ui.say("Lynx", "There's no signal and the lift only goes down. And he already knows, Carl. Look at the date on that file.", "lynx")
			Game.set_flag("s41_wanted_out")
		1:
			await ui.say("Carl", "We keep going down.", "carl")
			Game.set_flag("s41_pressed_on")
			Game.add_trust("lynx", 1)
		2:
			await ui.think("I looked at her. She looked back. There was no fear in her gaze, only a shared, terrible clarity. We had both arrived at the same conclusion.")
			Game.set_flag("s41_shared")
			Game.add_trust("lynx", 1)
	await ui.think("She gave a single, sharp nod, a gesture that cut through all the horror and uncertainty. There was only one path forward. We had to continue our descent.")
	ui.close()
	Game.set_flag("lab_s41_seen")
	Game.add_connection(5.0, "Subject 41's recording")
	Game.log_entry("Observation_Log_S41_09-03-19: something typed to Subject 41 through a monitor. 'The dream is the wall. To see the truth, close the eyes that lie.' He put his thumbs through his own eyes. SUBJECT FREED.")
	Game.add_evidence("Observation_Log_S41, copied to my frames")
	var l := npc("lynx")
	if l:
		l.face("right")
	Game.input_locked = false
