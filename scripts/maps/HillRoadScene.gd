extends StreetScene
## Hill Road: between the Heights and the SalTech gate. The streetlights go
## out ahead of Carl, and something follows at a fixed distance.

var _lights_done := false


func _init() -> void:
	title = "Hill Road"
	subtitle = "Down to SalTech"
	ambient = Color(0.78, 0.8, 0.9)


func intro() -> void:
	await ui.think("Hill Road ran down from the Heights to the hospital through the last trees in the city. Quiet. The kind of quiet that is listening.")
	ui.close()


func on_interact(id: String) -> void:
	match id:
		"nurse":
			var n := npc("nurse")
			n.face_toward(player.global_position)
			if Game.has_flag("warroom1_done"):
				await ui.say("Nurse", "You're the Psyonic one. Going in to see him?", "nurse")
			else:
				await ui.say("Nurse", "You're Psyonic. I can tell by the frames; the company ones hum. Here for a patient, or for the ward?", "nurse")
			await ui.say("Nurse", "Five patients on the ward hum the same tune at night. Same four notes. None of them have met. I asked. I stopped asking.", "nurse")
			await ui.think("She put the cigarette out on the wall and went back in without looking at me.")
			ui.close()
			Game.log_entry("Night nurse: five SalTech patients hum the same four notes. None of them have met.")
		"ambulance":
			await ui.think("An ambulance idling at the gate, lights off, engine running, nobody in the cab and nobody in the back. The dispatch screen said RETURNING.")
			ui.close()
			Game.add_connection(1.0, "the empty ambulance")
		"bench":
			await ui.think("A bench facing the trees. Carved into the slats, two rings. Carved a long time ago, by someone with time.")
			ui.close()
		"lights":
			if _lights_done:
				return
			_lights_done = true
			await _lights_out()
		"follow":
			if Game.has_flag("confront_follower"):
				return
			Game.set_flag("confront_follower")
			await _follower()
		"follower":
			await ui.think("He kept the distance exactly. When I stopped, he stopped. I couldn't get close enough to see his face, and I had the feeling that was the point.")
			ui.close()


func _lights_out() -> void:
	Game.input_locked = true
	for x in [12, 20, 28, 36]:
		show_prop("lamp_on_%d" % x, false)
		show_prop("lamp_off_%d" % x, true)
		await beat(0.35)
	await ui.think("The streetlights went out one by one ahead of me, down the hill. Behind me, one by one, they came back on.")
	ui.close()
	Game.add_connection(1.0, "the lights")
	Game.log_entry("Hill Road's streetlights go out ahead of me and come back on behind.")


func _follower() -> void:
	var man := npc("follower")
	if man:
		man.face_toward(player.global_position)
	var outcome := await confront({
		"intro": "Footsteps behind me, keeping pace. When I stopped, they stopped. A man, twenty paces back, standing in the road with his face toward me.",
		"look_on": "The frames resolved him: healed sockets, a Voltx jacket, lips moving on the four notes. ORA labelled him REGISTERED USER and nothing else.",
		"look_off": "Without the frames he was a shape, and the shape was closer than it had been.",
		"speak_known": "I said the chant back to him, the lines I had. He tilted his head, like a dog hearing its name, and turned and walked up the hill.",
		"speak_unknown": "I told him to stop following me. He took one step closer, and the lights behind him went out.",
		"run": "I ran. Down to the gate, into the light, and didn't look back. The footsteps never sped up.",
		"closer": "He was closer now. I hadn't seen him move.",
		"touched": "A hand on the back of my neck, cold, and four notes in my ear in my own voice. Then the road was empty and the frames were recording.",
	})
	match outcome:
		"seen":
			Game.log_entry("A Voltx man with healed sockets followed me down Hill Road. ORA labelled him a registered user.")
		"spoken":
			Game.log_entry("The follower on Hill Road answered the chant and left. They answer to it.")
		"ran":
			Game.log_entry("Something followed me down Hill Road. I ran.")
		"touched":
			Game.set_flag("touched_on_hill_road")
			Game.log_entry("The follower on Hill Road touched the back of my neck and hummed in my voice. I didn't see him go.")
	if man and outcome != "seen":
		man.set_meta("gone", true)
		man.visible = false
		man.set_deferred("monitorable", false)
