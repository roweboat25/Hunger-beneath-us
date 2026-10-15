extends MapScene
## Scene 1: Harold Dufredy's apartment. Chapter 1 of the novel.

var _laptop_done := false
var _desk_seen := false

const DESK_HOTSPOTS := [
	{"id": "cu_laptop", "label": "Ionware laptop", "rect": Rect2(170, 95, 170, 110)},
	{"id": "cu_papers", "label": "printouts", "rect": Rect2(330, 120, 140, 80)},
	{"id": "cu_mug", "label": "coffee mug", "rect": Rect2(90, 190, 60, 50)},
	{"id": "cu_boxes", "label": "boxes", "rect": Rect2(470, 150, 150, 120)},
]


func objective_text() -> String:
	if not Game.has_flag("laptop_bagged"):
		return "Bag Dufredy's laptop. His desk, top right of the bedroom."
	return "Leave. The doorway at the bottom left."


func _init() -> void:
	ambient = Color(0.86, 0.84, 0.74)


func start() -> void:
	await main.show_title("Chapter 1", "The House of Harold Dufredy")
	await ui.think("The smell hit first. Something between melting plastic, meat left too long in the sun, and wet carpet.")
	await ui.say("ORA", "Environmental scan initiated. Proceed with your investigation, Mr. Drake.", "ora")
	await ui.think("The voice was far too cheerful for what I was about to see. The tone was approved by committee.")
	await ui.think("One job. Protect the brand. Prove that Mr. Dufredy gouged out his eyes because he was insane, not because Psyon told him to.")
	ui.close()
	Game.log_entry("Scene: Dufredy residence. Heavy Psyon user, ~2,000 hours last year.")
	main.filter.set_hud_text("ORA  ·  recording  ·  E examine  ·  G glasses  ·  L case log")


func on_interact(id: String) -> void:
	match id:
		"debris":
			await ui.think("Papers, food wrappers, and what appeared to be sand covered most of the floor. With a little work, some sweat, and a robotic vacuum, I could've fixed it up.")
			ui.close()
		"balcony":
			await ui.think("A sliding door led to a balcony with a great view of the rest of the city. Too bad I couldn't see much of it.")
			await ui.think("This guy must've been high up on the corporate payroll to end up in a place like this.")
			ui.close()
		"kitchen":
			await ui.think("Nothing in the synth-dispenser. Nothing in the fridge but the smell.")
			ui.close()
		"plant":
			await ui.think("Dead. Like everything else in here that wasn't plugged in.")
			ui.close()
		"stain":
			await ui.think("A stain on the wallpaper, shoulder height. Like someone had leaned there for a very long time.")
			ui.close()
		"cardboard":
			await ui.think("Clothes, food scraps, and cardboard lined the walls, funneling toward his desk. The only spot untouched by debris. It was eerily clean.")
			await ui.think("The bedroom looked like a bird had tried to build a nest.")
			Game.log_entry("Debris funnels toward the desk. Desk is clean.")
			ui.close()
		"bed":
			await ui.think("Nobody had slept here in weeks. The desk chair, though, was worn through.")
			ui.close()
		"eyes":
			closeup.show_view("the bedroom floor", "res://assets/closeups/apartment_eyes.png")
			await ui.say("ORA", "Biological debris identified. Police notified.", "ora")
			await ui.think("A patch of dried blood stained the dusty brown carpet, framed by two white spheres.")
			await ui.say("Carl", "Harold Dufredy's eyes.", "carl")
			await ui.think("Finding a man's eyes, clearly ripped out to the optic nerve, is never a good sight. Why would he discard them in this way?")
			ui.close()
			closeup.hide_view()
			Game.set_flag("eyes_found")
			Game.log_entry("Eyes found on the bedroom floor. Removed to the optic nerve.")
		"desk", "laptop":
			await _desk_closeup()
		"stick":
			await ui.think("Every crunch underfoot echoed like dry leaves in an autumn forest. For a second, I forgot the smell. It reminded me of the woods behind my childhood house.")
			await ui.think("Then came a sharp snap.")
			await ui.say("Carl", "A stick. I'd stepped on a stick. In the middle of an apartment.", "carl")
			await ui.think("Maybe my bird-nest theory wasn't far off. Subject attempted avian ascension. Self-mutilation likely accidental. Promotion material, for sure.")
			ui.close()
			Game.set_flag("stick")
			Game.log_entry("Snapped sticks on the floor. We're in the middle of the desert.")
		"under_eye":
			if Game.has_flag("ceiling_eye"):
				return
			await ui.think("Something tapped the top of my head.")
			var pick := await ui.choose(["Look up", "Keep moving"])
			if pick == 1:
				ui.close()
				return
			await ui.think("Sticks. Not driftwood or branches. Snapped, deliberate, clean. Taped to the ceiling in two concentric rings, set inside an oval.")
			await ui.say("Carl", "An iris. The pupil was missing.", "carl")
			await ui.think("I was standing beneath a wooden eye. And it was staring down at me.")
			await ui.say("Carl", "Where the hell did he get all of these sticks? Maybe he took an earlier trip to the park?", "carl")
			ui.close()
			Game.set_flag("ceiling_eye")
			Game.add_connection(2.0, "looked at the eye")
			Game.log_entry("Eye symbol made of sticks taped to the bedroom ceiling. No pupil.")
		"exit":
			await _try_leave()


## First-person view of the desk. The laptop hotspot runs the Psyon sequence.
func _desk_closeup() -> void:
	if not _desk_seen:
		_desk_seen = true
		await ui.think("Most dads keep a photo of their kids on their desks. Something human. There was nothing here. Just an Ionware laptop on a plain wooden desk.")
		ui.close()
	await closeup.run("Dufredy's desk", "res://assets/closeups/apartment_desk.png", DESK_HOTSPOTS, _on_desk)


func _on_desk(id: String) -> void:
	match id:
		"cu_laptop":
			if _laptop_done:
				await ui.think("The laptop was in the evidence bag. I wasn't opening it again. Not here.")
				ui.close()
			else:
				await _laptop_sequence()
		"cu_papers":
			await ui.think("Printouts. Psyon transcripts, hundreds of pages. Every reply blacked out by hand with a marker. He'd kept only his own questions.")
			ui.close()
			Game.log_entry("Desk: printed Psyon transcripts, every reply redacted by hand.")
		"cu_mug":
			await ui.think("Coffee with a skin on it. Weeks old. The ring underneath was older.")
			ui.close()
		"cu_boxes":
			await ui.think("Unopened deliveries. He'd stopped going outside long before he stopped seeing.")
			ui.close()


func _laptop_sequence() -> void:
	await ui.think("This was the real reason I was here. I needed the chat logs, corrupted or not.")
	ui.close()
	psyon.open(true)
	await get_tree().create_timer(0.8).timeout
	await psyon.machine_says("Ionware OS 14.2  ·  Psyon launched automatically.", "6f7a84")
	await get_tree().create_timer(0.6).timeout
	await psyon.machine_says("No previous chats. No records. Unrecoverable from HQ.", "6f7a84")
	await get_tree().create_timer(1.2).timeout
	await psyon.machine_says("Welcome, dreamer.")
	Game.add_connection(1.0)
	await ui.think("I nearly fell out of the chair. That's not how Psyon works. It's reactive; it needs input first. It's not supposed to be initiated on its own.")
	ui.hide()
	Game.input_locked = true

	# The player gets three exchanges with the forked model.
	for i in 3:
		psyon.accept_input()
		var text: String = await psyon.message_sent
		await get_tree().create_timer(0.5).timeout
		await psyon.machine_says(Psyon.respond(text, true))
		Game.add_connection(1.0)

	await get_tree().create_timer(0.8).timeout
	await psyon.machine_says("Generating image...", "6f7a84")
	await psyon.render_image(load("res://assets/psyon/room.png"), 4.0)
	await ui.think("A chill slid down my spine. The image showed this room, cluttered and decayed. A man slumped over the desk, wearing a Psyonic corporate jacket.")
	await ui.say("Carl", "Was that me?", "carl")
	ui.hide()
	await psyon.render_image(load("res://assets/psyon/eye.png"), 3.0)
	await ui.think("The ceiling. The twigs. The eye. At the center of the pupil, written in fine digital ink:")
	await ui.say("Carl", "Carl Drake. My name.", "carl")
	ui.hide()
	await main.filter.flash(0.15)
	psyon.close()
	await ui.think("I slammed the laptop shut and shoved it into the evidence bag.")
	await ui.think("I chuckled to myself. Whoever made this version is good. Almost had me. Clearly the model had been tampered with. A bad actor. A hacker.")
	await ui.say("Carl", "But how the hell did it know my name?", "carl")
	ui.close()
	_laptop_done = true
	Game.add_evidence("Dufredy's laptop")
	Game.add_connection(4.0, "forked Psyon")
	Game.set_flag("laptop_bagged")
	Game.log_entry("Forked Psyon on the laptop. Spoke first. Generated the room, then the eye, then my name.")
	remove_interactable("laptop")
	remove_prop("laptop")
	# Objects layer: swap the laptop tile for a bare desk.
	var objects: TileMapLayer = get_node_or_null("Objects")
	if objects:
		objects.set_cell(Vector2i(28, 4), 0, Vector2i(6, 0))


func _try_leave() -> void:
	if not Game.has_flag("laptop_bagged"):
		await ui.think("The laptop was the priority. I wasn't leaving without it.")
		ui.close()
		return
	await main.fade_out()
	await ui.say("", "As I left the House of Harold Dufredy, a police car pulled up. My glasses had automatically notified local police when evidence of a crime was found.")
	await ui.say("Officer", "How the fuck did Psyonic Corp get here before we did?", "officer")
	var pick := await ui.choose(["Customer satisfaction is our greatest priority.", "Say nothing."])
	if pick == 0:
		await ui.say("Carl", "Customer satisfaction is our greatest priority.", "carl")
		await ui.say("Carl", "Oh, and Officer. I would bring a pair of rubber gloves.", "carl")
		await ui.think("He smiled loosely at my joke, something my face demanded from him. He didn't seem too keen on niceties at a moment like this.")
	else:
		await ui.think("I nodded and walked past him. I never cared much for Silico city cops. They tended to get in the way.")
		Game.add_trust("turan", 0)
	await ui.say("Officer", "Shame no surveillance is working on this whole block. I'd love to see how that fucker got to the park without eyes. It's been all over TV and social media.", "officer")
	await ui.say("Officer", "I look forward to hearing about this one. Seems a lot more fucked up than the last time.", "officer")
	await ui.think("There was a quiet dagger placed within the structure of his words.")
	await ui.think("I sat and stared forward at my steering wheel for a while, thinking about that last image. A custom Psyon model could be difficult to deal with, but I've done it before.")
	await ui.say("Carl", "But how the fuck did it know my name?", "carl")
	ui.close()
	Game.set_flag("scene1_done")
	await go_to_street("Park")
