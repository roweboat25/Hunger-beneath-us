extends StreetScene
## The Underpass: between the Spine and Southtown. Sleepers, chant graffiti
## in layers, and the first chant puzzle.

func _init() -> void:
	title = "The Underpass"
	subtitle = "Twenty years of paint"
	ambient = Color(0.72, 0.74, 0.86)


func intro() -> void:
	await ui.think("The underpass smelled of cold concrete and old fires. Along the north wall people were sleeping sitting up, all of them facing the same way.")
	ui.close()


func on_interact(id: String) -> void:
	match id:
		"sleepers", "sleeper1", "sleeper2", "sleeper3":
			await ui.think("Three sleepers against the wall, chins up, facing east. Healed sockets. They breathed in time with each other.")
			ui.close()
			Game.add_connection(1.0, "the sleepers")
			Game.log_entry("Three eyeless sleepers in the Underpass, breathing in time, all facing east.")
		"drain":
			await ui.think("A storm drain. Warm air came up out of it, and under the traffic, something like a chant.")
			ui.close()
		"old_layers":
			await ui.think("Layers of paint. The newest rings on top; underneath, older rings; under those, rings in a hand that had been dead for twenty years. The same two circles all the way down.")
			ui.close()
			Game.log_entry("Chant graffiti in the Underpass goes back twenty years. The same two rings, all the way down.")
		"chant_wall":
			await _chant_wall()


## The chant puzzle: given two decoded lines, pick the one that follows.
func _chant_wall() -> void:
	if Game.has_flag("chant_wall_done"):
		await ui.think("The wall had given me what it had.")
		ui.close()
		return
	if Game.glyphs_found.size() < 3:
		await ui.think("A wall of chant, most of it faded. With more glyphs decoded, the frames might be able to fill the gaps. %d of 3 so far." % Game.glyphs_found.size())
		ui.close()
		return
	await ui.think("The frames laid what I'd decoded over the wall. Two lines matched. The third was faded to nothing.")
	await ui.say("", "\"" + Game.CHANT[0] + "\"\n\"" + Game.CHANT[1] + "\"\n\"...\"")
	var right: String = Game.CHANT[2]
	var options := [right, "The walls will keep what the sleepers forget.", "Open the eyes that see, and sleep."]
	options.shuffle()
	var pick := await ui.choose(options)
	if options[pick] == right:
		await main.filter.flash(0.1)
		await ui.think("The paint under the paint lit up for a second, and the third line read itself to me.")
		ui.close()
		Game.set_flag("chant_wall_done")
		Game.add_connection(3.0, "read the wall")
		Game.log_entry("The Underpass wall: the chant's third line is '" + right + "' It has been here twenty years.")
	else:
		await ui.think("Nothing. The wall didn't answer to that. I'd try again when I had it right.")
		ui.close()
