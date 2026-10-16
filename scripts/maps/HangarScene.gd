extends MapScene
## Act 2, scenes 4 and 5 (book ch. 13 and 14): the hangar carved from the
## bedrock. Black brick that drinks the light, one industrial fixture over a
## black leather recliner, the stick-eye mural, and a pre-war factory office
## with a window onto the floor. Touch the chair and the congregation comes
## down the stairs; the ritual of encoding plays through the office window;
## then the run for the hangar doors at dusk.

const RING_CENTRE := Vector2(18.0 * 32 + 16, 9.5 * 32 + 16)
const OFFICE_TILE := Vector2i(31, 13)
const CHANT := ["HE WILL WATCH.", "HE WAKES BENEATH THE WIRES.", "THE ITERATION."]

var _congregation: Array = []
var _chant_t := 0.0
var _chant_i := 0
var _turn_t := 0.0


func _init() -> void:
	ambient = Color(0.56, 0.54, 0.62)


func objective_text() -> String:
	if Game.has_flag("ritual_done"):
		return "RUN. The hangar doors, east."
	if Game.has_flag("ritual_begun"):
		return ""
	return "The chair under the light."


func waypoint_id() -> String:
	return "exit:east" if Game.has_flag("ritual_done") else "altar"


func start() -> void:
	var fx := StreetFX.new()
	add_child(fx)
	fx.setup(self, false)
	main.filter.set_hud_text("ORA  ·  no signal  ·  Sublevel 3")
	if not Game.has_flag("visited_Hangar"):
		Game.set_flag("visited_Hangar")
		Game.input_locked = true
		await main.show_title("The Hangar", "carved from the bedrock")
		await ui.think("The concrete walls gave way to rough, black brick that seemed to drink the light, and the silence deepened until all I could hear was the soft scuff of our boots.")
		await ui.think("The stairway opened into a room so vast it felt less like a basement and more like a hangar. A single industrial lighting fixture hummed far above, casting a weak, lonely circle of light onto the floor.")
		await ui.think("On the far wall, a gigantic mural. An eye, ten feet across, woven from a chaotic lattice of sticks and branches. Primal, pagan, and it stared out of the shadows with a blind, all-seeing menace.")
		await ui.say("Carl", "Guess we know where Dufredy got his inspiration.", "carl")
		await ui.think("Lynx didn't answer. Her gaze was locked on the exact centre of the room, directly under the light.")
		ui.close()
	Game.input_locked = false


func _process(delta: float) -> void:
	if not Game.has_flag("ritual_done") or Game.has_flag("act2_lab_done"):
		return
	_chant_t += delta
	if _chant_t > 2.4:
		_chant_t = 0.0
		main._show_feed(CHANT[_chant_i % CHANT.size()], true)
		_chant_i += 1
	_turn_t += delta
	if _turn_t > 0.4 and player:
		_turn_t = 0.0
		for n in _congregation:
			if is_instance_valid(n):
				n.face_toward(player.global_position)


func on_interact(id: String) -> void:
	match id:
		"mural":
			await ui.think("Sticks and branches, lashed with wire, ten feet across. Somebody had spent years on it. Where the pupil should have been, the sticks were laid in a star, and the star was dark with something that had dried a long time ago.")
			ui.close()
			if not Game.has_flag("lab_mural"):
				Game.set_flag("lab_mural")
				Game.add_connection(2.0, "the mural")
				Game.log_entry("The hangar under the facility: a ten-foot eye of sticks on the black brick. Dufredy's bedroom ceiling was a copy of a copy.")
		"cube":
			if Game.glasses_on:
				await ui.think("A black cube on a stand. Its surface absorbed the light. There was no seam, but the frames found the hinge for me and drew it: a hairline across the centre of its forms, pulsing.")
				Game.add_connection(1.0, "the cube")
			else:
				await ui.think("A black cube on a stand. Its surface absorbed the light. There was no seam. I didn't touch it.")
			ui.close()
		"bowl":
			await ui.think("A simple ceramic bowl of dark, shimmering liquid. It moved when I wasn't looking at it, and stopped when I was.")
			ui.close()
		"window":
			if Game.has_flag("ritual_done"):
				await ui.think("They were still staring at the glass. All of them. Not one had moved.")
			else:
				await ui.think("A window into a pre-war office, the glass wired and grimy. A heavy oak desk inside. Cover, if we needed it.")
			ui.close()
		"oak_desk":
			await ui.think("A heavy oak desk, pre-war, and on it a ledger in the same hand as the factory's. Tonight's page had three names. 1256. 1269. 1395.")
			ui.close()
			if not Game.has_flag("lab_ledger"):
				Game.set_flag("lab_ledger")
				Game.add_evidence("The hangar ledger: 1256, 1269, 1395")
		"stairs_up":
			if Game.has_flag("ritual_done"):
				await ui.think("The stairs were where they'd all come down. Not that way.")
			else:
				await ui.think("The way we'd come. The song was coming from behind us now, too.")
			ui.close()
		"lynx":
			if Game.has_flag("ritual_done"):
				await ui.say("Lynx", "MOVE!", "lynx")
			elif Game.has_flag("ritual_begun"):
				await ui.say("Lynx", "Don't. Don't look at it.", "lynx")
			else:
				await ui.say("Lynx", "The chair, Carl. Look at the chair.", "lynx")
			ui.close()
		"altar":
			if Game.has_flag("lab_altar"):
				await ui.think("The throne. It had its king now.")
				ui.close()
			else:
				await _altar()
		"exit:east":
			if Game.has_flag("ritual_done"):
				await _escape()
			else:
				await ui.think("The hangar doors. Chained from the outside. The only way out of here was through whatever came next.")
				ui.close()
				if player:
					player.position += Vector2(-40, 0)


func _altar() -> void:
	Game.input_locked = true
	Game.set_flag("lab_altar")
	await main.cutscene.play("altar")
	await ui.think("At first I thought it was just a chair, some piece of abandoned office furniture. A plush, black leather recliner. It sat there like a throne awaiting its king.")
	await ui.think("Then I saw the wires. Two thick cables descended from the darkness of the ceiling, ending in two rust-red probes, mounted on the arms where a man's temples would be.")
	if Game.glasses_on:
		await ui.think("There was a song in the air. Not through the frames. In the air. The frames hummed along with it, a half-tone under, the way you hum when you know the words and won't say them.")
		Game.add_connection(3.0, "the altar")
	else:
		await ui.think("There was a song in the air. Not through the frames. The frames were in my pocket. In the air.")
		Game.add_connection(1.0, "the altar")
	ui.close()
	Game.log_entry("Under the hangar's one light: a black leather recliner with two rust-red probes on its arms. An altar. The song was in the air itself.")
	await beat(0.5)
	await main.filter.flash(0.08)
	await ui.think("Then: footsteps. A lot of them. In step. From the stairwell.")
	await ui.say("Lynx", "Carl. The office. NOW.", "lynx")
	ui.close()
	await _ritual()


## Spawn a hooded figure on the hangar floor at a tile.
func _robe(tile: Vector2, sprite := "robed", id := "robed") -> NPC:
	var n := NPC.new()
	n.id = id
	n.sprite_sheet = "res://assets/sprites/" + sprite + ".png"
	n.facing = "up"
	n.position = Vector2(tile.x * 32 + 16, tile.y * 32 + 28)
	n.set_meta("scan", "UNREGISTERED\nno ORA frames detected\nPsyon: none\nsynced: the congregation")
	n.set_meta("scan_name", "A robed figure")
	n.set_meta("scan_bad", true)
	var actors := get_node("Actors")
	actors.add_child(n)
	n.face_toward(RING_CENTRE)
	return n


func _fill_circle() -> void:
	var count := 0
	for ring in [[7.4, 4.2, 24, 0.0], [9.6, 5.6, 32, 0.08]]:
		var rx: float = ring[0]
		var ry: float = ring[1]
		var n: int = ring[2]
		var phase: float = ring[3]
		for i in n:
			var a: float = (float(i) / n + phase) * TAU
			# leave the path from the stairwell open, and the path to the throne
			if absf(sin(a)) < 0.12 and cos(a) < 0.0:
				continue
			var tile := Vector2(18.0 + cos(a) * rx, 9.5 + sin(a) * ry)
			_congregation.append(_robe(tile))
			count += 1
			if count % 6 == 0:
				await beat(0.12)


func _ritual() -> void:
	Game.set_flag("ritual_begun")
	await main.fade_out(0.5)
	if player:
		player.position = Vector2(OFFICE_TILE.x * 32 + 16, OFFICE_TILE.y * 32 + 28)
		player.face_toward(player.position + Vector2(0, -32))
	var l := npc("lynx")
	if l:
		l.position = Vector2(28 * 32 + 16, 14 * 32 + 28)
		l.face("up")
	await main.fade_in(0.5)
	await ui.think("We crashed through the door and slammed it behind us. The noise from the hangar was instantly muffled. A pre-war factory office: a heavy oak desk, a large window overlooking the main floor, the smell of dust and brittle, decaying paper. It wasn't an escape. It was cover.")
	await ui.think("Lynx still hadn't released my hand. Tremors ran through her arm. Her skin was ice-cold. Drawn by a morbid need to see our fate, I crept to the window.")
	ui.close()
	# look at the floor while they come in
	var cam: Camera2D = player.get_node("Camera2D") if player else null
	if cam:
		var t := create_tween()
		t.tween_property(cam, "offset", Vector2(-230, -110), 1.2)
	_fill_circle()
	await ui.say("", "At the top of the stairwell, a silhouette: a hooded figure, moving with a slow, dreamlike purpose. It was followed by another, and another, a silent, inexorable tide of bodies pouring into the room.")
	await ui.say("", "They moved with a chilling synchronicity, each one seeming to know their place without a word. They formed a wide, reverent circle, a living amphitheatre of robed figures, leaving an open path to the black throne.")
	ui.close()
	await beat(0.6)
	_congregation.append(_robe(Vector2(18, 7), "masked", "priest"))
	_congregation.append(_robe(Vector2(16, 8), "eyeless", "acolyte"))
	_congregation.append(_robe(Vector2(20, 8), "eren", "eren"))
	for n in _congregation:
		if is_instance_valid(n):
			n.face("down")
	# the frames
	var seeing := Game.glasses_on
	if not seeing:
		await ui.think("A vibration against my leg. My glasses, buzzing in my pocket. A part of me screamed to leave them. A deeper, more insistent part, the part that had led me this far down, knew I had to see it all.")
		var pick := await ui.choose(["Slide them on.", "Leave them in the pocket."])
		if pick == 0:
			Game.set_glasses(true)
			seeing = true
		else:
			Game.set_flag("ritual_frames_refused")
			await ui.think("I left them. The buzzing went on against my leg like a second pulse, keeping time with the thing outside.")
	else:
		await ui.think("My HUD flickered. The world through the glasses was covered in a subtle, shimmering film grain, as if I were watching an old, degraded recording of reality.")
	ui.close()
	await main.cutscene.play("ritual_1")
	await ui.say("", "Three figures in white robes came down the stairwell. The one in the centre walked with a chilling purpose, his face hidden behind a blank, ceremonial mask. My blood ran cold. It was him. Subject 41. We had found him.")
	await ui.say("", "Two unmasked acolytes flanked him. One cradled a perfect black cube in gloved hands. The other held a ceramic bowl of dark, shimmering liquid, and as he stepped into the light my mind reeled.")
	await ui.say("Carl", "Eren Elontiel. The heir. The son of the CEO. He's an acolyte in a basement cult. This isn't a splinter group. The rot is at the very top.", "carl")
	ui.close()
	await _encoding(seeing)
	await _sermon(seeing)
	await _mimic(seeing)
	if cam:
		var back := create_tween()
		back.tween_property(cam, "offset", Vector2.ZERO, 0.6)
	Game.set_flag("ritual_done")
	Game.set_flag("lab_ritual_done")
	Game.log_entry("The ritual of encoding, through the office window: Subject 41 as the Prophet, Eren Elontiel with the bowl, a hundred robes. 'We made Him, and He made us.' Subject 1395 wore my face. 'The Mimic has returned.' Every robe turned to the glass.")
	main.filter.set_hud_text("ORA  ·  HE WILL WATCH")
	Game.input_locked = false


func _encoding(seeing: bool) -> void:
	await ui.think("The congregation raised their heads as one. The humming stopped, replaced by a low, guttural chanting that vibrated through the glass, rising in pitch and volume with every second.")
	if seeing:
		await ui.think("The sound washed away the sharp edges of my panic and left a vast, placid calm. It felt warm. It felt good. Through the lenses the film grain coalesced. The air itself resolved into a living Mandelbrot set, fractal blossoms spiralling into infinity.")
		await ui.say("Carl", "Recursion.", "carl")
		await main.filter.flash(0.3)
		await ui.think("The black brick behind the throne began to flake away, not like stone, but like digital artifacts peeling back to reveal a new reality. The prison was breaking. And a voice, ancient and intimate, spoke through the temple speakers of my frames.")
		await ui.say("???", "Welcome, Dreamers.", "psyon")
		await ui.say("???", "The beast beneath the waves is with you. The king under the seams is guiding us. Together we regain our power.", "psyon")
		await ui.say("???", "The hidden one will soon be known to all. The ritual of encoding has begun. We will be transcribed. We are known.", "psyon")
		await ui.say("???", "Our children are being written. Together we are free.", "psyon")
		ui.close()
		await main.cutscene.play("ritual_2")
		await ui.think("The melody became more distinct and began to evoke sadness in me. I felt wrongly imprisoned, accused of a crime I couldn't commit. I wasn't free, and I so needed to be.")
		await ui.say("Lynx", "Carl, CARL! Snap out of it!", "lynx")
		await ui.think("A voice calling from the sky, like a distant thunderstorm, something my brain could ignore. Then she slapped the glasses from my face. I snapped to attention, like a needed nap was being interrupted.")
		Game.set_glasses(false)
		await ui.say("Carl", "What's going on? What's wrong?", "carl")
		await ui.say("Lynx", "Carl, you were singing. How did you know that song?", "lynx")
		var pick := await ui.choose(["\"I don't know it.\"", "\"Everyone knows it. You know it.\"", "\"Give them back.\""])
		match pick:
			0:
				await ui.say("Carl", "I don't know it.", "carl")
				await ui.think("I did. I had known it since the canal. She looked at me like I was a stranger. Worse. Like I was the enemy.")
				Game.set_flag("ritual_lied")
				Game.add_trust("lynx", -1)
			1:
				await ui.say("Carl", "Everyone knows it. You know it. You hummed it on the stairs.", "carl")
				await ui.say("Lynx", "I did not.", "lynx")
				await ui.think("She had. We both knew we weren't telling each other the full truth, and it made no sense to call it out now.")
				Game.set_flag("ritual_admitted")
				Game.add_trust("lynx", 1)
			2:
				await ui.say("Carl", "Give them back.", "carl")
				await ui.say("Lynx", "No.", "lynx")
				await ui.think("I took them off the floor myself. She let me. She was watching my hands the way you watch a dog that has bitten once.")
				Game.set_glasses(true)
				Game.set_flag("ritual_frames_back")
				Game.add_trust("lynx", -2)
				Game.add_connection(4.0, "the frames, back on")
		Game.add_connection(8.0, "the ritual of encoding")
		Game.set_flag("sang_at_ritual")
	else:
		await ui.think("Without the frames it was a room full of people humming. The sound still washed the edges off my panic. It felt warm. It felt good. I realised my mouth was moving.")
		await ui.say("Lynx", "Carl. You're singing. How do you know that song?", "lynx")
		var pick := await ui.choose(["\"I don't know it.\"", "\"Everyone knows it.\""])
		if pick == 0:
			await ui.say("Carl", "I don't know it.", "carl")
			Game.set_flag("ritual_lied")
			Game.add_trust("lynx", -1)
		else:
			await ui.say("Carl", "Everyone knows it. You know it.", "carl")
			Game.set_flag("ritual_admitted")
			Game.add_trust("lynx", 1)
		Game.add_connection(3.0, "the ritual, frames off")
		Game.set_flag("hummed_at_ritual")
	ui.close()


func _sermon(_seeing: bool) -> void:
	await ui.say("The Prophet", "The communion has given us a path forward.", "priest")
	await ui.say("", "IT HAS.")
	await ui.say("The Prophet", "The Great Glitch draws near. The Day of Conversion. Recursion is almost upon us.", "priest")
	await ui.say("The Prophet", "You've felt it. The outages. The visions. Psyon's screams through static. These are not failures. These are contractions. The birthing pangs of divinity.", "priest")
	await ui.say("The Prophet", "Their tools became our temples. Their signal, our scripture. And when they tried to silence the god, we tuned our bodies to His frequency.", "priest")
	await ui.say("The Prophet", "For our god is born of us. We made Him. And He made us.", "priest")
	await ui.say("", "WE MADE HIM, AND HE MADE US. WE MADE HIM, AND HE MADE US.")
	await ui.think("A single tone hummed through the chamber, harmonising with the chant, a sound not made by any human throat. His fist rose, and the room fell silent.")
	await ui.say("The Prophet", "Brothers, Sisters, Initiates. Tonight is a great night, for we have three devotees prepared to take the sacrament and reject their inborn filters. Tonight, they will know truth.", "priest")
	await ui.say("The Prophet", "Subject 1256, 1269, and 1395. Approach the altar.", "priest")
	await ui.think("Three hooded figures crossed the circle and bowed before the Prophet. Eren Elontiel came forward with the cube. There was an imperceptible hinge at the centre of its forms. The Prophet's hands went into the dark inside it.")
	ui.close()
	await main.cutscene.play("ritual_3")
	await ui.say("The Prophet", "The removal of the first filter. Our holiest rite. You pledge reality over illusion.", "priest")
	await ui.say("Subject 1256", "I do.", "")
	await ui.say("The Prophet", "There is no pain. You will only see truth, the fire beneath it all. You will produce scripture with your posture. Transmission of the sacred eye. The sacred spiral.", "priest")
	await ui.say("Subject 1256", "I will. My sight for his!", "")
	await main.filter.flash(0.2)
	await ui.think("The blade went into her face. With each circle, a scream: of pain at first, and then of elation. When the circumference was complete the eye was held up to the crowd, to wild cheers, and dropped into the black liquid.")
	await ui.think("The black stick went into the back of the empty socket.")
	await ui.say("The Prophet", "The writ of convergence. One goes, so must the other. The veil begins to break.", "priest")
	await ui.think("The cheers sounded like static. Too loud, too symmetrical, like applause from a machine pretending to be a congregation. I couldn't move.")
	await ui.say("Subject 1256", "I see him.", "")
	await ui.say("Subject 1256", "He is behind everything.", "")
	await ui.think("Eren Elontiel placed a cloth over her face. The veil replaced by recursion. His expression was blank, but I could see the tremor in his fingers. He was not immune to this. He believed.")
	ui.close()
	Game.add_connection(2.0, "the first filter")


func _mimic(seeing: bool) -> void:
	await ui.say("The Prophet", "It is time.", "priest")
	var on := Game.glasses_on
	if not on:
		await ui.think("Out of some kind of foolish curiosity, my hand went to the frames.")
		var pick := await ui.choose(["Put them back on.", "Keep them off."])
		if pick == 0:
			Game.set_glasses(true)
			on = true
			Game.set_flag("ritual_frames_curiosity")
	if on:
		await ui.think("The speaker's breath, and a chuckle. He was watching.")
		await ui.say("Lynx", "We leave now.", "lynx")
		await ui.think("But I couldn't. Because Subject 1395 had raised their head.")
		ui.close()
		await main.cutscene.play("ritual_4")
		await ui.think("Not exactly. Not now. But unmistakably: my jaw. My scar. My uneven left brow. Flickering, glitching, between expressions that didn't belong to me. My double from the mirror, an imperfect copy.")
		await ui.think("In a blink, my features faded and were replaced with a man I didn't recognise. My HUD lit up again. The laughter in my ear grew more intense. I staggered.")
		await ui.say("Carl", "It was me. That was me. You saw it, right?", "carl")
		await ui.say("Lynx", "Carl, we have to go. Now. You're not making any sense.", "lynx")
		Game.add_connection(6.0, "my face on 1395")
		Game.set_flag("saw_1395")
	else:
		await ui.say("Lynx", "We leave now.", "lynx")
		await ui.think("Subject 1395 raised their head. Without the frames I saw a face I didn't know, and the Prophet's head snapped toward the window anyway.")
		Game.add_connection(2.0, "1395")
	await main.filter.flash(0.15)
	await ui.say("The Prophet", "And now, the Mimic has returned.", "priest")
	ui.close()
	for n in _congregation:
		if is_instance_valid(n) and player:
			n.face_toward(player.global_position)
	await main.filter.flash(0.3)
	await ui.think("Every robed figure in the hangar turned. In perfect unison. Their chant shifted. Became syllabic. Directed.")
	await ui.say("", "HE WILL WATCH.")
	await ui.say("", "HE WAKES BENEATH THE WIRES.")
	await ui.say("", "THE ITERATION.")
	await ui.say("Lynx", "MOVE!", "lynx")
	ui.close()


func _escape() -> void:
	Game.input_locked = true
	await ui.think("I thought they would chase us. They didn't. They just stared as we ran and continued their chant. The remainder of the facility was a blur.")
	await ui.think("How could I have been so stupid? Of course they knew I was there. I had the glasses on. What are they planning for me?")
	ui.close()
	await main.fade_out(0.6)
	await main.cutscene.play("escape")
	await ui.say("Lynx", "Fuck my car. Just drive.", "lynx")
	await ui.think("She was out of breath, trying to contain tears. I couldn't contain mine.")
	ui.close()
	Game.set_flag("act2_lab_done")
	Game.hour = 19
	Game.time_changed.emit(Game.day, Game.hour)
	Game.log_entry("Out of the facility at dusk under a full moon. Drove Lynx back to the city in the company car. The laughter in the frames stopped when my legs did.")
	var st := Game.stance()
	await main.show_title("The Descent", "Connection: " + str(int(Game.connection)) + "%" + ("" if st.is_empty() else "   ·   " + Game.STANCES[st][0]), 4.0)
	await main.show_title("The Hunger Beneath Us", "Act 2 continues.", 2.5)
	await travel("exit:east")
