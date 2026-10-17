extends "res://scripts/Level.gd"
## Dev only: every prop in assets/kit/ stood in a night alley under game
## lighting, for reviewing the asset pipeline (`level=PropKit`, not in any menu).
## Props are CC0 Poly Haven scans and AI-generated meshes cut to PS1 budgets by
## tools/asset_pipeline/ (see its README); sources in assets/kit/LICENSE.txt.

const KIT_DIR := "res://assets/kit/"
const ROW := 7  # props per row


func build(m: Node) -> void:
	main = m
	spawn = Vector3(0, 0.2, 7.5)
	box(Vector3(40, 0.2, 30), Vector3(0, -0.1, 0), pbr("asphalt", Vector3(12, 12, 1)), true)
	box(Vector3(40, 9, 0.4), Vector3(0, 4.5, -6.5), pbr("concrete", Vector3(8, 3, 1)), true)
	var names := []
	var dir := DirAccess.open(KIT_DIR)
	if dir:
		for f in dir.get_files():
			var b := f.trim_suffix(".import").trim_suffix(".remap")
			if b.ends_with(".glb") and not names.has(b.get_basename()):
				names.append(b.get_basename())
	names.sort()
	for i in names.size():
		var scene: PackedScene = load(KIT_DIR + names[i] + ".glb")
		if scene == null:
			continue
		var n := scene.instantiate()
		var row := i / ROW
		var col := i % ROW
		n.position = Vector3(-6.0 + col * 2.0, 0, 2.0 - row * 1.8)
		n.rotation.y = 0.5
		add_child(n)
		if OS.get_environment("KITDUMP") != "":
			var bb := AABB()
			for mi in n.find_children("*", "MeshInstance3D", true, false):
				bb = bb.merge((mi as MeshInstance3D).get_aabb())
			print("KIT ", names[i], " ", bb.size)
	for p in [[Vector3(-5, 3, 1), Color(1.0, 0.2, 0.7)], [Vector3(5, 3, 1), Color(0.2, 0.9, 1.0)], [Vector3(0, 4, 4), Color(0.9, 0.85, 0.8)]]:
		var l := OmniLight3D.new()
		l.position = p[0]
		l.light_color = p[1]
		l.light_energy = 2.2
		l.omni_range = 12.0
		add_child(l)
	print("PROPKIT ", names.size(), " props")


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.03, 0.02, 0.06)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.35, 0.3, 0.45)
	env.ambient_light_energy = 0.5
	env.fog_enabled = false
	sun.light_energy = 0.25
	sun.rotation = Vector3(deg_to_rad(-50), deg_to_rad(150), 0)
