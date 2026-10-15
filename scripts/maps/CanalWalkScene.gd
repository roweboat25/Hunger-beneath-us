extends StreetScene
## Canal Walk: the dry canal between Lamplight and Harmony Green.

var _played := false


func _init() -> void:
	title = "Canal Walk"
	subtitle = "The canal dried the year the desert got in"
	ambient = Color(0.96, 0.9, 0.8)


func intro() -> void:
	await ui.think("The canal had carried water once. Now it carried sand, and the things people drew in it.")
	ui.close()


func on_interact(id: String) -> void:
	match id:
		"radio":
			await ui.think("A parked car, windows up, nobody in it. The radio was on. Four notes, patient, over and over. The lullaby.")
			await ui.think("I tried the door. Locked. The notes kept going, and the frames began to hum along before I noticed.")
			ui.close()
			Game.add_connection(1.0, "the radio")
			Game.log_entry("A locked car on Canal Walk with the lullaby playing on its radio. Nobody inside.")
		"chalk":
			await ui.think("Chalk on the pavement, a child's hand. A circle, another circle inside it, and the words PLEASE CONVENE.")
			ui.close()
		"circles":
			await ui.think("Stick circles in the silt. Two rings each, no pupil. Fresh. Somebody came down here every night to make them.")
			ui.close()
			Game.add_connection(1.0, "the stick circles")
		"silt":
			await ui.think("The silt took my weight like a held breath. Something under it was warm.")
			ui.close()
		"kid1", "kid2":
			await _kids()
		"bank_figure":
			if not npc_visible("bank_figure"):
				return
			await ui.think("On the far bank a man with no eyes bowed to me, slowly, from the waist. He held it. He was still holding it when I looked away.")
			ui.close()
			Game.add_connection(2.0, "the bow")


func _kids() -> void:
	var a := npc("kid1")
	var b := npc("kid2")
	a.face_toward(player.global_position)
	b.face_toward(player.global_position)
	if _played:
		await ui.say("Kid", "You have to say it right or they don't come.", "")
		ui.close()
		return
	_played = true
	await ui.say("Kid", "We're playing the Tower. You can be the fifth one. You just have to say please convene.", "")
	var pick := await ui.choose(["Play along. 'Please convene.'", "Tell them to stop and go home."])
	if pick == 0:
		await ui.say("Kid", "See? Now we're all here.", "")
		await ui.think("For one second there were five children on the walk, not two. Then two again, and the frames recording.")
		ui.close()
		Game.add_connection(3.0, "played the Tower")
		Game.log_entry("Kids on Canal Walk play 'the Tower'. Five avatars, 'please convene'. Mira's game is everywhere.")
	else:
		await ui.say("Kid", "You sound like my dad. He doesn't come anymore either.", "")
		ui.close()
		Game.add_trust("mira", -1)
		Game.log_entry("Kids on Canal Walk play 'the Tower'. I told them to go home. They didn't.")
