extends "res://scripts/Level.gd"
## Chapter 29: the core and the chapel. Bible A3-S5 (tier 4, Day 7). Book:
## "Two large metal doors, each easily fifteen feet high, were built into
## the façade of the spire." One swings inward on silent hinges and a column
## of pressurized air nearly knocks Carl off his feet. Inside, "a computer
## thrown up in the Hagia Sophia": a dome of cable ribs over a ring of green
## windows, the walls lined with bundles that pulse a sickly green, data
## shards and terminals erupting from the floor like stalagmites, giant
## veins carrying black coolant from the river into the chamber, and at the
## centre the altar: a simple metal desk, a curved monitor with the black
## hole simulation, a row of open drive ports. The coolant valve on the
## manifold (the Burn mechanism; here it is only examined). Lynx out of the
## shadows with the knife ("CARL, STOP! YOU'RE GOING TO KILL HIM!"); her
## eyes behind a black card, her voice not. The drive, held in. [UPLOAD
## COMPLETE]; two seconds of silence; Hameron's message typed at a person's
## speed; the chamber goes black. Mira singing from the far doors, the song
## bent into tones and then metal. The knife. The chapel: metal pews, the
## screen altarpiece of churning green glass, the eyeless turning in
## unison, the obsidian altar, Mira in white between the Prophet and Eren.
## Monica from behind the altar, eyeless, with the plug. The song stops.
## Two panels, the second black: "a soft, wet thud". Mira falls. Eight
## seconds of black with no input and no sound. Then the Chair.
##
## Layout (metres). The shore (z 21..34) on the black river, the spire's
## green façade at z 20 with the fifteen-foot doors (x -2.6..2.6). The
## cathedral x -18..18, z -26..20, walls 12 m; the dome (r 15) on a ring of
## forty windows centred over the desk at DESK; four piers at x ±11, z 10
## and -16 carry the roundels; colonnades of green marble at x ±11 with dark
## aisles behind (Lynx comes out of the south-west one). The coolant veins
## come in through the side walls to the manifold arc round the desk (open
## to the south); the valve is on its south-east end. The far doors in the
## north wall; the chapel beyond, x -11..11, z -27..-60, the pews in two
## banks either side of the aisle, the altar at ALTAR, the screen on the
## north wall. Lights are grouped by area and only the live area's are lit.
##
## Flags read: river_done (entry), main.trust["lynx"], lynx_has_drive (Lynx
## kept Hameron's cube at the trailer: at T:lynx >= 0 she gives it back
## here, at <= -1 it falls from her coat as she runs), saw_vr_nathan (the
## Present option), ev_knife. Flags set: core_doors, core_vast,
## coolant_seen, core_lynx, core_lynx_choice (silent | growl | present),
## core_drive_from (carl | lynx_gave | lynx_dropped), core_drive_in,
## core_hameron, core_dark, core_song, core_knife, ev_knife, core_chapel,
## core_monica, mira_dead. Next: Chair. Hooks for later systems: metas
## "eyeless" (the congregation), "cultist" (the Prophet, Eren, Monica),
## "hackable" (the desk, the terminals, the valve).

## Every line in the level, keyed by beat and line (bible A3-S5; the
## verbatim lines are the book's, ch.28-29). Lines marked "(game)" are
## additions for the game's beats and wait for ian's script.
const LINES := {
	"cards": {
		"chapter": "[b]CHAPTER 29[/b]\n\n[color=#aaaaaa]The core\nbeneath Psyonic HQ  -  Day 7[/color]",
		"lynx": "[b]CONTENT SETTING[/b]\n\n[color=#aaaaaa]Before I could react, she raised the knife. With a final, serene look, she shoved the blade deep into her left eye socket.\n\nThe frame is withheld. The sound is not.[/color]",
		"lynx_2": "[b]CONTENT SETTING[/b]\n\n[color=#aaaaaa]She let out a choked scream, not of agony, but of pure, ecstatic release, and plunged the bloody knife into her right eye, completing the ritual.[/color]",
		"plug_1": "With a single, decisive plunge, she drove the plug into the top of Mira's skull.",
		"plug_2": "a soft, wet thud",
	},
	"intro": {
		"arrive": "I stood before a mighty metallic structure, inserted into the very heart of a layer of bedrock. The metal was coated in the unmistakable, sickly green of Psyonic.",
		"arrived": "I knew I had arrived.",
		"frames": "(game) My frames were somewhere at the bottom of the river. My bag, with the drive, was still clinging to my body.",
	},
	"frames": {
		"lost": "(game) Nothing to put on. The frames were at the bottom of the river.",
	},
	"prompts": {
		"phones": "Look at the phones", "river": "Look at the river", "facade": "Look at the spire",
		"doors": "Approach the doors", "shards": "Look at the shards", "terminal": "Look at the terminal",
		"veins": "Touch the vein", "cables": "Look at the cables", "chandelier": "Look up at the lamps",
		"roundel": "Look at the roundel", "valve": "Examine the coolant valve", "desk": "The computer",
		"pearl": "Look at the floor", "cube": "Pick up Hameron's cube", "far_doors": "The far doors",
		"congregation": "Look at them", "screen": "Look at the altarpiece", "plugs": "Look up at the plugs",
		"mira": "Mira", "prophet": "The Prophet", "eren": "Eren Elontiel", "altar": "The altar",
		"monica": "Monica", "lynx": "Lynx", "racks": "Look at the racks",
	},
	"scan": {
		"desk": "CORE  //  black hole simulator\nhost: PSYON (root)\nports: 8 open",
		"valve": "COOLANT ISOLATION V-01\nflow: 41,000 L/min\nSalTech life support tie-in",
		"veins": "COOLANT MAIN  //  river intake\npulse: 38 / min",
		"eyeless": "NO RECORD\nsync 100%",
		"prophet": "SUBJECT 41\nstatus: VESSEL",
		"eren": "ELONTIEL, EREN\nPSYONIC  -  CHIEF EXECUTIVE",
		"monica": "DRAKE, MONICA (38)\nsync 100%\nmood: RESOLVED",
		"mira": "DRAKE, MIRA (11)\nstatus: THE ONE MORE",
	},
	"shore": {
		"phones": "Smartphones washed up on the shore like driftwood, their screens turning on like bioluminescent algae as I walked past them.",
		"phones_2": "(game) One of them showed a lock screen with a child's face on it. Not mine. Someone's.",
		"river": "(game) The black river went on without me, sliding under the spire's foundations. It had carried me here and it had no further use for me.",
		"facade": "The scale was likely a practical necessity, a way to move the massive equipment needed to house the beast, but the effect was one of unintended reverence.",
		"racks": "(game) Server racks lay on the beach of wire like the ribs of something that had died here. Their fans still turned.",
	},
	"doors": {
		"look": "Two large metal doors, each easily fifteen feet high, were built into the façade of the spire.",
		"look_2": "It looked like the entrance to a cathedral.",
		"open": "As I approached, one of the goliath doors swung inward on silent, massive hinges, pushing a column of pressurized air that nearly knocked me from my feet.",
		"fear": "I should have felt fear, or at least a tremor of apprehension, but my capacity for such emotions had been scoured from me. I simply acted. There was a task to be done, and emotion would only delay it. Fear would postpone it.",
		"anger": "Anger, on the other hand, was fuel. Not the hot, blinding rage of passion, but the cold, clean anger of an obsessive man. It was that compulsive tick, that itch deep in my soul for order in a world of chaos, that propelled my legs forward.",
		"enter": "I entered the cathedral built for a false god hiding within lines of code.",
		"open_already": "(game) The door stood open. The air still pushed past me, out toward the river.",
		"not_yet": "(game) Not yet. I had to get there first.",
	},
	"vast": {
		"hagia": "The room that lay before me looked as if a computer was thrown up in the Hagia Sophia. It was a cybernetic tumor built on the obsessions of old-world religions, something Silico was never supposed to have.",
		"work": "Here, Work was God. But who gets worshipped when work is no longer enough?",
		"walls": "The walls were lined with thick bundles of wire that pulsed with a sickly green light. Data shards and terminals erupted from the floor like crystalline stalagmites. Giant, throbbing veins carried the black coolant from the river into this central chamber, keeping the great machine alive.",
		"smell": "The air was thick with the pungent scent of chemical rot, a smell I had, to my horror, almost gotten used to.",
	},
	"look": {
		"shards": "Data shards and terminals erupted from the floor like crystalline stalagmites.",
		"shards_2": "(game) Light ran up the inside of the nearest one in lines, like text scrolling too fast to read. I caught a word on the way past. It was my name.",
		"terminal": "(game) A terminal, half swallowed by the floor, the screen tilted up like a face. Lines of green ran on it. No keyboard. Nobody was meant to type here. It was the one doing the talking.",
		"veins": "Giant, throbbing veins carried the black coolant from the river into this central chamber, keeping the great machine alive.",
		"veins_2": "(game) It was warm under my palm. It pulsed slower than a heart, and it never missed.",
		"cables": "A colossal infrastructure surrounded it, a web of cables and coolant pipes that snaked into the walls and ceiling, feeding the beast.",
		"cables_2": "The tendrils of Psyonic bored deep into its core. That's where its addiction started.",
		"chandelier": "(game) A ring of dead phones hung on cables from the dome, the way the old churches hung their lamps. Every screen faced the desk.",
		"roundel": "(game) A round screen the size of a house, hung on the pier like a shield. The Eye in amber, and under it the company line, scraped off by hand: PSYON IS THE PILLOW FOR THOSE WHO DREAM.",
		"far_sealed": "(game) Shut. Something hummed behind them, low, the way a choir hums before it remembers the words.",
		"far_open": "(game) Open. The light past them was soft and green, and the song came through it.",
		"pearl": "(game) A white pearl on the floor, where she'd been standing. I didn't touch it.",
		"cube_none": "(game) Nothing on the floor but coolant.",
		"desk_dark": "(game) The screen was black. The ports were empty but one.",
		"after_mira": "(game) Nothing moved. Nothing would.",
	},
	"valve": {
		"look": "(game) Where the veins met the manifold, a valve wheel as wide as my arms, painted a red that had gone brown. A plate riveted under it: ISOLATION V-01. Below that, smaller, newer: SALTECH LIFE SUPPORT TIE-IN.",
		"think": "The Machine. It wasn't enough to simply unplug it; someone would just rebuild it.",
		"think_2": "(game) But cut the coolant and the whole cathedral would cook in its own heat. Everything that drank from it would go dark with it.",
		"again": "(game) The wheel. I could turn it. Not yet. Not until I'd done what I came to do.",
		"log": "The coolant valve (ISOLATION V-01) on the core's manifold. Cut it and the machine cooks. A SalTech life support tie-in on the same line.",
	},
	"desk": {
		"doubt": "My skin began to itch. I began to wonder why the beast would guide me here, where it should be most vulnerable. Was it possible it didn't know I'd met with Hameron? Or was this a trap?",
		"doubt_2": "What kind of God can be killed by a flash drive, anyway? I lingered on that thought, a cold sliver of doubt, wishing I had asked Hameron more about his plan.",
		"altar": "At the chamber's center was the altar: a simple metal desk. The computer housing the black hole simulator sat upon it, deceptively simple-looking. A standard curved monitor and desktop, no different than the terminals Lynx and I had accessed before. But this was the heart.",
		"stalk": "I began my stalk towards the monitor, my mission a cold, hard stone in my gut, when a voice shattered the silence.",
		"monitor": "The monitor was on, displaying a mesmerizing simulation of a black hole's event horizon, its surface rolling and bleeding raw information. A series of open drive ports lined the desk, waiting.",
		"hold": "Hold E  -  the drive",
		"insert": "I ripped Hameron's drive from my bag and shoved it into the slot like a dagger. Like I was a knight slitting a dragon's throat.",
		"bar": "A progress bar appeared. It filled instantly.",
		"term_head": "COGNI  >  /core/0",
		"term_done": "[UPLOAD COMPLETE]",
		"peace": "For one beautiful, fleeting second, there was silence. Peace.",
		"won": "Was it over? Had I won?",
		"new_msg": "A new message from Dr. Hameron displayed in stark white text.",
		"hameron": "I'm very sorry for misleading you, Mr. Drake. But there's only one way to kill a god.",
		"black": "The screen went black. The entire chamber plunged into absolute darkness.",
		"no_drive": "(game) My hand went to the bag. No cube. Lynx had it. Lynx had kept it.",
		"log": "Uploaded Hameron's drive at the core. \"I'm very sorry for misleading you, Mr. Drake. But there's only one way to kill a god.\"",
	},
	"lynx": {
		"shout": "CARL, STOP! YOU'RE GOING TO KILL HIM!",
		"ruin": "It was Lynx, stumbling out from the shadows, her knife brandished weakly in her trembling hand. Her face was ruin.",
		"nathan": "Nathan's in there, Carl, you can't kill him. I need to see him… I need…",
		"sob": "Her strength gave out, and she sank to the floor, letting out a ragged, broken sob. She looked up at me, her eyes wild with a terrifying, hollow light.",
		"good": "Carl, the being is good. You just have to see. It will give you anything you want, Carl… anything.",
		"frozen": "I was frozen in shock, my cold resolve threatened by pity. How could she have fallen so far? I began to second-guess myself. What was I about to do?",
		"choice": ["Say nothing.", "\"LYNX, DON'T stand in my way.\""],
		"choice_present": "Present: the VR headset. The beach. \"Hey Honeybee.\"",
		"silent": "(game) I said nothing. The hum filled the place where my answer should have been.",
		"growl": "LYNX, DON'T stand in my way.",
		"growl_think": "My voice was a low growl.",
		"present_think": "(game) The headset on her table. The beach. The voice that called her Honeybee.",
		"present": "That wasn't him either.",
		"present_lynx": "(game) …I know. I know it wasn't. But it knew what he called me, Carl. It knew.",
		"present_think_2": "(game) For a second the knife came down an inch. Then it didn't.",
		"not_hurt": "I'm not going to hurt you, Carl. I won't stop you.",
		"be_with": "I just want to be… I just want to be with him again.",
		"give_think": "(game) She dug in her coat and set Hameron's cube on the floor between us, the way you'd leave something on a grave.",
		"give": "(game) Here. You'll want this. I don't need it anymore.",
		"stop": "LYNX, STOP! DON'T!",
		"beautiful": "Carl… it's beautiful. Nathan's here with me. You'll see.",
		"hurt": "It didn't hurt at all…",
		"stood": "She stood, sightless, a bloody and triumphant smile stretching across her face.",
		"giggle": "She giggled, a sound that would tear through my nightmares forever.",
		"laugh": "Then she laughed, a wild, unhinged sound that echoed off the cold metal walls, and turned, running back into the darkness.",
		"drop": "(game) Something fell out of her coat as she turned and skittered across the floor: Hameron's cube. She never looked back for it.",
		"grief": "The grief inside me erupted into a roar of pure fury. I surged toward the computer that housed this taker of family, this thief of self. It didn't deserve us.",
		"log": "Lynx at the core, with the knife: she took her own eyes. \"It didn't hurt at all…\"",
		"cube": "(game) I picked the cube up off the wet floor. It was warm, like something that had been held.",
	},
	"song": {
		"begin": "And from a distant, unseen room, I heard a song begin, a sweet, clear voice that I knew better than my own heart. It was Mira. Singing.",
		"lyric": "The sleeper will dream again,\nour eyes will lock us in…",
		"doors": "Another set of large double doors groaned open at the far end of the chamber, spilling a soft, ethereal light.",
		"warp": "The song grew in volume, beckoning me. It began to warp, the melody bending, the words dissolving into pure, hypnotic tones, then degrading further into a chorus of metallic screeching, a holy signal breaking down into raw, agonizing noise.",
		"prompt": "E   Draw the knife",
		"knife": "I drew my knife from my bag, its cold steel a small comfort, and ran toward the sound.",
	},
	"chapel": {
		"room": "The room beyond was a chapel. An unholy synthesis of circuit and stone. Rows of cold, metal pews lined a central aisle, all facing a massive screen that served as an altarpiece. On it, a digital mockery of stained glass churned in morphing, psychedelic green patterns.",
		"turn": "The pews were filled with the eyeless. As I entered, every head turned in perfect, silent unison. Their cavernous sockets fixed on me, not with malice, but with a profound, hungry longing.",
		"waiting": "They were waiting.",
		"congregation": "(game) Their hands were folded in their laps. Clean hands. Someone had dressed them for this.",
		"screen": "On it, a digital mockery of stained glass churned in morphing, psychedelic green patterns.",
		"plugs": "Above it, thick wire plugs dangled from the ceiling like industrial nooses.",
		"prophet": "The Prophet stood to her left, a silent, scarred sentinel.",
		"eren": "To her right, Eren Elontiel, the new CEO of Psyonic, watched me with an expression of serene calm.",
		"altar": "At the other end of the chapel was an altar, a simple obsidian slab. Above it, thick wire plugs dangled from the ceiling like industrial nooses. And on the altar, my blood ran cold.",
		"mira": "Mira sat facing me, dressed in a simple white gown. The Prophet stood to her left, a silent, scarred sentinel. To her right, Eren Elontiel, the new CEO of Psyonic, watched me with an expression of serene calm.",
		"fourth": "Then, a fourth figure stepped from the shadows behind the altar. A figure whose posture I knew like my own reflection.",
		"erased": "And what I saw next didn't just break me. It erased me.",
		"monica": "It was Monica, my wife. She stood there, holding a large, heavy metallic plug. She was eyeless. Her eyes were perfect, glistening black spheres that seemed to drink the light from the room, and they beckoned me forward.",
		"stops": "Mira's song stopped. The silence was absolute.",
		"raise": "Monica raised the metal plug high above her head. Her movements were fluid, certain, practiced.",
		"falls": "Mira's small body went rigid for a second, then fell forward onto the table, lifeless as a doll.",
		"mira_after": "(game) Mira. My girl.",
		"log": "The chapel under the core: Monica, eyeless, drove the plug into Mira's skull on the obsidian altar. Mira is dead.",
	},
	"phone": {
		"before": "[color=#7fe6b0]We have waited so long for you, Carl. Come in out of the river.[/color]\n\n",
		"inside": "[color=#7fe6b0]Go on. The ports are open. We left them open for you.[/color]\n\n",
		"dark": "[color=#ff8a8a]NO SIGNAL[/color]\n\n",
		"chapel": "[color=#7fe6b0]Come and see.[/color]\n\n",
	},
	"objective": {
		"doors": "The doors in the spire",
		"heart": "The computer at the heart of it",
		"cube": "Hameron's cube, on the floor",
		"drive": "Install the drive at the desk",
		"song": "Follow the song",
		"mira": "Mira",
	},
}

## The lullaby (Facility, ch.12): "The sleeper will dream again, / our eyes
## will lock us in, / and we will know no pain / for the rest of eternity."
## [midi note, beats, vowel] per syllable; a child's range, 3/4, slow.
const MELODY := [
	[69, 1, "uh"], [69, 1, "ee"], [72, 1, "er"], [69, 1, "ih"], [67, 1, "ee"], [65, 1, "uh"], [67, 3, "eh"],
	[67, 1, "ah"], [67, 1, "ah"], [69, 1, "ih"], [67, 1, "ah"], [65, 1, "uh"], [62, 3, "ih"],
	[69, 1, "ah"], [69, 1, "ee"], [72, 1, "ih"], [69, 1, "oh"], [67, 1, "oh"], [65, 3, "eh"],
	[67, 1, "oh"], [69, 1, "uh"], [67, 1, "eh"], [65, 1, "uh"], [64, 1, "ee"], [65, 1, "er"], [67, 1, "ee"], [65, 4, "ee"],
]
const VOWELS := {"ee": [420.0, 2900.0], "ih": [520.0, 2400.0], "eh": [680.0, 2150.0], "ah": [950.0, 1500.0],
	"oh": [620.0, 1050.0], "uh": [760.0, 1450.0], "er": [560.0, 1700.0]}
const SONG_RATE := 11025
const BEAT := 0.6
const WARP_AT := 11.0   # the first two lines are sung clean
const CRUSH_AT := 16.4  # then bent into tones; then bit-crushed into metal

const SPAWN := Vector3(0.0, 0.1, 31.0)
const FACADE_Z := 20.0
const HX := 18.0
const NORTH_Z := -26.0
const WALL_H := 12.0
const DOME := Vector3(0.0, 12.0, -3.0)
const DOME_R := 15.0
const DESK := Vector3(0.0, 0.0, -3.0)
const ARC_R := 4.6
const VALVE_A := -0.5          # radians round the manifold arc (south-east end)
const LYNX_FROM := Vector3(-13.5, 0.0, 8.5)
const LYNX_AT := Vector3(-1.5, 0.0, 1.3)
const CARL_AT := Vector3(0.7, 0.1, 3.6)
const CH_X := 11.0
const CH_Z1 := -60.0
const CH_H := 10.0
const ALTAR := Vector3(0.0, 0.0, -53.0)
const SCREEN_Z := -59.8
const CARL_CH := Vector3(0.0, 0.1, -46.6)
const GREEN := Color(0.3, 1.0, 0.5)
const AMBER := Color(1.0, 0.62, 0.18)

const CABLE_SHADER := """
shader_type spatial;
uniform float power = 1.0;
uniform vec3 core = vec3(0.0, 6.0, -3.0);
varying vec3 wp;
void vertex() { wp = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz; }
void fragment() {
	float d = length(wp - core);
	float p = pow(max(sin(d * 0.8 + TIME * 3.0), 0.0), 8.0);
	float strand = 0.5 + 0.5 * sin((wp.x + wp.z) * 37.0 + wp.y * 11.0);
	ALBEDO = vec3(0.025, 0.035, 0.03) * (0.6 + 0.6 * strand);
	ROUGHNESS = 0.5;
	METALLIC = 0.4;
	EMISSION = vec3(0.25, 1.0, 0.45) * (0.08 + 1.9 * p) * (0.55 + 0.45 * strand) * power;
}
"""

const VEIN_SHADER := """
shader_type spatial;
uniform float power = 1.0;
uniform vec3 core = vec3(0.0, 0.0, -3.0);
varying vec3 wp;
float throb(vec3 w) {
	float d = length(w.xz - core.xz) + w.y * 0.5;
	return pow(max(sin(d * 0.55 + TIME * 2.2), 0.0), 5.0);
}
void vertex() {
	vec3 w = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	VERTEX += NORMAL * throb(w) * 0.07 * power;
	wp = w;
}
void fragment() {
	ALBEDO = vec3(0.01, 0.011, 0.014);
	ROUGHNESS = 0.07;
	METALLIC = 0.7;
	SPECULAR = 0.9;
	float rim = pow(1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0), 3.0);
	EMISSION = (vec3(0.05, 0.4, 0.18) * throb(wp) * 0.8 + vec3(0.04, 0.16, 0.1) * rim * 0.6 + vec3(0.03, 0.0, 0.05) * 0.25) * power;
}
"""

const SHARD_SHADER := """
shader_type spatial;
uniform float power = 1.0;
varying vec3 wp;
void vertex() { wp = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz; }
void fragment() {
	float fres = pow(1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0), 2.5);
	float row = floor(wp.y * 10.0 - TIME * 0.9);
	float lit = step(0.5, fract(wp.y * 10.0 - TIME * 0.9));
	float word = step(0.45, fract(sin(row * 12.9898 + floor((wp.x + wp.z) * 16.0) * 78.233) * 43758.5453));
	ALBEDO = vec3(0.01, 0.035, 0.03);
	ROUGHNESS = 0.04;
	METALLIC = 0.3;
	SPECULAR = 1.0;
	EMISSION = (vec3(0.2, 1.0, 0.6) * (fres * 1.3 + lit * word * 0.4) + vec3(0.02, 0.12, 0.07)) * power;
}
"""

const RIVER_SHADER := """
shader_type spatial;
void fragment() {
	vec3 w = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float a = sin(w.x * 0.6 + TIME * 0.5) + sin(w.z * 1.1 - TIME * 0.8 + w.x * 0.3);
	ALBEDO = vec3(0.004, 0.005, 0.007);
	ROUGHNESS = 0.03;
	METALLIC = 0.9;
	SPECULAR = 1.0;
	NORMAL_MAP = normalize(vec3(0.5 + 0.07 * cos(w.x * 0.6 + TIME * 0.5), 0.5 + 0.07 * cos(w.z * 1.1 - TIME * 0.8), 1.0));
	EMISSION = vec3(0.05, 0.0, 0.08) * (0.5 + 0.25 * a) * 0.3;
}
"""

## The monitor: the event horizon, the photon ring, the disk lensed over
## the top, "its surface rolling and bleeding raw information".
const HOLE_SHADER := """
shader_type spatial;
render_mode unshaded, cull_disabled;
uniform float power = 1.0;
uniform float collapse = 0.0;
float hash(vec2 p) { return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }
float noise(vec2 p) {
	vec2 i = floor(p); vec2 f = fract(p); f = f * f * (3.0 - 2.0 * f);
	return mix(mix(hash(i), hash(i + vec2(1.0, 0.0)), f.x), mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), f.x), f.y);
}
void fragment() {
	vec2 uv = UV * 2.0 - 1.0;
	uv.x *= 2.3;
	uv.y = -uv.y;
	float t = TIME;
	float rh = 0.38 * (1.0 - collapse);
	float r = length(uv);
	float a = atan(uv.y, uv.x);
	vec2 dq = vec2(uv.x, (uv.y + 0.02) * 4.4);
	float dr = length(dq);
	float sw = noise(vec2(atan(dq.y, dq.x) * 3.0 - t * 1.4 + 5.0 / (dr + 0.25), dr * 7.0 - t * 0.5));
	float disk = smoothstep(rh * 1.25, rh * 1.7, dr) * smoothstep(2.1, 0.8, dr) * (0.3 + 1.0 * sw);
	float front = step(0.0, -uv.y) + step(rh * 1.05, r);
	disk *= clamp(front, 0.0, 1.0);
	float ring = exp(-pow((r - rh * 1.42) * 13.0, 2.0)) * (0.6 + 0.7 * noise(vec2(a * 4.0 + t, t * 0.7)));
	float photon = exp(-pow((r - rh * 1.04) * 45.0, 2.0));
	vec3 col = mix(vec3(0.42, 0.16, 0.85), vec3(0.85, 1.0, 0.92), sw) * disk * 0.85;
	col += vec3(0.55, 0.85, 1.0) * ring * 0.85 + vec3(1.0) * photon * 1.4;
	float stars = step(0.996, hash(floor(UV * vec2(220.0, 90.0)))) * 0.6;
	col += vec3(stars) * step(rh * 1.8, r);
	float row = floor(UV.y * 70.0);
	float bleed = step(0.9, hash(vec2(row, floor(t * 5.0))));
	float ch = step(0.45, hash(vec2(floor(UV.x * 160.0 - t * 30.0 * hash(vec2(row, 1.0))), row)));
	float near = smoothstep(1.4, 0.3, abs(uv.y) * 3.0 + abs(uv.x) * 0.3);
	col += vec3(0.25, 1.0, 0.6) * bleed * ch * near * 0.7;
	col *= smoothstep(rh * 0.95, rh, r);
	col += vec3(1.0) * photon * 1.2 * smoothstep(rh * 0.9, rh, r);
	col *= 0.86 + 0.14 * sin(UV.y * 600.0);
	ALBEDO = col * power;
}
"""

## The altarpiece: a rose of glass in leading, cells sliding, churning green.
const GLASS_SHADER := """
shader_type spatial;
render_mode unshaded, cull_disabled;
uniform float power = 1.0;
uniform float aspect = 1.8;
uniform float rose = 1.0;
vec2 h2(vec2 p) { p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3))); return fract(sin(p) * 43758.5453); }
void fragment() {
	vec2 uv = UV * 2.0 - 1.0;
	uv.x *= aspect;
	uv.y = -uv.y;
	float t = TIME * 0.22;
	float r = length(uv);
	float a = atan(uv.y, uv.x) + t * 0.4 * rose;
	float sec = 6.2831853 / 12.0;
	a = mix(a, abs(mod(a, sec) - sec * 0.5), rose);
	vec2 q = vec2(cos(a), sin(a)) * r;
	q = mix(uv, q, rose);
	q += 0.18 * vec2(sin(q.y * 3.1 + t * 2.3), cos(q.x * 2.7 - t * 1.9));
	vec2 g = q * 4.5;
	vec2 ip = floor(g);
	vec2 fp = fract(g);
	float d1 = 8.0;
	float d2 = 8.0;
	vec2 cell = vec2(0.0);
	for (int y = -1; y <= 1; y++) {
		for (int x = -1; x <= 1; x++) {
			vec2 o = vec2(float(x), float(y));
			vec2 h = h2(ip + o);
			vec2 pt = o + 0.5 + 0.42 * sin(t * 3.0 + 6.2831 * h) - fp;
			float d = dot(pt, pt);
			if (d < d1) { d2 = d1; d1 = d; cell = ip + o; } else if (d < d2) { d2 = d; }
		}
	}
	float lead = smoothstep(0.03, 0.09, sqrt(d2) - sqrt(d1));
	vec2 hc = h2(cell);
	vec3 c = mix(vec3(0.02, 0.3, 0.1), vec3(0.45, 1.0, 0.32), hc.x);
	c = mix(c, vec3(0.04, 0.7, 0.58), step(0.72, hc.y));
	c = mix(c, vec3(0.86, 1.0, 0.62), step(0.94, hc.y));
	c *= 0.5 + 0.65 * (0.5 + 0.5 * sin(t * 7.0 + hc.x * 20.0 - r * 5.0));
	float rings = smoothstep(0.035, 0.0, abs(fract(r * 2.0 - t * 0.6) - 0.5) - 0.455) * rose;
	float mull = smoothstep(0.02, 0.0, abs(fract(UV.x * 5.0) - 0.5) - 0.48) * (1.0 - rose);
	vec3 col = c * lead * (1.0 - rings * 0.85) * (1.0 - mull);
	ALBEDO = col * power;
}
"""

var dyn: Node3D
var _busy := false
var _env: Environment
var _rock: StandardMaterial3D
var _steel: StandardMaterial3D
var _cable_m: ShaderMaterial
var _cable_ch: ShaderMaterial     # the chapel's ribs, which stay lit
var _vein_m: ShaderMaterial
var _shard_m: ShaderMaterial
var _hole_m: ShaderMaterial
var _glass_m: ShaderMaterial
var _lancet_m: ShaderMaterial
var _area_lights := {"shore": [], "cath": [], "chapel": []}
var _cath_glows: Array = []      # [material, energy] that die with the chamber
var _chapel_glows: Array = []    # [material, energy] that wake with the far doors
var phones: Array = []           # [screen MeshInstance3D, lit?]
var _phone_lit: StandardMaterial3D
var _phone_dark: StandardMaterial3D
var door_leaf: Node3D
var far_leaves: Array = []       # [pivot, open angle]
var far_block: StaticBody3D
var air: CPUParticles3D
var drive_cube: MeshInstance3D
var lynx: Node3D
var lynx_it: CollisionObject3D
var lynx_face_eyeless: StandardMaterial3D
var lynx_blood: Array = []
var lynx_knife: MeshInstance3D
var pearl: MeshInstance3D
var pearl_it: CollisionObject3D
var cube_floor: MeshInstance3D
var cube_it: CollisionObject3D
var mira: Node3D
var prophet: Node3D
var eren: Node3D
var monica: Node3D
var monica_it: CollisionObject3D
var plug: Node3D
var cong: Array = []             # [{pos, v, k, yaw, want}]
var mm_body: Array = []
var mm_head: Array = []
var _turn := 0.0                 # 0 facing the altar, 1 turned to Carl
var _turn_target := 0.0
var _turned_back := false
var knife_fp: Node3D             # Carl's knife, at the bottom of his view
var _layer: CanvasLayer
var card_rect: ColorRect
var card_text: RichTextLabel
var panel_box: HBoxContainer
var panel_l: TextureRect
var panel_cap: Label
var term: PanelContainer
var term_head: Label
var term_bar: ColorRect
var term_text: RichTextLabel
var hold_box: Control
var hold_fill: ColorRect
var hold_l: Label
var _song: AudioStreamPlayer3D
var _song_loop: AudioStreamPlayer3D
var _throb: AudioStreamPlayer3D
var _hum: Node
var _block_input := false
var _pick := -1                  # the self-test's choice override
var _frames_note := 0.0


func L(beat: String, key: String) -> String:
	return str(LINES[beat][key])


func LA(beat: String, key: String) -> Array:
	return (LINES[beat][key] as Array).duplicate()


# ------------------------------------------------------------------ build

func build(m: Node) -> void:
	main = m
	rng.seed = 2929
	kit_day = false
	step_db = -17.0
	card = L("cards", "chapter")
	dyn = Node3D.new()
	add_child(dyn)
	_rock = pbr("concrete", Vector3(1, 1, 1) / 4.0, true, Color(0.42, 0.27, 0.2), 1.0)
	_steel = mat(Color(0.17, 0.19, 0.18), 0.45, 0.8)
	_cable_m = _shader(CABLE_SHADER)
	_cable_ch = _shader(CABLE_SHADER)
	_cable_ch.set_shader_parameter("core", Vector3(0.0, 4.0, ALTAR.z))
	_vein_m = _shader(VEIN_SHADER)
	_shard_m = _shader(SHARD_SHADER)
	_hole_m = _shader(HOLE_SHADER)
	_glass_m = _shader(GLASS_SHADER)
	_lancet_m = _shader(GLASS_SHADER)
	_lancet_m.set_shader_parameter("rose", 0.0)
	_lancet_m.set_shader_parameter("aspect", 0.3)
	_lancet_m.set_shader_parameter("power", 0.0)
	_glass_m.set_shader_parameter("power", 0.0)
	_shore()
	_facade()
	_cathedral()
	_dome()
	_veins()
	_shards()
	_desk()
	_valve()
	_chandeliers()
	_roundels()
	_rot()
	_chapel()
	_batch(self, 24.0, true)
	_doors()
	_phones()
	_congregation()
	_people()
	_lynx_build()
	_lights()
	_layers()
	_sounds()
	spawn = SPAWN
	spawn_yaw = 0.0
	# the frames went into the river (ch.28): nothing to put on down here
	if main.frames_on:
		main.frames_on = false
		main.ui.set_frames(0.0, main.connection)


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	_env = env
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.0, 0.0, 0.0)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.26, 0.36, 0.3)
	env.ambient_light_energy = 0.45
	env.fog_light_color = Color(0.01, 0.035, 0.022)
	env.fog_density = 0.011
	env.fog_sky_affect = 0.0
	env.glow_bloom = 0.1
	env.tonemap_exposure = 1.15
	sun.light_energy = 0.0
	sun.shadow_enabled = false


func hifi(env: Environment, _sun: DirectionalLight3D) -> void:
	env.volumetric_fog_density *= 0.8


func ambience() -> void:
	_hum = main.loop("hum", -18.0, DESK + Vector3(0, 6.0, 0), 8.0, 80.0)
	(_hum as AudioStreamPlayer3D).pitch_scale = 0.42
	main.loop("wind", -34.0)
	main.loop("static", -38.0, DESK + Vector3(0, 1.2, -0.2), 1.5, 14.0)
	_throb = main.loop("hum", -80.0, DESK, 6.0, 60.0) as AudioStreamPlayer3D
	_throb.stream = _throb_stream()
	_throb.volume_db = -12.0


func _shader(code: String) -> ShaderMaterial:
	var sh := Shader.new()
	sh.code = code
	var sm := ShaderMaterial.new()
	sm.shader = sh
	return sm


# ------------------------------------------------------------------ the shore (ch.28's last page)

## "A beach of wires and old, decaying tech": sandstone above, the black
## river behind, dead racks like ribs, cables like kelp.
func _shore() -> void:
	var sand := pbr("concrete", Vector3(1, 1, 1) / 3.0, true, Color(0.24, 0.2, 0.18), 1.1)
	solid_box(Vector3(40, 2, 18), Vector3(0, -1.0, 27.0))
	for x in [-14, 0, 14]:
		floor_quad(Vector2(14, 14), Vector3(x, 0.0, 27.0), 0.0, sand)
	# the river: oily black, sliding left to right
	var rv := _shader(RIVER_SHADER)
	floor_quad(Vector2(90, 40), Vector3(0, -0.35, 54.0), 0.0, rv)
	solid_box(Vector3(60, 4, 1), Vector3(0, 1.0, 34.6))
	# the cavern of raw sandstone: walls, ceiling, a lip down to the water
	box(Vector3(1.5, 16, 18), Vector3(-20.5, 8, 27), _rock, true)
	box(Vector3(1.5, 16, 18), Vector3(20.5, 8, 27), _rock, true)
	box(Vector3(44, 1.5, 36), Vector3(0, 16.5, 36), _rock)
	box(Vector3(44, 0.5, 1.2), Vector3(0, -0.1, 34.2), _rock)
	for i in 9:
		var p := Vector3(rng.randf_range(-18, 18), 0, rng.randf_range(42, 70))
		cyl(rng.randf_range(1.2, 3.0), rng.randf_range(2.0, 4.0), 18.0, p + Vector3(0, 8.0, 0), _rock, 8)
	# wire kelp: tangles on the sand
	var wire := mat(Color(0.05, 0.05, 0.05), 0.6, 0.4)
	var wire2 := mat(Color(0.22, 0.08, 0.06), 0.6, 0.3)
	for i in 70:
		var a := Vector3(rng.randf_range(-17, 17), 0.03, rng.randf_range(21.5, 33.8))
		var b := a + Vector3(rng.randf_range(-2.5, 2.5), rng.randf_range(0.0, 0.08), rng.randf_range(-1.5, 1.5))
		stick(a, b, rng.randf_range(0.012, 0.035), wire if i % 3 else wire2)
	# dead tech: racks fallen like ribs, boxes, tyres, a drone face down
	var racks := [[Vector3(-9.0, 0, 26.5), 0.4], [Vector3(-11.5, 0, 30.0), 1.9], [Vector3(10.0, 0, 28.0), -0.7], [Vector3(12.5, 0, 24.0), 2.6]]
	for r: Array in racks:
		var n := prop("server_rack", r[0], r[1], 1.0, true)
		if n:
			n.rotation.z = 1.45
			n.position.y = 0.3
	prop("old_tyre", Vector3(6.0, 0, 30.5), 0.3, 1.0, false)
	prop("delivery_drone", Vector3(-5.5, 0.05, 32.0), 2.2, 1.0, false)
	prop("modular_electric_cables", Vector3(8.0, 0, 22.5), 0.0, 1.0, false)
	prop("utility_box_02", Vector3(-13.0, 0, 22.0), 0.6, 1.0, true)
	prop("Barrel_01", Vector3(14.5, 0, 31.0), 0.0, 1.0, true)
	var rk := interactable("racks", LINES["prompts"]["racks"], Vector3(-10.2, 0.4, 28.0), Vector3(3.0, 0.8, 4.0), "", false)
	rk.set_meta("hackable", true)
	interactable("river", LINES["prompts"]["river"], Vector3(0, 0.3, 34.0), Vector3(30, 1.0, 0.8), "", false)


## The phones on the sand: each lights as Carl passes, "like bioluminescent
## algae". The bodies batch; the screens swap material in tick().
func _phones() -> void:
	_phone_lit = newglow(Color(0.55, 1.0, 0.85), 1.6)
	_phone_dark = mat(Color(0.02, 0.025, 0.03), 0.15, 0.3)
	var body := mat(Color(0.06, 0.06, 0.07), 0.4, 0.5)
	for i in 56:
		var p := Vector3(rng.randf_range(-16, 16), 0.02, rng.randf_range(21.6, 33.6))
		var ry := rng.randf() * TAU
		var tilt := rng.randf_range(-0.25, 0.25)
		var pb := box(Vector3(0.08, 0.012, 0.16), p, body, false, dyn)
		pb.rotation = Vector3(tilt, ry, 0.0)
		var sc := box(Vector3(0.07, 0.004, 0.145), p + Vector3(0, 0.008, 0), _phone_dark, false, dyn)
		sc.rotation = pb.rotation
		phones.append([sc, false])
	interactable("phones", LINES["prompts"]["phones"], Vector3(-3.0, 0.2, 27.0), Vector3(6, 0.4, 5), "", false)


# ------------------------------------------------------------------ the façade and the doors

func _facade() -> void:
	var green := pbr("rust", Vector3(1, 1, 1) / 3.0, true, Color(0.25, 0.62, 0.36), 0.8)
	var green_d := mat(Color(0.06, 0.16, 0.09), 0.5, 0.7)
	# the wall, cut for the doors (x -2.6..2.6, 4.6 high)
	box(Vector3(HX - 2.6, 16, 1.0), Vector3(-(HX + 2.6) * 0.5, 8, FACADE_Z), green, true)
	box(Vector3(HX - 2.6, 16, 1.0), Vector3((HX + 2.6) * 0.5, 8, FACADE_Z), green, true)
	box(Vector3(5.2, 16 - 4.6, 1.0), Vector3(0, 4.6 + (16 - 4.6) * 0.5, FACADE_Z), green, true)
	# the spire's buttresses and ribs, the panel seams, a stencil
	for x: float in [-15.0, -9.0, -4.2, 4.2, 9.0, 15.0]:
		box(Vector3(1.0, 16, 1.4), Vector3(x, 8, FACADE_Z + 0.9), green_d, true)
	for y: float in [5.4, 9.5, 13.5]:
		box(Vector3(36, 0.25, 0.3), Vector3(0, y, FACADE_Z + 0.65), green_d)
	box(Vector3(6.6, 0.6, 0.6), Vector3(0, 5.0, FACADE_Z + 0.7), green_d)
	for x: float in [-3.1, 3.1]:
		box(Vector3(0.6, 5.0, 0.6), Vector3(x, 2.5, FACADE_Z + 0.7), green_d)
	label("PSYONIC  //  SUBLEVEL", Vector3(0, 6.1, FACADE_Z + 1.0), 0.0, 0.0045, Color(0.6, 1.0, 0.7, 0.85), self, false)
	label("CORE  0", Vector3(0, 5.6, FACADE_Z + 1.0), 0.0, 0.003, Color(0.6, 1.0, 0.7, 0.6), self, false)
	# green light bleeding from the seams above the doors
	var seam := newglow(Color(0.3, 1.0, 0.5), 1.6)
	_cath_glows.append([seam, 1.6])
	box(Vector3(5.6, 0.06, 0.1), Vector3(0, 4.72, FACADE_Z + 0.55), seam)
	# the spire's seams lit from inside: strips up every buttress, bands across
	var seam2 := newglow(Color(0.3, 1.0, 0.5), 1.1)
	_cath_glows.append([seam2, 1.1])
	for x: float in [-15.0, -9.0, -4.2, 4.2, 9.0, 15.0]:
		box(Vector3(0.08, 15.0, 0.06), Vector3(x, 8.5, FACADE_Z + 1.62), seam2)
	for y: float in [5.4, 9.5, 13.5]:
		box(Vector3(36, 0.05, 0.05), Vector3(0, y + 0.16, FACADE_Z + 0.82), seam2)
	for x: float in [-12.0, -6.6, 6.6, 12.0]:
		for y: float in [7.4, 11.4]:
			box(Vector3(2.2, 1.0, 0.05), Vector3(x, y, FACADE_Z + 0.53), mat(Color(0.03, 0.08, 0.05), 0.3, 0.6))
			box(Vector3(2.0, 0.04, 0.06), Vector3(x, y - 0.3, FACADE_Z + 0.56), seam2)
	interactable("facade", LINES["prompts"]["facade"], Vector3(-9.0, 5.0, FACADE_Z + 1.3), Vector3(8, 6, 0.6), "", false)


## The doors: two leaves 4.6 m high (fifteen feet), hinged at the jambs. One
## swings inward on silent hinges and blows a column of air out at Carl.
## The far doors in the north wall open onto the chapel later.
func _doors() -> void:
	var leaf_m := pbr("rust", Vector3(1, 1, 1) / 2.0, true, Color(0.2, 0.5, 0.28), 0.8)
	var band := mat(Color(0.05, 0.12, 0.07), 0.5, 0.8)
	for s: float in [-1.0, 1.0]:
		var pv := Node3D.new()
		pv.position = Vector3(s * 2.6, 0, FACADE_Z)
		dyn.add_child(pv)
		box(Vector3(2.6, 4.6, 0.35), Vector3(-s * 1.3, 2.3, 0), leaf_m, false, pv)
		for y: float in [0.9, 2.3, 3.7]:
			box(Vector3(2.5, 0.12, 0.42), Vector3(-s * 1.3, y, 0), band, false, pv)
		solid_box(Vector3(2.6, 4.6, 0.35), Vector3(-s * 1.3, 2.3, 0), pv)
		if s > 0.0:
			door_leaf = pv
	interactable("doors", LINES["prompts"]["doors"], Vector3(0, 2.0, FACADE_Z + 0.6), Vector3(5.0, 3.6, 0.6), "", false)
	air = CPUParticles3D.new()
	air.emitting = false
	air.one_shot = true
	air.amount = 140
	air.lifetime = 1.8
	air.explosiveness = 0.85
	air.position = Vector3(0, 2.0, FACADE_Z + 0.4)
	air.direction = Vector3(0, 0.05, 1)
	air.spread = 22.0
	air.initial_velocity_min = 7.0
	air.initial_velocity_max = 14.0
	air.gravity = Vector3(0, -0.6, 0)
	air.emission_shape = CPUParticles3D.EMISSION_SHAPE_BOX
	air.emission_box_extents = Vector3(2.2, 2.0, 0.2)
	var dm := QuadMesh.new()
	dm.size = Vector2(0.05, 0.05)
	var dmat := StandardMaterial3D.new()
	dmat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	dmat.albedo_color = Color(0.5, 0.6, 0.55, 0.5)
	dmat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	dmat.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	dm.material = dmat
	air.mesh = dm
	dyn.add_child(air)
	# the far doors, north wall, opening out into the chapel
	for s: float in [-1.0, 1.0]:
		var pv := Node3D.new()
		pv.position = Vector3(s * 2.6, 0, NORTH_Z - 0.5)
		dyn.add_child(pv)
		box(Vector3(2.6, 4.6, 0.3), Vector3(-s * 1.3, 2.3, 0), leaf_m, false, pv)
		for y: float in [0.9, 2.3, 3.7]:
			box(Vector3(2.5, 0.12, 0.38), Vector3(-s * 1.3, y, 0), band, false, pv)
		far_leaves.append([pv, s * 1.75])
	far_block = solid_box(Vector3(5.2, 4.6, 0.4), Vector3(0, 2.3, NORTH_Z - 0.5))
	interactable("far_doors", LINES["prompts"]["far_doors"], Vector3(0, 2.0, NORTH_Z + 0.2), Vector3(5.0, 3.6, 0.5), "", false)


# ------------------------------------------------------------------ the cathedral

## Floor, walls, colonnades, piers, the gallery over the aisles, the flat
## ceiling round the dome, and the cable bundles lining every wall.
func _cathedral() -> void:
	var floor_m := pbr("concrete", Vector3(1, 1, 1) / 2.5, true, Color(0.16, 0.19, 0.18), 0.35)
	var wall_m := pbr("plaster", Vector3(1, 1, 1) / 3.0, true, Color(0.2, 0.26, 0.23), 1.0)
	var marble := pbr("concrete", Vector3(1, 1, 1) / 1.5, true, Color(0.1, 0.32, 0.22), 0.3)
	var stone := pbr("concrete", Vector3(1, 1, 1) / 3.0, true, Color(0.22, 0.24, 0.22), 1.0)
	var d := FACADE_Z - NORTH_Z
	var cz := (FACADE_Z + NORTH_Z) * 0.5
	solid_box(Vector3(HX * 2 + 2, 2, d), Vector3(0, -1.0, cz))
	for ix in range(-18, 18, 12):
		for iz in range(int(NORTH_Z), int(FACADE_Z), 12):
			var sz := minf(12.0, FACADE_Z - iz)
			floor_quad(Vector2(12, sz), Vector3(ix + 6, 0.0, iz + sz * 0.5), 0.0, floor_m)
	box(Vector3(1.0, WALL_H, d), Vector3(-HX - 0.5, WALL_H * 0.5, cz), wall_m, true)
	box(Vector3(1.0, WALL_H, d), Vector3(HX + 0.5, WALL_H * 0.5, cz), wall_m, true)
	# north wall, cut for the far doors
	box(Vector3(HX - 2.6, WALL_H, 1.0), Vector3(-(HX + 2.6) * 0.5, WALL_H * 0.5, NORTH_Z - 0.5), wall_m, true)
	box(Vector3(HX - 2.6, WALL_H, 1.0), Vector3((HX + 2.6) * 0.5, WALL_H * 0.5, NORTH_Z - 0.5), wall_m, true)
	box(Vector3(5.2, WALL_H - 4.6, 1.0), Vector3(0, 4.6 + (WALL_H - 4.6) * 0.5, NORTH_Z - 0.5), wall_m, true)
	# the ceiling round the dome's hole (the corners left to the dark)
	var ceil := mat(Color(0.05, 0.06, 0.055), 0.9)
	var r := DOME_R
	box(Vector3(HX * 2, 1.0, (DOME.z - r) - NORTH_Z), Vector3(0, WALL_H + 0.5, (NORTH_Z + DOME.z - r) * 0.5), ceil)
	box(Vector3(HX * 2, 1.0, FACADE_Z - (DOME.z + r)), Vector3(0, WALL_H + 0.5, (FACADE_Z + DOME.z + r) * 0.5), ceil)
	box(Vector3(HX - r, 1.0, 2 * r), Vector3(-(HX + r) * 0.5, WALL_H + 0.5, DOME.z), ceil)
	box(Vector3(HX - r, 1.0, 2 * r), Vector3((HX + r) * 0.5, WALL_H + 0.5, DOME.z), ceil)
	# piers at the four corners of the dome
	for p: Vector3 in [Vector3(-11, 0, 10), Vector3(11, 0, 10), Vector3(-11, 0, -16), Vector3(11, 0, -16)]:
		box(Vector3(3.2, WALL_H, 3.2), p + Vector3(0, WALL_H * 0.5, 0), stone, true)
		box(Vector3(3.6, 0.5, 3.6), p + Vector3(0, 0.25, 0), stone)
		box(Vector3(3.6, 0.6, 3.6), p + Vector3(0, WALL_H - 0.3, 0), stone)
	# the colonnades of green marble (the Hagia Sophia's verd antique)
	# with the gallery floor over the dark aisles
	for s: float in [-1.0, 1.0]:
		for z: float in [5.0, 0.0, -5.0, -10.0]:
			var c := Vector3(s * 11.0, 0, z)
			cyl(0.42, 0.48, 6.0, c + Vector3(0, 3.0, 0), marble, 12)
			box(Vector3(1.1, 0.4, 1.1), c + Vector3(0, 0.2, 0), stone)
			box(Vector3(1.2, 0.5, 1.2), c + Vector3(0, 5.85, 0), stone)
			solid_box(Vector3(0.9, 6.0, 0.9), c + Vector3(0, 3.0, 0))
			# cable strands bound to the columns
			for k in 5:
				var a := TAU * k / 5.0 + z
				var o := Vector3(cos(a), 0, sin(a)) * 0.5
				stick(c + o + Vector3(0, 0.2, 0), c + o * 1.1 + Vector3(0, 6.0, 0), 0.05, _cable_m)
		box(Vector3(7.0, 0.5, 30.0), Vector3(s * 14.5, 6.25, -3.0), stone)
		box(Vector3(0.3, 1.1, 26.0), Vector3(s * 11.15, 7.05, -3.0), _steel)
		# the bundles that line the walls: thick strands, sagging between hooks
		for z in range(-24, 19, 3):
			for k in 4:
				var x := s * (HX - 0.15 - k * 0.11)
				var y0 := 0.3 + k * 0.05
				stick(Vector3(x, y0, z), Vector3(x, WALL_H - 0.4, z + 0.6 + k * 0.1), 0.06, _cable_m)
		for y: float in [2.5, 7.5, 10.5]:
			for k in 3:
				var x2 := s * (HX - 0.3 - k * 0.12)
				var prev := Vector3(x2, y, NORTH_Z + 1.0)
				for i in range(1, 15):
					var zz := lerpf(NORTH_Z + 1.0, FACADE_Z - 1.0, i / 14.0)
					var p2 := Vector3(x2, y - 0.35 * sin(PI * fmod(i, 2.0) * 0.5) - k * 0.08, zz)
					stick(prev, p2, 0.07, _cable_m)
					prev = p2
	# the north and south walls get bundles too, round the doors
	for zw: float in [NORTH_Z + 0.15, FACADE_Z - 0.6]:
		for x in range(-17, 18, 2):
			if absf(x) < 3.5:
				continue
			stick(Vector3(x, 0.2, zw), Vector3(x + 0.4, WALL_H - 0.3, zw), 0.07, _cable_m)
	# a polished floor inlay round the desk: the omphalion
	var inlay := mat(Color(0.05, 0.09, 0.07), 0.15, 0.6)
	cyl(3.0, 3.0, 0.04, DESK + Vector3(0, 0.02, 0), inlay, 32)
	var ring := newglow(Color(0.25, 0.95, 0.45), 0.9)
	_cath_glows.append([ring, 0.9])
	var tm := TorusMesh.new()
	tm.inner_radius = 3.0
	tm.outer_radius = 3.1
	tm.rings = 48
	tm.ring_segments = 4
	mesh(tm, DESK + Vector3(0, 0.03, 0), ring).scale = Vector3(1, 0.2, 1)


## The dome: a hemisphere of stone, forty ribs of cable to the crown, forty
## windows round its foot (each a green screen), a cornice, and the bundle
## that drops from the crown into the desk.
func _dome() -> void:
	var stone := pbr("concrete", Vector3(1, 1, 1) / 4.0, true, Color(0.16, 0.2, 0.18), 1.0).duplicate() as StandardMaterial3D
	stone.cull_mode = BaseMaterial3D.CULL_DISABLED
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var segs := 40
	var rings := 10
	for j in rings:
		var a0 := PI * 0.5 * j / rings
		var a1 := PI * 0.5 * (j + 1) / rings
		for i in segs:
			var b0 := TAU * i / segs
			var b1 := TAU * (i + 1) / segs
			var q := [Vector3(cos(a0) * cos(b0), sin(a0), cos(a0) * sin(b0)), Vector3(cos(a0) * cos(b1), sin(a0), cos(a0) * sin(b1)),
				Vector3(cos(a1) * cos(b1), sin(a1), cos(a1) * sin(b1)), Vector3(cos(a1) * cos(b0), sin(a1), cos(a1) * sin(b0))]
			for k: int in [0, 1, 2, 0, 2, 3]:
				var v: Vector3 = q[k]
				st.set_normal(-v)
				st.add_vertex(DOME + v * DOME_R)
	mesh(st.commit(), Vector3.ZERO, stone)
	var tm := TorusMesh.new()
	tm.inner_radius = DOME_R - 0.6
	tm.outer_radius = DOME_R + 0.2
	tm.rings = 64
	tm.ring_segments = 6
	mesh(tm, DOME + Vector3(0, 0.1, 0), mat(Color(0.12, 0.14, 0.13), 0.8))
	# the windows: forty arched screens round the foot of the dome
	var win := newglow(Color(0.35, 1.0, 0.55), 2.2)
	_cath_glows.append([win, 2.2])
	for i in 40:
		var b := TAU * (i + 0.5) / 40.0
		var p := DOME + Vector3(cos(b), 0, sin(b)) * (DOME_R - 0.35) + Vector3(0, 1.3, 0)
		var w := box(Vector3(0.9, 1.6, 0.08), p, win)
		w.rotation.y = -b + PI * 0.5
		var cap := box(Vector3(0.9, 0.3, 0.09), p + Vector3(0, 0.95, 0), win)
		cap.rotation.y = w.rotation.y
		cap.scale = Vector3(0.6, 1, 1)
	# ribs of cable from the foot to the crown
	for i in 40:
		var b := TAU * i / 40.0
		var prev := DOME + Vector3(cos(b), 0.0, sin(b)) * (DOME_R - 0.5) + Vector3(0, 2.4, 0)
		for k in range(1, 10):
			var a := lerpf(0.16, PI * 0.5 - 0.06, k / 9.0)
			var p := DOME + Vector3(cos(a) * cos(b), sin(a), cos(a) * sin(b)) * (DOME_R - 0.4)
			stick(prev, p, 0.11 if i % 2 == 0 else 0.07, _cable_m)
			prev = p
	# the bundle from the crown into the heart: the tendrils bore down
	for k in 14:
		var a := TAU * k / 14.0
		var top := DOME + Vector3(cos(a) * 1.2, DOME_R - 0.5, sin(a) * 1.2)
		var mid := DESK + Vector3(cos(a + 0.6) * 0.9, 7.0, sin(a + 0.6) * 0.9)
		var low := DESK + Vector3(cos(a) * 0.6, 2.3, -0.55 + sin(a) * 0.3)
		stick(top, mid, 0.07, _cable_m)
		stick(mid, low, 0.06, _cable_m)
		stick(low, DESK + Vector3(cos(a) * 0.35, 1.3, -0.75), 0.05, _cable_m)
	# and down on the floor, the web from the desk out to the walls
	var floorc := mat(Color(0.03, 0.035, 0.035), 0.5, 0.4)
	for k in 22:
		var a := TAU * k / 22.0 + 0.1
		var from := DESK + Vector3(cos(a) * 0.7, 0.06, sin(a) * 0.5)
		var to := DESK + Vector3(cos(a) * 13.0, 0.06, sin(a) * 13.0)
		to.x = clampf(to.x, -HX + 0.3, HX - 0.3)
		to.z = clampf(to.z, NORTH_Z + 0.4, FACADE_Z - 1.5)
		var prev := from
		for i in range(1, 6):
			var p := from.lerp(to, i / 5.0) + Vector3(sin(i * 1.7 + k) * 0.4, 0, cos(i * 1.3 + k) * 0.4)
			stick(prev, p, 0.05 if k % 3 else 0.09, floorc)
			prev = p


## The veins: black coolant mains through the side walls, along the floor
## into the manifold arc round the desk; two more come over the façade and
## cross the vault to the crown. A tube of pipe segments, throbbing.
func _veins() -> void:
	var y := 0.62
	_tube([Vector3(-HX - 0.5, y, -9.0), Vector3(-12.0, y, -8.5), Vector3(-7.0, y, -5.5), Vector3(-ARC_R, y, DESK.z)], 0.6, true)
	_tube([Vector3(HX + 0.5, y, -9.0), Vector3(12.0, y, -8.5), Vector3(7.0, y, -5.5), Vector3(ARC_R, y, DESK.z)], 0.6, true)
	var arc := []
	for k in 15:
		var a := lerpf(VALVE_A, PI - VALVE_A, k / 14.0)
		arc.append(Vector3(cos(a) * ARC_R, 0.5, DESK.z - sin(a) * ARC_R))
	_tube(arc, 0.5, true)
	for e: Vector3 in [arc[0], arc[14]]:
		sphere(0.62, e, _vein_m, 10)
	# risers from the manifold up into the vault
	for s: float in [-1.0, 1.0]:
		_tube([Vector3(s * 2.4, 0.5, DESK.z - 3.9), Vector3(s * 2.0, 3.0, DESK.z - 4.6), Vector3(s * 1.6, 8.0, DESK.z - 2.5), Vector3(s * 1.0, DOME.y + DOME_R - 1.2, DESK.z)], 0.45, false)
	# over the façade and across the vault
	for s: float in [-1.0, 1.0]:
		_tube([Vector3(s * 7.0, 9.0, FACADE_Z + 0.5), Vector3(s * 6.5, 10.5, 12.0), Vector3(s * 5.0, 15.0, 4.0), Vector3(s * 2.0, 22.0, -1.0), Vector3(s * 1.0, DOME.y + DOME_R - 1.0, DESK.z)], 0.55, false)
	# black coolant weeping from the joints onto the floor
	var pool := mat(Color(0.006, 0.006, 0.008), 0.02, 0.9)
	for p: Vector3 in [Vector3(-9.0, 0.01, -7.5), Vector3(8.5, 0.01, -7.0), Vector3(-4.0, 0.01, -8.0), Vector3(3.5, 0.01, 1.4), Vector3(-14.0, 0.01, -10.0), Vector3(6.0, 0.01, 12.0)]:
		var q := cyl(rng.randf_range(0.8, 1.8), rng.randf_range(0.8, 1.8), 0.01, p, pool, 14)
		q.scale = Vector3(1.0, 1.0, rng.randf_range(0.5, 1.2))
	var vi := interactable("veins", LINES["prompts"]["veins"], Vector3(-9.0, 0.7, -7.6), Vector3(3.0, 1.4, 1.6), L("scan", "veins"), false)
	vi.set_meta("hackable", true)


func _tube(pts: Array, r: float, solid: bool) -> void:
	var c := Curve3D.new()
	c.bake_interval = 1.0
	for i in pts.size():
		var p: Vector3 = pts[i]
		var prev: Vector3 = pts[maxi(i - 1, 0)]
		var nxt: Vector3 = pts[mini(i + 1, pts.size() - 1)]
		var tn := (nxt - prev) * 0.22
		c.add_point(p, -tn, tn)
	var bp := c.get_baked_points()
	for i in bp.size() - 1:
		_pipe(bp[i], bp[i + 1], r)
		sphere(r, bp[i + 1], _vein_m, 10)
		if solid:
			_seg_solid(bp[i], bp[i + 1], r)


func _pipe(a: Vector3, b: Vector3, r: float) -> void:
	var mi := stick(a, b, r, _vein_m)
	var cm := mi.mesh as CylinderMesh
	cm.radial_segments = 10


func _seg_solid(a: Vector3, b: Vector3, r: float) -> void:
	var sb := StaticBody3D.new()
	sb.collision_layer = 1
	var cs := CollisionShape3D.new()
	var bs := BoxShape3D.new()
	bs.size = Vector3(r * 1.8, r * 1.8, a.distance_to(b) + r)
	cs.shape = bs
	sb.add_child(cs)
	add_child(sb)
	var up := Vector3.UP if absf((b - a).normalized().y) < 0.95 else Vector3.RIGHT
	sb.look_at_from_position((a + b) * 0.5, b, up)


## "Data shards and terminals erupted from the floor like crystalline
## stalagmites": five-sided crystals with text running inside, and dead
## terminals half swallowed, screens tilted up like faces.
func _shards() -> void:
	var placed := 0
	var tries := 0
	while placed < 38 and tries < 400:
		tries += 1
		var p := Vector3(rng.randf_range(-16.5, 16.5), 0, rng.randf_range(-24.0, 17.0))
		if absf(p.x) < 3.5 and p.z > -4.0:
			continue    # the walk in from the doors
		if Vector2(p.x - DESK.x, p.z - DESK.z).length() < 6.4:
			continue    # the desk and the manifold
		if absf(absf(p.x) - 11.0) < 1.2:
			continue    # the colonnades
		if absf(p.x) < 3.5 and p.z < -20.0:
			continue    # the way to the far doors
		var h := rng.randf_range(0.8, 4.6) * (1.3 if absf(p.x) > 12.0 else 1.0)
		for k in rng.randi_range(1, 3):
			var o := p + Vector3(rng.randf_range(-0.6, 0.6), 0, rng.randf_range(-0.6, 0.6))
			var hk := h * rng.randf_range(0.4, 1.0)
			var cm := CylinderMesh.new()
			cm.top_radius = 0.0
			cm.bottom_radius = rng.randf_range(0.14, 0.55) * (hk / 3.0 + 0.4)
			cm.height = hk
			cm.radial_segments = 5
			cm.rings = 1
			var mi := mesh(cm, o + Vector3(0, hk * 0.45, 0), _shard_m)
			mi.rotation = Vector3(rng.randf_range(-0.25, 0.25), rng.randf() * TAU, rng.randf_range(-0.25, 0.25))
		solid_box(Vector3(0.8, h, 0.8), p + Vector3(0, h * 0.5, 0))
		placed += 1
	interactable("shards", LINES["prompts"]["shards"], Vector3(-6.5, 1.0, 9.0), Vector3(3.0, 2.0, 3.0), "", false)
	# terminals, tilted, half buried, screens running
	var frame := mat(Color(0.07, 0.08, 0.08), 0.5, 0.7)
	var scr := newglow(Color(0.25, 0.9, 0.5), 1.1)
	_cath_glows.append([scr, 1.1])
	var tpos := [Vector3(-6.0, 0, 3.5), Vector3(6.5, 0, 6.0), Vector3(-8.0, 0, -13.0), Vector3(7.5, 0, -14.0), Vector3(-5.5, 0, -19.5), Vector3(5.0, 0, -21.0), Vector3(-14.5, 0, 14.0), Vector3(14.5, 0, -21.0)]
	for i in tpos.size():
		var p: Vector3 = tpos[i]
		var n := Node3D.new()
		n.position = p
		n.rotation = Vector3(-0.35 - rng.randf() * 0.3, rng.randf() * TAU, rng.randf_range(-0.2, 0.2))
		add_child(n)
		box(Vector3(1.1, 1.5, 0.14), Vector3(0, 0.55, 0), frame, false, n)
		box(Vector3(0.95, 1.2, 0.02), Vector3(0, 0.62, -0.08), scr, false, n)
		solid_box(Vector3(1.0, 1.4, 0.6), p + Vector3(0, 0.7, 0))
	var ti := interactable("terminal", LINES["prompts"]["terminal"], tpos[1] + Vector3(0, 0.8, 0), Vector3(1.4, 1.6, 1.0), "", false)
	ti.set_meta("hackable", true)


## The altar: "a simple metal desk", a standard curved monitor (the black
## hole), a tower, the row of open drive ports at the front edge.
func _desk() -> void:
	var top_m := mat(Color(0.32, 0.34, 0.34), 0.35, 0.85)
	var leg_m := mat(Color(0.12, 0.13, 0.13), 0.5, 0.8)
	var d := DESK
	box(Vector3(1.9, 0.05, 0.9), d + Vector3(0, 0.76, 0), top_m)
	for s: Vector3 in [Vector3(-0.9, 0, -0.4), Vector3(0.9, 0, -0.4), Vector3(-0.9, 0, 0.4), Vector3(0.9, 0, 0.4)]:
		box(Vector3(0.05, 0.74, 0.05), d + s + Vector3(0, 0.37, 0), leg_m)
	box(Vector3(0.45, 0.62, 0.82), d + Vector3(-0.68, 0.42, 0), leg_m)
	for y: float in [0.25, 0.45, 0.62]:
		box(Vector3(0.36, 0.015, 0.02), d + Vector3(-0.68, y, 0.42), top_m)
	box(Vector3(1.85, 0.4, 0.03), d + Vector3(0, 0.52, -0.43), leg_m)
	solid_box(Vector3(2.0, 1.0, 1.0), d + Vector3(0, 0.5, 0))
	# the ports: a strip at the front edge, green pins of light, waiting
	var strip := mat(Color(0.05, 0.05, 0.055), 0.4, 0.8)
	box(Vector3(1.3, 0.05, 0.05), d + Vector3(0.1, 0.72, 0.45), strip)
	var led := newglow(Color(0.35, 1.0, 0.5), 2.0)
	_cath_glows.append([led, 2.0])
	for i in 8:
		var x := -0.45 + i * 0.13
		box(Vector3(0.07, 0.022, 0.012), d + Vector3(x, 0.72, 0.474), mat(Color(0.0, 0.0, 0.0), 1.0))
		box(Vector3(0.012, 0.012, 0.01), d + Vector3(x + 0.05, 0.735, 0.476), led)
	drive_cube = box(Vector3(0.07, 0.07, 0.07), d + Vector3(-0.45 + 3 * 0.13, 0.72, 0.5), mat(Color(0.01, 0.01, 0.012), 0.1, 0.9), false, dyn)
	drive_cube.visible = false
	# the tower
	box(Vector3(0.22, 0.46, 0.48), d + Vector3(0.68, 1.02, -0.12), mat(Color(0.08, 0.085, 0.09), 0.4, 0.6))
	box(Vector3(0.01, 0.36, 0.01), d + Vector3(0.68, 1.02, 0.125), led)
	# the curved monitor: concave toward Carl
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var rr := 1.6
	var span := 0.42
	var n := 14
	var cy := d.y + 1.13
	var cz := d.z - 0.25 + rr
	for i in n:
		var a0 := lerpf(-span, span, float(i) / n)
		var a1 := lerpf(-span, span, float(i + 1) / n)
		var p0 := Vector3(rr * sin(a0), 0, cz - rr * cos(a0))
		var p1 := Vector3(rr * sin(a1), 0, cz - rr * cos(a1))
		var u0 := float(i) / n
		var u1 := float(i + 1) / n
		var verts := [[p0 + Vector3(0, cy + 0.28, 0), Vector2(u0, 0)], [p1 + Vector3(0, cy + 0.28, 0), Vector2(u1, 0)],
			[p1 + Vector3(0, cy - 0.28, 0), Vector2(u1, 1)], [p0 + Vector3(0, cy - 0.28, 0), Vector2(u0, 1)]]
		for k: int in [0, 1, 2, 0, 2, 3]:
			st.set_normal(Vector3(0, 0, 1))
			st.set_uv(verts[k][1])
			st.add_vertex(verts[k][0])
	var scr := mesh(st.commit(), Vector3.ZERO, _hole_m, dyn)
	scr.name = "monitor"
	var back := mat(Color(0.05, 0.05, 0.055), 0.4, 0.6)
	for i in 5:
		var a := lerpf(-span, span, (i + 0.5) / 5.0)
		var b := box(Vector3(rr * span * 2.0 / 5.0 + 0.02, 0.6, 0.03), Vector3(rr * sin(a), cy, cz - rr * cos(a) - 0.025), back)
		b.rotation.y = -a
	box(Vector3(0.08, 0.32, 0.06), d + Vector3(0, 0.95, -0.3), back)
	box(Vector3(0.4, 0.02, 0.25), d + Vector3(0, 0.79, -0.3), back)
	var it := interactable("desk", LINES["prompts"]["desk"], d + Vector3(0, 1.0, 0.1), Vector3(2.0, 1.1, 1.1), L("scan", "desk"), false)
	it.set_meta("hackable", true)


## The coolant valve on the manifold's south-east end: a wheel on a stem,
## the plate, the SalTech tie-in. The Burn mechanism; tonight, a look.
func _valve() -> void:
	var a := VALVE_A + 0.06
	var base := Vector3(cos(a) * ARC_R, 0.5, DESK.z - sin(a) * ARC_R)
	var out := Vector3(cos(a), 0, -sin(a))
	var wheel_m := mat(Color(0.36, 0.1, 0.07), 0.6, 0.5)
	var c := base + out * 0.75 + Vector3(0, 0.75, 0)
	stick(base, c - out * 0.05, 0.12, _steel)
	var tm := TorusMesh.new()
	tm.inner_radius = 0.42
	tm.outer_radius = 0.5
	tm.rings = 20
	tm.ring_segments = 6
	var wn := Node3D.new()
	wn.position = c
	add_child(wn)
	wn.look_at_from_position(c, c + out, Vector3.UP)
	var w := mesh(tm, Vector3.ZERO, wheel_m, wn)
	w.rotation.x = PI * 0.5
	for k in 4:
		var aa := TAU * k / 4.0 + 0.4
		stick(Vector3.ZERO, Vector3(cos(aa), sin(aa), 0) * 0.45, 0.03, wheel_m, wn)
	sphere(0.08, Vector3.ZERO, _steel, 8, wn)
	box(Vector3(0.5, 0.2, 0.02), Vector3(0, -0.72, -0.12), mat(Color(0.7, 0.68, 0.6), 0.6, 0.4), false, wn)
	var vi := interactable("valve", LINES["prompts"]["valve"], c, Vector3(1.1, 1.1, 1.1), L("scan", "valve"), false)
	vi.set_meta("hackable", true)


## The lamps: rings of dead phones hung on cables, the polycandela of the
## old church, every screen turned to the desk.
func _chandeliers() -> void:
	var ring_m := mat(Color(0.1, 0.1, 0.1), 0.5, 0.8)
	var lit := newglow(Color(0.4, 1.0, 0.6), 1.4)
	_cath_glows.append([lit, 1.4])
	var dead := mat(Color(0.02, 0.02, 0.025), 0.2, 0.3)
	for c: Vector3 in [Vector3(-7.5, 4.6, -10.0), Vector3(7.5, 4.6, -10.0), Vector3(-7.5, 4.6, 5.0), Vector3(7.5, 4.6, 5.0)]:
		var tm := TorusMesh.new()
		tm.inner_radius = 2.0
		tm.outer_radius = 2.08
		tm.rings = 32
		tm.ring_segments = 4
		mesh(tm, c, ring_m)
		for k in 6:
			var a := TAU * k / 6.0
			stick(c + Vector3(cos(a) * 2.04, 0, sin(a) * 2.04), Vector3(c.x * 0.6, DOME.y + 6.0, c.z * 0.5 + DOME.z * 0.5), 0.015, ring_m)
		for k in 18:
			var a := TAU * k / 18.0
			var p := c + Vector3(cos(a) * 2.04, -0.25, sin(a) * 2.04)
			stick(p + Vector3(0, 0.25, 0), p + Vector3(0, 0.05, 0), 0.006, ring_m)
			var ph := box(Vector3(0.08, 0.15, 0.01), p - Vector3(0, 0.05, 0), lit if k % 3 != 1 else dead)
			ph.rotation.y = atan2(-(DESK.x - p.x), -(DESK.z - p.z)) + PI
	interactable("chandelier", LINES["prompts"]["chandelier"], Vector3(-7.5, 2.4, 5.0), Vector3(4.0, 0.6, 4.0), "", false)


## The roundels on the piers: round screens hung like shields, the Eye in
## the church's amber, the company motto scraped off under it.
func _roundels() -> void:
	var disc := mat(Color(0.03, 0.04, 0.035), 0.4, 0.5)
	var amber := newglow(AMBER, 1.6)
	_cath_glows.append([amber, 1.6])
	for p: Vector3 in [Vector3(-11, 8.4, 10), Vector3(11, 8.4, 10), Vector3(-11, 8.4, -16), Vector3(11, 8.4, -16)]:
		var face := Vector3(-signf(p.x), 0, -signf(p.z - DOME.z)).normalized()
		var n := Node3D.new()
		add_child(n)
		n.look_at_from_position(p + face * 2.55, p + face * 4.0, Vector3.UP)
		var cm := cyl(2.1, 2.1, 0.12, Vector3.ZERO, disc, 32, n)
		cm.rotation.x = PI * 0.5
		var tm := TorusMesh.new()
		tm.inner_radius = 1.95
		tm.outer_radius = 2.12
		tm.rings = 40
		tm.ring_segments = 4
		var rim := mesh(tm, Vector3(0, 0, -0.07), amber, n)
		rim.rotation.x = PI * 0.5
		var tm2 := TorusMesh.new()
		tm2.inner_radius = 0.95
		tm2.outer_radius = 1.05
		tm2.rings = 32
		tm2.ring_segments = 4
		var lid := mesh(tm2, Vector3(0, 0, -0.08), amber, n)
		lid.rotation.x = PI * 0.5
		lid.scale = Vector3(1.0, 1.0, 0.45)
		var pu := cyl(0.32, 0.32, 0.02, Vector3(0, 0, -0.08), amber, 16, n)
		pu.rotation.x = PI * 0.5
		label("PSYON IS THE PILLOW FOR THOSE WHO DREAM", Vector3(0, -1.55, -0.09), PI, 0.0035, Color(1.0, 0.65, 0.25, 0.35), n, false)
	interactable("roundel", LINES["prompts"]["roundel"], Vector3(-9.2, 2.0, 8.2), Vector3(1.6, 3.0, 1.6), "", false)


## Rot: dead fluorescents, racks in the aisles, fuse panels gone black,
## coolant stains down the walls.
func _rot() -> void:
	for s: float in [-1.0, 1.0]:
		for z: float in [3.0, -2.5, -8.0, -13.0]:
			var n := prop("server_rack", Vector3(s * 16.6, 0, z), PI * 0.5 * s, 1.0, true)
			if n and int(z) % 2 == 0:
				n.rotation.z = 0.12 * s
		prop("fuse_panel", Vector3(s * (HX - 0.1), 1.6, 14.0), -PI * 0.5 * s, 1.0, false)
		prop("mounted_fluorescent_lights", Vector3(s * (HX - 0.2), 5.0, -20.0), -PI * 0.5 * s, 1.0, false)
	prop("modular_airduct_circular_01", Vector3(-15.0, 9.0, 16.0), 0.0, 1.0, false)
	prop("steel_frame_shelves_01", Vector3(15.5, 0, 17.0), PI, 1.0, true)
	var stain := mat(Color(0.01, 0.01, 0.012), 0.05, 0.8)
	for i in 14:
		var s := -1.0 if i % 2 == 0 else 1.0
		var z := rng.randf_range(-24, 18)
		box(Vector3(0.02, rng.randf_range(2.0, 7.0), rng.randf_range(0.3, 1.2)), Vector3(s * (HX - 0.02), 3.0, z), stain)
	var ri := interactable("cables", LINES["prompts"]["cables"], Vector3(1.5, 2.6, DESK.z - 0.8), Vector3(1.2, 2.4, 1.0), "", false)
	ri.set_meta("hackable", true)


# ------------------------------------------------------------------ the chapel

## "An unholy synthesis of circuit and stone": stone walls with circuit
## traces, a pointed vault ribbed with cable, metal pews in two banks, the
## screen altarpiece, lancet screens on the side walls, the obsidian altar
## and the plugs over it.
func _chapel() -> void:
	var z0 := NORTH_Z - 1.0
	var d := z0 - CH_Z1
	var cz := (z0 + CH_Z1) * 0.5
	var stone := pbr("concrete", Vector3(1, 1, 1) / 3.0, true, Color(0.2, 0.22, 0.21), 1.0)
	var floor_m := pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.12, 0.13, 0.13), 0.4)
	solid_box(Vector3(CH_X * 2 + 2, 2, d), Vector3(0, -1.0, cz))
	for iz in range(0, int(d), 12):
		var sz := minf(12.0, d - iz)
		floor_quad(Vector2(CH_X * 2, sz), Vector3(0, 0.0, z0 - iz - sz * 0.5), 0.0, floor_m)
	box(Vector3(1.0, CH_H, d), Vector3(-CH_X - 0.5, CH_H * 0.5, cz), stone, true)
	box(Vector3(1.0, CH_H, d), Vector3(CH_X + 0.5, CH_H * 0.5, cz), stone, true)
	box(Vector3(CH_X * 2 + 2, CH_H + 3.5, 1.0), Vector3(0, (CH_H + 3.5) * 0.5, CH_Z1 - 0.5), stone, true)
	# the pointed vault: two slopes to a ridge, ribs of cable every 3 m
	for s: float in [-1.0, 1.0]:
		var v := box(Vector3(12.4, 0.4, d), Vector3(s * 5.4, CH_H + 1.8, cz), stone)
		v.rotation.z = -s * 0.36
	for z in range(int(z0) - 2, int(CH_Z1), -3):
		var prev := Vector3(-CH_X + 0.1, CH_H - 0.2, z)
		for k in range(1, 9):
			var t := k / 8.0
			var x := lerpf(-CH_X + 0.1, CH_X - 0.1, t)
			var y := CH_H - 0.2 + (1.0 - absf(t - 0.5) * 2.0) * 3.6
			var p := Vector3(x, y, z)
			stick(prev, p, 0.08, _cable_ch)
			prev = p
	# circuit traces in the stone: green lines turning at right angles
	var trace := newglow(Color(0.3, 1.0, 0.5), 1.2)
	_chapel_glows.append([trace, 1.2])
	for s: float in [-1.0, 1.0]:
		for i in 26:
			var z := rng.randf_range(CH_Z1 + 1.0, z0 - 1.0)
			var y := rng.randf_range(0.6, 2.8)
			var ln := rng.randf_range(0.8, 3.0)
			box(Vector3(0.02, 0.03, ln), Vector3(s * (CH_X - 0.02), y, z), trace)
			box(Vector3(0.02, rng.randf_range(0.4, 1.4), 0.03), Vector3(s * (CH_X - 0.02), y + 0.4, z + ln * 0.5), trace)
			box(Vector3(0.025, 0.07, 0.07), Vector3(s * (CH_X - 0.02), y, z - ln * 0.5), trace)
	# lancet screens down the side walls, the same glass, quieter
	for s: float in [-1.0, 1.0]:
		for k in 6:
			var z := -31.0 - k * 4.4
			var q := quad(Vector2(1.1, 4.4), Vector3(s * (CH_X - 0.06), 4.6, z), -s * PI * 0.5, _lancet_m)
			q.name = "lancet"
			box(Vector3(0.12, 4.8, 0.2), Vector3(s * (CH_X - 0.06), 4.6, z - 0.62), stone)
			box(Vector3(0.12, 4.8, 0.2), Vector3(s * (CH_X - 0.06), 4.6, z + 0.62), stone)
	# the pews: cold metal, two banks either side of the aisle
	var pew_m := mat(Color(0.2, 0.21, 0.22), 0.35, 0.85)
	for row in 8:
		var z := -31.5 - row * 2.0
		for s: float in [-1.0, 1.0]:
			var cx := s * 5.6
			box(Vector3(8.0, 0.06, 0.5), Vector3(cx, 0.45, z), pew_m)
			box(Vector3(8.0, 0.6, 0.05), Vector3(cx, 0.85, z + 0.28), pew_m)
			box(Vector3(8.0, 0.04, 0.1), Vector3(cx, 1.16, z + 0.28), pew_m)
			for e: float in [-3.95, 0.0, 3.95]:
				box(Vector3(0.05, 0.45, 0.45), Vector3(cx + e, 0.22, z), pew_m)
			solid_box(Vector3(8.0, 1.2, 0.6), Vector3(cx, 0.6, z + 0.05))
	# the altarpiece: a screen the width of the nave in a black stone frame
	var black := mat(Color(0.02, 0.02, 0.022), 0.15, 0.6)
	quad(Vector2(15.0, 8.4), Vector3(0, 6.3, SCREEN_Z), 0.0, _glass_m).name = "altarpiece"
	box(Vector3(16.0, 0.5, 0.4), Vector3(0, 10.7, SCREEN_Z - 0.05), black)
	box(Vector3(16.0, 0.5, 0.4), Vector3(0, 1.9, SCREEN_Z - 0.05), black)
	for s: float in [-1.0, 1.0]:
		box(Vector3(0.5, 9.3, 0.4), Vector3(s * 7.75, 6.3, SCREEN_Z - 0.05), black)
	# the obsidian altar on its step
	var obs := mat(Color(0.015, 0.012, 0.02), 0.04, 0.3)
	box(Vector3(5.0, 0.2, 3.2), ALTAR + Vector3(0, 0.1, -0.3), mat(Color(0.08, 0.08, 0.085), 0.5, 0.2), true)
	box(Vector3(2.6, 1.0, 1.4), ALTAR + Vector3(0, 0.6, 0), obs, true)
	# the plugs: thick wire from the dark, hanging like industrial nooses
	var wire := mat(Color(0.03, 0.03, 0.035), 0.5, 0.5)
	var plug_m := mat(Color(0.5, 0.52, 0.5), 0.3, 0.9)
	for k in 7:
		var x := -2.4 + k * 0.8
		var zz := ALTAR.z - 0.3 + (0.3 if k % 2 else -0.4)
		var lo := 2.4 + float(k % 3) * 0.35
		stick(Vector3(x, CH_H + 2.5, zz), Vector3(x, lo, zz), 0.035, wire)
		cyl(0.06, 0.07, 0.24, Vector3(x, lo - 0.1, zz), plug_m, 10)
		for pr: float in [-0.025, 0.025]:
			box(Vector3(0.012, 0.08, 0.012), Vector3(x + pr, lo - 0.26, zz), plug_m)
		if k % 2 == 0:
			var tm := TorusMesh.new()
			tm.inner_radius = 0.16
			tm.outer_radius = 0.2
			tm.rings = 14
			tm.ring_segments = 5
			var lp := mesh(tm, Vector3(x, lo + 0.5, zz), wire)
			lp.rotation.x = PI * 0.5
	interactable("plugs", LINES["prompts"]["plugs"], Vector3(0, 3.2, ALTAR.z - 0.3), Vector3(5.0, 1.2, 1.2), "", false)
	interactable("screen", LINES["prompts"]["screen"], Vector3(0, 4.0, SCREEN_Z + 0.4), Vector3(12.0, 4.0, 0.5), "", false)
	interactable("altar", LINES["prompts"]["altar"], ALTAR + Vector3(0, 0.6, 0.75), Vector3(2.6, 1.0, 0.3), "", false)


## The congregation: the eyeless seated in the pews, faced to the screen.
## Bodies and heads are separate multimeshes so every head can turn at
## once ("perfect, silent unison") and keep turning to follow Carl.
func _congregation() -> void:
	var looks := [[Color(0.55, 0.55, 0.52), Color(0.82, 0.66, 0.54), Color(0.3, 0.26, 0.22)],
		[Color(0.14, 0.15, 0.17), Color(0.6, 0.45, 0.34), Color(0.06, 0.05, 0.05)],
		[Color(0.72, 0.72, 0.7), Color(0.9, 0.77, 0.67), Color(0.55, 0.5, 0.45)]]
	var counts := [0, 0, 0]
	var seats := []
	for row in 8:
		var z := -31.5 - row * 2.0
		for s: float in [-1.0, 1.0]:
			for k in 4:
				if rng.randf() < 0.1:
					continue
				var x := s * (2.6 + k * 1.8 + rng.randf_range(-0.2, 0.2))
				seats.append(Vector3(x, -0.31, z + 0.08))
	for i in seats.size():
		var v := i % 3 if rng.randf() < 0.85 else 0
		cong.append({"pos": seats[i], "v": v, "k": counts[v], "yaw": 0.0, "want": 0.0, "s": rng.randf_range(0.94, 1.06), "tilt": rng.randf_range(-0.12, 0.08)})
		counts[v] += 1
	for v in 3:
		var lk: Array = looks[v]
		var fig := figure(lk[0], lk[1], {"hair": lk[2], "legs": lk[0].darkened(0.3), "knees": true, "long_coat": false})
		var body_mm := MultiMesh.new()
		body_mm.transform_format = MultiMesh.TRANSFORM_3D
		body_mm.use_colors = true
		body_mm.mesh = _seated_mesh(fig)
		body_mm.instance_count = counts[v]
		var cloth := ((fig.get_meta("body") as MeshInstance3D).material_override as StandardMaterial3D).duplicate() as StandardMaterial3D
		cloth.vertex_color_use_as_albedo = true
		var head_mm := MultiMesh.new()
		head_mm.transform_format = MultiMesh.TRANSFORM_3D
		var hmi := _head_mi(fig)
		head_mm.mesh = hmi.mesh
		head_mm.instance_count = counts[v]
		var face := _eyeless_face(lk[1], lk[2], 2900 + v, false)
		fig.free()
		for c: Dictionary in cong:
			if int(c["v"]) == v:
				var sh := rng.randf_range(0.7, 1.1)
				body_mm.set_instance_color(int(c["k"]), Color(sh, sh, sh * rng.randf_range(0.95, 1.05)))
		for mm_i: Array in [[body_mm, cloth], [head_mm, face]]:
			var mmi := MultiMeshInstance3D.new()
			mmi.multimesh = mm_i[0]
			mmi.material_override = mm_i[1]
			mmi.custom_aabb = AABB(Vector3(-12, -1, -50), Vector3(24, 4, 30))
			dyn.add_child(mmi)
		mm_body.append(body_mm)
		mm_head.append(head_mm)
	_cong_write()
	for k in 6:
		var c: Dictionary = cong[k * 7 + 3]
		var it := interactable("congregation", LINES["prompts"]["congregation"], (c["pos"] as Vector3) + Vector3(0, 1.3, 0), Vector3(1.0, 1.2, 0.8), L("scan", "eyeless"), false, dyn)
		it.set_meta("eyeless", true)


## A seated body as one mesh: the torso as built, thighs forward, shins
## down (Anim.sit's pose), for the multimesh.
func _seated_mesh(fig: Node3D) -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.append_from((fig.get_meta("body") as MeshInstance3D).mesh, 0, Transform3D(Basis(Vector3.RIGHT, -0.06), Vector3.ZERO))
	for hip: Node3D in fig.get_meta("legs"):
		var hx := Transform3D(Basis(Vector3.RIGHT, PI * 0.5), hip.position)
		for c in hip.get_children():
			if c is MeshInstance3D:
				st.append_from((c as MeshInstance3D).mesh, 0, hx)
			elif c is Node3D:
				var kx := hx * Transform3D(Basis(Vector3.RIGHT, -PI * 0.5), (c as Node3D).position)
				for cc in c.get_children():
					if cc is MeshInstance3D:
						st.append_from((cc as MeshInstance3D).mesh, 0, kx)
	return st.commit()


func _cong_write() -> void:
	for c: Dictionary in cong:
		var v: int = c["v"]
		var k: int = c["k"]
		var s: float = c["s"]
		var pos: Vector3 = c["pos"]
		(mm_body[v] as MultiMesh).set_instance_transform(k, Transform3D(Basis().scaled(Vector3.ONE * s), pos))
		var hb := Basis(Vector3.UP, float(c["yaw"])) * Basis(Vector3.RIGHT, float(c["tilt"]))
		(mm_head[v] as MultiMesh).set_instance_transform(k, Transform3D(hb.scaled(Vector3.ONE * s), pos + Vector3(0, 1.72 * s, 0)))


## Mira on the altar in white; the Prophet at her left, Eren at her right;
## Monica in the dark behind with the plug. Monica is her Home figure with
## the eyes taken out and nothing else changed.
func _people() -> void:
	var skin := Color(0.86, 0.68, 0.56)
	var hair := Color(0.06, 0.05, 0.05)
	var white := Color(0.9, 0.9, 0.87)
	mira = figure(Color(0.93, 0.93, 0.9), skin, {"hair": hair, "long_hair": true, "legs": Color(0.93, 0.93, 0.9), "arms": true, "knees": true, "scale": 0.62, "long_coat": true})
	dyn.add_child(mira)
	Anim.sit(mira, 0.04)
	for a in mira.get_meta("arms"):
		(a as Node3D).rotation.x = -0.35
	mira.rotation.y = PI
	mira.position = Vector3(0, 1.1 - 0.86 * 0.62 + 0.05, ALTAR.z + 0.4)
	person("mira", LINES["prompts"]["mira"], mira, L("scan", "mira"))
	var robe := mat(Color(0.85, 0.85, 0.82), 0.9)
	prophet = figure(white, Color(0.78, 0.64, 0.55), {"arms": true, "knees": true, "hair": Color(0.2, 0.18, 0.16), "legs": white, "long_coat": true})
	dyn.add_child(prophet)
	_skirt(prophet, robe)
	_head_mi(prophet).material_override = _eyeless_face(Color(0.78, 0.64, 0.55), Color(0.2, 0.18, 0.16), 41, true)
	prophet.position = ALTAR + Vector3(2.0, 0.2, -0.2)
	prophet.rotation.y = PI
	person("prophet", LINES["prompts"]["prophet"], prophet, L("scan", "prophet")).set_meta("cultist", true)
	eren = figure(white, Color(0.84, 0.7, 0.6), {"arms": true, "knees": true, "hair": Color(0.6, 0.6, 0.6), "legs": white, "long_coat": true})
	dyn.add_child(eren)
	_skirt(eren, robe)
	_black_eyes(eren, Color(0.84, 0.7, 0.6))
	eren.position = ALTAR + Vector3(-2.0, 0.2, -0.2)
	eren.rotation.y = PI
	for a in eren.get_meta("arms"):
		(a as Node3D).rotation.x = -0.5
		(a as Node3D).rotation.z = 0.35 if (a as Node3D).position.x > 0.0 else -0.35
	person("eren", LINES["prompts"]["eren"], eren, L("scan", "eren")).set_meta("cultist", true)
	# Monica: as at home (the blouse, the curls), eyes gone to black spheres
	monica = figure(Color(0.55, 0.18, 0.28), skin, {"hair": hair, "long_hair": true, "legs": Color(0.12, 0.12, 0.14), "arms": true, "knees": true, "long_coat": false})
	dyn.add_child(monica)
	_black_eyes(monica, skin)
	monica.position = ALTAR + Vector3(0, 0.2, -5.0)
	monica.rotation.y = PI
	monica_it = person("monica", LINES["prompts"]["monica"], monica, L("scan", "monica"))
	monica_it.set_meta("cultist", true)
	plug = Node3D.new()
	monica.add_child(plug)
	var plug_m := mat(Color(0.55, 0.57, 0.55), 0.25, 0.95)
	cyl(0.09, 0.11, 0.42, Vector3.ZERO, plug_m, 12, plug)
	cyl(0.05, 0.05, 0.12, Vector3(0, -0.26, 0), plug_m, 10, plug)
	for pr: float in [-0.03, 0.03]:
		box(Vector3(0.014, 0.1, 0.014), Vector3(pr, -0.36, 0), plug_m, false, plug)
	stick(Vector3(0, 0.2, 0), Vector3(0, 3.5, 0.6), 0.035, mat(Color(0.03, 0.03, 0.035), 0.5, 0.5), plug)
	_hold_plug(false)
	monica.visible = false
	monica_it.collision_layer = 0


func _hold_plug(raised: bool) -> void:
	for a in monica.get_meta("arms"):
		var n := a as Node3D
		n.rotation.x = -2.95 if raised else -1.05
		n.rotation.z = (0.12 if n.position.x > 0.0 else -0.12)
	plug.position = Vector3(0, 2.25, -0.12) if raised else Vector3(0, 1.0, -0.42)
	plug.rotation.x = PI if raised else 0.0


## Lynx: hair loose, the long coat, the Bowie knife. Kept in the dark of
## the south-west aisle until she comes out.
func _lynx_build() -> void:
	var skin := Color(0.88, 0.74, 0.62)
	var hair := Color(0.12, 0.08, 0.06)
	lynx = figure(Color(0.09, 0.08, 0.1), skin, {"hair": hair, "long_hair": true, "legs": Color(0.1, 0.1, 0.12), "arms": true, "knees": true, "long_coat": true})
	lynx.position = LYNX_FROM
	dyn.add_child(lynx)
	lynx_it = person("lynx", LINES["prompts"]["lynx"], lynx, "")
	var arms: Array = lynx.get_meta("arms")
	lynx_knife = box(Vector3(0.03, 0.26, 0.05), Vector3(0, -0.74, -0.06), mat(Color(0.7, 0.72, 0.74), 0.15, 0.95), false, arms[1])
	box(Vector3(0.035, 0.1, 0.04), Vector3(0, -0.6, -0.04), mat(Color(0.15, 0.1, 0.07), 0.8), false, arms[1])
	lynx_face_eyeless = _eyeless_face(skin, hair, 777, false)
	var hd: Node3D = lynx.get_meta("head")
	var blood := mat(Color(0.42, 0.02, 0.02), 0.25)
	for s: float in [-1.0, 1.0]:
		var bs := box(Vector3(0.014, 0.11, 0.006), Vector3(s * 0.036, -0.03, -0.106), blood, false, hd)
		bs.visible = false
		lynx_blood.append(bs)
	var bm := box(Vector3(0.03, 0.05, 0.006), Vector3(0.0, -0.08, -0.105), blood, false, hd)
	bm.visible = false
	lynx_blood.append(bm)
	pearl = sphere(0.013, LYNX_AT + Vector3(0.35, 0.013, 0.45), mat(Color(0.95, 0.94, 0.9), 0.2), 8, dyn)
	pearl.visible = false
	pearl_it = interactable("pearl", LINES["prompts"]["pearl"], LYNX_AT + Vector3(0.35, 0.1, 0.45), Vector3(0.5, 0.3, 0.5), "", false, dyn)
	pearl_it.collision_layer = 0
	cube_floor = box(Vector3(0.07, 0.07, 0.07), LYNX_AT + Vector3(-0.6, 0.035, -0.2), mat(Color(0.01, 0.01, 0.012), 0.1, 0.9), false, dyn)
	cube_floor.visible = false
	cube_it = interactable("cube", LINES["prompts"]["cube"], LYNX_AT + Vector3(-0.6, 0.2, -0.2), Vector3(0.6, 0.5, 0.6), "", false, dyn)
	cube_it.collision_layer = 0
	_show(lynx, lynx_it, false)


## Lights by area; only the area Carl is in burns (tick()).
func _lights() -> void:
	var sh: Array = _area_lights["shore"]
	sh.append([light(Vector3(0, 8.0, 24.5), Color(0.35, 1.0, 0.55), 3.0, 20.0, false), 3.0])
	for x: float in [-9.0, 9.0]:
		sh.append([light(Vector3(x, 0.6, 22.2), Color(0.3, 1.0, 0.5), 2.0, 10.0, false), 2.0])
	sh.append([light(Vector3(0, 1.0, 37.0), Color(0.45, 0.25, 0.9), 0.8, 14.0, false), 0.8])
	sh.append([light(Vector3(-9, 2.0, 27.0), Color(0.5, 1.0, 0.85), 0.6, 9.0, false), 0.6])
	var ca: Array = _area_lights["cath"]
	ca.append([light(DESK + Vector3(0, 1.6, 1.4), Color(0.75, 0.7, 1.0), 1.6, 7.0, false), 1.6])
	ca.append([light(DOME + Vector3(0, -1.0, 0), Color(0.3, 1.0, 0.5), 2.4, 24.0, false), 2.4])
	for p: Vector3 in [Vector3(-15.5, 3.0, 8.0), Vector3(15.5, 3.0, 8.0), Vector3(-15.5, 3.0, -15.0), Vector3(15.5, 3.0, -15.0)]:
		ca.append([light(p, Color(0.3, 1.0, 0.48), 1.4, 11.0, false), 1.4])
	for p: Vector3 in [Vector3(-7.5, 4.0, -10.0), Vector3(7.5, 4.0, -10.0), Vector3(0, 5.5, 14.0)]:
		ca.append([light(p, Color(0.45, 1.0, 0.6), 1.0, 9.0, false), 1.0])
	ca.append([light(Vector3(9.0, 8.2, 10.0), AMBER, 0.6, 6.0, false), 0.6])
	var ch: Array = _area_lights["chapel"]
	ch.append([light(Vector3(0, 5.0, SCREEN_Z + 2.5), Color(0.35, 1.0, 0.5), 2.6, 17.0, false), 2.6])
	for s: float in [-1.0, 1.0]:
		ch.append([light(Vector3(s * 6.0, 5.0, SCREEN_Z + 3.0), Color(0.3, 1.0, 0.55), 1.2, 11.0, false), 1.2])
		ch.append([light(Vector3(s * 5.6, 3.2, -38.5), Color(0.4, 1.0, 0.65), 1.6, 9.0, false), 1.6])
	ch.append([light(ALTAR + Vector3(0, 4.0, 2.2), Color(0.85, 1.0, 0.92), 2.2, 8.0, false), 2.2])
	ch.append([light(Vector3(0, 4.0, -31.0), Color(0.4, 0.95, 0.6), 1.0, 9.0, false), 1.0])
	# the light that spills out of the far doors onto the cathedral floor
	ch.append([light(Vector3(0, 2.2, NORTH_Z + 1.6), Color(0.55, 1.0, 0.75), 1.4, 10.0, false), 1.4])
	for l: Array in ch:
		(l[0] as OmniLight3D).light_energy = 0.0
		(l[0] as OmniLight3D).visible = false


# ------------------------------------------------------------------ overlays

## The black card (with the two panels), the terminal on the monitor, the
## hold bar.
func _layers() -> void:
	_layer = CanvasLayer.new()
	_layer.layer = 9
	add_child(_layer)
	card_rect = ColorRect.new()
	card_rect.color = Color(0, 0, 0, 1)
	card_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	card_rect.visible = false
	_layer.add_child(card_rect)
	card_text = RichTextLabel.new()
	card_text.bbcode_enabled = true
	card_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card_text.anchor_left = 0.16
	card_text.anchor_right = 0.84
	card_text.anchor_top = 0.16
	card_text.anchor_bottom = 0.64
	card_text.add_theme_font_size_override("normal_font_size", 22)
	card_text.add_theme_font_size_override("bold_font_size", 30)
	card_rect.add_child(card_text)
	panel_box = HBoxContainer.new()
	panel_box.anchor_left = 0.06
	panel_box.anchor_right = 0.94
	panel_box.anchor_top = 0.08
	panel_box.anchor_bottom = 0.62
	panel_box.add_theme_constant_override("separation", 22)
	panel_box.visible = false
	card_rect.add_child(panel_box)
	panel_l = TextureRect.new()
	panel_l.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	panel_l.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	panel_l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel_l.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel_l.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	panel_l.modulate = Color(0.85, 1.0, 0.9)
	panel_box.add_child(panel_l)
	var pr := PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0, 0, 0, 1)
	sb.border_color = Color(0.25, 0.3, 0.27)
	sb.set_border_width_all(2)
	pr.add_theme_stylebox_override("panel", sb)
	pr.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	pr.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel_box.add_child(pr)
	panel_cap = Label.new()
	panel_cap.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel_cap.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	panel_cap.add_theme_font_size_override("font_size", 24)
	panel_cap.add_theme_color_override("font_color", Color(0.75, 0.75, 0.72))
	pr.add_child(panel_cap)
	# the terminal: white text on black, the bar, the message typed slowly
	term = PanelContainer.new()
	var ts := StyleBoxFlat.new()
	ts.bg_color = Color(0.0, 0.0, 0.0, 0.93)
	ts.border_color = Color(0.25, 0.8, 0.45, 0.7)
	ts.set_border_width_all(2)
	ts.set_content_margin_all(18)
	term.add_theme_stylebox_override("panel", ts)
	term.anchor_left = 0.2
	term.anchor_right = 0.8
	term.anchor_top = 0.16
	term.anchor_bottom = 0.5
	term.visible = false
	_layer.add_child(term)
	var vb := VBoxContainer.new()
	vb.add_theme_constant_override("separation", 12)
	term.add_child(vb)
	term_head = Label.new()
	term_head.add_theme_font_size_override("font_size", 18)
	term_head.add_theme_color_override("font_color", Color(0.55, 0.95, 0.7))
	vb.add_child(term_head)
	var bar_bg := ColorRect.new()
	bar_bg.color = Color(0.1, 0.14, 0.12)
	bar_bg.custom_minimum_size = Vector2(0, 14)
	vb.add_child(bar_bg)
	term_bar = ColorRect.new()
	term_bar.color = Color(0.4, 1.0, 0.6)
	term_bar.anchor_bottom = 1.0
	term_bar.anchor_right = 0.0
	bar_bg.add_child(term_bar)
	term_text = RichTextLabel.new()
	term_text.bbcode_enabled = true
	term_text.fit_content = true
	term_text.add_theme_font_size_override("normal_font_size", 22)
	term_text.add_theme_color_override("default_color", Color(0.96, 0.96, 0.94))
	term_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vb.add_child(term_text)
	# the hold bar
	hold_box = Control.new()
	hold_box.anchor_left = 0.35
	hold_box.anchor_right = 0.65
	hold_box.anchor_top = 0.62
	hold_box.anchor_bottom = 0.68
	hold_box.visible = false
	_layer.add_child(hold_box)
	hold_l = Label.new()
	hold_l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hold_l.add_theme_font_size_override("font_size", 20)
	hold_l.anchor_right = 1.0
	hold_l.anchor_bottom = 0.5
	hold_box.add_child(hold_l)
	var hb := ColorRect.new()
	hb.color = Color(0.1, 0.12, 0.11, 0.85)
	hb.anchor_top = 0.62
	hb.anchor_right = 1.0
	hb.anchor_bottom = 0.85
	hold_box.add_child(hb)
	hold_fill = ColorRect.new()
	hold_fill.color = Color(0.45, 1.0, 0.65)
	hold_fill.anchor_bottom = 1.0
	hold_fill.anchor_right = 0.0
	hb.add_child(hold_fill)


# ------------------------------------------------------------------ sound

## Mira's song: the lullaby sung by a child (a voice made of two formants
## over a wavetable, vibrato, a breath on each note), then bent into pure
## tones, then bit-crushed and ring-modulated into metal. One stream for
## the dark; a crushed loop of the first two lines for the chapel.
func _sounds() -> void:
	var raw := _voice()
	_song = AudioStreamPlayer3D.new()
	_song.stream = _song_stream(raw)
	_song.position = Vector3(0, 2.5, NORTH_Z - 3.0)
	_song.unit_size = 14.0
	_song.max_distance = 120.0
	_song.volume_db = -2.0
	add_child(_song)
	_song_loop = AudioStreamPlayer3D.new()
	_song_loop.stream = _loop_stream(raw)
	_song_loop.position = ALTAR + Vector3(0, 1.6, 0.4)
	_song_loop.unit_size = 9.0
	_song_loop.max_distance = 80.0
	_song_loop.volume_db = -6.0
	add_child(_song_loop)


func _table(f1: float, f2: float) -> PackedFloat32Array:
	var t := PackedFloat32Array()
	t.resize(512)
	var f0 := 430.0
	for h in range(1, 10):
		var fh := f0 * h
		var amp := (exp(-pow((fh - f1) / 240.0, 2.0)) + 0.75 * exp(-pow((fh - f2) / 420.0, 2.0)) + 0.06) / pow(float(h), 0.6)
		for i in 512:
			t[i] += amp * sin(TAU * h * i / 512.0)
	var mx := 0.001
	for i in 512:
		mx = maxf(mx, absf(t[i]))
	for i in 512:
		t[i] /= mx
	return t


func _voice() -> PackedFloat32Array:
	var tabs := {}
	for k in VOWELS:
		tabs[k] = _table(VOWELS[k][0], VOWELS[k][1])
	var sine := PackedFloat32Array()
	sine.resize(512)
	for i in 512:
		sine[i] = sin(TAU * i / 512.0)
	var total := 1.0
	for n: Array in MELODY:
		total += float(n[1]) * BEAT
	var s := PackedFloat32Array()
	s.resize(int(total * SONG_RATE))
	var ph := 0.0
	var t0 := 0.3
	var f_prev := 440.0 * pow(2.0, (int(MELODY[0][0]) - 69) / 12.0)
	var nz := 0.0
	for n: Array in MELODY:
		var f := 440.0 * pow(2.0, (int(n[0]) - 69) / 12.0)
		var dur := float(n[1]) * BEAT
		var tab: PackedFloat32Array = tabs[n[2]]
		var i0 := int(t0 * SONG_RATE)
		var i1 := mini(int((t0 + dur) * SONG_RATE), s.size())
		for i in range(i0, i1):
			var lt := float(i - i0) / SONG_RATE
			var gt := float(i) / SONG_RATE
			var w := clampf((gt - WARP_AT) / (CRUSH_AT - WARP_AT), 0.0, 1.0)
			var fr := lerpf(f_prev, f, minf(1.0, lt / 0.07))
			fr *= 1.0 + (0.005 + 0.006 * minf(1.0, lt / 0.6)) * sin(TAU * 5.4 * gt)
			fr *= pow(2.0, (w * w * 2.2 * sin(TAU * 0.31 * gt)) / 12.0)
			ph = fmod(ph + fr / SONG_RATE, 1.0)
			var idx := int(ph * 512.0) & 511
			var v := lerpf(tab[idx], sine[idx], w)
			var env := minf(1.0, lt / 0.05) * clampf((dur - lt) / 0.1, 0.0, 1.0)
			nz += (randf() * 2.0 - 1.0 - nz) * 0.3
			var breath := nz * 0.12 * (1.0 - w) * (1.0 if lt < 0.05 else 0.25)
			s[i] += (v * 0.55 + breath) * env
		f_prev = f
		t0 += dur
	# a room: two feedback taps, far away
	var d1 := int(0.13 * SONG_RATE)
	var d2 := int(0.29 * SONG_RATE)
	for i in range(d2, s.size()):
		s[i] += s[i - d1] * 0.3 + s[i - d2] * 0.18
	return s


func _crushed(raw: PackedFloat32Array, from_t: float, to_t: float, light_only: bool) -> PackedFloat32Array:
	var s := raw.duplicate()
	var hold := 0.0
	var cnt := 0
	for i in s.size():
		var t := float(i) / SONG_RATE
		var w := 0.25 if light_only else clampf((t - from_t) / (to_t - from_t), 0.0, 1.0)
		if w <= 0.0:
			continue
		var every := 1 + int(w * 11.0)
		if cnt % every == 0:
			hold = s[i]
		cnt += 1
		var lv := lerpf(48.0, 4.0, w)
		var q := roundf(hold * lv) / lv
		var v := q
		if not light_only:
			var car := sin(TAU * (1700.0 + 1500.0 * w + 260.0 * sin(t * 7.3)) * t)
			var scr := fmod(t * (2400.0 + 900.0 * sin(t * 13.0)), 1.0) * 2.0 - 1.0
			v = lerpf(q, q * car * 1.8 + scr * 0.22 * w, w * w)
		s[i] = clampf(v, -1.0, 1.0)
	return s


func _song_stream(raw: PackedFloat32Array) -> AudioStreamWAV:
	var s := _crushed(raw, CRUSH_AT, raw.size() / float(SONG_RATE), false)
	# the screech holds a moment past the last note, then cuts
	var tail := int(1.4 * SONG_RATE)
	var n0 := s.size()
	s.resize(n0 + tail)
	for i in tail:
		var t := float(n0 + i) / SONG_RATE
		var v := (fmod(t * (2900.0 + 700.0 * sin(t * 31.0)), 1.0) * 2.0 - 1.0) * 0.35 * sin(TAU * 1300.0 * t)
		s[n0 + i] = roundf(v * 4.0) / 4.0
	return _wav(s, false)


func _loop_stream(raw: PackedFloat32Array) -> AudioStreamWAV:
	var n := int(WARP_AT * SONG_RATE)
	var s := _crushed(raw.slice(0, n), 0.0, 1.0, true)
	for i in 800:
		s[i] *= i / 800.0
		s[n - 1 - i] *= i / 800.0
	return _wav(s, true)


## The coolant: two slow thumps and a slosh, about 38 to the minute.
func _throb_stream() -> AudioStreamWAV:
	var n := int(1.6 * SONG_RATE)
	var s := PackedFloat32Array()
	s.resize(n)
	var lp := 0.0
	for i in n:
		var t := float(i) / SONG_RATE
		var v := 0.0
		for st: float in [0.0, 0.32]:
			if t >= st:
				var e := exp(-(t - st) * 9.0)
				v += sin(TAU * (34.0 + 20.0 * e) * (t - st)) * e * (1.0 if st == 0.0 else 0.6)
		lp += ((randf() * 2.0 - 1.0) - lp) * 0.02
		v += lp * 0.6 * (0.5 + 0.5 * sin(TAU * t / 1.6))
		s[i] = v * 0.8
	return _wav(s, true)


## A soft, wet thud: a low body, a short wet click.
func _thud_stream() -> AudioStreamWAV:
	var n := int(0.5 * SONG_RATE)
	var s := PackedFloat32Array()
	s.resize(n)
	var lp := 0.0
	for i in n:
		var t := float(i) / SONG_RATE
		lp += ((randf() * 2.0 - 1.0) - lp) * 0.12
		s[i] = (sin(TAU * 58.0 * t) * exp(-t * 14.0) * 0.9 + lp * exp(-t * 30.0) * 1.6)
	return _wav(s, false)


func _wav(s: PackedFloat32Array, loop: bool) -> AudioStreamWAV:
	var b := PackedByteArray()
	b.resize(s.size() * 2)
	for i in s.size():
		b.encode_s16(i * 2, int(clampf(s[i], -1.0, 1.0) * 30000.0))
	var w := AudioStreamWAV.new()
	w.format = AudioStreamWAV.FORMAT_16_BITS
	w.mix_rate = SONG_RATE
	w.stereo = false
	w.data = b
	if loop:
		w.loop_mode = AudioStreamWAV.LOOP_FORWARD
		w.loop_begin = 0
		w.loop_end = s.size()
	return w


# ------------------------------------------------------------------ hooks

func objective() -> String:
	var f: Dictionary = main.flags
	var o: Dictionary = LINES["objective"]
	if f.has("mira_dead"):
		return ""
	if not f.has("core_doors"):
		return o["doors"]
	if not f.has("core_lynx"):
		return o["heart"]
	if not f.has("core_drive_in"):
		return o["cube"] if _cube_on_floor() else o["drive"]
	if not f.has("core_chapel"):
		return o["song"]
	return o["mira"]


func phone() -> String:
	var f: Dictionary = main.flags
	var p: Dictionary = LINES["phone"]
	if f.has("core_chapel"):
		return p["chapel"]
	if f.has("core_dark"):
		return p["dark"]
	if f.has("core_doors"):
		return p["inside"]
	return p["before"]


func intro() -> void:
	var ui = main.ui
	_busy = true
	await ui.think(L("intro", "arrive"))
	await ui.think(L("intro", "arrived"))
	await ui.think(L("intro", "frames"))
	ui.close()
	_busy = false


func interact(node: Object) -> bool:
	var ui = main.ui
	var f: Dictionary = main.flags
	var id := str(node.get_meta("id"))
	var lk: Dictionary = LINES["look"]
	match id:
		"phones":
			await ui.think(L("shore", "phones"))
			await ui.think(L("shore", "phones_2"))
		"river":
			await ui.think(L("shore", "river"))
		"facade":
			await ui.think(L("shore", "facade"))
		"racks":
			await ui.think(L("shore", "racks"))
		"doors":
			if f.has("core_doors"):
				await ui.think(L("doors", "open_already"))
			elif not f.has("river_done"):
				await ui.think(L("doors", "not_yet"))
			else:
				await _open_doors()
		"shards":
			await ui.think(lk["shards"])
			await ui.think(lk["shards_2"])
		"terminal":
			await ui.think(lk["terminal"])
		"veins":
			await ui.think(lk["veins"])
			await ui.think(lk["veins_2"])
		"cables":
			await ui.think(lk["cables"])
			await ui.think(lk["cables_2"])
		"chandelier":
			await ui.think(lk["chandelier"])
		"roundel":
			await ui.think(lk["roundel"])
		"valve":
			await _valve_look()
		"desk":
			await _desk_use()
		"pearl":
			await ui.think(lk["pearl"])
		"cube":
			if _cube_on_floor():
				await _take_cube()
			else:
				await ui.think(lk["cube_none"])
		"far_doors":
			await ui.think(lk["far_open"] if f.has("core_song") else lk["far_sealed"])
		"lynx":
			await ui.think(L("lynx", "ruin"))
		"congregation":
			await ui.think(L("chapel", "turn") if f.has("core_chapel") else L("chapel", "congregation"))
			await ui.think(L("chapel", "congregation"))
		"screen":
			await ui.think(L("chapel", "screen"))
		"plugs":
			await ui.think(L("chapel", "plugs"))
		"prophet":
			await ui.think(L("chapel", "prophet"))
		"eren":
			await ui.think(L("chapel", "eren"))
		"monica":
			await ui.think(L("chapel", "monica"))
		"mira", "altar":
			if f.has("mira_dead"):
				await ui.think(L("chapel", "mira_after"))
			elif f.has("core_chapel") and not _busy:
				await _monica_scene()
			else:
				await ui.think(L("chapel", "mira"))
		_:
			return false
	return true


# ------------------------------------------------------------------ the doors and the chamber

## The door swings in on silent hinges; the column of air; the cold anger.
func _open_doors() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	_busy = true
	f["cinematic"] = true
	await ui.think(L("doors", "look"))
	await ui.think(L("doors", "look_2"))
	ui.close()
	await p.face(Vector3(0, 2.4, FACADE_Z), 0.8)
	var tw := create_tween()
	tw.tween_property(door_leaf, "rotation:y", -1.45, 2.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(0.35).timeout
	air.restart()
	air.emitting = true
	main.play("pressure", -2.0, 0.7)
	main.play("wind", -2.0, 0.6)
	p.shake(1.6)
	ui.glitch(0.35, 0.6)
	var back := create_tween()
	back.tween_property(p, "position", p.position + Vector3(0, 0, 1.8), 0.7).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	await back.finished
	f["core_doors"] = true
	await ui.think(L("doors", "open"))
	await ui.think(L("doors", "fear"))
	await ui.think(L("doors", "anger"))
	await ui.think(L("doors", "enter"))
	ui.close()
	f.erase("cinematic")
	_busy = false
	main.update_hud()


## Through the door: the Hagia Sophia, the wire, the shards, the smell.
func _vast() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	_busy = true
	f["core_vast"] = true
	f["cinematic"] = true
	await main.player.face(DOME + Vector3(0, 4.0, 0), 2.4)
	await ui.think(L("vast", "hagia"))
	await ui.think(L("vast", "work"))
	await main.player.face(DESK + Vector3(0, 1.2, 0), 1.6)
	await ui.think(L("vast", "walls"))
	await ui.think(L("vast", "smell"))
	ui.close()
	f.erase("cinematic")
	_busy = false
	main.update_hud()


func _valve_look() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("coolant_seen"):
		await ui.think(L("valve", "again"))
		return
	await ui.think(L("valve", "look"))
	await ui.think(L("valve", "think"))
	await ui.think(L("valve", "think_2"))
	f["coolant_seen"] = true
	main.log_line("clue", L("valve", "log"))
	ui.show_toast("Ledger: the coolant valve", 3.0)


func _desk_use() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if _busy:
		return
	if not f.has("core_lynx"):
		await _lynx_scene()
	elif f.has("core_drive_in"):
		await ui.think(L("look", "desk_dark") if f.has("core_dark") else L("desk", "monitor"))
	elif _cube_on_floor():
		await ui.think(L("desk", "monitor"))
		await ui.think(L("desk", "no_drive"))
	else:
		await _install()


func _cube_on_floor() -> bool:
	return main.flags.get("core_drive_from", "") == "lynx_dropped" and not main.flags.has("core_cube_taken")


func _take_cube() -> void:
	var f: Dictionary = main.flags
	main.play("tap", -10.0, 0.8)
	cube_floor.visible = false
	cube_it.collision_layer = 0
	f["core_cube_taken"] = true
	await main.ui.think(L("lynx", "cube"))
	main.update_hud()


# ------------------------------------------------------------------ Lynx

## "CARL, STOP! YOU'RE GOING TO KILL HIM!" Out of the shadows with the
## knife; the choice; the black card with her voice under it; the run into
## the dark. Then, at once, the drive (the book does not let him stop).
func _lynx_scene() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	var ly: Dictionary = LINES["lynx"]
	var dk: Dictionary = LINES["desk"]
	_busy = true
	f["cinematic"] = true
	await ui.think(dk["doubt"])
	await ui.think(dk["doubt_2"])
	await p.face(DESK + Vector3(0, 1.1, 0), 1.0)
	await ui.think(dk["altar"])
	ui.close()
	var tw := create_tween()
	tw.tween_property(p, "position", CARL_AT, 1.4).set_trans(Tween.TRANS_SINE)
	await tw.finished
	await ui.think(dk["stalk"])
	# the shout, then her
	lynx.position = LYNX_FROM
	_lynx_face(false)
	lynx_knife.visible = true
	_show(lynx, lynx_it, true)
	main.play("sting", -6.0, 0.9)
	p.shake(0.4)
	await ui.say("Lynx", ly["shout"])
	ui.close()
	p.face(lynx.position + Vector3(0, 1.5, 0), 0.6)
	_move(lynx, [LYNX_FROM.lerp(LYNX_AT, 0.5) + Vector3(0.6, 0, 0.4), LYNX_AT], 2.4)
	await ui.think(ly["ruin"])
	await _wait(func() -> bool: return lynx.position.distance_to(LYNX_AT) < 0.05, 8.0)
	turn_to(lynx, p.position)
	await p.face(lynx.position + Vector3(0, 1.45, 0), 0.5)
	await ui.say("Lynx", ly["nathan"])
	Anim.crouch(lynx)
	lynx.position.y = -0.42
	await ui.think(ly["sob"])
	await p.face(lynx.position + Vector3(0, 1.1, 0), 0.6)
	await ui.say("Lynx", ly["good"])
	await ui.think(ly["frozen"])
	# the drive, if she kept it at the trailer
	var trust := int(main.trust.get("lynx", 0))
	if f.has("lynx_has_drive") and not f.has("core_drive_from"):
		if trust >= 0:
			await ui.think(ly["give_think"])
			await ui.say("Lynx", ly["give"])
			f["core_drive_from"] = "lynx_gave"
		else:
			f["core_drive_from"] = "lynx_dropped"
	elif not f.has("core_drive_from"):
		f["core_drive_from"] = "carl"
	# the choice
	var opts := LA("lynx", "choice")
	if f.has("saw_vr_nathan"):
		opts.append(ly["choice_present"])
	var i: int = await ui.choose(opts)
	if _pick >= 0:
		i = _pick if _pick < opts.size() else 1
	match i:
		0:
			f["core_lynx_choice"] = "silent"
			await ui.think(ly["silent"])
		1:
			f["core_lynx_choice"] = "growl"
			await ui.say("Carl", ly["growl"])
			await ui.think(ly["growl_think"])
		_:
			f["core_lynx_choice"] = "present"
			await ui.think(ly["present_think"])
			await ui.say("Carl", ly["present"])
			main.add_trust("lynx", 1)
			await ui.say("Lynx", ly["present_lynx"])
			await ui.think(ly["present_think_2"])
	Anim.idle(lynx, _t)
	lynx.position.y = 0.0
	await ui.say("Lynx", ly["not_hurt"])
	await ui.say("Lynx", ly["be_with"])
	# the black card: the frame withheld, the sound not
	ui.close()
	_card(L("cards", "lynx"))
	await get_tree().create_timer(0.6).timeout
	main.play("snap", -8.0, 0.55)
	main.play("whisper", -6.0, 1.4)
	await ui.say("Carl", ly["stop"])
	_card(L("cards", "lynx_2"))
	main.play("snap", -8.0, 0.5)
	await get_tree().create_timer(0.4).timeout
	await ui.say("Lynx", ly["beautiful"])
	await ui.say("Lynx", ly["hurt"])
	ui.close()
	_lynx_face(true)
	lynx_knife.visible = true
	pearl.visible = true
	pearl_it.collision_layer = 2
	_card_off()
	await ui.think(ly["stood"])
	await ui.think(ly["giggle"])
	main.play("murmur", -14.0, 1.6)
	await ui.think(ly["laugh"])
	ui.close()
	if f.get("core_drive_from", "") == "lynx_dropped":
		cube_floor.visible = true
		cube_it.collision_layer = 2
		main.play("tap", -6.0, 1.2)
	var gone := LYNX_FROM + Vector3(-1.5, 0, -6.0)
	_move(lynx, [LYNX_AT + Vector3(-3.0, 0, 2.0), LYNX_FROM, gone], 4.2)
	if f.get("core_drive_from", "") == "lynx_dropped":
		await ui.think(ly["drop"])
	await _wait(func() -> bool: return lynx.position.distance_to(gone) < 0.05, 10.0)
	_show(lynx, lynx_it, false)
	f["core_lynx"] = true
	main.log_line("event", ly["log"])
	await ui.think(ly["grief"])
	ui.close()
	f.erase("cinematic")
	_busy = false
	main.update_hud()
	if not _cube_on_floor() and not f.has("core_drive_in"):
		await _install()


func _lynx_face(eyeless: bool) -> void:
	var hm := _head_mi(lynx)
	if not hm.has_meta("orig"):
		hm.set_meta("orig", hm.material_override)
	hm.material_override = lynx_face_eyeless if eyeless else hm.get_meta("orig")
	for b in lynx_blood:
		(b as Node3D).visible = eyeless


# ------------------------------------------------------------------ the drive, Hameron, the dark, the song

## The held key: the drive goes into the port. [UPLOAD COMPLETE]. Two
## seconds of nothing. Hameron's message, typed at a person's speed.
func _install() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	var dk: Dictionary = LINES["desk"]
	if f.has("core_drive_in"):
		return
	_busy = true
	f["cinematic"] = true
	var tw := create_tween()
	tw.tween_property(p, "position", DESK + Vector3(0.0, 0.1, 1.45), 0.9).set_trans(Tween.TRANS_SINE)
	await tw.finished
	await p.face(DESK + Vector3(0, 1.0, -0.1), 0.6)
	_zoom(52.0, 1.2)
	await ui.think(dk["monitor"])
	ui.close()
	await _hold(dk["hold"], 1.6)
	main.play("snap", -4.0, 0.7)
	p.shake(0.3)
	drive_cube.visible = true
	await ui.think(dk["insert"])
	ui.close()
	term_head.text = dk["term_head"]
	term_bar.anchor_right = 0.0
	term_text.text = ""
	term.visible = true
	await get_tree().create_timer(0.3).timeout
	term_bar.anchor_right = 1.0
	term_text.text = dk["term_done"]
	main.play("ding", -8.0, 0.8)
	await ui.think(dk["bar"])
	ui.close()
	f["core_drive_in"] = true
	main.log_line("event", dk["log"])
	# silence, two seconds: every loop held at nothing
	_silence(true)
	await get_tree().create_timer(2.0).timeout
	await ui.think(dk["peace"])
	await ui.think(dk["won"])
	await ui.think(dk["new_msg"])
	ui.close()
	term_text.text = dk["term_done"] + "\n\n"
	var start := term_text.get_total_character_count()
	term_text.append_text("[color=#ffffff]" + dk["hameron"] + "[/color]")
	term_text.visible_characters = start
	var n := term_text.get_total_character_count()
	var typing := create_tween()
	typing.tween_property(term_text, "visible_characters", n, (n - start) * 0.085)
	var ticks := 0
	while typing.is_running():
		await get_tree().process_frame
		ticks += 1
		if ticks % 5 == 0:
			main.play("tap", -22.0, randf_range(1.5, 1.9))
	term_text.visible_characters = -1
	f["core_hameron"] = true
	await get_tree().create_timer(2.2).timeout
	term.visible = false
	await _blackout()
	await _song_begins()


## The screen goes black and the chamber with it.
func _blackout() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	main.play("outage", -4.0, 0.7)
	_hole_m.set_shader_parameter("power", 0.0)
	_area(_area_lights["cath"], false, 0.25)
	_area(_area_lights["shore"], false, 0.25)
	_set_power(_cath_glows, false, 0.25)
	_cable_m.set_shader_parameter("power", 0.0)
	_shard_m.set_shader_parameter("power", 0.0)
	_vein_m.set_shader_parameter("power", 0.15)
	if _env:
		create_tween().tween_property(_env, "ambient_light_energy", 0.015, 0.3)
	_zoom(72.0, 0.4)
	f["core_dark"] = true
	await ui.think(LINES["desk"]["black"])
	ui.close()
	await get_tree().create_timer(1.5).timeout


## Mira, from a distant room; the far doors; the warp; the knife.
func _song_begins() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	var sg: Dictionary = LINES["song"]
	_song.play()
	f["core_song"] = true
	await ui.think(sg["begin"])
	ui.caption("[i]" + sg["lyric"] + "[/i]", 5.0)
	await p.face(Vector3(0, 2.2, NORTH_Z), 2.4)
	# the far doors groan open on the chapel's light
	main.play("door", -2.0, 0.45)
	main.play("pressure", -10.0, 0.5)
	far_block.collision_layer = 0
	for fl: Array in far_leaves:
		create_tween().tween_property(fl[0], "rotation:y", fl[1], 3.5).set_trans(Tween.TRANS_SINE)
	_area(_area_lights["chapel"], true, 3.0)
	_set_power(_chapel_glows, true, 3.0)
	create_tween().tween_method(func(v: float): _glass_m.set_shader_parameter("power", v), 0.0, 1.0, 3.0)
	create_tween().tween_method(func(v: float): _lancet_m.set_shader_parameter("power", v), 0.0, 0.45, 3.0)
	if _env:
		create_tween().tween_property(_env, "ambient_light_energy", 0.14, 3.0)
	await ui.think(sg["doors"])
	await ui.think(sg["warp"])
	ui.close()
	# the knife: the last weapon prompt
	_silence(false)
	await _press(sg["prompt"])
	main.play("snap", -10.0, 1.6)
	_knife_fp()
	f["ev_knife"] = true
	await ui.think(sg["knife"])
	ui.close()
	f["core_knife"] = true
	f.erase("cinematic")
	_busy = false
	main.update_hud()
	_after_song()


## After the screech the song goes on from the altar, crushed, until Monica.
func _after_song() -> void:
	while is_inside_tree() and _song.playing:
		await get_tree().process_frame
	if is_inside_tree() and not main.flags.has("core_monica"):
		_song_loop.play()


func _knife_fp() -> void:
	if knife_fp:
		return
	knife_fp = Node3D.new()
	main.player.cam.add_child(knife_fp)
	knife_fp.position = Vector3(0.26, -0.25, -0.5)
	knife_fp.scale = Vector3.ONE * 0.6
	knife_fp.rotation = Vector3(0.5, 0.25, -0.35)
	var steel := newmat(Color(0.75, 0.77, 0.8), 0.12, 0.95)
	steel.emission_enabled = true
	steel.emission = Color(0.35, 0.5, 0.42)
	steel.emission_energy_multiplier = 0.35
	box(Vector3(0.022, 0.2, 0.05), Vector3(0, 0.12, 0), steel, false, knife_fp)
	box(Vector3(0.026, 0.11, 0.035), Vector3(0, -0.03, 0), mat(Color(0.18, 0.11, 0.07), 0.8), false, knife_fp)
	box(Vector3(0.03, 0.012, 0.08), Vector3(0, 0.025, 0), mat(Color(0.5, 0.45, 0.35), 0.4, 0.8), false, knife_fp)


# ------------------------------------------------------------------ the chapel

## Every head, at once, turns to him.
func _chapel_enter() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	_busy = true
	f["cinematic"] = true
	f["core_chapel"] = true
	await main.player.face(Vector3(0, 5.0, SCREEN_Z), 1.4)
	await ui.think(L("chapel", "room"))
	ui.close()
	_song_loop.volume_db = -18.0
	_turn_target = 1.0
	await get_tree().create_timer(0.8).timeout
	await main.player.face(Vector3(-3.0, 1.2, -36.0), 0.9)
	await ui.think(L("chapel", "turn"))
	await ui.think(L("chapel", "waiting"))
	ui.close()
	create_tween().tween_property(_song_loop, "volume_db", -6.0, 2.0)
	f.erase("cinematic")
	_busy = false
	main.update_hud()


## The altar; Monica from behind it with the plug; the song stops; two
## panels, the second black; Mira falls; mira_dead; eight seconds of black.
func _monica_scene() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	var c: Dictionary = LINES["chapel"]
	if f.has("core_monica"):
		return
	_busy = true
	f["cinematic"] = true
	f["core_monica"] = true
	var tw := create_tween()
	tw.tween_property(p, "position", CARL_CH, 1.6).set_trans(Tween.TRANS_SINE)
	await p.face(ALTAR + Vector3(0, 1.4, 0), 1.6)
	await ui.think(c["altar"])
	await ui.think(c["mira"])
	ui.close()
	# the fourth figure, out of the dark behind the altar
	monica.visible = true
	monica_it.collision_layer = 1 | 2
	monica.position = ALTAR + Vector3(0.3, 0.2, -4.6)
	await _move(monica, [ALTAR + Vector3(0.0, 0.2, -1.05)], 0.9)
	monica.rotation.y = PI
	await ui.think(c["fourth"])
	await ui.think(c["erased"])
	_zoom(48.0, 1.5)
	await p.face(monica.position + Vector3(0, 1.7, 0), 1.0)
	await ui.think(c["monica"])
	# the song stops; the room turns back to the altar as one
	_fade_out(_song_loop, 0.15)
	_silence(true)
	_turn_target = 0.0
	_turned_back = true
	await get_tree().create_timer(1.2).timeout
	await ui.think(c["stops"])
	_hold_plug(true)
	await ui.think(c["raise"])
	ui.close()
	# panel one is the room as it is now; panel two is black
	await p.face(ALTAR + Vector3(0, 1.75, -0.2), 0.6)
	_zoom(40.0, 0.4)
	await get_tree().create_timer(0.5).timeout
	var shot: ImageTexture = await _capture()
	panel_l.texture = shot
	panel_cap.text = L("cards", "plug_2")
	card_text.text = "[center]" + L("cards", "plug_1") + "[/center]"
	card_text.anchor_top = 0.68
	card_text.anchor_bottom = 0.92
	panel_box.visible = true
	card_rect.visible = true
	await get_tree().create_timer(2.6).timeout
	var th := AudioStreamPlayer.new()
	th.stream = _thud_stream()
	th.volume_db = -4.0
	add_child(th)
	th.play()
	await get_tree().create_timer(2.6).timeout
	panel_box.visible = false
	card_text.anchor_top = 0.16
	card_text.anchor_bottom = 0.64
	_card_off()
	# what's left: dimmer, Mira falling forward like a doll
	_hold_plug(false)
	plug.visible = false
	_glass_m.set_shader_parameter("power", 0.35)
	_area(_area_lights["chapel"], false, 0.0)
	(_area_lights["chapel"][0][0] as OmniLight3D).visible = true
	(_area_lights["chapel"][0][0] as OmniLight3D).light_energy = 0.9
	var fall := create_tween()
	fall.tween_property(mira, "rotation:x", -0.35, 0.25)
	fall.tween_interval(0.5)
	fall.tween_property(mira, "rotation:x", 1.15, 0.45).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await ui.think(c["falls"])
	ui.close()
	f["mira_dead"] = true
	main.log_line("event", c["log"])
	await _hold_black(8.0)
	f.erase("cinematic")
	_busy = false
	if not main._selftest:
		main.load_level("Chair")


## "The game holds on black for eight seconds with no input and no sound."
func _hold_black(secs: float) -> void:
	var ui = main.ui
	_block_input = true
	ui.close()
	ui.fade.color.a = 1.0
	ui.card_text.modulate.a = 0.0
	for k in main.amb:
		var ap = main.amb[k]
		if is_instance_valid(ap):
			ap.stop()
	for ap in main._sfx_pool:
		(ap as AudioStreamPlayer).stop()
	_song.stop()
	_song_loop.stop()
	AudioServer.set_bus_mute(0, true)
	await get_tree().create_timer(secs).timeout
	AudioServer.set_bus_mute(0, false)
	_block_input = false


func _input(e: InputEvent) -> void:
	if _block_input:
		get_viewport().set_input_as_handled()


func _exit_tree() -> void:
	AudioServer.set_bus_mute(0, false)
	if knife_fp and is_instance_valid(knife_fp):
		knife_fp.queue_free()
	if main and main.player:
		main.player.cam.fov = 72.0


# ------------------------------------------------------------------ tick

func tick(delta: float) -> void:
	if not main or not main.player:
		return
	var f: Dictionary = main.flags
	var pp: Vector3 = main.player.global_position
	# the phones on the sand wake as he passes
	if pp.z > 15.0:
		for ph: Array in phones:
			var sc: MeshInstance3D = ph[0]
			var on := sc.global_position.distance_to(pp) < 4.2
			if on != bool(ph[1]):
				ph[1] = on
				sc.material_override = _phone_lit if on else _phone_dark
	# lights: only the live area's (the browser shades 32)
	if not f.has("core_dark"):
		var shore_on := pp.z > 10.0
		for l: Array in _area_lights["shore"]:
			(l[0] as OmniLight3D).visible = shore_on
	# the frames are in the river
	if main.frames_on:
		main.frames_on = false
		main.ui.set_frames(0.0, main.connection)
		main.update_hud()
		if _t - _frames_note > 4.0:
			_frames_note = _t
			main.ui.show_toast(L("frames", "lost"), 3.0)
	# the congregation's heads
	var tgt := _turn_target
	if absf(_turn - tgt) > 0.001:
		_turn = move_toward(_turn, tgt, delta * (2.2 if tgt > _turn else 1.6))
	for c: Dictionary in cong:
		var d := pp - (c["pos"] as Vector3)
		var want := atan2(-d.x, -d.z)
		var e := smoothstep(0.0, 1.0, _turn)
		c["want"] = lerp_angle(float(c["want"]), want, minf(1.0, delta * 2.0))
		c["yaw"] = lerp_angle(0.0, float(c["want"]), e)
	if not cong.is_empty():
		_cong_write()
	# the Prophet and Eren watch him
	if f.has("core_song"):
		Anim.look(prophet, pp + Vector3(0, 1.5, 0), 0.6, 0.04)
		Anim.look(eren, pp + Vector3(0, 1.5, 0), 0.8, 0.04)
	# beats, gated on the flags and then on where he is
	if _busy or main.ui.busy or main.loading or f.has("mira_dead"):
		return
	if f.has("core_doors") and not f.has("core_vast") and pp.z < FACADE_Z - 3.0:
		_vast()
	elif f.has("core_vast") and not f.has("core_lynx") and Vector2(pp.x - DESK.x, pp.z - DESK.z).length() < 8.5:
		_lynx_scene()
	elif f.has("core_knife") and not f.has("core_chapel") and pp.z < NORTH_Z - 2.5:
		_chapel_enter()
	elif f.has("core_chapel") and not f.has("core_monica") and pp.z < -43.5:
		_monica_scene()


# ------------------------------------------------------------------ helpers

func _area(list: Array, on: bool, t: float) -> void:
	for l: Array in list:
		var o := l[0] as OmniLight3D
		if on:
			o.visible = true
		if t <= 0.0:
			o.light_energy = float(l[1]) if on else 0.0
			if not on:
				o.visible = false
			continue
		var tw := create_tween()
		tw.tween_property(o, "light_energy", float(l[1]) if on else 0.0, t)
		if not on:
			tw.tween_callback(func(): o.visible = false)


func _set_power(list: Array, on: bool, t: float) -> void:
	for g: Array in list:
		var m := g[0] as StandardMaterial3D
		if not on and t <= 0.0:
			m.emission_energy_multiplier = 0.0
			continue
		create_tween().tween_property(m, "emission_energy_multiplier", float(g[1]) if on else 0.0, maxf(t, 0.01))


## Every loop to nothing (or back): the two seconds after the upload, the
## silence when the song stops.
func _silence(on: bool) -> void:
	for k in main.amb:
		var ap = main.amb[k]
		if not is_instance_valid(ap):
			continue
		if on:
			if not ap.has_meta("db"):
				ap.set_meta("db", ap.volume_db)
			ap.volume_db = -80.0
		elif ap.has_meta("db"):
			create_tween().tween_property(ap, "volume_db", float(ap.get_meta("db")), 1.5)


func _fade_out(ap: Node, t: float) -> void:
	if ap and is_instance_valid(ap) and ap.playing:
		var tw := create_tween()
		tw.tween_property(ap, "volume_db", -80.0, t)
		tw.tween_callback(func(): ap.stop())


func _hold(text: String, secs: float) -> void:
	hold_l.text = text
	hold_fill.anchor_right = 0.0
	hold_box.visible = true
	var v := 0.0
	while v < 1.0 and is_inside_tree():
		await get_tree().process_frame
		var dt := get_process_delta_time()
		if main._selftest or Input.is_action_pressed("interact"):
			v += dt / secs
		else:
			v = maxf(0.0, v - dt * 0.9)
		hold_fill.anchor_right = clampf(v, 0.0, 1.0)
	hold_box.visible = false


func _press(text: String) -> void:
	hold_l.text = text
	hold_fill.anchor_right = 0.0
	hold_box.visible = true
	await get_tree().create_timer(0.5).timeout
	while is_inside_tree() and not main._selftest and not Input.is_action_just_pressed("interact"):
		await get_tree().process_frame
	hold_box.visible = false


func _capture() -> ImageTexture:
	var ui = main.ui
	ui.root.visible = false
	await get_tree().process_frame
	await get_tree().process_frame
	await RenderingServer.frame_post_draw
	var img := get_viewport().get_texture().get_image()
	ui.root.visible = true
	return ImageTexture.create_from_image(img)


func _card(text: String) -> void:
	card_text.text = "[center]" + text + "[/center]"
	panel_box.visible = false
	card_rect.visible = true


func _card_off() -> void:
	card_rect.visible = false


func _zoom(fov: float, t: float) -> void:
	create_tween().tween_property(main.player.cam, "fov", fov, t).set_trans(Tween.TRANS_SINE)


func _move(fig: Node3D, pts: Array, speed: float) -> void:
	for pt: Vector3 in pts:
		while is_inside_tree():
			var d := pt - fig.position
			var dist := d.length()
			var dt := get_process_delta_time()
			var step := speed * dt
			if dist <= maxf(step, 0.02):
				fig.position = pt
				break
			fig.position += d / dist * step
			if Vector2(d.x, d.z).length() > 0.02:
				fig.rotation.y = lerp_angle(fig.rotation.y, atan2(-d.x, -d.z), minf(1.0, dt * 8.0))
			Anim.walk(fig, _t, speed / 1.6, 0.0, 1.0)
			await get_tree().process_frame
	if is_inside_tree():
		Anim.idle(fig, _t, 0.0)


func _show(fig: Node3D, it: CollisionObject3D, on: bool) -> void:
	fig.visible = on
	if it:
		it.collision_layer = (1 | 2) if on else 0


func _head_mi(fig: Node3D) -> MeshInstance3D:
	for c in (fig.get_meta("head") as Node3D).get_children():
		if c is MeshInstance3D:
			return c
	return null


func _skirt(fig: Node3D, m: Material) -> MeshInstance3D:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	Body.loft(st, [[0.02, 0.36, 0.36, 0.0], [0.45, 0.3, 0.27, 0.0], [0.95, 0.22, 0.16, 0.0]], Rect2(0, 0, 1, 1), Transform3D(), false, true, 12)
	st.generate_normals()
	return mesh(st.commit(), Vector3.ZERO, m, fig)


## A face with the eyes gone (the book's "deep, hollowed-out craters"); the
## Prophet's crossed with scars, faded and fresh.
func _eyeless_face(skin: Color, hair: Color, seed: int, scars: bool) -> StandardMaterial3D:
	var base: StandardMaterial3D = Body.face_mat(skin, hair, false, seed)
	var img: Image = (base.albedo_texture as Texture2D).get_image()
	if img.is_compressed():
		img.decompress()
	img.clear_mipmaps()
	img.convert(Image.FORMAT_RGBA8)
	var ey := (0.155 - 0.022) / 0.355 * 256.0
	for s: float in [-1.0, 1.0]:
		var ex := 128.0 + asin(s * 0.034 / 0.088) / TAU * 256.0
		Body._ell(img, ex, ey, 10.0, 7.0, skin.darkened(0.22), 0.5)
		Body._ell(img, ex, ey, 7.5, 4.8, Color(0.42, 0.2, 0.17), 0.3)
		Body._ell(img, ex, ey + 0.5, 4.2, 2.6, Color(0.1, 0.03, 0.03))
		for k in 7:
			var a := TAU * k / 7.0
			Body._rect(img, ex + cos(a) * 6.0, ey + sin(a) * 4.0, 2, 1, Color(skin.darkened(0.4), 0.8))
	if scars:
		var r := RandomNumberGenerator.new()
		r.seed = seed
		for k in 9:
			var x0 := r.randf_range(90, 166)
			var y0 := r.randf_range(60, 150)
			var a2 := r.randf() * TAU
			var ln := r.randf_range(10, 34)
			var c := Color(0.62, 0.12, 0.1) if k % 3 == 0 else skin.lightened(0.18)
			for j in int(ln):
				Body._rect(img, x0 + cos(a2) * j, y0 + sin(a2) * j, 1.5, 1.5, c)
	img.generate_mipmaps()
	var m := base.duplicate() as StandardMaterial3D
	m.albedo_texture = ImageTexture.create_from_image(img)
	return m


## Eyes become "perfect, glistening black spheres": the painted eyes filled
## black on the figure's own face, and two wet black beads set in them.
## Nothing else on the face changes.
func _black_eyes(fig: Node3D, skin: Color) -> void:
	var hm := _head_mi(fig)
	var base := hm.material_override as StandardMaterial3D
	var img: Image = (base.albedo_texture as Texture2D).get_image()
	if img.is_compressed():
		img.decompress()
	img.clear_mipmaps()
	img.convert(Image.FORMAT_RGBA8)
	var ey := (0.155 - 0.022) / 0.355 * 256.0
	for s: float in [-1.0, 1.0]:
		var ex := 128.0 + asin(s * 0.034 / 0.088) / TAU * 256.0
		Body._ell(img, ex, ey, 8.0, 4.2, Color(0.01, 0.01, 0.012))
		Body._ell(img, ex, ey + 3.5, 6.0, 1.2, Color(skin.darkened(0.35), 0.6), 0.6)
	img.generate_mipmaps()
	var m := base.duplicate() as StandardMaterial3D
	m.albedo_texture = ImageTexture.create_from_image(img)
	hm.material_override = m
	var bead := mat(Color(0.005, 0.005, 0.006), 0.02, 0.6)
	var hd: Node3D = fig.get_meta("head")
	for s: float in [-1.0, 1.0]:
		var b := sphere(0.0125, Vector3(s * 0.034, 0.022, -0.094), bead, 8, hd)
		b.scale = Vector3(1.25, 0.8, 0.7)


# ------------------------------------------------------------------ dev and test

## Shot hooks: beat=air | inside | lynx | dark | chapel | monica.
func apply_args(a: Dictionary) -> void:
	var f: Dictionary = main.flags
	var beat := str(a.get("beat", ""))
	if beat == "":
		return
	f["river_done"] = true
	f["core_doors"] = true
	f["core_vast"] = true
	_busy = true
	door_leaf.rotation.y = -1.45
	if beat == "air":
		door_leaf.rotation.y = -0.5
		air.restart()
		air.emitting = true
	if beat == "lynx":
		f["core_vast"] = true
		_busy = true
		_show(lynx, lynx_it, true)
		lynx.position = LYNX_AT
		turn_to(lynx, main.player.position)
		_lynx_face(str(a.get("eyeless", "")) == "1")
		pearl.visible = str(a.get("eyeless", "")) == "1"
	if beat in ["dark", "chapel", "monica"]:
		_busy = true
		f["core_lynx"] = true
		f["core_drive_in"] = true
		f["core_dark"] = true
		f["core_song"] = true
		_hole_m.set_shader_parameter("power", 0.0)
		_area(_area_lights["cath"], false, 0.0)
		_area(_area_lights["shore"], false, 0.0)
		_set_power(_cath_glows, false, 0.0)
		_cable_m.set_shader_parameter("power", 0.0)
		_shard_m.set_shader_parameter("power", 0.0)
		_vein_m.set_shader_parameter("power", 0.15)
		if _env:
			_env.ambient_light_energy = 0.015
		far_block.collision_layer = 0
		for fl: Array in far_leaves:
			(fl[0] as Node3D).rotation.y = fl[1]
		_area(_area_lights["chapel"], true, 0.0)
		_set_power(_chapel_glows, true, 0.0)
		_glass_m.set_shader_parameter("power", 1.0)
		_lancet_m.set_shader_parameter("power", 0.45)
		if _env:
			_env.ambient_light_energy = 0.14
	if beat in ["chapel", "monica"]:
		f["core_knife"] = true
		f["core_chapel"] = true
		_knife_fp()
		_turn = 1.0
		_turn_target = 1.0
	if beat == "monica":
		f["core_monica"] = true
		monica.visible = true
		monica.position = ALTAR + Vector3(0.0, 0.2, -1.05)
		_hold_plug(str(a.get("raised", "1")) == "1")
		_turn = 0.0
		_turn_target = 0.0


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


func selftest() -> void:
	var p = main.player
	var f: Dictionary = main.flags
	# headless on llvmpipe the shaded vault crawls; the test is of the
	# script, so the level is hidden while it runs (it still ticks)
	visible = false
	f["river_done"] = true
	await intro()
	print("ok intro")
	for id in ["phones", "river", "facade", "racks"]:
		await _by_id(id)
	p.position = Vector3(0, 0.1, 22.5)
	await _by_id("doors")
	print("ok doors ", f.has("core_doors"))
	p.position = Vector3(0, 0.1, 14.0)
	await _wait(func() -> bool: return f.has("core_vast"), 5.0)
	await _wait(func() -> bool: return not _busy, 30.0)
	print("ok vast ", f.has("core_vast"))
	for id in ["shards", "terminal", "veins", "cables", "chandelier", "roundel", "far_doors"]:
		await _by_id(id)
	await _by_id("valve")
	print("ok valve coolant_seen=", f.has("coolant_seen"))
	# the main path: Carl has the drive; Lynx; the growl (choice 1)
	await _by_id("desk")
	await _wait(func() -> bool: return f.has("core_knife"), 90.0)
	print("ok lynx choice=", f.get("core_lynx_choice"), " from=", f.get("core_drive_from"), " drive_in=", f.has("core_drive_in"),
		" hameron=", f.has("core_hameron"), " dark=", f.has("core_dark"), " song=", f.has("core_song"), " knife=", f.has("core_knife"))
	await _wait(func() -> bool: return not _busy, 10.0)
	# the chapel
	p.position = Vector3(0, 0.1, -30.0)
	await _wait(func() -> bool: return f.has("core_chapel"), 5.0)
	await _wait(func() -> bool: return not _busy, 30.0)
	print("ok chapel turned=", snappedf(_turn, 0.01))
	for id in ["congregation", "screen", "plugs", "prophet", "eren"]:
		await _by_id(id)
	p.position = Vector3(0, 0.1, -44.6)
	await _wait(func() -> bool: return f.has("core_monica"), 5.0)
	await _wait(func() -> bool: return f.has("mira_dead"), 90.0)
	await _wait(func() -> bool: return not _busy, 20.0)
	print("ok mira_dead=", f.has("mira_dead"), " block=", _block_input, " muted=", AudioServer.is_bus_mute(0))
	# the other ways through Lynx, for the script's sake
	main.ui.fade.color.a = 0.0
	var keep := f.duplicate()
	for case: Array in [[-1, false, 0], [1, true, 2], [0, true, 0]]:
		for k in ["core_lynx", "core_drive_from", "core_cube_taken", "core_lynx_choice"]:
			f.erase(k)
		f["lynx_has_drive"] = true
		main.trust["lynx"] = case[0]
		if case[1]:
			f["saw_vr_nathan"] = true
		_pick = case[2]
		await _lynx_scene()
		print("ok lynx alt trust=", case[0], " choice=", f.get("core_lynx_choice"), " from=", f.get("core_drive_from"), " cube_on_floor=", _cube_on_floor(), " trust_after=", main.trust["lynx"])
		if _cube_on_floor():
			await _by_id("cube")
			print("ok cube taken=", f.has("core_cube_taken"))
	_pick = -1
	for k in keep:
		f[k] = keep[k]
	f.erase("lynx_has_drive")
	f.erase("saw_vr_nathan")
	await main.selftest_all_interactables()
	visible = true
