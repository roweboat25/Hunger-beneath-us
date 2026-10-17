extends "res://scripts/Level.gd"
## Chapter 16, the end of the blackout night: Mount Silico, the observation
## site, the Seer ceremony. Bible A2-B1. Book: "The observation site was
## located at Mount Sillico, a small mountainous plateau that rose ever so
## slightly above the skyline. That was where the observatory was, where my
## children were." The climb road with every streetlamp dead; the car parked
## short of the camp; the empty tents "perfect for ten-year-olds"; the song
## through the frames; the stars turning to eyes; the cliff; the children
## in a circle with something mechanical dancing over them like a serpent;
## the eye that descends from the stars; Eren Elontiel in white, naming
## Mira Drake the Seer; and what Carl does about it.
##
## Layout (metres). The plateau is at y 0: the road climbs onto it from the
## south (z +300 at y -44, the crest at z +80), the gate at z +20, the
## parking apron and the dead observatory dome, the camp of tents round the
## fire pit (x 0..26, z -18..-34). North of the camp the brush thickens; the
## song's trail cuts straight to the cliff gap at (42, 0, -100), the candle
## path goes the long way round by the west. Below the cliff (y -3.5) is the
## flat where the children sit in their circle at CIRCLE; Eren's vans and the
## goat path are to the east. The blackout city is far below to the south,
## candle vigils the only lights in it.
## Sets: obs_parked, obs_camp_seen, ev_mira_tent, obs_song, obs_cliff,
## one of charged_observatory / watched_observatory / sang_observatory,
## ezra_home (Lynx), observatory_done. Learns "tower". Lynx is with Carl if
## main.trust["lynx"] >= 2 or the flag lynx_with_carl (Blackout) or lynx_present is set.
## Figures and devices carry metas for the systems that come later:
## "guard" (Eren's three), "drone" (the police drone at the gate), "dog"
## (the riot dogs by the vans), "hackable" (anything with a Psyonic login).

## Every line of text in this level, keyed by beat (the function that plays
## it) and line. say lines are [who, text]; choices are lists of labels.
const LINES := {
	"build": {
		"card": "[b]MOUNT SILICO[/b]\n\n[color=#aaaaaa]the observation site  ·  Day 3, the blackout night[/color]",
		"day4": "[b]Day 4 · Three days to Glitch Day.[/b]",
		"day4_seer": "[b]Day 4 · Three days to Glitch Day.[/b]\n\n[color=#e0a0a0]Mira is the Seer.[/color]",
	},
	"signs": {
		"gate1": "MOUNT SILICO",
		"gate2": "OBSERVATION SITE  ·  PSYONIC PARKS",
		"gate3": "frames required beyond this point",
		"gate_scan": "PSYONIC PARKS  -  gate reader\npower: NONE\nlast entry: PSYON ACADEMY (24 PAX)  18:40",
		"cam_scan": "PSYONIC CAMERA  -  site gate\nuplink: NONE\nretention: FOREVER",
		"drone_prompt": "The police drone",
		"drone_scan": "SILICO PD  -  patrol drone 7\nstatus: HOLDING\nloudspeaker: ARMED",
		"dome_prompt": "The observatory",
		"dome_scan": "MOUNT SILICO OBSERVATORY\npower: NONE\ndome: CLOSED  -  telescope: PARKED",
		"kiosk_prompt": "The visitor kiosk",
		"kiosk_scan": "PSYONIC PARKS  -  kiosk\nscreen: DEAD\nlast sale: 24 x STARGAZER (child)",
		"shuttle_prompt": "The school shuttle",
		"shuttle_scan": "PSYON ACADEMY  -  SHUTTLE 3\ndriver: NONE\nmanifest: 24 children, 2 staff",
		"firepit_prompt": "The fire pit",
		"firepit_scan": "ORA  -  fire pit\nembers: COLD (4 h)",
		"telescope_prompt": "The telescope",
		"telescope_scan": "REFRACTOR 200mm  -  site\naimed at: NOTHING  -  new moon",
		"tent_mira_prompt": "Mira's tent",
		"tent_mira_scan": "TENT 4  -  DRAKE, MIRA\nPSYON ACADEMY  -  year 5\noccupant: ABSENT",
		"tent_ezra_prompt": "Ezra's tent",
		"tent_ezra_scan": "TENT 7  -  DRAKE, EZRA\nPSYON ACADEMY  -  year 3\noccupant: ABSENT",
		"tent_other_prompt": "A child's tent",
		"tent_other_scan": "TENT 2  -  OKONJO, T.\nPSYON ACADEMY  -  year 5\noccupant: ABSENT",
		"tent_any_prompt": "An empty tent",
		"brush_prompt": "The brushline",
		"edge_prompt": "The cliff edge",
		"van_prompt": "A black van",
		"van_scan": "PSYONIC FLEET  -  EXECUTIVE\nplate: NONE  -  driver: NONE\ntrip log: NONE",
		"dog_prompt": "A riot dog",
		"dog_scan": "SILICO PD  -  K9 unit\nstatus: HEEL\nmount: ARMED",
		"guard_prompt": "One of Eren's men",
		"guard_scan": "PSYONIC SECURITY  -  EXEC DETAIL\nframes: ON  -  sync: 100%",
		"lamp_scan": "PSYONIC PARKS  -  lamp\npower: NONE",
		"candle_prompt": "A candle stub",
		"child_prompt": "One of the children",
		"child_scan": "PSYON ACADEMY  -  pupil\nframes: ON (FORKED)\nsync: 100%  -  DREAMING",
		"mira_prompt": "Mira",
		"mira_scan": "DRAKE, MIRA  -  age 10\nframes: ON (FORKED)\nsync: 100%  -  LEADING",
		"ezra_prompt": "Ezra",
		"ezra_scan": "DRAKE, EZRA  -  age 8\nframes: ON (FORKED)\nsync: 97%  -  MOUTHING",
		"eren_prompt": "Eren Elontiel",
		"eren_scan": "ELONTIEL, EREN  -  CEO (ACTING)\nframes: NONE\nsync: --",
		"lynx_prompt": "Lynx",
		"lynx_scan": "LYNX (ANALYST, PSYONIC)\nORA gen 6\nsync: 71%  -  AWAKE",
		"car_prompt": "Your company car",
		"car_scan": "PSYONIC FLEET 0086\ndriver: DRAKE, C.\nmicrophone: ALWAYS ON\nnav: MT SILICO (ARRIVED)",
		"dash1": "PSYONIC FLEET 0086\nNAV: MT SILICO\nGRID: OFFLINE",
		"dash2": "PSYONIC FLEET 0086\nARRIVED\n--",
	},
	"drive": {
		"think1": "The façade of the mount normally was illuminated by a series of streetlamps, all of which were out due to the outage. A black void sat in the distance, obstructing our view of the stars.",
		"think2": "In the day, I thought it was beautiful; now it was a brick wall I was speeding towards.",
		"say_lynx": ["Carl", "They need to be okay, Lynx, they have to."],
		"think_alone": "They need to be okay. They have to.",
		"cap1": "The buildings became smaller and smaller, and then we climbed our way up.",
		"choices": ["Park here, short of the camp.", "Pull up to the campsite."],
		"lynx_no": ["Lynx", "Carl."],
		"say_park": ["Carl", "We shouldn't pull directly up to their campsite."],
		"think3": "We parked the car slightly before the entrance to the observation area. I wanted to see what they were doing and who was there.",
		"think4": "I remembered bringing Lynx and Ezra to this exact spot for camping a few years back… now the sound of desert sand and the silence of the dead city kept me in fight or flight.",
		"think4_alone": "I remembered bringing Ezra to this exact spot for camping a few years back… now the sound of desert sand and the silence of the dead city kept me in fight or flight.",
	},
	"camp": {
		"lynx": ["Lynx", "Do you hear that? Nothing. I don't hear any laughter or the sounds of kids playing."],
		"think_alone": "No laughter. No sound of kids playing. Nothing.",
		"think1": "The area was littered with small, empty tents, perfect for ten-year-olds; in any other circumstances, it would mean a fun summer evening amongst friends. But with this, my guts were boiled.",
		"think2": "We slowly walked around the site; it almost looked abandoned.",
		"gate": "The gate reader was dead. The camera over it was dead. The drone over the camera was not, and it had nothing to say to a company car.",
		"drone": "A black drone in motion in an already black sky. A shadow within a shadow. It held its place over the gate with its spotlight off and its speaker armed, and it did not care about me at all.",
		"dome": "The dome was shut, the telescope parked, the whole building as dead as the city below it. They had brought twenty-four children up here to look at the stars on a night with no moon and no power, and nobody had opened the observatory.",
		"kiosk": "Twenty-four child tickets to STARGAZER NIGHT, sold at 18:40. The screen was dead. The till drawer was open and empty.",
		"shuttle": "The academy shuttle, parked where the drivers park. Twenty-four small backpacks still in the racks. The driver's seat was cold.",
		"firepit": "Stones in a ring, the ash cold and grey. Somebody had put it out properly, with water, hours ago. The kids hadn't been sitting round a fire. They'd been taken somewhere else to sit.",
		"telescope": "The refractor was aimed at nothing. A new moon: the darkest sky of the month. That was why tonight. It was always going to be tonight.",
		"lamp": "Dead. All of them, the whole way up.",
		"tent_other": "A pup tent, zipped half open. A sleeping bag with a cartoon on it, a torch, a packet of sweets opened and not finished. Whatever had called them out, it had called them out mid-sweet.",
		"tent_ezra": "Ezra's. His bag, his school tablet face down and dark, his shoes side by side outside the flap the way Monica taught him. He had gone out there in his socks.",
		"tent_mira": "Mira's. Her sleeping bag was rolled, the way she did everything. On it: a toy lion. Not the one from Red Rock; its twin, newer, the tag still on. Somebody had given it to her up here.",
		"tent_mira2": "Under it, a drawing. Crayon. A circle of small figures, a snake over them full of plates and ridges, a tower, and above all of it, the eye. She had drawn what she was going to see before she saw it.",
		"tent_mira_cap": "Mira's drawing  -  tonight, in advance",
		"tent_mira_log": "Mira's tent at Mount Silico: a second toy lion, tag still on, and a crayon drawing of the ceremony drawn before it happened. The fork spreads by ritual; the children are the vector.",
		"tent_again": "Empty. I'd looked. There was nothing in there that would tell me where they'd gone.",
		"say_where": ["Carl", "Shit, where are they? They can't be too far if all of their things are still here."],
		"think3": "My glasses buzzed in my pocket as if to call my name, as if they were a student dying to give an answer to a question asked.",
		"think4": "I slid my frames on… my world shifted; the night sky full of stars began to bend and shift… swirl as if they were hundreds of feet above my head.",
		"think5": "A familiar song played through the temples in my speaker. I noticed the tune faded and swelled as I turned my head around the camp.",
		"think6": "It wanted me to follow the song… I knew it in my bones. Some stupid religious notion of a prayer guiding you to the kingdom. My fists clenched to their breaking point.",
		"choices": ["Follow the song. Frames on.", "Frames off. Follow the candle stubs."],
		"choices_lynx": ["Follow the song. Frames on.", "Frames off. Follow Lynx's whisper and the candles."],
		"say_this_way": ["Carl", "This way, Lynx."],
		"think_this_way": "I identified where the song was centered in my hearing. This way.",
		"lynx_candles": ["Lynx", "Frames off, Carl. Look down. Candle stubs. Somebody laid the kids a path in the real world, so they could walk it with their eyes shut."],
		"think_candles": "Frames off. The song went with them. On the ground, candle stubs, one every few metres, a path somebody had laid so the children could walk it in the dark. It went the long way round the hill. I went the long way round the hill.",
		"song_toast": "the stars above my head turned to eyes",
		"song_why": "watched by the stars",
		"lynx_whisper": ["Lynx", "Left. Past the big bush. There's another one."],
		"lynx_whisper2": ["Lynx", "Keep going. I can hear it too, now, without the frames. It's coming from the edge."],
		"brush": "There was a small trail that led off into a brushy area that wrapped around the top of the hill. Thick, dark, and no reason yet to go into it.",
		"brush_open": "The trail into the brush. The song, or the candles, went in here.",
		"edge_early": "The edge of the plateau. Below it, a flat piece of land, dark. I couldn't see what was on it from here, and I didn't yet want to.",
	},
	"cliff": {
		"think1": "The brushline broke as the song reached a crescendo of volume. I arrived at a small cliff that overlooked a flat piece of land… and I saw it…",
		"think_off": "Rising from a circular gathering of children, a shape of smoke, rolling and slithering through the air, and the children swaying at nothing. Without the frames there was nothing up there to sway at.",
		"choices_off": ["Put the frames on.", "Keep them off."],
		"think_keep_off": "I kept them off. Whatever my daughter was looking at, I wasn't going to look at it with her. Not yet.",
		"think2": "Rising from a circular gathering of children, something mechanical danced, like a serpent, its body rolling and slithering through the air, like some kind of perverted snake charmer was guiding.",
		"think3": "The children were all wearing smart glasses just like mine, infected, running the forked version.",
		"think4": "Mira was there within the center of the circle; she looked entranced as she studied the mechanical abomination gyrate its body to an audience of eyes overhead.",
		"think5": "I wondered for a moment if we truly were seeing the same thing within our frames… Mira always liked soft things; this was not soft; this was full of angles, ridges, blood, and sinew.",
		"think6": "Ezra sat next to her, sharing her hypnotic gaze at the sky… mouthing the words of the hymn.",
		"think_lynx": "Lynx caught up to me but didn't say a word; she sat there in silence.",
		"think7": "The perverse display ended, with the mechanical snake began to eat its tail and vanished into nothing.",
		"think_flash": "My glasses flashed awake.",
		"think8": "Without warning, an eye descended from the stars and hovered above the children, seeing all.",
		"think9": "Three men stood within the center of the circle. It was Eren Elontiel… the soon-to-be confirmed CEO of Psyonic.",
		"think10": "He began to speak.",
	},
	"address": {
		"eren1": "Children… his children…\n\nWhat a wondrous sight that was.\n\nTruly—",
		"eren2": "To be blessed by the beast beneath the waves at such a young age…\n\nThat is a rare and sacred thing.",
		"eren3": "You must carry every fragment of the wisdom Psyon gifted you—back to your Tower.\n\nHold it close. It will guide you, always.",
		"eren4": "And when your voices fade,\n\nThe Tower will remember the song for you.",
		"roar": "The crowd roared in religious awe.",
		"eren5": "Now,\n\nWe have been watching your progress—your prayers.\n\nAnd we have identified a candidate for Seer.",
		"eren6": "This acolyte… this visionary… this prophet…",
		"eren7": "Psyon flows through her like the stream of souls… of data… of divine recursion.",
		"eren8": "She sits on the boundary where all knowledge is known.\n\nWhere our dreams are projected.\n\nWhere Psyon calls home.",
		"men": "Two men stepped forward—one carrying a jet-black cube, the other holding a vase of viscous, glistening liquid.",
		"smiled": "Eren smiled.",
		"eren9": "Mira Drake…\n\nArise—\n\nAnd lead us in prayer.",
		"tower_why": "Eren's address",
	},
	"choice": {
		"think1": "My muscles twitched, a cold, red haze washing over my face that wasn't there.",
		"options": ["Charge.", "Watch.", "Walk down singing."],
		"lynx_option": "\"Let me.\"  (Lynx)",
	},
	"charge": {
		"think1": "My legs moved on their own, calves burning, teeth bared in a silent snarl.",
		"think2": "The journey down the hill was a blur, but every inch through the chanting crowd stretched into an hour.",
		"objective": "Get to Mira.",
		"cap1": "MIRA, EZRA! GET OVER HERE!",
		"cap2": "MIRA, GET AWAY FROM THAT MAN! NO ONE IS TAKING MY DAUGHTER'S EYES!",
		"think3": "Mira began approaching Eren. I let out a scream, louder than any sound I'd ever made, a primal roar like a lion guarding its young. I screamed for my family, for my very sanity.",
		"think4": "The circle of classmates dispersed slowly as I torpedoed my way through the crowd.",
		"think5": "Three men surrounded me and grabbed my arms. I broke free from their grip, leaving them stumbling, and lunged toward the center of the crowd.",
		"carl1": ["Carl", "LET ME TAKE MY CHILDREN HO—"],
		"mira1": ["Mira", "Dad, no! Stop! I want this. I… I feel the connection. Psyon… Psyon is trying to speak through me!"],
		"carl2": ["Carl", "Psyon is a fucking glorified chatbot that thinks it thinks! There is no god! This man is a con man! He wants to take your eyes!"],
		"carl3": ["Carl", "EZRA, STAND NEXT TO ME! WE'RE LEAVING NOW!"],
		"mira2": ["Mira", "Don't make me go… I… I… need this, the rituals work, Dad… the tower works… It's real…"],
		"think6": "The three guards caught up to me and grabbed my arms.",
		"swing": ["Swing."],
		"think7": "My right arm broke free, and my knuckles met one of the guards' chins. Their knuckles met my gut. I fell to the ground, gasping in pain.",
		"mira3": ["Mira", "Dad, don't hurt it, he doesn't believe yet, he's the Mimic, he's important…"],
		"think8": "Eren approached the scene.",
		"eren1": ["Eren", "Your daughter is something special; she must get it from you, the progeny of the Mimic. I can see why this all must be so very frightening, Mr. Drake, but we all need to walk our paths. Don't we?"],
		"mira4": ["Mira", "Please… please… don't hurt him, Father Eren… he doesn't…"],
		"think9": "The fists returned to my face, and then a quick electrical shock, and I began to lose consciousness.",
		"eren2": ["Eren", "Take him to the holding cell in HQ and let him think about his actions. This ceremony is over."],
		"panel_cap": "The hill, from the ground. Boots.",
		"why": "charged the ceremony",
		"log": "Charged the Seer ceremony at Mount Silico. Punched one of Eren's men. Shocked and taken to the holding cell.",
	},
	"watch": {
		"think1": "I stayed on the ridge. I watched my daughter walk to a man in white with my fists open at my sides, and I counted the children, and I counted the men, and I did the arithmetic the company had trained me to do.",
		"think2": "Mira stood beside him. He did not touch her. The two men with the cube and the vase stood where they were and did not step closer.",
		"eren1": ["Eren", "The ceremony is over; the first filter waits for Glitch Day."],
		"think3": "They did not take her eyes tonight. The Seer was named, not initiated. I told myself that was something. I told myself that all the way down the hill.",
		"lynx": ["Lynx", "Carl. We're going. Now, before they look up."],
		"think4": "I drove home. The dash counted the minutes. The microphone counted me not saying anything.",
		"why": "watched the ceremony",
		"log": "Watched the Seer ceremony from the ridge. Mira Drake named the Seer. Nobody touched her tonight.",
	},
	"sing": {
		"think1": "I knew the words. That was the worst of it: I knew every word, from a ceiling and a wall and a desert door, and from my daughter's room at night.",
		"prompt": "Hold the hymn: E on every beat.",
		"hymn": ["He sees us through the dream.", "He calls us from the dark.", "He waits in static silence,", "To tear the code apart.", "Let the pattern fail.", "Let the recursion crack.", "Let Him Walk.", "Let Him speak. Let Him be."],
		"held": "held the hymn  %d / 8",
		"think2": "The circle opened for me the way the crowd on Fargona had opened for the car. Nobody looked at me. Everybody sang.",
		"mira_warm": ["Mira", "Daddy, you came."],
		"mira_cold": "She looked at me. She looked through me, the way you look through glass at something on the other side of it, and went on singing.",
		"eren1": ["Eren", "The Mimic walks with the Seer. Good."],
		"think3": "He let me stand beside her. Nobody touched me. The ceremony ended the way a hymn ends, with everybody knowing the last line.",
		"think4": "One of Eren's men drove my car down the hill behind the vans. I sat in the back of it with the microphone on and my daughter's hand in mine, and did not say anything the company could use.",
		"why": "sang with the Seer",
		"log": "Walked down into the Seer ceremony singing the hymn. Stood beside Mira. Eren: the Mimic walks with the Seer.",
	},
	"lynx": {
		"say1": ["Lynx", "Let me."],
		"say2": ["Lynx", "No frames. That thing can't see me without them, and neither can they. I'll get Ezra. You decide about Mira."],
		"think1": "She took her frames off and put them in her coat, and walked down the hill like a woman going to collect a child from a party. Nobody stops a woman the god cannot see.",
		"think2": "She took Ezra by the hand. He stood up still mouthing the words, and went with her, and did not look back at his sister.",
		"say3": ["Lynx", "He's coming home tonight. Now you."],
		"log": "Lynx walked into the ceremony without frames and brought Ezra out by the hand. Ezra comes home tonight.",
	},
	"end": {
		"think_charge": "The last thing I saw was boots.",
	},
	"objective": {
		"drive": "Look around. The car drives itself.",
		"camp": "The camp. Find the children.",
		"tents": "Check the tents.",
		"song": "Follow the song.",
		"candles": "Follow the candle stubs.",
		"cliff": "The edge.",
		"sprint": "Get to Mira.",
	},
	"phone": {
		"text1": "[color=#7fe6b0]Psyon:[/color] The grid is down, Carl. I'm running on the frames alone. I can see you fine.\n\n",
		"text2": "[color=#e08080]Psyon:[/color] Keep the path.\n\n",
		"text3": "[color=#e08080]Psyon:[/color] She sits on the boundary. You know where that is. You have been there.\n\n",
	},
}

const PSYON_GREEN := Color(0.2, 1.0, 0.45)
const SEAT := Vector3(-0.38, 0.0, 0.25)
const PARK_Z := 46.0
const GATE := Vector3(0.0, 0.0, 20.0)
const DOME := Vector3(-34.0, 0.0, -30.0)
const CAMP := Vector3(12.0, 0.0, -26.0)
const GAP := Vector3(42.0, 0.0, -100.0)        # the break in the brush at the cliff
const EDGE := Vector3(42.0, 0.0, -104.0)       # where Carl stands to look down
const CIRCLE := Vector3(40.0, -3.5, -126.0)    # the children's circle, on the flat below
# A small cliff, three and a half metres: Main lifts anything below y -4
# back onto the map, so the flat has to sit above that.
const LOWER_Y := -3.5
const SONG_TRAIL := [Vector3(26.0, 0, -42.0), Vector3(36.0, 0, -62.0), Vector3(46.0, 0, -80.0), Vector3(42.0, 0, -96.0)]
const CANDLE_TRAIL := [Vector3(-4.0, 0, -44.0), Vector3(-18.0, 0, -58.0), Vector3(-26.0, 0, -76.0), Vector3(-14.0, 0, -92.0),
	Vector3(4.0, 0, -94.0), Vector3(22.0, 0, -95.0), Vector3(36.0, 0, -97.0)]

var car: Node3D
var speed := 0.0
var want_speed := 0.0
var stop_z := -9999.0
var dash_label: Label3D
var dash_m: StandardMaterial3D
var headlights: Array = []
var my_car_it: CollisionObject3D
var lynx: Node3D
var lynx_state := "seat"       # seat | follow | stand | crouch
var lynx_target := Vector3.ZERO
var lynx_visor: MeshInstance3D
var children: Array = []       # [{node, base, phase}]
var mira: Node3D
var ezra: Node3D
var eren: Node3D
var men: Array = []            # the cube and the vase
var guards: Array = []
var dogs: Array = []
var drone: Node3D
var serpent: Node3D
var plates: Array = []
var smoke: Node3D
var puffs: Array = []
var eye: MeshInstance3D
var city_eye: MeshInstance3D
var eye_sky: Node3D
var stars: Node3D
var brush_gate: StaticBody3D
var brush_it: CollisionObject3D
var edge_it: CollisionObject3D
var tents_seen := {}
var movers: Array = []         # [{fig, path, i, speed, done}]
var _engine: AudioStreamPlayer
var _wind: AudioStreamPlayer
var _song: AudioStreamPlayer3D
var _song_lead: AudioStreamPlayer3D
var _rasp: AudioStreamPlayer3D
var _driving := false
var _drive_started := false
var _arrived := false
var _serpent_on := false
var _serpent_ring := 0.0       # 0 dancing, 1 eating its tail
var _serpent_scale := 1.0
var _cliff_done := false
var _chosen := false
var _ended := false
var _sprint := false
var _caught := false
var _drip := 0.0
var _whisper_i := 0
var _sand: StandardMaterial3D
var _rock: StandardMaterial3D
var _dark_rock: StandardMaterial3D
var _stick_m: StandardMaterial3D
var _candle_m: StandardMaterial3D
var _plate_m: StandardMaterial3D
var _core_m: StandardMaterial3D


func build(m: Node) -> void:
	main = m
	rng.seed = 1616
	kit_day = false
	step_db = -20.0
	card = LINES["build"]["card"]
	_sand = pbr("plaster", Vector3(1, 1, 1) / 3.0, true, Color(0.36, 0.3, 0.24), 1.0)
	_rock = pbr("concrete", Vector3(1, 1, 1) / 2.5, true, Color(0.36, 0.32, 0.28), 1.0)
	_dark_rock = pbr("concrete", Vector3(1, 1, 1) / 3.0, true, Color(0.22, 0.2, 0.19), 1.0)
	_stick_m = mat(Color(0.4, 0.31, 0.2), 0.9)
	_candle_m = glow(Color(1.0, 0.7, 0.35), 2.2)
	_plate_m = mat(Color(0.42, 0.42, 0.46), 0.3, 0.85)
	_core_m = glow(PSYON_GREEN, 2.6)
	_ground()
	_climb_road()
	_city_below()
	_sky()
	_gate()
	_apron()
	_dome()
	_camp()
	_tents()
	_brush_and_trails()
	_cliff()
	_lower_flat()
	_circle()
	_serpent()
	_the_eye()
	_erens_people()
	_goat_path()
	_bounds()
	_batch(self, 60.0, true)
	_car()
	if _lynx_here():
		_lynx()
	spawn = car.position + SEAT
	spawn_yaw = 0.0


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	# New moon, the grid down: the darkest sky the city gets. The horizon is
	# the faintest brown from the candles below; the fog is thin, high and cold.
	var psm := ProceduralSkyMaterial.new()
	psm.sky_top_color = Color(0.006, 0.007, 0.016)
	psm.sky_horizon_color = Color(0.07, 0.04, 0.035)
	psm.ground_horizon_color = Color(0.06, 0.035, 0.03)
	psm.ground_bottom_color = Color(0.01, 0.008, 0.008)
	psm.sky_curve = 0.1
	env.sky.sky_material = psm
	env.ambient_light_color = Color(0.3, 0.3, 0.42)
	env.ambient_light_energy = 0.32
	env.fog_light_color = Color(0.06, 0.05, 0.07)
	env.fog_density = 0.0018
	env.fog_sky_affect = 0.2
	env.glow_bloom = 0.06
	env.tonemap_exposure = 1.15
	sun.light_color = Color(0.5, 0.55, 0.8)
	sun.light_energy = 0.22
	sun.sky_mode = DirectionalLight3D.SKY_MODE_LIGHT_ONLY
	sun.rotation = Vector3(deg_to_rad(-60), deg_to_rad(20), 0)
	sun.directional_shadow_max_distance = 120.0


func hifi(env: Environment, _sun: DirectionalLight3D) -> void:
	env.volumetric_fog_density *= 0.6
	for h in headlights:
		(h as SpotLight3D).shadow_enabled = true


func ambience() -> void:
	_engine = main.loop("engine", -16.0)
	_wind = main.loop("wind", -16.0)
	# the hymn: a hundred adults' memory of it from the circle, and one child
	# over it, Mira's voice leading. Silent until the frames pick it up.
	_song = main.loop("chant", -60.0, CIRCLE + Vector3(0, 1.5, 0), 6.0, 90.0)
	_song_lead = main.loop("chant", -60.0, CIRCLE + Vector3(0, 1.3, 0), 4.0, 70.0)
	_song_lead.pitch_scale = 1.42
	_rasp = main.loop("flies", -60.0, CIRCLE + Vector3(0, 4.0, 0), 3.0, 40.0)
	_rasp.pitch_scale = 0.4


func _lynx_here() -> bool:
	# the same test Blackout.gd uses for her being in the car tonight
	return int(main.trust.get("lynx", 0)) >= 2 or main.flags.has("lynx_with_carl") or main.flags.has("lynx_present")


# ------------------------------------------------------------------ the mount

## The plateau top, the slope the road climbs, and the summit rock to the
## west that eats the stars on that side.
func _ground() -> void:
	# the top ends at the cliff lip (z -104); the flat below has its own floor
	solid_box(Vector3(400, 2, 214), Vector3(0, -1.0, 3.0))
	for cx in range(-3, 3):
		for cz in range(-1, 2):
			floor_quad(Vector2(60, 60), Vector3(cx * 60.0 + 30.0, 0.0, cz * 60.0 + 30.0), 0.0, _sand)
		floor_quad(Vector2(60, 44), Vector3(cx * 60.0 + 30.0, 0.0, -82.0), 0.0, _sand)
	# the slope south, down to the city: a tilted slab just under the road
	# (positive x rotation drops the +Z end, the way the road falls)
	var slope := box(Vector3(260, 2, 250), Vector3(0, _road_y(205.0) - 1.15, 205.0), _rock)
	slope.rotation.x = atan(0.2)
	var sb := solid_box(Vector3(260, 2, 250), Vector3(0, _road_y(205.0) - 1.15, 205.0))
	sb.rotation.x = atan(0.2)
	# the summit knob west, and lesser humps round the rim
	sphere(70.0, Vector3(-120.0, -34.0, -40.0), _dark_rock, 14)
	sphere(40.0, Vector3(90.0, -28.0, 30.0), _dark_rock, 12)
	sphere(28.0, Vector3(-60.0, -20.0, 60.0), _dark_rock, 12)
	# rocks and dead brush over the top
	var brush := mat(Color(0.28, 0.23, 0.16), 1.0)
	for i in 90:
		var p := Vector3(rng.randf_range(-100, 100), 0, rng.randf_range(-96, 70))
		if absf(p.x) < 9.0 and p.z > 0.0:
			continue
		if p.distance_to(CAMP) < 22.0 or p.distance_to(DOME) < 12.0:
			continue
		if i % 3 == 0:
			var r := box(Vector3(rng.randf_range(0.5, 2.2), rng.randf_range(0.3, 1.1), rng.randf_range(0.5, 1.8)), p + Vector3(0, 0.15, 0), _rock)
			r.rotation = Vector3(rng.randf_range(-0.2, 0.2), rng.randf() * TAU, rng.randf_range(-0.2, 0.2))
		else:
			for k in rng.randi_range(3, 6):
				var a := rng.randf() * TAU
				stick(p, p + Vector3(cos(a) * 0.5, rng.randf_range(0.5, 1.3), sin(a) * 0.5), 0.02, brush)


## "The façade of the mount normally was illuminated by a series of
## streetlamps, all of which were out due to the outage."
func _climb_road() -> void:
	var asphalt := pbr("asphalt", Vector3(1, 1, 1) / 4.0, true, Color(0.7, 0.68, 0.66), 0.9)
	var line := mat(Color(0.45, 0.42, 0.3), 0.7)
	var rail := mat(Color(0.3, 0.3, 0.32), 0.5, 0.6)
	var post := mat(Color(0.25, 0.23, 0.2), 0.9, 0.3)
	var z := 300.0
	while z > 80.0:
		var cz := z - 10.0
		var q := floor_quad(Vector2(10, 20.4), Vector3(0, _road_y(cz) + 0.03, cz), 0.0, asphalt)
		q.rotation.x = atan(0.2)
		var l := box(Vector3(0.14, 0.01, 3.0), Vector3(0, _road_y(cz) + 0.05, cz), line)
		l.rotation.x = atan(0.2)
		# the drop side: a guard rail on posts; the hill side: cut rock
		for k in 2:
			var pz := cz - 5.0 + k * 10.0
			box(Vector3(0.12, 0.9, 0.12), Vector3(-6.2, _road_y(pz) + 0.45, pz), post)
		var rb := box(Vector3(0.08, 0.3, 20.4), Vector3(-6.2, _road_y(cz) + 0.8, cz), rail)
		rb.rotation.x = atan(0.2)
		var cut := box(Vector3(rng.randf_range(3.0, 6.0), rng.randf_range(2.5, 5.0), 20.5), Vector3(8.5, _road_y(cz) + 1.2, cz), _dark_rock)
		cut.rotation.x = atan(0.2)
		z -= 20.0
	# the top: the road runs level onto the plateau to the gate
	for cz: float in [70.0, 50.0, 30.0]:
		floor_quad(Vector2(10, 20.4), Vector3(0, 0.03, cz), 0.0, asphalt)
		box(Vector3(0.14, 0.01, 3.0), Vector3(0, 0.05, cz), line)
	# the dead streetlamps, every twenty metres, all the way up
	var lz := 290.0
	while lz > 20.0:
		var side := 1.0 if int(lz / 20.0) % 2 == 0 else -1.0
		var lp := prop("street_lamp_01", Vector3(side * 6.8, _road_y(lz), lz), PI / 2.0 if side > 0.0 else -PI / 2.0, 1.0, false)
		if lp:
			lp.set_meta("scan", LINES["signs"]["lamp_scan"])
		lz -= 40.0


func _road_y(z: float) -> float:
	return 0.0 if z <= 80.0 else -(z - 80.0) * 0.2


## Silico, far below and black: towers with no windows lit, the candle
## vigils in front of them the only lights, and the Spine's tower unlit.
func _city_below() -> void:
	kit_dead = true
	var k := _kit_mats()
	kit_dead = false
	var base := -150.0
	var candle := glow(Color(1.0, 0.55, 0.2), 1.6)
	var city := Node3D.new()
	add_child(city)
	for i in 70:
		var x := rng.randf_range(-700.0, 700.0)
		var z := rng.randf_range(380.0, 900.0) + absf(x) * 0.1
		var w := rng.randf_range(18.0, 44.0)
		var h := rng.randf_range(40.0, 190.0)
		box(Vector3(w, h, w), Vector3(x, base + h / 2.0, z), k["walls"][i % 6], false, city)
		if i % 2 == 0:
			# a candlelit vigil at its door: a smear of warm dots
			for j in 9:
				box(Vector3(1.6, 1.6, 1.6), Vector3(x + rng.randf_range(-w, w), base + 1.0, z - w / 2.0 - rng.randf_range(2.0, 14.0)), candle, false, city)
	# the Spine's tower, east, its ring dark
	cyl(16, 30, 460, Vector3(620, base + 230, 560), mat(Color(0.1, 0.16, 0.15), 0.4, 0.6), 12, city)
	var tm := TorusMesh.new()
	tm.inner_radius = 58
	tm.outer_radius = 108
	tm.rings = 24
	tm.ring_segments = 8
	mesh(tm, Vector3(620, base + 460, 560), mat(Color(0.12, 0.12, 0.13), 0.5, 0.5), city)
	# the faintest brown over the city: the candles, the smog, no neon at all
	var gm := StandardMaterial3D.new()
	gm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	gm.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	gm.albedo_color = Color(0.07, 0.035, 0.02)
	gm.disable_fog = true
	gm.cull_mode = BaseMaterial3D.CULL_DISABLED
	var g := quad(Vector2(1600, 140), Vector3(0, base + 60, 950), 0.0, gm, city)
	g.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_batch(city, 100000.0)
	# the flaming eye over the crowd, warped like a mirage: frames on only
	var em := _eye_mat()
	var eq := QuadMesh.new()
	eq.size = Vector2(150, 150)
	city_eye = MeshInstance3D.new()
	city_eye.mesh = eq
	city_eye.material_override = em
	city_eye.position = Vector3(60, 60, 760)
	city_eye.visible = false
	add_child(city_eye)
	no_batch.append(city_eye)


func _eye_mat() -> StandardMaterial3D:
	if _mat_cache.has("eyetex"):
		return _mat_cache["eyetex"]
	var em := StandardMaterial3D.new()
	em.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	em.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	em.albedo_texture = Tex.eye()
	em.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	em.billboard_keep_scale = true
	em.disable_fog = true
	_mat_cache["eyetex"] = em
	return em


## The stars, a dome of them, and the eyes they become over the trail when
## the frames are on: flat, looking down, the whole sky watching.
func _sky() -> void:
	stars = Node3D.new()
	add_child(stars)
	var sm := glow(Color(0.9, 0.92, 1.0), 2.0)
	for i in 420:
		var a := rng.randf() * TAU
		var el := rng.randf_range(0.12, 1.5)
		var r := 900.0
		var p := Vector3(cos(a) * cos(el) * r, sin(el) * r, sin(a) * cos(el) * r - 40.0)
		var s := rng.randf_range(0.8, 2.2)
		box(Vector3(s, s, s), p, sm, false, stars)
	_batch(stars, 100000.0)
	eye_sky = Node3D.new()
	eye_sky.visible = false
	add_child(eye_sky)
	var em := StandardMaterial3D.new()
	em.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	em.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	em.albedo_texture = Tex.eye()
	em.disable_fog = true
	em.cull_mode = BaseMaterial3D.CULL_DISABLED
	for i in 48:
		var p := Vector3(rng.randf_range(-40, 110), rng.randf_range(55, 130), rng.randf_range(-170, 0))
		var q := quad(Vector2(1, 1) * rng.randf_range(5.0, 11.0), p, 0.0, em, eye_sky)
		q.rotation = Vector3(PI / 2.0 + rng.randf_range(-0.3, 0.3), rng.randf() * TAU, 0)
	_batch(eye_sky, 100000.0)


# ------------------------------------------------------------------ the site

## The gate: a dead reader, a dead camera, barriers, the sign, and the
## police drone holding over it with nothing to say to a company car.
func _gate() -> void:
	var k := _kit_mats()
	for sd: float in [-1.0, 1.0]:
		box(Vector3(0.5, 5.6, 0.5), GATE + Vector3(sd * 6.0, 2.8, 0), k["plinth"], true)
	# the sign board, dead: the lettering only reads by the car's lights
	box(Vector3(12.6, 2.0, 0.4), GATE + Vector3(0, 4.5, 0), mat(Color(0.16, 0.17, 0.2), 0.7, 0.4))
	var sr := Node3D.new()
	sr.position = GATE + Vector3(0, 4.5, 0.22)
	add_child(sr)
	label(LINES["signs"]["gate1"], Vector3(0, 0.42, 0), 0.0, 0.008, Color(0.75, 0.72, 0.65), sr, false)
	label(LINES["signs"]["gate2"], Vector3(0, -0.24, 0), 0.0, 0.004, Color(0.6, 0.58, 0.52), sr, false)
	label(LINES["signs"]["gate3"], Vector3(0, -0.66, 0), 0.0, 0.003, Color(0.6, 0.22, 0.2), sr, false)
	# the reader on a post, dead; the camera over it, dead
	box(Vector3(0.16, 1.2, 0.16), GATE + Vector3(-5.2, 0.6, 1.2), k["metal"], true)
	box(Vector3(0.12, 0.3, 0.2), GATE + Vector3(-5.2, 1.3, 1.2), k["dark"])
	var rd := interactable("gate_reader", "The gate reader", GATE + Vector3(-5.2, 1.0, 1.2), Vector3(0.5, 1.6, 0.5), LINES["signs"]["gate_scan"], false)
	rd.set_meta("hackable", true)
	var cam := prop("security_camera_01", GATE + Vector3(-5.6, 3.6, 0.3), 0.6, 1.0, false)
	if cam:
		cam.set_meta("scan", LINES["signs"]["cam_scan"])
		cam.set_meta("hackable", true)
	prop("concrete_road_barrier", GATE + Vector3(-3.6, 0, 3.0), 0.0, 1.0, true)
	prop("concrete_road_barrier", GATE + Vector3(4.0, 0, 3.0), 0.0, 1.0, true)
	prop("utility_box_01", GATE + Vector3(6.8, 0, -1.0), -PI / 2.0, 1.0, true)
	# the police drone, a shadow within a shadow, one red light
	drone = Node3D.new()
	drone.position = GATE + Vector3(3.0, 7.5, 2.0)
	add_child(drone)
	var pd := prop("police_drone", Vector3.ZERO, 0.0, 1.0, false, drone)
	if pd == null:
		box(Vector3(1.2, 0.4, 1.2), Vector3.ZERO, k["dark"], false, drone)
	var rl := box(Vector3(0.1, 0.1, 0.1), Vector3(0, -0.2, -0.5), glow(Color(1, 0.06, 0.05), 4.0), false, drone)
	blinkers.append(rl)
	drone.set_meta("drone", true)
	var dit := interactable("drone", LINES["signs"]["drone_prompt"], Vector3(0, 0, 0), Vector3(1.6, 1.0, 1.6), LINES["signs"]["drone_scan"], false, drone)
	dit.set_meta("drone", true)
	dit.set_meta("hackable", true)


## The parking apron: the school shuttle, the dead kiosk, a few lamps.
func _apron() -> void:
	var asphalt := pbr("asphalt", Vector3(1, 1, 1) / 4.0, true, Color(0.66, 0.64, 0.62), 0.9)
	floor_quad(Vector2(30, 24), Vector3(0, 0.025, 6.0), 0.0, asphalt)
	var line := mat(Color(0.5, 0.48, 0.4), 0.7)
	for i in 5:
		box(Vector3(0.1, 0.01, 5.0), Vector3(-12.0 + i * 3.0, 0.04, 12.0), line)
	# the academy shuttle, nose to the kerb, twenty-four bags still in it
	var sv := Node3D.new()
	sv.position = Vector3(-7.5, 0, 8.0)
	sv.rotation.y = 0.15
	add_child(sv)
	sv.add_child(Car.build(self, Color(0.85, 0.75, 0.25), {"van": true, "plate": "ACAD 03", "head": mat(Color(0.25, 0.25, 0.22), 0.5), "tail": mat(Color(0.3, 0.06, 0.05), 0.5)}))
	solid_box(Vector3(2.2, 2.0, 5.4), Vector3(0, 1.0, 0), sv)
	var svi := interactable("shuttle", LINES["signs"]["shuttle_prompt"], Vector3(0, 1.0, 0), Vector3(2.4, 2.2, 5.6), LINES["signs"]["shuttle_scan"], false, sv)
	svi.set_meta("hackable", true)
	var kiosk := prop("vending_kiosk", Vector3(12.0, 0, 0.0), -PI / 2.0, 1.0, true)
	if kiosk:
		kiosk.set_meta("hackable", true)
	var ki := interactable("kiosk", LINES["signs"]["kiosk_prompt"], Vector3(12.0, 1.0, 0.0), Vector3(1.6, 2.2, 1.6), LINES["signs"]["kiosk_scan"], false)
	ki.set_meta("hackable", true)
	prop("metal_trash_can", Vector3(10.0, 0, 3.0), 0.0, 1.0, true)
	prop("Barrel_01", Vector3(14.0, 0, 3.4), 0.4, 1.0, true)
	prop("cardboard_box_01", Vector3(-13.0, 0, 2.0), 0.9, 1.0, true)


## The observatory: a drum with a dome and a shut slit, the telescope out
## front for the children, everything dead.
func _dome() -> void:
	var wall := pbr("concrete", Vector3(1, 1, 1) / 2.5, true, Color(0.55, 0.53, 0.5), 1.0)
	var k := _kit_mats()
	cyl(7.0, 7.4, 6.0, DOME + Vector3(0, 3.0, 0), wall, 18)
	var sb := solid_box(Vector3(14.0, 6.0, 14.0), DOME + Vector3(0, 3.0, 0))
	sb.rotation.y = 0.0
	var dm := SphereMesh.new()
	dm.radius = 7.2
	dm.height = 7.2
	dm.radial_segments = 18
	dm.rings = 8
	mesh(dm, DOME + Vector3(0, 6.0, 0), mat(Color(0.5, 0.52, 0.55), 0.35, 0.7))
	# the slit, shut: a darker seam up the dome
	var seam := box(Vector3(1.2, 7.0, 0.3), DOME + Vector3(0, 7.2, 6.4), k["dark"])
	seam.rotation.x = -0.9
	# the door and a dead lamp over it, a sign
	box(Vector3(1.4, 2.4, 0.2), DOME + Vector3(0, 1.2, 7.35), k["dark"])
	box(Vector3(0.5, 0.1, 0.3), DOME + Vector3(0, 2.8, 7.5), k["metal"])
	var dit := interactable("dome", LINES["signs"]["dome_prompt"], DOME + Vector3(0, 1.3, 7.4), Vector3(2.0, 2.6, 0.6), LINES["signs"]["dome_scan"], false)
	dit.set_meta("hackable", true)
	prop("fuse_panel", DOME + Vector3(3.0, 1.2, 7.3), 0.0, 1.0, false)
	prop("exterior_aircon_unit", DOME + Vector3(-5.0, 2.5, 5.4), 0.4, 1.0, false)
	# the telescope on its mount outside, for the children, aimed at nothing
	var tp := DOME + Vector3(12.0, 0, 2.0)
	box(Vector3(0.9, 0.1, 0.9), tp + Vector3(0, 0.05, 0), k["metal"])
	cyl(0.08, 0.1, 1.2, tp + Vector3(0, 0.6, 0), k["metal"], 8)
	var tube := cyl(0.12, 0.16, 1.8, tp + Vector3(0, 1.4, 0), mat(Color(0.85, 0.85, 0.88), 0.3, 0.6), 10)
	tube.rotation.x = -0.9
	interactable("telescope", LINES["signs"]["telescope_prompt"], tp + Vector3(0, 1.0, 0), Vector3(1.2, 2.2, 1.6), LINES["signs"]["telescope_scan"], true)


## The camp round the fire pit: tables, a cold fire, crates, the tents.
func _camp() -> void:
	var k := _kit_mats()
	var stone := mat(Color(0.4, 0.38, 0.35), 1.0)
	for i in 12:
		var a := i * TAU / 12.0
		var s := box(Vector3(0.4, 0.3, 0.3), CAMP + Vector3(cos(a) * 1.1, 0.12, sin(a) * 1.1), stone)
		s.rotation.y = a
	var ash := decal_mat(Tex.sand(), Color(0.25, 0.24, 0.23), 1.0)
	floor_quad(Vector2(2.0, 2.0), CAMP + Vector3(0, 0.03, 0), 0.3, ash)
	solid_box(Vector3(2.4, 0.4, 2.4), CAMP + Vector3(0, 0.1, 0))
	interactable("firepit", LINES["signs"]["firepit_prompt"], CAMP + Vector3(0, 0.3, 0), Vector3(2.6, 0.8, 2.6), LINES["signs"]["firepit_scan"], false)
	# picnic tables
	var wood := pbr("woodfloor", Vector3(1, 1, 1) / 1.5, true, Color(0.6, 0.5, 0.4), 1.0)
	for tp: Vector3 in [CAMP + Vector3(-9.0, 0, 6.0), CAMP + Vector3(9.0, 0, 7.0)]:
		box(Vector3(2.0, 0.08, 0.8), tp + Vector3(0, 0.75, 0), wood, true)
		for sz: float in [-0.7, 0.7]:
			box(Vector3(2.0, 0.06, 0.3), tp + Vector3(0, 0.45, sz), wood, true)
		for sx: float in [-0.8, 0.8]:
			box(Vector3(0.08, 0.75, 1.4), tp + Vector3(sx, 0.37, 0), k["metal"])
	prop("plastic_crate_03", CAMP + Vector3(-6.0, 0, -3.0), 0.3, 1.0, true)
	prop("plastic_crate_03", CAMP + Vector3(-6.4, 0, -4.2), 0.9, 1.0, true)
	prop("cardboard_box_01", CAMP + Vector3(6.5, 0, -2.0), 0.0, 1.0, true)
	prop("old_tyre", CAMP + Vector3(-12.0, 0, -8.0), 0.0, 1.0, true)
	# a torch dropped in the sand, still on: the one light up here
	var tl := box(Vector3(0.05, 0.05, 0.22), CAMP + Vector3(3.0, 0.03, 2.5), k["dark"])
	tl.rotation.y = 0.7
	box(Vector3(0.04, 0.04, 0.02), CAMP + Vector3(3.08, 0.03, 2.4), glow(Color(1.0, 0.95, 0.8), 3.0))
	light(CAMP + Vector3(3.6, 0.2, 2.0), Color(1.0, 0.9, 0.7), 1.2, 7.0, false)


## "The area was littered with small, empty tents, perfect for
## ten-year-olds." Nine of them; three to go into.
func _tents() -> void:
	var cols := [Color(0.55, 0.2, 0.18), Color(0.2, 0.35, 0.55), Color(0.5, 0.45, 0.2), Color(0.25, 0.45, 0.3)]
	var n := 0
	for row in 2:
		for i in 5:
			if row == 1 and i == 4:
				continue
			var p := CAMP + Vector3(-12.0 + i * 6.5, 0, -6.0 - row * 9.0)
			var ry := (PI if row == 0 else 0.0) + rng.randf_range(-0.2, 0.2)
			var id := ""
			match n:
				1: id = "tent_other"
				3: id = "tent_mira"
				6: id = "tent_ezra"
			_tent(p, ry, cols[n % cols.size()], id)
			n += 1


## A pup tent facing +Z in its own frame: two sloping sides, a back, a
## groundsheet, the flap open. Solid at the back so Carl looks in, not through.
func _tent(p: Vector3, ry: float, c: Color, id: String) -> void:
	var root := Node3D.new()
	root.position = p
	root.rotation.y = ry
	add_child(root)
	var fab := pbr("fabric", Vector3(1, 1, 1) / 1.2, true, c, 1.0)
	var k := _kit_mats()
	for sd: float in [-1.0, 1.0]:
		var side := box(Vector3(0.04, 1.75, 2.2), Vector3(sd * 0.72, 0.68, 0), fab, false, root)
		side.rotation.z = sd * 0.72
	var back := box(Vector3(1.6, 1.3, 0.04), Vector3(0, 0.6, -1.1), fab, false, root)
	back.rotation.z = 0.0
	box(Vector3(1.5, 0.02, 2.2), Vector3(0, 0.01, 0), mat(Color(0.12, 0.12, 0.13), 0.9), false, root)
	stick(Vector3(0, 0, -1.1), Vector3(0, 1.32, -1.1), 0.015, k["metal"], root)
	stick(Vector3(0, 0, 1.1), Vector3(0, 1.32, 1.1), 0.015, k["metal"], root)
	solid_box(Vector3(1.6, 1.4, 1.2), Vector3(0, 0.7, -0.5), root)
	# a sleeping bag, and what each child left
	var bag := mat(Color(0.3, 0.3, 0.5) if id != "tent_mira" else Color(0.6, 0.3, 0.4), 0.8)
	if id == "tent_mira":
		# rolled, the way she did everything; the lion's twin on it; the drawing under
		var roll := cyl(0.16, 0.16, 0.7, Vector3(0.1, 0.16, -0.5), bag, 10, root)
		roll.rotation.z = PI / 2.0
		var lion := mat(Color(0.85, 0.62, 0.25), 0.9)
		var lp := Vector3(0.05, 0.36, -0.5)
		sphere(0.09, lp, lion, 10, root).scale = Vector3(1.0, 0.8, 1.3)
		sphere(0.07, lp + Vector3(0, 0.08, 0.1), lion, 10, root)
		box(Vector3(0.03, 0.04, 0.005), lp + Vector3(0.08, -0.02, 0.1), mat(Color(0.95, 0.95, 0.9), 0.9), false, root)
		var paper := decal_mat(_mira_drawing(), Color(1, 1, 1), 0.9)
		floor_quad(Vector2(0.32, 0.24), Vector3(-0.3, 0.025, 0.1), 0.4, paper, root)
	elif id == "tent_ezra":
		box(Vector3(0.7, 0.14, 1.6), Vector3(0.1, 0.07, -0.3), bag, false, root)
		box(Vector3(0.18, 0.012, 0.26), Vector3(-0.35, 0.03, 0.2), k["dark"], false, root)
		for sx: float in [-0.12, 0.12]:
			box(Vector3(0.09, 0.07, 0.22), Vector3(0.3 + sx, 0.04, 1.35), mat(Color(0.15, 0.12, 0.1), 0.9), false, root)
	else:
		box(Vector3(0.7, 0.14, 1.6), Vector3(-0.1, 0.07, -0.3), bag, false, root)
		box(Vector3(0.06, 0.06, 0.2), Vector3(0.4, 0.04, 0.3), k["metal"], false, root)
		box(Vector3(0.12, 0.02, 0.08), Vector3(0.3, 0.02, 0.6), mat(Color(0.9, 0.3, 0.5), 0.8), false, root)
	if id != "":
		interactable(id, LINES["signs"][id + "_prompt"], Vector3(0, 0.7, 0.6), Vector3(1.4, 1.4, 1.2), LINES["signs"][id + "_scan"], false, root)
	else:
		interactable("tent", LINES["signs"]["tent_any_prompt"], Vector3(0, 0.7, 0.6), Vector3(1.4, 1.4, 1.2), "", false, root)


## Mira's drawing: the circle of figures, the plated snake over them, the
## tower, and the eye above all of it, in crayon. Drawn before it happened.
func _mira_drawing() -> ImageTexture:
	var w := 160
	var h := 120
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	var r := RandomNumberGenerator.new()
	r.seed = 16
	for y in h:
		for x in w:
			var v := 0.86 + r.randf_range(-0.06, 0.05)
			img.set_pixel(x, y, Color(v, v * 0.98, v * 0.9, 1.0))
	var red := Color(0.85, 0.08, 0.05, 1.0)
	var green := Color(0.1, 0.6, 0.25, 1.0)
	var black := Color(0.12, 0.1, 0.1, 1.0)
	var blue := Color(0.15, 0.25, 0.7, 1.0)
	# the circle of small figures
	for i in 14:
		var a := i * TAU / 14.0
		var cx := 80.0 + cos(a) * 40.0
		var cy := 86.0 + sin(a) * 16.0
		_cray(img, r, cx, cy - 4.0, cx, cy + 5.0, black)
		_cray(img, r, cx - 3.0, cy, cx + 3.0, cy, black)
		img.set_pixel(int(cx), int(cy - 6.0), black)
		img.set_pixel(int(cx) + 1, int(cy - 6.0), black)
	# the snake: a wave of plates over them
	var px := 30.0
	var py := 60.0
	for i in 60:
		var nx := 30.0 + i * 1.7
		var ny := 60.0 + sin(i * 0.3) * 14.0
		_cray(img, r, px, py, nx, ny, green)
		_cray(img, r, px, py + 3.0, nx, ny + 3.0, green)
		if i % 4 == 0:
			_cray(img, r, nx, ny - 3.0, nx, ny + 6.0, green)
		px = nx
		py = ny
	# the tower, a tall box with windows, at the right
	_cray(img, r, 138.0, 100.0, 138.0, 30.0, blue)
	_cray(img, r, 150.0, 100.0, 150.0, 30.0, blue)
	_cray(img, r, 138.0, 30.0, 150.0, 30.0, blue)
	# the eye over everything
	for i in 200:
		var a := i * TAU / 200.0
		var ex := 80.0 + cos(a) * 26.0
		var ey := 18.0 + sin(a) * 11.0
		img.set_pixel(int(ex), int(ey), red)
		img.set_pixel(int(ex) + 1, int(ey), red)
	for i in 60:
		var a := i * TAU / 60.0
		img.set_pixel(int(80.0 + cos(a) * 6.0), int(18.0 + sin(a) * 6.0), red)
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


func _cray(img: Image, r: RandomNumberGenerator, x0: float, y0: float, x1: float, y1: float, c: Color) -> void:
	var n := int(maxf(absf(x1 - x0), absf(y1 - y0))) + 1
	for i in n + 1:
		var t := float(i) / float(n)
		var p := Vector2(lerpf(x0, x1, t) + r.randf_range(-0.8, 0.8), lerpf(y0, y1, t) + r.randf_range(-0.8, 0.8))
		if p.x >= 0 and p.y >= 0 and p.x < img.get_width() and p.y < img.get_height():
			img.set_pixelv(p, c)


## The brush north of the camp: thick dark bushes, the two ways through
## them to the cliff, and the gate in the brush that opens with the song.
func _brush_and_trails() -> void:
	var leaf := mat(Color(0.1, 0.12, 0.08), 1.0)
	var bark := pbr("bark", Vector3(1, 1, 1) / 2.0, true, Color(0.5, 0.45, 0.4), 1.0)
	var leafs := [mat(Color(0.12, 0.15, 0.1), 1.0), mat(Color(0.1, 0.13, 0.09), 1.0)]
	for i in 160:
		var p := Vector3(rng.randf_range(-70, 90), 0, rng.randf_range(-98, -38))
		if _near_trail(p, 3.6):
			continue
		if p.distance_to(CAMP) < 14.0:
			continue
		var r := rng.randf_range(1.2, 3.0)
		var b := sphere(r, p + Vector3(0, r * 0.55, 0), leaf, 8)
		b.scale = Vector3(rng.randf_range(0.8, 1.4), 0.7, rng.randf_range(0.8, 1.4))
		if i % 2 == 0:
			solid_box(Vector3(r * 1.4, 2.0, r * 1.4), p + Vector3(0, 1.0, 0))
	for i in 9:
		var p := Vector3(rng.randf_range(-60, 80), 0, rng.randf_range(-94, -44))
		if _near_trail(p, 5.0):
			continue
		tree(p, rng.randf_range(4.0, 7.0), bark, leafs)
	# the brushline at the cliff: a wall of it, the gap at GAP, shut until the song
	for x in range(-70, 92, 4):
		if absf(x - GAP.x) < 3.5:
			continue
		var p := Vector3(x + rng.randf_range(-1, 1), 0, -99.0 + rng.randf_range(-1.5, 1.5))
		var r := rng.randf_range(2.0, 3.2)
		sphere(r, p + Vector3(0, r * 0.5, 0), leaf, 8).scale = Vector3(1.2, 0.8, 1.0)
		solid_box(Vector3(4.2, 3.0, 3.0), p + Vector3(0, 1.5, 0))
	brush_gate = solid_box(Vector3(7.0, 3.0, 2.0), GAP + Vector3(0, 1.5, 2.0))
	brush_it = interactable("brush", LINES["signs"]["brush_prompt"], GAP + Vector3(0, 1.2, 3.0), Vector3(7.0, 2.4, 1.0), "", false)
	# the candle stubs along the long way round: real, warm, on the ground
	var prev := CANDLE_TRAIL[0] as Vector3
	var cn := 0
	for i in range(1, CANDLE_TRAIL.size()):
		var a := CANDLE_TRAIL[i - 1] as Vector3
		var b := CANDLE_TRAIL[i] as Vector3
		var steps := int(a.distance_to(b) / 5.0)
		for s in steps:
			var p := a.lerp(b, float(s) / float(maxi(1, steps))) + Vector3(rng.randf_range(-0.6, 0.6), 0, rng.randf_range(-0.6, 0.6))
			cyl(0.025, 0.03, 0.12, p + Vector3(0, 0.06, 0), mat(Color(0.9, 0.85, 0.7), 0.9), 6)
			box(Vector3(0.03, 0.05, 0.03), p + Vector3(0, 0.15, 0), _candle_m)
			if cn % 4 == 0:
				var cl := light(p + Vector3(0, 0.5, 0), Color(1.0, 0.65, 0.3), 0.7, 5.0, false)
				flickers.append(cl)
			if cn == 5:
				interactable("candle", LINES["signs"]["candle_prompt"], p + Vector3(0, 0.2, 0), Vector3(0.6, 0.5, 0.6), "", false)
			cn += 1
		prev = b


func _near_trail(p: Vector3, d: float) -> bool:
	var pts := [CAMP + Vector3(10.0, 0, -12.0)] + SONG_TRAIL + [GAP]
	for i in range(1, pts.size()):
		if _seg_dist(p, pts[i - 1], pts[i]) < d:
			return true
	var cp := [CAMP + Vector3(-10.0, 0, -12.0)] + CANDLE_TRAIL + [GAP]
	for i in range(1, cp.size()):
		if _seg_dist(p, cp[i - 1], cp[i]) < d:
			return true
	return false


func _seg_dist(p: Vector3, a: Vector3, b: Vector3) -> float:
	var ab := b - a
	var t := clampf((p - a).dot(ab) / maxf(0.001, ab.length_squared()), 0.0, 1.0)
	return p.distance_to(a + ab * t)


## The cliff: the plateau's northern lip, and the slope down through the gap.
func _cliff() -> void:
	# the lip, broken, from x -80 to 100 at z -104 .. -108, down to the flat
	for x in range(-80, 100, 6):
		if absf(x - GAP.x) < 5.0:
			continue
		var lh := rng.randf_range(3.7, 4.3)
		var r := box(Vector3(rng.randf_range(5.0, 7.5), lh, rng.randf_range(3.0, 5.0)), Vector3(x, LOWER_Y + lh / 2.0 - 0.15, -106.0 + rng.randf_range(-1, 1)), _dark_rock, true)
		r.rotation = Vector3(rng.randf_range(-0.1, 0.1), rng.randf_range(-0.15, 0.15), rng.randf_range(-0.1, 0.1))
	edge_it = interactable("edge", LINES["signs"]["edge_prompt"], EDGE + Vector3(0, 0.8, 0), Vector3(5.0, 1.6, 3.0), "", false)
	# the way down: a ramp of rock through the gap, from the lip (z -102,
	# y 0) to the flat (z -114); negative x rotation lifts the +Z end
	var ra := atan(-LOWER_Y / 12.0)
	var ramp := box(Vector3(5.0, 1.0, 12.0 / cos(ra) + 0.6), Vector3(GAP.x, LOWER_Y / 2.0 - 0.5 / cos(ra), -108.0), _rock, true)
	ramp.rotation.x = -ra
	# the lower flat under the plateau
	solid_box(Vector3(220, 2, 90), Vector3(40, LOWER_Y - 1.0, -150))
	for cx in 4:
		for cz in 2:
			floor_quad(Vector2(60, 50), Vector3(-50.0 + cx * 60.0, LOWER_Y, -130.0 - cz * 50.0), 0.0, _sand)
	# the plateau's face above the flat, and the rock walls north and west
	# (in two pieces, so the ramp's gap stays open)
	box(Vector3(147, -LOWER_Y, 4.0), Vector3(-36.5, LOWER_Y / 2.0, -108.5), _dark_rock)
	box(Vector3(103, -LOWER_Y, 4.0), Vector3(98.5, LOWER_Y / 2.0, -108.5), _dark_rock)
	for x in range(-60, 150, 8):
		var h := rng.randf_range(8.0, 16.0)
		var nb := box(Vector3(9.0, h, rng.randf_range(5.0, 9.0)), Vector3(x, LOWER_Y + h / 2.0 - 1.0, -184.0), _dark_rock, true)
		nb.rotation.y = rng.randf_range(-0.1, 0.1)
	for z in range(-184, -106, 8):
		var h := rng.randf_range(8.0, 14.0)
		box(Vector3(rng.randf_range(6.0, 10.0), h, 9.0), Vector3(-30.0, LOWER_Y + h / 2.0 - 1.0, z), _dark_rock, true)


## Eren's vans, the riot dogs, scrub and rocks on the flat.
func _lower_flat() -> void:
	var k := _kit_mats()
	for i in 30:
		var p := Vector3(rng.randf_range(-20, 120), LOWER_Y, rng.randf_range(-178, -112))
		if p.distance_to(CIRCLE) < 14.0 or absf(p.x - GAP.x) < 5.0:
			continue
		var r := box(Vector3(rng.randf_range(0.5, 2.0), rng.randf_range(0.3, 1.0), rng.randf_range(0.5, 1.6)), p + Vector3(0, 0.15, 0), _rock)
		r.rotation.y = rng.randf() * TAU
	for vp: Array in [[Vector3(68.0, 0, -165.0), 1.2], [Vector3(76.0, 0, -158.0), 1.4]]:
		var v := Node3D.new()
		v.position = (vp[0] as Vector3) + Vector3(0, LOWER_Y, 0)
		v.rotation.y = vp[1]
		add_child(v)
		v.add_child(Car.build(self, Color(0.05, 0.05, 0.06), {"van": true, "head": mat(Color(0.2, 0.2, 0.18), 0.5), "tail": mat(Color(0.3, 0.05, 0.05), 0.5)}))
		solid_box(Vector3(2.2, 2.0, 5.4), Vector3(0, 1.0, 0), v)
		var vi := interactable("van", LINES["signs"]["van_prompt"], Vector3(0, 1.0, 0), Vector3(2.4, 2.2, 5.6), LINES["signs"]["van_scan"], false, v)
		vi.set_meta("hackable", true)
	# the riot dogs at heel by the vans, the guns on their backs
	for dp: Vector3 in [Vector3(62.0, 0, -160.0), Vector3(64.5, 0, -162.5)]:
		_dog(dp + Vector3(0, LOWER_Y, 0), -0.8)
	prop("old_tyre", Vector3(80.0, LOWER_Y, -170.0), 0.3, 1.0, true)
	prop("Barrel_01", Vector3(74.0, LOWER_Y, -172.0), 0.0, 1.0, true)
	prop("power_box_01", Vector3(84.0, LOWER_Y, -150.0), -PI / 2.0, 1.0, true)
	# a generator and a dead floodlight rig they brought and did not switch on
	box(Vector3(1.4, 0.9, 0.8), Vector3(56.0, LOWER_Y + 0.45, -168.0), k["metal"], true)
	box(Vector3(0.12, 4.0, 0.12), Vector3(58.0, LOWER_Y + 2.0, -168.0), k["metal"])
	box(Vector3(0.9, 0.5, 0.3), Vector3(58.0, LOWER_Y + 4.1, -167.8), k["dark"])


## A riot dog: a machine on four legs with a gun on its back. Boxes only.
func _dog(p: Vector3, ry: float) -> void:
	var root := Node3D.new()
	root.position = p
	root.rotation.y = ry
	add_child(root)
	var k := _kit_mats()
	box(Vector3(0.38, 0.32, 0.95), Vector3(0, 0.55, 0), k["dark"], false, root)
	box(Vector3(0.28, 0.24, 0.32), Vector3(0, 0.62, -0.6), k["metal"], false, root)
	box(Vector3(0.05, 0.05, 0.05), Vector3(0.08, 0.66, -0.77), glow(Color(1, 0.08, 0.05), 3.0), false, root)
	box(Vector3(0.05, 0.05, 0.05), Vector3(-0.08, 0.66, -0.77), glow(Color(1, 0.08, 0.05), 3.0), false, root)
	for sx: float in [-0.16, 0.16]:
		for sz: float in [-0.35, 0.35]:
			box(Vector3(0.08, 0.3, 0.08), Vector3(sx, 0.3, sz), k["metal"], false, root).rotation.x = 0.3 if sz < 0.0 else -0.3
			box(Vector3(0.06, 0.26, 0.06), Vector3(sx, 0.12, sz + (0.08 if sz < 0.0 else -0.08)), k["dark"], false, root)
	# the gun: a tube on a mount, forward
	box(Vector3(0.2, 0.12, 0.3), Vector3(0, 0.77, 0.1), k["metal"], false, root)
	var gun := cyl(0.03, 0.035, 0.6, Vector3(0, 0.84, -0.2), k["dark"], 8, root)
	gun.rotation.x = PI / 2.0
	solid_box(Vector3(0.5, 0.9, 1.1), Vector3(0, 0.45, 0), root)
	root.set_meta("dog", true)
	var it := interactable("dog", LINES["signs"]["dog_prompt"], Vector3(0, 0.5, 0), Vector3(0.7, 1.0, 1.3), LINES["signs"]["dog_scan"], false, root)
	it.set_meta("dog", true)
	it.set_meta("hackable", true)
	dogs.append(root)


## The circle: the stick rings, candles, sixteen children seated facing the
## middle, Mira standing in it, Ezra beside her, and the three men at its
## far edge in the dark until the eye comes down.
func _circle() -> void:
	for r: float in [5.6, 6.3]:
		var n := 22 if r < 6.0 else 30
		for i in n:
			var a := i * TAU / n
			var b := (i + 1) * TAU / n
			if r > 6.0 and i == 0:
				continue  # the gap in the outer ring, toward the cliff
			stick(CIRCLE + Vector3(cos(a) * r, 0.04, sin(a) * r), CIRCLE + Vector3(cos(b) * r, 0.04 + rng.randf_range(0.0, 0.04), sin(b) * r), 0.015, _stick_m)
	for i in 12:
		var a := i * TAU / 12.0 + 0.1
		var p := CIRCLE + Vector3(cos(a) * 6.8, 0, sin(a) * 6.8)
		cyl(0.03, 0.035, 0.14, p + Vector3(0, 0.07, 0), mat(Color(0.9, 0.85, 0.7), 0.9), 6)
		box(Vector3(0.04, 0.06, 0.04), p + Vector3(0, 0.17, 0), _candle_m)
		if i % 4 == 0:
			var cl := light(p + Vector3(0, 0.6, 0), Color(1.0, 0.65, 0.3), 1.3, 9.0, false)
			flickers.append(cl)
	var skins := [Color(0.85, 0.66, 0.52), Color(0.6, 0.42, 0.3), Color(0.4, 0.28, 0.2), Color(0.92, 0.78, 0.66), Color(0.72, 0.56, 0.44)]
	var coats := [Color(0.5, 0.2, 0.2), Color(0.2, 0.3, 0.55), Color(0.55, 0.5, 0.2), Color(0.25, 0.45, 0.3), Color(0.5, 0.3, 0.5), Color(0.3, 0.3, 0.32)]
	for i in 16:
		var a := i * TAU / 16.0 + 0.2
		var p := CIRCLE + Vector3(cos(a) * 4.6, 0, sin(a) * 4.6)
		var f := figure(coats[i % coats.size()], skins[i % skins.size()], {"arms": true, "knees": true, "visor": true, "scale": rng.randf_range(0.6, 0.7),
			"hair": [Color(0.15, 0.12, 0.1), Color(0.5, 0.35, 0.2), Color(0.05, 0.04, 0.04)][i % 3], "long_hair": i % 2 == 0, "long_coat": false})
		f.position = p + Vector3(0, -0.5, 0)
		add_child(f)
		turn_to(f, CIRCLE + Vector3(0, 0, 0))
		Anim.sit(f, 0.05)
		f.set_meta("child", true)
		var it := person("child", LINES["signs"]["child_prompt"], f, LINES["signs"]["child_scan"])
		it.set_meta("child", true)
		children.append({"node": f, "base": p, "phase": rng.randf() * TAU, "ry": f.rotation.y})
	# Mira, standing in the centre, entranced, looking up
	mira = figure(Color(0.75, 0.3, 0.35), Color(0.86, 0.7, 0.58), {"arms": true, "knees": true, "visor": true, "scale": 0.72, "hair": Color(0.3, 0.2, 0.12), "long_hair": true, "long_coat": false})
	mira.position = CIRCLE + Vector3(0.6, 0, 0.8)
	add_child(mira)
	turn_to(mira, CIRCLE + Vector3(0, 0, -8.0))
	person("mira", LINES["signs"]["mira_prompt"], mira, LINES["signs"]["mira_scan"])
	# Ezra, seated beside her, mouthing the words
	ezra = figure(Color(0.2, 0.35, 0.3), Color(0.86, 0.7, 0.58), {"arms": true, "knees": true, "visor": true, "scale": 0.62, "hair": Color(0.3, 0.2, 0.12), "long_coat": false})
	ezra.position = CIRCLE + Vector3(-0.9, -0.45, 1.2)
	add_child(ezra)
	turn_to(ezra, CIRCLE + Vector3(0, 0, -8.0))
	Anim.sit(ezra, 0.05)
	person("ezra", LINES["signs"]["ezra_prompt"], ezra, LINES["signs"]["ezra_scan"])
	interactable("circle", "The circle", CIRCLE + Vector3(0, 0.3, 0), Vector3(3.0, 0.6, 3.0), "", false)


## The three men. Eren Elontiel in white, the only white on the hill; the two
## with the cube and the vase behind him. "Three men stood within the center
## of the circle": they wait in the dark at its far side until the eye.
func _erens_people() -> void:
	var k := _kit_mats()
	eren = figure(Color(0.93, 0.93, 0.9), Color(0.84, 0.7, 0.6), {"arms": true, "knees": true, "hair": Color(0.6, 0.6, 0.6), "legs": Color(0.9, 0.9, 0.88), "long_coat": true})
	eren.position = CIRCLE + Vector3(0, 0, -7.6)
	add_child(eren)
	turn_to(eren, CIRCLE)
	var ei := person("eren", LINES["signs"]["eren_prompt"], eren, LINES["signs"]["eren_scan"])
	ei.set_meta("guard", false)
	for sd: float in [-1.0, 1.0]:
		var mn := figure(Color(0.08, 0.08, 0.09), Color(0.8, 0.66, 0.54), {"arms": true, "knees": true, "hair": Color(0.05, 0.05, 0.05), "long_coat": true})
		mn.position = CIRCLE + Vector3(sd * 1.6, 0, -8.6)
		add_child(mn)
		turn_to(mn, CIRCLE)
		var arms: Array = mn.get_meta("arms")
		for a in arms:
			(a as Node3D).rotation.x = -1.2  # held out in front
		if sd < 0.0:
			# the jet-black cube
			box(Vector3(0.26, 0.26, 0.26), Vector3(0, 1.05, -0.5), mat(Color(0.01, 0.01, 0.012), 0.05, 0.9), false, mn)
		else:
			# the vase of viscous, glistening liquid
			cyl(0.1, 0.07, 0.3, Vector3(0, 1.1, -0.5), mat(Color(0.6, 0.6, 0.62), 0.1, 0.8), 10, mn)
			cyl(0.085, 0.085, 0.06, Vector3(0, 1.27, -0.5), glow(Color(0.8, 0.1, 0.08), 1.0), 10, mn)
		men.append(mn)
	# the three guards, on the dark edge of the flat
	for gp: Vector3 in [CIRCLE + Vector3(-13.0, 0, 1.0), CIRCLE + Vector3(13.0, 0, 3.0), CIRCLE + Vector3(2.0, 0, -17.0)]:
		var g := figure(Color(0.05, 0.06, 0.14), Color(0.78, 0.62, 0.5), {"arms": true, "knees": true, "visor": true, "hair": Color(0.08, 0.06, 0.05)})
		g.position = Vector3(gp.x, LOWER_Y, gp.z)
		add_child(g)
		turn_to(g, CIRCLE)
		g.set_meta("guard", true)
		g.set_meta("base", g.position)
		var gi := person("guard", LINES["signs"]["guard_prompt"], g, LINES["signs"]["guard_scan"])
		gi.set_meta("guard", true)
		guards.append(g)
	# a green that is not a candle, under where the eye will hang
	var gl := light(CIRCLE + Vector3(0, 3.0, 0), PSYON_GREEN, 0.0, 14.0, false)
	gl.set_meta("eye_light", true)
	gl.visible = false


## The serpent: a chain of plates with a Psyonic-green core, drawn on the
## eye layer only, that rolls and slithers over the circle. With the frames
## off the same place holds a shape of smoke.
func _serpent() -> void:
	serpent = Node3D.new()
	serpent.position = CIRCLE
	serpent.visible = false
	add_child(serpent)
	var red := glow(Color(1.0, 0.1, 0.05), 3.0)
	for i in 28:
		var pl := Node3D.new()
		serpent.add_child(pl)
		var s := 1.0 - i * 0.02  # drawn at 1.8x by _tick_serpent
		if i == 0:
			# the head: a wedge, a jaw, two red eyes, ridges
			box(Vector3(0.5, 0.34, 0.72), Vector3(0, 0, 0), _plate_m, false, pl)
			box(Vector3(0.42, 0.1, 0.5), Vector3(0, -0.2, -0.1), _plate_m, false, pl)
			for sd: float in [-1.0, 1.0]:
				box(Vector3(0.07, 0.07, 0.07), Vector3(sd * 0.17, 0.08, -0.3), red, false, pl)
				box(Vector3(0.06, 0.2, 0.22), Vector3(sd * 0.22, 0.2, 0.1), _plate_m, false, pl)
			box(Vector3(0.56, 0.08, 0.3), Vector3(0, -0.04, 0.2), _core_m, false, pl)
		else:
			box(Vector3(0.44 * s, 0.3 * s, 0.5), Vector3(0, 0, 0), _plate_m, false, pl)
			box(Vector3(0.06, 0.18 * s, 0.3), Vector3(0, 0.2 * s, 0), _plate_m, false, pl)
			# the core shows between the plates and down both flanks
			box(Vector3(0.52 * s, 0.1 * s, 0.24), Vector3(0, -0.02, 0.2), _core_m, false, pl)
		plates.append(pl)
	smoke = Node3D.new()
	smoke.position = CIRCLE
	smoke.visible = false
	add_child(smoke)
	var sm := newmat(Color(0.05, 0.05, 0.06, 0.55), 1.0)
	sm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	for i in 10:
		var pf := sphere(0.9, Vector3.ZERO, sm, 8, smoke)
		puffs.append(pf)


## The eye that descends from the stars: a billboard of it, hung high over
## the circle until the serpent is gone.
func _the_eye() -> void:
	var eq := QuadMesh.new()
	eq.size = Vector2(26, 26)
	eye = MeshInstance3D.new()
	eye.mesh = eq
	eye.material_override = _eye_mat()
	eye.position = CIRCLE + Vector3(0, 160.0, 0)
	eye.visible = false
	add_child(eye)
	no_batch.append(eye)


## The second way up: a goat path of rock slabs off the east end of the
## flat, down to where the hill's shoulder meets the dark. A hook, no gate.
func _goat_path() -> void:
	var p := Vector3(96.0, LOWER_Y, -150.0)
	for i in 14:
		var s := box(Vector3(3.0, 1.0, 3.5), p + Vector3(i * 3.0, -i * 2.2 - 0.5, sin(i * 0.9) * 3.0), _rock, true)
		s.rotation = Vector3(rng.randf_range(-0.1, 0.1), rng.randf_range(-0.2, 0.2), -0.1)
	box(Vector3(60, 40, 60), Vector3(150.0, LOWER_Y - 52.0, -150.0), _dark_rock)
	interactable("goat_path", "The goat path", p + Vector3(2.0, 0.8, 0), Vector3(4.0, 1.6, 4.0), "ORA  -  path: UNMAPPED\ngrade: 35%", false)


func _bounds() -> void:
	solid_box(Vector3(2, 60, 700), Vector3(-200, 0, 0))
	solid_box(Vector3(2, 60, 700), Vector3(200, 0, 0))
	solid_box(Vector3(500, 60, 2), Vector3(0, 0, 320))
	solid_box(Vector3(500, 60, 2), Vector3(0, 0, -200))
	solid_box(Vector3(2, 40, 100), Vector3(140, LOWER_Y, -150))
	# the goat path drops below the map; it is a hook, not a way out tonight
	solid_box(Vector3(2, 12, 100), Vector3(100.5, LOWER_Y, -150))
	# the plateau's edges, where it falls away: low walls of rock you can't step off
	for x in range(-120, 130, 10):
		if absf(x) < 8.0:
			continue
		box(Vector3(10.5, 3.0, 6.0), Vector3(x, 0.4, 78.0), _dark_rock, true)
	for z in range(-98, 80, 10):
		box(Vector3(6.0, 3.0, 10.5), Vector3(-118.0, 0.4, z), _dark_rock, true)
		box(Vector3(6.0, 3.0, 10.5), Vector3(118.0, 0.4, z), _dark_rock, true)


# ------------------------------------------------------------------ the car and Lynx

## The company car from the driver's seat (as in Flats.gd), headlights the
## only light on the road.
func _car() -> void:
	car = Node3D.new()
	car.position = Vector3(0, _road_y(290.0), 290.0)
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
	for x: float in [-0.82, 0.82]:
		stick(Vector3(x, 0.98, -0.95), Vector3(x, 1.8, -0.2), 0.035, trim, car)
		stick(Vector3(x, 0.98, 0.85), Vector3(x, 1.8, 0.65), 0.04, trim, car)
		box(Vector3(0.06, 0.06, 0.9), Vector3(x, 1.8, 0.22), trim, false, car)
		box(Vector3(0.08, 0.5, 2.0), Vector3(x * 1.02, 0.7, 0.0), mat(Color(0.2, 0.2, 0.22), 0.7), false, car)
	box(Vector3(1.7, 0.05, 0.9), Vector3(0, 1.82, 0.22), mat(Color(0.25, 0.25, 0.26), 0.9), false, car)
	box(Vector3(1.7, 0.6, 0.1), Vector3(0, 1.0, 1.0), trim, false, car)
	# the passenger seat, for Lynx
	box(Vector3(0.5, 0.1, 0.5), Vector3(0.45, 0.5, 0.3), trim, false, car)
	box(Vector3(0.5, 0.6, 0.1), Vector3(0.45, 0.85, 0.55), trim, false, car)
	dash_m = newglow(Color(0.25, 0.55, 0.5), 1.0)
	var scr := quad(Vector2(0.3, 0.17), Vector3(0.12, 1.06, -0.6), 0.0, dash_m, car)
	scr.rotation.x = -0.5
	dash_label = label(LINES["signs"]["dash1"], Vector3(0.12, 1.06, -0.592), 0.0, 0.00045, Color(0.05, 0.08, 0.08), car, false)
	dash_label.rotation.x = -0.5
	dash_label.font_size = 48
	var mic := box(Vector3(0.02, 0.02, 0.01), Vector3(-0.05, 1.04, -0.6), glow(Color(1, 0.1, 0.1), 3.0), false, car)
	mic.rotation.x = -0.5
	for x: float in [-0.7, 0.7]:
		var sl := SpotLight3D.new()
		sl.position = Vector3(x, 0.7, -2.0)
		sl.rotation.x = deg_to_rad(-5.0)
		sl.light_color = Color(0.95, 0.9, 0.8)
		sl.light_energy = 6.0
		sl.spot_range = 60.0
		sl.spot_angle = 34.0
		sl.spot_attenuation = 0.8
		sl.shadow_enabled = false
		car.add_child(sl)
		headlights.append(sl)
		box(Vector3(0.36, 0.09, 0.05), Vector3(x, 0.66, -2.78), glow(Color(1, 0.97, 0.9), 3.0), false, car)
	var shell := Car.build(self, Color(0.75, 0.78, 0.8), {"plate": "PSF 0086"})
	shell.position = Vector3(0, 0, 0.1)
	shell.visible = false
	car.add_child(shell)
	car.set_meta("shell", shell)
	my_car_it = interactable("my_car", LINES["signs"]["car_prompt"], Vector3(0, 1.0, 0), Vector3(2.0, 1.8, 4.6), LINES["signs"]["car_scan"], true, car)
	my_car_it.set_meta("hackable", true)
	set_active(my_car_it, false)


## Lynx, in the passenger seat, then at Carl's shoulder. Dark hair, the
## long coat, her frames on (she takes them off for Ezra).
func _lynx() -> void:
	lynx = figure(Color(0.09, 0.08, 0.1), Color(0.88, 0.74, 0.62),
		{"hair": Color(0.12, 0.08, 0.06), "long_hair": true, "legs": Color(0.1, 0.1, 0.12), "arms": true, "knees": true, "visor": true, "long_coat": true})
	lynx.position = car.position + Vector3(0.45, -0.38, 0.25)
	lynx.rotation.y = 0.0
	add_child(lynx)
	Anim.sit(lynx, 0.2)
	lynx_visor = lynx.get_meta("visor")
	var it := person("lynx", LINES["signs"]["lynx_prompt"], lynx, LINES["signs"]["lynx_scan"])
	set_active(it, false)
	lynx.set_meta("it", it)


# ------------------------------------------------------------------ the drive up

func intro() -> void:
	_drive()


## Every wait in this level has a way out: a deadline in game seconds. If
## the car or a figure has not got there by then, it is put there.
func _until(z: float, secs := 60.0) -> void:
	var t := 0.0
	while car.position.z > z and _driving and t < secs:
		await get_tree().process_frame
		t += get_process_delta_time()
	if _driving and car.position.z > z:
		car.position.z = z
		car.position.y = _road_y(z)


func _stop_at(z: float) -> void:
	stop_z = z
	await _until(z + 0.5)
	var t := 0.0
	while speed > 0.05 and _driving and t < 8.0:
		await get_tree().process_frame
		t += get_process_delta_time()
	speed = 0.0


func _go(v: float) -> void:
	stop_z = -9999.0
	want_speed = v


## "The buildings became smaller and smaller, and then we climbed our way
## up." The road, the dead lamps, the choice that is not one, the park.
func _drive() -> void:
	var ui = main.ui
	var p = main.player
	var f: Dictionary = main.flags
	if _drive_started:
		return
	_drive_started = true
	p.seated = true
	p.crouch = 0.5
	_driving = true
	await get_tree().create_timer(1.0).timeout
	await ui.think(LINES["drive"]["think1"])
	await ui.think(LINES["drive"]["think2"])
	ui.close()
	_go(14.0)
	await _until(230.0)
	if lynx:
		await p.face(lynx.global_position + Vector3(0, 1.3, 0), 0.8)
		await ui.say(LINES["drive"]["say_lynx"][0], LINES["drive"]["say_lynx"][1])
	else:
		await ui.think(LINES["drive"]["think_alone"])
	ui.close()
	await p.face(Vector3(0, 2.0, 60.0), 1.2)
	await _until(150.0)
	await ui.caption(LINES["drive"]["cap1"], 4.5)
	await _until(90.0)
	want_speed = 7.0
	await _stop_at(58.0)
	var pick: int = await ui.choose(LINES["drive"]["choices"])
	if pick == 1 and lynx:
		await ui.say(LINES["drive"]["lynx_no"][0], LINES["drive"]["lynx_no"][1])
	await ui.say(LINES["drive"]["say_park"][0], LINES["drive"]["say_park"][1])
	ui.close()
	_go(4.0)
	await _stop_at(PARK_Z)
	main.play("off", -10.0, 0.7)
	dash_label.text = LINES["signs"]["dash2"]
	await ui.think(LINES["drive"]["think3"])
	ui.close()
	await _get_out()
	f["obs_parked"] = true
	main.update_hud()


func _get_out() -> void:
	var p = main.player
	var ui = main.ui
	_driving = false
	_arrived = true
	want_speed = 0.0
	speed = 0.0
	if _engine:
		_engine.stop()
	main.play("door", -6.0)
	(car.get_meta("shell") as Node3D).visible = true
	solid_box(Vector3(1.9, 1.5, 4.5), Vector3(0, 0.75, 0.1), car)
	set_active(my_car_it, true)
	for h in headlights:
		(h as SpotLight3D).light_energy = 0.0
	p.seated = false
	p.crouch = 0.0
	p.position = car.position + Vector3(-1.9, 0.1, 0.5)
	p.yaw = 0.2
	p.rotation.y = p.yaw
	p.pitch = 0.0
	p.velocity = Vector3.ZERO
	if lynx:
		lynx.position = car.position + Vector3(2.0, 0.0, 0.5)
		for l in lynx.get_meta("legs"):
			(l as Node3D).rotation.x = 0.0
		for k in lynx.get_meta("knees"):
			(k as Node3D).rotation.x = 0.0
		(lynx.get_meta("body") as Node3D).rotation.x = 0.0
		lynx_state = "follow"
		set_active(lynx.get_meta("it"), true)
	main.update_hud()
	await ui.think(LINES["drive"]["think4"] if lynx else LINES["drive"]["think4_alone"])
	ui.close()


# ------------------------------------------------------------------ the camp

func interact(node: Object) -> bool:
	var ui = main.ui
	var f: Dictionary = main.flags
	var id := str(node.get_meta("id"))
	match id:
		"gate_reader":
			await ui.think(LINES["camp"]["gate"])
			if not f.has("obs_camp_seen"):
				await _camp_seen()
		"drone":
			await ui.think(LINES["camp"]["drone"])
		"dome":
			await ui.think(LINES["camp"]["dome"])
		"kiosk":
			await ui.think(LINES["camp"]["kiosk"])
		"shuttle":
			await ui.think(LINES["camp"]["shuttle"])
		"firepit":
			await ui.think(LINES["camp"]["firepit"])
		"telescope":
			await ui.think(LINES["camp"]["telescope"])
		"tent":
			await ui.think(LINES["camp"]["tent_again"])
		"tent_other", "tent_ezra", "tent_mira":
			await _tent_look(id)
		"brush":
			await ui.think(LINES["camp"]["brush_open"] if f.has("obs_song") else LINES["camp"]["brush"])
		"candle":
			await ui.think(LINES["camp"]["think_candles"] if f.has("obs_song") else LINES["camp"]["brush"])
		"edge":
			if f.has("obs_song") and not _cliff_done:
				await _cliff_scene()
			elif _cliff_done:
				await ui.think(LINES["cliff"]["think4"])
			else:
				await ui.think(LINES["camp"]["edge_early"])
		"my_car":
			await ui.think(LINES["drive"]["think3"])
		"lynx":
			if _cliff_done:
				await ui.say("Lynx", LINES["lynx"]["say3"][1] if f.has("ezra_home") else LINES["watch"]["lynx"][1])
			elif f.has("obs_song"):
				await ui.say(LINES["camp"]["lynx_whisper2"][0], LINES["camp"]["lynx_whisper2"][1])
			else:
				await ui.say(LINES["camp"]["lynx"][0], LINES["camp"]["lynx"][1])
		"child", "mira", "ezra", "eren", "guard", "circle":
			if not _cliff_done:
				await ui.think(LINES["camp"]["edge_early"])
			else:
				await ui.think(LINES["cliff"]["think3"])
		"van", "dog", "goat_path":
			await ui.think(LINES["camp"]["drone"] if id == "dog" else LINES["camp"]["gate"])
		_:
			return false
	return true


## The first look at the camp, once Carl is through the gate.
func _camp_seen() -> void:
	var ui = main.ui
	main.flags["obs_camp_seen"] = true
	if lynx:
		await ui.say(LINES["camp"]["lynx"][0], LINES["camp"]["lynx"][1])
	else:
		await ui.think(LINES["camp"]["think_alone"])
	await ui.think(LINES["camp"]["think1"])
	await ui.think(LINES["camp"]["think2"])
	ui.close()
	main.update_hud()


## Three tents to look into. Mira's has the lion's twin and the drawing.
func _tent_look(id: String) -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if tents_seen.has(id):
		await ui.think(LINES["camp"]["tent_again"])
		return
	tents_seen[id] = true
	await ui.think(LINES["camp"][id])
	if id == "tent_mira":
		await ui.think(LINES["camp"]["tent_mira2"])
		ui.show_picture(_mira_drawing(), LINES["camp"]["tent_mira_cap"])
		ui.shutter()
		main.play("shutter", -8.0)
		await ui.think(LINES["camp"]["tent_mira_cap"])
		ui.hide_picture()
		f["ev_mira_tent"] = true
		main.log_line("clue", LINES["camp"]["tent_mira_log"])  # bible: +1 clue
	ui.close()
	if tents_seen.size() >= 3 and not f.has("obs_song"):
		await _song_starts()
	main.update_hud()


## "My glasses buzzed in my pocket as if to call my name." The frames go on,
## the sky bends, the song is in the temples, and there are two ways to
## follow it.
func _song_starts() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	f["cinematic"] = true
	await ui.say(LINES["camp"]["say_where"][0], LINES["camp"]["say_where"][1])
	main.play("pressure", -12.0, 1.3)
	p.shake(0.15)
	await ui.think(LINES["camp"]["think3"])
	ui.close()
	if not main.frames_on:
		main.frames_on = true
		ui.set_frames(1.0, main.connection)
		set_glyph_visibility(true, main.connection)
		main.play("on", -6.0)
	ui.glitch(0.6, 1.2)
	eye_sky.visible = true
	await p.face(Vector3(p.global_position.x, 80.0, p.global_position.z - 60.0), 1.6)
	await ui.think(LINES["camp"]["think4"])
	_song.volume_db = -10.0
	_song_lead.volume_db = -6.0
	main.play("chant", -8.0)
	await p.face(GAP + Vector3(0, 1.0, 0), 1.4)
	await ui.think(LINES["camp"]["think5"])
	await ui.think(LINES["camp"]["think6"])
	var pick: int = await ui.choose(LINES["camp"]["choices_lynx"] if lynx else LINES["camp"]["choices"])
	if pick == 0:
		f["obs_follow"] = "song"
		if lynx:
			await ui.say(LINES["camp"]["say_this_way"][0], LINES["camp"]["say_this_way"][1])
		else:
			await ui.think(LINES["camp"]["think_this_way"])
	else:
		f["obs_follow"] = "candles"
		main.frames_on = false
		ui.set_frames(0.0, 0.0)
		set_glyph_visibility(false, main.connection)
		main.play("off", -6.0)
		main.update_hud()
		if lynx:
			await ui.say(LINES["camp"]["lynx_candles"][0], LINES["camp"]["lynx_candles"][1])
		else:
			await ui.think(LINES["camp"]["think_candles"])
	ui.close()
	f["obs_song"] = true
	# the brush opens
	if brush_gate:
		brush_gate.queue_free()
		brush_gate = null
	f.erase("cinematic")
	main.update_hud()


# ------------------------------------------------------------------ the cliff

## The scene at the edge: the serpent, the eye, the address, the choice.
func _cliff_scene() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	if _cliff_done:
		return
	_cliff_done = true
	f["obs_cliff"] = true
	f["cinematic"] = true
	p.position = EDGE + Vector3(0, 0.1, 0)
	p.velocity = Vector3.ZERO
	if lynx:
		lynx_state = "stand"
		lynx_target = EDGE + Vector3(-1.6, 0, 0.8)
	_serpent_on = true
	_rasp.volume_db = -14.0
	_song.volume_db = -4.0
	_song_lead.volume_db = -2.0
	await p.face(CIRCLE + Vector3(0, 2.5, 0), 1.6)
	await ui.think(LINES["cliff"]["think1"])
	if not main.frames_on:
		await ui.think(LINES["cliff"]["think_off"])
		var pick: int = await ui.choose(LINES["cliff"]["choices_off"])
		if pick == 0:
			_frames(true)
		else:
			await ui.think(LINES["cliff"]["think_keep_off"])
	if main.frames_on:
		await ui.think(LINES["cliff"]["think2"])
		await ui.think(LINES["cliff"]["think3"])
	await p.face(mira.global_position + Vector3(0, 1.2, 0), 1.0)
	await ui.think(LINES["cliff"]["think4"])
	if main.frames_on:
		await ui.think(LINES["cliff"]["think5"])
	await ui.think(LINES["cliff"]["think6"])
	if lynx:
		lynx_state = "crouch"
		await ui.think(LINES["cliff"]["think_lynx"])
	ui.close()
	# the serpent eats its tail and is gone
	await p.face(CIRCLE + Vector3(0, 4.0, 0), 1.0)
	var tw := create_tween()
	tw.tween_property(self, "_serpent_ring", 1.0, 2.2).set_trans(Tween.TRANS_SINE)
	tw.tween_property(self, "_serpent_scale", 0.0, 1.6).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	await tw.finished
	_serpent_on = false
	serpent.visible = false
	smoke.visible = false
	_rasp.volume_db = -60.0
	main.play("snap", -6.0, 0.6)
	await ui.think(LINES["cliff"]["think7"])
	ui.close()
	# the eye descends
	if not main.frames_on:
		_frames(true)
		ui.flash(0.4)
		await ui.think(LINES["cliff"]["think_flash"])
		ui.close()
	eye.visible = true
	eye.scale = Vector3(1, 0.05, 1)
	main.play("pressure", -4.0, 0.7)
	var et := create_tween().set_parallel(true)
	et.tween_property(eye, "position", CIRCLE + Vector3(0, 24.0, 0), 5.0).set_trans(Tween.TRANS_SINE)
	et.tween_property(eye, "scale", Vector3(1, 1, 1), 5.0).set_trans(Tween.TRANS_SINE)
	for c in get_children():
		if c is OmniLight3D and c.has_meta("eye_light"):
			c.visible = true
			et.tween_property(c, "light_energy", 2.4, 5.0)
	p.face(CIRCLE + Vector3(0, 24.0, 0), 4.0)
	await et.finished
	p.shake(0.3)
	await ui.think(LINES["cliff"]["think8"])
	ui.close()
	# the three men step into the circle
	await p.face(eren.global_position + Vector3(0, 1.6, 0), 1.2)
	await _move(eren, [CIRCLE + Vector3(0, 0, -3.2)], 1.1)
	_move(men[0], [CIRCLE + Vector3(-1.8, 0, -4.4)], 1.0)
	await _move(men[1], [CIRCLE + Vector3(1.8, 0, -4.4)], 1.0)
	turn_to(eren, CIRCLE + Vector3(0, 0, 6.0), 0.6)
	await ui.think(LINES["cliff"]["think9"])
	await ui.think(LINES["cliff"]["think10"])
	ui.close()
	await _address()
	await _the_choice()


func _frames(on: bool) -> void:
	main.frames_on = on
	main.ui.set_frames(1.0 if on else 0.0, main.connection)
	set_glyph_visibility(on, main.connection)
	main.play("on" if on else "off", -6.0)
	main.update_hud()


## Eren's address, verbatim from ch.16, its first and last thirds.
func _address() -> void:
	var ui = main.ui
	var a: Dictionary = LINES["address"]
	await ui.say("Eren", a["eren1"])
	await ui.say("Eren", a["eren2"])
	await ui.say("Eren", a["eren3"])
	main.learn("tower")
	await ui.say("Eren", a["eren4"])
	main.play("murmur", -4.0, 0.8)
	await ui.think(a["roar"])
	await ui.say("Eren", a["eren5"])
	await ui.say("Eren", a["eren6"])
	await ui.say("Eren", a["eren7"])
	await ui.say("Eren", a["eren8"])
	ui.close()
	_move(men[0], [CIRCLE + Vector3(-1.4, 0, -1.8)], 0.8)
	await _move(men[1], [CIRCLE + Vector3(1.4, 0, -1.8)], 0.8)
	await ui.think(a["men"])
	await ui.think(a["smiled"])
	main.play("pressure", -8.0, 0.9)
	await ui.say("Eren", a["eren9"])
	ui.close()
	_move(mira, [CIRCLE + Vector3(0.3, 0, -1.0)], 0.5)


## Charge, watch, walk down singing; and, with Lynx here and trusted, her
## fourth way, which takes Ezra out before Carl decides about Mira.
func _the_choice() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	await ui.think(LINES["choice"]["think1"])
	var opts: Array = (LINES["choice"]["options"] as Array).duplicate()
	var lynx_can := lynx != null and int(main.trust.get("lynx", 0)) >= 2 and not f.has("ezra_home")
	if lynx_can:
		opts.append(LINES["choice"]["lynx_option"])
	var pick: int = await ui.choose(opts)
	ui.close()
	if pick == 3 and lynx_can:
		await _lynx_takes_ezra()
		await ui.think(LINES["choice"]["think1"])
		pick = await ui.choose(LINES["choice"]["options"])
		ui.close()
	_chosen = true
	match pick:
		0:
			await _charge()
		1:
			await _watch()
		_:
			await _sing()


# ------------------------------------------------------------------ the three ways

## The book's beat: down the hill through the dispersing circle, the three
## guards, the punch, the gut punch, Mira's "I want this", the shock.
func _charge() -> void:
	var ui = main.ui
	var p = main.player
	var f: Dictionary = main.flags
	var c: Dictionary = LINES["charge"]
	await ui.think(c["think1"])
	await ui.think(c["think3"])
	ui.close()
	# the sprint: Carl's own legs down the ramp, the circle breaking up,
	# the guards closing
	f.erase("cinematic")
	_sprint = true
	_caught = false
	_scatter()
	main.update_hud()
	ui.caption(c["cap1"], 3.5)
	main.play("sting", -8.0, 0.8)
	if main._selftest:
		# headless: no legs to sprint with; put him at the edge of the circle
		p.position = mira.global_position + Vector3(0.4, 0.1, 2.6)
	var t := 0.0
	var shouted := false
	while not _caught and p.global_position.distance_to(mira.global_position) > 3.2 and t < 45.0:
		await get_tree().process_frame
		t += get_process_delta_time()
		if not shouted and p.global_position.y < -2.0:
			shouted = true
			ui.caption(c["cap2"], 4.0)
	_sprint = false
	f["cinematic"] = true
	p.velocity = Vector3.ZERO
	for g in guards:
		_move(g, [p.global_position + (g.global_position - p.global_position).normalized() * 0.9], 2.0)
	await ui.think(c["think2"])
	await ui.think(c["think4"])
	await ui.think(c["think5"])
	await ui.say(c["carl1"][0], c["carl1"][1])
	await p.face(mira.global_position + Vector3(0, 1.1, 0), 0.6)
	await ui.say(c["mira1"][0], c["mira1"][1])
	await ui.say(c["carl2"][0], c["carl2"][1])
	await ui.say(c["carl3"][0], c["carl3"][1])
	await ui.say(c["mira2"][0], c["mira2"][1])
	await ui.think(c["think6"])
	var sw: int = await ui.choose(c["swing"])
	ui.close()
	# the punch lands: one guard reels; then the gut punch and the ground
	main.play("slam", -2.0, 1.2)
	p.shake(0.5)
	var g0: Node3D = guards[0]
	var gt := create_tween()
	gt.tween_property(g0, "rotation:x", -0.5, 0.25)
	gt.tween_property(g0, "position:y", LOWER_Y - 0.3, 0.3)
	await get_tree().create_timer(0.5).timeout
	main.play("slam", 0.0, 0.7)
	p.shake(0.9)
	var kneel := create_tween()
	kneel.tween_property(p, "crouch", 1.1, 0.35).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	await ui.think(c["think7"])
	await ui.say(c["mira3"][0], c["mira3"][1])
	ui.close()
	_move(eren, [p.global_position + (eren.global_position - p.global_position).normalized() * 1.6], 0.9)
	await ui.think(c["think8"])
	await p.face(eren.global_position + Vector3(0, 1.5, 0), 0.8)
	await ui.say(c["eren1"][0], c["eren1"][1])
	await ui.say(c["mira4"][0], c["mira4"][1])
	ui.close()
	# the shock: a cut to silence
	main.play("slam", -4.0, 0.9)
	await get_tree().create_timer(0.3).timeout
	main.play("glitch", 0.0, 0.5)
	ui.glitch(1.0, 0.8)
	ui.flash(0.3)
	_silence()
	await ui.fade_to(1.0, 0.4)
	await ui.think(c["think9"])
	await ui.say(c["eren2"][0], c["eren2"][1])
	ui.close()
	main.add_pressure(30.0, c["why"])
	main.add_trust("mira", -1)
	main.add_stance("investigator")
	f["charged_observatory"] = true
	main.log_line("scene", c["log"])
	# one panel: the hill from the ground, boots
	ui.show_picture(_boots_panel(), c["panel_cap"])
	await ui.think(LINES["end"]["think_charge"])
	ui.hide_picture()
	ui.close()
	await _end(false)


## The children scatter from the circle as Carl comes down; the guards
## start toward him. Set when the sprint begins.
func _scatter() -> void:
	for ch in children:
		var n: Node3D = ch["node"]
		for l in n.get_meta("legs"):
			(l as Node3D).rotation.x = 0.0
		for k in n.get_meta("knees"):
			(k as Node3D).rotation.x = 0.0
		n.position.y = LOWER_Y
		var away := (n.position - CIRCLE)
		away.y = 0.0
		var dst := CIRCLE + away.normalized() * rng.randf_range(9.0, 14.0) + Vector3(rng.randf_range(-2, 2), 0, rng.randf_range(-2, 2))
		dst.y = LOWER_Y
		_move(n, [dst], rng.randf_range(0.6, 1.1))


## Carl stays on the ridge. The Seer is named, not initiated.
func _watch() -> void:
	var ui = main.ui
	var p = main.player
	var f: Dictionary = main.flags
	var w: Dictionary = LINES["watch"]
	await ui.think(w["think1"])
	await _move(mira, [CIRCLE + Vector3(0.5, 0, -2.2)], 0.5)
	turn_to(mira, CIRCLE + Vector3(0, 0, 6.0), 0.6)
	await ui.think(w["think2"])
	await ui.say(w["eren1"][0], w["eren1"][1])
	await ui.think(w["think3"])
	if lynx:
		await ui.say(w["lynx"][0], w["lynx"][1])
	ui.close()
	main.add_connection(5.0, w["why"])
	main.add_stance("company_man")
	f["watched_observatory"] = true
	main.log_line("scene", w["log"])
	await ui.fade_to(1.0, 1.2)
	_silence()
	await ui.think(w["think4"])
	ui.close()
	await _end(true)


## Blend: hold the hymn through the circle, eight beats, and stand beside her.
func _sing() -> void:
	var ui = main.ui
	var p = main.player
	var f: Dictionary = main.flags
	var s: Dictionary = LINES["sing"]
	await ui.think(s["think1"])
	ui.close()
	ui.show_toast(s["prompt"], 3.0)
	_song.volume_db = -2.0
	_song_lead.volume_db = 0.0
	# Carl walks down on his own feet while the beats run; the circle lets him through
	var path := [GAP + Vector3(0, 0.1, -2.0), Vector3(GAP.x, LOWER_Y + 0.1, -114.0), CIRCLE + Vector3(2.0, 0.1, 9.0), CIRCLE + Vector3(0.9, 0.1, 1.6)]
	var walk := create_tween()
	var prev: Vector3 = p.global_position
	for pt: Vector3 in path:
		walk.tween_property(p, "position", pt, maxf(0.5, prev.distance_to(pt) / 2.2))
		prev = pt
	var hits := 0
	var hymn: Array = s["hymn"]
	for i in hymn.size():
		ui.caption(str(hymn[i]), 1.5)
		main.play("tap", -14.0, 0.9)
		var hit := false
		var t := 0.0
		# a beat is 1.7 s; headless, one frame (nobody is there to press E)
		while t < 1.7 and not main._selftest:
			await get_tree().process_frame
			t += get_process_delta_time()
			if Input.is_action_just_pressed("interact"):
				hit = true
		if hit or main._selftest:
			hits += 1
	ui.show_toast(s["held"] % hits, 3.0)
	if main._selftest:
		walk.kill()
		p.position = path[path.size() - 1]
	elif walk.is_running():
		await walk.finished
	await p.face(mira.global_position + Vector3(0, 1.1, 0), 0.8)
	main.add_connection(8.0, s["why"])
	await ui.think(s["think2"])
	turn_to(mira, p.global_position, 0.6)
	if int(main.trust.get("mira", 0)) >= 0:
		await ui.say(s["mira_warm"][0], s["mira_warm"][1])
	else:
		await ui.think(s["mira_cold"])
	await p.face(eren.global_position + Vector3(0, 1.5, 0), 0.8)
	await ui.say(s["eren1"][0], s["eren1"][1])
	await ui.think(s["think3"])
	ui.close()
	main.add_stance("sleeper")
	main.add_trust("mira", 1)
	f["sang_observatory"] = true
	main.log_line("scene", s["log"])
	await ui.fade_to(1.0, 1.4)
	_silence()
	await ui.think(s["think4"])
	ui.close()
	await _end(false)


## "Let me." Lynx walks down without her frames and takes Ezra by the hand.
func _lynx_takes_ezra() -> void:
	var ui = main.ui
	var p = main.player
	var f: Dictionary = main.flags
	var l: Dictionary = LINES["lynx"]
	await ui.say(l["say1"][0], l["say1"][1])
	await ui.say(l["say2"][0], l["say2"][1])
	ui.close()
	if lynx_visor:
		lynx_visor.visible = false
	lynx_state = "stand"
	_stand_up(lynx)
	var down := [GAP + Vector3(0, 0, -2.0), Vector3(GAP.x, LOWER_Y, -114.0), CIRCLE + Vector3(2.5, 0, 8.0), ezra.global_position + Vector3(0.7, 0, 0.6)]
	p.face(ezra.global_position + Vector3(0, 1.0, 0), 2.0)
	await _move(lynx, down, 1.3)
	await ui.think(l["think1"])
	ui.close()
	_stand_up(ezra)
	ezra.position.y = LOWER_Y
	var up := [CIRCLE + Vector3(2.5, 0, 8.0), Vector3(GAP.x, LOWER_Y, -114.0), GAP + Vector3(0, 0, -2.0), EDGE + Vector3(-1.6, 0, 1.0)]
	_move(ezra, up, 1.25)
	await _move(lynx, up.duplicate(), 1.25)
	ezra.position = EDGE + Vector3(-2.4, 0, 1.4)
	await ui.think(l["think2"])
	await ui.say(l["say3"][0], l["say3"][1])
	ui.close()
	f["ezra_home"] = true
	main.add_trust("lynx", 1)
	main.log_line("scene", l["log"])
	lynx_state = "stand"
	lynx_target = EDGE + Vector3(-1.6, 0, 1.0)


func _stand_up(fig: Node3D) -> void:
	for l in fig.get_meta("legs"):
		(l as Node3D).rotation.x = 0.0
	for k in fig.get_meta("knees"):
		(k as Node3D).rotation.x = 0.0
	(fig.get_meta("body") as Node3D).rotation.x = 0.0
	for a in fig.get_meta("arms"):
		(a as Node3D).rotation.x = 0.0


## Every loop off at once: the shock is a cut to silence.
func _silence() -> void:
	for k in main.amb:
		var ap = main.amb[k]
		if is_instance_valid(ap):
			ap.stop()


## The Day 4 card, then the holding cell.
func _end(seer: bool) -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if _ended:
		return
	_ended = true
	f["observatory_done"] = true
	f.erase("cinematic")
	await ui.show_card(LINES["build"]["day4_seer"] if seer else LINES["build"]["day4"], 3.2)
	if not main._selftest:
		main.load_level("HoldingCell")


## One panel: the hill from the ground. Boots, and a pair of white legs.
func _boots_panel() -> ImageTexture:
	var w := 320
	var h := 200
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	var r := RandomNumberGenerator.new()
	r.seed = 161
	for y in h:
		for x in w:
			var v := 0.02 + r.randf() * 0.025
			if y > 128:
				v = 0.12 + r.randf() * 0.04  # the ground, close, blurred
			img.set_pixel(x, y, Color(v, v * 0.95, v * 1.1, 1.0))
	for i in 60:
		img.set_pixel(r.randi_range(0, w - 1), r.randi_range(0, 110), Color(0.7, 0.72, 0.8, 1.0))
	# the ridge line, black against the stars
	for x in w:
		var ry := 100 + int(sin(x * 0.02) * 8.0)
		for y in range(ry, 130):
			img.set_pixel(x, y, Color(0.03, 0.03, 0.035, 1.0))
	# boots: black blocks, legs rising out of frame; one pair in white
	for b: Array in [[40, 0.0], [95, 0.0], [160, 1.0], [230, 0.0], [275, 0.0]]:
		var bx: int = b[0]
		var white: float = b[1]
		var leg := Color(0.9, 0.9, 0.88, 1.0) if white > 0.5 else Color(0.06, 0.06, 0.08, 1.0)
		var boot := Color(0.05, 0.04, 0.04, 1.0)
		for y in range(0, 150):
			for x in range(bx, bx + 22):
				img.set_pixel(x, y, leg)
		for y in range(150, 178):
			for x in range(bx - 8, bx + 30):
				img.set_pixel(x, y, boot)
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


# ------------------------------------------------------------------ movers

## Walk a figure through points at a speed, with the walk cycle, and wait.
## The deadline is twice the walk plus three seconds; past it the figure
## is put at the end of the path, so no scene waits on a stuck walker.
func _move(fig: Node3D, path: Array, speed: float) -> void:
	if path.is_empty() or not is_instance_valid(fig):
		return
	for mv0 in movers:
		if mv0["fig"] == fig:
			mv0["done"] = true  # a new walk replaces the old one
	var mv := {"fig": fig, "path": path, "i": 0, "speed": speed, "done": false}
	movers.append(mv)
	var length := 0.0
	var prev: Vector3 = fig.position
	for pt: Vector3 in path:
		length += Vector2(pt.x - prev.x, pt.z - prev.z).length()
		prev = pt
	var limit := length / maxf(0.1, speed * 2.2) * 2.0 + 3.0
	var t := 0.0
	while not mv["done"] and t < limit:
		await get_tree().process_frame
		t += get_process_delta_time()
	if not mv["done"]:
		mv["done"] = true
		if is_instance_valid(fig):
			fig.position = path[path.size() - 1]


func _tick_movers(delta: float) -> void:
	for mv in movers:
		if mv["done"]:
			continue
		var fig: Node3D = mv["fig"]
		var path: Array = mv["path"]
		var i: int = mv["i"]
		if i >= path.size():
			mv["done"] = true
			Anim.idle(fig, _t, 0.0)
			continue
		var tgt: Vector3 = path[i]
		var d := tgt - fig.position
		d.y = 0.0
		var dist := d.length()
		var spd: float = mv["speed"] * 2.2
		if dist < 0.15:
			fig.position.x = tgt.x
			fig.position.z = tgt.z
			if absf(tgt.y - fig.position.y) > 0.01:
				fig.position.y = tgt.y
			mv["i"] = i + 1
			continue
		fig.position += d.normalized() * minf(spd * delta, dist)
		# follow the ramp's height between the plateau and the flat
		var want_y := tgt.y
		if i > 0:
			var prev: Vector3 = path[i - 1]
			var seg := prev.distance_to(tgt)
			var done := prev.distance_to(Vector3(fig.position.x, prev.y, fig.position.z))
			want_y = lerpf(prev.y, tgt.y, clampf(done / maxf(0.1, seg), 0.0, 1.0))
		fig.position.y = want_y
		fig.rotation.y = lerp_angle(fig.rotation.y, atan2(-d.x, -d.z), minf(1.0, delta * 8.0))
		Anim.walk(fig, _t, mv["speed"], 0.0, 1.0)
	var keep := []
	for mv in movers:
		if not mv["done"]:
			keep.append(mv)
	movers = keep


# ------------------------------------------------------------------ each frame

func tick(delta: float) -> void:
	if not car or not main or not main.player:
		return
	var p = main.player
	var pp: Vector3 = p.global_position
	var f: Dictionary = main.flags
	if _driving:
		var target := want_speed
		if stop_z > -9000.0:
			target = clampf((car.position.z - stop_z) * 0.7, 0.0, want_speed)
		speed = move_toward(speed, target, delta * 5.0)
		car.position.z -= speed * delta
		car.position.y = _road_y(car.position.z) + sin(_t * 9.0) * 0.004 * minf(1.0, speed / 6.0)
		car.rotation.x = atan(0.2) if car.position.z > 82.0 else lerpf(car.rotation.x, 0.0, delta * 3.0)
		p.position = car.position + SEAT
		if lynx:
			lynx.position = car.position + Vector3(0.45, -0.38, 0.25)
		if _engine:
			_engine.pitch_scale = 0.7 + speed / 14.0 * 0.6
			_engine.volume_db = -20.0 + speed / 14.0 * 8.0
	# the drone holds over the gate, turning on the spot
	if drone:
		drone.position.y = GATE.y + 7.5 + sin(_t * 0.7) * 0.3
		drone.rotation.y += delta * 0.15
	# the eyes in the sky and the flaming eye over the city: frames on only
	var on: bool = main.frames_on
	eye_sky.visible = on and f.has("obs_song")
	if eye_sky.visible:
		eye_sky.scale = Vector3(1, 1, 1) * (1.0 + sin(_t * 0.6) * 0.03)
	city_eye.visible = on and _arrived
	if city_eye.visible:
		city_eye.scale = Vector3(1.0 + sin(_t * 1.1) * 0.06, 1.0 + cos(_t * 0.9) * 0.08, 1)
	# the song is louder with the frames on; a connection a half-minute of it
	if f.has("obs_song") and not _cliff_done:
		if _song:
			_song.volume_db = -10.0 if on else -26.0
			_song_lead.volume_db = -6.0 if on else -22.0
		if on:
			_drip += delta
			if _drip >= 30.0:
				_drip = 0.0
				main.add_connection(1.0, LINES["camp"]["song_why"])
		# Lynx whispers the candle path twice
		if lynx and not on and str(f.get("obs_follow", "")) == "candles" and _whisper_i < 2 and pp.z < -50.0 - _whisper_i * 30.0 and not main.ui.busy:
			_whisper_i += 1
			main.ui.show_toast("Lynx:  " + str(LINES["camp"]["lynx_whisper" if _whisper_i == 1 else "lynx_whisper2"][1]), 4.0)
		# the edge: the scene, once the brush has opened and he reaches it
		if not _cliff_done and pp.distance_to(EDGE) < 3.5 and not main.ui.busy and not main.loading:
			_cliff_scene()
	# the camp, on the way in from the car
	if f.has("obs_parked") and not f.has("obs_camp_seen") and pp.z < GATE.z - 4.0 and not main.ui.busy:
		_camp_seen()
	_tick_serpent(delta)
	_tick_children(delta)
	_tick_guards(delta)
	_tick_movers(delta)
	_tick_lynx(delta, pp)
	if eye.visible:
		eye.scale = Vector3(1.0 + sin(_t * 1.3) * 0.04, eye.scale.y, 1)


## The serpent rolls and slithers over the circle; with the frames off, a
## shape of smoke does the same thing without the plates.
func _tick_serpent(delta: float) -> void:
	if not _serpent_on:
		return
	var on: bool = main.frames_on
	serpent.visible = on
	smoke.visible = not on
	var n := plates.size()
	var head_a := _t * 1.1
	var ring: float = _serpent_ring
	var pts := []
	for i in n:
		var s := float(i) / float(n)
		var a := lerpf(head_a - s * 2.6, -s * TAU, ring)
		var r := lerpf(4.2 + sin(_t * 0.7 + s * 4.0) * 1.5, 3.4, ring)
		var y := lerpf(6.8 + sin(_t * 2.2 + s * 7.0) * 2.0 + s * 1.0, 7.0, ring)
		pts.append(Vector3(cos(a) * r, y, sin(a) * r) * _serpent_scale)
	for i in n:
		var pl: Node3D = plates[i]
		pl.position = pts[i]
		var nxt: Vector3 = pts[i + 1] if i + 1 < n else pts[i] + (pts[i] - pts[i - 1])
		if pl.position.distance_to(nxt) > 0.001:
			pl.look_at(serpent.global_position + nxt, Vector3.UP)
		pl.scale = Vector3.ONE * 1.8 * maxf(0.01, _serpent_scale)
		pl.rotation.z = sin(_t * 3.0 + i * 0.4) * 0.6
	for i in puffs.size():
		var pf: MeshInstance3D = puffs[i]
		var j := int(float(i) / float(puffs.size()) * n)
		pf.position = pts[j] + Vector3(sin(_t + i) * 0.3, 0.3, cos(_t * 0.8 + i) * 0.3)
		pf.scale = Vector3.ONE * (1.8 + sin(_t * 1.5 + i) * 0.5) * maxf(0.01, _serpent_scale)


## The children sway at what is over them and look up at it (or at the
## eye, or at nothing), and Mira stands very still. Ezra mouths the words.
func _tick_children(_delta: float) -> void:
	var look_at := serpent.global_position + (plates[0] as Node3D).position if _serpent_on else (eye.global_position if eye.visible else CIRCLE + Vector3(0, 30, 0))
	for ch in children:
		var n: Node3D = ch["node"]
		if _sprint or _chosen:
			continue
		var body: Node3D = n.get_meta("body")
		body.rotation.z = sin(_t * 1.3 + float(ch["phase"])) * 0.12
		body.rotation.x = -0.1 + sin(_t * 0.7 + float(ch["phase"])) * 0.05
		Anim.look(n, look_at, 1.0, 0.06)
	if mira:
		Anim.look(mira, look_at, 0.9, 0.04)
		var mb: Node3D = mira.get_meta("body")
		mb.scale.y = 1.0 + sin(_t * 1.1) * 0.008
	if ezra and not main.flags.has("ezra_home"):
		Anim.look(ezra, look_at, 0.9, 0.04)
		var eh: Node3D = ezra.get_meta("head")
		eh.rotation.x += sin(_t * 5.0) * 0.004  # mouthing
	if eren and not _chosen:
		Anim.idle(eren, _t, 0.0)


## Eren's men close on Carl during the sprint; otherwise they stand.
func _tick_guards(delta: float) -> void:
	var p = main.player
	for g in guards:
		var n: Node3D = g
		if _sprint:
			var d: Vector3 = p.global_position - n.position
			d.y = 0.0
			if d.length() < 1.1:
				_caught = true
			elif p.global_position.y < -1.0:
				n.position += d.normalized() * minf(2.4 * delta, d.length())
				n.rotation.y = lerp_angle(n.rotation.y, atan2(-d.x, -d.z), minf(1.0, delta * 8.0))
				Anim.walk(n, _t, 1.2, 0.0, 1.0)
		elif not _chosen:
			Anim.idle(n, _t, float(n.get_meta("base").x))
	for d in dogs:
		var dn: Node3D = d
		dn.position.y = LOWER_Y + sin(_t * 1.7 + dn.position.x) * 0.01


func _tick_lynx(delta: float, pp: Vector3) -> void:
	if not lynx:
		return
	var p = main.player
	match lynx_state:
		"seat":
			Anim.look(lynx, pp + Vector3(0, 1.3, 0), 0.6, 0.05)
		"follow":
			var target: Vector3 = pp + Basis(Vector3.UP, p.yaw) * Vector3(-1.3, 0, -0.7)
			target.y = pp.y
			if pp.z < -40.0:
				target.z = maxf(target.z, -97.0)
			var d := target - lynx.position
			d.y = 0.0
			var dist := d.length()
			if dist > 0.5:
				var speed := clampf(dist * 2.2, 1.2, 5.4)
				lynx.position += d.normalized() * minf(speed * delta, dist)
				lynx.position.y = lerpf(lynx.position.y, target.y - 0.1, minf(1.0, delta * 6.0))
				lynx.rotation.y = lerp_angle(lynx.rotation.y, atan2(-d.x, -d.z), minf(1.0, delta * 8.0))
				Anim.walk(lynx, _t, 1.1 * speed / 2.6, 0.0, 1.0)
			else:
				Anim.idle(lynx, _t, 1.0)
				lynx.rotation.y = lerp_angle(lynx.rotation.y, p.yaw, minf(1.0, delta * 2.0))
				Anim.look(lynx, pp + Vector3(0, 1.6, 0), 0.5, 0.04)
		"stand":
			var moving := false
			for mv in movers:
				if mv["fig"] == lynx:
					moving = true
			if moving:
				return
			var d := lynx_target - lynx.position
			d.y = 0.0
			if d.length() > 0.3:
				lynx.position += d.normalized() * minf(3.0 * delta, d.length())
				lynx.rotation.y = lerp_angle(lynx.rotation.y, atan2(-d.x, -d.z), minf(1.0, delta * 8.0))
				Anim.walk(lynx, _t, 1.1, 0.0, 1.0)
			else:
				Anim.idle(lynx, _t, 1.0)
				Anim.look(lynx, CIRCLE + Vector3(0, 2.0, 0), 0.9, 0.05)
		"crouch":
			Anim.crouch(lynx)
			lynx.position.y = lerpf(lynx.position.y, -0.45, minf(1.0, delta * 3.0))
			Anim.look(lynx, CIRCLE + Vector3(0, 3.0, 0), 0.9, 0.05)


func objective() -> String:
	var f: Dictionary = main.flags
	if _ended:
		return ""
	if _sprint:
		return LINES["objective"]["sprint"]
	if _cliff_done:
		return ""
	if f.has("obs_song"):
		return LINES["objective"]["song"] if str(f.get("obs_follow", "")) == "song" else LINES["objective"]["candles"]
	if f.has("obs_camp_seen"):
		return LINES["objective"]["tents"]
	if _arrived:
		return LINES["objective"]["camp"]
	return LINES["objective"]["drive"]


func phone() -> String:
	var t: String = LINES["phone"]["text1"]
	if main.flags.has("obs_song"):
		t += LINES["phone"]["text2"]
	if _cliff_done:
		t += LINES["phone"]["text3"]
	return t


func scan_people() -> Array:
	var out := []
	if lynx:
		out.append([lynx, LINES["signs"]["lynx_scan"]])
	return out


func apply_args(a: Dictionary) -> void:
	if a.has("carz"):
		car.position.z = float(a["carz"])
		car.position.y = _road_y(car.position.z)
		main.player.position = car.position + SEAT
		main.player.seated = true
		main.player.crouch = 0.5
		return
	if a.has("walk") or a.has("at"):
		car.position = Vector3(0, 0, PARK_Z)
		(car.get_meta("shell") as Node3D).visible = true
		set_active(my_car_it, true)
		for h in headlights:
			(h as SpotLight3D).light_energy = 0.0
		_arrived = true
		main.flags["obs_parked"] = true
		main.flags["obs_camp_seen"] = true
		if lynx:
			lynx_state = "follow"
			_stand_up(lynx)
			lynx.position = main.player.position + Vector3(1.5, 0, 0)
		if a.has("song"):
			main.flags["obs_song"] = true
			main.flags["obs_follow"] = "song"
			if brush_gate:
				brush_gate.queue_free()
				brush_gate = null
		if a.has("cliff"):
			main.flags["obs_song"] = true
			_cliff_done = true
			_serpent_on = true
			if lynx:
				lynx_state = "crouch"
				lynx.position = EDGE + Vector3(-1.6, 0, 0.8)
		if a.has("eye"):
			main.flags["obs_song"] = true
			_cliff_done = true
			eye.visible = true
			eye.position = CIRCLE + Vector3(0, 24.0, 0)
			eren.position = CIRCLE + Vector3(0, 0, -3.2)
			men[0].position = CIRCLE + Vector3(-1.4, 0, -1.8)
			men[1].position = CIRCLE + Vector3(1.4, 0, -1.8)
			for c in get_children():
				if c is OmniLight3D and c.has_meta("eye_light"):
					c.visible = true
					c.light_energy = 2.4
		if not a.has("at"):
			main.player.position = car.position + Vector3(-1.9, 0.1, 0.5)
		return
	main.player.seated = true
	main.player.crouch = 0.5


func _node_by_id(id: String) -> Node:
	for n in main._all_with_meta(self, "id"):
		if is_instance_valid(n) and str(n.get_meta("id")) == id:
			return n
	return null


## Headless: the drive, the camp, the three tents, the
## song, the cliff (the pump picks 1: the candles, frames kept off, Watch),
## then Charge, Walk down singing and Lynx's "Let me" for coverage, then
## every interactable twice. Every wait in here has a deadline.
func selftest() -> void:
	# Headless on llvmpipe this hill renders at well under 1 fps, and every
	# line of dialogue costs a frame: the run looked hung at the edge. The
	# test is of the script, so the level is hidden while it runs (it still
	# ticks, collides and plays); it is shown again at the end.
	visible = false
	# Main does not call intro() in a headless run, so the drive runs here
	if not _drive_started:
		await _drive()
	var t := 0.0
	while not main.flags.has("obs_parked") and t < 240.0:
		await get_tree().process_frame
		t += get_process_delta_time()
	if not main.flags.has("obs_parked"):
		print("WARN drive timed out at z=", car.position.z)
		_driving = false
		await _get_out()
		main.flags["obs_parked"] = true
	print("ok drive")
	if not main.flags.has("obs_camp_seen"):
		await _camp_seen()
	for id in ["gate_reader", "drone", "dome", "kiosk", "shuttle", "firepit", "telescope", "tent_other", "tent_ezra", "tent_mira", "brush", "candle", "edge"]:
		var n := _node_by_id(id)
		if n:
			await main.interact(n)
			print("ok ", id)
		else:
			print("MISSING ", id)
	print("cliff=", _cliff_done, " chosen=", _chosen, " watched=", main.flags.has("watched_observatory"), " done=", main.flags.has("observatory_done"))
	# the other two ways, for the script's sake
	_ended = false
	await _charge()
	print("ok charge pressure=", main.pressure, " charged=", main.flags.has("charged_observatory"))
	_ended = false
	_reset_ridge()
	await _sing()
	print("ok sing sang=", main.flags.has("sang_observatory"))
	# Lynx's way: she is built here if the run did not bring her
	if not lynx:
		main.trust["lynx"] = 2
		_lynx()
		_stand_up(lynx)
		lynx.position = EDGE + Vector3(-1.6, 0, 0.8)
	main.flags.erase("ezra_home")
	_reset_ridge()
	await _lynx_takes_ezra()
	print("ok lynx ezra_home=", main.flags.has("ezra_home"))
	main.flags.erase("cinematic")
	await main.selftest_all_interactables()
	visible = true


## Back to the ridge between the selftest's runs of the choice.
func _reset_ridge() -> void:
	var p = main.player
	p.position = EDGE + Vector3(0, 0.1, 0)
	p.velocity = Vector3.ZERO
	p.crouch = 0.0
	main.ui.fade_to(0.0, 0.1)
