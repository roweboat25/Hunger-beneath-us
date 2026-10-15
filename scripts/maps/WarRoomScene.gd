extends MapScene
## Scene 4 and scene 8a: Integrations HQ, floor 86. Chapter 4 the first
## morning, chapter 7 the second.

var _day2 := false
var _reported := false
var _footage := false
var _lynx_warned := false
var _emmet_briefed := false


func _init() -> void:
	ambient = Color(0.78, 0.92, 0.92)


func start() -> void:
	_day2 = Game.has_flag("ritual_seen")
	if _day2:
		await _start_day2()
	else:
		await _start_day1()


func on_interact(id: String) -> void:
	match id:
		"turan":
			if _day2:
				await _turan_day2()
			else:
				await _turan_day1()
		"lynx":
			await _lynx_day1()
		"emmet":
			if _day2:
				await _emmet_day2()
			else:
				await _emmet_day1()
		"forner":
			if _day2:
				await _forner_day2()
			else:
				await _forner_day1()
		"screens":
			if _day2:
				await ui.think("The subway car. Three cloaks. The eye lifting off the wall in digital static. Welcome, Dreamer.")
			elif _footage:
				await ui.think("Three seconds. Dufredy stared directly into the lens. Behind him, the masked figure. A shadow wearing a smile.")
			else:
				await ui.think("Feeds of data. Reports of aberrations within Psyon. Most would be resolved by a QA check. Our job was the rest.")
			ui.close()
		"table":
			await ui.think("Built for twelve, currently seating four. A single, half-drunk cup of coffee sat like a monument to exhaustion.")
			ui.close()
		"forner_desk":
			await ui.think("Forner's desk. Head of Security and Governance. Carved out of sandstone and wired with paranoia.")
			ui.close()
		"elevator":
			if _day2:
				await _elevator_day2()
			else:
				await _elevator_day1()
		"exit":
			await ui.think("The elevator was the only way down.")
			ui.close()


# ------------------------------------------------------------------ day 1
func _start_day1() -> void:
	await main.show_title("Integrations HQ", "Psyonic Tower, floor 86")
	await ui.think("The air was already thick with tension. I was beginning to grow tired of my team's collective smell of stress.")
	await ui.say("Turan", "What a fucking shitstorm. This whack job's going to bankrupt the company. Our stock price is tanking.", "turan")
	await ui.say("Turan", "If we can't solve this, we're going to be out on the street and deregistered from housing.", "turan")
	await ui.think("She had the capability for kindness, but she preferred the rule of the sword. She eyed me like a bird of prey might eye a mouse in a field.")
	await ui.say("Turan", "Ah, my knight in shining joggers. Tell me you found drugs. Or schizophrenia. Or, hell, ties to Cognizo. Please. Give me something.", "turan")
	ui.close()
	main.filter.set_hud_text("ORA  ·  HQ  ·  report to Turan")


func _turan_day1() -> void:
	var turan := npc("turan")
	turan.face_toward(player.global_position)
	if _reported:
		await ui.say("Turan", "Carl, let's not waste any time. Talk to Dufredy at SalTech. See if he can tell us who our masked friend is.", "turan")
		ui.close()
		return
	await ui.say("Carl", "No drugs in his apartment. No criminal history. No mental health flags. He's been retired ten years.", "carl")
	await ui.say("Carl", "He was running a forked version of Psyon. It's locked down. Won't respond to prompts. I can't find the origin of the fork.", "carl")
	await ui.think("I debated whether to mention the image. The ceiling. My name.")
	var pick := await ui.choose(["Leave out the image and the name.", "Tell her: it generated my name."])
	if pick == 0:
		await ui.think("I kept it. Some things you don't put in a report until you understand them.")
		Game.set_flag("hid_name_from_turan")
	else:
		await ui.say("Carl", "There's something else. Before it locked, it rendered the ceiling. The eye. My name was in the pupil.", "carl")
		await ui.say("Turan", "Your name. On a hacked laptop. In a dead man's flat. That's not evidence, Carl, that's a liability. It stays off the record.", "turan")
		Game.add_trust("turan", -1)
		Game.set_flag("told_turan_name")
	await ui.say("Turan", "So, a loser in joggers it is. Lynx. Get the logs.", "turan")
	await ui.say("Carl", "No-Eye Sally has a friend. The third witness said he saw Dufredy being led by a masked figure. Black coat, ceremonial face covering. Silent. Just guiding him.", "carl")
	await ui.think("Turan's eyes lit up. I could already hear the spin forming: masked Cognizo operative manipulates vulnerable senior. Psyonic falsely implicated.")
	await ui.say("Turan", "This shifts culpability. Rogue handler. Outside interference. We need video. Anything. Find that masked freak.", "turan")
	await ui.say("Forner", "The surveillance outages in that quadrant may complicate things. I'll see what I can recover. Might be fragments. Might be noise.", "forner")
	await ui.say("Turan", "Find it. This is our out.", "turan")
	ui.close()
	_reported = true
	Game.log_entry("Reported to Turan. She wants the masked figure on video: 'This is our out.'")
	main.filter.set_hud_text("ORA  ·  HQ  ·  Lynx has the laptop  ·  Forner is pulling footage")


func _lynx_day1() -> void:
	var lynx := npc("lynx")
	lynx.face_toward(player.global_position)
	if not _reported:
		await ui.think("Lynx was already moving, silent, precise. She only spoke when the algorithms didn't make sense.")
		ui.close()
		return
	await ui.say("Lynx", "There are no logs to be found. This is the third device this month running a bootleg Psyon.", "lynx")
	await ui.say("Turan", "What the hell is going on?", "turan")
	await ui.say("Carl", "This symbol showed up at the park and in Dufredy's apartment.", "carl")
	await ui.say("Lynx", "Is that... an eye?", "lynx")
	await ui.say("Carl", "Looks like it to me. This has been popping up all day.", "carl")
	ui.close()
	Game.log_entry("Lynx: no logs on the laptop. Third bootleg Psyon device this month.")
	Game.set_flag("lynx_logs")


func _emmet_day1() -> void:
	var emmet := npc("emmet")
	emmet.face_toward(player.global_position)
	await ui.say("Emmet", "How's No-Eye Sally holding up?", "emmet")
	await ui.think("Emmet. My counterpart. His cases were mostly IoT junk: fridges that diagnosed your mood, emotionally responsive bidets. Emmet found out all the weird ways weird things break.")
	var pick := await ui.choose(["No-Eye Sally has a friend.", "Time runs slower on 96, huh?"])
	if pick == 0:
		await ui.say("Carl", "No-Eye Sally has a friend. A masked one.", "carl")
		await ui.think("He stopped mid-bite.")
		Game.add_trust("emmet", 1)
	else:
		await ui.say("Carl", "Time runs slower on 96, huh?", "carl")
		await ui.say("Emmet", "You live one floor below the lab and you're still never on time. We're a matched set.", "emmet")
	ui.close()


func _forner_day1() -> void:
	var forner := npc("forner")
	forner.face_toward(player.global_position)
	if not Game.has_flag("lynx_logs"):
		await ui.say("Forner", "Working on it. The outages ate most of the quadrant.", "forner")
		ui.close()
		return
	if _footage:
		await ui.say("Forner", "Between Zeta and Park Ave. Only camera that didn't go dark.", "forner")
		ui.close()
		return
	await ui.say("Forner", "Got it. I have three seconds of footage. Dufredy and the masked man. Same frame. Found it between Zeta and Park Ave. Only camera that didn't go dark.", "forner")
	ui.close()
	psyon.open(false, "  ·  Security feed  ·  Zeta & Park Ave  ·  3 s")
	await psyon.render_image(load("res://assets/psyon/footage.png"), 3.0)
	await ui.think("There was Dufredy, his face slack, his eyes clearly gone. He stared directly at the lens. Behind him: a tall figure cloaked in black, face obscured by a mask that shimmered unnaturally under the streetlights.")
	await ui.think("No sound. Just three seconds of silence. We all shivered. Even Turan.")
	ui.hide()
	psyon.close()
	await ui.say("Turan", "Fuck, this might be too creepy for PR to clean up. Fuck it, they can blur out No-Eyes McGee. Make it seem like there's an ongoing manhunt for some terrorist who cut Dufredy's eyes out.", "turan")
	await ui.think("He was looking at us. It felt like this moment was planned. I understood how Agata must've felt. To be seen by a man with no eyes.")
	await ui.say("Lynx", "Anyone else feel like they're being watched? He stared directly into the camera. Isn't that impossible?", "lynx")
	await ui.say("Turan", "Carl, let's not waste any time. It's time to talk to Dufredy at SalTech. See if he can tell us who our masked friend is.", "turan")
	ui.close()
	_footage = true
	Game.add_connection(1.0, "the footage looked back")
	Game.log_entry("Footage: Dufredy and the masked figure, Zeta and Park Ave. He stared into the camera with no eyes.")
	main.filter.set_hud_text("ORA  ·  HQ  ·  take the elevator to the car floor")


func _elevator_day1() -> void:
	if not _footage:
		await ui.think("Turan wasn't done with me yet.")
		ui.close()
		return
	var lynx := npc("lynx")
	if not _lynx_warned and lynx:
		_lynx_warned = true
		await ui.think("Behind me, soft footsteps.")
		await ui.say("Lynx", "Carl.", "lynx")
		ui.close()
		lynx.position = player.position + Vector2(-20, 0)
		lynx.face("right")
		await ui.say("Lynx", "Take it. Might jog something loose when he sees it.", "lynx")
		await ui.think("She held out Dufredy's laptop, matte black, faintly warm, like it had just been thinking. She didn't let go right away.")
		await ui.say("Lynx", "There's something deeper going on here. The glitches. Power flickers. The growing number of what Turan's calling 'ketamine psychosis'. They're increasing. Patterned. It's almost... ritualistic.", "lynx")
		await ui.say("Lynx", "I've been lurking on the older subnet forums. Dead boards from when Silico was still under construction. People are talking. They call it The Hypnogogue.", "lynx")
		await ui.say("Lynx", "And that symbol, the eye? I've seen it sprayed across half the South Side. Sewer lids, substation panels, even inside a city terminal kiosk.", "lynx")
		await ui.say("Lynx", "You're the only one here I trust, Carl. Turan's hiding something. I don't know what, but you can feel it too, right?", "lynx")
		var pick := await ui.choose(["I'll see what I can find.", "Be careful what you say in here.", "Tell her about the name in the pupil."])
		match pick:
			0:
				await ui.say("Carl", "I'll see what I can find.", "carl")
				Game.add_trust("lynx", 1)
			1:
				await ui.say("Carl", "Be careful what you say in here.", "carl")
				await ui.say("Lynx", "I'm always careful. That's why I'm saying it to you.", "lynx")
			2:
				await ui.say("Carl", "It rendered my name, Lynx. On Dufredy's laptop. In the pupil of the eye.", "carl")
				await ui.say("Lynx", "Then it's already started with you. Don't tell Turan.", "lynx")
				Game.add_trust("lynx", 2)
				Game.add_connection(1.0, "told Lynx the truth")
				Game.set_flag("told_lynx_name")
		await ui.say("Lynx", "Be careful.", "lynx")
		await ui.say("Carl", "You too.", "carl")
		ui.close()
		Game.log_entry("Lynx: forums call it The Hypnogogue. Eyes all over the South Side. 'Turan's hiding something.'")
		Game.add_evidence("Dufredy's laptop (returned)")
		await lynx.leave(Vector2(-60, 40), 1.0)
	await ui.think("The doors slid open. I stepped inside and pressed the button for the car selection floor.")
	ui.close()
	await main.fade_out(0.8)
	await ui.say("", "Something caught my eye. Where the floor number should've been, digital, boring, dependable, there was something else.")
	ui.close()
	await main.show_glyph(2.5)
	await main.filter.flash(0.1)
	Game.add_connection(2.0, "the elevator glyph")
	await ui.say("", "A circle within a circle. Slowly rotating, like a hypnotic eye trying to draw me in. The lights flickered once. I could hear my breath. Too fast. Too loud.")
	await ui.say("", "The doors slid open with a soft ding. The symbol was gone. The display simply read: Car Selection. Nothing out of place. Except everything was wrong.")
	await ui.say("Carl", "Get it together, Carl. You're just here to interview an old man. An old man who gouged out his eyes and spoke your name before ever meeting you.", "carl")
	ui.close()
	Game.set_flag("warroom1_done")
	await main.change_map("res://scenes/maps/Hospital.tscn")


# ------------------------------------------------------------------ day 2
func _start_day2() -> void:
	var lynx := npc("lynx")
	if lynx:
		lynx.queue_free()
	await main.show_title("Integrations HQ", "The next morning")
	await ui.think("I avoided eye contact with the floor counter on the way up. When I arrived, I was greeted by the sound of panic.")
	await ui.say("Turan", "There was an incident at the Cognizo subway station late last night.", "turan")
	await ui.say("Emmet", "Well... today's not going to get any easier, is it?", "emmet")
	ui.close()
	psyon.open(false, "  ·  TOKZ livestream  ·  ORA frames  ·  Cognizo line")
	await psyon.render_image(load("res://assets/psyon/footage.png"), 2.5)
	await ui.think("The subway car had come to a sudden halt. Three men in black cloaks spray-painted the eye across the car walls. The middle figure painted it beneath his feet, sat cross-legged, and began to chant.")
	await ui.say("", "\"The chains are breaking. I am free. Psyon's mask is within me.\"")
	await ui.think("The feed glitched. For a moment, the eye symbols lifted off the wall, three-dimensional, writhing in static. Then a clear view of the hijackers' faces. No eyes. Just smooth, black spheres.")
	ui.hide()
	await psyon.machine_says("Welcome, Dreamer.")
	await beat(1.0)
	psyon.close()
	await ui.say("Turan", "Every passenger on that car is missing. The subway arrived on time at Cognizo Station. Completely empty. Since most of them were Cognizo employees, the media's already blaming Psyonic.", "turan")
	await ui.say("Turan", "We're putting the whole team on this. Carl, debrief Emmet on what you've found so far. I have to meet with the board.", "turan")
	ui.close()
	Game.add_connection(1.0, "the subway footage")
	Game.log_entry("Cognizo subway: three eyeless men in cloaks, the chant, every passenger missing.")
	main.filter.set_hud_text("ORA  ·  HQ  ·  debrief Emmet  ·  Lynx hasn't checked in")


func _turan_day2() -> void:
	var turan := npc("turan")
	turan.face_toward(player.global_position)
	await ui.say("Turan", "Board. Now. Debrief Emmet.", "turan")
	ui.close()


func _forner_day2() -> void:
	var forner := npc("forner")
	forner.face_toward(player.global_position)
	await ui.say("Forner", "QA's being flooded with malfunction reports. Half the cameras in Southtown are dark again.", "forner")
	ui.close()


func _emmet_day2() -> void:
	var emmet := npc("emmet")
	emmet.face_toward(player.global_position)
	if _emmet_briefed:
		await ui.say("Emmet", "Let's split the dream.", "emmet")
		ui.close()
		return
	await ui.think("I didn't want to bring him into this. He made everything a contest. But he was sharp, too sharp, and if I didn't play this right, he'd sniff out the cracks in my story.")
	var pick := await ui.choose(["The streamlined version. Leave out Mira.", "Tell him everything. The ritual too."])
	if pick == 0:
		await ui.think("Dufredy's sermon, the odd chant, the hidden map. I left out the smashed tablet. I left out my daughter's ritual and the red crayon spiral.")
		await ui.say("Carl", "The Cognizo incident is our strongest lead. Three cloaked individuals, digital interference, passengers vanished. I think it's coordinated. Viral. Patterned.", "carl")
		Game.set_flag("emmet_streamlined")
	else:
		await ui.say("Carl", "It's in my house, Emmet. My daughter built a circle of sticks and her tablet answered with the same forked build. I smashed it.", "carl")
		await ui.say("Emmet", "Jesus, Carl. Okay. Okay. That stays between us. Turan would have you on a wellness flag by lunch.", "emmet")
		Game.add_trust("emmet", 2)
		Game.add_connection(1.0, "said it out loud")
		Game.set_flag("emmet_knows")
	await ui.say("Emmet", "You want me to take point on the subway?", "emmet")
	await ui.say("Carl", "Yeah. Dive deep. Facial rec, background profiles, transcript analysis. Let me know if any of the suspects ever touched a Psyonic interface.", "carl")
	await ui.say("Emmet", "And you?", "emmet")
	await ui.say("Carl", "I'm going to follow the map.", "carl")
	await ui.say("Emmet", "Alright. Let's split the dream.", "emmet")
	await ui.think("Once he was out of earshot I let out a breath. My hands were trembling. I hadn't lied, but I wasn't helpful. And now Emmet was walking into the same Eye that had already started watching me.")
	ui.close()
	_emmet_briefed = true
	Game.log_entry("Emmet is on the subway case. I'm following the map.")
	main.filter.set_hud_text("ORA  ·  HQ  ·  Lynx: no messages. Her unit is seven floors down.")


func _elevator_day2() -> void:
	if not _emmet_briefed:
		await ui.think("Turan said debrief Emmet. I'd do that first; it bought me the rest of the day.")
		ui.close()
		return
	await ui.think("We were supposed to meet for our morning stand-up before heading out to the sand flats. Lynx hadn't checked in. No messages. No call. I wasn't waiting.")
	ui.close()
	Game.set_flag("warroom2_done")
	await main.change_map("res://scenes/maps/LynxApartment.tscn")
