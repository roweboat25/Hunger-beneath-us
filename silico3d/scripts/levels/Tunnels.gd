extends "res://scripts/Level.gd"
## Chapter 25: the tunnels. Bible A3-S1 (tier 4; Day 6, 22:00 -> Day 7).
## Book: "We parked three blocks from the old Tunelet tunnel depot. Broken
## drills sat rusting in a graveyard of industrial decay. Across the
## expanse, a gaping hole - black, silent - was carved into the side of the
## mountain." The car (the last save point), then a choice of three ways
## down: the depot's 160-foot mouth at Rail Cut (Emmet's way; the bag is
## here if it was not taken at the trailer), the overpass tunnel mouth in
## Southtown (the camp's glyph footprints; Tyson walks us in at trust +2;
## no eyeless at this mouth), or the Red Rock subway's maintenance stair
## (the shortest, past the alley double). Frames on at the mouth: the
## tunnel becomes a blood-red eye for a second. Then rails, soft dirt, and
## "a deep, metallic ringing ... like an army of mechanical bees". The
## three tunnels meet in a small sandstone hub (a side room off each: the
## cache of offerings, Hameron's seventh log, Forner's frames). The green
## eye and the arrow; the manhole (Turan first, flashlight in her teeth);
## the circular chamber in a green floodlight that "did not fully belong in
## this world"; the frames chime. The possessed doors (Speak: dreamer,
## sleeper, and a door that is a wall with the frames off; hush on the
## speaker calling the eyeless; two eyeless patrol; the hymn ahead is the
## stealth timer). The two doors and their bloody readers; Carl prays (bow
## opens both, filter the right only, anything else costs a round with the
## eyeless); Monica's voice, "Have you learned to remember?"; the lullaby;
## the left hall green, the right a black void; Lynx; Carl follows her in.
##
## Layout (metres). The upper level is y 0. The hub is a 16-sided sandstone
## cavern (r 9) at the origin; the green eye on its north wall, the manhole
## at (0, -5). Three bores (7 wide, 6 high, rails on the north/west side):
## east to the Rail Cut funnel (x 90..125) and the cliff face at x 125, the
## depot yard x 125..215, the street and the car at x 212; south to the
## Southtown portal at z 85, the overpass camp z 85..150; west to the Red
## Rock maintenance stair (x -36..-48, up to y 6), the subway platform
## (x -48..-92, y 6), the subway stair up to the plaza (y 12, x -100..-175).
## Side rooms: the offerings cache (50, -6.5), the control room with the
## terminal (6.5, 45), Forner's closet (-26, 6.5). The lower level is y -14,
## under the hub: the green chamber (r 9 at z -5, the ladder from the
## manhole), the corridor north (door A at z -26, the gallery z -26..-50
## with the speaker and the eye-layer door C, door B at z -50), the two-doors
## room (r 7 at z -69), the doors in its north wall at x -2.4 (left, the
## green hall) and +2.4 (right, the void).
##
## Flags read: broadcast_seen, ev_knife, ev_flashlight, warned_lynx,
## lynx_has_drive, rr_double_* (Red Rock), main.trust lynx / tyson / emmet,
## main.lexicon. Flags set: tu_route (rc | st | rr), tu_frames_on, tu_mouth,
## tu_ringing, tu_eye, tu_descended, tu_chamber, tu_door_a, tu_door_b,
## tu_door_c_tried, tu_hushed, tu_hymn, tu_doors_seen, tu_prayed (bow |
## filter), tu_lynx (plea | betrayal | voice), tu_cache, tu_log7,
## tu_forner, tu_double, tu_touched, ev_knife / ev_flashlight (if the bag
## is taken here), ev_offerings, ev_hameron_log_7, ev_forner_frames,
## two_doors_done. Next: BronzeHands. Hooks for later systems: metas
## "eyeless", "cultist", "hackable" (the speaker, the readers, the
## terminal), "route" (the three mouths, the side rooms), "guard".

const CarS := preload("res://scripts/Car.gd")

## Every line in the level, keyed by beat and line (bible A3-S1; the
## verbatim lines are the book's, ch.25; "(game)" lines are new).
const LINES := {
	"cards": {
		"chapter": "[b]CHAPTER 25[/b]\n\n[color=#aaaaaa]The tunnels\nDay 6, 22:00  -  three blocks from the Tunelet depot, Rail Cut[/color]",
		"drive_st": "Day 6, 22:20  -  Southtown, under the overpass",
		"drive_rr": "Day 6, 22:15  -  Red Rock Plaza",
		"day7": "Day 7, 00:04  -  Glitch Day",
		"end": "[color=#aaaaaa]The door slammed behind, ushering me into an obsidian haze.[/color]",
	},
	"intro": {
		"think": "There was no vomit, no bile, no tears left to give.",
		"think_2": "I couldn't afford grief. I couldn't afford rage. Not now. Not with everything on the line. Emotion was a liability. One slip, and everything would fall.",
		"roads": "The roads were eerily empty. An impending birth of a god has a way of keeping citizens indoors.",
		"parked": "We parked three blocks from the old Tunelet tunnel depot. Broken drills sat rusting in a graveyard of industrial decay. Across the expanse, a gaping hole - black, silent - was carved into the side of the mountain.",
		"way_in": "That was our way in. Or one of them. (game) Emmet had three on his map: the depot, the overpass mouth in Southtown, the maintenance stair under Red Rock.",
		"silence": "We didn't speak in the car. No one wanted to vocalize what we were walking into. The silence wasn't awkward - it was sacred, funereal. We were heading to war.",
		"lynx_car": "Lynx's car was already at the depot gate, three blocks down. Empty, the driver's door open, the seat cold. She'd gone ahead alone.",
		"log": "Day 6, 22:00: the car, three blocks from the Tunelet depot at Rail Cut",
	},
	"bag": {
		"emmet": "We got this, Carl. Don't worry - we're going to save her.",
		"think": "He handed me a black utility bag, heavier than I expected. Inside was a large tactical flashlight - brighter than the anemic one built into the frames - a few protein bars, water, and a massive Bowie knife, its blade clean and gleaming.",
		"emmet_2": "The knife's just in case a cultist tries to stop us. Don't you wish guns weren't outlawed?",
		"carl": "Had that thought about five times this week.",
		"think_2": "I didn't say what I was really thinking: I'm not sure I could stab someone to death. But there wasn't time for hypotheticals.",
		"turan": "Alright. If everyone's got what they need, there's no time to waste.",
		"log": "Emmet's bag: the tactical flashlight, protein bars, water, the Bowie knife.",
	},
	"car": {
		"prompt": "The car",
		"scan": "RENTAL  -  SLA 2241\nlast stop before the depot\nSAVE POINT",
		"ask": "The car. The last place I could still turn around. (game) Three ways down, and Emmet's map open on the dash.",
		"options": ["The depot at Rail Cut. Emmet's way: the big mouth.", "The overpass mouth in Southtown, where the camp walked in.", "The Red Rock subway, the maintenance stair. The shortest."],
		"tyson_opt": "The overpass mouth in Southtown. Tyson said he'd be waiting.",
		"emmet_rc": "The depot, then. The old TBM bore. If it's still open anywhere, it's open there.",
		"emmet_st": "Southtown. The access under the overpass. It comes out on the same line.",
		"emmet_rr": "Red Rock. The subway stair drops straight onto the Tunelet layer. Quickest. Busiest.",
		"after": "The car. Lynx had said it: if we got separated, we meet back here.",
		"after_alone": "The car. The rental smelled of Turan's coffee. Nobody was coming back to it tonight.",
		"lynx_car_prompt": "Lynx's car",
		"lynx_car": "Her car, at the depot gate. Keys in it. A protein-bar wrapper on the passenger seat and her badge on the dash, left behind on purpose. (game)",
	},
	"frames": {
		"buzz": "The hairs on the back of my neck pulsed, standing upright. My frames buzzed violently in my pocket. I remembered Hameron's words: You'll need the frames. They'll guide the way. I slipped them on.",
		"air": "Immediately, the air changed. It vibrated with a static charge, faint and pervasive, the tang of ozone coating my throat. We were close. I could feel it.",
		"toast": "The frames buzz in your pocket.  G puts them on.",
		"off_toast": "Eyeless: frames on, they turn to you and walk. Frames off, you are not there.",
	},
	"rc": {
		"sign": "TUNELET. KEEP OFF THE TRACKS. Under it, older: PSYONIC INTEGRATIONS. SAFE STREETS FOR SILICO. Under that, two rings.",
		"drills": "The drills. Cutterheads the size of a house, tipped over in the gravel like dropped coins, their teeth rusted to stubs. Tunelet had bored the mountain with them and then left them where they stopped.",
		"depot": "TUNELET DEPOT 2. A shed of corrugated tin with its shutter half up and its lights dead. Inside, crew lockers with the names peeled off and a calendar still on the month the company folded.",
		"rat": "A rat on the rail, facing the mouth. It didn't run. It was listening to something I couldn't hear yet.",
		"wide": "As we approached the tunnel, the hole widened like a yawning mouth. It was vast - at least 160 feet across, according to the measurement overlay in my glasses.",
		"wide_2": "I marveled at the audacity of man to blast through mountain, and how even that feat felt minuscule compared to what we were walking into.",
		"overlay": "OVERLAY  //  BORE  160 FT  //  TUNELET TBM-2  //  DECOMMISSIONED",
		"eyeless": "Three of them stood in the mouth, spaced like the stones of a gate, chins up, facing in. Healed sockets. They breathed in time with each other.",
	},
	"st": {
		"arrive": "Southtown. Beneath the overpass, the encampment, utterly deserted. Tattered plastic tarps flapped listlessly. Scorched barrel stoves lay like fallen monoliths. Nobody had come back.",
		"footprints_off": "Dust, ash, a bootprint or two. With the frames off, the ground was just the ground.",
		"footprints": "With the frames on, the ground lit up. Two rings at every step, hundreds of steps, all of them walking the same way: out from under the deck and into the tunnel mouth.",
		"footprints_2": "Forty people had got up one night and walked into the hill in single file, and not one of them had turned round. No eyeless at this mouth. The camp had gone in and stayed in.",
		"layers": "Layers of paint on the pier. The newest rings on top; underneath, older rings; under those, rings in a hand that had been dead for twenty years. The same two circles all the way down.",
		"drain": "A storm drain. Warm air came up out of it, and under the traffic noise that wasn't there tonight, something like a chant.",
		"portal": "TUNELET  -  TBM ACCESS 3  -  NO ENTRY. The bars were still there. The chain wasn't.",
		"chained": "TUNELET  -  TBM ACCESS 3  -  NO ENTRY. Chained since before Lynx was hired.",
		"cut": "Emmet had bolt cutters in the bag, because of course he did. The chain went with one bite and lay in the dust like something dead.",
		"tyson_1": "Carl. I told you. The beast beneath the waves. You're going down to it.",
		"tyson_2": "I've had a key to this gate for two years. I never once used it. Tonight I don't think it'll matter.",
		"tyson_3": "Somebody has to be up here when you come back. If you come back. I'll keep the fire going.",
		"tyson_scan": "CLERIF, TYSON (45)\nUNREGISTERED - 2 YEARS\nformerly: SALTECH EDUCATOR",
		"tyson_again": "He fed the barrel another slat and didn't look at the tunnel. He hadn't once.",
	},
	"rr": {
		"arrive": "Red Rock Plaza, near midnight. The casino screens ran to nobody. The subway steps went down under a sign with a red R, and the stair beyond them, the one with no sign at all, went further.",
		"double": "I saw a man stare at me from behind an alley, his eyes wide and full of glee.",
		"double_named": "The same man as before. He mouthed my name, the way he had the last time, half a second ahead of me thinking it.",
		"double_bowed": "The same man as before. He bowed first, this time.",
		"double_opts": ["Keep walking.", "Look at him.", "Bow."],
		"double_walk": "I kept walking. I could feel him keep pace on the other side of the glass of the frames, the whole length of the plaza.",
		"double_look": "His mouth made a word with mine, half a second late, like an echo that had learned to lie. Then the alley was empty.",
		"double_bow": "I bowed. I don't know why. When I straightened, the alley was empty, and the frames said THANK YOU.",
		"double_off": "An alley. Something breathed in its mouth, slow, the way I breathe when I'm trying not to wake the kids. With the frames off there was nobody to see.",
		"station": "RED ROCK. The platform's lights ran on a backup that hummed. A train stood at the platform with its doors open and its seats empty, going nowhere.",
		"stair": "MAINTENANCE  -  TUNELET INTERCHANGE  -  AUTHORIZED PERSONNEL. The door was propped with a ring of sticks.",
		"eyeless": "Two on the platform, facing the maintenance door, as if they were waiting for a train that ran the other way.",
	},
	"mouth": {
		"eye": "Suddenly, the frames glitched. The tunnel vanished - and in its place, a giant blood-red eye blinked into existence.",
		"calm": "I didn't flinch. I expected this. The tricks wouldn't work on me anymore.",
		"lynx": "If we get separated in there, we meet back at the car. No one goes home unless we all do.",
		"lynx_think": "Her voice trembled - not with weakness, but with restraint. She was scared. I could hear it. We all were.",
		"party": "Our little rebellion looked pitiful now. Turan stared blankly into the sky, her pupils wide and unfocused. Emmet clenched his fists until his knuckles cracked. For a moment, I wondered why I wasn't like them.",
		"peace": "But this was the first time since it all began that I knew what I had to do. I saw the path clearly. There was a kind of peace in that.",
		"reply": ["I won't leave without you. But I'm not stopping until this ends. One way or another.", "Say nothing."],
		"nod": "She nodded, lips pressed tight.",
		"quiet": "She looked at me for a long second, and then at the dark, and didn't ask again.",
		"cross": "We checked our gear, turned on our flashlights, and crossed the threshold. The tunnel swallowed us whole.",
		"spa": "It reminded me of the Spa. The initiation. The descent. Only this time, there was no fear in my bones - only fire.",
		"need_frames": "The frames buzzed in my pocket again, harder. Hameron's voice: They'll guide the way.",
		"log": "Frames on at the mouth: the tunnel became a blood-red eye for a second. Expected now.",
	},
	"ring": {
		"think": "The darkness inside was complete. No light beyond our beams. A deep, metallic ringing echoed through the sandstone walls like an army of mechanical bees humming behind the veil.",
		"turan": "What the hell is that?",
		"think_2": "Turan whispered, sweeping her flashlight across the walls. Nothing but layered orange rock and old rail lines.",
		"emmet": "Sounds like machinery. Could be vibrations coming through the track... but it's far off. Distant. Doesn't matter. We press on.",
		"hq": "Psyonic HQ lay at least two to three miles ahead - depending on how direct the tunnel path remained.",
		"rails": "We kept to the right of the rusted tracks. No trains had passed through since Tunelet shut down, but the rails still carried a ghostly weight, like they remembered the lives they'd once ferried.",
		"dirt": "The dirt underfoot was soft and pliant, like wet sand at low tide. Each step left a silent imprint. Even a whisper felt loud here.",
		"watcher": "A man between the rails, facing up the tunnel, humming. He didn't turn. If a train had come through he'd have let it, and I had the feeling one had.",
	},
	"eye": {
		"lynx": "Check this out.",
		"think": "A symbol. A large green eye painted on the wall, vivid even under years of dust. Below it, a crude arrow pointing down... toward a corroded manhole cover.",
		"flare": "My glasses flared to life, unprompted, and drew a ring round the cover.",
		"carl": "The Cult. They left breadcrumbs. They want us to go this way.",
		"emmet": "Why the hell would we follow them? Could be a trap.",
		"carl_2": "Hameron told me the frames would lead me. This is what they're doing.",
		"lynx_2": "And how do we know Hameron's not compromised? He's been around this thing longer than anyone. What if it got to him?",
		"emmet_2": "And how do we know Hameron's not compromised? He's been around this thing longer than anyone.",
		"carl_3": "He wanted it imprisoned. He didn't have to help us. If he was a fanatic, why hide at Cognizo?",
		"charge": "Even saying the word Hypnogogue sent a strange charge into the air. The others felt it too.",
		"turan": "We don't have another lead, and we're running out of time. This is an old maintenance shaft. I'm going in.",
		"drive": "Lynx. The drive. Hameron's drive. (game)",
		"drive_lynx": "She held it a second longer than she needed to, then put it in my hand. \"I was going to give it back.\"",
		"examine": "The eye. Green paint, dripped, older than the dust on it. Whoever painted it had stood on something to reach the top lid.",
		"log": "The hub under Rail Cut: a green eye painted on the sandstone, an arrow down to a manhole.",
	},
	"manhole": {
		"prompt": "The manhole",
		"scan": "TUNELET MAINT. SHAFT 7\ndepth: 14 m\nchevron: DOWN",
		"early": "A manhole cover, corroded green at the rim. TUNELET MAINT. SHAFT 7. It was cold to the touch, and under the cold, a hum.",
		"think": "She knelt beside the manhole and, with effort, slid it open. A muted green glow rose from below. Inside, a rusted metal ladder spiraled downward.",
		"order": "Turan descended first, flashlight clenched between her teeth. Then Lynx. Then Emmet. I went last.",
		"order_alone": "Turan descended first, flashlight clenched between her teeth. Then Emmet. I went last.",
		"climb": "As I grabbed the first rung, my mind went silent. Crystal clear. But the deeper I climbed, the stronger the stench grew - like industrial disinfectant layered over burning hair and blood.",
		"ground": "I hit the ground.",
		"up": "The ladder, back up to the hub. Fourteen metres of rust. Up there were the three ways out. Down here was the only way on.",
	},
	"chamber": {
		"think": "The chamber was vast. A circular room, lined with dim green floodlights casting an alien twilight across every surface. The light bent strangely - like it didn't fully belong in this world.",
		"think_2": "Shadows pooled in the contours of my teammates' faces, exaggerating their features into masks of fear, doubt, and awe.",
		"chime": "My glasses chimed again.",
		"msg": "Those who walk the path will be tested.\nIt watches your footsteps closely.\nContinue, and learn God's true name.\nCOMMUNION: zero to one. One to two.",
		"breath": "The breathing in my frames returned, and I thought I saw something out of the corner of my eye, but it faded as I moved my head.",
		"bury": "I buried my fear. There was only one direction to go. Forward.",
		"flood": "A floodlight in a cage, Tunelet stencil on the housing. The light that came out of it was a green I had never seen in any screen, any sign, any sky. It didn't light things so much as find them.",
		"log": "Under the hub: a circular chamber in green floodlight. The frames: COMMUNION: zero to one. One to two.",
	},
	"corridor": {
		"narrow": "We proceeded silently, and we followed the dull green down a narrow corridor with no end.",
		"lynx_gone": "I looked back. Turan. Emmet. No Lynx. Her flashlight lay in the dirt by the door, still on, pointing at the wall. Nobody had heard her go.",
		"door_a": "A steel door across the corridor. No handle. A grille at mouth height, and behind the grille, breathing.",
		"door_a_eye": "With the frames on, words came up on the steel in the font from Dufredy's laptop: WELCOME, DREAMER.",
		"door_b": "A second door, older, with a Tunelet number half under the rust. The grille in it hummed one note.",
		"door_b_eye": "The frames lettered it in red: GATHER, SLEEPERS. GATHER.",
		"door_c": "Stone. The frames had drawn a door here, and the hand found sandstone.",
		"door_c_eye": "A door in the east wall, ringed in red, that the frames insisted on. Its grille breathed when I breathed.",
		"door_c_none": "I said it. The door took the word and gave nothing back. It wasn't a door. It was a wall, wearing one for me.",
		"speak_prompt": "Speak",
		"say_nothing": "Say nothing",
		"hum": "Hum",
		"right": "The word left my mouth and the door took it. Bolts drew back somewhere inside the metal, one after another, a long way down.",
		"wrong": "The grille breathed in. The door stayed shut, and somewhere behind us, something turned its head.",
		"silent": "I said nothing. The door said nothing back.",
		"open": "Open. Beyond it, more of the dull green.",
		"round_toast": "A wrong word. It heard.",
		"wrong_why": "the wrong word",
	},
	"speaker": {
		"prompt": "The speaker",
		"scan": "TUNELET PA - ZONE 4\nstatus: BROADCASTING\nsource: (none)",
		"look": "A speaker grille bolted to the sandstone, old Tunelet PA, a green diode lit. A voice came out of it, too slow: Gather, sleeper. Gather. Gather to the walk.",
		"calls": "GATHER, SLEEPER. GATHER TO THE WALK.",
		"no_frames": "Without the frames I had nothing to say to it that it would hear.",
		"hushed": "I said it the way Monica used to say it to Mira through the incubator glass. Hush. The diode went out. The corridor was quieter than it had any right to be.",
		"wrong": "The speaker took the word and played it back, louder, twice, down the corridor. Something answered by walking.",
		"done": "The speaker. Dead diode, and in the grille a smell like a burnt-out fuse.",
		"hush_why": "hush",
	},
	"eyeless": {
		"prompt": "The eyeless",
		"scan": "SUBJECT %d\nFRAMES SIGNAL: TRACKING\nstatus: VIEWPORT",
		"look": "Still as a statue. Chin up. The sockets healed into deep, puckered craters, and the face around them perfectly calm. It was facing the way we were going.",
		"look_on": "With the frames on it had turned. Toward me. It didn't hurry. It didn't need to.",
		"touched": "Its hand closed on my wrist, cold as the rails. The frames filled with my own pulse. When I could see again I was back at the last door, and it was back where it had stood, as if it had never moved.",
		"touched_why": "touched",
		"toast": "Touched. Connection +5. Back to the last door.",
	},
	"hymn": {
		"start": "From somewhere ahead, under the ringing, a hymn. A hundred voices, slow. As long as they sang, they couldn't hear us.",
		"gap": "The hymn stopped. In the silence, my steps in the dirt.",
		"gap_toast": "The hymn has stopped. They can hear you.",
		"back": "The hymn again.",
	},
	"cache": {
		"prompt": "The crew room",
		"scan": "TUNELET CREW ROOM 2\noffering cache\nFaith: rising",
		"think": "The old crew room, and nobody's crew. Sticks bound with wire in bundles on the lockers. Stones laid in two rings on the table. A heap of phones and tablets, every screen cracked in the same place, the centre. A child's shoe.",
		"ask": ["Take what's needed. Sticks, stones, wire.", "Leave it. It isn't mine."],
		"take": "I filled the side of Emmet's bag. Sticks, two stones from the rings, a coil of wire. Offerings. I'd stopped pretending I didn't know what for.",
		"leave": "I left it. Somebody had walked a long way in the dark to put a child's shoe on that table.",
		"after": "The cache. The rings on the table had closed up where I'd taken the stones. Someone had been in behind me.",
		"log": "An offering cache in the Tunelet crew room under Rail Cut: sticks, stones, wire, broken phones, a child's shoe.",
	},
	"log7": {
		"prompt": "The terminal",
		"scan": "IONWARE  -  TUNELET OPS\nuser: T.HAMERON (guest)\nlast login: 7 YEARS AGO",
		"boot": "An Ionware desktop in the old control room, caked in dust, that woke when I came in. It had been waiting for someone with frames on. The file was already open:",
		"text": "DREAM INDUCED WAVE COLLAPSE - LOG 7\nDr. T. Hameron | Division of Quantum Psychotopography\n\nSUBJECT 41 | DAYS SINCE FIRST RITUAL ATTEMPT: 611\nSubject no longer requires the Contact Field to be active. It is active wherever she is.\nShe asked for the probes today. She said it wants to see what we see.\nThe lower layer is holding. The prison is recursive; every bar we add is a word it learns.\nWe are not studying it any more. It is studying the exits.\nRecommend: none.",
		"think": "Recommend: none. The only line in seven logs where he hadn't known what to do next. Somebody had left it here, open, for me.",
		"after": "The terminal. LOG 7, still open. The cursor blinked after Recommend: none, as if it were waiting for me to type something better.",
		"log": "Hameron's seventh log, on a Tunelet terminal under Southtown: Subject 41 asked for the probes. 'It is studying the exits.'",
		"dark": "The terminal's screen stayed black for me. With the frames off it had nobody to wake for.",
	},
	"forner": {
		"prompt": "The frames on the crate",
		"scan": "ORA FRAMES  -  GEN 2\nowner: FORNER, D.\nlast sync: CHEYENNE (?)",
		"think": "A maintenance closet, and on a crate in the middle of it, a ring of sticks, and in the ring, a pair of Ora frames. Old ones. One arm taped. FORNER on the inside of the temple in label-maker letters.",
		"think_2": "He'd told us he smashed his computer. He hadn't said what he did with his frames. He hadn't needed to bring them down here himself. Something had.",
		"ask": ["Scrub the last recording.", "Bag them, don't look."],
		"scrub": "The frames still had three seconds on them. I had mine replay it, one frame at a time.",
		"frames": ["Frame 1: this closet, door open, from Forner's eye height.", "Frame 2: the tunnel outside. Rails. Dark.", "Frame 3: a woman standing between the rails, far off.", "Frame 4: the woman, close. Full face. Cheyenne, if the photo on his desk was Cheyenne. No eyes. Two holes, and she's smiling.", "Frame 5: motion blur.", "Frame 6: the ceiling of the closet."],
		"found": "There. The face he'd smashed a computer to stop hearing. Down here it had a body to stand in. I hoped he'd never know where his frames had gone.",
		"blur": "Blur. Not that frame. Somewhere in the three seconds was the thing he'd run from.",
		"bag": "I put them in the bag with the lenses down. I didn't want them looking at me.",
		"after": "The crate. The ring of sticks round nothing now.",
		"log": "Forner's old Ora frames, in a ring of sticks under Red Rock. Their last three seconds: Cheyenne on the rails, eyeless, smiling.",
	},
	"two": {
		"chime": "We reached another circular room flanked by two metal doors. My glasses chimed again.",
		"msg": "Salvation or Blood Sacrament\nAn offering is required to continue\nA prayer, faith is the balm\nOne path holds the key\nIt watches and it judges\nBut it is merciful\nWe walk alone, we test alone.",
		"red": "I noticed my Ora frames highlighted both doors on the right with a dull red. There was no knob or handle, just a biometric sensor that was stained red with blood.",
		"emmet": "There's no handle. No terminal. Just... this.",
		"emmet_2": "I'll do it. It's just a little blood; it won't hurt me.",
		"think": "The surface was smeared in dark, dried blood. Old. Rusted into the metal. A hundred past offerings, maybe more. Some small part of me hoped it was symbolic. That it was pigment. Ink. But I already knew the truth.",
		"turan": "This place isn't just built to test us. It was designed to remember everyone who failed.",
		"lynx": "No... everyone who chose wrong.",
		"alone": "We stood there, the four of us, each alone in our own silence.",
		"alone_3": "We stood there, the three of us, each alone in our own silence.",
		"heat": "I stepped closer. The Ora frames pulsed again - this time sending a wave of heat across my temple. The message changed:",
		"msg_2": "Carl Drake\nMan and Machine\nGod and Servant\nCommune now or turn away.\nOnly one voice opens the Eye.",
		"wait": "The sensor beneath my hand blinked, waiting for touch. Waiting for pain. Waiting for belief.",
		"carl": "I think we each have to make the choice. Alone. No group, no vote.",
		"emmet_3": "But how do we know which door is which?",
		"carl_2": "You don't. You pray.",
		"lynx_waiting": "Lynx was already there, standing between the doors with her back to us, as if she'd been waiting for hours.",
		"kneel_prompt": "Kneel and pray",
		"reader_prompt": "The reader",
		"reader_scan": "BIOMETRIC  -  BLOOD\nofferings logged: 1,412\nlast: 6 h ago",
		"reader": "The reader. Dried blood in layers, like the rings in a tree. The newest layer was still tacky.",
		"kneel": "And I dropped to my knees in the center of the room, took a deep breath, and focused my intention.",
		"pray_ask": "(the word)",
		"bow": "I bow to you yet again, I thought.",
		"filter": "I shed my filter, I thought. Take what's left.",
		"other": "I thought the word as hard as I could, into the frames, into the floor.",
		"nothing": "The readers stayed dark. Behind us, in the corridor, something that had been standing still began to walk.",
		"round": "It came across the room the way they all do, not fast, and laid its hand on the back of my neck like a priest. Then it went back to the doorway and stood there, waiting for me to try again.",
		"monica": "Have you learned to remember?",
		"voice": "My frames spoke, in Monica's voice.",
		"melody": "A familiar melody began to get out of the frames. I remembered the initial trial with the mirror; it was the song I couldn't recognize. No, the memory crystallized within my mind:",
		"nicu": "It's the song my wife sang to Mira, when we visited her in the NICU, when we thought she wasn't going to make it.",
		"wonder": "Was Monica... did this song have a relation to the Hypnogogue...? I never knew where it came from.",
		"guided": "I have always guided you, Carl.",
		"both": "The voice faded, and both doors flew open.",
		"right_only": "The voice faded, and the door on the right opened. Only the right. The left stayed shut, its reader blinking, still hungry.",
		"emmet_blood": "Emmet stepped to the left door before anyone could stop him and pressed his thumb to the reader. It's just a little blood, he said again, to nobody. The reader drank. The left door slid open.",
		"left": "The door on the left swung open and revealed a dim green pathway similar to the one we were following.",
		"right": "The door on the right revealed nothing. A black void. Deeper than shadow. Light didn't even try to touch it.",
		"stood": "I stood slowly, heart pounding. The others stared at the two paths. Waiting.",
		"carl_3": "We have to choose again. Not just which door. But what we're walking into.",
		"turan_2": "That one looks like it leads deeper. Controlled. Like the others.",
		"emmet_nod": "Emmet nodded but didn't move.",
		"lynx_2": "But this one, this one wants something more.",
		"stare": "I didn't speak. I stared into the darkness of the right-hand door and felt something looking back. The melody still played in my head.",
		"plea": "Carl. He's in there. I'm sorry.",
		"plea_think": "She walked into the black, not fast. The way you walk into cold water when you've already decided.",
		"betray": "Then, without warning, Lynx sprinted into the black.",
		"betray_drive": "Hameron's drive was still in her pocket.",
		"voice_think": "And from the void, a voice I knew. Lynx's. Calling my name the way she'd said it at the car. She'd never come down with us. She was in there anyway.",
		"follow": "I heard a familiar voice, and without a thought, followed her into the void.",
		"left_hall": "Behind me Turan and Emmet took the left hall, into the green. I didn't see them go.",
		"void_prompt": "The void",
		"left_prompt": "The green hall",
		"left_look": "The green hall. Turan's way. It went on the way the others had, controlled. I couldn't make my feet want it.",
		"shut": "Two metal doors, and no way to open either one that didn't start on my knees.",
		"done": "I'd prayed. They'd answered.",
		"log": "The two doors: Carl prayed. Monica's voice: 'Have you learned to remember?' The NICU lullaby. Left, a green hall; right, a void.",
		"why_bow": "I bow to you yet again",
	},
	"objective": {
		"car": "The car: choose the way down.",
		"rc": "The depot: the mouth in the mountain.",
		"st": "Southtown: the tunnel mouth under the overpass.",
		"rr": "Red Rock: the subway, then the maintenance stair.",
		"tunnel": "Follow the tunnel to where they meet.",
		"hub": "The hub: the green eye, the manhole.",
		"down": "Down the manhole.",
		"chamber": "Forward.",
		"door_a": "The corridor: speak to the door.",
		"door_b": "The gallery: the second door. The eyeless.",
		"doors": "The two doors.",
		"pray": "Kneel and pray.",
		"void": "Follow her.",
	},
	"phone": {
		"greeting": "[color=#7fe6b0]Psyon:[/color] Good evening, Carl. The tunnels are closed to the public. I'm glad you came anyway.\n\n",
		"tunnel": "[color=#7fe6b0]Psyon:[/color] It's two to three miles, depending how direct you are. You've always been direct.\n\n",
		"low": "[color=#7fe6b0]Psyon:[/color] Zero to one. One to two. You're doing so well.\n\n",
		"doors": "[color=#7fe6b0]Psyon:[/color] Only one voice opens the Eye. Use yours.\n\n",
	},
	"party": {
		"turan_prompt": "Turan",
		"turan_scan": "TURAN, DR. A.\nPSYONIC INTEGRATIONS - LEAD\nheart rate: 58 (calm)",
		"turan": "Turan swept her light along the strata and said nothing. Her pupils hadn't come back down since the mouth.",
		"emmet_prompt": "Emmet",
		"emmet_scan": "EMMET\nPSYONIC INTEGRATIONS - ANALYST\nheart rate: 112",
		"emmet": "We got this, Carl. He said it to himself as much as me.",
		"lynx_prompt": "Lynx",
		"lynx_scan": "MORRINO, LYNX\nPSYONIC - ML ENGINEERING, FL.79\nheart rate: 96",
		"lynx": "She kept her light on my back, not the walls. Watching me, or watching for me. I couldn't tell any more.",
	},
}

const GREEN := Color(0.239, 1.0, 0.478)      # #3dff7a: the floodlight; in no other palette
const SODIUM := Color(1.0, 0.62, 0.3)
const BLOOD := Color(0.3, 0.025, 0.02)
const LOW := 0.0                              # the lower level's floor
const LZ := -320.0                            # where it lies (Main lifts anyone below y -4)
const CH := Vector3(0.0, LOW, LZ - 5.0)           # the green chamber
const CH_R := 9.0
const TD := Vector3(0.0, LOW, LZ - 69.0)          # the two-doors room
const TD_R := 7.0
const DOOR_Z := LZ - 76.0
const DOOR_X := 2.4                           # left at -x, right (the void) at +x
const DOOR_A_Z := LZ - 26.0
const DOOR_B_Z := LZ - 50.0
const DOOR_C := Vector3(4.0, LOW, LZ - 38.0)
const SPEAKER := Vector3(-3.85, LOW + 2.7, LZ - 41.0)
const MANHOLE := Vector3(0.0, 0.0, -5.0)
const HUB_R := 9.0
const BW := 7.0                               # bore width and height
const BH := 6.0
const RC_FUN := 90.0                          # the funnel to the 160-ft mouth
const RC_FACE := 125.0                        # the cliff face
const CAR_AT := Vector3(217.5, 0.0, 4.0)
const ST_PORTAL := 85.0
const ST_ARRIVE := Vector3(0.0, 0.0, 134.0)
const RR_Y := 12.0                            # the plaza
const RR_PLAT_Y := 6.0                        # the subway platform
const RR_ARRIVE := Vector3(-160.0, RR_Y, 6.0)
const ALLEY := Vector3(-138.0, RR_Y, -41.5)
const CACHE := Vector3(50.0, 0.0, -7.0)
const CTRL := Vector3(7.0, 0.0, 45.0)
const CLOSET := Vector3(-24.0, 0.0, 7.0)

var z_rc: Node3D                    # Rail Cut: the street, the yard, the funnel
var z_st: Node3D                    # Southtown: the overpass camp, the portal
var z_rr: Node3D                    # Red Rock: the plaza, the station, the stairs
var z_tun: Node3D                   # the hub, the three bores, the side rooms
var z_low: Node3D                   # the green chamber, the corridor, the doors
var dyn: Node3D                     # moving and switched things, never batched
var turan: Node3D
var emmet: Node3D
var lynx: Node3D
var tyson: Node3D
var party: Array = []               # [{fig, lag}] following Carl
var eyeless: Array = []             # [{fig, it, home, yaw, patrol, pi, reset, zone, range}]
var eye_layer: Array = []           # shown only with the frames on
var eye_its: Array = []             # interactables that exist only with the frames on
var footprints: Array = []
var torch: SpotLight3D              # Emmet's tactical flashlight, in Carl's hand
var big_eye: MeshInstance3D         # the blood-red eye in the mouth
var eye_flash: OmniLight3D
var st_eye: MeshInstance3D
var rr_eye: MeshInstance3D
var green_eye_m: StandardMaterial3D
var cover: MeshInstance3D           # the manhole cover
var hole_glow: MeshInstance3D
var hole_light: OmniLight3D
var door_a: Node3D
var door_b: Node3D
var door_l: Node3D
var door_r: Node3D
var speaker_led: MeshInstance3D
var speaker_snd: Node
var double: Node3D
var lynx_torch: SpotLight3D
var dropped_torch: SpotLight3D
var void_box: MeshInstance3D
var fire_light: OmniLight3D
var flicker_l: OmniLight3D
var _hymn: AudioStreamPlayer3D
var _ring: Node
var _ring2: Node
var _drip: Node
var _env: Environment
var _sun: DirectionalLight3D
var _under := -1                    # 0 outside, 1 underground (env switched on change)
var _trail: Array = []
var _busy := false
var _shot := false
var _shot_posed := false
var _eye_vis := false
var _touch_cd := 0.0
var _checkpoint := Vector3.ZERO
var _hymn_t := 0.0
var _gap := false
var _ended := false
var _lynx_mode := ""                # follow | ahead | gone
var _opened := ""                   # "" | both | right
var _lynx_ahead_seen := false
var _sand: StandardMaterial3D
var _sand_d: StandardMaterial3D
var _dirt: StandardMaterial3D
var _rust: StandardMaterial3D
var _rail: StandardMaterial3D
var _wood: StandardMaterial3D
var _conc: StandardMaterial3D
var _conc_low: StandardMaterial3D
var _asph: StandardMaterial3D
var _steel: StandardMaterial3D
var _tile: StandardMaterial3D
var _black: StandardMaterial3D
var _void_m: StandardMaterial3D
var _faces := {}


func build(m: Node) -> void:
	main = m
	rng.seed = 2525
	kit_day = false
	step_db = -20.0               # soft dirt: "each step left a silent imprint"
	card = LINES["cards"]["chapter"]
	for n in ["z_rc", "z_st", "z_rr", "z_tun", "z_low", "dyn"]:
		var nd := Node3D.new()
		nd.name = n
		add_child(nd)
		set(n, nd)
	_materials()
	# the upper level's ground: one slab under the hub, the bores and the yards
	solid_box(Vector3(560, 1, 420), Vector3(20, -0.5, 30), self)
	solid_box(Vector3(60, 1, 160), Vector3(0, LOW - 0.5, LZ - 50.0), self)
	_hub()
	_bores()
	_side_rooms()
	_funnel()
	_railcut()
	_southtown()
	_redrock()
	_lower()
	for z: Node3D in [z_rc, z_st, z_rr, z_tun, z_low]:
		_batch(z, 30.0, true)
	_people()
	_eyeless_build()
	_moving()
	_sounds_at()
	spawn = CAR_AT + Vector3(-2.2, 0.1, -1.0)
	spawn_yaw = 90.0
	_checkpoint = spawn


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	_env = env
	_sun = sun
	_under = -1
	_set_env(false)


## Outside: a hot dark night, empty roads. Underground: no sky, no moon,
## a faint warm ambient so the sandstone reads in the beams; below the hub,
## the green.
func _set_env(under: bool) -> void:
	var u := 1 if under else 0
	if u == _under or _env == null:
		return
	_under = u
	if under:
		_env.background_mode = Environment.BG_COLOR
		_env.background_color = Color(0, 0, 0)
		_env.ambient_light_color = Color(0.5, 0.36, 0.28)
		_env.ambient_light_energy = 0.16
		_env.fog_light_color = Color(0.03, 0.02, 0.015)
		_env.fog_density = 0.02
		_env.fog_sky_affect = 0.0
		_env.tonemap_exposure = 1.25
		_env.glow_bloom = 0.04
		_sun.light_energy = 0.0
		_sun.shadow_enabled = false
	else:
		_env.background_mode = Environment.BG_SKY
		var psm := ProceduralSkyMaterial.new()
		psm.sky_top_color = Color(0.01, 0.012, 0.03)
		psm.sky_horizon_color = Color(0.26, 0.08, 0.12)
		psm.ground_horizon_color = Color(0.2, 0.07, 0.08)
		psm.ground_bottom_color = Color(0.02, 0.012, 0.012)
		psm.sky_curve = 0.08
		_env.sky.sky_material = psm
		_env.ambient_light_color = Color(0.3, 0.24, 0.36)
		_env.ambient_light_energy = 0.4
		_env.fog_light_color = Color(0.18, 0.08, 0.12)
		_env.fog_density = 0.0045
		_env.fog_sky_affect = 0.3
		_env.tonemap_exposure = 1.15
		_env.glow_bloom = 0.05
		_sun.light_color = Color(0.55, 0.5, 0.8)
		_sun.light_energy = 0.16
		_sun.rotation = Vector3(deg_to_rad(-50), deg_to_rad(40), 0)


func hifi(_e: Environment, _s: DirectionalLight3D) -> void:
	if torch:
		torch.shadow_enabled = true


func ambience() -> void:
	main.loop("wind", -30.0)
	# the ringing: far off, everywhere underground, loudest down the bores
	_ring = main.loop("flies", -80.0)
	(_ring as AudioStreamPlayer).pitch_scale = 2.4
	_ring2 = main.loop("hum", -80.0)
	(_ring2 as AudioStreamPlayer).pitch_scale = 1.9
	_drip = main.loop("tap", -80.0)
	(_drip as AudioStreamPlayer).pitch_scale = 0.6
	_hymn = main.loop("chant", -80.0, TD + Vector3(0, 2.0, -6.0), 6.0, 70.0)
	_hymn.pitch_scale = 0.82
	speaker_snd = main.loop("whisper", -6.0, SPEAKER, 3.0, 22.0)
	(speaker_snd as AudioStreamPlayer3D).pitch_scale = 0.55
	main.loop("hum", -18.0, CH + Vector3(0, 6, 0), 4.0, 30.0)
	main.loop("fire", -10.0, Vector3(-5.0, 0.6, 124.0), 3.0, 22.0)


# ------------------------------------------------------------------ materials and textures

func _materials() -> void:
	var nrm: Texture2D = load("res://assets/pbr/concrete/normal.jpg")
	var strata := _strata_tex()
	_sand = tex_mat(strata, Vector3.ONE / 3.2, 0.95, true)
	_sand.normal_enabled = true
	_sand.normal_texture = nrm
	_sand_d = tex_mat(strata, Vector3.ONE / 2.4, 0.95, true)
	_sand_d.albedo_color = Color(0.62, 0.5, 0.42)
	_sand_d.normal_enabled = true
	_sand_d.normal_texture = nrm
	_dirt = tex_mat(_dirt_tex(), Vector3.ONE / 2.0, 1.0, true)
	_rust = pbr("rust", Vector3.ONE / 1.6, true)
	_rail = pbr("rust", Vector3.ONE / 0.7, true, Color(0.7, 0.52, 0.4), 0.8)
	_wood = pbr("woodfloor", Vector3.ONE / 1.2, true, Color(0.28, 0.2, 0.15))
	_conc = pbr("concrete", Vector3.ONE / 3.0, true, Color(0.5, 0.48, 0.46))
	_conc_low = pbr("concrete", Vector3.ONE / 2.5, true, Color(0.3, 0.32, 0.3))
	_asph = pbr("asphalt", Vector3.ONE / 4.0, true, Color(0.42, 0.4, 0.42))
	_steel = mat(Color(0.2, 0.2, 0.22), 0.45, 0.8)
	_tile = tex_mat(_tile_tex(), Vector3.ONE / 1.6, 0.35, true)
	_black = mat(Color(0.015, 0.015, 0.018), 0.95)
	_void_m = newmat(Color(0, 0, 0), 1.0)
	_void_m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_void_m.cull_mode = BaseMaterial3D.CULL_DISABLED
	_void_m.disable_fog = true


## Orange sandstone in strata: "layered orange rock". Bands that wobble,
## thin dark seams, grit. Tiles both ways.
func _strata_tex() -> ImageTexture:
	var n := 256
	var img := Image.create(n, n, false, Image.FORMAT_RGBA8)
	var r := RandomNumberGenerator.new()
	r.seed = 77
	var bands: Array = []
	for i in 24:
		bands.append(r.randf())
	for y in n:
		for x in n:
			var wob := sin(x * TAU / n * 2.0) * 3.0 + sin(x * TAU / n * 5.0 + y * 0.05) * 1.5
			var yy := fposmod(y + wob, float(n))
			var bi := int(yy / (n / 24.0)) % 24
			var v: float = bands[bi]
			var c := Color(0.72, 0.36, 0.16).lerp(Color(0.92, 0.6, 0.34), v)
			if fmod(yy, n / 24.0) < 1.2 and v > 0.5:
				c = c.darkened(0.35)
			c = c.darkened(r.randf() * 0.16)
			img.set_pixel(x, y, c)
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


## Soft dirt, "like wet sand at low tide": brown-orange grain and pebbles.
func _dirt_tex() -> ImageTexture:
	var n := 128
	var img := Image.create(n, n, false, Image.FORMAT_RGBA8)
	var r := RandomNumberGenerator.new()
	r.seed = 31
	img.fill(Color(0.4, 0.26, 0.17))
	for i in 5000:
		var c := Color(0.48, 0.31, 0.2) if r.randf() < 0.5 else Color(0.3, 0.19, 0.12)
		img.set_pixel(r.randi() % n, r.randi() % n, c)
	for i in 60:
		var px := r.randi() % n
		var py := r.randi() % n
		var pc := Color(0.55, 0.42, 0.32).darkened(r.randf() * 0.4)
		for dx in 2:
			for dy in 2:
				img.set_pixel((px + dx) % n, (py + dy) % n, pc)
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


## Subway tile, white once, grout gone brown.
func _tile_tex() -> ImageTexture:
	var n := 128
	var img := Image.create(n, n, false, Image.FORMAT_RGBA8)
	var r := RandomNumberGenerator.new()
	r.seed = 9
	for y in n:
		for x in n:
			var g := (x % 32 < 2) or (y % 16 < 2)
			var c := Color(0.36, 0.3, 0.24) if g else Color(0.8, 0.8, 0.74).darkened(r.randf() * 0.08 + (0.25 if y > 96 else 0.0) * (y - 96) / 32.0)
			img.set_pixel(x, y, c)
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


## An eye: almond lids, iris, pupil. `painted` draws it the way the cult
## paints it (outline, a filled pupil, drips); otherwise solid, for the
## frames' blood-red eye.
func _eye_tex(c: Color, painted: bool) -> ImageTexture:
	var w := 256
	var h := 160
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	var cy := 70.0
	for y in h:
		for x in w:
			var u := (x - w / 2.0) / (w * 0.46)
			var v := (y - cy) / (h * 0.4)
			var lid := 1.0 - u * u
			if lid <= 0.0:
				continue
			var inside := absf(v) < lid * 0.95
			var edge := absf(absf(v) - lid * 0.95) < 0.06
			var rr := sqrt(u * u * 2.6 + v * v)
			var px := Color(0, 0, 0, 0)
			if painted:
				if edge and absf(u) < 0.98:
					px = Color(c, 0.95)
				if rr < 0.42 and inside:
					px = Color(c, 0.9) if rr > 0.36 or rr < 0.2 else Color(c.darkened(0.6), 0.5)
			else:
				if inside:
					px = Color(c.darkened(0.55), 0.92)
					if rr < 0.5:
						px = Color(c, 1.0)
					if rr < 0.22:
						px = Color(0.02, 0.0, 0.0, 1.0)
				elif edge:
					px = Color(c.lightened(0.2), 1.0)
			if px.a > 0.0:
				img.set_pixel(x, y, px)
	if painted:
		var r := RandomNumberGenerator.new()
		r.seed = 4
		for k in 9:
			var dx := int(w / 2.0 + r.randf_range(-100, 100))
			var dy := int(cy + (1.0 - pow((dx - w / 2.0) / (w * 0.46), 2)) * 0.95 * h * 0.4)
			for j in r.randi_range(8, 30):
				if dy + j < h:
					img.set_pixel(dx, dy + j, Color(c, 0.85 - j * 0.02))
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


## Dried blood on steel, in runs: old and brown at the edges, red where
## it is new.
func _blood_tex() -> ImageTexture:
	var w := 64
	var h := 128
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	var r := RandomNumberGenerator.new()
	r.seed = 66
	for k in 40:
		var x0 := r.randf_range(8, 56)
		var y0 := r.randf_range(0, 30)
		var ln := r.randf_range(20, 110)
		var wd := r.randf_range(1.0, 4.0)
		var c := Color(0.35, 0.04, 0.03).lerp(Color(0.18, 0.06, 0.03), r.randf())
		for j in int(ln):
			for i in int(wd):
				var xx := int(x0 + i + sin(j * 0.2) * 0.8)
				var yy := int(y0 + j)
				if xx >= 0 and xx < w and yy < h:
					img.set_pixel(xx, yy, Color(c, clampf(0.95 - j / ln * 0.5, 0.3, 0.95)))
	for k in 12:
		var cx := r.randf_range(10, 54)
		var cy := r.randf_range(4, 30)
		for y in range(-6, 7):
			for x in range(-6, 7):
				if x * x + y * y < 30 and int(cx + x) >= 0 and int(cx + x) < w and int(cy + y) >= 0:
					img.set_pixel(int(cx + x), int(cy + y), Color(0.3, 0.03, 0.02, 0.9))
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


## A face with the eyes gone: "deep, hollowed-out craters of puckered flesh".
func _eyeless_face(skin: Color, hair: Color, seed: int) -> StandardMaterial3D:
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
	img.generate_mipmaps()
	var m := base.duplicate() as StandardMaterial3D
	m.albedo_texture = ImageTexture.create_from_image(img)
	return m


func _head_mi(fig: Node3D) -> MeshInstance3D:
	for c in (fig.get_meta("head") as Node3D).get_children():
		if c is MeshInstance3D:
			return c
	return null


# ------------------------------------------------------------------ build helpers

## A box with a full transform (and a matching collider when solid).
func _xbox(size: Vector3, xf: Transform3D, m: Material, solid: bool, par: Node) -> MeshInstance3D:
	var bm := BoxMesh.new()
	bm.size = size
	var mi := MeshInstance3D.new()
	mi.mesh = bm
	mi.material_override = m
	mi.transform = xf
	par.add_child(mi)
	if solid:
		var sb := StaticBody3D.new()
		sb.transform = xf
		var cs := CollisionShape3D.new()
		var sh := BoxShape3D.new()
		sh.size = size
		cs.shape = sh
		sb.add_child(cs)
		par.add_child(sb)
	return mi


## A box in a bore's frame: origin a, basis bs (local z along the bore),
## rolled about the local z axis.
func _lb(a: Vector3, bs: Basis, size: Vector3, lp: Vector3, roll: float, m: Material, solid: bool, par: Node) -> MeshInstance3D:
	return _xbox(size, Transform3D(bs * Basis(Vector3.BACK, roll), a + bs * lp), m, solid, par)


func _lamp(pos: Vector3, c: Color, e: float, r: float, par: Node) -> OmniLight3D:
	var o := OmniLight3D.new()
	o.position = pos
	o.light_color = c
	o.light_energy = e
	o.omni_range = r
	o.omni_attenuation = 1.3
	o.shadow_enabled = false
	par.add_child(o)
	return o


func _fwd(yaw: float) -> Vector3:
	return Vector3(-sin(yaw), 0, -cos(yaw))


## A ring of wall boxes round centre c (radius r, height h), leaving gaps
## toward the given angles (0 = +Z, PI/2 = +X); a floor and a ceiling.
func _ring_room(c: Vector3, r: float, h: float, sides: int, gaps: Array, gap_w: float, wall: Material, floor_m: Material, ceil_m: Material, par: Node) -> void:
	var step := TAU / sides
	var sl := 2.0 * r * sin(step / 2.0)
	for i in sides:
		var a := (i + 0.5) * step
		var skip := false
		for g: float in gaps:
			if absf(wrapf(a - g, -PI, PI)) < gap_w:
				skip = true
		if skip:
			continue
		var d := Vector3(sin(a), 0, cos(a))
		_xbox(Vector3(sl + 0.5, h, 1.2), Transform3D(Basis(Vector3.UP, a), c + d * (r + 0.6) + Vector3(0, h / 2.0, 0)), wall, true, par)
	cyl(r + 0.6, r + 0.6, 0.2, c + Vector3(0, -0.08, 0), floor_m, sides, par)
	cyl(r * 0.35, r + 1.0, 1.4, c + Vector3(0, h + 0.6, 0), ceil_m, sides, par)


## A box room (sx by sz, h high) with one door opening 1.6 wide toward
## n (-z), s (+z), e (+x) or w (-x).
func _room(c: Vector3, sx: float, sz: float, h: float, door: String, wall: Material, floor_m: Material, par: Node) -> void:
	box(Vector3(sx, 0.2, sz), c + Vector3(0, -0.08, 0), floor_m, false, par)
	box(Vector3(sx + 0.8, 0.4, sz + 0.8), c + Vector3(0, h + 0.2, 0), wall, false, par)
	for side in ["n", "s", "e", "w"]:
		var along_x: bool = side in ["n", "s"]
		var ln: float = sx if along_x else sz
		var off: Vector3
		match side:
			"n": off = Vector3(0, 0, -sz / 2.0 - 0.2)
			"s": off = Vector3(0, 0, sz / 2.0 + 0.2)
			"e": off = Vector3(sx / 2.0 + 0.2, 0, 0)
			_: off = Vector3(-sx / 2.0 - 0.2, 0, 0)
		var thick := Vector3(ln + 0.8, h, 0.4) if along_x else Vector3(0.4, h, ln + 0.8)
		if side != door:
			box(thick, c + off + Vector3(0, h / 2.0, 0), wall, true, par)
			continue
		var half := (ln + 0.8 - 1.6) / 2.0
		for s: float in [-1.0, 1.0]:
			var shift := s * (0.8 + half / 2.0)
			var sz2 := Vector3(half, h, 0.4) if along_x else Vector3(0.4, h, half)
			var p := c + off + Vector3(shift if along_x else 0.0, h / 2.0, 0.0 if along_x else shift)
			box(sz2, p, wall, true, par)
		var lin := Vector3(1.6, h - 2.4, 0.4) if along_x else Vector3(0.4, h - 2.4, 1.6)
		box(lin, c + off + Vector3(0, 2.4 + (h - 2.4) / 2.0, 0), wall, false, par)


## Two rusted rails on sleepers from a along dir, at lateral offset lat.
func _rails(a: Vector3, dir: Vector3, ln: float, lat: float, par: Node) -> void:
	var bs := Basis(Vector3.UP, atan2(dir.x, dir.z))
	for s: float in [-0.72, 0.72]:
		_lb(a, bs, Vector3(0.09, 0.13, ln), Vector3(lat + s, 0.07, ln / 2.0), 0.0, _rail, false, par)
	var k := 0.6
	while k < ln:
		_lb(a, bs, Vector3(2.3, 0.08, 0.24), Vector3(lat + rng.randf_range(-0.05, 0.05), 0.02, k), rng.randf_range(-0.02, 0.02), _wood, false, par)
		k += 1.1


# ------------------------------------------------------------------ the hub (ch.25)

## Where the three bores meet: a sandstone cavern, sixteen-sided, the
## green eye on the north wall over the arrow and the manhole.
func _hub() -> void:
	_ring_room(Vector3.ZERO, HUB_R, 7.0, 16, [PI / 2.0, 0.0, -PI / 2.0], 0.4, _sand, _dirt, _sand_d, z_tun)
	# fallen blocks, an old TBM segment ring leaning on the wall
	for i in 9:
		var a := rng.randf() * TAU
		var p := Vector3(sin(a), 0, cos(a)) * rng.randf_range(6.0, 8.2)
		var s := sphere(rng.randf_range(0.3, 0.8), p + Vector3(0, 0.15, 0), _sand_d, 7, z_tun)
		s.scale = Vector3(1.3, 0.6, 1.0)
	var seg := TorusMesh.new()
	seg.inner_radius = 2.4
	seg.outer_radius = 2.9
	seg.rings = 18
	seg.ring_segments = 6
	var ring := mesh(seg, Vector3(-6.4, 2.2, -4.6), _rust, z_tun)
	ring.rotation = Vector3(PI / 2.0, 0.6, 0.12)
	# the green eye: "vivid even under years of dust", and the crude arrow
	green_eye_m = newmat(Color(1, 1, 1), 0.9)
	green_eye_m.albedo_texture = _eye_tex(Color(0.28, 0.7, 0.4), true)
	green_eye_m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	green_eye_m.emission_enabled = true
	green_eye_m.emission = Color(0.12, 0.35, 0.18)
	green_eye_m.emission_energy_multiplier = 0.6
	var eq := quad(Vector2(5.2, 3.25), Vector3(0, 3.9, -HUB_R + 0.02), 0.0, green_eye_m, dyn)
	eq.name = "green_eye"
	var paint := mat(Color(0.2, 0.52, 0.3), 0.9)
	box(Vector3(0.22, 1.5, 0.04), Vector3(0, 1.55, -HUB_R + 0.03), paint, false, z_tun)
	for s: float in [-1.0, 1.0]:
		var ab := box(Vector3(0.2, 0.7, 0.04), Vector3(s * 0.2, 0.75, -HUB_R + 0.03), paint, false, z_tun)
		ab.rotation.z = s * 0.7
	interactable("green_eye", "The green eye", Vector3(0, 3.9, -HUB_R + 0.3), Vector3(5.0, 3.2, 0.3),
		"PAINT  -  ACRYLIC, GREEN\nage: 8-10 YEARS\nfaith: 1", false, z_tun)
	# the manhole: "a corroded manhole cover"
	cover = cyl(0.62, 0.62, 0.07, MANHOLE + Vector3(0, 0.04, 0), _rust, 18, dyn)
	cyl(0.72, 0.72, 0.05, MANHOLE + Vector3(0, 0.015, 0), _steel, 18, z_tun)
	var hg := newmat(Color(0, 0, 0), 1.0)
	hg.emission_enabled = true
	hg.emission = GREEN * 0.6
	hg.emission_energy_multiplier = 1.4
	hole_glow = cyl(0.6, 0.6, 0.02, MANHOLE + Vector3(0, 0.05, 0), hg, 18, dyn)
	hole_glow.visible = false
	hole_light = _lamp(MANHOLE + Vector3(0, 0.6, 0), GREEN, 0.0, 6.0, dyn)
	var mh := interactable("manhole", LINES["manhole"]["prompt"], MANHOLE + Vector3(0, 0.25, 0), Vector3(1.4, 0.5, 1.4), LINES["manhole"]["scan"], false, z_tun)
	mh.set_meta("route", true)
	_lamp(Vector3(0, 5.5, 0), Color(1.0, 0.7, 0.45), 0.25, 14.0, z_tun)


# ------------------------------------------------------------------ the bores

## A straight bore from a along dir: soft dirt, sandstone walls, a three-slab
## vault, rusted ribs, a dead cable, the rails on one side. gaps:
## [[from, to, side]] where a wall opens onto a side room.
func _bore(a: Vector3, dir: Vector3, ln: float, gaps: Array, rail_end: float, par: Node) -> void:
	var bs := Basis(Vector3.UP, atan2(dir.x, dir.z))
	var hw := BH * 0.55
	_lb(a, bs, Vector3(BW + 0.4, 0.2, ln), Vector3(0, -0.08, ln / 2.0), 0.0, _dirt, false, par)
	for side: float in [-1.0, 1.0]:
		var cuts: Array = []
		for g: Array in gaps:
			if float(g[2]) == side:
				cuts.append(g)
		var t0 := 0.0
		cuts.sort_custom(func(p: Array, q: Array) -> bool: return float(p[0]) < float(q[0]))
		for g: Array in cuts + [[ln, ln, side]]:
			var t1: float = g[0]
			if t1 - t0 > 0.05:
				_lb(a, bs, Vector3(1.2, hw, t1 - t0), Vector3(side * (BW / 2.0 + 0.6), hw / 2.0, (t0 + t1) / 2.0), 0.0, _sand, true, par)
			var g1: float = g[1]
			if g1 > t1:
				_lb(a, bs, Vector3(1.2, hw - 2.5, g1 - t1), Vector3(side * (BW / 2.0 + 0.6), 2.5 + (hw - 2.5) / 2.0, (t1 + g1) / 2.0), 0.0, _sand, false, par)
			t0 = g1
		# the vault: a slab from the wall top to the crown
		var outer := Vector2(side * BW / 2.0, hw)
		var inner := Vector2(side * BW * 0.22, BH)
		var mid := (outer + inner) / 2.0
		var dv := inner - outer
		var roll := atan2(dv.y, dv.x)
		_lb(a, bs, Vector3(dv.length() + 0.5, 0.8, ln), Vector3(mid.x + side * 0.3, mid.y + 0.3, ln / 2.0), roll, _sand_d, false, par)
	_lb(a, bs, Vector3(BW * 0.44 + 0.6, 0.8, ln), Vector3(0, BH + 0.3, ln / 2.0), 0.0, _sand_d, false, par)
	# ribs every ten metres, rusted through
	var k := 5.0
	while k < ln - 1.0:
		for side: float in [-1.0, 1.0]:
			_lb(a, bs, Vector3(0.28, hw, 0.28), Vector3(side * (BW / 2.0 - 0.14), hw / 2.0, k), 0.0, _rust, false, par)
			var outer := Vector2(side * (BW / 2.0 - 0.2), hw)
			var inner := Vector2(side * BW * 0.2, BH - 0.3)
			var dv := inner - outer
			_lb(a, bs, Vector3(dv.length(), 0.22, 0.28), Vector3((outer.x + inner.x) / 2.0, (outer.y + inner.y) / 2.0, k), atan2(dv.y, dv.x), _rust, false, par)
		_lb(a, bs, Vector3(BW * 0.42, 0.22, 0.28), Vector3(0, BH - 0.3, k), 0.0, _rust, false, par)
		# a dead cage lamp on every other rib
		if int(k) % 20 == 5:
			_lb(a, bs, Vector3(0.3, 0.36, 0.3), Vector3(BW / 2.0 - 0.35, hw - 0.6, k), 0.0, _steel, false, par)
			_lb(a, bs, Vector3(0.18, 0.2, 0.18), Vector3(BW / 2.0 - 0.35, hw - 0.66, k), 0.0, mat(Color(0.25, 0.22, 0.18), 0.2), false, par)
		k += 10.0
	# the cable along the wall, and grit on the floor
	_lb(a, bs, Vector3(0.07, 0.07, ln), Vector3(BW / 2.0 - 0.15, hw - 0.3, ln / 2.0), 0.0, _black, false, par)
	_lb(a, bs, Vector3(0.05, 0.05, ln), Vector3(BW / 2.0 - 0.15, hw - 0.45, ln / 2.0), 0.0, _black, false, par)
	k = 3.0
	while k < ln:
		var s := sphere(rng.randf_range(0.15, 0.5), a + bs * Vector3(rng.randf_range(0.8, BW / 2.0 - 0.5) * (1.0 if rng.randf() < 0.7 else -1.0), 0.05, k), _sand_d, 6, par)
		s.scale = Vector3(1.4, 0.5, 1.1)
		k += rng.randf_range(4.0, 9.0)
	_rails(a, dir, rail_end, -1.7, par)


func _bores() -> void:
	# east to Rail Cut, south to Southtown, west to Red Rock's stair
	_bore(Vector3(8.5, 0, 0), Vector3(1, 0, 0), RC_FUN - 8.5, [[CACHE.x - 8.5 - 0.8, CACHE.x - 8.5 + 0.8, 1.0]], RC_FUN - 8.5, z_tun)
	_bore(Vector3(0, 0, 8.5), Vector3(0, 0, 1), ST_PORTAL - 8.5, [[CTRL.z - 8.5 - 0.8, CTRL.z - 8.5 + 0.8, 1.0]], ST_PORTAL - 8.5, z_tun)
	_bore(Vector3(-8.5, 0, 0), Vector3(-1, 0, 0), 27.5, [[-CLOSET.x - 8.5 - 0.8, -CLOSET.x - 8.5 + 0.8, 1.0]], 22.0, z_tun)
	# the west bore's end: a wall, and the maintenance stair's foot in it
	box(Vector3(1.0, BH, 4.2), Vector3(-36.5, BH / 2.0, 1.4), _sand, true, z_tun)
	box(Vector3(1.0, BH - 3.0, 3.2), Vector3(-36.5, 3.0 + (BH - 3.0) / 2.0, -2.0), _sand, false, z_tun)
	# the watcher's stretch: a TUNELET stencil, a speed board, a refuge niche
	label("TUNELET  -  LINE 2  -  RAIL CUT  4.1 KM", Vector3(30.0, 2.6, -BW / 2.0 + 0.02), 0.0, 0.006, Color(0.85, 0.8, 0.7), z_tun, false).font_size = 40
	label("SOUTHTOWN  ACCESS  3", Vector3(-BW / 2.0 + 0.02, 2.6, 30.0), PI / 2.0, 0.006, Color(0.85, 0.8, 0.7), z_tun, false).font_size = 40
	label("RED ROCK  INTERCHANGE", Vector3(-20.0, 2.6, BW / 2.0 - 0.02), PI, 0.006, Color(0.85, 0.8, 0.7), z_tun, false).font_size = 40
	for p: Vector3 in [Vector3(64.0, 0, -2.6), Vector3(-1.6, 0, 62.0), Vector3(-15.0, 0, -2.4)]:
		prop("Barrel_01" if int(p.x) % 2 == 0 else "old_tyre", p, rng.randf() * TAU, 1.0, true, z_tun)
	prop("modular_electric_cables", Vector3(40.0, 2.2, 3.3), PI, 1.0, false, z_tun)
	prop("cardboard_box_01", Vector3(-2.6, 0, 70.0), 0.4, 1.0, true, z_tun)
	# rings scratched where the bores meet
	_glyph_on(Vector3(HUB_R - 0.05, 1.7, 3.6), -PI / 2.0 - 0.4, 0.006, "tu_glyph_hub", true, false,
		"Two rings scratched deep into the sandstone where the bores meet, by a hand that knew the way and wanted us to.")


# ------------------------------------------------------------------ the side rooms

func _side_rooms() -> void:
	# Rail Cut: the crew room, the cache of offerings
	_room(CACHE, 6.0, 6.0, 3.2, "s", _conc, _dirt, z_tun)
	prop("steel_frame_shelves_01", CACHE + Vector3(-2.2, 0, -2.4), 0.0, 1.0, true, z_tun)
	prop("metal_office_desk", CACHE + Vector3(0.6, 0, -0.6), 0.0, 1.0, true, z_tun)
	var stick_m := pbr("bark", Vector3(1, 3, 1), false, Color(0.8, 0.6, 0.4))
	for k in 7:
		var p := CACHE + Vector3(-2.4 + rng.randf_range(-0.3, 0.3), 0.3 + (k % 3) * 0.55, -2.4)
		for j in 6:
			stick(p + Vector3(rng.randf_range(-0.2, 0.2), 0, rng.randf_range(-0.12, 0.12)), p + Vector3(rng.randf_range(-0.3, 0.3), 0.45, rng.randf_range(-0.12, 0.12)), 0.015, stick_m, z_tun)
	var stone := mat(Color(0.5, 0.46, 0.42), 0.9)
	for ring: float in [0.3, 0.55]:
		for k in int(ring * 28):
			var a := TAU * k / int(ring * 28)
			sphere(0.035, CACHE + Vector3(0.6 + cos(a) * ring, 0.8, -0.6 + sin(a) * ring), stone, 5, z_tun)
	for k in 14:
		var ph := box(Vector3(0.08, 0.008, 0.15), CACHE + Vector3(rng.randf_range(1.2, 2.4), 0.02 + k * 0.01, rng.randf_range(0.6, 2.2)), mat(Color(0.05, 0.05, 0.06), 0.2, 0.3), false, z_tun)
		ph.rotation.y = rng.randf() * TAU
	box(Vector3(0.09, 0.07, 0.17), CACHE + Vector3(0.9, 0.79, -0.9), mat(Color(0.8, 0.3, 0.45), 0.8), false, z_tun)
	var c := interactable("cache", LINES["cache"]["prompt"], CACHE + Vector3(0, 1.0, -0.6), Vector3(3.0, 2.0, 2.0), LINES["cache"]["scan"], false, z_tun)
	c.set_meta("route", true)
	_lamp(CACHE + Vector3(0, 2.6, 0), Color(1.0, 0.55, 0.3), 0.35, 6.0, z_tun)
	# Southtown: the control room and the terminal with Hameron's seventh log
	_room(CTRL, 6.0, 6.0, 3.2, "w", _conc, _conc, z_tun)
	prop("metal_office_desk", CTRL + Vector3(1.6, 0, 0), -PI / 2.0, 1.0, true, z_tun)
	prop("server_rack", CTRL + Vector3(2.4, 0, -2.3), -PI / 2.0, 1.0, true, z_tun)
	prop("fuse_panel", CTRL + Vector3(-1.0, 1.4, -2.85), 0.0, 1.0, false, z_tun)
	box(Vector3(0.06, 0.5, 0.7), CTRL + Vector3(1.75, 1.2, 0), mat(Color(0.12, 0.12, 0.13), 0.4, 0.5), false, z_tun)
	var scr := newglow(Color(0.5, 0.95, 0.85), 1.2)
	box(Vector3(0.02, 0.4, 0.6), CTRL + Vector3(1.71, 1.2, 0), scr, false, z_tun)
	for k in 3:
		box(Vector3(0.05, 0.45, 0.6), CTRL + Vector3(2.85, 1.5, -1.2 + k * 1.2), mat(Color(0.03, 0.03, 0.04), 0.2), false, z_tun)
	var t := interactable("terminal", LINES["log7"]["prompt"], CTRL + Vector3(1.5, 1.1, 0), Vector3(0.8, 0.8, 1.0), LINES["log7"]["scan"], false, z_tun)
	t.set_meta("hackable", true)
	t.set_meta("route", true)
	_lamp(CTRL + Vector3(1.0, 1.4, 0), Color(0.5, 0.95, 0.85), 0.4, 4.0, z_tun)
	# Red Rock: the closet, Forner's frames in a ring of sticks
	_room(CLOSET, 4.0, 4.0, 3.0, "n", _conc, _dirt, z_tun)
	prop("plastic_crate_03", CLOSET + Vector3(0, 0, 0.2), 0.3, 1.0, true, z_tun)
	prop("steel_frame_shelves_01", CLOSET + Vector3(1.3, 0, 1.6), PI, 1.0, true, z_tun)
	prop("old_gas_mask", CLOSET + Vector3(1.2, 1.2, 1.6), 0.0, 1.0, false, z_tun)
	for k in 12:
		var a := TAU * k / 12.0
		stick(CLOSET + Vector3(cos(a) * 0.32, 0.36, 0.2 + sin(a) * 0.32), CLOSET + Vector3(cos(a + 0.5) * 0.32, 0.37, 0.2 + sin(a + 0.5) * 0.32), 0.012, stick_m, z_tun)
	var fr := Node3D.new()
	fr.position = CLOSET + Vector3(0, 0.38, 0.2)
	z_tun.add_child(fr)
	box(Vector3(0.15, 0.012, 0.05), Vector3.ZERO, mat(Color(0.05, 0.05, 0.06), 0.3, 0.4), false, fr)
	for s: float in [-1.0, 1.0]:
		box(Vector3(0.06, 0.035, 0.008), Vector3(s * 0.04, 0.006, 0.025), mat(Color(0.3, 0.6, 0.55), 0.05, 0.6), false, fr)
		box(Vector3(0.006, 0.006, 0.14), Vector3(s * 0.072, 0.0, -0.05), mat(Color(0.05, 0.05, 0.06), 0.3), false, fr)
	box(Vector3(0.012, 0.012, 0.03), Vector3(0.072, 0.0, -0.04), mat(Color(0.8, 0.8, 0.75), 0.9), false, fr)
	var f := interactable("forner", LINES["forner"]["prompt"], CLOSET + Vector3(0, 0.5, 0.2), Vector3(0.9, 0.6, 0.9), LINES["forner"]["scan"], false, z_tun)
	f.set_meta("route", true)
	_lamp(CLOSET + Vector3(0, 2.4, 0), Color(0.8, 0.85, 1.0), 0.2, 4.0, z_tun)


# ------------------------------------------------------------------ Rail Cut: the mouth

## The bore opens out to the mouth, 160 feet across: seven rings of rock
## widening and rising to the cliff face, the rails running out of it.
func _funnel() -> void:
	var n := 7
	var seg := (RC_FACE - RC_FUN) / n
	var prev_w := BW
	var prev_h := BH
	for i in n:
		var t := (i + 1.0) / n
		var w := lerpf(BW, 48.0, pow(t, 1.4))
		var h := lerpf(BH, 30.0, pow(t, 1.3))
		var x := RC_FUN + seg * (i + 0.5)
		box(Vector3(seg + 0.2, 0.2, w + 0.5), Vector3(x, -0.08, 0), _dirt, false, z_rc)
		for s: float in [-1.0, 1.0]:
			box(Vector3(seg + 0.3, h, 2.2), Vector3(x, h / 2.0, s * (w / 2.0 + 1.1)), _sand, true, z_rc)
			# the step between rings, filled
			var fw := (w - prev_w) / 2.0 + 2.2
			box(Vector3(0.8, h, fw), Vector3(x - seg / 2.0, h / 2.0, s * (prev_w / 2.0 + fw / 2.0)), _sand, false, z_rc)
		box(Vector3(seg + 0.3, 2.4, w + 4.4), Vector3(x, h + 1.2, 0), _sand_d, false, z_rc)
		box(Vector3(0.8, h - prev_h + 2.4, w + 4.4), Vector3(x - seg / 2.0, prev_h + (h - prev_h) / 2.0 + 1.2, 0), _sand_d, false, z_rc)
		prev_w = w
		prev_h = h
	_rails(Vector3(RC_FUN, 0, 0), Vector3(1, 0, 0), RC_FACE - RC_FUN + 66.0, -1.7, z_rc)
	# fallen rock in the funnel
	for i in 16:
		var p := Vector3(rng.randf_range(RC_FUN + 8.0, RC_FACE - 2.0), 0.2, rng.randf_range(-18.0, 18.0))
		if absf(p.z - 1.7) < 2.2:
			p.z += 4.5
		var s := sphere(rng.randf_range(0.4, 1.6), p, _sand_d, 7, z_rc)
		s.scale = Vector3(1.3, 0.6, 1.1)
	# the eye the frames put there: blood-red, filling the mouth
	var em := newmat(Color(1, 1, 1), 1.0)
	em.albedo_texture = _eye_tex(Color(0.95, 0.04, 0.03), false)
	em.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	em.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	em.disable_fog = true
	big_eye = quad(Vector2(46.0, 28.75), Vector3(RC_FACE - 4.0, 14.0, 0), PI / 2.0, em, dyn)
	big_eye.visible = false
	st_eye = quad(Vector2(7.0, 4.4), Vector3(0, 3.0, ST_PORTAL - 0.4), 0.0, em, dyn)
	st_eye.visible = false
	rr_eye = quad(Vector2(3.2, 2.0), Vector3(-47.6, RR_PLAT_Y + 1.6, -2.0), -PI / 2.0, em, dyn)
	rr_eye.visible = false
	eye_flash = _lamp(Vector3(RC_FACE + 6.0, 10.0, 0), Color(1.0, 0.05, 0.03), 0.0, 60.0, dyn)
	var m := interactable("rc_mouth", "The mouth", Vector3(RC_FACE + 1.0, 4.0, 0), Vector3(1.0, 8.0, 40.0), LINES["rc"]["overlay"], false, z_rc)
	m.set_meta("route", true)


# ------------------------------------------------------------------ Rail Cut: the depot and the street

## "Broken drills sat rusting in a graveyard of industrial decay. Across
## the expanse, a gaping hole... carved into the side of the mountain."
## The mountain, the yard, the depot shed, the fence and the sign, the
## street three blocks up with the car, the city behind it and the tower.
func _railcut() -> void:
	# the mountain round the mouth (the funnel's last ring is 48 wide, 30 high)
	box(Vector3(70, 72, 180), Vector3(RC_FACE - 35.0, 36.0, -26.0 - 90.0), _sand, true, z_rc)
	box(Vector3(70, 72, 180), Vector3(RC_FACE - 35.0, 36.0, 26.0 + 90.0), _sand, true, z_rc)
	box(Vector3(70, 40, 52), Vector3(RC_FACE - 35.0, 32.0 + 20.0, 0), _sand, false, z_rc)
	for s: float in [-1.0, 1.0]:
		var c1 := box(Vector3(9, 9, 9), Vector3(RC_FACE - 0.5, 30.5, s * 23.5), _sand, false, z_rc)
		c1.rotation.x = PI / 4.0
	for i in 14:
		var z := rng.randf_range(-190.0, 190.0)
		if absf(z) < 30.0:
			continue
		var h := rng.randf_range(10.0, 30.0)
		var b := box(Vector3(rng.randf_range(12, 30), h, rng.randf_range(14, 34)), Vector3(RC_FACE - rng.randf_range(20, 60), 72.0 + h / 2.0 - 4.0, z), _sand_d, false, z_rc)
		b.rotation.y = rng.randf() * 0.6
	# the yard: gravel and broken asphalt
	box(Vector3(100, 0.2, 180), Vector3(RC_FACE + 50.0, -0.08, 0), _asph, false, z_rc)
	var grit := mat(Color(0.22, 0.17, 0.14), 1.0)
	for i in 30:
		var q := floor_quad(Vector2(rng.randf_range(2, 7), rng.randf_range(2, 6)), Vector3(rng.randf_range(RC_FACE + 2, 205), 0.03, rng.randf_range(-60, 60)), rng.randf() * PI, grit, z_rc)
		q.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	# the broken drills: three cutterheads tipped over, a TBM shield on its side
	for d: Array in [[Vector3(140.0, 0, -18.0), 0.35, 0.4], [Vector3(152.0, 0, 16.0), 1.2, -0.3], [Vector3(166.0, 0, -32.0), 0.9, 1.1]]:
		_cutterhead(d[0], d[1], d[2])
	var shield := cyl(3.6, 3.6, 13.0, Vector3(178.0, 3.4, 22.0), _rust, 20, z_rc)
	shield.rotation = Vector3(PI / 2.0, 0.5, 0)
	for k in 5:
		var rg := cyl(3.75, 3.75, 0.35, Vector3.ZERO, _steel, 20, z_rc)
		rg.transform = Transform3D(Basis(Vector3.UP, 0.5) * Basis(Vector3.RIGHT, PI / 2.0), Vector3(178.0, 3.4, 22.0) + Basis(Vector3.UP, 0.5) * Vector3(0, 0, -5.5 + k * 2.75))
	interactable("drills", "The drills", Vector3(152.0, 2.0, 16.0), Vector3(9.0, 4.0, 9.0), "TUNELET TBM-2 CUTTERHEAD\nstatus: SCRAP\nowner: (dissolved)", false, z_rc)
	# the depot shed: corrugated tin, the shutter half up, the sign dead
	var tin := pbr("rust", Vector3.ONE / 3.0, true, Color(0.55, 0.55, 0.58))
	var shed := Vector3(190.0, 0, -36.0)
	box(Vector3(22, 0.4, 14), shed + Vector3(0, 7.2, 0), tin, false, z_rc)
	box(Vector3(22, 7, 0.3), shed + Vector3(0, 3.5, -7.0), tin, true, z_rc)
	for s: float in [-1.0, 1.0]:
		box(Vector3(0.3, 7, 14), shed + Vector3(s * 11.0, 3.5, 0), tin, true, z_rc)
	box(Vector3(8, 7, 0.3), shed + Vector3(-7.0, 3.5, 7.0), tin, true, z_rc)
	box(Vector3(8, 7, 0.3), shed + Vector3(7.0, 3.5, 7.0), tin, true, z_rc)
	box(Vector3(6, 3.2, 0.2), shed + Vector3(0, 5.4, 7.0), tin, false, z_rc)
	prop("rollershutter_door", shed + Vector3(0, 2.6, 7.1), PI, 1.0, false, z_rc)
	box(Vector3(22, 0.3, 14), shed + Vector3(0, -0.05, 0), _conc, false, z_rc)
	for k in 5:
		prop("steel_frame_shelves_01", shed + Vector3(-9.0 + k * 2.2, 0, -6.2), 0.0, 1.0, true, z_rc)
	neon_text("TUNELET", shed + Vector3(-3.5, 8.6, 7.2), 0.0, 1.4, Color(0.3, 0.08, 0.06), 0.3, z_rc)
	neon_text("DEPOT 2", shed + Vector3(4.0, 8.6, 7.2), 0.0, 1.0, Color(0.3, 0.08, 0.06), 0.3, z_rc)
	interactable("depot", "The depot", shed + Vector3(0, 1.6, 7.6), Vector3(6.0, 3.0, 0.6), "TUNELET DEPOT 2\nsealed: 7 YEARS\npower: NONE", false, z_rc)
	flicker_l = _lamp(shed + Vector3(0, 4.0, 4.0), Color(1.0, 0.85, 0.6), 0.6, 10.0, z_rc)
	# the fence, the gate open, the sign
	var post := mat(Color(0.3, 0.3, 0.32), 0.6, 0.7)
	var mesh_m := mat(Color(0.22, 0.22, 0.24), 0.6, 0.6)
	for z in range(-80, 81, 4):
		if absf(z) < 6:
			continue
		box(Vector3(0.1, 2.6, 0.1), Vector3(204.0, 1.3, z), post, false, z_rc)
		box(Vector3(0.02, 2.2, 4.0), Vector3(204.0, 1.3, z + 2.0), mesh_m, false, z_rc)
	solid_box(Vector3(0.4, 3.0, 74), Vector3(204.0, 1.5, -43.0), z_rc)
	solid_box(Vector3(0.4, 3.0, 74), Vector3(204.0, 1.5, 43.0), z_rc)
	var gate := box(Vector3(0.08, 2.4, 5.5), Vector3(203.0, 1.25, -8.2), post, false, z_rc)
	gate.rotation.y = 1.0
	box(Vector3(0.1, 1.2, 2.4), Vector3(204.2, 2.4, 7.2), mat(Color(0.8, 0.78, 0.7), 0.7), false, z_rc)
	label("TUNELET\nKEEP OFF THE TRACKS", Vector3(204.3, 2.5, 7.2), PI / 2.0, 0.0035, Color(0.12, 0.1, 0.1), z_rc, false).font_size = 48
	_glyph_on(Vector3(204.32, 1.95, 7.6), PI / 2.0, 0.003, "tu_glyph_sign", false, false,
		"Under the sign's older layer, PSYONIC INTEGRATIONS, under that, two rings, small, in marker. The first word the city ever learned to say twice.")
	interactable("rc_sign", "The sign", Vector3(204.4, 2.4, 7.2), Vector3(0.3, 1.2, 2.4), "", false, z_rc)
	# yard dressing: barriers, tyres, a dead security light, a rat on the rail
	for p: Array in [["concrete_road_barrier", Vector3(196.0, 0, 12.0), 1.4], ["concrete_road_barrier", Vector3(198.0, 0, -14.0), 0.2],
			["old_tyre", Vector3(160.0, 0, 4.0), 0.0], ["old_tyre", Vector3(161.0, 0.25, 5.0), 0.7], ["Barrel_01", Vector3(147.0, 0, 30.0), 0.0],
			["Barrel_01", Vector3(148.2, 0, 31.0), 0.4], ["security_light", Vector3(200.0, 4.0, -29.0), PI / 2.0], ["power_box_01", Vector3(200.5, 0, -24.0), -PI / 2.0],
			["utility_box_01", Vector3(185.0, 0, 30.0), 0.0], ["metal_trash_can", Vector3(201.0, 0, 18.0), 0.0], ["plastic_crate_03", Vector3(172.0, 0, -12.0), 0.5]]:
		prop(p[0], p[1], p[2], 1.0, true, z_rc)
	var rat := prop("street_rat", Vector3(150.0, 0.14, 1.0), PI / 2.0, 1.0, false, z_rc)
	interactable("rat", "The rat", Vector3(150.0, 0.25, 1.0), Vector3(0.6, 0.4, 0.6), "", false, z_rc)
	if rat:
		rat.set_meta("prop", true)
	# the street, three blocks from the depot: empty, lit, nobody on it
	box(Vector3(14, 0.1, 400), Vector3(222.0, -0.04, 0), _asph, false, z_rc)
	var walk := pbr("paving", Vector3.ONE / 2.0, true, Color(0.5, 0.5, 0.52))
	box(Vector3(4, 0.16, 400), Vector3(213.0, 0.03, 0), walk, false, z_rc)
	box(Vector3(4, 0.16, 400), Vector3(231.0, 0.03, 0), walk, false, z_rc)
	var line_m := mat(Color(0.75, 0.72, 0.6), 0.6)
	for i in 40:
		box(Vector3(0.18, 0.02, 3.0), Vector3(222.0, 0.02, -195.0 + i * 10.0), line_m, false, z_rc)
	var wet := mat(Color(0.02, 0.02, 0.03), 0.04, 0.5)
	for i in 18:
		floor_quad(Vector2(rng.randf_range(1.5, 4.0), rng.randf_range(1.0, 2.5)), Vector3(rng.randf_range(216.0, 228.0), 0.025, rng.randf_range(-80, 80)), rng.randf() * PI, wet, z_rc)
	kit_parent = z_rc
	var z := -150.0
	while z < 150.0:
		var w := rng.randf_range(14.0, 22.0)
		cyber_block(Vector3(233.0, 0, z + w / 2.0), -PI / 2.0, w, rng.randf_range(14.0, 70.0), 18.0, true, 0 if absf(z) < 60.0 else 1)
		z += w + 0.4
	# across the street, behind the car: low units, and a wall of signs north
	z = -150.0
	while z < 150.0:
		var w := rng.randf_range(12.0, 18.0)
		if absf(z + w / 2.0) > 24.0:
			cyber_block(Vector3(211.0, 0, z + w / 2.0), PI / 2.0, w, rng.randf_range(8.0, 16.0), 8.0, true, 1)
		z += w + 0.4
	for k in 3:
		cyber_block(Vector3(222.0 + (k - 1) * 22.0, 0, -160.0), 0.0, 20.0, rng.randf_range(50.0, 110.0), 20.0, false, 1)
	kit_holo(Vector3(222.0, 14.0, -40.0), 0.0, "PSYON", "the pillow for those who dream", Color(0.1, 0.92, 1.0), 14.0)
	kit_holo(Vector3(222.0, 10.0, 46.0), PI, "STAY INDOORS", "Glitch Day  -  Psyonic Integrations", Color(1.0, 0.18, 0.62), 12.0)
	kit_parent = self
	for k in 6:
		var zc := -60.0 + k * 24.0
		cable(Vector3(212.0, 9.0 + k % 2, zc), Vector3(232.0, 11.0, zc + 3.0), 1.4)
	for zc: float in [-36.0, -6.0, 26.0]:
		prop("street_lamp_01", Vector3(215.2, 0, zc), PI / 2.0, 1.0, true, z_rc)
		_lamp(Vector3(216.5, 6.0, zc), SODIUM, 1.1, 16.0, z_rc)
	_lamp(Vector3(226.0, 8.0, -40.0), Color(0.2, 0.9, 1.0), 0.8, 18.0, z_rc)
	_lamp(Vector3(226.0, 6.0, 46.0), Color(1.0, 0.2, 0.6), 0.8, 16.0, z_rc)
	prop("fire_hydrant", Vector3(213.5, 0.1, 14.0), 0.0, 1.0, true, z_rc)
	prop("vending_kiosk", Vector3(212.0, 0.1, -18.0), PI / 2.0, 1.0, true, z_rc)
	prop("police_drone", Vector3(222.0, 12.0, -20.0), 0.6, 1.0, false, z_rc)
	_tower(Vector3(260.0, 0, -1500.0))


## A TBM cutterhead the size of a house, tipped in the gravel, the teeth
## rusted to stubs.
func _cutterhead(p: Vector3, tilt: float, yaw: float) -> void:
	var root := Node3D.new()
	root.position = p + Vector3(0, 3.0 * cos(tilt) + 0.6, 0)
	root.rotation = Vector3(tilt, yaw, 0)
	z_rc.add_child(root)
	var disc := cyl(4.0, 4.0, 1.1, Vector3.ZERO, _rust, 24, root)
	disc.rotation.x = PI / 2.0
	cyl(1.1, 1.3, 1.6, Vector3(0, 0, -0.5), _steel, 12, root).rotation.x = PI / 2.0
	for k in 6:
		var a := TAU * k / 6.0
		var sp := box(Vector3(0.6, 3.6, 0.5), Vector3(cos(a) * 2.0, sin(a) * 2.0, -0.6), _rust, false, root)
		sp.rotation.z = a + PI / 2.0
	for k in 22:
		var a := TAU * k / 22.0
		var r := 3.8 if k % 2 == 0 else 2.6
		var t := box(Vector3(0.3, 0.3, 0.5), Vector3(cos(a) * r, sin(a) * r, -0.7), _steel, false, root)
		t.rotation.z = a
	solid_box(Vector3(7.0, 3.0, 7.0), p + Vector3(0, 1.5, 0), z_rc)


## Psyonic HQ on the horizon: "levitating, angular, inhuman... a monolith
## in service of the Eye." Jade, the silver ring, red lights.
func _tower(tp: Vector3) -> void:
	var jade := mat(Color(0.12, 0.3, 0.26), 0.3, 0.7)
	var silver := mat(Color(0.5, 0.52, 0.56), 0.25, 0.85)
	cyl(50.0, 56.0, 36.0, tp + Vector3(0, 60.0, 0), jade, 24, z_rc)
	cyl(16.0, 30.0, 440.0, tp + Vector3(0, 300.0, 0), jade, 16, z_rc)
	var tm := TorusMesh.new()
	tm.inner_radius = 58.0
	tm.outer_radius = 108.0
	tm.rings = 32
	tm.ring_segments = 10
	mesh(tm, tp + Vector3(0, 560.0, 0), silver, z_rc)
	var seam := newglow(Color(0.35, 0.95, 0.85), 2.6)
	seam.disable_fog = true
	for s in 8:
		var a := s * TAU / 8.0
		for g in 6:
			var y := 100.0 + g * 70.0
			var rad := lerpf(30.0, 16.0, (y - 80.0) / 440.0) + 0.3
			var b := box(Vector3(1.6, 50.0, 1.6), tp + Vector3(sin(a) * rad, y, cos(a) * rad), seam, false, z_rc)
			b.rotation.y = a
	var red := newglow(Color(1, 0.05, 0.05), 5.0)
	red.disable_fog = true
	for k in 6:
		var a := k * TAU / 6.0
		blinkers.append(box(Vector3(4, 4, 4), tp + Vector3(cos(a) * 108.0, 560.0, sin(a) * 108.0), red, false, z_rc))


# ------------------------------------------------------------------ Southtown: the overpass mouth

## The overpass at the east end of Southtown: the deserted camp, the barrel
## stoves "like fallen monoliths", the piers with twenty years of rings, the
## glyph footprints (frames on) into TBM ACCESS 3.
func _southtown() -> void:
	var o := Vector3(0, 0, ST_PORTAL)
	# the embankment the portal is cut into
	for s: float in [-1.0, 1.0]:
		box(Vector3(76.5, 16.0, 6.0), o + Vector3(s * (3.5 + 38.25), 8.0, -3.0), _conc, true, z_st)
	box(Vector3(7.0, 10.0, 6.0), o + Vector3(0, 11.0, -3.0), _conc, false, z_st)
	box(Vector3(160.0, 20.0, 60.0), o + Vector3(0, 26.0, -36.0), _sand_d, false, z_st)
	box(Vector3(8.6, 0.6, 0.8), o + Vector3(0, 6.3, 0.2), _conc, false, z_st)
	for s: float in [-1.0, 1.0]:
		box(Vector3(0.6, 6.0, 0.8), o + Vector3(s * 4.0, 3.0, 0.2), _conc, false, z_st)
	label("TUNELET  -  TBM ACCESS 3\nNO ENTRY", o + Vector3(0, 7.3, 0.62), 0.0, 0.006, Color(0.85, 0.8, 0.7), z_st, false).font_size = 48
	var pi := interactable("st_portal", "The tunnel mouth", o + Vector3(0, 2.5, 0.6), Vector3(7.0, 5.0, 0.5), "TUNELET ACCESS 3\nstatus: OPEN\nchevron: IN", false, z_st)
	pi.set_meta("route", true)
	_glyph_on(o + Vector3(3.2, 4.4, 0.65), 0.0, 0.006, "tu_glyph_portal", true, false,
		"Two rings on the portal, red and new, beside the NO ENTRY. Painted by somebody on the way in, for somebody behind them.")
	# the bars across the portal: chained, unless Tyson has the key
	var gate := Node3D.new()
	gate.name = "st_gate"
	gate.position = o + Vector3(-3.5, 0, 0.35)
	dyn.add_child(gate)
	var bars := mat(Color(0.2, 0.2, 0.22), 0.5, 0.7)
	for k in 10:
		box(Vector3(0.06, 5.6, 0.06), Vector3(0.35 + k * 0.7, 2.8, 0), bars, false, gate)
	for yy: float in [1.2, 4.6]:
		box(Vector3(7.0, 0.08, 0.08), Vector3(3.5, yy, 0), bars, false, gate)
	stick(Vector3(6.6, 1.0, 0.05), Vector3(6.9, 1.4, 0.05), 0.03, mat(Color(0.7, 0.6, 0.2), 0.4, 0.8), gate)
	solid_box(Vector3(7.0, 5.6, 0.2), Vector3(3.5, 2.8, 0), gate)
	# the ground, the deck, the piers
	box(Vector3(170, 0.2, 90), o + Vector3(0, -0.08, 45.0), _asph, false, z_st)
	var deck := Vector3(0, 8.2, ST_PORTAL + 24.0)
	box(Vector3(150, 1.4, 14), deck, _conc, false, z_st)
	box(Vector3(150, 1.0, 0.4), deck + Vector3(0, 1.2, -7.0), _conc, false, z_st)
	box(Vector3(150, 1.0, 0.4), deck + Vector3(0, 1.2, 7.0), _conc, false, z_st)
	for x: float in [-26.0, -9.0, 9.0, 26.0]:
		box(Vector3(2.2, 8.2, 2.2), Vector3(x, 4.1, deck.z), _conc, true, z_st)
	interactable("st_layers", "The pier", Vector3(-9.0, 2.0, deck.z + 1.15), Vector3(2.4, 3.0, 0.4), "", false, z_st)
	for k in 9:
		var s := Sprite3D.new()
		s.texture = _glyph_tex
		s.pixel_size = 0.004 + k * 0.0006
		s.modulate = Color(0.85, 0.82, 0.78).darkened(0.08 * k) if k % 3 != 0 else Color(0.7, 0.1, 0.08).darkened(0.05 * k)
		s.position = Vector3(-9.0 + rng.randf_range(-0.5, 0.5), 1.6 + rng.randf_range(-0.6, 1.2), deck.z + 1.12 + k * 0.002)
		s.shaded = true
		z_st.add_child(s)
	# the camp: tarps, the barrel stoves on their sides, mattresses, a drain
	var tarp := mat(Color(0.16, 0.24, 0.36), 0.8)
	var tarp2 := mat(Color(0.38, 0.32, 0.22), 0.9)
	for i in 11:
		var p := Vector3(rng.randf_range(-24.0, 24.0), 0, rng.randf_range(ST_PORTAL + 18.0, ST_PORTAL + 32.0))
		if absf(p.x) < 4.0:
			p.x += 7.0 * signf(p.x + 0.01)
		var t := quad(Vector2(rng.randf_range(2.0, 3.6), 1.8), p + Vector3(0, 0.9, 0), rng.randf() * TAU, tarp if i % 2 == 0 else tarp2, z_st)
		t.rotation.x = -0.55
		for s: float in [-1.0, 1.0]:
			stick(p + Vector3(s * 1.2, 0, 0), p + Vector3(s * 1.2, 1.6, 0.3), 0.03, _steel, z_st)
		box(Vector3(1.0, 0.18, 1.9), p + Vector3(0.4, 0.09, 0.9), mat(Color(0.42, 0.38, 0.3), 1.0), false, z_st)
	for i in 6:
		var b := prop("Barrel_01", Vector3(rng.randf_range(-18.0, 18.0), 0.4, rng.randf_range(ST_PORTAL + 12.0, ST_PORTAL + 34.0)), rng.randf() * TAU, 1.0, false, z_st)
		if b:
			b.rotation.z = PI / 2.0
	prop("metal_trash_can", Vector3(-12.0, 0, ST_PORTAL + 14.0), 0.0, 1.0, true, z_st)
	prop("cardboard_box_01", Vector3(14.0, 0, ST_PORTAL + 20.0), 0.6, 1.0, true, z_st)
	box(Vector3(1.6, 0.06, 0.8), Vector3(6.0, 0.03, ST_PORTAL + 8.0), mat(Color(0.12, 0.12, 0.13), 0.5, 0.7), false, z_st)
	interactable("st_drain", "The storm drain", Vector3(6.0, 0.2, ST_PORTAL + 8.0), Vector3(1.6, 0.4, 0.8), "", false, z_st)
	# the footprints: two rings at every step, from the camp into the portal
	var path := [Vector3(-14.0, 0, ST_PORTAL + 30.0), Vector3(-8.0, 0, ST_PORTAL + 22.0), Vector3(-2.0, 0, ST_PORTAL + 12.0), Vector3(0.0, 0, ST_PORTAL + 1.0), Vector3(0.6, 0, ST_PORTAL - 10.0)]
	for i in path.size() - 1:
		var a: Vector3 = path[i]
		var b: Vector3 = path[i + 1]
		var n := int(a.distance_to(b) / 0.75)
		var dir := (b - a).normalized()
		for k in n:
			var q := a.lerp(b, float(k) / n) + Vector3(-dir.z, 0, dir.x) * (0.22 if k % 2 == 0 else -0.22)
			var s := Sprite3D.new()
			s.texture = _glyph_tex
			s.pixel_size = 0.0034
			s.modulate = Color(0.35, 1.0, 0.9, 0.85)
			s.position = q + Vector3(0, 0.07, 0)
			s.rotation.x = -PI / 2.0
			s.shaded = false
			s.visible = false
			dyn.add_child(s)
			footprints.append(s)
	interactable("footprints", "Look at the ground", Vector3(-4.0, 0.3, ST_PORTAL + 16.0), Vector3(8.0, 0.6, 10.0), "", false, z_st)
	# Southtown beyond: the fulfilment centre, blocks, an ad on the deck
	kit_parent = z_st
	var x := -80.0
	while x < 80.0:
		var w := rng.randf_range(14.0, 22.0)
		cyber_block(Vector3(x + w / 2.0, 0, ST_PORTAL + 64.0), PI, w, rng.randf_range(12.0, 48.0), 16.0, true, 1)
		x += w + 0.5
	kit_holo(Vector3(0, 13.5, deck.z + 7.4), 0.0, "TOKZ", "fulfilment that never sleeps", Color(1.0, 0.5, 0.12), 12.0)
	kit_parent = self
	neon_text("TOKZ  FULFILMENT", Vector3(-40.0, 10.0, ST_PORTAL + 63.6), PI, 1.6, Color(1.0, 0.85, 0.25), 2.4, z_st)
	_lamp(Vector3(0, 7.0, deck.z), SODIUM, 1.0, 20.0, z_st)
	_lamp(Vector3(0, 4.5, ST_PORTAL + 3.0), SODIUM, 0.6, 10.0, z_st)
	_lamp(Vector3(0, 8.0, deck.z + 12.0), Color(1.0, 0.5, 0.15), 0.6, 18.0, z_st)
	# Tyson's barrel, lit
	var bar := prop("Barrel_01", Vector3(-5.0, 0, 124.0), 0.0, 1.0, true, z_st)
	if bar:
		bar.set_meta("prop", true)
	var fm := newglow(Color(1.0, 0.45, 0.12), 3.0)
	cyl(0.25, 0.32, 0.25, Vector3(-5.0, 1.0, 124.0), fm, 8, dyn).name = "fire"
	fire_light = _lamp(Vector3(-5.0, 1.6, 124.0), Color(1.0, 0.5, 0.2), 1.4, 9.0, dyn)


# ------------------------------------------------------------------ Red Rock: the plaza, the station, the stair

## Red Rock Plaza at night (the sandstone city, the casino screens), the
## subway stair down to the platform, the platform with its dead train,
## the maintenance door, and the stair down again to the Tunelet layer.
func _redrock() -> void:
	var y := RR_Y
	var pave := pbr("paving", Vector3.ONE / 2.2, true, Color(0.62, 0.42, 0.34))
	# the plaza floor round the stair well (the well: x -104..-92, z -3..3)
	box(Vector3(76, 0.4, 84), Vector3(-142.0, y - 0.2, 0), pave, true, z_rr)
	for s: float in [-1.0, 1.0]:
		box(Vector3(9.5, 0.4, 39), Vector3(-99.25, y - 0.2, s * 22.5), pave, true, z_rr)
	solid_box(Vector3(80, 6, 1), Vector3(-140.0, y + 3.0, -42.5), z_rr)
	solid_box(Vector3(80, 6, 1), Vector3(-140.0, y + 3.0, 42.5), z_rr)
	solid_box(Vector3(1, 6, 90), Vector3(-180.5, y + 3.0, 0), z_rr)
	# the stair enclosure: rails, the red R
	for s: float in [-1.0, 1.0]:
		box(Vector3(12.4, 1.0, 0.2), Vector3(-98.0, y + 0.5, s * 3.1), _steel, true, z_rr)
	box(Vector3(0.3, 4.0, 0.3), Vector3(-104.6, y + 2.0, 3.6), _steel, false, z_rr)
	box(Vector3(5.8, 0.4, 6.4), Vector3(-95.1, y + 0.2, 0), _conc, false, z_rr)
	neon_text("R", Vector3(-104.6, y + 4.6, 3.6), -PI / 2.0, 1.2, Color(1.0, 0.15, 0.12), 3.0, z_rr)
	neon_text("RED ROCK", Vector3(-95.4, y + 7.0, 0), -PI / 2.0, 1.4, Color(1.0, 0.2, 0.15), 2.6, z_rr)
	_stair(Vector3(-104.0, y, 0), Vector3(1, 0, 0), 12.0, -6.0, 6.0, z_rr, pave)
	# the plaza's blocks: north and south rows, the west end, the facade over the stair
	kit_parent = z_rr
	_row(-178.0, ALLEY.x - 2.2, -43.0, 0.0, 20.0, 60.0, y)
	_row(ALLEY.x + 2.2, -100.0, -43.0, 0.0, 20.0, 60.0, y)
	_row(-178.0, -100.0, 43.0, PI, 18.0, 50.0, y)
	cyber_block(Vector3(-181.0, y, 0), PI / 2.0, 80.0, 30.0, 14.0, true, 1)
	cyber_block(Vector3(-94.5, y, -23.5), -PI / 2.0, 39.0, 36.0, 14.0, true, 1)
	cyber_block(Vector3(-94.5, y, 23.5), -PI / 2.0, 39.0, 26.0, 14.0, true, 1)
	kit_holo(Vector3(-140.0, y + 12.0, -10.0), PI / 2.0, "LUCKY EYE", "casino  -  open all night", Color(1.0, 0.18, 0.62), 14.0)
	kit_holo(Vector3(-122.0, y + 9.0, 18.0), -PI / 2.0, "PSYON", "Glitch Day: stay indoors", Color(0.1, 0.92, 1.0), 10.0)
	kit_parent = self
	for k in 5:
		var xc := -170.0 + k * 16.0
		cable(Vector3(xc, y + 12.0, -35.0), Vector3(xc + 6.0, y + 14.0, 35.0), 2.5)
	# the alley mouth and the man in it (frames on)
	box(Vector3(4.0, 0.3, 10.0), Vector3(ALLEY.x, y + 0.05, ALLEY.z - 3.0), _asph, false, z_rr)
	prop("metal_trash_can", ALLEY + Vector3(1.3, 0, -1.0), 0.3, 1.0, true, z_rr)
	prop("cardboard_box_01", ALLEY + Vector3(-1.2, 0, -2.5), 0.9, 1.0, true, z_rr)
	interactable("alley", "The alley", ALLEY + Vector3(0, 1.4, 1.6), Vector3(3.6, 2.8, 0.4), "", false, z_rr)
	for p: Array in [[Vector3(-150.0, y, -26.0), Color(1.0, 0.2, 0.62)], [Vector3(-120.0, y, 26.0), Color(0.15, 0.9, 1.0)], [Vector3(-166.0, y, 18.0), SODIUM], [Vector3(-110.0, y, -20.0), Color(1.0, 0.3, 0.2)]]:
		_lamp(p[0] + Vector3(0, 6.0, 0), p[1], 1.0, 22.0, z_rr)
	prop("street_lamp_01", Vector3(-150.0, y, -26.0), 0.0, 1.0, true, z_rr)
	prop("atm", Vector3(-112.0, y, 36.0), PI, 1.0, true, z_rr)
	prop("delivery_drone", Vector3(-130.0, y + 9.0, 10.0), 1.2, 1.0, false, z_rr)
	# the platform hall: x -92..-48, platform z -8..2 at y 6, the track pit z 2..8
	var py := RR_PLAT_Y
	box(Vector3(44, 0.4, 10), Vector3(-70.0, py - 0.2, -3.0), _conc, true, z_rr)
	box(Vector3(44, 0.4, 6), Vector3(-70.0, py - 1.4, 5.0), _conc, true, z_rr)
	box(Vector3(44, 1.2, 0.3), Vector3(-70.0, py - 0.6, 2.0), _conc, false, z_rr)
	box(Vector3(44, 0.03, 0.4), Vector3(-70.0, py + 0.02, 1.6), mat(Color(0.9, 0.75, 0.1), 0.6), false, z_rr)
	_rails(Vector3(-92.0, py - 1.2, 5.0), Vector3(1, 0, 0), 44.0, 0.0, z_rr)
	for s: float in [-1.0, 1.0]:
		box(Vector3(44, 7.4, 0.4), Vector3(-70.0, py + 2.3, s * 8.2), _tile, true, z_rr)
		box(Vector3(0.4, 7.4, 5.4), Vector3(-92.2, py + 2.3, s * 5.7), _tile, true, z_rr)
	box(Vector3(0.4, 2.7, 6.0), Vector3(-92.2, py + 4.35, 0), _tile, false, z_rr)
	box(Vector3(44, 0.4, 17), Vector3(-70.0, py + 5.7, 0), _conc, false, z_rr)
	# the east wall, with the maintenance door at z -3.5..-0.5
	box(Vector3(0.4, 6.0, 4.5), Vector3(-47.8, py + 2.6, -5.75), _tile, true, z_rr)
	box(Vector3(0.4, 6.0, 9.0), Vector3(-47.8, py + 2.6, 4.0), _tile, true, z_rr)
	box(Vector3(0.4, 3.0, 3.0), Vector3(-47.8, py + 4.1, -2.0), _tile, false, z_rr)
	label("MAINTENANCE  -  TUNELET INTERCHANGE\nAUTHORIZED PERSONNEL", Vector3(-48.05, py + 3.4, -2.0), -PI / 2.0, 0.003, Color(0.9, 0.85, 0.2), z_rr, false).font_size = 40
	var md := interactable("rr_stair", "The maintenance door", Vector3(-48.3, py + 1.2, -2.0), Vector3(0.4, 2.4, 2.8), "TUNELET INTERCHANGE\nlock: PROPPED\nchevron: DOWN", false, z_rr)
	md.set_meta("route", true)
	var stick_m := pbr("bark", Vector3(1, 3, 1), false, Color(0.8, 0.6, 0.4))
	for k in 10:
		var a := TAU * k / 10.0
		stick(Vector3(-48.6 + cos(a) * 0.4, py + 0.05, -1.0 + sin(a) * 0.4), Vector3(-48.6 + cos(a + 0.6) * 0.4, py + 0.06, -1.0 + sin(a + 0.6) * 0.4), 0.015, stick_m, z_rr)
	for xc: float in [-86.0, -76.0, -66.0, -56.0]:
		box(Vector3(0.6, 5.6, 0.6), Vector3(xc, py + 2.8, -7.0), _tile, true, z_rr)
		prop("mounted_fluorescent_lights", Vector3(xc + 5.0, py + 5.4, -3.0), 0.0, 1.0, false, z_rr)
	label("RED ROCK", Vector3(-70.0, py + 3.6, -7.9), 0.0, 0.008, Color(0.95, 0.95, 0.9), z_rr, false).font_size = 72
	var station := interactable("rr_station", "The platform", Vector3(-70.0, py + 1.5, -6.0), Vector3(6.0, 3.0, 0.4), "", false, z_rr)
	station.set_meta("route", true)
	for xc: float in [-82.0, -64.0]:
		_lamp(Vector3(xc, py + 4.8, -3.0), Color(0.85, 0.95, 1.0), 0.9, 14.0, z_rr)
	# the dead train, doors open, seats empty
	var train := Node3D.new()
	train.position = Vector3(-72.0, py - 1.2, 5.0)
	z_rr.add_child(train)
	var body_m := mat(Color(0.6, 0.62, 0.64), 0.4, 0.6)
	box(Vector3(30.0, 3.2, 3.0), Vector3(0, 2.0, 0), body_m, true, train)
	box(Vector3(30.2, 0.3, 3.1), Vector3(0, 3.2, 0), mat(Color(0.8, 0.12, 0.1), 0.5), false, train)
	var win := newglow(Color(0.7, 0.85, 0.9), 0.5)
	for k in 9:
		box(Vector3(1.6, 0.9, 0.04), Vector3(-12.0 + k * 3.0, 2.6, -1.52), win, false, train)
	# the maintenance stair: platform level down to the Tunelet layer
	_stair(Vector3(-48.0, py, -2.0), Vector3(1, 0, 0), 12.0, -6.0, 3.0, z_rr, _conc)
	for s: float in [-1.0, 1.0]:
		box(Vector3(12.0, 6.6, 0.4), Vector3(-42.0, 3.3, -2.0 + s * 1.7), _conc, true, z_rr)
	box(Vector3(12.0, 0.4, 3.8), Vector3(-42.0, py + 3.2, -2.0), _conc, false, z_rr)
	_lamp(Vector3(-42.0, 4.0, -2.0), Color(1.0, 0.7, 0.4), 0.4, 7.0, z_rr)


## A stair from top t along dir, `run` long, dropping `drop`: steps to look
## at, a smooth slope underneath to walk on.
func _stair(t: Vector3, dir: Vector3, run: float, drop: float, w: float, par: Node, m: Material) -> void:
	var yaw := atan2(dir.x, dir.z)
	var bs := Basis(Vector3.UP, yaw)
	var n := int(absf(drop) / 0.3)
	var rise := drop / n
	var tread := run / n
	for i in n:
		var top := t.y + rise * (i + 1)
		var p := t + dir * (tread * (i + 0.5))
		_xbox(Vector3(w, 0.3, tread + 0.02), Transform3D(bs, Vector3(p.x, top - 0.15, p.z)), m, false, par)
	var ang := atan2(-drop, run)
	var mid := t + dir * (run / 2.0) + Vector3(0, drop / 2.0 - 0.12, 0)
	var sb := StaticBody3D.new()
	sb.transform = Transform3D(bs * Basis(Vector3.RIGHT, ang), mid)
	var cs := CollisionShape3D.new()
	var sh := BoxShape3D.new()
	sh.size = Vector3(w, 0.2, sqrt(run * run + drop * drop))
	cs.shape = sh
	sb.add_child(cs)
	par.add_child(sb)


## A row of city blocks filling x0..x1 along the line z, facing rot.
func _row(x0: float, x1: float, z: float, rot: float, hmin: float, hmax: float, y: float) -> void:
	var x := x0
	while x1 - x > 4.0:
		var w := minf(rng.randf_range(12.0, 18.0), x1 - x)
		if x1 - x - w < 8.0:
			w = x1 - x
		cyber_block(Vector3(x + w / 2.0, y, z), rot, w, rng.randf_range(hmin, hmax), 16.0, true, 0)
		x += w


# ------------------------------------------------------------------ below the hub: the green

## The circular chamber in the green floodlight, the ladder down the
## middle of it, the corridor north with its doors and its gallery, the
## room of the two doors, the green hall behind the left one and the void
## behind the right.
func _lower() -> void:
	var y := LOW
	var green_l := newglow(GREEN, 2.2)
	green_l.disable_fog = true
	var strip := newglow(GREEN, 1.3)
	# the chamber
	_ring_room(CH, CH_R, 8.0, 18, [PI], 0.25, _conc_low, _conc_low, _conc_low, z_low)
	for s: float in [-1.0, 1.0]:
		box(Vector3(1.6, 8.0, 1.2), Vector3(s * 2.45, y + 4.0, CH.z - CH_R - 0.4), _conc_low, true, z_low)
	var paint := Sprite3D.new()
	paint.texture = _glyph_tex
	paint.pixel_size = 0.055
	paint.modulate = Color(0.32, 0.07, 0.05, 0.9)
	paint.rotation.x = -PI / 2.0
	paint.position = CH + Vector3(0, 0.04, 0)
	paint.shaded = true
	z_low.add_child(paint)
	for k in 6:
		var a := PI + 0.9 + k * (TAU - 1.8) / 5.0
		var d := Vector3(sin(a), 0, cos(a))
		var fp := CH + d * (CH_R - 0.25) + Vector3(0, 5.2, 0)
		var fx := box(Vector3(0.9, 0.6, 0.45), fp, _steel, false, z_low)
		fx.rotation.y = a
		var lens := quad(Vector2(0.7, 0.42), fp - d * 0.24, a + PI, green_l, z_low)
		lens.rotation.x = -0.3
		for g in 3:
			var bar := box(Vector3(0.04, 0.5, 0.04), fp - d * 0.3 + Basis(Vector3.UP, a) * Vector3(-0.25 + g * 0.25, 0, 0), _steel, false, z_low)
			bar.rotation.y = a
	for k in 4:
		var a := PI / 4.0 + k * PI / 2.0
		_lamp(CH + Vector3(sin(a), 0, cos(a)) * 5.5 + Vector3(0, 5.0, 0), GREEN, 1.1, 13.0, z_low)
	interactable("flood", "The floodlight", CH + Vector3(sin(PI + 0.9), 0, cos(PI + 0.9)) * (CH_R - 0.6) + Vector3(0, 5.2, 0), Vector3(1.2, 1.0, 1.2), "FLOOD  -  TUNELET\nspectrum: (none matching)\nCRI: --", false, z_low)
	# the shaft and the ladder, "spiraled downward"
	var shaft_m := _conc_low.duplicate() as StandardMaterial3D
	shaft_m.cull_mode = BaseMaterial3D.CULL_DISABLED
	cyl(0.95, 0.95, 6.2, Vector3(CH.x, LOW + 11.0, CH.z), shaft_m, 14, z_low)
	for s: float in [-1.0, 1.0]:
		stick(Vector3(s * 0.3, y, CH.z - 0.55), Vector3(s * 0.3, LOW + 14.0, CH.z - 0.55), 0.025, _rust, z_low)
	var r := y + 0.3
	while r < LOW + 13.8:
		box(Vector3(0.6, 0.035, 0.035), Vector3(0, r, CH.z - 0.55), _rust, false, z_low)
		r += 0.32
	var prev := Vector3(0.8, y + 2.0, CH.z)
	for k in range(1, 40):
		var a := k * 0.55
		var p := Vector3(cos(a) * 0.8, y + 2.0 + k * 0.3, CH.z + sin(a) * 0.8)
		if p.y > LOW + 13.7:
			break
		stick(prev, p, 0.02, _rust, z_low)
		prev = p
	interactable("ladder", "The ladder", Vector3(0, y + 1.4, CH.z - 0.55), Vector3(0.8, 2.6, 0.3), "", false, z_low)
	# the narrow corridor to door A
	_corridor(CH.z - CH_R - 0.4, DOOR_A_Z, 3.2, 3.4, _conc_low, strip, z_low)
	_lamp(Vector3(0, y + 3.0, LZ - 20.0), GREEN, 0.7, 9.0, z_low)
	_cross_wall(DOOR_A_Z, 3.2, 3.4, _conc_low)
	# the gallery: older, rougher; pillars, the speaker, the false door
	_corridor(DOOR_A_Z, DOOR_B_Z, 8.0, 4.6, _sand_d, strip, z_low)
	for z: float in [LZ - 32.0, LZ - 38.0, LZ - 44.0]:
		for s: float in [-1.0, 1.0]:
			box(Vector3(0.7, 4.6, 0.7), Vector3(s * 2.2, y + 2.3, z), _sand, true, z_low)
	_lamp(Vector3(0, y + 3.8, LZ - 31.0), GREEN, 0.7, 10.0, z_low)
	_lamp(Vector3(0, y + 3.8, LZ - 45.0), GREEN, 0.6, 10.0, z_low)
	box(Vector3(0.25, 0.7, 0.5), SPEAKER, _steel, false, z_low)
	var grille := mat(Color(0.04, 0.04, 0.045), 0.5, 0.6)
	for k in 5:
		box(Vector3(0.03, 0.04, 0.4), SPEAKER + Vector3(0.13, -0.24 + k * 0.12, 0), grille, false, z_low)
	speaker_led = box(Vector3(0.03, 0.05, 0.05), SPEAKER + Vector3(0.14, 0.3, 0.18), newglow(GREEN, 4.0), false, dyn)
	stick(SPEAKER + Vector3(0, 0.35, 0), SPEAKER + Vector3(0, 2.0, 0), 0.02, _black, z_low)
	var sp := interactable("speaker", LINES["speaker"]["prompt"], SPEAKER + Vector3(0.2, 0, 0), Vector3(0.4, 0.9, 0.7), LINES["speaker"]["scan"], false, z_low)
	sp.set_meta("hackable", true)
	# door C: only in the eye layer; with the frames off, sandstone
	var dc := Node3D.new()
	dc.position = DOOR_C
	dyn.add_child(dc)
	box(Vector3(0.12, 2.7, 1.7), Vector3(-0.08, 1.35, 0), _steel, false, dc)
	box(Vector3(0.14, 0.18, 1.9), Vector3(-0.09, 2.75, 0), _rust, false, dc)
	var ring := Sprite3D.new()
	ring.texture = _glyph_tex
	ring.pixel_size = 0.014
	ring.modulate = Color(1.0, 0.12, 0.08)
	ring.shaded = false
	ring.position = Vector3(-0.16, 1.6, 0)
	ring.rotation.y = -PI / 2.0
	dc.add_child(ring)
	eye_layer.append(dc)
	var ci := interactable("door_c", LINES["corridor"]["speak_prompt"], DOOR_C + Vector3(-0.3, 1.3, 0), Vector3(0.4, 2.6, 1.6), "DOOR  -  (no record)\nlayer: EYE ONLY", false, z_low)
	eye_its.append(ci)
	_cross_wall(DOOR_B_Z, 8.0, 4.6, _sand_d)
	# the second narrow stretch, the hymn ahead
	_corridor(DOOR_B_Z, TD.z + TD_R, 4.4, 3.4, _conc_low, strip, z_low)
	_lamp(Vector3(0, y + 3.0, LZ - 56.0), GREEN, 0.6, 9.0, z_low)
	# the room of the two doors
	_ring_room(TD, TD_R, 5.0, 14, [0.0, PI], 0.3, _conc_low, _conc_low, _conc_low, z_low)
	for s: float in [-1.0, 1.0]:
		box(Vector3(1.0, 5.0, 1.0), Vector3(s * 2.7, y + 2.5, TD.z + TD_R + 0.3), _conc_low, true, z_low)
		box(Vector3(0.4, 5.0, 4.6), Vector3(s * 6.9, y + 2.5, DOOR_Z + 2.3), _conc_low, true, z_low)
	var dz := DOOR_Z - 0.2
	box(Vector3(3.8, 5.0, 0.4), Vector3(-5.3, y + 2.5, dz), _conc_low, true, z_low)
	box(Vector3(3.8, 5.0, 0.4), Vector3(5.3, y + 2.5, dz), _conc_low, true, z_low)
	box(Vector3(2.8, 5.0, 0.4), Vector3(0, y + 2.5, dz), _conc_low, true, z_low)
	for s: float in [-1.0, 1.0]:
		box(Vector3(2.0, 2.0, 0.4), Vector3(s * DOOR_X, y + 4.0, dz), _conc_low, false, z_low)
		box(Vector3(2.3, 0.2, 0.5), Vector3(s * DOOR_X, y + 3.05, dz), _steel, false, z_low)
	# the readers on the pillar between the doors, and a hundred offerings
	var blood := decal_mat(_blood_tex(), Color(1, 1, 1), 0.4)
	var red_l := newglow(Color(1.0, 0.08, 0.05), 2.4)
	for s: float in [-1.0, 1.0]:
		var rp := Vector3(s * 0.75, y + 1.35, dz + 0.22)
		box(Vector3(0.36, 0.5, 0.06), rp, _steel, false, z_low)
		box(Vector3(0.22, 0.22, 0.02), rp + Vector3(0, 0.04, 0.035), mat(Color(0.2, 0.03, 0.02), 0.15, 0.3), false, z_low)
		box(Vector3(0.26, 0.02, 0.02), rp + Vector3(0, -0.15, 0.035), red_l, false, z_low)
		quad(Vector2(0.6, 1.2), rp + Vector3(0, -0.55, 0.04), 0.0, blood, z_low)
		var st := floor_quad(Vector2(1.2, 0.9), Vector3(s * 0.75, y + 0.02, dz + 0.8), 0.3 * s, mat(Color(0.16, 0.02, 0.015), 0.3), z_low)
		st.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		var ri := interactable("reader_r" if s > 0 else "reader_l", LINES["two"]["reader_prompt"], rp + Vector3(0, 0, 0.15), Vector3(0.5, 0.6, 0.3), LINES["two"]["reader_scan"], false, z_low)
		ri.set_meta("hackable", true)
	_lamp(Vector3(0, y + 4.2, TD.z), GREEN, 0.9, 11.0, z_low)
	_lamp(Vector3(0, y + 1.4, dz + 0.8), Color(1.0, 0.1, 0.06), 0.5, 4.0, z_low)
	var kn := interactable("kneel", LINES["two"]["kneel_prompt"], TD + Vector3(0, 0.3, -1.0), Vector3(2.2, 0.6, 2.2), "", false, z_low)
	kn.set_meta("route", true)
	# the frames' words over the doors (eye layer)
	for t: Array in [["SALVATION", -DOOR_X], ["BLOOD SACRAMENT", DOOR_X]]:
		var lb := label(t[0], Vector3(t[1], y + 3.7, dz + 0.25), 0.0, 0.0045, Color(1.0, 0.3, 0.25), dyn, false)
		lb.font_size = 56
		lb.no_depth_test = true
		lb.shaded = false
		eye_layer.append(lb)
	# behind the left door: the green hall
	_corridor(DOOR_Z - 0.4, DOOR_Z - 22.0, 2.4, 3.2, _conc_low, strip, z_low, -DOOR_X)
	box(Vector3(2.8, 3.2, 0.4), Vector3(-DOOR_X, y + 1.6, DOOR_Z - 22.2), _conc_low, true, z_low)
	_lamp(Vector3(-DOOR_X, y + 2.8, DOOR_Z - 6.0), GREEN, 1.0, 9.0, z_low)
	_lamp(Vector3(-DOOR_X, y + 2.8, DOOR_Z - 16.0), GREEN, 0.8, 9.0, z_low)
	# behind the right: nothing. "Light didn't even try to touch it."
	void_box = box(Vector3(2.6, 3.4, 12.0), Vector3(DOOR_X, y + 1.7, DOOR_Z - 6.4), _void_m, false, dyn)
	interactable("left_hall", LINES["two"]["left_prompt"], Vector3(-DOOR_X, y + 1.5, DOOR_Z - 1.2), Vector3(2.0, 2.6, 0.4), "", false, z_low)
	interactable("void", LINES["two"]["void_prompt"], Vector3(DOOR_X, y + 1.5, DOOR_Z - 1.2), Vector3(2.0, 2.6, 0.4), "", false, z_low)


## A straight corridor along -z from z0 to z1 (centre x), w wide, h high:
## floor, walls, ceiling, and green strip lights every four metres.
func _corridor(z0: float, z1: float, w: float, h: float, wall: Material, strip: Material, par: Node, x := 0.0) -> void:
	var y := LOW
	var ln := absf(z0 - z1)
	var zc := (z0 + z1) / 2.0
	box(Vector3(w + 0.4, 0.2, ln), Vector3(x, y - 0.08, zc), _dirt if wall == _sand_d else _conc_low, false, par)
	for s: float in [-1.0, 1.0]:
		box(Vector3(0.4, h, ln), Vector3(x + s * (w / 2.0 + 0.2), y + h / 2.0, zc), wall, true, par)
	box(Vector3(w + 0.8, 0.4, ln), Vector3(x, y + h + 0.2, zc), wall, false, par)
	var z := z0 - 2.0
	while z > z1 + 1.0:
		box(Vector3(0.14, 0.05, 1.4), Vector3(x, y + h - 0.03, z), strip, false, par)
		z -= 4.0


## A wall across the corridor at z with a 1.6 m opening for a door.
func _cross_wall(z: float, w: float, h: float, m: Material) -> void:
	var y := LOW
	var side := (w - 1.6) / 2.0
	for s: float in [-1.0, 1.0]:
		box(Vector3(side, h, 0.4), Vector3(s * (0.8 + side / 2.0), y + h / 2.0, z), m, true, z_low)
	box(Vector3(1.6, h - 2.6, 0.4), Vector3(0, y + 2.6 + (h - 2.6) / 2.0, z), m, false, z_low)


# ------------------------------------------------------------------ people

## Turan and Emmet always; Lynx if she trusts Carl enough to come (T:lynx
## >= +1), otherwise ahead of us alone; Tyson by his fire in Southtown at
## T:tyson >= +2; the alley double in Red Rock (frames on only).
func _people() -> void:
	var f: Dictionary = main.flags
	turan = figure(Color(0.16, 0.16, 0.19), Color(0.8, 0.66, 0.56), {"hair": Color(0.2, 0.2, 0.22), "legs": Color(0.14, 0.14, 0.16), "arms": true, "knees": true, "long_coat": false})
	emmet = figure(Color(0.28, 0.38, 0.5), Color(0.9, 0.74, 0.64), {"hair": Color(0.8, 0.3, 0.1), "legs": Color(0.2, 0.2, 0.24), "arms": true, "knees": true, "scale": 1.06, "long_coat": false})
	lynx = figure(Color(0.09, 0.08, 0.1), Color(0.88, 0.74, 0.62), {"hair": Color(0.12, 0.08, 0.06), "long_hair": true, "legs": Color(0.1, 0.1, 0.12), "arms": true, "knees": true, "long_coat": true})
	for t: Array in [[turan, "turan"], [emmet, "emmet"], [lynx, "lynx"]]:
		var fg: Node3D = t[0]
		dyn.add_child(fg)
		person(t[1], LINES["party"][t[1] + "_prompt"], fg, LINES["party"][t[1] + "_scan"])
		var sp := SpotLight3D.new()
		sp.position = Vector3(0.12, 1.35, -0.25)
		sp.rotation.x = -0.18
		sp.light_color = Color(1.0, 0.92, 0.8)
		sp.light_energy = 0.0
		sp.spot_range = 22.0
		sp.spot_angle = 22.0
		sp.spot_attenuation = 1.2
		fg.add_child(sp)
		fg.set_meta("torch", sp)
		# the flashlight in the right hand, held forward
		var arm: Node3D = (fg.get_meta("arms") as Array)[1]
		arm.rotation.x = -0.9
		box(Vector3(0.05, 0.05, 0.22), Vector3(0, -0.62, -0.08), _steel, false, arm)
	lynx_torch = lynx.get_meta("torch")
	_lynx_mode = "follow" if int(main.trust.get("lynx", 0)) >= 1 else "ahead"
	party = [{"fig": turan, "lag": 7}, {"fig": emmet, "lag": 11}]
	if _lynx_mode == "follow":
		party.append({"fig": lynx, "lag": 4})
	else:
		lynx.visible = false
		_it_on(lynx, false)
	_place_party(spawn_at_car())
	# the tactical flashlight, in Carl's hand
	torch = SpotLight3D.new()
	torch.light_color = Color(1.0, 0.95, 0.85)
	torch.light_energy = 0.0
	torch.spot_range = 34.0
	torch.spot_angle = 24.0
	torch.spot_attenuation = 1.1
	dyn.add_child(torch)
	# Lynx's car at the depot gate, if she went ahead
	if _lynx_mode == "ahead":
		var hers := CarS.build(self, Color(0.34, 0.07, 0.08), {"plate": "LYX 2210"})
		hers.position = Vector3(208.5, 0, -12.0)
		hers.rotation.y = 0.3
		dyn.add_child(hers)
		interactable("lynx_car", LINES["car"]["lynx_car_prompt"], Vector3(0, 0.9, 0), Vector3(2.0, 1.6, 4.6), "", true, hers)
	# our car, three blocks from the depot
	var car := CarS.build(self, Color(0.42, 0.06, 0.08), {"plate": "SLA 2241"})
	car.position = CAR_AT
	dyn.add_child(car)
	var ci := interactable("car", LINES["car"]["prompt"], Vector3(0, 0.9, 0), Vector3(2.0, 1.6, 4.6), LINES["car"]["scan"], true, car)
	ci.set_meta("route", true)
	# Tyson, by the barrel, if he trusts Carl enough to walk him in
	tyson = figure(Color(0.35, 0.28, 0.2), Color(0.55, 0.4, 0.3), {"hair": Color(0.3, 0.3, 0.3), "legs": Color(0.25, 0.22, 0.18), "arms": true, "knees": true})
	tyson.position = Vector3(-6.4, 0, 125.2)
	dyn.add_child(tyson)
	turn_to(tyson, Vector3(-5.0, 0, 124.0))
	person("tyson", "Tyson", tyson, LINES["st"]["tyson_scan"])
	if int(main.trust.get("tyson", 0)) < 2:
		tyson.visible = false
		_it_on(tyson, false)
		fire_light.light_energy = 0.0
		var fire := dyn.get_node_or_null("fire")
		if fire:
			(fire as Node3D).visible = false
	# the double: Carl's coat, Carl's jaw, the eyes too wide
	double = figure(Color(0.14, 0.13, 0.12), Color(0.84, 0.66, 0.54), {"hair": Color(0.12, 0.09, 0.07), "arms": true, "knees": true, "long_coat": true})
	double.position = ALLEY + Vector3(0.2, 0, -3.0)
	dyn.add_child(double)
	double.visible = false


func spawn_at_car() -> Vector3:
	return CAR_AT + Vector3(-2.2, 0.0, -1.0)


func _it_on(fig: Node3D, on: bool) -> void:
	for c in fig.get_children():
		if c is CollisionObject3D and c.has_meta("id"):
			(c as CollisionObject3D).collision_layer = (1 | 2) if on else 0


## Put the party round a point (after a drive or the ladder).
func _place_party(at: Vector3) -> void:
	_trail.clear()
	var k := 0
	for p: Dictionary in party:
		var fg: Node3D = p["fig"]
		fg.position = at + Vector3(1.2 - k * 1.1, 0, 1.6 + k * 0.6)
		k += 1


## The eyeless: statues with the frames off; with them on, they turn and
## walk to Carl. Three at the Rail Cut mouth, the watcher on the rails, two
## on the Red Rock platform, two patrolling the gallery and the stretch
## after door B, one in the doorway of the two doors.
func _eyeless_build() -> void:
	var specs := [
		[Vector3(108.0, 0, -9.0), [], Vector3(129.0, 0.1, 3.0), z_rc, 13.0],
		[Vector3(112.0, 0, 10.0), [], Vector3(129.0, 0.1, 3.0), z_rc, 13.0],
		[Vector3(100.0, 0, -3.5), [], Vector3(129.0, 0.1, 3.0), z_rc, 13.0],
		[Vector3(70.0, 0, 1.7), [], Vector3(80.0, 0.1, -2.0), z_tun, 7.0],
		[Vector3(-62.0, RR_PLAT_Y, -4.5), [], Vector3(-88.0, RR_PLAT_Y + 0.1, -4.0), z_rr, 11.0],
		[Vector3(-77.0, RR_PLAT_Y, -1.0), [], Vector3(-88.0, RR_PLAT_Y + 0.1, -4.0), z_rr, 11.0],
		[Vector3(-2.6, LOW, LZ - 30.0), [Vector3(-2.6, LOW, LZ - 30.0), Vector3(2.6, LOW, LZ - 37.0), Vector3(-2.6, LOW, LZ - 44.0), Vector3(2.6, LOW, LZ - 37.0)], Vector3(0, LOW + 0.1, LZ - 27.6), z_low, 12.0],
		[Vector3(1.3, LOW, LZ - 53.0), [Vector3(1.3, LOW, LZ - 53.0), Vector3(-1.3, LOW, LZ - 60.0)], Vector3(0, LOW + 0.1, LZ - 51.6), z_low, 10.0],
		[Vector3(-5.2, LOW, LZ - 63.8), [], Vector3(0, LOW + 0.1, LZ - 66.0), z_low, 0.0],
	]
	var skins := [Color(0.8, 0.62, 0.5), Color(0.62, 0.46, 0.34), Color(0.9, 0.76, 0.66), Color(0.5, 0.36, 0.26)]
	for i in specs.size():
		var sp: Array = specs[i]
		var home: Vector3 = sp[0]
		var sk: Color = skins[i % skins.size()]
		var gown := Color(0.5, 0.48, 0.44).darkened(rng.randf_range(0.0, 0.4))
		var fg := figure(gown, sk, {"hair": Color(0.25, 0.22, 0.2) if i % 2 == 0 else sk.darkened(0.3), "long_coat": true, "arms": true, "knees": true, "long_hair": i % 3 == 1})
		fg.position = home
		(sp[3] as Node3D).add_child(fg)
		var look_at := Vector3.ZERO
		match i:
			0, 1, 2: look_at = Vector3(80.0, 0, 0)
			3: look_at = Vector3(0, 0, 1.7)
			4, 5: look_at = Vector3(-40.0, RR_PLAT_Y, -2.0)
			8: look_at = TD
			_: look_at = home + Vector3(0, 0, -5.0)
		turn_to(fg, Vector3(look_at.x, home.y, look_at.z))
		var key := "e%d" % (i % 4)
		if not _faces.has(key):
			_faces[key] = _eyeless_face(sk, Color(0.25, 0.22, 0.2), 1300 + i)
		var hm := _head_mi(fg)
		if hm:
			hm.material_override = _faces[key]
		for a in fg.get_meta("arms"):
			(a as Node3D).rotation.x = -0.12
		# an Area3D, not a wall: you can slip past a statue in a narrow place
		var it := interactable("eyeless", LINES["eyeless"]["prompt"], Vector3(0, 0.9, 0), Vector3(0.7, 1.9, 0.7), LINES["eyeless"]["scan"] % (4100 + i * 13), false, fg)
		it.set_meta("eyeless", true)
		fg.set_meta("eyeless", true)
		eyeless.append({"fig": fg, "it": it, "home": home, "yaw": fg.rotation.y, "patrol": sp[1], "pi": 0, "reset": sp[2], "range": sp[4], "lane": i})


## Things that move or switch: the corridor doors, the two doors.
func _moving() -> void:
	door_a = _door_leaf(Vector3(0, LOW, DOOR_A_Z), 1.6, 2.6, "door_a")
	door_b = _door_leaf(Vector3(0, LOW, DOOR_B_Z), 1.6, 2.6, "door_b")
	door_l = _door_leaf(Vector3(-DOOR_X, LOW, DOOR_Z - 0.6), 2.0, 3.0, "")
	door_r = _door_leaf(Vector3(DOOR_X, LOW, DOOR_Z - 0.6), 2.0, 3.0, "")


## A steel leaf with a grille at mouth height and a collider, in its own node.
func _door_leaf(p: Vector3, w: float, h: float, id: String) -> Node3D:
	var n := Node3D.new()
	n.position = p
	dyn.add_child(n)
	var steel := pbr("rust", Vector3.ONE / 1.2, true, Color(0.45, 0.45, 0.48), 0.8)
	box(Vector3(w, h, 0.16), Vector3(0, h / 2.0, 0), steel, true, n)
	box(Vector3(0.36, 0.18, 0.04), Vector3(0, 1.58, 0.09), _black, false, n)
	for k in 4:
		box(Vector3(0.34, 0.02, 0.05), Vector3(0, 1.51 + k * 0.045, 0.1), _steel, false, n)
	for s: float in [-1.0, 1.0]:
		box(Vector3(0.08, h, 0.2), Vector3(s * (w / 2.0 - 0.04), h / 2.0, 0), _rust, false, n)
	if id != "":
		interactable(id, LINES["corridor"]["speak_prompt"], Vector3(0, 1.3, 0.25), Vector3(w, 2.4, 0.3), "DOOR  -  TUNELET 4-%s\nlock: VOICE" % id.right(1).to_upper(), false, n)
	return n


func _sounds_at() -> void:
	pass


# ------------------------------------------------------------------ hooks

func objective() -> String:
	var f: Dictionary = main.flags
	var o: Dictionary = LINES["objective"]
	if f.has("two_doors_done") or _opened != "":
		return o["void"]
	if f.has("tu_doors_seen"):
		return o["pray"]
	if f.has("tu_door_b"):
		return o["doors"]
	if f.has("tu_door_a"):
		return o["door_b"]
	if f.has("tu_chamber"):
		return o["door_a"]
	if f.has("tu_eye"):
		return o["down"]
	if f.has("tu_ringing"):
		return o["hub"]
	if f.has("tu_mouth"):
		return o["tunnel"]
	if f.has("tu_route"):
		return o[str(f["tu_route"])]
	return o["car"]


func phone() -> String:
	var f: Dictionary = main.flags
	var ph: Dictionary = LINES["phone"]
	var t: String = ph["greeting"]
	if f.has("tu_mouth"):
		t += ph["tunnel"]
	if f.has("tu_chamber"):
		t += ph["low"]
	if f.has("tu_doors_seen"):
		t += ph["doors"]
	return "[b]PSYON[/b]\n\n" + t


func scan_people() -> Array:
	var out := []
	for t: Array in [[turan, "turan"], [emmet, "emmet"], [lynx, "lynx"]]:
		if (t[0] as Node3D).visible:
			out.append([t[0], LINES["party"][t[1] + "_scan"]])
	if tyson.visible:
		out.append([tyson, LINES["st"]["tyson_scan"]])
	return out


func intro() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	_busy = true
	f["cinematic"] = true
	await ui.think(LINES["intro"]["think"])
	await ui.think(LINES["intro"]["think_2"])
	await ui.think(LINES["intro"]["roads"])
	await ui.think(LINES["intro"]["silence"])
	await ui.think(LINES["intro"]["parked"])
	if _lynx_mode == "ahead":
		await ui.think(LINES["intro"]["lynx_car"])
	if not f.has("ev_knife"):
		await _bag()
	await ui.think(LINES["intro"]["way_in"])
	ui.close()
	main.log_line("time", LINES["intro"]["log"])
	f.erase("cinematic")
	_busy = false
	main.update_hud()


## Emmet's bag, if it wasn't handed out at the trailer (book ch.25 opens on it).
func _bag() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	turn_to(emmet, main.player.global_position, 0.3)
	await ui.say("Emmet", LINES["bag"]["emmet"])
	await ui.think(LINES["bag"]["think"])
	await ui.say("Emmet", LINES["bag"]["emmet_2"])
	await ui.say("Carl", LINES["bag"]["carl"])
	await ui.think(LINES["bag"]["think_2"])
	await ui.say("Turan", LINES["bag"]["turan"])
	f["ev_flashlight"] = true
	f["ev_knife"] = true
	main.log_line("evidence", LINES["bag"]["log"])
	ui.show_toast("Evidence: the knife, the flashlight", 3.0)


func interact(node: Object) -> bool:
	var ui = main.ui
	var f: Dictionary = main.flags
	var id := str(node.get_meta("id"))
	if _busy and id != "eyeless":
		return true
	match id:
		"car":
			await _route()
		"lynx_car":
			await ui.think(LINES["car"]["lynx_car"])
		"drills":
			await ui.think(LINES["rc"]["drills"])
		"depot":
			await ui.think(LINES["rc"]["depot"])
		"rc_sign":
			await ui.think(LINES["rc"]["sign"])
		"rat":
			await ui.think(LINES["rc"]["rat"])
		"rc_mouth":
			if str(f.get("tu_route", "")) == "rc" and not f.has("tu_mouth"):
				await _mouth("rc")
			else:
				await ui.say("", _fc(LINES["rc"]["overlay"]))
		"footprints":
			if main.frames_on:
				await ui.think(LINES["st"]["footprints"])
				await ui.think(LINES["st"]["footprints_2"])
				if not f.has("tu_footprints"):
					f["tu_footprints"] = true
					main.add_connection(2.0, "the footprints")
					main.log_line("evidence", "The camp's footprints walk into TBM ACCESS 3 under the overpass, all one way.")
			else:
				await ui.think(LINES["st"]["footprints_off"])
		"st_layers":
			await ui.think(LINES["st"]["layers"])
		"st_drain":
			await ui.think(LINES["st"]["drain"])
		"st_portal":
			if str(f.get("tu_route", "")) == "st" and not f.has("tu_mouth"):
				await _mouth("st")
			else:
				await ui.think(LINES["st"]["portal"] if f.has("tu_st_open") else LINES["st"]["chained"])
		"tyson":
			await ui.think(LINES["st"]["tyson_again"])
		"alley":
			if not f.has("tu_double") and str(f.get("tu_route", "")) == "rr":
				await _double()
			else:
				await ui.think(LINES["rr"]["double_off"])
		"rr_station":
			await ui.think(LINES["rr"]["station"])
		"rr_stair":
			if str(f.get("tu_route", "")) == "rr" and not f.has("tu_mouth"):
				await _mouth("rr")
			else:
				await ui.think(LINES["rr"]["stair"])
		"green_eye":
			if not f.has("tu_eye") and f.has("tu_mouth"):
				await _green_eye()
			else:
				await ui.think(LINES["eye"]["examine"])
		"manhole":
			if f.has("tu_descended"):
				await ui.think(LINES["manhole"]["up"])
			elif not f.has("tu_eye"):
				await ui.think(LINES["manhole"]["early"])
			else:
				await _descend()
		"ladder":
			await ui.think(LINES["manhole"]["up"])
		"flood":
			await ui.think(LINES["chamber"]["flood"])
		"cache":
			await _cache()
		"terminal":
			await _log7()
		"forner":
			await _forner()
		"door_a", "door_b":
			await _door(id)
		"door_c":
			await _door_c()
		"speaker":
			await _speaker()
		"eyeless":
			await ui.think(LINES["eyeless"]["look_on"] if main.frames_on else LINES["eyeless"]["look"])
		"kneel":
			await _pray()
		"reader_l", "reader_r":
			if f.has("tu_doors_seen"):
				await ui.think(LINES["two"]["reader"])
			else:
				await ui.think(LINES["two"]["shut"])
		"left_hall":
			await ui.think(LINES["two"]["left_look"] if _opened != "" else LINES["two"]["shut"])
		"void":
			if _opened != "" and not _ended:
				await _follow()
			else:
				await ui.think(LINES["two"]["shut"])
		"turan", "emmet", "lynx":
			await ui.think(LINES["party"][id])
		_:
			return false
	ui.close()
	main.update_hud()
	return true


## The frames' own words: cyan, or red once the connection is past 25.
func _fc(text: String) -> String:
	var c := "#ff6a5a" if main.connection >= 25.0 else "#8ff5e6"
	return "[color=%s]%s[/color]" % [c, text.replace("\n", "[/color]\n[color=%s]" % c)]


# ------------------------------------------------------------------ the car and the three ways down

func _route() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("tu_route"):
		await ui.think(LINES["car"]["after"] if _lynx_mode == "follow" else LINES["car"]["after_alone"])
		return
	_busy = true
	var opts: Array = (LINES["car"]["options"] as Array).duplicate()
	if int(main.trust.get("tyson", 0)) >= 2:
		opts[1] = LINES["car"]["tyson_opt"]
	await ui.think(LINES["car"]["ask"])
	var i: int = await ui.choose(opts)
	var r: String = ["rc", "st", "rr"][clampi(i, 0, 2)]
	f["tu_route"] = r
	await ui.say("Emmet", LINES["car"]["emmet_" + r])
	main.log_line("route", "The way down: " + {"rc": "the Rail Cut depot", "st": "the Southtown overpass mouth", "rr": "the Red Rock maintenance stair"}[r])
	if r == "rc":
		await _frames_buzz()
	else:
		await _drive_to(r)
	ui.close()
	_busy = false
	main.update_hud()


## The frames buzz in his pocket; he puts them on. Hameron's words.
func _frames_buzz() -> void:
	var ui = main.ui
	await ui.think(LINES["frames"]["buzz"])
	if not main.frames_on:
		_frames(true)
	main.ui.glitch(0.5, 0.6)
	await ui.think(LINES["frames"]["air"])
	main.flags["tu_frames_on"] = true


func _drive_to(r: String) -> void:
	var ui = main.ui
	var p = main.player
	main.flags["cinematic"] = true
	ui.close()
	main.play("car", -6.0)
	await ui.fade_to(1.0, 0.8)
	var at: Vector3 = ST_ARRIVE if r == "st" else RR_ARRIVE
	p.position = at + Vector3(0, 0.1, 0)
	p.velocity = Vector3.ZERO
	p.yaw = 0.0 if r == "st" else deg_to_rad(-90.0)
	_place_party(at + (Vector3(0, 0, 2.0) if r == "st" else Vector3(-2.0, 0, 0)))
	_checkpoint = p.position
	ui.caption(LINES["cards"]["drive_" + r], 3.0)
	await get_tree().create_timer(1.0).timeout
	await ui.fade_to(0.0, 0.8)
	main.flags.erase("cinematic")
	if r == "st":
		await ui.think(LINES["st"]["arrive"])
		await _frames_buzz()
		if tyson.visible:
			turn_to(tyson, p.global_position, 0.4)
			await ui.say("Tyson", LINES["st"]["tyson_1"])
			await ui.say("Tyson", LINES["st"]["tyson_2"])
			main.log_line("person", "Tyson walked us to TBM ACCESS 3 and kept his fire.")
	else:
		await ui.think(LINES["rr"]["arrive"])
		await _frames_buzz()


## The mouth: the overlay, the frames' blood-red eye, Lynx's line, the
## threshold. Each way down has its own mouth; the eye is the same.
func _mouth(r: String) -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	if f.has("tu_mouth") or _busy:
		return
	_busy = true
	f["cinematic"] = true
	var eye: MeshInstance3D = big_eye
	var look := Vector3(RC_FACE - 4.0, 12.0, 0)
	match r:
		"rc":
			await p.face(Vector3(RC_FACE, 10.0, 0), 1.0)
			await ui.think(LINES["rc"]["wide"])
			await ui.say("", _fc(LINES["rc"]["overlay"]))
			await ui.think(LINES["rc"]["wide_2"])
		"st":
			eye = st_eye
			look = Vector3(0, 3.0, ST_PORTAL)
			await p.face(look, 0.8)
			if tyson.visible:
				await ui.say("Tyson", LINES["st"]["tyson_3"])
			else:
				await ui.think(LINES["st"]["chained"])
				main.play("snap", -2.0, 0.7)
				await ui.think(LINES["st"]["cut"])
			_open_st_gate()
			await ui.think(LINES["st"]["footprints_2"])
		"rr":
			eye = rr_eye
			look = Vector3(-47.6, RR_PLAT_Y + 1.6, -2.0)
			await p.face(look, 0.8)
			await ui.think(LINES["rr"]["stair"])
	if not main.frames_on:
		await ui.think(LINES["mouth"]["need_frames"])
		_frames(true)
	# the eye, for a second
	await p.face(look, 0.3)
	eye.visible = true
	eye_flash.position = look + (Vector3(6, 0, 0) if r == "rc" else Vector3(0, 0, 2.0) if r == "st" else Vector3(-2.0, 0, 0))
	eye_flash.light_energy = 6.0 if r == "rc" else 2.5
	main.play("glitch", -2.0, 0.7)
	main.play("sting", -6.0, 0.6)
	ui.glitch(1.0, 1.1)
	p.shake(0.4)
	await get_tree().create_timer(1.1).timeout
	eye.visible = false
	eye_flash.light_energy = 0.0
	await ui.think(LINES["mouth"]["eye"])
	await ui.think(LINES["mouth"]["calm"])
	if _lynx_mode == "follow":
		turn_to(lynx, p.global_position, 0.3)
		await ui.say("Lynx", LINES["mouth"]["lynx"])
		await ui.think(LINES["mouth"]["lynx_think"])
	await ui.think(LINES["mouth"]["party"])
	await ui.think(LINES["mouth"]["peace"])
	if _lynx_mode == "follow":
		var i: int = await ui.choose(LINES["mouth"]["reply"])
		if i == 0:
			await ui.say("Carl", LINES["mouth"]["reply"][0])
			await ui.think(LINES["mouth"]["nod"])
			main.log_line("promise", "At the mouth: I won't leave without you.")
		else:
			await ui.think(LINES["mouth"]["quiet"])
	await ui.think(LINES["mouth"]["cross"])
	_torches(true)
	await ui.think(LINES["mouth"]["spa"])
	if r == "rc":
		await ui.think(LINES["rc"]["eyeless"])
	elif r == "rr":
		await ui.think(LINES["rr"]["eyeless"])
	ui.close()
	f["tu_mouth"] = true
	main.log_line("frames", LINES["mouth"]["log"])
	if r != "st":
		ui.show_toast(LINES["frames"]["off_toast"], 6.0)
	_checkpoint = p.global_position
	f.erase("cinematic")
	_busy = false
	main.update_hud()


func _open_st_gate() -> void:
	var f: Dictionary = main.flags
	f["tu_st_open"] = true
	var g := dyn.get_node_or_null("st_gate")
	if g:
		create_tween().tween_property(g, "rotation:y", -1.6, 1.2)
		for c in g.get_children():
			if c is StaticBody3D:
				(c as StaticBody3D).collision_layer = 0


## The alley double on the way across the plaza (frames on only).
func _double() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	if not main.frames_on:
		await ui.think(LINES["rr"]["double_off"])
		return
	_busy = true
	f["tu_double"] = true
	f["cinematic"] = true
	double.visible = true
	turn_to(double, p.global_position)
	await p.face(double.global_position + Vector3(0, 1.6, 0), 0.7)
	main.play("whisper", -6.0, 0.8)
	if f.has("rr_double_named"):
		await ui.think(LINES["rr"]["double_named"])
	elif f.has("rr_double_bowed"):
		await ui.think(LINES["rr"]["double_bowed"])
	else:
		await ui.think(LINES["rr"]["double"])
	f.erase("cinematic")
	var i: int = await ui.choose(LINES["rr"]["double_opts"])
	match i:
		0:
			await ui.think(LINES["rr"]["double_walk"])
		1:
			await ui.think(LINES["rr"]["double_look"])
			main.add_connection(1.0, "the double")
		_:
			await ui.think(LINES["rr"]["double_bow"])
			main.add_connection(3.0, "bowed to the double")
			f["tu_double_bowed"] = true
	double.visible = false
	main.log_line("encounter", "The alley double on Red Rock Plaza, on the way to the subway stair.")
	_busy = false


# ------------------------------------------------------------------ the tunnel, the hub, the manhole

func _ringing() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	_busy = true
	f["tu_ringing"] = true
	_fade(_ring, -24.0, 3.0)
	_fade(_ring2, -30.0, 3.0)
	_fade(_drip, -26.0, 2.0)
	await ui.think(LINES["ring"]["think"])
	await ui.say("Turan", LINES["ring"]["turan"])
	await ui.think(LINES["ring"]["think_2"])
	await ui.say("Emmet", LINES["ring"]["emmet"])
	await ui.think(LINES["ring"]["hq"])
	await ui.think(LINES["ring"]["rails"])
	await ui.think(LINES["ring"]["dirt"])
	ui.close()
	main.log_line("sound", "The ringing in the Tunelet bores: 'an army of mechanical bees humming behind the veil'.")
	_busy = false
	main.update_hud()


## The green eye and the arrow: Lynx's flashlight finds it (Emmet's, if
## she isn't with us); the frames flare unprompted; the argument; Turan.
func _green_eye() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	_busy = true
	f["cinematic"] = true
	var finder: Node3D = lynx if _lynx_mode == "follow" else emmet
	turn_to(finder, Vector3(0, 0, -HUB_R), 0.4)
	await ui.say("Lynx" if finder == lynx else "Emmet", LINES["eye"]["lynx"])
	await p.face(Vector3(0, 3.6, -HUB_R), 1.0)
	await ui.think(LINES["eye"]["think"])
	await p.face(MANHOLE, 0.8)
	if not main.frames_on:
		_frames(true)
	ui.glitch(0.6, 0.6)
	green_eye_m.emission_energy_multiplier = 2.2
	await ui.think(LINES["eye"]["flare"])
	await ui.say("Carl", LINES["eye"]["carl"])
	await ui.say("Emmet", LINES["eye"]["emmet"])
	await ui.say("Carl", LINES["eye"]["carl_2"])
	if _lynx_mode == "follow":
		await ui.say("Lynx", LINES["eye"]["lynx_2"])
	else:
		await ui.say("Emmet", LINES["eye"]["emmet_2"])
	await ui.say("Carl", LINES["eye"]["carl_3"])
	await ui.think(LINES["eye"]["charge"])
	main.play("hum", -10.0, 0.6)
	turn_to(turan, MANHOLE, 0.4)
	await ui.say("Turan", LINES["eye"]["turan"])
	if _lynx_mode == "follow" and f.has("lynx_has_drive"):
		await ui.say("Carl", LINES["eye"]["drive"])
		await ui.think(LINES["eye"]["drive_lynx"])
		f.erase("lynx_has_drive")
		main.log_line("evidence", "Took Hameron's drive back from Lynx at the green eye.")
	ui.close()
	f["tu_eye"] = true
	main.log_line("evidence", LINES["eye"]["log"])
	f.erase("cinematic")
	_busy = false
	main.update_hud()


## Turan slides the cover; the green comes up; the order down; the stench;
## the ground. Then the chamber.
func _descend() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	_busy = true
	f["cinematic"] = true
	await _move(turan, [MANHOLE + Vector3(0.9, 0, 0.4)], 2.0)
	turn_to(turan, MANHOLE, 0.3)
	Anim.crouch(turan)
	main.play("slam", -10.0, 0.5)
	create_tween().tween_property(cover, "position", MANHOLE + Vector3(-1.1, 0.04, 0.5), 1.2)
	hole_glow.visible = true
	create_tween().tween_property(hole_light, "light_energy", 1.4, 1.2)
	await ui.think(LINES["manhole"]["think"])
	await ui.think(LINES["manhole"]["order"] if _lynx_mode == "follow" else LINES["manhole"]["order_alone"])
	for pd: Dictionary in party:
		var fg: Node3D = pd["fig"]
		_stand(fg)
		fg.position = MANHOLE
		fg.visible = false
		main.play("tap", -12.0, 0.7)
		await get_tree().create_timer(0.5).timeout
	await p.face(MANHOLE, 0.6)
	await ui.think(LINES["manhole"]["climb"])
	ui.close()
	await ui.fade_to(1.0, 0.8)
	for k in 6:
		main.play("tap", -10.0, 0.55)
		await get_tree().create_timer(0.25).timeout
	p.position = CH + Vector3(0.0, 0.1, 1.4)
	p.velocity = Vector3.ZERO
	p.yaw = 0.0
	p.pitch = 0.0
	_checkpoint = p.position
	var k := 0
	for pd: Dictionary in party:
		var fg: Node3D = pd["fig"]
		fg.visible = true
		fg.position = CH + Vector3(-1.6 + k * 1.6, 0, -1.4 - (k % 2) * 0.8)
		turn_to(fg, CH + Vector3(0, 0, -20))
		k += 1
	_trail.clear()
	f["tu_descended"] = true
	await get_tree().create_timer(0.3).timeout
	await ui.fade_to(0.0, 0.8)
	await ui.think(LINES["manhole"]["ground"])
	await _chamber()
	f.erase("cinematic")
	_busy = false
	main.update_hud()


## "The chamber was vast." The green; the chime; COMMUNION; something at
## the corner of the eye.
func _chamber() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	await p.face(CH + Vector3(0, 4.0, -CH_R), 1.4)
	await ui.think(LINES["chamber"]["think"])
	await p.face(turan.global_position + Vector3(0, 1.6, 0), 0.8)
	await ui.think(LINES["chamber"]["think_2"])
	main.play("ding", -6.0, 0.8)
	await ui.think(LINES["chamber"]["chime"])
	await ui.say("", _fc(LINES["chamber"]["msg"]))
	main.add_connection(2.0, "COMMUNION: zero to one")
	main.play("whisper", -8.0, 0.5)
	# the breathing, and something at the edge of sight: his own coat
	var g: Vector3 = CH + Vector3(CH_R - 1.2, 0, -2.5)
	double.position = g
	turn_to(double, p.global_position)
	double.visible = true
	await get_tree().create_timer(0.35).timeout
	double.visible = false
	await ui.think(LINES["chamber"]["breath"])
	await ui.think(LINES["chamber"]["bury"])
	ui.close()
	ui.caption(LINES["cards"]["day7"], 4.0)
	main.log_line("time", LINES["cards"]["day7"])
	main.log_line("frames", LINES["chamber"]["log"])
	f["tu_chamber"] = true
	await ui.think(LINES["corridor"]["narrow"])
	ui.close()


# ------------------------------------------------------------------ the side rooms

func _cache() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("tu_cache"):
		await ui.think(LINES["cache"]["after"])
		return
	await ui.think(LINES["cache"]["think"])
	var i: int = await ui.choose(LINES["cache"]["ask"])
	f["tu_cache"] = true
	if i == 0:
		await ui.think(LINES["cache"]["take"])
		f["ev_offerings"] = true
		for o in ["offer_sticks", "offer_stones", "offer_wire"]:
			f[o] = int(f.get(o, 0)) + 1
		ui.show_toast("Offerings: sticks, stones, wire", 3.0)
	else:
		await ui.think(LINES["cache"]["leave"])
	main.log_line("evidence", LINES["cache"]["log"])


func _log7() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("tu_log7"):
		await ui.think(LINES["log7"]["after"])
		return
	if not main.frames_on:
		await ui.think(LINES["log7"]["dark"])
		return
	main.play("on", -8.0, 0.7)
	await ui.think(LINES["log7"]["boot"])
	await ui.say("", "[color=#cfd8d0]" + LINES["log7"]["text"] + "[/color]")
	await ui.think(LINES["log7"]["think"])
	f["tu_log7"] = true
	f["ev_hameron_log_7"] = true
	main.add_connection(2.0, "Hameron's seventh log")
	main.log_line("evidence", LINES["log7"]["log"])
	ui.show_toast("Evidence: Hameron, log 7", 3.0)


## Forner's frames: the pixel game's scrub, frame by frame (RailCutScene),
## now on his own glasses, under Red Rock.
func _forner() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("tu_forner"):
		await ui.think(LINES["forner"]["after"])
		return
	await ui.think(LINES["forner"]["think"])
	await ui.think(LINES["forner"]["think_2"])
	var i: int = await ui.choose(LINES["forner"]["ask"])
	f["tu_forner"] = true
	f["ev_forner_frames"] = true
	if i == 0:
		await ui.think(LINES["forner"]["scrub"])
		var pick: int = await ui.choose(LINES["forner"]["frames"])
		if pick == 3:
			ui.flash(0.3)
			main.play("sting", -6.0, 0.7)
			await ui.think(LINES["forner"]["found"])
			main.add_connection(2.0, "Cheyenne on the rails")
		else:
			await ui.think(LINES["forner"]["blur"])
			await ui.think(LINES["forner"]["frames"][3])
			await ui.think(LINES["forner"]["found"])
			main.add_connection(2.0, "Cheyenne on the rails")
	else:
		await ui.think(LINES["forner"]["bag"])
	main.log_line("evidence", LINES["forner"]["log"])
	ui.show_toast("Evidence: Forner's frames", 3.0)


# ------------------------------------------------------------------ the possessed doors

## Speak: a choice of the words Carl knows (the lexicon), or nothing.
func _speak() -> String:
	var ui = main.ui
	var words: Array = []
	for w in main.lexicon:
		words.append(str(w))
	var opts: Array = words.duplicate()
	if words.is_empty():
		opts.append(LINES["corridor"]["hum"])
	opts.append(LINES["corridor"]["say_nothing"])
	var i: int = await ui.choose(opts)
	if i < words.size():
		return words[i]
	if words.is_empty() and i == 0:
		return "hum"
	return ""


func _door(id: String) -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var done_flag := "tu_" + id
	if f.has(done_flag):
		await ui.think(LINES["corridor"]["open"])
		return
	await ui.think(LINES["corridor"][id])
	if main.frames_on:
		main.play("glitch", -10.0, 1.2)
		await ui.think(LINES["corridor"][id + "_eye"])
		main.learn("dreamer" if id == "door_a" else "sleeper")
	var w := await _speak()
	await _door_word(id, w)


func _door_word(id: String, w: String) -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("tu_" + id):
		return
	if w == "":
		await ui.think(LINES["corridor"]["silent"])
		return
	main.player.shake(0.15)
	if w == ("dreamer" if id == "door_a" else "sleeper"):
		await ui.think(LINES["corridor"]["right"])
		f["tu_" + id] = true
		var d: Node3D = door_a if id == "door_a" else door_b
		main.play("door", -4.0, 0.7)
		create_tween().tween_property(d, "position:y", LOW + 2.75, 2.0).set_trans(Tween.TRANS_SINE)
		for c in d.get_children():
			if c is CollisionObject3D:
				(c as CollisionObject3D).collision_layer = 0
		_checkpoint = Vector3(0, LOW + 0.1, (DOOR_A_Z if id == "door_a" else DOOR_B_Z) - 1.6)
		main.log_line("word", "Spoke '%s' at %s; it opened." % [w, id.replace("_", " ")])
		if id == "door_a":
			_hymn_start()
		else:
			await _lynx_goes()
	else:
		await ui.think(LINES["corridor"]["wrong"])
		main.add_connection(1.0, LINES["corridor"]["wrong_why"])
		main.log_line("word", "Spoke '%s' at %s: the wrong word." % [w, id.replace("_", " ")])
		_round()


## Door C: in the eye layer only. Any word is a wrong word.
func _door_c() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if not main.frames_on:
		await ui.think(LINES["corridor"]["door_c"])
		return
	await ui.think(LINES["corridor"]["door_c_eye"])
	var w := await _speak()
	if w == "":
		await ui.think(LINES["corridor"]["silent"])
		return
	await ui.think(LINES["corridor"]["door_c_none"])
	f["tu_door_c_tried"] = true
	main.add_connection(1.0, LINES["corridor"]["wrong_why"])
	main.log_line("word", "Spoke '%s' to the door that is a wall." % w)
	_round()


## A round with the eyeless: the nearest one in this stretch comes closer
## at once, facing Carl.
func _round() -> void:
	var pp: Vector3 = main.player.global_position
	main.ui.show_toast(LINES["corridor"]["round_toast"], 2.5)
	main.ui.glitch(0.5, 0.5)
	main.play("whisper", -6.0, 0.7)
	for e: Dictionary in eyeless:
		if int(e["lane"]) < 6 or int(e["lane"]) > 7:
			continue
		var fg: Node3D = e["fig"]
		if fg.global_position.distance_to(pp) < 16.0 and absf(fg.global_position.y - pp.y) < 3.0:
			var to := pp + (fg.global_position - pp).normalized() * 3.2
			to.y = LOW
			fg.position = to
			turn_to(fg, pp)
			return


func _speaker() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("tu_hushed"):
		await ui.think(LINES["speaker"]["done"])
		return
	await ui.think(LINES["speaker"]["look"])
	if not main.frames_on:
		await ui.think(LINES["speaker"]["no_frames"])
		return
	var w := await _speak()
	await _hack_speaker(w)


func _hack_speaker(w: String) -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if w == "" or f.has("tu_hushed"):
		return
	main.play("glitch", -6.0, 1.3)
	ui.glitch(0.6, 0.6)
	if w == "hush":
		await ui.think(LINES["speaker"]["hushed"])
		f["tu_hushed"] = true
		main.add_connection(1.0, LINES["speaker"]["hush_why"])
		speaker_led.visible = false
		if speaker_snd and is_instance_valid(speaker_snd):
			(speaker_snd as AudioStreamPlayer3D).stop()
		main.log_line("hack", "Quick-hack hush on the Tunelet PA calling the eyeless.")
	else:
		await ui.think(LINES["speaker"]["wrong"])
		main.add_connection(1.0, LINES["corridor"]["wrong_why"])
		_round()


func _hymn_start() -> void:
	var f: Dictionary = main.flags
	if f.has("tu_hymn"):
		return
	f["tu_hymn"] = true
	_hymn_t = 0.0
	_gap = false
	_fade(_hymn, -8.0, 4.0)
	main.ui.caption(LINES["hymn"]["start"], 5.0)


## After door B, if Lynx came but was never warned (and so has no line at
## the doors), she is simply gone: her light in the dirt.
func _lynx_goes() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if _lynx_mode == "follow" and not (f.has("warned_lynx") and int(main.trust.get("lynx", 0)) >= 0):
		_lynx_mode = "gone"
		party = party.filter(func(pd: Dictionary) -> bool: return pd["fig"] != lynx)
		lynx.visible = false
		_it_on(lynx, false)
		dropped_torch = SpotLight3D.new()
		dropped_torch.light_color = Color(1.0, 0.92, 0.8)
		dropped_torch.light_energy = 1.6
		dropped_torch.spot_range = 8.0
		dropped_torch.spot_angle = 18.0
		dropped_torch.position = Vector3(1.2, LOW + 0.12, DOOR_B_Z + 0.8)
		dropped_torch.rotation.y = -PI / 2.0
		dyn.add_child(dropped_torch)
		box(Vector3(0.22, 0.05, 0.05), Vector3(1.2, LOW + 0.04, DOOR_B_Z + 0.8), _steel, false, dyn)
		await get_tree().create_timer(0.4).timeout
		await main.player.face(dropped_torch.global_position, 0.8)
		await ui.think(LINES["corridor"]["lynx_gone"])
		main.log_line("person", "Lynx was gone after door B. Her flashlight in the dirt.")
	elif _lynx_mode == "ahead":
		var t := int(main.trust.get("lynx", 0))
		if t <= -1 or (t >= 0 and f.has("warned_lynx")):
			# she came another way, and she is waiting at the doors
			lynx.visible = true
			_it_on(lynx, true)
			lynx.position = Vector3(1.0, LOW, DOOR_Z + 2.2)
			turn_to(lynx, Vector3(DOOR_X, LOW, DOOR_Z - 4.0))
			lynx_torch.light_energy = 1.2


# ------------------------------------------------------------------ the two doors (the blood sensor)

func _two_doors() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	_busy = true
	f["cinematic"] = true
	f["tu_doors_seen"] = true
	var here := lynx.visible
	await p.face(Vector3(0, LOW + 2.0, DOOR_Z), 1.0)
	main.play("ding", -6.0, 0.8)
	await ui.think(LINES["two"]["chime"])
	if here and _lynx_mode == "ahead":
		await ui.think(LINES["two"]["lynx_waiting"])
	await ui.say("", _fc(LINES["two"]["msg"]))
	await ui.think(LINES["two"]["red"])
	await _move(emmet, [Vector3(1.4, LOW, DOOR_Z + 1.6)], 1.6)
	turn_to(emmet, Vector3(0.75, LOW, DOOR_Z))
	await ui.say("Emmet", LINES["two"]["emmet"])
	await ui.say("Emmet", LINES["two"]["emmet_2"])
	await p.face(Vector3(0.75, LOW + 1.35, DOOR_Z), 0.8)
	await ui.think(LINES["two"]["think"])
	await ui.say("Turan", LINES["two"]["turan"])
	if here:
		await ui.say("Lynx", LINES["two"]["lynx"])
	await ui.think(LINES["two"]["alone"] if here else LINES["two"]["alone_3"])
	main.play("hum", -8.0, 1.4)
	await ui.think(LINES["two"]["heat"])
	await ui.say("", _fc(LINES["two"]["msg_2"]))
	await ui.think(LINES["two"]["wait"])
	await ui.say("Carl", LINES["two"]["carl"])
	await ui.say("Emmet", LINES["two"]["emmet_3"])
	await ui.say("Carl", LINES["two"]["carl_2"])
	ui.close()
	main.log_line("frames", "The two doors: 'Carl Drake / Man and Machine / God and Servant / Commune now or turn away.'")
	f.erase("cinematic")
	_busy = false
	main.update_hud()


## Carl prays: the player picks the word. bow opens both; filter the right
## only (and Emmet bleeds for the left); anything else costs a round.
func _pray() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if not f.has("tu_doors_seen"):
		await ui.think(LINES["two"]["shut"])
		return
	if _opened != "":
		await ui.think(LINES["two"]["done"])
		return
	_busy = true
	var p = main.player
	create_tween().tween_property(p, "crouch", 0.75, 0.6)
	await ui.think(LINES["two"]["kneel"])
	await ui.think(LINES["two"]["pray_ask"])
	var w := await _speak()
	await _prayer(w)
	_busy = false


func _prayer(w: String) -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	if _opened != "":
		return
	f["cinematic"] = true
	if w == "bow":
		await ui.think(LINES["two"]["bow"])
		main.add_connection(3.0, LINES["two"]["why_bow"])
		await _answer(true)
	elif w == "filter":
		await ui.think(LINES["two"]["filter"])
		await _answer(false)
	else:
		await ui.think(LINES["two"]["other"])
		await ui.think(LINES["two"]["nothing"])
		main.log_line("word", "Prayed '%s' at the two doors: nothing opened." % (w if w != "" else "(nothing)"))
		await _prayer_round()
		create_tween().tween_property(p, "crouch", 0.0, 0.5)
		f.erase("cinematic")
		ui.close()
		return
	f.erase("cinematic")


## A round with the eyeless in the doorway: it crosses the room and lays
## a hand on him (+5), then goes back to wait.
func _prayer_round() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	var e: Dictionary = eyeless[8]
	var fg: Node3D = e["fig"]
	await p.face(fg.global_position + Vector3(0, 1.5, 0), 0.6)
	var to: Vector3 = p.global_position + (fg.global_position - p.global_position).normalized() * 0.8
	to.y = LOW
	await _move(fg, [to], 1.4)
	main.play("whisper", -2.0, 0.6)
	p.shake(0.5)
	ui.glitch(0.8, 0.5)
	main.add_connection(5.0, LINES["eyeless"]["touched_why"])
	f["tu_touched"] = int(f.get("tu_touched", 0)) + 1
	await ui.think(LINES["two"]["round"])
	await _move(fg, [e["home"]], 1.6)
	turn_to(fg, TD)


## The answer: Monica's voice, the lullaby, the doors.
func _answer(both: bool) -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	_fade(_hymn, -80.0, 2.0)
	await ui.think(LINES["two"]["voice"])
	main.play("whisper", -10.0, 0.9)
	await ui.say("Monica", LINES["two"]["monica"])
	main.play("jingle", -8.0, 0.52)
	await ui.think(LINES["two"]["melody"])
	await ui.say("Carl", LINES["two"]["nicu"])
	main.play("jingle", -10.0, 0.52)
	await ui.think(LINES["two"]["wonder"])
	await ui.say("Monica", LINES["two"]["guided"])
	main.play("door", -2.0, 0.6)
	ui.glitch(0.7, 0.6)
	if both:
		_opened = "both"
		await ui.think(LINES["two"]["both"])
		_open(door_l, -1.0)
		_open(door_r, 1.0)
		await ui.think(LINES["two"]["left"])
		await ui.think(LINES["two"]["right"])
	else:
		_opened = "right"
		await ui.think(LINES["two"]["right_only"])
		_open(door_r, 1.0)
		await ui.think(LINES["two"]["right"])
		await _move(emmet, [Vector3(-0.75, LOW, DOOR_Z + 0.9)], 1.6)
		turn_to(emmet, Vector3(-0.75, LOW, DOOR_Z))
		main.play("snap", -8.0, 1.6)
		await ui.think(LINES["two"]["emmet_blood"])
		main.add_trust("emmet", 1)
		_open(door_l, -1.0)
		await ui.think(LINES["two"]["left"])
	f["tu_prayed"] = "bow" if both else "filter"
	main.log_line("ritual", LINES["two"]["log"])
	create_tween().tween_property(p, "crouch", 0.0, 0.8)
	await ui.think(LINES["two"]["stood"])
	await ui.say("Carl", LINES["two"]["carl_3"])
	turn_to(turan, Vector3(-DOOR_X, LOW, DOOR_Z), 0.4)
	await ui.say("Turan", LINES["two"]["turan_2"])
	await ui.think(LINES["two"]["emmet_nod"])
	await _lynx_doors()
	ui.close()
	if not _ended:
		await _follow()


func _open(d: Node3D, side: float) -> void:
	create_tween().tween_property(d, "position:x", d.position.x + side * 2.1, 1.0).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	for c in d.get_children():
		if c is CollisionObject3D:
			(c as CollisionObject3D).collision_layer = 0


## Lynx at the doors: a plea (T >= 0 and warned), a betrayal (T <= -1), or
## only her voice from the void (she is not here).
func _lynx_doors() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	var t := int(main.trust.get("lynx", 0))
	var mode := "voice"
	if lynx.visible:
		mode = "plea" if (t >= 0 and f.has("warned_lynx")) else "betrayal"
	f["tu_lynx"] = mode
	var into := Vector3(DOOR_X, LOW, DOOR_Z - 5.0)
	if mode != "voice":
		party = party.filter(func(pd: Dictionary) -> bool: return pd["fig"] != lynx)
		turn_to(lynx, into, 0.4)
		await ui.say("Lynx", LINES["two"]["lynx_2"])
		await p.face(Vector3(DOOR_X, LOW + 1.6, DOOR_Z - 3.0), 0.8)
		await ui.think(LINES["two"]["stare"])
		if mode == "plea":
			await ui.say("Lynx", LINES["two"]["plea"])
			await ui.think(LINES["two"]["plea_think"])
			await _move(lynx, [Vector3(DOOR_X, LOW, DOOR_Z + 0.6), into], 1.3)
		else:
			await ui.think(LINES["two"]["betray"])
			if f.has("lynx_has_drive"):
				await ui.think(LINES["two"]["betray_drive"])
			await _move(lynx, [Vector3(DOOR_X, LOW, DOOR_Z + 0.6), into], 5.0)
		lynx.visible = false
		_it_on(lynx, false)
		main.log_line("person", "Lynx went into the void (%s)." % mode)
	else:
		await p.face(Vector3(DOOR_X, LOW + 1.6, DOOR_Z - 3.0), 0.8)
		await ui.think(LINES["two"]["stare"])
		main.play("whisper", -4.0, 1.1)
		await ui.think(LINES["two"]["voice_think"])
		main.log_line("person", "Lynx's voice from the void; she was not with us.")


## "I heard a familiar voice, and without a thought, followed her into the
## void." Forced: he walks in. Turan and Emmet take the left hall.
func _follow() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	if _ended:
		return
	_ended = true
	f["cinematic"] = true
	await ui.think(LINES["two"]["follow"])
	ui.close()
	for pd: Dictionary in party:
		var fg: Node3D = pd["fig"]
		_move(fg, [Vector3(-DOOR_X, LOW, DOOR_Z + 0.6), Vector3(-DOOR_X, LOW, DOOR_Z - 8.0 - (1.5 if fg == emmet else 0.0))], 1.4)
	party.clear()
	await p.face(Vector3(DOOR_X, LOW + 1.6, DOOR_Z - 4.0), 0.6)
	var tw := create_tween()
	tw.tween_property(p, "position", Vector3(DOOR_X, LOW + 0.1, DOOR_Z + 0.4), 1.6)
	tw.tween_property(p, "position", Vector3(DOOR_X, LOW + 0.1, DOOR_Z - 3.0), 1.4)
	await tw.finished
	ui.caption(LINES["two"]["left_hall"], 3.0)
	await ui.fade_to(1.0, 1.2)
	main.play("slam", 0.0, 0.7)
	p.shake(0.8)
	_stop_loops()
	await ui.show_card(LINES["cards"]["end"], 2.6)
	f["two_doors_done"] = true
	main.log_line("time", "Day 7: through the right-hand door, into the void, after Lynx.")
	f.erase("cinematic")
	if not main._selftest:
		main.load_level("BronzeHands")


# ------------------------------------------------------------------ the frame loop

func tick(delta: float) -> void:
	if not main or not main.player:
		return
	var p = main.player
	var pp: Vector3 = p.global_position
	var f: Dictionary = main.flags
	_set_env(_underground(pp))
	_zones(pp)
	if _eye_vis != main.frames_on:
		_eye_vis = main.frames_on
		_eye_layer()
	if pp.y > RR_Y - 1.0 and not f.has("cinematic"):
		double.visible = main.frames_on and str(f.get("tu_route", "")) == "rr" and not f.has("tu_double")
	# Emmet's flashlight in Carl's hand
	var cam: Camera3D = p.cam
	torch.global_transform = cam.global_transform.translated_local(Vector3(0.18, -0.2, 0.1))
	if _shot:
		# --at/--yaw land after apply_args: pose the party once, here
		if not _shot_posed and str(main._args.get("scene", "")) != "":
			_shot_posed = true
			_pose_party()
		_tick_lights()
		return
	_tick_party(delta, pp)
	_tick_lights()
	_touch_cd = maxf(0.0, _touch_cd - delta)
	_tick_hymn(delta, pp)
	_tick_eyeless(delta, pp)
	if _busy or f.has("cinematic") or main.ui.busy:
		return
	var r := str(f.get("tu_route", ""))
	if not f.has("tu_mouth") and r != "":
		if r == "rc" and pp.x < RC_FACE + 10.0 and pp.x > RC_FUN:
			_mouth("rc")
		elif r == "st" and pp.z < ST_PORTAL + 5.0 and pp.z > ST_PORTAL - 2.0 and absf(pp.x) < 7.0:
			_mouth("st")
		elif r == "rr" and pp.y > RR_PLAT_Y - 1.0 and pp.y < RR_PLAT_Y + 2.0 and pp.x > -54.0 and pp.x < -46.0:
			_mouth("rr")
		elif r == "rr" and not f.has("tu_double") and main.frames_on and pp.y > RR_Y - 1.0 and pp.x > ALLEY.x - 14.0 and pp.x < ALLEY.x + 8.0:
			_double()
	elif f.has("tu_mouth") and not f.has("tu_ringing") and _in_tunnel(pp):
		_ringing()
	elif f.has("tu_ringing") and not f.has("tu_eye") and pp.y > -2.0 and pp.y < 3.0 and Vector2(pp.x, pp.z).length() < 7.0:
		_green_eye()
	elif f.has("tu_door_b") and not f.has("tu_doors_seen") and pp.y < LOW + 3.0 and pp.z < TD.z + TD_R - 1.0:
		_two_doors()


func _underground(pp: Vector3) -> bool:
	if pp.z < -250.0:
		return true
	if pp.y > RR_Y - 1.5:
		return false
	if pp.x > RC_FACE - 2.0 or pp.z > ST_PORTAL + 1.0 or pp.x < -93.0:
		return false
	return true


func _in_tunnel(pp: Vector3) -> bool:
	if pp.z < -250.0 or pp.y > 3.0:
		return false
	return (absf(pp.z) < 4.2 and pp.x > 9.0 and pp.x < RC_FUN) or (absf(pp.x) < 4.2 and pp.z > 9.0 and pp.z < ST_PORTAL - 1.0) or (absf(pp.z) < 4.2 and pp.x < -9.0 and pp.x > -37.0)


## Only the places near Carl are drawn (and lit): the browser shades 32 lights.
func _zones(pp: Vector3) -> void:
	var low := pp.z < -250.0
	z_low.visible = low
	z_tun.visible = not low
	z_rc.visible = not low and pp.x > 60.0
	z_st.visible = not low and pp.z > 50.0
	z_rr.visible = not low and pp.x < -20.0


func _tick_lights() -> void:
	if flicker_l:
		flicker_l.light_energy = 0.6 if fmod(_t * 3.7, 5.0) > 0.4 else 0.05
	if fire_light and fire_light.light_energy > 0.0:
		fire_light.light_energy = 1.2 + sin(_t * 9.0) * 0.2 + sin(_t * 23.0) * 0.12


## The party walks Carl's trail, each a few steps back, lights on him.
func _tick_party(delta: float, pp: Vector3) -> void:
	if main.flags.has("cinematic") and not _shot:
		return
	if _trail.is_empty() or (_trail[_trail.size() - 1] as Vector3).distance_to(pp) > 0.5:
		_trail.append(pp)
		if _trail.size() > 60:
			_trail.pop_front()
	for pd: Dictionary in party:
		var fg: Node3D = pd["fig"]
		if not fg.visible:
			continue
		var lag: int = pd["lag"]
		var target: Vector3 = _trail[maxi(0, _trail.size() - lag)] if _trail.size() > 0 else fg.position
		var d := target - fg.position
		var dist := d.length()
		if dist > 8.0 and _trail.size() < lag:
			continue
		if dist > 0.35 and pp.distance_to(fg.position) > 1.3:
			var speed := clampf(dist * 2.0, 1.0, 5.0)
			fg.position += d.normalized() * minf(speed * delta, dist)
			if Vector2(d.x, d.z).length() > 0.05:
				fg.rotation.y = lerp_angle(fg.rotation.y, atan2(-d.x, -d.z), minf(1.0, delta * 8.0))
			Anim.walk(fg, _t, speed / 2.4, float(pd["lag"]), 1.0)
		else:
			Anim.idle(fg, _t, float(pd["lag"]))
			Anim.look(fg, pp + Vector3(0, 1.6, 0), 0.4, 0.04)
		(fg.get_meta("arms") as Array)[1].rotation.x = -0.9


func _tick_hymn(delta: float, pp: Vector3) -> void:
	var f: Dictionary = main.flags
	if not f.has("tu_hymn") or _opened != "" or _ended:
		return
	_hymn_t += delta
	var phase := fmod(_hymn_t, 48.0)
	var gap := phase > 40.0
	if gap != _gap and pp.z < -250.0:
		_gap = gap
		if gap:
			_hymn.volume_db = -80.0
			main.ui.show_toast(LINES["hymn"]["gap_toast"], 4.0)
			if not f.has("cinematic"):
				main.ui.caption(LINES["hymn"]["gap"], 3.0)
		else:
			_fade(_hymn, -8.0, 1.5)
			main.ui.caption(LINES["hymn"]["back"], 2.0)
	elif not gap and fmod(_hymn_t, 12.0) < delta and not f.has("cinematic"):
		main.ui.caption(main.CHANT[int(_hymn_t / 12.0) % main.CHANT.size()], 3.5)
	if not f.has("tu_hushed") and pp.z < -250.0 and pp.z < DOOR_A_Z and pp.z > DOOR_B_Z - 12.0 and fmod(_hymn_t + 6.0, 14.0) < delta:
		main.ui.show_toast(LINES["speaker"]["calls"], 3.0)


## Eyeless rules (bible-1): frames on, they orient to Carl and walk at a
## walking pace; frames off, he is not there. In the corridor the hymn's
## silences and the speaker's calling let them hear him without the frames.
func _tick_eyeless(delta: float, pp: Vector3) -> void:
	var f: Dictionary = main.flags
	var on: bool = main.frames_on
	for e: Dictionary in eyeless:
		var fg: Node3D = e["fig"]
		var lane: int = e["lane"]
		if lane == 8 or not (fg.get_parent() as Node3D).visible:
			continue
		var d: Vector3 = pp - fg.global_position
		var dist := d.length()
		if absf(d.y) > 3.0:
			continue
		var hear := false
		if lane >= 6:
			hear = (_gap and dist < 9.0) or (not f.has("tu_hushed") and dist < 5.0)
		var rng_m: float = e["range"] * (1.5 if (lane >= 6 and not f.has("tu_hushed")) else 1.0)
		if f.has("cinematic") or _busy:
			continue
		if (on or hear) and dist < rng_m:
			fg.rotation.y = lerp_angle(fg.rotation.y, atan2(-d.x, -d.z), minf(1.0, delta * 2.5))
			Anim.look(fg, pp + Vector3(0, 1.6, 0), 1.0, 0.08)
			var flat := Vector3(d.x, 0, d.z)
			var home: Vector3 = e["home"]
			if flat.length() > 0.6 and fg.global_position.distance_to(home) < rng_m:
				var speed := 1.4 if not hear or on else 0.9
				fg.position += flat.normalized() * minf(speed * delta, flat.length())
				Anim.walk(fg, _t, 0.85, float(lane), 0.8)
			if dist < 0.95 and _touch_cd <= 0.0:
				_touched(e)
				return
		elif on and (e["patrol"] as Array).size() > 1:
			var pts: Array = e["patrol"]
			var tgt: Vector3 = pts[int(e["pi"]) % pts.size()]
			var dd := tgt - fg.position
			dd.y = 0.0
			if dd.length() < 0.3:
				e["pi"] = int(e["pi"]) + 1
			else:
				fg.position += dd.normalized() * minf(0.8 * delta, dd.length())
				fg.rotation.y = lerp_angle(fg.rotation.y, atan2(-dd.x, -dd.z), minf(1.0, delta * 3.0))
				Anim.walk(fg, _t, 0.5, float(lane), 0.6)


## Touched: +5, back to the last safe place, and they go back to theirs.
func _touched(e: Dictionary) -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	_touch_cd = 4.0
	f["tu_touched"] = int(f.get("tu_touched", 0)) + 1
	main.play("whisper", -2.0, 0.6)
	p.shake(0.5)
	ui.glitch(0.8, 0.5)
	main.add_connection(5.0, LINES["eyeless"]["touched_why"])
	ui.show_toast(LINES["eyeless"]["toast"], 3.0)
	var to: Vector3 = e["reset"]
	if int(e["lane"]) >= 6:
		to = _checkpoint
	p.position = to
	p.velocity = Vector3.ZERO
	for x: Dictionary in eyeless:
		if int(x["lane"]) == 8:
			continue
		var fg: Node3D = x["fig"]
		fg.position = x["home"]
		fg.rotation.y = float(x["yaw"])
		x["pi"] = 0
	_place_party(p.position)
	if not f.has("cinematic") and not _busy:
		_busy = true
		await ui.think(LINES["eyeless"]["touched"])
		ui.close()
		_busy = false


# ------------------------------------------------------------------ helpers

func _frames(on: bool) -> void:
	main.frames_on = on
	main.ui.set_frames(1.0 if on else 0.0, main.connection)
	set_glyph_visibility(on, main.connection)
	main.play("on" if on else "off", -6.0)
	_eye_vis = on
	_eye_layer()
	main.update_hud()


## The eye layer: door C, the words over the two doors, the footprints.
func _eye_layer() -> void:
	var on: bool = main.frames_on
	for n in eye_layer:
		(n as Node3D).visible = on
	for it in eye_its:
		set_active(it, on)
	for s in footprints:
		(s as Node3D).visible = on
	green_eye_m.emission_energy_multiplier = 2.2 if on else 0.6


func _torches(on: bool) -> void:
	torch.light_energy = 3.2 if on else 0.0
	for pd: Dictionary in party:
		var sp: SpotLight3D = (pd["fig"] as Node3D).get_meta("torch")
		sp.light_energy = 1.4 if on else 0.0
	if lynx.visible:
		lynx_torch.light_energy = 1.4 if on else 0.0


func _fade(ap: Node, db: float, t: float) -> void:
	if ap == null or not is_instance_valid(ap):
		return
	if not ap.playing:
		ap.volume_db = -80.0
		ap.play()
	create_tween().tween_property(ap, "volume_db", db, t)


func _stop_loops() -> void:
	for k in main.amb:
		var ap = main.amb[k]
		if is_instance_valid(ap):
			ap.stop()


func _stand(fig: Node3D) -> void:
	for l in fig.get_meta("legs"):
		(l as Node3D).rotation.x = 0.0
	for k in fig.get_meta("knees", []):
		(k as Node3D).rotation.x = 0.0
	(fig.get_meta("body") as Node3D).rotation.x = 0.0


## Walk a figure along points, then stand.
func _move(fig: Node3D, pts: Array, speed: float) -> void:
	for pt: Vector3 in pts:
		var t := 0.0
		while is_inside_tree() and t < 20.0:
			var d := pt - fig.position
			var dist := d.length()
			var dt := get_process_delta_time()
			t += dt
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
		_stand(fig)
		Anim.idle(fig, _t, 0.0)


# ------------------------------------------------------------------ dev args and the self-test

## scene=car|mouth|st|rr|tunnel|hub|chamber|gallery|doors|open poses the
## level for a screenshot (with --at=x,y,z --yaw --pitch --frames=1).
func apply_args(a: Dictionary) -> void:
	_shot = a.has("shot")
	var f: Dictionary = main.flags
	var sc := str(a.get("scene", ""))
	if sc == "":
		_eye_layer()
		return
	f["tu_route"] = "st" if sc == "st" else ("rr" if sc == "rr" else "rc")
	if sc in ["tunnel", "hub", "chamber", "gallery", "doors", "open"]:
		f["tu_mouth"] = true
		_torches(true)
	if sc == "mouth":
		big_eye.visible = true
		eye_flash.light_energy = 6.0
		eye_flash.position = Vector3(RC_FACE + 6.0, 12.0, 0)
		_torches(true)
	if sc == "st":
		tyson.visible = true
		fire_light.light_energy = 1.4
		var fire := dyn.get_node_or_null("fire")
		if fire:
			(fire as Node3D).visible = true
	if sc in ["chamber", "gallery", "doors", "open"]:
		f["tu_descended"] = true
		f["tu_chamber"] = true
	if sc in ["gallery", "doors", "open"]:
		f["tu_door_a"] = true
		door_a.position.y = LOW + 2.75
	if sc in ["doors", "open"]:
		f["tu_door_b"] = true
		f["tu_doors_seen"] = true
		door_b.position.y = LOW + 2.75
	if sc == "open":
		_opened = "both"
		door_l.position.x -= 2.1
		door_r.position.x += 2.1
		lynx.visible = true
		lynx.position = Vector3(DOOR_X - 0.2, LOW, DOOR_Z + 0.3)
		lynx.rotation.y = 0.0
	_eye_layer()
	main.update_hud()


## Shots only: the party ahead of the camera, off to the sides and
## looking where it looks, so a frame is not all backs of heads.
func _pose_party() -> void:
	var p = main.player
	var pp: Vector3 = p.position
	var fwd := _fwd(p.yaw)
	var right := Vector3(-fwd.z, 0, fwd.x)
	var k := 0
	for pd: Dictionary in party:
		var fg: Node3D = pd["fig"]
		fg.position = pp + fwd * (3.4 + k * 2.2) + right * (2.6 if k % 2 == 0 else -2.8)
		fg.position.y = pp.y
		turn_to(fg, fg.position + fwd * 5.0)
		Anim.idle(fg, 0.0, float(k))
		k += 1


func _by_id(id: String) -> void:
	for n in main._all_with_meta(self, "id"):
		if is_instance_valid(n) and str(n.get_meta("id")) == id:
			await main.interact(n)
			print("ok ", id)
			return
	print("MISSING ", id)


func _wait(cond: Callable, secs: float) -> void:
	var t := 0.0
	while not cond.call() and t < secs:
		await get_tree().process_frame
		t += get_process_delta_time()


func _idle(secs: float) -> void:
	await _wait(func() -> bool: return not _busy and not main.flags.has("cinematic") and not main.ui.busy, secs)


func selftest() -> void:
	# headless on llvmpipe the whole city renders slowly; the test is of
	# the script, so the level is hidden while it runs (it still ticks)
	visible = false
	var p = main.player
	var f: Dictionary = main.flags
	# a Tunnels-only run has no Act 1-2 state: the words Act 3 expects
	for w in ["dreamer", "sleeper", "hush", "bow", "filter"]:
		if not main.lexicon.has(w):
			main.lexicon.append(w)
	f["broadcast_seen"] = true
	await intro()
	print("ok intro knife=", f.has("ev_knife"), " lynx=", _lynx_mode)
	# the car: the pump picks the second way, Southtown
	await _by_id("car")
	print("ok route ", f.get("tu_route", ""))
	p.position = Vector3(0.5, 0.1, ST_PORTAL + 3.0)
	await _wait(func() -> bool: return f.has("tu_mouth"), 6.0)
	await _idle(60.0)
	print("ok st mouth ", f.has("tu_mouth"), " gate=", f.has("tu_st_open"))
	for id in ["footprints", "st_layers", "st_drain", "st_portal", "drills", "depot", "rc_sign", "rat", "rr_station", "alley"]:
		await _by_id(id)
	# the other two mouths, and Tyson's way, for the script's sake
	for r in ["rc", "rr", "st"]:
		f.erase("tu_mouth")
		f["tu_route"] = r
		if r == "rr":
			f.erase("tu_double")
			_frames(true)
			await _double()
		if r == "st":
			tyson.visible = true
		await _mouth(r)
		await _idle(30.0)
		print("ok mouth ", r, " ", f.has("tu_mouth"))
	tyson.visible = false
	# the tunnel: the ringing
	p.position = Vector3(30.0, 0.1, 0.0)
	await _wait(func() -> bool: return f.has("tu_ringing"), 6.0)
	await _idle(60.0)
	print("ok ringing ", f.has("tu_ringing"))
	for id in ["cache", "terminal", "forner"]:
		await _by_id(id)
	print("ok side rooms cache=", f.has("tu_cache"), " log7=", f.has("ev_hameron_log_7"), " forner=", f.has("ev_forner_frames"))
	# the hub: the green eye, then the manhole and the chamber
	p.position = Vector3(0.0, 0.1, 3.0)
	await _wait(func() -> bool: return f.has("tu_eye"), 6.0)
	await _idle(60.0)
	print("ok eye ", f.has("tu_eye"))
	await _by_id("manhole")
	await _idle(60.0)
	print("ok chamber ", f.has("tu_chamber"), " y=", snappedf(p.position.y, 0.1))
	# the corridor: door A (the pump says sleeper: wrong), then dreamer
	p.position = Vector3(0, LOW + 0.1, DOOR_A_Z + 1.6)
	await _by_id("door_a")
	await _door_word("door_a", "dreamer")
	print("ok door a ", f.has("tu_door_a"), " hymn=", f.has("tu_hymn"))
	p.position = Vector3(2.5, LOW + 0.1, LZ - 38.0)
	if not main.frames_on:
		_frames(true)
	await _by_id("door_c")
	await _by_id("speaker")
	await _hack_speaker("hush")
	print("ok speaker hushed=", f.has("tu_hushed"))
	# frames on beside the patrolling eyeless: touched, back to the door
	var e1: Node3D = eyeless[6]["fig"]
	p.position = e1.global_position + Vector3(0.6, 0.1, 0.4)
	await _wait(func() -> bool: return int(f.get("tu_touched", 0)) >= 1, 8.0)
	await _idle(20.0)
	print("ok touched ", f.get("tu_touched", 0), " at z=", snappedf(p.position.z, 0.1))
	# the hymn's silence
	_hymn_t = 39.8
	await get_tree().create_timer(1.0).timeout
	print("ok hymn gap=", _gap)
	_frames(false)
	p.position = Vector3(0, LOW + 0.1, DOOR_B_Z + 1.6)
	await _by_id("door_b")
	await _idle(10.0)
	print("ok door b ", f.has("tu_door_b"), " lynx=", _lynx_mode)
	# the two doors
	p.position = Vector3(0, LOW + 0.1, TD.z + 2.0)
	await _wait(func() -> bool: return f.has("tu_doors_seen"), 6.0)
	await _idle(60.0)
	print("ok doors seen ", f.has("tu_doors_seen"))
	# a wrong prayer (the pump picks sleeper): a round with the eyeless
	await _by_id("kneel")
	print("ok wrong prayer touched=", f.get("tu_touched", 0), " opened=", _opened)
	# filter: the right door only; Emmet bleeds for the left; the void
	await _prayer("filter")
	print("ok filter prayed=", f.get("tu_prayed", ""), " lynx=", f.get("tu_lynx", ""), " done=", f.has("two_doors_done"))
	# bow, with Lynx warned and present (the plea), then at -1 (the betrayal)
	for t in [1, -1]:
		_opened = ""
		_ended = false
		main.trust["lynx"] = t
		f["warned_lynx"] = true
		f["lynx_has_drive"] = true
		lynx.visible = true
		lynx.position = Vector3(1.0, LOW, DOOR_Z + 2.2)
		party = [{"fig": turan, "lag": 7}, {"fig": emmet, "lag": 11}]
		p.position = Vector3(0, LOW + 0.1, TD.z)
		await _prayer("bow")
		print("ok bow trust=", t, " lynx=", f.get("tu_lynx", ""), " prayed=", f.get("tu_prayed", ""))
	_ended = true
	print("ok two_doors_done=", f.has("two_doors_done"), " conn=", main.connection)
	await main.selftest_all_interactables()
	visible = true
