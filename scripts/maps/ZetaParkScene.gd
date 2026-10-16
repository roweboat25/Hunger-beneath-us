extends StreetScene
## Zeta and Park: Lynx's block and the corner the footage was shot on.

func _init() -> void:
	title = "Zeta & Park"
	subtitle = "Lynx's block"
	intro_flag = "warroom1_done"
	ambient = Color(0.84, 0.86, 0.96)


func intro() -> void:
	await ui.think("Zeta and Park. Forner's three seconds of footage had been shot from this corner. Dufredy and the masked figure, walking, and then the stare into the lens with nothing behind it.")
	ui.close()


func intro_early() -> void:
	await ui.think("Zeta and Park. A corner like a hundred others: a camera on a pole, a red building, and a red eye sprayed on the wall beside its door, fresh enough to smell.")
	ui.close()


func on_interact(id: String) -> void:
	match id:
		"camera":
			await ui.think("The one camera on the block that still worked. Not Psyonic's. Someone paid its bill in cash, every month, according to Forner. Nobody knew who.")
			ui.close()
			Game.log_entry("The one working camera at Zeta and Park is paid for in cash by someone unknown.")
		"corner":
			if Game.has_flag("zp_corner"):
				return
			Game.set_flag("zp_corner")
			await ui.think("I stood where he had stood. The camera was above and to the left. He would have had to turn his whole head to look into it.")
			if Game.connection >= 50.0:
				await ui.think("Behind me, on the kerb, someone was standing very still. When I turned, the corner was empty and the frames were recording.")
				Game.add_connection(2.0, "the figure on the corner")
			ui.close()
		"glass_lobby":
			await ui.think("A glass lobby with a Cognizo logo, dark. The rival's outpost on Psyonic's side of town. The receptionist's desk had a stick on it, snapped in two.")
			ui.close()
		"masked":
			var m := npc("masked")
			if not m.visible:
				return
			await ui.think("Black coat. Ceremonial face covering. It did not move, and it did not need to. When I blinked it was a lamp post.")
			ui.close()
			Game.add_connection(3.0, "saw the masked figure")
			Game.log_entry("The masked figure stood on the corner at Zeta and Park. Then it was a lamp post.")
