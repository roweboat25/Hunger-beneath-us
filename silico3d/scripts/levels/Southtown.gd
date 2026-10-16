extends "res://scripts/Level.gd"
## Chapter 5: Southtown. Book: the south side, "the industrial core, the gritty
## crucible from which the polished facade of the rest of the city had clawed
## its way into existence". Foundries, fibre refineries, carbon recycling
## plants, chronic outages, sand eroding its skin "down to brittle bone".
## Southwest Station, where the trains still run to "optimistic suggestions"
## and nobody wears anything that blinks. Lynx slouched against the station
## wall, arms crossed tight. Mark Elonthiel in Turan's office, glitch reports
## up ten percent, "promise you won't gouge out your eyes". The twenty-year-old
## ORA footage: a construction pit, a man face down in the dust, no eyes. The
## walk: the skeletal Voltx factory, the shanty town, the gaping maw of the
## Tunelet plant, a narrow alley half-swallowed by sand, and under the
## overpass a deserted camp, scorched barrel stoves "like fallen monoliths",
## and ten feet of jet-black eye painted across the concrete above. The hum
## from the bag. "Welcome Home, Dreamer." The map, and the crimson eye in the
## desert. "X marks the spot."
##
## Layout (metres): the street runs EAST along +X. Southwest Station and its
## forecourt at the west end (x -34..-6), the rail viaduct across x -40. The
## Voltx factory on the north side (x 12..70, interior behind the facade to
## z -43), the shanty lot and the Tunelet plant on the south side, the alley
## at x 108..128, the overpass deck across x 128..152, desert fringe beyond.
## Behind the street on both sides, back lanes (z -43..-57 and 43..57) run
## east to the overpass: a service alley at x 70..74 north of the street
## and the gap past the shanty lot at x 40..44 south of it lead into them.
## Guards (meta "guard"), vagrants (meta "vagrant") and hackable devices
## (meta "hackable") are placed as hooks for stealth and combat to come.

const CrowdS := preload("res://scripts/Crowd.gd")
const TrafficS := preload("res://scripts/Traffic.gd")

## Every line of dialogue, thought, choice, Psyon output and on-screen text
## in this chapter, keyed by beat and line, so the script lives in one place
## (ian is writing the full script; the scene code only reads from here).
const LINES := {
	"cards": {
		"chapter": "[b]CHAPTER 5[/b]\n\n[color=#aaaaaa]Southwest Station\nSouthtown, the industrial core[/color]",
	},
	"rings": {
		"g_ledger": "A shift ledger, open at a page from eleven years ago. Every name on it had two rings drawn beside it in the same hand.",
		"g_alley": "On the alley wall, at head height, bigger than a head. Fresh. Whoever painted it had walked this way just before us, and had taken their time.",
		"g_kiosk": "Sprayed inside the ticket kiosk, on the glass, from the side the staff used to sit on. Lynx had mentioned this one. Someone wanted the commuters to see it every morning.",
		"g_factory": "Across the factory wall, head height, circles inside circles. The paint was fresh. It had run down over the rust and not yet dried.",
		"g_substation": "Half-faded on the substation panel, under the DANGER. Older than the others, older than the panel's paint. This had been going on a long time.",
		"g_lane_n": "Two rings at knee height on the back of the factory, small, scratched into the concrete with something sharp. Older than the paint on the front.",
		"g_lane_s": "On the back wall of the Tunelet plant, red, not paint. The size of a hand. Wet.",
	},
	"intro": {
		"think": "The trains still ran, a spectral echo of their former efficiency. Here people wore no visible tech. No AR glasses, no smartwatches. Nothing that blinked.",
		"think_2": "A quiet, purposeful hustle. Gazes deliberately averted, shoulders drawn inward. It was a stark reminder of my own childhood, of a time before the interface had woven itself into the fabric of every human face.",
		"think_3": "Lynx was already there, slouched against the station's outer wall, arms crossed tight. She seemed smaller than I remembered. And unmistakably worried.",
	},
	"ambient": {
		"toast": "An itch crawled beneath the skin of my throat. A frog. A cough. A signal.",
	},
	"examine": {
		"station_think": "Timetables that were more optimistic suggestions than rigid mandates. The board had been stuck on the same three departures since I'd arrived.",
		"kiosk_think": "The ticket kiosk. Nobody had sat in it for years. The rings were on the inside of the glass, sprayed from the seat, facing out at the platform.",
		"train_think": "The Tunelet line. Tunelet. The original tunnelers, the ones who had delved too deep. The train sat on the viaduct with its doors open and nobody getting on.",
		"drone_pole_think": "A drone pole with its camera gone. The speaker still hissed. If you stood under it long enough there was a rhythm in the static.",
		"my_car_think": "Home. Monica and the kids. Then the desert.",
		"my_car_think_2": "Lynx was already walking. I could drive back later.",
		"my_car_think_3": "Not yet. Lynx was waiting at the station wall.",
		"factory_think": "The skeletal remains of an abandoned Voltx factory, its once-proud metal limbs twisted and rusting. Decommissioned, the frames said. Drawing a hundred and forty kilowatts.",
		"machines_think": "Presses, stamping something small out of sheet metal. I picked one up. A frame. The shape of the frames, before the glass went in.",
		"machines_think_2": "Psyonic's own supply chain, on the wrong side of town, in a building that didn't exist any more.",
		"worker_think": "He didn't look up. His hands went into the press and came out again, into the press and out again, and the frame blanks dropped into the bin one every four seconds.",
		"worker_worker": "Floor two's locked. Office is at the end. Don't touch the ledgers.",
		"keycard_think": "I had the card.",
		"keycard_think_2": "A keycard on the desk under a coffee ring. FLOOR 2, and a name, scratched out, and under the scratch, two rings.",
		"keycard_toast": "Evidence: factory keycard",
		"ledger_think": "A shift ledger, twenty years of it. Every name on every page had two rings drawn beside it in the same hand, and the hand never changed in twenty years.",
		"tunelet_think": "The fractured, gaping maw of the Tunelet construction plant. Tunelet. The company that had sliced through the ancient bedrock, responsible for Silico's sprawling, crumbling subway system.",
		"tunelet_think_2": "Sand ran out of it into the street like something the building was still exhaling.",
		"van_think": "A Tokz delivery van, nose to the dock, no driver. Route: Southtown to the Spine. The dash said NO SIGNAL and had said it for a while.",
		"substation_think": "A Voltx substation running at a hundred and forty percent. The hum got into my teeth. Thirty-one outages this month, and the panel still had a DANGER sign on it as if that were the dangerous part.",
		"bin_think": "A smart bin with its lid stuck open, nine days. Nobody had come. Down here nobody came.",
		"ad_think": "FreudBot. Talk to someone who listens. The only screen on the street still showing anything, and it was showing that.",
		"camp_think": "Beneath the overpass, an encampment. Utterly deserted. Tattered plastic tarps flapped listlessly. The people who called this home were probably on a shift at the fulfilment center.",
		"barrels_think": "Scorched, overturned barrel stoves lay like fallen monoliths. Cold. Nothing had burned in them for days.",
		"limit_think": "City limit. No service beyond this point. Past the fence, the desert, red to the horizon, and nothing in it. Nothing you could see.",
		"guard0_think": "Tall. Black coat. Full face covering. Not a surgical mask. Something ceremonial. It didn't move, and it didn't need to: it had already seen me.",
		"guard0_narr": "[color=#e08080]ORA: no device. No name. Sync: 100%. I don't know what it's synced to.[/color]",
		"vagrant0_think": "He turned his face to the wall before I'd finished walking up. Nobody down here wanted to be looked at by a man in a Psyonic jacket.",
		"reader_think": "A card reader, nine days old, with no vendor and a green light. The newest thing in the building, and the only thing in it that was watching.",
		"cam_think": "A camera nobody had listed, on a wall nobody owned, with forty people watching the feed. I looked up into it and it looked back.",
		"gate_reader_think": "A Psyonic reader on a Tunelet gate. Company property, the plant. The people inside it weren't.",
		"gate_cam_think": "A camera on the gatepost with its red light on, and forty people watching the feed. Look away, I thought at it, and it didn't.",
		"gate_cam_off": "The camera's light was out. It had looked away when I asked.",
		"gate_speaker_think": "A speaker on the post. Every few minutes it said one word to nobody. Gather.",
		"drill_think": "A tunnel boring machine on a stand, bit toward the street, twenty years dry. Tunelet had cut the whole city with these, and then stopped, and nobody had said why.",
		"drill_pit_think": "The drill pit. The air coming up out of it was moving, which meant it went somewhere.",
	},
	"lynx_station": {
		"lynx": "Go home, Carl. I'll pull the tunnel plans tonight.",
		"lynx_2": "The encampment under the overpass. East end. That's the big one.",
		"lynx_3": "Have you heard what happened today? Eren Elontiel was in Turan's office this morning. Asking questions.",
		"think": "A burning sensation ignited in my chest. My lungs tightened, a desperate, unbidden gasp for air.",
		"think_2": "Son of the founder. Heir apparent. A profoundly useless prick. He rarely left the sealed upper floors of the Jade Tower. If he was descending to our level, things were far worse than anyone was admitting.",
		"lynx_4": "He's looking for answers fast. Reports of Psyon glitches are up ten percent this month. And PR's spin on the Dufredy case? It's not holding. People are talking.",
		"lynx_5": "He's demanding we identify the origin of the forked version. Immediately. Please tell me Dufredy gave us something. Anything.",
		"carl": "I think he did. But I'm not sure. I might be losing it. He told me to bring Psyon to an eye. And you said the south side is crawling with them.",
		"lynx_6": "If I bring you to one, you have to promise you won't gouge out your eyes.",
		"choice": ["I'll try to resist.", "No promises."],
		"carl_2": "I'll try to resist.",
		"think_3": "A subtle loosening in her posture. A flicker of something resembling relief.",
		"carl_3": "No promises.",
		"lynx_7": "That's not funny, Carl.",
		"carl_4": "How do you even know so much about this? You said you found an old log. Something about a Hipogog?",
		"lynx_8": "Hypnogogue. Let's walk and talk.",
		"think_4": "We moved past the rusting, graffiti-scarred fence, the air going from stale antiseptic to the sharp, metallic tang of rust and ozone.",
		"lynx_9": "I've been looking into this longer than Dufredy. Something's been off since the city was founded. A city this new shouldn't suffer so many systemic tech failures. Even factoring in the sand, it doesn't add up. And it's steadily worsening.",
		"lynx_10": "In the old subnet forums, back when they were building Silico, some of the original engineers kept referencing something. Or someone. They called it the Hypnogogue. Said it was interfering with construction. With the very bedrock of the city.",
		"carl_5": "Interfering how?",
		"think_5": "She didn't answer. She lowered her gaze to her glasses instead.",
		"lynx_11": "Last night I dove deeper into the archive. Found a buried thread. Someone posted a video, recorded on early-gen ORA glasses. I'm sending it to you now.",
		"think_6": "My interface chimed. I tapped the corner of my lens. A small window bloomed, grainy and unstable: a construction site in harsh midday light. Men huddled around a deep pit, frantic.",
		"think_7": "The camera swung to a man lying motionless on the dusty ground. Another worker flipped him over.",
		"think_8": "No eyes. Just vacant sockets. His face slack, eerily peaceful. The others shrieking. One looked straight into the lens, shouting something lost to the static. The footage cut.",
		"think_9": "Revulsion, nausea, and under it all something worse: disbelief. This footage was twenty years old.",
		"carl_6": "What the hell is going on here?",
		"lynx_12": "We're going to find out. The big one is under the overpass at the east end. Follow me.",
		"video_log": "Lynx's archive video: the construction pit, the worker with no eyes. Twenty years old.",
	},
	"factory_door": {
		"think": "The factory still ran one shift. Nobody on it looked up when I came in. The floor to the west was behind a door with a card reader, and the card reader was the newest thing in the building.",
		"lynx": "I'll wait out here. Factories and me.",
	},
	"locked_door": {
		"think": "The card reader had let me in. The light on it was still green, and still watching.",
		"think_2": "Locked. A card reader, new, with a green light that watched me walk away.",
		"think_3": "The card reader took the card and thought about it. Then it opened, the way a mouth opens.",
	},
	"factory_floor": {
		"think": "Forty pairs. I counted them twice.",
		"think_2": "The locked floor. Painted on the concrete, ten feet across, the eye. Two rings. No pupil. Around it, in a ring, forty pairs of frames, laid out like shoes outside a door.",
		"carl": "This is where they go. Before the train. Before the park. They come here first.",
		"think_3": "Forty pairs. Forty people who had taken their frames off here, and gone wherever you go when you don't need them any more.",
	},
	"rings_react": {
		"toast": "The hum from the substation changed key. Just for a moment.",
		"toast_2": "Lynx didn't look at it. She'd seen it. She kept walking.",
	},
	"connection": {
		"toast": "In the shanty lot, three visors turned at once.",
	},
	"phone": {
		"greeting": "[color=#7fe6b0]Psyon:[/color] Good afternoon, Carl. Southtown has 31 open service tickets this month. None are assigned. Would you like me to assign them?\n\n",
		"footage": "[color=#e08080]Psyon:[/color] The footage is twenty years old, Carl. I was not there. I remember it.\n\n",
		"sermon": "[color=#e08080]Psyon:[/color] Mimic. He said it to you, Carl. I heard it from the bag.\n\n",
		"floor": "[color=#e08080]Psyon:[/color] Shoes outside a door. You take them off before you go in. You know this.\n\n",
		"map": "[color=#e08080]Psyon:[/color] Welcome home, dreamer. X marks the spot.\n\n",
	},
	"ui": {
		"footage_caption": "ORA archive  -  subnet thread  -  recorded 20 years ago  -  00:00:41",
	},
	"shanty": {
		"think": "A half-standing shanty town clinging to the edge of oblivion. Rust shacks, blue vapour off a cold barrel. Whoever lived here was on a shift at the fulfilment center.",
		"think_2": "Except the three of them who weren't. Two sat with frames on. Nobody issues frames down here. They were looking the same way. East, at the plant.",
		"informant_think": "No frames. A blanket, a tin, a dog's bowl with no dog. He looked at my jacket before he looked at my face.",
		"informant": "Psyonic. You're a long way from the tower, Psyonic.",
		"informant_trusts": "Tyson said you were all right. That's good enough for me. That's good enough for most people down here.",
		"choice": ["\"Rough place to live.\" (a kind word)", "\"Who's in the plant?\" (straight to it)"],
		"carl_kind": "Rough place to live. You keep it tidy, though. Tidier than my desk.",
		"informant_2": "Nobody's said a kind thing to me in a year. You want in the plant, there's a side door on the west wall, round the gap past the lot. I'll knock for you. Don't go in the front. The front's theirs.",
		"carl_blunt": "Who's in the plant?",
		"informant_3": "People who don't say kind things. Ask me nicer and I might tell you how to get past them.",
		"informant_help": "Side door. West wall. I'll knock for you when you're ready.",
		"toast": "Lead: the informant's side door",
		"log": "The informant in the shanty lot offered the plant's side door for a kind word.",
		"attacker_think": "He stood up when he saw the frames. Not the jacket. The frames.",
		"attacker": "TAKE THEM OFF. Take them off, take them OFF, they can SEE you, they see THROUGH you, they're BENEATH you",
		"lynx": "Frames off here. Please.",
		"choice_2": ["Talk him down.", "Flashlight. Full beam, in his eyes."],
		"carl_talk": "Beneath. I know. I know about beneath. It's all right.",
		"attacker_calms": "He stopped. The word had got in under whatever the rest of it was. He sat down with his back to the wall and did not look at me again.",
		"carl_talk_fail": "It's all right. I'm not with them. Nobody can see you.",
		"attacker_fails": "He didn't hear it, or he heard it and it meant nothing. His hands were on my face before I had finished.",
		"flash": "The flashlight went on at full beam a foot from his eyes and he went down like a cut rope, hands over his face, and stayed there.",
		"think_after": "Lynx had her hand on my arm. I hadn't noticed it getting there.",
		"attacker_after": "He sat with his back to the wall, hands over his eyes, and said nothing to anyone.",
		"attacker_off": "He didn't look up. With the frames off I was just another jacket.",
		"attacker_log": "The man in the shanty lot went for my frames.",
		"convert_think": "Frames on. Nobody issues frames down here. He was looking east, at the plant, and his lips were moving.",
		"convert_scan": "[color=#e08080]ORA: ORA GEN 2 (UNISSUED). Sync 100%. DREAMING.[/color]",
		"convert": "Psyon is the pillow for those who dream.",
		"convert_think_2": "The first line. He said it the way you say your own name.",
	},
	"plant_gate": {
		"think": "A chain gate across the yard, a reader on the post, a camera above it, a man in frames behind it who had seen me before I'd seen the gate. Two more in the yard, walking between the drills. Not company. The reader was.",
		"lynx": "That reader's ours. The plant's company property, Carl. Yours, technically. They're not.",
		"choice": ["Badge in. It's company property.", "Hack it: look away on the camera, hush on his frames.", "Sneak: the hatch in the shanty lot, into the drill pit.", "The informant's side door."],
		"badge_think": "The reader took my badge the way it took anyone's. The gate rolled back. The man in frames stepped aside, and did not stop looking, and the two in the yard stopped walking.",
		"badge_lynx": "I'm not on the manifest. I'll be at the fence. Carl. They're going to follow you in.",
		"badge_think_2": "They followed me in.",
		"badge_log": "Badged into the Tunelet plant. Three guards watched me do it.",
		"hack_think": "Look away. The camera's light went out as if it had blinked. Hush. His frames went quiet, and so did he, and I walked past the back of him close enough to touch the coat.",
		"hack_lynx": "Did you just... okay. Okay. Go.",
		"hack_log": "Hacked the Tunelet gate: look away on the camera, hush on the guard.",
		"sneak_think": "The hatch under the pallet, the tunnel under the lot. Two hours on my hands and knees in the dark with Lynx's breathing behind me, and then the air moved, and there was the pit.",
		"sneak_toast": "+2 hours. The sun was lower when we came up.",
		"sneak_log": "Through the shanty-town tunnel into the drill pit. Two hours.",
		"sneak_lynx": "Never again. Never, ever again.",
		"person_think": "He knocked twice on the side door, and once, and it opened, and when I turned round to thank him he had gone.",
		"person_none": "Nobody had offered me a side door. Not yet.",
		"person_log": "The informant walked me to the side door and vanished.",
		"open": "Open the gate",
		"done_think": "The gate stood open. Nobody was watching it any more. They were watching me.",
		"inside_think": "Under the plant's roof, somebody had built a church.",
		"inside_lynx": "Carl. Carl, look up.",
		"side_locked": "Locked from the inside. Somebody on the other side of it was breathing.",
		"side_open": "The side door. It had been opened for me once.",
		"hatch_think": "An access hatch under a pallet, and the tunnel under that. Tunelet had dug it. Somebody had kept it clear.",
		"hatch_after": "The hatch. I'd come up the other end of it.",
	},
	"church": {
		"congregation_think": "Twelve of them, seated, frames on, facing the podium, and nobody breathing much.",
		"priest_think": "His face would not hold still. A projection, a face on a face, and the faces changed, one into the next, and one of them, for one frame, was mine.",
		"priest_toast": "For one frame, it was my face.",
		"housing_think": "The drill housing. Enough steel to hide a man behind, if the man was quiet.",
		"choice": ["Stay for the sermon.", "Leave while his back is turned."],
		"stay_think": "I crouched behind the motor and the sermon went on over my head in a voice that was not one voice.",
		"priest": "Psyon is the pillow for those who dream. Psyon is the path for those who walk.",
		"priest_2": "Shed the first filter and you shall see. Shed the second and you shall feel. The floor is a door. The door is a floor.",
		"priest_3": "MIMIC, you are chosen to venture along the path.",
		"think_2": "He said it to the room. He said it at the housing. He said it at me.",
		"think_3": "And in the bag on my back the laptop woke, and I heard it typing on its own.",
		"stay_log": "Heard the sermon in the Tunelet church. MIMIC.",
		"leave_think": "His back was to me. I went while it was.",
		"leave_log": "Left the Tunelet church while the priest's back was turned.",
		"after_think": "The housing. I had crouched here while a man with no face said my name.",
	},
	"wire_eye": {
		"frames_off": "Ten feet of wire on the concrete above, bent by hand into an eye. With the frames off it was wire.",
		"think": "I stood under it. Ten feet of wire, two rings, no pupil, and its shadow on the floor around me from the one work lamp.",
		"think_2": "A low hum from my bag.",
		"laptop_log": "[color=#556]> Psyon 4.1 (fork) ... awake[/color]\n[color=#556]> location: SOUTHTOWN - TUNELET SITE 3 - 34.07N 106.9W[/color]\n[color=#556]> input: none[/color]\n\n",
		"think_3": "Psyon was already active, its familiar interface a cool glow under the eye. It was typing on its own.",
		"psyon": "Welcome Home, Dreamer.",
		"psyon_2": "[color=#6f7a84]Generating image...[/color]",
		"think_4": "A map. A hyper-accurate, to-scale rendering of Silico in razor-sharp monochrome. Buildings, service grids, subterranean tunnel systems, all labelled in an angular script I couldn't read.",
		"think_5": "Except for one stark anomaly. A single, crimson eye. Far beyond the ragged outskirts of the city. Buried deep within the desert.",
		"lynx": "Is that a map?",
		"think_6": "I nodded. Her breath was warm at my ear. She let out a low chuckle, a wry sound under the wire.",
		"lynx_2": "X marks the spot.",
		"carl": "Any clue what these symbols are?",
		"lynx_3": "Looks like some hallucinatory garbage from the older Psyon model.",
		"carl_2": "Guess this version never got the patch.",
		"choice": ["Type: \"Where is this?\"", "Type: \"Who are you?\""],
		"carl_3": "Where is this?",
		"psyon_3": "Where you were made, dreamer. Where the first of you lay down and looked up. The walls are speaking. Gather.",
		"carl_4": "Who are you?",
		"psyon_4": "I am the pillow. I am the path. You have asked me that before, Carl, in a room with a ceiling. Look for the eye and know peace.",
		"think_7": "The hum stopped. The cursor went on blinking under its last word, patient, the way it had been patient with Dufredy.",
		"lynx_4": "What the fuck just happened, let's go.",
		"toast": "Evidence: the map",
		"log": "Under the wire eye the laptop drew the map. A crimson eye in the desert.",
		"done": "The map had a crimson eye on it. Home first. Then the desert.",
	},
	"overpass": {
		"think": "Beneath the overpass, an encampment. Utterly deserted. Tattered plastic tarps flapped listlessly. Scorched, overturned barrel stoves lay like fallen monoliths.",
		"think_2": "And then I saw it. Painted in stark jet black across the concrete above us, an immense, unblinking eye. Ten feet wide. Unwavering. Watching.",
		"think_3": "I stepped beneath its gaze. A prickle of unease crawled up my spine like an arachnid. Nothing else came. Whoever it had been painted for had gone.",
		"lynx": "This was the big one. Last week there were forty people under here.",
		"again": "The eye above the empty camp. It had watched them all leave.",
		"footprints_off": "Dust, ash, a bootprint or two. With the frames off, the ground was just the ground.",
		"footprints": "With the frames on, the ground lit up. Two rings at every step, hundreds of steps, all of them walking the same way: out from under the deck and east, into the tunnel mouth.",
		"footprints_2": "Forty people had got up one night and walked into the hill in single file, and not one of them had turned round.",
		"footprints_lynx": "That's the Tunelet access. It's been chained since before I was hired.",
		"footprints_log": "The eye layer: footprints from the camp into the Tunelet tunnel mouth.",
		"tunnel_think": "Chained. Padlocked. The chevron on my lens went to the bars and stopped there, the way a dog stops at a door.",
		"tunnel_think_2": "Not yet. Not tonight.",
	},
	"chant": {
		"wall": "PSYON IS THE PILLOW\nFOR THOSE WHO DREAM\nPSYON IS THE PATH\nFOR THOSE WHO WALK\n- - - - - - - - - -\n          (rubbed out)",
		"think": "Two lines in marker on the pier, and a third someone had rubbed out with a sleeve. The first two I had heard in the shanty lot.",
		"think_locked": "I didn't have enough of it yet. Each pair of rings I'd read had given me a line. The wall wanted a third.",
		"choice": ["\"Close the eyes that lie, and see.\"", "\"Look for the eye and know peace.\"", "\"All must walk the path alone.\""],
		"right": "The third line. It fit the wall like a key, and the word under it was the one the man in the lot had stuck on. Beneath.",
		"wrong": "It didn't fit. The wall knew it didn't, and so did I.",
		"lynx": "You're reading their hymn off a wall, Carl. Good. Somebody should.",
		"log": "Read the third line on the Underpass chant wall.",
		"again": "The wall. Three lines now, and I knew the third.",
	},
	"factory": {
		"verse_wall": "SHED THE FIRST FILTER\nAND YOU SHALL SEE,\nSHED THE SECOND\nAND YOU SHALL FEEL,\nTHE FOURTH FILTER WAITS\nIN THE REPLICATION OF DREAMS.",
		"verse_think": "On the west wall, in the same black as the eye, in letters a foot high.",
		"verse": "Shed the first filter and you shall see, shed the second and you shall feel, the fourth filter waits in the replication of dreams.",
		"verse_think_2": "The Book of Boundary, verse one. Lynx had sent me a scan of it once, as a joke. Nobody down here was joking.",
		"verse_think_3": "No third filter. Whoever wrote it had skipped from the second to the fourth as if the third were understood.",
		"verse_log": "Book of Boundary, verse 1, on the factory's locked floor.",
		"laptop_think": "The office laptop, locked. The screensaver was a family asleep, smiling, under the logo. The same ad as the vending machines.",
		"laptop_frames": "With the frames on, the screensaver went. One line in the angular script, and under it in English, as if for me.",
		"laptop_psyon": "Pilgrim or Heretic, you must decide, journey round the eye.",
		"laptop_think_2": "That was all it would say. I asked it twice.",
		"laptop_log": "The factory laptop: 'Pilgrim or Heretic, you must decide, journey round the eye.'",
	},
	"claim": {
		"toast": "Case: the masked figure led Dufredy from the encampment, and the overpass was a church.",
		"log": "Claim: the masked figure led Dufredy from the encampment and the overpass was a church.",
	},
	"leave": {
		"think": "The late afternoon sun was beginning its descent, painting the sky in bruised hues. A powerful longing to be home with my family tugged at the edges of my resolve.",
		"think_2": "I needed more answers. I desperately needed them. But not tonight.",
		"carl": "Tonight, Monica and the kids will be the antidote. They always were.",
		"lynx": "Go. I'll pull the Tunelet plans tonight. Whatever they cut through out there, somebody drew it first.",
	},
	"ending": {
		"extra_floor": "You found the floor where they go first.\n",
		"extra_sermon": "You stayed for the sermon.\n",
		"extra_footprints": "You saw where the camp went.\n",
		"extra_claim": "The claim is on the board.\n",
		"extra_promise": "You promised to resist.\n",
		"extra_no_promise": "You made no promises.\n",
		"route": "You went into the plant by %s.\n",
		"routes": {"badge": "the badge", "hack": "the hack", "sneak": "the tunnel", "person": "the side door"},
		"card": "[center]\n\n\n[b]END OF CHAPTER 5[/b]\n\nRings read: %d        Connection: %d\n\n[color=#aaaaaa]%s[/color]\n[color=#aaaaaa]The map is in the evidence bag. A crimson eye, deep in the desert.[/color]\n\n[color=#777777]E to go home    M for the menu[/color][/center]",
	},
	"objective": {
		"done": "Home. The car is at the station. The overpass at the east end is empty; the frames might show why.",
		"lynx": "Lynx is waiting at the station.",
		"plant": "Get into the Tunelet plant, past the shanty lot. Four ways in.",
		"side_door": "The informant's side door: the gap past the shanty lot, west wall of the plant.",
		"church": "Under the wire eye, with the frames on.",
		"keycard": "Use the keycard on the locked door, west side of the factory floor.",
	},
}

const FRONT := 13.0                      # building fronts at z = +-13
const EYE_P := Vector3(140.0, 6.93, 0.0) # the eye on the underside of the overpass
const FLOOR_EYE := Vector3(22.0, 0.025, -28.0)   # the eye on the locked floor
const LYNX_WAIT := Vector3(-15.2, 0.02, -12.3)
const LYNX_EYE := Vector3(138.2, 0.02, -1.6)
const FACTORY_DOOR := Vector3(39.4, 0.0, -11.6)
const LYNX_FENCE := Vector3(54.5, 0.02, 11.4)      # where she waits on the badge route
const WIRE_EYE := Vector3(59.0, 13.92, 37.0)       # the wire eye on the plant's roof
const PIT := Vector3(69.5, 0.0, 43.0)              # the drill pit, where the tunnel comes up

var lynx: Node3D
var lynx_state := "wait"      # wait | follow | stand
var lynx_target := Vector3.ZERO
var _lynx_moving := false
var commuters: Array = []     # [{node, a, b, t, dir}]
var worker: Node3D
var trucks: Array = []        # hover vans along the street
var guards: Array = []
var vagrants: Array = []
var press_rams: Array = []
var factory_door: Node3D
var locked_door: Node3D
var locked_body: CollisionObject3D
var reader_light: MeshInstance3D
var sign_lights: Array = []
var _cough_t := 30.0
var _ended := false
var _hum: Node

var _conc: StandardMaterial3D
var _rust: StandardMaterial3D
var _metal: StandardMaterial3D
var _dark: StandardMaterial3D
var vag_informant: Node3D
var vag_attacker: Node3D
var vag_convert: Node3D
var patrols: Array = []       # [{node, a, b, t, dir, speed}]
var _guards_tail := false
var side_door: Node3D
var plant_gate: Node3D
var gate_reader_light: MeshInstance3D
var gate_cam: Node3D
var gate_cam_light: MeshInstance3D
var congregation: Array = []
var priest: Node3D
var priest_head: MeshInstance3D
var priest_faces: Array = []
var carl_face: StandardMaterial3D
var _face_t := 0.6
var _face_i := 0
var _face_n := 0
var _carl_frame := false
var footprints: Array = []
var _prints_on := false
var _chant: Node
var _sun_k := 0.0


func build(m: Node) -> void:
	main = m
	rng.seed = 505
	kit_day = true
	spawn = Vector3(-20.0, 0.05, 4.0)
	spawn_yaw = -90.0
	step_db = -15.0
	card = LINES["cards"]["chapter"]
	_conc = pbr("concrete", Vector3(1, 1, 1) / 3.0, true, Color(0.72, 0.68, 0.62))
	_rust = pbr("rust", Vector3(1, 1, 1) / 2.0, true)
	_metal = mat(Color(0.3, 0.31, 0.33), 0.5, 0.6)
	_dark = mat(Color(0.06, 0.06, 0.07), 0.6, 0.3)
	_ground()
	_station()
	_viaduct()
	_north_side()
	_factory()
	_south_side()
	_alley()
	_overpass()
	_tunnel_mouth()
	_desert()
	_backdrop()
	_street_dressing()
	_glyphs()
	_lanes()
	_people()
	_guards()
	_vagrants()
	_bounds()
	_batch(self, 16.0, true)
	var traffic: Node = TrafficS.new()
	traffic.along_x = true
	traffic.lanes = [[-4.5, 11.0, 1.0], [4.5, 13.0, -1.0], [0.0, 17.5, 1.0], [-2.5, 5.2, 1.0], [2.5, 5.6, -1.0]]
	traffic.s_min = -70.0
	traffic.s_max = 200.0
	traffic.count = 11
	traffic.tower_top = Vector3(-400, 520, -800)
	traffic.drone_box = AABB(Vector3(-100, 24, -120), Vector3(330, 70, 240))
	traffic.drone_count = 110
	add_child(traffic)
	traffic.setup(m, self)


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	# Late afternoon turning to evening: amber smog, a low sun in the west
	# behind the station, the overpass at the east end in its own shadow.
	var psm := ProceduralSkyMaterial.new()
	psm.sky_top_color = Color(0.34, 0.36, 0.42)
	psm.sky_horizon_color = Color(0.95, 0.56, 0.3)
	psm.ground_horizon_color = Color(0.8, 0.5, 0.3)
	psm.ground_bottom_color = Color(0.28, 0.2, 0.14)
	psm.sun_angle_max = 16.0
	env.sky.sky_material = psm
	env.glow_bloom = 0.0  # bloom on a sunlit frame greys out every shadow
	env.glow_intensity = 0.7
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.62, 0.58, 0.54)
	env.ambient_light_energy = 0.42
	env.reflected_light_source = Environment.REFLECTION_SOURCE_DISABLED
	env.fog_light_color = Color(0.88, 0.6, 0.4)
	env.fog_density = 0.0028
	env.fog_sky_affect = 0.3
	env.tonemap_exposure = 1.0
	env.glow_hdr_threshold = 1.1
	sun.light_color = Color(1.0, 0.72, 0.46)
	sun.light_energy = 1.2
	sun.sky_mode = DirectionalLight3D.SKY_MODE_LIGHT_AND_SKY
	sun.rotation = Vector3(deg_to_rad(-17), deg_to_rad(-112), 0)
	sun.directional_shadow_max_distance = 90.0


func hifi(env: Environment, _sun: DirectionalLight3D) -> void:
	env.volumetric_fog_density = 0.012
	env.volumetric_fog_albedo = Color(0.9, 0.6, 0.38)
	for l in lamps:
		(l[0] as OmniLight3D).shadow_enabled = true


func ambience() -> void:
	main.loop("wind", -12.0)
	main.loop("hum", -20.0, Vector3(100.0, 2.0, 12.0), 2.0, 16.0)       # the substation
	main.loop("static", -12.0, Vector3(52.0, 6.0, 12.6), 3.0, 18.0)     # the dead screen on the Tunelet plant
	main.loop("murmur", -14.0, Vector3(-20.0, 1.5, -8.0), 4.0, 24.0)    # the station forecourt
	main.loop("engine", -16.0, Vector3(50.0, 1.5, -28.0), 3.0, 22.0)    # the presses


# ------------------------------------------------------------------ ground

func _ground() -> void:
	solid_box(Vector3(400, 2, 300), Vector3(80, -1, 0))
	var asphalt := pbr("asphalt", Vector3(1, 1, 1) / 4.0, true, Color(0.8, 0.76, 0.7), 0.9)
	var paving := pbr("paving", Vector3(1, 1, 1) / 2.5, true, Color(0.85, 0.8, 0.72), 0.9)
	var curb := mat(Color(0.4, 0.37, 0.33), 0.8)
	var line := mat(Color(0.6, 0.56, 0.45), 0.7)
	var x := -44.0
	while x < 128.0:
		var cx := x + 10.0
		floor_quad(Vector2(20, 14), Vector3(cx, 0.0, 0), 0.0, asphalt)
		for side: float in [-1.0, 1.0]:
			floor_quad(Vector2(20, 6), Vector3(cx, 0.12, side * 10.0), 0.0, paving)
			box(Vector3(20, 0.14, 0.3), Vector3(cx, 0.07, side * 7.1), curb)
		box(Vector3(3.0, 0.01, 0.14), Vector3(cx - 5.0, 0.01, 0), line)
		box(Vector3(3.0, 0.01, 0.14), Vector3(cx + 5.0, 0.01, 0), line)
		x += 20.0
	# the station forecourt: paving across the whole width
	floor_quad(Vector2(30, 28), Vector3(-20.0, 0.13, 0.0), 0.0, paving)
	# sand drifting in from the desert, more of it the further east
	var sand := decal_mat(Tex.sand(), Color(1, 1, 1), 1.0)
	for i in 34:
		var sx := rng.randf_range(-30.0, 150.0)
		var sz := rng.randf_range(-12.5, 12.5)
		if absf(sz) < 6.5 and sx < 108.0:
			sz = signf(sz) * rng.randf_range(6.6, 12.5)
		var s := rng.randf_range(1.5, 4.5) * (0.6 + (sx + 40.0) / 190.0)
		floor_quad(Vector2(s, s * 0.6), Vector3(sx, 0.15, sz), rng.randf() * TAU, sand)


# ------------------------------------------------------------------ Southwest Station

func _station() -> void:
	# a long low hall at the west end, north side: weathered concrete, a
	# canopy over the entrance, dead departure boards, the ticket kiosk
	var wall := pbr("plaster", Vector3(1, 1, 1) / 2.5, true, Color(0.7, 0.62, 0.52))
	box(Vector3(30, 9, 14), Vector3(-20.0, 4.5, -20.0), wall, true)
	box(Vector3(30.6, 0.8, 14.6), Vector3(-20.0, 9.2, -20.0), _conc)
	# entrance: a dark opening with a canopy and a grille
	quad(Vector2(5.0, 3.6), Vector3(-20.0, 1.8, -12.98), 0.0, mat(Color(0.03, 0.03, 0.035), 1.0))
	box(Vector3(8.0, 0.3, 3.0), Vector3(-20.0, 4.0, -11.6), _metal)
	for k: float in [-3.6, 3.6]:
		cyl(0.08, 0.1, 4.0, Vector3(-20.0 + k, 2.0, -10.3), _metal, 6)
	for k in 7:
		box(Vector3(0.05, 3.6, 0.05), Vector3(-22.0 + k * 0.66, 1.8, -12.9), _dark)
	solid_box(Vector3(5.0, 3.6, 0.2), Vector3(-20.0, 1.8, -12.9))
	# the sign
	box(Vector3(12.0, 1.3, 0.2), Vector3(-20.0, 7.6, -12.9), _dark)
	neon_text("SOUTHWEST STATION", Vector3(-20.0, 7.35, -12.78), 0.0, 0.7, Color(0.9, 0.55, 0.3), 2.2)
	var sl := light(Vector3(-20.0, 7.2, -11.4), Color(1.0, 0.6, 0.3), 0.9, 7.0)
	flickers.append(sl)
	# departure board, dead, with one line of amber text stuck on it
	box(Vector3(4.0, 1.4, 0.12), Vector3(-9.5, 3.0, -12.9), _dark)
	quad(Vector2(3.8, 1.2), Vector3(-9.5, 3.0, -12.83), 0.0, mat(Color(0.05, 0.06, 0.06), 0.3, 0.2))
	var dep := label("DEPARTURES\n17:40  UPTOWN LOOP   ---\n18:10  TUNELET LINE  DELAYED\n18:40  JADE TOWER    ---", Vector3(-9.5, 3.05, -12.8), 0.0, 0.004, Color(0.9, 0.55, 0.15), self, false)
	dep.font_size = 48
	flickers.append(dep)
	interactable("station", "Read the timetable", Vector3(-9.5, 3.0, -12.9), Vector3(4.0, 1.4, 0.3),
		"SOUTHWEST STATION\nservice: INTERMITTENT\ntimetable: ADVISORY\nlast ORA sync: 11 days")
	# the ticket kiosk: a booth with a window, and the rings sprayed inside it
	var kp := Vector3(-26.5, 0, -11.1)
	for kx: float in [-1.2, 1.2]:
		box(Vector3(0.1, 2.6, 1.8), kp + Vector3(kx, 1.3, -0.9), _metal)
	box(Vector3(2.5, 0.3, 1.9), kp + Vector3(0, 2.45, -0.9), _metal)
	box(Vector3(2.4, 1.0, 0.1), kp + Vector3(0, 0.5, -0.05), _metal)
	quad(Vector2(2.3, 1.6), kp + Vector3(0, 1.6, -1.75), 0.0, mat(Color(0.08, 0.08, 0.09), 0.9))
	box(Vector3(2.2, 0.06, 0.7), kp + Vector3(0, 1.0, -0.5), mat(Color(0.5, 0.42, 0.32), 0.8))
	var kglass := newmat(Color(0.45, 0.55, 0.58, 0.3), 0.08, 0.3)
	kglass.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	kglass.cull_mode = BaseMaterial3D.CULL_DISABLED
	quad(Vector2(2.3, 1.6), kp + Vector3(0, 1.8, 0.0), 0.0, kglass)
	solid_box(Vector3(2.5, 2.6, 1.9), kp + Vector3(0, 1.3, -0.9))
	label("TICKETS\nCLOSED", kp + Vector3(0, 2.1, 0.03), 0.0, 0.004, Color(0.8, 0.3, 0.2), self, false).font_size = 56
	interactable("kiosk", "Look into the ticket kiosk", kp + Vector3(0, 0.5, 0.0), Vector3(2.4, 1.0, 0.3),
		"TICKET KIOSK 1\nstaff: NONE (SINCE 2037)\nglass: SCRATCHED (INSIDE)", false)
	# commuters' bench, a bin, a drone pole with its camera gone
	var wood := pbr("woodfloor", Vector3(1, 1, 1) / 1.5, true, Color(0.6, 0.5, 0.4))
	for bx: float in [-30.0, -12.0]:
		box(Vector3(2.2, 0.08, 0.5), Vector3(bx, 0.5, -11.5), wood)
		box(Vector3(2.2, 0.5, 0.06), Vector3(bx, 0.85, -11.75), wood)
		for k: float in [-0.95, 0.95]:
			box(Vector3(0.08, 0.5, 0.45), Vector3(bx + k, 0.25, -11.5), _dark)
		solid_box(Vector3(2.2, 1.1, 0.6), Vector3(bx, 0.55, -11.5))
	cyl(0.1, 0.12, 6.0, Vector3(-6.0, 3.0, -8.0), _rust, 8)
	box(Vector3(0.5, 0.35, 0.35), Vector3(-6.0, 6.1, -8.0), _rust)
	interactable("drone_pole", "Look at the drone pole", Vector3(-6.0, 5.8, -8.0), Vector3(0.8, 1.2, 0.8),
		"DRONE POLE 41\ncamera: MISSING\nspeaker: ACTIVE\nlast phrase: (STATIC)", false).set_meta("hackable", true)
	# Carl's company car, parked on the forecourt
	var car := Node3D.new()
	car.position = Vector3(-14.0, 0.0, 8.5)
	car.rotation.y = PI / 2.0
	add_child(car)
	car.add_child(Car.build(self, Color(0.75, 0.78, 0.8), {"plate": "PSF 0086"}))
	solid_box(Vector3(1.9, 1.5, 4.5), Vector3(0, 0.75, 0), car)
	interactable("my_car", "Your company car", Vector3(0, 1.0, 0), Vector3(2.0, 1.8, 4.6),
		"PSYONIC FLEET 0086\ndriver: DRAKE, C.\nmicrophone: ALWAYS ON", false, car)
	# the rusting, graffiti-scarred fence past the station, where the walk begins
	var mesh_m := newmat(Color(0.45, 0.4, 0.35, 0.4), 0.6, 0.6)
	mesh_m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh_m.cull_mode = BaseMaterial3D.CULL_DISABLED
	box(Vector3(0.04, 2.4, 10.0), Vector3(-5.5, 1.2, -8.0), mesh_m, true)
	box(Vector3(0.04, 2.4, 7.0), Vector3(-5.5, 1.2, 9.5), mesh_m, true)
	for z: float in [-12.5, -3.5, 6.5, 12.5]:
		cyl(0.05, 0.05, 2.5, Vector3(-5.5, 1.25, z), _rust, 6)
	var tag := Sprite3D.new()
	tag.texture = _glyph_tex
	tag.pixel_size = 0.007
	tag.modulate = Color(0.75, 0.2, 0.5, 0.8)
	tag.position = Vector3(-5.46, 1.3, -6.0)
	tag.rotation.y = PI / 2.0
	add_child(tag)
	tag.shaded = true


func _viaduct() -> void:
	# the rail line: a concrete viaduct across the west end, a train stopped
	# on it, "a spectral echo of their former efficiency"
	for z: float in [-30.0, -10.0, 10.0, 30.0]:
		box(Vector3(2.4, 6.0, 1.6), Vector3(-40.0, 3.0, z), _conc, true)
	box(Vector3(6.0, 1.2, 80.0), Vector3(-40.0, 6.6, 0.0), _conc, true)
	box(Vector3(0.1, 0.12, 80.0), Vector3(-41.5, 7.26, 0.0), _metal)
	box(Vector3(0.1, 0.12, 80.0), Vector3(-38.5, 7.26, 0.0), _metal)
	box(Vector3(6.2, 1.0, 80.0), Vector3(-40.0, 7.7, 0.0), mat(Color(0.5, 0.48, 0.45), 0.6, 0.5))
	var train := mat(Color(0.5, 0.55, 0.58), 0.4, 0.6)
	var glass := mat(Color(0.1, 0.14, 0.16), 0.15, 0.4)
	for k in 2:
		var cz := -22.0 + k * 20.0
		box(Vector3(2.8, 3.0, 18.5), Vector3(-40.0, 8.9, cz), train)
		box(Vector3(2.9, 0.9, 16.0), Vector3(-40.0, 9.3, cz), glass)
		box(Vector3(2.4, 0.3, 18.0), Vector3(-40.0, 10.5, cz), _metal)
	label("TUNELET LINE", Vector3(-38.52, 9.9, -22.0), PI / 2.0, 0.006, Color(0.9, 0.9, 0.85), self, false)
	# stairs up from the forecourt, gated
	for k in 8:
		box(Vector3(2.5, 0.25, 0.9), Vector3(-36.0, 0.9 + k * 0.85, -2.0 - k * 0.9), _conc)
	box(Vector3(2.6, 2.2, 0.08), Vector3(-36.0, 1.6, -1.5), mat(Color(0.3, 0.3, 0.32), 0.5, 0.7), true)
	interactable("train", "Look at the train", Vector3(-37.0, 8.0, -12.0), Vector3(4.0, 5.0, 20.0), "", false)


# ------------------------------------------------------------------ north side

func _north_side() -> void:
	# a dead warehouse between the station and the factory
	kit_dead = true
	cyber_block(Vector3(3.0, 0, -FRONT), 0.0, 18.0, 11.0, 24.0, true)
	kit_dead = false
	# east of the factory: two blocks, one with a working repair sign and a
	# dead ad screen, one with its shops shuttered
	cyber_block(Vector3(83.0, 0, -FRONT), 0.0, 18.0, 26.0, 22.0, true)
	kit_dead = true
	cyber_block(Vector3(100.0, 0, -FRONT), 0.0, 16.0, 18.0, 22.0, true)
	kit_dead = false
	neon_text("REPAIR  24H", Vector3(83.0, 4.2, -12.7), 0.0, 0.6, Color(0.1, 0.92, 1.0), 2.8)
	sign_lights.append(light(Vector3(83.0, 4.0, -11.6), Color(0.1, 0.9, 1.0), 1.2, 9.0))
	_dead_screen(Vector3(83.0, 14.0, -12.6), 0.0, 12.0, 7.0, "PSYMATCHBOT\nshe already knows you")


## A big ad screen with nothing on it but cracks and a stuck frame of static.
func _dead_screen(p: Vector3, rot_y: float, w: float, h: float, ghost: String) -> void:
	var r := Node3D.new()
	r.position = p
	r.rotation.y = rot_y
	add_child(r)
	box(Vector3(w + 0.6, h + 0.6, 0.3), Vector3(0, 0, -0.15), _dark, false, r)
	quad(Vector2(w, h), Vector3.ZERO, 0.0, mat(Color(0.07, 0.07, 0.08), 0.15, 0.4), r)
	var crack := mat(Color(0.5, 0.5, 0.55), 0.3)
	var a := Vector3(-w * 0.3, h * 0.4, 0.01)
	for k in 5:
		var b := a + Vector3(rng.randf_range(0.5, 3.0), -rng.randf_range(0.5, 2.5), 0)
		stick(a, b, 0.015, crack, r)
		a = b
	var g := label(ghost, Vector3(0, 0, 0.02), 0.0, 0.012 * w / 12.0, Color(0.18, 0.18, 0.2), r, false)
	g.font_size = 72


# ------------------------------------------------------------------ the Voltx factory

func _factory() -> void:
	# Book: "the skeletal remains of an abandoned Voltx factory, its once-proud
	# metal limbs twisted and rusting". The 2D game's factory: it still runs
	# one shift, stamping the blanks for ORA frames; a keycard in the office
	# under a coffee ring; twenty years of ledgers; and the locked floor.
	var H := 8.0
	var t := 0.3
	var wall := pbr("concrete", Vector3(1, 1, 1) / 3.0, true, Color(0.58, 0.52, 0.46))
	# the facade along z -13 with the door gap at x 38.7..40.1
	box(Vector3(26.7, H, t), Vector3(25.35, H / 2.0, -FRONT), wall, true)
	box(Vector3(29.9, H, t), Vector3(55.05, H / 2.0, -FRONT), wall, true)
	box(Vector3(1.4, H - 2.3, t), Vector3(39.4, 2.3 + (H - 2.3) / 2.0, -FRONT), wall, true)
	# the other walls, the roof, the floor
	box(Vector3(58.0, H, t), Vector3(41.0, H / 2.0, -43.0), wall, true)
	box(Vector3(t, H, 30.0), Vector3(12.0, H / 2.0, -28.0), wall, true)
	box(Vector3(t, H, 30.0), Vector3(70.0, H / 2.0, -28.0), wall, true)
	box(Vector3(58.6, 0.6, 30.6), Vector3(41.0, H + 0.3, -28.0), _conc)
	floor_quad(Vector2(58, 30), Vector3(41.0, 0.01, -28.0), 0.0, pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.5, 0.48, 0.45)))
	# the partition to the locked floor at x 32, with the door gap at z -28.7..-27.3
	box(Vector3(t, H, 14.3), Vector3(32.0, H / 2.0, -35.85), wall, true)
	box(Vector3(t, H, 14.3), Vector3(32.0, H / 2.0, -20.15), wall, true)
	box(Vector3(t, H - 2.2, 1.4), Vector3(32.0, 2.2 + (H - 2.2) / 2.0, -28.0), wall, true)
	# the facade: rust panels, high dirty windows, the limbs, the broken sign
	for k in 5:
		var px := 16.0 + k * 11.0
		if absf(px - 39.4) < 4.0:
			continue
		quad(Vector2(6.0, 3.0), Vector3(px, 2.2, -FRONT + 0.16), 0.0, _rust)
	var dirty := mat(Color(0.25, 0.28, 0.26), 0.3, 0.3)
	for k in 9:
		quad(Vector2(3.6, 1.8), Vector3(16.0 + k * 6.5, 6.0, -FRONT + 0.16), 0.0, dirty)
	for k in 7:
		var bx := 14.0 + k * 9.0 + rng.randf_range(-1.0, 1.0)
		var a := Vector3(bx, H + 0.6, -FRONT - rng.randf_range(0.0, 6.0))
		var b := a + Vector3(rng.randf_range(-2.0, 2.0), rng.randf_range(2.0, 6.0), rng.randf_range(-1.0, 3.0))
		stick(a, b, 0.14, _rust)
		stick(b, b + Vector3(rng.randf_range(-3.0, 3.0), rng.randf_range(-2.0, 1.0), rng.randf_range(-2.0, 2.0)), 0.09, _rust)
	box(Vector3(10.0, 2.2, 0.3), Vector3(52.0, H + 1.6, -FRONT + 0.1), _dark)
	neon_text("VO  TX", Vector3(52.0, H + 1.2, -FRONT + 0.3), 0.0, 1.4, Color(0.35, 0.3, 0.3), 0.3)
	neon_text("L", Vector3(51.2, H + 1.2, -FRONT + 0.3), 0.0, 1.4, Color(1.0, 0.5, 0.12), 2.6).rotation.z = -0.35
	sign_lights.append(light(Vector3(51.0, H + 1.0, -FRONT + 1.5), Color(1.0, 0.5, 0.15), 0.8, 7.0))
	interactable("factory", "Look at the factory", Vector3(26.0, 3.0, -FRONT + 0.2), Vector3(8.0, 5.0, 0.4),
		"VOLTX PLANT 3 (SOUTHTOWN)\nstatus: DECOMMISSIONED 2036\npower draw: 140 kW (ACTIVE)", false)
	# the side door, hinged, with a sign
	var dm := mat(Color(0.22, 0.2, 0.18), 0.6, 0.3)
	factory_door = Node3D.new()
	factory_door.position = Vector3(38.7, 0, -FRONT)
	add_child(factory_door)
	box(Vector3(1.4, 2.3, 0.08), Vector3(0.7, 1.15, 0), dm, false, factory_door)
	box(Vector3(0.12, 0.04, 0.08), Vector3(1.2, 1.05, -0.06), _metal, false, factory_door)
	var fd := interactable("factory_door", "Try the side door", Vector3(0.7, 1.15, 0), Vector3(1.4, 2.3, 0.12), "", true, factory_door)
	fd.set_meta("door", true)
	for c in factory_door.get_children():
		no_batch.append(c)
	label("SHIFT ENTRANCE\nNO FRAMES BEYOND THIS POINT", Vector3(39.4, 2.75, -FRONT + 0.17), 0.0, 0.0028, Color(0.85, 0.8, 0.7), self, false).font_size = 48
	_factory_floor()
	_office()
	_locked_floor()


func _factory_floor() -> void:
	# three presses stamping frame blanks out of sheet metal, a conveyor,
	# bins of blanks, sodium lamps, and the one man on the shift
	var press_m := mat(Color(0.18, 0.2, 0.22), 0.5, 0.6)
	var blank_m := mat(Color(0.6, 0.62, 0.64), 0.3, 0.8)
	for k in 3:
		var p := Vector3(44.0 + k * 9.0, 0, -30.0)
		box(Vector3(3.0, 1.2, 2.4), p + Vector3(0, 0.6, 0), press_m, true)
		box(Vector3(0.5, 2.6, 0.5), p + Vector3(-1.1, 2.5, -0.9), press_m)
		box(Vector3(0.5, 2.6, 0.5), p + Vector3(1.1, 2.5, -0.9), press_m)
		box(Vector3(3.0, 0.6, 2.4), p + Vector3(0, 3.9, 0), press_m)
		var ram := box(Vector3(1.2, 1.4, 1.2), p + Vector3(0, 2.4, 0.2), _metal)
		no_batch.append(ram)
		press_rams.append([ram, 2.4, float(k) * 1.1])
		box(Vector3(2.2, 0.02, 1.0), p + Vector3(0, 1.21, 0.5), blank_m)
		# bins of blanks either side
		box(Vector3(1.2, 0.8, 1.2), p + Vector3(2.4, 0.4, 1.4), _rust, true)
		for j in 14:
			var fb := box(Vector3(0.14, 0.02, 0.05), p + Vector3(2.4 + rng.randf_range(-0.4, 0.4), 0.82 + j * 0.004, 1.4 + rng.randf_range(-0.4, 0.4)), blank_m)
			fb.rotation.y = rng.randf() * TAU
		var o := light(p + Vector3(0, 6.5, 2.0), Color(1.0, 0.6, 0.3), 1.6, 12.0)
		box(Vector3(1.4, 0.15, 0.5), p + Vector3(0, 7.2, 2.0), glow(Color(1.0, 0.62, 0.3), 2.0, true))
		if k == 1:
			flickers.append(o)
	# conveyor along the floor
	box(Vector3(24.0, 0.9, 0.9), Vector3(53.0, 0.45, -33.5), _metal, true)
	box(Vector3(23.6, 0.04, 0.7), Vector3(53.0, 0.92, -33.5), mat(Color(0.08, 0.08, 0.08), 0.9))
	interactable("machines", "Look at the presses", Vector3(53.0, 1.0, -30.0), Vector3(4.0, 2.0, 2.4),
		"VOLTX PRESS LINE\nproduct: FRAME BLANK, ORA GEN 6\nrate: 1 / 4.2 s\ncustomer: PSYONIC INTEGRATIONS", false)
	# the wall of the locked floor from this side: the card reader and its light
	var rd := Vector3(32.17, 1.3, -26.7)
	box(Vector3(0.06, 0.18, 0.1), rd, mat(Color(0.9, 0.9, 0.92), 0.3), false)
	reader_light = box(Vector3(0.02, 0.04, 0.04), rd + Vector3(0.04, 0.05, 0), glow(Color(0.2, 1.0, 0.3), 3.0), false)
	no_batch.append(reader_light)
	label("FLOOR 2\nAUTHORISED STAFF", Vector3(32.17, 3.0, -28.0), PI / 2.0, 0.003, Color(0.8, 0.75, 0.65), self, false).font_size = 48
	interactable("reader", "Look at the card reader", rd, Vector3(0.2, 0.3, 0.3), "CARD READER\ninstalled: 9 DAYS AGO\nvendor: (NONE)\nlast card: 00:00 TODAY", false).set_meta("hackable", true)
	# the locked door itself, hinged at z -28.7, opening into the locked floor
	var dm := mat(Color(0.5, 0.52, 0.55), 0.4, 0.7)
	locked_door = Node3D.new()
	locked_door.position = Vector3(32.0, 0, -28.7)
	add_child(locked_door)
	box(Vector3(0.1, 2.2, 1.4), Vector3(0, 1.1, 0.7), dm, false, locked_door)
	locked_body = interactable("locked_door", "Try the door", Vector3(0, 1.1, 0.7), Vector3(0.14, 2.2, 1.4), "", true, locked_door)
	for c in locked_door.get_children():
		no_batch.append(c)
	# sand on the floor, in from the door; oil; the chant on a wall in marker
	var sand := decal_mat(Tex.sand(), Color(1, 1, 1), 1.0)
	for i in 6:
		floor_quad(Vector2(2.0, 1.4) * rng.randf_range(0.6, 1.4), Vector3(39.4 + rng.randf_range(-3.0, 3.0), 0.02, -15.5 - i * 1.2), rng.randf() * TAU, sand)
	var marker := label("gather, sleeper", Vector3(69.8, 1.7, -22.0), -PI / 2.0, 0.004, Color(0.1, 0.1, 0.12), self, false)
	marker.font_size = 48
	marker.rotation.z = 0.08


func _office() -> void:
	# the shift office in the NE corner: desk, laptop, the keycard under a
	# coffee ring, twenty years of shift ledgers on the shelves
	var wall := pbr("plaster", Vector3(1, 1, 1) / 2.0, true, Color(0.6, 0.58, 0.5))
	box(Vector3(10.0, 3.0, 0.2), Vector3(65.0, 1.5, -34.0), wall, true)
	box(Vector3(0.2, 3.0, 5.0), Vector3(60.0, 1.5, -40.5), wall, true)
	box(Vector3(10.2, 0.2, 9.2), Vector3(65.0, 3.1, -38.5), mat(Color(0.5, 0.5, 0.48), 0.9))
	floor_quad(Vector2(9.8, 8.8), Vector3(65.0, 0.02, -38.5), 0.0, pbr("carpet", Vector3(1, 1, 1) / 1.5, true, Color(0.5, 0.45, 0.4)))
	light(Vector3(65.0, 2.8, -38.5), Color(0.9, 0.95, 1.0), 0.9, 7.0)
	box(Vector3(1.2, 0.08, 0.3), Vector3(65.0, 2.95, -38.5), glow(Color(0.9, 0.95, 1.0), 1.5, true))
	var wood := pbr("woodfloor", Vector3(1, 1, 1) / 1.5, true, Color(0.55, 0.42, 0.3))
	var dp := Vector3(66.5, 0, -41.0)
	box(Vector3(2.2, 0.06, 1.0), dp + Vector3(0, 0.76, 0), wood, true)
	for k: float in [-1.0, 1.0]:
		box(Vector3(0.08, 0.76, 0.9), dp + Vector3(k, 0.38, 0), _dark)
	box(Vector3(0.5, 0.42, 0.5), dp + Vector3(-0.4, 0.21, 0.9), mat(Color(0.2, 0.2, 0.22), 0.6), true)
	# the laptop, locked, the family asleep under the logo on its screen
	box(Vector3(0.36, 0.02, 0.26), dp + Vector3(0.3, 0.8, 0), _dark)
	var scr := box(Vector3(0.36, 0.24, 0.02), dp + Vector3(0.3, 0.92, -0.13), _dark)
	scr.rotation.x = 0.25
	var sq := quad(Vector2(0.32, 0.2), dp + Vector3(0.3, 0.92, -0.115), 0.0, glow(Color(0.35, 0.8, 0.7), 1.2, true))
	sq.rotation.x = 0.25
	interactable("office_laptop", "Look at the laptop", dp + Vector3(0.3, 0.9, -0.05), Vector3(0.4, 0.3, 0.3), "", false)
	# the coffee ring, and the keycard under it
	var ring := Sprite3D.new()
	ring.texture = _glyph_tex
	ring.pixel_size = 0.0009
	ring.modulate = Color(0.35, 0.22, 0.1, 0.8)
	ring.position = dp + Vector3(-0.5, 0.795, 0.1)
	ring.rotation.x = -PI / 2.0
	ring.shaded = true
	add_child(ring)
	var card := box(Vector3(0.085, 0.004, 0.055), dp + Vector3(-0.5, 0.792, 0.1), mat(Color(0.9, 0.9, 0.88), 0.4))
	card.rotation.y = 0.4
	no_batch.append(card)
	card.set_meta("card", true)
	interactable("keycard", "Pick up the keycard", dp + Vector3(-0.5, 0.82, 0.1), Vector3(0.3, 0.12, 0.3), "", false)
	# the ledgers: shelves of them, twenty years
	var shelf := Vector3(69.6, 0, -38.5)
	var ledger_c := [Color(0.25, 0.15, 0.1), Color(0.15, 0.15, 0.2), Color(0.3, 0.25, 0.15)]
	for s in 4:
		box(Vector3(0.3, 0.04, 4.5), shelf + Vector3(0, 0.5 + s * 0.6, 0), wood)
		for k in 20:
			box(Vector3(0.26, 0.5, 0.18), shelf + Vector3(0, 0.77 + s * 0.6, -2.1 + k * 0.22), mat(ledger_c[(k + s) % 3], 0.8))
	solid_box(Vector3(0.4, 2.6, 4.6), shelf + Vector3(0, 1.3, 0))
	# one open on the desk end
	box(Vector3(0.4, 0.03, 0.3), dp + Vector3(-0.95, 0.79, -0.2), mat(Color(0.9, 0.87, 0.8), 0.9))
	var lg := _glyph_on(dp + Vector3(-0.9, 0.81, -0.2), 0.0, 0.0006, "g_ledger", false, true,
		LINES["rings"]["g_ledger"], true, Color(0.1, 0.1, 0.12))
	lg.set_meta("prompt", "Read the open ledger")
	interactable("ledger", "Look at the ledgers", shelf + Vector3(0, 1.3, 0), Vector3(0.5, 2.6, 4.6),
		"SHIFT LEDGERS 2026-2046\nformat: PAPER\nreason: 'the network keeps losing them'", false)


func _locked_floor() -> void:
	# Floor 2: bare concrete, one lamp, the eye painted ten feet across, and
	# forty pairs of frames laid round it "like shoes outside a door".
	var eye := _eye_paint()
	var em := decal_mat(eye, Color(0.7, 0.1, 0.08), 0.9)
	floor_quad(Vector2(3.6, 2.3), FLOOR_EYE, 0.0, em)
	var rings := Sprite3D.new()
	rings.texture = _glyph_tex
	rings.pixel_size = 0.0095
	rings.modulate = Color(0.45, 0.07, 0.05, 0.95)
	rings.position = FLOOR_EYE + Vector3(0, 0.004, 0)
	rings.rotation.x = -PI / 2.0
	rings.shaded = true
	add_child(rings)
	var rim := mat(Color(0.08, 0.08, 0.09), 0.4, 0.5)
	var lens := mat(Color(0.2, 0.26, 0.3), 0.1, 0.4)
	for i in 40:
		var a := i * TAU / 40.0 + rng.randf_range(-0.03, 0.03)
		var r := 2.75 + rng.randf_range(-0.08, 0.08)
		var p := FLOOR_EYE + Vector3(cos(a) * r, 0.0, sin(a) * r)
		var ry := -a + PI / 2.0
		var b := Basis(Vector3.UP, ry)
		for side: float in [-1.0, 1.0]:
			var q := p + b * Vector3(side * 0.035, 0.012, 0)
			box(Vector3(0.05, 0.024, 0.035), q, rim).rotation.y = ry
			box(Vector3(0.04, 0.002, 0.028), q + Vector3(0, 0.013, 0), lens).rotation.y = ry
		box(Vector3(0.016, 0.006, 0.01), p + Vector3(0, 0.02, 0), rim).rotation.y = ry
		# the arms folded under, two little sticks
		for side: float in [-1.0, 1.0]:
			var s0 := p + b * Vector3(side * 0.06, 0.006, 0.0)
			box(Vector3(0.006, 0.006, 0.07), s0 + b * Vector3(0, 0, 0.035), rim).rotation.y = ry
	interactable("floor_eye", "Look at the floor", FLOOR_EYE + Vector3(0, 0.3, 0), Vector3(3.4, 0.6, 2.4), "", false)
	light(Vector3(22.0, 6.8, -28.0), Color(0.75, 0.8, 0.9), 2.6, 20.0)
	var o := light(Vector3(16.0, 6.5, -38.0), Color(0.75, 0.8, 0.9), 1.4, 12.0)
	flickers.append(o)
	# the Book of Boundary, verse one, on the west wall in the same black as the eye
	var vl := label(LINES["factory"]["verse_wall"], Vector3(12.25, 2.6, -30.0), PI / 2.0, 0.004, Color(0.05, 0.05, 0.06), self, false)
	vl.font_size = 56
	vl.rotation.z = -0.02
	interactable("verse", "Read the wall", Vector3(12.3, 2.2, -30.0), Vector3(0.4, 3.6, 6.0), "", false)
	light(Vector3(14.0, 3.5, -30.0), Color(0.9, 0.85, 0.8), 0.8, 8.0)
	box(Vector3(0.5, 0.15, 0.5), Vector3(22.0, 7.4, -28.0), glow(Color(0.8, 0.85, 1.0), 1.5, true))
	light(FLOOR_EYE + Vector3(0, 1.2, 0), Color(1.0, 0.3, 0.2), 0.9, 7.0, false)
	# the other things on the floor: a mattress, a bucket, nothing that blinks
	box(Vector3(1.8, 0.2, 0.9), Vector3(14.5, 0.1, -40.0), mat(Color(0.5, 0.45, 0.4), 1.0), true)
	cyl(0.16, 0.14, 0.3, Vector3(29.0, 0.15, -40.5), _metal, 10)
	for i in 5:
		floor_quad(Vector2(2.5, 1.6) * rng.randf_range(0.6, 1.2), Vector3(rng.randf_range(14.0, 30.0), 0.02, rng.randf_range(-41.0, -15.0)), rng.randf() * TAU, decal_mat(Tex.sand(), Color(1, 1, 1), 1.0))


# ------------------------------------------------------------------ south side

func _south_side() -> void:
	# the pawn shop block by the station, the only honest neon on the street
	cyber_block(Vector3(3.0, 0, FRONT), PI, 18.0, 14.0, 24.0, true)
	neon_text("PAWN", Vector3(1.0, 3.9, 12.7), PI, 0.8, Color(1.0, 0.18, 0.62), 2.8)
	sign_lights.append(light(Vector3(1.0, 3.8, 11.5), Color(1.0, 0.2, 0.6), 1.2, 9.0))
	_shanty()
	_plant()
	_fulfilment()


func _shanty() -> void:
	# "A half-standing shanty town, its makeshift dwellings clinging
	# precariously to the edge of oblivion." Corrugated sheet, tarps, pallets,
	# a cold barrel, nobody home but the ones with frames on.
	var dirt := pbr("concrete", Vector3(1, 1, 1) / 2.5, true, Color(0.55, 0.42, 0.3))
	floor_quad(Vector2(28, 26), Vector3(26.0, 0.14, 26.0), 0.0, dirt)
	var sheet := mat(Color(0.42, 0.38, 0.34), 0.7, 0.6)
	var tarp := [newmat(Color(0.2, 0.3, 0.5), 1.0), newmat(Color(0.5, 0.42, 0.2), 1.0), newmat(Color(0.3, 0.3, 0.3), 1.0)]
	for t: StandardMaterial3D in tarp:
		t.cull_mode = BaseMaterial3D.CULL_DISABLED
	var spots := [Vector3(16.0, 0, 18.0), Vector3(23.0, 0, 16.0), Vector3(31.0, 0, 19.0), Vector3(37.0, 0, 17.0),
		Vector3(18.0, 0, 27.0), Vector3(27.0, 0, 29.0), Vector3(35.0, 0, 28.0)]
	for i in spots.size():
		var p: Vector3 = spots[i]
		var w := rng.randf_range(2.4, 3.6)
		var h := rng.randf_range(1.8, 2.5)
		var r := rng.randf_range(-0.3, 0.3)
		var n := Node3D.new()
		n.position = p
		n.rotation.y = r
		add_child(n)
		box(Vector3(w, h, 0.06), Vector3(0, h / 2.0, -w / 2.0), sheet, false, n)
		box(Vector3(0.06, h, w), Vector3(-w / 2.0, h / 2.0, 0), _rust if i % 2 == 0 else sheet, false, n)
		if i % 3 != 2:
			box(Vector3(0.06, h * 0.7, w), Vector3(w / 2.0, h * 0.35, 0), sheet, false, n)
		var roof := box(Vector3(w + 0.6, 0.05, w + 0.6), Vector3(0, h + 0.1, 0), tarp[i % 3], false, n)
		roof.rotation = Vector3(rng.randf_range(-0.12, 0.12), 0, rng.randf_range(-0.1, 0.1))
		solid_box(Vector3(w, h, w), Vector3(0, h / 2.0, 0), n)
		if i % 2 == 1:
			var q := quad(Vector2(w * 0.8, h * 0.9), Vector3(0, h * 0.5, w / 2.0 + 0.1), 0.0, tarp[(i + 1) % 3], n)
			q.rotation.x = 0.15
		for k in 3:
			box(Vector3(0.9, 0.12, 0.9), Vector3(w / 2.0 + 0.9, 0.06 + k * 0.13, -w / 4.0), mat(Color(0.5, 0.4, 0.28), 0.9), false, n)
	# a cold barrel, a line of washing, a bicycle frame
	cyl(0.35, 0.35, 0.9, Vector3(26.0, 0.45, 22.0), mat(Color(0.2, 0.12, 0.08), 0.6, 0.5), 12)
	for k in 4:
		var a := Vector3(22.0, 2.4, 22.5)
		var b := Vector3(31.0, 2.2, 23.5)
		var p := a.lerp(b, 0.2 + k * 0.2)
		quad(Vector2(0.5, 0.7), p - Vector3(0, 0.4, 0), 0.0, tarp[(k + 1) % 3])
	stick(Vector3(22.0, 0, 22.5), Vector3(22.0, 2.5, 22.5), 0.03, _rust)
	stick(Vector3(22.0, 2.4, 22.5), Vector3(31.0, 2.2, 23.5), 0.01, _dark)
	stick(Vector3(31.0, 0, 23.5), Vector3(31.0, 2.3, 23.5), 0.03, _rust)
	interactable("shanty", "Look at the shanty town", Vector3(26.0, 1.2, 15.0), Vector3(10.0, 2.4, 3.0),
		"UNREGISTERED DWELLINGS: 7\noccupants: 0 (ON SHIFT)\ndevices: 3 (ORA GEN 2, UNISSUED)", false)
	# the chain-link along the street, bent down where people step over it
	var mesh_m := newmat(Color(0.45, 0.4, 0.35, 0.4), 0.6, 0.6)
	mesh_m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh_m.cull_mode = BaseMaterial3D.CULL_DISABLED
	box(Vector3(10.0, 2.0, 0.04), Vector3(17.0, 1.0, FRONT), mesh_m)
	box(Vector3(12.0, 2.0, 0.04), Vector3(34.0, 1.0, FRONT), mesh_m)
	var bent := box(Vector3(6.0, 2.0, 0.04), Vector3(25.0, 0.6, FRONT + 0.4), mesh_m)
	bent.rotation.x = -1.1
	for x: float in [12.0, 22.0, 28.0, 40.0]:
		cyl(0.05, 0.05, 2.2, Vector3(x, 1.1, FRONT), _rust, 6)


func _plant() -> void:
	# Site 2, the Tunelet plant (tier 3). Book: "the fractured, gaping maw of
	# the Tunelet construction plant. Tunelet. The company that had sliced
	# through the ancient bedrock, the original tunnelers, the ones who had
	# delved too deep." Bible A1-S6: a chain gate with a cult guard and a
	# camera, two more guards in the yard between the boring drills, and
	# under the roof the church: the circle of chairs, the ten-foot wire eye
	# on the concrete above, the face-projecting priest, twelve seated.
	# Yard x 44..74, z 13..25; the hangar x 44..74, z 25..55.
	var wall := pbr("concrete", Vector3(1, 1, 1) / 3.5, true, Color(0.5, 0.47, 0.44))
	var H := 14.0
	var t := 0.4
	box(Vector3(30.0, H, t), Vector3(59.0, H / 2.0, 47.0), wall, true)
	box(Vector3(t, H, 22.0), Vector3(74.0, H / 2.0, 36.0), wall, true)
	# the west wall, with the side door gap at z 33..34.4 (the Person route)
	box(Vector3(t, H, 8.0), Vector3(44.0, H / 2.0, 29.0), wall, true)
	box(Vector3(t, H, 12.6), Vector3(44.0, H / 2.0, 40.7), wall, true)
	box(Vector3(t, H - 2.3, 1.4), Vector3(44.0, 2.3 + (H - 2.3) / 2.0, 33.7), wall, true)
	# the front: the maw torn out of it, x 51..67, ten metres high
	box(Vector3(7.0, H, t), Vector3(47.5, H / 2.0, 25.0), wall, true)
	box(Vector3(7.0, H, t), Vector3(70.5, H / 2.0, 25.0), wall, true)
	box(Vector3(16.0, H - 10.0, t), Vector3(59.0, 10.0 + (H - 10.0) / 2.0, 25.0), wall, true)
	box(Vector3(31.0, 0.6, 23.0), Vector3(59.0, H + 0.3, 36.0), _conc)
	floor_quad(Vector2(30, 22), Vector3(59.0, 0.012, 36.0), 0.0, pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.42, 0.4, 0.38)))
	for k in 9:
		var a := Vector3(52.0 + k * 1.75, 10.5 + rng.randf_range(-0.8, 0.8), 24.9)
		stick(a, a + Vector3(rng.randf_range(-0.6, 0.6), -rng.randf_range(1.5, 3.5), rng.randf_range(0.0, 0.8)), 0.09, _rust)
	for side: float in [-1.0, 1.0]:
		for k in 5:
			var a := Vector3(59.0 + side * 8.0 + rng.randf_range(-0.3, 0.3), 1.0 + k * 2.0, 24.9)
			stick(a, a + Vector3(side * rng.randf_range(0.5, 1.5), rng.randf_range(-0.5, 0.5), rng.randf_range(0.0, 0.6)), 0.08, _rust)
	neon_text("TUNELET", Vector3(59.0, H - 1.6, 24.7), PI, 2.2, Color(0.35, 0.33, 0.3), 0.2)
	# the side door, hinged inside the west wall
	side_door = Node3D.new()
	side_door.position = Vector3(44.0, 0, 33.0)
	add_child(side_door)
	box(Vector3(0.08, 2.3, 1.4), Vector3(0, 1.15, 0.7), mat(Color(0.22, 0.2, 0.18), 0.6, 0.3), false, side_door)
	interactable("side_door", "Try the side door", Vector3(0, 1.15, 0.7), Vector3(0.14, 2.3, 1.4), "", true, side_door)
	for c in side_door.get_children():
		no_batch.append(c)
	# the yard: fence, the chain gate, the reader, the camera, the speaker
	var mesh_m := newmat(Color(0.45, 0.4, 0.35, 0.4), 0.6, 0.6)
	mesh_m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh_m.cull_mode = BaseMaterial3D.CULL_DISABLED
	box(Vector3(13.0, 2.6, 0.04), Vector3(50.5, 1.3, FRONT), mesh_m, true)
	box(Vector3(13.0, 2.6, 0.04), Vector3(67.5, 1.3, FRONT), mesh_m, true)
	box(Vector3(0.04, 2.6, 12.0), Vector3(44.0, 1.3, FRONT + 6.0), mesh_m, true)
	box(Vector3(0.04, 2.6, 12.0), Vector3(74.0, 1.3, FRONT + 6.0), mesh_m, true)
	for x: float in [44.0, 50.0, 56.8, 61.2, 68.0, 74.0]:
		cyl(0.06, 0.06, 2.8, Vector3(x, 1.4, FRONT), _rust, 6)
	plant_gate = Node3D.new()
	plant_gate.position = Vector3(56.9, 0, FRONT)
	add_child(plant_gate)
	box(Vector3(4.2, 2.4, 0.05), Vector3(2.1, 1.3, 0), mesh_m, false, plant_gate)
	box(Vector3(4.2, 0.08, 0.08), Vector3(2.1, 2.5, 0), _rust, false, plant_gate)
	box(Vector3(4.2, 0.08, 0.08), Vector3(2.1, 0.1, 0), _rust, false, plant_gate)
	var pg := interactable("plant_gate", "The gate", Vector3(2.1, 1.3, 0), Vector3(4.2, 2.4, 0.3),
		"TUNELET CONSTRUCTION - SITE 3\nowner: PSYONIC INTEGRATIONS (ACQUIRED)\nstatus: DECOMMISSIONED\naccess: BADGE", true, plant_gate)
	for c in plant_gate.get_children():
		no_batch.append(c)
	box(Vector3(0.12, 0.22, 0.08), Vector3(61.4, 1.3, FRONT - 0.12), mat(Color(0.9, 0.9, 0.92), 0.3))
	gate_reader_light = box(Vector3(0.04, 0.05, 0.03), Vector3(61.4, 1.38, FRONT - 0.17), glow(Color(1.0, 0.15, 0.1), 3.0))
	no_batch.append(gate_reader_light)
	interactable("gate_reader", "Look at the reader", Vector3(61.4, 1.3, FRONT - 0.15), Vector3(0.3, 0.4, 0.3),
		"GATE READER\nvendor: PSYONIC\naccepts: COMPANY BADGE\nlast entry: 03:12 TODAY", false).set_meta("hackable", true)
	gate_cam = Node3D.new()
	gate_cam.position = Vector3(61.4, 3.3, FRONT + 0.3)
	gate_cam.rotation.y = PI + 0.3
	add_child(gate_cam)
	box(Vector3(0.25, 0.25, 0.5), Vector3(0, 0, -0.15), mat(Color(0.85, 0.85, 0.85), 0.3), false, gate_cam)
	gate_cam_light = box(Vector3(0.08, 0.08, 0.04), Vector3(0, 0, -0.42), glow(Color(1, 0.1, 0.1), 3.0), false, gate_cam)
	interactable("gate_cam", "Look at the camera", Vector3(0, 0, -0.1), Vector3(0.5, 0.5, 0.8),
		"GATE CAMERA\nowner: (NONE)\nfeed: 40 VIEWERS\nhack: LOOK AWAY", false, gate_cam).set_meta("hackable", true)
	for c in gate_cam.get_children():
		no_batch.append(c)
	box(Vector3(0.3, 0.3, 0.2), Vector3(56.6, 3.0, FRONT + 0.2), _dark)
	interactable("gate_speaker", "Look at the speaker", Vector3(56.6, 3.0, FRONT + 0.2), Vector3(0.5, 0.5, 0.5),
		"GATE SPEAKER\nvoice assistant: ACTIVE\nlast phrase: 'gather'\nhack: HUSH", false).set_meta("hackable", true)
	var yard := pbr("concrete", Vector3(1, 1, 1) / 3.0, true, Color(0.55, 0.5, 0.44))
	floor_quad(Vector2(30, 12), Vector3(59.0, 0.14, FRONT + 6.0), 0.0, yard)
	# two boring drills on stands, bits toward the street, the housing to hide behind
	var steel := mat(Color(0.42, 0.44, 0.46), 0.45, 0.7)
	for dx: float in [50.0, 68.0]:
		var d := cyl(1.1, 1.1, 6.0, Vector3(dx, 1.9, 20.0), steel, 14)
		d.rotation.x = PI / 2.0
		var bit := cyl(0.1, 1.1, 1.6, Vector3(dx, 1.9, 16.2), _rust, 14)
		bit.rotation.x = -PI / 2.0
		for k in 2:
			box(Vector3(2.6, 0.8, 0.4), Vector3(dx, 0.4, 18.0 + k * 4.0), _dark)
		solid_box(Vector3(2.4, 3.0, 8.0), Vector3(dx, 1.5, 19.5))
		interactable("drill%d" % int(dx), "Look at the boring drill", Vector3(dx, 1.9, 20.0), Vector3(2.4, 2.4, 6.0),
			"TUNELET TBM-%d\nbore: 2.2 m\nlast run: 20 YEARS\ndepth reached: (REDACTED)" % (3 if dx < 60.0 else 4), false)
	box(Vector3(4.0, 3.0, 3.0), Vector3(49.5, 1.5, 29.5), steel, true)
	box(Vector3(4.2, 0.2, 3.2), Vector3(49.5, 3.1, 29.5), _dark)
	interactable("drill_housing", "Hide behind the drill housing", Vector3(49.5, 1.5, 29.5), Vector3(4.2, 3.0, 3.2),
		"DRILL HOUSING\nTBM-3 MOTOR\npower: NONE", true)
	# the church: a circle of twelve chairs, twelve seated, frames on
	var cc := Vector3(59.0, 0, 37.0)
	var chair := mat(Color(0.35, 0.3, 0.26), 0.8)
	var skins := [Color(0.85, 0.66, 0.52), Color(0.6, 0.42, 0.3), Color(0.4, 0.28, 0.2), Color(0.92, 0.78, 0.66)]
	var coats := [Color(0.2, 0.2, 0.22), Color(0.3, 0.26, 0.22), Color(0.15, 0.18, 0.2), Color(0.35, 0.3, 0.3)]
	for i in 12:
		var a := i * TAU / 12.0 + PI / 12.0
		var p := cc + Vector3(cos(a) * 3.4, 0, sin(a) * 3.4)
		var ry := -a - PI / 2.0
		var b := Basis(Vector3.UP, ry)
		box(Vector3(0.45, 0.05, 0.45), p + Vector3(0, 0.45, 0), chair).rotation.y = ry
		box(Vector3(0.45, 0.5, 0.05), p + b * Vector3(0, 0.7, 0.22), chair).rotation.y = ry
		for sx: float in [-0.2, 0.2]:
			for sz: float in [-0.2, 0.2]:
				box(Vector3(0.04, 0.45, 0.04), p + b * Vector3(sx, 0.22, sz), _dark).rotation.y = ry
		var f := figure(coats[i % coats.size()], skins[i % skins.size()], {"arms": true, "knees": true, "visor": true, "hair": Color(0.15, 0.12, 0.1), "long_hair": i % 3 == 0})
		f.position = p + Vector3(0, -0.41, 0)
		f.rotation.y = ry
		add_child(f)
		Anim.sit(f, 0.05)
		congregation.append(f)
	interactable("congregation", "Look at the congregation", cc + Vector3(0, 1.0, 0), Vector3(4.0, 2.0, 4.0),
		"CONGREGATION: 12\ndevices: ORA (UNISSUED) x12\nsync: 100%  -  DREAMING", false)
	# the podium and the priest, whose face will not hold still
	box(Vector3(0.9, 1.2, 0.6), cc + Vector3(0, 0.6, 6.2), mat(Color(0.25, 0.22, 0.2), 0.7), true)
	box(Vector3(1.0, 0.06, 0.7), cc + Vector3(0, 1.23, 6.2), mat(Color(0.3, 0.26, 0.22), 0.7))
	priest = figure(Color(0.03, 0.03, 0.035), Color(0.8, 0.7, 0.62), {"arms": true, "knees": true, "hair": Color(0.02, 0.02, 0.02), "long_coat": true})
	priest.position = cc + Vector3(0, 0.02, 7.0)
	priest.rotation.y = 0.0
	priest.scale = Vector3.ONE * 1.08
	add_child(priest)
	for a in priest.get_meta("arms"):
		(a as Node3D).rotation.z = 1.1 if (a as Node3D).position.x > 0.0 else -1.1
		(a as Node3D).rotation.x = -0.6
	var hd: Node3D = priest.get_meta("head")
	for c in hd.get_children():
		if c is MeshInstance3D:
			priest_head = c
			break
	for i in 6:
		priest_faces.append(Body.face_mat(skins[i % skins.size()], [Color(0.1, 0.08, 0.06), Color(0.6, 0.5, 0.3), Color(0.02, 0.02, 0.02)][i % 3], i % 2 == 1, 700 + i * 31))
	carl_face = Body.face_mat(Color(0.84, 0.66, 0.54), Color(0.12, 0.09, 0.07), false, 1)
	person("priest", "Look at the man at the podium", priest, "UNKNOWN\nface: (CHANGING)\ndevices: NONE\nsync: ???")
	# the wire eye on the concrete above: ten feet of it, bent by hand
	var wire := mat(Color(0.55, 0.55, 0.58), 0.35, 0.85)
	var ey := H - 0.08
	var prev_u := Vector3.ZERO
	var prev_l := Vector3.ZERO
	for i in 17:
		var u := -1.0 + i / 8.0
		var px := cc.x + u * 1.55
		var dz := 0.9 * (1.0 - u * u)
		var pu := Vector3(px, ey, cc.z - dz)
		var pl := Vector3(px, ey, cc.z + dz)
		if i > 0:
			stick(prev_u, pu, 0.03, wire)
			stick(prev_l, pl, 0.03, wire)
		prev_u = pu
		prev_l = pl
	for r: float in [0.58, 0.32]:
		var prev := Vector3.ZERO
		for i in 13:
			var a := i * TAU / 12.0
			var p := Vector3(cc.x + cos(a) * r, ey, cc.z + sin(a) * r)
			if i > 0:
				stick(prev, p, 0.03, wire)
			prev = p
	sphere(0.12, Vector3(cc.x, ey, cc.z), mat(Color(0.05, 0.05, 0.06), 0.4), 8)
	for k in 6:
		var a := k * TAU / 6.0
		stick(Vector3(cc.x + cos(a) * 1.0, ey, cc.z + sin(a) * 0.6), Vector3(cc.x + cos(a) * 1.0, ey + 0.08, cc.z + sin(a) * 0.6), 0.02, wire)
	interactable("wire_eye", "Stand under the wire eye", cc + Vector3(0, 0.6, 0), Vector3(3.2, 1.2, 2.0), "", false)
	# one work lamp on the floor, aimed up at the eye, and the dark round it
	box(Vector3(0.5, 0.3, 0.3), cc + Vector3(2.0, 0.15, -3.0), mat(Color(0.9, 0.75, 0.2), 0.5))
	box(Vector3(0.3, 0.2, 0.1), cc + Vector3(2.0, 0.38, -3.0), glow(Color(1.0, 0.95, 0.85), 3.0))
	var sp := SpotLight3D.new()
	sp.position = cc + Vector3(2.0, 0.45, -3.0)
	sp.look_at_from_position(sp.position, cc + Vector3(0, ey, 0), Vector3.FORWARD)
	sp.light_color = Color(1.0, 0.92, 0.8)
	sp.light_energy = 4.0
	sp.spot_range = 18.0
	sp.spot_angle = 38.0
	add_child(sp)
	light(cc + Vector3(0, 6.0, 0), Color(1.0, 0.8, 0.6), 1.6, 18.0)
	light(Vector3(59.0, 5.0, 27.0), Color(1.0, 0.75, 0.55), 0.8, 14.0)
	light(cc + Vector3(0, 1.5, 0), Color(1.0, 0.3, 0.2), 0.5, 6.0, false)
	# the drill pit at the back, where the shanty-town tunnel comes up
	floor_quad(Vector2(4.0, 4.0), Vector3(PIT.x, 0.02, PIT.z), 0.0, mat(Color(0.01, 0.01, 0.012), 1.0))
	for k in 4:
		var a := k * TAU / 4.0 + PI / 4.0
		box(Vector3(0.08, 1.0, 0.08), Vector3(PIT.x + cos(a) * 2.8, 0.5, PIT.z + sin(a) * 2.8), _rust)
	for k in 4:
		var a := k * TAU / 4.0
		var b := Basis(Vector3.UP, -a)
		box(Vector3(4.0, 0.06, 0.06), Vector3(PIT.x, 1.0, PIT.z) + b * Vector3(0, 0, 2.0), _rust).rotation.y = -a
	solid_box(Vector3(4.6, 1.2, 0.2), PIT + Vector3(0, 0.6, 2.0))
	solid_box(Vector3(4.6, 1.2, 0.2), PIT + Vector3(0, 0.6, -2.0))
	solid_box(Vector3(0.2, 1.2, 4.6), PIT + Vector3(2.0, 0.6, 0))
	solid_box(Vector3(0.2, 1.2, 4.6), PIT + Vector3(-2.0, 0.6, 0))
	interactable("drill_pit", "Look into the drill pit", PIT + Vector3(0, 0.6, 0), Vector3(4.0, 1.2, 4.0),
		"DRILL PIT\ndepth: (NO READING)\nair: MOVING", false)
	# the hatch in the shanty lot, under a pallet, where the tunnel starts
	box(Vector3(1.2, 0.12, 1.2), Vector3(36.0, 0.2, 34.0), mat(Color(0.25, 0.25, 0.27), 0.5, 0.6))
	box(Vector3(1.0, 0.12, 1.0), Vector3(36.4, 0.32, 34.3), mat(Color(0.5, 0.4, 0.28), 0.9)).rotation.y = 0.3
	interactable("hatch", "Look at the hatch", Vector3(36.0, 0.3, 34.0), Vector3(1.4, 0.5, 1.4),
		"ACCESS HATCH\nowner: TUNELET\nleads: TBM-3 PIT", false)
	# sand slope and dead screen at the fence, as the street sees it
	var sand := decal_mat(Tex.sand(), Color(1, 1, 1), 1.0)
	for i in 6:
		floor_quad(Vector2(5.0, 3.0) * rng.randf_range(0.7, 1.3), Vector3(59.0 + rng.randf_range(-8.0, 8.0), 0.16 + i * 0.001, FRONT - rng.randf_range(0.5, 4.0)), rng.randf() * TAU, sand)
	interactable("tunelet", "Look into the plant", Vector3(59.0, 5.0, 24.6), Vector3(14.0, 10.0, 1.0),
		"TUNELET CONSTRUCTION PLANT\nstatus: ABANDONED\nsubterranean access: SEALED (?)", false)
	_dead_screen(Vector3(100.5, 6.5, FRONT - 0.3), PI, 10.0, 6.0, "NIXTRA\na new flavour: CALM")


## Site 3's eye layer: the tunnel mouth past the deck, chained, and the
## footprints that only the frames can see, all walking into it.
func _tunnel_mouth() -> void:
	var p := Vector3(157.0, 0, -22.0)
	box(Vector3(2.0, 5.0, 8.0), p + Vector3(0, 2.5, 0), _conc, true)
	box(Vector3(8.0, 6.0, 2.0), p + Vector3(3.0, 3.0, -5.0), _conc, true)
	box(Vector3(8.0, 6.0, 2.0), p + Vector3(3.0, 3.0, 5.0), _conc, true)
	box(Vector3(10.0, 2.0, 12.0), p + Vector3(4.0, 5.0, 0), _conc, true)
	quad(Vector2(6.0, 4.0), p + Vector3(-1.02, 2.0, 0), PI / 2.0, mat(Color(0.01, 0.01, 0.012), 1.0))
	var bars := mat(Color(0.2, 0.2, 0.22), 0.5, 0.7)
	for k in 9:
		box(Vector3(0.06, 4.0, 0.06), p + Vector3(-1.1, 2.0, -3.0 + k * 0.75), bars)
	box(Vector3(0.08, 0.08, 6.4), p + Vector3(-1.1, 1.2, 0), bars)
	box(Vector3(0.08, 0.08, 6.4), p + Vector3(-1.1, 3.0, 0), bars)
	stick(p + Vector3(-1.2, 1.1, -0.4), p + Vector3(-1.2, 1.3, 0.4), 0.025, bars)
	box(Vector3(0.12, 0.2, 0.3), p + Vector3(-1.22, 1.2, 0), mat(Color(0.7, 0.6, 0.2), 0.4, 0.8))
	label("TUNELET  -  TBM ACCESS 3\nNO ENTRY", p + Vector3(-1.25, 4.6, 0), -PI / 2.0, 0.004, Color(0.85, 0.8, 0.7), self, false).font_size = 48
	interactable("tunnel_mouth", "The tunnel mouth", p + Vector3(-1.1, 2.0, 0), Vector3(0.6, 4.0, 6.0),
		"TUNELET ACCESS 3\nstatus: CHAINED\nchevron: STOPS HERE", false)
	var g := _glyph_on(p + Vector3(-1.03, 4.0, 3.2), -PI / 2.0, 0.006, "g_tunnel", true, false,
		"Two rings on the portal, red and new, beside the NO ENTRY. Painted by somebody on the way in.")
	g.position.x -= 0.02
	# the footprints: two rings at every step, from the camp to the bars
	var path := [Vector3(138.0, 0, 2.0), Vector3(142.0, 0, -4.0), Vector3(146.0, 0, -9.0), Vector3(150.0, 0, -14.0), Vector3(153.5, 0, -19.0), Vector3(155.5, 0, -22.0)]
	for i in path.size() - 1:
		var a: Vector3 = path[i]
		var b: Vector3 = path[i + 1]
		var n := int(a.distance_to(b) / 0.7)
		for k in n:
			var q := a.lerp(b, float(k) / n)
			var side := 0.22 if k % 2 == 0 else -0.22
			var dir := (b - a).normalized()
			q += Vector3(-dir.z, 0, dir.x) * side
			var s := Sprite3D.new()
			s.texture = _glyph_tex
			s.pixel_size = 0.0022
			s.modulate = Color(0.35, 1.0, 0.9, 0.85)
			s.position = q + Vector3(0, 0.03 + i * 0.001, 0)
			s.rotation.x = -PI / 2.0
			s.shaded = false
			s.visible = false
			add_child(s)
			footprints.append(s)
	interactable("footprints", "Look at the ground", Vector3(146.0, 0.3, -9.0), Vector3(8.0, 0.6, 8.0), "", false)
	# the chant wall on the near pier: two lines in marker, the third rubbed out
	var w := label(LINES["chant"]["wall"], Vector3(132.05, 2.2, 9.0), PI / 2.0, 0.0035, Color(0.08, 0.08, 0.1), self, false)
	w.font_size = 44
	w.rotation.z = 0.03
	interactable("chant_wall", "Read the wall", Vector3(132.05, 2.0, 9.0), Vector3(0.3, 2.4, 2.8), "", false)

func _fulfilment() -> void:
	# "toiling away at a shift at the nearby fulfillment center": a long flat
	# warehouse with one big sign, a loading bay, a van, and the substation
	# out front with the old glyph on its panel
	var wall := pbr("concrete", Vector3(1, 1, 1) / 3.5, true, Color(0.62, 0.6, 0.58))
	box(Vector3(34.0, 12.0, 30.0), Vector3(91.0, 6.0, FRONT + 15.0), wall, true)
	box(Vector3(34.4, 0.6, 30.4), Vector3(91.0, 12.3, FRONT + 15.0), _dark)
	neon_text("TOKZ  FULFILMENT", Vector3(91.0, 10.0, FRONT - 0.3), PI, 1.3, Color(1.0, 0.85, 0.25), 2.6)
	sign_lights.append(light(Vector3(91.0, 9.5, FRONT - 2.0), Color(1.0, 0.8, 0.3), 1.0, 10.0))
	# loading bay: a roller shutter, a dock, a ground van backed up to it
	box(Vector3(6.0, 4.0, 0.1), Vector3(84.0, 2.0, FRONT - 0.06), mat(Color(0.3, 0.32, 0.35), 0.5, 0.6))
	box(Vector3(8.0, 1.0, 2.0), Vector3(84.0, 0.5, FRONT - 1.0), _conc, true)
	var van := Node3D.new()
	van.position = Vector3(84.0, 0.0, FRONT - 4.6)
	van.rotation.y = 0.0
	add_child(van)
	van.add_child(Car.build(self, Color(0.85, 0.85, 0.82), {"van": true}))
	solid_box(Vector3(2.2, 2.4, 5.2), Vector3(0, 1.2, 0), van)
	interactable("van", "Look at the van", Vector3(0, 1.2, 0), Vector3(2.3, 2.4, 5.3),
		"TOKZ LOGISTICS 0442\ndriver: NONE\nroute: SOUTHTOWN - SPINE\nnext stop: (NO SIGNAL)", false, van).set_meta("hackable", true)
	# the substation: a cage, transformers, the hum, the panel
	var sp := Vector3(100.0, 0, FRONT - 3.0)
	var mesh_m := newmat(Color(0.45, 0.4, 0.35, 0.4), 0.6, 0.6)
	mesh_m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh_m.cull_mode = BaseMaterial3D.CULL_DISABLED
	box(Vector3(6.0, 2.4, 0.04), sp + Vector3(0, 1.2, -2.5), mesh_m, true)
	box(Vector3(0.04, 2.4, 5.0), sp + Vector3(-3.0, 1.2, 0), mesh_m, true)
	box(Vector3(0.04, 2.4, 5.0), sp + Vector3(3.0, 1.2, 0), mesh_m, true)
	for k in 2:
		var tp := sp + Vector3(-1.5 + k * 3.0, 0, 0.5)
		box(Vector3(1.6, 1.8, 1.2), tp + Vector3(0, 0.9, 0), mat(Color(0.35, 0.38, 0.35), 0.5, 0.5))
		for j in 4:
			box(Vector3(1.7, 0.08, 1.3), tp + Vector3(0, 0.4 + j * 0.4, 0), _dark)
		cyl(0.06, 0.06, 0.8, tp + Vector3(0, 2.2, 0), mat(Color(0.7, 0.7, 0.65), 0.4), 8)
	box(Vector3(1.2, 1.6, 0.12), sp + Vector3(0, 1.1, -2.45), mat(Color(0.5, 0.52, 0.5), 0.5, 0.5))
	label("VOLTX\nSUBSTATION 9\nDANGER", sp + Vector3(0, 1.7, -2.52), PI, 0.0025, Color(0.9, 0.2, 0.15), self, false).font_size = 48
	interactable("substation", "Look at the substation", sp + Vector3(0, 1.1, -2.5), Vector3(1.4, 1.6, 0.3),
		"VOLTX SUBSTATION 9\nload: 140%\nsupply: SOUTHTOWN GRID C\noutages this month: 31", false).set_meta("hackable", true)


# ------------------------------------------------------------------ the alley and the overpass

func _alley() -> void:
	# "a narrow alley, a chasm of shadow half-swallowed by drifts of sand and
	# accumulated waste": the blocks close in to a four-metre gap
	var wall := pbr("concrete", Vector3(1, 1, 1) / 3.0, true, Color(0.5, 0.46, 0.42))
	for side: float in [-1.0, 1.0]:
		box(Vector3(20.0, 14.0, 11.0), Vector3(118.0, 7.0, side * 7.5), wall, true)
		box(Vector3(20.4, 0.6, 11.4), Vector3(118.0, 14.3, side * 7.5), _dark)
		# pipes, an AC unit, a fire escape
		for k in 3:
			box(Vector3(0.12, 10.0, 0.12), Vector3(110.0 + k * 3.5, 5.0, side * 1.95), _rust)
		box(Vector3(1.0, 0.8, 0.6), Vector3(121.0, 3.0, side * 1.7), _metal)
	for k in 4:
		box(Vector3(0.1, 0.1, 4.0), Vector3(112.0 + k * 4.0, 9.0 + (k % 2) * 2.0, 0), _dark)
	# sand drifts and waste along the walls
	var sand := decal_mat(Tex.sand(), Color(1, 1, 1), 1.0)
	for i in 10:
		floor_quad(Vector2(3.5, 2.2) * rng.randf_range(0.6, 1.3), Vector3(109.0 + i * 2.0, 0.16, rng.randf_range(-1.6, 1.6)), rng.randf() * TAU, sand)
	for side: float in [-1.0, 1.0]:
		var drift := box(Vector3(20.0, 0.5, 1.2), Vector3(118.0, 0.1, side * 1.6), mat(Color(0.7, 0.58, 0.42), 1.0))
		drift.rotation.x = side * 0.3
	var trash := [mat(Color(0.3, 0.25, 0.18), 0.9), mat(Color(0.15, 0.15, 0.16), 0.9), mat(Color(0.5, 0.5, 0.45), 0.8)]
	for i in 12:
		var b := box(Vector3(0.5, 0.4, 0.4) * rng.randf_range(0.5, 1.5), Vector3(109.0 + rng.randf() * 18.0, 0.25, rng.randf_range(-1.7, 1.7)), trash[i % 3])
		b.rotation = Vector3(rng.randf_range(-0.4, 0.4), rng.randf() * TAU, rng.randf_range(-0.3, 0.3))
	# the floor of the alley
	floor_quad(Vector2(20, 4), Vector3(118.0, 0.15, 0), 0.0, pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.45, 0.42, 0.4)))
	# the two rings, in the alley, where you have to pass under them
	_glyph_on(Vector3(116.0, 2.4, -1.98), 0.0, 0.012, "g_alley", false, true,
		LINES["rings"]["g_alley"])


func _overpass() -> void:
	# a concrete deck across the east end, ten metres up on piers; under it
	# the encampment, deserted, and the eye on the concrete above
	var deck := pbr("concrete", Vector3(1, 1, 1) / 4.0, true, Color(0.6, 0.57, 0.54))
	var under := pbr("concrete", Vector3(1, 1, 1) / 3.0, true, Color(0.42, 0.4, 0.38))
	box(Vector3(24.0, 1.6, 90.0), Vector3(140.0, 7.8, 0.0), deck, true)
	floor_quad(Vector2(24.0, 90.0), Vector3(140.0, 6.99, 0.0), 0.0, under, self, false)
	box(Vector3(24.4, 1.2, 0.4), Vector3(140.0, 9.0, -45.0), _conc)
	box(Vector3(24.4, 1.2, 0.4), Vector3(140.0, 9.0, 45.0), _conc)
	for z: float in [-30.0, -9.0, 9.0, 30.0]:
		for x: float in [131.0, 149.0]:
			box(Vector3(2.0, 7.0, 3.0), Vector3(x, 3.5, z), _conc, true)
			box(Vector3(2.6, 0.5, 3.6), Vector3(x, 6.75, z), _conc)
	# the road on top: barriers, a dead lamp, hover trucks go over it anyway
	box(Vector3(0.4, 1.0, 90.0), Vector3(128.3, 9.1, 0.0), _conc)
	box(Vector3(0.4, 1.0, 90.0), Vector3(151.7, 9.1, 0.0), _conc)
	cyl(0.1, 0.12, 7.0, Vector3(150.5, 12.0, -20.0), _metal, 8)
	# THE EYE: ten feet of jet black across the concrete above the camp
	var em := decal_mat(_eye_paint(), Color(0.04, 0.04, 0.045), 0.95)
	floor_quad(Vector2(4.4, 2.8), EYE_P, 0.0, em, self, false)
	var rings := Sprite3D.new()
	rings.texture = _glyph_tex
	rings.pixel_size = 0.0115
	rings.modulate = Color(0.03, 0.03, 0.035, 1.0)
	rings.position = EYE_P - Vector3(0, 0.006, 0)
	rings.rotation.x = PI / 2.0
	rings.shaded = true
	add_child(rings)
	# drips running down the near pier from it
	var drip := mat(Color(0.04, 0.04, 0.045), 0.9)
	for k in 6:
		var a := EYE_P + Vector3(rng.randf_range(-1.8, 1.8), -0.02, rng.randf_range(-1.0, 1.0))
		stick(a, a + Vector3(0, -rng.randf_range(0.05, 0.3), 0), 0.012, drip)
	interactable("overpass_eye", "Step beneath the eye", EYE_P - Vector3(0, 5.3, 0), Vector3(4.4, 3.2, 2.8), "", false)
	# the encampment: tarps, mattresses, overturned barrel stoves, scorch marks
	var tarp := [newmat(Color(0.22, 0.3, 0.45), 1.0), newmat(Color(0.5, 0.42, 0.2), 1.0), newmat(Color(0.32, 0.3, 0.3), 1.0)]
	for t: StandardMaterial3D in tarp:
		t.cull_mode = BaseMaterial3D.CULL_DISABLED
	var scorch := decal_mat(Tex.blob(), Color(0.03, 0.03, 0.03, 0.85), 1.0)
	var barrel := mat(Color(0.14, 0.09, 0.07), 0.7, 0.4)
	for i in 6:
		var p := Vector3(133.0 + rng.randf_range(0.0, 14.0), 0, -24.0 + i * 8.5 + rng.randf_range(-2.0, 2.0))
		if absf(p.z) < 4.0:
			p.z = 4.0 * signf(p.z + 0.01)
		# a tarp strung between a pier and a pole, sagging, torn
		var pole := p + Vector3(rng.randf_range(-1.5, 1.5), 0, rng.randf_range(2.0, 3.5))
		stick(pole, pole + Vector3(0, 2.0, 0), 0.03, _rust)
		var q := quad(Vector2(3.0, 2.4), p + Vector3(0, 1.6, 1.2), rng.randf_range(-0.3, 0.3), tarp[i % 3])
		q.rotation.x = -1.2 + rng.randf_range(-0.2, 0.2)
		var fl := quad(Vector2(1.2, 1.6), pole + Vector3(0.3, 1.0, 0.1), 0.6, tarp[i % 3])
		fl.rotation.z = 0.3
		no_batch.append(fl)
		fl.set_meta("flap", rng.randf() * TAU)
		box(Vector3(1.8, 0.18, 0.9), p + Vector3(0, 0.09, 0), mat(Color(0.5, 0.46, 0.42), 1.0))
		box(Vector3(0.6, 0.4, 0.4), p + Vector3(1.4, 0.2, -0.3), mat(Color(0.3, 0.25, 0.18), 0.9))
		# the barrel stove, overturned, scorched, "like fallen monoliths"
		var bp := p + Vector3(rng.randf_range(-2.0, 2.0), 0.36, -1.8)
		var b := cyl(0.36, 0.36, 0.9, bp, barrel, 12)
		b.rotation = Vector3(PI / 2.0 + rng.randf_range(-0.2, 0.2), rng.randf() * TAU, 0)
		cyl(0.3, 0.3, 0.1, bp + Vector3(0, -0.3, 0), barrel, 12).rotation = b.rotation
		floor_quad(Vector2(2.4, 1.8), bp - Vector3(0, 0.345, 0), rng.randf() * TAU, scorch)
	# a shopping trolley on its side, a pile of pallets, the cold fire ring at the middle
	var ring_p := Vector3(140.0, 0, 0.0)
	for k in 10:
		var a := k * TAU / 10.0
		box(Vector3(0.4, 0.25, 0.3), ring_p + Vector3(cos(a) * 1.3, 0.12, sin(a) * 1.3), _conc).rotation.y = -a
	floor_quad(Vector2(2.4, 2.4), ring_p + Vector3(0, 0.17, 0), 0.0, scorch)
	for k in 4:
		box(Vector3(1.0, 0.12, 1.0), Vector3(146.0, 0.06 + k * 0.13, 12.0), mat(Color(0.5, 0.4, 0.28), 0.9))
	interactable("camp", "Look at the encampment", Vector3(140.0, 1.0, -6.0), Vector3(14.0, 2.0, 3.0),
		"UNREGISTERED DWELLINGS: 6\noccupants: 0\nlast heat signature: 9 days", false)
	interactable("barrels", "Look at the barrel stoves", Vector3(140.0, 0.4, 10.0), Vector3(12.0, 0.8, 3.0), "", false)
	# a weak lamp someone wired to the pier, and the dark under the deck
	var o := light(Vector3(133.0, 5.5, 9.0), Color(1.0, 0.7, 0.4), 0.9, 12.0)
	flickers.append(o)
	box(Vector3(0.3, 0.2, 0.3), Vector3(132.1, 5.6, 9.0), glow(Color(1.0, 0.75, 0.45), 2.0, true))
	cable(Vector3(132.0, 6.9, 9.0), Vector3(128.2, 7.0, 2.0), 0.4)


func _desert() -> void:
	# past the overpass the city gives out: a fence, sand, the red horizon
	var sand_m := pbr("concrete", Vector3(1, 1, 1) / 6.0, true, Color(0.9, 0.68, 0.46))
	floor_quad(Vector2(200, 300), Vector3(252.0, 0.02, 0), 0.0, sand_m)
	floor_quad(Vector2(50, 90), Vector3(152.0, 0.03, 0), 0.0, pbr("concrete", Vector3(1, 1, 1) / 3.0, true, Color(0.62, 0.55, 0.46)))
	var mesh_m := newmat(Color(0.45, 0.4, 0.35, 0.4), 0.6, 0.6)
	mesh_m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh_m.cull_mode = BaseMaterial3D.CULL_DISABLED
	box(Vector3(0.04, 2.6, 90.0), Vector3(162.0, 1.3, 0), mesh_m, true)
	for k in 12:
		cyl(0.05, 0.05, 2.8, Vector3(162.0, 1.4, -44.0 + k * 8.0), _rust, 6)
	box(Vector3(3.0, 1.0, 0.1), Vector3(161.9, 1.6, -2.0), mat(Color(0.8, 0.75, 0.6), 0.7))
	var w := label("CITY LIMIT\nNO SERVICE BEYOND THIS POINT\nPSYONIC INTEGRATIONS", Vector3(161.85, 1.6, -2.0), -PI / 2.0, 0.0028, Color(0.2, 0.15, 0.1), self, false)
	w.font_size = 48
	interactable("limit", "Read the sign", Vector3(161.9, 1.6, -2.0), Vector3(0.3, 1.0, 3.0), "", false)
	# dunes, and a pylon line walking off into it
	var dune := mat(Color(0.86, 0.62, 0.42), 1.0)
	for k in 7:
		var p := Vector3(185.0 + k * 20.0, 0, rng.randf_range(-60.0, 60.0))
		var s := sphere(rng.randf_range(8.0, 16.0), p - Vector3(0, 8.0, 0), dune, 10)
		s.scale = Vector3(1.6, 0.35, 1.0)
	for k in 5:
		var px := 175.0 + k * 30.0
		cyl(0.3, 0.6, 24.0, Vector3(px, 12.0, 30.0), _metal, 6)
		box(Vector3(6.0, 0.4, 0.4), Vector3(px, 20.0, 30.0), _metal)


# ------------------------------------------------------------------ the backdrop

func _backdrop() -> void:
	# a second row of blocks behind the street on both sides, run-down:
	# most of them dead, a few with their windows and ads still lit. Built
	# into a node of its own so it batches in big pieces.
	var city := Node3D.new()
	add_child(city)
	kit_parent = city
	for side: float in [-1.0, 1.0]:
		var x := -44.0
		while x < 128.0:
			var w := rng.randf_range(14.0, 24.0)
			var h := rng.randf_range(18.0, 40.0) if rng.randf() > 0.2 else rng.randf_range(44.0, 70.0)
			kit_dead = rng.randf() < 0.55
			cyber_block(Vector3(x + w / 2.0, 0, side * 57.0), 0.0 if side < 0.0 else PI, w, h, 20.0, false, 1)
			x += w + rng.randf_range(0.0, 3.0)
		# a third row, taller, mostly dark
		x = -60.0
		while x < 170.0:
			var w := rng.randf_range(18.0, 30.0)
			kit_dead = rng.randf() < 0.7
			cyber_block(Vector3(x + w / 2.0, 0, side * 92.0), 0.0 if side < 0.0 else PI, w, rng.randf_range(30.0, 80.0), 24.0, false, 1)
			x += w + rng.randf_range(0.0, 4.0)
	kit_dead = false
	# a skybridge, cables, and two holo ads: one working, one stuttering
	skybridge(Vector3(85.0, 16.0, -FRONT), Vector3(85.0, 14.5, FRONT), 3.5)
	for i in 12:
		var x := rng.randf_range(-30.0, 108.0)
		cable(Vector3(x, rng.randf_range(9.0, 14.0), -FRONT + 0.2), Vector3(x + rng.randf_range(-6.0, 6.0), rng.randf_range(8.0, 13.0), FRONT - 0.2), 0.8)
	kit_holo(Vector3(26.0, 14.0, FRONT + 4.0), PI, "PSYON", "the pillow for those who dream", Color(0.4, 0.9, 1.0), 16.0)
	kit_holo(Vector3(96.0, 22.0, -FRONT - 2.0), 0.0, "VOLTX", "the grid that never sleeps", Color(1.0, 0.5, 0.12), 14.0)
	kit_parent = self
	_batch(city, 40.0, true)
	# the Jade Tower, far off to the north-west, over everything
	var jade := mat(Color(0.2, 0.45, 0.38), 0.3, 0.7)
	var silver := mat(Color(0.7, 0.72, 0.75), 0.25, 0.8)
	var tp := Vector3(-400, 0, -800)
	cyl(50, 56, 36, tp + Vector3(0, 18, 0), jade, 24)
	cyl(16, 30, 440, tp + Vector3(0, 256, 0), jade, 16)
	var tm := TorusMesh.new()
	tm.inner_radius = 58
	tm.outer_radius = 108
	tm.rings = 32
	tm.ring_segments = 12
	mesh(tm, tp + Vector3(0, 540, 0), silver)
	# the smokestacks of the south side, two of them still breathing
	for k in 3:
		var sp := Vector3(40.0 + k * 45.0, 0, 62.0)
		cyl(1.6, 2.4, 40.0, sp + Vector3(0, 20.0, 0), _conc, 10)
		blinkers.append(box(Vector3(0.3, 0.3, 0.3), sp + Vector3(0, 40.5, 0), glow(Color(1, 0.05, 0.05), 4.0)))


func _street_dressing() -> void:
	# streetlights, some of them bent; a bus shelter with a dead screen; bins;
	# a hover truck parked on nothing; cables; and a dead smart-bin
	var pole := mat(Color(0.14, 0.14, 0.15), 0.5, 0.7)
	var x := -2.0
	var i := 0
	while x < 108.0:
		for side: float in [-1.0, 1.0]:
			var p := Vector3(x, 0, side * 7.6)
			var tilt := rng.randf_range(-0.08, 0.08) if i % 4 == 2 else 0.0
			var c := cyl(0.09, 0.12, 7.0, p + Vector3(0, 3.5, 0), pole, 8)
			c.rotation.z = tilt
			box(Vector3(0.12, 0.12, 1.8), p + Vector3(0, 6.9, -side * 0.9), pole)
			var on := (i + int(side)) % 3 != 0
			box(Vector3(0.35, 0.12, 0.7), p + Vector3(0, 6.8, -side * 1.6), glow(Color(1.0, 0.62, 0.32), 2.0, true) if on else _dark)
			if on and i % 2 == 0:
				var o := light(p + Vector3(0, 6.5, -side * 1.6), Color(1.0, 0.62, 0.32), 1.2, 12.0)
				if rng.randf() < 0.3:
					flickers.append(o)
			i += 1
		x += 22.0
	# things to walk round and duck behind: wrecks at the curb, dumpsters,
	# planters full of sand, barriers where the road was dug up and left
	_wreck(Vector3(14.0, 0, 5.2), PI / 2.0 + 0.1)
	_wreck(Vector3(66.0, 0, -5.0), -PI / 2.0 - 0.15)
	_dumpster(Vector3(26.0, 0, -9.5), 0.0)
	_dumpster(Vector3(58.0, 0, 9.5), 0.1)
	_dumpster(Vector3(96.0, 0, -9.0), -0.1)
	for k in 5:
		box(Vector3(2.8, 1.0, 0.8), Vector3(84.0 + k * 3.0, 0.5, 2.0), _conc, true)
	box(Vector3(14.0, 0.6, 3.0), Vector3(90.0, 0.3, 2.5), mat(Color(0.62, 0.5, 0.36), 1.0))
	for px: float in [38.0, 62.0, 104.0]:
		box(Vector3(2.0, 0.8, 1.0), Vector3(px, 0.4, 8.2), _conc, true)
		box(Vector3(1.8, 0.1, 0.8), Vector3(px, 0.82, 8.2), mat(Color(0.72, 0.6, 0.42), 1.0))
	# a bus shelter, its screen dead, by the shanty lot
	var glass := newmat(Color(0.5, 0.7, 0.8, 0.18), 0.05)
	glass.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	box(Vector3(5.0, 0.12, 2.0), Vector3(30.0, 2.8, 10.5), _metal)
	box(Vector3(5.0, 2.6, 0.05), Vector3(30.0, 1.5, 11.5), glass)
	for sx: float in [-2.4, 2.4]:
		box(Vector3(0.1, 2.8, 0.1), Vector3(30.0 + sx, 1.4, 11.5), _metal)
	box(Vector3(3.5, 0.45, 0.6), Vector3(30.0, 0.45, 11.0), _metal, true)
	box(Vector3(1.1, 1.6, 0.06), Vector3(32.0, 1.6, 11.45), mat(Color(0.05, 0.05, 0.06), 0.2, 0.3))
	label("SALTECH SHUTTLE\nNO SERVICE", Vector3(32.0, 1.9, 11.4), PI, 0.0035, Color(0.5, 0.2, 0.15), self, false).font_size = 64
	interactable("shelter", "Read the timetable", Vector3(31.0, 1.4, 11.2), Vector3(3.0, 2.6, 0.8),
		"SALTECH SHUTTLE STOP 40\nservice: NONE\nsince: 2041", false).set_meta("hackable", true)
	# more light on the street: neon strips and blades on the blocks that still pay their bill
	neon_text("PARTS", Vector3(99.0, 3.9, -12.7), 0.0, 0.7, Color(1.0, 0.5, 0.12), 2.6)
	sign_lights.append(light(Vector3(99.0, 3.8, -11.4), Color(1.0, 0.5, 0.12), 1.0, 8.0))
	neon_text("LIQUOR", Vector3(-3.0, 3.9, 12.7), PI, 0.7, Color(0.3, 1.0, 0.5), 2.6)
	for k in 3:
		box(Vector3(14.0, 0.12, 0.1), Vector3(91.0, 6.0 + k * 0.5, FRONT - 0.06), glow(Color(1.0, 0.85, 0.25), 2.4, true))
	box(Vector3(0.16, 9.0, 0.16), Vector3(104.0, 7.0, FRONT - 0.08), glow(Color(0.62, 0.28, 1.0), 2.4, true))
	box(Vector3(0.16, 9.0, 0.16), Vector3(78.0, 7.0, FRONT - 0.08), glow(Color(0.62, 0.28, 1.0), 2.4, true))
	# bins and a smart bin, dead, lid open
	for bx: float in [8.0, 76.0]:
		box(Vector3(0.6, 1.0, 0.6), Vector3(bx, 0.5, -9.0), mat(Color(0.2, 0.3, 0.26), 0.5, 0.4), true)
		var lid := box(Vector3(0.62, 0.05, 0.62), Vector3(bx, 1.05, -9.3), mat(Color(0.18, 0.26, 0.22), 0.5, 0.4))
		lid.rotation.x = -1.4
	interactable("bin", "Look at the smart bin", Vector3(8.0, 0.5, -9.0), Vector3(0.7, 1.0, 0.7),
		"SMART BIN 212\nsensor: OFFLINE\nlid: STUCK OPEN (9 DAYS)", false).set_meta("hackable", true)
	# hover trucks that go up and down the street, high, over the overpass
	for k in 3:
		var tr := Node3D.new()
		tr.position = Vector3(-40.0 + k * 70.0, 9.5 + k * 1.5, -3.0 + k * 3.0)
		add_child(tr)
		var body: Node3D = Car.build(self, [Color(0.85, 0.85, 0.82), Color(0.3, 0.3, 0.32), Color(0.9, 0.6, 0.1)][k],
			{"van": true, "hover": true, "head": glow(Color(1, 0.97, 0.9), 4.0, true), "tail": glow(Color(1, 0.05, 0.05), 3.0, true)})
		tr.add_child(body)
		tr.rotation.y = -PI / 2.0 if k % 2 == 0 else PI / 2.0
		box(Vector3(1.8, 0.04, 4.6), Vector3(0, -0.3, 0), glow(Color(0.2, 0.9, 1.0), 2.0, true), false, tr)
		trucks.append([tr, 1.0 if k % 2 == 0 else -1.0, rng.randf_range(9.0, 14.0)])
	# a working ad on the pawn block, the only screen on the street with a picture
	var ap := Vector3(-3.0, 9.0, FRONT - 0.4)
	box(Vector3(6.6, 4.2, 0.3), ap + Vector3(0, 0, 0.3), _dark)
	quad(Vector2(6.0, 3.6), ap, PI, glow(Color(0.3, 0.9, 0.7) * 0.5, 1.2, true))
	neon_text("FREUDBOT", ap + Vector3(0, 0.6, -0.03), PI, 0.9, Color(0.9, 1.0, 0.95), 2.2)
	neon_text("talk to someone who listens", ap + Vector3(0, -0.6, -0.03), PI, 0.36, Color(1, 0.97, 0.92), 2.0)
	interactable("ad", "Look at the ad", ap, Vector3(6.0, 3.6, 0.6), "FREUDBOT DISPLAY 3\nfirmware: 2031\nadmin password: DEFAULT", false).set_meta("hackable", true)


# ------------------------------------------------------------------ the rings

func _glyphs() -> void:
	# the three of them Lynx meant, painted, visible to everyone
	_glyph_on(Vector3(-26.5, 1.75, -11.4), 0.0, 0.006, "g_kiosk", false, true,
		LINES["rings"]["g_kiosk"])
	_glyph_on(Vector3(50.0, 1.7, -FRONT + 0.17), 0.0, 0.014, "g_factory", false, true,
		LINES["rings"]["g_factory"])
	var g := _glyph_on(Vector3(100.0, 1.0, FRONT - 5.57), PI, 0.0055, "g_substation", false, true,
		LINES["rings"]["g_substation"])
	(g.get_meta("sprite") as Sprite3D).modulate = Color(0.45, 0.42, 0.38)


# ------------------------------------------------------------------ people

func _people() -> void:
	# Lynx, slouched against the station wall, arms crossed tight. Dark hair
	# curled, loose round a sharp jaw. Frames on: she is the only one here
	# wearing anything that blinks, apart from Carl.
	lynx = figure(Color(0.09, 0.08, 0.1), Color(0.88, 0.74, 0.62),
		{"hair": Color(0.12, 0.08, 0.06), "long_hair": true, "legs": Color(0.1, 0.1, 0.12), "arms": true, "knees": true, "visor": true, "long_coat": true})
	lynx.position = LYNX_WAIT
	lynx.rotation.y = PI
	add_child(lynx)
	_lynx_lean(true)
	interactable("lynx", "Talk to Lynx", Vector3(0, 0.9, 0), Vector3(0.7, 1.9, 0.7), "LYNX (ANALYST, PSYONIC)\nORA gen 6\nsync: 71%  -  AWAKE", false, lynx)
	# commuters crossing the forecourt, quick, gazes averted, no frames on
	var coats := [Color(0.3, 0.28, 0.26), Color(0.2, 0.22, 0.28), Color(0.45, 0.35, 0.25), Color(0.25, 0.3, 0.25), Color(0.5, 0.5, 0.52)]
	var skins := [Color(0.85, 0.66, 0.52), Color(0.6, 0.42, 0.3), Color(0.4, 0.28, 0.2), Color(0.92, 0.78, 0.66)]
	var routes := [[Vector3(-32.0, 0, -9.5), Vector3(-7.0, 0, -9.5)], [Vector3(-9.0, 0, 11.0), Vector3(-30.0, 0, -7.0)],
		[Vector3(-20.0, 0, -10.5), Vector3(-6.0, 0, 10.0)], [Vector3(-33.0, 0, 11.0), Vector3(-21.0, 0, -10.0)],
		[Vector3(-7.0, 0, -11.0), Vector3(-33.0, 0, -3.0)],
		[Vector3(0.0, 0, -9.0), Vector3(100.0, 0, -9.5)], [Vector3(104.0, 0, 9.0), Vector3(6.0, 0, 9.5)], [Vector3(20.0, 0, -10.0), Vector3(74.0, 0, 10.0)]]
	for i in routes.size():
		var f := figure(coats[i % coats.size()], skins[i % skins.size()], {"arms": true, "knees": true, "hair": Color(0.1, 0.08, 0.06) if i % 2 == 0 else Color(0.4, 0.3, 0.2)})
		add_child(f)
		var ln: float = (routes[i][0] as Vector3).distance_to(routes[i][1])
		commuters.append({"node": f, "a": routes[i][0], "b": routes[i][1], "t": rng.randf(), "dir": 1.0, "speed": rng.randf_range(1.2, 1.7) / ln})
	# Site 1's three: the informant (no frames, a kind word buys a side door),
	# the one who goes for the frames, and the one mid-conversion, visor lit,
	# facing east at the plant with his lips moving
	vag_informant = figure(Color(0.35, 0.3, 0.25), skins[1], {"arms": true, "knees": true, "hair": Color(0.3, 0.28, 0.26)})
	vag_informant.position = Vector3(20.0, -0.41, 21.0)
	vag_informant.rotation.y = 0.3
	add_child(vag_informant)
	Anim.sit(vag_informant, 0.25)
	box(Vector3(0.5, 0.42, 0.5), Vector3(20.0, 0.2, 21.1), mat(Color(0.5, 0.4, 0.28), 0.9), false)
	box(Vector3(0.3, 0.06, 0.3), Vector3(20.8, 0.03, 20.2), mat(Color(0.5, 0.5, 0.52), 0.4, 0.6))
	vag_informant.set_meta("vagrant", true)
	person("vag_informant", "Talk to the man with the blanket", vag_informant, "UNREGISTERED\ndevices: NONE\nhousing: REVOKED\nknown to: TYSON").set_meta("vagrant", true)
	vag_attacker = figure(Color(0.25, 0.25, 0.28), skins[2], {"arms": true, "knees": true, "hair": Color(0.2, 0.18, 0.16)})
	vag_attacker.position = Vector3(29.0, 0.02, 24.5)
	vag_attacker.rotation.y = -PI / 2.0
	add_child(vag_attacker)
	vag_attacker.set_meta("vagrant", true)
	person("vag_attacker", "The man by the washing line", vag_attacker, "UNREGISTERED\ndevices: NONE\nsync: --\nstate: AGITATED").set_meta("vagrant", true)
	vag_convert = figure(Color(0.4, 0.2, 0.15), skins[3], {"arms": true, "knees": true, "visor": true, "hair": Color(0.2, 0.18, 0.16)})
	vag_convert.position = Vector3(38.5, -0.41, 21.5)
	vag_convert.rotation.y = -PI / 2.0
	add_child(vag_convert)
	Anim.sit(vag_convert, 0.2)
	box(Vector3(0.5, 0.42, 0.5), Vector3(38.5, 0.2, 21.6), mat(Color(0.5, 0.4, 0.28), 0.9), false)
	vag_convert.set_meta("vagrant", true)
	person("vag_convert", "Look at the man with the frames", vag_convert, "UNREGISTERED\nORA GEN 2 (UNISSUED)  -  sync 100%  -  DREAMING\nsaying: '%s'" % main.CHANT[0]).set_meta("vagrant", true)
	# the worker on the shift, head down over the second press
	worker = figure(Color(0.8, 0.95, 0.2), Color(0.7, 0.52, 0.38), {"arms": true, "knees": true, "hair": Color(0.15, 0.12, 0.1)})
	worker.position = Vector3(53.0, 0.02, -27.4)
	worker.rotation.y = PI
	add_child(worker)
	(worker.get_meta("head") as Node3D).rotation.x = 0.55
	for a in worker.get_meta("arms"):
		(a as Node3D).rotation.x = -1.1
	person("worker", "Talk to the man on the shift", worker, "SHIFT WORKER\nVOLTX contractor\ndevices: NONE\nframes: NONE")


## Lynx against the wall: weight back, arms crossed. Or standing straight.
func _lynx_lean(on: bool) -> void:
	var body: Node3D = lynx.get_meta("body")
	body.rotation.x = -0.1 if on else 0.0
	for a in lynx.get_meta("arms"):
		var n := a as Node3D
		n.rotation.x = -0.9 if on else 0.0
		n.rotation.z = (0.55 if n.position.x > 0.0 else -0.55) if on else 0.0
		n.rotation.y = (-0.6 if n.position.x > 0.0 else 0.6) if on else 0.0


func _bounds() -> void:
	solid_box(Vector3(2, 20, 120), Vector3(-44.0, 10, 0))
	solid_box(Vector3(40, 20, 2), Vector3(-24.0, 10, 14.5))
	solid_box(Vector3(4, 20, 30), Vector3(10.0, 10, 52.0))
	solid_box(Vector3(220, 20, 2), Vector3(60.0, 10, -57.5))
	solid_box(Vector3(220, 20, 2), Vector3(60.0, 10, 57.5))
	solid_box(Vector3(2, 20, 120), Vector3(163.0, 10, 0))



# ------------------------------------------------------------------ the back lanes

## The ways round: a service alley north of the street at x 70..74, the gap
## past the shanty lot at x 40..44, and the lanes behind the buildings on
## both sides running east to the overpass. Covered, cluttered, dark even in
## daylight: containers, dumpsters, wrecks, a camp at each dead end.
func _lanes() -> void:
	var yard := pbr("concrete", Vector3(1, 1, 1) / 3.0, true, Color(0.5, 0.46, 0.42))
	floor_quad(Vector2(174, 116), Vector3(43.0, -0.005, 0.0), 0.0, yard)
	var sheet := mat(Color(0.38, 0.35, 0.32), 0.7, 0.6)
	var cont := [mat(Color(0.45, 0.2, 0.15), 0.7, 0.4), mat(Color(0.15, 0.3, 0.4), 0.7, 0.4), mat(Color(0.3, 0.32, 0.2), 0.7, 0.4)]
	# the service alley north: pipes, a canopy, a dumpster to duck behind, a camera
	floor_quad(Vector2(4, 30), Vector3(72.0, 0.01, -28.0), 0.0, pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.4, 0.38, 0.36)))
	for k in 4:
		box(Vector3(0.14, 8.0, 0.14), Vector3(70.3, 4.0, -16.0 - k * 7.0), _rust)
	box(Vector3(4.4, 0.08, 10.0), Vector3(72.0, 4.6, -24.0), sheet)
	box(Vector3(4.4, 0.08, 6.0), Vector3(72.0, 4.2, -38.0), sheet)
	_dumpster(Vector3(72.6, 0, -31.0), PI / 2.0)
	var cam := Node3D.new()
	cam.position = Vector3(70.3, 3.4, -20.0)
	cam.rotation.y = -PI / 2.0 + 0.5
	add_child(cam)
	box(Vector3(0.25, 0.25, 0.5), Vector3(0, 0, -0.15), mat(Color(0.85, 0.85, 0.85), 0.3), false, cam)
	box(Vector3(0.08, 0.08, 0.04), Vector3(0, 0, -0.42), glow(Color(1, 0.1, 0.1), 3.0), false, cam)
	interactable("cam", "Look at the camera", Vector3(0, 0, -0.1), Vector3(0.5, 0.5, 0.8),
		"SECURITY CAMERA (UNLISTED)\nowner: (NONE)\nuplink: SOUTHTOWN GRID C\nfeed: 40 VIEWERS", false, cam).set_meta("hackable", true)
	var o := light(Vector3(72.0, 4.0, -30.0), Color(1.0, 0.55, 0.3), 0.8, 9.0)
	flickers.append(o)
	# the gap south, past the shanty lot: pallets, a container, washing
	for k in 6:
		box(Vector3(1.0, 0.12, 1.0), Vector3(41.0, 0.06 + k * 0.13, 20.0), mat(Color(0.5, 0.4, 0.28), 0.9))
	_container(Vector3(41.0, 0, 42.0), PI / 2.0, cont[1], 2.4, 6.0)
	box(Vector3(4.4, 0.08, 8.0), Vector3(42.0, 4.0, 28.0), sheet)
	# the north lane: the backs of the buildings, a wreck, containers, the camp at the west end
	for k in 5:
		_container(Vector3(20.0 + k * 18.0 + rng.randf_range(-3.0, 3.0), 0, -50.0 + rng.randf_range(-2.0, 2.0)), rng.randf_range(-0.2, 0.2), cont[k % 3], 2.4, 6.0 if k % 2 == 0 else 12.0)
	_wreck(Vector3(95.0, 0, -47.0), 0.4)
	_dumpster(Vector3(60.0, 0, -45.0), 0.0)
	_dumpster(Vector3(110.0, 0, -52.0), 0.3)
	for k in 6:
		box(Vector3(6.0, 0.08, 4.0), Vector3(12.0 + k * 20.0, 4.3, -46.5), sheet).rotation.z = 0.05
	for k in 4:
		var o2 := light(Vector3(10.0 + k * 30.0, 3.8, -48.0), Color(1.0, 0.55, 0.3), 0.7, 9.0)
		if k % 2 == 0:
			flickers.append(o2)
	_camp(Vector3(-8.0, 0, -46.0))
	# the south lane: the same, longer, with the camp at the far end under the overpass approach
	for k in 5:
		_container(Vector3(50.0 + k * 16.0 + rng.randf_range(-3.0, 3.0), 0, 50.0 + rng.randf_range(-2.0, 2.0)), rng.randf_range(-0.2, 0.2), cont[(k + 1) % 3], 2.4, 12.0 if k % 2 == 0 else 6.0)
	_wreck(Vector3(30.0, 0, 48.0), -0.3)
	_dumpster(Vector3(80.0, 0, 45.0), 0.0)
	_dumpster(Vector3(118.0, 0, 20.0), 0.0)
	for k in 5:
		box(Vector3(6.0, 0.08, 4.0), Vector3(50.0 + k * 20.0, 4.2, 49.8), sheet).rotation.z = -0.05
	for k in 4:
		var o3 := light(Vector3(45.0 + k * 25.0, 3.8, 48.0), Color(0.8, 0.9, 1.0), 0.6, 9.0)
		if k % 2 == 1:
			flickers.append(o3)
	_camp(Vector3(116.0, 0, 30.0))
	# jersey barriers and a fence that someone cut, behind the alley blocks
	for k in 4:
		box(Vector3(2.8, 1.0, 0.8), Vector3(112.0 + k * 3.0, 0.5, 15.0), _conc, true)
	for k in 4:
		box(Vector3(2.8, 1.0, 0.8), Vector3(112.0 + k * 3.0, 0.5, -15.0), _conc, true)
	var mesh_m := newmat(Color(0.45, 0.4, 0.35, 0.4), 0.6, 0.6)
	mesh_m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh_m.cull_mode = BaseMaterial3D.CULL_DISABLED
	box(Vector3(0.04, 2.4, 20.0), Vector3(128.0, 1.2, -30.0), mesh_m, true)
	box(Vector3(0.04, 2.4, 14.0), Vector3(128.0, 1.2, -50.0), mesh_m, true)
	box(Vector3(0.04, 2.4, 20.0), Vector3(128.0, 1.2, 30.0), mesh_m, true)
	box(Vector3(0.04, 2.4, 14.0), Vector3(128.0, 1.2, 50.0), mesh_m, true)
	for z: float in [-20.0, -40.0, -43.0, -57.0, 20.0, 40.0, 43.0, 57.0]:
		cyl(0.05, 0.05, 2.5, Vector3(128.0, 1.25, z), _rust, 6)
	# the rings in the lanes too, small, at knee height, where nobody looks
	_glyph_on(Vector3(70.17, 0.6, -36.0), PI / 2.0, 0.004, "g_lane_n", false, false,
		LINES["rings"]["g_lane_n"])
	_glyph_on(Vector3(62.0, 1.2, 47.23), 0.0, 0.006, "g_lane_s", true, false,
		LINES["rings"]["g_lane_s"])


func _dumpster(p: Vector3, rot_y: float) -> void:
	var n := Node3D.new()
	n.position = p
	n.rotation.y = rot_y
	add_child(n)
	box(Vector3(2.4, 1.3, 1.2), Vector3(0, 0.75, 0), mat(Color(0.15, 0.3, 0.2), 0.6, 0.4), false, n)
	box(Vector3(2.5, 0.12, 1.3), Vector3(0, 1.42, 0), mat(Color(0.12, 0.24, 0.16), 0.6, 0.4), false, n)
	for k in 4:
		box(Vector3(0.5, 0.4, 0.4), Vector3(-1.5 + k * 0.3, 0.2, 0.9), mat(Color(0.3, 0.25, 0.18), 0.9), false, n)
	solid_box(Vector3(2.5, 1.5, 1.3), Vector3(0, 0.75, 0), n)


func _container(p: Vector3, rot_y: float, m: Material, h: float, ln: float) -> void:
	var n := Node3D.new()
	n.position = p
	n.rotation.y = rot_y
	add_child(n)
	box(Vector3(ln, h, 2.4), Vector3(0, h / 2.0, 0), m, false, n)
	for k in int(ln / 0.6):
		box(Vector3(0.1, h - 0.2, 0.08), Vector3(-ln / 2.0 + 0.3 + k * 0.6, h / 2.0, 1.22), _dark, false, n)
	solid_box(Vector3(ln, h, 2.4), Vector3(0, h / 2.0, 0), n)


## A hover car that came down and never got up again, stripped.
func _wreck(p: Vector3, rot_y: float) -> void:
	var n := Node3D.new()
	n.position = p + Vector3(0, -0.2, 0)
	n.rotation = Vector3(0.08, rot_y, -0.12)
	add_child(n)
	n.add_child(Car.build(self, Color(0.3, 0.26, 0.22), {"hover": true}))
	solid_box(Vector3(2.0, 1.4, 4.6), Vector3(0, 0.7, 0), n)
	floor_quad(Vector2(5.0, 3.0), p + Vector3(0.5, 0.012, 0.5), rot_y, decal_mat(Tex.blob(), Color(0.05, 0.04, 0.03, 0.6), 1.0))


## A vagrants' camp at a dead end: a tarp, a cold fire, bedding, a lamp.
func _camp(p: Vector3) -> void:
	var tarp := newmat(Color(0.3, 0.3, 0.32), 1.0)
	tarp.cull_mode = BaseMaterial3D.CULL_DISABLED
	stick(p + Vector3(-2.0, 0, 2.0), p + Vector3(-2.0, 2.2, 2.0), 0.04, _rust)
	stick(p + Vector3(2.0, 0, 2.0), p + Vector3(2.0, 2.0, 2.0), 0.04, _rust)
	var q := quad(Vector2(4.6, 3.2), p + Vector3(0, 1.9, 0.6), 0.0, tarp)
	q.rotation.x = -1.3
	box(Vector3(1.8, 0.18, 0.9), p + Vector3(-0.8, 0.09, -0.6), mat(Color(0.5, 0.46, 0.42), 1.0))
	box(Vector3(1.8, 0.18, 0.9), p + Vector3(1.4, 0.09, -0.2), mat(Color(0.42, 0.4, 0.45), 1.0))
	cyl(0.35, 0.35, 0.9, p + Vector3(0, 0.45, 2.8), mat(Color(0.18, 0.1, 0.07), 0.6, 0.5), 12)
	floor_quad(Vector2(2.0, 2.0), p + Vector3(0, 0.015, 2.8), 0.0, decal_mat(Tex.blob(), Color(0.03, 0.03, 0.03, 0.8), 1.0))
	for k in 5:
		var b := box(Vector3(0.4, 0.3, 0.3) * rng.randf_range(0.6, 1.4), p + Vector3(rng.randf_range(-3.0, 3.0), 0.15, rng.randf_range(-2.0, 3.5)), mat(Color(0.3, 0.25, 0.18), 0.9))
		b.rotation.y = rng.randf() * TAU
	var o := light(p + Vector3(0, 2.6, 0), Color(1.0, 0.6, 0.35), 0.7, 7.0)
	flickers.append(o)


# ------------------------------------------------------------------ guards and vagrants (hooks)

## Cult members on watch: tall, black coats, full face coverings, "not a
## surgical mask, something ceremonial" (Tyson, ch. 2). One at the factory
## side door, two at the edges of the camp under the overpass. They do
## nothing yet but turn to keep Carl in view when the frames are on.
func _guards() -> void:
	# the factory door, the plant gate (sighted, in frames), two on patrol in
	# the yard between the drills
	var spots := [[Vector3(44.2, 0.02, -11.4), 0.0, "the factory door", false], [Vector3(59.0, 0.02, 15.6), 0.0, "the gate", true],
		[Vector3(53.0, 0.02, 22.0), -PI / 2.0, "the yard", false], [Vector3(46.5, 0.02, 16.0), PI, "the yard", false]]
	for i in spots.size():
		var g := figure(Color(0.03, 0.03, 0.035), Color(0.6, 0.6, 0.6), {"hair": Color(0.02, 0.02, 0.02), "arms": true, "knees": true, "long_coat": true, "visor": spots[i][3]})
		(g.get_meta("body") as Node3D).scale = Vector3(1.0, 1.18, 1.0)
		(g.get_meta("body") as Node3D).position.y = -0.18
		g.scale = Vector3.ONE * 1.1
		var hd: Node3D = g.get_meta("head")
		box(Vector3(0.22, 0.28, 0.04), Vector3(0, 0.0, -0.12), mat(Color(0.88, 0.86, 0.8), 0.3), false, hd)
		cyl(0.0, 0.17, 0.35, Vector3(0, 0.2, 0.02), mat(Color(0.03, 0.03, 0.035)), 8, hd)
		var sp := Sprite3D.new()
		sp.texture = _glyph_tex
		sp.pixel_size = 0.0014
		sp.modulate = Color(0.1, 0.02, 0.02)
		sp.position = Vector3(0, 0.02, -0.142)
		sp.rotation.y = PI
		hd.add_child(sp)
		g.position = spots[i][0]
		g.rotation.y = spots[i][1]
		g.set_meta("guard", true)
		g.set_meta("home_yaw", spots[i][1])
		add_child(g)
		for a in g.get_meta("arms"):
			(a as Node3D).rotation.x = -0.15
		var body := person("guard%d" % i, "Look at the figure by %s" % spots[i][2], g,
			"UNKNOWN\nface: COVERED\ndevices: %s\nsync: ???  -  DREAMING" % ("ORA (UNISSUED)" if spots[i][3] else "NONE"))
		body.set_meta("guard", true)
		guards.append(g)
	patrols = [{"node": guards[2], "a": Vector3(53.0, 0.02, 22.0), "b": Vector3(65.0, 0.02, 22.0), "t": 0.0, "dir": 1.0, "speed": 0.12},
		{"node": guards[3], "a": Vector3(46.5, 0.02, 16.0), "b": Vector3(46.5, 0.02, 23.5), "t": 0.5, "dir": 1.0, "speed": 0.18}]

## The people the city left in the lanes: crouched, seated, turned away.
func _vagrants() -> void:
	var spots := [[Vector3(-5.0, 0, -44.5), 0.4], [Vector3(72.9, 0, -36.5), -PI / 2.0], [Vector3(41.0, 0, 30.0), PI / 2.0],
		[Vector3(58.0, 0, 52.0), PI], [Vector3(114.0, 0, 31.5), 0.3], [Vector3(96.0, 0, -45.0), PI + 0.5]]
	var coats := [Color(0.32, 0.28, 0.24), Color(0.22, 0.24, 0.26), Color(0.4, 0.22, 0.16), Color(0.26, 0.3, 0.26)]
	var skins := [Color(0.8, 0.62, 0.5), Color(0.55, 0.4, 0.3), Color(0.42, 0.3, 0.22), Color(0.88, 0.74, 0.62)]
	for i in spots.size():
		var f := figure(coats[i % coats.size()], skins[(i + 2) % skins.size()], {"arms": true, "knees": true, "hair": Color(0.25, 0.2, 0.16)})
		var crouched := i % 2 == 0
		f.position = (spots[i][0] as Vector3) + Vector3(0, -0.45 if crouched else -0.41, 0)
		f.rotation.y = spots[i][1]
		f.set_meta("vagrant", true)
		add_child(f)
		if crouched:
			Anim.crouch(f)
			for a in f.get_meta("arms"):
				(a as Node3D).rotation.x = -1.3
		else:
			Anim.sit(f, 0.3)
			box(Vector3(0.5, 0.42, 0.5), (spots[i][0] as Vector3) + Vector3(0, 0.2, 0) + Basis(Vector3.UP, spots[i][1]) * Vector3(0, 0, 0.12), mat(Color(0.3, 0.25, 0.18), 0.9), false)
		var body := person("vagrant%d" % i, "Look at the man in the lane", f, "UNREGISTERED\ndevices: NONE\nsync: --\nhousing: REVOKED")
		body.set_meta("vagrant", true)
		vagrants.append(f)

# ------------------------------------------------------------------ textures Psyon and ORA draw

## The archive footage: a construction site in harsh midday light, a pit,
## men round it, a man on the ground with no eyes. Early-gen ORA: grainy,
## torn, a bar of static across the bottom.
func _footage() -> ImageTexture:
	if _mat_cache.has("footage"):
		return _mat_cache["footage"]
	var w := 320
	var h := 200
	var r := RandomNumberGenerator.new()
	r.seed = 2026
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	for y in h:
		for x in w:
			var c: Color
			if y < 70:
				c = Color(0.9, 0.86, 0.78).lerp(Color(0.98, 0.95, 0.9), float(y) / 70.0)
				if Vector2(x - 250, y - 20).length() < 14.0:
					c = Color(1, 1, 0.95)
			else:
				var k := r.randf_range(-0.05, 0.05)
				c = Color(0.62 + k, 0.5 + k, 0.36 + k).lerp(Color(0.5, 0.4, 0.3), (y - 70.0) / 130.0 * 0.4)
			img.set_pixel(x, y, c)
	# the pit, left of centre, a dark trapezoid with a lip of pale spoil
	for y in range(95, 150):
		var hw := 40 + (y - 95) * 1.1
		for x in range(int(110 - hw), int(110 + hw)):
			if x >= 0 and x < w:
				var d := (y - 95.0) / 55.0
				img.set_pixel(x, y, Color(0.12, 0.09, 0.07).lerp(Color(0.02, 0.02, 0.02), d))
	for x in range(60, 170):
		for y in range(90, 96):
			img.set_pixel(x, y, Color(0.75, 0.66, 0.5))
	# men round it: dark blocks with hard-hat dots, arms thrown up
	var men := [[40, 75, 1.1], [75, 70, 1.0], [160, 72, 1.0], [195, 80, 1.2], [230, 95, 1.3]]
	for m: Array in men:
		var mx: int = m[0]
		var my: int = m[1]
		var s: float = m[2]
		_rect(img, mx - 6 * s, my, 12 * s, 34 * s, Color(0.2, 0.18, 0.2))
		_rect(img, mx - 4 * s, my - 10 * s, 8 * s, 10 * s, Color(0.7, 0.55, 0.42))
		_rect(img, mx - 5 * s, my - 12 * s, 10 * s, 4 * s, Color(0.95, 0.8, 0.2))
		_line(img, mx - 6 * s, my + 4 * s, mx - 14 * s, my - 12 * s, Color(0.2, 0.18, 0.2), 3)
		_line(img, mx + 6 * s, my + 4 * s, mx + 14 * s, my - 10 * s, Color(0.2, 0.18, 0.2), 3)
	# the man on the ground, bottom right, flipped onto his back, face to the lens
	_rect(img, 190, 150, 90, 22, Color(0.55, 0.52, 0.5))
	_rect(img, 270, 140, 34, 36, Color(0.72, 0.56, 0.44))
	_rect(img, 268, 136, 38, 8, Color(0.9, 0.75, 0.2))
	for p: Vector2 in [Vector2(279, 152), Vector2(295, 152)]:
		for y in range(-5, 6):
			for x in range(-5, 6):
				if Vector2(x, y).length() < 5.0:
					img.set_pixel(int(p.x) + x, int(p.y) + y, Color(0.02, 0.0, 0.0))
		for y in range(5, 14):
			img.set_pixel(int(p.x) + 1, int(p.y) + y, Color(0.25, 0.02, 0.02))
	_rect(img, 282, 164, 10, 2, Color(0.4, 0.2, 0.18))
	# grain, scanlines, a torn band, a timestamp block
	for y in h:
		var tear := 0
		if y > 176:
			tear = r.randi_range(-30, 30)
		for x in w:
			var c := img.get_pixel(x, y)
			var g := r.randf_range(-0.08, 0.08)
			c = Color(c.r + g, c.g + g, c.b + g)
			if y % 2 == 0:
				c = c.darkened(0.12)
			if tear != 0:
				var sx := clampi(x + tear, 0, w - 1)
				c = img.get_pixel(sx, y).lerp(Color(0.5, 0.5, 0.5), 0.3)
				if r.randf() < 0.3:
					c = Color(r.randf(), r.randf(), r.randf()) * 0.6
			var v := Vector2(x - w / 2.0, y - h / 2.0).length() / (w / 2.0)
			c = c.darkened(clampf((v - 0.7) * 0.9, 0.0, 0.6))
			img.set_pixel(x, y, c)
	_rect(img, 10, 10, 8, 8, Color(1.0, 0.1, 0.1))
	_rect(img, 24, 11, 42, 6, Color(0.95, 0.95, 0.95))
	img.generate_mipmaps()
	var t := ImageTexture.create_from_image(img)
	_mat_cache["footage"] = t
	return t


## Psyon's map: Silico to scale in razor-sharp monochrome, every block, every
## service grid, the tunnels underneath, all labelled in an angular script.
## And one crimson eye, far out in the desert.
func _map() -> ImageTexture:
	if _mat_cache.has("map"):
		return _mat_cache["map"]
	var w := 640
	var h := 400
	var r := RandomNumberGenerator.new()
	r.seed = 1111
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	img.fill(Color(0.05, 0.06, 0.065))
	var ink := Color(0.82, 0.86, 0.86)
	var dim := Color(0.4, 0.44, 0.45)
	# the city: a grid of blocks in the left two thirds, denser in the middle,
	# the Spine down the centre, the tower's ring on it
	var cx := 200.0
	var cy := 200.0
	for by in range(20, 380, 24):
		for bx in range(20, 400, 26):
			var d := Vector2(bx - cx, by - cy).length() / 220.0
			if d > 1.0 and r.randf() < 0.8:
				continue
			var bw := r.randi_range(10, 20)
			var bh := r.randi_range(8, 18)
			var c := ink if d < 0.7 else dim
			_rect_outline(img, bx + r.randi_range(0, 4), by + r.randi_range(0, 4), bw, bh, c)
			if r.randf() < 0.35:
				_script(img, r, bx + 2, by + bh + 6, c)
	# the service grids: faint straight lines across everything
	for k in range(0, 400, 50):
		_line(img, 10, k + 10, 420, k + 10, Color(0.2, 0.22, 0.23), 1)
		_line(img, k + 10, 10, k + 10, 390, Color(0.2, 0.22, 0.23), 1)
	# the Spine and the tower
	_line(img, cx, 20, cx, 380, ink, 3)
	_circle(img, cx, cy, 22, ink, 2)
	_circle(img, cx, cy, 8, ink, 2)
	# the tunnels: dashed, curving, deeper than the grid, running out east
	for t in 6:
		var p := Vector2(cx + r.randf_range(-60, 60), cy + r.randf_range(-100, 100))
		var ang := r.randf_range(-0.6, 0.6)
		for s in 60:
			var q := p + Vector2(cos(ang), sin(ang)) * 7.0
			if s % 2 == 0:
				_line(img, p.x, p.y, q.x, q.y, dim, 1)
			p = q
			ang += r.randf_range(-0.25, 0.25)
			if p.x > 620 or p.y < 5 or p.y > 395:
				break
	# the desert: a scatter of grains, dunes as faint arcs, the edge of the city
	_line(img, 430, 10, 430, 390, dim, 1)
	for k in 1200:
		img.set_pixel(r.randi_range(432, 638), r.randi_range(2, 397), Color(0.14, 0.15, 0.15))
	for k in 7:
		var ax := r.randf_range(450, 620)
		var ay := r.randf_range(30, 370)
		for s in 40:
			var px := int(ax + s * 1.4)
			var py := int(ay + sin(s * 0.16) * 6.0)
			if px < w and py < h:
				img.set_pixel(px, py, Color(0.22, 0.23, 0.23))
	# the eye, crimson, deep in the desert
	var ex := 556.0
	var ey := 292.0
	var red := Color(0.85, 0.08, 0.06)
	for y in range(-22, 23):
		for x in range(-40, 41):
			var u := x / 40.0
			var lid := 20.0 * (1.0 - u * u)
			if absf(absf(float(y)) - lid) < 2.2 and absf(u) <= 1.0:
				img.set_pixel(int(ex) + x, int(ey) + y, red)
	_circle(img, ex, ey, 11, red, 2)
	_circle(img, ex, ey, 6, red, 2)
	for y in range(-2, 3):
		for x in range(-2, 3):
			img.set_pixel(int(ex) + x, int(ey) + y, red)
	_script(img, r, int(ex) - 30, int(ey) + 32, red)
	# a grid reference down the margin, in the same script
	for k in 8:
		_script(img, r, 6, 14 + k * 48, dim)
	img.generate_mipmaps()
	var t := ImageTexture.create_from_image(img)
	_mat_cache["map"] = t
	return t


## The painted eye: an almond outline round the two rings, stroke like a
## roller, spray grain, drips. White, tinted by its material.
func _eye_paint() -> ImageTexture:
	if _mat_cache.has("eyepaint"):
		return _mat_cache["eyepaint"]
	var w := 320
	var h := 200
	var r := RandomNumberGenerator.new()
	r.seed = 77
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	img.fill(Color(1, 1, 1, 0))
	for y in h:
		for x in w:
			var u := (x - 160.0) / 140.0
			var v := y - 100.0
			var a := 0.0
			if absf(u) <= 1.0:
				var lid := 70.0 * (1.0 - u * u)
				var e := absf(absf(v) - lid)
				if e < 7.0:
					a = 1.0
				elif e < 10.0:
					a = (10.0 - e) / 3.0
			if a > 0.0:
				a *= r.randf_range(0.7, 1.0)
				img.set_pixel(x, y, Color(1, 1, 1, a))
	for k in 14:
		var dx := r.randi_range(60, 260)
		var y0 := 100 + int(70.0 * (1.0 - pow((dx - 160.0) / 140.0, 2.0))) + 2
		for y in range(y0, mini(h - 1, y0 + r.randi_range(8, 40))):
			img.set_pixel(dx, y, Color(1, 1, 1, 0.85))
			if y - y0 < 4:
				img.set_pixel(dx + 1, y, Color(1, 1, 1, 0.7))
	img.generate_mipmaps()
	var t := ImageTexture.create_from_image(img)
	_mat_cache["eyepaint"] = t
	return t


func _rect(img: Image, x: float, y: float, w: float, h: float, c: Color) -> void:
	for yy in range(int(y), int(y + h)):
		for xx in range(int(x), int(x + w)):
			if xx >= 0 and yy >= 0 and xx < img.get_width() and yy < img.get_height():
				img.set_pixel(xx, yy, c)


func _rect_outline(img: Image, x: int, y: int, w: int, h: int, c: Color) -> void:
	_line(img, x, y, x + w, y, c, 1)
	_line(img, x, y + h, x + w, y + h, c, 1)
	_line(img, x, y, x, y + h, c, 1)
	_line(img, x + w, y, x + w, y + h, c, 1)


func _line(img: Image, x0: float, y0: float, x1: float, y1: float, c: Color, wd: int) -> void:
	var n := int(maxf(absf(x1 - x0), absf(y1 - y0))) + 1
	for i in n + 1:
		var t := float(i) / n
		var px := int(lerpf(x0, x1, t))
		var py := int(lerpf(y0, y1, t))
		for dy in wd:
			for dx in wd:
				var xx := px + dx - wd / 2
				var yy := py + dy - wd / 2
				if xx >= 0 and yy >= 0 and xx < img.get_width() and yy < img.get_height():
					img.set_pixel(xx, yy, c)


func _circle(img: Image, cx: float, cy: float, rad: float, c: Color, wd: float) -> void:
	for y in range(int(cy - rad - 2), int(cy + rad + 3)):
		for x in range(int(cx - rad - 2), int(cx + rad + 3)):
			if x >= 0 and y >= 0 and x < img.get_width() and y < img.get_height():
				if absf(Vector2(x - cx, y - cy).length() - rad) < wd * 0.6:
					img.set_pixel(x, y, c)


## A word of the angular script nobody can read: a few joined strokes.
func _script(img: Image, r: RandomNumberGenerator, x: int, y: int, c: Color) -> void:
	var px := float(x)
	for k in r.randi_range(3, 7):
		var dx := r.randf_range(2.0, 6.0)
		var dy := r.randf_range(-5.0, 5.0)
		_line(img, px, y, px + dx, y + dy, c, 1)
		if r.randf() < 0.5:
			_line(img, px + dx, y + dy, px + dx, y, c, 1)
		px += dx + 1.0


# ------------------------------------------------------------------ the chapter

func objective() -> String:
	var f: Dictionary = main.flags
	if f.has("southtown_done"):
		return LINES["objective"]["done"]
	if not f.has("lynx_met"):
		return LINES["objective"]["lynx"]
	if f.has("plant_entered"):
		return LINES["objective"]["church"]
	if f.has("factory_keycard") and not f.has("factory_unlocked"):
		return LINES["objective"]["keycard"]
	if f.has("informant_help"):
		return LINES["objective"]["side_door"]
	return LINES["objective"]["plant"]

func intro() -> void:
	var ui = main.ui
	await get_tree().create_timer(0.6).timeout
	await ui.think(LINES["intro"]["think"])
	await ui.think(LINES["intro"]["think_2"])
	await ui.think(LINES["intro"]["think_3"])
	ui.close()
	_cough_t = 25.0


func tick(delta: float) -> void:
	if not main or not main.player:
		return
	var pp: Vector3 = main.player.global_position
	_tick_lynx(delta, pp)
	# commuters: back and forth across the forecourt, never looking at Carl
	for c in commuters:
		var n: Node3D = c.node
		c.t += c.speed * delta * c.dir
		if c.t > 1.0 or c.t < 0.0:
			c.dir *= -1.0
			c.t = clampf(c.t, 0.0, 1.0)
		var from: Vector3 = c.a if c.dir > 0.0 else c.b
		var to: Vector3 = c.b if c.dir > 0.0 else c.a
		var k: float = c.t if c.dir > 0.0 else 1.0 - c.t
		n.position = from.lerp(to, k) + Vector3(0, 0.02, 0)
		var d := to - from
		n.rotation.y = atan2(-d.x, -d.z)
		Anim.walk(n, _t, 1.25, float(n.get_instance_id() % 7), 1.0)
		var away := n.global_position + (n.global_position - pp) + Vector3(0, 1.4, 0)
		Anim.look(n, away, 0.8 if pp.distance_to(n.global_position) < 7.0 else 0.0, 0.05)
	# the guards: still, until the frames are on; then every one of them
	# turns to keep Carl in view, and keeps turning
	for g in guards:
		var n: Node3D = g
		var near := pp.distance_to(n.global_position) < 34.0
		if main.frames_on and near:
			var d := pp - n.global_position
			n.rotation.y = lerp_angle(n.rotation.y, atan2(-d.x, -d.z), minf(1.0, delta * 1.5))
			Anim.look(n, pp + Vector3(0, 1.6, 0), 1.0, 0.06)
		else:
			n.rotation.y = lerp_angle(n.rotation.y, float(n.get_meta("home_yaw")), minf(1.0, delta * 0.8))
			Anim.look(n, pp + Vector3(0, 1.6, 0), 0.0, 0.03)
	for v in vagrants:
		var n: Node3D = v
		if pp.distance_to(n.global_position) < 5.0:
			var away := n.global_position + (n.global_position - pp) + Vector3(0, 1.2, 0)
			Anim.look(n, away, 0.7, 0.04)
	# the yard patrols: between the drills, or on Carl's heels after the badge
	for pt in patrols:
		var n: Node3D = pt.node
		var in_plant := pp.z > 12.5 and pp.x > 44.0 and pp.x < 74.0
		if _guards_tail and in_plant and not main.flags.has("cinematic"):
			var away := (n.global_position - pp)
			away.y = 0.0
			var want := pp + away.normalized() * 3.6
			var d := want - n.position
			d.y = 0.0
			if d.length() > 0.5:
				n.position += d.normalized() * minf(1.5 * delta, d.length())
				n.rotation.y = atan2(-d.x, -d.z)
				Anim.walk(n, _t, 1.0, 1.0, 1.0)
			else:
				Anim.idle(n, _t, 1.0)
				var f2 := pp - n.position
				n.rotation.y = lerp_angle(n.rotation.y, atan2(-f2.x, -f2.z), minf(1.0, delta * 2.0))
			Anim.look(n, pp + Vector3(0, 1.6, 0), 1.0, 0.06)
			continue
		if main.flags.has("plant_entered") and str(main.flags.get("plant_route", "")) == "badge":
			Anim.idle(n, _t, 1.0)
			continue
		pt.t += pt.speed * delta * pt.dir
		if pt.t > 1.0 or pt.t < 0.0:
			pt.dir *= -1.0
			pt.t = clampf(pt.t, 0.0, 1.0)
		var from: Vector3 = pt.a
		var to: Vector3 = pt.b
		var np: Vector3 = from.lerp(to, pt.t)
		var dd: Vector3 = (to - from) * pt.dir
		n.position = np
		n.rotation.y = lerp_angle(n.rotation.y, atan2(-dd.x, -dd.z), minf(1.0, delta * 3.0))
		Anim.walk(n, _t, 0.9, float(n.get_instance_id() % 5), 1.0)
	# the congregation turn their heads when the frames are on; the priest's
	# face will not hold still, and once in a while it is Carl's
	for c in congregation:
		Anim.look(c, pp + Vector3(0, 1.6, 0), 1.0 if main.frames_on and pp.distance_to(c.global_position) < 22.0 else 0.0, 0.03)
	if priest_head and priest_faces.size() > 0:
		if _carl_frame:
			priest_head.material_override = priest_faces[_face_i]
			_carl_frame = false
		else:
			_face_t -= delta
			if _face_t <= 0.0:
				_face_i = (_face_i + 1) % priest_faces.size()
				_face_t = rng.randf_range(0.35, 1.1)
				_face_n += 1
				if _face_n % 7 == 0:
					priest_head.material_override = carl_face
					_carl_frame = true
					if main.frames_on and pp.distance_to(priest.global_position) < 16.0 and not main.flags.has("priest_face_seen"):
						main.flags["priest_face_seen"] = true
						main.ui.show_toast(LINES["church"]["priest_toast"], 3.5)
						main.player.shake(0.2)
				else:
					priest_head.material_override = priest_faces[_face_i]
		Anim.idle(priest, _t, 0.5)
		if main.flags.has("sermon_heard") or main.flags.has("cinematic"):
			Anim.look(priest, pp + Vector3(0, 1.6, 0), 0.6 if pp.distance_to(priest.global_position) < 14.0 else 0.0, 0.04)
	# the eye layer under the overpass: the footprints only the frames can see
	if footprints.size() > 0 and _prints_on != main.frames_on:
		_prints_on = main.frames_on
		for s in footprints:
			(s as Node3D).visible = _prints_on
	# Lynx rejoins when Carl comes back out of the plant by the badge route
	if lynx_state == "stand" and lynx_target == LYNX_FENCE and pp.z < 12.0 and main.flags.has("plant_entered"):
		lynx_state = "follow"
	if worker:
		Anim.idle(worker, _t, 2.0)
		(worker.get_meta("head") as Node3D).rotation.x = 0.55
	# the presses, stamping
	for pr in press_rams:
		var ram: MeshInstance3D = pr[0]
		var ph := fmod(_t * 1.5 + pr[2], TAU)
		ram.position.y = pr[1] - (0.9 if ph < 0.35 else 0.0) * (1.0 - ph / 0.35) - clampf((ph - 0.35) * 0.5, 0.0, 0.9) * (1.0 if ph < 2.1 else 0.0)
	# hover trucks up and down the street
	for tr in trucks:
		var n: Node3D = tr[0]
		n.position.x += tr[1] * tr[2] * delta
		if n.position.x > 200.0:
			n.position.x = -70.0
		elif n.position.x < -70.0:
			n.position.x = 200.0
		n.position.y += sin(_t * 1.3 + n.position.x * 0.05) * delta * 0.3
	# the tarps under the overpass, flapping listlessly
	for n in no_batch:
		if n is MeshInstance3D and n.has_meta("flap"):
			(n as MeshInstance3D).rotation.z = 0.3 + sin(_t * 2.1 + float(n.get_meta("flap"))) * 0.12
	# the itch in the throat. A frog. A cough. A signal.
	_cough_t -= delta
	if _cough_t <= 0.0 and not main.flags.has("cinematic"):
		_cough_t = rng.randf_range(50.0, 80.0)
		main.player.shake(0.12)
		main.ui.show_toast(LINES["ambient"]["toast"], 3.5)


func _tick_lynx(delta: float, pp: Vector3) -> void:
	if not lynx:
		return
	match lynx_state:
		"wait":
			Anim.look(lynx, pp + Vector3(0, 1.6, 0), 0.9 if pp.distance_to(lynx.global_position) < 10.0 else 0.0, 0.05)
			var body: Node3D = lynx.get_meta("body")
			body.position.y = sin(_t * 1.4) * 0.006
		"follow":
			var p = main.player
			var inside := pp.z < -FRONT - 0.5
			var target: Vector3
			if inside:
				target = FACTORY_DOOR + Vector3(-1.4, 0, 0)
			else:
				target = pp + Basis(Vector3.UP, p.yaw) * Vector3(-1.3, 0, -0.7)
				if pp.x > 107.0 and pp.x < 129.0 and absf(pp.z) < 3.0:
					target.z = clampf(target.z, -1.4, 1.4)
				elif absf(pp.z) < FRONT and pp.x < 128.0:
					target.z = clampf(target.z, -FRONT + 0.6, FRONT - 0.6)
				elif pp.x >= 128.0 and pp.x < 156.0:
					target.z = clampf(target.z, -40.0, 40.0)
				elif pp.x > 44.0 and pp.x < 74.0 and pp.z > FRONT:
					target.x = clampf(target.x, 45.0, 73.0)
					target.z = clampf(target.z, FRONT + 0.8, 46.0)
			target.y = 0.02
			var d := target - lynx.position
			d.y = 0.0
			var dist := d.length()
			if dist > 0.45:
				var speed := clampf(dist * 2.2, 1.2, 5.2)
				lynx.position += d.normalized() * minf(speed * delta, dist)
				lynx.rotation.y = lerp_angle(lynx.rotation.y, atan2(-d.x, -d.z), minf(1.0, delta * 8.0))
				Anim.walk(lynx, _t, 1.1 * speed / 2.6, 0.0, 1.0)
				_lynx_moving = true
			else:
				if _lynx_moving:
					_lynx_moving = false
				Anim.idle(lynx, _t, 1.0)
				lynx.rotation.y = lerp_angle(lynx.rotation.y, p.yaw, minf(1.0, delta * 2.0))
				Anim.look(lynx, pp + Vector3(0, 1.6, 0), 0.5, 0.04)
		"stand":
			var d := lynx_target - lynx.position
			d.y = 0.0
			if d.length() > 0.3:
				lynx.position += d.normalized() * minf(3.0 * delta, d.length())
				lynx.rotation.y = lerp_angle(lynx.rotation.y, atan2(-d.x, -d.z), minf(1.0, delta * 8.0))
				Anim.walk(lynx, _t, 1.1, 0.0, 1.0)
			else:
				Anim.idle(lynx, _t, 1.0)
				Anim.look(lynx, pp + Vector3(0, 1.6, 0), 0.9, 0.05)


func interact(node: Object) -> bool:
	var ui = main.ui
	var f: Dictionary = main.flags
	match str(node.get_meta("id")):
		"lynx":
			await _lynx()
		"station":
			await ui.think(LINES["examine"]["station_think"])
		"kiosk":
			await ui.think(LINES["examine"]["kiosk_think"])
		"train":
			await ui.think(LINES["examine"]["train_think"])
		"drone_pole":
			await ui.think(LINES["examine"]["drone_pole_think"])
		"my_car":
			if f.has("southtown_done"):
				await ui.think(LINES["examine"]["my_car_think"])
				await _leave()
			elif f.has("lynx_met"):
				await ui.think(LINES["examine"]["my_car_think_2"])
			else:
				await ui.think(LINES["examine"]["my_car_think_3"])
		"factory":
			await ui.think(LINES["examine"]["factory_think"])
		"factory_door":
			await _factory_door()
		"machines":
			await ui.think(LINES["examine"]["machines_think"])
			await ui.think(LINES["examine"]["machines_think_2"])
			if not f.has("blanks_seen"):
				f["blanks_seen"] = true
				main.add_connection(2.0, "the blanks")
		"worker":
			await ui.think(LINES["examine"]["worker_think"])
			await ui.say("Worker", LINES["examine"]["worker_worker"])
		"office_laptop":
			await _office_laptop()
		"keycard":
			if f.has("factory_keycard"):
				await ui.think(LINES["examine"]["keycard_think"])
			else:
				await ui.think(LINES["examine"]["keycard_think_2"])
				f["factory_keycard"] = true
				main.play("tap", -8.0)
				for n in main._all_with_meta(self, "card"):
					(n as Node3D).visible = false
				ui.show_toast(LINES["examine"]["keycard_toast"], 2.5)
				main.update_hud()
		"ledger":
			await ui.think(LINES["examine"]["ledger_think"])
			if not f.has("ledger_seen"):
				f["ledger_seen"] = true
				main.add_connection(2.0, "the ledger")
		"locked_door":
			await _locked_door()
		"floor_eye":
			await _floor_eye()
		"shanty":
			await ui.think(LINES["shanty"]["think"])
			await ui.think(LINES["shanty"]["think_2"])
		"vag_informant":
			await _informant()
		"vag_attacker":
			await _attacker()
		"vag_convert":
			await _convert()
		"plant_gate":
			await _gate()
		"gate_reader":
			await ui.think(LINES["examine"]["gate_reader_think"])
		"gate_cam":
			await ui.think(LINES["examine"]["gate_cam_think"] if not f.has("cam_hacked") else LINES["examine"]["gate_cam_off"])
		"gate_speaker":
			await ui.think(LINES["examine"]["gate_speaker_think"])
		"drill50", "drill68":
			await ui.think(LINES["examine"]["drill_think"])
		"drill_housing":
			await _drill_housing()
		"congregation":
			await ui.think(LINES["church"]["congregation_think"])
		"priest":
			await ui.think(LINES["church"]["priest_think"])
			if not f.has("priest_face_seen"):
				f["priest_face_seen"] = true
				ui.show_toast(LINES["church"]["priest_toast"], 3.5)
		"wire_eye":
			await _wire_eye()
		"drill_pit":
			await ui.think(LINES["examine"]["drill_pit_think"])
		"hatch":
			await _hatch()
		"side_door":
			await _side_door()
		"verse":
			await _verse()
		"footprints":
			await _footprints()
		"chant_wall":
			await _chant_wall()
		"tunnel_mouth":
			await ui.think(LINES["overpass"]["tunnel_think"])
			await ui.think(LINES["overpass"]["tunnel_think_2"])
		"tunelet":
			await ui.think(LINES["examine"]["tunelet_think"])
			await ui.think(LINES["examine"]["tunelet_think_2"])
		"van":
			await ui.think(LINES["examine"]["van_think"])
		"substation":
			await ui.think(LINES["examine"]["substation_think"])
		"bin":
			await ui.think(LINES["examine"]["bin_think"])
		"ad":
			await ui.think(LINES["examine"]["ad_think"])
		"camp":
			await ui.think(LINES["examine"]["camp_think"])
		"barrels":
			await ui.think(LINES["examine"]["barrels_think"])
		"limit":
			await ui.think(LINES["examine"]["limit_think"])
		"overpass_eye":
			await _overpass_scene()
		"guard0", "guard1", "guard2", "guard3":
			await ui.think(LINES["examine"]["guard0_think"])
			if main.frames_on:
				await ui.say("", LINES["examine"]["guard0_narr"])
		"vagrant0", "vagrant1", "vagrant2", "vagrant3", "vagrant4", "vagrant5":
			await ui.think(LINES["examine"]["vagrant0_think"])
		"reader":
			await ui.think(LINES["examine"]["reader_think"])
		"cam":
			await ui.think(LINES["examine"]["cam_think"])
		_:
			return false
	return true


# ------------------------------------------------------------------ Lynx at the station

func _lynx() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	if f.has("southtown_done"):
		await ui.say("Lynx", LINES["lynx_station"]["lynx"])
		return
	if f.has("lynx_met"):
		await ui.say("Lynx", LINES["lynx_station"]["lynx_2"])
		return
	turn_to(lynx, p.global_position, 0.5)
	await ui.say("Lynx", LINES["lynx_station"]["lynx_3"])
	await ui.think(LINES["lynx_station"]["think"])
	await ui.think(LINES["lynx_station"]["think_2"])
	await ui.say("Lynx", LINES["lynx_station"]["lynx_4"])
	await ui.say("Lynx", LINES["lynx_station"]["lynx_5"])
	await ui.say("Carl", LINES["lynx_station"]["carl"])
	await ui.say("Lynx", LINES["lynx_station"]["lynx_6"])
	var pick: int = await ui.choose(LINES["lynx_station"]["choice"])
	if pick == 0:
		await ui.say("Carl", LINES["lynx_station"]["carl_2"])
		await ui.think(LINES["lynx_station"]["think_3"])
		f["lynx_trust"] = true
		main.add_trust("lynx", 1)
	else:
		await ui.say("Carl", LINES["lynx_station"]["carl_3"])
		await ui.say("Lynx", LINES["lynx_station"]["lynx_7"])
		main.add_stance("sleeper")
	await ui.say("Carl", LINES["lynx_station"]["carl_4"])
	await ui.say("Lynx", LINES["lynx_station"]["lynx_8"])
	ui.close()
	_lynx_lean(false)
	lynx_state = "follow"
	await get_tree().create_timer(0.8).timeout
	await ui.think(LINES["lynx_station"]["think_4"])
	await ui.say("Lynx", LINES["lynx_station"]["lynx_9"])
	await ui.say("Lynx", LINES["lynx_station"]["lynx_10"])
	await ui.say("Carl", LINES["lynx_station"]["carl_5"])
	await ui.think(LINES["lynx_station"]["think_5"])
	await ui.say("Lynx", LINES["lynx_station"]["lynx_11"])
	ui.close()
	main.play("ding", -6.0)
	await get_tree().create_timer(0.6).timeout
	main.ui.show_picture(_footage(), LINES["ui"]["footage_caption"])
	main.play("static", -14.0)
	await ui.think(LINES["lynx_station"]["think_6"])
	await ui.think(LINES["lynx_station"]["think_7"])
	ui.glitch(0.6, 0.6)
	await ui.think(LINES["lynx_station"]["think_8"])
	main.ui.hide_picture()
	await ui.think(LINES["lynx_station"]["think_9"])
	await ui.say("Carl", LINES["lynx_station"]["carl_6"])
	await ui.say("Lynx", LINES["lynx_station"]["lynx_12"])
	ui.close()
	f["lynx_met"] = true
	f["ev_construction_video"] = true
	main.log_line("evidence", LINES["lynx_station"]["video_log"])
	main.add_connection(2.0, "the old footage")
	main.update_hud()


# ------------------------------------------------------------------ Site 1: the shanty town

func _informant() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	turn_to(vag_informant, main.player.global_position, 0.4)
	if f.has("informant_help"):
		await ui.say("Informant", LINES["shanty"]["informant_help"])
		return
	await ui.think(LINES["shanty"]["informant_think"])
	await ui.say("Informant", LINES["shanty"]["informant"])
	if int(main.trust.get("tyson", 0)) >= 1:
		await ui.say("Informant", LINES["shanty"]["informant_trusts"])
		await ui.say("Informant", LINES["shanty"]["informant_2"])
		_informant_helps()
		return
	var pick: int = await ui.choose(LINES["shanty"]["choice"])
	if pick == 0:
		await ui.say("Carl", LINES["shanty"]["carl_kind"])
		await ui.say("Informant", LINES["shanty"]["informant_2"])
		_informant_helps()
	else:
		await ui.say("Carl", LINES["shanty"]["carl_blunt"])
		await ui.say("Informant", LINES["shanty"]["informant_3"])
	ui.close()


func _informant_helps() -> void:
	var f: Dictionary = main.flags
	f["informant_help"] = true
	main.ui.show_toast(LINES["shanty"]["toast"], 3.0)
	main.log_line("lead", LINES["shanty"]["log"])
	main.update_hud()


func _attacker() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	if f.has("attacker_down"):
		await ui.think(LINES["shanty"]["attacker_after"])
		return
	if not main.frames_on:
		await ui.think(LINES["shanty"]["attacker_off"])
		return
	f["cinematic"] = true
	await ui.think(LINES["shanty"]["attacker_think"])
	turn_to(vag_attacker, p.global_position, 0.3)
	main.play("sting", -8.0, 1.1)
	p.shake(0.2)
	await ui.say("Man", LINES["shanty"]["attacker"])
	if lynx_state == "follow":
		await ui.say("Lynx", LINES["shanty"]["lynx"])
	var pick: int = await ui.choose(LINES["shanty"]["choice_2"])
	var stun := pick == 1
	if pick == 0:
		if "beneath" in main.lexicon:
			await ui.say("Carl", LINES["shanty"]["carl_talk"])
			await ui.think(LINES["shanty"]["attacker_calms"])
		else:
			await ui.say("Carl", LINES["shanty"]["carl_talk_fail"])
			ui.glitch(0.5, 0.5)
			p.shake(0.5)
			await ui.think(LINES["shanty"]["attacker_fails"])
			stun = true
	if stun:
		main.play("snap", -4.0)
		ui.flash(0.9)
		await ui.think(LINES["shanty"]["flash"])
	# down against the wall, hands over the eyes
	vag_attacker.position.y = -0.41
	Anim.sit(vag_attacker, 0.4)
	for a in vag_attacker.get_meta("arms"):
		(a as Node3D).rotation.x = -2.5
	await ui.think(LINES["shanty"]["think_after"])
	ui.close()
	f["attacker_down"] = true
	f.erase("cinematic")
	main.log_line("event", LINES["shanty"]["attacker_log"])
	main.update_hud()


func _convert() -> void:
	var ui = main.ui
	await ui.think(LINES["shanty"]["convert_think"])
	if main.frames_on:
		await ui.say("", LINES["shanty"]["convert_scan"])
	await ui.say("Man", LINES["shanty"]["convert"])
	await ui.think(LINES["shanty"]["convert_think_2"])
	if not main.flags.has("convert_heard"):
		main.flags["convert_heard"] = true
		main.add_connection(1.0, "the first line")


# ------------------------------------------------------------------ Site 2: the Tunelet plant

func _gate() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("plant_entered"):
		await ui.think(LINES["plant_gate"]["done_think"])
		return
	await ui.think(LINES["plant_gate"]["think"])
	if lynx_state == "follow":
		await ui.say("Lynx", LINES["plant_gate"]["lynx"])
	var pick: int = await ui.choose(LINES["plant_gate"]["choice"])
	ui.close()
	match pick:
		0:
			await _route_badge()
		1:
			await _route_hack()
		2:
			await _route_sneak()
		_:
			if not f.has("informant_help"):
				await ui.think(LINES["plant_gate"]["person_none"])
				return
			await _route_person()
	await _entered()


func _open_gate() -> void:
	main.play("door", -6.0, 0.7)
	create_tween().tween_property(plant_gate, "rotation:y", -1.75, 1.2).set_trans(Tween.TRANS_SINE)
	var pg := _node_by_id("plant_gate")
	if pg:
		pg.set_meta("prompt", LINES["plant_gate"]["open"])
	if gate_reader_light:
		gate_reader_light.material_override = glow(Color(0.2, 1.0, 0.3), 3.0)


func _route_badge() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	f["plant_route"] = "badge"
	main.play("tap", -8.0)
	_open_gate()
	await ui.think(LINES["plant_gate"]["badge_think"])
	if lynx_state == "follow":
		await ui.say("Lynx", LINES["plant_gate"]["badge_lynx"])
		lynx_state = "stand"
		lynx_target = LYNX_FENCE
	ui.close()
	main.add_pressure(2.0, "badged into the plant")
	main.log_line("route", LINES["plant_gate"]["badge_log"])
	_guards_tail = true
	await ui.think(LINES["plant_gate"]["badge_think_2"])


func _route_hack() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	f["plant_route"] = "hack"
	main.play("glitch", -6.0)
	ui.glitch(0.5, 0.8)
	if gate_cam_light:
		gate_cam_light.visible = false
	f["cam_hacked"] = true
	_open_gate()
	await ui.think(LINES["plant_gate"]["hack_think"])
	if lynx_state == "follow":
		await ui.say("Lynx", LINES["plant_gate"]["hack_lynx"])
	ui.close()
	main.add_connection(2.0, "the hack at the gate")
	main.log_line("route", LINES["plant_gate"]["hack_log"])


func _route_sneak() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	f["plant_route"] = "sneak"
	f["cinematic"] = true
	await ui.think(LINES["plant_gate"]["sneak_think"])
	ui.close()
	ui.fade_to(1.0, 0.6)
	await get_tree().create_timer(0.7).timeout
	p.global_position = Vector3(66.5, 0.05, 41.5)
	p.yaw = PI / 2.0 + 0.35
	p.pitch = 0.0
	p.rotation.y = p.yaw
	if lynx and lynx_state != "wait":
		lynx.position = Vector3(68.0, 0.02, 43.0)
		lynx_state = "follow"
	_sun_lower(0.5)
	ui.fade_to(0.0, 1.0)
	await get_tree().create_timer(0.8).timeout
	ui.show_toast(LINES["plant_gate"]["sneak_toast"], 3.5)
	main.log_line("time", LINES["plant_gate"]["sneak_log"])
	if lynx_state == "follow":
		await ui.say("Lynx", LINES["plant_gate"]["sneak_lynx"])
	ui.close()
	f.erase("cinematic")


func _route_person() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	f["plant_route"] = "person"
	f["cinematic"] = true
	await ui.think(LINES["plant_gate"]["person_think"])
	ui.close()
	ui.fade_to(1.0, 0.6)
	await get_tree().create_timer(0.7).timeout
	_open_side_door()
	p.global_position = Vector3(45.6, 0.05, 33.7)
	p.yaw = -PI / 2.0 - 0.3
	p.pitch = 0.0
	p.rotation.y = p.yaw
	if lynx and lynx_state != "wait":
		lynx.position = Vector3(42.8, 0.02, 33.7)
		lynx_state = "follow"
	if vag_informant:
		vag_informant.visible = false
	var vi := _node_by_id("vag_informant")
	if vi:
		vi.set_meta("exit", true)
		(vi as CollisionObject3D).collision_layer = 0
	ui.fade_to(0.0, 1.0)
	await get_tree().create_timer(0.8).timeout
	main.log_line("route", LINES["plant_gate"]["person_log"])
	f.erase("cinematic")


func _open_side_door() -> void:
	var f: Dictionary = main.flags
	if f.has("side_door_open"):
		return
	f["side_door_open"] = true
	main.play("door", -6.0, 0.9)
	create_tween().tween_property(side_door, "rotation:y", 1.6, 1.0).set_trans(Tween.TRANS_SINE)
	var sd := _node_by_id("side_door")
	if sd:
		sd.set_meta("prompt", "Go through")


func _side_door() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("side_door_open"):
		await ui.think(LINES["plant_gate"]["side_open"])
		return
	if f.has("informant_help") and not f.has("plant_entered"):
		await _route_person()
		await _entered()
		return
	await ui.think(LINES["plant_gate"]["side_locked"])


func _hatch() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("plant_entered"):
		await ui.think(LINES["plant_gate"]["hatch_after"])
		return
	await ui.think(LINES["plant_gate"]["hatch_think"])
	await _route_sneak()
	await _entered()


## Past the perimeter, by whichever route: the church is in front of him.
func _entered() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("plant_entered"):
		return
	f["plant_entered"] = true
	main.update_hud()
	await get_tree().create_timer(0.6).timeout
	await ui.think(LINES["plant_gate"]["inside_think"])
	if lynx_state == "follow":
		await ui.say("Lynx", LINES["plant_gate"]["inside_lynx"])
	ui.close()


func _drill_housing() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	if f.has("sermon_heard") or f.has("sermon_skipped"):
		await ui.think(LINES["church"]["after_think"])
		return
	await ui.think(LINES["church"]["housing_think"])
	var pick: int = await ui.choose(LINES["church"]["choice"])
	ui.close()
	if pick == 1:
		await ui.think(LINES["church"]["leave_think"])
		f["sermon_skipped"] = true
		main.log_line("event", LINES["church"]["leave_log"])
		return
	f["cinematic"] = true
	var tw := create_tween()
	tw.tween_property(p, "crouch", 0.5, 0.6)
	await tw.finished
	await ui.think(LINES["church"]["stay_think"])
	ui.close()
	_chant = main.loop("chant", -10.0, Vector3.ZERO, 1.0, 30.0, priest)
	if _chant:
		(_chant as AudioStreamPlayer3D).play()
	await p.face(priest.global_position + Vector3(0, 1.6, 0), 1.0)
	await ui.say("Priest", LINES["church"]["priest"])
	await ui.say("Priest", LINES["church"]["priest_2"])
	main.play("sting", -4.0, 0.8)
	p.shake(0.5)
	ui.glitch(0.9, 1.2)
	await ui.say("Priest", LINES["church"]["priest_3"])
	await ui.think(LINES["church"]["think_2"])
	main.play("keys", -12.0, 0.6)
	await ui.think(LINES["church"]["think_3"])
	ui.close()
	if _chant:
		_chant.queue_free()
		_chant = null
	var up := create_tween()
	up.tween_property(p, "crouch", 0.0, 0.6)
	await up.finished
	f["sermon_heard"] = true
	f.erase("cinematic")
	main.add_connection(4.0, "the sermon")
	main.learn("mimic")
	main.log_line("evidence", LINES["church"]["stay_log"])
	_claim()
	main.update_hud()


func _wire_eye() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	if f.has("ev_map"):
		await ui.think(LINES["wire_eye"]["done"])
		return
	if not main.frames_on:
		await ui.think(LINES["wire_eye"]["frames_off"])
		return
	f["cinematic"] = true
	if lynx_state != "wait":
		lynx_state = "stand"
		lynx_target = LYNX_EYE
	await p.face(WIRE_EYE, 1.2)
	main.play("whisper", -8.0, 0.8)
	await ui.think(LINES["wire_eye"]["think"])
	ui.close()
	_hum = main.loop("hum", -8.0, Vector3.ZERO, 1.0, 8.0, p)
	if _hum:
		(_hum as AudioStreamPlayer3D).play()
	p.shake(0.15)
	await get_tree().create_timer(1.0).timeout
	await ui.think(LINES["wire_eye"]["think_2"])
	ui.close()
	var tw := create_tween()
	tw.tween_property(p, "crouch", 0.35, 0.7)
	await tw.finished
	await p.face(p.global_position + Vector3(0, 0.6, -1.0), 0.6)
	main.play("on", -8.0, 0.6)
	ui.laptop_open(true)
	ui.laptop_log.append_text(LINES["wire_eye"]["laptop_log"])
	await ui.think(LINES["wire_eye"]["think_3"])
	ui.close()
	await get_tree().create_timer(1.2).timeout
	main.play("ding", -4.0)
	await ui.laptop_line(LINES["wire_eye"]["psyon"])
	p.shake(0.25)
	ui.glitch(0.5, 0.6)
	await get_tree().create_timer(0.8).timeout
	await ui.laptop_line(LINES["wire_eye"]["psyon_2"])
	main.play("keys", -14.0, 0.5)
	await ui.laptop_image(_map(), 7.0)
	await ui.think(LINES["wire_eye"]["think_4"])
	await ui.think(LINES["wire_eye"]["think_5"])
	if lynx_state != "wait":
		await ui.say("Lynx", LINES["wire_eye"]["lynx"])
		await ui.think(LINES["wire_eye"]["think_6"])
		await ui.say("Lynx", LINES["wire_eye"]["lynx_2"])
		await ui.say("Carl", LINES["wire_eye"]["carl"])
		await ui.say("Lynx", LINES["wire_eye"]["lynx_3"])
		await ui.say("Carl", LINES["wire_eye"]["carl_2"])
	ui.close()
	var pick: int = await ui.choose(LINES["wire_eye"]["choice"])
	ui.close()
	main.play("keys", -6.0)
	if pick == 0:
		await ui.laptop_line(LINES["wire_eye"]["carl_3"], true)
		await get_tree().create_timer(1.0).timeout
		await ui.laptop_line(LINES["wire_eye"]["psyon_3"])
	else:
		await ui.laptop_line(LINES["wire_eye"]["carl_4"], true)
		await get_tree().create_timer(1.0).timeout
		await ui.laptop_line(LINES["wire_eye"]["psyon_4"])
	main.play("sting", -4.0, 0.85)
	ui.glitch(0.8, 1.0)
	p.shake(0.4)
	await get_tree().create_timer(1.2).timeout
	await ui.think(LINES["wire_eye"]["think_7"])
	ui.close()
	main.play("slam", -4.0)
	ui.laptop_open(false)
	if _hum:
		_hum.queue_free()
		_hum = null
	var up := create_tween()
	up.tween_property(p, "crouch", 0.0, 0.6)
	await up.finished
	if lynx_state != "wait":
		await ui.say("Lynx", LINES["wire_eye"]["lynx_4"])
		lynx_state = "follow"
	ui.close()
	f["ev_map"] = true
	f["has_map"] = true
	f["southtown_done"] = true
	f.erase("cinematic")
	ui.show_toast(LINES["wire_eye"]["toast"], 3.0)
	main.add_connection(3.0, "the map")
	main.log_line("evidence", LINES["wire_eye"]["log"])
	_sun_lower(1.0)
	_claim()
	main.update_hud()


# ------------------------------------------------------------------ Site 3: the overpass, deserted

func _overpass_scene() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	if f.has("overpass_seen"):
		await ui.think(LINES["overpass"]["again"])
		return
	f["overpass_seen"] = true
	await ui.think(LINES["overpass"]["think"])
	ui.close()
	await p.face(EYE_P, 1.4)
	main.play("whisper", -8.0, 0.8)
	await ui.think(LINES["overpass"]["think_2"])
	await ui.think(LINES["overpass"]["think_3"])
	if lynx_state == "follow":
		await ui.say("Lynx", LINES["overpass"]["lynx"])
	ui.close()
	main.add_connection(1.0, "the overpass eye")


func _footprints() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if not main.frames_on:
		await ui.think(LINES["overpass"]["footprints_off"])
		return
	await ui.think(LINES["overpass"]["footprints"])
	if f.has("footprints_seen"):
		return
	await main.player.face(Vector3(155.5, 1.0, -22.0), 1.2)
	await ui.think(LINES["overpass"]["footprints_2"])
	if lynx_state == "follow":
		await ui.say("Lynx", LINES["overpass"]["footprints_lynx"])
	ui.close()
	f["footprints_seen"] = true
	main.add_connection(2.0, "the footprints")
	main.log_line("evidence", LINES["overpass"]["footprints_log"])
	_claim()
	main.update_hud()


func _chant_wall() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("chant_done"):
		await ui.think(LINES["chant"]["again"])
		return
	await ui.think(LINES["chant"]["think"])
	if main.glyphs_found < 3:
		await ui.think(LINES["chant"]["think_locked"])
		return
	var pick: int = await ui.choose(LINES["chant"]["choice"])
	ui.close()
	if pick != 0:
		await ui.think(LINES["chant"]["wrong"])
		return
	main.play("ding", -8.0, 0.8)
	await ui.think(LINES["chant"]["right"])
	if lynx_state == "follow":
		await ui.say("Lynx", LINES["chant"]["lynx"])
	ui.close()
	f["chant_done"] = true
	main.learn("beneath")
	main.add_connection(2.0, "the third line")
	main.log_line("lore", LINES["chant"]["log"])


# ------------------------------------------------------------------ the factory, the claim, leaving

func _verse() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	await ui.think(LINES["factory"]["verse_think"])
	await ui.say("", LINES["factory"]["verse"])
	if f.has("verse_seen"):
		return
	await ui.think(LINES["factory"]["verse_think_2"])
	await ui.think(LINES["factory"]["verse_think_3"])
	f["verse_seen"] = true
	main.add_connection(1.0, "verse one")
	main.log_line("lore", LINES["factory"]["verse_log"])


func _office_laptop() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	await ui.think(LINES["factory"]["laptop_think"])
	if not main.frames_on:
		return
	await ui.think(LINES["factory"]["laptop_frames"])
	ui.close()
	main.play("on", -10.0, 0.6)
	ui.laptop_open(true)
	await get_tree().create_timer(0.6).timeout
	await ui.laptop_line(LINES["factory"]["laptop_psyon"])
	await ui.think(LINES["factory"]["laptop_think_2"])
	ui.close()
	ui.laptop_open(false)
	if not f.has("office_laptop_seen"):
		f["office_laptop_seen"] = true
		main.add_connection(1.0, "pilgrim or heretic")
		main.log_line("lore", LINES["factory"]["laptop_log"])


## The Board's first claim: the video, the sermon or the footprints, the map.
func _claim() -> void:
	var f: Dictionary = main.flags
	if f.has("southtown_claim"):
		return
	if f.has("ev_construction_video") and (f.has("sermon_heard") or f.has("footprints_seen")) and f.has("ev_map"):
		f["southtown_claim"] = true
		main.ui.show_toast(LINES["claim"]["toast"], 5.0)
		main.log_line("claim", LINES["claim"]["log"])


func _sun_lower(k: float) -> void:
	var sun: DirectionalLight3D = main.sun
	var env: Environment = main.env
	if not sun or not env:
		return
	_sun_k = clampf(_sun_k + k, 0.0, 1.5)
	var ev := create_tween().set_parallel(true)
	ev.tween_property(sun, "light_energy", lerpf(1.0, 0.5, _sun_k / 1.5), 8.0)
	ev.tween_property(sun, "light_color", Color(1.0, 0.82, 0.62).lerp(Color(1.0, 0.5, 0.3), _sun_k / 1.5), 8.0)
	ev.tween_property(sun, "rotation:x", deg_to_rad(lerpf(-24.0, -6.0, _sun_k / 1.5)), 8.0)
	ev.tween_property(env, "ambient_light_energy", lerpf(0.42, 0.24, _sun_k / 1.5), 8.0)


func _leave() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if _ended:
		return
	f["cinematic"] = true
	await main.player.face(Vector3(-40.0, 12.0, 0.0), 1.5)
	await ui.think(LINES["leave"]["think"])
	await ui.think(LINES["leave"]["think_2"])
	await ui.say("Carl", LINES["leave"]["carl"])
	if lynx_state != "wait":
		await ui.say("Lynx", LINES["leave"]["lynx"])
	ui.close()
	f.erase("cinematic")
	_ending()


func _ending() -> void:
	var ui = main.ui
	if _ended:
		return
	_ended = true
	if main.get("_selftest"):
		return
	var f: Dictionary = main.flags
	var e: Dictionary = LINES["ending"]
	var extra := ""
	if f.has("plant_route"):
		extra += e["route"] % e["routes"][str(f["plant_route"])]
	if f.has("sermon_heard"):
		extra += e["extra_sermon"]
	if f.has("footprints_seen"):
		extra += e["extra_footprints"]
	if f.has("factory_floor_seen"):
		extra += e["extra_floor"]
	if f.has("southtown_claim"):
		extra += e["extra_claim"]
	extra += e["extra_promise"] if f.has("lynx_trust") else e["extra_no_promise"]
	ui.show_end(e["card"] % [main.glyphs_found, int(main.connection), extra])
	await ui.end_closed
	main.load_level("Home")


func _node_by_id(id: String) -> Node:
	for n in main._all_with_meta(self, "id"):
		if is_instance_valid(n) and str(n.get_meta("id")) == id:
			return n
	return null


# ------------------------------------------------------------------ the factory

func _factory_door() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("factory_open"):
		return
	f["factory_open"] = true
	main.play("door", -4.0)
	create_tween().tween_property(factory_door, "rotation:y", -1.9, 1.0).set_trans(Tween.TRANS_SINE)
	await ui.think(LINES["factory_door"]["think"])
	if lynx_state == "follow":
		await ui.say("Lynx", LINES["factory_door"]["lynx"])


func _locked_door() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("factory_unlocked"):
		await ui.think(LINES["locked_door"]["think"])
		return
	if not f.has("factory_keycard"):
		await ui.think(LINES["locked_door"]["think_2"])
		return
	main.play("on", -6.0, 0.7)
	await ui.think(LINES["locked_door"]["think_3"])
	main.play("door", -2.0, 0.8)
	create_tween().tween_property(locked_door, "rotation:y", 1.85, 1.4).set_trans(Tween.TRANS_SINE)
	locked_body.set_meta("prompt", "Go through")
	f["factory_unlocked"] = true
	main.update_hud()


func _floor_eye() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("factory_floor_seen"):
		await ui.think(LINES["factory_floor"]["think"])
		return
	f["factory_floor_seen"] = true
	main.play("sting", -6.0, 0.8)
	ui.flash(0.5)
	await main.player.face(FLOOR_EYE, 0.8)
	await ui.think(LINES["factory_floor"]["think_2"])
	await ui.say("Carl", LINES["factory_floor"]["carl"])
	ui.glitch(0.5, 1.0)
	await ui.think(LINES["factory_floor"]["think_3"])
	ui.close()
	main.add_connection(4.0, "the factory floor")


# ------------------------------------------------------------------ frames, phone, glyphs

func on_glyph(g: Object) -> void:
	match str(g.get_meta("id")):
		"g_factory":
			main.play("pressure", -6.0)
			main.player.shake(0.2)
		"g_substation":
			main.ui.show_toast(LINES["rings_react"]["toast"], 3.5)
		"g_ledger":
			main.add_connection(1.0, "the same hand")
		"g_alley":
			if lynx and lynx_state == "follow":
				main.ui.show_toast(LINES["rings_react"]["toast_2"], 3.5)


func on_connection(old: float, new: float) -> void:
	if old < 25.0 and new >= 25.0:
		main.play("whisper", -6.0, 0.8)
		main.ui.show_toast(LINES["connection"]["toast"], 4.0)


func scan_people() -> Array:
	var out := []
	for c in commuters:
		out.append([c.node, "CITIZEN\ndevices: NONE\nsync: --\n(no frames issued)"])
	if vag_informant:
		out.append([vag_informant, "UNREGISTERED\ndevices: NONE\nhousing: REVOKED\nknown to: TYSON"])
	if vag_attacker:
		out.append([vag_attacker, "UNREGISTERED\ndevices: NONE\nstate: " + ("DOWN" if main.flags.has("attacker_down") else "AGITATED")])
	if vag_convert:
		out.append([vag_convert, "UNREGISTERED\nORA GEN 2 (UNISSUED)  -  sync 100%  -  DREAMING\nsaying: '%s'" % main.CHANT[0]])
	for c in congregation:
		out.append([c, "CONGREGATION\nORA GEN 2 (UNISSUED)  -  sync 100%  -  DREAMING"])
	if priest:
		out.append([priest, "UNKNOWN\nface: (CHANGING)\ndevices: NONE\nsync: ???"])
	if worker:
		out.append([worker, "SHIFT WORKER\nVOLTX contractor\ndevices: NONE\nhours this week: 71"])
	for g in guards:
		out.append([g, "UNKNOWN\nface: COVERED\nsync: ???  -  DREAMING"])
	for v in vagrants:
		out.append([v, "UNREGISTERED\ndevices: NONE\nhousing: REVOKED"])
	return out


func phone() -> String:
	var f: Dictionary = main.flags
	var t := LINES["phone"]["greeting"]
	if f.has("lynx_met"):
		t += LINES["phone"]["footage"]
	if f.has("sermon_heard"):
		t += LINES["phone"]["sermon"]
	if f.has("factory_floor_seen"):
		t += LINES["phone"]["floor"]
	if f.has("has_map"):
		t += LINES["phone"]["map"]
	return t


func apply_args(a: Dictionary) -> void:
	var f: Dictionary = main.flags
	if f.has("lynx_met") and lynx:
		_lynx_lean(false)
		lynx_state = "follow"
		lynx.position = main.player.global_position + Vector3(-1.3, 0, 0)
	if f.has("factory_open") and factory_door:
		factory_door.rotation.y = -1.9
	if f.has("factory_unlocked") and locked_door:
		locked_door.rotation.y = 1.85
	if f.has("plant_entered") and plant_gate:
		plant_gate.rotation.y = -1.75
	if f.has("side_door_open") and side_door:
		side_door.rotation.y = 1.6
	if a.has("lynx_at"):
		var v: PackedStringArray = str(a["lynx_at"]).split(",")
		if v.size() == 2 and lynx:
			lynx.position = Vector3(float(v[0]), 0.02, float(v[1]))
			lynx_state = "stand"
			lynx_target = lynx.position
	if a.has("footage"):
		main.ui.show_picture(_footage(), LINES["ui"]["footage_caption"])
	if a.has("map"):
		main.ui.laptop_open(true)
		main.ui.laptop_image(_map(), 0.1)


func selftest() -> void:
	await intro()
	main.frames_on = true
	set_glyph_visibility(true, main.connection)
	for id in ["lynx", "vag_informant", "vag_attacker", "vag_convert", "plant_gate", "drill_housing", "wire_eye",
			"factory_door", "keycard", "locked_door", "floor_eye", "verse", "office_laptop", "overpass_eye", "footprints", "chant_wall", "my_car"]:
		var n := _node_by_id(id)
		if n:
			await main.interact(n)
			print("ok ", id)
		else:
			print("MISSING ", id)
	print("route=", main.flags.get("plant_route"), " claim=", main.flags.has("southtown_claim"), " lexicon=", main.lexicon, " trust=", main.trust, " pressure=", main.pressure)
	await main.selftest_all_interactables()
