extends "res://scripts/Level.gd"
## Dev only: the cast stood in a row in daylight, for checking the people
## (`level=Lineup`, not in any menu).


func build(m: Node) -> void:
	main = m
	spawn = Vector3(0, 0.2, 4.2)
	box(Vector3(30, 0.2, 30), Vector3(0, -0.1, 0), pbr("paving", Vector3(10, 10, 1)), true)
	box(Vector3(30, 8, 0.4), Vector3(0, 4, -3), mat(Color(0.5, 0.48, 0.45)), true)
	var cast := [
		[Color(0.05, 0.07, 0.12), Color(0.6, 0.42, 0.3), {"legs": Color(0.05, 0.06, 0.1)}],
		[Color(0.8, 0.95, 0.2), Color(0.86, 0.68, 0.55), {"hair": Color(0.32, 0.2, 0.12), "long_hair": true, "legs": Color(0.25, 0.25, 0.3), "arms": true}],
		[Color(0.35, 0.4, 0.45), Color(0.9, 0.76, 0.64), {"hair": Color(0.78, 0.74, 0.62), "long_hair": true, "legs": Color(0.2, 0.22, 0.3)}],
		[Color(0.35, 0.28, 0.2), Color(0.55, 0.4, 0.3), {"hair": Color(0.3, 0.3, 0.3), "legs": Color(0.25, 0.22, 0.18)}],
		[Color(0.3, 0.1, 0.12), Color(0.4, 0.28, 0.2), {"visor": true}],
		[Color(0.2, 0.16, 0.12), Color(0.85, 0.66, 0.52), {"visor": true, "long_coat": false}],
		[Color(0.5, 0.4, 0.3), Color(0.92, 0.78, 0.66), {"scale": 0.58}],
	]
	for i in cast.size():
		var c: Array = cast[i]
		var f := figure(c[0], c[1], c[2])
		f.position = Vector3(-3.6 + i * 1.2, 0, 0)
		f.rotation.y = PI
		add_child(f)
	var c1 := Car.build(self, Color(0.55, 0.06, 0.08), {"plate": "SIL 0086"})
	c1.position = Vector3(-6.5, 0, 2.0)
	c1.rotation.y = 0.6
	add_child(c1)
	var c2 := Car.build(self, Color(0.7, 0.72, 0.75), {"hover": true})
	c2.position = Vector3(6.5, 1.2, 2.0)
	c2.rotation.y = -2.4
	add_child(c2)
	var c3 := Car.build(self, Color(0.85, 0.85, 0.82), {"van": true, "plate": "VLT 4410"})
	c3.position = Vector3(0, 0, 9.0)
	c3.rotation.y = 2.2
	add_child(c3)
	var c4 := Car.build(self, Color(0.92, 0.92, 0.94), {"police": true})
	c4.position = Vector3(-2.5, 0, 6.0)
	c4.rotation.y = 2.6
	add_child(c4)
	_dump()


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.6, 0.65, 0.7)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.7, 0.7, 0.72)
	env.ambient_light_energy = 0.6
	env.fog_enabled = false
	env.glow_bloom = 0.0
	sun.light_energy = 1.3
	sun.rotation = Vector3(deg_to_rad(-40), deg_to_rad(160), 0)


func _dump() -> void:
	if OS.get_environment("DUMPTEX") != "":
		var i := 0
		for k in Body._tex:
			var t: Texture2D = (Body._tex[k] as StandardMaterial3D).albedo_texture
			t.get_image().save_png("/tmp/claude-0/-home-user-Hunger-beneath-us/ab3e229a-d842-505a-a027-dd84944f3049/scratchpad/shots/tex_%s.png" % k.left(1) + str(i))
			i += 1
