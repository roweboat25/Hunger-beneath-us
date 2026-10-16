extends StreetScene
## Red Rock Plaza: the mall of Silico. A gigantic pillar of red stone in a
## park flanked by shops and restaurants; the casino, Lushon Tavern, the
## basement clubs, the smoothie stand, handlers in the alleys. One of the
## few places citizens break out of their corporate personalities. Past
## connection 50 the plaza goes sober, and a man with Carl's face waits in
## the alley, visible only through the frames.

## The people who are gone once Psyon has cleaned the streets.
const SOBER_GONE := ["handler", "partier_a", "partier_b", "fighter_a", "fighter_b", "drunk"]

var _mimic_seen := false


func _init() -> void:
	title = "Red Rock Plaza"
	subtitle = "The mall of Silico"
	ambient_tint = Color(0.98, 0.86, 0.74)
	ambient = ambient_tint


func intro() -> void:
	await ui.think("Red Rock Plaza was aptly named. A gigantic pillar of red stone stood at the centre of a park flanked by shops and restaurants. The mall of Silico: a place for corporate slaves to spend their hard-earned cash on other corporate products.")
	await ui.think("The air was hot and dry, and it made my skin feel like I was in an air fryer. Music came up through the pavement from the basement clubs. Somebody was shouting outside the casino. Somebody in the alley wanted to know if I was holding.")
	if Game.connection >= 50.0:
		await ui.think("Or had wanted to. Tonight the plaza was subdued; not empty, but it didn't bustle with the life and danger it normally provided. The denizens seemed, for lack of a better word, sober.")
	else:
		await ui.think("It was one of the few places in the city where people had fun. I rarely left the tower for anything other than work. Psyonic provided everything.")
	ui.close()
	Game.log_entry("Red Rock Plaza: the mall of Silico, the red pillar, the casino, Lushon Tavern, the basement clubs. People having fun, for now.")


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	var sober := Game.connection >= 50.0
	for id in SOBER_GONE:
		var n := npc(id)
		if n and n.visible == sober:
			n.visible = not sober
			n.set_deferred("monitorable", not sober)
	var m := npc("mimic")
	if m and not m.has_meta("gone"):
		var show := sober and Game.glasses_on
		if m.visible != show:
			m.visible = show
			m.set_deferred("monitorable", show)


## The bouncer's house rule: frames off downstairs. Deep in, he doesn't
## bother; the frames are not the thing he was watching for by then.
func _door(id: String) -> void:
	if id == "door:Arcade" and Game.glasses_on and Game.connection < 50.0:
		await ui.think("Stairs down, and the bass coming up them like weather. A sign on the rail: FRAMES OFF. The bouncer watched me read it, and then watched the frames.")
		var pick := await ui.choose(["Take them off.", "Keep them on."])
		if pick == 0:
			Game.set_glasses(false)
			await ui.think("I took them off. The plaza got quieter and dimmer and smaller, and the stairs were just stairs. He stepped aside.")
			ui.close()
			await travel(id)
		else:
			await ui.say("Bouncer", "Then you're not coming in. Casino's that way. They'll take you with the frames on. They'll take anybody.", "officer")
			ui.close()
			player.position += Vector2(0, 12)
		return
	if id == "door:Arcade" and Game.connection >= 50.0 and Game.glasses_on and not Game.has_flag("arcade_deep_let_in"):
		Game.set_flag("arcade_deep_let_in")
		await ui.think("FRAMES OFF, the sign on the rail said. The bouncer looked at mine and then away, and stepped aside without a word, the way you'd step aside for a hearse.")
		ui.close()
	await super._door(id)


func on_interact(id: String) -> void:
	match id:
		"pillar":
			await ui.think("Sandstone, the whole height of it one piece, quarried from the flats before the city had a name. A plaque at the foot said so. Somebody had sprayed the eye over the plaque.")
			if Game.connection >= 25.0:
				await ui.think("Standing under it I could feel the ground hum. Not the subway. Lower.")
				Game.add_connection(1.0, "the pillar")
			ui.close()
			Game.log_entry("The red pillar on Red Rock Plaza was quarried from the flats before the city was founded. The eye is sprayed over its plaque.")
		"smoothie":
			await _smoothie()
		"club":
			await ui.think("Stairs down, and the bass coming up them like weather. A sign on the rail: FRAMES OFF. The bouncer watched me read it.")
			if Game.connection >= 50.0:
				await ui.think("No music tonight. Nothing came up the stairs at all.")
			ui.close()
		"outlet":
			await ui.think("A Nixtra outlet, shutters down. The ad above it was still running to nobody. SLEEP BETTER. SLEEP TOGETHER.")
			ui.close()
		"alley_w":
			if Game.connection >= 50.0 and Game.glasses_on and not _mimic_seen:
				await _mimic()
			else:
				await ui.think("An alley, a dead end, a smell of hot bins. Someone had been sleeping in it. The frames flagged nothing.")
				ui.close()
		"alley_e":
			await ui.think("The handler's alley. Cash for K, same as every plaza in every city. The frames, for once, didn't have an opinion.")
			ui.close()
		"subway_sign":
			await ui.think("RED ROCK LINE. Trains to Cognizo Quarter and the tower every eleven minutes, the sign said. The sign had the eye scratched into it, small, in the corner.")
			ui.close()
		"mimic":
			await _mimic()
		_:
			await super.on_interact(id)


func _smoothie() -> void:
	await ui.think("A smoothie stand with a Psyon-powered blender. The kid running it had her frames off and a paperback open on the counter.")
	var pick := await ui.choose(["Get a smoothie.", "Leave it."])
	if pick == 0:
		if Game.has_flag("rr_smoothie"):
			await ui.say("Vendor", "Same again? The machine remembered you. It remembers everybody.", "")
		else:
			Game.set_flag("rr_smoothie")
			await ui.say("Vendor", "Blender's picking the flavour tonight, sorry. It keeps overriding me. You get what it thinks you need.", "")
		await ui.think("Thirty minutes early, a cold drink, the pillar going orange in the last of the light. For a minute I was a man in a plaza and nothing else.")
		Game.add_pressure(-2)
		if Game.connection >= 25.0:
			await ui.think("The cup had the eye printed on the lid. It hadn't a minute ago.")
			Game.add_connection(1.0, "the smoothie")
	ui.close()


func _mimic() -> void:
	_mimic_seen = true
	var m := npc("mimic")
	if m:
		m.face_toward(player.global_position)
	await ui.think("A man stood in the mouth of the alley and stared at me, his eyes wide and full of glee.")
	await main.filter.flash(0.08)
	await ui.think("He had my face.")
	var pick := await ui.choose(["Tear the frames off.", "Keep looking."])
	if pick == 0:
		Game.set_glasses(false)
		if m:
			m.visible = false
			m.set_meta("gone", true)
			m.set_deferred("monitorable", false)
		await ui.think("I tore my glasses off, and he was gone. An empty alley, a smell of hot bins. I wished he was real. I wished I could chase him.")
		Game.set_flag("rr_mimic_refused")
	else:
		await ui.think("He raised a hand, slowly, the way you wave at a child, and I felt my own hand want to answer. The frames said: MATCH FOUND.")
		Game.add_connection(4.0, "looked at the mimic")
		Game.set_flag("rr_mimic_watched")
	ui.close()
	Game.log_entry("A man with my face watched me from an alley on Red Rock Plaza. He was only there with the frames on.")
