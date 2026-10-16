extends Node3D
## Hover cars in lanes over the boulevard, and the delivery drones that swarm
## to the tower "like bees to a hive" (book, ch. 3). In an outage the cars
## stop dead in the air with their lights out.

var main: Node
var city: Node
var cars: Array = []
var drones: MultiMeshInstance3D
var drone_data: Array = []
var _flow := 1.0
var rng := RandomNumberGenerator.new()

const LANES := [[-6.5, 5.5, 1.0], [-3.0, 9.0, 1.0], [3.0, 9.0, -1.0], [6.5, 5.5, -1.0],
	[-5.0, 14.0, 1.0], [5.0, 14.0, -1.0]]
const TOWER_TOP := Vector3(0, 470, -330)


func setup(m: Node) -> void:
	main = m
	city = m.city
	rng.seed = 5
	var paints := [Color(0.05, 0.05, 0.06), Color(0.6, 0.62, 0.65), Color(0.5, 0.08, 0.1),
		Color(0.08, 0.2, 0.3), Color(0.85, 0.85, 0.82)]
	var under := [Color(0.2, 0.9, 1.0), Color(1.0, 0.25, 0.7), Color(0.4, 1.0, 0.5)]
	var whoosh: AudioStream = m.sfx.get("car")
	for i in 14:
		var lane: Array = LANES[i % LANES.size()]
		var car := Node3D.new()
		add_child(car)
		var paint: StandardMaterial3D = city.mat(paints[rng.randi() % paints.size()], 0.2, 0.7)
		city.box(Vector3(2.0, 0.6, 4.4), Vector3(0, 0, 0), paint, false, car)
		city.box(Vector3(1.7, 0.5, 2.2), Vector3(0, 0.5, 0.3), city.mat(Color(0.02, 0.03, 0.04), 0.05, 0.6), false, car)
		city.box(Vector3(1.7, 0.1, 0.05), Vector3(0, 0.05, -2.22), city.glow(Color(1, 0.97, 0.9), 4.0, true), false, car)
		city.box(Vector3(1.8, 0.1, 0.05), Vector3(0, 0.1, 2.22), city.glow(Color(1, 0.05, 0.05), 3.0, true), false, car)
		var uc: Color = under[rng.randi() % under.size()]
		city.box(Vector3(1.6, 0.04, 3.6), Vector3(0, -0.32, 0), city.glow(uc, 2.0, true), false, car)
		if i % 3 == 0:
			var o: OmniLight3D = city.light(Vector3.ZERO, uc, 1.2, 9.0)
			o.reparent(car, false)
			o.position = Vector3(0, -0.6, 0)
		if whoosh and i % 2 == 0:
			var ap := AudioStreamPlayer3D.new()
			ap.stream = whoosh
			ap.unit_size = 5.0
			ap.max_distance = 70.0
			ap.volume_db = -6.0
			ap.pitch_scale = rng.randf_range(0.8, 1.2)
			ap.autoplay = true
			car.add_child(ap)
		car.position = Vector3(lane[0], lane[1], rng.randf_range(-200.0, 140.0))
		car.rotation.y = 0.0 if lane[2] < 0.0 else PI
		cars.append({"node": car, "dir": lane[2], "speed": rng.randf_range(14.0, 24.0), "y": lane[1]})
	_drones()


func _drones() -> void:
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	var bm := BoxMesh.new()
	bm.size = Vector3(0.6, 0.25, 0.6)
	mm.mesh = bm
	mm.instance_count = 260
	drones = MultiMeshInstance3D.new()
	drones.multimesh = mm
	drones.material_override = city.glow(Color(1.0, 0.85, 0.55), 5.0)
	drones.extra_cull_margin = 2000.0
	add_child(drones)
	for i in mm.instance_count:
		var start := Vector3(rng.randf_range(-250, 250), rng.randf_range(25, 120), rng.randf_range(-80, 260))
		drone_data.append({"a": start, "t": rng.randf(), "v": rng.randf_range(0.035, 0.07),
			"w": rng.randf() * TAU, "back": rng.randf() < 0.4})


func _process(delta: float) -> void:
	_flow = lerpf(_flow, 0.0 if main.outage else 1.0, minf(1.0, delta * (3.0 if main.outage else 0.6)))
	for c in cars:
		var n: Node3D = c.node
		n.position.z += c.dir * c.speed * delta * _flow
		if n.position.z < -175.0:
			n.position.z = 150.0
		elif n.position.z > 150.0:
			n.position.z = -175.0
		n.position.y = c.y + sin(Time.get_ticks_msec() / 700.0 + n.position.z * 0.1) * 0.15
	var mm := drones.multimesh
	for i in drone_data.size():
		var d: Dictionary = drone_data[i]
		d.t = fmod(d.t + d.v * delta * (0.3 + 0.7 * _flow), 1.0)
		var k: float = d.t if not d.back else 1.0 - d.t
		var p: Vector3 = (d.a as Vector3).lerp(TOWER_TOP, k * k * (3.0 - 2.0 * k))
		p += Vector3(sin(d.t * 40.0 + d.w), cos(d.t * 33.0 + d.w), 0) * 1.5
		mm.set_instance_transform(i, Transform3D(Basis(), p))
