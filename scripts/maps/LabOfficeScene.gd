extends MapScene
## Act 2, scene 2 (book ch. 11): Sublevel 1. A small office with a whiteboard
## still smudged from decades ago and five ancient Ionware desktops, the
## sleeping quarter, the gym, two doors that don't open, and a breath against
## Carl's left ear.


func _init() -> void:
	ambient = Color(0.6, 0.63, 0.68)


func objective_text() -> String:
	if not Game.has_flag("lab_whiteboard"):
		return "The office. The whiteboard on the left."
	if not Game.has_flag("lab_hameron"):
		return "The terminal Lynx got working. The lit desktop."
	return "The stairs down to Sublevel Two. Bottom left."


func waypoint_id() -> String:
	if not Game.has_flag("lab_whiteboard"):
		return "whiteboard"
	if not Game.has_flag("lab_hameron"):
		return "hameron"
	return "stairs"


func start() -> void:
	main.filter.set_hud_text("ORA  ·  no signal  ·  Sublevel 1")
	if not Game.has_flag("visited_LabOffice"):
		Game.set_flag("visited_LabOffice")
		Game.input_locked = true
		await main.show_title("Sublevel 1", "the office floor")
		await ui.say("Lynx", "Looks like an old DARPA research site. Could be early AI development, could be worse. The office is through here.", "lynx")
		await ui.think("A whiteboard still smudged with marker from decades ago. Five ancient Ionware desktops lined against the far wall. Lynx moved with purpose. I appreciated her fire.")
		ui.close()
	Game.input_locked = false


func on_interact(id: String) -> void:
	match id:
		"whiteboard":
			await _whiteboard()
		"pc1", "pc2", "pc5":
			await ui.think("An Ionware desktop, booted to a screensaver: the eye, turning slowly, on a beige machine that should have died before I was born.")
			ui.close()
		"pc4":
			await ui.think("Dead. The only one of the five that was. Somebody had put a boot through the tower.")
			ui.close()
		"hameron":
			await _hameron()
		"report":
			await ui.think("A fat folder. DARPA on one tab, Psyonic on the other. First slide: the two logos, side by side. CONTACT FIELD PERTURBATION REPORTING.")
			await ui.think("If Psyonic was tied to DARPA, to pre-war contact experiments, then everything, the Fork, the frames, Dufredy, was older than the company that sold it to me.")
			ui.close()
			if not Game.has_flag("lab_report"):
				Game.set_flag("lab_report")
				Game.log_entry("A DARPA and Psyonic joint report in the Sublevel 1 office: Contact Field Perturbation Reporting. The company inherited this place.")
				Game.add_evidence("DARPA / Psyonic report, first page")
		"bunk1", "bunk3", "bunk4":
			await ui.think("A steel bunk, recently slept in. Stale air, and under it something sweet, like a hospital.")
			ui.close()
		"bunk2":
			await ui.think("Frames on the pillow. Not ORA. Older. Wire and glass, with the two rings etched where a logo would go. They were warm.")
			ui.close()
			if not Game.has_flag("lab_old_frames"):
				Game.set_flag("lab_old_frames")
				Game.add_evidence("Pre-war frames from the sleeping quarter")
				Game.add_connection(2.0, "the old frames")
		"gym":
			await ui.think("A weights rack. Every plate was stamped with the eye instead of a number. You lifted what it decided you lifted.")
			ui.close()
		"treadmill":
			await ui.think("A treadmill whose display still counted. DAYS SINCE FIRST RITUAL ATTEMPT: 144. It wasn't counting steps.")
			ui.close()
		"door_a":
			await ui.think("Locked. A card reader with a red light. It did not want my badge.")
			ui.close()
		"door_b":
			await ui.think("LAB. Locked from the inside. Something behind it hummed at the pitch of the lullaby.")
			ui.close()
			if Game.glasses_on and not Game.has_flag("lab_hum"):
				Game.set_flag("lab_hum")
				Game.add_connection(1.0, "the hum behind the lab door")
		"breath":
			await _breath()
		"lynx":
			if Game.has_flag("lab_hameron"):
				await ui.say("Lynx", "Hopefully, the fucking Hypnogogue. Stairs are that way.", "lynx")
			else:
				await ui.say("Lynx", "Give me a minute. The keyboard's missing half its keys.", "lynx")
			ui.close()
		"stairs":
			if not Game.has_flag("lab_hameron"):
				await ui.think("Stairs down. Lynx had the terminal up. I wanted to see what she'd found before we went any deeper.")
				ui.close()
				return
			await ui.say("Lynx", "Sublevel Two. Experimental floor. Hopefully, the fucking Hypnogogue.", "lynx")
			ui.close()
			await travel("stairs")
		"lift":
			await ui.think("The lift only went down from here. The button for the hall didn't light.")
			ui.close()


func _whiteboard() -> void:
	await ui.think("ENCODING. SUBJ 12-31, done. 12-32, done. 12-33, done. 12-34, and three dots.")
	if Game.has_flag("lab_whiteboard"):
		ui.close()
		return
	Game.set_flag("lab_whiteboard")
	if Game.glasses_on:
		await main.filter.flash(0.1)
		await ui.think("And under it, in fresher red, in a hand that hadn't changed in twenty years: 12-35. C. DRAKE. The frames underlined it for me.")
		Game.add_connection(3.0, "the whiteboard")
	else:
		await ui.think("And under it, in fresher red: 12-35. C. DRAKE. I read it twice without the frames so I'd know it was really there.")
		Game.add_connection(1.0, "the whiteboard")
	ui.close()
	Game.log_entry("Sublevel 1 whiteboard: subjects 12-31 to 12-34 encoded. 12-35 is C. DRAKE, added in fresh marker.")


func _hameron() -> void:
	if Game.has_flag("lab_hameron"):
		await ui.think("Hameron's log. I'd read enough.")
		ui.close()
		return
	Game.input_locked = true
	Game.set_flag("lab_hameron")
	await ui.say("Lynx", "Got it. Plain text, no formatting. A series of dated entries. Author listed as: Dr. T. Hameron, Division of Quantum Psychotopography, Clearance Omega-Black.", "lynx")
	await ui.say("", "DREAM INDUCED WAVE COLLAPSE. LOG 1.")
	await ui.say("", "SUBJECT 12-34 | AGE 25 | DAYS SINCE FIRST RITUAL ATTEMPT: 144. Subject continues to exhibit standard pre-contact disruptions. Reports spontaneous waking at 3:03 AM for three consecutive nights.")
	await ui.say("", "Claims an unseen entity is present in the room during REM cycles, attempting \"communication.\" Subject described the voice as \"coming from inside the walls, like breathing through wires.\"")
	await ui.say("", "Notable: Subject refused sedation during follow-up. Reported feeling \"called\" to remain awake. EEG confirmed theta spike synchronous with hallway light anomaly. This constitutes a promising drift. Recommend proceeding to Phase 3: Induced Merge Trial with Contact Field active.")
	await ui.say("Lynx", "'Theta spike synchronous with hallway light anomaly.' They were mapping psychic responses to electrical glitches?", "lynx")
	var pick := await ui.choose(["\"They weren't studying dreams. They were using dreams to access something else.\"", "\"It's a lab notebook from before the war. It's not evidence of anything.\""])
	if pick == 0:
		await ui.say("Carl", "They weren't studying dreams. They were using dreams to access something else.", "carl")
		Game.add_trust("lynx", 1)
		Game.set_flag("lab_hameron_believed")
	else:
		await ui.say("Carl", "It's a lab notebook from before the war. It's not evidence of anything.", "carl")
		await ui.say("Lynx", "Keep telling yourself that. Read on.", "lynx")
		Game.set_flag("lab_hameron_dismissed")
	await ui.say("", "We're not just listening to the Field anymore. It's listening back. And it's learning what we respond to. Symbols are reactive. They evolve.")
	await ui.say("", "We need an interface that learns alongside the phenomenon. Something conversational. Something recursive. A mimic that dreams with us.")
	await ui.say("Lynx", "They're not just testing contact with something. The Hypnogogue. They're optimizing it. Why was Psyonic here?", "lynx")
	await ui.say("Carl", "That last line sounds like my interview with Dufredy. They're looking for better ways to talk to something.", "carl")
	if Game.glasses_on:
		await main.filter.flash(0.18)
		await ui.think("My ORA frames buzzed. My stomach turned. I blinked. The HUD reset.")
		await ui.say("", "Subject 12-35: Carl Drake.\nDays since first ritual attempt: 3.")
		await main.filter.flash(0.08)
		await ui.think("Then it vanished. Just static. Had I hallucinated it? Or had it been waiting for me to look?")
		Game.add_connection(4.0, "Hameron's log")
		Game.set_flag("lab_saw_12_35")
	else:
		await ui.think("Something buzzed in my pocket. The frames, wanting to show me something. I left them where they were and the buzzing stopped, eventually, the way a phone stops ringing.")
		Game.add_connection(1.0, "Hameron's log")
	ui.close()
	Game.set_flag("lab_hameron")
	Game.log_entry("Hameron's log on Sublevel 1: Dream Induced Wave Collapse. Subject 12-34, 144 days since first ritual attempt. 'A mimic that dreams with us.' The frames showed me Subject 12-35: Carl Drake, day 3.")
	Game.add_evidence("Hameron's log, photographed")
	var l := npc("lynx")
	if l:
		l.face("down")
	Game.input_locked = false


func _breath() -> void:
	Game.input_locked = true
	await main.filter.flash(0.15)
	await ui.think("A breath. Hot and metallic, right against my left ear.")
	if Game.glasses_on:
		await ui.think("My HUD shorted out. The sound wasn't just heard. It rang through my body like sonar. Like something scanning me.")
	else:
		await ui.think("It rang through my body like sonar. Like something scanning me. There was nothing on my face to blame it on.")
	await ui.think("Not a glitch. Not a hallucination. I swear I felt the breath on my shoulder. I froze. The breath lingered, dragging across my nervous system. Then it stopped.")
	await ui.say("Lynx", "Carl? Got it working. You okay? You look pale.", "lynx")
	var pick := await ui.choose(["\"Fine.\"", "\"Something just breathed in my ear.\""])
	if pick == 0:
		await ui.say("Carl", "Fine.", "carl")
		await ui.think("If I said it, everything would come pouring out. My job, my clearance, my identity, shredded the moment HR got wind. Once the FreudBot flagged your profile, it was only a matter of time.")
		Game.set_flag("hid_breath")
	else:
		await ui.say("Carl", "Something just breathed in my ear.", "carl")
		await ui.say("Lynx", "I know. It did it to me on the way down. Don't answer it.", "lynx")
		Game.add_trust("lynx", 1)
		Game.set_flag("told_breath")
	ui.close()
	Game.add_connection(3.0, "the breath")
	Game.set_flag("lab_breath")
	Game.log_entry("Sublevel 1: a breath against my left ear, hot and metallic, that rang through me like sonar. Lynx had felt it too.")
	Game.input_locked = false
