extends MapScene
## The casino on Red Rock Plaza: a small place that catered to drunks on
## the way to the subway. Every machine pays out the same three symbols,
## and the chant is on the walls in paint that is still wet.


func _init() -> void:
	ambient = Color(0.82, 0.62, 0.62)


func objective_text() -> String:
	return "The casino. Door at the bottom when you're done."


func start() -> void:
	var fx := StreetFX.new()
	add_child(fx)
	fx.setup(self, false)
	if not Game.has_flag("visited_Casino"):
		Game.set_flag("visited_Casino")
		await main.show_title("The casino", "Red Rock Plaza, by the subway stairs")
		await ui.think("A small casino that catered to drunk passers-by on their way to the subway. Half the machines were lit. The other half had been switched off at the wall, which in this city meant somebody had wanted them quiet.")
		if Game.connection >= 50.0:
			await ui.think("All of the machines were empty. At first I thought the place was out of order, and then I saw the eye, sprayed over the inside of the shop, everywhere, and the words on the far wall.")
		ui.close()
	Game.input_locked = false
	main.filter.set_hud_text("ORA  ·  Red Rock  ·  the casino")


func on_interact(id: String) -> void:
	match id:
		"machines":
			await _machines()
		"dark_machines":
			await ui.think("Switched off. Someone had pulled the plugs and coiled the cables neatly on top. On the glass of each one, in marker: the eye, and under it a number. 0. 1. 2. 4.")
			ui.close()
			Game.log_entry("Four slot machines in the Red Rock casino are unplugged and marked 0, 1, 2, 4 under the eye.")
		"cage":
			await ui.think("The cashier's cage, empty, the credit counter at zero. A sign taped to the bars: PAYOUTS SUSPENDED BY ORDER OF THE HOUSE. The house hadn't signed it. Somebody had drawn an eye where the signature went.")
			ui.close()
		"words_god", "words_sea":
			await _words(id)
		"exit":
			await travel("exit")


func _machines() -> void:
	await ui.think("A slot machine, lit, the reels still. I put a hand on the arm without meaning to.")
	var pick := await ui.choose(["Pull it.", "Leave it."])
	if pick == 1:
		ui.close()
		return
	await main.filter.flash(0.05)
	if Game.glasses_on:
		await ui.think("Three eyes. The machine chimed like I'd won and paid out nothing. Down the row, every lit machine spun on its own and stopped on the same three eyes, one after another, toward the door.")
		Game.add_connection(2.0, "pulled the arm")
		if Game.connection >= 25.0:
			var pick2 := await ui.choose(["Interface with it.", "Step back."])
			if pick2 == 0:
				ui.close()
				await interface("casino_slots", "the slot machines")
				return
	else:
		await ui.think("Cherries, a bar, a seven. Nothing. Without the frames it was a slot machine in a bad casino, and I was a man losing a credit in it.")
	ui.close()
	Game.log_entry("The lit machines in the Red Rock casino all stop on three eyes, in sequence, with the frames on.")


func _words(id: String) -> void:
	var line := ""
	match id:
		"words_god":
			line = "On the wall above the slot machines, in red: THE GOD WHO ANSWERS. THE GOD WITHIN THE WAVES. The paint that made them was still wet."
		"words_sea":
			line = "SIN DISTRACTS WITHIN AN EYELESS SEA. A drip had run from the last letter all the way to the floor."
	await ui.think(line)
	if not Game.has_flag("ca_" + id):
		Game.set_flag("ca_" + id)
		await ui.think("Psyon was once the city's brain. Now, like a tumour, it sought to spread anywhere that would take it. Not only estranged employees and lone vagrants: it wanted drunks and ketamine addicts. It wanted to clean the streets.")
		Game.add_connection(1.0, "read the wall")
		Game.log_entry("The chant is painted on the casino walls on Red Rock Plaza, the paint still wet: THE GOD WHO ANSWERS. SIN DISTRACTS WITHIN AN EYELESS SEA.")
	ui.close()
