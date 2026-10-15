extends SceneTree
## Headless smoke test: godot --headless -s tools/smoke.gd
## Loads the map and the main scene, runs a few frames, reports.


func _init() -> void:
	var apt: PackedScene = load("res://scenes/maps/Apartment.tscn")
	var inst := apt.instantiate()
	var ground: TileMapLayer = inst.get_node("Ground")
	var objects: TileMapLayer = inst.get_node("Objects")
	print("ground cells: ", ground.get_used_cells().size())
	print("object cells: ", objects.get_used_cells().size())
	print("cell (3,0) atlas: ", ground.get_cell_atlas_coords(Vector2i(3, 0)))
	print("cell (28,4) atlas (objects): ", objects.get_cell_atlas_coords(Vector2i(28, 4)))
	var n := 0
	for c in inst.get_node("Interactables").get_children():
		n += 1
	print("interactables: ", n)
	inst.free()

	print("SMOKE OK")
	quit()
