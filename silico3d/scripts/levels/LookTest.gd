extends "res://scripts/levels/Spine.gd"
## Dev only (`level=LookTest`, not in any menu): the Spine at night with two
## people stopped on the pavement in front of Carl, for comparing the PS1 look
## with the cinematic prototype (`look=cine`) on the same frame.
## `talk=1` sets Monica talking; `dlg=1` adds the dialogue letterbox and a
## close focus (with look=cine).

var monica: Node3D
var guard: Node3D


func build(m: Node) -> void:
	super.build(m)
	# Monica: auburn hair, a grey-green coat; a company security guard in navy
	monica = figure(Color(0.3, 0.36, 0.33), Color(0.86, 0.7, 0.6),
		{"hair": Color(0.36, 0.14, 0.08), "long_hair": true, "legs": Color(0.12, 0.12, 0.14), "long_coat": true})
	monica.position = Vector3(4.2, 0.2, 101.9)
	monica.rotation.y = PI - 0.25
	add_child(monica)
	guard = figure(Color(0.05, 0.07, 0.12), Color(0.5, 0.36, 0.26), {"hair": Color(0.05, 0.04, 0.04), "legs": Color(0.05, 0.06, 0.1)})
	guard.position = Vector3(6.55, 0.2, 101.4)
	guard.rotation.y = PI + 0.35
	add_child(guard)
	# a shop window's light falling on them, the same in both looks
	var key := OmniLight3D.new()
	key.light_color = Color(1.0, 0.72, 0.85)
	key.light_energy = 0.7
	key.omni_range = 6.0
	key.shadow_enabled = true
	key.position = Vector3(2.6, 2.8, 104.2)
	add_child(key)
	var rim := OmniLight3D.new()
	rim.light_color = Color(0.3, 0.9, 1.0)
	rim.light_energy = 0.9
	rim.omni_range = 5.0
	rim.position = Vector3(7.8, 2.2, 99.6)
	add_child(rim)


func apply_args(a: Dictionary) -> void:
	super.apply_args(a)
	if a.has("norain"):
		main._rain.visible = false
		main._rain.emitting = false
	if a.has("talk") and monica.has_meta("face"):
		(monica.get_meta("face") as Face).talking = true
		(monica.get_meta("face") as Face).hold_open = float(a["talk"]) if float(a["talk"]) < 1.0 else 0.0
	if a.has("dlg") and main.cine:
		# the conversation camera: letterbox and a push in to head and shoulders
		main.cine.set_letterbox(true)
		main.player.cam.fov = 30.0
		main.cine.focus(main.player.cam, main.player.cam.global_position.distance_to(monica.global_position + Vector3(0, 1.7, 0)))
