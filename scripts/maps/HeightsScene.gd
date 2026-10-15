extends StreetScene
## The Heights: Carl's gated suburb. A nightlight in every child's window.

func _init() -> void:
	title = "The Heights"
	subtitle = "A nightlight in every window"
	ambient = Color(0.8, 0.8, 0.95)


func intro() -> void:
	await ui.think("The Heights. Gates, lawns, a school at the end of the street. Every house had a child's window, and every child's window had a nightlight on, and it wasn't dark yet.")
	ui.close()


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
