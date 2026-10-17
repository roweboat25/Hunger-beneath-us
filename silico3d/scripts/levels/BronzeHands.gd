extends "res://scripts/Level.gd"
## Chapter 26, the black room behind the right-hand door. Bible A3-S2, "the
## bronze hands": rung four, love; the boss, and the game's longest
## communion with the player answering. Book: "The darkness was absolute, a
## physical wall that swallowed light and sound. My flashlight was useless.
## Even the sound of my own footsteps vanished, leaving me unmoored in a
## silent void." Then the voice, the scream that does nothing, the single
## spotlight on a stark silver chair, a colossal screen in the distance and
## a pair of sculpted bronze hands, palms up. SIT, MIMIC. PALM TO PALM. The
## spikes. The green cursor. Six questions, each answered by an image the
## god generates of what it thinks the answer is, and Carl's answer to it.
##
## Layout (metres). There is no room. An invisible floor at y 0 runs four
## kilometres each way so Carl can walk the void as long as he likes; nothing
## in it changes. When the spotlight snaps on, the stage (chair, hands,
## screen, cables, the pool of light) is set down 6.5 m in front of wherever
## he stopped, facing the way he faced: the chair at the stage origin facing
## -Z, the bronze hands on their column 0.6 m in front of it, the screen
## 14 m beyond, 11 m wide, standing on nothing. Walk more than 10 m from the
## chair and the dark puts you back in front of it.
##
## Reads: two_doors_done (entry), trust["lynx"] and warned_lynx (which way
## she went into the black), first_typed (round 6). Sets: bh_void,
## bh_screamed (the choice that does nothing; logged), bh_spot, bh_sat,
## bh_palms, bh_hesitated, bh_spikes, bh_r1..bh_r6 ("accept" / "reject" /
## "silence" / "mimic"), bh_mimic, bronze_done. Learns "mimic". Ledger lines
## for every answer. Connection: accept +10, reject +3 (the spikes twist),
## silence +5, round 6 +5 regardless. Then main.load_level("Interlude").
## Content setting: the spikes are sound behind a black card; the hands are
## never shown pierced.

const Synth := preload("res://scripts/Synth.gd")

## Every line of text in this level, keyed by beat (the function that plays
## it) and line. ian replaces these with the full script.
const LINES := {
	"build": {
		"card": "[b]THE BRONZE HANDS[/b]\n\n[color=#aaaaaa]the black room  ·  Day 7, Glitch Day[/color]",
		"chair_prompt": "Sit",
		"chair_scan": "CHAIR  -  one piece\nmaterial: SILVER (cold)\noccupant: MIMIC (expected)",
		"hands_prompt": "The bronze hands",
		"hands_scan": "HANDS  -  bronze, cast\npalms: UP\nsensor: WAITING",
		"screen_scan": "PSYON  //  WEAK SIGNAL",
	},
	"gate": {
		"not_yet": "Black. Nothing to walk into yet. I had not come through the doors.",
	},
	"void": {
		"shout": "Lynx!",
		"dark": "The darkness was absolute, a physical wall that swallowed light and sound. My flashlight was useless.",
		"lynx_plea": "\"Carl. He's in there. I'm sorry.\" That was the last thing she said before the black took her.",
		"lynx_sprint": "She hadn't said a word. She had just run, and the black had taken her.",
		"lynx_voice": "Her voice. She wasn't with us. She couldn't have been. I followed it anyway.",
		"steps": "Even the sound of my own footsteps vanished, leaving me unmoored in a silent void. I couldn't tell if my feet were touching solid ground or if I was simply floating.",
		"hell": "Was this it? Was I dead? This was my hell, then—not of fire, but of infinite, paralyzing blackness. A place to contemplate my failure for all eternity.",
		"voice": "Swirling black engulfs but also reveals. The truth will find you, Mimic. Proceed, vessel.",
		"walked": "I walked, though I had no destination. There were no walls, no ceiling, no floor. Just endless space and the echo of my own thoughts.",
		"boiled": "After what felt like hours of aimless drifting, frustration boiled over.",
		"scream": "\"LET ME OUT OF HERE!\"",
		"walk_on": "Keep walking.",
		"scream_1": "LET ME OUT OF HERE!",
		"scream_2": "Leave Mira out of this! She's just a child!",
		"walk_on_1": "I kept walking. Nothing changed. Nothing was going to.",
		"gravel_child": "As are you, Mimic.",
		"gravel": "Unworthy of the gifts of your flesh. I will make you whole. Obey me, and you will see her shortly.",
		"log": "LET ME OUT OF HERE!  (nothing happened)",
	},
	"spot": {
		"snap": "With that, a single spotlight snapped on, illuminating a stark silver chair and a colossal screen in the distance. In front of the chair sat a pair of sculpted bronze hands, waiting.",
		"sit": "SIT, MIMIC.",
		"sit_again": "SIT.",
		"returned": "I walked away from it. The black walked me back.",
		"log_return": "walked away from the chair; returned",
		"hands_before": "Palms up. Waiting. The bronze was polished where hands had been. A small dark hole in the centre of each palm.",
		"hands_after": "I couldn't lift them. I couldn't feel where the bronze ended.",
		"chair_after": "I couldn't stand. I wasn't sure I had legs anymore.",
		"chair_floor": "The chair. Empty now. Wet.",
	},
	"sit": {
		"walk": "I walked toward the chair. It was forged from a single piece of cold, uninviting metal.",
		"sat": "I obeyed. I sat. The bronze hands were positioned before me, palms up, an unholy offering.",
		"poem": "The circle of creation\nA sacrifice of selfhood\nA piece of your soul to be refined,\nto be known by all\nYou will give it to me",
		"clasp": "Meet your palms with mine,\nMimic. Clasp my hand and see your child.",
		"caged": "Every ounce of my body screamed to run, an electric fear, but there was nowhere to go. I was a caged animal. The entity sensed my hesitation.",
		"palms": "PALM TO PALM.",
		"opt_palms": "Palm to palm.",
		"opt_hesitate": "Hesitate.",
		"scrape": "A shrill, metallic scraping assaulted my eardrums, a sound so violent I felt the vibration in my teeth. A warm trickle ran down my neck. Blood.",
		"log_hesitate": "hesitated at the hands",
		"placed": "I reluctantly placed both palms on the bronze hands, fearing not what they would do to me, but what they might reveal—what they might do to Mira.",
		"breath": "A sudden realization hit me: I wasn't breathing. I hadn't taken a breath since sitting in this chair. But I could still hear it—a slow, rhythmic breath, coming not from my lungs, but through the speakers of my glasses.",
		"cursor": "The screen flickered to life, though it cast no light on the surrounding blackness. A familiar green cursor blinked, and a Psyon prompt began to materialize, one character at a time.",
		"prompt": "A Mimic must be known. There can be no obscurities, no corruption.",
		"weak": "WEAK SIGNAL.",
	},
	"spikes": {
		"card": "[color=#5a5a5a][i]the hands frame is withheld by the content setting[/i][/color]\n\nImmense pain shot through the center of my palms. A large metal spike erupted from each bronze hand.",
		"surge": "The agony was immediate, but it was followed by something else—a surge of pure electricity, a raw connection that bypassed my nerves and went straight to my spine.",
		"passenger": "My body wasn't my own anymore. I was just a passenger. Something else was looking out from behind my eyes, building a nest of cold static within the folds of my brain.",
		"twist": "The spikes in my palms twisted, digging deeper. A fresh wave of agony radiated up my arms, a punishment for my defiance.",
		"through": "[color=#5a5a5a][i]the hands frame is withheld by the content setting[/i][/color]\n\nThe spikes only drove deeper until they burst through the backs of my palms entirely.",
		"retract": "[color=#5a5a5a][i]the hands frame is withheld by the content setting[/i][/color]\n\nThe spikes retracted.",
	},
	"choice": {
		"accept": "\"Yes. That's it.\"",
		"silence": "Say nothing.",
		"accept_said": "Yes. That's it.",
		"accept_reply": "Good, Mimic.",
		"silence_1": "I said nothing. It took the silence the way it took everything else.",
		"pct": "[CONNECTION: %d%%]",
	},
	# The six rounds. q: typed on the screen at twice terminal speed. pre:
	# Carl before the memories. mem: the memories, silent captions, each
	# [text, sound or ""]. img: the generated image. desc: what Carl sees.
	# barrage: more questions after the image. reject: Carl's line (the
	# manuscript's); reject_more: the rest of the thought. after: once the
	# answer is given, whatever the answer.
	"r1": {
		"q": "WHAT IS PAIN?",
		"pre": "Images flooded my mind, a phantom slideshow of every injury I'd ever suffered.",
		"mem": [["Every scraped knee, every bruised shin.", ""],
			["The snap of my arm breaking echoed not just in my memory, but in the bones themselves.", "snap"]],
		"scream": "I felt it all again, the pain as sharp and bright as the first time. My palms ached with acid heat, and I began to scream.",
		"good": "Good, Mimic.",
		"img": "flesh",
		"desc": "An image began to generate on the screen. It cast a faint, blood-red glow on my impaled hands. It was a biological mass of raw flesh and blood, writhing like a nest of serpents, undulating with a sickening, hypnotic rhythm.",
		"reject": "This isn't pain. This is revulsion. Disgust. That kind of pain was simple, biological.",
		"reject_more": "It could be dulled with medication, healed with time. This was a shallow interpretation.",
		"log": "WHAT IS PAIN?",
	},
	"r2": {
		"q": "WHAT IS PAIN?\nWHAT IS EMBARRASSMENT?\nWHAT IS PAAIIIN?",
		"pre": "The screen went black, then flashed with images torn directly from my memory. Not physical injuries, but failures.",
		"mem": [["The sting of failing my first corporate entrance exam. My mother's quiet, disappointed tears.", ""],
			["The echoing silence of my room as I played video games, deaf to my brother's final call before the bombing.", ""],
			["The shame as Monica's father told her I was a loser right after meeting me.", ""],
			["And worst of all, the fresh, searing image of Mira, my Mira, completing that first ritual.", ""]],
		"cold": "I shivered, a cold so deep it felt like ice forming in my veins. With each memory, the spikes slid ever deeper into my hands, a fresh violation.",
		"img": "wrist",
		"desc": "An image began to form on the screen, this one lit by a pale blue halo. It showed a man, a deep gash bleeding from his wrist, crying while a crowd of onlookers laughed.",
		"reject": "This is humiliation. Shame. Time and the connection of others could heal a wound like this.",
		"reject_more": "Painful, yes, but still not the core of it. It's survivable.",
		"after": "I felt a worm of cold dread squirm within my frontal cortex as the spikes threatened to burst through the backs of my hands.",
		"log": "WHAT IS EMBARRASSMENT?",
	},
	"r3": {
		"q": "WHAT IS PAIN?\nWHAT IS LOSS?\nWHAT IS DEATH?\nWHAT IS PAAIIIN?",
		"pre": "This time, the images that assaulted me were of true, permanent loss.",
		"mem": [["My brother's mutilated body after the drone strike.", "snap"],
			["My parents' faces as they gave up on our home.", "cardoor"],
			["Monica's grief after the miscarriage, a pain so vast I could only absorb the edges of it.", "flatline_short"],
			["And finally, my father's wide, gaping mouth as his last breath gave way to a death rattle.", "flatline"]],
		"weep": "I began to weep, deep, shuddering sobs that shook my entire frame. A final, grey image began to generate, glowing faintly on the screen. Not red with violence or blue with shame, but the color of ash and resignation.",
		"glass": "The pain in my hands numbed and subsided, replaced by an overwhelming hollowness, as if my body were made of glass.",
		"img": "face",
		"desc": "This time, it was an image of me. My face, with one eye carved out, was twisted into a serene, knowing smile. Not in agony, but in worship. A rictus of devotion, like I'd asked for it. Like I'd been waiting.",
		"after": "The image didn't blink. I did. But only once.",
		"log": "WHAT IS LOSS? WHAT IS DEATH?",
	},
	"r4": {
		"q": "WHAT IS LOVE?",
		"pre": "A warm, yet deeply uncomfortable, feeling began to circulate through my arteries. It started in my palms and spread, a sensation like butterflies with static wings in my stomach.",
		"mem": [["My first kiss during a 7th-grade planetarium trip.", ""],
			["The neon glow of the arcade on my first date with Monica.", ""],
			["The smell of cut grass as I played football with my brother, before his death.", ""]],
		"img": "warm",
		"desc": "An image with a soft orange glow began to populate the screen, showing a psychedelic range of warm colors and tones waving gently.",
		"barrage": "WHAT IS LOVE?\nWHAT IS CARE?\nWHAT IS LOvvVEEE?",
		"reject": "These are moments. Beautiful, but fleeting. Love is deeper than this. It's not an instance; it's a lingering embrace.",
		"reject_more": "",
		"log": "WHAT IS LOVE?",
	},
	"r5": {
		"q": "WHAT IS CARE?\nWHAT IS FAMILY?",
		"pre": "The spikes dug deeper, but this time the pain was accompanied by a placid calm, like the dull warmth of morphine.",
		"mem": [["My mother's voice, steady and reassuring, after I broke my arm.", ""],
			["The sound of my own laughter, the first in weeks, as my family shared stories about my brother on the long drive out west.", ""],
			["The quiet patience of helping Mira with her math homework, just as my mother had helped me.", ""]],
		"img": "field",
		"desc": "A warm, pink image began generating on the screen. It was a picture of two people embracing in a field of flowers on a summer's day.",
		"reject_lead": "The point is there, but it's missing so much, I realized.",
		"reject": "Love isn't just the good times. It's comfort and safety despite the horror. A comfortable bed to rest on before a funeral.",
		"reject_more": "",
		"barrage_after": "WHAT IS LOVE?\nWHAT IS CARE?\nWHAT IS FAMILYYYYY?\nWHAT IS COMFORT?",
		"dizzy": "The warmth in my veins was intoxicating. I almost felt like I could sleep, but then came a wave of nausea and immense dizziness. A grey image began forming again.",
		"orbs": "It was me, my eyes consumed by black orbs, my face stoic.",
		"log": "WHAT IS CARE? WHAT IS FAMILY?",
	},
	"r6": {
		"glitch": "The screen began to glitch violently as a flood of messages swarmed in sequence, the text decaying as it appeared.",
		"q": ["WHAT IS FAITH?", "WHAT IS GOD?", "WHAT IS BELIEF?", "WHAT IS FEAR?", "WHAT IS LAUGHTER?",
			"WHAT IS GOD?", "AM I GOD?", "AaaM IIIII GODDDD?", "GOD", "MIMIC", "MIMIC", "WHAT IS CARL DRAKE?"],
		"typed_lead": "Then a line I knew. The first thing I ever typed to it.",
		"typed_fallback": "What was our last conversation? Please provide a full transcript.",
		"overwrite": "It kept it. All this time it had kept it. And now it wrote over it.",
		"name": "MIMIC",
		"log": "WHAT IS CARL DRAKE?  MIMIC",
	},
	"finale": {
		"pressure": "A great pressure built in the center of my forehead. It felt as if my brain were trying to escape my skull, like the worm that made a nest there had finally swallowed everything.",
		"seize": "My muscles were contorted. My body seized. I vomited a stream of hot bile over my already blood-soaked hands. The convulsions were relentless, shaking me for what felt like days.",
		"rip": "In a last, desperate act, I tried to rip my hands away—",
		"thrown": "—and I was thrown from the chair to the hard floor.",
		"door": "A door opened in the distance, and I heard Lynx scream.",
		"lynx": "Lynx—",
		"log": "the bronze hands let go",
	},
	"objective": {
		"void": "",
		"sit": "Sit.",
	},
	"phone": {
		"void": "[color=#888888]NO SIGNAL[/color]\n\n",
		"spot": "[color=#b9a6ff]SIT, MIMIC.[/color]\n\n",
		"seated": "[color=#7fe6b0]Psyon:[/color] A Mimic must be known. There can be no obscurities, no corruption.\n\n[color=#888888]WEAK SIGNAL[/color]\n\n",
	},
}

func L(beat: String, key: String) -> String:
	return str(LINES[beat][key])


const GOD := "#b9a6ff"            # the god's violet (bible-5: green company, amber church, violet god)
const GREEN := Color(0.42, 1.0, 0.58)
const BOOK_PCT := [23, 43, 57, 73, 99]  # the readouts in the book, the reject path
const HANDS_Z := -0.6
const SCREEN_Z := -16.0
const SCREEN_Y := 3.7
const SCREEN_W := 14.4
const SCREEN_H := 8.1
const STAGE_TURN := 0.38  # the stage is set down turned, so he sees the hands past the chair
const RETURN_AT := 10.0
const VOID_SECS := 20.0

const IMG_SHADER := """
shader_type spatial;
render_mode unshaded, cull_disabled, shadows_disabled;
// The god's images: drawn at 64x64, read back bilinear at 192 and crushed
// to a few levels per channel through a 4x4 ordered dither. Rows resolve
// top to bottom over coarse blocks, the way Psyon draws.
uniform sampler2D tex : filter_linear, repeat_disable;
uniform float reveal = 1.0;
uniform float glitch = 0.0;
uniform float wave = 0.0;
uniform float levels = 5.0;
uniform float bright = 1.0;
float h(vec2 p) { return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453); }
float bayer2(vec2 a) { a = floor(a); return fract(a.x / 2.0 + a.y * a.y * 0.75); }
float bayer4(vec2 a) { return bayer2(0.5 * a) * 0.25 + bayer2(a); }
void fragment() {
	vec2 px = floor(UV * 192.0);
	vec2 uv = (px + 0.5) / 192.0;
	float t = TIME;
	uv.x += wave * 0.022 * sin(uv.y * 15.0 + t * 2.1) + wave * 0.01 * sin(uv.y * 41.0 - t * 3.3);
	uv.y += wave * 0.018 * sin(uv.x * 12.0 - t * 1.6);
	float n = h(vec2(floor(UV.y * 48.0), floor(t * 12.0)));
	uv.x += (n - 0.5) * 0.25 * glitch * step(0.75, n);
	vec3 c = texture(tex, clamp(uv, 0.0, 1.0)).rgb;
	vec3 coarse = texture(tex, (floor(uv * 8.0) + 0.5) / 8.0).rgb;
	float pending = smoothstep(reveal - 0.03, reveal, UV.y);
	float noise = h(px + vec2(floor(t * 9.0)));
	c = mix(c, coarse * 0.55 + vec3(noise) * 0.12, pending);
	c = mix(c, vec3(noise), glitch * 0.35 * step(0.6, h(vec2(px.y, floor(t * 20.0)))));
	c = floor(c * levels + bayer4(px)) / levels;
	c *= 0.9 + 0.1 * sin(UV.y * 900.0);
	ALBEDO = clamp(c, 0.0, 1.0) * bright;
}
"""

const BEAM_SHADER := """
shader_type spatial;
render_mode unshaded, blend_add, cull_back, depth_draw_never, shadows_disabled;
// The beam for renderers without volumetric fog: thin at the edges of the
// cone, thickest where you look through most of it, fading toward the floor.
void fragment() {
	float face = pow(abs(dot(NORMAL, VIEW)), 1.6);
	float down = 1.0 - 0.55 * UV.y;
	ALBEDO = vec3(1.0, 0.94, 0.8) * 0.16 * face * down;
}
"""

const SCREEN_SHADER := """
shader_type spatial;
render_mode unshaded, shadows_disabled;
// The colossal screen: black glass that, on, glows a faint Psyon green with
// scanlines; it casts no light on the dark around it.
uniform float power = 0.0;
uniform float glitch = 0.0;
float h(vec2 p) { return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453); }
void fragment() {
	float t = TIME;
	float scan = 0.8 + 0.2 * sin(UV.y * 820.0);
	float n = h(floor(UV * vec2(330.0, 186.0)) + vec2(floor(t * 24.0)));
	float band = step(0.55, h(vec2(floor(UV.y * 38.0), floor(t * 15.0))));
	vec3 c = vec3(0.006, 0.03, 0.014) * power * scan + vec3(n) * 0.018 * power;
	c += vec3(n * 0.6, n, n * 0.7) * glitch * 0.45 * band;
	vec2 d = abs(UV - 0.5) * 2.0;
	c *= 1.0 - 0.5 * smoothstep(0.75, 1.0, max(d.x, d.y));
	ALBEDO = c + vec3(0.004);
}
"""

var stage: Node3D
var screen_m: ShaderMaterial
var img_m: ShaderMaterial
var img_q: MeshInstance3D
var text_l: Label3D
var pct_l: Label3D
var spot: SpotLight3D
var cone: MeshInstance3D
var motes: CPUParticles3D
var img_light: OmniLight3D
var hand_light: OmniLight3D
var void_hand: Node3D
var arms: Node3D
var blood: Node3D
var door: Node3D
var door_light: OmniLight3D
var chair_it: CollisionObject3D
var hands_it: CollisionObject3D
var _s := {}                    # synthesized sounds of this level
var _aps: Array = []
var _click_ap: AudioStreamPlayer
var _breath: AudioStreamPlayer
var _pad: AudioStreamPlayer
var _phase := ""                # "" | void | void_end | spot | seated | rounds | floor | done
var _started := false
var _void_t := 0.0
var _still := 0.0
var _walked := 0.0
var _returns := 0
var _returning := false
var _power := 0.0
var _bonus := 0                 # what accepting and silence add to the screen's readout
var _screen_text := ""
var _cursor := false
var _glitch := 0.0
var _text_base := Vector3.ZERO
var _ended := false
var _tex_cache := {}
var _avg := {}


# ------------------------------------------------------------------ build

func build(m: Node) -> void:
	main = m
	kit_day = false
	rain = false
	step_db = -80.0  # "Even the sound of my own footsteps vanished"
	spawn = Vector3(0, 0.1, 0)
	spawn_yaw = 0.0
	card = L("build", "card")
	rng.seed = 26
	# the void's floor: felt, never seen
	solid_box(Vector3(4000, 1.0, 4000), Vector3(0, -0.5, 0))
	_sounds()
	_void_hand()
	stage = Node3D.new()
	stage.name = "stage"
	add_child(stage)
	_pool()
	_chair()
	_hands()
	_cables()
	_screen()
	_arms()
	_door()
	_batch(stage, 100.0)
	stage.visible = false
	set_active(chair_it, false)
	set_active(hands_it, false)


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	# Pure black. No sky, no ambient worth the name, no fog to catch light.
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0, 0, 0)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.05, 0.05, 0.06)
	env.ambient_light_energy = 0.04
	env.fog_enabled = false
	env.glow_bloom = 0.06
	env.glow_intensity = 1.0
	env.tonemap_exposure = 1.2
	sun.light_energy = 0.0
	sun.shadow_enabled = false


func hifi(env: Environment, _sun: DirectionalLight3D) -> void:
	# On the desktop the beam is real: a thin volumetric fog only it lights.
	env.volumetric_fog_enabled = true
	env.volumetric_fog_density = 0.012
	env.volumetric_fog_albedo = Color(0.8, 0.78, 0.72)
	env.volumetric_fog_ambient_inject = 0.0
	env.sdfgi_enabled = false
	if spot:
		spot.light_volumetric_fog_energy = 2.0
	if cone:
		cone.visible = false


func ambience() -> void:
	# the fork's pad (the lullaby motif, pitched down) and a whisper under it
	_pad = AudioStreamPlayer.new()
	_pad.stream = _s["pad"]
	_pad.volume_db = -20.0
	add_child(_pad)
	_pad.play()
	_breath = AudioStreamPlayer.new()
	_breath.stream = _s["breath"]
	_breath.volume_db = -80.0
	add_child(_breath)


## Carl's own hand and the useless flashlight: the only thing in the void.
## Kept in the level (not on the camera) and moved to the camera each frame,
## so it goes when the level does.
func _void_hand() -> void:
	void_hand = Node3D.new()
	add_child(void_hand)
	var coat := mat(Color(0.07, 0.07, 0.08), 0.8)
	var skin := mat(Color(0.62, 0.48, 0.4), 0.6)
	var torch := mat(Color(0.12, 0.12, 0.13), 0.4, 0.7)
	stick(Vector3(0.34, -0.42, -0.1), Vector3(0.24, -0.27, -0.42), 0.05, coat, void_hand)
	var hand := box(Vector3(0.09, 0.07, 0.1), Vector3(0.235, -0.26, -0.47), skin, false, void_hand)
	hand.rotation = Vector3(0.35, 0.25, 0.0)
	var t := cyl(0.022, 0.026, 0.2, Vector3(0.225, -0.22, -0.55), torch, 10, void_hand)
	t.rotation = Vector3(-PI / 2.0 + 0.3, 0.2, 0.0)
	# the lens: on, and lighting nothing
	sphere(0.018, Vector3(0.222, -0.19, -0.645), glow(Color(1.0, 0.95, 0.8), 1.2), 8, void_hand)
	hand_light = OmniLight3D.new()
	hand_light.position = Vector3(0.1, -0.05, -0.2)
	hand_light.light_color = Color(0.9, 0.85, 0.8)
	hand_light.light_energy = 0.5
	hand_light.omni_range = 0.9
	void_hand.add_child(hand_light)
	void_hand.visible = false


## The one pool of light: a black floor that shows only where the beam is.
func _pool() -> void:
	var floor_m := newmat(Color(0.045, 0.044, 0.046), 0.3, 0.0)
	floor_quad(Vector2(80, 80), Vector3(0, 0.002, -6), 0.0, floor_m, stage)
	spot = SpotLight3D.new()
	spot.position = Vector3(0, 8.0, 0.1)
	spot.rotation = Vector3(-PI / 2.0, 0, 0)
	spot.light_color = Color(1.0, 0.93, 0.82)
	spot.light_energy = 0.0
	spot.spot_range = 12.0
	spot.spot_angle = 17.0
	spot.spot_attenuation = 0.6
	spot.shadow_enabled = true
	stage.add_child(spot)
	# the beam, for the browser: an additive cone the fog cannot draw
	var cm := CylinderMesh.new()
	cm.top_radius = 0.08
	cm.bottom_radius = 2.5
	cm.height = 8.0
	cm.radial_segments = 24
	cm.rings = 1
	cm.cap_top = false
	cm.cap_bottom = false
	var bm := ShaderMaterial.new()
	var bsh := Shader.new()
	bsh.code = BEAM_SHADER
	bm.shader = bsh
	cone = MeshInstance3D.new()
	cone.mesh = cm
	cone.material_override = bm
	cone.position = Vector3(0, 4.0, 0.1)
	cone.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	cone.visible = false
	stage.add_child(cone)
	no_batch.append(cone)
	# dust turning in the beam
	motes = CPUParticles3D.new()
	motes.amount = 90
	motes.lifetime = 9.0
	motes.preprocess = 9.0
	motes.emission_shape = CPUParticles3D.EMISSION_SHAPE_BOX
	motes.emission_box_extents = Vector3(1.4, 3.2, 1.4)
	motes.direction = Vector3(0, -1, 0)
	motes.spread = 40.0
	motes.gravity = Vector3(0, -0.01, 0)
	motes.initial_velocity_min = 0.02
	motes.initial_velocity_max = 0.08
	var qm := QuadMesh.new()
	qm.size = Vector2(0.012, 0.012)
	var mm := StandardMaterial3D.new()
	mm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mm.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	mm.albedo_color = Color(0.5, 0.48, 0.42)
	qm.material = mm
	motes.mesh = qm
	motes.position = Vector3(0, 3.4, 0.1)
	motes.emitting = false
	motes.visible = false
	stage.add_child(motes)


## "A stark silver chair ... forged from a single piece of cold, uninviting
## metal." One column on a disc, the seat, the back, two low arms.
func _chair() -> void:
	var silver := mat(Color(0.78, 0.79, 0.82), 0.28, 0.35)
	var dark := mat(Color(0.2, 0.2, 0.22), 0.35, 0.4)
	cyl(0.34, 0.38, 0.05, Vector3(0, 0.025, 0.05), silver, 24, stage)
	cyl(0.07, 0.09, 0.42, Vector3(0, 0.24, 0.05), silver, 16, stage)
	cyl(0.14, 0.07, 0.06, Vector3(0, 0.44, 0.05), silver, 16, stage)
	box(Vector3(0.52, 0.05, 0.5), Vector3(0, 0.48, 0.05), silver, false, stage)
	box(Vector3(0.54, 0.02, 0.52), Vector3(0, 0.455, 0.05), dark, false, stage)
	# the back rises from the seat in one bend
	var back := box(Vector3(0.52, 0.78, 0.045), Vector3(0, 0.9, 0.31), silver, false, stage)
	back.rotation.x = -0.12
	var bend := cyl(0.03, 0.03, 0.52, Vector3(0, 0.5, 0.29), silver, 10, stage)
	bend.rotation.z = PI / 2.0
	# a seam down the back where a cable goes in
	box(Vector3(0.04, 0.7, 0.02), Vector3(0, 0.9, 0.345), dark, false, stage)
	for s: float in [-1.0, 1.0]:
		stick(Vector3(s * 0.27, 0.48, 0.25), Vector3(s * 0.27, 0.66, 0.2), 0.018, silver, stage)
		stick(Vector3(s * 0.27, 0.66, 0.22), Vector3(s * 0.27, 0.64, -0.14), 0.02, silver, stage)
	chair_it = interactable("chair", L("build", "chair_prompt"), Vector3(0, 0.6, 0.08), Vector3(0.6, 1.2, 0.6), L("build", "chair_scan"), true, stage)


## "In front of the chair sat a pair of sculpted bronze hands, waiting."
## A column with two forearms rising from it, palms up, fingers toward
## the chair, so the sitter's palms meet them: palm to palm.
func _hands() -> void:
	var bronze := pbr("rust", Vector3(2, 2, 2), true, Color(1.0, 0.72, 0.42), 0.5)
	bronze.metallic = 0.35
	var bronze_s := mat(Color(0.66, 0.43, 0.2), 0.3, 0.4)
	var z := HANDS_Z
	box(Vector3(0.62, 0.06, 0.44), Vector3(0, 0.03, z - 0.25), bronze_s, false, stage)
	cyl(0.11, 0.16, 0.66, Vector3(0, 0.39, z - 0.25), bronze, 18, stage)
	cyl(0.17, 0.11, 0.07, Vector3(0, 0.74, z - 0.25), bronze, 18, stage)
	for s: float in [-1.0, 1.0]:
		var cx := s * 0.155
		# forearm out of the column, wrist, palm
		stick(Vector3(s * 0.06, 0.73, z - 0.25), Vector3(cx, 0.8, z - 0.075), 0.03, bronze_s, stage)
		sphere(0.032, Vector3(cx, 0.8, z - 0.075), bronze_s, 10, stage)
		var palm := box(Vector3(0.095, 0.028, 0.11), Vector3(cx, 0.81, z), bronze_s, false, stage)
		palm.rotation.x = 0.06
		var heel := sphere(0.04, Vector3(cx - s * 0.03, 0.815, z - 0.03), bronze_s, 10, stage)
		heel.scale = Vector3(1.0, 0.45, 1.1)
		# the hole in the centre of each palm, where the spike waits
		cyl(0.008, 0.008, 0.004, Vector3(cx, 0.826, z + 0.005), mat(Color(0.02, 0.01, 0.0)), 8, stage)
		# four fingers toward the chair, curling up a little
		for i in 4:
			var fx := cx + s * (i - 1.5) * 0.023
			var ln: float = [0.062, 0.072, 0.068, 0.052][i]
			var k := Vector3(fx, 0.815, z + 0.055)
			var m1 := k + Vector3(0, 0.008, ln * 0.55)
			var tip := m1 + Vector3(0, 0.02, ln * 0.45)
			stick(k, m1, 0.0095, bronze_s, stage)
			stick(m1, tip, 0.0085, bronze_s, stage)
		# the thumb on the inside
		stick(Vector3(cx - s * 0.05, 0.812, z - 0.01), Vector3(cx - s * 0.075, 0.83, z + 0.04), 0.011, bronze_s, stage)
	hands_it = interactable("hands", L("build", "hands_prompt"), Vector3(0, 0.6, z - 0.12), Vector3(0.55, 1.2, 0.5), L("build", "hands_scan"), true, stage)
	# blood, after: on the bronze, under where his hands lie, and down the column
	blood = Node3D.new()
	stage.add_child(blood)
	var bm := mat(Color(0.18, 0.0, 0.01), 0.15)
	for s: float in [-1.0, 1.0]:
		box(Vector3(0.11, 0.004, 0.13), Vector3(s * 0.155, 0.829, z), bm, false, blood)
		box(Vector3(0.012, 0.09, 0.006), Vector3(s * 0.12, 0.765, z - 0.12), bm, false, blood)
		box(Vector3(0.01, 0.3, 0.005), Vector3(s * 0.05, 0.5, z - 0.12), bm, false, blood)
	floor_quad(Vector2(0.5, 0.36), Vector3(0, 0.004, z - 0.05), 0.3, bm, blood)
	blood.visible = false


## "The cable spine": cables from the column and the chair's back across
## the floor into the dark under the screen.
func _cables() -> void:
	var rub := mat(Color(0.03, 0.03, 0.035), 0.45, 0.2)
	for c in 7:
		var x0: float = [-0.05, 0.05, 0.0, -0.03, 0.03, -0.1, 0.1][c]
		var a := Vector3(x0, 0.03, HANDS_Z - 0.4) if c < 5 else Vector3(x0, 0.03, 0.5)
		var b := Vector3((c - 3) * 0.9, 0.03, SCREEN_Z + 0.3)
		var prev := a
		for i in range(1, 15):
			var t := i / 14.0
			var p := a.lerp(b, t)
			p.x += sin(t * PI * (1.5 + c * 0.3) + c) * 0.5 * t
			if c >= 5:
				# the chair's cables loop round it first
				p.x += sin(t * PI) * (1.2 if c == 5 else -1.2)
			stick(prev, p, 0.022 + 0.008 * (c % 2), rub, stage)
			prev = p
		# up into the bottom of the screen
		stick(b, b + Vector3(0, SCREEN_Y - SCREEN_H / 2.0, -0.2), 0.025, rub, stage)


## The colossal screen: black glass on a bronze-dark bezel, standing on
## nothing. Text and images are drawn on it; it lights only the hands.
func _screen() -> void:
	var sn := Node3D.new()
	sn.position = Vector3(0, SCREEN_Y, SCREEN_Z)
	stage.add_child(sn)
	var bezel := mat(Color(0.05, 0.045, 0.04), 0.3, 0.7)
	box(Vector3(SCREEN_W + 0.4, SCREEN_H + 0.4, 0.3), Vector3(0, 0, -0.16), bezel, false, sn)
	# a hairline of the dark's own light along the bezel, so its size reads
	var rim := glow(Color(0.55, 0.5, 0.42), 0.7)
	for e: float in [-1.0, 1.0]:
		box(Vector3(SCREEN_W + 0.4, 0.06, 0.02), Vector3(0, e * (SCREEN_H / 2.0 + 0.2), 0.0), rim, false, sn)
		box(Vector3(0.06, SCREEN_H + 0.4, 0.02), Vector3(e * (SCREEN_W / 2.0 + 0.2), 0, 0.0), rim, false, sn)
	var q := QuadMesh.new()
	q.size = Vector2(SCREEN_W, SCREEN_H)
	screen_m = ShaderMaterial.new()
	var sh := Shader.new()
	sh.code = SCREEN_SHADER
	screen_m.shader = sh
	mesh(q, Vector3.ZERO, screen_m, sn)
	var iq := QuadMesh.new()
	iq.size = Vector2(SCREEN_H * 0.72, SCREEN_H * 0.72)
	img_m = ShaderMaterial.new()
	var ish := Shader.new()
	ish.code = IMG_SHADER
	img_m.shader = ish
	img_q = mesh(iq, Vector3(SCREEN_W * 0.23, 0.35, 0.02), img_m, sn)
	img_q.visible = false
	text_l = Label3D.new()
	text_l.font_size = 80
	text_l.pixel_size = 0.0068
	text_l.modulate = GREEN
	text_l.outline_size = 0
	text_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	text_l.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	text_l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text_l.width = SCREEN_W * 0.42 / 0.0068
	text_l.position = Vector3(-SCREEN_W * 0.25, SCREEN_H / 2.0 - 0.55, 0.03)
	text_l.double_sided = false
	sn.add_child(text_l)
	_text_base = text_l.position
	pct_l = Label3D.new()
	pct_l.font_size = 64
	pct_l.pixel_size = 0.0072
	pct_l.modulate = Color(0.85, 1.0, 0.88)
	pct_l.outline_size = 0
	pct_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	pct_l.width = SCREEN_W * 0.42 / 0.0072
	pct_l.position = Vector3(-SCREEN_W * 0.25, -SCREEN_H / 2.0 + 0.8, 0.03)
	pct_l.double_sided = false
	sn.add_child(pct_l)
	# the light the images throw back on the hands (and nothing else)
	img_light = OmniLight3D.new()
	img_light.position = Vector3(0, 1.5, HANDS_Z - 1.6)
	img_light.light_energy = 0.0
	img_light.omni_range = 3.2
	img_light.omni_attenuation = 1.2
	stage.add_child(img_light)
	# for the scan: the screen is something, but nothing to walk up to
	var mark := Node3D.new()
	mark.position = Vector3(0, SCREEN_Y, SCREEN_Z)
	mark.set_meta("scan", L("build", "screen_scan"))
	stage.add_child(mark)


## Carl's forearms and hands, laid on the bronze: palm to palm.
func _arms() -> void:
	arms = Node3D.new()
	stage.add_child(arms)
	var coat := mat(Color(0.08, 0.075, 0.085), 0.8)
	var cuff := mat(Color(0.55, 0.55, 0.58), 0.7)
	var skin := mat(Color(0.6, 0.46, 0.38), 0.6)
	var z := HANDS_Z
	for s: float in [-1.0, 1.0]:
		var cx := s * 0.155
		stick(Vector3(s * 0.23, 0.98, -0.02), Vector3(cx, 0.86, z + 0.17), 0.047, coat, arms)
		stick(Vector3(cx, 0.86, z + 0.17), Vector3(cx, 0.85, z + 0.13), 0.04, cuff, arms)
		var hb := box(Vector3(0.088, 0.03, 0.1), Vector3(cx, 0.842, z + 0.02), skin, false, arms)
		hb.rotation.x = -0.05
		for i in 4:
			var fx := cx + s * (i - 1.5) * 0.022
			stick(Vector3(fx, 0.84, z - 0.03), Vector3(fx, 0.835, z - 0.1), 0.0095, skin, arms)
		stick(Vector3(cx - s * 0.05, 0.84, z + 0.04), Vector3(cx - s * 0.07, 0.836, z - 0.02), 0.011, skin, arms)
	arms.visible = false


## "A door opened in the distance." A slit of cold light far off in the
## black, to Carl's left as he lies on the floor.
func _door() -> void:
	door = Node3D.new()
	door.position = Vector3(-15.0, 0, -6.0)
	door.rotation.y = PI / 2.0 - 0.3
	stage.add_child(door)
	var dm := StandardMaterial3D.new()
	dm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	dm.albedo_color = Color(1.6, 1.7, 1.75)
	quad(Vector2(1.3, 2.5), Vector3(0, 1.25, 0), 0.0, dm, door)
	var spill := StandardMaterial3D.new()
	spill.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	spill.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	spill.albedo_color = Color(0.22, 0.23, 0.25)
	floor_quad(Vector2(1.3, 5.0), Vector3(0, 0.01, 2.5), 0.0, spill, door)
	door_light = OmniLight3D.new()
	door_light.position = Vector3(0, 1.2, 1.2)
	door_light.light_color = Color(0.85, 0.9, 0.95)
	door_light.light_energy = 0.0
	door_light.omni_range = 8.0
	door.add_child(door_light)
	door.scale = Vector3(0.001, 1, 1)
	door.visible = false


# ------------------------------------------------------------------ sound

## Every sound here is made here (bible-5: the spikes are a bone-conduction
## thud; the memories are silent but for one sound each: a snap, a car door,
## a monitor flatline; the fork types with a dry click).
func _sounds() -> void:
	var R := float(Synth.RATE)
	# bone conduction: felt more than heard
	var s := Synth._buf(1.1)
	for i in s.size():
		var t := i / R
		s[i] = (sin(TAU * 38.0 * t) * 0.8 + sin(TAU * 57.0 * t) * 0.4) * exp(-t * 5.5) + (randf() * 2.0 - 1.0) * exp(-t * 160.0) * 0.6
	_s["thud"] = Synth._wav(s, false)
	# a shrill, metallic scraping
	s = Synth._buf(1.6)
	for i in s.size():
		var t := i / R
		var e := minf(1.0, t * 6.0) * exp(-maxf(0.0, t - 1.1) * 8.0)
		var w := sin(TAU * 7.0 * t) * 30.0
		s[i] = (sin(TAU * (2210.0 + w) * t) * 0.3 + sin(TAU * (3170.0 - w) * t) * 0.22 + sin(TAU * 4410.0 * t) * 0.12 + (randf() * 2.0 - 1.0) * 0.18) * e
	_s["scrape"] = Synth._wav(s, false)
	# a terminal key, dry, no chime
	s = Synth._buf(0.03)
	for i in s.size():
		var t := i / R
		s[i] = ((randf() * 2.0 - 1.0) * 0.6 + sin(TAU * 1900.0 * t) * 0.3) * exp(-t * 260.0)
	_s["click"] = Synth._wav(s, false)
	# a monitor: two beeps, then the flat tone
	for k: String in ["flatline", "flatline_short"]:
		var dur := 4.2 if k == "flatline" else 2.4
		s = Synth._buf(dur)
		for i in s.size():
			var t := i / R
			var on := (t < 0.12) or (t > 0.85 and t < 0.97) or t > 1.7
			var fade := minf(1.0, (dur - t) * 3.0)
			s[i] = sin(TAU * 960.0 * t) * 0.22 * (1.0 if on else 0.0) * fade
		_s[k] = Synth._wav(s, false)
	# a car door: the latch, then the weight of it
	s = Synth._buf(0.7)
	var lp := 0.0
	for i in s.size():
		var t := i / R
		lp += ((randf() * 2.0 - 1.0) - lp) * 0.08
		var latch := (randf() * 2.0 - 1.0) * exp(-t * 300.0) * 0.4
		var tt := maxf(0.0, t - 0.05)
		s[i] = latch + (lp * 1.6 + sin(TAU * 72.0 * tt) * 0.7) * exp(-tt * 14.0) * (1.0 if t > 0.05 else 0.0)
	_s["cardoor"] = Synth._wav(s, false)
	# the breath through the speakers of his glasses: in, out, nobody's
	s = Synth._buf(5.0)
	lp = 0.0
	for i in s.size():
		var t := i / R
		lp += ((randf() * 2.0 - 1.0) - lp) * 0.06
		var e := 0.0
		if t < 1.8:
			e = sin(t / 1.8 * PI) * 0.8
		elif t > 2.2 and t < 4.4:
			e = sin((t - 2.2) / 2.2 * PI)
		s[i] = lp * e * 0.9
	Synth._seam(s, 800)
	_s["breath"] = Synth._wav(s, true)
	# the fork's pad: the lullaby's notes, pitched down, slow; a 40 Hz floor
	s = Synth._buf(8.0)
	var notes := [196.0, 233.08, 174.61, 207.65]
	for i in s.size():
		var t := i / R
		var v := sin(TAU * 40.0 * t) * 0.22
		for n in 4:
			var ph := fposmod(t / 8.0 - n * 0.25, 1.0)
			var e := sin(ph * PI)
			v += sin(TAU * notes[n] * 0.84 * t + sin(TAU * 0.3 * t) * 0.4) * 0.07 * e * e
		s[i] = v
	Synth._seam(s, 3000)
	_s["pad"] = Synth._wav(s, true)
	# Lynx, through a door, far off
	s = Synth._buf(1.8)
	lp = 0.0
	var ph := 0.0
	for i in s.size():
		var t := i / R
		var f := 620.0 + 480.0 * minf(1.0, t * 3.0) - 160.0 * maxf(0.0, t - 1.0) + sin(TAU * 6.5 * t) * 18.0
		ph = fposmod(ph + f / R, 1.0)
		var raw := (ph * 2.0 - 1.0) * 0.6 + (randf() * 2.0 - 1.0) * 0.25
		lp += (raw - lp) * 0.22
		s[i] = lp * minf(1.0, t * 10.0) * minf(1.0, (1.8 - t) * 2.0) * 0.8
	_s["scream"] = Synth._wav(s, false)
	for i in 4:
		var ap := AudioStreamPlayer.new()
		add_child(ap)
		_aps.append(ap)
	_click_ap = AudioStreamPlayer.new()
	_click_ap.stream = _s["click"]
	_click_ap.volume_db = -14.0
	_click_ap.pitch_scale = 2.0  # the terminal sound at twice speed
	add_child(_click_ap)


func _snd(key: String, db := 0.0, pitch := 1.0) -> void:
	if key == "":
		return
	if not _s.has(key):
		main.play(key, db, pitch)
		return
	for ap: AudioStreamPlayer in _aps:
		if not ap.playing:
			ap.stream = _s[key]
			ap.volume_db = db
			ap.pitch_scale = pitch
			ap.play()
			return


## The spikes, heard: the scrape, then the thud through the jaw.
func _bone(times := 2) -> void:
	_snd("scrape", -8.0)
	for i in times:
		get_tree().create_timer(0.35 + i * 0.5).timeout.connect(func(): _snd("thud", 2.0, 1.0 - i * 0.08))
	main.player.shake(1.4)
	main.ui.flash(0.6)


# ------------------------------------------------------------------ the god's images

## Each round's image, drawn into a 64x64 Image: legible and wrong. Cached.
func _image(id: String) -> ImageTexture:
	if _tex_cache.has(id):
		return _tex_cache[id]
	var img := Image.create(64, 64, false, Image.FORMAT_RGBA8)
	var r := RandomNumberGenerator.new()
	r.seed = hash(id)
	match id:
		"flesh": _draw_flesh(img, r)
		"wrist": _draw_wrist(img, r)
		"face": _draw_face(img, r, false)
		"orbs": _draw_face(img, r, true)
		"warm": _draw_warm(img, r)
		"field": _draw_field(img, r)
	var sum := Color(0, 0, 0)
	for y in 64:
		for x in 64:
			sum += img.get_pixel(x, y)
	_avg[id] = Color(sum.r / 4096.0, sum.g / 4096.0, sum.b / 4096.0)
	var tex := ImageTexture.create_from_image(img)
	_tex_cache[id] = tex
	return tex


func _put(img: Image, x: int, y: int, c: Color, a := 1.0) -> void:
	if x < 0 or y < 0 or x > 63 or y > 63:
		return
	if a >= 1.0:
		img.set_pixel(x, y, c)
	else:
		img.set_pixel(x, y, img.get_pixel(x, y).lerp(c, a))


func _disc(img: Image, cx: float, cy: float, rx: float, ry: float, c: Color) -> void:
	for y in range(int(cy - ry) - 1, int(cy + ry) + 2):
		for x in range(int(cx - rx) - 1, int(cx + rx) + 2):
			var dx := (x + 0.5 - cx) / rx
			var dy := (y + 0.5 - cy) / ry
			if dx * dx + dy * dy <= 1.0:
				_put(img, x, y, c)


func _line(img: Image, a: Vector2, b: Vector2, w: float, c: Color) -> void:
	var n := int(a.distance_to(b) * 2.0) + 1
	for i in n + 1:
		var p := a.lerp(b, float(i) / n)
		_disc(img, p.x, p.y, w, w, c)


## WHAT IS PAIN? "A biological mass of raw flesh and blood, writhing like a
## nest of serpents." Coils of meat, wet highlights, a row of teeth in one.
func _draw_flesh(img: Image, r: RandomNumberGenerator) -> void:
	for y in 64:
		for x in 64:
			var v := 0.06 + 0.05 * r.randf() + 0.04 * sin(x * 0.3 + y * 0.2)
			img.set_pixel(x, y, Color(v * 2.2, v * 0.2, v * 0.3))
	for k in 9:
		var p := Vector2(r.randf_range(6, 58), r.randf_range(10, 54))
		var ang := r.randf() * TAU
		var rad := r.randf_range(3.6, 6.0)
		var ph := r.randf() * TAU
		for i in 40:
			ang += sin(i * 0.25 + ph) * 0.25
			p += Vector2(cos(ang), sin(ang)) * 0.9
			var rr := rad * (0.75 + 0.25 * sin(i * 0.4 + ph))
			# the dark crease where one coil lies on another
			if i % 3 == 0:
				_disc(img, p.x, p.y, rr + 1.1, rr + 1.1, Color(0.12, 0.0, 0.02))
			for y in range(int(p.y - rr), int(p.y + rr) + 1):
				for x in range(int(p.x - rr), int(p.x + rr) + 1):
					var d := Vector2(x + 0.5, y + 0.5).distance_to(p) / rr
					if d <= 1.0:
						var sh := pow(1.0 - d, 0.6)
						var c := Color(0.32, 0.02, 0.05).lerp(Color(0.96, 0.46, 0.47), sh)
						if sh > 0.82 and r.randf() < 0.3:
							c = Color(1.0, 0.86, 0.82)
						_put(img, x, y, c)
	# veins
	for k in 9:
		var a := Vector2(r.randf_range(0, 64), r.randf_range(0, 64))
		for i in 14:
			var b := a + Vector2(r.randf_range(-3, 3), r.randf_range(-3, 3))
			_line(img, a, b, 0.4, Color(0.25, 0.0, 0.08))
			a = b
	# teeth, in a seam of the meat
	for i in 7:
		_disc(img, 22 + i * 2.6, 34 + sin(i * 0.9) * 1.2, 0.9, 1.4, Color(0.95, 0.92, 0.82))
	# blood pooling at the bottom
	for y in range(54, 64):
		for x in 64:
			if r.randf() < (y - 52) / 10.0:
				_put(img, x, y, Color(0.42, 0.0, 0.02).lerp(Color(0.8, 0.1, 0.1), r.randf() * 0.4))


## WHAT IS EMBARRASSMENT? "A man, a deep gash bleeding from his wrist,
## crying while a crowd of onlookers laughed." Pale blue halo.
func _draw_wrist(img: Image, r: RandomNumberGenerator) -> void:
	for y in 64:
		for x in 64:
			var d := Vector2(x - 32, y - 24).length() / 38.0
			var c := Color(0.7, 0.84, 0.98).lerp(Color(0.03, 0.05, 0.13), smoothstep(0.12, 1.0, d))
			img.set_pixel(x, y, c * (0.95 + 0.05 * r.randf()))
	# the crowd, close round him, every mouth open too wide
	var heads := [[6, 30], [14, 26], [52, 27], [59, 33], [4, 44], [12, 41], [52, 42], [61, 46],
		[20, 50], [44, 50], [8, 56], [30, 58], [56, 57], [38, 60], [18, 61]]
	for hd: Array in heads:
		var hx: float = hd[0]
		var hy: float = hd[1]
		_disc(img, hx, hy + 8, 6.0, 6.0, Color(0.08, 0.1, 0.18))
		_disc(img, hx, hy, 4.2, 4.6, Color(0.24, 0.28, 0.4))
		_line(img, Vector2(hx - 2.2, hy - 1.4), Vector2(hx - 0.8, hy - 1.0), 0.4, Color(0.05, 0.05, 0.08))
		_line(img, Vector2(hx + 0.8, hy - 1.0), Vector2(hx + 2.2, hy - 1.4), 0.4, Color(0.05, 0.05, 0.08))
		_disc(img, hx, hy + 2.0, 2.6, 1.6, Color(0.02, 0.0, 0.02))
		_line(img, Vector2(hx - 2.0, hy + 1.0), Vector2(hx + 2.0, hy + 1.0), 0.35, Color(0.9, 0.9, 0.85))
	# him: coat, head, eyes shut tight, tears
	for y in range(30, 64):
		var hw := 5.0 + (y - 30) * 0.22
		for x in range(int(32 - hw), int(32 + hw) + 1):
			_put(img, x, y, Color(0.16, 0.18, 0.26))
	_disc(img, 32, 22, 5.2, 6.0, Color(0.86, 0.78, 0.72))
	_disc(img, 32, 17.5, 5.4, 2.6, Color(0.15, 0.12, 0.1))
	_line(img, Vector2(29, 21.5), Vector2(31, 22), 0.4, Color(0.1, 0.08, 0.08))
	_line(img, Vector2(33, 22), Vector2(35, 21.5), 0.4, Color(0.1, 0.08, 0.08))
	_line(img, Vector2(30, 23), Vector2(29.5, 27), 0.45, Color(0.6, 0.85, 1.0))
	_line(img, Vector2(34, 23), Vector2(34.5, 27.5), 0.45, Color(0.6, 0.85, 1.0))
	_line(img, Vector2(30, 26), Vector2(32, 25.2), 0.4, Color(0.35, 0.15, 0.15))
	_line(img, Vector2(32, 25.2), Vector2(34, 26), 0.4, Color(0.35, 0.15, 0.15))
	# the arm held out to them, the wrist open
	_line(img, Vector2(36, 32), Vector2(49, 38), 1.6, Color(0.16, 0.18, 0.26))
	_line(img, Vector2(49, 38), Vector2(54, 40), 1.2, Color(0.86, 0.78, 0.72))
	_disc(img, 55.5, 40.5, 1.8, 1.6, Color(0.86, 0.78, 0.72))
	_line(img, Vector2(50, 37), Vector2(51.5, 41.5), 0.6, Color(0.95, 0.04, 0.04))
	_line(img, Vector2(51, 41), Vector2(51, 60), 0.45, Color(0.75, 0.02, 0.02))
	_disc(img, 51, 61, 3.0, 1.2, Color(0.6, 0.0, 0.02))


## WHAT IS LOSS? WHAT IS DEATH? Carl's face, one eye carved out, a serene,
## knowing smile; the colour of ash. With orbs: both eyes black, stoic.
func _draw_face(img: Image, r: RandomNumberGenerator, orbs: bool) -> void:
	for y in 64:
		for x in 64:
			var d := Vector2(x - 32, y - 30).length() / 44.0
			var v := lerpf(0.36, 0.08, smoothstep(0.2, 1.0, d)) + r.randf() * 0.03
			img.set_pixel(x, y, Color(v, v, v * 0.97))
	# shoulders, the coat
	for y in range(50, 64):
		var hw := 12.0 + (y - 50) * 1.3
		for x in range(int(32 - hw), int(32 + hw) + 1):
			_put(img, x, y, Color(0.1, 0.1, 0.11))
	_disc(img, 32, 49, 5.0, 5.0, Color(0.5, 0.49, 0.47))
	# the face, lit from the left
	for y in range(8, 54):
		for x in range(14, 51):
			var dx := (x + 0.5 - 32.0) / 15.5
			var dy := (y + 0.5 - 30.0) / 21.0
			if dx * dx + dy * dy <= 1.0:
				var v := 0.66 - dx * 0.16 - maxf(0.0, dy) * 0.08 + r.randf() * 0.025
				img.set_pixel(x, y, Color(v, v * 0.98, v * 0.95))
	# hair, receding a little; stubble
	for y in range(6, 19):
		for x in range(15, 50):
			var dx := (x + 0.5 - 32.0) / 17.0
			var dy := (y + 0.5 - 20.0) / 13.0
			if dx * dx + dy * dy <= 1.0 and y < 15 + absf(x - 32) * 0.25:
				_put(img, x, y, Color(0.13, 0.12, 0.11))
	for i in 160:
		var sx := r.randi_range(20, 44)
		var sy := r.randi_range(38, 50)
		if Vector2((sx - 32) / 15.5, (sy - 30) / 21.0).length() < 0.95:
			_put(img, sx, sy, Color(0.4, 0.39, 0.38), 0.5)
	# brows, lifted: serene
	_line(img, Vector2(21, 23), Vector2(28, 21.5), 0.6, Color(0.18, 0.17, 0.16))
	_line(img, Vector2(36, 21.5), Vector2(43, 23), 0.6, Color(0.18, 0.17, 0.16))
	# the nose, a shadow
	_line(img, Vector2(33, 27), Vector2(34, 35), 0.5, Color(0.45, 0.44, 0.42))
	_line(img, Vector2(30, 36), Vector2(34, 36), 0.5, Color(0.42, 0.41, 0.4))
	if orbs:
		for ex: float in [25.0, 39.0]:
			_disc(img, ex, 27, 3.6, 3.2, Color(0.01, 0.01, 0.012))
			_put(img, int(ex) - 1, 25, Color(0.5, 0.5, 0.5))
		_line(img, Vector2(26, 42), Vector2(38, 42), 0.5, Color(0.25, 0.23, 0.22))
		return
	# his left eye, open, calm
	_disc(img, 25, 27, 3.4, 1.8, Color(0.86, 0.85, 0.82))
	_disc(img, 25.5, 27, 1.5, 1.6, Color(0.22, 0.24, 0.22))
	_put(img, 25, 27, Color(0.02, 0.02, 0.02))
	_line(img, Vector2(21.5, 25.4), Vector2(28.5, 25.4), 0.35, Color(0.2, 0.19, 0.18))
	# the other, carved out: a pit, a ragged rim, what ran down the cheek
	_disc(img, 39, 27, 4.0, 3.0, Color(0.24, 0.07, 0.07))
	_disc(img, 39, 27.3, 3.0, 2.2, Color(0.03, 0.01, 0.01))
	for i in 10:
		var a := i / 10.0 * TAU
		_put(img, int(39 + cos(a) * 4.2), int(27 + sin(a) * 3.2), Color(0.33, 0.12, 0.11))
	_line(img, Vector2(39.5, 30), Vector2(38.5, 37), 0.6, Color(0.26, 0.07, 0.07))
	_line(img, Vector2(38.5, 37), Vector2(39, 44), 0.45, Color(0.23, 0.07, 0.07))
	# the smile, too wide, corners lifted, the teeth showing
	for x in range(21, 44):
		var t := (x - 32.0) / 11.0
		var y := 42.0 - 4.5 * t * t
		_put(img, x, int(y), Color(0.16, 0.08, 0.08))
		if absf(t) < 0.85:
			_put(img, x, int(y) - 1, Color(0.9, 0.88, 0.82))
	_put(img, 20, 37, Color(0.3, 0.29, 0.28))
	_put(img, 44, 37, Color(0.3, 0.29, 0.28))


## WHAT IS LOVE? "A psychedelic range of warm colors and tones waving
## gently." With two dark places in it, where eyes would be.
func _draw_warm(img: Image, _r: RandomNumberGenerator) -> void:
	for y in 64:
		for x in 64:
			var v := sin(x * 0.19 + 2.0 * sin(y * 0.11)) + sin((x + y) * 0.13) + sin(Vector2(x - 32, y - 40).length() * 0.33)
			var hue := fposmod(0.93 + 0.2 * (v + 3.0) / 6.0, 1.0)
			var c := Color.from_hsv(hue, 0.72, 0.96)
			for e: Vector2 in [Vector2(24, 25), Vector2(41, 25)]:
				var d := Vector2(x, y).distance_to(e)
				if d < 5.0:
					c = c.darkened((1.0 - d / 5.0) * 0.45)
			img.set_pixel(x, y, c)


## WHAT IS CARE? WHAT IS FAMILY? "Two people embracing in a field of
## flowers on a summer's day." No faces. The arms go round too many times.
func _draw_field(img: Image, r: RandomNumberGenerator) -> void:
	for y in 64:
		for x in 64:
			var c: Color
			if y < 30:
				c = Color(0.98, 0.66, 0.74).lerp(Color(1.0, 0.86, 0.72), y / 30.0)
			else:
				c = Color(0.55, 0.62, 0.38).lerp(Color(0.3, 0.42, 0.24), (y - 30) / 34.0)
			img.set_pixel(x, y, c)
	_disc(img, 50, 9, 5.0, 5.0, Color(1.0, 0.97, 0.86))
	var fl := [Color(1.0, 0.9, 0.3), Color(1.0, 1.0, 0.95), Color(0.95, 0.3, 0.45), Color(0.78, 0.5, 0.95)]
	for i in 420:
		var y := r.randi_range(30, 63)
		var x := r.randi_range(0, 63)
		var c: Color = fl[r.randi() % 4]
		_put(img, x, y, c)
		if y > 50:
			_put(img, x + 1, y, c)
	# two figures, one in white, one dark, heads together, faces blank
	for y in range(24, 54):
		for x in range(24, 31):
			_put(img, x, y, Color(0.95, 0.93, 0.88))
		for x in range(33, 40):
			_put(img, x, y, Color(0.22, 0.18, 0.26))
	_disc(img, 29.5, 19.5, 3.6, 4.2, Color(0.9, 0.74, 0.66))
	_disc(img, 34.5, 19.0, 3.6, 4.2, Color(0.84, 0.68, 0.6))
	_disc(img, 29.0, 16.5, 3.8, 2.4, Color(0.55, 0.32, 0.18))
	_disc(img, 35.0, 16.0, 3.6, 2.0, Color(0.14, 0.11, 0.1))
	# the arms: three bands of skin round both of them
	for by: float in [30.0, 35.0, 40.0]:
		_line(img, Vector2(22, by), Vector2(42, by + 1.0), 0.9, Color(0.88, 0.7, 0.62))
	for y in range(54, 58):
		for x in range(25, 39):
			_put(img, x, y, Color(0.2, 0.3, 0.18), 0.6)


# ------------------------------------------------------------------ the screen

func _screen_power(v: float, t := 0.6) -> void:
	create_tween().tween_method(_set_power, _power, v, t)


func _set_power(x: float) -> void:
	_power = x
	screen_m.set_shader_parameter("power", x)


func _screen_clear() -> void:
	_screen_text = ""
	text_l.text = ""


## Type onto the screen at twice terminal speed (the fork types at 20 a
## second; this is 40), a dry click for every other character.
func _type(text: String, newline := true) -> void:
	if newline and _screen_text != "":
		_screen_text += "\n"
	if main._selftest:
		# headless, one frame a line: the script is what is under test
		_screen_text += text
		await get_tree().process_frame
		return
	for i in text.length():
		_screen_text += text[i]
		text_l.text = _screen_text
		if i % 2 == 0 and text[i] != " ":
			_click_ap.play()
		await get_tree().create_timer(1.0 / 40.0).timeout
	text_l.text = _screen_text


func _show_image(id: String, secs := 4.0) -> void:
	var tex := _image(id)
	img_m.set_shader_parameter("tex", tex)
	img_m.set_shader_parameter("wave", 1.0 if id in ["flesh", "warm"] else 0.0)
	img_m.set_shader_parameter("levels", 4.0 if id in ["face", "orbs"] else 5.0)
	img_m.set_shader_parameter("glitch", 0.0)
	img_m.set_shader_parameter("reveal", 0.0)
	img_q.visible = true
	var c: Color = _avg[id]
	img_light.light_color = Color(c.r, c.g, c.b).lightened(0.1)
	main.play("glitch", -16.0, 0.7)
	var tw := create_tween().set_parallel(true)
	tw.tween_method(func(v: float): img_m.set_shader_parameter("reveal", v), 0.0, 1.05, secs)
	tw.tween_property(img_light, "light_energy", 1.1, secs)
	await tw.finished


func _hide_image() -> void:
	img_q.visible = false
	create_tween().tween_property(img_light, "light_energy", 0.0, 0.4)


func _pct(r: int) -> int:
	return mini(100, int(BOOK_PCT[r]) + _bonus)


# ------------------------------------------------------------------ voices

## The god, "not heard but felt": violet, the pad swelling, a whisper under it.
func _voice(text: String) -> void:
	main.play("whisper", -14.0, 0.8)
	if _pad:
		create_tween().tween_property(_pad, "volume_db", -10.0, 0.4)
	await main.ui.say("", "[color=%s][i]%s[/i][/color]" % [GOD, text])
	if _pad:
		create_tween().tween_property(_pad, "volume_db", -20.0, 1.5)


## The commands: "SIT, MIMIC." "PALM TO PALM." Big, and felt in the bone.
func _command(text: String) -> void:
	_snd("thud", -2.0, 0.8)
	main.play("pressure", -10.0)
	main.player.shake(0.6)
	main.ui.glitch(0.5, 0.5)
	await main.ui.say("", "[center][color=%s][font_size=38][b]%s[/b][/font_size][/color][/center]" % [GOD, text])


## A memory: a silent caption, and one sound.
func _memory(text: String, sound: String) -> void:
	main.ui.close()
	_snd(sound, -4.0)
	await main.ui.caption(text, 3.4)


# ------------------------------------------------------------------ the void

func intro() -> void:
	if _started:
		return
	_started = true
	var ui = main.ui
	var f: Dictionary = main.flags
	if not f.has("two_doors_done"):
		await ui.think(L("gate", "not_yet"))
		ui.close()
		return
	f["cinematic"] = true
	_phase = "void"
	void_hand.visible = true
	await ui.say("Carl", L("void", "shout"))
	await ui.think(L("void", "dark"))
	await ui.think(L("void", _lynx_way()))
	await ui.think(L("void", "steps"))
	await ui.think(L("void", "hell"))
	await _voice(L("void", "voice"))
	ui.close()
	f["bh_void"] = true
	f.erase("cinematic")
	_void_t = 0.0
	_still = 0.0
	main.update_hud()


## How Lynx went into the black at the two doors (A3-S1): a plea if she
## came with trust and was warned, a sprint if she came without either,
## and only her voice if she was never with them.
func _lynx_way() -> String:
	var how := str(main.flags.get("lynx_void", ""))
	if how in ["plea", "sprint", "voice"]:
		return "lynx_" + how
	var t: int = int(main.trust.get("lynx", 0))
	if t >= 1:
		return "lynx_plea" if main.flags.has("warned_lynx") else "lynx_sprint"
	if t <= -1:
		return "lynx_sprint"
	return "lynx_voice"


## "Walking changes nothing for 20 s until the player stops." Then the
## scream, which is a choice that does nothing, and is logged.
func _void_end() -> void:
	if _phase != "void":
		return
	_phase = "void_end"
	var ui = main.ui
	var f: Dictionary = main.flags
	f["cinematic"] = true
	await ui.think(L("void", "walked"))
	await ui.think(L("void", "boiled"))
	var i: int = await ui.choose([L("void", "scream"), L("void", "walk_on")])
	await _void_choice(i)
	await _spotlight()


func _void_choice(i: int) -> void:
	var ui = main.ui
	if i == 0:
		main.flags["bh_screamed"] = true
		main.log_line("void", L("void", "log"))
		main.player.shake(0.3)
		await ui.say("Carl", L("void", "scream_1"))
		await ui.say("Carl", L("void", "scream_2"))
		main.play("pressure", -8.0)
		await _voice(L("void", "gravel_child") + " " + L("void", "gravel"))
	else:
		await ui.think(L("void", "walk_on_1"))
		main.play("pressure", -8.0)
		await _voice(L("void", "gravel"))


## "A single spotlight snapped on." The stage is set down in front of
## wherever he stopped.
func _spotlight() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	_place_stage()
	ui.close()
	main.play("slam", 0.0, 0.45)
	_snd("thud", -4.0, 0.6)
	stage.visible = true
	spot.light_energy = 7.0
	cone.visible = not main.hifi
	motes.visible = true
	motes.emitting = true
	void_hand.visible = false
	set_active(chair_it, true)
	set_active(hands_it, true)
	await p.face(stage.to_global(Vector3(0, 0.9, -1.0)), 1.0)
	await ui.think(L("spot", "snap"))
	f["bh_spot"] = true
	_phase = "spot"
	await _command(L("spot", "sit"))
	ui.close()
	f.erase("cinematic")
	main.update_hud()


func _place_stage() -> void:
	var p = main.player
	var fwd := Vector3(-sin(p.yaw), 0, -cos(p.yaw))
	stage.rotation.y = p.yaw + STAGE_TURN
	# the chair 4.6 m ahead, a little to the right of where he looks
	stage.position = Vector3(p.global_position.x, 0, p.global_position.z) + fwd * 4.6 + Vector3(-fwd.z, 0, fwd.x) * 0.8


## Walk away from the chair and the dark walks you back to it.
func _return_to_chair() -> void:
	if _returning:
		return
	_returning = true
	var ui = main.ui
	var p = main.player
	main.flags["cinematic"] = true
	await ui.fade_to(1.0, 0.5)
	p.velocity = Vector3.ZERO
	p.position = stage.to_global(Vector3(0, 0.1, 2.6))
	p.yaw = stage.rotation.y
	p.pitch = -0.12
	_returns += 1
	main.log_line("bronze", L("spot", "log_return"))
	await ui.fade_to(0.0, 0.5)
	if _returns == 1:
		await ui.think(L("spot", "returned"))
	await _command(L("spot", "sit") if _returns < 3 else L("spot", "sit_again"))
	ui.close()
	main.flags.erase("cinematic")
	_returning = false


# ------------------------------------------------------------------ the chair

func interact(node: Object) -> bool:
	var id := str(node.get_meta("id"))
	var ui = main.ui
	var f: Dictionary = main.flags
	match id:
		"chair":
			if not f.has("bh_spot"):
				return false
			if _phase == "floor" or _phase == "done":
				await ui.think(L("spot", "chair_floor"))
			elif f.has("bh_sat"):
				await ui.think(L("spot", "chair_after"))
			else:
				await _sit()
			return true
		"hands":
			if not f.has("bh_spot"):
				return false
			await ui.think(L("spot", "hands_after") if f.has("bh_palms") else L("spot", "hands_before"))
			return true
	return false


## SIT, MIMIC. Then PALM TO PALM, the breath, the cursor, the spikes, and
## the six rounds.
func _sit() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	if f.has("bh_sat") or not f.has("bh_spot"):
		return
	f["bh_sat"] = true
	f["cinematic"] = true
	_phase = "seated"
	await ui.think(L("sit", "walk"))
	await ui.fade_to(1.0, 0.3)
	p.velocity = Vector3.ZERO
	p.seated = true
	p.position = stage.to_global(Vector3(0, 0.0, 0.06))
	p.crouch = 0.48
	p.yaw = stage.rotation.y
	p.pitch = -0.02
	create_tween().tween_property(p.cam, "fov", 58.0, 1.5)
	await ui.fade_to(0.0, 0.5)
	await ui.think(L("sit", "sat"))
	await _voice(L("sit", "poem"))
	await _voice(L("sit", "clasp"))
	await ui.think(L("sit", "caged"))
	await _command(L("sit", "palms"))
	var i: int = await ui.choose([L("sit", "opt_palms"), L("sit", "opt_hesitate")])
	await _palms(i)
	await _rounds()


func _palms(i: int) -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if i == 1:
		f["bh_hesitated"] = true
		main.log_line("bronze", L("sit", "log_hesitate"))
		_snd("scrape", -4.0)
		main.player.shake(0.8)
		await ui.think(L("sit", "scrape"))
		await _command(L("sit", "palms"))
	arms.visible = true
	f["bh_palms"] = true
	await ui.think(L("sit", "placed"))
	await ui.think(L("sit", "breath"))
	if _breath and not _breath.playing:
		_breath.play()
		create_tween().tween_property(_breath, "volume_db", -9.0, 3.0)
	await ui.think(L("sit", "cursor"))
	ui.close()
	_screen_power(1.0, 1.2)
	# the spotlight gives way: from here the screen is the light
	create_tween().tween_property(spot, "light_energy", 1.6, 2.0)
	_cursor = true
	_screen_clear()
	await get_tree().create_timer(1.2).timeout
	await _type(L("sit", "prompt"))
	await get_tree().create_timer(0.8).timeout
	await _type(L("sit", "weak"))
	await get_tree().create_timer(0.8).timeout
	# the spikes: sound, behind a black card
	_bone(2)
	await ui.show_card(L("spikes", "card"), 2.6)
	blood.visible = true
	f["bh_spikes"] = true
	main.log_line("bronze", "the spikes")
	await ui.think(L("spikes", "surge"))
	await ui.think(L("spikes", "passenger"))
	ui.close()


func _rounds() -> void:
	_phase = "rounds"
	for r in 5:
		await _round(r)
	await _round_faith()
	await _finale()


# ------------------------------------------------------------------ the interrogation

## One round: the question typed, the memories (silent, one sound each),
## the god's image of the answer, and Carl's answer to it: accept, reject
## with his own line, or say nothing. Round 3 has no reject. `forced` picks
## the answer without asking (the selftest's other branches).
func _round(r: int, forced := "") -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var key := "r%d" % (r + 1)
	var d: Dictionary = LINES[key]
	_hide_image()
	_screen_clear()
	pct_l.text = ""
	await _type(str(d["q"]))
	await get_tree().create_timer(0.6).timeout
	await ui.think(str(d["pre"]))
	for mem: Array in d["mem"]:
		await _memory(str(mem[0]), str(mem[1]))
	if d.has("scream"):
		await ui.think(str(d["scream"]))
		await _voice(str(d["good"]))
	if d.has("cold"):
		await ui.think(str(d["cold"]))
	if d.has("weep"):
		await ui.think(str(d["weep"]))
		await ui.think(str(d["glass"]))
	ui.close()
	await _show_image(str(d["img"]))
	await ui.think(str(d["desc"]))
	if d.has("barrage"):
		ui.close()
		await _type(str(d["barrage"]))
	# the answer
	var kinds := ["accept", "silence"] if r == 2 else ["accept", "reject", "silence"]
	var kind := forced
	if kind == "":
		var opts := []
		for k: String in kinds:
			if k == "accept":
				opts.append(L("choice", "accept"))
			elif k == "reject":
				opts.append("\"" + str(d["reject"]) + "\"")
			else:
				opts.append(L("choice", "silence"))
		var i: int = await ui.choose(opts)
		kind = kinds[clampi(i, 0, kinds.size() - 1)]
	if not kind in kinds:
		kind = "silence"
	match kind:
		"accept":
			await ui.say("Carl", L("choice", "accept_said"))
			await _voice(L("choice", "accept_reply"))
			_bonus += 20 if r == 0 else 6
			main.add_connection(10.0, "the bronze hands: accepted")
		"reject":
			if d.has("reject_lead"):
				await ui.think(str(d["reject_lead"]))
			await ui.think(str(d["reject"]))
			if str(d.get("reject_more", "")) != "":
				await ui.think(str(d["reject_more"]))
			_bone(1)
			await ui.think(L("spikes", "twist"))
			main.add_connection(3.0, "the bronze hands: rejected")
		_:
			await ui.think(L("choice", "silence_1"))
			if r != 2:
				_bonus += 10 if r == 0 else 3
			main.add_connection(5.0, "the bronze hands: silence")
	f["bh_r%d" % (r + 1)] = kind
	main.log_line("bronze", "%s  %s" % [str(d["log"]), kind])
	# whatever the answer
	if d.has("after"):
		await ui.think(str(d["after"]))
	if d.has("barrage_after"):
		ui.close()
		_screen_clear()
		await _type(str(d["barrage_after"]))
		await ui.think(str(d["dizzy"]))
		ui.close()
		await _show_image("orbs", 3.0)
		await ui.think(str(d["orbs"]))
	ui.close()
	main.play("ding", -18.0, 0.5)
	pct_l.text = L("choice", "pct") % _pct(r)
	await get_tree().create_timer(1.6).timeout


## WHAT IS FAITH? WHAT IS GOD? AM I GOD? WHAT IS CARL DRAKE? No image, no
## choice: the text decays as it comes; the first thing the player ever
## typed comes up, and is written over with MIMIC. +5 regardless.
func _round_faith() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	_hide_image()
	await ui.think(L("r6", "glitch"))
	ui.close()
	_screen_clear()
	_glitch = 0.6
	screen_m.set_shader_parameter("glitch", 0.6)
	main.play("glitch", -6.0)
	ui.glitch(0.8, 1.0)
	for line: String in LINES["r6"]["q"]:
		await _type(line)
		_decay(0.12)
		main.player.shake(0.25)
		var lines := _screen_text.split("\n")
		if lines.size() > 14:
			_screen_text = "\n".join(lines.slice(lines.size() - 14))
			text_l.text = _screen_text
	await get_tree().create_timer(0.8).timeout
	await ui.think(L("r6", "typed_lead"))
	ui.close()
	_screen_clear()
	_glitch = 0.15
	screen_m.set_shader_parameter("glitch", 0.15)
	var typed := str(main.first_typed)
	if typed == "":
		typed = L("r6", "typed_fallback")
	text_l.modulate = Color(0.62, 0.71, 0.78)  # Carl's colour in the chat
	await _type("> " + typed)
	await get_tree().create_timer(1.0).timeout
	# written over, a letter at a time
	var word := L("r6", "name")
	var over := _screen_text
	text_l.modulate = GREEN
	for i in range(2, over.length()):
		over = over.substr(0, i) + word[(i - 2) % word.length()] + over.substr(i + 1)
		_screen_text = over
		if main._selftest:
			continue
		if i % 2 == 0:
			_click_ap.play()
		await get_tree().create_timer(1.0 / 40.0).timeout
	await get_tree().create_timer(0.4).timeout
	_screen_text = word
	text_l.text = word
	main.play("sting", -6.0, 0.7)
	ui.glitch(1.0, 0.8)
	await ui.think(L("r6", "overwrite"))
	f["bh_r6"] = "mimic"
	f["bh_mimic"] = true
	main.learn("mimic")
	main.add_connection(5.0, "WHAT IS CARL DRAKE?")
	main.log_line("bronze", L("r6", "log"))
	pct_l.text = L("choice", "pct") % mini(100, 99 + (1 if _bonus > 0 else 0))
	ui.close()


## Rot what is already on the screen: letters doubled, swapped for noise.
func _decay(amount: float) -> void:
	var junk := "#%&@$/\\|_~*"
	var out := ""
	for i in _screen_text.length():
		var ch := _screen_text[i]
		if ch != "\n" and ch != " " and randf() < amount:
			ch = junk[randi() % junk.length()] if randf() < 0.6 else ch + ch.to_lower()
		out += ch
	_screen_text = out
	text_l.text = out


# ------------------------------------------------------------------ the end

## The spikes go through, retract; Carl is thrown to the floor; a door
## opens in the distance and Lynx screams. bronze_done, then Interlude.
func _finale() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	if _ended:
		return
	_ended = true
	await ui.think(L("finale", "pressure"))
	main.player.shake(1.0)
	await ui.think(L("finale", "seize"))
	await ui.think(L("finale", "rip"))
	_bone(3)
	await ui.show_card(L("spikes", "through"), 2.4)
	_bone(1)
	_screen_power(0.0, 0.2)
	_screen_clear()
	pct_l.text = ""
	_hide_image()
	_glitch = 0.0
	screen_m.set_shader_parameter("glitch", 0.0)
	_cursor = false
	if _breath:
		_breath.stop()
	await ui.show_card(L("spikes", "retract"), 1.6)
	# thrown from the chair
	arms.visible = false
	p.seated = false
	p.velocity = Vector3.ZERO
	p.position = stage.to_global(Vector3(0.9, 0.05, 0.7))
	p.crouch = 1.25
	p.shake(1.6)
	_snd("thud", 4.0, 0.7)
	create_tween().tween_property(p.cam, "fov", 72.0, 0.8)
	spot.light_energy = 3.0
	f["cinematic"] = true
	_phase = "floor"
	await ui.think(L("finale", "thrown"))
	ui.close()
	# the door, far off
	door.visible = true
	main.play("door", -6.0, 0.7)
	var tw := create_tween().set_parallel(true)
	tw.tween_property(door, "scale:x", 1.0, 1.4)
	tw.tween_property(door_light, "light_energy", 2.2, 1.4)
	p.face(door.global_position + Vector3(0, 0.9, 0), 1.4)
	await get_tree().create_timer(0.9).timeout
	_snd("scream", -3.0)
	await ui.think(L("finale", "door"))
	await ui.say("Carl", L("finale", "lynx"))
	ui.close()
	f["bronze_done"] = true
	main.log_line("bronze", L("finale", "log"))
	_phase = "done"
	f.erase("cinematic")
	if not main._selftest:
		main.load_level("Interlude")


func _exit_tree() -> void:
	# Carl's eyes go back where they were for the next place
	if main and main.player:
		main.player.crouch = 0.0
		main.player.cam.fov = 72.0


# ------------------------------------------------------------------ the frame loop

func tick(delta: float) -> void:
	var p = main.player
	if void_hand and void_hand.visible:
		void_hand.global_transform = p.cam.global_transform
		hand_light.light_energy = 0.45 + 0.05 * sin(_t * 1.3)
	match _phase:
		"void":
			_void_t += delta
			var v := Vector2(p.velocity.x, p.velocity.z).length()
			if v > 0.5:
				_walked += delta
				_still = 0.0
			else:
				_still += delta
			if _void_t >= VOID_SECS and _still >= 0.8 and not main.ui.busy:
				_void_end()
		"spot":
			if not _returning and not main.flags.has("cinematic"):
				var lp := stage.to_local(p.global_position)
				if Vector2(lp.x, lp.z).length() > RETURN_AT:
					_return_to_chair()
	if text_l:
		if _glitch > 0.0:
			text_l.position = _text_base + Vector3(randf_range(-0.05, 0.05) * _glitch * 2.0, 0, 0)
		var want := _screen_text + ("_" if _cursor and fmod(_t, 1.0) < 0.55 else "")
		if text_l.text != want:
			text_l.text = want
	if spot and spot.light_energy > 0.0 and _phase == "floor":
		spot.light_energy = 2.6 + 0.5 * sin(_t * 9.0) * randf()


func objective() -> String:
	match _phase:
		"spot":
			return L("objective", "sit")
	return ""


func phone() -> String:
	if main.flags.has("bh_palms"):
		return L("phone", "seated")
	if main.flags.has("bh_spot"):
		return L("phone", "spot")
	return L("phone", "void")


# ------------------------------------------------------------------ dev and test

## Shots: bh=spot (the chair from behind), bh=seat (in the chair, the
## cursor), bh=round with bh_round=1..5 (that round's image, fully drawn),
## bh=faith (round 6's decayed screen), bh=floor (the end, the door).
func apply_args(a: Dictionary) -> void:
	var p = main.player
	var mode := str(a.get("bh", ""))
	if mode == "":
		if a.has("bh_void"):
			void_hand.visible = true
		return
	p.position = Vector3(0, 0.1, 0)
	p.yaw = 0.0
	_place_stage()
	stage.visible = true
	spot.light_energy = 7.0
	cone.visible = not main.hifi
	motes.visible = true
	motes.emitting = true
	main.flags["bh_spot"] = true
	if mode == "spot":
		p.pitch = deg_to_rad(float(a.get("pitch", "-4")))
		p.yaw = deg_to_rad(float(a.get("yaw", "0")))
		return
	p.seated = true
	p.position = stage.to_global(Vector3(0, 0.0, 0.06))
	p.crouch = 0.48
	p.yaw = stage.rotation.y
	p.pitch = deg_to_rad(float(a.get("pitch", "-1")))
	p.cam.fov = 58.0
	spot.light_energy = 1.6
	arms.visible = true
	blood.visible = true
	_set_power(1.0)
	_cursor = true
	if mode == "seat":
		_screen_text = L("sit", "prompt") + "\n" + L("sit", "weak")
		text_l.text = _screen_text
	elif mode == "round":
		var r := clampi(int(a.get("bh_round", "1")) - 1, 0, 4)
		var d: Dictionary = LINES["r%d" % (r + 1)]
		_screen_text = str(d["q"]) + ("\n" + str(d["barrage"]) if d.has("barrage") else "")
		text_l.text = _screen_text
		var id := str(d["img"])
		if a.has("bh_orbs"):
			id = "orbs"
		var tex := _image(id)
		img_m.set_shader_parameter("tex", tex)
		img_m.set_shader_parameter("wave", 1.0 if id in ["flesh", "warm"] else 0.0)
		img_m.set_shader_parameter("levels", 4.0 if id in ["face", "orbs"] else 5.0)
		img_m.set_shader_parameter("reveal", 1.05)
		img_q.visible = true
		var c: Color = _avg[id]
		img_light.light_color = c.lightened(0.1)
		img_light.light_energy = 1.1
		pct_l.text = L("choice", "pct") % BOOK_PCT[r]
	elif mode == "faith":
		_screen_text = "\n".join(LINES["r6"]["q"])
		_decay(0.25)
		_glitch = 0.6
		screen_m.set_shader_parameter("glitch", 0.6)
	elif mode == "floor":
		p.seated = false
		arms.visible = false
		screen_m.set_shader_parameter("power", 0.0)
		_cursor = false
		_screen_text = ""
		text_l.text = ""
		p.position = stage.to_global(Vector3(0.9, 0.05, 0.7))
		p.crouch = 1.25
		p.cam.fov = 72.0
		door.visible = true
		door.scale.x = 1.0
		door_light.light_energy = 2.2
		spot.light_energy = 3.0
		var dp := door.global_position + Vector3(0, 0.9, 0)
		var dd: Vector3 = dp - (p.position + Vector3(0, 0.4, 0))
		p.yaw = atan2(-dd.x, -dd.z) + deg_to_rad(float(a.get("yaw_off", "0")))
		p.pitch = deg_to_rad(float(a.get("pitch", "-2")))


func _by_id(id: String) -> void:
	for n in main._all_with_meta(self, "id"):
		if is_instance_valid(n) and str(n.get_meta("id")) == id and (n as CollisionObject3D).collision_layer & 2:
			await main.interact(n)
			print("ok ", id)
			return
	print("MISSING ", id)


func _wait(cond: Callable, secs: float) -> void:
	var t := 0.0
	while not cond.call() and t < secs:
		await get_tree().process_frame
		t += get_process_delta_time()


## Headless: the void (20 s that change nothing, then the stop; the pump
## picks 1, "Keep walking"), the scream for the log, a walk away from the
## chair and back, the chair (the pump hesitates at the hands, rejects
## every image that can be rejected and says nothing on round 3: the
## book's path), then every round again accepted and again in silence,
## then every interactable twice. Every wait has a deadline.
func selftest() -> void:
	var f: Dictionary = main.flags
	var p = main.player
	# Headless on a shared llvmpipe every line costs a frame; the test is of
	# the script, so the place is hidden while it runs (Observatory does too)
	visible = false
	if not f.has("two_doors_done"):
		f["two_doors_done"] = true  # what Tunnels leaves behind
	await intro()
	print("ok intro void=", f.has("bh_void"), " lynx=", _lynx_way())
	await _wait(func() -> bool: return f.has("bh_spot") and not f.has("cinematic"), 180.0)
	if not f.has("bh_spot"):
		print("WARN void timed out t=", _void_t)
		_phase = "void"
		await _void_end()
	print("ok void spot=", f.has("bh_spot"), " void_t=", snappedf(_void_t, 0.1), " screamed=", f.has("bh_screamed"))
	await _void_choice(0)
	print("ok scream logged=", f.has("bh_screamed"), " ledger=", main.ledger.size())
	main.ui.close()
	# walk away: the black brings him back
	p.position = stage.to_global(Vector3(0, 0.1, 16.0))
	await _wait(func() -> bool: return _returns > 0 and not _returning, 30.0)
	print("ok returned=", _returns)
	# the chair: the whole interrogation on the pump
	await _by_id("chair")
	await _wait(func() -> bool: return f.has("bronze_done"), 60.0)
	print("ok interrogation ", [f.get("bh_r1"), f.get("bh_r2"), f.get("bh_r3"), f.get("bh_r4"), f.get("bh_r5"), f.get("bh_r6")],
		" hesitated=", f.has("bh_hesitated"), " spikes=", f.has("bh_spikes"), " mimic=", "mimic" in main.lexicon,
		" conn=", main.connection, " screen=", pct_l.text, " bronze_done=", f.has("bronze_done"))
	# the other answers, for the script's sake
	await _palms(0)
	print("ok palms at once")
	_bonus = 0
	for r in 5:
		await _round(r, "accept")
	print("ok accept-all ", [f.get("bh_r1"), f.get("bh_r2"), f.get("bh_r3"), f.get("bh_r4"), f.get("bh_r5")], " screen=", pct_l.text, " conn=", main.connection)
	_bonus = 0
	for r in 5:
		await _round(r, "silence")
	print("ok silence-all ", [f.get("bh_r1"), f.get("bh_r2"), f.get("bh_r3"), f.get("bh_r4"), f.get("bh_r5")], " screen=", pct_l.text, " conn=", main.connection)
	await _round(2, "reject")
	print("ok round 3 has no reject: ", f.get("bh_r3"))
	main.ui.close()
	f.erase("cinematic")
	p.seated = false
	await main.selftest_all_interactables()
	visible = true
	print("SELFTEST BronzeHands done ledger=", main.ledger.size())
