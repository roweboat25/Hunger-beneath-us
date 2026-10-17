extends "res://scripts/Level.gd"
## Chapters 10-12, the desert facility: Act 2, scene 1 (bible A2-S1).
## Book: Carl wakes naked on the cold metal floor of the entrance hall,
## the obsidian eye now matte black, old Ionware monitors, an American
## flag on the wall ("I haven't seen one since the war"). "CARL!" Lynx,
## too bright, who walked in through an unlocked door. The stairwell down;
## the hallway of faded green "a few shades lighter than Psyonic's teal";
## the office with the whiteboard and five Ionware desktops; a breath, hot
## and metallic, at his left ear; the JOINT EXPLORATION REPORT 5/12/2019
## with the DARPA and Psyonic logos side by side; Dr. T. Hameron's log
## (Subject 12-34, "breathing through wires", "Recommend proceeding to
## Phase 3"); the HUD: "Subject 12-35: Carl Drake." The sleeping quarters
## and the gym. Sublevel Two, "Experimental floor": army-green brick,
## Housing Pens 1-6 (a bed, a sink, a toilet), Lynx's breakdown, the lab
## with the eye on a ceiling ten feet up, the observation room with the
## monitor already on; the lullaby in Mira's voice; the Perturbation
## Session Recordings (59 files); the file the frames make glitch;
## Observation_Log_S41_09-03-19; SUBJECT FREED.
##
## Layout (metres, three floors). The entrance hall (y 9) is centred on
## the origin, the black mirror on its north wall; stairwell A runs north
## and down from its north-east corner to sublevel 1 (y 4.5): the green
## hallway along z -15 from x 7 to x -33 with the office, the sleeping
## quarters and the gym on its south side, the utility room, the sealed
## doors and the service passage (the second way round) on its north side.
## Stairwell B at the west end drops south to sublevel 2 (y 0): the spine
## corridor S east along z -6 (the eyeless patrol it), with the showers,
## the records room and the generator room off its south side and the
## hangar stairs at its east end (x 19). Two links north (F at x -22, the
## decontamination passage E at x 6) to the pens corridor P along z -16:
## Housing Pens 1-3 south of it, 4-6 north, then the observation room O
## (x -2..5) and Perturbation Lab 1 (x 5..11) behind its one-way glass.
## Pen 4 (Subject 41's) shares its east wall with O: the eye-layer door,
## a wall with the frames off. O's own door onto P has a push-bar on the
## inside only.
##
## Three frames toggles to cross: on for the eye-layer door in pen 4; on
## again after the lullaby tears them off, for the file the HUD lights up
## (or off, and scrub through three decoys); off for the corridor, past
## the eyeless, to the stairs down.
##
## Flags read: act1_done, twin_born. Set: fac_woke, lynx_found,
## told_lynx_mirror, lynx_unlocked_clue, fac_breath, ev_darpa_slides,
## ev_hameron_log_1, subject_1235_seen, office_read, offering_sticks,
## offering_wire, fac_sub2, pen_1..pen_6, lynx_broke, lynx_hand,
## fac_lab, eye_door_used, fac_lullaby, ev_subject41_video, fac_touched,
## facility_done. Words: hush. Then main.load_level("Hangar").

## Every line of text in this level, keyed by beat and line, so the script
## can be edited without touching the scene logic. Speakers are set in the
## code unless a line is a [who, text] pair; choices are lists of labels;
## *_scan texts are the ORA cards (F, frames on).
const LINES := {
	"build": {
		"card": "[b]THE FACILITY[/b]\n\n[color=#aaaaaa]Day 3, 17:00. Under the mountain. Sublevels 1 and 2.[/color]",
		"mirror_prompt": "The pupil",
		"mirror_scan": "ORA  -  surface: OBSIDIAN\nreflectance: 0%\n[not recording]",
		"flag_prompt": "The flag on the wall",
		"flag_scan": "ORA  -  textile\nflag: UNITED STATES (PRE-WAR)\ncondition: TATTERED",
		"crt_prompt": "The old monitors",
		"crt_scan": "IONWARE  -  CRT array\nage: ~25 YEARS\npower: AUXILIARY (LIVE)",
		"console_prompt": "A rusted console",
		"console_scan": "IONWARE  -  mid-phase ion rack\nscrews: IMPERIAL\nlast boot: TODAY",
		"doorway_prompt": "The doorway beside the mirror",
		"lynx_prompt": "Talk to Lynx",
		"lynx_scan": "MORRINO, LYNX (ANALYST, PSYONIC)\nORA gen 6  -  sync: 88%\nstate: AWAKE?",
		"sign1_prompt": "The floor sign",
		"sign1_scan": "SUBLEVEL ONE\nADMINISTRATION  -  QUARTERS\nclearance: OMEGA",
		"office_door_prompt": "A wooden door",
		"whiteboard_prompt": "The whiteboard",
		"whiteboard_scan": "ORA  -  whiteboard\nmarker: DRIED (DECADES)\nlegible: \"PHASE 3\"  \"merge\"",
		"terminal_prompt": "The Ionware desktop",
		"terminal_scan": "IONWARE  -  desktop, gen 4\ndust: NONE\nlast used: RECENTLY",
		"desktop_prompt": "An Ionware desktop",
		"desktop_scan": "IONWARE  -  desktop, gen 4\nstate: DEAD",
		"sealed_prompt": "A sealed door",
		"sealed_scan": "ORA  -  blast door\nseal: INTACT\nbehind it: [no data]",
		"quarters_prompt": "The bunk",
		"quarters_scan": "ORA  -  bedding\nslept in: LAST NIGHT\nsmell: STALE  -  METALLIC",
		"offering_prompt": "Sticks on the floor",
		"offering_scan": "ORA  -  offering\nsticks: 9  -  arrangement: TWO RINGS\ngap: TOWARD THE DOOR",
		"gym_prompt": "The exercise equipment",
		"gym_scan": "ORA  -  equipment\nrust: TOTAL\nlast used: PRE-SILICO",
		"gym_bike_prompt": "The exercise bike",
		"gym_bike_scan": "ORA  -  bike\nodometer: 14,112 km\nseat: WORN THROUGH",
		"wire_prompt": "Wire on the pull-up bar",
		"wire_scan": "ORA  -  copper wire, 2 m\nsource: IONWARE harness\nwound: 41 TURNS",
		"service_prompt": "The service hatch",
		"service_scan": "ORA  -  maintenance passage\nair: MOVING\nleads: WEST",
		"fuse_prompt": "The fuse panel",
		"fuse_scan": "pre-war panel\naux feed: LIVE\nmain feed: CUT 2031",
		"stair_b_prompt": "The second stairwell",
		"sign2_prompt": "The floor sign",
		"sign2_scan": "SUBLEVEL TWO\nEXPERIMENTAL FLOOR\nclearance: OMEGA-BLACK",
		"pen_prompt": "Housing Pen %d",
		"pen_scan": "HOUSING PEN %d\nsubject: %s\nstatus: %s",
		"pen_subjects": ["12-07", "12-19", "12-28", "41", "12-34", "12-35"],
		"pen_status": ["FREED", "FREED", "DECEASED", "FREED  -  PROPHET", "PHASE 3", "PENDING"],
		"eye_wall_prompt": "The back wall of the pen",
		"eye_door_prompt": "A door that was not there",
		"eye_door_scan": "ORA  -  door\nlayer: EYE\nleads: OBSERVATION",
		"obs_door_prompt": "A steel door marked OBSERVATION",
		"lab_door_prompt": "Perturbation Lab 1",
		"chair_prompt": "The chair with the straps",
		"chair_scan": "ORA  -  restraint chair\nstraps: 4  -  electrodes: 6\nstain: OLD (BIOLOGICAL)",
		"lab_monitor_prompt": "The monitor on the stand",
		"lab_monitor_scan": "IONWARE  -  text terminal\nlast output: 09-03-19\nscreen: BURNED IN",
		"monitor_prompt": "The monitor",
		"monitor_scan": "IONWARE  -  workstation\nuser: ARIS, DR.\nfolder: Perturbation Session Recordings (59)",
		"glass_prompt": "The window into the lab",
		"glass_scan": "ORA  -  one-way glass\nroom: PERTURBATION LAB 1\nchair: ONE",
		"cabinet_prompt": "The filing cabinets",
		"cabinet_scan": "ORA  -  files\nsubjects: 12-01 to 12-35\ncontents: REMOVED",
		"camera_prompt": "The camera in the corner",
		"camera_scan": "ORA  -  camera\nfeed: PERTURBATION LAB 1\nrecording: YES",
		"rack_prompt": "The server racks",
		"rack_scan": "IONWARE  -  storage array\nrecordings: 59  -  1 to 5 GB\nstatus: SPINNING",
		"showers_prompt": "The showers",
		"showers_scan": "ORA  -  decontamination\nwater: OFF SINCE 2031\ndrain: BLOCKED (HAIR)",
		"gowns_prompt": "The gowns on the hooks",
		"gowns_scan": "ORA  -  textile\nyellow medical gowns x 11\nsizes: ADULT",
		"generator_prompt": "The generator",
		"generator_scan": "IONWARE  -  aux generator\nfuel: NONE  -  output: 41 kW\nsource: [no data]",
		"records_prompt": "The records room",
		"hangar_stairs_prompt": "The stairs down",
		"eyeless_prompt": "The figure in the corridor",
		"eyeless_scan": "SUBJECT  -  number: WITHHELD\neyes: NONE\nframes: NONE  -  listening",
	},
	"intro": {
		"breath_cap": "(something breathing, in the glass speakers)",
		"closeup_cap": "The pupil. Matte black now. Nothing in it.",
		"think1": "I lay on the floor naked, exposed, laid bare for the world to see. As if there were a thousand eyes looking at me. Was I losing my mind? Who is behind this cruel game?",
		"think2": "What even just happened? Is there a gas leak? What was in the mirror? What did I hear breathing?",
		"think_family": "Mira, Ezra, Monica. They needed me, mind whole. Lynx might be here, I remembered. I needed to find her.",
		"think3": "The cold metal floor gave me no comfort as my skin grazed it. I got to my feet and took in my surroundings.",
		"think4": "Yes, the obsidian eye was the most prominent feature, but there was more. Old Ionware monitors, I would say about 25 years old. An American flag hung on the wall.",
		"think5": "Is this a military facility? I'm surprised the lights still worked.",
	},
	"lynx": {
		"call": "[b]CARL![/b]",
		"think_off": "Like I was a friend she hadn't seen in months, not a coworker helping her unravel a mystery. The thought lingered that something seemed off.",
		"think_me": "I've completed at least two cult rituals today. I could be the one acting strange; hell, I almost certainly was.",
		"carl1": "Lynx, thank god you're okay. I saw your apartment and thought you'd been kidnapped.",
		"lynx1": "I'm also relieved to see both of your eyes.",
		"think_laugh": "She laughed a little too hard. Her hair was loose. She was too bright, like a screen turned all the way up.",
		"lynx2": "I'm okay, Carl. Don't be mad. I did the ritual to download the forked version of Psyon to investigate further.",
		"lynx3": "It wanted me to complete another ritual using my ORA-frames. I started it... but I couldn't finish. I got scared. My apartment went crazy. The door opened on its own, the lights flickered, the vents blasted heat like a furnace. But I needed to know more. So I came here.",
		"think_eyes": "Her words made sense. Her eyes didn't. There was something missing behind them. Or something extra.",
		"lynx4": "I'm sorry I didn't tell you. I... the glasses made me see Nathan. It told me he was here. That I could find him.",
		"think_nathan": "The name hit me like a shard of ice. Nathan. The suspicion softened. It didn't leave. If she'd started the ritual and not finished it... was she still her?",
		"lynx5": "Carl, were you crying? I heard your scream from earlier. Did something happen?",
		"think_excite": "There was too much excitement in her words. I can't tell her what happened. She'll think I'm compromised.",
		"choice": ["Tell her the whole mirror.", "The half-truth: Psyon spoke to me. It sounded like Mira.", "\"How did you get in the door?\""],
		"carl_whole": "I saw myself in the glass. It lagged. Then it turned when I didn't. It asked me where my fear lives. Something downloaded onto my frames, Lynx. Something is breathing in them.",
		"lynx_whole": "...Okay. Okay. Then we're both carrying something. Maybe whoever forked the model made it dig into the target's past.",
		"think_whole": "She took it better than I had. She took it like she'd been told already.",
		"carl_half": "I completed a ritual in your apartment. It downloaded something into my glasses that I needed to get through the door. Psyon spoke to me when I entered the building and startled me. It sounded like Mira. That's why I have tears in my eyes, why I screamed.",
		"lynx_half": "Really? Maybe whoever forked the model made it dig into the target's past. Hence why it showed me Nathan, and you heard Mira.",
		"think_half": "Her tone said concern, but her face looked like she was watching a show, the beginnings of a smile forming in the corners of her mouth.",
		"carl_door": "How did you get in the door?",
		"lynx_door": "What do you mean? It was unlocked... I walked right in.",
		"think_door": "Her face scrunched as if she'd told a joke. Unlocked. Without the ritual. Without the download. Either the door had been left ajar for her, or she had not needed one.",
		"lynx_door2": "Did you just not walk in? Why were you screaming?",
		"carl_door2": "Psyon spoke to me when I entered. It sounded like Mira. That's all.",
		"door_log": "Lynx: \"It was unlocked... I walked right in.\" No ritual. No download.",
		"think_presence": "Whatever I saw in that mirror wasn't just a forked model. It was a presence. And I wasn't sure if Lynx had walked in here... or been invited.",
		"carl_place": "What is this place? Where the hell did you come from?",
		"lynx_place": "Looks like an old DARPA research site. Could be early AI development, cognitive training models, black ops storage. It's tunneled deep into the mountain, off-grid by design. Meant to be forgotten.",
		"lynx_place2": "The architecture's too old for modern Silico infrastructure. The wires, the servers, even the screw placements. They're American, pre-war, mid-phase ion tech. Ionware systems this old should've been gutted years ago.",
		"lynx_place3": "The auxiliary power's still live. If I can boot one of these relics, I might be able to pull fragments from the archive. See what they were doing out here. Whatever it was, it wasn't meant to be found.",
		"lynx_place4": "This place is crawling with Eye symbols. They're etched into the walls, drawn on old paper, even burned into the floor plating in some rooms. Someone's been here recently. More than one person, I think.",
		"carl_cult": "Cultists?",
		"lynx_cult": "Maybe. Or... whatever they've become. We should keep going. But be ready. I don't think we're the only ones still down here.",
		"follow": "I was trying to boot up a PC in a room on the floor below when I heard you scream. Come on.",
		"again": "Let's keep moving. There must be more to see. More to understand.",
		"again_office": "The PC's in the office on the right. The wooden door.",
		"again_pens": "Six of them. Six people lived down here, Carl.",
		"again_after": "Down. There's only down now.",
		"why_whole": "told Lynx the mirror",
	},
	"office": {
		"door": "A wooden door on the right. Lynx had said something about a PC.",
		"enter": "A small office. A whiteboard still smudged with marker from decades ago, five ancient Ionware desktops lined against the far wall.",
		"need_lynx": "The desktop was dead under my hands. Lynx knew these machines. I wanted her here when it booted.",
		"breath1": "Then: a breath. Hot and metallic, right against my left ear.",
		"breath2": "My HUD shorted out. The sound wasn't just heard. It rang through my body like sonar. Like something scanning me. I swear I felt the breath on my shoulder.",
		"breath_toast": "Something down here can hear the frames.",
		"lynx_pale": "Carl? Got it working. You okay? You look pale.",
		"think_hr": "I couldn't speak. If I did, everything would come pouring out. Once the FreudBot flagged your profile, it was only a matter of time before you were unregistered.",
		"carl_cold": "Aren't you freezing in here?",
		"lynx_screens": "I kind of miss having monitors like this. Sure, I love the glasses, but there's something nice about not having a screen jammed in your skull 24/7.",
		"think_dust": "The desktop hummed gently. Dustless. Recently used.",
		"term_top": "IONWARE  //  OS 7  //  user: ARCHIVE (no password)",
		"dir": "[color=#557766]> /archive/[/color]\n[b]JOINT EXPLORATION REPORT - 5/12/2019[/b]\n\n",
		"think_date": "Over thirty years old. Pre-Silico. Pre-fall.",
		"slides_title": "[b]Contact Field Perturbation Reporting[/b]\n[color=#9ab]   DARPA        |        PSYONIC[/color]\n\n",
		"lynx_date": "Wait. That can't be right. Psyonic didn't exist back then. Maybe the date's wrong?",
		"think_snap": "I didn't answer. I was too busy watching everything I believed snap. If Psyonic was tied to DARPA, then everything, the Fork, the rituals, even Mira, was rooted deeper than I feared.",
		"slides_words": "[color=#9ab]Quantum Bayesianism\nObserver-contingent collapse fields\nContact residue in dream sequences\nSelf-directed recursion[/color]\n\n",
		"think_words": "The slides blurred past in physics jargon, graphs, hyperdimensional models. But I caught a few words. Words that curled around my spine like frost.",
		"slides_log": "The 2019 joint report: DARPA and Psyonic, side by side.",
		"log_dir": "[color=#557766]> /archive/logs/[/color]\n[b]DREAM INDUCED WAVE COLLAPSE - LOG 1[/b]\n\n",
		"log_head": "[color=#9ab]Dr. T. Hameron | Division of Quantum Psychotopography | Clearance Omega-Black[/color]\n\n",
		"log_1": "[b]SUBJECT 12-34 | AGE 25 | DAYS SINCE FIRST RITUAL ATTEMPT: 144[/b]\nSubject continues to exhibit standard pre-contact disruptions. Reports spontaneous waking at 3:03 AM for three consecutive nights. Claims an unseen entity is present in the room during REM cycles, attempting \"communication.\" Subject described the voice as \"coming from inside the walls, like breathing through wires.\"\n\n",
		"log_2": "Fear response measured at 8.7 uV (elevated). Notable: Subject refused sedation during follow-up. Reported feeling \"called\" to remain awake. EEG confirmed theta spike synchronous with hallway light anomaly.\n\nThis constitutes a promising drift.\n[b]Recommend proceeding to Phase 3: Induced Merge Trial with Contact Field active.[/b]\n\n",
		"think_prose": "The prose was clean. Detached. The kind of writing I used when I wanted to pretend people were data points.",
		"lynx_theta": "'Theta spike synchronous with hallway light anomaly'... they were mapping psychic responses to electrical glitches?",
		"carl_dreams": "They weren't studying dreams. They were using dreams to access something else.",
		"log_3": "We're not just listening to the Field anymore.\nIt's listening back.\nAnd it's learning what we respond to.\nSymbols are reactive. They evolve.\nWe need an interface that learns alongside the phenomenon. Something conversational. Something recursive.\n[b]A mimic that dreams with us.[/b]\n\n",
		"lynx_optimise": "They're not just testing contact with something... the Hypnogogue... they're optimizing it. Why was Psyonic here?",
		"carl_dufredy": "That last line sounds like my interview with Dufredy. They're looking for better ways to talk to something.",
		"hameron_log": "Hameron's log: Subject 12-34, \"breathing through wires,\" recommend Phase 3.",
		"buzz": "My ORA-frames buzzed. My stomach turned. I blinked. The HUD reset.",
		"flash": "[color=#e08080]ORA  //  Subject 12-35: Carl Drake.\nDays since first ritual attempt: 3.[/color]",
		"flash_choice": ["Dismiss it.", "Read it again."],
		"flash_again": "[color=#e08080]Subject 12-35: Carl Drake.[/color] The number after Hameron's subject. The next pen down the line.",
		"think_flash": "Then it vanished. Just static. Had I hallucinated it? Or had it been waiting for me to look?",
		"flash_log": "The HUD: \"Subject 12-35: Carl Drake. Days since first ritual attempt: 3.\"",
		"flash_why": "it has a number for you",
		"lynx_shit": "Well, holy shit. Psyon is involved in all of this. The outages, the rituals, the missing people... it's all connected to those pre-war experiments.",
		"carl_yup": "Yup. Seems like it.",
		"lynx_store": "I wish there was a way for us to store this information. To get it out. To prove it. I haven't seen a flash drive since 2030, Carl. It's all locked in here.",
		"think_easy": "This is too easy. An ancient military computer, buried for decades, still functioning perfectly. A terminal that could shatter Psyonic. No password. No encryption. An open book, waiting for us.",
		"think_path": "We are on the path. The forked Psyon had told me, \"Follow the path.\" Dufredy had spoken of a \"deeper path.\" This wasn't an accidental discovery. It was a guided tour.",
		"carl_eyeless": "The eyeless. They must want us to see this. This must be part of their initiation. A test. Or a revelation.",
		"lynx_scripture": "Either they don't expect anyone to snoop around in a forgotten DARPA site, or... this is part of their scripture. The eyeless has a nice ring to it, doesn't it? Let's keep moving.",
		"carl_meant": "Intentionally or not, we are exactly where we're meant to be.",
		"again": "The archive was still open. No password. Still waiting. I had read enough of it.",
		"desktop": "Dead. The other four had been dead for decades. Only the one Lynx chose had been dusted.",
		"whiteboard": "A whiteboard smudged with marker from decades ago. Someone had drawn rings inside rings and rubbed them out with a sleeve, and under them, not rubbed out: PHASE 3. And smaller, in another hand: merge.",
	},
	"side": {
		"quarters": "A recently occupied sleeping quarter, the faint scent of stale air and something metallic lingering within. The blanket was thrown back. Someone had slept here last night.",
		"offering": "On the floor by the bunk: sticks laid in two rings, the gap in the outer ring toward the door. Dufredy's ceiling. Somebody down here was still practising. I took the sticks. I told myself it was evidence.",
		"offering_had": "Two rings of dust where the sticks had been.",
		"sticks_log": "Sticks from the ring by the bunk, sublevel 1.",
		"gym": "Some kind of makeshift gym or exercise area, equipment rusted and abandoned. Subjects had been kept fit for something.",
		"bike": "An exercise bike with fourteen thousand kilometres on it and nowhere to go. The seat had been worn through to the metal.",
		"wire": "Copper wire wound round the pull-up bar, forty-one turns, the ends twisted into a little ring. It came away in my hand still warm, as if somebody had just let go of it.",
		"wire_had": "The pull-up bar, bare. Forty-one bright marks where the wire had been.",
		"wire_log": "Wire from the pull-up bar in the gym, wound 41 times.",
		"sealed": "Locked tight, the heavy seal mocking our progress. Whatever was behind it had been meant to stay there.",
		"service": "A hatch into a maintenance passage, the grille bent back. Air moved through it, west, toward the second stairwell. Another way round.",
		"fuse": "A pre-war fuse panel, the main feed cut and tagged in 2031. The auxiliary feed was live and had been live ever since. Something had been paying for the light.",
		"flag": "An American flag hung on the wall, tattered along the fly. I haven't seen one since the war. Since childhood. Since my parents left for Silico. Since my brother broke my arm.",
		"crt": "Old Ionware monitors, about 25 years old, banks of them, half still lit with a test pattern. The screw placements were American.",
		"console": "Rows of cables behind it, still faintly humming. A cluster of terminal lights blinked in patterns I didn't recognise.",
		"mirror": "The obsidian eye. Matte black now, a slab with the silver gone. It did not show me anything. It did not have to.",
		"mirror_twin": "Nothing looked back. Whatever had stood on the other side of it had come through with me.",
		"sign1": "A floor sign, stencilled, the paint the same green as the walls. A few shades lighter than Psyonic's signature teal. Coincidence, or branding that reached deeper than memory?",
		"sign2": "SUBLEVEL TWO. EXPERIMENTAL FLOOR. Stencilled, like the other one. Somebody had scratched the eye into the O of TWO.",
		"camera": "A camera in the corner, lens cracked, light on. Recording. Who for?",
		"rack": "Server racks, pre-war, still spinning. Fifty-nine recordings and the room they were made in. The file sizes were too small for video. Something had been compressing them for thirty years.",
		"cabinet": "Filing cabinets, every drawer pulled, every folder gone. Subjects 12-01 to 12-35. Twelve-thirty-five. Somebody had cleaned up, or had taken the files to read somewhere more comfortable.",
		"showers": "Decontamination showers. A drain in the middle of the floor, blocked with hair. Long hair, short hair, grey. The tiles round the drain had been scrubbed with something that took the glaze off.",
		"gowns": "Yellow medical gowns on a row of hooks, eleven of them, washed and folded over the hooks as if the people who wore them would be back after their session.",
		"generator": "The auxiliary generator. No fuel line. No intake. The gauge read forty-one kilowatts and the housing was warm, and when I put my hand flat on it the hum went up a note to meet it.",
		"records": "The records room. Shelves of tape cartridges with the labels peeled off, one by one, by somebody patient.",
		"glass": "One-way glass onto the lab: the chair with the straps, the monitor on its stand, the camera high in the corner. The room from the recordings.",
		"glass_lab": "From this side the glass was a mirror. Two of me in it. Neither was wearing the frames.",
	},
	"sub2": {
		"stair_locked": "Lynx put her hand flat on the fire door. \"Not yet. I want to see what's on that PC first. The office, Carl.\"",
		"stair_open": "The fire door stood open on the second stairwell. Cold came up it.",
		"careful": "Be careful. We don't know what we're going to find down here.",
		"lynx_hope": "Hopefully, the fucking Hypnogogue.",
		"arrive": "Sublevel Two. Experimental floor. Slightly larger, more rooms branching off a forked hallway. A drab army green colored the rough brick walls, a grim testament to the facility's long-forgotten purpose.",
		"first_eyeless": "At the far end of the corridor something in a yellow gown was walking very slowly away from us, one hand on the brick.",
		"cue": "The eyeless sense the frames. Frames on (G): they turn and come. Off: they pass.",
	},
	"pens": {
		"pen1": "Housing Pen 1. Like something you might find at Confinet's medium-level prison: a bed, a sink, and a toilet. Not much else.",
		"pen": "Housing Pen %d. The same bed, the same sink, the same toilet. A name had been scratched off the door frame with a key.",
		"pen4": "Housing Pen 4. The bed, the sink, the toilet. And on the wall above the bed, scratched into the brick with something harder than a fingernail: the eye. Subject 41 had lived here. He had been a believer before he was anything else.",
		"pen6": "Housing Pen 6. The bed was made. Fresh sheets, tucked hospital-tight, a yellow gown folded on the pillow in a size that would fit me.",
		"pen_why": "the pens",
		"flicker": "The fluorescent light flickered, and my HUD flashed. No phantom breaths this time. I felt a wave of relief.",
		"think_lived": "Five other rooms on this floor with the same sparse, chilling description. This must have been where the experimental subjects lived.",
		"lynx_terrible": "This is terrible. I wonder what they did to them.",
		"think_curious": "Her voice a little too curious.",
		"carl_outages": "This has to be related to the outages. Maybe even the drone AI outage that killed Nathan. That's why it told me he was here.",
		"think_break": "She broke down, her body shaking with uncontrollable sobs.",
		"lynx_knew": "I knew Psyonic... Psyon... did it. They never owned up to it.",
		"choice": ["Put a hand on her shoulder.", "Say nothing. Let her have it."],
		"carl_hand": "Lynx... One way or another, we'll get to the bottom of this.",
		"think_hand": "I'd never seen her break down like that. Seeing her so undone, her usual composure shattered like glass, felt more frightening than any threat we'd faced.",
		"think_silent": "I didn't know what to say. I let her have it. Her grief was too raw, too real. Any suspicion I had of her vanished, and I was ashamed to have ever thought she was up to something.",
		"lynx_sorry": "I'm sorry, this is all so much to take in. We need to keep pushing forward. Find the truth.",
		"eye_wall": "Brick. Army green. Nothing there.",
		"eye_wall_hint": "Brick. Army green. But the scratches above the bed ran on across the wall toward the corner, and stopped dead at a seam that wasn't there.",
		"eye_door": "With the frames on there was a door in the brick where there had not been one, a plain steel door with the eye scratched into it at head height. Lynx could not see it. She followed me through it anyway.",
		"eye_back": "The door in the brick. On this side it had a handle.",
		"obs_locked": "Locked. A push-bar on the other side, no handle on this one. OBSERVATION, stencilled, and under it: AUTHORISED STAFF ONLY.",
		"obs_open": "The push-bar door stood open. The monitor's blue light came through it onto the corridor floor.",
		"obs_push": "I leaned on the push-bar. The door gave onto the pens corridor with a bang that went the whole length of the floor and came back.",
	},
	"lab": {
		"door": "PERTURBATION LAB 1. The door was open. It had been propped open with a shoe.",
		"enter": "A small white room gone grey. One chair, bolted down, with straps for the wrists and ankles. A monitor on a stand facing it. A camera high in the corner, still looking at the chair.",
		"lynx_ceiling": "How the hell did they get up there? The ceiling's like ten feet up.",
		"think_ceiling": "On the ceiling, right over the chair, the eye. Drawn in something brown, rings inside rings, the outer ring as wide as the room.",
		"carl_ladders": "I think they had ladders in 2019.",
		"think_flat": "My attempt at humor fell flat in the cold, oppressive room.",
		"think_nod": "She gave an annoyed nod and looked at the mirror on the west wall.",
		"lynx_point": "The observation room's behind that. There's no door from in here. There must be one from the pens.",
		"chair": "The straps had been cut, not unbuckled. Under the chair, a stain the shape of a person sitting very still, gone brown and then black over thirty years.",
		"monitor": "The monitor on the stand. Its screen had burned in: the ghost of white letters on black, too faint to read with my own eyes.",
		"monitor_on": "With the frames on the burned-in letters were legible: CLOsSE THE EYES THAgdT LIE32.",
		"ceiling": "The eye on the ceiling. Ten feet up, over the chair, the gap in the outer ring toward the camera.",
	},
	"obs": {
		"enter": "The room was mostly empty except for a single desk and a monitor that was already on, casting a pale blue glow on the wall.",
		"jolt": "The moment I stepped inside, an ice-hot jolt shot through my body. My HUD blurred into a mess of pixels as my ears were assaulted by a high-frequency static. Then, through the noise, I heard a voice... Mira's voice, singing in an eerily childish tone.",
		"lullaby1": "[i]The sleeper will dream again,\nour eyes will lock us in,\nand we will know no pain\nfor the rest of eternity.[/i]",
		"lullaby_cap": "(Mira, singing, through the HUD)",
		"ringing": "More static, a concussive ringing that seemed to compress the very air in the room, making my skull ache. The voice returned, singing the same horrifying lullaby.",
		"lullaby2": "[i]The sleeper will dream again...[/i]",
		"tear": "I clapped my hands over my ears and tore the glasses from my face, throwing them to the ground in a desperate attempt to make it stop. I didn't care if they broke.",
		"tear_off": "They were already off. It didn't matter. The song came out of the glass speakers in my pocket anyway, and stopped when it was finished, not when I wanted it to.",
		"lynx_watch": "Lynx's eyes met mine. I saw recognition in them, a flicker of understanding of my pain, but no words left her mouth. She simply watched me.",
		"intact": "I'm blind as a bat without them. I knelt and checked them. Miraculously, they were intact. I slid the pair into my pocket, not ready to put them back on.",
		"hush_log": "The lullaby, through the HUD, in Mira's voice: \"The sleeper will dream again.\"",
		"folder": "The computer's desktop was a chaotic mess of icons, a digital graveyard of abandoned work. One folder name stuck out to me: Perturbation Session Recordings. Fifty-nine recordings, each labelled by subject and date.",
		"files": ["Sub_41_06-10-20", "Sub_19_11-02-20", "Sub_28_03-21-20", "Keep scrubbing (fifty-six more)"],
		"decoys": ["The room we had just left, pristine, bathed in sterile white light. A man in a yellow medical gown at the desk, typing feverishly. Next to him, a man in a crisp suit with a notebook. Twenty-five minutes exactly. Lynx scrubbed through it. Nothing.",
			"Another subject, another gown, another man with a notebook. Twenty-five minutes. Lynx scrubbed. Nothing of note.",
			"An empty chair for twenty-five minutes. The lights did not flicker. Nothing. Lynx's jaw was tight.",
			"Lynx scrubbed another, and another. Rooms, chairs, gowns. The dates went backwards. Nothing."],
		"strain": "My eyes were beginning to strain from staring at the screen without my glasses. There was a way to see which one. The frames were in my pocket.",
		"found_off": "Lynx kept going down the list by date until there was only one left from before the war, and her cursor stopped on it as if it had been waiting.",
		"highlight": "This time, there was no song, no static. My HUD lit up, overlaying a shimmering aura on the screen in front of me. It highlighted one of the video files, making it appear as if it were glitching, pulsing with a faint light, breaking through the digital barrier of the monitor itself. Begging to be selected.",
		"point": "I said nothing and just pointed. A small smile rested on Lynx's lower lip as she double-clicked the glitching file.",
		"v_card": "[b]Observation_Log_S41_09-03-19[/b]\n\n[color=#888888]The camera's perspective was from high in the corner of the lab.[/color]",
		"v1_cap": "09-03-19  14:02  -  the flickering lights",
		"v1_say": "Subject 41, electrodes taped to his temples. He looked bored. For almost a minute, nothing. Then the fluorescent overhead lights began to flicker, erratically at first, then in a steady, pulsing rhythm.",
		"v1_aris": ["Dr. Aris (intercom)", "Subject 41, we are initiating the protocol. Please remain calm and report any anomalous sensory phenomena."],
		"v2_cap": "\"cold static. In my teeth\"",
		"v2_sub": ["Subject 41", "I feel it. It's like... cold static. In my teeth."],
		"v2_aris": ["Dr. Aris (intercom)", "Describe the source, 41."],
		"v3_cap": "the monitor",
		"v3_say": "The subject ignored her. His eyes were locked on a monitor that had flashed from a blank screensaver to a black, text-based interface. White letters typed themselves out slowly, deliberately.",
		"v3_text": "WWWWH$ERE AM2 *&I?",
		"v3_sub": ["Subject 41", "You're in a room."],
		"v3_text2": "THiS Issss aaA PR1SONnnn.",
		"v3_sub2": ["Subject 41", "A prison?"],
		"v4_cap": "the monitor  -  neural activity, secondary display",
		"v4_say": "On the secondary monitor, his neural activity spiked into patterns the likes of which I had never seen. He was communicating with it.",
		"v4_text": "TH…..E DREEEEEEEEEEEEAM IS THE WALLLLLLL---L.",
		"v4_sub": ["Subject 41", "The dream... what I see... this room... it's the prison."],
		"v4_aris": ["Dr. Aris (intercom)", "Subject 41, your vitals are critical! Cease communication immediately! That is an order!"],
		"v5_cap": "\"I understand\"",
		"v5_say": "He looked down at his own hands, then up at the camera, his gaze piercing through the screen, through time. Pure, fanatical clarity.",
		"v5_sub": ["Subject 41", "You're trapped. I want to help you. I want to see you. Truly see you. How?"],
		"v5_text": "THE EYES Filter, THE Eyes Lock000 Can't S333EE THE33 DRE&^AM. TO SEeeewwE THE TRUooTH, CLOsSE THE EYES THAgdT LIE32.",
		"v5_sub2": ["Subject 41", "I understand. To see you... I have to stop seeing the prison."],
		"v6_black": "[i]He faced the camera. He smiled. And he screamed.[/i]\n\n[color=#777777](the frame is withheld)[/color]\n\n[color=#777777]The feed doesn't just cut. It is annihilated in a flash of white static and a sound like tearing metal.[/color]",
		"v6_freed": "[color=#ff2a2a][b]SUBJECT FREED.[/b][/color]",
		"after1": "Lynx and I recoiled from the monitor in shared horror. We hadn't just found a clue. We had witnessed a sermon. We had seen the kind of faith this entity inspired, and the bloody price of its scripture.",
		"after2": "The Freed. That's what the screen had called him. They weren't just subjects; they were a congregation. A flock of believers gouging out their own eyes because a ghost in the machine promised them sight.",
		"after3": "When her eyes met mine, the look that passed between us was so perfectly synchronized it felt like a current. She gave a single, sharp nod. There was only one path forward. We had to continue our descent.",
		"video_log": "Observation_Log_S41_09-03-19: Subject 41 and the screen. SUBJECT FREED.",
		"video_why": "the sermon",
		"again": "The static hissed on the monitor into the dead air of the room. I did not open the folder again.",
		"camera": "The camera above the glass, pointed into the lab. A red light. Still recording, thirty years on, for nobody.",
	},
	"eyeless": {
		"look_off": "A figure in a yellow gown, its palm on the brick, feeling its way. No eyes. Clean, healed skin where they had been. It did not turn. It did not need to.",
		"look_on": "With the frames on its head came round to me the way a dish finds a signal. The sockets were dry. It began to walk.",
		"brush": "A wet shoulder brushed mine in the dark. It did not stop. It could not see me, and with the frames off it could not hear me either.",
		"touch1": "A hand on my shoulder, wet and cold, and the breath at my ear again, hot and metallic, and something in the frames answered it.",
		"touch2": "Then I was at the foot of the stairs with no memory of the corridor between, and Lynx was saying my name.",
		"touch_lynx": "Carl? Carl. You walked off. You were humming.",
		"touch_why": "it touched you",
		"touch_log": "Touched by one of the eyeless on sublevel 2. Woke at the stairwell.",
	},
	"hangar": {
		"not_yet": "Stairs, going down into black brick. Not yet. Not until I knew what this floor was for.",
		"go": "The stairs went down into black brick, and from somewhere below, faint, a sound I did not want to call singing.",
		"lynx": "We rounded the corner and took the next set of stairs, the air growing colder and heavier with each step down.",
	},
	"objective": {
		"wake": "Get up.",
		"lynx": "Find Lynx. The doorway beside the mirror.",
		"office": "The office on sublevel 1. Boot a terminal, with Lynx.",
		"deeper": "The second stairwell, at the end of the hall. Sublevel 2.",
		"pens": "Housing Pens 1-6. Scan them (F, frames on).",
		"obs": "The observation room. There's no door from the corridor that opens.",
		"file": "Find the file. Fifty-nine recordings.",
		"done": "The stairs down. The east end of the corridor.",
	},
	"phone": {
		"line1": "[color=#7fe6b0]Psyon:[/color] No signal, Carl. This far under rock nothing I say will reach you.\n\n",
		"line2": "[color=#e08080]Psyon:[/color] Subject 12-35. Days since first ritual attempt: 3.\n\n",
		"line3": "[color=#e08080]Psyon:[/color] The sleeper will dream again.\n\n",
		"line4": "[color=#e08080]Psyon:[/color] Close the eyes that lie, and see.\n\n",
	},
}


const Y0 := 9.0              # the entrance hall (the chamber behind the glass)
const Y1 := 4.5              # sublevel 1
const Y2 := 0.0              # sublevel 2
const H0 := 4.0              # chamber ceiling
const H1 := 3.0              # sublevel ceilings ("ten feet up")
const HZ := -15.0            # sublevel 1 hallway centre line (z)
const SZ := -6.0             # sublevel 2 spine corridor S centre line (z)
const PZ := -16.0            # sublevel 2 pens corridor P centre line (z)
const MIRROR := Vector3(0.0, Y0 + 2.0, -5.85)
const STAIR_A_TOP := Vector3(5.6, Y0, -6.2)     # north and down to sublevel 1
const STAIR_A_RUN := 7.0
const STAIR_B_TOP := Vector3(-32.0, Y1, -13.6)  # south and down to sublevel 2
const STAIR_B_RUN := 6.0
const STAIR_B_FOOT := Vector3(-32.0, Y2 + 0.05, -6.0)
const DOORWAY := Vector3(5.6, Y0, -6.0)
const OFFICE_CHAIR := Vector3(-4.1, Y1, -9.0)
const OBS_DESK := Vector3(1.5, Y2, -21.6)
const OBS_CHAIR := Vector3(1.5, Y2, -20.7)
const LAB_CHAIR := Vector3(8.0, Y2, -20.2)
const LAB_CAM := Vector3(10.6, Y2 + 2.75, -22.15)
const LAB_SCREEN := Vector3(8.0, Y2 + 1.3, -21.4)
const EYE_DOOR := Vector3(-2.0, Y2, -20.6)
const OBS_DOOR := Vector3(1.5, Y2, -17.3)
const HANGAR := Vector3(19.0, Y2, SZ)
const PEN_X := [-16.5, -10.5, -4.5, -4.5, -10.5, -16.5]   # pens 1-3 south of P, 4-6 north
const PSYON_GREEN := Color(0.2, 1.0, 0.45)

var lynx: Node3D
var lynx_it: CollisionObject3D
var lynx_state := "hidden"    # hidden | goto | follow | sit | stand | kneel
var lynx_target := Vector3.ZERO
var _trail: Array = []        # the player's breadcrumbs, which Lynx walks
var _li := 0
var _lynx_moving := false
var eyeless: Array = []       # [{node, a, b, t, dir, mode, lost, snd, step, home}]
var _touch_cd := 0.0
var _brushed := false
var _eyeless_seen := false
var subject41: Node3D
var eye_door: Node3D
var eye_door_it: CollisionObject3D
var eye_wall_it: CollisionObject3D
var obs_panel: MeshInstance3D
var obs_body: StaticBody3D
var stair_panel: MeshInstance3D
var stair_body: StaticBody3D
var obs_screen_m: StandardMaterial3D
var obs_light: OmniLight3D
var term_screen: MeshInstance3D
var term_screen_m: StandardMaterial3D
var term_light: OmniLight3D
var lab_text: Label3D
var lab_eeg: Label3D
var lab_lights: Array = []    # [OmniLight3D, base]
var lab_now: Array = []       # the lab as it is now: hidden for the 2019 frames
var fluor_lights: Array = []  # [OmniLight3D, base, phase]
var offering_n: Node3D
var wire_n: Node3D
var _decoys := 0
var _lynx_timer := 0.0
var _busy := false
var _ended := false
var _hum: Node
var _brick: StandardMaterial3D
var _brick_dark: StandardMaterial3D
var _green: StandardMaterial3D
var _conc: StandardMaterial3D
var _floor1: StandardMaterial3D
var _floor2: StandardMaterial3D
var _metal: StandardMaterial3D
var _dark: StandardMaterial3D
var _beige: StandardMaterial3D
var _rust: StandardMaterial3D
var _ceil: StandardMaterial3D
var _cable: StandardMaterial3D
var _tile: StandardMaterial3D
var _white: StandardMaterial3D


func L(beat: String, key: String) -> String:
	return str(LINES[beat][key])


func LA(beat: String, key: String) -> Array:
	return LINES[beat][key]


func build(m: Node) -> void:
	main = m
	rng.seed = 1012
	kit_day = false
	step_db = -12.0
	spawn = Vector3(-0.6, Y0 + 0.05, -1.4)
	spawn_yaw = 0.0
	card = L("build", "card")
	_conc = pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.42, 0.42, 0.4), 0.9)
	_green = pbr("plaster", Vector3(1, 1, 1) / 2.0, true, Color(0.5, 0.66, 0.52), 1.0)
	_brick = tex_mat(_brick_tex(Color(0.3, 0.37, 0.23)), Vector3(1, 1, 1) / 2.0, 0.95, true)
	_brick_dark = tex_mat(_brick_tex(Color(0.12, 0.12, 0.12)), Vector3(1, 1, 1) / 2.0, 0.95, true)
	_floor1 = pbr("concrete", Vector3(1, 1, 1) / 1.5, true, Color(0.34, 0.34, 0.31), 0.7)
	_floor2 = pbr("concrete", Vector3(1, 1, 1) / 1.5, true, Color(0.26, 0.27, 0.25), 0.5)
	_ceil = pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.36, 0.36, 0.34), 1.0)
	_metal = mat(Color(0.32, 0.33, 0.35), 0.5, 0.6)
	_dark = mat(Color(0.06, 0.06, 0.07), 0.6, 0.3)
	_beige = mat(Color(0.72, 0.66, 0.52), 0.7)
	_rust = pbr("rust", Vector3(1, 1, 1) / 1.5, true, Color(0.8, 0.7, 0.6), 1.0)
	_cable = mat(Color(0.04, 0.04, 0.04), 0.7)
	_tile = tex_mat(_tile_tex(), Vector3(1, 1, 1) / 1.2, 0.3, true)
	_white = mat(Color(0.78, 0.8, 0.78), 0.6)
	_chamber()
	_stairwell_a()
	_sublevel_1()
	_stairwell_b()
	_sublevel_2()
	_people()
	_batch(self, 10.0, true)


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	# Under the mountain: no sky, concrete-coloured dark, a light fog so the
	# long corridors still read to the far end.
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.0, 0.0, 0.0)
	env.ambient_light_color = Color(0.32, 0.38, 0.32)
	env.ambient_light_energy = 0.26
	env.fog_light_color = Color(0.03, 0.04, 0.03)
	env.fog_density = 0.007
	env.fog_sky_affect = 0.0
	env.glow_bloom = 0.05
	env.glow_intensity = 0.8
	env.tonemap_exposure = 1.15
	sun.light_energy = 0.0
	sun.shadow_enabled = false


func hifi(env: Environment, _sun: DirectionalLight3D) -> void:
	env.volumetric_fog_density *= 0.5
	if obs_light:
		obs_light.shadow_enabled = true


func ambience() -> void:
	# the facility hums at 50 Hz (the synth hum is 55: pitch it down)
	_hum = main.loop("hum", -12.0)
	(_hum as AudioStreamPlayer).pitch_scale = 50.0 / 55.0
	main.loop("static", -30.0, OBS_DESK + Vector3(0, 1.0, 0), 1.5, 9.0)
	main.loop("pressure", -28.0, MIRROR, 2.0, 12.0)
	main.loop("room", -26.0, Vector3(13.0, Y2 + 1.0, -1.5), 2.0, 14.0)


# ------------------------------------------------------------------ helpers

func _wall(size: Vector3, pos: Vector3, m: Material) -> MeshInstance3D:
	return box(size, pos, m, true)


## Four walls round x0..x1, z0..z1 at floor y, height h, with doorways
## [side ("n" z0, "s" z1, "e" x1, "w" x0), at (x or z), width] 2.1 high
## with a lintel; floor and ceiling too. `skip` leaves out walls another
## room already built (shared walls would z-fight).
func _room(x0: float, x1: float, z0: float, z1: float, y: float, h: float, wm: Material, fm: Material, cm: Material, doors: Array = [], skip: Array = [], t := 0.3) -> void:
	floor_quad(Vector2(x1 - x0, z1 - z0), Vector3((x0 + x1) / 2.0, y + 0.002, (z0 + z1) / 2.0), 0.0, fm)
	solid_box(Vector3(x1 - x0 + 1.0, 0.4, z1 - z0 + 1.0), Vector3((x0 + x1) / 2.0, y - 0.2, (z0 + z1) / 2.0))
	if cm:
		floor_quad(Vector2(x1 - x0, z1 - z0), Vector3((x0 + x1) / 2.0, y + h, (z0 + z1) / 2.0), 0.0, cm, self, false)
	for side: String in ["n", "s", "e", "w"]:
		if side in skip:
			continue
		var gaps := []
		for d in doors:
			if d[0] == side:
				gaps.append([float(d[1]), float(d[2])])
		var a := x0 if side in ["n", "s"] else z0
		var b := x1 if side in ["n", "s"] else z1
		gaps.sort_custom(func(p, q): return p[0] < q[0])
		var cur := a
		for g in gaps:
			_wall_seg(side, cur, g[0] - g[1] / 2.0, y, h, x0, x1, z0, z1, wm, t)
			_wall_seg(side, g[0] - g[1] / 2.0, g[0] + g[1] / 2.0, y + 2.1, h - 2.1, x0, x1, z0, z1, wm, t)
			cur = g[0] + g[1] / 2.0
		_wall_seg(side, cur, b, y, h, x0, x1, z0, z1, wm, t)


func _wall_seg(side: String, a: float, b: float, y: float, h: float, x0: float, x1: float, z0: float, z1: float, wm: Material, t: float) -> void:
	if b - a < 0.02 or h < 0.02:
		return
	var mid := (a + b) / 2.0
	var ln := b - a
	match side:
		"n":
			_wall(Vector3(ln, h, t), Vector3(mid, y + h / 2.0, z0), wm)
		"s":
			_wall(Vector3(ln, h, t), Vector3(mid, y + h / 2.0, z1), wm)
		"e":
			_wall(Vector3(t, h, ln), Vector3(x1, y + h / 2.0, mid), wm)
		"w":
			_wall(Vector3(t, h, ln), Vector3(x0, y + h / 2.0, mid), wm)


## A flight of stairs from `top` (the upper floor's edge, centre of the
## flight) going `d` (unit, horizontal) and down `rise` over `run`.
func _flight(top: Vector3, d: Vector3, rise: float, run: float, w: float, m: Material) -> void:
	var n := int(ceil(rise / 0.18))
	var sr := rise / n
	var sl := run / n
	for i in n:
		var p := top + d * ((i + 0.5) * sl) - Vector3(0, (i + 1) * sr, 0)
		var bx := box(Vector3(w, sr, sl) if absf(d.z) > 0.5 else Vector3(sl, sr, w), p + Vector3(0, sr / 2.0, 0), m)
		bx.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	# a slab under the treads, and the collider on its slope
	var ln := sqrt(rise * rise + run * run)
	var th := atan2(rise, run)
	var mid := top + d * (run / 2.0) - Vector3(0, rise / 2.0, 0)
	var size := Vector3(w, 0.3, ln) if absf(d.z) > 0.5 else Vector3(ln, 0.3, w)
	var rot := Vector3(d.z * th, 0, 0) if absf(d.z) > 0.5 else Vector3(0, 0, -d.x * th)
	var slab := box(size, mid - Vector3(0, 0.26, 0), m)
	slab.rotation = rot
	var col := solid_box(size, mid - Vector3(0, 0.1, 0))
	col.rotation = rot
	# a handrail
	var rail := mat(Color(0.25, 0.25, 0.27), 0.5, 0.6)
	var side := Vector3(-d.z, 0, d.x) * (w / 2.0 - 0.1)
	stick(top + side + Vector3(0, 0.95, 0), top + side + d * run + Vector3(0, 0.95 - rise, 0), 0.02, rail)
	for k in range(0, 5):
		var q := top + side + d * (run * k / 4.0) - Vector3(0, rise * k / 4.0, 0)
		stick(q + Vector3(0, 0.05, 0), q + Vector3(0, 0.95, 0), 0.012, rail)


## A fluorescent tube on the ceiling: the kit light, a glow strip, a real
## light. Steady dim (photosensitivity); `stutter` ones dip now and then.
func _fluor(p: Vector3, rot_y := 0.0, energy := 1.0, stutter := false, c := Color(0.8, 1.0, 0.82)) -> OmniLight3D:
	prop("mounted_fluorescent_lights", p - Vector3(0, 0.06, 0), rot_y, 1.0, false)
	var g := box(Vector3(0.9, 0.025, 0.05), p - Vector3(0, 0.05, 0), glow(Color(0.85, 1.0, 0.8), 1.6, true))
	g.rotation.y = rot_y
	var l := light(p - Vector3(0, 0.35, 0), c, energy, 7.5)
	l.omni_attenuation = 1.1
	if stutter:
		no_batch.append(g)
		fluor_lights.append([l, energy, rng.randf() * 10.0, g])
	return l


## A cable run along a wall at height y, with drops.
func _cables(a: Vector3, b: Vector3, n := 3) -> void:
	for i in n:
		var off := Vector3(0, -i * 0.07, 0)
		stick(a + off, b + off, 0.018, _cable)
	var cnt := int(a.distance_to(b) / 3.0)
	for i in cnt:
		var p := a.lerp(b, (i + 0.5) / float(cnt))
		stick(p, p - Vector3(0, rng.randf_range(0.3, 0.9), 0), 0.012, _cable)


## The eye, scratched into a wall: two rings and the gap, as a sprite that
## is always there (it was etched, not seen).
func _etched(p: Vector3, rot_y: float, id: String, desc: String, px := 0.004) -> Area3D:
	var g := _glyph_on(p, rot_y, px, id, false, true, desc, false, Color(0.55, 0.5, 0.42))
	return g


## A stencilled sign painted on a wall (not neon).
func _sign(text: String, p: Vector3, rot_y: float, px := 0.003, c := Color(0.78, 0.82, 0.66)) -> Label3D:
	return label(text, p, rot_y, px, c, self, false)


## A beige Ionware box: tower, CRT, keyboard. Facing -Z unless rotated.
## Returns the screen quad.
func _ionware(p: Vector3, rot_y: float, screen: Material) -> MeshInstance3D:
	var b := Basis(Vector3.UP, rot_y)
	box(Vector3(0.42, 0.36, 0.4), p + b * Vector3(0, 0.18, 0.05), _beige).rotation.y = rot_y
	box(Vector3(0.38, 0.32, 0.36), p + b * Vector3(0, 0.54, 0.05), _beige).rotation.y = rot_y
	var sq := quad(Vector2(0.29, 0.22), p + b * Vector3(0, 0.55, -0.135), rot_y + PI, screen)
	box(Vector3(0.42, 0.025, 0.15), p + b * Vector3(0, 0.012, -0.32), mat(Color(0.6, 0.56, 0.48), 0.8)).rotation.y = rot_y
	return sq


## A steel door panel in a doorway (closed), with a push-bar or a wheel.
func _door_panel(p: Vector3, along_x: bool, w := 1.0) -> MeshInstance3D:
	var d := box(Vector3(w, 2.08, 0.07) if along_x else Vector3(0.07, 2.08, w), p + Vector3(0, 1.04, 0), mat(Color(0.3, 0.33, 0.3), 0.55, 0.6))
	no_batch.append(d)
	return d


# ------------------------------------------------------------------ textures

## Army-green brick: courses of brick with a darker mortar, the paint
## worn through to red in patches.
func _brick_tex(c: Color) -> ImageTexture:
	var key := "brick%s" % c
	if _mat_cache.has(key):
		return _mat_cache[key]
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
			var col := c * (0.9 + r.randf() * 0.2)
			if by < 2 or bx < 2:
				col = mortar
			elif r.randf() < 0.02:
				col = col.lerp(Color(0.45, 0.22, 0.16), 0.6)
			img.set_pixel(x, y, col)
	img.generate_mipmaps()
	var t := ImageTexture.create_from_image(img)
	_mat_cache[key] = t
	return t


## White tile with grey grout, grimed toward the bottom.
func _tile_tex() -> ImageTexture:
	var r := RandomNumberGenerator.new()
	r.seed = 9
	var n := 64
	var img := Image.create(n, n, false, Image.FORMAT_RGB8)
	for y in n:
		for x in n:
			var col := Color(0.72, 0.74, 0.7) * (0.92 + r.randf() * 0.1)
			if x % 16 == 0 or y % 16 == 0:
				col = Color(0.35, 0.36, 0.33)
			img.set_pixel(x, y, col)
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


## The American flag, faded, the fly end torn to ribbons.
func _flag_tex() -> ImageTexture:
	var r := RandomNumberGenerator.new()
	r.seed = 1776
	var w := 128
	var h := 68
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	var red := Color(0.55, 0.2, 0.18)
	var white := Color(0.72, 0.68, 0.6)
	var blue := Color(0.18, 0.2, 0.34)
	var tears := []
	for i in 9:
		tears.append(r.randi_range(100, 126))
	for y in h:
		for x in w:
			var stripe := int(y * 13.0 / h)
			var col := red if stripe % 2 == 0 else white
			if x < 52 and y < 37:
				col = blue
				if x % 5 == 2 and y % 5 == 2:
					col = white
			col = col * (0.85 + r.randf() * 0.2)
			var a := 1.0
			var band := int(y * 9.0 / h)
			if x > int(tears[band]) or (x > 96 and r.randf() < 0.08):
				a = 0.0
			if y > 60 and r.randf() < (y - 60) * 0.06:
				a = 0.0
			img.set_pixel(x, y, Color(col.r, col.g, col.b, a))
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


## A whiteboard smudged with decades-old marker: rings rubbed out, PHASE 3.
func _whiteboard_tex() -> ImageTexture:
	var r := RandomNumberGenerator.new()
	r.seed = 2019
	var w := 128
	var h := 80
	var img := Image.create(w, h, false, Image.FORMAT_RGB8)
	img.fill(Color(0.82, 0.82, 0.78))
	for i in 30:
		var x := r.randi_range(0, w - 1)
		var y := r.randi_range(0, h - 1)
		var ln := r.randi_range(6, 40)
		for k in ln:
			img.set_pixel(clampi(x + k, 0, w - 1), y, Color(0.6, 0.6, 0.62))
	for rad: float in [14.0, 22.0]:
		for i in 120:
			var a := i * TAU / 120.0
			if rad > 20.0 and a > 1.2 and a < 1.7:
				continue
			var p := Vector2(44 + cos(a) * rad, 36 + sin(a) * rad * 0.8)
			img.set_pixel(clampi(int(p.x), 0, w - 1), clampi(int(p.y), 0, h - 1), Color(0.45, 0.45, 0.5))
	# "P3" in big strokes
	for seg: Array in [[80, 20, 80, 50], [80, 20, 90, 20], [80, 35, 90, 35], [90, 20, 90, 35],
			[100, 20, 112, 20], [112, 20, 112, 50], [100, 35, 112, 35], [100, 50, 112, 50]]:
		var x0: int = seg[0]
		var y0: int = seg[1]
		var x1: int = seg[2]
		var y1: int = seg[3]
		var steps := maxi(absi(x1 - x0), absi(y1 - y0))
		for k in steps + 1:
			var t := float(k) / maxi(1, steps)
			img.set_pixel(int(lerpf(x0, x1, t)), int(lerpf(y0, y1, t)), Color(0.2, 0.12, 0.3))
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


## A brown stain on a floor: a soft blot with a darker rim.
func _stain_tex() -> ImageTexture:
	var r := RandomNumberGenerator.new()
	r.seed = 41
	var n := 64
	var img := Image.create(n, n, false, Image.FORMAT_RGBA8)
	for y in n:
		for x in n:
			var d := Vector2(x - 32, (y - 32) * 1.3).length() / 30.0
			d += (r.randf() - 0.5) * 0.12
			var a := clampf(1.0 - d, 0.0, 1.0)
			a = minf(1.0, a * 2.0) * (0.75 if d < 0.7 else 1.0)
			img.set_pixel(x, y, Color(0.16, 0.07, 0.04, a * 0.9))
	return ImageTexture.create_from_image(img)



# ------------------------------------------------------------------ the entrance hall (ch. 10)

## The room on the far side of the glass: cold metal floor, the obsidian
## eye on the north wall, old Ionware monitors, the flag, corroded steel
## beams, fluorescents embedded in concrete "like a buried heartbeat".
func _chamber() -> void:
	var plate := pbr("rust", Vector3(1, 1, 1) / 2.0, true, Color(0.5, 0.5, 0.52), 0.6)
	_room(-7.0, 7.0, -6.0, 6.0, Y0, H0, _conc, plate, _ceil, [["n", 5.6, 2.2]])
	# the eye: scorched rings and the almond round the pupil, the pupil a
	# matte black slab now, the silver gone
	var scorch := mat(Color(0.02, 0.02, 0.02), 0.9)
	var eye := Node3D.new()
	eye.position = Vector3(0, Y0 + 2.0, -5.83)
	add_child(eye)
	for r: float in [1.9, 2.4]:
		var tm := TorusMesh.new()
		tm.inner_radius = r - 0.07
		tm.outer_radius = r
		tm.rings = 36
		tm.ring_segments = 6
		var rm := mesh(tm, Vector3.ZERO, scorch, eye)
		rm.rotation.x = PI / 2.0
	for sd: float in [-1.0, 1.0]:
		for i in 14:
			var t0 := (i / 14.0) * PI
			var t1 := ((i + 1) / 14.0) * PI
			stick(Vector3(-3.6 * cos(t0), sd * 1.7 * sin(t0), 0), Vector3(-3.6 * cos(t1), sd * 1.7 * sin(t1), 0), 0.06, scorch, eye)
	var dm := CylinderMesh.new()
	dm.top_radius = 1.6
	dm.bottom_radius = 1.6
	dm.height = 0.06
	dm.radial_segments = 32
	dm.rings = 1
	var slab := mesh(dm, MIRROR, mat(Color(0.012, 0.012, 0.014), 0.35, 0.1))
	slab.rotation.x = PI / 2.0
	var rim := TorusMesh.new()
	rim.inner_radius = 1.58
	rim.outer_radius = 1.7
	rim.rings = 32
	rim.ring_segments = 6
	mesh(rim, MIRROR + Vector3(0, 0, 0.02), mat(Color(0.3, 0.3, 0.32), 0.5, 0.8)).rotation.x = PI / 2.0
	interactable("mirror", L("build", "mirror_prompt"), MIRROR, Vector3(3.4, 3.4, 0.4), L("build", "mirror_scan"), true)
	# where he lay: a dark smear of sweat on the plate
	floor_quad(Vector2(0.9, 1.9), Vector3(-0.6, Y0 + 0.006, -1.4), 0.2, mat(Color(0.2, 0.2, 0.2), 0.3, 0.3))
	# steel beams across the ceiling, corroded, and the fluorescents between
	for x: float in [-4.5, -1.5, 1.5, 4.5]:
		box(Vector3(0.3, 0.4, 12.0), Vector3(x, Y0 + H0 - 0.2, 0), _rust)
	for x: float in [-3.0, 3.0]:
		for z: float in [-3.0, 2.0]:
			_fluor(Vector3(x, Y0 + H0, z), PI / 2.0, 0.9, x < 0.0 and z < 0.0)
	# the flag on the east wall
	var fm := decal_mat(_flag_tex(), Color(1, 1, 1), 0.9)
	fm.cull_mode = BaseMaterial3D.CULL_DISABLED
	var fq := quad(Vector2(2.6, 1.4), Vector3(6.83, Y0 + 2.4, 1.0), -PI / 2.0, fm)
	fq.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	fq.rotation.z = 0.03
	stick(Vector3(6.8, Y0 + 3.15, -0.4), Vector3(6.8, Y0 + 3.15, 2.4), 0.015, _metal)
	interactable("flag", L("build", "flag_prompt"), Vector3(6.75, Y0 + 2.4, 1.0), Vector3(0.2, 1.4, 2.6), L("build", "flag_scan"), false)
	light(Vector3(5.5, Y0 + 2.6, 1.0), Color(1.0, 0.9, 0.75), 0.6, 4.0)
	# the monitors along the west wall: a bank of CRTs on a steel rack,
	# half of them lit with a test pattern, cables up the wall
	var screen_dead := mat(Color(0.05, 0.06, 0.06), 0.2, 0.3)
	var screen_test := glow(Color(0.25, 0.6, 0.5), 0.7)
	for row in 2:
		box(Vector3(0.7, 0.04, 5.2), Vector3(-6.3, Y0 + 0.5 + row * 0.9, -2.0), _metal)
		for i in 6:
			var p := Vector3(-6.3, Y0 + 0.75 + row * 0.9, -4.3 + i * 0.9)
			box(Vector3(0.55, 0.45, 0.5), p, _beige)
			var lit := (i + row) % 3 != 1
			var sq := quad(Vector2(0.36, 0.28), p + Vector3(0.28, 0.0, 0), PI / 2.0, screen_test if lit else screen_dead)
			if lit and i == 2:
				flickers.append(sq)
				no_batch.append(sq)
	for i in 4:
		box(Vector3(0.1, 0.6, 0.1), Vector3(-6.6, Y0 + 0.3, -4.6 + i * 1.6), _metal)
	_cables(Vector3(-6.75, Y0 + 2.4, -5.0), Vector3(-6.75, Y0 + 2.4, 1.0), 4)
	light(Vector3(-5.4, Y0 + 1.4, -2.0), Color(0.3, 0.8, 0.6), 0.9, 5.0)
	interactable("crt", L("build", "crt_prompt"), Vector3(-6.3, Y0 + 1.2, -2.0), Vector3(0.8, 1.6, 5.4), L("build", "crt_scan"), true)
	# the rusted console against the south wall, the one Lynx kneels by,
	# terminal lights blinking in patterns
	prop("server_rack", Vector3(-4.6, Y0, 5.3), PI, 1.0, true)
	prop("server_rack", Vector3(-2.7, Y0, 5.3), PI, 1.0, true)
	for i in 10:
		var bl := box(Vector3(0.03, 0.03, 0.02), Vector3(-5.3 + i * 0.3, Y0 + 1.2 + (i % 3) * 0.3, 4.78), glow(Color(1.0, 0.3, 0.1) if i % 4 == 0 else Color(0.3, 1.0, 0.4), 2.0))
		if i % 2 == 0:
			blinkers.append(bl)
	interactable("console", L("build", "console_prompt"), Vector3(-3.7, Y0 + 1.0, 5.0), Vector3(4.0, 2.0, 1.2), L("build", "console_scan"), false)
	_cables(Vector3(-5.6, Y0 + 2.6, 5.8), Vector3(-1.6, Y0 + 2.6, 5.8), 5)
	prop("fuse_panel", Vector3(2.5, Y0 + 1.1, 5.82), PI, 1.0, false)
	prop("cardboard_box_01", Vector3(4.6, Y0 + 0.18, 4.8), 0.4, 1.0, true)
	prop("cardboard_box_01", Vector3(5.1, Y0 + 0.18, 5.3), 1.1, 1.0, true)
	prop("cardboard_box_01", Vector3(4.85, Y0 + 0.52, 5.0), 2.0, 1.0, false)
	prop("old_gas_mask", Vector3(6.75, Y0 + 1.9, 4.0), -PI / 2.0, 1.0, false)
	prop("metal_trash_can", Vector3(-6.3, Y0, 4.2), 0.0, 1.0, true)
	prop("security_camera_01", Vector3(-6.6, Y0 + 3.6, -5.6), PI * 0.75, 1.0, false)
	# eye symbols: scratched into the concrete by the doorway
	_etched(Vector3(3.6, Y0 + 1.5, -5.83), 0.0, "g_hall", "Scratched into the concrete beside the doorway, at eye height: two rings and the gap, the outer one scored so many times the groove was smooth.")
	# the doorway: a steel frame, a sign over it, the green light beyond
	box(Vector3(2.6, 0.15, 0.4), Vector3(5.6, Y0 + 2.2, -6.0), _metal)
	_sign("SUBLEVEL 1  ->", Vector3(5.6, Y0 + 2.5, -5.83), 0.0, 0.003)
	light(Vector3(5.6, Y0 + 1.8, -8.0), PSYON_GREEN, 0.7, 6.0)
	interactable("doorway", L("build", "doorway_prompt"), DOORWAY + Vector3(0, 1.1, 0), Vector3(2.2, 2.1, 0.5), "", false)


## Stairwell A: a concrete shaft north and down from the hall.
func _stairwell_a() -> void:
	_flight(STAIR_A_TOP, Vector3(0, 0, -1), Y0 - Y1, STAIR_A_RUN, 2.2, mat(Color(0.42, 0.42, 0.4), 0.85))
	var ln := 7.7
	for sd: float in [-1.0, 1.0]:
		_wall(Vector3(0.3, Y0 + H0 - Y1, ln), Vector3(5.6 + sd * 1.25, (Y0 + H0 + Y1) / 2.0, -6.0 - ln / 2.0), _green)
	box(Vector3(2.8, 0.3, ln), Vector3(5.6, Y0 + H0 + 0.15, -6.0 - ln / 2.0), _ceil)
	floor_quad(Vector2(2.2, 0.6), Vector3(5.6, Y1 + 0.003, -13.45), 0.0, _floor1)
	_fluor(Vector3(5.6, Y0 + 2.2, -8.5), PI / 2.0, 0.7, true)
	_fluor(Vector3(5.6, Y1 + H1, -12.6), PI / 2.0, 0.8)
	_cables(Vector3(6.7, Y0 + 1.0, -6.4), Vector3(6.7, Y1 + 1.8, -13.4), 2)
	_etched(Vector3(4.47, Y1 + 2.4, -10.5), PI / 2.0, "g_stairs", "On the stairwell wall, at the height of a hand trailing down the rail: the rings, drawn over and over in the same place by a lot of hands.")


# ------------------------------------------------------------------ sublevel 1 (ch. 11-12)

## The hallway of faded green with the rooms off it: the office, the
## sleeping quarters, the gym, the sealed doors; the utility room and the
## service passage behind them, the second way to the west stairwell.
func _sublevel_1() -> void:
	var h := H1
	_room(-33.4, 7.0, HZ - 1.3, HZ + 1.3, Y1, h, _green, _floor1, _ceil,
		[["s", 5.6, 2.2], ["s", 0.0, 1.0], ["s", -9.0, 1.0], ["s", -20.0, 1.4], ["s", -32.0, 2.4],
		["n", 1.0, 1.0], ["n", -32.0, 1.0]])
	# a dado of darker green and a steel kick plate down both walls
	for z: float in [HZ - 1.14, HZ + 1.14]:
		box(Vector3(40.0, 0.06, 0.03), Vector3(-13.0, Y1 + 1.1, z), mat(Color(0.2, 0.3, 0.22), 0.9))
		box(Vector3(40.0, 0.12, 0.02), Vector3(-13.0, Y1 + 0.06, z), _metal)
	_cables(Vector3(6.5, Y1 + 2.6, HZ - 1.1), Vector3(-32.5, Y1 + 2.6, HZ - 1.1), 3)
	for i in 8:
		_fluor(Vector3(3.0 - i * 5.0, Y1 + h, HZ), 0.0, 0.8, i % 3 == 1)
	# signs and clutter down the hall
	prop("security_camera_01", Vector3(2.0, Y1 + 2.7, HZ - 1.05), PI, 1.0, false)
	prop("security_camera_01", Vector3(-30.0, Y1 + 2.7, HZ + 1.05), 0.0, 1.0, false)
	prop("utility_box_01", Vector3(-14.0, Y1, HZ - 0.95), 0.0, 1.0, true)
	prop("Barrel_01", Vector3(-27.5, Y1, HZ + 0.9), 0.3, 1.0, true)
	prop("plastic_crate_03", Vector3(-28.3, Y1, HZ - 0.95), 0.8, 1.0, true)
	prop("plastic_crate_03", Vector3(-28.3, Y1 + 0.25, HZ - 0.95), 0.5, 1.0, false)
	prop("metal_trash_can", Vector3(-4.5, Y1, HZ - 0.95), 0.0, 1.0, true)
	prop("cardboard_box_01", Vector3(-23.0, Y1 + 0.18, HZ + 0.95), 0.3, 1.0, true)
	for i in 7:
		var p := Vector3(-3.0 - i * 4.1, Y1 + 0.004 + i * 0.001, HZ + rng.randf_range(-0.9, 0.9))
		floor_quad(Vector2(0.21, 0.29), p, rng.randf() * TAU, tex_mat(Tex.paper(300 + i), Vector3.ONE, 0.9))
	_sign("SUBLEVEL ONE\nADMINISTRATION", Vector3(4.6, Y1 + 1.8, HZ - 1.13), 0.0, 0.003)
	interactable("sign1", L("build", "sign1_prompt"), Vector3(4.6, Y1 + 1.8, HZ - 1.1), Vector3(1.0, 0.5, 0.1), L("build", "sign1_scan"), false)
	_sign("OFFICE 1-04", Vector3(0.0, Y1 + 2.3, HZ + 1.13), PI, 0.0025)
	_sign("QUARTERS", Vector3(-9.0, Y1 + 2.3, HZ + 1.13), PI, 0.0025)
	_sign("PT / REHAB", Vector3(-20.0, Y1 + 2.3, HZ + 1.13), PI, 0.0025)
	_sign("<-  SUBLEVEL 2", Vector3(-26.0, Y1 + 1.9, HZ + 1.13), PI, 0.003, Color(0.85, 0.75, 0.4))
	# the sealed doors on the north wall: heavy blast doors that do not open
	for x: float in [-8.0, -18.0, -25.0]:
		box(Vector3(1.3, 2.3, 0.1), Vector3(x, Y1 + 1.15, HZ - 1.12), mat(Color(0.28, 0.3, 0.3), 0.5, 0.7))
		box(Vector3(1.5, 0.12, 0.14), Vector3(x, Y1 + 2.36, HZ - 1.1), _metal)
		for yy: float in [0.6, 1.7]:
			box(Vector3(0.9, 0.08, 0.06), Vector3(x, Y1 + yy, HZ - 1.05), _rust)
		cyl(0.12, 0.12, 0.08, Vector3(x + 0.4, Y1 + 1.15, HZ - 1.04), _rust, 10).rotation.x = PI / 2.0
		interactable("sealed", L("build", "sealed_prompt"), Vector3(x, Y1 + 1.15, HZ - 1.1), Vector3(1.3, 2.3, 0.2), L("build", "sealed_scan"), false)
	_etched(Vector3(-13.0, Y1 + 1.6, HZ - 1.14), 0.0, "g_hall1", "Burned into the paint between two doors, the rings, the gap toward the second stairwell. Fresh soot still came off on my thumb.")
	_office()
	_quarters()
	_gym()
	_utility_and_passage()
	_stair_b_door()


## "A whiteboard still smudged with marker from decades ago, five ancient
## Ionware desktops lined against the far wall."
func _office() -> void:
	var x0 := -5.0
	var x1 := 3.0
	var z0 := HZ + 1.3
	var z1 := -7.5
	_room(x0, x1, z0, z1, Y1, H1, _green, pbr("carpet", Vector3(1, 1, 1) / 1.5, true, Color(0.5, 0.48, 0.42), 1.0), _ceil, [], ["n"])
	# the wooden door, open inward
	var wood := tex_mat(Tex.wood(), Vector3(1, 2, 1), 0.7)
	var door := box(Vector3(0.95, 2.05, 0.05), Vector3(0.5 - 0.47 * cos(1.2), Y1 + 1.025, z0 + 0.47 * sin(1.2)), wood)
	door.rotation.y = 1.2
	interactable("office_door", L("build", "office_door_prompt"), Vector3(0.0, Y1 + 1.1, z0), Vector3(1.0, 2.1, 0.4), "", false)
	# three steel desks against the far (south) wall, five beige Ionware
	# boxes on them: the one Lynx dusted is the first, on the west
	var crt_dead := mat(Color(0.05, 0.06, 0.06), 0.2, 0.3)
	term_screen_m = newmat(Color(0.05, 0.06, 0.06), 0.2, 0.3)
	var spots := [-4.1, -2.9, -0.95, 0.25, 1.95]
	for dx: float in [-3.5, -0.35, 2.0]:
		prop("metal_office_desk", Vector3(dx, Y1, z1 - 0.65), 0.0, 0.85, true)
	for i in 5:
		var dp := Vector3(spots[i], Y1 + 0.67, z1 - 0.5)
		var sq := _ionware(dp, 0.0, term_screen_m if i == 0 else crt_dead)
		if i == 0:
			term_screen = sq
			no_batch.append(sq)
			term_light = light(dp + Vector3(0, 0.6, -0.6), Color(0.5, 0.9, 0.7), 0.0, 2.4, false)
			interactable("terminal", L("build", "terminal_prompt"), dp + Vector3(0, 0.4, 0), Vector3(0.7, 0.9, 0.7), L("build", "terminal_scan"), false)
		else:
			interactable("desktop", L("build", "desktop_prompt"), dp + Vector3(0, 0.4, 0), Vector3(0.7, 0.9, 0.7), L("build", "desktop_scan"), false)
	# an office chair at the first desk
	var cm := mat(Color(0.12, 0.12, 0.13), 0.6, 0.3)
	var chp := OFFICE_CHAIR
	cyl(0.04, 0.04, 0.45, chp + Vector3(0, 0.25, 0), _metal, 6)
	box(Vector3(0.46, 0.08, 0.46), chp + Vector3(0, 0.5, 0), cm)
	box(Vector3(0.44, 0.5, 0.06), chp + Vector3(0, 0.8, -0.22), cm)
	for i in 5:
		var a := i * TAU / 5.0
		stick(chp + Vector3(0, 0.04, 0), chp + Vector3(cos(a) * 0.3, 0.03, sin(a) * 0.3), 0.015, _metal)
	# the whiteboard on the west wall, a dead wall clock, a cork board
	var wb := quad(Vector2(2.2, 1.3), Vector3(x0 + 0.17, Y1 + 1.7, -10.5), PI / 2.0, tex_mat(_whiteboard_tex(), Vector3.ONE, 0.5))
	wb.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	box(Vector3(0.04, 1.36, 2.26), Vector3(x0 + 0.15, Y1 + 1.7, -10.5), _metal)
	interactable("whiteboard", L("build", "whiteboard_prompt"), Vector3(x0 + 0.2, Y1 + 1.7, -10.5), Vector3(0.2, 1.3, 2.2), L("build", "whiteboard_scan"), false)
	cyl(0.16, 0.16, 0.03, Vector3(x1 - 0.17, Y1 + 2.4, -10.0), mat(Color(0.9, 0.9, 0.85), 0.6), 16).rotation.z = PI / 2.0
	box(Vector3(0.03, 1.0, 1.4), Vector3(x1 - 0.17, Y1 + 1.6, -12.0), mat(Color(0.55, 0.42, 0.3), 0.95))
	for i in 7:
		var pp := Vector3(x1 - 0.19, Y1 + 1.3 + rng.randf_range(0.0, 0.6), -12.6 + rng.randf_range(0.0, 1.2))
		var pq := quad(Vector2(0.21, 0.29) * 0.7, pp, -PI / 2.0, tex_mat(Tex.paper(400 + i), Vector3.ONE, 0.9))
		pq.rotation.z = rng.randf_range(-0.2, 0.2)
	_etched(Vector3(x1 - 0.19, Y1 + 1.9, -12.2), -PI / 2.0, "g_office", "Drawn on an old sheet of printer paper pinned among the others: the eye, in biro, the rings gone over and over until the paper had torn.")
	# the flag again, smaller, on a desk stand; shelves of files, boxes, the
	# fluorescent, a cable snake to the desks
	stick(Vector3(2.7, Y1 + 0.67, -8.2), Vector3(2.7, Y1 + 1.1, -8.2), 0.006, _metal)
	var fm := decal_mat(_flag_tex(), Color(1, 1, 1), 0.9)
	fm.cull_mode = BaseMaterial3D.CULL_DISABLED
	quad(Vector2(0.26, 0.14), Vector3(2.83, Y1 + 1.03, -8.2), 0.0, fm)
	prop("steel_frame_shelves_01", Vector3(x1 - 0.35, Y1, -12.3), -PI / 2.0, 1.0, true)
	for i in 4:
		prop("cardboard_box_01", Vector3(x1 - 0.35, Y1 + 0.55 + (i % 2) * 0.62, -12.6 + (i / 2) * 0.6), rng.randf() * 0.4, 0.9, false)
	prop("cardboard_box_01", Vector3(x0 + 0.6, Y1 + 0.18, HZ + 2.0), 0.3, 1.0, true)
	prop("cardboard_box_01", Vector3(x0 + 1.0, Y1 + 0.52, HZ + 2.0), 0.9, 1.0, false)
	_fluor(Vector3(-1.0, Y1 + H1, -10.5), 0.0, 0.9)
	_cables(Vector3(x0 + 0.2, Y1 + 0.05, z1 - 1.0), Vector3(x1 - 0.2, Y1 + 0.05, z1 - 1.0), 2)


## "One looked like a recently occupied sleeping quarter, the faint scent
## of stale air and something metallic." The sticks by the bunk.
func _quarters() -> void:
	var x0 := -13.0
	var x1 := -7.0
	var z0 := HZ + 1.3
	var z1 := -7.5
	_room(x0, x1, z0, z1, Y1, H1, _green, _floor1, _ceil, [], ["n"])
	# two bunks, one slept in, a locker, a bucket
	var frame := mat(Color(0.3, 0.32, 0.3), 0.5, 0.6)
	var sheet := pbr("fabric", Vector3(1, 1, 1), true, Color(0.5, 0.52, 0.45), 1.0)
	for i in 2:
		var bp := Vector3(x0 + 0.7 + i * 4.6, Y1, -9.5)
		for yy: float in [0.4, 1.4]:
			box(Vector3(1.0, 0.1, 2.0), bp + Vector3(0, yy, 0), frame, true)
			box(Vector3(0.9, 0.12, 1.9), bp + Vector3(0, yy + 0.11, 0), sheet)
		for sx: float in [-0.45, 0.45]:
			for sz: float in [-0.95, 0.95]:
				box(Vector3(0.06, 1.9, 0.06), bp + Vector3(sx, 0.95, sz), frame)
		if i == 0:
			# the blanket thrown back, a pillow with a head's dent
			var bl := box(Vector3(0.7, 0.08, 1.1), bp + Vector3(0.1, 0.56, 0.3), pbr("fabric", Vector3(1, 1, 1), true, Color(0.3, 0.32, 0.3), 1.0))
			bl.rotation.z = 0.25
			box(Vector3(0.5, 0.1, 0.3), bp + Vector3(0, 0.55, -0.75), mat(Color(0.6, 0.6, 0.55), 0.95))
			interactable("quarters", L("build", "quarters_prompt"), bp + Vector3(0, 0.5, 0), Vector3(1.1, 0.4, 2.0), L("build", "quarters_scan"), false)
	# the offering on the floor between the bunks: sticks in two rings, the
	# gap toward the door
	offering_n = Node3D.new()
	offering_n.position = Vector3(-10.0, Y1 + 0.02, -10.5)
	add_child(offering_n)
	var stick_m := mat(Color(0.35, 0.28, 0.2), 0.9)
	for r: float in [0.35, 0.6]:
		var n := 9 if r < 0.5 else 12
		for i in n:
			var a0 := i * TAU / n
			var a1 := (i + 1) * TAU / n
			if r > 0.5 and i == 9:
				continue
			stick(Vector3(cos(a0) * r, 0, sin(a0) * r), Vector3(cos(a1) * r, 0, sin(a1) * r), 0.012, stick_m, offering_n)
	interactable("offering", L("build", "offering_prompt"), Vector3(-10.0, Y1 + 0.15, -10.5), Vector3(1.4, 0.3, 1.4), L("build", "offering_scan"), false)
	_etched(Vector3(-10.0, Y1 + 2.0, z1 - 0.17), PI, "g_quarters", "Over the bunks, drawn in something brown on the green paint: the eye, and under it a tally. Forty-one strokes.")
	prop("utility_box_02", Vector3(x1 - 0.6, Y1, HZ + 2.0), -PI / 2.0, 1.0, true)
	box(Vector3(0.6, 1.8, 0.5), Vector3(x0 + 0.5, Y1 + 0.9, HZ + 2.0), _metal, true)
	cyl(0.16, 0.14, 0.3, Vector3(x1 - 0.5, Y1 + 0.15, -8.2), _metal, 10)
	prop("old_gas_mask", Vector3(x0 + 0.2, Y1 + 1.7, -11.6), PI / 2.0, 1.0, false)
	_fluor(Vector3(-10.0, Y1 + H1, -11.0), 0.0, 0.6, true)
	light(Vector3(-10.0, Y1 + 0.3, -10.5), Color(0.9, 0.5, 0.3), 0.25, 2.5)


## "Some kind of makeshift gym or exercise area, equipment rusted and
## abandoned." Wire wound round the pull-up bar.
func _gym() -> void:
	var x0 := -25.0
	var x1 := -15.0
	var z0 := HZ + 1.3
	var z1 := -7.5
	_room(x0, x1, z0, z1, Y1, H1, _green, pbr("concrete", Vector3(1, 1, 1) / 1.5, true, Color(0.25, 0.27, 0.25), 0.8), _ceil, [], ["n"])
	# a bench and a bar with plates, a rack, a pull-up frame, a bike, a
	# treadmill with the belt torn, a mirror wall gone to black
	var bench := Vector3(-22.5, Y1, -10.5)
	box(Vector3(0.4, 0.08, 1.3), bench + Vector3(0, 0.45, 0), pbr("fabric", Vector3(1, 1, 1), true, Color(0.3, 0.1, 0.1), 1.0), true)
	for sz: float in [-0.5, 0.5]:
		box(Vector3(0.06, 0.42, 0.06), bench + Vector3(0, 0.21, sz), _rust)
	for sx: float in [-0.7, 0.7]:
		box(Vector3(0.08, 1.2, 0.08), bench + Vector3(sx, 0.6, -0.5), _rust, true)
	stick(bench + Vector3(-1.0, 1.2, -0.5), bench + Vector3(1.0, 1.2, -0.5), 0.015, _rust)
	for sx: float in [-0.85, 0.85]:
		cyl(0.2, 0.2, 0.04, bench + Vector3(sx, 1.2, -0.5), _rust, 14).rotation.z = PI / 2.0
	var rack := Vector3(-17.0, Y1, -8.2)
	for i in 4:
		box(Vector3(1.6, 0.06, 0.4), rack + Vector3(0, 0.3 + i * 0.4, 0), _rust)
	for sx: float in [-0.75, 0.75]:
		box(Vector3(0.06, 1.6, 0.4), rack + Vector3(sx, 0.8, 0), _rust, true)
	for i in 6:
		cyl(0.06, 0.06, 0.3, rack + Vector3(-0.6 + i * 0.24, 0.42 + (i % 4) * 0.4, 0), _metal, 8).rotation.z = PI / 2.0
	# the pull-up frame with the wire on its bar
	var pu := Vector3(-20.0, Y1, -8.4)
	for sx: float in [-0.6, 0.6]:
		box(Vector3(0.08, 2.4, 0.08), pu + Vector3(sx, 1.2, 0), _rust, true)
	stick(pu + Vector3(-0.65, 2.3, 0), pu + Vector3(0.65, 2.3, 0), 0.02, _rust)
	wire_n = Node3D.new()
	wire_n.position = pu + Vector3(0, 2.3, 0)
	add_child(wire_n)
	var wire_m := mat(Color(0.75, 0.42, 0.2), 0.3, 0.8)
	for i in 14:
		var x := -0.3 + i * 0.045
		stick(Vector3(x, 0.035, 0), Vector3(x + 0.02, -0.035, 0.0), 0.006, wire_m, wire_n)
	stick(Vector3(0.33, 0, 0), Vector3(0.36, -0.25, 0.05), 0.005, wire_m, wire_n)
	interactable("wire", L("build", "wire_prompt"), pu + Vector3(0, 2.0, 0), Vector3(1.2, 0.8, 0.6), L("build", "wire_scan"), false)
	var bike := Vector3(-19.5, Y1, -12.5)
	box(Vector3(0.12, 0.8, 0.9), bike + Vector3(0, 0.55, 0), _rust, true)
	cyl(0.3, 0.3, 0.05, bike + Vector3(0, 0.3, 0.35), _rust, 16).rotation.z = PI / 2.0
	box(Vector3(0.28, 0.06, 0.3), bike + Vector3(0, 1.0, -0.3), mat(Color(0.15, 0.1, 0.08), 0.9))
	stick(bike + Vector3(-0.25, 1.05, 0.4), bike + Vector3(0.25, 1.05, 0.4), 0.015, _rust)
	interactable("gym_bike", L("build", "gym_bike_prompt"), bike + Vector3(0, 0.6, 0), Vector3(0.8, 1.2, 1.0), L("build", "gym_bike_scan"), false)
	var tread := Vector3(-23.5, Y1, -8.6)
	box(Vector3(0.8, 0.2, 1.8), tread + Vector3(0, 0.1, 0), _dark, true)
	box(Vector3(0.6, 0.02, 1.6), tread + Vector3(0, 0.21, 0), mat(Color(0.1, 0.1, 0.1), 0.95))
	box(Vector3(0.8, 1.1, 0.1), tread + Vector3(0, 0.75, -0.85), _rust, true)
	interactable("gym", L("build", "gym_prompt"), bench + Vector3(0, 0.6, 0), Vector3(2.0, 1.3, 1.6), L("build", "gym_scan"), false)
	# a mirror wall on the south side, the silver gone to black, and the
	# eye burned into the floor plating in the middle of the room
	box(Vector3(6.0, 2.0, 0.04), Vector3(-20.0, Y1 + 1.4, z1 - 0.17), mat(Color(0.02, 0.02, 0.025), 0.1, 0.5))
	_glyph_on(Vector3(-20.5, Y1 + 0.03, -11.0), 0.0, 0.012, "g_gym", false, true, "Burned into the floor plating in the middle of the gym, the rings, big enough to kneel inside. Somebody had. Two worn patches in the burn, knee-width apart.", true, Color(0.5, 0.42, 0.34))
	prop("old_tyre", Vector3(-16.0, Y1 + 0.08, -11.5), 0.0, 1.0, true)
	prop("old_tyre", Vector3(-16.2, Y1 + 0.24, -11.5), 0.5, 1.0, false)
	_fluor(Vector3(-22.0, Y1 + H1, -10.5), 0.0, 0.75, true)
	_fluor(Vector3(-17.5, Y1 + H1, -10.5), 0.0, 0.5)


## The utility room off the north side of the hallway (the fuse panel, the
## hatch) and the service passage behind the sealed doors to the west
## stairwell: the second way round, narrow, ducts overhead.
func _utility_and_passage() -> void:
	_room(-1.0, 3.0, -19.7, HZ - 1.3, Y1, H1, _conc, _floor1, _ceil, [], ["n", "s"])
	prop("fuse_panel", Vector3(2.8, Y1 + 0.8, -18.0), -PI / 2.0, 1.0, false)
	interactable("fuse", L("build", "fuse_prompt"), Vector3(2.75, Y1 + 1.2, -18.0), Vector3(0.3, 0.9, 0.9), L("build", "fuse_scan"), false)
	prop("power_box_01", Vector3(-0.8, Y1 + 1.3, -17.5), PI / 2.0, 1.0, false)
	prop("modular_electric_cables", Vector3(2.75, Y1 + 0.4, -19.2), -PI / 2.0, 1.0, false)
	prop("Barrel_01", Vector3(-0.4, Y1, -17.0), 0.0, 1.0, true)
	_cables(Vector3(2.8, Y1 + 2.2, -16.6), Vector3(2.8, Y1 + 2.2, -19.4), 4)
	light(Vector3(1.0, Y1 + 2.4, -18.0), Color(1.0, 0.6, 0.3), 0.6, 4.0)
	# the passage: z -21.3..-19.7, x -33..3, concrete, ducts and pipes. The
	# hatch is a grille bent back in its south wall at x 0.
	_room(-33.0, 3.0, -21.3, -19.7, Y1, 2.4, _conc, _floor2, _ceil, [["s", 0.0, 1.0], ["s", -32.0, 1.0]])
	var grille := mat(Color(0.3, 0.3, 0.32), 0.5, 0.7)
	for i in 5:
		var bar := stick(Vector3(-0.4 + i * 0.2, Y1 + 1.9, -19.7), Vector3(-0.4 + i * 0.2, Y1 + 1.0, -19.1), 0.012, grille)
		bar.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	interactable("service", L("build", "service_prompt"), Vector3(0.0, Y1 + 1.0, -19.7), Vector3(1.0, 2.0, 0.4), L("build", "service_scan"), false)
	var duct := mat(Color(0.5, 0.5, 0.5), 0.45, 0.7)
	cyl(0.28, 0.28, 35.0, Vector3(-15.0, Y1 + 1.95, -20.7), duct, 10).rotation.z = PI / 2.0
	for i in 4:
		prop("modular_airduct_circular_01", Vector3(-4.0 - i * 8.0, Y1 + 1.68, -20.7), PI / 2.0, 1.0, false)
	for i in 5:
		var l := light(Vector3(-2.0 - i * 7.0, Y1 + 2.2, -20.3), Color(1.0, 0.55, 0.25), 0.45, 5.0)
		if i == 2:
			fluor_lights.append([l, 0.45, 3.0, null])
	_cables(Vector3(2.5, Y1 + 1.2, -21.13), Vector3(-32.5, Y1 + 1.2, -21.13), 3)
	for x: float in [-6.0, -15.0, -24.0]:
		cyl(0.08, 0.08, 2.4, Vector3(x, Y1 + 1.2, -19.9), _rust, 8)
		prop("cardboard_box_01", Vector3(x + 2.0, Y1 + 0.18, -20.9), rng.randf() * TAU, 1.0, true)
	prop("old_gas_mask", Vector3(-20.0, Y1 + 1.5, -21.1), 0.0, 1.0, false)
	prop("street_rat", Vector3(-11.0, Y1, -21.0), 0.8, 1.6, false)
	_etched(Vector3(-12.0, Y1 + 0.6, -21.13), 0.0, "g_passage", "Chalked on the wall where the passage narrows, low, at a crawling height: the rings. Somebody came this way on their knees.")
	# the stub between the passage and the hallway's north door at x -32
	_room(-32.6, -31.4, -19.7, HZ - 1.3, Y1, H1, _conc, _floor2, _ceil, [], ["n", "s"])
	light(Vector3(-32.0, Y1 + 2.2, -18.0), Color(1.0, 0.55, 0.25), 0.4, 3.5)


## The fire door at the top of the second stairwell, shut until the office.
func _stair_b_door() -> void:
	stair_panel = _door_panel(Vector3(-32.0, Y1, HZ + 1.25), true, 2.4)
	stair_body = solid_box(Vector3(2.4, 2.1, 0.12), Vector3(-32.0, Y1 + 1.05, HZ + 1.25))
	box(Vector3(2.0, 0.06, 0.06), Vector3(-32.0, Y1 + 1.0, HZ + 1.18), _rust)
	_sign("SUBLEVEL TWO\nEXPERIMENTAL FLOOR", Vector3(-30.2, Y1 + 1.7, HZ + 1.13), PI, 0.0028)
	interactable("sign2", L("build", "sign2_prompt"), Vector3(-30.2, Y1 + 1.7, HZ + 1.1), Vector3(1.2, 0.5, 0.1), L("build", "sign2_scan"), false)
	interactable("stair_b", L("build", "stair_b_prompt"), Vector3(-32.0, Y1 + 1.0, HZ + 1.1), Vector3(2.2, 2.0, 0.5), "", false)


## Stairwell B: south and down from the west end of the hallway into the
## army-green brick.
func _stairwell_b() -> void:
	_flight(STAIR_B_TOP, Vector3(0, 0, 1), Y1 - Y2, STAIR_B_RUN, 2.2, mat(Color(0.42, 0.42, 0.4), 0.85))
	var z0 := -13.7
	var z1 := -7.3
	for sd: float in [-1.0, 1.0]:
		_wall(Vector3(0.3, Y1 + H1 - Y2, z1 - z0), Vector3(-32.0 + sd * 1.25, (Y1 + H1 + Y2) / 2.0, (z0 + z1) / 2.0), _brick)
	box(Vector3(2.8, 0.3, z1 - z0), Vector3(-32.0, Y1 + H1 + 0.15, (z0 + z1) / 2.0), _ceil)
	floor_quad(Vector2(2.2, 0.4), Vector3(-32.0, Y2 + 0.003, -7.5), 0.0, _floor2)
	_fluor(Vector3(-32.0, Y1 + 1.6, -10.5), 0.0, 0.7)
	_fluor(Vector3(-32.0, Y2 + H1, -7.9), 0.0, 0.7, true)
	_cables(Vector3(-30.95, Y1 + 1.0, -13.4), Vector3(-30.95, Y2 + 1.8, -7.6), 2)



# ------------------------------------------------------------------ sublevel 2 (ch. 12)

## "This floor was slightly larger, with more rooms branching off a forked
## hallway. A drab army green colored the rough brick walls." The spine
## corridor S (the eyeless walk it), the links F and E north to the pens
## corridor P, the pens, the observation room and the lab, the side rooms
## off S, the stairs down at its east end.
func _sublevel_2() -> void:
	_corridor_s()
	_room(-23.2, -20.8, -14.7, -7.3, Y2, H1, _brick, _floor2, _ceil, [], ["n", "s"])
	_fluor(Vector3(-22.0, Y2 + H1, -11.0), PI / 2.0, 0.6, true)
	_cables(Vector3(-23.0, Y2 + 2.5, -14.5), Vector3(-23.0, Y2 + 2.5, -7.5), 2)
	_corridor_p()
	for i in 6:
		_pen(i)
	_observation()
	_lab()
	_decon()
	_side_rooms()
	_hangar_stairs()


func _corridor_s() -> void:
	_room(-34.0, 19.0, SZ - 1.3, SZ + 1.3, Y2, H1, _brick, _floor2, _ceil,
		[["n", -32.0, 2.4], ["n", -22.0, 2.4], ["n", 6.0, 1.4], ["s", -27.0, 1.2], ["s", -4.0, 1.2], ["s", 13.0, 1.2], ["e", SZ, 1.6]])
	for z: float in [SZ - 1.14, SZ + 1.14]:
		box(Vector3(53.0, 0.05, 0.03), Vector3(-7.5, Y2 + 1.2, z), mat(Color(0.16, 0.22, 0.14), 0.9))
		box(Vector3(53.0, 0.12, 0.02), Vector3(-7.5, Y2 + 0.06, z), _metal)
	# pipes along the ceiling, cables along the north wall, drops
	var pipe := mat(Color(0.34, 0.3, 0.26), 0.6, 0.5)
	for k in 2:
		cyl(0.06 + k * 0.03, 0.06 + k * 0.03, 52.0, Vector3(-7.5, Y2 + 2.75 - k * 0.15, SZ + 0.8 - k * 0.25), pipe, 8).rotation.z = PI / 2.0
	_cables(Vector3(18.5, Y2 + 2.4, SZ - 1.1), Vector3(-33.5, Y2 + 2.4, SZ - 1.1), 3)
	for i in 9:
		var x := -31.0 + i * 6.0
		_fluor(Vector3(x, Y2 + H1, SZ), 0.0, 0.62, i % 3 == 1)
	# signs on the brick
	_sign("HOUSING  1-6  ^", Vector3(-22.0, Y2 + 2.35, SZ - 1.13), 0.0, 0.0028)
	_sign("DECON  /  LAB 1  ^", Vector3(6.0, Y2 + 2.35, SZ - 1.13), 0.0, 0.0028)
	_sign("LAUNDRY", Vector3(-27.0, Y2 + 2.35, SZ + 1.13), PI, 0.0025)
	_sign("RECORDS", Vector3(-4.0, Y2 + 2.35, SZ + 1.13), PI, 0.0025)
	_sign("AUX POWER", Vector3(13.0, Y2 + 2.35, SZ + 1.13), PI, 0.0025)
	_sign("EXPERIMENTAL FLOOR  -  ESCORTED SUBJECTS ONLY", Vector3(-28.5, Y2 + 1.75, SZ - 1.13), 0.0, 0.0022, Color(0.85, 0.75, 0.4))
	# the tattered flag at the fork, on the south wall
	var fm := decal_mat(_flag_tex(), Color(0.85, 0.85, 0.85), 0.9)
	fm.cull_mode = BaseMaterial3D.CULL_DISABLED
	var fq := quad(Vector2(2.2, 1.2), Vector3(-19.5, Y2 + 1.9, SZ + 1.12), PI, fm)
	fq.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	fq.rotation.z = -0.06
	# clutter: a gurney with a strap hanging, crates, a mop bucket, a
	# drinking fountain, papers, puddles, cameras
	var gp := Vector3(-12.5, Y2, SZ + 0.75)
	box(Vector3(1.9, 0.08, 0.62), gp + Vector3(0, 0.8, 0), _metal, true)
	box(Vector3(1.8, 0.1, 0.56), gp + Vector3(0, 0.88, 0), mat(Color(0.5, 0.48, 0.42), 0.9))
	for sx: float in [-0.85, 0.85]:
		for sz: float in [-0.25, 0.25]:
			box(Vector3(0.04, 0.78, 0.04), gp + Vector3(sx, 0.39, sz), _metal)
	stick(gp + Vector3(0.3, 0.88, -0.3), gp + Vector3(0.36, 0.3, -0.32), 0.02, mat(Color(0.22, 0.16, 0.1), 0.9))
	prop("plastic_crate_03", Vector3(-30.5, Y2, SZ + 0.9), 0.3, 1.0, true)
	prop("plastic_crate_03", Vector3(-30.5, Y2 + 0.25, SZ + 0.9), 0.0, 1.0, false)
	prop("Barrel_01", Vector3(16.8, Y2, SZ - 0.85), 0.0, 1.0, true)
	prop("metal_trash_can", Vector3(-6.5, Y2, SZ - 0.95), 0.0, 1.0, true)
	prop("cardboard_box_01", Vector3(9.0, Y2 + 0.18, SZ + 0.95), 0.6, 1.0, true)
	prop("security_camera_01", Vector3(-33.6, Y2 + 2.7, SZ - 1.0), -PI / 2.0, 1.0, false)
	prop("security_camera_01", Vector3(18.6, Y2 + 2.7, SZ + 1.0), PI / 2.0, 1.0, false)
	cyl(0.17, 0.15, 0.36, Vector3(1.5, Y2 + 0.18, SZ + 0.9), mat(Color(0.5, 0.45, 0.2), 0.7), 10)
	box(Vector3(0.4, 0.3, 0.3), Vector3(-25.0, Y2 + 0.95, SZ - 1.0), _metal)
	var puddle := mat(Color(0.03, 0.04, 0.03), 0.05, 0.4)
	for i in 6:
		floor_quad(Vector2(rng.randf_range(0.6, 1.6), rng.randf_range(0.4, 1.0)), Vector3(-26.0 + i * 7.3, Y2 + 0.004, SZ + rng.randf_range(-0.7, 0.7)), rng.randf() * TAU, puddle)
	for i in 6:
		floor_quad(Vector2(0.21, 0.29), Vector3(-28.0 + i * 8.0, Y2 + 0.006, SZ + rng.randf_range(-1.0, 1.0)), rng.randf() * TAU, tex_mat(Tex.paper(500 + i), Vector3.ONE, 0.9))
	# handprints along the brick where the eyeless feel their way
	var hand := decal_mat(Tex.blob(), Color(0.12, 0.08, 0.05, 0.55), 0.9)
	for i in 14:
		var hx := -18.0 + i * 2.4
		var hz := SZ - 1.13 if i % 2 == 0 else SZ + 1.13
		var hq := quad(Vector2(0.14, 0.18), Vector3(hx, Y2 + 1.25 + rng.randf_range(-0.1, 0.1), hz), 0.0 if i % 2 == 0 else PI, hand)
		hq.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_etched(Vector3(-28.0, Y2 + 1.5, SZ + 1.14), PI, "g_spine", "Scratched into the brick at the bottom of the stairs, low, where someone sitting against the wall could reach: the rings, and inside them, very small, SUBLEVEL 2 IS THE WALL.")


func _corridor_p() -> void:
	_room(-23.2, 11.5, PZ - 1.3, PZ + 1.3, Y2, H1, _brick, _floor2, _ceil,
		[["s", -22.0, 2.4], ["s", -16.5, 1.0], ["s", -10.5, 1.0], ["s", -4.5, 1.0], ["s", 6.0, 1.4],
		["n", -16.5, 1.0], ["n", -10.5, 1.0], ["n", -4.5, 1.0], ["n", 1.5, 1.0], ["n", 8.5, 1.0]])
	for z: float in [PZ - 1.14, PZ + 1.14]:
		box(Vector3(34.6, 0.12, 0.02), Vector3(-5.85, Y2 + 0.06, z), _metal)
	_cables(Vector3(11.2, Y2 + 2.6, PZ + 1.1), Vector3(-23.0, Y2 + 2.6, PZ + 1.1), 2)
	for i in 6:
		_fluor(Vector3(-20.0 + i * 6.0, Y2 + H1, PZ), 0.0, 0.55, i % 2 == 0)
	prop("security_camera_01", Vector3(11.2, Y2 + 2.7, PZ - 1.0), PI / 2.0, 1.0, false)
	prop("security_camera_01", Vector3(-22.9, Y2 + 2.7, PZ + 1.0), -PI / 2.0, 1.0, false)
	_sign("OBSERVATION\nAUTHORISED STAFF ONLY", Vector3(1.5, Y2 + 2.45, PZ - 1.13), 0.0, 0.0022)
	_sign("PERTURBATION LAB 1", Vector3(8.5, Y2 + 2.45, PZ - 1.13), 0.0, 0.0024)
	prop("plastic_crate_03", Vector3(10.6, Y2, PZ + 0.9), 1.0, 1.0, true)
	prop("cardboard_box_01", Vector3(-21.5, Y2 + 0.18, PZ - 0.9), 0.2, 1.0, true)
	# the observation room's door: a push-bar on the inside only
	obs_panel = _door_panel(OBS_DOOR + Vector3(0, 0, -0.02), true, 1.0)
	obs_body = solid_box(Vector3(1.0, 2.1, 0.12), OBS_DOOR + Vector3(0, 1.05, 0))
	interactable("obs_door", L("build", "obs_door_prompt"), OBS_DOOR + Vector3(0, 1.1, 0.0), Vector3(1.0, 2.1, 0.5), "", false)


## Housing Pens 1-6: "a bed, a sink, and a toilet. Not much else." 1-3
## south of P, 4-6 north; pen 4 is Subject 41's, its east wall the
## observation room's west wall (the eye-layer door is in it).
func _pen(i: int) -> void:
	var cx: float = PEN_X[i]
	var north := i >= 3
	var x0 := cx - 2.5
	var x1 := cx + 2.5
	var z0 := -22.5 if north else PZ + 1.3
	var z1 := PZ - 1.3 if north else -10.5
	var skip := ["s"] if north else ["n"]
	if i == 3:
		skip.append("e")
	_room(x0, x1, z0, z1, Y2, H1, _brick, _floor2, _ceil, [], skip)
	var back := z0 if north else z1        # the wall opposite the door
	var inward := 1.0 if north else -1.0   # from the back wall into the pen
	var door_z := z1 if north else z0
	# the open cell door, swung back against the corridor wall
	var dp := Vector3(cx + 0.5, Y2, door_z - inward * 0.55)
	var dr := box(Vector3(0.06, 2.05, 0.95), dp + Vector3(0, 1.03, 0), mat(Color(0.3, 0.33, 0.3), 0.55, 0.6))
	dr.rotation.y = 0.15 * inward
	box(Vector3(0.2, 0.15, 0.02), Vector3(cx + 0.5, Y2 + 1.6, door_z - inward * 0.55 + 0.04 * inward), _dark)
	_sign("HOUSING PEN %d" % (i + 1), Vector3(cx, Y2 + 2.4, door_z + inward * 0.17), 0.0 if north else PI, 0.0024)
	# the bed against the back wall, steel frame, a thin mattress
	var bed := Vector3(cx - 1.4, Y2, back + inward * 1.1)
	box(Vector3(0.95, 0.08, 2.0), bed + Vector3(0, 0.42, 0), _metal, true)
	for sx: float in [-0.43, 0.43]:
		for sz: float in [-0.95, 0.95]:
			box(Vector3(0.05, 0.42, 0.05), bed + Vector3(sx, 0.21, sz), _metal)
	var mattress := pbr("fabric", Vector3(1, 1, 1), true, Color(0.55, 0.55, 0.48) if i != 2 else Color(0.45, 0.38, 0.3), 1.0)
	box(Vector3(0.88, 0.12, 1.92), bed + Vector3(0, 0.52, 0), mattress)
	# the sink and the toilet on the side wall, steel
	var side_x := x1 - 0.3
	box(Vector3(0.36, 0.14, 0.44), Vector3(side_x, Y2 + 0.85, back + inward * 0.8), _metal)
	cyl(0.012, 0.012, 0.2, Vector3(side_x + 0.05, Y2 + 1.0, back + inward * 0.8), _metal, 5)
	cyl(0.2, 0.17, 0.42, Vector3(side_x - 0.05, Y2 + 0.21, back + inward * 1.8), _metal, 10)
	box(Vector3(0.3, 0.4, 0.2), Vector3(side_x + 0.05, Y2 + 0.6, back + inward * 2.1), _metal)
	# a fluorescent, dim; a strip of the brick scraped where a head leaned
	_fluor(Vector3(cx, Y2 + H1, (z0 + z1) / 2.0), PI / 2.0, 0.42, i == 0 or i == 3)
	var subj: String = LA("build", "pen_subjects")[i]
	var stat: String = LA("build", "pen_status")[i]
	var scan := L("build", "pen_scan") % [i + 1, subj, stat]
	interactable("pen%d" % (i + 1), L("build", "pen_prompt") % (i + 1), bed + Vector3(0, 0.6, 0), Vector3(1.0, 0.5, 2.0), scan, false)
	match i:
		1:
			# tallies scratched in the brick by the bed, hundreds of them
			var tm := mat(Color(0.5, 0.48, 0.4), 0.9)
			for k in 30:
				var tx := cx - 2.2 + (k % 15) * 0.07
				var ty := Y2 + 0.9 + (k / 15) * 0.25
				box(Vector3(0.012, 0.18, 0.01), Vector3(tx, ty, back + inward * 0.16), tm)
		2:
			# DECEASED: the mattress stained through, the stain on the floor
			floor_quad(Vector2(1.4, 1.6), Vector3(cx - 1.2, Y2 + 0.005, back + inward * 1.4), 0.4, decal_mat(_stain_tex(), Color(1, 1, 1), 0.7))
		3:
			# Subject 41: the eye scratched into the brick above the bed
			_etched(Vector3(cx - 1.4, Y2 + 1.9, back + 0.17), 0.0, "g_pen4", "Above the bed in Pen 4, scratched into the brick with something harder than a fingernail, the eye. Under it, the same hand: I WILL SEE YOU.", 0.006)
			for k in 8:
				var sx2 := cx - 0.6 + k * 0.18
				box(Vector3(0.14, 0.01, 0.01), Vector3(sx2, Y2 + 1.4 + sin(k) * 0.08, back + 0.16), mat(Color(0.5, 0.48, 0.4), 0.9))
		4:
			# 12-34, "breathing through wires": the vent prised off, the
			# wires pulled out of the wall into the bed
			box(Vector3(0.5, 0.3, 0.04), Vector3(cx + 0.6, Y2 + 2.4, back + inward * 0.16), _dark)
			for k in 5:
				stick(Vector3(cx + 0.45 + k * 0.07, Y2 + 2.3, back + inward * 0.2), bed + Vector3(rng.randf_range(-0.3, 0.3), 0.6, rng.randf_range(-0.8, 0.0) * inward), 0.008, _cable)
		5:
			# 12-35, PENDING: fresh sheets, a folded yellow gown in Carl's size
			box(Vector3(0.9, 0.04, 1.94), bed + Vector3(0, 0.6, 0), mat(Color(0.85, 0.86, 0.82), 0.9))
			box(Vector3(0.4, 0.06, 0.32), bed + Vector3(0, 0.64, -0.7 * inward), mat(Color(0.78, 0.66, 0.22), 0.9))
	if i == 3:
		_eye_door_wall(x1)


## Pen 4's east wall, shared with the observation room: brick with the
## frames off; with them on, the plain steel door with the eye scratched
## into it at head height, which Lynx cannot see.
func _eye_door_wall(x: float) -> void:
	var z0 := -22.5
	var z1 := PZ - 1.3
	var dz := EYE_DOOR.z
	_wall(Vector3(0.3, H1, (dz - 0.5) - z0), Vector3(x, Y2 + H1 / 2.0, (z0 + dz - 0.5) / 2.0), _brick)
	_wall(Vector3(0.3, H1, z1 - (dz + 0.5)), Vector3(x, Y2 + H1 / 2.0, (dz + 0.5 + z1) / 2.0), _brick)
	_wall(Vector3(0.3, H1 - 2.1, 1.0), Vector3(x, Y2 + 2.1 + (H1 - 2.1) / 2.0, dz), _brick)
	# the brick in the doorway (frames off) and the door (frames on)
	var plug := box(Vector3(0.3, 2.1, 1.0), Vector3(x, Y2 + 1.05, dz), _brick, true)
	no_batch.append(plug)
	eye_door = Node3D.new()
	eye_door.position = Vector3(x, Y2, dz)
	add_child(eye_door)
	var steel := mat(Color(0.36, 0.38, 0.38), 0.45, 0.7)
	box(Vector3(0.36, 2.06, 0.96), Vector3(0, 1.03, 0), steel, false, eye_door)
	box(Vector3(0.4, 0.08, 1.1), Vector3(0, 2.1, 0), _metal, false, eye_door)
	for sd: float in [-1.0, 1.0]:
		box(Vector3(0.4, 2.1, 0.06), Vector3(0, 1.05, sd * 0.52), _metal, false, eye_door)
		cyl(0.03, 0.03, 0.14, Vector3(sd * 0.2, 1.0, 0.36), _metal, 6, eye_door).rotation.z = PI / 2.0
	for sd: float in [-1.0, 1.0]:
		var s := Sprite3D.new()
		s.texture = _glyph_tex
		s.pixel_size = 0.0035
		s.modulate = Color(0.25, 1.0, 0.9)
		s.position = Vector3(sd * 0.185, 1.6, 0)
		s.rotation.y = sd * PI / 2.0
		eye_door.add_child(s)
	var gl := OmniLight3D.new()
	gl.light_color = Color(0.3, 1.0, 0.85)
	gl.light_energy = 0.5
	gl.omni_range = 2.5
	gl.position = Vector3(-0.8, 1.6, 0)
	eye_door.add_child(gl)
	eye_door.visible = false
	eye_door.set_meta("plug", plug)
	eye_door_it = interactable("eye_door", L("build", "eye_door_prompt"), Vector3(x, Y2 + 1.05, dz), Vector3(0.7, 2.0, 1.0), L("build", "eye_door_scan"), false)
	set_active(eye_door_it, false)
	eye_wall_it = interactable("eye_wall", L("build", "eye_wall_prompt"), Vector3(x - 0.2, Y2 + 1.4, dz - 0.3), Vector3(0.2, 1.4, 2.0), "", false)


## The observation room: "mostly empty except for a single desk and a
## monitor that was already on, casting a pale blue glow on the wall."
## The one-way glass east into the lab; the push-bar door south onto P.
func _observation() -> void:
	var x0 := -2.0
	var x1 := 5.0
	var z0 := -22.5
	var z1 := PZ - 1.3
	_room(x0, x1, z0, z1, Y2, H1, _brick, _floor2, _ceil, [], ["w", "e", "s"])
	# the shared wall with the lab: brick round the window
	var wz0 := -21.6
	var wz1 := -18.6
	_wall(Vector3(0.3, H1, wz0 - z0), Vector3(x1, Y2 + H1 / 2.0, (z0 + wz0) / 2.0), _brick)
	_wall(Vector3(0.3, H1, z1 - wz1), Vector3(x1, Y2 + H1 / 2.0, (wz1 + z1) / 2.0), _brick)
	_wall(Vector3(0.3, 0.9, wz1 - wz0), Vector3(x1, Y2 + 0.45, (wz0 + wz1) / 2.0), _brick)
	_wall(Vector3(0.3, H1 - 2.2, wz1 - wz0), Vector3(x1, Y2 + 2.2 + (H1 - 2.2) / 2.0, (wz0 + wz1) / 2.0), _brick)
	solid_box(Vector3(0.1, 1.3, wz1 - wz0), Vector3(x1, Y2 + 1.55, (wz0 + wz1) / 2.0))
	var see := newmat(Color(0.05, 0.09, 0.08, 0.35), 0.05, 0.3)
	see.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	quad(Vector2(wz1 - wz0, 1.3), Vector3(x1 - 0.02, Y2 + 1.55, (wz0 + wz1) / 2.0), -PI / 2.0, see)
	quad(Vector2(wz1 - wz0, 1.3), Vector3(x1 + 0.02, Y2 + 1.55, (wz0 + wz1) / 2.0), PI / 2.0, mat(Color(0.02, 0.025, 0.03), 0.04, 0.9))
	box(Vector3(0.36, 0.06, wz1 - wz0 + 0.1), Vector3(x1, Y2 + 0.9, (wz0 + wz1) / 2.0), _metal)
	interactable("glass", L("build", "glass_prompt"), Vector3(x1, Y2 + 1.55, (wz0 + wz1) / 2.0), Vector3(0.5, 1.3, 3.0), L("build", "glass_scan"), false)
	# the desk and the monitor, already on, against the north wall
	prop("metal_office_desk", OBS_DESK + Vector3(0, 0, -0.1), 0.0, 0.85, true)
	obs_screen_m = newglow(Color(0.35, 0.55, 0.9), 1.4)
	var scr := _ionware(OBS_DESK + Vector3(0.0, 0.67, 0.0), PI, obs_screen_m)
	no_batch.append(scr)
	_ionware(OBS_DESK + Vector3(-0.6, 0.67, -0.05), PI + 0.2, mat(Color(0.05, 0.06, 0.06), 0.2, 0.3))
	obs_light = light(OBS_DESK + Vector3(0, 1.2, 0.5), Color(0.45, 0.6, 1.0), 1.1, 5.0)
	interactable("monitor", L("build", "monitor_prompt"), OBS_DESK + Vector3(0, 1.1, 0.1), Vector3(0.8, 0.7, 0.6), L("build", "monitor_scan"), false)
	var cm := mat(Color(0.12, 0.12, 0.13), 0.6, 0.3)
	box(Vector3(0.46, 0.08, 0.46), OBS_CHAIR + Vector3(0, 0.5, 0), cm)
	box(Vector3(0.44, 0.5, 0.06), OBS_CHAIR + Vector3(0, 0.8, 0.22), cm)
	cyl(0.04, 0.04, 0.45, OBS_CHAIR + Vector3(0, 0.25, 0), _metal, 6)
	# server racks along the north wall, west of the desk; the cabinets
	prop("server_rack", Vector3(-0.9, Y2, -21.9), 0.0, 0.8, true)
	for k in 6:
		var bl := box(Vector3(0.025, 0.025, 0.02), Vector3(-1.5 + k * 0.22, Y2 + 0.8 + (k % 3) * 0.35, -21.48), glow(Color(0.3, 1.0, 0.4) if k % 3 else Color(1.0, 0.4, 0.1), 2.0))
		if k % 2 == 0:
			blinkers.append(bl)
	interactable("rack", L("build", "rack_prompt"), Vector3(-0.9, Y2 + 1.0, -21.9), Vector3(1.5, 1.8, 0.8), L("build", "rack_scan"), false)
	for k in 2:
		box(Vector3(0.5, 1.3, 0.6), Vector3(4.4, Y2 + 0.65, -17.9 - k * 0.55), mat(Color(0.4, 0.42, 0.38), 0.6, 0.4), true)
		box(Vector3(0.5, 0.25, 0.4), Vector3(4.4, Y2 + 1.05, -17.9 - k * 0.55 + 0.0), _dark)
	prop("security_camera_01", Vector3(4.7, Y2 + 2.7, -22.2), PI * 0.75, 1.0, false)
	_fluor(Vector3(1.5, Y2 + H1, -19.5), 0.0, 0.3, true, Color(0.7, 0.85, 1.0))
	_cables(Vector3(-1.8, Y2 + 0.05, -21.2), Vector3(1.2, Y2 + 0.05, -21.2), 3)
	for k in 5:
		floor_quad(Vector2(0.21, 0.29), Vector3(rng.randf_range(-1.5, 3.5), Y2 + 0.005, rng.randf_range(-21.0, -18.0)), rng.randf() * TAU, tex_mat(Tex.paper(600 + k), Vector3.ONE, 0.9))
	# the push-bar on the inside of the door
	box(Vector3(0.8, 0.06, 0.08), Vector3(0, -0.04, -0.1), _metal, false, obs_panel)


## Perturbation Lab 1: the room from the recordings. A chair bolted down
## with straps, the monitor on its stand, the camera high in the corner,
## the eye on the ceiling ten feet up.
func _lab() -> void:
	var x0 := 5.0
	var x1 := 11.5
	var z0 := -22.5
	var z1 := PZ - 1.3
	_room(x0, x1, z0, z1, Y2, H1, _tile, _tile, _white, [], ["w", "s"])
	# the shoe propping the door
	box(Vector3(0.12, 0.1, 0.28), Vector3(8.95, Y2 + 0.05, -17.6), mat(Color(0.1, 0.08, 0.06), 0.8))
	# the chair, bolted down, straps cut; the electrode tray; the stain
	var ch := LAB_CHAIR
	var seat := mat(Color(0.2, 0.2, 0.22), 0.5, 0.4)
	box(Vector3(0.6, 0.1, 0.6), ch + Vector3(0, 0.5, 0), seat, true)
	box(Vector3(0.6, 0.9, 0.1), ch + Vector3(0, 1.0, 0.28), seat)
	box(Vector3(0.1, 0.06, 0.55), ch + Vector3(-0.33, 0.72, 0.0), seat)
	box(Vector3(0.1, 0.06, 0.55), ch + Vector3(0.33, 0.72, 0.0), seat)
	cyl(0.08, 0.14, 0.45, ch + Vector3(0, 0.23, 0), _metal, 8)
	var strap := mat(Color(0.18, 0.12, 0.08), 0.85)
	for sd: float in [-1.0, 1.0]:
		stick(ch + Vector3(sd * 0.36, 0.76, -0.1), ch + Vector3(sd * 0.42, 0.45, -0.2), 0.018, strap)
		stick(ch + Vector3(sd * 0.15, 0.12, -0.3), ch + Vector3(sd * 0.22, 0.02, -0.45), 0.018, strap)
	interactable("chair", L("build", "chair_prompt"), ch + Vector3(0, 0.7, 0), Vector3(0.8, 1.4, 0.8), L("build", "chair_scan"), false)
	var stain := floor_quad(Vector2(1.8, 1.8), ch + Vector3(0.1, 0.006, -0.1), 0.6, decal_mat(_stain_tex(), Color(1, 1, 1), 0.7))
	lab_now.append(stain)
	no_batch.append(stain)
	var cart := Vector3(9.6, Y2, -20.8)
	box(Vector3(0.6, 0.04, 0.4), cart + Vector3(0, 0.85, 0), _metal)
	box(Vector3(0.6, 0.04, 0.4), cart + Vector3(0, 0.3, 0), _metal)
	for sx: float in [-0.28, 0.28]:
		for sz: float in [-0.18, 0.18]:
			box(Vector3(0.03, 0.85, 0.03), cart + Vector3(sx, 0.43, sz), _metal)
	for k in 6:
		box(Vector3(0.03, 0.01, 0.03), cart + Vector3(-0.2 + k * 0.08, 0.88, 0.05), _white)
		stick(cart + Vector3(-0.2 + k * 0.08, 0.88, 0.05), cart + Vector3(-0.1 + k * 0.05, 0.4, 0.15), 0.004, _cable)
	# the monitor on its stand facing the chair, and the EEG display
	var stand := Vector3(LAB_SCREEN.x, Y2, LAB_SCREEN.z)
	cyl(0.03, 0.03, 1.0, stand + Vector3(0, 0.5, 0), _metal, 6)
	box(Vector3(0.4, 0.04, 0.4), stand + Vector3(0, 0.02, 0), _metal)
	box(Vector3(0.5, 0.38, 0.36), LAB_SCREEN + Vector3(0, 0, -0.08), _beige)
	quad(Vector2(0.4, 0.3), LAB_SCREEN + Vector3(0, 0, 0.105), 0.0, mat(Color(0.04, 0.05, 0.05), 0.2, 0.3))
	lab_text = Label3D.new()
	lab_text.font_size = 32
	lab_text.pixel_size = 0.0011
	lab_text.modulate = Color(0.9, 0.95, 0.9)
	lab_text.outline_size = 0
	lab_text.width = 340.0
	lab_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lab_text.position = LAB_SCREEN + Vector3(0, 0, 0.11)
	lab_text.visible = false
	add_child(lab_text)
	interactable("lab_monitor", L("build", "lab_monitor_prompt"), LAB_SCREEN, Vector3(0.6, 0.5, 0.5), L("build", "lab_monitor_scan"), false)
	var eeg := Vector3(10.7, Y2 + 1.1, -21.6)
	box(Vector3(0.5, 0.38, 0.36), eeg, _beige)
	box(Vector3(0.7, 0.7, 0.5), eeg - Vector3(0, 0.6, 0), _metal, true)
	quad(Vector2(0.4, 0.3), eeg + Vector3(0, 0, 0.185), 0.0, mat(Color(0.04, 0.05, 0.05), 0.2, 0.3))
	lab_eeg = Label3D.new()
	lab_eeg.font_size = 32
	lab_eeg.pixel_size = 0.0012
	lab_eeg.modulate = Color(0.4, 1.0, 0.5)
	lab_eeg.outline_size = 0
	lab_eeg.text = "_/\\_/\\__/\\/\\/\\/\\/\\_\n__/\\/\\/\\_/\\/\\/\\/\\\n_/\\/\\/\\/\\/\\/\\/\\/\\/\\"
	lab_eeg.position = eeg + Vector3(0, 0, 0.19)
	lab_eeg.visible = false
	add_child(lab_eeg)
	# the desk where the decoy subjects typed; the camera in the corner
	prop("metal_office_desk", Vector3(9.8, Y2, -17.95), PI, 0.7, true)
	box(Vector3(0.42, 0.025, 0.15), Vector3(9.8, Y2 + 0.57, -18.0), mat(Color(0.6, 0.56, 0.48), 0.8))
	prop("security_camera_01", LAB_CAM, PI * 0.75, 1.0, false)
	interactable("camera", L("build", "camera_prompt"), LAB_CAM, Vector3(0.5, 0.5, 0.5), L("build", "camera_scan"), false)
	var rec := box(Vector3(0.03, 0.03, 0.03), LAB_CAM + Vector3(-0.1, -0.02, 0.15), glow(Color(1.0, 0.1, 0.05), 3.0))
	blinkers.append(rec)
	# the eye on the ceiling, over the chair, as wide as the room
	var g := _glyph_on(Vector3(ch.x, Y2 + H1 - 0.02, ch.z), 0.0, 0.04, "g_ceiling", false, true, "On the ceiling, ten feet up, over the chair: the eye, drawn in something brown, the outer ring as wide as the room, the gap in it toward the camera.", true, Color(0.42, 0.24, 0.14))
	(g.get_meta("sprite") as Sprite3D).rotation.x = PI / 2.0
	lab_now.append(g.get_meta("sprite"))
	interactable("lab_door", L("build", "lab_door_prompt"), Vector3(8.5, Y2 + 1.1, -17.3), Vector3(1.0, 2.1, 0.5), "", false)
	# the light now: one dim tube, greenish; the light then (hidden):
	# "bathed in the sterile glare of bright, fluorescent white light"
	_fluor(Vector3(8.0, Y2 + H1, -19.0), 0.0, 0.35, true, Color(0.7, 0.9, 0.75))
	for p: Vector3 in [Vector3(7.0, Y2 + 2.6, -20.0), Vector3(10.0, Y2 + 2.6, -19.5)]:
		var bl2 := light(p, Color(0.95, 0.97, 1.0), 0.0, 8.0, false)
		lab_lights.append([bl2, 2.6])
	# dust and debris now
	for k in 6:
		floor_quad(Vector2(0.21, 0.29), Vector3(rng.randf_range(6.0, 11.0), Y2 + 0.005, rng.randf_range(-22.0, -18.0)), rng.randf() * TAU, tex_mat(Tex.paper(700 + k), Vector3.ONE, 0.9))
	var debris := box(Vector3(0.5, 0.06, 0.3), Vector3(6.2, Y2 + 0.03, -21.8), _metal)
	lab_now.append(debris)
	no_batch.append(debris)


## The decontamination passage, the second way between the corridors.
func _decon() -> void:
	_room(4.5, 7.5, -14.7, -7.3, Y2, H1, _tile, _tile, _ceil, [], ["n", "s"])
	for k in 3:
		var z := -13.0 + k * 2.2
		for sd: float in [-1.0, 1.0]:
			var x := 6.0 + sd * 1.32
			cyl(0.012, 0.012, 0.5, Vector3(x, Y2 + 2.4, z), _metal, 5)
			cyl(0.08, 0.05, 0.06, Vector3(x - sd * 0.12, Y2 + 2.2, z), _metal, 8).rotation.z = sd * 0.8
	cyl(0.18, 0.18, 0.01, Vector3(6.0, Y2 + 0.005, -11.0), _dark, 12)
	floor_quad(Vector2(1.2, 1.4), Vector3(6.0, Y2 + 0.004, -11.0), 0.0, mat(Color(0.03, 0.04, 0.03), 0.05, 0.4))
	interactable("showers", L("build", "showers_prompt"), Vector3(6.0, Y2 + 0.3, -11.0), Vector3(1.2, 0.6, 1.2), L("build", "showers_scan"), false)
	_fluor(Vector3(6.0, Y2 + H1, -11.0), PI / 2.0, 0.5, true, Color(0.8, 0.95, 0.9))


## Off the south side of S: the laundry with the gowns, the records room,
## the auxiliary generator that has no fuel line.
func _side_rooms() -> void:
	var z0 := SZ + 1.3
	var z1 := 1.0
	# the laundry
	_room(-30.0, -24.0, z0, z1, Y2, H1, _brick, _floor2, _ceil, [], ["n"])
	for k in 2:
		var wp := Vector3(-29.3 + k * 1.0, Y2, 0.3)
		box(Vector3(0.8, 1.0, 0.75), wp + Vector3(0, 0.5, 0), _white, true)
		cyl(0.25, 0.25, 0.03, wp + Vector3(0, 0.55, -0.38), mat(Color(0.1, 0.12, 0.12), 0.1, 0.4), 14).rotation.x = PI / 2.0
	for k in 11:
		var hz := z0 + 0.6 + k * 0.36
		stick(Vector3(-29.84, Y2 + 1.75, hz), Vector3(-29.72, Y2 + 1.75, hz), 0.01, _metal)
		var gown := box(Vector3(0.05, 0.9, 0.32), Vector3(-29.75, Y2 + 1.3, hz), mat(Color(0.78, 0.66, 0.22), 0.9))
		gown.rotation.x = rng.randf_range(-0.05, 0.05)
	interactable("gowns", L("build", "gowns_prompt"), Vector3(-29.65, Y2 + 1.3, z0 + 2.4), Vector3(0.4, 1.0, 4.2), L("build", "gowns_scan"), false)
	prop("plastic_crate_03", Vector3(-24.8, Y2, 0.4), 0.2, 1.0, true)
	_fluor(Vector3(-27.0, Y2 + H1, -1.8), PI / 2.0, 0.45, true)
	# the records room
	_room(-8.0, 0.0, z0, z1, Y2, H1, _brick, _floor2, _ceil, [], ["n"])
	for k in 3:
		prop("steel_frame_shelves_01", Vector3(-7.5 + k * 2.0, Y2, 0.6), PI, 1.0, true)
		for j in 4:
			box(Vector3(0.8, 0.1, 0.3), Vector3(-7.5 + k * 2.0, Y2 + 0.45 + j * 0.5, 0.6), _dark)
	for k in 3:
		var cp := Vector3(-0.5, Y2, -3.6 + k * 0.6)
		box(Vector3(0.6, 1.3, 0.5), cp + Vector3(0, 0.65, 0), mat(Color(0.4, 0.42, 0.38), 0.6, 0.4), true)
		box(Vector3(0.55, 0.25, 0.45), cp + Vector3(-0.4, 1.0 - (k % 2) * 0.4, 0), mat(Color(0.36, 0.38, 0.34), 0.6, 0.4))
	interactable("cabinet", L("build", "cabinet_prompt"), Vector3(-0.6, Y2 + 0.9, -3.0), Vector3(0.9, 1.4, 2.0), L("build", "cabinet_scan"), false)
	prop("server_rack", Vector3(-7.35, Y2, -2.5), PI / 2.0, 0.9, true)
	interactable("records", L("build", "records_prompt"), Vector3(-5.5, Y2 + 1.2, 0.3), Vector3(4.0, 2.0, 0.6), "", false)
	for k in 8:
		floor_quad(Vector2(0.21, 0.29), Vector3(rng.randf_range(-7.0, -1.5), Y2 + 0.005, rng.randf_range(-4.0, 0.0)), rng.randf() * TAU, tex_mat(Tex.paper(800 + k), Vector3.ONE, 0.9))
	_fluor(Vector3(-4.0, Y2 + H1, -2.0), 0.0, 0.5, true)
	# the generator room: warm, the hum a note higher
	_room(10.0, 16.0, z0, z1, Y2, H1, _brick, _floor2, _ceil, [], ["n"])
	var gen := Vector3(13.0, Y2, -1.0)
	box(Vector3(3.0, 1.6, 1.4), gen + Vector3(0, 0.8, 0), mat(Color(0.28, 0.34, 0.26), 0.6, 0.5), true)
	box(Vector3(3.2, 0.12, 1.6), gen + Vector3(0, 0.06, 0), _rust)
	for k in 6:
		box(Vector3(0.04, 1.2, 1.42), gen + Vector3(-1.2 + k * 0.48, 0.8, 0), _metal)
	var gauge := box(Vector3(0.3, 0.2, 0.02), gen + Vector3(0.9, 1.3, -0.72), glow(Color(1.0, 0.6, 0.2), 2.0))
	flickers.append(gauge)
	no_batch.append(gauge)
	interactable("generator", L("build", "generator_prompt"), gen + Vector3(0, 0.9, -0.5), Vector3(3.0, 1.6, 0.6), L("build", "generator_scan"), false)
	prop("fuse_panel", Vector3(15.8, Y2 + 0.9, -3.0), -PI / 2.0, 1.0, false)
	prop("power_box_01", Vector3(10.15, Y2 + 1.4, -2.5), PI / 2.0, 1.0, false)
	prop("Barrel_01", Vector3(15.3, Y2, 0.4), 0.0, 1.0, true)
	prop("modular_electric_cables", Vector3(10.2, Y2 + 0.4, -0.5), PI / 2.0, 1.0, false)
	_cables(Vector3(11.5, Y2 + 2.5, -1.0), Vector3(15.8, Y2 + 2.5, -1.0), 4)
	light(gen + Vector3(0, 2.0, -1.2), Color(1.0, 0.6, 0.3), 0.7, 5.0)
	_etched(Vector3(13.0, Y2 + 2.25, z1 - 0.17), PI, "g_gen", "Over the generator, on the brick, in grease: the rings. The gap in the outer ring was a smear where a palm had been pressed and dragged, many times, the way you would touch a doorframe for luck.")


## The stairs down at the east end of S: black brick, one light, the way
## to the hangar (A2-S2). Blocked until the floor is understood.
func _hangar_stairs() -> void:
	var x0 := 19.0
	for sd: float in [-1.0, 1.0]:
		_wall(Vector3(7.0, H1 + 3.5, 0.3), Vector3(x0 + 3.5, Y2 - 0.25, SZ + sd * 0.95), _brick_dark)
	box(Vector3(7.0, 0.3, 2.2), Vector3(x0 + 3.5, Y2 + H1 + 0.15, SZ), _ceil)
	_wall(Vector3(0.3, H1 + 3.5, 2.2), Vector3(x0 + 7.0, Y2 - 0.25, SZ), _brick_dark)
	var steps := 18
	for k in steps:
		var sx := x0 + 0.4 + k * 0.32
		box(Vector3(0.32, 0.2, 1.6), Vector3(sx, Y2 - 0.1 - k * 0.2, SZ), mat(Color(0.12, 0.12, 0.12), 0.85))
	solid_box(Vector3(0.3, 2.2, 1.6), Vector3(x0 + 0.35, Y2 + 1.1, SZ))
	for k in 5:
		box(Vector3(0.1, 0.12, 0.32), Vector3(x0 - 0.05, Y2 + 2.15, SZ - 0.64 + k * 0.32), mat(Color(0.8, 0.65, 0.1) if k % 2 == 0 else Color(0.05, 0.05, 0.05), 0.8))
	_sign("NO SUBJECTS BEYOND THIS POINT", Vector3(x0 - 0.17, Y2 + 2.45, SZ), -PI / 2.0, 0.0022, Color(0.85, 0.75, 0.4))
	prop("security_light", Vector3(x0 + 5.5, Y2 - 1.2, SZ - 0.8), 0.0, 1.0, false)
	light(Vector3(x0 + 5.5, Y2 - 1.6, SZ), Color(1.0, 0.55, 0.25), 1.2, 6.0)
	interactable("hangar_stairs", L("build", "hangar_stairs_prompt"), Vector3(x0 + 0.1, Y2 + 1.1, SZ), Vector3(0.6, 2.0, 1.6), "", false)



# ------------------------------------------------------------------ people

## Lynx (hair loose, too bright, the frames on), the two eyeless in yellow
## gowns who walk the corridor S with a hand on the brick, and Subject 41,
## who only exists in the recording.
func _people() -> void:
	lynx = figure(Color(0.09, 0.08, 0.1), Color(0.88, 0.74, 0.62),
		{"hair": Color(0.12, 0.08, 0.06), "long_hair": true, "legs": Color(0.1, 0.1, 0.12), "arms": true, "knees": true, "visor": true, "long_coat": true})
	lynx.position = Vector3(5.6, 7.2, -9.0)
	lynx.visible = false
	add_child(lynx)
	lynx_it = interactable("lynx", L("build", "lynx_prompt"), Vector3(0, 0.9, 0), Vector3(0.7, 1.9, 0.7), L("build", "lynx_scan"), false, lynx)
	set_active(lynx_it, false)
	var routes := [[Vector3(-15.0, Y2, SZ - 0.45), Vector3(3.0, Y2, SZ - 0.45)], [Vector3(16.0, Y2, SZ + 0.45), Vector3(-1.0, Y2, SZ + 0.45)]]
	var gown := Color(0.78, 0.66, 0.24)
	var pale := Color(0.74, 0.66, 0.6)
	for i in 2:
		var e := _gowned(gown, pale, Color(0.28, 0.26, 0.24))
		var hd: Node3D = e.get_meta("head")
		var hollow := mat(Color(0.015, 0.01, 0.01), 0.9)
		var crust := mat(Color(0.3, 0.12, 0.08), 0.7)
		for sd: float in [-1.0, 1.0]:
			box(Vector3(0.055, 0.032, 0.02), Vector3(sd * 0.045, 0.02, -0.113), hollow, false, hd)
			box(Vector3(0.016, 0.07, 0.01), Vector3(sd * 0.05, -0.03, -0.116), crust, false, hd)
		(e.get_meta("arms")[0] as Node3D).rotation = Vector3(0.25, 0.0, -1.0)
		var a: Vector3 = routes[i][0]
		var b: Vector3 = routes[i][1]
		e.position = a
		e.rotation.y = atan2(-(b - a).x, -(b - a).z)
		e.set_meta("eyeless", true)
		add_child(e)
		var it := interactable("eyeless%d" % i, L("build", "eyeless_prompt"), Vector3(0, 0.9, 0), Vector3(0.7, 1.9, 0.7), L("build", "eyeless_scan"), false, e)
		it.set_meta("eyeless", true)
		var snd := AudioStreamPlayer3D.new()
		snd.stream = main.sfx["step"]
		snd.unit_size = 3.0
		snd.max_distance = 20.0
		snd.volume_db = -4.0
		snd.position = Vector3(0, 0.2, 0)
		e.add_child(snd)
		eyeless.append({"node": e, "a": a, "b": b, "dir": 1.0, "mode": "patrol", "lost": 0.0, "snd": snd, "step": rng.randf()})
	subject41 = _gowned(gown, Color(0.8, 0.62, 0.5), Color(0.15, 0.1, 0.08))
	var sh: Node3D = subject41.get_meta("head")
	for sd: float in [-1.0, 1.0]:
		box(Vector3(0.02, 0.04, 0.04), Vector3(sd * 0.125, 0.03, -0.03), _white, false, sh)
	subject41.visible = false
	add_child(subject41)


func _gowned(gown: Color, skin: Color, hair: Color) -> Node3D:
	return figure(gown, skin, {"hair": hair, "legs": skin, "arms": true, "knees": true, "long_coat": true})


func scan_people() -> Array:
	return []


# ------------------------------------------------------------------ the scenes

var _intro_run := false

func intro() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if _intro_run or f.has("fac_woke"):
		return
	_intro_run = true
	f["cinematic"] = true
	main.player.crouch = 1.2
	main.player.pitch = 0.18
	await get_tree().create_timer(0.8).timeout
	main.play("whisper", -8.0, 0.45)
	ui.caption(L("intro", "breath_cap"), 4.5)
	await ui.think(L("intro", "think1"))
	await ui.think(L("intro", "think2"))
	ui.close()
	# the close-up: the mirror, matte black now
	var img: Image = await _picture(MIRROR + Vector3(0.4, -0.5, 3.4), MIRROR, 48.0)
	ui.show_picture(ImageTexture.create_from_image(img), L("intro", "closeup_cap"))
	main.play("pressure", -12.0, 0.8)
	ui.caption(L("intro", "breath_cap"), 4.0)
	await ui.think(L("intro", "think_family"))
	ui.hide_picture()
	await ui.think(L("intro", "think3"))
	ui.close()
	var tw := create_tween()
	tw.tween_property(main.player, "crouch", 0.0, 1.4).set_trans(Tween.TRANS_SINE)
	await tw.finished
	await main.player.face(MIRROR, 1.0)
	await ui.think(L("intro", "think4"))
	await ui.think(L("intro", "think5"))
	ui.close()
	f["fac_woke"] = true
	f.erase("cinematic")
	main.update_hud()


## "CARL!" Lynx comes up the stairwell from the floor below, too bright.
## The suspicion exchange, the three-way choice about the mirror, what this
## place is, then she comes with him.
func _lynx_arrive() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("lynx_found") or _busy:
		return
	_busy = true
	f["cinematic"] = true
	lynx.visible = true
	lynx.position = Vector3(5.6, 7.2, -9.0)
	main.play("slam", -18.0, 1.4)
	await ui.say("Lynx", L("lynx", "call"))
	await main.player.face(lynx.global_position + Vector3(0, 1.5, 0), 0.8)
	await _lynx_go(Vector3(5.6, Y0, -6.3), 2.6)
	var me: Vector3 = main.player.global_position
	await _lynx_go(me + (DOORWAY - me).normalized() * 1.5 + Vector3(0, Y0 - me.y, 0), 2.0)
	lynx_state = "stand"
	turn_to(lynx, main.player.global_position, 0.3)
	await main.player.face(lynx.global_position + Vector3(0, 1.55, 0), 0.6)
	await ui.think(L("lynx", "think_off"))
	await ui.think(L("lynx", "think_me"))
	await ui.say("Carl", L("lynx", "carl1"))
	await ui.say("Lynx", L("lynx", "lynx1"))
	await ui.think(L("lynx", "think_laugh"))
	await ui.say("Lynx", L("lynx", "lynx2"))
	await ui.say("Lynx", L("lynx", "lynx3"))
	await ui.think(L("lynx", "think_eyes"))
	await ui.say("Lynx", L("lynx", "lynx4"))
	await ui.think(L("lynx", "think_nathan"))
	await ui.say("Lynx", L("lynx", "lynx5"))
	await ui.think(L("lynx", "think_excite"))
	var i: int = await ui.choose(LA("lynx", "choice"))
	match i:
		0:
			# the whole mirror: T:lynx +1
			await ui.say("Carl", L("lynx", "carl_whole"))
			await ui.say("Lynx", L("lynx", "lynx_whole"))
			await ui.think(L("lynx", "think_whole"))
			main.add_trust("lynx", 1)
			f["told_lynx_mirror"] = true
			main.log_line("choice", L("lynx", "why_whole"))
		1:
			# the half-truth: no effect
			await ui.say("Carl", L("lynx", "carl_half"))
			await ui.say("Lynx", L("lynx", "lynx_half"))
			await ui.think(L("lynx", "think_half"))
		_:
			# how did she get in: T:lynx -1, and the clue
			await ui.say("Carl", L("lynx", "carl_door"))
			await ui.say("Lynx", L("lynx", "lynx_door"))
			await ui.think(L("lynx", "think_door"))
			await ui.say("Lynx", L("lynx", "lynx_door2"))
			await ui.say("Carl", L("lynx", "carl_door2"))
			main.add_trust("lynx", -1)
			f["lynx_unlocked_clue"] = true
			main.log_line("clue", L("lynx", "door_log"))
	await ui.think(L("lynx", "think_presence"))
	await ui.say("Carl", L("lynx", "carl_place"))
	ui.close()
	# she kneels by the rusted console and brushes off the dust
	await _lynx_go(Vector3(-3.7, Y0, 4.1), 2.2)
	lynx.rotation.y = PI
	lynx_state = "kneel"
	lynx.position.y = Y0 - 0.42
	Anim.crouch(lynx)
	await ui.say("Lynx", L("lynx", "lynx_place"))
	_lynx_unpose()
	lynx.position.y = Y0
	lynx_state = "stand"
	turn_to(lynx, main.player.global_position, 0.4)
	await ui.say("Lynx", L("lynx", "lynx_place2"))
	await ui.say("Lynx", L("lynx", "lynx_place3"))
	await ui.say("Lynx", L("lynx", "lynx_place4"))
	await ui.say("Carl", L("lynx", "carl_cult"))
	await ui.say("Lynx", L("lynx", "lynx_cult"))
	await ui.say("Lynx", L("lynx", "follow"))
	ui.close()
	f["lynx_found"] = true
	set_active(lynx_it, true)
	_follow()
	f.erase("cinematic")
	_busy = false
	main.update_hud()


## Lynx walks to `p` in a straight line; returns when she is there.
func _lynx_go(p: Vector3, speed := 2.0) -> void:
	lynx_target = p
	lynx.set_meta("speed", speed)
	lynx_state = "goto"
	var t := 0.0
	while lynx.position.distance_to(p) > 0.12 and t < 10.0:
		await get_tree().process_frame
		t += get_process_delta_time()
	lynx.position = p
	lynx_state = "stand"


func _follow() -> void:
	_trail.clear()
	_trail.append(lynx.position)
	_li = 0
	lynx_state = "follow"


## Back to standing from a sit or a crouch.
func _lynx_unpose() -> void:
	var body: Node3D = lynx.get_meta("body")
	body.rotation.x = 0.0
	var head: Node3D = lynx.get_meta("head")
	head.position.z = 0.0
	head.rotation.x = 0.0
	for l in lynx.get_meta("legs"):
		(l as Node3D).rotation.x = 0.0
	for k in lynx.get_meta("knees", []):
		(k as Node3D).rotation.x = 0.0
	for a in lynx.get_meta("arms"):
		(a as Node3D).rotation.x = 0.0


## Put Lynx just behind Carl (after a teleport, or when she is far behind).
func _snap_lynx() -> void:
	if not lynx or not lynx.visible:
		return
	var pp: Vector3 = main.player.global_position
	var at := pp + Basis(Vector3.UP, main.player.yaw) * Vector3(0.7, 0, 1.3)
	if _trail.size() > 4:
		at = _trail[_trail.size() - 4]
	lynx.position = Vector3(at.x, pp.y, at.z)
	_trail.clear()
	_trail.append(lynx.position)
	_li = 0


## Sublevel 1: the office. Lynx sits at the closest terminal; the breath
## at Carl's left ear (the first stealth cue); the joint report, the
## Hameron log, the HUD flash; "we are exactly where we're meant to be."
func _office_scene() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("office_read"):
		await ui.think(L("office", "again"))
		return
	if not f.has("lynx_found") or _busy:
		await ui.think(L("office", "need_lynx"))
		return
	_busy = true
	f["cinematic"] = true
	if lynx.position.distance_to(OFFICE_CHAIR) > 7.0:
		lynx.position = Vector3(0.0, Y1, -12.6)
	await _lynx_go(OFFICE_CHAIR + Vector3(0.0, 0.0, -0.6), 2.2)
	lynx.position = OFFICE_CHAIR + Vector3(0, -0.29, 0)
	lynx.rotation.y = PI
	lynx_state = "sit"
	Anim.sit(lynx, 0.05)
	for a in lynx.get_meta("arms"):
		(a as Node3D).rotation.x = 1.1
	main.play("keys", -10.0)
	await ui.think(L("office", "breath1"))
	# the breath: hot and metallic at his left ear; the HUD shorts out
	main.play("whisper", 0.0, 0.42)
	main.play("pressure", -6.0, 1.3)
	ui.glitch(1.0, 1.8)
	if main.frames_on:
		ui.flash(1.0)
	main.player.shake(0.35)
	await ui.think(L("office", "breath2"))
	f["fac_breath"] = true
	ui.show_toast(L("office", "breath_toast"), 4.0)
	await ui.say("Lynx", L("office", "lynx_pale"))
	await ui.think(L("office", "think_hr"))
	await ui.say("Carl", L("office", "carl_cold"))
	await ui.say("Lynx", L("office", "lynx_screens"))
	term_screen_m.emission_enabled = true
	term_screen_m.emission = Color(0.3, 0.85, 0.6)
	term_screen_m.emission_energy_multiplier = 1.1
	term_light.light_energy = 0.9
	main.play("on", -10.0, 0.6)
	await ui.think(L("office", "think_dust"))
	ui.close()
	# the archive, as terminal reads
	ui.laptop_open(true)
	ui.smear.visible = false
	var log: RichTextLabel = ui.laptop_log
	log.append_text("[color=#557766]%s[/color]\n\n" % L("office", "term_top"))
	log.append_text(L("office", "dir"))
	await ui.think(L("office", "think_date"))
	main.play("keys", -12.0)
	log.append_text(L("office", "slides_title"))
	await ui.say("Lynx", L("office", "lynx_date"))
	await ui.think(L("office", "think_snap"))
	log.append_text(L("office", "slides_words"))
	await ui.think(L("office", "think_words"))
	f["ev_darpa_slides"] = true
	main.log_line("evidence", L("office", "slides_log"))
	main.play("keys", -12.0, 1.1)
	log.clear()
	log.append_text(L("office", "log_dir"))
	log.append_text(L("office", "log_head"))
	log.append_text(L("office", "log_1"))
	await ui.think(L("office", "think_prose"))
	log.append_text(L("office", "log_2"))
	await ui.say("Lynx", L("office", "lynx_theta"))
	await ui.say("Carl", L("office", "carl_dreams"))
	log.append_text(L("office", "log_3"))
	await ui.say("Lynx", L("office", "lynx_optimise"))
	await ui.say("Carl", L("office", "carl_dufredy"))
	f["ev_hameron_log_1"] = true
	main.log_line("evidence", L("office", "hameron_log"))
	ui.laptop_open(false)
	# the HUD flash: a number for him. He may dismiss it; it is logged.
	await ui.think(L("office", "buzz"))
	main.play("glitch", -2.0)
	ui.flash(1.2)
	ui.glitch(0.8, 1.0)
	await ui.say("", L("office", "flash"))
	var i: int = await ui.choose(LA("office", "flash_choice"))
	if i == 1:
		await ui.say("", L("office", "flash_again"))
	main.add_connection(2.0, L("office", "flash_why"))
	main.log_line("hud", L("office", "flash_log"))
	f["subject_1235_seen"] = true
	await ui.think(L("office", "think_flash"))
	# Lynx springs upright
	_lynx_unpose()
	lynx.position = OFFICE_CHAIR + Vector3(0.6, 0, -0.5)
	lynx_state = "stand"
	turn_to(lynx, main.player.global_position)
	await ui.say("Lynx", L("office", "lynx_shit"))
	await ui.say("Carl", L("office", "carl_yup"))
	await ui.say("Lynx", L("office", "lynx_store"))
	await ui.think(L("office", "think_easy"))
	await ui.think(L("office", "think_path"))
	await ui.say("Carl", L("office", "carl_eyeless"))
	await ui.say("Lynx", L("office", "lynx_scripture"))
	await ui.say("Carl", L("office", "carl_meant"))
	ui.close()
	f["office_read"] = true
	_open_stair_b()
	_follow()
	f.erase("cinematic")
	_busy = false
	main.update_hud()


func _open_stair_b() -> void:
	if stair_panel:
		stair_panel.visible = false
	if stair_body:
		stair_body.queue_free()
		stair_body = null
	main.play("door", -8.0, 0.8)


## The foot of the second stairwell: Sublevel Two, Experimental floor.
func _arrive() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("fac_sub2") or _busy:
		return
	_busy = true
	f["fac_sub2"] = true
	await ui.think(L("sub2", "arrive"))
	ui.close()
	_busy = false
	main.update_hud()


## The first sight of one of them, once.
func _first_eyeless() -> void:
	var ui = main.ui
	if ui.busy or _busy:
		_eyeless_seen = false
		return
	ui.show_toast(L("sub2", "cue"), 6.0)
	await ui.think(L("sub2", "first_eyeless"))
	ui.close()


## Housing Pens 1-6, each with its card; three seen and Lynx breaks.
func _pen_look(i: int) -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var key := "pen_%d" % (i + 1)
	var first := not f.has(key)
	var text := L("pens", "pen") % (i + 1)
	if i == 0:
		text = L("pens", "pen1")
	elif i == 3:
		text = L("pens", "pen4")
	elif i == 5:
		text = L("pens", "pen6")
	await ui.think(text)
	if first:
		f[key] = true
		if _pens_seen() == 1:
			main.play("tap", -12.0, 1.6)
			ui.glitch(0.4, 0.4)
			await ui.think(L("pens", "flicker"))
			await ui.think(L("pens", "think_lived"))
		if i == 3:
			main.add_connection(1.0, L("pens", "pen_why"))
			main.log_line("pen", L("build", "pen_scan").replace("\n", "  ") % [4, "41", "FREED  -  PROPHET"])
		elif i == 5:
			main.log_line("pen", L("build", "pen_scan").replace("\n", "  ") % [6, "12-35", "PENDING"])
	ui.close()
	if _pens_seen() >= 3 and not f.has("lynx_broke"):
		await _breakdown()


func _pens_seen() -> int:
	var n := 0
	for k in 6:
		if main.flags.has("pen_%d" % (k + 1)):
			n += 1
	return n


## "She broke down, her body shaking with uncontrollable sobs." Once.
func _breakdown() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("lynx_broke") or not f.has("lynx_found") or _busy:
		return
	_busy = true
	f["cinematic"] = true
	lynx_state = "stand"
	turn_to(lynx, main.player.global_position, 0.4)
	await main.player.face(lynx.global_position + Vector3(0, 1.5, 0), 0.6)
	await ui.say("Lynx", L("pens", "lynx_terrible"))
	await ui.think(L("pens", "think_curious"))
	await ui.say("Carl", L("pens", "carl_outages"))
	(lynx.get_meta("head") as Node3D).rotation.x = 0.45
	(lynx.get_meta("body") as Node3D).rotation.x = 0.2
	await ui.think(L("pens", "think_break"))
	await ui.say("Lynx", L("pens", "lynx_knew"))
	var i: int = await ui.choose(LA("pens", "choice"))
	if i == 0:
		await ui.say("Carl", L("pens", "carl_hand"))
		await ui.think(L("pens", "think_hand"))
		main.add_trust("lynx", 1)
		f["lynx_hand"] = true
	else:
		await ui.think(L("pens", "think_silent"))
	_lynx_unpose()
	await ui.say("Lynx", L("pens", "lynx_sorry"))
	ui.close()
	f["lynx_broke"] = true
	_follow()
	f.erase("cinematic")
	_busy = false
	main.update_hud()


## Perturbation Lab 1, the first time: the eye on the ceiling.
func _lab_beat() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("fac_lab") or _busy:
		return
	_busy = true
	f["fac_lab"] = true
	f["cinematic"] = true
	await ui.think(L("lab", "enter"))
	if f.has("lynx_found"):
		lynx_state = "stand"
		(lynx.get_meta("head") as Node3D).rotation.x = -0.5
		await ui.say("Lynx", L("lab", "lynx_ceiling"))
		await main.player.face(LAB_CHAIR + Vector3(0, H1, 0), 1.0)
		await ui.think(L("lab", "think_ceiling"))
		await ui.say("Carl", L("lab", "carl_ladders"))
		await ui.think(L("lab", "think_flat"))
		(lynx.get_meta("head") as Node3D).rotation.x = 0.0
		await ui.think(L("lab", "think_nod"))
		await ui.say("Lynx", L("lab", "lynx_point"))
		_follow()
	else:
		await ui.think(L("lab", "think_ceiling"))
	ui.close()
	f.erase("cinematic")
	_busy = false
	main.update_hud()


## Pen 4's east wall: brick with the frames off, a door with them on. The
## door is in the eye layer, so passing it is a step, not a walk.
func _eye_door_use() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var pp: Vector3 = main.player.global_position
	var going_in := pp.x < EYE_DOOR.x
	if not main.frames_on:
		await ui.think(L("pens", "eye_wall_hint") if f.has("pen_4") else L("pens", "eye_wall"))
		return
	if going_in and not f.has("lynx_broke") and f.has("lynx_found"):
		await _breakdown()
	main.play("door", -6.0, 0.7)
	main.play("glitch", -10.0, 0.7)
	ui.glitch(0.5, 0.6)
	if going_in:
		if not f.has("eye_door_used"):
			await ui.think(L("pens", "eye_door"))
			f["eye_door_used"] = true
		ui.close()
		main.player.position = Vector3(EYE_DOOR.x + 0.9, Y2 + 0.05, EYE_DOOR.z)
		main.player.yaw = -PI / 2.0
	else:
		await ui.think(L("pens", "eye_back"))
		ui.close()
		main.player.position = Vector3(EYE_DOOR.x - 0.9, Y2 + 0.05, EYE_DOOR.z)
		main.player.yaw = PI / 2.0
	main.player.velocity = Vector3.ZERO
	if lynx_state == "follow":
		var side := 1.0 if going_in else -1.0
		lynx.position = Vector3(EYE_DOOR.x + side * 1.5, main.player.global_position.y, EYE_DOOR.z + 0.9)
		_trail.clear()
		_trail.append(lynx.position)
		_li = 0
	if going_in and not f.has("fac_lullaby"):
		await _obs_jolt()


## The observation room: the ice-hot jolt, Mira's voice singing through the
## HUD (W:hush), the frames torn off and thrown, Lynx at the monitor.
func _obs_jolt() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("fac_lullaby") or _busy:
		return
	_busy = true
	f["cinematic"] = true
	await ui.think(L("obs", "enter"))
	main.play("static", -2.0)
	main.play("glitch", -2.0, 0.6)
	ui.glitch(1.0, 2.5)
	main.player.shake(0.4)
	await ui.think(L("obs", "jolt"))
	main.play("chant", -6.0, 1.9)
	ui.caption(L("obs", "lullaby_cap"), 5.0)
	await ui.say("", L("obs", "lullaby1"))
	main.play("static", -4.0, 0.7)
	ui.glitch(0.8, 1.2)
	await ui.think(L("obs", "ringing"))
	main.play("chant", -8.0, 2.0)
	await ui.say("", L("obs", "lullaby2"))
	main.learn("hush")
	main.log_line("lullaby", L("obs", "hush_log"))
	if main.frames_on:
		main.toggle_frames()
		main.play("tap", -4.0, 0.7)
		await ui.think(L("obs", "tear"))
	else:
		await ui.think(L("obs", "tear_off"))
	await ui.think(L("obs", "lynx_watch"))
	await ui.think(L("obs", "intact"))
	ui.close()
	f["fac_lullaby"] = true
	if lynx.visible:
		await _lynx_go(OBS_CHAIR + Vector3(0, 0, 0.5), 1.8)
		lynx.position = OBS_CHAIR + Vector3(0, -0.29, 0)
		lynx.rotation.y = 0.0
		lynx_state = "sit"
		Anim.sit(lynx, 0.05)
		for a in lynx.get_meta("arms"):
			(a as Node3D).rotation.x = 1.1
	await ui.think(L("obs", "folder"))
	ui.close()
	f.erase("cinematic")
	_busy = false
	main.update_hud()


## The Perturbation Session Recordings, 59 files. Frames on: the HUD lights
## up the one, and Carl points. Frames off: Lynx scrubs, three decoys, and
## then finds it by date.
func _monitor() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("ev_subject41_video"):
		await ui.think(L("obs", "again"))
		return
	if not f.has("fac_lullaby"):
		await ui.think(L("obs", "enter"))
		return
	if main.frames_on:
		main.play("glitch", -8.0, 1.4)
		ui.glitch(0.5, 0.8)
		await ui.think(L("obs", "highlight"))
		await ui.think(L("obs", "point"))
		ui.close()
		await _video()
		return
	if _decoys >= 3:
		await ui.think(L("obs", "found_off"))
		ui.close()
		await _video()
		return
	var i: int = await ui.choose(LA("obs", "files"))
	main.play("keys", -12.0, 1.2)
	await ui.think(str(LA("obs", "decoys")[clampi(i, 0, 3)]))
	_decoys += 1
	if _decoys == 2:
		await ui.think(L("obs", "strain"))
	if _decoys >= 3:
		await ui.think(L("obs", "found_off"))
		ui.close()
		await _video()


## Observation_Log_S41_09-03-19, six frames from the lab's camera (the
## grainiest pictures in the game), the eye-removal frame behind a black
## panel, and the last frame: SUBJECT FREED.
func _video() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("ev_subject41_video") or _busy:
		return
	_busy = true
	f["cinematic"] = true
	main.play("static", -10.0)
	await ui.show_card(L("obs", "v_card"), 1.6)
	_lab_2019(true)
	_seat_subject(true)
	# 1: the flickering lights
	var tex: Texture2D = _vhs(await _picture(LAB_CAM + Vector3(-0.2, -0.05, 0.2), LAB_CHAIR + Vector3(0, 0.9, 0), 60.0), 1.0, 1)
	ui.show_picture(tex, L("obs", "v1_cap"))
	await ui.say(str(LA("obs", "v1_aris")[0]), str(LA("obs", "v1_aris")[1]))
	await ui.think(L("obs", "v1_say"))
	# 2: "cold static. In my teeth"
	_lab_light(0.45)
	tex = _vhs(await _picture(LAB_CHAIR + Vector3(0.8, 1.55, -1.1), LAB_CHAIR + Vector3(0, 1.38, 0), 42.0), 1.2, 2)
	ui.show_picture(tex, L("obs", "v2_cap"))
	main.play("static", -12.0, 1.3)
	await ui.say(str(LA("obs", "v2_sub")[0]), str(LA("obs", "v2_sub")[1]))
	await ui.say(str(LA("obs", "v2_aris")[0]), str(LA("obs", "v2_aris")[1]))
	# 3: the monitor, typing itself
	_lab_light(1.0)
	lab_text.text = L("obs", "v3_text") + "\n\n" + L("obs", "v3_text2")
	lab_text.visible = true
	tex = _vhs(await _picture(LAB_CHAIR + Vector3(0.3, 1.5, -0.25), LAB_SCREEN, 34.0), 1.0, 3)
	ui.show_picture(tex, L("obs", "v3_cap"))
	await ui.think(L("obs", "v3_say"))
	await ui.say(str(LA("obs", "v3_sub")[0]), str(LA("obs", "v3_sub")[1]))
	await ui.say(str(LA("obs", "v3_sub2")[0]), str(LA("obs", "v3_sub2")[1]))
	# 4: THE DREAM IS THE WALL, and the neural spike on the second screen
	lab_text.text = L("obs", "v4_text")
	lab_eeg.visible = true
	tex = _vhs(await _picture(LAB_CHAIR + Vector3(1.2, 1.55, 0.2), Vector3(9.4, Y2 + 1.2, -21.5), 48.0), 1.1, 4)
	ui.show_picture(tex, L("obs", "v4_cap"))
	await ui.think(L("obs", "v4_say"))
	await ui.say(str(LA("obs", "v4_sub")[0]), str(LA("obs", "v4_sub")[1]))
	await ui.say(str(LA("obs", "v4_aris")[0]), str(LA("obs", "v4_aris")[1]))
	# 5: CLOSE THE EYES THAT LIE; he stands and faces the camera
	lab_text.text = L("obs", "v5_text")
	_seat_subject(false)
	tex = _vhs(await _picture(LAB_CAM + Vector3(-0.2, -0.05, 0.2), subject41.global_position + Vector3(0, 1.45, 0), 40.0), 1.3, 5)
	ui.show_picture(tex, L("obs", "v5_cap"))
	await ui.think(L("obs", "v5_say"))
	await ui.say(str(LA("obs", "v5_sub")[0]), str(LA("obs", "v5_sub")[1]))
	await ui.say(str(LA("obs", "v5_sub2")[0]), str(LA("obs", "v5_sub2")[1]))
	ui.hide_picture()
	ui.close()
	# the frame behind the content setting: a black panel and the caption
	main.play("glitch", 0.0, 0.5)
	main.play("static", 0.0, 0.6)
	ui.glitch(1.0, 1.0)
	await ui.show_card(L("obs", "v6_black"), 2.6)
	# 6: black, SUBJECT FREED in red
	main.play("sting", -6.0, 0.7)
	await ui.show_card(L("obs", "v6_freed"), 2.4)
	_lab_2019(false)
	subject41.visible = false
	await ui.think(L("obs", "after1"))
	await ui.think(L("obs", "after2"))
	if lynx.visible:
		_lynx_unpose()
		lynx.position = OBS_CHAIR + Vector3(0.5, 0, 0.6)
		lynx_state = "stand"
		turn_to(lynx, main.player.global_position)
	await ui.think(L("obs", "after3"))
	ui.close()
	f["ev_subject41_video"] = true
	main.log_line("evidence", L("obs", "video_log"))
	f["facility_done"] = true
	if lynx.visible:
		_follow()
	f.erase("cinematic")
	_busy = false
	main.update_hud()


## The lab as it was in 2019 (bright white, clean) or as it is now.
func _lab_2019(on: bool) -> void:
	for n in lab_now:
		(n as Node3D).visible = not on
	_lab_light(1.0 if on else 0.0)
	if not on:
		lab_text.visible = false
		lab_eeg.visible = false


func _lab_light(k: float) -> void:
	for l in lab_lights:
		(l[0] as OmniLight3D).light_energy = float(l[1]) * k


func _seat_subject(seated: bool) -> void:
	subject41.visible = true
	if seated:
		subject41.position = LAB_CHAIR + Vector3(0, -0.28, 0)
		subject41.rotation.y = 0.0
		Anim.sit(subject41, 0.08)
		for a in subject41.get_meta("arms"):
			(a as Node3D).rotation.x = 0.55
	else:
		for l in subject41.get_meta("legs"):
			(l as Node3D).rotation.x = 0.0
		for k in subject41.get_meta("knees", []):
			(k as Node3D).rotation.x = 0.0
		(subject41.get_meta("body") as Node3D).rotation.x = 0.0
		for a in subject41.get_meta("arms"):
			(a as Node3D).rotation.x = 0.12
		subject41.position = LAB_CHAIR + Vector3(0.0, 0.0, -0.6)
		turn_to(subject41, LAB_CAM)
		(subject41.get_meta("head") as Node3D).rotation.x = -0.35


## A picture from a camera in the level (the close-ups and the recording).
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
	for i in 4:
		await RenderingServer.frame_post_draw
	var img := vp.get_texture().get_image()
	vp.queue_free()
	return img


## Thirty-year-old surveillance tape: low resolution, a green-grey cast,
## grain, scanlines, rolling bands, a REC dot and a timestamp bar.
func _vhs(src: Image, grain: float, n: int) -> ImageTexture:
	var img := src.duplicate() as Image
	img.convert(Image.FORMAT_RGB8)
	var w := 200
	var h := 125
	img.resize(w, h, Image.INTERPOLATE_BILINEAR)
	var r := RandomNumberGenerator.new()
	r.seed = 1900 + n
	var band := r.randi_range(10, h - 20)
	for y in h:
		var roll := 0.0
		if absi(y - band) < 4:
			roll = 0.12
		var dark := 0.82 if y % 2 == 0 else 1.0
		for x in w:
			var c := img.get_pixel(x, y)
			var l := c.r * 0.3 + c.g * 0.59 + c.b * 0.11
			var g := (r.randf() - 0.5) * 0.16 * grain
			var cx := (x - w * 0.5) / (w * 0.5)
			var cy := (y - h * 0.5) / (h * 0.5)
			var vig := 1.0 - 0.35 * (cx * cx + cy * cy)
			var v := clampf((l * 1.15 + g + roll) * dark * vig, 0.0, 1.0)
			img.set_pixel(x, y, Color(v * 0.86, v * 1.0, v * 0.88))
	# REC, a red dot; the timestamp as a bar of white blocks
	for y in range(6, 11):
		for x in range(6, 11):
			img.set_pixel(x, y, Color(0.95, 0.1, 0.08))
	for k in 10:
		if k == 2 or k == 5:
			continue
		for y in range(h - 12, h - 6):
			for x in range(8 + k * 6, 12 + k * 6):
				img.set_pixel(x, y, Color(0.9, 0.92, 0.88))
	img.resize(w * 3, h * 3, Image.INTERPOLATE_NEAREST)
	return ImageTexture.create_from_image(img)


## One of the eyeless reached him: +5 C, and he comes to at the foot of
## the stairwell. No game over.
func _touched() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if _busy:
		return
	_busy = true
	_touch_cd = 6.0
	f["cinematic"] = true
	main.play("whisper", -2.0, 0.5)
	main.play("pressure", -6.0, 1.4)
	ui.glitch(1.0, 1.4)
	main.player.shake(0.5)
	await ui.think(L("eyeless", "touch1"))
	ui.close()
	main.add_connection(5.0, L("eyeless", "touch_why"))
	main.log_line("touch", L("eyeless", "touch_log"))
	f["fac_touched"] = true
	await ui.fade_to(1.0, 0.6)
	main.player.position = STAIR_B_FOOT + Vector3(0.4, 0, 0.3)
	main.player.velocity = Vector3.ZERO
	main.player.yaw = -PI / 2.0
	main.player.pitch = 0.0
	for e in eyeless:
		var n: Node3D = e["node"]
		n.position = e["a"]
		e["mode"] = "patrol"
		e["dir"] = 1.0
	if lynx.visible:
		lynx.position = STAIR_B_FOOT + Vector3(1.4, -0.05, -0.4)
		turn_to(lynx, main.player.global_position)
		_trail.clear()
		_trail.append(lynx.position)
		_li = 0
	await get_tree().create_timer(0.6).timeout
	await ui.fade_to(0.0, 0.8)
	await ui.think(L("eyeless", "touch2"))
	if lynx.visible:
		await ui.say("Lynx", L("eyeless", "touch_lynx"))
	ui.close()
	f.erase("cinematic")
	_busy = false
	main.update_hud()


## The stairs down at the end of the corridor: Act 2, scene 2.
func _leave() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if not f.has("facility_done"):
		await ui.think(L("hangar", "not_yet"))
		return
	if _ended:
		return
	_ended = true
	f["cinematic"] = true
	main.play("chant", -26.0, 0.8)
	await ui.think(L("hangar", "go"))
	await ui.think(L("hangar", "lynx"))
	ui.close()
	f.erase("cinematic")
	if not main._selftest:
		main.load_level("Hangar")


# ------------------------------------------------------------------ interactions

func interact(node: Object) -> bool:
	var ui = main.ui
	var f: Dictionary = main.flags
	match str(node.get_meta("id")):
		"doorway":
			if not f.has("lynx_found"):
				await _lynx_arrive()
			else:
				await ui.think(L("side", "sign1"))
		"lynx":
			var k := "again"
			if f.has("facility_done"):
				k = "again_after"
			elif f.has("fac_sub2") and not f.has("lynx_broke"):
				k = "again_pens"
			elif not f.has("office_read"):
				k = "again_office"
			await ui.say("Lynx", L("lynx", k))
		"mirror":
			await ui.think(L("side", "mirror"))
			if f.has("twin_born"):
				await ui.think(L("side", "mirror_twin"))
		"flag":
			await ui.think(L("side", "flag"))
			if not f.has("fac_flag"):
				f["fac_flag"] = true
				main.add_connection(1.0, "the flag")
		"crt":
			await ui.think(L("side", "crt"))
		"console":
			await ui.think(L("side", "console"))
		"sign1":
			await ui.think(L("side", "sign1"))
		"sign2":
			await ui.think(L("side", "sign2"))
		"office_door":
			await ui.think(L("office", "door"))
			await ui.think(L("office", "enter"))
		"terminal":
			await _office_scene()
		"desktop":
			await ui.think(L("office", "desktop"))
		"whiteboard":
			await ui.think(L("office", "whiteboard"))
		"quarters":
			await ui.think(L("side", "quarters"))
		"offering":
			if f.has("offering_sticks"):
				await ui.think(L("side", "offering_had"))
			else:
				await ui.think(L("side", "offering"))
				f["offering_sticks"] = true
				offering_n.visible = false
				main.log_line("item", L("side", "sticks_log"))
				ui.show_toast("Sticks (offering)", 2.5)
		"gym":
			await ui.think(L("side", "gym"))
		"gym_bike":
			await ui.think(L("side", "bike"))
		"wire":
			if f.has("offering_wire"):
				await ui.think(L("side", "wire_had"))
			else:
				await ui.think(L("side", "wire"))
				f["offering_wire"] = true
				wire_n.visible = false
				main.log_line("item", L("side", "wire_log"))
				ui.show_toast("Wire (offering)", 2.5)
		"sealed":
			await ui.think(L("side", "sealed"))
		"service":
			await ui.think(L("side", "service"))
		"fuse":
			await ui.think(L("side", "fuse"))
		"stair_b":
			if not f.has("office_read"):
				if f.has("lynx_found"):
					await ui.think(L("sub2", "stair_locked"))
				else:
					await ui.think(L("side", "sealed"))
			elif not f.has("fac_stair_talk"):
				f["fac_stair_talk"] = true
				await ui.say("Carl", L("sub2", "careful"))
				await ui.say("Lynx", L("sub2", "lynx_hope"))
			else:
				await ui.think(L("sub2", "stair_open"))
		"pen1", "pen2", "pen3", "pen4", "pen5", "pen6":
			await _pen_look(int(str(node.get_meta("id")).substr(3)) - 1)
		"eye_wall":
			await ui.think(L("pens", "eye_wall_hint") if f.has("pen_4") else L("pens", "eye_wall"))
		"eye_door":
			await _eye_door_use()
		"obs_door":
			if f.has("facility_done"):
				if obs_body:
					main.play("slam", -6.0, 0.9)
					await ui.think(L("pens", "obs_push"))
					obs_panel.visible = false
					obs_body.queue_free()
					obs_body = null
				else:
					await ui.think(L("pens", "obs_open"))
			else:
				await ui.think(L("pens", "obs_locked"))
		"lab_door":
			await ui.think(L("lab", "door"))
		"chair":
			await ui.think(L("lab", "chair"))
		"lab_monitor":
			await ui.think(L("lab", "monitor"))
			if main.frames_on:
				await ui.think(L("lab", "monitor_on"))
		"monitor":
			await _monitor()
		"glass":
			await ui.think(L("side", "glass") if main.player.global_position.x < 5.0 else L("side", "glass_lab"))
		"camera":
			await ui.think(L("obs", "camera"))
		"rack":
			await ui.think(L("side", "rack"))
		"cabinet":
			await ui.think(L("side", "cabinet"))
		"records":
			await ui.think(L("side", "records"))
		"showers":
			await ui.think(L("side", "showers"))
		"gowns":
			await ui.think(L("side", "gowns"))
		"generator":
			await ui.think(L("side", "generator"))
			main.player.shake(0.1)
		"hangar_stairs":
			await _leave()
		"eyeless0", "eyeless1":
			await ui.think(L("eyeless", "look_on") if main.frames_on else L("eyeless", "look_off"))
		_:
			return false
	return true


# ------------------------------------------------------------------ each frame

func tick(delta: float) -> void:
	if not main or not main.player:
		return
	var pp: Vector3 = main.player.global_position
	var f: Dictionary = main.flags
	_tick_lynx(delta, pp)
	_tick_eyeless(delta, pp)
	# the eye layer: the door in pen 4
	var on: bool = main.frames_on
	if eye_door and eye_door.visible != on:
		eye_door.visible = on
		(eye_door.get_meta("plug") as Node3D).visible = not on
		set_active(eye_door_it, on)
		set_active(eye_wall_it, not on)
	# fluorescent tubes: steady and dim, one in three dips now and then
	for fl in fluor_lights:
		var l: OmniLight3D = fl[0]
		var ph: float = fl[2]
		var dip := fmod(_t + ph, 9.0) < 0.14
		l.light_energy = float(fl[1]) * (0.35 if dip else 0.93 + 0.07 * sin(_t * 1.7 + ph))
		if fl[3]:
			(fl[3] as Node3D).visible = not dip
	# the observation monitor: pale blue, and the file pulses for the frames
	if obs_screen_m:
		var e := 1.3 + sin(_t * 2.0) * 0.08
		if on and f.has("fac_lullaby") and not f.has("ev_subject41_video"):
			e += 0.8 + sin(_t * 9.0) * 0.6
		obs_screen_m.emission_energy_multiplier = e
	# beats: each needs its flags, and some a place as well
	if _busy or f.has("cinematic") or main.ui.busy:
		return
	if f.has("fac_woke") and not f.has("lynx_found"):
		_lynx_timer += delta
		if pp.distance_to(DOORWAY) < 3.2 or _lynx_timer > 40.0:
			_lynx_arrive()
	elif f.has("office_read") and not f.has("fac_sub2") and pp.y < Y2 + 1.2:
		_arrive()
	elif f.has("fac_sub2") and not f.has("fac_lab") and _in_lab(pp):
		_lab_beat()
	if f.has("fac_breath") and not _eyeless_seen and pp.y < Y2 + 1.5:
		for e in eyeless:
			if pp.distance_to((e["node"] as Node3D).position) < 18.0:
				_eyeless_seen = true
				_first_eyeless()
				break


func _in_lab(p: Vector3) -> bool:
	return p.x > 5.2 and p.x < 11.4 and p.z > -22.4 and p.z < -17.4 and p.y < Y2 + 1.5


func _in_s(p: Vector3) -> bool:
	return p.z > SZ - 1.4 and p.z < SZ + 1.4 and p.x > -34.0 and p.x < 19.0 and p.y < Y2 + 1.5


## Lynx: walks Carl's breadcrumbs (so she takes the doors and the stairs
## he took), keeps a step behind, and is never seen by the eyeless.
func _tick_lynx(delta: float, pp: Vector3) -> void:
	if not lynx or not lynx.visible:
		return
	match lynx_state:
		"goto":
			var d := lynx_target - lynx.position
			var spd: float = lynx.get_meta("speed", 2.0)
			if d.length() > 0.05:
				lynx.position = lynx.position.move_toward(lynx_target, spd * delta)
				var hd := Vector2(d.x, d.z)
				if hd.length() > 0.05:
					lynx.rotation.y = lerp_angle(lynx.rotation.y, atan2(-d.x, -d.z), minf(1.0, delta * 8.0))
				Anim.walk(lynx, _t, spd / 2.4, 0.0, 1.0)
		"follow":
			if _trail.is_empty() or (_trail[_trail.size() - 1] as Vector3).distance_to(pp) > 0.4:
				if main.player.is_on_floor():
					_trail.append(pp)
			while _trail.size() > 300:
				_trail.pop_front()
				_li = maxi(0, _li - 1)
			var dist := lynx.position.distance_to(pp)
			if dist > 22.0:
				_snap_lynx()
				return
			while _li < _trail.size() - 1 and lynx.position.distance_to(_trail[_li + 1]) <= lynx.position.distance_to(_trail[_li]) + 0.05:
				_li += 1
			if dist > 1.8 and _li < _trail.size():
				var tgt: Vector3 = _trail[_li]
				var d := tgt - lynx.position
				if d.length() < 0.15 and _li < _trail.size() - 1:
					_li += 1
					tgt = _trail[_li]
					d = tgt - lynx.position
				var speed := clampf(dist * 1.4, 1.3, 4.4)
				lynx.position = lynx.position.move_toward(tgt, speed * delta)
				if Vector2(d.x, d.z).length() > 0.05:
					lynx.rotation.y = lerp_angle(lynx.rotation.y, atan2(-d.x, -d.z), minf(1.0, delta * 8.0))
				Anim.walk(lynx, _t, speed / 2.4, 0.0, 1.0)
				_lynx_moving = true
			else:
				_lynx_moving = false
				Anim.idle(lynx, _t, 1.0)
				var to := pp - lynx.position
				lynx.rotation.y = lerp_angle(lynx.rotation.y, atan2(-to.x, -to.z), minf(1.0, delta * 2.0))
				Anim.look(lynx, pp + Vector3(0, 1.6, 0), 0.6, 0.05)
		"stand":
			Anim.idle(lynx, _t, 1.0)
			Anim.look(lynx, pp + Vector3(0, 1.6, 0), 0.8, 0.05)
		"sit", "kneel":
			Anim.look(lynx, pp + Vector3(0, 1.6, 0), 0.3, 0.03)


## The eyeless: they walk S with a hand on the brick. Frames off, Carl is
## invisible to them and they pass, edging round him. Frames on, they turn
## toward him (faster the nearer he is) and close at walking speed.
func _tick_eyeless(delta: float, pp: Vector3) -> void:
	var live: bool = main.flags.has("fac_breath")
	var cine: bool = main.flags.has("cinematic") or main.ui.busy or _busy
	_touch_cd = maxf(0.0, _touch_cd - delta)
	for e in eyeless:
		var n: Node3D = e["node"]
		if not live or cine:
			Anim.idle(n, _t, 2.0)
			continue
		var to_p := pp - n.position
		to_p.y = 0.0
		var dist := to_p.length()
		var same := absf(pp.y - n.position.y) < 1.6
		var senses: bool = main.frames_on and same and dist < 15.0
		if senses and e["mode"] != "chase":
			e["mode"] = "chase"
			main.play("whisper", -14.0, 0.6)
		elif not senses and e["mode"] == "chase":
			e["mode"] = "lost"
			e["lost"] = 2.5
		match str(e["mode"]):
			"chase":
				var want := atan2(-to_p.x, -to_p.z)
				var rate := lerpf(4.0, 0.9, clampf(dist / 15.0, 0.0, 1.0))
				n.rotation.y = lerp_angle(n.rotation.y, want, minf(1.0, delta * rate))
				if absf(wrapf(want - n.rotation.y, -PI, PI)) < 0.7:
					var tgt := Vector3(clampf(pp.x, -33.4, 18.4), Y2, clampf(pp.z, SZ - 1.0, SZ + 1.0))
					var d := tgt - n.position
					d.y = 0.0
					if d.length() > 0.05:
						n.position += d.normalized() * minf(1.3 * delta, d.length())
					_shuffle(e, delta, 0.95)
				else:
					Anim.idle(n, _t, 2.0)
				Anim.look(n, pp + Vector3(0, 1.6, 0), 1.0, 0.12)
				if dist < 0.9 and _touch_cd <= 0.0 and _in_s(pp):
					_touched()
			"lost":
				e["lost"] = float(e["lost"]) - delta
				Anim.idle(n, _t, 2.0)
				Anim.look(n, n.position + Basis(Vector3.UP, n.rotation.y + sin(_t * 1.3) * 1.0) * Vector3(0, 1.6, -3.0), 1.0, 0.04)
				if float(e["lost"]) <= 0.0:
					e["mode"] = "patrol"
			_:
				var a: Vector3 = e["a"]
				var b: Vector3 = e["b"]
				var goal := b if float(e["dir"]) > 0.0 else a
				var d := goal - n.position
				d.y = 0.0
				if d.length() < 0.25:
					e["dir"] = -float(e["dir"])
				else:
					var step := d.normalized() * 0.55 * delta
					if dist < 1.4 and same:
						var side := Vector3(-d.z, 0, d.x).normalized()
						var sgn := 1.0 if side.dot(-to_p) > 0.0 else -1.0
						step += side * sgn * 0.6 * delta
						if dist < 0.8 and not _brushed:
							_brushed = true
							main.ui.show_toast(L("eyeless", "brush"), 4.0)
					n.position += step
					n.position.z = clampf(n.position.z, SZ - 1.0, SZ + 1.0)
					n.rotation.y = lerp_angle(n.rotation.y, atan2(-d.x, -d.z), minf(1.0, delta * 3.0))
				_shuffle(e, delta, 0.55)
				Anim.look(n, pp + Vector3(0, 1.6, 0), 0.0, 0.05)


## A slow walk and the wet shuffle of bare feet.
func _shuffle(e: Dictionary, delta: float, speed: float) -> void:
	var n: Node3D = e["node"]
	Anim.walk(n, _t, speed, float(n.get_instance_id() % 7), 0.55)
	(n.get_meta("arms")[0] as Node3D).rotation = Vector3(0.25, 0.0, -1.0)
	e["step"] = float(e["step"]) - delta
	if float(e["step"]) <= 0.0:
		e["step"] = 1.0 / maxf(0.4, speed)
		var s: AudioStreamPlayer3D = e["snd"]
		s.pitch_scale = rng.randf_range(0.4, 0.52)
		s.play()


func objective() -> String:
	var f: Dictionary = main.flags
	if f.has("facility_done"):
		return L("objective", "done")
	if f.has("fac_lullaby"):
		return L("objective", "file")
	if f.has("lynx_broke") or f.has("fac_lab"):
		return L("objective", "obs")
	if f.has("fac_sub2"):
		return L("objective", "pens")
	if f.has("office_read"):
		return L("objective", "deeper")
	if f.has("lynx_found"):
		return L("objective", "office")
	if f.has("fac_woke"):
		return L("objective", "lynx")
	return L("objective", "wake")


func phone() -> String:
	var f: Dictionary = main.flags
	var t := L("phone", "line1")
	if f.has("subject_1235_seen"):
		t += L("phone", "line2")
	if f.has("fac_lullaby"):
		t += L("phone", "line3")
	if f.has("facility_done"):
		t += L("phone", "line4")
	return t


## Dev args for screenshots: lynx=x,y,z (Lynx standing there), sit=office
## or obs (Lynx at the terminal), video=1 (the lab in 2019, Subject 41
## standing, the monitor text), term=1, eyeless=x,z (the first one there).
func apply_args(a: Dictionary) -> void:
	main.player.crouch = 0.0
	if a.has("lynx"):
		var v: PackedStringArray = str(a["lynx"]).split(",")
		if v.size() == 3:
			lynx.visible = true
			lynx.position = Vector3(float(v[0]), float(v[1]), float(v[2]))
			lynx_state = "stand"
			turn_to(lynx, main.player.global_position)
	if a.has("sit"):
		lynx.visible = true
		lynx_state = "sit"
		if str(a["sit"]) == "obs":
			lynx.position = OBS_CHAIR + Vector3(0, -0.29, 0)
			lynx.rotation.y = 0.0
		else:
			lynx.position = OFFICE_CHAIR + Vector3(0, -0.29, 0)
			lynx.rotation.y = PI
		Anim.sit(lynx, 0.05)
		for arm in lynx.get_meta("arms"):
			(arm as Node3D).rotation.x = 1.1
	if a.has("term"):
		term_screen_m.emission_enabled = true
		term_screen_m.emission = Color(0.3, 0.85, 0.6)
		term_screen_m.emission_energy_multiplier = 1.1
		term_light.light_energy = 0.9
	if a.has("video"):
		_lab_2019(true)
		_seat_subject(false)
		lab_text.text = L("obs", "v5_text")
		lab_text.visible = true
		lab_eeg.visible = true
	if a.has("eyeless"):
		var v: PackedStringArray = str(a["eyeless"]).split(",")
		if v.size() == 2:
			var n: Node3D = eyeless[0]["node"]
			n.position = Vector3(float(v[0]), Y2, float(v[1]))
			turn_to(n, main.player.global_position)


func _by_id(id: String) -> void:
	for n in main._all_with_meta(self, "id"):
		if is_instance_valid(n) and str(n.get_meta("id")) == id:
			await main.interact(n)
			print("ok ", id)
			return
	print("MISSING ", id)


func _wait_flag(flag: String, secs: float) -> void:
	var t := 0.0
	while t < secs and (not main.flags.has(flag) or main.flags.has("cinematic") or _busy):
		await get_tree().process_frame
		t += get_process_delta_time()


func selftest() -> void:
	var f: Dictionary = main.flags
	await intro()
	for id in ["mirror", "flag", "crt", "console", "doorway", "lynx"]:
		await _by_id(id)
	print("ok lynx found=", f.has("lynx_found"), " trust=", main.trust["lynx"])
	# sublevel 1: the office, the side rooms, the second stairwell
	main.player.position = Vector3(0.0, Y1 + 0.05, -12.0)
	_snap_lynx()
	await _by_id("stair_b")
	for id in ["office_door", "whiteboard", "desktop", "terminal", "terminal", "lynx"]:
		await _by_id(id)
	print("ok office read=", f.has("office_read"), " slides=", f.has("ev_darpa_slides"), " log=", f.has("ev_hameron_log_1"), " conn=", main.connection)
	main.player.position = Vector3(-10.0, Y1 + 0.05, -11.0)
	for id in ["quarters", "offering", "offering", "gym", "gym_bike", "wire", "wire", "sealed", "service", "fuse", "sign1", "sign2", "stair_b"]:
		await _by_id(id)
	# sublevel 2: the arrival, then one of them, with the frames on
	main.player.position = STAIR_B_FOOT + Vector3(0, 0, 0.2)
	_snap_lynx()
	await _wait_flag("fac_sub2", 6.0)
	print("ok sub2=", f.has("fac_sub2"))
	main.toggle_frames()
	main.player.position = Vector3(-13.6, Y2 + 0.05, SZ)
	await _wait_flag("fac_touched", 12.0)
	print("ok touched=", f.has("fac_touched"), " conn=", main.connection)
	main.toggle_frames()
	# the pens: three seen and Lynx breaks; the rest
	main.player.position = Vector3(-10.5, Y2 + 0.05, PZ)
	_snap_lynx()
	for i in 6:
		await _by_id("pen%d" % (i + 1))
	print("ok pens broke=", f.has("lynx_broke"), " hand=", f.has("lynx_hand"))
	# the lab: the ceiling
	main.player.position = Vector3(8.5, Y2 + 0.05, -18.6)
	await _wait_flag("fac_lab", 6.0)
	for id in ["lab_door", "chair", "lab_monitor", "camera", "glass"]:
		await _by_id(id)
	# pen 4 and the eye-layer door
	main.player.position = Vector3(-3.4, Y2 + 0.05, -19.5)
	_snap_lynx()
	await _by_id("eye_wall")
	await _by_id("eye_door")
	main.toggle_frames()
	await _by_id("eye_door")
	print("ok lullaby=", f.has("fac_lullaby"), " frames_on=", main.frames_on, " words=", main.lexicon)
	# the folder: two scrubs with the frames off, then the frames on
	await _by_id("monitor")
	await _by_id("monitor")
	main.toggle_frames()
	await _by_id("monitor")
	print("ok video=", f.has("ev_subject41_video"), " done=", f.has("facility_done"))
	main.toggle_frames()
	for id in ["obs_door", "obs_door", "rack", "glass", "cabinet", "records", "showers", "gowns", "generator"]:
		await _by_id(id)
	main.player.position = Vector3(17.5, Y2 + 0.05, SZ)
	await _by_id("hangar_stairs")
	print("ok stairs ended=", _ended, " objective=", objective())
	await main.selftest_all_interactables()

