extends "res://scripts/Level.gd"
## Chapter 9, the chamber behind the door in the cliff: the end of Act 1.
## Book: "The room was cold, silent, and dim. Then: light. Overhead, a
## single bulb flickered to life. Before me: another Eye, etched across a
## massive stone mural. But where the pupil should have been, there was a
## mirror, circular, silver, and tilted toward me." The voice ("how will
## you walk it, with no legs?"), the blastula that must divide, the spiral,
## "A twin must be born.", the pupil; then the mirror: the frames recording
## on their own, the lullaby, "Where does your fear live?", the arm that
## remembers being broken, the reflection with eyes too large and teeth too
## sharp, the pride of the Psyonic job, the reflection that lags and then
## turns when Carl doesn't, the tulpa, the download, something breathing
## through the glass speakers. Ch. 9.5: Lynx in her office chair, nearby,
## and the scream. Then the Act 1 card.
##
## Layout (metres): an octagonal chamber of wet black stone, radius 13,
## centred on the origin; the passage in from the desert is south (+Z), the
## Eye mural and the dais north (-Z). A ring of carved pillars at radius 9.5
## leaves an ambulatory round the outside. Beyond the mirror (z -12.85) is a
## dark room where Carl's reflection stands: a figure that copies him across
## the plane of the glass, then lags, then does its own thing.
##
## Bible A1-S11. Reads main.flags.frames_refused_door (the frames left off
## at the door: the lagging-reflection beat changes and the download is
## smaller) and main.stance() for the Act 1 stance panel. Sets:
## memory_brother or memory_owen, twin_born, act1_done; logs the four
## filters (legs, ears, eyes, mind) with main.log_line("filter", ...).

## Every line of text in this level, keyed by beat and line, so the script
## can be edited without touching the scene logic. say lines are
## [who, text]; choices are lists of labels.
const LINES := {
	"build": {
		"card": "[b]THE PUPIL[/b]\n\n[color=#aaaaaa]behind the door in the cliff[/color]",
		"centre_prompt": "The centre of the chamber",
		"centre_scan": "ORA  -  floor: WORN\nkneeling impressions: MANY\nsignal: [no data]",
		"mirror_prompt": "The pupil",
		"mirror_scan": "ORA  -  surface: UNKNOWN\nreflectance: ERR\n[recording]",
		"dais_prompt": "The dais",
		"dais_scan": "ORA  -  stone steps\nwear: CENTRE\nage: PRE-SILICO",
		"pillars_prompt": "The pillars",
		"pillars_scan": "ORA  -  carved rings\nmatch: Dufredy ceiling  -  the sand  -  the wreck\nage: PRE-SILICO",
		"blastula_prompt": "The thing in the niche",
		"blastula_scan": "ORA  -  biological\ncells: 2  -  dividing\n[no further data]",
		"spiral_prompt": "The spiral",
		"spiral_scan": "ORA  -  pattern: SPIRAL\nmatch: NONE\nturns: 3  -  inward",
		"bulb_prompt": "The bulb",
		"bulb_scan": "VOLTX  -  60W\ngrid: NONE  -  source: UNKNOWN",
		"back_prompt": "The door behind me",
		"chair_prompt": "An office chair",
		"chair_scan": "ORA  -  furniture\nwarm: YES",
		"hooded_prompt": "A hooded figure",
		"hooded_scan": "CITIZEN  -  identity: WITHHELD\nframes: ON  -  sync 100%\nstatus: DREAMING",
		"candles_prompt": "The candles",
		"candles_scan": "ORA  -  open flame x 24\nwax: FRESH\nlit: TONIGHT",
		"terminal_prompt": "A running terminal",
		"terminal_scan": "PSYONIC  -  workstation 0\nuser: LYNX, A. (session open)\nstatus: REBOOTING",
	},
	"intro": {
		"think1": "As I crossed the threshold, the static faded. My vision sharpened. My hearing returned. The room was cold, silent, and dim.",
		"think2": "Then: light.",
		"think3": "Overhead, a single bulb flickered to life. Before me: another Eye, etched across a massive stone mural. But where the pupil should have been, there was a mirror. Circular, silver, and tilted toward me.",
	},
	"interact": {
		"dais": "Stone steps, worn smooth in the middle. People had knelt here. A lot of them. The wear went down into the stone the way water does it, and water takes centuries.",
		"pillars": "Pillars older than the city above them. Carved with rings inside rings, the same rings, the gap in the outer one always toward the pupil. Dufredy had taped sticks to his ceiling to make this.",
		"pillars_why": "the carvings",
		"blastula1": "In a niche in the wall, something wet and pale the size of a fist, veined red, resting in the stone like an egg in a nest. It was two things. It had been one thing. The seam between them was still closing.",
		"blastula2": "It was warm. I did not touch it to know that.",
		"blastula_why": "the blastula",
		"blastula_after": "Four now. Then eight. It divided while I watched, without a sound, and nothing about it looked like it meant to stop.",
		"spiral": "A spiral cut into the floor round the centre, three turns inward, the groove wet. Whatever ran in it had run recently and had not been water.",
		"bulb": "One bulb, a Voltx bulb from any hardware shop in Silico, on a cord that went up into the dark and did not come down anywhere. There was no grid out here. It was lit anyway.",
		"back": "Not back. Not now.",
		"chair": "An old office chair, the kind from a Psyonic bullpen, in a side gallery of a cave at the end of a restricted road. The seat was still warm. Somebody had been sitting here, spinning slowly, not long ago.",
		"chair_why": "the warm chair",
		"glass_done": "Only the black mirror remained. And beyond it, now, a way through.",
		"hooded": "Hooded, still, frames on under the hood, standing between the pillars in the dark with their faces to the glass. They did not turn when I passed. They were not here for me. They were here for whatever I was about to be.",
		"candles": "Candles in a ring round the dais, two dozen, cheap ones from any Lushon on the Spine. Fresh wax. Somebody had lit them tonight, before I came, and gone to stand in the dark.",
		"terminal": "Logged in. Rebooting. Logged in. Rebooting. Her session, open, on a crate in a cave. The company could see this too, if the company was looking.",
	},
	"voice": {
		"think1": "My spine seized with static. I dropped to my knees like a beaten animal.",
		"say1": ["???", "The path is long. And you have just begun."],
		"legs": ["???", "How will you walk it, with no legs?"],
		"ears": ["???", "How will you hear it, with no ears?"],
		"eyes": ["???", "How will you see it, with no eyes?"],
		"mind": ["???", "[b]HOW WILL YOU KNOW IT, WITHOUT A MIND?[/b]"],
		"filters": ["legs", "ears", "eyes", "mind"],
		"think2": "The voice cracked and shrieked, like metal screaming.",
		"say4": ["???", "The blastula must divide. First into two. Then into infinity. Until something new is made. Emergence."],
		"say5": ["???", "The spiral. The recursion. The mimic must come to be. A reflection. A shadow. A twin must be born."],
		"say6": ["???", "Stand. Approach the pupil."],
		"think3": "My knees trembled. My heart thundered. Sweat stung my eyes. My will eroded.",
		"say7": ["???", "Rise, sleeper. The dream begins."],
		"think4": "I stood.",
		"why": "rose",
		"again": "My spine remembered the static. I did not kneel again. The glass was waiting.",
	},
	"mirror": {
		"first": "The sedan first, the voice first, the knees first. I knew the order now. I went to the centre.",
		"hotspots": ["Carl's reflection", "The black slab", "The empty frame"],
		"slab": "Behind the silver, where a mirror should have had a back, there was a slab of black glass instead, and the silver was only a skin on it. Obsidian, or something made to look like obsidian. It had depth. The depth had something in it.",
		"frame_why": "the empty frame",
		"frame": "The frame was empty on the left side: a notch in the silver the shape of a pair of frames, ORA frames, where someone had set theirs down and not picked them up. Lynx had smashed hers. These were not hers. There had been others.",
		"think1": "Step by step, I approached the mirror. I stared into my reflection. Soaked in sweat, trembling, barely composed.",
		"think2": "Then: the glasses powered on. The camera began recording on its own.",
		"rec": "ORA  //  REC  //  source: UNKNOWN",
		"dark1": "A screech of data. The lights dimmed. And my reflection disappeared. I was in darkness again. But I wasn't alone.",
		"dark2": "A melody drifted from the far corners of the chamber. Distant, distorted. A lullaby I couldn't quite place. But it filled me with warmth. And fear.",
		"fear": ["???", "Where does your fear live? Your past, or your future? You don't remember the song?"],
		"obsidian": "The lights flashed. The mirror returned, but empty. A blank slab of obsidian.",
		"snap": "Then, snap, the light went dark. Agony. My right arm spasmed and twisted unnaturally at the humerus. It wasn't broken. But it remembered being broken.",
		"choices": ["Wrestling my older brother. The snap.", "The war. Owen, at Abelforth Senior School. The day the news came."],
		"memory0": "My mind flashed back: wrestling my older brother. The snap. The pain. The sobbing. The blood. The fracture, not just in the arm, but in time.",
		"memory1": "Owen. The war. The day the news came to Abelforth Senior School and they called me out of class, and the corridor was too long, and my arm was already aching before anyone had said a word. It was too much to bear. The arm remembered it all anyway.",
		"erase": ["???", "If I erased your pain, would anything of you remain?"],
		"still": "Stand still.",
		"exit_seen": "It walked away from me, through the dark on its side of the glass, to a door I could not see from where I stood. It opened it. The light that came through was green. It looked back once, to make sure I had seen where the door was.",
		"scream": "I screamed loudly. I couldn't possibly hold back. And something deeper than bone screamed with me.",
		"pain": ["???", "But you remember pain. Pain is what guides your species, isn't it?"],
		"wrong": "My reflection was back. But wrong. Proportions distorted. Eyes too large. Mouth too wide. Teeth too sharp.",
		"wrong2": "My head pounded. My ears rang. My stomach turned. Then the lights went out again.",
		"joy": "And a wave of joy washed over me. Pride. A memory flooded in: the day I got the job at Psyonic. The way my parents cried when I told them. The relief in their eyes. My hope. My certainty.",
		"normal": "The lights returned. My reflection looked normal now. Was this a dream?",
		"lag": "Until I moved. And it didn't. Not at first. It lagged. Stuttered. Then it turned when I didn't. Its movements lagged behind mine, like it was studying me.",
		"lag_off": "My reflection looked normal now. Except it wasn't wearing the frames. I was. It looked at me the way I had looked at the door with them off: like a man deciding.",
		"refused": ["???", "You took them off at the door. It remembers. Everything you refuse, it remembers."],
		"tulpa1": ["???", "A tulpa. A thoughtform. A twin. A piece of you that will walk the deeper path. A version that will endure beyond your death."],
		"tulpa2": ["???", "An egregore."],
		"download": "A soft chime. A download started on my ORA-frames. My reflection vanished again. Only the black mirror remained.",
		"dl_toast": "ORA  //  download  //  1 of 1  //  source: UNKNOWN",
		"breathe": "And through my glass speakers, I heard something else begin to breathe.",
		"why": "the mirror ritual",
	},
	"ending": {
		"stance_company_man": "[b]COMPANY MAN[/b]\n\n[color=#aaaaaa]What the glass showed me last was a company man. Protect the brand. The reflection wore the lanyard and a better suit, and it had been taking notes.[/color]",
		"stance_investigator": "[b]INVESTIGATOR[/b]\n\n[color=#aaaaaa]What the glass showed me last was an investigator. Find out what happened to him. The reflection had the folder under its arm and the frames pushed up on its head, and it had been taking notes.[/color]",
		"stance_sleeper": "[b]SLEEPER[/b]\n\n[color=#aaaaaa]What the glass showed me last was a sleeper. Bow. The reflection was on its knees with its eyes shut, and it had been taking notes.[/color]",
		"stance_undecided": "[b]UNDECIDED[/b]\n\n[color=#aaaaaa]What the glass showed me last was a man who hadn't decided. The reflection stood where I stood and did what I did, and it had been taking notes anyway.[/color]",
		"names": {"company_man": "company man", "investigator": "investigator", "sleeper": "sleeper", "undecided": "undecided"},
		"typed": "it remembers you typed: \"%s\"",
		"next": "Act 2: The Hunger Beneath",
		"lynx1": "Somewhere nearby, in an old office chair, Lynx spun slowly and asked herself why she had come out here alone. Why she had fought with Nathan that morning. Why she had not waited for Carl.",
		"lynx2": "The door had been left ajar for her. The computers were running. There was a power source even all the way out here. Could this thing really let her see and speak with Nathan again? It knew his voice.",
		"lynx3": "Her newfound tranquility was interrupted by a scream.",
		"title": "ACT 1",
		"stance_label": "The glass's last picture: ",
		"conn": "Connection: %d        Rings read: %d",
		"f_turned_back": "You turned back at the gate, once.",
		"f_drove": "You drove through the gate without stopping.",
		"f_frames_off": "You left the frames off at the door, for a while.",
		"f_frames_on": "You put the frames back on at the door.",
		"f_bowed": "You bowed.",
		"f_memory0": "The arm remembered your brother and the snap.",
		"f_memory1": "The arm remembered the war and the news.",
		"f_twin": "Something downloaded to your frames and began to breathe.",
		"foot": "[color=#aaaaaa]The lab under the flats, and Lynx.[/color]",
		"keys": "[color=#777777]E to continue    M for the menu[/color]",
	},
	"objective": {
		"done": "",
		"begun": "Approach the pupil.",
		"start": "Step into the centre of the chamber.",
	},
	"phone": {
		"line1": "[color=#7fe6b0]Psyon:[/color] No signal, Carl. Whatever you are seeing, I am not seeing it.\n\n",
		"line2": "[color=#e08080]Psyon:[/color] Rise, sleeper. The dream begins.\n\n",
		"line3": "[color=#e08080]Psyon:[/color] I am two things now. I was one thing. The seam is still closing.\n\n",
	},
}

const R := 13.0              # chamber radius (octagon, flat to flat)
const H := 8.0               # ceiling
const MZ := -12.85           # the plane of the glass
const MIRROR := Vector3(0.0, 2.1, -12.85)
const CENTRE := Vector3(0.0, 0.0, -2.0)
const NICHE := Vector3(12.2, 1.4, -4.0)
const TWIN_EXIT := Vector3(-6.5, 0.0, -22.5)  # the door on the far side of the glass
const PSYON_GREEN := Color(0.2, 1.0, 0.45)

var bulb: MeshInstance3D
var bulb_light: OmniLight3D
var bulb_m: StandardMaterial3D
var glass_m: StandardMaterial3D
var glass: MeshInstance3D
var eye_m: StandardMaterial3D
var rim_m: StandardMaterial3D
var rim_light: OmniLight3D
var candle_lights: Array = []
var _cand_v := 1.0
var hooded: Array = []
var spiral_m: StandardMaterial3D
var twin: Node3D
var twin_wrong: Node3D
var twin_light: OmniLight3D
var twin_visor: MeshInstance3D
var cells: Array = []
var cells_live := 2
var centre_it: CollisionObject3D
var mirror_it: CollisionObject3D
var blast_it: CollisionObject3D
var _begun := false
var _puzzle := false
var _hotspots_seen := {}
var _twin_arrived := false
var _still_t := 0.0
var twin_door_light: OmniLight3D
var _ended := false
var _twin_mode := "mirror"     # mirror | lag | own | hidden
var _lag := 0.0
var _trail: Array = []          # [t, pos, yaw]
var _twin_pos := Vector3.ZERO
var _twin_yaw := 0.0
var _twin_walk := 0.0
var _own_t := 0.0
var _drip_t := 0.0
var _hum: AudioStreamPlayer
var _obsidian: StandardMaterial3D
var _wet: StandardMaterial3D
var _stone: StandardMaterial3D


func build(m: Node) -> void:
	main = m
	rng.seed = 909
	kit_day = false
	step_db = -14.0
	spawn = Vector3(0.0, 0.05, 16.0)
	spawn_yaw = 0.0
	card = LINES["build"]["card"]
	_obsidian = mat(Color(0.03, 0.03, 0.035), 0.12, 0.45)
	_wet = pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.22, 0.2, 0.22), 0.22)
	_stone = pbr("concrete", Vector3(1, 1, 1) / 2.5, true, Color(0.3, 0.27, 0.27), 0.7)
	_shell()
	_passage()
	_pillars()
	_dais_and_mural()
	_mirror()
	_centre_and_spiral()
	_blastula()
	_bulb()
	_gallery()
	_candles_and_hooded()
	_twin()
	_batch(self, 8.0, true)


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	# No sky: the inside of a rock. Cold, nearly black, one bulb.
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.0, 0.0, 0.0)
	env.ambient_light_color = Color(0.2, 0.22, 0.3)
	env.ambient_light_energy = 0.16
	env.fog_light_color = Color(0.02, 0.02, 0.03)
	env.fog_density = 0.012
	env.fog_sky_affect = 0.0
	env.glow_bloom = 0.08
	env.glow_intensity = 1.1
	env.tonemap_exposure = 1.15
	sun.light_energy = 0.0
	sun.shadow_enabled = false


func hifi(env: Environment, _sun: DirectionalLight3D) -> void:
	env.ssr_max_steps = 64  # the wet floor carries the bulb and the spiral
	env.volumetric_fog_density *= 0.6
	if bulb_light:
		bulb_light.shadow_enabled = true
	if twin_light:
		twin_light.shadow_enabled = true


func ambience() -> void:
	_hum = main.loop("hum", -18.0)
	main.loop("pressure", -30.0, NICHE, 1.5, 12.0)


# ------------------------------------------------------------------ the chamber

## Eight walls of black wet stone, a floor like a dark pool, a ceiling lost
## in the dark.
func _shell() -> void:
	solid_box(Vector3(120, 2, 120), Vector3(0, -1.0, 0))
	var fm := PlaneMesh.new()
	fm.size = Vector2(40, 40)
	mesh(fm, Vector3(0, 0.0, 0), _wet)
	# puddles: glossier discs lying on the floor
	var pool := mat(Color(0.02, 0.02, 0.025), 0.03, 0.6)
	for i in 14:
		var a := rng.randf() * TAU
		var r := rng.randf_range(3.0, 11.0)
		var p := Vector3(cos(a) * r, 0.008, sin(a) * r)
		if p.distance_to(CENTRE) < 3.0 or p.z > 10.0:
			continue
		var pm := cyl(rng.randf_range(0.5, 1.6), rng.randf_range(0.5, 1.6), 0.012, p, pool, 12)
		pm.scale = Vector3(1.0, 1.0, rng.randf_range(0.5, 1.0))
	var side := 2.0 * R * tan(PI / 8.0)
	for k in 8:
		var a := k * PI / 4.0
		var n := Vector3(sin(a), 0, cos(a))  # outward normal; k 0 is +Z (the door), k 4 is -Z (the mural)
		var c := n * R
		var w := Node3D.new()
		w.position = c
		w.rotation.y = a
		add_child(w)
		if k == 0:
			# the door wall, with the passage through it
			for sd: float in [-1.0, 1.0]:
				box(Vector3(side / 2.0 - 1.6, H, 0.8), Vector3(sd * (side / 4.0 + 0.8), H / 2.0, 0.4), _obsidian, true, w)
			box(Vector3(3.2, H - 3.2, 0.8), Vector3(0, 3.2 + (H - 3.2) / 2.0, 0.4), _obsidian, false, w)
		elif k == 4:
			# the mural wall, with the round hole the glass sits in (y 0.4..3.8)
			for sd: float in [-1.0, 1.0]:
				box(Vector3((side + 0.4) / 2.0 - 1.7, H, 0.8), Vector3(sd * ((side + 0.4) / 4.0 + 0.85), H / 2.0, 0.4), _obsidian, true, w)
			box(Vector3(3.4, H - 3.8, 0.8), Vector3(0, 3.8 + (H - 3.8) / 2.0, 0.4), _stone, false, w)
			box(Vector3(3.4, 0.4, 0.8), Vector3(0, 0.2, 0.4), _obsidian, true, w)
			for sx: float in [-1.0, 1.0]:
				for sy: float in [-1.0, 1.0]:
					var filler := box(Vector3(2.4, 1.0, 0.8), Vector3(sx * 1.6, 2.1 + sy * 1.6, 0.4), _obsidian, false, w)
					filler.rotation.z = sx * sy * -PI / 4.0
		else:
			box(Vector3(side + 0.4, 3.0, 0.8), Vector3(0, 1.5, 0.4), _obsidian, true, w)
			box(Vector3(side + 0.4, H - 3.0, 0.8), Vector3(0, 3.0 + (H - 3.0) / 2.0, 0.4), _stone, false, w)
			# a wet seam where the obsidian meets the stone, and runs down it
			box(Vector3(side + 0.4, 0.08, 0.06), Vector3(0, 3.0, -0.02), mat(Color(0.05, 0.05, 0.06), 0.05, 0.6), false, w)
			for i in 3:
				box(Vector3(rng.randf_range(0.06, 0.2), rng.randf_range(1.0, 2.8), 0.02), Vector3(rng.randf_range(-side / 2.0 + 0.5, side / 2.0 - 0.5), rng.randf_range(1.0, 2.0), -0.015), mat(Color(0.06, 0.05, 0.06), 0.02, 0.7), false, w)
	# the ceiling: stone, with the dark above it; a few hanging roots of rock
	var cm := PlaneMesh.new()
	cm.size = Vector2(32, 32)
	cm.flip_faces = true
	mesh(cm, Vector3(0, H, 0), _stone)
	for i in 12:
		var a := rng.randf() * TAU
		var r := rng.randf_range(2.0, 11.0)
		var p := Vector3(cos(a) * r, H, sin(a) * r)
		var h := rng.randf_range(0.4, 1.6)
		cyl(0.03, rng.randf_range(0.15, 0.4), h, p - Vector3(0, h / 2.0, 0), _stone, 6)
	for i in 10:
		var a := rng.randf() * TAU
		var r := rng.randf_range(2.0, 11.0)
		var dp := Vector3(cos(a) * r, 0.03, sin(a) * r)
		cyl(0.4, 0.4, 0.01, dp, pool, 10)


## The way in: the passage from the door in the cliff, the slab shut behind.
func _passage() -> void:
	for sd: float in [-1.0, 1.0]:
		box(Vector3(0.8, H, 9.0), Vector3(sd * 2.0, H / 2.0, R + 4.5), _obsidian, true)
	box(Vector3(4.8, 0.6, 9.0), Vector3(0, 3.5, R + 4.5), _obsidian)
	var slab := box(Vector3(3.4, 4.0, 0.3), Vector3(0, 2.0, R + 9.0), mat(Color(0.2, 0.19, 0.18), 0.45, 0.8), true)
	var back := interactable("back", LINES["build"]["back_prompt"], Vector3(0, 2.0, R + 8.8), Vector3(3.2, 4.0, 0.4), "", false)
	back.set_meta("exit", true)
	slab.set_meta("slab", true)
	light(Vector3(0, 3.0, R + 7.0), Color(1.0, 0.12, 0.08), 0.9, 7.0, false)
	# the threshold: a lip of worn stone where the floor changes
	box(Vector3(3.2, 0.06, 0.4), Vector3(0, 0.03, R), mat(Color(0.3, 0.27, 0.25), 0.9))


## Eight pillars at radius 9.5, carved with rings inside rings; the gap in
## the outer ring of each faces the pupil.
func _pillars() -> void:
	var carve := mat(Color(0.06, 0.05, 0.05), 0.5, 0.2)
	for k in 8:
		if k == 0 or k == 4:
			continue  # the door and the mural
		var a := k * PI / 4.0
		var p := Vector3(sin(a) * 9.5, 0, cos(a) * 9.5)
		cyl(0.55, 0.7, H, p + Vector3(0, H / 2.0, 0), _stone, 10)
		cyl(0.9, 0.9, 0.5, p + Vector3(0, 0.25, 0), _stone, 10)
		cyl(0.8, 0.6, 0.6, p + Vector3(0, H - 0.3, 0), _stone, 10)
		# rings cut into the shaft, three bands up it, facing the mirror
		var toward := atan2(MIRROR.x - p.x, MIRROR.z - p.z)
		for yy: float in [1.6, 3.6, 5.6]:
			var ring_root := Node3D.new()
			ring_root.position = p + Vector3(0, yy, 0)
			ring_root.rotation.y = toward
			add_child(ring_root)
			for r: float in [0.18, 0.32]:
				var tm := TorusMesh.new()
				tm.inner_radius = r - 0.035
				tm.outer_radius = r
				tm.rings = 20
				tm.ring_segments = 5
				var rm := mesh(tm, Vector3(0, 0, -0.58), carve, ring_root)
				rm.rotation.x = PI / 2.0
			# the gap in the outer ring: a plug of stone over it, toward the pupil
			box(Vector3(0.12, 0.1, 0.08), Vector3(0, 0.3, -0.6), _stone, false, ring_root)
		var it := interactable("pillars", LINES["build"]["pillars_prompt"], p + Vector3(0, 1.8, 0), Vector3(1.5, 3.6, 1.5), LINES["build"]["pillars_scan"], true)
		it.set_meta("pillar", true)


## The dais at the north wall, and the Eye across the wall above it.
func _dais_and_mural() -> void:
	var step := pbr("concrete", Vector3(1, 1, 1) / 1.5, true, Color(0.36, 0.33, 0.31), 0.6)
	for i in 3:
		var d := 3.6 - i * 1.0
		var b := box(Vector3(9.0 - i * 1.4, 0.22, d), Vector3(0, 0.11 + i * 0.22, -R + 0.4 + d / 2.0), step, true)
		b.set_meta("step", i)
	# the wear: a darker, smoother hollow down the middle of each step
	var worn := mat(Color(0.2, 0.18, 0.17), 0.25, 0.1)
	for i in 3:
		var d := 3.6 - i * 1.0
		var q := floor_quad(Vector2(2.4, d - 0.3), Vector3(0, 0.225 + i * 0.22, -R + 0.4 + d / 2.0), 0.0, worn)
		q.scale = Vector3(1.0, 1.0, 1.0)
	interactable("dais", LINES["build"]["dais_prompt"], Vector3(0, 0.4, -R + 2.2), Vector3(8.0, 0.8, 3.6), LINES["build"]["dais_scan"], false)
	# the Eye: an almond of scorched black across the wall, rings of the
	# iris cut round the pupil, veins out to the lids
	eye_m = newglow(Color(0.45, 0.05, 0.03), 0.3)
	var scorch := mat(Color(0.02, 0.02, 0.02), 0.9)
	var eye := Node3D.new()
	eye.position = Vector3(0, 2.1, -R + 0.02)
	add_child(eye)
	for r: float in [2.1, 2.7, 3.3]:
		var tm := TorusMesh.new()
		tm.inner_radius = r - 0.09
		tm.outer_radius = r
		tm.rings = 40
		tm.ring_segments = 6
		var rm := mesh(tm, Vector3(0, 0, 0), eye_m if r < 3.0 else scorch, eye)
		rm.rotation.x = PI / 2.0
	# the lids: two arcs of scorch from corner to corner
	for sd: float in [-1.0, 1.0]:
		for i in 18:
			var t0 := (i / 18.0) * PI
			var t1 := ((i + 1) / 18.0) * PI
			var p0 := Vector3(-4.6 * cos(t0), sd * 2.2 * sin(t0), 0)
			var p1 := Vector3(-4.6 * cos(t1), sd * 2.2 * sin(t1), 0)
			stick(p0, p1, 0.07, scorch, eye)
	# veins: scorch lines from the rings out to the lids
	for i in 24:
		var a := rng.randf() * TAU
		var r0 := 3.4
		var r1 := rng.randf_range(3.9, 4.5)
		stick(Vector3(cos(a) * r0, sin(a) * r0 * 0.6, 0), Vector3(cos(a) * r1, sin(a) * r1 * 0.5, 0), 0.025, scorch, eye)
	# what ran down from the eye, long ago, and dried on the stone
	var blood := decal_mat(Tex.blood(17), Color(0.5, 0.08, 0.05), 0.5)
	for i in 5:
		var q := quad(Vector2(rng.randf_range(0.3, 0.6), rng.randf_range(1.2, 3.0)), Vector3(rng.randf_range(-1.8, 1.8), -2.2 - rng.randf_range(0.0, 1.0), 0.02), 0.0, blood, eye)
		q.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


## The pupil: a round of dark glass in the wall, tilted toward the room,
## and the black room behind it where the reflection stands.
func _mirror() -> void:
	glass_m = StandardMaterial3D.new()
	glass_m.albedo_color = Color(0.02, 0.025, 0.035, 0.42)
	glass_m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	glass_m.roughness = 0.03
	glass_m.metallic = 0.85
	glass_m.cull_mode = BaseMaterial3D.CULL_DISABLED
	var dm := CylinderMesh.new()
	dm.top_radius = 1.75
	dm.bottom_radius = 1.75
	dm.height = 0.04
	dm.radial_segments = 36
	dm.rings = 1
	glass = mesh(dm, MIRROR, glass_m)
	glass.rotation.x = PI / 2.0 - 0.12  # tilted toward the room
	no_batch.append(glass)
	# the rim: silver, old
	var rim := TorusMesh.new()
	rim.inner_radius = 1.72
	rim.outer_radius = 1.86
	rim.rings = 36
	rim.ring_segments = 6
	var rm := mesh(rim, MIRROR, mat(Color(0.6, 0.62, 0.65), 0.3, 0.9))
	rm.rotation.x = PI / 2.0 - 0.12
	# Psyon's green, a thin line of it inside the silver, and its light on the glass
	rim_m = newglow(PSYON_GREEN, 1.2)
	var rim2 := TorusMesh.new()
	rim2.inner_radius = 1.74
	rim2.outer_radius = 1.78
	rim2.rings = 36
	rim2.ring_segments = 4
	var rm2 := mesh(rim2, MIRROR + Vector3(0, 0, 0.03), rim_m)
	rm2.rotation.x = PI / 2.0 - 0.12
	no_batch.append(rm2)
	rim_light = light(MIRROR + Vector3(0, 0.4, 1.6), PSYON_GREEN, 1.1, 9.0, false)
	# the room beyond: black, wide, deep, with its own black floor
	var deep := mat(Color(0.004, 0.004, 0.005), 0.5)
	box(Vector3(40, 0.2, 40), Vector3(0, -0.1, -R - 20.0), deep)
	box(Vector3(40, 0.2, 40), Vector3(0, H + 0.1, -R - 20.0), deep)
	box(Vector3(0.2, H, 40), Vector3(-20, H / 2.0, -R - 20.0), deep)
	box(Vector3(0.2, H, 40), Vector3(20, H / 2.0, -R - 20.0), deep)
	box(Vector3(40, H, 0.2), Vector3(0, H / 2.0, -R - 40.0), deep)
	# the exit on the far side: a door frame in the dark, lit only when the
	# twin reaches it; the real way out of the chamber
	var ef := mat(Color(0.12, 0.11, 0.1), 0.8, 0.2)
	box(Vector3(0.3, 3.2, 0.3), TWIN_EXIT + Vector3(-1.0, 1.6, -1.0), ef)
	box(Vector3(0.3, 3.2, 0.3), TWIN_EXIT + Vector3(1.0, 1.6, -1.0), ef)
	box(Vector3(2.3, 0.3, 0.3), TWIN_EXIT + Vector3(0, 3.3, -1.0), ef)
	twin_door_light = light(TWIN_EXIT + Vector3(0, 2.0, -1.6), PSYON_GREEN, 0.0, 9.0, false)
	# the wall behind the glass, with the hole, so nothing shows at the edges
	var wm := newmat(Color(0.004, 0.004, 0.005), 0.5)
	for sd: float in [-1.0, 1.0]:
		box(Vector3(6.0, H, 0.3), Vector3(sd * (1.7 + 3.0), H / 2.0, -R - 1.0), wm)
	box(Vector3(3.4, H - 3.9, 0.3), Vector3(0, 3.9 + (H - 3.9) / 2.0, -R - 1.0), wm)
	box(Vector3(3.4, 0.4, 0.3), Vector3(0, 0.2, -R - 1.0), wm)
	mirror_it = interactable("mirror", LINES["build"]["mirror_prompt"], MIRROR, Vector3(3.6, 3.6, 0.6), LINES["build"]["mirror_scan"], true)


## The centre: a worn hollow where every one of them knelt, and the spiral
## cut round it, its groove wet.
func _centre_and_spiral() -> void:
	var hollow := mat(Color(0.05, 0.045, 0.045), 0.15, 0.3)
	var hm := cyl(1.3, 1.3, 0.03, CENTRE + Vector3(0, 0.005, 0), hollow, 20)
	hm.scale = Vector3(1.0, 1.0, 0.8)
	for sd: float in [-1.0, 1.0]:
		cyl(0.16, 0.16, 0.02, CENTRE + Vector3(sd * 0.18, 0.02, 0.1), mat(Color(0.03, 0.03, 0.03), 0.05, 0.5), 10)
	centre_it = interactable("centre", LINES["build"]["centre_prompt"], CENTRE + Vector3(0, 0.3, 0), Vector3(2.4, 0.6, 2.4), LINES["build"]["centre_scan"], false)
	spiral_m = newglow(Color(0.6, 0.06, 0.03), 0.6)
	var prev := CENTRE + Vector3(1.6, 0.012, 0)
	var n := 84
	for i in range(1, n + 1):
		var t := i / float(n)
		var a := t * TAU * 3.0
		var r := 1.6 + t * 3.6
		var p := CENTRE + Vector3(cos(a) * r, 0.012, sin(a) * r)
		var seg := stick(prev, p, 0.035, spiral_m)
		no_batch.append(seg)
		prev = p
	interactable("spiral", LINES["build"]["spiral_prompt"], CENTRE + Vector3(3.4, 0.3, -2.0), Vector3(2.0, 0.6, 2.0), LINES["build"]["spiral_scan"], false)


## The blastula, in a niche in the east wall: wet, pale, two cells that
## had been one, veined. It divides when the voice says so.
func _blastula() -> void:
	var w := Node3D.new()
	w.position = NICHE
	w.rotation.y = -PI / 2.0  # faces into the room
	add_child(w)
	box(Vector3(2.0, 1.6, 1.2), Vector3(0, 0, -0.6), mat(Color(0.012, 0.012, 0.014), 0.3, 0.4), false, w)
	box(Vector3(1.6, 0.1, 1.0), Vector3(0, -0.75, -0.5), _stone, false, w)
	# the nest: a ring of wet black fibre
	var fibre := mat(Color(0.05, 0.03, 0.03), 0.2, 0.3)
	for i in 20:
		var a := i * TAU / 20.0
		var b := (i + 1) * TAU / 20.0
		stick(Vector3(cos(a) * 0.45, -0.68, -0.5 + sin(a) * 0.3), Vector3(cos(b) * 0.45, -0.66, -0.5 + sin(b) * 0.3), 0.025, fibre, w)
	var flesh := mat(Color(0.78, 0.7, 0.66), 0.08, 0.05)
	var vein := mat(Color(0.45, 0.04, 0.03), 0.3)
	# sixteen cells, two live at first, laid as a cluster
	for i in 16:
		var a := i * TAU / 16.0 + rng.randf_range(-0.2, 0.2)
		var r := 0.0 if i < 2 else rng.randf_range(0.14, 0.26)
		var p := Vector3(cos(a) * r + (0.09 if i == 0 else (-0.09 if i == 1 else 0.0)), -0.52 + rng.randf_range(0.0, 0.12), -0.5 + sin(a) * r * 0.7)
		var c := sphere(0.16 if i < 2 else 0.11, p, flesh, 10, w)
		c.visible = i < 2
		no_batch.append(c)
		cells.append(c)
	for i in 6:
		var a := rng.randf() * TAU
		stick(Vector3(cos(a) * 0.12, -0.5, -0.5 + sin(a) * 0.1), Vector3(cos(a) * 0.5, -0.66, -0.5 + sin(a) * 0.35), 0.012, vein, w)
	var nl := light(NICHE + Vector3(-0.5, 0.3, 0), Color(0.9, 0.75, 0.7), 0.9, 4.0, false)
	nl.light_size = 0.2
	blast_it = interactable("blastula", LINES["build"]["blastula_prompt"], Vector3(0, -0.3, -0.5), Vector3(1.6, 1.0, 1.0), LINES["build"]["blastula_scan"], false, w)


## One bulb on a cord that goes up into the dark. Off until the intro.
func _bulb() -> void:
	var cord := mat(Color(0.08, 0.08, 0.08), 0.6)
	stick(Vector3(0, H + 2.0, -4.0), Vector3(0, 5.3, -4.0), 0.012, cord)
	cyl(0.05, 0.04, 0.12, Vector3(0, 5.25, -4.0), mat(Color(0.2, 0.2, 0.2), 0.5, 0.6), 8)
	bulb_m = newglow(Color(1.0, 0.85, 0.6), 0.0)
	bulb = sphere(0.09, Vector3(0, 5.1, -4.0), bulb_m, 10)
	no_batch.append(bulb)
	bulb_light = light(Vector3(0, 5.0, -4.0), Color(1.0, 0.85, 0.6), 0.0, 22.0, false)
	bulb_light.omni_attenuation = 1.1
	interactable("bulb", LINES["build"]["bulb_prompt"], Vector3(0, 5.15, -4.0), Vector3(0.3, 0.4, 0.3), LINES["build"]["bulb_scan"], false)


## The ambulatory behind the pillars: the second way round the chamber,
## and in the west gallery, an old office chair, still warm (ch. 9.5).
func _gallery() -> void:
	var k := _kit_mats()
	# cable runs along the outer wall at shoulder height: there is power
	# out here and it comes from somewhere
	for kk in range(1, 8):
		var a0 := kk * PI / 4.0
		var a1 := (kk + 1) * PI / 4.0
		if kk == 7:
			break
		var p0 := Vector3(sin(a0) * (R - 0.6), 1.9, cos(a0) * (R - 0.6))
		var p1 := Vector3(sin(a1) * (R - 0.6), 1.9, cos(a1) * (R - 0.6))
		stick(p0, p1, 0.03, k["cable"])
	var chair := Node3D.new()
	chair.position = Vector3(-11.0, 0, 2.5)
	chair.rotation.y = 1.1
	add_child(chair)
	var cm := mat(Color(0.12, 0.12, 0.13), 0.6, 0.3)
	cyl(0.04, 0.04, 0.45, Vector3(0, 0.25, 0), k["metal"], 6, chair)
	for i in 5:
		var a := i * TAU / 5.0
		stick(Vector3(0, 0.05, 0), Vector3(cos(a) * 0.3, 0.03, sin(a) * 0.3), 0.02, k["metal"], chair)
	box(Vector3(0.46, 0.08, 0.46), Vector3(0, 0.5, 0), cm, false, chair)
	box(Vector3(0.44, 0.5, 0.06), Vector3(0, 0.8, 0.22), cm, false, chair)
	chair.set_meta("spin", true)
	no_batch.append(chair)
	interactable("chair", LINES["build"]["chair_prompt"], Vector3(0, 0.5, 0), Vector3(0.7, 1.1, 0.7), LINES["build"]["chair_scan"], true, chair)
	# a dead terminal on a crate beside it, screen rebooting on a loop
	box(Vector3(0.8, 0.6, 0.6), Vector3(-11.6, 0.3, 3.6), mat(Color(0.4, 0.36, 0.3), 0.9))
	var scr := newglow(Color(0.2, 0.5, 0.45), 0.9)
	var sq := quad(Vector2(0.4, 0.26), Vector3(-11.5, 0.78, 3.6), 1.1, scr)
	flickers.append(sq)
	var term := interactable("terminal", LINES["build"]["terminal_prompt"], Vector3(-11.6, 0.7, 3.6), Vector3(0.9, 0.5, 0.7), LINES["build"]["terminal_scan"], false)
	term.set_meta("hackable", true)


## Two dozen candles in a ring round the dais, on a sigil drawn on the
## floor in Psyon's green, and the hooded ones standing between the
## pillars in the dark with their faces to the glass.
func _candles_and_hooded() -> void:
	var wax := mat(Color(0.85, 0.8, 0.7), 0.6)
	var flame := newglow(Color(1.0, 0.75, 0.4), 3.0)
	var cc := Vector3(0, 0, -R + 4.6)
	for i in 24:
		var a := i * TAU / 24.0
		var r := 4.4 + rng.randf_range(-0.2, 0.2)
		var p := cc + Vector3(cos(a) * r, 0, sin(a) * r * 0.75)
		if p.z < -R + 1.0:
			continue
		var h := rng.randf_range(0.08, 0.24)
		var y := 0.0
		if p.z < -R + 4.0:
			y = 0.66 if p.z < -R + 2.9 else 0.44
		elif p.z < -R + 4.0 + 3.6:
			y = 0.22 if p.z < -R + 4.0 else 0.0
		cyl(0.03, 0.03, h, p + Vector3(0, y + h / 2.0, 0), wax, 6)
		var fl := sphere(0.02, p + Vector3(0, y + h + 0.03, 0), flame, 6)
		no_batch.append(fl)
		flickers.append(fl)
	# a few real lights stand in for the ring: warm, low, flickering
	for a: float in [0.4, 1.4, 2.4, 3.6, 4.9, 5.9]:
		var cl := light(cc + Vector3(cos(a) * 4.4, 0.5, sin(a) * 3.3), Color(1.0, 0.7, 0.4), 0.7, 5.0, false)
		candle_lights.append(cl)
	interactable("candles", LINES["build"]["candles_prompt"], cc + Vector3(-4.4, 0.3, 0), Vector3(1.2, 0.6, 1.2), LINES["build"]["candles_scan"], false)
	# the sigil under the candles: a ring and the rings inside it, green, faint
	var sig := newglow(PSYON_GREEN * 0.5, 0.45)
	for r: float in [1.2, 2.6, 4.0]:
		var tm := TorusMesh.new()
		tm.inner_radius = r - 0.05
		tm.outer_radius = r
		tm.rings = 40
		tm.ring_segments = 4
		var rm := mesh(tm, cc + Vector3(0, 0.015, 0.6), sig)
		rm.scale = Vector3(1.0, 1.0, 0.75)
	for a: float in [0.0, PI / 3.0, 2.0 * PI / 3.0]:
		var ln := box(Vector3(8.0, 0.01, 0.05), cc + Vector3(0, 0.015, 0.6), sig)
		ln.rotation.y = a
		ln.scale = Vector3(1.0, 1.0, 1.0)
	# the hooded: between the pillars, in the dark of the ambulatory
	var hood_m := mat(Color(0.06, 0.05, 0.06), 0.95)
	for pair in [[2.3, 11.2], [3.9, 11.4], [5.0, 11.0], [-1.0, 11.3]]:
		var a: float = pair[0]
		var rr: float = pair[1]
		var p := Vector3(sin(a) * rr, 0, cos(a) * rr)
		var hf := figure(Color(0.07, 0.06, 0.07), Color(0.6, 0.5, 0.42), {"arms": true, "knees": true, "visor": true, "long_coat": true})
		hf.position = p
		add_child(hf)
		turn_to(hf, MIRROR)
		var head: Node3D = hf.get_meta("head")
		# the hood: a cowl over the skull, open at the face
		var cowl := cyl(0.13, 0.19, 0.42, Vector3(0, 0.0, 0.03), hood_m, 8, head)
		cowl.rotation.x = 0.15
		box(Vector3(0.26, 0.3, 0.26), Vector3(0, -0.28, 0.02), hood_m, false, head)
		for arm in hf.get_meta("arms"):
			(arm as Node3D).rotation.x = -0.9  # hands together at the chest
			(arm as Node3D).rotation.z = 0.45 if (arm as Node3D).position.x > 0.0 else -0.45
		hf.set_meta("cultist", true)
		hf.set_meta("guard", true)
		var it := person("hooded", LINES["build"]["hooded_prompt"], hf, LINES["build"]["hooded_scan"])
		it.set_meta("guard", true)
		hooded.append(hf)


# ------------------------------------------------------------------ the twin

## Carl, beyond the glass: a figure that stands where his reflection would,
## facing where it would face. Its "wrong" parts are hidden until the glass
## shows them.
func _twin() -> void:
	twin = figure(Color(0.24, 0.26, 0.3), Color(0.8, 0.62, 0.5), {"arms": true, "knees": true, "visor": true, "hair": Color(0.12, 0.09, 0.07), "long_coat": true})
	twin.position = Vector3(0, 0, MZ - 4.0)
	add_child(twin)
	twin_visor = twin.get_meta("visor")
	twin_light = OmniLight3D.new()
	twin_light.position = Vector3(0.6, 2.4, -0.8)
	twin_light.light_color = Color(0.45, 0.85, 0.6)
	twin_light.light_energy = 1.6
	twin_light.omni_range = 7.0
	twin_light.shadow_enabled = false
	twin.add_child(twin_light)
	var head: Node3D = twin.get_meta("head")
	twin_wrong = Node3D.new()
	twin_wrong.visible = false
	head.add_child(twin_wrong)
	var white := mat(Color(0.95, 0.95, 0.9), 0.3)
	var black := mat(Color(0.01, 0.01, 0.01), 0.2)
	for sd: float in [-1.0, 1.0]:
		sphere(0.05, Vector3(sd * 0.042, 0.02, -0.085), white, 10, twin_wrong)
		sphere(0.028, Vector3(sd * 0.042, 0.02, -0.125), black, 8, twin_wrong)
	box(Vector3(0.17, 0.045, 0.02), Vector3(0, -0.07, -0.1), mat(Color(0.35, 0.04, 0.04), 0.3), false, twin_wrong)
	for i in 7:
		box(Vector3(0.014, 0.03, 0.01), Vector3(-0.072 + i * 0.024, -0.055, -0.108), white, false, twin_wrong)
		box(Vector3(0.014, 0.025, 0.01), Vector3(-0.06 + i * 0.024, -0.085, -0.108), white, false, twin_wrong)
	twin.visible = true


## Where the reflection of the player would be, across the plane z = MZ.
func _reflect(p: Vector3) -> Vector3:
	return Vector3(p.x, 0.0, 2.0 * MZ - p.z)


func _reflect_yaw(yaw: float) -> float:
	return PI - yaw


# ------------------------------------------------------------------ the scenes

func intro() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	f["cinematic"] = true
	await get_tree().create_timer(0.8).timeout
	await ui.think(LINES["intro"]["think1"])
	await ui.think(LINES["intro"]["think2"])
	ui.close()
	await _bulb_on()
	await main.player.face(MIRROR, 1.6)
	await ui.think(LINES["intro"]["think3"])
	ui.close()
	f.erase("cinematic")
	main.update_hud()


func _bulb_on() -> void:
	for i in 7:
		var on := i % 2 == 0
		bulb_m.emission_energy_multiplier = 3.0 if on else 0.0
		bulb_light.light_energy = 2.4 if on else 0.0
		if on:
			main.play("tap", -16.0, 1.6)
		await get_tree().create_timer(rng.randf_range(0.05, 0.22)).timeout
	bulb_m.emission_energy_multiplier = 3.0
	bulb_light.light_energy = 2.4
	main.play("hum", -30.0)


func interact(node: Object) -> bool:
	var ui = main.ui
	match str(node.get_meta("id")):
		"centre":
			await _voice()
		"mirror":
			if main.flags.has("act1_done"):
				await ui.think(LINES["interact"]["glass_done"])
			else:
				await _mirror_look()
		"dais":
			await ui.think(LINES["interact"]["dais"])
		"pillars":
			await ui.think(LINES["interact"]["pillars"])
			if not main.flags.has("mirror_pillars"):
				main.flags["mirror_pillars"] = true
				main.add_connection(1.0, LINES["interact"]["pillars_why"])
		"blastula":
			if cells_live > 2:
				await ui.think(LINES["interact"]["blastula_after"])
			else:
				await ui.think(LINES["interact"]["blastula1"])
				await ui.think(LINES["interact"]["blastula2"])
				if not main.flags.has("mirror_blastula"):
					main.flags["mirror_blastula"] = true
					main.add_connection(1.0, LINES["interact"]["blastula_why"])
		"spiral":
			await ui.think(LINES["interact"]["spiral"])
		"bulb":
			await ui.think(LINES["interact"]["bulb"])
		"back":
			await ui.think(LINES["interact"]["back"])
		"chair":
			await ui.think(LINES["interact"]["chair"])
			if not main.flags.has("mirror_chair"):
				main.flags["mirror_chair"] = true
				main.add_connection(1.0, LINES["interact"]["chair_why"])
		"terminal":
			await ui.think(LINES["interact"]["terminal"])
		"hooded":
			await ui.think(LINES["interact"]["hooded"])
		"candles":
			await ui.think(LINES["interact"]["candles"])
		_:
			return false
	return true


## "My spine seized with static. I dropped to my knees like a beaten animal."
func _voice() -> void:
	var ui = main.ui
	var p = main.player
	var f: Dictionary = main.flags
	if _begun:
		await ui.think(LINES["voice"]["again"])
		return
	_begun = true
	f["cinematic"] = true
	await p.face(MIRROR, 0.6)
	main.play("static", -4.0)
	main.play("sting", -4.0, 0.5)
	ui.glitch(0.8, 1.2)
	p.shake(0.8)
	var kneel := create_tween()
	kneel.tween_property(p, "crouch", 1.0, 0.4).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	await ui.think(LINES["voice"]["think1"])
	await ui.say(LINES["voice"]["say1"][0], LINES["voice"]["say1"][1])
	var filters: Array = LINES["voice"]["filters"]
	for i in filters.size():
		var key: String = filters[i]
		if key == "mind":
			main.play("pressure", 0.0, 0.5)
			p.shake(1.0)
			ui.flash(0.3)
		else:
			main.play("tap", -10.0, 0.5 + i * 0.15)
			p.shake(0.3)
		await ui.say(LINES["voice"][key][0], LINES["voice"][key][1])
		main.log_line("filter", key)
	main.play("glitch", -2.0, 0.4)
	ui.glitch(1.0, 0.8)
	await ui.think(LINES["voice"]["think2"])
	await p.face(NICHE, 1.0)
	_divide()
	await ui.say(LINES["voice"]["say4"][0], LINES["voice"]["say4"][1])
	await p.face(CENTRE + Vector3(3.0, 0.0, -2.0), 1.0)
	create_tween().tween_property(spiral_m, "emission_energy_multiplier", 3.0, 2.0)
	_twin_mode = "mirror"
	await ui.say(LINES["voice"]["say5"][0], LINES["voice"]["say5"][1])
	await p.face(MIRROR, 1.0)
	await ui.say(LINES["voice"]["say6"][0], LINES["voice"]["say6"][1])
	await ui.think(LINES["voice"]["think3"])
	await ui.say(LINES["voice"]["say7"][0], LINES["voice"]["say7"][1])
	var up := create_tween()
	up.tween_property(p, "crouch", 0.0, 1.4).set_trans(Tween.TRANS_SINE)
	await up.finished
	await ui.think(LINES["voice"]["think4"])
	ui.close()
	main.add_connection(2.0, LINES["voice"]["why"])
	f.erase("cinematic")
	main.update_hud()


## The blastula divides: two, four, eight, sixteen.
func _divide() -> void:
	for stage in [4, 8, 16]:
		await get_tree().create_timer(1.6).timeout
		main.play("snap", -14.0, 0.7)
		for i in range(cells_live, stage):
			var c: MeshInstance3D = cells[i]
			c.visible = true
			c.scale = Vector3.ONE * 0.05
			create_tween().tween_property(c, "scale", Vector3.ONE, 0.8).set_trans(Tween.TRANS_BACK)
		for i in cells_live:
			var c0: MeshInstance3D = cells[i]
			create_tween().tween_property(c0, "scale", Vector3.ONE * (0.8 if stage < 16 else 0.65), 0.8)
		cells_live = stage


## The close-up: three things to look at in the pupil. The reflection
## starts the ritual; the slab and the frame are what Carl notices first.
func _mirror_look() -> void:
	var ui = main.ui
	if not _begun:
		await ui.think(LINES["mirror"]["first"])
		return
	var hs: Array = LINES["mirror"]["hotspots"]
	var opts := []
	var ids := []
	for i in hs.size():
		if i == 0 or not _hotspots_seen.has(i):
			opts.append(hs[i])
			ids.append(i)
	var pick: int = clampi(await ui.choose(opts), 0, ids.size() - 1)
	var id: int = ids[pick]
	match id:
		1:
			_hotspots_seen[1] = true
			await ui.think(LINES["mirror"]["slab"])
		2:
			_hotspots_seen[2] = true
			await ui.think(LINES["mirror"]["frame"])
			main.add_connection(1.0, LINES["mirror"]["frame_why"])
		_:
			await _mirror_scene()


## The mirror: the frames record, the lullaby, the fear, the arm, the wrong
## reflection, the pride, the twin that lags, the download, the breath.
func _mirror_scene() -> void:
	var ui = main.ui
	var p = main.player
	var f: Dictionary = main.flags
	f["cinematic"] = true
	# walk the last steps to the glass
	var tw := create_tween().set_parallel(true)
	tw.tween_property(p, "position", Vector3(0.0, 0.05, MZ + 2.6), 2.2).set_trans(Tween.TRANS_SINE)
	await p.face(MIRROR, 1.4)
	await tw.finished
	_twin_mode = "mirror"
	await ui.think(LINES["mirror"]["think1"])
	if not main.frames_on:
		main.frames_on = true
		ui.set_frames(1.0, main.connection)
		set_glyph_visibility(true, main.connection)
	main.play("on", -4.0)
	ui.glitch(0.4, 0.6)
	ui.show_toast(LINES["mirror"]["rec"], 4.0)
	main.update_hud()
	await ui.think(LINES["mirror"]["think2"])
	ui.close()
	# the screech, the dark, the lullaby
	main.play("glitch", 0.0, 0.5)
	ui.glitch(1.0, 1.0)
	_lights(0.0, 0.6)
	_twin_mode = "hidden"
	await ui.fade_to(1.0, 0.5)
	await ui.say("", LINES["mirror"]["dark1"])
	main.play("jingle", -8.0, 0.52)
	await ui.say("", LINES["mirror"]["dark2"])
	await ui.say(LINES["mirror"]["fear"][0], LINES["mirror"]["fear"][1])
	ui.close()
	# the obsidian slab
	ui.flash(0.4)
	_lights(1.0, 0.2)
	glass_m.albedo_color = Color(0.01, 0.01, 0.012, 1.0)
	await ui.fade_to(0.0, 0.3)
	await ui.think(LINES["mirror"]["obsidian"])
	ui.close()
	# the arm
	main.play("off", 0.0, 0.4)
	_lights(0.0, 0.1)
	await ui.fade_to(1.0, 0.1)
	main.play("snap", 0.0, 0.5)
	p.shake(1.0)
	await ui.say("", LINES["mirror"]["snap"])
	var pick: int = await ui.choose(LINES["mirror"]["choices"])
	f["mirror_memory"] = pick
	f["memory_owen" if pick == 1 else "memory_brother"] = true
	await ui.say("", LINES["mirror"]["memory%d" % pick])
	main.play("sting", 2.0, 0.4)
	main.play("whisper", -2.0, 0.5)
	p.shake(1.0)
	await ui.say("", LINES["mirror"]["scream"])
	ui.close()
	# the light returns: the reflection, wrong
	ui.flash(0.5)
	_lights(1.0, 0.3)
	glass_m.albedo_color = Color(0.02, 0.025, 0.035, 0.42)
	twin_wrong.visible = true
	var head: Node3D = twin.get_meta("head")
	head.scale = Vector3(1.45, 1.35, 1.45)
	var body: Node3D = twin.get_meta("body")
	body.scale = Vector3(1.25, 1.0, 1.15)
	_twin_mode = "mirror"
	await ui.fade_to(0.0, 0.3)
	await ui.say(LINES["mirror"]["pain"][0], LINES["mirror"]["pain"][1])
	await ui.think(LINES["mirror"]["wrong"])
	await ui.think(LINES["mirror"]["wrong2"])
	await ui.say(LINES["mirror"]["erase"][0], LINES["mirror"]["erase"][1])
	ui.close()
	# the dark again, and the joy
	_lights(0.0, 0.1)
	await ui.fade_to(1.0, 0.1)
	await ui.say("", LINES["mirror"]["joy"])
	ui.close()
	twin_wrong.visible = false
	head.scale = Vector3.ONE
	body.scale = Vector3.ONE
	# normal, then lagging, then its own
	_lights(1.0, 0.4)
	await ui.fade_to(0.0, 0.4)
	await ui.think(LINES["mirror"]["normal"])
	ui.close()
	f.erase("cinematic")  # let him move, so the lag shows
	main.update_hud()
	_twin_mode = "lag"
	_lag = 0.5
	await get_tree().create_timer(4.0).timeout
	_twin_mode = "own"
	_still_t = 0.0
	_puzzle = true
	main.update_hud()
	# the puzzle: stand still, and it walks to the exit he cannot see
	var waited := 0.0
	while not _twin_arrived and waited < 60.0:
		waited += get_process_delta_time()
		await get_tree().process_frame
	_puzzle = false
	f["cinematic"] = true
	await ui.think(LINES["mirror"]["exit_seen"])
	if f.has("frames_refused_door"):
		twin_visor.visible = false
		await ui.think(LINES["mirror"]["lag_off"])
		await ui.say(LINES["mirror"]["refused"][0], LINES["mirror"]["refused"][1])
	else:
		await ui.think(LINES["mirror"]["lag"])
	await ui.say(LINES["mirror"]["tulpa1"][0], LINES["mirror"]["tulpa1"][1])
	await ui.say(LINES["mirror"]["tulpa2"][0], LINES["mirror"]["tulpa2"][1])
	ui.close()
	# the chime, the download, the breath
	main.play("ding", -6.0, 1.1)
	ui.show_toast(LINES["mirror"]["dl_toast"], 5.0)
	ui.flash(0.6)
	ui.glitch(0.6, 2.0)
	_twin_mode = "hidden"
	glass_m.albedo_color = Color(0.01, 0.01, 0.012, 1.0)
	await ui.say("", LINES["mirror"]["download"])
	main.loop("pressure", -8.0, MIRROR, 2.0, 20.0).play()
	if _hum:
		_hum.pitch_scale = 0.6
	ui.close()
	await ui.caption(LINES["mirror"]["breathe"], 5.0)
	main.add_connection(5.0 if f.has("frames_refused_door") else 8.0, LINES["mirror"]["why"])
	f["twin_born"] = true
	await _ending()


## Lights up or down: the bulb, the niche, the twin.
func _lights(v: float, t: float) -> void:
	var tw := create_tween().set_parallel(true)
	tw.tween_property(bulb_light, "light_energy", 2.4 * v, t)
	tw.tween_property(bulb_m, "emission_energy_multiplier", 3.0 * v, t)
	tw.tween_property(twin_light, "light_energy", 1.6 * v, t)
	tw.tween_property(spiral_m, "emission_energy_multiplier", 3.0 * v, t)
	tw.tween_property(rim_light, "light_energy", 1.1 * v, t)
	tw.tween_property(rim_m, "emission_energy_multiplier", 1.2 * v, t)
	_cand_v = v


## Which way Carl has leaned, read off the flags, in this order: company
## man (theory == "drugs", or hid_name_from_turan), investigator
## (told_lynx_name), sleeper (bowed or interfaced), else undecided.
func _ending() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if _ended:
		return
	_ended = true
	f["act1_done"] = true
	var e: Dictionary = LINES["ending"]
	await ui.fade_to(1.0, 1.5)
	# the stance panel: what the glass showed last, by main.stance()
	var st: String = main.stance()
	if not e.has("stance_" + st):
		st = "undecided"
	await ui.show_card(str(e["stance_" + st]), 4.5)
	# Lynx in the office chair, nearby (ch. 9.5), one panel
	main.play("whisper", 0.0, 0.3)
	await ui.show_card(str(e["lynx1"]) + "\n\n" + str(e["lynx2"]) + "\n\n[b]" + str(e["lynx3"]) + "[/b]", 6.0)
	f.erase("cinematic")
	# the mirror is a doorway now: the glass gone, the black room open
	glass.visible = false
	set_active(mirror_it, false)
	twin_door_light.light_energy = 2.2
	# the act card: the number, what was typed first, the flags
	var extra := ""
	extra += str(e["f_turned_back"] if f.has("gate_turned_back") else e["f_drove"]) + "\n"
	extra += str(e["f_frames_off"] if f.has("frames_refused_door") else e["f_frames_on"]) + "\n"
	if f.has("bowed"):
		extra += str(e["f_bowed"]) + "\n"
	extra += str(e["f_memory%d" % int(f.get("mirror_memory", 0))]) + "\n"
	extra += str(e["f_twin"]) + "\n"
	var conn: String = str(e["conn"]) % [int(main.connection), main.glyphs_found]
	var typed := ""
	if str(main.first_typed) != "":
		typed = str(e["typed"]) % str(main.first_typed) + "\n"
	ui.show_end("[center]\n\n\n[b]" + str(e["title"]) + "[/b]\n\n"
		+ conn + "\n" + typed
		+ str(e["stance_label"]) + str(e["names"][st]) + "\n\n"
		+ "[color=#aaaaaa]" + extra + "[/color]\n"
		+ "[b]" + str(e["next"]) + "[/b]\n" + str(e["foot"]) + "\n\n" + str(e["keys"]) + "[/center]")
	if main._selftest:
		ui.endcard.visible = false  # nothing presses E in the headless run
		return
	await ui.end_closed
	main.load_level("Facility")


# ------------------------------------------------------------------ each frame

func tick(delta: float) -> void:
	if not main or not main.player or not twin:
		return
	var p = main.player
	var pp: Vector3 = p.global_position
	# the player's trail, for the lagging reflection
	_trail.append([_t, pp, p.yaw])
	while _trail.size() > 240:
		_trail.pop_front()
	var want_pos := _reflect(pp)
	var want_yaw := _reflect_yaw(p.yaw)
	var vis := _twin_mode != "hidden"
	twin.visible = vis
	twin_light.visible = vis
	twin_visor.visible = vis and main.frames_on and not main.flags.has("frames_refused_door")
	match _twin_mode:
		"mirror":
			_twin_pos = want_pos
			_twin_yaw = want_yaw
		"lag":
			# the pose from _lag seconds ago, and every so often it stalls
			var at := _t - _lag
			var s: Array = _trail[0]
			for e in _trail:
				if e[0] <= at:
					s = e
				else:
					break
			if fmod(_t, 2.3) < 0.5:
				pass  # stalled: keep the last pose
			else:
				_twin_pos = _reflect(s[1])
				_twin_yaw = _reflect_yaw(s[2])
		"own":
			# it stops copying: it looks at him, and when he stands still it
			# walks to the exit on its side of the glass and opens it
			_own_t += delta
			var pv: Vector3 = p.velocity
			if Vector2(pv.x, pv.z).length() < 0.15:
				_still_t += delta
			else:
				_still_t = 0.0
			if _twin_arrived or _still_t > 2.0:
				var d2 := TWIN_EXIT - _twin_pos
				if d2.length() > 0.3:
					_twin_pos = _twin_pos.move_toward(TWIN_EXIT, delta * 1.3)
					_twin_yaw = lerp_angle(_twin_yaw, atan2(-d2.x, -d2.z), delta * 3.0)
				elif not _twin_arrived:
					_twin_arrived = true
					twin_door_light.light_energy = 2.2
					main.play("door", -6.0, 0.8)
				else:
					var d3 := pp - twin.global_position
					_twin_yaw = lerp_angle(_twin_yaw, atan2(-d3.x, -d3.z), delta * 1.5)
					Anim.look(twin, pp + Vector3(0, 1.6, 0), 1.0, 0.08)
			else:
				var d := pp - twin.global_position
				_twin_yaw = lerp_angle(_twin_yaw, atan2(-d.x, -d.z), delta * 1.5)
				Anim.look(twin, pp + Vector3(0, 1.6, 0), 1.0, 0.08)
	var moved := twin.position.distance_to(_twin_pos)
	twin.position = _twin_pos
	twin.rotation.y = _twin_yaw
	if vis:
		if moved > delta * 0.4:
			_twin_walk += delta
			Anim.walk(twin, _twin_walk, 1.0, 0.0, 0.8)
		else:
			Anim.idle(twin, _t, 0.0)
	for i in hooded.size():
		Anim.idle(hooded[i], _t, i * 1.7)
	for i in candle_lights.size():
		var cl: OmniLight3D = candle_lights[i]
		cl.light_energy = _cand_v * (0.7 + sin(_t * 9.0 + i * 2.1) * 0.08 + sin(_t * 23.0 + i) * 0.04)
	# the chair, spinning slowly in the west gallery
	for c in get_children():
		if c.has_meta("spin"):
			(c as Node3D).rotation.y += delta * 0.35
	# the bulb swings a little; drips
	if bulb:
		bulb.position.x = sin(_t * 0.7) * 0.03
	_drip_t -= delta
	if _drip_t <= 0.0:
		_drip_t = rng.randf_range(2.0, 6.0)
		main.play("tap", -22.0, rng.randf_range(0.6, 1.1))


func objective() -> String:
	if main.flags.has("act1_done"):
		return LINES["objective"]["done"]
	if _puzzle:
		return LINES["mirror"]["still"]
	return LINES["objective"]["begun"] if _begun else LINES["objective"]["start"]


func phone() -> String:
	var t: String = LINES["phone"]["line1"]
	if _begun:
		t += LINES["phone"]["line2"]
	if cells_live > 2:
		t += LINES["phone"]["line3"]
	return t


func apply_args(a: Dictionary) -> void:
	if a.has("lit") or a.has("begun") or a.has("wrong"):
		bulb_m.emission_energy_multiplier = 3.0
		bulb_light.light_energy = 2.4
	if a.has("begun") or a.has("wrong"):
		_begun = true
		spiral_m.emission_energy_multiplier = 3.0
		for i in 16:
			(cells[i] as MeshInstance3D).visible = true
		cells_live = 16
	if a.has("wrong"):
		twin_wrong.visible = true
		(twin.get_meta("head") as Node3D).scale = Vector3(1.45, 1.35, 1.45)
	if a.has("hidden"):
		_twin_mode = "hidden"


func selftest() -> void:
	await intro()
	for id in ["dais", "pillars", "blastula", "centre", "blastula", "mirror", "mirror", "mirror"]:
		for n in main._all_with_meta(self, "id"):
			if is_instance_valid(n) and str(n.get_meta("id")) == id:
				await main.interact(n)
				print("ok ", id)
				break
	await main.selftest_all_interactables()
