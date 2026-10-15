extends MapScene
## Cognizo Station: the platform the empty train arrived at.

var _train_done := false


func _init() -> void:
	ambient = Color(0.7, 0.78, 0.9)


func objective_text() -> String:
	return "The platform. Stairs up at the left when you're done."


func start() -> void:
	if not Game.has_flag("visited_CognizoStation"):
		Game.set_flag("visited_CognizoStation")
		await main.show_title("Cognizo Station", "Where the empty train came in")
		await ui.think("The platform where the car had arrived on time with nobody in it. Tape on the floor where the doors had opened. A guard who didn't want to be here either.")
		ui.close()
	Game.input_locked = false
	main.filter.set_hud_text("ORA  ·  Cognizo Station")


func on_interact(id: String) -> void:
	match id:
		"board":
			await ui.think("Departures. Every train ON TIME, all the way down. The last line, from last night, said ARRIVED and then, in a smaller font the board shouldn't have had, EMPTY.")
			ui.close()
			Game.log_entry("Cognizo Station's board lists last night's train as ARRIVED · EMPTY. The board shouldn't have that word.")
		"tablet":
			await ui.think("A tablet, screen cracked, left on the platform. It still had charge. The chat window on it was open, and the last line was mine, from Dufredy's laptop, word for word.")
			ui.close()
			Game.add_connection(3.0, "the tablet quoted me")
			Game.log_entry("A cracked tablet on the Cognizo platform shows a Psyon chat whose last line is one I typed on Dufredy's laptop.")
		"guard":
			var g := npc("guard")
			g.face_toward(player.global_position)
			await ui.say("Guard", "Psyonic? Then you'll want the same thing the others wanted. The footage. There isn't any. The cameras recorded a platform with nobody on it for forty minutes, and that was true.", "officer")
			await ui.say("Guard", "The train came in. Doors opened. Nothing got off. I was here. I'm still here. Nobody's asked me if I'm all right.", "officer")
			ui.close()
			Game.log_entry("The Cognizo guard was on the platform when the empty train came in. Forty minutes of footage of nobody.")
		"edge":
			if _train_done:
				return
			_train_done = true
			await _train()
		"exit":
			await travel("exit")


func _train() -> void:
	Game.input_locked = true
	await ui.think("Wind out of the tunnel. A train, slowing. Not on the board.")
	await main.filter.flash(0.1)
	await ui.say("", "It came in at walking pace, every window lit, and at every window a face, turned toward me, eyes closed. The doors opened. Nobody got off. The doors closed. It left.")
	await ui.think("The guard hadn't looked up. The frames had recorded eleven seconds of an empty track.")
	ui.close()
	Game.add_connection(4.0, "the train")
	Game.log_entry("A train not on the board came through Cognizo Station with a sleeping face at every window. The frames recorded an empty track.")
