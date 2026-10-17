extends "res://scripts/Level.gd"
## Epilogue: stub, being built.


func build(m: Node) -> void:
	main = m
	kit_day = false
	spawn = Vector3(0, 0.2, 4.0)
	card = "Epilogue\n[color=#888888]not built yet[/color]"
	box(Vector3(30, 0.2, 30), Vector3(0, -0.1, 0), mat(Color(0.2, 0.2, 0.22)), true)
	interactable("exit", "Leave", Vector3(0, 1.0, -6.0), Vector3(1.5, 2.2, 0.3)).set_meta("exit", true)


func interact(node: Object) -> bool:
	if str(node.get_meta("id")) == "exit":
		main.ui.show_end("[center]\n\n\n[b]Epilogue[/b]\n\nNot built yet.\n\n[color=#777777]M for the menu[/color][/center]")
		return true
	return false


func selftest() -> void:
	await main.selftest_all_interactables()
