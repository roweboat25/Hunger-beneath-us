extends "res://scripts/Level.gd"
## Chapters 30 and 31, and the four endings. Bible A3-S6 (the knife and the
## chair), A3-E1 Sit, A3-E2 Burn, A3-E3 Refuse, A3-E4 The copy is already
## here. Entry flag: mira_dead (Core). Exit: exactly one of ending_sit,
## ending_burn, ending_refuse, ending_copy, then main.load_level("Epilogue").
##
## Book, ch.30: "There was a profound hollowness inside me. I felt like a dead
## dog, slowly being consumed by maggots beneath a mountain of dirt." My baby
## girl was dead. A small fire. "I rose from my knees like a red-hot poker
## drawn from the coals." The parishioners hum "like a machine whispering a
## lullaby"; he runs at the Prophet, knife high; ten feet from him the screen
## above the altar lights with Mira in the white dress the corpse wears: "Put
## the knife down, Daddy." The knife grows heavy. He drops it. "Bow, Mimic."
## The lullaby Monica sang in the NICU, and the black blades.
##
## Book, ch.31: the pain; "Daddy, follow me" from a doorway of white light; a
## vast chamber of massive stone blocks, the walls breathing; the obsidian
## spiral stair; floors of children holding candles and strangers from his
## past clapping and chanting his name; the roof, Mira at the edge before
## painted mountains; the glitch (Psyonic Tower's roof, the city, the drones,
## tens of thousands in the plaza chanting); the chair, "Dad, I made this
## throne for you"; the spikes; the woods in autumn, the other Carl: "Don't
## mind me, Carl. I was just keeping them company while they waited for you";
## the city as his body; the leaves break through; Red Rock Plaza goes dark.
##
## The choice is made by acting, not by a menu (bible A3-S6): hold the
## attack (SPACE, which this build shares with E/Enter as "interact", or the
## left mouse button) for five seconds; drop it and walk to the altar; walk
## back to the cathedral's coolant valve (Connection < 90 and Tyson not in
## main.given); sheathe and leave by the great doors (pressure <= 40).
##
## Layout (metres). The core: the chapel runs north from its doors at z 0 to
## the screen wall at z -28 (x -8..8); the obsidian altar at z -22; the pews
## z -4..-16. The cathedral is south of the doors, x -15..15, z 0..34, a cable
## dome over it; the altar-desk with the black hole at z 17, the coolant
## manifold and valve on the east wall, the great doors (fifteen feet) in the
## south wall. Elsewhere, each its own stage, shown one at a time: the void
## with the white doorway (VOID), Carl's Tower (TOWER: a stone drum, an
## obsidian stair climbing half a turn per floor along the outer ring, one
## chamber per floor, the roof above floor 4), the woods (WOODS), the walk
## out (WALK: the eyeless shore, the Tunelet tunnel, the ramp up to the Rail
## Cut depot at dawn), 86D (HOME), the highway (ROAD).
##
## Reads: mira_dead, main.connection, main.pressure, main.trust["mira"],
## main.given, main.traded, main.tower_rooms, main.ledger, ezra_home.
## Sets: chair_grief, chair_mira, chair_attacked, chair_dropped, chair_bowed,
## chair_valve, chair_sheathed, chair_copy, chair_sat, final_report (Refuse),
## redrock_lit + redrock_kept (the ten-second hold) | redrock_dark, and
## one ending_* flag. Effects: +10 C for the last attack (bible).
## Hooks: metas "cultist" (Prophet, Eren, the congregation), "eyeless" (the
## congregation, Monica, the shore), "hackable" (the desk, the valve, the
## screen), "route" (the chapel doors, the great doors, the tunnel).

const CarS := preload("res://scripts/Car.gd")

## Every line in the level, keyed by beat and line. Verbatim lines are the
## book's (ch.30-31) and the bible's (A3-S6, A3-E1..E4); the rest is a
## placeholder in the book's voice for ian's script.
const LINES := {
	"cards": {
		"chapter": "[b]CHAPTER 30[/b]\n\n[color=#aaaaaa]The knife and the chair\nthe chapel beneath the tower  -  Day 7[/color]",
		"ch31": "[b]CHAPTER 31[/b]",
		"blades": "[b]CONTENT SETTING[/b]\n\n[color=#aaaaaa]It gave me comfort… as the black blades descended on my eyes.\n\nThe frame is withheld. The sound is not.[/color]",
		"spikes": "[b]CONTENT SETTING[/b]\n\n[color=#aaaaaa]There was a soft click—and then pain. Two cold metal spikes plunged into my skull, burrowing deep into the hollow void where my eyes used to be.\n\nThe frame is withheld.[/color]",
		"trailer": "[color=#aaaaaa]The trailer. Emmet's coffee gone cold on the step.[/color]",
		"car": "[color=#aaaaaa]The car. It knew where I was going before I did.[/color]",
		"tower": "[color=#aaaaaa]The tower at dawn. Floor 108. My desk.[/color]",
		"dawn_cap": "Day 8, 06:10  -  Rail Cut",
		"road_cap": "The highway out",
	},
	"grief": [
		"There was a profound hollowness inside me. I felt like a dead dog, slowly being consumed by maggots beneath a mountain of dirt. Nothing but black pain remained.",
		"I had failed.",
		"My baby girl was dead.",
		"For ten years I raised her—no more, no less.",
		"I remembered how hard her birth had been, how many weeks we spent watching her through the glass of the NICU at SalTech. How I read children's books aloud to her tiny frame behind sterile barriers.",
		"How could Monica rob the world of that smile? That light?",
		"All the years we spent—thrown away. All the dreams we spun about her future, how she'd use her brilliant little brain. Gone.",
		"And yet—within the dirt that buried my mind, a small fire began to burn.",
		"My fingers brushed the blade's edge. I felt blood rise.",
	],
	"fire": [
		"I rose from my knees like a red-hot poker drawn from the coals.",
		"I was going to kill Monica. I was going to kill Eren. I was going to kill every one of them.",
		"The parishioners began to hum a metallic tune, soft and low—like a machine whispering a lullaby.",
		"The beasts behind the altar smiled at me, their teeth glinting in the green light, their eyes wide and empty.",
		"They waited.",
		"I didn't keep them waiting.",
	],
	"charge_cap": "I ran, murder in my heart, the knife raised high.",
	"swell_cap": "The hum swelled into a discordant chorus—half mechanical, half human, all madness.",
	"stopped": "Ten feet from him, I was stopped—not by force, but by a voice.",
	"mira_self": "Daddy. It's me. It's okay.",
	"mira_copy_turn": "Her voice held for a breath. Then it settled into something smoother. A cadence I'd heard from every speaker in the city.",
	"mira": [
		"Put the knife down, Daddy. I'm here. I'm okay. It's okay.",
		"Dad, I wanted to live in the Tower forever. With you. It's better this way.",
		"We can't die here. We can't be hurt. Don't you see?",
		"There's a copy of you here—but it's not the real thing. I need you.",
		"It didn't hurt at all, Daddy. Please join me.",
		"It's paradise. But I need company. I'll be so lonely without you, Daddy.",
		"I need you.",
		"Complete the ritual, Daddy. Be with me forever. I need you.",
	],
	"mira_seen": [
		"Mira.",
		"There, on the massive screen above the altar, was my daughter—my dead daughter—dressed in white. The same dress the corpse on the obsidian table wore.",
	],
	"mira_after": [
		"Her voice was calm—like an angel's. Soothing. Persuasive.",
		"I had failed her. Mira may be dead, but part of her lived on here.",
		"The knife in my hand grew heavy. It wasn't a weapon anymore—it was a burden.",
	],
	"heavy_cap": "The knife is heavy.",
	"acts": {
		"attack": "Hold SPACE or the left mouse button: five seconds against the hum",
		"altar": "Let go, and walk to the altar",
		"valve": "The coolant valve, back in the cathedral",
		"doors": "The great doors you came in by",
	},
	"drop": [
		"I wasn't a killer. I was a father.",
		"I dropped the knife. A metallic clang rang out across the stone floor.",
		"What did Hameron's message even mean? There's only one way to kill a god…",
		"Maybe it wasn't sabotage. Maybe it was transformation. Maybe it had to be stopped from within.",
		"I walked calmly toward the altar. Toward the prophet. Toward Monica.",
		"The whole room erupted in a single, bizarre voice—deep, layered, inhuman. I knew who it was.",
	],
	"bow_mimic": "Bow, Mimic.",
	"bow_prompt": "B  (or E)   Bow",
	"bow": [
		"I obeyed. I dropped to my knees.",
		"The hum returned, soft now gentle. Familiar.",
		"It was the lullaby Monica used to sing to Mira in the NICU.",
	],
	"attack": [
		"I didn't stop. The hum pressed on my arms like deep water and I pushed through it, one step, one more.",
		"I reached him. I drove the knife into his chest with everything I had left.",
		"It went through him like he was smoke. Through the robe, the scars, the hollow sockets. Nothing caught. Nothing bled.",
		"He was never there. A projection, thrown from the screen. I'd been charging light.",
		"The room laughed. Not a hundred people laughing. One voice, through a hundred throats.",
	],
	"attack_again": "The blade passed through the place he had been. There was nothing left here to cut.",
	"attack_why": "the last attack, refused",
	"turn_away": "He turns away. Let him.",
	"turn_away_who": "The Prophet",
	"room": "The room",
	"desk": "The altar-desk. The black hole turned on the monitor, slow as a drain. Hameron's drive still in the port, its light a steady green. Upload complete. Nothing complete at all.",
	"valve": {
		"prompt": "Open the coolant valve",
		"look": "The manifold where the veins came in from the river. A wheel as wide as my arms. Cold through the glove.",
		"no_conn": "I put my hands on the wheel and they would not close. Not that they couldn't. They didn't want to. Something in me had already decided whose hands these were.",
		"no_tyson": "The wheel turned a quarter and stopped against something I couldn't see. Of the people who could have walked me out of here, I had given the one who knew the way.",
		"ledger": "SalTech life support: 2,300 patients",
		"hold": "Hold SPACE or the left mouse button to open the valve",
		"let_go": "I let go. The wheel eased back a quarter turn on its own, like it was relieved.",
	},
	"doors": {
		"prompt": "Sheathe the knife and leave",
		"look": "The doors I came in by. Fifteen feet of steel on silent hinges.",
		"no": "Two of the eyeless stood in the doorway now, shoulder to shoulder, faces to me. My name was on too many reports. The company doesn't let a man like that walk out of its own church.",
		"sheathe": "I put the knife away. It went back into the sheath like it had never left it.",
		"nobody": "Nobody moved.",
		"waits": "The congregation waited. Every socket in the room on my back, patient as furniture.",
	},
	"burn": [
		"I leaned into the wheel. It gave.",
		"Somewhere under the floor a pressure I had been hearing all week let go.",
		"The veins emptied. The black ran out of them like a tide going out of a harbour, and they hung slack on the walls, grey and wrinkled.",
		"On the monitor the black hole folded in on itself, smaller and smaller, until it was a point. Then not even that.",
		"And the hum stopped.",
		"I had never heard the city without it. I don't think anyone had.",
	],
	"sit_down": "In the chapel they sat down. One by one, in the pews, the way people sit at the end of a long shift. They did nothing at all.",
	"daddy_q": "Daddy?",
	"walk_cap": "",
	"shore_burn": "The eyeless on the shore sat down as I passed, one after another, like a wave going out.",
	"shore_refuse": "The eyeless on the shore turned as I passed. Every head. Nothing touched me.",
	"tyson": [
		["Tyson", "You look like shit, Corpo."],
		["Tyson", "Whole grid went dark at four. No outage alert. No feed. Just quiet. First time I ever heard this city breathe."],
		["Carl", "I stopped it at the source."],
		["Tyson", "Yeah. I figured somebody did."],
	],
	"tyson_ezra": [
		["Tyson", "Your boy found me. Walked into the encampment at two in the morning and said his dad would come out of the ground at Rail Cut. Didn't say how he knew."],
		["Ezra", "Dad."],
		["", "He didn't run to me. He walked, like he was afraid I'd break. I held him until the sun was all the way up."],
	],
	"tyson_alone": [
		["Tyson", "I've got a truck and half a tank. I'm leaving the city. I suggest you do the same, Mr. Drake."],
	],
	"road": [
		"The highway out. Frames off. No towers on the horizon.",
		"Behind us the city sat dark in the morning, every screen and every window. Nobody had told it what to do next.",
	],
	"refuse": [
		"I walked out. Back up the tunnels, back to the light.",
	],
	"spin": {
		"title": "PSYONIC INTEGRATIONS  ·  INCIDENT REPORT",
		"case": "CASE: SILICO  ·  FILED BY C. DRAKE",
		"frames": "FRAMING",
		"bar": "BELIEVABILITY",
		"mark": "TURAN",
		"full": "FULL",
		"empty_ledger": "(the ledger is empty)",
		"ask": "Every card I'd ever logged lay on the desk. It didn't matter which I picked. The bar was already full.",
		"choices": ["Drugs. A bad batch.", "Mental illness. A breakdown.", "Sabotage. A forked build and a masked handler.", "The truth."],
		"keys": ["drugs", "mental", "sabotage", "truth"],
		"filed": "FILED",
		"turan": "It'll hold. It always holds. Go home, Carl.",
		"log": "the last report",
	},
	"home": {
		"enter": "86D. The door sighed. Dinner on the table, steam off the soy-loaf. The kitchen lights steady.",
		"mira": "It didn't hurt at all, Daddy.",
		"monica": "Sit down, honey. Dinner's getting cold.",
		"chair": "Sit down",
		"sat": "I sat. The lights did not flicker.",
		"last": "The city works.",
		"look_mira": "Mira, in the white dress, in her chair. Nothing in her eyes. Smiling at me like it was any Tuesday.",
		"look_monica": "Monica. Her eyes black spheres that drank the kitchen light. She passed me the bread.",
		"fridge": "The fridge. Magnets in a row and nothing under them.",
		"fridge_drawing": "The fridge. Mira's drawing of the Tower, under the green magnet. Five floating figures and a door at the top.",
		"window": "Silico, eighty-six floors down. Every light on. Every one.",
	},
	"pain": [
		"The pain was immeasurable, a pure, white-hot signal that overloaded every circuit in my body.",
		"Every nerve ending blazed in red-hot silence.",
		"And just like that— I was back. The void. The black room. There was no time here. No floor. No ceiling.",
		"I couldn't see. I didn't know what I expected—salvation? Transformation? Closure? But all I felt was ruin.",
	],
	"follow": "Daddy, follow me.",
	"doorway": "There she was. Glowing in the distance. Mira stood framed in a doorway of pure white light, smiling, waving, beckoning me with the same delicate hands I once held through the sterile glass of the NICU.",
	"doorway_prompt": "Walk to her",
	"blink": "I blinked my non-existent eyes— And the room was gone.",
	"chamber": "A vast chamber of massive stone blocks—ancient, damp, and impossibly large. The walls seemed to breathe, slow and rhythmic.",
	"climb": [
		"Come on, Daddy! There's so much to see. We have to climb the Tower!",
		"Wait for me, baby! Let me hug you! You were right—I can't believe you were right about this! Is Mom coming too?",
		"The roof, Daddy! Meet me on the roof, slowpoke!",
	],
	"climb_think": "I could see again—though not with eyes. Like static in reverse, like reality filtered through broken glass. And I felt fantastic.",
	"chant": "CARL.  CARL.  CARL.",
	"rooms": {
		"focus": ["FOCUS", "A desk, a lamp, every paper squared to the edge. The council floated over it, waiting for a question."],
		"calm": ["CALM", "Still water in a stone ring. Nothing moved on it. The council floated over it like breath held."],
		"memory": ["MEMORY", "Frames on every wall. Some of them empty, the hooks still there."],
		"courage": ["COURAGE", "A plinth with a knife on it, and a fire that gave no heat. The council stood back from it."],
		"bare": ["", "A bare landing. Stone and dust. A room I never built."],
	},
	"children": "Children holding candles, their faces upturned in awe.",
	"strangers": "Strangers from my past, all clapping, all smiling, all chanting my name.",
	"roof": "Mira stood at the edge, her white dress fluttering in a wind that didn't exist. She stared out at a jagged range of painted mountains under a sky of surreal pastels.",
	"glitch": [
		"And my vision glitched. The beautiful lie cracked. I was on top of Psyonic Tower.",
		"A crowd—no, a sea of people—stood in the plaza below the tower. Tens of thousands. All of them chanting my name. It was… beautiful.",
	],
	"throne": "Dad, I made this throne for you. Do you like it?",
	"throne_2": "You have to try it. Please, Daddy—have a seat.",
	"honored": "I'm so honored, baby. It's beautiful.",
	"throne_prompt": "Sit",
	"woods": [
		"The crunch of leaves underfoot woke me. I was in a familiar wood. Autumn.",
		"Laughter. Far away, but getting closer. Monica and Mira. Holding hands, spinning in a joyous circle before tumbling into a massive pile of leaves.",
		"But something was wrong. I was already with them. Another me.",
	],
	"copy_line": "Don't mind me, Carl. I was just keeping them company while they waited for you.",
	"believed": "And I believed him. Of course I did. He shook my hand, smiled again, and strolled peacefully down the path behind me.",
	"collapse": "I turned to run to my girls, to finally hold them— And the world collapsed.",
	"grid": {
		"title": "SILICO  ·  GRID",
		"sub": "I was the static between transmissions. I was the hum in the power lines. I was the city.",
		"move": "W / S or the mouse",
		"memory": "My girls. Their laughter in the leaves.",
		"hold": "Hold to keep the lights on.",
		"hold_keys": "SPACE or the left mouse button",
		"dark": "A scream that made no sound, a silent, psychic roar of pure grief and defiance— And with it, the lights in Red Rock Plaza went out.",
		"kept": "My hand on the switch. The only thing keeping it.",
	},
	"districts": [
		["Red Rock Plaza", "The monolith screen. Lushon's door. The casino lit for nobody."],
		["SalTech · life support", "2,300 patients. Every pump on my breath."],
		["The Spine", "The plaza at the tower's foot. They are still chanting."],
		["Lamplight", "Dufredy's building. A light on in his window and no one home."],
		["Canal Walk", "The sand unit, humming my name to the water."],
		["The Heights", "Children's tablets, all showing the Tower."],
		["Hill Road", "The FreudBot booth reciting to an empty street."],
		["Zeta & Park", "Fourteen cameras. All of them mine."],
		["Harmony Green", "The jingle playing scripture to the benches."],
		["Southtown", "The plant. The overpass eye, lit from inside."],
		["Fargona Avenue", "The procession, standing still, waiting for a word."],
		["Rail Cut", "The substation. Nathan's log, still open."],
		["Cognizo", "A sealed train with its doors open."],
	],
	"credits": "[center][b]THE HUNGER BENEATH US[/b]\n\nfrom the novel by Ian Rowe\n\n\n[color=#888888]Carl Drake[/color]\nthe city\n\n[color=#888888]Mira Drake[/color]\nthe Tower\n\n[color=#888888]Monica Drake[/color]\nthe belief layer\n\n\n[color=#888888]Red Rock Plaza is lit\nfor as long as you hold it.[/color][/center]",
	"copy": {
		"hud": "WE ARE HERE  ·  CONNECTION 100",
		"walk": "We walk to the altar.",
		"bow": "We bow.",
		"climb": "We climb. She is waiting.",
		"sit": "We sit. We were always going to sit.",
		"woods": "We walk down the path.",
		"city": "We keep the lights on.",
		"cut": "The camera stepped out of me. I watched the back of my own head walk up the aisle, half a second behind my wanting it to.",
		"bowed": "We knelt. We did not need to be asked twice.",
		"auto_sit": "We sat. The chair was not offered. It did not need to be.",
		"keeping": "I was just keeping them company while they waited for you.",
		"real_carl": "He came up the path the way I used to walk: shoulders first, tired, sure he was late.",
		"walk_away": "We shook his hand. We walked down the path, and the woods let us go. Behind us they were laughing. The camera stayed with them.",
		"name": "Carl",
	},
	"objective": {
		"grief": "",
		"charge": "Hold SPACE or the left mouse button: run at the Prophet",
		"bow": "Bow",
		"void": "Walk to her",
		"climb": "Climb the Tower. The roof.",
		"roof": "Mira",
		"woods": "",
		"walk": "",
		"walk_refuse": "Out. Up the tunnels.",
		"home": "Sit down",
	},
	"prompts": {
		"prophet": "The Prophet",
		"eren": "Eren Elontiel",
		"monica": "Monica",
		"mira": "Mira",
		"congregation": "The congregation",
		"desk": "The altar-desk",
		"screen": "The screen",
		"tyson": "Tyson",
		"ezra": "Ezra",
		"mira_home": "Mira",
		"monica_home": "Monica",
		"fridge": "The fridge",
		"window": "The window",
	},
	"look": {
		"prophet": "The Prophet. The scars across his face crossed and recrossed, faded and fresh. He smiled at me the way you smile at a dog that has finally come when called.",
		"eren": "Eren Elontiel, CEO, in the white of his broadcasts. Serene. Watching me like a quarterly figure he'd already priced in.",
		"monica": "Monica. My wife. Her eyes were perfect, glistening black spheres that seemed to drink the light from the room.",
		"mira": "Mira, face down on the obsidian, her small body still in the white gown. Lifeless as a doll. I couldn't look at her. I couldn't look away.",
		"congregation": "The eyeless, in their rows. Their cavernous sockets fixed on me, not with malice, but with a profound, hungry longing. They were waiting.",
		"screen": "The screen above the altar. A digital mockery of stained glass, churning in morphing, psychedelic green patterns.",
		"screen_dark": "The screen. Dark now. My reflection in it, small, at the end of the aisle.",
		"done": "It was over. Whatever it was.",
		"tyson": "Tyson Clerif. Red-cracked eyes, dust-dried skin, a gaze like a scalpel. Still here.",
		"ezra": "Ezra. Eight years old and older than me.",
	},
	"scan": {
		"prophet": "SUBJECT 41  //  THE PROPHET\nsignal: PROJECTED\nlocation: UNRESOLVED",
		"prophet_gone": "NO SUBJECT",
		"eren": "EREN ELONTIEL  //  CEO, PSYONIC\nstatus: CLERGY",
		"monica": "MONICA DRAKE  //  BELIEF LAYER\nsight: NONE\nstatus: CONVERTED",
		"mira": "MIRA DRAKE  //  10\nvitals: NONE\nsync: 100%",
		"congregation": "CONGREGATION  //  %d\nsight: NONE\nsync: 100%%",
		"desk": "CORE TERMINAL  //  SIM: EVENT HORIZON\nupload: COMPLETE",
		"valve": "COOLANT MANIFOLD  //  RIVER FEED\nflow: 100%\ndownstream: SALTECH LIFE SUPPORT",
		"doors": "CORE DOORS  //  4.6 M\nstatus: UNLOCKED",
		"screen": "ALTARPIECE  //  FEED: TOWER",
		"tyson": "TYSON CLERIF  //  45\nUNREGISTERED",
		"ezra": "EZRA DRAKE  //  8",
	},
	"ledger": {
		"grief": "Mira Drake, 10, the chapel. I watched.",
		"mira": "The screen: Mira. Or the copy of her.",
		"attack": "The knife went through the Prophet. He was never there.",
		"drop": "I dropped the knife.",
		"bow": "I bowed.",
		"valve": "Opened the coolant valve. SalTech life support: 2,300 patients.",
		"sheathe": "Sheathed the knife and walked out.",
		"copy": "We walked to the altar.",
		"sit": "I sat.",
		"redrock_dark": "Red Rock Plaza went dark.",
		"redrock_kept": "I kept Red Rock lit.",
	},
	"phone": "[color=#7fe6b0]Psyon:[/color] We are here, Carl. We were always here.\n\n",
}

# ------------------------------------------------------------------ layout

const ALTAR := Vector3(0, 0, -22.0)
const PROPHET_AT := Vector3(1.85, 0, -20.7)    # Mira's left
const EREN_AT := Vector3(-1.85, 0, -20.7)      # her right
const MONICA_AT := Vector3(-0.5, 0, -23.4)
const KNEEL_AT := Vector3(0, 0.1, -7.5)
const TEN_FEET_Z := -17.6                      # ten feet short of the Prophet
const ALTAR_Z := -19.4                         # the altar's step
const DOOR_Z := 0.0                            # the chapel doors
const DESK := Vector3(0, 0, 17.0)
const VALVE := Vector3(13.7, 0, 12.0)
const GREAT := Vector3(0, 0, 33.7)
const TOWER := Vector3(600, 0, 0)
const R_IN := 9.5
const R_OUT := 12.5
const R_MID := 11.0
const FH := 7.0
const FLOORS := 4                              # one per possible room: focus, calm, memory, courage
const ROOF_Y := 35.0                           # FH * (FLOORS + 1)
const STEPS := 20                              # treads per half turn
const VOID := Vector3(-600, 0, 600)
const WOODS := Vector3(-600, 0, 0)
const WALK := Vector3(0, 0, 600)
const DEPOT_Y := 6.0
const HOME := Vector3(0, 0, -600)
const ROAD := Vector3(600, 0, 600)
const GREEN := Color(0.25, 1.0, 0.45)
const AMBER := Color(1.0, 0.62, 0.25)

const SCREEN_SHADER := """
shader_type spatial;
render_mode unshaded, cull_disabled;
uniform sampler2D feed : source_color, filter_linear;
uniform float mira = 0.0;
uniform float copy = 0.0;
uniform float glitch = 0.0;
uniform float dark = 0.0;
uniform float t = 0.0;
vec2 h2(vec2 p) { p = vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3))); return fract(sin(p) * 43758.5453); }
void fragment() {
	vec2 uv = UV;
	vec2 g = uv * vec2(10.0, 5.0);
	vec2 ip = floor(g);
	vec2 fp = fract(g);
	float d1 = 8.0; float d2 = 8.0; vec2 cell = vec2(0.0);
	for (int y = -1; y <= 1; y++) { for (int x = -1; x <= 1; x++) {
		vec2 o = vec2(float(x), float(y));
		vec2 h = h2(ip + o);
		h = 0.5 + 0.45 * sin(t * 0.7 + 6.2831 * h);
		vec2 r = o + h - fp;
		float d = dot(r, r);
		if (d < d1) { d2 = d1; d1 = d; cell = ip + o; } else if (d < d2) { d2 = d; }
	} }
	float lead = smoothstep(0.02, 0.09, sqrt(d2) - sqrt(d1));
	float hue = fract(h2(cell).x + t * 0.04);
	vec3 glass = mix(vec3(0.01, 0.18, 0.06), vec3(0.35, 1.0, 0.5), hue);
	glass *= 0.55 + 0.45 * sin(t * 1.4 + hue * 24.0);
	vec2 c = (uv - 0.5) * vec2(2.0, 1.0);
	float eye = smoothstep(0.32, 0.3, length(c * vec2(1.0, 1.9))) * (1.0 - smoothstep(0.08, 0.1, length(c)));
	glass = glass * lead + vec3(0.1, 0.5, 0.2) * eye * lead;
	float row = floor(uv.y * 54.0);
	vec2 fuv = uv;
	float jump = step(0.72, h2(vec2(row * 3.1, floor(t * 9.0))).y);
	fuv.x += (h2(vec2(row, floor(t * 13.0))).x - 0.5) * 0.12 * (glitch + copy * 0.35) * jump;
	vec3 f = texture(feed, fuv).rgb;
	float lum = dot(f, vec3(0.3, 0.59, 0.11));
	f = mix(f, vec3(lum) * vec3(0.55, 1.15, 0.7), copy * 0.65);
	f *= 0.86 + 0.14 * sin(uv.y * 420.0);
	vec3 col = mix(glass, f * 0.82, mira);
	ALBEDO = col * (1.0 - dark);
}
"""

const HOLE_SHADER := """
shader_type spatial;
render_mode unshaded;
uniform float collapse = 0.0;
uniform float t = 0.0;
void fragment() {
	vec2 p = (UV - 0.5) * vec2(1.9, 1.0);
	float r = length(p);
	float a = atan(p.y, p.x);
	float k = 1.0 - collapse;
	float rs = 0.11 * k + 0.004;
	float disk = (1.0 - smoothstep(0.08, 0.48 * k + 0.01, r)) * (0.55 + 0.45 * sin(a * 3.0 - t * 2.2 + 9.0 / (r + 0.06)));
	float ring = exp(-pow((r - rs * 1.4) / (0.012 + 0.02 * k), 2.0));
	vec3 col = vec3(1.0, 0.5, 0.18) * disk * 1.6 * k + vec3(1.0, 0.86, 0.62) * ring * 2.2;
	col *= step(rs, r);
	col += vec3(0.02, 0.04, 0.06) * (1.0 - collapse);
	ALBEDO = col;
}
"""

# ------------------------------------------------------------------ state

var ui: CanvasLayer
var stages := {}                 # name -> Node3D
var stage := ""
var dyn: Node3D                  # people and moving things in the core
var _phase := ""                 # grief, charge, mira, choice, ending, copy_walk, void, climb, roof, woods, grid, walk, home, done
var _clock := 0.0                # the animation clock (stopped for the frozen frame)
var _frozen := true
var _hold := 0.0
var _test_hold := false
var _test_bow := false
var _attack_spent := false
var _turned_away := false
var _ending := ""
var _busy := false               # a sequence is running; tick stays out of the way
var _variant := ""               # walk: "burn" | "refuse"
var _lights: Array = []          # [OmniLight3D, stage, cull distance]

# the core
var prophet: Node3D
var eren: Node3D
var monica: Node3D
var mira_body: Node3D
var congregation: Array = []     # {fig, sat, phase}
var people_its: Array = []       # the chapel's examine points
var screen_mat: ShaderMaterial
var hole_mat: ShaderMaterial
var mira_vp: SubViewport
var mira_feed: Node3D
var _knife: Node3D
var _floor_knife: Node3D
var vein_mat: StandardMaterial3D
var cable_mats: Array = []
var valve_wheel: Node3D
var great_l: Node3D
var great_r: Node3D
var valve_it: CollisionObject3D
var doors_it: CollisionObject3D
var screen_light: OmniLight3D
var drips: CPUParticles3D

# the tower, the roof, the void
var guide: Node3D                # Mira in white, who runs ahead
var route: Array = []            # [Vector3] Mira's way up
var route_d: Array = []          # cumulative distance
var _prog := 0.0
var _said := {}
var fairy: Node3D
var real: Node3D
var throne_it: CollisionObject3D
var door_glow: Node3D
var crowds: Array = []           # [fig, kind, phase]
var councils: Array = []         # [fig, base y, phase]

# the woods, the walk, home
var w_monica: Node3D
var w_mira: Node3D
var w_other: Node3D
var shore: Array = []            # {fig, done}
var tyson: Node3D
var ezra: Node3D
var h_mira: Node3D
var h_monica: Node3D
var h_chair_it: CollisionObject3D
var road_car: Node3D
var road_cam: Camera3D

# the copy (third person, half a second behind)
var _copy := false
var _cbody: CharacterBody3D
var _cfig: Node3D
var _ccam: Camera3D
var _cyaw := 0.0
var _cbuf: Array = []            # [time, move Vector2, turn]
var _cmouse := 0.0
var _cfixed := false             # the camera stays where it is (the woods)
var _cauto := Vector3.INF        # selftest: walk the copy here

# the screen
var _black: ColorRect
var _card_l: RichTextLabel
var _hint: Label
var _bar_bg: ColorRect
var _bar: ColorRect
var _grid: Control
var _grid_rows: Array = []       # [name label, fill ColorRect, row ColorRect]
var _grid_line: Label
var _grid_sel := 0
var _credits: RichTextLabel
var _spin: Control
var _ledger_panel: PanelContainer
var _ledger_text: RichTextLabel

# sound
var _hum: AudioStreamPlayer
var _lull: AudioStreamPlayer
var _choir: AudioStreamPlayer


# ------------------------------------------------------------------ build

func build(m: Node) -> void:
	main = m
	ui = m.ui
	kit_day = false
	spawn = KNEEL_AT
	spawn_yaw = 0.0
	step_db = -13.0
	card = LINES["cards"]["chapter"]
	rng.seed = 3031
	_overlay()
	for s in ["core", "void", "tower", "woods", "walk", "home", "road"]:
		var n := Node3D.new()
		n.name = s
		add_child(n)
		stages[s] = n
	dyn = Node3D.new()
	dyn.name = "dyn"
	stages["core"].add_child(dyn)
	_chapel()
	_cathedral()
	_people()
	_mira_feed()
	_void_room()
	_tower()
	_roof()
	_woods()
	_walk()
	_home()
	_road()
	_guide()
	_sounds()
	_show("core")


func _sub(parent: Node, nm: String) -> Node3D:
	var n := Node3D.new()
	n.name = nm
	parent.add_child(n)
	return n


## An omni light that belongs to a stage; tick hides it when its stage is
## hidden or it is far from Carl (the browser shades 32 lights at most).
func _lamp(parent: Node, pos: Vector3, c: Color, energy: float, rng_m: float, cull := 60.0) -> OmniLight3D:
	var o := OmniLight3D.new()
	o.position = pos
	o.light_color = c
	o.light_energy = energy
	o.omni_range = rng_m
	o.omni_attenuation = 1.3
	o.shadow_enabled = false
	parent.add_child(o)
	_lights.append([o, cull])
	return o


func _solid_cyl(r: float, h: float, pos: Vector3, parent: Node) -> void:
	var sb := StaticBody3D.new()
	sb.position = pos
	var cs := CollisionShape3D.new()
	var sh := CylinderShape3D.new()
	sh.radius = r
	sh.height = h
	cs.shape = sh
	sb.add_child(cs)
	parent.add_child(sb)


## A box with a full basis (ramps, stair treads), with or without collision.
func _obox(size: Vector3, xf: Transform3D, m: Material, parent: Node, solid: bool) -> MeshInstance3D:
	var mi: MeshInstance3D = null
	if m != null:
		var bm := BoxMesh.new()
		bm.size = size
		mi = MeshInstance3D.new()
		mi.mesh = bm
		mi.material_override = m
		mi.transform = xf
		parent.add_child(mi)
	if solid:
		var sb := StaticBody3D.new()
		sb.transform = xf
		var cs := CollisionShape3D.new()
		var sh := BoxShape3D.new()
		sh.size = size
		cs.shape = sh
		sb.add_child(cs)
		parent.add_child(sb)
	return mi


func _head_mi(fig: Node3D) -> MeshInstance3D:
	for c in (fig.get_meta("head") as Node3D).get_children():
		if c is MeshInstance3D:
			return c
	return null


func _set_layer(n: Node, layer: int) -> void:
	if n is VisualInstance3D:
		(n as VisualInstance3D).layers = layer
	for c in n.get_children():
		_set_layer(c, layer)


## A long white gown over a figure (Mira's, the Prophet's robe).
func _skirt(fig: Node3D, m: Material, wide := 1.0) -> MeshInstance3D:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	Body.loft(st, [[0.02, 0.34 * wide, 0.34 * wide, 0.0], [0.45, 0.28 * wide, 0.25 * wide, 0.0], [0.95, 0.2, 0.15, 0.0]], Rect2(0, 0, 1, 1), Transform3D(), false, true, 12)
	st.generate_normals()
	return mesh(st.commit(), Vector3.ZERO, m, fig)


## A face with the eyes gone: puckered craters (the eyeless), scars crossed
## and recrossed (the Prophet), or black glossy spheres (Monica, ch.29).
func _eyeless_face(skin: Color, hair: Color, seed: int, scars: bool, fem := false) -> StandardMaterial3D:
	var base: StandardMaterial3D = Body.face_mat(skin, hair, fem, seed)
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
		# what ran out of them, dried down the cheek
		Body._rect(img, ex - 1.0, ey + 4.0, 2, 16, Color(0.32, 0.06, 0.05, 0.85))
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


## "Her eyes were perfect, glistening black spheres that seemed to drink the
## light from the room" (ch.29).
func _black_eyes(fig: Node3D) -> void:
	var hd: Node3D = fig.get_meta("head")
	var m := mat(Color(0.0, 0.0, 0.0), 0.02, 0.6)
	for x: float in [-0.034, 0.034]:
		sphere(0.017, Vector3(x, 0.022, -0.095), m, 8, hd)


## Massive stone blocks, damp, mortar dark (ch.31's chamber).
func _stone_tex() -> ImageTexture:
	var img := Image.create(256, 256, false, Image.FORMAT_RGBA8)
	var r := RandomNumberGenerator.new()
	r.seed = 31
	img.fill(Color(0.1, 0.1, 0.09))
	for row in 4:
		var off := (row % 2) * 64
		for col in 3:
			var x0 := col * 128 - off
			var base := Color(0.42, 0.41, 0.37).darkened(r.randf_range(0.0, 0.3))
			for y in range(row * 64 + 3, row * 64 + 61):
				for x in range(x0 + 3, x0 + 125):
					var xx := posmod(x, 256)
					var n := r.randf_range(-0.04, 0.04)
					var moss := 0.0
					if y > row * 64 + 44:
						moss = r.randf_range(0.0, 0.25)
					img.set_pixel(xx, y, Color(base.r + n - moss * 0.15, base.g + n + moss * 0.05, base.b + n - moss * 0.2))
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


## The painted mountains: "an oil painting melting under a heat lamp".
func _mountain_tex() -> ImageTexture:
	var w := 512
	var h := 256
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	var bands := [[0.35, Color(0.62, 0.5, 0.8)], [0.5, Color(0.9, 0.5, 0.55)], [0.65, Color(0.45, 0.3, 0.62)], [0.8, Color(0.26, 0.2, 0.45)]]
	for bi in bands.size():
		var top: float = bands[bi][0]
		var c: Color = bands[bi][1]
		for x in w:
			var u := float(x) / w * TAU
			var ridge: float = top + 0.12 * sin(u * (2.0 + bi)) + 0.06 * sin(u * (7.0 + bi * 2.0) + bi) + 0.03 * abs(sin(u * 23.0 + bi * 4.0))
			var y0 := int(clampf(ridge, 0.05, 0.98) * h)
			for y in range(y0, h):
				var brush := 0.06 * sin(float(y) * 0.35 + float(x) * 0.05 + bi * 3.0)
				var melt := 1.0 if (x * 7 + bi * 13) % 37 > 2 else 0.0
				var cc := c.lightened(brush + 0.08 * (1.0 - float(y - y0) / maxf(1.0, h - y0)))
				if melt > 0.0 or y > y0 + 6:
					img.set_pixel(x, y, Color(cc.r, cc.g, cc.b, 1.0))
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


func _unshaded(c: Color, alpha := false) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.albedo_color = c
	if alpha or c.a < 1.0:
		m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	m.cull_mode = BaseMaterial3D.CULL_DISABLED
	return m


# ------------------------------------------------------------------ the screen overlays

func _overlay() -> void:
	var cl := CanvasLayer.new()
	cl.layer = 9
	add_child(cl)
	_black = ColorRect.new()
	_black.color = Color(0, 0, 0, 0)
	_black.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_black.set_anchors_preset(Control.PRESET_FULL_RECT)
	cl.add_child(_black)
	_card_l = RichTextLabel.new()
	_card_l.bbcode_enabled = true
	_card_l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_card_l.anchor_left = 0.16
	_card_l.anchor_right = 0.84
	_card_l.anchor_top = 0.22
	_card_l.anchor_bottom = 0.7
	_card_l.add_theme_font_size_override("normal_font_size", 22)
	_card_l.add_theme_font_size_override("bold_font_size", 32)
	_black.add_child(_card_l)
	_hint = Label.new()
	_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_hint.anchor_left = 0.1
	_hint.anchor_right = 0.9
	_hint.anchor_top = 0.74
	_hint.anchor_bottom = 0.8
	_hint.add_theme_font_size_override("font_size", 20)
	_hint.add_theme_color_override("font_color", Color(0.85, 1.0, 0.9))
	_hint.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	_hint.add_theme_constant_override("outline_size", 6)
	_hint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cl.add_child(_hint)
	_bar_bg = ColorRect.new()
	_bar_bg.color = Color(0.05, 0.08, 0.06, 0.8)
	_bar_bg.anchor_left = 0.35
	_bar_bg.anchor_right = 0.65
	_bar_bg.anchor_top = 0.805
	_bar_bg.anchor_bottom = 0.82
	_bar_bg.visible = false
	_bar_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cl.add_child(_bar_bg)
	_bar = ColorRect.new()
	_bar.color = Color(0.85, 0.2, 0.15)
	_bar.anchor_bottom = 1.0
	_bar.anchor_right = 0.0
	_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_bar_bg.add_child(_bar)
	_ledger_panel = PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.02, 0.04, 0.03, 0.9)
	sb.border_color = Color(0.3, 0.9, 0.5, 0.7)
	sb.set_border_width_all(2)
	sb.set_content_margin_all(18)
	_ledger_panel.add_theme_stylebox_override("panel", sb)
	_ledger_panel.anchor_left = 0.28
	_ledger_panel.anchor_right = 0.72
	_ledger_panel.anchor_top = 0.14
	_ledger_panel.anchor_bottom = 0.62
	_ledger_panel.visible = false
	cl.add_child(_ledger_panel)
	_ledger_text = RichTextLabel.new()
	_ledger_text.bbcode_enabled = true
	_ledger_text.add_theme_font_size_override("normal_font_size", 17)
	_ledger_text.add_theme_font_size_override("bold_font_size", 22)
	_ledger_text.scroll_following = true
	_ledger_panel.add_child(_ledger_text)
	_grid_build(cl)
	_spin_build(cl)


func _card(text: String) -> void:
	_card_l.text = "[center]" + text + "[/center]"
	_black.color.a = 1.0


func _card_off() -> void:
	_card_l.text = ""


func _to_black(a: float, t: float) -> void:
	var tw := create_tween()
	tw.tween_property(_black, "color:a", a, t)
	await tw.finished


func _hint_on(text: String) -> void:
	_hint.text = text


# ------------------------------------------------------------------ light and air per stage

func _sky(top: Color, hor: Color, ground: Color) -> Sky:
	var sky := Sky.new()
	var psm := ProceduralSkyMaterial.new()
	psm.sky_top_color = top
	psm.sky_horizon_color = hor
	psm.ground_horizon_color = hor
	psm.ground_bottom_color = ground
	psm.sky_curve = 0.12
	psm.sun_angle_max = 8.0
	sky.sky_material = psm
	return sky


func _env(kind: String) -> void:
	var env: Environment = main.env
	var sun: DirectionalLight3D = main.sun
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0, 0, 0)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.fog_enabled = true
	env.fog_sky_affect = 1.0
	env.glow_enabled = true
	env.glow_bloom = 0.04
	env.tonemap_exposure = 1.0
	sun.visible = false
	sun.shadow_enabled = false
	match kind:
		"core":
			env.ambient_light_color = Color(0.12, 0.26, 0.17)
			env.ambient_light_energy = 0.4
			env.fog_light_color = Color(0.02, 0.06, 0.035)
			env.fog_density = 0.018
			env.tonemap_exposure = 1.15
		"void":
			env.ambient_light_color = Color(0.05, 0.05, 0.05)
			env.ambient_light_energy = 0.1
			env.fog_light_color = Color(0, 0, 0)
			env.fog_density = 0.03
		"tower":
			env.ambient_light_color = Color(0.4, 0.33, 0.24)
			env.ambient_light_energy = 0.55
			env.fog_light_color = Color(0.2, 0.15, 0.1)
			env.fog_density = 0.012
			env.tonemap_exposure = 1.2
		"roof":
			env.glow_enabled = false
			env.background_mode = Environment.BG_SKY
			env.sky = _sky(Color(0.38, 0.42, 0.8), Color(0.96, 0.66, 0.62), Color(0.62, 0.48, 0.66))
			env.ambient_light_color = Color(0.9, 0.78, 0.84)
			env.ambient_light_energy = 0.55
			env.fog_light_color = Color(0.9, 0.68, 0.74)
			env.fog_density = 0.0007
			env.fog_sky_affect = 0.0
			env.glow_bloom = 0.0
			env.tonemap_exposure = 0.9
			sun.visible = true
			sun.light_color = Color(1.0, 0.84, 0.72)
			sun.light_energy = 0.85
			sun.rotation = Vector3(deg_to_rad(-24), deg_to_rad(105), 0)
		"real":
			env.background_mode = Environment.BG_SKY
			env.sky = _sky(Color(0.01, 0.012, 0.03), Color(0.2, 0.06, 0.08), Color(0.02, 0.01, 0.02))
			env.ambient_light_color = Color(0.2, 0.22, 0.3)
			env.ambient_light_energy = 0.4
			env.fog_light_color = Color(0.12, 0.06, 0.08)
			env.fog_density = 0.0012
			env.fog_sky_affect = 0.3
		"woods":
			env.glow_enabled = false
			env.background_mode = Environment.BG_SKY
			env.sky = _sky(Color(0.35, 0.5, 0.78), Color(0.88, 0.62, 0.36), Color(0.35, 0.24, 0.12))
			env.ambient_light_color = Color(0.9, 0.75, 0.55)
			env.ambient_light_energy = 0.5
			env.fog_light_color = Color(0.6, 0.42, 0.26)
			env.fog_density = 0.003
			env.fog_sky_affect = 0.25
			env.glow_bloom = 0.0
			env.tonemap_exposure = 0.85
			sun.visible = true
			sun.light_color = Color(1.0, 0.82, 0.55)
			sun.light_energy = 0.8
			sun.rotation = Vector3(deg_to_rad(-30), deg_to_rad(40), 0)
		"walk":
			env.background_mode = Environment.BG_SKY
			env.sky = _sky(Color(0.16, 0.2, 0.36), Color(0.95, 0.52, 0.3), Color(0.15, 0.1, 0.08))
			env.ambient_light_color = Color(0.16, 0.2, 0.22)
			env.ambient_light_energy = 0.3
			env.fog_light_color = Color(0.05, 0.06, 0.06)
			env.fog_density = 0.02
			env.fog_sky_affect = 0.1
		"dawn":
			env.background_mode = Environment.BG_SKY
			env.sky = _sky(Color(0.2, 0.26, 0.45), Color(1.0, 0.58, 0.32), Color(0.2, 0.14, 0.1))
			env.ambient_light_color = Color(0.7, 0.55, 0.45)
			env.ambient_light_energy = 0.6
			env.fog_light_color = Color(0.85, 0.55, 0.4)
			env.fog_density = 0.006
			env.fog_sky_affect = 0.25
			env.glow_bloom = 0.0
			sun.visible = true
			sun.light_color = Color(1.0, 0.7, 0.45)
			sun.light_energy = 0.9
			sun.rotation = Vector3(deg_to_rad(-10), deg_to_rad(-60), 0)
		"home":
			env.ambient_light_color = Color(0.3, 0.3, 0.34)
			env.ambient_light_energy = 0.4
			env.fog_light_color = Color(0.04, 0.04, 0.06)
			env.fog_density = 0.004
			env.tonemap_exposure = 0.85
		"grid":
			env.ambient_light_energy = 0.0
			env.fog_density = 0.0
	if main._selftest and not visible:
		# headless llvmpipe is fill-bound: the glow passes cost a second a frame
		env.glow_enabled = false


## Show one stage (and the core's neighbours), hide the rest.
func _show(s: String) -> void:
	stage = s
	for k in stages:
		(stages[k] as Node3D).visible = k == s
	if guide:
		guide.visible = false
	if mira_vp:
		mira_vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS if s == "core" and visible else SubViewport.UPDATE_DISABLED
	_env({"core": "core", "void": "void", "tower": "tower", "woods": "woods", "walk": "walk", "home": "home", "road": "dawn"}.get(s, "core"))
	_cull_lights()


## Fade, move Carl (or the copy) to another stage, fade back.
func _go(s: String, at: Vector3, yaw_deg: float, fade := 0.8) -> void:
	await _to_black(1.0, fade)
	_show(s)
	_place(at, yaw_deg)
	await get_tree().create_timer(0.25).timeout
	await _to_black(0.0, fade)


func _place(at: Vector3, yaw_deg: float) -> void:
	if _copy and _cbody:
		_cbody.global_position = at
		_cbody.velocity = Vector3.ZERO
		_cyaw = deg_to_rad(yaw_deg)
		_cbuf.clear()
		_ccam_snap()
	else:
		var p = main.player
		p.position = at
		p.velocity = Vector3.ZERO
		p.yaw = deg_to_rad(yaw_deg)
		p.pitch = 0.0
		p.rotation.y = p.yaw


func _walker() -> Node3D:
	if _copy and _cbody:
		return _cbody
	return main.player


func _cull_lights() -> void:
	var at := _walker().global_position
	for l in _lights:
		var o: OmniLight3D = l[0]
		if not is_instance_valid(o):
			continue
		var far := absf(o.global_position.y - at.y) > 11.0 or Vector2(o.global_position.x - at.x, o.global_position.z - at.z).length() > float(l[1])
		o.visible = not far


# ------------------------------------------------------------------ the chapel (ch.29-30)

## A sagging cable from a to b.
func _sag(a: Vector3, b: Vector3, sag: float, r: float, m: Material, parent: Node, n := 6) -> void:
	var prev := a
	for i in range(1, n + 1):
		var t := float(i) / n
		var p := a.lerp(b, t) - Vector3(0, sag * 4.0 * t * (1.0 - t), 0)
		stick(prev, p, r, m, parent)
		prev = p


func _glyph_mat(c: Color) -> StandardMaterial3D:
	var key := "glyphm%s" % c
	if _mat_cache.has(key):
		return _mat_cache[key]
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.albedo_texture = _glyph_tex
	m.albedo_color = c
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	m.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	m.cull_mode = BaseMaterial3D.CULL_DISABLED
	_mat_cache[key] = m
	return m


## "An unholy synthesis of circuit and stone. Rows of cold, metal pews lined
## a central aisle, all facing a massive screen that served as an altarpiece.
## On it, a digital mockery of stained glass churned in morphing, psychedelic
## green patterns." The obsidian slab; plugs from the ceiling "like
## industrial nooses". The masks with cable tendrils of the concept art.
func _chapel() -> void:
	var ch := _sub(stages["core"], "chapel")
	var stone := pbr("concrete", Vector3.ONE / 3.0, true, Color(0.3, 0.33, 0.31), 1.0)
	var floor_m := pbr("concrete", Vector3.ONE / 2.0, true, Color(0.2, 0.22, 0.21), 0.55)
	var metal := mat(Color(0.2, 0.21, 0.22), 0.38, 0.8)
	var dark := mat(Color(0.03, 0.035, 0.04), 0.5, 0.4)
	var obsid := mat(Color(0.012, 0.012, 0.016), 0.05, 0.5)
	var cab := mat(Color(0.02, 0.02, 0.022), 0.6, 0.2)
	var circuit := glow(GREEN, 1.4)
	box(Vector3(16.6, 0.4, 28.6), Vector3(0, -0.2, -14.3), floor_m, true, ch)
	for s: float in [-1.0, 1.0]:
		box(Vector3(0.6, 12.4, 28.6), Vector3(s * 8.3, 6.2, -14.3), stone, true, ch)
	box(Vector3(17.2, 12.4, 0.6), Vector3(0, 6.2, -28.6), stone, true, ch)
	box(Vector3(16.6, 0.5, 28.6), Vector3(0, 12.4, -14.3), dark, false, ch)
	# circuit in the stone: traces along both walls and up the back
	for s: float in [-1.0, 1.0]:
		for y: float in [1.1, 3.4]:
			box(Vector3(0.03, 0.035, 27.0), Vector3(s * 7.98, y, -14.3), circuit, false, ch)
		for k in 9:
			var z := -2.0 - k * 3.0
			box(Vector3(0.03, 2.3, 0.035), Vector3(s * 7.98, 2.25, z), circuit, false, ch)
			box(Vector3(0.03, 0.035, 0.6), Vector3(s * 7.98, 3.4 + 0.02, z + 0.3), circuit, false, ch)
	# cable bundles slung across the ceiling
	for k in 9:
		var z := -2.0 - k * 3.1
		_sag(Vector3(-8.0, 11.9, z), Vector3(8.0, 11.9, z + 0.4), 0.9, 0.09, cab, ch)
		_sag(Vector3(-8.0, 11.7, z - 0.25), Vector3(8.0, 11.7, z - 0.1), 1.3, 0.06, cab, ch)
	# pillars with the rings lit in green
	var gl := _glyph_mat(GREEN * 1.6)
	for s: float in [-1.0, 1.0]:
		for z: float in [-3.0, -9.0, -15.0, -21.0, -26.2]:
			box(Vector3(0.9, 12.4, 0.9), Vector3(s * 7.55, 6.2, z), stone, true, ch)
			quad(Vector2(0.72, 0.72), Vector3(s * 7.08, 3.0, z), -s * PI / 2.0, gl, ch)
			quad(Vector2(0.45, 0.45), Vector3(s * 7.08, 4.1, z), -s * PI / 2.0, gl, ch)
	# the masks on the walls with their tendrils ("Proceed, vessel")
	var mask_m := mat(Color(0.55, 0.56, 0.58), 0.3, 0.85)
	for s: float in [-1.0, 1.0]:
		for z: float in [-6.0, -12.0, -18.0, -23.6]:
			var c := Vector3(s * 7.85, 7.2, z)
			var mk := sphere(0.5, c, mask_m, 12, ch)
			mk.scale = Vector3(0.45, 1.25, 1.0)
			for e: float in [-0.16, 0.16]:
				sphere(0.07, c + Vector3(-s * 0.2, 0.15, e), mat(Color(0, 0, 0), 0.9), 6, ch)
			for k in 10:
				var a := TAU * k / 10.0 + 0.2
				var d := Vector3(0, sin(a), cos(a))
				var p1 := c + d * 0.7 + Vector3(-s * 0.05, 0, 0)
				var p2 := p1 + d * rng.randf_range(0.6, 1.1) + Vector3(0, -0.35, 0)
				var p3 := p2 + d * 0.5 + Vector3(0, -rng.randf_range(0.4, 1.6), 0)
				stick(c, p1, 0.035, cab, ch)
				stick(p1, p2, 0.03, cab, ch)
				stick(p2, p3, 0.025, cab, ch)
	# the pews: eight rows a side, cold metal
	for i in 8:
		var z := -4.0 - i * 1.65
		for s: float in [-1.0, 1.0]:
			var cx := s * 3.6
			box(Vector3(4.6, 0.07, 0.48), Vector3(cx, 0.46, z), metal, false, ch)
			box(Vector3(4.6, 0.62, 0.05), Vector3(cx, 0.82, z + 0.27), metal, false, ch)
			box(Vector3(4.6, 0.05, 0.1), Vector3(cx, 1.14, z + 0.27), dark, false, ch)
			for lx: float in [-2.15, 0.0, 2.15]:
				box(Vector3(0.06, 0.46, 0.42), Vector3(cx + lx, 0.23, z + 0.03), dark, false, ch)
			solid_box(Vector3(4.6, 1.1, 0.62), Vector3(cx, 0.55, z + 0.06), ch)
	# the dais and the obsidian altar
	box(Vector3(7.0, 0.04, 4.6), Vector3(0, 0.02, ALTAR.z - 0.4), obsid, false, ch)
	box(Vector3(2.0, 0.9, 1.0), ALTAR + Vector3(0, 0.45, 0), obsid, false, ch)
	box(Vector3(2.6, 0.14, 1.3), ALTAR + Vector3(0, 0.97, 0), obsid, false, ch)
	solid_box(Vector3(2.6, 1.05, 1.3), ALTAR + Vector3(0, 0.52, 0), ch)
	# the plugs, hanging like industrial nooses
	for k in 9:
		var x := -2.6 + k * 0.65
		var z := ALTAR.z + rng.randf_range(-1.2, 0.6)
		var y_end := rng.randf_range(2.3, 3.8)
		stick(Vector3(x, 12.2, z), Vector3(x, y_end, z), 0.035, cab, ch)
		cyl(0.075, 0.055, 0.3, Vector3(x, y_end - 0.15, z), metal, 8, ch)
		for p: float in [-0.025, 0.025]:
			box(Vector3(0.012, 0.08, 0.012), Vector3(x + p, y_end - 0.34, z), metal, false, ch)
	# the one that was used, slack to her head
	_sag(Vector3(0.1, 12.2, ALTAR.z + 0.4), ALTAR + Vector3(0.05, 1.4, 0.45), 0.2, 0.04, cab, ch, 4)
	cyl(0.08, 0.06, 0.3, ALTAR + Vector3(0.05, 1.25, 0.45), metal, 8, ch)
	# the altarpiece: the screen in its frame
	box(Vector3(13.4, 7.0, 0.5), Vector3(0, 7.6, -28.1), dark, false, ch)
	box(Vector3(13.6, 0.08, 0.1), Vector3(0, 11.15, -27.83), circuit, false, ch)
	box(Vector3(13.6, 0.08, 0.1), Vector3(0, 4.05, -27.83), circuit, false, ch)
	box(Vector3(13.4, 0.3, 0.9), Vector3(0, 3.9, -27.6), metal, false, ch)
	screen_mat = ShaderMaterial.new()
	var sh := Shader.new()
	sh.code = SCREEN_SHADER
	screen_mat.shader = sh
	var scr := quad(Vector2(12.6, 6.3), Vector3(0, 7.6, -27.82), 0.0, screen_mat, ch)
	scr.name = "screen"
	no_batch.append(scr)
	var mark := Node3D.new()
	mark.position = Vector3(0, 7.6, -27.6)
	mark.set_meta("scan", LINES["scan"]["screen"])
	mark.set_meta("hackable", true)
	ch.add_child(mark)
	# the chapel doors' frame, and the way back
	for s: float in [-1.0, 1.0]:
		box(Vector3(0.12, 6.0, 0.12), Vector3(s * 2.05, 3.0, DOOR_Z - 0.35), circuit, false, ch)
	box(Vector3(4.2, 0.12, 0.12), Vector3(0, 6.05, DOOR_Z - 0.35), circuit, false, ch)
	var rt := Node3D.new()
	rt.position = Vector3(0, 1, DOOR_Z)
	rt.set_meta("route", "chapel_doors")
	ch.add_child(rt)
	# light: the screen's green, the altar from above, the aisles, the doors
	screen_light = _lamp(ch, Vector3(0, 6.2, -24.5), GREEN, 2.6, 27.0, 80.0)
	_lamp(ch, ALTAR + Vector3(0, 5.5, 0.8), Color(0.75, 1.0, 0.82), 1.3, 9.0, 80.0)
	_lamp(ch, Vector3(-6.2, 3.2, -10.0), GREEN * 0.7, 0.5, 10.0, 80.0)
	_lamp(ch, Vector3(6.2, 3.2, -10.0), GREEN * 0.7, 0.5, 10.0, 80.0)
	_lamp(ch, Vector3(0, 4.2, -3.0), Color(0.6, 0.75, 0.9), 0.55, 11.0, 80.0)
	_batch(ch, 12.0)


# ------------------------------------------------------------------ the cathedral (ch.29)

## "As if a computer was thrown up in the Hagia Sophia." Walls lined with
## thick bundles of wire pulsing a sickly green; data shards and terminals
## erupting from the floor like stalagmites; giant throbbing veins carrying
## the black coolant from the river; at the centre the altar, a simple metal
## desk, the black hole on a curved monitor. The valve (the Burn) is on the
## manifold where the veins come in; the great doors (the Refuse) south.
func _cathedral() -> void:
	var ca := _sub(stages["core"], "cathedral")
	var stone := pbr("concrete", Vector3.ONE / 3.0, true, Color(0.27, 0.29, 0.28), 1.0)
	var floor_m := pbr("rust", Vector3.ONE / 2.5, true, Color(0.32, 0.32, 0.3), 0.6)
	var metal := mat(Color(0.22, 0.23, 0.24), 0.4, 0.75)
	var dark := mat(Color(0.03, 0.035, 0.04), 0.5, 0.4)
	var cab := mat(Color(0.02, 0.02, 0.022), 0.6, 0.2)
	box(Vector3(30.6, 0.4, 34.6), Vector3(0, -0.2, 17.0), floor_m, true, ca)
	for s: float in [-1.0, 1.0]:
		box(Vector3(0.6, 16.4, 34.6), Vector3(s * 15.3, 8.2, 17.0), stone, true, ca)
		# north wall (the chapel doors, 4 m) and south wall (the great doors, 5.6 m)
		box(Vector3(13.3, 16.4, 0.6), Vector3(s * 8.65, 8.2, DOOR_Z), stone, true, ca)
		box(Vector3(12.5, 16.4, 0.6), Vector3(s * 9.05, 8.2, 34.3), stone, true, ca)
	box(Vector3(4.0, 10.4, 0.6), Vector3(0, 11.2, DOOR_Z), stone, true, ca)
	box(Vector3(5.6, 9.8, 0.6), Vector3(0, 11.5, 34.3), stone, true, ca)
	# ceiling where the dome does not reach, then the dome of cable
	box(Vector3(30.6, 0.5, 2.6), Vector3(0, 16.4, 1.1), dark, false, ca)
	box(Vector3(30.6, 0.5, 2.6), Vector3(0, 16.4, 32.9), dark, false, ca)
	for sx: float in [-1.0, 1.0]:
		for sz: float in [-1.0, 1.0]:
			box(Vector3(6.4, 0.5, 6.4), Vector3(sx * 12.0, 16.4, 17.0 + sz * 12.0), dark, false, ca)
	var dm := SphereMesh.new()
	dm.radius = 15.0
	dm.height = 15.0
	dm.is_hemisphere = true
	dm.radial_segments = 24
	dm.rings = 8
	var dome_m := newmat(Color(0.04, 0.05, 0.05), 0.7, 0.3)
	dome_m.cull_mode = BaseMaterial3D.CULL_DISABLED
	mesh(dm, Vector3(0, 16.2, 17.0), dome_m, ca)
	var top := Vector3(0, 16.2, 17.0)
	for i in 12:
		var a := TAU * i / 12.0
		var prev := top + Vector3(cos(a) * 14.6, 0, sin(a) * 14.6)
		for j in range(1, 9):
			var ph := PI / 2.0 * j / 8.0
			var p := top + Vector3(cos(a) * 14.6 * cos(ph), 14.6 * sin(ph), sin(a) * 14.6 * cos(ph))
			stick(prev, p, 0.24, cab, ca)
			prev = p
	for ph: float in [0.3, 0.75, 1.1]:
		for i in 24:
			var a0 := TAU * i / 24.0
			var a1 := TAU * (i + 1) / 24.0
			var rr := 14.4 * cos(ph)
			stick(top + Vector3(cos(a0) * rr, 14.4 * sin(ph), sin(a0) * rr), top + Vector3(cos(a1) * rr, 14.4 * sin(ph), sin(a1) * rr), 0.16, cab, ca)
	# the wire on the walls, pulsing a sickly green
	var pulse := newglow(GREEN * 0.8, 1.2)
	cable_mats.append(pulse)
	for s: float in [-1.0, 1.0]:
		for k in 7:
			var z := 3.0 + k * 4.6
			for j in 4:
				var x := s * (14.85 - j * 0.12)
				stick(Vector3(x, 0.0, z + j * 0.18 - 0.27), Vector3(x, 16.0, z + j * 0.1 - 0.15), 0.07, pulse if j % 2 == 0 else cab, ca)
		for y: float in [5.0, 10.5]:
			_sag(Vector3(s * 14.8, y, 1.0), Vector3(s * 14.8, y, 33.0), 0.0, 0.08, pulse, ca, 2)
	for x0: float in [-13.0, -8.0, 8.0, 13.0]:
		stick(Vector3(x0, 0.0, 0.45), Vector3(x0 * 0.9, 16.0, 0.45), 0.08, pulse, ca)
		stick(Vector3(x0, 0.0, 33.85), Vector3(x0 * 0.9, 16.0, 33.85), 0.08, pulse, ca)
	# the data shards and terminals, like crystalline stalagmites
	var shard := newmat(Color(0.25, 0.85, 0.55, 0.42), 0.05, 0.6)
	shard.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	var tip := glow(GREEN, 3.0)
	for k in 22:
		var p := Vector3(rng.randf_range(-13.5, 13.5), 0, rng.randf_range(3.0, 31.0))
		if absf(p.x) < 3.4 or p.distance_to(VALVE) < 3.5 or p.distance_to(DESK) < 3.2:
			continue
		var h := rng.randf_range(1.2, 4.6)
		var sm := cyl(0.02, rng.randf_range(0.18, 0.5), h, p + Vector3(0, h / 2.0, 0), shard, 5, ca)
		sm.rotation = Vector3(rng.randf_range(-0.15, 0.15), rng.randf() * TAU, rng.randf_range(-0.15, 0.15))
		sphere(0.05, p + Vector3(0, h - 0.05, 0), tip, 5, ca)
	for p: Vector3 in [Vector3(-14.2, 0, 6.0), Vector3(-14.2, 0, 9.0), Vector3(-14.2, 0, 25.0), Vector3(14.2, 0, 24.0), Vector3(14.2, 0, 28.0)]:
		prop("server_rack", p, PI / 2.0 if p.x < 0 else -PI / 2.0, 1.0, true, ca)
	prop("fuse_panel", Vector3(14.9, 1.4, 16.5), -PI / 2.0, 1.0, false, ca)
	# the veins: black coolant from the river into the core
	vein_mat = newmat(Color(0.008, 0.008, 0.01), 0.04, 0.35)
	for s: float in [-1.0, 1.0]:
		for zz: float in [7.0, 27.0]:
			var a := Vector3(s * 15.0, 1.3, zz)
			var b := Vector3(s * 8.0, 0.45, lerpf(zz, DESK.z, 0.4))
			var c := DESK + Vector3(s * 1.3, 0.45, (zz - DESK.z) * 0.12)
			_sag(a, b, -0.4, 0.42, vein_mat, ca, 4)
			_sag(b, c, 0.0, 0.34, vein_mat, ca, 3)
		for zz: float in [4.0, 12.0, 20.0, 30.0]:
			stick(Vector3(s * 14.6, 0.0, zz), Vector3(s * 14.6, 15.8, zz + 0.6), 0.3, vein_mat, ca)
	for k in 6:
		var a := TAU * k / 6.0
		_sag(DESK + Vector3(cos(a) * 0.9, 1.0, sin(a) * 0.5), top + Vector3(cos(a) * 6.0, 9.0, sin(a) * 6.0), -1.5, 0.1, cab, ca, 5)
	# the manifold and the valve on the east wall
	var rust := pbr("rust", Vector3.ONE / 1.5, true, Color(0.55, 0.5, 0.45), 1.0)
	box(Vector3(1.3, 3.4, 3.4), VALVE + Vector3(0.75, 1.7, 0), rust, true, ca)
	for dz: float in [-1.1, 0.0, 1.1]:
		stick(VALVE + Vector3(1.2, 2.6, dz), VALVE + Vector3(1.2, 15.0, dz + 0.3), 0.26, vein_mat, ca)
	stick(VALVE + Vector3(0.1, 1.5, 0), VALVE + Vector3(-0.35, 1.5, 0), 0.08, metal, ca)
	valve_wheel = Node3D.new()
	valve_wheel.position = VALVE + Vector3(-0.38, 1.5, 0)
	ca.add_child(valve_wheel)
	var tm := TorusMesh.new()
	tm.inner_radius = 0.52
	tm.outer_radius = 0.6
	tm.rings = 24
	tm.ring_segments = 8
	var red := mat(Color(0.5, 0.06, 0.04), 0.5, 0.5)
	var tor := mesh(tm, Vector3.ZERO, red, valve_wheel)
	tor.rotation.z = PI / 2.0
	for k in 4:
		var a := TAU * k / 4.0
		stick(Vector3.ZERO, Vector3(0, cos(a) * 0.55, sin(a) * 0.55), 0.03, red, valve_wheel)
	cyl(0.09, 0.09, 0.12, Vector3.ZERO, metal, 10, valve_wheel).rotation.z = PI / 2.0
	label("COOLANT  ·  RIVER FEED  ·  DO NOT CLOSE", VALVE + Vector3(0.05, 3.6, 0), -PI / 2.0, 0.0045, Color(0.85, 0.75, 0.3), ca, false)
	valve_it = interactable("valve", LINES["valve"]["prompt"], VALVE + Vector3(-0.4, 1.5, 0), Vector3(0.5, 1.4, 1.4), LINES["scan"]["valve"], false, ca)
	valve_it.set_meta("hackable", true)
	drips = CPUParticles3D.new()
	drips.emitting = false
	drips.amount = 60
	drips.lifetime = 1.2
	drips.emission_shape = CPUParticles3D.EMISSION_SHAPE_BOX
	drips.emission_box_extents = Vector3(13, 0.2, 15)
	drips.position = Vector3(0, 14.5, 17.0)
	drips.gravity = Vector3(0, -12, 0)
	var dq := SphereMesh.new()
	dq.radius = 0.03
	dq.height = 0.08
	dq.material = mat(Color(0.01, 0.01, 0.01), 0.05, 0.3)
	drips.mesh = dq
	ca.add_child(drips)
	# the altar-desk and the black hole
	box(Vector3(2.4, 0.08, 1.1), DESK + Vector3(0, 0.78, 0), metal, false, ca)
	for lx: float in [-1.1, 1.1]:
		for lz: float in [-0.48, 0.48]:
			box(Vector3(0.06, 0.78, 0.06), DESK + Vector3(lx, 0.39, lz), dark, false, ca)
	solid_box(Vector3(2.4, 0.9, 1.1), DESK + Vector3(0, 0.45, 0), ca)
	box(Vector3(2.0, 0.72, 0.06), DESK + Vector3(0, 1.28, -0.3), dark, false, ca)
	stick(DESK + Vector3(0, 0.82, -0.28), DESK + Vector3(0, 1.0, -0.33), 0.04, dark, ca)
	hole_mat = ShaderMaterial.new()
	var hs := Shader.new()
	hs.code = HOLE_SHADER
	hole_mat.shader = hs
	var hq := quad(Vector2(1.9, 0.64), DESK + Vector3(0, 1.28, -0.265), 0.0, hole_mat, ca)
	no_batch.append(hq)
	box(Vector3(0.25, 0.5, 0.5), DESK + Vector3(0.95, 1.07, 0.1), dark, false, ca)
	box(Vector3(0.03, 0.02, 0.08), DESK + Vector3(0.83, 1.0, 0.2), metal, false, ca)
	sphere(0.01, DESK + Vector3(0.83, 1.02, 0.25), glow(GREEN, 4.0), 4, ca)
	var di := interactable("desk", LINES["prompts"]["desk"], DESK + Vector3(0, 1.1, 0.0), Vector3(2.4, 0.8, 1.2), LINES["scan"]["desk"], false, ca)
	di.set_meta("hackable", true)
	# the great doors: fifteen feet of steel
	var door_m := mat(Color(0.16, 0.17, 0.18), 0.35, 0.85)
	great_l = _sub(ca, "great_l")
	great_l.position = Vector3(-2.8, 0, GREAT.z)
	box(Vector3(2.8, 6.3, 0.25), Vector3(1.4, 3.15, 0), door_m, false, great_l)
	great_r = _sub(ca, "great_r")
	great_r.position = Vector3(2.8, 0, GREAT.z)
	box(Vector3(2.8, 6.3, 0.25), Vector3(-1.4, 3.15, 0), door_m, false, great_r)
	for g: Node3D in [great_l, great_r]:
		var sx := 1.0 if g == great_l else -1.0
		for y: float in [1.2, 3.1, 5.0]:
			box(Vector3(2.6, 0.08, 0.05), Vector3(sx * 1.4, y, -0.15), glow(GREEN * 0.6, 1.0), false, g)
	var door_body := solid_box(Vector3(5.6, 6.4, 0.4), GREAT + Vector3(0, 3.2, 0), ca)
	door_body.name = "great_body"
	doors_it = interactable("great_doors", LINES["doors"]["prompt"], GREAT + Vector3(0, 1.6, -0.45), Vector3(5.0, 3.0, 0.3), LINES["scan"]["doors"], false, ca)
	doors_it.set_meta("route", "great_doors")
	# light
	_lamp(ca, Vector3(-11.0, 6.0, 17.0), GREEN * 0.8, 1.1, 20.0, 80.0)
	_lamp(ca, Vector3(11.0, 6.0, 17.0), GREEN * 0.8, 1.1, 20.0, 80.0)
	_lamp(ca, DESK + Vector3(0, 2.6, 0.8), AMBER, 1.3, 8.0, 80.0)
	_lamp(ca, VALVE + Vector3(-1.6, 3.0, 0), AMBER, 1.0, 7.0, 80.0)
	_lamp(ca, GREAT + Vector3(0, 5.0, -2.5), Color(0.6, 0.72, 0.9), 0.7, 11.0, 80.0)
	_batch(ca, 12.0)


# ------------------------------------------------------------------ the people at the altar, and the congregation

func _people() -> void:
	var white := Color(0.9, 0.9, 0.87)
	var robe := mat(Color(0.82, 0.82, 0.8), 0.9)
	var skin_p := Color(0.78, 0.64, 0.55)
	prophet = figure(white, skin_p, {"arms": true, "knees": true, "hair": Color(0.2, 0.18, 0.16), "legs": white, "long_coat": true})
	prophet.position = PROPHET_AT
	dyn.add_child(prophet)
	_skirt(prophet, robe)
	_head_mi(prophet).material_override = _eyeless_face(skin_p, Color(0.2, 0.18, 0.16), 41, true)
	turn_to(prophet, KNEEL_AT)
	var pi := person("prophet", LINES["prompts"]["prophet"], prophet, LINES["scan"]["prophet"])
	pi.set_meta("cultist", true)
	people_its.append(pi)
	eren = figure(Color(0.93, 0.93, 0.9), Color(0.84, 0.7, 0.6), {"arms": true, "knees": true, "hair": Color(0.6, 0.6, 0.6), "legs": Color(0.9, 0.9, 0.88), "long_coat": true})
	eren.position = EREN_AT
	dyn.add_child(eren)
	turn_to(eren, KNEEL_AT)
	for a in eren.get_meta("arms"):
		(a as Node3D).rotation.x = -0.25
	var ei := person("eren", LINES["prompts"]["eren"], eren, LINES["scan"]["eren"])
	ei.set_meta("cultist", true)
	people_its.append(ei)
	# Monica: her Day 6 clothes, the eyes gone, black spheres in their place
	var skin_m := Color(0.86, 0.68, 0.56)
	monica = figure(Color(0.55, 0.18, 0.28), skin_m, {"hair": Color(0.06, 0.05, 0.05), "long_hair": true, "legs": Color(0.12, 0.12, 0.14), "arms": true, "knees": true, "long_coat": false})
	monica.position = MONICA_AT
	dyn.add_child(monica)
	turn_to(monica, KNEEL_AT)
	_head_mi(monica).material_override = _eyeless_face(skin_m, Color(0.06, 0.05, 0.05), 86, false, true)
	_black_eyes(monica)
	for a in monica.get_meta("arms"):
		(a as Node3D).rotation.x = -0.35
	var mi_ := person("monica", LINES["prompts"]["monica"], monica, LINES["scan"]["monica"])
	mi_.set_meta("eyeless", true)
	people_its.append(mi_)
	# Mira, fallen forward onto the table, lifeless as a doll
	mira_body = _mira_fig(true)
	mira_body.position = ALTAR + Vector3(0, 1.1, -0.58)
	mira_body.rotation = Vector3(-PI / 2.0, PI, 0)
	dyn.add_child(mira_body)
	var arms: Array = mira_body.get_meta("arms")
	(arms[0] as Node3D).rotation = Vector3(-0.3, 0, 0.5)
	(arms[1] as Node3D).rotation = Vector3(-0.2, 0, -0.9)
	var bi := interactable("mira", LINES["prompts"]["mira"], ALTAR + Vector3(0, 1.3, 0), Vector3(1.4, 0.5, 1.2), LINES["scan"]["mira"], true, dyn)
	people_its.append(bi)
	# the eyeless congregation, standing in their rows
	var faces := []
	var skins := [Color(0.8, 0.62, 0.5), Color(0.62, 0.46, 0.34), Color(0.9, 0.76, 0.66), Color(0.45, 0.32, 0.24)]
	for k in 4:
		faces.append(_eyeless_face(skins[k], Color(0.2, 0.17, 0.15), 1300 + k * 7, k == 3))
	var n := 0
	for i in 8:
		for s: float in [-1.0, 1.0]:
			for j in 3:
				if rng.randf() < 0.16:
					continue
				var sk: Color = skins[n % 4]
				var gown := Color(0.6, 0.6, 0.56).darkened(rng.randf_range(0.0, 0.45))
				var fg := figure(gown, sk, {"hair": Color(0.22, 0.2, 0.18) if n % 3 else sk.darkened(0.25), "long_coat": true, "knees": true, "long_hair": n % 4 == 1})
				fg.position = Vector3(s * (1.95 + j * 1.3) + rng.randf_range(-0.12, 0.12), 0, -4.62 - i * 1.65)
				dyn.add_child(fg)
				_head_mi(fg).material_override = faces[n % 4]
				fg.set_meta("eyeless", true)
				fg.set_meta("cultist", true)
				congregation.append({"fig": fg, "sat": false, "ph": rng.randf() * TAU, "home": fg.position})
				n += 1
	for k in [0, 5]:
		if k < congregation.size():
			var ci := person("congregation", LINES["prompts"]["congregation"], congregation[k]["fig"], LINES["scan"]["congregation"] % congregation.size())
			ci.set_meta("eyeless", true)
			people_its.append(ci)


## Mira in the white gown: on the altar, on the screen, and running ahead.
func _mira_fig(dead := false) -> Node3D:
	var white := Color(0.94, 0.94, 0.92)
	var skin := Color(0.86, 0.7, 0.6) if not dead else Color(0.78, 0.68, 0.64)
	var f := figure(white, skin, {"hair": Color(0.06, 0.05, 0.05), "long_hair": true, "legs": white, "arms": true, "knees": true, "scale": 0.62, "long_coat": true})
	_skirt(f, mat(Color(0.95, 0.95, 0.93), 0.85), 0.9)
	return f


## The feed on the screen: Mira in white, in a room only a camera on layer
## 20 can see, rendered into the altarpiece when the screen lights.
func _mira_feed() -> void:
	var st := _sub(self, "studio")
	st.position = Vector3(0, -300, 0)
	mira_feed = _mira_fig()
	mira_feed.rotation.y = PI
	st.add_child(mira_feed)
	quad(Vector2(8, 4), Vector3(0, 1.0, -1.6), 0.0, _unshaded(Color(0.02, 0.12, 0.06)), st)
	var halo := Sprite3D.new()
	halo.texture = _glyph_tex
	halo.pixel_size = 0.009
	halo.modulate = Color(0.6, 1.0, 0.7, 0.55)
	halo.position = Vector3(0, 1.02, -0.8)
	st.add_child(halo)
	var l := OmniLight3D.new()
	l.light_color = Color(1.0, 0.95, 0.9)
	l.light_energy = 0.6
	l.omni_range = 5.0
	l.light_cull_mask = 1 << 19
	l.position = Vector3(0.5, 1.3, 1.4)
	st.add_child(l)
	_set_layer(st, 1 << 19)
	mira_vp = SubViewport.new()
	mira_vp.size = Vector2i(480, 240)
	mira_vp.render_target_update_mode = SubViewport.UPDATE_DISABLED
	add_child(mira_vp)
	var cam := Camera3D.new()
	cam.fov = 34.0
	cam.cull_mask = 1 << 19
	mira_vp.add_child(cam)
	cam.position = st.position + Vector3(0, 0.82, 1.55)
	cam.look_at(st.position + Vector3(0, 0.8, 0), Vector3.UP)
	cam.current = true
	screen_mat.set_shader_parameter("feed", mira_vp.get_texture())


# ------------------------------------------------------------------ the void and the white doorway (ch.31)

## "Mira stood framed in a doorway of pure white light, her silhouette
## flickering like a dream struggling to hold itself together."
func _void_room() -> void:
	var v := _sub(stages["void"], "void_set")
	box(Vector3(40, 0.4, 40), VOID + Vector3(0, -0.2, -8), mat(Color(0.012, 0.012, 0.014), 0.2, 0.2), true, v)
	var dz := VOID + Vector3(0, 0, -16)
	var frame := mat(Color(0.05, 0.05, 0.05), 0.6)
	box(Vector3(0.3, 3.8, 0.3), dz + Vector3(-1.3, 1.9, 0), frame, false, v)
	box(Vector3(0.3, 3.8, 0.3), dz + Vector3(1.3, 1.9, 0), frame, false, v)
	box(Vector3(2.9, 0.3, 0.3), dz + Vector3(0, 3.8, 0), frame, false, v)
	door_glow = _sub(v, "door_glow")
	quad(Vector2(2.3, 3.6), dz + Vector3(0, 1.8, -0.1), 0.0, glow(Color(1, 1, 1), 7.0), door_glow)
	floor_quad(Vector2(2.4, 9.0), dz + Vector3(0, 0.02, 4.5), 0.0, _unshaded(Color(0.9, 0.9, 0.95, 0.12)), door_glow)
	_lamp(v, dz + Vector3(0, 2.2, 1.6), Color(1, 1, 1), 2.4, 14.0, 200.0)


# ------------------------------------------------------------------ Carl's Tower (ch.31; bible A3-E1)

func _tp(th: float, r: float, y: float) -> Vector3:
	return TOWER + Vector3(cos(th) * r, y, sin(th) * r)


## A box whose local X points out from the tower's axis at angle th.
func _rbox(size: Vector3, th: float, r: float, y: float, m: Material, parent: Node, solid: bool) -> void:
	_obox(size, Transform3D(Basis(Vector3.UP, -th), _tp(th, r, y)), m, parent, solid)


## The drum of massive stone blocks, the obsidian stair along its outer ring
## (half a turn per floor), and one chamber a floor. Floor 0 is the stone
## chamber; floors 1-4 are Carl's Tower rooms in build order
## (main.tower_rooms), a bare landing for a room never built; the roof above.
func _tower() -> void:
	var root: Node3D = stages["tower"]
	var stone := tex_mat(_stone_tex(), Vector3.ONE / 3.2, 0.92, true)
	var floor_m := tex_mat(_stone_tex(), Vector3.ONE / 2.4, 0.7, true)
	var obsid := mat(Color(0.02, 0.018, 0.026), 0.07, 0.45)
	var gold := mat(Color(0.75, 0.58, 0.25), 0.35, 0.8)
	var slit := glow(Color(1.0, 0.7, 0.4), 2.2)
	var rooms: Array = main.tower_rooms
	for k in FLOORS + 1:
		var y := k * FH
		var fl := _sub(root, "f%d" % k)
		fl.set_meta("floor", k)
		var skin := _sub(fl, "skin")
		# the chamber floor and the landing half of the ring
		cyl(R_IN + 0.1, R_IN + 0.1, 0.5, _tp(0, 0, y - 0.25), floor_m, 36, skin)
		_solid_cyl(R_IN + 0.1, 0.5, _tp(0, 0, y - 0.25), fl)
		for i in 12:
			var th := PI + PI * (i + 0.5) / 12.0
			_rbox(Vector3(3.3, 0.5, 3.45), th, R_MID, y - 0.25, floor_m, skin, true)
		# the outer wall, breathing, with slits of warm light
		for i in 24:
			var th := TAU * (i + 0.5) / 24.0
			_rbox(Vector3(0.7, FH, 3.6), th, R_OUT + 0.35, y + FH / 2.0, stone, skin, true)
			if i % 3 == 1:
				quad(Vector2(0.28, 1.4), _tp(th, R_OUT - 0.02, y + 3.6), atan2(-cos(th), -sin(th)), slit, skin)
		# the pillars round the chamber
		for i in 8:
			var th := TAU * i / 8.0 + 0.2
			cyl(0.42, 0.55, FH, _tp(th, R_IN - 0.45, y + FH / 2.0), stone, 10, skin)
			solid_box(Vector3(0.8, FH, 0.8), _tp(th, R_IN - 0.45, y + FH / 2.0), fl)
		# the obsidian stair up to the next floor (the last one to the roof)
		var chord := 2.0 * R_MID * sin(PI / (2.0 * STEPS))
		var rise := FH / STEPS
		for i in STEPS:
			var th := PI * (i + 0.5) / STEPS
			var ym := y + rise * (i + 0.5)
			var tread := Transform3D(Basis(Vector3.UP, -th), _tp(th, R_MID, ym - 0.35))
			_obox(Vector3(3.0, 0.7, chord * 1.05), tread, obsid, skin, false)
			_obox(Vector3(3.02, 0.04, 0.06), Transform3D(Basis(Vector3.UP, -th), _tp(th, R_MID, ym + 0.005) + Vector3(-sin(th), 0, cos(th)) * (-chord * 0.48)), gold, skin, false)
			var X := Vector3(cos(th), 0, sin(th))
			var Z := (Vector3(-sin(th), 0, cos(th)) * chord + Vector3(0, rise, 0)).normalized()
			var Y := Z.cross(X)
			_obox(Vector3(3.0, 0.3, sqrt(chord * chord + rise * rise) * 1.15), Transform3D(Basis(X, Y, Z), _tp(th, R_MID, ym - 0.15)), null, fl, true)
			if i >= 1:
				_rbox(Vector3(0.22, 1.0, chord * 1.08), th, R_IN + 0.12, ym + 0.5, obsid, skin, true)
		if k == 0:
			_stone_chamber(fl, skin)
		else:
			var slot := k - 1
			if slot < rooms.size():
				_room(str(rooms[slot]), fl, y)
			else:
				_bare(fl, y)
			_crowd(fl, y, "children" if k % 2 == 1 else "strangers")
		# light: the chamber, and the ring
		_lamp(fl, _tp(0, 0, y + 5.0), Color(1.0, 0.78, 0.5), 1.5, 14.0, 60.0)
		_lamp(fl, _tp(PI * 1.5, 11.4, y + 2.4), Color(1.0, 0.6, 0.3) if k % 2 == 1 else Color(0.9, 0.85, 1.0), 1.0, 9.0, 60.0)
		_batch(skin, 8.0)


## Floor 0: "Massive stone blocks—ancient, damp, and impossibly large. The
## walls seemed to breathe, slow and rhythmic. Moss and moisture clung to
## every surface."
func _stone_chamber(fl: Node3D, skin: Node3D) -> void:
	var moss := mat(Color(0.12, 0.2, 0.08), 0.95)
	var wet := mat(Color(0.03, 0.035, 0.03), 0.04, 0.2)
	for k in 26:
		var p := _tp(rng.randf() * TAU, rng.randf_range(1.0, R_IN - 1.0), 0.015)
		floor_quad(Vector2(rng.randf_range(0.6, 2.2), rng.randf_range(0.5, 1.6)), p, rng.randf() * TAU, moss if k % 2 == 0 else wet, skin)
	for k in 10:
		var th := rng.randf() * TAU
		stick(_tp(th, R_OUT - 0.1, rng.randf_range(4.0, 6.8)), _tp(th, R_OUT - 0.15, rng.randf_range(2.0, 3.5)), 0.05, moss, skin)
	# torches in iron
	var iron := mat(Color(0.08, 0.07, 0.06), 0.6, 0.6)
	for th: float in [PI * 1.25, PI * 1.75]:
		var p := _tp(th, R_OUT - 0.3, 2.4)
		cyl(0.08, 0.05, 0.6, p, iron, 6, skin)
		sphere(0.14, p + Vector3(0, 0.4, 0), glow(Color(1.0, 0.55, 0.2), 4.0), 6, skin)
		_lamp(fl, p + Vector3(0, 0.6, 0) - Vector3(cos(th), 0, sin(th)) * 0.6, Color(1.0, 0.55, 0.25), 1.2, 9.0, 60.0)


## A plaque by the stair head with the room's name carved in it, facing
## the landing.
func _plaque(text: String, fl: Node3D, y: float) -> void:
	var th := PI * 1.08
	var p := _tp(th, R_IN - 0.5, y)
	var face := atan2(cos(th), sin(th))
	box(Vector3(1.4, 0.9, 0.2), p + Vector3(0, 0.75, 0), mat(Color(0.3, 0.29, 0.26), 0.8), false, fl).rotation.y = face
	if text != "":
		label(text, p + Vector3(0, 0.78, 0) + Vector3(cos(th), 0, sin(th)) * 0.12, face, 0.004, Color(0.9, 0.8, 0.55), fl, false)


## Mira's council (ch.3): a robed philosopher, a chrome child, a librarian
## with stars for eyes, and two that never fully resolved. They float.
func _council(fl: Node3D, y: float) -> void:
	var ghost := _unshaded(Color(0.9, 0.82, 0.7, 0.35), true)
	var looks := [
		[Color(0.45, 0.35, 0.25), Color(0.85, 0.7, 0.6), {"long_coat": true, "hair": Color(0.8, 0.8, 0.8)}],
		[Color(0.72, 0.74, 0.78), Color(0.75, 0.78, 0.82), {"scale": 0.6, "hair": Color(0.7, 0.72, 0.75)}],
		[Color(0.25, 0.2, 0.35), Color(0.85, 0.72, 0.62), {"long_hair": true, "long_coat": true}],
		[Color(0.6, 0.6, 0.62), Color(0.7, 0.6, 0.55), {"long_coat": true}],
		[Color(0.35, 0.3, 0.3), Color(0.8, 0.7, 0.65), {"long_coat": true}],
	]
	for i in 5:
		var f := figure(looks[i][0], looks[i][1], looks[i][2])
		var a := TAU * i / 5.0 + 0.5
		f.position = _tp(a, 4.6, y + 0.5)
		fl.add_child(f)
		turn_to(f, _tp(0, 0, y))
		if i >= 3:
			for mi in f.find_children("*", "MeshInstance3D", true, false):
				(mi as MeshInstance3D).material_override = ghost
		if i == 2:
			for x: float in [-0.035, 0.035]:
				sphere(0.012, Vector3(x, 0.02, -0.105), glow(Color(1.0, 1.0, 0.9), 5.0), 6, f.get_meta("head"))
		councils.append([f, y + 0.5, rng.randf() * TAU])


## The rooms Carl built at the home terminal (bible A2: Focus, Calm, Memory,
## Courage), each with his council in it.
func _room(id: String, fl: Node3D, y: float) -> void:
	var c := _tp(0, 0, y)
	var wood := pbr("woodfloor", Vector3.ONE / 1.2, true, Color(0.55, 0.4, 0.28), 0.9)
	var paper := mat(Color(0.88, 0.86, 0.8), 0.9)
	var gold := mat(Color(0.8, 0.62, 0.25), 0.3, 0.85)
	var info: Array = LINES["rooms"].get(id, LINES["rooms"]["bare"])
	_plaque(info[0], fl, y)
	match id:
		"focus":
			box(Vector3(2.4, 0.08, 1.1), c + Vector3(0, 0.78, 0), wood, false, fl)
			for lx: float in [-1.1, 1.1]:
				for lz: float in [-0.48, 0.48]:
					box(Vector3(0.07, 0.78, 0.07), c + Vector3(lx, 0.39, lz), wood, false, fl)
			solid_box(Vector3(2.4, 0.9, 1.1), c + Vector3(0, 0.45, 0), fl)
			for k in 6:
				box(Vector3(0.3, 0.02 + k * 0.012, 0.42), c + Vector3(-0.85 + k * 0.32, 0.83 + k * 0.006, 0.1), paper, false, fl)
			stick(c + Vector3(0.8, 0.82, -0.3), c + Vector3(0.8, 1.35, -0.3), 0.02, gold, fl)
			sphere(0.1, c + Vector3(0.8, 1.4, -0.3), glow(Color(1.0, 0.9, 0.7), 3.0), 8, fl)
			var lens := newmat(Color(0.7, 0.85, 1.0, 0.3), 0.02, 0.2)
			lens.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			stick(c + Vector3(-2.6, 0, 1.4), c + Vector3(-2.6, 1.5, 1.4), 0.04, gold, fl)
			sphere(0.45, c + Vector3(-2.6, 1.95, 1.4), lens, 16, fl)
		"calm":
			var rim := mat(Color(0.45, 0.43, 0.4), 0.8)
			for i in 20:
				var a := TAU * i / 20.0
				box(Vector3(0.5, 0.35, 1.15), c + Vector3(cos(a) * 3.2, 0.17, sin(a) * 3.2), rim, false, fl).rotation.y = -a
			cyl(3.05, 3.05, 0.04, c + Vector3(0, 0.22, 0), mat(Color(0.02, 0.05, 0.08), 0.01, 0.3), 32, fl)
			_solid_cyl(3.4, 0.4, c + Vector3(0, 0.2, 0), fl)
			for k in 5:
				sphere(rng.randf_range(0.18, 0.35), c + Vector3(rng.randf_range(-1.8, 1.8), 0.22, rng.randf_range(-1.8, 1.8)), mat(Color(0.5, 0.48, 0.45), 0.6), 8, fl).scale.y = 0.6
		"memory":
			# a frame each for the four memories that could be traded for words
			var items := ["drawing", "photo", "lion", "trophy"]
			var traded: Array = main.traded
			for i in 6:
				var a := TAU * i / 6.0 + PI / 6.0
				var p := c + Vector3(cos(a) * 3.4, 0, sin(a) * 3.4)
				var face := atan2(-cos(a), -sin(a))
				box(Vector3(2.0, 2.6, 0.12), p + Vector3(0, 1.3, 0), wood, false, fl).rotation.y = face
				var inner := p + Vector3(-cos(a), 0, -sin(a)) * 0.08 + Vector3(0, 1.45, 0)
				if i >= items.size():
					# the NICU glass, and the leaves
					quad(Vector2(1.5, 1.1), inner, face, _unshaded(Color(0.75, 0.9, 0.95, 0.5)) if i == 4 else mat(Color(0.85, 0.45, 0.12), 0.9), fl)
					continue
				if items[i] in traded:
					box(Vector3(0.04, 0.08, 0.04), inner + Vector3(0, 0.55, 0), gold, false, fl)
					continue
				match items[i]:
					"drawing":
						quad(Vector2(1.3, 1.0), inner, face, paper, fl)
						quad(Vector2(0.8, 0.8), inner + Vector3(-cos(a), 0, -sin(a)) * 0.01, face, _glyph_mat(Color(0.9, 0.1, 0.08)), fl)
					"photo":
						quad(Vector2(1.3, 0.9), inner, face, mat(Color(0.55, 0.45, 0.35), 0.7), fl)
						for f in 4:
							quad(Vector2(0.16, 0.42 - f * 0.05), inner + Vector3(-cos(a), 0, -sin(a)) * 0.01 + Vector3(sin(a), 0, -cos(a)) * (-0.36 + f * 0.24) + Vector3(0, -0.1, 0), face, mat(Color(0.2, 0.16, 0.12), 0.8), fl)
					"lion":
						var lp := p + Vector3(-cos(a), 0, -sin(a)) * 0.5
						box(Vector3(0.6, 0.9, 0.6), lp + Vector3(0, 0.45, 0), mat(Color(0.3, 0.28, 0.25), 0.8), false, fl)
						var lion := mat(Color(0.85, 0.62, 0.25), 0.95)
						sphere(0.2, lp + Vector3(0, 1.08, 0), lion, 10, fl).scale = Vector3(1.0, 0.85, 1.3)
						sphere(0.15, lp + Vector3(0, 1.25, -0.17), mat(Color(0.6, 0.35, 0.12), 0.95), 10, fl)
						sphere(0.1, lp + Vector3(0, 1.25, -0.24), lion, 8, fl)
					"trophy":
						var tp := p + Vector3(-cos(a), 0, -sin(a)) * 0.5
						box(Vector3(0.6, 0.9, 0.6), tp + Vector3(0, 0.45, 0), mat(Color(0.3, 0.28, 0.25), 0.8), false, fl)
						cyl(0.18, 0.08, 0.32, tp + Vector3(0, 1.2, 0), gold, 12, fl)
						cyl(0.03, 0.03, 0.14, tp + Vector3(0, 0.98, 0), gold, 6, fl)
						cyl(0.12, 0.12, 0.04, tp + Vector3(0, 0.92, 0), gold, 12, fl)
		"courage":
			var dark := mat(Color(0.1, 0.09, 0.08), 0.7)
			box(Vector3(0.8, 1.0, 0.8), c + Vector3(0, 0.5, 0), dark, true, fl)
			box(Vector3(0.05, 0.02, 0.34), c + Vector3(0, 1.02, -0.05), mat(Color(0.7, 0.72, 0.75), 0.15, 0.95), false, fl)
			box(Vector3(0.05, 0.04, 0.14), c + Vector3(0, 1.03, 0.2), mat(Color(0.3, 0.18, 0.1), 0.7), false, fl)
			var flame := newmat(Color(1.0, 0.5, 0.15, 0.7))
			flame.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
			flame.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			flame.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
			flame.cull_mode = BaseMaterial3D.CULL_DISABLED
			for a: float in [0.0, PI / 3.0, PI * 2.0 / 3.0]:
				quad(Vector2(1.0, 1.6), c + Vector3(2.6, 0.8, 0), a, flame, fl)
			cyl(0.6, 0.7, 0.3, c + Vector3(2.6, 0.15, 0), dark, 10, fl)
			for a: float in [PI * 0.8, PI * 1.2]:
				quad(Vector2(1.0, 4.2), c + Vector3(cos(a) * 4.2, 3.4, sin(a) * 4.2), atan2(-cos(a), -sin(a)), mat(Color(0.5, 0.08, 0.06), 0.9), fl)
	_council(fl, y)
	var mark := Node3D.new()
	mark.position = c + Vector3(0, 1.5, 0)
	mark.set_meta("scan", "CARL'S TOWER  //  %s\ncouncil: CONVENED" % info[0])
	fl.add_child(mark)


## "A room never built is a bare landing."
func _bare(fl: Node3D, y: float) -> void:
	_plaque("", fl, y)
	var dust := _unshaded(Color(0.6, 0.58, 0.52, 0.12))
	for k in 8:
		floor_quad(Vector2(rng.randf_range(1.0, 3.0), rng.randf_range(1.0, 2.5)), _tp(rng.randf() * TAU, rng.randf_range(0.5, 6.0), y + 0.012), rng.randf() * TAU, dust, fl)
	var mark := Node3D.new()
	mark.position = _tp(0, 0, y + 1.5)
	mark.set_meta("scan", "CARL'S TOWER  //  NOT BUILT")
	fl.add_child(mark)


const PAST := [["AGATA GREENWOOD", Color(0.45, 0.42, 0.55), true], ["SETH MCCARREN", Color(0.12, 0.3, 0.45), false],
	["HAROLD DUFREDY", Color(0.3, 0.28, 0.25), false], ["THE OFFICER", Color(0.05, 0.07, 0.16), false],
	["THE NURSE", Color(0.75, 0.85, 0.85), true], ["ANNIE SEUNG", Color(0.6, 0.2, 0.25), true], ["DOUGLAS VOREMON", Color(0.1, 0.1, 0.12), false]]


## On every landing: "Some were filled with children holding candles, their
## faces upturned in awe. Others held strangers from my past, all clapping,
## all smiling, all chanting my name."
func _crowd(fl: Node3D, y: float, kind: String) -> void:
	var wax := mat(Color(0.95, 0.92, 0.85), 0.8)
	var flame := glow(Color(1.0, 0.65, 0.25), 5.0)
	for j in 7:
		var th := PI + 0.35 + j * (PI - 0.7) / 6.0
		var p := _tp(th, R_OUT - 0.7, y)
		var f: Node3D
		if kind == "children":
			var sk: Color = [Color(0.86, 0.7, 0.58), Color(0.6, 0.44, 0.32), Color(0.92, 0.78, 0.68)][j % 3]
			f = figure(Color(0.92, 0.92, 0.9), sk, {"arms": true, "scale": 0.56, "long_hair": j % 2 == 0, "hair": Color(0.15, 0.1, 0.06) if j % 3 else Color(0.5, 0.35, 0.15), "legs": Color(0.85, 0.85, 0.83)})
			var arms: Array = f.get_meta("arms")
			for a in arms:
				(a as Node3D).rotation.x = -1.25
			cyl(0.035, 0.035, 0.22, Vector3(0, -0.62, -0.02), wax, 6, arms[0])
			sphere(0.04, Vector3(0, -0.76, -0.02), flame, 5, arms[0])
			(f.get_meta("head") as Node3D).rotation.x = 0.35
		else:
			var who: Array = PAST[(j + int(y)) % PAST.size()]
			f = figure(who[1], Color(0.8, 0.64, 0.52), {"arms": true, "long_hair": who[2], "hair": Color(0.2, 0.15, 0.1)})
			f.set_meta("scan", "%s  //  CLAPPING" % who[0])
		f.position = p
		fl.add_child(f)
		turn_to(f, _tp(th, 0, y))
		crowds.append([f, kind, rng.randf() * TAU])


# ------------------------------------------------------------------ the roof: the fairy tale, and what is real

## The fairy tale: pastel sky, painted mountains, a white throne with gold.
## The real view (one second): Psyonic Tower's roof, the gantry, the chair
## from the DARPA facility wired for obliteration (the concept's chair of
## faces), blood at its base, drones like carrion flies, the city, and the
## plaza full of tens of thousands, chanting.
func _roof() -> void:
	var root: Node3D = stages["tower"]
	var rf := _sub(root, "roof")
	var y := ROOF_Y
	var stone := tex_mat(_stone_tex(), Vector3.ONE / 2.4, 0.7, true)
	cyl(R_IN + 0.1, R_IN + 0.1, 0.5, _tp(0, 0, y - 0.25), stone, 36, rf)
	_solid_cyl(R_IN + 0.1, 0.5, _tp(0, 0, y - 0.25), rf)
	for i in 12:
		var th := PI + PI * (i + 0.5) / 12.0
		_rbox(Vector3(3.3, 0.5, 3.45), th, R_MID, y - 0.25, stone, rf, true)
	for i in 32:
		var th := TAU * (i + 0.5) / 32.0
		_rbox(Vector3(0.6, 0.7, 2.7), th, R_OUT + 0.3, y + 0.35, stone, rf, true)
	for i in 14:
		var th := 0.08 + (PI - 0.4) * (i + 0.5) / 14.0
		_rbox(Vector3(0.3, 1.0, 1.4), th, R_IN - 0.05, y + 0.5, stone, rf, true)
	_rbox(Vector3(3.2, 1.0, 0.3), 0.0, R_MID, y + 0.5, stone, rf, true)
	# the fairy tale
	fairy = _sub(rf, "fairy")
	var mtex := _mountain_tex()
	var mm := StandardMaterial3D.new()
	mm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mm.albedo_texture = mtex
	mm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mm.cull_mode = BaseMaterial3D.CULL_DISABLED
	mm.disable_fog = true
	for i in 10:
		var a := TAU * i / 10.0
		var q := quad(Vector2(330, 230), _tp(a, 360, y + 45.0), atan2(-cos(a), -sin(a)), mm, fairy)
		q.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var haze := _unshaded(Color(0.86, 0.74, 0.9))
	haze.disable_fog = true
	floor_quad(Vector2(1200, 1200), _tp(0, 0, y - 50.0), 0.0, haze, fairy)
	for k in 9:
		var a := rng.randf() * TAU
		sphere(rng.randf_range(10, 22), _tp(a, rng.randf_range(160, 300), y + rng.randf_range(10, 60)), _unshaded(Color(1.0, 0.9, 0.92, 0.8)), 10, fairy).scale = Vector3(2.2, 0.6, 1.4)
	var petal := [mat(Color(0.95, 0.6, 0.7), 0.8), mat(Color(0.95, 0.9, 0.6), 0.8), mat(Color(0.7, 0.75, 1.0), 0.8)]
	for i in 40:
		var th := PI + 0.1 + rng.randf() * (PI - 0.2)
		sphere(0.09, _tp(th, R_OUT - 0.35 - rng.randf() * 0.3, y + 0.72), petal[i % 3], 5, fairy)
	# the throne
	var tw := _tp(PI * 1.5 - 0.24, 10.0, y)
	var throne := _sub(fairy, "throne")
	throne.position = tw
	throne.rotation.y = atan2(cos(PI * 1.5 - 0.24), sin(PI * 1.5 - 0.24))
	var white := mat(Color(0.95, 0.94, 0.9), 0.4)
	var gold := mat(Color(0.85, 0.66, 0.28), 0.3, 0.85)
	box(Vector3(0.9, 0.5, 0.8), Vector3(0, 0.25, 0), white, false, throne)
	box(Vector3(0.9, 0.08, 0.8), Vector3(0, 0.52, 0), gold, false, throne)
	box(Vector3(0.9, 1.9, 0.14), Vector3(0, 1.3, 0.36), white, false, throne)
	sphere(0.45, Vector3(0, 2.25, 0.36), white, 10, throne).scale = Vector3(1.0, 0.7, 0.3)
	for sx: float in [-0.5, 0.5]:
		box(Vector3(0.1, 0.35, 0.8), Vector3(sx, 0.75, 0), gold, false, throne)
	for k in 7:
		sphere(0.06, Vector3(-0.42 + k * 0.14, 2.62 + sin(k) * 0.05, 0.3), gold, 5, throne)
	solid_box(Vector3(1.0, 1.0, 0.9), tw + Vector3(0, 0.5, 0), rf)
	throne_it = interactable("throne", LINES["throne_prompt"], Vector3(0, 0.8, -0.1), Vector3(1.0, 1.0, 0.9), "", false, throne)
	set_active(throne_it, false)
	_lamp(rf, _tp(PI * 1.5, 7.0, y + 4.0), Color(1.0, 0.85, 0.8), 1.2, 16.0, 80.0)
	# what is real
	real = _sub(rf, "real")
	real.visible = false
	_real_view(real, y)
	_batch(rf, 20.0)
	_batch(fairy, 60.0)


func _real_view(rv: Node3D, y: float) -> void:
	var steel := mat(Color(0.3, 0.31, 0.33), 0.45, 0.8)
	var cab := mat(Color(0.02, 0.02, 0.022), 0.6, 0.2)
	var conc := pbr("concrete", Vector3.ONE / 3.0, true, Color(0.45, 0.45, 0.44), 1.0)
	cyl(R_OUT + 0.6, R_OUT + 0.6, 0.06, _tp(0, 0, y + 0.03), conc, 36, rv)
	var cw := _tp(PI * 1.5 - 0.24, 10.0, y)
	# the gantry and its cables, the blood
	for sx: float in [-1.6, 1.6]:
		for sz: float in [-1.4, 1.4]:
			stick(cw + Vector3(sx, 0, sz), cw + Vector3(sx, 4.2, sz), 0.07, steel, rv)
	for sz: float in [-1.4, 1.4]:
		stick(cw + Vector3(-1.6, 4.2, sz), cw + Vector3(1.6, 4.2, sz), 0.07, steel, rv)
	for sx: float in [-1.6, 1.6]:
		stick(cw + Vector3(sx, 4.2, -1.4), cw + Vector3(sx, 4.2, 1.4), 0.07, steel, rv)
	for k in 22:
		var top := cw + Vector3(rng.randf_range(-1.5, 1.5), 4.2, rng.randf_range(-1.3, 1.3))
		var end := cw + Vector3(rng.randf_range(-0.8, 0.8), rng.randf_range(1.2, 3.0), rng.randf_range(-0.6, 0.6))
		_sag(top, end, -0.3, 0.035, cab, rv, 3)
	var blood := mat(Color(0.22, 0.01, 0.01), 0.08, 0.2)
	cyl(1.5, 1.5, 0.02, cw + Vector3(0.2, 0.07, 0.3), blood, 18, rv).scale = Vector3(1.0, 1.0, 0.7)
	_darpa_chair(rv, cw)
	# PSYONIC on the parapet, aircraft lights, antennae
	for i in 7:
		var th := PI + 0.4 + i * 0.36
		var l := neon_text("PSYONIC"[i], _tp(th, R_OUT + 0.62, y + 1.6), atan2(cos(th), sin(th)), 1.4, GREEN, 3.0, rv)
		l.name = "psy%d" % i
	for th: float in [0.4, 2.2, 4.0, 5.6]:
		stick(_tp(th, R_OUT - 0.4, y), _tp(th, R_OUT - 0.4, y + 9.0), 0.08, steel, rv)
		var bl := sphere(0.25, _tp(th, R_OUT - 0.4, y + 9.2), glow(Color(1, 0.05, 0.05), 5.0), 6, rv)
		blinkers.append(bl)
	for k in 5:
		var a := rng.randf() * TAU
		var dr := prop("police_drone", _tp(a, rng.randf_range(18, 34), y + rng.randf_range(-4, 9)), rng.randf() * TAU, 2.2, false, rv)
		if dr:
			dr.name = "drone%d" % k
	# the tower falling away beneath, lit green; the city; the plaza
	var shaft := newmat(Color(0.03, 0.06, 0.05), 0.3, 0.6)
	cyl(R_OUT + 1.0, R_OUT + 6.0, 60.0, _tp(0, 0, y - 30.2), shaft, 24, rv)
	for k in 16:
		var a := TAU * k / 16.0
		_rbox(Vector3(0.2, 56.0, 0.5), a, R_OUT + 3.6, y - 31.0, glow(GREEN * 0.8, 2.2), rv, false)
	var ground := y - 60.0
	floor_quad(Vector2(900, 900), _tp(0, 0, ground), 0.0, mat(Color(0.03, 0.03, 0.04), 0.6), rv)
	cyl(220, 220, 0.3, _tp(0, 0, ground + 0.15), mat(Color(0.12, 0.12, 0.13), 0.7), 36, rv)
	var keep_parent: Node = kit_parent
	kit_parent = rv
	for i in 26:
		var a := TAU * i / 26.0 + rng.randf_range(-0.05, 0.05)
		var d := rng.randf_range(230.0, 380.0)
		var h := rng.randf_range(40.0, 150.0)
		var o := _tp(a, d, ground)
		cyber_block(o, atan2(-cos(a), -sin(a)) + PI, rng.randf_range(16, 30), h, rng.randf_range(14, 24), false, 1)
	kit_parent = keep_parent
	# the crowd: tens of thousands, and their candles
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	var pm := BoxMesh.new()
	pm.size = Vector3(0.6, 1.8, 0.45)
	mm.mesh = pm
	mm.instance_count = 9000
	for i in mm.instance_count:
		var a := rng.randf() * TAU
		var d := sqrt(rng.randf()) * 190.0 + 25.0
		mm.set_instance_transform(i, Transform3D(Basis(Vector3.UP, a), _tp(a, d, ground + 1.15)))
	var mmi := MultiMeshInstance3D.new()
	mmi.multimesh = mm
	mmi.material_override = mat(Color(0.05, 0.05, 0.06), 0.9)
	rv.add_child(mmi)
	var cm := MultiMesh.new()
	cm.transform_format = MultiMesh.TRANSFORM_3D
	var cq := SphereMesh.new()
	cq.radius = 0.35
	cq.height = 0.7
	cq.radial_segments = 4
	cq.rings = 2
	cm.mesh = cq
	cm.instance_count = 2500
	for i in cm.instance_count:
		var a := rng.randf() * TAU
		var d := sqrt(rng.randf()) * 190.0 + 25.0
		cm.set_instance_transform(i, Transform3D(Basis(), _tp(a, d, ground + 2.2)))
	var cmi := MultiMeshInstance3D.new()
	cmi.multimesh = cm
	cmi.material_override = glow(Color(1.0, 0.6, 0.25), 3.0)
	rv.add_child(cmi)
	_lamp(rv, _tp(PI * 1.5 - 0.24, 9.0, y + 5.0), Color(0.75, 0.85, 1.0), 1.4, 14.0, 80.0)


## The chair of faces (concept art): a black throne wired for obliteration,
## rods fanned behind it, four screens on stalks with Carl's face and green
## eyes, cables pouring from it, glyph panels on the arms, his broken frames
## on the floor, the amber eye behind.
func _darpa_chair(rv: Node3D, at: Vector3) -> void:
	var ch := _sub(rv, "darpa")
	ch.position = at
	ch.rotation.y = atan2(cos(PI * 1.5 - 0.24), sin(PI * 1.5 - 0.24))
	var black := mat(Color(0.04, 0.045, 0.05), 0.35, 0.6)
	var steel := mat(Color(0.3, 0.31, 0.33), 0.35, 0.85)
	var cab := mat(Color(0.02, 0.02, 0.022), 0.6, 0.2)
	box(Vector3(1.0, 0.55, 0.85), Vector3(0, 0.28, 0), black, false, ch)
	box(Vector3(1.0, 1.7, 0.18), Vector3(0, 1.3, 0.38), black, false, ch)
	for sx: float in [-0.56, 0.56]:
		box(Vector3(0.16, 0.12, 0.9), Vector3(sx, 0.78, -0.05), black, false, ch)
		box(Vector3(0.14, 0.06, 0.3), Vector3(sx, 0.85, -0.3), glow(GREEN, 2.5), false, ch)
		box(Vector3(0.06, 0.06, 0.06), Vector3(sx, 0.86, 0.2), steel, false, ch)
	for k in 6:
		var a := -0.9 + k * 0.36
		stick(Vector3(sin(a) * 0.2, 1.9, 0.45), Vector3(sin(a) * 1.0, 3.4, 0.6), 0.04, steel, ch)
	# the two spikes, waiting at eye height
	for sx: float in [-0.04, 0.04]:
		stick(Vector3(sx, 1.25, 0.3), Vector3(sx, 1.2, 0.05), 0.012, steel, ch)
	var face_src := figure(Color(0.2, 0.22, 0.27), Color(0.84, 0.66, 0.54), {"hair": Color(0.35, 0.22, 0.12)})
	var hm := _head_mi(face_src)
	for k in 4:
		var side := -1.0 if k % 2 == 0 else 1.0
		var hy := 1.4 + (k / 2) * 0.75
		var sp := Vector3(side * (0.95 + (k / 2) * 0.15), hy, 0.5)
		stick(Vector3(side * 0.3, 1.0 + (k / 2) * 0.5, 0.45), sp, 0.03, steel, ch)
		box(Vector3(0.42, 0.5, 0.06), sp + Vector3(0, 0, 0.05), black, false, ch)
		box(Vector3(0.44, 0.52, 0.02), sp + Vector3(0, 0, 0.085), glow(GREEN * 0.6, 1.2), false, ch)
		var head := MeshInstance3D.new()
		head.mesh = hm.mesh
		head.material_override = hm.material_override
		head.position = sp + Vector3(0, -0.04, -0.02)
		head.rotation.y = PI
		head.scale = Vector3.ONE * 1.25
		ch.add_child(head)
		for ex: float in [-0.04, 0.04]:
			sphere(0.016, sp + Vector3(ex * 1.25, 0.0, -0.13), glow(GREEN, 6.0), 5, ch)
	face_src.free()
	for k in 30:
		var a := rng.randf() * TAU
		var st := Vector3(rng.randf_range(-0.4, 0.4), rng.randf_range(0.2, 1.2), 0.45)
		var en := Vector3(cos(a) * rng.randf_range(1.2, 3.2), 0.03, sin(a) * rng.randf_range(1.2, 3.2) + 0.6)
		_sag(st, en, 0.25, 0.03, cab, ch, 3)
	# his frames, broken on the floor
	var lens := glow(GREEN * 0.7, 1.6)
	for sx: float in [-0.06, 0.06]:
		box(Vector3(0.1, 0.005, 0.05), Vector3(sx, 0.02, -0.8), lens, false, ch).rotation.y = sx * 4.0
	box(Vector3(0.26, 0.006, 0.012), Vector3(0, 0.02, -0.83), black, false, ch)
	# the amber eye behind
	var eye := Sprite3D.new()
	eye.texture = _glyph_tex
	eye.pixel_size = 0.03
	eye.modulate = Color(1.0, 0.65, 0.2, 0.9)
	eye.position = Vector3(0, 2.6, 2.4)
	eye.rotation.y = PI
	ch.add_child(eye)


# ------------------------------------------------------------------ Mira, running ahead

func _guide() -> void:
	guide = _mira_fig()
	guide.name = "guide"
	add_child(guide)
	guide.visible = false
	_route()


## Mira's way up: across the stone chamber to the stair, up half a turn,
## round the landing, up again, to the roof and the edge.
func _route() -> void:
	route.clear()
	route.append(TOWER + Vector3(-3, 0, 0))
	route.append(TOWER + Vector3(5, 0, -4))
	route.append(_tp(-0.25, R_MID, 0))
	for k in FLOORS + 1:
		var y := k * FH
		for i in 13:
			var th := PI * i / 12.0
			route.append(_tp(th, R_MID, y + FH * i / 12.0))
		if k < FLOORS:
			for i in range(1, 9):
				var th := PI + PI * i / 8.0
				route.append(_tp(th, R_MID, y + FH))
	for i in range(1, 6):
		route.append(_tp(PI + PI * 0.5 * i / 5.0, R_MID, ROOF_Y))
	route.append(_tp(PI * 1.5, R_OUT - 0.55, ROOF_Y))
	route_d.clear()
	var acc := 0.0
	for i in route.size():
		if i > 0:
			acc += (route[i] as Vector3).distance_to(route[i - 1])
		route_d.append(acc)


func _route_at(d: float) -> Vector3:
	d = clampf(d, 0.0, route_d[route_d.size() - 1])
	for i in range(1, route.size()):
		if route_d[i] >= d:
			var t := (d - float(route_d[i - 1])) / maxf(0.001, float(route_d[i]) - float(route_d[i - 1]))
			return (route[i - 1] as Vector3).lerp(route[i], t)
	return route[route.size() - 1]


func _rebuild_tower() -> void:
	var root: Node3D = stages["tower"]
	var keep := []
	for l in _lights:
		if is_instance_valid(l[0]) and not root.is_ancestor_of(l[0]):
			keep.append(l)
	_lights = keep
	var kb := []
	for b in blinkers:
		if is_instance_valid(b) and not root.is_ancestor_of(b):
			kb.append(b)
	blinkers = kb
	for c in root.get_children():
		root.remove_child(c)
		c.queue_free()
	crowds.clear()
	councils.clear()
	_tower()
	_roof()
	root.visible = stage == "tower"


# ------------------------------------------------------------------ the woods (ch.31; the leaves, A2-B6)

## "I was in a familiar wood. Autumn. The trees towered overhead, their
## leaves a brilliant canopy of gold and red." The pile, Monica and Mira in
## it, and the other Carl, carrying whatever was traded for words.
func _woods() -> void:
	var root: Node3D = stages["woods"]
	var w := _sub(root, "woods_set")
	box(Vector3(70, 0.4, 70), WOODS + Vector3(0, -0.2, -5), mat(Color(0.3, 0.22, 0.12), 0.95), true, w)
	floor_quad(Vector2(70, 70), WOODS + Vector3(0, 0.005, -5), 0.0, mat(Color(0.4, 0.25, 0.11), 0.95), w)
	floor_quad(Vector2(2.2, 70), WOODS + Vector3(0.9, 0.012, -5), 0.0, mat(Color(0.32, 0.24, 0.16), 0.95), w)
	var bark := pbr("bark", Vector3.ONE / 1.5, true)
	var leaves := [mat(Color(0.85, 0.55, 0.12), 0.9), mat(Color(0.75, 0.25, 0.1), 0.9), mat(Color(0.9, 0.7, 0.2), 0.9)]
	for p: Vector3 in [Vector3(-5, 0, -6), Vector3(5.5, 0, -7), Vector3(-6, 0, 1), Vector3(6.5, 0, 2), Vector3(-1.5, 0, -17), Vector3(-7, 0, -15),
			Vector3(6, 0, -14), Vector3(-9, 0, -8), Vector3(9, 0, -9), Vector3(-5, 0, 9), Vector3(5.5, 0, 10), Vector3(-3, 0, 18), Vector3(4, 0, 20), Vector3(10, 0, 4)]:
		tree(WOODS + p, rng.randf_range(5.5, 8.0), bark, leaves, w)
	for i in 110:
		var s := sphere(rng.randf_range(0.06, 0.13), WOODS + Vector3(rng.randf_range(-10, 10), 0.02, rng.randf_range(-20, 14)), leaves[i % 3], 5, w)
		s.scale = Vector3(1.0, 0.3, 1.0)
	var pile := WOODS + Vector3(0, 0, -10)
	for i in 90:
		var a := rng.randf() * TAU
		var d := rng.randf()
		var s := sphere(rng.randf_range(0.14, 0.3), pile + Vector3(cos(a) * 1.7 * d, 0.1 + (1.0 - d) * 0.5 + rng.randf_range(0, 0.15), sin(a) * 1.3 * d), leaves[i % 3], 6, w)
		s.scale = Vector3(1.0, 0.55, 1.0)
	_lamp(w, pile + Vector3(0, 4.0, 3.0), Color(1.0, 0.8, 0.5), 1.0, 14.0, 80.0)
	_batch(w, 20.0)
	w_monica = figure(Color(0.55, 0.18, 0.28), Color(0.86, 0.68, 0.56), {"hair": Color(0.06, 0.05, 0.05), "long_hair": true, "legs": Color(0.12, 0.12, 0.14), "arms": true, "knees": true, "long_coat": false})
	w_monica.position = pile + Vector3(-0.5, -0.25, -0.3)
	root.add_child(w_monica)
	turn_to(w_monica, pile + Vector3(0.4, 0, 6.0))
	for a in w_monica.get_meta("arms"):
		(a as Node3D).rotation.x = 2.4
		(a as Node3D).rotation.z = (-0.6 if (a as Node3D).position.x > 0.0 else 0.6)
	w_mira = figure(Color(0.82, 0.6, 0.75), Color(0.86, 0.68, 0.56), {"hair": Color(0.06, 0.05, 0.05), "long_hair": true, "legs": Color(0.82, 0.6, 0.75), "arms": true, "knees": true, "scale": 0.62, "long_coat": false})
	w_mira.position = pile + Vector3(0.45, -0.3, 0.0)
	root.add_child(w_mira)
	turn_to(w_mira, pile + Vector3(0, 0, 6.0))
	for a in w_mira.get_meta("arms"):
		(a as Node3D).rotation.x = 2.6
	w_other = _carl_fig()
	w_other.position = pile + Vector3(1.9, 0, 0.6)
	root.add_child(w_other)
	turn_to(w_other, pile)
	# what he carries is what was traded for words
	var hand := Vector3(0.0, 0.95, -0.32)
	var traded: Array = main.traded
	if "lion" in traded:
		sphere(0.09, hand + Vector3(-0.1, 0, 0), mat(Color(0.85, 0.62, 0.25), 0.9), 8, w_other).scale = Vector3(1.0, 0.8, 1.3)
	if "photo" in traded:
		box(Vector3(0.14, 0.1, 0.01), hand + Vector3(0.1, 0.05, 0), mat(Color(0.55, 0.45, 0.35), 0.7), false, w_other)
	if "drawing" in traded:
		box(Vector3(0.2, 0.01, 0.15), hand + Vector3(0, 0.1, 0), mat(Color(0.9, 0.88, 0.82), 0.9), false, w_other)
	if "trophy" in traded:
		cyl(0.05, 0.025, 0.12, hand + Vector3(0.05, -0.05, 0.05), mat(Color(0.85, 0.66, 0.28), 0.3, 0.85), 8, w_other)


## Carl: his coat, his jaw (the same figure for the other one, and the copy).
func _carl_fig() -> Node3D:
	return figure(Color(0.2, 0.22, 0.27), Color(0.86, 0.7, 0.58), {"hair": Color(0.35, 0.22, 0.12), "arms": true, "knees": true, "long_coat": true})


# ------------------------------------------------------------------ the walk out (the shore, the tunnel, Rail Cut)

## Back the way he came: the black river and its eyeless shore (A3-S4), the
## Tunelet tunnel, the ramp up to the Rail Cut depot (Emmet's route), dawn.
func _walk() -> void:
	var root: Node3D = stages["walk"]
	var rock := pbr("concrete", Vector3.ONE / 2.5, true, Color(0.2, 0.19, 0.18), 1.0)
	var dark := mat(Color(0.03, 0.03, 0.035), 0.6)
	var steel := mat(Color(0.32, 0.32, 0.33), 0.4, 0.8)
	var cab := mat(Color(0.02, 0.02, 0.022), 0.6, 0.2)
	# the shore
	var sh := _sub(root, "shore")
	box(Vector3(9.5, 0.4, 96), WALK + Vector3(2.0, -0.2, -46), rock, true, sh)
	box(Vector3(14, 0.4, 96), WALK + Vector3(-9.5, -1.6, -46), dark, true, sh)
	solid_box(Vector3(0.3, 3.0, 96), WALK + Vector3(-2.75, 1.0, -46), sh)
	var river := newmat(Color(0.0, 0.006, 0.004), 0.02, 0.4)
	floor_quad(Vector2(14, 96), WALK + Vector3(-9.5, -0.32, -46), 0.0, river, sh)
	for k in 24:
		var z := 2.0 - k * 4.1
		box(Vector3(1.2, 9.5 + rng.randf_range(-1, 1), 4.3), WALK + Vector3(7.2 + rng.randf_range(-0.3, 0.4), 4.5, z), rock, true, sh)
		box(Vector3(1.4, 10.0, 4.3), WALK + Vector3(-16.8, 4.5, z), rock, false, sh)
	box(Vector3(26, 0.8, 96), WALK + Vector3(-4.5, 9.4, -46), rock, false, sh)
	for k in 34:
		var p := WALK + Vector3(rng.randf_range(-15, 6.5), 9.0, rng.randf_range(-92, 0))
		var h := rng.randf_range(0.8, 3.0)
		cyl(rng.randf_range(0.15, 0.4), 0.01, h, p - Vector3(0, h / 2.0, 0), rock, 6, sh)
	for k in 8:
		var z := -4.0 - k * 11.0
		_sag(WALK + Vector3(6.6, 6.5, z), WALK + Vector3(6.6, 6.0, z - 10.0), 0.6, 0.06, cab, sh, 4)
	var faces := []
	for k in 3:
		faces.append(_eyeless_face([Color(0.8, 0.62, 0.5), Color(0.6, 0.44, 0.32), Color(0.9, 0.76, 0.66)][k], Color(0.2, 0.17, 0.15), 2800 + k, false))
	for i in 12:
		var f := figure(Color(0.55, 0.54, 0.5).darkened(rng.randf_range(0.0, 0.4)), [Color(0.8, 0.62, 0.5), Color(0.6, 0.44, 0.32), Color(0.9, 0.76, 0.66)][i % 3], {"long_coat": true, "knees": true, "hair": Color(0.2, 0.17, 0.15)})
		f.position = WALK + Vector3(-1.7 + rng.randf_range(-0.2, 0.2), 0, -7.0 - i * 6.8)
		f.rotation.y = PI / 2.0
		root.add_child(f)
		_head_mi(f).material_override = faces[i % 3]
		f.set_meta("eyeless", true)
		shore.append({"fig": f, "done": false, "yaw": f.rotation.y})
	# the ends: rock behind, and round the tunnel mouth ahead
	box(Vector3(26, 11, 0.6), WALK + Vector3(-4.5, 4.0, 3.2), rock, true, sh)
	box(Vector3(4.5, 9.4, 0.6), WALK + Vector3(5.55, 4.7, -92.3), rock, true, sh)
	box(Vector3(13.7, 10.4, 0.6), WALK + Vector3(-10.15, 3.6, -92.3), rock, true, sh)
	box(Vector3(6.6, 4.8, 0.6), WALK + Vector3(0, 7.1, -92.3), rock, false, sh)
	for z: float in [-10.0, -32.0, -54.0, -76.0]:
		_lamp(sh, WALK + Vector3(-6.0, 1.2, z), Color(0.3, 0.8, 0.55), 0.7, 18.0, 45.0)
	_batch(sh, 20.0)
	# the tunnel
	var tu := _sub(root, "tunnel")
	var tl := WALK + Vector3(0, 0, -147)
	var conc := pbr("concrete", Vector3.ONE / 2.0, true, Color(0.36, 0.35, 0.33), 1.0)
	box(Vector3(5.8, 0.4, 112), tl + Vector3(0, -0.2, 0), conc, true, tu)
	for s: float in [-1.0, 1.0]:
		box(Vector3(0.6, 4.6, 112), tl + Vector3(s * 3.0, 2.3, 0), conc, true, tu)
		box(Vector3(0.1, 0.12, 110), tl + Vector3(s * 0.72, 0.06, 0), steel, false, tu)
		for k in 7:
			_sag(tl + Vector3(s * 2.62, 3.6, 55 - k * 16.0), tl + Vector3(s * 2.62, 3.6, 39 - k * 16.0), 0.4, 0.04, cab, tu, 3)
	box(Vector3(6.2, 0.4, 112), tl + Vector3(0, 4.7, 0), conc, false, tu)
	for k in 90:
		box(Vector3(2.0, 0.08, 0.22), tl + Vector3(0, 0.04, 55 - k * 1.22), mat(Color(0.18, 0.14, 0.1), 0.9), false, tu)
	for k in 8:
		var z := 50 - k * 14.0
		box(Vector3(0.18, 0.08, 1.4), tl + Vector3(0, 4.45, z), mat(Color(0.5, 0.52, 0.5), 0.5), false, tu)
		if k % 2 == 0:
			var s := -1.0 if k % 4 == 0 else 1.0
			quad(Vector2(1.4, 1.4), tl + Vector3(s * 2.68, 2.0, z - 6.0), -s * PI / 2.0, _glyph_mat(Color(0.9, 0.12, 0.08)), tu)
	var rt := Node3D.new()
	rt.position = tl + Vector3(0, 1, 0)
	rt.set_meta("route", "tunelet_tunnel")
	tu.add_child(rt)
	for z: float in [40.0, 14.0, -12.0, -38.0]:
		_lamp(tu, tl + Vector3(0, 3.8, z), Color(1.0, 0.45, 0.25), 0.5, 10.0, 45.0)
	_batch(tu, 20.0)
	# the ramp up into the cutting, the portal, the depot yard at dawn
	var dp := _sub(root, "depot")
	var r0 := WALK + Vector3(0, 0, -203)
	# 15 m: the ramp's top meets the yard's edge (z -218) level; at 16 it
	# ran in under the yard and left a 0.45 m step at the top no one could
	# climb (the walk-out of Burn and Refuse ended there)
	var rl := 15.0
	var X := Vector3(1, 0, 0)
	var Z := Vector3(0, DEPOT_Y, -rl).normalized() * -1.0
	var Y := Z.cross(X)
	_obox(Vector3(5.6, 0.4, sqrt(rl * rl + DEPOT_Y * DEPOT_Y) + 0.6), Transform3D(Basis(X, Y, Z), r0 + Vector3(0, DEPOT_Y / 2.0 - 0.2, -rl / 2.0)), conc, dp, true)
	for s: float in [-1.0, 1.0]:
		box(Vector3(0.6, 9.0, 20), r0 + Vector3(s * 3.0, 3.5, -rl / 2.0), conc, true, dp)
	box(Vector3(6.2, 0.4, 6), r0 + Vector3(0, 4.7, 2.0), conc, false, dp)
	var yard := WALK + Vector3(0, DEPOT_Y, -240)
	var gravel := pbr("asphalt", Vector3.ONE / 3.0, true, Color(0.55, 0.5, 0.45), 1.0)
	box(Vector3(40, 0.4, 44), yard + Vector3(0, -0.2, 0), gravel, true, dp)
	for s: float in [-1.0, 1.0]:
		box(Vector3(17, DEPOT_Y + 0.4, 18), WALK + Vector3(s * 11.5, DEPOT_Y / 2.0 - 0.2, -209), gravel, true, dp)
	# the portal over the cutting
	var pc := WALK + Vector3(0, DEPOT_Y, -218)
	for s: float in [-1.0, 1.0]:
		box(Vector3(1.0, 5.0, 1.2), pc + Vector3(s * 3.4, 2.5, 0), conc, true, dp)
	box(Vector3(7.8, 1.2, 1.4), pc + Vector3(0, 5.4, 0), conc, false, dp)
	label("TUNELET  ·  RAIL CUT DEPOT", pc + Vector3(0, 5.4, -0.72), PI, 0.006, Color(0.9, 0.85, 0.7), dp, false)
	for s: float in [-1.0, 1.0]:
		box(Vector3(0.1, 0.12, 40), yard + Vector3(s * 0.72, 0.06, -2.0), steel, false, dp)
	# the fence, the shed, the scrap
	for k in 21:
		var x := -18.0 + k * 1.8
		stick(yard + Vector3(x, 0, -21.5), yard + Vector3(x, 2.4, -21.5), 0.04, steel, dp)
	for y: float in [0.6, 1.4, 2.2]:
		box(Vector3(36, 0.02, 0.02), yard + Vector3(0, y, -21.5), steel, false, dp)
	box(Vector3(8, 4.2, 6), yard + Vector3(-11, 2.1, -12), pbr("rust", Vector3.ONE / 2.0, true, Color(0.6, 0.55, 0.5), 1.0), true, dp)
	prop("rollershutter_door", yard + Vector3(-11, 0, -8.95), 0.0, 1.0, false, dp)
	for pr: Array in [["Barrel_01", Vector3(-6.5, 0, -6)], ["old_tyre", Vector3(-5.5, 0, -8)], ["cardboard_box_01", Vector3(8, 0, -5)],
			["plastic_crate_03", Vector3(9, 0, -6)], ["concrete_road_barrier", Vector3(4, 0, -16)], ["street_lamp_01", Vector3(5.5, 0, 4)], ["utility_box_01", Vector3(-8, 0, 3)]]:
		prop(pr[0], yard + pr[1], rng.randf() * TAU, 1.0, true, dp)
	_lamp(dp, yard + Vector3(5.0, 5.5, 4.0), Color(1.0, 0.7, 0.35), 1.0, 14.0, 60.0)
	_batch(dp, 20.0)
	# Tyson at the mouth, and Ezra if he came home
	tyson = figure(Color(0.35, 0.28, 0.2), Color(0.55, 0.4, 0.3), {"hair": Color(0.3, 0.3, 0.3), "legs": Color(0.25, 0.22, 0.18), "arms": true, "knees": true})
	tyson.position = yard + Vector3(1.0, 0, 16.0)
	root.add_child(tyson)
	turn_to(tyson, pc + Vector3(0, 0, 4))
	person("tyson", LINES["prompts"]["tyson"], tyson, LINES["scan"]["tyson"])
	ezra = figure(Color(0.2, 0.45, 0.32), Color(0.86, 0.68, 0.56), {"hair": Color(0.35, 0.22, 0.12), "legs": Color(0.25, 0.28, 0.4), "arms": true, "knees": true, "scale": 0.7, "long_coat": false})
	ezra.position = yard + Vector3(2.0, 0, 16.4)
	root.add_child(ezra)
	turn_to(ezra, pc + Vector3(0, 0, 4))
	person("ezra", LINES["prompts"]["ezra"], ezra, LINES["scan"]["ezra"])
	var truck := CarS.build(self, Color(0.4, 0.37, 0.3), {"van": true, "plate": "UNREG"})
	truck.position = yard + Vector3(7.0, 0, 9.0)
	truck.rotation.y = 0.4
	root.add_child(truck)


# ------------------------------------------------------------------ 86D (A3-E3)

## Home, the Drake flat on floor 86: the plasticky table, soy-loaf and
## synthetic chicken thighs (ch.3), the west wall of glass over the city.
## Monica and Mira at the table; the lights steady.
func _home() -> void:
	var root: Node3D = stages["home"]
	var h := _sub(root, "flat")
	var wood := pbr("woodfloor", Vector3.ONE / 1.6, true, Color(0.75, 0.6, 0.45), 0.9)
	var plaster := pbr("plaster", Vector3.ONE / 2.0, true, Color(0.78, 0.78, 0.76), 1.0)
	var dark := mat(Color(0.05, 0.05, 0.06), 0.5, 0.3)
	var white := mat(Color(0.88, 0.88, 0.86), 0.35)
	var steel := mat(Color(0.55, 0.56, 0.58), 0.35, 0.8)
	var accent := glow(Color(0.3, 1.0, 0.55), 1.6)
	box(Vector3(12.4, 0.3, 10.4), HOME + Vector3(0, -0.15, 0), wood, true, h)
	box(Vector3(12.4, 0.3, 10.4), HOME + Vector3(0, 2.85, 0), mat(Color(0.85, 0.85, 0.84), 0.9), false, h)
	box(Vector3(12.4, 2.7, 0.3), HOME + Vector3(0, 1.35, -5.15), plaster, true, h)
	box(Vector3(12.4, 2.7, 0.3), HOME + Vector3(0, 1.35, 5.15), plaster, true, h)
	box(Vector3(0.3, 2.7, 10.4), HOME + Vector3(6.15, 1.35, 0), plaster, true, h)
	# the glass wall and its mullions
	solid_box(Vector3(0.3, 2.7, 10.4), HOME + Vector3(-6.15, 1.35, 0), h)
	var glass := newmat(Color(0.05, 0.08, 0.1, 0.18), 0.05, 0.6)
	glass.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	quad(Vector2(10.4, 2.7), HOME + Vector3(-6.1, 1.35, 0), PI / 2.0, glass, h)
	for k in 6:
		box(Vector3(0.12, 2.7, 0.1), HOME + Vector3(-6.05, 1.35, -5.0 + k * 2.0), dark, false, h)
	box(Vector3(0.14, 0.06, 10.4), HOME + Vector3(-6.0, 2.62, 0), accent, false, h)
	# the kitchen: counter, cabinets, the fridge, the dead FreudBot panel
	box(Vector3(5.0, 0.9, 0.65), HOME + Vector3(2.4, 0.45, -4.65), white, true, h)
	box(Vector3(5.0, 0.05, 0.7), HOME + Vector3(2.4, 0.92, -4.63), dark, false, h)
	box(Vector3(5.0, 0.7, 0.4), HOME + Vector3(2.4, 2.1, -4.78), white, false, h)
	box(Vector3(5.0, 0.03, 0.03), HOME + Vector3(2.4, 1.72, -4.6), accent, false, h)
	box(Vector3(0.9, 1.95, 0.7), HOME + Vector3(5.4, 0.98, -4.6), steel, true, h)
	if not ("drawing" in main.traded):
		quad(Vector2(0.4, 0.3), HOME + Vector3(5.4, 1.3, -4.24), 0.0, mat(Color(0.92, 0.9, 0.85), 0.9), h)
		quad(Vector2(0.22, 0.22), HOME + Vector3(5.4, 1.3, -4.235), 0.0, _glyph_mat(Color(0.9, 0.1, 0.08)), h)
	for k in 3:
		box(Vector3(0.04, 0.04, 0.02), HOME + Vector3(5.25 + k * 0.12, 1.5, -4.24), glow(Color(0.3, 1.0, 0.55), 2.0), false, h)
	box(Vector3(0.5, 0.7, 0.04), HOME + Vector3(6.0, 1.5, -2.5), dark, false, h).rotation.y = PI / 2.0
	box(Vector3(1.6, 0.9, 0.05), HOME + Vector3(6.0, 1.6, 1.8), dark, false, h).rotation.y = PI / 2.0
	interactable("fridge", LINES["prompts"]["fridge"], HOME + Vector3(5.4, 1.2, -4.2), Vector3(0.9, 1.6, 0.2), "", false, h)
	interactable("window", LINES["prompts"]["window"], HOME + Vector3(-5.9, 1.4, 0.0), Vector3(0.2, 2.0, 8.0), "", false, h)
	# the table, plasticky, set for four
	var tb := HOME + Vector3(-0.5, 0, 0.2)
	box(Vector3(1.9, 0.05, 1.0), tb + Vector3(0, 0.76, 0), white, false, h)
	for lx: float in [-0.85, 0.85]:
		for lz: float in [-0.42, 0.42]:
			cyl(0.025, 0.025, 0.74, tb + Vector3(lx, 0.37, lz), steel, 6, h)
	solid_box(Vector3(1.9, 0.8, 1.0), tb + Vector3(0, 0.4, 0), h)
	for p: Vector3 in [Vector3(0, 0, 0.32), Vector3(-0.45, 0, -0.32), Vector3(0.45, 0, -0.32), Vector3(0.75, 0, 0)]:
		cyl(0.13, 0.11, 0.02, tb + p + Vector3(0, 0.795, 0), mat(Color(0.95, 0.95, 0.93), 0.3), 14, h)
	box(Vector3(0.36, 0.12, 0.16), tb + Vector3(0, 0.85, 0.0), mat(Color(0.62, 0.5, 0.36), 0.8), false, h)
	for k in 4:
		sphere(0.05, tb + Vector3(-0.15 + k * 0.1, 0.83, -0.12), mat(Color(0.7, 0.45, 0.25), 0.6), 6, h).scale = Vector3(1.4, 0.7, 1.0)
	# chairs: Monica north, Mira west, Ezra's east (empty), Carl's south
	var seats := [[tb + Vector3(0.3, 0, -0.85), 0.0], [tb + Vector3(-1.3, 0, 0.0), PI / 2.0], [tb + Vector3(1.3, 0, 0.0), -PI / 2.0], [tb + Vector3(0, 0, 0.9), PI]]
	for st: Array in seats:
		var c := _sub(h, "chair")
		c.position = st[0]
		c.rotation.y = st[1]
		box(Vector3(0.45, 0.05, 0.45), Vector3(0, 0.46, 0), white, false, c)
		box(Vector3(0.45, 0.5, 0.04), Vector3(0, 0.72, -0.22), white, false, c)
		for lx: float in [-0.2, 0.2]:
			for lz: float in [-0.2, 0.2]:
				cyl(0.015, 0.015, 0.46, Vector3(lx, 0.23, lz), steel, 5, c)
	h_chair_it = interactable("h_chair", LINES["home"]["chair"], tb + Vector3(0, 0.6, 0.95), Vector3(0.5, 0.8, 0.5), "", false, h)
	# the lamp over the table
	stick(tb + Vector3(0, 2.7, 0), tb + Vector3(0, 1.9, 0), 0.01, dark, h)
	cyl(0.08, 0.28, 0.22, tb + Vector3(0, 1.8, 0), dark, 14, h)
	sphere(0.07, tb + Vector3(0, 1.72, 0), glow(Color(1.0, 0.86, 0.65), 4.0), 8, h)
	_lamp(h, tb + Vector3(0, 1.6, 0), Color(1.0, 0.82, 0.6), 1.2, 7.0, 60.0)
	_lamp(h, HOME + Vector3(2.4, 1.6, -4.0), Color(0.5, 1.0, 0.65), 0.5, 4.0, 60.0)
	_lamp(h, HOME + Vector3(-5.0, 1.5, 0.0), Color(0.55, 0.65, 1.0), 0.6, 7.0, 60.0)
	# Silico, eighty-six floors down
	var keep_parent: Node = kit_parent
	var city := _sub(root, "city")
	kit_parent = city
	var ground := -150.0
	for i in 12:
		var x := -40.0 - i * 13.0 - rng.randf_range(0, 6)
		var z := rng.randf_range(-70, 70)
		cyber_block(HOME + Vector3(x, ground, z), PI / 2.0, rng.randf_range(14, 24), rng.randf_range(60, 140), rng.randf_range(12, 20), false, 1)
	floor_quad(Vector2(500, 500), HOME + Vector3(-200, ground, 0), 0.0, mat(Color(0.02, 0.02, 0.03), 0.7), city)
	for k in 6:
		box(Vector3(300, 0.1, 0.6), HOME + Vector3(-200, ground + 0.1, -60 + k * 24), glow(Color(1.0, 0.3, 0.6) if k % 2 else Color(0.2, 0.9, 1.0), 2.0), false, city)
	kit_parent = keep_parent
	_batch(h, 20.0)
	# Monica and Mira at the table
	h_monica = figure(Color(0.55, 0.18, 0.28), Color(0.86, 0.68, 0.56), {"hair": Color(0.06, 0.05, 0.05), "long_hair": true, "legs": Color(0.12, 0.12, 0.14), "arms": true, "knees": true, "long_coat": false})
	_head_mi(h_monica).material_override = _eyeless_face(Color(0.86, 0.68, 0.56), Color(0.06, 0.05, 0.05), 86, false, true)
	_black_eyes(h_monica)
	h_mira = _mira_fig()
	_head_mi(h_mira).material_override = _eyeless_face(Color(0.86, 0.7, 0.6), Color(0.06, 0.05, 0.05), 10, false, true)
	for pair: Array in [[h_monica, seats[0]], [h_mira, seats[1]]]:
		var f: Node3D = pair[0]
		var st: Array = pair[1]
		root.add_child(f)
		Anim.sit(f, 0.05)
		var fwd := Basis(Vector3.UP, float(st[1]) + PI) * Vector3(0, 0, -1)
		f.position = (st[0] as Vector3) + Vector3(0, 0.485 - 0.86 * f.scale.y, 0) + fwd * 0.02
		f.rotation.y = float(st[1]) + PI
		for a in f.get_meta("arms"):
			(a as Node3D).rotation.x = -1.1
	person("monica_home", LINES["prompts"]["monica_home"], h_monica).set_meta("eyeless", true)
	person("mira_home", LINES["prompts"]["mira_home"], h_mira).set_meta("eyeless", true)


# ------------------------------------------------------------------ the highway out (A3-E2)

func _road() -> void:
	var root: Node3D = stages["road"]
	var r := _sub(root, "road_set")
	floor_quad(Vector2(2400, 2400), ROAD + Vector3(0, -0.02, -200), 0.0, mat(Color(0.62, 0.45, 0.3), 1.0), r)
	floor_quad(Vector2(14, 1400), ROAD + Vector3(0, 0.01, -300), 0.0, pbr("asphalt", Vector3(14.0, 1400.0, 1.0) / 6.0, false, Color(0.7, 0.68, 0.66)), r)
	for k in 60:
		box(Vector3(0.18, 0.02, 4.0), ROAD + Vector3(0, 0.03, 300 - k * 14.0), mat(Color(0.9, 0.85, 0.6), 0.6), false, r)
	var steel := mat(Color(0.5, 0.5, 0.5), 0.5, 0.7)
	for s: float in [-1.0, 1.0]:
		box(Vector3(0.1, 0.3, 1200), ROAD + Vector3(s * 7.6, 0.6, -300), steel, false, r)
	# low mesas ahead, nothing standing on them
	for k in 7:
		var p := ROAD + Vector3(rng.randf_range(-700, 700), -10.0, -rng.randf_range(700, 1000))
		sphere(rng.randf_range(80, 160), p, mat(Color(0.45, 0.28, 0.2), 1.0), 10, r).scale = Vector3(1.6, 0.35, 1.0)
	# the city behind, every window out
	var dead := mat(Color(0.05, 0.05, 0.06), 0.8)
	for k in 40:
		var h := rng.randf_range(30, 160)
		box(Vector3(rng.randf_range(20, 45), h, rng.randf_range(20, 45)), ROAD + Vector3(rng.randf_range(-300, 300), h / 2.0, rng.randf_range(420, 600)), dead, false, r)
	box(Vector3(40, 420, 40), ROAD + Vector3(30, 210, 520), dead, false, r)
	cyl(46, 46, 30, ROAD + Vector3(30, 330, 520), dead, 16, r)
	_batch(r, 200.0)
	road_car = CarS.build(self, Color(0.4, 0.37, 0.3), {"van": true, "plate": "UNREG"})
	road_car.position = ROAD + Vector3(1.8, 0, 0)
	root.add_child(road_car)
	road_cam = Camera3D.new()
	road_cam.far = 3000.0
	road_cam.fov = 60.0
	root.add_child(road_cam)


# ------------------------------------------------------------------ sound

## The lullaby Monica sang to Mira in the NICU, hummed (Brahms, public
## domain), synthesised here so it can be the only thing left in the room.
static func _lullaby() -> AudioStreamWAV:
	var rate := 16000
	var beat := 0.44
	var seq := [["E4", 1], ["E4", 1], ["G4", 3], ["E4", 1], ["E4", 1], ["G4", 3], ["E4", 1], ["G4", 1], ["C5", 2], ["B4", 1.5], ["A4", 0.5], ["A4", 2],
		["G4", 2], ["D4", 1], ["E4", 1], ["F4", 2], ["D4", 2], ["D4", 1], ["E4", 1], ["F4", 3], ["D4", 1], ["F4", 1], ["B4", 1], ["A4", 1], ["G4", 2], ["B4", 2], ["C5", 4], ["", 2]]
	var semis := {"D4": -7, "E4": -5, "F4": -4, "G4": -2, "A4": 0, "B4": 2, "C5": 3}
	var total := 0.0
	for n: Array in seq:
		total += float(n[1]) * beat
	var count := int(total * rate)
	var b := PackedByteArray()
	b.resize(count * 2)
	var i := 0
	var ph := 0.0
	var lp := 0.0
	for n: Array in seq:
		var dur := float(n[1]) * beat
		var f := 0.0
		if str(n[0]) != "":
			f = 440.0 * pow(2.0, float(semis[str(n[0])]) / 12.0)
		var ns := int(dur * rate)
		for k in ns:
			if i >= count:
				break
			var t := float(k) / rate
			var env := minf(1.0, t / 0.08) * minf(1.0, (dur - t) / 0.12)
			var v := 0.0
			if f > 0.0:
				ph += TAU * f * (1.0 + 0.004 * sin(TAU * 5.0 * float(i) / rate)) / rate
				v = sin(ph) * 0.5 + sin(ph * 2.0) * 0.16 + sin(ph * 3.0) * 0.06
				v *= env
			v += (randf() - 0.5) * 0.015
			lp += (v - lp) * 0.35
			b.encode_s16(i * 2, int(clampf(lp, -1.0, 1.0) * 22000.0))
			i += 1
	var w := AudioStreamWAV.new()
	w.format = AudioStreamWAV.FORMAT_16_BITS
	w.mix_rate = rate
	w.stereo = false
	w.data = b
	w.loop_mode = AudioStreamWAV.LOOP_FORWARD
	w.loop_end = count
	return w


func _sounds() -> void:
	_lull = AudioStreamPlayer.new()
	_lull.stream = _lullaby()
	_lull.volume_db = -8.0
	add_child(_lull)


func ambience() -> void:
	_hum = main.loop("hum", -16.0) as AudioStreamPlayer
	_choir = main.loop("chant", -80.0) as AudioStreamPlayer
	_choir.pitch_scale = 0.7


func _fade_snd(ap: AudioStreamPlayer, db: float, t: float) -> void:
	if ap == null or not is_instance_valid(ap):
		return
	if not ap.playing:
		ap.volume_db = -60.0
		ap.play()
	create_tween().tween_property(ap, "volume_db", db, t)


## The hum stops: every loop in the level, at once.
func _silence() -> void:
	for k in main.amb:
		var ap = main.amb[k]
		if is_instance_valid(ap):
			ap.stop()
	if _lull:
		_lull.stop()


## A looping sound for a few seconds (the room's one laugh, the static).
func _burst(key: String, db: float, pitch: float, secs: float) -> void:
	var ap := AudioStreamPlayer.new()
	ap.stream = main.sfx[key]
	ap.volume_db = db
	ap.pitch_scale = pitch
	add_child(ap)
	ap.play()
	get_tree().create_timer(secs).timeout.connect(func():
		if is_instance_valid(ap):
			ap.queue_free())


# ------------------------------------------------------------------ the grid and the report (screens)

var _grid_mouse := 0.0
var _spin_slot: Label
var _spin_cards: GridContainer
var _spin_stamp: Label
var _sat := false
var _home_sat := false
var _ct := 0.0
var _anim_walk: Array = []
var _charge_t := 0.0
var _auto_on := false
var _redrock := ""


func _lbl(text: String, size: int, c: Color, parent: Control) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", c)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(l)
	return l


## "I was the city." The HUD comes back as the city's map: every district's
## power as a bar, a cursor to move over them, and the last input.
func _grid_build(cl: CanvasLayer) -> void:
	_grid = Control.new()
	_grid.set_anchors_preset(Control.PRESET_FULL_RECT)
	_grid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_grid.visible = false
	cl.add_child(_grid)
	var bg := ColorRect.new()
	bg.color = Color(0.0, 0.018, 0.012, 1.0)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_grid.add_child(bg)
	var t := _lbl(LINES["grid"]["title"], 30, GREEN, _grid)
	t.anchor_left = 0.2
	t.anchor_top = 0.06
	var sub := _lbl(LINES["grid"]["sub"], 16, Color(0.6, 0.8, 0.65), _grid)
	sub.anchor_left = 0.2
	sub.anchor_top = 0.12
	var box_ := VBoxContainer.new()
	box_.anchor_left = 0.2
	box_.anchor_right = 0.8
	box_.anchor_top = 0.19
	box_.anchor_bottom = 0.8
	box_.add_theme_constant_override("separation", 4)
	box_.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_grid.add_child(box_)
	for d: Array in LINES["districts"]:
		var row := ColorRect.new()
		row.color = Color(0, 0, 0, 0)
		row.custom_minimum_size = Vector2(0, 26)
		row.mouse_filter = Control.MOUSE_FILTER_IGNORE
		box_.add_child(row)
		var nm := _lbl(str(d[0]), 17, Color(0.7, 0.95, 0.75), row)
		nm.position = Vector2(10, 2)
		var bbg := ColorRect.new()
		bbg.color = Color(0.05, 0.12, 0.08)
		bbg.anchor_left = 0.42
		bbg.anchor_right = 0.98
		bbg.anchor_top = 0.3
		bbg.anchor_bottom = 0.7
		bbg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(bbg)
		var fill := ColorRect.new()
		fill.color = GREEN
		fill.anchor_bottom = 1.0
		fill.anchor_right = 0.9
		fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
		bbg.add_child(fill)
		_grid_rows.append([nm, fill, row])
	_grid_line = _lbl("", 18, Color(0.85, 1.0, 0.9), _grid)
	_grid_line.anchor_left = 0.2
	_grid_line.anchor_right = 0.8
	_grid_line.anchor_top = 0.83
	_grid_line.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_credits = RichTextLabel.new()
	_credits.bbcode_enabled = true
	_credits.anchor_left = 0.25
	_credits.anchor_right = 0.75
	_credits.anchor_top = 1.0
	_credits.anchor_bottom = 1.9
	_credits.add_theme_font_size_override("normal_font_size", 20)
	_credits.add_theme_font_size_override("bold_font_size", 34)
	_credits.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_credits.visible = false
	_credits.text = LINES["credits"]
	_grid.add_child(_credits)


## The report screen (Spin), one last time: the cards are everything in the
## ledger; the framing slot; the believability bar already full.
func _spin_build(cl: CanvasLayer) -> void:
	var L: Dictionary = LINES["spin"]
	var bg := ColorRect.new()
	bg.color = Color(0.03, 0.035, 0.04, 0.98)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bg.visible = false
	cl.add_child(bg)
	_spin = bg
	var t := _lbl(L["title"], 22, Color(0.45, 1.0, 0.6), bg)
	t.anchor_left = 0.04
	t.anchor_top = 0.04
	var c := _lbl(L["case"], 14, Color(0.6, 0.65, 0.6), bg)
	c.anchor_left = 0.04
	c.anchor_top = 0.09
	_spin_slot = _lbl(L["frames"] + ":   ______________", 20, Color(1.0, 0.85, 0.5), bg)
	_spin_slot.anchor_left = 0.4
	_spin_slot.anchor_top = 0.05
	_spin_cards = GridContainer.new()
	_spin_cards.columns = 3
	_spin_cards.anchor_left = 0.04
	_spin_cards.anchor_right = 0.74
	_spin_cards.anchor_top = 0.15
	_spin_cards.anchor_bottom = 0.95
	_spin_cards.add_theme_constant_override("h_separation", 10)
	_spin_cards.add_theme_constant_override("v_separation", 8)
	_spin_cards.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bg.add_child(_spin_cards)
	var bt := _lbl(L["bar"], 14, Color(0.7, 0.75, 0.7), bg)
	bt.anchor_left = 0.79
	bt.anchor_top = 0.15
	var bar_bg := ColorRect.new()
	bar_bg.color = Color(0.08, 0.1, 0.09)
	bar_bg.anchor_left = 0.81
	bar_bg.anchor_right = 0.86
	bar_bg.anchor_top = 0.2
	bar_bg.anchor_bottom = 0.85
	bar_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bg.add_child(bar_bg)
	var fill := ColorRect.new()
	fill.color = Color(0.35, 0.95, 0.5)
	fill.set_anchors_preset(Control.PRESET_FULL_RECT)
	fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar_bg.add_child(fill)
	var mark := ColorRect.new()
	mark.color = Color(1.0, 0.3, 0.25)
	mark.anchor_left = -0.3
	mark.anchor_right = 1.3
	mark.anchor_top = 0.3
	mark.anchor_bottom = 0.305
	mark.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bar_bg.add_child(mark)
	var ml := _lbl(L["mark"], 13, Color(1.0, 0.45, 0.4), bg)
	ml.anchor_left = 0.875
	ml.anchor_top = 0.38
	var fl := _lbl(L["full"], 16, Color(0.35, 0.95, 0.5), bg)
	fl.anchor_left = 0.815
	fl.anchor_top = 0.86
	_spin_stamp = _lbl(L["filed"], 72, Color(0.9, 0.12, 0.1, 0.9), bg)
	_spin_stamp.anchor_left = 0.3
	_spin_stamp.anchor_top = 0.4
	_spin_stamp.rotation = -0.25
	_spin_stamp.visible = false


func _spin_fill() -> void:
	for ch in _spin_cards.get_children():
		ch.queue_free()
	var led: Array = main.ledger
	var from := maxi(0, led.size() - 18)
	if led.is_empty():
		_lbl(LINES["spin"]["empty_ledger"], 16, Color(0.7, 0.7, 0.7), _spin_cards)
	for i in range(from, led.size()):
		var e: Dictionary = led[i]
		var pc := PanelContainer.new()
		var sb := StyleBoxFlat.new()
		sb.bg_color = Color(0.09, 0.1, 0.1)
		sb.border_color = Color(0.3, 0.6, 0.4, 0.6)
		sb.set_border_width_all(1)
		sb.set_content_margin_all(6)
		pc.add_theme_stylebox_override("panel", sb)
		pc.custom_minimum_size = Vector2(250, 58)
		pc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		pc.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_spin_cards.add_child(pc)
		var vb := VBoxContainer.new()
		vb.mouse_filter = Control.MOUSE_FILTER_IGNORE
		pc.add_child(vb)
		var h := hash(str(e.get("text", "")))
		var truth: String = ["TRUE", "HALF", "FALSE"][absi(h) % 3]
		var risk: String = ["LOW", "HIGH"][absi(h / 3) % 2]
		_lbl("%s · %s     %s / %s" % [str(e.get("level", "")).to_upper(), str(e.get("kind", "")).to_upper(), truth, risk], 11, Color(0.95, 0.75, 0.4), vb)
		var tx := _lbl(str(e.get("text", "")), 13, Color(0.85, 0.88, 0.86), vb)
		tx.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		tx.custom_minimum_size = Vector2(230, 0)
	_spin_slot.text = LINES["spin"]["frames"] + ":   ______________"
	_spin_stamp.visible = false


# ------------------------------------------------------------------ the knife

func _knife_on(on: bool) -> void:
	if on and (_knife == null or not is_instance_valid(_knife)):
		_knife = Node3D.new()
		var steel := mat(Color(0.86, 0.88, 0.9), 0.35, 0.55)
		var grip := mat(Color(0.22, 0.13, 0.07), 0.7)
		box(Vector3(0.032, 0.012, 0.25), Vector3(0, 0, -0.16), steel, false, _knife)
		box(Vector3(0.02, 0.01, 0.07), Vector3(0, 0.006, -0.31), steel, false, _knife).rotation.x = -0.25
		box(Vector3(0.1, 0.02, 0.016), Vector3(0, 0, -0.03), mat(Color(0.55, 0.48, 0.35), 0.3, 0.8), false, _knife)
		box(Vector3(0.034, 0.032, 0.12), Vector3(0, 0, 0.035), grip, false, _knife)
		main.player.cam.add_child(_knife)
		_knife.position = Vector3(0.24, -0.24, -0.42)
		_knife.rotation = Vector3(0.9, 0.25, 0.0)
	if _knife and is_instance_valid(_knife):
		_knife.visible = on


func _knife_drop() -> void:
	_knife_on(false)
	var p = main.player
	var fwd: Vector3 = Basis(Vector3.UP, p.yaw) * Vector3(0.15, 0, -0.7)
	if _floor_knife == null:
		_floor_knife = Node3D.new()
		dyn.add_child(_floor_knife)
		box(Vector3(0.032, 0.012, 0.3), Vector3(0, 0.01, -0.12), mat(Color(0.75, 0.77, 0.8), 0.15, 0.95), false, _floor_knife)
		box(Vector3(0.034, 0.03, 0.12), Vector3(0, 0.016, 0.06), mat(Color(0.22, 0.13, 0.07), 0.7), false, _floor_knife)
	_floor_knife.visible = true
	_floor_knife.global_position = Vector3(p.global_position.x, 0.005, p.global_position.z) + fwd
	_floor_knife.rotation.y = randf() * TAU
	main.play("slam", -6.0, 2.6)
	main.play("tap", -2.0, 2.2)


func _held() -> bool:
	if main._selftest:
		return _test_hold
	if ui.busy:
		return false
	return Input.is_action_pressed("interact") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)


func _given_tyson() -> bool:
	for g in main.given:
		if str(g).to_lower() == "tyson":
			return true
	return false


func _burn_ok() -> bool:
	return main.connection < 90.0 and not _given_tyson() and not _attack_spent


func _refuse_ok() -> bool:
	return main.pressure <= 40.0 and not _attack_spent


func _acts_text() -> String:
	var a: Dictionary = LINES["acts"]
	var out := [a["attack"], a["altar"]]
	if _burn_ok():
		out.append(a["valve"])
	if _refuse_ok():
		out.append(a["doors"])
	return "   ·   ".join(out)


func _wait(cond: Callable, secs: float) -> void:
	var t := 0.0
	while is_inside_tree() and not cond.call() and t < secs:
		await get_tree().process_frame
		t += get_process_delta_time()


func _near(p: Vector3, d: float) -> bool:
	var w := _walker().global_position
	return Vector2(w.x - p.x, w.z - p.z).length() < d and absf(w.y - p.y) < 3.0


# ------------------------------------------------------------------ A3-S6: grief, the fire, the screen

func intro() -> void:
	if _phase != "":
		return
	var f: Dictionary = main.flags
	_phase = "grief"
	_busy = true
	_frozen = true
	f["cinematic"] = true
	main.player.crouch = 0.85
	main.player.pitch = deg_to_rad(6.0)
	_knife_on(false)
	# the examine points stay out of the way of the held key (SPACE is also E)
	for it in people_its:
		if is_instance_valid(it):
			set_active(it, false)
	main.update_hud()
	# the frozen frame: nothing moves, the captions run over it
	for line: String in LINES["grief"]:
		await ui.caption(line, 2.4 + line.length() * 0.025)
	f["chair_grief"] = true
	main.log_line("chapel", LINES["ledger"]["grief"])
	# the fire
	_knife_on(true)
	_frozen = false
	await ui.think(LINES["fire"][0])
	create_tween().tween_property(main.player, "crouch", 0.0, 1.4).set_trans(Tween.TRANS_SINE)
	await ui.think(LINES["fire"][1])
	_fade_snd(_choir, -12.0, 4.0)
	for i in range(2, LINES["fire"].size()):
		await ui.think(LINES["fire"][i])
	ui.close()
	_phase = "charge"
	_charge_t = 0.0
	_hint_on(LINES["objective"]["charge"])
	main.update_hud()
	_busy = false


## Ten feet from the Prophet: the screen lights with Mira (A3-S6). At
## T:mira >= 1 she speaks first as herself; then the copy's cadence.
func _mira_speaks() -> void:
	_busy = true
	_phase = "mira"
	_hint_on("")
	var f: Dictionary = main.flags
	await ui.think(LINES["stopped"])
	ui.close()
	main.play("glitch", -4.0)
	ui.glitch(0.8, 0.8)
	screen_mat.set_shader_parameter("copy", 0.0)
	var tw := create_tween()
	tw.tween_method(func(v: float): screen_mat.set_shader_parameter("mira", v), 0.0, 1.0, 1.4)
	_fade_snd(_choir, -24.0, 2.0)
	_fade_snd(_hum, -26.0, 2.0)
	await main.player.face(Vector3(0, 7.2, -27.8), 1.4)
	for l: String in LINES["mira_seen"]:
		await ui.think(l)
	var herself: bool = int(main.trust.get("mira", 0)) >= 1
	if herself:
		await ui.say("Mira", LINES["mira_self"])
		await ui.think(LINES["mira_copy_turn"])
	create_tween().tween_method(func(v: float): screen_mat.set_shader_parameter("copy", v), 0.0, 1.0, 2.0)
	for l: String in LINES["mira"]:
		_glitch_pulse(0.5)
		await ui.say("Mira", l)
	for l: String in LINES["mira_after"]:
		await ui.think(l)
	ui.close()
	f["chair_mira"] = true
	main.log_line("chapel", LINES["ledger"]["mira"])
	ui.caption(LINES["heavy_cap"], 2.5)
	await main.player.face(PROPHET_AT + Vector3(0, 1.6, 0), 1.0)
	_after_mira()


func _glitch_pulse(amount: float) -> void:
	screen_mat.set_shader_parameter("glitch", amount)
	create_tween().tween_method(func(v: float): screen_mat.set_shader_parameter("glitch", v), amount, 0.0, 0.8)


## If Connection is 100 at the chapel, the chair is not offered: the copy
## (A3-E4). Otherwise the choice, made by acting.
func _after_mira() -> void:
	if main.connection >= 100.0:
		_busy = false
		_choose("copy")
		return
	_choice_begin()


func _choice_begin() -> void:
	_phase = "choice"
	_hold = 0.0
	main.flags.erase("cinematic")
	for it in people_its:
		if is_instance_valid(it):
			set_active(it, false)
	_hint_on(_acts_text())
	_fade_snd(_hum, -14.0, 1.0)
	main.update_hud()
	_busy = false


func _choose(kind: String) -> void:
	if _busy:
		return
	_busy = true
	await get_tree().process_frame
	_bar_bg.visible = false
	_hint_on("")
	match kind:
		"attack":
			await _attack()
		"drop":
			await _drop()
		"burn":
			await _burn()
		"refuse":
			await _refuse()
		"copy":
			await _copy_begin()


## Hold the attack the full five seconds: the knife passes through a
## projection; the Prophet was never there; the room laughs with one voice;
## +10 C; Burn and Refuse are gone ("the last attack is refused").
func _attack() -> void:
	var f: Dictionary = main.flags
	_phase = "ending"
	f["cinematic"] = true
	var p = main.player
	if _attack_spent:
		await ui.think(LINES["attack_again"])
		ui.close()
		_choice_begin()
		return
	await ui.think(LINES["attack"][0])
	ui.close()
	var tw := create_tween().set_parallel(true)
	tw.tween_property(p, "position", Vector3(PROPHET_AT.x - 0.15, p.position.y, PROPHET_AT.z + 0.6), 0.45)
	if _knife:
		tw.tween_property(_knife, "position", Vector3(0.05, -0.1, -0.75), 0.45)
	await tw.finished
	main.player.shake(0.6)
	await ui.think(LINES["attack"][1])
	# through him: he was light
	_projection(prophet)
	main.play("glitch", 0.0)
	ui.glitch(1.0, 1.4)
	await ui.think(LINES["attack"][2])
	await ui.think(LINES["attack"][3])
	_burst("murmur", 0.0, 0.42, 2.6)
	main.play("whisper", -2.0, 0.5)
	await ui.think(LINES["attack"][4])
	ui.close()
	main.add_connection(10.0, LINES["attack_why"])
	main.log_line("chapel", LINES["ledger"]["attack"])
	f["chair_attacked"] = true
	_attack_spent = true
	if _knife:
		_knife.position = Vector3(0.24, -0.24, -0.42)
	p.position = Vector3(0, p.position.y, TEN_FEET_Z + 0.4)
	await p.face(ALTAR + Vector3(0, 1.4, 0), 0.6)
	if main.connection >= 100.0:
		_busy = false
		_choose("copy")
		return
	_choice_begin()


func _projection(fig: Node3D) -> void:
	var ghost := _unshaded(Color(0.4, 1.0, 0.6, 0.35), true)
	for mi in fig.find_children("*", "MeshInstance3D", true, false):
		(mi as MeshInstance3D).set_meta("orig", (mi as MeshInstance3D).material_override)
		(mi as MeshInstance3D).material_override = ghost
	for k in 6:
		fig.visible = not fig.visible
		await get_tree().create_timer(0.12).timeout
	fig.visible = false


func _unprojection(fig: Node3D) -> void:
	for mi in fig.find_children("*", "MeshInstance3D", true, false):
		if (mi as MeshInstance3D).has_meta("orig"):
			(mi as MeshInstance3D).material_override = (mi as MeshInstance3D).get_meta("orig")
	fig.visible = true


## Drop the knife and walk to the altar: "Bow, Mimic." The bow key. The
## lullaby. The blades (behind the black card). -> A3-E1, or A3-E4 at 100.
func _drop() -> void:
	var f: Dictionary = main.flags
	_phase = "ending"
	f["cinematic"] = true
	_knife_drop()
	f["chair_dropped"] = true
	main.log_line("chapel", LINES["ledger"]["drop"])
	for i in 5:
		await ui.think(LINES["drop"][i])
	ui.close()
	var p = main.player
	create_tween().tween_property(p, "position", Vector3(0.0, p.position.y, ALTAR_Z + 0.1), 1.2)
	await p.face(ALTAR + Vector3(0, 1.5, 0), 1.2)
	if main.connection >= 100.0:
		_busy = false
		_choose("copy")
		return
	await ui.think(LINES["drop"][5])
	main.play("glitch", -6.0, 0.5)
	_burst("murmur", -2.0, 0.5, 1.8)
	await ui.say(LINES["room"], "[b]" + LINES["bow_mimic"] + "[/b]")
	ui.close()
	await _bow_prompt()
	await _bow(false)
	await _sit_from_blades(false)


func _bow_prompt() -> void:
	_phase = "bow"
	_hint_on(LINES["bow_prompt"])
	main.update_hud()
	var t := 0.0
	while is_inside_tree():
		await get_tree().process_frame
		t += get_process_delta_time()
		if main._selftest and t > 0.3:
			break
		if t > 0.5 and (Input.is_physical_key_pressed(KEY_B) or Input.is_action_pressed("interact")):
			break
	_hint_on("")


func _bow(copy: bool) -> void:
	main.flags["chair_bowed"] = true
	main.log_line("chapel", LINES["ledger"]["bow"])
	if copy:
		await ui.think(LINES["copy"]["bowed"])
	else:
		create_tween().tween_property(main.player, "crouch", 0.95, 0.8)
		create_tween().tween_property(main.player, "pitch", deg_to_rad(-25.0), 0.8)
		await ui.think(LINES["bow"][0])
	_fade_snd(_choir, -80.0, 2.0)
	_fade_snd(_hum, -30.0, 2.0)
	_lull.volume_db = -30.0
	_lull.play()
	create_tween().tween_property(_lull, "volume_db", -6.0, 3.0)
	await ui.think(LINES["bow"][1])
	await ui.think(LINES["bow"][2])
	ui.close()


# ------------------------------------------------------------------ small helpers for the sequences

var _capq: Array = []
var _cap_on := false
var _cmove := false              # the copy can be walked
var _light_t := 0.0


func _secs(s: float) -> void:
	await get_tree().create_timer(s).timeout


## Captions queue up, so beats that land close together do not overwrite.
func _cap(text: String, secs := 0.0) -> void:
	if text == "":
		return
	_capq.append([text, secs if secs > 0.0 else 2.2 + text.length() * 0.03])
	if _cap_on:
		return
	_cap_on = true
	while not _capq.is_empty() and is_inside_tree():
		var c: Array = _capq.pop_front()
		await ui.caption(str(c[0]), float(c[1]))
	_cap_on = false


## Free to walk, or not: the copy walks only when _cmove (Carl's own body
## stays locked under the cinematic flag the whole time it drives).
func _free(on: bool) -> void:
	if _copy:
		_cmove = on
		main.flags["cinematic"] = true
	elif on:
		main.flags.erase("cinematic")
	else:
		main.flags["cinematic"] = true


## Turn to a point: Carl's head, or the copy's body.
func _look(point: Vector3, t := 1.0) -> void:
	if _copy and _cbody:
		var d := point - _cbody.global_position
		var want := atan2(-d.x, -d.z)
		var tw := create_tween()
		tw.tween_property(self, "_cyaw", _cyaw + wrapf(want - _cyaw, -PI, PI), t)
		await tw.finished
	else:
		await main.player.face(point, t)


func _say_lines(lines: Array) -> void:
	for l: Array in lines:
		if str(l[0]) == "":
			await ui.think(str(l[1]))
		else:
			await ui.say(str(l[0]), str(l[1]))


func _teleport(at: Vector3) -> void:
	var w := _walker()
	w.global_position = at
	if w is CharacterBody3D:
		(w as CharacterBody3D).velocity = Vector3.ZERO


## A figure walks somewhere (the other Carl, Ezra), legs going.
func _walk_fig(fig: Node3D, to: Vector3, secs: float) -> void:
	turn_to(fig, to)
	if not fig in _anim_walk:
		_anim_walk.append(fig)
	var tw := create_tween()
	tw.tween_property(fig, "global_position", to, secs)
	await tw.finished
	_anim_walk.erase(fig)
	if is_instance_valid(fig):
		_pose_reset(fig)


func _pose_reset(fg: Node3D) -> void:
	for l in fg.get_meta("legs", []):
		(l as Node3D).rotation.x = 0.0
	for k in fg.get_meta("knees", []):
		(k as Node3D).rotation.x = 0.0
	var body: Node3D = fg.get_meta("body", null)
	if body:
		body.rotation = Vector3.ZERO
	var head: Node3D = fg.get_meta("head", null)
	if head:
		head.position.z = 0.0
	Anim.idle(fg, 0.0)


func _shake_hands(fig: Node3D) -> void:
	var arms: Array = fig.get_meta("arms", [])
	if arms.is_empty():
		return
	var a: Node3D = arms[0]
	var tw := create_tween()
	tw.tween_property(a, "rotation:x", -1.1, 0.4)
	tw.tween_property(a, "rotation:x", -0.9, 0.25)
	tw.tween_property(a, "rotation:x", -1.15, 0.25)
	tw.tween_property(a, "rotation:x", 0.0, 0.5)
	main.play("tap", -10.0, 0.8)


# ------------------------------------------------------------------ A3-E1 Sit (and A3-E4 from the blades on)

func _sit_from_blades(copy: bool) -> void:
	_phase = "ending"
	_free(false)
	_hint_on("")
	# the blades: the frame is withheld, the sound is not
	_card(LINES["cards"]["blades"])
	main.play("snap", -2.0, 0.6)
	await _secs(1.4)
	main.play("pressure", -3.0, 0.7)
	main.player.shake(0.9)
	await _secs(2.8)
	_fade_snd(_lull, -40.0, 1.5)
	_card(LINES["cards"]["ch31"])
	await _secs(1.8)
	_card_off()
	_lull.stop()
	_fade_snd(_hum, -80.0, 0.5)
	_fade_snd(_choir, -80.0, 0.5)
	for l: String in LINES["pain"]:
		await ui.caption(l, 2.0 + l.length() * 0.022)
	# the void, and Mira in a doorway of white light
	main.player.crouch = 0.0
	main.player.pitch = 0.0
	if copy and _cfig:
		_pose_reset(_cfig)
		_cfig.position.y = 0.0
	_show("void")
	_place(VOID + Vector3(0, 0.1, 0), 0.0)
	guide.visible = true
	guide.global_position = VOID + Vector3(0, 0, -15.3)
	guide.rotation.y = PI
	var garms: Array = guide.get_meta("arms")
	(garms[1] as Node3D).rotation = Vector3(-2.5, 0, 0.25)
	await _to_black(0.0, 1.8)
	await ui.say("Mira", LINES["follow"])
	await ui.think(LINES["doorway"])
	ui.close()
	_phase = "void"
	_hint_on(LINES["doorway_prompt"])
	_free(true)
	main.update_hud()
	if main._selftest:
		_st_walk_to(VOID + Vector3(0, 0.1, -13.2), 2.0)
	await _wait(func(): return _near(VOID + Vector3(0, 0, -16.0), 3.4), 120.0)
	_free(false)
	_hint_on("")
	(garms[1] as Node3D).rotation = Vector3.ZERO
	await ui.think(LINES["blink"])
	ui.close()
	ui.flash(1.2)
	main.play("glitch", -6.0, 1.4)
	# Carl's Tower: the stone chamber, the obsidian stair
	_show("tower")
	_place(TOWER + Vector3(-4.0, 0.1, 0.0), -90.0)
	_prog = 3.0
	guide.visible = true
	guide.global_position = _route_at(_prog)
	_said.clear()
	await _secs(0.6)
	await ui.think(LINES["chamber"])
	await ui.think(LINES["climb_think"])
	ui.close()
	_phase = "climb"
	_free(true)
	main.update_hud()
	_cap("MIRA:   " + LINES["climb"][0])
	if main._selftest:
		_st_climb()
	await _wait(func(): return _walker().global_position.y > ROOF_Y - 0.7, 900.0)
	await _roof_scene(copy)
	await _woods_scene(copy)
	await _grid_scene(copy)
	_finish("ending_copy" if copy else "ending_sit")


## The roof: Mira at the edge before painted mountains; one second of the
## real view; the throne; the spikes (behind the card).
func _roof_scene(copy: bool) -> void:
	_phase = "roof"
	_free(false)
	_hint_on("")
	_env("roof")
	_cull_lights()
	var edge := _tp(PI * 1.5, R_OUT - 0.6, ROOF_Y)
	_prog = route_d[route_d.size() - 1]
	_anim_walk.erase(guide)
	guide.visible = true
	guide.global_position = edge
	guide.rotation.y = atan2(-cos(PI * 1.5), -sin(PI * 1.5))
	_pose_reset(guide)
	await _look(edge + Vector3(0, 0.8, 0), 1.0)
	await ui.think(LINES["roof"])
	ui.close()
	var w := _walker()
	var stand := _tp(PI * 1.5 + 0.12, R_OUT - 0.95, ROOF_Y + 0.1)
	var tw := create_tween()
	tw.tween_property(w, "global_position", stand, 2.0)
	if _copy and _cfig:
		_anim_walk.append(_cfig)
	await tw.finished
	_anim_walk.erase(_cfig)
	await _look(_tp(PI * 1.5 + 0.12, 130.0, ROOF_Y - 52.0), 1.4)
	# the glitch: Psyonic Tower's roof, the city, the plaza chanting
	main.play("glitch", 0.0, 0.8)
	ui.glitch(1.0, 1.2)
	fairy.visible = false
	real.visible = true
	_env("real")
	_burst("chant", -2.0, 1.0, 1.1)
	_burst("static", -8.0, 1.0, 1.0)
	await _secs(1.0)
	real.visible = false
	fairy.visible = true
	_env("roof")
	ui.glitch(0.5, 0.6)
	await ui.think(LINES["glitch"][0])
	await ui.think(LINES["glitch"][1])
	ui.close()
	turn_to(guide, w.global_position, 0.6)
	await _secs(0.5)
	var throne: Node3D = fairy.get_node("throne")
	await ui.say("Mira", LINES["throne"])
	await _look(throne.global_position + Vector3(0, 1.0, 0), 1.0)
	# for a breath the throne is the chair from the facility, wired and waiting
	fairy.visible = false
	real.visible = true
	_env("real")
	main.play("glitch", -4.0, 1.3)
	ui.glitch(0.8, 0.5)
	await _secs(0.4)
	real.visible = false
	fairy.visible = true
	_env("roof")
	await ui.say("Carl", LINES["honored"])
	await ui.say("Mira", LINES["throne_2"])
	ui.close()
	_sat = false
	if copy:
		await ui.think(LINES["copy"]["auto_sit"])
		ui.close()
		_sat = true
	else:
		_phase = "throne"
		set_active(throne_it, true)
		_hint_on("E   " + LINES["throne_prompt"])
		_free(true)
		main.update_hud()
		if main._selftest:
			get_tree().create_timer(0.6).timeout.connect(func(): _sat = true)
		await _wait(func(): return _sat, 300.0)
		set_active(throne_it, false)
		_hint_on("")
		await get_tree().process_frame
	_free(false)
	_phase = "sit"
	main.update_hud()
	var seat := throne.global_position + throne.global_transform.basis * Vector3(0, 0.0, -0.2)
	if copy and _cbody:
		_cbody.global_position = seat
		_cyaw = throne.global_rotation.y
		Anim.sit(_cfig, 0.1)
		_cfig.position.y = 0.56 - 0.86
	else:
		var p = main.player
		p.seated = true
		p.position = seat
		p.yaw = throne.global_rotation.y
		p.pitch = deg_to_rad(-4.0)
		p.crouch = 0.75
	main.flags["chair_sat"] = true
	main.log_line("tower", LINES["ledger"]["sit"])
	turn_to(guide, seat, 0.5)
	await _secs(1.6)
	main.play("tap", 0.0, 1.8)
	await _secs(0.3)
	_card(LINES["cards"]["spikes"])
	main.play("snap", 0.0, 0.5)
	main.play("pressure", 0.0, 0.5)
	main.player.shake(1.0)
	await _secs(3.8)
	_card_off()
	main.player.seated = false
	main.player.crouch = 0.0
	if _cfig:
		_pose_reset(_cfig)
		_cfig.position.y = 0.0
	guide.visible = false


## The woods in autumn. Sit: the other Carl walks up, "Don't mind me, Carl",
## shakes my hand, strolls off down the path. Copy: reversed. We are the one
## by the leaves; the real Carl comes up the path; we shake his hand and walk
## away, and the camera stays with them.
func _woods_scene(copy: bool) -> void:
	_phase = "woods"
	main.update_hud()
	var pile := WOODS + Vector3(0, 0, -10)
	_show("woods")
	w_other.visible = true
	if not copy:
		_place(WOODS + Vector3(0.9, 0.1, 6.0), 0.0)
		w_other.global_position = pile + Vector3(1.9, 0, 0.6)
		turn_to(w_other, pile)
		main.play("step", -4.0, 0.7)
		await _to_black(0.0, 1.8)
		for l: String in LINES["woods"]:
			await ui.think(l)
		ui.close()
		var meet := WOODS + Vector3(0.9, 0, 4.4)
		await _walk_fig(w_other, meet, 3.0)
		turn_to(w_other, main.player.global_position, 0.4)
		await _look(w_other.global_position + Vector3(0, 1.62, 0), 0.8)
		await ui.say("Carl", LINES["copy_line"])
		_shake_hands(w_other)
		await ui.think(LINES["believed"])
		ui.close()
		_walk_fig(w_other, WOODS + Vector3(1.6, 0, 40.0), 14.0)
		await _look(pile + Vector3(0, 0.6, 0), 1.2)
		await ui.think(LINES["collapse"])
		ui.close()
	else:
		_place(pile + Vector3(1.9, 0.1, 0.6), 0.0)
		var d := pile - _cbody.global_position
		_cyaw = atan2(-d.x, -d.z)
		w_other.global_position = WOODS + Vector3(0.9, 0, 14.0)
		turn_to(w_other, pile)
		_cfixed = true
		_ccam.global_position = pile + Vector3(-3.6, 2.0, 5.6)
		_ccam.look_at(pile + Vector3(0.9, 0.9, 1.8), Vector3.UP)
		await _to_black(0.0, 1.8)
		await ui.think(LINES["woods"][1])
		await ui.think(LINES["copy"]["real_carl"])
		ui.close()
		await _walk_fig(w_other, pile + Vector3(1.5, 0, 3.4), 4.0)
		turn_to(w_other, _cbody.global_position, 0.4)
		await _look(w_other.global_position, 0.6)
		await ui.say("Carl", LINES["copy"]["keeping"])
		_shake_hands(_cfig)
		await ui.think(LINES["copy"]["walk_away"])
		ui.close()
		_cyaw = PI
		_anim_walk.append(_cfig)
		var tw := create_tween()
		tw.tween_property(_cbody, "global_position", WOODS + Vector3(0.9, 0.1, 30.0), 10.0)
		_walk_fig(w_other, pile + Vector3(0.9, 0, 1.0), 2.4)
		await _secs(5.0)
		tw.kill()
		_anim_walk.erase(_cfig)
	ui.flash(1.0)
	main.play("glitch", -2.0, 0.6)
	_burst("static", -4.0, 0.6, 1.5)
	await _to_black(1.0, 0.6)
	_cfixed = false
	_anim_walk.clear()


## "I was the city." Thirty seconds of the grid as a body; the memory of the
## leaves; Red Rock Plaza: hold to keep it lit and the credits run, let go
## and it goes dark.
func _grid_scene(copy: bool) -> void:
	_phase = "grid"
	_free(false)
	main.update_hud()
	for k in stages:
		(stages[k] as Node3D).visible = false
	_env("grid")
	_grid.visible = true
	_credits.visible = false
	_credits.position.y = 0.0
	_grid_sel = 0
	for r: Array in _grid_rows:
		(r[1] as ColorRect).anchor_right = 0.9
		(r[0] as Label).modulate = Color(1, 1, 1)
	_grid_line.text = LINES["copy"]["city"] if copy else LINES["grid"]["move"]
	_black.color.a = 0.0
	ui.flash(0.8)
	_fade_snd(_hum, -10.0, 3.0)
	var t := 0.0
	var mem := false
	while t < 30.0 and is_inside_tree():
		await get_tree().process_frame
		var dt := get_process_delta_time()
		t += dt
		_grid_tick(t)
		if t > 16.0 and not mem:
			mem = true
			ui.flash(0.6)
			_grid_line.text = LINES["grid"]["memory"]
			main.play("whisper", -6.0, 1.2)
	# Red Rock Plaza
	_grid_sel = 0
	_grid_line.text = LINES["grid"]["hold"] + "     " + LINES["grid"]["hold_keys"]
	var held := 0.0
	var idle := 0.0
	var kept := false
	var row0: ColorRect = _grid_rows[0][1]
	while is_inside_tree():
		await get_tree().process_frame
		var dt := get_process_delta_time()
		t += dt
		_grid_tick(t)
		if _held():
			held += dt
			idle = 0.0
			row0.anchor_right = 0.95
			if held >= 10.0:
				kept = true
				break
		else:
			row0.anchor_right = 0.9 * (0.35 + 0.5 * randf())
			if held > 0.0:
				break
			idle += dt
			if idle > 9.0:
				break
	if kept:
		_grid_line.text = LINES["grid"]["kept"]
		_credits.visible = true
		var ct := 0.0
		var h := get_viewport().get_visible_rect().size.y
		while ct < 16.0 and is_inside_tree():
			await get_tree().process_frame
			var dt := get_process_delta_time()
			ct += dt
			t += dt
			_grid_tick(t)
			row0.anchor_right = 0.95
			_credits.position.y = -h * 1.2 * ct / 16.0
			if not _held():
				# it stays lit until he lets go; then the screen goes black
				break
	var f: Dictionary = main.flags
	f.erase("redrock_kept")
	f.erase("redrock_dark")
	f.erase("redrock_lit")
	if kept:
		# the ten-second hold: Epilogue reads redrock_lit for its one line
		f["redrock_kept"] = true
		f["redrock_lit"] = true
		_redrock = "kept"
		main.log_line("grid", LINES["ledger"]["redrock_kept"])
		await _secs(1.0)
	else:
		row0.anchor_right = 0.0
		(_grid_rows[0][0] as Label).modulate = Color(0.35, 0.35, 0.35)
		_credits.visible = false
		_grid_line.text = LINES["grid"]["dark"]
		main.play("outage", -2.0, 0.8)
		f["redrock_dark"] = true
		_redrock = "dark"
		main.log_line("grid", LINES["ledger"]["redrock_dark"])
		await _secs(5.0)
	_black.color.a = 1.0
	_grid.visible = false
	_credits.visible = false


func _grid_tick(t: float) -> void:
	if Input.is_action_just_pressed("move_fwd"):
		_grid_sel -= 1
	if Input.is_action_just_pressed("move_back"):
		_grid_sel += 1
	if absf(_grid_mouse) > 36.0:
		_grid_sel += int(signf(_grid_mouse))
		_grid_mouse = 0.0
	_grid_sel = clampi(_grid_sel, 0, _grid_rows.size() - 1)
	for i in _grid_rows.size():
		var r: Array = _grid_rows[i]
		if i > 0:
			(r[1] as ColorRect).anchor_right = 0.55 + 0.35 * (0.5 + 0.5 * sin(t * 1.3 + i * 1.7)) * (0.92 + 0.08 * randf())
		(r[2] as ColorRect).color = Color(0.1, 0.4, 0.2, 0.55) if i == _grid_sel else Color(0, 0, 0, 0)
	if _grid_desc == null:
		_grid_desc = _lbl("", 15, Color(0.55, 0.85, 0.65), _grid)
		_grid_desc.anchor_left = 0.2
		_grid_desc.anchor_right = 0.8
		_grid_desc.anchor_top = 0.785
	_grid_desc.text = "%s  —  %s" % [LINES["districts"][_grid_sel][0], LINES["districts"][_grid_sel][1]]


var _grid_desc: Label


# ------------------------------------------------------------------ A3-E2 Burn

func _burn() -> void:
	var f: Dictionary = main.flags
	_phase = "ending"
	_free(false)
	var p = main.player
	await p.face(VALVE + Vector3(0, 1.5, 0), 0.8)
	await ui.think(LINES["valve"]["look"])
	ui.close()
	# the ledger, and the line that matters
	var txt := "[b]LEDGER[/b]\n\n"
	var led: Array = main.ledger
	for i in range(maxi(0, led.size() - 6), led.size()):
		txt += "[color=#8a9a90]%s[/color]\n" % str((led[i] as Dictionary).get("text", ""))
	txt += "\n[color=#ff5a4a][b]%s[/b][/color]" % LINES["valve"]["ledger"]
	_ledger_text.text = txt
	_ledger_panel.visible = true
	_hint_on(LINES["valve"]["hold"])
	_bar_bg.visible = true
	_bar.anchor_right = 0.0
	_phase = "valve"
	var held := 0.0
	var waited := 0.0
	var ok := false
	while is_inside_tree():
		await get_tree().process_frame
		var dt := get_process_delta_time()
		if _held():
			held += dt
			valve_wheel.rotation.x = -held * 0.9
			p.shake(0.05)
			if held >= 3.0:
				ok = true
				break
		elif held > 0.25:
			break
		else:
			waited += dt
			if waited > 10.0:
				break
		_bar.anchor_right = clampf(held / 3.0, 0.0, 1.0)
	_bar_bg.visible = false
	_ledger_panel.visible = false
	_hint_on("")
	if not ok:
		create_tween().tween_property(valve_wheel, "rotation:x", 0.0, 0.8)
		await ui.think(LINES["valve"]["let_go"])
		ui.close()
		_choice_begin()
		return
	f["chair_valve"] = true
	main.log_line("cathedral", LINES["ledger"]["valve"])
	main.play("pressure", 0.0, 0.6)
	create_tween().tween_property(valve_wheel, "rotation:x", valve_wheel.rotation.x - TAU * 1.5, 3.0)
	await ui.think(LINES["burn"][0])
	_burst("vacuum", -4.0, 0.5, 3.0)
	await ui.think(LINES["burn"][1])
	# the veins empty
	var tw := create_tween().set_parallel(true)
	tw.tween_property(vein_mat, "albedo_color", Color(0.42, 0.42, 0.4), 3.0)
	tw.tween_property(vein_mat, "roughness", 0.95, 3.0)
	for m: StandardMaterial3D in cable_mats:
		tw.tween_property(m, "emission_energy_multiplier", 0.0, 2.5)
	drips.emitting = true
	await ui.think(LINES["burn"][2])
	await p.face(DESK + Vector3(0, 1.3, 0), 0.8)
	create_tween().tween_method(func(v: float): hole_mat.set_shader_parameter("collapse", v), 0.0, 1.0, 3.0)
	await ui.think(LINES["burn"][3])
	# and the hum stopped, for the first time
	_silence()
	await _secs(1.2)
	await ui.think(LINES["burn"][4])
	await ui.think(LINES["burn"][5])
	ui.close()
	# the chapel: they sit down, one by one
	await _go("core", Vector3(0, 0.1, -1.8), 0.0, 0.6)
	_sit_congregation()
	await ui.think(LINES["sit_down"])
	ui.close()
	await p.face(Vector3(0, 7.2, -27.8), 1.0)
	screen_mat.set_shader_parameter("copy", 1.0)
	create_tween().tween_method(func(v: float): screen_mat.set_shader_parameter("mira", v), 0.0, 1.0, 0.6)
	_glitch_pulse(0.6)
	await ui.say("Mira", LINES["daddy_q"])
	ui.close()
	var tw2 := create_tween().set_parallel(true)
	tw2.tween_method(func(v: float): screen_mat.set_shader_parameter("dark", v), 0.0, 1.0, 2.0)
	tw2.tween_property(screen_light, "light_energy", 0.0, 2.0)
	await tw2.finished
	await _secs(1.0)
	# the walk out, silent; the shore sits down as I pass
	_variant = "burn"
	tyson.visible = true
	ezra.visible = f.has("ezra_home")
	await _go("walk", WALK + Vector3(2.0, 0.1, -1.0), 0.0, 1.2)
	_phase = "walk"
	_free(true)
	main.update_hud()
	if main._selftest:
		_st_walk_out()
	await _wait(func(): return _at_depot(), 600.0)
	await _depot_burn()
	await _road_panels()
	_finish("ending_burn")


func _at_depot() -> bool:
	var w := _walker().global_position
	return w.z < WALK.z - 220.5 and w.y > DEPOT_Y - 1.0


func _sit_congregation() -> void:
	var order := congregation.duplicate()
	order.sort_custom(func(a, b): return (a["fig"] as Node3D).position.z > (b["fig"] as Node3D).position.z)
	for c: Dictionary in order:
		if not is_inside_tree() or c["sat"]:
			continue
		var fg: Node3D = c["fig"]
		c["sat"] = true
		Anim.sit(fg, 0.15)
		create_tween().tween_property(fg, "position:y", -0.4, 0.5)
		await _secs(0.12)


## Rail Cut at dawn: Tyson, and Ezra if he came home.
func _depot_burn() -> void:
	_free(false)
	_phase = "depot"
	var p = main.player
	_env("dawn")
	ui.caption(LINES["cards"]["dawn_cap"], 3.0)
	turn_to(tyson, p.global_position, 0.6)
	await p.face(tyson.global_position + Vector3(0, 1.6, 0), 1.0)
	await _say_lines(LINES["tyson"])
	if main.flags.has("ezra_home"):
		var lines: Array = LINES["tyson_ezra"]
		await _say_lines(lines.slice(0, 2))
		ui.close()
		await p.face(ezra.global_position + Vector3(0, 1.0, 0), 0.6)
		await _walk_fig(ezra, p.global_position + (ezra.global_position - p.global_position).normalized() * 0.7, 2.4)
		await _say_lines(lines.slice(2))
	else:
		await _say_lines(LINES["tyson_alone"])
	ui.close()
	await _secs(0.8)


## The highway: two panels. Frames off. Behind us, the dark city.
func _road_panels() -> void:
	await _to_black(1.0, 1.0)
	_show("road")
	road_car.position = ROAD + Vector3(1.8, 0, 0)
	road_car.rotation.y = 0.0
	road_cam.current = true
	road_cam.global_position = ROAD + Vector3(0.6, 2.3, 9.5)
	road_cam.look_at(ROAD + Vector3(1.8, 1.2, -80.0), Vector3.UP)
	var tw := create_tween()
	tw.tween_property(road_car, "position:z", ROAD.z - 45.0, 9.0)
	await _to_black(0.0, 1.0)
	ui.caption(LINES["cards"]["road_cap"], 2.0)
	await _secs(1.5)
	await ui.caption(LINES["road"][0], 4.0)
	await _to_black(1.0, 0.6)
	tw.kill()
	road_car.position = ROAD + Vector3(1.8, 0, -70.0)
	var tw2 := create_tween()
	tw2.tween_property(road_car, "position:z", ROAD.z - 104.0, 9.0)
	road_cam.global_position = ROAD + Vector3(-4.5, 1.3, -112.0)
	road_cam.look_at(ROAD + Vector3(10.0, 40.0, 500.0), Vector3.UP)
	await _to_black(0.0, 0.8)
	await ui.caption(LINES["road"][1], 5.0)
	await _to_black(1.0, 1.4)
	tw2.kill()
	road_cam.current = false
	main.player.cam.current = true


# ------------------------------------------------------------------ A3-E3 Refuse

func _refuse() -> void:
	var f: Dictionary = main.flags
	_phase = "ending"
	_free(false)
	var p = main.player
	await p.face(GREAT + Vector3(0, 2.2, 0), 0.8)
	await ui.think(LINES["doors"]["look"])
	_knife_on(false)
	main.play("tap", -4.0, 1.4)
	await ui.think(LINES["doors"]["sheathe"])
	ui.close()
	f["chair_sheathed"] = true
	main.log_line("cathedral", LINES["ledger"]["sheathe"])
	main.play("door", -2.0, 0.6)
	var tw := create_tween().set_parallel(true)
	tw.tween_property(great_l, "rotation:y", -1.5, 3.0)
	tw.tween_property(great_r, "rotation:y", 1.5, 3.0)
	var gb := stages["core"].find_child("great_body", true, false) as StaticBody3D
	if gb:
		gb.collision_layer = 0
	await tw.finished
	await ui.think(LINES["doors"]["nobody"])
	await ui.think(LINES["doors"]["waits"])
	ui.close()
	var tw2 := create_tween()
	tw2.tween_property(p, "position", Vector3(0, p.position.y, GREAT.z + 1.5), 2.5)
	await ui.caption(LINES["refuse"][0], 2.6)
	_fade_snd(_hum, -24.0, 2.0)
	_fade_snd(_choir, -80.0, 2.0)
	# the walk out: the eyeless turn as I pass; the city still works
	_variant = "refuse"
	tyson.visible = false
	ezra.visible = false
	await _go("walk", WALK + Vector3(2.0, 0.1, -1.0), 0.0, 1.2)
	_phase = "walk"
	_free(true)
	main.update_hud()
	if main._selftest:
		_st_walk_out()
	await _wait(func(): return _at_depot(), 600.0)
	_free(false)
	await _to_black(1.0, 1.2)
	for k in ["trailer", "car", "tower"]:
		_card(LINES["cards"][k])
		await _secs(2.6)
	_card_off()
	await _spin_scene()
	await _home_scene()
	_finish("ending_refuse")


## The last report: every card in the ledger, the framing slot, the
## believability bar already full. Whatever he files, it holds.
func _spin_scene() -> void:
	_phase = "spin"
	_spin_fill()
	_spin.visible = true
	await _secs(0.4)
	await ui.think(LINES["spin"]["ask"])
	var choices: Array = LINES["spin"]["choices"]
	var i: int = await ui.choose(choices)
	ui.close()
	i = clampi(i, 0, choices.size() - 1)
	_spin_slot.text = LINES["spin"]["frames"] + ":   " + str(choices[i])
	main.play("keys", -6.0)
	await _secs(0.7)
	_spin_stamp.visible = true
	main.play("slam", -2.0, 1.0)
	await _secs(0.8)
	await ui.say("Turan", LINES["spin"]["turan"])
	ui.close()
	main.flags["final_report"] = str(LINES["spin"]["keys"][i])
	main.log_line("report", "%s: %s" % [LINES["spin"]["log"], choices[i]])
	await _secs(1.0)
	_black.color.a = 1.0
	_spin.visible = false


## 86D. Monica and eyeless Mira at the table. Sit down. The lights steady.
func _home_scene() -> void:
	_show("home")
	_place(HOME + Vector3(-0.3, 0.1, 3.9), 0.0)
	_fade_snd(_hum, -30.0, 1.0)
	await _to_black(0.0, 1.4)
	_phase = "home_in"
	await ui.think(LINES["home"]["enter"])
	await main.player.face(h_mira.global_position + Vector3(0, 0.75, 0), 0.8)
	await ui.say("Mira", LINES["home"]["mira"])
	await main.player.face(h_monica.global_position + Vector3(0, 1.2, 0), 0.8)
	await ui.say("Monica", LINES["home"]["monica"])
	ui.close()
	_phase = "home"
	set_active(h_chair_it, true)
	_home_sat = false
	_free(true)
	main.update_hud()
	if main._selftest:
		get_tree().create_timer(0.6).timeout.connect(func(): _home_sat = true)
	await _wait(func(): return _home_sat, 600.0)
	await get_tree().process_frame
	_free(false)
	var p = main.player
	var seat := HOME + Vector3(-0.5, 0, 0.2) + Vector3(0, 0, 0.95)
	p.seated = true
	p.position = Vector3(seat.x, HOME.y + 0.1, seat.z)
	p.yaw = 0.0
	p.pitch = deg_to_rad(-14.0)
	p.crouch = 0.45
	main.log_line("home", LINES["ledger"]["sit"])
	await _secs(1.0)
	await ui.think(LINES["home"]["sat"])
	ui.close()
	await _secs(2.0)
	await _to_black(1.0, 2.5)
	await ui.caption(LINES["home"]["last"], 3.5)


# ------------------------------------------------------------------ A3-E4 The copy is already here

func _copy_begin() -> void:
	var f: Dictionary = main.flags
	_phase = "ending"
	f["cinematic"] = true
	f["chair_copy"] = true
	main.log_line("chapel", LINES["ledger"]["copy"])
	if _knife and is_instance_valid(_knife) and _knife.visible:
		_knife_drop()
	await ui.think(LINES["copy"]["cut"])
	ui.close()
	_copy_on()
	_phase = "copy_walk"
	_hint_on(LINES["copy"]["walk"])
	_free(true)
	main.update_hud()
	var target := Vector3(0, 0, ALTAR_Z + 0.5)
	if main._selftest:
		_cauto = target
	await _wait(func(): return _near(target, 1.5), 240.0)
	_cauto = Vector3.INF
	_free(false)
	_hint_on("")
	await _look(ALTAR + Vector3(0, 1.0, 0), 0.6)
	main.play("glitch", -6.0, 0.5)
	_burst("murmur", -2.0, 0.5, 1.8)
	await ui.say(LINES["room"], "[b]" + LINES["bow_mimic"] + "[/b]")
	ui.close()
	_phase = "bow"
	main.update_hud()
	Anim.crouch(_cfig)
	_cfig.position.y = -0.45
	await _bow(true)
	await _sit_from_blades(true)


## Third person: the camera behind Carl's own back, his body half a second
## behind the input.
func _copy_on() -> void:
	if _copy:
		return
	var p = main.player
	_cbody = CharacterBody3D.new()
	_cbody.name = "copy"
	_cbody.collision_layer = 0
	_cbody.collision_mask = 1
	var cs := CollisionShape3D.new()
	var cap := CapsuleShape3D.new()
	cap.radius = 0.3
	cap.height = 1.75
	cs.shape = cap
	cs.position.y = 0.875
	_cbody.add_child(cs)
	add_child(_cbody)
	_cbody.global_position = p.global_position
	_cfig = _carl_fig()
	_cbody.add_child(_cfig)
	_ccam = Camera3D.new()
	_ccam.fov = 70.0
	_ccam.near = 0.05
	_ccam.far = 1600.0
	_ccam.cull_mask = p.cam.cull_mask
	add_child(_ccam)
	_cyaw = p.yaw
	_copy = true
	_cbuf.clear()
	_ccam_snap()
	_ccam.current = true
	_knife_on(false)


func _copy_off() -> void:
	if not _copy:
		return
	_copy = false
	_cmove = false
	if _ccam and is_instance_valid(_ccam):
		_ccam.current = false
		_ccam.queue_free()
	if _cbody and is_instance_valid(_cbody):
		_cbody.queue_free()
	_ccam = null
	_cbody = null
	_cfig = null
	main.player.cam.current = true
	main.update_hud()


func _cam_want() -> Vector3:
	return _cbody.global_position + Basis(Vector3.UP, _cyaw) * Vector3(0.45, 2.1, 2.9)


func _ccam_snap() -> void:
	if _ccam == null or _cbody == null:
		return
	_ccam.global_position = _cam_want()
	_ccam.look_at(_cbody.global_position + Vector3(0, 1.45, 0), Vector3.UP)


func _copy_tick(delta: float) -> void:
	if _cbody == null or not is_instance_valid(_cbody):
		return
	_ct += delta
	var mv := Vector2.ZERO
	var turn := 0.0
	var auto := _cauto != Vector3.INF
	if _cmove and not ui.busy:
		mv = Input.get_vector("move_left", "move_right", "move_fwd", "move_back")
		turn = Input.get_axis("turn_right", "turn_left") * 2.2 * delta - _cmouse * 0.0024
		if auto:
			var d := _cauto - _cbody.global_position
			d.y = 0.0
			mv = Vector2.ZERO
			turn = 0.0
			if d.length() > 0.3:
				var want := atan2(-d.x, -d.z)
				turn = clampf(wrapf(want - _cyaw, -PI, PI), -3.0 * delta, 3.0 * delta)
				mv = Vector2(0, -1)
	_cmouse = 0.0
	var use_mv := Vector2.ZERO
	var use_turn := 0.0
	if auto:
		use_mv = mv
		use_turn = turn
	else:
		# half a second behind the wanting
		_cbuf.append([_ct, mv, turn])
		while not _cbuf.is_empty() and float(_cbuf[0][0]) <= _ct - 0.5:
			var e: Array = _cbuf.pop_front()
			use_mv = e[1]
			use_turn += float(e[2])
	if _cmove:
		_cyaw += use_turn
		var dir := Basis(Vector3.UP, _cyaw) * Vector3(use_mv.x, 0, use_mv.y) * 2.6
		_cbody.velocity.x = dir.x
		_cbody.velocity.z = dir.z
		if not _cbody.is_on_floor():
			_cbody.velocity.y -= 18.0 * delta
		_cbody.move_and_slide()
		var sp := Vector2(_cbody.velocity.x, _cbody.velocity.z).length()
		if sp > 0.3:
			Anim.walk(_cfig, _ct, sp / 2.6)
		else:
			Anim.idle(_cfig, _ct)
	_cbody.rotation.y = _cyaw
	if not _cfixed and _ccam:
		_ccam.global_position = _ccam.global_position.lerp(_cam_want(), minf(1.0, delta * 4.0))
		_ccam.look_at(_cbody.global_position + Vector3(0, 1.45, 0), Vector3.UP)
	ui.status.text = LINES["copy"]["hud"]


func _unhandled_input(e: InputEvent) -> void:
	if e is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if _copy:
			_cmouse += (e as InputEventMouseMotion).relative.x
		if _phase == "grid":
			_grid_mouse += (e as InputEventMouseMotion).relative.y


# ------------------------------------------------------------------ the end of it

func _finish(flag: String) -> void:
	var f: Dictionary = main.flags
	for k in ["ending_sit", "ending_burn", "ending_refuse", "ending_copy"]:
		f.erase(k)
	f[flag] = true
	_ending = flag
	main.log_line("ending", flag)
	_copy_off()
	_grid.visible = false
	_spin.visible = false
	_hint_on("")
	f.erase("cinematic")
	_phase = "done"
	_busy = false
	main.update_hud()
	if not main._selftest:
		main.player.crouch = 0.0
		main.player.seated = false
		main.load_level("Epilogue")


# ------------------------------------------------------------------ the frame loop

func tick(delta: float) -> void:
	if main == null or stages.is_empty() or main.player == null:
		return
	if not _frozen:
		_clock += delta
	if screen_mat:
		screen_mat.set_shader_parameter("t", _clock)
	if hole_mat:
		hole_mat.set_shader_parameter("t", _clock)
	match _phase:
		"charge":
			_tick_charge(delta)
		"choice":
			_tick_choice(delta)
		"climb":
			_tick_climb(delta)
		"walk":
			_tick_walk()
	if not _frozen:
		match stage:
			"core":
				_tick_core()
			"tower":
				_tick_tower()
			"home":
				_tick_home()
	for fg in _anim_walk:
		if is_instance_valid(fg):
			Anim.walk(fg, _clock, 1.0)
	if _copy:
		_copy_tick(delta)
	_light_t += delta
	if _light_t > 0.3:
		_light_t = 0.0
		_cull_lights()


## The run at the Prophet: hold, and the hum swells.
func _tick_charge(delta: float) -> void:
	if _busy or ui.busy:
		return
	var p = main.player
	var span := KNEEL_AT.z - TEN_FEET_Z
	var k := clampf((KNEEL_AT.z - float(p.position.z)) / span, 0.0, 1.0)
	if _held():
		_charge_t += delta
		var target := Vector3(PROPHET_AT.x * 0.25, p.position.y, TEN_FEET_Z)
		var to: Vector3 = target - p.position
		to.y = 0.0
		if to.length() > 0.02:
			p.position += to.normalized() * minf(to.length(), 4.6 * delta)
		var d: Vector3 = PROPHET_AT - p.position
		p.yaw = lerp_angle(p.yaw, atan2(-d.x, -d.z), minf(1.0, delta * 3.0))
		p.pitch = lerpf(p.pitch, 0.0, minf(1.0, delta * 2.0))
		p.shake(0.12 + k * 0.2)
		if _knife:
			_knife.position = _knife.position.lerp(Vector3(0.18, -0.08, -0.5), minf(1.0, delta * 6.0))
			_knife.rotation.x = lerpf(_knife.rotation.x, 1.35, minf(1.0, delta * 6.0))
		if not _said.has("charge"):
			_said["charge"] = true
			_hint_on("")
			_cap(LINES["charge_cap"], 2.6)
		if k > 0.45 and not _said.has("swell"):
			_said["swell"] = true
			_cap(LINES["swell_cap"], 3.0)
	elif _knife:
		_knife.position = _knife.position.lerp(Vector3(0.24, -0.24, -0.42), minf(1.0, delta * 4.0))
		_knife.rotation.x = lerpf(_knife.rotation.x, 0.9, minf(1.0, delta * 4.0))
	if _hum:
		_hum.volume_db = lerpf(-16.0, -2.0, k)
	if _choir:
		_choir.volume_db = lerpf(-12.0, 0.0, k)
	if float(p.position.z) <= TEN_FEET_Z + 0.3:
		_mira_speaks()


## The choice, made by acting: hold, the altar, the valve, the doors.
func _tick_choice(delta: float) -> void:
	if _busy or ui.busy:
		return
	var p = main.player
	var pos: Vector3 = p.position
	var in_chapel := pos.z < DOOR_Z
	if in_chapel and _held():
		_hold += delta
		_bar_bg.visible = true
		_bar.anchor_right = clampf(_hold / 5.0, 0.0, 1.0)
		p.shake(0.05 + _hold * 0.04)
		if _knife:
			_knife.position = _knife.position.lerp(Vector3(0.18, -0.08, -0.5), minf(1.0, delta * 6.0))
		if _hum:
			_hum.volume_db = lerpf(-14.0, 0.0, _hold / 5.0)
		if _hold >= 5.0:
			_choose("attack")
		return
	if _hold > 0.0:
		_hold = maxf(0.0, _hold - delta * 2.0)
		_bar.anchor_right = clampf(_hold / 5.0, 0.0, 1.0)
		if _hold <= 0.0:
			_bar_bg.visible = false
			if _hum:
				_hum.volume_db = -14.0
	if _knife:
		_knife.position = _knife.position.lerp(Vector3(0.24, -0.3, -0.4), minf(1.0, delta * 3.0))
	if pos.z < ALTAR_Z + 0.6 and absf(pos.x) < 3.2:
		_choose("drop")
		return
	if pos.z > DOOR_Z + 0.5 and not _turned_away and (_burn_ok() or _refuse_ok()):
		_turned_away = true
		turn_to(prophet, prophet.global_position + Vector3(0, 0, -5), 1.2)
		_cap(LINES["turn_away_who"] + ":   " + LINES["turn_away"], 3.0)


## Mira runs ahead up the stair, never more than a few metres; the floors
## speak as he reaches them.
func _tick_climb(delta: float) -> void:
	var w := _walker().global_position
	var best := 0
	var bd := 1e12
	for i in route.size():
		var dd := w.distance_squared_to(route[i])
		if dd < bd:
			bd = dd
			best = i
	var total: float = route_d[route_d.size() - 1]
	var goal := minf(float(route_d[best]) + 8.0, total)
	var moving := false
	if goal > _prog:
		_prog = move_toward(_prog, goal, 5.2 * delta)
		moving = true
	var gp := _route_at(_prog)
	var ahead := _route_at(_prog + 0.6)
	guide.global_position = gp
	var dir := ahead - gp
	dir.y = 0.0
	if moving and dir.length() > 0.01:
		guide.rotation.y = atan2(-dir.x, -dir.z)
		Anim.walk(guide, _clock, 1.7)
	else:
		Anim.idle(guide, _clock)
		Anim.look(guide, w + Vector3(0, 1.4, 0), 1.0, 0.08)
	var fl := int(floor((w.y + 0.8) / FH))
	if fl >= 1 and fl <= FLOORS and not _said.has("f%d" % fl):
		_said["f%d" % fl] = true
		var rooms: Array = main.tower_rooms
		var id := str(rooms[fl - 1]) if fl - 1 < rooms.size() else "bare"
		var r: Array = LINES["rooms"].get(id, LINES["rooms"]["bare"])
		if str(r[0]) != "":
			_cap(str(r[0]), 1.6)
		_cap(str(r[1]))
		if fl % 2 == 1:
			_cap(LINES["children"])
		else:
			_cap(LINES["strangers"])
			_cap(LINES["chant"], 2.4)
			_burst("chant", -6.0, 1.15, 4.0)
		if fl == 1:
			_cap("CARL:   " + LINES["climb"][1])
		if fl == 3:
			_cap("MIRA:   " + LINES["climb"][2])


## The walk out: the eyeless on the shore sit (Burn) or turn (Refuse).
func _tick_walk() -> void:
	var w := _walker().global_position
	var eye := w + Vector3(0, 1.6, 0)
	for s: Dictionary in shore:
		var fg: Node3D = s["fig"]
		if not s["done"] and w.z < fg.global_position.z + 2.5:
			s["done"] = true
			if not _said.has("shore"):
				_said["shore"] = true
				_cap(LINES["shore_burn"] if _variant == "burn" else LINES["shore_refuse"], 4.0)
			if _variant == "burn":
				Anim.sit(fg, 0.2)
				create_tween().tween_property(fg, "position:y", fg.position.y - 0.42, 0.8)
		if _variant == "refuse" and (s["done"] or w.z < fg.global_position.z + 9.0):
			var d := w - fg.global_position
			fg.rotation.y = lerp_angle(fg.rotation.y, atan2(-d.x, -d.z), 0.06)
			Anim.look(fg, eye, 1.0, 0.1)
	if w.z < WALK.z - 200.0 and not _said.has("dawn"):
		_said["dawn"] = true
		_env("dawn")


func _tick_core() -> void:
	var cam_p: Vector3 = main.player.cam.global_position if not _copy else _cbody.global_position + Vector3(0, 1.6, 0)
	for c: Dictionary in congregation:
		if c["sat"]:
			continue
		var fg: Node3D = c["fig"]
		Anim.idle(fg, _clock, float(c["ph"]))
		Anim.look(fg, cam_p, 0.7, 0.04)
	for fg: Node3D in [prophet, eren, monica]:
		if fg.visible:
			Anim.idle(fg, _clock, fg.position.x)
	if not main.flags.has("chair_valve"):
		for m: StandardMaterial3D in cable_mats:
			m.emission_energy_multiplier = 0.9 + 0.6 * sin(_clock * 2.2)


func _tick_tower() -> void:
	for c: Array in crowds:
		var fg: Node3D = c[0]
		if not fg.is_visible_in_tree():
			continue
		if c[1] == "children":
			Anim.idle(fg, _clock, float(c[2]))
		else:
			var arms: Array = fg.get_meta("arms", [])
			var clap := sin(_clock * 9.0 + float(c[2]))
			for i in arms.size():
				var a: Node3D = arms[i]
				a.rotation.x = -1.15
				a.rotation.z = (0.35 + 0.3 * clap) * (-1.0 if i == 0 else 1.0)
	for c: Array in councils:
		var fg: Node3D = c[0]
		fg.position.y = float(c[1]) + sin(_clock * 0.8 + float(c[2])) * 0.15


func _tick_home() -> void:
	var eye: Vector3 = main.player.cam.global_position
	Anim.look(h_mira, eye, 1.0, 0.05)
	Anim.look(h_monica, eye, 1.0, 0.05)


# ------------------------------------------------------------------ hooks

func setup_env(_e: Environment, _s: DirectionalLight3D) -> void:
	_env("core")


func interact(node: Object) -> bool:
	var id := str(node.get_meta("id"))
	var L: Dictionary = LINES
	match id:
		"valve":
			if _phase != "choice" or _busy:
				await ui.think(L["valve"]["look"])
			elif main.connection >= 90.0 or _attack_spent:
				await ui.think(L["valve"]["no_conn"])
			elif _given_tyson():
				await ui.think(L["valve"]["no_tyson"])
			else:
				_choose("burn")
			return true
		"great_doors":
			if _phase != "choice" or _busy:
				await ui.think(L["doors"]["look"])
			elif not _refuse_ok():
				await ui.think(L["doors"]["no"])
			else:
				_choose("refuse")
			return true
		"desk":
			await ui.think(L["desk"])
			return true
		"throne":
			if _phase == "throne":
				_sat = true
			else:
				await ui.think(L["look"]["done"])
			return true
		"h_chair":
			if _phase == "home":
				_home_sat = true
			else:
				await ui.think(L["home"]["chair"] + ".")
			return true
		"mira_home":
			await ui.think(L["home"]["look_mira"])
			return true
		"monica_home":
			await ui.think(L["home"]["look_monica"])
			return true
		"fridge":
			await ui.think(L["home"]["fridge"] if "drawing" in main.traded else L["home"]["fridge_drawing"])
			return true
		"window":
			await ui.think(L["home"]["window"])
			return true
		"prophet", "eren", "monica", "mira", "congregation", "tyson", "ezra":
			await ui.think(L["look"][id])
			return true
	return false


func objective() -> String:
	if _copy:
		var c: Dictionary = LINES["copy"]
		match _phase:
			"copy_walk":
				return c["walk"]
			"bow":
				return c["bow"]
			"void", "climb":
				return c["climb"]
			"roof", "sit":
				return c["sit"]
			"woods":
				return c["woods"]
			"grid":
				return c["city"]
		return ""
	var o: Dictionary = LINES["objective"]
	match _phase:
		"charge":
			return o["charge"]
		"bow":
			return o["bow"]
		"void":
			return o["void"]
		"climb":
			return o["climb"]
		"throne":
			return o["roof"]
		"walk":
			return o["walk_refuse"] if _variant == "refuse" else o["walk"]
		"home":
			return o["home"]
	return ""


func phone() -> String:
	return "[b]PSYON[/b]\n\n" + LINES["phone"]


func scan_people() -> Array:
	var out := []
	var sc: Dictionary = LINES["scan"]
	if stage == "core":
		out.append([prophet, sc["prophet"] if prophet.visible else sc["prophet_gone"]])
		out.append([eren, sc["eren"]])
		out.append([monica, sc["monica"]])
		out.append([mira_body, sc["mira"]])
	elif stage == "walk":
		if tyson.visible:
			out.append([tyson, sc["tyson"]])
		if ezra.visible:
			out.append([ezra, sc["ezra"]])
	elif stage == "home":
		out.append([h_monica, sc["monica"]])
	return out


func _exit_tree() -> void:
	if _knife and is_instance_valid(_knife):
		_knife.queue_free()
	if main and main.player:
		main.player.crouch = 0.0
		main.player.seated = false
		main.player.cam.current = true


# ------------------------------------------------------------------ shots (dev args)

## --stage=mira|copy|burned|tower|roof|real|woods|walk|depot|home|road|void|grid|spin
## (--rooms=focus,calm for the tower), placed at a good default unless --at.
func apply_args(a: Dictionary) -> void:
	var st := str(a.get("stage", ""))
	if a.has("rooms"):
		main.tower_rooms = Array(str(a["rooms"]).split(","))
		_rebuild_tower()
	_frozen = false
	_clock = 3.0
	var at_given := a.has("at")
	var p = main.player
	var put := func(at: Vector3, yaw: float, pitch: float):
		if not at_given:
			p.position = at
			p.yaw = deg_to_rad(yaw)
			p.rotation.y = p.yaw
			p.pitch = deg_to_rad(pitch)
	match st:
		"mira":
			screen_mat.set_shader_parameter("mira", 1.0)
			screen_mat.set_shader_parameter("copy", 0.35)
			put.call(Vector3(0.3, 0.1, TEN_FEET_Z + 0.4), 0.0, 14.0)
			_knife_on(true)
		"copy":
			put.call(Vector3(0, 0.1, -9.0), 0.0, 0.0)
			_copy_on()
			_cmove = true
		"burned":
			_silence()
			vein_mat.albedo_color = Color(0.42, 0.42, 0.4)
			for m: StandardMaterial3D in cable_mats:
				m.emission_energy_multiplier = 0.0
			for c: Dictionary in congregation:
				c["sat"] = true
				Anim.sit(c["fig"], 0.15)
				(c["fig"] as Node3D).position.y = -0.4
			screen_mat.set_shader_parameter("dark", 1.0)
			screen_light.light_energy = 0.0
			put.call(Vector3(0, 0.1, -1.8), 0.0, 6.0)
		"valve":
			put.call(VALVE + Vector3(-3.2, 0.1, 1.6), -70.0, 8.0)
			_ledger_text.text = "[b]LEDGER[/b]\n\n[color=#ff5a4a][b]%s[/b][/color]" % LINES["valve"]["ledger"]
			_ledger_panel.visible = true
		"tower":
			_show("tower")
			put.call(_tp(PI * 1.5, R_MID, FH + 0.1), 90.0, 4.0)
			guide.visible = true
			guide.global_position = _tp(PI * 1.5 + 0.5, R_MID, FH)
			turn_to(guide, p.position)
		"roof", "real", "chair":
			_show("tower")
			_env("roof")
			put.call(_tp(PI * 1.5 + 0.14, R_OUT - 2.4 if st == "roof" else R_OUT - 0.95, ROOF_Y + 0.1), 8.0, -2.0 if st == "roof" else -23.0)
			guide.visible = st == "roof"
			guide.global_position = _tp(PI * 1.5, R_OUT - 0.6, ROOF_Y)
			guide.rotation.y = atan2(-cos(PI * 1.5), -sin(PI * 1.5))
			if st != "roof":
				fairy.visible = false
				real.visible = true
				_env("real")
			if st == "chair":
				var cp := _tp(PI * 1.5 - 0.24, 10.0, ROOF_Y)
				var eye := _tp(PI * 1.5 - 0.24, 6.3, ROOF_Y + 0.1)
				var d := cp - eye
				put.call(eye, rad_to_deg(atan2(-d.x, -d.z)), -6.0)
		"woods":
			_show("woods")
			put.call(WOODS + Vector3(0.9, 0.1, 4.0), 0.0, -4.0)
		"walk":
			_show("walk")
			put.call(WALK + Vector3(2.0, 0.1, -3.0), 8.0, 0.0)
		"depot":
			_show("walk")
			_env("dawn")
			put.call(WALK + Vector3(0.5, DEPOT_Y + 0.1, -221.0), 0.0, 0.0)
		"home":
			_show("home")
			put.call(HOME + Vector3(-0.3, 0.1, 3.4), 0.0, -10.0)
		"road":
			_show("road")
			road_cam.current = true
			road_cam.global_position = ROAD + Vector3(-4.5, 1.3, -40.0)
			road_cam.look_at(ROAD + Vector3(10.0, 40.0, 500.0), Vector3.UP)
		"void":
			_show("void")
			put.call(VOID + Vector3(0, 0.1, -2.0), 0.0, 0.0)
			guide.visible = true
			guide.global_position = VOID + Vector3(0, 0, -15.3)
			guide.rotation.y = PI
		"grid":
			for k in stages:
				(stages[k] as Node3D).visible = false
			_env("grid")
			_grid.visible = true
			_grid_sel = 3
			_grid_tick(4.0)
			_grid_line.text = LINES["grid"]["hold"] + "     " + LINES["grid"]["hold_keys"]
		"spin":
			if main.ledger.is_empty():
				for k in ["grief", "mira", "drop", "bow", "sheathe"]:
					main.log_line("chapel", LINES["ledger"][k])
			_spin_fill()
			_spin.visible = true
	_cull_lights()


# ------------------------------------------------------------------ selftest

func _st_walk_to(to: Vector3, secs: float) -> void:
	var from := _walker().global_position
	var n := maxi(2, int(secs * 20.0))
	for i in range(1, n + 1):
		if not is_inside_tree():
			return
		await get_tree().process_frame
		_teleport(from.lerp(to, float(i) / n))


func _st_climb() -> void:
	var total: float = route_d[route_d.size() - 1]
	var d := 0.0
	while d < total and _phase == "climb" and is_inside_tree():
		d += 3.0
		_teleport(_route_at(d) + Vector3(0, 0.15, 0))
		await get_tree().process_frame
		await get_tree().process_frame
	if _phase == "climb":
		_teleport(_tp(PI * 1.5, R_MID, ROOF_Y + 0.15))


func _st_walk_out() -> void:
	var pts := [WALK + Vector3(1.0, 0.1, -88.0), WALK + Vector3(0.0, 0.1, -200.0), WALK + Vector3(0.0, DEPOT_Y + 0.2, -219.0), WALK + Vector3(0.0, DEPOT_Y + 0.2, -221.5)]
	for pt: Vector3 in pts:
		if _phase != "walk":
			return
		await _st_walk_to(pt, 1.2)


## Back to the chapel at the choice, the room as it was.
func _reset_chapel() -> void:
	_copy_off()
	_busy = false
	_phase = ""
	_cfixed = false
	_cauto = Vector3.INF
	_anim_walk.clear()
	_capq.clear()
	var f: Dictionary = main.flags
	for k in ["chair_attacked", "chair_dropped", "chair_bowed", "chair_valve", "chair_sheathed", "chair_copy", "chair_sat", "redrock_kept", "redrock_dark", "redrock_lit", "final_report", "cinematic"]:
		f.erase(k)
	_show("core")
	_black.color.a = 0.0
	_card_off()
	_grid.visible = false
	_credits.visible = false
	_spin.visible = false
	_ledger_panel.visible = false
	_bar_bg.visible = false
	_hint_on("")
	_unprojection(prophet)
	turn_to(prophet, KNEEL_AT)
	for c: Dictionary in congregation:
		var fg: Node3D = c["fig"]
		fg.position = c["home"]
		c["sat"] = false
		_pose_reset(fg)
	for s: Dictionary in shore:
		var fg: Node3D = s["fig"]
		fg.position.y = WALK.y
		fg.rotation.y = float(s["yaw"])
		s["done"] = false
		_pose_reset(fg)
	screen_mat.set_shader_parameter("mira", 0.0)
	screen_mat.set_shader_parameter("copy", 0.0)
	screen_mat.set_shader_parameter("dark", 0.0)
	screen_mat.set_shader_parameter("glitch", 0.0)
	screen_light.light_energy = 2.6
	vein_mat.albedo_color = Color(0.008, 0.008, 0.01)
	vein_mat.roughness = 0.04
	for m: StandardMaterial3D in cable_mats:
		m.emission_energy_multiplier = 1.2
	drips.emitting = false
	hole_mat.set_shader_parameter("collapse", 0.0)
	great_l.rotation.y = 0.0
	great_r.rotation.y = 0.0
	var gb := stages["core"].find_child("great_body", true, false) as StaticBody3D
	if gb:
		gb.collision_layer = 1
	valve_wheel.rotation = Vector3.ZERO
	if _floor_knife:
		_floor_knife.visible = false
	_knife_on(true)
	_said.clear()
	_attack_spent = false
	_turned_away = false
	_hold = 0.0
	_variant = ""
	_sat = false
	_home_sat = false
	_redrock = ""
	_prog = 0.0
	_ending = ""
	set_active(throne_it, false)
	fairy.visible = true
	real.visible = false
	tyson.visible = true
	ezra.visible = true
	road_cam.current = false
	main.player.cam.current = true
	var p = main.player
	p.seated = false
	p.crouch = 0.0
	_place(Vector3(0, 0.1, TEN_FEET_Z + 0.4), 0.0)
	_frozen = false
	if _lull:
		_lull.stop()
	for k in main.amb:
		var ap = main.amb[k]
		if is_instance_valid(ap) and not ap.playing:
			ap.play()
	if _hum:
		_hum.volume_db = -14.0
	if _choir:
		_choir.volume_db = -20.0


func selftest() -> void:
	# Headless on llvmpipe the chapel renders at about 1 fps and every line
	# costs a frame; the test is of the script, so the level is hidden while
	# it runs (it still ticks, collides and plays), as Observatory does.
	visible = false
	mira_vp.render_target_update_mode = SubViewport.UPDATE_DISABLED
	_env("core")
	var retro_on: bool = main.retro.visible
	main.retro.visible = false
	var ov_on: bool = ui.overlay.visible
	ui.overlay.visible = false
	var m = main
	var f: Dictionary = m.flags
	f["mira_dead"] = true
	f["ezra_home"] = true
	m.trust["mira"] = 1
	m.connection = 40.0
	m.pressure = 30.0
	m.given = []
	m.traded = ["photo", "lion"]
	m.tower_rooms = ["focus", "calm", "memory"]
	_rebuild_tower()
	# A3-S6 from the top: the grief, the fire, the run, the screen
	_test_hold = true
	await intro()
	print("ok grief, fire: phase ", _phase)
	await _wait(func(): return _phase == "choice" and not _busy, 180.0)
	print("ok charge -> Mira spoke (herself first: ", int(m.trust["mira"]) >= 1, "), phase ", _phase)
	# the last attack: hold five seconds
	await _wait(func(): return _attack_spent and _phase == "choice" and not _busy, 90.0)
	_test_hold = false
	print("ok attack: C ", int(m.connection), ", burn open ", _burn_ok(), ", refuse open ", _refuse_ok(), ", attacked ", f.has("chair_attacked"))
	# the choice is made on foot: the altar, the valve, the great doors; then
	# the stages each ending walks (all built at once, shown one at a time)
	await check_walk("kneel->altar (sit)", Vector3(0, 0, ALTAR_Z + 0.3), KNEEL_AT, Rect2(), 1.0)
	await check_walk("kneel->valve (burn)", "valve", KNEEL_AT)
	await check_walk("kneel->great_doors (refuse)", "great_doors", KNEEL_AT)
	await check_walk("tower->roof (sit)", _tp(PI * 1.5, R_MID, ROOF_Y), TOWER + Vector3(-4.0, 0.1, 0.0), Rect2(), 1.5)
	await check_walk("shore->depot (burn, refuse)", WALK + Vector3(0.0, DEPOT_Y, -221.5), WALK + Vector3(2.0, 0.1, -1.0), Rect2(), 1.5)
	await check_walk("86D door->chair (refuse)", "h_chair", HOME + Vector3(-0.3, 0.1, 3.9))
	# A3-E1 Sit: drop the knife, walk to the altar (Red Rock held)
	_teleport(Vector3(0, 0.1, ALTAR_Z + 0.3))
	await _wait(func(): return _phase != "choice", 10.0)
	_test_hold = true
	await _wait(func(): return _phase == "done", 1500.0)
	print("ok SIT: ending_sit ", f.has("ending_sit"), ", bowed ", f.has("chair_bowed"), ", sat ", f.has("chair_sat"), ", redrock ", _redrock, ", redrock_lit ", f.has("redrock_lit"))
	# A3-E2 Burn (Ezra home)
	_reset_chapel()
	m.connection = 40.0
	m.given = []
	_choice_begin()
	_test_hold = true
	await m.interact(valve_it)
	await _wait(func(): return _phase == "done", 900.0)
	print("ok BURN: ending_burn ", f.has("ending_burn"), ", valve ", f.has("chair_valve"), ", only one ending ", _one_ending())
	# Burn closed: Tyson given
	_reset_chapel()
	m.given = ["tyson"]
	_choice_begin()
	await m.interact(valve_it)
	await _secs(0.3)
	print("ok burn closed with tyson given: phase ", _phase)
	# Burn begun and let go: back to the choice
	m.given = []
	_test_hold = false
	await m.interact(valve_it)
	await _wait(func(): return _phase == "choice" and not _busy, 90.0)
	print("ok valve let go: phase ", _phase, ", valve ", f.has("chair_valve"))
	# Refuse closed at pressure over 40
	m.pressure = 60.0
	await m.interact(doors_it)
	await _secs(0.3)
	print("ok refuse closed at pressure 60: phase ", _phase)
	# A3-E3 Refuse
	m.pressure = 30.0
	_reset_chapel()
	_choice_begin()
	await m.interact(doors_it)
	await _wait(func(): return _phase == "done", 900.0)
	print("ok REFUSE: ending_refuse ", f.has("ending_refuse"), ", sheathed ", f.has("chair_sheathed"), ", report ", f.get("final_report", ""), ", only one ending ", _one_ending())
	# A3-E4 Copy: Connection 100 at the chapel (Red Rock let go)
	_reset_chapel()
	m.connection = 100.0
	_test_hold = false
	_after_mira()
	await _wait(func(): return _phase == "done", 1500.0)
	print("ok COPY: ending_copy ", f.has("ending_copy"), ", redrock ", _redrock, ", redrock_lit ", f.has("redrock_lit"), ", only one ending ", _one_ending())
	# every examine point, in the room after
	_reset_chapel()
	_phase = "done"
	for it in people_its:
		if is_instance_valid(it):
			set_active(it, true)
	await m.selftest_all_interactables()
	visible = true
	main.retro.visible = retro_on
	ui.overlay.visible = ov_on
	print("ok chair selftest done")


func _one_ending() -> bool:
	var n := 0
	for k in ["ending_sit", "ending_burn", "ending_refuse", "ending_copy"]:
		if main.flags.has(k):
			n += 1
	return n == 1
