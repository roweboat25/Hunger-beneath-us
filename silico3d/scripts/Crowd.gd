extends Node3D
## The people on the Spine. Everyone wears frames, so every face has a thin
## lit visor. Past 25 connection, after the first outage, the crowd starts
## to watch Carl: whoever he is not looking at stops and turns to face him.
## Look back at them and, after a moment, they walk on as if nothing happened.

var main: Node
var city: Node
var peds: Array = []
var statics := {}
var _visor_cyan: StandardMaterial3D
var _visor_red: StandardMaterial3D
var rng := RandomNumberGenerator.new()

const COATS := [Color(0.12, 0.12, 0.14), Color(0.2, 0.16, 0.12), Color(0.1, 0.14, 0.18),
	Color(0.25, 0.25, 0.27), Color(0.3, 0.1, 0.12), Color(0.08, 0.08, 0.08)]
const SKINS := [Color(0.85, 0.66, 0.52), Color(0.6, 0.42, 0.3), Color(0.4, 0.28, 0.2),
	Color(0.92, 0.78, 0.66), Color(0.7, 0.52, 0.38)]


func setup(m: Node) -> void:
	main = m
	city = m.city
	rng.seed = 77
	_visor_cyan = city.glow(Color(0.3, 0.95, 1.0), 3.0)
	_visor_red = city.glow(Color(1.0, 0.08, 0.05), 9.0)
	var lanes := [-15.0, -11.6, 11.6, 15.0]
	for i in 28:
		var x: float = lanes[i % lanes.size()] + rng.randf_range(-0.3, 0.3)
		var z := rng.randf_range(-160.0, 120.0)
		if x < 0.0 and z < -5.0 and z > -55.0 and x < -14.0:
			z += 60.0
		var n := figure(COATS[rng.randi() % COATS.size()], SKINS[rng.randi() % SKINS.size()], true)
		n.position = Vector3(x, 0.12, z)
		add_child(n)
		peds.append({"node": n, "dir": -1.0 if rng.randf() < 0.5 else 1.0,
			"speed": rng.randf_range(0.9, 1.5), "state": "walk", "look_t": 0.0,
			"phase": rng.randf() * TAU, "min_z": -165.0, "max_z": 124.0})
	_statics()


## A low-poly person facing -Z. Kept deliberately plain: a placeholder for a real model.
func figure(coat: Color, skin: Color, visor: bool, separate_arms := false) -> Node3D:
	var root := Node3D.new()
	var coat_m: StandardMaterial3D = city.mat(coat, 0.7)
	var skin_m: StandardMaterial3D = city.mat(skin, 0.6)
	var legs := []
	for side: float in [-1.0, 1.0]:
		var hip := Node3D.new()
		hip.position = Vector3(side * 0.1, 0.86, 0)
		root.add_child(hip)
		city.box(Vector3(0.14, 0.86, 0.16), Vector3(0, -0.43, 0), city.mat(Color(0.06, 0.06, 0.07)), false, hip)
		legs.append(hip)
	# coat, torso and (for walkers) arms as one mesh: fewer draw calls
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var skirt := CylinderMesh.new()
	skirt.top_radius = 0.22
	skirt.bottom_radius = 0.3
	skirt.height = 0.55
	skirt.radial_segments = 10
	skirt.rings = 1
	st.append_from(skirt, 0, Transform3D(Basis(), Vector3(0, 0.95, 0)))
	var cm := CapsuleMesh.new()
	cm.radius = 0.21
	cm.height = 0.75
	cm.radial_segments = 10
	cm.rings = 4
	st.append_from(cm, 0, Transform3D(Basis(), Vector3(0, 1.3, 0)))
	var am := CapsuleMesh.new()
	am.radius = 0.065
	am.height = 0.7
	am.radial_segments = 6
	am.rings = 2
	var arms := []
	for side: float in [-1.0, 1.0]:
		if separate_arms:
			var sh := Node3D.new()
			sh.position = Vector3(side * 0.26, 1.55, 0)
			root.add_child(sh)
			city.mesh(am, Vector3(0, -0.33, 0), coat_m, sh)
			arms.append(sh)
		else:
			st.append_from(am, 0, Transform3D(Basis(), Vector3(side * 0.26, 1.22, 0)))
	var body := MeshInstance3D.new()
	body.mesh = st.commit()
	body.material_override = coat_m
	root.add_child(body)
	var head := Node3D.new()
	head.position = Vector3(0, 1.72, 0)
	root.add_child(head)
	var hm := SphereMesh.new()
	hm.radius = 0.12
	hm.height = 0.27
	hm.radial_segments = 12
	hm.rings = 6
	city.mesh(hm, Vector3.ZERO, skin_m, head)
	var hair := SphereMesh.new()
	hair.radius = 0.125
	hair.height = 0.16
	hair.radial_segments = 12
	hair.rings = 4
	city.mesh(hair, Vector3(0, 0.07, 0.02), city.mat(Color(0.05, 0.04, 0.04), 0.9), head)
	var v: MeshInstance3D = null
	if visor:
		v = city.box(Vector3(0.21, 0.045, 0.03), Vector3(0, 0.02, -0.11), _visor_cyan, false, head)
	root.set_meta("legs", legs)
	root.set_meta("arms", arms)
	root.set_meta("head", head)
	root.set_meta("visor", v)
	return root


func _statics() -> void:
	# The eyeless man, face up to the sky, arms open. Book ch. 1 and the 2D Spine.
	var pr := figure(Color(0.75, 0.72, 0.66), Color(0.8, 0.62, 0.5), false, true)
	pr.position = Vector3(-13.4, 0.12, 14.0)
	pr.rotation.y = -PI / 2.0
	add_child(pr)
	(pr.get_meta("head") as Node3D).rotation.x = 0.7
	for a in pr.get_meta("arms"):
		(a as Node3D).rotation.z = 2.1 if (a as Node3D).position.x > 0.0 else -2.1
	# two dark hollows where the eyes had been: healed skin, shadowed
	var hollow: StandardMaterial3D = city.mat(Color(0.35, 0.22, 0.2), 1.0)
	for s: float in [-1.0, 1.0]:
		city.box(Vector3(0.05, 0.025, 0.02), Vector3(s * 0.045, 0.02, -0.112), hollow, false, pr.get_meta("head"))
	city.interactable("preacher", "Talk to the eyeless man", Vector3(0, 0.9, 0), Vector3(0.8, 1.9, 0.8), "", true, pr)
	statics["preacher"] = pr
	# the press scrum, waiting for a statement
	var p1 := figure(Color(0.2, 0.2, 0.25), SKINS[0], true)
	p1.position = Vector3(14.0, 0.12, -28.0)
	add_child(p1)
	city.interactable("press_1", "Talk to the reporter", Vector3(0, 0.9, 0), Vector3(0.7, 1.9, 0.7),
		"PRESS - CHANNEL 4\nPsyon 4.1 - sync 94%\nstory: EYELESS MAN BLAMES PRODUCT", true, p1)
	var p2 := figure(Color(0.3, 0.25, 0.2), SKINS[2], true)
	p2.position = Vector3(13.2, 0.12, -29.4)
	add_child(p2)
	city.interactable("press_2", "Talk to the reporter", Vector3(0, 0.9, 0), Vector3(0.7, 1.9, 0.7),
		"PRESS - THE SILICO LEDGER\nPsyon 3.9 - sync 70%\nrecorder: NOT RECORDING", true, p2)
	statics["press_1"] = p1
	statics["press_2"] = p2
	var cop := figure(Color(0.05, 0.07, 0.12), SKINS[1], false)
	cop.position = Vector3(14.2, 0.12, -40.0)
	cop.rotation.y = PI / 2.0
	add_child(cop)
	city.box(Vector3(0.3, 0.06, 0.32), Vector3(0, 0.13, 0), city.mat(Color(0.05, 0.07, 0.12)), false, cop.get_meta("head"))
	city.interactable("cop", "Talk to the officer", Vector3(0, 0.9, 0), Vector3(0.7, 1.9, 0.7),
		"SILICO PD - BADGE 2211\nPsyon: none (opted out)\nnote: here since the first incident", true, cop)
	statics["cop"] = cop


func _process(delta: float) -> void:
	if not main or not main.player:
		return
	var cam: Camera3D = main.player.cam
	var ppos: Vector3 = main.player.global_position
	var watching: bool = main.connection >= 25.0 and main.flags.has("outage_done")
	var t := Time.get_ticks_msec() / 1000.0
	for p in peds:
		var n: Node3D = p.node
		var head := n.global_position + Vector3(0, 1.7, 0)
		var dist := head.distance_to(cam.global_position)
		var seen := dist < 80.0 and cam.is_position_in_frustum(head)
		if main.outage:
			p.state = "stare"
		elif watching:
			if p.state == "walk" and not seen and dist < 40.0 and randf() < delta * 1.2:
				p.state = "stare"
				p.look_t = 0.0
			elif p.state == "stare" and seen:
				p.look_t += delta
				if p.look_t > 2.4:
					p.state = "walk"
		else:
			p.state = "walk"
		var legs: Array = n.get_meta("legs")
		var visor: MeshInstance3D = n.get_meta("visor")
		if p.state == "walk":
			n.position.z += p.dir * p.speed * delta
			if n.position.z < p.min_z or n.position.z > p.max_z:
				p.dir = -p.dir
			n.rotation.y = lerp_angle(n.rotation.y, 0.0 if p.dir < 0.0 else PI, delta * 4.0)
			var sw := sin(t * p.speed * 4.5 + p.phase) * 0.45
			legs[0].rotation.x = sw
			legs[1].rotation.x = -sw
			if visor:
				visor.material_override = _visor_red if watching else _visor_cyan
		else:
			var d := ppos - n.global_position
			var want := atan2(-d.x, -d.z)
			if seen and not main.outage:
				n.rotation.y = lerp_angle(n.rotation.y, want, delta * 0.6)
			else:
				n.rotation.y = want
			for l in legs:
				l.rotation.x = 0.0
			if visor:
				visor.material_override = _visor_red


## Everyone stops where they are and faces Carl. Used for the outage.
func everyone_faces(point: Vector3) -> void:
	for p in peds:
		var n: Node3D = p.node
		var d := point - n.global_position
		n.rotation.y = atan2(-d.x, -d.z)
		p.state = "stare"
		p.look_t = 0.0
