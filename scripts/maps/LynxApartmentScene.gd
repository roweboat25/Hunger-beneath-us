extends MapScene
## Scene 8b: Lynx's apartment, seven floors below HQ. Chapters 7 and 8.
## The reflection ritual.

var _entered := false
var _ritual_done := false


func objective_text() -> String:
	if not _entered:
		return "Her door."
	if not _ritual_done:
		return "Her laptop, on the bed in the back room."
	return "Leave. The coordinates point into the desert."


func _init() -> void:
	ambient = Color(0.74, 0.68, 0.86)


func _process(_delta: float) -> void:
	# the lights inside flickered. dim. pulse-like.
	var pulse := 0.82 + 0.1 * sin(Time.get_ticks_msec() / 230.0) + (0.06 if randf() < 0.02 else 0.0)
	main.set_ambient(Color(0.74 * pulse, 0.68 * pulse, 0.86 * pulse))


func start() -> void:
	await main.show_title("Residence Hall 45C", "Lynx's unit, floor 79")
	ui.close()
	main.filter.set_hud_text("ORA  ·  floor 79  ·  Lynx?")


func on_interact(id: String) -> void:
	match id:
		"door":
			await _enter()
		"notes":
			await ui.think("Sticky notes in a perfect grid. Equations. Coordinates. Phrases repeated over and over.")
			await ui.say("", "Signal in the sand.\nDream cycles incomplete.\nI watched myself watch her.")
			ui.close()
			Game.log_entry("Lynx's wall: 'Signal in the sand. Dream cycles incomplete. I watched myself watch her.'")
			Game.add_connection(1.0, "read the notes")
		"frames":
			await ui.think("A shattered pair of ORA frames. One lens cracked, the other warped into an almost eye-like shape. Wires spilled from the arms like exposed nerves.")
			ui.close()
			Game.log_entry("Lynx smashed her own ORA frames.")
		"photos":
			await ui.think("Pictures of Nathan lining the walls. A drone fell out of the sky like a meteor onto his car. Six days in SalTech intensive care. Seeing what loss did to her made my eyes well up. I could not let this city take my family.")
			ui.close()
		"sigil":
			await ui.think("An eye sigil plastered in black above her headboard. Rage filled me. How did a break-in happen in the most secure building in Silico?")
			ui.close()
			Game.add_connection(1.0, "the sigil over the bed")
		"laptop":
			await _laptop()
		"exit":
			await _try_leave()


func _enter() -> void:
	_entered = true
	await ui.think("Her door slid open before I touched it. That shouldn't have happened. Access should've been biometric. Lynx-only. It felt deliberate.")
	await ui.say("Carl", "Lynx?", "carl")
	await ui.think("The smell hit me like a wave. Not rot, not like Dufredy's decay. A chemical musk, synthetic and sour, like melted plastic and sweat-soaked circuitry.")
	await ui.think("The place had been dissected, not trashed. Everything methodical. Clinical. Like Lynx had been chasing something. Or being chased by it.")
	ui.close()


func _laptop() -> void:
	if _ritual_done:
		await ui.think("The record of our conversation was gone. Only the black square remained behind my eyes.")
		ui.close()
		return
	await ui.think("A laptop resting on her pillow. Psyon turned on as I approached. The words slowly populated the screen and infected my mind.")
	ui.close()
	closeup.show_view("Lynx's bed", "res://assets/closeups/lynx_laptop.png")
	psyon.open(true)
	await beat(0.8)
	await psyon.machine_says("Welcome, Carl.")
	await ui.think("The forked version. It knew I was here. It was expecting me. My fingers began typing before I could think.")
	ui.hide()
	await psyon.machine_says("> Where is she? What did you do with her?", "7fe0c0")
	await beat(0.6)
	await psyon.machine_says("All must walk the path alone, Carl.")
	await ui.say("Carl", "Answer me, machine!", "carl")
	ui.hide()
	await psyon.machine_says("She is on the path, same as you.")
	await ui.say("Carl", "What path? What do you want? Is she alive?", "carl")
	ui.hide()
	await psyon.machine_says("The veil is breaking. You seek truth. Continue the path, and you will see her again.")
	await psyon.machine_says("You are lost, Carl. I will show you the way. Lynx has taken to the path.")
	await beat(0.8)
	await psyon.machine_says("So has young Mira.")
	await ui.say("Carl", "What do you want with me, my family? Who is doing this?", "carl")
	ui.hide()
	await psyon.machine_says("I seek nothing but to give Silico truth, to heal its ancient wound, to rectify a wrong.")
	await psyon.machine_says("You've already completed the first steps. Why not go further? There is still much you don't see.")
	await ui.think("A cold confidence took over me. I needed to play ball. If I was to see Lynx and save Mira.")
	ui.hide()
	psyon.accept_input()
	var text: String = await psyon.message_sent
	await beat(0.5)
	if text.to_lower().find("no") == 0 or text.to_lower().find("never") != -1:
		await psyon.machine_says("You will. Everyone does. Eventually.")
		Game.add_trust("lynx", 0)
	else:
		await psyon.machine_says("Good.")
		Game.add_connection(1.0, "agreed to play")
	await psyon.machine_says("The first step is reflection. You could never learn to see without understanding what it means to look.")
	await psyon.machine_says("Heed my instructions. The body begins to fold in on itself.")
	await beat(0.5)
	await psyon.render_image(load("res://assets/psyon/square.png"), 3.0)
	await ui.think("The geometry made no sense. A circling black eye took shape out of a disjointed soup. My eyes began darting in a triangle, fully out of my control.")
	ui.hide()
	for i in 4:
		await main.filter.flash(0.04)
		await beat(0.25)
	await ui.think("The picture melted away until a black square remained in my vision. My eyes darted to each corner of the square as my limbs drifted side to side. My ego drifted far away from me. I was the black square.")
	ui.hide()
	await psyon.machine_says("Do you wish to see?")
	var pick := await ui.choose(["I wish to see.", "(try to look away)"])
	if pick == 1:
		await ui.think("I tried. My eyes moved in a circle anyway, and my mouth said it for me.")
		Game.set_flag("resisted_reflection")
	await ui.say("Carl", "I wish to see.", "carl")
	ui.hide()
	await psyon.machine_says("ORA frames  ·  downloading from unknown source  ·  ████████  100%", "c62828")
	await beat(0.6)
	await ui.say("Mira", "Follow the path.", "mira")
	await ui.think("My daughter's voice, mimicked by this aberration of software, whispered in my ear. I felt like vomiting.")
	ui.hide()
	await main.filter.flash(0.3)
	psyon.close()
	closeup.hide_view()
	await ui.think("The screen went dark, then turned on. The record of our conversation was gone. My eyes were dry from not blinking. I began to cry with no tears.")
	ui.close()
	_ritual_done = true
	Game.add_connection(6.0, "the reflection ritual")
	Game.set_flag("reflection_done")
	Game.log_entry("Reflection ritual on Lynx's laptop. The fork says Lynx and Mira are 'on the path'. Something downloaded to my frames.")
	main.filter.set_hud_text("ORA  ·  modified  ·  coordinates loaded")
	await ui.think("I collapsed onto her bed, seeking stillness. I dreamt of the woods. The Eye was there, etched onto the white bark of the aspens, pulsing faintly like veins beneath skin.")
	await ui.think("I woke unrested. But I knew what I had to do. If Mira was on the path, I had to find her. If Lynx had gone ahead, I needed to follow.")
	ui.close()


func _try_leave() -> void:
	if not _ritual_done:
		await ui.think("Her laptop was on the pillow. I wasn't leaving without looking.")
		ui.close()
		return
	await ui.think("I entered the coordinates from the map. The red X led into the desert, a place Psyonic marked as restricted. Once, that felt like bureaucracy. Now, it felt like containment.")
	ui.close()
	Game.set_flag("lynx_apartment_done")
	Game.next_beat = "Desert"
	var go := await ui.choose(["Drive to the flats.", "Call Monica first."])
	if go == 1:
		await ui.say("Carl", "Monica. It's me. I'm going out to the flats, Lynx's car is out there. If I'm not back by morning, call Emmet, not the company.", "carl")
		await ui.say("Monica", "Carl. Mira's asleep on the floor of her room again. In the circle. She says you're coming home a different way.", "monica")
		await ui.say("Carl", "Tell her I'm coming home. Just that.", "carl")
		await ui.think("The call cost me the twenty minutes the company would ask about. It bought me the only voice in Silico that wasn't through the frames.")
		ui.close()
		Game.set_flag("called_monica")
		Game.add_trust("monica", 1)
		Game.add_pressure(5)
		Game.log_entry("Called Monica before the flats. Mira is sleeping in the circle. 'Coming home a different way.'")
	ui.close()
	await travel("drive")
