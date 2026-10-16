extends StreetScene
## Cognizo Quarter: the rival's glass district, and the subway.

func _init() -> void:
	title = "Cognizo Quarter"
	subtitle = "The other company's side of town"
	ambient = Color(0.8, 0.88, 0.98)


func intro() -> void:
	await ui.think("Cognizo Quarter. Glass where Psyonic used brick, and windows lit at every hour so the street could see in. They built the trains. We built the frames. The city had picked sides by postcode.")
	ui.close()


func on_interact(id: String) -> void:
	match id:
		"lobby":
			await ui.think("A Cognizo lobby, all glass. The receptionist watched me the way the tower's cameras did, and for the same reason.")
			ui.close()
		"vending":
			await ui.think("Cognizo water. Two credits. The screen on the front showed a train arriving on time, over and over, with nobody on it.")
			ui.close()
		"drain":
			await ui.think("Warm air out of the drain, and under the traffic, four notes. The same four as the Underpass. The same four as everywhere.")
			ui.close()
			Game.add_connection(1.0, "the drain")
		"suit":
			var s1 := npc("suit")
			s1.face_toward(player.global_position)
			await ui.say("Cognizo man", "Psyonic frames. You're brave, wearing those on this side of the avenue.", "")
			await ui.say("Cognizo man", "Your people say our train did it. Our people say your glasses did. Thirty passengers say nothing, because nobody can find them.", "")
			ui.close()
			Game.log_entry("Cognizo blames the frames; Psyonic blames the train. Thirty passengers from the empty car are still missing.")
			Game.add_pressure(3)
		"suit2":
			var s2 := npc("suit2")
			s2.face_toward(player.global_position)
			await ui.say("Cognizo woman", "You look like you haven't slept. Everybody on this street looks like that lately. Try the subway. It's quiet now.", "")
			ui.close()
