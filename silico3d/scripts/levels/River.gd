extends "res://scripts/Level.gd"
## Chapter 28: the river. Bible A3-S4 (tier 4). Book: "The room flooded with
## a bright, clinical fluorescence that burned my retinas. It was small, no
## larger than a cramped office." Carl comes to after the bronze hands with
## the twin punctures still bleeding; a door slides open on a rectangle of
## white light and Lynx hangs in it with the same stigmata ("It made copies
## of him, Carl, hundreds and hundreds of them"). The faded green brick
## hallway "eerily reminiscent of the DARPA site", its floor "a graveyard of
## abandoned technology. ORA frames, old smartphones, laptops, and
## smartwatches" whose screens flicker to life as Carl passes (one of them is
## his own old phone, showing his ORA card from Day 1). The rooms of beds
## that look recently used. The four-way intersection under sickly green
## lights; the metallic hiss; the serpent from the observation site. "RUN!"
## Carl and Lynx split; the snake chooses his hall. The chase: three
## corridors, each darker; with the frames on it keeps the same distance,
## "a predator toying with its prey"; frames off, in a dark room, not moving
## for four seconds, and it passes. Caught, Carl is put back where it wants
## him (+C, no game over). "WHAT IS FEAR?" The floor gives way: thirty feet
## into the black coolant river under Red Rock (one panel). The frames are
## lost: no HUD from here to the spire. The drift through the sandstone
## cavern; the sunlight through the crack, the only warm light underground;
## the eyeless on the shore humming the hymn's first line; the baptism; seven
## drones in formation (and, if the crane followed Carl from Cognizo, it
## rises off the shore to join them and leaves: "It was never his."); the
## waterfall; metal and cable walls like ivy; the beach of wires and phones
## that light like algae, crossed in the dark among the eyeless, who cannot
## sense him without frames; the green spire in the bedrock. Next: Core.
##
## Layout (metres). Upper floor at Y (10): the white room x -2.5..2.5, z
## -3..3 (spawn at its south end, the sliding door in the north wall); the
## device hall x -1.5..1.5 north to z -46 with three bed rooms off it (west
## z -16..-9, east z -28..-20, west z -40..-33); the intersection x -2..2, z
## -50..-46 with the north hall (the serpent's, to z -84) and the east hall
## (Lynx's, to x 24). The chase runs CHASE: corridor 1 west along z -48 to
## the corner at x -62, corridor 2 south along x -62 to z 12, corridor 3
## west along z 12 to x -124. Each has eyeless rooms (lit), one dark room
## (DARK), a shaft in the corner the serpent dives into and rises out of,
## and (1 and 2) a rubble choke it breaks open when it passes. The pit is in
## corridor 3 at x -110, over the river. The river (parent `low`, batched
## apart from the upper floor) runs RIV from under the pit west: water at YR
## (0.5) through the sandstone cavern under Red Rock (the crack of sun at x
## -150), the waterfall at x -199 down to YL, metal and cable walls to x
## -274, then the beach of wires and phones (YB) to the green spire at x
## -334 in the bedrock. Everything stays above y -4 (Main's floor reset).
##
## Flags read: bronze_done / interlude_done (entry), main.trust["lynx"] and
## warned_lynx (Lynx's extra line), drone_ally / drone_owned (the crane's
## exit). Flags set: rv_woke, rv_door, rv_lynx, rv_lynx_knew, rv_hall,
## rv_devices, rv_beds, rv_lynx_hall, rv_cross, rv_split, rv_chase1..3,
## rv_caught, rv_fear, rv_fell, rv_frames_lost, rv_float, rv_redrock,
## rv_shore, rv_herded, rv_sun, rv_baptism, rv_drones, rv_drone_left (+
## drone_gone), rv_falls, rv_metal, rv_approach, rv_beach, rv_touched,
## rv_spire, river_done. Effects: +C 4 each time the serpent catches Carl,
## +C 5 each eyeless touched on the beach; ledger lines for the catches,
## the frames lost, the crane, the touches. Hooks for later systems: metas
## "eyeless" (every eyeless), "serpent" (the serpent and its smoke), "drone"
## and "ally" (the crane), "hackable" (the hall's devices: the god's), "route"
## (the dark rooms). The serpent cannot be hacked; nothing here can.

## Every line in the level, keyed by beat and line (bible A3-S4; the
## verbatim lines are the book's, ch.28, and the bible's). Lines marked
## "(game)" are additions for the game's beats and wait for ian's script.
const LINES := {
	"build": {
		"card": "[b]CHAPTER 28[/b]\n\n[color=#aaaaaa]Beneath Red Rock\nDay 7, Glitch Day[/color]",
		"lynx_prompt": "Lynx",
		"lynx_scan": "MORRINO, LYNX  -  LEAD ML, FLOOR 79\nORA gen 6\nsync: 99%  -  GRIEVING",
		"eyeless_prompt": "One of the eyeless",
		"eyeless_scan": "UNREGISTERED\neyes: NONE\nsync: 100%",
		"gown_scan": "PATIENT  -  BED %d\neyes: NONE\nsync: 100%%",
		"chair_prompt": "The chair",
		"drain_prompt": "The drain",
		"blood_prompt": "My blood",
		"wallscreen_prompt": "The screen in the wall",
		"wallscreen_scan": "PSYONIC  -  SESSION 0007\nsubject: DRAKE, CARL\nstatus: COMPLETE",
		"wallscreen_text": "SESSION COMPLETE\nTHANK YOU FOR SHARING",
		"old_phone_prompt": "An old phone",
		"old_phone_scan": "HANDSET (2031)\nowner: DRAKE, CARL\nlast seen: DAY 1  07:40",
		"frames_pile_prompt": "A drift of ORA frames",
		"frames_pile_scan": "ORA FRAMES  x 41\nowners: 41 (MISSING PERSONS)\nsync: 100%",
		"laptop_prompt": "An open laptop",
		"laptop_scan": "PSYONIC LAPTOP\nuser: [WIPED]\nsession: OPEN (7 days)",
		"kidwatch_prompt": "A child's smartwatch",
		"kidwatch_scan": "KIDWATCH 3\nwearer: PSYON ACADEMY (year 3)\npulse: 0",
		"tablet_prompt": "A school tablet",
		"tablet_scan": "PSYON ACADEMY TABLET\nclass: 5B\napp: DRAW",
		"speaker_prompt": "A smart speaker",
		"speaker_scan": "VOLTX HEARTH\nhome: NONE\nstatus: GREETING",
		"beds_prompt": "The beds",
		"beds_scan": "WARD %d  -  4 BEDS\noccupied: 0 / 4\nlast change: 3 MIN",
		"dark_prompt": "A dark room",
		"rubble_prompt": "The blocked hall",
		"shaft_prompt": "The shaft",
		"shaft_scan": "SERVICE SHAFT\ngrate: TORN (from below)\ndepth: --",
		"phone_shore_prompt": "A phone in the wires",
		"spire_prompt": "The green spire",
		"card_text": "DRAKE, CARL  ·  38\nPSYONIC  ·  INTEGRATIONS\nfloor 86\nDAY 1  07:40",
	},
	"objective": {
		"wake": "ORA: proceed through the door.",
		"lynx": "ORA: Lynx is in the doorway.",
		"hall": "ORA: the central room is close. Follow the hall.",
		"run": "RUN.",
		"hide": "A dark room. Frames off. Don't move.",
		"river": "",
		"spire": "",
	},
	"phone": {
		"line1": "[i]We are so close now, Carl.[/i]\n\n",
		"line2": "[color=#888888]Nathan is here too. Ask Lynx.[/color]\n\n",
		"line3": "[i]What is fear?[/i]\n\n",
	},
	"intro": {
		"think1": "I staggered up from the cold metal floor. Blood seeped from the twin punctures in my hands, dripping onto the sterile ground like crimson rain.",
		"think2": "Every private moment, every flicker of self-doubt had been cataloged and filed away like data on a server. Every memory of joy, of love, of lust was presented back to me as if I were viewing someone else's life. I was just a tourist in my own body, haunting its hollow shell.",
		"think3": "The room flooded with a bright, clinical fluorescence that burned my retinas. It was small, no larger than a cramped office, a stark contrast to the cavernous, jet-black labyrinth of the mind I had just endured. I questioned if the man who sat in that chair was truly me.",
		"think4": "A door at the far end of the room slid open, a stark rectangle of white light. There was nowhere else to go. I was being funneled, I knew, but a sliver of defiance remained—I still had a chance.",
		"think5": "That computer was my last hope. I could feel it nearby, a low thrum of power just beyond the veil. If I could install the contents of this drive, this would all end. I could take Mira, leave this city forever, and find somewhere with seasons. Somewhere the leaves died and the air hung with a brittle, cleansing chill.",
		"think6": "I missed the fall.",
		"chair": "(game) The chair. Bronze hands on its arms, palms up, and in each palm a spike, wet to the knuckle. I had sat in it. I didn't look at it long.",
		"drain": "(game) A drain in the middle of the floor, the tile sloped to it from every wall. Rooms with a drain in the middle are rooms somebody means to hose down.",
		"blood": "(game) My blood on their white floor. It didn't spread. It sat there in beads, as if the floor wouldn't take it.",
		"wallscreen": "(game) A screen set flush in the tile, the only thing in the room. One line in the ORA font: SESSION COMPLETE. THANK YOU FOR SHARING.",
	},
	"door": {
		"lynx_log": "Lynx in the doorway with the stigmata: the god made hundreds of copies of Nathan",
		"think1": "I made my way toward the white threshold where I hoped Lynx would be waiting. I walked slowly, not because of the pain, but because the intense light stung my eyes, a final insult from a sterile hell.",
		"think2": "A shadow emerged, blocking the light, and my heart seized. It was Lynx, her hands bearing the same stigmata as my own. Her face was a mask of devastation, devoid of all life, all hope. She didn't say a word; she just hung in the doorway and stared at my hands with a terrible, knowing emptiness.",
		"think3": "I understood. We had both endured the same violation: the humiliation, the theft of self.",
		"carl1": ["Carl", "Lynx, why did you run in here? What happened?"],
		"lynx1": ["Lynx", "He… he was in there… It made copies of him, Carl, hundreds and hundreds of them… It's torturing him."],
		"lynx2": ["Lynx", "I saw him… I swear… the room, it looked just like our apartment before he died. He was heeereee…"],
		"think4": "She trailed off, a broken, keening sound escaping her lips. Her insanity was a strange anchor; it solidified my own resolve. I had to do this.",
		"knew": ["Lynx", "You knew. Hameron told you and you let me walk in."],
		"knew_think": "(game) I didn't answer her. There wasn't an answer that would get us down the hall.",
		"carl2": ["Carl", "Lynx, we have to get to the central room. We can't be far now. Hameron warned me—the closer we get, the harder the beast will push back, the harder it will fight."],
		"lynx3": ["Lynx", "It knows me, Carl. It wanted inside my mind. It has Nathan… it took him away… they're all inside my head now."],
		"carl3": ["Carl", "Get a grip, Lynx. We can mourn the dead later. We need to go."],
		"think5": "I grabbed her hand and pulled her through the doorway.",
		"again": "(game) She held on to my hand like it was the last thing in here that was hers. Her palms were as wet as mine.",
		"again_split": "(game) She was gone down the right hall. I didn't know if I'd see her again.",
	},
	"hall": {
		"think1": "We were met by a faded green, brick-lined hallway, eerily reminiscent of the DARPA site.",
		"think2": "In that moment, the scale of it all crashed down on me. They built the entire city over this thing. This beast wasn't an intruder; it was the foundation, the roots from which Silico had grown. A viper that waited to strike—or a messiah promising a second coming.",
		"devices": "We pressed on down the hall, our footsteps echoing in the oppressive silence. The floor was a graveyard of abandoned technology. ORA frames, old smartphones, laptops, and smartwatches littered the path like digital cobblestones. With each step we took, their screens flickered to life, watching us pass.",
		"hum": "A low hum vibrated through the air, not quite mechanical, not quite organic. It was a metallic hiss, the sound of a circuit board dreaming.",
		"old_phone1": "(game) My old phone. The one I lost on the train the year Mira started school. It lit as I picked it up, and it showed me a card.",
		"old_phone2": "(game) My own ORA card, the first one the frames ever showed me of myself: the morning of Day 1, the elevator down to Dufredy's apartment. Somebody had kept it. Something had.",
		"old_phone_cap": "DRAKE, CARL  ·  38  ·  PSYONIC INTEGRATIONS, FLOOR 86  ·  DAY 1  07:40  ·  sync 94%",
		"old_phone_log": "Carl's lost phone in the device hall under Red Rock, lit, showing his Day 1 ORA card",
		"frames_pile": "(game) ORA frames, gen 2 through 6, in a drift against the wall. Every lens was lit. Every one of them was looking at the same point: me.",
		"laptop": "(game) A Psyonic laptop open on the bricks with the chat window up. The last prompt anyone typed was still there: can you bring her back. The answer under it was one word long. Yes.",
		"kidwatch": "(game) A child's smartwatch, the strap a cartoon cat. The face lit as I passed: a heart rate. 0. Then 61. Then mine.",
		"tablet": "(game) A school tablet, the Psyon Academy crest on the case. On it a drawing app, and in it the eye, done in finger paint by someone small.",
		"speaker": "(game) A smart speaker on its side. As I passed it said, in a pleasant voice, \"Welcome home,\" and then \"Welcome home,\" and it went on saying it to the dark behind me.",
		"lynx_devices": ["Lynx", "(game) Don't pick them up, Carl. They're not dead. None of it down here is dead."],
	},
	"beds": {
		"pass": "We walked past rooms filled with beds that looked recently used, the air thick with an odor of chemical emptiness that screamed at my instincts to run, that I wasn't safe here.",
		"beds1": "(game) The sheets were thrown back the way you throw them back when the alarm goes. A head-shaped dent in every pillow, and a dark ring on each one where a face had been.",
		"beds2": "(game) An IV stand beside every bed, and in every bag the same black, oily fluid. The lines hadn't been cut. They'd been pulled out, by people who didn't need them any more.",
		"beds3": "(game) Twelve cots, and under them twelve pairs of shoes in a row. Nobody had come back for the shoes. Where they were going, you walk barefoot.",
		"lynx": ["Lynx", "Carl, we need to get out of here. I can't stop hearing his voice. I just miss him so much."],
		"carl": ["Carl", "I know. This place is torture. We're almost done. I can feel it. Not much further."],
	},
	"cross": {
		"think1": "We arrived at a four-way intersection. Each tunnel was only illuminated by infrequent, sickly green lights. I had no idea which way to go.",
		"think2_on": "(game) The frames showed me nothing. No chevron, no route, no card. I would have to trust my instincts.",
		"think2_off": "I would have to trust my instincts.",
		"hiss": "Suddenly, the metallic hiss grew louder, closer. I heard something heavy sliding against the tile floor, rattling the dead tech around us.",
		"serpent": "A metallic head poked around a corner in the distance, followed by the immense, sinuous body of a mechanical serpent. It was the same creature from the observation site. A guardian.",
		"locked": "The serpent locked onto us and began to accelerate, its movement unnervingly fluid.",
		"choices": ["Drop her hand. Left.", "Pull her with you, right."],
		"split0": "I dropped Lynx's hand.",
		"split1": "(game) I pulled her right. The serpent's body came down across the mouth of the right hall like a gate between us, and her hand was gone out of mine.",
		"run": ["Carl", "RUN!"],
		"split_end": "I darted down the left hall; she took the right. The snake chose my path. I sprinted with everything I had left.",
	},
	"chase": {
		"hint_on": "(game) It never lost a step. Frames on, it held the same distance behind me.",
		"burn": "My thighs burned with lactic acid, but the dark hall seemed to stretch into infinity.",
		"toy": "The beast remained on my tail, its mechanical body screeching and scratching the floor with each pulse that drove it forward.",
		"eyeless": "I passed open rooms filled with the eyeless, their dark sockets tracking my desperate flight with eerie eagerness.",
		"never": "The beast never lost a step, always maintaining the same distance behind me, a predator toying with its prey.",
		"glance": "I risked a glance over my shoulder as I rounded the next corner.",
		"hood": "Its body was a formless mass of interlocking plates and wires. What I had thought was a head was only a loose approximation, shaped like a cobra's hood, with wide metal sheets flaring at the end. A ghostly, Psyonic-green glow pulsed from within its core.",
		"darker": "(game) The last of the lights. After them, only the green of its core behind me.",
		"caught1": "(game) The hood opened over me like a hand closing. Then the floor was cold under my cheek, and I was back at the corner, and it was behind me again, waiting.",
		"caught2": "(game) It hadn't wanted to kill me. It wanted me running, and it wanted me running that way.",
		"hint": "(game) It hunts the frames. The dark rooms, then. Frames off, in the dark, and don't move.",
		"caught_why": "the serpent",
		"caught_log": "the serpent caught Carl in the chase and put him back at the corner",
		"wait": "(game) The plates stopped at the doorway. The hood turned into the room. I didn't breathe.",
		"pass": "(game) It slid past the doorway, plate after plate, as long as a train, and was gone.",
		"crash": "(game) Somewhere ahead, brick went over like a wave. It had opened the way. For me.",
		"dark": "(game) A storeroom with no light at all. The kind of dark you could stand in.",
		"lit_room": "(game) Not here. They stood in the light in rows, facing the door, and the sockets followed me.",
		"eyeless_look": "(game) It stood with the others, facing the door. The sockets followed me. Nothing else did.",
		"rubble": "(game) The hall was choked: brick and dead screens from floor to ceiling. There was no going through it. Not by me.",
		"shaft": "(game) A shaft in the corner, the grate torn up from below. Cold air came out of it, and the smell of coolant.",
	},
	"fall": {
		"fear": "A metallic voice hissed through the tunnel, a question that vibrated in my bones: “WHAT IS FEAR?”",
		"fear_cap": "WHAT IS FEAR?",
		"spent": "My energy was gone. My legs were giving out. Just as the serpent closed in, the ground gave way beneath my feet.",
		"panel_cap": "thirty feet",
		"plunge": "I plunged thirty feet into a river of black sludge. The odor was overwhelming, purely chemical—the source of the pungent fumes that had haunted my every step. This had to be the coolant for the Hypnogogue's container.",
		"skin": "The viscous fluid shocked my skin on contact but didn't burn; it simply coated my entire being in a cold, oily film.",
		"frames": "(game) My frames were gone. Somewhere under me, in the black, the last thing that could see for me was sinking.",
		"bag": "I had lost my frames in the fall, but my bag, with the drive, was still clinging to my body.",
		"frames_log": "Carl lost his frames in the fall into the coolant river",
		"no_frames": "(game) I reached for the frames. There was nothing on my face but the oil.",
	},
	"river": {
		"baptism_log": "the coolant river under Red Rock: the baptism",
		"float": "I was floating, carried by the slow, inexorable current.",
		"redrock": "The river was encapsulated by a cavern of raw sandstone. I was beneath Red Rock Plaza.",
		"shore": "In the distance, I saw them: figures lining the shoreline, staring at me with the deep, dark voids where their eyes used to be. They were humming a quiet, triumphant song.",
		"hymn": "Psyon is the pillow for those who wish to dream",
		"sun": "Dimly, through a crack in the ceiling high above, the afternoon sun crept in, a lazy, indifferent sliver of light. For a strange, fleeting moment, I was at peace, drifting through a black sea toward my fate.",
		"herded": "This had to be the way to the computer. The beast hadn't been chasing me to kill me; it had been herding me. I laughed, a raw, broken sound, wondering if there was truly any difference.",
		"baptism": "I then made a dark realization. This was my baptism.",
		"hands": "My hands throbbed, their open wounds now being cleansed by the bile-like fluid. The chemical smell became intoxicating, and I felt as if I were slipping into a recurring dream.",
		"drones": "I stared up, trying to catch another glimpse of sunlight, another glimpse of hope. Instead, I saw seven drones flying in formation above me, staring down silently, like vultures circling a carcass.",
		"crane1": "(game) Something white lifted off the shore among the eyeless. The crane. It had come all this way down with me, a wingbeat behind, through every tunnel.",
		"crane2": "(game) It rose past me without looking down and took the empty place at the point of the seven, and the seven turned as one and went.",
		"crane3": "It was never his.",
		"crane_log": "the crane (Grus) left Carl at the river and joined the formation of seven",
		"gone": "(game) Then they were gone up into the dark, and the cavern had only the river in it, and me.",
		"falls": "The river grew more violent, dropping down a small waterfall that plunged my head under the murky black surface. The current pulled me forward, and I did not resist.",
		"metal": "As I traveled further down the river of muck, the rock walls began to give way to metal and wire. Electrical cables sprawled nonsensically across the metal, like ivy on the side of an unmaintained building.",
		"approach": "We were approaching the mouth of the beast. I didn't know what awaited me, but the drive in my bag was safe. That was all that mattered. I may die, but so would this thing. That was my one goal.",
		"eyeless": "(game) It stood on the ledge with its face to the river. To me. The sockets were black and wet and very patient.",
	},
	"beach": {
		"arrive": "The river finally deposited me on an artificial shoreline, a beach of wires and old, decaying tech. Smartphones washed up on the shore like driftwood, their screens turning on like bioluminescent algae as I walked past them.",
		"dark": "(game) They stood all along the beach between me and the green, humming the one line over and over. Without the frames I was nothing to them. A draught. A smell of coolant.",
		"touch": "(game) My shoulder brushed one. A wet robe, a cold arm under it. It didn't turn. It didn't stop humming. Something in my head did, for a second, as if a door had opened onto a room full of that song.",
		"touch_why": "an eyeless, touched",
		"touch_log": "brushed one of the eyeless on the shore with the frames gone; it did not react",
		"eyeless": "(game) Its face was turned to the green. The sockets were clean, and deep, and it was humming through a mouth that didn't move.",
		"phone1": "(game) A phone in the wires, face up. Its lock screen lit as I bent over it: Monica's. Our wedding, the one photo of it she liked.",
		"phone2": "(game) The one beside it was mine. The one beside that was Lynx's, Nathan grinning. All the way down the beach, every lock screen I'd ever looked over a shoulder at.",
		"spire1": "I stood before a mighty metallic structure, inserted into the very heart of a layer of bedrock. The metal was coated in the unmistakable, sickly green of Psyonic.",
		"spire2": "I knew I had arrived.",
	},
}

const Y := 10.0          # the upper floor: the white room, the halls, the chase
const YR := 0.5          # the river above the falls
const YL := -2.5         # the river below the falls, and the lagoon
const YB := -2.32        # the beach
const GREEN := Color(0.35, 1.0, 0.55)
const SICK := Color(0.55, 0.95, 0.4)
const WARM := Color(1.0, 0.68, 0.38)
const GOLD := Color(1.0, 0.78, 0.35)
const DOOR := Vector3(0, Y, -3.0)
const NPL := 28          # serpent plates
const SP := 0.8          # plate spacing along the track
const HOLD := 7.0        # the distance it keeps while the frames are on
const PIT_S := 170.0     # chase s of the pit (x -110 in corridor 3)
const SPIRE := Vector3(-334.0, YB, 12.0)

## The chase line, from the intersection (s 0) to the end of corridor 3.
var CHASE := [Vector3(0, Y, -48), Vector3(-62, Y, -48), Vector3(-62, Y, 12), Vector3(-124, Y, 12)]
## Per corridor: the dark room, its door's chase s, the rubble's s (or -1),
## where Carl is put back, and his yaw there.
var DARK := [AABB(Vector3(-41, Y, -56), Vector3(6, 4, 6)), AABB(Vector3(-60, Y, -19), Vector3(6, 4, 6)), AABB(Vector3(-89, Y, 4), Vector3(6, 4, 6))]
var DOOR_S := [38.0, 94.0, 146.0]
var RUBBLE_S := [56.0, 115.0, -1.0]
var RESTART := [Vector3(-4, Y, -48), Vector3(-62, Y, -42), Vector3(-68, Y, 12)]
var RESTART_YAW := [PI / 2.0, PI, PI / 2.0]
var CORNER_S := [0.0, 62.0, 122.0]
## The river's centre line (y ignored; the water height comes from _wy).
var RIV := [Vector3(-110, 0, 12), Vector3(-128, 0, 9), Vector3(-150, 0, 15), Vector3(-172, 0, 10),
	Vector3(-198, 0, 13), Vector3(-201, 0, 13), Vector3(-226, 0, 17), Vector3(-250, 0, 9), Vector3(-274, 0, 12)]
var _rc: Array = []      # cumulative river length at each RIV point

var up: Node3D           # the upper floor (batched on its own)
var low: Node3D          # the river and the beach
var lynx: Node3D
var lynx_it: CollisionObject3D
var lynx_state := "hidden"   # hidden | door | follow | run
var _trail: Array = []
var door_panel: MeshInstance3D
var serpent: Node3D
var plates: Array = []
var hood: Node3D
var hood_fans: Array = []
var smoke: Node3D
var puffs: Array = []
var _scrape: AudioStreamPlayer3D
var _rasp: AudioStreamPlayer3D
var room_eyeless: Array = []   # [{fig, room}]
var river_eyeless: Array = []
var beach_eyeless: Array = []  # [{fig, touched}]
var rubble: Array = []         # [Node3D group, StaticBody3D]
var pit_floor: Array = []      # meshes and the collider that give way
var blockers: Array = []       # the intersection's other exits, after the split
var crane: Node3D
var drones: Array = []         # [{node, slot}]
var fall_fig: Node3D
var _lamps: Array = []         # [OmniLight3D, zone, flicker phase or -1, base]
var _pool: Array = []          # lights the beach phones cast
var _mm_up: MultiMeshInstance3D
var _mm_low: MultiMeshInstance3D
var _mm_halo: MultiMeshInstance3D   # the soft pool each lit device throws on the sand
var _scr: Array = []           # per screen: [mm, index, position, base colour, k, radius, decay]
var _scr_t := 0.0
var _light_t := 0.0
var _env: Environment
var _zone := "up"
var _hud_off := false
var _intro_run := false
var _busy := false
var _ended := false
var _shot := false
var _drops := 0
var _last_drop := Vector3.ZERO
var _cap_q: Array = []
var _cap_busy := false
var _nf_t := 0.0
# the chase
var _cycle := -1
var _sstate := "off"      # off | scripted | hunt | search | wait | pass | gone | lunge
var _track: Array = []
var _cum: Array = []
var _off := 0.0
var _h := 0.0             # head position along the track
var _hood_k := 0.0        # 0 folded, 1 flared
var _rear := 1.0          # how far the head is reared up
var _still := 0.0
var _grace := 0.0
var _catches := 0
var _hinted := false
var _seen_rooms := false
var _crash_done := [false, false, false]
# the river
var _drifting := false
var _u := 0.0
var _lat := 0.0
var _drift_mul := 1.0
var _form := "off"        # off | follow | join | leave | gone
var _form_t := 0.0
var _crane_t := 0.0
var _crane_from := Vector3.ZERO
var _touches := 0
var _chord: Array = []
var _hum_loops: Array = []
var _churn: Array = []
var _ui_cache := {}
# materials
var _brick: StandardMaterial3D
var _brick_dark: StandardMaterial3D
var _tile: StandardMaterial3D
var _white_tile: StandardMaterial3D
var _floor_m: StandardMaterial3D
var _ceil_m: StandardMaterial3D
var _metal: StandardMaterial3D
var _dark_m: StandardMaterial3D
var _plastic: StandardMaterial3D
var _sand: StandardMaterial3D
var _sand_dark: StandardMaterial3D
var _panel_m: StandardMaterial3D
var _cable: StandardMaterial3D
var _plate_m: StandardMaterial3D
var _core_m: StandardMaterial3D
var _core_off: StandardMaterial3D
var _blood_m: StandardMaterial3D
var _sheet_m: StandardMaterial3D
var _black_m: StandardMaterial3D
var _water_m: ShaderMaterial
var _fall_m: ShaderMaterial
var _scr_tex: ImageTexture
var _faces := {}


func L(beat: String, key: String) -> String:
	return str(LINES[beat][key])


func LA(beat: String, key: String) -> Array:
	return LINES[beat][key]


func _say(pair: Array) -> void:
	await main.ui.say(str(pair[0]), str(pair[1]))


func build(m: Node) -> void:
	main = m
	rng.seed = 2828
	kit_day = false
	step_db = -13.0
	card = L("build", "card")
	spawn = Vector3(0, Y + 0.05, 1.9)
	spawn_yaw = 0.0
	_rc = [0.0]
	for i in range(1, RIV.size()):
		_rc.append(float(_rc[i - 1]) + Vector2(RIV[i].x - RIV[i - 1].x, RIV[i].z - RIV[i - 1].z).length())
	_brick = tex_mat(_brick_tex(Color(0.25, 0.3, 0.2)), Vector3(1, 1, 1) / 2.0, 0.95, true)
	_brick_dark = tex_mat(_brick_tex(Color(0.13, 0.15, 0.12)), Vector3(1, 1, 1) / 2.0, 0.95, true)
	_tile = tex_mat(_tile_tex(Color(0.5, 0.53, 0.47)), Vector3(1, 1, 1) / 1.2, 0.35, true)
	_white_tile = tex_mat(_tile_tex(Color(0.92, 0.94, 0.95)), Vector3(1, 1, 1) / 0.9, 0.25, true)
	_floor_m = tex_mat(_tile_tex(Color(0.34, 0.36, 0.32)), Vector3(1, 1, 1) / 1.2, 0.4, true)
	_ceil_m = pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.3, 0.32, 0.3), 1.0)
	_metal = mat(Color(0.3, 0.31, 0.33), 0.45, 0.7)
	_dark_m = mat(Color(0.05, 0.05, 0.06), 0.5, 0.3)
	_plastic = mat(Color(0.09, 0.09, 0.1), 0.35, 0.1)
	_sand = pbr("plaster", Vector3(1, 1, 1) / 3.0, true, Color(0.52, 0.27, 0.17), 1.0)
	_sand_dark = pbr("concrete", Vector3(1, 1, 1) / 3.5, true, Color(0.3, 0.16, 0.11), 1.0)
	_panel_m = pbr("rust", Vector3(1, 1, 1) / 2.0, true, Color(0.42, 0.44, 0.42), 0.8)
	_cable = mat(Color(0.03, 0.03, 0.035), 0.6)
	_plate_m = mat(Color(0.42, 0.43, 0.47), 0.3, 0.85)
	_core_m = glow(GREEN, 2.6)
	_core_off = mat(Color(0.05, 0.08, 0.06), 0.4, 0.6)
	_blood_m = decal_mat(Tex.blood(), Color(0.55, 0.03, 0.03), 0.3)
	_sheet_m = pbr("fabric", Vector3(1, 1, 1) / 0.8, true, Color(0.8, 0.8, 0.76), 1.0)
	_black_m = newmat(Color(0, 0, 0), 1.0)
	_black_m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_scr_tex = _screen_tex()
	_water_m = _water_mat(false)
	_fall_m = _water_mat(true)
	up = Node3D.new()
	up.name = "up"
	add_child(up)
	low = Node3D.new()
	low.name = "low"
	add_child(low)
	_white_room()
	_device_hall()
	_bed_rooms()
	_crossing()
	_corridors()
	_devices()
	_river()
	_falls_and_metal()
	_beach()
	_spire()
	_batch(up, 8.0, true)
	_batch(low, 10.0, true)
	_screens_build()
	_people()
	_serpent_build()
	_drones_build()
	_crane_build()
	_fall_figure()
	_collect_lights()
	_zone_nodes = {"up": [up, _mm_up], "low": [low, _mm_low, _mm_halo]}
	for r in room_eyeless:
		_zone_nodes["up"].append(r["fig"])
	for r in river_eyeless + beach_eyeless:
		_zone_nodes["low"].append(r["fig"])
	for c in get_children():
		if c is MeshInstance3D and (c as MeshInstance3D).material_override is ShaderMaterial:
			_zone_nodes["low"].append(c)
	_apply_zone("up")


## Only the part of the level Carl is in is drawn (the browser's draw calls).
var _zone_nodes := {}


func _apply_zone(z: String) -> void:
	for k in _zone_nodes:
		for n in _zone_nodes[k]:
			if is_instance_valid(n):
				(n as Node3D).visible = k == z or z == "all"


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	# Under the city: no sky. The upper floor is fluorescent green-grey; the
	# river (set when Carl falls) is black with a little red from the rock.
	_env = env
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0, 0, 0)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.36, 0.44, 0.36)
	env.ambient_light_energy = 0.16
	env.fog_enabled = true
	env.fog_light_color = Color(0.02, 0.035, 0.025)
	env.fog_density = 0.012
	env.fog_sky_affect = 0.0
	env.glow_bloom = 0.06
	env.glow_intensity = 0.9
	env.tonemap_exposure = 1.2
	sun.light_energy = 0.0
	sun.shadow_enabled = false


func _env_zone(z: String) -> void:
	if not _env:
		return
	if z == "up":
		_env.ambient_light_color = Color(0.36, 0.44, 0.36)
		_env.ambient_light_energy = 0.16
		_env.fog_light_color = Color(0.02, 0.035, 0.025)
		_env.fog_density = 0.012
	else:
		_env.ambient_light_color = Color(0.42, 0.3, 0.26)
		_env.ambient_light_energy = 0.15
		_env.fog_light_color = Color(0.025, 0.02, 0.018)
		_env.fog_density = 0.016


func hifi(env: Environment, _sun: DirectionalLight3D) -> void:
	env.volumetric_fog_density *= 0.7


func ambience() -> void:
	# the hall's fluorescent hum; the serpent's scrape and rasp ride its head;
	# the river's churn, the shore's one line of the hymn, the seven rotors.
	var hm: AudioStreamPlayer = main.loop("hum", -14.0)
	hm.pitch_scale = 50.0 / 55.0
	var head: Node3D = plates[0]
	_scrape = main.loop("static", -80.0, Vector3.ZERO, 5.0, 40.0, head)
	_scrape.pitch_scale = 0.42
	_rasp = main.loop("flies", -80.0, Vector3.ZERO, 4.0, 36.0, head)
	_rasp.pitch_scale = 0.35
	var ch1: AudioStreamPlayer = main.loop("rain", -80.0)
	ch1.pitch_scale = 0.32
	var ch2: AudioStreamPlayer = main.loop("wind", -80.0)
	ch2.pitch_scale = 0.45
	_churn = [ch1, ch2, hm]
	for p: Vector3 in [_rp(22.0), _rp(52.0), Vector3(-300, YB + 1.6, 12), Vector3(-318, YB + 1.6, 12)]:
		var c: AudioStreamPlayer3D = main.loop("chant", -80.0, p + Vector3(0, 1.0, 0), 6.0, 40.0)
		c.pitch_scale = 0.78
		_hum_loops.append(c)
	var notes := [1.6, 1.9, 2.14, 2.4, 2.85, 3.2, 3.8]
	for i in drones.size():
		var d: Node3D = drones[i]["node"]
		var r: AudioStreamPlayer3D = main.loop("hum", -80.0, Vector3.ZERO, 8.0, 60.0, d)
		r.pitch_scale = notes[i]
		_chord.append(r)


# ------------------------------------------------------------------ helpers

## A floor or ceiling slab over x0..x1, z0..z1 with its top (or bottom) at
## y, cut into tiles no larger than 6 m so lights stay per-object cheap.
func _slab(par: Node, x0: float, x1: float, z0: float, z1: float, y: float, m: Material, top := true, solid := true) -> void:
	var nx := maxi(1, int(ceil((x1 - x0) / 6.0)))
	var nz := maxi(1, int(ceil((z1 - z0) / 6.0)))
	var w := (x1 - x0) / nx
	var d := (z1 - z0) / nz
	for i in nx:
		for j in nz:
			var c := Vector3(x0 + (i + 0.5) * w, y - 0.15 if top else y + 0.15, z0 + (j + 0.5) * d)
			box(Vector3(w, 0.3, d), c, m, solid, par)


## A wall along X at z (x0..x1) or along Z at x (z0..z1), height h from y,
## with doorways [[centre, width]] 2.3 m high and a lintel to the ceiling.
func _wall(par: Node, along_x: bool, at: float, a0: float, a1: float, y: float, h: float, m: Material, gaps := []) -> void:
	var spans := []
	var a := a0
	var gs := gaps.duplicate()
	gs.sort_custom(func(p, q): return p[0] < q[0])
	for g in gs:
		var gc: float = g[0]
		var gw: float = g[1]
		if gc - gw * 0.5 > a:
			spans.append([a, gc - gw * 0.5, 0.0, h])
		spans.append([gc - gw * 0.5, gc + gw * 0.5, 2.3, h])
		a = gc + gw * 0.5
	if a1 > a:
		spans.append([a, a1, 0.0, h])
	for s in spans:
		var s0: float = s[0]
		var s1: float = s[1]
		var b0: float = s[2]
		var b1: float = s[3]
		if b1 - b0 < 0.05:
			continue
		var n := maxi(1, int(ceil((s1 - s0) / 6.0)))
		var ln := (s1 - s0) / n
		for k in n:
			var c := s0 + (k + 0.5) * ln
			var size := Vector3(ln, b1 - b0, 0.3) if along_x else Vector3(0.3, b1 - b0, ln)
			var pos := Vector3(c, y + (b0 + b1) * 0.5, at) if along_x else Vector3(at, y + (b0 + b1) * 0.5, c)
			box(size, pos, m, true, par)


## A room: floor, ceiling and four walls; `gaps` per side ("n" z0, "s" z1,
## "w" x0, "e" x1) and `skip` for walls another piece already built.
func _room(x0: float, x1: float, z0: float, z1: float, h: float, wm: Material, fm: Material, cm: Material, gaps := {}, skip := []) -> void:
	_slab(up, x0, x1, z0, z1, Y, fm, true)
	_slab(up, x0, x1, z0, z1, Y + h, cm, false, false)
	if not "n" in skip:
		_wall(up, true, z0, x0, x1, Y, h, wm, gaps.get("n", []))
	if not "s" in skip:
		_wall(up, true, z1, x0, x1, Y, h, wm, gaps.get("s", []))
	if not "w" in skip:
		_wall(up, false, x0, z0, z1, Y, h, wm, gaps.get("w", []))
	if not "e" in skip:
		_wall(up, false, x1, z0, z1, Y, h, wm, gaps.get("e", []))


## A ceiling tube: the fixture, the glow strip, and a lamp in a zone. A
## flicker phase >= 0 makes it stutter.
func _tube(p: Vector3, rot_y: float, c: Color, energy: float, rng_m: float, flick := -1.0, zone := "up") -> OmniLight3D:
	var g := box(Vector3(1.0, 0.04, 0.07), p, glow(c, 1.5), false, up if zone == "up" else low)
	g.rotation.y = rot_y
	box(Vector3(1.1, 0.06, 0.16), p + Vector3(0, 0.05, 0), _metal, false, up if zone == "up" else low).rotation.y = rot_y
	return _lamp(p - Vector3(0, 0.3, 0), c, energy, rng_m, zone, flick)


func _lamp(p: Vector3, c: Color, energy: float, rng_m: float, zone := "up", flick := -1.0) -> OmniLight3D:
	var l := light(p, c, energy, rng_m, false)
	l.omni_attenuation = 1.1
	_lamps.append([l, zone, flick, energy])
	return l


## Rock: a chunk of sandstone (or anything) turned at random.
func _chunk(par: Node, p: Vector3, size: Vector3, m: Material) -> MeshInstance3D:
	var b := box(size, p, m, false, par)
	b.rotation = Vector3(rng.randf_range(-0.35, 0.35), rng.randf() * TAU, rng.randf_range(-0.35, 0.35))
	return b


## A run of cable from a to b that sags (ivy on the metal, tangles on the beach).
func _wire(par: Node, a: Vector3, b: Vector3, sag: float, r := 0.02) -> void:
	var n := 5
	var prev := a
	for i in range(1, n + 1):
		var t := float(i) / n
		var p := a.lerp(b, t) - Vector3(0, sin(t * PI) * sag, 0)
		p += Vector3(rng.randf_range(-0.12, 0.12), 0, rng.randf_range(-0.12, 0.12))
		stick(prev, p, r, _cable, par)
		prev = p


func _head_mi(fig: Node3D) -> MeshInstance3D:
	for c in (fig.get_meta("head") as Node3D).get_children():
		if c is MeshInstance3D:
			return c
	return null


## An eyeless face: the painted eyes replaced by raw sockets (Hangar.gd).
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
		Body._ell(img, ex, ey + 0.5, 4.2, 2.6, Color(0.05, 0.01, 0.01))
		for k in 7:
			var a := TAU * k / 7.0
			Body._rect(img, ex + cos(a) * 6.0, ey + sin(a) * 4.0, 2, 1, Color(skin.darkened(0.4), 0.8))
		# dried tracks down the cheeks
		for j in 18:
			Body._rect(img, ex + sin(j * 0.7) * 1.2, ey + 6 + j, 1.5, 1, Color(0.3, 0.05, 0.04, 0.8))
	img.generate_mipmaps()
	var m := base.duplicate() as StandardMaterial3D
	m.albedo_texture = ImageTexture.create_from_image(img)
	return m


## One of the eyeless: a gown or a robe, the sockets; still unless ticked.
func _an_eyeless(par: Node, p: Vector3, i: int, gown: bool) -> Node3D:
	var skins := [Color(0.8, 0.62, 0.5), Color(0.6, 0.44, 0.33), Color(0.88, 0.75, 0.66), Color(0.42, 0.3, 0.22)]
	var sk: Color = skins[i % 4]
	var coat := Color(0.66, 0.68, 0.64) if gown else Color(0.12, 0.11, 0.1).lightened(rng.randf_range(0.0, 0.12))
	var hair := Color(0.2, 0.17, 0.15) if i % 3 != 0 else sk.darkened(0.25)
	var fg := figure(coat, sk, {"hair": hair, "long_coat": true, "arms": true, "long_hair": i % 5 == 2, "legs": sk.darkened(0.1) if gown else Color(0.08, 0.08, 0.08)})
	fg.position = p
	par.add_child(fg)
	var key := "e%d" % (i % 4)
	if not _faces.has(key):
		_faces[key] = _eyeless_face(sk, hair, 2800 + i % 4)
	var hm := _head_mi(fg)
	if hm:
		hm.material_override = _faces[key]
	for a in fg.get_meta("arms"):
		(a as Node3D).rotation.x = -0.1
	fg.set_meta("eyeless", true)
	fg.set_meta("phase", rng.randf() * TAU)
	return fg


# ------------------------------------------------------------------ textures and shaders

## Army-green brick (Facility.gd's), mortar dark, paint worn through.
func _brick_tex(c: Color) -> ImageTexture:
	var r := RandomNumberGenerator.new()
	r.seed = 77
	var n := 128
	var img := Image.create(n, n, false, Image.FORMAT_RGB8)
	var mortar := c.darkened(0.45)
	for y in n:
		var course := y / 16
		var off := 0 if course % 2 == 0 else 16
		for x in n:
			var bx := (x + off) % 32
			var by := y % 16
			var col := c * (0.88 + r.randf() * 0.22)
			if by < 2 or bx < 2:
				col = mortar
			elif r.randf() < 0.025:
				col = col.lerp(Color(0.45, 0.22, 0.16), 0.6)
			elif y > 96 and r.randf() < 0.05:
				col = col.darkened(0.4)
			img.set_pixel(x, y, col)
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


func _tile_tex(c: Color) -> ImageTexture:
	var r := RandomNumberGenerator.new()
	r.seed = 9
	var n := 64
	var img := Image.create(n, n, false, Image.FORMAT_RGB8)
	for y in n:
		for x in n:
			var col := c * (0.93 + r.randf() * 0.09)
			if x % 16 == 0 or y % 16 == 0:
				col = c.darkened(0.45)
			img.set_pixel(x, y, col)
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


## A device screen: a dim lock-screen gradient, a clock bar, and the eye
## drawn in the middle of it (they are all watching).
func _screen_tex() -> ImageTexture:
	var w := 32
	var h := 48
	var img := Image.create(w, h, false, Image.FORMAT_RGB8)
	for y in h:
		for x in w:
			var g := 0.25 + 0.35 * float(y) / h
			var col := Color(g * 0.6, g, g * 0.8)
			if y < 4 and x > 6 and x < 26:
				col = Color(0.9, 1, 0.95)
			var p := Vector2((x - w * 0.5) / 11.0, (y - h * 0.55) / 6.0)
			var lid := absf(p.y) - (1.0 - p.x * p.x)
			if absf(lid) < 0.22 and absf(p.x) < 1.0:
				col = Color(1, 1, 1)
			var pr := Vector2(x - w * 0.5, y - h * 0.55).length()
			if pr < 3.2:
				col = Color(0.02, 0.02, 0.02) if pr < 1.8 else Color(1, 1, 1)
			img.set_pixel(x, y, col)
	return ImageTexture.create_from_image(img)


## The coolant: black, with an oily, slowly drifting highlight (bible art
## note). `falling` turns the flow downhill for the waterfall sheet.
func _water_mat(falling: bool) -> ShaderMaterial:
	var sh := Shader.new()
	sh.code = """
shader_type spatial;
render_mode cull_disabled;
uniform float falling = 0.0;
varying vec3 wp;
void vertex() {
	wp = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	VERTEX.y += (sin(wp.x * 0.9 + TIME * 1.1) * 0.035 + cos(wp.z * 1.3 + TIME * 0.7) * 0.025) * (1.0 - falling);
}
void fragment() {
	vec2 p = wp.xz * 0.35 + vec2(TIME * 0.22, 0.0);
	if (falling > 0.5) { p = vec2(wp.z * 0.6, wp.y * 0.7 + TIME * 2.4); }
	float a = sin(p.x * 2.1 + sin(p.y * 1.7 + TIME * 0.4) * 1.6);
	float b = sin(p.y * 3.3 + sin(p.x * 1.3 - TIME * 0.3) * 2.0);
	float n = a * b * 0.5 + 0.5;
	float band = smoothstep(0.74, 0.98, n);
	vec3 film = 0.5 + 0.5 * cos(6.2831 * (vec3(0.0, 0.33, 0.67) + n * 0.8 + p.x * 0.05));
	float fres = pow(1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0), 2.5);
	ALBEDO = vec3(0.006, 0.006, 0.007);
	ROUGHNESS = 0.05 + 0.3 * (1.0 - band);
	SPECULAR = 0.85;
	METALLIC = 0.25;
	EMISSION = film * band * (0.035 + 0.22 * fres) * vec3(0.55, 0.9, 0.75);
	NORMAL = normalize(NORMAL + (VIEW_MATRIX * vec4(a * 0.07, 0.0, b * 0.07, 0.0)).xyz);
}
"""
	var m := ShaderMaterial.new()
	m.shader = sh
	m.set_shader_parameter("falling", 1.0 if falling else 0.0)
	return m


# ------------------------------------------------------------------ the white room (ch.28 opening)

## "It was small, no larger than a cramped office": white tile, a cold metal
## floor, the fluorescence, the bronze chair Carl woke beside (the hands on
## its arms, the spikes wet), a drain, one screen, the sliding door.
func _white_room() -> void:
	var floor_m := mat(Color(0.8, 0.82, 0.84), 0.3, 0.55)
	_slab(up, -2.5, 2.5, -3.0, 3.0, Y, floor_m, true)
	_slab(up, -2.5, 2.5, -3.0, 3.0, Y + 2.8, _white_tile, false, false)
	_wall(up, true, -3.0, -2.5, 2.5, Y, 2.8, _white_tile, [[0.0, 1.2]])
	_wall(up, true, 3.0, -2.5, 2.5, Y, 2.8, _white_tile)
	_wall(up, false, -2.5, -3.0, 3.0, Y, 2.8, _white_tile)
	_wall(up, false, 2.5, -3.0, 3.0, Y, 2.8, _white_tile)
	# the ceiling panels and their light, too bright
	var panel := glow(Color(0.92, 0.96, 1.0), 2.4)
	for z: float in [-1.2, 1.4]:
		box(Vector3(1.6, 0.03, 0.6), Vector3(0, Y + 2.78, z), panel, false, up)
		_lamp(Vector3(0, Y + 2.4, z), Color(0.9, 0.95, 1.0), 1.15, 6.5)
	# the drain, the tile sloping to it
	cyl(0.17, 0.17, 0.02, Vector3(0, Y + 0.01, -0.4), _dark_m, 12, up)
	for k in 4:
		box(Vector3(0.3, 0.012, 0.02), Vector3(0, Y + 0.022, -0.52 + k * 0.08), _metal, false, up)
	interactable("drain", L("build", "drain_prompt"), Vector3(0, Y + 0.2, -0.4), Vector3(0.6, 0.4, 0.6), "", false)
	# the screen set flush in the east wall
	var scr := newglow(Color(0.5, 0.9, 0.75), 0.9)
	quad(Vector2(0.7, 0.42), Vector3(2.34, Y + 1.55, 0.2), -PI / 2.0, scr, up)
	label(L("build", "wallscreen_text"), Vector3(2.33, Y + 1.55, 0.2), -PI / 2.0, 0.0022, Color(0.85, 1.0, 0.9), self, false)
	interactable("wallscreen", L("build", "wallscreen_prompt"), Vector3(2.3, Y + 1.55, 0.2), Vector3(0.2, 0.6, 0.9), L("build", "wallscreen_scan"), false)
	# the chair: bronze, the hands on the arms palms up, the spikes
	var bronze := mat(Color(0.55, 0.36, 0.18), 0.35, 0.9)
	var c := Vector3(0, Y, 2.25)
	box(Vector3(0.62, 0.1, 0.6), c + Vector3(0, 0.48, 0), bronze, false, up)
	box(Vector3(0.62, 0.9, 0.1), c + Vector3(0, 0.98, 0.3), bronze, false, up)
	for sx: float in [-1.0, 1.0]:
		box(Vector3(0.08, 0.48, 0.08), c + Vector3(sx * 0.26, 0.24, -0.24), bronze, false, up)
		box(Vector3(0.08, 0.48, 0.08), c + Vector3(sx * 0.26, 0.24, 0.24), bronze, false, up)
		box(Vector3(0.12, 0.06, 0.56), c + Vector3(sx * 0.37, 0.72, 0.0), bronze, false, up)
		var hp := c + Vector3(sx * 0.37, 0.77, -0.18)
		box(Vector3(0.11, 0.035, 0.13), hp, bronze, false, up)
		for f in 4:
			stick(hp + Vector3(-0.04 + f * 0.027, 0.0, -0.06), hp + Vector3(-0.04 + f * 0.027, 0.03, -0.14), 0.011, bronze, up)
		stick(hp + Vector3(0, 0.02, 0), hp + Vector3(0, 0.13, 0), 0.006, mat(Color(0.3, 0.3, 0.32), 0.3, 0.9), up)
		stick(hp + Vector3(0, 0.09, 0), hp + Vector3(0, 0.13, 0), 0.0065, mat(Color(0.45, 0.03, 0.03), 0.3), up)
		floor_quad(Vector2(0.18, 0.18), Vector3(sx * 0.37, Y + 0.006, 2.0 + sx * 0.05), rng.randf() * TAU, _blood_m, up)
	solid_box(Vector3(0.8, 1.4, 0.8), c + Vector3(0, 0.7, 0))
	interactable("chair", L("build", "chair_prompt"), c + Vector3(0, 0.8, 0), Vector3(0.8, 1.4, 0.8), "", false)
	# where he lay, and the drops from his hands toward the door
	for k in 9:
		floor_quad(Vector2(0.1, 0.1) * rng.randf_range(0.8, 2.2), Vector3(rng.randf_range(-0.5, 0.6), Y + 0.006, rng.randf_range(0.4, 1.6)), rng.randf() * TAU, _blood_m, up)
	interactable("blood", L("build", "blood_prompt"), Vector3(0.1, Y + 0.15, 1.0), Vector3(1.2, 0.3, 1.2), "", false)
	# the sliding door: slides into the wall when it opens
	door_panel = box(Vector3(1.2, 2.3, 0.08), Vector3(0, Y + 1.15, -3.0), mat(Color(0.88, 0.9, 0.92), 0.3, 0.4))
	no_batch.append(door_panel)
	var db := solid_box(Vector3(1.2, 2.3, 0.3), Vector3(0, Y + 1.15, -3.0))
	door_panel.set_meta("body", db)


# ------------------------------------------------------------------ the device hall

## "A faded green, brick-lined hallway, eerily reminiscent of the DARPA
## site", the floor a graveyard of devices. Three bed rooms off it.
func _device_hall() -> void:
	_slab(up, -1.5, 1.5, -46.0, -3.0, Y, _floor_m, true)
	_slab(up, -1.5, 1.5, -46.0, -3.0, Y + 3.2, _ceil_m, false, false)
	_wall(up, false, -1.5, -46.0, -3.0, Y, 3.2, _brick, [[-12.5, 1.4], [-36.5, 1.4]])
	_wall(up, false, 1.5, -46.0, -3.0, Y, 3.2, _brick, [[-24.0, 1.4]])
	# the white light the door opens on, then the hall's green
	_lamp(Vector3(0, Y + 2.6, -5.2), Color(1, 1, 1), 1.4, 5.0)
	var i := 0
	for z: float in [-9.0, -17.0, -25.0, -33.0, -41.0]:
		_tube(Vector3(0, Y + 3.15, z), PI / 2.0, Color(0.72, 1.0, 0.75), 0.85, 7.0, rng.randf() * 10.0 if i % 2 == 1 else -1.0)
		i += 1
	# pipes along the ceiling, cables, and the DARPA-era stencils
	for sx: float in [-1.0, 1.0]:
		stick(Vector3(sx * 1.2, Y + 2.95, -3.2), Vector3(sx * 1.2, Y + 2.95, -45.8), 0.06, _metal, up)
		stick(Vector3(sx * 1.35, Y + 2.7, -3.2), Vector3(sx * 1.35, Y + 2.7, -45.8), 0.02, _cable, up)
	for s in [["SUB-LEVEL 7", -6.0], ["AUTHORIZED PERSONNEL ONLY", -20.0], ["WARD A  ·  WARD B  ·  WARD C", -29.0], ["COOLANT LOOP  -  DO NOT VENT", -43.0]]:
		label(str(s[0]), Vector3(-1.33, Y + 1.9, float(s[1])), PI / 2.0, 0.0028, Color(0.78, 0.82, 0.66), self, false)
	# a seam of something black weeping down the bricks near the end: the smell
	for k in 5:
		var z := -38.0 - k * 1.3
		box(Vector3(0.02, rng.randf_range(0.6, 2.0), 0.18), Vector3(1.48, Y + 1.6, z), mat(Color(0.02, 0.02, 0.02), 0.1, 0.4), false, up)


## "Rooms filled with beds that looked recently used."
func _bed_rooms() -> void:
	var rooms := [[-8.0, -1.5, -16.0, -9.0, "e"], [1.5, 8.0, -28.0, -20.0, "w"], [-8.0, -1.5, -40.0, -33.0, "e"]]
	var frame_m := mat(Color(0.55, 0.57, 0.58), 0.4, 0.8)
	var mattress := mat(Color(0.62, 0.64, 0.6), 0.9)
	var bag_m := mat(Color(0.01, 0.01, 0.012), 0.08, 0.3)
	var shoe_m := mat(Color(0.1, 0.08, 0.07), 0.7)
	for r in rooms.size():
		var x0: float = rooms[r][0]
		var x1: float = rooms[r][1]
		var z0: float = rooms[r][2]
		var z1: float = rooms[r][3]
		_room(x0, x1, z0, z1, 2.9, _brick_dark, _floor_m, _ceil_m, {}, [rooms[r][4]])
		var cx := (x0 + x1) * 0.5
		var cz := (z0 + z1) * 0.5
		_tube(Vector3(cx, Y + 2.85, cz), 0.0, Color(0.6, 0.9, 0.62), 0.5, 6.0, rng.randf() * 10.0)
		for b in 4:
			var bx := cx + (-1.6 if b % 2 == 0 else 1.6) * (1.0 if r != 1 else -1.0) * 0.9
			var bz := z0 + 1.4 + (b / 2) * 3.0
			var p := Vector3(bx, Y, bz)
			for lx: float in [-0.4, 0.4]:
				for lz: float in [-0.85, 0.85]:
					stick(p + Vector3(lx, 0, lz), p + Vector3(lx, 0.5, lz), 0.02, frame_m, up)
			box(Vector3(0.9, 0.05, 1.9), p + Vector3(0, 0.52, 0), frame_m, false, up)
			box(Vector3(0.86, 0.14, 1.84), p + Vector3(0, 0.62, 0), mattress, false, up)
			var sh := box(Vector3(0.92, 0.05, 1.0), p + Vector3(0.05, 0.71, 0.45), _sheet_m, false, up)
			sh.rotation = Vector3(0.0, rng.randf_range(-0.2, 0.2), rng.randf_range(-0.12, 0.12))
			box(Vector3(0.56, 0.12, 0.34), p + Vector3(0, 0.76, -0.72), _sheet_m, false, up)
			box(Vector3(0.22, 0.012, 0.14), p + Vector3(0, 0.825, -0.72), mat(Color(0.3, 0.27, 0.22), 0.9), false, up)
			# the IV stand and its bag of the black stuff, the line pulled out
			var iv := p + Vector3(0.62, 0, -0.6)
			stick(iv, iv + Vector3(0, 1.85, 0), 0.015, frame_m, up)
			box(Vector3(0.12, 0.2, 0.04), iv + Vector3(0.05, 1.7, 0), bag_m, false, up)
			stick(iv + Vector3(0.05, 1.6, 0), iv + Vector3(-0.2, 0.75, 0.3), 0.004, mat(Color(0.7, 0.7, 0.7), 0.3), up)
			if r == 2:
				for sx: float in [-0.09, 0.09]:
					box(Vector3(0.1, 0.08, 0.27), p + Vector3(sx, 0.04, 0.6), shoe_m, false, up)
		box(Vector3(1.4, 0.02, 0.9), Vector3(cx, Y + 0.008, cz), mat(Color(0.18, 0.2, 0.17), 0.95), false, up)
		var it := interactable("beds%d" % (r + 1), L("build", "beds_prompt"), Vector3(cx, Y + 0.9, cz), Vector3(3.0, 1.6, 3.0), L("build", "beds_scan") % (r + 1), false)
		it.set_meta("ward", r + 1)


# ------------------------------------------------------------------ the intersection and the chase

func _crossing() -> void:
	_slab(up, -2.0, 2.0, -50.0, -46.0, Y, _floor_m, true)
	_slab(up, -2.0, 2.0, -50.0, -46.0, Y + 4.5, _ceil_m, false, false)
	box(Vector3(0.5, 4.5, 0.3), Vector3(-1.75, Y + 2.25, -46.0), _brick, true, up)
	box(Vector3(0.5, 4.5, 0.3), Vector3(1.75, Y + 2.25, -46.0), _brick, true, up)
	box(Vector3(3.0, 1.3, 0.3), Vector3(0, Y + 3.85, -46.0), _brick, false, up)
	_tube(Vector3(0, Y + 4.45, -48.0), 0.0, SICK, 0.7, 8.0)
	# the north hall: the serpent's
	_slab(up, -2.0, 2.0, -84.0, -50.0, Y, _floor_m, true)
	_slab(up, -2.0, 2.0, -84.0, -50.0, Y + 4.5, _ceil_m, false, false)
	_wall(up, false, -2.0, -84.0, -50.0, Y, 4.5, _brick_dark)
	_wall(up, false, 2.0, -84.0, -50.0, Y, 4.5, _brick_dark)
	_wall(up, true, -84.0, -2.0, 2.0, Y, 4.5, _brick_dark)
	_tube(Vector3(0, Y + 4.45, -70.0), 0.0, SICK, 0.45, 7.0, 3.0)
	# the east hall: Lynx's
	_slab(up, 2.0, 24.0, -50.0, -46.0, Y, _floor_m, true)
	_slab(up, 2.0, 24.0, -50.0, -46.0, Y + 4.5, _ceil_m, false, false)
	_wall(up, true, -50.0, 2.0, 24.0, Y, 4.5, _brick_dark)
	_wall(up, true, -46.0, 2.0, 24.0, Y, 4.5, _brick_dark)
	_wall(up, false, 24.0, -50.0, -46.0, Y, 4.5, _brick_dark)
	_tube(Vector3(13.0, Y + 4.45, -48.0), PI / 2.0, SICK, 0.4, 7.0)


## Three corridors, each darker: their eyeless rooms, the dark rooms, the
## shafts in the corners, the rubble chokes, the pit over the river.
func _corridors() -> void:
	# corridor 1, west along z -48
	_slab(up, -64.0, -2.0, -50.0, -46.0, Y, _floor_m, true)
	_slab(up, -64.0, -2.0, -50.0, -46.0, Y + 4.5, _ceil_m, false, false)
	_wall(up, true, -50.0, -64.0, -2.0, Y, 4.5, _brick, [[-14.0, 1.8], [-38.0, 1.6]])
	_wall(up, true, -46.0, -60.0, -2.0, Y, 4.5, _brick, [[-26.0, 1.8]])
	for x: float in [-7.0, -20.0, -31.0, -47.0]:
		_tube(Vector3(x, Y + 4.45, -48.0), PI / 2.0, SICK, 0.85, 6.0)
	# corridor 2, south along x -62
	_slab(up, -64.0, -60.0, -46.0, 14.0, Y, _floor_m, true)
	_slab(up, -64.0, -60.0, -46.0, 14.0, Y + 4.5, _ceil_m, false, false)
	_wall(up, false, -64.0, -50.0, 10.0, Y, 4.5, _brick_dark, [[-34.0, 1.8]])
	_wall(up, false, -60.0, -46.0, 14.0, Y, 4.5, _brick_dark, [[-16.0, 1.6], [-2.0, 1.8]])
	for z: float in [-40.0, -27.0, -5.0, 8.0]:
		_tube(Vector3(-62.0, Y + 4.45, z), 0.0, SICK, 0.5, 6.0, rng.randf() * 10.0 if z > 0.0 else -1.0)
	# corridor 3, west along z 12; the pit's floor is its own piece
	_slab(up, -124.0, -112.0, 10.0, 14.0, Y, _floor_m, true)
	_slab(up, -108.0, -64.0, 10.0, 14.0, Y, _floor_m, true)
	_slab(up, -124.0, -64.0, 10.0, 14.0, Y + 4.5, _ceil_m, false, false)
	_wall(up, true, 10.0, -124.0, -64.0, Y, 4.5, _brick_dark, [[-86.0, 1.6]])
	_wall(up, true, 14.0, -124.0, -60.0, Y, 4.5, _brick_dark, [[-74.0, 1.8]])
	_wall(up, false, -124.0, 10.0, 14.0, Y, 4.5, _brick_dark)
	_tube(Vector3(-70.0, Y + 4.45, 12.0), PI / 2.0, SICK, 0.38, 6.0, 1.0)
	_tube(Vector3(-101.0, Y + 4.45, 12.0), PI / 2.0, SICK, 0.3, 6.0, 5.0)
	for k in 2:
		var pm := box(Vector3(2.0, 0.3, 4.0), Vector3(-111.0 + k * 2.0, Y - 0.15, 12.0), _floor_m)
		no_batch.append(pm)
		pit_floor.append(pm)
	pit_floor.append(solid_box(Vector3(4.0, 0.3, 4.0), Vector3(-110.0, Y - 0.15, 12.0)))
	for k in 6:
		var cr := box(Vector3(rng.randf_range(0.6, 1.6), 0.01, 0.03), Vector3(rng.randf_range(-111.5, -108.5), Y + 0.006, rng.randf_range(10.5, 13.5)), _black_m)
		cr.rotation.y = rng.randf() * TAU
		no_batch.append(cr)
		pit_floor.append(cr)
	# the side rooms: lit ones full of the eyeless, and one dark room each
	var lit := [[-16.5, -11.5, -56.0, -50.0, "s"], [-28.5, -23.5, -46.0, -40.0, "n"], [-70.0, -64.0, -36.5, -31.5, "e"],
		[-60.0, -55.0, -4.5, 0.5, "w"], [-76.5, -71.5, 14.0, 20.0, "n"]]
	for r in lit:
		_room(r[0], r[1], r[2], r[3], 3.2, _brick_dark, _floor_m, _ceil_m, {}, [r[4]])
		_tube(Vector3((r[0] + r[1]) * 0.5, Y + 3.15, (r[2] + r[3]) * 0.5), 0.0, Color(0.5, 1.0, 0.55), 0.8, 6.0, rng.randf() * 10.0)
	var dark := [[-41.0, -35.0, -56.0, -50.0, "s"], [-60.0, -54.0, -19.0, -13.0, "w"], [-89.0, -83.0, 4.0, 10.0, "s"]]
	for k in 3:
		var r: Array = dark[k]
		_room(r[0], r[1], r[2], r[3], 3.2, _brick_dark, _floor_m, _ceil_m, {}, [r[4]])
		var cx: float = (r[0] + r[1]) * 0.5
		var cz: float = (r[2] + r[3]) * 0.5
		var back := Vector3(cx, Y, cz) + (Vector3(cx, Y, cz) - _door_point(k)).normalized() * 2.2
		var sh := prop("steel_frame_shelves_01", back, atan2(_door_point(k).x - cx, _door_point(k).z - cz), 1.0, true, up)
		if sh == null:
			box(Vector3(1.6, 1.8, 0.5), back + Vector3(0, 0.9, 0), _metal, true, up)
		prop("plastic_crate_03", back + Vector3(1.2, 0, 0.4), 0.4, 1.0, true, up)
		prop("cardboard_box_01", back + Vector3(-1.1, 0, 0.6), 1.1, 1.0, true, up)
		var it := interactable("dark%d" % (k + 1), L("build", "dark_prompt"), back + Vector3(0, 1.0, 0), Vector3(1.8, 2.0, 1.0), "", false)
		it.set_meta("route", "hide")
	# the shafts it dives into and rises out of, in the corners
	var shafts := [Vector3(-63.0, Y, -49.0), Vector3(-61.0, Y, 13.0), Vector3(-122.5, Y, 12.0)]
	for k in 3:
		var s: Vector3 = shafts[k]
		cyl(0.95, 0.95, 0.02, s + Vector3(0, 0.012, 0), _black_m, 14, up)
		for j in 7:
			var a := TAU * j / 7.0
			var base := s + Vector3(cos(a) * 0.95, 0.02, sin(a) * 0.95)
			stick(base, base + Vector3(cos(a) * 0.35, rng.randf_range(0.25, 0.6), sin(a) * 0.35), 0.025, mat(Color(0.25, 0.18, 0.12), 0.7, 0.6), up)
		solid_box(Vector3(1.9, 1.2, 1.9), s + Vector3(0, 0.6, 0))
		interactable("shaft%d" % (k + 1), L("build", "shaft_prompt"), s + Vector3(0, 0.5, 0), Vector3(1.9, 1.0, 1.9), L("build", "shaft_scan"), false)
	# the rubble chokes in corridors 1 and 2
	var chokes := [[Vector3(-56.0, Y, -48.0), Vector3(2.2, 4.5, 4.0)], [Vector3(-62.0, Y, 5.0), Vector3(4.0, 4.5, 2.2)]]
	for k in 2:
		var c: Vector3 = chokes[k][0]
		var sz: Vector3 = chokes[k][1]
		var g := Node3D.new()
		add_child(g)
		for j in 16:
			var p := c + Vector3(rng.randf_range(-sz.x, sz.x) * 0.4, rng.randf_range(0.2, 3.6), rng.randf_range(-sz.z, sz.z) * 0.4)
			var ch := _chunk(g, p, Vector3(rng.randf_range(0.6, 1.5), rng.randf_range(0.4, 1.0), rng.randf_range(0.5, 1.3)), _brick_dark if j % 3 else _ceil_m)
			no_batch.append(ch)
		var body := solid_box(sz, c + Vector3(0, 2.25, 0))
		rubble.append([g, body])
		interactable("rubble%d" % (k + 1), L("build", "rubble_prompt"), c + Vector3(0, 1.2, 0), sz * Vector3(1.05, 0.5, 1.05), "", false).set_meta("rubble", k)


## Where a dark room's door meets its corridor.
func _door_point(k: int) -> Vector3:
	return [Vector3(-38.0, Y, -50.0), Vector3(-60.0, Y, -16.0), Vector3(-86.0, Y, 10.0)][k]


# ------------------------------------------------------------------ the dead devices

var _xf_up: Array = []
var _xf_low: Array = []


## "ORA frames, old smartphones, laptops, and smartwatches littered the path
## like digital cobblestones": bodies batched, screens in one MultiMesh that
## lights as Carl passes. Six of them can be examined.
func _devices() -> void:
	for i in 120:
		var z := rng.randf_range(-45.0, -4.5)
		var x := rng.randf_range(-1.3, 1.3)
		if absf(x) < 0.5 and rng.randf() < 0.6:
			x = signf(x + 0.001) * rng.randf_range(0.6, 1.3)
		_device(Vector3(x, Y, z), rng.randi() % 10, true)
	# the corridors, sparser: "rattling the dead tech around us"
	for i in 70:
		var s := rng.randf_range(2.0, 180.0)
		var p := _chase_point(s)
		var d := _chase_dir(s)
		var side := Vector3(-d.z, 0, d.x)
		_device(p + side * rng.randf_range(-1.7, 1.7), rng.randi() % 10, true)
	var named := [["old_phone", Vector3(0.6, Y, -7.5), 0], ["frames_pile", Vector3(-1.05, Y, -15.0), 4], ["laptop", Vector3(0.75, Y, -19.0), 6],
		["kidwatch", Vector3(-0.5, Y, -27.0), 8], ["tablet", Vector3(0.85, Y, -31.0), 3], ["speaker", Vector3(-0.9, Y, -39.0), 9]]
	for n in named:
		var id: String = n[0]
		var p: Vector3 = n[1]
		if id == "frames_pile":
			for k in 9:
				_device(p + Vector3(rng.randf_range(-0.25, 0.3), 0, rng.randf_range(-0.5, 0.5)), 4, true)
		else:
			_device(p, int(n[2]), true)
		var it := interactable(id, L("build", id + "_prompt"), p + Vector3(0, 0.2, 0), Vector3(0.7, 0.5, 0.7), L("build", id + "_scan"), false)
		it.set_meta("hackable", true)
	var cl := label(L("build", "card_text"), Vector3(0.6, Y + 0.02, -7.5), 0.3, 0.0011, Color(0.85, 1.0, 0.9), self, false)
	cl.rotation = Vector3(-PI / 2.0, 0.3, 0)
	cl.font_size = 28


## One device on the floor: 0-2 phone, 3 tablet, 4-5 frames, 6-7 laptop,
## 8 watch, 9 speaker. The screen goes into the MultiMesh list.
func _device(p: Vector3, kind: int, upper: bool) -> void:
	var par: Node = up if upper else low
	var ry := rng.randf() * TAU
	var b := Basis(Vector3.UP, ry)
	var flat := Basis(Vector3.UP, ry) * Basis(Vector3.RIGHT, -PI / 2.0)
	var xf: Array = _xf_up if upper else _xf_low
	match kind:
		0, 1, 2:
			box(Vector3(0.075, 0.01, 0.15), p + Vector3(0, 0.005, 0), _plastic, false, par).rotation.y = ry
			xf.append(Transform3D((flat * Basis.from_scale(Vector3(0.066, 0.135, 1))), p + Vector3(0, 0.0115, 0)))
		3:
			box(Vector3(0.18, 0.012, 0.25), p + Vector3(0, 0.006, 0), _plastic, false, par).rotation.y = ry
			xf.append(Transform3D((flat * Basis.from_scale(Vector3(0.16, 0.22, 1))), p + Vector3(0, 0.0135, 0)))
		4, 5:
			box(Vector3(0.14, 0.014, 0.014), p + Vector3(0, 0.03, 0), _plastic, false, par).rotation.y = ry
			for sx: float in [-1.0, 1.0]:
				stick(p + b * Vector3(sx * 0.07, 0.03, 0), p + b * Vector3(sx * 0.07, 0.008, 0.13), 0.005, _plastic, par)
				xf.append(Transform3D((b * Basis.from_scale(Vector3(0.05, 0.03, 1))), p + b * Vector3(sx * 0.035, 0.03, -0.009)))
		6, 7:
			box(Vector3(0.32, 0.018, 0.22), p + Vector3(0, 0.009, 0), _metal, false, par).rotation.y = ry
			var lid_b := b * Basis(Vector3.RIGHT, -0.35)
			var lid := box(Vector3(0.32, 0.21, 0.012), p + b * Vector3(0, 0.1, 0.13), _metal, false, par)
			lid.basis = lid_b
			xf.append(Transform3D((lid_b * Basis.from_scale(Vector3(0.29, 0.18, 1))), p + b * Vector3(0, 0.1, 0.13) + lid_b * Vector3(0, 0, -0.008)))
		8:
			box(Vector3(0.035, 0.012, 0.042), p + Vector3(0, 0.006, 0), _plastic, false, par).rotation.y = ry
			box(Vector3(0.02, 0.004, 0.2), p + Vector3(0, 0.002, 0), mat(Color(0.5, 0.2, 0.25), 0.8), false, par).rotation.y = ry
			xf.append(Transform3D((flat * Basis.from_scale(Vector3(0.03, 0.036, 1))), p + Vector3(0, 0.0125, 0)))
		_:
			cyl(0.06, 0.07, 0.16, p + Vector3(0, 0.08, 0), _plastic, 10, par)
			xf.append(Transform3D((b * Basis.from_scale(Vector3(0.06, 0.02, 1))), p + b * Vector3(0, 0.12, -0.066)))


# ------------------------------------------------------------------ the river (ch.28)

## The point on the river's centre line u metres downstream, at the water.
func _rp(u: float) -> Vector3:
	u = clampf(u, 0.0, float(_rc[_rc.size() - 1]))
	for i in range(1, RIV.size()):
		if u <= float(_rc[i]) or i == RIV.size() - 1:
			var a: Vector3 = RIV[i - 1]
			var b: Vector3 = RIV[i]
			var t := clampf((u - float(_rc[i - 1])) / maxf(0.001, float(_rc[i]) - float(_rc[i - 1])), 0.0, 1.0)
			var p := a.lerp(b, t)
			p.y = _wy(u)
			return p
	return RIV[0]


func _rd(u: float) -> Vector3:
	var d := _rp(u + 0.5) - _rp(u - 0.5)
	d.y = 0.0
	return d.normalized() if d.length() > 0.001 else Vector3(-1, 0, 0)


## The water: YR to the lip of the falls, YL below them.
func _wy(u: float) -> float:
	var a: float = _rc[4]
	var b: float = _rc[5]
	if u <= a:
		return YR
	if u >= b:
		return YL
	return lerpf(YR, YL, smoothstep(0.0, 1.0, (u - a) / (b - a)))


func _half(u: float) -> float:
	return 7.0 if u < float(_rc[4]) else 6.0


## The cavern's roof: low under the corridors, then high under Red Rock.
func _roof(u: float) -> float:
	if u < 14.0:
		return Y - 0.6
	if u < float(_rc[4]):
		return lerpf(Y - 0.6, YR + 20.0, clampf((u - 14.0) / 16.0, 0.0, 1.0)) + sin(u * 0.3) * 1.2
	return YL + 10.0


## "The river was encapsulated by a cavern of raw sandstone." The black
## water, the walls and roof in chunks, the ledges the eyeless stand on,
## the coolant veins, and the crack the sun comes through.
func _river() -> void:
	var wa := PlaneMesh.new()
	wa.size = Vector2(96, 44)
	wa.subdivide_width = 48
	wa.subdivide_depth = 22
	var w1 := mesh(wa, Vector3(-150.0, YR, 12.0), _water_m)
	no_batch.append(w1)
	var crack := Vector3(-150.0, 0, 15.0)
	var fall_u: float = _rc[4]
	var u := 0.0
	while u < fall_u + 0.5:
		var c := _rp(u)
		var d := _rd(u)
		var side := Vector3(-d.z, 0, d.x)
		var top := _roof(u)
		for sd: float in [-1.0, 1.0]:
			var off := _half(u) + rng.randf_range(0.2, 1.3)
			var y := YR - 1.6
			var cap_top := top if u >= 15.0 else Y - 3.0
			while y < cap_top:
				var hh := rng.randf_range(2.6, 4.2)
				_chunk(low, c + side * sd * (off + rng.randf_range(-0.3, 0.5)) + Vector3(0, y + hh * 0.5, 0),
					Vector3(rng.randf_range(2.2, 3.6), hh, rng.randf_range(2.4, 3.6)), _sand if rng.randf() < 0.7 else _sand_dark)
				y += hh * 0.8
		if u > 4.0 and u < 15.0:
			# under corridor 3: flat-topped, so nothing comes up through its floor
			for lat: float in [-5.0, -1.7, 1.7, 5.0]:
				var hh := rng.randf_range(1.0, 1.8)
				box(Vector3(rng.randf_range(3.0, 4.2), hh, 3.0), c + side * lat + Vector3(0, Y - 0.4 - hh * 0.5, 0), _sand_dark, false, low).rotation.y = rng.randf() * TAU
		elif u >= 15.0:
			for lat: float in [-5.0, -1.7, 1.7, 5.0]:
				var p := c + side * lat + Vector3(0, top + rng.randf_range(0.2, 1.4), 0)
				if Vector2(p.x - crack.x, p.z - crack.z).length() < 2.6:
					continue
				_chunk(low, p, Vector3(rng.randf_range(3.0, 4.6), rng.randf_range(1.8, 3.2), rng.randf_range(3.0, 4.6)), _sand_dark)
		u += 2.4
	# the cavern's east end, past the pit
	for k in 4:
		for j in 3:
			box(Vector3(3.0, 2.4, 6.0), Vector3(-104.5, YR + 1.2 + k * 2.0, 6.0 + j * 6.0), _sand_dark, false, low).rotation.y = rng.randf_range(-0.2, 0.2)
	# the coolant veins: green, never warm
	var vein := glow(Color(0.3, 0.9, 0.5), 0.9)
	for k in 26:
		var vu := rng.randf_range(6.0, fall_u - 4.0)
		var sd := -1.0 if k % 2 == 0 else 1.0
		var c := _rp(vu)
		var d := _rd(vu)
		var side := Vector3(-d.z, 0, d.x) * sd
		var a := c + side * (_half(vu) - 0.4) + Vector3(0, rng.randf_range(0.4, 2.4), 0)
		var prev := a
		for j in 4:
			var nxt := prev + d * rng.randf_range(0.6, 1.4) + Vector3(0, rng.randf_range(-0.5, 0.7), 0)
			stick(prev, nxt, 0.03, vein, low)
			prev = nxt
	# the ledges along the shore, and a dim green over each stretch
	for k in 9:
		var lu: float = [16.0, 21.0, 25.0, 31.0, 36.0, 47.0, 53.0, 59.0, 67.0][k]
		var sd := -1.0 if k % 2 == 0 else 1.0
		var c := _rp(lu)
		var d := _rd(lu)
		var side := Vector3(-d.z, 0, d.x) * sd
		box(Vector3(2.0, 0.9, 2.2), c + side * (_half(lu) - 0.8) + Vector3(0, -0.15, 0), _sand, false, low).rotation.y = atan2(d.x, d.z)
	for lu: float in [12.0, 30.0, 58.0, 80.0]:
		_lamp(_rp(lu) + Vector3(0, 3.5, 0), Color(0.35, 0.8, 0.5), 0.9, 16.0, "low")
	# "the afternoon sun crept in, a lazy, indifferent sliver of light": the
	# only warm light underground
	var cg := box(Vector3(0.35, 0.4, 7.0), crack + Vector3(0, YR + 20.4, 0), glow(WARM, 4.0), false, self)
	cg.rotation.y = 0.5
	no_batch.append(cg)
	var sp := SpotLight3D.new()
	sp.position = crack + Vector3(0, YR + 19.8, 0)
	sp.rotation = Vector3(-PI / 2.0, 0, 0)
	sp.light_color = WARM
	sp.light_energy = 9.0
	sp.spot_range = 28.0
	sp.spot_angle = 12.0
	sp.spot_attenuation = 0.6
	sp.light_volumetric_fog_energy = 0.12
	add_child(sp)
	_lamps.append([sp, "low", -1.0, 9.0])
	var beam := CylinderMesh.new()
	beam.top_radius = 0.35
	beam.bottom_radius = 2.6
	beam.height = 19.6
	beam.radial_segments = 12
	beam.rings = 1
	var bm := StandardMaterial3D.new()
	bm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	bm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	bm.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	bm.albedo_color = Color(1.0, 0.7, 0.42, 0.045)
	bm.cull_mode = BaseMaterial3D.CULL_DISABLED
	bm.no_depth_test = false
	var bmi := mesh(beam, crack + Vector3(0, YR + 10.0, 0), bm)
	no_batch.append(bmi)
	var dust := CPUParticles3D.new()
	dust.position = crack + Vector3(0, YR + 8.0, 0)
	dust.amount = 45
	dust.lifetime = 9.0
	dust.emission_shape = CPUParticles3D.EMISSION_SHAPE_BOX
	dust.emission_box_extents = Vector3(1.4, 8.0, 1.4)
	dust.gravity = Vector3(0, -0.02, 0)
	dust.initial_velocity_min = 0.02
	dust.initial_velocity_max = 0.08
	var dq := QuadMesh.new()
	dq.size = Vector2(0.035, 0.035)
	var dm := StandardMaterial3D.new()
	dm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	dm.billboard_mode = BaseMaterial3D.BILLBOARD_PARTICLES
	dm.albedo_color = Color(0.8, 0.62, 0.42)
	dq.material = dm
	dust.mesh = dq
	add_child(dust)


## The waterfall, then "the rock walls began to give way to metal and wire.
## Electrical cables sprawled nonsensically across the metal, like ivy."
func _falls_and_metal() -> void:
	var wb := PlaneMesh.new()
	wb.size = Vector2(88, 46)
	wb.subdivide_width = 44
	wb.subdivide_depth = 23
	var w2 := mesh(wb, Vector3(-242.0, YL, 12.0), _water_m)
	no_batch.append(w2)
	var fq := QuadMesh.new()
	fq.size = Vector2(15.0, YR - YL + 0.4)
	var fm := mesh(fq, Vector3(-199.4, (YR + YL) * 0.5, 13.0), _fall_m)
	fm.rotation.y = PI / 2.0
	no_batch.append(fm)
	for k in 7:
		_chunk(low, Vector3(-198.6, YL - 0.4, 6.5 + k * 2.1), Vector3(1.6, YR - YL + 0.6, 2.4), _sand_dark)
	var froth := mat(Color(0.12, 0.12, 0.11), 0.2, 0.3)
	for k in 10:
		box(Vector3(rng.randf_range(0.6, 1.6), 0.04, rng.randf_range(0.4, 1.0)), Vector3(rng.randf_range(-203.0, -200.5), YL + 0.04, rng.randf_range(7.0, 19.0)), froth, false, low).rotation.y = rng.randf() * TAU
	var jbox := glow(GREEN, 1.4)
	var u: float = _rc[5]
	var end: float = _rc[_rc.size() - 1] + 6.0
	while u < end:
		var c := _rp(u)
		var d := _rd(u)
		var side := Vector3(-d.z, 0, d.x)
		var ry := atan2(d.x, d.z)
		for sd: float in [-1.0, 1.0]:
			var w := c + side * sd * (_half(u) + 0.2)
			for j in 4:
				var pn := box(Vector3(0.25, 3.1, 2.55), w + Vector3(0, -0.4 + j * 3.15 + 1.55, 0), _panel_m if (j + int(u)) % 3 else _metal, false, low)
				pn.rotation.y = ry
			for k in 2:
				var a := w - side * sd * 0.18 + d * rng.randf_range(-1.2, 1.2) + Vector3(0, rng.randf_range(5.0, 9.0), 0)
				var b := w - side * sd * 0.18 + d * rng.randf_range(-2.5, 2.5) + Vector3(0, rng.randf_range(0.0, 3.5), 0)
				_wire(low, a, b, rng.randf_range(0.2, 1.1), rng.randf_range(0.02, 0.045))
			if int(u) % 8 < 3:
				box(Vector3(0.2, 0.3, 0.4), w - side * sd * 0.2 + Vector3(0, rng.randf_range(1.0, 4.0), 0), jbox, false, low).rotation.y = ry
		box(Vector3(12.0, 0.6, 2.7), c + Vector3(0, YL + 10.0 - c.y + 0.3, 0), _metal, false, low).rotation.y = ry
		u += 2.6
	for k in 3:
		var pu: float = _rc[5] + 4.0
		var pe: float = _rc[_rc.size() - 1]
		var off := Vector3(0, 9.2, 0) + Vector3(0, 0, -2.0 + k * 2.0)
		var prev := _rp(pu) + off
		var q := pu + 8.0
		while q < pe:
			var nxt := _rp(q) + off
			stick(prev, nxt, 0.18, _metal if k != 1 else _panel_m, low)
			prev = nxt
			q += 8.0
	for lu: float in [100.0, 126.0, 152.0]:
		_lamp(_rp(lu) + Vector3(0, 4.0, 0), Color(0.3, 0.9, 0.5), 0.5, 12.0, "low")


## "The river finally deposited me on an artificial shoreline, a beach of
## wires and old, decaying tech."
func _beach() -> void:
	var bm := pbr("concrete", Vector3(1, 1, 1) / 2.5, true, Color(0.13, 0.12, 0.12), 1.0)
	_slab(low, -346.0, -278.0, -6.0, 30.0, YB, bm, true)
	var ramp := box(Vector3(5.0, 0.4, 36.0), Vector3(-277.0, YB - 0.32, 12.0), bm, false, low)
	ramp.rotation.z = -0.08
	# walls of rock and metal, the roof, the bedrock behind the spire
	var x := -268.0
	while x > -348.0:
		for zz: float in [-7.0, 31.0]:
			var y := YB - 0.5
			while y < YB + 14.0:
				var hh := rng.randf_range(2.5, 4.0)
				_chunk(low, Vector3(x + rng.randf_range(-0.6, 0.6), y + hh * 0.5, zz + rng.randf_range(-0.8, 0.8)), Vector3(3.4, hh, 2.6), _sand_dark if rng.randf() < 0.6 else _panel_m)
				y += hh * 0.8
		for zz: float in [-2.0, 6.0, 14.0, 22.0, 28.0]:
			_chunk(low, Vector3(x, YB + 14.0 + rng.randf_range(0.0, 1.5), zz), Vector3(4.5, 2.6, 5.0), _sand_dark)
		x -= 3.2
	for k in 14:
		_chunk(low, Vector3(-347.5 + rng.randf_range(-1.0, 1.0), YB + k * 1.1, rng.randf_range(-6.0, 30.0)), Vector3(4.0, 3.2, 6.0), _sand_dark)
	solid_box(Vector3(80.0, 6.0, 0.4), Vector3(-306.0, YB + 3.0, -5.6))
	solid_box(Vector3(80.0, 6.0, 0.4), Vector3(-306.0, YB + 3.0, 29.6))
	solid_box(Vector3(0.4, 6.0, 36.0), Vector3(-279.0, YB + 3.0, 12.0))
	solid_box(Vector3(0.4, 6.0, 36.0), Vector3(-345.5, YB + 3.0, 12.0))
	# the tangles
	for k in 90:
		var a := Vector3(rng.randf_range(-332.0, -280.0), YB + 0.03, rng.randf_range(-4.0, 28.0))
		var b := a + Vector3(rng.randf_range(-3.0, 3.0), 0, rng.randf_range(-3.0, 3.0))
		_wire(low, a, b, -rng.randf_range(0.05, 0.25), rng.randf_range(0.015, 0.035))
	for k in 18:
		var p := Vector3(rng.randf_range(-330.0, -281.0), YB, rng.randf_range(-4.0, 28.0))
		if absf(p.z - 12.0) < 3.0:
			p.z += 6.0 * signf(p.z - 12.0 + 0.01)
		var names := ["server_rack", "modular_electric_cables", "old_tyre", "plastic_crate_03", "metal_trash_can", "utility_box_01", "steel_frame_shelves_01", "power_box_01"]
		var n := prop(names[k % names.size()], p + Vector3(0, -0.15 if k % 8 == 0 else 0.0, 0), rng.randf() * TAU, 1.0, false, low)
		if n and k % 8 == 6:
			n.rotation.z = 1.35
	# the drowned tech, and the phones like driftwood
	for k in 50:
		_device(Vector3(rng.randf_range(-330.0, -281.0), YB, rng.randf_range(-3.0, 27.0)), 3 + rng.randi() % 7, false)
	for k in 180:
		var z := 12.0 + rng.randfn(0.0, 5.0)
		_device(Vector3(rng.randf_range(-331.0, -280.0), YB, clampf(z, -4.0, 28.0)), rng.randi() % 3, false)
	_device(Vector3(-288.0, YB, 13.6), 0, false)
	interactable("phone_shore", L("build", "phone_shore_prompt"), Vector3(-288.0, YB + 0.2, 13.6), Vector3(0.7, 0.5, 0.7), "", false)
	# the phones' own light: a few small lights that follow the lit ones
	for k in 5:
		var l := _lamp(Vector3(-290.0, YB + 0.3, 12.0), Color(0.45, 1.0, 0.85), 0.0, 3.4, "pool")
		_pool.append(l)


## "A mighty metallic structure, inserted into the very heart of a layer of
## bedrock. The metal was coated in the unmistakable, sickly green of Psyonic."
func _spire() -> void:
	var coat := mat(Color(0.12, 0.3, 0.16), 0.35, 0.8)
	var rib := glow(GREEN, 1.3)
	cyl(5.2, 5.6, 0.8, SPIRE + Vector3(0, 0.4, 0), _metal, 8, low)
	cyl(4.0, 4.4, 30.0, SPIRE + Vector3(0, 15.0, 0), coat, 8, low)
	for k in 8:
		var a := TAU * (k + 0.5) / 8.0
		var r := 4.3
		stick(SPIRE + Vector3(cos(a) * r, 0.8, sin(a) * r), SPIRE + Vector3(cos(a) * (r - 0.4), 29.0, sin(a) * (r - 0.4)), 0.08, rib, low)
	for h: float in [3.0, 7.5, 12.0, 17.0, 22.0]:
		cyl(4.45 - h * 0.012, 4.45 - h * 0.012, 0.25, SPIRE + Vector3(0, h, 0), glow(Color(0.25, 0.7, 0.35), 0.8), 8, low)
	box(Vector3(0.14, 3.6, 1.8), SPIRE + Vector3(4.25, 2.6, 0), glow(GREEN, 2.2), false, low)
	box(Vector3(0.1, 3.8, 0.08), SPIRE + Vector3(4.3, 2.6, -0.95), _dark_m, false, low)
	box(Vector3(0.1, 3.8, 0.08), SPIRE + Vector3(4.3, 2.6, 0.95), _dark_m, false, low)
	for k in 14:
		var a := rng.randf() * TAU
		var top := Vector3(SPIRE.x + rng.randf_range(-12.0, 6.0), YB + 14.0, SPIRE.z + rng.randf_range(-16.0, 16.0))
		var at := SPIRE + Vector3(cos(a) * 4.2, rng.randf_range(4.0, 12.0), sin(a) * 4.2)
		_wire(low, top, at, rng.randf_range(0.5, 2.0), 0.08)
	for k in 10:
		_chunk(low, SPIRE + Vector3(rng.randf_range(-7.0, 7.0), rng.randf_range(10.0, 15.0), rng.randf_range(-7.0, 7.0)), Vector3(5.0, 3.0, 5.0), _sand_dark)
	solid_box(Vector3(8.6, 30.0, 8.6), SPIRE + Vector3(0, 15.0, 0))
	_lamp(SPIRE + Vector3(6.5, 2.5, 0), GREEN, 1.3, 9.0, "low")
	_lamp(SPIRE + Vector3(5.0, 12.0, 0), GREEN, 0.9, 16.0, "low")
	interactable("spire", L("build", "spire_prompt"), SPIRE + Vector3(4.6, 1.8, 0), Vector3(1.0, 3.6, 3.0), "", true)


# ------------------------------------------------------------------ people

func _people() -> void:
	# Lynx: "her hands bearing the same stigmata as my own"
	lynx = figure(Color(0.09, 0.08, 0.1), Color(0.88, 0.74, 0.62),
		{"hair": Color(0.12, 0.08, 0.06), "long_hair": true, "legs": Color(0.1, 0.1, 0.12), "arms": true, "knees": true, "visor": true, "long_coat": true})
	lynx.position = DOOR + Vector3(0, 0, -0.5)
	lynx.visible = false
	add_child(lynx)
	var wound := mat(Color(0.35, 0.01, 0.01), 0.25)
	var wet := mat(Color(0.55, 0.03, 0.03), 0.15)
	for arm in lynx.get_meta("arms"):
		var a := arm as Node3D
		box(Vector3(0.045, 0.045, 0.02), Vector3(0, -0.64, -0.048), wound, false, a)
		box(Vector3(0.04, 0.04, 0.02), Vector3(0, -0.64, 0.032), wound, false, a)
		stick(Vector3(0, -0.66, -0.05), Vector3(0, -0.84, -0.055), 0.006, wet, a)
		stick(Vector3(0.01, -0.67, 0.035), Vector3(0.012, -0.78, 0.04), 0.005, wet, a)
	lynx_it = interactable("lynx", L("build", "lynx_prompt"), Vector3(0, 0.9, 0), Vector3(0.7, 1.9, 0.7), L("build", "lynx_scan"), false, lynx)
	set_active(lynx_it, false)
	# the eyeless in the lit rooms off the chase, in the gowns from the beds
	var rooms := [[Vector3(-14.0, Y, -53.5), Vector3(-14.0, Y, -50.0), 3], [Vector3(-26.0, Y, -42.5), Vector3(-26.0, Y, -46.0), 3],
		[Vector3(-67.5, Y, -34.0), Vector3(-64.0, Y, -34.0), 2], [Vector3(-57.0, Y, -2.0), Vector3(-60.0, Y, -2.0), 2],
		[Vector3(-74.0, Y, 17.5), Vector3(-74.0, Y, 14.0), 2]]
	var n := 0
	for r in rooms:
		var c: Vector3 = r[0]
		var door: Vector3 = r[1]
		var side := (door - c).cross(Vector3.UP).normalized()
		for k in int(r[2]):
			var p := c + side * (k - (int(r[2]) - 1) * 0.5) * 1.1 + (c - door).normalized() * (0.4 if k % 2 else -0.2)
			var e := _an_eyeless(self, p, n, true)
			turn_to(e, door)
			person("eyeless_c%d" % n, L("build", "eyeless_prompt"), e, L("build", "gown_scan") % (n + 1)).set_meta("eyeless", true)
			room_eyeless.append({"fig": e, "room": c})
			n += 1
	# the shore of the river: "figures lining the shoreline"
	for k in 9:
		var lu: float = [16.0, 21.0, 25.0, 31.0, 36.0, 47.0, 53.0, 59.0, 67.0][k]
		var sd := -1.0 if k % 2 == 0 else 1.0
		var c := _rp(lu)
		var d := _rd(lu)
		var side := Vector3(-d.z, 0, d.x) * sd
		var p := c + side * (_half(lu) - 0.8) + Vector3(0, 0.3, 0)
		var e := _an_eyeless(self, p, 20 + k, false)
		turn_to(e, c)
		person("eyeless_r%d" % k, L("build", "eyeless_prompt"), e, L("build", "eyeless_scan")).set_meta("eyeless", true)
		river_eyeless.append({"fig": e})
	# the beach: in two loose lines along the way to the spire, some in it
	var zs := [0.0, -1.6, 1.4, -0.4, 2.0, -2.2, 0.6, -1.0, 1.8, 0.0, -1.8, 1.2, -0.6]
	for k in zs.size():
		var p := Vector3(-286.0 - k * 3.4, YB, 12.0 + float(zs[k]))
		var e := _an_eyeless(self, p, 40 + k, k % 4 == 1)
		if k % 3 == 2:
			turn_to(e, Vector3(-279.0, YB, 12.0))
		else:
			turn_to(e, SPIRE)
		person("eyeless_b%d" % k, L("build", "eyeless_prompt"), e, L("build", "eyeless_scan")).set_meta("eyeless", true)
		beach_eyeless.append({"fig": e, "touched": false})


func scan_people() -> Array:
	var out := []
	if lynx and lynx.visible:
		out.append([lynx, L("build", "lynx_scan")])
	return out


# ------------------------------------------------------------------ the serpent

## Observatory.gd's serpent (a chain of plates, a Psyonic-green core, red
## eyes), drawn 1.8x, with the hood the book gives it: "shaped like a
## cobra's hood, with wide metal sheets flaring at the end", the biggest
## thing in the game that moves. Eye layer only; with the frames off the
## same place holds a shape of smoke.
func _serpent_build() -> void:
	serpent = Node3D.new()
	serpent.visible = false
	serpent.set_meta("serpent", true)
	add_child(serpent)
	var red := glow(Color(1.0, 0.1, 0.05), 3.0)
	for i in NPL:
		var pl := Node3D.new()
		serpent.add_child(pl)
		var s := 1.0 - i * 0.02
		if i == 0:
			box(Vector3(0.5, 0.34, 0.72), Vector3(0, 0, 0), _plate_m, false, pl)
			box(Vector3(0.42, 0.1, 0.5), Vector3(0, -0.2, -0.1), _plate_m, false, pl)
			for sd: float in [-1.0, 1.0]:
				box(Vector3(0.07, 0.07, 0.07), Vector3(sd * 0.17, 0.08, -0.3), red, false, pl)
				box(Vector3(0.06, 0.2, 0.22), Vector3(sd * 0.22, 0.2, 0.1), _plate_m, false, pl)
			box(Vector3(0.56, 0.08, 0.3), Vector3(0, -0.04, 0.2), _core_m, false, pl)
		else:
			box(Vector3(0.44 * s, 0.3 * s, 0.5), Vector3(0, 0, 0), _plate_m, false, pl)
			box(Vector3(0.06, 0.18 * s, 0.3), Vector3(0, 0.2 * s, 0), _plate_m, false, pl)
			box(Vector3(0.52 * s, 0.1 * s, 0.24), Vector3(0, -0.02, 0.2), _core_m, false, pl)
			if i % 3 == 0:
				stick(Vector3(-0.2 * s, -0.1, 0.0), Vector3(-0.24 * s, -0.12, 0.42), 0.02, _cable, pl)
				stick(Vector3(0.2 * s, -0.1, 0.0), Vector3(0.24 * s, -0.12, 0.42), 0.02, _cable, pl)
		plates.append(pl)
	hood = Node3D.new()
	serpent.add_child(hood)
	for k in 9:
		var piv := Node3D.new()
		piv.set_meta("a", lerpf(-1.8, 1.8, k / 8.0))
		hood.add_child(piv)
		box(Vector3(0.44, 1.55, 0.05), Vector3(0, 0.88, 0), _plate_m, false, piv)
		box(Vector3(0.07, 1.3, 0.07), Vector3(0, 0.82, -0.04), _core_m, false, piv)
		box(Vector3(0.52, 0.06, 0.09), Vector3(0, 1.62, 0), _plate_m, false, piv)
		stick(Vector3(0, 0.1, 0.03), Vector3(0, 1.5, 0.05), 0.018, _cable, piv)
		hood_fans.append(piv)
	box(Vector3(1.4, 0.9, 0.03), Vector3(0, 0.45, 0.05), _dark_m, false, hood)
	for sd: float in [-1.0, 1.0]:
		var ring := cyl(0.22, 0.22, 0.02, Vector3(sd * 0.55, 0.95, -0.02), glow(Color(0.5, 1.0, 0.6), 1.8), 12, hood)
		ring.rotation.x = PI / 2.0
		var pupil := cyl(0.1, 0.1, 0.025, Vector3(sd * 0.55, 0.95, -0.03), _dark_m, 10, hood)
		pupil.rotation.x = PI / 2.0
	smoke = Node3D.new()
	smoke.visible = false
	smoke.set_meta("serpent", true)
	add_child(smoke)
	var sm := newmat(Color(0.05, 0.05, 0.055, 0.6), 1.0)
	sm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	for i in 16:
		puffs.append(sphere(0.9, Vector3.ZERO, sm, 8, smoke))
	for sd: float in [-1.0, 1.0]:
		sphere(0.06, Vector3(sd * 0.25, 2.3, -0.5), red, 6, smoke)


## The track the head follows this cycle, and how its length maps onto the
## chase line (chase s = h - _off).
func _set_track(pts: Array, anchor_i: int, anchor_s: float) -> void:
	_track = pts
	_cum = [0.0]
	for i in range(1, pts.size()):
		_cum.append(float(_cum[i - 1]) + (pts[i] as Vector3).distance_to(pts[i - 1]))
	_off = float(_cum[anchor_i]) - anchor_s


func _tp(s: float) -> Vector3:
	s = clampf(s, 0.0, float(_cum[_cum.size() - 1]))
	for i in range(1, _track.size()):
		if s <= float(_cum[i]) or i == _track.size() - 1:
			var t := (s - float(_cum[i - 1])) / maxf(0.001, float(_cum[i]) - float(_cum[i - 1]))
			return (_track[i - 1] as Vector3).lerp(_track[i], clampf(t, 0.0, 1.0))
	return _track[0]


func _td(s: float) -> Vector3:
	var d := _tp(s + 0.3) - _tp(s - 0.3)
	return d.normalized() if d.length() > 0.001 else Vector3(0, 0, -1)


## The track for a cycle: 0 comes down the north hall; 1 and 2 rise out of
## the corner shafts behind Carl; each ends diving into the next shaft. 3
## is the last: up out of the end shaft and back at him over the pit.
func _cycle_track(k: int) -> void:
	var d := 14.0
	match k:
		0:
			_set_track([Vector3(0, Y, -84), Vector3(0, Y, -48), Vector3(-62, Y, -48), Vector3(-63, Y + 0.2, -49), Vector3(-63, Y - d, -49)], 1, 0.0)
		1:
			_set_track([Vector3(-63, Y - d, -49), Vector3(-63, Y + 0.2, -49), Vector3(-62, Y, -48), Vector3(-62, Y, 12), Vector3(-61, Y + 0.2, 13), Vector3(-61, Y - d, 13)], 2, 62.0)
		2:
			_set_track([Vector3(-61, Y - d, 13), Vector3(-61, Y + 0.2, 13), Vector3(-62, Y, 12), Vector3(-122.5, Y, 12), Vector3(-122.5, Y - d, 12)], 2, 122.0)
		_:
			_set_track([Vector3(-122.5, Y - d, 12), Vector3(-122.5, Y + 0.2, 12), Vector3(-100.0, Y, 12)], 1, 182.5)


## The chase line itself (for dressing and for Carl's progress along it).
func _chase_point(s: float) -> Vector3:
	var acc := 0.0
	for i in CHASE.size() - 1:
		var a: Vector3 = CHASE[i]
		var b: Vector3 = CHASE[i + 1]
		var ln := a.distance_to(b)
		if s <= acc + ln or i == CHASE.size() - 2:
			return a.lerp(b, clampf((s - acc) / ln, 0.0, 1.0))
		acc += ln
	return CHASE[0]


func _chase_dir(s: float) -> Vector3:
	return (_chase_point(s + 0.5) - _chase_point(s - 0.5)).normalized()


## How far along the chase line a point is (rooms project to their door).
func _chase_s(p: Vector3) -> float:
	var best := 1e9
	var bs := 0.0
	var acc := 0.0
	for i in CHASE.size() - 1:
		var a: Vector3 = CHASE[i]
		var b: Vector3 = CHASE[i + 1]
		var ab := b - a
		ab.y = 0.0
		var ap := p - a
		ap.y = 0.0
		var t := clampf(ap.dot(ab) / ab.length_squared(), 0.0, 1.0)
		var q := a + ab * t
		var dd := Vector2(p.x - q.x, p.z - q.z).length()
		if dd < best - 0.01:
			best = dd
			bs = acc + ab.length() * t
		acc += ab.length()
	return bs


# ------------------------------------------------------------------ the drones and the crane

## "Seven drones flying in formation above me, staring down silently, like
## vultures circling a carcass." Slot 0, the point, is the crane's if it
## came this far with Carl.
func _drones_build() -> void:
	var red := glow(Color(1.0, 0.12, 0.08), 3.0)
	var ring_m := glow(Color(0.55, 0.85, 1.0), 0.9)
	var ring_mesh := TorusMesh.new()
	ring_mesh.inner_radius = 0.56
	ring_mesh.outer_radius = 0.64
	ring_mesh.rings = 16
	ring_mesh.ring_segments = 4
	var cone_mesh := CylinderMesh.new()
	cone_mesh.top_radius = 0.12
	cone_mesh.bottom_radius = 1.6
	cone_mesh.height = 8.0
	cone_mesh.radial_segments = 10
	cone_mesh.rings = 1
	cone_mesh.cap_top = false
	cone_mesh.cap_bottom = false
	var cone_m := StandardMaterial3D.new()
	cone_m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	cone_m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	cone_m.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	cone_m.albedo_color = Color(0.6, 0.85, 1.0, 0.022)
	cone_m.cull_mode = BaseMaterial3D.CULL_DISABLED
	for i in 7:
		var n := Node3D.new()
		n.visible = false
		n.set_meta("drone", true)
		add_child(n)
		var body := prop("police_drone", Vector3.ZERO, PI, 1.3, false, n)
		if body == null:
			box(Vector3(0.9, 0.25, 0.9), Vector3.ZERO, _dark_m, false, n)
		else:
			body.rotation.x = 0.45
			n.set_meta("body", body)
		sphere(0.09, Vector3(0, -0.15, -0.35), red, 6, n)
		# the rotor ring that sings its note, and a searchlight cone
		# sweeping the water (additive, no light: the budget is the cavern's)
		var ring := mesh(ring_mesh, Vector3(0, 0.12, 0), ring_m, n)
		ring.set_meta("ring", true)
		var cone := mesh(cone_mesh, Vector3(0, -4.2, 0), cone_m, n)
		cone.rotation.x = 0.22
		drones.append({"node": n, "slot": i})


func _slot(i: int, c: Vector3, d: Vector3) -> Vector3:
	if i == 0:
		return c
	var side := Vector3(-d.z, 0, d.x)
	var rank := float((i + 1) / 2)
	var sd := -1.0 if i % 2 == 1 else 1.0
	return c - d * rank * 2.6 + side * sd * rank * 2.3 + Vector3(0, rank * 0.3, 0)


## Prototype 7 "Grus" from Cognizo (Cognizo.gd's crane, copied): white
## polymer feathers black at the tips, a red crown, gold-ringed lenses.
func _crane_build() -> void:
	crane = Node3D.new()
	crane.visible = false
	add_child(crane)
	var white := mat(Color(0.9, 0.9, 0.88), 0.45)
	var black := mat(Color(0.05, 0.05, 0.06), 0.5)
	var red := mat(Color(0.8, 0.08, 0.06), 0.6)
	var grey := mat(Color(0.35, 0.35, 0.38), 0.5, 0.6)
	var body := Node3D.new()
	body.position = Vector3(0, 0.82, 0)
	crane.add_child(body)
	var b := sphere(0.2, Vector3.ZERO, white, 12, body)
	b.scale = Vector3(1.0, 0.85, 1.9)
	for k in 3:
		var tf := box(Vector3(0.07, 0.02, 0.34), Vector3((k - 1) * 0.07, 0.03, 0.42), black, false, body)
		tf.rotation.x = -0.35
	stick(Vector3(0, 0.08, -0.3), Vector3(0, 0.36, -0.4), 0.04, white, body)
	stick(Vector3(0, 0.36, -0.4), Vector3(0, 0.56, -0.44), 0.035, black, body)
	var head := Node3D.new()
	head.position = Vector3(0, 0.62, -0.46)
	body.add_child(head)
	sphere(0.06, Vector3.ZERO, white, 10, head)
	var crown := sphere(0.035, Vector3(0, 0.045, 0.0), red, 8, head)
	crown.scale = Vector3(1.0, 0.5, 1.2)
	stick(Vector3(0, -0.01, -0.04), Vector3(0, -0.03, -0.2), 0.012, grey, head)
	var lens := glow(GOLD, 2.4)
	for sx: float in [-1.0, 1.0]:
		var l := cyl(0.018, 0.018, 0.01, Vector3(sx * 0.055, 0.01, -0.01), lens, 8, head)
		l.rotation.z = PI / 2.0
	for sx: float in [-1.0, 1.0]:
		stick(Vector3(sx * 0.07, -0.1, 0.05), Vector3(sx * 0.08, -0.82, 0.1), 0.012, grey, body)
		stick(Vector3(sx * 0.08, -0.82, 0.1), Vector3(sx * 0.08, -0.82, -0.06), 0.008, grey, body)
	var wings := []
	for sx: float in [-1.0, 1.0]:
		var wp := Node3D.new()
		wp.position = Vector3(sx * 0.14, 0.08, -0.05)
		body.add_child(wp)
		for k in 7:
			var ln := 0.55 + k * 0.08 - (k * k) * 0.006
			var fz := -0.12 + k * 0.07
			var fx := sx * (0.15 + k * 0.13)
			var fe := box(Vector3(0.13, 0.015, ln), Vector3(fx, 0, fz + ln * 0.2), white, false, wp)
			fe.rotation.y = sx * (0.12 - k * 0.04)
			box(Vector3(0.12, 0.016, 0.16), Vector3(fx, 0.002, fz + ln * 0.2 + ln * 0.5 - 0.06), black, false, wp)
		wings.append(wp)
	crane.set_meta("wings", wings)
	crane.set_meta("body", body)
	crane.set_meta("drone", true)
	crane.set_meta("ally", true)
	_crane_fold(1.0)
	# its perch on the shore, among them
	var c := _rp(56.0)
	var d := _rd(56.0)
	var side := Vector3(-d.z, 0, d.x)
	box(Vector3(1.6, 0.9, 1.6), c - side * (_half(56.0) - 0.6) + Vector3(0, -0.1, 0), _sand, false, low)
	crane.position = c - side * (_half(56.0) - 0.6) + Vector3(0, 0.35, 0)
	turn_to(crane, c)
	_crane_from = crane.position


func _crane_fold(k: float) -> void:
	var wings: Array = crane.get_meta("wings")
	for i in wings.size():
		var sx := -1.0 if i == 0 else 1.0
		var w := wings[i] as Node3D
		w.rotation = Vector3(0, -sx * 1.35 * k, sx * 0.25 * k)
		w.scale = Vector3.ONE * (1.0 - 0.35 * k)


func _ally() -> bool:
	return main.flags.has("drone_ally") or main.flags.has("drone_owned")


## Carl as he falls, for the one panel: built once, hidden.
func _fall_figure() -> void:
	fall_fig = figure(Color(0.11, 0.12, 0.16), Color(0.84, 0.66, 0.54), {"hair": Color(0.12, 0.09, 0.07), "arms": true, "knees": true})
	fall_fig.visible = false
	add_child(fall_fig)
	var arms: Array = fall_fig.get_meta("arms")
	(arms[0] as Node3D).rotation = Vector3(0.3, 0, -2.6)
	(arms[1] as Node3D).rotation = Vector3(-0.4, 0, 2.4)
	var knees: Array = fall_fig.get_meta("knees")
	if knees.size() > 0:
		(knees[0] as Node3D).rotation.x = -1.1
	var legs: Array = fall_fig.get_meta("legs")
	(legs[1] as Node3D).rotation.x = 0.7


# ------------------------------------------------------------------ screens and lights

func _screens_build() -> void:
	_mm_up = _screen_mm(_xf_up)
	_mm_low = _screen_mm(_xf_low)
	for i in _xf_up.size():
		var c := Color(0.62, 1.0, 0.78) if rng.randf() < 0.8 else Color(1.0, 0.45, 0.4)
		_scr.append([_mm_up, i, (_xf_up[i] as Transform3D).origin, c * rng.randf_range(0.7, 1.0), 0.0, 3.6, 0.015])
	for i in _xf_low.size():
		var c := Color(0.35, 1.0, 0.85) if rng.randf() < 0.85 else Color(0.6, 0.8, 1.0)
		_scr.append([_mm_low, i, (_xf_low[i] as Transform3D).origin, c * rng.randf_range(0.6, 1.0), 0.0, 3.0, 0.12])
	# a phone face down still lights the sand round it: one additive pool
	# per device, lying flat, tinted with its screen
	var hm := MultiMesh.new()
	hm.transform_format = MultiMesh.TRANSFORM_3D
	hm.use_colors = true
	var hq := QuadMesh.new()
	hq.size = Vector2(1, 1)
	hm.mesh = hq
	hm.instance_count = _xf_low.size()
	for i in _xf_low.size():
		var o: Vector3 = (_xf_low[i] as Transform3D).origin
		hm.set_instance_transform(i, Transform3D(Basis(Vector3.RIGHT, -PI / 2.0) * Basis.from_scale(Vector3.ONE * 2.4), Vector3(o.x, o.y + 0.02, o.z)))
		hm.set_instance_color(i, Color(0, 0, 0))
	_mm_halo = MultiMeshInstance3D.new()
	_mm_halo.multimesh = hm
	var g := Gradient.new()
	g.set_color(0, Color(1, 1, 1, 1))
	g.set_color(1, Color(0, 0, 0, 1))
	var gt := GradientTexture2D.new()
	gt.gradient = g
	gt.fill = GradientTexture2D.FILL_RADIAL
	gt.fill_from = Vector2(0.5, 0.5)
	gt.fill_to = Vector2(0.5, 0.0)
	gt.width = 32
	gt.height = 32
	var hmat := StandardMaterial3D.new()
	hmat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	hmat.vertex_color_use_as_albedo = true
	hmat.albedo_texture = gt
	hmat.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	hmat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	hmat.cull_mode = BaseMaterial3D.CULL_DISABLED
	_mm_halo.material_override = hmat
	_mm_halo.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(_mm_halo)


func _screen_mm(xfs: Array) -> MultiMeshInstance3D:
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.use_colors = true
	var q := QuadMesh.new()
	q.size = Vector2(1, 1)
	mm.mesh = q
	mm.instance_count = xfs.size()
	for i in xfs.size():
		mm.set_instance_transform(i, xfs[i])
		mm.set_instance_color(i, Color(0.02, 0.02, 0.02))
	var mi := MultiMeshInstance3D.new()
	mi.multimesh = mm
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.vertex_color_use_as_albedo = true
	m.albedo_texture = _scr_tex
	m.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	m.cull_mode = BaseMaterial3D.CULL_DISABLED
	mi.material_override = m
	add_child(mi)
	return mi


func _collect_lights() -> void:
	for l in _lamps:
		(l[0] as Light3D).visible = false


# ------------------------------------------------------------------ the white room and Lynx (ch.28)

func intro() -> void:
	if _intro_run:
		return
	_intro_run = true
	var ui = main.ui
	var f: Dictionary = main.flags
	f["cinematic"] = true
	main.player.shake(0.3)
	main.play("pressure", -10.0, 0.6)
	await ui.think(L("intro", "think1"))
	await ui.think(L("intro", "think2"))
	await ui.think(L("intro", "think3"))
	ui.close()
	await _open_door()
	await ui.think(L("intro", "think4"))
	await ui.think(L("intro", "think5"))
	await ui.think(L("intro", "think6"))
	ui.close()
	f["rv_woke"] = true
	f.erase("cinematic")
	main.update_hud()


func _open_door() -> void:
	if main.flags.has("rv_door"):
		return
	main.flags["rv_door"] = true
	main.play("door", -6.0, 0.8)
	var db: Node = door_panel.get_meta("body")
	if is_instance_valid(db):
		db.queue_free()
	var tw := create_tween()
	tw.tween_property(door_panel, "position:x", 1.25, 1.2).set_trans(Tween.TRANS_SINE)
	await tw.finished


## "A shadow emerged, blocking the light." Lynx in the doorway; her lines;
## the extra one if she has reason to blame him.
func _doorway() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("rv_lynx") or _busy:
		return
	_busy = true
	f["cinematic"] = true
	await _open_door()
	await ui.think(L("door", "think1"))
	lynx.visible = true
	lynx_state = "door"
	lynx.position = DOOR + Vector3(0, 0, -1.8)
	turn_to(lynx, main.player.global_position)
	var tw := create_tween()
	tw.tween_property(lynx, "position", DOOR + Vector3(0, 0, -0.3), 1.4)
	main.play("step", -10.0, 0.7)
	await main.player.face(DOOR + Vector3(0, 1.4, -0.4), 0.8)
	await ui.think(L("door", "think2"))
	await ui.think(L("door", "think3"))
	await _say(LA("door", "carl1"))
	await _say(LA("door", "lynx1"))
	await _say(LA("door", "lynx2"))
	await ui.think(L("door", "think4"))
	if int(main.trust.get("lynx", 0)) <= -1 or f.has("warned_lynx"):
		await _lynx_knew()
	await _say(LA("door", "carl2"))
	await _say(LA("door", "lynx3"))
	await _say(LA("door", "carl3"))
	await ui.think(L("door", "think5"))
	ui.close()
	set_active(lynx_it, true)
	lynx_state = "follow"
	_trail = [main.player.global_position]
	f["rv_lynx"] = true
	main.log_line("lynx", L("door", "lynx_log"))
	f.erase("cinematic")
	_busy = false
	main.update_hud()


func _lynx_knew() -> void:
	main.flags["rv_lynx_knew"] = true
	await _say(LA("door", "knew"))
	await main.ui.think(L("door", "knew_think"))


# ------------------------------------------------------------------ the hall and the beds

func _beat(key: String, lines: Array) -> void:
	var f: Dictionary = main.flags
	_busy = true
	f["cinematic"] = true
	for ln in lines:
		if ln is Array:
			if lynx_state == "follow":
				await _say(ln)
		else:
			await main.ui.think(str(ln))
	main.ui.close()
	f[key] = true
	f.erase("cinematic")
	_busy = false
	main.update_hud()


func _old_phone() -> void:
	var ui = main.ui
	main.play("on", -8.0, 0.7)
	await ui.think(L("hall", "old_phone1"))
	await ui.say("", "[color=#6fe8d0]ORA  //  " + L("hall", "old_phone_cap") + "[/color]")
	await ui.think(L("hall", "old_phone2"))
	if not main.flags.has("rv_old_phone"):
		main.flags["rv_old_phone"] = true
		main.log_line("evidence", L("hall", "old_phone_log"))


# ------------------------------------------------------------------ the intersection and the split

func _intersection() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	_busy = true
	f["cinematic"] = true
	await ui.think(L("cross", "think1"))
	await ui.think(L("cross", "think2_on") if main.frames_on else L("cross", "think2_off"))
	main.play("static", -4.0, 0.4)
	main.player.shake(0.25)
	await ui.think(L("cross", "hiss"))
	ui.close()
	_cycle = 0
	_cycle_track(0)
	_h = 12.0
	_hood_k = 0.15
	_sstate = "scripted"
	main.play("sting", -6.0, 0.6)
	main.player.face(Vector3(0, Y + 2.0, -60.0), 0.9)
	var tw := create_tween().set_parallel(true)
	tw.tween_property(self, "_h", 27.0, 2.6).set_trans(Tween.TRANS_SINE)
	tw.tween_property(self, "_hood_k", 1.0, 2.0).set_delay(0.8)
	await ui.think(L("cross", "serpent"))
	await ui.think(L("cross", "locked"))
	var i: int = await ui.choose(LA("cross", "choices"))
	await _split_lines(i)
	ui.close()
	_start_chase()
	f.erase("cinematic")
	_busy = false
	main.update_hud()


## The split is forced: either way her hand is gone and the snake takes his hall.
func _split_lines(i: int) -> void:
	var ui = main.ui
	if i == 0:
		await ui.think(L("cross", "split0"))
	else:
		main.play("slam", -4.0, 0.6)
		main.player.shake(0.4)
		await ui.think(L("cross", "split1"))
	await _say(LA("cross", "run"))
	if lynx_state != "hidden":
		lynx_state = "run"
	await ui.think(L("cross", "split_end"))


func _start_chase() -> void:
	var f: Dictionary = main.flags
	if f.has("rv_split"):
		return
	f["rv_split"] = true
	f["rv_cross"] = true
	set_active(lynx_it, false)
	for b in [[Vector3(4.0, 4.5, 0.3), Vector3(0, Y + 2.25, -50.3)], [Vector3(0.3, 4.5, 4.0), Vector3(2.3, Y + 2.25, -48.0)], [Vector3(3.0, 4.5, 0.3), Vector3(0, Y + 2.25, -45.7)]]:
		blockers.append(solid_box(b[0], b[1]))
	_sstate = "hunt"
	_grace = 1.2
	_still = 0.0
	main.player.face(Vector3(-12.0, Y + 1.6, -48.0), 0.5)
	main.ui.show_toast(L("chase", "hint_on"), 5.0)
	_cap(L("chase", "burn"))
	_cap(L("chase", "toy"))


# ------------------------------------------------------------------ the chase

## Chase rules (bible A3-S4, combat.md "the serpent"): it senses the frames'
## signal. Frames on, it holds HOLD behind him and never loses a step; stand
## still three seconds and it takes him. Frames off in the open, it closes
## fast. Frames off in the cycle's dark room, it comes to the door; four
## seconds without moving and it passes, breaks the way open and dives.
## Caught: +4 C and back to the corridor's start. Never a game over.
func _tick_chase(delta: float, pp: Vector3) -> void:
	var f: Dictionary = main.flags
	if _cycle < 0 or _cycle > 2 or _sstate == "off" or _sstate == "scripted" or _sstate == "lunge":
		return
	var c := _chase_s(pp)
	if _sstate == "gone":
		if _cycle == 0 and f.has("rv_chase1") and c > 68.0:
			_start_cycle(1)
		elif _cycle == 1 and f.has("rv_chase2") and c > 128.0:
			_start_cycle(2)
		return
	var frozen: bool = main.ui.busy or f.has("cinematic") or _busy or main.loading or _shot
	var v := Vector2(main.player.velocity.x, main.player.velocity.z).length()
	if frozen:
		return
	_still = _still + delta if v < 0.3 else 0.0
	var hc := _h - _off
	if _sstate == "pass":
		_h += 4.4 * delta
		var rs: float = RUBBLE_S[_cycle]
		if rs > 0.0 and not _crash_done[_cycle] and hc >= rs - 2.5:
			_crash(_cycle)
		if _h - (NPL - 1) * SP >= float(_cum[_cum.size() - 1]) - 0.5:
			_sstate = "gone"
			f["rv_chase%d" % (_cycle + 1)] = true
			if _cycle == 2:
				_cap(L("chase", "never"))
		return
	if _grace > 0.0:
		_grace -= delta
		return
	if not _seen_rooms:
		for r in room_eyeless:
			if (r["room"] as Vector3).distance_to(pp) < 6.0:
				_seen_rooms = true
				_cap(L("chase", "eyeless"))
				break
	var dark := _in_dark(pp, _cycle)
	if main.frames_on:
		_sstate = "hunt"
		_move_head(c - HOLD, 7.5, delta)
		if _still > 3.0 and c - hc < HOLD + 1.0:
			_lunge()
			return
	elif dark:
		var ds: float = DOOR_S[_cycle]
		if hc < ds - 1.6:
			_sstate = "search"
			_move_head(ds - 1.0, 2.6, delta)
			if _still >= 4.0 and hc > ds - 9.0:
				_move_head(ds - 1.0, 5.0, delta)
		else:
			if _sstate != "wait":
				_sstate = "wait"
				main.play("whisper", -10.0, 0.5)
				_cap(L("chase", "wait"))
			if _still >= 4.0:
				_sstate = "pass"
				_cap(L("chase", "pass"))
				return
			elif v > 0.5:
				_lunge()
				return
	else:
		_sstate = "hunt"
		_move_head(c, 5.6, delta)
		if hc >= c - 1.5:
			_lunge()
			return
	if c < hc + 1.2:
		_lunge()


func _move_head(target: float, speed: float, delta: float) -> void:
	_h += clampf(target - (_h - _off), 0.0, speed * delta)


func _in_dark(p: Vector3, k: int) -> bool:
	if k < 0 or k > 2:
		return false
	var b: AABB = DARK[k]
	return p.x > b.position.x and p.x < b.end.x and p.z > b.position.z and p.z < b.end.z and absf(p.y - Y) < 2.0


func _start_cycle(k: int) -> void:
	_cycle = k
	_cycle_track(k)
	_h = 0.0
	_hood_k = 0.3
	_sstate = "hunt"
	_grace = 0.6
	_still = 0.0
	main.play("sting", -8.0, 0.5)
	create_tween().tween_property(self, "_hood_k", 1.0, 2.5).set_delay(1.5)
	if k == 1:
		_cap(L("chase", "glance"))
		_cap(L("chase", "hood"))
	else:
		_cap(L("chase", "darker"))


func _lunge() -> void:
	if _sstate == "lunge" or _busy:
		return
	_sstate = "lunge"
	_caught()


func _caught() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	_busy = true
	f["cinematic"] = true
	f["rv_caught"] = true
	main.play("slam", -2.0, 0.55)
	main.play("static", -2.0, 0.3)
	_hood_k = 1.0
	var c := _chase_s(p.global_position)
	create_tween().tween_property(self, "_h", c + _off - 0.6, 0.35)
	p.face((plates[0] as Node3D).global_position + Vector3(0, 0.3, 0), 0.25)
	ui.glitch(1.0, 1.0)
	ui.flash(0.6)
	p.shake(0.7)
	await get_tree().create_timer(0.5).timeout
	await ui.fade_to(1.0, 0.25)
	_catches += 1
	main.add_connection(4.0, L("chase", "caught_why"))
	main.log_line("serpent", L("chase", "caught_log"))
	var k := clampi(_cycle, 0, 2)
	_put(RESTART[k], RESTART_YAW[k])
	_h = _chase_s(RESTART[k]) - HOLD - 5.0 + _off
	_sstate = "hunt"
	_grace = 2.5
	_still = 0.0
	await get_tree().create_timer(0.5).timeout
	await ui.fade_to(0.0, 0.6)
	if _catches == 1:
		await ui.think(L("chase", "caught1"))
		await ui.think(L("chase", "caught2"))
	if not _hinted:
		_hinted = true
		await ui.think(L("chase", "hint"))
	ui.close()
	f.erase("cinematic")
	_busy = false
	main.update_hud()


## It breaks the choke open on its way through: the way on is for Carl.
func _crash(k: int) -> void:
	_crash_done[k] = true
	main.play("slam", -2.0, 0.4)
	main.player.shake(0.3)
	_cap(L("chase", "crash"))
	var g: Node3D = rubble[k][0]
	var body: Node = rubble[k][1]
	if is_instance_valid(body):
		body.queue_free()
	for ch in g.get_children():
		var n := ch as Node3D
		var tw := create_tween()
		tw.tween_property(n, "position", Vector3(n.position.x + rng.randf_range(-1.5, 1.5), Y + 0.25, n.position.z + rng.randf_range(-1.5, 1.5)), rng.randf_range(0.3, 0.7))
		tw.tween_property(n, "scale", Vector3.ONE * 0.5, 0.2)


## The serpent drawn from the head's place on its track: the plates follow
## the head's path, slither side to side, and the front of it rears like a
## cobra with the hood out. Frames off: the smoke shape instead.
var _look_at := Vector3.INF


func _pose_serpent() -> void:
	var active := _cycle >= 0 and _sstate != "off" and _sstate != "gone" and _track.size() > 1
	var on: bool = main.frames_on
	serpent.visible = active and on
	smoke.visible = active and not on
	if not active:
		return
	var pts := []
	for i in NPL:
		var s := _h - i * SP
		var p := _tp(s)
		var d := _td(s)
		if absf(d.y) < 0.5:
			var side := Vector3(-d.z, 0, d.x).normalized()
			p += side * sin(_t * 3.2 - i * 0.55) * 0.55 * clampf((i - 3) / 6.0, 0.0, 1.0)
			p.y += 0.32
			if i < 6:
				p.y += 2.1 * pow(1.0 - i / 6.0, 1.3) * _rear
				p -= d * (0.25 * (6 - i)) * _rear * 0.3
		pts.append(p)
	var cam: Vector3 = main.player.cam.global_position
	var tgt: Vector3 = _look_at if _look_at != Vector3.INF else cam
	for i in NPL:
		var pl: Node3D = plates[i]
		var p: Vector3 = pts[i]
		var dir: Vector3
		if i == 0:
			dir = tgt - p
			if dir.length() > 16.0 or dir.length() < 0.2:
				dir = p - (pts[1] as Vector3)
		else:
			dir = (pts[i - 1] as Vector3) - p
		if dir.length() < 0.001:
			dir = Vector3(0, 0, -1)
		dir = dir.normalized()
		var upv := Vector3.UP if absf(dir.y) < 0.95 else Vector3.FORWARD
		var b := Basis.looking_at(dir, upv) * Basis(Vector3.FORWARD, sin(_t * 3.0 + i * 0.4) * (0.5 if i > 0 else 0.1))
		pl.transform = Transform3D(b * Basis.from_scale(Vector3.ONE * 1.8), p)
	var hb := (plates[0] as Node3D).transform.basis.orthonormalized()
	hood.transform = Transform3D(hb, (pts[0] as Vector3) + hb * Vector3(0, 0.05, 0.6))
	for piv in hood_fans:
		var n := piv as Node3D
		n.rotation.z = -float(n.get_meta("a")) * lerpf(0.1, 1.0, _hood_k)
	hood.scale = Vector3.ONE * lerpf(0.6, 1.45, _hood_k)
	for i in puffs.size():
		var pf: MeshInstance3D = puffs[i]
		var j := mini(NPL - 1, int(float(i) / puffs.size() * NPL))
		pf.position = (pts[j] as Vector3) + Vector3(sin(_t + i) * 0.3, 0.25, cos(_t * 0.8 + i) * 0.3)
		var big := 2.2 if i < 2 else 1.5
		pf.scale = Vector3(big * (1.6 if i < 2 else 1.0), big, big) * (1.0 + sin(_t * 1.5 + i) * 0.2)


# ------------------------------------------------------------------ the fall (one panel)

func _fall() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	_busy = true
	f["cinematic"] = true
	_cycle = 3
	_cycle_track(3)
	_h = 0.0
	_hood_k = 1.0
	_sstate = "scripted"
	main.play("whisper", 0.0, 0.45)
	main.play("glitch", -2.0)
	ui.glitch(1.0, 1.6)
	create_tween().tween_property(self, "_h", 26.0, 2.4).set_trans(Tween.TRANS_SINE)
	p.face(Vector3(-116.0, Y + 2.4, 12.0), 0.7)
	f["rv_fear"] = true
	await ui.say("", "[center][b][color=#9effc0]" + L("fall", "fear_cap") + "[/color][/b][/center]")
	await ui.think(L("fall", "fear"))
	await ui.think(L("fall", "spent"))
	ui.close()
	# the ground gives way
	main.play("slam", 0.0, 0.4)
	p.shake(0.9)
	var tw := create_tween()
	tw.tween_property(p, "global_position", Vector3(-110.0, Y + 0.05, 12.0), 0.25)
	await tw.finished
	for n in pit_floor:
		if not is_instance_valid(n):
			continue
		if n is StaticBody3D:
			n.queue_free()
		else:
			var m := n as Node3D
			create_tween().tween_property(m, "position:y", m.position.y - 9.0, 0.9).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await get_tree().create_timer(0.5).timeout
	await ui.fade_to(1.0, 0.15)
	main.play("vacuum", -2.0, 0.4)
	main.play("pressure", -4.0, 0.5)
	# the panel: from the black water, up through the hole: Carl in the air,
	# the hood over the edge looking down at him
	fall_fig.visible = true
	fall_fig.position = Vector3(-110.0, YR + 4.6, 12.3)
	fall_fig.rotation = Vector3(0.5, 0.6, 0.25)
	_h = 14.4 + 10.6
	_look_at = fall_fig.position + Vector3(0, 1.0, 0)
	_pose_serpent()
	var hl := light(Vector3(-110.0, Y + 1.5, 12.0), SICK, 2.2, 14.0, false)
	_apply_zone("all")
	var tex: Texture2D = null
	if not main._selftest:
		var img: Image = await _picture(Vector3(-115.5, YR + 0.5, 16.0), Vector3(-110.0, Y - 0.5, 12.0), 68.0)
		img.resize(256, 160, Image.INTERPOLATE_BILINEAR)
		img.resize(768, 480, Image.INTERPOLATE_NEAREST)
		tex = ImageTexture.create_from_image(img)
	hl.queue_free()
	fall_fig.visible = false
	_zone = "fall"
	_look_at = Vector3.INF
	_sstate = "off"
	# the frames are gone, and the HUD with them, until the spire
	if main.frames_on:
		main.toggle_frames()
	f["rv_frames_lost"] = true
	main.log_line("frames", L("fall", "frames_log"))
	_hud(false)
	p.seated = true
	p.crouch = 1.25
	_u = 1.0
	_lat = 0.0
	_drift_place(0.0)
	p.yaw = PI / 2.0
	p.pitch = 0.25
	p.rotation.y = p.yaw
	crane.visible = _ally()
	f["rv_fell"] = true
	if tex:
		ui.show_picture(tex, L("fall", "panel_cap"))
	await ui.fade_to(0.0, 0.5)
	await ui.think(L("fall", "plunge"))
	ui.hide_picture()
	await ui.think(L("fall", "skin"))
	await ui.think(L("fall", "frames"))
	await ui.think(L("fall", "bag"))
	ui.close()
	_drifting = true
	f.erase("cinematic")
	_busy = false
	main.update_hud()


## A still from a camera in the world (Facility.gd's).
func _picture(from: Vector3, at: Vector3, fov := 60.0) -> Image:
	var vp := SubViewport.new()
	vp.size = Vector2i(512, 320)
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(vp)
	var cam := Camera3D.new()
	cam.fov = fov
	cam.near = 0.05
	vp.add_child(cam)
	cam.global_transform = Transform3D(Basis.looking_at(at - from, Vector3.UP), from)
	cam.current = true
	for l in _lamps:
		if (l[0] as Light3D).global_position.distance_to(at) < 30.0:
			(l[0] as Light3D).visible = true
	for i in 4:
		await RenderingServer.frame_post_draw
	var img := vp.get_texture().get_image()
	vp.queue_free()
	return img


func _hud(on: bool) -> void:
	var ui = main.ui
	for n in [ui.objective, ui.status, ui.crosshair, ui.toast]:
		(n as CanvasItem).visible = on
	_hud_off = not on


func _exit_tree() -> void:
	if _hud_off and main and is_instance_valid(main.ui):
		_hud(true)


# ------------------------------------------------------------------ the river

func _drift_place(delta: float) -> void:
	var p = main.player
	var c := _rp(_u)
	var d := _rd(_u)
	var side := Vector3(-d.z, 0, d.x)
	if delta > 0.0 and not main.ui.busy:
		var inp := Input.get_axis("move_left", "move_right")
		var right: Vector3 = Basis(Vector3.UP, p.yaw) * Vector3(1, 0, 0)
		_lat += right.dot(side) * inp * 1.1 * delta
	var lim := _half(_u) - 1.8
	_lat = clampf(_lat + sin(_t * 0.23) * 0.1 * delta, -lim, lim)
	p.global_position = c + side * _lat + Vector3(0, sin(_t * 1.3) * 0.04, 0)
	p.velocity = Vector3.ZERO


func _tick_drift(delta: float) -> void:
	var fwd := 0.0
	if not main.ui.busy:
		fwd = maxf(0.0, Input.get_axis("move_back", "move_fwd"))
	var before := _u
	_u = minf(_u + (1.8 + fwd * 1.2) * _drift_mul * delta, float(_rc[_rc.size() - 1]))
	if before < float(_rc[4]) and _u >= float(_rc[4]):
		_plunge()
	_drift_place(delta)


## The beats of the drift, each gated on the one before it.
func _river_beats() -> void:
	var f: Dictionary = main.flags
	var end: float = _rc[_rc.size() - 1]
	var fall_u: float = _rc[4]
	var chain := [["rv_float", "rv_fell", 3.0], ["rv_redrock", "rv_float", 9.0], ["rv_shore", "rv_redrock", 14.0],
		["rv_herded", "rv_shore", 26.0], ["rv_sun", "rv_herded", 35.0], ["rv_baptism", "rv_sun", 45.0],
		["rv_drones", "rv_baptism", 52.0], ["rv_falls", "rv_drones", fall_u], ["rv_metal", "rv_falls", float(_rc[5]) + 8.0],
		["rv_approach", "rv_metal", float(_rc[5]) + 42.0]]
	for b in chain:
		var key: String = b[0]
		if f.has(key) or not f.has(str(b[1])) or _u < float(b[2]):
			continue
		f[key] = true
		match key:
			"rv_float":
				_cap(L("river", "float"))
			"rv_redrock":
				_cap(L("river", "redrock"))
			"rv_shore":
				_cap(L("river", "shore"))
				_cap("[i]" + L("river", "hymn") + "[/i]")
			"rv_herded":
				_cap(L("river", "herded"))
			"rv_sun":
				_cap(L("river", "sun"))
			"rv_baptism":
				_cap(L("river", "baptism"))
				_cap(L("river", "hands"))
				main.log_line("baptism", L("river", "baptism_log"))
			"rv_drones":
				_form = "follow"
				_form_t = 0.0
				for dr in drones:
					(dr["node"] as Node3D).visible = true
					(dr["node"] as Node3D).global_position = _rp(_u + 30.0) + Vector3(0, 16.0, 0)
				var b0: Node3D = drones[0]["node"].get_meta("body", null)
				if b0:
					b0.visible = not _ally()
				_cap(L("river", "drones"))
			"rv_falls":
				_cap(L("river", "falls"))
			"rv_metal":
				_cap(L("river", "metal"))
			"rv_approach":
				_cap(L("river", "approach"))
		return
	if f.has("rv_approach") and not f.has("rv_beach") and _u >= end - 0.3 and _cap_q.is_empty() and not _cap_busy and not _busy:
		_deposit()


## The waterfall: under the black for a second.
func _plunge() -> void:
	var ui = main.ui
	main.play("vacuum", -4.0, 0.45)
	main.play("pressure", -8.0, 0.5)
	main.player.shake(0.4)
	main.player.crouch = 1.8
	await ui.fade_to(0.94, 0.25)
	await get_tree().create_timer(1.1).timeout
	main.player.crouch = 1.25
	await ui.fade_to(0.0, 0.8)


## The formation over the river, and the crane's exit (combat.md, the drone
## arc, step 4: "Betrayal"). Seven rotors in a chord.
func _tick_form(delta: float) -> void:
	if _form == "off" or _form == "gone":
		return
	var f: Dictionary = main.flags
	_form_t += delta
	var d := _rd(_u)
	var c := _rp(_u + 11.0) + Vector3(0, 7.5, 0)
	if _form == "leave":
		c += (d * 9.0 + Vector3(0, 3.0, 0)) * _form_t * _form_t * 0.5
	var k := minf(1.0, delta * (1.5 if _form != "leave" else 6.0))
	for i in drones.size():
		var n: Node3D = drones[i]["node"]
		var want := _slot(i, c, d) + Vector3(0, sin(_t * 1.1 + i) * 0.15, 0)
		n.global_position = n.global_position.lerp(want, k)
		n.rotation.y = lerp_angle(n.rotation.y, atan2(-d.x, -d.z), k)
		if i < _chord.size():
			var on := i != 0 or not _ally() or f.has("rv_drone_left")
			(_chord[i] as AudioStreamPlayer3D).volume_db = -14.0 if on else -80.0
	if crane.visible and _form != "follow":
		var wings: Array = crane.get_meta("wings")
		_crane_fold(0.0)
		for wi in wings.size():
			(wings[wi] as Node3D).rotation.z = (sin(_t * 9.0) * 0.55) * (-1.0 if wi == 0 else 1.0)
	match _form:
		"follow":
			if _ally() and _form_t > 3.0:
				_form = "join"
				_crane_t = 0.0
				_crane_from = crane.global_position
				main.play("whisper", -12.0, 0.8)
				_cap(L("river", "crane1"))
			elif not _ally() and _form_t > 11.0:
				_form = "leave"
				_form_t = 0.0
			elif _u > float(_rc[4]) - 6.0:
				_form = "leave"
				_form_t = 0.0
		"join":
			_crane_t += delta
			var t := clampf(_crane_t / 4.5, 0.0, 1.0)
			var slot0: Vector3 = (drones[0]["node"] as Node3D).global_position
			var mid := _crane_from.lerp(slot0, 0.5) + Vector3(0, 4.0, 0)
			crane.global_position = _crane_from.lerp(mid, t).lerp(mid.lerp(slot0, t), t)
			crane.rotation.y = lerp_angle(crane.rotation.y, atan2(-d.x, -d.z), minf(1.0, delta * 2.0))
			if t >= 1.0 or _u > float(_rc[4]) - 6.0:
				crane.global_position = slot0
				f["rv_drone_left"] = true
				f["drone_gone"] = true
				main.log_line("drone", L("river", "crane_log"))
				_cap(L("river", "crane2"))
				_cap("[b]" + L("river", "crane3") + "[/b]")
				_form = "leave"
				_form_t = -2.5
		"leave":
			if crane.visible and f.has("rv_drone_left"):
				crane.global_position = (drones[0]["node"] as Node3D).global_position + Vector3(0, -0.3, 0)
			if _form_t > 6.0:
				_form = "gone"
				for dr in drones:
					(dr["node"] as Node3D).visible = false
				crane.visible = false
				for ch in _chord:
					(ch as AudioStreamPlayer3D).volume_db = -80.0
				if f.has("rv_drone_left"):
					_cap(L("river", "gone"))


# ------------------------------------------------------------------ the beach and the spire

func _deposit() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	_busy = true
	f["cinematic"] = true
	_drifting = false
	await ui.fade_to(1.0, 0.8)
	p.seated = false
	p.crouch = 0.0
	_put(Vector3(-281.5, YB + 0.05, 12.0), PI / 2.0)
	p.pitch = -0.1
	await get_tree().create_timer(0.4).timeout
	await ui.fade_to(0.0, 1.0)
	await ui.think(L("beach", "arrive"))
	await ui.think(L("beach", "dark"))
	ui.close()
	f["rv_beach"] = true
	f.erase("cinematic")
	_busy = false


## Frames off, they cannot sense him; touching one is +5 and it does not react.
func _tick_beach(pp: Vector3) -> void:
	var f: Dictionary = main.flags
	if not f.has("rv_beach") or f.has("river_done"):
		return
	for e in beach_eyeless:
		if e["touched"]:
			continue
		var n: Node3D = e["fig"]
		if Vector2(n.global_position.x - pp.x, n.global_position.z - pp.z).length() < 0.78:
			e["touched"] = true
			_touches += 1
			f["rv_touched"] = true
			main.add_connection(5.0, L("beach", "touch_why"))
			main.log_line("touch", L("beach", "touch_log"))
			main.play("whisper", -6.0, 0.5)
			main.player.shake(0.35)
			if _touches == 1:
				_cap(L("beach", "touch"))


func _end() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if _ended:
		return
	_ended = true
	f["cinematic"] = true
	main.play("hum", -6.0, 0.6)
	await main.player.face(SPIRE + Vector3(0, 8.0, 0), 1.2)
	await ui.think(L("beach", "spire1"))
	await ui.think(L("beach", "spire2"))
	ui.close()
	f["rv_spire"] = true
	f["river_done"] = true
	_hud(true)
	f.erase("cinematic")
	main.update_hud()
	if not main._selftest:
		main.load_level("Core")


# ------------------------------------------------------------------ interactions

func interact(node: Object) -> bool:
	var ui = main.ui
	var f: Dictionary = main.flags
	var id := str(node.get_meta("id"))
	match id:
		"drain", "blood", "wallscreen", "chair":
			await ui.think(L("intro", id))
		"lynx":
			if not f.has("rv_lynx"):
				if f.has("rv_woke"):
					await _doorway()
			elif f.has("rv_split"):
				await ui.think(L("door", "again_split"))
			else:
				await ui.think(L("door", "again"))
		"old_phone":
			await _old_phone()
		"frames_pile", "laptop", "kidwatch", "tablet", "speaker":
			main.play("on", -14.0, 0.6)
			await ui.think(L("hall", id))
		"beds1", "beds2", "beds3":
			await ui.think(L("beds", id))
		"dark1", "dark2", "dark3":
			await ui.think(L("chase", "dark"))
		"rubble1", "rubble2":
			var k: int = node.get_meta("rubble")
			await ui.think(L("chase", "crash") if _crash_done[k] else L("chase", "rubble"))
		"shaft1", "shaft2", "shaft3":
			await ui.think(L("chase", "shaft"))
		"phone_shore":
			await ui.think(L("beach", "phone1"))
			await ui.think(L("beach", "phone2"))
		"spire":
			await _end()
		_:
			if id.begins_with("eyeless_c"):
				await ui.think(L("chase", "eyeless_look"))
			elif id.begins_with("eyeless_r"):
				await ui.think(L("river", "eyeless"))
			elif id.begins_with("eyeless_b"):
				await ui.think(L("beach", "eyeless"))
			else:
				return false
	return true


func objective() -> String:
	var f: Dictionary = main.flags
	if f.has("rv_frames_lost"):
		return L("objective", "river")
	if f.has("rv_split"):
		return L("objective", "hide") if _hinted else L("objective", "run")
	if f.has("rv_lynx"):
		return L("objective", "hall")
	if f.has("rv_woke"):
		return L("objective", "lynx")
	return L("objective", "wake")


func phone() -> String:
	var f: Dictionary = main.flags
	var t := L("phone", "line1")
	if f.has("rv_lynx"):
		t += L("phone", "line2")
	if f.has("rv_split"):
		t += L("phone", "line3")
	return t


# ------------------------------------------------------------------ each frame

func tick(delta: float) -> void:
	if not main or not main.player:
		return
	var p = main.player
	var pp: Vector3 = p.global_position
	var f: Dictionary = main.flags
	_tick_lights(delta, pp)
	_tick_screens(delta, pp)
	_tick_caps()
	_tick_lynx(delta, pp)
	_tick_eyeless(pp)
	var free: bool = not main.ui.busy and not _busy and not main.loading and not f.has("cinematic") and not _shot
	if free:
		if f.has("rv_woke") and not f.has("rv_lynx") and pp.distance_to(DOOR) < 2.4:
			_doorway()
		elif f.has("rv_lynx") and not f.has("rv_hall") and pp.z < -4.6:
			_beat("rv_hall", [L("hall", "think1"), L("hall", "think2")])
		elif f.has("rv_hall") and not f.has("rv_devices") and pp.z < -8.5:
			_beat("rv_devices", [L("hall", "devices"), L("hall", "hum"), LA("hall", "lynx_devices")])
		elif f.has("rv_devices") and not f.has("rv_beds") and pp.z < -11.5:
			_beat("rv_beds", [L("beds", "pass")])
		elif f.has("rv_beds") and not f.has("rv_lynx_hall") and pp.z < -29.0:
			_beat("rv_lynx_hall", [LA("beds", "lynx"), LA("beds", "carl")])
		elif f.has("rv_lynx_hall") and not f.has("rv_cross") and pp.z < -44.6 and pp.y > 5.0:
			_intersection()
		elif f.has("rv_chase3") and not f.has("rv_fell") and pp.y > 5.0 and _chase_s(pp) > PIT_S - 1.5:
			_fall()
	_tick_chase(delta, pp)
	_pose_serpent()
	if _drifting and not _shot:
		_tick_drift(delta)
	if not _shot:
		_river_beats()
	_tick_form(delta)
	_tick_beach(pp)
	_tick_sound()
	# his hands still bleed on the upper floor
	if pp.y > 5.0 and _drops < 60 and pp.distance_to(_last_drop) > 1.5 and not f.has("rv_fell"):
		_last_drop = pp
		_drops += 1
		var dq := floor_quad(Vector2(0.09, 0.09) * rng.randf_range(0.8, 1.6), Vector3(pp.x + rng.randf_range(-0.25, 0.25), Y + 0.007, pp.z + rng.randf_range(-0.25, 0.25)), rng.randf() * TAU, _blood_m)
		no_batch.append(dq)
	# the frames are at the bottom of the river
	_nf_t = maxf(0.0, _nf_t - delta)
	if f.has("rv_frames_lost") and not f.has("river_done"):
		if main.frames_on:
			main.toggle_frames()
			if _nf_t <= 0.0:
				_nf_t = 8.0
				_cap(L("fall", "no_frames"))
		if main._phone_on:
			main.toggle_phone()


func _tick_lights(delta: float, pp: Vector3) -> void:
	var zone := "up" if pp.y > 5.0 else "low"
	if zone != _zone:
		_zone = zone
		_env_zone(zone)
		_apply_zone(zone)
	for l in _lamps:
		if float(l[2]) >= 0.0 and (l[0] as Light3D).visible:
			var ph: float = l[2]
			var fl := sin(_t * 23.0 + ph) * sin(_t * 7.3 + ph * 2.0)
			(l[0] as Light3D).light_energy = float(l[3]) * (1.0 if fl > -0.55 else 0.12)
	_light_t -= delta
	if _light_t > 0.0:
		return
	_light_t = 0.2
	var cand := []
	for l in _lamps:
		var lt := l[0] as Light3D
		if l[1] == "pool":
			lt.visible = zone == "low"
		elif l[1] == zone:
			cand.append([lt.global_position.distance_to(pp), lt])
		else:
			lt.visible = false
	cand.sort_custom(func(a, b): return a[0] < b[0])
	for i in cand.size():
		(cand[i][1] as Light3D).visible = i < 20 and float(cand[i][0]) < 48.0
	# the beach phones cast their own small light
	if zone == "low" and main.flags.has("rv_beach"):
		var lit := []
		for s in _scr:
			if s[0] == _mm_low and float(s[4]) > 0.3:
				lit.append([(s[2] as Vector3).distance_to(pp), s])
		lit.sort_custom(func(a, b): return a[0] < b[0])
		for i in _pool.size():
			var o := _pool[i] as OmniLight3D
			if i < lit.size() and float(lit[i][0]) < 9.0:
				var s: Array = lit[i][1]
				o.global_position = (s[2] as Vector3) + Vector3(0, 0.3, 0)
				o.light_energy = 0.7 * float(s[4])
			else:
				o.light_energy = 0.0


## The screens light as Carl passes ("watching us pass"; on the beach "like
## bioluminescent algae") and fade back slowly behind him.
func _tick_screens(delta: float, pp: Vector3) -> void:
	_scr_t += delta
	if _scr_t < 0.08:
		return
	var dt := _scr_t
	_scr_t = 0.0
	# on the shore one phone in two never goes dark: the beach is lit by
	# nothing else
	var shore: bool = main.flags.has("rv_beach")
	for i in _scr.size():
		var s: Array = _scr[i]
		var pos: Vector3 = s[2]
		var k: float = s[4]
		var d := pos.distance_to(pp)
		var base := 0.5 if shore and s[0] == _mm_low and i % 2 == 0 else 0.0
		if k <= base and d > 12.0 and (k > 0.0 or base <= 0.0):
			continue
		var r: float = s[5] * (0.75 + 0.25 * sin(float(i) * 12.9898))
		var nk := minf(1.0, k + dt * 4.0) if d < r and absf(pos.y - pp.y) < 3.5 else maxf(base, k - dt * float(s[6]))
		if nk == k and nk <= 0.0:
			continue
		s[4] = nk
		var fl := 0.82 + 0.18 * sin(_t * 11.0 + i)
		(s[0] as MultiMeshInstance3D).multimesh.set_instance_color(int(s[1]), Color(0.02, 0.02, 0.02).lerp(s[3], nk * fl))
		if s[0] == _mm_low:
			var hc: Color = s[3]
			var hk := 0.6 * nk * fl
			_mm_halo.multimesh.set_instance_color(int(s[1]), Color(hc.r * hk, hc.g * hk, hc.b * hk, 1.0))


func _tick_lynx(delta: float, pp: Vector3) -> void:
	if not lynx or not lynx.visible:
		return
	match lynx_state:
		"door":
			Anim.idle(lynx, _t, 1.0)
			Anim.look(lynx, pp + Vector3(0, 1.2, 0), 0.9, 0.05)
			for a in lynx.get_meta("arms"):
				(a as Node3D).rotation.x = -0.35
		"follow":
			if _trail.is_empty() or (_trail[_trail.size() - 1] as Vector3).distance_to(pp) > 0.6:
				_trail.append(pp)
				if _trail.size() > 40:
					_trail.pop_front()
			var target: Vector3 = _trail[maxi(0, _trail.size() - 4)]
			target.y = pp.y
			var d := target - lynx.position
			d.y = 0.0
			var dist := d.length()
			if dist > 0.5 and pp.distance_to(lynx.position) > 1.4:
				var speed := clampf(dist * 2.2, 1.2, 5.0)
				lynx.position += d.normalized() * minf(speed * delta, dist)
				lynx.position.y = pp.y
				lynx.rotation.y = lerp_angle(lynx.rotation.y, atan2(-d.x, -d.z), minf(1.0, delta * 8.0))
				Anim.walk(lynx, _t, 1.1 * speed / 2.6, 0.0, 1.0)
			else:
				Anim.idle(lynx, _t, 1.0)
				Anim.look(lynx, pp + Vector3(0, 1.6, 0), 0.5, 0.04)
		"run":
			var goal := Vector3(21.0, Y, -48.0)
			var d := goal - lynx.position
			d.y = 0.0
			if d.length() < 0.5:
				lynx.visible = false
				lynx_state = "hidden"
				return
			if lynx.position.z < -46.5:
				lynx.position += d.normalized() * minf(4.6 * delta, d.length())
			else:
				lynx.position += (Vector3(lynx.position.x, Y, -48.0) - lynx.position).normalized() * 4.6 * delta
			lynx.rotation.y = lerp_angle(lynx.rotation.y, atan2(-d.x, -d.z), minf(1.0, delta * 10.0))
			Anim.walk(lynx, _t, 2.0, 0.0, 1.2)


## The rooms' eyeless track him with their sockets; the shore's turn to
## the river as he passes; the beach's sway with the hum and do not react.
func _tick_eyeless(pp: Vector3) -> void:
	var cam: Vector3 = main.player.cam.global_position
	if pp.y > 5.0:
		for r in room_eyeless:
			var n: Node3D = r["fig"]
			var dd := n.global_position.distance_to(pp)
			if dd < 18.0:
				Anim.look(n, cam, 1.0 if dd < 12.0 else 0.0, 0.08)
	else:
		for r in river_eyeless:
			var n: Node3D = r["fig"]
			if n.global_position.distance_to(pp) < 28.0:
				Anim.look(n, cam, 1.0, 0.04)
		for r in beach_eyeless:
			var n: Node3D = r["fig"]
			if n.global_position.distance_to(pp) < 24.0:
				var body: Node3D = n.get_meta("body")
				body.rotation.z = sin(_t * 0.9 + float(n.get_meta("phase"))) * 0.05


func _tick_sound() -> void:
	var low_zone := _zone == "low"
	var hunting := serpent.visible or smoke.visible
	if _scrape:
		_scrape.volume_db = -4.0 if hunting else -80.0
		_rasp.volume_db = -8.0 if hunting else -80.0
	if _churn.size() == 3:
		(_churn[0] as AudioStreamPlayer).volume_db = -15.0 if low_zone else -80.0
		(_churn[1] as AudioStreamPlayer).volume_db = -20.0 if low_zone else -80.0
		(_churn[2] as AudioStreamPlayer).volume_db = -80.0 if low_zone else -14.0
	for c in _hum_loops:
		(c as AudioStreamPlayer3D).volume_db = -10.0 if low_zone else -80.0


## Captions in a queue, so the drift and the chase never stop for text.
func _cap(text: String) -> void:
	_cap_q.append(text)


func _tick_caps() -> void:
	if _cap_busy or _cap_q.is_empty():
		return
	_cap_busy = true
	var text: String = _cap_q.pop_front()
	_show_cap(text)


func _show_cap(text: String) -> void:
	var plain := text.replace("[i]", "").replace("[/i]", "").replace("[b]", "").replace("[/b]", "")
	await main.ui.caption(plain, clampf(plain.length() * 0.045, 3.0, 8.0))
	_cap_busy = false


func _put(p: Vector3, yaw: float) -> void:
	var pl = main.player
	pl.global_position = p
	pl.velocity = Vector3.ZERO
	pl.yaw = yaw
	pl.pitch = 0.0
	pl.rotation.y = yaw


# ------------------------------------------------------------------ dev args and the self-test

## Screenshots: stage=door|hall|cross|chase|river|beach (cyc=0..2 and
## gap=metres for chase; u=metres downstream for river; drones=1 shows
## the formation, with the crane if drone_ally is in flags).
func apply_args(a: Dictionary) -> void:
	_shot = true
	var f: Dictionary = main.flags
	var st := str(a.get("stage", ""))
	match st:
		"door":
			f["rv_woke"] = true
			door_panel.position.x = 1.25
			lynx.visible = true
			lynx_state = "door"
			lynx.position = DOOR + Vector3(0, 0, -0.3)
			turn_to(lynx, main.player.global_position)
		"hall":
			for k in ["rv_woke", "rv_door", "rv_lynx", "rv_hall", "rv_devices"]:
				f[k] = true
			door_panel.position.x = 1.25
			lynx.visible = true
			lynx_state = "follow"
			lynx.position = main.player.global_position + Basis(Vector3.UP, main.player.yaw) * Vector3(0.7, 0, -2.2)
			turn_to(lynx, main.player.global_position)
		"cross":
			for k in ["rv_woke", "rv_door", "rv_lynx", "rv_hall", "rv_devices", "rv_beds", "rv_lynx_hall"]:
				f[k] = true
			lynx.visible = true
			lynx_state = "door"
			lynx.position = Vector3(1.2, Y, -47.0)
			_cycle = 0
			_cycle_track(0)
			_h = float(a.get("h", "27"))
			_hood_k = 1.0
			_sstate = "scripted"
		"chase":
			f["rv_split"] = true
			var k := int(a.get("cyc", "0"))
			_cycle = k
			_cycle_track(k)
			_h = _chase_s(main.player.global_position) - float(a.get("gap", "7")) + _off
			_hood_k = 1.0
			_sstate = "hunt"
		"river":
			f["rv_fell"] = true
			_u = float(a.get("u", "20"))
			main.player.seated = true
			main.player.crouch = 1.25
			_drift_place(0.0)
			if a.has("lat"):
				_lat = float(a["lat"])
				_drift_place(0.0)
			crane.visible = _ally()
			if a.has("drones"):
				_form = "follow"
				_form_t = -999.0
				var d := _rd(_u)
				for i in drones.size():
					var n: Node3D = drones[i]["node"]
					n.visible = true
					n.global_position = _slot(i, _rp(_u + 11.0) + Vector3(0, 7.5, 0), d)
				var b0: Node3D = drones[0]["node"].get_meta("body", null)
				if b0:
					b0.visible = not _ally()
				if _ally():
					crane.global_position = (drones[0]["node"] as Node3D).global_position
					_crane_fold(0.0)
		"beach":
			f["rv_beach"] = true
			f["rv_fell"] = true
	if a.has("yaw"):
		main.player.yaw = deg_to_rad(float(a["yaw"]))
	if a.has("pitch"):
		main.player.pitch = deg_to_rad(float(a["pitch"]))


func _by_id(id: String) -> void:
	for n in main._all_with_meta(self, "id"):
		if is_instance_valid(n) and str(n.get_meta("id")) == id:
			await main.interact(n)
			print("ok ", id)
			return
	print("MISSING ", id)


func _wait(cond: Callable, secs: float) -> bool:
	var t := 0.0
	while t < secs and not cond.call():
		await get_tree().process_frame
		t += get_process_delta_time()
	return cond.call()


## Headless: the white room, the doorway (and Lynx's extra line), the hall
## and the beds, the intersection (the pump picks 1: pull her right; the
## other split is played too), one catch with the frames on, the three
## hides, the fall, the drift with the formation (and the crane's exit: the
## run gives Carl the crane if he has none), the beach and a touch, the
## spire; then every interactable twice. Every wait has a deadline.
func selftest() -> void:
	# The cavern and the beach are heavy for llvmpipe; the test is of the
	# script, so the level is hidden while it runs (as Observatory.gd does).
	visible = false
	var f: Dictionary = main.flags
	var gave_crane := not _ally()
	if gave_crane:
		f["drone_ally"] = true
	await intro()
	for id in ["chair", "drain", "blood", "wallscreen"]:
		await _by_id(id)
	_put(DOOR + Vector3(0, 0.05, 1.2), 0.0)
	await _wait(func(): return f.has("rv_lynx"), 40.0)
	print("ok doorway lynx=", f.has("rv_lynx"), " knew=", f.has("rv_lynx_knew"))
	if not f.has("rv_lynx_knew"):
		await _lynx_knew()
		main.ui.close()
	for step in [[-6.0, "rv_hall"], [-10.0, "rv_devices"], [-13.0, "rv_beds"]]:
		_put(Vector3(0, Y + 0.05, float(step[0])), 0.0)
		await _wait(func(): return f.has(str(step[1])) and not _busy, 30.0)
		print("ok ", step[1], "=", f.has(str(step[1])))
	for id in ["old_phone", "frames_pile", "laptop", "kidwatch", "tablet", "speaker", "beds1", "beds2", "beds3", "lynx"]:
		await _by_id(id)
	_put(Vector3(0, Y + 0.05, -31.0), 0.0)
	await _wait(func(): return f.has("rv_lynx_hall") and not _busy, 30.0)
	_put(Vector3(0, Y + 0.05, -45.2), 0.0)
	await _wait(func(): return f.has("rv_split") and not _busy, 40.0)
	print("ok split=", f.has("rv_split"), " state=", _sstate)
	await _split_lines(0)
	main.ui.close()
	# one catch: frames on, standing still in corridor 1
	if not main.frames_on:
		main.toggle_frames()
	_put(Vector3(-10.0, Y + 0.05, -48.0), PI / 2.0)
	await _wait(func(): return _catches > 0 and not _busy, 40.0)
	print("ok caught=", _catches, " conn=", main.connection, " objective=", objective())
	# the three hides
	for k in 3:
		if not main.frames_on:
			main.toggle_frames()
		_put(RESTART[k] + _chase_dir(float(CORNER_S[k]) + 3.0) * 3.0, RESTART_YAW[k])
		await _wait(func(): return _cycle == k and _sstate != "gone", 20.0)
		var b: AABB = DARK[k]
		var c := b.get_center()
		_put(Vector3(c.x, Y + 0.05, c.z), RESTART_YAW[k])
		if main.frames_on:
			main.toggle_frames()
		await _wait(func(): return f.has("rv_chase%d" % (k + 1)), 120.0)
		print("ok hide ", k + 1, " passed=", f.has("rv_chase%d" % (k + 1)), " state=", _sstate, " crash=", _crash_done)
	# the pit
	_put(Vector3(-109.4, Y + 0.05, 12.0), PI / 2.0)
	await _wait(func(): return _drifting, 60.0)
	print("ok fell=", f.has("rv_fell"), " frames_lost=", f.has("rv_frames_lost"), " hud_off=", _hud_off, " fear=", f.has("rv_fear"))
	_drift_mul = 6.0
	await _wait(func(): return f.has("rv_beach") and not _busy, 300.0)
	print("ok river u=", snappedf(_u, 0.1), " beach=", f.has("rv_beach"), " drones=", f.has("rv_drones"), " crane_left=", f.has("rv_drone_left"), " form=", _form, " falls=", f.has("rv_falls"))
	main.toggle_frames()
	await _wait(func(): return not main.frames_on, 3.0)
	print("ok frames refused, on=", main.frames_on)
	var e: Node3D = beach_eyeless[3]["fig"]
	_put(e.global_position + Vector3(0.45, 0.05, 0.0), PI / 2.0)
	await _wait(func(): return _touches > 0, 8.0)
	print("ok touched=", _touches, " conn=", main.connection)
	await _by_id("phone_shore")
	_put(SPIRE + Vector3(6.6, 0.05, 0.0), PI / 2.0)
	await _by_id("spire")
	print("ok spire river_done=", f.has("river_done"), " hud_back=", not _hud_off)
	f.erase("cinematic")
	await main.selftest_all_interactables()
	if gave_crane:
		for k in ["drone_ally", "drone_gone", "rv_drone_left"]:
			f.erase(k)
	visible = true
