extends MapScene
## Scene 2: Harmony Green. Chapter 2. Two witnesses and the first glyphs.

var _seth_done := false
var _tyson_done := false


func objective_text() -> String:
	if _seth_done and _tyson_done:
		return "Leave. The path at the bottom left."
	return "Interview the witnesses: Seth on the bench, Tyson in the alley."


func _init() -> void:
	ambient = Color(1.0, 0.95, 0.82)


func start() -> void:
	await main.show_title("Harmony Green", "Where it happened")
	await ui.think("The park was the last green thing in Silico. Dufredy had walked out of that gap in the retaining wall, bleeding, grinning, and run straight through the plaza.")
	await ui.say("ORA", "Two witnesses remain on site, Mr. Drake. Seth McCarren, Voltx. Tyson Clerif, unregistered.", "ora")
	ui.close()
	main.filter.set_hud_text("ORA  ·  recording  ·  2 witnesses")


func on_interact(id: String) -> void:
	match id:
		"seth":
			await _seth()
		"tyson":
			await _tyson()
		"bench":
			await ui.think("Black spray on rusted steel. Circular, like a tire tread, but wrong. Too narrow in some places, too wide in others.")
			await ui.say("Carl", "Not an eye. A signal.", "carl")
			ui.close()
			_glyph("bench")
		"blood":
			await ui.think("Dried drops, a stride apart. He was running. Toward the plaza, not away from anything.")
			ui.close()
			Game.log_entry("Blood trail runs from the wall gap to the plaza. He ran toward the crowd.")
		"plaza":
			await ui.think("This is where he stopped and preached. Agata's statement filled in the rest: 'Psyon is the gate for those who dream.'")
			ui.close()
		"wall_gap":
			await ui.think("The gap in the retaining wall. Seth said Dufredy came out of here. Beyond it: the encampment.")
			ui.close()
		"alley_graffiti":
			await ui.think("More graffiti, faded, recursive. Circles inside circles. Not a warning. Not a message. A system. Watching back.")
			ui.close()
			_glyph("alley")
		"glyph_wall":
			await ui.think("The same rings, sprayed smaller, like a signature. Someone tags this whole block.")
			ui.close()
			_glyph("wall")
		"tent":
			await ui.think("A rather ornate tent. The area was clean, with a distinct lack of garbage. Whoever lives here still has rules.")
			ui.close()
		"exit":
			await _try_leave()


func _glyph(which: String) -> void:
	if Game.has_flag("park_glyph_" + which):
		return
	Game.set_flag("park_glyph_" + which)
	Game.add_connection(1.0, "looked at a glyph")
	await main.filter.flash(0.05)


func _seth() -> void:
	var seth := npc("seth")
	seth.face_toward(player.global_position)
	if _seth_done:
		await ui.say("Seth", "This is only going to get worse, man. Feels like the city's got a ghost.", "seth")
		ui.close()
		return
	await ui.think("An electrician. Voltx. The ones who really keep this city from being swallowed by the desert. He was clearing sand out of the bench's phone outlets with a tiny handheld vacuum.")
	await ui.say("Seth", "You must be the investigator from Psyonic. What's it like, working beneath one of the city's founders?", "seth")
	await ui.think("Ah. There it was. Dude probably wants a referral.")
	var pick := await ui.choose(["Let's focus on the event, shall we?", "It's a job. Like yours.", "Do you consent to be recorded?"])
	match pick:
		0:
			await ui.say("Carl", "Let's focus on the event, shall we?", "carl")
			await ui.think("Anxiety flashed across his face, then the smile returned, sharper. Defensive. Maybe even smug.")
		1:
			await ui.say("Carl", "It's a job. Like yours. Fewer vacuums.", "carl")
			await ui.say("Seth", "Ha. Fewer vacuums. Sure.", "seth")
			Game.add_trust("turan", 0)
		2:
			await ui.say("Carl", "Do you consent to have this interview recorded?", "carl")
			await ui.say("Seth", "With pleasure.", "seth")
	await ui.say("Seth", "You guys caused this, didn't you? One of your little neuronal manipulations gone sideways. What's it like from the jade tower, looking down at this decaying city?", "seth")
	await ui.say("Carl", "I'm a worker just like you. There is no manipulation. Just logs, code, and cleanup.", "carl")
	await ui.think("It wasn't convincing, and we both knew it.")
	await ui.say("Carl", "Please. Just tell me what you saw, from the beginning, and I'll leave you alone.", "carl")
	await ui.say("Seth", "I was vacuuming the charging ports. The sand filtration systems are starting to go. I noticed this graffiti pattern on the bench. At first I thought it was kids, but... it didn't look random.", "seth")
	await ui.say("Seth", "Circular. Like a tire tread, but wrong. I took a photo for my supervisor. Here.", "seth")
	await ui.think("Crude, yeah. Black spray on rusted steel. But too symmetrical to be random. Uneven rings layered with intention.")
	await ui.say("Carl", "The eye.", "carl")
	await ui.say("Seth", "What eye? Is this connected to the psycho who gouged out his own?", "seth")
	await ui.say("Carl", "It might be. Please, continue.", "carl")
	await ui.say("Seth", "Right after I saw the graffiti, the air changed. Dense. Like there was pressure behind it. You ever stand under a transmission tower and feel your bones hum?", "seth")
	await ui.say("Seth", "That's when I saw him. Standing by the wall. Grinning. Not moving. And the weird part? It looked like someone was talking to him. Not at him. Into him. Little nods.", "seth")
	await ui.say("Seth", "Then he ran. Toward the center of the park, like a bat outta hell. He didn't say anything until he hit the plaza.", "seth")
	await ui.say("Seth", "But the smile. That's what stayed with me. It wasn't scared. It was like... joy. Like he knew something we didn't.", "seth")
	var p2 := await ui.choose(["You didn't try to stop him?", "Thank you for your time."])
	if p2 == 0:
		await ui.say("Carl", "You didn't try to stop him?", "carl")
		await ui.say("Seth", "Guy's bleeding from the face, sprinting full tilt, clearly unwell. What was I gonna do? Throw my vacuum at him?", "seth")
	await ui.say("Seth", "One more thing. Check the homeless encampment just beyond the retaining wall. That's where he came from. They probably saw something.", "seth")
	await ui.say("Seth", "This is only going to get worse. Things like this are happening more and more. Feels like the city's got a ghost.", "seth")
	await ui.think("Or a bad batch of ketamine. That seemed more likely.")
	ui.close()
	_seth_done = true
	Game.log_entry("Seth McCarren (Voltx): bench graffiti, 'the air changed', Dufredy nodding to a voice, then ran smiling.")
	Game.log_entry("Dufredy came out of the gap in the retaining wall. Encampment beyond it.")


func _tyson() -> void:
	var tyson := npc("tyson")
	tyson.face_toward(player.global_position)
	if _tyson_done:
		await ui.say("Tyson", "Everyone. Eventually.", "tyson")
		ui.close()
		return
	await ui.think("A man perched against the wall, avoiding my gaze. He probably thought I was a cop.")
	await ui.say("ORA", "Tyson Clerif, 45. Unregistered for corporate property for two years. Formerly a corporate educator: semantic analysis of emotional communication.", "ora")
	await ui.say("Carl", "Tyson Clerif?", "carl")
	await ui.say("Tyson", "Depends on who's asking.", "tyson")
	await ui.say("Carl", "Carl Drake. Psyonic.", "carl")
	await ui.say("Tyson", "Of course. From the Tower. You people always show up after the miracle's already turned to ash.", "tyson")
	await ui.say("Carl", "Do you consent to being recorded about the events of today?", "carl")
	await ui.say("Tyson", "You already own most of the city. Might as well take my voice, too.", "tyson")
	await ui.say("Tyson", "A man with no eyes came out from behind the wall. But he wasn't alone.", "tyson")
	await ui.say("Tyson", "Tall figure. Black coat. Full face covering. Not a surgical mask. Something ceremonial. Eyeless Joe followed like a schoolkid following instructions.", "tyson")
	await ui.say("Carl", "Did the figure vanish?", "carl")
	await ui.say("Tyson", "Turned the corner. Never came out the other side. Like the city swallowed them whole.", "tyson")
	var pick := await ui.choose(["Could've been a hallucination.", "Tell me about the symbol.", "Why were you fired from SalTech?"])
	match pick:
		0:
			await ui.say("Carl", "Could've been a hallucination.", "carl")
			await ui.say("Tyson", "I'm not on ketamine. I taught math at SalTech. Twelve years. Calculus, symbolic logic. Then one quarter, I get a severance email. They'd swapped me for GPT-Learn 3.7.", "tyson")
			await ui.say("Tyson", "So don't talk to me about delusions. I know patterns. I know recursion. And I know what it looks like when someone's being programmed.", "tyson")
		1:
			await ui.say("Carl", "Tell me about the symbol.", "carl")
			Game.add_connection(1.0, "asked about the symbol")
		2:
			await ui.say("Carl", "Why did SalTech let you go?", "carl")
			await ui.say("Tyson", "They'd swapped me for GPT-Learn 3.7. Personalized AI instruction. Empathetic tutoring modules. And just like that, I was obsolete.", "tyson")
			await ui.think("He looked away for a second, then back. The anger had somewhere to go now. He trusted me a little more for asking.")
	await ui.say("Tyson", "That symbol? It's not an eye. It's a recursive shell. Input feeding into itself. It's not art. It's a ritual. Call and response. And someone, something, is starting to answer.", "tyson")
	await ui.say("Carl", "Psyon isn't sentient.", "carl")
	await ui.say("Tyson", "No. But something else might be. And it's using your system the way a voice uses a throat.", "tyson")
	await ui.say("Tyson", "People are whispering about 'The Dreamer'. Some think it's a god. Others, a consciousness waking up. Doesn't matter.", "tyson")
	await ui.say("Carl", "Who's whispering?", "carl")
	await ui.say("Tyson", "Everyone. Eventually.", "tyson")
	await ui.say("Tyson", "But don't think Psyonic runs this. Whatever it is, it's not theirs. It's using your tech like scaffolding. Like a parasite learning to code.", "tyson")
	await ui.think("My mouth was dry. I stopped recording.")
	ui.close()
	_tyson_done = true
	Game.log_entry("Tyson Clerif: Dufredy was led by a tall masked figure in a black coat. 'A recursive shell. Call and response.'")
	Game.log_entry("Street name for whatever is answering: The Dreamer.")
	Game.add_connection(1.0, "heard about the Dreamer")


func _try_leave() -> void:
	if not (_seth_done and _tyson_done):
		await ui.think("Two witnesses. I wasn't leaving until I had both on record.")
		ui.close()
		return
	await ui.think("I needed to return to headquarters. Write the report. Sync the logs. Pretend I was still in control.")
	await ui.think("Turan isn't going to like this one bit. The media attention on these incidents is reaching a fever pitch. But something is very wrong.")
	ui.close()
	Game.set_flag("park_done")
	await go_to_street("Home")
