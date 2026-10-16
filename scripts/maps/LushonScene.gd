extends MapScene
## Lushon Tavern: an upscale speakeasy with an Asian flare, red lanterns on
## every wall. The company had its Independence Day party here once. The
## Psyon drink dispenser still works, for now, and the big round table at
## the back is kept for people who need to talk where nothing listens.


func _init() -> void:
	ambient = Color(0.96, 0.7, 0.6)


func objective_text() -> String:
	return "Lushon's. The door at the bottom when you're done."


func start() -> void:
	var fx := StreetFX.new()
	add_child(fx)
	fx.setup(self, false)
	if not Game.has_flag("visited_Lushon"):
		Game.set_flag("visited_Lushon")
		await main.show_title("Lushon Tavern", "Red Rock Plaza")
		await ui.think("An upscale speakeasy with an Asian flare. Red lanterns lined each wall, and the glow they made filled the space; in another setting it would have been calming.")
		await ui.think("We'd had a corporate Independence Day party here a few years back. It had been full of life. I remembered Dorner dancing, badly, with his wife.")
		ui.close()
	Game.input_locked = false
	main.filter.set_hud_text("ORA  ·  Red Rock  ·  Lushon's")


func on_interact(id: String) -> void:
	match id:
		"counter":
			await _barkeep()
		"barkeep":
			await _barkeep()
		"dispenser":
			await _dispenser()
		"table":
			await ui.think("The big round table at the back, the one you could seat eight at. Nobody at it. A card in the middle said RESERVED and gave no name.")
			if Game.connection >= 50.0:
				await ui.think("Four chairs pulled out. I counted them twice. Somebody had been expecting four people, and I was somebody's fourth.")
			ui.close()
			Game.log_entry("Lushon's keeps the big round table at the back reserved. No name on the card.")
		"lanterns":
			await ui.think("Paper lanterns, real paper, real bulbs. Nothing in them had a network ID. The barkeep said that was the point.")
			ui.close()
		"window":
			await ui.think("The one window, painted over from the inside. Through a scratch in the paint, the plaza: the pillar, the pink of the smoothie stand, a drone going round.")
			ui.close()
		"exit":
			await travel("exit")


func _barkeep() -> void:
	var b := npc("barkeep")
	if b:
		b.face_toward(player.global_position)
	if not Game.has_flag("lu_barkeep"):
		Game.set_flag("lu_barkeep")
		await ui.say("Barkeep", "Psyonic. I remember the party. Independence Day, the whole floor, somebody from your lot stood on this bar and gave a speech about the city's brain.", "")
		await ui.say("Barkeep", "There's no company surveillance in here. No cameras, no pickups, lanterns and bulbs. People pay for that now. They didn't used to.", "")
		await ui.think("He said it like a man quoting his own sign. I believed him anyway. It was the first room in days where the frames had nothing to say.")
		Game.log_entry("Lushon Tavern has no corporate surveillance. People pay for that now, the barkeep says.")
	else:
		await ui.say("Barkeep", "Table at the back's reserved. Everything else is yours.", "")
	ui.close()


func _dispenser() -> void:
	await ui.think("The Psyon-powered drink dispensing unit. Every button clean. It lit up when I looked at it, and the little screen said: FOR YOU.")
	var pick := await ui.choose(["Let it pour.", "Leave it."])
	if pick == 0:
		await ui.think("Something clear, cold, faintly sweet. The screen said SLEEP WELL, CARL. I hadn't touched a button.")
		Game.add_connection(2.0, "drank what it poured")
		if not Game.has_flag("lu_drink"):
			Game.set_flag("lu_drink")
			Game.log_entry("The Psyon dispenser at Lushon's poured for me without being asked and knew my name.")
	ui.close()
