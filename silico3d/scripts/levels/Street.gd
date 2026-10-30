extends "res://scripts/Level.gd"
## The open city: one street in one of Silico's districts (City.district),
## built from the city kit at the Spine's density, and dressed by the clock
## (day or night) and the district's Faith (bible-1 "The city": graffiti eyes
## and stick rings at 1, vigils and candles at 2, a congregation facing the
## tower at 3). On it: the district's landmark, a city terminal (trades and
## sacrifice, Terminal.gd), an open incident's device with the red eye over
## it, people who say what the street thinks of Carl, and, when the
## scheduler has a story beat open here, its door. Both ends of the street
## open the map (Tab), which is how Carl leaves.
## Layout (metres): the road runs north along -Z from z 70 to z -110, the
## building fronts at x = +-13; the landmark closes the north end.

const TrafficS := preload("res://scripts/Traffic.gd")
const EncountersS := preload("res://scripts/Encounters.gd")
const NightS := preload("res://scripts/Night.gd")

const N := -110.0
const S := 70.0
const FRONT := 13.0

const LINES := {
	"prompts": {
		"kiosk": "Use the city terminal",
		"end": "The street goes on (the map)",
		"home": "The residential entrance: up to 86D",
		"sign": "Read the street sign",
		"ring": "Look at the sticks",
		"eye": "Look at the eye on the wall",
		"vigil": "Look at the candles",
		"kneel": "Look at the people kneeling",
		"person": "Talk to them",
		"landmark": "Look at it",
	},
	"scan": {
		"kiosk": "CITY TERMINAL %d\nservices: TRANSIT, BILLS, FREUDBOT\nsession: OPEN",
		"person": "CITIZEN\nPsyon 4.1  -  sync %d%%\nfacing: %s",
		"kneel": "CITIZEN\nPsyon: sync 100%\nstatus: KNEELING",
		"home": "PSYONIC TOWER  -  RESIDENTIAL\nlift: FLOORS 40-120\nbadge: DRAKE, C.",
	},
	"examine": {
		"kiosk_dead": "(game) The terminal's screen was black. With the frames off it had nobody to wake for.",
		"end": "(game) The street ran on into the next one. I'd need the map for where.",
		"ring": "(game) Sticks laid in two rings on the pavement, one inside the other. Someone had swept round them and not through them.",
		"eye": "(game) An eye in house paint on the wall, the iris done twice, the pupil once. The paint was still tacky.",
		"vigil": "(game) Candles in a ring on the kerb, real wax, the flames all leaning the same way. Toward the tower.",
		"kneel": "(game) They knelt in the road with their faces up and their frames on. Not one of them looked at me. All of them knew I was there.",
		"sign": "%s. %s",
	},
	# what people on the street say; the stance lines are the pixel game's (MapScene.STANCE_LINES)
	"people": {
		"undecided": ["(game) Psyonic? You're the one on the feed. Don't stand so close.", "(game) My frames keep showing me a door that isn't there. Is that normal now?",
			"(game) They closed the shuttle again. Walk, they said. Walk where?"],
		"company_man": ["You're one of theirs. I can see the badge from here. Tell them the lamps are still out on Fargona.", "Company man. My cousin had a wellness flag too. Nobody's seen him since the tower sent a car."],
		"investigator": ["You're the one asking questions. Careful who hears you ask them.", "They say there's an investigator going round who doesn't file everything. Is that you? Good."],
		"sleeper": ["You look tired. Have you been dreaming? You hum it when you walk, you know.", "I saw you bow on the Spine. Don't be ashamed. Everyone bows eventually."],
		"faith": ["(game) We go to the vigil after work now. It's nice. Nobody looks at their phone.", "(game) Gather, sleeper. That's what it says when you wake up. Doesn't yours?",
			"(game) Don't stand there. You're blocking the tower."],
	},
	# each district's landmark: [name on the sign, what Carl thinks looking at it]
	"landmarks": {
		"lamplight": ["DUFREDY'S BUILDING", "(game) The grey block with the posters. His flat was up there, and the stain on the carpet, and the eyes. Somebody had put flowers on the step and somebody else had put sticks in them."],
		"canal_walk": ["VOLTX FILTRATION UNIT 7", "(game) The sand filtration unit by the canal, humming. The walk round it was swept. The sand was not where it had been swept to."],
		"spine": ["PSYONIC TOWER", "(game) The tower. A jade-and-silver nail driven into the city's spine. From the foot of it you couldn't see the top, only the drones going up into the cloud like bees to a hive."],
		"heights": ["HEIGHTS PRIMARY", "(game) Mira's school. Through the windows, the tablets on every desk, every screen the same game."],
		"hill_road": ["SALTECH", "(game) SalTech's gate, white and green and humming. Behind it, Room 108, and a man with gauze where his eyes had been."],
		"zeta_park": ["ZETA & PARK", "(game) Fourteen camera poles on the block. Lynx's building at the end, red, with the red eye on the wall beside it."],
		"harmony_green": ["HARMONY GREEN", "(game) The park. A Tranquility Zone, the sign said. The retaining wall, the benches, and past them the encampment where Tyson keeps his books."],
		"southtown": ["SOUTHWEST STATION", "(game) Southwest Station, and behind it the overpass with the eye on its underside, big enough to read from the plant."],
		"fargona": ["FARGONA AVENUE", "(game) The screens on Fargona never go off now. Sixty-one faces, every one of them dead, every one of them still posting."],
		"rail_cut": ["RAIL CUT SUBSTATION", "(game) The substation, fenced, the glyphs on its doors in a hand I'd started to recognise. Past it, the Tunelet arch, chained."],
		"red_rock": ["RED ROCK PLAZA", "(game) Red Rock: the monolith screen, the casino, the subway stairs. And under the red lanterns, Lushon's."],
		"cognizo": ["COGNIZO", "(game) Cognizo's tower, black and gold, forty-seven floors, modest by this city's standards and proud of it."],
		"park_ave": ["PARK AVENUE", "(game) Park Avenue, a through-street, the kind you walk without looking up. Everyone was looking up."],
		"restricted_road": ["CONTAINMENT ZONE 1", "(game) The checkpoint, and the sand past it."],
	},
	"phone": "[color=#7fe6b0]Psyon:[/color] %s, %s. Faith here: %d. Tab for the map.\n\n",
	"phone_fork": "[color=#ff4fd8]%s. We are here too. We are everywhere you go.[/color]\n\n",
}

## Geometry per district: the street's two sides, building heights, rain at
## night, where the tower stands from here.
const CFG := {
	"lamplight": {"west": "blocks", "east": "blocks", "h": [12.0, 34.0], "tower": Vector3(420, 0, -620)},
	"canal_walk": {"west": "canal", "east": "blocks", "h": [10.0, 26.0], "tower": Vector3(380, 0, -760)},
	"spine": {"west": "blocks", "east": "blocks", "h": [30.0, 90.0], "tower": Vector3(0, 0, -300)},
	"heights": {"west": "blocks", "east": "blocks", "h": [10.0, 22.0], "tower": Vector3(-120, 0, 520)},
	"hill_road": {"west": "blocks", "east": "blocks", "h": [12.0, 30.0], "tower": Vector3(500, 0, 480)},
	"zeta_park": {"west": "blocks", "east": "blocks", "h": [20.0, 60.0], "tower": Vector3(-420, 0, -200)},
	"harmony_green": {"west": "park", "east": "blocks", "h": [12.0, 30.0], "tower": Vector3(600, 0, -500)},
	"southtown": {"west": "shanty", "east": "blocks", "h": [8.0, 22.0], "tower": Vector3(-200, 0, -800)},
	"fargona": {"west": "blocks", "east": "blocks", "h": [16.0, 44.0], "tower": Vector3(-500, 0, 300)},
	"rail_cut": {"west": "shanty", "east": "blocks", "h": [8.0, 20.0], "tower": Vector3(-600, 0, -600)},
	"red_rock": {"west": "blocks", "east": "blocks", "h": [18.0, 50.0], "tower": Vector3(-700, 0, -500)},
	"cognizo": {"west": "blocks", "east": "blocks", "h": [24.0, 70.0], "tower": Vector3(-650, 0, 0)},
	"park_ave": {"west": "blocks", "east": "blocks", "h": [20.0, 56.0], "tower": Vector3(-520, 0, -100)},
	"restricted_road": {"west": "shanty", "east": "shanty", "h": [6.0, 10.0], "tower": Vector3(-300, 0, -900)},
}

var did := "spine"
var cfg: Dictionary
var faith := 0
var night := true
var _concrete: StandardMaterial3D
var _metal: StandardMaterial3D
var walkers: Array = []
var kneelers: Array = []
var talkers: Array = []
var _eye_sprite: Sprite3D
var _eye_light: OmniLight3D
var _incident_id := ""
var _beat: Dictionary = {}
var _door_marker: Node3D
var _lines_i := 0
## The night layer: the eyeless, the follower, the crowd, the preacher, the double (Night.gd).
var night_layer: Node3D


func build(m: Node) -> void:
	main = m
	did = str(main.city.district)
	if not CFG.has(did):
		did = "spine"
	cfg = CFG[did]
	rng.seed = absi(hash(did)) % 100000
	faith = main.city.faith_of(did)
	night = main.city.is_night()
	kit_day = not night
	rain = night and rng.randf() < 0.45
	spawn = Vector3(3.0, 0.1, 56.0)
	spawn_yaw = 0.0
	step_db = -17.0
	card = main.city.place_card()
	_concrete = mat(Color(0.14, 0.14, 0.15), 0.9)
	_metal = mat(Color(0.25, 0.26, 0.28), 0.45, 0.6)
	_ground()
	_sides()
	_streetlights()
	_overhead()
	_far_tower()
	_landmark()
	_kiosk()
	_ends()
	_faith_dressing()
	_incident()
	_beat_door()
	_people()
	main.city.standing.street_build(self)     # PIP / deregistered: the lift, the encampment's way in
	# the hack and stealth layer: devices, the scene hold at tier 2, addicts (Encounters.gd)
	EncountersS.street(self)
	# the side cases: their places, props and people, gated on each case's step (SideCases.gd)
	main.city.cases.dress(self)
	# the night layer and the confrontations (Night.gd, Confront.gd)
	var nl := NightS.new()
	add_child(nl)
	nl.setup(self)
	night_layer = nl
	_batch(self, 30.0)
	var traffic: Node = TrafficS.new()
	traffic.lanes = [[-4.0, 6.0, 1.0], [-1.5, 9.5, 1.0], [1.5, 9.5, -1.0], [4.0, 6.0, -1.0], [0.0, 15.0, 1.0]]
	traffic.s_min = N - 10.0
	traffic.s_max = S + 10.0
	traffic.count = 9 if faith < 3 else 4
	traffic.tower_top = cfg["tower"] + Vector3(0, 420, 0)
	traffic.drone_box = AABB(Vector3(-120, 25, -160), Vector3(240, 70, 240))
	traffic.drone_count = 90
	add_child(traffic)
	traffic.setup(m, self)


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	if night:
		# the default night (Main._reset_env), a little more neon in the haze
		env.fog_density = 0.005 if rain else 0.0038
		if faith >= 2:
			env.fog_light_color = Color(0.2, 0.08, 0.1)
		return
	var psm := ProceduralSkyMaterial.new()
	var h := int(main.hour) % 24
	var dusk := h >= 17 or h < 8
	psm.sky_top_color = Color(0.3, 0.38, 0.52) if not dusk else Color(0.16, 0.16, 0.3)
	psm.sky_horizon_color = Color(0.85, 0.7, 0.55) if not dusk else Color(0.95, 0.5, 0.3)
	psm.ground_horizon_color = psm.sky_horizon_color
	psm.ground_bottom_color = Color(0.25, 0.22, 0.2)
	psm.sun_angle_max = 25.0
	env.sky.sky_material = psm
	env.glow_bloom = 0.0
	env.glow_intensity = 0.6
	env.glow_hdr_threshold = 1.2
	env.ambient_light_color = Color(0.62, 0.62, 0.6)
	env.ambient_light_energy = 0.45
	env.fog_light_color = Color(0.75, 0.62, 0.5) if not dusk else Color(0.7, 0.42, 0.3)
	env.fog_density = 0.0028
	env.fog_sky_affect = 0.15
	env.tonemap_exposure = 1.0
	sun.light_color = Color(1.0, 0.9, 0.75) if not dusk else Color(1.0, 0.62, 0.4)
	sun.light_energy = 1.1 if not dusk else 0.7
	sun.sky_mode = DirectionalLight3D.SKY_MODE_LIGHT_AND_SKY
	sun.rotation = Vector3(deg_to_rad(-55 if not dusk else -18), deg_to_rad(210), 0)
	sun.directional_shadow_max_distance = 80.0


func ambience() -> void:
	main.loop("wind", -18.0)
	main.loop("murmur", -10.0, Vector3(0, 1.5, 0), 6.0, 60.0)
	if rain:
		main.loop("rain", -10.0)
	if did == "spine":
		main.loop("hum", -12.0, Vector3(0, 6, -130), 12.0, 140.0)
	if faith >= 2:
		main.loop("chant", -14.0, Vector3(-9.0, 1.2, -20.0), 4.0, 40.0)
	if _incident_id != "":
		main.loop("static", -10.0, Vector3(-10.5, 1.2, 14.0), 2.0, 18.0)


func intro() -> void:
	main.update_hud()


# ------------------------------------------------------------------ the street

func _ground() -> void:
	solid_box(Vector3(200, 2, 260), Vector3(0, -1.0, (N + S) / 2.0))
	var asphalt := pbr("asphalt", Vector3(1, 1, 1) / 4.0, true, Color(0.7, 0.7, 0.72), 0.35 if night else 0.9)
	var paving := pbr("paving", Vector3(1, 1, 1) / 2.5, true, Color(0.75, 0.75, 0.75), 0.6 if night else 1.0)
	var curb := mat(Color(0.22, 0.21, 0.2), 0.8)
	var line := mat(Color(0.55, 0.52, 0.42), 0.6)
	var z := S
	while z > N:
		var cz := z - 10.0
		var pm := PlaneMesh.new()
		pm.size = Vector2(14, 20)
		mesh(pm, Vector3(0, 0.0, cz), asphalt)
		for side: float in [-1.0, 1.0]:
			var sw := PlaneMesh.new()
			sw.size = Vector2(6, 20)
			mesh(sw, Vector3(side * 10.0, 0.12, cz), paving)
			box(Vector3(0.3, 0.14, 20), Vector3(side * 7.1, 0.07, cz), curb)
		box(Vector3(0.14, 0.01, 4.0), Vector3(0, 0.01, cz - 4.0), line)
		z -= 20.0
	# the far ground out past the blocks
	var far := PlaneMesh.new()
	far.size = Vector2(1600, 1600)
	mesh(far, Vector3(0, -0.05, 0), mat(Color(0.06, 0.055, 0.05) if night else Color(0.32, 0.3, 0.27)))


func _sides() -> void:
	for side: float in [-1.0, 1.0]:
		var kind: String = cfg["west"] if side < 0.0 else cfg["east"]
		match kind:
			"canal":
				_canal(side)
			"park":
				_park(side)
			"shanty":
				_shanty(side)
			_:
				_blocks(side)


func _blocks(side: float) -> void:
	var h0: float = cfg["h"][0]
	var h1: float = cfg["h"][1]
	var z := S - 2.0
	while z > N + 14.0:
		var w := rng.randf_range(12.0, 24.0)
		w = minf(w, z - (N + 12.0))
		if w < 7.0:
			break
		var h := rng.randf_range(h0, h1)
		if rng.randf() < 0.15:
			h *= 1.6
		var rot := PI / 2.0 if side < 0.0 else -PI / 2.0
		cyber_block(Vector3(side * FRONT, 0, z - w / 2.0), rot, w, h, rng.randf_range(14.0, 24.0))
		z -= w
		if rng.randf() < 0.28:
			z -= 3.5  # an alley, dark
	# the backs behind the alleys
	box(Vector3(2, 40, S - N), Vector3(side * (FRONT + 26.0), 20, (N + S) / 2.0), _concrete, true)


func _canal(side: float) -> void:
	# Canal Walk: the water where the west blocks would be, a rail, the far bank's blocks
	var water := newmat(Color(0.05, 0.09, 0.1) if night else Color(0.18, 0.26, 0.26), 0.05, 0.3)
	var pm := PlaneMesh.new()
	pm.size = Vector2(16, S - N)
	mesh(pm, Vector3(side * 21.0, -0.9, (N + S) / 2.0), water)
	box(Vector3(0.6, 1.1, S - N), Vector3(side * 13.2, -0.4, (N + S) / 2.0), _concrete)
	solid_box(Vector3(0.3, 2.0, S - N), Vector3(side * 13.3, 1.0, (N + S) / 2.0))
	var rail := mat(Color(0.3, 0.32, 0.3), 0.4, 0.8)
	box(Vector3(0.06, 0.06, S - N), Vector3(side * 13.0, 1.05, (N + S) / 2.0), rail)
	var z := S
	while z > N:
		box(Vector3(0.06, 1.05, 0.06), Vector3(side * 13.0, 0.55, z), rail)
		z -= 3.0
	# sand on the walk, laid in rings at Faith 1+
	var sand := mat(Color(0.72, 0.62, 0.45), 1.0)
	for k in 5:
		floor_quad(Vector2(rng.randf_range(2.0, 4.0), rng.randf_range(2.0, 4.0)), Vector3(side * 10.5, 0.14, 40.0 - k * 26.0), rng.randf() * TAU, sand)
	var z2 := S
	while z2 > N:
		var w := rng.randf_range(14.0, 22.0)
		cyber_block(Vector3(side * 29.5, -1.0, z2 - w / 2.0), PI / 2.0 if side < 0.0 else -PI / 2.0, w, rng.randf_range(14.0, 30.0), 12.0, false, 1)
		z2 -= w + 2.0


func _park(side: float) -> void:
	# Harmony Green: grass, trees, benches, the retaining wall at the back
	var grass := pbr("grass", Vector3(1, 1, 1) / 3.0, true, Color(0.8, 0.85, 0.75) if not night else Color(0.4, 0.45, 0.4))
	var pm := PlaneMesh.new()
	pm.size = Vector2(40, S - N)
	mesh(pm, Vector3(side * 33.0, 0.11, (N + S) / 2.0), grass)
	var bark := pbr("bark", Vector3(1, 1, 1) / 1.5, true)
	var leaves := [mat(Color(0.2, 0.32, 0.18)), mat(Color(0.25, 0.36, 0.2))]
	var z := S - 8.0
	while z > N + 10.0:
		tree(Vector3(side * rng.randf_range(16.0, 40.0), 0.1, z), rng.randf_range(4.5, 7.5), bark, leaves)
		z -= rng.randf_range(10.0, 18.0)
	var wood := pbr("woodfloor", Vector3(1, 1, 1) / 1.0, true, Color(0.55, 0.42, 0.3))
	for k in 5:
		var bz := 44.0 - k * 30.0
		box(Vector3(0.5, 0.06, 2.0), Vector3(side * 14.5, 0.5, bz), wood, true)
		box(Vector3(0.06, 0.5, 2.0), Vector3(side * 14.8, 0.78, bz), wood)
	box(Vector3(1.2, 3.2, S - N), Vector3(side * 54.0, 1.6, (N + S) / 2.0), pbr("concrete", Vector3(1, 1, 1) / 2.0, true), true)
	solid_box(Vector3(0.4, 3.0, S - N), Vector3(side * 13.6, 1.5, (N + S) / 2.0))
	# the encampment past the wall
	var canvas := [mat(Color(0.3, 0.25, 0.18)), mat(Color(0.2, 0.24, 0.2)), mat(Color(0.28, 0.2, 0.2))]
	for k in 6:
		var t := cyl(0.0, 1.6, 1.6, Vector3(side * 60.0, 0.8, 30.0 - k * 14.0), canvas[k % 3], 3)
		t.rotation.y = PI / 6.0


func _shanty(side: float) -> void:
	# tin and tarp, two storeys at most, a few lit doorways
	var tin := [pbr("rust", Vector3(1, 1, 1) / 2.0, true), mat(Color(0.3, 0.3, 0.32), 0.7, 0.5), mat(Color(0.22, 0.2, 0.16), 0.9)]
	var z := S - 2.0
	while z > N + 12.0:
		var w := rng.randf_range(4.0, 8.0)
		var h := rng.randf_range(2.6, 6.0)
		var d := rng.randf_range(4.0, 8.0)
		var x := side * (FRONT + d / 2.0 + rng.randf_range(0.0, 1.5))
		box(Vector3(d, h, w), Vector3(x, h / 2.0, z - w / 2.0), tin[rng.randi() % tin.size()], true)
		box(Vector3(d + 0.6, 0.1, w + 0.5), Vector3(x, h + 0.05, z - w / 2.0), tin[1]).rotation.z = side * 0.08
		if rng.randf() < 0.4:
			var c := Color(1.0, 0.6, 0.25)
			quad(Vector2(0.9, 1.8), Vector3(side * (FRONT - 0.02), 0.95, z - w / 2.0), PI / 2.0 if side < 0.0 else -PI / 2.0, glow(c, 1.2, true))
			if rng.randf() < 0.5:
				light(Vector3(side * (FRONT - 1.0), 1.6, z - w / 2.0), c, 0.9, 6.0)
		z -= w + rng.randf_range(0.3, 2.0)
	# the tall blocks behind, over the roofs
	var z2 := S
	while z2 > N:
		var w2 := rng.randf_range(16.0, 26.0)
		cyber_block(Vector3(side * 34.0, 0, z2 - w2 / 2.0), PI / 2.0 if side < 0.0 else -PI / 2.0, w2, rng.randf_range(18.0, 40.0), 14.0, true, 1)
		z2 -= w2 + 4.0


func _streetlights() -> void:
	var pole := mat(Color(0.1, 0.1, 0.11), 0.5, 0.7)
	var i := 0
	var z := S - 6.0
	while z > N + 4.0:
		for side: float in [-1.0, 1.0]:
			var x := side * 7.6
			cyl(0.09, 0.12, 7.2, Vector3(x, 3.6, z), pole, 8)
			box(Vector3(1.8, 0.12, 0.12), Vector3(x - side * 0.9, 7.1, z), pole)
			var sodium := (i % 3) != 1
			var c := Color(1.0, 0.62, 0.32) if sodium else Color(0.7, 0.85, 1.0)
			box(Vector3(0.7, 0.12, 0.35), Vector3(x - side * 1.6, 7.0, z), glow(c, 3.0 if night else 0.6, true))
			if night:
				var o := light(Vector3(x - side * 1.6, 6.7, z), c, 2.2, 16.0)
				if rng.randf() < 0.15:
					flickers.append(o)
			i += 1
		z -= 26.0


## Cables, a sky bridge, hanging holograms, street props: the Spine's density.
func _overhead() -> void:
	for k in 7:
		var z := S - 10.0 - k * 24.0 + rng.randf_range(-4.0, 4.0)
		cable(Vector3(-FRONT, rng.randf_range(9.0, 14.0), z), Vector3(FRONT, rng.randf_range(9.0, 14.0), z + rng.randf_range(-6.0, 6.0)), rng.randf_range(0.8, 2.0))
	if cfg["west"] == "blocks" and cfg["east"] == "blocks":
		var bz := rng.randf_range(-60.0, -20.0)
		skybridge(Vector3(-FRONT - 1.0, 22.0, bz), Vector3(FRONT + 1.0, 22.0, bz + 2.0), 3.5)
	for k in 3:
		var ad: Array = KIT_ADS[rng.randi() % KIT_ADS.size()]
		var side := -1.0 if k % 2 == 0 else 1.0
		kit_holo(Vector3(side * 9.5, rng.randf_range(12.0, 22.0), 20.0 - k * 45.0), side * -0.35 + (PI / 2.0 if side < 0.0 else -PI / 2.0), ad[0], ad[1], KIT_NEON[rng.randi() % KIT_NEON.size()], 10.0)
	var props := ["fire_hydrant", "metal_trash_can", "utility_box_01", "vending_kiosk", "atm", "power_box_01", "cardboard_box_01", "plastic_crate_03", "concrete_road_barrier"]
	for k in 10:
		var side := -1.0 if rng.randf() < 0.5 else 1.0
		var z := rng.randf_range(N + 20.0, S - 12.0)
		if absf(z - 30.0) < 4.0 or absf(z - 14.0) < 5.0:
			continue
		prop(props[rng.randi() % props.size()], Vector3(side * rng.randf_range(11.0, 12.2), 0.12, z), (PI / 2.0 if side < 0.0 else -PI / 2.0), 1.0, true)
	for k in 2:
		var dr := prop("police_drone" if k == 0 else "delivery_drone", Vector3(rng.randf_range(-5.0, 5.0), rng.randf_range(7.0, 11.0), rng.randf_range(-60.0, 30.0)), rng.randf() * TAU, 1.0, false)
		if dr:
			no_batch.append(dr)


## The tower, wherever it stands from here: it is in every view of the city.
func _far_tower() -> void:
	var p: Vector3 = cfg["tower"]
	var jade := mat(Color(0.16, 0.42, 0.34), 0.28, 0.75)
	var near := p.length() < 400.0
	var h := 420.0
	cyl(22.0 if near else 18.0, 34.0 if near else 26.0, h, p + Vector3(0, h / 2.0, 0), jade, 24)
	var ring := TorusMesh.new()
	ring.inner_radius = 40.0
	ring.outer_radius = 62.0
	ring.rings = 32
	ring.ring_segments = 10
	mesh(ring, p + Vector3(0, h * 0.82, 0), mat(Color(0.75, 0.78, 0.8), 0.25, 0.8))
	box(Vector3(3, 3, 3), p + Vector3(0, h + 4.0, 0), glow(Color(1, 0.05, 0.05), 5.0))
	var band := glow(Color(0.3, 1.0, 0.7), 2.4 if night else 1.0)
	for k in 6:
		cyl(23.5 if near else 19.5, 23.5 if near else 19.5, 1.2, p + Vector3(0, 60.0 + k * 55.0, 0), band, 24)


# ------------------------------------------------------------------ the landmark at the north end

func _landmark() -> void:
	var nm: Array = LINES["landmarks"][did]
	var lz := N + 8.0
	var k := _kit_mats()
	# the end of the street: a block across it, dressed, the landmark in front
	cyber_block(Vector3(0, 0, N - 2.0), 0.0, 2.0 * FRONT + 6.0, cfg["h"][1] * 0.8, 20.0)
	var sign_c: Color = KIT_NEON[absi(hash(did)) % KIT_NEON.size()]
	neon_text(str(nm[0]), Vector3(0, 6.2, N - 1.6), 0.0, 1.3, sign_c, -1.0, self)
	interactable("landmark", LINES["prompts"]["landmark"], Vector3(0, 2.0, lz - 2.0), Vector3(10.0, 4.0, 1.0), str(nm[0]), false)
	match did:
		"lamplight":
			var grey := mat(Color(0.38, 0.38, 0.36), 0.9)
			box(Vector3(12, 16, 0.4), Vector3(-6, 8, lz - 3.0), grey, true)
			for i in 6:
				quad(Vector2(0.6, 0.85), Vector3(-9.5 + i * 1.2, 1.6, lz - 2.78), 0.0, mat(Color(rng.randf_range(0.6, 0.9), 0.85, 0.75), 0.9))
			box(Vector3(1.2, 2.2, 0.1), Vector3(-6, 1.1, lz - 2.75), mat(Color(0.15, 0.12, 0.1), 0.6))
		"canal_walk", "rail_cut":
			box(Vector3(5, 3.5, 3), Vector3(-9.0, 1.75, lz), mat(Color(0.35, 0.36, 0.33), 0.7, 0.4), true)
			for i in 3:
				cyl(0.25, 0.25, 4.0, Vector3(-11.5 + i * 0.9, 2.0, lz + 1.6), k["rust"], 10)
			prop("fuse_panel", Vector3(-6.0, 0.12, lz + 1.4), 0.0, 1.0, true)
			prop("power_box_01", Vector3(6.5, 0.12, lz + 1.0), 0.0, 1.0, true)
			if did == "rail_cut":
				box(Vector3(8, 6, 1), Vector3(7.0, 3.0, lz - 2.5), _concrete, true)
				box(Vector3(5, 4.4, 0.2), Vector3(7.0, 2.2, lz - 1.9), mat(Color(0.02, 0.02, 0.02)))
		"spine":
			# the tower's base at the end of the boulevard: the HQ doors, the residential entrance
			var jade := mat(Color(0.16, 0.42, 0.34), 0.28, 0.75)
			box(Vector3(22, 8, 2), Vector3(0, 4, lz - 2.0), jade, true)
			box(Vector3(6, 4, 0.2), Vector3(-4.5, 2, lz - 0.9), glow(Color(0.55, 1.0, 0.8), 1.2, true))
			box(Vector3(4, 4, 0.2), Vector3(6.0, 2, lz - 0.9), glow(Color(0.9, 0.85, 0.7), 1.0, true))
			neon_text("PSYONIC  -  INTEGRATIONS", Vector3(-4.5, 4.6, lz - 0.85), 0.0, 0.5, Color(0.5, 1.0, 0.8), -1.0, self)
			neon_text("RESIDENTIAL", Vector3(6.0, 4.6, lz - 0.85), 0.0, 0.5, Color(1.0, 0.92, 0.75), -1.0, self)
			var hb := interactable("home_lift", LINES["prompts"]["home"], Vector3(6.0, 1.5, lz - 0.4), Vector3(4.0, 3.0, 1.0), LINES["scan"]["home"], false)
			hb.set_meta("exit", true)
			prop("security_camera_01", Vector3(1.0, 6.0, lz - 0.8), PI, 1.0, false)
		"heights":
			var brick := mat(Color(0.5, 0.3, 0.24), 0.9)
			box(Vector3(18, 9, 0.4), Vector3(0, 4.5, lz - 3.0), brick, true)
			for i in 6:
				var wq := quad(Vector2(1.6, 1.2), Vector3(-7.0 + i * 2.8, 5.5, lz - 2.78), 0.0, glow(Color(0.5, 0.75, 1.0) if faith >= 1 else Color(0.9, 0.85, 0.7), 1.0, true))
				if faith >= 1 and i % 2 == 0:
					flickers.append(wq)
					no_batch.append(wq)  # a flicker the batch would free
		"hill_road":
			box(Vector3(16, 10, 1), Vector3(-3.0, 5, lz - 3.0), mat(Color(0.88, 0.9, 0.88), 0.5), true)
			box(Vector3(5, 4, 0.2), Vector3(-3.0, 2, lz - 2.4), glow(Color(0.5, 1.0, 0.6), 1.0, true))
			box(Vector3(1.6, 0.5, 0.1), Vector3(-3.0, 7.5, lz - 2.4), glow(Color(0.3, 1.0, 0.4), 2.0, true))
			box(Vector3(0.5, 1.6, 0.1), Vector3(-3.0, 7.5, lz - 2.4), glow(Color(0.3, 1.0, 0.4), 2.0, true))
			# the FreudBot booth on the corner
			box(Vector3(1.4, 2.4, 1.4), Vector3(8.0, 1.2, lz + 2.0), mat(Color(0.85, 0.86, 0.9), 0.3, 0.2), true)
			quad(Vector2(0.9, 0.7), Vector3(8.0, 1.6, lz + 2.72), 0.0, glow(Color(0.6, 0.85, 1.0), 1.2, true))
		"zeta_park":
			var red := mat(Color(0.45, 0.08, 0.08), 0.7)
			box(Vector3(12, 24, 1), Vector3(6.0, 12, lz - 3.0), red, true)
			var eye := Sprite3D.new()
			eye.texture = _glyph_tex
			eye.pixel_size = 0.03
			eye.modulate = Color(1.0, 0.1, 0.08)
			eye.shaded = false
			eye.position = Vector3(-1.0, 8.0, lz - 2.4)
			add_child(eye)
			for i in 5:
				var pz := S - 20.0 - i * 30.0
				cyl(0.08, 0.1, 6.0, Vector3(-8.0, 3.0, pz), _metal, 6)
				prop("security_camera_01", Vector3(-7.6, 5.6, pz), -PI / 2.0, 1.0, false)
		"harmony_green":
			box(Vector3(2.0, 1.2, 0.3), Vector3(-9.0, 0.6, lz + 4.0), _concrete, true)
			neon_text("TRANQUILITY ZONE", Vector3(-9.0, 1.6, lz + 4.2), 0.0, 0.3, Color(0.5, 1.0, 0.7), -1.0, self)
		"southtown":
			box(Vector3(20, 7, 2), Vector3(0, 3.5, lz - 2.0), mat(Color(0.32, 0.28, 0.24), 0.9), true)
			box(Vector3(8, 4, 0.2), Vector3(0, 2, lz - 0.9), glow(Color(1.0, 0.8, 0.5), 0.9, true))
			# the overpass across the sky, the eye on its underside
			box(Vector3(60, 3, 10), Vector3(0, 16, lz + 18.0), _concrete)
			for x: float in [-20.0, 20.0]:
				box(Vector3(2, 16, 3), Vector3(x, 8, lz + 18.0), _concrete, true)
			var ov := Sprite3D.new()
			ov.texture = _glyph_tex
			ov.pixel_size = 0.07
			ov.modulate = Color(0.9, 0.85, 0.8)
			ov.shaded = false
			ov.rotation.x = PI / 2.0
			ov.position = Vector3(0, 14.45, lz + 18.0)
			add_child(ov)
		"fargona":
			for i in 6:
				var sx := -10.0 + i * 4.0
				box(Vector3(3.4, 2.2, 0.2), Vector3(sx, 4.0 + (i % 2) * 2.6, lz - 2.5), k["dark"], true)
				quad(Vector2(3.2, 2.0), Vector3(sx, 4.0 + (i % 2) * 2.6, lz - 2.38), 0.0, glow(Color(0.6, 0.65, 0.8), 1.0, true))
		"red_rock":
			# the monolith screen, Lushon's red lanterns, the casino, the subway stairs
			box(Vector3(5, 18, 1.5), Vector3(-7.0, 9, lz - 1.0), k["dark"], true)
			quad(Vector2(4.4, 16), Vector3(-7.0, 9, lz - 0.24), 0.0, glow(Color(0.9, 0.25, 0.2), 1.3, true))
			var lantern := glow(Color(1.0, 0.15, 0.08), 2.5, true)
			for i in 5:
				sphere(0.35, Vector3(3.0 + i * 1.5, 3.4, lz - 0.3), lantern, 8)
			light(Vector3(6.0, 3.0, lz + 1.0), Color(1.0, 0.2, 0.1), 1.6, 9.0)
			neon_text("LUSHON", Vector3(6.0, 4.6, lz - 0.85), 0.0, 0.8, Color(1.0, 0.3, 0.2), -1.0, self)
			box(Vector3(4.0, 2.6, 0.2), Vector3(6.0, 1.3, lz - 0.9), mat(Color(0.3, 0.12, 0.08), 0.5))
			box(Vector3(4, 0.1, 6), Vector3(-10.0, 0.13, lz + 8.0), mat(Color(0.01, 0.01, 0.01)))
			neon_text("SUBWAY", Vector3(-10.0, 2.6, lz + 5.0), 0.0, 0.5, Color(0.4, 0.8, 1.0), -1.0, self)
		"cognizo":
			var black := mat(Color(0.04, 0.04, 0.05), 0.2, 0.6)
			var gold := glow(Color(0.95, 0.75, 0.3), 1.6, true)
			box(Vector3(26, 150, 26), Vector3(0, 75, lz - 16.0), black, true)
			for i in 12:
				box(Vector3(26.2, 0.3, 26.2), Vector3(0, 8.0 + i * 12.0, lz - 16.0), gold)
			neon_text("COGNIZO", Vector3(0, 10.0, lz - 2.85), 0.0, 1.6, Color(0.95, 0.75, 0.3), -1.0, self)
			box(Vector3(6, 4, 0.2), Vector3(0, 2, lz - 2.9), glow(Color(0.95, 0.85, 0.6), 0.8, true))
		"park_ave":
			var bark := pbr("bark", Vector3(1, 1, 1) / 1.5, true)
			var leaves := [mat(Color(0.2, 0.32, 0.18))]
			for i in 4:
				tree(Vector3(-10.5, 0.12, 40.0 - i * 40.0), 5.0, bark, leaves)
				tree(Vector3(10.5, 0.12, 20.0 - i * 40.0), 5.0, bark, leaves)


# ------------------------------------------------------------------ the terminal, the ends

func _kiosk() -> void:
	var kp := Vector3(11.3, 1.0, 30.0)
	box(Vector3(0.6, 2.0, 1.0), kp, _metal, true)
	var scr_c := Color(1.0, 0.31, 0.85) if main.connection >= 25.0 else Color(0.4, 1.0, 0.6)
	var ks := quad(Vector2(0.8, 0.9), kp + Vector3(-0.31, 0.3, 0), -PI / 2.0, glow(scr_c, 1.2, true))
	no_batch.append(ks)
	light(kp + Vector3(-1.0, 0.6, 0), scr_c, 0.8, 4.0)
	neon_text("CITY TERMINAL", kp + Vector3(-0.32, 1.15, 0), -PI / 2.0, 0.12, scr_c, -1.0, self)
	interactable("kiosk", LINES["prompts"]["kiosk"], kp, Vector3(0.7, 2.0, 1.1), LINES["scan"]["kiosk"] % (absi(hash(did)) % 90 + 10), false)


func _ends() -> void:
	for z: float in [S + 2.0, N + 3.0]:
		var e := interactable("end", LINES["prompts"]["end"], Vector3(0, 1.5, z), Vector3(26.0, 3.0, 1.0), "", true)
		e.set_meta("exit", true)
	# barriers at the south end
	for x in range(-6, 7, 3):
		prop("concrete_road_barrier", Vector3(x, 0.0, S + 1.0), 0.0, 1.0, false)


# ------------------------------------------------------------------ Faith on the street

func _faith_dressing() -> void:
	if faith <= 0:
		return
	var stick_m := mat(Color(0.42, 0.33, 0.22), 0.9)
	var paint := Color(0.75, 0.08, 0.06)
	# 1: the eye painted on the walls, sticks in rings on the pavement
	for k in 3 + faith * 2:
		var side := -1.0 if k % 2 == 0 else 1.0
		var z := S - 15.0 - k * 22.0 + rng.randf_range(-5.0, 5.0)
		var s := Sprite3D.new()
		s.texture = _glyph_tex
		s.pixel_size = rng.randf_range(0.008, 0.016)
		s.modulate = paint
		s.position = Vector3(side * (FRONT - 0.08), rng.randf_range(1.8, 3.4), z)
		s.rotation.y = PI / 2.0 if side < 0.0 else -PI / 2.0
		add_child(s)
		if k == 0:
			interactable("eye", LINES["prompts"]["eye"], s.position, Vector3(0.4, 1.6, 1.6), "", false)
	for k in faith + 1:
		var c := Vector3(rng.randf_range(-11.0, -8.5) if k % 2 == 0 else rng.randf_range(8.5, 10.5), 0.14, 44.0 - k * 34.0)
		for ring: float in [0.55, 1.0]:
			var n := 10 if ring < 0.6 else 16
			for i in n:
				var a := TAU * i / n
				var st := box(Vector3(0.03, 0.03, 0.34), c + Vector3(cos(a) * ring, 0.0, sin(a) * ring), stick_m)
				st.rotation.y = -a
		if k == 0:
			interactable("ring", LINES["prompts"]["ring"], c + Vector3(0, 0.3, 0), Vector3(2.2, 0.6, 2.2), "", false)
	# 2: a vigil: candles on the kerb, people kneeling round them
	if faith >= 2:
		var vc := Vector3(-9.0, 0.14, -20.0)
		var wax := mat(Color(0.92, 0.88, 0.78), 0.8)
		var flame := glow(Color(1.0, 0.65, 0.25), 3.0)
		for i in 18:
			var a := TAU * i / 18.0
			var p := vc + Vector3(cos(a) * 1.6, 0.0, sin(a) * 1.6)
			cyl(0.035, 0.035, 0.16, p + Vector3(0, 0.08, 0), wax, 6)
			box(Vector3(0.02, 0.04, 0.02), p + Vector3(0, 0.19, 0), flame)
		light(vc + Vector3(0, 0.5, 0), Color(1.0, 0.6, 0.3), 1.6, 7.0, false)
		interactable("vigil", LINES["prompts"]["vigil"], vc + Vector3(0, 0.3, 0), Vector3(3.6, 0.6, 3.6), "", false)
		for i in 4:
			var a := TAU * (i + 0.5) / 4.0
			_kneeler(vc + Vector3(cos(a) * 2.4, -0.02, sin(a) * 2.4))
	# 3: the street is a congregation, facing the tower
	if faith >= 3:
		for i in 18:
			_kneeler(Vector3(-5.0 + (i % 6) * 2.0, 0.0, -45.0 - int(i / 6) * 2.2))
		interactable("kneel", LINES["prompts"]["kneel"], Vector3(0, 0.8, -47.0), Vector3(12.0, 1.6, 7.0), LINES["scan"]["kneel"], false)


func _kneeler(p: Vector3) -> void:
	var f := figure(Crowd_COATS[rng.randi() % Crowd_COATS.size()], Crowd_SKINS[rng.randi() % Crowd_SKINS.size()], {"visor": true, "arms": true, "knees": true})
	f.position = p - Vector3(0, 0.45, 0)
	add_child(f)
	Anim.crouch(f)
	var tp: Vector3 = cfg["tower"] + Vector3(0, 300, 0)
	var d := tp - p
	f.rotation.y = atan2(-d.x, -d.z)
	(f.get_meta("head") as Node3D).rotation.x = 0.6
	var v: MeshInstance3D = f.get_meta("visor")
	if v:
		v.material_override = glow(Color(1.0, 0.08, 0.05), 6.0)
	kneelers.append(f)


const Crowd_COATS := [Color(0.12, 0.12, 0.14), Color(0.2, 0.16, 0.12), Color(0.1, 0.14, 0.18),
	Color(0.25, 0.25, 0.27), Color(0.3, 0.1, 0.12), Color(0.08, 0.08, 0.08)]
const Crowd_SKINS := [Color(0.85, 0.66, 0.52), Color(0.6, 0.42, 0.3), Color(0.4, 0.28, 0.2),
	Color(0.92, 0.78, 0.66), Color(0.7, 0.52, 0.38)]


# ------------------------------------------------------------------ the incident, the beat's door

## An open incident in this district: its device on the west pavement, the
## red eye over it with the frames on.
func _incident() -> void:
	var open: Array = main.city.open_incidents_in(did)
	if open.is_empty():
		return
	var inc: Dictionary = open[0]
	_incident_id = str(inc["id"])
	var p := Vector3(-10.5, 0.12, 14.0)
	var dev := str(inc["device"])
	var k := _kit_mats()
	match dev:
		"freudbot":
			box(Vector3(1.4, 2.4, 1.4), p + Vector3(0, 1.2, 0), mat(Color(0.85, 0.86, 0.9), 0.3, 0.2), true)
			no_batch.append(quad(Vector2(0.9, 0.7), p + Vector3(0.72, 1.6, 0), PI / 2.0, glow(Color(1.0, 0.3, 0.3), 1.4, true)))
		"drone":
			for i in 6:
				var a := TAU * i / 6.0
				var dr := prop("delivery_drone", p + Vector3(cos(a) * 2.2, 3.4, sin(a) * 2.2), a, 1.0, false)
				if dr:
					no_batch.append(dr)
		"kiosk":
			box(Vector3(0.6, 2.0, 1.0), p + Vector3(0, 1.0, 0), _metal, true)
			no_batch.append(quad(Vector2(0.8, 0.9), p + Vector3(0.31, 1.3, 0), PI / 2.0, glow(Color(1.0, 0.2, 0.2), 1.3, true)))
		"shuttle":
			var bus := Car.build(self, Color(0.85, 0.86, 0.88), {"van": true})
			bus.position = Vector3(-5.0, 0.0, 14.0)
			add_child(bus)
			solid_box(Vector3(2.2, 2.4, 5.4), Vector3(-5.0, 1.2, 14.0))
			neon_text("PLEASE CONVENE", p + Vector3(5.6, 2.6, -2.8), PI / 2.0, 0.25, Color(1.0, 0.3, 0.2), -1.0, self)
		"tablet":
			box(Vector3(0.6, 0.45, 2.0), p + Vector3(0, 0.25, 0), pbr("woodfloor", Vector3.ONE, true), true)
			no_batch.append(quad(Vector2(0.24, 0.34), p + Vector3(0, 0.49, 0), 0.0, glow(Color(0.5, 0.85, 1.0), 1.6, true)))
		"substation":
			prop("power_box_01", p, PI / 2.0, 1.0, true)
			prop("fuse_panel", p + Vector3(0, 0, 1.4), PI / 2.0, 1.0, true)
		"camera":
			cyl(0.08, 0.1, 6.0, p + Vector3(0, 3.0, 0), _metal, 6)
			prop("security_camera_01", p + Vector3(0.4, 5.6, 0), PI / 2.0, 1.2, false)
		_:
			box(Vector3(0.4, 3.0, 4.0), p + Vector3(0, 2.6, 0), k["dark"], true)
			no_batch.append(quad(Vector2(3.6, 2.4), p + Vector3(0.21, 2.8, 0), PI / 2.0, glow(Color(1.0, 0.25, 0.25), 1.2, true)))
	_eye_sprite = Sprite3D.new()
	_eye_sprite.texture = _glyph_tex
	_eye_sprite.pixel_size = 0.012
	_eye_sprite.modulate = Color(1.0, 0.12, 0.08)
	_eye_sprite.shaded = false
	_eye_sprite.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	_eye_sprite.no_depth_test = true
	_eye_sprite.position = p + Vector3(0, 4.6, 0)
	_eye_sprite.visible = false
	add_child(_eye_sprite)
	_eye_light = light(p + Vector3(1.0, 2.0, 0), Color(1.0, 0.15, 0.1), 1.2, 8.0, false)
	var title := str(inc["title"])
	var body := interactable("incident", main.city.LINES["incident"]["prompt"] % title.to_lower(), p + Vector3(0.3, 1.4, 0), Vector3(2.0, 2.8, 3.0),
		main.city.incident_text(inc, "card"), false)
	body.set_meta("incident", _incident_id)


## The story beat open here, if the scheduler has one: its door, lit.
func _beat_door() -> void:
	_beat = main.city.beat_at(did)
	if _beat.is_empty():
		return
	var lz := N + 8.0
	var pos := Vector3(-4.5, 1.5, lz - 0.4)
	match did:
		"red_rock":
			pos = Vector3(6.0, 1.5, lz - 0.4)
		"hill_road":
			pos = Vector3(-3.0, 1.5, lz - 2.0)
		"zeta_park":
			pos = Vector3(6.0, 1.5, lz - 2.2)
		"southtown":
			pos = Vector3(0.0, 1.5, lz - 0.4)
	var b := interactable("beat_door", main.city.LINES["beats"][_beat["step"]][1], pos, Vector3(4.0, 3.0, 1.2), "", false)
	b.set_meta("exit", true)
	# a slow amber marker over the door; the chevron itself is Days 2-3 only (bible-1 HUD)
	_door_marker = Node3D.new()
	_door_marker.position = pos + Vector3(0, 3.2, 1.0)
	add_child(_door_marker)
	if int(main.day) <= 3:
		var cm := glow(Color(1.0, 0.75, 0.3), 3.0)
		for s: float in [-1.0, 1.0]:
			var bar := box(Vector3(0.12, 0.7, 0.12), Vector3(s * 0.22, 0, 0), cm, false, _door_marker)
			bar.rotation.z = s * 0.7
			no_batch.append(bar)
	light(pos + Vector3(0, 1.5, 2.0), Color(1.0, 0.7, 0.35), 1.4, 9.0, false)


# ------------------------------------------------------------------ people

func _people() -> void:
	var count := (14 if not night else 9) - faith * 3
	for i in maxi(count, 2):
		var side := -1.0 if i % 2 == 0 else 1.0
		var n := figure(Crowd_COATS[rng.randi() % Crowd_COATS.size()], Crowd_SKINS[rng.randi() % Crowd_SKINS.size()], {"visor": true, "arms": true, "knees": true})
		n.position = Vector3(side * rng.randf_range(9.0, 11.5), 0.12, rng.randf_range(N + 16.0, S - 6.0))
		add_child(n)
		walkers.append({"node": n, "dir": -1.0 if rng.randf() < 0.5 else 1.0, "speed": rng.randf_range(0.9, 1.4), "phase": rng.randf() * TAU})
	# three who stand still and will talk
	for i in 3:
		var t := figure(Crowd_COATS[rng.randi() % Crowd_COATS.size()], Crowd_SKINS[rng.randi() % Crowd_SKINS.size()], {"visor": true, "arms": true, "knees": true})
		var side := 1.0 if i != 1 else -1.0
		t.position = Vector3(side * 11.6, 0.12, 46.0 - i * 38.0)
		t.rotation.y = PI / 2.0 if side > 0.0 else -PI / 2.0
		add_child(t)
		var sync := 88 + rng.randi() % 12
		person("person%d" % i, LINES["prompts"]["person"], t, LINES["scan"]["person"] % [sync, "THE TOWER" if faith >= 1 else "YOU"])
		talkers.append(t)


func tick(delta: float) -> void:
	if not main or not main.player:
		return
	var pp: Vector3 = main.player.global_position
	for w in walkers:
		var n: Node3D = w["node"]
		n.position.z += w["dir"] * w["speed"] * delta
		if n.position.z < N + 14.0 or n.position.z > S - 4.0:
			w["dir"] = -w["dir"]
		n.rotation.y = lerp_angle(n.rotation.y, 0.0 if w["dir"] < 0.0 else PI, delta * 4.0)
		Anim.walk(n, _t, w["speed"], w["phase"])
		if faith >= 1:
			Anim.look(n, pp + Vector3(0, 1.6, 0), 0.0 if n.position.distance_to(pp) > 10.0 else 0.7, 0.05)
	for t: Node3D in talkers:
		Anim.idle(t, _t, float(t.get_instance_id() % 7))
		Anim.look(t, pp + Vector3(0, 1.6, 0), 0.9 if t.position.distance_to(pp) < 7.0 else 0.0, 0.06)
	if _eye_sprite:
		_eye_sprite.visible = main.frames_on
		_eye_light.light_energy = 0.8 + 0.6 * sin(_t * 3.0)
	if _door_marker:
		_door_marker.position.y += sin(_t * 3.0) * 0.004
		_door_marker.rotation.y += delta * 1.5
	main.city.cases.tick(self, delta)


## After waiting in place the street may have something new open.
func refresh_city() -> void:
	main.update_hud()


func objective() -> String:
	return main.city.objective()


func phone() -> String:
	var t: String = LINES["phone"] % [main.city.district_name(did), main.city.clock_text(), faith]
	if main.connection >= 25.0:
		t += LINES["phone_fork"] % main.city.district_name(did)
	t += main.city.standing.remember()     # Carl's Tower, Memory
	t += main.city.cases.phone_text()      # the side cases (SideCases.gd)
	return t


func scan_people() -> Array:
	var out := []
	for w in walkers:
		out.append([w["node"], LINES["scan"]["person"] % [90 + (w["node"] as Node3D).get_instance_id() % 10, "THE TOWER" if faith >= 1 else "THE STREET"]])
	for k in kneelers:
		out.append([k, LINES["scan"]["kneel"]])
	out.append_array(main.city.cases.scan_people(self))
	return out


# ------------------------------------------------------------------ interactions

func interact(node: Object) -> bool:
	var ui = main.ui
	var ex: Dictionary = LINES["examine"]
	var id := str(node.get_meta("id"))
	if await main.city.standing.street_interact(self, id):
		return true
	if id.begins_with("case_"):
		return await main.city.cases.interact(self, node)
	match id:
		"kiosk":
			if not main.frames_on and main.connection >= 25.0:
				await ui.think(ex["kiosk_dead"])
			else:
				ui.close()
				await main.city.open_terminal("kiosk")
		"incident":
			if main.incidents.has(_incident_id) and main.incidents[_incident_id]["state"] == "open":
				await main.city.run_incident(_incident_id)
				if main.incidents[_incident_id]["state"] != "open" and _eye_sprite:
					_eye_sprite.queue_free()
					_eye_sprite = null
					_eye_light.light_energy = 0.0
					_eye_light = null
			else:
				await ui.think(main.city.incident_text(main.incidents[_incident_id], "found") if main.incidents.has(_incident_id) else ex["end"])
		"beat_door":
			ui.close()
			if not _beat.is_empty() and main.city.is_open(_beat):
				main.city.enter_beat(_beat)
		"home_lift":
			ui.close()
			main.city.go("home")
		"end":
			await ui.think(ex["end"])
			ui.close()
			main.city.open_map()
		"landmark":
			var nm: Array = LINES["landmarks"][did]
			await ui.think(str(nm[1]))
		"eye", "ring", "vigil", "kneel":
			await ui.think(ex[id])
		"person0", "person1", "person2":
			await ui.say("", _street_line())
		_:
			return false
	return true


## The quick-hack on a side-case device: the charge post, the substation gate (SideCases.gd).
func on_hack(node: Object, word: String) -> bool:
	return await main.city.cases.on_hack(self, node, word)


## What the street says: a stance line when Carl has one, a Faith line when the district has it.
func _street_line() -> String:
	var P: Dictionary = LINES["people"]
	_lines_i += 1
	var st: String = main.stance()
	var pool: Array = P["undecided"]
	if faith >= 2 and _lines_i % 2 == 0:
		pool = P["faith"]
	elif main.city.standing.dereg():
		return main.city.standing.street_line(_lines_i)
	elif st != "undecided" and P.has(st):
		pool = P[st]
	return str(pool[(_lines_i + absi(hash(did))) % pool.size()])


func selftest() -> void:
	main.frames_on = true
	for id in ["landmark", "kiosk", "incident", "person0", "ring", "vigil"]:
		for n in main._all_with_meta(self, "id"):
			if is_instance_valid(n) and str(n.get_meta("id")) == id:
				await main.interact(n)
				print("ok ", id)
				break
	await main.selftest_all_interactables()
