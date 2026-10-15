extends MapScene
## Scene 6: Southtown. Chapter 5. Lynx, the old footage, the overpass eye,
## and the map.

var _met_lynx := false
var _eye_sprite: Sprite2D


func objective_text() -> String:
	if not _met_lynx:
		return "Lynx is waiting at the station."
	return "Follow the glyphs east, to the overpass."


func _init() -> void:
	ambient = Color(0.95, 0.72, 0.62)


func start() -> void:
	# the ten-foot eye painted on the underside of the overpass
	_eye_sprite = Sprite2D.new()
	_eye_sprite.texture = load("res://assets/ui/eye_glyph.png")
	_eye_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_eye_sprite.scale = Vector2(3, 3)
	_eye_sprite.modulate = Color(0.05, 0.05, 0.06, 0.9)
	_eye_sprite.position = Vector2(44 * 32 + 16, 9 * 32 + 16)
	_eye_sprite.z_index = 1
	add_child(_eye_sprite)
	await main.show_title("Southwest Station", "Southtown, the industrial core")
	await ui.think("The trains still ran, a spectral echo of their former efficiency. Here people wore no visible tech. No AR glasses, no smartwatches. Nothing that blinked.")
	await ui.think("Lynx was already there, slouched against the station's outer wall, arms crossed tight. She seemed smaller than I remembered. And unmistakably worried.")
	ui.close()
	main.filter.set_hud_text("ORA  ·  Southtown  ·  Lynx is at the station")


func on_interact(id: String) -> void:
	match id:
		"lynx":
			await _lynx()
		"station":
			await ui.think("Timetables that were more optimistic suggestions than rigid mandates.")
			ui.close()
		"factory":
			await ui.think("The skeletal remains of an abandoned Voltx factory, its once-proud metal limbs twisted and rusting.")
			ui.close()
		"shanty":
			await ui.think("A half-standing shanty town clinging to the edge of oblivion. Whoever lived here was on a shift at the fulfilment center.")
			ui.close()
		"glyph_station", "glyph_factory", "glyph_far":
			await _glyph(id)
		"overpass":
			await _overpass()
		"exit":
			await ui.think("The map had a red X on it. Home first. Then the desert.")
			ui.close()


func _glyph(id: String) -> void:
	if Game.has_flag("st_" + id):
		await ui.think("The rings again.")
		ui.close()
		return
	Game.set_flag("st_" + id)
	match id:
		"glyph_station":
			await ui.think("Sprayed inside the ticket kiosk. Lynx had mentioned this one. Someone wanted the commuters to see it every morning.")
		"glyph_factory":
			await ui.think("Across the factory wall, head height, circles inside circles. The paint was fresh.")
		"glyph_far":
			await ui.think("Half-faded on a substation panel. Older than the others. This had been going on a long time.")
	ui.close()
	Game.add_connection(1.0, "looked at " + id)
	await main.filter.flash(0.05)
	Game.log_entry("Eye glyphs all over Southtown: kiosk, factory wall, substation panel.")


func _lynx() -> void:
	var lynx := npc("lynx")
	lynx.face_toward(player.global_position)
	if _met_lynx:
		await ui.say("Lynx", "The encampment under the overpass. East end. That's the big one.", "lynx")
		ui.close()
		return
	await ui.say("Lynx", "Have you heard what happened today? Mark Elonthiel was in Turan's office this morning. Asking questions.", "lynx")
	await ui.think("Son of the founder. Heir apparent. A profoundly useless prick. If he was descending to our level, things were far worse than anyone was admitting.")
	await ui.say("Lynx", "Reports of Psyon glitches are up ten percent this month. He's demanding we identify the origin of the forked version. Immediately. Please tell me Dufredy gave us something.", "lynx")
	await ui.say("Carl", "I think he did. But I'm not sure. I might be losing it. He told me to bring Psyon to an eye. And you said the south side is crawling with them.", "carl")
	await ui.say("Lynx", "If I bring you to one, you have to promise you won't gouge out your eyes.", "lynx")
	var pick := await ui.choose(["I'll try to resist.", "No promises."])
	if pick == 0:
		await ui.say("Carl", "I'll try to resist.", "carl")
		Game.add_trust("lynx", 1)
	else:
		await ui.say("Carl", "No promises.", "carl")
		await ui.say("Lynx", "That's not funny, Carl.", "lynx")
		Game.add_connection(1.0, "joked about it")
	await ui.say("Carl", "How do you even know so much about this? You said you found an old log. Something about a Hipogog?", "carl")
	await ui.say("Lynx", "Hypnogogue. Let's walk and talk.", "lynx")
	await ui.say("Lynx", "I've been looking into this longer than Dufredy. Something's been off since the city was founded. A city this new shouldn't suffer so many systemic tech failures.", "lynx")
	await ui.say("Lynx", "In the old subnet forums, some of the original engineers kept referencing something. Or someone. They called it the Hypnogogue. Said it was interfering with construction. With the very bedrock of the city.", "lynx")
	await ui.say("Lynx", "Last night I dove deeper into the archive. Found a buried thread. Someone posted a video, recorded on early-gen ORA glasses. I'm sending it to you now.", "lynx")
	ui.close()
	psyon.open(false, "  ·  ORA archive  ·  subnet thread  ·  20 years ago")
	await psyon.render_image(load("res://assets/psyon/footage.png"), 2.5)
	await ui.think("A construction site in harsh midday light. Men huddled around a deep pit. The camera swung to a man lying motionless on the dusty ground. Another worker flipped him over.")
	await ui.think("No eyes. Just vacant sockets. His face slack, eerily peaceful. The others shrieking. One looked into the lens, shouting something lost to static. The footage cut.")
	ui.hide()
	psyon.close()
	await ui.say("Carl", "What the hell is going on here? This footage is twenty years old.", "carl")
	await ui.say("Lynx", "We're going to find out. The big one is under the overpass at the east end. Follow me.", "lynx")
	ui.close()
	_met_lynx = true
	Game.add_connection(1.0, "the old footage")
	Game.log_entry("Lynx's archive video: a construction worker with no eyes, twenty years ago. The Hypnogogue predates the city.")
	main.filter.set_hud_text("ORA  ·  Southtown  ·  the overpass, east end")
	await lynx.leave(Vector2(600, 60), 2.5)


func _overpass() -> void:
	if not _met_lynx:
		await ui.think("Lynx was still waiting at the station.")
		ui.close()
		player.position += Vector2(-48, 0)
		return
	Game.input_locked = true
	await ui.think("Beneath the overpass, an encampment. Utterly deserted. Tattered plastic tarps flapped listlessly. Scorched, overturned barrel stoves lay like fallen monoliths.")
	await ui.think("And then I saw it. Painted in stark jet black across the concrete above us, an immense, unblinking eye. Ten feet wide. Unwavering. Watching.")
	await ui.think("I stepped beneath its gaze. A low hum emanated from my bag.")
	ui.close()
	psyon.open(true)
	await beat(0.8)
	await psyon.machine_says("Welcome Home, Dreamer.")
	await beat(0.6)
	await psyon.machine_says("Generating image...", "6f7a84")
	await psyon.render_image(load("res://assets/psyon/map.png"), 5.0)
	await ui.think("A map. A hyper-accurate, to-scale rendering of Silico in razor-sharp monochrome. Buildings, service grids, subterranean tunnel systems, all labelled in an angular script I couldn't read.")
	await ui.think("Except for one stark anomaly. A single, crimson eye. Far beyond the ragged outskirts of the city. Buried deep within the desert.")
	await ui.say("Lynx", "Is that a map? X marks the spot.", "lynx")
	await ui.say("Carl", "Any clue what these symbols are?", "carl")
	await ui.say("Lynx", "Looks like some hallucinatory garbage from the older Psyon model. Guess this version never got the patch.", "lynx")
	ui.hide()
	psyon.accept_input()
	var text: String = await psyon.message_sent
	await beat(0.5)
	await psyon.machine_says(Psyon.respond(text, true))
	await beat(1.0)
	psyon.close()
	await ui.think("The sun was beginning its descent. A powerful longing to be home with my family tugged at the edges of my resolve. I needed more answers. But not tonight.")
	await ui.say("Carl", "Tonight, Monica and the kids will be the antidote. They always were.", "carl")
	ui.close()
	Game.add_connection(3.0, "the map")
	Game.add_evidence("The map")
	Game.log_entry("Under the overpass eye, the fork generated a map of Silico. A red eye marks a spot deep in the desert.")
	Game.set_flag("southtown_done")
	await go_to_street("Home")
