extends MapScene
## The factory floor in Southtown: a locked floor, a keycard in the office,
## and twenty years of shifts with the eye on the floor.

var _eye_sprite: Sprite2D


func _init() -> void:
	ambient = Color(0.78, 0.72, 0.68)


func objective_text() -> String:
	if Game.has_flag("factory_floor_seen"):
		return "Leave. The door, bottom left."
	if Game.has_flag("factory_unlocked"):
		return "The locked floor is open. West."
	if Game.has_flag("factory_keycard"):
		return "Use the keycard on the locked door, west side."
	return "Find a way onto the locked floor. Try the office, east."


func start() -> void:
	_eye_sprite = Sprite2D.new()
	_eye_sprite.texture = load("res://assets/ui/eye_glyph.png")
	_eye_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_eye_sprite.scale = Vector2(4, 4)
	_eye_sprite.modulate = Color(0.5, 0.08, 0.06, 0.85)
	_eye_sprite.position = Vector2(5 * 32 + 16, 9 * 32 + 16)
	_eye_sprite.z_index = 1
	add_child(_eye_sprite)
	if not Game.has_flag("visited_Factory"):
		Game.set_flag("visited_Factory")
		await main.show_title("The Factory", "Southtown's industrial core")
		await ui.think("The factory still ran one shift. Nobody on it had looked up when I came in. The floor to the west was behind a door with a card reader, and the card reader was the newest thing in the building.")
		ui.close()
	Game.input_locked = false
	main.filter.set_hud_text("ORA  ·  the factory")


func on_interact(id: String) -> void:
	match id:
		"machines":
			await ui.think("Presses, stamping something small out of sheet metal. I picked one up. A frame. The shape of the frames, before the glass went in.")
			ui.close()
			Game.log_entry("The Southtown factory stamps the blanks for ORA frames. Psyonic's own supply chain, on the wrong side of town.")
		"keycard":
			if Game.has_flag("factory_keycard"):
				await ui.think("I had the card.")
				ui.close()
				return
			await ui.think("A keycard on the desk under a coffee ring. FLOOR 2, and a name, scratched out, and under the scratch, two rings.")
			ui.close()
			Game.set_flag("factory_keycard")
			Game.add_evidence("Factory keycard")
		"office_laptop":
			await ui.think("The office laptop, locked. The screensaver was a family asleep, smiling, under the logo. The same ad as the vending machines.")
			ui.close()
		"locked_door":
			if Game.has_flag("factory_unlocked"):
				return
			if Game.has_flag("factory_keycard"):
				await ui.think("The card reader took the card and thought about it. Then it opened, the way a mouth opens.")
				ui.close()
				remove_prop("locked_door")
				Game.set_flag("factory_unlocked")
				return
			await ui.think("Locked. A card reader, new, with a green light that watched me walk away.")
			ui.close()
		"ledger":
			await ui.think("A shift ledger, twenty years of it. Every name on every page had two rings drawn beside it in the same hand, and the hand never changed in twenty years.")
			ui.close()
			Game.log_entry("Twenty years of factory shift ledgers, every worker's name marked with two rings in the same hand.")
			Game.add_connection(2.0, "the ledger")
		"floor_eye":
			if Game.has_flag("factory_floor_seen"):
				return
			Game.set_flag("factory_floor_seen")
			await main.filter.flash(0.12)
			await ui.think("The locked floor. Painted on the concrete, ten feet across, the eye. Two rings. No pupil. Around it, in a ring, forty pairs of frames, laid out like shoes outside a door.")
			await ui.say("Carl", "This is where they go. Before the train. Before the park. They come here first.", "carl")
			ui.close()
			Game.add_connection(4.0, "the factory floor")
			Game.log_entry("The factory's locked floor: a ten-foot eye on the concrete and forty pairs of frames laid around it. They come here first.")
		"exit":
			await travel("exit")
