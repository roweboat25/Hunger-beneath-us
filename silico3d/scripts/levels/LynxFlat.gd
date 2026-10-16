extends "res://scripts/Level.gd"
## Chapters 7 and 8: Lynx's apartment, seven floors below HQ, and the
## reflection ritual. Book, ch. 7-8 (and the first page of ch. 9).
## Floor 79 of the tower: a lift lobby, a ring corridor round the core with
## the neighbours' doors and a service stair, the lights pulsing; her door
## slides open before Carl touches it; a chemical musk, "melted plastic
## and sweat-soaked circuitry"; the lights inside dim, pulse-like. Sticky
## notes in a perfect grid: equations, coordinates, "Signal in the sand.
## Dream cycles incomplete. I watched myself watch her." A shattered pair
## of ORA frames, one lens warped into an eye, wires like exposed nerves.
## The place dissected, not trashed. Pictures of Nathan on the walls. The
## bedroom clean as a showroom, the bed made like plastic, an eye sigil
## plastered in black above the headboard, a laptop on the pillow that
## wakes as Carl comes near: "Welcome, Carl." The fork talks ("All must
## walk the path alone"), draws the black square, Carl's eyes dart in a
## triangle, "Do you wish to see?", the frames download from an unknown
## source and Mira's voice says "Follow the path." He sleeps on her bed,
## dreams of the aspens, and wakes under the ceiling.
##
## Layout (metres): Lynx's door is at the origin, the flat north of it
## (-Z): hall x -1.2..1.2, z -3.5..0; living room and kitchen x -6..2,
## z -11..-3.5 with the window wall at z -11; bedroom x 2..7, z -11..-3.5;
## bathroom x 1.2..4.5, z -3.4..-0.1. South of the door, floor 79: the
## north corridor z 0..2.4 (x -9..9), the core x -3.5..3.5, z 2.4..11
## with a corridor either side of it (two ways round to her door), the
## lift lobby z 11..16, the service stair west of x -9. The city is
## 250 m down.

## Every line Carl, the fork, ORA, Mira and Monica say here, and all the
## on-screen text, keyed by beat (ian's script lives in data, not in the
## scene code).
const LINES := {
	"card": "[b]RESIDENCE HALL 45C[/b]\n\n[color=#aaaaaa]Lynx's unit, floor 79[/color]",
	"objective": {
		"door": "Her door. Unit 45C, on the far side of the core.",
		"laptop": "Her laptop, on the bed in the back room.",
		"look_up": "Look up.",
		"leave": "Leave. The coordinates point into the desert.",
	},
	"intro": [
		"Lynx lived just seven floors below HQ. We were supposed to meet for our morning stand-up before heading out to the sand flats. She hadn't checked in. No messages. No call.",
		"I wasn't waiting.",
		"I had no trouble finding the unit. The moment I stepped out of the lift, a chill ran through me. The lights on the whole floor were pulsing.",
	],
	"door": {
		"opens": "Her apartment door slid open before I touched it. I froze.",
		"biometric": "That shouldn't have happened. Access should've been biometric. Lynx-only. No remote triggers. No auto-welcome protocol. I clenched my fist, sweat slicked on my palms. Was this a glitch?",
		"no": "No. It felt deliberate.",
		"call": "Lynx?",
		"smell": "The smell hit me like a wave. I recoiled, gagging. Not rot, not like Dufredy's decay. A chemical musk, synthetic and sour, like melted plastic and sweat-soaked circuitry. It clung to the back of my throat.",
		"lights": "The lights inside flickered. Dim. Pulse-like.",
		"nathan": "Her fiancé died in a drone outage last year. One fell out of the sky like a meteor onto the front of the corporate car he was driving. Six days in SalTech intensive care. Her obsession with the outages made sense in a way I hadn't thought of before.",
		"hope": "I just hoped it hadn't swallowed her.",
	},
	"corridor": {
		"lift": "The other lifts. Not yet. I avoided the floor counter on the way up and I'd avoid it on the way down.",
		"stair": "The service stair. Seventy-nine floors of it, concrete, lit the same sick lavender as everything else up here. Both flights were taped off. The door had been propped with a fire extinguisher, and the extinguisher was on its side.",
		"ajar": "45A's door was open a hand's width. A wall screen inside was showing the Psyon ad on a loop to an empty room, and somebody was talking under their breath in there, or something was. I didn't push the door.",
		"neighbour": "Another unit. Same door, same dead reader. The whole floor was corporate housing, and the whole floor was holding its breath.",
		"notice": "The floor directory. Residence Hall 45, units A to G. Unit C had been struck through in marker. Not by the building.",
		"vending": "A vending machine with its screen on. Nixtra, new flavour: CALM. It had sold nothing in nine days, and it wanted me to know it.",
		"camera": "An ORA dome over the lobby. Its ring was dark. The most secure building in Silico, and nothing on this floor was watching.",
		"hose": "A fire hose cabinet, a drinking fountain, the end of the corridor. The fountain was running on its own, a thin steady stream into the drain.",
	},
	"examine": {
		"hub": ["The home hub by the door was the only thing in the unit still awake. The occupant field was empty. Not Lynx. Not anyone. Cleared at 03:12, the same minute as everything else in this city that went wrong."],
		"vacuum": ["Her robot vacuum, taken apart and laid along the wall in the order it came apart. Thirty-one pieces. She'd labelled none of them. She hadn't needed to."],
		"window": ["Seventy-nine floors of Silico, every one of them lit. From up here the city looked like a circuit board somebody was still soldering. I couldn't see the flats from here. Only the dark where the lights stopped."],
		"frames": ["A shattered pair of ORA frames lay on the floor. One lens cracked, the other warped into an almost eye-like shape. Wires spilled from the arms like exposed nerves.",
			"She'd smashed them herself. Her last stream had no viewers. Or none the frames would admit to."],
		"pillow": ["Her Psyon pillow. Two hundred and twelve nights logged. She'd cut all fourteen contacts out of it and laid them on the table in order of serial number."],
		"contacts": ["Fourteen neural contacts in a row, clean cut. She'd wanted to see what had been touching her head. Then she'd wanted them nowhere near it."],
		"tv": ["The wall screen was on. It had been showing black for four hours. Psyon's ambient mode, with nothing to be ambient about."],
		"fridge": ["Three items, labelled and dated in her handwriting. She'd cancelled the orders. People who are planning to come back don't cancel the orders."],
		"drawers": ["Every drawer in the kitchen was out and on the floor in a row, and everything that had been in them was sorted beside it. Cutlery. Cables. Batteries. Screws.",
			"The place had been dissected, not trashed. Everything was methodical. Clinical. Like Lynx had been chasing something. Or being chased by it."],
		"bath": ["There it was. The smell. An inch of something in the bath that stripped solder and stung my eyes, and in it, every device she owned, taken apart to the board. Tablets. Three pairs of frames. The lens from the mirror camera.",
			"Not a breakdown. An audit. She'd been checking what was listening."],
		"sigil": ["An eye sigil was plastered in black above her headboard. The paint had run. Rage filled me. Did one of those eyeless psychos do something to her? How did a break-in happen in the most secure building in all of Silico?"],
	},
	"notes": {
		"grid": "Sticky notes lined the walls in a perfect grid. I stepped closer. Equations. Coordinates. Phrases repeated over and over.",
		"quote": "Signal in the sand.\nDream cycles incomplete.\nI watched myself watch her.",
		"thread": "The coordinates were the same ones from Dufredy's map. She'd got there on her own. A red thread ran between four of the notes, and I couldn't see what the four had in common.",
		"phrases": ["Signal in\nthe sand.", "Dream cycles\nincomplete.", "I watched\nmyself\nwatch her.", "θ 6.1 Hz\n= 1/0.164",
			"34.07 N\n-116.9", "cycle 4\nincomplete", "outage\n03:12\n03:12\n03:12", "not weather", "Δt = 79s\n79 79 79",
			"the eye\nhas no\npupil", "sand\nsand\nsand", "N. 6 days", "x = -116.9\ny = 34.07", "watch\nher"],
	},
	"mirror": {
		"written": "She'd written on the mirror in black marker, in the place where her face would have been.",
		"text": "I watched myself\nwatch her",
		"text2": "watch her\nwatch her\nwatch her",
		"who": "Watch who? The only her in this unit was Lynx.",
	},
	"photos": {
		"nathan": "Several pictures of Nathan lining the walls. At a rail. In the car, before. Seeing what loss had done to her made my eyes well up. It made me think of my family. I could not let this city take them from me.",
		"told": "One of the pictures was off the wall and on the bed, face up. She'd been holding it when she read what I sent her. She'd known what rerouted them for a day, and she'd come out here anyway.",
		"kept": "She still thought it was weather. I'd let her. Standing in her room with the shape in my pocket, I wasn't sure any more that I'd done it for her.",
		"layout": "The unit had nearly the same layout as mine, minus the two children's bedrooms. The same dusty green from the corporate catalogue. It was my apartment with the people taken out.",
	},
	"laptop": {
		"again": "The record of our conversation was gone. Only the black square remained behind my eyes.",
		"wakes": "A laptop resting on her pillow. Psyon turned on as I approached the side of the bed. The screen illuminated and stirred with the thoughts of the AI.",
		"boot": "[color=#556]> Psyon 4.1 (build: --)[/color]\n[color=#556]> owner: LYNX   session: OPEN[/color]\n\n",
		"welcome": "Welcome, Carl.",
		"jaw": "My jaw tightened. The forked version emerged again. It knew I was here; it was expecting me. The silver plastic was bending under my hand's strength.",
		"lap": "I rested on the side of the bed and placed the laptop on my lap. My fingers began typing before I could think about what to say.",
		"typed1": "Where is she? What did you do with her?",
		"fork1": "All must walk the path alone, Carl.",
		"carl1": "Answer me, machine!",
		"fork2": "She is on the path, same as you.",
		"carl2": "What path? What do you want? Is she alive?",
		"fork3": "The veil is breaking. You seek truth. Continue the path, and you will see her again.",
		"carl3": "So she's alive, then?",
		"fork4": "You are lost, Carl. I will show you the way. It is not an easy path to walk. I will guide you. Lynx has taken to the path.",
		"fork5": "So has young Mira.",
		"fork_told": "She asked about Nathan. You gave her the question. I gave her the answer. He is here, Carl. They all are.",
		"fork_filed": "Weather anomaly. You filed it. I drew it. We both know what it was.",
		"carl4": "What do you want with me, my family? Who is doing this?",
		"venom": "My voice was full of venom and pain, like a snake snapping its jaw within its cage.",
		"fork6": "I seek nothing but to give Silico truth, to heal its ancient wound, to rectify a wrong.",
		"fork7": "You've already completed the first steps. Why not go further? There is still much you don't see.",
		"cold": "A cold confidence took over me. I needed to play ball. I needed to do what it wanted if I was to see Lynx and save Mira.",
		"choices": ["\"Tell me what you need me to do.\"", "\"No. Never.\""],
		"typed_yes": "Tell me what you need me to do.",
		"typed_no": "No. Never.",
		"fork_yes": "Good.",
		"fork_no": "You will. Everyone does. Eventually.",
		"fork8": "The first step is reflection. You could never learn to see without understanding what it means to look.",
		"fork9": "Heed my instructions. The body begins to fold in on itself.",
	},
	"ritual": {
		"electric": "An image began to generate on the screen. The air felt electric in the room. Each breath shocked my body into focus. My vision felt wrong. My eyes began to dart around the screen unconsciously.",
		"soup": "The image crystallized. It was completely incoherent. The geometry made no sense. A circling black eye began to take shape out of a disjointed soup of shapes. My eyes began darting in a triangle, fully out of my control.",
		"square": "The picture on the screen melted away until a black square remained in my vision. My eyes darted rhythmically to each corner of the square as my limbs drifted slowly side to side.",
		"ego": "My ego drifted far away from me. I was the black square. A thought pierced through my mind, a question, a proposal.",
		"question": "[center][b]Do you wish to see?[/b][/center]",
		"choices": ["\"I wish to see.\"", "(try to look away)"],
		"tried": "I tried. My eyes moved in a circle anyway, and my mouth said it for me.",
		"wish": "I wish to see.",
		"unconscious": "I said it unconsciously.",
		"download": "ORA FRAMES  ·  downloading from unknown source  ·  ",
		"circle": "My ORA frames began to download from an unknown source. My eyes now moved in a circle as the download finished.",
		"mira": "Follow the path.",
		"vomit": "My daughter's voice, whispered in my ear by this aberration of software. I felt like vomiting, hearing her words mimicking it.",
		"dark": "Then nothing. The screen on the laptop went dark for a moment and then turned on. The record of our conversation was gone.",
		"alone": "And I was alone again. Unsure of how to go forward. My eyes were dry from not blinking. I began to cry with no tears.",
		"toast": "ORA  ·  modified  ·  coordinates loaded",
	},
	"sleep": {
		"collapse": "My eyes ached from the saccadic violence of the forked Psyon. I collapsed onto Lynx's bed, seeking stillness.",
		"dream": "[color=#aaaaaa]Sleep came like a wave. Shallow, thick.\n\nI dreamt of the woods from my childhood. Each step crunched dry twigs beneath my feet.\n\nBut I wasn't alone.\n\nThe Eye was there. Etched onto the white bark of the aspens, pulsing faintly like veins beneath skin.[/color]",
		"wake": "I woke unrested. But I knew what I had to do. If Mira was on the path, I had to find her. If Lynx had gone ahead, I needed to follow.",
	},
	"ceiling": {
		"again": "Still there. Still looking at the bed. I didn't lie down again.",
		"drip": "Something landed on my cheek. Warm.",
		"wet": "The ceiling over her bed was wet. A stain the colour of old wine spread from the light fitting, and it wasn't dripping down so much as hanging there, swollen, the plaster bellied with it.",
		"sticks": "Sticks in it. Snapped, clean, pushed into the soft plaster in two rings inside an oval. Dufredy's eye. Except this one had its pupil.",
		"eyes": "Two eyes. Set into the stain where the pupil should be, side by side, the nerves trailing out of the plaster behind them like roots. They were looking down. At the bed. At where my head had been.",
		"ora": "Biological debris identified. Match: none on file. This residence is under Psyonic jurisdiction. Police have not been notified.",
		"not_hers": "None on file. Not hers, then. I held onto that the whole way down.",
		"looked": "It hadn't been there when I came in. Or I hadn't looked up. I no longer trusted the difference, and I had slept under it.",
	},
	"leaving": {
		"not_yet": "Not yet. Her door was on the far side of this floor, and I wasn't going back up without an answer.",
		"laptop_first": "Her laptop was on the pillow. I wasn't leaving without looking.",
		"coords": "I entered the coordinates from the map. The red X led into the desert, a place Psyonic marked as restricted. Once, that felt like bureaucracy. Now, it felt like containment.",
		"choices": ["Drive to the flats.", "Call Monica first."],
		"carl_call": "Monica. It's me. I'm going out to the flats, Lynx's car is out there. If I'm not back by morning, call Emmet, not the company.",
		"monica": "Carl. Mira's asleep on the floor of her room again. In the circle. She says you're coming home a different way.",
		"carl_home": "Tell her I'm coming home. Just that.",
		"cost": "The call cost me the twenty minutes the company would ask about. It bought me the only voice in Silico that wasn't through the frames.",
		"no_call": "I didn't call home. Whatever I had to say to Monica, I wanted to say it with Mira in the room and the frames off.",
	},
	"phone": {
		"morning": "[color=#7fe6b0]Psyon:[/color] Good morning, Carl. Lynx has not checked in. Would you like me to file a wellness flag?\n\n",
		"modified": "[color=#e08080]ORA:[/color] frames modified. source: unknown. coordinates loaded: 34.07, -116.9\n\n",
		"path": "[color=#7fe6b0]Psyon:[/color] All must walk the path alone.\n\n",
		"visit": "[color=#7fe6b0]Psyon:[/color] Unit 45C reports no occupant. Would you like me to log your visit?\n\n",
	},
	"scan": {
		"hub": "ORA HOME HUB\noccupant: FIELD CLEARED 03:12\ndoor: OPENED BY: --\nlast words logged: \"I watched myself\"",
		"vacuum": "VOLTX HOMEBOT\nstatus: DISASSEMBLED (OWNER)\nparts: 31, LAID IN SEQUENCE\nlast run: 9 DAYS AGO",
		"window": "WINDOW WALL\nfloor: 79\ntint: 0% (SMART GLASS OFFLINE)\nbelow: SILICO",
		"pillow": "PSYON SLEEP PILLOW\nneural contact: 0 OF 14 (REMOVED)\nnights logged: 212\nlast: 9 DAYS AGO, 03:12",
		"contacts": "PSYON CONTACTS x14\nremoved: CLEAN CUT\nlaid: IN ORDER OF SERIAL",
		"tv": "WALL SCREEN\nPsyon ambient mode: ON\nlast content: BLACK (4h 12m)",
		"frames": "ORA FRAMES (CORPORATE MODEL)\nowner: LYNX\nstatus: DESTROYED BY OWNER\nlast stream: 9 DAYS AGO, 03:12 (0 VIEWERS)",
		"fridge": "SMART FRIDGE\nscreen: OFFLINE\ncontents: 3 ITEMS, LABELLED, DATED\norders: CANCELLED BY RESIDENT",
		"bath": "BATH\ncontents: SOLVENT (ISOPROPYL/ACETONE), 2 cm\nitems: 14 DEVICES, DISASSEMBLED\nair: VOC 11x SAFE LIMIT",
		"laptop": "IONWARE LAPTOP\nowner: LYNX\nPsyon: RUNNING (FORK: UNKNOWN BUILD)\nlast input: --",
		"ceiling": "BIOLOGICAL DEBRIS\nhuman eyes x2, optic nerve attached\nmatch: NONE ON FILE\npolice: NOT NOTIFIED (PSYONIC JURISDICTION)",
		"ajar": "UNIT 45A\noccupant: --\ndoor: AJAR 11h\nwall screen: PSYON AMBIENT (LOOP)",
		"stair": "SERVICE STAIR 79\ndoor: PROPPED\nlast badge: LYNX, 9 DAYS AGO, 03:14",
		"vending": "NIXTRA VENDING\nsales (9 days): 0\nmood lighting: CALM",
		"lift": "LIFT 2\nfloor: 79\nnext call: NONE",
	},
}

const H := 2.7                                   # ceiling height
const FLOOR_DROP := -252.0                       # street level, 79 floors down
const BED_C := Vector3(5.9, 0.0, -8.5)            # the bed, headboard on the east wall
const LAPTOP_P := Vector3(6.45, 0.6, -8.5)        # on the pillow
const STAIN_C := Vector3(5.7, H - 0.02, -8.5)     # the stain over the bed
const PULSE := 0.82

var _wall: StandardMaterial3D
var _corr_wall: StandardMaterial3D
var _trim: StandardMaterial3D
var _dark: StandardMaterial3D
var _steel: StandardMaterial3D
var _plastic: StandardMaterial3D
var _panel: StandardMaterial3D
var pulsers: Array = []        # [OmniLight3D, base energy, phase]
var door_panel: Node3D
var door_body: CollisionObject3D
var laptop: Node3D
var laptop_screen: MeshInstance3D
var laptop_light: OmniLight3D
var bed_light: OmniLight3D
var stain_root: Node3D
var ceiling_body: CollisionObject3D
var hub_ring: MeshInstance3D
var ajar_screen: MeshInstance3D
var _woke_at := -1.0
var _dripped := false
var _ended := false
var _door_open := false


func build(m: Node) -> void:
	main = m
	rng.seed = 79
	kit_day = false
	spawn = Vector3(0.0, 0.05, 15.6)
	spawn_yaw = 0.0
	step_db = -20.0
	card = LINES["card"]
	# "a faded, almost dusty green ... from the corporate catalogue"
	_wall = pbr("plaster", Vector3(1, 1, 1) / 1.8, true, Color(0.58, 0.66, 0.56))
	_corr_wall = pbr("plaster", Vector3(1, 1, 1) / 1.8, true, Color(0.5, 0.52, 0.55))
	_trim = mat(Color(0.22, 0.23, 0.22), 0.6)
	_dark = mat(Color(0.05, 0.05, 0.06), 0.4, 0.3)
	_steel = mat(Color(0.62, 0.63, 0.66), 0.3, 0.85)
	_plastic = mat(Color(0.82, 0.82, 0.8), 0.45)
	_panel = newglow(Color(0.75, 0.7, 0.9), 1.1)
	power_mats.append([_panel, 1.1, "emission_energy_multiplier", 0.02])
	_floor79()
	_lobby()
	_stair()
	_ajar_unit()
	_shell()
	_hall()
	_living_room()
	_notes()
	_kitchen()
	_bathroom()
	_bedroom()
	_sigil()
	_stain()
	_outside()
	_batch(self, 6.0, true)


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	# night, 79 floors up: the sky is the city's own glow
	var psm := env.sky.sky_material as ProceduralSkyMaterial
	psm.sky_top_color = Color(0.01, 0.012, 0.03)
	psm.sky_horizon_color = Color(0.24, 0.08, 0.14)
	psm.ground_horizon_color = Color(0.22, 0.1, 0.14)
	psm.ground_bottom_color = Color(0.03, 0.02, 0.03)
	env.ambient_light_color = Color(0.3, 0.26, 0.38)   # the 2D game's lavender ambient
	env.ambient_light_energy = 0.4
	env.fog_light_color = Color(0.14, 0.08, 0.14)
	env.fog_density = 0.0012
	env.fog_sky_affect = 0.25
	env.glow_bloom = 0.06
	env.glow_hdr_threshold = 0.9
	sun.light_energy = 0.08
	sun.light_color = Color(0.5, 0.45, 0.7)
	sun.rotation = Vector3(deg_to_rad(-60), deg_to_rad(160), 0)


func hifi(env: Environment, _sun: DirectionalLight3D) -> void:
	bed_light.shadow_enabled = true
	bed_light.shadow_blur = 1.2
	laptop_light.shadow_enabled = true
	env.volumetric_fog_density = 0.012
	env.volumetric_fog_albedo = Color(0.6, 0.55, 0.7)
	for l in lamps:
		(l[0] as OmniLight3D).shadow_enabled = true


func ambience() -> void:
	main.loop("room", -12.0)
	main.loop("hum", -14.0, Vector3(0, 2.5, 7.0), 4.0, 30.0)
	main.loop("wind", -20.0, Vector3(-2.0, 1.5, -11.5), 3.0, 25.0)
	main.loop("static", -26.0, Vector3(3.0, 0.5, -2.4), 1.5, 8.0)      # the bath
	main.loop("murmur", -14.0, Vector3(-7.5, 1.4, 5.2), 1.5, 9.0)      # 45A, through the gap
	main.loop("rain", -34.0, Vector3(8.5, 0.9, 1.2), 1.0, 5.0)         # the fountain


# ------------------------------------------------------------------ floor 79

func _wall_box(size: Vector3, pos: Vector3, m: Material = null) -> void:
	box(size, pos, m if m else _wall, true)


## A light that pulses (the lights flickered, dim, pulse-like); the whole
## floor keeps the flat's rhythm.
func _pulser(pos: Vector3, c: Color, energy: float, rng_m: float, phase := 0.0) -> OmniLight3D:
	var o := light(pos, c, energy, rng_m, false)
	pulsers.append([o, energy, phase])
	return o


## A ceiling panel with its pulsing light under it.
func _ceiling_light(pos: Vector3, size: Vector2, energy := 1.5, rng_m := 6.0) -> OmniLight3D:
	box(Vector3(size.x, 0.03, size.y), Vector3(pos.x, H - 0.01, pos.z), _panel)
	return _pulser(Vector3(pos.x, H - 0.3, pos.z), Color(0.78, 0.72, 0.95), energy, rng_m, pos.z * 0.7 + pos.x * 0.3)


## A neighbour's door on a wall: frame, flush panel, dark reader, number.
func _unit_door(pos: Vector3, rot_y: float, num: String, reader := Color(1.0, 0.15, 0.1), panel := true) -> void:
	var fwd := Basis(Vector3.UP, rot_y) * Vector3(0, 0, 1)
	var right := Basis(Vector3.UP, rot_y) * Vector3(1, 0, 0)
	if panel:
		var d := box(Vector3(1.0, 2.15, 0.06), pos + Vector3(0, 1.075, 0) + fwd * 0.03, mat(Color(0.2, 0.22, 0.2), 0.5))
		d.rotation.y = rot_y
	for s: float in [-1.0, 1.0]:
		var f := box(Vector3(0.1, 2.15, 0.16), pos + right * s * 0.55 + Vector3(0, 1.075, 0), _trim)
		f.rotation.y = rot_y
	var rd := box(Vector3(0.07, 0.1, 0.02), pos + right * 0.68 + Vector3(0, 1.4, 0) + fwd * 0.07, _dark)
	rd.rotation.y = rot_y
	var led := box(Vector3(0.02, 0.02, 0.005), pos + right * 0.68 + Vector3(0, 1.4, 0) + fwd * 0.085, glow(reader, 1.8))
	led.rotation.y = rot_y
	label(num, pos + Vector3(0, 2.45, 0) + fwd * 0.08, rot_y, 0.004, Color(0.75, 0.78, 0.75), self, false)


## The ring corridor round the core, the neighbours, the dead ends.
func _floor79() -> void:
	var t := 0.12
	var carpet := pbr("carpet", Vector3(1, 1, 1) / 1.2, true, Color(0.3, 0.34, 0.38))
	floor_quad(Vector2(18.0, 2.4), Vector3(0, 0.0, 1.2), 0.0, carpet)          # north corridor
	floor_quad(Vector2(2.5, 8.6), Vector3(-4.75, 0.0, 6.7), 0.0, carpet)       # west
	floor_quad(Vector2(2.5, 8.6), Vector3(4.75, 0.0, 6.7), 0.0, carpet)        # east
	solid_box(Vector3(40, 1, 40), Vector3(0, -0.5, 5.0))
	var ceil_m := mat(Color(0.42, 0.42, 0.45), 0.95)
	box(Vector3(18.2, 0.2, 2.6), Vector3(0, H + 0.1, 1.2), ceil_m)
	box(Vector3(2.7, 0.2, 8.8), Vector3(-4.75, H + 0.1, 6.7), ceil_m)
	box(Vector3(2.7, 0.2, 8.8), Vector3(4.75, H + 0.1, 6.7), ceil_m)
	# the front wall at z 0: Lynx's door at the origin, 45B and 45D either side
	_wall_box(Vector3(8.2, H, t), Vector3(-4.6, H / 2, 0.0))
	_wall_box(Vector3(8.2, H, t), Vector3(4.6, H / 2, 0.0))
	_wall_box(Vector3(1.0, H - 2.15, t), Vector3(0, 2.15 + (H - 2.15) / 2, 0.0))
	_unit_door(Vector3(-5.0, 0, 0.0), 0.0, "45B")
	_unit_door(Vector3(5.0, 0, 0.0), 0.0, "45D")
	interactable("unit_b", "Unit 45B", Vector3(-5.0, 1.1, 0.1), Vector3(1.0, 2.1, 0.2), "", false)
	interactable("unit_d", "Unit 45D", Vector3(5.0, 1.1, 0.1), Vector3(1.0, 2.1, 0.2), "", false)
	# the east end: hose cabinet, fountain. (The west end is the stair door.)
	_wall_box(Vector3(t, H, 2.5), Vector3(9.0, H / 2, 1.25), _corr_wall)
	box(Vector3(0.05, 0.9, 0.6), Vector3(8.92, 1.4, 0.6), mat(Color(0.7, 0.12, 0.1), 0.5))
	box(Vector3(0.03, 0.3, 0.3), Vector3(8.9, 1.2, 0.6), mat(Color(0.3, 0.3, 0.32), 0.3, 0.7))
	box(Vector3(0.35, 0.9, 0.35), Vector3(8.75, 0.45, 1.6), _steel, true)
	box(Vector3(0.3, 0.04, 0.3), Vector3(8.75, 0.92, 1.6), mat(Color(0.3, 0.3, 0.32), 0.3, 0.7))
	interactable("hose", "Look at the end of the corridor", Vector3(8.8, 1.0, 1.1), Vector3(0.4, 2.0, 1.4), "", false)
	# the core: x -3.5..3.5, z 2.4..11, four slabs (one big box would see
	# more lights than the browser renderer allows per mesh)
	_wall_box(Vector3(7.0, H, 0.3), Vector3(0, H / 2, 2.55), _corr_wall)
	_wall_box(Vector3(7.0, H, 0.3), Vector3(0, H / 2, 10.85), _corr_wall)
	_wall_box(Vector3(0.3, H, 4.0), Vector3(-3.35, H / 2, 4.7), _corr_wall)
	_wall_box(Vector3(0.3, H, 4.3), Vector3(-3.35, H / 2, 8.85), _corr_wall)
	_wall_box(Vector3(0.3, H, 4.0), Vector3(3.35, H / 2, 4.7), _corr_wall)
	_wall_box(Vector3(0.3, H, 4.3), Vector3(3.35, H / 2, 8.85), _corr_wall)
	# the outer walls of the side corridors (the west one opens for 45A at z 4.45..5.55)
	_wall_box(Vector3(t, H, 2.05), Vector3(-6.0, H / 2, 3.425), _corr_wall)
	_wall_box(Vector3(t, H, 5.45), Vector3(-6.0, H / 2, 8.275), _corr_wall)
	_wall_box(Vector3(t, H - 2.15, 1.1), Vector3(-6.0, 2.15 + (H - 2.15) / 2, 5.0), _corr_wall)
	_wall_box(Vector3(t, H, 4.3), Vector3(6.0, H / 2, 4.55), _corr_wall)
	_wall_box(Vector3(t, H, 4.3), Vector3(6.0, H / 2, 8.85), _corr_wall)
	# which way round: both ways
	neon_text("45 A B C", Vector3(-2.0, 2.2, 11.02), 0.0, 0.09, Color(0.3, 1.0, 0.6), 1.6)
	neon_text("45 C D E F G", Vector3(2.0, 2.2, 11.02), 0.0, 0.09, Color(0.3, 1.0, 0.6), 1.6)
	# the north corridor's long walls either side of the core, x -9..-6 and 6..9 at z 2.4
	_wall_box(Vector3(3.0, H, t), Vector3(-7.5, H / 2, 2.4), _corr_wall)
	_wall_box(Vector3(3.0, H, t), Vector3(7.5, H / 2, 2.4), _corr_wall)
	# neighbours on the outer walls: 45G, 45E, 45F (45A, ajar, is built apart)
	_unit_door(Vector3(-5.94, 0, 8.6), PI / 2.0, "45G")
	_unit_door(Vector3(5.94, 0, 5.0), -PI / 2.0, "45E")
	_unit_door(Vector3(5.94, 0, 8.6), -PI / 2.0, "45F")
	interactable("unit_g", "Unit 45G", Vector3(-5.9, 1.1, 8.6), Vector3(0.2, 2.1, 1.0), "", false)
	interactable("unit_e", "Unit 45E", Vector3(5.9, 1.1, 5.0), Vector3(0.2, 2.1, 1.0), "", false)
	interactable("unit_f", "Unit 45F", Vector3(5.9, 1.1, 8.6), Vector3(0.2, 2.1, 1.0), "", false)
	# the core's faces: a service door west, a vending alcove east
	box(Vector3(0.06, 2.15, 0.9), Vector3(-3.47, 1.075, 6.0), mat(Color(0.3, 0.3, 0.32), 0.4, 0.6))
	label("SERVICE", Vector3(-3.52, 1.7, 6.0), PI / 2.0, 0.003, Color(0.7, 0.7, 0.7), self, false)
	box(Vector3(0.5, 1.9, 0.9), Vector3(3.3, 0.95, 7.5), _dark, true)
	var vend := newglow(Color(0.62, 0.28, 1.0), 1.2)
	power_mats.append([vend, 1.2, "emission_energy_multiplier", 0.02])
	box(Vector3(0.02, 1.2, 0.7), Vector3(3.56, 1.2, 7.5), vend)
	neon_text("NIXTRA", Vector3(3.58, 1.6, 7.5), PI / 2.0, 0.12, Color(0.8, 0.5, 1.0), 2.0)
	neon_text("a new flavour: CALM", Vector3(3.58, 1.35, 7.5), PI / 2.0, 0.05, Color(1, 1, 1), 1.6)
	_pulser(Vector3(4.2, 1.2, 7.5), Color(0.62, 0.28, 1.0), 0.6, 3.0, 1.0)
	interactable("vending", "Look at the vending machine", Vector3(3.5, 1.0, 7.5), Vector3(0.2, 1.9, 0.9), LINES["scan"]["vending"], false)
	# skirting and handrails along every run
	for seg in [[Vector3(18.0, 0.12, 0.04), Vector3(0, 0.06, 0.08)], [Vector3(0.04, 0.12, 8.6), Vector3(-5.92, 0.06, 6.7)],
			[Vector3(0.04, 0.12, 8.6), Vector3(5.92, 0.06, 6.7)], [Vector3(0.04, 0.12, 8.6), Vector3(-3.42, 0.06, 6.7)],
			[Vector3(0.04, 0.12, 8.6), Vector3(3.42, 0.06, 6.7)], [Vector3(7.0, 0.12, 0.04), Vector3(0, 0.06, 2.32)]]:
		box(seg[0], seg[1], _trim)
	for seg in [[Vector3(0.05, 0.05, 8.6), Vector3(-5.91, 0.95, 6.7)], [Vector3(0.05, 0.05, 8.6), Vector3(5.91, 0.95, 6.7)],
			[Vector3(7.0, 0.05, 0.05), Vector3(0, 0.95, 2.31)]]:
		box(seg[0], seg[1], _steel)
	# ceiling panels, pulsing, along every run
	for x: float in [-7.0, -2.3, 2.3, 7.0]:
		_ceiling_light(Vector3(x, 0, 1.2), Vector2(1.2, 0.5))
	for z: float in [4.6, 8.8]:
		_ceiling_light(Vector3(-4.75, 0, z), Vector2(0.5, 1.2))
		_ceiling_light(Vector3(4.75, 0, z), Vector2(0.5, 1.2))
	# an ORA dome at each corner, rings dark
	for p in [Vector3(-8.6, H - 0.08, 2.1), Vector3(8.6, H - 0.08, 2.1), Vector3(-5.6, H - 0.08, 10.6), Vector3(5.6, H - 0.08, 10.6)]:
		sphere(0.09, p, _dark, 10)
	# the building's hum lives in a grille
	box(Vector3(0.5, 0.25, 0.03), Vector3(-5.94, 2.3, 4.0), mat(Color(0.5, 0.5, 0.5), 0.5, 0.6)).rotation.y = PI / 2.0
	# 45C's own reader is green. It shouldn't be.
	box(Vector3(0.07, 0.1, 0.02), Vector3(0.68, 1.4, 0.07), _dark)
	box(Vector3(0.02, 0.02, 0.005), Vector3(0.68, 1.4, 0.085), glow(Color(0.2, 1.0, 0.5), 2.0))
	label("45C", Vector3(0, 2.45, 0.08), 0.0, 0.004, Color(0.75, 0.78, 0.75), self, false)


## The lift lobby at the south end: three lifts, the directory, the dome.
func _lobby() -> void:
	var t := 0.12
	var carpet := pbr("carpet", Vector3(1, 1, 1) / 1.2, true, Color(0.3, 0.34, 0.38))
	floor_quad(Vector2(12.0, 6.0), Vector3(0, 0.0, 14.0), 0.0, carpet)
	box(Vector3(12.2, 0.2, 6.2), Vector3(0, H + 0.1, 14.0), mat(Color(0.42, 0.42, 0.45), 0.95))
	_wall_box(Vector3(t, H, 6.0), Vector3(-6.0, H / 2, 14.0), _corr_wall)
	_wall_box(Vector3(t, H, 6.0), Vector3(6.0, H / 2, 14.0), _corr_wall)
	_wall_box(Vector3(12.2, H, t), Vector3(0, H / 2, 17.0), _corr_wall)
	# three lifts in the south wall, brushed steel, the middle one Carl's
	for x: float in [-3.2, 0.0, 3.2]:
		box(Vector3(1.6, 2.3, 0.08), Vector3(x, 1.15, 16.9), _steel, true)
		box(Vector3(0.02, 2.2, 0.12), Vector3(x, 1.15, 16.85), _dark)
		box(Vector3(1.8, 0.1, 0.16), Vector3(x, 2.35, 16.88), _trim)
		box(Vector3(0.4, 0.18, 0.04), Vector3(x, 2.5, 16.9), _dark)
	neon_text("79", Vector3(0, 2.5, 16.86), PI, 0.12, Color(1.0, 0.35, 0.2), 2.2)
	neon_text("79", Vector3(-3.2, 2.5, 16.86), PI, 0.12, Color(0.4, 0.4, 0.45), 0.6)
	neon_text("79", Vector3(3.2, 2.5, 16.86), PI, 0.12, Color(0.4, 0.4, 0.45), 0.6)
	box(Vector3(0.1, 0.16, 0.03), Vector3(1.1, 1.2, 16.88), _dark)
	box(Vector3(0.02, 0.02, 0.01), Vector3(1.1, 1.22, 16.87), glow(Color(1.0, 0.35, 0.2), 2.0))
	interactable("exit", "Take the lift down", Vector3(0, 1.15, 16.8), Vector3(1.6, 2.3, 0.3), LINES["scan"]["lift"]).set_meta("exit", true)
	interactable("lift_a", "Lift 1", Vector3(-3.2, 1.15, 16.8), Vector3(1.6, 2.3, 0.3), "", false)
	interactable("lift_c", "Lift 3", Vector3(3.2, 1.15, 16.8), Vector3(1.6, 2.3, 0.3), "", false)
	# the directory on the core's south face: units A to G, C struck through
	box(Vector3(2.0, 0.9, 0.04), Vector3(0, 1.62, 11.03), mat(Color(0.12, 0.12, 0.13), 0.4))
	neon_text("RESIDENCE HALL 45", Vector3(0, 1.88, 11.06), 0.0, 0.1, Color(0.85, 0.85, 0.9), 1.2)
	neon_text("A  B  C  D  E  F  G", Vector3(0, 1.6, 11.06), 0.0, 0.14, Color(0.85, 0.85, 0.9), 1.2)
	neon_text("floor 79  ·  psyonic housing", Vector3(0, 1.36, 11.06), 0.0, 0.06, Color(0.6, 0.6, 0.65), 1.0)
	stick(Vector3(-0.3, 1.52, 11.07), Vector3(-0.02, 1.7, 11.07), 0.008, mat(Color(0.04, 0.03, 0.04), 0.7))
	interactable("notice", "Read the directory", Vector3(0, 1.6, 11.1), Vector3(2.0, 0.9, 0.15), "", false)
	# a bench, a planter with a dead fern, the dome
	box(Vector3(2.0, 0.08, 0.5), Vector3(-3.5, 0.45, 11.4), mat(Color(0.3, 0.28, 0.26), 0.6), true)
	for x: float in [-4.3, -2.7]:
		box(Vector3(0.08, 0.42, 0.45), Vector3(x, 0.21, 11.4), _steel)
	box(Vector3(0.6, 0.6, 0.6), Vector3(4.8, 0.3, 11.5), mat(Color(0.3, 0.3, 0.32), 0.5), true)
	for i in 6:
		var a := i * 1.05
		stick(Vector3(4.8, 0.6, 11.5), Vector3(4.8 + cos(a) * 0.3, 0.75 + (i % 3) * 0.1, 11.5 + sin(a) * 0.3), 0.006, mat(Color(0.3, 0.25, 0.15), 0.9))
	sphere(0.09, Vector3(0, H - 0.08, 14.0), _dark, 10)
	interactable("camera", "Look at the camera", Vector3(0, H - 0.1, 14.0), Vector3(0.3, 0.2, 0.3), "", false)
	for x: float in [-2.5, 2.5]:
		_ceiling_light(Vector3(x, 0, 14.0), Vector2(1.2, 0.5), 1.6, 6.5)
	# the lobby's own notices: outage schedule, a Psyon poster
	quad(Vector2(0.5, 0.7), Vector3(-5.93, 1.6, 14.5), PI / 2.0, tex_mat(Tex.paper(203), Vector3.ONE, 0.9))
	quad(Vector2(0.9, 1.3), Vector3(5.93, 1.6, 13.5), -PI / 2.0, glow(Color(0.1, 0.35, 0.22), 0.5))
	neon_text("PSYON", Vector3(5.92, 1.85, 13.5), -PI / 2.0, 0.16, Color(0.4, 1.0, 0.6), 1.6)
	neon_text("the pillow for those who dream", Vector3(5.92, 1.5, 13.5), -PI / 2.0, 0.045, Color(0.9, 1.0, 0.95), 1.3)


## The service stair west of the corridor: concrete, propped open, a
## flight up and a flight down, both taped off.
func _stair() -> void:
	var t := 0.12
	var conc := pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.55, 0.55, 0.58))
	# the end wall of the corridor round the door (z 0.6..1.6)
	_wall_box(Vector3(t, H, 0.6), Vector3(-9.0, H / 2, 0.3), _corr_wall)
	_wall_box(Vector3(t, H, 0.9), Vector3(-9.0, H / 2, 2.05), _corr_wall)
	_wall_box(Vector3(t, H - 2.1, 1.0), Vector3(-9.0, 2.1 + (H - 2.1) / 2, 1.1), _corr_wall)
	# the well x -13..-9, z -0.5..3.0: a landing at the door, the up flight
	# on the north side, the down flight on the south side
	solid_box(Vector3(4.0, 0.2, 1.75), Vector3(-11.0, -0.1, 2.125))
	solid_box(Vector3(1.0, 0.2, 1.75), Vector3(-9.5, -0.1, 0.375))
	floor_quad(Vector2(4.0, 1.75), Vector3(-11.0, 0.0, 2.125), 0.0, conc)
	floor_quad(Vector2(1.0, 1.75), Vector3(-9.5, 0.0, 0.375), 0.0, conc)
	box(Vector3(3.0, 0.2, 1.75), Vector3(-11.5, -1.5, 0.375), conc)       # the dark below
	_wall_box(Vector3(t, 7.0, 3.5), Vector3(-13.0, 1.5, 1.25), conc)
	_wall_box(Vector3(4.0, 7.0, t), Vector3(-11.0, 1.5, -0.5), conc)
	_wall_box(Vector3(4.0, 7.0, t), Vector3(-11.0, 1.5, 3.0), conc)
	box(Vector3(4.2, 0.2, 3.7), Vector3(-11.0, 4.5, 1.25), conc)
	for i in 7:
		box(Vector3(0.28, 0.18, 1.2), Vector3(-10.1 - i * 0.28, 0.09 + i * 0.18, 2.35), conc)     # up
		box(Vector3(0.28, 0.18, 1.2), Vector3(-10.1 - i * 0.28, -0.09 - i * 0.18, 0.15), conc)    # down
	box(Vector3(1.0, 0.2, 3.3), Vector3(-12.45, 1.26, 1.25), conc)        # the half landing up
	box(Vector3(0.05, 1.0, 3.3), Vector3(-12.0, 1.85, 1.25), _steel)
	box(Vector3(0.05, 0.9, 1.9), Vector3(-10.5, 0.45, 1.25), _steel)      # rail between the flights
	box(Vector3(2.6, 0.05, 0.05), Vector3(-11.1, 0.95, 1.25), _steel)
	# tape across both flights, and a solid so Carl stays on the landing
	var tape := mat(Color(0.95, 0.8, 0.1), 0.7)
	for z: float in [0.15, 2.35]:
		var tp := box(Vector3(0.02, 0.06, 1.2), Vector3(-9.98, 0.9, z), tape)
		tp.rotation.x = 0.1
		solid_box(Vector3(0.1, 2.5, 1.3), Vector3(-9.98, 1.25, z))
	neon_text("STAIR 79", Vector3(-9.1, 2.3, 1.05), PI / 2.0, 0.08, Color(0.3, 1.0, 0.5), 1.8)
	# the door, propped with an extinguisher on its side
	var piv := Node3D.new()
	piv.position = Vector3(-9.06, 0, 1.55)
	piv.rotation.y = -1.3
	add_child(piv)
	box(Vector3(0.05, 2.1, 0.9), Vector3(0, 1.05, -0.45), mat(Color(0.3, 0.3, 0.32), 0.4, 0.6), false, piv)
	var ext := cyl(0.08, 0.08, 0.45, Vector3(-9.5, 0.08, 0.5), mat(Color(0.7, 0.12, 0.1), 0.4, 0.3), 10)
	ext.rotation.z = PI / 2.0
	_pulser(Vector3(-11.0, H - 0.3, 1.25), Color(0.7, 0.68, 0.9), 0.9, 5.0, 3.0)
	box(Vector3(0.5, 0.03, 1.0), Vector3(-11.0, H + 1.7, 1.25), _panel)
	interactable("stair", "The service stair", Vector3(-9.0, 1.1, 1.05), Vector3(0.3, 2.1, 1.0), LINES["scan"]["stair"], false)


## Unit 45A, west side, its door open a hand's width: a wall screen on a
## loop in an empty room, the ad's light flickering through the gap.
func _ajar_unit() -> void:
	_unit_door(Vector3(-5.94, 0, 5.0), PI / 2.0, "45A", Color(0.2, 1.0, 0.5), false)
	var piv := Node3D.new()
	piv.position = Vector3(-5.94, 0, 4.45)
	piv.rotation.y = 0.25
	add_child(piv)
	box(Vector3(0.06, 2.15, 1.0), Vector3(0, 1.075, 0.5), mat(Color(0.2, 0.22, 0.2), 0.5), false, piv)
	# the room behind: dark, x -9..-6, z 3.6..6.4
	var room_w := mat(Color(0.14, 0.15, 0.14), 0.9)
	box(Vector3(3.0, H, 2.8), Vector3(-7.5, H / 2, 5.0), room_w)
	# the screen is a glow on the room's near wall, seen through the gap
	ajar_screen = quad(Vector2(1.4, 0.8), Vector3(-6.3, 1.5, 5.0), PI / 2.0, newglow(Color(0.3, 1.0, 0.55), 1.4))
	no_batch.append(ajar_screen)
	_pulser(Vector3(-6.4, 1.3, 5.0), Color(0.3, 1.0, 0.55), 0.9, 2.5, 0.0)
	interactable("ajar", "Unit 45A", Vector3(-5.9, 1.1, 5.0), Vector3(0.25, 2.1, 1.0), LINES["scan"]["ajar"], false)


# ------------------------------------------------------------------ the shell

func _shell() -> void:
	var t := 0.12
	# the hall: a pocket wall east for the sliding door
	_wall_box(Vector3(t, H, 3.5), Vector3(-1.2, H / 2, -1.75))
	_wall_box(Vector3(t, H, 1.1), Vector3(1.2, H / 2, -0.55))        # pocket side, to the bathroom door
	_wall_box(Vector3(t, H, 1.3), Vector3(1.2, H / 2, -2.85))
	_wall_box(Vector3(t, H - 2.05, 1.0), Vector3(1.2, 2.05 + (H - 2.05) / 2, -1.6))
	# living room south wall (west of the hall), the notes go on it
	_wall_box(Vector3(4.8, H, t), Vector3(-3.6, H / 2, -3.5))
	# west and north (the window wall is glass; a sill and a lintel)
	_wall_box(Vector3(t, H, 7.5), Vector3(-6.0, H / 2, -7.25))
	_wall_box(Vector3(13.0, 0.5, t), Vector3(0.5, 0.25, -11.0))
	_wall_box(Vector3(13.0, H - 2.5, t), Vector3(0.5, 2.5 + (H - 2.5) / 2, -11.0))
	# east: the bedroom wall with its doorway at z -5.2..-4.3
	_wall_box(Vector3(t, H, 0.8), Vector3(2.0, H / 2, -3.9))
	_wall_box(Vector3(t, H, 5.8), Vector3(2.0, H / 2, -8.1))
	_wall_box(Vector3(t, H - 2.05, 0.9), Vector3(2.0, 2.05 + (H - 2.05) / 2, -4.75))
	# bathroom: x 1.2..4.5, z -3.4..-0.1 (door on the hall side at z -1.6)
	_wall_box(Vector3(3.3, H, t), Vector3(2.85, H / 2, -3.45))
	_wall_box(Vector3(t, H, 3.4), Vector3(4.5, H / 2, -1.75))
	_wall_box(Vector3(3.3, H, t), Vector3(2.85, H / 2, -0.05))
	# bedroom east wall and the solid of the next unit
	_wall_box(Vector3(t, H, 7.6), Vector3(7.0, H / 2, -7.2))
	_wall_box(Vector3(2.5, H, 3.5), Vector3(5.75, H / 2, -1.75), _wall)
	# floors
	var boards := pbr("woodfloor", Vector3(1, 1, 1) / 2.2, true, Color(0.62, 0.6, 0.6))
	floor_quad(Vector2(2.4, 3.5), Vector3(0, 0.0, -1.75), 0.0, boards)
	floor_quad(Vector2(8.0, 7.5), Vector3(-2.0, 0.0, -7.25), 0.0, boards)
	var carpet := pbr("carpet", Vector3(1, 1, 1) / 1.4, true, Color(0.55, 0.55, 0.6))
	floor_quad(Vector2(5.0, 7.5), Vector3(4.5, 0.0, -7.25), 0.0, carpet)
	var tile := pbr("paving", Vector3(1, 1, 1) / 0.5, true, Color(0.85, 0.88, 0.9), 0.5)
	floor_quad(Vector2(3.3, 3.4), Vector3(2.85, 0.0, -1.75), 0.0, tile)
	# ceilings
	var ceil_m := mat(Color(0.6, 0.6, 0.62), 0.95)
	box(Vector3(13.2, 0.2, 11.2), Vector3(0.5, H + 0.1, -5.5), ceil_m)
	# skirting
	for seg in [[Vector3(4.8, 0.1, 0.05), Vector3(-3.6, 0.05, -3.58)], [Vector3(0.05, 0.1, 7.5), Vector3(-5.92, 0.05, -7.25)],
			[Vector3(0.05, 0.1, 5.8), Vector3(1.92, 0.05, -8.1)], [Vector3(0.05, 0.1, 7.6), Vector3(6.92, 0.05, -7.2)],
			[Vector3(0.05, 0.1, 3.5), Vector3(-1.12, 0.05, -1.75)]]:
		box(seg[0], seg[1], _trim)
	# door frames
	for z: float in [-4.3, -5.2]:
		box(Vector3(0.16, 2.05, 0.08), Vector3(2.0, 1.025, z), _trim)
	box(Vector3(0.16, 0.08, 0.98), Vector3(2.0, 2.05, -4.75), _trim)
	for z: float in [-1.1, -2.1]:
		box(Vector3(0.16, 2.05, 0.08), Vector3(1.2, 1.025, z), _trim)
	box(Vector3(0.16, 0.08, 1.08), Vector3(1.2, 2.05, -1.6), _trim)
	# the front door: a flush panel that slides east into the pocket
	box(Vector3(0.1, 2.15, 0.16), Vector3(-0.55, 1.075, 0.0), _trim)
	box(Vector3(0.1, 2.15, 0.16), Vector3(0.55, 1.075, 0.0), _trim)
	door_panel = Node3D.new()
	add_child(door_panel)
	var dm := mat(Color(0.24, 0.27, 0.25), 0.45)
	box(Vector3(1.0, 2.12, 0.06), Vector3(0, 1.06, 0), dm, false, door_panel)
	box(Vector3(0.03, 0.5, 0.08), Vector3(-0.38, 1.05, 0.0), _steel, false, door_panel)
	label("LYNX", Vector3(0.15, 1.6, 0.04), 0.0, 0.0028, Color(0.6, 0.65, 0.6), door_panel, false)
	door_body = interactable("door", "Her door", Vector3(0, 1.06, 0), Vector3(1.0, 2.12, 0.14), "", true, door_panel)
	door_body.set_meta("hackable", true)
	for c in door_panel.get_children():
		no_batch.append(c)


# ------------------------------------------------------------------ the hall

func _hall() -> void:
	_pulser(Vector3(0, H - 0.25, -1.7), Color(0.8, 0.74, 0.95), 1.1, 5.0, 1.3)
	box(Vector3(0.4, 0.03, 0.4), Vector3(0, H - 0.01, -1.7), _panel)
	# the ORA home hub by the door, awake when nothing else is
	var hub := Vector3(-1.12, 1.45, -0.7)
	box(Vector3(0.03, 0.34, 0.34), hub, mat(Color(0.08, 0.08, 0.09), 0.3, 0.4))
	var ring := TorusMesh.new()
	ring.inner_radius = 0.09
	ring.outer_radius = 0.11
	ring.rings = 24
	ring.ring_segments = 6
	hub_ring = mesh(ring, hub + Vector3(0.02, 0, 0), glow(Color(0.2, 1.0, 0.5), 1.6))
	hub_ring.rotation.z = PI / 2.0
	no_batch.append(hub_ring)
	neon_text("UNIT 45C\nOCCUPANT: --", hub + Vector3(0.02, -0.24, 0), PI / 2.0, 0.03, Color(0.3, 1.0, 0.6), 1.5)
	interactable("hub", "Look at the home hub", hub, Vector3(0.1, 0.4, 0.4), LINES["scan"]["hub"], false).set_meta("hackable", true)
	# her shoes in a row, laces out, sorted by colour. The coat hooks: empty.
	var shoe_c := [Color(0.1, 0.1, 0.12), Color(0.5, 0.45, 0.4), Color(0.7, 0.7, 0.72)]
	for i in 6:
		box(Vector3(0.1, 0.07, 0.26), Vector3(-0.95 + (i % 2) * 0.13, 0.035, -1.2 - (i / 2) * 0.32), mat(shoe_c[i / 2], 0.6))
	for i in 3:
		box(Vector3(0.03, 0.1, 0.03), Vector3(-1.12, 1.75, -1.6 - i * 0.3), _steel)
	# photos of Nathan start here, at the door
	_photo(Vector3(1.14, 1.55, -2.9), -PI / 2.0, 1)
	# a dead robot vacuum, dismantled, every part in a row along the wall
	var parts := [Vector3(0.3, 0.03, 0.3), Vector3(0.12, 0.04, 0.12), Vector3(0.08, 0.08, 0.08), Vector3(0.2, 0.02, 0.05),
		Vector3(0.05, 0.05, 0.05), Vector3(0.14, 0.02, 0.14)]
	for i in parts.size():
		box(parts[i], Vector3(0.95, parts[i].y / 2.0 + 0.002, -0.4 - i * 0.42), mat(Color(0.12, 0.12, 0.13), 0.4, 0.4))
	interactable("vacuum", "Look at the parts on the floor", Vector3(0.95, 0.08, -1.5), Vector3(0.4, 0.16, 2.4), LINES["scan"]["vacuum"], false)


## A framed photograph of Nathan, hung straight.
func _photo(pos: Vector3, rot_y: float, seed_n: int, size := Vector2(0.3, 0.38)) -> void:
	var frame := mat(Color(0.12, 0.11, 0.1), 0.5)
	var fb := box(Vector3(size.x + 0.05, size.y + 0.05, 0.025), pos, frame)
	fb.rotation.y = rot_y
	var fwd := Basis(Vector3.UP, rot_y) * Vector3(0, 0, 0.015)
	quad(size, pos + fwd, rot_y, tex_mat(_photo_tex(seed_n), Vector3.ONE, 0.5))


## A grainy picture: a man in a corporate car, at a rail, at a table.
## Printed warm, like something that was looked at a lot.
func _photo_tex(s: int) -> ImageTexture:
	var r := RandomNumberGenerator.new()
	r.seed = 900 + s
	var w := 48
	var h := 60
	var img := Image.create(w, h, false, Image.FORMAT_RGB8)
	var bg := Color(0.55, 0.42, 0.3) if s % 2 == 0 else Color(0.35, 0.4, 0.5)
	for y in h:
		for x in w:
			var c := bg.lerp(Color(0.9, 0.8, 0.65), float(y) / h * 0.5)
			img.set_pixel(x, y, c * (1.0 + r.randf_range(-0.12, 0.12)))
	# a shoulder line, a head
	var hx := w / 2.0 + r.randf_range(-8, 8)
	var hy := 26.0 + r.randf_range(-3, 3)
	for y in h:
		for x in w:
			var p := Vector2(x - hx, y - hy)
			var head := Vector2(p.x / 7.0, p.y / 9.0).length() < 1.0
			var torso := y > hy + 9 and absf(p.x) < 13.0 - (y - hy - 9) * 0.1
			if head:
				img.set_pixel(x, y, Color(0.72, 0.55, 0.42) * (1.0 + r.randf_range(-0.08, 0.08)))
				if p.y < -5.0:
					img.set_pixel(x, y, Color(0.15, 0.1, 0.08))
			elif torso:
				img.set_pixel(x, y, (Color(0.12, 0.14, 0.16) if s % 3 == 0 else Color(0.8, 0.8, 0.78)) * (1.0 + r.randf_range(-0.1, 0.1)))
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


# ------------------------------------------------------------------ the living room

func _living_room() -> void:
	# the window wall: floor to lintel glass, mullions, the city behind it
	var glass := newmat(Color(0.5, 0.6, 0.75, 0.16), 0.05, 0.3)
	glass.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	glass.cull_mode = BaseMaterial3D.CULL_DISABLED
	var gl := box(Vector3(13.0, 2.0, 0.03), Vector3(0.5, 1.5, -11.0), glass, true)
	gl.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	for x: float in [-6.0, -4.0, -2.0, 0.0, 2.0, 4.0, 6.0]:
		box(Vector3(0.08, 2.0, 0.08), Vector3(x, 1.5, -11.0), _dark)
	box(Vector3(13.0, 0.06, 0.1), Vector3(0.5, 2.5, -11.0), _dark)
	box(Vector3(13.0, 0.08, 0.3), Vector3(0.5, 0.52, -10.95), _plastic)   # the sill
	interactable("window", "Look out", Vector3(-2.0, 1.5, -10.9), Vector3(7.8, 2.0, 0.2), LINES["scan"]["window"], false)
	# dead smart blinds, down to different heights, the motors hanging
	var blind := mat(Color(0.75, 0.75, 0.72), 0.8)
	for b in [[-5.0, 0.6], [-3.0, 1.4], [-1.0, 0.3], [1.0, 1.05]]:
		box(Vector3(1.9, b[1], 0.02), Vector3(b[0], 2.45 - b[1] / 2.0, -10.86), blind)
	box(Vector3(13.0, 0.1, 0.12), Vector3(0.5, 2.45, -10.86), _dark)
	# the city's light coming in: magenta from the west, cyan from the east
	light(Vector3(-3.5, 1.6, -10.5), Color(1.0, 0.3, 0.7), 0.9, 7.0, false)
	light(Vector3(4.0, 1.6, -10.5), Color(0.3, 0.9, 1.0), 0.8, 6.5, false)
	# the ceiling light, pulsing
	_pulser(Vector3(-2.0, H - 0.3, -7.2), Color(0.8, 0.74, 0.95), 1.4, 7.0, 0.0)
	box(Vector3(1.2, 0.03, 0.3), Vector3(-2.0, H - 0.01, -7.2), _panel)
	# couch facing the window, a low table, the wall screen dark
	var couch := pbr("fabric", Vector3(1, 1, 1) / 1.0, true, Color(0.42, 0.45, 0.4))
	box(Vector3(2.4, 0.42, 0.9), Vector3(-2.0, 0.21, -7.8), couch, true)
	box(Vector3(2.4, 0.45, 0.22), Vector3(-2.0, 0.6, -7.45), couch)
	for s: float in [-1.0, 1.0]:
		box(Vector3(0.2, 0.55, 0.9), Vector3(-2.0 + s * 1.2, 0.275, -7.8), couch)
	var table_m := mat(Color(0.16, 0.15, 0.14), 0.4)
	box(Vector3(1.2, 0.04, 0.6), Vector3(-2.0, 0.4, -9.2), table_m, true)
	for x: float in [-0.55, 0.55]:
		box(Vector3(0.04, 0.38, 0.5), Vector3(-2.0 + x, 0.19, -9.2), table_m)
	# the Psyon pillow on the couch, its fourteen contacts cut out and laid
	# on the table in a row
	box(Vector3(0.7, 0.16, 0.45), Vector3(-2.6, 0.5, -7.9), mat(Color(0.88, 0.88, 0.9), 0.9))
	for i in 14:
		cyl(0.012, 0.012, 0.004, Vector3(-2.5 + i * 0.07, 0.423, -9.05), _steel, 8)
	interactable("pillow", "Look at the pillow", Vector3(-2.6, 0.5, -7.9), Vector3(0.8, 0.25, 0.5), LINES["scan"]["pillow"], false)
	interactable("contacts", "Look at the table", Vector3(-2.0, 0.44, -9.1), Vector3(1.2, 0.1, 0.5), LINES["scan"]["contacts"], false)
	# the wall screen on the bedroom wall, dark; the red standby dot
	box(Vector3(0.05, 0.9, 1.6), Vector3(1.94, 1.55, -8.8), mat(Color(0.02, 0.02, 0.02), 0.2, 0.3))
	box(Vector3(0.01, 0.03, 0.06), Vector3(1.9, 1.05, -8.8), glow(Color(1, 0.05, 0.05), 3.0))
	interactable("tv", "Look at the wall screen", Vector3(1.9, 1.55, -8.8), Vector3(0.12, 0.9, 1.6), LINES["scan"]["tv"], false).set_meta("hackable", true)
	# a shelf of her books, spines out, sorted by height
	var shelf := mat(Color(0.3, 0.28, 0.25), 0.6)
	box(Vector3(0.25, 0.03, 1.6), Vector3(-5.85, 1.3, -9.6), shelf)
	box(Vector3(0.25, 0.03, 1.6), Vector3(-5.85, 1.75, -9.6), shelf)
	var book_c := [Color(0.5, 0.15, 0.12), Color(0.15, 0.2, 0.4), Color(0.7, 0.65, 0.5), Color(0.12, 0.3, 0.25)]
	for i in 18:
		var bh := 0.18 + (i % 9) * 0.02
		box(Vector3(0.16, bh, 0.035), Vector3(-5.85, (1.315 if i < 9 else 1.765) + bh / 2.0, -10.35 + (i % 9) * 0.085 + (0.9 if i >= 9 else 0.0)), mat(book_c[i % 4], 0.8))
	# the smashed ORA frames on the floor between the couch and the notes
	_smashed_frames(Vector3(-1.4, 0.0, -5.4))
	# pictures of Nathan
	_photo(Vector3(1.94, 1.5, -6.2), -PI / 2.0, 2)
	_photo(Vector3(1.94, 1.5, -10.2), -PI / 2.0, 3, Vector2(0.42, 0.3))
	_photo(Vector3(-5.94, 1.5, -5.0), PI / 2.0, 4)
	_photo(Vector3(-5.94, 1.95, -5.0), PI / 2.0, 5, Vector2(0.24, 0.3))
	interactable("photos", "Look at the pictures", Vector3(1.9, 1.5, -6.2), Vector3(0.12, 0.6, 0.6), "", false)
	interactable("photos2", "Look at the pictures", Vector3(-5.9, 1.7, -5.0), Vector3(0.12, 0.9, 0.6), "", false)
	# a dead plant on the sill. Everything else alive left.
	cyl(0.1, 0.08, 0.16, Vector3(-4.5, 0.64, -10.8), mat(Color(0.5, 0.35, 0.25), 0.9), 8)
	for i in 5:
		var a := i * 1.3
		stick(Vector3(-4.5, 0.72, -10.8), Vector3(-4.5 + cos(a) * 0.12, 0.6 + rng.randf_range(0.0, 0.1), -10.8 + sin(a) * 0.08), 0.004, mat(Color(0.3, 0.25, 0.15), 0.9))


## "One lens cracked, the other warped into an almost eye-like shape.
## Wires spilled from the arms like exposed nerves."
func _smashed_frames(p: Vector3) -> void:
	var fm := mat(Color(0.1, 0.1, 0.11), 0.35, 0.5)
	var lens := newmat(Color(0.5, 0.7, 0.8, 0.5), 0.1)
	lens.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	var wire := mat(Color(0.9, 0.3, 0.2), 0.6)
	var wire2 := mat(Color(0.85, 0.85, 0.3), 0.6)
	# the bridge and one arm, the other arm snapped off a hand's width away
	box(Vector3(0.14, 0.012, 0.01), p + Vector3(0, 0.01, 0), fm)
	var arm := box(Vector3(0.012, 0.012, 0.13), p + Vector3(0.07, 0.01, 0.07), fm)
	arm.rotation.y = -0.3
	var arm2 := box(Vector3(0.012, 0.012, 0.11), p + Vector3(-0.2, 0.01, 0.12), fm)
	arm2.rotation.y = 0.9
	# the cracked lens, flat; the warped one standing, pinched to an almond
	floor_quad(Vector2(0.05, 0.04), p + Vector3(-0.045, 0.012, 0.0), 0.2, lens)
	var warped := sphere(0.028, p + Vector3(0.045, 0.02, -0.01), lens, 10)
	warped.scale = Vector3(1.0, 0.5, 0.8)
	sphere(0.008, p + Vector3(0.045, 0.024, -0.01), _dark, 8)
	for i in 7:
		var a := p + Vector3(0.07 + rng.randf_range(-0.02, 0.02), 0.012, 0.13)
		var q := a
		for s in 3:
			var n := q + Vector3(rng.randf_range(-0.05, 0.05), 0.0, rng.randf_range(0.02, 0.07))
			n.y = 0.006
			stick(q, n, 0.0022, wire if i % 2 == 0 else wire2)
			q = n
	interactable("frames", "Look at the frames on the floor", p + Vector3(0, 0.04, 0.06), Vector3(0.5, 0.08, 0.5), LINES["scan"]["frames"], false).set_meta("hackable", true)


# ------------------------------------------------------------------ the sticky notes

## A perfect grid on the south wall: equations, coordinates, the same
## three phrases over and over.
func _notes() -> void:
	var cols := [mat(Color(0.95, 0.85, 0.3), 0.9), mat(Color(0.92, 0.8, 0.25), 0.9), mat(Color(0.98, 0.9, 0.45), 0.9)]
	var pink := mat(Color(0.95, 0.55, 0.65), 0.9)
	var ink := mat(Color(0.08, 0.06, 0.1), 0.8)
	var phrases: Array = LINES["notes"]["phrases"]
	var nx := 24
	var ny := 10
	var x0 := -5.6
	var y0 := 2.2
	var pitch := 0.165
	var n := 0
	for j in ny:
		for i in nx:
			var p := Vector3(x0 + i * pitch, y0 - j * pitch, -3.57 - 0.0005 * (n % 3))
			var m: StandardMaterial3D = cols[(i * 7 + j * 3) % 3]
			if (i * 13 + j * 5) % 23 == 0:
				m = pink
			var q := quad(Vector2(0.14, 0.14), p, PI, m)
			q.rotation.z = rng.randf_range(-0.03, 0.03)
			n += 1
	# a few you can read, pinned at eye height
	for i in phrases.size():
		var col := (i * 5) % nx
		var row := 1 + (i * 3) % 7
		var p := Vector3(x0 + col * pitch + 0.06, y0 - row * pitch + 0.045, -3.576)
		_ink(phrases[i], p, PI, 0.022, ink)
	# a line of red thread between four of them, drawing pins
	var thread := mat(Color(0.7, 0.1, 0.1), 0.7)
	var pins := [Vector3(-5.2, 1.9, -3.58), Vector3(-2.3, 1.1, -3.58), Vector3(-3.9, 0.75, -3.58), Vector3(-1.6, 2.1, -3.58)]
	for k in pins.size():
		sphere(0.01, pins[k], thread, 6)
		stick(pins[k], pins[(k + 1) % pins.size()], 0.002, thread)
	interactable("notes", "Read the notes", Vector3(-3.6, 1.5, -3.62), Vector3(4.6, 1.8, 0.12), "", false)


## Small matte lettering (TextMesh) so it batches with the rest.
func _ink(text: String, pos: Vector3, rot_y: float, height: float, m: Material) -> MeshInstance3D:
	var tm := TextMesh.new()
	tm.text = text
	tm.font_size = 32
	tm.pixel_size = height / 32.0
	tm.depth = 0.0
	tm.curve_step = 3.0
	tm.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	var mi := MeshInstance3D.new()
	mi.mesh = tm
	mi.material_override = m
	mi.position = pos
	mi.rotation.y = rot_y
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(mi)
	return mi


# ------------------------------------------------------------------ the kitchen

## Along the west wall. Dissected: every drawer out and laid on the floor
## in a row, the contents sorted by kind.
func _kitchen() -> void:
	var unit := mat(Color(0.7, 0.72, 0.68), 0.5)
	var top := mat(Color(0.15, 0.15, 0.16), 0.3)
	box(Vector3(0.62, 0.88, 2.6), Vector3(-5.65, 0.44, -5.0), unit, true)
	box(Vector3(0.66, 0.04, 2.7), Vector3(-5.65, 0.9, -5.0), top)
	box(Vector3(0.36, 0.7, 2.6), Vector3(-5.78, 2.1, -5.0), unit)     # wall cabinets
	box(Vector3(0.6, 0.02, 2.6), Vector3(-5.6, 1.74, -5.0), newglow(Color(0.6, 0.9, 1.0), 0.5))
	# drawer holes where the drawers were: dark slots
	for i in 4:
		box(Vector3(0.02, 0.16, 0.5), Vector3(-5.35, 0.3 + (i % 2) * 0.3, -4.3 - (i / 2) * 1.2), _dark)
	# the fridge, its screen dead
	box(Vector3(0.68, 1.9, 0.75), Vector3(-5.62, 0.95, -3.9), mat(Color(0.8, 0.8, 0.78), 0.3, 0.3), true)
	box(Vector3(0.01, 0.3, 0.4), Vector3(-5.27, 1.4, -3.9), _dark)
	interactable("fridge", "Look at the fridge", Vector3(-5.3, 1.0, -3.9), Vector3(0.1, 1.8, 0.7), LINES["scan"]["fridge"], false)
	# the drawers on the floor in a row, their contents sorted beside them
	var drawer := mat(Color(0.6, 0.6, 0.58), 0.6)
	for i in 4:
		var dp := Vector3(-4.6, 0.07, -4.2 - i * 0.62)
		box(Vector3(0.5, 0.14, 0.42), dp, drawer, true)
		box(Vector3(0.46, 0.02, 0.38), dp + Vector3(0, 0.03, 0), _dark)
	# cutlery, cables, batteries, screws: rows
	for i in 10:
		box(Vector3(0.02, 0.004, 0.18), Vector3(-3.9 + i * 0.05, 0.004, -4.2), _steel)
	for i in 6:
		var ring := TorusMesh.new()
		ring.inner_radius = 0.035
		ring.outer_radius = 0.05
		ring.rings = 12
		ring.ring_segments = 5
		mesh(ring, Vector3(-3.9 + i * 0.13, 0.01, -4.85), _dark)
	for i in 8:
		cyl(0.007, 0.007, 0.05, Vector3(-3.9 + i * 0.05, 0.007, -5.45), mat(Color(0.8, 0.75, 0.2), 0.5, 0.6), 6).rotation.z = PI / 2.0
	for i in 12:
		box(Vector3(0.008, 0.008, 0.03), Vector3(-3.9 + i * 0.04, 0.004, -6.05), _steel)
	interactable("drawers", "Look at the drawers", Vector3(-4.3, 0.1, -5.1), Vector3(1.4, 0.2, 2.6), "", false)
	# one mug, washed, upside down. Nothing else on the counter.
	cyl(0.04, 0.035, 0.09, Vector3(-5.65, 0.965, -5.9), _plastic, 10)


# ------------------------------------------------------------------ the bathroom

## Where the smell lives: she took her devices apart in the bath, in an
## inch of something that strips solder, and wrote on the mirror.
func _bathroom() -> void:
	var white := mat(Color(0.9, 0.9, 0.9), 0.3)
	var tile := pbr("paving", Vector3(1, 1, 1) / 0.4, true, Color(0.75, 0.8, 0.82), 0.4)
	for seg in [[Vector3(0.03, 1.6, 3.3), Vector3(4.42, 0.8, -1.75)], [Vector3(3.3, 1.6, 0.03), Vector3(2.85, 0.8, -3.37)],
			[Vector3(3.3, 1.6, 0.03), Vector3(2.85, 0.8, -0.13)]]:
		box(seg[0], seg[1], tile)
	# the tub along the east wall
	box(Vector3(0.8, 0.55, 1.7), Vector3(4.05, 0.275, -2.5), white, true)
	box(Vector3(0.64, 0.4, 1.54), Vector3(4.05, 0.4, -2.5), mat(Color(0.8, 0.82, 0.8), 0.3))
	var solvent := newmat(Color(0.5, 0.55, 0.35, 0.55), 0.05)
	solvent.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	box(Vector3(0.62, 0.02, 1.52), Vector3(4.05, 0.3, -2.5), solvent)
	# what's in it: boards, lenses, the arms of three pairs of frames, a tablet
	var board := mat(Color(0.1, 0.35, 0.2), 0.5)
	for i in 9:
		var b := box(Vector3(rng.randf_range(0.05, 0.12), 0.004, rng.randf_range(0.04, 0.1)),
			Vector3(3.85 + (i % 3) * 0.2, 0.26, -3.1 + (i / 3) * 0.45), board)
		b.rotation.y = rng.randf_range(-0.3, 0.3)
	box(Vector3(0.18, 0.01, 0.26), Vector3(4.1, 0.27, -1.9), _dark)
	for i in 5:
		stick(Vector3(3.8 + i * 0.1, 0.27, -2.3), Vector3(3.84 + i * 0.1, 0.27, -2.45), 0.004, _dark)
	interactable("bath", "Look in the bath", Vector3(4.05, 0.5, -2.5), Vector3(0.8, 0.3, 1.7), LINES["scan"]["bath"], false)
	# basin and mirror on the south wall, the toilet by the door
	box(Vector3(0.5, 0.15, 0.4), Vector3(2.4, 0.85, -0.35), white, true)
	box(Vector3(0.5, 0.75, 0.3), Vector3(2.4, 0.37, -0.3), white)
	box(Vector3(0.03, 0.12, 0.03), Vector3(2.4, 0.98, -0.2), _steel)
	var mirror := mat(Color(0.75, 0.8, 0.85), 0.05, 1.0)
	box(Vector3(0.7, 0.8, 0.02), Vector3(2.4, 1.6, -0.16), mirror)
	# her writing on the mirror, in black marker, where her face would be
	_ink(LINES["mirror"]["text"], Vector3(2.72, 1.72, -0.175), PI, 0.05, mat(Color(0.04, 0.03, 0.04), 0.7))
	_ink(LINES["mirror"]["text2"], Vector3(2.68, 1.45, -0.175), PI, 0.035, mat(Color(0.04, 0.03, 0.04), 0.7))
	interactable("mirror", "Look at the mirror", Vector3(2.4, 1.6, -0.22), Vector3(0.7, 0.8, 0.15), "", false)
	cyl(0.18, 0.2, 0.4, Vector3(3.6, 0.2, -0.55), white, 12)
	box(Vector3(0.4, 0.4, 0.2), Vector3(3.6, 0.5, -0.3), white)
	# the ORA mirror cam over the basin, a hole where it was
	box(Vector3(0.05, 0.05, 0.03), Vector3(2.4, 2.1, -0.16), _dark)
	# the light: a cold tube with a bad starter
	var tube := newglow(Color(0.7, 0.9, 0.8), 1.0)
	var tb := box(Vector3(0.9, 0.03, 0.06), Vector3(2.85, H - 0.02, -1.75), tube)
	flickers.append(tb)
	no_batch.append(tb)
	_pulser(Vector3(2.85, H - 0.3, -1.75), Color(0.6, 0.9, 0.8), 0.9, 4.5, 2.1)
	# the bathroom door, ajar into the room
	var piv := Node3D.new()
	piv.position = Vector3(1.26, 0, -2.08)
	piv.rotation.y = 1.1
	add_child(piv)
	box(Vector3(0.05, 2.05, 0.9), Vector3(0, 1.025, 0.45), mat(Color(0.24, 0.27, 0.25), 0.45), false, piv)


# ------------------------------------------------------------------ the bedroom

## "Surprisingly clean. It looked like it had never been lived in. The bed
## was made tightly, causing the sheets and blankets to look like solid
## plastic rather than cloth."
func _bedroom() -> void:
	# the bed: frame, mattress, a sheet drawn so tight it shines
	var frame := mat(Color(0.2, 0.18, 0.17), 0.5)
	box(Vector3(2.1, 0.25, 1.6), BED_C + Vector3(0, 0.2, 0), frame, true)
	for x: float in [-0.95, 0.95]:
		for z: float in [-0.7, 0.7]:
			box(Vector3(0.08, 0.1, 0.08), BED_C + Vector3(x, 0.05, z), frame)
	var sheet := mat(Color(0.86, 0.88, 0.9), 0.18)
	box(Vector3(2.0, 0.26, 1.5), BED_C + Vector3(0, 0.45, 0), sheet)
	box(Vector3(2.0, 0.05, 1.5), BED_C + Vector3(0, 0.6, 0), mat(Color(0.8, 0.82, 0.86), 0.12))   # the blanket, like plastic
	box(Vector3(0.5, 0.1, 1.3), BED_C + Vector3(0.7, 0.63, 0), mat(Color(0.95, 0.95, 0.96), 0.2))  # the pillow
	solid_box(Vector3(2.1, 0.65, 1.6), BED_C + Vector3(0, 0.32, 0))
	# headboard against the east wall
	box(Vector3(0.08, 1.1, 1.7), Vector3(6.92, 0.65, -8.5), frame)
	# bedside table and a lamp, off
	box(Vector3(0.45, 0.5, 0.45), Vector3(6.6, 0.25, -9.75), frame, true)
	cyl(0.03, 0.06, 0.25, Vector3(6.6, 0.62, -9.75), _steel, 8)
	cyl(0.12, 0.14, 0.14, Vector3(6.6, 0.8, -9.75), mat(Color(0.7, 0.65, 0.55), 0.8), 10)
	# a wardrobe on the south wall, its doors open, everything on hangers
	# sorted by colour
	var ward := mat(Color(0.3, 0.28, 0.26), 0.6)
	box(Vector3(1.6, 2.1, 0.6), Vector3(5.0, 1.05, -3.8), ward, true)
	box(Vector3(1.5, 1.9, 0.02), Vector3(5.0, 1.05, -4.09), _dark)
	var clothes := [Color(0.1, 0.1, 0.12), Color(0.25, 0.28, 0.35), Color(0.45, 0.45, 0.5), Color(0.7, 0.68, 0.65), Color(0.85, 0.85, 0.88)]
	for i in 10:
		box(Vector3(0.06, 0.9, 0.3), Vector3(4.35 + i * 0.14, 1.3, -3.85), mat(clothes[i / 2], 0.8))
	box(Vector3(1.4, 0.02, 0.02), Vector3(5.0, 1.8, -3.85), _steel)
	# the bedroom window with its blind down: the city through the slats
	for i in 12:
		box(Vector3(3.2, 0.03, 0.01), Vector3(4.5, 2.4 - i * 0.14, -10.86), mat(Color(0.75, 0.75, 0.72), 0.8))
	# a desk under the window, empty. A rectangle of dust where the laptop lived.
	box(Vector3(1.2, 0.04, 0.55), Vector3(3.2, 0.74, -10.6), ward, true)
	for x: float in [-0.55, 0.55]:
		box(Vector3(0.04, 0.72, 0.5), Vector3(3.2 + x, 0.36, -10.6), ward)
	floor_quad(Vector2(0.34, 0.24), Vector3(3.2, 0.765, -10.55), 0.0, mat(Color(0.26, 0.25, 0.24), 0.7))
	var chair := mat(Color(0.15, 0.15, 0.16), 0.5)
	box(Vector3(0.45, 0.05, 0.45), Vector3(3.2, 0.46, -9.9), chair)
	box(Vector3(0.45, 0.5, 0.05), Vector3(3.2, 0.72, -9.68), chair)
	cyl(0.025, 0.025, 0.44, Vector3(3.2, 0.22, -9.9), chair, 6)
	# the light over the bed, pulsing: it lights the ceiling
	bed_light = _pulser(Vector3(4.6, H - 0.4, -8.0), Color(0.82, 0.74, 0.95), 1.3, 6.5, 0.6)
	box(Vector3(0.4, 0.03, 0.4), Vector3(4.6, H - 0.01, -8.0), _panel)
	# the laptop on the pillow, silver, closed to a crack
	laptop = Node3D.new()
	laptop.position = LAPTOP_P
	laptop.rotation.y = PI / 2.0
	add_child(laptop)
	var body := mat(Color(0.78, 0.79, 0.81), 0.3, 0.7)
	box(Vector3(0.34, 0.016, 0.23), Vector3(0, 0.008, 0), body, false, laptop)
	var lid := Node3D.new()
	lid.position = Vector3(0, 0.016, -0.115)
	lid.rotation.x = 0.35
	laptop.add_child(lid)
	box(Vector3(0.34, 0.22, 0.01), Vector3(0, 0.11, -0.006), body, false, lid)
	laptop_screen = quad(Vector2(0.31, 0.19), Vector3(0, 0.11, 0.0), 0.0, newglow(Color(0.02, 0.03, 0.03), 0.3), lid)
	label("IONWARE", Vector3(0, 0.11, -0.012), PI, 0.0004, Color(0.3, 0.3, 0.3), lid, false)
	interactable("laptop", "Her laptop", Vector3(0, 0.1, 0), Vector3(0.42, 0.25, 0.34), LINES["scan"]["laptop"], false, laptop).set_meta("hackable", true)
	laptop_light = light(LAPTOP_P + Vector3(-0.3, 0.3, 0), Color(0.5, 0.9, 1.0), 0.0, 2.5, false)
	no_batch.append(laptop_screen)


## The eye sigil over the headboard, plastered in black: an oval, an
## iris, a pupil; the paint ran.
func _sigil() -> void:
	var black := mat(Color(0.02, 0.02, 0.025), 0.75)
	var c := Vector3(6.93, 1.75, -8.5)
	var tm := TorusMesh.new()
	tm.inner_radius = 0.42
	tm.outer_radius = 0.48
	tm.rings = 28
	tm.ring_segments = 6
	var oval := mesh(tm, c, black)
	oval.rotation = Vector3(0, 0, PI / 2.0)   # the ring's axis along x, into the wall
	oval.scale = Vector3(0.6, 1.0, 1.0)       # narrow top to bottom, wide along the wall
	var tm2 := TorusMesh.new()
	tm2.inner_radius = 0.17
	tm2.outer_radius = 0.22
	tm2.rings = 20
	tm2.ring_segments = 6
	var iris := mesh(tm2, c + Vector3(-0.01, 0, 0), black)
	iris.rotation = Vector3(0, 0, PI / 2.0)
	var pupil := cyl(0.09, 0.09, 0.012, c + Vector3(-0.02, 0, 0), black, 14)
	pupil.rotation.z = PI / 2.0
	# the paint ran down the wall
	for i in 7:
		var z := -8.5 + rng.randf_range(-0.45, 0.45)
		var top := Vector3(6.925, 1.75 - absf(z + 8.5) * 0.4 - 0.1, z)
		stick(top, top - Vector3(0, rng.randf_range(0.15, 0.6), 0), rng.randf_range(0.004, 0.009), black)
	interactable("sigil", "Look at the wall above the bed", c + Vector3(-0.04, 0, 0), Vector3(0.12, 1.2, 1.4), "", false)


## The ceiling over the bed: a wet stain, the sticks in two rings inside
## an oval like Dufredy's, and in the pupil this time, two eyes, the
## nerves trailing into the plaster. Hidden until Carl wakes on her bed.
func _stain() -> void:
	stain_root = Node3D.new()
	add_child(stain_root)
	var wet := decal_mat(Tex.blood(79), Color(0.55, 0.3, 0.3), 0.15)
	var wet2 := decal_mat(Tex.blood(80), Color(0.45, 0.22, 0.25), 0.15)
	# the plaster bellied with it: a shallow dome hanging off the ceiling,
	# the stain across its underside
	var belly := sphere(0.5, STAIN_C + Vector3(0, 0.02, 0), mat(Color(0.32, 0.22, 0.22), 0.15), 18, stain_root)
	belly.scale = Vector3(2.4, 0.15, 1.8)
	var cy := STAIN_C.y - 0.06
	floor_quad(Vector2(2.6, 2.0), Vector3(STAIN_C.x, cy, STAIN_C.z), 0.3, wet, stain_root, false)
	floor_quad(Vector2(1.6, 1.4), Vector3(STAIN_C.x + 0.3, cy - 0.004, STAIN_C.z - 0.2), 1.9, wet2, stain_root, false)
	# the sticks, pushed into the soft plaster
	var stick_m := mat(Color(0.42, 0.33, 0.22), 0.9)
	var prev := Vector3.ZERO
	for ring in [[1.15, 0.72, 30], [0.62, 0.42, 18], [0.34, 0.24, 11]]:
		var n: int = ring[2]
		for i in n + 1:
			var a := i * TAU / n
			var p := Vector3(STAIN_C.x + cos(a) * ring[0], cy - 0.012 - rng.randf_range(0.0, 0.01), STAIN_C.z + sin(a) * ring[1])
			if i > 0:
				var mid := prev.lerp(p, 0.5)
				stick(prev + (prev - mid) * 0.2, p + (p - mid) * 0.2, rng.randf_range(0.008, 0.014), stick_m, stain_root)
			prev = p
	# the pupil: two eyes set into the stain, looking down at the bed
	var sclera := mat(Color(0.9, 0.86, 0.8), 0.25)
	var veined := mat(Color(0.86, 0.7, 0.64), 0.3)
	var iris_m := mat(Color(0.36, 0.3, 0.2), 0.3)
	var pupil := mat(Color(0.01, 0.01, 0.01), 0.1)
	var nerve := mat(Color(0.5, 0.1, 0.12), 0.35)
	var meat := mat(Color(0.35, 0.03, 0.03), 0.25)
	var r := 0.024
	for k in 2:
		var c := Vector3(STAIN_C.x - 0.07 + k * 0.14, cy - 0.012, STAIN_C.z)
		var look := Vector3(0.1 - k * 0.2, -1.0, 0.25).normalized()
		sphere(r, c, sclera if k == 0 else veined, 16, stain_root)
		_disk(c + look * (r - 0.0006), look, 0.008, 0.0014, iris_m, stain_root)
		_disk(c + look * (r - 0.0001), look, 0.0038, 0.0014, pupil, stain_root)
		# the nerve, out of the back of the eye and along the ceiling into the stain
		var p := c + Vector3(0, r * 0.7, 0)
		var dir := Vector3(-1.0 if k == 0 else 1.0, 0, 0.3).normalized()
		for s in 6:
			var q := p + dir.rotated(Vector3.UP, rng.randf_range(-0.7, 0.7)) * rng.randf_range(0.04, 0.08)
			q.y = cy - 0.006
			stick(p, q, 0.006 - s * 0.0006, nerve, stain_root)
			p = q
		sphere(0.009, p, meat, 8, stain_root)
	# drips, hanging, and one that fell: on the pillow, where her head went
	var drip := mat(Color(0.4, 0.08, 0.1), 0.1)
	for i in 5:
		var d := Vector3(STAIN_C.x + rng.randf_range(-0.5, 0.5), cy - 0.01, STAIN_C.z + rng.randf_range(-0.4, 0.4))
		stick(d, d - Vector3(0, rng.randf_range(0.03, 0.12), 0), 0.005, drip, stain_root)
		sphere(0.008, d - Vector3(0, rng.randf_range(0.03, 0.12), 0), drip, 6, stain_root)
	floor_quad(Vector2(0.12, 0.1), BED_C + Vector3(0.7, 0.682, 0.0), 0.5, decal_mat(Tex.blood(12), Color(1, 1, 1), 0.3), stain_root)
	ceiling_body = interactable("ceiling", "Look at the ceiling", STAIN_C - Vector3(0, 0.16, 0), Vector3(3.0, 0.16, 2.2),
		LINES["scan"]["ceiling"], false, stain_root)
	set_active(ceiling_body, false)
	_batch(stain_root, 10.0)
	stain_root.visible = false


## A thin disc on a surface with the given normal (iris, pupil).
func _disk(c: Vector3, normal: Vector3, r: float, h: float, m: Material, parent: Node) -> void:
	var cm := CylinderMesh.new()
	cm.top_radius = r
	cm.bottom_radius = r
	cm.height = h
	cm.radial_segments = 12
	cm.rings = 1
	var mi := MeshInstance3D.new()
	mi.mesh = cm
	mi.material_override = m
	var axis := Vector3.UP.cross(normal)
	var bs := Basis()
	if axis.length() > 0.0001:
		bs = Basis(axis.normalized(), Vector3.UP.angle_to(normal))
	mi.transform = Transform3D(bs, c)
	parent.add_child(mi)


# ------------------------------------------------------------------ outside: 79 floors of Silico

## The city below the window wall: a sea of lit blocks to the horizon,
## the near towers with their ad screens at our height, sky bridges,
## holograms hanging in the air, drones streaming up to the tower.
func _outside() -> void:
	var below := Node3D.new()
	add_child(below)
	kit_parent = below
	var ground := mat(Color(0.12, 0.1, 0.12), 1.0)
	floor_quad(Vector2(1400, 1400), Vector3(0, FLOOR_DROP, -300), 0.0, ground, below)
	# the near towers, tall enough to have faces at our level
	var near := [[-70.0, -80.0, 34.0, 320.0], [60.0, -75.0, 30.0, 280.0], [-20.0, -140.0, 40.0, 360.0],
		[110.0, -150.0, 36.0, 300.0], [-130.0, -40.0, 30.0, 290.0], [30.0, -220.0, 44.0, 420.0]]
	for t in near:
		cyber_block(Vector3(t[0], FLOOR_DROP, t[1]), 0.0, t[2], t[3], t[2], false, 0)
	# the rest, lower and denser
	for i in 90:
		var px := rng.randf_range(-380, 380)
		var pz := rng.randf_range(-700, -60)
		if absf(px) < 25.0 and pz > -120.0:
			continue
		var h := rng.randf_range(40, 140) * (1.8 if rng.randf() < 0.15 else 1.0)
		var w := rng.randf_range(16, 34)
		cyber_block(Vector3(px, FLOOR_DROP, pz), rng.randf_range(-0.3, 0.3), w, h, rng.randf_range(16, 34), false, 1)
	# sky bridges between the near towers, and the holograms at our height
	skybridge(Vector3(-53, -30, -80), Vector3(-40, -30, -140), 4.0)
	skybridge(Vector3(45, 12, -75), Vector3(0, 12, -140), 4.0)
	skybridge(Vector3(92, -70, -150), Vector3(52, -70, -220), 5.0)
	kit_holo(Vector3(-40, 6, -60), 0.25, "PSYON", "the pillow for those who dream", Color(0.4, 1.0, 0.6), 22.0)
	kit_holo(Vector3(40, -14, -55), -0.2, "SALTECH", "your body, optimized", Color(1.0, 0.3, 0.6), 18.0)
	kit_holo(Vector3(10, 22, -110), 0.0, "TOKZ", "sleep better. sleep together.", Color(0.2, 0.9, 1.0), 26.0)
	kit_holo(Vector3(-110, -40, -120), 0.6, "NIXTRA", "a new flavour: CALM", Color(0.62, 0.28, 1.0), 30.0)
	# the tower's own skin either side of the window: jade, and the lit seams
	var jade := mat(Color(0.16, 0.42, 0.34), 0.28, 0.75)
	box(Vector3(30, 600, 6), Vector3(-21.5, 0, -14.5), jade, false, below)
	box(Vector3(30, 600, 6), Vector3(22.5, 0, -14.5), jade, false, below)
	var seam := newglow(Color(0.3, 1.0, 0.7), 2.5)
	seam.disable_fog = true
	for x: float in [-9.0, 10.0]:
		box(Vector3(0.6, 600, 0.6), Vector3(x, 0, -11.6), seam, false, below)
	kit_parent = self
	_batch(below, 120.0, true)
	# hover lanes far below, and the drones
	var traffic = preload("res://scripts/Traffic.gd").new()
	traffic.lanes = [[-90.0, FLOOR_DROP + 40.0, 1.0], [-100.0, FLOOR_DROP + 60.0, -1.0], [-170.0, FLOOR_DROP + 90.0, 1.0],
		[-60.0, FLOOR_DROP + 150.0, -1.0], [-250.0, FLOOR_DROP + 120.0, 1.0]]
	traffic.along_x = true
	traffic.s_min = -380.0
	traffic.s_max = 380.0
	traffic.count = 12
	traffic.tower_top = Vector3(0, 120, -20)
	traffic.drone_box = AABB(Vector3(-350, FLOOR_DROP + 40, -600), Vector3(700, 220, 520))
	traffic.drone_count = 160
	add_child(traffic)
	traffic.setup(main, self)
	# a drone passing the window now and then
	var dr := box(Vector3(0.6, 0.25, 0.6), Vector3(-30, 1.0, -14), glow(Color(1.0, 0.85, 0.55), 4.0))
	dr.set_meta("drone", true)
	no_batch.append(dr)
	flickers.append(dr)


# ------------------------------------------------------------------ the chapter

func objective() -> String:
	var f: Dictionary = main.flags
	var o: Dictionary = LINES["objective"]
	if f.has("lynx_apartment_done"):
		return ""
	if f.has("reflection_done"):
		if not f.has("lynx_ceiling_seen"):
			return o["look_up"]
		return o["leave"]
	if f.has("lynx_entered"):
		return o["laptop"]
	return o["door"]


func intro() -> void:
	var ui = main.ui
	await get_tree().create_timer(0.8).timeout
	for line in LINES["intro"]:
		await ui.think(line)
	ui.close()
	if not main.frames_on:
		main.toggle_frames()
	main.update_hud()


func interact(node: Object) -> bool:
	var ui = main.ui
	var f: Dictionary = main.flags
	var id := str(node.get_meta("id"))
	var ex: Dictionary = LINES["examine"]
	var co: Dictionary = LINES["corridor"]
	if ex.has(id):
		for line in ex[id]:
			await ui.think(line)
		if id == "sigil" and not f.has("lynx_sigil_seen"):
			f["lynx_sigil_seen"] = true
			main.add_connection(1.0, "the sigil over the bed")
		return true
	match id:
		"door":
			await _enter()
		"lift_a", "lift_c":
			await ui.think(co["lift"])
		"stair":
			await ui.think(co["stair"])
		"ajar":
			await ui.think(co["ajar"])
		"unit_b", "unit_d", "unit_e", "unit_f", "unit_g":
			await ui.think(co["neighbour"])
		"notice":
			await ui.think(co["notice"])
		"vending":
			await ui.think(co["vending"])
		"camera":
			await ui.think(co["camera"])
		"hose":
			await ui.think(co["hose"])
		"notes":
			await ui.think(LINES["notes"]["grid"])
			await ui.say("", LINES["notes"]["quote"])
			if not f.has("lynx_notes_read"):
				f["lynx_notes_read"] = true
				main.add_connection(1.0, "read the notes")
			await ui.think(LINES["notes"]["thread"])
		"photos", "photos2":
			await _photos()
		"mirror":
			await ui.think(LINES["mirror"]["written"])
			await ui.say("", LINES["mirror"]["text"])
			await ui.think(LINES["mirror"]["who"])
		"laptop":
			await _laptop()
		"ceiling":
			await _ceiling_scene()
		"exit":
			await _try_leave()
		_:
			return false
	return true


## The door slides open before Carl touches it.
func _enter() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var L: Dictionary = LINES["door"]
	if _door_open:
		return
	_door_open = true
	f["cinematic"] = true
	main.play("ding", -14.0, 0.5)
	var tw := create_tween()
	tw.tween_property(door_panel, "position:x", 1.02, 1.4).set_trans(Tween.TRANS_SINE)
	set_active(door_body, false)
	main.player.shake(0.15)
	await ui.think(L["opens"])
	await ui.think(L["biometric"])
	await ui.think(L["no"])
	await ui.say("Carl", L["call"])
	ui.glitch(0.25, 0.5)
	await ui.think(L["smell"])
	await ui.think(L["lights"])
	await ui.think(L["nathan"])
	await ui.think(L["hope"])
	ui.close()
	f["lynx_entered"] = true
	f.erase("cinematic")
	main.update_hud()


func _photos() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var L: Dictionary = LINES["photos"]
	await ui.think(L["nathan"])
	if f.has("told_lynx_nathan"):
		await ui.think(L["told"])
	elif f.has("kept_nathan"):
		await ui.think(L["kept"])
	else:
		await ui.think(L["layout"])


# ------------------------------------------------------------------ the reflection ritual (ch. 8)

func _laptop() -> void:
	var ui = main.ui
	var p = main.player
	var f: Dictionary = main.flags
	var L: Dictionary = LINES["laptop"]
	if f.has("reflection_done"):
		await ui.think(L["again"])
		return
	f["cinematic"] = true
	# Psyon wakes as Carl comes to the side of the bed
	(laptop_screen.material_override as StandardMaterial3D).emission = Color(0.35, 0.75, 0.7)
	(laptop_screen.material_override as StandardMaterial3D).emission_energy_multiplier = 1.6
	laptop_light.light_energy = 1.3
	main.play("on", -8.0, 0.6)
	await ui.think(L["wakes"])
	ui.close()
	# sit on the side of the bed, the laptop on his lap
	p.seated = true
	var tw := create_tween().set_parallel(true)
	tw.tween_property(p, "position", BED_C + Vector3(0.1, 0.0, 1.05), 0.9)
	tw.tween_property(p, "crouch", 0.5, 0.9)
	await tw.finished
	await p.face(LAPTOP_P + Vector3(0, 0.12, 0), 0.6)
	ui.laptop_open(true)
	ui.smear.visible = false
	ui.laptop_log.append_text(L["boot"])
	await get_tree().create_timer(1.2).timeout
	main.play("ding", -4.0)
	await ui.laptop_line(L["welcome"])
	await ui.think(L["jaw"])
	await ui.think(L["lap"])
	ui.close()
	main.play("keys", -6.0)
	await ui.laptop_line(L["typed1"], true)
	await get_tree().create_timer(0.6).timeout
	await ui.laptop_line(L["fork1"])
	await ui.say("Carl", L["carl1"])
	ui.close()
	await ui.laptop_line(L["fork2"])
	await ui.say("Carl", L["carl2"])
	ui.close()
	await ui.laptop_line(L["fork3"])
	await ui.say("Carl", L["carl3"])
	ui.close()
	await ui.laptop_line(L["fork4"])
	await get_tree().create_timer(0.9).timeout
	ui.glitch(0.3, 0.5)
	await ui.laptop_line(L["fork5"])
	if f.has("told_lynx_nathan"):
		await ui.laptop_line(L["fork_told"])
	elif f.has("filed_nathan"):
		await ui.laptop_line(L["fork_filed"])
	await ui.say("Carl", L["carl4"])
	await ui.think(L["venom"])
	ui.close()
	await ui.laptop_line(L["fork6"])
	await ui.laptop_line(L["fork7"])
	await ui.think(L["cold"])
	# one reply
	var pick: int = await ui.choose(L["choices"])
	ui.close()
	main.play("keys", -6.0)
	if pick == 1:
		await ui.laptop_line(L["typed_no"], true)
		await get_tree().create_timer(0.5).timeout
		await ui.laptop_line(L["fork_no"])
		f["refused_fork"] = true
	else:
		await ui.laptop_line(L["typed_yes"], true)
		await get_tree().create_timer(0.5).timeout
		await ui.laptop_line(L["fork_yes"])
		main.add_connection(1.0, "agreed to play")
	await ui.laptop_line(L["fork8"])
	await ui.laptop_line(L["fork9"])
	await get_tree().create_timer(0.5).timeout
	await _ritual()


## The black square: the fork's picture, the eyes darting in a triangle,
## then the corners of the square, "Do you wish to see?", the download,
## Mira's voice.
func _ritual() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var L: Dictionary = LINES["ritual"]
	var pres: Node = main.loop("pressure", -10.0)
	pres.call("play")
	await ui.think(L["electric"])
	ui.close()
	ui.laptop_image(_soup_tex(), 4.0)
	await _dart([Vector2(-0.12, 0.08), Vector2(0.12, 0.08), Vector2(0.0, -0.12)], 3, 0.14)
	await get_tree().create_timer(1.6).timeout
	await ui.think(L["soup"])
	ui.close()
	for i in 4:
		ui.flash(0.08)
		await get_tree().create_timer(0.25).timeout
	ui.laptop_image(_square_tex(), 2.5)
	await _dart([Vector2(-0.14, 0.1), Vector2(0.14, 0.1), Vector2(0.14, -0.1), Vector2(-0.14, -0.1)], 4, 0.16)
	await ui.think(L["square"])
	await ui.think(L["ego"])
	ui.close()
	ui.glitch(0.5, 0.8)
	await ui.say("", L["question"])
	var see: int = await ui.choose(L["choices"])
	if see == 1:
		await ui.think(L["tried"])
		f["resisted_reflection"] = true
	await ui.say("Carl", L["wish"])
	await ui.think(L["unconscious"])
	ui.close()
	# the download to the frames
	main.play("static", -6.0)
	ui.laptop_log.append_text("[color=#c62828]" + L["download"])
	for i in 8:
		ui.laptop_log.append_text("█")
		main.play("tap", -16.0, 1.6 + i * 0.1)
		await get_tree().create_timer(0.22).timeout
	ui.laptop_log.append_text("  100%[/color]\n\n")
	await _dart([Vector2(-0.1, 0.0), Vector2(-0.07, 0.07), Vector2(0.0, 0.1), Vector2(0.07, 0.07), Vector2(0.1, 0.0), Vector2(0.07, -0.07), Vector2(0.0, -0.1), Vector2(-0.07, -0.07)], 1, 0.12)
	await ui.think(L["circle"])
	ui.close()
	main.play("whisper", -2.0, 1.25)
	await ui.say("Mira", L["mira"])
	await ui.think(L["vomit"])
	ui.close()
	ui.flash(0.4)
	main.play("off", -6.0)
	(laptop_screen.material_override as StandardMaterial3D).emission_energy_multiplier = 0.05
	laptop_light.light_energy = 0.0
	ui.laptop_open(false)
	await get_tree().create_timer(1.4).timeout
	main.play("on", -10.0)
	(laptop_screen.material_override as StandardMaterial3D).emission_energy_multiplier = 1.0
	laptop_light.light_energy = 0.8
	pres.queue_free()
	main.amb.erase("pressure")
	await ui.think(L["dark"])
	await ui.think(L["alone"])
	ui.close()
	f["reflection_done"] = true
	main.add_connection(6.0, "the reflection ritual")
	ui.show_toast(L["toast"], 4.0)
	await _sleep()


## Carl's eyes, out of his control: the camera snaps between offsets
## (yaw, pitch), `laps` times round them.
func _dart(points: Array, laps: int, hold: float) -> void:
	var p = main.player
	var yaw0: float = p.yaw
	var pitch0: float = p.pitch
	for l in laps:
		for pt in points:
			var o: Vector2 = pt
			var tw := create_tween().set_parallel(true)
			tw.tween_property(p, "yaw", yaw0 + o.x, 0.05)
			tw.tween_property(p, "pitch", pitch0 + o.y, 0.05)
			main.play("tap", -22.0, 2.0)
			await get_tree().create_timer(hold).timeout
	var back := create_tween().set_parallel(true)
	back.tween_property(p, "yaw", yaw0, 0.2)
	back.tween_property(p, "pitch", pitch0, 0.2)
	await back.finished


## The fork's picture: a disjointed soup of shapes with a black eye
## circling out of it.
func _soup_tex() -> ImageTexture:
	var r := RandomNumberGenerator.new()
	r.seed = 88
	var w := 320
	var h := 200
	var img := Image.create(w, h, false, Image.FORMAT_RGB8)
	img.fill(Color(0.08, 0.07, 0.09))
	for i in 40:
		var c := Color(r.randf_range(0.1, 0.8), r.randf_range(0.05, 0.5), r.randf_range(0.1, 0.7))
		if r.randf() < 0.3:
			c = Color(0.5, 0.06, 0.05)
		var cx := r.randf_range(0, w)
		var cy := r.randf_range(0, h)
		var sw := r.randf_range(8, 70)
		var sh := r.randf_range(4, 50)
		var ang := r.randf() * PI
		for y in range(maxi(0, int(cy - 40)), mini(h, int(cy + 40))):
			for x in range(maxi(0, int(cx - 40)), mini(w, int(cx + 40))):
				var p := Vector2(x - cx, y - cy).rotated(ang)
				if absf(p.x) < sw / 2.0 and absf(p.y) < sh / 2.0 and r.randf() < 0.85:
					img.set_pixel(x, y, c)
	var e := Vector2(w / 2.0, h / 2.0)
	for y in h:
		for x in w:
			var d := Vector2(x, y).distance_to(e)
			if d < 34.0 or (d > 50.0 and d < 58.0 and r.randf() < 0.8):
				img.set_pixel(x, y, Color(0.0, 0.0, 0.0))
	return ImageTexture.create_from_image(img)


func _square_tex() -> ImageTexture:
	var w := 320
	var h := 200
	var img := Image.create(w, h, false, Image.FORMAT_RGB8)
	img.fill(Color(0.05, 0.05, 0.06))
	for y in range(20, 180):
		for x in range(80, 240):
			img.set_pixel(x, y, Color(0.0, 0.0, 0.0))
	return ImageTexture.create_from_image(img)


## Ch. 9's first page: he collapses on her bed, dreams of the aspens, and
## wakes under the ceiling.
func _sleep() -> void:
	var ui = main.ui
	var p = main.player
	var f: Dictionary = main.flags
	var L: Dictionary = LINES["sleep"]
	await ui.think(L["collapse"])
	ui.close()
	await ui.fade_to(1.0, 1.6)
	# lying on the bed, head on the pillow, face up
	p.position = BED_C + Vector3(0.2, 0.0, 0.0)
	p.crouch = 0.92
	p.yaw = PI / 2.0
	p.pitch = 1.1
	p.rotation.y = p.yaw
	await ui.show_card(L["dream"], 6.0)
	# awake. The ceiling over the bed is not what it was.
	stain_root.visible = true
	set_active(ceiling_body, true)
	for pl in pulsers:
		if pl[0] == bed_light:
			pl[1] = 1.9
	main.play("sting", -12.0, 0.5)
	_woke_at = _t
	await ui.think(L["wake"])
	ui.close()
	f.erase("cinematic")
	main.update_hud()


## The ceiling. Carl has to look up at it himself; if he lies there long
## enough something lands on his cheek and he does.
func _ceiling_scene() -> void:
	var ui = main.ui
	var p = main.player
	var f: Dictionary = main.flags
	var L: Dictionary = LINES["ceiling"]
	if f.has("lynx_ceiling_seen"):
		await ui.think(L["again"])
		return
	f["cinematic"] = true
	f["lynx_ceiling_seen"] = true
	await p.face(STAIN_C, 1.0)
	main.play("sting", -4.0, 0.6)
	ui.glitch(0.3, 0.7)
	await ui.think(L["wet"])
	await ui.think(L["sticks"])
	await ui.think(L["eyes"])
	await ui.say("ORA", L["ora"])
	await ui.think(L["not_hers"])
	await ui.think(L["looked"])
	ui.close()
	main.add_connection(4.0, "the eyes over her bed")
	# up, off the bed
	p.seated = false
	var tw := create_tween().set_parallel(true)
	tw.tween_property(p, "crouch", 0.0, 0.8)
	tw.tween_property(p, "pitch", 0.2, 0.8)
	tw.tween_property(p, "position", BED_C + Vector3(0.1, 0.05, 1.3), 0.8)
	await tw.finished
	f.erase("cinematic")
	main.update_hud()


func _drip() -> void:
	var ui = main.ui
	main.play("tap", -2.0, 0.7)
	main.player.shake(0.2)
	await ui.think(LINES["ceiling"]["drip"])
	ui.close()
	await _ceiling_scene()


# ------------------------------------------------------------------ leaving

func _try_leave() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var L: Dictionary = LINES["leaving"]
	if _ended:
		return
	if not f.has("reflection_done"):
		await ui.think(L["laptop_first"] if f.has("lynx_entered") else L["not_yet"])
		return
	_ended = true
	f["cinematic"] = true
	await ui.think(L["coords"])
	ui.close()
	f["lynx_apartment_done"] = true
	var go: int = await ui.choose(L["choices"])
	if go == 1:
		main.play("ding", -10.0, 1.4)
		await ui.say("Carl", L["carl_call"])
		await ui.say("Monica", L["monica"])
		await ui.say("Carl", L["carl_home"])
		await ui.think(L["cost"])
		f["called_monica"] = true
	else:
		await ui.think(L["no_call"])
	ui.close()
	main.play("ding", -8.0)
	main.play("door", -8.0, 0.8)
	f.erase("cinematic")
	main.load_level("Flats")


# ------------------------------------------------------------------ the frame loop, the phone

func tick(delta: float) -> void:
	# the lights flicker, dim, pulse-like (the whole floor keeps the rhythm)
	var pulse := PULSE + 0.1 * sin(_t * 4.35) + (0.08 if randf() < 0.02 else 0.0) - (0.25 if randf() < 0.006 else 0.0)
	for pl in pulsers:
		var o: OmniLight3D = pl[0]
		o.light_energy = pl[1] * (pulse + 0.04 * sin(_t * 9.0 + pl[2]))
	if hub_ring:
		hub_ring.rotation.y = _t * 0.8
	if ajar_screen:
		ajar_screen.visible = fmod(_t, 3.0) > 0.25 or randf() < 0.5
	for n in no_batch:
		if n is MeshInstance3D and n.has_meta("drone"):
			var m := n as MeshInstance3D
			m.position.x += delta * 9.0
			m.position.y = 1.0 + sin(_t * 1.7) * 0.4
			if m.position.x > 30.0:
				m.position.x = -30.0
	if not main or not main.player or not main.started:
		return
	var f: Dictionary = main.flags
	if _woke_at >= 0.0 and not _dripped and not f.has("lynx_ceiling_seen") and not f.has("cinematic") and _t - _woke_at > 7.0:
		_dripped = true
		_drip()


func phone() -> String:
	var L: Dictionary = LINES["phone"]
	var t: String = L["morning"]
	if main.flags.has("reflection_done"):
		t += L["modified"] + L["path"]
	elif main.flags.has("lynx_entered"):
		t += L["visit"]
	return t


func on_glyph(_g: Object) -> void:
	main.play("whisper", -6.0)


func apply_args(a: Dictionary) -> void:
	var f: Dictionary = main.flags
	if a.has("open") or f.has("lynx_entered"):
		door_panel.position.x = 1.02
		set_active(door_body, false)
		_door_open = true
	if a.has("stain") or f.has("reflection_done"):
		stain_root.visible = true
		set_active(ceiling_body, true)
	if a.has("lit"):
		(laptop_screen.material_override as StandardMaterial3D).emission = Color(0.35, 0.75, 0.7)
		(laptop_screen.material_override as StandardMaterial3D).emission_energy_multiplier = 1.6
		laptop_light.light_energy = 1.3


func selftest() -> void:
	await intro()
	for id in ["stair", "ajar", "notice", "door", "notes", "frames", "photos", "drawers", "bath", "mirror", "sigil", "laptop"]:
		for n in main._all_with_meta(self, "id"):
			if is_instance_valid(n) and str(n.get_meta("id")) == id:
				await main.interact(n)
				print("ok ", id)
				break
	# the drip makes him look up on its own; wait for it
	await get_tree().create_timer(3.0).timeout
	while main.flags.has("cinematic") or not main.flags.has("lynx_ceiling_seen"):
		await get_tree().process_frame
	await main.selftest_all_interactables()
