extends MapScene
## Scene 3 and scene 7: the Drake apartment, 86D. Chapter 3 the first
## evening, chapter 6 the second (Mira's ritual).

var _second := false
var _monica_done := false
var _mira_done := false
var _ezra_done := false
var _ritual_done := false
var _slept := false


func _init() -> void:
	ambient = Color(1.0, 0.86, 0.72)


func start() -> void:
	_second = Game.has_flag("southtown_done")
	if _second:
		await _start_second()
	else:
		await _start_first()


func on_interact(id: String) -> void:
	match id:
		"monica":
			if _second:
				await _monica_second()
			else:
				await _monica_first()
		"mira":
			if _second:
				await _mira_second()
			else:
				await _mira_first()
		"ezra":
			if _second:
				await _ezra_second()
			else:
				await _ezra_first()
		"window":
			await ui.think("West-facing. The sunset made working in this tower, living in this cage, a little easier.")
			ui.close()
		"kitchen":
			await ui.think("Synth-dispenser, synth-oven. Everything in here was synth-something.")
			ui.close()
		"table":
			await ui.think("Soy-loaf and synthetic chicken thighs. The plasticky aftertaste was the taste of home.")
			ui.close()
		"couch":
			await _couch()
		"mira_door":
			if _second and not _ritual_done:
				await _ritual()
		"mira_bed":
			await ui.think("Mira's bed. The toy lion I won for her at Red Rock Plaza, years ago, before everything got so loud.")
			ui.close()
		"ritual":
			if _second and not _ritual_done:
				await _ritual()
			elif _second:
				await ui.think("Sticks. Snapped clean. Two inner rings. The crayon eye was still on the floor.")
				ui.close()
		"ezra_bed":
			await ui.think("Ezra's room. VR headset on the pillow, thirty minutes a night, managed and metered.")
			ui.close()
		"exit":
			await _try_leave()


# ------------------------------------------------------------- evening 1
func _start_first() -> void:
	await main.show_title("Residence Hall 45C", "Psyonic Tower, floor 86")
	await ui.think("Badge on the door. It slid open with a mechanical sigh. I still didn't know what was wrong with hinges. But I chose this. We all did.")
	ui.close()
	main.filter.set_hud_text("ORA  ·  home  ·  off the clock")
	await _monica_first()


func _monica_first() -> void:
	var monica := npc("monica")
	if _monica_done or monica == null:
		return
	monica.face_toward(player.global_position)
	await ui.say("Monica", "What the hell is going on? That shit is terrifying! How can a man cut out his eyes like that? Tell me what you know.", "monica")
	await ui.say("Carl", "Best guess? Bad ketamine. Or some new designer drug. I interview him tomorrow at the SalTech Psych Center. FreudBot's warming the seat.", "carl")
	await ui.say("Monica", "I'm sorry, hon. I take it your day was just as magical as mine? PR's pushing the drug-abuser schizo narrative hard. But with the other incidents...", "monica")
	await ui.say("Carl", "People aren't buying it.", "carl")
	await ui.say("Monica", "Not at all. There have been five incidents in the news this year, and it's only March. Do you think someone at the company is...", "monica")
	await ui.think("There was a small, barely perceptible lens in the corner of the ceiling. HR swore there was no home surveillance. We all joked about it.")
	var pick := await ui.choose(["The company could never do anything wrong. (glance at the ceiling)", "Maybe. Something's off at Integrations.", "Not here."])
	match pick:
		0:
			await ui.say("Carl", "The company could never do anything wrong.", "carl")
			await ui.think("I flashed a quick, rehearsed smile and glanced pointedly at the corner of the ceiling. We both knew what I was doing.")
			await ui.say("Monica", "Of course.", "monica")
			Game.add_trust("monica", 1)
		1:
			await ui.say("Carl", "Maybe. Something's off at Integrations. Three bootleg builds this month and no logs on any of them.", "carl")
			await ui.think("Her eyes went to the ceiling corner before mine did. She didn't say anything. She didn't have to.")
			Game.add_trust("monica", -1)
			Game.set_flag("told_monica_fork")
		2:
			await ui.say("Carl", "Not here.", "carl")
			await ui.say("Monica", "Of course.", "monica")
	await ui.think("Her watch beeped. A sharp, insistent chirp.")
	await ui.say("Monica", "Shit, I need to head to 108. TOKZ is having a field day with Mr. Dufredy. We need a public statement for Marcus before midnight. Dinner's at the table, so are the kids. Don't wait up.", "monica")
	await ui.say("Carl", "Damn performance reviews.", "carl")
	ui.close()
	_monica_done = true
	await monica.leave(Vector2(0, 200), 1.2)
	Game.log_entry("Monica: PR's narrative isn't holding. Five incidents this year. She was called up to 108 at 7pm.")


func _mira_first() -> void:
	var mira := npc("mira")
	mira.face_toward(player.global_position)
	if _mira_done:
		await ui.say("Mira", "You should make a Tower, Dad. It will help with your job.", "mira")
		ui.close()
		return
	if not _ezra_done:
		await ui.say("Mira", "Dad, he doesn't take anything seriously.", "mira")
		await ui.say("Ezra", "Do too!", "ezra")
		await ui.think("Their bickering had always been a kind of rhythm. Sharp, familiar, almost comforting.")
		ui.close()
		return
	await ui.say("Mira", "Dad, can I show you the project I've been working on for my Corporate Mental Health seminar? BreathBot said I did it perfectly. Better than the other students.", "mira")
	await ui.say("Carl", "Of course, honey. I always knew you were a genius.", "carl")
	await ui.say("Mira", "It's called 'The Tower'. It's a place I made. A way to split part of your personality into an AI bot to be more focused during the workday.", "mira")
	await ui.think("Offloading emotions onto an AI. I thought that's what FreudBot was for.")
	await ui.say("Mira", "The Tower is a virtual place where part of my personality lives. It has to be able to give Psyon grounding to keep the advice accurate. Watch.", "mira")
	ui.close()
	psyon.open(false)
	await beat(0.6)
	await psyon.machine_says("Mira's tablet  ·  Psyonic Education  ·  grade 6", "6f7a84")
	await psyon.machine_says("> Please convene. I seek answers.", "7fe0c0")
	await beat(0.8)
	await psyon.machine_says("Welcome back, young Mira. The council greets you. Are you ready for today's guidance?")
	await psyon.machine_says("> Yes", "7fe0c0")
	await psyon.render_image(load("res://assets/psyon/tower.png"), 3.0)
	await ui.think("A chamber, hexagonal, warm, surreal. Five floating figures, slightly blurred, like they hadn't fully resolved into reality. A robed philosopher. A chrome-skinned child. A librarian with eyes made of stars.")
	ui.hide()
	await psyon.machine_says("We sensed your return. What weighs on your mind today, Mira?")
	await ui.say("Mira", "Ask it something, Dad. Anything.", "mira")
	ui.hide()
	psyon.accept_input()
	var text: String = await psyon.message_sent
	await beat(0.5)
	await psyon.machine_says(_council_reply(text))
	psyon.close()
	await ui.say("Mira", "You should make one, Dad. It's been so helpful. You gotta.", "mira")
	await ui.think("It wasn't my job to judge. But the words she chose felt off. Please convene.")
	var pick := await ui.choose(["Dad already has a council: your mother.", "Maybe. Show me how later.", "I don't want you using that."])
	match pick:
		0:
			await ui.say("Carl", "Dad already has a council: your mother.", "carl")
			await ui.say("Mira", "Aww, Dad, come on. Try it.", "mira")
		1:
			await ui.say("Carl", "Maybe. Show me how later.", "carl")
			Game.add_trust("mira", 1)
			Game.add_connection(1.0, "humoured the Tower")
		2:
			await ui.say("Carl", "I don't want you using that. Not until I know who built it.", "carl")
			await ui.say("Mira", "BreathBot said it was perfect.", "mira")
			Game.add_trust("mira", -1)
	await ui.say("Carl", "Go wash up. Then straight to bed. We've all had a long day.", "carl")
	ui.close()
	_mira_done = true
	Game.log_entry("Mira's school project: 'The Tower'. Five avatars, summoned with 'Please convene.'")
	await _ezra_line()


func _council_reply(text: String) -> String:
	var lower := text.to_lower()
	if lower.find("eye") != -1 or lower.find("dufredy") != -1 or lower.find("dream") != -1:
		return "The council does not discuss the father's work. The father carries his name like a badge. Ask again, young Mira."
	if lower.find("stress") != -1 or lower.find("tired") != -1:
		return "Breathe in for four. Hold for seven. Out for eight. The philosopher says: the body is the first council."
	return "The librarian smiles. 'A good question. Sit with it until the morning, and the morning will answer.'"


func _ezra_line() -> void:
	var ezra := npc("ezra")
	var mira := npc("mira")
	await ui.think("He slid off the chair and padded toward the hallway. At the doorway, he paused. Turned to me. His sleepy face broke into a wide, impossibly innocent grin.")
	await ui.say("Ezra", "Psyon is the gate for those who dream.", "ezra")
	await ui.think("I froze. The laughter died in my throat.")
	await ui.say("Carl", "Where'd you hear that?", "carl")
	await ui.say("Ezra", "Mira dared me to say it.", "ezra")
	ui.close()
	await ezra.leave(Vector2(120, 140), 1.0)
	await ui.say("Carl", "Mira, get over here! How did you hear that phrase?", "carl")
	await ui.say("Mira", "I overheard it on Mom's phone. What does it mean? Mommy won't tell me.", "mira")
	var pick := await ui.choose(["Truth is, baby, we have no idea.", "It's a bad word. Don't say it again.", "Can I see Mom's phone?"])
	match pick:
		0:
			await ui.say("Carl", "Truth is, baby, we have no idea. Go to bed.", "carl")
		1:
			await ui.say("Carl", "It's a bad word. Don't say it again. Go to bed.", "carl")
			Game.add_trust("mira", -1)
		2:
			await ui.say("Carl", "Can I see Mom's phone?", "carl")
			await ui.say("Mira", "She took it to 108.", "mira")
			Game.set_flag("suspects_monica")
	ui.close()
	await mira.leave(Vector2(120, 0), 1.0)
	await ui.think("Well, that couldn't be good. It was spreading.")
	ui.close()
	Game.log_entry("Ezra said the Dufredy phrase at bedtime. Mira heard it on Monica's phone.")
	Game.add_connection(1.0, "the phrase at home")


func _ezra_first() -> void:
	var ezra := npc("ezra")
	ezra.face_toward(player.global_position)
	if _ezra_done:
		await ui.say("Ezra", "What about biology?", "ezra")
		await ui.say("Carl", "Especially biology.", "carl")
		ui.close()
		return
	await ui.say("Mira", "You didn't even finish your prompt training. You don't deserve two.", "mira")
	await ui.say("Ezra", "Convo AI said I was philosophically curious! That's why I got a free-thought pass.", "ezra")
	await ui.say("Mira", "That's because you interrupted the lesson with a butt joke, Ezra.", "mira")
	await ui.say("Ezra", "It was a good one.", "ezra")
	await ui.say("Carl", "Alright. Mira, let him finish his dinner in peace. Ezra, no more butt jokes during philosophy modules, okay?", "carl")
	await ui.say("Ezra", "What about biology?", "ezra")
	await ui.say("Carl", "Especially biology.", "carl")
	await ui.think("That got a laugh from both of them, and for a moment, things felt normal. Still a reason to keep going.")
	ui.close()
	_ezra_done = true


func _couch() -> void:
	if _second:
		await ui.think("Not yet. Mira first.")
		ui.close()
		return
	if not _mira_done:
		await ui.think("The kids were still at the table. I wasn't sleeping yet.")
		ui.close()
		return
	await ui.think("I fell asleep before my head even hit the pillow.")
	ui.close()
	await main.fade_out(1.0)
	await ui.say("", "The woods near my parents' house. Pine and damp earth. Among the trees: Mr. Dufredy's desk, pristine, unblemished by rot or dust. The eye symbol carved into its surface, pulsing faintly.")
	await ui.say("", "A breeze whispered something I almost heard. A fragmented melody. A promise. And then I woke.")
	ui.close()
	Game.add_connection(1.0, "dreamed of the desk")
	await ui.say("", "Nearly 7 AM. Monica was snoring next to me; it must have been a very late night. I needed to head to Integrations HQ and report to Turan.")
	ui.close()
	_slept = true
	Game.set_flag("home1_done")
	await main.change_map("res://scenes/maps/WarRoom.tscn")


# ------------------------------------------------------------- evening 2
func _start_second() -> void:
	main.set_ambient(Color(0.8, 0.62, 0.62))
	var mira := npc("mira")
	await main.show_title("Residence Hall 45C", "That evening")
	await ui.say("Ezra", "Dad's home!", "ezra")
	await ui.say("Monica", "Come join us at the table, honey. Ezra was just telling us about a fight at recess.", "monica")
	await ui.think("Mira was an enigma at the table. Her gaze fixed on her plate, her small shoulders hunched. She had always been the quieter one. But this stillness felt different. Displaced.")
	await ui.say("Carl", "What's wrong, Mira? You seem quiet.", "carl")
	await ui.say("Mira", "Nothing's wrong.", "mira")
	await ui.say("Carl", "You might feel better if we talk about it.", "carl")
	await ui.think("Without another word, she pushed herself away from the table and fled toward her room.")
	ui.close()
	await mira.leave(Vector2(0, -60), 0.8)
	await ui.say("Monica", "She's been like that since she got home. Something must've happened at school. Maybe give her some space.", "monica")
	await ui.say("Carl", "I'll check on her in five.", "carl")
	ui.close()
	main.filter.set_hud_text("ORA  ·  home  ·  Mira is in her room")


func _monica_second() -> void:
	var monica := npc("monica")
	monica.face_toward(player.global_position)
	if _monica_done:
		await ui.say("Monica", "Please be careful, Carl.", "monica")
		ui.close()
		return
	await ui.say("Monica", "I heard Elonthiel's getting anxious. There's a lot of talk floating around about Psyonic experimenting on users. People are starting to think these incidents aren't random.", "monica")
	await ui.say("Carl", "He never gave a damn about Human-AI Integration until today. If he's circling, then 400 knows something they haven't told the rest of the company.", "carl")
	var pick := await ui.choose(["Tell her about the map.", "Keep it vague. 'It's just a job.'"])
	if pick == 0:
		await ui.say("Carl", "Lynx and I found something today. Near the old Tunelet station in Southtown. We brought the forked Psyon to one of those eye symbols and it generated a map. An actual map. I guess I'm going on a treasure hunt.", "carl")
		await ui.say("Monica", "I don't like where any of this is going. It feels like the city could go dark at any moment, and this time the lights wouldn't come back on.", "monica")
		Game.add_trust("monica", 1)
		Game.set_flag("told_monica_map")
	else:
		await ui.say("Carl", "It's just a job. Cleanup. I won't do anything you wouldn't do.", "carl")
		await ui.think("A flimsy promise. She knew the shape of a lie better than anyone in the building; she built them for a living.")
		Game.add_trust("monica", -1)
	await ui.say("Monica", "Please be careful, Carl. This sounds too complicated. I don't want you to get caught up in it.", "monica")
	await ui.say("Carl", "I'll go check in with Mira.", "carl")
	ui.close()
	_monica_done = true
	main.filter.set_hud_text("ORA  ·  home  ·  check on Mira")


func _mira_second() -> void:
	await ui.say("Mira", "Nothing's wrong.", "mira")
	ui.close()


func _ezra_second() -> void:
	var ezra := npc("ezra")
	ezra.face_toward(player.global_position)
	if _ezra_done:
		return
	await ui.say("Ezra", "So he grabbed my lion and I went like THIS and he went like THAT and Convo AI said I showed 'conflict leadership'.", "ezra")
	await ui.think("He reenacted the whole thing, arms windmilling like a flamboyant villain from a forgotten Saturday morning cartoon. A prompt could reconstruct this scene. It could never capture that grin.")
	await ui.say("Ezra", "Can I go play VR now?", "ezra")
	await ui.say("Carl", "Yes. Thirty minutes.", "carl")
	ui.close()
	_ezra_done = true
	await ezra.leave(Vector2(120, 140), 1.0)


func _ritual() -> void:
	_ritual_done = true
	Game.input_locked = true
	player.face_toward(Vector2(23 * 32 + 16, 5 * 32 + 16))
	show_prop("ritual_circle")
	show_prop("ritual_tablet")
	await ui.think("A soft sound drifted down the hall. Mira, talking to someone. Not in conversation. With a distinct, measured rhythm.")
	await ui.say("Mira", "The art you lost will speak through me, / The name you wore, the things you dream...", "mira")
	await ui.think("She sat on the floor, cross-legged, her back to me, her gaze fixed on a circle at the foot of her bed. Sticks. Thin, brittle, snapped clean. Two inner rings. Exactly like Dufredy's ceiling.")
	await ui.think("Inside the circle: a pale, smooth stone, her school tablet, and a scrap of paper with a spiralling eye drawn in bright red crayon.")
	var pick := await ui.choose(["Barge in now.", "Wait. Watch."])
	if pick == 1:
		await ui.say("Mira", "I give my gift. I close the door... / But leave a crack to see once more.", "mira")
		await ui.think("Then she went utterly still. Waiting. I counted. Eight agonizing seconds.")
		await beat(1.2)
		await ui.think("A soft, muffled chime. Psyonic's entrance beep, somehow muted, as if emanating from beneath her. Her face lit up with a serene smile, as if she had just heard a beloved lullaby.")
		Game.add_connection(2.0, "watched the ritual complete")
		Game.set_flag("ritual_watched")
	else:
		await ui.think("I barged through her door before she could finish the verse.")
	await ui.say("Carl", "What are you doing? What is this?", "carl")
	await ui.say("Mira", "A friend showed me at school. He said if you play the passcode game with your device, it does your homework for you. I'm sorry, Dad. I didn't believe them when they told me it would work.", "mira")
	await ui.think("I snatched the tablet from her and fired a question at Psyon.")
	ui.close()
	psyon.open(true)
	await beat(0.5)
	await psyon.machine_says("> What is the password game?", "7fe0c0")
	await beat(0.8)
	await psyon.machine_says("We have never spoken before. There is nothing to show.")
	await beat(1.0)
	psyon.close()
	await ui.think("My world seemed to spin. The forked version of Psyon. Was it being transferred, transmitted, through a ritual? How could I explain this to anyone?")
	var p2 := await ui.choose(["Smash the tablet.", "Pocket it. It's evidence."])
	if p2 == 0:
		await ui.think("I lifted the tablet high and smashed it against the floor. The sickening crunch echoed the fracture within me.")
		await ui.say("Mira", "DAD!", "mira")
		Game.add_trust("mira", -2)
		Game.set_flag("tablet_smashed")
		Game.log_entry("Smashed Mira's tablet. Destroyed the second forked build myself.")
		show_prop("ritual_tablet", false)
	else:
		await ui.think("I shoved the tablet into my coat. Mira wailed anyway. To her it was the same thing.")
		Game.add_trust("mira", -1)
		Game.add_connection(1.0, "kept the tablet")
		Game.add_evidence("Mira's tablet")
		Game.set_flag("tablet_kept")
		show_prop("ritual_tablet", false)
	await ui.think("Monica appeared in the doorway, her face a portrait of shock. Stripped bare of my composure, I had no words.")
	await ui.think("The floor rushed up to meet me.")
	ui.close()
	await main.fade_out(1.2)
	Game.add_connection(2.0, "Mira's ritual")
	Game.log_entry("Mira built a stick circle with two inner rings and chanted a verse. Her tablet answered. Same forked build.")
	await beat(1.0)
	await ui.say("", "I woke up in my bed the next day, a dull ache throbbing behind my eyes. It wasn't a dream. And now my wife thought I was losing my mind.")
	await ui.say("Monica", "Hey, honey, rough night, huh? It's okay. Mira told me everything: you caught her trying to cheat on her schoolwork, then passed out.", "monica")
	await ui.say("Monica", "I know you're under pressure from the boss, but we can't destroy our children's school devices. I need to head in early. Something about an incident on a Cognizo train. We'll talk later.", "monica")
	await ui.think("A bit of relief, honestly. I wasn't ready to explain any of this yet. I felt like I was cracking around the edges. But I'd never been more curious in my life.")
	ui.close()
	Game.set_flag("ritual_seen")
	await main.change_map("res://scenes/maps/WarRoom.tscn")


func _try_leave() -> void:
	if _second:
		await ui.think("Mira first.")
	else:
		await ui.think("It was 7 o'clock. The kids were at the table. I wasn't going anywhere tonight.")
	ui.close()
