extends "res://scripts/Level.gd"
## Chapters 8 and 9: the Restricted Road out of Southtown at night, then
## the sand flats on foot. Book, ch. 9: "The red X led into the desert, a
## place Psyonic marked as restricted. Once, that felt like bureaucracy.
## Now, it felt like containment." The road cracks, the horizon opens, sand
## and silence swallow everything; the frames flicker ("Not a glitch. A
## filter. A signal shift."); a Psyonic sedan perched at the edge of a rocky
## bluff, no sand on the tires; the fingerprint on the rearview mirror; the
## door carved into the cliffside with the Eye scorched into the metal; the
## frames scream and shut down; "BOW, SLEEPER."; knees in the dust; the door
## slides open.
##
## Two halves. First the company car drives itself along the road (as in
## Drive.gd: Carl is seated and can look around) past the CONTAINMENT ZONE 1
## sign, the sleeping guard, the gate that wipes the trip log, the deep sand
## where ORA loses the map, and an older wrecked fleet sedan with stick rings
## on its roof. Then Carl gets out at the bluff: Lynx's sedan, his own car,
## rings in the sand, the door in the cliff to the east.
##
## Layout (metres): the road runs north along -Z from the edge of Southtown
## (z 60) to the bluff (z -520). The city's glow is behind, to the south.
## The cliff runs along x 72 from z -430 to -720; the door is at z -575.
## From the cars there are two ways to it: north, down the broken edge of
## the bluff through the gully (z -505) and along the foot of the cliff; or
## south, past the rings and through the dune field and the second wreck's
## debris. Rock outcrops, drifts and debris between are cover for later.
## Figures and devices carry metas for the systems that come later:
## "guard" (the eyeless watchers by the door), "vagrant" (the people at the
## shacks by the checkpoint), "hackable" (anything with a Psyonic login).

## Every line of text in this level, keyed by beat (the function that
## plays it) and line, so the script can be edited without touching the
## scene logic. say lines are [who, text]; choices are lists of labels.
const LINES := {
	"build": {
		"text1": "[b]THE RESTRICTED ROAD[/b]\n\n[color=#aaaaaa]out of Southtown, into the flats[/color]",
	},
	"city_edge": {
		"text1": "always watching over you",
		"text2": "the pillow for those who dream",
		"text3": "customer satisfaction is our greatest priority",
		"text4": "CONTAINMENT ZONE 1  -  NO ENTRY BEYOND THIS POINT",
	},
	"sign": {
		"text1": "PSYONIC INTEGRATIONS",
		"text2": "RESTRICTED AREA",
		"text3": "CONTAINMENT ZONE 1",
		"text4": "NO ENTRY  -  AUTHORISED FLEET ONLY",
		"text5": "PSYONIC INTEGRATIONS  -  RESTRICTED\nsignage id: NONE ON FILE\nerected: before records begin",
	},
	"checkpoint": {
		"text1": "PSYONIC SECURITY  -  node 7\nframes: ON  -  RECORDING\nsync 100%  -  DREAMING",
		"text2": "The booth terminal",
		"text3": "PSYONIC CHECKPOINT  -  terminal\nlogin: node7 (session open)\nfeed: 2 cameras, 1 barrier",
		"text4": "PSYONIC  -  AUTHORISED FLEET ONLY",
		"text5": "TRIP LOGS SURRENDERED AT THIS POINT",
		"text6": "The barrier controller",
		"text7": "BARRIER CONTROLLER  -  Voltx\nfirmware: 2.0.1 (unpatched)\nport: OPEN",
		"text8": "PSYONIC CHECKPOINT 1\nbarrier: UP\ntrip log: CLEARED ON PASSAGE",
		"text9": "PSYONIC CAMERA  -  lane %d\nuplink: LIVE\nretention: FOREVER",
	},
	"deep_sand": {
		"text1": "ORA  -  LOCATION UNAVAILABLE",
	},
	"wreck": {
		"text1": "The sticks on the roof of the wreck: two rings, the gap in the outer one toward the flats. Laid after the car stopped. Laid after the sand came, by the look of them.",
		"text2": "The wrecked sedan",
		"text3": "PSYONIC FLEET 0041\nstatus: DECOMMISSIONED\ntrip log: NONE  -  driver: NONE",
	},
	"bluff": {
		"text1": "Two rings of sticks pressed into the sand, the gap in the outer one facing the cliff. Her footprints went in. Her footprints did not come out.",
		"text2": "Rings in the sand",
		"text3": "ORA  -  pattern: RINGS (2)\nmatch: Dufredy ceiling  -  Harmony Green bench  -  the wreck",
	},
	"basin": {
		"text1": "The overturned van",
		"text2": "PSYONIC FLEET  -  VAN 0019\nstatus: WRITTEN OFF\nmanifest: FRAMES (ORA) x 240",
	},
	"cliff_and_door": {
		"text1": "The door in the cliff",
		"text2": "ORA  -  [no data]",
		"scripture": ["SALVATION OR BLOOD SACRAMENT", "an offering is required to continue", "a prayer, faith is the key", "one path holds the key, it watches and it judges", "we walk alone, we test alone"],
		"panel_prompt": "An ORA panel",
		"panel_scan": "ORA  -  door panel\noffering: NONE\nstatus: WAITING",
		"panel_bleed_scan": "ORA  -  door panel\noffering: ACCEPTED\nstatus: BLEEDING",
	},
	"watchers": {
		"text1": "One of the eyeless",
		"text2": "CITIZEN  -  identity: WITHHELD\nframes: NONE  -  eyes: NONE\nsync 100%  -  DREAMING",
	},
	"shacks": {
		"text1": "The man by the fire",
		"text2": "CITIZEN  -  no fixed address\nPsyon: UNINSTALLED\nframes: SOLD",
		"text3": "The woman under the sheet",
		"text4": "CITIZEN  -  no fixed address\nPsyon 3.9  -  sync 0%\nframes: BROKEN",
		"text5": "NO WORK\nNO WATER\nNO EYES",
	},
	"car": {
		"text1": "PSYONIC FLEET 0086\nNAV: RESTRICTED RD\nTRIP LOG 41.2 KM",
		"text2": "Your company car",
		"text3": "PSYONIC FLEET 0086\ndriver: DRAKE, C.\nmicrophone: ALWAYS ON\ntrip log: 0.0 KM",
	},
	"lynx_sedan": {
		"text1": "Lynx's sedan",
		"text2": "PSYONIC FLEET 0112\ndriver: LYNX, A.\ntrip log: NONE\nlast sync: 06:12 TODAY",
	},
	"run": {
		"think1": "The road out of Southtown ran dead straight into the flats. Psyonic had marked it restricted years ago. Once, that felt like bureaucracy. Now it felt like containment.",
		"think2": "The road out of Southtown ran dead straight into the flats, and stopped being a road for anyone without company plates at the checkpoint. Psyonic had marked it restricted years ago. I had never asked why.",
		"think3": "I entered the coordinates from the map. The red X led into the desert. The city passed me like a dream. Too bright, too loud, too human. I wondered how many were already infected. How many were unknowingly carrying the forked model.",
		"think4": "PSYONIC INTEGRATIONS. RESTRICTED AREA. CONTAINMENT ZONE 1. The sign was older than the company's current logo. Somebody had known there was something out here to contain before there was a company.",
		"think5": "The guard was asleep in the booth, mouth open, frames on. The frames were recording. Whatever he was dreaming, the company had it.",
		"text1": "the sleeping guard",
		"think6": "Across the road, under plastic and sheet metal, a fire in a drum and two people who did not get up. The edge of every zone had them now. The company car went by and the man by the fire watched it the way you watch weather.",
		"text2": "PSYONIC FLEET 0086\nORA: LOCATION\nUNAVAILABLE",
		"think7": "Sand over the asphalt, deeper every step. The frames tried to draw the road and gave up. ORA: LOCATION UNAVAILABLE. First time I'd seen it say that.",
		"toast1": "ORA  //  location unavailable",
		"think8": "A sedan, company plates, nose down in the sand. Not Lynx's. Older. The logs in the dash had been wiped, and someone had laid two rings of sticks on the roof.",
		"cap1": "The road cracked beneath my wheels. The horizon opened. Sand and silence swallowed everything.",
		"cap2": "My ORA-frames flickered. Not a glitch. A filter. A signal shift. It was watching me.",
		"text3": "PSYONIC FLEET 0086\nCOORDINATES REACHED\n--",
		"cap3": "The coordinates pinged. At first: nothing.",
		"think9": "Perched at the edge of a rocky bluff, like a fossil waiting to be uncovered: a Psyonic-issued sedan. Its polished exterior gleamed in my headlights. No sand on the tires. No dust on the windshield. Recently abandoned.",
		"say1": ["Carl", "Lynx."],
	},
	"gate": {
		"text1": "PSYONIC FLEET 0086\nNAV: RESTRICTED RD\nTRIP LOG 0.0 KM",
		"think1": "The barrier was up. As I passed under it the dash chimed, and the trip log, the whole log, cleared itself to zero.",
		"choices1": ["Keep driving.", "Turn back, once."],
		"think2": "I kept driving. The company could have the logs. The company could have the dream.",
		"text2": "drove through",
		"think3": "I turned back, once, and sat at the barrier with the engine running until the chime stopped. Then I went through anyway. There was never a version where I didn't.",
		"think4": "Second time. I kept going.",
	},
	"get_out": {
		"think1": "I pulled alongside and killed the engine. The silence was immense. Oppressive. I stepped out, gravel crunching beneath my boots. The night bore down like judgment.",
	},
	"interact": {
		"think1": "Two rings of sticks pressed into the sand, the gap in the outer one toward the cliff. Her footprints went in. Her footprints did not come out. I had seen this on a ceiling, on a bench, and on the roof of a car nobody drove.",
		"think2": "With the frames on I could have read it. I did not put the frames on.",
		"toast1": "ORA  //  pattern: RINGS (2)  -  match: 4",
		"think3": "One of the eyeless. Standing in the rocks facing the door, hands at its sides, the sockets dried black and the blood down the coat gone to rust. It did not breathe that I could see.",
		"think4": "With the frames on it turned its head toward me. Not its body. Its head. It had no eyes and it was looking at me.",
		"text1": "looked at by the eyeless",
		"think5": "Without the frames it was a statue. I did not want to know what it was with them on.",
		"think6": "A fleet van on its side below the bluff, its load thrown across the sand toward the cliff. Frames. Crates of them, burst open, the little glass eyes of them everywhere. Someone had been bringing frames out here by the hundred.",
		"think7": "He didn't look up. She didn't wake. There was nothing a man from the company could say to either of them that the company hadn't already said.",
		"think8": "Company hardware, logged in and left. Everything out here was logged in and left.",
		"think9": "I'd passed it in the car. The road behind me was already somewhere I had been.",
		"panel": "An ORA panel on a post, the same unit as the ones in the tower lobby, out here in the rock. One was dark and waiting. The other had taken its offering: the screen was red, and what had run down from it had dried on the post and had not been paint. Somebody had paid with the only thing they had on them.",
	},
	"my_car": {
		"think1": "The corporate bubble of sanity. I could still get back in and drive home.",
		"choices1": ["Stay.", "Drive home."],
		"text1": "PSYONIC FLEET 0086\nNAV: HOME\n61 MIN",
		"text2": "PSYONIC FLEET 0086\nNAV: HOME\n61 MIN\n\nmicrophone: ON",
		"think2": "I sat with the engine running for a full minute. The dash counted the minutes home. The microphone counted me breathing. Then I got out again. The path had already begun.",
		"text3": "PSYONIC FLEET 0086\nCOORDINATES REACHED\n--",
		"text4": "couldn't leave",
	},
	"sedan": {
		"think1": "A faint trace of her perfume, already vanishing into the cold.",
		"think2": "I circled the vehicle slowly, hand hovering near my sidearm, half-expecting movement behind the tinted glass. Nothing. I opened the door.",
		"think3": "No signs of a struggle. No blood. No bag. No tablet. Not even a coffee cup. Just a faint trace of her perfume. Something citrusy, distant, like memory evaporating.",
		"text1": "Check the glove compartment.",
		"text2": "Check the dashboard.",
		"text3": "Check the mirror.",
		"think4": "Empty. Not cleaned out. Empty, as if nothing had ever been put in it.",
		"think5": "Clean. Logs wiped. The center console blinked once, then dimmed, rebooting on a loop. There was no sign she'd ever been inside.",
		"think6": "The only thing out of place: a fingerprint, smudged faintly on the rearview mirror. I touched it reflexively. A momentary rush of emotion hit me. Panic. Guilt. Something else.",
		"say1": ["Carl", "She was here. And now she isn't."],
		"think7": "I looked out over the bluff, and saw it. The door. Carved into the cliffside. No handles. No keypad. No signage. Just the Eye, scorched into the metal like a scar. Waiting. Watching.",
		"think8": "It watched me. Especially here.",
	},
	"door": {
		"think1": "The sedan first. If Lynx was out here, the car would say so.",
		"think2": "I stepped forward. Each footfall felt rehearsed. Then: static.",
		"think3": "My ORA-frames shut down. A scream of digital distortion ripped through my skull. I tore the glasses off. Silence.",
		"think4": "But not for long. I thought of Lynx. I thought of Mira, her voice bent and warped by the machine.",
		"choices1": ["Put the glasses back on.", "Leave them off."],
		"think5": "Without them the door was just a door. Metal in rock. No voice. No Eye. I stood there until the sky had moved and the city's glow behind me had gone from red to grey, and then I put them on anyway, because the path had already begun.",
		"say1": ["???", "[b]BOW, SLEEPER.[/b]"],
		"think6": "A voice. Raw, mechanical, ancient.",
		"say2": ["Carl", "Who are you?"],
		"think7": "A breath touched the back of my neck.",
		"say3": ["???", "[b]BOW![/b]"],
		"think8": "The word detonated in my ear. My legs buckled. My knees hit the dust.",
		"think9": "The door slid open.",
	},
	"enter": {
		"think1": "I walked in. Because the path had already begun.",
	},
	"objective": {
		"text1": "The door in the cliff, to the east.",
		"text2": "The sedan, out on the bluff.",
		"text3": "Look around. The car drives itself.",
	},
	"phone": {
		"text1": "[color=#7fe6b0]Psyon:[/color] You've left the service area, Carl. I can't see the road from here.\n\n",
		"text2": "[color=#7fe6b0]Psyon:[/color] Your trip log has been surrendered to Psyonic Integrations. This is normal.\n\n",
		"text3": "[color=#e08080]Psyon:[/color] All must walk the path alone, Carl.\n\n",
	},
}

const LANE_X := 2.4
const SEAT := Vector3(-0.38, 0.0, 0.25)
const PARK_Z := -521.0
const SEDAN := Vector3(7.5, 0.0, -537.0)
const DOOR := Vector3(71.0, 0.0, -575.0)
const RINGS := Vector3(21.0, 0.0, -552.0)
const CLIFF_X := 72.0
const PSYON_GREEN := Color(0.2, 1.0, 0.45)

var car: Node3D
var speed := 0.0
var want_speed := 0.0
var stop_z := -9999.0
var dash_label: Label3D
var dash_m: StandardMaterial3D
var headlights: Array = []
var guard: Node3D
var guard_rec: MeshInstance3D
var barrier_arm: Node3D
var gate_lamp: StandardMaterial3D
var door_slab: Node3D
var door_eye_m: StandardMaterial3D
var door_green_m: StandardMaterial3D
var door_light: OmniLight3D
var my_car_it: CollisionObject3D
var sedan_it: CollisionObject3D
var door_it: CollisionObject3D
var drones: Array = []
var watchers: Array = []
var vagrants: Array = []
var _engine: AudioStreamPlayer
var _wind: AudioStreamPlayer
var _driving := false
var _arrived := false
var _sedan_done := false
var _at_door := false
var _ended := false
var _sand: StandardMaterial3D
var _rock: StandardMaterial3D
var _stick_m: StandardMaterial3D


func build(m: Node) -> void:
	main = m
	rng.seed = 89
	kit_day = false
	step_db = -22.0
	card = LINES["build"]["text1"]
	_sand = pbr("plaster", Vector3(1, 1, 1) / 3.0, true, Color(0.62, 0.5, 0.36), 1.0)
	_rock = pbr("concrete", Vector3(1, 1, 1) / 2.5, true, Color(0.42, 0.36, 0.3), 1.0)
	_stick_m = mat(Color(0.4, 0.31, 0.2), 0.9)
	_ground()
	_road()
	_city_edge()
	_skyline()
	_sign()
	_checkpoint()
	_deep_sand()
	_wreck()
	_shacks()
	_bluff()
	_basin()
	_cliff_and_door()
	_watchers()
	_desert()
	_drones()
	_bounds()
	_batch(self, 60.0, true)
	_car()
	_lynx_sedan()
	spawn = car.position + SEAT
	spawn_yaw = 0.0


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	# Moonless. The sky to the south is the colour of the city's smog, lit
	# from below; the fog is sand hanging in the air, warm and dirty.
	var psm := ProceduralSkyMaterial.new()
	psm.sky_top_color = Color(0.012, 0.012, 0.028)
	psm.sky_horizon_color = Color(0.22, 0.09, 0.09)
	psm.ground_horizon_color = Color(0.22, 0.09, 0.09)
	psm.ground_bottom_color = Color(0.03, 0.02, 0.02)
	psm.sky_curve = 0.12
	env.sky.sky_material = psm
	env.ambient_light_color = Color(0.3, 0.28, 0.38)
	env.ambient_light_energy = 0.3
	env.fog_light_color = Color(0.13, 0.07, 0.09)
	env.fog_density = 0.0026
	env.fog_sky_affect = 0.25
	env.glow_bloom = 0.05
	env.tonemap_exposure = 1.1
	# starlight from above, cold; the city's glow is a warm rim low in the south
	sun.light_color = Color(0.55, 0.58, 0.8)
	sun.light_energy = 0.24
	sun.sky_mode = DirectionalLight3D.SKY_MODE_LIGHT_ONLY
	sun.rotation = Vector3(deg_to_rad(-52), deg_to_rad(160), 0)
	sun.directional_shadow_max_distance = 90.0


func hifi(env: Environment, _sun: DirectionalLight3D) -> void:
	env.volumetric_fog_density *= 0.8
	for h in headlights:
		(h as SpotLight3D).shadow_enabled = true


func ambience() -> void:
	_engine = main.loop("engine", -16.0)
	_wind = main.loop("wind", -14.0)
	main.loop("hum", -26.0)
	main.loop("static", -22.0, DOOR + Vector3(-1.5, 1.6, 0), 2.0, 22.0)
	main.loop("fire", -8.0, Vector3(-9.5, 0.8, -103.0), 2.0, 18.0)


# ------------------------------------------------------------------ the road out

func _ground() -> void:
	solid_box(Vector3(900, 2, 1200), Vector3(0, -1.0, -350))
	var pm := PlaneMesh.new()
	pm.size = Vector2(900, 1200)
	mesh(pm, Vector3(0, -0.02, -350), _sand)


func _road() -> void:
	var asphalt := pbr("asphalt", Vector3(1, 1, 1) / 4.0, true, Color(0.75, 0.72, 0.7), 0.9)
	var line := mat(Color(0.5, 0.45, 0.32), 0.7)
	var curb := mat(Color(0.3, 0.27, 0.24), 0.9)
	var z := 60.0
	while z > -530.0:
		var cz := z - 10.0
		floor_quad(Vector2(11, 20), Vector3(0, 0.0, cz), 0.0, asphalt)
		if cz > -180.0:
			for side: float in [-1.0, 1.0]:
				box(Vector3(0.3, 0.14, 20), Vector3(side * 5.6, 0.07, cz), curb)
			box(Vector3(0.14, 0.01, 3.0), Vector3(0, 0.012, cz), line)
			box(Vector3(0.14, 0.01, 3.0), Vector3(0, 0.012, cz - 8.0), line)
		elif cz > -400.0:
			# the road cracked beneath my wheels: slabs tilted, lines gone
			for k in 3:
				var crack := box(Vector3(rng.randf_range(0.08, 0.2), 0.03, rng.randf_range(2, 6)),
					Vector3(rng.randf_range(-5, 5), 0.015, cz + rng.randf_range(-9, 9)), mat(Color(0.12, 0.1, 0.09), 1.0))
				crack.rotation.y = rng.randf_range(-0.6, 0.6)
		z -= 20.0
	# sand blown over the asphalt, thin at first, then the road is under it
	var sand_decal := decal_mat(Tex.sand(), Color(1, 1, 1), 1.0)
	for i in 90:
		var sz := rng.randf_range(-420, 40)
		var t := clampf((-sz - 60.0) / 300.0, 0.05, 1.0)
		floor_quad(Vector2(rng.randf_range(2, 7) * (0.5 + t), rng.randf_range(1.5, 4) * (0.5 + t)),
			Vector3(rng.randf_range(-5.5, 5.5) * (1.0 - t * 0.4), 0.02 + i * 0.0002, sz), rng.randf_range(-0.5, 0.5), sand_decal)
	# fence posts and a sagging wire along the restricted stretch
	var post := mat(Color(0.28, 0.22, 0.18), 0.9, 0.3)
	var wire := mat(Color(0.1, 0.1, 0.1), 0.6, 0.5)
	for side: float in [-1.0, 1.0]:
		var fz := -70.0
		var prev := Vector3(side * 8.5, 1.3, fz)
		while fz > -400.0:
			var lean := rng.randf_range(-0.15, 0.15)
			var p := Vector3(side * 8.5 + rng.randf_range(-0.3, 0.3), 0.0, fz)
			var h := 1.5 - clampf((-fz - 250.0) / 300.0, 0.0, 0.8)  # sinking into the sand
			var pb := box(Vector3(0.12, h, 0.12), p + Vector3(0, h / 2.0, 0), post)
			pb.rotation.z = lean
			var top := p + Vector3(0, h - 0.1, 0)
			stick(prev, top, 0.012, wire)
			prev = top
			fz -= 12.0


## The last blocks of Southtown: shopfronts, neon, cables, and then nothing.
func _city_edge() -> void:
	for side: float in [-1.0, 1.0]:
		var z := 70.0
		while z > -40.0:
			var depth := rng.randf_range(14.0, 24.0)
			var h := rng.randf_range(12.0, 34.0)
			if z > 30.0 and rng.randf() < 0.5:
				h = rng.randf_range(40.0, 80.0)
			var cz := z - depth / 2.0
			cyber_block(Vector3(side * 12.0, 0, cz), -side * PI / 2.0, depth, h, 24.0, true, 0 if cz > -20.0 else 1)
			z -= depth
	for cz: float in [50.0, 32.0, 16.0, 2.0, -14.0]:
		for i in rng.randi_range(1, 3):
			var y := rng.randf_range(7.0, 13.0)
			cable(Vector3(-11.9, y, cz + rng.randf_range(-3, 3)), Vector3(11.9, y + rng.randf_range(-1.5, 1.5), cz + rng.randf_range(-3, 3)), rng.randf_range(0.6, 1.4))
	skybridge(Vector3(-12.0, 18.0, 40.0), Vector3(12.0, 20.0, 40.0), 3.5)
	kit_holo(Vector3(-2.0, 17.0, 20.0), 0.0, "ORA", LINES["city_edge"]["text1"], KIT_NEON[1], 11.0)
	kit_holo(Vector3(3.0, 15.0, 58.0), 0.0, "PSYON", LINES["city_edge"]["text2"], KIT_NEON[0], 10.0)
	# streetlights, the last two dead, and the sand already in the gutters
	var pole := mat(Color(0.25, 0.25, 0.27), 0.5, 0.6)
	var sl := 55.0
	var n := 0
	while sl > -70.0:
		for side: float in [-1.0, 1.0]:
			cyl(0.08, 0.1, 6.5, Vector3(side * 6.6, 3.25, sl), pole, 6)
			box(Vector3(1.4, 0.1, 0.12), Vector3(side * 6.0, 6.4, sl), pole)
			if sl > -30.0:
				box(Vector3(0.5, 0.08, 0.2), Vector3(side * 5.5, 6.32, sl), glow(Color(1.0, 0.75, 0.45), 2.0, true))
				light(Vector3(side * 5.5, 5.8, sl), Color(1.0, 0.75, 0.45), 1.6, 12.0)
			n += 1
		sl -= 24.0
	# beyond the last block: low dead sheds, a transformer yard, a billboard
	kit_dead = true
	for side: float in [-1.0, 1.0]:
		cyber_block(Vector3(side * 14.0, 0, -58.0), -side * PI / 2.0, 20.0, 7.0, 16.0, true, 1)
		cyber_block(Vector3(side * 16.0, 0, -86.0), -side * PI / 2.0, 22.0, 5.0, 14.0, true, 1)
	kit_dead = false
	var k := _kit_mats()
	for i in 6:
		var p := Vector3(-30.0 + (i % 3) * 4.0, 0, -100.0 - (i / 3) * 4.0)
		box(Vector3(2.2, 2.6, 1.6), p + Vector3(0, 1.3, 0), k["metal"])
		cyl(0.15, 0.15, 1.2, p + Vector3(0, 3.2, 0), k["rust"], 6)
	box(Vector3(0.3, 9.0, 0.3), Vector3(16.0, 4.5, -45.0), k["metal"])
	var bb := box(Vector3(0.25, 5.0, 12.0), Vector3(16.3, 11.0, -45.0), k["dark"])
	bb.rotation.y = 0.2
	var br := Node3D.new()
	br.position = Vector3(16.1, 11.0, -45.0)
	br.rotation.y = -PI / 2.0 + 0.2
	add_child(br)
	neon_text("PSYONIC", Vector3(0, 1.0, 0), 0.0, 1.6, KIT_NEON[1], 2.2, br)
	neon_text(LINES["city_edge"]["text3"], Vector3(0, -0.6, 0), 0.0, 0.42, Color(1, 0.95, 0.9), 1.8, br)
	neon_text(LINES["city_edge"]["text4"], Vector3(0, -1.7, 0), 0.0, 0.3, Color(1.0, 0.3, 0.2), 2.0, br)


## Silico behind: a ridge of towers across the whole south, lit windows and
## the sky glowing over them. It stays in the mirror the whole drive.
func _skyline() -> void:
	var k := _kit_mats()
	for i in 44:
		var x := rng.randf_range(-420.0, 420.0)
		var z := rng.randf_range(110.0, 330.0) + absf(x) * 0.15
		var w := rng.randf_range(18.0, 40.0)
		var h := rng.randf_range(40.0, 170.0)
		var wi := rng.randi() % 6
		box(Vector3(w, h, w), Vector3(x, h / 2.0, z), k["walls"][wi])
		quad(Vector2(w - 0.2, h - 6.0), Vector3(x, 3.0 + h / 2.0, z - w / 2.0 - 0.02), PI, k["lits"][wi])
		if h > 110.0:
			var bl := box(Vector3(1.0, 1.0, 1.0), Vector3(x, h + 1.0, z), glow(Color(1, 0.05, 0.05), 4.0))
			blinkers.append(bl)
		if rng.randf() < 0.4:
			var c := _kc()
			box(Vector3(w * 0.7, 0.5, 0.3), Vector3(x, h - 3.0, z - w / 2.0 - 0.1), glow(c, 2.4, true))
	# a warm wash from the city on the backs of things along the first stretch
	for z: float in [20.0, -60.0, -140.0]:
		var wl := light(Vector3(0, 14.0, z), Color(1.0, 0.55, 0.4), 1.2, 60.0, false)
		wl.omni_attenuation = 1.0
	# the smog glow: additive sheets hanging over the city, unfogged
	var gm := StandardMaterial3D.new()
	gm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	gm.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	gm.albedo_color = Color(0.3, 0.1, 0.12)
	gm.disable_fog = true
	gm.cull_mode = BaseMaterial3D.CULL_DISABLED
	var g1 := quad(Vector2(1100, 160), Vector3(0, 70, 360), 0.0, gm)
	g1.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	no_batch.append(g1)
	var gm2 := StandardMaterial3D.new()
	gm2.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	gm2.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	gm2.albedo_color = Color(0.16, 0.05, 0.08)
	gm2.disable_fog = true
	gm2.cull_mode = BaseMaterial3D.CULL_DISABLED
	var g2 := quad(Vector2(1400, 360), Vector3(0, 150, 420), 0.0, gm2)
	g2.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	no_batch.append(g2)
	# the Spine's tower, far off east of the city, its ring still lit
	var jade := mat(Color(0.16, 0.4, 0.34), 0.3, 0.7)
	cyl(16, 30, 440, Vector3(520, 220, 600), jade, 12)
	var tm := TorusMesh.new()
	tm.inner_radius = 58
	tm.outer_radius = 108
	tm.rings = 24
	tm.ring_segments = 8
	mesh(tm, Vector3(520, 440, 600), glow(Color(0.7, 0.75, 0.8), 0.6))


## "PSYONIC INTEGRATIONS. RESTRICTED AREA. CONTAINMENT ZONE 1. The sign
## was older than the company's current logo."
func _sign() -> void:
	var z := -62.0
	var k := _kit_mats()
	box(Vector3(0.16, 3.6, 0.16), Vector3(7.4, 1.8, z), k["rust"])
	box(Vector3(0.16, 3.6, 0.16), Vector3(9.4, 1.8, z), k["rust"])
	var plate := mat(Color(0.62, 0.58, 0.5), 0.95)
	var pb := box(Vector3(2.4, 1.5, 0.08), Vector3(8.4, 3.0, z), plate)
	pb.rotation.y = 0.35
	var root := Node3D.new()
	root.position = Vector3(8.4, 3.0, z)
	root.rotation.y = 0.35
	add_child(root)
	label(LINES["sign"]["text1"], Vector3(0, 0.5, 0.05), 0.0, 0.0065, Color(0.25, 0.2, 0.15), root, false)
	label(LINES["sign"]["text2"], Vector3(0, 0.18, 0.05), 0.0, 0.0085, Color(0.45, 0.1, 0.08), root, false)
	label(LINES["sign"]["text3"], Vector3(0, -0.18, 0.05), 0.0, 0.0085, Color(0.45, 0.1, 0.08), root, false)
	label(LINES["sign"]["text4"], Vector3(0, -0.5, 0.05), 0.0, 0.0045, Color(0.3, 0.25, 0.2), root, false)
	# the old mark in the corner: a ring inside a ring, not the swoosh they use now
	var old := mat(Color(0.3, 0.26, 0.2), 0.9)
	for r: float in [0.09, 0.16]:
		var tm := TorusMesh.new()
		tm.inner_radius = r - 0.015
		tm.outer_radius = r
		tm.rings = 16
		tm.ring_segments = 5
		var ring := mesh(tm, Vector3(-0.95, 0.5, 0.05), old, root)
		ring.rotation.x = PI / 2.0
	# rust streaks and a bullet hole or two
	var rust := mat(Color(0.32, 0.18, 0.1), 1.0)
	for i in 5:
		box(Vector3(0.06, rng.randf_range(0.3, 0.9), 0.01), Vector3(rng.randf_range(-1.1, 1.1), rng.randf_range(-0.5, 0.3), 0.045), rust, false, root)
	for i in 2:
		cyl(0.03, 0.03, 0.1, Vector3(rng.randf_range(-0.8, 0.8), rng.randf_range(-0.4, 0.4), 0.0), mat(Color(0.02, 0.02, 0.02)), 6, root).rotation.x = PI / 2.0
	light(Vector3(8.4, 4.4, z + 0.8), Color(1.0, 0.8, 0.6), 1.4, 7.0)
	box(Vector3(0.8, 0.08, 0.3), Vector3(8.4, 4.4, z + 0.4), k["metal"])
	interactable("sign", "The sign", Vector3(8.4, 3.0, z), Vector3(2.5, 1.6, 0.4),
		LINES["sign"]["text5"], false)


## The checkpoint: a booth with a guard asleep in it, frames on and
## recording, and the barrier gantry past it that wipes the trip log.
func _checkpoint() -> void:
	var z := -110.0
	var k := _kit_mats()
	var wall := pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.7, 0.68, 0.64))
	var bp := Vector3(8.0, 0, z)
	box(Vector3(3.0, 0.2, 3.0), bp + Vector3(0, 0.1, 0), k["plinth"])
	box(Vector3(2.6, 1.0, 2.4), bp + Vector3(0, 0.7, 0), wall, true)
	box(Vector3(2.8, 0.2, 2.6), bp + Vector3(0, 2.7, 0), k["dark"])
	for c: Vector3 in [Vector3(-1.25, 1.85, -1.15), Vector3(1.25, 1.85, -1.15), Vector3(-1.25, 1.85, 1.15), Vector3(1.25, 1.85, 1.15)]:
		box(Vector3(0.12, 1.4, 0.12), bp + c, k["metal"])
	# glass all round above the sill, the road side open as a window
	for s: float in [-1.0, 1.0]:
		var g := quad(Vector2(2.3, 1.3), bp + Vector3(0, 1.85, s * 1.2), 0.0 if s > 0.0 else PI, k["glass"])
		g.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	quad(Vector2(2.3, 1.3), bp + Vector3(1.3, 1.85, 0), PI / 2.0, k["glass"])
	quad(Vector2(2.3, 1.3), bp + Vector3(-1.3, 1.85, 0), -PI / 2.0, k["glass"])
	# desk, a dead monitor, a thermos, a chair with the guard in it
	box(Vector3(2.0, 0.06, 0.6), bp + Vector3(0, 1.0, 0.7), mat(Color(0.5, 0.42, 0.3), 0.8))
	box(Vector3(0.5, 0.35, 0.05), bp + Vector3(0.5, 1.25, 0.8), k["dark"])
	cyl(0.05, 0.05, 0.25, bp + Vector3(-0.6, 1.15, 0.7), mat(Color(0.7, 0.1, 0.1), 0.5, 0.4), 8)
	box(Vector3(0.5, 0.05, 0.5), bp + Vector3(0, 0.55, -0.2), k["dark"])
	box(Vector3(0.5, 0.7, 0.05), bp + Vector3(0, 0.9, -0.45), k["dark"])
	cyl(0.04, 0.04, 0.5, bp + Vector3(0, 0.27, -0.2), k["metal"], 6)
	guard = figure(Color(0.08, 0.1, 0.18), Color(0.78, 0.6, 0.46), {"arms": true, "knees": true, "visor": true, "hair": Color(0.2, 0.15, 0.1)})
	guard.position = bp + Vector3(0, 0.55, -0.25)
	guard.rotation.y = PI  # back to the road, feet toward the desk
	add_child(guard)
	Anim.sit(guard, 0.3)
	var head: Node3D = guard.get_meta("head")
	head.rotation.x = -0.55  # mouth open at the ceiling
	# the little red eye on the frames: recording
	guard_rec = box(Vector3(0.02, 0.02, 0.02), Vector3(0.11, 0.03, -0.1), glow(Color(1, 0.08, 0.05), 4.0), false, head)
	blinkers.append(guard_rec)
	light(bp + Vector3(0, 2.4, 0), Color(0.55, 0.9, 0.8), 1.3, 5.0)
	var bl := box(Vector3(0.6, 0.06, 0.2), bp + Vector3(0, 2.58, 0), glow(Color(0.55, 0.9, 0.8), 2.0, true))
	flickers.append(bl)
	interactable("guard", "The guard", bp + Vector3(0, 1.0, 0), Vector3(2.8, 2.6, 2.6),
		LINES["checkpoint"]["text1"], false)
	var term := interactable("booth_terminal", LINES["checkpoint"]["text2"], bp + Vector3(0.5, 1.25, 0.8), Vector3(0.6, 0.45, 0.2),
		LINES["checkpoint"]["text3"], false)
	term.set_meta("hackable", true)
	# the gantry and the barrier, up
	var gz := z - 14.0
	for side: float in [-1.0, 1.0]:
		box(Vector3(0.4, 6.0, 0.4), Vector3(side * 6.4, 3.0, gz), k["metal"], true)
	box(Vector3(13.6, 0.6, 0.6), Vector3(0, 6.0, gz), k["metal"])
	gate_lamp = newglow(Color(0.3, 1.0, 0.5), 2.5)
	for x: float in [-4.0, -2.0, 0.0, 2.0, 4.0]:
		box(Vector3(0.3, 0.15, 0.15), Vector3(x, 5.6, gz + 0.3), gate_lamp)
	var gr := Node3D.new()
	gr.position = Vector3(0, 5.2, gz + 0.32)
	add_child(gr)
	neon_text(LINES["checkpoint"]["text4"], Vector3(0, 0, 0), 0.0, 0.42, Color(1.0, 0.5, 0.2), 2.2, gr)
	neon_text(LINES["checkpoint"]["text5"], Vector3(0, -0.5, 0), 0.0, 0.28, Color(1.0, 0.3, 0.2), 2.0, gr)
	box(Vector3(0.4, 1.2, 0.4), Vector3(6.2, 0.6, gz - 1.0), mat(Color(0.8, 0.75, 0.2), 0.6))
	var ctl := interactable("gate_box", LINES["checkpoint"]["text6"], Vector3(6.2, 0.6, gz - 1.0), Vector3(0.6, 1.3, 0.6),
		LINES["checkpoint"]["text7"], false)
	ctl.set_meta("hackable", true)
	barrier_arm = Node3D.new()
	barrier_arm.position = Vector3(6.4, 1.1, gz - 1.0)
	barrier_arm.rotation.z = 1.35  # raised
	add_child(barrier_arm)
	var arm := box(Vector3(4.5, 0.12, 0.12), Vector3(-2.25, 0, 0), mat(Color(0.9, 0.85, 0.8), 0.6), false, barrier_arm)
	no_batch.append(arm)
	for i in 3:
		box(Vector3(0.6, 0.13, 0.13), Vector3(-0.6 - i * 1.5, 0, 0), mat(Color(0.85, 0.15, 0.1), 0.6), false, barrier_arm)
	# cameras on the gantry, one on each side, looking down the lanes
	for side: float in [-1.0, 1.0]:
		box(Vector3(0.3, 0.2, 0.5), Vector3(side * 3.0, 5.6, gz - 0.4), k["dark"])
		box(Vector3(0.05, 0.05, 0.05), Vector3(side * 3.0, 5.6, gz - 0.67), glow(Color(1, 0.1, 0.1), 3.0))
	light(Vector3(0, 5.4, gz + 1.0), Color(0.3, 1.0, 0.5), 1.8, 14.0)
	var gate_it := interactable("gate", "The barrier", Vector3(0, 3.0, gz), Vector3(13.0, 6.0, 1.2),
		LINES["checkpoint"]["text8"], false)
	gate_it.set_meta("hackable", true)
	for side: float in [-1.0, 1.0]:
		var cam_it := interactable("gate_camera", "The camera", Vector3(side * 3.0, 5.6, gz - 0.4), Vector3(0.5, 0.4, 0.7),
			LINES["checkpoint"]["text9"] % (1 if side < 0.0 else 2), false)
		cam_it.set_meta("hackable", true)


## Sand over the asphalt, deeper every step. ORA: LOCATION UNAVAILABLE.
func _deep_sand() -> void:
	# drifts across the road, higher as it goes; the car wallows through
	for i in 26:
		var z := -170.0 - i * 9.0
		var r := rng.randf_range(4.0, 9.0)
		var d := sphere(r, Vector3(rng.randf_range(-7, 7), -r * 0.55 + rng.randf_range(0.25, 0.7), z), _sand, 10)
		d.scale = Vector3(1.6, 0.55, 1.2)
	# a trapped car-sized shape under one drift, only the aerial showing
	stick(Vector3(-4.0, 0.2, -230.0), Vector3(-3.8, 1.3, -230.5), 0.015, mat(Color(0.1, 0.1, 0.1), 0.5, 0.5))
	interactable("deep_sand", "The sand", Vector3(0, 0.6, -215.0), Vector3(10.0, 1.4, 12.0),
		LINES["deep_sand"]["text1"], false)


## "A sedan, company plates, nose down in the sand. Not Lynx's. Older.
## The logs in the dash had been wiped, and someone had laid two rings of
## sticks on the roof."
func _wreck() -> void:
	var w := Node3D.new()
	w.position = Vector3(-8.5, -0.1, -292.0)
	w.rotation = Vector3(-0.42, 0.9, 0.12)  # nose down, off the road
	add_child(w)
	w.add_child(Car.build(self, Color(0.42, 0.44, 0.45), {"plate": "PSF 0041", "head": mat(Color(0.2, 0.2, 0.18), 0.5), "tail": mat(Color(0.25, 0.05, 0.05), 0.5)}))
	# sand up the nose and in the cabin
	var s1 := sphere(2.6, Vector3(0, -0.6, -1.6), _sand, 10, w)
	s1.scale = Vector3(1.0, 0.5, 1.1)
	# two rings of sticks on the roof, the outer open to the sky like the ceiling
	for r: float in [0.45, 0.75]:
		var n := 10 if r < 0.6 else 16
		for i in n:
			var a := i * TAU / n
			var b := (i + 1) * TAU / n
			stick(Vector3(cos(a) * r, 1.48, 0.3 + sin(a) * r), Vector3(cos(b) * r, 1.48 + rng.randf_range(0.0, 0.04), 0.3 + sin(b) * r), 0.012, _stick_m, w)
	_glyph_on(Vector3(-8.5, 1.5, -292.0), 0.9, 0.009, "g_wreck", false, true,
		LINES["wreck"]["text1"], true, Color(0.75, 0.55, 0.3))
	var w2 := Node3D.new()
	w2.position = Vector3(-8.5, 0, -292.0)
	w2.rotation.y = 0.9
	add_child(w2)
	solid_box(Vector3(2.2, 1.6, 4.8), Vector3(0, 0.6, 0), w2)
	var wk := interactable("wreck", LINES["wreck"]["text2"], Vector3(0, 0.9, 0), Vector3(2.4, 1.9, 5.0),
		LINES["wreck"]["text3"], false, w2)
	wk.set_meta("hackable", true)
	# the door open, a shoe in the sand beside it, a trail that goes nowhere
	var shoe := box(Vector3(0.12, 0.08, 0.3), Vector3(-12.0, 0.04, -289.0), mat(Color(0.15, 0.1, 0.08), 0.9))
	shoe.rotation.y = 1.2
	var sand_decal := decal_mat(Tex.sand(), Color(0.8, 0.7, 0.55), 1.0)
	for i in 7:
		floor_quad(Vector2(0.35, 0.5), Vector3(-13.0 - i * 0.9, 0.03, -288.0 - i * 2.2), rng.randf_range(-0.3, 0.3), sand_decal)


## The rocky bluff where the road ends, and where both cars stand.
func _bluff() -> void:
	# the rise the road climbs onto: a shelf of rock, sand round the edges
	var shelf := box(Vector3(60, 1.2, 70), Vector3(10, -0.61, -545), _rock)
	shelf.rotation.y = 0.12
	for i in 30:
		var p := Vector3(rng.randf_range(-24, 44), 0, rng.randf_range(-585, -505))
		if absf(p.x - SEDAN.x) < 5.0 and absf(p.z - SEDAN.z) < 7.0:
			continue
		if absf(p.x - LANE_X) < 4.0 and p.z > -530.0:
			continue
		var r := box(Vector3(rng.randf_range(0.6, 2.4), rng.randf_range(0.3, 1.1), rng.randf_range(0.6, 2.0)), p + Vector3(0, 0.15, 0), _rock)
		r.rotation = Vector3(rng.randf_range(-0.3, 0.3), rng.randf() * TAU, rng.randf_range(-0.3, 0.3))
	# the broken edge of the bluff: a lip of rock with two gaps in it, the
	# gully north (z -505) and the slope by the rings south (z -552)
	for i in 18:
		var ez := -495.0 - i * 5.0
		if absf(ez - -505.0) < 6.0 or absf(ez - -552.0) < 7.0:
			continue
		var p := Vector3(36.0 + rng.randf_range(-2, 2), 0.3, ez)
		var r := box(Vector3(rng.randf_range(2.0, 4.0), rng.randf_range(1.4, 2.4), 5.0), p, _rock, true)
		r.rotation = Vector3(rng.randf_range(-0.1, 0.1), rng.randf_range(-0.1, 0.1), rng.randf_range(-0.3, -0.1))
	# the rings of sticks in the sand, east of the sedan, where she walked
	for r: float in [0.5, 0.9]:
		var n := 10 if r < 0.6 else 16
		for i in n:
			var a := i * TAU / n
			var b := (i + 1) * TAU / n
			stick(RINGS + Vector3(cos(a) * r, 0.03, sin(a) * r), RINGS + Vector3(cos(b) * r, 0.03, sin(b) * r), 0.015, _stick_m)
	_glyph_on(RINGS + Vector3(0, 0.05, 0), 0.0, 0.016, "g_rings", false, true,
		LINES["bluff"]["text1"], true, Color(0.8, 0.5, 0.3))
	var sand_decal := decal_mat(Tex.sand(), Color(0.5, 0.42, 0.32), 1.0)
	var fp := RINGS
	for i in 22:
		fp += Vector3(2.2, 0, -1.0)
		floor_quad(Vector2(0.3, 0.45), fp + Vector3(0, 0.03, (i % 2) * 0.5), -1.1, sand_decal)
	interactable("rings", LINES["bluff"]["text2"], RINGS + Vector3(0, 0.3, 0), Vector3(2.4, 0.6, 2.4),
		LINES["bluff"]["text3"], false)


## The basin between the bluff and the cliff: the width of the approach.
## Rock outcrops to duck behind, drifts, and the debris of a second wreck
## that went over the edge years ago, strewn toward the door.
func _basin() -> void:
	# outcrops: stacked, leaning blocks, solid, in two bands with the routes between
	var outcrops := [Vector3(48.0, 0, -520.0), Vector3(56.0, 0, -536.0), Vector3(47.0, 0, -566.0),
		Vector3(58.0, 0, -598.0), Vector3(50.0, 0, -612.0), Vector3(62.0, 0, -548.0), Vector3(44.0, 0, -590.0)]
	for o: Vector3 in outcrops:
		for k in rng.randi_range(3, 5):
			var sz := Vector3(rng.randf_range(1.6, 3.6), rng.randf_range(1.0, 2.6), rng.randf_range(1.4, 3.2))
			var r := box(sz, o + Vector3(rng.randf_range(-1.6, 1.6), sz.y / 2.0 - 0.2 + k * 0.3, rng.randf_range(-1.6, 1.6)), _rock, k < 2)
			r.rotation = Vector3(rng.randf_range(-0.2, 0.2), rng.randf() * TAU, rng.randf_range(-0.25, 0.25))
	# low drifts against the outcrops, the sand ribbed by the wind
	for i in 22:
		var r := rng.randf_range(3.0, 7.0)
		var d := sphere(r, Vector3(rng.randf_range(38, 68), -r * 0.6 + rng.randf_range(0.3, 0.9), rng.randf_range(-640, -490)), _sand, 10)
		d.scale = Vector3(1.8, 0.6, 1.0)
		d.rotation.y = rng.randf_range(-0.4, 0.4)
	# the second wreck: a fleet van that went over the edge, on its side,
	# its load thrown across the sand toward the cliff
	var v := Node3D.new()
	v.position = Vector3(46.0, 0.9, -626.0)
	v.rotation = Vector3(0.0, 2.3, 1.35)
	add_child(v)
	v.add_child(Car.build(self, Color(0.3, 0.3, 0.3), {"van": true, "head": mat(Color(0.2, 0.2, 0.18), 0.5), "tail": mat(Color(0.2, 0.05, 0.05), 0.5)}))
	var v2 := Node3D.new()
	v2.position = Vector3(46.0, 0, -626.0)
	v2.rotation.y = 2.3
	add_child(v2)
	solid_box(Vector3(5.2, 2.0, 2.4), Vector3(0, 1.0, 0), v2)
	var van_it := interactable("van_wreck", LINES["basin"]["text1"], Vector3(0, 1.1, 0), Vector3(5.4, 2.4, 2.8),
		LINES["basin"]["text2"], false, v2)
	van_it.set_meta("hackable", true)
	var crate := mat(Color(0.45, 0.42, 0.36), 0.9)
	var k := _kit_mats()
	for i in 16:
		var p := Vector3(46.0, 0, -626.0) + Vector3(rng.randf_range(2, 22), 0, rng.randf_range(-6, 30))
		if i % 4 == 0:
			var c := box(Vector3(1.2, 0.8, 0.9), p + Vector3(0, 0.4, 0), crate, true)
			c.rotation = Vector3(rng.randf_range(-0.3, 0.3), rng.randf() * TAU, rng.randf_range(-0.2, 0.2))
		elif i % 4 == 1:
			var t := cyl(0.34, 0.34, 0.24, p + Vector3(0, 0.34, 0), mat(Color(0.03, 0.03, 0.03), 0.9), 12)
			t.rotation.x = PI / 2.0 + rng.randf_range(-0.3, 0.3)
		elif i % 4 == 2:
			var dr := box(Vector3(1.1, 0.05, 0.9), p + Vector3(0, 0.03, 0), k["metal"])
			dr.rotation.y = rng.randf() * TAU
		else:
			# a frames case burst open, the little glass eyes of them in the sand
			box(Vector3(0.5, 0.2, 0.35), p + Vector3(0, 0.1, 0), k["dark"])
			for j in 5:
				box(Vector3(0.14, 0.03, 0.04), p + Vector3(rng.randf_range(-0.8, 0.8), 0.03, rng.randf_range(-0.8, 0.8)), k["dark"]).rotation.y = rng.randf() * TAU
	# a hollow where the drifts meet, knee-deep, where something was dragged
	var sand_decal := decal_mat(Tex.sand(), Color(0.45, 0.38, 0.3), 1.0)
	for i in 12:
		floor_quad(Vector2(0.9, 2.2), Vector3(52.0 + i * 1.4, 0.03, -600.0 + i * 1.9), 0.6, sand_decal)


## The cliff to the east, and the door carved into it with the Eye scorched
## into the metal. "No handles. No keypad. No signage."
func _cliff_and_door() -> void:
	var dark_rock := pbr("concrete", Vector3(1, 1, 1) / 3.0, true, Color(0.3, 0.25, 0.22), 1.0)
	for k in range(-11, 11):
		var zc := DOOR.z + k * 14.0
		var h := rng.randf_range(22.0, 34.0)
		var d := rng.randf_range(6.0, 12.0)
		if k == 0:
			# the passage runs into the rock here: rock above it and either side
			box(Vector3(13.0, h - 5.4, 14.0), Vector3(CLIFF_X + 6.5, 5.4 + (h - 5.4) / 2.0, zc), dark_rock)
			for sd: float in [-1.0, 1.0]:
				box(Vector3(13.0, 5.6, 4.5), Vector3(CLIFF_X + 6.5, 2.7, zc + sd * 4.75), dark_rock, true)
			box(Vector3(6.0, 5.6, 14.0), Vector3(CLIFF_X + 16.0, 2.7, zc), dark_rock)
		else:
			var b := box(Vector3(d, h, 14.0), Vector3(CLIFF_X + d / 2.0 + rng.randf_range(-1.5, 1.5), h / 2.0 - 1.0, zc), dark_rock, true)
			b.rotation.y = rng.randf_range(-0.04, 0.04)
		# ledges and overhangs
		var l := box(Vector3(rng.randf_range(3.0, 6.0), rng.randf_range(1.0, 3.0), 10.0), Vector3(CLIFF_X - 1.0, rng.randf_range(7.0, h - 4.0), zc), dark_rock)
		l.rotation.z = rng.randf_range(-0.2, 0.2)
		if k != 0:
			box(Vector3(rng.randf_range(2.0, 4.0), rng.randf_range(0.6, 1.4), rng.randf_range(2.0, 5.0)), Vector3(CLIFF_X - rng.randf_range(0.5, 2.5), 0.3, zc + rng.randf_range(-6, 6)), _rock)
	# scree at the foot
	for i in 40:
		var p := Vector3(CLIFF_X - rng.randf_range(1.0, 9.0), 0.1, rng.randf_range(-700, -440))
		if absf(p.z - DOOR.z) < 4.0:
			continue
		var r := box(Vector3(rng.randf_range(0.3, 1.2), rng.randf_range(0.2, 0.7), rng.randf_range(0.3, 1.0)), p, _rock)
		r.rotation.y = rng.randf() * TAU
	# the doorway: a cut in the rock, the slab inside it, the Eye on the slab
	var frame := mat(Color(0.12, 0.11, 0.1), 0.8, 0.2)
	box(Vector3(1.0, 5.2, 0.5), DOOR + Vector3(0.0, 2.6, -2.3), frame)
	box(Vector3(1.0, 5.2, 0.5), DOOR + Vector3(0.0, 2.6, 2.3), frame)
	box(Vector3(1.0, 0.5, 5.1), DOOR + Vector3(0.0, 5.0, 0), frame)
	box(Vector3(1.2, 0.3, 5.6), DOOR + Vector3(0.0, 0.1, 0), frame)
	# the passage behind, black, with a red breath at the far end
	box(Vector3(14.0, 5.0, 0.4), DOOR + Vector3(7.0, 2.5, -2.3), frame)
	box(Vector3(14.0, 5.0, 0.4), DOOR + Vector3(7.0, 2.5, 2.3), frame)
	box(Vector3(14.0, 0.4, 5.0), DOOR + Vector3(7.0, 4.9, 0), frame)
	box(Vector3(14.0, 0.2, 5.0), DOOR + Vector3(7.0, 0.05, 0), mat(Color(0.05, 0.04, 0.04), 0.3, 0.2))
	box(Vector3(0.4, 5.0, 5.0), DOOR + Vector3(13.8, 2.5, 0), frame)
	door_light = light(DOOR + Vector3(9.0, 2.0, 0), PSYON_GREEN, 0.0, 10.0, false)
	# the portal: a green-lit frame round the cut, Psyon's green, the only
	# colour out here that isn't sand or blood
	var green := newglow(PSYON_GREEN, 1.4)
	door_green_m = green
	box(Vector3(0.1, 4.9, 0.12), DOOR + Vector3(-0.52, 2.5, -2.36), green)
	box(Vector3(0.1, 4.9, 0.12), DOOR + Vector3(-0.52, 2.5, 2.36), green)
	box(Vector3(0.1, 0.12, 4.9), DOOR + Vector3(-0.52, 4.98, 0), green)
	var gl := light(DOOR + Vector3(-2.0, 2.6, 0), PSYON_GREEN, 1.6, 12.0, false)
	gl.light_size = 0.5
	# the ORA panels either side, on posts: one dark and waiting, one that
	# took its offering and bled for it
	var k2 := _kit_mats()
	for sd: float in [-1.0, 1.0]:
		var pp := DOOR + Vector3(-1.6, 0, sd * 3.4)
		box(Vector3(0.18, 1.3, 0.18), pp + Vector3(0, 0.65, 0), k2["metal"], true)
		box(Vector3(0.12, 0.6, 0.42), pp + Vector3(0, 1.55, 0), k2["dark"], true)
		if sd > 0.0:
			var red := newglow(Color(1.0, 0.1, 0.08), 2.2)
			quad(Vector2(0.34, 0.46), pp + Vector3(-0.065, 1.57, 0), -PI / 2.0, red)
			var drip := mat(Color(0.35, 0.03, 0.02), 0.3)
			for i in 5:
				stick(pp + Vector3(-0.07, 1.3, rng.randf_range(-0.16, 0.16)), pp + Vector3(-0.07, rng.randf_range(0.0, 0.9), rng.randf_range(-0.2, 0.2)), 0.012, drip)
			var pool := decal_mat(Tex.blood(23), Color(0.55, 0.06, 0.04), 0.3)
			floor_quad(Vector2(1.4, 1.1), pp + Vector3(-0.3, 0.025, 0.1), 0.4, pool)
			light(pp + Vector3(-0.4, 1.5, 0), Color(1.0, 0.1, 0.08), 0.9, 4.0, false)
			var pit := interactable("door_panel", LINES["cliff_and_door"]["panel_prompt"], pp + Vector3(0, 1.2, 0), Vector3(0.5, 1.6, 0.6), LINES["cliff_and_door"]["panel_bleed_scan"], false)
			pit.set_meta("hackable", true)
		else:
			quad(Vector2(0.34, 0.46), pp + Vector3(-0.065, 1.57, 0), -PI / 2.0, newglow(PSYON_GREEN * 0.5, 0.6))
			var pit2 := interactable("door_panel", LINES["cliff_and_door"]["panel_prompt"], pp + Vector3(0, 1.2, 0), Vector3(0.5, 1.6, 0.6), LINES["cliff_and_door"]["panel_scan"], false)
			pit2.set_meta("hackable", true)
	# the sigil on the ground before the door: a ring, a cross in it, old blood
	var sig := newglow(PSYON_GREEN * 0.6, 0.5)
	for r: float in [2.6, 3.2]:
		var tm2 := TorusMesh.new()
		tm2.inner_radius = r - 0.06
		tm2.outer_radius = r
		tm2.rings = 36
		tm2.ring_segments = 4
		mesh(tm2, DOOR + Vector3(-4.2, 0.02, 0), sig)
	box(Vector3(5.2, 0.01, 0.06), DOOR + Vector3(-4.2, 0.02, 0), sig)
	box(Vector3(0.06, 0.01, 5.2), DOOR + Vector3(-4.2, 0.02, 0), sig)
	var old_blood := decal_mat(Tex.blood(29), Color(0.45, 0.05, 0.04), 0.5)
	for i in 4:
		floor_quad(Vector2(rng.randf_range(0.8, 1.6), rng.randf_range(0.6, 1.2)), DOOR + Vector3(-4.2 + rng.randf_range(-2.2, 2.2), 0.03, rng.randf_range(-2.2, 2.2)), rng.randf() * TAU, old_blood)
	# the scripture, in red, on the rock over the door
	var sc_root := Node3D.new()
	sc_root.position = DOOR + Vector3(-0.6, 6.4, 0)
	sc_root.rotation.y = -PI / 2.0
	add_child(sc_root)
	var scr: Array = LINES["cliff_and_door"]["scripture"]
	for i in scr.size():
		var sz := 0.42 if i == 0 else 0.26
		neon_text(str(scr[i]), Vector3(0, 1.6 - i * 0.55, 0), 0.0, sz, Color(1.0, 0.25, 0.2), 2.4, sc_root)
	# the green reaches a little way down the passage
	light(DOOR + Vector3(4.0, 2.4, 0), PSYON_GREEN, 1.0, 7.0, false)
	door_slab = Node3D.new()
	door_slab.position = DOOR + Vector3(0.2, 0, 0)
	add_child(door_slab)
	var metal := mat(Color(0.2, 0.19, 0.18), 0.45, 0.8)
	var slab := box(Vector3(0.3, 4.6, 4.0), Vector3(0, 2.4, 0), metal, false, door_slab)
	no_batch.append(slab)
	# the Eye scorched into it: rings burnt black, a pupil that is not quite dark
	door_eye_m = newglow(Color(0.5, 0.06, 0.03), 0.35)
	for r: float in [0.55, 1.05, 1.5]:
		var tm := TorusMesh.new()
		tm.inner_radius = r - 0.07
		tm.outer_radius = r
		tm.rings = 24
		tm.ring_segments = 6
		var ring := mesh(tm, Vector3(-0.16, 2.3, 0), door_eye_m, door_slab)
		ring.rotation.z = PI / 2.0
		no_batch.append(ring)
	var pupil := cyl(0.34, 0.34, 0.04, Vector3(-0.16, 2.3, 0), door_eye_m, 20, door_slab)
	pupil.rotation.z = PI / 2.0
	no_batch.append(pupil)
	var scorch := mat(Color(0.04, 0.03, 0.03), 1.0)
	for i in 14:
		var a := rng.randf() * TAU
		var r := rng.randf_range(1.5, 2.0)
		var s := box(Vector3(0.02, rng.randf_range(0.1, 0.5), 0.08), Vector3(-0.16, 2.3 + sin(a) * r, cos(a) * r), scorch, false, door_slab)
		s.rotation.x = a
	door_it = interactable("door", LINES["cliff_and_door"]["text1"], DOOR + Vector3(0.0, 2.3, 0), Vector3(1.4, 4.6, 4.4),
		LINES["cliff_and_door"]["text2"], true)
	door_it.set_meta("exit", true)


## Two of the eyeless, standing among the rocks either side of the door,
## facing it. Without the frames they are statues. With the frames on they
## turn their sockets toward Carl, wherever he goes.
func _watchers() -> void:
	var blood := mat(Color(0.3, 0.03, 0.02), 0.6)
	var socket := mat(Color(0.02, 0.01, 0.01), 1.0)
	for pair in [[Vector3(63.0, 0, -561.0), 0.0], [Vector3(61.5, 0, -592.0), 0.0]]:
		var pos: Vector3 = pair[0]
		var w := figure(Color(0.22, 0.2, 0.18) * rng.randf_range(0.7, 1.2), Color(0.72, 0.56, 0.44), {"arms": true, "knees": true, "long_coat": true})
		w.position = pos
		add_child(w)
		turn_to(w, DOOR + Vector3(0, 1.7, 0))
		w.set_meta("guard", true)
		w.set_meta("base_yaw", w.rotation.y)
		var head: Node3D = w.get_meta("head")
		# the sockets, and what ran out of them, dried down the face and the coat
		for sd: float in [-1.0, 1.0]:
			sphere(0.022, Vector3(sd * 0.034, 0.02, -0.098), socket, 8, head)
			box(Vector3(0.012, 0.09, 0.006), Vector3(sd * 0.034, -0.04, -0.102), blood, false, head)
		box(Vector3(0.1, 0.5, 0.01), Vector3(0.0, 1.25, -0.14), blood, false, w)
		for a in w.get_meta("arms"):
			(a as Node3D).rotation.x = 0.05
		var it := person("watcher", LINES["watchers"]["text1"], w, LINES["watchers"]["text2"])
		it.set_meta("guard", true)
		watchers.append(w)


## The shacks at the checkpoint: people live at the edge of every zone now,
## under plastic and corrugated sheet, by a fire in a drum. Two of them
## watch the fleet car go by without getting up.
func _shacks() -> void:
	var k := _kit_mats()
	var sheet := mat(Color(0.35, 0.3, 0.26), 0.8, 0.4)
	var plastic := newmat(Color(0.25, 0.35, 0.55, 0.7), 0.5)
	plastic.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	plastic.cull_mode = BaseMaterial3D.CULL_DISABLED
	for i in 3:
		var o := Vector3(-11.5 - (i % 2) * 2.5, 0, -96.0 - i * 6.5)
		box(Vector3(3.2, 0.1, 3.0), o + Vector3(0, 0.05, 0), k["plinth"])
		for c: Vector3 in [Vector3(-1.4, 1.0, -1.3), Vector3(1.4, 1.1, -1.3), Vector3(-1.4, 0.9, 1.3), Vector3(1.4, 1.0, 1.3)]:
			box(Vector3(0.08, c.y * 2.0, 0.08), o + Vector3(c.x, c.y, c.z), k["rust"])
		var roof := box(Vector3(3.6, 0.04, 3.4), o + Vector3(0, 2.05, 0), sheet if i != 1 else plastic, false)
		roof.rotation.z = 0.1
		box(Vector3(3.2, 1.8, 0.04), o + Vector3(0, 1.0, -1.5), sheet, true)
		box(Vector3(0.04, 1.8, 3.0), o + Vector3(-1.6, 1.0, 0), plastic if i != 1 else sheet, true)
		box(Vector3(0.9, 0.5, 0.6), o + Vector3(0.8, 0.25, 0.6), mat(Color(0.5, 0.4, 0.3), 0.9))
	# the fire drum, and the light it throws on the booth's blind side
	var drum := Vector3(-9.5, 0, -103.0)
	cyl(0.3, 0.3, 0.9, drum + Vector3(0, 0.45, 0), k["rust"], 10)
	var fl := light(drum + Vector3(0, 1.3, 0), Color(1.0, 0.45, 0.12), 2.4, 9.0, false)
	flickers.append(fl)
	box(Vector3(0.3, 0.3, 0.3), drum + Vector3(0, 0.95, 0), glow(Color(1.0, 0.4, 0.1), 3.0))
	# the people: one by the fire, one asleep under the plastic
	var v1 := figure(Color(0.3, 0.26, 0.2), Color(0.7, 0.55, 0.42), {"arms": true, "knees": true, "hair": Color(0.3, 0.3, 0.3)})
	v1.position = drum + Vector3(-1.2, 0.05, 0.6)
	add_child(v1)
	turn_to(v1, Vector3(LANE_X, 1.0, -103.0))
	v1.set_meta("vagrant", true)
	var p1 := person("vagrant", LINES["shacks"]["text1"], v1, LINES["shacks"]["text2"])
	p1.set_meta("vagrant", true)
	vagrants.append(v1)
	var v2 := figure(Color(0.2, 0.22, 0.26), Color(0.74, 0.6, 0.48), {"arms": true, "knees": true, "long_hair": true, "hair": Color(0.1, 0.08, 0.06)})
	v2.position = Vector3(-14.0, 0.05, -109.0) + Vector3(0, 0.5, 0)
	v2.rotation = Vector3(0, 0.4, -PI / 2.0)  # lying on her side under the sheet
	add_child(v2)
	Anim.sit(v2, 0.0)
	v2.set_meta("vagrant", true)
	var p2 := person("vagrant2", LINES["shacks"]["text3"], v2, LINES["shacks"]["text4"])
	p2.set_meta("vagrant", true)
	vagrants.append(v2)
	var sign := label(LINES["shacks"]["text5"], Vector3(-9.8, 1.4, -98.0), PI / 2.0 - 0.3, 0.006, Color(0.8, 0.75, 0.7), self, false)
	sign.double_sided = true
	box(Vector3(0.04, 0.6, 0.8), Vector3(-9.85, 1.4, -98.0), mat(Color(0.5, 0.42, 0.3), 0.9)).rotation.y = PI / 2.0 - 0.3


## The flats themselves: dunes, dead brush, the odd rock, and nothing else
## for miles. Kept away from the road and the path to the door.
func _desert() -> void:
	var brush := mat(Color(0.32, 0.26, 0.18), 1.0)
	for i in 70:
		var p := Vector3(rng.randf_range(-320, 320), 0, rng.randf_range(-780, 60))
		if absf(p.x) < 16.0 or (p.x > 30.0 and p.z < -420.0):
			continue
		var d := sphere(rng.randf_range(6.0, 16.0), p - Vector3(0, rng.randf_range(4.0, 9.0), 0), _sand, 10)
		d.scale = Vector3(rng.randf_range(1.2, 2.4), 0.5, 1.0)
		d.rotation.y = rng.randf() * TAU
	for i in 120:
		var p := Vector3(rng.randf_range(-200, 200), 0, rng.randf_range(-700, 40))
		if absf(p.x) < 7.0 or (p.x > 60.0 and p.z < -420.0):
			continue
		for k in rng.randi_range(2, 5):
			var a := rng.randf() * TAU
			stick(p, p + Vector3(cos(a) * 0.4, rng.randf_range(0.4, 1.1), sin(a) * 0.4), 0.02, brush)
	for i in 40:
		var p := Vector3(rng.randf_range(-200, 200), 0.1, rng.randf_range(-700, -100))
		if absf(p.x) < 7.0:
			continue
		var r := box(Vector3(rng.randf_range(0.5, 2.0), rng.randf_range(0.3, 1.0), rng.randf_range(0.5, 1.5)), p, _rock)
		r.rotation = Vector3(0, rng.randf() * TAU, rng.randf_range(-0.2, 0.2))
	# the frames' idea of a road: a few survey stakes with dead tags, then nothing
	var tag := mat(Color(0.8, 0.3, 0.6), 0.7)
	for i in 6:
		var p := Vector3(6.5, 0, -440.0 - i * 12.0)
		box(Vector3(0.05, 0.9, 0.05), p + Vector3(0, 0.45, 0), mat(Color(0.5, 0.45, 0.4), 0.8))
		box(Vector3(0.02, 0.1, 0.25), p + Vector3(0, 0.85, 0), tag)


## Three lights high over the flats, drifting. "It was watching me."
func _drones() -> void:
	for i in 3:
		var d := Node3D.new()
		d.position = Vector3(rng.randf_range(-80, 80), rng.randf_range(40, 70), rng.randf_range(-600, -300))
		add_child(d)
		var b := box(Vector3(0.4, 0.4, 0.4), Vector3.ZERO, glow(Color(1, 0.1, 0.08), 4.0), false, d)
		blinkers.append(b)
		d.set_meta("phase", rng.randf() * TAU)
		drones.append(d)


func _bounds() -> void:
	solid_box(Vector3(2, 40, 1200), Vector3(-230, 20, -350))
	solid_box(Vector3(2, 40, 1200), Vector3(230, 20, -350))
	solid_box(Vector3(500, 40, 2), Vector3(0, 20, 80))
	solid_box(Vector3(500, 40, 2), Vector3(0, 20, -800))


# ------------------------------------------------------------------ the cars

## The company car, from the driver's seat (the same car as Drive.gd), with
## its headlights on this time.
func _car() -> void:
	car = Node3D.new()
	car.position = Vector3(LANE_X, 0, 40.0)
	add_child(car)
	var trim := mat(Color(0.12, 0.12, 0.13), 0.6)
	var paint := mat(Color(0.75, 0.78, 0.8), 0.25, 0.6)
	box(Vector3(1.9, 0.25, 1.8), Vector3(0, 0.75, -1.9), paint, false, car)
	box(Vector3(1.7, 0.22, 0.55), Vector3(0, 0.88, -0.75), trim, false, car)
	box(Vector3(1.7, 0.06, 0.3), Vector3(0, 1.0, -0.62), mat(Color(0.18, 0.18, 0.2), 0.5), false, car)
	var wheel := TorusMesh.new()
	wheel.inner_radius = 0.15
	wheel.outer_radius = 0.18
	wheel.rings = 20
	wheel.ring_segments = 6
	var wm := mesh(wheel, Vector3(SEAT.x, 0.98, -0.42), trim, car)
	wm.rotation.x = PI / 2.0 - 0.45
	box(Vector3(0.04, 0.04, 0.3), Vector3(SEAT.x, 0.93, -0.55), trim, false, car)
	for x: float in [-0.82, 0.82]:
		stick(Vector3(x, 0.98, -0.95), Vector3(x, 1.8, -0.2), 0.035, trim, car)
		stick(Vector3(x, 0.98, 0.85), Vector3(x, 1.8, 0.65), 0.04, trim, car)
		box(Vector3(0.06, 0.06, 0.9), Vector3(x, 1.8, 0.22), trim, false, car)
		box(Vector3(0.08, 0.5, 2.0), Vector3(x * 1.02, 0.7, 0.0), mat(Color(0.2, 0.2, 0.22), 0.7), false, car)
	box(Vector3(1.7, 0.05, 0.9), Vector3(0, 1.82, 0.22), mat(Color(0.25, 0.25, 0.26), 0.9), false, car)
	box(Vector3(1.7, 0.6, 0.1), Vector3(0, 1.0, 1.0), trim, false, car)
	# the fleet screen, the microphone that is never off, and the map on the dash
	dash_m = newglow(Color(0.25, 0.55, 0.5), 1.0)
	var scr := quad(Vector2(0.3, 0.17), Vector3(0.12, 1.06, -0.6), 0.0, dash_m, car)
	scr.rotation.x = -0.5
	dash_label = label(LINES["car"]["text1"], Vector3(0.12, 1.06, -0.592), 0.0, 0.00045, Color(0.05, 0.08, 0.08), car, false)
	dash_label.rotation.x = -0.5
	dash_label.font_size = 48
	var mic := box(Vector3(0.02, 0.02, 0.01), Vector3(-0.05, 1.04, -0.6), glow(Color(1, 0.1, 0.1), 3.0), false, car)
	mic.rotation.x = -0.5
	label("MIC", Vector3(-0.05, 1.065, -0.597), 0.0, 0.00025, Color(0.6, 0.15, 0.1), car, false).rotation.x = -0.5
	# the red X on the paper map she left, taped to the dash
	var map := quad(Vector2(0.22, 0.16), Vector3(-0.55, 1.03, -0.6), 0.0, mat(Color(0.75, 0.7, 0.55), 0.95), car)
	map.rotation.x = -0.5
	var xm := mat(Color(0.7, 0.05, 0.05), 0.8)
	for s: float in [-0.6, 0.6]:
		var l := box(Vector3(0.05, 0.004, 0.004), Vector3(-0.5, 1.045, -0.605), xm, false, car)
		l.rotation = Vector3(-0.5, 0, s)
	# the headlights: the only thing lighting the road from here on
	for x: float in [-0.7, 0.7]:
		var sl := SpotLight3D.new()
		sl.position = Vector3(x, 0.7, -2.0)
		sl.rotation.x = deg_to_rad(-6.0)
		sl.light_color = Color(0.95, 0.9, 0.8)
		sl.light_energy = 6.0
		sl.spot_range = 55.0
		sl.spot_angle = 32.0
		sl.spot_attenuation = 0.8
		sl.shadow_enabled = false
		car.add_child(sl)
		headlights.append(sl)
		box(Vector3(0.36, 0.09, 0.05), Vector3(x, 0.66, -2.78), glow(Color(1, 0.97, 0.9), 3.0), false, car)
	# the body, for when Carl walks round it
	var shell := Car.build(self, Color(0.75, 0.78, 0.8), {"plate": "PSF 0086"})
	shell.position = Vector3(0, 0, 0.1)
	shell.visible = false
	car.add_child(shell)
	car.set_meta("shell", shell)
	my_car_it = interactable("my_car", LINES["car"]["text2"], Vector3(0, 1.0, 0), Vector3(2.0, 1.8, 4.6),
		LINES["car"]["text3"], true, car)
	my_car_it.set_meta("hackable", true)
	set_active(my_car_it, false)


## "Perched at the edge of a rocky bluff, like a fossil waiting to be
## uncovered: a Psyonic-issued sedan. No sand on the tires. No dust on the
## windshield. Recently abandoned."
func _lynx_sedan() -> void:
	var s := Node3D.new()
	s.position = SEDAN
	s.rotation.y = -0.55
	add_child(s)
	s.add_child(Car.build(self, Color(0.82, 0.84, 0.86), {"plate": "PSF 0112", "head": mat(Color(0.3, 0.3, 0.28), 0.4), "tail": mat(Color(0.35, 0.06, 0.06), 0.5)}))
	solid_box(Vector3(1.9, 1.5, 4.5), Vector3(0, 0.75, 0), s)
	# the driver's door left open, the cabin light still on, the console rebooting
	var door := Node3D.new()
	door.position = Vector3(-0.96, 0.6, -0.95)
	door.rotation.y = -1.0
	s.add_child(door)
	box(Vector3(0.05, 0.6, 1.2), Vector3(0, 0, 0.6), mat(Color(0.82, 0.84, 0.86), 0.28, 0.55), false, door)
	box(Vector3(0.03, 0.45, 1.0), Vector3(0, 0.55, 0.6), mat(Color(0.03, 0.045, 0.06), 0.04, 0.6), false, door)
	var cab := OmniLight3D.new()
	cab.position = Vector3(0, 1.2, -0.3)
	cab.light_color = Color(1.0, 0.95, 0.8)
	cab.light_energy = 0.7
	cab.omni_range = 3.0
	cab.shadow_enabled = false
	s.add_child(cab)
	var console := newglow(Color(0.2, 0.5, 0.45), 1.2)
	var cq := quad(Vector2(0.28, 0.16), Vector3(0.0, 1.05, -0.6), 0.0, console, s)
	cq.rotation.x = -0.5
	flickers.append(cq)
	sedan_it = interactable("sedan", LINES["lynx_sedan"]["text1"], Vector3(0, 1.0, 0), Vector3(2.2, 1.8, 4.8),
		LINES["lynx_sedan"]["text2"], false, s)
	sedan_it.set_meta("hackable", true)
	# a drift of nothing: the sand round the tyres is untouched, the tyres clean
	var sand_decal := decal_mat(Tex.sand(), Color(0.55, 0.45, 0.33), 1.0)
	for i in 8:
		floor_quad(Vector2(rng.randf_range(0.8, 1.8), rng.randf_range(0.6, 1.2)), SEDAN + Vector3(rng.randf_range(-3, 3), 0.03, rng.randf_range(-3.5, 3.5)), rng.randf() * TAU, sand_decal)


# ------------------------------------------------------------------ the drive

func intro() -> void:
	_run()


func _until(z: float) -> void:
	while car.position.z > z:
		await get_tree().process_frame


## Slow to a stop at z, and wait there.
func _stop_at(z: float) -> void:
	stop_z = z
	await _until(z + 0.5)
	while speed > 0.05:
		await get_tree().process_frame


func _go(v: float) -> void:
	stop_z = -9999.0
	want_speed = v


func _run() -> void:
	var ui = main.ui
	var p = main.player
	var f: Dictionary = main.flags
	p.seated = true
	p.crouch = 0.5
	_driving = true
	await get_tree().create_timer(1.0).timeout
	if f.has("lynx_apartment_done") or f.has("lynxflat_done"):
		await ui.think(LINES["run"]["think1"])
	else:
		await ui.think(LINES["run"]["think2"])
	await ui.think(LINES["run"]["think3"])
	ui.close()
	_go(15.0)
	# the sign
	await _stop_at(-56.0)
	await p.face(Vector3(8.4, 3.0, -62.0), 1.0)
	await ui.think(LINES["run"]["think4"])
	ui.close()
	_go(12.0)
	# the guard
	await _stop_at(-107.0)
	await p.face(Vector3(8.0, 1.6, -110.0), 1.0)
	await ui.think(LINES["run"]["think5"])
	ui.close()
	main.add_connection(1.0, LINES["run"]["text1"])
	await p.face(Vector3(-9.5, 1.0, -103.0), 0.8)
	await ui.think(LINES["run"]["think6"])
	ui.close()
	_go(8.0)
	await p.face(Vector3(LANE_X, 1.2, -200.0), 1.2)
	# the gate
	await _until(-122.0)
	await _gate()
	_go(14.0)
	# deep sand
	await _until(-175.0)
	want_speed = 7.0
	await _until(-205.0)
	main.ui.glitch(0.5, 1.2)
	main.play("glitch", -8.0)
	dash_m.emission = Color(0.6, 0.3, 0.05)
	dash_label.text = LINES["run"]["text2"]
	p.shake(0.3)
	await _stop_at(-218.0)
	await ui.think(LINES["run"]["think7"])
	ui.close()
	ui.show_toast(LINES["run"]["toast1"], 4.0)
	main.add_connection(2.0, "off the map")
	_go(10.0)
	# the wreck
	await _stop_at(-284.0)
	await p.face(Vector3(-8.5, 1.2, -292.0), 1.0)
	await ui.think(LINES["run"]["think8"])
	ui.close()
	_go(13.0)
	await p.face(Vector3(LANE_X, 1.2, -500.0), 1.4)
	# the road cracks, the horizon opens
	await _until(-400.0)
	await main.ui.caption(LINES["run"]["cap1"], 5.0)
	main.ui.glitch(0.7, 0.8)
	main.play("static", -10.0)
	await main.ui.caption(LINES["run"]["cap2"], 5.0)
	main.play("ding", -10.0, 1.2)
	dash_m.emission = Color(0.25, 0.55, 0.5)
	dash_label.text = LINES["run"]["text3"]
	await main.ui.caption(LINES["run"]["cap3"], 3.0)
	await _stop_at(PARK_Z)
	await p.face(SEDAN + Vector3(0, 1.0, 0), 1.2)
	await ui.think(LINES["run"]["think9"])
	await ui.say(LINES["run"]["say1"][0], LINES["run"]["say1"][1])
	ui.close()
	await _get_out()


## "The barrier was up. As I passed under it the dash chimed, and the trip
## log, the whole log, cleared itself to zero."
func _gate() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	main.play("ding", -6.0, 0.8)
	dash_label.text = LINES["gate"]["text1"]
	gate_lamp.emission = Color(1.0, 0.3, 0.1)
	await _stop_at(-128.0)
	await ui.think(LINES["gate"]["think1"])
	var pick: int = await ui.choose(LINES["gate"]["choices1"])
	if pick == 0:
		await ui.think(LINES["gate"]["think2"])
		ui.close()
		f["gate_passed"] = true
		main.add_connection(2.0, LINES["gate"]["text2"])
		return
	ui.close()
	# back under the gantry, the engine running, the chime going until it stops
	f["gate_turned_back"] = true
	main.flags["cinematic"] = true
	want_speed = 0.0
	stop_z = -9999.0
	var tw := create_tween()
	tw.tween_property(car, "position:z", -116.0, 2.6).set_trans(Tween.TRANS_SINE)
	await tw.finished
	await p.face(Vector3(0, 5.2, -124.0), 1.0)
	for i in 5:
		main.play("ding", -8.0, 0.8)
		await get_tree().create_timer(0.9).timeout
	await ui.think(LINES["gate"]["think3"])
	await ui.think(LINES["gate"]["think4"])
	ui.close()
	main.flags.erase("cinematic")
	f["gate_passed"] = true
	await p.face(Vector3(LANE_X, 1.2, -300.0), 1.0)


## Out of the car at the bluff: the car becomes a thing in the world, and
## Carl stands beside it.
func _get_out() -> void:
	var p = main.player
	_driving = false
	_arrived = true
	want_speed = 0.0
	speed = 0.0
	if _engine:
		_engine.stop()
	main.play("off", -10.0, 0.7)
	main.play("door", -6.0)
	(car.get_meta("shell") as Node3D).visible = true
	solid_box(Vector3(1.9, 1.5, 4.5), Vector3(0, 0.75, 0.1), car)
	set_active(my_car_it, true)
	p.seated = false
	p.crouch = 0.0
	p.position = car.position + Vector3(-1.9, 0.1, 0.5)
	p.yaw = -0.6
	p.rotation.y = p.yaw
	p.pitch = 0.0
	p.velocity = Vector3.ZERO
	main.update_hud()
	await main.ui.think(LINES["get_out"]["think1"])
	main.ui.close()


# ------------------------------------------------------------------ on foot

func interact(node: Object) -> bool:
	var ui = main.ui
	match str(node.get_meta("id")):
		"my_car":
			await _my_car()
		"sedan":
			await _sedan()
		"rings":
			await ui.think(LINES["interact"]["think1"])
			if not main.frames_on:
				await ui.think(LINES["interact"]["think2"])
			else:
				main.ui.show_toast(LINES["interact"]["toast1"], 3.0)
		"door":
			await _door()
		"watcher":
			await ui.think(LINES["interact"]["think3"])
			if main.frames_on:
				await ui.think(LINES["interact"]["think4"])
				main.add_connection(1.0, LINES["interact"]["text1"])
			else:
				await ui.think(LINES["interact"]["think5"])
		"van_wreck":
			await ui.think(LINES["interact"]["think6"])
		"vagrant", "vagrant2":
			await ui.think(LINES["interact"]["think7"])
		"booth_terminal", "gate_box", "gate_camera":
			await ui.think(LINES["interact"]["think8"])
		"door_panel":
			await ui.think(LINES["interact"]["panel"])
		"sign", "guard", "gate", "deep_sand", "wreck":
			await ui.think(LINES["interact"]["think9"])
		_:
			return false
	return true


## "The corporate bubble of sanity. I could still get back in and drive home."
func _my_car() -> void:
	var ui = main.ui
	var p = main.player
	await ui.think(LINES["my_car"]["think1"])
	var pick: int = await ui.choose(LINES["my_car"]["choices1"])
	ui.close()
	if pick == 0:
		return
	main.flags["cinematic"] = true
	main.play("door", -6.0)
	await ui.fade_to(1.0, 0.6)
	# a minute behind the wheel with the engine running and the lights on
	# the sedan, the trip log at zero, the microphone recording the silence
	p.seated = true
	p.crouch = 0.5
	p.position = car.position + SEAT
	p.yaw = 0.0
	p.rotation.y = 0.0
	p.pitch = 0.0
	if _engine:
		_engine.play()
	main.play("on", -10.0, 0.7)
	await ui.fade_to(0.0, 0.6)
	dash_label.text = LINES["my_car"]["text1"]
	var tw := create_tween()
	tw.tween_property(p, "pitch", -0.3, 2.5).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(4.0).timeout
	dash_label.text = LINES["my_car"]["text2"]
	await get_tree().create_timer(2.5).timeout
	await ui.think(LINES["my_car"]["think2"])
	ui.close()
	await ui.fade_to(1.0, 0.6)
	if _engine:
		_engine.stop()
	main.play("door", -6.0)
	p.seated = false
	p.crouch = 0.0
	p.position = car.position + Vector3(-1.9, 0.1, 0.5)
	p.yaw = -0.6
	p.rotation.y = p.yaw
	p.pitch = 0.0
	dash_label.text = LINES["my_car"]["text3"]
	await ui.fade_to(0.0, 0.6)
	main.flags.erase("cinematic")
	main.add_connection(1.0, LINES["my_car"]["text4"])


## Lynx's sedan: three things to check, and the fingerprint on the mirror.
func _sedan() -> void:
	var ui = main.ui
	var p = main.player
	if _sedan_done:
		await ui.think(LINES["sedan"]["think1"])
		return
	main.flags["cinematic"] = true
	await ui.think(LINES["sedan"]["think2"])
	main.play("door", -8.0, 1.1)
	await ui.think(LINES["sedan"]["think3"])
	var checked := {}
	while checked.size() < 3:
		var opts := []
		var ids := []
		for pair in [["glove", LINES["sedan"]["text1"]], ["dash", LINES["sedan"]["text2"]], ["mirror", LINES["sedan"]["text3"]]]:
			if not checked.has(pair[0]):
				opts.append(pair[1])
				ids.append(pair[0])
		var pick: int = await ui.choose(opts)
		pick = clampi(pick, 0, ids.size() - 1)
		var id: String = ids[pick]
		checked[id] = true
		match id:
			"glove":
				await ui.think(LINES["sedan"]["think4"])
			"dash":
				main.play("glitch", -14.0, 0.8)
				await ui.think(LINES["sedan"]["think5"])
			"mirror":
				break
	await ui.think(LINES["sedan"]["think6"])
	main.play("sting", -10.0, 0.6)
	ui.glitch(0.4, 0.8)
	await ui.say(LINES["sedan"]["say1"][0], LINES["sedan"]["say1"][1])
	ui.close()
	# look out over the bluff: the door, lit for a breath
	await p.face(DOOR + Vector3(0, 2.3, 0), 1.6)
	door_light.light_energy = 0.0
	var tw := create_tween()
	tw.tween_property(door_eye_m, "emission_energy_multiplier", 2.5, 1.2)
	tw.tween_property(door_eye_m, "emission_energy_multiplier", 0.5, 1.5)
	main.play("pressure", -8.0)
	await ui.think(LINES["sedan"]["think7"])
	await ui.think(LINES["sedan"]["think8"])
	ui.close()
	_sedan_done = true
	main.flags["lynx_sedan_done"] = true
	main.flags.erase("cinematic")
	main.update_hud()


## The door: the frames scream and shut down, the choice to put them back
## on, "BOW, SLEEPER.", the knees in the dust, and the door slides open.
func _door() -> void:
	var ui = main.ui
	var p = main.player
	var f: Dictionary = main.flags
	if not _sedan_done:
		await ui.think(LINES["door"]["think1"])
		return
	if _at_door:
		await _enter()
		return
	_at_door = true
	f["cinematic"] = true
	await p.face(DOOR + Vector3(-0.2, 2.3, 0), 1.0)
	await ui.think(LINES["door"]["think2"])
	# the frames scream and die
	main.play("static", 0.0)
	main.play("glitch", 0.0, 0.6)
	ui.glitch(1.0, 1.6)
	p.shake(0.8)
	if not main.frames_on:
		main.frames_on = true
		ui.set_frames(1.0, main.connection)
		await get_tree().create_timer(0.5).timeout
	await get_tree().create_timer(0.8).timeout
	main.frames_on = false
	ui.set_frames(0.0, 0.0)
	set_glyph_visibility(false, main.connection)
	main.play("off", -4.0, 0.5)
	main.update_hud()
	if _wind:
		_wind.volume_db = -34.0
	await ui.think(LINES["door"]["think3"])
	await ui.think(LINES["door"]["think4"])
	var pick: int = await ui.choose(LINES["door"]["choices1"])
	ui.close()
	if pick == 1:
		f["frames_off_at_door"] = true
		f["hesitated_at_door"] = true
		# the eye on the door is just scorch marks without the frames
		door_eye_m.emission_energy_multiplier = 0.0
		await get_tree().create_timer(1.5).timeout
		await ui.think(LINES["door"]["think5"])
		ui.close()
		await ui.fade_to(1.0, 1.4)
		await get_tree().create_timer(0.8).timeout
		await ui.fade_to(0.0, 1.0)
		door_eye_m.emission_energy_multiplier = 0.5
	if _wind:
		_wind.volume_db = -14.0
	main.frames_on = true
	ui.set_frames(1.0, main.connection)
	set_glyph_visibility(true, main.connection)
	main.play("on", -4.0)
	ui.flash(0.4)
	main.update_hud()
	create_tween().tween_property(door_eye_m, "emission_energy_multiplier", 3.0, 0.8)
	await get_tree().create_timer(0.6).timeout
	main.play("pressure", -2.0, 0.6)
	await ui.say(LINES["door"]["say1"][0], LINES["door"]["say1"][1])
	await ui.think(LINES["door"]["think6"])
	await ui.say(LINES["door"]["say2"][0], LINES["door"]["say2"][1])
	main.play("whisper", -2.0, 0.7)
	await ui.think(LINES["door"]["think7"])
	ui.close()
	# the word detonates: the knees go
	main.play("slam", 0.0, 0.8)
	main.play("sting", -2.0, 0.5)
	p.shake(1.0)
	ui.glitch(0.9, 1.0)
	var kneel := create_tween()
	kneel.tween_property(p, "crouch", 1.0, 0.35).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	await ui.say(LINES["door"]["say3"][0], LINES["door"]["say3"][1])
	await ui.think(LINES["door"]["think8"])
	ui.close()
	f["bowed"] = true
	main.add_connection(2.0, "bowed")
	# the door slides into the rock, and the red at the end of the passage breathes
	main.play("door", 0.0, 0.5)
	main.play("pressure", -6.0, 0.8)
	var tw := create_tween().set_parallel(true)
	tw.tween_property(door_slab, "position:z", DOOR.z + 4.2, 3.2).set_trans(Tween.TRANS_SINE)
	tw.tween_property(door_light, "light_energy", 2.6, 3.0)
	tw.tween_property(door_green_m, "emission_energy_multiplier", 3.0, 3.0)
	await tw.finished
	await ui.think(LINES["door"]["think9"])
	ui.close()
	var up := create_tween()
	up.tween_property(p, "crouch", 0.0, 1.2)
	await up.finished
	door_it.set_meta("prompt", "Walk in")
	f.erase("cinematic")
	main.update_hud()


func _enter() -> void:
	var ui = main.ui
	if _ended:
		return
	_ended = true
	main.flags["cinematic"] = true
	await ui.think(LINES["enter"]["think1"])
	ui.close()
	main.flags["desert_done"] = true
	main.flags.erase("cinematic")
	if not main._selftest:
		main.load_level("Mirror")


# ------------------------------------------------------------------ each frame

func tick(delta: float) -> void:
	if not car or not main or not main.player:
		return
	if _driving:
		var target := want_speed
		if stop_z > -9000.0:
			target = clampf((car.position.z - stop_z) * 0.7, 0.0, want_speed)
		speed = move_toward(speed, target, delta * 5.0)
		car.position.z -= speed * delta
		# the car wallows in the deep sand, and jolts over the cracked road
		var rough := 0.004
		if car.position.z < -170.0 and car.position.z > -260.0:
			rough = 0.03
		elif car.position.z < -400.0:
			rough = 0.012
		car.position.y = sin(_t * 9.0) * rough * minf(1.0, speed / 6.0)
		car.rotation.z = sin(_t * 3.1) * rough * 0.5 * minf(1.0, speed / 6.0)
		main.player.position = car.position + SEAT
		if _engine:
			_engine.pitch_scale = 0.7 + speed / 15.0 * 0.6
			_engine.volume_db = -20.0 + speed / 15.0 * 8.0
	# the drones drift and turn, keeping their distance
	for d in drones:
		var n: Node3D = d
		var ph: float = n.get_meta("phase")
		n.position.x += cos(_t * 0.08 + ph) * delta * 3.0
		n.position.z += sin(_t * 0.06 + ph) * delta * 2.0
	# the eyeless turn toward Carl only when the frames are on
	for w in watchers:
		var n: Node3D = w
		var on: bool = main.frames_on and main.player.global_position.distance_to(n.global_position) < 40.0
		var tgt: Vector3 = main.player.global_position + Vector3(0, 1.6, 0)
		Anim.look(n, tgt, 1.0 if on else 0.0, 0.05)
		if on:
			var dv: Vector3 = tgt - n.global_position
			n.rotation.y = lerp_angle(n.rotation.y, atan2(-dv.x, -dv.z), delta * 1.2)
		else:
			n.rotation.y = lerp_angle(n.rotation.y, float(n.get_meta("base_yaw")), delta * 0.5)
	if vagrants.size() > 0:
		Anim.idle(vagrants[0], _t, 2.0)
	# the dead guard breathes; the little red light records
	if guard:
		var body: Node3D = guard.get_meta("body")
		body.scale.y = 1.0 + sin(_t * 1.1) * 0.01
	# the Eye on the door is brighter the closer Carl gets, once he knows it is there
	if _sedan_done and not _at_door and door_eye_m:
		var dd: float = main.player.global_position.distance_to(DOOR)
		door_eye_m.emission_energy_multiplier = lerpf(door_eye_m.emission_energy_multiplier, clampf(2.0 - dd / 30.0, 0.35, 1.6), delta * 2.0)


func objective() -> String:
	if _ended:
		return ""
	if _at_door:
		return "Walk in."
	if _sedan_done:
		return LINES["objective"]["text1"]
	if _arrived:
		return LINES["objective"]["text2"]
	return LINES["objective"]["text3"]


func phone() -> String:
	var t := LINES["phone"]["text1"]
	if main.flags.has("gate_passed"):
		t += LINES["phone"]["text2"]
	if _sedan_done:
		t += LINES["phone"]["text3"]
	return t


func on_glyph(g: Object) -> void:
	if str(g.get_meta("id")) == "g_rings":
		main.play("pressure", -6.0)
		main.player.shake(0.2)


func scan_people() -> Array:
	return []


func apply_args(a: Dictionary) -> void:
	if a.has("carz"):
		car.position.z = float(a["carz"])
		main.player.position = car.position + SEAT
		main.player.seated = true
		main.player.crouch = 0.5
		return
	if a.has("walk") or a.has("at"):
		# on foot at the bluff, the car parked
		car.position.z = PARK_Z
		(car.get_meta("shell") as Node3D).visible = true
		set_active(my_car_it, true)
		_arrived = true
		if a.has("sedan"):
			_sedan_done = true
			door_eye_m.emission_energy_multiplier = 1.0
		if a.has("open"):
			_sedan_done = true
			_at_door = true
			door_slab.position.z = DOOR.z + 4.2
			door_light.light_energy = 2.6
			door_green_m.emission_energy_multiplier = 3.0
			door_eye_m.emission_energy_multiplier = 3.0
		if not a.has("at"):
			main.player.position = car.position + Vector3(-1.9, 0.1, 0.5)
		return
	main.player.seated = true
	main.player.crouch = 0.5


func selftest() -> void:
	await _run()
	print("ok drive")
	for id in ["my_car", "sedan", "rings", "door", "door"]:
		for n in main._all_with_meta(self, "id"):
			if is_instance_valid(n) and str(n.get_meta("id")) == id:
				await main.interact(n)
				print("ok ", id)
				break
	await main.selftest_all_interactables()
