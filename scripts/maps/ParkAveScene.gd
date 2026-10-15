extends StreetScene
## Park Avenue: between Zeta & Park and Cognizo Quarter. At high connection
## the avenue fills with a crowd that isn't there.

func _init() -> void:
	title = "Park Avenue"
	subtitle = "Lit windows, nobody home"
	ambient = Color(0.82, 0.84, 0.95)


func intro() -> void:
	await ui.think("Park Avenue. Every window lit, no one in any of them. The street had the hush of a place where a crowd had just left, or was just about to arrive.")
	ui.close()


func on_interact(id: String) -> void:
	match id:
		"camera2":
			await ui.think("The second camera, Cognizo's. Pointed at the first one, across the avenue. Two companies filming each other while the street filled up with sleepers.")
			ui.close()
		"bench":
			await ui.think("A bench with a view of nothing. Two rings carved into the slat, and under them, a name. Mine.")
			ui.close()
			Game.add_connection(2.0, "my name on the bench")
			Game.log_entry("A bench on Park Avenue has two rings and my name carved under them. Old carving.")
		"crowd":
			if Game.has_flag("confront_crowd"):
				return
			if Game.connection < 50.0:
				await ui.think("An empty avenue. The frames flagged movement at the edges and then withdrew the flag.")
				ui.close()
				return
			Game.set_flag("confront_crowd")
			await _crowd()


func _crowd() -> void:
	var outcome := await confront({
		"intro": "The avenue was full. A crowd, shoulder to shoulder, all facing me, all with their eyes closed, humming the four notes. None of them had been there a second ago.",
		"look_on": "The frames counted them: thirty. Thirty registered users. Thirty passengers. They were not labelled missing.",
		"look_off": "Without the frames they were still there. That was the worst thing I'd learned all week.",
		"speak_known": "I said the chant with them. The humming stopped. Thirty people opened their eyes, looked at me with something like gratitude, and were gone.",
		"speak_unknown": "I told them to go home. The humming changed key, and the front row took a step.",
		"run": "I ran through them. They parted, and they were cold, and when I reached the corner the avenue was empty.",
		"closer": "The front row was closer. I hadn't seen them move. The humming was in my teeth.",
		"touched": "Thirty hands, all at once, cold, on my arms and my face and the back of my neck, and the four notes in my own voice, and then the avenue, empty, and the frames recording.",
	})
	match outcome:
		"seen":
			Game.log_entry("A crowd of thirty on Park Avenue, eyes closed, humming. ORA counted them as registered users. The missing passengers.")
		"spoken":
			Game.log_entry("The crowd on Park Avenue stopped humming when I said the chant with them. They looked grateful. Then they were gone.")
		"ran":
			Game.log_entry("A crowd on Park Avenue that wasn't there. I ran through it. They were cold.")
		"touched":
			Game.set_flag("touched_on_park_ave")
			Game.log_entry("The crowd on Park Avenue touched me, thirty hands, and hummed in my voice.")
	var actors := get_node_or_null("Actors")
	if actors:
		for node in actors.get_children():
			if node is NPC and node.id.begins_with("crowd"):
				node.set_meta("gone", true)
				node.visible = false
				node.set_deferred("monitorable", false)
