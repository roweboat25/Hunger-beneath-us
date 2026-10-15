extends MapScene
## The Silico street: the open hub between plot beats. Every building Carl
## visits in Act 1 opens onto it. The next beat is marked in the objective;
## the rest of the street is optional: glyphs, strangers, the camp.

const PLACE_NAMES := {
	"Apartment": "the Lamplight, Dufredy's building", "Park": "Harmony Green", "Home": "home",
	"WarRoom": "Psyonic HQ, the tower", "Hospital": "SalTech hospital", "Southtown": "Southtown, the road south",
	"LynxApartment": "Lynx's building",
}
## Where Carl stands when he steps out of each place (tile coords).
const SPAWN := {
	"Apartment": Vector2i(7, 9), "Home": Vector2i(20, 9), "WarRoom": Vector2i(34, 9), "Hospital": Vector2i(49, 9),
	"LynxApartment": Vector2i(59, 9), "Park": Vector2i(9, 17), "Southtown": Vector2i(56, 22),
}

var _listened := false


func objective_text() -> String:
	return "Go to " + PLACE_NAMES.get(Game.next_beat, Game.next_beat) + "."


func _init() -> void:
	ambient = Color(0.88, 0.84, 0.92)


func start() -> void:
	# spawn outside the door Carl came through (unless a dev --at= moved him)
	if player.position == Vector2(7 * 32 + 16, 9 * 32 + 28):
		var at: Vector2i = SPAWN.get(Game.last_place, Vector2i(7, 9))
		player.position = Vector2(at.x * 32 + 16 + (16 if at.y == 9 else 0), at.y * 32 + 28)
		player.get_node("Camera2D").reset_smoothing()
	if not Game.has_flag("silico_intro"):
		Game.set_flag("silico_intro")
		await main.show_title("Silico", "The city between")
		await ui.think("Silico, from the street. One long boulevard between the places that mattered, and a desert on every side of it pretending to be sky.")
		await ui.think("With the frames on, the walls had started to have opinions.")
		ui.close()
	Game.input_locked = false
	main.filter.set_hud_text("ORA  ·  Silico  ·  " + PLACE_NAMES.get(Game.next_beat, "").get_slice(",", 0))


func on_interact(id: String) -> void:
	if id.begins_with("door:"):
		await _door(id.trim_prefix("door:"))
		return
	match id:
		"preacher":
			await _preacher()
		"officer":
			await _officer()
		"my_car":
			await ui.think("My sedan. Company plates, company logs. Everywhere I drove it, the tower knew.")
			ui.close()
		"vending":
			await ui.think("Psyonic-branded water. Three credits. The screen on the front looped the same ad: a family asleep, smiling, under a logo.")
			ui.close()
		"mailboxes":
			await ui.think("Names scratched off half the boxes. Someone had drawn two rings around DUFREDY in marker, then tried to rub them out.")
			ui.close()
		"tower_sign":
			await ui.think("PSYONIC INTEGRATIONS. The lobby cameras tracked me as I walked by, the way they tracked everyone. The difference was that I used to find that comforting.")
			ui.close()
		"park_fence":
			await ui.think("Harmony Green, behind iron. The last green thing in the city. The gap in the fence was where the tape had been.")
			ui.close()
		"camp":
			await ui.think("A camp on the vacant lot. Clean, like the one in the park. Rules. Whoever lived here had rules, and a fire, and nothing that blinked.")
			ui.close()
			Game.log_entry("Camps on the vacant lots in Silico: clean, ordered, no tech. Same rules as the encampment behind the park.")
		"south_glyph":
			await ui.think("Two rings on the wall where the road turned south. Big, confident, old. Pointing the way like a signpost.")
			ui.close()
			Game.add_connection(1.0, "the signpost glyph")


func _door(place: String) -> void:
	if place == Game.next_beat:
		Game.last_place = place
		await main.change_map("res://scenes/maps/" + place + ".tscn")
		return
	if place == Game.last_place:
		await ui.think("I'd just come from " + PLACE_NAMES.get(place, place).get_slice(",", 0) + ". Nothing left for me there right now.")
	else:
		await ui.think("Not yet. " + objective_text())
	ui.close()
	# step back off the doorway so it can fire again
	player.position += Vector2(0, 12) if SPAWN.get(place, Vector2i(0, 9)).y == 9 else Vector2(0, -12)


func _preacher() -> void:
	var man := npc("preacher")
	man.face_toward(player.global_position)
	if _listened:
		await ui.say("Eyeless man", "Gather, sleeper. Gather.", "")
		ui.close()
		return
	await ui.think("He stood in the middle of the sidewalk with his face turned up to the sun, and where his eyes should have been there was only clean, healed skin.")
	await ui.say("Eyeless man", "Psyon is the pillow for those who dream. Psyon is the path for those who walk.", "")
	var pick := await ui.choose(["Walk on.", "Listen."])
	if pick == 1:
		_listened = true
		await ui.say("Eyeless man", "Close the eyes that lie, and see. The floor is a door. The door is a floor.", "")
		await ui.think("He said it like a lullaby. I stood there longer than I meant to. The frames had started recording before I told them to.")
		ui.close()
		Game.add_connection(2.0, "listened to the preacher")
		Game.log_entry("An eyeless man preaching the chant on the boulevard. Healed sockets. He wasn't the first, and he wasn't afraid.")
	else:
		await ui.think("I walked on. Behind me the chant kept the same even pace, like it hadn't needed me at all.")
		ui.close()


func _officer() -> void:
	var cop := npc("officer")
	cop.face_toward(player.global_position)
	if Game.has_flag("hospital_done"):
		await ui.say("Officer", "Every camera on this block went down for forty minutes the night your guy ran. Psyonic cameras. You want to tell me that's a coincidence, Drake?", "officer")
		await ui.think("I didn't. He already knew what I'd say.")
		ui.close()
		Game.add_pressure(5)
		return
	await ui.say("Officer", "Media's camped outside the tower. Third one this month. If Psyonic wants my opinion, something in those glasses is cooking people.", "officer")
	await ui.think("Nobody at Psyonic wanted his opinion. That was starting to feel like the problem.")
	ui.close()
