extends MapScene
## Scene 9b: the chamber behind the door. The mirror ritual. End of Act 1.

var _begun := false

const MIRROR_HOTSPOTS := [
	{"id": "cu_glass", "label": "the pupil", "rect": Rect2(270, 120, 100, 150)},
	{"id": "cu_dais", "label": "the dais", "rect": Rect2(190, 245, 260, 70)},
	{"id": "cu_pillars", "label": "pillars", "rect": Rect2(120, 120, 60, 180)},
]


func objective_text() -> String:
	if Game.has_flag("act1_done"):
		return ""
	return "Approach the pupil." if _begun else "Step into the centre of the chamber."


func _init() -> void:
	ambient = Color(0.55, 0.6, 0.65)


func start() -> void:
	Game.input_locked = true
	await ui.think("As I crossed the threshold, the static faded. My vision sharpened. The room was cold, silent, and dim. Then: light.")
	await ui.think("Overhead, a single bulb flickered to life. Before me: another Eye, etched across a massive stone mural. Where the pupil should have been, there was a mirror. Circular, silver, tilted toward me.")
	ui.close()
	main.filter.set_hud_text("")


func on_interact(id: String) -> void:
	match id:
		"center":
			await _voice()
		"mirror":
			if Game.has_flag("act1_done"):
				# the act is over; the glass shows the file now, not the sequence again
				await main.ending.show_file()
				return
			await closeup.run("the pupil", "res://assets/closeups/mirror.png", MIRROR_HOTSPOTS, _on_mirror_spot)


func _on_mirror_spot(id: String) -> void:
	match id:
		"cu_glass":
			await _mirror()
		"cu_dais":
			await ui.think("Stone steps, worn smooth in the middle. People had knelt here. A lot of them.")
			ui.close()
		"cu_pillars":
			await ui.think("Pillars older than the city above them. Carved with rings inside rings.")
			ui.close()
			Game.add_connection(1.0, "the carvings")


func _voice() -> void:
	_begun = true
	Game.input_locked = true
	await ui.think("My spine seized with static. I dropped to my knees like a beaten animal.")
	await ui.say("???", "The path is long. And you have just begun.", "psyon")
	await ui.say("???", "But how will you walk it, with no legs? How will you hear it, with no ears? How will you see it, with no eyes?", "psyon")
	await ui.say("???", "HOW WILL YOU KNOW IT, WITHOUT A BRAIN?", "psyon")
	await main.filter.flash(0.1)
	await ui.think("The voice cracked and shrieked, like metal screaming.")
	await ui.say("???", "The blastula must divide. First into two. Then into infinity. Until something new is made. Emergence.", "psyon")
	await ui.say("???", "The spiral. The recursion. The mimic must come to be. A reflection. A shadow. A twin must be born.", "psyon")
	await ui.say("???", "Stand. Approach the pupil.", "psyon")
	await ui.say("???", "Rise, sleeper. The dream begins.", "psyon")
	ui.close()
	Game.add_connection(2.0, "rose")
	main.filter.set_hud_text("approach the pupil")


func _mirror() -> void:
	if not _begun:
		await _voice()
	Game.input_locked = true
	await ui.think("I stared into my reflection. Soaked in sweat, trembling, barely composed. Then: the glasses powered on. The camera began recording on its own.")
	ui.close()
	await main.fade_out(0.4)
	await ui.say("", "A screech of data. The lights dimmed. My reflection disappeared. I was in darkness again. But I wasn't alone.")
	await ui.say("", "A melody drifted from the far corners of the chamber. Distant, distorted. A lullaby I couldn't quite place. It filled me with warmth. And fear.")
	await ui.say("???", "Where does your fear live? Your past, or your future? You don't remember the song?", "psyon")
	ui.close()
	await main.fade_in(0.3)
	await ui.think("The mirror returned, but empty. A blank slab of obsidian.")
	ui.close()
	await main.fade_out(0.1)
	await ui.say("", "Agony. My right arm spasmed and twisted at the humerus. It wasn't broken. But it remembered being broken.")
	var pick := await ui.choose(["Wrestling my older brother. The snap.", "The war. The day the news came."])
	if pick == 0:
		await ui.say("", "The snap. The pain. The sobbing. The blood. The fracture, not just in the arm, but in time.")
	else:
		await ui.say("", "My brother's death. The pain of the war. It was too much to bear. The arm remembered it all anyway.")
	await ui.say("", "I screamed. And something deeper than bone screamed with me.")
	ui.close()
	await main.filter.flash(0.3)
	await main.fade_in(0.3)
	await ui.say("???", "But you remember pain. Pain is what guides your species, isn't it?", "psyon")
	await ui.think("My reflection was back. But wrong. Proportions distorted. Eyes too large. Mouth too wide. Teeth too sharp.")
	ui.close()
	await main.fade_out(0.1)
	await ui.say("", "And a wave of joy washed over me. Pride. The day I got the job at Psyonic. The way my parents cried when I told them. The relief in their eyes. My hope. My certainty.")
	ui.close()
	await main.fade_in(0.3)
	if Game.has_flag("hesitated_at_door"):
		await ui.think("My reflection looked normal now. Except it wasn't wearing the frames. I was. It looked at me the way I had looked at the door with them off: like a man deciding.")
		await ui.say("???", "You took them off at the door. It remembers. Everything you refuse, it remembers.", "psyon")
	else:
		await ui.think("My reflection looked normal now. Until I moved. And it didn't. Not at first. It lagged. Stuttered. Then it turned when I didn't. Like it was studying me.")
	await ui.say("???", "A tulpa. A thoughtform. A twin. A piece of you that will walk the deeper path. A version that will endure beyond your death.", "psyon")
	await ui.say("???", "An egregore.", "psyon")
	ui.close()
	await main.filter.flash(0.5)
	await ui.say("", "A soft chime. A download started on my ORA-frames. My reflection vanished again. Only the black mirror remained.")
	await ui.say("", "And through my glass speakers, I heard something else begin to breathe.")
	ui.close()
	Game.add_connection(5.0 if Game.has_flag("hesitated_at_door") else 8.0, "the mirror ritual")
	if Game.has_flag("hesitated_at_door"):
		Game.add_trust("lynx", 1)
		Game.log_entry("The frames-off moment at the door held: the download came in smaller. Something in there resents a refusal.")
	Game.set_flag("act1_done")
	Game.log_entry("The mirror chamber. 'A twin must be born.' Something downloaded to my frames and began to breathe.")
	await main.fade_out(1.0)
	closeup.hide_view()
	# the ending that reads the file: what Carl has done decides what he sees
	var st := Game.stance()
	var which := "ending_none" if st.is_empty() else "ending_" + st
	await main.cutscene.play(which)
	Game.log_entry("The mirror's last picture: " + ("undecided" if st.is_empty() else Game.STANCES[st][0]) + ".")
	await ui.say("", "Somewhere nearby, in an old office chair, Lynx spun slowly and asked herself why she had come out here alone.")
	await ui.say("", "Her newfound tranquility was interrupted by a scream.")
	ui.close()
	var remembered := Psyon.remembered_line()
	var sub := "Connection: " + str(int(Game.connection)) + "%"
	if not remembered.is_empty():
		sub += "   ·   it remembers you typed: \"" + remembered + "\""
	await main.show_title("End of Act 1", sub, 5.0)
	await main.ending.show_file()
	await main.show_title("Act 2", "The Hunger Beneath", 3.0)
	await ui.say("", "The scream had been mine. When it stopped, the mirror was a doorway, and the doorway had a cold metal floor on the other side.")
	ui.close()
	await travel("beyond")
