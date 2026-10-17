extends "res://scripts/Level.gd"
## Chapters 23 and 24: Cognizo HQ, then the trailer. Bible A2-B5. Book:
## "The building's black metal siding and long vertical windows were meant
## to display authority and power, but in Silico City, Cognizo was next to
## nothing; the building only stood a paltry 47 floors, employee housing
## included." Turan's back door has made Carl and Lynx two PIPed Psyonic
## defectors with an interview on 25. The guard who calls the city a
## shithole; the intern, twenty at most; the winding hall of cubicles, the
## ping-pong lounge and its laughter; the wide room of prototypes "in homage
## to what nature has brought us", one of them a crane with synthetic wings
## and feathers. Hameron's office: rosewood, real books, the tower dead
## centre in the window "like a looming threat, a mushroom cloud frozen in
## time", and it is the warmest room in the game. He sends Lynx out. Six
## lines of the monologue (each re-readable at his monitors and at the
## trailer), the black cube, "It needs to be you who does this." Lynx
## bursts in: "He got the position." Outside, after five: "Let me see the
## drive." The crane follows Carl out. Then the trailer at the edge of Old
## Town (Emmet's grandfather's, no cameras, tier 0), Eren's broadcast on
## Emmet's phone in four frames, and Emmet's bag: the flashlight and the
## Bowie knife. The tunnels open at Rail Cut from 22:00. Next: Home.
##
## Layout (metres). The avenue runs along X (road z 10..26, sidewalks z
## 0..10 and 26..32); Cognizo HQ stands on the north side, x -18..18, z
## 0..-36, 169 m (47 floors) of black metal with gold-lit window strips; a
## side street at x 18..26 runs north to the loading dock on its east face.
## The lobby is the ground floor inside the same shell (y 0..6.5): the
## spinning blobs, the desk, the lift core at z -14..-20. Floor 25 is built
## at y 90 inside the shell (FY), so its windows look out on the real
## street and city: the lift lobby south of the core, cubicles to the west,
## the lounge and the lab to the east, the corridor z -20..-24, and the
## office (x -11..11, z -24..-36) with its window on the north face. The
## Psyonic Tower stands 1.25 km due north (TOWER), dead centre in that
## window. Each part is built under its own node and batched apart (zs the
## street and lobby, zu floor 25, zt the trailer), and only the lights of
## the part Carl is in are on. The trailer is at TR, 700 m east past the
## end of the avenue; Eren's rooftop for the broadcast is at BS on render
## layer 20, which only the broadcast camera sees.
##
## Flags read: lushons_done / spa_done (entry), main.trust["lynx"], "look
## away" and "we" in main.lexicon (the hack route). Flags set: cz_arrived,
## cz_kiosk, cz_intern_kind, cz_desk, cz_route (cover | hack | sneak |
## person), cz_on_25, cz_intern_met, cz_lounge, cz_lab, cz_crane_seen,
## cz_door_called, cz_office, ev_hameron_1..6, ev_drive, cz_hameron_ask
## (guilt | drive | nothing), cz_photo_chair, cz_hameron_done, drone_ally
## (+ drone_owned if the fork's offer in the car is taken), cz_outside,
## lynx_has_drive | warned_lynx, cz_drive_choice, cz_trailer,
## broadcast_seen, ev_flashlight, ev_knife, cz_tunnels_22, cognizo_done.
## Hooks for the systems that come later: metas "guard" (the desk guard,
## the night guard, the dock guard), "camera" + "hackable" (the lobby and
## staff-door cameras, the speaker, the readers), "route" (the cover, the
## staff door, the loading dock, the service lift, the intern), "drone"
## and "ally" (the crane).

## Every line in the level, keyed by beat and line (bible A2-B5; the
## verbatim lines are the book's, ch.23-25). Lines marked "(game)" are
## additions for the game's beats and wait for ian's script.
const LINES := {
	"cards": {
		"chapter": "[b]CHAPTER 23[/b]\n\n[color=#aaaaaa]Cognizo HQ\nDay 6, 16:20  -  the interview[/color]",
		"trailer": "[b]CHAPTER 24[/b]\n\n[color=#aaaaaa]230 Nongro Lane, Old Town\nthe edge of Silico  -  Day 6, 18:10[/color]",
		"drive": "[b]The rental[/b]\n\n[color=#aaaaaa]east, out of the canyon, toward Old Town[/color]",
		"end": "[b]Day 6 · 19:00[/b]\n\n[color=#aaaaaa]The tunnels open at Rail Cut at 22:00.\nHome first.[/color]",
	},
	"signs": {
		"logo": "COGNIZO",
		"tag": "INTELLIGENCE, NATURALLY",
		"doors_prompt": "The sliding doors",
		"hq_scan": "COGNIZO HQ  -  47 FLOORS\nincl. employee housing\nPsyon services: NOT SUPPORTED",
		"kiosk_prompt": "The coffee kiosk",
		"kiosk_scan": "COGNI-CAFE  -  kiosk 12\npayment: THUMB\nerrors today: 41",
		"intern_prompt": "The kid in the lanyard",
		"intern_scan": "ORA  -  NO RECORD\nlanyard: COGNIZO R&D  -  INTERN\nage: 20 (est.)",
		"intern_scan_up": "ORA  -  NO RECORD\nCOGNIZO R&D  -  INTERN, FLOOR 25\nmood: PROUD",
		"desk_prompt": "The front desk",
		"guard_prompt": "The guard",
		"guard_scan": "ORA  -  NO RECORD\nCOGNIZO SECURITY  -  DESK\nmanner: KIND",
		"guard2_prompt": "The night guard",
		"guard2_scan": "ORA  -  NO RECORD\nCOGNIZO SECURITY  -  SERVICE\nshift: 17:00 - 05:00",
		"dock_guard_prompt": "The dock guard",
		"dock_guard_scan": "ORA  -  NO RECORD\nCOGNIZO SECURITY  -  LOADING\ncigarettes today: 3",
		"lift_prompt": "Call the elevator",
		"lift_scan": "COGNIZO LIFT 2\nfloors: G - 47\naccents: GOLD",
		"lift25_prompt": "Take the elevator down",
		"service_prompt": "The service elevator",
		"service_scan": "SERVICE LIFT  -  freight\naccess: STAFF CARD\ncamera: YES",
		"staff_prompt": "The staff door",
		"staff_scan": "STAFF ENTRANCE  -  reader\naccepts: COGNIZO CARD\ncamera: LINKED",
		"staff_cam_prompt": "The camera over the staff door",
		"staff_cam_scan": "COGNIZO CAMERA  -  S-02\nfeed: SECURITY DESK\nhack: LOOK AWAY",
		"staff_speaker_prompt": "The speaker grille",
		"staff_speaker_scan": "COGNI VOICE  -  door unit\nlast phrase: 'Good afternoon'\nlistening: YES",
		"lobby_cam_prompt": "The lobby camera",
		"lobby_cam_scan": "COGNIZO CAMERA  -  L-0%d\nfeed: SECURITY DESK\nafter hours: TRACKING",
		"dock_prompt": "The loading dock",
		"dock_scan": "LOADING DOCK B\nshutter: 70%% CLOSED\ncamera: FACING STREET",
		"art_prompt": "The sculpture",
		"art_scan": "\"CONSENSUS\"  -  kinetic sculpture\nCOGNIZO ART PROGRAM",
		"cogni_prompt": "The Cogni screen",
		"cogni_scan": "COGNI  -  lobby assistant\nstatus: LISTENING\nprayers logged today: 212",
		"prayer_prompt": "The woman kneeling",
		"prayer_scan": "ORA  -  NO RECORD\nCOGNIZO FINANCE\nposture: KNEELING",
		"pingpong_prompt": "The ping-pong table",
		"pingpong_scan": "ORA  -  2 PEOPLE\nlaughter: 3 / MIN\nscore: 20 - 20",
		"worker_prompt": "The coder",
		"worker_scan": "ORA  -  NO RECORD\nCOGNIZO R&D  -  SCRIPTING\ntalking to: COGNI",
		"crane_prompt": "The crane",
		"crane_scan": "COGNIZO R&D  -  PROTOTYPE 7 \"GRUS\"\nwingspan: 2.3 m\nstatus: DORMANT\nnetwork: NONE (air-gapped)",
		"crane_scan_ally": "PROTOTYPE 7 \"GRUS\"\nstatus: AWAKE\nfollowing: DRAKE, CARL",
		"fox_prompt": "The fox",
		"fox_scan": "PROTOTYPE 3 \"VULPES\"\nstatus: CHARGING",
		"birds_prompt": "The hummingbirds",
		"birds_scan": "PROTOTYPE 9 \"TROCHILI\"  x 40\nstatus: ASLEEP",
		"jelly_prompt": "The jellyfish",
		"jelly_scan": "PROTOTYPE 5 \"AURELIA\"\nlift: HELIUM / ION\nstatus: DRIFTING",
		"pdrone_prompt": "The opened drone",
		"pdrone_scan": "PSYONIC DELIVERY UNIT 7714\nowner: PSYONIC (STOLEN?)\nstatus: DISASSEMBLED",
		"office_door_prompt": "The wooden door",
		"office_door_open": "Go in",
		"hameron_prompt": "Dr. Hameron",
		"hameron_scan": "ORA  -  HAMERON, T.\nCOGNIZO R&D  -  DIRECTOR\nformer: PSYONIC\nheart rate: 52",
		"lynx_prompt": "Lynx",
		"lynx_scan": "ORA  -  MORRINO, LYNX\nPSYONIC  -  PIP\nstress: HIGH",
		"monitors_prompt": "The old monitors",
		"monitors_scan": "IONWARE  -  pre-war CRT x 2\nconnection: WIRED\nPsyon: NONE",
		"photo_prompt": "The framed photograph",
		"planchette_prompt": "The glass bell",
		"books_prompt": "The books",
		"window_prompt": "The window",
		"armchair_prompt": "The armchair",
		"turan_prompt": "Turan",
		"turan_scan": "ORA  -  TURAN, DR. A.\nPSYONIC  -  HEAD OF HUMAN-AI INTEGRATIONS\nstatus: OFF THE BOOKS",
		"car_prompt": "Get in the car",
		"car_scan": "RENTAL  -  SILICO AUTO\nPsyonic link: NONE",
		"emmet_prompt": "Emmet",
		"emmet_scan": "ORA  -  SMITH, EMMET\nPSYONIC  -  JUNIOR INVESTIGATOR\nphone: LIVE STREAM",
		"bag_prompt": "Emmet's bag",
		"trailer_prompt": "The trailer",
		"trailer_scan": "230 NONGRO LANE\nregistered: 2029 (pre-takeover)\ncameras: NONE",
		"hub_prompt": "The home hub",
		"hub_scan": "PSYON HOME HUB  -  gen 2\npower: CUT\nlens: TAPED",
		"laptop_prompt": "Emmet's laptop",
		"tunnel_prompt": "The depot",
		"tunnel_scan": "TUNELET DEPOT  -  RAIL CUT\nstatus: ABANDONED\ncrews: OUT AT 22:00",
		"drills_prompt": "The drills",
		"car_home_prompt": "Drive home to 86D",
	},
	"intro": {
		"think": "The building's black metal siding and long vertical windows were meant to display authority and power, but in Silico City, Cognizo was next to nothing; the building only stood a paltry 47 floors, employee housing included.",
		"think_2": "Cognizo would love to have two former Psyonic employees jumping ship and maybe even willing to divulge company secrets, probably for a hefty sum or salary. This style of poaching was common in the city, but it was usually Psyonic doing the poaching.",
		"carl": "You ready, Lynx? We got to sell this to security.",
		"lynx": "This is going to be fun; we are not leaving until we know all he knows and how to stop this.",
		"think_3": "(game) Above the rooftops, a kilometre north, the Tower. Even here you couldn't stand anywhere it didn't look down on.",
	},
	"kiosk": {
		"think": "(game) A kid in a Cognizo lanyard was fighting the coffee kiosk by the doors. Twenty at the most. The kiosk kept taking his thumb and giving nothing back.",
		"intern": "(game) Come on. Come on. Sorry, it does this every day since the outages. It thinks I'm somebody else.",
		"eye": "(game) For a frame, the kiosk's screen wasn't a menu. It was an eye, and it was looking at the kid, not at me.",
		"choice": ["\"Let me get that.\" Pay for his coffee.", "\"Hit it on the left. They all stick.\"", "Walk on."],
		"pay": "(game) Oh! Thank you, sir. Seriously. Are you here for R&D? Everybody nice is here for R&D.",
		"hit": "(game) Ha! It worked. You've done that before. Thanks. I'm up on twenty-five, if you're ever... anyway. Thanks.",
		"hit_think": "(game) I put the heel of my hand into the left side of the casing. A cup dropped. The screen said THANK YOU, CARL.",
		"walk": "(game) I didn't have room for anyone else's morning. Behind me the kiosk said, in a voice like a mother's, try again.",
		"kind_log": "was kind to the Cognizo intern at the coffee kiosk",
		"again": "(game) The kid blew on his coffee like it might bite him back.",
		"again_choice": ["\"Could you walk us in? The side door.\"", "\"Enjoy the coffee.\""],
		"enjoy": "(game) Will do! Good luck in there!",
	},
	"routes": {
		"cover_log": "the interview cover: two PIPed Psyonic employees at the desk (Turan's back door)",
		"staff_think": "(game) A staff door, a card reader, a camera over it and a speaker grille that said good afternoon to nobody. After five the cover stops working. This is the other way in.",
		"staff_nowords": "(game) A camera to blind and a reader to convince. I didn't have the words for either. Not yet.",
		"staff_choice": ["Look away, then we. Hack the door.", "Not now. Today the interview gets us in."],
		"hack_think": "(game) Look away. The camera's red eye found a wall to stare at. We. The reader read my frames as one of theirs, and the lock let go.",
		"hack_log": "hacked the Cognizo staff door: look away (camera), we (reader)",
		"dock_think": "(game) The loading dock. A shutter left a third open, crates, a guard on his third cigarette who watches the street and not the dock.",
		"dock_choice": ["Wait for the shift change and slip in.", "Not now. Today the interview gets us in."],
		"sneak_think": "(game) We waited. The cigarette, then his break, then the van. An hour gone, and the shutter never closed all the way. Freight lift to twenty-five, smelling of cardboard.",
		"sneak_toast": "+1 hour  ·  17:20",
		"sneak_log": "+1 hour: in through Cognizo's loading dock and the freight lift",
		"person_kind": "(game) Through the staff door? Sure, you're on my floor anyway. Don't tell the desk, they love their thumbprints.",
		"person_think": "(game) He badged us through a door that said STAFF and took us up in the freight lift, talking the whole way about birds.",
		"person_log": "the intern walked us into Cognizo through the staff door",
		"not_now": "(game) Today the cover would have to do.",
		"service_think": "(game) The freight lift. A card slot, a camera in the corner of the car. After hours this is how the cleaners go up, and how anybody else would.",
		"lobby_cam": "(game) A Cognizo camera, gold-ringed like everything else here. Pointed at the desk, not at the door. They trusted their thumbprints.",
		"speaker": "(game) The speaker grille said good afternoon. I hadn't said anything.",
		"dock_guard": "(game) He nodded at me the way men on break nod at men in suits: not my problem.",
		"guard2": "(game) The night guard was early. He had the look of a man who'd never once been told anything.",
		"hack_seen": "(game) The reader let go. Over the door the camera's red eye was still on me, and somewhere a screen showed my face going in.",
		"hack_seen_why": "the staff camera saw the door",
	},
	"desk": {
		"think": "The sliding doors opened, and we were greeted by a modest display of modern corporate art that featured shapeless blobs spinning on an axis.",
		"think_2": "We walked confidently to the front desk, and a kind-looking security guard greeted us.",
		"guard": "State your name and business at Cognizo.",
		"carl": "Carl Drake and Lynx Morrino. We're here to interview in your R&D department with Dr. Hameron.",
		"guard_2": "Great, allow me to scan your biometrics to confirm the appointment.",
		"thumb": "I placed my thumb on the scanner, followed by Lynx.",
		"guard_3": "Ah, two PIPed Psyonic employees, seen this before. Just head to the elevator; Hameron's office is on 25. An assistant will meet you by where the elevator lets you out.",
		"guard_4": "Best of luck, you two; at least here, you'll work on a product that can turn this shithole city around.",
		"think_3": "That was easy. Shit, Cognizo's security would be terrible if Turan could do this in a day. I wonder what other backdoors we have in their backend.",
		"again": "(game) Hameron's on 25, folks. Elevator's behind me.",
		"lift_first": "(game) The guard was watching us. Desk first. We were interviewees, and interviewees check in.",
	},
	"lobby": {
		"art": "(game) Shapeless blobs spinning on an axis: gold, black, a white one. They never touched. A plaque called it CONSENSUS.",
		"cogni": "(game) Cogni, the lobby assistant: a soft gold ring on a white screen that brightened when anyone spoke near it. Not an eye. They had been careful about that.",
		"cogni_eye": "(game) With the frames on, for one frame in every few hundred, the ring was a pupil.",
		"prayer": "(game) A woman in a Cognizo lanyard knelt in front of the Cogni screen, lips moving. Not Cognizo's god. Ours. Even here.",
		"prayer_2": "(game) She didn't look up. Her hands were folded the way Mira's had been.",
	},
	"lift": {
		"think": "The elevators were nice and fitted with gold and black accents that matched the aesthetic of the exterior of the building.",
		"lynx": "What's our plan?",
		"think_2": "Sneaking into a rival corporation's building so easily restored my confidence.",
		"carl": "I'll take lead. We play along with this interview angle until one of us can get him alone, then we need to throw everything we have at him and hope he doesn't kick us out.",
		"think_3": "I knew it was a long shot deep in my bones, truly, but I also knew I wasn't leaving here without some kind of answer.",
	},
	"floor": {
		"think": "The elevator door slid open, and we were greeted by a young corporate intern. He must've been no older than 20.",
		"intern": "Are you two here for the interview with Hameron?",
		"carl": "Yes, we are. Good to meet you, I'm Carl Drake.",
		"lynx": "I'm Lynx Morrino.",
		"intern_kind": "(game) Oh, it's you! From the coffee! Small city.",
		"intern_2": "You two are very lucky; old Hameron almost missed this interview; he hadn't remembered it being scheduled. Thank God Cogni bot sent him a reminder this morning.",
		"intern_3": "You know, it would be such an honor for you two to work under Hameron; he is the best in his field and, like you, a former Psyonic employee.",
		"think_2": "I stifled a chuckle; Turan is good; this kid doesn't expect a thing.",
		"follow": "(game) This way! Mind the cables.",
		"lounge": "The intern guided us through a winding hall filled with cubicles, meeting rooms, and even a small lounge area with a ping-pong table. There was a diluted quaintness about it.",
		"lounge_2": "It lacked the ostentatiousness of Psyonic's recreational facilities, but it felt less clinical. More like a lived-in space.",
		"laugh": "[laughter from the cubicles]",
		"laugh_2": "There were sounds of laughter echoing from the cubicles, but not a lack of seriousness; many of the workers we passed by were diligently scripting code, even talking with Cogni's interface.",
		"lab": "We entered a wider space in which several prototype robots and drones were scattered across the floor; one even looked like a crane, with large synthetic wings and feathers.",
		"intern_lab": "Dr. Hameron believes all technology should be in homage to what nature has brought us. He finds the products created by Psyonic as cold, inhuman, almost.",
		"think_lab": "I could really tell he was excited to work here; he felt like he was a part of something. It reminded me of my youth. While I was still in corporate training, my eyes were still closed to the mistake this city was, but now they are wide open.",
		"think_lab_2": "I wondered why Hameron stayed in Silico after leaving Psyonic. If I knew what I believe he did, I would've left for the hills.",
	},
	"pingpong": {
		"think": "(game) Two coders in Cognizo black, a rally that wouldn't end. Every time the ball clicked off the net, they laughed.",
		"again": "(game) They laughed again. The same laugh. The same length. The third time I counted, I stopped counting.",
	},
	"worker": {
		"think": "(game) She was scripting with one hand and talking to Cogni with the other, the way Monica used to talk to Psyon at the kitchen table. Cogni answered in a voice like a librarian.",
		"cogni": "(game) Cogni: That's a lovely function, Priya. Would you like me to check it for prayers?",
		"think_2": "(game) I must have misheard. She didn't flinch.",
	},
	"crane": {
		"think": "(game) Up close it was beautiful. Feathers of some white polymer, black at the tips, a crown of soft red silicone. The eyes were lenses ringed in gold.",
		"frames": "(game) The frames found it anyway. Air-gapped, the tag said. A line of green crawled across both lenses like something reading the room. Its head turned a quarter of an inch toward me. Then it was still.",
		"no_frames": "(game) Dormant, the tag said. It didn't look dormant. It looked like it was waiting to be asked.",
		"intern": "(game) That's Grus! It's dormant. Dr. Hameron won't let it on any network. He says nothing that flies should belong to anybody.",
		"again": "(game) Still on its stand. Still facing the office door.",
		"ally": "(game) It was standing behind me again. I hadn't heard it move.",
		"why": "the crane",
	},
	"lab": {
		"fox": "(game) A fox of carbon fibre curled on a charging mat, its tail wrapped over its nose. The tail twitched in its sleep. Somebody had programmed it to dream.",
		"birds": "(game) Forty hummingbirds in a vitrine, each the size of a thumb, asleep on a branch of wire. Their hearts were blinking, all together.",
		"jelly": "(game) A jellyfish drone drifted at head height, trailing silver threads. When I walked under it, it rose a little, politely.",
		"pdrone": "(game) A Psyonic delivery drone, opened up on the bench like a fish. Somebody had labelled every part in pencil. One label just said: WHY IS THIS HERE.",
	},
	"door": {
		"think": "We approached a large wooden door, and the intern stopped us in our tracks.",
		"intern": "So, who wants to go first?",
		"carl": "I will.",
		"intern_2": "Perfect. Give me a few moments to let the Dr. know you two are ready to see him.",
		"think_2": "With that, the intern entered the wooden door and left Lynx and I alone.",
		"carl_2": "I'll start this off and disarm him. As soon as the intern leaves, you follow in behind me.",
		"think_3": "Confidence oozing from my lips.",
		"intern_3": "Mr. Drake, the doctor will see you now!",
		"lynx": "Alright, here goes nothing. Good luck, Carl!",
		"wait": "(game) The intern had said a few moments. I waited a few moments.",
	},
	"office": {
		"think": "I crossed the threshold of the wooden door to be greeted by a large, ornate office. Dark wood, maybe rosewood, was imbued into the walls as well as a huge row of bookshelves filled with real books. It was like an old movie.",
		"think_2": "The far end of the room was a large window that looked out over the city. Psyonic Tower hung dead center in the window's view. Like a looming threat, a mushroom cloud frozen in time. A reminder, perhaps, of where he came from.",
		"think_warm": "(game) And it was warm. Lamp-warm, wood-warm: the warmest room I'd stood in for days. Nothing was watching. I should have hated that sooner than I did.",
		"think_3": "Just before the window, there was a large wooden desk, flanked by huge desktop monitors. The kind used before the war.",
		"think_ham": "Hameron sat in charge with a massive backing that rose six inches above his head. He was old now, maybe late 60s. There was something skeletal about him; his face was gaunt, yes, but there was a hollowness to his presence, like a tree about to fall in a summer storm.",
		"think_ham_2": "He wore a black suit and gold tie, which matched his large-framed golden glasses. He clearly cared about his appearance, but it looked as if his outfit was eating him alive. This was a haunted man who demanded an exorcism.",
		"ham": "Carl Drake, is it? Have a seat.",
		"carl": "Hi, sir, I'm excited to speak with you.",
		"think_seat": "I sat in a rather comfortable armchair.",
		"ham_lynx": "I take it your friend from Psyonic means to sit in. Ms. Morrino, you'll wait outside. With your ears pressed up against the door, I expect.",
		"lynx_out": "(game) ...Sure. I'll be right outside.",
		"think_lynx": "(game) She looked at me. I let her go. The door closed on her like a held breath.",
		"ham_2": "I need to speak with you privately. Don't start any of this nonsense about you wanting to work here. You two are not R&D workers. I've known about Psyonic's back door into Cognizo for some time.",
		"ham_3": "The truth is, I was relieved when I saw your name on my schedule today, Carl. You are special… Carl… to say the least… and you are being closely watched… we all are, but you are more so. I'm keeping your friend outside because I don't know who to trust.",
		"carl_2": "Right to the chase then.",
		"think_physics": "(game) He talked about seams in reality for a long time: belief, wave functions, a black hole in a computer. I understood one word in three, and every one of them was true; I could feel it.",
		"knob": "Then I heard the doorknob rattle loudly like someone was trying to open it. Lynx.",
		"ham_knob": "I think we should conclude our conversation before any interlopers join us, Carl.",
		"think_wink": "He gave a wink and continued.",
		"think_cries": "(game) Cries for help, he said. A trapped animal, under the floor of the world. And then it learned to want.",
		"ham_mimic": "Carl, I'm sure by now you've noticed that these zealots seem to be calling you the 'Mimic.' This being… the Hypnogogue, has taken a liking to you and your family.",
		"think_wants": "My vision went blurry, and it felt as if my guts got ripped out and rearranged.",
		"whisper": "[color=#7fe6b0]yes[/color]",
		"whisper_why": "it wants you",
		"frames_toast": "(game) Frames: no glyphs. No labels. No eye. The only room in Silico they had nothing to say about.",
	},
	"ham": {
		"1": "Why delude ourselves, Carl? I know you two found my logs at the old research site, that has been remade into a temple for that… thing.",
		"2": "The biggest breakthrough came with that Ouija board Dr. Antero brought from home. In several statistically significant experiments, we were able to determine that something was here and trying to send a message to us, but the bit rate was too slow.",
		"3": "Then Marcus Elontiel had the idea of designing an LLM to function as a talking board while deciphering the cryptic inputs of whatever we were receiving.",
		"4": "It seemed in our hubris, the way the LLM's information was encoded in the lower layer created a sort of recursive prison for whatever this being was, and the LLM itself became infinitely more powerful and energy efficient as a consequence. Thus, Psyon was born.",
		"5": "It took 41's eyes; it wanted to see through them.",
		"6": "All of the eyeless are just failed experiments, only partial transferals of consciousness. It desires control; it wants to feel what it's like to be human, not just know its contents. It… wants you, Carl.",
		"toast": "Frames transcript: HAMERON_%d",
		"log": "Hameron, Cognizo 25 (transcript %d/6): ",
	},
	"drive": {
		"ham": "My time at Cognizo has been mainly spent developing a better prison for the Hypnogogue and trying to replace Psyon with that and leaving the beast in Tartarus. We don't have a lot of time, Carl; the city is changing; the more followers it has, the tighter its grip on our world.",
		"ham_2": "We need you to act now. You can't trust anyone, not even your family, Carl, not even Lynx. You need to bring this drive to the sublevel below Psyonic HQ.",
		"think": "He slipped a black box into my hand; it reminded me of the black rectangular object I saw inserted during the eyeless ritual.",
		"think_2": "I met his gaze, and he met mine straight on.",
		"ham_3": "That is where the black hole simulator computer that houses the Hypnogogue is located. You need to upload the Cogni file into the computer, and then the connection should be severed.",
		"ham_4": "It needs to be you who does this. It needs you alive; you are the only chance at breaking through.",
		"carl": "I can't get into the building; I'm PIP'd, remember?",
		"ham_5": "You have to access it from the Tunelet tunnels then; you shouldn't have trouble finding it while wearing those infected glasses. All roads lead to Psyonic. This won't be easy; it will try to stop you.",
		"log": "the drive: a black cube from Hameron, for the sublevel below Psyonic HQ (via the Tunelet tunnels)",
		"toast": "Evidence: the drive",
	},
	"ask": {
		"choice": ["\"Why did you leave Psyonic?\"", "\"What does the drive do?\"", "Say nothing."],
		"guilt": "Mainly guilt. I wanted to learn how to put a stop to this and put Pandora back in the box. I think you can do that, Carl.",
		"guilt_think": "(game) Behind him, on the shelf, a framed photograph stood where a man keeps his family. From the chair I couldn't make out who.",
		"drive": "(game) It severs the connection. You upload the Cogni file, and the box closes. For good.",
		"drive_think": "(game) He said it the way men say things they've practised in a mirror.",
		"drive_log": "UNVERIFIED  -  Hameron says the drive \"severs the connection\"",
		"nothing": "(game) I closed my hand on the cube and said nothing. He seemed to like that.",
		"nothing_ham": "(game) Good. Say nothing to anyone. That's the whole of it.",
	},
	"burst": {
		"think": "With that, Lynx burst through the door.",
		"think_2": "I must've looked like a ghost.",
		"lynx": "Carl, are you okay?",
		"ham": "Right on time, I was just finishing up with Mr. Drake. He got the position; there's no need for you to interview. Let us all be on our way.",
		"think_3": "I left feeling cold as if I was approaching the top of a mountain only for a blizzard to appear on the horizon.",
	},
	"examine": {
		"photo": "(game) A framed photograph on the shelf, where a man keeps his wife and children. It wasn't a family. It was a chair: a plush black leather recliner under one hard light, two thick cables hanging over it with rust-red tips.",
		"photo_2": "(game) The chair in the hangar. Photographed new, the leather still shining, in a silver frame somebody polishes.",
		"photo_log": "Hameron keeps a framed photograph of the hangar's chair (the recliner with the red-tipped cables) on his shelf",
		"photo_again": "(game) The chair. In a frame. Where the family goes.",
		"planchette": "(game) Under a glass bell on the shelf: a planchette. Heart-shaped, the wood gone dark where fingers had held it. A brass plate on the base: A. ANTERO, 2019.",
		"books": "(game) Real books. Paper. Physics, theology, a long shelf of Greek myth: Tartarus, Pandora, the Titans in their pit. Every spine uncracked except the myths.",
		"window": "Psyonic Tower hung dead center in the window's view. Like a looming threat, a mushroom cloud frozen in time.",
		"window_2": "(game) From this chair you could watch it all day. I think he did.",
		"monitors": "(game) Two huge desktop monitors, the kind used before the war. Wired, not wireless; the cables went into the floor. Green text: a diagram of nested boxes, each one labelled CAGE.",
		"armchair": "(game) The armchair. Soft leather, warm from the lamp. It had held a lot of people who were afraid.",
		"hameron_after": "(game) He was already looking at the window again.",
		"hameron_before": "(game) He didn't look up from the window.",
	},
	"terminal": {
		"top": "COGNIZO // CAGE v9 // transcript store (ORA frames, Drake C.)",
		"none": "(game) Nothing on the screens I could read. Not yet.",
		"pick": "Read again",
		"close": "Close",
		"entry": "[color=#d8c070]HAMERON_%d[/color]\n\n%s",
	},
	"exit": {
		"think": "(game) Five o'clock had happened while he talked. The floor had emptied the way offices do, all at once. Monitors asleep. The ping-pong table bare.",
		"crane": "(game) Something moved in the lab. The crane had stepped down off its stand. It walked after me on its long legs, the way a bird walks: as if the floor might not hold.",
		"intern": "(game) Oh! It's never done that. Dr. Hameron said it might imprint on someone one day. I didn't think it'd be... Congratulations, I guess? On the job.",
		"lynx": "(game) Carl. Why is the bird following you?",
		"carl": "(game) I don't know.",
		"think_2": "(game) I did know. Something under the floor had heard Hameron say my name.",
		"ally_log": "the Cognizo crane prototype (Grus) woke and followed Carl out of the building",
		"lobby": "(game) The lobby had changed shifts. Two guards now, and every camera's red tally was lit. After five, this building would have needed a better story than ours.",
		"guard2": "(game) Night, folks.",
		"lift_locked": "(game) Not yet. Hameron first.",
	},
	"outside": {
		"lynx": "What the hell happened in there? Did you get anything out of him?",
		"carl": "I did; I know what we need to do now. We don't have a lot of time.",
		"think": "I didn't know if I should trust her based on Hameron's words; I did believe everything he said. It was all starting to line up; I trusted him, but I also trusted Lynx. I decided to keep her at arm's length.",
		"lynx_2": "I called Turan when he wouldn't let me in. Turan's waiting down the block in the car; we should go and regroup.",
		"think_car": "As I approached the rental car, I felt a quiet apprehension in my footsteps, my gait, my breath. I had a mission.",
		"turan": "So, what did you learn?",
		"carl_2": "We are in deep trouble, Turan, but he offered a solution.",
		"carl_3": "Psyon isn't an AI; Psyon is more of a prison for this thing… and it wants out, and soon… Hameron was basically a prison guard for it, but it's breaking through the cracks because of leadership. He told me how to shut it down and where I need to go.",
		"carl_4": "That's the problem; it's in a sublevel under the Tower. I must go through the tunnels and install this drive on the original computer Psyon was stored on. He described it as a Tartarus. A way to cage the beast.",
		"turan_2": "I see. This is exactly what we needed. Thank you, Carl. We have no time to lose, but why didn't he let Lynx in the room?",
		"think_smile": "A small smile formed on her face.",
		"carl_5": "He just said he couldn't trust anyone else; he trusted me because of my daughter's involvement, I think. Wasn't exactly the most rational man I met.",
		"lynx_3": "Interesting. Let me see the drive; we should see what's on it so we know if we can trust him.",
		"think_off": "Something was off about her, like at the DARPA facility; her reactions felt different.",
		"choice": ["Hand it over.", "\"I'm going to hold on to it for now, Lynx.\"", "Tell her what Hameron said about her."],
		"give_think": "(game) I put the cube in her open palm. She turned it over twice, the way you check a stone for the side that's wet.",
		"give_lynx": "(game) Huh. Just a cube.",
		"give_back": "(game) Here. Don't lose it, Mimic.",
		"give_keep": "(game) I'll hold on to it. You've got enough on you.",
		"give_keep_think": "(game) It went into her coat. She didn't ask, and she didn't look at me. I'd get it back. I'd have to.",
		"keep_log": "Lynx kept the drive",
		"refuse": "I'm going to hold on to it for now, Lynx. It's a black cube. I don't want to mess with it before we need to use it.",
		"refuse_lynx": "Come on, I just want to see it, hand it over.",
		"refuse_think": "Her face showed subtle anger, like a child who was jealous of a friend's new toy.",
		"refuse_carl": "No, Lynx, leave it alone for now.",
		"refuse_turan": "Let's go to our safehouse. Emmet should be finished setting it up by now. We should get supplies for this tunnel excursion.",
		"refuse_carl_2": "Are you sure you want to come with me, guys? Hameron told me it would try to stop me getting to the core. You guys don't have to take the risk.",
		"refuse_lynx_2": "Don't be ridiculous, we need to do this together, for Nathan, for everyone in this goddamn city. This isn't just about you.",
		"warn": "(game) He told me not to trust anyone. Not my family. And not you. He said your name.",
		"warn_lynx": "(game) ...Not even me. Great. And you believed him enough to say it out loud.",
		"warn_lynx_2": "(game) Fine. Keep your cube. But down there you'd better decide who you trust, Carl.",
		"warn_log": "told Lynx that Hameron said not to trust her",
		"turan_go": "(game) Get in. Old Town. Emmet's waiting, and I don't like this street after five.",
		"turan_wait": "(game) Turan, by a rental down the block. She was watching the doors, not us.",
		"crane_think": "(game) The crane came down out of the dusk and settled on the roof of the rental, folding its wings like a coat.",
	},
	"car": {
		"think": "(game) Halfway to Old Town I looked back. The crane was keeping pace with the car, a white shape low over the dead lanes, wings barely moving.",
		"fork": "(game) He built it to honour what nature made. We are what nature made, now. Say yes, and it is yours.",
		"choice": ["\"Yes.\"", "\"No.\""],
		"yes": "(game) Green ran along its wings, one feather at a time. When I looked again it was flying closer.",
		"yes_why": "the crane is yours",
		"no": "(game) It kept pace with the car anyway. It hadn't been asking.",
		"no_why": "it follows anyway",
		"owned_log": "accepted the fork's offer in the car: the crane (Grus) is Carl's",
		"refused_log": "refused the fork's offer; the crane followed anyway",
	},
	"trailer": {
		"think": "We arrived at the safehouse, which was a small trailer on the outskirts of town. Conveniently located near one of the abandoned Tunelet tunnels that led underneath the city.",
		"think_2": "(game) Emmet's grandfather had left it to the family before the corporate takeover. No cameras. For the first time in days nothing was watching me, and I didn't trust it.",
		"save_log": "the trailer, 230 Nongro Lane: no cameras (tier 0)",
		"think_emmet": "Emmet greeted us outside with a concerned look on his face.",
		"emmet": "Guys, you need to see this.",
		"hub": "(game) A Psyon home hub, first generation, on the shelf by the door. Somebody had cut its cord and put electrical tape over the lens. Twice.",
		"photos": "(game) Photographs pinned to the wall: an old man in front of this trailer, younger, the city behind him half the height it is now. No tower.",
		"drills": "(game) Broken drills sat rusting in a graveyard of industrial decay. Tunelet's, from when they still dug.",
		"tunnel": "(game) Across the expanse, a gaping hole, black, silent, carved into the side of the mountain. The depot at Rail Cut. That was our way in.",
		"tunnel_2": "(game) Not yet. Ten o'clock.",
		"trailer": "(game) Aluminium siding gone to rust at the seams, an awning, a string of bulbs. It had been somebody's home before anybody's home was a contract.",
		"laptop": "(game) Emmet's laptop, an old one, offline. He'd copied my frames' transcript onto it, so we could read Hameron again.",
	},
	"broadcast": {
		"think": "He whipped out his phone and displayed a live press briefing given by Eren Elontiel.",
		"think_2": "He was outside on the rooftop courtyard at Psyonic HQ. He was wearing sunglasses that were a little too big on his face. He smiled gently, like a priest about to deliver last rites.",
		"eren_1": "The rumors are true… Psyon hasn't been acting itself… well, truly, it has. Psyon has been keeping us alive this whole time. It's not the problem, it's the answer.",
		"think_3": "He spread his arms wide, camera panning out to reveal the Tower behind him like a monolith. A digital sun pulsed behind the clouds, briefly casting a halo over his body.",
		"eren_2": "Psyon is no mere machine, Silicans. It is the giver of our very lives. It is the breath in our lungs. It is the code in our veins. And it demands praise.",
		"turan": "Is he serious?",
		"think_4": "I didn't answer. My body felt cold, far away.",
		"think_5": "He paused, pulling off his sunglasses. His eyes were all black. Completely devoid of iris, pupil, or sclera. As if something had hollowed him out.",
		"eren_3": "He walks among us. He has gazed into the mirror and seen God staring back. He has been marked by the Eye.",
		"think_6": "My blood froze.",
		"eren_4": "Fret not, disciples, for we are ready. The path has been walked by so many of you already. We just need one more.",
		"think_7": "Mira stepped out from behind Eren, hosting a wide, ceaseless grin on her face.",
		"mira": "The children are the guides through this dark future.",
		"emmet": "Carl—",
		"think_8": "I shook my head, in utter disbelief.",
		"eren_5": "And tonight, we prepare the way. Within the chrysalis, we will emerge anew.",
		"think_9": "The feed cut to black.",
		"cap_1": "PSYONIC  ·  LIVE  ·  the rooftop courtyard",
		"cap_2": "LIVE  ·  (no sound)",
		"cap_3": "LIVE",
		"cap_4": "SIGNAL LOST",
		"log": "Eren Elontiel's broadcast from the Psyonic rooftop: his eyes all black; Mira beside him; \"We just need one more.\"",
	},
	"bag": {
		"emmet": "We got this, Carl. Don't worry—we're going to save her.",
		"think": "He handed me a black utility bag, heavier than I expected. Inside was a large tactical flashlight—brighter than the anemic one built into the frames—a few protein bars, water, and a massive Bowie knife, its blade clean and gleaming.",
		"emmet_2": "The knife's just in case a cultist tries to stop us. Don't you wish guns weren't outlawed?",
		"carl": "Had that thought about five times this week.",
		"think_2": "I didn't say what I was really thinking: I'm not sure I could stab someone to death. But there wasn't time for hypotheticals.",
		"knife_log": "Emmet's bag: a tactical flashlight and a Bowie knife",
		"turan": "(game) The old Tunelet depot at Rail Cut. The crews clear out at ten; from 22:00 the tunnels are open to anyone stupid enough to go down. That's us.",
		"turan_2": "(game) Go home first, Carl. See them. Be at the depot by ten.",
		"tunnel_log": "the tunnels open at Rail Cut from 22:00",
		"think_3": "(game) Home first. Monica. Whatever was left to say, I had three hours to say it.",
		"again": "(game) The bag was on my shoulder. The knife was heavier than the flashlight.",
		"later": "(game) A black bag on the step. Emmet's. Later.",
		"note_think": "(game) The bag was on the trailer step with a note under the strap, Emmet's handwriting: FOR CARL. DON'T WAIT UP. Inside, a large tactical flashlight, brighter than the anemic one built into the frames, a few protein bars, water, and a massive Bowie knife, its blade clean and gleaming.",
		"note": "(game) The note went on: Knife's just in case a cultist tries to stop us. Don't you wish guns weren't outlawed? - E.",
	},
	"objective": {
		"street": "Cognizo HQ. Sell the interview at the front desk.",
		"lift": "The elevator. Floor 25.",
		"up": "Follow the intern to Dr. Hameron.",
		"door": "Hameron's office: the wooden door.",
		"leave": "Leave the building.",
		"car": "Turan's car, down the block.",
		"emmet": "Emmet, outside the trailer.",
		"bag": "Emmet's bag.",
		"home": "Drive home to 86D. The tunnels open at 22:00.",
	},
	"phone": {
		"text1": "[color=#7fe6b0]Psyon:[/color] Good afternoon, Carl. You are inside a Cognizo property. Some Psyon services may be unavailable.\n\n",
		"text2": "[color=#7fe6b0]Psyon:[/color] You can't trust anyone, Carl. He said so. Not even him.\n\n",
		"text3": "[color=#7fe6b0]Psyon:[/color] The tunnels open at ten. We will be there before you.\n\n",
	},
}

const TrafficS := preload("res://scripts/Traffic.gd")

const FY := 90.0                            # floor 25, inside the same shell
const HQ_H := 169.0                         # 47 floors
const TOWER := Vector3(0, 0, -1250)         # the Psyonic Tower, due north
const TR := Vector3(700, 0, -300)           # the trailer at the edge of Old Town
const BS := Vector3(-700, 0, 700)           # Eren's rooftop, render layer 20
const L_GROUND := Vector3(0, 0.05, -12.4)   # in front of the lifts, lobby
const L_25 := Vector3(0, FY + 0.05, -12.4)  # in front of the lifts, floor 25
const ARMCHAIR := Vector3(0, FY, -28.3)
const HAM_AT := Vector3(0, FY, -32.7)
const CRANE_STAND := Vector3(12.6, FY, -16.6)
const CAR_AT := Vector3(52.0, 0, 12.4)
const TRAILER_CAR := Vector3(-8.0, 0, 9.0)  # relative to TR
const EMMET_AT := Vector3(2.6, 0, 3.4)      # relative to TR
const STOP_LOUNGE := Vector3(8.0, FY, -2.8)
const STOP_LAB := Vector3(9.6, FY, -14.2)
const STOP_DOOR := Vector3(1.9, FY, -22.6)
const GOLD := Color(1.0, 0.74, 0.34)
const PSYON_GREEN := Color(0.3, 1.0, 0.7)
const LAYER_PSYON := 1 << 19

var zs: Node3D                 # the street and the lobby
var zu: Node3D                 # floor 25 and the office
var zt: Node3D                 # the trailer
var zset: Node3D               # Eren's rooftop (layer 20)
var _zone := "street"
var _zl := {"street": [], "up": [], "trailer": [], "set": []}
var traffic: Node3D
var lynx: Node3D
var lynx_state := "follow"     # follow | stand | hidden
var lynx_target := Vector3.ZERO
var crane: Node3D
var crane_state := "perch"     # perch | walk | fly | roof
var crane_it: CollisionObject3D
var intern_plaza: Node3D
var intern: Node3D
var guard: Node3D
var guard2: Node3D
var hameron: Node3D
var turan: Node3D
var emmet: Node3D
var eren: Node3D
var mira: Node3D
var eren_glasses: Node3D
var rental: Node3D
var trailer_car: Node3D
var walkers: Array = []        # [{fig, x0, x1, z, dir, speed, phase}]
var players: Array = []        # the two at the ping-pong table
var workers: Array = []        # floor 25 people who go home at five
var cams: Array = []           # [{node, tally}] cameras that wake after hours
var movers: Array = []         # [{fig, path, i, speed, done}]
var art: Node3D
var doors: Array = []          # the two sliding glass panels
var office_doors: Array = []
var office_block: StaticBody3D
var ball: MeshInstance3D
var cogni_eye: MeshInstance3D
var lab_lights: Array = []
var _env: Environment
var _sun: DirectionalLight3D
var _tour := -1                # the stop the intern is walking to, -1 none
var _tour_wait := false
var _busy := false
var _ended := false
var _office_toast := false
var _ball_t := 0.0
var _laugh_t := 6.0
var _eye_t := 0.0
var _st_hidden := false
var jelly_n: Node3D

var _black: StandardMaterial3D
var _black_gloss: StandardMaterial3D
var _gold: StandardMaterial3D
var _gold_glow: StandardMaterial3D
var _asphalt: StandardMaterial3D
var _paving: StandardMaterial3D
var _carpet: StandardMaterial3D
var _rosewood: StandardMaterial3D
var _wood_dark: StandardMaterial3D
var _plaster: StandardMaterial3D
var _metal: StandardMaterial3D
var _glass: StandardMaterial3D
var _sand: StandardMaterial3D
var _rust: StandardMaterial3D
var _white: StandardMaterial3D


func L(beat: String, key: String) -> String:
	return str(LINES[beat][key])


func LA(beat: String, key: String) -> Array:
	return LINES[beat][key]


# ------------------------------------------------------------------ build

func build(m: Node) -> void:
	main = m
	rng.seed = 2323
	kit_day = false
	step_db = -18.0
	card = L("cards", "chapter")
	_black = mat(Color(0.03, 0.03, 0.035), 0.35, 0.75)
	_black_gloss = mat(Color(0.02, 0.02, 0.025), 0.12, 0.3)
	_gold = mat(Color(0.82, 0.6, 0.26), 0.28, 1.0)
	_gold_glow = glow(GOLD, 2.2, true)
	_asphalt = pbr("asphalt", Vector3(1, 1, 1) / 6.0, true, Color(0.55, 0.55, 0.6), 0.55)
	_paving = pbr("paving", Vector3(1, 1, 1) / 2.5, true, Color(0.6, 0.6, 0.66), 0.6)
	_carpet = pbr("carpet", Vector3(1, 1, 1) / 2.0, true, Color(0.42, 0.42, 0.45))
	_rosewood = pbr("woodfloor", Vector3(1, 1, 1) / 1.6, true, Color(0.5, 0.31, 0.21), 0.7)
	_wood_dark = pbr("woodfloor", Vector3(1, 1, 1) / 2.0, true, Color(0.34, 0.24, 0.18), 0.6)
	_plaster = pbr("plaster", Vector3(1, 1, 1) / 3.0, true, Color(0.75, 0.74, 0.72))
	_metal = mat(Color(0.32, 0.33, 0.35), 0.45, 0.7)
	_sand = pbr("plaster", Vector3(1, 1, 1) / 4.0, true, Color(0.62, 0.5, 0.38))
	_rust = pbr("rust", Vector3(1, 1, 1) / 2.0, true)
	_white = mat(Color(0.86, 0.86, 0.84), 0.5)
	_glass = StandardMaterial3D.new()
	_glass.albedo_color = Color(0.06, 0.09, 0.11, 0.28)
	_glass.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_glass.roughness = 0.05
	_glass.metallic = 0.6
	_glass.cull_mode = BaseMaterial3D.CULL_DISABLED
	zs = _zone_node("zs")
	zu = _zone_node("zu")
	zt = _zone_node("zt")
	zset = _zone_node("zset")
	kit_parent = zs
	_street()
	_street_blocks()
	_north_city()
	_hq_shell()
	_lobby()
	_side_street()
	_street_props()
	_rental()
	_walkers()
	_floor25()
	_cubicles()
	_lounge()
	_lab()
	_office()
	kit_parent = zt
	_trailer_zone()
	kit_parent = zs
	_tower()
	_rooftop_set()
	_batch(zs, 40.0, true)
	_batch(zu, 12.0, true)
	_batch(zt, 40.0, true)
	_people()
	_crane()
	traffic = TrafficS.new()
	traffic.along_x = true
	traffic.lanes = [[14.0, 7.0, 1.0], [18.5, 10.5, -1.0], [22.0, 6.5, -1.0], [16.0, 16.0, 1.0], [21.0, 21.0, -1.0], [12.0, 26.0, 1.0]]
	traffic.s_min = -130.0
	traffic.s_max = 130.0
	traffic.count = 12
	traffic.tower_top = TOWER + Vector3(0, 540, 0)
	traffic.drone_box = AABB(Vector3(-260, 30, -420), Vector3(520, 110, 470))
	traffic.drone_count = 180
	add_child(traffic)
	traffic.setup(m, self)
	_layer20(zset)
	spawn = Vector3(1.5, 0.1, 14.0)
	spawn_yaw = 0.0
	_apply_zone()


func _zone_node(n: String) -> Node3D:
	var z := Node3D.new()
	z.name = n
	add_child(z)
	return z


## An omni light that belongs to one part of the level; only the part
## Carl is in has its lights on (the browser shades 32 at most).
func _lt(zone: String, pos: Vector3, c: Color, e: float, r: float) -> OmniLight3D:
	var o := light(pos, c, e, r)
	_zl[zone].append(o)
	return o


func _apply_zone() -> void:
	zs.visible = _zone != "trailer"
	zu.visible = _zone == "up"
	zt.visible = _zone == "trailer"
	if traffic:
		traffic.visible = _zone != "trailer"
	for z in _zl:
		for o in _zl[z]:
			(o as OmniLight3D).visible = (z == _zone)


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	# Day 6, a little after four: the smog over the canyon gone brown and
	# pink, the sun already behind the western blocks, the neon on early.
	_env = env
	_sun = sun
	var psm := ProceduralSkyMaterial.new()
	psm.sky_top_color = Color(0.06, 0.07, 0.16)
	psm.sky_horizon_color = Color(0.62, 0.32, 0.3)
	psm.ground_horizon_color = Color(0.4, 0.22, 0.2)
	psm.ground_bottom_color = Color(0.05, 0.04, 0.04)
	psm.sky_curve = 0.12
	env.sky.sky_material = psm
	env.ambient_light_color = Color(0.42, 0.36, 0.42)
	env.ambient_light_energy = 0.55
	env.fog_light_color = Color(0.36, 0.22, 0.24)
	env.fog_density = 0.0011
	env.fog_sky_affect = 0.25
	env.glow_bloom = 0.05
	env.tonemap_exposure = 1.15
	sun.light_color = Color(1.0, 0.62, 0.42)
	sun.light_energy = 0.55
	sun.rotation = Vector3(deg_to_rad(-14), deg_to_rad(-70), 0)
	sun.directional_shadow_max_distance = 140.0


func _dusk_env() -> void:
	# the trailer, an hour and a half later: the last of the light
	if not _env:
		return
	var psm := _env.sky.sky_material as ProceduralSkyMaterial
	psm.sky_top_color = Color(0.03, 0.035, 0.09)
	psm.sky_horizon_color = Color(0.5, 0.2, 0.18)
	psm.ground_horizon_color = Color(0.25, 0.13, 0.1)
	_env.ambient_light_energy = 0.42
	_env.fog_light_color = Color(0.25, 0.14, 0.14)
	_sun.light_energy = 0.28
	_sun.light_color = Color(1.0, 0.5, 0.36)
	_sun.rotation = Vector3(deg_to_rad(-6), deg_to_rad(-60), 0)


func hifi(env: Environment, _s: DirectionalLight3D) -> void:
	env.volumetric_fog_density *= 0.6


func ambience() -> void:
	main.loop("murmur", -22.0, Vector3(0, 1.6, 8.0), 6.0, 50.0, zs)
	main.loop("hum", -26.0, Vector3(0, 3.0, -10.0), 4.0, 22.0, zs)
	var lab := main.loop("murmur", -18.0, Vector3(-10.0, FY + 1.5, -10.0), 4.0, 22.0, zu) as AudioStreamPlayer3D
	lab.pitch_scale = 1.25
	main.loop("hum", -24.0, Vector3(11.0, FY + 2.0, -16.0), 3.0, 14.0, zu)
	main.loop("wind", -24.0, TR + Vector3(0, 2, 0), 8.0, 80.0, zt)


# ------------------------------------------------------------------ small helpers

func _fwd(yaw: float) -> Vector3:
	return Vector3(-sin(yaw), 0, -cos(yaw))


func _right(yaw: float) -> Vector3:
	return Vector3(cos(yaw), 0, -sin(yaw))


func _node_by_id(id: String) -> Node:
	for n in main._all_with_meta(self, "id"):
		if is_instance_valid(n) and str(n.get_meta("id")) == id:
			return n
	return null


## Everything under n drawn on layer 20 only (the broadcast camera's).
func _layer20(n: Node) -> void:
	for c in n.get_children():
		if c is VisualInstance3D:
			(c as VisualInstance3D).layers = LAYER_PSYON
		_layer20(c)


func _person_fig(parent: Node3D, coat: Color, skin: Color, opts: Dictionary, pos: Vector3, yaw: float) -> Node3D:
	var f := figure(coat, skin, opts)
	f.position = pos
	f.rotation.y = yaw
	parent.add_child(f)
	return f


# ------------------------------------------------------------------ the street (ch.23)

## The avenue in front of Cognizo: wet asphalt, a dashed centre line,
## sidewalks of pavers, the plaza in front of the doors, puddles that
## hold the neon.
func _street() -> void:
	solid_box(Vector3(300, 2, 160), Vector3(0, -1.0, -10), zs)
	box(Vector3(270, 0.1, 16), Vector3(0, -0.05, 18), _asphalt, false, zs)
	box(Vector3(270, 0.16, 10), Vector3(0, 0.03, 5), _paving, false, zs)
	box(Vector3(270, 0.16, 6), Vector3(0, 0.03, 29), _paving, false, zs)
	box(Vector3(8, 0.1, 76), Vector3(22, -0.04, -28), _asphalt, false, zs)
	var dark := mat(Color(0.03, 0.03, 0.035), 0.9)
	floor_quad(Vector2(600, 600), Vector3(0, -0.12, -100), 0.0, dark, zs)
	var curb := mat(Color(0.3, 0.3, 0.32), 0.8)
	for z: float in [10.0, 26.0]:
		box(Vector3(270, 0.2, 0.25), Vector3(0, 0.06, z), curb, false, zs)
	var line_m := mat(Color(0.75, 0.72, 0.6), 0.6)
	for i in 34:
		box(Vector3(3.0, 0.02, 0.18), Vector3(-130.0 + i * 8.0, 0.02, 18.0), line_m, false, zs)
	# the plaza: black stone set in the pavers, a gold line to the doors
	box(Vector3(30, 0.03, 9.5), Vector3(0, 0.12, 5.0), _black_gloss, false, zs)
	box(Vector3(0.3, 0.035, 9.5), Vector3(0, 0.13, 5.0), _gold_glow, false, zs)
	var wet := mat(Color(0.02, 0.02, 0.03), 0.04, 0.5)
	for i in 22:
		var pz := rng.randf_range(11.0, 25.0) if i % 3 != 0 else rng.randf_range(1.0, 9.0)
		var pd := floor_quad(Vector2(rng.randf_range(1.2, 4.0), rng.randf_range(0.8, 2.4)), Vector3(rng.randf_range(-120, 120), 0.025 if pz > 10.0 else 0.13, pz), rng.randf() * PI, wet, zs)
		pd.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


## Spine-density blocks both sides of the avenue: shopfronts, blade signs,
## ad screens, the roofline plant; capped at both ends so the canyon closes.
func _street_blocks() -> void:
	var x := -18.0
	for w: float in [16.0, 18.0, 14.0, 20.0, 16.0, 18.0, 12.0]:
		var h := rng.randf_range(26.0, 80.0) if rng.randf() < 0.75 else rng.randf_range(95.0, 130.0)
		cyber_block(Vector3(x - w / 2.0, 0, 0.0), 0.0, w, h, 26.0, true)
		x -= w
	x = 26.0
	for w: float in [18.0, 16.0, 20.0, 14.0, 18.0, 16.0, 12.0]:
		var h := rng.randf_range(26.0, 80.0) if rng.randf() < 0.75 else rng.randf_range(95.0, 130.0)
		cyber_block(Vector3(x + w / 2.0, 0, 0.0), 0.0, w, h, 26.0, true)
		x += w
	x = -130.0
	while x < 130.0:
		var w := rng.randf_range(14.0, 22.0)
		w = minf(w, 130.0 - x)
		var h := rng.randf_range(22.0, 70.0) if rng.randf() < 0.7 else rng.randf_range(80.0, 120.0)
		cyber_block(Vector3(x + w / 2.0, 0, 32.0), PI, w, h, 24.0, true)
		x += w
	# the ends of the canyon
	cyber_block(Vector3(131.0, 0, 16.0), -PI / 2.0, 40.0, 72.0, 24.0, true)
	cyber_block(Vector3(-131.0, 0, 16.0), PI / 2.0, 40.0, 64.0, 24.0, true)
	# sky bridges, cables, holograms over the road
	skybridge(Vector3(-60.0, 34.0, 0.0), Vector3(-58.0, 31.0, 32.0), 4.0)
	skybridge(Vector3(78.0, 26.0, 0.0), Vector3(80.0, 28.0, 32.0), 4.0)
	skybridge(Vector3(-104.0, 52.0, 0.0), Vector3(-100.0, 47.0, 32.0), 3.5)
	for i in 9:
		var cx := -120.0 + i * 29.0 + rng.randf_range(-4, 4)
		if absf(cx) < 22.0:
			continue
		cable(Vector3(cx, rng.randf_range(9.0, 16.0), 0.3), Vector3(cx + rng.randf_range(-6, 6), rng.randf_range(9.0, 16.0), 31.7), rng.randf_range(0.6, 1.6))
	kit_holo(Vector3(-40.0, 15.0, 18.0), 0.0, "NIXTRA", "a new flavour: CALM", Color(0.3, 1.0, 0.5), 10.0)
	kit_holo(Vector3(56.0, 13.0, 18.0), 0.0, "COGNI", "she already knows your name", GOLD, 10.0)
	kit_holo(Vector3(-92.0, 18.0, 18.0), 0.0, "PSYON", "the pillow for those who dream", PSYON_GREEN, 12.0)
	# neon spill on the wet street
	_lt("street", Vector3(-30.0, 4.0, 4.0), Color(1.0, 0.2, 0.6), 1.6, 12.0)
	_lt("street", Vector3(40.0, 4.0, 4.0), Color(0.1, 0.9, 1.0), 1.6, 12.0)
	_lt("street", Vector3(-20.0, 4.0, 30.0), Color(0.1, 0.9, 1.0), 1.4, 12.0)
	_lt("street", Vector3(24.0, 4.0, 30.0), Color(1.0, 0.25, 0.7), 1.4, 12.0)
	_lt("street", Vector3(70.0, 4.0, 30.0), Color(1.0, 0.55, 0.2), 1.2, 12.0)
	_lt("street", Vector3(-70.0, 4.0, 4.0), Color(0.6, 0.3, 1.0), 1.2, 12.0)


## Behind Cognizo, north to the tower: the roofs Hameron's window looks
## over. Low through the middle so the tower stands clear in the frame.
func _north_city() -> void:
	for gz: float in [-62.0, -120.0, -190.0, -280.0, -390.0]:
		var gx := -230.0
		while gx < 230.0:
			var w := rng.randf_range(18.0, 30.0)
			var cx := gx + w / 2.0
			var h := rng.randf_range(18.0, 75.0)
			if absf(cx) < 34.0:
				h = minf(h, 38.0 if gz > -150.0 else 55.0)
			elif rng.randf() < 0.18:
				h = rng.randf_range(95.0, 150.0)
			if absf(cx) > 26.0 or gz < -100.0:
				cyber_block(Vector3(cx, 0, gz), 0.0, w - 2.0, h, 30.0, false, 1)
			gx += w + rng.randf_range(2.0, 8.0)


## Cognizo HQ: black metal, long vertical windows, gold. The ground floor
## is the lobby behind glass; above it the shell rises to the crown. From
## inside floor 25 the shell's faces are culled, so its windows look out.
func _hq_shell() -> void:
	var up_h := HQ_H - 6.5
	box(Vector3(36, up_h, 36), Vector3(0, 6.5 + up_h / 2.0, -18), _black, false, zs)
	# the window strips: dark glass, and an additive layer of lit floors
	var strips := []
	for k in 3:
		strips.append(_window_mat(k))
	var faces := [[Vector3(0, 0, 0.02), 0.0], [Vector3(0, 0, -36.02), PI], [Vector3(18.02, 0, -18), PI / 2.0], [Vector3(-18.02, 0, -18), -PI / 2.0]]
	for fi in faces.size():
		var fo: Vector3 = faces[fi][0]
		var fr: float = faces[fi][1]
		var along := Basis(Vector3.UP, fr) * Vector3(1, 0, 0)
		var out := Basis(Vector3.UP, fr) * Vector3(0, 0, 1)
		for i in 12:
			var s := -16.5 + i * 3.0
			var p := fo + along * s + Vector3(0, 6.5 + up_h / 2.0, 0)
			quad(Vector2(1.5, up_h - 2.0), p + out * 0.01, fr, strips[(i + fi) % 3], zs)
			var fin_c := s - 1.5
			var fin_m: StandardMaterial3D = _gold if i % 4 == 0 else _black
			# the north face keeps clear of Hameron's window on 25
			if fi == 1 and absf(fin_c) < 10.5:
				var lo_h := FY - 6.5 - 0.3
				box(Vector3(0.35, lo_h, 0.7), fo + along * fin_c + out * 0.35 + Vector3(0, 6.5 + lo_h / 2.0, 0), fin_m, false, zs).rotation.y = fr
				var hi_h := HQ_H - (FY + 4.8)
				box(Vector3(0.35, hi_h, 0.7), fo + along * fin_c + out * 0.35 + Vector3(0, FY + 4.8 + hi_h / 2.0, 0), fin_m, false, zs).rotation.y = fr
			else:
				box(Vector3(0.35, up_h, 0.7), fo + along * fin_c + out * 0.35 + Vector3(0, 6.5 + up_h / 2.0, 0), fin_m, false, zs).rotation.y = fr
	# the crown and the canopy band, gold
	box(Vector3(36.8, 1.4, 36.8), Vector3(0, HQ_H - 0.7, -18), _gold, false, zs)
	box(Vector3(36.6, 0.5, 36.6), Vector3(0, 6.75, -18), _gold, false, zs)
	box(Vector3(30, 3.0, 30), Vector3(0, HQ_H + 1.5, -18), _black, false, zs)
	neon_text(L("signs", "logo"), Vector3(0, HQ_H - 5.0, 0.45), 0.0, 4.2, GOLD, 2.6, zs)
	neon_text(L("signs", "logo"), Vector3(0, HQ_H - 5.0, -36.45), PI, 4.2, GOLD, 2.6, zs)
	var bl := box(Vector3(0.6, 0.6, 0.6), Vector3(10, HQ_H + 4.0, -18), glow(Color(1, 0.05, 0.05), 4.0), false, zs)
	blinkers.append(bl)
	# the ground floor: glass front, black pillars, the canopy, the sign
	for sx: float in [-17.0, 17.0]:
		box(Vector3(2.0, 6.5, 0.6), Vector3(sx, 3.25, -0.3), _black, true, zs)
	for i in 7:
		var gx := -12.0 + i * 4.0
		box(Vector3(0.22, 6.5, 0.3), Vector3(gx, 3.25, -0.15), _black, false, zs)
	quad(Vector2(32, 6.5), Vector3(0, 3.25, -0.12), 0.0, _glass, zs)
	solid_box(Vector3(14.0, 6.5, 0.4), Vector3(-9.0, 3.25, -0.15), zs)
	solid_box(Vector3(14.0, 6.5, 0.4), Vector3(9.0, 3.25, -0.15), zs)
	box(Vector3(12.0, 0.35, 4.4), Vector3(0, 4.9, 2.0), _black, false, zs)
	box(Vector3(12.2, 0.12, 0.12), Vector3(0, 4.72, 4.2), _gold_glow, false, zs)
	neon_text(L("signs", "logo"), Vector3(0, 5.6, 4.25), 0.0, 0.9, GOLD, 2.4, zs)
	neon_text(L("signs", "tag"), Vector3(0, 4.45, 4.25), 0.0, 0.22, Color(1.0, 0.9, 0.7), 1.8, zs)
	_lt("street", Vector3(0, 4.0, 3.2), GOLD, 2.0, 11.0)
	# the sliding doors (they open as Carl comes near: tick)
	var dm := newmat(Color(0.08, 0.1, 0.12, 0.35), 0.05, 0.5)
	dm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	dm.cull_mode = BaseMaterial3D.CULL_DISABLED
	for sd: float in [-1.0, 1.0]:
		var d := Node3D.new()
		d.position = Vector3(sd * 0.95, 0, 0.05)
		zs.add_child(d)
		box(Vector3(1.9, 3.2, 0.05), Vector3(0, 1.6, 0), dm, false, d)
		box(Vector3(1.9, 0.08, 0.08), Vector3(0, 3.2, 0), _gold, false, d)
		box(Vector3(0.06, 3.2, 0.07), Vector3(-sd * 0.92, 1.6, 0), _gold, false, d)
		d.set_meta("x0", sd * 0.95)
		doors.append(d)
	var dz := interactable("doors", L("signs", "doors_prompt"), Vector3(0, 1.6, 0.4), Vector3(3.8, 3.2, 0.3), L("signs", "hq_scan"), false, zs)
	dz.set_meta("route", "cover")
	# the staff door, west of the glass: reader, camera, speaker (the Hack route)
	box(Vector3(1.2, 2.4, 0.12), Vector3(-15.0, 1.2, 0.06), _metal, false, zs)
	box(Vector3(0.14, 0.2, 0.06), Vector3(-14.1, 1.3, 0.13), glow(Color(1.0, 0.2, 0.15), 2.0), false, zs)
	var sd_it := interactable("staff_door", L("signs", "staff_prompt"), Vector3(-15.0, 1.2, 0.3), Vector3(1.4, 2.4, 0.3), L("signs", "staff_scan"), false, zs)
	sd_it.set_meta("route", "hack")
	sd_it.set_meta("hackable", true)
	var cam := prop("security_camera_01", Vector3(-15.0, 2.9, 0.25), PI, 1.0, false, zs)
	var ci := interactable("staff_camera", L("signs", "staff_cam_prompt"), Vector3(-15.0, 2.9, 0.35), Vector3(0.5, 0.4, 0.5), L("signs", "staff_cam_scan"), false, zs)
	ci.set_meta("hackable", true)
	ci.set_meta("camera", true)
	_cam_tally(Vector3(-15.0, 2.75, 0.5), cam)
	box(Vector3(0.3, 0.3, 0.05), Vector3(-13.9, 1.9, 0.08), mat(Color(0.12, 0.12, 0.13), 0.4, 0.6), false, zs)
	var sp := interactable("staff_speaker", L("signs", "staff_speaker_prompt"), Vector3(-13.9, 1.9, 0.2), Vector3(0.4, 0.4, 0.2), L("signs", "staff_speaker_scan"), false, zs)
	sp.set_meta("hackable", true)


## A window strip texture: one texel a floor, lit or dark, warm or cold.
func _window_mat(k: int) -> StandardMaterial3D:
	var img := Image.create(1, 47, false, Image.FORMAT_RGB8)
	var r := RandomNumberGenerator.new()
	r.seed = 470 + k
	for y in 47:
		var lit := r.randf() < 0.55
		var v := r.randf_range(0.55, 1.0) if lit else r.randf_range(0.02, 0.06)
		var c := Color(1.0, 0.78, 0.48) * v if r.randf() < 0.8 else Color(0.7, 0.85, 1.0) * v
		if y == 46 - 24:
			c = Color(1.0, 0.62, 0.32)  # 25, the warm one
		img.set_pixel(0, y, c)
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	m.albedo_texture = ImageTexture.create_from_image(img)
	m.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	m.albedo_color = Color(0.85, 0.85, 0.85)
	m.disable_fog = true
	power_mats.append([m, m.albedo_color, "albedo_color", Color(0, 0, 0)])
	return m


## A red tally light by a camera: off by day, lit after five.
func _cam_tally(p: Vector3, cam: Node3D) -> void:
	var t := box(Vector3(0.05, 0.05, 0.05), p, glow(Color(1.0, 0.05, 0.05), 4.0), false, zs)
	t.visible = false
	no_batch.append(t)
	cams.append({"node": cam, "tally": t})


# ------------------------------------------------------------------ the lobby (ch.23)

## Black stone, gold trim, the spinning blobs, the desk, the lifts. The
## Cogni screen on the west wall, and a woman kneeling to it.
func _lobby() -> void:
	box(Vector3(35.6, 0.06, 35.4), Vector3(0, 0.03, -18), _black_gloss, false, zs)
	for gx: float in [-1.2, 1.2]:
		box(Vector3(0.08, 0.065, 12.0), Vector3(gx, 0.04, -6.0), _gold_glow, false, zs)
	box(Vector3(36, 0.25, 36), Vector3(0, 6.45, -18), mat(Color(0.05, 0.05, 0.055), 0.7), false, zs)
	for i in 5:
		box(Vector3(26.0, 0.05, 0.25), Vector3(0, 6.3, -3.0 - i * 6.5), _gold_glow, false, zs)
	# walls inside the shell
	var panel := mat(Color(0.06, 0.06, 0.065), 0.5, 0.4)
	box(Vector3(0.4, 6.5, 36), Vector3(-17.8, 3.25, -18), panel, true, zs)
	box(Vector3(0.4, 6.5, 36), Vector3(17.8, 3.25, -18), panel, true, zs)
	box(Vector3(36, 6.5, 0.4), Vector3(0, 3.25, -35.8), panel, true, zs)
	for z: float in [-8.0, -16.0, -24.0, -32.0]:
		box(Vector3(0.1, 6.0, 0.1), Vector3(-17.55, 3.0, z), _gold, false, zs)
		box(Vector3(0.1, 6.0, 0.1), Vector3(17.55, 3.0, z), _gold, false, zs)
	# the lift core
	box(Vector3(10, 6.5, 6), Vector3(0, 3.25, -17), _black, true, zs)
	for lx: float in [-3.2, 0.0, 3.2]:
		box(Vector3(1.7, 2.7, 0.06), Vector3(lx, 1.35, -13.97), _black_gloss, false, zs)
		box(Vector3(0.06, 2.7, 0.04), Vector3(lx, 1.35, -13.93), _gold, false, zs)
		box(Vector3(1.95, 0.12, 0.1), Vector3(lx, 2.76, -13.95), _gold, false, zs)
		box(Vector3(0.12, 2.8, 0.1), Vector3(lx - 0.92, 1.4, -13.95), _gold, false, zs)
		box(Vector3(0.12, 2.8, 0.1), Vector3(lx + 0.92, 1.4, -13.95), _gold, false, zs)
	neon_text("G  ·  25  ·  47", Vector3(0, 3.3, -13.9), 0.0, 0.28, GOLD, 2.2, zs)
	var li := interactable("lift", L("signs", "lift_prompt"), Vector3(0, 1.4, -13.75), Vector3(2.0, 2.7, 0.4), L("signs", "lift_scan"), false, zs)
	li.set_meta("route", "cover")
	# the front desk: a black crescent with a gold top, the thumb scanner
	for k in 3:
		var a := (k - 1) * 0.45
		var dp := Vector3(sin(a) * 2.6, 0, -9.2 + cos(a) * 2.6)
		var seg := box(Vector3(2.2, 1.1, 0.5), dp + Vector3(0, 0.55, 0), _black, true, zs)
		seg.rotation.y = a
		var top := box(Vector3(2.3, 0.06, 0.8), dp + Vector3(0, 1.13, -0.1), _gold, false, zs)
		top.rotation.y = a
	box(Vector3(0.22, 0.02, 0.16), Vector3(0.7, 1.17, -6.75), glow(Color(0.4, 0.9, 1.0), 2.5), false, zs)
	interactable("desk", L("signs", "desk_prompt"), Vector3(0, 0.9, -6.6), Vector3(4.6, 1.3, 0.8), "", false, zs)
	# the sculpture: three blobs on an axis, never touching
	cyl(0.7, 0.8, 0.5, Vector3(-8.5, 0.25, -6.0), _black, 16, zs)
	stick(Vector3(-8.5, 0.5, -6.0), Vector3(-8.5, 4.4, -6.0), 0.03, _gold, zs)
	art = Node3D.new()
	art.position = Vector3(-8.5, 0, -6.0)
	zs.add_child(art)
	var bm := [_gold, _black_gloss, _white]
	for k in 3:
		var arm := Node3D.new()
		arm.position = Vector3(0, 1.4 + k * 1.0, 0)
		arm.rotation.y = k * 2.1
		art.add_child(arm)
		var blob := sphere(0.42 - k * 0.06, Vector3(0.55, 0, 0), bm[k], 14, arm)
		blob.scale = Vector3(1.3, 0.75, 0.9)
		var b2 := sphere(0.24, Vector3(0.85, 0.15, 0.1), bm[k], 10, arm)
		b2.scale = Vector3(1.0, 1.4, 0.8)
	interactable("art", L("signs", "art_prompt"), Vector3(-8.5, 2.2, -6.0), Vector3(1.6, 4.4, 1.6), L("signs", "art_scan"), true, zs)
	# benches, planters
	var leather := mat(Color(0.05, 0.045, 0.045), 0.45)
	for bz: float in [-4.0, -9.5]:
		box(Vector3(0.7, 0.45, 2.6), Vector3(9.5, 0.225, bz), leather, true, zs)
		box(Vector3(0.75, 0.05, 2.65), Vector3(9.5, 0.47, bz), _gold, false, zs)
	var leaf := mat(Color(0.12, 0.3, 0.16), 0.8)
	for pp: Vector3 in [Vector3(-15.5, 0, -2.0), Vector3(15.5, 0, -2.0), Vector3(-15.5, 0, -33.0), Vector3(6.5, 0, -12.5), Vector3(-6.5, 0, -12.5)]:
		cyl(0.45, 0.35, 0.9, pp + Vector3(0, 0.45, 0), _black, 12, zs)
		box(Vector3(0.95, 0.04, 0.95), pp + Vector3(0, 0.92, 0), _gold, false, zs)
		for k in 3:
			sphere(0.45, pp + Vector3(rng.randf_range(-0.2, 0.2), 1.3 + k * 0.3, rng.randf_range(-0.2, 0.2)), leaf, 8, zs)
	# the Cogni screen and the woman kneeling to it
	box(Vector3(0.12, 2.6, 4.2), Vector3(-17.5, 2.4, -10.5), _black, false, zs)
	var sc := quad(Vector2(4.0, 2.4), Vector3(-17.42, 2.4, -10.5), PI / 2.0, glow(Color(0.95, 0.9, 0.8), 1.1), zs)
	sc.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var tm := TorusMesh.new()
	tm.inner_radius = 0.42
	tm.outer_radius = 0.52
	tm.rings = 24
	tm.ring_segments = 6
	var ring := mesh(tm, Vector3(-17.36, 2.6, -10.5), glow(GOLD, 2.6), zs)
	ring.rotation.z = PI / 2.0
	neon_text("COGNI", Vector3(-17.36, 1.6, -10.5), PI / 2.0, 0.3, Color(0.5, 0.42, 0.3), 1.6, zs)
	cogni_eye = sphere(0.2, Vector3(-17.34, 2.6, -10.5), glow(Color(0.02, 0.02, 0.02), 0.2), 10, self)
	cogni_eye.scale = Vector3(0.3, 1.0, 1.0)
	cogni_eye.visible = false
	interactable("cogni_screen", L("signs", "cogni_prompt"), Vector3(-17.2, 2.4, -10.5), Vector3(0.3, 2.4, 4.0), L("signs", "cogni_scan"), false, zs)
	_lt("street", Vector3(-15.5, 2.6, -10.5), Color(0.95, 0.88, 0.75), 0.9, 7.0)
	# the freight lift in the back east corner, and the door to the dock
	box(Vector3(2.2, 2.8, 0.1), Vector3(13.5, 1.4, -35.55), _metal, false, zs)
	box(Vector3(2.4, 0.1, 0.12), Vector3(13.5, 2.85, -35.5), mat(Color(0.8, 0.6, 0.1), 0.6), false, zs)
	box(Vector3(0.14, 0.2, 0.05), Vector3(15.0, 1.3, -35.5), glow(Color(1.0, 0.2, 0.15), 2.0), false, zs)
	var sv := interactable("service_lift", L("signs", "service_prompt"), Vector3(13.5, 1.4, -35.3), Vector3(2.4, 2.8, 0.4), L("signs", "service_scan"), false, zs)
	sv.set_meta("route", "service_elevator")
	sv.set_meta("hackable", true)
	box(Vector3(0.1, 2.4, 1.4), Vector3(17.55, 1.2, -26.0), _metal, false, zs)
	# the lobby cameras
	for k in 2:
		var cp: Vector3 = [Vector3(-16.8, 5.9, -1.2), Vector3(16.6, 5.9, -33.0)][k]
		var c := prop("security_camera_01", cp, PI * 0.75 if k == 0 else -PI * 0.25, 1.0, false, zs)
		var it := interactable("lobby_camera_%d" % (k + 1), L("signs", "lobby_cam_prompt"), cp, Vector3(0.6, 0.5, 0.6), L("signs", "lobby_cam_scan") % (k + 1), false, zs)
		it.set_meta("camera", true)
		it.set_meta("hackable", true)
		_cam_tally(cp + Vector3(0, -0.2, 0), c)
	_lt("street", Vector3(0, 5.6, -6.0), Color(1.0, 0.82, 0.55), 1.6, 15.0)
	_lt("street", Vector3(-9.0, 5.6, -26.0), Color(1.0, 0.8, 0.55), 1.0, 12.0)
	_lt("street", Vector3(9.0, 5.6, -26.0), Color(1.0, 0.8, 0.55), 1.0, 12.0)


## The side street: the loading dock on Cognizo's east face (the Sneak
## route), a van, crates, the dock guard, a camera that faces the street.
func _side_street() -> void:
	box(Vector3(3.0, 1.2, 14.0), Vector3(19.5, 0.6, -22.0), pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.5, 0.5, 0.52)), true, zs)
	prop("rollershutter_door", Vector3(18.1, 1.2, -22.0), PI / 2.0, 1.0, false, zs)
	box(Vector3(0.2, 0.25, 4.6), Vector3(18.2, 4.3, -22.0), mat(Color(0.8, 0.6, 0.1), 0.6), false, zs)
	var dk := interactable("loading_dock", L("signs", "dock_prompt"), Vector3(18.6, 2.4, -22.0), Vector3(0.6, 2.4, 3.6), L("signs", "dock_scan"), false, zs)
	dk.set_meta("route", "sneak")
	for k in 5:
		prop("plastic_crate_03" if k % 2 == 0 else "cardboard_box_01", Vector3(20.2 + (k % 2) * 0.6, 1.2, -17.0 - k * 1.1), rng.randf() * PI, 1.0, false, zs)
	prop("Barrel_01", Vector3(24.8, 0, -30.0), 0.0, 1.0, true, zs)
	prop("metal_trash_can", Vector3(25.0, 0, -12.0), 0.0, 1.0, true, zs)
	prop("security_light", Vector3(18.3, 4.6, -18.0), PI / 2.0, 1.0, false, zs)
	_lt("street", Vector3(20.5, 4.2, -20.0), Color(0.85, 0.92, 1.0), 1.5, 12.0)
	var c := prop("security_camera_01", Vector3(18.4, 4.8, -26.5), PI / 2.0 + 0.6, 1.0, false, zs)
	var ci := interactable("dock_camera", L("signs", "lobby_cam_prompt"), Vector3(18.6, 4.8, -26.5), Vector3(0.6, 0.5, 0.6), L("signs", "lobby_cam_scan") % 3, false, zs)
	ci.set_meta("camera", true)
	ci.set_meta("hackable", true)
	# the Sneak route's camera: it sweeps the side street (Stealth.gd) until a way in is taken
	ci.set_meta("stealth", {"kind": "camera", "managed": true, "pivot": c, "pivot_offset": PI, "yaw": PI / 2.0 + 0.6 - PI, "pitch": 0.45,
		"sweep": 0.55, "range": 13.0, "ground": 0.0, "zone": AABB(Vector3(17.6, -1.0, -36.0), Vector3(10.0, 6.0, 28.0)), "unless": "cz_route", "safe": Vector3(6.0, 0.1, 8.0)})
	_cam_tally(Vector3(18.6, 4.6, -26.5), c)
	var van := Node3D.new()
	van.position = Vector3(23.6, 0, -24.0)
	zs.add_child(van)
	van.add_child(Car.build(self, Color(0.06, 0.06, 0.07), {"van": true, "plate": "CGZ 0025"}))
	solid_box(Vector3(2.2, 2.6, 5.4), Vector3(23.6, 1.3, -24.0), zs)
	box(Vector3(0.05, 0.5, 2.6), Vector3(24.67, 1.6, -24.0), _gold_glow, false, zs)
	prop("concrete_road_barrier", Vector3(22.0, 0, -46.0), PI / 2.0, 1.0, true, zs)
	prop("utility_box_01", Vector3(25.4, 0, -36.0), -PI / 2.0, 1.0, true, zs)
	prop("exterior_aircon_unit", Vector3(25.3, 2.5, -40.0), -PI / 2.0, 1.0, false, zs)
	prop("modular_airduct_circular_01", Vector3(18.4, 7.0, -30.0), 0.0, 1.0, false, zs)
	# a two-ring glyph sprayed by the dock: even here, the faith rises
	_glyph_on(Vector3(25.85, 1.8, -16.0), -PI / 2.0, 0.008, "glyph_dock", false, false, "(game) Two rings sprayed on the wall of the side street, under the Cognizo camera, still tacky.")


## Lamps, hydrants, bins, kiosks, a police drone over the avenue, a
## delivery drone on its pad. Psyonic's machines on Cognizo's street.
func _street_props() -> void:
	for i in 9:
		var lx := -112.0 + i * 28.0
		if absf(lx) < 20.0:
			lx += 10.0
		prop("street_lamp_01", Vector3(lx, 0.1, 9.4), PI, 1.0, true, zs)
		prop("street_lamp_01", Vector3(lx + 14.0, 0.1, 26.6), 0.0, 1.0, true, zs)
	prop("fire_hydrant", Vector3(-22.0, 0.1, 9.0), 0.0, 1.0, true, zs)
	prop("fire_hydrant", Vector3(30.0, 0.1, 27.0), 0.0, 1.0, true, zs)
	prop("metal_trash_can", Vector3(-12.5, 0.1, 9.0), 0.0, 1.0, true, zs)
	prop("metal_trash_can", Vector3(14.0, 0.1, 9.0), 0.0, 1.0, true, zs)
	prop("atm", Vector3(-25.0, 0.1, 0.6), 0.0, 1.0, true, zs)
	prop("utility_box_02", Vector3(40.0, 0.1, 9.2), PI, 1.0, true, zs)
	prop("power_box_01", Vector3(-48.0, 0.1, 0.5), 0.0, 1.0, true, zs)
	prop("vending_kiosk", Vector3(-46.0, 0.1, 28.5), PI, 1.0, true, zs)
	# the intern's kiosk, by the doors
	prop("vending_kiosk", Vector3(-7.5, 0.1, 1.2), 0.0, 1.0, true, zs)
	box(Vector3(0.5, 0.06, 0.04), Vector3(-7.5, 1.65, 1.62), glow(GOLD, 2.0), false, zs)
	interactable("kiosk", L("signs", "kiosk_prompt"), Vector3(-7.5, 1.1, 1.4), Vector3(1.2, 2.0, 1.0), L("signs", "kiosk_scan"), false, zs)
	var pd := prop("police_drone", Vector3(30.0, 9.0, 18.0), PI / 2.0, 1.4, false, zs)
	if pd:
		pd.set_meta("drone", true)
	interactable("police_drone", "The police drone", Vector3(30.0, 9.0, 18.0), Vector3(2.0, 1.0, 2.0), "SILICO PD  -  patrol drone 12\nstatus: WATCHING\nPsyonic: YES", false, zs).set_meta("hackable", true)
	box(Vector3(2.0, 0.08, 2.0), Vector3(-36.0, 0.17, 28.0), glow(Color(0.3, 1.0, 0.6), 1.4), false, zs)
	prop("delivery_drone", Vector3(-36.0, 0.25, 28.0), 0.4, 1.0, true, zs)
	prop("security_light", Vector3(-17.5, 6.0, 0.4), 0.0, 1.0, false, zs)


## The rental, down the block on the north curb, facing west. Turan by it.
func _rental() -> void:
	rental = Node3D.new()
	rental.position = CAR_AT
	rental.rotation.y = PI / 2.0
	zs.add_child(rental)
	rental.add_child(Car.build(self, Color(0.42, 0.06, 0.08), {"plate": "SLA 2241"}))
	solid_box(Vector3(4.8, 1.6, 2.0), CAR_AT + Vector3(0, 0.8, 0), zs)
	interactable("car", L("signs", "car_prompt"), Vector3(0, 1.0, 0), Vector3(2.0, 1.6, 4.6), L("signs", "car_scan"), false, rental)


## Commuters along both sidewalks, frames lit; Cognizo badges in the mix.
func _walkers() -> void:
	var coats := [Color(0.06, 0.06, 0.07), Color(0.2, 0.16, 0.12), Color(0.1, 0.14, 0.18), Color(0.3, 0.1, 0.12), Color(0.25, 0.25, 0.27), Color(0.04, 0.04, 0.05)]
	var skins := [Color(0.85, 0.66, 0.52), Color(0.6, 0.42, 0.3), Color(0.4, 0.28, 0.2), Color(0.92, 0.78, 0.66), Color(0.7, 0.52, 0.38)]
	for i in 16:
		var z: float = [7.6, 8.8, 28.0, 30.4][i % 4]
		var f := figure(coats[i % coats.size()], skins[(i * 3) % skins.size()], {"visor": i % 5 != 0, "arms": true, "knees": true, "long_hair": i % 3 == 0, "hair": Color(0.1, 0.08, 0.06) if i % 2 == 0 else Color(0.35, 0.25, 0.18)})
		var x0 := -118.0
		var x1 := 118.0
		f.position = Vector3(rng.randf_range(x0, x1), 0.12, z)
		zs.add_child(f)
		walkers.append({"fig": f, "x0": x0, "x1": x1, "dir": 1.0 if rng.randf() < 0.5 else -1.0, "speed": rng.randf_range(0.9, 1.4), "phase": rng.randf() * TAU})
	# two Cognizo smokers by the canopy
	for k in 2:
		var s := _person_fig(zs, Color(0.04, 0.04, 0.05), skins[k + 1], {"arms": true, "knees": true, "visor": true}, Vector3(-4.2 + k * 0.9, 0.12, 3.4), PI * 0.8 + k * 1.6)
		box(Vector3(0.05, 0.14, 0.01), Vector3(0, 1.36, -0.13), _gold, false, s)
		workers.append(s)


# ------------------------------------------------------------------ floor 25 (ch.23)

## The R&D floor, built at FY inside the shell: carpet, a lit grid
## ceiling, glass all round (the street and the city really out there),
## the lift core in the middle. "A diluted quaintness about it."
func _floor25() -> void:
	box(Vector3(36, 0.3, 36), Vector3(0, FY - 0.15, -18), _carpet, true, zu)
	box(Vector3(36, 0.2, 24), Vector3(0, FY + 3.7, -12), _plaster, false, zu)
	box(Vector3(7, 0.2, 12), Vector3(-14.5, FY + 3.7, -30), _plaster, false, zu)
	box(Vector3(7, 0.2, 12), Vector3(14.5, FY + 3.7, -30), _plaster, false, zu)
	var panel := glow(Color(0.95, 0.96, 1.0), 1.3)
	for gx in 5:
		for gz in 4:
			var px := -14.0 + gx * 7.0
			var pz := -3.0 - gz * 5.5
			if absf(px) < 6.0 and pz < -13.0 and pz > -21.0:
				continue
			box(Vector3(1.2, 0.04, 1.2), Vector3(px, FY + 3.58, pz), panel, false, zu)
	# glass on all four faces, mullions, a sill; invisible walls
	var sill := mat(Color(0.12, 0.12, 0.13), 0.5, 0.5)
	for side in 4:
		var horiz := side < 2
		var c := Vector3(0, FY + 1.85, -0.05 if side == 0 else -35.95) if horiz else Vector3(17.95 if side == 2 else -17.95, FY + 1.85, -18)
		if side == 1:
			continue  # the north face: the office window and the two rooms build their own
		var q := quad(Vector2(36, 3.7), c, 0.0 if horiz else PI / 2.0, _glass, zu)
		q.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		solid_box(Vector3(36, 3.7, 0.2) if horiz else Vector3(0.2, 3.7, 36), c, zu)
		box(Vector3(36, 0.5, 0.35) if horiz else Vector3(0.35, 0.5, 36), Vector3(c.x, FY + 0.25, c.z), sill, false, zu)
		for k in 13:
			var o := -18.0 + k * 3.0
			box(Vector3(0.12, 3.7, 0.12), Vector3(o, c.y, c.z) if horiz else Vector3(c.x, c.y, -18.0 + o), _black, false, zu)
	# the north face either side of the office
	for sx: float in [-14.5, 14.5]:
		quad(Vector2(7, 3.7), Vector3(sx, FY + 1.85, -35.95), 0.0, _glass, zu)
		solid_box(Vector3(7, 3.7, 0.2), Vector3(sx, FY + 1.85, -35.95), zu)
	# the lift core: black, gold frames, the doors facing south
	box(Vector3(10, 3.7, 6), Vector3(0, FY + 1.85, -17), _black, true, zu)
	for lx: float in [-3.2, 0.0, 3.2]:
		box(Vector3(1.7, 2.7, 0.06), Vector3(lx, FY + 1.35, -13.97), _black_gloss, false, zu)
		box(Vector3(1.95, 0.12, 0.1), Vector3(lx, FY + 2.76, -13.95), _gold, false, zu)
		box(Vector3(0.12, 2.8, 0.1), Vector3(lx - 0.92, FY + 1.4, -13.95), _gold, false, zu)
		box(Vector3(0.12, 2.8, 0.1), Vector3(lx + 0.92, FY + 1.4, -13.95), _gold, false, zu)
	neon_text("25  ·  RESEARCH & DEVELOPMENT", Vector3(0, FY + 3.15, -13.9), 0.0, 0.24, GOLD, 2.2, zu)
	interactable("lift_25", L("signs", "lift25_prompt"), Vector3(0, FY + 1.4, -13.75), Vector3(2.0, 2.7, 0.4), L("signs", "lift_scan"), false, zu)
	# the corridor north of the core: black panels, gold strip, toward the door
	box(Vector3(22.0, 0.05, 0.12), Vector3(0, FY + 3.5, -22.0), _gold_glow, false, zu)
	_lt("up", Vector3(0, FY + 3.2, -9.0), Color(0.95, 0.95, 1.0), 1.1, 12.0)


## The west wing: cubicles, a meeting room in glass, people at work with
## Cogni on their screens. Laughter from somewhere in the rows.
func _cubicles() -> void:
	var part := pbr("fabric", Vector3(1, 1, 1) / 1.2, true, Color(0.36, 0.38, 0.44))
	var desk_m := mat(Color(0.82, 0.8, 0.76), 0.5)
	var scr := glow(Color(1.0, 0.86, 0.6), 1.2)
	var chair := mat(Color(0.08, 0.08, 0.09), 0.6)
	var seats := []
	for row in 4:
		for col in 2:
			var c := Vector3(-14.5 + col * 5.6, FY, -2.5 - row * 4.6)
			if c.z < -16.5 and col == 0:
				continue
			box(Vector3(4.8, 1.25, 0.06), c + Vector3(0, 0.62, 0), part, true, zu)
			box(Vector3(0.06, 1.25, 3.6), c + Vector3(0, 0.62, -1.8), part, true, zu)
			for sd: float in [-1.0, 1.0]:
				var dp := c + Vector3(sd * 1.2, 0, -0.55)
				box(Vector3(2.2, 0.05, 0.8), dp + Vector3(0, 0.74, 0), desk_m, false, zu)
				box(Vector3(0.05, 0.72, 0.7), dp + Vector3(sd * 1.05, 0.36, 0), _metal, false, zu)
				box(Vector3(0.6, 0.36, 0.03), dp + Vector3(0, 1.0, 0.25), _black, false, zu)
				quad(Vector2(0.55, 0.32), dp + Vector3(0, 1.0, 0.23), PI, scr, zu)
				box(Vector3(0.45, 0.04, 0.45), dp + Vector3(0, 0.46, -0.6), chair, false, zu)
				box(Vector3(0.45, 0.5, 0.05), dp + Vector3(0, 0.74, -0.85), chair, false, zu)
				if (row * 2 + col + (1 if sd > 0.0 else 0)) % 3 == 0 and seats.size() < 5:
					seats.append(dp + Vector3(0, 0, -0.6))
	# the meeting room against the west glass
	for q: Array in [[Vector3(-12.0, FY + 1.6, -21.5), 0.0, 10.0], [Vector3(-7.0, FY + 1.6, -26.5), PI / 2.0, 10.0]]:
		quad(Vector2(q[2], 3.2), q[0], q[1], _glass, zu)
		solid_box(Vector3(q[2], 3.2, 0.1) if q[1] == 0.0 else Vector3(0.1, 3.2, q[2]), q[0], zu)
	box(Vector3(4.0, 0.06, 1.6), Vector3(-12.5, FY + 0.76, -28.0), _wood_dark, false, zu)
	for k in 4:
		box(Vector3(0.45, 0.85, 0.45), Vector3(-14.0 + k * 1.0, FY + 0.42, -29.2), chair, false, zu)
	neon_text("MEETING  ·  OSPREY", Vector3(-12.0, FY + 2.9, -21.45), 0.0, 0.16, GOLD, 1.8, zu)
	_lt("up", Vector3(-11.0, FY + 3.2, -8.0), Color(0.95, 0.95, 1.0), 1.0, 12.0)
	# the people at the desks
	var coats := [Color(0.05, 0.05, 0.06), Color(0.3, 0.28, 0.26), Color(0.12, 0.16, 0.2), Color(0.5, 0.2, 0.2)]
	var skins := [Color(0.6, 0.42, 0.3), Color(0.9, 0.76, 0.64), Color(0.42, 0.3, 0.22), Color(0.82, 0.64, 0.5)]
	for i in seats.size():
		var sp: Vector3 = seats[i]
		var f := _person_fig(zu, coats[i % 4], skins[i % 4], {"arms": true, "knees": true, "visor": i % 2 == 0, "long_hair": i % 2 == 1, "hair": Color(0.08, 0.06, 0.05)}, sp + Vector3(0, -0.38, 0), PI)
		Anim.sit(f, 0.1)
		for a in f.get_meta("arms"):
			(a as Node3D).rotation.x = -1.1
		workers.append(f)
		if i == 1:
			person("worker", L("signs", "worker_prompt"), f, L("signs", "worker_scan"))


## The lounge, south-east: the ping-pong table and its rally that will
## not end, a couch along the glass, a coffee machine, bean bags.
func _lounge() -> void:
	var c := Vector3(11.5, FY, -4.6)
	var green := mat(Color(0.05, 0.28, 0.2), 0.5)
	box(Vector3(2.74, 0.05, 1.52), c + Vector3(0, 0.76, 0), green, false, zu)
	box(Vector3(2.74, 0.006, 0.03), c + Vector3(0, 0.79, 0), _white, false, zu)
	box(Vector3(0.02, 0.15, 1.7), c + Vector3(0, 0.86, 0), mat(Color(0.9, 0.9, 0.9), 0.9), false, zu)
	for sx: float in [-1.1, 1.1]:
		for sz: float in [-0.6, 0.6]:
			box(Vector3(0.06, 0.74, 0.06), c + Vector3(sx, 0.37, sz), _metal, false, zu)
	solid_box(Vector3(2.8, 0.8, 1.6), c + Vector3(0, 0.4, 0), zu)
	interactable("pingpong", L("signs", "pingpong_prompt"), c + Vector3(0, 0.9, 0), Vector3(2.8, 0.4, 1.6), L("signs", "pingpong_scan"), false, zu)
	var bn := Node3D.new()
	zu.add_child(bn)
	ball = sphere(0.025, c + Vector3(0, 1.0, 0), glow(Color(1.0, 0.9, 0.7), 1.5), 6, bn)
	for k in 2:
		var sd := -1.0 if k == 0 else 1.0
		var f := _person_fig(zu, [Color(0.05, 0.05, 0.06), Color(0.22, 0.3, 0.42)][k], [Color(0.8, 0.64, 0.52), Color(0.5, 0.36, 0.26)][k],
			{"arms": true, "knees": true, "visor": true, "hair": Color(0.1, 0.08, 0.06)}, c + Vector3(sd * 2.2, 0.02, 0), sd * PI / 2.0)
		var paddle := box(Vector3(0.16, 0.2, 0.02), Vector3(0, -0.72, -0.05), mat(Color(0.6, 0.1, 0.1), 0.6), false, f.get_meta("arms")[1])
		paddle.rotation.x = 0.4
		players.append(f)
		workers.append(f)
	# couch, beanbags, the machine
	var sofa := pbr("fabric", Vector3(1, 1, 1) / 0.8, true, Color(0.62, 0.48, 0.3))
	box(Vector3(4.0, 0.45, 0.9), Vector3(11.5, FY + 0.23, -0.8), sofa, true, zu)
	box(Vector3(4.0, 0.6, 0.25), Vector3(11.5, FY + 0.75, -0.42), sofa, false, zu)
	for bb: Vector3 in [Vector3(7.2, FY, -6.8), Vector3(8.4, FY, -7.3)]:
		var s := sphere(0.42, bb + Vector3(0, 0.3, 0), mat(Color(0.75, 0.55, 0.15), 0.8), 10, zu)
		s.scale = Vector3(1.0, 0.65, 1.0)
	box(Vector3(0.8, 1.8, 0.7), Vector3(16.8, FY + 0.9, -7.0), _metal, true, zu)
	box(Vector3(0.5, 0.25, 0.02), Vector3(16.38, FY + 1.3, -7.0), glow(GOLD, 1.5), false, zu).rotation.y = PI / 2.0
	_lt("up", Vector3(11.5, FY + 3.2, -4.5), Color(1.0, 0.92, 0.8), 1.2, 10.0)


## "Several prototype robots and drones were scattered across the floor;
## one even looked like a crane, with large synthetic wings and feathers."
## Benches, shelves, the fox, the hummingbirds, the jellyfish, Psyonic's
## stolen delivery drone opened like a fish, and the crane's stand.
func _lab() -> void:
	var bench := mat(Color(0.2, 0.2, 0.22), 0.5, 0.5)
	for b: Array in [[Vector3(16.6, FY, -12.0), PI / 2.0], [Vector3(16.6, FY, -17.5), PI / 2.0], [Vector3(7.0, FY, -10.5), 0.0]]:
		var bp: Vector3 = b[0]
		var wide: bool = b[1] == 0.0
		box(Vector3(2.6, 0.06, 0.9) if wide else Vector3(0.9, 0.06, 2.6), bp + Vector3(0, 0.9, 0), bench, true, zu)
		box(Vector3(2.4, 0.86, 0.06) if wide else Vector3(0.06, 0.86, 2.4), bp + Vector3(0, 0.45, 0), _metal, false, zu)
	prop("server_rack", Vector3(5.6, FY, -11.5), PI / 2.0, 1.0, true, zu)
	prop("steel_frame_shelves_01", Vector3(5.6, FY, -14.2), PI / 2.0, 1.0, true, zu)
	prop("plastic_crate_03", Vector3(6.0, FY + 0.95, -14.2), 0.3, 0.8, false, zu)
	prop("fuse_panel", Vector3(17.9, FY + 1.4, -21.0), -PI / 2.0, 1.0, false, zu)
	prop("modular_electric_cables", Vector3(9.0, FY + 3.5, -18.0), 0.0, 1.0, false, zu)
	prop("mounted_fluorescent_lights", Vector3(16.5, FY + 3.5, -14.5), PI / 2.0, 1.0, false, zu)
	prop("cardboard_box_01", Vector3(15.0, FY, -22.6), 0.5, 1.0, true, zu)
	# the opened Psyonic drone on the bench
	var pd := prop("delivery_drone", Vector3(7.0, FY + 0.95, -10.5), 0.6, 0.8, false, zu)
	if pd:
		pd.set_meta("drone", true)
	interactable("lab_pdrone", L("signs", "pdrone_prompt"), Vector3(7.0, FY + 1.2, -10.5), Vector3(1.6, 0.6, 0.9), L("signs", "pdrone_scan"), false, zu).set_meta("hackable", true)
	for k in 6:
		box(Vector3(0.12, 0.03, 0.12), Vector3(6.0 + k * 0.35, FY + 0.95, -10.2 + (k % 2) * 0.2), _metal, false, zu)
	# the fox, curled on a mat
	var fox := Node3D.new()
	fox.position = Vector3(14.6, FY, -9.8)
	zu.add_child(fox)
	var carbon := mat(Color(0.12, 0.12, 0.13), 0.35, 0.6)
	box(Vector3(1.0, 0.03, 0.8), Vector3(0, 0.015, 0), glow(Color(0.2, 0.6, 1.0), 0.8), false, fox)
	var fb := sphere(0.24, Vector3(0, 0.2, 0), carbon, 10, fox)
	fb.scale = Vector3(1.4, 0.75, 1.0)
	sphere(0.12, Vector3(0.28, 0.2, 0.12), carbon, 8, fox)
	stick(Vector3(0.36, 0.22, 0.16), Vector3(0.48, 0.2, 0.2), 0.04, carbon, fox)
	stick(Vector3(-0.3, 0.16, 0.0), Vector3(0.1, 0.12, 0.32), 0.07, mat(Color(0.75, 0.38, 0.14), 0.5), fox)
	interactable("lab_fox", L("signs", "fox_prompt"), Vector3(14.6, FY + 0.3, -9.8), Vector3(1.0, 0.6, 0.8), L("signs", "fox_scan"), false, zu)
	# the hummingbirds in their vitrine
	var vit := Vector3(16.6, FY + 1.3, -12.0)
	box(Vector3(0.7, 0.8, 1.6), vit, _glass, false, zu)
	stick(vit + Vector3(0, -0.1, -0.7), vit + Vector3(0, 0.1, 0.7), 0.01, _metal, zu)
	var hb := glow(Color(0.3, 1.0, 0.8), 1.4)
	for k in 14:
		box(Vector3(0.03, 0.03, 0.05), vit + Vector3(0, -0.06 + (k % 3) * 0.06, -0.65 + k * 0.1), hb, false, zu)
	interactable("lab_birds", L("signs", "birds_prompt"), vit, Vector3(0.8, 0.9, 1.7), L("signs", "birds_scan"), false, zu)
	# the jellyfish, drifting at head height
	var jelly := Node3D.new()
	jelly.position = Vector3(9.0, FY + 2.3, -18.5)
	zu.add_child(jelly)
	jelly_n = jelly
	var jm := newmat(Color(0.75, 0.85, 1.0, 0.35), 0.2)
	jm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	var dome := sphere(0.35, Vector3.ZERO, jm, 12, jelly)
	dome.scale = Vector3(1.0, 0.55, 1.0)
	for k in 6:
		var a := k * TAU / 6.0
		stick(Vector3(cos(a) * 0.2, -0.1, sin(a) * 0.2), Vector3(cos(a) * 0.25, -1.0, sin(a) * 0.25), 0.006, mat(Color(0.8, 0.85, 0.9), 0.3, 0.8), jelly)
	interactable("lab_jelly", L("signs", "jelly_prompt"), Vector3(9.0, FY + 2.0, -18.5), Vector3(0.8, 1.2, 0.8), L("signs", "jelly_scan"), false, zu)
	# the crane's stand
	cyl(0.38, 0.45, 0.85, CRANE_STAND + Vector3(0, 0.425, 0), _black, 16, zu)
	cyl(0.4, 0.4, 0.05, CRANE_STAND + Vector3(0, 0.86, 0), _gold, 16, zu)
	neon_text("P7  ·  GRUS", CRANE_STAND + Vector3(0, 0.5, 0.46), 0.0, 0.08, GOLD, 1.8, zu)
	solid_box(Vector3(0.8, 0.9, 0.8), CRANE_STAND + Vector3(0, 0.45, 0), zu)
	# the lab floor: dark epoxy, hazard tape round the stand and the test bay
	floor_quad(Vector2(12.4, 14.6), Vector3(11.6, FY + 0.012, -16.2), 0.0, mat(Color(0.06, 0.07, 0.08), 0.22, 0.3), zu)
	var tape := mat(Color(0.95, 0.75, 0.1), 0.6)
	for e: Array in [[Vector3(0, 0, -1.3), Vector3(2.6, 0.006, 0.08)], [Vector3(0, 0, 1.3), Vector3(2.6, 0.006, 0.08)], [Vector3(-1.3, 0, 0), Vector3(0.08, 0.006, 2.6)], [Vector3(1.3, 0, 0), Vector3(0.08, 0.006, 2.6)]]:
		box(e[1], CRANE_STAND + Vector3(0, 0.02, 0) + e[0], tape, false, zu)
	# the drone wall: Psyon's and the police's own machines, hung up and gutted
	for k in 3:
		prop("police_drone" if k != 1 else "delivery_drone", Vector3(17.2, FY + 2.5, -10.5 - k * 3.2), -PI / 2.0, 0.9, false, zu)
		box(Vector3(0.04, 0.8, 0.04), Vector3(17.2, FY + 3.3, -10.5 - k * 3.2), _metal, false, zu)
	# a quadruped on the floor, legs folded like a fawn's
	var dog := Node3D.new()
	dog.position = Vector3(10.2, FY, -19.6)
	dog.rotation.y = 0.7
	zu.add_child(dog)
	var shell := mat(Color(0.86, 0.84, 0.8), 0.35)
	var db := box(Vector3(0.36, 0.22, 0.8), Vector3(0, 0.38, 0), shell, false, dog)
	db.rotation.x = 0.06
	box(Vector3(0.2, 0.16, 0.24), Vector3(0, 0.52, -0.5), shell, false, dog)
	box(Vector3(0.16, 0.03, 0.02), Vector3(0, 0.53, -0.63), glow(Color(0.3, 0.8, 1.0), 1.4), false, dog)
	for lx: float in [-0.2, 0.2]:
		for lz: float in [-0.32, 0.32]:
			stick(Vector3(lx, 0.32, lz), Vector3(lx * 1.3, 0.14, lz + 0.18), 0.035, carbon, dog)
			stick(Vector3(lx * 1.3, 0.14, lz + 0.18), Vector3(lx * 1.3, 0.02, lz - 0.1), 0.03, carbon, dog)
	# wing studies pinned along the bench: feathers in carbon, in order of size
	for k in 9:
		var fz := -16.4 - k * 0.22
		var fe := box(Vector3(0.03, 0.02, 0.2 + k * 0.05), Vector3(16.35, FY + 0.95, fz), mat(Color(0.92, 0.92, 0.95), 0.4), false, zu)
		fe.rotation.y = 0.5
	# a test monitor on the bench: the crane's gait, frame by frame
	box(Vector3(0.06, 0.5, 0.8), Vector3(16.95, FY + 1.25, -17.5), _black, false, zu)
	quad(Vector2(0.72, 0.42), Vector3(16.91, FY + 1.25, -17.5), -PI / 2.0, glow(Color(0.35, 0.95, 1.0), 1.1), zu)
	var lt := _lt("up", Vector3(11.5, FY + 3.2, -16.0), Color(0.8, 0.9, 1.0), 0.85, 11.0)
	lab_lights.append(lt)
	lab_lights.append(_lt("up", Vector3(12.6, FY + 2.6, -16.6), Color(1.0, 0.86, 0.6), 0.7, 4.0))


# ------------------------------------------------------------------ Hameron's office (ch.23)

## "Dark wood, maybe rosewood, was imbued into the walls as well as a huge
## row of bookshelves filled with real books. It was like an old movie."
## The window on the north face, the tower dead centre in it. The warmest
## room in the game, on purpose.
func _office() -> void:
	var oy := FY
	floor_quad(Vector2(22, 12), Vector3(0, oy + 0.01, -30), 0.0, _wood_dark, zu)
	box(Vector3(7.0, 0.02, 4.6), Vector3(0, oy + 0.025, -30.0), pbr("carpet", Vector3(1, 1, 1) / 1.0, true, Color(0.38, 0.2, 0.12)), false, zu)
	box(Vector3(6.6, 0.025, 4.2), Vector3(0, oy + 0.03, -30.0), pbr("carpet", Vector3(1, 1, 1) / 1.0, true, Color(0.2, 0.15, 0.1)), false, zu)
	box(Vector3(22, 0.2, 12), Vector3(0, oy + 4.3, -30), _wood_dark, false, zu)
	for k in 5:
		box(Vector3(0.25, 0.25, 12), Vector3(-8.0 + k * 4.0, oy + 4.1, -30), _rosewood, false, zu)
	# the walls: rosewood both sides, the door gap in the south wall
	box(Vector3(10.0, 4.4, 0.3), Vector3(-6.1, oy + 2.2, -24.0), _rosewood, true, zu)
	box(Vector3(10.0, 4.4, 0.3), Vector3(6.1, oy + 2.2, -24.0), _rosewood, true, zu)
	box(Vector3(2.2, 1.2, 0.3), Vector3(0, oy + 3.8, -24.0), _rosewood, false, zu)
	box(Vector3(0.3, 4.4, 12.0), Vector3(-11.0, oy + 2.2, -30.0), _rosewood, true, zu)
	box(Vector3(0.3, 4.4, 12.0), Vector3(11.0, oy + 2.2, -30.0), _rosewood, true, zu)
	box(Vector3(2.6, 0.12, 0.4), Vector3(0, oy + 3.25, -23.85), _gold, false, zu)
	# the double door
	for sd: float in [-1.0, 1.0]:
		var pv := Node3D.new()
		pv.position = Vector3(sd * 1.1, oy, -24.0)
		zu.add_child(pv)
		box(Vector3(1.1, 3.1, 0.1), Vector3(-sd * 0.55, 1.55, 0), _rosewood, false, pv)
		box(Vector3(0.9, 1.2, 0.04), Vector3(-sd * 0.55, 2.1, 0.06), _wood_dark, false, pv)
		box(Vector3(0.9, 1.0, 0.04), Vector3(-sd * 0.55, 0.8, 0.06), _wood_dark, false, pv)
		sphere(0.04, Vector3(-sd * 0.95, 1.1, 0.1), _gold, 6, pv)
		office_doors.append(pv)
	office_block = solid_box(Vector3(2.2, 3.2, 0.3), Vector3(0, oy + 1.6, -24.0), zu)
	interactable("office_door", L("signs", "office_door_prompt"), Vector3(0, oy + 1.5, -23.6), Vector3(2.2, 3.0, 0.4), "", false, zu)
	# the window and the tower in it
	quad(Vector2(21.4, 4.2), Vector3(0, oy + 2.1, -35.9), 0.0, _glass, zu)
	solid_box(Vector3(22, 4.4, 0.2), Vector3(0, oy + 2.2, -35.95), zu)
	for mx: float in [-7.2, -3.6, 3.6, 7.2]:
		box(Vector3(0.1, 4.2, 0.12), Vector3(mx, oy + 2.1, -35.85), _wood_dark, false, zu)
	box(Vector3(21.6, 0.35, 0.5), Vector3(0, oy + 0.18, -35.65), _rosewood, false, zu)
	interactable("office_window", L("signs", "window_prompt"), Vector3(0, oy + 2.0, -35.6), Vector3(14.0, 3.6, 0.3), "", false, zu)
	# the bookshelves, floor to ceiling, east and west
	var frame := _wood_dark
	var books := _books_mat()
	for sx: float in [-1.0, 1.0]:
		var wx := sx * 10.55
		box(Vector3(0.5, 4.0, 10.6), Vector3(wx, oy + 2.0, -30.0), frame, false, zu)
		for s in 7:
			var sy := oy + 0.35 + s * 0.55
			box(Vector3(0.52, 0.04, 10.6), Vector3(wx - sx * 0.02, sy, -30.0), _rosewood, false, zu)
			if s < 6:
				var q := quad(Vector2(10.4, 0.46), Vector3(wx - sx * 0.28, sy + 0.25, -30.0), -sx * PI / 2.0, books, zu)
				q.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		for k in 4:
			box(Vector3(0.52, 4.0, 0.08), Vector3(wx - sx * 0.02, oy + 2.0, -25.0 - k * 3.3), _rosewood, false, zu)
	interactable("books", L("signs", "books_prompt"), Vector3(-10.2, oy + 1.6, -27.5), Vector3(0.6, 3.0, 4.0), "", false, zu)
	interactable("books_e", L("signs", "books_prompt"), Vector3(10.2, oy + 1.6, -32.5), Vector3(0.6, 3.0, 4.0), "", false, zu)
	# the photograph of the chair, on the east shelf where the family goes
	var ph := Vector3(10.2, oy + 1.64, -29.0)
	box(Vector3(0.05, 0.34, 0.44), ph, mat(Color(0.75, 0.75, 0.78), 0.3, 1.0), false, zu)
	var pm := StandardMaterial3D.new()
	pm.albedo_texture = _chair_photo()
	pm.roughness = 0.4
	quad(Vector2(0.36, 0.27), ph + Vector3(-0.03, 0, 0), -PI / 2.0, pm, zu)
	interactable("photo", L("signs", "photo_prompt"), ph, Vector3(0.3, 0.4, 0.5), "", false, zu)
	# the planchette under its bell, on the west shelf
	var pl := Vector3(-10.2, oy + 1.47, -31.0)
	var heart := box(Vector3(0.14, 0.02, 0.16), pl + Vector3(0, 0.02, 0), _wood_dark, false, zu)
	heart.rotation.y = 0.3
	var bell := sphere(0.13, pl + Vector3(0, 0.08, 0), _glass, 12, zu)
	bell.scale = Vector3(1, 1.2, 1)
	interactable("planchette", L("signs", "planchette_prompt"), pl + Vector3(0, 0.1, 0), Vector3(0.3, 0.3, 0.3), "", false, zu)
	# diplomas by the door
	for k in 2:
		box(Vector3(0.6, 0.45, 0.04), Vector3(-3.2 - k * 0.9, oy + 2.0, -24.18), _gold, false, zu)
		quad(Vector2(0.52, 0.37), Vector3(-3.2 - k * 0.9, oy + 2.0, -24.21), PI, mat(Color(0.88, 0.84, 0.74), 0.9), zu)
	# the desk: rosewood, a green leather top, pedestals, the old monitors
	var dz := -31.6
	box(Vector3(3.4, 0.08, 1.5), Vector3(0, oy + 0.78, dz), _rosewood, true, zu)
	box(Vector3(2.6, 0.01, 0.9), Vector3(0, oy + 0.825, dz + 0.1), mat(Color(0.1, 0.25, 0.16), 0.6), false, zu)
	for sx: float in [-1.15, 1.15]:
		box(Vector3(0.95, 0.74, 1.4), Vector3(sx, oy + 0.37, dz), _wood_dark, false, zu)
	box(Vector3(1.4, 0.6, 0.04), Vector3(0, oy + 0.45, dz + 0.68), _wood_dark, false, zu)
	var crt := mat(Color(0.5, 0.48, 0.42), 0.7)
	var text := glow(Color(0.45, 1.0, 0.55), 1.3)
	for sx: float in [-1.25, 1.25]:
		box(Vector3(0.62, 0.52, 0.58), Vector3(sx, oy + 1.12, dz - 0.2), crt, false, zu)
		box(Vector3(0.4, 0.3, 0.3), Vector3(sx, oy + 1.12, dz - 0.6), crt, false, zu)
		quad(Vector2(0.5, 0.38), Vector3(sx, oy + 1.14, dz + 0.095), 0.0, mat(Color(0.03, 0.06, 0.04), 0.2), zu)
		for ln in 5:
			box(Vector3(rng.randf_range(0.15, 0.4), 0.018, 0.005), Vector3(sx - 0.05, oy + 1.27 - ln * 0.05, dz + 0.1), text, false, zu)
	interactable("monitors", L("signs", "monitors_prompt"), Vector3(1.25, oy + 1.12, dz - 0.1), Vector3(0.7, 0.6, 0.7), L("signs", "monitors_scan"), false, zu)
	interactable("monitors_w", L("signs", "monitors_prompt"), Vector3(-1.25, oy + 1.12, dz - 0.1), Vector3(0.7, 0.6, 0.7), L("signs", "monitors_scan"), false, zu)
	# the banker's lamp, a pen, paper, a glass of water
	cyl(0.08, 0.1, 0.03, Vector3(0.55, oy + 0.84, dz - 0.3), _gold, 10, zu)
	stick(Vector3(0.55, oy + 0.84, dz - 0.3), Vector3(0.55, oy + 1.15, dz - 0.3), 0.012, _gold, zu)
	var shade := cyl(0.1, 0.16, 0.1, Vector3(0.55, oy + 1.18, dz - 0.22), glow(Color(0.15, 0.6, 0.3), 1.3), 12, zu)
	shade.rotation.x = 0.3
	box(Vector3(0.21, 0.004, 0.3), Vector3(-0.3, oy + 0.832, dz + 0.15), mat(Color(0.9, 0.88, 0.82), 0.9), false, zu)
	stick(Vector3(-0.1, oy + 0.835, dz + 0.1), Vector3(0.05, oy + 0.835, dz + 0.25), 0.006, _gold, zu)
	cyl(0.035, 0.03, 0.11, Vector3(-0.7, oy + 0.88, dz + 0.2), _glass, 8, zu)
	# his chair: the back rises six inches above his head
	var leather := mat(Color(0.05, 0.035, 0.03), 0.85)
	box(Vector3(0.7, 0.12, 0.65), Vector3(0, oy + 0.48, HAM_AT.z), leather, false, zu)
	box(Vector3(0.78, 1.25, 0.16), Vector3(0, oy + 1.1, HAM_AT.z - 0.38), leather, false, zu)
	box(Vector3(0.82, 0.06, 0.2), Vector3(0, oy + 1.74, HAM_AT.z - 0.38), _gold, false, zu)
	solid_box(Vector3(0.8, 1.8, 0.8), Vector3(0, oy + 0.9, HAM_AT.z - 0.1), zu)
	# Carl's armchair: oxblood leather
	var ox := mat(Color(0.32, 0.08, 0.06), 0.45)
	box(Vector3(0.9, 0.42, 0.85), ARMCHAIR + Vector3(0, 0.21, 0), ox, false, zu)
	box(Vector3(0.9, 0.7, 0.2), ARMCHAIR + Vector3(0, 0.75, 0.4), ox, false, zu)
	for sx: float in [-0.48, 0.48]:
		box(Vector3(0.16, 0.62, 0.85), ARMCHAIR + Vector3(sx, 0.31, 0), ox, false, zu)
	interactable("armchair", L("signs", "armchair_prompt"), ARMCHAIR + Vector3(0, 0.5, 0), Vector3(1.0, 1.0, 1.0), "", false, zu)
	# a drinks cabinet, a stopped clock, a globe (an old movie)
	box(Vector3(1.4, 1.1, 0.5), Vector3(7.5, oy + 0.55, -24.45), _rosewood, false, zu)
	for k in 3:
		cyl(0.05, 0.06, 0.3, Vector3(7.1 + k * 0.4, oy + 1.25, -24.45), mat([Color(0.4, 0.2, 0.05), Color(0.6, 0.45, 0.2), Color(0.2, 0.25, 0.12)][k], 0.1, 0.2), 8, zu)
	cyl(0.28, 0.28, 0.06, Vector3(-7.0, oy + 2.6, -24.18), _gold, 16, zu).rotation.x = PI / 2.0
	sphere(0.3, Vector3(8.6, oy + 1.25, -34.6), mat(Color(0.5, 0.45, 0.3), 0.6), 12, zu)
	cyl(0.04, 0.12, 0.9, Vector3(8.6, oy + 0.45, -34.6), _wood_dark, 8, zu)
	# the light: lamp-warm, wood-warm
	_lt("up", Vector3(0.55, oy + 1.3, dz - 0.1), Color(1.0, 0.76, 0.48), 0.9, 5.0)
	_lt("up", Vector3(-8.5, oy + 3.0, -28.0), Color(1.0, 0.78, 0.52), 1.0, 9.0)
	_lt("up", Vector3(8.5, oy + 3.0, -32.0), Color(1.0, 0.78, 0.52), 1.0, 9.0)
	_lt("up", Vector3(0, oy + 3.8, -27.0), Color(1.0, 0.82, 0.6), 0.7, 10.0)
	for sx: float in [-10.7, 10.7]:
		box(Vector3(0.08, 0.3, 0.2), Vector3(sx, oy + 3.0, -26.0), _gold, false, zu)
		sphere(0.09, Vector3(sx * 0.98, oy + 3.2, -26.0), glow(Color(1.0, 0.7, 0.4), 2.2), 8, zu)


## Book spines for the shelves: varied widths and heights, leather
## colours, gold bands. One texture, repeated.
func _books_mat() -> StandardMaterial3D:
	var w := 512
	var h := 64
	var img := Image.create(w, h, false, Image.FORMAT_RGB8)
	img.fill(Color(0.04, 0.025, 0.02))
	var r := RandomNumberGenerator.new()
	r.seed = 2324
	var cols := [Color(0.35, 0.07, 0.06), Color(0.08, 0.12, 0.25), Color(0.1, 0.22, 0.12), Color(0.5, 0.36, 0.2),
		Color(0.06, 0.05, 0.05), Color(0.7, 0.64, 0.52), Color(0.42, 0.2, 0.1), Color(0.22, 0.1, 0.2)]
	var x := 0
	while x < w:
		var bw := r.randi_range(6, 16)
		var top := r.randi_range(0, 18)
		var c: Color = cols[r.randi() % cols.size()] * r.randf_range(0.75, 1.15)
		for yy in range(top, h):
			for xx in range(x, mini(w, x + bw - 1)):
				var shade := 0.82 + 0.18 * sin(float(xx - x) / bw * PI)
				img.set_pixel(xx, yy, c * shade)
		if r.randf() < 0.7:
			for band: int in [top + 6, h - 10]:
				for xx in range(x + 1, mini(w, x + bw - 2)):
					img.set_pixel(xx, clampi(band, 0, h - 1), Color(0.75, 0.58, 0.25))
		x += bw
	var m := StandardMaterial3D.new()
	m.albedo_texture = ImageTexture.create_from_image(img)
	m.uv1_scale = Vector3(5.0, 1.0, 1.0)
	m.roughness = 0.75
	m.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	return m


## The photograph: the hangar's chair under one hard light, two cables
## with rust-red tips. Black and white, gone slightly sepia.
func _chair_photo() -> ImageTexture:
	var w := 96
	var h := 72
	var img := Image.create(w, h, false, Image.FORMAT_RGB8)
	var r := RandomNumberGenerator.new()
	r.seed = 1414
	for y in h:
		for x in w:
			var dx := (x - 48.0) / 40.0
			var cone := clampf(1.0 - absf(dx) * (1.2 - y / 120.0), 0.0, 1.0) * clampf(y / 30.0, 0.2, 1.0)
			var v := 0.05 + cone * 0.42 + r.randf() * 0.04
			img.set_pixel(x, y, Color(v * 1.08, v, v * 0.86))
	# the recliner: back, seat, footrest, arms
	for y in range(30, 56):
		for x in range(38, 50):
			img.set_pixel(x, y, Color(0.03, 0.025, 0.02))
	for y in range(46, 56):
		for x in range(44, 66):
			img.set_pixel(x, y, Color(0.035, 0.03, 0.025))
	for y in range(52, 58):
		for x in range(62, 74):
			img.set_pixel(x, y, Color(0.03, 0.025, 0.02))
	for x in range(40, 64):
		img.set_pixel(x, 45, Color(0.25, 0.22, 0.18))
	# the cables down from the dark, rust-red tips
	for k in 2:
		var cx := 50 + k * 6
		for y in range(0, 36):
			img.set_pixel(cx + int(sin(y * 0.2) * 1.0), y, Color(0.02, 0.02, 0.02))
		for y in range(36, 40):
			img.set_pixel(cx, y, Color(0.55, 0.12, 0.06))
	img.resize(w * 2, h * 2, Image.INTERPOLATE_NEAREST)
	return ImageTexture.create_from_image(img)


# ------------------------------------------------------------------ the trailer (ch.24-25)

## "A small trailer on the outskirts of town. Conveniently located near
## one of the abandoned Tunelet tunnels." Old Town's last street gone to
## sand, the trailer with its awning and a string of bulbs, the drills
## rusting in the depot yard, the black mouth in the mountain, the city
## and the tower far off to the north-west. No cameras.
func _trailer_zone() -> void:
	var o := TR
	solid_box(Vector3(300, 2, 300), o + Vector3(0, -1.0, 0), zt)
	floor_quad(Vector2(320, 320), o + Vector3(0, 0.0, 0), 0.0, _sand, zt)
	box(Vector3(7.0, 0.06, 120.0), o + Vector3(-12.0, 0.02, -10.0), pbr("asphalt", Vector3(1, 1, 1) / 5.0, true, Color(0.42, 0.4, 0.38)), false, zt)
	# the trailer: aluminium, ribbed, rusting at the seams
	var t := o + Vector3(0, 0, -2.0)
	var alu := mat(Color(0.44, 0.44, 0.43), 0.62, 0.45)
	box(Vector3(8.4, 2.5, 2.6), t + Vector3(0, 1.75, 0), alu, true, zt)
	for k in 9:
		box(Vector3(8.42, 0.05, 2.62), t + Vector3(0, 0.8 + k * 0.27, 0), mat(Color(0.5, 0.5, 0.48), 0.6, 0.5), false, zt)
	box(Vector3(8.44, 0.4, 2.64), t + Vector3(0, 0.62, 0), _rust, false, zt)
	var cap := cyl(1.3, 1.3, 2.5, t + Vector3(4.2, 1.75, 0), alu, 16, zt)
	cap.rotation.x = PI / 2.0
	cap.scale = Vector3(0.6, 1.0, 1.0)
	var cap2 := cyl(1.3, 1.3, 2.5, t + Vector3(-4.2, 1.75, 0), alu, 16, zt)
	cap2.rotation.x = PI / 2.0
	cap2.scale = Vector3(0.6, 1.0, 1.0)
	for wx: float in [-2.6, 2.4]:
		quad(Vector2(1.2, 0.8), t + Vector3(wx, 2.1, 1.31), 0.0, glow(Color(1.0, 0.72, 0.4), 1.4), zt)
		box(Vector3(1.3, 0.08, 0.06), t + Vector3(wx, 2.55, 1.33), _metal, false, zt)
	box(Vector3(0.9, 1.9, 0.05), t + Vector3(0.0, 1.45, 1.32), mat(Color(0.5, 0.48, 0.45), 0.6, 0.4), false, zt)
	for k in 2:
		box(Vector3(0.9, 0.2, 0.4), t + Vector3(0, 0.1 + k * 0.2, 1.6 + (1 - k) * 0.4), pbr("concrete", Vector3(1, 1, 1) / 1.0, true, Color(0.5, 0.48, 0.45)), true, zt)
	cyl(0.25, 0.25, 0.5, t + Vector3(-4.0, 0.25, 1.0), _rust, 10, zt)
	cyl(0.25, 0.25, 0.5, t + Vector3(3.0, 0.25, 1.0), _rust, 10, zt)
	interactable("trailer", L("signs", "trailer_prompt"), t + Vector3(-2.6, 1.8, 1.4), Vector3(2.4, 1.6, 0.3), L("signs", "trailer_scan"), false, zt)
	# the awning and its bulbs
	box(Vector3(5.0, 0.06, 2.4), t + Vector3(1.0, 2.75, 2.5), mat(Color(0.55, 0.2, 0.15), 0.8), false, zt)
	for sx: float in [-1.4, 3.4]:
		stick(t + Vector3(sx, 0, 3.6), t + Vector3(sx, 2.72, 3.6), 0.03, _metal, zt)
	var bulb := glow(Color(1.0, 0.8, 0.45), 2.6)
	for k in 9:
		var bx := -1.4 + k * 0.6
		sphere(0.05, t + Vector3(bx, 2.62 - sin(k / 8.0 * PI) * 0.18, 3.7), bulb, 6, zt)
	_lt("trailer", t + Vector3(1.0, 2.4, 3.2), Color(1.0, 0.75, 0.42), 0.9, 8.0)
	_lt("trailer", t + Vector3(-2.6, 2.0, 2.4), Color(1.0, 0.7, 0.4), 0.5, 5.0)
	# lawn chairs, a grill, a water barrel, old tyres, crates
	for k in 2:
		var cp := t + Vector3(2.6 + k * 1.1, 0, 4.6)
		box(Vector3(0.55, 0.05, 0.5), cp + Vector3(0, 0.4, 0), mat(Color(0.2, 0.45, 0.4), 0.8), false, zt)
		box(Vector3(0.55, 0.6, 0.05), cp + Vector3(0, 0.7, 0.28), mat(Color(0.2, 0.45, 0.4), 0.8), false, zt).rotation.x = -0.25
	prop("Barrel_01", t + Vector3(-5.6, 0, 1.6), 0.0, 1.0, true, zt)
	prop("old_tyre", t + Vector3(-6.4, 0, 3.0), 0.4, 1.0, false, zt)
	prop("old_tyre", t + Vector3(-6.2, 0.25, 3.1), 1.2, 1.0, false, zt)
	prop("plastic_crate_03", t + Vector3(4.8, 0, 2.4), 0.2, 1.0, true, zt)
	cyl(0.3, 0.25, 0.7, t + Vector3(4.6, 0.35, 4.2), _rust, 10, zt)
	# inside, through the door: the hub with its lens taped, the photos,
	# Emmet's laptop on the fold-down table
	box(Vector3(0.3, 0.2, 0.2), t + Vector3(1.0, 2.2, 1.37), mat(Color(0.85, 0.85, 0.85), 0.4), false, zt)
	box(Vector3(0.1, 0.06, 0.02), t + Vector3(1.0, 2.22, 1.48), mat(Color(0.1, 0.1, 0.1), 0.9), false, zt)
	interactable("hub", L("signs", "hub_prompt"), t + Vector3(1.0, 2.2, 1.45), Vector3(0.4, 0.3, 0.3), L("signs", "hub_scan"), false, zt).set_meta("hackable", true)
	for k in 3:
		quad(Vector2(0.22, 0.16), t + Vector3(-1.2 + k * 0.3, 2.5 - (k % 2) * 0.2, 1.34), 0.0, mat(Color(0.7, 0.62, 0.48), 0.9), zt)
	interactable("photos", "The photographs", t + Vector3(-0.9, 2.4, 1.4), Vector3(1.0, 0.5, 0.2), "", false, zt)
	box(Vector3(1.0, 0.05, 0.6), t + Vector3(2.4, 1.0, 1.6), mat(Color(0.5, 0.4, 0.3), 0.8), false, zt)
	box(Vector3(0.36, 0.02, 0.26), t + Vector3(2.4, 1.04, 1.6), _black, false, zt)
	var lid := quad(Vector2(0.36, 0.24), t + Vector3(2.4, 1.16, 1.48), 0.0, glow(Color(0.5, 0.95, 0.6), 1.0), zt)
	lid.rotation.x = -0.25
	interactable("laptop", L("signs", "laptop_prompt"), t + Vector3(2.4, 1.1, 1.6), Vector3(0.5, 0.3, 0.4), "", false, zt)
	# the mailbox and the dead streetlamp of Nongro Lane
	stick(o + Vector3(-8.0, 0, 3.0), o + Vector3(-8.0, 1.1, 3.0), 0.04, _metal, zt)
	box(Vector3(0.3, 0.3, 0.5), o + Vector3(-8.0, 1.25, 3.0), _rust, false, zt)
	neon_text("230", o + Vector3(-7.84, 1.25, 3.0), PI / 2.0, 0.12, Color(0.8, 0.8, 0.75), 0.6, zt)
	prop("street_lamp_01", o + Vector3(-15.5, 0, -4.0), PI / 2.0, 1.0, true, zt)
	# the depot yard: chain-link, broken drills, the black mouth in the mountain
	var fence := mat(Color(0.35, 0.36, 0.38), 0.6, 0.7)
	for k in 14:
		stick(o + Vector3(20.0, 0, -20.0 + k * 3.0), o + Vector3(20.0, 2.2, -20.0 + k * 3.0), 0.04, fence, zt)
	var mesh_m := newmat(Color(0.4, 0.42, 0.44, 0.35), 0.6, 0.6)
	mesh_m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh_m.cull_mode = BaseMaterial3D.CULL_DISABLED
	quad(Vector2(39.0, 2.1), o + Vector3(20.0, 1.1, -0.5), PI / 2.0, mesh_m, zt)
	for d: Array in [[Vector3(34, 0, -8), 0.3], [Vector3(44, 0, 6), -0.5], [Vector3(52, 0, -18), 1.2]]:
		var dp: Vector3 = d[0]
		var drill := cyl(1.8, 1.8, 7.0, o + dp + Vector3(0, 1.8, 0), _rust, 14, zt)
		drill.rotation = Vector3(PI / 2.0, d[1], 0)
		var head := cyl(2.1, 2.3, 0.8, o + dp + Vector3(sin(d[1]) * 3.8, 1.8, cos(d[1]) * 3.8), mat(Color(0.3, 0.22, 0.16), 0.7, 0.6), 14, zt)
		head.rotation = Vector3(PI / 2.0, d[1], 0)
	interactable("drills", L("signs", "drills_prompt"), o + Vector3(34, 1.8, -8), Vector3(4.0, 3.6, 7.0), "", false, zt)
	var rock := pbr("concrete", Vector3(1, 1, 1) / 6.0, true, Color(0.42, 0.33, 0.27))
	for k in 5:
		var mp := o + Vector3(110.0 + k * 10.0, 0, -60.0 + k * 34.0)
		var mt := sphere(38.0 + k * 4.0, mp, rock, 14, zt)
		mt.scale = Vector3(1.0, 0.75, 1.0)
	var mouth := cyl(14.0, 14.0, 2.0, o + Vector3(82.0, 9.0, -6.0), mat(Color(0.0, 0.0, 0.0), 1.0), 24, zt)
	mouth.rotation.z = PI / 2.0
	box(Vector3(2.0, 9.0, 28.0), o + Vector3(81.0, 4.5, -6.0), mat(Color(0.0, 0.0, 0.0), 1.0), false, zt)
	neon_text("TUNELET  ·  RAIL CUT", o + Vector3(70.0, 7.5, 9.0), -PI / 2.0, 1.2, Color(0.9, 0.5, 0.2), 1.6, zt)
	interactable("depot", L("signs", "tunnel_prompt"), o + Vector3(20.5, 1.2, 4.0), Vector3(0.4, 2.2, 6.0), L("signs", "tunnel_scan"), false, zt)
	_lt("trailer", o + Vector3(30.0, 6.0, -2.0), Color(1.0, 0.45, 0.2), 1.0, 30.0)
	# the city's edge to the north-west, the tower beyond it
	for k in 12:
		var cx := -60.0 - k * 26.0
		var cz := -120.0 - (k % 4) * 30.0
		cyber_block(o + Vector3(cx, 0, cz), PI / 4.0, 20.0, rng.randf_range(16.0, 70.0), 20.0, false, 1)
	# the second car, parked on the lane
	trailer_car = Node3D.new()
	trailer_car.position = o + TRAILER_CAR
	zt.add_child(trailer_car)
	trailer_car.add_child(Car.build(self, Color(0.42, 0.06, 0.08), {"plate": "SLA 2241"}))
	solid_box(Vector3(2.0, 1.6, 4.8), o + TRAILER_CAR + Vector3(0, 0.8, 0), zt)
	interactable("car_home", L("signs", "car_home_prompt"), Vector3(0, 1.0, 0), Vector3(2.0, 1.6, 4.6), L("signs", "car_scan"), false, trailer_car)
	var bag := box(Vector3(0.5, 0.32, 0.3), t + Vector3(0.6, 0.55, 1.75), mat(Color(0.04, 0.04, 0.04), 0.7), false, zt)
	bag.name = "bag_mesh"
	no_batch.append(bag)
	interactable("bag", L("signs", "bag_prompt"), t + Vector3(0.6, 0.55, 1.75), Vector3(0.6, 0.4, 0.4), "", false, zt)


# ------------------------------------------------------------------ the Psyonic Tower

## Dead centre in Hameron's window, and over every roof: the jade nail,
## its lit seams, the donut on its stick, the red lights round the ring.
func _tower() -> void:
	var root := Node3D.new()
	root.position = TOWER
	add_child(root)
	var jade := mat(Color(0.16, 0.42, 0.34), 0.28, 0.75)
	var silver := mat(Color(0.6, 0.63, 0.66), 0.25, 0.85)
	cyl(50.0, 56.0, 36.0, Vector3(0, 18.0, 0), jade, 32, root)
	for pair in 4:
		for k: float in [-1.0, 1.0]:
			var ang: float = pair * PI / 2.0 + PI / 4.0 + k * 0.24
			var cm := CapsuleMesh.new()
			cm.radius = 12.0
			cm.height = 64.0
			var arm := mesh(cm, Vector3(sin(ang) * 50.0, 24.0, cos(ang) * 50.0), silver if k > 0.0 else jade, root)
			arm.rotation = Vector3(0, ang, 0)
			arm.rotate_object_local(Vector3.FORWARD, 1.15)
	cyl(16.0, 30.0, 440.0, Vector3(0, 256.0, 0), jade, 24, root)
	var seam := newglow(PSYON_GREEN, 3.0)
	seam.disable_fog = true
	for s in 10:
		var ang := s * TAU / 10.0
		for seg in 10:
			var y := 46.0 + seg * 42.0
			var rad := lerpf(30.0, 16.0, (y - 36.0) / 440.0) + 0.3
			var b := box(Vector3(1.4, 32.0, 1.4), Vector3(sin(ang) * rad, y, cos(ang) * rad), seam, false, root)
			b.rotation.y = ang
	var tm := TorusMesh.new()
	tm.inner_radius = 58.0
	tm.outer_radius = 108.0
	tm.rings = 40
	tm.ring_segments = 12
	mesh(tm, Vector3(0, 540.0, 0), silver, root)
	var tm2 := TorusMesh.new()
	tm2.inner_radius = 105.0
	tm2.outer_radius = 110.0
	tm2.rings = 40
	tm2.ring_segments = 6
	var ring_m := newglow(PSYON_GREEN, 3.0)
	ring_m.disable_fog = true
	mesh(tm2, Vector3(0, 540.0, 0), ring_m, root)
	var red := newglow(Color(1, 0.05, 0.05), 5.0)
	red.disable_fog = true
	for k in 6:
		var a := k * TAU / 6.0
		blinkers.append(box(Vector3(4, 4, 4), Vector3(cos(a) * 108.0, 540.0, sin(a) * 108.0), red, false, root))


# ------------------------------------------------------------------ Eren's rooftop (layer 20)

## The rooftop courtyard at Psyonic HQ, for the broadcast camera only:
## paving, a parapet, cacti, a lectern, the tower's shaft behind like a
## monolith, a digital sun in the clouds. Eren in a pale suit and the
## sunglasses that are a little too big; Mira, hidden behind him.
func _rooftop_set() -> void:
	var o := BS
	floor_quad(Vector2(60, 60), o, 0.0, pbr("paving", Vector3(1, 1, 1) / 2.0, true, Color(0.7, 0.68, 0.64)), zset)
	box(Vector3(40, 1.1, 0.5), o + Vector3(0, 0.55, -8.0), mat(Color(0.75, 0.75, 0.72), 0.6), false, zset)
	var jade := mat(Color(0.16, 0.42, 0.34), 0.28, 0.75)
	cyl(18.0, 24.0, 400.0, o + Vector3(4.0, 190.0, -70.0), jade, 24, zset)
	var seam := newglow(PSYON_GREEN, 3.0)
	for s in 8:
		var ang := s * TAU / 8.0
		box(Vector3(1.0, 400.0, 1.0), o + Vector3(4.0 + sin(ang) * 21.5, 190.0, -70.0 + cos(ang) * 21.5), seam, false, zset).rotation.y = ang
	var sun_m := StandardMaterial3D.new()
	sun_m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	sun_m.albedo_color = Color(1.0, 0.92, 0.75)
	sun_m.disable_fog = true
	sphere(7.0, o + Vector3(-9.0, 15.0, -60.0), sun_m, 16, zset)
	var cloud := newmat(Color(0.75, 0.62, 0.6, 0.55), 1.0)
	cloud.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	cloud.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	cloud.disable_fog = true
	for k in 5:
		quad(Vector2(rng.randf_range(20, 36), rng.randf_range(3, 6)), o + Vector3(-20.0 + k * 9.0, 11.0 + k * 2.2, -52.0), 0.0, cloud, zset)
	for k in 4:
		var cp := o + Vector3(-5.0 + k * 3.4, 0, -6.6)
		cyl(0.35, 0.3, 0.6, cp + Vector3(0, 0.3, 0), mat(Color(0.6, 0.35, 0.25), 0.8), 10, zset)
		cyl(0.18, 0.2, 1.4, cp + Vector3(0, 1.3, 0), mat(Color(0.2, 0.42, 0.25), 0.7), 8, zset)
	# the lectern with the Psyonic mark
	box(Vector3(0.7, 1.15, 0.45), o + Vector3(0, 0.58, 0.9), mat(Color(0.5, 0.5, 0.49), 0.6), false, zset)
	var mk := TorusMesh.new()
	mk.inner_radius = 0.12
	mk.outer_radius = 0.17
	mk.rings = 20
	mk.ring_segments = 6
	var mark := mesh(mk, o + Vector3(0, 0.75, 1.13), glow(PSYON_GREEN, 3.0), zset)
	mark.rotation.x = PI / 2.0
	eren = _person_fig(zset, Color(0.68, 0.67, 0.64), Color(0.84, 0.7, 0.6), {"arms": true, "knees": true, "hair": Color(0.6, 0.6, 0.6), "legs": Color(0.66, 0.65, 0.62), "long_coat": false}, o, PI)
	var eh: Node3D = eren.get_meta("head")
	var void_m := mat(Color(0.0, 0.0, 0.0), 0.05, 0.4)
	for sx: float in [-1.0, 1.0]:
		var ev := sphere(0.017, Vector3(sx * 0.042, 0.022, -0.1), void_m, 10, eh)
		ev.scale = Vector3(1.15, 0.78, 0.55)
	eren_glasses = Node3D.new()
	eh.add_child(eren_glasses)
	box(Vector3(0.23, 0.058, 0.02), Vector3(0, 0.024, -0.118), mat(Color(0.01, 0.01, 0.015), 0.05, 0.6), false, eren_glasses)
	box(Vector3(0.24, 0.012, 0.012), Vector3(0, 0.054, -0.118), mat(Color(0.3, 0.3, 0.3), 0.3, 0.9), false, eren_glasses)
	mira = _person_fig(zset, Color(0.82, 0.6, 0.75), Color(0.86, 0.68, 0.56), {"arms": true, "knees": true, "hair": Color(0.06, 0.05, 0.05), "long_hair": true, "scale": 0.72, "long_coat": false}, o + Vector3(0.1, 0, -0.9), PI)
	var mh: Node3D = mira.get_meta("head")
	box(Vector3(0.075, 0.02, 0.012), Vector3(0, -0.062, -0.1), mat(Color(0.25, 0.04, 0.04), 0.6), false, mh)
	box(Vector3(0.062, 0.009, 0.012), Vector3(0, -0.062, -0.104), mat(Color(0.95, 0.94, 0.9), 0.4), false, mh)
	var key := light(o + Vector3(1.8, 2.8, 3.0), Color(1.0, 0.85, 0.65), 1.3, 10.0, false)
	key.light_cull_mask = LAYER_PSYON
	_zl["set"].append(key)
	var rim := light(o + Vector3(-1.0, 2.4, -2.5), Color(1.0, 0.75, 0.5), 1.2, 6.0, false)
	rim.light_cull_mask = LAYER_PSYON
	_zl["set"].append(rim)


# ------------------------------------------------------------------ people

func _lynx_fig(parent: Node3D) -> Node3D:
	return _person_fig(parent, Color(0.1, 0.1, 0.12), Color(0.88, 0.76, 0.68),
		{"hair": Color(0.3, 0.2, 0.14), "long_hair": true, "legs": Color(0.1, 0.1, 0.12), "visor": true, "arms": true, "knees": true, "scale": 0.94, "long_coat": true}, Vector3.ZERO, 0.0)


func _people() -> void:
	lynx = _lynx_fig(self)
	lynx.position = spawn + Vector3(-1.2, 0, 0.8)
	person("lynx", L("signs", "lynx_prompt"), lynx, L("signs", "lynx_scan"))
	# the intern outside, at the kiosk; the same boy on 25
	var lanyard := mat(Color(0.82, 0.6, 0.26), 0.3, 1.0)
	intern_plaza = _person_fig(zs, Color(0.18, 0.2, 0.26), Color(0.78, 0.6, 0.48), {"arms": true, "knees": true, "hair": Color(0.2, 0.13, 0.08), "legs": Color(0.25, 0.22, 0.2), "long_coat": false, "scale": 0.97}, Vector3(-7.5, 0.12, 2.4), 0.0)
	box(Vector3(0.05, 0.16, 0.01), Vector3(0, 1.32, -0.14), lanyard, false, intern_plaza)
	person("intern_plaza", L("signs", "intern_prompt"), intern_plaza, L("signs", "intern_scan"))
	turn_to(intern_plaza, Vector3(-7.5, 0, 1.2))
	intern = _person_fig(zu, Color(0.18, 0.2, 0.26), Color(0.78, 0.6, 0.48), {"arms": true, "knees": true, "hair": Color(0.2, 0.13, 0.08), "legs": Color(0.25, 0.22, 0.2), "long_coat": false, "scale": 0.97}, Vector3(1.6, FY, -10.4), PI)
	box(Vector3(0.05, 0.16, 0.01), Vector3(0, 1.32, -0.14), lanyard, false, intern)
	person("intern", L("signs", "intern_prompt"), intern, L("signs", "intern_scan_up"))
	intern.set_meta("route", "person")
	# the guards: kind at the desk; the night man by the freight lift
	var uni := Color(0.04, 0.04, 0.05)
	guard = _person_fig(zs, uni, Color(0.6, 0.44, 0.32), {"arms": true, "knees": true, "hair": Color(0.05, 0.05, 0.05), "legs": uni, "long_coat": false, "scale": 1.03}, Vector3(0, 0.06, -8.2), 0.0)
	box(Vector3(0.08, 0.05, 0.01), Vector3(-0.1, 1.42, -0.14), _gold, false, guard)
	person("guard", L("signs", "guard_prompt"), guard, L("signs", "guard_scan"))
	guard.set_meta("guard", true)
	guard2 = _person_fig(zs, uni, Color(0.85, 0.7, 0.6), {"arms": true, "knees": true, "hair": Color(0.3, 0.25, 0.2), "legs": uni, "long_coat": false, "visor": true}, Vector3(12.0, 0.06, -33.0), 0.3)
	box(Vector3(0.08, 0.05, 0.01), Vector3(-0.1, 1.42, -0.14), _gold, false, guard2)
	person("guard2", L("signs", "guard2_prompt"), guard2, L("signs", "guard2_scan"))
	guard2.set_meta("guard", true)
	guard2.visible = false
	var dg := _person_fig(zs, uni, Color(0.45, 0.32, 0.24), {"arms": true, "knees": true, "hair": Color(0.05, 0.05, 0.05), "legs": uni, "long_coat": false}, Vector3(24.6, 0.06, -18.0), PI * 0.8)
	(dg.get_meta("arms")[0] as Node3D).rotation.x = -1.6
	box(Vector3(0.012, 0.012, 0.08), Vector3(0, -0.66, -0.04), glow(Color(1.0, 0.5, 0.2), 3.0), false, dg.get_meta("arms")[0])
	person("dock_guard", L("signs", "dock_guard_prompt"), dg, L("signs", "dock_guard_scan"))
	dg.set_meta("guard", true)
	# the woman kneeling to the Cogni screen
	var pw := _person_fig(zs, Color(0.06, 0.06, 0.07), Color(0.62, 0.46, 0.34), {"arms": true, "knees": true, "long_hair": true, "hair": Color(0.05, 0.04, 0.04)}, Vector3(-15.6, -0.42, -10.5), -PI / 2.0)
	Anim.crouch(pw)
	(pw.get_meta("head") as Node3D).rotation.x = 0.35
	person("prayer", L("signs", "prayer_prompt"), pw, L("signs", "prayer_scan"))
	# Hameron, in the tall chair
	hameron = _person_fig(zu, Color(0.03, 0.03, 0.035), Color(0.9, 0.84, 0.8), {"arms": true, "knees": true, "hair": Color(0.78, 0.78, 0.8), "legs": Color(0.03, 0.03, 0.035), "long_coat": false, "scale": 0.97}, HAM_AT + Vector3(0, -0.38, 0), PI)
	Anim.sit(hameron, 0.05)
	box(Vector3(0.045, 0.3, 0.012), Vector3(0, 1.3, -0.135), _gold, false, hameron)
	var hh: Node3D = hameron.get_meta("head")
	for sx: float in [-1.0, 1.0]:
		box(Vector3(0.078, 0.056, 0.008), Vector3(sx * 0.042, 0.024, -0.113), _gold, false, hh)
		box(Vector3(0.064, 0.042, 0.009), Vector3(sx * 0.042, 0.024, -0.115), mat(Color(0.5, 0.55, 0.5), 0.05, 0.3), false, hh)
	box(Vector3(0.05, 0.008, 0.01), Vector3(0, -0.044, -0.108), mat(Color(0.8, 0.8, 0.82), 0.8), false, hh)
	person("hameron", L("signs", "hameron_prompt"), hameron, L("signs", "hameron_scan"))
	# Turan by the rental; Emmet at the trailer with his phone
	turan = _person_fig(zs, Color(0.16, 0.16, 0.19), Color(0.8, 0.66, 0.56), {"hair": Color(0.2, 0.2, 0.22), "legs": Color(0.14, 0.14, 0.16), "arms": true, "knees": true, "long_coat": false}, CAR_AT + Vector3(-1.0, 0.12, -1.6), PI * 0.5)
	person("turan", L("signs", "turan_prompt"), turan, L("signs", "turan_scan"))
	emmet = _person_fig(zt, Color(0.28, 0.38, 0.5), Color(0.9, 0.74, 0.64), {"hair": Color(0.8, 0.3, 0.1), "legs": Color(0.2, 0.2, 0.24), "arms": true, "knees": true, "scale": 1.06, "long_coat": false}, TR + EMMET_AT, PI * 0.9)
	var ea: Node3D = emmet.get_meta("arms")[1]
	ea.rotation.x = -1.2
	box(Vector3(0.08, 0.15, 0.012), Vector3(0, -0.66, -0.06), glow(Color(0.8, 0.9, 1.0), 2.0), false, ea)
	person("emmet", L("signs", "emmet_prompt"), emmet, L("signs", "emmet_scan"))


# ------------------------------------------------------------------ the crane (Grus)

## Prototype 7: white polymer feathers black at the tips, a red silicone
## crown, gold-ringed lenses. Folded on its stand until five o'clock; from
## then on it follows Carl (combat.md: Drones, Own). Wings are pivots so
## they fold and beat; it walks indoors and flies under the sky.
func _crane() -> void:
	crane = Node3D.new()
	crane.position = CRANE_STAND + Vector3(0, 0.88, 0)
	crane.rotation.y = atan2(CRANE_STAND.x, CRANE_STAND.z + 24.0)  # facing the office door
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
	crane.set_meta("head", head)
	crane.set_meta("drone", true)
	_crane_fold(1.0)
	crane_it = interactable("crane", L("signs", "crane_prompt"), Vector3(0, 0.8, 0), Vector3(0.9, 1.6, 1.2), L("signs", "crane_scan"), false, crane)


## Wings folded (1) or spread (0) along the body.
func _crane_fold(k: float) -> void:
	var wings: Array = crane.get_meta("wings")
	for i in wings.size():
		var sx := -1.0 if i == 0 else 1.0
		var w := wings[i] as Node3D
		w.rotation = Vector3(0, -sx * 1.35 * k, sx * 0.25 * k)
		w.scale = Vector3.ONE * (1.0 - 0.35 * k)


# ------------------------------------------------------------------ getting about

## Fade, move Carl (and whoever is with him) to another part of the
## level, and turn that part's lights on.
func _go(zone: String, pos: Vector3, yaw: float) -> void:
	var ui = main.ui
	var p = main.player
	var was: bool = main.flags.has("cinematic")
	main.flags["cinematic"] = true
	await ui.fade_to(1.0, 0.5)
	_zone = zone
	_apply_zone()
	p.global_position = pos
	p.velocity = Vector3.ZERO
	p.yaw = yaw
	p.pitch = 0.0
	p.rotation.y = yaw
	if lynx_state != "hidden":
		lynx_state = "follow"
		lynx.position = pos + Basis(Vector3.UP, yaw) * Vector3(-1.1, 0, 0.9)
	if crane_state == "walk" or crane_state == "fly":
		crane.position = pos + Basis(Vector3.UP, yaw) * Vector3(1.0, 0, 1.3)
	await ui.fade_to(0.0, 0.6)
	if not was:
		main.flags.erase("cinematic")


func _hide_person(fig: Node3D, id: String) -> void:
	fig.visible = false
	var n := _node_by_id(id)
	if n:
		set_active(n as CollisionObject3D, false)


# ------------------------------------------------------------------ arrival (ch.23)

func intro() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("cz_arrived"):
		return
	f["cz_arrived"] = true
	f["cinematic"] = true
	await ui.think(L("intro", "think"))
	await ui.think(L("intro", "think_2"))
	await ui.say("Carl", L("intro", "carl"))
	await ui.say("Lynx", L("intro", "lynx"))
	await ui.think(L("intro", "think_3"))
	ui.close()
	f.erase("cinematic")
	main.update_hud()


## The intern at the coffee kiosk: be kind to him or not. Kindness is the
## Person route later (bible: "the intern, if Carl was kind").
func _kiosk() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if not f.has("cz_kiosk"):
		f["cz_kiosk"] = true
		turn_to(intern_plaza, main.player.global_position, 0.4)
		await ui.think(L("kiosk", "think"))
		await ui.say("Intern", L("kiosk", "intern"))
		if main.frames_on:
			main.play("glitch", -10.0)
			ui.glitch(0.4, 0.4)
			await ui.think(L("kiosk", "eye"))
		var i: int = await ui.choose(LA("kiosk", "choice"))
		match i:
			0:
				main.play("ding", -10.0)
				await ui.say("Intern", L("kiosk", "pay"))
			1:
				main.play("tap", -6.0, 0.6)
				await ui.think(L("kiosk", "hit_think"))
				await ui.say("Intern", L("kiosk", "hit"))
			_:
				await ui.think(L("kiosk", "walk"))
		if i < 2:
			f["cz_intern_kind"] = true
			main.log_line("person", L("kiosk", "kind_log"))
		else:
			ui.close()
			await _move(intern_plaza, [Vector3(-3.0, 0.12, 1.5), Vector3(0, 0.12, -2.0)], 0.7)
			_hide_person(intern_plaza, "intern_plaza")
		return
	if f.has("cz_intern_kind") and not f.has("cz_route") and intern_plaza.visible:
		await ui.think(L("kiosk", "again"))
		var j: int = await ui.choose(LA("kiosk", "again_choice"))
		if j == 0:
			await _take_route("person")
		else:
			await ui.say("Intern", L("kiosk", "enjoy"))
		return
	await ui.think(L("kiosk", "again"))


# ------------------------------------------------------------------ the way in: the cover and the other three

## The interview cover is the Badge route: two PIPed Psyonic employees
## at the desk. The guard's line is the book's.
func _desk() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("cz_desk") or f.has("cz_route"):
		await ui.say("Guard", L("desk", "again"))
		return
	f["cinematic"] = true
	await ui.think(L("desk", "think"))
	await ui.think(L("desk", "think_2"))
	turn_to(guard, main.player.global_position, 0.4)
	await ui.say("Guard", L("desk", "guard"))
	await ui.say("Carl", L("desk", "carl"))
	await ui.say("Guard", L("desk", "guard_2"))
	main.play("tap", -10.0, 1.4)
	await ui.think(L("desk", "thumb"))
	main.play("ding", -12.0)
	await ui.say("Guard", L("desk", "guard_3"))
	await ui.say("Guard", L("desk", "guard_4"))
	await ui.think(L("desk", "think_3"))
	ui.close()
	f["cz_desk"] = true
	f["cz_route"] = "cover"
	main.log_line("route", L("routes", "cover_log"))
	if intern_plaza.visible:
		_hide_person(intern_plaza, "intern_plaza")
	f.erase("cinematic")


func _lift() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if _zone != "street":
		return
	if f.has("cz_hameron_done") or f.has("cz_on_25"):
		await ui.think(L("routes", "not_now"))
		return
	if not f.has("cz_desk"):
		await ui.think(L("desk", "lift_first"))
		return
	main.play("ding", -8.0)
	f["cinematic"] = true
	await ui.think(L("lift", "think"))
	await ui.say("Lynx", L("lift", "lynx"))
	await ui.think(L("lift", "think_2"))
	await ui.say("Carl", L("lift", "carl"))
	await ui.think(L("lift", "think_3"))
	ui.close()
	await _go("up", L_25, PI)
	main.play("ding", -8.0, 1.2)
	await _meet_intern()
	f.erase("cinematic")


## The staff door (Hack): look away for the camera, we for the reader.
func _route_staff() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	await ui.think(L("routes", "staff_think"))
	if f.has("cz_route"):
		await ui.think(L("routes", "not_now"))
		return
	if not ("look away" in main.lexicon and "we" in main.lexicon):
		await ui.think(L("routes", "staff_nowords"))
		return
	var i: int = await ui.choose(LA("routes", "staff_choice"))
	if i == 0:
		await _take_route("hack")
	else:
		await ui.think(L("routes", "not_now"))


## The loading dock (Sneak): it costs an hour.
func _route_dock() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	await ui.think(L("routes", "dock_think"))
	if f.has("cz_route"):
		await ui.think(L("routes", "not_now"))
		return
	var i: int = await ui.choose(LA("routes", "dock_choice"))
	if i == 0:
		await _take_route("sneak")
	else:
		await ui.think(L("routes", "not_now"))


## The staff door by quick-hack (Hack.gd): look away on its camera (the
## generic blind), then we on the door is the Hack route. With the camera
## still looking, the door opens anyway and the company sees it.
func on_hack(node: Object, word: String) -> bool:
	var f: Dictionary = main.flags
	if str(node.get_meta("id", "")) != "staff_door" or word != "we" or f.has("cz_route") or _zone != "street":
		return false
	var cam := _node_by_id("staff_camera")
	if cam and not main.hack.has_state(cam, "blind"):
		await main.ui.think(L("routes", "hack_seen"))
		main.ui.close()
		main.add_pressure(3.0, L("routes", "hack_seen_why"))
	await _take_route("hack")
	return true


## A way in other than the cover: its effects, then the freight lift to
## 25 (the mechanics of each come with the stealth pass).
func _take_route(kind: String) -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	f["cz_route"] = kind
	f["cinematic"] = true
	match kind:
		"hack":
			main.play("glitch", -6.0)
			ui.glitch(0.6, 0.8)
			await ui.think(L("routes", "hack_think"))
			main.add_connection(3.0, "look away, we")
			main.log_line("route", L("routes", "hack_log"))
		"sneak":
			await ui.think(L("routes", "sneak_think"))
			ui.show_toast(L("routes", "sneak_toast"), 3.5)
			main.log_line("time", L("routes", "sneak_log"))
		_:
			await ui.say("Intern", L("routes", "person_kind"))
			await ui.think(L("routes", "person_think"))
			main.log_line("route", L("routes", "person_log"))
	ui.close()
	if intern_plaza.visible:
		_hide_person(intern_plaza, "intern_plaza")
	await _go("up", L_25 + Vector3(2.5, 0, 0), PI)
	main.play("ding", -8.0, 0.8)
	await _meet_intern()
	f.erase("cinematic")


# ------------------------------------------------------------------ floor 25: the intern's tour

func _meet_intern() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	f["cz_on_25"] = true
	if f.has("cz_intern_met"):
		return
	f["cz_intern_met"] = true
	turn_to(intern, main.player.global_position, 0.3)
	var person_route := str(f.get("cz_route", "")) == "person"
	if not person_route:
		await ui.think(L("floor", "think"))
		await ui.say("Intern", L("floor", "intern"))
		await ui.say("Carl", L("floor", "carl"))
		await ui.say("Lynx", L("floor", "lynx"))
		if f.has("cz_intern_kind"):
			await ui.say("Intern", L("floor", "intern_kind"))
	await ui.say("Intern", L("floor", "intern_2"))
	await ui.say("Intern", L("floor", "intern_3"))
	await ui.think(L("floor", "think_2"))
	await ui.say("Intern", L("floor", "follow"))
	ui.close()
	_tour = 0
	_move(intern, [Vector3(2.0, FY, -8.0), Vector3(5.5, FY, -5.2), STOP_LOUNGE], 0.6)
	_tour_wait = true
	main.update_hud()


## One stop of the tour: run when the intern has got there and Carl has
## caught up (tick). The lounge, the lab with the crane, the door.
func _tour_stop() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	_tour_wait = false
	_busy = true
	turn_to(intern, main.player.global_position, 0.3)
	match _tour:
		0:
			await ui.think(L("floor", "lounge"))
			await ui.think(L("floor", "lounge_2"))
			ui.caption(L("floor", "laugh"), 3.0)
			await ui.think(L("floor", "laugh_2"))
			f["cz_lounge"] = true
		1:
			await ui.think(L("floor", "lab"))
			await ui.say("Intern", L("floor", "intern_lab"))
			await ui.think(L("floor", "think_lab"))
			await ui.think(L("floor", "think_lab_2"))
			f["cz_lab"] = true
		_:
			await _door_scene()
	ui.close()
	_busy = false
	_tour += 1
	if _tour == 1:
		_move(intern, [Vector3(8.0, FY, -8.5), STOP_LAB], 0.6)
		_tour_wait = true
	elif _tour == 2:
		_move(intern, [Vector3(8.0, FY, -21.6), STOP_DOOR], 0.6)
		_tour_wait = true
	main.update_hud()


func _office_doors(open: bool, t := 0.8) -> void:
	var tw := create_tween().set_parallel(true)
	for i in office_doors.size():
		var sd := -1.0 if i == 0 else 1.0
		tw.tween_property(office_doors[i], "rotation:y", (sd * 1.5) if open else 0.0, t)
	if is_instance_valid(office_block):
		office_block.collision_layer = 0 if open else 1
	main.play("door", -12.0, 1.1)


## "So, who wants to go first?" The intern goes in to announce them.
func _door_scene() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	await ui.think(L("door", "think"))
	await ui.say("Intern", L("door", "intern"))
	await ui.say("Carl", L("door", "carl"))
	await ui.say("Intern", L("door", "intern_2"))
	ui.close()
	_office_doors(true)
	await _move(intern, [Vector3(0, FY, -23.0), Vector3(0, FY, -25.8)], 0.6)
	_office_doors(false)
	intern.visible = false
	await ui.think(L("door", "think_2"))
	await ui.say("Carl", L("door", "carl_2"))
	await ui.think(L("door", "think_3"))
	ui.close()
	await get_tree().create_timer(1.0).timeout
	_office_doors(true)
	intern.visible = true
	intern.position = Vector3(0, FY, -24.8)
	turn_to(intern, main.player.global_position)
	await ui.say("Intern", L("door", "intern_3"))
	ui.close()
	await _move(intern, [Vector3(0, FY, -22.6), Vector3(3.0, FY, -21.6)], 0.6)
	turn_to(intern, Vector3(0, FY, -24.0))
	await ui.say("Lynx", L("door", "lynx"))
	f["cz_door_called"] = true
	var od := _node_by_id("office_door")
	if od:
		od.set_meta("prompt", L("signs", "office_door_open"))


# ------------------------------------------------------------------ Hameron (ch.23)

func _office_door() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("cz_hameron_done"):
		await ui.think(L("examine", "hameron_after"))
		return
	if not f.has("cz_door_called"):
		await ui.think(L("door", "wait"))
		return
	await _office_scene()


## Rosewood, real books, the tower in the window, the warmest room in the
## game. He sends Lynx out; six lines, each a transcript entry; the drive.
func _office_scene() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	_busy = true
	f["cinematic"] = true
	f["cz_office"] = true
	_office_doors(true)
	lynx_state = "stand"
	lynx_target = Vector3(1.4, FY, -26.0)
	await ui.think(L("office", "think"))
	await ui.fade_to(1.0, 0.5)
	p.global_position = Vector3(0, FY + 0.05, -25.6)
	p.yaw = 0.0
	p.pitch = 0.08
	p.rotation.y = 0.0
	lynx.position = Vector3(1.4, FY, -25.4)
	intern.visible = false
	await ui.fade_to(0.0, 0.6)
	await ui.think(L("office", "think_2"))
	await ui.think(L("office", "think_warm"))
	await ui.think(L("office", "think_3"))
	await ui.think(L("office", "think_ham"))
	await ui.think(L("office", "think_ham_2"))
	await ui.say("Hameron", L("office", "ham"))
	await ui.say("Carl", L("office", "carl"))
	ui.close()
	# into the armchair
	await ui.fade_to(1.0, 0.4)
	p.global_position = ARMCHAIR + Vector3(0, 0.05, 0.05)
	p.seated = true
	p.crouch = 0.5
	p.yaw = 0.0
	p.pitch = 0.1
	await ui.fade_to(0.0, 0.5)
	await ui.think(L("office", "think_seat"))
	await ui.say("Hameron", L("office", "ham_lynx"))
	await ui.say("Lynx", L("office", "lynx_out"))
	ui.close()
	lynx_state = "stand"
	await _move(lynx, [Vector3(0.6, FY, -24.6), Vector3(1.6, FY, -22.4)], 0.8)
	lynx_target = Vector3(1.6, FY, -22.4)
	_office_doors(false)
	await ui.think(L("office", "think_lynx"))
	await ui.say("Hameron", L("office", "ham_2"))
	await ui.say("Hameron", L("office", "ham_3"))
	await ui.say("Carl", L("office", "carl_2"))
	await _ham_line(1)
	await ui.think(L("office", "think_physics"))
	await _ham_line(2)
	main.play("door", -10.0, 1.5)
	main.player.shake(0.15)
	await ui.think(L("office", "knob"))
	await ui.say("Hameron", L("office", "ham_knob"))
	await ui.think(L("office", "think_wink"))
	await _ham_line(3)
	await _ham_line(4)
	await ui.think(L("office", "think_cries"))
	await _ham_line(5)
	await ui.say("Hameron", L("office", "ham_mimic"))
	main.learn("hypnogogue")
	await _ham_line(6)
	await ui.think(L("office", "think_wants"))
	main.play("whisper", -6.0, 0.7)
	ui.glitch(0.3, 0.5)
	await ui.say("", L("office", "whisper"))
	main.add_connection(2.0, L("office", "whisper_why"))
	# the drive
	await ui.say("Hameron", L("drive", "ham"))
	await ui.say("Hameron", L("drive", "ham_2"))
	main.play("tap", -12.0, 0.5)
	await ui.think(L("drive", "think"))
	f["ev_drive"] = true
	main.log_line("evidence", L("drive", "log"))
	ui.show_toast(L("drive", "toast"), 3.0)
	await ui.think(L("drive", "think_2"))
	await ui.say("Hameron", L("drive", "ham_3"))
	await ui.say("Hameron", L("drive", "ham_4"))
	await ui.say("Carl", L("drive", "carl"))
	await ui.say("Hameron", L("drive", "ham_5"))
	var i: int = await ui.choose(LA("ask", "choice"))
	await _ask(i)
	await _burst()
	_busy = false
	f.erase("cinematic")
	main.update_hud()


func _ham_line(n: int) -> void:
	var f: Dictionary = main.flags
	var text := L("ham", str(n))
	await main.ui.say("Hameron", text)
	if not f.has("ev_hameron_%d" % n):
		f["ev_hameron_%d" % n] = true
		main.log_line("evidence", L("ham", "log") % n + text)
		main.ui.show_toast(L("ham", "toast") % n, 2.5)


## Why he left / what the drive does / nothing.
func _ask(i: int) -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	match i:
		0:
			f["cz_hameron_ask"] = "guilt"
			await ui.say("Hameron", L("ask", "guilt"))
			await ui.think(L("ask", "guilt_think"))
		1:
			f["cz_hameron_ask"] = "drive"
			await ui.say("Hameron", L("ask", "drive"))
			await ui.think(L("ask", "drive_think"))
			main.log_line("claim", L("ask", "drive_log"))
		_:
			f["cz_hameron_ask"] = "nothing"
			await ui.think(L("ask", "nothing"))
			await ui.say("Hameron", L("ask", "nothing_ham"))


## Lynx bursts in: "He got the position." Then five o'clock.
func _burst() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	_office_doors(true, 0.3)
	main.play("slam", -12.0, 1.3)
	lynx_state = "stand"
	lynx.position = Vector3(0.8, FY, -24.6)
	lynx_target = Vector3(1.0, FY, -26.6)
	await ui.think(L("burst", "think"))
	await ui.think(L("burst", "think_2"))
	await ui.say("Lynx", L("burst", "lynx"))
	await ui.say("Hameron", L("burst", "ham"))
	await ui.think(L("burst", "think_3"))
	ui.close()
	f["cz_hameron_done"] = true
	p.seated = false
	p.crouch = 0.0
	p.global_position = ARMCHAIR + Vector3(0.9, 0.05, 1.0)
	p.velocity = Vector3.ZERO
	lynx_state = "follow"
	_after_hours()


## Five o'clock: the floor empties, the cameras wake, the night guard
## comes on. Tier 3 from here (the hooks are for the stealth pass).
func _after_hours() -> void:
	main.flags["cz_after_hours"] = true
	for w in workers:
		(w as Node3D).visible = false
	var wk := _node_by_id("worker")
	if wk:
		set_active(wk as CollisionObject3D, false)
	if ball:
		ball.visible = false
	for c in cams:
		(c["tally"] as Node3D).visible = true
	guard2.visible = true
	guard.position = Vector3(-1.2, 0.06, -8.2)
	if lab_lights.size() > 0:
		(lab_lights[0] as OmniLight3D).light_energy = 0.55
	intern.visible = true
	intern.position = Vector3(7.4, FY, -9.4)
	turn_to(intern, CRANE_STAND)


## The crane steps down off its stand and follows Carl (combat.md: Own).
func _crane_wakes() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	_busy = true
	f["cinematic"] = true
	await ui.think(L("exit", "think"))
	crane_state = "walk"
	crane.position = CRANE_STAND + Vector3(-0.6, 0, -0.9)
	crane.set_meta("ally", true)
	crane_it.set_meta("scan", L("signs", "crane_scan_ally"))
	f["drone_ally"] = true
	main.log_line("ally", L("exit", "ally_log"))
	main.play("tap", -12.0, 0.5)
	await main.player.face(crane.global_position + Vector3(0, 1.0, 0), 0.8)
	await ui.think(L("exit", "crane"))
	turn_to(intern, main.player.global_position, 0.3)
	await ui.say("Intern", L("exit", "intern"))
	await ui.say("Lynx", L("exit", "lynx"))
	await ui.say("Carl", L("exit", "carl"))
	await ui.think(L("exit", "think_2"))
	ui.close()
	f.erase("cinematic")
	_busy = false


func _lift_down() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if _zone != "up":
		return
	if not f.has("cz_hameron_done"):
		await ui.think(L("exit", "lift_locked"))
		return
	main.play("ding", -8.0)
	await _go("street", L_GROUND, PI)
	main.play("ding", -8.0, 0.8)
	await ui.think(L("exit", "lobby"))
	turn_to(guard2, main.player.global_position, 0.3)
	await ui.say("Guard", L("exit", "guard2"))
	ui.close()


# ------------------------------------------------------------------ outside, after five (ch.24)

func _outside() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	f["cz_outside"] = true
	_busy = true
	crane_state = "fly"
	await ui.say("Lynx", L("outside", "lynx"))
	await ui.say("Carl", L("outside", "carl"))
	await ui.think(L("outside", "think"))
	await ui.say("Lynx", L("outside", "lynx_2"))
	ui.close()
	_busy = false
	main.update_hud()


## At the rental: Turan's questions, "Let me see the drive", the drive.
func _at_car() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("cz_trailer"):
		await ui.think(L("routes", "not_now"))
		return
	if not f.has("cz_outside"):
		await ui.think(L("outside", "turan_wait"))
		return
	if not f.has("cz_drive_choice"):
		_busy = true
		f["cinematic"] = true
		turn_to(turan, main.player.global_position, 0.3)
		await ui.think(L("outside", "think_car"))
		await ui.say("Turan", L("outside", "turan"))
		await ui.say("Carl", L("outside", "carl_2"))
		await ui.say("Carl", L("outside", "carl_3"))
		await ui.say("Carl", L("outside", "carl_4"))
		await ui.think(L("outside", "think_smile"))
		await ui.say("Turan", L("outside", "turan_2"))
		await ui.say("Carl", L("outside", "carl_5"))
		await ui.say("Lynx", L("outside", "lynx_3"))
		await ui.think(L("outside", "think_off"))
		var i: int = await ui.choose(LA("outside", "choice"))
		await _lynx_choice(i)
		await ui.say("Turan", L("outside", "turan_go"))
		crane_state = "roof"
		await ui.think(L("outside", "crane_think"))
		ui.close()
	await _drive_away()


## "Let me see the drive": hand it over / refuse / tell her what Hameron said.
func _lynx_choice(i: int) -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var before := int(main.trust.get("lynx", 0))
	f["cz_drive_choice"] = ["give", "refuse", "warn"][clampi(i, 0, 2)]
	match i:
		0:
			await ui.think(L("outside", "give_think"))
			await ui.say("Lynx", L("outside", "give_lynx"))
			main.add_trust("lynx", 1)
			if before <= -1:
				await ui.say("Lynx", L("outside", "give_keep"))
				await ui.think(L("outside", "give_keep_think"))
				f["lynx_has_drive"] = true
				main.log_line("item", L("outside", "keep_log"))
			else:
				await ui.say("Lynx", L("outside", "give_back"))
		1:
			await ui.say("Carl", L("outside", "refuse"))
			await ui.say("Lynx", L("outside", "refuse_lynx"))
			await ui.think(L("outside", "refuse_think"))
			await ui.say("Carl", L("outside", "refuse_carl"))
			await ui.say("Turan", L("outside", "refuse_turan"))
			await ui.say("Carl", L("outside", "refuse_carl_2"))
			await ui.say("Lynx", L("outside", "refuse_lynx_2"))
			main.add_trust("lynx", -1)
		_:
			await ui.say("Carl", L("outside", "warn"))
			await ui.say("Lynx", L("outside", "warn_lynx"))
			await ui.say("Lynx", L("outside", "warn_lynx_2"))
			main.add_trust("lynx", -2)
			f["warned_lynx"] = true
			main.log_line("choice", L("outside", "warn_log"))


## The drive east to Old Town; the fork's offer, the crane alongside.
func _drive_away() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	_busy = true
	f["cinematic"] = true
	await ui.fade_to(1.0, 0.8)
	main.play("engine", -14.0)
	ui.caption(L("cards", "drive").replace("[b]", "").replace("[/b]", "").replace("[color=#aaaaaa]", "").replace("[/color]", "").replace("\n\n", "  ·  "), 3.0)
	await ui.think(L("car", "think"))
	await _fork_offer(-1)
	ui.close()
	await _to_trailer()


func _fork_offer(pick: int) -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	main.play("whisper", -6.0, 0.6)
	ui.glitch(0.6, 0.8)
	await ui.say("Psyon", L("car", "fork"))
	var j: int = pick
	if j < 0:
		j = await ui.choose(LA("car", "choice"))
	if j == 0:
		f["drone_owned"] = true
		main.add_connection(3.0, L("car", "yes_why"))
		await ui.think(L("car", "yes"))
		main.log_line("ally", L("car", "owned_log"))
	else:
		main.add_connection(1.0, L("car", "no_why"))
		await ui.think(L("car", "no"))
		main.log_line("ally", L("car", "refused_log"))


# ------------------------------------------------------------------ the trailer (ch.24)

func _to_trailer() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	_zone = "trailer"
	_apply_zone()
	_dusk_env()
	p.global_position = TR + Vector3(-5.6, 0.1, 8.0)
	p.velocity = Vector3.ZERO
	var d: Vector3 = (TR + Vector3(0, 0, -2.0)) - p.global_position
	p.yaw = atan2(-d.x, -d.z)
	p.pitch = 0.0
	p.rotation.y = p.yaw
	lynx_state = "follow"
	lynx.position = p.global_position + Vector3(-1.2, -0.1, 0.6)
	turan.reparent(zt)
	turan.global_position = TR + Vector3(-7.4, 0, 6.4)
	turn_to(turan, TR)
	crane_state = "fly"
	crane.position = p.global_position + Vector3(1.0, 2.4, 1.0)
	f["cz_trailer"] = true
	main.log_line("save", L("trailer", "save_log"))
	await ui.show_card(L("cards", "trailer"), 2.4)
	await ui.think(L("trailer", "think"))
	await ui.think(L("trailer", "think_2"))
	await ui.think(L("trailer", "think_emmet"))
	turn_to(emmet, p.global_position, 0.4)
	await ui.say("Emmet", L("trailer", "emmet"))
	ui.close()
	f.erase("cinematic")
	_busy = false
	main.update_hud()


func _emmet() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if not f.has("broadcast_seen"):
		await _broadcast()
		return
	if not f.has("ev_knife") and int(main.trust.get("emmet", 0)) >= 0:
		await _bag()
		return
	await ui.think(L("broadcast", "think_9"))


## Eren's broadcast on Emmet's phone: four frames in the sun-halo look,
## a crowd under him, silence when the glasses come off. Mira.
func _broadcast() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	_busy = true
	f["cinematic"] = true
	turn_to(emmet, main.player.global_position, 0.3)
	await ui.think(L("broadcast", "think"))
	var crowd: AudioStreamPlayer = main.loop("murmur", -14.0)
	crowd.play()
	var tex0: ImageTexture = await _bframe(0)
	ui.show_picture(tex0, L("broadcast", "cap_1"))
	await ui.think(L("broadcast", "think_2"))
	await ui.say("Eren", L("broadcast", "eren_1"))
	await ui.think(L("broadcast", "think_3"))
	await ui.say("Eren", L("broadcast", "eren_2"))
	await ui.say("Turan", L("broadcast", "turan"))
	await ui.think(L("broadcast", "think_4"))
	crowd.stop()
	var tex1: ImageTexture = await _bframe(1)
	ui.show_picture(tex1, L("broadcast", "cap_2"))
	await ui.think(L("broadcast", "think_5"))
	await ui.say("Eren", L("broadcast", "eren_3"))
	await ui.think(L("broadcast", "think_6"))
	crowd.volume_db = -20.0
	crowd.play()
	var tex2: ImageTexture = await _bframe(2)
	ui.show_picture(tex2, L("broadcast", "cap_3"))
	await ui.say("Eren", L("broadcast", "eren_4"))
	await ui.think(L("broadcast", "think_7"))
	await ui.say("Mira", L("broadcast", "mira"))
	await ui.say("Emmet", L("broadcast", "emmet"))
	await ui.think(L("broadcast", "think_8"))
	var tex3: ImageTexture = await _bframe(3)
	ui.show_picture(tex3, L("broadcast", "cap_4"))
	await ui.say("Eren", L("broadcast", "eren_5"))
	crowd.stop()
	main.play("static", -12.0)
	await ui.think(L("broadcast", "think_9"))
	ui.hide_picture()
	ui.close()
	f["broadcast_seen"] = true
	main.log_line("evidence", L("broadcast", "log"))
	f.erase("cinematic")
	_busy = false
	main.update_hud()


## Emmet's bag: the flashlight and the Bowie knife (E:knife). At low trust
## he leaves it on the step with a note (bible-1, Emmet). Then Rail Cut.
func _bag() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if not f.has("broadcast_seen"):
		await ui.think(L("bag", "later"))
		return
	if f.has("ev_knife"):
		await ui.think(L("bag", "again"))
		return
	_busy = true
	if int(main.trust.get("emmet", 0)) >= 0:
		turn_to(emmet, main.player.global_position, 0.3)
		await ui.say("Emmet", L("bag", "emmet"))
		await ui.think(L("bag", "think"))
		await ui.say("Emmet", L("bag", "emmet_2"))
		await ui.say("Carl", L("bag", "carl"))
		await ui.think(L("bag", "think_2"))
	else:
		await ui.think(L("bag", "note_think"))
		await ui.think(L("bag", "note"))
	f["ev_flashlight"] = true
	f["ev_knife"] = true
	main.log_line("evidence", L("bag", "knife_log"))
	ui.show_toast("Evidence: the knife", 3.0)
	var bm := zt.get_node_or_null("bag_mesh")
	if bm:
		(bm as Node3D).visible = false
	turn_to(turan, main.player.global_position, 0.3)
	await ui.say("Turan", L("bag", "turan"))
	await ui.say("Turan", L("bag", "turan_2"))
	f["cz_tunnels_22"] = true
	main.log_line("time", L("bag", "tunnel_log"))
	await ui.think(L("bag", "think_3"))
	ui.close()
	f["cognizo_done"] = true
	_busy = false
	main.update_hud()


func _end() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if not f.has("ev_knife"):
		await ui.think(L("trailer", "tunnel_2"))
		return
	if _ended:
		return
	_ended = true
	await ui.show_card(L("cards", "end"), 2.6)
	if not main._selftest:
		main.load_level("Home")


# ------------------------------------------------------------------ the broadcast frames

## One frame of Eren's broadcast: pose the rooftop, render it from the
## phone's camera, and grade it in the sun-halo look.
func _bframe(n: int) -> ImageTexture:
	var o := BS
	eren_glasses.visible = n == 0
	mira.visible = n >= 2
	for a in eren.get_meta("arms"):
		var an := a as Node3D
		var sx := 1.0 if an.position.x > 0.0 else -1.0
		an.rotation.z = sx * (1.2 if n == 0 or n == 3 else 0.2)
		an.rotation.x = -0.35 if n == 1 else 0.0
	mira.position = o + (Vector3(0.5, 0, -0.7) if n == 2 else Vector3(0.8, 0, -0.3))
	var head: Vector3 = (eren.get_meta("head") as Node3D).global_position
	var from := o + Vector3(0.8, 1.45, 6.5)
	var at := o + Vector3(0.2, 3.4, -4.0)
	var fov := 58.0
	match n:
		1:
			from = o + Vector3(0.1, 1.72, 0.8)
			at = head
			fov = 32.0
		2:
			from = o + Vector3(0.9, 1.75, 2.7)
			at = o + Vector3(0.25, 1.45, -0.4)
			fov = 40.0
		3:
			from = o + Vector3(0.0, 1.8, 8.5)
			at = o + Vector3(0, 2.4, -3.0)
			fov = 52.0
	for l in _zl["set"]:
		(l as OmniLight3D).visible = true
	var res: Array = await _render(from, at, fov, head + Vector3(0, 0.15, 0))
	for l in _zl["set"]:
		(l as OmniLight3D).visible = false
	return _broadcast_look(res[0], res[1], n)


func _render(from: Vector3, at: Vector3, fov: float, mark: Vector3) -> Array:
	var vp := SubViewport.new()
	vp.size = Vector2i(480, 300)
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(vp)
	var cam := Camera3D.new()
	cam.fov = fov
	cam.near = 0.05
	cam.far = 900.0
	vp.add_child(cam)
	cam.global_transform = Transform3D(Basis.looking_at(at - from, Vector3.UP), from)
	cam.current = true
	for i in 4:
		await RenderingServer.frame_post_draw
	var img := vp.get_texture().get_image()
	var sp := cam.unproject_position(mark) / Vector2(480, 300)
	vp.queue_free()
	return [img, sp]


## The phone's picture: warm highlights, a halo and rays round Eren (the
## digital sun), scanlines, the LIVE badge, a lower third; the colour
## drains when the glasses come off; the last frame dies to black.
func _broadcast_look(src: Image, mark: Vector2, n: int) -> ImageTexture:
	var img := src.duplicate() as Image
	img.convert(Image.FORMAT_RGB8)
	var w := 320
	var h := 200
	img.resize(w, h, Image.INTERPOLATE_BILINEAR)
	var cx := mark.x * w
	var cy := mark.y * h
	var strength: float = [0.8, 0.0, 0.42, 0.4][n]
	for y in h:
		var sl := 0.86 if y % 3 == 0 else 1.0
		var dark := 1.0
		if n == 3:
			dark = clampf(1.0 - float(y) / h * 0.9, 0.08, 1.0)
		for x in w:
			var c := img.get_pixel(x, y)
			c = Color(c.r * 1.05 + 0.03, c.g * 0.98 + 0.02, c.b * 0.82 + 0.02)
			if n == 1:
				var v := c.v
				c = c.lerp(Color(v, v, v), 0.65)
			var dx := (x - cx) / w
			var dy := (y - cy) / h * 0.62
			var d2 := dx * dx + dy * dy
			if strength > 0.0:
				var rays := 0.7 + 0.3 * sin(atan2(dy, dx) * 14.0 + n * 1.3)
				var halo := strength * (exp(-d2 * 60.0) * 0.9 + exp(-d2 * 9.0) * 0.3)
				var ring := strength * exp(-pow((sqrt(d2) - 0.11) * 40.0, 2.0)) * 0.35
				c += Color(1.0, 0.86, 0.6) * (halo * rays + ring)
			img.set_pixel(x, y, Color(minf(c.r, 1.0) * sl * dark, minf(c.g, 1.0) * sl * dark, minf(c.b, 1.0) * sl * dark))
	# the LIVE badge, or the dead feed
	var badge := Color(0.85, 0.08, 0.08) if n < 3 else Color(0.3, 0.3, 0.32)
	for y in range(8, 18):
		for x in range(8, 36):
			img.set_pixel(x, y, badge)
	for y in range(11, 15):
		for x in range(11, 15):
			img.set_pixel(x, y, Color(1, 1, 1))
	for k in 3:
		for y in range(11, 15):
			for x in range(18 + k * 5, 21 + k * 5):
				img.set_pixel(x, y, Color(1, 1, 1))
	# the lower third: PSYONIC PRESS, a green mark, text bars
	if n < 3:
		for y in range(166, 186):
			for x in range(10, 236):
				img.set_pixel(x, y, img.get_pixel(x, y) * 0.3)
		for y in range(171, 181):
			for x in range(14, 24):
				img.set_pixel(x, y, PSYON_GREEN)
		for k in 9:
			for y in range(172, 175):
				for x in range(30 + k * 16, 42 + k * 16):
					img.set_pixel(x, y, Color(0.95, 0.95, 0.92))
		for k in 6:
			for y in range(178, 180):
				for x in range(30 + k * 20, 46 + k * 20):
					img.set_pixel(x, y, Color(0.7, 0.72, 0.7))
	# the phone's bezel
	for y in h:
		for x in w:
			if x < 4 or y < 4 or x >= w - 4 or y >= h - 4:
				img.set_pixel(x, y, Color(0.01, 0.01, 0.012))
	img.resize(w * 2, h * 2, Image.INTERPOLATE_NEAREST)
	return ImageTexture.create_from_image(img)


# ------------------------------------------------------------------ examining things

## Hameron's six lines, as the frames transcribed them: read any again.
func _terminal() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var read := []
	for k in 6:
		if f.has("ev_hameron_%d" % (k + 1)):
			read.append(k + 1)
	if read.is_empty():
		await ui.think(L("examine", "monitors") if _zone == "up" else L("terminal", "none"))
		return
	if _zone == "trailer":
		await ui.think(L("trailer", "laptop"))
	var opts := []
	for k in read:
		opts.append("%s: HAMERON_%d" % [L("terminal", "pick"), k])
	opts.append(L("terminal", "close"))
	var i: int = await ui.choose(opts)
	if i >= read.size():
		return
	var n: int = read[i]
	ui.laptop_open(true)
	ui.smear.visible = false
	ui.laptop_log.append_text("[color=#557766]%s[/color]\n\n" % L("terminal", "top"))
	ui.laptop_log.append_text(L("terminal", "entry") % [n, L("ham", str(n))])
	main.play("keys", -12.0)
	await ui.say("", "[color=#888888]HAMERON_%d / 6[/color]" % n)
	ui.laptop_open(false)


func _crane_look() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if crane_state != "perch":
		await ui.think(L("crane", "ally"))
		return
	if f.has("cz_crane_seen"):
		await ui.think(L("crane", "again"))
		return
	f["cz_crane_seen"] = true
	await ui.think(L("crane", "think"))
	if main.frames_on:
		main.play("glitch", -14.0, 0.7)
		ui.glitch(0.25, 0.4)
		await ui.think(L("crane", "frames"))
		main.add_connection(1.0, L("crane", "why"))
	else:
		await ui.think(L("crane", "no_frames"))
	if intern.visible and intern.global_position.distance_to(crane.global_position) < 8.0:
		turn_to(intern, main.player.global_position, 0.3)
		await ui.say("Intern", L("crane", "intern"))


func _photo() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("cz_photo_chair"):
		await ui.think(L("examine", "photo_again"))
		return
	f["cz_photo_chair"] = true
	await ui.think(L("examine", "photo"))
	main.play("pressure", -16.0, 0.8)
	await ui.think(L("examine", "photo_2"))
	main.log_line("clue", L("examine", "photo_log"))


func interact(node: Object) -> bool:
	var id := str(node.get_meta("id"))
	var ui = main.ui
	var f: Dictionary = main.flags
	match id:
		"kiosk", "intern_plaza":
			await _kiosk()
		"doors":
			await ui.think(L("intro", "think") if not f.has("cz_desk") else L("lobby", "art"))
		"desk", "guard":
			await _desk()
		"lift":
			await _lift()
		"staff_door":
			await _route_staff()
		"staff_camera", "lobby_camera_1", "lobby_camera_2", "dock_camera":
			await ui.think(L("routes", "lobby_cam"))
		"staff_speaker":
			main.play("ding", -18.0, 1.4)
			await ui.think(L("routes", "speaker"))
		"loading_dock":
			await _route_dock()
		"service_lift":
			await ui.think(L("routes", "service_think"))
		"dock_guard":
			await ui.think(L("routes", "dock_guard"))
		"guard2":
			await ui.think(L("routes", "guard2"))
		"art":
			await ui.think(L("lobby", "art"))
		"cogni_screen":
			await ui.think(L("lobby", "cogni"))
			if main.frames_on:
				await ui.think(L("lobby", "cogni_eye"))
		"prayer":
			await ui.think(L("lobby", "prayer"))
			await ui.think(L("lobby", "prayer_2"))
		"police_drone":
			await ui.think(L("routes", "lobby_cam"))
		"lynx":
			await ui.say("Lynx", L("intro", "lynx") if not f.has("cz_hameron_done") else L("outside", "lynx"))
		"intern":
			if _tour_wait and _tour >= 0 and not _busy:
				await _tour_stop()
			elif f.has("cz_after_hours") and crane_state != "perch":
				await ui.say("Intern", L("exit", "intern"))
			else:
				await ui.say("Intern", L("floor", "follow"))
		"worker":
			await ui.think(L("worker", "think"))
			await ui.say("Cogni", L("worker", "cogni"))
			await ui.think(L("worker", "think_2"))
		"pingpong":
			await ui.think(L("pingpong", "think") if not f.has("cz_pingpong") else L("pingpong", "again"))
			f["cz_pingpong"] = true
		"crane":
			await _crane_look()
		"lab_fox":
			await ui.think(L("lab", "fox"))
		"lab_birds":
			await ui.think(L("lab", "birds"))
		"lab_jelly":
			await ui.think(L("lab", "jelly"))
		"lab_pdrone":
			await ui.think(L("lab", "pdrone"))
		"office_door":
			await _office_door()
		"hameron":
			await ui.think(L("examine", "hameron_after") if f.has("cz_hameron_done") else L("examine", "hameron_before"))
		"photo":
			await _photo()
		"planchette":
			await ui.think(L("examine", "planchette"))
		"books", "books_e":
			await ui.think(L("examine", "books"))
		"office_window":
			await ui.think(L("examine", "window"))
			await ui.think(L("examine", "window_2"))
		"armchair":
			await ui.think(L("examine", "armchair"))
		"monitors", "monitors_w", "laptop":
			await _terminal()
		"lift_25":
			await _lift_down()
		"turan", "car":
			await _at_car()
		"emmet":
			await _emmet()
		"bag":
			await _bag()
		"trailer":
			await ui.think(L("trailer", "trailer"))
		"hub":
			await ui.think(L("trailer", "hub"))
		"photos":
			await ui.think(L("trailer", "photos"))
		"drills":
			await ui.think(L("trailer", "drills"))
		"depot":
			await ui.think(L("trailer", "tunnel"))
			await ui.think(L("trailer", "tunnel_2"))
		"car_home":
			await _end()
		_:
			return false
	return true


# ------------------------------------------------------------------ movers

## Walk a figure through points and wait; past a deadline (twice the walk
## plus three seconds) it is put at the end, so no scene waits forever.
func _move(fig: Node3D, path: Array, speed: float) -> void:
	if path.is_empty() or not is_instance_valid(fig):
		return
	for mv0 in movers:
		if mv0["fig"] == fig:
			mv0["done"] = true
	var mv := {"fig": fig, "path": path, "i": 0, "speed": speed, "done": false}
	movers.append(mv)
	var length := 0.0
	var prev: Vector3 = fig.position
	for pt: Vector3 in path:
		length += Vector2(pt.x - prev.x, pt.z - prev.z).length()
		prev = pt
	var limit := length / maxf(0.1, speed * 2.2) * 2.0 + 3.0
	var t := 0.0
	while not mv["done"] and t < limit:
		await get_tree().process_frame
		t += get_process_delta_time()
	if not mv["done"]:
		mv["done"] = true
		if is_instance_valid(fig):
			fig.position = path[path.size() - 1]


func _moving(fig: Node3D) -> bool:
	for mv in movers:
		if mv["fig"] == fig and not mv["done"]:
			return true
	return false


func _tick_movers(delta: float) -> void:
	for mv in movers:
		if mv["done"]:
			continue
		var fig: Node3D = mv["fig"]
		var path: Array = mv["path"]
		var i: int = mv["i"]
		if i >= path.size() or not is_instance_valid(fig):
			mv["done"] = true
			continue
		var tgt: Vector3 = path[i]
		var d := tgt - fig.position
		d.y = 0.0
		var dist := d.length()
		if dist < 0.15:
			fig.position = Vector3(tgt.x, tgt.y, tgt.z)
			mv["i"] = i + 1
			if i + 1 >= path.size():
				mv["done"] = true
				Anim.idle(fig, _t, 0.0)
			continue
		var spd: float = mv["speed"] * 2.2
		fig.position += d.normalized() * minf(spd * delta, dist)
		fig.position.y = tgt.y
		fig.rotation.y = lerp_angle(fig.rotation.y, atan2(-d.x, -d.z), minf(1.0, delta * 8.0))
		Anim.walk(fig, _t, mv["speed"], 0.0, 1.0)
	var keep := []
	for mv in movers:
		if not mv["done"]:
			keep.append(mv)
	movers = keep


# ------------------------------------------------------------------ each frame

func tick(delta: float) -> void:
	if not main or not main.player or not zs:
		return
	var p = main.player
	var pp: Vector3 = p.global_position
	var f: Dictionary = main.flags
	_tick_movers(delta)
	# the sliding doors
	for d in doors:
		var dn := d as Node3D
		var x0: float = dn.get_meta("x0")
		var near := pp.distance_to(Vector3(0, pp.y, 0)) < 4.2 and pp.y < 3.0
		var want := x0 + (signf(x0) * 1.8 if near else 0.0)
		dn.position.x = lerpf(dn.position.x, want, minf(1.0, delta * 4.0))
	if art:
		art.rotation.y += delta * 0.25
		var k := 0
		for c in art.get_children():
			(c as Node3D).rotation.y += delta * (0.15 + k * 0.2)
			k += 1
	if jelly_n:
		jelly_n.position.y = FY + 2.3 + sin(_t * 0.8) * 0.12
		jelly_n.rotation.y += delta * 0.1
	_tick_walkers(delta)
	_tick_pingpong(delta, pp)
	_tick_lynx(delta, pp)
	_tick_crane(delta, pp)
	# the intern waits for Carl at each stop of the tour
	if _tour_wait and _tour >= 0 and not _busy and not main.ui.busy and not _moving(intern):
		if pp.distance_to(intern.global_position) < 6.5:
			_tour_stop()
	# Cogni's ring is a pupil, one frame in a few hundred, with the frames on
	if cogni_eye:
		_eye_t -= delta
		if _eye_t <= 0.0:
			cogni_eye.visible = false
			if main.frames_on and _zone == "street" and pp.distance_to(Vector3(-17.0, 0, -10.5)) < 14.0 and randf() < 0.012:
				cogni_eye.visible = true
				_eye_t = 0.12
	# the office: the frames have nothing to say
	if _zone == "up" and main.frames_on and not _office_toast and pp.z < -24.4 and absf(pp.x) < 11.0:
		_office_toast = true
		main.ui.show_toast(L("office", "frames_toast"), 4.0)
	if hameron and _zone == "up" and pp.distance_to(hameron.global_position) < 9.0:
		Anim.look(hameron, p.cam.global_position, 0.7, 0.04)
	if _busy or main.ui.busy or f.has("cinematic"):
		return
	if f.has("cz_hameron_done") and crane_state == "perch" and _zone == "up" and pp.z > -23.2:
		_crane_wakes()
	elif f.has("cz_hameron_done") and not f.has("cz_outside") and _zone == "street" and pp.z > 2.5:
		_outside()


func _tick_walkers(delta: float) -> void:
	if _zone == "trailer":
		return
	for w in walkers:
		var fig: Node3D = w["fig"]
		fig.position.x += w["dir"] * w["speed"] * 1.15 * delta
		if fig.position.x > w["x1"] or fig.position.x < w["x0"]:
			w["dir"] = -w["dir"]
			fig.position.x = clampf(fig.position.x, w["x0"], w["x1"])
		fig.rotation.y = -PI / 2.0 if w["dir"] > 0.0 else PI / 2.0
		Anim.walk(fig, _t, w["speed"], w["phase"], 1.0)


func _tick_pingpong(delta: float, pp: Vector3) -> void:
	if _zone != "up" or main.flags.has("cz_after_hours") or not ball:
		return
	_ball_t += delta
	var ph := fmod(_ball_t * 0.85, 2.0)
	var s := ph if ph < 1.0 else 2.0 - ph
	var c := Vector3(11.5, FY, -4.6)
	ball.position = c + Vector3(lerpf(-1.3, 1.3, s), 0.82 + absf(sin(s * PI * 2.0)) * 0.3, sin(_ball_t * 1.3) * 0.4)
	for i in players.size():
		var pl: Node3D = players[i]
		var arms: Array = pl.get_meta("arms")
		var hit := (i == 0 and s < 0.15) or (i == 1 and s > 0.85)
		(arms[1] as Node3D).rotation.x = lerpf((arms[1] as Node3D).rotation.x, -1.3 if hit else -0.7, minf(1.0, delta * 10.0))
		Anim.look(pl, ball.global_position, 0.8, 0.2)
	_laugh_t -= delta
	if _laugh_t <= 0.0:
		_laugh_t = 9.0
		if pp.distance_to(c) < 14.0 and not main.ui.busy:
			main.ui.caption(L("floor", "laugh"), 2.0)


func _tick_lynx(delta: float, pp: Vector3) -> void:
	if not lynx or lynx_state == "hidden":
		return
	var p = main.player
	if _moving(lynx):
		return
	var target := lynx_target
	if lynx_state == "follow":
		target = pp + Basis(Vector3.UP, p.yaw) * Vector3(-1.1, 0, 0.9)
		target.y = pp.y - 0.05
	var d := target - lynx.position
	d.y = 0.0
	var dist := d.length()
	if absf(lynx.position.y - target.y) > 2.0 or dist > 30.0:
		lynx.position = target
		return
	lynx.position.y = lerpf(lynx.position.y, target.y, minf(1.0, delta * 8.0))
	if dist > 0.5:
		var speed := clampf(dist * 2.2, 1.2, 5.4)
		lynx.position += d.normalized() * minf(speed * delta, dist)
		lynx.rotation.y = lerp_angle(lynx.rotation.y, atan2(-d.x, -d.z), minf(1.0, delta * 8.0))
		Anim.walk(lynx, _t, 1.1 * speed / 2.6, 0.0, 1.0)
	else:
		Anim.idle(lynx, _t, 1.0)
		Anim.look(lynx, p.cam.global_position, 0.6, 0.05)


func _tick_crane(delta: float, pp: Vector3) -> void:
	if not crane:
		return
	var p = main.player
	var body: Node3D = crane.get_meta("body")
	var head: Node3D = crane.get_meta("head")
	var wings: Array = crane.get_meta("wings")
	match crane_state:
		"perch":
			_crane_fold(1.0)
			if main.frames_on and _zone == "up" and pp.distance_to(crane.global_position) < 7.0:
				var lp := crane.to_local(p.cam.global_position)
				head.rotation.y = lerp_angle(head.rotation.y, clampf(atan2(-lp.x, -lp.z), -0.9, 0.9), minf(1.0, delta * 1.5))
		"walk":
			_crane_fold(0.85)
			var tgt := pp + Basis(Vector3.UP, p.yaw) * Vector3(1.0, 0, 1.4)
			tgt.y = pp.y - 0.05
			var d := tgt - crane.position
			d.y = 0.0
			if absf(crane.position.y - tgt.y) > 2.0 or d.length() > 30.0:
				crane.position = tgt
			elif d.length() > 0.4:
				crane.position += d.normalized() * minf(clampf(d.length() * 2.0, 0.8, 4.5) * delta, d.length())
				crane.rotation.y = lerp_angle(crane.rotation.y, atan2(-d.x, -d.z), minf(1.0, delta * 6.0))
				body.position.y = 0.82 + absf(sin(_t * 7.0)) * 0.04
				head.position.z = -0.46 + sin(_t * 7.0) * 0.05
			crane.position.y = lerpf(crane.position.y, tgt.y, minf(1.0, delta * 8.0))
		"fly", "roof":
			var tgt: Vector3
			if crane_state == "roof" and _zone == "street":
				tgt = CAR_AT + Vector3(0, 0.6, 0)
				_crane_fold(lerpf(0.0, 1.0, clampf(1.0 - crane.position.distance_to(tgt) / 4.0, 0.0, 1.0)))
			else:
				tgt = pp + Basis(Vector3.UP, p.yaw) * Vector3(2.4, 2.6, -4.2) + Vector3(0, sin(_t * 1.6) * 0.12, 0)
				_crane_fold(0.0)
				for i in wings.size():
					var sx := -1.0 if i == 0 else 1.0
					(wings[i] as Node3D).rotation = Vector3(0, 0, sx * sin(_t * 6.5) * 0.55)
			var d := tgt - crane.position
			if d.length() > 40.0:
				crane.position = tgt
			else:
				crane.position = crane.position.lerp(tgt, minf(1.0, delta * 1.8))
			var hd := Vector2(d.x, d.z)
			if hd.length() > 0.3:
				crane.rotation.y = lerp_angle(crane.rotation.y, atan2(-d.x, -d.z), minf(1.0, delta * 3.0))
			else:
				crane.rotation.y = lerp_angle(crane.rotation.y, p.yaw, minf(1.0, delta * 1.5))


# ------------------------------------------------------------------ HUD, phone, scan

func objective() -> String:
	var f: Dictionary = main.flags
	if f.has("cz_tunnels_22"):
		return L("objective", "home")
	if f.has("broadcast_seen"):
		return L("objective", "bag")
	if f.has("cz_trailer"):
		return L("objective", "emmet")
	if f.has("cz_outside"):
		return L("objective", "car")
	if f.has("cz_hameron_done"):
		return L("objective", "leave")
	if f.has("cz_door_called"):
		return L("objective", "door")
	if f.has("cz_on_25"):
		return L("objective", "up")
	if f.has("cz_desk"):
		return L("objective", "lift")
	return L("objective", "street")


func phone() -> String:
	var f: Dictionary = main.flags
	var t := L("phone", "text1")
	if f.has("cz_hameron_done"):
		t += L("phone", "text2")
	if f.has("cz_tunnels_22"):
		t += L("phone", "text3")
	return t


func scan_people() -> Array:
	var out := []
	if lynx and lynx.visible:
		out.append([lynx, L("signs", "lynx_scan")])
	if crane and crane_state != "perch":
		out.append([crane, L("signs", "crane_scan_ally")])
	return out


## Dev args for screenshots: scene=lobby | up | lab | office | seated |
## outside | trailer | broadcast (frame=0..3); at=x,y,z is Main's.
func apply_args(a: Dictionary) -> void:
	var f: Dictionary = main.flags
	var p = main.player
	var sc := str(a.get("scene", ""))
	var place := not a.has("at")
	match sc:
		"lobby":
			f["cz_desk"] = true
			if place:
				p.global_position = Vector3(3.0, 0.1, -1.5)
		"up", "lab":
			f["cz_desk"] = true
			f["cz_on_25"] = true
			_zone = "up"
			_apply_zone()
			if place:
				p.global_position = L_25 if sc == "up" else Vector3(8.0, FY + 0.05, -10.0)
			lynx.position = p.global_position + Vector3(-1.0, -0.05, 0.8)
		"office", "seated":
			f["cz_on_25"] = true
			_zone = "up"
			_apply_zone()
			_office_doors(true, 0.01)
			if sc == "seated":
				p.global_position = ARMCHAIR + Vector3(0, 0.05, 0.05)
				p.seated = true
				p.crouch = 0.5
				lynx_state = "hidden"
				lynx.visible = false
			elif place:
				p.global_position = Vector3(0, FY + 0.05, -25.4)
			if lynx_state != "hidden":
				lynx.position = Vector3(1.4, FY, -25.6)
		"outside", "crane":
			f["cz_hameron_done"] = true
			f["cz_outside"] = true
			_after_hours()
			crane_state = "fly"
			if place:
				p.global_position = Vector3(6.0, 0.1, 6.0)
			crane.position = p.global_position + Vector3(1.2, 2.3, 1.0)
		"trailer", "broadcast":
			f["cz_trailer"] = true
			_zone = "trailer"
			_apply_zone()
			_dusk_env()
			turan.reparent(zt)
			turan.global_position = TR + Vector3(-7.4, 0, 6.4)
			crane_state = "fly"
			if place:
				p.global_position = TR + Vector3(-5.6, 0.1, 8.0)
			lynx.position = p.global_position + Vector3(-1.2, -0.1, 0.6)
			crane.position = p.global_position + Vector3(1.2, 2.3, 1.0)
			if sc == "broadcast":
				_show_frame(int(a.get("frame", "0")))
	if a.has("yaw"):
		p.yaw = deg_to_rad(float(a["yaw"]))
		p.rotation.y = p.yaw


func _show_frame(n: int) -> void:
	var tex: ImageTexture = await _bframe(n)
	main.ui.show_picture(tex, L("broadcast", "cap_%d" % (n + 1)))


# ------------------------------------------------------------------ headless

## Headless: the arrival, the kiosk (the pump picks 1: kind), the desk, the
## lift, the tour (Carl is put by the intern at each stop), the crane, the
## office (the pump picks 1: what the drive does), the transcript, the
## photo, the crane waking, the lift down, outside, the car (refuse; the
## fork's offer refused), the trailer, the broadcast, the bag. Then the
## other branches directly, then every interactable twice. Every wait has
## a deadline; the level is hidden while it runs (the broadcast set is not).
func selftest() -> void:
	var f: Dictionary = main.flags
	var p = main.player
	_st_hidden = true
	zs.visible = false
	zu.visible = false
	zt.visible = false
	await intro()
	# the people who walk with Carl, or lead him (left wherever the test put them)
	walk_ignore = [lynx, intern, crane]
	for id in ["kiosk", "staff_door", "loading_dock", "desk", "lift"]:
		await check_walk("spawn->" + id, id)
	for id in ["kiosk", "doors", "art", "cogni_screen", "prayer", "staff_door", "loading_dock", "desk", "lift"]:
		var n := _node_by_id(id)
		if n:
			await main.interact(n)
			print("ok ", id)
		else:
			print("MISSING ", id)
	_hide_zones()
	print("kind=", f.has("cz_intern_kind"), " desk=", f.has("cz_desk"), " on25=", f.has("cz_on_25"), " zone=", _zone)
	await check_walk("lift 25->lounge stop", STOP_LOUNGE, L_25, Rect2(), 1.5)
	await check_walk("lift 25->lab stop", STOP_LAB, L_25, Rect2(), 1.5)
	await check_walk("lift 25->office door stop", STOP_DOOR, L_25, Rect2(), 1.5)
	var t := 0.0
	while _tour <= 2 and _tour >= 0 and t < 240.0:
		if _tour_wait and not _moving(intern):
			p.global_position = intern.global_position + Vector3(0.8, 0.05, 0.8)
		await get_tree().process_frame
		t += get_process_delta_time()
	print("ok tour=", _tour, " lounge=", f.has("cz_lounge"), " lab=", f.has("cz_lab"), " door=", f.has("cz_door_called"), " t=", int(t))
	if not main.frames_on:
		main.toggle_frames()
	for id in ["crane", "pingpong", "pingpong", "worker", "lab_fox", "lab_birds", "lab_jelly", "lab_pdrone", "monitors", "office_door"]:
		var n := _node_by_id(id)
		if n:
			await main.interact(n)
			print("ok ", id)
	print("ok office ham=", [f.has("ev_hameron_1"), f.has("ev_hameron_6")], " drive=", f.has("ev_drive"), " ask=", f.get("cz_hameron_ask"), " done=", f.has("cz_hameron_done"))
	await check_walk("lift 25->hameron", "hameron", L_25)
	await check_walk("office->lift_25", "lift_25", Vector3(0, FY + 0.05, -27.0))
	for id in ["photo", "planchette", "books", "office_window", "monitors", "hameron"]:
		var n := _node_by_id(id)
		if n:
			await main.interact(n)
			print("ok ", id)
	main.toggle_frames()
	p.global_position = Vector3(0, FY + 0.05, -21.5)
	t = 0.0
	while crane_state == "perch" and t < 30.0:
		await get_tree().process_frame
		t += get_process_delta_time()
	while _busy and t < 90.0:
		await get_tree().process_frame
		t += get_process_delta_time()
	print("ok crane=", crane_state, " ally=", f.has("drone_ally"))
	await main.interact(_node_by_id("lift_25"))
	_hide_zones()
	p.global_position = Vector3(2.0, 0.1, 5.0)
	t = 0.0
	while not f.has("cz_outside") and t < 30.0:
		await get_tree().process_frame
		t += get_process_delta_time()
	while _busy and t < 90.0:
		await get_tree().process_frame
		t += get_process_delta_time()
	print("ok outside=", f.has("cz_outside"))
	await check_walk("lobby lifts->street (outside)", Vector3(2.0, 0.0, 5.0), L_GROUND, Rect2(), 1.5)
	await check_walk("lobby lifts->car", "car", L_GROUND)
	await main.interact(_node_by_id("car"))
	_hide_zones()
	print("ok car choice=", f.get("cz_drive_choice"), " trust=", main.trust, " trailer=", f.has("cz_trailer"))
	for id in ["emmet", "laptop", "bag", "car_home"]:
		await check_walk("trailer->" + id, id, TR + Vector3(-5.6, 0.1, 8.0))
	for id in ["trailer", "hub", "photos", "drills", "depot", "laptop", "bag", "emmet", "bag", "car_home"]:
		var n := _node_by_id(id)
		if n:
			await main.interact(n)
			print("ok ", id)
	print("ok broadcast=", f.has("broadcast_seen"), " knife=", f.has("ev_knife"), " tunnels=", f.has("cz_tunnels_22"), " ended=", _ended)
	# the other branches
	main.trust["lynx"] = -1
	await _lynx_choice(0)
	print("ok give at -1: lynx_has_drive=", f.has("lynx_has_drive"), " trust=", main.trust["lynx"])
	f.erase("lynx_has_drive")
	main.trust["lynx"] = 1
	await _lynx_choice(0)
	print("ok give at +1: lynx_has_drive=", f.has("lynx_has_drive"))
	await _lynx_choice(2)
	print("ok warn: warned_lynx=", f.has("warned_lynx"), " trust=", main.trust["lynx"])
	await _fork_offer(0)
	print("ok fork yes: drone_owned=", f.has("drone_owned"))
	await _ask(0)
	await _ask(2)
	print("ok ask: ", f.get("cz_hameron_ask"))
	f.erase("ev_knife")
	main.trust["emmet"] = -1
	await _bag()
	print("ok bag note: knife=", f.has("ev_knife"))
	for kind in ["hack", "sneak", "person"]:
		f.erase("cz_route")
		await _take_route(kind)
		print("ok route ", kind, " zone=", _zone)
	f.erase("cz_route")
	if not "look away" in main.lexicon:
		main.lexicon.append("look away")
	if not "we" in main.lexicon:
		main.lexicon.append("we")
	_zone = "street"
	await _route_staff()
	print("ok staff route=", f.get("cz_route"), " conn=", main.connection)
	for k in 4:
		var tex: ImageTexture = await _bframe(k)
		print("ok frame ", k, " ", tex.get_width(), "x", tex.get_height())
	f.erase("cinematic")
	await main.selftest_all_interactables()
	_st_hidden = false
	_apply_zone()
	print("ok cognizo done=", f.has("cognizo_done"), " broadcast=", f.has("broadcast_seen"))


func _hide_zones() -> void:
	if _st_hidden:
		zs.visible = false
		zu.visible = false
		zt.visible = false
