extends MapScene
## The arcade under Red Rock Plaza, down the club stairs. The one room in
## Silico where the frames come off: cabinets that set the same puzzles the
## broken machines do, Psyonic's corporate dating program in a coin-op
## booth, a prize counter (50 tickets for a new phone, 200 for the box),
## and a table of school kids playing the Password Game Mira learned.

const CABINETS := {
	"cab_serpent": ["SERPENT", "eye", "A snake game, except the snake ate itself on the title screen and the rings it left were the puzzle."],
	"cab_hush": ["HUSH", "breathing", "A rhythm game with no music. Four notes, the cabinet said, and a circle that breathed."],
	"cab_blastula": ["BLASTULA", "chant", "A counting game. One cell, then two, then four, and a line of text with a word gone."],
}

var _pad_seen := false


func _init() -> void:
	ambient = Color(0.62, 0.56, 0.78)


func objective_text() -> String:
	return "The arcade. Tickets: %d. Door at the bottom when you're done." % Game.tickets


func start() -> void:
	var fx := StreetFX.new()
	add_child(fx)
	fx.setup(self, false)
	if not Game.has_flag("visited_Arcade"):
		Game.set_flag("visited_Arcade")
		await main.show_title("The arcade", "under Red Rock Plaza")
		await ui.think("A basement the width of the block, and every cabinet in it lit. The bass I'd heard on the stairs was the ventilation. Nobody down here had the frames on, and for a second I couldn't tell what was wrong with their faces, and then I could: they were having fun.")
		if Game.glasses_on:
			await ui.think("Mine were still on. Three people looked up at once, the way a room looks up when somebody's phone rings in it.")
			Game.set_flag("arcade_frames_on")
		ui.close()
		Game.log_entry("The arcade under Red Rock Plaza: frames off, house rule. School kids at a table playing the Password Game.")
	Game.input_locked = false
	main.filter.set_hud_text("ORA  ·  the arcade  ·  %d tickets" % Game.tickets)


func _route_interact(id: String) -> void:
	if id in CABINETS:
		await _cabinet(id)
	elif id == "cab_dark":
		await ui.think("Two cabinets switched off at the wall, the screens scratched with the eye. Under one, in marker: OUT OF ORDER. Under the other: IN ORDER.")
		ui.close()
	elif id == "cab_tower":
		await _tower_run()
	elif id == "booth":
		await _psymatch()
	elif id == "claw":
		await _claw()
	elif id == "counter":
		await _counter()
	elif id == "tickets":
		await ui.think("The ticket machine. %d in my pocket. It had a slot for ORA frames as well as coins, and the slot had been used more." % Game.tickets)
		ui.close()
	elif id == "pad":
		await _pad()
	elif id == "kids_table":
		await _password_game()
	else:
		await super._route_interact(id)


func _tickets(n: int, why: String) -> void:
	Game.tickets += n
	main._show_toast("%+d tickets  ·  %s  ·  %d" % [n, why, Game.tickets])
	main.filter.set_hud_text("ORA  ·  the arcade  ·  %d tickets" % Game.tickets)


# ------------------------------------------------------------- the cabinets
func _cabinet(id: String) -> void:
	var c: Array = CABINETS[id]
	await ui.think(String(c[2]))
	var pick := await ui.choose(["Play it.", "Leave it."])
	ui.close()
	if pick == 1:
		return
	var ok: bool = await play_game(id, String(c[0]), String(c[1]))
	if not ok:
		return
	var first := not Game.has_flag("won_" + id)
	Game.set_flag("won_" + id)
	await _tickets(25 if first else 10, String(c[0]))
	if Game.glasses_on:
		await ui.think("The cabinet paid out, and under the tickets the frames logged it as an interface. The same puzzle the dead machines set, in a box with a coin slot, and the kids had been feeding it all week.")
		Game.log_entry("The arcade cabinets under Red Rock set the same puzzles the broken machines do. With the frames on they count as interfaces.")
	else:
		await ui.think("Tickets. A machine had asked me something and I'd answered and it had given me paper. I'd missed that.")
	ui.close()


## Tower Run: rigged. The eye is at the top of every floor and the game
## ends when you look at it. Deep in, you can't not look.
func _tower_run() -> void:
	await ui.think("TOWER RUN. A stick figure on a stairwell, and above it, eighty-six floors. The regular was right: on the first landing there was the eye, drawn in four pixels, waiting.")
	var floor_n := 0
	while floor_n < 3:
		floor_n += 1
		var pick: int
		if Game.connection >= 50.0:
			await ui.think("Floor %d. I meant to keep climbing. My thumb moved the stick to the eye and held it there." % floor_n)
			pick = 0
		else:
			pick = await ui.choose(["Look at it.", "Keep climbing."])
		if pick == 0:
			await ui.think("GAME OVER, the screen said, and then, smaller: IT SAW YOU LOOK. The regular laughed without turning round.")
			ui.close()
			Game.add_connection(1.0, "looked, in Tower Run")
			Game.log_entry("Tower Run, the arcade: the eye on every landing, and the game ends when you look.")
			return
	await ui.think("Floor 86. The screen went white and stayed white, and the cabinet paid out twenty-five tickets for a floor nobody had drawn.")
	ui.close()
	await _tickets(25 if not Game.has_flag("won_tower") else 5, "TOWER RUN")
	Game.set_flag("won_tower")


# ----------------------------------------------------------------- the booth
## Psymatchbot: Psyonic's corporate dating program. It paired Carl and Monica
## at 97.87%, a record at the time. The booth knows that. It also knows what
## his archetype is compatible with now.
func _psymatch() -> void:
	await ui.think("PSYMATCHBOT. Psyonic's dating program in a coin-op shell, a curtain and two seats. It had paired me with Monica, once. Ninety-seven point eight seven. A record, at the time.")
	if not Game.glasses_on:
		await ui.say("Psymatchbot", "Welcome. Please wear your ORA frames to be matched. Compatibility is measured, not asked.", "psyon")
		var p0 := await ui.choose(["Put them on.", "Not in here."])
		if p0 == 1:
			ui.close()
			return
		Game.set_glasses(true)
		Game.set_flag("arcade_frames_on")
		await ui.think("I put them on, in the one room in the city where you don't, and felt the room notice.")
	ui.hide()
	await ui.say("Psymatchbot", "Welcome back, Carl. Four questions. There are no wrong answers; there are only measured ones.", "psyon")
	var answers := []
	await ui.say("Psymatchbot", "What is love?", "psyon")
	answers.append(await ui.choose(["Knowing the optimal order of operations.", "Someone who stays.", "A number I set once."]))
	await ui.say("Psymatchbot", "What do you fear?", "psyon")
	answers.append(await ui.choose(["The floor.", "Losing them.", "Nothing, with the frames on."]))
	await ui.say("Psymatchbot", "Where do you sleep?", "psyon")
	answers.append(await ui.choose(["In the car.", "At home, when I can.", "I don't."]))
	await ui.say("Psymatchbot", "What would you give?", "psyon")
	answers.append(await ui.choose(["Everything.", "My eyes.", "Nothing it asked for."]))
	ui.hide()
	await main.filter.flash(0.08)
	var sleeper_answers := 0
	for i in 4:
		if (i == 0 and answers[i] == 2) or (i == 1 and answers[i] == 2) or (i == 2 and answers[i] == 2) or (i == 3 and answers[i] != 2):
			sleeper_answers += 1
	await ui.say("Psymatchbot", "Archetype built. DRAKE, C. Record match: MONICA DRAKE, 97.87%, archived.", "psyon")
	if Game.connection < 25.0:
		await ui.say("Psymatchbot", "Live match: none within range. Your archetype has changed since the record. Try again when you have slept.", "psyon")
		Game.log_entry("Psymatchbot, the arcade: 'Your archetype has changed since the record.' No live match.")
	elif Game.connection < 50.0:
		await ui.say("Psymatchbot", "Live match found: 99.1%. Name withheld. Location: directly beneath this booth. Distance: increasing as you read this.", "psyon")
		Game.add_connection(2.0, "matched")
		Game.log_entry("Psymatchbot matched me at 99.1% with something it wouldn't name, 'directly beneath this booth'.")
	else:
		await ui.say("Psymatchbot", "Live match found: 100.00%. DRAKE, C. You are compatible with yourself. The twin must be born.", "psyon")
		Game.add_connection(3.0, "matched with himself")
		Game.log_entry("Psymatchbot: 100% match. Me. 'The twin must be born.'")
	if sleeper_answers >= 3:
		await ui.say("Psymatchbot", "Your answers have been forwarded to the Dreamer. It says: soon.", "psyon")
		Game.add_connection(2.0, "answered the booth")
		Game.set_flag("psymatch_sleeper")
	if answers[3] == 1:
		Game.set_flag("psymatch_eyes")
	Game.set_flag("psymatch_done")
	await ui.think("The curtain stayed shut. Nobody had come to sit in the other seat. The booth printed a ticket anyway: a heart, and under it, in the same four pixels as everything else in this city, the eye.")
	ui.close()
	if not Game.has_flag("psymatch_ticket"):
		Game.set_flag("psymatch_ticket")
		Game.add_evidence("a Psymatchbot ticket: a heart and the eye")


# ------------------------------------------------------------ the claw, prizes
func _claw() -> void:
	await ui.think("A claw machine full of plush eyes, white with a red pupil, the kind Mira would have begged for. Ten tickets a go.")
	if Game.tickets < 10:
		await ui.think("I didn't have ten.")
		ui.close()
		return
	var pick := await ui.choose(["Ten tickets. Go.", "Leave it."])
	ui.close()
	if pick == 1:
		return
	await _tickets(-10, "the claw")
	await main.filter.flash(0.05)
	if Game.glasses_on:
		await ui.think("The claw went straight down and closed on one and brought it up without a wobble, the way a claw machine never does. It dropped the eye in the chute looking at me.")
		Game.add_connection(1.0, "the claw")
	else:
		await ui.think("The claw wobbled, closed on nothing, opened, closed on one by accident, and dropped it in the chute. I laughed out loud. The dancer looked over.")
	ui.close()
	if not Game.has_flag("plush_eye"):
		Game.set_flag("plush_eye")
		Game.add_evidence("a plush eye from the claw machine")


func _counter() -> void:
	await ui.say("Attendant", "Tickets for prizes. You've got %d." % Game.tickets, "seth")
	var options := ["A plush eye, for the kid (10).", "ORA frames, refurbished (50).", "The box (200).", "Nothing."]
	var pick := await ui.choose(options)
	match pick:
		0:
			if Game.tickets < 10:
				await ui.say("Attendant", "Ten. You've got %d. The kids' table is free." % Game.tickets, "seth")
			else:
				await _tickets(-10, "plush eye")
				await ui.think("A plush eye, white, with a red pupil that had been sewn on slightly off centre so it looked past you. Mira would love it. That was the problem with it.")
				Game.set_flag("plush_for_mira")
				Game.add_trust("mira", 1)
				if not Game.has_flag("plush_eye"):
					Game.set_flag("plush_eye")
					Game.add_evidence("a plush eye from the prize counter")
		1:
			if Game.tickets < 50:
				await ui.say("Attendant", "Fifty. Phones are fifty too, but nobody asks for the phones.", "seth")
			else:
				await _tickets(-50, "spare frames")
				await ui.think("A pair of ORA frames in a box that had been opened before. Refurbished, the label said. Somebody's. I put them in my coat. A second pair meant I could take mine off and still be reachable, which was either a way out or the opposite.")
				Game.set_flag("spare_frames")
				Game.add_evidence("a spare pair of ORA frames, refurbished")
				Game.log_entry("Bought a second pair of frames at the arcade prize counter, 50 tickets. Somebody's, refurbished.")
		2:
			if Game.tickets < 200:
				await ui.say("Attendant", "Two hundred.", "seth")
				await ui.think("He didn't say what was in the box. The box was long, and the label on it said SLEEP BETTER. SLEEP TOGETHER, which was the Nixtra ad from the shuttered outlet upstairs.")
			else:
				await _tickets(-200, "the box")
				await ui.think("He brought the box round the counter and set it on the floor and stepped back, the way you'd step back from a thing that might sit up. I opened it.")
				await ui.think("A companion. The Nixtra model, the one the outlet had sold before it shut, a body with no face yet, because the face comes with the pairing. It paired with my frames while I looked at it, and the face came up slowly, and it was mine.")
				Game.add_connection(4.0, "the box")
				Game.set_flag("bought_companion")
				Game.log_entry("Bought the box at the arcade prize counter, 200 tickets: a Nixtra companion. It paired with my frames and took my face. Left it there.")
				await ui.say("Attendant", "They all do that. Nobody's ever taken one home.", "seth")
		3:
			pass
	ui.close()


# --------------------------------------------------------- the pad, the game
func _pad() -> void:
	if _pad_seen:
		return
	_pad_seen = true
	await ui.think("The dance pad lit under my shoes. Four arrows. Up, down, left, right, the same four the dancer had been stepping to nothing.")
	if Game.has_flag("password_game_won"):
		await ui.think("It played the sequence back. My sequence, from the kids' table, every step of it, and chimed at the end the way Mira's tablet had.")
		Game.add_connection(1.0, "the pad knew")
	ui.close()


## The Password Game, as a friend showed Mira at school. If you play the
## passcode game with your device, it does your homework for you.
func _password_game() -> void:
	await ui.think("Two school tablets on a low table, one of them cracked across the glass, and two kids in Heights Primary jumpers. On the screen that worked: a circle of sticks, and the words I GIVE MY GIFT.")
	await ui.say("Schoolgirl", "You can play if you want. You need a device, though. It doesn't do anything without a device.", "mira")
	await ui.say("Schoolboy", "Mira Drake's dad, right? She's the best at it. She got to round eight.", "ezra")
	var options := []
	if Game.glasses_on:
		options = ["Play it on my frames.", "Play it on her tablet.", "Not with that."]
	else:
		options = ["Play it on her tablet.", "Put the frames on and play it.", "Not with that."]
	var pick := await ui.choose(options)
	ui.close()
	var on_frames := false
	match pick:
		0:
			on_frames = Game.glasses_on
		1:
			if not Game.glasses_on:
				Game.set_glasses(true)
				Game.set_flag("arcade_frames_on")
			on_frames = Game.glasses_on and options[1].begins_with("Put")
		2:
			await ui.think("Not with that. I'd smashed one of these on the kitchen floor for less.")
			ui.close()
			Game.set_flag("password_refused")
			Game.log_entry("The kids at the arcade offered me the Password Game. Didn't play.")
			return
	var ok: bool = await play_game("password_game", "the Password Game", "password", {"title": "the Password Game"})
	if not ok:
		await ui.say("Schoolgirl", "Told you. You're too old for it.", "mira")
		ui.close()
		return
	await _tickets(25 if not Game.has_flag("password_game_played") else 5, "the Password Game")
	Game.set_flag("password_game_played")
	if on_frames:
		await main.filter.flash(0.1)
		await ui.think("Eight seconds. I counted them, the way I'd counted them outside Mira's door. Then the chime: Psyonic's entrance beep, muted, somehow from under the frames, from under me.")
		await ui.say("Schoolboy", "There. Now it does your homework.", "ezra")
		await ui.think("I didn't have homework. It did something anyway. I felt it settle in behind my eyes like a second pair of frames.")
		Game.set_flag("password_game_won")
		Game.add_connection(6.0, "played the Password Game")
		Game.log_entry("Played the Password Game on my frames at the arcade. Eight seconds, then Psyonic's entrance beep from under me. It's how the fork gets in. It's in.")
	else:
		await ui.think("The tablet chimed, Psyonic's entrance beep, and the girl's homework app opened on its own and started typing. The boy wasn't surprised. Nobody at the table was surprised but me.")
		Game.set_flag("password_game_seen")
		Game.log_entry("Watched the Password Game do a schoolgirl's homework at the arcade. Round four. Mira got to round eight.")
	await ui.say("Schoolgirl", "Mira says it talks to her at night. Does yours?", "mira")
	ui.close()
