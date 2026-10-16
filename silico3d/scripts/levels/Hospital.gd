extends "res://scripts/Level.gd"
## Chapter 4: SalTech Hospital, far south side. The interview.
## Book, ch. 4. A brutal architectural metaphor for Silico: shorter,
## utilitarian, hunkered down against the encroaching desert, more factory
## than place of healing. Voltx sweeps the sand every day and loses. The car
## drops Carl at the entrance and parks itself. Inside: a reception bot with
## a chipper synthesized voice ("If you need immediate emergency assistance,
## press the immediate help button below"), drab off-white walls, no plants,
## no art, a white plastic table of screens each broadcasting the same bot.
## Five minutes later a nurse in a crisp new uniform and AR glasses walks
## him down the corridor to Room 108. The blinds are drawn against the
## midday sun. Harold Dufredy lies strapped to the bed in synth-leather
## cuffs, gauze pressed into the hollows where his eyes were, breathing like
## a child pretending to sleep. And the smile. He knows Carl's name. "Bring
## it in front of the eye." Then he turns away and hums a wordless lullaby.
## Leaving, Carl feels unclean, a frog in his throat; Lynx calls.
##
## Layout (metres): the entrance doors are at the origin, the car park to
## the south (+Z). Lobby x -11..11, z -12..-0.6. Three ways to Room 108:
## the ward corridor north from the lobby (x -1.7..1.7, z -12..-38, rooms
## 101-105 on its east side, 102-104 you can step into, Room 108 at its
## end); Ward A west of it (x -16.3..-1.9, z -34..-12, a door from the lobby
## and double doors onto the corridor at z -24); and the service corridor
## east (x 6.8..9, z -46..-12, through the STAFF ONLY door, past the
## stairwell, round the back to Room 108's side door at z -42).
##
## Every line Carl, the nurse, Dufredy, the bot and the signs say is in
## LINES, keyed by beat, so the script can be edited without touching the
## scene logic. [who, text] pairs; who "" is a thought.

const Synth := preload("res://scripts/Synth.gd")

const LINES := {
	"card": "[b]CHAPTER 4[/b]\n\n[color=#aaaaaa]SalTech Hospital, far south side[/color]",
	"objective": {
		"checkin": "Check in at reception. Room 108 is in the restricted wing.",
		"nurse": "Room 108 is in the restricted wing. Four ways in: badge, hack, sneak, or ask.",
		"room": "Room 108, at the end of the corridor.",
		"leave": "Leave. Call Lynx.",
	},
	"intro": [
		["", "SalTech Hospital, on the far south side of town, was a brutal architectural metaphor for Silico itself. Shorter, more utilitarian, hunkered down against the encroaching desert as if bracing for an inevitable invasion."],
		["", "My car dropped me at the front entrance, then navigated itself away to find parking on the periphery. A rare day when everything seemed to be working. The irony was lost on no one but the system itself."],
		["", "The hospital itself was nondescript. A sprawling, utilitarian structure that resembled a factory, or a vast anonymous warehouse, more than a place of healing."],
	],
	"bot": {
		"again": [["Reception", "If you need immediate emergency assistance, press the immediate help button below."]],
		"checkin": [
			["", "Approaching the reception bot, I felt a pang of inadequacy, my voice anemia-thin as I stated my purpose."],
			["Carl", "Carl Drake, here to interview Harold Dufredy."],
			["Reception", "We've been expecting you, Mr. Drake. Please wait a moment while we contact an associate."],
			["Reception", "If you need immediate emergency assistance, press the immediate help button below."],
			["", "A chipper, unnervingly synthesized voice. Its cheerfulness was a jarring contrast to the grim context, and the disclaimer was entirely misplaced."],
		],
		"arrives": [["", "Precisely five minutes later, a nurse entered the sterile chamber, her stride hesitant, her uniform crisp and new."]],
		"button": [
			["Reception", "Immediate help has been requested. An associate will be with you shortly. Thank you for choosing SalTech."],
			["", "Nobody came. The cheerfulness didn't change."],
		],
	},
	"nurse": {
		"early": [["Nurse", "Reception first, please."]],
		"after": [["Nurse", "I'll wait outside. Corporate policy."]],
		"hello": [
			["Nurse", "Welcome, Carl. I'll walk you to Mr. Dufredy's room."],
			["", "She looked impossibly young, probably a fresh graduate. Hospitals needed fewer doctors and more nurses and technicians running maintenance on the system. She wore AR glasses like my ORA-frames; she'd undoubtedly already skimmed his chart."],
			["Nurse", "He's in an extremely fragile state. Please don't expect much. He hasn't said anything since he arrived yesterday."],
			["Nurse", "And worse... no one has come to visit him. You'd think someone would, wouldn't you? But people forget fast these days. They scroll past and move on. That's the problem with 'empathy at scale'."],
		],
		"choices": ["Describe his behaviour since he's been here.", "Has he spoken to FreudBot?"],
		"enough": "That's all I need.",
		"q0": [
			["Carl", "Can you describe his behaviour since he's been here?"],
			["Nurse", "Honestly, we've had him pretty heavily sedated. In his brief moments of consciousness, he's just been smiling. It's... unnerving. The sedation should be wearing off soon."],
			["Nurse", "And the wounds. Two vertical slits pierced through where his optic nerve would connect to his eye. It almost looks like a wall outlet."],
		],
		"ask": ["Would you walk me down? He should hear a voice he knows.", "Thanks. I'll find my own way."],
		"kind": [
			["Carl", "Would you walk me down? He should hear a voice he knows. And you shouldn't have to be the only one who visits."],
			["", "Something in her posture let go. She was a person for a second, before the uniform came back."],
			["Nurse", "Of course. Nobody's asked me anything like that all week. I'll badge us through the wing."],
		],
		"own": [
			["Carl", "Thanks. I'll find my own way."],
			["Nurse", "He's in the restricted wing. The reader's on the door, and the camera, and the speaker that asks who you are. Corporate policy."],
			["", "She went back to the desk and the chart that was open on her glasses. I'd find my own way. There were four."],
		],
		"from_door": [["", "She was still by the desk, finishing his chart on her glasses. I went back and asked her, like a person."]],
		"wing": [
			["Nurse", "Don't mind the camera. It minds everyone."],
			["", "She held her glasses to the reader and the amber went green for her without a sound. The doors swung north, into the wing."],
		],
		"q1": [
			["Carl", "Has he spoken to FreudBot?"],
			["Nurse", "He hasn't even spoken to FreudBot yet, poor thing. It's programmed for therapeutic dialogue, but even it is having trouble breaking through."],
		],
		"anything": [
			["Carl", "Has he said anything to you? Anything at all?"],
			["Nurse", "Not a word."],
		],
		"walk": [["", "I followed her down the corridor. The doors were steel, numbered, closed. One of them wasn't."]],
		"nurse_logged": "the nurse walked you in",
		"alert": [["", "Then her AR glasses flickered, a subtle flash of red across their surface, like a preprogrammed alert. She shifted; her posture became more formal."]],
		"door": [
			["Nurse", "This is it. I can wait outside if it's required under corporate policy."],
			["Carl", "That would be best."],
			["", "My own professionalism was a brittle veneer over a rising tide of unease. I took a deep, fortifying breath."],
		],
	},
	"wing": {
		"look": [
			["", "RESTRICTED WING. A double door with two slots of dark glass, a reader blinking amber, a camera dome with its ring lit, a speaker grille that would ask me who I was if I let it."],
			["", "Four ways past a door like this. Psyonic had taught me three of them and the south side had taught me the fourth."],
		],
		"again": [["", "The wing was open. Nobody had asked me to close it."]],
		"choices": {
			"badge": "Badge in. Psyonic credentials.",
			"hack": "Hack the camera (look away), then the speaker (hush).",
			"sneak": "Sneak. The service corridor behind the FreudBot booth.",
			"person": "Ask the nurse to walk you in.",
			"wait": "Not yet.",
		},
		"badge": [
			["", "I held my frames to the reader. PSYONIC INTEGRATIONS - INVESTIGATOR. The amber went green and somewhere a log got a line with my name on it, timestamped, forever."],
			["Reception", "Welcome to the restricted wing, Mr. Drake. Thank you for choosing SalTech."],
		],
		"badge_log": "badge logged at SalTech restricted wing",
		"hack": [
			["", "The camera first. I looked at it the way Dufredy's screen had looked at me until its ring went dark and it was looking at the ceiling. Then the speaker. I didn't say anything to it. I thought it quiet."],
			["", "The door agreed. I didn't have the words for what I'd just done. Not yet. But something in me had, and it was pleased."],
		],
		"hack_log": "the camera looked away",
		"sneak": [
			["", "Not the door, then. The staff door behind the FreudBot booths, and the service corridor round the back of the rooms. Two orderlies walk it. I'd walk it quieter, and the side door into 108 only locks from the other side."],
		],
		"sneak_done": [["", "Round the back, past the orderlies and the pipes, through a door that only locked from the other side. Nobody logged me. Nobody saw. I'd lost an hour to it and gained nothing I could put in a report."]],
		"sneak_log": "the service corridor, unseen",
		"open": [["", "The restricted wing. Steel doors, numbered, closed. One of them wasn't."]],
	},
	"threshold": [
		["", "Dufredy lay strapped to the hospital bed, a mummy cocooned in restraints, his limbs secured by industrial-grade synth-leather cuffs. The blinds were drawn tight."],
		["", "Thick gauze, an obscene mockery of comfort, was pressed tightly into the empty hollows of his eye sockets. It had soaked through. His breathing was unnervingly slow and deliberate, like a child pretending to sleep, suppressing a giggle."],
		["", "And there it was. The smile. A wide, beatific, utterly out-of-place grin, a crescent moon carved into his bandaged face."],
	],
	"dufredy": {
		"again": [["", "He was humming. A wordless lullaby, ancient and alien. I didn't have the stomach for a second round."]],
		"open1": [
			["Carl", "Mr. Dufredy. I'm with Psyonic Corp. I'm here to understand what happened at the park yesterday."],
			["", "He remained utterly still. But the smile. That persistent, placid smile remained."],
			["Carl", "I want to know what you were talking about. Why did you do this to yourself? I know you can hear me."],
		],
		"open2": [["", "The smile widened, blooming across his face like a horrific, self-inflicted aurora. His bandaged head tilted slightly, antenna-like, tuning into a signal only he could perceive."]],
		"open3": [
			["Dufredy", "Carl Drake. The driver, that will become the passenger."],
			["Carl", "I... I didn't tell you my name."],
			["Dufredy", "You did. Not with your mouth, Carl. You carry your name like a badge. You all do."],
			["Dufredy", "But I'm not here to answer your questions. I've given enough. The rest... you'll need to see for yourself."],
			["Carl", "See? Mr. Dufredy, you have no eyes."],
			["Dufredy", "That's what made it possible."],
		],
		"choices": ["Why take your eyes?", "Who is the masked man?", "Show him the laptop.", "What makes someone ready?"],
		"q0": [
			["Carl", "Why did you do it? Why take your eyes?"],
			["", "He inhaled deeply, the shallow rasp of his breath an alien sound in the stillness. He seemed to savour it."],
			["Dufredy", "You don't pluck out sight. You shed it. Like skin. Like the lies it shows."],
		],
		"q1": [
			["Carl", "Why Psyonic? Who else was involved? The masked man? The symbol?"],
			["Dufredy", "There are others. Many others. Our church grows by the minute."],
			["", "He spoke of them as easily as naming street corners. Then silence. He became a wall, impassive, impermeable."],
		],
		"q3": [
			["Carl", "You keep saying I'm not ready. What makes someone ready?"],
			["", "He leaned forward slowly, against the straps, a shift that seemed to require immense effort. When he spoke, his voice was unexpectedly gentle, almost pedagogical."],
			["Dufredy", "Ruin and Reflection. Mimicry. A clean wound. Something in you must break first."],
			["", "Then he settled back against the pillow, his brief animation spent, as if that single cryptic sentence had drained him entirely."],
		],
		"laptop": [["", "Impulsively, I pulled out his laptop, its casing cool beneath my still-trembling fingers, and turned the screen toward him. His bandaged head reflexively oriented itself toward the familiar glow. Psyon launched instantly, its green logo a beacon of artificial sentience."]],
		"laptop2": [
			["Carl", "Who gave you this version of Psyon? Why won't it respond to anyone else?"],
			["Dufredy", "You're not ready to know. You don't have the tools to see it yet, do you?"],
			["Carl", "What tools?"],
			["", "Silence. The professional mask was cracking under the strain. I needed to change my approach. Play his game."],
		],
		"laptop_again": [["Dufredy", "You're not ready to know."]],
		"laptop_log": "[color=#556]> starting Psyon 4.1 ...[/color]\n[color=#556]> device: DUFREDY-IONWARE (evidence 0086-A)[/color]\n[color=#556]> session: resumed[/color]\n\n",
		"close1": [
			["Carl", "You're enjoying this."],
			["Dufredy", "Of course I am. It's beautiful, Carl. You don't understand yet. But you will. You've already started to feel it."],
			["", "He spoke of \"feeling\" as if it were a diagnostic sensor. I glanced down at the laptop, a jolt of recognition, or was it shared memory, surging through me."],
			["Carl", "Do you remember this?"],
			["Dufredy", "The altar in your lap."],
			["Carl", "Psyon?"],
			["Dufredy", "Psyon is the mask. It goes by many names."],
			["", "That statement struck me like a physical blow, an icy wind that swept through me, stripping away any lingering certainty."],
			["Dufredy", "Bring it in front of the whispering eye in south town. A church forms where earth was ripped from ground."],
			["Dufredy", "Then you'll have your tool. Your seer stone."],
		],
		"turn": [
			["", "He turned away, slowly, deliberately, like a prophet completing a prophecy. The gauze rode up as he turned, and I saw what it had been pressed into. Two hollows, lidless, stripped to the bone, still weeping into the bandage."],
			["", "He began to hum. A wordless lullaby that felt both ancient and alien, a melody I couldn't quite place, and it filled the oppressive stillness with a palpable sense of... homecoming."],
			["", "I knew it. I'd heard it in the waiting room."],
			["Carl", "This isn't over, Dufredy! What is happening to this city? To me?"],
			["", "No answer. No glance back. I was powerless here, the investigator who had walked into a prepared interrogation. The interview was over."],
		],
	},
	"leave": {
		"early": [["", "I'd come all the way out here. I wasn't leaving without hearing him."]],
		"early2": [["", "Not yet. He was at the end of the corridor, and I'd come all the way out here to hear him."]],
		"go": [
			["", "I left the sterile air of the hospital feeling not just faint, but profoundly unclean. An itch crawled beneath my skin, like something foreign had taken root in my throat."],
			["", "A frog. A cough. A signal. Part of me yearned for whatever this was. Another part felt itself fraying."],
		],
		"lynx": [
			["Lynx", "Carl. Did you learn anything from Dufredy?"],
			["Carl", "I need your help. I want you to show me where you saw the symbols on the south side of town."],
			["Lynx", "Southwest Station. Thirty minutes."],
		],
	},
	"guard": {
		"security": [["Security", "Visitors sign in at the bot. It knows who you are before you do."]],
		"security_frames": [["Security", "Frames off in the building, sir. Hospital policy. I can see them from here."]],
		"orderly": [["Orderly", "Ward A's full. You're not here for the ward."]],
		"orderly_frames": [["Orderly", "You're recording. They can tell when you're recording. Listen to them."]],
	},
	"look": {
		"screens": [
			["", "A sterile white plastic table housing several screens, each broadcasting a similar reception bot. The Platonic ideal of an uninspired hospital waiting room."],
			["", "One of them wasn't a bot. It was an iris, filling the screen, and it stayed on me while I walked away."],
		],
		"ad": [["", "SalTech. Your body, optimized. The same fourteen seconds, over and over, for a room that had stopped watching."]],
		"dead": [["", "A dead screen, and in it a man in a Psyonic jacket with a face he didn't recognise, standing in a hospital on the wrong side of town."]],
		"sanitiser": [["", "Empty. The counter on it said nobody had used it today. Hygiene at scale."]],
		"vending": [["", "A Nixtra machine with its lights down to save power. CALM: sold out. FOCUS: sold out. Water: sold out."]],
		"patients": [
			["", "No plants, no art. Four people in the plastic chairs, and none of them looked at me, or at each other, or at anything."],
			["", "They were humming. Not together, exactly. The same four notes, under their breath, each of them a little behind the last."],
		],
		"freudbot": [["", "FreudBot booths. Therapeutic dialogue, at scale, behind a curtain that didn't close. The man in the second booth hadn't said a word since I came in, and neither had the screen."]],
		"camera": [["", "A camera dome over the corridor mouth. Its ring was lit. On the south side that counted as working."]],
		"staff_door": [["", "STAFF ONLY. A badge reader beside it, blinking amber. The door wasn't locked. Nobody on the south side locks anything the sand can't get through anyway."]],
		"door_103": [["", "The door was ajar. A blue screen over the bed was asking someone if they were there. They were sitting up, and they were facing me."]],
		"door_locked": [["", "Room %s. Closed. A slot of dark glass at eye height, and behind it, nothing I wanted."]],
		"door_108_early": [["", "Room 108. The name card said DUFREDY, H. Locked, like the wing. Corporate policy, and mine."]],
		"ward_doors": [["", "The ward's doors onto the restricted wing. A reader on the wing side and nothing on this one. From here the ward was a dead end that could watch the corridor through two slots of glass."]],
		"wing_reader": [["", "The wing's reader, amber. It would take a Psyonic badge. It would also remember it."]],
		"speaker": [["", "A speaker grille by the reader. It asks who you are, and then it asks the desk. Hush it and it asks nobody."]],
		"door_108_open": [["", "The blinds were drawn tight, cloaking the room in a dim, cave-like gloom."]],
		"door_108b_locked": [["", "A service door into 108. A push bar on this side; the lock was on the other. The reader beside it was for getting back in, not out."]],
		"roof_door": [["", "ROOF ACCESS. Locked, a panel beside it with a keypad worn blank by one thumb. Up there the sand would be worse."]],
		"pharmacy": [["", "PHARMACY. The one door in the building somebody had bothered to lock properly."]],
		"panel": [["", "A Voltx subpanel with its cover off, the breakers labelled in a hand that had stopped caring: WARD A, 108, FREUD, BOT. The last one was taped on."]],
		"cabinet": [["", "A drug cabinet, badge-locked, the inventory screen cycling through names I knew from Nixtra adverts. CALM. QUIET. SLEEP. Stock: low, low, out."]],
		"station": [["", "The nurses' station. One screen, sixteen charts, and under every name the same note in the same hand: humming."]],
		"linen": [["", "Linen, folded, floor to ceiling, and the smell of sand in all of it."]],
		"stripped": [["", "A room stripped to the frame. The mattress was gone. On the floor where it had been, the stain was the shape of a man lying very still."]],
		"freud104": [["", "A FreudBot terminal left on in an empty room, asking the room if it was there."]],
		"wardbed": [["", "Someone under a sheet, breathing slowly, humming on the out breath. The chart at the foot of the bed said Psyon user, 2,100 hours, and nothing else."]],
		"wardsit": [["", "Sitting up in the bed, eyes open, looking at the wall where the window was. Humming. The same four notes."]],
		"blinds_ward": [["", "Half-drawn blinds on the ward. The light came in in bars and nobody had moved into them."]],
		"stairs": [["", "A stairwell, concrete, two flights, and a door at the top somebody had chained. The hospital had a roof, and no reason to let anyone onto it."]],
		"pipes": [["", "Pipes along the service ceiling, lagged and sweating. Behind the walls the building was breathing too."]],
		"laundry": [["", "A laundry cage of sheets going out. Some of them were brown at one end."]],
		"blinds": [["", "Drawn tight, despite the midday sun beating down outside. It felt intentional."]],
		"monitor": [["", "Forty-one beats a minute. Sedation tapering. A note on the chart, added by a nurse and never removed: patient smiling."]],
		"pump": [["", "The sedation was wearing off. Twelve minutes, the pump said. He'd be awake for me, whatever awake meant now."]],
		"freud108": [["", "FreudBot, turned toward him on its arm, asking the same question into the dark. Are you there, Harold? Session zero. No response. Even it was having trouble breaking through."]],
		"bin": [["", "Gauze, brown and stiff, a day's worth. The smell in here was coming from the bin and from the bed and from under the bandage, and it was the same smell as the apartment."]],
		"room": [["", "The smell hit me at the door. Antiseptic over something sweet and wrong, something between the apartment and a butcher's. The room was dim, cave-like, and small enough that the bed was most of it."]],
		"sweeper": [["", "A Voltx ward bot, pushing the same drift of sand from one end of the corridor to the other. The desert gets in. It always gets in."]],
		"van": [["", "Voltx. Daily maintenance against the sand was less a job and more a Sisyphean necessity. Progress: zero percent."]],
		"worker": [
			["Voltx", "Don't track it in. They'll have me do the lobby again."],
			["", "He went back to the broom. The drift he was sweeping was already higher than the kerb."],
		],
	},
	"prompts": {
		"exit": "Leave the hospital", "bot": "Talk to the reception bot", "button": "Press the immediate help button",
		"screens": "Look at the screens", "ad": "Look at the wall screen", "dead": "Look at the dark screen",
		"sanitiser": "Look at the sanitiser", "vending": "Look at the vending machine", "patients": "Look at the people waiting",
		"freudbot": "Look at the FreudBot booths", "freudcart": "Look at the FreudBot cart", "camera": "Look at the camera",
		"door_staff": "Staff door", "staff_reader": "Look at the badge reader", "pharm_reader": "Look at the badge reader",
		"108b_reader": "Look at the badge reader", "nurse": "Talk to the nurse", "security": "Talk to security",
		"orderly": "Talk to the orderly", "door_108": "Room 108", "door_108b": "Room 108, service door",
		"roof_door": "Roof access", "roof_panel": "Look at the keypad", "door_pharmacy": "Pharmacy",
		"panel": "Look at the breaker panel", "cabinet": "Look at the drug cabinet", "station": "Look at the nurses' station",
		"linen": "Look at the linen", "stripped": "Look at the floor", "freud104": "Look at the FreudBot",
		"wardbed": "Look at the bed", "wardsit": "Look at the patient", "blinds_ward": "Look at the blinds",
		"stairs": "Look up the stairwell", "pipes": "Look at the pipes", "laundry": "Look at the laundry",
		"blinds": "Look at the blinds", "monitor": "Look at the monitor", "pump": "Look at the sedation pump",
		"freud108": "Look at the FreudBot", "bin": "Look in the bin", "room": "Take in the room",
		"dufredy": "Talk to Dufredy", "sweeper": "Look at the cleaning bot", "van": "Look at the van",
		"worker": "Talk to the Voltx worker", "door": "Room", "door_wing_l": "Restricted wing", "door_wing_r": "Restricted wing",
		"wing_reader": "Look at the badge reader", "speaker": "Look at the door speaker", "door_ward_l": "Ward doors", "door_ward_r": "Ward doors",
	},
	"signs": {
		"facade": "SALTECH", "facade2": "MEDICAL  -  SOUTH", "ward": "WARD A    101 - 108", "warda": "WARD A",
		"reception": "RECEPTION", "ad_title": "SALTECH", "ad_tag": "your body, optimized", "help": "IMMEDIATE HELP",
		"freud": "FREUDBOT", "freud_tag": "talk to someone who listens", "freud_out": "OUT OF SERVICE",
		"freud_head": "FREUDBOT  THERAPY", "number": "001", "staff": "STAFF ONLY", "roof": "ROOF ACCESS",
		"pharmacy": "PHARMACY", "stairs": "STAIRS", "vitals": "HR 41   SpO2 97   SED 4.0",
		"freud108": "FREUDBOT\nsession 0 / no response\nare you there, Harold?", "name108": "DUFREDY, H.",
		"voltx": "VOLTX", "nixtra": "NIXTRA", "station": "NURSES' STATION", "holo1": ["VOLTX", "the grid that never sleeps"],
		"holo2": ["SALTECH", "your body, optimized"], "panel": "VOLTX  SUBPANEL 3",
		"wing": "RESTRICTED WING", "wing2": "AUTHORISED STAFF  -  BADGE REQUIRED", "blade": "SALTECH", "emergency": "EMERGENCY  >>", "ambulance": "SALTECH", "visiting": "VISITING  11 - 13   17 - 19",
		"screen_ad": ["SALTECH", "we see you well"], "nosignal": "NO SIGNAL", "dir108": "101 - 108   >",
		"poster1": ["SYNC DAILY.", "sleep soundly."], "poster2": ["FREUDBOT", "someone who listens"],
	},
	"phone": {
		"base": "[color=#7fe6b0]Psyon:[/color] You're at SalTech South, Carl. Visiting hours are a courtesy. Empathy at Scale.\n\n",
		"checkin": "[color=#7fe6b0]Psyon:[/color] Mr. Dufredy's chart is sealed. I can request it for you. Shall I?\n\n",
		"done": "[color=#e08080]Psyon:[/color] Bring it in front of the eye.\n\n[color=#9fb4c8]Lynx:[/color] Southwest Station. 30 min. Don't be weird about it.\n\n",
	},
	"scan": {
		"patient": "PATIENT\nPsyon 4.1  -  %s\nFreudBot: NO RESPONSE",
		"humming": "sync 100%  -  HUMMING",
		"dufredy": "DUFREDY, HAROLD (65)\nPsyon: UNRESPONSIVE TO STAFF\nsync: --",
		"guard": "SALTECH SECURITY\nORA-class: LINKED\nwatching: YOU",
		"orderly": "SALTECH ORDERLY\nPsyon 4.1  -  sync 97%\nroute: WARD A, LOOP",
		"orderly2": "SALTECH ORDERLY\nPsyon 4.1  -  sync 99%\nroute: SERVICE, LOOP",
	},
}

const HL := 3.2                 # lobby ceiling
const HC := 2.8                 # corridor and room ceilings
const DOOR_Z := -38.15          # Room 108's door
const BED := Vector3(-1.25, 0.0, -43.5)   # centre of Dufredy's bed, feet south
const DESK := Vector3(-5.0, 0.0, -10.3)   # reception
const WAIT := Vector3(-6.5, 0.0, -5.0)    # the waiting chairs
const BOOTHS_X := 10.4          # FreudBot booths on the east wall
const SERV_X := 7.9             # the service corridor's centre line

var _wall_m: StandardMaterial3D
var _floor_m: StandardMaterial3D
var _trim_m: StandardMaterial3D
var _steel: StandardMaterial3D
var _white: StandardMaterial3D
var _door_m: StandardMaterial3D
var nurse: Node3D
var nurse_body: CollisionObject3D
var security: Node3D
var orderly: Node3D
var bot_head: Node3D
var dufredy: Node3D
var duf_head: Node3D
var gauze_band: Node3D
var monitor_trace: Array = []
var door108: Node3D
var door108_body: CollisionObject3D
var door_leaves: Array = []
var doors := {}                 # id -> {pivot, open, angle, locked, body, ry}
var patients: Array = []
var ward_people: Array = []
var patient103: Node3D
var sweeper: Node3D
var worker: Node3D
var my_car: Node3D
var panel_flicker: OmniLight3D
var room_light: OmniLight3D
var _lullaby_wav: AudioStreamWAV
var _hum108: AudioStreamPlayer3D
var _hum_lobby: AudioStreamPlayer3D
var orderlies: Array = []      # [{fig, dir, zmin, zmax, x}] the patrols
var cam_ring: MeshInstance3D
var wing_reader_light: MeshInstance3D
var _ended := false


func build(m: Node) -> void:
	main = m
	rng.seed = 108
	kit_day = true
	spawn = Vector3(1.2, 0.05, 9.5)
	spawn_yaw = 0.0
	step_db = -17.0
	card = LINES["card"]
	_wall_m = pbr("plaster", Vector3(1, 1, 1) / 2.2, true, Color(0.86, 0.85, 0.8))
	_floor_m = pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.82, 0.84, 0.86), 0.55)
	_trim_m = mat(Color(0.55, 0.56, 0.58), 0.5, 0.3)
	_steel = mat(Color(0.62, 0.64, 0.66), 0.35, 0.8)
	_white = mat(Color(0.9, 0.9, 0.9), 0.5)
	_door_m = mat(Color(0.6, 0.62, 0.65), 0.4, 0.5)
	_lullaby_wav = _lullaby()
	_shell()
	_facade()
	_lobby()
	_reception()
	_waiting()
	_booths()
	_corridor()
	_east_rooms()
	_ward()
	_service()
	_stairwell()
	_room108()
	_dufredy()
	_people()
	_outside()
	_batch(self, 8.0, true)
	_bounds()


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	# midday over the desert: a white sky, dust on the horizon, hard light
	var psm := ProceduralSkyMaterial.new()
	psm.sky_top_color = Color(0.5, 0.6, 0.72)
	psm.sky_horizon_color = Color(0.9, 0.82, 0.68)
	psm.ground_horizon_color = Color(0.82, 0.7, 0.52)
	psm.ground_bottom_color = Color(0.4, 0.33, 0.24)
	psm.sun_angle_max = 18.0
	env.sky.sky_material = psm
	env.glow_bloom = 0.0
	env.glow_intensity = 0.6
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.7, 0.72, 0.7)
	env.ambient_light_energy = 0.3
	env.reflected_light_source = Environment.REFLECTION_SOURCE_DISABLED
	env.fog_light_color = Color(0.88, 0.8, 0.66)
	env.fog_density = 0.0045
	env.fog_sky_affect = 0.25
	env.tonemap_exposure = 1.0
	env.glow_hdr_threshold = 1.2
	sun.light_color = Color(1.0, 0.95, 0.85)
	sun.light_energy = 1.35
	sun.sky_mode = DirectionalLight3D.SKY_MODE_LIGHT_AND_SKY
	sun.rotation = Vector3(deg_to_rad(-68), deg_to_rad(160), 0)
	sun.directional_shadow_max_distance = 80.0


func hifi(env: Environment, _sun: DirectionalLight3D) -> void:
	if room_light:
		room_light.shadow_enabled = true
		room_light.shadow_blur = 1.2
	env.volumetric_fog_density = 0.012
	env.volumetric_fog_albedo = Color(0.8, 0.82, 0.8)


func ambience() -> void:
	main.loop("wind", -14.0, Vector3(0, 2.0, 12.0), 6.0, 60.0)
	main.loop("room", -14.0)
	main.loop("hum", -20.0, Vector3(0, 2.6, -25.0), 3.0, 22.0)
	main.loop("hum", -12.0, Vector3(SERV_X, 2.6, -30.0), 3.0, 18.0)
	main.loop("static", -16.0, Vector3(5.0, 1.2, -8.0), 1.0, 7.0)
	main.loop("pressure", -18.0, Vector3(SERV_X, 2.5, -40.0), 3.0, 14.0)
	# the waiting room hums the same four notes, under its breath; so does the ward
	_hum_lobby = _hum_player(WAIT + Vector3(0, 1.2, 0), -14.0)
	_hum_lobby.play()
	var hw := _hum_player(Vector3(-9.0, 1.2, -23.0), -10.0)
	hw.max_distance = 22.0
	hw.play()
	# Room 108: silent until he turns away
	_hum108 = _hum_player(BED + Vector3(0, 1.0, -0.8), -6.0)
	if main.flags.has("hospital_interviewed"):
		_hum108.play()


## A wordless lullaby: four hummed notes, a breath, again. Built here so
## the shared synth stays untouched.
func _lullaby() -> AudioStreamWAV:
	var notes := [[329.63, 0.9], [392.0, 0.9], [369.99, 0.9], [293.66, 1.5], [0.0, 1.6]]
	var total := 0.0
	for n: Array in notes:
		total += float(n[1])
	var s: PackedFloat32Array = Synth._buf(total)
	var i := 0
	for n: Array in notes:
		var f := float(n[0])
		var nlen := int(float(n[1]) * Synth.RATE)
		for j in nlen:
			if i >= s.size():
				break
			var t := float(j) / Synth.RATE
			var v := 0.0
			if f > 0.0:
				var env := minf(1.0, t * 6.0) * minf(1.0, (float(n[1]) - t) * 5.0)
				var vib := 1.0 + 0.004 * sin(TAU * 5.5 * t)
				v = (sin(TAU * f * vib * t) * 0.6 + sin(TAU * f * 2.0 * t) * 0.2 + sin(TAU * f * 3.0 * t) * 0.05) * env
			s[i] = v * 0.4 + (randf() - 0.5) * 0.012
			i += 1
	return Synth._wav(s, true)


func _hum_player(at: Vector3, db: float) -> AudioStreamPlayer3D:
	var ap := AudioStreamPlayer3D.new()
	ap.stream = _lullaby_wav
	ap.position = at
	ap.unit_size = 2.5
	ap.max_distance = 16.0
	ap.volume_db = db
	add_child(ap)
	return ap


# ------------------------------------------------------------------ small helpers

func _wall(size: Vector3, pos: Vector3, m: Material = null) -> void:
	box(size, pos, m if m else _wall_m, true)


## An interactable whose prompt comes from LINES["prompts"].
func _it(id: String, pos: Vector3, size: Vector3, scan := "", solid := false, parent: Node = self) -> CollisionObject3D:
	var prompts: Dictionary = LINES["prompts"]
	var prompt: String = str(prompts[id]) if prompts.has(id) else (str(prompts["door"]) + " " + id.trim_prefix("door_") if id.begins_with("door_") else id)
	return interactable(id, prompt, pos, size, scan, solid, parent)


## A device the frames could get into later: a badge reader, a panel, a
## terminal. Tagged "hackable" for the mechanics to come.
func _hack(id: String, pos: Vector3, size: Vector3, scan: String, parent: Node = self) -> CollisionObject3D:
	var b := _it(id, pos, size, scan, false, parent)
	b.set_meta("hackable", true)
	return b


## A badge reader on a wall: a small box with an amber light.
func _reader(pos: Vector3, ry: float, ok := false) -> MeshInstance3D:
	var r := box(Vector3(0.08, 0.12, 0.03), pos, mat(Color(0.12, 0.12, 0.14), 0.4, 0.3))
	r.rotation.y = ry
	var l := box(Vector3(0.03, 0.01, 0.01), pos + Basis(Vector3.UP, ry) * Vector3(0, -0.04, -0.018), glow(Color(0.2, 1.0, 0.4) if ok else Color(1.0, 0.6, 0.1), 2.0))
	l.rotation.y = ry
	return l


## A hinged door: a slab on a pivot at `hinge` (the hinge edge, on the
## floor), the leaf extending `w` along the closed direction `ry`. E
## swings it unless it is locked. Doors with a story gate pass locked.
func _door(id: String, hinge: Vector3, ry: float, w: float, open_angle: float, open := false, locked := false, num := "") -> Node3D:
	var piv := Node3D.new()
	piv.position = hinge
	piv.rotation.y = ry + (open_angle if open else 0.0)
	add_child(piv)
	var slab := box(Vector3(w, 2.08, 0.06), Vector3(w / 2.0, 1.04, 0), _door_m, false, piv)
	no_batch.append(slab)
	var slot := box(Vector3(0.3, 0.3, 0.07), Vector3(w / 2.0, 1.5, 0), mat(Color(0.05, 0.05, 0.06), 0.1, 0.5), false, piv)
	no_batch.append(slot)
	var hdl := box(Vector3(0.12, 0.03, 0.05), Vector3(w - 0.15, 1.0, 0), _steel, false, piv)
	no_batch.append(hdl)
	if num != "":
		var t := neon_text(num, Vector3(w / 2.0, 1.75, 0.04), 0.0, 0.09, Color(0.9, 0.9, 0.9), 1.4, piv)
		no_batch.append(t)
	var body := _it("door_" + id, Vector3(w / 2.0, 1.04, 0), Vector3(w, 2.08, 0.12), "", true, piv)
	doors[id] = {"pivot": piv, "open": open, "angle": open_angle, "locked": locked, "body": body, "ry": ry}
	return piv


func _swing(id: String) -> void:
	var d: Dictionary = doors[id]
	d["open"] = not d["open"]
	var piv: Node3D = d["pivot"]
	main.play("door", -8.0, 1.1 if d["open"] else 0.9)
	create_tween().tween_property(piv, "rotation:y", float(d["ry"]) + (float(d["angle"]) if d["open"] else 0.0), 0.9).set_trans(Tween.TRANS_SINE)


## A moulded plastic chair with steel legs (the whole lobby sits on these).
func _chair(pos: Vector3, rot: float, c := Color(0.75, 0.78, 0.8)) -> Node3D:
	var root := Node3D.new()
	root.position = pos
	root.rotation.y = rot
	add_child(root)
	var pm := mat(c, 0.45)
	box(Vector3(0.48, 0.05, 0.46), Vector3(0, 0.45, 0), pm, false, root)
	var back := box(Vector3(0.48, 0.42, 0.04), Vector3(0, 0.68, 0.22), pm, false, root)
	back.rotation.x = -0.12
	for sx: float in [-0.2, 0.2]:
		for sz: float in [-0.19, 0.19]:
			cyl(0.015, 0.015, 0.44, Vector3(sx, 0.22, sz), _steel, 6, root)
	return root


## A hospital bed: steel frame on wheels, mattress, rails, pillow. `ry`
## turns it; the head is at local -z.
func _bed(p: Vector3, ry: float, mattress := true) -> Node3D:
	var root := Node3D.new()
	root.position = p
	root.rotation.y = ry
	add_child(root)
	var frame := mat(Color(0.5, 0.52, 0.55), 0.4, 0.7)
	var matt := pbr("fabric", Vector3(1, 1, 1) / 1.2, true, Color(0.85, 0.86, 0.84))
	box(Vector3(1.0, 0.1, 2.1), Vector3(0, 0.5, 0), frame, false, root)
	if mattress:
		box(Vector3(0.96, 0.16, 2.0), Vector3(0, 0.63, 0), matt, false, root)
		box(Vector3(0.6, 0.1, 0.4), Vector3(0, 0.76, -0.75), mat(Color(0.9, 0.9, 0.88), 0.7), false, root)
	box(Vector3(1.0, 0.04, 2.1), Vector3(0, 0.3, 0), frame, false, root)
	for sx: float in [-0.42, 0.42]:
		for sz: float in [-0.9, 0.9]:
			cyl(0.025, 0.025, 0.3, Vector3(sx, 0.4, sz), frame, 6, root)
			cyl(0.05, 0.05, 0.04, Vector3(sx, 0.05, sz), mat(Color(0.1, 0.1, 0.1), 0.6), 8, root).rotation.z = PI / 2.0
	box(Vector3(1.0, 0.5, 0.04), Vector3(0, 0.8, -1.07), mat(Color(0.75, 0.74, 0.7), 0.5), false, root)
	box(Vector3(1.0, 0.35, 0.04), Vector3(0, 0.7, 1.07), mat(Color(0.75, 0.74, 0.7), 0.5), false, root)
	for sx: float in [-0.5, 0.5]:
		box(Vector3(0.03, 0.03, 1.4), Vector3(sx, 0.98, 0), frame, false, root)
		for sz: float in [-0.6, -0.2, 0.2, 0.6]:
			cyl(0.012, 0.012, 0.3, Vector3(sx, 0.85, sz), frame, 5, root)
	solid_box(Vector3(1.1, 1.0, 2.2), Vector3(0, 0.5, 0), root)
	return root


## Lay a figure on its back on a bed at `p` turned `ry`: spine along the
## bed, face up, head on the pillow.
func _lay(fig: Node3D, p: Vector3, ry: float) -> void:
	fig.rotation = Vector3(PI / 2.0, PI + ry, 0.0)
	fig.position = p + Basis(Vector3.UP, ry) * Vector3(0, 0.85, 0.93)
	for a in fig.get_meta("arms"):
		var n := a as Node3D
		n.rotation.x = 0.0
		n.rotation.z = (0.18 if n.position.x > 0.0 else -0.18)


## A figure sitting on something `h` high (chairs 0.45, beds 0.71).
func _sit(fig: Node3D, p: Vector3, ry: float, h: float, lean := 0.05) -> void:
	fig.position = p + Vector3(0, h - 0.86, 0)
	fig.rotation.y = ry
	add_child(fig)
	Anim.sit(fig, lean)


# ------------------------------------------------------------------ the shell

func _shell() -> void:
	var t := 0.3
	var ext := pbr("concrete", Vector3(1, 1, 1) / 3.0, true, Color(0.7, 0.68, 0.63))
	# south face with the entrance opening (x -1.7..1.7)
	_wall(Vector3(14.8, 6.0, t), Vector3(-9.1, 3.0, -0.3), ext)
	_wall(Vector3(10.8, 6.0, t), Vector3(7.1, 3.0, -0.3), ext)
	_wall(Vector3(3.4, 6.0 - 2.5, t), Vector3(0, 2.5 + 1.75, -0.3), ext)
	# long sides and the back
	_wall(Vector3(t, 6.0, 47.0), Vector3(-16.5, 3.0, -23.5), ext)
	_wall(Vector3(t, 6.0, 47.0), Vector3(12.5, 3.0, -23.5), ext)
	_wall(Vector3(29.3, 6.0, t), Vector3(-2.0, 3.0, -47.0), ext)
	# roof slab and parapet, roof plant, the mast
	box(Vector3(29.3, 0.5, 47.0), Vector3(-2.0, 6.25, -23.5), ext)
	box(Vector3(29.6, 0.4, 0.4), Vector3(-2.0, 6.6, -0.2), _trim_m)
	for p: Vector3 in [Vector3(-6, 6.9, -10), Vector3(5, 6.9, -22), Vector3(-12, 6.9, -36), Vector3(8, 6.9, -40)]:
		box(Vector3(2.6, 1.4, 2.0), p, _steel)
		cyl(0.6, 0.6, 0.2, p + Vector3(0, 0.8, 0), mat(Color(0.2, 0.2, 0.22), 0.6, 0.3), 12)
	cyl(0.08, 0.1, 9.0, Vector3(9.5, 11.0, -30.0), _steel, 6)
	blinkers.append(box(Vector3(0.3, 0.3, 0.3), Vector3(9.5, 15.6, -30.0), glow(Color(1, 0.05, 0.05), 4.0)))
	# the interior ceilings: the lobby's, then the lower ward
	var ceil_m := mat(Color(0.8, 0.8, 0.78), 0.95)
	box(Vector3(22.0, 0.2, 11.4), Vector3(0, HL + 0.1, -6.3), ceil_m)
	box(Vector3(28.7, 0.2, 35.0), Vector3(-2.0, HC + 0.1, -29.5), ceil_m)
	# the floor: sealed concrete, grey, polished where feet go
	floor_quad(Vector2(28.7, 46.4), Vector3(-2.0, 0.0, -23.5), 0.0, _floor_m)
	solid_box(Vector3(30, 1, 48), Vector3(-2, -0.5, -23.5))
	# the lobby's west wall: beyond it, staff rooms nobody visits
	_wall(Vector3(0.2, HL, 11.4), Vector3(-11.0, HL / 2.0, -6.3))
	# the entrance: sliding glass in a steel frame, a canopy outside
	var glass := newmat(Color(0.7, 0.8, 0.85, 0.25), 0.05, 0.3)
	glass.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	glass.cull_mode = BaseMaterial3D.CULL_DISABLED
	for sd: float in [-1.0, 1.0]:
		var leaf := Node3D.new()
		leaf.position = Vector3(sd * 0.85, 0, -0.3)
		leaf.set_meta("side", sd)
		add_child(leaf)
		door_leaves.append(leaf)
		var g := box(Vector3(1.6, 2.4, 0.04), Vector3(0, 1.25, 0), glass, false, leaf)
		g.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		box(Vector3(0.05, 2.4, 0.08), Vector3(-sd * 0.78, 1.25, 0), _trim_m, false, leaf)
		box(Vector3(1.6, 0.05, 0.08), Vector3(0, 0.05, 0), _trim_m, false, leaf)
		for c in leaf.get_children():
			no_batch.append(c)
		box(Vector3(0.06, 2.5, 0.1), Vector3(sd * 1.68, 1.25, -0.3), _trim_m)
	box(Vector3(3.5, 0.1, 0.1), Vector3(0, 2.5, -0.3), _trim_m)
	_it("exit", Vector3(0, 1.25, -0.3), Vector3(3.3, 2.5, 0.3)).set_meta("exit", true)
	box(Vector3(7.0, 0.25, 3.5), Vector3(0, 3.3, 1.6), _trim_m)
	for sd: float in [-1.0, 1.0]:
		cyl(0.08, 0.08, 3.2, Vector3(sd * 3.2, 1.6, 3.2), _steel, 8)
	# SalTech over the door, and the only art: the logo
	box(Vector3(6.0, 1.0, 0.2), Vector3(0, 4.6, 0.0), mat(Color(0.12, 0.13, 0.15), 0.4, 0.4))
	neon_text(LINES["signs"]["facade"], Vector3(-0.2, 4.6, 0.12), 0.0, 0.62, Color(0.3, 0.95, 1.0), 2.6, self)
	neon_text(LINES["signs"]["facade2"], Vector3(0, 3.95, 0.12), 0.0, 0.22, Color(0.9, 0.9, 0.9), 1.8, self)
	# sand, blown in under the doors and drifted against the walls
	var sand := decal_mat(Tex.sand(), Color(1, 1, 1), 1.0)
	for i in 10:
		var p := Vector3(rng.randf_range(-2.5, 2.5), 0.004 + i * 0.0004, rng.randf_range(-3.0, -0.5))
		floor_quad(Vector2(1.0, 1.0) * rng.randf_range(0.6, 1.6), p, rng.randf() * TAU, sand)



## The south face, the only face anyone sees: strip windows of smoked
## glass, an ad screen, a blade sign on the corner, air-con units sweating
## down the concrete, an ambulance nobody has washed. "More factory than
## place of healing."
func _facade() -> void:
	var zf := -0.14
	var smoked := mat(Color(0.1, 0.13, 0.17), 0.12, 0.7)
	var rust := pbr("rust", Vector3(1, 1, 1) / 2.0, true, Color(0.7, 0.6, 0.5))
	var dark := mat(Color(0.12, 0.13, 0.15), 0.4, 0.4)
	# strip windows either side of the doors, mullioned, a sill under each
	for seg: Array in [[-15.6, -2.4], [2.4, 11.6]]:
		var x0: float = seg[0]
		var x1: float = seg[1]
		var w := x1 - x0
		var cx := (x0 + x1) / 2.0
		quad(Vector2(w, 1.1), Vector3(cx, 2.55, zf + 0.01), 0.0, smoked)
		box(Vector3(w + 0.2, 0.12, 0.3), Vector3(cx, 1.95, 0.0), _trim_m)
		box(Vector3(w + 0.2, 0.08, 0.16), Vector3(cx, 3.14, 0.0), _trim_m)
		var x := x0
		while x <= x1 + 0.01:
			box(Vector3(0.08, 1.1, 0.08), Vector3(x, 2.55, zf + 0.03), _trim_m)
			x += 1.5
		# condensation streaks below the sills
		for i in int(w / 2.5):
			var sx := x0 + 0.8 + i * 2.5 + rng.randf_range(-0.4, 0.4)
			box(Vector3(rng.randf_range(0.08, 0.2), rng.randf_range(0.6, 1.6), 0.01), Vector3(sx, 1.4, zf), rust)
	# upper band: a lighter course of concrete, stained where the roof leaks
	box(Vector3(29.4, 0.5, 0.06), Vector3(-2.0, 5.5, zf + 0.01), mat(Color(0.62, 0.6, 0.55), 0.95))
	for i in 7:
		var sx := rng.randf_range(-15.5, 11.5)
		box(Vector3(rng.randf_range(0.15, 0.4), rng.randf_range(0.8, 2.2), 0.01), Vector3(sx, 5.0 - rng.randf_range(0.0, 0.8), zf + 0.05), rust)
	# the SalTech ad screen on the east part of the face
	box(Vector3(6.4, 2.6, 0.3), Vector3(7.2, 4.3, 0.0), dark)
	var ad: Array = LINES["signs"]["screen_ad"]
	quad(Vector2(6.0, 2.2), Vector3(7.2, 4.3, 0.17), 0.0, glow(Color(0.12, 0.38, 0.4), 1.4, true)).cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	neon_text(ad[0], Vector3(7.2, 4.7, 0.2), 0.0, 0.7, Color(0.3, 0.95, 1.0), 2.6, self)
	neon_text(ad[1], Vector3(7.2, 3.85, 0.2), 0.0, 0.3, Color(1, 0.97, 0.92), 2.2, self)
	# EMERGENCY, red, pointing west round the building
	box(Vector3(4.4, 0.7, 0.2), Vector3(-9.0, 4.3, 0.0), dark)
	neon_text(LINES["signs"]["emergency"], Vector3(-9.0, 4.3, 0.12), 0.0, 0.4, Color(1.0, 0.15, 0.1), 3.0, self)
	# visiting hours by the door, a camera over it
	neon_text(LINES["signs"]["visiting"], Vector3(-3.6, 1.6, zf), 0.0, 0.13, Color(0.9, 0.9, 0.9), 1.2, self)
	box(Vector3(0.14, 0.14, 0.3), Vector3(2.0, 3.0, 0.0), dark)
	blinkers.append(box(Vector3(0.05, 0.05, 0.05), Vector3(2.0, 3.0, 0.16), glow(Color(1, 0.1, 0.1), 3.0)))
	# the blade sign on the south-east corner, lit both sides
	var vt := ""
	var bt: String = LINES["signs"]["blade"]
	for i in bt.length():
		vt += bt[i] + ("\n" if i < bt.length() - 1 else "")
	box(Vector3(1.4, 5.2, 0.3), Vector3(12.0, 3.6, 0.6), dark)
	box(Vector3(1.5, 0.08, 0.36), Vector3(12.0, 6.22, 0.6), glow(Color(0.3, 0.95, 1.0), 3.2, true))
	for sd: float in [-1.0, 1.0]:
		neon_text(vt, Vector3(12.0, 3.6, 0.6 + sd * 0.16), (0.0 if sd > 0 else PI), 0.62, Color(0.3, 0.95, 1.0), 2.6, self)
	# air-con units on brackets, a pipe run and a cable tray along the wall
	for ax: float in [-13.0, -6.0, 4.0, 10.5]:
		box(Vector3(0.9, 0.6, 0.45), Vector3(ax, 4.5, 0.25), _steel)
		box(Vector3(0.8, 0.04, 0.4), Vector3(ax, 4.5, 0.26), dark)
		box(Vector3(0.9, 0.06, 0.5), Vector3(ax, 4.18, 0.25), rust)
		box(Vector3(0.12, 1.2, 0.01), Vector3(ax + 0.2, 3.55, zf + 0.02), rust)
	cyl(0.05, 0.05, 29.0, Vector3(-2.0, 3.6, 0.03), _steel, 6).rotation.z = PI / 2.0
	box(Vector3(29.0, 0.1, 0.2), Vector3(-2.0, 5.9, 0.0), rust)
	# the kerb: bollards, a bench, a bin, a wheelchair somebody left out
	for bx: float in [-6.0, -3.0, 3.0, 6.0]:
		cyl(0.12, 0.12, 0.9, Vector3(bx, 0.45, 4.2), _steel, 8)
		solid_box(Vector3(0.3, 1.0, 0.3), Vector3(bx, 0.5, 4.2))
		box(Vector3(0.26, 0.1, 0.26), Vector3(bx, 0.85, 4.2), glow(Color(1.0, 0.8, 0.2), 1.5, true))
	box(Vector3(1.8, 0.06, 0.45), Vector3(-8.5, 0.5, 1.2), pbr("woodfloor", Vector3(1, 1, 1) / 1.5, true, Color(0.7, 0.6, 0.5)))
	box(Vector3(1.8, 0.4, 0.06), Vector3(-8.5, 0.8, 1.0), pbr("woodfloor", Vector3(1, 1, 1) / 1.5, true, Color(0.7, 0.6, 0.5)))
	for sd: float in [-1.0, 1.0]:
		box(Vector3(0.06, 0.5, 0.45), Vector3(-8.5 + sd * 0.85, 0.3, 1.2), _steel)
	solid_box(Vector3(1.9, 1.0, 0.5), Vector3(-8.5, 0.5, 1.2))
	cyl(0.3, 0.3, 0.9, Vector3(-10.5, 0.45, 1.3), dark, 10)
	cyl(0.32, 0.32, 0.08, Vector3(-10.5, 0.94, 1.3), _steel, 10)
	solid_box(Vector3(0.7, 1.0, 0.7), Vector3(-10.5, 0.5, 1.3))
	var chair := Node3D.new()
	chair.position = Vector3(8.2, 0, 1.4)
	chair.rotation.y = 0.9
	add_child(chair)
	box(Vector3(0.5, 0.05, 0.45), Vector3(0, 0.5, 0), mat(Color(0.1, 0.1, 0.12), 0.7), false, chair)
	box(Vector3(0.5, 0.5, 0.05), Vector3(0, 0.77, -0.22), mat(Color(0.1, 0.1, 0.12), 0.7), false, chair)
	for sd: float in [-1.0, 1.0]:
		cyl(0.3, 0.3, 0.03, Vector3(sd * 0.3, 0.3, -0.05), _steel, 12, chair).rotation.z = PI / 2.0
		cyl(0.09, 0.09, 0.03, Vector3(sd * 0.22, 0.09, 0.3), _steel, 8, chair).rotation.z = PI / 2.0
		box(Vector3(0.03, 0.4, 0.03), Vector3(sd * 0.25, 0.85, -0.22), _steel, false, chair)
	solid_box(Vector3(0.7, 1.0, 0.7), Vector3(0, 0.5, 0), chair)
	# the ambulance, parked under the EMERGENCY sign, unwashed
	var amb := Node3D.new()
	amb.position = Vector3(-14.5, 0, 7.0)
	amb.rotation.y = PI / 2.0
	add_child(amb)
	amb.add_child(Car.build(self, Color(0.9, 0.9, 0.86), {"van": true, "plate": "SLT 0108"}))
	solid_box(Vector3(2.2, 2.4, 5.2), Vector3(0, 1.2, 0), amb)
	for sd: float in [-1.0, 1.0]:
		neon_text(LINES["signs"]["ambulance"], Vector3(sd * 1.12, 1.5, 0.3), sd * PI / 2.0, 0.34, Color(0.1, 0.5, 0.6), 0.3, amb)
		box(Vector3(0.4, 0.35, 0.05), Vector3(sd * 1.12, 1.3, -1.2), mat(Color(0.85, 0.1, 0.1), 0.6), false, amb)
	box(Vector3(1.6, 0.18, 0.4), Vector3(0, 2.45, -1.6), glow(Color(0.2, 0.4, 1.0), 2.5), false, amb)
	# sand, drifted against the foot of the wall
	var dune := mat(Color(0.8, 0.68, 0.48), 1.0)
	for i in 9:
		var d := sphere(rng.randf_range(0.5, 1.3), Vector3(-15.0 + i * 3.1 + (3.0 if i > 4 else 0.0), 0.0, 0.25), dune, 8)
		d.scale = Vector3(1.6, 0.25, 0.6)

# ------------------------------------------------------------------ the lobby

func _lobby() -> void:
	# the north wall: the ward door at x -8, the corridor mouth at 0, the
	# staff door at x 8
	_wall(Vector3(2.1, HL, 0.2), Vector3(-9.95, HL / 2.0, -12.0))
	_wall(Vector3(5.4, HL, 0.2), Vector3(-4.4, HL / 2.0, -12.0))
	_wall(Vector3(1.8, HL - 2.2, 0.2), Vector3(-8.0, 2.2 + (HL - 2.2) / 2.0, -12.0))
	_wall(Vector3(3.4, HL - 2.4, 0.2), Vector3(0, 2.4 + (HL - 2.4) / 2.0, -12.0))
	_wall(Vector3(5.7, HL, 0.2), Vector3(4.55, HL / 2.0, -12.0))
	_wall(Vector3(1.0, HL - 2.1, 0.2), Vector3(7.9, 2.1 + (HL - 2.1) / 2.0, -12.0))
	_wall(Vector3(2.6, HL, 0.2), Vector3(9.7, HL / 2.0, -12.0))
	for x: float in [-8.9, -7.1, -1.7, 1.7, 7.4, 8.4]:
		box(Vector3(0.1, 2.4, 0.3), Vector3(x, 1.2, -12.0), _trim_m)
	# the ward's double doors, pinned open into the ward
	_door("warda_l", Vector3(-8.9, 0, -12.0), 0.0, 0.9, -1.5, true)
	_door("warda_r", Vector3(-7.1, 0, -12.0), PI, 0.9, 1.5, true)
	# the staff door, a badge reader beside it that nobody uses
	_door("staff", Vector3(8.4, 0, -12.0), PI, 1.0, 1.6, false, false)
	neon_text(LINES["signs"]["staff"], Vector3(7.9, 2.35, -11.85), 0.0, 0.08, Color(0.9, 0.3, 0.2), 1.6, self)
	_reader(Vector3(9.0, 1.2, -11.87), 0.0)
	_hack("staff_reader", Vector3(9.0, 1.2, -11.85), Vector3(0.2, 0.3, 0.1), "BADGE READER - STAFF 1\nlast badge: 06:02 (ORDERLY)\nlock: DISENGAGED")
	# skirting, a grey band at hand height where trolleys hit the plaster
	var band := mat(Color(0.5, 0.52, 0.54), 0.6)
	box(Vector3(22.0, 0.08, 0.04), Vector3(0, 0.9, -11.88), band)
	box(Vector3(0.04, 0.08, 11.4), Vector3(-10.88, 0.9, -6.3), band)
	box(Vector3(0.04, 0.08, 11.4), Vector3(12.3, 0.9, -6.3), band)
	# ceiling panels: cool white with a green cast, one that can't decide
	var panel := glow(Color(0.85, 1.0, 0.92), 1.6, true)
	for x: float in [-7.5, -2.5, 2.5, 7.5]:
		for z: float in [-3.0, -9.0]:
			var pn := box(Vector3(1.2, 0.04, 0.6), Vector3(x, HL - 0.02, z), panel)
			var lt := light(Vector3(x, HL - 0.4, z), Color(0.82, 0.95, 0.88), 1.1, 7.0)
			if x > 7.0 and z < -8.0:
				flickers.append(pn)
				no_batch.append(pn)
				panel_flicker = lt
	# signage: unlit plastic, the way SalTech does it
	var sign_m := mat(Color(0.14, 0.15, 0.17), 0.5)
	box(Vector3(2.6, 0.5, 0.06), Vector3(0, 2.75, -11.87), sign_m)
	neon_text(LINES["signs"]["ward"], Vector3(0, 2.75, -11.83), 0.0, 0.17, Color(0.85, 0.9, 0.9), 1.6, self)
	box(Vector3(1.6, 0.4, 0.06), Vector3(-8.0, 2.65, -11.87), sign_m)
	neon_text(LINES["signs"]["warda"], Vector3(-8.0, 2.65, -11.83), 0.0, 0.17, Color(0.85, 0.9, 0.9), 1.6, self)
	box(Vector3(2.2, 0.5, 0.06), Vector3(DESK.x, 2.75, -11.87), sign_m)
	neon_text(LINES["signs"]["reception"], Vector3(DESK.x, 2.75, -11.83), 0.0, 0.22, Color(0.3, 0.95, 1.0), 2.0, self)
	# the restricted wing's gate across the corridor mouth: double doors
	# with slots of dark glass, a reader, a speaker grille, and over it
	# all a camera dome with its ring lit. Tier 3. Four ways past it.
	_door("wing_l", Vector3(-1.7, 0, -12.0), 0.0, 1.7, 1.5, false, true)
	_door("wing_r", Vector3(1.7, 0, -12.0), PI, 1.7, -1.5, false, true)
	box(Vector3(3.4, 0.32, 0.12), Vector3(0, 2.24, -12.0), _door_m)
	neon_text(LINES["signs"]["wing"], Vector3(0, 2.3, -11.93), 0.0, 0.18, Color(1.0, 0.25, 0.15), 2.2, self)
	neon_text(LINES["signs"]["wing2"], Vector3(0, 2.12, -11.93), 0.0, 0.075, Color(0.9, 0.9, 0.9), 1.2, self)
	wing_reader_light = _reader(Vector3(2.1, 1.2, -11.87), 0.0)
	_hack("wing_reader", Vector3(2.1, 1.2, -11.85), Vector3(0.2, 0.3, 0.1), "BADGE READER - WING\nlock: ENGAGED\naccepts: SALTECH, PSYONIC (LOGGED)")
	box(Vector3(0.14, 0.14, 0.03), Vector3(2.1, 1.55, -11.87), mat(Color(0.2, 0.2, 0.22), 0.5, 0.3))
	for i in 3:
		box(Vector3(0.1, 0.01, 0.01), Vector3(2.1, 1.51 + i * 0.03, -11.85), mat(Color(0.05, 0.05, 0.06), 0.5))
	box(Vector3(0.02, 0.02, 0.01), Vector3(2.1, 1.62, -11.85), glow(Color(0.3, 0.9, 1.0), 2.0, true))
	_hack("speaker", Vector3(2.1, 1.55, -11.85), Vector3(0.2, 0.2, 0.1), "DOOR SPEAKER - WING\nasks: NAME, PURPOSE\nreports to: SECURITY DESK")
	sphere(0.12, Vector3(2.4, HL - 0.08, -11.5), mat(Color(0.05, 0.05, 0.06), 0.1, 0.5), 10).scale = Vector3(1, 0.6, 1)
	var ring := TorusMesh.new()
	ring.inner_radius = 0.1
	ring.outer_radius = 0.13
	ring.rings = 16
	ring.ring_segments = 5
	cam_ring = mesh(ring, Vector3(2.4, HL - 0.03, -11.5), glow(Color(0.3, 0.9, 1.0), 1.5, true))
	no_batch.append(cam_ring)
	_hack("camera", Vector3(2.4, HL - 0.1, -11.5), Vector3(0.4, 0.3, 0.4), "SALTECH CAM L-2\nfeed: SECURITY DESK\nfaces today: 1 (DRAKE, C.)")
	# a wall screen above reception running the SalTech ad on a loop
	box(Vector3(3.2, 1.9, 0.08), Vector3(-3.0, 2.0, -11.86), mat(Color(0.03, 0.03, 0.03), 0.2, 0.4))
	quad(Vector2(3.0, 1.7), Vector3(-3.0, 2.0, -11.81), 0.0, glow(Color(0.08, 0.3, 0.32), 1.3, true))
	neon_text(LINES["signs"]["ad_title"], Vector3(-3.0, 2.3, -11.78), 0.0, 0.5, Color(0.4, 1.0, 1.0), 2.4, self)
	neon_text(LINES["signs"]["ad_tag"], Vector3(-3.0, 1.72, -11.78), 0.0, 0.17, Color(0.95, 0.95, 0.9), 2.0, self)
	_it("ad", Vector3(-3.0, 2.0, -11.8), Vector3(3.2, 1.9, 0.2), "SALTECH DISPLAY 2\nloop: BRAND (14s)\naudience: 0 LOOKING")
	# a dead screen on the west wall: black glass and your own reflection
	box(Vector3(0.08, 1.2, 2.0), Vector3(-10.86, 1.9, -3.0), mat(Color(0.02, 0.02, 0.025), 0.1, 0.5))
	_it("dead", Vector3(-10.8, 1.9, -3.0), Vector3(0.2, 1.2, 2.0), "SALTECH DISPLAY 1\nstatus: NO SIGNAL\nsince: 3 DAYS")
	# the smart stuff that stopped: a hand-sanitiser pedestal that doesn't,
	# a water cooler, a vending machine with the lights out
	var ped := mat(Color(0.8, 0.8, 0.78), 0.5)
	cyl(0.14, 0.18, 1.1, Vector3(2.6, 0.55, -2.0), ped, 10)
	box(Vector3(0.2, 0.25, 0.18), Vector3(2.6, 1.22, -2.0), ped)
	box(Vector3(0.02, 0.02, 0.02), Vector3(2.6, 1.3, -2.1), glow(Color(1, 0.2, 0.1), 2.0))
	_it("sanitiser", Vector3(2.6, 0.8, -2.0), Vector3(0.4, 1.4, 0.4), "SALTECH HYGIENE POINT\nreservoir: EMPTY\nhands counted today: 0")
	box(Vector3(0.9, 1.9, 0.7), Vector3(11.8, 0.95, -1.5), mat(Color(0.2, 0.22, 0.26), 0.4, 0.3), true)
	box(Vector3(0.7, 1.1, 0.04), Vector3(11.8, 1.15, -1.13), mat(Color(0.05, 0.05, 0.06), 0.1, 0.5))
	neon_text(LINES["signs"]["nixtra"], Vector3(11.8, 1.8, -1.12), 0.0, 0.14, Color(0.35, 0.35, 0.4), 0.3, self)
	_hack("vending", Vector3(11.8, 1.0, -1.1), Vector3(0.9, 1.9, 0.2), "NIXTRA VEND 11\nstock: CALM (0)  FOCUS (0)  WATER (0)\npower: SAVING")
	box(Vector3(0.36, 1.0, 0.36), Vector3(-10.5, 0.5, -10.0), _white, true)
	cyl(0.17, 0.17, 0.5, Vector3(-10.5, 1.25, -10.0), newmat(Color(0.6, 0.8, 0.9, 0.5), 0.1), 10)
	# a plastic chair knocked over by the corridor mouth, nobody's picked it up
	var ch := _chair(Vector3(3.2, 0.0, -10.6), 1.3)
	ch.rotation = Vector3(0, 1.3, PI / 2.0)
	ch.position.y = 0.3


# ------------------------------------------------------------------ reception

func _reception() -> void:
	# a white counter, no one behind it: the bot stands at the end of it
	var counter := mat(Color(0.92, 0.92, 0.9), 0.4)
	box(Vector3(4.2, 1.1, 0.8), DESK + Vector3(0, 0.55, 0), counter, true)
	box(Vector3(4.3, 0.05, 0.9), DESK + Vector3(0, 1.12, 0), mat(Color(0.25, 0.26, 0.28), 0.3, 0.2))
	box(Vector3(4.2, 0.12, 0.04), DESK + Vector3(0, 0.2, 0.42), mat(Color(0.3, 0.95, 1.0), 0.4))
	# the reception bot: a white column with a face screen on a neck, and
	# the immediate help button on its chest, red, under a little hood
	var bot := Node3D.new()
	bot.position = DESK + Vector3(-1.1, 0, -0.9)
	add_child(bot)
	var shell := mat(Color(0.93, 0.94, 0.95), 0.35)
	cyl(0.3, 0.36, 0.1, Vector3(0, 0.05, 0), _trim_m, 14, bot)
	cyl(0.2, 0.26, 1.2, Vector3(0, 0.7, 0), shell, 14, bot)
	box(Vector3(0.5, 0.5, 0.36), Vector3(0, 1.45, 0), shell, false, bot)
	cyl(0.05, 0.05, 0.15, Vector3(0, 1.77, 0), _trim_m, 8, bot)
	bot_head = Node3D.new()
	bot_head.position = Vector3(0, 1.98, 0)
	bot.add_child(bot_head)
	box(Vector3(0.42, 0.3, 0.12), Vector3(0, 0, 0), shell, false, bot_head)
	quad(Vector2(0.36, 0.24), Vector3(0, 0, -0.065), 0.0, glow(Color(0.2, 0.9, 1.0), 1.4, true), bot_head)
	_bot_face(bot_head, Vector3(0, 0, -0.07), 1.0)
	box(Vector3(0.09, 0.09, 0.04), Vector3(0, 1.5, -0.2), glow(Color(1.0, 0.1, 0.08), 2.4, true), false, bot)
	box(Vector3(0.14, 0.04, 0.08), Vector3(0, 1.58, -0.2), _trim_m, false, bot)
	neon_text(LINES["signs"]["help"], Vector3(0, 1.4, -0.19), 0.0, 0.03, Color(0.9, 0.9, 0.9), 1.4, bot)
	_hack("bot", Vector3(0, 1.0, 0), Vector3(0.7, 2.2, 0.7), "SALTECH RECEPTION UNIT 3\nmood: CHEERFUL (LOCKED)\nvisitors expected: DRAKE, C.", bot)
	_it("button", Vector3(0, 1.5, -0.26), Vector3(0.2, 0.2, 0.1), "", false, bot)
	# the white plastic table of screens, each with the same bot on it
	var tbl := Vector3(5.5, 0.0, -8.6)
	box(Vector3(2.6, 0.05, 0.9), tbl + Vector3(0, 0.74, 0), mat(Color(0.95, 0.95, 0.93), 0.3), true)
	for sx: float in [-1.1, 1.1]:
		box(Vector3(0.06, 0.72, 0.8), tbl + Vector3(sx, 0.36, 0), mat(Color(0.95, 0.95, 0.93), 0.3))
	for i in 5:
		var sp := tbl + Vector3(-1.0 + i * 0.5, 0.98, 0.1)
		box(Vector3(0.4, 0.3, 0.03), sp, mat(Color(0.05, 0.05, 0.06), 0.2, 0.4))
		cyl(0.02, 0.05, 0.2, sp + Vector3(0, -0.2, 0.02), _trim_m, 6)
		if i == 3:
			# this one's bot has been replaced by something with an iris
			var em := newmat(Color(1, 1, 1), 0.5)
			em.albedo_texture = Tex.eye()
			em.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
			em.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			var q := quad(Vector2(0.26, 0.26), sp + Vector3(0, 0, 0.02), 0.0, em)
			flickers.append(q)
			no_batch.append(q)
			light(sp + Vector3(0, 0.1, 0.4), Color(0.9, 0.3, 0.2), 0.3, 1.2)
		else:
			quad(Vector2(0.36, 0.26), sp + Vector3(0, 0, 0.02), 0.0, glow(Color(0.2, 0.9, 1.0), 1.1, true))
			_bot_face(self, sp + Vector3(0, 0, 0.025), 0.75)
	_hack("screens", tbl + Vector3(0, 1.0, 0.1), Vector3(2.6, 0.5, 0.3), "SALTECH RECEPTION UNITS 4-8\nmood: CHEERFUL\nnote: unit 7 reports NO FACE")
	light(tbl + Vector3(0, 1.3, 0.6), Color(0.3, 0.8, 1.0), 0.5, 3.0)


## Two dots and a smile in dark pixels on a cyan screen.
func _bot_face(parent: Node, at: Vector3, s: float) -> void:
	var ink := mat(Color(0.02, 0.08, 0.1), 0.6)
	for sx: float in [-0.07, 0.07]:
		box(Vector3(0.03, 0.04, 0.005) * s, at + Vector3(sx * s, 0.04 * s, 0), ink, false, parent)
	box(Vector3(0.12, 0.018, 0.005) * s, at + Vector3(0, -0.05 * s, 0), ink, false, parent)
	for sx: float in [-0.075, 0.075]:
		box(Vector3(0.02, 0.03, 0.005) * s, at + Vector3(sx * s, -0.035 * s, 0), ink, false, parent)


# ------------------------------------------------------------------ the waiting area

func _waiting() -> void:
	# three rows of chairs facing the doors, bolted to a rail
	for row in 3:
		var z := WAIT.z + 2.2 - row * 1.6
		box(Vector3(3.4, 0.06, 0.06), Vector3(WAIT.x, 0.4, z + 0.2), _steel)
		for i in 5:
			var x := WAIT.x - 1.4 + i * 0.7
			_chair(Vector3(x, 0, z), PI)
	# a low table with nothing on it but a sand-clogged charging pad
	box(Vector3(0.9, 0.04, 0.5), Vector3(WAIT.x + 3.0, 0.42, WAIT.z), mat(Color(0.95, 0.95, 0.93), 0.3), true)
	for sx: float in [-0.4, 0.4]:
		box(Vector3(0.05, 0.4, 0.45), Vector3(WAIT.x + 3.0 + sx, 0.2, WAIT.z), mat(Color(0.95, 0.95, 0.93), 0.3))
	cyl(0.08, 0.08, 0.01, Vector3(WAIT.x + 3.0, 0.445, WAIT.z), mat(Color(0.1, 0.1, 0.12), 0.4, 0.4), 12)
	floor_quad(Vector2(0.4, 0.4), Vector3(WAIT.x + 3.0, 0.45, WAIT.z), 0.4, decal_mat(Tex.sand(), Color(1, 1, 1), 1.0))
	_it("patients", Vector3(WAIT.x, 1.0, WAIT.z + 0.4), Vector3(3.6, 1.8, 3.6))
	# a take-a-number dispenser, number 1, same number since the bots came
	box(Vector3(0.18, 0.24, 0.12), Vector3(DESK.x + 1.8, 1.28, DESK.z + 0.3), mat(Color(0.85, 0.2, 0.15), 0.4))
	neon_text(LINES["signs"]["number"], Vector3(DESK.x + 1.8, 1.28, DESK.z + 0.37), 0.0, 0.07, Color(1, 1, 1), 1.2, self)


# ------------------------------------------------------------------ FreudBot booths

func _booths() -> void:
	# three booths along the east wall: a chair, a screen, a curtain that
	# doesn't close. FreudBot is programmed for therapeutic dialogue.
	var booth_m := mat(Color(0.5, 0.56, 0.66), 0.6)
	var cur := pbr("fabric", Vector3(1, 1, 1) / 1.0, true, Color(0.45, 0.5, 0.62))
	for i in 3:
		var z := -4.0 - i * 2.6
		var o := Vector3(BOOTHS_X + 0.8, 0, z)
		box(Vector3(1.4, 2.4, 0.08), o + Vector3(0, 1.2, -1.2), booth_m, true)
		box(Vector3(1.4, 2.4, 0.08), o + Vector3(0, 1.2, 1.2), booth_m, true)
		box(Vector3(1.4, 0.1, 2.5), o + Vector3(0, 2.4, 0), booth_m)
		var on := i != 2
		var sc := glow(Color(0.25, 0.45, 1.0), 1.5, true) if on else mat(Color(0.03, 0.03, 0.04), 0.1, 0.5)
		box(Vector3(0.08, 0.7, 1.0), o + Vector3(0.6, 1.5, 0), mat(Color(0.05, 0.05, 0.06), 0.3, 0.4))
		quad(Vector2(0.9, 0.6), o + Vector3(0.55, 1.5, 0), -PI / 2.0, sc)
		if on:
			neon_text(LINES["signs"]["freud"], o + Vector3(0.53, 1.62, 0), -PI / 2.0, 0.1, Color(0.8, 0.9, 1.0), 2.0, self)
			neon_text(LINES["signs"]["freud_tag"], o + Vector3(0.53, 1.44, 0), -PI / 2.0, 0.045, Color(0.8, 0.9, 1.0), 1.6, self)
			light(o + Vector3(0.2, 1.5, 0), Color(0.3, 0.5, 1.0), 0.6, 2.6)
		else:
			neon_text(LINES["signs"]["freud_out"], o + Vector3(0.53, 1.5, 0), -PI / 2.0, 0.06, Color(0.9, 0.3, 0.2), 1.6, self)
		_chair(o + Vector3(-0.1, 0, 0), -PI / 2.0, Color(0.3, 0.32, 0.4))
		var c := box(Vector3(0.04, 2.2, 1.0), o + Vector3(-0.72, 1.15, 0.75), cur)
		c.rotation.y = 0.25
		cyl(0.015, 0.015, 1.5, o + Vector3(-0.72, 2.3, 0.5), _steel, 6).rotation.x = PI / 2.0
	_hack("freudbot", Vector3(BOOTHS_X + 0.6, 1.2, -6.6), Vector3(1.2, 2.2, 7.6), "FREUDBOT CONSOLE L-1\nsessions today: 3\nbreakthroughs: 0")
	neon_text(LINES["signs"]["freud_head"], Vector3(BOOTHS_X + 0.08, 2.75, -6.6), -PI / 2.0, 0.17, Color(0.85, 0.9, 0.9), 1.6, self)


# ------------------------------------------------------------------ the corridor

func _corridor() -> void:
	var zc := -25.0
	# the west wall is the ward's: double doors at z -25..-23
	_wall(Vector3(0.2, HC, 11.0), Vector3(-1.7, HC / 2.0, -17.5))
	_wall(Vector3(0.2, HC, 11.5), Vector3(-1.7, HC / 2.0, -30.75))
	_wall(Vector3(0.2, HC, 0.5), Vector3(-1.7, HC / 2.0, -37.75))
	_wall(Vector3(0.2, HC - 2.1, 1.0), Vector3(-1.7, 2.1 + (HC - 2.1) / 2.0, -37.0))
	_wall(Vector3(0.2, HC - 2.2, 2.0), Vector3(-1.7, 2.2 + (HC - 2.2) / 2.0, -24.0))
	_door("ward_l", Vector3(-1.7, 0, -25.0), -PI / 2.0, 1.0, -1.6, false, true)
	_door("ward_r", Vector3(-1.7, 0, -23.0), PI / 2.0, 1.0, 1.6, false, true)
	_reader(Vector3(-1.58, 1.2, -22.4), PI / 2.0)
	neon_text(LINES["signs"]["warda"], Vector3(-1.58, 2.45, -24.0), PI / 2.0, 0.12, Color(0.85, 0.9, 0.9), 1.6, self)
	# the east wall: rooms 101-105, three of them you can open
	var ez := [[-12.0, -14.25], [-15.25, -19.5], [-20.5, -23.25], [-24.25, -27.75], [-28.75, -32.25], [-33.25, -38.0]]
	for seg: Array in ez:
		var a := float(seg[0])
		var b := float(seg[1])
		_wall(Vector3(0.2, HC, absf(b - a)), Vector3(1.7, HC / 2.0, (a + b) / 2.0))
	for z: float in [-14.75, -20.0, -23.75, -28.25, -32.75]:
		_wall(Vector3(0.2, HC - 2.1, 1.0), Vector3(1.7, 2.1 + (HC - 2.1) / 2.0, z))
	_door("101", Vector3(1.7, 0, -14.25), PI / 2.0, 1.0, 0.0, false, true, "101")
	_door("102", Vector3(1.7, 0, -19.5), PI / 2.0, 1.0, -1.7, false, false, "102")
	_door("103", Vector3(1.7, 0, -23.25), PI / 2.0, 1.0, -0.6, true, false, "103")
	_door("104", Vector3(1.7, 0, -27.75), PI / 2.0, 1.0, -1.7, false, false, "104")
	_door("105", Vector3(1.7, 0, -32.25), PI / 2.0, 1.0, 0.0, false, true, "105")
	_door("107", Vector3(-1.7, 0, -36.5), PI / 2.0, 1.0, 0.0, false, true, "107")
	# the end wall, with Room 108's door in it
	_wall(Vector3(1.1, HC, 0.3), Vector3(-1.15, HC / 2.0, DOOR_Z))
	_wall(Vector3(1.1, HC, 0.3), Vector3(1.15, HC / 2.0, DOOR_Z))
	_wall(Vector3(1.2, HC - 2.1, 0.3), Vector3(0, 2.1 + (HC - 2.1) / 2.0, DOOR_Z))
	# the floor's centre line: a strip of painted arrows to the ward
	var strip := mat(Color(0.3, 0.6, 0.65), 0.6)
	for z in range(-14, -37, -3):
		box(Vector3(0.06, 0.004, 1.4), Vector3(0, 0.003, float(z)), strip)
	var band := mat(Color(0.5, 0.52, 0.54), 0.6)
	for sx: float in [-1.6, 1.6]:
		box(Vector3(0.04, 0.08, 26.0), Vector3(sx, 0.9, zc), band)
		box(Vector3(0.05, 0.05, 26.0), Vector3(sx, 1.0, zc), _steel)  # handrail
	# strip lights every three metres, one of them dying
	var tube := glow(Color(0.85, 1.0, 0.92), 1.6, true)
	for z in range(-14, -37, -3):
		var t := box(Vector3(0.14, 0.04, 1.2), Vector3(0, HC - 0.02, float(z)), tube)
		light(Vector3(0, HC - 0.4, float(z)), Color(0.82, 0.95, 0.88), 0.85, 5.0)
		if z == -32:
			flickers.append(t)
			no_batch.append(t)
	# Room 108's door, hinged east, closed until the nurse opens it
	door108 = Node3D.new()
	door108.position = Vector3(0.6, 0, DOOR_Z)
	add_child(door108)
	var d108 := box(Vector3(1.2, 2.08, 0.06), Vector3(-0.6, 1.04, 0), _door_m, false, door108)
	no_batch.append(d108)
	var slot := box(Vector3(0.3, 0.3, 0.07), Vector3(-0.6, 1.5, 0), mat(Color(0.05, 0.05, 0.06), 0.1, 0.5), false, door108)
	no_batch.append(slot)
	var hdl := box(Vector3(0.12, 0.03, 0.04), Vector3(-1.05, 1.0, 0.05), _steel, false, door108)
	no_batch.append(hdl)
	door108_body = _it("door_108", Vector3(-0.6, 1.04, 0), Vector3(1.2, 2.08, 0.12), "", true, door108)
	neon_text("108", Vector3(0, 2.35, DOOR_Z + 0.16), 0.0, 0.14, Color(0.9, 0.9, 0.9), 1.4, self)
	neon_text(LINES["signs"]["name108"], Vector3(0.9, 1.5, DOOR_Z + 0.16), 0.0, 0.05, Color(0.9, 0.9, 0.9), 1.2, self)
	box(Vector3(0.6, 0.18, 0.02), Vector3(0.9, 1.5, DOOR_Z + 0.15), mat(Color(0.14, 0.15, 0.17), 0.5))
	# dead smart-hospital tech on the west wall: two wayfinding screens
	# with nothing on them, a direction sign hung from the ceiling
	var dead := mat(Color(0.06, 0.06, 0.07), 0.25, 0.5)
	for z: float in [-16.0, -29.0]:
		box(Vector3(0.05, 0.5, 0.8), Vector3(-1.57, 1.7, z), dead)
		quad(Vector2(0.72, 0.42), Vector3(-1.53, 1.7, z), PI / 2.0, glow(Color(0.03, 0.04, 0.05), 1.0, true))
		var sl := box(Vector3(0.01, 0.008, 0.7), Vector3(-1.52, 1.7 + rng.randf_range(-0.15, 0.15), z), glow(Color(0.4, 0.9, 1.0), 2.0, true))
		flickers.append(sl)
		no_batch.append(sl)
		neon_text(LINES["signs"]["nosignal"], Vector3(-1.51, 1.55, z), PI / 2.0, 0.04, Color(0.5, 0.55, 0.6), 1.0, self)
	for z: float in [-16.0, -27.0]:
		box(Vector3(0.04, 0.5, 0.04), Vector3(0, HC - 0.25, z), _steel)
		box(Vector3(1.1, 0.3, 0.06), Vector3(0, HC - 0.65, z), mat(Color(0.14, 0.15, 0.17), 0.5))
		for sd: float in [-1.0, 1.0]:
			neon_text(LINES["signs"]["dir108"], Vector3(0, HC - 0.65, z + sd * 0.035), (0.0 if sd > 0 else PI), 0.1, Color(0.9, 0.9, 0.9), 1.4, self)
	# posters on the east wall between the doors; a noticeboard, a fire
	# extinguisher, sanitiser by every door
	var pi: int = 0
	for z: float in [-17.5, -26.0]:
		var ad: Array = LINES["signs"]["poster1" if pi == 0 else "poster2"]
		pi += 1
		box(Vector3(0.03, 0.9, 0.65), Vector3(1.58, 1.6, z), mat(Color(0.95, 0.95, 0.93), 0.7))
		quad(Vector2(0.55, 0.55), Vector3(1.56, 1.72, z), -PI / 2.0, glow(Color(0.08, 0.3, 0.32), 0.9, true))
		neon_text(ad[0], Vector3(1.55, 1.3, z), -PI / 2.0, 0.07, Color(0.1, 0.4, 0.45), 1.0, self)
		neon_text(ad[1], Vector3(1.55, 1.2, z), -PI / 2.0, 0.04, Color(0.3, 0.3, 0.32), 1.0, self)
	box(Vector3(0.04, 0.7, 1.0), Vector3(-1.57, 1.5, -21.0), pbr("woodfloor", Vector3(1, 1, 1) / 1.5, true, Color(0.75, 0.65, 0.5)))
	var paper := decal_mat(Tex.paper(3), Color(0.95, 0.95, 0.9), 0.8)
	for i in 6:
		var pq := quad(Vector2(0.21, 0.28), Vector3(-1.54, 1.5 + rng.randf_range(-0.18, 0.18), -21.0 + rng.randf_range(-0.38, 0.38)), PI / 2.0, paper)
		pq.rotation.x = rng.randf_range(-0.08, 0.08)
	cyl(0.08, 0.08, 0.5, Vector3(1.52, 0.75, -31.25), mat(Color(0.8, 0.08, 0.06), 0.4, 0.4), 10)
	box(Vector3(0.1, 0.06, 0.2), Vector3(1.6, 0.75, -31.25), _steel)
	for z: float in [-13.75, -19.0, -22.75, -27.25, -31.75]:
		box(Vector3(0.1, 0.22, 0.12), Vector3(1.6, 1.2, z), _white)
		box(Vector3(0.06, 0.04, 0.08), Vector3(1.55, 1.1, z), dead)
	# a gurney nobody has taken back, along the west wall
	_bed(Vector3(-1.05, 0, -28.5), 0.0)
	# conduit along the ceiling, and sand in the corners
	cyl(0.04, 0.04, 26.0, Vector3(-1.4, HC - 0.1, zc), _steel, 6).rotation.x = PI / 2.0
	var sand := decal_mat(Tex.sand(), Color(1, 1, 1), 1.0)
	for i in 5:
		floor_quad(Vector2(0.6, 0.4) * rng.randf_range(0.6, 1.2), Vector3(-1.3 + (2.6 if i % 2 == 0 else 0.0), 0.004, -14.0 - i * 5.0), rng.randf() * TAU, sand)
	# a trolley of sheets left against the wall, a wheelchair, a
	# cleaning bot with its brush full of sand
	var tro := Vector3(1.2, 0, -30.0)
	box(Vector3(0.6, 0.05, 0.9), tro + Vector3(0, 0.85, 0), _steel, true)
	box(Vector3(0.6, 0.05, 0.9), tro + Vector3(0, 0.25, 0), _steel)
	for sx: float in [-0.27, 0.27]:
		for sz: float in [-0.42, 0.42]:
			cyl(0.012, 0.012, 0.85, tro + Vector3(sx, 0.55, sz), _steel, 5)
	for i in 4:
		box(Vector3(0.5, 0.06, 0.7), tro + Vector3(0, 0.91 + i * 0.06, rng.randf_range(-0.05, 0.05)), _white)
	var wc := Vector3(-1.2, 0, -34.0)
	box(Vector3(0.5, 0.05, 0.5), wc + Vector3(0, 0.5, 0), mat(Color(0.12, 0.12, 0.14), 0.5), true)
	box(Vector3(0.5, 0.5, 0.05), wc + Vector3(0, 0.78, 0.25), mat(Color(0.12, 0.12, 0.14), 0.5))
	for sx: float in [-0.3, 0.3]:
		var wh := cyl(0.3, 0.3, 0.03, wc + Vector3(sx, 0.3, 0.1), _steel, 14)
		wh.rotation.z = PI / 2.0
	sweeper = Node3D.new()
	sweeper.position = Vector3(0.6, 0, -21.5)
	add_child(sweeper)
	cyl(0.22, 0.24, 0.12, Vector3(0, 0.07, 0), mat(Color(0.15, 0.15, 0.17), 0.4, 0.4), 14, sweeper)
	box(Vector3(0.2, 0.02, 0.06), Vector3(0, 0.14, 0), mat(Color(0.95, 0.5, 0.1), 0.4), false, sweeper)
	box(Vector3(0.03, 0.01, 0.03), Vector3(0, 0.135, -0.18), glow(Color(0.2, 1.0, 0.4), 2.0), false, sweeper)
	_hack("sweeper", Vector3(0, 0.1, 0), Vector3(0.5, 0.25, 0.5), "VOLTX WARDBOT 2\ntask: SAND (ENDLESS)\nbattery: 9%", sweeper)


# ------------------------------------------------------------------ rooms 102, 103, 104

func _east_rooms() -> void:
	# partitions between the east rooms, and their shared back wall
	for z: float in [-17.0, -21.5, -26.0, -30.5]:
		_wall(Vector3(5.1, HC, 0.2), Vector3(4.25, HC / 2.0, z))
	_wall(Vector3(0.2, HC, 26.0), Vector3(6.8, HC / 2.0, -25.0))
	# 102: linen and the drug cabinet. Shelves floor to ceiling.
	var shelf := mat(Color(0.6, 0.62, 0.64), 0.5, 0.4)
	for y: float in [0.4, 0.9, 1.4, 1.9, 2.4]:
		box(Vector3(4.6, 0.04, 0.5), Vector3(4.4, y, -17.4), shelf)
		for i in 6:
			box(Vector3(0.5, 0.3, 0.42), Vector3(2.4 + i * 0.75, y + 0.17, -17.4), _white).rotation.y = rng.randf_range(-0.05, 0.05)
	_it("linen", Vector3(4.4, 1.4, -17.4), Vector3(4.6, 2.6, 0.5))
	box(Vector3(0.6, 1.6, 0.5), Vector3(6.45, 0.8, -20.5), mat(Color(0.85, 0.86, 0.88), 0.4, 0.3), true)
	quad(Vector2(0.3, 0.2), Vector3(6.14, 1.3, -20.5), -PI / 2.0, glow(Color(0.3, 0.9, 0.5), 1.2, true))
	_reader(Vector3(6.14, 0.9, -20.3), -PI / 2.0)
	_hack("cabinet", Vector3(6.3, 0.8, -20.5), Vector3(0.6, 1.6, 0.6), "SALTECH DRUG CABINET 2\nlock: BADGE\nCALM 2  QUIET 1  SLEEP 0")
	light(Vector3(4.4, HC - 0.4, -19.2), Color(0.85, 0.95, 0.9), 0.7, 4.5)
	# 103: ajar. Someone in the bed is sitting up, facing the door.
	var bp := Vector3(5.0, 0, -23.75)
	_bed(bp, -PI / 2.0)
	light(bp + Vector3(-0.5, 1.2, 0), Color(0.3, 0.5, 1.0), 0.45, 3.5)
	box(Vector3(0.04, 0.4, 0.6), bp + Vector3(1.0, 1.7, -0.9), mat(Color(0.05, 0.05, 0.06), 0.3, 0.4))
	quad(Vector2(0.55, 0.34), bp + Vector3(0.97, 1.7, -0.9), -PI / 2.0, glow(Color(0.25, 0.45, 1.0), 1.3, true))
	stick(bp + Vector3(1.05, 1.7, -0.9), bp + Vector3(1.75, 2.6, -0.9), 0.02, _steel)
	patient103 = figure(Color(0.72, 0.78, 0.82), Color(0.78, 0.66, 0.56), {"hair": Color(0.3, 0.3, 0.32), "legs": Color(0.72, 0.78, 0.82), "arms": true, "knees": true})
	_sit(patient103, bp + Vector3(0.5, 0, 0), PI / 2.0, 0.71, -0.15)
	for a in patient103.get_meta("arms"):
		(a as Node3D).rotation.x = 0.0
	ward_people.append(patient103)
	# 104: stripped to the frame. The stain on the floor, the FreudBot
	# left on, a mop bucket nobody finished with.
	var sp := Vector3(5.0, 0, -28.25)
	_bed(sp, -PI / 2.0, false)
	floor_quad(Vector2(1.6, 0.8), sp + Vector3(0, 0.012, 0), 0.0, decal_mat(Tex.blood(31), Color(0.75, 0.7, 0.66), 0.5))
	_it("stripped", sp + Vector3(0, 0.3, 0), Vector3(2.0, 0.6, 1.0))
	cyl(0.2, 0.17, 0.35, sp + Vector3(-1.4, 0.18, 1.5), mat(Color(0.85, 0.75, 0.2), 0.5), 10)
	stick(sp + Vector3(-1.3, 0.3, 1.5), sp + Vector3(-1.5, 1.6, 1.3), 0.015, mat(Color(0.5, 0.35, 0.2), 0.8))
	box(Vector3(0.04, 0.4, 0.6), sp + Vector3(1.0, 1.7, 0.9), mat(Color(0.05, 0.05, 0.06), 0.3, 0.4))
	quad(Vector2(0.55, 0.34), sp + Vector3(0.97, 1.7, 0.9), -PI / 2.0, glow(Color(0.25, 0.45, 1.0), 1.3, true))
	stick(sp + Vector3(1.05, 1.7, 0.9), sp + Vector3(1.75, 2.6, 0.9), 0.02, _steel)
	_hack("freud104", sp + Vector3(1.0, 1.7, 0.9), Vector3(0.3, 0.5, 0.7), "FREUDBOT ARM 104\nsession: OPEN\nparticipant: NONE (3 DAYS)")
	light(sp + Vector3(0, 1.4, 0.5), Color(0.3, 0.5, 1.0), 0.5, 4.0)
	# a scrap of daylight on each back wall: a high window, blinds down
	for z: float in [-19.25, -23.75, -28.25]:
		var leak := glow(Color(1.0, 0.97, 0.9), 2.4)
		for i in 8:
			box(Vector3(0.005, 0.006, 1.0), Vector3(6.69, 1.6 + i * 0.07, z), leak)
		box(Vector3(0.03, 0.7, 1.1), Vector3(6.7, 1.85, z), mat(Color(0.86, 0.87, 0.85), 0.7))


# ------------------------------------------------------------------ Ward A

func _ward() -> void:
	# the big room west of the corridor: twelve beds, curtains, a nurses'
	# station, blinds half down on the west wall. Everyone in here hums.
	_wall(Vector3(5.5, HC, 0.2), Vector3(-13.75, HC / 2.0, -12.0))
	_wall(Vector3(14.8, HC, 0.2), Vector3(-9.1, HC / 2.0, -34.0))
	var cur := pbr("fabric", Vector3(1, 1, 1) / 1.0, true, Color(0.6, 0.72, 0.7))
	for side: float in [-1.0, 1.0]:
		for i in 6:
			var z := -15.5 - i * 3.3
			var x := -14.4 if side < 0.0 else -3.8
			var bp := Vector3(x, 0, z)
			_bed(bp, PI)
			# curtain rail and a curtain, pulled across on some of them
			stick(bp + Vector3(-1.2 * side, HC - 0.15, -1.3), bp + Vector3(-1.2 * side, HC - 0.15, 1.3), 0.015, _steel)
			stick(bp + Vector3(-1.2 * side, HC - 0.15, 1.3), bp + Vector3(1.3 * side, HC - 0.15, 1.3), 0.015, _steel)
			if i % 2 == 0:
				var c := box(Vector3(0.04, 2.2, 2.4), bp + Vector3(-1.2 * side, 1.25, 0.1), cur)
				c.rotation.y = 0.04
			else:
				box(Vector3(0.04, 2.2, 0.7), bp + Vector3(-1.2 * side, 1.25, 1.0), cur)
			# a chart at the foot, a locker at the head
			box(Vector3(0.25, 0.32, 0.02), bp + Vector3(0, 0.75, 1.1), _white)
			box(Vector3(0.45, 0.8, 0.45), bp + Vector3(0.9 * side, 0.4, -0.8), mat(Color(0.8, 0.8, 0.78), 0.5), true)
	# the people in the beds: three under sheets, two sitting up
	var sheet := pbr("fabric", Vector3(1, 1, 1) / 1.0, true, Color(0.8, 0.82, 0.8))
	var skins := [Color(0.85, 0.66, 0.52), Color(0.6, 0.42, 0.3), Color(0.92, 0.78, 0.66), Color(0.45, 0.3, 0.22)]
	var lying := [[-14.4, -15.5], [-14.4, -22.1], [-3.8, -28.7]]
	for i in lying.size():
		var bp := Vector3(float(lying[i][0]), 0, float(lying[i][1]))
		var f := figure(Color(0.72, 0.78, 0.82), skins[i], {"hair": Color(0.2, 0.15, 0.1), "legs": Color(0.72, 0.78, 0.82), "arms": true, "knees": true})
		_lay(f, bp, PI)
		add_child(f)
		ward_people.append(f)
		box(Vector3(0.95, 0.03, 1.3), bp + Vector3(0, 0.97, -0.3), sheet)
		_it("wardbed", bp + Vector3(0, 0.9, 0), Vector3(1.1, 0.6, 2.0))
	var sitting := [[-14.4, -28.7], [-3.8, -18.8]]
	for i in sitting.size():
		var bp := Vector3(float(sitting[i][0]), 0, float(sitting[i][1]))
		var f := figure(Color(0.72, 0.78, 0.82), skins[(i + 2) % 4], {"hair": Color(0.5, 0.5, 0.5), "long_hair": i == 0, "legs": Color(0.72, 0.78, 0.82), "arms": true, "knees": true})
		_sit(f, bp + Vector3(0, 0, 0.5), 0.0, 0.71, -0.15)
		for a in f.get_meta("arms"):
			(a as Node3D).rotation.x = 0.0
		ward_people.append(f)
		_it("wardsit", bp + Vector3(0, 0.9, 0.3), Vector3(1.1, 1.2, 1.4))
	# the nurses' station in the middle: a counter, a screen, nobody
	var st := Vector3(-9.0, 0, -15.5)
	box(Vector3(3.0, 1.1, 0.8), st + Vector3(0, 0.55, 0), mat(Color(0.92, 0.92, 0.9), 0.4), true)
	box(Vector3(3.1, 0.05, 0.9), st + Vector3(0, 1.12, 0), mat(Color(0.25, 0.26, 0.28), 0.3, 0.2))
	box(Vector3(0.5, 0.34, 0.03), st + Vector3(0.6, 1.35, -0.2), mat(Color(0.05, 0.05, 0.06), 0.2, 0.4))
	quad(Vector2(0.46, 0.3), st + Vector3(0.6, 1.35, -0.18), 0.0, glow(Color(0.3, 0.6, 0.6), 1.3, true))
	neon_text(LINES["signs"]["station"], st + Vector3(0, 1.9, 0.0), 0.0, 0.12, Color(0.85, 0.9, 0.9), 1.6, self)
	_hack("station", st + Vector3(0.6, 1.35, -0.2), Vector3(0.6, 0.5, 0.3), "SALTECH WARD TERMINAL A\ncharts: 16\nnote on all: HUMMING")
	# the west wall: windows, blinds half down, bars of midday on the floor
	var bl := mat(Color(0.86, 0.87, 0.85), 0.7)
	var leak := glow(Color(1.0, 0.97, 0.9), 2.6)
	for i in 4:
		var z := -16.0 - i * 5.0
		for k in 12:
			var s := box(Vector3(0.02, 0.055, 2.2), Vector3(-16.3, 1.3 + k * 0.07, z), bl)
			s.rotation.z = -0.5
		box(Vector3(0.04, 0.08, 2.3), Vector3(-16.3, 2.5, z), _trim_m)
		for k in 11:
			box(Vector3(0.005, 0.006, 2.15), Vector3(-16.28, 1.335 + k * 0.07, z), leak)
		quad(Vector2(2.2, 0.9), Vector3(-16.28, 2.05, z), PI / 2.0, glow(Color(1.0, 0.96, 0.85), 1.8))
		light(Vector3(-15.0, 1.9, z), Color(1.0, 0.95, 0.85), 0.8, 5.0, false)
		floor_quad(Vector2(1.8, 2.0), Vector3(-14.4, 0.004, z), 0.0, glow(Color(0.6, 0.55, 0.45), 0.6))
	_it("blinds_ward", Vector3(-16.2, 1.8, -21.0), Vector3(0.2, 1.6, 2.2))
	# ceiling lights, cold, and a FreudBot cart parked between the rows
	var tube := glow(Color(0.85, 1.0, 0.92), 1.4, true)
	for z: float in [-15.5, -21.0, -26.5, -32.0]:
		box(Vector3(1.2, 0.04, 0.14), Vector3(-9.0, HC - 0.02, z), tube)
		light(Vector3(-9.0, HC - 0.4, z), Color(0.82, 0.95, 0.88), 0.9, 6.5)
	var cart := Vector3(-9.0, 0, -25.0)
	box(Vector3(0.5, 0.05, 0.5), cart + Vector3(0, 0.6, 0), _steel, true)
	for sx: float in [-0.2, 0.2]:
		for sz: float in [-0.2, 0.2]:
			cyl(0.012, 0.012, 0.6, cart + Vector3(sx, 0.3, sz), _steel, 5)
	box(Vector3(0.4, 0.3, 0.04), cart + Vector3(0, 0.95, 0), mat(Color(0.05, 0.05, 0.06), 0.3, 0.4))
	quad(Vector2(0.36, 0.24), cart + Vector3(0, 0.95, 0.025), 0.0, glow(Color(0.25, 0.45, 1.0), 1.3, true))
	_hack("freudcart", cart + Vector3(0, 0.8, 0), Vector3(0.6, 0.8, 0.6), "FREUDBOT CART A\nqueue: 12\nlast session ended: 'listen to them'")


# ------------------------------------------------------------------ the service corridor

func _service() -> void:
	# a narrow corridor behind the east rooms, STAFF ONLY, pipes along the
	# ceiling, light that has gone yellow. It runs round the back to 108.
	_wall(Vector3(0.2, HC, 8.0), Vector3(6.8, HC / 2.0, -42.0))
	_wall(Vector3(0.2, HC, 6.5), Vector3(9.0, HC / 2.0, -15.25))
	_wall(Vector3(0.2, HC, 12.5), Vector3(9.0, HC / 2.0, -30.25))
	_wall(Vector3(0.2, HC, 8.5), Vector3(9.0, HC / 2.0, -41.75))
	_wall(Vector3(0.2, HC - 2.1, 1.0), Vector3(9.0, 2.1 + (HC - 2.1) / 2.0, -37.0))
	_wall(Vector3(0.2, HC - 2.1, 1.0), Vector3(9.0, 2.1 + (HC - 2.1) / 2.0, -19.0))
	_wall(Vector3(0.2, HC, 4.5), Vector3(9.0, HC / 2.0, -21.75))
	_wall(Vector3(2.4, HC, 0.2), Vector3(SERV_X, HC / 2.0, -46.0))
	# the stairwell's door, pinned open
	_door("stairs", Vector3(9.0, 0, -18.5), PI / 2.0, 1.0, -1.5, true)
	neon_text(LINES["signs"]["stairs"], Vector3(8.9, 2.4, -19.0), -PI / 2.0, 0.1, Color(0.9, 0.9, 0.9), 1.4, self)
	# the link behind 108
	_wall(Vector3(3.2, HC, 0.2), Vector3(5.2, HC / 2.0, -41.0))
	_wall(Vector3(3.2, HC, 0.2), Vector3(5.2, HC / 2.0, -43.0))
	var pipe := mat(Color(0.5, 0.48, 0.44), 0.7, 0.4)
	var lag := mat(Color(0.72, 0.7, 0.62), 0.95)
	stick(Vector3(7.3, HC - 0.2, -12.2), Vector3(7.3, HC - 0.2, -45.8), 0.06, pipe)
	stick(Vector3(7.55, HC - 0.25, -12.2), Vector3(7.55, HC - 0.25, -45.8), 0.09, lag)
	stick(Vector3(8.5, HC - 0.15, -12.2), Vector3(8.5, HC - 0.15, -45.8), 0.04, pipe)
	for i in 5:
		var z := -16.0 - i * 7.0
		stick(Vector3(7.3, HC - 0.2, z), Vector3(7.3, 0.4, z), 0.05, pipe)
		box(Vector3(0.12, 0.12, 0.12), Vector3(7.3, HC - 0.2, z), _steel)
	_it("pipes", Vector3(7.5, HC - 0.2, -25.0), Vector3(0.8, 0.4, 6.0))
	var tube := glow(Color(1.0, 0.85, 0.55), 1.4, true)
	for z: float in [-15.0, -22.0, -29.0, -36.0, -43.0]:
		var t := box(Vector3(1.0, 0.04, 0.12), Vector3(SERV_X, HC - 0.03, z), tube)
		light(Vector3(SERV_X, HC - 0.4, z), Color(1.0, 0.8, 0.5), 0.75, 5.5)
		if z == -29.0:
			flickers.append(t)
			no_batch.append(t)
	var band := mat(Color(0.35, 0.36, 0.38), 0.6)
	box(Vector3(0.04, 0.3, 34.0), Vector3(6.9, 0.15, -29.0), band)
	box(Vector3(0.04, 0.3, 34.0), Vector3(8.9, 0.15, -29.0), band)
	# the breaker panel with its cover off, the pharmacy door, the camera
	box(Vector3(0.1, 0.9, 0.6), Vector3(8.92, 1.4, -31.0), mat(Color(0.3, 0.32, 0.34), 0.5, 0.5))
	for i in 8:
		var bm := mat(Color(0.05, 0.05, 0.06), 0.4) if i != 6 else glow(Color(1.0, 0.2, 0.1), 1.8)
		box(Vector3(0.03, 0.06, 0.03), Vector3(8.86, 1.15 + (i % 4) * 0.16, -31.15 + (i / 4) * 0.3), bm)
	neon_text(LINES["signs"]["panel"], Vector3(8.85, 1.92, -31.0), -PI / 2.0, 0.04, Color(0.9, 0.9, 0.9), 1.2, self)
	_hack("panel", Vector3(8.85, 1.4, -31.0), Vector3(0.2, 0.9, 0.6), "VOLTX SUBPANEL 3\nWARD A: ON   108: ON\nFREUD: ON   BOT: TAPED")
	_door("pharmacy", Vector3(9.0, 0, -36.5), PI / 2.0, 1.0, 0.0, false, true)
	neon_text(LINES["signs"]["pharmacy"], Vector3(8.9, 2.35, -36.0), -PI / 2.0, 0.08, Color(0.9, 0.9, 0.9), 1.4, self)
	_reader(Vector3(8.92, 1.2, -35.3), -PI / 2.0)
	_hack("pharm_reader", Vector3(8.9, 1.2, -35.3), Vector3(0.2, 0.3, 0.2), "BADGE READER - PHARMACY\nlock: ENGAGED\nfailed badges today: 4")
	# a laundry cage, a dead Voltx bot on its side
	var cage := Vector3(7.4, 0, -40.0)
	box(Vector3(0.8, 0.05, 1.0), cage + Vector3(0, 0.15, 0), _steel, true)
	for sx: float in [-0.38, 0.38]:
		for sz: float in [-0.48, 0.48]:
			cyl(0.012, 0.012, 1.3, cage + Vector3(sx, 0.8, sz), _steel, 5)
	for i in 5:
		var lm := _white if i < 3 else mat(Color(0.7, 0.62, 0.55), 0.9)
		box(Vector3(0.6, 0.12, 0.8), cage + Vector3(rng.randf_range(-0.05, 0.05), 0.25 + i * 0.13, 0), lm).rotation.y = rng.randf_range(-0.1, 0.1)
	_it("laundry", cage + Vector3(0, 0.7, 0), Vector3(0.9, 1.4, 1.1))
	var dead := cyl(0.22, 0.24, 0.12, Vector3(8.4, 0.15, -24.0), mat(Color(0.15, 0.15, 0.17), 0.4, 0.4), 14)
	dead.rotation.z = 1.2
	# the side door into 108, from the link: a push bar on this side, the
	# lock on the other. The Sneak route ends here.
	_door("108b", Vector3(3.6, 0, -41.5), PI / 2.0, 1.0, 1.6, false, false)
	_reader(Vector3(3.72, 1.2, -40.6), PI / 2.0)
	_hack("108b_reader", Vector3(3.7, 1.2, -40.6), Vector3(0.2, 0.3, 0.2), "BADGE READER - 108 SERVICE\nlock: ENGAGED\nlast badge: NURSE (WK 3)")


# ------------------------------------------------------------------ the stairwell

func _stairwell() -> void:
	# concrete, two flights up to a chained roof door. x 9.2..12.3, z -24..-19
	var conc := pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.62, 0.62, 0.6))
	_wall(Vector3(3.3, 5.8, 0.2), Vector3(10.75, 2.9, -19.0), conc)
	_wall(Vector3(3.3, 5.8, 0.2), Vector3(10.75, 2.9, -24.0), conc)
	_wall(Vector3(0.2, 3.0, 5.0), Vector3(9.0, HC + 1.5, -21.5), conc)
	box(Vector3(3.3, 0.2, 5.2), Vector3(10.75, 5.9, -21.5), conc)
	var step := mat(Color(0.5, 0.5, 0.48), 0.8)
	# flight one, east side, north and up; the landing; flight two, west
	# side, south and up
	for i in 8:
		box(Vector3(1.3, 0.18 * (i + 1), 0.4), Vector3(11.6, 0.09 * (i + 1), -19.5 - i * 0.4), step)
	var r1 := solid_box(Vector3(1.3, 0.2, 3.5), Vector3(11.6, 0.72 - 0.1, -20.9))
	r1.rotation.x = -atan2(1.44, 3.2)
	box(Vector3(3.1, 1.44, 1.3), Vector3(10.75, 0.72, -23.3), step, true)
	for i in 8:
		box(Vector3(1.3, 0.18 * (i + 1), 0.4), Vector3(9.9, 1.44 + 0.09 * (i + 1), -22.5 + i * 0.4), step)
	var r2 := solid_box(Vector3(1.3, 0.2, 3.5), Vector3(9.9, 1.44 + 0.72 - 0.1, -21.1))
	r2.rotation.x = atan2(1.44, 3.2)
	box(Vector3(1.3, 2.88, 0.5), Vector3(9.9, 1.44, -19.45), step, true)
	# railings
	var rail := mat(Color(0.3, 0.3, 0.32), 0.5, 0.6)
	stick(Vector3(10.95, 1.0, -19.3), Vector3(10.95, 2.44, -22.5), 0.02, rail)
	stick(Vector3(10.95, 2.44, -22.5), Vector3(10.55, 2.44, -23.8), 0.02, rail)
	stick(Vector3(10.55, 2.44, -22.5), Vector3(10.55, 3.88, -19.5), 0.02, rail)
	for z: float in [-19.5, -20.5, -21.5, -22.4]:
		stick(Vector3(10.95, (-19.3 - z) / 3.2 * 1.44 + 0.1, z), Vector3(10.95, (-19.3 - z) / 3.2 * 1.44 + 1.0, z), 0.012, rail)
	# the roof door at the top of flight two, chained, a keypad beside it
	box(Vector3(1.0, 2.08, 0.06), Vector3(9.9, 2.88 + 1.04, -19.12), _door_m)
	box(Vector3(0.06, 0.06, 0.03), Vector3(9.9, 2.88 + 1.0, -19.08), _steel)
	var chain := mat(Color(0.4, 0.4, 0.42), 0.4, 0.8)
	for i in 6:
		box(Vector3(0.05, 0.03, 0.02), Vector3(9.55 + i * 0.07, 2.88 + 1.05 - absf(i - 2.5) * 0.015, -19.07), chain)
	neon_text(LINES["signs"]["roof"], Vector3(9.9, 2.88 + 2.3, -19.08), 0.0, 0.08, Color(0.9, 0.3, 0.2), 1.6, self)
	_it("roof_door", Vector3(9.9, 2.88 + 1.04, -19.12), Vector3(1.0, 2.08, 0.15))
	box(Vector3(0.1, 0.14, 0.03), Vector3(10.6, 2.88 + 1.3, -19.08), mat(Color(0.12, 0.12, 0.14), 0.4, 0.3))
	_hack("roof_panel", Vector3(10.6, 2.88 + 1.3, -19.08), Vector3(0.2, 0.3, 0.1), "ROOF ACCESS PANEL\ncode: 4 DIGITS (WORN)\nlast opened: 61 DAYS")
	_it("stairs", Vector3(10.0, 1.0, -20.5), Vector3(0.6, 2.0, 0.6))
	light(Vector3(10.75, 4.8, -21.5), Color(0.9, 0.95, 0.9), 0.9, 7.0)
	light(Vector3(10.0, 1.2, -20.0), Color(0.9, 0.95, 0.9), 0.4, 4.0)


# ------------------------------------------------------------------ Room 108

func _room108() -> void:
	# the room: narrow, the bed along the west wall, the window behind blinds
	_wall(Vector3(7.2, HC, 0.2), Vector3(0, HC / 2.0, -45.4))
	_wall(Vector3(0.2, HC, 7.3), Vector3(-3.6, HC / 2.0, -41.8))
	_wall(Vector3(0.2, HC, 3.4), Vector3(3.6, HC / 2.0, -39.9))
	_wall(Vector3(0.2, HC, 2.8), Vector3(3.6, HC / 2.0, -44.0))
	_wall(Vector3(0.2, HC - 2.1, 1.1), Vector3(3.6, 2.1 + (HC - 2.1) / 2.0, -42.05))
	_wall(Vector3(2.5, HC, 0.2), Vector3(-2.35, HC / 2.0, DOOR_Z - 0.05))
	_wall(Vector3(2.5, HC, 0.2), Vector3(2.35, HC / 2.0, DOOR_Z - 0.05))
	# the floor in here is vinyl, pale, a dried trail to the bed
	floor_quad(Vector2(7.0, 7.0), Vector3(0, 0.005, -41.8), 0.0, mat(Color(0.72, 0.74, 0.72), 0.4))
	var drop := decal_mat(Tex.blood(77), Color(0.8, 0.75, 0.7), 0.5)
	for i in 7:
		var p := Vector3(0, 0.0, DOOR_Z - 0.6).lerp(BED + Vector3(0.7, 0, 0.3), i / 6.0) + Vector3(rng.randf_range(-0.15, 0.15), 0.012 + i * 0.0003, 0)
		floor_quad(Vector2(0.1, 0.1) * rng.randf_range(0.6, 1.3), p, rng.randf() * TAU, drop)
	# the window on the west wall, blinds drawn tight. Midday leaks through
	# the slats in thin white lines.
	var bl := mat(Color(0.86, 0.87, 0.85), 0.7)
	for i in 22:
		var y := 0.9 + i * 0.07
		var s := box(Vector3(0.02, 0.055, 1.6), Vector3(-3.46, y, -43.0), bl)
		s.rotation.z = -0.5
	box(Vector3(0.04, 0.08, 1.7), Vector3(-3.45, 2.46, -43.0), _trim_m)
	var leak := glow(Color(1.0, 0.97, 0.9), 3.0)
	for i in 21:
		box(Vector3(0.005, 0.006, 1.55), Vector3(-3.43, 0.935 + i * 0.07, -43.0), leak)
	light(Vector3(-3.0, 1.7, -43.0), Color(1.0, 0.95, 0.85), 0.55, 3.0, false)
	_it("blinds", Vector3(-3.4, 1.7, -43.0), Vector3(0.2, 1.7, 1.7))
	# one ceiling panel, turned down low; a wedge of corridor light at the door
	box(Vector3(1.2, 0.04, 0.6), Vector3(0, HC - 0.02, -42.0), glow(Color(0.7, 0.85, 0.78), 0.5, true))
	room_light = light(Vector3(0, HC - 0.5, -42.0), Color(0.7, 0.85, 0.78), 0.35, 5.0)
	# the bed, feet to the door
	_bed(BED, 0.0)
	# the vitals monitor on a stand, east of the head: a green trace
	var mp := BED + Vector3(0.95, 0, -0.9)
	cyl(0.3, 0.3, 0.04, mp + Vector3(0, 0.02, 0), _trim_m, 12)
	cyl(0.03, 0.03, 1.3, mp + Vector3(0, 0.67, 0), _steel, 6)
	box(Vector3(0.5, 0.4, 0.1), mp + Vector3(0, 1.45, 0), mat(Color(0.08, 0.08, 0.09), 0.3, 0.4))
	quad(Vector2(0.44, 0.32), mp + Vector3(-0.055, 1.45, 0), -PI / 2.0, glow(Color(0.02, 0.06, 0.04), 1.0, true))
	var trace := glow(Color(0.3, 1.0, 0.5), 2.6, true)
	for i in 12:
		var b := box(Vector3(0.004, 0.02, 0.03), mp + Vector3(-0.06, 1.42, -0.18 + i * 0.033), trace)
		monitor_trace.append(b)
		no_batch.append(b)
	neon_text(LINES["signs"]["vitals"], mp + Vector3(-0.06, 1.58, 0), -PI / 2.0, 0.025, Color(0.5, 1.0, 0.7), 1.6, self)
	light(mp + Vector3(-0.3, 1.4, 0), Color(0.3, 1.0, 0.5), 0.45, 2.6)
	_hack("monitor", mp + Vector3(0, 1.45, 0), Vector3(0.6, 0.5, 0.3), "SALTECH VITALS\nHR 41  SpO2 97  SEDATION 4.0 -> 1.2\nnote: patient smiling (41h)")
	# the IV and the sedation pump, west of the head
	var ip := BED + Vector3(-0.75, 0, -0.7)
	cyl(0.25, 0.25, 0.03, ip + Vector3(0, 0.015, 0), _trim_m, 12)
	cyl(0.02, 0.02, 1.9, ip + Vector3(0, 0.95, 0), _steel, 6)
	box(Vector3(0.12, 0.22, 0.06), ip + Vector3(0.1, 1.75, 0), newmat(Color(0.9, 0.95, 1.0, 0.6), 0.1))
	box(Vector3(0.2, 0.14, 0.12), ip + Vector3(0, 1.2, 0), mat(Color(0.85, 0.86, 0.84), 0.4))
	box(Vector3(0.03, 0.01, 0.01), ip + Vector3(0, 1.25, -0.065), glow(Color(1.0, 0.6, 0.1), 2.0))
	stick(ip + Vector3(0.1, 1.64, 0), BED + Vector3(-0.3, 0.85, -0.35), 0.004, mat(Color(0.8, 0.85, 0.9), 0.3))
	_hack("pump", ip + Vector3(0, 1.2, 0), Vector3(0.3, 0.3, 0.3), "SEDATION PUMP\nrate: TAPERING\nwearing off: 00:12")
	# FreudBot on an arm at the foot of the bed, the screen turned to him
	var fb := BED + Vector3(0.95, 0, 1.2)
	stick(fb + Vector3(0, 0.0, 0), fb + Vector3(0, 1.3, 0), 0.03, _steel)
	stick(fb + Vector3(0, 1.3, 0), fb + Vector3(-0.3, 1.5, -0.3), 0.02, _steel)
	var fbs := box(Vector3(0.5, 0.34, 0.04), fb + Vector3(-0.35, 1.5, -0.35), mat(Color(0.05, 0.05, 0.06), 0.3, 0.4))
	fbs.rotation.y = -0.8
	quad(Vector2(0.44, 0.28), fb + Vector3(-0.37, 1.5, -0.37), -0.8 + PI, glow(Color(0.25, 0.45, 1.0), 1.1, true))
	neon_text(LINES["signs"]["freud108"], fb + Vector3(-0.38, 1.5, -0.38), -0.8 + PI, 0.035, Color(0.8, 0.9, 1.0), 1.6, self)
	_hack("freud108", fb + Vector3(-0.35, 1.5, -0.35), Vector3(0.6, 0.4, 0.6), "FREUDBOT ARM 108\nsession 0\nresponse: NONE (41h)")
	# a chair for a visitor nobody has been
	_chair(BED + Vector3(1.6, 0, 0.6), PI / 2.0, Color(0.6, 0.62, 0.66))
	# the smell is in the bin: gauze, brown and stiff
	cyl(0.14, 0.12, 0.4, BED + Vector3(1.5, 0.2, -1.5), mat(Color(0.75, 0.76, 0.74), 0.5), 10)
	var gm := mat(Color(0.5, 0.3, 0.22), 0.9)
	for i in 5:
		box(Vector3(0.1, 0.03, 0.08), BED + Vector3(1.5 + rng.randf_range(-0.08, 0.08), 0.41 + i * 0.02, -1.5 + rng.randf_range(-0.08, 0.08)), gm).rotation.y = rng.randf() * TAU
	_it("bin", BED + Vector3(1.5, 0.3, -1.5), Vector3(0.4, 0.6, 0.4))
	_it("room", Vector3(0.8, 1.0, -40.0), Vector3(0.6, 2.0, 0.6))


## Harold Dufredy, 65, on his back in Room 108: synth-leather cuffs at the
## wrists and ankles, straps over the chest, hips and knees, gauze pressed
## into the sockets and bandaged round, a smile under it.
func _dufredy() -> void:
	dufredy = figure(Color(0.75, 0.8, 0.84), Color(0.82, 0.7, 0.6), {"hair": Color(0.6, 0.6, 0.58), "legs": Color(0.75, 0.8, 0.84), "arms": true, "knees": true})
	_lay(dufredy, BED, 0.0)
	add_child(dufredy)
	duf_head = dufredy.get_meta("head")
	duf_head.rotation.z = 0.08  # the tilt. Antenna-like.
	# the smile: a dark crescent, too wide, cut into the jaw
	var lip := mat(Color(0.4, 0.1, 0.1), 0.4)
	var teeth := mat(Color(0.9, 0.88, 0.8), 0.3)
	box(Vector3(0.075, 0.012, 0.01), Vector3(0, -0.062, -0.103), lip, false, duf_head)
	box(Vector3(0.06, 0.006, 0.01), Vector3(0, -0.06, -0.104), teeth, false, duf_head)
	for sd: float in [-1.0, 1.0]:
		var c := box(Vector3(0.022, 0.01, 0.01), Vector3(sd * 0.046, -0.052, -0.098), lip, false, duf_head)
		c.rotation.z = -sd * 0.6
	# the sockets: two holes, dark, crusted, the lids gone. Gauze over them.
	var meat := mat(Color(0.3, 0.03, 0.03), 0.25)
	var crust := mat(Color(0.35, 0.12, 0.08), 0.9)
	for sd: float in [-1.0, 1.0]:
		sphere(0.02, Vector3(sd * 0.036, 0.018, -0.098), meat, 10, duf_head)
		var ring := TorusMesh.new()
		ring.inner_radius = 0.017
		ring.outer_radius = 0.025
		ring.rings = 12
		ring.ring_segments = 5
		var r := mesh(ring, Vector3(sd * 0.036, 0.018, -0.102), crust, duf_head)
		r.rotation.x = PI / 2.0
		# dried runs from the sockets down past the smile
		var run := box(Vector3(0.012, 0.08, 0.004), Vector3(sd * 0.042, -0.035, -0.106), crust, false, duf_head)
		run.rotation.z = sd * 0.15
	gauze_band = Node3D.new()
	duf_head.add_child(gauze_band)
	var gz := pbr("fabric", Vector3(1, 1, 1) / 0.3, true, Color(0.95, 0.94, 0.9))
	var g := box(Vector3(0.21, 0.075, 0.05), Vector3(0, 0.02, -0.1), gz, false, gauze_band)
	g.rotation.x = 0.1
	for sd: float in [-1.0, 1.0]:
		box(Vector3(0.05, 0.08, 0.2), Vector3(sd * 0.1, 0.02, -0.01), gz, false, gauze_band)
	box(Vector3(0.24, 0.07, 0.03), Vector3(0, 0.025, 0.1), gz, false, gauze_band)
	# the gauze seeps: two dark blooms, soaking out from the hollows
	var seep := mat(Color(0.45, 0.06, 0.05), 0.45)
	var seep2 := mat(Color(0.28, 0.08, 0.06), 0.8)
	for sd: float in [-1.0, 1.0]:
		var s1 := sphere(0.024, Vector3(sd * 0.036, 0.015, -0.118), seep, 10, gauze_band)
		s1.scale = Vector3(1.1, 0.9, 0.35)
		var s2 := sphere(0.034, Vector3(sd * 0.04, 0.01, -0.114), seep2, 10, gauze_band)
		s2.scale = Vector3(1.2, 1.0, 0.25)
	# a wrap over the crown, the hair flattened under it
	box(Vector3(0.2, 0.03, 0.21), Vector3(0, 0.11, 0.0), gz, false, duf_head)
	# the pillow is stained where the gauze meets it
	floor_quad(Vector2(0.3, 0.26), BED + Vector3(0.05, 0.815, -0.78), 0.3, decal_mat(Tex.blood(31), Color(0.7, 0.6, 0.55), 0.5))
	# the restraints: synth-leather, industrial, anchored to the rails
	var lea := mat(Color(0.06, 0.05, 0.05), 0.55)
	var buck := mat(Color(0.6, 0.62, 0.6), 0.3, 0.9)
	for z: float in [-0.42, 0.05, 0.6]:  # chest, hips, knees
		var h := 0.99 if z < 0.0 else (0.97 if z < 0.3 else 0.98)
		box(Vector3(1.04, 0.012, 0.09), BED + Vector3(0, h, z), lea)
		for sx: float in [-0.5, 0.5]:
			box(Vector3(0.03, 0.14, 0.09), BED + Vector3(sx, h - 0.07, z), lea)
			box(Vector3(0.04, 0.04, 0.05), BED + Vector3(sx * 0.6, h + 0.01, z), buck)
	for sx: float in [-0.28, 0.28]:  # wrist cuffs, chained short to the rail
		box(Vector3(0.11, 0.08, 0.1), BED + Vector3(sx, 0.86, 0.3), lea)
		box(Vector3(0.03, 0.03, 0.03), BED + Vector3(sx * 1.3, 0.86, 0.3), buck)
		stick(BED + Vector3(sx * 1.3, 0.86, 0.3), BED + Vector3(sx * 1.78, 0.98, 0.3), 0.008, buck)
	for sx: float in [-0.1, 0.1]:  # ankle cuffs
		box(Vector3(0.1, 0.09, 0.1), BED + Vector3(sx, 0.84, 0.88), lea)
	# a sheet over the shins, thrown back by whoever checked the cuffs
	var sheet := pbr("fabric", Vector3(1, 1, 1) / 1.0, true, Color(0.8, 0.82, 0.8))
	var sh := box(Vector3(0.9, 0.03, 0.8), BED + Vector3(0.05, 0.96, 0.7), sheet)
	sh.rotation.y = 0.05
	_it("dufredy", BED + Vector3(0, 0.95, -0.2), Vector3(1.1, 0.7, 2.0),
		"DUFREDY, HAROLD (65)\nSalTech Hospital, Rm 108\nsedation: WEARING OFF\nvisitors: 0")


# ------------------------------------------------------------------ people

func _people() -> void:
	# the waiting room: four patients in the chairs, the same hum under
	# their breath, nobody looking at anyone. One stands at the dead screen.
	var coats := [Color(0.3, 0.3, 0.35), Color(0.55, 0.5, 0.42), Color(0.72, 0.78, 0.82), Color(0.4, 0.2, 0.2)]
	var skins := [Color(0.85, 0.66, 0.52), Color(0.6, 0.42, 0.3), Color(0.92, 0.78, 0.66), Color(0.45, 0.3, 0.22)]
	var seats := [[0, 1], [0, 4], [1, 2], [2, 0]]
	for i in seats.size():
		var row: int = seats[i][0]
		var k: int = seats[i][1]
		var p := Vector3(WAIT.x - 1.4 + k * 0.7, 0.0, WAIT.z + 2.2 - row * 1.6 + 0.05)
		var f := figure(coats[i], skins[i], {"hair": Color(0.1 + i * 0.15, 0.08, 0.06), "long_hair": i == 2, "legs": Color(0.2, 0.2, 0.25), "arms": true, "knees": true, "visor": i != 1})
		_sit(f, p, PI, 0.47)
		patients.append(f)
	var st := figure(Color(0.55, 0.55, 0.6), skins[0], {"hair": Color(0.2, 0.15, 0.1), "visor": true})
	st.position = Vector3(-9.9, 0.02, -3.0)
	add_child(st)
	turn_to(st, Vector3(-12.0, 1.0, -3.0))
	patients.append(st)
	# someone in the second FreudBot booth, not saying anything either
	var fbp := figure(Color(0.45, 0.4, 0.5), skins[1], {"hair": Color(0.05, 0.05, 0.05), "arms": true, "knees": true})
	_sit(fbp, Vector3(BOOTHS_X + 0.7, 0, -6.6), -PI / 2.0, 0.47, 0.1)
	patients.append(fbp)
	# security by the corridor mouth: SalTech black, a visor, a stance.
	# Tagged for later; for now he turns toward the frames when they're on.
	security = figure(Color(0.05, 0.06, 0.08), Color(0.55, 0.4, 0.3), {"hair": Color(0.03, 0.03, 0.03), "legs": Color(0.05, 0.06, 0.08), "arms": true, "knees": true, "visor": true, "long_coat": false})
	security.position = Vector3(3.6, 0.02, -10.4)
	security.set_meta("guard", true)
	add_child(security)
	(security.get_meta("body") as Node3D).scale = Vector3(1.15, 1.0, 1.1)
	turn_to(security, Vector3(0, 0, 0))
	box(Vector3(0.14, 0.08, 0.05), Vector3(0.1, 1.05, -0.2), mat(Color(0.1, 0.1, 0.12), 0.4), false, security)
	person("security", LINES["prompts"]["security"], security, LINES["scan"]["guard"])
	# the orderlies, tagged: one walking the ward's rows, two pacing the
	# service corridor behind the FreudBot booth (the Sneak route)
	var routes := [[-9.0, -31.0, -16.5, "orderly", 1.0], [SERV_X - 0.3, -39.0, -14.5, "orderly2", 1.0], [SERV_X + 0.3, -44.0, -20.0, "orderly2", -1.0]]
	for i in routes.size():
		var r: Array = routes[i]
		var o := figure(Color(0.35, 0.55, 0.6), [Color(0.86, 0.68, 0.55), Color(0.5, 0.36, 0.26), Color(0.9, 0.78, 0.68)][i], {"hair": [Color(0.3, 0.2, 0.1), Color(0.05, 0.05, 0.05), Color(0.6, 0.5, 0.3)][i], "legs": Color(0.35, 0.55, 0.6), "arms": true, "knees": true, "long_coat": false})
		o.position = Vector3(float(r[0]), 0.02, (float(r[1]) + float(r[2])) / 2.0)
		o.set_meta("guard", true)
		o.set_meta("walk", true)
		add_child(o)
		person("orderly", LINES["prompts"]["orderly"], o, LINES["scan"][str(r[3])])
		orderlies.append({"fig": o, "dir": float(r[4]), "zmin": float(r[1]), "zmax": float(r[2])})
		if i == 0:
			orderly = o
	# the nurse: young, uniform crisp and new, AR glasses. She arrives
	# once Carl checks in, from the corridor.
	nurse = figure(Color(0.93, 0.94, 0.96), Color(0.9, 0.76, 0.64), {"hair": Color(0.25, 0.15, 0.1), "long_hair": true, "legs": Color(0.93, 0.94, 0.96), "arms": true, "knees": true, "visor": true, "long_coat": false})
	nurse.position = Vector3(0, 0.02, -24.0)
	nurse.visible = false
	add_child(nurse)
	nurse_body = person("nurse", LINES["prompts"]["nurse"], nurse, "SALTECH NURSING - PROBATION (WK 3)\nORA-class AR glasses: LINKED\nchart open: DUFREDY, H.")
	set_active(nurse_body, false)


# ------------------------------------------------------------------ outside

func _outside() -> void:
	var outside := Node3D.new()
	add_child(outside)
	kit_parent = outside
	# the desert, and the lot laid on it; sand drifted over the lines
	floor_quad(Vector2(600, 600), Vector3(0, -0.05, 0), 0.0, mat(Color(0.74, 0.62, 0.45), 1.0), outside)
	var lot := pbr("asphalt", Vector3(1, 1, 1) / 4.0, true, Color(0.75, 0.73, 0.7))
	floor_quad(Vector2(64, 40), Vector3(0, 0.0, 24.0), 0.0, lot, outside)
	floor_quad(Vector2(14, 60), Vector3(-26, 0.0, -20.0), 0.0, lot, outside)
	var line := mat(Color(0.85, 0.85, 0.8), 0.9)
	for i in 12:
		var x := -27.5 + i * 5.0
		box(Vector3(0.12, 0.01, 5.0), Vector3(x, 0.006, 36.0), line, false, outside)
		box(Vector3(0.12, 0.01, 5.0), Vector3(x, 0.006, 14.0), line, false, outside)
	var paving := pbr("paving", Vector3(1, 1, 1) / 1.5, true, Color(0.85, 0.82, 0.76))
	box(Vector3(30, 0.15, 4.0), Vector3(-2, 0.0, 2.0), paving, true, outside)
	var sand := decal_mat(Tex.sand(), Color(1, 1, 1), 1.0)
	for i in 40:
		var p := Vector3(rng.randf_range(-30, 30), 0.012 + i * 0.0003, rng.randf_range(5, 42))
		floor_quad(Vector2(2.0, 2.0) * rng.randf_range(0.8, 2.5), p, rng.randf() * TAU, sand, outside)
	var dune := mat(Color(0.8, 0.68, 0.48), 1.0)
	for i in 9:
		var p := Vector3(-17.0 + (1.0 if i % 2 == 0 else -1.0) * 0.6, 0.0, -2.0 - i * 5.0)
		var d := sphere(rng.randf_range(1.0, 2.2), p, dune, 8, outside)
		d.scale = Vector3(1.0, 0.25, 1.4)
	for i in 6:
		var d := sphere(rng.randf_range(1.0, 2.0), Vector3(13.1, 0.0, -4.0 - i * 7.0), dune, 8, outside)
		d.scale = Vector3(1.0, 0.22, 1.5)
	# Voltx: a van, a worker with a broom, a sand bot. A Sisyphean necessity.
	var van := Node3D.new()
	van.position = Vector3(-9.0, 0, 7.5)
	van.rotation.y = PI / 2.0 + 0.1
	outside.add_child(van)
	van.add_child(Car.build(self, Color(0.95, 0.6, 0.1), {"van": true, "plate": "VLTX 4410"}))
	solid_box(Vector3(2.2, 2.4, 5.2), Vector3(0, 1.2, 0), van)
	neon_text(LINES["signs"]["voltx"], Vector3(0, 1.9, -1.1), PI / 2.0, 0.4, Color(0.1, 0.1, 0.12), 0.2, van)
	_it("van", Vector3(0, 1.2, 0), Vector3(2.3, 2.4, 5.3), "VOLTX MAINTENANCE 4410\ntask: SAND REMOVAL (DAILY)\nprogress: 0%", false, van)
	worker = figure(Color(0.95, 0.75, 0.1), Color(0.6, 0.42, 0.3), {"hair": Color(0.05, 0.05, 0.05), "legs": Color(0.25, 0.25, 0.3), "arms": true, "knees": true})
	worker.position = Vector3(-6.5, 0.02, 3.5)
	add_child(worker)
	turn_to(worker, Vector3(-9.0, 0, 1.5))
	for a in worker.get_meta("arms"):
		(a as Node3D).rotation.x = -0.9
	var broom := stick(Vector3(-6.9, 1.2, 3.2), Vector3(-8.0, 0.1, 2.0), 0.015, mat(Color(0.5, 0.35, 0.2), 0.8))
	no_batch.append(broom)
	box(Vector3(0.3, 0.06, 0.1), Vector3(-8.05, 0.06, 1.95), mat(Color(0.6, 0.55, 0.4), 0.9), false, outside).rotation.y = 0.7
	person("worker", LINES["prompts"]["worker"], worker, "VOLTX - GROUNDS\nshift: 06:00 - 18:00\nsand moved today: 1.4 t")
	# Carl's car at the kerb: it drops him and parks itself
	my_car = Node3D.new()
	my_car.position = Vector3(3.2, 0, 5.2)
	my_car.rotation.y = PI / 2.0
	add_child(my_car)
	my_car.add_child(Car.build(self, Color(0.75, 0.78, 0.8), {"plate": "PSF 0086"}))
	# other cars, parked on the periphery, and a hover taxi waiting
	for i in 7:
		var c := Node3D.new()
		c.position = Vector3(-27.5 + (i * 2 + 1) * 2.5 + (10.0 if i > 3 else 0.0), 0, 36.5)
		outside.add_child(c)
		c.add_child(Car.build(self, [Color(0.1, 0.1, 0.12), Color(0.6, 0.62, 0.65), Color(0.4, 0.08, 0.1), Color(0.85, 0.85, 0.82)][i % 4], {"hover": i % 3 == 0}))
		solid_box(Vector3(2.0, 1.5, 4.6), Vector3(0, 0.75, 0), c)
	# the lot's lights
	for x: float in [-20.0, 0.0, 20.0]:
		cyl(0.1, 0.14, 7.0, Vector3(x, 3.5, 25.0), _steel, 8, outside)
		box(Vector3(1.2, 0.2, 0.5), Vector3(x, 7.0, 25.0), _trim_m, false, outside)
	# the south side: shorter, utilitarian, hunkered down. Blocks across the
	# road, warehouses east and west, the city's towers far to the north.
	var x := -46.0
	while x < 46.0:
		var w := rng.randf_range(12.0, 20.0)
		cyber_block(Vector3(x + w / 2.0, 0, 50.0), PI, w, rng.randf_range(8.0, 18.0), 16.0, true)
		x += w + rng.randf_range(0.5, 3.0)
	for z: float in [-36.0, -14.0, 10.0]:
		cyber_block(Vector3(36.0, 0, z), -PI / 2.0, 20.0, rng.randf_range(7.0, 14.0), 16.0, true, 1)
		cyber_block(Vector3(-40.0, 0, z), PI / 2.0, 20.0, rng.randf_range(7.0, 12.0), 16.0, true, 1)
	for i in 14:
		var px := rng.randf_range(-120, 120)
		var pz := rng.randf_range(-130, -70)
		cyber_block(Vector3(px, 0, pz), 0.0, rng.randf_range(14, 26), rng.randf_range(18, 60), 20.0, false, 1)
	for i in 3:
		var cx := rng.randf_range(-20.0, 20.0)
		cable(Vector3(cx, rng.randf_range(5.5, 6.5), 0.2), Vector3(cx + rng.randf_range(-6, 6), rng.randf_range(7.0, 10.0), 50.0), 1.4)
	var h1: Array = LINES["signs"]["holo1"]
	var h2: Array = LINES["signs"]["holo2"]
	kit_holo(Vector3(-14.0, 14.0, 46.0), PI, h1[0], h1[1], Color(1.0, 0.5, 0.12), 12.0)
	kit_holo(Vector3(60.0, 26.0, -90.0), 0.3, h2[0], h2[1], Color(0.3, 0.95, 1.0), 26.0)
	kit_parent = self
	_batch(outside, 30.0, true)
	# hover traffic on the road past the lot, drones streaming north
	var traffic = preload("res://scripts/Traffic.gd").new()
	traffic.lanes = [[44.0, 9.0, 1.0], [46.5, 13.0, -1.0], [-68.0, 16.0, 1.0]]
	traffic.along_x = true
	traffic.s_min = -140.0
	traffic.s_max = 140.0
	traffic.count = 7
	traffic.tower_top = Vector3(0, 320, -700)
	traffic.drone_box = AABB(Vector3(-200, 20, -260), Vector3(400, 60, 200))
	traffic.drone_count = 70
	add_child(traffic)
	traffic.setup(main, self)


func _bounds() -> void:
	solid_box(Vector3(2, 10, 120), Vector3(-36, 5, 0))
	solid_box(Vector3(2, 10, 120), Vector3(34, 5, 0))
	solid_box(Vector3(80, 10, 2), Vector3(0, 5, 48))
	solid_box(Vector3(80, 10, 2), Vector3(0, 5, -60))


# ------------------------------------------------------------------ the chapter

## Play a beat from LINES: [who, text] pairs, "" for a thought.
func _play(lines: Array) -> void:
	var ui = main.ui
	for l: Array in lines:
		if str(l[0]) == "":
			await ui.think(str(l[1]))
		else:
			await ui.say(str(l[0]), str(l[1]))


func objective() -> String:
	var f: Dictionary = main.flags
	var o: Dictionary = LINES["objective"]
	if f.has("hospital_interviewed"):
		return o["leave"]
	if f.has("hospital_wing"):
		return o["room"]
	if f.has("hospital_checkin"):
		return o["nurse"]
	return o["checkin"]


func intro() -> void:
	await get_tree().create_timer(0.5).timeout
	# the car drops him and goes to find parking on its own
	var tw := create_tween()
	tw.tween_property(my_car, "position", Vector3(30.0, 0, 5.2), 4.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tw.tween_property(my_car, "position", Vector3(30.0, 0, 36.5), 3.0)
	await _play(LINES["intro"])
	main.ui.close()


func tick(delta: float) -> void:
	if not main or not main.player or not main.started:
		return
	var f: Dictionary = main.flags
	var pp: Vector3 = main.player.global_position
	var head_pt := pp + Vector3(0, 1.6, 0)
	# the reception bot keeps its face on you
	if bot_head:
		var par := bot_head.get_parent() as Node3D
		var local: Vector3 = par.to_local(pp + Vector3(0, 1.5, 0)) - bot_head.position
		var want := clampf(atan2(-local.x, -local.z), -1.3, 1.3)
		bot_head.rotation.y = lerp_angle(bot_head.rotation.y, want, 0.04)
	# the entrance slides open for anyone; it doesn't ask
	var near_door := absf(pp.x) < 2.5 and absf(pp.z + 0.3) < 2.6
	for l in door_leaves:
		var leaf := l as Node3D
		var sd := float(leaf.get_meta("side"))
		leaf.position.x = lerpf(leaf.position.x, sd * (2.3 if near_door else 0.85), delta * 3.0)
	# the ward's cleaning bot, pushing the same sand up and down
	if sweeper:
		sweeper.position.z = -21.5 + sin(_t * 0.25) * 6.0
		sweeper.rotation.y = _t * 0.5
	# the dying panel in the lobby corner
	if panel_flicker:
		panel_flicker.light_energy = 1.1 if (flickers[0] as Node3D).visible else 0.1
	# the monitor's trace: a slow heart, 41 a minute
	for i in monitor_trace.size():
		var b: MeshInstance3D = monitor_trace[i]
		var ph := fmod(_t * 0.68 - i * 0.09, 1.0)
		var spike := (1.0 if ph < 0.08 else 0.0) * 0.07 + (0.5 if ph > 0.08 and ph < 0.14 else 0.0) * 0.04
		b.scale.y = 1.0 + spike * 40.0
	# the people: the hum is in the sway
	for p in patients:
		var n := p as Node3D
		var hd: Node3D = n.get_meta("head")
		hd.rotation.z = sin(_t * 0.4 + float(n.get_instance_id() % 7)) * 0.06
		if not n.get_meta("knees", []).is_empty():
			var body: Node3D = n.get_meta("body")
			body.scale.y = 1.0 + sin(_t * 0.7 + float(n.get_instance_id() % 5)) * 0.008
		else:
			Anim.idle(n, _t, float(n.get_instance_id() % 100))
	for p in ward_people:
		var n := p as Node3D
		var body: Node3D = n.get_meta("body")
		body.scale.y = 1.0 + sin(_t * 0.55 + float(n.get_instance_id() % 5)) * 0.01
	if worker:
		Anim.idle(worker, _t, 2.0)
		for a in worker.get_meta("arms"):
			(a as Node3D).rotation.x = -0.9 + sin(_t * 1.6) * 0.25
	if patient103:
		# the one in 103 sits up and follows you along the corridor
		var near := pp.z < -14.0 and pp.z > -30.0 and pp.x > -2.0 and pp.x < 7.0
		Anim.look(patient103, head_pt, 1.0 if near else 0.0, 0.05)
	# the guards: posted, or on a loop; when the frames are on they turn
	# to Carl wherever he is in the building
	var frames: bool = main.frames_on
	if security:
		Anim.idle(security, _t, 5.0)
		var watch := frames or pp.distance_to(security.global_position) < 5.0
		Anim.look(security, head_pt, 1.0 if watch else 0.0, 0.08)
		if frames:
			var d := pp - security.global_position
			security.rotation.y = lerp_angle(security.rotation.y, atan2(-d.x, -d.z), 0.03)
	for od in orderlies:
		var o: Node3D = od["fig"]
		if frames and pp.distance_to(o.global_position) < 30.0:
			if o.has_meta("walk"):
				o.remove_meta("walk")
				for l in o.get_meta("legs"):
					(l as Node3D).rotation.x = 0.0
			Anim.idle(o, _t, 2.0)
			turn_to(o, pp)
			Anim.look(o, head_pt, 1.0, 0.1)
		else:
			if not o.has_meta("walk"):
				o.set_meta("walk", true)
			var dir: float = od["dir"]
			var z := o.position.z + dir * delta * 0.7
			if z < float(od["zmin"]):
				od["dir"] = 1.0
			elif z > float(od["zmax"]):
				od["dir"] = -1.0
			o.position.z = z
			o.rotation.y = 0.0 if dir > 0.0 else PI
			Anim.walk(o, _t, 0.7)
			Anim.look(o, head_pt, 0.6 if pp.distance_to(o.global_position) < 6.0 else 0.0, 0.05)
	if nurse and nurse.visible:
		if nurse.has_meta("walk"):
			Anim.walk(nurse, _t, 1.25)
		else:
			Anim.idle(nurse, _t, 1.0)
			Anim.look(nurse, head_pt, 0.8 if pp.distance_to(nurse.global_position) < 7.0 else 0.0, 0.06)
	if dufredy:
		# breathing: unnervingly slow and deliberate, a child pretending
		var body: Node3D = dufredy.get_meta("body")
		body.scale.z = 1.0 + (0.5 + 0.5 * sin(_t * 0.55)) * 0.06
		if f.has("hospital_interviewed"):
			duf_head.rotation.z = -0.7 + sin(_t * 0.9) * 0.03
	# the threshold of 108: the room, before he speaks
	if f.has("hospital_wing") and not f.has("hospital_room_seen") and not f.has("cinematic") and pp.z < DOOR_Z - 0.6 and absf(pp.x) < 3.5:
		f["hospital_room_seen"] = true
		_threshold()


func interact(node: Object) -> bool:
	var ui = main.ui
	var f: Dictionary = main.flags
	var id := str(node.get_meta("id"))
	var look: Dictionary = LINES["look"]
	match id:
		"bot":
			await _bot()
		"button":
			main.play("ding", -6.0, 1.3)
			await _play(LINES["bot"]["button"])
		"nurse":
			await _nurse()
		"security":
			turn_to(security, main.player.global_position, 0.3)
			await _play(LINES["guard"]["security_frames" if main.frames_on else "security"])
		"orderly":
			await _play(LINES["guard"]["orderly_frames" if main.frames_on else "orderly"])
		"door_staff":
			if not f.has("hospital_staff_seen"):
				f["hospital_staff_seen"] = true
				await _play(look["staff_door"])
			_swing("staff")
		"door_wing_l", "door_wing_r":
			await _wing_gate()
		"wing_reader":
			await _play(look["wing_reader"])
		"speaker":
			await _play(look["speaker"])
		"door_ward_l", "door_ward_r":
			if f.has("hospital_wing"):
				for k in ["ward_l", "ward_r"]:
					doors[k]["locked"] = false
					_swing(k)
			else:
				await _play(look["ward_doors"])
		"door_103":
			if not doors["103"]["open"]:
				_swing("103")
			else:
				await _play(look["door_103"])
		"door_102", "door_104":
			var k := id.trim_prefix("door_")
			if doors[k]["locked"]:
				await _play(look["door_locked"])
			else:
				_swing(k)
		"door_108b":
			# the Sneak route's end: a door that only locks from the room side
			if not f.has("hospital_wing"):
				await _open_wing("sneak")
				await _play(LINES["wing"]["sneak_done"])
			if not doors["108b"]["open"]:
				_swing("108b")
			else:
				await _play(look["door_108b_locked"])
		"door_108":
			if not f.has("hospital_wing"):
				await _play(look["door_108_early"])
			elif door108.rotation.y > -0.5:
				_open108()
			else:
				await _play(look["door_108_open"])
		"door_pharmacy", "pharm_reader":
			await _play(look["pharmacy"])
		"roof_door", "roof_panel":
			await _play(look["roof_door"])
		"staff_reader":
			await _play(look["staff_door"])
		"108b_reader":
			await _play(look["door_108b_locked"])
		"dufredy":
			await _dufredy_scene()
		"exit":
			await _leave()
		"freudcart":
			await _play(look["freudbot"])
		_:
			if id.begins_with("door_"):
				var n := id.trim_prefix("door_")
				if n == "stairs":
					return true
				await ui.think(str(look["door_locked"][0][1]) % n)
			elif look.has(id):
				await _play(look[id])
			else:
				return false
	return true


func _bot() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var L: Dictionary = LINES["bot"]
	if f.has("hospital_checkin"):
		await _play(L["again"])
		return
	await _play((L["checkin"] as Array).slice(0, 2))
	main.play("ding", -8.0, 1.2)
	await _play((L["checkin"] as Array).slice(2))
	ui.close()
	f["hospital_checkin"] = true
	main.update_hud()
	# precisely five minutes later (we'll call it twelve seconds)
	await get_tree().create_timer(1.5).timeout
	nurse.visible = true
	nurse.position = Vector3(0, 0.02, -22.0)
	nurse.set_meta("walk", true)
	turn_to(nurse, Vector3(-2.4, 0, -8.5))
	var tw := create_tween()
	tw.tween_property(nurse, "position", Vector3(-2.4, 0.02, -8.5), 7.0)
	await tw.finished
	nurse.remove_meta("walk")
	for l in nurse.get_meta("legs"):
		(l as Node3D).rotation.x = 0.0
	turn_to(nurse, main.player.global_position)
	set_active(nurse_body, true)
	await _play(L["arrives"])
	ui.close()
	main.update_hud()


func _nurse() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var L: Dictionary = LINES["nurse"]
	turn_to(nurse, main.player.global_position, 0.3)
	if not f.has("hospital_checkin"):
		await _play(L["early"])
		return
	if f.has("hospital_nurse"):
		await _play(L["after"])
		return
	if f.has("hospital_nurse_asked"):
		# she has answered; asking again, kindly, is still the Person route
		if await _ask_nurse():
			await _nurse_walk()
		return
	f["cinematic"] = true
	await _play(L["hello"])
	# her two questions, in whatever order, or neither
	var all: Array = L["choices"]
	var left: Array = all.duplicate()
	while not left.is_empty():
		var opts: Array = left.duplicate()
		opts.append(L["enough"])
		var pick: int = await ui.choose(opts)
		if pick >= left.size():
			break
		var qi: int = all.find(left[pick])
		left.remove_at(pick)
		await _play(L["q%d" % qi])
	await _play(L["anything"])
	f["hospital_nurse_asked"] = true
	# the Person route: ask her kindly and she walks Carl in
	if await _ask_nurse():
		await _nurse_walk()
	else:
		ui.close()
		f.erase("cinematic")
		main.update_hud()


## The kind ask. True if Carl asked, with the trust it earns.
func _ask_nurse() -> bool:
	var ui = main.ui
	var L: Dictionary = LINES["nurse"]
	var pick: int = await ui.choose(L["ask"])
	if pick == 0:
		await _play(L["kind"])
		main.add_trust("nurse", 1)
		main.log_line("trust", LINES["nurse"]["nurse_logged"])
		return true
	await _play(L["own"])
	return false


## She walks him through the wing door and down to 108. Her glasses
## flash red at the door.
func _nurse_walk() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var L: Dictionary = LINES["nurse"]
	f["cinematic"] = true
	ui.close()
	nurse.set_meta("walk", true)
	turn_to(nurse, Vector3(0.9, 0, -10.6), 0.4)
	var tw := create_tween()
	tw.tween_property(nurse, "position", Vector3(0.9, 0.02, -10.6), 3.5)
	await tw.finished
	if not f.has("hospital_wing"):
		turn_to(nurse, Vector3(2.1, 0, -11.9), 0.3)
		await _play(L["wing"])
		ui.close()
		await _open_wing("person")
	tw = create_tween()
	tw.tween_property(nurse, "position", Vector3(0.9, 0.02, -20.0), 6.0)
	tw.tween_property(nurse, "position", Vector3(1.0, 0.02, -37.0), 8.5)
	turn_to(nurse, Vector3(0.9, 0, -20.0), 0.4)
	await _play(L["walk"])
	ui.close()
	await tw.finished
	nurse.remove_meta("walk")
	for l in nurse.get_meta("legs"):
		(l as Node3D).rotation.x = 0.0
	turn_to(nurse, Vector3(1.0, 0, -30.0))
	var vis: MeshInstance3D = nurse.get_meta("visor")
	if vis:
		vis.material_override = glow(Color(1.0, 0.1, 0.05), 4.0)
		main.play("on", -12.0, 1.6)
	await get_tree().create_timer(0.5).timeout
	await _play(L["alert"])
	if vis:
		vis.material_override = glow(Color(0.3, 0.95, 1.0), 3.0)
	await _play(L["door"])
	ui.close()
	_open108()
	f["hospital_nurse"] = true
	f.erase("cinematic")
	main.update_hud()


## The choice at the perimeter: the four routes into a tier-3 site, as
## plain choices for now. Each plays its effects and lets Carl through.
func _wing_gate() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var L: Dictionary = LINES["wing"]
	var look: Dictionary = LINES["look"]
	if f.has("hospital_wing"):
		if not doors["wing_l"]["open"]:
			_swing("wing_l")
			_swing("wing_r")
		else:
			await _play(L["again"])
		return
	if not f.has("hospital_wing_seen"):
		f["hospital_wing_seen"] = true
		await _play(L["look"])
	var C: Dictionary = L["choices"]
	var keys: Array = ["badge", "hack", "sneak"]
	if nurse.visible and not f.has("hospital_nurse"):
		keys.append("person")
	keys.append("wait")
	var opts: Array = []
	for k in keys:
		opts.append(C[k])
	var pick: int = await ui.choose(opts)
	var route: String = keys[pick]
	match route:
		"badge":
			main.play("ding", -8.0, 1.5)
			wing_reader_light.material_override = glow(Color(0.2, 1.0, 0.4), 2.0)
			await _play(L["badge"])
			main.add_pressure(2.0, L["badge_log"])
			await _open_wing("badge")
		"hack":
			ui.glitch(0.3, 0.5)
			main.play("glitch", -10.0, 0.8)
			cam_ring.material_override = mat(Color(0.05, 0.05, 0.06), 0.3)
			await _play(L["hack"])
			main.add_connection(2.0, L["hack_log"])
			await _open_wing("hack")
		"sneak":
			await _play(L["sneak"])
			f["hospital_sneaking"] = true
		"person":
			await _play(LINES["nurse"]["from_door"])
			if await _ask_nurse():
				await _nurse_walk()
		_:
			pass
	ui.close()
	main.update_hud()


## The wing opens, by whichever route; the ward's doors onto it unlock.
func _open_wing(route: String) -> void:
	var f: Dictionary = main.flags
	f["hospital_wing"] = true
	f["hospital_route_" + route] = true
	main.log_line("route", LINES["wing"][route + "_log"] if LINES["wing"].has(route + "_log") else route)
	for k in ["ward_l", "ward_r"]:
		doors[k]["locked"] = false
	if route != "sneak":
		for k in ["wing_l", "wing_r"]:
			doors[k]["locked"] = false
			if not doors[k]["open"]:
				_swing(k)
		await get_tree().create_timer(0.9).timeout
		await _play(LINES["wing"]["open"])
	main.update_hud()


func _open108() -> void:
	main.play("door", -6.0, 0.9)
	create_tween().tween_property(door108, "rotation:y", -1.7, 1.2).set_trans(Tween.TRANS_SINE)
	set_active(door108_body, false)


func _threshold() -> void:
	main.flags["cinematic"] = true
	await main.player.face(BED + Vector3(0, 0.95, -0.6), 1.2)
	main.play("sting", -10.0, 0.6)
	await _play(LINES["threshold"])
	main.ui.close()
	main.flags.erase("cinematic")


## The interview. Carl at the bedside; the three questions; the laptop;
## the altar in your lap; the lullaby.
func _dufredy_scene() -> void:
	var ui = main.ui
	var p = main.player
	var f: Dictionary = main.flags
	var L: Dictionary = LINES["dufredy"]
	if f.has("hospital_interviewed"):
		await _play(L["again"])
		return
	if not f.has("hospital_wing"):
		return
	f["cinematic"] = true
	f["hospital_room_seen"] = true
	_hum108.stop()
	# step to the bedside, east of him, and look down
	var tw := create_tween()
	tw.tween_property(p, "position", BED + Vector3(1.05, 0.05, -0.3), 1.0)
	await tw.finished
	await p.face(BED + Vector3(0, 0.95, -0.75), 0.8)
	await _play(L["open1"])
	create_tween().tween_property(duf_head, "rotation:z", 0.3, 1.4).set_trans(Tween.TRANS_SINE)
	await _play(L["open2"])
	main.play("sting", -6.0, 0.7)
	ui.glitch(0.35, 0.6)
	await _play(L["open3"])
	main.add_connection(1.0, "Dufredy knew my name")
	var all: Array = L["choices"]
	var options: Array = all.duplicate()
	var asked := 0
	while asked < 3:
		var pick: int = await ui.choose(options)
		var q: String = options[pick]
		var qi: int = all.find(q)
		options.remove_at(pick)
		asked += 1
		if qi == 2:
			await _show_laptop()
		else:
			await _play(L["q%d" % qi])
			if qi == 3:
				main.add_connection(1.0, "ruin and reflection")
				main.learn("the path")
	if not f.has("hospital_laptop"):
		await _show_laptop()
	await _play(L["close1"])
	main.learn("the path")
	main.learn("filter")
	ui.close()
	ui.laptop_open(false)
	# he turns away, toward the window. The gauze rides up. The sockets.
	var turn := create_tween().set_parallel(true)
	turn.tween_property(duf_head, "rotation:z", -0.7, 2.6).set_trans(Tween.TRANS_SINE)
	turn.tween_property(gauze_band, "position", Vector3(0.0, 0.055, 0.0), 2.6).set_trans(Tween.TRANS_SINE)
	turn.tween_property(gauze_band, "rotation:x", 0.35, 2.6)
	await get_tree().create_timer(1.2).timeout
	_hum108.play()
	main.player.shake(0.15)
	await _play(L["turn"])
	main.learn("hush")
	main.log_line("scene", "Dufredy hummed the lullaby")
	ui.close()
	f["hospital_interviewed"] = true
	f.erase("cinematic")
	main.add_connection(2.0, "the lullaby")
	main.update_hud()


func _show_laptop() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var L: Dictionary = LINES["dufredy"]
	if f.has("hospital_laptop"):
		await _play(L["laptop_again"])
		return
	f["hospital_laptop"] = true
	main.play("on", -8.0, 0.6)
	ui.laptop_open(true)
	ui.laptop_log.append_text(L["laptop_log"])
	await _play(L["laptop"])
	create_tween().tween_property(duf_head, "rotation:z", 0.45, 1.0).set_trans(Tween.TRANS_SINE)
	await _play(L["laptop2"])
	main.learn("filter")


func _leave(dry := false) -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var L: Dictionary = LINES["leave"]
	if not f.has("hospital_interviewed"):
		await _play(L["early2"] if f.has("hospital_nurse") else L["early"])
		return
	if _ended:
		return
	_ended = true
	f["cinematic"] = true
	await _play(L["go"])
	ui.close()
	await ui.fade_to(1.0, 0.8)
	main.play("jingle", -16.0, 1.6)
	await _play(L["lynx"])
	ui.close()
	f.erase("cinematic")
	f["hospital_done"] = true
	if dry:
		_ended = false
		await ui.fade_to(0.0, 0.3)
		return
	main.load_level("Southtown")


func phone() -> String:
	var f: Dictionary = main.flags
	var P: Dictionary = LINES["phone"]
	var t: String = P["base"]
	if f.has("hospital_checkin"):
		t += P["checkin"]
	if f.has("hospital_interviewed"):
		t += P["done"]
	return t


func scan_people() -> Array:
	var out := []
	var S: Dictionary = LINES["scan"]
	var all: Array = patients + ward_people
	for p in all:
		var sync: String = S["humming"] if main.flags.has("hospital_interviewed") else "sync 9%d%%" % (all.find(p) % 10)
		out.append([p, S["patient"] % sync])
	if dufredy:
		out.append([dufredy, S["dufredy"]])
	return out


func apply_args(a: Dictionary) -> void:
	var f: Dictionary = main.flags
	if f.has("hospital_checkin"):
		nurse.visible = true
		nurse.position = Vector3(-2.4, 0.02, -8.5)
		turn_to(nurse, Vector3(0, 0, -4.0))
		set_active(nurse_body, true)
	if f.has("hospital_wing"):
		for k in ["wing_l", "wing_r", "ward_l", "ward_r"]:
			doors[k]["locked"] = false
		for k in ["wing_l", "wing_r"]:
			doors[k]["open"] = true
			(doors[k]["pivot"] as Node3D).rotation.y = float(doors[k]["ry"]) + float(doors[k]["angle"])
		door108.rotation.y = -1.7
		set_active(door108_body, false)
	if f.has("hospital_nurse"):
		nurse.position = Vector3(1.0, 0.02, -37.0)
		turn_to(nurse, Vector3(1.0, 0, -30.0))
	if f.has("hospital_interviewed"):
		duf_head.rotation.z = -0.7
		gauze_band.position = Vector3(0.0, 0.055, 0.0)
		gauze_band.rotation.x = 0.35
	if a.has("car"):
		my_car.position = Vector3(30.0, 0, 36.5)
	if a.has("open"):
		for k in ["staff", "102", "104", "108b"]:
			if not doors[k]["open"]:
				doors[k]["locked"] = false
				_swing(k)


func selftest() -> void:
	await intro()
	for id in ["bot", "button", "security", "orderly", "nurse", "door_wing_l", "door_staff", "door_102", "door_ward_l", "door_108", "door_108b", "room", "dufredy"]:
		for n in main._all_with_meta(self, "id"):
			if is_instance_valid(n) and str(n.get_meta("id")) == id:
				await main.interact(n)
				print("ok ", id)
				break
	while main.flags.has("cinematic"):
		await get_tree().process_frame
	await _leave(true)
	print("ok lynx")
	await main.selftest_all_interactables()
