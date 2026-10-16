extends StreetScene
## The Flyover: the elevated road between the Spine and the Heights.
## Twenty years of Psyonic billboards, oldest at the top of the ramp.

var _boards := 0


func _init() -> void:
	title = "The Flyover"
	subtitle = "Twenty years of Psyonic, oldest at the top"
	ambient = Color(0.82, 0.8, 0.9)


func intro() -> void:
	await ui.think("The flyover carried the commute over the old town. Along the rail, the company's billboards went back in time as the ramp climbed: the frames as safety, the frames as family, the frames as sleep.")
	ui.close()


func on_interact(id: String) -> void:
	match id:
		"billboard":
			_boards += 1
			var lines := [
				"SLEEP BETTER WITH ORA. A family in a bed, smiling, eyes closed. This one was new.",
				"ORA SEES WHAT YOU MISS. A mother, a child, a crosswalk. Safety. Five years old.",
				"PSYON, FOR THOSE WHO DREAM. The old slogan. Someone at the company had written it before the chant ever reached the street. Or after.",
				"INTEGRATIONS. The first logo, before the eye. Just a word, the year the company bought the water.",
				"Paint over paint. Whatever this one had said, two rings had been sprayed across it and painted out, and sprayed again.",
				"The oldest board, bare. The frame around it was the shape of an eye, and always had been.",
			]
			await ui.think(lines[min(_boards - 1, lines.size() - 1)])
			if Game.connection >= 25.0 and _boards >= 2 and not Game.has_flag("billboard_glitch"):
				Game.set_flag("billboard_glitch")
				await main.filter.flash(0.06)
				await ui.think("For one frame every board on the ramp was the eye. Then they were ads again. The frames had the frame; I checked.")
				Game.add_connection(2.0, "the billboards blinked")
				Game.log_entry("Every billboard on the Flyover showed the eye for one frame. ORA recorded it.")
			ui.close()
		"stalled":
			await ui.think("A car stalled in the middle lane, hazards off, doors locked. On every seat, snapped sticks laid in a row, like someone had been counting.")
			var pick := await ui.choose(["Report it.", "Leave it."])
			if pick == 0:
				await ui.say("ORA", "Reported. Psyonic Roadside has the location.", "ora")
				ui.close()
				Game.add_pressure(2)
				Game.log_entry("Stalled car on the Flyover with sticks laid on every seat. Reported to Psyonic Roadside.")
			else:
				await ui.think("I left it. Whoever had counted the sticks would be back for them.")
				ui.close()
				Game.add_connection(1.0, "left the sticks")
		"jogger":
			var j := npc("jogger")
			j.face_toward(player.global_position)
			await ui.say("Jogger", "Carl. Carl Drake. You dropped something.", "")
			await ui.think("I hadn't. He pointed back down the ramp, at nothing, and jogged on with his eyes shut.")
			ui.close()
			Game.add_connection(1.0, "the jogger")
		"ramp_top":
			await ui.think("At the top of the ramp the Heights opened out, lawns and gates and the school. Home. The frames took a second longer than usual to label it.")
			ui.close()
