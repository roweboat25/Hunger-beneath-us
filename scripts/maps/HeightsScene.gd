extends StreetScene
## The Heights: Carl's gated suburb. A nightlight in every child's window.

func _init() -> void:
	title = "The Heights"
	subtitle = "A nightlight in every window"
	ambient = Color(0.8, 0.8, 0.95)


func intro() -> void:
	await ui.think("The Heights. Gates, lawns, a school at the end of the street. Every house had a child's window, and every child's window had a nightlight on, and it wasn't dark yet.")
	ui.close()


func _route_interact(id: String) -> void:
	if id == "swarm" and Game.case_open("nathan") and Game.has_flag("case_nathan_substation") and not Game.has_flag("case_nathan_choice"):
		await _swarm()
		return
	await super._route_interact(id)


## Nathan's case: the swarm flies the 02:14 update every night. Scrub it.
func _swarm() -> void:
	if not Game.has_flag("case_nathan_swarm"):
		await ui.think("Six drones in a ring over one house, flying the same update they'd flown the night Nathan died. I had the frames record a full circuit and scrub it back, frame by frame.")
		var frames := [
			"Frame 1: six units, a loose ring, drifting.",
			"Frame 2: the ring tightening. One unit dropping.",
			"Frame 3: two rings now, one inside the other.",
			"Frame 4: the inner ring closing to a point. The outer ring holding.",
			"Frame 5: the point, the ring, and six lines out from it. A shape.",
			"Frame 6: dispersing. Nominal.",
		]
		var pick := await ui.choose(frames)
		if pick != 4:
			await ui.think("Not that frame. The ring opened again. I'd keep going.")
			ui.close()
			return
		await main.filter.flash(0.1)
		await ui.think("There. The pupil, the iris, the lashes. The route in the attachment that wouldn't open was the eye, and twenty-two drones had drawn it over the Flyover with Nathan's car as the pupil.")
		ui.close()
		Game.case_done("nathan", "swarm")
		Game.add_connection(3.0, "the swarm's route")
		Game.log_entry("Scrubbed the Heights swarm frame by frame: the 02:14 route is the eye glyph. Nathan's car was the pupil.")
	await ui.think("I had it on the frames. A year of Logistics saying weather anomaly, and the shape in my pocket. Who hears it?")
	var pick := await ui.choose(["Send it to Lynx.", "File it to Turan as the official story.", "Keep it. She has enough in her head."])
	var outcome := ""
	match pick:
		0:
			outcome = "told"
			await ui.think("I sent her the circuit, no note. The call came back in under a minute.")
			await ui.say("Lynx", "You're sure. Carl. You're sure it's the same update.", "lynx")
			await ui.say("Carl", "Same timestamp. No author. The route is the eye.", "carl")
			await ui.say("Lynx", "They never owned up to it. A year. Weather anomaly. I sat in that ward six days and they sent flowers with the logo on.", "lynx")
			await ui.say("Lynx", "Don't tell Turan you have this. Don't tell anyone. Thank you. I mean it. Thank you.", "lynx")
			await ui.think("Her voice did something at the end I hadn't heard it do. Then she hung up, and the swarm over the house went on drawing its shape.")
			ui.close()
			Game.add_trust("lynx", 2)
			Game.add_connection(1.0, "told Lynx")
			Game.set_flag("told_lynx_nathan")
		1:
			outcome = "filed"
			await ui.say("Turan", "Weather anomaly. That's what Logistics filed and that's what we file. I'll see the fleet copy gets purged; it should have been a year ago.", "turan")
			await ui.say("Turan", "Good work, Carl. Lynx doesn't need this on top of everything. Neither does the stock price.", "turan")
			ui.close()
			Game.add_trust("turan", 2)
			Game.add_pressure(-4)
			Game.set_flag("filed_nathan")
		2:
			outcome = "kept"
			await ui.think("I kept it. She had enough in her head. The swarm finished its shape and started again, and I walked home under it.")
			ui.close()
			Game.add_trust("lynx", 1)
			Game.set_flag("kept_nathan")
	Game.case_done("nathan", "choice")
	Game.resolve_case("nathan", outcome)


func on_interact(id: String) -> void:
	match id:
		"nightlight":
			await ui.think("A nightlight shaped like a moon. The same model as Mira's. Every house on the street had bought the same one, the same month.")
			ui.close()
			Game.log_entry("Every child's window in the Heights has the same moon nightlight, bought the same month.")
			Game.add_connection(1.0, "the nightlights")
		"chalk":
			await ui.think("Chalk on the pavement outside the school. Five circles in a ring, and in the middle, PLEASE CONVENE.")
			ui.close()
		"school":
			await ui.think("Mira's school. Locked for the evening. Through the glass, a corridor of drawings pinned up: a tower, and five figures around it, over and over.")
			ui.close()
			Game.log_entry("The school corridor is papered with drawings of a tower and five figures. Mira's project is the whole class's project.")
		"my_car":
			await fast_travel()
		"jogger":
			var j := npc("jogger")
			j.face_toward(player.global_position)
			await ui.say("Jogger", "Evening, Carl.", "")
			await ui.think("I had never seen him before. He hadn't broken stride.")
			ui.close()
			Game.add_connection(1.0, "the jogger knew my name")
