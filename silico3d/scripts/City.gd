extends Node
## The open city. Main owns the state (day, hour, faith, devotion, hacks,
## incidents); this node runs the systems that move it, from the bible
## (design/bible-1-systems-and-ui.md: "Meters and state", "Day card",
## "Incidents", "Sacrifice", "Dreams", "Clock and schedules", "The city";
## bible-3 "The open city (Days 4-6)"; bible-2 "Act 1 openness"):
##
## - the clock: every story level sits at its bible day and hour (TIMES);
##   travel costs hours; sleep ends the day at 07:00; the Day card.
## - the districts and their Faith (0-3), rising from Day 4.
## - travel between places on the map (CityMap.gd): walk (+1 hour a street),
##   the company car (1 hour to a car spot) or, on PIP, the subway.
## - the scheduler: a story beat opens at its place, in its window, when its
##   predicate on state holds (BEATS). A level's hand-off to such a beat goes
##   to the open city instead; a beat's latest hour forces it.
## - incidents: the six authored ones on their flags, and from Day 4 two a
##   day in districts at Faith >= 1. Interface / Report / Bury / Let run.
## - sleep and the dream pool; the terminals are Terminal.gd.
##
## All player-facing text is in LINES. (game) marks a line written for the
## game, not taken from the book or the bible; ian rewrites those.

const TerminalS := preload("res://scripts/Terminal.gd")
const MapS := preload("res://scripts/CityMap.gd")

const LINES := {
	"glitch": ["", "Six days to Glitch Day.", "Five days to Glitch Day.", "Four days to Glitch Day.", "Three days to Glitch Day.",
		"Two days to Glitch Day.", "One day to Glitch Day.", "Glitch Day."],
	"card": {
		"incident": "INCIDENT",
		"story": "STORY",
		"faith": "FAITH",
		"none": "The feed is quiet. It is never quiet.",
		"from": "from %02d:00",
		"day_from": "Day %d, from %02d:00",
		"rose": "rose overnight in %d districts.",
		"tunnels": "The tunnels.",
		# a place card when Carl arrives somewhere in the open city
		"place": "[b]%s[/b]\n\n[color=#aaaaaa]%s  ·  Faith %d[/color]",
		"home": "[b]86D[/b]\n\n[color=#aaaaaa]Psyonic Tower, floor 86  ·  %s[/color]",
	},
	# the bible's district table: what each Faith level looks like
	"districts": {
		"lamplight": ["Lamplight", "Dufredy's building; residential blocks; the first car spot.",
			"Graffiti eye on Dufredy's door; a mourner.", "Vigil at the building; shuttered shops.", "The street is a congregation at night."],
		"canal_walk": ["Canal Walk", "The sand filtration unit; the canal path.",
			"Sand laid in rings everywhere.", "Vigil; the unit chants.", "Eyeless by the water."],
		"spine": ["The Spine", "HQ tower base, the plaza, the residential entrance, the charge post.",
			"A glyph on the charge post.", "Annie Seung's vigil; drones.", "The plaza kneels at outages."],
		"heights": ["The Heights", "Residential; Heights Primary; the drone ring.",
			"Towers in windows: the kids' tablets.", "Children's circle in a courtyard.", "The Seer's street; Mira's song from windows."],
		"hill_road": ["Hill Road", "SalTech hospital; the FreudBot booth.",
			"The follower appears at night.", "The booth recites to a crowd.", "Hospital doors say not yet without a bow."],
		"zeta_park": ["Zeta & Park", "The one camera that didn't go dark; Lynx's building.",
			"13 of 14 cameras dark.", "All cameras track Carl.", "Camera poles painted as eyes."],
		"harmony_green": ["Harmony Green", "The park, the benches, the retaining wall; the encampment.",
			"A tent ring forms.", "The jingle plays scripture.", "The park is a church."],
		"southtown": ["Southtown", "Southwest Station, the shanty town, the Tunelet plant, the overpass eye.",
			"Cult guards at the plant.", "Guards on the station.", "Everyone here is eyeless."],
		"fargona": ["Fargona Avenue", "The preacher's vigil; the road to the observatory.",
			"The preacher's vigil.", "The vigil blocks the road.", "The road is a procession."],
		"rail_cut": ["Rail Cut", "The substation; scrap yards; a Tunelet entrance.",
			"Glyphs on the substation.", "Eyeless at the entrance.", "The entrance is open and lit."],
		"red_rock": ["Red Rock", "The plaza, the monolith screen, the casino, Lushon's, the subway.",
			"Casino empty, scripture wet on the wall.", "Sober. The alley double.", "Lushon's is the only lit door."],
		"cognizo": ["Cognizo", "Cognizo tower, the station.",
			"A sealed train at the station.", "Cognizo staff praying in the lobby.", "Closed."],
		"park_ave": ["Park Avenue", "A through-street.",
			"The crowd appears.", "The crowd sings.", "The crowd has Carl's face."],
		"restricted_road": ["Restricted Road", "Containment Zone 1, the booth, the wreck, the gate.", "", "", ""],
	},
	"home": "86D",
	"feed": {
		"faith": "ORA  ·  %s: %s",
		"incident": "ORA ALERT  ·  %s  ·  %s",
		"expired": "ORA  ·  %s closed itself. Nobody came. (%s)",
		"travel": "%s  ·  %s",
		"beat": "The frames have a door for you: %s.",
	},
	"travel": {
		"walk": "on foot", "car": "the company car", "subway": "the subway", "lift": "the lift",
		"here": "You are here.", "hours": "%d h", "hour": "1 h", "none": "0 h",
		"locked": "Not on the map I'm allowed. Not yet.",
		"not_now": "(game) Not now. Whatever this is, it isn't finished with me.",
		"wait": "(game) An hour went by. The city didn't.",
	},
	# a story beat's door, by its step id: [where, the door's prompt, the objective]
	"beats": {
		"warroom1": ["Psyonic HQ, floor 96", "The tower doors: Integrations, floor 96", "Turan's waiting. The tower doors, floor 96."],
		"hospital": ["SalTech, Room 108", "The SalTech gate: Room 108", "SalTech. Dufredy is in Room 108."],
		"southtown": ["Southwest Station", "Southwest Station", "Southwest Station. Where the masked figure took him."],
		"home2": ["86D", "The residential entrance: 86D", "Home. Dinner."],
		"warroom2": ["Psyonic HQ, floor 96", "The tower doors: Integrations, floor 96", "The war room. The subway footage."],
		"lynxflat": ["Lynx's flat, floor 79", "Lynx's building", "Lynx's building. Floor 79."],
		"redrock": ["Red Rock Plaza", "Red Rock Plaza: Lushon's, under the red lanterns", "Red Rock. Lushon's, at nine."],
		"home4": ["86D", "The residential entrance: 86D", "Home. Monica is home."],
	},
	# the forced transition at a beat's latest hour (bible: "It's 21:00. The observatory.")
	"forced": "It's %02d:00. %s.",
	"forced_where": {"warroom1": "The war room", "hospital": "SalTech", "southtown": "Southtown", "home2": "Home",
		"warroom2": "The war room", "lynxflat": "Lynx", "redrock": "Red Rock", "home4": "Home"},
	"objective": {
		"open": "(game) The city is open. Tab for the map.",
		"next": "%s, %s. Tab for the map.",
		"here": "%s",
		"home": "(game) 86D. The terminal, the couch. Tab for the map.",
	},
	"sleep": {
		"ask": "Sleep until 07:00?",
		"yes": "Sleep.", "no": "Not yet.",
		"blocked": "Not yet. %s, %s.",
		"rest": "Rest until %02d:00.", "up": "Get up.",
		"beat_home": "(game) I lay down and didn't sleep. The door went before I did.",
		"no_sleep": "(game) I hadn't slept. The frames counted it for me.",
		"lie": "(game) I lay down on the couch facing the glass. The city kept its lights on for me.",
	},
	# the dream pool (bible-1 "Dreams"); the leaves are forced on Day 6 by Home
	"dreams": [
		["DUFREDY'S DESK", "(game) A desk in the woods. The clean desk from his flat, the laptop open on it, the cardboard path leading up through the pines. He sat with his back to me, typing. The trees leaned in to read.", "Psyon is the pillow for those who dream."],
		["THE COUNCIL CHAMBER", "(game) Mira's council round the brown table, all five of them, the knight and the bear and the girl with pigtails. Her chair was empty. They turned to me and pulled it out.", "All must walk the path alone."],
		["THE CLIFF DOOR", "(game) The girl in the yellow top stood at the door in the cliff, her back to me, one hand flat on the stone. The sand around her feet lay in rings. She was waiting for me to say the word.", "The floor is a door. The door is a floor."],
		["THE ARM", "(game) Owen's arm, in the rubble of the school, the sleeve still buttoned at the wrist. The hand opened when I got near it, palm up, like it wanted something put in it.", "A clean wound. Something has to break first."],
		["THE NICU GLASS", "(game) The glass of the NICU, and Mira behind it, so small, the wires on her. Monica humming on my side of the glass. Every incubator in the row had an eye painted on it.", "Look for the eye and know peace."],
		["THE HUM", "(game) The city from the inside: every wire a vein, every screen a lid. The hum was a voice holding one note so long it had forgotten it was a word.", "Gather, sleeper. Gather."],
	],
	"dream": {
		"bow": "Bow.", "wake": "Wake.",
		"bowed": "(game) I bowed. The line was already in my mouth.",
		"woke": "(game) I woke with my hands pressed together.",
		"no_choice": "(game) There was no waking from it. I bowed because I was already bowing.",
		"repeat": "You dreamed of %s. We were there.",
		"log": "Dreamed: %s",
	},
	# incidents: the six authored ones keep their pixel-game text (Game.gd INCIDENTS)
	"calls": ["Interface with it.   [+ Connection]", "Report it.   [+ Standing]", "Bury it.   [- Standing]", "Let it run."],
	"incident": {
		"no_frames": "No frames, no interface. Just a machine, doing the wrong thing.",
		"dive": "I put my hand on it and the frames took the rest. The street went away.",
		"dive_deep": "I didn't decide to touch it. The frames were already in.",
		"knew": "You already knew.",
		"scan": "The frames flagged this. Scan it (F), or look at it (E).",
		"buried_feed": "(game) A vigil will come to the place I buried.",
		"prompt": "Look at the %s",
	},
	"generated": {
		"devices": {
			"freudbot": ["FreudBot booth", "(game) A FreudBot booth on the corner, mid-session with nobody in the chair."],
			"drone": ["delivery drone", "(game) A delivery drone hanging at head height over the pavement, rotors running, going nowhere."],
			"kiosk": ["city kiosk", "(game) A city terminal kiosk, the transit map gone from its screen."],
			"shuttle": ["shuttle stop", "(game) A shuttle stop board, its timetable replaced by one line."],
			"tablet": ["dropped tablet", "(game) A child's tablet face up on a bench, the battery icon full, nobody's name on it."],
			"substation": ["substation box", "(game) A Voltx substation box with its door open and the breakers thrown in a pattern."],
			"ad": ["ad screen", "(game) An ad screen at shop height, the product gone from it, the brand gone from it."],
		},
		"faults": {
			"ring": ["laying rings", "(game) It was arranging things round itself in rings. Two of them, one inside the other."],
			"chant": ["chanting", "(game) It was saying the chant, one line at a time, to nobody in particular."],
			"convene": ["PLEASE CONVENE", "(game) It had two words for everyone who passed. PLEASE CONVENE."],
			"dreamer": ["asking for the dreamer", "(game) It asked everyone who walked past the same question. Are you the dreamer?"],
			"breathing": ["breathing", "(game) It was breathing. Four in, hold, four out. The street had started doing it with it."],
		},
		"card": "%s\nstatus: RUNNING\nfault: %s\nsince: %s",
		"fix": ["(game) It wanted a pattern and I gave it one. It stopped, and thanked me by name.",
			"(game) The fault ran out like a held breath. The device remembered me as I left."],
		"report": ["(game) I filed it. Somebody would come and replace a thing that had already replaced itself.",
			"(game) Reported. Turan's office logged it in four minutes and did nothing in five."],
		"bury": ["(game) I closed the ticket myself. Someone would light a candle here by the weekend.",
			"(game) I buried it. The frames filed the burial under a word I hadn't typed."],
		"run": ["(game) I left it running. Let it do what it was doing. Let someone else write it down.",
			"(game) I let it run. The street was already learning the words."],
		"log": "%s, %s: %s (%s).",
	},
	# the free visit home (Home.gd with City.free_home)
	"home_visit": {
		"door": "Take the lift down to the Spine",
		"terminal": "Use the home terminal",
		"terminal_scan": "PSYONIC HOME TERMINAL\nuser: DRAKE, C.\nsession: %s",
		"leave": "(game) The lift down. Eighty-six floors of nobody getting in.",
		"empty": "(game) Nobody home. Monica on 108, the kids at the retreat. The flat ran its lights for me anyway.",
		"kids_away": "(game) Her room, tidy, the way it never is when she's here.",
		"ezra": "(game) Ezra at the table with his headset pushed up on his forehead. \"Dad. Is Mira coming home?\"",
		"ezra_scan": "DRAKE, EZRA (10)\nhome: YES\nPsyon: OFF (BY REQUEST)",
	},
	"calls_log": {"fixed": "fixed", "reported": "reported", "buried": "buried", "let_run": "let run", "expired": "expired"},
	"toast": {
		"faith_up": "Faith +1   %s",
		"faith_down": "Faith -1   %s",
		"devotion": "Devotion +%d   %s",
		"standing_sleep": "a night's sleep",
		"dream_bow": "bowed in a dream",
		"dream_wake": "a dream",
		"interface": "the interface",
		"reported": "incident reported",
		"buried": "incident buried",
	},
}

## The six incidents as built (pixel game, scripts/Game.gd INCIDENTS), by
## district, each opening on its flag.
const INCIDENTS := {
	"filtration": {"title": "Sand filtration failure", "district": "canal_walk", "device": "substation", "unlock": "scene1_done",
		"notice": "VOLTX ticket 4471: canal walk filtration unit offline, third time this week.",
		"card": "VOLTX FILTRATION UNIT 7\nstatus: RUNNING\nintake: REVERSED\nlast service: 20 years",
		"found": "The unit was running. It was running backwards, pulling sand up out of the canal bed and laying it on the walk in rings. The Voltx tech had been clearing the same rings all morning.",
		"report": "I filed it. Turan's office would send a crew to replace a unit that had replaced itself twenty years ago.",
		"bury": "I closed the ticket as resolved. The rings could stay. Something in me wanted to see how wide they got.",
		"run": "I left it. Let Voltx find it. Let someone else write it down.",
		"fix": "I turned the rings until the intake read as an eye, and the unit stopped and ran the right way. The sand it had laid out stayed in its rings on the walk. I knew the next line of the chant without having read it anywhere.",
		"log": "Canal filtration unit reversed itself, laying sand in rings"},
	"shuttle": {"title": "SalTech shuttle sealed", "district": "spine", "device": "shuttle", "unlock": "park_done",
		"notice": "TRANSIT: SalTech shuttle 3 holding at the Spine stop. Doors unresponsive. Passengers aboard.",
		"card": "SALTECH SHUTTLE 3\nroute: TOWER LOOP\ndoors: SEALED\npassengers: 11, all asleep",
		"found": "The shuttle sat at the stop with its doors shut and eleven people inside, every one of them with their head back and their eyes closed. The destination board read the same line over and over: PLEASE CONVENE.",
		"report": "I called it in as a door fault. Turan's people had it towed with the passengers still inside.",
		"bury": "I wiped the destination log from the stop's terminal and walked on. Eleven sleepers, and I'd just made sure nobody would ask where they'd been going.",
		"run": "I watched for a while. Then the doors opened on their own and the passengers filed out, calm as a congregation, and went eleven different ways.",
		"fix": "Four notes, in time, and the doors sighed open. The eleven passengers filed out past me, calm as a congregation, and every one of them touched my sleeve on the way by.",
		"log": "SalTech shuttle 3 sealed with eleven sleepers aboard, the board reading PLEASE CONVENE"},
	"swarm": {"title": "Delivery drones rerouted", "district": "heights", "device": "drone", "unlock": "warroom1_done",
		"notice": "ORA ALERT: delivery drones rerouted mid-flight over the Heights. Avoid the area.",
		"card": "PSYONIC LOGISTICS SWARM\nunits: 6\nroute: REROUTED\npattern: RING, 4m, CENTRED ON RESIDENCE",
		"found": "Six delivery drones in a ring over one house, the way they'd rung Lynx's fiance's copter the night the outage killed him. Nobody home. The ring didn't drift.",
		"report": "I reported the swarm. Logistics pulled the units and sent a form letter to the house. The house didn't answer.",
		"bury": "I flagged the units as returned to depot and let the ring hang there. From the street it looked like a crown.",
		"run": "I left them circling. Lynx would want to know. I wasn't sure I wanted to be the one who told her.",
		"fix": "The route was a sentence and the sentence wanted a word. I gave it. The six drones broke the ring and flew home to the depot in single file, and the lights in the house came on, every one of them.",
		"log": "Six drones rerouted into a ring over a house in the Heights, the fault that killed Nathan"},
	"freudbot": {"title": "FreudBot booth malfunction", "district": "hill_road", "device": "freudbot", "unlock": "hospital_done",
		"notice": "SALTECH: FreudBot GPT booth on Hill Road reporting elevated session length. Attend.",
		"card": "FREUDBOT GPT  ·  BOOTH 12\nsession: 9h 41m\npatient: none\ndiagnosis: PLEASE CONVENE",
		"found": "The booth was mid-session with nobody in the chair. Its face was smiling on the screen, and it was saying the chant in a therapist's voice, the one that ends every interview. Any residual trauma should be looked after.",
		"report": "I reported the booth. SalTech sent a tech who sat in the chair to test it and didn't get up for an hour.",
		"bury": "I pulled the booth's plug and closed the ticket. It kept talking for a full minute on battery, slower each line.",
		"run": "I let it talk. It was forked, the same build as Dufredy's, and it was lonely. I'm not proud of that word.",
		"fix": "The booth wanted a patient and had one. It had been talking to me since I sat down, which I did not remember doing. I gave it my name and it ended the session, satisfied, and thanked me.",
		"log": "FreudBot booth on Hill Road reciting the chant to an empty chair"},
	"cameras": {"title": "Surveillance dark on the block", "district": "zeta_park", "device": "camera", "unlock": "southtown_done",
		"notice": "PSYONIC SECURITY: surveillance outage, Zeta and Park quadrant. One unit responding.",
		"card": "SURVEILLANCE UNIT ZP-04\nblock status: 1 of 14 ONLINE\ntracking: CARL DRAKE\nuptime: since the footage",
		"found": "Every camera on the block was dark but this one, and this one had been following me since I turned the corner. It wasn't recording the street. It was recording me.",
		"report": "I reported the quadrant outage. Security's answer came back in four minutes: the block was fully operational. Fourteen of fourteen.",
		"bury": "I cut the unit's feed at the box. The lens kept turning after the power was gone, slowly, until it found me again.",
		"run": "I let it watch. If it wanted me, it could have me. I wanted to see who came to collect the footage.",
		"fix": "The lens assembly was rings on a spindle. When they lined up it stopped tracking me and swung back to the street, and the thirteen dark cameras on the block woke up one after another and turned, all of them, to face the tower.",
		"log": "Thirteen cameras dark on Zeta and Park, the fourteenth tracking me"},
	"tablets": {"title": "School tablets running the Password Game", "district": "heights", "device": "tablet", "unlock": "ritual_seen",
		"notice": "CORPORATE TRAINING: Heights primary reporting unauthorised app on 212 student tablets.",
		"card": "HEIGHTS PRIMARY  ·  DEVICE FLEET\ntablets: 212\nforeground app: THE PASSWORD GAME\nsource: a friend showed me",
		"found": "Two hundred and twelve school tablets, every one of them running the game Mira had been playing on the kitchen floor. The lights in the windows were nightlights. It was eleven in the morning.",
		"report": "I reported it to corporate training. They wiped the fleet overnight. By the second day the game was back on nine of them, and by the third on all of them.",
		"bury": "I didn't report it. If it went up the chain it went to Monica, and Monica would ask where Mira learned it.",
		"run": "I let the tablets be. You can't destroy the children's school devices. Monica had said that, and she was right, and that was the problem.",
		"fix": "The fleet wanted the breathing. I gave it the four notes and two hundred and twelve screens went dark together, and the nightlights with them. The fleet logged me as the teacher.",
		"log": "The Password Game on 212 school tablets in the Heights"},
}

## Districts: walking roads between them (hours), car spots, the subway.
const DISTRICT_IDS := ["lamplight", "canal_walk", "spine", "heights", "hill_road", "zeta_park", "harmony_green",
	"southtown", "fargona", "rail_cut", "red_rock", "cognizo", "park_ave", "restricted_road"]
const ROADS := [["home", "spine", 0], ["lamplight", "spine", 1], ["lamplight", "canal_walk", 1], ["canal_walk", "harmony_green", 1],
	["spine", "zeta_park", 1], ["spine", "heights", 2], ["heights", "hill_road", 1], ["spine", "southtown", 2],
	["zeta_park", "park_ave", 1], ["park_ave", "cognizo", 1], ["park_ave", "fargona", 1], ["cognizo", "rail_cut", 1],
	["rail_cut", "southtown", 1], ["rail_cut", "red_rock", 1], ["southtown", "restricted_road", 1]]
const CAR_SPOTS := ["home", "spine", "lamplight", "zeta_park", "red_rock", "cognizo", "heights"]
const SUBWAY := ["red_rock", "cognizo", "southtown"]
## Faith rises every second day here (the Spine, Red Rock: Lushon's keeps it, Cognizo).
const SLOW := ["spine", "red_rock", "cognizo"]

## Where each story level sits on the clock: step -> [day, from, day_to, to].
## Hours past 23 belong to the same day until sleep (bible: "the game treats
## the late return as Day 1 night").
const TIMES := {
	"dufredy": [1, 21, 1, 22], "drive": [1, 22, 1, 22], "park": [1, 22, 1, 24], "spine": [1, 24, 1, 25],
	"home1": [1, 25, 1, 25], "warroom1": [2, 8, 2, 11], "hospital": [2, 11, 2, 14], "southtown": [2, 14, 2, 19],
	"home2": [2, 19, 2, 23], "warroom2": [3, 8, 3, 10], "lynxflat": [3, 10, 3, 13], "flats": [3, 13, 3, 17],
	"mirror": [3, 17, 3, 17], "facility": [3, 17, 3, 20], "hangar": [3, 20, 3, 22], "home3": [3, 22, 3, 23],
	"blackout": [3, 23, 3, 24], "observatory": [3, 24, 3, 25], "holdingcell": [4, 9, 4, 11],
	"redrock": [5, 20, 5, 23], "spa": [5, 24, 6, 9], "cognizo": [6, 9, 6, 19], "home4": [6, 19, 6, 21],
	"tunnels": [7, 0, 7, 1], "bronzehands": [7, 1, 7, 2], "interlude": [7, 2, 7, 3], "river": [7, 3, 7, 4],
	"core": [7, 4, 7, 5], "chair": [7, 5, 7, 6],
}
## Where Carl is when a step ends (the open city starts there).
const PLACE_AFTER := {"home1": "home", "home2": "home", "warroom1": "spine", "warroom2": "spine",
	"hospital": "hill_road", "southtown": "southtown", "holdingcell": "home", "cognizo": "cognizo",
	"redrock": "red_rock", "lynxflat": "zeta_park", "park": "harmony_green", "spine": "spine"}

## The scheduler's beats (bible: "scene gates are predicates on state, not
## previous scene"). A beat is open at `place` from Day `day` `from`:00 while
## every flag in `needs` is set and `done` is not; at `latest`:00 it is forced.
const BEATS := [
	{"step": "warroom1", "level": "WarRoom", "place": "spine", "needs": ["home1_done"], "done": "warroom1_done", "day": 2, "from": 8, "latest": 18},
	{"step": "hospital", "level": "Hospital", "place": "hill_road", "needs": ["warroom1_done"], "done": "hospital_done", "day": 2, "from": 11, "latest": 20},
	{"step": "southtown", "level": "Southtown", "place": "southtown", "needs": ["hospital_done"], "done": "southtown_done", "day": 2, "from": 14, "latest": 22},
	{"step": "home2", "level": "Home", "place": "home", "needs": ["southtown_done"], "done": "home2_done", "day": 2, "from": 18, "latest": 23},
	{"step": "warroom2", "level": "WarRoom", "place": "spine", "needs": ["home2_done"], "done": "warroom2_done", "day": 3, "from": 8, "latest": 12},
	{"step": "lynxflat", "level": "LynxFlat", "place": "zeta_park", "needs": ["warroom2_done"], "done": "lynx_apartment_done", "day": 3, "from": 9, "latest": 15},
	{"step": "redrock", "level": "RedRock", "place": "red_rock", "needs": ["holdingcell_done"], "done": "lushons_done", "day": 5, "from": 20, "latest": 23},
	{"step": "home4", "level": "Home", "place": "home", "needs": ["broadcast_seen"], "done": "home4_done", "day": 6, "from": 19, "latest": 21},
]

## People the fork will take (bible-1 "Sacrifice", "Characters"): base value,
## district, the flag that means Carl has investigated them, and words in the
## ledger that count as investigating them (+1 each, capped at 10).
const PEOPLE := {
	"agata": {"name": "Agata Greenwood", "base": 3, "district": "harmony_green", "met": "park_done", "keys": ["Agata", "Greenwood"]},
	"seth": {"name": "Seth McCarren", "base": 2, "district": "harmony_green", "met": "park_done", "keys": ["Seth", "McCarren"]},
	"officer": {"name": "The officer from Lamplight", "base": 2, "district": "zeta_park", "met": "scene1_done", "keys": ["officer"]},
	"nurse": {"name": "The nurse at SalTech", "base": 2, "district": "hill_road", "met": "hospital_done", "keys": ["nurse"]},
	"annie": {"name": "Annie Seung", "base": 3, "district": "spine", "met": "blackout_done", "keys": ["Annie", "Seung"]},
	"tyson": {"name": "Tyson Clerif", "base": 6, "district": "harmony_green", "met": "park_done", "keys": ["Tyson", "Clerif"]},
}

var main: Node
var map: Control
var terminal: Control
## Where Carl is in the open city: a district id, or "home".
var district := "spine"
## The next Home load is the free visit (the hub), not a story visit.
var free_home := false
## The story step on screen ("" in the open city).
var cur_step := ""
## Set when Carl walks through a beat's door, so the hand-off isn't rerouted.
var _entering := ""
## The level a hand-off asked for, if the scheduler has nothing better.
var fallback := ""
## The strict chain, for testing (--linear=1).
var linear := false
var dream_line := ""      # last night's dream, which the fork repeats next day
var dream_index := 0
var _gen_n := 0
var _forcing := false
var sys_test := false     # --systems=1 runs with the scheduler on
var _frames_t := 0.0
var rng := RandomNumberGenerator.new()


func setup(m: Node) -> void:
	main = m
	rng.seed = 7
	map = MapS.new()
	main.ui.root.add_child(map)
	map.setup(main, self)
	terminal = TerminalS.new()
	main.ui.root.add_child(terminal)
	terminal.setup(main, self)
	# the map and the terminal draw under the fade, the title and the end card
	main.ui.root.move_child(map, main.ui.fade.get_index())
	main.ui.root.move_child(terminal, main.ui.fade.get_index())
	reset()


func reset() -> void:
	main.day = 1
	main.hour = 21
	main.devotion = 0
	main.hacks = []
	main.incidents = {}
	main.faith = {}
	for d in DISTRICT_IDS:
		main.faith[d] = 0
	district = "spine"
	free_home = false
	cur_step = ""
	_entering = ""
	fallback = ""
	dream_line = ""
	dream_index = 0
	_gen_n = 0


# ------------------------------------------------------------------ the clock

func now_abs() -> int:
	return int(main.day) * 24 + int(main.hour)


func clock_text() -> String:
	return "Day %d  ·  %02d:00" % [main.day, int(main.hour) % 24]


func is_night() -> bool:
	var h := int(main.hour) % 24
	return h >= 20 or h < 6


## Move the clock forward to day d, hour h (never back). A later day than
## today is a silent morning (a dev start, or the spa's night).
func set_time(d: int, h: int) -> void:
	if d * 24 + h <= now_abs():
		return
	if d > int(main.day):
		_new_day(d, h)
	else:
		main.hour = h
	main.update_hud()


## Hours pass: the afternoon wave of incidents, expiries.
func advance(h: int) -> void:
	if h <= 0:
		return
	var before := int(main.hour)
	main.hour = int(main.hour) + h
	if int(main.day) >= 4 and before < 15 and int(main.hour) >= 15:
		_spawn_incident()
	_open_authored()
	_expire_incidents()
	main.update_hud()


func glitch_line(d: int) -> String:
	var g: Array = LINES["glitch"]
	return str(g[clampi(d, 0, g.size() - 1)])


## The Day card (bible-1): "Day 4" and "Three days to Glitch Day.", and under
## them the feed's morning list: incidents, the day's story beat and its
## earliest hour, the district that changed. Three seconds, or any key.
## `headline` is the level's own card text when it has one.
func day_card(d: int, headline := "", wake := 7) -> void:
	_new_day(d, wake)
	await main.ui.show_day(day_card_text(headline))


func day_card_text(headline := "") -> String:
	var d := int(main.day)
	var c: Dictionary = LINES["card"]
	var t := headline
	if t == "":
		t = "[b]Day %d[/b]\n\n[color=#aaaaaa]%s[/color]" % [d, glitch_line(d)]
	var rows := []
	var n := 0
	for id in main.incidents:
		var inc: Dictionary = main.incidents[id]
		if inc["state"] == "open" and n < 2:
			rows.append("[color=#e0453a]%s[/color]   %s  ·  %s" % [c["incident"], district_name(inc["district"]), inc["title"]])
			n += 1
	var b := next_beat_any()
	if not b.is_empty():
		var when: String = c["from"] % int(b["from"]) if int(b["day"]) == d else c["day_from"] % [int(b["day"]), int(b["from"])]
		rows.append("[color=#f5d6a0]%s[/color]   %s  ·  %s" % [c["story"], LINES["beats"][b["step"]][0], when])
	elif d >= 7:
		rows.append("[color=#f5d6a0]%s[/color]   %s" % [c["story"], c["tunnels"]])
	if _faith_changed.size() > 0:
		var first: String = _faith_changed[0]
		rows.append("[color=#ff4fd8]%s[/color]   %s  %s" % [c["faith"], district_name(first), _faith_line(first)])
	if rows.is_empty():
		rows.append("[color=#888888]%s[/color]" % c["none"])
	t += "\n\n[font_size=17][color=#c8d0d4]" + "\n".join(rows) + "[/color][/font_size]"
	return t


var _faith_changed: Array = []


## A new morning: Faith rises from Day 4, incidents open and expire.
func _new_day(d: int, wake: int) -> void:
	var from_day := int(main.day)
	main.day = d
	main.hour = wake
	_faith_changed = []
	for dd in range(from_day + 1, d + 1):
		_morning(dd)
	main.flags.erase("bowed_today")
	main.update_hud()


func _morning(d: int) -> void:
	if d >= 4:
		if not main.flags.has("city_tithe"):
			# what Carl has already given: every glyph read, ritual, scripture and bow in the ledger
			main.flags["city_tithe"] = true
			var tithe := int(main.glyphs_found)
			for e in main.ledger:
				var k: String = str(e.get("kind", ""))
				if k in ["ritual", "scripture", "dream", "baptism"] or "bow" in str(e.get("text", "")).to_lower():
					tithe += 1
			main.devotion += tithe
		for id: String in DISTRICT_IDS:
			if id == "restricted_road":
				continue
			if id in SLOW and d % 2 == 1:
				continue
			var was := int(main.faith.get(id, 0))
			var now := mini(3, was + 1)
			if id == "fargona":
				now = maxi(now, 2)
			if now != was:
				main.faith[id] = now
				_faith_changed.append(id)
		for id: String in _faith_changed:
			feed(LINES["feed"]["faith"] % [district_name(id), _faith_line(id)])
	_open_authored()
	if d >= 4:
		_spawn_incident()
	_expire_incidents()


# ------------------------------------------------------------------ districts and Faith

func district_name(id: String) -> String:
	if id == "home":
		return LINES["home"]
	return str(LINES["districts"][id][0]) if LINES["districts"].has(id) else id


func _faith_line(id: String) -> String:
	var f := int(main.faith.get(id, 0))
	var row: Array = LINES["districts"].get(id, [])
	if row.is_empty():
		return ""
	return str(row[1]) if f <= 0 else str(row[1 + f])


func faith_of(id: String) -> int:
	return int(main.faith.get(id, 0))


func add_faith(id: String, d: int, why := "") -> void:
	if not main.faith.has(id):
		return
	var was := int(main.faith[id])
	var now := clampi(was + d, 0, 3)
	if now == was:
		return
	main.faith[id] = now
	main.ui.show_toast((LINES["toast"]["faith_up"] if d > 0 else LINES["toast"]["faith_down"]) % district_name(id), 2.5)
	feed(LINES["feed"]["faith"] % [district_name(id), _faith_line(id)])
	main.log_line("faith", "%s %+d %s" % [district_name(id), d, why])


func add_devotion(n: int, why: String) -> void:
	main.devotion = int(main.devotion) + n
	main.ui.show_toast(LINES["toast"]["devotion"] % [n, why], 2.5)


## The ORA feed ticker along the bottom of the HUD.
func feed(text: String) -> void:
	main.ui.feed_push(text)


# ------------------------------------------------------------------ travel

func _adj() -> Dictionary:
	var a := {}
	for r: Array in ROADS:
		a[r[0]] = a.get(r[0], []) + [[r[1], int(r[2])]]
		a[r[1]] = a.get(r[1], []) + [[r[0], int(r[2])]]
	return a


## Walking hours between two places (Dijkstra on the street graph).
func walk_hours(a: String, b: String) -> int:
	if a == b:
		return 0
	var adj := _adj()
	var dist := {a: 0}
	var todo := [a]
	while not todo.is_empty():
		todo.sort_custom(func(x, y): return dist[x] < dist[y])
		var cur: String = todo.pop_front()
		for e: Array in adj.get(cur, []):
			var nd: int = dist[cur] + int(e[1])
			if not dist.has(e[0]) or nd < int(dist[e[0]]):
				dist[e[0]] = nd
				todo.append(e[0])
	return int(dist.get(b, 99))


func car_ok() -> bool:
	return main.flags.has("warroom1_done") and not main.flags.has("pip_active")


## The cheapest way from here to `to`: [hours, mode].
func route(to: String) -> Array:
	var from := district
	if from == to:
		return [0, "here"]
	var best := [walk_hours(from, to), "walk"]
	if (from == "home" and to == "spine") or (from == "spine" and to == "home"):
		return [0, "lift"]
	if car_ok():
		for c: String in CAR_SPOTS:
			var h := 1 + walk_hours(c, to)
			if h < int(best[0]):
				best = [h, "car"]
	var f2 := "spine" if from == "home" else from
	var t2 := "spine" if to == "home" else to
	if f2 in SUBWAY and t2 in SUBWAY and int(best[0]) > 2:
		best = [2, "subway"]
	return best


func can_travel(to: String) -> bool:
	if to == "restricted_road":
		return false
	return to == "home" or DISTRICT_IDS.has(to)


## True while Carl is in the open city (a street or the free visit home).
func in_hub() -> bool:
	return main.level_name == "Street" or (main.level_name == "Home" and free_home)


## Travel on the map: hours pass, a beat may force itself, then the place.
func travel(to: String) -> void:
	if not can_travel(to) or not in_hub():
		return
	var r := route(to)
	advance(int(r[0]))
	main.log_line("travel", "%s -> %s (%s, %dh)" % [district_name(district), district_name(to), r[1], int(r[0])])
	if await check_forced():
		return
	go(to)


## Load a place in the open city: a district street, or 86D. A home beat
## that is open takes the home visit instead of the free one.
func go(to: String) -> void:
	district = to
	if to == "home":
		var hb := beat_at("home")
		if not hb.is_empty():
			enter_beat(hb)
			return
		free_home = true
		main.load_level("Home")
	else:
		free_home = false
		main.load_level("Street")


func wait_hour() -> void:
	advance(1)
	main.ui.show_toast(LINES["travel"]["wait"], 2.0)
	await check_forced()
	if is_instance_valid(main.level) and main.level.has_method("refresh_city"):
		main.level.refresh_city()


func place_card() -> String:
	var c: Dictionary = LINES["card"]
	if district == "home":
		return c["home"] % clock_text()
	return c["place"] % [district_name(district).to_upper(), clock_text(), faith_of(district)]


# ------------------------------------------------------------------ the scheduler

## The story step a level load is, read from the flags (Home and the war room
## are visited more than once).
func step_of(lname: String) -> String:
	var f: Dictionary = main.flags
	match lname:
		"Home":
			if f.has("broadcast_seen") and not f.has("home4_done"):
				return "home4"
			if f.has("hangar_done") and not f.has("home3_done"):
				return "home3"
			if f.has("southtown_done") and not f.has("home2_done"):
				return "home2"
			if not f.has("home1_done"):
				return "home1"
			return ""
		"WarRoom":
			return "warroom2" if f.has("warroom1_done") else "warroom1"
		"Street":
			return ""
	return lname.to_lower()


func beat_for(step: String) -> Dictionary:
	for b: Dictionary in BEATS:
		if b["step"] == step:
			return b
	return {}


func needs_met(b: Dictionary) -> bool:
	for fl: String in b["needs"]:
		if not main.flags.has(fl):
			return false
	return not main.flags.has(b["done"])


## Open now: the predicate holds and the window has started.
func is_open(b: Dictionary) -> bool:
	return needs_met(b) and now_abs() >= int(b["day"]) * 24 + int(b["from"])


## Every beat whose predicate holds, open or not yet (the map marks them).
func pending() -> Array:
	var out := []
	for b: Dictionary in BEATS:
		if needs_met(b):
			out.append(b)
	return out


func beat_at(place: String) -> Dictionary:
	for b: Dictionary in pending():
		if b["place"] == place and is_open(b):
			return b
	return {}


## The next beat for the Day card and the objective: the first one not done
## from today on, predicate or not.
func next_beat_any() -> Dictionary:
	for b: Dictionary in BEATS:
		if not main.flags.has(b["done"]) and int(b["day"]) >= int(main.day):
			return b
	return {}


## Main.load_level asks here first. A level handing off to a beat the city
## opens goes to the open city instead (where the hand-off ended); a beat
## whose predicate does not hold loads as it always did (the old chain).
func before_load(lname: String) -> String:
	var prev := cur_step
	if prev != "" and TIMES.has(prev):
		var t: Array = TIMES[prev]
		set_time(int(t[2]), int(t[3]))
	if lname == "Street" or (lname == "Home" and free_home):
		cur_step = ""
		_open_authored()
		return lname
	free_home = false
	var step := step_of(lname)
	var b := beat_for(step)
	if _routing() and prev != "" and _entering != step and not b.is_empty() and needs_met(b):
		fallback = lname
		var hub: String = PLACE_AFTER.get(prev, str(b["place"]))
		district = hub
		cur_step = ""
		_open_authored()
		feed(LINES["feed"]["beat"] % LINES["beats"][step][0])
		if hub == "home":
			free_home = true
			return "Home"
		return "Street"
	_entering = ""
	cur_step = step
	if TIMES.has(step):
		var t: Array = TIMES[step]
		set_time(int(t[0]), int(t[1]))
	return lname


func _routing() -> bool:
	return not linear and (not main._selftest or sys_test) and not main.shot_mode and main.started


## Walk through a beat's door.
func enter_beat(b: Dictionary) -> void:
	_entering = str(b["step"])
	free_home = false
	district = str(b["place"])
	main.load_level(str(b["level"]))


## A beat past its latest hour is forced (bible: "It's 21:00. The
## observatory."). Also the morning after a night with no sleep. True if
## something took over.
func check_forced() -> bool:
	if _forcing or not in_hub():
		return false
	for b: Dictionary in pending():
		if now_abs() >= int(b["day"]) * 24 + int(b["latest"]):
			_forcing = true
			await main.ui.think(LINES["forced"] % [int(b["latest"]), LINES["forced_where"][b["step"]]])
			main.ui.close()
			_forcing = false
			enter_beat(b)
			return true
	if int(main.hour) >= 31:
		_forcing = true
		await main.ui.think(LINES["sleep"]["no_sleep"])
		main.ui.close()
		await day_card(int(main.day) + 1)
		_forcing = false
		main.load_level("Home" if district == "home" else "Street")
		return true
	return false


## The objective line in the open city.
func objective() -> String:
	var o: Dictionary = LINES["objective"]
	var here := beat_at(district)
	if not here.is_empty():
		return o["here"] % LINES["beats"][here["step"]][2]
	var p := pending()
	if p.is_empty():
		return o["home"] if district == "home" else o["open"]
	var b: Dictionary = p[0]
	var when: String = LINES["card"]["from"] % int(b["from"]) if int(b["day"]) == int(main.day) else LINES["card"]["day_from"] % [int(b["day"]), int(b["from"])]
	return o["next"] % [LINES["beats"][b["step"]][0], when]


# ------------------------------------------------------------------ incidents

func _open_authored() -> void:
	# the city opens on Day 2 (bible-2 "Act 1 openness")
	if int(main.day) < 2:
		return
	for id: String in INCIDENTS:
		if main.incidents.has(id):
			continue
		var data: Dictionary = INCIDENTS[id]
		if main.flags.has(data["unlock"]):
			main.incidents[id] = {"id": id, "title": data["title"], "district": data["district"], "device": data["device"],
				"state": "open", "opened": now_abs(), "gen": false}
			feed(LINES["feed"]["incident"] % [district_name(data["district"]), data["notice"]])


## The generator (bible-1 "Incidents"): device x district x fault, in a
## district at Faith >= 1 with nothing open.
func _spawn_incident() -> void:
	var choices := []
	for d: String in DISTRICT_IDS:
		if d == "restricted_road" or faith_of(d) < 1:
			continue
		var busy := false
		for id in main.incidents:
			if main.incidents[id]["district"] == d and main.incidents[id]["state"] == "open":
				busy = true
		if not busy:
			choices.append(d)
	if choices.is_empty():
		return
	var g: Dictionary = LINES["generated"]
	var devs: Array = g["devices"].keys()
	var faults: Array = g["faults"].keys()
	var d: String = choices[rng.randi() % choices.size()]
	var dev: String = devs[rng.randi() % devs.size()]
	var fault: String = faults[rng.randi() % faults.size()]
	_gen_n += 1
	var id := "gen_%d_%d" % [int(main.day), _gen_n]
	var title := "%s %s" % [str(g["devices"][dev][0]).capitalize(), g["faults"][fault][0]]
	main.incidents[id] = {"id": id, "title": title, "district": d, "device": dev, "fault": fault,
		"state": "open", "opened": now_abs(), "gen": true}
	feed(LINES["feed"]["incident"] % [district_name(d), title])


func _expire_incidents() -> void:
	for id in main.incidents:
		var inc: Dictionary = main.incidents[id]
		if inc["state"] == "open" and now_abs() - int(inc["opened"]) >= 24:
			inc["state"] = "expired"
			# an ignored incident pushes Faith only so far: 3 comes with the days
			if faith_of(inc["district"]) < 2:
				add_faith(inc["district"], 1, "expired")
			feed(LINES["feed"]["expired"] % [inc["title"], district_name(inc["district"])])


func open_incidents_in(d: String) -> Array:
	var out := []
	for id in main.incidents:
		if main.incidents[id]["district"] == d and main.incidents[id]["state"] == "open":
			out.append(main.incidents[id])
	return out


func incident_text(inc: Dictionary, key: String) -> String:
	if not inc["gen"]:
		return str(INCIDENTS[inc["id"]].get(key, ""))
	var g: Dictionary = LINES["generated"]
	match key:
		"card":
			return g["card"] % [str(g["devices"][inc["device"]][0]).to_upper(), str(g["faults"][inc["fault"]][0]).to_upper(), clock_text()]
		"found":
			return str(g["devices"][inc["device"]][1]) + " " + str(g["faults"][inc["fault"]][1])
		"log":
			return inc["title"]
		"fix", "report", "bury", "run":
			var pool: Array = g[key]
			return str(pool[rng.randi() % pool.size()])
	return ""


## An incident found: the four calls (bible-1 "Incidents").
func run_incident(id: String) -> void:
	var ui = main.ui
	if not main.incidents.has(id):
		return
	var inc: Dictionary = main.incidents[id]
	var L: Dictionary = LINES["incident"]
	await ui.think(incident_text(inc, "found"))
	var pick: int = await ui.choose(LINES["calls"])
	ui.close()
	var outcome := ""
	match pick:
		0:
			if not main.frames_on:
				await ui.think(L["no_frames"])
				ui.close()
				return
			main.play("glitch", -6.0)
			ui.glitch(0.8, 0.8)
			await ui.think(L["dive_deep"] if main.connection >= 50.0 else L["dive"])
			if main.connection >= 50.0:
				await ui.say("Psyon", L["knew"])
			await ui.think(incident_text(inc, "fix"))
			ui.close()
			advance(1)
			main.add_connection(5.0, LINES["toast"]["interface"])
			add_devotion(1, LINES["toast"]["interface"])
			main.add_stance("sleeper")
			add_faith(inc["district"], -1, "fixed")
			outcome = "fixed"
		1:
			await ui.think(incident_text(inc, "report"))
			ui.close()
			main.add_pressure(-3.0, LINES["toast"]["reported"])
			outcome = "reported"
		2:
			await ui.think(incident_text(inc, "bury"))
			ui.close()
			main.add_pressure(1.0, LINES["toast"]["buried"])
			add_faith(inc["district"], 1, "buried")
			outcome = "buried"
		_:
			await ui.think(incident_text(inc, "run"))
			ui.close()
			add_faith(inc["district"], 1, "let run")
			outcome = "let_run"
	inc["state"] = outcome
	inc["call_day"] = int(main.day)
	main.log_line("incident", LINES["generated"]["log"] % [clock_text(), district_name(inc["district"]), incident_text(inc, "log"), LINES["calls_log"][outcome]])
	main.update_hud()


# ------------------------------------------------------------------ sleep and dreams

## The couch at home. Sleep is +3 pressure (Calm: +2) and a dream; a beat
## still open today keeps Carl up, or takes the night if it is at home.
func sleep() -> void:
	var ui = main.ui
	var S: Dictionary = LINES["sleep"]
	for b: Dictionary in pending():
		if int(b["day"]) <= int(main.day):
			if b["place"] == "home" and is_open(b):
				await ui.think(S["beat_home"])
				ui.close()
				enter_beat(b)
				return
			var when: String = LINES["card"]["from"] % int(b["from"])
			await ui.think(S["blocked"] % [LINES["beats"][b["step"]][0], when])
			var opts := [S["up"]]
			if now_abs() < int(b["day"]) * 24 + int(b["from"]):
				opts.append(S["rest"] % int(b["from"]))
			var i: int = await ui.choose(opts)
			ui.close()
			if i == 1:
				advance(int(b["day"]) * 24 + int(b["from"]) - now_abs())
				await check_forced()
				if is_instance_valid(main.level) and main.level.has_method("refresh_city"):
					main.level.refresh_city()
			return
	await ui.think(S["lie"])
	var c: int = await ui.choose([S["yes"], S["no"]])
	ui.close()
	if c != 0:
		return
	await sleep_now()


func sleep_now() -> void:
	main.add_pressure(2.0 if main.tower_rooms.has("calm") else 3.0, LINES["toast"]["standing_sleep"])
	await dream()
	await day_card(int(main.day) + 1)
	main.log_line("sleep", "slept to Day %d, 07:00" % int(main.day))
	if in_hub():
		main.load_level("Home" if district == "home" else "Street")


## One dream from the pool: a picture in words, then Bow (+3, a chant line)
## or Wake (+1). Past 50 there is no choice.
func dream() -> void:
	var ui = main.ui
	var D: Dictionary = LINES["dream"]
	var pool: Array = LINES["dreams"]
	var dr: Array = pool[dream_index % pool.size()]
	dream_index += 1
	await ui.fade_to(1.0, 1.2)
	main.play("whisper", -10.0, 0.6)
	await ui.say(dr[0], dr[1])
	var bow := true
	if main.connection < 50.0:
		var i: int = await ui.choose([D["bow"], D["wake"]])
		bow = i == 0
	else:
		await ui.think(D["no_choice"])
	if bow:
		await ui.say("", "[i]%s[/i]\n\n[b]%s[/b]" % [D["bowed"], dr[2]])
		ui.close()
		main.add_connection(3.0, LINES["toast"]["dream_bow"])
		add_devotion(1, LINES["toast"]["dream_bow"])
		main.add_stance("sleeper")
		main.flags["bowed_today"] = true
	else:
		await ui.think(D["woke"])
		ui.close()
		main.add_connection(1.0, LINES["toast"]["dream_wake"])
	dream_line = str(dr[0]).to_lower()
	main.log_line("dream", D["log"] % dr[0])


# ------------------------------------------------------------------ home (the free visit)

## Dress 86D for a visit with no scene: nobody home (Ezra, if he came back
## from the observatory), the home terminal on the east wall, the door out.
func dress_home(h: Node) -> void:
	var V: Dictionary = LINES["home_visit"]
	for fig in [h.monica, h.mira, h.mira_floor]:
		h._hide(fig)
	if not (main.flags.has("ezra_home") and int(main.day) >= 4):
		h._hide(h.ezra)
	if h.front_body:
		h.front_body.set_meta("prompt", V["door"])
	# the terminal: a slim desk and a screen on the east wall, by the hall
	var wood: Material = h.pbr("woodfloor", Vector3(1, 1, 1) / 1.0, true, Color(0.42, 0.33, 0.25))
	var dark: Material = h.mat(Color(0.03, 0.03, 0.035), 0.3, 0.4)
	var fork: bool = main.connection >= 25.0
	var sc := Color(1.0, 0.31, 0.85) if fork else Color(0.3, 1.0, 0.6)
	h.box(Vector3(0.55, 0.05, 1.3), Vector3(5.66, 0.76, -2.3), wood, true)
	for z: float in [-2.85, -1.75]:
		h.box(Vector3(0.05, 0.74, 0.05), Vector3(5.5, 0.37, z), dark)
	h.box(Vector3(0.05, 0.62, 0.95), Vector3(5.9, 1.25, -2.3), dark)
	var scr: MeshInstance3D = h.quad(Vector2(0.88, 0.54), Vector3(5.87, 1.25, -2.3), -PI / 2.0, h.glow(sc, 1.3, true))
	h.no_batch.append(scr)
	h.box(Vector3(0.25, 0.02, 0.5), Vector3(5.55, 0.79, -2.3), h.mat(Color(0.2, 0.2, 0.22), 0.4))
	h.light(Vector3(5.2, 1.3, -2.3), sc, 0.6, 3.5)
	h.interactable("home_terminal", V["terminal"], Vector3(5.7, 1.1, -2.3), Vector3(0.7, 0.9, 1.3), V["terminal_scan"] % ("FORKED" if fork else "OPEN"), false)


## Home's interactions in the free visit; false lets Home answer as usual.
func home_interact(id: String) -> bool:
	var ui = main.ui
	var V: Dictionary = LINES["home_visit"]
	match id:
		"front_door":
			await ui.think(V["leave"])
			ui.close()
			go("spine")
		"couch":
			await sleep()
		"home_terminal":
			ui.close()
			await open_terminal("home")
		"ezra":
			await ui.say("", V["ezra"])
		"monica", "mira", "mira_floor", "sketchbook":
			await ui.think(V["empty"])
		"mira_door", "tablet", "circle":
			await ui.think(V["kids_away"])
		_:
			return false
	return true


# ------------------------------------------------------------------ the map and terminals

func open_map() -> void:
	map.open()


func open_terminal(where: String) -> void:
	await terminal.run(where)


## Carl's frames time is an offering (bible: +1 devotion per 30 minutes of
## frames time); in game, every three minutes of real time with them on.
func _process(delta: float) -> void:
	if not main or not main.started or not main.frames_on or main.loading:
		return
	_frames_t += delta
	if _frames_t >= 180.0:
		_frames_t = 0.0
		main.devotion = int(main.devotion) + 1


# ------------------------------------------------------------------ dev and screenshots

## Dev args: day=N hour=N district=id linear=1 devotion=N; for shots
## map=1 daycard=1 terminal=home|kiosk|tower|trade|give.
func apply_args(a: Dictionary) -> void:
	if a.has("linear"):
		linear = true
	if a.has("district"):
		district = str(a["district"])
		if district == "home":
			free_home = true
	if a.has("devotion"):
		main.devotion = int(a["devotion"])
	if a.has("faith"):
		for d in DISTRICT_IDS:
			main.faith[d] = int(a["faith"])


func apply_time_args(a: Dictionary) -> void:
	if a.has("day"):
		main.day = int(a["day"])
	if a.has("hour"):
		main.hour = int(a["hour"])
	main.update_hud()


## Before a screenshot: open what the shot is of.
func shot_args(a: Dictionary) -> void:
	if a.has("daycard"):
		_new_day(int(main.day), int(main.hour))
		main.ui.show_day_static(day_card_text())
	if a.has("map"):
		map.open()
		if a.has("mapsel"):
			map.select(str(a["mapsel"]))
	if a.has("terminal"):
		terminal.show_static(str(a["terminal"]))


# ------------------------------------------------------------------ the systems self-test (--systems=1)

var _fails := 0


func _ok(name: String, cond: bool, info := "") -> void:
	if cond:
		print("SYS ok ", name, "  ", info)
	else:
		_fails += 1
		print("SYS FAIL ", name, "  ", info)


## Run one step of the test, bounded by a real-time timeout.
func _sys(name: String, step: Callable, secs := 60.0) -> bool:
	var st := {"done": false}
	var run := func() -> void:
		await step.call()
		st["done"] = true
	run.call()
	var t0 := Time.get_ticks_msec()
	while not st["done"] and Time.get_ticks_msec() - t0 < int(secs * 1000.0):
		await get_tree().process_frame
	if not st["done"]:
		_fails += 1
		print("SYS TIMEOUT ", name, " after ", secs, "s")
	return st["done"]


## Wait for a level to be on screen and settled, bounded.
func _await_level(lname: String, secs := 60.0) -> bool:
	var t0 := Time.get_ticks_msec()
	while (main.level_name != lname or main.loading) and Time.get_ticks_msec() - t0 < int(secs * 1000.0):
		await get_tree().process_frame
	for i in 10:
		await get_tree().process_frame
	return main.level_name == lname and not main.loading


## The open city end to end: the clock and the Day card, the scheduler
## routing a hand-off to the city, the home terminal (Tower, trades), the
## map's routes and travel, a street with its incident and kiosk, sleep and
## a dream, the beat opening in its window and forcing at its latest hour,
## sacrifice. Every wait has a timeout.
func selftest_systems() -> void:
	sys_test = true
	Engine.time_scale = 4.0
	var watchdog := get_tree().create_timer(1500.0, true, false, true)
	watchdog.timeout.connect(func():
		print("SYS TIMEOUT watchdog")
		get_tree().quit(1))
	var ui = main.ui
	var pump := func() -> void:
		while main._selftest:
			await get_tree().process_frame
			ui.advanced.emit()
			ui.picked.emit(1)
	pump.call()
	# the state the holding cell leaves: Act 1 and the set pieces done, Day 4 morning
	for fl in ["opening_seen", "scene1_done", "park_done", "home1_done", "warroom1_done", "hospital_done", "southtown_done",
			"home2_done", "ritual_seen", "warroom2_done", "lynx_apartment_done", "desert_done", "mirror_done", "act1_done",
			"facility_done", "hangar_done", "home3_done", "blackout_done", "observatory_done", "watched_observatory",
			"freudbot_1", "pip_active", "holdingcell_done"]:
		main.flags[fl] = true
	main.connection = 40.0
	for w in ["hush", "look away", "convene", "sleeper", "we"]:
		main.learn(w)
	main.log_line("evidence", "Mira's drawing of the Tower, the council, the shadow, the eye")
	main.log_line("person", "Seth McCarren, the Voltx electrician, at the bench")
	main.day = 3
	main.hour = 25
	# 1. the Day card and the morning: Faith, incidents
	await _sys("day card", func(): await day_card(4, ""), 30.0)
	_ok("clock day 4", int(main.day) == 4 and int(main.hour) == 7, clock_text())
	_ok("faith rose", faith_of("lamplight") == 1 and faith_of("fargona") == 2 and faith_of("spine") == 1, str(main.faith))
	_ok("incidents open", main.incidents.size() >= 6, str(main.incidents.keys()))
	_ok("day card text", "Three days" in day_card_text() and "Red Rock" in day_card_text(), day_card_text().replace("\n", " | "))
	_ok("devotion tithe", main.flags.has("city_tithe"), "devotion %d" % int(main.devotion))
	# 2. the scheduler: the holding cell hands off to Red Rock; the city takes it home instead
	cur_step = "holdingcell"
	main.load_level("RedRock")
	var at_home := await _await_level("Home", 90.0)
	_ok("hand-off routed to the city", at_home and free_home and district == "home", "%s free=%s %s" % [main.level_name, free_home, clock_text()])
	_ok("clock after the holding cell", now_abs() >= 4 * 24 + 11, clock_text())
	_ok("beat pending, not open", not pending().is_empty() and beat_at("red_rock").is_empty(), objective())
	print("SYS objective: ", main.level.objective())
	# 3. the home terminal: Carl's Tower, the trade, the menus
	main.devotion = 12
	var c0: float = main.connection
	await _sys("tower: focus", func(): await terminal.build_room("focus"), 20.0)
	_ok("tower room", main.tower_rooms == ["focus"] and main.connection >= c0 + 3.0 and int(main.devotion) == 9, "%s conn %d dev %d" % [main.tower_rooms, int(main.connection), int(main.devotion)])
	await _sys("terminal menu (home)", func(): await open_terminal("home"), 90.0)
	_ok("terminal menus", main.tower_rooms.size() >= 1, "rooms %s traded %s hacks %s" % [main.tower_rooms, main.traded, main.hacks])
	if not main.traded.has("photo"):
		await _sys("trade", func(): await terminal.trade("we", "photo"), 20.0)
	_ok("trade", main.traded.size() >= 1 and main.flags.has("traded_" + str(main.traded[0])) and main.hacks.size() >= 3, "traded %s hacks %s" % [main.traded, main.hacks])
	var blanked := false
	for e in main.ledger:
		if str(e.get("text", "")) == TerminalS.LINES["trade"]["blank"]:
			blanked = true
	_ok("traded memory blanked in the ledger", blanked or not main.traded.has("drawing"))
	# 4. the map: routes, then travel on foot (PIP: no car)
	map.open()
	map.select("red_rock")
	await get_tree().process_frame
	map.close()
	var r := route("red_rock")
	_ok("route home -> red rock", int(r[0]) >= 2 and r[1] != "car", str(r))
	var h0 := now_abs()
	await _sys("travel red rock", func(): await travel("red_rock"), 30.0)
	var on_street := await _await_level("Street", 90.0)
	_ok("travel", on_street and district == "red_rock" and now_abs() == h0 + int(r[0]), "%s %s" % [district, clock_text()])
	# 5. a street: the incident, the kiosk, the people, the ends
	if open_incidents_in("red_rock").is_empty():
		_spawn_incident_in("red_rock")
		main.load_level("Street")
		await _await_level("Street", 60.0)
	var inc_id: String = main.level._incident_id
	_ok("incident on the street", inc_id != "", inc_id)
	await _sys("street selftest", func(): await main.level.selftest(), 240.0)
	_ok("incident called", inc_id != "" and main.incidents[inc_id]["state"] != "open", str(main.incidents.get(inc_id, {}).get("state", "")))
	# 6. walk on to another district and back home (the lift on the Spine)
	await _sys("travel lamplight", func(): await travel("lamplight"), 30.0)
	_ok("travel lamplight", await _await_level("Street", 90.0) and district == "lamplight", clock_text())
	await _sys("travel home", func(): await travel("home"), 30.0)
	_ok("travel home", await _await_level("Home", 90.0) and free_home, clock_text())
	# 7. sleep: +3 pressure, a dream, the Day 5 card
	var p0: float = main.pressure
	await _sys("sleep", func(): await sleep_now(), 60.0)
	await _await_level("Home", 90.0)
	_ok("slept to day 5", int(main.day) == 5 and int(main.hour) == 7 and main.pressure > p0, "%s pressure %d dream %s" % [clock_text(), int(main.pressure), dream_line])
	# 8. the beat opens in its window: Day 5, 20:00, at Red Rock
	set_time(5, 20)
	_ok("beat open at 20:00", not beat_at("red_rock").is_empty(), objective())
	# 9. sacrifice (after Lushon's; the flag set here only to test the list)
	main.flags["lushons_done"] = true
	var people: Array = terminal.givable()
	_ok("givable", people.size() >= 3, str(people))
	await _sys("give", func(): await terminal.give("seth"), 20.0)
	_ok("given", main.given.has("seth"), str(main.given))
	main.flags.erase("lushons_done")
	# 10. the latest hour forces the beat: 23:00, Red Rock
	set_time(5, 23)
	var res := {"forced": false}
	await _sys("forced", func(): res["forced"] = await check_forced(), 30.0)
	var in_rr := await _await_level("RedRock", 120.0)
	_ok("forced at 23:00", res["forced"] and in_rr, "%s %s" % [main.level_name, clock_text()])
	print("SYSTEMS DONE fails=", _fails, " clock=", clock_text(), " faith=", main.faith, " devotion=", main.devotion,
		" rooms=", main.tower_rooms, " traded=", main.traded, " hacks=", main.hacks, " given=", main.given,
		" incidents=", main.incidents.size(), " pressure=", int(main.pressure), " conn=", int(main.connection))
	main._selftest = false
	get_tree().quit()


## For the test: an incident in a given district now.
func _spawn_incident_in(d: String) -> void:
	main.faith[d] = maxi(1, faith_of(d))
	_gen_n += 1
	var id := "gen_test_%d" % _gen_n
	main.incidents[id] = {"id": id, "title": "Ad screen chanting", "district": d, "device": "ad", "fault": "chant",
		"state": "open", "opened": now_abs(), "gen": true}
