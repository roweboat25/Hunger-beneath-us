extends StreetScene
## Restricted Road: from Southtown out to the sand flats. A Psyonic
## checkpoint with a sleeping guard, and sand that deepens as Carl goes.

func _init() -> void:
	title = "Restricted Road"
	subtitle = "Psyonic land. Containment, the sign said."
	ambient = Color(1.0, 0.9, 0.74)


func intro() -> void:
	if Game.has_flag("lynx_apartment_done"):
		await ui.think("The road out of Southtown ran dead straight into the flats. Psyonic had marked it restricted years ago. Once, that felt like bureaucracy. Now it felt like containment.")
	else:
		await ui.think("The road out of Southtown ran dead straight into the flats, and stopped being a road for anyone without company plates at the checkpoint. Psyonic had marked it restricted years ago. I had never asked why.")
	ui.close()


func on_interact(id: String) -> void:
	match id:
		"sign":
			await ui.think("PSYONIC INTEGRATIONS. RESTRICTED AREA. CONTAINMENT ZONE 1. The sign was older than the company's current logo. Somebody had known there was something out here to contain before there was a company.")
			ui.close()
			Game.log_entry("The Restricted Road sign reads CONTAINMENT ZONE 1 and predates the company's current logo.")
		"guard":
			var g := npc("guard")
			await ui.think("The guard was asleep in the booth, mouth open, frames on. The frames were recording. Whatever he was dreaming, the company had it.")
			if g:
				g.face("down")
			ui.close()
			Game.add_connection(1.0, "the sleeping guard")
		"gate":
			await _gate()
		"deep_sand":
			await ui.think("Sand over the asphalt, deeper every step. The frames tried to draw the road and gave up. ORA: LOCATION UNAVAILABLE. First time I'd seen it say that.")
			ui.close()
			main.filter.set_hud_text("ORA  ·  location unavailable")
			Game.add_connection(2.0, "off the map")
		"wreck":
			await ui.think("A sedan, company plates, nose down in the sand. Not Lynx's. Older. The logs in the dash had been wiped, and someone had laid two rings of sticks on the roof.")
			ui.close()
			Game.log_entry("An older company sedan wrecked on the Restricted Road, logs wiped, stick rings on the roof. Someone drove out here before Lynx did.")


func _gate() -> void:
	if Game.has_flag("gate_passed"):
		return
	await ui.think("The barrier was up. As I passed under it the dash chimed, and the trip log, the whole log, cleared itself to zero.")
	if Game.has_flag("gate_turned_back"):
		await ui.think("Second time. I kept going.")
		ui.close()
		Game.set_flag("gate_passed")
		return
	var pick := await ui.choose(["Keep driving.", "Turn back, once."])
	if pick == 0:
		await ui.think("I kept driving. The company could have the logs. The company could have the dream.")
		ui.close()
		Game.set_flag("gate_passed")
		Game.add_connection(2.0, "drove through")
	else:
		await ui.think("I turned back, once, and sat at the barrier with the engine running until the chime stopped. Then I went through anyway. There was never a version where I didn't.")
		ui.close()
		Game.set_flag("gate_turned_back")
		Game.set_flag("gate_passed")
		Game.add_trust("monica", 1)
