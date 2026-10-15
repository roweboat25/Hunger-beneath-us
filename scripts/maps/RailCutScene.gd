extends StreetScene
## The Rail Cut: the tracks between Southtown and Cognizo Quarter. The empty
## train passes, and Forner's footage gets scrubbed frame by frame.

func _init() -> void:
	title = "The Rail Cut"
	subtitle = "Cognizo's tracks, Psyonic's side"
	ambient = Color(0.9, 0.82, 0.76)


func intro() -> void:
	await ui.think("The cutting ran between the two halves of the city, Cognizo's rails through Psyonic's ground. Nobody walked it. I walked it.")
	ui.close()


func on_interact(id: String) -> void:
	match id:
		"train":
			await ui.think("The rails hummed, then sang. The train came through at walking pace, lit, and at every window a face with its eyes shut, and on the far platform of nowhere, nobody waiting.")
			ui.close()
			Game.add_connection(2.0, "the train passed")
			Game.log_entry("The empty train passes along the Rail Cut at walking pace. Faces at every window, eyes shut.")
		"tracks":
			await _scrub()
		"sign":
			await ui.think("COGNIZO TRANSIT. KEEP OFF THE TRACKS. Under it, older: PSYONIC INTEGRATIONS. SAFE STREETS FOR SILICO. Under that, two rings.")
			ui.close()
		"watcher":
			if not npc_visible("watcher"):
				return
			await ui.think("A man between the rails, facing the tunnel, humming. He didn't turn. The next train would come through him, and I had the feeling it had before.")
			ui.close()
			Game.add_connection(2.0, "the man on the tracks")


## Forner's footage, frame by frame. Six frames; one of them is the look.
func _scrub() -> void:
	if Game.has_flag("footage_scrubbed"):
		await ui.think("I'd found the frame. I didn't want to see it again.")
		ui.close()
		return
	if not Game.has_flag("warroom1_done"):
		await ui.think("Standing on the tracks, I thought about the footage Forner was pulling. Nothing to scrub yet.")
		ui.close()
		return
	await ui.think("Standing where the camera had looked, I had the frames replay Forner's three seconds, one frame at a time.")
	var frames := [
		"Frame 1: two figures, backs to the camera, walking.",
		"Frame 2: the masked one half-turned. Dufredy still walking.",
		"Frame 3: Dufredy's head turning. The mask facing the lens.",
		"Frame 4: Dufredy full-face, eyes open, into the lens. The mask gone.",
		"Frame 5: motion blur. Both figures gone.",
		"Frame 6: empty street.",
	]
	var pick := await ui.choose(frames)
	if pick == 3:
		await main.filter.flash(0.1)
		await ui.think("There. Dufredy's eyes, open, and a second pair of eyes under the mask's edge, looking the same way. Not one person being led. Two people looking at me.")
		ui.close()
		Game.set_flag("footage_scrubbed")
		Game.add_connection(2.0, "scrubbed the footage")
		Game.add_trust("lynx", 1)
		Game.log_entry("Scrubbed Forner's footage frame by frame: in frame 4 both Dufredy and the masked figure look into the lens. Lynx will want this.")
	else:
		await ui.think("Blur. Not that frame. I'd keep going.")
		ui.close()
