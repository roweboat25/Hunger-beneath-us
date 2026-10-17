extends "res://scripts/Level.gd"
## Chapter 27, the playable interlude: Dr. Turan and Emmet, after the two
## doors. Bible A3-S3. Book: "The door slammed right in Turan's face. She
## cried out for Carl and Lynx, but there was no noise getting through that
## door." Played in third person as Turan (her Body figure on a capsule, the
## camera on a spring arm behind her right shoulder); Carl's first-person
## body is parked, seated and hidden until the end, when the first-person
## camera is handed back. Emmet follows her on a breadcrumb trail (the
## Lynx-follow pattern from Southtown.gd, without the clamps: the trail
## keeps him inside the halls).
##
## The beats, in the book's order: the slammed door and Emmet on the floor;
## the slap ("Giving up isn't going to help them"); the left hall, green and
## brick-lined, Turan's interior as captions over the walk (floor 118, "What
## a croc of shit", "her baby, her brain child was nothing but a farce");
## the bed in the hall where the lights get brighter; the chamber "about the
## size of a football field" under a skylight, the eye murals, the LED bulbs
## at regular intervals, the encampment along the walls; the circle face
## down under the light; the delivery drone, "the kind that killed Marcus
## Elontiel", and its package; the chant, and the bulbs flickering with it;
## the white and red ring with the black pond (the eyes, behind the
## content-setting card); the run back; Harold Dufredy in the door; Emmet's
## knife (the player can swing it: nothing); the cultists behind them; the
## center; the bow (hold E to resist; the force wins); the fleet of drones;
## Forner (with eyes in the circle if forner_case_ending is "cover" or "walk
## him home", eyeless at Dufredy's side otherwise); "Good children, now it is
## time for you to see." Cut to black. Their fate is the epilogue's.
##
## Layout (metres, y 0 is the floor). The round room of the two doors is at
## the origin (r 5.5): the left door opens north at x -1.8, the right door
## (the void, shut now) at x +1.8, the way back runs south. The left hall is
## built on a 1.4 m grid from axis-aligned rects (a wall wherever a cell has
## no neighbour): north to z -36, west to x -25.6, north again to the
## chamber's south door at z -94.8, with a dead-end spur of offerings and a
## side room of used beds. The chamber is 90 x 50 m (x -70.6..19.4, z
## -144.8..-94.8), 16 m high; the skylight is a 9.2 m square hole over CC.
## The pond of eyes is at POOL, 18 m off the circle.
##
## Reads: forner_case_ending, ev_knife, trust.lynx, trust.emmet. Sets:
## in_start, in_slap, in_walk1, in_talk, in_lynx ("part" / "trick"), in_bed,
## in_chamber, in_told (if Turan tells Emmet), in_circle, in_drone, in_eyes,
## in_dufredy, in_swung, in_bound, in_bowed, turan_resisted (seconds held),
## in_forner, turan_interlude_done and interlude_done; then loads "River".
## Hooks for the systems that come later: "cultist" (the sleepers by the
## shelters, the two who take their arms), "eyeless" (Dufredy, and Forner
## when he has none), "drone" / "hackable" (the delivery drone, the fleet).

## Every line of text in this level, keyed by beat (the function that plays
## it) and line. Captions are arrays played in order over the walk.
const LINES := {
	"build": {
		"card": "[b]TURAN[/b]\n\n[color=#aaaaaa]the left hall  ·  Day 7, Glitch Day[/color]",
		"toast": "You are Dr. Turan.   WASD walk   mouse look   Shift run   E act",
	},
	"objective": {
		"emmet": "Get Emmet off the floor.",
		"hall": "The left hall. Press on.",
		"follow": "Follow the hall.",
		"centre": "The light at the centre of the room.",
		"run": "Back the way you came. Run (Shift).",
		"bow": "Hold E to resist.",
	},
	"intro": {
		"cry": "CARL! LYNX!",
		"slam": "The door slammed right in Turan's face. She cried out for Carl and Lynx, but there was no noise getting through that door.",
		"dead": "Emmet sat on the floor in a cold silence. The last thing Turan needed was dead weight in a moment like this.",
	},
	"slap": {
		"eye": "She got to Emmet's eye level and slapped him hard, hard enough that the sound echoed through the room.",
		"line": "Giving up isn't going to help them, neither is sitting in this room waiting for the cult to find us. We need to press on.",
		"rise": "A bewildered Emmet slowly arose and wiped the dirt from his pants and sheepishly followed behind her, like a bear cub might follow his mother.",
		"emmet": "...Yes, ma'am.",
		"emmet_warm": "...Yeah. Okay. Yes, ma'am. Pressing on.",
		"log": "Turan slapped Emmet off the floor at the two doors and took the left hall.",
	},
	"walk1": [
		"Turan knew Emmet was out of his depth. He had been for quite some time.",
		"She thought he longed for the days in corporate training, where anything was possible.",
		"He had been grateful to work at Psyonic once, for the prestige of it. Now he wished he'd just been assigned simple maintenance duty.",
		"He'd likely end up touched by the cult anyway. At least then he wouldn't be crawling around a haunted tunnel system with his bitchy boss.",
		"Turan's guilt was slowly beginning to reach her as well.",
		"Her apartment was on floor 118. Not so bad for a girl whose family started as line cooks in the corporate cafeteria.",
		"There was a time when 118 wasn't good enough. She wished to be higher, more important, working with the movers and shakers of this city. Maybe floor 230.",
		"She laughed at herself for a moment.",
	],
	"talk": {
		"croc": "What a croc of shit this whole thing ended up being.",
		"pace": "Her pace slowed to allow Emmet to catch up to her.",
		"what": "What do you mean, ma'am?",
		"know": "You know what I'm talking about. Psyon... Psyonic... the fucking eldritch being that lives in the bottom of the city that threatens to rip the eyes from every man, woman and child in this town. This was supposed to be paradise, away from the violence of the old world. Now we're huddled in a fucking cave.",
		"show": "Oh, you meant that. Yup, it's a total shit show.",
		"smile": "Emmet gave a small smile, regaining his footing in the world.",
		"lynx": "We have to find Carl and Lynx. We need to get them to that computer. Why the fuck did Lynx run off like that? Do you think she's a part of this?",
		"lynx_cold": "She didn't even look back at him. She just ran.",
		"choices": ["\"It's almost certain at this point.\"", "\"It may have been a trick.\""],
		"certain": "It's almost certain at this point. But I don't want to believe that.",
		"certain_e": "...Yeah. Me neither.",
		"trick": "This thing knows us. Our fears, our desires. It may have been a trick.",
		"trick_n": "Turan whispered it, as if the walls could hear. They probably could.",
		"trick_e": "A trick. Okay. A trick. That's... better. I think that's better.",
		"log_part": "Turan told Emmet that Lynx was almost certainly part of it.",
		"log_trick": "Turan told Emmet that Lynx running might have been the thing's trick.",
	},
	"bed": {
		"bed": "They approached a bed in the hall and the lights got slightly brighter.",
		"where": "There's no way for us to tell exactly where we are.",
		"point": "I think that's the point. This whole place is a maze and a test. Probably for followers to show their loyalty.",
	},
	"guilt": [
		"Turan was sure Eren had walked these halls before. That fucking bastard, she thought.",
		"Why would the company go along with this for so long?",
		"Using belief is an effective societal control mechanism. But giving up your eyes to a fucking voice within a computer program? Arranging your father's death?",
		"The guilt began to swallow her.",
		"The AI integrations department, her baby, her brain child, was nothing but a farce: a way for the cultish leaders of the company to spy on the beast's murmurs.",
		"Poor Carl. She led him down this path, made him feel like his work mattered to the people of Sillico. Now it might seal his family's fate.",
		"She got the sense that all of this was preordained, like she was walking a path that required this of her, even the immense guilt she was bearing.",
		"How much of her life had been a lie? To what end had she facilitated this thing's colossal following within the city?",
		"Or was it inevitable? It was a godless time. Maybe people need one. Maybe Sillico cried out, and this is what answered: a cruel reflection of the void.",
	],
	"chamber": {
		"arrive": "She soon arrived at a large open area about the size of a football field, illuminated by sunlight from a central hole in the ceiling above them.",
		"watched": "The air had changed. She knew she was being watched, but not from where. She debated on telling Emmet. What was going to happen would happen regardless.",
		"choices": ["Tell Emmet they're being watched", "Let him keep a few more moments of sanity"],
		"tell": "Emmet. We're being watched.",
		"tell_e": "I know. I've felt it since the door. I just didn't want to say it out loud.",
		"tell_t": "At least his instincts were still sharp. That was the reason she had hired him.",
		"keep": "Maybe she would let him retain a few more moments of sanity.",
		"what": "What is this place?",
		"alone": "We're not alone here, are we.",
		"instincts": "Well, at least his instincts are still sharp. That was the reason she had hired him. But she did wish for him to sit in that oblivion a bit longer.",
		"murals": "The room was ornamented in massive eye-shaped murals.",
		"leds": "LED light bulbs hung from all parts of the ceiling in regular intervals.",
		"camp": "There were small structures lining the walls, an encampment of sorts.",
		"log_tell": "Turan told Emmet they were being watched.",
		"log_keep": "Turan let Emmet keep a few more moments of sanity.",
	},
	"circle": {
		"saw": "Then she saw it. In the center of the room, a small circle of people lay face down underneath the skylight.",
		"chant": "They slowly began to chant a rhythmic, undiscernible hymn. The lights above them began to flicker in sequence with their chants. Perhaps it was a prayer answered, she thought.",
	},
	"drone": {
		"descend": "Then a drone descended from the hole in the roof, a large delivery drone. The kind that killed Marcus Elontiel.",
		"drop": "The drone dropped what appeared to be a large package in the center of the room.",
		"who": "The circle",
		"praise1": "[b]It provides. It provides.[/b]",
		"praise2": "[b]Praise the one beneath the waves.[/b]",
		"praise3": "[b]The pupil feeds the ones who walk the path.[/b]",
		"chorus": "The chorus grew louder as the chants evolved to cries of praise for the beast within the waves, for providing for them.",
	},
	"eyes": {
		"look": "Turan, look over there.",
		"ring": "Around the cultists sat a large, roughly constructed white and red circle, sitting with a pool of black liquid.",
		"eyes": "It's... It's their fucking eyes.",
		"card": "[b]CONTENT SETTING[/b]\n\n[color=#aaaaaa]Turan knew he was right. In the distance, a circle of hundreds of eyes lay sitting in a murky black pond.\n\nThe frame is withheld. The smell is not.[/color]",
		"out": "We need to get the fuck out of here.",
		"log": "Emmet saw the pond of eyes. Turan said they had to get out.",
	},
	"door": {
		"ran": "They ran back the way they came, only to be greeted by a familiar phantom.",
		"name": "[b]Harold Dufredy.[/b]",
		"anger": "Turan stared at the gaunt figure that blocked the door. She felt fear, yes, but also anger. Anger for the life that was promised and that was now lost.",
		"verse1": "You walked the sacred path\nYou have arrived at the center, the pupil\nThe birthplace of reverence",
		"out": "Get out of our way!",
		"knife": "Emmet brandished his knife at the man.",
		"knife_alt": "Carl had the good knife, out of Emmet's bag. Emmet had the little folding one off his keyring, and he held it out like it was a sword.",
		"verse2": "Your mind races with haste, child.\nBut there is no need for that here.\nIt is a great day.\nThere will be no violence.\nOnly submissions.",
		"swing": "Swing (Emmet's knife)",
		"miss": "The blade cut the air an inch from the old man's throat. Dufredy did not flinch. He had nothing left to flinch with.",
		"grab": "Emmet tried rushing toward the man, only for his arms to be grabbed by a cultist behind him.",
		"bound": "Turan's arms were also restrained, and they were brought to the center, to the hole in the ceiling.",
		"log_swing": "Emmet swung his knife at Dufredy. It did nothing.",
	},
	"bow": {
		"emmet": "Emmet was forced to bow as the congregation began to pray loudly.",
		"knees": "Turan felt a force in her knees.",
		"hold": "HOLD E   resist",
		"bowed": "...and she bowed as well. The smell of rotting eyeballs began to fill her nose.",
		"drones": "She noticed a fleet of drones floating above their heads, silently watching.",
		"see": "Good children, now it is time for you to see.",
		"log": "Turan held out %d seconds against the bow before it took her.",
	},
	"forner": {
		"eyes1": "In the circle, face down on the stone with the rest of them: Phil Forner. Head of Security and Governance. Oldest on the team.",
		"eyes2": "He raised his head and looked up at her. He still had his eyes. He looked almost happy to see her.",
		"none1": "At Dufredy's side stood a second gaunt figure in a coat she knew. Forner. Head of Security and Governance.",
		"none2": "Where his eyes had been, two dried black wounds. He was smiling at her the way Dufredy smiled.",
	},
	"end": {
		"log": "Turan and Emmet were taken at the center, the pupil. Dufredy said it was time for them to see.",
	},
	"emmet": {
		"hall": "Right behind you, ma'am. ...Right behind you.",
		"chamber": "Don't look at them too long. I don't think they like it. I don't think they don't like it.",
		"end": "Emmet didn't answer. His forehead was on the stone.",
	},
	# [prompt, line, line]
	"look": {
		"right_door": ["The right door", "She hit it with the flat of her hand until her palm stung. Steel. No knob, no handle, no seam she could get a nail into.", "Carl and Lynx were on the other side of it, in the black. Or they were nowhere."],
		"reader": ["The blood sensor", "The biometric reader was smeared in dark, dried blood. Old. Rusted into the metal. A hundred past offerings, maybe more.", "This place wasn't just built to test them. It was designed to remember everyone who failed."],
		"way_back": ["The way back", "Back was the corridor, the manhole, the depot at Rail Cut, the city on top of all of it. Back was the cult, coming down after them.", "Forward was the only direction there was."],
		"glyph": ["The green eye", "The green eye and the arrow, painted at the turn. The same mark that had led them down from the depot.", "It pointed on, and it did not care whether they followed."],
		"offerings": ["The dead end", "A dead end. At the foot of the wall: frames, phones, a smartwatch on a child's strap, laid out like flowers at a grave. Every screen dark.", "A maze and a test. Somebody had failed it here and left what they had."],
		"bed": ["The bed", "A steel cot, alone in the hall, as if someone had wheeled it this far and given up. The mattress still held the shape of a body.", "On the pillow, two small brown stains, side by side, where the eyes would be."],
		"beds": ["The beds", "Six cots in a row. Blankets thrown back. Shoes underneath, lined up neatly, the way you leave them when you're coming back.", "Recently used. Whoever slept here had woken up and walked on toward the center."],
		"mural": ["The murals", "Eyes. Each one the size of a billboard, lime-white and rust-red on the sandstone, the pupils painted black and glossy so they looked wet.", "Every one of them was aimed at the skylight. Or at her."],
		"bulbs": ["The bulbs", "LED bulbs on bare wire, hung from every part of the ceiling at regular intervals. Psyonic Home stock: the same bulbs that lit her apartment on floor 118.", "Someone had wired a cathedral out of a parts catalogue."],
		"shelter": ["A shelter", "Tarps over poles. A mattress, a camp stove, a water jug, a child's shoe. People lived down here.", "Not prisoners. Nobody had locked them in. They had chosen this."],
		"shrine": ["A shelter", "A cardboard sign propped against the tarp, the letters in the same red as the murals: THE PUPIL PROVIDES.", "Under it, a stack of ORA frames, folded neatly, lenses down. They didn't need them anymore."],
		"packages": ["The packages", "Delivery crates, stacked to head height. Psyonic Logistics labels, every one addressed to nobody at no address.", "The city fed them. The city didn't know it was feeding them."],
		"sleeper": ["A sleeper", "A figure sat cross-legged by its shelter, hood up, hands open on its knees. It did not look at Turan.", "It did not need to."],
		"circle": ["The circle", "A small circle of people lay face down on the stone underneath the skylight, arms out, foreheads to the floor, heads to the middle like the spokes of a wheel.", "None of them moved when she came close. The sun was on their backs."],
	},
	"phone": {
		"text": "Turan's phone.\n\n[color=#e07070]NO SIGNAL[/color]\n\nThe last message, unsent: [i]Carl, the left door. We're going left.[/i]\n\n",
	},
}


func L(beat: String, key: String) -> String:
	return str((LINES[beat] as Dictionary)[key])


# ------------------------------------------------------------------ layout

const PSYON_GREEN := Color(0.2, 1.0, 0.45)
const HALL_GREEN := Color(0.35, 0.95, 0.5)
const SUN_C := Color(1.0, 0.92, 0.76)
const LED_C := Color(0.82, 0.9, 1.0)
const CELL := 1.4
const GX := -3.2
const GZ := -37.4
const HALL_H := 3.2
const WT := 0.4
## The hall as rects [x0, x1, z0, z1]: A north, B west, C north, the spur, the bed room.
const RECTS := [[-3.2, -0.4, -37.4, -5.2], [-27.0, -0.4, -37.4, -34.6], [-27.0, -24.2, -94.8, -34.6],
	[-11.6, -8.8, -47.2, -37.4], [-35.4, -27.0, -64.0, -57.0]]
## Cells that are open but not hall (the round room, the chamber door): no wall toward them.
const GHOSTS := [[-3.2, -0.4, -5.2, -2.4], [-27.0, -24.2, -97.6, -94.8]]
## The walking line, for the beats that fire on how far along she is.
const PATH := [Vector3(-1.8, 0, -4.0), Vector3(-1.8, 0, -36.0), Vector3(-25.6, 0, -36.0), Vector3(-25.6, 0, -95.0)]
const ROOM_R := 5.5
const R_DOOR := Vector3(1.8, 0, -5.4)
const TSPAWN := Vector3(1.5, 0.05, -3.3)
const ESIT := Vector3(-3.3, 0, 2.9)
const BED := Vector3(-26.3, 0, -52.0)
const CC := Vector3(-25.6, 0, -120.0)
const CH_X0 := -70.6
const CH_X1 := 19.4
const CH_Z0 := -144.8
const CH_Z1 := -94.8
const CH_H := 16.0
const HOLE := 4.6
const POOL := Vector3(-9.6, 0, -129.0)
const DOOR_C := Vector3(-25.6, 0, -94.8)
const DUF_DOOR := Vector3(-25.6, 0, -96.1)
const KNEEL_T := CC + Vector3(-0.65, 0, 1.75)
const KNEEL_E := CC + Vector3(0.65, 0, 1.75)
const DUF_END := CC + Vector3(0, 0, -1.05)
const SENS := 0.0024
const MAX_OMNI := 20

# Turan: a capsule (tb) carrying a hip pivot carrying the figure
var tb: CharacterBody3D
var t_piv: Node3D
var turan: Node3D
var torch: SpotLight3D
var _t_yaw := 0.0
var _t_kneel := 0.0
var _t_bow := 0.0
var _t_posed := false
var _step_acc := 0.0
# the camera: a pivot at her shoulder, a spring arm, the camera; a free cut camera
var _pivot: Node3D
var _arm: SpringArm3D
var _cam: Camera3D
var _cut: Camera3D
var _yaw := 0.0
var _pitch := -0.18
var _shake := 0.0
var _tp := false
var _ctl := false
var _busy := false
var _no_trig := false
var _near: CollisionObject3D
var _its: Array = []
# Emmet
var emmet: Node3D
var e_piv: Node3D
var emmet_it: CollisionObject3D
var knife: MeshInstance3D
var _e_state := "sit"
var _e_pos := ESIT
var _e_yaw := -0.85
var _e_to := Vector3.ZERO
var _e_sit := 1.0
var _e_kneel := 0.0
var _e_bow := 0.0
var _trail: Array = []
# the others
var dufredy: Node3D
var d_piv: Node3D
var forner: Node3D
var f_piv: Node3D
var _forner_eyes := false
var grabbers: Array = []    # [piv, fig]
var drone: Node3D
var package: Node3D
var fleet: Array = []
var hall_gate: StaticBody3D
var dyn: Node3D
# robes: meshes and the multimeshes of each crowd
var _robe_m: StandardMaterial3D
var _void_m: StandardMaterial3D
var robe_stand: Array = []
var robe_sit: Array = []
var camp: Array = []        # {pos, yaw, t, s}
var mm_camp_sit: Array = []
var mm_camp_stand: Array = []
var mm_cong: Array = []
var _camp_up := false
var _cong_on := false
var circle_skip := -1
# lights and the LED groups
var _omnis: Array = []
var _hall_lamps: Array = []  # [OmniLight3D, base]
var _led_mats: Array = []
var _chanting := false
var _chant_k := 0.0
var _cull_t := 0.0
var _flood: OmniLight3D
var shaft: StandardMaterial3D
var sun_spot: SpotLight3D
# sound
var _hum: Node
var _wind: Node
var _chant1: Node
var _chant2: Node
var _murmur: Node
var _flies: Node
var _rotor: Node
var _press: Node
# captions over the walk
var _caps: Array = []
var _cap_on := false
# the black card
var card_rect: ColorRect
var card_text: RichTextLabel
# the knife and the bow
var _phase := ""
var _swings := 0
var _last_swing := 0.0
var _kw := 0.0
var _sim_hold := false
var _sim_swing := false
var _resisted := 0.0
var _ended := false


# ------------------------------------------------------------------ build

var _brick: StandardMaterial3D
var _hfloor: StandardMaterial3D
var _hceil: StandardMaterial3D
var _sand: StandardMaterial3D
var _sandfloor: StandardMaterial3D
var _rust: StandardMaterial3D
var _steel: StandardMaterial3D
var _blood: StandardMaterial3D


func build(m: Node) -> void:
	main = m
	rng.seed = 2727
	kit_day = false
	step_db = -19.0
	card = L("build", "card")
	# Carl's body waits out of the way, seated, on a slab of his own
	spawn = Vector3(0, 0.1, 60.0)
	box(Vector3(3, 0.2, 3), Vector3(0, -0.1, 60.0), mat(Color(0.02, 0.02, 0.02)), true)
	dyn = Node3D.new()
	add_child(dyn)
	_brick = tex_mat(_brick_tex(), Vector3(0.62, 0.62, 0.62), 0.92, true)
	_hfloor = pbr("concrete", Vector3(1, 1, 1) / 2.2, true, Color(0.36, 0.36, 0.3), 1.0)
	_hceil = pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.16, 0.17, 0.15), 1.0)
	_sand = pbr("plaster", Vector3(1, 1, 1) / 4.0, true, Color(0.62, 0.42, 0.28), 1.0)
	_sandfloor = pbr("concrete", Vector3(1, 1, 1) / 3.0, true, Color(0.55, 0.42, 0.3), 1.0)
	_rust = pbr("rust", Vector3(1, 1, 1) / 1.5, true, Color(0.8, 0.7, 0.62), 1.0)
	_steel = mat(Color(0.24, 0.25, 0.25), 0.4, 0.8)
	_blood = decal_mat(Tex.blood(27), Color(1, 1, 1), 0.3)
	_void_m = StandardMaterial3D.new()
	_void_m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_void_m.albedo_color = Color(0, 0, 0)
	_void_m.disable_fog = true
	_round_room()
	_hall()
	_hall_dressing()
	_chamber()
	_skylight()
	_murals()
	_leds()
	_encampment()
	_circle_and_pool()
	_robes()
	_batch(self, 24.0, true)
	_people()
	_drone_and_fleet()
	_layers()
	_turan()
	_tp_on()


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	# underground, Glitch Day afternoon: no sky but the square of it through
	# the hole; a dark fog with sand in it, a low warm ambient so the halls
	# read as shapes between the green lamps
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0, 0, 0)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.36, 0.33, 0.3)
	env.ambient_light_energy = 0.32
	env.fog_light_color = Color(0.05, 0.045, 0.035)
	env.fog_density = 0.011
	env.fog_sky_affect = 0.0
	env.glow_bloom = 0.06
	env.tonemap_exposure = 1.18
	sun.light_energy = 0.0
	sun.shadow_enabled = false


func hifi(env: Environment, _sun: DirectionalLight3D) -> void:
	env.volumetric_fog_density *= 0.8
	for c in get_children():
		if c is SpotLight3D:
			(c as SpotLight3D).shadow_enabled = true
			(c as SpotLight3D).light_volumetric_fog_energy = 3.0


func ambience() -> void:
	_hum = main.loop("hum", -24.0)
	(_hum as AudioStreamPlayer).pitch_scale = 0.55
	_wind = main.loop("wind", -14.0, CC + Vector3(0, 14.0, 0), 10.0, 90.0)
	_chant1 = main.loop("chant", -80.0, CC + Vector3(0, 0.8, 0), 9.0, 140.0)
	_chant2 = main.loop("chant", -80.0, CC + Vector3(0, 0.8, 0), 9.0, 140.0)
	(_chant2 as AudioStreamPlayer3D).pitch_scale = 0.68
	_murmur = main.loop("murmur", -80.0, CC + Vector3(0, 1.0, 0), 9.0, 140.0)
	_flies = main.loop("flies", -80.0, POOL + Vector3(0, 0.5, 0), 3.0, 40.0)
	_rotor = main.loop("hum", -80.0, Vector3.ZERO, 6.0, 90.0, drone)
	(_rotor as AudioStreamPlayer3D).pitch_scale = 2.6
	_press = main.loop("pressure", -80.0)


func _fade(ap: Node, db: float, t: float) -> void:
	if ap == null or not is_instance_valid(ap):
		return
	create_tween().tween_property(ap, "volume_db", db, t)


## A box that turns with the wall it belongs to, and collides as it turns.
func _rwall(size: Vector3, pos: Vector3, rot_y: float, m: Material, solid := true) -> void:
	var mi := box(size, pos, m)
	mi.rotation.y = rot_y
	if not solid:
		return
	var sb := StaticBody3D.new()
	sb.position = pos
	sb.rotation.y = rot_y
	var cs := CollisionShape3D.new()
	var sh := BoxShape3D.new()
	sh.size = size
	cs.shape = sh
	sb.add_child(cs)
	add_child(sb)


func _lamp(pos: Vector3, c: Color, e: float, r: float) -> OmniLight3D:
	var o := light(pos, c, e, r, false)
	_omnis.append(o)
	return o


## Something Turan can act on. `r` is how close she has to be.
func _it(id: String, pos: Vector3, size: Vector3, r := 2.2, parent: Node = self) -> CollisionObject3D:
	var look: Array = LINES["look"].get(id, [id, "", ""])
	var it := interactable(id, str(look[0]), pos, size, "", false, parent)
	it.set_meta("r", r)
	_its.append(it)
	return it


# ------------------------------------------------------------------ the round room (ch.25's two doors)

## "We reached another circular room flanked by two metal doors." The left
## door hangs open on the green hall; the right one, the void, is shut now.
func _round_room() -> void:
	cyl(ROOM_R + 0.3, ROOM_R + 0.3, 0.2, Vector3(0, -0.1, 0), _hfloor, 28)
	solid_box(Vector3(12, 0.2, 12), Vector3(0, -0.1, 0))
	cyl(ROOM_R + 0.4, ROOM_R + 0.4, 0.4, Vector3(0, 4.4, 0), _hceil, 28)
	var n := 28
	for k in n:
		var a0 := TAU * k / n
		var a1 := TAU * (k + 1) / n
		var p0 := Vector3(cos(a0), 0, sin(a0)) * ROOM_R
		var p1 := Vector3(cos(a1), 0, sin(a1)) * ROOM_R
		var mid := (p0 + p1) * 0.5
		if mid.z < -3.0 and absf(mid.x) < 3.7:
			continue
		if mid.z > 3.0 and absf(mid.x) < 1.6:
			continue
		var d := p1 - p0
		_rwall(Vector3(d.length() + 0.12, 4.4, WT), mid + mid.normalized() * WT * 0.5 + Vector3(0, 2.2, 0), atan2(-d.z, d.x), _brick)
	# the north face: pillar, the open left door, a pillar, the shut right door, a pillar
	for x: float in [-3.4, 0.0, 3.4]:
		box(Vector3(0.4 if x != 0.0 else 0.8, 4.4, 0.6), Vector3(x, 2.2, -5.4), _brick, true)
	box(Vector3(7.2, 1.2, 0.6), Vector3(0, 3.8, -5.4), _brick, true)
	for x: float in [-3.6, 3.6]:
		box(Vector3(0.4, 4.4, 1.6), Vector3(x, 2.2, -4.6), _brick, true)
	box(Vector3(2.8, 3.2, 0.18), R_DOOR + Vector3(0, 1.6, 0), _rust, true)
	box(Vector3(2.9, 0.1, 0.24), R_DOOR + Vector3(0, 3.2, 0), _steel)
	# the left door, swung in against the hall wall
	box(Vector3(0.12, 3.1, 2.7), Vector3(-0.6, 1.6, -6.9), _rust)
	# biometric readers, "stained red with blood"
	for x: float in [-3.1, 3.1]:
		box(Vector3(0.22, 0.32, 0.08), Vector3(x * 0.98, 1.3, -5.06), _steel)
		box(Vector3(0.14, 0.14, 0.02), Vector3(x * 0.98, 1.34, -5.01), glow(Color(0.9, 0.12, 0.08), 1.2))
		quad(Vector2(0.36, 0.5), Vector3(x * 0.98, 1.16, -5.0), 0.0, _blood)
	# the way they came: a short corridor south into the dark, and rubble
	box(Vector3(2.8, 0.2, 9.0), Vector3(0, -0.1, 9.6), _hfloor, true)
	box(Vector3(2.8, 0.4, 9.0), Vector3(0, 3.4, 9.6), _hceil)
	for x: float in [-1.6, 1.6]:
		box(Vector3(WT, 3.2, 9.0), Vector3(x, 1.6, 9.6), _brick, true)
	box(Vector3(2.8, 3.2, 0.4), Vector3(0, 1.6, 13.0), mat(Color(0.01, 0.01, 0.01)), true)
	for k in 6:
		box(Vector3(rng.randf_range(0.4, 0.9), rng.randf_range(0.2, 0.5), rng.randf_range(0.4, 0.8)),
			Vector3(rng.randf_range(-1.0, 1.0), 0.15, 11.5 + rng.randf_range(-0.8, 1.0)), _sand)
	# rails from the drill days run under the floor and out
	for x: float in [-0.55, 0.55]:
		box(Vector3(0.08, 0.06, 12.0), Vector3(x, 0.03, 7.0), _rust)
	# the green floodlight "that did not fully belong in this world"
	cyl(0.35, 0.5, 0.3, Vector3(0, 4.05, 0), _steel, 10)
	cyl(0.3, 0.3, 0.04, Vector3(0, 3.89, 0), glow(PSYON_GREEN, 3.2), 10)
	_flood = _lamp(Vector3(0, 3.5, 0), PSYON_GREEN, 1.4, 10.5)
	_it("right_door", R_DOOR + Vector3(0, 1.3, 0.2), Vector3(2.6, 2.4, 0.4), 2.4)
	_it("reader", Vector3(3.05, 1.3, -5.0), Vector3(0.5, 0.6, 0.3), 1.6)
	_it("way_back", Vector3(0, 1.2, 7.5), Vector3(2.4, 2.2, 0.6), 2.6)
	var gate := StaticBody3D.new()
	var cs := CollisionShape3D.new()
	var sh := BoxShape3D.new()
	sh.size = Vector3(2.8, 3.2, 0.3)
	cs.shape = sh
	gate.add_child(cs)
	gate.position = Vector3(-1.8, 1.6, -5.6)
	add_child(gate)
	hall_gate = gate


# ------------------------------------------------------------------ the left hall

## "The door on the left swung open and revealed a dim green pathway." A
## grid of 1.4 m cells from RECTS; every cell side with no neighbour gets a
## brick wall, merged into runs. Floors and ceilings are one box per rect.
func _hall() -> void:
	var occ := {}
	var ghost := {}
	for r: Array in RECTS:
		_mark(occ, r)
		var w: float = r[1] - r[0]
		var d: float = r[3] - r[2]
		var c := Vector3((r[0] + r[1]) * 0.5, 0, (r[2] + r[3]) * 0.5)
		box(Vector3(w, 0.2, d), c + Vector3(0, -0.1, 0), _hfloor, true)
		box(Vector3(w + WT * 2.0, 0.4, d + WT * 2.0), c + Vector3(0, HALL_H + 0.2, 0), _hceil)
	for r: Array in GHOSTS:
		_mark(ghost, r)
	var vx := {}
	var hz := {}
	for k: Vector2i in occ:
		for dd: Vector2i in [Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, -1), Vector2i(0, 1)]:
			var nb := k + dd
			if occ.has(nb) or ghost.has(nb):
				continue
			if dd.x != 0:
				var key := Vector2i(k.x + (1 if dd.x > 0 else 0), dd.x)
				if not vx.has(key):
					vx[key] = []
				vx[key].append(k.y)
			else:
				var key2 := Vector2i(k.y + (1 if dd.y > 0 else 0), dd.y)
				if not hz.has(key2):
					hz[key2] = []
				hz[key2].append(k.x)
	for key: Vector2i in vx:
		for run: Vector2i in _runs(vx[key]):
			var x := GX + key.x * CELL + key.y * WT * 0.5
			var z0 := GZ + run.x * CELL - WT
			var z1 := GZ + (run.y + 1) * CELL + WT
			box(Vector3(WT, HALL_H, z1 - z0), Vector3(x, HALL_H * 0.5, (z0 + z1) * 0.5), _brick, true)
			# a skirting of damp along the foot of each run
			box(Vector3(0.05, 0.35, z1 - z0 - 0.8), Vector3(x - key.y * (WT * 0.5 + 0.02), 0.17, (z0 + z1) * 0.5), mat(Color(0.06, 0.08, 0.06), 0.4))
	for key: Vector2i in hz:
		for run: Vector2i in _runs(hz[key]):
			var z := GZ + key.x * CELL + key.y * WT * 0.5
			var x0 := GX + run.x * CELL - WT
			var x1 := GX + (run.y + 1) * CELL + WT
			box(Vector3(x1 - x0, HALL_H, WT), Vector3((x0 + x1) * 0.5, HALL_H * 0.5, z), _brick, true)


func _mark(d: Dictionary, r: Array) -> void:
	var i0 := roundi((float(r[0]) - GX) / CELL)
	var i1 := roundi((float(r[1]) - GX) / CELL)
	var j0 := roundi((float(r[2]) - GZ) / CELL)
	var j1 := roundi((float(r[3]) - GZ) / CELL)
	for i in range(i0, i1):
		for j in range(j0, j1):
			d[Vector2i(i, j)] = true


## Consecutive integers grouped as (first, last) runs.
func _runs(list: Array) -> Array:
	var s := list.duplicate()
	s.sort()
	var out := []
	var a: int = s[0]
	var b: int = s[0]
	for k in range(1, s.size()):
		var v: int = s[k]
		if v == b + 1:
			b = v
		elif v != b:
			out.append(Vector2i(a, b))
			a = v
			b = v
	out.append(Vector2i(a, b))
	return out


## Green caged lamps on the ceiling line, a pipe and a cable run the length
## of each stretch, the eye-and-arrow at the turns, the bed in the hall, the
## spur's offerings, the side room of used cots.
func _hall_dressing() -> void:
	var cage := mat(Color(0.1, 0.12, 0.1), 0.5, 0.7)
	var bulb := glow(HALL_GREEN, 3.0)
	var pipe := mat(Color(0.2, 0.23, 0.2), 0.5, 0.6)
	var cablem := mat(Color(0.03, 0.03, 0.03), 0.7)
	var pts := [Vector3(-1.8, 0, -9.0), Vector3(-1.8, 0, -17.5), Vector3(-1.8, 0, -26.0), Vector3(-1.8, 0, -34.0),
		Vector3(-9.0, 0, -36.0), Vector3(-17.0, 0, -36.0), Vector3(-25.6, 0, -40.0), Vector3(-25.6, 0, -47.0),
		Vector3(-25.6, 0, -53.0), Vector3(-25.6, 0, -60.5), Vector3(-25.6, 0, -69.0), Vector3(-25.6, 0, -77.5),
		Vector3(-25.6, 0, -86.0), Vector3(-10.2, 0, -44.5), Vector3(-31.2, 0, -60.5)]
	for p: Vector3 in pts:
		var top := p + Vector3(0, HALL_H - 0.02, 0)
		box(Vector3(0.12, 0.16, 0.12), top - Vector3(0, 0.12, 0), bulb)
		stick(top - Vector3(0.09, 0.24, 0), top - Vector3(-0.09, 0.24, 0), 0.008, cage)
		stick(top - Vector3(0, 0.24, 0.09), top - Vector3(0, 0.24, -0.09), 0.008, cage)
		var o := _lamp(top - Vector3(0, 0.35, 0), HALL_GREEN, 0.8, 8.0)
		_hall_lamps.append([o, 0.8])
	# pipes and cables along the stretches
	var runs := [[Vector3(-0.75, 2.85, -5.4), Vector3(-0.75, 2.85, -35.0)], [Vector3(-1.0, 2.85, -35.0), Vector3(-26.2, 2.85, -35.0)],
		[Vector3(-24.65, 2.85, -35.0), Vector3(-24.65, 2.85, -94.6)]]
	for r: Array in runs:
		stick(r[0], r[1], 0.07, pipe)
		var a: Vector3 = r[0] + Vector3(0, -0.22, 0)
		var b: Vector3 = r[1] + Vector3(0, -0.22, 0)
		var segs := int(a.distance_to(b) / 3.0)
		for k in segs:
			var p0 := a.lerp(b, float(k) / segs)
			var p1 := a.lerp(b, float(k + 1) / segs)
			stick(p0, (p0 + p1) * 0.5 + Vector3(0, -0.12, 0), 0.015, cablem)
			stick((p0 + p1) * 0.5 + Vector3(0, -0.12, 0), p1, 0.015, cablem)
	# the green eye and the arrow (ch.25) at each turn
	var gm := _glyph_mat()
	quad(Vector2(1.2, 1.2), Vector3(-1.8, 1.7, -37.18), 0.0, gm)
	quad(Vector2(1.2, 1.2), Vector3(-26.97, 1.7, -36.0), PI / 2.0, gm)
	_it("glyph", Vector3(-1.8, 1.4, -36.6), Vector3(1.2, 1.4, 0.6), 2.6)
	var _wet := decal_mat(Tex.blob(), Color(0.02, 0.03, 0.02, 0.55), 0.05)
	# a wet line down the middle of the floor, and the odd sandal, the odd frame
	for k in 26:
		var p: Vector3 = _path_at(rng.randf_range(4.0, 150.0))
		floor_quad(Vector2(rng.randf_range(0.8, 1.8), rng.randf_range(0.6, 1.4)), p + Vector3(rng.randf_range(-0.6, 0.6), 0.012, rng.randf_range(-0.6, 0.6)), rng.randf() * TAU, _wet)
	# the bed in the hall
	_cot(BED, 0.0, true)
	_it("bed", BED + Vector3(0.3, 0.6, 0), Vector3(1.2, 1.0, 2.2), 2.4)
	# the spur: a dead end with offerings
	var end := Vector3(-10.2, 0, -46.8)
	for k in 22:
		var p := end + Vector3(rng.randf_range(-1.1, 1.1), 0.03, rng.randf_range(0.0, 1.1))
		if k % 3 == 0:
			box(Vector3(0.14, 0.04, 0.05), p, mat(Color(0.05, 0.05, 0.06), 0.3, 0.4))  # frames
		elif k % 3 == 1:
			box(Vector3(0.07, 0.01, 0.14), p, mat(Color(0.02, 0.02, 0.03), 0.2, 0.3))  # phones
		else:
			cyl(0.02, 0.02, 0.12, p + Vector3(0, 0.05, 0), mat(Color(0.86, 0.82, 0.7), 0.6), 6)
			sphere(0.012, p + Vector3(0, 0.13, 0), glow(Color(1.0, 0.7, 0.3), 2.0), 5)
	quad(Vector2(1.6, 1.6), end + Vector3(0, 1.8, -0.18), 0.0, gm)
	_it("offerings", end + Vector3(0, 0.5, 0.6), Vector3(2.2, 1.0, 1.0), 2.2)
	# the side room: six cots, recently used
	for k in 6:
		var x := -34.4 + (k % 3) * 2.5
		var z := -63.0 if k < 3 else -58.0
		_cot(Vector3(x, 0, z), 0.0, false)
		for sd: float in [-0.12, 0.12]:
			box(Vector3(0.1, 0.07, 0.26), Vector3(x + sd, 0.035, z + (1.25 if k < 3 else -1.25)), mat(Color(0.12, 0.1, 0.08), 0.8))
	_it("beds", Vector3(-31.2, 0.8, -60.5), Vector3(5.0, 1.6, 4.0), 3.0)


## A steel cot with a stained mattress and a blanket thrown back.
func _cot(p: Vector3, ry: float, stained: bool) -> void:
	var b := Basis(Vector3.UP, ry)
	for sx: float in [-0.42, 0.42]:
		for sz: float in [-0.95, 0.95]:
			stick(p + b * Vector3(sx, 0, sz), p + b * Vector3(sx, 0.48, sz), 0.02, _rust)
	var fr := box(Vector3(0.9, 0.05, 2.0), p + Vector3(0, 0.45, 0), _rust)
	fr.rotation.y = ry
	var mm := box(Vector3(0.82, 0.14, 1.9), p + Vector3(0, 0.55, 0), pbr("fabric", Vector3(2, 2, 1), false, Color(0.5, 0.48, 0.4), 1.0))
	mm.rotation.y = ry
	var bl := box(Vector3(0.86, 0.06, 0.8), p + b * Vector3(0, 0.66, 0.55), pbr("fabric", Vector3(2, 2, 1), false, Color(0.3, 0.32, 0.4), 1.0))
	bl.rotation = Vector3(0.12, ry, 0.05)
	var pl := box(Vector3(0.5, 0.1, 0.3), p + b * Vector3(0, 0.67, -0.75), mat(Color(0.7, 0.68, 0.6), 0.9))
	pl.rotation.y = ry
	if stained:
		for sd: float in [-0.07, 0.07]:
			floor_quad(Vector2(0.09, 0.07), p + b * Vector3(sd, 0.725, -0.75), ry, _blood)
		floor_quad(Vector2(1.0, 1.4), p + b * Vector3(0.1, 0.62, 0.0), ry, decal_mat(Tex.blood(51), Color(0.6, 0.5, 0.4), 0.4))
		floor_quad(Vector2(1.3, 1.0), p + b * Vector3(0.5, 0.012, 0.3), ry + 0.6, _blood)


## Where along the walking line `s` metres is.
func _path_at(s: float) -> Vector3:
	var acc := 0.0
	for k in range(PATH.size() - 1):
		var a: Vector3 = PATH[k]
		var b: Vector3 = PATH[k + 1]
		var ln := a.distance_to(b)
		if s <= acc + ln:
			return a.lerp(b, (s - acc) / ln)
		acc += ln
	return PATH[PATH.size() - 1]


## How far along the walking line a point is (nearest segment).
func _progress(p: Vector3) -> float:
	var best := 1e9
	var out := 0.0
	var acc := 0.0
	var q := Vector2(p.x, p.z)
	for k in range(PATH.size() - 1):
		var a := Vector2(PATH[k].x, PATH[k].z)
		var b := Vector2(PATH[k + 1].x, PATH[k + 1].z)
		var ab := b - a
		var t := clampf((q - a).dot(ab) / ab.length_squared(), 0.0, 1.0)
		var d := q.distance_to(a + ab * t)
		if d < best:
			best = d
			out = acc + ab.length() * t
		acc += ab.length()
	return out


# ------------------------------------------------------------------ the chamber

## "A large open area about the size of a football field, illuminated by
## sunlight from a central hole in the ceiling above them." Sandstone,
## orange where the light finds it; ribs of rock up the long walls; the old
## Tunelet rails crossing the north end; cables down the walls.
func _chamber() -> void:
	var w := CH_X1 - CH_X0
	var d := CH_Z1 - CH_Z0
	var c := Vector3((CH_X0 + CH_X1) * 0.5, 0, (CH_Z0 + CH_Z1) * 0.5)
	box(Vector3(w, 0.2, d), c + Vector3(0, -0.1, 0), _sandfloor, true)
	# walls (the south one leaves the door)
	box(Vector3(w + 2, CH_H + 2, 1.0), Vector3(c.x, CH_H * 0.5, CH_Z0 - 0.5), _sand, true)
	box(Vector3(1.0, CH_H + 2, d + 2), Vector3(CH_X0 - 0.5, CH_H * 0.5, c.z), _sand, true)
	box(Vector3(1.0, CH_H + 2, d + 2), Vector3(CH_X1 + 0.5, CH_H * 0.5, c.z), _sand, true)
	var dl := DOOR_C.x - 1.4
	var dr := DOOR_C.x + 1.4
	box(Vector3(dl - CH_X0 + 1, CH_H + 2, 1.0), Vector3((CH_X0 + dl) * 0.5 - 0.5, CH_H * 0.5, CH_Z1 + 0.5), _sand, true)
	box(Vector3(CH_X1 - dr + 1, CH_H + 2, 1.0), Vector3((dr + CH_X1) * 0.5 + 0.5, CH_H * 0.5, CH_Z1 + 0.5), _sand, true)
	box(Vector3(2.8, CH_H - HALL_H + 2, 1.0), Vector3(DOOR_C.x, HALL_H + (CH_H - HALL_H + 2) * 0.5, CH_Z1 + 0.5), _sand, true)
	# a brick arch round the door, green-lit from the hall side
	for sd: float in [-1.0, 1.0]:
		box(Vector3(0.6, HALL_H + 0.6, 0.5), DOOR_C + Vector3(sd * 1.7, (HALL_H + 0.6) * 0.5, -0.25), _brick, true)
	box(Vector3(4.0, 0.6, 0.5), DOOR_C + Vector3(0, HALL_H + 0.3, -0.25), _brick)
	# the ceiling: four slabs round the hole
	var cz := CC.z
	var cx := CC.x
	var t := 1.6
	var y := CH_H + t * 0.5
	box(Vector3(w, t, (cz - HOLE) - CH_Z0), Vector3(c.x, y, (CH_Z0 + cz - HOLE) * 0.5), _sand)
	box(Vector3(w, t, CH_Z1 - (cz + HOLE)), Vector3(c.x, y, (cz + HOLE + CH_Z1) * 0.5), _sand)
	box(Vector3((cx - HOLE) - CH_X0, t, HOLE * 2), Vector3((CH_X0 + cx - HOLE) * 0.5, y, cz), _sand)
	box(Vector3(CH_X1 - (cx + HOLE), t, HOLE * 2), Vector3((cx + HOLE + CH_X1) * 0.5, y, cz), _sand)
	# ribs of rock up the long walls, every fifteen metres
	var x := CH_X0 + 7.0
	while x < CH_X1 - 4.0:
		for zz: float in [CH_Z0 + 0.6, CH_Z1 - 0.6]:
			if absf(x - DOOR_C.x) < 4.0 and zz > cz:
				continue
			box(Vector3(2.2, CH_H, 1.4), Vector3(x, CH_H * 0.5, zz), _sand, true)
			stick(Vector3(x + 1.3, CH_H, zz + signf(cz - zz) * 0.8), Vector3(x + 1.5, 0.0, zz + signf(cz - zz) * 0.9), 0.03, mat(Color(0.03, 0.03, 0.03), 0.7))
		x += 15.0
	for zz: float in [CH_Z0 + 12.5, CH_Z0 + 25.0, CH_Z0 + 37.5]:
		for xx: float in [CH_X0 + 0.6, CH_X1 - 0.6]:
			box(Vector3(1.4, CH_H, 2.2), Vector3(xx, CH_H * 0.5, zz), _sand, true)
	# the Tunelet rails, from the drill days, across the north end
	for zr: float in [-139.0, -138.0]:
		box(Vector3(w - 2, 0.07, 0.09), Vector3(c.x, 0.035, zr), _rust)
	for k in 40:
		box(Vector3(0.22, 0.05, 1.7), Vector3(CH_X0 + 2 + k * 2.2, 0.02, -138.5), pbr("woodfloor", Vector3(1, 1, 1), false, Color(0.35, 0.3, 0.25), 1.0))
	# sand drifted in the corners, pale under the bulbs
	for k in 18:
		var p := Vector3(rng.randf_range(CH_X0 + 2, CH_X1 - 2), 0.01, rng.randf_range(CH_Z0 + 2, CH_Z1 - 2))
		floor_quad(Vector2(rng.randf_range(2, 6), rng.randf_range(2, 5)), p, rng.randf() * TAU, decal_mat(Tex.blob(), Color(0.7, 0.55, 0.38, 0.4), 0.9))
	# the warm lights: the sun's bounce off the floor, the camp's lanterns, two
	# high cold fills for the bulbs, a dim red over the pond
	_lamp(CC + Vector3(0, 1.4, 0), SUN_C, 1.0, 17.0)
	for p: Vector3 in [Vector3(-60, 2.2, -139), Vector3(4, 2.2, -139), Vector3(-62, 2.2, -100), Vector3(12, 2.2, -112)]:
		_lamp(p, Color(1.0, 0.62, 0.3), 1.5, 13.0)
	_lamp(Vector3(-50, 10.0, -120), LED_C, 0.7, 34.0)
	_lamp(Vector3(-2, 10.0, -120), LED_C, 0.7, 34.0)
	_lamp(POOL + Vector3(0, 2.0, 0), Color(0.9, 0.25, 0.2), 0.8, 9.0)


## The hole, its shaft of rock, the square of afternoon over it, the light
## coming down in a column with dust turning in it.
func _skylight() -> void:
	var top := CH_H + 9.0
	for sd: float in [-1.0, 1.0]:
		box(Vector3(HOLE * 2 + 2, top - CH_H, 1.0), CC + Vector3(0, (CH_H + top) * 0.5, sd * (HOLE + 0.5)), _sand)
		box(Vector3(1.0, top - CH_H, HOLE * 2), CC + Vector3(sd * (HOLE + 0.5), (CH_H + top) * 0.5, 0), _sand)
	var sky := StandardMaterial3D.new()
	sky.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	sky.albedo_color = Color(1.0, 0.97, 0.9)
	sky.disable_fog = true
	floor_quad(Vector2(HOLE * 2, HOLE * 2), CC + Vector3(0, top - 0.2, 0), 0.0, sky, self, false)
	# the column of light and its pool on the floor
	shaft = StandardMaterial3D.new()
	shaft.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	shaft.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	shaft.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	shaft.cull_mode = BaseMaterial3D.CULL_DISABLED
	shaft.albedo_color = Color(SUN_C.r, SUN_C.g, SUN_C.b, 0.022)
	shaft.disable_fog = true
	for k in 3:
		# three nested shells, open-ended, so the column is denser at its heart
		var col := cyl(HOLE * (0.55 + 0.2 * k), HOLE * (0.7 + 0.22 * k), top - 0.5, CC + Vector3(0, (top - 0.5) * 0.5, 0), shaft, 20, dyn)
		(col.mesh as CylinderMesh).cap_top = false
		(col.mesh as CylinderMesh).cap_bottom = false
		col.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var patch := StandardMaterial3D.new()
	patch.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	patch.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	patch.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	patch.albedo_texture = Tex.blob()
	patch.albedo_color = Color(SUN_C.r, SUN_C.g * 0.95, SUN_C.b * 0.85, 0.2)
	floor_quad(Vector2(HOLE * 3.2, HOLE * 3.2), CC + Vector3(0, 0.02, 0), 0.0, patch, dyn)
	var sp := SpotLight3D.new()
	sp.position = CC + Vector3(0, 34.0, 0)
	sp.rotation.x = -PI / 2.0
	sp.spot_angle = 8.6
	sp.spot_range = 42.0
	sp.light_energy = 5.0
	sp.light_color = SUN_C
	sp.spot_attenuation = 0.4
	add_child(sp)
	sun_spot = sp
	var dust := CPUParticles3D.new()
	dust.position = CC + Vector3(0, 7.0, 0)
	dust.amount = 70
	dust.lifetime = 14.0
	dust.preprocess = 14.0
	dust.emission_shape = CPUParticles3D.EMISSION_SHAPE_BOX
	dust.emission_box_extents = Vector3(HOLE * 0.8, 7.0, HOLE * 0.8)
	dust.gravity = Vector3(0, -0.02, 0)
	dust.initial_velocity_min = 0.02
	dust.initial_velocity_max = 0.08
	dust.direction = Vector3(1, 0.2, 0.3)
	dust.spread = 180.0
	var qm := QuadMesh.new()
	qm.size = Vector2(0.03, 0.03)
	var dm := StandardMaterial3D.new()
	dm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	dm.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	dm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	dm.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	dm.albedo_color = Color(1.0, 0.9, 0.7, 0.55)
	qm.material = dm
	dust.mesh = qm
	dyn.add_child(dust)


## "The room was ornamented in massive eye-shaped murals." Lime-white lids,
## a rust-red iris, a black pupil painted glossy, rays, and the drips.
func _murals() -> void:
	var ms := [_mural_mat(1), _mural_mat(2)]
	var places := [[Vector3(-56, 8.5, CH_Z0 + 0.06), 0.0], [Vector3(-25.6, 9.0, CH_Z0 + 0.06), 0.0], [Vector3(5, 8.5, CH_Z0 + 0.06), 0.0],
		[Vector3(-56, 8.5, CH_Z1 - 0.06), PI], [Vector3(5, 8.5, CH_Z1 - 0.06), PI],
		[Vector3(CH_X0 + 0.06, 8.5, -120), PI / 2.0], [Vector3(CH_X1 - 0.06, 8.5, -120), -PI / 2.0]]
	for k in places.size():
		var pl: Array = places[k]
		var mi := quad(Vector2(14.0, 8.0), pl[0], pl[1], ms[k % 2])
		mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_it("mural", Vector3(-25.6, 1.2, CH_Z0 + 3.0), Vector3(14.0, 2.4, 1.0), 6.0)
	_it("mural", Vector3(CH_X0 + 3.0, 1.2, -120), Vector3(1.0, 2.4, 14.0), 5.0)


func _mural_mat(seed: int) -> StandardMaterial3D:
	var wd := 256
	var ht := 146
	var img := Image.create(wd, ht, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	var r := RandomNumberGenerator.new()
	r.seed = 70 + seed
	var lime := Color(0.92, 0.9, 0.82)
	var red := Color(0.62, 0.1, 0.06)
	var cx := wd * 0.5
	var cy := ht * 0.46
	for yy in ht:
		for xx in wd:
			var u := (xx - cx) / (wd * 0.42)
			var v := (yy - cy) / (ht * 0.4)
			if absf(u) > 1.0:
				continue
			var lid := (1.0 - u * u) * 0.95
			var av := absf(v)
			var col := Color(0, 0, 0, 0)
			var rr := Vector2(u * 1.9, v).length()
			if av < lid:
				col = Color(lime.r * 0.7, lime.g * 0.66, lime.b * 0.6, 0.85)
				if rr < 0.82:
					col = red.lerp(Color(0.85, 0.2, 0.1), 0.5 + 0.5 * sin(atan2(v, u) * 40.0))
					col.a = 0.95
				if rr < 0.4:
					col = Color(0.01, 0.01, 0.01, 1.0)
				if rr > 0.24 and rr < 0.32 and u < -0.02 and v < -0.05:
					col = Color(0.95, 0.95, 0.9, 1.0)  # the wet glint
			if absf(av - lid) < 0.09:
				col = Color(lime.r, lime.g, lime.b, 0.95)
			if col.a > 0.0 and r.randf() < 0.06:
				col.a *= 0.4
			if col.a > 0.0:
				img.set_pixel(xx, yy, col)
	# rays out from the lids
	for k in 26:
		var a := TAU * k / 26.0
		var p := Vector2(cx, cy) + Vector2(cos(a) * wd * 0.44, sin(a) * ht * 0.42)
		for j in 18:
			var q := p + Vector2(cos(a), sin(a)) * j
			if q.x >= 0 and q.y >= 0 and q.x < wd and q.y < ht:
				img.set_pixelv(q, Color(lime.r, lime.g, lime.b, 0.7))
	# drips from the bottom lid
	for k in 14:
		var x0 := int(cx + r.randf_range(-wd * 0.35, wd * 0.35))
		var u0 := (x0 - cx) / (wd * 0.42)
		var y0 := int(cy + (1.0 - u0 * u0) * 0.95 * ht * 0.4)
		var ln := r.randi_range(8, 40)
		var c := red if k % 2 == 0 else lime
		for j in ln:
			if y0 + j < ht:
				img.set_pixel(x0, y0 + j, Color(c.r, c.g, c.b, 0.85))
				if x0 + 1 < wd:
					img.set_pixel(x0 + 1, y0 + j, Color(c.r, c.g, c.b, 0.6))
	img.generate_mipmaps()
	var m := StandardMaterial3D.new()
	m.albedo_texture = ImageTexture.create_from_image(img)
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.albedo_color = Color(0.62, 0.58, 0.54)
	return m


## "LED light bulbs hung from all parts of the ceiling in regular intervals."
## A grid of bulbs on bare wire, in six rings out from the centre; each ring
## is one material, so the chant can run a wave through them.
func _leds() -> void:
	var groups := []
	for g in 6:
		groups.append([])
		var gm := newglow(LED_C, 2.2)
		_led_mats.append(gm)
	var wires := []
	var x := CH_X0 + 3.0
	while x < CH_X1 - 2.0:
		var z := CH_Z0 + 3.0
		while z < CH_Z1 - 2.0:
			var p := Vector3(x + rng.randf_range(-0.4, 0.4), 0, z + rng.randf_range(-0.4, 0.4))
			if absf(p.x - CC.x) > HOLE + 0.8 or absf(p.z - CC.z) > HOLE + 0.8:
				var h := rng.randf_range(7.5, 12.5)
				var g := clampi(int(Vector2(p.x - CC.x, p.z - CC.z).length() / 8.0), 0, 5)
				groups[g].append(Transform3D(Basis(), Vector3(p.x, h, p.z)))
				wires.append(Transform3D(Basis().scaled(Vector3(1, CH_H - h, 1)), Vector3(p.x, (CH_H + h) * 0.5, p.z)))
			z += 5.0
		x += 4.6
	var bm := SphereMesh.new()
	bm.radius = 0.12
	bm.height = 0.26
	bm.radial_segments = 6
	bm.rings = 3
	for g in 6:
		_multi(bm, groups[g], _led_mats[g])
	var wm := BoxMesh.new()
	wm.size = Vector3(0.012, 1.0, 0.012)
	_multi(wm, wires, mat(Color(0.04, 0.04, 0.04), 0.7))
	_it("bulbs", CC + Vector3(-14, 1.2, 8), Vector3(3, 2.4, 3), 4.0)


func _multi(m: Mesh, xfs: Array, material: Material) -> MultiMeshInstance3D:
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.mesh = m
	mm.instance_count = xfs.size()
	for k in xfs.size():
		mm.set_instance_transform(k, xfs[k])
	var mmi := MultiMeshInstance3D.new()
	mmi.multimesh = mm
	mmi.material_override = material
	mmi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	dyn.add_child(mmi)
	return mmi


# ------------------------------------------------------------------ the encampment

## "There were small structures lining the walls, an encampment of sorts."
## Tarps over poles, mattresses, stoves, water, the packages the drones bring;
## a sleeper sitting at each one, hood up.
func _encampment() -> void:
	var spots := []
	for xx: float in [-64.0, -52.0, -40.0, -11.0, 1.0, 12.0]:
		spots.append([Vector3(xx, 0, CH_Z0 + 3.4), 0.0])
	for xx: float in [-62.0, -48.0, -6.0, 8.0]:
		spots.append([Vector3(xx, 0, CH_Z1 - 3.4), PI])
	for zz: float in [-108.0, -122.0, -136.0]:
		spots.append([Vector3(CH_X0 + 3.4, 0, zz), PI / 2.0])
		spots.append([Vector3(CH_X1 - 3.4, 0, zz), -PI / 2.0])
	var tarps := [pbr("fabric", Vector3(3, 3, 1), false, Color(0.22, 0.3, 0.42), 1.0), pbr("fabric", Vector3(3, 3, 1), false, Color(0.5, 0.3, 0.14), 1.0),
		pbr("fabric", Vector3(3, 3, 1), false, Color(0.3, 0.32, 0.2), 1.0), pbr("fabric", Vector3(3, 3, 1), false, Color(0.32, 0.3, 0.3), 1.0)]
	var props := ["cardboard_box_01", "plastic_crate_03", "Barrel_01", "metal_trash_can", "old_tyre", "cardboard_box_01"]
	for k in spots.size():
		var o: Vector3 = spots[k][0]
		var ry: float = spots[k][1]
		_shack(o, ry, tarps[k % tarps.size()], k)
		var b := Basis(Vector3.UP, ry)
		prop(props[k % props.size()], o + b * Vector3(1.9, 0, 0.4), ry + rng.randf_range(-0.4, 0.4), 1.0, true)
		camp.append({"pos": o + b * Vector3(0.7, 0, 2.0), "yaw": ry + rng.randf_range(-0.5, 0.5), "t": k % 2, "s": rng.randf_range(0.94, 1.06)})
		if k == 1 or k == 8:
			var lab := "shrine" if k == 1 else "shelter"
			_it(lab, o + Vector3(0, 1.0, 0) + b * Vector3(0, 0, 1.0), Vector3(3.0, 2.0, 2.4), 3.2)
		if k == 3:
			var sl := _it("sleeper", o + b * Vector3(0.7, 0.6, 2.0), Vector3(0.9, 1.2, 0.9), 2.2)
			sl.set_meta("cultist", true)
	# the provisions: delivery crates by the north-east shelters
	var pc := Vector3(7.0, 0, CH_Z0 + 7.5)
	var crate := mat(Color(0.48, 0.36, 0.22), 0.9)
	var tape := mat(Color(0.75, 0.7, 0.6), 0.6)
	for k in 14:
		var lvl := k / 5
		var p := pc + Vector3((k % 5) * 0.9 - 1.8 + lvl * 0.3, 0.32 + lvl * 0.64, rng.randf_range(-0.15, 0.15))
		var bx := box(Vector3(0.8, 0.62, 0.7), p, crate)
		bx.rotation.y = rng.randf_range(-0.2, 0.2)
		var tp := box(Vector3(0.82, 0.05, 0.12), p + Vector3(0, 0.31, 0), tape)
		tp.rotation.y = bx.rotation.y
		var lb := box(Vector3(0.3, 0.18, 0.01), p + Vector3(0, 0.05, 0.36), glow(PSYON_GREEN, 0.5))
		lb.rotation.y = bx.rotation.y
	_it("packages", pc + Vector3(0, 0.8, 0.8), Vector3(4.6, 1.6, 1.4), 3.4)


func _shack(o: Vector3, ry: float, tarp: Material, k: int) -> void:
	var b := Basis(Vector3.UP, ry)
	var pole := _rust
	for sx: float in [-1.4, 1.4]:
		stick(o + b * Vector3(sx, 0, -1.1), o + b * Vector3(sx, 2.3, -1.1), 0.035, pole)
		stick(o + b * Vector3(sx, 0, 1.1), o + b * Vector3(sx, 1.85, 1.1), 0.035, pole)
	var roof := box(Vector3(3.1, 0.03, 2.5), o + b * Vector3(0, 2.1, 0), tarp)
	roof.rotation = Vector3(-0.18, ry, 0.03 * (k % 3 - 1))
	var back := box(Vector3(3.0, 2.25, 0.03), o + b * Vector3(0, 1.12, -1.12), tarp)
	back.rotation.y = ry
	var side := box(Vector3(0.03, 1.9, 2.2), o + b * Vector3(-1.42 if k % 2 == 0 else 1.42, 0.95, 0), tarp)
	side.rotation.y = ry
	var mt := box(Vector3(1.0, 0.18, 2.0), o + b * Vector3(-0.55, 0.09, -0.05), pbr("fabric", Vector3(2, 2, 1), false, Color(0.55, 0.52, 0.44), 1.0))
	mt.rotation.y = ry
	var bl := box(Vector3(1.0, 0.07, 1.1), o + b * Vector3(-0.5, 0.2, 0.3), pbr("fabric", Vector3(2, 2, 1), false, Color(0.45, 0.2, 0.18) if k % 2 == 0 else Color(0.2, 0.3, 0.35), 1.0))
	bl.rotation = Vector3(0.06, ry + 0.2, 0.04)
	# stove, pot, a water jug, a candle at the threshold
	cyl(0.14, 0.16, 0.12, o + b * Vector3(0.75, 0.06, 0.2), _steel, 8)
	cyl(0.12, 0.11, 0.14, o + b * Vector3(0.75, 0.19, 0.2), mat(Color(0.3, 0.3, 0.3), 0.4, 0.7), 8)
	cyl(0.11, 0.11, 0.36, o + b * Vector3(1.0, 0.18, -0.7), mat(Color(0.35, 0.55, 0.75), 0.15), 8)
	cyl(0.025, 0.025, 0.14, o + b * Vector3(0.3, 0.07, 1.25), mat(Color(0.86, 0.82, 0.7), 0.6), 6)
	sphere(0.018, o + b * Vector3(0.3, 0.16, 1.25), glow(Color(1.0, 0.65, 0.3), 2.6), 5)
	if k % 3 == 0:
		# a child's shoe
		box(Vector3(0.07, 0.05, 0.15), o + b * Vector3(0.1, 0.025, 0.8), mat(Color(0.8, 0.2, 0.3), 0.6))
	if k % 4 == 1:
		# a clothes line between the poles
		stick(o + b * Vector3(-1.4, 1.6, 1.1), o + b * Vector3(1.4, 1.6, 1.1), 0.006, mat(Color(0.7, 0.7, 0.6)))
		for j in 3:
			var cl := box(Vector3(0.4, 0.5, 0.01), o + b * Vector3(-0.8 + j * 0.7, 1.35, 1.1), pbr("fabric", Vector3(1, 1, 1), false, Color(0.6, 0.6, 0.55) if j != 1 else Color(0.3, 0.12, 0.12), 1.0))
			cl.rotation.y = ry
	# an eye scrawled on the back tarp
	quad(Vector2(1.1, 0.7), o + b * Vector3(0, 1.4, -1.09), ry, _mural_small())


var _msmall: StandardMaterial3D
func _mural_small() -> StandardMaterial3D:
	if _msmall == null:
		_msmall = _mural_mat(5)
		_msmall.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
		_msmall.albedo_color = Color(1, 1, 1)
	return _msmall


# ------------------------------------------------------------------ the circle and the pond

## "In the center of the room a small circle of people lay face down
## underneath the skylight." Heads to the middle, like spokes. "Around the
## cultists sat a large roughly constructed white and red circle sitting with
## a pool of black liquid": the ring is kerb-stones and boards, painted
## alternate red and white; inside it the black pond, and in it, the eyes.
func _circle_and_pool() -> void:
	var red := mat(Color(0.6, 0.08, 0.05), 0.7)
	var white := mat(Color(0.86, 0.84, 0.78), 0.8)
	var n := 30
	for k in n:
		var a := TAU * k / n
		var p := POOL + Vector3(cos(a), 0, sin(a)) * 5.0
		var bx := box(Vector3(1.1, rng.randf_range(0.25, 0.42), 0.4), p + Vector3(0, 0.16, 0), red if k % 2 == 0 else white)
		bx.rotation = Vector3(rng.randf_range(-0.08, 0.08), -a + PI / 2.0, rng.randf_range(-0.06, 0.06))
	# a second, cruder ring of paint round the face-down circle itself
	for k in 40:
		var a := TAU * k / 40.0
		floor_quad(Vector2(0.9, 0.25), CC + Vector3(cos(a), 0.015, sin(a)) * 5.6, -a + PI / 2.0, red if k % 2 == 0 else white)
	var pond := StandardMaterial3D.new()
	pond.albedo_color = Color(0.01, 0.01, 0.012)
	pond.metallic = 0.6
	pond.roughness = 0.04
	cyl(4.8, 4.8, 0.06, POOL + Vector3(0, 0.03, 0), pond, 28)
	floor_quad(Vector2(13, 13), POOL + Vector3(0, 0.012, 0), 0.4, decal_mat(Tex.blood(88), Color(0.15, 0.12, 0.1), 0.2))
	# hundreds of them, floating, turned every way. Seen only from a distance;
	# the close look is behind the content-setting card.
	var em := StandardMaterial3D.new()
	em.albedo_texture = Tex.eye()
	em.roughness = 0.15
	var sm := SphereMesh.new()
	sm.radius = 0.035
	sm.height = 0.07
	sm.radial_segments = 8
	sm.rings = 4
	var xfs := []
	for k in 420:
		var rr := sqrt(rng.randf()) * 4.6
		var a := rng.randf() * TAU
		var bas := Basis(Vector3(rng.randf() - 0.5, rng.randf() - 0.5, rng.randf() - 0.5).normalized(), rng.randf() * TAU)
		xfs.append(Transform3D(bas, POOL + Vector3(cos(a) * rr, 0.06, sin(a) * rr)))
	_multi(sm, xfs, em)
	# the package lands here; the circle lies round it
	_it("circle", CC + Vector3(0, 0.6, 0), Vector3(8.0, 1.2, 8.0), 6.5)


# ------------------------------------------------------------------ the robed (as Hangar.gd draws them)

const A_BODY := [[0.0, 0.4, 0.4, 0.02], [0.08, 0.38, 0.37, 0.02], [0.5, 0.32, 0.29, 0.01], [0.95, 0.25, 0.2, -0.02], [1.2, 0.24, 0.17, -0.02],
	[1.42, 0.26, 0.17, 0.0], [1.52, 0.22, 0.15, 0.01], [1.58, 0.13, 0.12, 0.02]]
const A_HOOD := [[1.5, 0.15, 0.16, 0.02], [1.62, 0.155, 0.17, 0.01], [1.76, 0.15, 0.165, 0.02], [1.88, 0.11, 0.13, 0.05], [1.98, 0.03, 0.04, 0.1]]
const A_FACE := [[1.6, 0.075, 0.015, -0.158], [1.69, 0.09, 0.02, -0.168], [1.78, 0.065, 0.015, -0.152]]
const A_SIT := [[0.0, 0.42, 0.48, 0.06], [0.1, 0.42, 0.47, 0.06], [0.32, 0.36, 0.38, 0.04], [0.52, 0.26, 0.22, 0.0], [0.78, 0.24, 0.17, -0.02],
	[0.98, 0.26, 0.17, 0.0], [1.08, 0.22, 0.15, 0.01], [1.14, 0.13, 0.12, 0.02]]
const B_BODY := [[0.0, 0.38, 0.38, 0.03], [0.5, 0.3, 0.27, 0.0], [0.9, 0.24, 0.2, -0.03], [1.12, 0.24, 0.19, -0.07], [1.3, 0.25, 0.19, -0.1],
	[1.4, 0.2, 0.16, -0.13], [1.45, 0.12, 0.12, -0.16]]
const B_HOOD := [[1.36, 0.14, 0.15, -0.2], [1.46, 0.15, 0.16, -0.23], [1.58, 0.14, 0.15, -0.24], [1.68, 0.1, 0.12, -0.22], [1.76, 0.03, 0.04, -0.17]]
const B_FACE := [[1.4, 0.07, 0.015, -0.388], [1.48, 0.085, 0.02, -0.398], [1.56, 0.06, 0.015, -0.388]]
const B_SIT := [[0.0, 0.4, 0.46, 0.05], [0.3, 0.35, 0.36, 0.02], [0.5, 0.26, 0.22, -0.02], [0.72, 0.24, 0.19, -0.07], [0.88, 0.25, 0.19, -0.1],
	[0.96, 0.2, 0.16, -0.13], [1.0, 0.12, 0.12, -0.16]]


func _robes() -> void:
	_robe_m = (pbr("fabric", Vector3(3, 3, 1), false, Color(0.15, 0.13, 0.13), 1.0)).duplicate()
	_robe_m.vertex_color_use_as_albedo = true
	var vm := mat(Color(0.004, 0.004, 0.005), 1.0)
	robe_stand = [_robe_mesh(A_BODY, A_HOOD, A_FACE, vm), _robe_mesh(B_BODY, B_HOOD, B_FACE, vm)]
	robe_sit = [_robe_mesh(A_SIT, _shift(A_HOOD, -0.44), _shift(A_FACE, -0.44), vm), _robe_mesh(B_SIT, _shift(B_HOOD, -0.45), _shift(B_FACE, -0.45), vm)]
	# the circle, face down, heads to the middle; one place kept for Forner
	_forner_eyes = _forner_has_eyes()
	var lying := []
	var sleeves := []
	var hands := []
	var n := 14
	circle_skip = 10 if _forner_eyes else -1
	for k in n:
		if k == circle_skip:
			continue
		var a := TAU * (k + 0.5) / n
		var p := CC + Vector3(sin(a), 0, cos(a)) * 4.25
		var yaw := atan2(p.x - CC.x, p.z - CC.z)
		var bas := Basis(Vector3.UP, yaw) * Basis(Vector3.RIGHT, -PI / 2.0) * Basis.from_scale(Vector3(1.0, rng.randf_range(0.95, 1.05), 0.62))
		lying.append(Transform3D(bas, p + Vector3(0, 0.16, 0)))
		# arms out past the head, palms on the stone
		var dir := (CC - p).normalized()
		var side := Vector3(dir.z, 0, -dir.x)
		for sd: float in [-1.0, 1.0]:
			sleeves.append(Transform3D(Basis(Vector3.UP, yaw), p + dir * 1.78 + side * sd * 0.2 + Vector3(0, 0.07, 0)))
			hands.append(Transform3D(Basis(Vector3.UP, yaw), p + dir * 2.2 + side * sd * 0.19 + Vector3(0, 0.03, 0)))
	_robe_mmi(robe_stand[0], lying)
	var slm := BoxMesh.new()
	slm.size = Vector3(0.11, 0.1, 0.7)
	_multi(slm, sleeves, mat(Color(0.12, 0.1, 0.1), 0.95))
	var hm := BoxMesh.new()
	hm.size = Vector3(0.09, 0.035, 0.17)
	_multi(hm, hands, mat(Color(0.62, 0.48, 0.4), 0.7))
	# the sleepers at the shelters: sitting now, standing later, the same places
	for t in 2:
		var sits := []
		var stands := []
		for c: Dictionary in camp:
			if int(c["t"]) != t:
				continue
			var xf := Transform3D(Basis(Vector3.UP, float(c["yaw"])).scaled(Vector3.ONE * float(c["s"])), c["pos"])
			sits.append(xf)
			stands.append(xf)
		mm_camp_sit.append(_robe_mmi(robe_sit[t], sits).multimesh)
		var st := _robe_mmi(robe_stand[t], stands)
		st.visible = false
		mm_camp_stand.append(st.multimesh)
	# the congregation that closes round them at the end: two rings, standing
	for t in 2:
		var xfs := []
		for ring: Array in [[7.4, 22], [9.8, 28]]:
			var r: float = ring[0]
			var cnt: int = ring[1]
			for k in cnt:
				if (k + t) % 2 != 0:
					continue
				var a := TAU * (k + 0.5 * (int(r) % 2)) / cnt
				if r < 8.0 and absf(wrapf(a, -PI, PI)) < 0.32:
					continue  # a gap behind Turan and Emmet, the way they were walked in
				var p := CC + Vector3(sin(a), 0, cos(a)) * (r + rng.randf_range(-0.3, 0.3))
				var yaw := atan2(p.x - CC.x, p.z - CC.z)
				xfs.append(Transform3D(Basis(Vector3.UP, yaw).scaled(Vector3.ONE * rng.randf_range(0.94, 1.07)), p))
		var mmi := _robe_mmi(robe_stand[t], xfs)
		mmi.visible = false
		mm_cong.append(mmi)


func _robe_mmi(m: Mesh, xfs: Array) -> MultiMeshInstance3D:
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.use_colors = true
	mm.mesh = m
	mm.instance_count = xfs.size()
	for k in xfs.size():
		mm.set_instance_transform(k, xfs[k])
		var shade := rng.randf_range(0.65, 1.2)
		mm.set_instance_color(k, Color(shade, shade * rng.randf_range(0.9, 1.0), shade * rng.randf_range(0.88, 1.04)))
	var mmi := MultiMeshInstance3D.new()
	mmi.multimesh = mm
	mmi.custom_aabb = AABB(Vector3(-200, -20, -200), Vector3(400, 60, 400))
	dyn.add_child(mmi)
	return mmi


func _shift(rings: Array, dy: float) -> Array:
	var out := []
	for r: Array in rings:
		var nr := r.duplicate()
		nr[0] = float(nr[0]) + dy
		out.append(nr)
	return out


func _robe_mesh(body: Array, hood: Array, face: Array, void_m: Material) -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	Body.loft(st, body, Rect2(0, 0, 1, 0.7), Transform3D(), true, true, 12)
	Body.loft(st, hood, Rect2(0, 0.7, 1, 0.3), Transform3D(), true, false, 12)
	st.generate_normals()
	var am: ArrayMesh = st.commit()
	am.surface_set_material(0, _robe_m)
	var st2 := SurfaceTool.new()
	st2.begin(Mesh.PRIMITIVE_TRIANGLES)
	Body.loft(st2, face, Rect2(0, 0, 1, 1), Transform3D(), true, true, 10)
	st2.generate_normals()
	st2.commit(am)
	am.surface_set_material(1, void_m)
	return am


# ------------------------------------------------------------------ people

## Every figure stands on a pivot at the hip, so it can kneel and bow:
## the pivot drops by the thigh as the knees fold back, and tips forward
## while the thighs are turned back to stay upright.
func _rig(fig: Node3D, parent: Node3D) -> Node3D:
	var piv := Node3D.new()
	parent.add_child(piv)
	piv.add_child(fig)
	fig.position = Vector3(0, -0.86 * fig.scale.x, 0)
	return piv


func _pose(piv: Node3D, fig: Node3D, ground: Vector3, yaw: float, kneel: float, bow: float) -> void:
	var s := fig.scale.x
	piv.position = ground + Vector3(0, (0.86 - 0.43 * kneel) * s, 0)
	piv.rotation = Vector3(-bow, yaw, 0)
	if kneel > 0.001 or absf(bow) > 0.001:
		for l in fig.get_meta("legs", []):
			(l as Node3D).rotation.x = bow
		for k in fig.get_meta("knees", []):
			(k as Node3D).rotation.x = -PI / 2.0 * kneel


## Sitting on the floor, knees up, the head down (Emmet, at the doors).
func _floor_sit(piv: Node3D, fig: Node3D, ground: Vector3, yaw: float, k: float) -> void:
	var s := fig.scale.x
	var lean := 0.28 * k
	piv.position = ground + Vector3(0, lerpf(0.86 * s, 0.15, k), 0)
	piv.rotation = Vector3(-lean, yaw, 0)
	for l in fig.get_meta("legs", []):
		(l as Node3D).rotation.x = lerpf(0.0, PI / 2.0 + 0.55, k) + lean
	for kn in fig.get_meta("knees", []):
		(kn as Node3D).rotation.x = lerpf(0.0, -2.0, k)
	for a in fig.get_meta("arms", []):
		(a as Node3D).rotation.x = lerpf(0.0, -0.75, k)
	var hd: Node3D = fig.get_meta("head")
	hd.rotation.x = lerpf(hd.rotation.x, 0.42 * k, 0.2)


func _people() -> void:
	# Emmet: lanky, red hair that looks fake (WarRoom.gd's Emmet)
	emmet = figure(Color(0.28, 0.38, 0.5), Color(0.9, 0.74, 0.64), {"hair": Color(0.8, 0.3, 0.1), "legs": Color(0.2, 0.2, 0.24), "arms": true, "knees": true, "scale": 1.06, "long_coat": false})
	e_piv = _rig(emmet, dyn)
	var ea: Array = emmet.get_meta("arms")
	knife = box(Vector3(0.02, 0.2, 0.04), Vector3(0, -0.78, -0.06), mat(Color(0.75, 0.76, 0.78), 0.2, 0.9), false, ea[1])
	box(Vector3(0.03, 0.09, 0.04), Vector3(0, -0.66, -0.06), mat(Color(0.08, 0.08, 0.08), 0.6), false, ea[1])
	knife.visible = false
	emmet_it = interactable("emmet", "Emmet", Vector3(0, 0.9, 0), Vector3(0.8, 1.9, 0.8), "", false, emmet)
	emmet_it.set_meta("r", 2.0)
	_its.append(emmet_it)
	_floor_sit(e_piv, emmet, ESIT, _e_yaw, 1.0)
	# Harold Dufredy: the gaunt phantom, nothing in his sockets (RedRock.gd's)
	var skin := Color(0.8, 0.68, 0.6)
	dufredy = figure(Color(0.5, 0.5, 0.48), skin, {"hair": Color(0.88, 0.88, 0.84), "legs": Color(0.42, 0.42, 0.44), "arms": true, "knees": true, "long_coat": true})
	(dufredy.get_meta("body") as Node3D).scale = Vector3(0.86, 1.0, 0.86)
	d_piv = _rig(dufredy, dyn)
	_set_face(dufredy, _eyeless_face(skin, Color(0.88, 0.88, 0.84), 61, true))
	var hd: Node3D = dufredy.get_meta("head")
	hd.rotation.z = 0.08
	for sd: float in [-1.0, 1.0]:
		var v := sphere(0.024, Vector3(sd * 0.034, 0.018, -0.094), _void_m, 10, hd)
		v.scale = Vector3(1.15, 0.9, 0.55)
	box(Vector3(0.075, 0.012, 0.01), Vector3(0, -0.062, -0.103), mat(Color(0.4, 0.1, 0.1), 0.4), false, hd)
	box(Vector3(0.06, 0.006, 0.01), Vector3(0, -0.06, -0.104), mat(Color(0.9, 0.88, 0.8), 0.3), false, hd)
	dufredy.set_meta("eyeless", true)
	d_piv.visible = false
	_pose(d_piv, dufredy, DUF_DOOR, 0.0, 0.0, 0.0)
	# Forner: carved out of sandstone (WarRoom.gd's). In the circle with his
	# eyes, or at Dufredy's side without them.
	var fs := Color(0.72, 0.58, 0.45)
	forner = figure(Color(0.5, 0.42, 0.32), fs, {"hair": Color(0.55, 0.55, 0.52), "legs": Color(0.3, 0.26, 0.22), "arms": true, "knees": true, "long_coat": false})
	(forner.get_meta("body") as Node3D).scale = Vector3(1.22, 1.0, 1.18)
	f_piv = _rig(forner, dyn)
	_forner_place(_forner_eyes)
	# the two who take their arms: robes over long dark coats, hoods, no eyes
	for k in 2:
		var gs := Color(0.62, 0.5, 0.42) if k == 0 else Color(0.5, 0.38, 0.3)
		var g := figure(Color(0.1, 0.09, 0.09), gs, {"hair": Color(0.15, 0.12, 0.1), "legs": Color(0.08, 0.08, 0.08), "arms": true, "knees": true, "long_coat": true})
		_set_face(g, _eyeless_face(gs, Color(0.15, 0.12, 0.1), 200 + k, false))
		var hood := SurfaceTool.new()
		hood.begin(Mesh.PRIMITIVE_TRIANGLES)
		Body.loft(hood, A_HOOD, Rect2(0, 0.7, 1, 0.3), Transform3D(Basis(), Vector3(0, -0.08, 0.02)), true, false, 12)
		hood.generate_normals()
		mesh(hood.commit(), Vector3.ZERO, _robe_m, g)
		var pv := _rig(g, dyn)
		pv.visible = false
		g.set_meta("cultist", true)
		grabbers.append([pv, g])


func _forner_has_eyes() -> bool:
	var e := str(main.flags.get("forner_case_ending", "")).to_lower()
	return e == "cover" or e.begins_with("walk")


func _forner_place(with_eyes: bool) -> void:
	_forner_eyes = with_eyes
	var hd: Node3D = forner.get_meta("head")
	if with_eyes:
		# face down in the circle, in the place kept for him
		var a := TAU * 10.5 / 14.0
		var p := CC + Vector3(sin(a), 0, cos(a)) * 3.0
		var yaw := atan2(-(CC.x - p.x), -(CC.z - p.z))
		_pose(f_piv, forner, p, yaw, 1.0, 1.25)
		hd.rotation.x = 0.4
		_set_face(forner, Body.face_mat(Color(0.72, 0.58, 0.45), Color(0.55, 0.55, 0.52), false, 31))
		if forner.has_meta("eyeless"):
			forner.remove_meta("eyeless")
		f_piv.visible = true
	else:
		_set_face(forner, _eyeless_face(Color(0.72, 0.58, 0.45), Color(0.55, 0.55, 0.52), 31, false))
		forner.set_meta("eyeless", true)
		_pose(f_piv, forner, DUF_DOOR + Vector3(1.0, 0, 0.35), 0.0, 0.0, 0.0)
		hd.rotation.x = 0.1
		f_piv.visible = false


## Healed-over sockets (the eyeless) or two holes with nothing in them (Dufredy).
const EYE_Y := 95.9
const EYE_DX := 16.2
func _eyeless_face(skin: Color, hair: Color, seed: int, void_eyes: bool) -> StandardMaterial3D:
	var base: StandardMaterial3D = Body.face_mat(skin, hair, false, seed)
	var img: Image = (base.albedo_texture as Texture2D).get_image()
	if img.is_compressed():
		img.decompress()
	img.clear_mipmaps()
	img.convert(Image.FORMAT_RGBA8)
	for sd: float in [-1.0, 1.0]:
		var ex := 128.0 + sd * EYE_DX
		if void_eyes:
			Body._ell(img, ex, EYE_Y, 10.0, 7.5, skin.darkened(0.35), 0.5)
			Body._ell(img, ex, EYE_Y, 8.0, 6.0, Color(0, 0, 0))
		else:
			Body._ell(img, ex, EYE_Y, 9.0, 6.5, skin.darkened(0.2), 0.5)
			Body._ell(img, ex, EYE_Y, 7.0, 4.6, Color(0.36, 0.14, 0.12), 0.3)
			Body._ell(img, ex, EYE_Y + 0.5, 4.2, 2.6, Color(0.08, 0.02, 0.02))
			for j in 6:
				Body._rect(img, ex - 2 + j % 3, EYE_Y + 5 + j * 2, 1.5, 2, Color(0.3, 0.06, 0.05, 0.8))
	img.generate_mipmaps()
	var m := base.duplicate() as StandardMaterial3D
	m.albedo_texture = ImageTexture.create_from_image(img)
	return m


func _set_face(fig: Node3D, m: Material) -> void:
	var hd: Node3D = fig.get_meta("head")
	for c in hd.get_children():
		if c is MeshInstance3D:
			(c as MeshInstance3D).material_override = m
			return


# ------------------------------------------------------------------ the drones

## "Then a drone descended from the hole in the roof, a large delivery
## drone. The kind that killed Marcus Elontiel." And at the end: "a fleet of
## drones floating above their heads silently watching."
func _drone_and_fleet() -> void:
	drone = Node3D.new()
	dyn.add_child(drone)
	drone.position = CC + Vector3(0, 40.0, 0)
	prop("delivery_drone", Vector3.ZERO, 0.0, 2.2, false, drone)
	sphere(0.12, Vector3(0, -0.4, 0), glow(Color(1.0, 0.2, 0.15), 3.0), 6, drone)
	drone.set_meta("drone", true)
	drone.set_meta("hackable", true)
	drone.visible = false
	package = Node3D.new()
	drone.add_child(package)
	package.position = Vector3(0, -1.2, 0)
	box(Vector3(1.3, 0.8, 1.0), Vector3(0, 0, 0), mat(Color(0.5, 0.38, 0.24), 0.9), false, package)
	box(Vector3(1.32, 0.06, 0.16), Vector3(0, 0.4, 0), mat(Color(0.75, 0.7, 0.6), 0.6), false, package)
	box(Vector3(0.5, 0.3, 0.01), Vector3(0, 0.05, 0.505), glow(PSYON_GREEN, 0.6), false, package)
	for k in 7:
		var d := Node3D.new()
		dyn.add_child(d)
		var a := TAU * k / 7.0
		d.position = CC + Vector3(cos(a) * rng.randf_range(4.0, 7.5), rng.randf_range(9.0, 13.0), sin(a) * rng.randf_range(4.0, 7.5))
		d.rotation.y = -a
		prop("police_drone" if k % 2 == 0 else "delivery_drone", Vector3.ZERO, 0.0, 1.3 if k % 2 == 0 else 1.5, false, d)
		sphere(0.06, Vector3(0, -0.35, -0.2), glow(Color(1.0, 0.15, 0.1), 3.5), 5, d)
		d.set_meta("drone", true)
		d.set_meta("hackable", true)
		d.set_meta("home", d.position)
		d.visible = false
		fleet.append(d)


# ------------------------------------------------------------------ the black card

func _layers() -> void:
	var cl := CanvasLayer.new()
	cl.layer = 9
	add_child(cl)
	card_rect = ColorRect.new()
	card_rect.color = Color(0, 0, 0, 1)
	card_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	card_rect.visible = false
	cl.add_child(card_rect)
	card_text = RichTextLabel.new()
	card_text.bbcode_enabled = true
	card_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card_text.anchor_left = 0.18
	card_text.anchor_right = 0.82
	card_text.anchor_top = 0.2
	card_text.anchor_bottom = 0.62
	card_text.add_theme_font_size_override("normal_font_size", 22)
	card_text.add_theme_font_size_override("bold_font_size", 30)
	card_rect.add_child(card_text)


func _card(text: String) -> void:
	card_text.text = "[center]" + text + "[/center]"
	card_rect.visible = true


func _card_off() -> void:
	if card_rect:
		card_rect.visible = false


# ------------------------------------------------------------------ Turan, and the camera behind her

## Dr. Turan: graying black hair in a surgically tight bun (WarRoom.gd's),
## the flashlight she went down the manhole with (ch.25), on a capsule.
func _turan() -> void:
	tb = CharacterBody3D.new()
	tb.collision_layer = 0
	tb.collision_mask = 1
	tb.floor_snap_length = 0.3
	var cs := CollisionShape3D.new()
	var cap := CapsuleShape3D.new()
	cap.radius = 0.3
	cap.height = 1.7
	cs.shape = cap
	cs.position.y = 0.85
	tb.add_child(cs)
	dyn.add_child(tb)
	tb.position = TSPAWN
	turan = figure(Color(0.16, 0.16, 0.19), Color(0.8, 0.66, 0.56), {"hair": Color(0.2, 0.2, 0.22), "legs": Color(0.14, 0.14, 0.16), "arms": true, "knees": true, "long_coat": false})
	var th: Node3D = turan.get_meta("head")
	sphere(0.05, Vector3(0, 0.07, 0.1), mat(Color(0.2, 0.2, 0.22), 0.9), 8, th)
	t_piv = _rig(turan, tb)
	var ta: Array = turan.get_meta("arms")
	var fl := cyl(0.022, 0.026, 0.18, Vector3(0, -0.7, -0.08), mat(Color(0.08, 0.08, 0.09), 0.4, 0.6), 8, ta[1])
	fl.rotation.x = PI / 2.0
	torch = SpotLight3D.new()
	torch.position = Vector3(0.16, 0.42, -0.3)
	torch.rotation.x = -0.14
	torch.spot_angle = 24.0
	torch.spot_range = 17.0
	torch.light_energy = 2.4
	torch.light_color = Color(1.0, 0.95, 0.85)
	t_piv.add_child(torch)
	_t_yaw = 0.0
	_pose(t_piv, turan, Vector3.ZERO, _t_yaw, 0.0, 0.0)
	_pivot = Node3D.new()
	add_child(_pivot)
	_arm = SpringArm3D.new()
	_arm.spring_length = 2.5
	_arm.collision_mask = 1
	_arm.margin = 0.08
	var sph := SphereShape3D.new()
	sph.radius = 0.2
	_arm.shape = sph
	_pivot.add_child(_arm)
	_arm.add_excluded_object(tb.get_rid())
	_cam = Camera3D.new()
	_cam.fov = 68.0
	_cam.near = 0.05
	_cam.far = 400.0
	_cam.cull_mask = main.player.cam.cull_mask
	_arm.add_child(_cam)
	_cut = Camera3D.new()
	_cut.fov = 60.0
	_cut.near = 0.05
	_cut.far = 400.0
	_cut.cull_mask = main.player.cam.cull_mask
	add_child(_cut)
	_yaw = 0.0
	_pivot.position = tb.position + Vector3(0.42, 1.55, 0)


## Third person on: Carl parked and seated (so Main's look-ray finds
## nothing), the crosshair and the frames HUD away, this camera current.
func _tp_on() -> void:
	_tp = true
	_cam.current = true
	main.flags["cinematic"] = true
	main.player.visible = false
	main.ui.crosshair.visible = false
	main.ui.status.visible = false
	main.ui.set_frames(0.0, main.connection)


## Third person off: Carl's own eyes again.
func _restore_fp() -> void:
	_tp = false
	_ctl = false
	_phase = ""
	_card_off()
	if main == null or not is_instance_valid(main) or main.player == null:
		return
	main.player.cam.current = true
	main.player.seated = false
	main.player.visible = true
	main.flags.erase("cinematic")
	main.ui.crosshair.visible = true
	main.ui.status.visible = true
	main.ui.prompt.text = ""
	main.ui.set_frames(1.0 if main.frames_on else 0.0, main.connection)


func _exit_tree() -> void:
	if _tp:
		_restore_fp()


func _cut_to(from: Vector3, at: Vector3, fov := 60.0) -> void:
	_cut.fov = fov
	_cut.global_transform = Transform3D(Basis.looking_at(at - from, Vector3.UP), from)
	_cut.current = true


func _cut_move(from: Vector3, at: Vector3, secs: float) -> void:
	var a := _cut.global_transform
	var b := Transform3D(Basis.looking_at(at - from, Vector3.UP), from)
	var tw := create_tween()
	tw.tween_method(func(k: float) -> void:
		_cut.global_transform = a.interpolate_with(b, smoothstep(0.0, 1.0, k)), 0.0, 1.0, secs)


func _follow(face_yaw := INF) -> void:
	if face_yaw != INF:
		_yaw = face_yaw
		_pitch = -0.18
	_snap_cam()
	_cam.current = true


func _snap_cam() -> void:
	_pivot.global_position = tb.global_position + Vector3(0, 1.55 - 0.45 * _t_kneel, 0) + Basis(Vector3.UP, _yaw) * Vector3(0.42, 0, 0)
	_pivot.rotation = Vector3(_pitch, _yaw, 0)


func _unhandled_input(e: InputEvent) -> void:
	if not _tp or main == null:
		return
	if e is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and _ctl:
		_yaw -= e.relative.x * SENS
		_pitch = clampf(_pitch - e.relative.y * SENS, -1.0, 0.55)
		return
	if e.is_action_pressed("interact"):
		if _phase == "knife":
			_swing()
			get_viewport().set_input_as_handled()
		elif _near and _ctl and not _busy and not main.ui.busy and is_instance_valid(_near):
			get_viewport().set_input_as_handled()
			main.interact(_near)


# ------------------------------------------------------------------ the frame loop

func tick(delta: float) -> void:
	if main == null or tb == null:
		return
	if _tp:
		main.flags["cinematic"] = true
		main.player.seated = true
		main.ui.crosshair.visible = false
	_move_turan(delta)
	if _tp and _cam.current:
		_update_cam(delta)
	_trail_update()
	_tick_emmet(delta)
	_tick_world(delta)
	_tick_prompt()
	if _tp and not _busy and not _no_trig and not _ended:
		_check_beats()


func _move_turan(delta: float) -> void:
	var ui = main.ui
	var input := Vector2.ZERO
	if _tp and _ctl and not ui.choice_box.visible and not ui.title.visible and not main.loading:
		input = Input.get_vector("move_left", "move_right", "move_fwd", "move_back")
		_yaw += Input.get_axis("turn_right", "turn_left") * 2.0 * delta
		_pitch = clampf(_pitch + Input.get_axis("look_down", "look_up") * 1.4 * delta, -1.0, 0.55)
	var running: bool = Input.is_action_pressed("run") or (main._selftest and main.flags.has("in_eyes"))
	var spd := 4.6 if running else 2.3
	var dir := Basis(Vector3.UP, _yaw) * Vector3(input.x, 0, input.y)
	if tb.is_on_floor():
		tb.velocity.y = -0.5
	else:
		tb.velocity.y -= 18.0 * delta
	tb.velocity.x = lerpf(tb.velocity.x, dir.x * spd, minf(1.0, delta * 10.0))
	tb.velocity.z = lerpf(tb.velocity.z, dir.z * spd, minf(1.0, delta * 10.0))
	tb.move_and_slide()
	if tb.global_position.y < -3.0:
		tb.global_position = Vector3(tb.global_position.x, 0.3, tb.global_position.z)
	if _t_posed:
		return
	var hv := Vector2(tb.velocity.x, tb.velocity.z).length()
	if hv > 0.3 and input != Vector2.ZERO:
		_t_yaw = lerp_angle(_t_yaw, atan2(-tb.velocity.x, -tb.velocity.z), minf(1.0, delta * 10.0))
		Anim.walk(turan, _t, hv / 2.4, 0.0, minf(1.0, hv / 1.6))
		_step_acc += hv * delta
		if _step_acc > 0.75:
			_step_acc = 0.0
			main.play("step", step_db, randf_range(1.05, 1.3))
	else:
		Anim.idle(turan, _t, 0.0)
	_pose(t_piv, turan, Vector3.ZERO, _t_yaw, 0.0, 0.0)


func _update_cam(delta: float) -> void:
	var want := tb.global_position + Vector3(0, 1.55 - 0.45 * _t_kneel, 0) + Basis(Vector3.UP, _yaw) * Vector3(0.42, 0, 0)
	_pivot.global_position = _pivot.global_position.lerp(want, minf(1.0, delta * 12.0))
	_pivot.rotation = Vector3(_pitch, _yaw, 0)
	if _shake > 0.0:
		_cam.h_offset = randf_range(-1.0, 1.0) * _shake * 0.04
		_cam.v_offset = randf_range(-1.0, 1.0) * _shake * 0.04
		_shake = maxf(0.0, _shake - delta * 1.2)
	else:
		_cam.h_offset = 0.0
		_cam.v_offset = 0.0


func _trail_update() -> void:
	var p := tb.global_position
	p.y = 0.0
	if _trail.is_empty() or (_trail[_trail.size() - 1] as Vector3).distance_to(p) > 0.3:
		_trail.append(p)
		if _trail.size() > 140:
			_trail.pop_front()


## The point on her trail `back` metres behind her.
func _trail_point(back: float) -> Vector3:
	var p := tb.global_position
	p.y = 0.0
	var acc := 0.0
	var prev := p
	for k in range(_trail.size() - 1, -1, -1):
		var q: Vector3 = _trail[k]
		acc += prev.distance_to(q)
		if acc >= back:
			return q
		prev = q
	return _trail[0] if not _trail.is_empty() else p


func _tick_emmet(delta: float) -> void:
	var head := tb.global_position + Vector3(0, 1.6, 0)
	match _e_state:
		"sit":
			Anim.idle(emmet, _t, 0.7)
			_floor_sit(e_piv, emmet, _e_pos, _e_yaw, _e_sit)
		"follow":
			var target := _beside(_trail_point(1.25))
			if target.distance_to(_e_pos) > 14.0:
				_e_pos = target
			_e_walk(target, delta, head)
		"to":
			_e_walk(_e_to, delta, head)
		"posed":
			_pose(e_piv, emmet, _e_pos, _e_yaw, _e_kneel, _e_bow)


## A step to her left of a point on her trail, unless a wall is there: so he
## walks at her side and out of the camera's line over her right shoulder.
func _beside(q: Vector3) -> Vector3:
	var left := Basis(Vector3.UP, _yaw) * Vector3(-0.8, 0, 0)
	var space := get_world_3d().direct_space_state
	var rq := PhysicsRayQueryParameters3D.create(q + Vector3(0, 0.9, 0), q + left * 1.5 + Vector3(0, 0.9, 0), 1)
	rq.exclude = [tb.get_rid()]
	if space.intersect_ray(rq).is_empty():
		return q + left
	return q


func _e_walk(target: Vector3, delta: float, look_at_pt: Vector3) -> void:
	var d := target - _e_pos
	d.y = 0.0
	var dist := d.length()
	if dist > 0.4:
		var speed := clampf(dist * 2.2, 1.2, 5.0)
		_e_pos += d.normalized() * minf(speed * delta, dist)
		_e_yaw = lerp_angle(_e_yaw, atan2(-d.x, -d.z), minf(1.0, delta * 8.0))
		Anim.walk(emmet, _t, speed / 2.4, 0.9, 1.0)
	else:
		Anim.idle(emmet, _t, 0.9)
		var f := look_at_pt - _e_pos
		_e_yaw = lerp_angle(_e_yaw, atan2(-f.x, -f.z), minf(1.0, delta * 2.0))
		Anim.look(emmet, look_at_pt, 0.6, 0.05)
	_pose(e_piv, emmet, _e_pos, _e_yaw, 0.0, 0.0)


func _tick_world(delta: float) -> void:
	# the bulbs: a slow shimmer, then a wave out from the circle with the chant
	for g in _led_mats.size():
		var m: StandardMaterial3D = _led_mats[g]
		var calm := 2.0 + 0.25 * sin(_t * 0.7 + g)
		var wave := 0.3 + 3.2 * pow(maxf(0.0, sin(_t * 2.6 - g * 0.9)), 3.0)
		m.emission_energy_multiplier = lerpf(calm, wave, _chant_k)
	var cam := get_viewport().get_camera_3d()
	if cam and shaft:
		var cd := Vector2(cam.global_position.x - CC.x, cam.global_position.z - CC.z).length()
		shaft.albedo_color.a = lerpf(0.003, 0.02, clampf((cd - 2.5) / 6.0, 0.0, 1.0))
	if _flood:
		_flood.light_energy = 1.4 + sin(_t * 23.0) * 0.06 + (0.0 if randf() > 0.01 else -1.0)
	# the sleepers, once they are up: every hood turns to keep her in view
	if _camp_up:
		var p := tb.global_position
		for t in 2:
			var mm: MultiMesh = mm_camp_stand[t]
			var k := 0
			for c: Dictionary in camp:
				if int(c["t"]) != t:
					continue
				var cp: Vector3 = c["pos"]
				var want := atan2(-(p.x - cp.x), -(p.z - cp.z))
				c["yaw"] = lerp_angle(float(c["yaw"]), want, minf(1.0, delta * 1.5))
				mm.set_instance_transform(k, Transform3D(Basis(Vector3.UP, float(c["yaw"])).scaled(Vector3.ONE * float(c["s"])), cp))
				k += 1
	for d: Node3D in fleet:
		if d.visible:
			var h: Vector3 = d.get_meta("home")
			d.position = h + Vector3(0, sin(_t * 0.8 + h.x) * 0.25, 0)
			d.rotation.y += delta * 0.05
	# the web renderer shades 32 lights: keep the nearest MAX_OMNI on
	_cull_t -= delta
	if _cull_t <= 0.0:
		_cull_t = 0.3
		var p2 := tb.global_position
		var ds := []
		for o: OmniLight3D in _omnis:
			ds.append([o.global_position.distance_squared_to(p2), o])
		ds.sort_custom(func(a: Array, b: Array) -> bool: return float(a[0]) < float(b[0]))
		for k in ds.size():
			(ds[k][1] as OmniLight3D).visible = k < MAX_OMNI


func _tick_prompt() -> void:
	_near = null
	if not _tp or not _ctl or main.ui.busy or _busy:
		if _phase == "knife":
			main.ui.prompt.text = "E   " + L("door", "swing")
		return
	var p := tb.global_position
	var best := 1e9
	for it: CollisionObject3D in _its:
		if not is_instance_valid(it) or (it.collision_layer & 2) == 0 or not it.is_visible_in_tree():
			continue
		var q := it.global_position
		var d := Vector2(q.x - p.x, q.z - p.z).length()
		if d < float(it.get_meta("r", 2.0)) and d < best:
			best = d
			_near = it
	if _near:
		main.ui.prompt.text = "E   " + str(_near.get_meta("prompt"))


func _check_beats() -> void:
	var f: Dictionary = main.flags
	var p := tb.global_position
	var s := _progress(p)
	if f.has("in_slap") and not f.has("in_walk1") and s > 2.0 and p.z < -5.6:
		f["in_walk1"] = true
		main.update_hud()
		_cap(LINES["walk1"])
	elif f.has("in_walk1") and not f.has("in_talk") and s > 18.0:
		_run(_talk)
	elif f.has("in_talk") and not f.has("in_bed") and s > 64.0 and p.x < -20.0:
		_run(_bed)
	elif f.has("in_bed") and not f.has("in_chamber") and p.z < -96.0:
		_run(_chamber_beat)
	elif f.has("in_chamber") and not f.has("in_circle") and Vector2(p.x - CC.x, p.z - CC.z).length() < 22.0:
		_run(_circle_beat)
	elif f.has("in_eyes") and not f.has("in_dufredy") and p.z > -104.0 and absf(p.x - DOOR_C.x) < 12.0:
		_run(_door_beat)


func _run(c: Callable) -> void:
	_busy = true
	await c.call()
	_busy = false
	main.update_hud()


# ------------------------------------------------------------------ captions over the walk

func _cap(lines: Array) -> void:
	_caps.append_array(lines)
	if not _cap_on:
		_cap_run()


func _cap_run() -> void:
	_cap_on = true
	while not _caps.is_empty():
		var w := 0.0
		while main.ui.dlg.visible and w < 40.0:
			await get_tree().process_frame
			w += get_process_delta_time()
		var t: String = _caps.pop_front()
		await main.ui.caption(t, clampf(t.length() * 0.05, 3.0, 7.5))
	_cap_on = false


func _caps_drain(limit := 45.0) -> void:
	var w := 0.0
	while _cap_on and w < limit:
		await get_tree().process_frame
		w += get_process_delta_time()


func _wait(secs: float) -> void:
	await get_tree().create_timer(secs).timeout


func _say(who: String, text: String) -> void:
	await main.ui.say(who, text)


func _think(text: String) -> void:
	await main.ui.think(text)


# ------------------------------------------------------------------ the beats

func intro() -> void:
	if not _tp:
		_tp_on()
	main.ui.show_toast(L("build", "toast"), 6.0)
	_run(_intro_beat)


## The slam. "She cried out for Carl and Lynx."
func _intro_beat() -> void:
	_ctl = false
	_t_yaw = 0.0
	_pose(t_piv, turan, Vector3.ZERO, 0.0, 0.0, 0.0)
	_cut_to(TSPAWN + Vector3(-1.6, 1.5, 2.2), R_DOOR + Vector3(0, 1.5, 0), 58.0)
	main.play("slam", 3.0, 0.8)
	main.ui.flash(0.3)
	_cut_move(TSPAWN + Vector3(-1.0, 1.6, 1.6), R_DOOR + Vector3(0, 1.6, 0), 3.0)
	await _wait(0.5)
	await _say("Turan", L("intro", "cry"))
	await _think(L("intro", "slam"))
	_cut_to(Vector3(1.2, 1.7, -2.0), ESIT + Vector3(0, 0.6, 0), 56.0)
	await _think(L("intro", "dead"))
	main.ui.close()
	main.flags["in_start"] = true
	var de := ESIT - TSPAWN
	_follow(atan2(-de.x, -de.z))
	_ctl = true


## "She got to Emmet's eye level and slapped him hard."
func _slap() -> void:
	_ctl = false
	var ui = main.ui
	var front := ESIT + Basis(Vector3.UP, _e_yaw) * Vector3(0, 0, -0.85)
	tb.global_position = front + Vector3(0, 0.05, 0)
	tb.velocity = Vector3.ZERO
	var to_e := ESIT - front
	_t_yaw = atan2(-to_e.x, -to_e.z)
	_t_posed = true
	_t_kneel = 1.0
	_pose(t_piv, turan, Vector3.ZERO, _t_yaw, 1.0, 0.15)
	var side := Basis(Vector3.UP, _t_yaw) * Vector3(1.6, 0, 0)
	_cut_to(front + side * 0.9 + to_e * 0.5 + Vector3(0, 0.75, 0), (front + ESIT) * 0.5 + Vector3(0, 0.55, 0), 52.0)
	await _think(L("slap", "eye"))
	ui.close()
	var arm: Node3D = (turan.get_meta("arms") as Array)[1]
	var tw := create_tween()
	tw.tween_property(arm, "rotation", Vector3(-1.5, 0, 0.9), 0.18)
	tw.tween_property(arm, "rotation", Vector3(-1.2, 0, -0.5), 0.07)
	await tw.finished
	main.play("snap", 6.0, 1.3)
	_shake = 0.6
	var eh: Node3D = emmet.get_meta("head")
	create_tween().tween_property(eh, "rotation", Vector3(0.1, -0.75, 0.15), 0.08)
	get_tree().create_timer(0.35).timeout.connect(func() -> void: main.play("snap", -8.0, 1.25))
	get_tree().create_timer(0.75).timeout.connect(func() -> void: main.play("snap", -16.0, 1.2))
	await _wait(0.9)
	create_tween().tween_property(arm, "rotation", Vector3.ZERO, 0.4)
	create_tween().tween_property(eh, "rotation", Vector3(0.3, 0, 0), 0.8)
	await _say("Turan", L("slap", "line"))
	ui.close()
	_t_kneel = 0.0
	_t_posed = false
	# he gets up slowly, and wipes the dirt off
	var rise := create_tween()
	rise.tween_property(self, "_e_sit", 0.0, 1.6).set_trans(Tween.TRANS_SINE)
	await rise.finished
	_e_state = "to"
	_e_to = _e_pos
	await _think(L("slap", "rise"))
	await _say("Emmet", L("slap", "emmet_warm") if int(main.trust.get("emmet", 0)) >= 1 else L("slap", "emmet"))
	ui.close()
	main.flags["in_slap"] = true
	main.log_line("interlude", L("slap", "log"))
	hall_gate.collision_layer = 0
	_e_state = "follow"
	_trail.clear()
	_follow(_t_yaw)
	_ctl = true


## Walk and talk: the player keeps walking while they speak (not while she chooses).
func _talk() -> void:
	await _caps_drain(40.0)
	await _say("Turan", L("talk", "croc"))
	await _think(L("talk", "pace"))
	await _say("Emmet", L("talk", "what"))
	await _say("Turan", L("talk", "know"))
	await _say("Emmet", L("talk", "show"))
	await _think(L("talk", "smile"))
	await _say("Emmet", L("talk", "lynx"))
	if int(main.trust.get("lynx", 0)) <= -1:
		await _say("Emmet", L("talk", "lynx_cold"))
	var i: int = await main.ui.choose(LINES["talk"]["choices"])
	await _lynx_reply(i)
	main.ui.close()
	main.flags["in_talk"] = true


func _lynx_reply(i: int) -> void:
	if i == 0:
		main.flags["in_lynx"] = "part"
		await _say("Turan", L("talk", "certain"))
		await _say("Emmet", L("talk", "certain_e"))
		main.log_line("interlude", L("talk", "log_part"))
	else:
		main.flags["in_lynx"] = "trick"
		await _say("Turan", L("talk", "trick"))
		await _think(L("talk", "trick_n"))
		await _say("Emmet", L("talk", "trick_e"))
		main.log_line("interlude", L("talk", "log_trick"))


## "They approached a bed in the hall and the lights got slightly brighter."
func _bed() -> void:
	await _caps_drain(30.0)
	for pair: Array in _hall_lamps:
		var o: OmniLight3D = pair[0]
		if o.global_position.distance_to(BED) < 22.0:
			create_tween().tween_property(o, "light_energy", float(pair[1]) * 1.7, 2.5)
	main.play("hum", -14.0, 1.6)
	await _think(L("bed", "bed"))
	await _say("Emmet", L("bed", "where"))
	await _say("Turan", L("bed", "point"))
	main.ui.close()
	main.flags["in_bed"] = true
	_cap(LINES["guilt"])


## The chamber: the size of it, being watched, the murals, the bulbs, the camp.
func _chamber_beat() -> void:
	# she may walk on into the room while the last of the guilt plays out
	await _caps_drain(70.0)
	_ctl = false
	tb.velocity = Vector3.ZERO
	_cut_to(DOOR_C + Vector3(2.0, 2.0, -1.5), CC + Vector3(0, 5.0, 0), 62.0)
	_cut_move(DOOR_C + Vector3(1.4, 3.2, -9.0), CC + Vector3(0, 4.0, 0), 6.0)
	_fade(_wind, -10.0, 4.0)
	await _think(L("chamber", "arrive"))
	await _think(L("chamber", "watched"))
	var i: int = await main.ui.choose(LINES["chamber"]["choices"])
	await _watched_reply(i)
	_cut_to(CC + Vector3(-12, 3.0, 14), Vector3(-25.6, 8.0, CH_Z0), 56.0)
	await _think(L("chamber", "murals"))
	_cut_to(CC + Vector3(-8, 1.6, 12), CC + Vector3(-16, 11.0, -2), 60.0)
	await _think(L("chamber", "leds"))
	_cut_to(Vector3(-38, 2.4, -128), Vector3(-58, 1.0, CH_Z0 + 3.0), 58.0)
	await _think(L("chamber", "camp"))
	main.ui.close()
	main.flags["in_chamber"] = true
	_follow(0.0)
	_ctl = true


func _watched_reply(i: int) -> void:
	if i == 0:
		main.flags["in_told"] = true
		await _say("Turan", L("chamber", "tell"))
		await _say("Emmet", L("chamber", "tell_e"))
		await _think(L("chamber", "tell_t"))
		main.log_line("interlude", L("chamber", "log_tell"))
	else:
		await _think(L("chamber", "keep"))
		await _say("Emmet", L("chamber", "what"))
		await _say("Emmet", L("chamber", "alone"))
		await _think(L("chamber", "instincts"))
		main.log_line("interlude", L("chamber", "log_keep"))


## "Then she saw it." The circle, the hymn, the bulbs keeping time; then the
## drone and its package; then the pond.
func _circle_beat() -> void:
	_ctl = false
	tb.velocity = Vector3.ZERO
	var p := tb.global_position
	var to_c := (CC - p)
	to_c.y = 0.0
	to_c = to_c.normalized()
	_cut_to(p + Vector3(0, 1.7, 0) - to_c * 1.6 + Vector3(to_c.z, 0, -to_c.x) * 0.6, CC + Vector3(0, 0.3, 0), 50.0)
	await _think(L("circle", "saw"))
	_fade(_chant1, -6.0, 6.0)
	_fade(_chant2, -10.0, 8.0)
	_fade(_hum, -40.0, 4.0)
	create_tween().tween_property(self, "_chant_k", 1.0, 4.0)
	_chanting = true
	await _think(L("circle", "chant"))
	main.ui.close()
	main.flags["in_circle"] = true
	await _drone_beat()
	await _eyes_beat()


func _drone_beat() -> void:
	drone.visible = true
	drone.position = CC + Vector3(0, 40.0, 0)
	_fade(_rotor, 2.0, 2.5)
	_cut_to(CC + Vector3(6.5, 1.3, 9.0), CC + Vector3(0.5, 16.0, 0.3), 58.0)
	var tw := create_tween()
	tw.tween_property(drone, "position", CC + Vector3(0, 4.4, 0), 7.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_cut_move(CC + Vector3(6.0, 1.5, 8.0), CC + Vector3(0, 4.0, 0), 7.0)
	await _think(L("drone", "descend"))
	var w := 0.0
	while tw.is_running() and w < 12.0:
		await get_tree().process_frame
		w += get_process_delta_time()
	main.ui.close()
	# the drop
	var gp := package.global_position
	drone.remove_child(package)
	dyn.add_child(package)
	package.global_position = gp
	var fall := create_tween()
	fall.tween_property(package, "global_position", CC + Vector3(0, 0.4, 0), 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await fall.finished
	main.play("slam", -2.0, 0.6)
	_shake = 0.3
	var up := create_tween()
	up.tween_property(drone, "position", CC + Vector3(0, 44.0, 0), 8.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	up.tween_callback(func() -> void: drone.visible = false)
	_fade(_rotor, -80.0, 8.0)
	await _think(L("drone", "drop"))
	_fade(_chant1, 0.0, 3.0)
	_fade(_murmur, -4.0, 3.0)
	_cut_to(CC + Vector3(-3.0, 0.5, 6.5), CC + Vector3(0, 0.6, 0), 54.0)
	await _say(L("drone", "who"), L("drone", "praise1"))
	await _say(L("drone", "who"), L("drone", "praise2"))
	await _say(L("drone", "who"), L("drone", "praise3"))
	await _think(L("drone", "chorus"))
	main.ui.close()
	main.flags["in_drone"] = true


## "It's... It's their fucking eyes." The pond behind the content-setting card.
func _eyes_beat() -> void:
	await _say("Emmet", L("eyes", "look"))
	var from := CC + (POOL - CC) * 0.15 + Vector3(-2.0, 2.4, 6.0)
	_cut_to(from, POOL + Vector3(0, 0.2, 0), 46.0)
	_fade(_flies, -6.0, 3.0)
	await _think(L("eyes", "ring"))
	await _say("Emmet", L("eyes", "eyes"))
	main.ui.close()
	_card(L("eyes", "card"))
	main.play("sting", -4.0, 0.7)
	await _wait(3.5)
	await _say("Turan", L("eyes", "out"))
	main.ui.close()
	_card_off()
	main.flags["in_eyes"] = true
	main.log_line("interlude", L("eyes", "log"))
	# they are all up now, and every hood turns to follow her
	for k in 2:
		(mm_camp_sit[k] as MultiMesh).visible_instance_count = 0
		(mm_camp_stand[k] as MultiMesh).visible_instance_count = -1
	for mmi in dyn.get_children():
		if mmi is MultiMeshInstance3D and (mmi as MultiMeshInstance3D).multimesh in mm_camp_stand:
			(mmi as MultiMeshInstance3D).visible = true
	_camp_up = true
	_fade(_murmur, 2.0, 4.0)
	_fade(_press, -14.0, 6.0)
	var d := DOOR_C - tb.global_position
	_follow(atan2(-d.x, -d.z))
	_ctl = true


## Dufredy in the door; the verses; the knife; the arms; the center.
func _door_beat() -> void:
	_ctl = false
	main.flags["in_dufredy"] = true
	tb.velocity = Vector3.ZERO
	var tp := DUF_DOOR + Vector3(0.7, 0, -4.4)
	tb.global_position = tp + Vector3(0, 0.05, 0)
	_t_yaw = PI
	_pose(t_piv, turan, Vector3.ZERO, PI, 0.0, 0.0)
	_e_state = "posed"
	_e_pos = DUF_DOOR + Vector3(-0.8, 0, -4.0)
	_e_yaw = PI
	d_piv.visible = true
	if not _forner_eyes:
		f_piv.visible = true
	_cut_to(tp + Vector3(0.9, 1.75, -2.2), DUF_DOOR + Vector3(0, 1.5, 0), 54.0)
	main.play("sting", -2.0, 0.5)
	await _think(L("door", "ran"))
	_cut_to(DUF_DOOR + Vector3(0.6, 1.55, -1.9), DUF_DOOR + Vector3(0, 1.62, 0), 40.0)
	await _think(L("door", "name"))
	_cut_to(tp + Vector3(-0.5, 1.62, -1.4), DUF_DOOR + Vector3(0, 1.5, 0), 50.0)
	await _think(L("door", "anger"))
	_cut_to(DUF_DOOR + Vector3(-1.0, 1.4, -2.1), DUF_DOOR + Vector3(0, 1.7, 0), 44.0)
	await _say("Dufredy", L("door", "verse1"))
	knife.visible = true
	var ea: Array = emmet.get_meta("arms")
	create_tween().tween_property(ea[1], "rotation", Vector3(-1.2, 0, 0.1), 0.3)
	_cut_to(_e_pos + Vector3(-1.4, 1.5, -1.6), _e_pos + Vector3(0, 1.3, 0.4), 52.0)
	await _say("Emmet", L("door", "out"))
	await _think(L("door", "knife_alt") if main.flags.has("ev_knife") else L("door", "knife"))
	_cut_to(DUF_DOOR + Vector3(-1.2, 1.5, -2.3), DUF_DOOR + Vector3(0, 1.62, 0), 46.0)
	await _say("Dufredy", L("door", "verse2"))
	main.ui.close()
	# the player can swing; it does nothing
	_cut_to(_e_pos + Vector3(-2.2, 1.7, -2.6), DUF_DOOR + Vector3(-0.4, 1.3, 0), 56.0)
	_phase = "knife"
	_swings = 0
	_last_swing = 0.0
	_kw = 0.0
	while _kw < 6.0 and not (_swings > 0 and _kw - _last_swing > 1.6) and _swings < 4:
		if _sim_swing and _swings == 0 and _kw > 0.5:
			_swing()
		await get_tree().process_frame
		_kw += get_process_delta_time()
	_phase = ""
	main.ui.prompt.text = ""
	await _grab()


func _swing() -> void:
	if _phase != "knife":
		return
	_swings += 1
	_last_swing = _kw
	main.flags["in_swung"] = true
	if _swings == 1:
		main.log_line("interlude", L("door", "log_swing"))
		main.ui.show_toast(L("door", "miss"), 4.0)
	var ea: Array = emmet.get_meta("arms")
	var tw := create_tween()
	tw.tween_property(ea[1], "rotation", Vector3(-1.7, 0.4, -0.9), 0.12)
	tw.tween_property(ea[1], "rotation", Vector3(-1.2, 0, 0.1), 0.3)
	var lunge := create_tween()
	var p0 := _e_pos
	lunge.tween_property(self, "_e_pos", p0 + Vector3(0.2, 0, 0.5), 0.12)
	lunge.tween_property(self, "_e_pos", p0, 0.4)
	main.play("tap", -4.0, 0.6)


func _grab() -> void:
	# from behind them, out of the chamber: two of the hooded
	var gt: Array = grabbers[0]
	var gu: Array = grabbers[1]
	(gt[0] as Node3D).visible = true
	(gu[0] as Node3D).visible = true
	var tp := tb.global_position
	tp.y = 0.0
	_pose(gt[0], gt[1], _e_pos + Vector3(0, 0, -0.55), PI, 0.0, 0.0)
	_pose(gu[0], gu[1], tp + Vector3(0, 0, -0.55), PI, 0.0, 0.0)
	for g: Array in grabbers:
		for a in (g[1] as Node3D).get_meta("arms"):
			(a as Node3D).rotation = Vector3(-1.1, 0, 0)
	var ea: Array = emmet.get_meta("arms")
	for a in ea:
		create_tween().tween_property(a, "rotation", Vector3(0.5, 0, 0), 0.15)
	var ta: Array = turan.get_meta("arms")
	_t_posed = true
	for a in ta:
		(a as Node3D).rotation = Vector3(0.45, 0, 0)
	main.play("slam", -6.0, 1.4)
	_shake = 0.5
	_cut_to(_e_pos + Vector3(2.4, 1.6, 0.8), _e_pos + Vector3(0, 1.2, -0.3), 54.0)
	await _think(L("door", "grab"))
	_drop_torch(tp + Vector3(0.4, 0.08, 0.3))
	await _think(L("door", "bound"))
	main.ui.close()
	await main.ui.fade_to(1.0, 0.9)
	_setup_bound()
	main.flags["in_bound"] = true
	await _wait(1.2)
	main.ui.fade_to(0.0, 1.4)
	await _bow_beat()


## She drops the flashlight; it lies on the stone and lights the floor.
func _drop_torch(at: Vector3) -> void:
	if torch.get_parent() == dyn:
		return
	t_piv.remove_child(torch)
	dyn.add_child(torch)
	torch.global_position = at
	torch.rotation = Vector3(0, 2.2, 0)
	torch.light_energy = 1.6


## At the center, under the hole: the congregation round them, the drones
## above, Dufredy before them across the package.
func _setup_bound() -> void:
	tb.global_position = KNEEL_T + Vector3(0, 0.05, 0)
	tb.velocity = Vector3.ZERO
	_t_yaw = 0.0
	_pose(t_piv, turan, Vector3.ZERO, 0.0, 0.0, 0.0)
	_e_pos = KNEEL_E
	_e_yaw = 0.0
	_e_kneel = 0.0
	_e_bow = 0.0
	_pose(d_piv, dufredy, DUF_END, PI, 0.0, 0.0)
	var gt: Array = grabbers[0]
	var gu: Array = grabbers[1]
	_pose(gt[0], gt[1], KNEEL_E + Vector3(0, 0, 0.6), 0.0, 0.0, 0.0)
	_pose(gu[0], gu[1], KNEEL_T + Vector3(0, 0, 0.6), 0.0, 0.0, 0.0)
	if not _forner_eyes:
		_pose(f_piv, forner, DUF_END + Vector3(1.1, 0, -0.5), PI, 0.0, 0.0)
		f_piv.visible = true
	for mmi: MultiMeshInstance3D in mm_cong:
		mmi.visible = true
	for k in 2:
		(mm_camp_stand[k] as MultiMesh).visible_instance_count = 0
	_camp_up = false
	for d: Node3D in fleet:
		d.visible = true
	_fade(_chant1, 4.0, 3.0)
	_fade(_chant2, 0.0, 3.0)
	_fade(_murmur, 4.0, 3.0)
	_fade(_wind, -30.0, 3.0)


func _bow_beat() -> void:
	# "Emmet was forced to bow"
	_cut_to(DUF_END + Vector3(1.6, 1.0, -0.6), (KNEEL_T + KNEEL_E) * 0.5 + Vector3(0, 1.0, 0), 56.0)
	_e_state = "posed"
	var tw := create_tween()
	tw.tween_property(self, "_e_kneel", 1.0, 1.2)
	tw.tween_property(self, "_e_bow", 1.2, 1.4)
	await _think(L("bow", "emmet"))
	await _think(L("bow", "knees"))
	main.ui.close()
	await _resist()
	main.flags["in_bowed"] = true
	main.flags["turan_resisted"] = int(_resisted)
	main.log_line("interlude", L("bow", "log") % int(_resisted))
	main.play("flies", -8.0, 0.8)
	await _think(L("bow", "bowed"))
	# the fleet
	_cut_to(KNEEL_T + Vector3(0.3, 0.9, 0.9), CC + Vector3(0.6, 12.0, -0.4), 64.0)
	_cut_move(KNEEL_T + Vector3(0.4, 1.0, 0.8), CC + Vector3(-1.5, 11.0, -1.5), 5.0)
	await _think(L("bow", "drones"))
	await _forner_beat(_forner_eyes)
	# the line, from where her head is
	_cut_to(KNEEL_T + Vector3(0.1, 0.75, -0.25), DUF_END + Vector3(0, 1.75, 0), 50.0)
	_cut_move(KNEEL_T + Vector3(0.1, 0.62, -0.35), DUF_END + Vector3(0, 1.72, 0), 4.0)
	await _say("Dufredy", L("bow", "see"))
	main.ui.close()
	await _end()


## Hold E against it for as long as she can. The force wins.
func _resist() -> void:
	_phase = "bow"
	var k := 0.0
	var t := 0.0
	_resisted = 0.0
	_fade(_press, -2.0, 2.0)
	_cut_to(KNEEL_T + Vector3(-1.4, 1.2, -1.6), KNEEL_T + Vector3(0, 1.1, 0), 50.0)
	while k < 1.0 and t < 90.0:
		var dt := get_process_delta_time()
		t += dt
		var hold := _sim_hold or Input.is_action_pressed("interact")
		var push := 0.06 + t * 0.012
		var res := maxf(0.0, 0.22 - t * 0.006) if hold else 0.0
		if hold:
			_resisted += dt
		k = clampf(k + (push - res) * dt, 0.0, 1.0)
		var e := smoothstep(0.0, 1.0, k)
		_t_kneel = minf(1.0, e * 1.6)
		_pose(t_piv, turan, Vector3.ZERO, 0.0, _t_kneel, maxf(0.0, e - 0.45) * 2.0)
		var hd: Node3D = turan.get_meta("head")
		hd.rotation.x = -0.25 * (1.0 - e)
		var bar := ""
		for j in 20:
			bar += "|" if j < int(k * 20.0) else "."
		main.ui.prompt.text = L("bow", "hold") + "    [" + bar + "]"
		_shake = 0.15 + k * 0.4
		if _shake > 0.0:
			_cut.h_offset = randf_range(-1.0, 1.0) * _shake * 0.02
			_cut.v_offset = randf_range(-1.0, 1.0) * _shake * 0.02
		await get_tree().process_frame
	_cut.h_offset = 0.0
	_cut.v_offset = 0.0
	_t_kneel = 1.0
	_pose(t_piv, turan, Vector3.ZERO, 0.0, 1.0, 1.1)
	main.ui.prompt.text = ""
	_phase = ""
	_fade(_press, -30.0, 3.0)


func _forner_beat(with_eyes: bool) -> void:
	main.flags["in_forner"] = "eyes" if with_eyes else "eyeless"
	if with_eyes:
		var fp := f_piv.position
		_cut_to(KNEEL_T + Vector3(-0.6, 0.8, -0.3), fp + Vector3(0, 0.3, 0), 48.0)
		await _think(L("forner", "eyes1"))
		var hd: Node3D = forner.get_meta("head")
		var g := Vector3(fp.x, 0, fp.z)
		var to_t := KNEEL_T - g
		var tw := create_tween().set_parallel(true)
		tw.tween_method(func(b: float) -> void: _pose(f_piv, forner, g, atan2(-to_t.x, -to_t.z), 1.0, b), 1.25, 0.35, 2.2)
		tw.tween_property(hd, "rotation", Vector3(-0.3, 0, 0.12), 2.2)
		await _wait(1.0)
		await _think(L("forner", "eyes2"))
	else:
		_cut_to(KNEEL_T + Vector3(0.2, 0.8, -0.2), f_piv.position + Vector3(0, 0.9, 0), 46.0)
		await _think(L("forner", "none1"))
		await _think(L("forner", "none2"))
	main.ui.close()


## Cut to black. Their fate is the epilogue's.
func _end() -> void:
	_ended = true
	main.ui.fade.color.a = 1.0
	for ap: Node in [_chant1, _chant2, _murmur, _wind, _flies, _press, _hum, _rotor]:
		if ap and is_instance_valid(ap):
			(ap as Node).set("volume_db", -80.0)
	main.play("off", -6.0, 0.5)
	await _wait(2.0)
	main.flags["turan_interlude_done"] = true
	main.flags["interlude_done"] = true
	main.log_line("interlude", L("end", "log"))
	_restore_fp()
	main.update_hud()
	if not main._selftest:
		main.load_level("River")


# ------------------------------------------------------------------ hooks

func interact(node: Object) -> bool:
	var id := str(node.get_meta("id"))
	var f: Dictionary = main.flags
	if id == "emmet":
		if _tp and f.has("in_start") and not f.has("in_slap") and not _busy:
			_busy = true
			await _slap()
			_busy = false
			main.update_hud()
		elif f.has("in_bound") or f.has("interlude_done"):
			await _think(L("emmet", "end"))
		elif f.has("in_chamber"):
			await _say("Emmet", L("emmet", "chamber"))
		elif f.has("in_slap"):
			await _say("Emmet", L("emmet", "hall"))
		else:
			await _think(L("intro", "dead"))
		return true
	if id == "right_door" and not f.has("in_slap"):
		main.play("slam", -10.0, 1.6)
		_shake = 0.3
		await _say("Turan", L("intro", "cry"))
	if LINES["look"].has(id):
		var look: Array = LINES["look"][id]
		for k in range(1, look.size()):
			if str(look[k]) != "":
				await _think(str(look[k]))
		return true
	return false


func objective() -> String:
	var f: Dictionary = main.flags
	if _ended or f.has("in_dufredy"):
		return ""
	if f.has("in_eyes"):
		return L("objective", "run")
	if f.has("in_chamber"):
		return L("objective", "centre")
	if f.has("in_bed"):
		return L("objective", "follow")
	if f.has("in_slap"):
		return L("objective", "hall")
	if f.has("in_start"):
		return L("objective", "emmet")
	return ""


func phone() -> String:
	return L("phone", "text")


func scan_people() -> Array:
	return []


## Dev args for shots: stage=hall|bed|chamber|circle|eyes|door|bow, at=x,z
## (or x,y,z), yaw, pitch, forner=cover (Forner with eyes), drone=height,
## cut=fx,fy,fz,tx,ty,tz (a fixed camera). The stage sets the
## flags and the people as the beats would have left them; nothing fires.
func apply_args(a: Dictionary) -> void:
	if a.has("forner"):
		main.flags["forner_case_ending"] = str(a["forner"])
		_forner_place(_forner_has_eyes())
	var stage := str(a.get("stage", ""))
	if stage != "":
		_no_trig = true
		_stage(stage)
	if a.has("drone"):
		drone.visible = true
		drone.position = CC + Vector3(0, float(a["drone"]), 0)
	if a.has("at"):
		var v: PackedStringArray = str(a["at"]).split(",")
		if v.size() == 2:
			tb.global_position = Vector3(float(v[0]), 0.1, float(v[1]))
		elif v.size() == 3:
			tb.global_position = Vector3(float(v[0]), float(v[1]), float(v[2]))
		_trail.clear()
		if _e_state == "follow":
			_e_pos = tb.global_position + Basis(Vector3.UP, _yaw) * Vector3(-0.9, 0, 1.6)
			_e_pos.y = 0.0
	if a.has("yaw"):
		_yaw = deg_to_rad(float(a["yaw"]))
		_t_yaw = _yaw
	if a.has("pitch"):
		_pitch = deg_to_rad(float(a["pitch"]))
	main.player.yaw = 0.0
	main.player.pitch = 0.0
	main.player.position = spawn
	if a.has("cut"):
		var c: PackedStringArray = str(a["cut"]).split(",")
		if c.size() == 6:
			_cut_to(Vector3(float(c[0]), float(c[1]), float(c[2])), Vector3(float(c[3]), float(c[4]), float(c[5])), 56.0)
			return
	_follow()


func _stage(stage: String) -> void:
	var f: Dictionary = main.flags
	var order := ["hall", "bed", "chamber", "circle", "eyes", "door", "bow"]
	var n := order.find(stage)
	f["in_start"] = true
	# door and bow are held poses for shots: no walking, no prompts
	_ctl = n < 5
	if n >= 0:
		f["in_slap"] = true
		f["in_walk1"] = true
		f["in_talk"] = true
		hall_gate.collision_layer = 0
		_e_sit = 0.0
		_e_state = "follow"
		var eh: Node3D = emmet.get_meta("head")
		eh.rotation = Vector3.ZERO
		for a in emmet.get_meta("arms"):
			(a as Node3D).rotation = Vector3.ZERO
		for l in emmet.get_meta("legs"):
			(l as Node3D).rotation = Vector3.ZERO
		for kn in emmet.get_meta("knees"):
			(kn as Node3D).rotation = Vector3.ZERO
	if n >= 1:
		f["in_bed"] = true
	if n >= 2:
		f["in_chamber"] = true
	if n >= 3:
		f["in_circle"] = true
		_chanting = true
		_chant_k = 1.0
		package.reparent(dyn)
		package.global_position = CC + Vector3(0, 0.4, 0)
		f["in_drone"] = true
	if n >= 4:
		f["in_eyes"] = true
		for k in 2:
			(mm_camp_sit[k] as MultiMesh).visible_instance_count = 0
		for mmi in dyn.get_children():
			if mmi is MultiMeshInstance3D and (mmi as MultiMeshInstance3D).multimesh in mm_camp_stand:
				(mmi as MultiMeshInstance3D).visible = true
		_camp_up = true
	if n >= 5:
		f["in_dufredy"] = true
		d_piv.visible = true
		if not _forner_eyes:
			f_piv.visible = true
		_e_state = "posed"
		_e_pos = DUF_DOOR + Vector3(-0.8, 0, -4.0)
		_e_yaw = PI
		knife.visible = true
		tb.global_position = DUF_DOOR + Vector3(0.7, 0.05, -4.4)
		_t_yaw = PI
		_yaw = PI
	if n >= 6:
		f["in_bound"] = true
		_drop_torch(DUF_DOOR + Vector3(1.1, 0.08, -4.1))
		_setup_bound()
		_e_kneel = 1.0
		_e_bow = 1.2
		_t_posed = true
		_t_kneel = 0.7
		_pose(t_piv, turan, Vector3.ZERO, 0.0, 0.7, 0.2)
		for a in turan.get_meta("arms"):
			(a as Node3D).rotation = Vector3(0.45, 0, 0)
		for g: Array in grabbers:
			(g[0] as Node3D).visible = true
			for a in (g[1] as Node3D).get_meta("arms"):
				(a as Node3D).rotation = Vector3(-1.1, 0, 0)
		_yaw = 0.0
	main.update_hud()


func _node_by_id(id: String) -> Node:
	for n in main._all_with_meta(self, "id"):
		if is_instance_valid(n) and str(n.get_meta("id")) == id:
			return n
	return null


## Put her somewhere (the self-test's legs), Emmet a step behind.
func _put(p: Vector3) -> void:
	tb.global_position = p + Vector3(0, 0.1, 0)
	tb.velocity = Vector3.ZERO
	_trail.clear()
	if _e_state == "follow":
		_e_pos = Vector3(p.x, 0, p.z) + Vector3(0.6, 0, 1.2)
	for k in 3:
		await get_tree().physics_frame


func _wait_flag(fl: String, secs: float) -> bool:
	var t := 0.0
	while not main.flags.has(fl) and t < secs:
		await get_tree().process_frame
		t += get_process_delta_time()
	if not main.flags.has(fl):
		print("WARN interlude: timed out waiting for ", fl)
		return false
	return true


## Headless: the slam, the door, the slap, then Turan is set down at each
## trigger along the hall and the chamber and the beats fire on their own
## (the pump picks choice 2: "a trick", "a few more moments of sanity");
## the knife is swung once, the bow held for a while and let go. Then the
## other choices (Lynx "part of this", "we're being watched") and the other
## Forner, and every interactable twice. Every wait has a deadline.
func selftest() -> void:
	# llvmpipe is slow and every line of dialogue costs a frame: the level is
	# hidden while the script runs (it still ticks, collides and plays)
	visible = false
	if not _tp:
		_tp_on()
	await _intro_beat()
	print("ok intro")
	await main.interact(_node_by_id("right_door"))
	await main.interact(emmet_it)
	print("ok slap ", main.flags.has("in_slap"), " gate=", hall_gate.collision_layer)
	await _put(Vector3(-1.8, 0, -9.0))
	await _wait_flag("in_walk1", 10.0)
	await _put(Vector3(-1.8, 0, -26.0))
	await _wait_flag("in_talk", 160.0)
	print("ok talk lynx=", main.flags.get("in_lynx", ""))
	await _lynx_reply(0)
	main.ui.close()
	print("ok lynx part=", main.flags.get("in_lynx", ""))
	await _put(Vector3(-25.6, 0, -48.0))
	await _wait_flag("in_bed", 120.0)
	print("ok bed")
	await _put(Vector3(-25.6, 0, -98.0))
	await _wait_flag("in_chamber", 160.0)
	print("ok chamber told=", main.flags.has("in_told"))
	await _watched_reply(0)
	main.ui.close()
	print("ok told=", main.flags.has("in_told"))
	await _put(CC + Vector3(-2.0, 0, 13.0))
	await _wait_flag("in_eyes", 200.0)
	print("ok circle drone eyes ", main.flags.has("in_circle"), main.flags.has("in_drone"), main.flags.has("in_eyes"))
	_sim_swing = true
	_sim_hold = true
	_release_hold(6.0)
	await _put(DOOR_C + Vector3(0.5, 0, -7.0))
	await _wait_flag("interlude_done", 400.0)
	print("ok end swung=", main.flags.has("in_swung"), " resisted=", main.flags.get("turan_resisted", -1),
		" forner=", main.flags.get("in_forner", ""), " done=", main.flags.has("interlude_done"), " turan=", main.flags.has("turan_interlude_done"))
	# the other Forner, for the script's sake
	_tp_on()
	_forner_place(not _forner_eyes)
	f_piv.visible = true
	await _forner_beat(_forner_eyes)
	print("ok forner other=", main.flags.get("in_forner", ""))
	_restore_fp()
	_card_off()
	main.ui.fade_to(0.0, 0.1)
	await main.selftest_all_interactables()
	visible = true


func _release_hold(after: float) -> void:
	var t := 0.0
	while t < 300.0 and _phase != "bow":
		await get_tree().process_frame
		t += get_process_delta_time()
	await _wait(after)
	_sim_hold = false


# ------------------------------------------------------------------ textures

## "A faded green, brick-lined hallway": green-grey brick, black mortar, damp.
func _brick_tex() -> ImageTexture:
	var img := Image.create(256, 256, false, Image.FORMAT_RGBA8)
	img.fill(Color(0.035, 0.04, 0.035))
	var r := RandomNumberGenerator.new()
	r.seed = 27
	for row in 16:
		var off := (row % 2) * 32
		for col in 5:
			var x0 := col * 64 - off
			var c := Color(0.16, 0.18, 0.15).lerp(Color(0.25, 0.27, 0.22), r.randf())
			if r.randf() < 0.12:
				c = c.lerp(Color(0.3, 0.22, 0.16), 0.6)
			for xs: int in [x0, x0 + 256]:
				var rr := Rect2i(xs + 1, row * 16 + 1, 62, 14).intersection(Rect2i(0, 0, 256, 256))
				if rr.size.x > 0:
					img.fill_rect(rr, c)
	for k in 2600:
		var x := r.randi() % 256
		var y := r.randi() % 256
		var c2 := img.get_pixel(x, y)
		img.set_pixel(x, y, c2.darkened(r.randf_range(0.0, 0.45)) if r.randf() < 0.75 else c2.lightened(0.12))
	# damp creeping up from the floor
	for x in 256:
		var h := 40 + int(18.0 * sin(x * 0.05) + r.randf_range(0, 10))
		for y in range(256 - h, 256):
			var c3 := img.get_pixel(x, y)
			img.set_pixel(x, y, c3.darkened(0.35 * float(y - (256 - h)) / h))
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


## The green eye and the arrow, as the tunnels paint it (ch.25).
func _glyph_mat() -> StandardMaterial3D:
	var n := 96
	var img := Image.create(n, n, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	var c := Vector2(n * 0.5, n * 0.36)
	for y in n:
		for x in n:
			var u := (x - c.x) / (n * 0.4)
			var v := (y - c.y) / (n * 0.22)
			if absf(u) <= 1.0:
				var lid := 1.0 - u * u
				var av := absf(v)
				if absf(av - lid) < 0.16 or Vector2(u * 2.0, v).length() < 0.42:
					img.set_pixel(x, y, Color(1, 1, 1, 0.92))
			# the arrow under it, pointing on
			var ax := x - n * 0.5
			var ay := y - n * 0.78
			if absf(ay) < 2.5 and ax > -n * 0.3 and ax < n * 0.2:
				img.set_pixel(x, y, Color(1, 1, 1, 0.92))
			if ax > n * 0.08 and ax < n * 0.3 and absf(ay) < (n * 0.3 - ax) * 0.6 and absf(ay) > (n * 0.3 - ax) * 0.6 - 4.0:
				img.set_pixel(x, y, Color(1, 1, 1, 0.92))
	img.generate_mipmaps()
	var m := StandardMaterial3D.new()
	m.albedo_texture = ImageTexture.create_from_image(img)
	m.albedo_color = PSYON_GREEN
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	return m
