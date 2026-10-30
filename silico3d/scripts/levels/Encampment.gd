extends "res://scripts/Level.gd"
## Deregistered (bible-1 Standing table, pressure 100; bible-3 "The open
## city": "home is the encampment at Harmony Green ... encampments open as
## safe spaces"). Where Carl sleeps once the tower has locked him out: the
## encampment past the retaining wall in Harmony Green, Tyson Clerif against
## his wall, or the one behind any street's block (Standing._camp_door). A
## tier-0 space: no devices, no cameras, nobody hunting; the cot is sleep
## (City.sleep, +3 pressure or +2 with Calm), Tyson is the handler (his lines
## take Turan's: each morning one incident from the ledger, and what Carl
## did about it), the alley mouth is the map.
##
## Book, ch.2: "As I rounded the corner, I was greeted with a rather ornate
## tent; the area was clean, with a distinct lack of the garbage that I
## would've expected." "This wall's mine. Closest thing I've got to rent."
## Circles inside circles in red dust behind him: "It's not an eye. It's a
## recursive shell." He taught maths at SalTech for twelve years; GPT-Learn
## took his job. Ch.19.5, the train: "Don't trust your reflection. I would
## burn every screen you have if I were you." "Psyon needs to be shut down at
## its core."
##
## Layout (metres): the court runs north from the alley mouth at z 16 to
## Tyson's wall at z -18; x -15..15. The retaining wall (Harmony Green: the
## park's trees over it) is the west side, the back of a block the east. The
## tent ring is round the drum fire at (0, -3), Tyson's ornate tent in the
## north-west corner, Carl's cot in the open tent on the east of the ring.
##
## Flags: camp_seen, handler_d<N> (Tyson's morning question asked), tyson_core
## (the Burn line). Effects: T:tyson by the truth of the answer.

const TrafficS := preload("res://scripts/Traffic.gd")

const RING := Vector3(0.0, 0.0, -3.0)
const COT := Vector3(6.2, 0.0, -1.2)
const TYSON_AT := Vector3(-2.2, 0.0, -16.9)
const WALL_Z := -18.0

const LINES := {
	"card": "[b]THE ENCAMPMENT[/b]\n\n[color=#aaaaaa]%s  ·  past the wall\n%s  ·  no frames past here[/color]",
	"objective": {
		"tyson": "Tyson, against his wall. He'll want to know what you did.",   # (game)
		"sleep": "The cot in the open tent. Tab for the map.",   # (game)
	},
	"prompts": {
		"tyson": "Talk to Tyson", "keeper": "Talk to the woman by the fire", "cot": "The cot: sleep",
		"fire": "Warm your hands", "tent": "Look at the tent", "books": "Look at the books", "board": "Read the board",
		"wall": "Look at the wall", "jugs": "Look at the water", "person": "Talk to them", "end": "The alley mouth (the map)",
		"line": "Look at the washing",
	},
	"scan": {
		"person": "UNREGISTERED\nno ORA frames",
		"tyson": "CLERIF, TYSON (45)\nUNREGISTERED - 2 YEARS\nformerly: SALTECH EDUCATOR",
		"tent": "UNREGISTERED DWELLING\noccupant: CLERIF, T. (45)\ndevices: NONE\ncomplaints: NONE",
		"cot": "UNREGISTERED DWELLING\noccupant: DRAKE, C.\ndevices: ORA FRAMES (1)",
	},
	"arrive": {
		"first": ["Past the wall the noise of the street stopped like a door had shut on it. Swept concrete. Tents in a ring. Nobody here looked up at the drones any more.",   # (game)
			"Somebody had already put a cot in the open tent on the east side. A blanket folded square on it, the way they fold them in the army or in prison."],   # (game)
		"tyson": ["Tyson", "This wall's mine. Closest thing I've got to rent."],
		"tyson2": ["Tyson", "Guess you'll want one too, Corpo. Take the cot. It was Ray's. Ray went to the tower."],   # (game)
		"keeper": ["Keeper", "You're the Psyonic one. Were. Cot's in the open tent. No frames on round the fire, please. The children don't like the light in them."],   # (game)
		"back": "The ring of tents, the drum fire, the swept concrete. Somebody had folded my blanket again.",   # (game)
	},
	# Tyson's handler question: one incident from the ledger, what Carl did (bible-3: his lines replace Turan's)
	"handler": {
		"ask": "%s, in %s. Your frames were there. What did you do about it?",   # (game)
		"none": "Nothing on your feed yesterday? Then you weren't looking. Sit down. Tell me what you saw instead.",   # (game)
		"choices": ["I put my hand on it and it stopped.", "I let it run.", "I buried it.", "I told the company."],
		"true": "Yeah. That's what the wall heard too.",   # (game)
		"false": "I know patterns, Corpo. That's not what happened. You don't have to lie to me. Nobody's grading you down here.",   # (game)
		"open": "It's still running, then. You walked past it. Everybody walks past it.",   # (game)
		"log_true": "Told Tyson the truth about %s.",
		"log_false": "Lied to Tyson about %s. He knew.",
	},
	# the rest of what he says, in turn (book lines first)
	"tyson": [
		["Tyson", "That symbol? It's not an eye. It's a recursive shell. Input feeding into itself. It's not art. It's a ritual. Call and response. And someone, something, is starting to answer."],
		["Tyson", "I know patterns. I know recursion. And I know what it looks like when someone's being programmed."],
		["Tyson", "Don't trust your reflection. I would burn every screen you have if I were you."],
		["Tyson", "They told us if you spoke to the walls someone would answer. Every outage was time for a prayer. I thought they were K'd out of their minds. Then the walls answered."],   # (game)
	],
	"core": [
		["Tyson", "If you really want to save her, you need to stop it at the source. Psyon needs to be shut down at its core; that's the only way to disrupt communication long enough to break out… if she's willing to go."],
		["Tyson", "And when you do it, you'll need someone who knows the way out after. I've been walking out of places for two years."],   # (game)
	],
	"core_log": "Tyson: shut Psyon down at its core; he knows the way out after.",
	"keeper": ["We don't take anything that talks. Phones, watches, the kids' tablets. They go in the drum. It's the only rule.",   # (game)
		"Tyson says the city's got a ghost. I say the ghost's got a city. Same thing, he says, and laughs.",   # (game)
		"You'll sleep. Everyone sleeps the first night. It's the quiet. Up there you forget what quiet is."],   # (game)
	"people": ["Don't stand there with them on. Your glasses. They're looking out of you.",   # (game)
		"I was floor forty. Logistics. Now I'm floor zero. Better view of the sky.",   # (game)
		"My boy asked the wall a question once. It answered in his teacher's voice. We burned the wall's screen and came here.",   # (game)
		"Twelve of us at Christmas. Nine now. The other three went to the vigil and kept going."],   # (game)
	"examine": {
		"fire": "An oil drum, holes punched in it, a fire of pallet wood. On the rim, half-melted, the backs of phones. It's the only rule.",   # (game)
		"tent": "A rather ornate tent. Red and gold and blue canvas in tiers, the guy-ropes pegged in a perfect circle. Rules. Whoever lived here had rules.",   # (game)
		"books": "Paper books in milk crates, spines out, sorted by subject. Calculus. Symbolic logic. Semantic analysis of emotional communication. A whole career, kept dry.",   # (game)
		"board": "A school blackboard leaned against the wall. f(f(f(x))). Under it, in a different hand, smaller: it feeds itself. Under that, somebody had drawn the eye and rubbed it out.",   # (game)
		"wall": "Circles within circles in red dust behind him. Not a warning. Not a message. A system. Watching back.",   # (game)
		"jugs": "Water jugs in a row, filled at the park fountain at night when the jingle stops, every cap screwed tight.",   # (game)
		"line": "Washing on a line between the fire escape and a pole: shirts, a child's dress, a SalTech lanyard nobody had wanted to throw away.",   # (game)
		"end": "The alley mouth, and past it the street, and past that every screen in Silico. I'd need the map for where.",   # (game)
		"no_tyson": "His wall. His books in their crates. Nobody against it.",   # (game)
	},
	"place": {"harmony_green": "Harmony Green, beyond the retaining wall", "_": "%s, behind the block"},
	"phone": "[color=#7fe6b0]Psyon:[/color] %s  ·  %s. No service registered to this user.\n\n",
}

var did := "harmony_green"
var night := true
var tyson: Node3D
var keeper: Node3D
var sitters: Array = []
var _fire_l: OmniLight3D
var _talk_i := 0
var _people_i := 0


func build(m: Node) -> void:
	main = m
	did = str(main.city.district)
	rng.seed = 4500 + absi(hash(did)) % 1000
	night = main.city.is_night()
	kit_day = not night
	rain = false
	spawn = Vector3(0.0, 0.1, 13.0)
	spawn_yaw = 0.0
	step_db = -18.0
	var place: String = LINES["place"]["harmony_green"] if did == "harmony_green" else LINES["place"]["_"] % main.city.district_name(did)
	card = LINES["card"] % [place.to_upper(), main.city.clock_text()]
	_ground()
	_walls()
	_city_above()
	_ring()
	_tyson_corner()
	_camp_life()
	_people()
	_batch(self, 12.0)
	var traffic: Node = TrafficS.new()
	traffic.lanes = [[-6.0, 32.0, 1.0], [8.0, 40.0, -1.0]]
	traffic.s_min = -120.0
	traffic.s_max = 80.0
	traffic.count = 3
	traffic.tower_top = Vector3(500, 420, -500)
	traffic.drone_box = AABB(Vector3(-80, 30, -120), Vector3(160, 60, 160))
	traffic.drone_count = 40
	add_child(traffic)
	traffic.setup(m, self)


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	if night:
		env.fog_density = 0.004
		env.fog_light_color = Color(0.16, 0.09, 0.08)
		return
	var psm := ProceduralSkyMaterial.new()
	var h := int(main.hour) % 24
	var dusk := h >= 17 or h < 8
	psm.sky_top_color = Color(0.3, 0.38, 0.52) if not dusk else Color(0.16, 0.16, 0.3)
	psm.sky_horizon_color = Color(0.85, 0.7, 0.55) if not dusk else Color(0.95, 0.5, 0.3)
	psm.ground_horizon_color = psm.sky_horizon_color
	psm.ground_bottom_color = Color(0.25, 0.22, 0.2)
	env.sky.sky_material = psm
	env.glow_bloom = 0.0
	env.ambient_light_color = Color(0.6, 0.58, 0.55)
	env.ambient_light_energy = 0.4
	env.fog_light_color = Color(0.75, 0.62, 0.5) if not dusk else Color(0.7, 0.42, 0.3)
	env.fog_density = 0.003
	sun.light_color = Color(1.0, 0.88, 0.72) if not dusk else Color(1.0, 0.6, 0.4)
	sun.light_energy = 1.0 if not dusk else 0.6
	sun.sky_mode = DirectionalLight3D.SKY_MODE_LIGHT_AND_SKY
	sun.rotation = Vector3(deg_to_rad(-55 if not dusk else -18), deg_to_rad(210), 0)
	sun.directional_shadow_max_distance = 60.0


func ambience() -> void:
	main.loop("wind", -20.0)
	main.loop("fire", -12.0, RING + Vector3(0, 1.0, 0), 2.0, 16.0)
	main.loop("murmur", -16.0, RING + Vector3(0, 1.2, 0), 3.0, 22.0)


func intro() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	main.update_hud()
	if f.has("camp_seen"):
		if not main._selftest:
			ui.caption(LINES["arrive"]["back"], 4.0)
		return
	f["camp_seen"] = true
	for l: String in LINES["arrive"]["first"]:
		await ui.think(l)
	if tyson:
		await main.player.face(tyson.global_position + Vector3(0, 1.0, 0), 1.0)
		await ui.say(LINES["arrive"]["tyson"][0], LINES["arrive"]["tyson"][1])
		await ui.say(LINES["arrive"]["tyson2"][0], LINES["arrive"]["tyson2"][1])
	elif keeper:
		await ui.say(LINES["arrive"]["keeper"][0], LINES["arrive"]["keeper"][1])
	ui.close()
	main.log_line("scene", "Slept rough for the first time: the encampment, %s." % main.city.district_name(did))


# ------------------------------------------------------------------ the court

func _ground() -> void:
	solid_box(Vector3(80, 2, 80), Vector3(0, -1.0, 0))
	var conc := pbr("concrete", Vector3(1, 1, 1) / 3.0, true, Color(0.62, 0.6, 0.57), 0.9)
	floor_quad(Vector2(30, 36), Vector3(0, 0.0, -1.0), 0.0, conc)
	# swept: a cleaner disc round the fire, the broom strokes in arcs
	var swept := mat(Color(0.5, 0.48, 0.45), 0.95)
	for k in 3:
		var ring := TorusMesh.new()
		ring.inner_radius = 2.4 + k * 1.6
		ring.outer_radius = 2.5 + k * 1.6
		ring.rings = 32
		ring.ring_segments = 3
		var r := mesh(ring, RING + Vector3(0, 0.004, 0), swept)
		r.scale.y = 0.02
	var far := PlaneMesh.new()
	far.size = Vector2(600, 600)
	mesh(far, Vector3(0, -0.05, 0), mat(Color(0.06, 0.055, 0.05) if night else Color(0.3, 0.28, 0.25)))


func _walls() -> void:
	var conc := pbr("concrete", Vector3(1, 1, 1) / 2.5, true, Color(0.7, 0.66, 0.6))
	# Tyson's wall to the north: tall, the circles in red dust
	box(Vector3(32, 7.0, 0.6), Vector3(0, 3.5, WALL_Z), conc, true)
	var wp := Vector3(0.6, 3.1, WALL_Z + 0.31)
	for k in 4:
		var s := Sprite3D.new()
		s.texture = _glyph_tex
		s.pixel_size = 0.018 * (1.0 + k * 0.65)
		s.modulate = Color(0.62, 0.16, 0.1, 0.85 - k * 0.18)
		s.position = wp + Vector3(0, 0, 0.005 * k)
		add_child(s)
	interactable("wall", LINES["prompts"]["wall"], wp, Vector3(4.0, 3.0, 0.3), "", false)
	# west: the retaining wall at Harmony Green (the park's trees over it), else a block's back
	if did == "harmony_green":
		box(Vector3(0.6, 2.6, 36), Vector3(-15.0, 1.3, -1.0), conc, true)
		solid_box(Vector3(0.4, 6.0, 36), Vector3(-15.0, 3.0, -1.0))
		var bark := pbr("bark", Vector3(1, 1, 1) / 1.5, true)
		var leaves := [mat(Color(0.2, 0.32, 0.18)), mat(Color(0.25, 0.36, 0.2))]
		var z := 12.0
		while z > -18.0:
			tree(Vector3(rng.randf_range(-19.0, -26.0), 0.0, z), rng.randf_range(5.0, 8.0), bark, leaves)
			z -= rng.randf_range(6.0, 9.0)
		neon_text("TRANQUILITY ZONE", Vector3(-15.32, 2.3, 6.0), PI / 2.0, 0.3, Color(0.5, 1.0, 0.7), -1.0, self)
	else:
		cyber_block(Vector3(-15.0, 0, -1.0), PI / 2.0, 36.0, rng.randf_range(18.0, 30.0), 14.0)
	# east: the back of a block, a fire escape, the washing line
	cyber_block(Vector3(15.0, 0, -1.0), -PI / 2.0, 36.0, rng.randf_range(24.0, 40.0), 16.0)
	var rust := pbr("rust", Vector3(1, 1, 1) / 2.0, true)
	for k in 3:
		var y := 3.2 + k * 3.2
		box(Vector3(1.4, 0.08, 4.0), Vector3(14.2, y, 6.0), rust)
		box(Vector3(0.05, 1.0, 4.0), Vector3(13.52, y + 0.5, 6.0), rust)
	stick(Vector3(13.6, 0.1, 4.0), Vector3(13.6, 3.2, 8.0), 0.05, rust)
	# south: the alley mouth between two backs
	box(Vector3(12.0, 9.0, 1.0), Vector3(-9.0, 4.5, 16.5), conc, true)
	box(Vector3(12.0, 9.0, 1.0), Vector3(9.0, 4.5, 16.5), conc, true)
	solid_box(Vector3(8.0, 4.0, 0.5), Vector3(0, 2.0, 19.0))
	var e := interactable("end", LINES["prompts"]["end"], Vector3(0, 1.5, 17.5), Vector3(6.0, 3.0, 1.0), "", true)
	e.set_meta("exit", true)
	# behind Tyson's wall, the city goes up
	cyber_block(Vector3(0, 0, WALL_Z - 2.0), 0.0, 34.0, rng.randf_range(30.0, 46.0), 18.0)


## The blocks' upper floors, the tower somewhere, the ads that can see the camp.
func _city_above() -> void:
	for k in 4:
		var z := 12.0 - k * 9.0
		cable(Vector3(-15.0, rng.randf_range(8.0, 12.0), z), Vector3(15.0, rng.randf_range(9.0, 13.0), z + rng.randf_range(-3.0, 3.0)), rng.randf_range(0.6, 1.4))
	var ad: Array = KIT_ADS[0]
	kit_holo(Vector3(13.2, 16.0, -4.0), -PI / 2.0 - 0.3, ad[0], ad[1], KIT_NEON[1], 9.0)
	var p := Vector3(520.0, 0.0, -520.0)
	var jade := mat(Color(0.16, 0.42, 0.34), 0.28, 0.75)
	cyl(18.0, 26.0, 420.0, p + Vector3(0, 210.0, 0), jade, 24)
	box(Vector3(3, 3, 3), p + Vector3(0, 424.0, 0), glow(Color(1, 0.05, 0.05), 5.0))
	for k in 6:
		cyl(19.5, 19.5, 1.2, p + Vector3(0, 60.0 + k * 55.0, 0), glow(Color(0.3, 1.0, 0.7), 2.4 if night else 1.0), 24)
	var dr := prop("police_drone", Vector3(3.0, 14.0, -10.0), 0.6, 1.0, false)
	if dr:
		no_batch.append(dr)


# ------------------------------------------------------------------ the tents

func _tent(p: Vector3, rot: float, canvas: Material, kind: int) -> void:
	var t := Node3D.new()
	t.position = p
	t.rotation.y = rot
	add_child(t)
	match kind:
		0:
			# a ridge tent: two sloped panels, the open end facing the fire
			for s: float in [-1.0, 1.0]:
				var pnl := box(Vector3(1.5, 0.04, 2.4), Vector3(s * 0.62, 0.62, 0), canvas, false, t)
				pnl.rotation.z = s * 0.95
			box(Vector3(0.04, 0.04, 2.5), Vector3(0, 1.22, 0), mat(Color(0.3, 0.28, 0.25), 0.7), false, t)
		1:
			# a dome from a cone, a flap folded back
			cyl(0.15, 1.3, 1.5, Vector3(0, 0.75, 0), canvas, 8, t)
			box(Vector3(0.7, 1.0, 0.04), Vector3(0, 0.5, 1.2), mat(Color(0.05, 0.04, 0.03), 1.0), false, t)
		_:
			# a tarp over a frame of pallets
			box(Vector3(2.4, 0.04, 2.2), Vector3(0, 1.4, 0), canvas, false, t).rotation.x = 0.2
			for x: float in [-1.1, 1.1]:
				box(Vector3(0.1, 1.3, 1.9), Vector3(x, 0.65, 0), pbr("woodfloor", Vector3.ONE, true, Color(0.6, 0.5, 0.36)), false, t)
	# a bedroll inside, a crate by the door
	box(Vector3(0.7, 0.08, 1.8), Vector3(0, 0.04, -0.1), mat(Color(0.25, 0.27, 0.32), 0.95), false, t)
	box(Vector3(0.36, 0.3, 0.36), Vector3(0.7, 0.15, 1.3), pbr("woodfloor", Vector3.ONE, true, Color(0.55, 0.42, 0.3)), false, t)
	solid_box(Vector3(2.4, 1.6, 2.4), p + Vector3(0, 0.8, 0))


func _ring() -> void:
	var canvas := [mat(Color(0.28, 0.24, 0.18), 0.95), mat(Color(0.2, 0.26, 0.24), 0.95), mat(Color(0.32, 0.2, 0.2), 0.95),
		mat(Color(0.18, 0.22, 0.32), 0.95), mat(Color(0.4, 0.34, 0.2), 0.95)]
	var k := 0
	for a_deg: float in [200.0, 235.0, 270.0, 305.0, 125.0, 160.0]:
		var a := deg_to_rad(a_deg)
		var p := RING + Vector3(cos(a) * 7.5, 0, sin(a) * 7.5)
		var face := RING - p
		_tent(p, atan2(face.x, face.z), canvas[k % canvas.size()], k % 3)
		k += 1
	# Carl's: the open tent on the east of the ring, the cot in it
	var cp := COT
	var cc: Material = mat(Color(0.3, 0.32, 0.36), 0.95)
	# a lean-to: one sloped tarp off a back wall of pallets, open to the fire
	box(Vector3(2.4, 0.04, 2.8), cp + Vector3(0.6, 1.75, 0), cc).rotation.z = -0.35
	for z: float in [-1.3, 1.3]:
		cyl(0.03, 0.03, 1.9, cp + Vector3(-0.4, 0.95, z), mat(Color(0.3, 0.3, 0.3), 0.5, 0.7), 5)
	box(Vector3(0.05, 1.6, 2.6), cp + Vector3(1.8, 0.8, 0), cc, true)
	# the cot: a frame, canvas, the blanket folded square
	var steel := mat(Color(0.35, 0.36, 0.34), 0.5, 0.6)
	box(Vector3(0.8, 0.06, 1.9), cp + Vector3(0.7, 0.42, 0), mat(Color(0.32, 0.36, 0.28), 0.9))
	for x: float in [0.32, 1.08]:
		for z: float in [-0.9, 0.9]:
			box(Vector3(0.04, 0.42, 0.04), cp + Vector3(x, 0.21, z), steel)
	box(Vector3(0.5, 0.1, 0.4), cp + Vector3(0.7, 0.5, 0.6), mat(Color(0.5, 0.18, 0.15), 0.95))
	solid_box(Vector3(0.9, 0.5, 2.0), cp + Vector3(0.7, 0.25, 0))
	interactable("cot", LINES["prompts"]["cot"], cp + Vector3(0.7, 0.6, 0), Vector3(1.0, 0.6, 2.0), LINES["scan"]["cot"], false)
	# the drum fire in the middle
	prop("Barrel_01", RING, 0.0, 1.0, true)
	var fire := glow(Color(1.0, 0.45, 0.12), 3.5)
	box(Vector3(0.5, 0.08, 0.5), RING + Vector3(0, 0.98, 0), fire)
	for i in 5:
		var fl := box(Vector3(0.08, 0.3, 0.08), RING + Vector3(rng.randf_range(-0.15, 0.15), 1.15, rng.randf_range(-0.15, 0.15)), glow(Color(1.0, 0.6, 0.2), 4.0))
		no_batch.append(fl)
		flickers.append(fl)
	_fire_l = light(RING + Vector3(0, 1.6, 0), Color(1.0, 0.52, 0.22), 2.2, 11.0, false)
	flickers.append(_fire_l)
	interactable("fire", LINES["prompts"]["fire"], RING + Vector3(0, 0.8, 0), Vector3(1.0, 1.4, 1.0), "", false)
	# crates for seats round it
	for i in 6:
		var a := TAU * (i + 0.5) / 6.0
		box(Vector3(0.45, 0.4, 0.45), RING + Vector3(cos(a) * 2.2, 0.2, sin(a) * 2.2), pbr("woodfloor", Vector3.ONE, true, Color(0.55, 0.42, 0.3)), true)


## Tyson's corner: the ornate tent, his wall, his books, the blackboard.
func _tyson_corner() -> void:
	var tp := Vector3(-8.0, 0, -13.0)
	var canvas := [mat(Color(0.55, 0.15, 0.12), 0.9), mat(Color(0.8, 0.6, 0.2), 0.9), mat(Color(0.15, 0.3, 0.45), 0.9)]
	for k in 3:
		cyl(1.6 - k * 0.5, 2.2 - k * 0.5, 0.8, tp + Vector3(0, 0.4 + k * 0.8, 0), canvas[k], 8)
	cyl(0.0, 0.7, 0.8, tp + Vector3(0, 2.8, 0), canvas[1], 8)
	box(Vector3(0.05, 1.2, 0.8), tp + Vector3(1.6, 0.6, 1.2), mat(Color(0.05, 0.04, 0.03), 1.0))
	solid_box(Vector3(4.2, 3.2, 4.2), tp + Vector3(0, 1.6, 0))
	floor_quad(Vector2(3.0, 2.0), tp + Vector3(3.6, 0.02, 1.6), 0.0, mat(Color(0.5, 0.2, 0.25), 1.0))
	floor_quad(Vector2(2.6, 1.6), tp + Vector3(3.6, 0.025, 1.6), 0.0, mat(Color(0.75, 0.6, 0.3), 1.0))
	interactable("tent", LINES["prompts"]["tent"], tp + Vector3(0, 1.2, 0), Vector3(4.4, 2.6, 4.4), LINES["scan"]["tent"])
	# the books: milk crates of paper, spines out
	var crate := mat(Color(0.12, 0.22, 0.5), 0.7)
	for i in 4:
		var cpos := Vector3(-5.6 + (i % 2) * 0.5, 0.2 + int(i / 2) * 0.4, WALL_Z + 0.55)
		box(Vector3(0.46, 0.38, 0.38), cpos, crate)
		for b in 7:
			box(Vector3(0.05, 0.3, 0.26), cpos + Vector3(-0.17 + b * 0.055, 0.0, 0.0), mat(Color(0.35 + 0.08 * (b % 4), 0.25 + 0.05 * (b % 3), 0.2), 0.9))
	solid_box(Vector3(1.0, 0.8, 0.45), Vector3(-5.35, 0.4, WALL_Z + 0.55))
	interactable("books", LINES["prompts"]["books"], Vector3(-5.35, 0.5, WALL_Z + 0.6), Vector3(1.1, 0.9, 0.6), "", false)
	# the blackboard against the wall, chalk
	var bp := Vector3(4.2, 0.0, WALL_Z + 0.5)
	var board := box(Vector3(2.2, 1.3, 0.06), bp + Vector3(0, 1.2, 0), mat(Color(0.08, 0.12, 0.1), 0.9))
	board.rotation.x = -0.12
	box(Vector3(2.3, 0.06, 0.1), bp + Vector3(0, 0.5, 0.1), pbr("woodfloor", Vector3.ONE, true, Color(0.5, 0.38, 0.26)))
	var chalk := label("f(f(f(x)))\nlim  n -> oo\nit feeds itself", bp + Vector3(0, 1.25, 0.08), 0.0, 0.0026, Color(0.9, 0.9, 0.85), self, false)
	chalk.rotation.x = -0.12
	interactable("board", LINES["prompts"]["board"], bp + Vector3(0, 1.2, 0.1), Vector3(2.2, 1.4, 0.3), "", false)
	solid_box(Vector3(2.3, 1.8, 0.4), bp + Vector3(0, 0.9, 0.0))
	# a cool wash on the wall from a work lamp on a crate
	var lamp := light(Vector3(1.0, 2.2, WALL_Z + 2.6), Color(0.75, 0.82, 1.0), 0.9, 8.0, false)
	lamp.light_energy = 0.9 if night else 0.3
	if did == "harmony_green" and main.city.standing.tyson_alive():
		tyson = figure(Color(0.35, 0.28, 0.2), Color(0.55, 0.4, 0.3), {"hair": Color(0.3, 0.3, 0.3), "legs": Color(0.25, 0.22, 0.18), "arms": true, "knees": true})
		tyson.position = TYSON_AT + Vector3(0, -0.41, 0)
		tyson.rotation.y = PI
		add_child(tyson)
		Anim.sit(tyson, 0.25)
		person("tyson", LINES["prompts"]["tyson"], tyson, LINES["scan"]["tyson"])


## The washing, the water, the string of bulbs, blue vapour, the rule.
func _camp_life() -> void:
	# the washing line from the fire escape to a pole
	var pole := mat(Color(0.3, 0.3, 0.3), 0.5, 0.7)
	cyl(0.04, 0.05, 2.6, Vector3(7.5, 1.3, 10.0), pole, 6)
	cable(Vector3(13.5, 2.4, 7.0), Vector3(7.5, 2.4, 10.0), 0.3)
	var cloth := [mat(Color(0.75, 0.72, 0.68), 0.95), mat(Color(0.55, 0.2, 0.3), 0.95), mat(Color(0.2, 0.55, 0.45), 0.95), mat(Color(0.85, 0.85, 0.3), 0.95)]
	for i in 6:
		var t := (i + 0.5) / 6.0
		var p := Vector3(13.5, 2.4, 7.0).lerp(Vector3(7.5, 2.4, 10.0), t) + Vector3(0, -0.25 - sin(t * PI) * 0.3, 0)
		box(Vector3(0.45, 0.55, 0.02), p + Vector3(0, -0.25, 0), cloth[i % cloth.size()]).rotation.y = -0.46
	box(Vector3(0.06, 0.4, 0.02), Vector3(10.5, 1.55, 8.5), glow(Color(0.3, 1.0, 0.6), 0.6))
	interactable("line", LINES["prompts"]["line"], Vector3(10.5, 1.8, 8.5), Vector3(5.0, 1.0, 0.6), "", false)
	# water jugs in a row by the east wall
	var jug := mat(Color(0.6, 0.75, 0.85), 0.2)
	for i in 8:
		cyl(0.13, 0.13, 0.42, Vector3(12.4, 0.21, -9.0 + i * 0.32), jug, 8)
	interactable("jugs", LINES["prompts"]["jugs"], Vector3(12.4, 0.4, -7.9), Vector3(0.5, 0.6, 2.8), "", false)
	# a string of salvaged bulbs from the wall round the ring
	var bulb := glow(Color(1.0, 0.82, 0.5), 2.2)
	var pts := [Vector3(-12.0, 4.2, WALL_Z + 0.4), Vector3(-6.0, 3.6, -6.0), Vector3(0.0, 3.8, 3.0), Vector3(7.0, 3.6, -6.0), Vector3(12.0, 4.4, WALL_Z + 0.4)]
	for i in pts.size() - 1:
		cable(pts[i], pts[i + 1], 0.6)
		for k in 5:
			var t := (k + 0.5) / 5.0
			var p: Vector3 = (pts[i] as Vector3).lerp(pts[i + 1], t) + Vector3(0, -sin(t * PI) * 0.6 - 0.12, 0)
			sphere(0.06, p, bulb, 6)
	light(Vector3(-4.0, 3.2, -6.0), Color(1.0, 0.8, 0.5), 0.9 if night else 0.2, 9.0, false)
	light(Vector3(5.0, 3.2, -6.0), Color(1.0, 0.8, 0.5), 0.9 if night else 0.2, 9.0, false)
	# a rain barrel and the phones in the drum's ash, a broom against the tent
	prop("plastic_crate_03", Vector3(-11.5, 0.0, 8.0), 0.4, 1.0, true)
	prop("cardboard_box_01", Vector3(-12.2, 0.0, 6.6), 0.0, 1.0, true)
	prop("old_tyre", Vector3(11.8, 0.0, 12.5), 0.0, 1.0, true)
	stick(Vector3(-3.6, 0.0, -9.2), Vector3(-3.3, 1.4, -9.0), 0.02, mat(Color(0.5, 0.4, 0.25), 0.9))


func _people() -> void:
	var coats := [Color(0.3, 0.26, 0.22), Color(0.22, 0.24, 0.2), Color(0.35, 0.18, 0.16), Color(0.2, 0.2, 0.25), Color(0.4, 0.36, 0.3)]
	var skins := [Color(0.85, 0.66, 0.52), Color(0.6, 0.42, 0.3), Color(0.4, 0.28, 0.2), Color(0.92, 0.78, 0.66), Color(0.7, 0.52, 0.38)]
	# round the fire on the crates: unregistered, no frames, faces lit from below
	for i in 4:
		var a := TAU * (i + 0.5) / 6.0 + (PI if i >= 2 else 0.0)
		var p := RING + Vector3(cos(a) * 2.2, 0.0, sin(a) * 2.2)
		var f := figure(coats[i % coats.size()], skins[(i + 1) % skins.size()], {"hair": Color(0.15, 0.12, 0.1), "arms": true, "knees": true})
		f.position = p + Vector3(0, -0.02, 0)
		add_child(f)
		turn_to(f, RING)
		Anim.sit(f, 0.2)
		for arm in f.get_meta("arms"):
			(arm as Node3D).rotation.x = -0.9
		if i < 3:
			person("person%d" % i, LINES["prompts"]["person"], f, LINES["scan"]["person"])
		sitters.append(f)
		if i % 2 == 0:
			_vapour(p + Vector3(0, 1.45, 0))
	# the keeper, where Tyson isn't
	if tyson == null:
		keeper = figure(Color(0.4, 0.22, 0.2), Color(0.6, 0.42, 0.3), {"hair": Color(0.7, 0.7, 0.68), "long_hair": true, "arms": true, "knees": true})
		keeper.position = RING + Vector3(-1.6, 0.0, 3.2)
		add_child(keeper)
		turn_to(keeper, Vector3(0, 0, 13))
		person("keeper", LINES["prompts"]["keeper"], keeper, LINES["scan"]["person"])
	# a child asleep in a doorway, a blanket to the chin
	var kid := figure(Color(0.5, 0.3, 0.5), skins[0], {"scale": 0.55, "arms": true, "knees": true})
	kid.position = RING + Vector3(cos(deg_to_rad(235.0)) * 6.2, 0.05, sin(deg_to_rad(235.0)) * 6.2)
	kid.rotation = Vector3(-PI / 2.0, 0.6, 0)
	add_child(kid)


## Blue vapour off a vape: a slow plume (bible A1-S2's "blue vapour sprites").
func _vapour(p: Vector3) -> void:
	var cp := CPUParticles3D.new()
	cp.position = p
	cp.amount = 14
	cp.lifetime = 3.0
	cp.direction = Vector3(0, 1, 0)
	cp.spread = 25.0
	cp.initial_velocity_min = 0.15
	cp.initial_velocity_max = 0.35
	cp.gravity = Vector3(0, 0.05, 0)
	cp.scale_amount_min = 0.6
	cp.scale_amount_max = 1.4
	var qm := QuadMesh.new()
	qm.size = Vector2(0.18, 0.18)
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	m.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	m.albedo_color = Color(0.45, 0.7, 1.0, 0.18)
	qm.material = m
	cp.mesh = qm
	add_child(cp)


func tick(delta: float) -> void:
	if not main or not main.player:
		return
	var pp: Vector3 = main.player.global_position
	if tyson:
		Anim.look(tyson, pp + Vector3(0, 1.6, 0), 0.7 if pp.distance_to(tyson.global_position) < 9.0 else 0.0, 0.05)
	if keeper:
		Anim.idle(keeper, _t, 1.0)
		Anim.look(keeper, pp + Vector3(0, 1.6, 0), 0.8 if pp.distance_to(keeper.global_position) < 7.0 else 0.0, 0.06)
	if _fire_l:
		_fire_l.light_energy = 2.0 + 0.5 * sin(_t * 9.0) + 0.3 * sin(_t * 23.0)


# ------------------------------------------------------------------ hooks

func refresh_city() -> void:
	main.update_hud()


func objective() -> String:
	if tyson and not main.flags.has("handler_d%d" % int(main.day)):
		return LINES["objective"]["tyson"]
	return LINES["objective"]["sleep"]


func phone() -> String:
	return LINES["phone"] % [main.city.district_name(did), main.city.clock_text()]


func scan_people() -> Array:
	var out := []
	for f in sitters:
		out.append([f, LINES["scan"]["person"]])
	return out


func interact(node: Object) -> bool:
	var ui = main.ui
	var ex: Dictionary = LINES["examine"]
	var id := str(node.get_meta("id"))
	match id:
		"tyson":
			await _tyson()
		"keeper":
			var K: Array = LINES["keeper"]
			await ui.say("Keeper", K[_talk_i % K.size()])
			_talk_i += 1
		"cot":
			ui.close()
			await main.city.sleep()
		"end":
			await ui.think(ex["end"])
			ui.close()
			main.city.open_map()
		"tent", "books", "board", "wall", "fire", "jugs", "line":
			await ui.think(ex[id])
			if id == "books" and tyson == null:
				await ui.think(ex["no_tyson"])
		"person0", "person1", "person2":
			var P: Array = LINES["people"]
			await ui.say("", P[(_people_i + int(id.substr(6))) % P.size()])
			_people_i += 1
		_:
			return false
	return true


## The handler (his lines take Turan's): the first talk of the day is one
## incident from the ledger and what Carl did about it; the truth or a lie,
## and he knows. After that, what he knows; at T:tyson >= 1, the core.
func _tyson() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var H: Dictionary = LINES["handler"]
	var key := "handler_d%d" % int(main.day)
	if not f.has(key):
		f[key] = true
		var inc := _latest_incident()
		if inc.is_empty():
			await ui.say("Tyson", H["none"])
		else:
			var where: String = main.city.district_name(inc["district"])
			await ui.say("Tyson", H["ask"] % [str(inc["title"]), where])
			var i: int = await ui.choose(H["choices"])
			ui.close()
			var truth := {"fixed": 0, "let_run": 1, "expired": 1, "buried": 2, "reported": 3}
			var st := str(inc.get("state", "open"))
			if st == "open":
				await ui.say("Tyson", H["open"])
			elif int(truth.get(st, -1)) == i:
				await ui.say("Tyson", H["true"])
				main.add_trust("tyson", 1)
				main.log_line("handler", H["log_true"] % str(inc["title"]))
			else:
				await ui.say("Tyson", H["false"])
				main.add_trust("tyson", -1)
				main.log_line("handler", H["log_false"] % str(inc["title"]))
		return
	if int(main.trust.get("tyson", 0)) >= 1 and not f.has("tyson_core"):
		f["tyson_core"] = true
		for ln: Array in LINES["core"]:
			await ui.say(ln[0], ln[1])
		main.log_line("testimony", LINES["core_log"])
		return
	var T: Array = LINES["tyson"]
	var l: Array = T[_talk_i % T.size()]
	_talk_i += 1
	await ui.say(l[0], l[1])


## The incident Carl last made a call on (or the oldest one still open).
func _latest_incident() -> Dictionary:
	var best := {}
	for id in main.incidents:
		var inc: Dictionary = main.incidents[id]
		if str(inc.get("state", "")) == "open":
			if best.is_empty():
				best = inc
			continue
		if best.is_empty() or str(best.get("state", "")) == "open" or int(inc.get("call_day", 0)) >= int(best.get("call_day", 0)):
			best = inc
	return best


# ------------------------------------------------------------------ test

func selftest() -> void:
	if tyson:
		await check_walk("camp spawn->tyson", "tyson")
	else:
		await check_walk("camp spawn->keeper", "keeper")
	await check_walk("camp spawn->cot", "cot")
	await check_walk("camp spawn->fire", "fire")
	await check_walk("camp spawn->books", "books")
	await check_walk("camp spawn->board", "board")
	await check_walk("camp spawn->washing", "line")
	for id in ["tyson", "keeper", "fire", "tent", "books", "board", "wall", "person0", "person1", "jugs", "line", "tyson"]:
		var n := by_id(id)
		if n:
			await main.interact(n)
			print("ok ", id)
	print("ok camp handler_today=", main.flags.has("handler_d%d" % int(main.day)), " trust_tyson=", main.trust.get("tyson", 0))
