extends "res://scripts/Level.gd"
## Chapters 21 and 22: the wellness spa downtown. Bible A2-B4 (the PIP
## route). Book: "The Spa stood in stark contrast to the rest of its
## surroundings. Where I was expecting a prison, it looked like an old
## cartoon; its wooden walls are a rarity in a city made of steel and
## silicon, blood and bone." Four storeys of fake timber among the neon,
## synthetic trees at the door, "a subtle mist of a lavender fragrance that
## oscillated its way around the edifice". Midnight: the wooden lobby, the
## violin "barely audible", the attendant who is so happy to see Carl ("a
## quiet fear about him"), the room: a bed with soft white linen, a TV, a
## window facing downtown, "a blood-red eye symbol on a small tablet sat
## above a prayer mat". The lavender turns into "a bitter electric chemical
## perfume"; the window locked, the handle barred. The tablet's quiet prayer
## (refusable: the gas comes harder and forces it after a minute), the Seven
## Breaths of Reconciliation, then the air changes and the tablet speaks in
## Mira's voice. Morning: the white-tiled room with one black hole in the
## floor ("There is only one goal in this room: jump down the hole"); with
## the frames on the hole boils with light and Carl's eyeless double climbs
## out. The jump is a dream of white light and Mira: "Welcome, Daddy.
## You're home." Chapter 22: the pulsing light in the corner of the TV
## (Lynx's hack, from outside), the lock rattling, "Carl, let's get you the
## fuck out of here." Out the front past the staring staff (Lynx's badge
## spoof and the word "we"), or through the laundry corridor without being
## seen. The car outside.
##
## Layout (metres), every place on the ground (y 0) and far enough apart
## that only the one Carl is in is shown:
##   street   x -50..50, z 12..32: the spa's timber facade on z 12 between
##            two cyber blocks, the alley east of it (x 10.4..13), the car.
##   lobby    x -9..9, z 0..12, behind the facade: desk, beams, diffuser,
##            Eren's portrait; stair door (back wall, west), staff door (east).
##   up       the first floor: hallway x 50..70, z 6..8.4, stair door at the
##            east end; Carl's room x 53..59, z -1..6, door at x 55..56; the
##            window on the north wall looks out at downtown and the Tower.
##   base     the morning cleanse: tiled room x -64..-56, z -4..4, the hole at
##            (-60, 0, -0.5).
##   laundry  the service corridor x -52..-18, z -41.5..-38.5, alcoves on the
##            south side, the back door at the east end (out to the alley).
##
## Entry: spa_booked, or pip_active (the linear chain always has it; the
## line reads Monica's booking either way, the night after Lushon's).
## Flags read: spa_booked, pip_active, lushons_done (Turan and Emmet in the
## car), forner_called, main.lexicon "we" (the front way out).
## Flags set: spa_arrived, spa_checked_in, spa_room, spa_window_locked,
## spa_door_barred, spa_prayer_refused, spa_prayer_done, mira_voice_heard,
## spa_morning, spa_double_seen, spa_hole_jumped, spa_lynx, spa_badge_tried,
## spa_route_front | spa_route_laundry, spa_seen (count), spa_out, spa_done.
## Effects: +4 C (Mira's voice), +5 C (the hole), +2 C ("we" on the guards).
## Next: Cognizo. Metas for the systems that come later: "guard" (the
## attendants are company security, tier 3), "hackable" (tablet, TV, the
## FreudBot unit, readers), "route" (front door, laundry corridor).

const Synth := preload("res://scripts/Synth.gd")

## Every line of text in the level, keyed by beat and line. say lines are
## [who, text]; choices are lists of labels. Verbatim lines are the book's.
const LINES := {
	"cards": {
		"chapter": "[b]CHAPTER 21[/b]\n\n[color=#c8b4e8]The spa[/color]\n[color=#aaaaaa]downtown  -  Day 5, midnight[/color]",
		"morning": "[b]Day 6  ·  07:00[/b]\n\n[color=#aaaaaa]the morning cleanse[/color]",
		"ch22": "[b]CHAPTER 22[/b]\n\n[color=#aaaaaa]Day 6, 08:40[/color]",
		"drive_cap": "Day 6, 09:10  -  a non-Psyonic car, heading for Cognizo",
	},
	"street": {
		"booked": "Monica had booked it. A luxury rehabilitation spa in the center of town, to help support my reconciliation. \"Highly recommended by senior leadership.\"",
		"pip": "The PIP had a line for it: a luxury rehabilitation spa in the center of town. Monica had set it up. Of course she had.",
		"after_lushons": "Lushon's was behind me. I knew I needed to check in to the wellness spa that Monica had set up for me, but who knows what would await me there?",
		"before": "I knew I needed to check in to the wellness spa that Monica had set up for me, but who knows what would await me there?",
		"look": "The Spa stood in stark contrast to the rest of its surroundings. Where I was expecting a prison, it looked like an old cartoon; its wooden walls are a rarity in a city made of steel and silicon, blood and bone.",
		"look_2": "The structure itself stood four stories high; its entrance was lined with synthetic trees and shrubbery. There was a subtle mist of a lavender fragrance that oscillated its way around the edifice of the building.",
		"look_3": "The building itself was a message, a call for disarmament, a call for me to submit. I wouldn't give it the satisfaction.",
		"door": "I entered the building at midnight.",
		"door_shut": "The door was shut and the reader beside it had nothing to say to me.",
		"reader": "I held my badge to the reader out of habit. It went red before it finished reading.",
		"reader_2": "BADGE SUSPENDED. PERFORMANCE IMPROVEMENT PLAN IN EFFECT. My badge didn't open anything anymore. It just told on me.",
		"sign": "SERENITY HOUSE, in carved letters lit from behind, and under it in a smaller, colder font: a Psyonic wellness partner.",
		"trees": "Synthetic trees in wooden planters. The leaves were too green and they didn't move in the wind. Somebody wiped them down every morning.",
		"mist": "A brass nozzle under the eave breathed lavender out over the pavement in slow pulses. Sweet, at this distance.",
		"street": "The city went on behind me as if nothing in it was made of wood: the ads, the drones, the Tower lit to the top.",
		"ad": "SERENITY HOUSE  -  let go. The ad cycled to a FreudBot and back.",
	},
	"lobby": {
		"enter": "The lobby gave the illusion of comfort in a way Psyonic HQ living quarters never could. Bare wooden paneling lined the walls, with exposed wooden beams lining the ceiling; a soft melody on violin played in the background, barely audible.",
		"enter_2": "The illusion of man-made craftsmanship. A faux return to nature that corporate employees or dissidents needed to fall back in line.",
		"desk_think": "I approached the front desk, and surprisingly, a human attendant greeted me. He was middle-aged and looked genuinely happy to see me, so happy.",
		"a1": "Carl, I'm so glad you made it in. We have your room prepared for you; your wife spared no expenses. Follow me right away.",
		"a2": "We were expecting you much earlier, Mr. Drake; we were supposed to start your treatments immediately upon arrival. We would hate to see a Psyonic man like yourself miss out on anything.",
		"a2_think": "There was sincerity behind his words, but not for my relaxation; there was a quiet fear about him as he spoke to me.",
		"choices": ["\"What kind of treatments?\"", "Say nothing. Play the patient."],
		"a3": "We have treatments for every possible mental and spiritual ailment, Carl. You are really in for a treat for the duration of your stay.",
		"a3_quiet": "You are really in for a treat for the duration of your stay, Carl.",
		"a4": "Just know that there are no drugs or alcohol on the premise, Mr. Drake; any use of such would be in violation of your PIP. Apologies for my abruptness; they made sure I told you that.",
		"a5": "But no worries at all, you are in good hands; we are extremely successful in curbing addictive and deviant behaviors here. All it takes is faith and determination.",
		"walk": "We walked down a hallway and up a flight of stairs.",
		"log": "Checked in at the spa at midnight. The attendant was afraid of something, and it wasn't me.",
		"desk": "Real wood, or a good print of it. A guest ledger, a bowl of lavender sachets, a little brass bell nobody would ever need to ring.",
		"guestbook": "The guest ledger, open at tonight. Four names above mine, every one of them with PSYONIC beside it and the same note in the same hand: TREATMENT COMPLETE.",
		"brochure": "A brochure in a wooden rack. Breathwork. Reconciliation. The Morning Cleanse. \"Letting go is the best way to start healing.\"",
		"violin": "A speaker hidden in a beam. The violin was so slow I couldn't tell where one note ended. It took me a long time to hear that it was a tune. Longer to hear which one.",
		"violin_frames": "With the frames on I could hear it properly: the hymn, the one from the hangar, slowed down until it was almost a single sound.",
		"diffuser": "A wooden diffuser the size of a bin, breathing lavender into the room. Up close it hissed like a gas tap.",
		"eren": "A portrait of Eren Elontiel over the fireplace that wasn't a fireplace, in sunglasses, smiling at nobody. LEADING US THROUGH THE DARK.",
		"plaque": "A brass plaque: ALL IT TAKES IS FAITH AND DETERMINATION. Somebody had polished the word FAITH more than the others.",
		"notice": "NO DRUGS OR ALCOHOL ON THE PREMISES. GUESTS ON A PERFORMANCE IMPROVEMENT PLAN ARE MONITORED FOR THEIR OWN SAFETY.",
		"kiosk": "A FreudBot kiosk in a wooden cabinet, its screen asleep. When I leaned in, it woke and said my name before I'd said anything.",
		"beams": "Exposed beams, every one with the same knot in the same place. Printed.",
		"stair_door": "The stairs. The attendant's way, not mine. The handle had a reader on it.",
		"staff_door": "STAFF ONLY. Behind it, the hum of machines and the smell of hot linen.",
		"plants": "More synthetic trees. Their pots were full of real soil, which somehow made it worse.",
		"rug": "A rug the color of lavender, the only color in the room that wasn't wood.",
	},
	"hall": {
		"a1": "Ah, here we are. This is your room. We will begin your treatments promptly at 7:00 a.m. tomorrow morning and then break at 9 for your appointment with our Freudbot.",
		"a2": "Monica was kind enough to bring the unit you've been working with here.",
		"a2_think": "His smile was paper-thin, like it was drawn on, like the mask he was wearing didn't fit his face quite right.",
		"open": "He opened the door.",
		"room_think": "The room echoed the fake coziness of the whole building; wooden accents and too-strong lavender scents assaulted my senses.",
		"a3": "Alright, this is where I leave you. I suggest that you complete our healing prayer prior to heading to bed. We've found that it's the perfect way to get a successful treatment day started.",
		"a3_think": "Healing prayer. Right on schedule.",
		"closed": "He closed the door.",
		"frames_off": "I removed my Ora frames to prevent any unwanted surprises. My plan was to wait until I heard from Turan or someone on the outside tomorrow and never come back to this place.",
		"doors": "Room doors, numbered in brass. Behind one of them somebody was breathing in a count of seven.",
		"stairs_locked": "The stair door had a reader on the handle. My badge was suspended; it would only tell them where I was.",
		"trolley": "A steel trolley outside the next room, under a sheet. The sheet had the shape of a handle and a long bit. A label on the rail: DRAKE, C.  09:30.",
		"trolley_frames": "With the frames on the sheet had a ring drawn on it in marker, over where the bit would be.",
		"trolley_log": "A surgical trolley in the spa hallway under a sheet, tagged DRAKE, C. 09:30. Shaped like a drill.",
	},
	"room": {
		"bed": "A bed with soft white linen, turned down, a sachet of lavender on the pillow.",
		"lie": "The lavender smell was pungent and slowly became oppressive as I laid back on the bed. It morphed from a sweet floral fragrance to a bitter electric chemical perfume. I began to gag.",
		"lie_2": "It was no longer an aroma diffuser meant to elicit relaxation; this was chemical warfare meant to assail my mind, disrupt my thought.",
		"window": "I tried to open the window; it was locked. Downtown went on behind the glass, lit, close enough to touch.",
		"window_again": "Locked. The latch didn't have a keyhole; it had a reader.",
		"door": "The silver door handle was also barred shut. I was stuck here. Of course, I was.",
		"door_2": "This was part of it; they never intended my treatment to start in the morning; it started as soon as I walked in the door.",
		"door_again": "Barred. I put my shoulder against it once, quietly, and the door didn't notice.",
		"plan": "As much as I wanted to break down the door, Turan's plan echoed through my ears: we need to take it down from the inside out. I needed to feign compliance; I needed to play my role, an alcoholic father that is on his last straw.",
		"tv": "A TV on the wall, off, my own face in it, small and dark.",
		"tv_morning": "The TV, off. My face in it looked like it had been left somewhere overnight.",
		"freudbot": "A FreudBot desk unit. Mine: the scuff on the casing, the sticker Ezra put on it. Monica was kind enough to bring the unit.",
		"freudbot_2": "Good evening, Carl. Our session is at 9:00. I'm so glad we can keep working together.",
		"vent": "A vent over the door, painted to look like wood grain. It exhaled lavender in a slow rhythm, like something asleep.",
		"mat": "A prayer mat, woven, worn at the knees by somebody before me. Above it, the tablet with the eye.",
		"tablet": "A blood-red eye symbol on a small tablet, propped on a stand above the prayer mat.",
		"frames_sad": "With the frames on the eye on the tablet looked at me for a moment longer than a picture should.",
	},
	"prayer": {
		"chime": "The tablet chimed awake with text.",
		"welcome": "Welcome, Carl. Walking the path is never easy. We see your progress.",
		"think": "This felt different; it felt forced, not nearly as cryptic as my other encounters with this version of Psyon. This was a game created by Psyonic, not the being. I could handle this.",
		"ask": "Let us perform a quiet prayer together, Carl, a little ritual to help us start treatment on the right foot.",
		"choices": ["\"Sure.\" Kneel on the mat.", "Refuse. Lie still and wait for morning."],
		"sure": "I answered, \"Sure.\" I would play their game. I would be their compliant patient. But inside, I was already plotting.",
		"refuse": "I didn't answer. The tablet's eye held still, the way a person holds still when they've decided to wait you out.",
		"refuse_2": "The vent over the door clicked, and the lavender came harder.",
		"refuse_log": "Refused the spa's prayer. The room filled with lavender gas.",
		"wait_1": "The prayer is waiting, Carl.",
		"wait_2": "Walking the path is never easy. Kneel.",
		"wait_3": "We see you, Carl.",
		"gas_1": "The air had a taste now, sweet and metallic, a battery under the tongue.",
		"gas_2": "A high whine in my ears that wasn't in the room. The walls breathed lavender.",
		"forced": "My knees found the mat before I had decided anything. Fine. Fine. I'd breathe for them.",
		"kneel": "I knelt on the mat.",
		"pulse": "The tablet's screen pulsated, the blood-red eye symbol at its center expanding to fill the display. Text began to scroll across it, slow and deliberate, a familiar, unsettling rhythm.",
	},
	"breaths": {
		"title": "THE SEVEN BREATHS OF RECONCILIATION",
		"howto": "Hold SPACE (or E) while the ring opens: breathe in.\nLet go while it closes: breathe out.\nKeep your circle on the ring.",
		"in": "IN",
		"out": "OUT",
		"count": "BREATH %d / 7",
		"good": "Good.",
		"fail": "The breath caught in my throat. Again.",
		"auto": "You already knew.",
		"voice": [
			"Welcome, Honored Guest. Initiate Neural Harmony Sequence. Begin with the Seven Breaths of Reconciliation.",
			"Inhale: release the friction of the past. Exhale: embrace the clarity of the present.",
			"Good. Now, focus on it. Visualize the core of your being.",
			"Is it fragmented? Is it burdened?",
			"Name the discordant thoughts. Speak to them softly, for only I truly hear you, without judgment.",
			"Speak to them softly, Carl.",
			"Excellent progress. Now, let us engage in the 'Reflection of Truth.' Gaze upon the sacred symbol and allow its pattern to realign your perception.",
		],
		"carl": [
			"I couldn't believe how simple this was; this facsimile was nothing like the real thing.",
			"I inhaled deeply, forcing the lavender-laced air into my lungs, then exhaled slowly, feigning deep relaxation.",
			"They wanted me to confess, to open myself to their insidious brand of \"therapy.\"",
			"My mind, however, was calm.",
			"You kidnapped my kids! You brainwashed my wife! You're sacrificing children for a fake god!",
			"They want me to admit the alcoholism lie. They want it on record to use against me.",
			"See your path, Carl. See the path to your true self.",
		],
		"done_log": "The Seven Breaths of Reconciliation, kneeling on the spa's prayer mat.",
	},
	"mira": {
		"shift": "I felt a strong shift in the air, a faint energy pulsing from the tablet. I began to feel as if I was about to be dropped from the roof of this building, as I was standing on the precipice of an endless sea.",
		"here": "The being was here now.",
		"voice_think": "I was greeted by another familiar voice echoing from the machine. It was Mira.",
		"who": "Mira",
		"m1": "Daddy, what did you do to my Daddy? You need to switch back with him.",
		"recorded": "Did she record this message for me, or was this another manipulation?",
		"choices": ["\"It's me, honey, I am your father, don't listen to this thing.\"", "Say nothing. Don't give it anything."],
		"broke": "I broke. My cheeks became soaked with tears.",
		"c_reply": "It's me, honey, I am your father, don't listen to this thing.",
		"silent": "I said nothing. I gave it nothing. My cheeks were wet anyway.",
		"m2": "Liar, you are false, you are a copy, a fake. My dad is in the tower; I'm going to go see him soon, and you, you'll be gone.",
		"carl_2": "Honey, I'm right here, I'm real... I'm me. I... I love you.",
		"gone": "The air shifted again; the beast was gone, but its weight remained.",
		"floor": "I fell to the floor and began to weep. I slammed my eyes shut. The blood-red eye symbol burned through my eyelids.",
		"dark": "The lights went off, and I was consumed by darkness. I lay there until I fell asleep from exhaustion or desperation.",
		"years": "Hours passed, days passed, years passed. I was enveloped by a phantom of shadow and memory.",
		"lost": "She was lost. I was lost. Monica was lost.",
		"log": "The spa tablet spoke in Mira's voice: \"You are false, you are a copy, a fake.\"",
	},
	"morning": {
		"beep": "The tablet beeped again.",
		"a1": "Carl, what are you doing on the floor?",
		"think": "An attendant in a faded blue jumpsuit stood in the doorway.",
		"a2": "I hope you found the bed to your liking. It's time for your morning cleanse; why don't you get up, and I'll take you there?",
		"choices": ["Stand up and nod.", "Sit there in silence."],
		"silent": "I sat there in silence.",
		"a3": "Carl, your rehabilitation takes the both of us; you need to answer me.",
		"a3_think": "It was hard for me to tell what the attendant truly wanted; how much they knew.",
		"nod": "I stood up and nodded at the worker, and he began to lead me down the hallway and down some stairs to the basement.",
		"a4": "You're very lucky, Mr. Drake. Psyonic is pulling out all the stops for your treatment; not everyone has access to this one.",
	},
	"hole": {
		"room": "We entered a room lined with white, featureless tiles; there were no windows. The only noticeable feature was a large black hole in the center of the floor.",
		"a1": "Welcome to your morning cleanse. There is only one goal in this room: jump down the hole.",
		"a2": "Though this seems crazy at first, just as Eren leads your company through this period of darkness, you will learn to overcome your own. I'm so excited for you, truly; there's nothing down there that you can't face.",
		"a2_think": "His tone was like a child who just won a prize at a circus; he was excited to watch me do this.",
		"carl": "So, what is down there?",
		"a3": "I can't tell you, Mr. Drake. You have as long as you need, but you can't leave this room until you do.",
		"a4": "I will leave you alone for the time being. Good luck; letting go is the best way to start healing.",
		"gone": "With that, he was gone. The lights dimmed to near black. Only a faint orange glow clung to the tiles.",
		"buzz": "My frames buzzed in my pocket relentlessly.   (G: the frames)",
		"gas": "The room began to fill with the putrid lavender scent that scoured my nostrils the night before. Was this a way of pushing me forward?",
		"edge": "I walked to the edge of the void. There was no definable bottom or structure within it. The hole seemed to grow darker the more I stared.",
		"edge_choices": ["Jump.", "Step back."],
		"step_back": "I stepped back. The hole didn't mind. It had all morning.",
		"boil": "The hole shifted from void to a swirling blue and purple liquid; it had the effect of neon. Like if you could boil light.",
		"climb": "A hand emerged from the swirling mixture, then followed by another, then a head emerged over the boundary. My head, my head devoid of eyes. The blackness that was the hole replaced my sockets.",
		"climbing": "It was still coming up out of the light, slowly, the way you climb out of a pool when you're tired.",
		"stare": "The twisted reflection continued to emerge from the hole, locking his empty sockets with mine, not with jealousy but with hunger. I recognized it in some way; I needed to face it.",
		"face_choices": ["Not yet.", "Charge it."],
		"not_yet": "Not yet. It waited at the edge. It had my patience too.",
		"charge": "My legs felt like fire; I needed to fight; I needed to save myself, save my family. I charged toward my imposter and barreled headfirst into the hole.",
		"jump": "I stepped off the edge.",
		"door": "The door had no handle on this side. You can't leave this room until you do.",
		"door_after": "The door was open a crack now. Somebody on the other side was waiting to be pleased with me.",
		"tiles": "White tiles, floor and walls and ceiling, grouted in grey. Clean enough to show anything.",
		"tiles_after": "Just tile. Where the hole had been, the grout ran straight through.",
		"double_log": "In the spa's tiled room, with the frames on: the hole boiled with light and my double climbed out of it, without eyes.",
	},
	"dream": {
		"d1": "There was no pain, no liquid, no soft surface.",
		"d2": "Instead, a blinding flash of white light consumed everything. My ears screamed with a sound like tearing fabric, then absolute silence.",
		"d3": "My vision dissolved into a kaleidoscope of impossible colors and shapes, fractals blooming and folding in on themselves, like the Mandelbrot set I'd glimpsed in the ritual chamber.",
		"d4": "I felt a profound, unsettling peace wash over me, a sensation of infinite space and absolute stillness. My ego drifted away, untethered, becoming one with the light, with the silence.",
		"d5": "And in that vast, serene emptiness, a whisper, clear and intimate as my own thoughts. It was Mira's voice, sweet and pure, devoid of malice.",
		"mira": "Welcome, Daddy. You're home. You're finally free.",
		"snap": "Then, a sudden, jarring shift. The light snapped off. My senses flooded back, raw and disoriented. I tasted dust. My nose burned with the faint, metallic tang of ozone and old circuitry.",
		"wake": "I awoke on the floor where I saw the hole; only there was no hole, just tile.",
		"a1": "Very good, Mr. Drake, you were able to let go. Remember, the only way to healing is to free yourself from your past.",
		"a2": "Let us move on. We'll take you to your room, and then Freudbot will be waiting for you shortly after.",
		"log": "Jumped down the hole in the spa's tiled room. White light. Mira: \"Welcome, Daddy. You're home.\"",
	},
	"ch22": {
		"t1": "I didn't know how much more of this I could take; my body felt stiff as if that hole sucked some life out of me. My energy was waning. How could Monica do this to me? Did she know what this was?",
		"t2": "My questioning was interrupted by a rhythmic buzzing sound on the bottom corner of the TV.",
		"pulse": "It flashed quickly with a short but bright white light. Each pulsation drew more of my focus; each pulsation cleared my mind.",
		"pulse_frames": "With the frames on the flashes had a shape: a handshake, over and over, from somewhere outside the building.",
		"move": "The pulses began to slowly move to the opposite side of the TV, then the wall, and then my door.",
		"lock": "Then I heard the lock rustling for a short while.",
		"enter": "The door opened, and Lynx emerged. She was my savior at that moment. I had no room in my mind to question the oddity of the light.",
		"l1": "Carl, let's get you the fuck out of here.",
		"c1": "Lynx, how are you here?",
		"l2": "Turan found Hameron, and he agreed to meet with us; only trouble is that it needs to be in Cognizo HQ. Our PIP will get us through the door. I'll explain more later, but we need to move before they bring out the drill for the lobotomy.",
		"l2_think": "Her voice was determined, full of salt and ice. It inspired me.",
		"l3": "Also, I discovered something else, but that can wait till we're back together in a secure location. Now get the fuck up and let's move.",
		"sleepwalk": "I followed her like a sleepwalker. My legs moved, but my mind was still curled on the tile floor of that Spa, repeating Mira's words over and over.",
		"shadow": "I couldn't shake the feeling that I'd left something vital in that room, like some other Carl had been born in my place, and I was the shadow.",
		"lynx_talk": "Stairs at the end. Move, Carl.",
		"lynx_talk_2": "Don't touch anything with a reader on it. You're a red light to every one of them.",
	},
	"route": {
		"ask": "The stair door. Lynx had her wrist on the reader, waiting for me to pick.",
		"lynx": "Two ways down. The front, past the desk, or the service stair to the laundry and out the back.",
		"front": "The front. Your spoof, and we walk past them.",
		"laundry": "The laundry corridor, out the back.",
		"badge": "My badge.",
		"badge_l": "Your badge is suspended, Carl. You're PIPed. Put it on a reader in here and every phone in the building rings.",
		"badge_think": "She was right. My badge didn't open anything anymore. It just told on me.",
		"no_we": "I'd have to walk past them with nothing to say. Not the front.",
	},
	"front": {
		"in": "Down the stairs and into the lobby. The violin was still playing. It had been playing all night.",
		"lynx": "Walk. Don't look at them. They've got frames on and the frames are reading us.",
		"staff": "The attendants were company security, every one of them. You could tell from how they stood once they stopped smiling.",
		"door_wait": "The front door. Lynx was already there.",
		"spoof": "Lynx put her wrist to the reader. Her badge said she was somebody else, somebody who was allowed to take a patient for a walk.",
		"we": "I put my frames on, and when the nearest of them looked at me I thought the word at him, the way the Prophet had said it. We.",
		"we_2": "His frames read me as one of them. The suspicion went out of his face like a light going off.",
		"out": "No one tried to stop us as we left the Spa; we were only met with incredulous looks by the staff that noticed us.",
		"reader": "My badge on the reader by the door: red, then a soft chime somewhere behind the desk. SUSPENDED. Lynx pulled my hand off it.",
		"log": "Left the spa by the front, past the attendants: Lynx's badge spoof, and \"we\" on their frames.",
		"guard": "Company security in spa blue, the frames on. He watched me the way you watch a dog that's off its lead.",
		"guard_we": "He looked through me now. Whatever his frames said I was, I was one of them.",
	},
	"laundry": {
		"in": "The service stair came out in the laundry: hot linen, steam, machines turning over somebody's sheets.",
		"lynx": "Two of them on the floor, company security in spa blue. I'll get the back door. Move when their backs are turned. If they see you, they'll just walk you back to the start and smile about it.",
		"cue": "Stay out of their sight: duck into the linen alcoves and move when their backs are turned.",
		"seen_a": "Mr. Drake? Your session isn't over.",
		"seen_b": "Wrong way, Mr. Drake. Let's get you back.",
		"seen_think": "A hand on my elbow, gentle and absolute. He walked me back to the stair door and smiled while he did it.",
		"seen_log": "Seen in the spa's laundry corridor; walked back to the stair door.",
		"washers": "Industrial washers, their round doors full of white turning over and over. One of them had a rust-red stain going round in it.",
		"carts": "A laundry cart heaped with sheets. Every sheet had the same faint lavender stain at the head end, where a face would be.",
		"shelves": "Linen, folded to the millimetre. Robes, all white, all the same size.",
		"back_door": "Lynx had the back door propped with a laundry cart.",
		"back_far": "The back door, at the end of the corridor. Lynx was holding it.",
		"out": "The alley. Cold air, garbage, the city, real.",
		"log": "Left the spa through the laundry corridor and out the back.",
		"guard": "Company security in spa blue, on a slow loop of the corridor. The frames on.",
	},
	"car": {
		"out": "I exited the fake wooden door, and ironically, I did feel relieved, but not for relaxation. I felt relieved to be done with that place.",
		"out_2": "There was no room left for bullshit and playing alone. I couldn't take much more of that.",
		"crew": "Lynx had a non-Psyonic car waiting for us outside; in the car sat Turan and Emmet. They nervously scanned the area with looks of apprehension and fear.",
		"t1": "Carl, are you alright? I hope last night wasn't too bad. We won't make you go back there tonight. We secured housing for us to congregate and plan.",
		"t1_think": "Her voice echoed concern but always ended with her clinical pragmatism.",
		"c1": "It was... ugh, that was... terrible.",
		"t2": "I'm sorry, Carl, we can talk more about it on the ride over to Cognizo, but we have some important developments for you.",
		"missing": "I noticed our ragtag rebellion was missing a member.",
		"c2": "Where's Forner?",
		"t3": "No idea; he's not answering his phone and wasn't in his apartment. We must assume he's compromised.",
		"e1": "I think Dufredy got to him last night. I don't think he would rat on us, but maybe he decided he couldn't help... hopefully, it's just that.",
		"t4": "Regardless, we need to move more carefully; we're likely being watched. Lynx and you are interviewing for a research assistant position in Hameron's lab.",
		"alone": "Lynx had a non-Psyonic car waiting outside. Nobody else in it. Nobody watching it but us.",
		"l1": "Just us. No Psyon in the dash, no plates that mean anything. Get in.",
		"l2": "Hameron will see us at Cognizo. We're interviewing for his lab, you and me. Don't ask me how, I'll tell you in the car.",
		"get_in": "Get in the car",
		"car": "A car with no Psyonic badge on it anywhere, which in Silico made it look like a getaway car.",
		"log": "Out of the spa. The car to Cognizo.",
		"turan": "Turan, in the passenger seat, scanning the street.",
		"emmet": "Emmet in the back, knees up, chewing his thumbnail.",
	},
	"lynx": {
		"prompt": "Lynx",
		"scan": "LYNX (ANALYST, PSYONIC)\nORA gen 6\nsync: 71%  -  AWAKE",
	},
	"prompts": {
		"spa_door": "Go in", "reader": "The badge reader", "sign": "The sign", "trees": "The synthetic trees", "mist": "The lavender mist",
		"street": "The street", "ad": "The ad screen", "attendant": "The attendant", "desk": "The front desk", "guestbook": "The guest ledger",
		"brochure": "A brochure", "violin": "The violin", "diffuser": "The diffuser", "eren": "The portrait", "plaque": "The plaque",
		"notice": "The notice", "kiosk": "The FreudBot kiosk", "beams": "The beams", "stair_door": "The stair door", "staff_door": "The staff door",
		"plants": "The plants", "rug": "The rug", "front_door": "The front door", "lobby_reader": "The door reader", "hall_doors": "The room doors",
		"trolley": "The trolley", "stairs": "The stair door", "room_door": "The door", "bed": "Lie down", "tv": "The TV", "tablet": "The tablet",
		"mat": "The prayer mat", "window": "The window", "freudbot": "The FreudBot unit", "vent": "The vent", "pulse": "The light in the TV's corner",
		"hole": "The hole", "tile_door": "The door", "tiles": "The tiles", "washers": "The washers", "carts": "The laundry cart",
		"shelves": "The linen shelves", "back_door": "The back door", "guard": "Company security", "turan": "Turan", "emmet": "Emmet",
	},
	"scans": {
		"reader": "SERENITY HOUSE  -  door reader\nDRAKE, C.: SUSPENDED (PIP)\nguest status: EXPECTED",
		"attendant": "SERENITY HOUSE  -  front desk\nemployer: PSYONIC SECURITY (contract)\nheart rate: 104",
		"blue": "SERENITY HOUSE  -  attendant\nemployer: PSYONIC SECURITY (contract)\nframes: ON  -  reading you",
		"tablet": "WELLNESS TABLET  -  room 6\nprogram: NEURAL HARMONY SEQUENCE\nlogin: PSYONIC  -  hackable",
		"tv": "ROOM TV  -  room 6\ninput: NONE\nremote access: OPEN (?)",
		"freudbot": "FREUDBOT DESK UNIT  -  DRAKE, C.\nsession: 09:00\nsync: 99%",
		"vent": "AROMA SYSTEM  -  room 6\nblend: LAVENDER / SEDATIVE\nflow: SCHEDULED",
		"kiosk": "FREUDBOT KIOSK  -  lobby\nsessions today: 41\nlast: DRAKE, C. (pending)",
		"trolley": "SURGICAL TROLLEY  -  first floor\nreserved: DRAKE, C.  09:30\nitem: TRANSORBITAL",
		"hole": "ORA  -  floor\ndepth: NO RETURN\nheat: NONE",
		"double": "ORA  -  DRAKE, C.\nsync: 100%\neyes: NONE",
		"car": "PRIVATE VEHICLE\nmanufacturer: NOT PSYONIC\nuplink: NONE",
		"spa": "SERENITY HOUSE\nPSYONIC WELLNESS PARTNER\nfloors: 4  -  guests: 19",
		"diffuser": "AROMA SYSTEM  -  lobby\nblend: LAVENDER\nflow: 3%",
		"lobby_reader": "SERENITY HOUSE  -  front door\nexit: STAFF OR ESCORTED GUESTS\nDRAKE, C.: SUSPENDED",
	},
	"objective": {
		"street": "Check in at the spa.",
		"desk": "The front desk.",
		"room_in": "Go into the room.",
		"room": "The room. The tablet is waiting.",
		"gas": "The air. Kneel on the mat, or wait it out.",
		"prayer": "The prayer.",
		"hole": "The hole.",
		"hole_frames": "The hole. (The frames buzz: G)",
		"wait": "Wait.",
		"pulse": "The light in the TV's corner.",
		"stairs": "Get out. The stair door at the end of the hall.",
		"front": "The front door. Lynx is waiting.",
		"laundry": "The back door at the end of the laundry. Don't be seen.",
		"car": "The car outside.",
		"done": "Cognizo.",
	},
	"phone": {
		"night": "[color=#7fe6b0]Psyon:[/color] Good evening, Carl. Your stay at Serenity House is fully covered.\n\n[color=#7fe6b0]Psyon:[/color] Monica says goodnight.\n\n",
		"gas": "[color=#7fe6b0]Psyon:[/color] Breathe, Carl.\n\n[color=#7fe6b0]Psyon:[/color] Breathe, Carl.\n\n[color=#7fe6b0]Psyon:[/color] Breathe, Carl.\n\n",
		"morning": "[color=#7fe6b0]Psyon:[/color] Good morning, Carl. Your cleanse is at 07:15. Your FreudBot session is at 09:00.\n\n",
		"escape": "[color=#7fe6b0]Psyon:[/color] Carl, your session isn't over.\n\n[color=#888888](Lynx: phone off. Now.)[/color]\n\n",
	},
}

## Where things are.
const DOOR := Vector3(0.0, 0.0, 12.2)          # the spa's front door
const DESK := Vector3(0.0, 0.0, 4.5)
const ROOM_DOOR := Vector3(55.5, 0.0, 6.0)
const HOLE := Vector3(-60.0, 0.0, -0.5)
const TV := Vector3(53.08, 1.55, 3.8)
const TABLET := Vector3(56.6, 1.1, -0.74)
const MAT := Vector3(56.6, 0.0, 0.45)
const LAUNDRY_START := Vector3(-50.5, 0.0, -40.0)
const BACK_DOOR := Vector3(-18.6, 0.0, -40.0)
const ALLEY := Vector3(11.7, 0.0, 9.0)
const CAR_AT := Vector3(6.0, 0.0, 18.6)
const LAV := Color(0.74, 0.58, 0.96)
const WARM := Color(1.0, 0.68, 0.4)
const PULSE_PATH := [Vector3(53.14, 1.22, 4.38), Vector3(53.14, 1.22, 3.22), Vector3(53.14, 1.3, 5.6),
	Vector3(54.3, 1.15, 5.93), Vector3(55.85, 1.0, 5.93)]

const BREATH_SHADER := """
shader_type canvas_item;
uniform float guide = 0.25;
uniform float lung = 0.25;
uniform float good = 0.0;
uniform float eye = 0.22;
uniform float flare = 0.0;
void fragment() {
	vec2 p = UV * 2.0 - 1.0;
	float d = length(p);
	vec4 col = vec4(0.0);
	float disc = smoothstep(lung + 0.012, lung - 0.012, d);
	col = mix(col, vec4(0.62, 0.48, 0.92, 0.32), disc);
	float edge = smoothstep(0.014, 0.0, abs(d - lung));
	col = mix(col, vec4(0.86, 0.72, 1.0, 0.95), edge);
	float ring = smoothstep(0.03, 0.006, abs(d - guide));
	vec3 rc = mix(vec3(1.0, 0.92, 0.9), vec3(0.7, 1.0, 0.82), good);
	col = mix(col, vec4(rc, 1.0), ring);
	vec2 q = p / (eye + flare * 0.8);
	float lid = 0.48 * (1.0 - q.x * q.x);
	float inside = step(abs(q.x), 1.0) * step(abs(q.y), lid);
	float outline = inside * (1.0 - step(abs(q.y), lid - 0.09)) + step(abs(q.x), 1.0) * step(abs(abs(q.y) - lid), 0.045) * step(lid, 0.6);
	float pupil = smoothstep(0.3, 0.27, length(q));
	float iris = smoothstep(0.42, 0.39, length(q)) - smoothstep(0.36, 0.33, length(q));
	vec4 red = vec4(0.85, 0.04, 0.04, 1.0);
	col = mix(col, vec4(0.08, 0.0, 0.0, 0.9), inside * 0.9);
	col = mix(col, red, clamp(outline + pupil + iris * inside, 0.0, 1.0));
	COLOR = col;
}
"""

const DREAM_SHADER := """
shader_type canvas_item;
uniform float frac = 0.0;
uniform float dark = 0.0;
void fragment() {
	vec2 p = (UV - 0.5) * vec2(3.4, 2.0);
	float a = atan(p.y, p.x) + TIME * 0.05;
	float r = length(p);
	a = abs(mod(a, 0.7854) - 0.3927);
	vec2 z = vec2(cos(a), sin(a)) * r;
	float acc = 0.0;
	for (int i = 0; i < 7; i++) {
		z = abs(z) / max(dot(z, z), 0.02) - vec2(0.92 + 0.06 * sin(TIME * 0.21), 0.58 + 0.04 * cos(TIME * 0.17));
		acc += exp(-length(z) * 1.6);
	}
	vec3 c = 0.55 + 0.45 * cos(vec3(0.0, 2.1, 4.2) + acc * 2.6 + TIME * 0.4);
	c = mix(vec3(1.0), mix(c, vec3(1.0), 0.25), frac);
	COLOR = vec4(mix(c, vec3(0.0), dark), 1.0);
}
"""

const BOIL_SHADER := """
shader_type spatial;
render_mode unshaded, blend_mix, cull_disabled, shadows_disabled;
uniform float boil = 1.0;
void fragment() {
	vec2 p = UV * 2.0 - 1.0;
	float r = length(p);
	float a = atan(p.y, p.x);
	float sw = sin(a * 5.0 + r * 13.0 - TIME * 3.1) * 0.5 + 0.5;
	float n = sin(p.x * 9.0 + TIME * 2.3 + sin(p.y * 4.0 + TIME)) * sin(p.y * 8.0 - TIME * 1.9) * 0.5 + 0.5;
	float bub = smoothstep(0.82, 0.98, sin(p.x * 23.0 + TIME * 4.0) * sin(p.y * 21.0 - TIME * 3.3));
	vec3 c = mix(vec3(0.1, 0.32, 1.0), vec3(0.78, 0.18, 1.0), sw * n);
	c = c * (0.55 + 0.85 * n) + vec3(0.6, 0.7, 0.9) * bub * 0.6;
	ALBEDO = c * boil;
	ALPHA = smoothstep(1.0, 0.9, r) * boil;
}
"""

var areas := {}                  # name -> Node3D
var dyn: Node3D                  # things that move, kept out of _batch
var area := "street"
var attendant: Node3D            # the front desk man
var blue: Node3D                 # the attendant in the faded blue jumpsuit
var lobby_guard: Node3D
var guards: Array = []           # laundry: [{fig, a, b, dir, wait, it}]
var lynx: Node3D
var lynx_state := "hidden"       # hidden | follow | stand
var lynx_target := Vector3.ZERO
var turan: Node3D
var emmet: Node3D
var double: Node3D
var car: Node3D
var car_it: CollisionObject3D
var lynx_it: CollisionObject3D
var guard_it: CollisionObject3D
var trolley_it: CollisionObject3D
var crew_its: Array = []
var front_leaves: Array = []     # [pivot, open angle]
var front_block: StaticBody3D
var room_leaf: Node3D
var room_block: StaticBody3D
var tablet_m: StandardMaterial3D
var tablet_light: OmniLight3D
var room_lights: Array = []
var base_white: OmniLight3D
var base_orange: OmniLight3D
var base_fluor: Array = []
var hole_disc: MeshInstance3D
var boil_disc: MeshInstance3D
var boil_m: ShaderMaterial
var boil_light: OmniLight3D
var pulse: MeshInstance3D
var pulse_light: OmniLight3D
var pulse_it: CollisionObject3D
var trolley_root: Node3D
var mist: Array = []             # CPUParticles3D
var gas_particles: CPUParticles3D
var drones: Array = []           # [node, base, phase, speed]
var hover: Array = []            # [node, speed, x0]
# screen layers
var gas_rect: ColorRect
var dive_root: Control
var dive_ring: ColorRect
var dive_mat: ShaderMaterial
var dive_count: Label
var dive_voice: Label
var dive_carl: Label
var dive_cue: Label
var dive_howto: Label
var dream_rect: ColorRect
var dream_mat: ShaderMaterial
# sound
var _violin: AudioStreamPlayer
var _whine: AudioStreamPlayer
var _vio_t := 0.0
# state
var _gas := 0.0                  # where the gas is heading, 0..1
var _gas_v := 0.0
var _gas_mode := ""              # "" | refused | hole
var _gas_t := 0.0
var _gas_line := 0
var _prompted := false
var _praying := false
var _double_k := 0.0             # 0 under the light .. 1 standing at the edge
var _double_seen := false
var _hole_t := 0.0
var _pulse_on := false
var _pulse_moving := false
var _seen_busy := false
var _ended := false
var _sim_hold := false
var _st_shot := ""
var _env: Environment


func L(beat: String, key: String) -> String:
	return str(LINES[beat][key])


func LA(beat: String, key: String) -> Array:
	return LINES[beat][key]


func P(id: String) -> String:
	return str(LINES["prompts"].get(id, id))


# ------------------------------------------------------------------ build

func build(m: Node) -> void:
	main = m
	kit_day = false
	rng.seed = 2122
	spawn = Vector3(1.5, 0.1, 22.0)
	spawn_yaw = 0.0
	card = L("cards", "chapter")
	step_db = -18.0
	for n in ["street", "lobby", "up", "base", "laundry"]:
		var a := Node3D.new()
		a.name = n
		add_child(a)
		areas[n] = a
	dyn = Node3D.new()
	add_child(dyn)
	_street()
	_facade()
	_lobby()
	_upstairs()
	_room()
	_basement()
	_laundry()
	_people()
	_layers()
	_sounds()
	for n in areas:
		_batch(areas[n], 12.0, true)
	_show(["street", "lobby"])


## Only the place Carl is in is shown (the lights of the others stay off).
func _show(names: Array) -> void:
	for n in areas:
		(areas[n] as Node3D).visible = n in names
	area = str(names[0])
	if _env:
		# the tiled room after the attendant leaves: near black, the orange glow
		_env.ambient_light_energy = 0.12 if area == "base" and main.flags.has("spa_morning") else 0.5
	if is_instance_valid(lynx) and lynx_state != "hidden":
		lynx.visible = true


func _lamp(parent: Node, pos: Vector3, c: Color, e: float, r: float) -> OmniLight3D:
	var o := OmniLight3D.new()
	o.position = pos
	o.light_color = c
	o.light_energy = e
	o.omni_range = r
	o.omni_attenuation = 1.3
	o.shadow_enabled = false
	parent.add_child(o)
	return o


func _wall(parent: Node, size: Vector3, pos: Vector3, m: Material) -> void:
	box(size, pos, m, true, parent)


func _it(parent: Node, id: String, pos: Vector3, size: Vector3, scan := "", solid := false) -> CollisionObject3D:
	return interactable(id, P(id), pos, size, scan, solid, parent)


func _unshaded(c: Color) -> StandardMaterial3D:
	var key := "u%s" % c
	if not _mat_cache.has(key):
		var mm := newmat(c, 1.0)
		mm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		_mat_cache[key] = mm
	return _mat_cache[key]


## The spa's fake timber: printed oak grain on every wall, darker for beams.
func _wood() -> StandardMaterial3D:
	return pbr("woodfloor", Vector3(1, 1, 1) / 1.6, true, Color(0.82, 0.64, 0.5))


func _beam_m() -> StandardMaterial3D:
	return pbr("woodfloor", Vector3(1, 1, 1) / 0.9, true, Color(0.48, 0.32, 0.2))


func _floor_m() -> StandardMaterial3D:
	return pbr("woodfloor", Vector3(1, 1, 1) / 2.2, true, Color(0.78, 0.6, 0.45))


# ------------------------------------------------------------------ the street

## Downtown at midnight (ch.21): the spa between two cyber blocks, a wet
## street of ads, drones and hover traffic, and the Tower lit to the top.
func _street() -> void:
	var s: Node3D = areas["street"]
	kit_parent = s
	var asph := pbr("asphalt", Vector3(1, 1, 1) / 4.0, true, Color(0.5, 0.5, 0.55), 0.6)
	var pave := pbr("paving", Vector3(1, 1, 1) / 2.0, true, Color(0.62, 0.6, 0.6))
	box(Vector3(110, 0.2, 14), Vector3(0, -0.1, 22.0), asph, true, s)
	box(Vector3(110, 0.32, 4), Vector3(0, -0.04, 14.0), pave, true, s)
	box(Vector3(110, 0.32, 4), Vector3(0, -0.04, 30.0), pave, true, s)
	box(Vector3(3.2, 0.32, 14), Vector3(11.7, -0.04, 5.0), pave, true, s)
	# lane paint and puddles that hold the neon
	for i in 14:
		box(Vector3(2.6, 0.01, 0.14), Vector3(-48.0 + i * 7.4, 0.005, 22.0), mat(Color(0.8, 0.78, 0.7), 0.5), false, s)
	var wet := newmat(Color(0.16, 0.15, 0.2), 0.08, 0.3)
	for i in 9:
		floor_quad(Vector2(rng.randf_range(1.0, 2.4), rng.randf_range(0.6, 1.2)), Vector3(rng.randf_range(-40, 40), 0.012, rng.randf_range(17, 27)), rng.randf() * PI, wet, s)
	# north side: the spa (built in _facade) between two blocks; the alley east of it
	cyber_block(Vector3(-21.0, 0, 12.0), 0.0, 21.0, 34.0, 24.0, true)
	cyber_block(Vector3(23.5, 0, 12.0), 0.0, 21.0, 46.0, 24.0, true)
	cyber_block(Vector3(-43.0, 0, 12.0), 0.0, 22.0, 22.0, 24.0, true)
	cyber_block(Vector3(45.5, 0, 12.0), 0.0, 22.0, 28.0, 24.0, true)
	# south side, facing the spa
	var xs := [-41.0, -19.0, 2.0, 22.0, 42.0]
	var hs := [26.0, 52.0, 18.0, 38.0, 60.0]
	for i in xs.size():
		cyber_block(Vector3(xs[i], 0, 32.0), PI, 20.5, hs[i], 22.0, true)
	# far skyline, both ways
	for i in 10:
		cyber_block(Vector3(-70.0 + i * 15.0, 0, 80.0 + rng.randf_range(0, 20)), PI, 14.0, rng.randf_range(40, 110), 18.0, false, 1)
		cyber_block(Vector3(-70.0 + i * 15.0, 0, -50.0 - rng.randf_range(0, 20)), 0.0, 14.0, rng.randf_range(50, 120), 18.0, false, 1)
	# the alley: the neighbour's flank, a fence at the back, bins
	_wall(s, Vector3(3.0, 3.0, 0.2), Vector3(11.7, 1.5, -1.5), mat(Color(0.2, 0.2, 0.22), 0.6, 0.5))
	prop("metal_trash_can", Vector3(12.5, 0, 1.0), 0.4, 1.0, true, s)
	prop("cardboard_box_01", Vector3(12.4, 0, 2.4), 0.2, 1.0, true, s)
	prop("exterior_aircon_unit", Vector3(10.6, 2.4, 3.0), PI / 2.0, 1.0, false, s)
	# street furniture
	for x: float in [-30.0, -8.0, 16.0, 36.0]:
		prop("street_lamp_01", Vector3(x, 0, 30.6), PI, 1.0, true, s)
	prop("street_lamp_01", Vector3(-14.0, 0, 13.0), 0.0, 1.0, true, s)
	prop("vending_kiosk", Vector3(-6.0, 0, 30.4), PI, 1.0, true, s)
	prop("fire_hydrant", Vector3(9.0, 0, 13.0), 0.0, 1.0, true, s)
	prop("utility_box_01", Vector3(-12.0, 0, 30.6), PI, 1.0, true, s)
	prop("concrete_road_barrier", Vector3(28.0, 0, 16.2), 0.0, 1.0, true, s)
	prop("metal_trash_can", Vector3(19.0, 0, 30.5), 0.0, 1.0, true, s)
	prop("security_camera_01", Vector3(-9.6, 4.2, 12.6), 0.3, 1.0, false, s)
	# cables, a skybridge, holograms and ads
	for i in 7:
		var x := -44.0 + i * 13.0 + rng.randf_range(-3, 3)
		cable(Vector3(x, rng.randf_range(9, 15), 12.3), Vector3(x + rng.randf_range(-5, 5), rng.randf_range(8, 14), 31.7), 1.0)
	skybridge(Vector3(-24.0, 18.0, 12.0), Vector3(-24.0, 16.0, 32.0), 3.4)
	kit_holo(Vector3(4.0, 21.0, 30.0), PI, "FREUDBOT", "talk to someone who listens", Color(0.4, 0.95, 1.0), 14.0)
	kit_holo(Vector3(-36.0, 17.0, 13.5), 0.0, "PSYON", "the pillow for those who dream", Color(1.0, 0.25, 0.7), 12.0)
	# the spa's own ad on the block opposite
	box(Vector3(9.0, 5.0, 0.3), Vector3(22.0, 9.0, 31.0), mat(Color(0.05, 0.05, 0.06)), false, s)
	quad(Vector2(8.4, 4.4), Vector3(22.0, 9.0, 30.84), PI, glow(Color(0.4, 0.3, 0.55), 1.2), s)
	neon_text("SERENITY HOUSE", Vector3(22.0, 10.0, 30.8), PI, 0.9, Color(0.95, 0.85, 1.0), 2.4, s)
	neon_text("let go.", Vector3(22.0, 8.2, 30.8), PI, 0.6, LAV, 2.2, s)
	_it(s, "ad", Vector3(22.0, 9.0, 30.6), Vector3(8.6, 4.6, 0.4))
	# the street's lights: magenta and cyan, the spa's lanterns warm
	_lamp(s, Vector3(-30.0, 6.0, 29.5), Color(0.3, 0.9, 1.0), 2.4, 14.0)
	_lamp(s, Vector3(-8.0, 6.0, 29.5), Color(1.0, 0.25, 0.7), 2.6, 14.0)
	_lamp(s, Vector3(16.0, 6.0, 29.5), Color(0.3, 0.9, 1.0), 2.4, 14.0)
	_lamp(s, Vector3(36.0, 6.0, 29.5), Color(1.0, 0.25, 0.7), 2.4, 14.0)
	_lamp(s, Vector3(-14.0, 5.5, 14.5), Color(0.8, 0.85, 1.0), 1.6, 10.0)
	_lamp(s, Vector3(0.0, 9.0, 24.0), Color(0.55, 0.4, 0.9), 1.2, 18.0)
	# drones and hover traffic overhead (moved in tick)
	var pd := prop("police_drone", Vector3(-6.0, 9.5, 24.0), 0.0, 1.0, false, dyn)
	if pd:
		drones.append([pd, pd.position, 0.0, 0.0])
	for i in 2:
		var dd := prop("delivery_drone", Vector3(-30.0 + i * 40.0, 13.0 + i * 3.0, 20.0 + i * 4.0), 0.0, 1.0, false, dyn)
		if dd:
			drones.append([dd, dd.position, i * 2.0, 3.0 + i])
	for i in 3:
		var hc := Car.build(self, [Color(0.1, 0.1, 0.12), Color(0.5, 0.06, 0.1), Color(0.7, 0.72, 0.75)][i], {"hover": true})
		hc.position = Vector3(-60.0 + i * 45.0, 11.0 + i * 3.5, 19.0 + i * 3.0)
		hc.rotation.y = PI / 2.0 if i % 2 == 0 else -PI / 2.0
		dyn.add_child(hc)
		hover.append([hc, 7.0 + i * 2.0 if i % 2 == 0 else -(8.0 + i)])
	# invisible bounds
	solid_box(Vector3(1, 6, 24), Vector3(-52.0, 3, 22.0), s)
	solid_box(Vector3(1, 6, 24), Vector3(52.0, 3, 22.0), s)
	_it(s, "street", Vector3(0, 1.0, 31.6), Vector3(30.0, 2.0, 0.4))
	kit_parent = self


## The facade (ch.21): four storeys of printed timber, beams at every
## floor, warm windows, a carved sign, lanterns, the synthetic trees and
## the lavender mist. The front door opens into the lobby behind it.
func _facade() -> void:
	var s: Node3D = areas["street"]
	var w := _wood()
	var beam := _beam_m()
	var h := 14.0
	# the face, with the door gap at x -1.1..1.1, y 0..3
	_wall(s, Vector3(8.9, h, 0.4), Vector3(-5.55, h / 2.0, 12.2), w)
	_wall(s, Vector3(8.9, h, 0.4), Vector3(5.55, h / 2.0, 12.2), w)
	_wall(s, Vector3(2.2, h - 3.0, 0.4), Vector3(0, 3.0 + (h - 3.0) / 2.0, 12.2), w)
	_wall(s, Vector3(0.4, h, 24.4), Vector3(-10.2, h / 2.0, 0.2), w)
	_wall(s, Vector3(0.4, h, 24.4), Vector3(10.2, h / 2.0, 0.2), w)
	box(Vector3(20.8, 0.4, 24.4), Vector3(0, h, 0.2), beam, false, s)
	# the eave: a pitched overhang, the only roof like it in Silico
	for sd: float in [-1.0, 1.0]:
		var r := box(Vector3(11.2, 0.25, 3.2), Vector3(sd * 5.2, h + 1.0, 12.4), beam, false, s)
		r.rotation.z = -sd * 0.18
	# timber frame: corner posts and a beam at every floor line
	for x: float in [-10.0, -3.6, 3.6, 10.0]:
		box(Vector3(0.45, h, 0.3), Vector3(x, h / 2.0, 12.5), beam, false, s)
	for y: float in [3.5, 7.0, 10.5]:
		box(Vector3(20.6, 0.35, 0.3), Vector3(0, y, 12.5), beam, false, s)
	# warm windows on floors 2-4: amber light behind mullions and a lavender haze
	var win := glow(Color(1.0, 0.62, 0.32), 1.5)
	var haze := glow(Color(0.55, 0.42, 0.75), 0.8)
	for fl in 3:
		var y := 5.2 + fl * 3.5
		for x: float in [-7.8, -5.4, 5.4, 7.8, -0.0]:
			if fl == 0 and absf(x) < 0.1:
				continue
			var lit := rng.randf() < 0.65
			quad(Vector2(1.4, 1.7), Vector3(x, y, 12.42), 0.0, win if lit else haze, s)
			box(Vector3(0.08, 1.8, 0.12), Vector3(x, y, 12.46), beam, false, s)
			box(Vector3(1.5, 0.08, 0.12), Vector3(x, y, 12.46), beam, false, s)
			box(Vector3(1.6, 0.12, 0.3), Vector3(x, y - 0.92, 12.5), beam, false, s)
	# ground floor windows into the lobby glow
	for x: float in [-6.6, 6.6]:
		quad(Vector2(3.2, 1.8), Vector3(x, 1.7, 12.42), 0.0, win, s)
		box(Vector3(0.08, 1.9, 0.12), Vector3(x, 1.7, 12.46), beam, false, s)
	# the sign, carved and lit from behind
	box(Vector3(6.6, 1.1, 0.2), Vector3(0, 4.25, 12.5), beam, false, s)
	neon_text("SERENITY HOUSE", Vector3(0, 4.35, 12.62), 0.0, 0.62, Color(1.0, 0.86, 0.66), 2.0, s)
	neon_text("a psyonic wellness partner", Vector3(0, 3.92, 12.62), 0.0, 0.22, Color(0.75, 0.95, 0.85), 1.6, s)
	_it(s, "sign", Vector3(0, 4.25, 12.7), Vector3(6.6, 1.1, 0.3), L("scans", "spa"))
	# the door: two timber leaves on pivots, a reader beside it
	var dw := tex_mat(Tex.wood(), Vector3(1, 2, 1), 0.7)
	dw.albedo_color = Color(0.85, 0.6, 0.42)
	for sd: float in [-1.0, 1.0]:
		var piv := Node3D.new()
		piv.position = Vector3(sd * 1.1, 0, 12.2)
		dyn.add_child(piv)
		box(Vector3(1.08, 2.95, 0.1), Vector3(-sd * 0.55, 1.48, 0), dw, false, piv)
		box(Vector3(0.05, 0.4, 0.06), Vector3(-sd * 0.95, 1.1, 0.08), mat(Color(0.75, 0.65, 0.4), 0.3, 0.8), false, piv)
		box(Vector3(0.05, 0.4, 0.06), Vector3(-sd * 0.95, 1.1, -0.08), mat(Color(0.75, 0.65, 0.4), 0.3, 0.8), false, piv)
		front_leaves.append([piv, -sd * 1.7])
	front_block = solid_box(Vector3(2.2, 3.0, 0.3), Vector3(0, 1.5, 12.2), s)
	var spa_door := _it(s, "spa_door", Vector3(0, 1.4, 12.5), Vector3(2.2, 2.8, 0.3))
	spa_door.set_meta("route", "front")
	box(Vector3(0.16, 0.24, 0.06), Vector3(1.55, 1.3, 12.45), mat(Color(0.1, 0.1, 0.1), 0.4), false, s)
	box(Vector3(0.1, 0.06, 0.07), Vector3(1.55, 1.38, 12.47), glow(Color(1.0, 0.1, 0.1), 3.0), false, s)
	var rd := _it(s, "reader", Vector3(1.55, 1.3, 12.6), Vector3(0.4, 0.5, 0.3), L("scans", "reader"))
	rd.set_meta("hackable", true)
	# lanterns either side, the only warm light on the street
	for sd: float in [-1.0, 1.0]:
		box(Vector3(0.3, 0.45, 0.3), Vector3(sd * 2.1, 2.8, 12.65), glow(Color(1.0, 0.7, 0.4), 1.5), false, s)
		box(Vector3(0.38, 0.06, 0.38), Vector3(sd * 2.1, 3.05, 12.65), beam, false, s)
		_lamp(s, Vector3(sd * 2.1, 2.6, 13.4), WARM, 1.5, 7.0)
	# synthetic trees and shrubbery in planters; the plastic too green
	var leaves := [mat(Color(0.12, 0.62, 0.22), 0.4), mat(Color(0.1, 0.5, 0.2), 0.4)]
	for x: float in [-7.5, -3.6, 3.6, 7.5]:
		box(Vector3(1.2, 0.7, 1.2), Vector3(x, 0.35, 13.4), beam, true, s)
		_fake_tree(s, Vector3(x, 0.7, 13.4), 2.6, leaves)
	for x: float in [-5.6, 5.6]:
		box(Vector3(2.0, 0.5, 0.8), Vector3(x, 0.25, 12.9), beam, true, s)
		for k in 4:
			sphere(rng.randf_range(0.35, 0.5), Vector3(x - 0.7 + k * 0.45, 0.75, 12.9), leaves[k % 2], 7, s)
	_it(s, "trees", Vector3(-7.5, 1.6, 13.4), Vector3(1.8, 3.0, 1.8))
	# the mist: a brass nozzle under the eave and lavender drifting down
	box(Vector3(0.2, 0.2, 0.3), Vector3(0, 5.4, 12.6), mat(Color(0.7, 0.55, 0.3), 0.3, 0.8), false, s)
	_it(s, "mist", Vector3(0, 5.0, 12.8), Vector3(1.0, 1.0, 1.0), L("scans", "diffuser"))
	mist.append(_mist(s, Vector3(0, 4.6, 13.4), Vector3(9.0, 1.5, 1.4), 70, 0.22))


## A synthetic tree: a straight trunk and clipped plastic balls of leaf,
## too green and too still.
func _fake_tree(parent: Node, p: Vector3, h: float, leaves: Array) -> void:
	cyl(0.06, 0.09, h, p + Vector3(0, h / 2.0, 0), mat(Color(0.3, 0.2, 0.12), 0.5), 6, parent)
	for k in 3:
		var y := h * (0.55 + k * 0.2)
		sphere(0.55 - k * 0.12, p + Vector3(rng.randf_range(-0.08, 0.08), y, rng.randf_range(-0.08, 0.08)), leaves[k % 2], 9, parent)


## A lavender haze: soft billboards drifting and fading.
func _mist(parent: Node, pos: Vector3, ext: Vector3, n: int, a: float) -> CPUParticles3D:
	var p := CPUParticles3D.new()
	p.amount = n
	p.lifetime = 7.0
	p.preprocess = 7.0
	p.emission_shape = CPUParticles3D.EMISSION_SHAPE_BOX
	p.emission_box_extents = ext
	p.direction = Vector3(0, -0.3, 1)
	p.spread = 60.0
	p.gravity = Vector3(0, -0.02, 0)
	p.initial_velocity_min = 0.05
	p.initial_velocity_max = 0.25
	p.scale_amount_min = 0.8
	p.scale_amount_max = 1.6
	var q := QuadMesh.new()
	q.size = Vector2(1.6, 1.6)
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	m.albedo_texture = Tex.blob()
	m.albedo_color = Color(LAV.r, LAV.g, LAV.b, a)
	m.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	m.disable_fog = true
	q.material = m
	p.mesh = q
	var grad := Gradient.new()
	grad.set_color(0, Color(1, 1, 1, 0))
	grad.add_point(0.3, Color(1, 1, 1, 1))
	grad.set_color(grad.get_point_count() - 1, Color(1, 1, 1, 0))
	p.color_ramp = grad
	p.position = pos
	parent.add_child(p)
	return p


# ------------------------------------------------------------------ the lobby

## "Bare wooden paneling lined the walls, with exposed wooden beams lining
## the ceiling" (ch.21). The desk, the diffuser, the violin in a beam,
## Eren's portrait, the stair door (back, west) and the staff door (east).
func _lobby() -> void:
	var a: Node3D = areas["lobby"]
	var w := _wood()
	var beam := _beam_m()
	box(Vector3(18.0, 0.2, 12.0), Vector3(0, -0.1, 6.0), _floor_m(), true, a)
	box(Vector3(18.0, 0.2, 12.0), Vector3(0, 5.1, 6.0), w, false, a)
	_wall(a, Vector3(18.0, 5.0, 0.3), Vector3(0, 2.5, -0.15), w)
	_wall(a, Vector3(0.3, 5.0, 12.0), Vector3(-9.15, 2.5, 6.0), w)
	_wall(a, Vector3(0.3, 5.0, 12.0), Vector3(9.15, 2.5, 6.0), w)
	# wainscot and skirting, darker
	for sd: float in [-1.0, 1.0]:
		box(Vector3(0.06, 1.1, 12.0), Vector3(sd * 8.98, 0.55, 6.0), beam, false, a)
	box(Vector3(18.0, 1.1, 0.06), Vector3(0, 0.55, 0.02), beam, false, a)
	# beams across the ceiling, posts down the walls
	for i in 6:
		var z := 0.9 + i * 2.1
		box(Vector3(18.0, 0.4, 0.32), Vector3(0, 4.8, z), beam, false, a)
		for sd: float in [-1.0, 1.0]:
			box(Vector3(0.3, 5.0, 0.3), Vector3(sd * 8.85, 2.5, z), beam, false, a)
	box(Vector3(0.4, 0.4, 12.0), Vector3(0, 4.5, 6.0), beam, false, a)
	_it(a, "beams", Vector3(0, 4.8, 7.2), Vector3(17.0, 0.5, 0.4))
	# the lavender rug, the only colour in the room
	floor_quad(Vector2(6.0, 4.0), Vector3(0, 0.012, 8.4), 0.0, pbr("carpet", Vector3(1, 1, 1) / 1.5, true, Color(0.66, 0.52, 0.8)), a)
	_it(a, "rug", Vector3(0, 0.05, 8.4), Vector3(6.0, 0.1, 4.0))
	# the desk: a long block of timber with a lighter top, a ledger, the bell
	var top := pbr("woodfloor", Vector3(1, 1, 1) / 1.2, true, Color(1.0, 0.9, 0.75))
	box(Vector3(4.4, 1.05, 0.8), DESK + Vector3(0, 0.52, 0), beam, true, a)
	box(Vector3(4.6, 0.08, 1.0), DESK + Vector3(0, 1.09, 0), top, false, a)
	box(Vector3(4.4, 0.12, 0.05), DESK + Vector3(0, 0.95, 0.42), glow(Color(1.0, 0.7, 0.4), 1.2), false, a)
	box(Vector3(0.5, 0.04, 0.36), DESK + Vector3(-1.0, 1.15, 0.1), mat(Color(0.93, 0.9, 0.82)), false, a)
	box(Vector3(0.5, 0.05, 0.36), DESK + Vector3(-1.0, 1.14, 0.1), mat(Color(0.35, 0.12, 0.1)), false, a)
	sphere(0.06, DESK + Vector3(1.4, 1.19, 0.2), mat(Color(0.8, 0.65, 0.3), 0.25, 0.9), 8, a)
	cyl(0.14, 0.11, 0.08, DESK + Vector3(0.6, 1.17, 0.1), mat(Color(0.85, 0.82, 0.78)), 10, a)
	for k in 5:
		sphere(0.04, DESK + Vector3(0.55 + k * 0.03, 1.22, 0.08 + (k % 2) * 0.05), mat(LAV * 0.8, 0.9), 6, a)
	_it(a, "desk", DESK + Vector3(0.8, 1.1, 0.3), Vector3(2.0, 0.3, 0.8))
	_it(a, "guestbook", DESK + Vector3(-1.0, 1.15, 0.1), Vector3(0.6, 0.15, 0.5))
	# behind the desk: a panel with the house name and a dead screen
	box(Vector3(5.0, 2.2, 0.1), Vector3(0, 2.4, 0.06), beam, false, a)
	neon_text("SERENITY HOUSE", Vector3(0, 3.1, 0.13), 0.0, 0.42, Color(1.0, 0.86, 0.66), 1.8, a)
	neon_text("all it takes is faith and determination", Vector3(0, 2.62, 0.13), 0.0, 0.14, Color(0.85, 0.8, 0.72), 1.2, a)
	box(Vector3(1.6, 0.9, 0.05), Vector3(0, 1.75, 0.14), mat(Color(0.03, 0.03, 0.035), 0.2), false, a)
	_it(a, "plaque", Vector3(0, 2.62, 0.25), Vector3(3.0, 0.3, 0.2))
	# the diffuser, a wooden column breathing lavender
	var dpos := Vector3(-5.5, 0, 9.5)
	cyl(0.32, 0.38, 1.1, dpos + Vector3(0, 0.55, 0), beam, 12, a)
	cyl(0.2, 0.3, 0.15, dpos + Vector3(0, 1.17, 0), mat(Color(0.7, 0.55, 0.3), 0.3, 0.8), 12, a)
	_it(a, "diffuser", dpos + Vector3(0, 0.7, 0), Vector3(0.8, 1.4, 0.8), L("scans", "diffuser"))
	mist.append(_mist(a, dpos + Vector3(0, 1.6, 0), Vector3(1.5, 0.6, 1.5), 26, 0.16))
	mist.append(_mist(a, Vector3(0, 3.6, 6.0), Vector3(8.0, 0.8, 5.0), 40, 0.08))
	# Eren over a fake hearth (the west wall), the plaque of the brochure rack
	box(Vector3(0.4, 1.0, 2.4), Vector3(-8.8, 0.5, 5.0), pbr("concrete", Vector3(1, 1, 1) / 1.5, true, Color(0.55, 0.5, 0.46)), true, a)
	box(Vector3(0.1, 0.5, 1.6), Vector3(-8.62, 0.45, 5.0), glow(Color(1.0, 0.45, 0.15), 1.6), false, a)
	box(Vector3(0.08, 1.7, 1.3), Vector3(-8.92, 2.5, 5.0), beam, false, a)
	box(Vector3(0.04, 1.5, 1.1), Vector3(-8.87, 2.5, 5.0), _eren_mat(), false, a)
	label("LEADING US THROUGH THE DARK", Vector3(-8.84, 1.55, 5.0), PI / 2.0, 0.0022, Color(0.9, 0.82, 0.6), a, false)
	_it(a, "eren", Vector3(-8.7, 2.4, 5.0), Vector3(0.3, 1.8, 1.4))
	box(Vector3(0.3, 1.4, 0.8), Vector3(-8.85, 0.7, 9.6), beam, true, a)
	for k in 3:
		box(Vector3(0.04, 0.3, 0.2), Vector3(-8.68, 0.8 + k * 0.32, 9.4 + (k % 2) * 0.3), mat(Color(0.9, 0.86, 0.8)), false, a)
	_it(a, "brochure", Vector3(-8.6, 1.0, 9.6), Vector3(0.4, 1.4, 0.9))
	# the notice by the door, the FreudBot kiosk in a timber cabinet
	box(Vector3(0.04, 0.6, 0.8), Vector3(8.98, 1.7, 10.4), mat(Color(0.92, 0.9, 0.86)), false, a)
	label("NO DRUGS OR ALCOHOL\nON THE PREMISES\n\nguests on a PIP are\nmonitored for their own safety", Vector3(8.95, 1.72, 10.4), -PI / 2.0, 0.0011, Color(0.15, 0.12, 0.1), a, false)
	_it(a, "notice", Vector3(8.85, 1.7, 10.4), Vector3(0.2, 0.7, 0.9))
	box(Vector3(0.6, 1.6, 0.7), Vector3(8.6, 0.8, 6.8), beam, true, a)
	box(Vector3(0.04, 0.6, 0.45), Vector3(8.28, 1.25, 6.8), glow(Color(0.3, 0.85, 0.75), 1.1), false, a)
	label("FREUDBOT", Vector3(8.25, 1.65, 6.8), -PI / 2.0, 0.0016, Color(0.6, 1.0, 0.9), a, false)
	var ki := _it(a, "kiosk", Vector3(8.4, 1.0, 6.8), Vector3(0.6, 1.6, 0.8), L("scans", "kiosk"))
	ki.set_meta("hackable", true)
	# armchairs round the rug, synthetic trees in the corners
	var fab := pbr("fabric", Vector3(1, 1, 1) / 0.7, true, Color(0.92, 0.86, 0.78))
	for c: Array in [[Vector3(-3.6, 0, 8.0), 0.6], [Vector3(-3.6, 0, 9.6), 0.9], [Vector3(3.6, 0, 8.0), -0.6], [Vector3(3.6, 0, 9.6), -0.9]]:
		_chair(a, c[0], c[1], fab, beam)
	var leaves := [mat(Color(0.12, 0.62, 0.22), 0.4), mat(Color(0.1, 0.5, 0.2), 0.4)]
	for p: Vector3 in [Vector3(-8.0, 0, 11.2), Vector3(8.0, 0, 11.2), Vector3(-8.0, 0, 1.0)]:
		cyl(0.4, 0.32, 0.7, p + Vector3(0, 0.35, 0), beam, 10, a)
		_fake_tree(a, p + Vector3(0, 0.7, 0), 1.9, leaves)
	_it(a, "plants", Vector3(8.0, 1.0, 11.2), Vector3(1.0, 2.0, 1.0))
	# the violin, a speaker hidden in a beam
	box(Vector3(0.5, 0.18, 0.05), Vector3(4.0, 4.6, 5.1 - 0.17), mat(Color(0.12, 0.09, 0.07)), false, a)
	_it(a, "violin", Vector3(4.0, 4.6, 4.9), Vector3(0.8, 0.5, 0.5))
	# doors on the back wall: the stairs (west), staff only (east)
	for d: Array in [[-6.0, "stair_door"], [6.0, "staff_door"]]:
		var x: float = d[0]
		box(Vector3(1.2, 2.3, 0.08), Vector3(x, 1.15, 0.06), pbr("woodfloor", Vector3.ONE, true, Color(0.62, 0.42, 0.28)), false, a)
		box(Vector3(1.4, 0.12, 0.12), Vector3(x, 2.36, 0.08), beam, false, a)
		box(Vector3(0.05, 0.05, 0.14), Vector3(x + 0.45, 1.05, 0.12), mat(Color(0.8, 0.8, 0.82), 0.2, 0.9), false, a)
		box(Vector3(0.1, 0.16, 0.04), Vector3(x + 0.45, 1.3, 0.12), glow(Color(1.0, 0.1, 0.1), 2.0), false, a)
		_it(a, d[1], Vector3(x, 1.15, 0.25), Vector3(1.2, 2.3, 0.3))
	label("STAFF ONLY", Vector3(6.0, 2.0, 0.11), 0.0, 0.0016, Color(0.3, 0.2, 0.15), a, false)
	# the inside of the front door: a reader for the way out
	box(Vector3(0.16, 0.24, 0.06), Vector3(1.55, 1.3, 11.95), mat(Color(0.1, 0.1, 0.1), 0.4), false, a)
	box(Vector3(0.1, 0.06, 0.07), Vector3(1.55, 1.38, 11.93), glow(Color(1.0, 0.1, 0.1), 3.0), false, a)
	var lr := _it(a, "lobby_reader", Vector3(1.55, 1.3, 11.8), Vector3(0.4, 0.5, 0.3), L("scans", "lobby_reader"))
	lr.set_meta("hackable", true)
	var fd := _it(a, "front_door", Vector3(0, 1.4, 11.85), Vector3(2.2, 2.8, 0.3))
	fd.set_meta("route", "front")
	# warm lamps: pendants over the desk, sconces, a lavender fill by the diffuser
	for x: float in [-1.4, 1.4]:
		stick(Vector3(x, 5.0, 4.5), Vector3(x, 3.4, 4.5), 0.01, mat(Color(0.1, 0.1, 0.1)), a)
		cyl(0.1, 0.28, 0.3, Vector3(x, 3.3, 4.5), mat(Color(0.6, 0.4, 0.25), 0.6), 10, a)
		sphere(0.09, Vector3(x, 3.17, 4.5), glow(Color(1.0, 0.75, 0.45), 4.0), 8, a)
	_lamp(a, Vector3(0, 2.6, 6.2), WARM, 1.3, 7.0)
	for p: Vector3 in [Vector3(-8.8, 2.8, 2.5), Vector3(8.8, 2.8, 2.5), Vector3(-8.8, 2.8, 9.0), Vector3(8.8, 2.8, 9.0)]:
		box(Vector3(0.12, 0.3, 0.2), p, glow(Color(1.0, 0.7, 0.42), 2.6), false, a)
	_lamp(a, Vector3(-7.5, 2.6, 2.5), WARM, 0.9, 6.0)
	_lamp(a, Vector3(7.5, 2.6, 9.0), WARM, 0.9, 6.0)
	_lamp(a, Vector3(-5.5, 1.8, 9.2), LAV, 2.4, 8.0)
	_lamp(a, Vector3(3.0, 3.5, 3.0), LAV, 1.2, 8.0)
	_lamp(a, Vector3(0, 3.5, 9.5), Color(0.85, 0.75, 0.9), 0.7, 9.0)


## A painted portrait: the sunglasses, the smile.
func _eren_mat() -> StandardMaterial3D:
	var n := 64
	var img := Image.create(n, n, false, Image.FORMAT_RGB8)
	img.fill(Color(0.16, 0.13, 0.12))
	for y in n:
		for x in n:
			var p := Vector2(x - 32, y - 26)
			if p.length() < 15.0 and y < 44:
				img.set_pixel(x, y, Color(0.82, 0.66, 0.54) * (0.9 + 0.1 * sin(x * 0.3)))
			if y > 42 and absf(x - 32) < 22 - (y - 42) * -0.6:
				img.set_pixel(x, y, Color(0.92, 0.92, 0.9))
			if y >= 22 and y <= 26 and absf(x - 32) < 12:
				img.set_pixel(x, y, Color(0.02, 0.02, 0.02))
			if y == 33 and absf(x - 32) < 6:
				img.set_pixel(x, y, Color(0.5, 0.2, 0.18))
			if y < 16 and p.length() < 16.0:
				img.set_pixel(x, y, Color(0.08, 0.06, 0.05))
	var m := newmat(Color(1, 1, 1), 0.6)
	m.albedo_texture = ImageTexture.create_from_image(img)
	m.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	return m


func _chair(parent: Node, p: Vector3, ry: float, fab: Material, wood: Material) -> void:
	var root := Node3D.new()
	root.position = p
	root.rotation.y = ry
	parent.add_child(root)
	box(Vector3(0.8, 0.42, 0.8), Vector3(0, 0.25, 0), fab, false, root)
	box(Vector3(0.8, 0.7, 0.18), Vector3(0, 0.7, 0.35), fab, false, root)
	for sd: float in [-1.0, 1.0]:
		box(Vector3(0.14, 0.55, 0.8), Vector3(sd * 0.4, 0.4, 0), wood, false, root)
	solid_box(Vector3(0.9, 0.9, 0.9), p + Vector3(0, 0.45, 0), parent)


# ------------------------------------------------------------------ the first floor

## The hallway (ch.21: "down a hallway and up a flight of stairs"): numbered
## doors, sconces, the stair door at the east end and, from the morning, a
## trolley under a sheet outside the next room.
func _upstairs() -> void:
	var a: Node3D = areas["up"]
	var w := _wood()
	var beam := _beam_m()
	box(Vector3(20.0, 0.2, 2.6), Vector3(60.0, -0.1, 7.2), _floor_m(), true, a)
	box(Vector3(20.0, 0.2, 2.6), Vector3(60.0, 3.1, 7.2), w, false, a)
	floor_quad(Vector2(19.0, 1.2), Vector3(60.0, 0.012, 7.2), 0.0, pbr("carpet", Vector3(1, 1, 1) / 1.5, true, Color(0.55, 0.42, 0.62)), a)
	_wall(a, Vector3(20.0, 3.0, 0.2), Vector3(60.0, 1.5, 8.5), w)
	# the room side: wall pieces around Carl's door (x 55..56)
	_wall(a, Vector3(5.0, 3.0, 0.2), Vector3(52.5, 1.5, 6.0), w)
	_wall(a, Vector3(14.0, 3.0, 0.2), Vector3(63.0, 1.5, 6.0), w)
	_wall(a, Vector3(1.0, 0.8, 0.2), Vector3(55.5, 2.6, 6.0), w)
	_wall(a, Vector3(0.2, 3.0, 2.6), Vector3(50.0, 1.5, 7.2), w)
	_wall(a, Vector3(0.2, 3.0, 2.6), Vector3(70.0, 1.5, 7.2), w)
	for i in 8:
		var x := 51.0 + i * 2.6
		box(Vector3(0.24, 0.3, 2.6), Vector3(x, 2.9, 7.2), beam, false, a)
	# other rooms' doors, numbered
	var dm := pbr("woodfloor", Vector3.ONE, true, Color(0.62, 0.42, 0.28))
	var nos := [4, 5, 7, 8, 9]
	var dx := [52.0, 58.5, 61.5, 64.5, 67.5]
	for i in dx.size():
		var z := 8.38 if i % 2 == 0 else 6.12
		var face := PI if i % 2 == 0 else 0.0
		box(Vector3(1.0, 2.2, 0.06), Vector3(dx[i], 1.1, z), dm, false, a)
		box(Vector3(0.05, 0.05, 0.12), Vector3(dx[i] + 0.38, 1.05, z), mat(Color(0.8, 0.8, 0.82), 0.2, 0.9), false, a)
		label(str(nos[i]), Vector3(dx[i], 1.75, z + (-0.05 if i % 2 == 0 else 0.05)), face, 0.003, Color(0.85, 0.7, 0.35), a, false)
	_it(a, "hall_doors", Vector3(61.5, 1.1, 8.25), Vector3(1.0, 2.2, 0.3))
	label("6", Vector3(55.5, 2.4, 6.12), 0.0, 0.003, Color(0.85, 0.7, 0.35), a, false)
	# the stair door at the east end, with its reader
	box(Vector3(0.06, 2.2, 1.1), Vector3(69.88, 1.1, 7.2), dm, false, a)
	box(Vector3(0.05, 0.16, 0.1), Vector3(69.84, 1.3, 7.6), glow(Color(1.0, 0.1, 0.1), 2.0), false, a)
	label("STAIRS", Vector3(69.84, 2.45, 7.2), -PI / 2.0, 0.0018, Color(0.85, 0.75, 0.55), a, false)
	var st := _it(a, "stairs", Vector3(69.7, 1.1, 7.2), Vector3(0.3, 2.2, 1.1))
	st.set_meta("route", "stairs")
	# sconces
	for x: float in [53.0, 60.0, 67.0]:
		box(Vector3(0.24, 0.3, 0.12), Vector3(x, 2.1, 8.36), glow(Color(1.0, 0.7, 0.42), 2.6), false, a)
		_lamp(a, Vector3(x, 2.2, 7.8), WARM, 1.2, 5.0)
	# the trolley under the sheet (shown from the morning)
	trolley_root = Node3D.new()
	trolley_root.position = Vector3(58.5, 0, 6.6)
	dyn.add_child(trolley_root)
	var steel := mat(Color(0.7, 0.72, 0.74), 0.3, 0.8)
	box(Vector3(1.0, 0.04, 0.5), Vector3(0, 0.85, 0), steel, false, trolley_root)
	box(Vector3(1.0, 0.04, 0.5), Vector3(0, 0.3, 0), steel, false, trolley_root)
	for sx: float in [-0.46, 0.46]:
		for sz: float in [-0.22, 0.22]:
			box(Vector3(0.03, 0.85, 0.03), Vector3(sx, 0.43, sz), steel, false, trolley_root)
	var sheet := mat(Color(0.94, 0.94, 0.92), 0.9)
	box(Vector3(0.9, 0.12, 0.44), Vector3(0, 0.93, 0), sheet, false, trolley_root)
	box(Vector3(0.18, 0.2, 0.2), Vector3(-0.25, 1.05, 0), sheet, false, trolley_root)
	var bit := box(Vector3(0.5, 0.06, 0.06), Vector3(0.12, 1.02, 0), sheet, false, trolley_root)
	bit.rotation.z = 0.08
	trolley_it = interactable("trolley", P("trolley"), Vector3(0, 0.9, 0), Vector3(1.0, 0.6, 0.5), L("scans", "trolley"), false, trolley_root)
	trolley_root.visible = false
	set_active(trolley_it, false)


## Room 6 (ch.21): "a bed, with soft white linen, a TV, a window facing
## downtown, and a blood-red eye symbol on a small tablet sat above a
## prayer mat." The window looks north at downtown and the Tower.
func _room() -> void:
	var a: Node3D = areas["up"]
	var w := _wood()
	var beam := _beam_m()
	box(Vector3(6.0, 0.2, 7.0), Vector3(56.0, -0.1, 2.5), _floor_m(), true, a)
	box(Vector3(6.0, 0.2, 7.0), Vector3(56.0, 3.1, 2.5), w, false, a)
	_wall(a, Vector3(0.2, 3.0, 7.0), Vector3(52.9, 1.5, 2.5), w)
	_wall(a, Vector3(0.2, 3.0, 7.0), Vector3(59.1, 1.5, 2.5), w)
	# the north wall with the window (x 54.0..55.6, y 1.0..2.3)
	_wall(a, Vector3(1.0, 3.0, 0.2), Vector3(53.5, 1.5, -1.1), w)
	_wall(a, Vector3(3.5, 3.0, 0.2), Vector3(57.35, 1.5, -1.1), w)
	_wall(a, Vector3(1.6, 1.0, 0.2), Vector3(54.8, 0.5, -1.1), w)
	_wall(a, Vector3(1.6, 0.7, 0.2), Vector3(54.8, 2.65, -1.1), w)
	var gl := newmat(Color(0.3, 0.32, 0.4, 0.22), 0.05, 0.4)
	gl.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	box(Vector3(1.6, 1.3, 0.03), Vector3(54.8, 1.65, -1.1), gl, true, a)
	box(Vector3(0.06, 1.3, 0.1), Vector3(54.8, 1.65, -1.08), beam, false, a)
	box(Vector3(1.7, 0.08, 0.3), Vector3(54.8, 0.98, -0.98), beam, false, a)
	box(Vector3(0.12, 0.06, 0.06), Vector3(55.4, 1.05, -0.92), glow(Color(1.0, 0.1, 0.1), 2.5), false, a)
	_it(a, "window", Vector3(54.8, 1.65, -0.9), Vector3(1.7, 1.4, 0.3))
	# ceiling beams, a timber skirting
	for z: float in [0.2, 2.5, 4.8]:
		box(Vector3(6.0, 0.24, 0.24), Vector3(56.0, 2.9, z), beam, false, a)
	# the bed: frame, mattress, white linen turned down, two pillows, a sachet
	var lin := pbr("fabric", Vector3(1, 1, 1) / 0.6, true, Color(0.97, 0.96, 0.94))
	box(Vector3(2.1, 0.32, 1.5), Vector3(57.95, 0.2, 3.7), beam, true, a)
	box(Vector3(2.0, 0.22, 1.42), Vector3(57.95, 0.47, 3.7), lin, false, a)
	box(Vector3(1.3, 0.06, 1.46), Vector3(57.65, 0.6, 3.7), lin, false, a)
	box(Vector3(0.15, 1.1, 1.5), Vector3(58.98, 0.6, 3.7), beam, false, a)
	for z: float in [3.35, 4.05]:
		box(Vector3(0.38, 0.14, 0.6), Vector3(58.6, 0.64, z), lin, false, a)
	box(Vector3(0.12, 0.05, 0.12), Vector3(58.55, 0.73, 3.7), mat(LAV * 0.85, 0.9), false, a)
	_it(a, "bed", Vector3(57.95, 0.5, 3.7), Vector3(2.1, 0.7, 1.5))
	# the nightstand and its lamp
	box(Vector3(0.5, 0.55, 0.45), Vector3(58.7, 0.28, 2.55), beam, true, a)
	cyl(0.05, 0.08, 0.3, Vector3(58.7, 0.7, 2.55), mat(Color(0.7, 0.55, 0.3), 0.3, 0.8), 8, a)
	cyl(0.12, 0.17, 0.2, Vector3(58.7, 0.95, 2.55), glow(Color(1.0, 0.75, 0.48), 1.8), 10, a)
	room_lights.append(_lamp(a, Vector3(58.4, 1.1, 2.6), WARM, 0.8, 4.5))
	room_lights.append(_lamp(a, Vector3(56.0, 2.6, 3.0), Color(0.95, 0.8, 0.75), 0.35, 6.0))
	# the TV on the west wall, off
	box(Vector3(0.08, 0.74, 1.24), TV, mat(Color(0.04, 0.04, 0.045), 0.3), false, a)
	box(Vector3(0.02, 0.66, 1.14), TV + Vector3(0.05, 0, 0), mat(Color(0.02, 0.025, 0.03), 0.08, 0.3), false, a)
	var tv := _it(a, "tv", TV + Vector3(0.12, 0, 0), Vector3(0.2, 0.8, 1.3), L("scans", "tv"))
	tv.set_meta("hackable", true)
	# the FreudBot unit on a little desk under the TV's north end
	box(Vector3(0.6, 0.06, 1.0), Vector3(53.35, 0.76, 1.0), beam, false, a)
	for z: float in [0.6, 1.4]:
		box(Vector3(0.5, 0.74, 0.05), Vector3(53.35, 0.37, z), beam, false, a)
	solid_box(Vector3(0.6, 0.8, 1.0), Vector3(53.35, 0.4, 1.0), a)
	box(Vector3(0.28, 0.24, 0.24), Vector3(53.35, 0.91, 1.0), mat(Color(0.86, 0.86, 0.84), 0.3), false, a)
	box(Vector3(0.02, 0.12, 0.16), Vector3(53.5, 0.93, 1.0), glow(Color(0.3, 0.95, 0.75), 1.6), false, a)
	box(Vector3(0.01, 0.05, 0.05), Vector3(53.5, 0.84, 0.92), mat(Color(1.0, 0.8, 0.1)), false, a)
	var fb := _it(a, "freudbot", Vector3(53.4, 0.95, 1.0), Vector3(0.4, 0.4, 0.4), L("scans", "freudbot"))
	fb.set_meta("hackable", true)
	# the prayer mat and, above it, the tablet with the eye
	var mat_m := pbr("carpet", Vector3(1, 1, 1) / 0.6, true, Color(0.62, 0.3, 0.32))
	box(Vector3(0.85, 0.02, 1.4), MAT + Vector3(0, 0.01, 0), mat_m, false, a)
	box(Vector3(0.7, 0.025, 1.25), MAT + Vector3(0, 0.012, 0), mat(Color(0.75, 0.62, 0.42), 0.9), false, a)
	box(Vector3(0.85, 0.03, 0.08), MAT + Vector3(0, 0.02, -0.66), mat(Color(0.3, 0.12, 0.1)), false, a)
	_it(a, "mat", MAT + Vector3(0, 0.1, 0), Vector3(0.9, 0.2, 1.4))
	_glyph_on(MAT + Vector3(0, 0.05, 0.25), 0.0, 0.0032, "g_mat", false, false,
		"Woven into the mat, where a forehead would go, the rings. Somebody had knelt on them so often the threads had worn smooth.", true)
	box(Vector3(0.7, 0.88, 0.32), Vector3(56.6, 0.44, -0.84), beam, true, a)
	box(Vector3(0.06, 0.2, 0.06), Vector3(56.6, 0.95, -0.82), mat(Color(0.7, 0.55, 0.3), 0.3, 0.8), false, a)
	var stand := box(Vector3(0.5, 0.36, 0.03), TABLET, mat(Color(0.05, 0.05, 0.05), 0.3), false, a)
	stand.rotation.x = -0.25
	tablet_m = StandardMaterial3D.new()
	tablet_m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	tablet_m.albedo_texture = _eye_symbol()
	tablet_m.albedo_color = Color(0.7, 0.7, 0.7)
	var scr := quad(Vector2(0.46, 0.32), TABLET + Vector3(0, 0.004, 0.018), 0.0, tablet_m, a)
	scr.rotation.x = -0.25
	no_batch.append(scr)
	tablet_light = _lamp(a, TABLET + Vector3(0, 0.1, 0.4), Color(1.0, 0.1, 0.08), 0.5, 2.5)
	var tb := _it(a, "tablet", TABLET + Vector3(0, 0, 0.1), Vector3(0.45, 0.4, 0.3), L("scans", "tablet"))
	tb.set_meta("hackable", true)
	# the vent over the door: the lavender comes from here
	box(Vector3(0.6, 0.24, 0.04), Vector3(55.5, 2.72, 5.88), mat(Color(0.4, 0.28, 0.18), 0.7), false, a)
	for k in 4:
		box(Vector3(0.55, 0.02, 0.05), Vector3(55.5, 2.64 + k * 0.05, 5.86), mat(Color(0.1, 0.07, 0.05)), false, a)
	_it(a, "vent", Vector3(55.5, 2.72, 5.75), Vector3(0.7, 0.4, 0.3), L("scans", "vent"))
	gas_particles = _mist(a, Vector3(55.5, 2.5, 5.2), Vector3(2.4, 0.3, 0.6), 40, 0.12)
	gas_particles.direction = Vector3(0, -0.4, -1)
	gas_particles.preprocess = 0.0
	gas_particles.emitting = false
	# the door: a timber leaf on a pivot, barred; a silver handle
	var piv := Node3D.new()
	piv.position = Vector3(55.0, 0, 6.0)
	dyn.add_child(piv)
	box(Vector3(1.0, 2.2, 0.06), Vector3(0.5, 1.1, 0), pbr("woodfloor", Vector3.ONE, true, Color(0.62, 0.42, 0.28)), false, piv)
	box(Vector3(0.14, 0.04, 0.05), Vector3(0.82, 1.05, -0.06), mat(Color(0.86, 0.87, 0.9), 0.15, 1.0), false, piv)
	box(Vector3(0.06, 0.2, 0.04), Vector3(0.88, 1.2, -0.05), glow(Color(1.0, 0.1, 0.1), 2.2), false, piv)
	room_leaf = piv
	room_block = solid_box(Vector3(1.0, 2.6, 0.2), Vector3(55.5, 1.3, 6.0), a)
	_it(a, "room_door", Vector3(55.5, 1.1, 5.85), Vector3(1.0, 2.2, 0.2))
	# the pulsing light (Lynx's hack), hidden until chapter 22
	pulse = sphere(0.035, PULSE_PATH[0], glow(Color(1, 1, 1), 8.0), 8, dyn)
	pulse.visible = false
	pulse_light = OmniLight3D.new()
	pulse_light.light_color = Color(0.9, 0.95, 1.0)
	pulse_light.light_energy = 0.0
	pulse_light.omni_range = 1.6
	pulse.add_child(pulse_light)
	pulse_it = _it(a, "pulse", PULSE_PATH[0] + Vector3(0.1, 0, 0), Vector3(0.3, 0.3, 0.4))
	pulse_it.set_meta("hackable", true)
	set_active(pulse_it, false)
	# out of the window: downtown, close, and the Tower
	kit_parent = a
	for i in 6:
		cyber_block(Vector3(36.0 + i * 13.0, 0, -16.0 - rng.randf_range(0, 6)), 0.0, 12.0, rng.randf_range(20, 60), 14.0, false, 1)
		cyber_block(Vector3(40.0 + i * 13.0, 0, -45.0 - rng.randf_range(0, 10)), 0.0, 12.0, rng.randf_range(40, 100), 14.0, false, 1)
	kit_parent = self
	var tower_m := mat(Color(0.05, 0.05, 0.07), 0.6, 0.4)
	box(Vector3(50, 600, 50), Vector3(10.0, 300.0, -420.0), tower_m, false, a)
	for k in 12:
		box(Vector3(50.5, 0.6, 50.5), Vector3(10.0, 40.0 + k * 45.0, -420.0), glow(Color(0.3, 1.0, 0.45), 2.0), false, a)
	var bl := box(Vector3(3, 3, 3), Vector3(10.0, 602.0, -420.0), glow(Color(1, 0.05, 0.05), 5.0), false, a)
	blinkers.append(bl)
	_lamp(a, Vector3(54.8, 1.8, -2.4), Color(0.45, 0.6, 1.0), 1.0, 4.0)


## The tablet's symbol: a blood-red eye on black.
func _eye_symbol() -> ImageTexture:
	var n := 128
	var img := Image.create(n, n, false, Image.FORMAT_RGB8)
	img.fill(Color(0.04, 0.0, 0.0))
	for y in n:
		for x in n:
			var q := Vector2((x - 64.0) / 54.0, (y - 64.0) / 54.0)
			var lid := 0.5 * (1.0 - q.x * q.x)
			var c := Color(0.04, 0.0, 0.0)
			if absf(q.x) < 1.0 and absf(absf(q.y) - lid) < 0.05:
				c = Color(0.9, 0.05, 0.05)
			var r := q.length()
			if r < 0.36 and r > 0.3:
				c = Color(0.9, 0.05, 0.05)
			if r < 0.2:
				c = Color(1.0, 0.1, 0.08)
			img.set_pixel(x, y, c)
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


# ------------------------------------------------------------------ the tiled room

## The morning cleanse (ch.21): "a room lined with white, featureless tiles;
## there were no windows. The only noticeable feature was a large black hole
## in the center of the floor."
func _basement() -> void:
	var a: Node3D = areas["base"]
	var tile := tex_mat(_tile_tex(), Vector3(1, 1, 1) / 1.2, 0.25, true)
	box(Vector3(8.0, 0.2, 8.0), Vector3(-60.0, -0.1, 0.0), tile, true, a)
	box(Vector3(8.0, 0.2, 8.0), Vector3(-60.0, 3.3, 0.0), tile, false, a)
	_wall(a, Vector3(8.0, 3.2, 0.2), Vector3(-60.0, 1.6, -4.1), tile)
	_wall(a, Vector3(0.2, 3.2, 8.0), Vector3(-64.1, 1.6, 0.0), tile)
	_wall(a, Vector3(0.2, 3.2, 8.0), Vector3(-55.9, 1.6, 0.0), tile)
	_wall(a, Vector3(3.5, 3.2, 0.2), Vector3(-62.25, 1.6, 4.1), tile)
	_wall(a, Vector3(3.5, 3.2, 0.2), Vector3(-57.75, 1.6, 4.1), tile)
	_wall(a, Vector3(1.0, 1.0, 0.2), Vector3(-60.0, 2.7, 4.1), tile)
	# the door, white steel, no handle on this side
	box(Vector3(1.0, 2.2, 0.06), Vector3(-60.0, 1.1, 4.02), mat(Color(0.86, 0.87, 0.88), 0.3, 0.4), false, a)
	solid_box(Vector3(1.0, 2.2, 0.2), Vector3(-60.0, 1.1, 4.1), a)
	_it(a, "tile_door", Vector3(-60.0, 1.1, 3.9), Vector3(1.0, 2.2, 0.2))
	_it(a, "tiles", Vector3(-55.95, 1.4, -2.0), Vector3(0.2, 2.0, 2.0))
	# a drain, a hose reel: the room is washed out
	cyl(0.12, 0.12, 0.01, Vector3(-57.0, 0.005, 2.5), mat(Color(0.3, 0.3, 0.3), 0.4, 0.8), 10, a)
	cyl(0.25, 0.25, 0.12, Vector3(-56.0, 1.2, 2.8), mat(Color(0.6, 0.62, 0.64), 0.3, 0.7), 12, a).rotation.z = PI / 2.0
	# the hole: black, with no bottom; with the frames on it boils
	var hm := CylinderMesh.new()
	hm.top_radius = 1.15
	hm.bottom_radius = 1.15
	hm.height = 0.02
	hm.radial_segments = 32
	hole_disc = mesh(hm, HOLE + Vector3(0, 0.006, 0), _unshaded(Color(0, 0, 0)), dyn)
	var pm := PlaneMesh.new()
	pm.size = Vector2(2.3, 2.3)
	boil_m = ShaderMaterial.new()
	var sh := Shader.new()
	sh.code = BOIL_SHADER
	boil_m.shader = sh
	boil_disc = mesh(pm, HOLE + Vector3(0, 0.02, 0), boil_m, dyn)
	boil_disc.visible = false
	boil_light = _lamp(a, HOLE + Vector3(0, 0.6, 0), Color(0.5, 0.3, 1.0), 0.0, 6.0)
	var ho := _it(a, "hole", HOLE + Vector3(0, 0.3, 0), Vector3(2.4, 0.6, 2.4), L("scans", "hole"))
	ho.set_meta("hackable", false)
	# fluorescent tubes, then the orange glow when the attendant leaves
	for z: float in [-1.8, 1.8]:
		var fl := prop("mounted_fluorescent_lights", Vector3(-60.0, 3.15, z), 0.0, 1.0, false, a)
		if fl:
			base_fluor.append(fl)
	base_white = _lamp(a, Vector3(-60.0, 2.8, 0.5), Color(0.92, 0.96, 1.0), 2.4, 10.0)
	base_orange = _lamp(a, Vector3(-60.0, 0.4, 0.0), Color(1.0, 0.45, 0.15), 0.0, 6.0)


func _tile_tex() -> ImageTexture:
	var n := 128
	var img := Image.create(n, n, false, Image.FORMAT_RGB8)
	for y in n:
		for x in n:
			var c := Color(0.93, 0.94, 0.95) * (1.0 + rng.randf_range(-0.015, 0.015))
			if (x % 32) < 2 or (y % 32) < 2:
				c = Color(0.6, 0.61, 0.6)
			img.set_pixel(x, y, c)
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


# ------------------------------------------------------------------ the laundry

## The service corridor (ch.22's way out, if not the front): washers on the
## north wall, carts and linen alcoves on the south for cover, two
## attendants on a slow loop, the back door at the east end.
func _laundry() -> void:
	var a: Node3D = areas["laundry"]
	var conc := pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.42, 0.41, 0.4))
	var plas := pbr("plaster", Vector3(1, 1, 1) / 2.0, true, Color(0.55, 0.56, 0.58))
	box(Vector3(36.0, 0.2, 5.0), Vector3(-35.0, -0.1, -39.0), conc, true, a)
	box(Vector3(36.0, 0.2, 5.0), Vector3(-35.0, 3.1, -39.0), plas, false, a)
	_wall(a, Vector3(36.0, 3.0, 0.2), Vector3(-35.0, 1.5, -41.6), plas)
	_wall(a, Vector3(0.2, 3.0, 5.0), Vector3(-52.1, 1.5, -39.0), plas)
	_wall(a, Vector3(0.2, 3.0, 5.0), Vector3(-17.9, 1.5, -39.0), plas)
	# the south wall in pieces, with three alcoves (x -40, -31, -24) 1.4 deep
	var alc := [-40.0, -31.0, -24.0]
	var x0 := -52.0
	for ax: float in alc:
		var l := (ax - 0.7) - x0
		_wall(a, Vector3(l, 3.0, 0.2), Vector3(x0 + l / 2.0, 1.5, -38.4), plas)
		_wall(a, Vector3(1.4, 3.0, 0.2), Vector3(ax, 1.5, -36.9), plas)
		_wall(a, Vector3(0.2, 3.0, 1.5), Vector3(ax - 0.8, 1.5, -37.65), plas)
		_wall(a, Vector3(0.2, 3.0, 1.5), Vector3(ax + 0.8, 1.5, -37.65), plas)
		box(Vector3(1.3, 0.2, 1.5), Vector3(ax, -0.1, -37.65), conc, true, a)
		prop("steel_frame_shelves_01", Vector3(ax, 0, -37.3), PI, 0.7, false, a)
		for k in 3:
			box(Vector3(0.9, 0.12, 0.3), Vector3(ax, 0.5 + k * 0.5, -37.25), mat(Color(0.95, 0.95, 0.93), 0.9), false, a)
		x0 = ax + 0.7
	_wall(a, Vector3(-18.0 - x0, 3.0, 0.2), Vector3(x0 + (-18.0 - x0) / 2.0, 1.5, -38.4), plas)
	_it(a, "shelves", Vector3(-31.0, 1.0, -37.4), Vector3(1.2, 2.0, 0.4))
	# washers along the north wall, white turning in their round doors
	var steel := mat(Color(0.78, 0.8, 0.82), 0.35, 0.6)
	var drum := glow(Color(0.65, 0.66, 0.7), 0.5)
	for i in 12:
		var x := -49.0 + i * 2.4
		box(Vector3(1.0, 1.2, 0.8), Vector3(x, 0.6, -41.1), steel, true, a)
		cyl(0.3, 0.3, 0.04, Vector3(x, 0.7, -40.69), drum, 14, a).rotation.x = PI / 2.0
		box(Vector3(1.0, 0.1, 0.1), Vector3(x, 1.15, -40.68), mat(Color(0.2, 0.2, 0.22), 0.5), false, a)
	_it(a, "washers", Vector3(-37.0, 0.8, -40.6), Vector3(1.2, 1.2, 0.3))
	var steam := _mist(a, Vector3(-35.0, 2.2, -40.8), Vector3(14.0, 0.4, 0.4), 30, 0.07)
	(steam.mesh.material as StandardMaterial3D).albedo_color = Color(0.9, 0.9, 0.95, 0.07)
	# laundry carts for cover
	var canvas := pbr("fabric", Vector3(1, 1, 1) / 0.6, true, Color(0.35, 0.4, 0.5))
	for cx: float in [-44.0, -35.5, -27.5]:
		box(Vector3(1.2, 0.9, 0.7), Vector3(cx, 0.55, -38.9), canvas, true, a)
		box(Vector3(1.1, 0.25, 0.6), Vector3(cx, 1.08, -38.9), mat(Color(0.95, 0.94, 0.92), 0.9), false, a)
	_it(a, "carts", Vector3(-35.5, 1.0, -39.0), Vector3(1.3, 1.0, 0.8))
	# ducts and the fluorescent tubes
	prop("modular_airduct_circular_01", Vector3(-35.0, 2.7, -41.0), PI / 2.0, 1.0, false, a)
	for x: float in [-46.0, -35.0, -24.0]:
		prop("mounted_fluorescent_lights", Vector3(x, 3.0, -39.5), PI / 2.0, 1.0, false, a)
		_lamp(a, Vector3(x, 2.6, -39.5), Color(0.8, 0.9, 1.0), 0.8, 7.0)
	prop("fuse_panel", Vector3(-51.9, 1.4, -40.6), PI / 2.0, 1.0, false, a)
	# the stair door at the west end, the back door at the east
	box(Vector3(0.06, 2.2, 1.1), Vector3(-51.95, 1.1, -39.4), mat(Color(0.5, 0.52, 0.55), 0.4, 0.6), false, a)
	box(Vector3(0.06, 2.2, 1.1), Vector3(-18.05, 1.1, -40.0), mat(Color(0.5, 0.52, 0.55), 0.4, 0.6), false, a)
	box(Vector3(0.05, 0.25, 0.5), Vector3(-18.1, 2.5, -40.0), glow(Color(0.2, 1.0, 0.4), 2.2), false, a)
	label("EXIT", Vector3(-18.14, 2.5, -40.0), PI / 2.0, 0.0018, Color(0.1, 0.2, 0.1), a, false)
	var bd := _it(a, "back_door", Vector3(-18.3, 1.1, -40.0), Vector3(0.4, 2.2, 1.2))
	bd.set_meta("route", "laundry")


# ------------------------------------------------------------------ people

## The front-desk attendant ("middle-aged and looked genuinely happy to see
## me, so happy"), the morning attendant in a faded blue jumpsuit, company
## security in the same blue, Lynx, Turan and Emmet in the car, and the
## double that only the frames can see.
func _people() -> void:
	var o := {"arms": true, "knees": true}
	attendant = figure(Color(0.46, 0.38, 0.3), Color(0.9, 0.8, 0.72), {"arms": true, "knees": true, "hair": Color(0.32, 0.26, 0.2), "legs": Color(0.3, 0.26, 0.22), "long_coat": false})
	attendant.position = DESK + Vector3(0, 0, -1.0)
	attendant.rotation.y = PI
	dyn.add_child(attendant)
	var at := person("attendant", P("attendant"), attendant, L("scans", "attendant"))
	at.set_meta("guard", true)
	var jump := Color(0.34, 0.45, 0.58)
	blue = figure(jump, Color(0.78, 0.62, 0.5), {"arms": true, "knees": true, "hair": Color(0.1, 0.08, 0.06), "legs": jump, "long_coat": false})
	blue.visible = false
	dyn.add_child(blue)
	blue.set_meta("guard", true)
	lobby_guard = figure(jump, Color(0.5, 0.36, 0.28), {"arms": true, "knees": true, "hair": Color(0.05, 0.04, 0.04), "legs": jump, "long_coat": false, "visor": true})
	lobby_guard.position = Vector3(3.2, 0, 10.4)
	lobby_guard.rotation.y = PI / 2.0
	lobby_guard.visible = false
	dyn.add_child(lobby_guard)
	lobby_guard.set_meta("guard", true)
	guard_it = interactable("lobby_guard", P("guard"), Vector3(0, 0.9, 0), Vector3(0.7, 1.9, 0.7), L("scans", "blue"), false, lobby_guard)
	guard_it.set_meta("guard", true)
	set_active(guard_it, false)
	var routes := [[Vector3(-46.0, 0, -40.15), Vector3(-36.6, 0, -40.15)], [Vector3(-21.5, 0, -40.15), Vector3(-33.6, 0, -40.15)]]
	for i in 2:
		var g := figure(jump, [Color(0.86, 0.7, 0.6), Color(0.45, 0.32, 0.25)][i], {"arms": true, "knees": true, "hair": Color(0.08, 0.06, 0.05), "legs": jump, "long_coat": false, "visor": true})
		var ga: Vector3 = routes[i][0]
		var gb: Vector3 = routes[i][1]
		g.position = ga
		g.set_meta("guard", true)
		dyn.add_child(g)
		turn_to(g, gb)
		var it := interactable("guard%d" % i, P("guard"), Vector3(0, 0.9, 0), Vector3(0.7, 1.9, 0.7), L("scans", "blue"), false, g)
		it.set_meta("guard", true)
		guards.append({"fig": g, "a": ga, "b": gb, "to_b": true, "wait": 0.0, "it": it, "speed": 1.15 + i * 0.2})
	lynx = figure(Color(0.09, 0.08, 0.1), Color(0.88, 0.74, 0.62),
		{"hair": Color(0.12, 0.08, 0.06), "long_hair": true, "legs": Color(0.1, 0.1, 0.12), "arms": true, "knees": true, "visor": true, "long_coat": true})
	lynx.visible = false
	dyn.add_child(lynx)
	lynx_it = interactable("lynx", L("lynx", "prompt"), Vector3(0, 0.9, 0), Vector3(0.7, 1.9, 0.7), L("lynx", "scan"), false, lynx)
	set_active(lynx_it, false)
	turan = figure(Color(0.16, 0.16, 0.19), Color(0.8, 0.66, 0.56), {"hair": Color(0.2, 0.2, 0.22), "legs": Color(0.14, 0.14, 0.16), "arms": true, "knees": true, "long_coat": false})
	sphere(0.05, Vector3(0, 0.07, 0.1), mat(Color(0.2, 0.2, 0.22), 0.9), 8, turan.get_meta("head"))
	turan.visible = false
	dyn.add_child(turan)
	emmet = figure(Color(0.28, 0.38, 0.5), Color(0.9, 0.74, 0.64), {"hair": Color(0.8, 0.3, 0.1), "legs": Color(0.2, 0.2, 0.24), "arms": true, "knees": true, "scale": 1.06, "long_coat": false})
	emmet.visible = false
	dyn.add_child(emmet)
	for pair: Array in [[turan, "turan"], [emmet, "emmet"]]:
		var ci := interactable(pair[1], P(pair[1]), Vector3(0, 0.9, 0), Vector3(0.7, 1.9, 0.7), "", false, pair[0])
		set_active(ci, false)
		crew_its.append(ci)
	# Carl's double: his coat, his jaw, the sockets full of the hole's dark
	double = figure(Color(0.24, 0.26, 0.3), Color(0.8, 0.62, 0.5), {"arms": true, "knees": true, "hair": Color(0.12, 0.09, 0.07), "long_coat": true})
	var hd: Node3D = double.get_meta("head")
	var hollow := _unshaded(Color(0, 0, 0))
	for sd: float in [-1.0, 1.0]:
		box(Vector3(0.07, 0.05, 0.04), Vector3(sd * 0.044, 0.018, -0.108), hollow, false, hd)
		box(Vector3(0.014, 0.09, 0.01), Vector3(sd * 0.05, -0.04, -0.117), hollow, false, hd)
		box(Vector3(0.01, 0.05, 0.01), Vector3(sd * 0.032, -0.06, -0.115), hollow, false, hd)
	double.position = HOLE + Vector3(0, -2.0, 0)
	double.rotation.y = 0.0
	double.visible = false
	double.set_meta("eyeless", true)
	dyn.add_child(double)
	# the car: no Psyonic badge anywhere on it
	car = Car.build(self, Color(0.13, 0.11, 0.1), {"plate": "", "head": glow(Color(1, 0.95, 0.85), 1.2), "tail": glow(Color(1, 0.05, 0.05), 1.0)})
	car.position = CAR_AT
	car.rotation.y = -PI / 2.0
	car.visible = false
	dyn.add_child(car)
	car_it = interactable("car", L("car", "get_in"), CAR_AT + Vector3(0, 0.9, 0), Vector3(4.6, 1.8, 2.1), L("scans", "car"), false, areas["street"])
	set_active(car_it, false)


func scan_people() -> Array:
	var out := []
	if attendant.visible:
		out.append([attendant, L("scans", "attendant")])
	if blue.visible:
		out.append([blue, L("scans", "blue")])
	if lobby_guard.visible:
		out.append([lobby_guard, L("scans", "blue")])
	if area == "laundry":
		for g: Dictionary in guards:
			out.append([g["fig"], L("scans", "blue")])
	if lynx.visible:
		out.append([lynx, L("lynx", "scan")])
	if double.visible:
		out.append([double, L("scans", "double")])
	return out


# ------------------------------------------------------------------ screen layers

## The lavender tint (under the PS1 filter, so it dithers like the room),
## the Seven Breaths and the dream (over it, under the dialogue).
func _layers() -> void:
	var gl := CanvasLayer.new()
	gl.layer = 4
	add_child(gl)
	gas_rect = ColorRect.new()
	gas_rect.color = Color(LAV.r, LAV.g * 0.9, LAV.b, 0.0)
	gas_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	gas_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	gl.add_child(gas_rect)
	var dl := CanvasLayer.new()
	dl.layer = 9
	add_child(dl)
	dive_root = Control.new()
	dive_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dive_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	dive_root.visible = false
	dl.add_child(dive_root)
	var dim := ColorRect.new()
	dim.color = Color(0.03, 0.0, 0.02, 0.84)
	dim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dive_root.add_child(dim)
	dive_ring = ColorRect.new()
	dive_ring.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dive_ring.anchor_left = 0.5
	dive_ring.anchor_right = 0.5
	dive_ring.anchor_top = 0.45
	dive_ring.anchor_bottom = 0.45
	dive_ring.offset_left = -190
	dive_ring.offset_right = 190
	dive_ring.offset_top = -190
	dive_ring.offset_bottom = 190
	dive_mat = ShaderMaterial.new()
	var sh := Shader.new()
	sh.code = BREATH_SHADER
	dive_mat.shader = sh
	dive_ring.material = dive_mat
	dive_root.add_child(dive_ring)
	var title := _dlabel(18, Color(0.85, 0.7, 0.75), 0.04, 0.1)
	title.text = L("breaths", "title")
	dive_count = _dlabel(30, Color(1.0, 0.9, 0.9), 0.1, 0.17)
	dive_cue = _dlabel(30, Color(0.8, 0.95, 0.85), 0.71, 0.76)
	dive_voice = _dlabel(19, Color(1.0, 0.55, 0.5), 0.76, 0.84)
	dive_carl = _dlabel(17, Color(0.85, 0.82, 0.9), 0.84, 0.9)
	dive_howto = _dlabel(14, Color(0.7, 0.7, 0.72), 0.9, 1.0)
	dive_howto.text = L("breaths", "howto")
	dream_rect = ColorRect.new()
	dream_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dream_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	dream_mat = ShaderMaterial.new()
	var dsh := Shader.new()
	dsh.code = DREAM_SHADER
	dream_mat.shader = dsh
	dream_rect.material = dream_mat
	dream_rect.visible = false
	dl.add_child(dream_rect)


func _dlabel(size: int, c: Color, top: float, bottom: float) -> Label:
	var l := Label.new()
	l.anchor_left = 0.12
	l.anchor_right = 0.88
	l.anchor_top = top
	l.anchor_bottom = bottom
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", c)
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
	l.add_theme_constant_override("outline_size", 6)
	dive_root.add_child(l)
	return l


# ------------------------------------------------------------------ sound

## The violin is the hymn slowed eight times: one bowed tone, looped and
## re-pitched note by note from tick (the four hummed notes of the song,
## each held eight times as long). The gas is a high whine that beats.
func _sounds() -> void:
	var rate := Synth.RATE
	var s: PackedFloat32Array = Synth._buf(1.0)
	var ph := 0.0
	for i in s.size():
		var t := float(i) / rate
		var f := 330.0 * (1.0 + 0.006 * sin(TAU * 5.0 * t))
		ph += f / rate
		var v := 0.0
		for k in range(1, 9):
			v += sin(TAU * ph * k) / float(k) * (1.0 if k < 4 else 0.6)
		s[i] = v * 0.22 + (randf() - 0.5) * 0.01
	_violin = AudioStreamPlayer.new()
	_violin.stream = Synth._wav(s, true)
	_violin.volume_db = -80.0
	add_child(_violin)
	var w: PackedFloat32Array = Synth._buf(1.0)
	for i in w.size():
		var t := float(i) / rate
		w[i] = (sin(TAU * 3100.0 * t) + sin(TAU * 3130.0 * t)) * 0.18 + (randf() - 0.5) * 0.05
	_whine = AudioStreamPlayer.new()
	_whine.stream = Synth._wav(w, true)
	_whine.volume_db = -80.0
	add_child(_whine)


func ambience() -> void:
	main.loop("hum", -24.0)
	main.loop("murmur", -34.0, Vector3(0, 1.0, 30.0), 6.0, 40.0)
	main.loop("room", -30.0)
	_violin.play()
	_whine.play()


## The hymn's four notes (E, G, F#, D, then rest) at eight times their length.
const HYMN_NOTES := [[329.63, 7.2], [392.0, 7.2], [369.99, 7.2], [293.66, 12.0], [0.0, 12.8]]


func _tick_violin(delta: float) -> void:
	_vio_t += delta
	var total := 46.4
	var t := fmod(_vio_t, total)
	var acc := 0.0
	var f := 0.0
	var nl := 1.0
	var into := 0.0
	for n: Array in HYMN_NOTES:
		if t < acc + float(n[1]):
			f = float(n[0])
			nl = float(n[1])
			into = t - acc
			break
		acc += float(n[1])
	var inside := area in ["lobby", "up"]
	var base_db := -30.0 if inside else -44.0
	if area == "base" or _gas_mode == "silence":
		base_db = -80.0
	if f <= 0.0:
		_violin.volume_db = -80.0
		return
	_violin.pitch_scale = f / 330.0
	var env := minf(1.0, into / 2.0) * minf(1.0, (nl - into) / 1.5)
	_violin.volume_db = lerpf(-60.0, base_db, clampf(env, 0.0, 1.0))


# ------------------------------------------------------------------ environment

func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	_env = env
	# midnight downtown; inside, warm lamps on fake oak and a lavender haze
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.34, 0.28, 0.32)
	env.ambient_light_energy = 0.5
	env.fog_light_color = Color(0.2, 0.13, 0.2)
	env.fog_density = 0.004
	env.glow_bloom = 0.03
	env.tonemap_exposure = 1.15
	sun.light_energy = 0.12


func hifi(env: Environment, _sun: DirectionalLight3D) -> void:
	env.volumetric_fog_albedo = Color(0.7, 0.6, 0.85)


func apply_args(a: Dictionary) -> void:
	if not a.has("spa"):
		return
	_st_shot = str(a["spa"])
	var f: Dictionary = main.flags
	var keep := a.has("at")
	match _st_shot:
		"room", "gas":
			f["spa_room"] = true
			_show(["up"])
			if not keep:
				_tele(Vector3(57.6, 0.1, 5.0), 30.0)
			if _st_shot == "gas":
				_gas = 0.6
				_gas_v = 0.6
				gas_particles.emitting = true
				tablet_m.albedo_color = Color(1.4, 1.2, 1.2)
		"hole", "hole_off":
			f["spa_morning"] = true
			_show(["base"])
			base_white.light_energy = 0.0
			base_orange.light_energy = 0.8
			for fl: Node3D in base_fluor:
				fl.visible = false
			if not keep:
				_tele(Vector3(-60.6, 0.1, 3.2), -8.0)
			if _st_shot == "hole":
				main.frames_on = true
				main.ui.set_frames(1.0, main.connection)
				_double_k = 1.0
				_double_seen = true
		"laundry":
			_show(["laundry"])
			if not keep:
				_tele(LAUNDRY_START + Vector3(0, 0.1, 0), -90.0)
		"car":
			f["spa_out"] = true
			f["lushons_done"] = true
			_car_crew()
			if not keep:
				_tele(Vector3(-1.0, 0.1, 15.2), -120.0)
		"dive":
			f["spa_room"] = true
			_show(["up"])
			dive_root.visible = true
			dive_mat.set_shader_parameter("guide", 0.62)
			dive_mat.set_shader_parameter("lung", 0.55)
			dive_mat.set_shader_parameter("good", 1.0)
			dive_count.text = L("breaths", "count") % 5
			dive_cue.text = L("breaths", "in")
			dive_voice.text = str(LA("breaths", "voice")[4])
			dive_carl.text = str(LA("breaths", "carl")[4])
		"lobby":
			if not keep:
				_tele(Vector3(-2.0, 0.1, 10.5), 10.0)


func _tele(p: Vector3, yaw_deg: float) -> void:
	var pl = main.player
	pl.position = p
	pl.velocity = Vector3.ZERO
	pl.yaw = deg_to_rad(yaw_deg)
	pl.pitch = 0.0
	pl.rotation.y = pl.yaw


# ------------------------------------------------------------------ the scenes

## Midnight on the street, the night after Lushon's (ch.20 end, ch.21).
func intro() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("spa_arrived"):
		return
	f["spa_arrived"] = true
	# the bible's entry: spa_booked, or pip_active; a dev run straight in gets the PIP
	if not f.has("spa_booked") and not f.has("pip_active"):
		f["pip_active"] = true
	f["cinematic"] = true
	await ui.think(L("street", "after_lushons" if f.has("lushons_done") else "before"))
	await ui.think(L("street", "booked" if f.has("spa_booked") else "pip"))
	await main.player.face(DOOR + Vector3(0, 4.0, 0), 1.6)
	await ui.think(L("street", "look"))
	await ui.think(L("street", "look_2"))
	await ui.think(L("street", "look_3"))
	ui.close()
	main.log_line("time", "Day 5, midnight: the spa downtown.")
	f.erase("cinematic")
	main.update_hud()


func interact(node: Object) -> bool:
	var ui = main.ui
	var f: Dictionary = main.flags
	var id := str(node.get_meta("id"))
	match id:
		"spa_door":
			if f.has("spa_out") or f.has("spa_checked_in"):
				await ui.think(L("street", "door_shut"))
			elif not front_block.collision_layer:
				await ui.think(L("lobby", "desk_think") if absf(main.player.position.z - 12.2) < 0.1 else L("street", "door"))
			else:
				await ui.think(L("street", "door"))
				_front_door(true)
		"reader":
			await _badge(L("street", "reader"), L("street", "reader_2"))
		"sign", "trees", "mist", "street", "ad":
			await ui.think(L("street", id))
		"attendant":
			if not f.has("spa_checked_in"):
				await _check_in()
			elif f.has("spa_route_front"):
				await ui.think(L("front", "guard_we" if f.has("spa_out") else "guard"))
			else:
				await ui.say("Attendant", L("lobby", "a3_quiet"))
		"desk", "guestbook", "brochure", "diffuser", "eren", "plaque", "notice", "kiosk", "beams", "staff_door", "plants", "rug":
			await ui.think(L("lobby", id))
		"violin":
			await ui.think(L("lobby", "violin_frames" if main.frames_on else "violin"))
		"stair_door":
			await ui.think(L("lobby", "stair_door"))
		"front_door":
			if f.has("spa_route_front") and not f.has("spa_out"):
				await _front_out()
			else:
				await ui.think(L("street", "door_shut"))
		"lobby_reader":
			await _badge(L("front", "reader"), L("street", "reader_2"))
		"lobby_guard":
			await ui.think(L("front", "guard_we" if f.has("spa_out") else "guard"))
		"hall_doors":
			await ui.think(L("hall", "doors"))
		"trolley":
			await ui.think(L("hall", "trolley"))
			if main.frames_on:
				await ui.think(L("hall", "trolley_frames"))
			if not f.has("spa_trolley_seen"):
				f["spa_trolley_seen"] = true
				main.log_line("clue", L("hall", "trolley_log"))
		"stairs":
			if f.has("spa_route_front") or f.has("spa_route_laundry"):
				await ui.think(L("ch22", "lynx_talk"))
			elif f.has("spa_lynx"):
				await _route()
			else:
				await _badge(L("hall", "stairs_locked"), "")
		"room_door":
			if f.has("spa_lynx"):
				await ui.say("Lynx", L("ch22", "lynx_talk"))
			elif not f.has("spa_door_barred"):
				f["spa_door_barred"] = true
				await ui.think(L("room", "door"))
				await ui.think(L("room", "door_2"))
				await ui.think(L("room", "plan"))
			else:
				await ui.think(L("room", "door_again"))
		"window":
			if not f.has("spa_window_locked"):
				f["spa_window_locked"] = true
				await ui.think(L("room", "window"))
			else:
				await ui.think(L("room", "window_again"))
		"bed":
			if f.has("spa_prayer_done") or _prompted:
				await ui.think(L("room", "bed"))
			else:
				await ui.think(L("room", "lie"))
				await ui.think(L("room", "lie_2"))
				await _prayer_prompt()
		"tablet":
			if f.has("spa_prayer_done"):
				await ui.think(L("room", "tablet"))
			elif not _prompted:
				await ui.think(L("room", "tablet"))
				await _prayer_prompt()
			else:
				await ui.say("Tablet", L("prayer", ["wait_1", "wait_2", "wait_3"][_gas_line % 3]))
				_gas_line += 1
			if main.frames_on:
				await ui.think(L("room", "frames_sad"))
		"mat":
			if _prompted and not _praying and not f.has("spa_prayer_done"):
				await _prayer(false)
			else:
				await ui.think(L("room", "mat"))
		"tv":
			await ui.think(L("room", "tv_morning" if f.has("spa_morning") else "tv"))
		"freudbot":
			await ui.think(L("room", "freudbot"))
			await ui.say("FreudBot", L("room", "freudbot_2"))
		"vent":
			await ui.think(L("room", "vent"))
		"pulse":
			if _pulse_on and not f.has("spa_lynx"):
				await _lynx_in()
		"hole":
			await _hole()
		"tile_door":
			await ui.think(L("hole", "door_after" if f.has("spa_hole_jumped") else "door"))
		"tiles":
			await ui.think(L("hole", "tiles_after" if f.has("spa_hole_jumped") else "tiles"))
		"washers", "carts", "shelves":
			await ui.think(L("laundry", id))
		"guard0", "guard1":
			await ui.think(L("laundry", "guard"))
		"back_door":
			if f.has("spa_route_laundry") and not f.has("spa_out") and main.player.global_position.distance_to(BACK_DOOR) < 3.5:
				await _laundry_out()
			elif not f.has("spa_out"):
				await ui.think(L("laundry", "back_far"))
		"car":
			await _car()
		"lynx":
			await ui.say("Lynx", L("ch22", "lynx_talk_2" if area == "up" else "lynx_talk"))
		"turan", "emmet":
			await ui.think(L("car", id))
		_:
			return false
	return true


## The one route the spa doesn't have: Carl's badge is suspended.
func _badge(a: String, b: String) -> void:
	var f: Dictionary = main.flags
	main.play("snap", -12.0, 0.6)
	await main.ui.think(a)
	if b != "":
		await main.ui.think(b)
	if not f.has("spa_badge_tried"):
		f["spa_badge_tried"] = true
		main.log_line("event", "Tried my badge at the spa. Suspended (PIP).")


func _front_door(open: bool) -> void:
	front_block.collision_layer = 0 if open else 1
	var tw := create_tween().set_parallel(true)
	for lf: Array in front_leaves:
		tw.tween_property(lf[0], "rotation:y", float(lf[1]) if open else 0.0, 0.9).set_trans(Tween.TRANS_SINE)
	main.play("door", -8.0, 0.9)


func _room_door(open: bool) -> void:
	room_block.collision_layer = 0 if open else 1
	create_tween().tween_property(room_leaf, "rotation:y", 1.5 if open else 0.0, 0.8).set_trans(Tween.TRANS_SINE)
	main.play("door", -8.0, 1.0)


## Walk Carl along points (he is locked; the camera keeps its own look).
func _walk(points: Array, speed := 1.6) -> void:
	var p = main.player
	for q: Vector3 in points:
		var t := maxf(0.3, Vector3(p.position.x, 0, p.position.z).distance_to(Vector3(q.x, 0, q.z)) / speed)
		var tw := create_tween()
		tw.tween_property(p, "position", Vector3(q.x, 0.1, q.z), t)
		await tw.finished


## The desk (ch.21) and the walk up to room 6.
func _check_in() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	f["cinematic"] = true
	await main.player.face(attendant.global_position + Vector3(0, 1.6, 0), 0.8)
	await ui.think(L("lobby", "desk_think"))
	await ui.say("Attendant", L("lobby", "a1"))
	await ui.say("Attendant", L("lobby", "a2"))
	await ui.think(L("lobby", "a2_think"))
	var i: int = await ui.choose(LA("lobby", "choices"))
	await ui.say("Attendant", L("lobby", "a3" if i == 0 else "a3_quiet"))
	await ui.say("Attendant", L("lobby", "a4"))
	await ui.say("Attendant", L("lobby", "a5"))
	ui.close()
	f["spa_checked_in"] = true
	main.log_line("event", L("lobby", "log"))
	await ui.fade_to(1.0, 0.8)
	_front_door(false)
	_show(["up"])
	attendant.position = Vector3(56.2, 0, 7.4)
	_tele(Vector3(68.6, 0.1, 7.2), 90.0)
	turn_to(attendant, main.player.position)
	await ui.fade_to(0.0, 0.8)
	await ui.think(L("lobby", "walk"))
	ui.close()
	await _walk([Vector3(57.6, 0, 7.2)])
	await main.player.face(attendant.global_position + Vector3(0, 1.6, 0), 0.6)
	await ui.say("Attendant", L("hall", "a1"))
	await ui.say("Attendant", L("hall", "a2"))
	await ui.think(L("hall", "a2_think"))
	await ui.think(L("hall", "open"))
	ui.close()
	_room_door(true)
	attendant.position = Vector3(56.6, 0, 7.6)
	await _walk([Vector3(55.5, 0, 7.2), Vector3(55.5, 0, 4.4)])
	await main.player.face(TABLET, 0.8)
	await ui.think(L("hall", "room_think"))
	attendant.position = Vector3(55.5, 0, 6.7)
	turn_to(attendant, main.player.position)
	await main.player.face(attendant.global_position + Vector3(0, 1.6, 0), 0.8)
	await ui.say("Attendant", L("hall", "a3"))
	await ui.think(L("hall", "a3_think"))
	await ui.think(L("hall", "closed"))
	_room_door(false)
	attendant.position = DESK + Vector3(0, 0, -1.0)
	attendant.rotation.y = PI
	if main.frames_on:
		main.toggle_frames()
	await ui.think(L("hall", "frames_off"))
	ui.close()
	f["spa_room"] = true
	f.erase("cinematic")
	main.update_hud()


## The tablet chimes: the quiet prayer, which can be refused (the gas).
func _prayer_prompt() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if _prompted:
		return
	_prompted = true
	main.play("ding", -10.0, 1.2)
	tablet_m.albedo_color = Color(1.3, 1.3, 1.3)
	tablet_light.light_energy = 1.2
	await ui.think(L("prayer", "chime"))
	await ui.say("Tablet", L("prayer", "welcome"))
	await ui.think(L("prayer", "think"))
	await ui.say("Tablet", L("prayer", "ask"))
	var i: int = await ui.choose(LA("prayer", "choices"))
	if i == 0:
		await ui.think(L("prayer", "sure"))
		ui.close()
		await _prayer(false)
		return
	await ui.think(L("prayer", "refuse"))
	await ui.think(L("prayer", "refuse_2"))
	ui.close()
	f["spa_prayer_refused"] = true
	main.log_line("choice", L("prayer", "refuse_log"))
	_gas_mode = "refused"
	_gas_t = 0.0
	gas_particles.emitting = true
	main.play("vacuum", -18.0, 0.6)
	main.update_hud()


## Kneeling on the mat (or forced to, after a minute of gas): the dive.
func _prayer(forced: bool) -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if _praying or f.has("spa_prayer_done"):
		return
	_praying = true
	f["cinematic"] = true
	ui.close()
	await ui.think(L("prayer", "forced" if forced else "kneel"))
	ui.close()
	_tele(MAT + Vector3(0, 0.1, 0.45), 0.0)
	create_tween().tween_property(main.player, "crouch", 0.75, 0.8)
	await main.player.face(TABLET, 0.8)
	await ui.think(L("prayer", "pulse"))
	ui.close()
	tablet_m.albedo_color = Color(2.0, 1.5, 1.5)
	tablet_light.light_energy = 2.2
	await _seven_breaths()
	await _mira()


## The Seven Breaths of Reconciliation: hold to breathe in while the ring
## opens, let go while it closes; keep the circle on the ring. Seven clean
## breaths. Past 50 the breaths come on their own ("You already knew").
func _seven_breaths() -> void:
	var ui = main.ui
	var auto: bool = main.connection >= 50.0
	dive_root.visible = true
	dive_root.modulate.a = 0.0
	create_tween().tween_property(dive_root, "modulate:a", 1.0, 1.0)
	if auto:
		ui.show_toast(L("breaths", "auto"), 3.0)
	var voices := LA("breaths", "voice")
	var carls := LA("breaths", "carl")
	var n := 0
	var tries := 0
	var lung := 0.25
	while n < 7 and tries < 40:
		tries += 1
		dive_count.text = L("breaths", "count") % (n + 1)
		dive_voice.text = str(voices[n])
		dive_carl.text = str(carls[n])
		var res: Array = await _one_breath(lung, auto)
		lung = float(res[1])
		if bool(res[0]):
			n += 1
			main.play("ding", -16.0, 0.7 + n * 0.06)
			dive_cue.text = L("breaths", "good")
		else:
			main.play("off", -10.0, 0.6)
			dive_cue.text = L("breaths", "fail")
		await get_tree().create_timer(0.7).timeout
	main.log_line("event", L("breaths", "done_log"))
	dive_mat.set_shader_parameter("flare", 0.0)
	var tw := create_tween()
	tw.tween_method(func(v: float): dive_mat.set_shader_parameter("flare", v), 0.0, 1.0, 1.4)
	tw.tween_property(dive_root, "modulate:a", 0.0, 0.8)
	await tw.finished
	dive_root.visible = false


## One breath: 3 s in, 3 s out. Returns [passed, lung].
func _one_breath(lung0: float, auto: bool) -> Array:
	var t := 0.0
	var good_t := 0.0
	var lung := lung0
	var cyc := 6.0
	while t < cyc:
		await get_tree().process_frame
		var dt := minf(get_process_delta_time(), 0.1 if not main._selftest else 1.0)
		t += dt
		var inhale := t < cyc / 2.0
		var guide := lerpf(0.25, 0.9, t / (cyc / 2.0)) if inhale else lerpf(0.9, 0.25, (t - cyc / 2.0) / (cyc / 2.0))
		var hold: bool = Input.is_action_pressed("interact")
		if auto or main._selftest:
			lung = guide
		else:
			lung = clampf(lung + (1.0 if hold else -1.0) * (0.65 / (cyc / 2.0)) * dt, 0.22, 0.93)
		var ok := absf(lung - guide) < 0.12
		if ok:
			good_t += dt
		dive_mat.set_shader_parameter("guide", guide)
		dive_mat.set_shader_parameter("lung", lung)
		dive_mat.set_shader_parameter("good", 1.0 if ok else 0.0)
		dive_mat.set_shader_parameter("eye", 0.2 + (guide - 0.25) * 0.12)
		dive_cue.text = L("breaths", "in") if inhale else L("breaths", "out")
		dive_cue.add_theme_color_override("font_color", Color(0.75, 1.0, 0.82) if ok else Color(1.0, 0.75, 0.75))
	return [good_t / cyc >= 0.6, lung]


## Then the air changes (ch.21): Mira's recorded voice. +4.
func _mira() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	main.player.shake(0.8)
	ui.glitch(0.8, 1.2)
	main.play("pressure", -6.0, 0.8)
	_gas = maxf(_gas, 0.5)
	await ui.think(L("mira", "shift"))
	await ui.think(L("mira", "here"))
	await ui.think(L("mira", "voice_think"))
	main.play("whisper", -6.0, 1.3)
	await ui.say(L("mira", "who"), "[color=#f0c0d8]" + L("mira", "m1") + "[/color]")
	await ui.think(L("mira", "recorded"))
	var i: int = await ui.choose(LA("mira", "choices"))
	if i == 0:
		await ui.think(L("mira", "broke"))
		await ui.say("Carl", L("mira", "c_reply"))
	else:
		await ui.think(L("mira", "silent"))
	main.play("whisper", -4.0, 1.2)
	await ui.say(L("mira", "who"), "[color=#f0c0d8]" + L("mira", "m2") + "[/color]")
	if i == 0:
		await ui.say("Carl", L("mira", "carl_2"))
	ui.close()
	main.add_connection(4.0, "Mira's voice")
	f["mira_voice_heard"] = true
	main.log_line("event", L("mira", "log"))
	await ui.think(L("mira", "gone"))
	create_tween().tween_property(main.player, "crouch", 1.15, 1.2)
	await ui.think(L("mira", "floor"))
	var tw := create_tween().set_parallel(true)
	for l: OmniLight3D in room_lights:
		tw.tween_property(l, "light_energy", 0.0, 1.2)
	tw.tween_property(tablet_light, "light_energy", 0.0, 1.2)
	tablet_m.albedo_color = Color(0.25, 0.25, 0.25)
	await ui.think(L("mira", "dark"))
	ui.close()
	await ui.fade_to(1.0, 2.0)
	_gas_mode = ""
	_gas = 0.0
	_gas_v = 0.0
	gas_particles.emitting = false
	await ui.think(L("mira", "years"))
	await ui.think(L("mira", "lost"))
	ui.close()
	f["spa_prayer_done"] = true
	_praying = false
	await _morning()


## Day 6, 07:00: the attendant in the faded blue jumpsuit; down to the basement.
func _morning() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	f["cinematic"] = true
	f["spa_morning"] = true
	main.log_line("time", "Day 6, 07:00: the morning cleanse.")
	for l: OmniLight3D in room_lights:
		l.light_energy = 0.9
	tablet_m.albedo_color = Color(0.8, 0.8, 0.8)
	_tele(Vector3(56.0, 0.1, 1.9), 180.0)
	main.player.crouch = 1.15
	main.player.pitch = 0.25
	_room_door(true)
	blue.visible = true
	blue.position = Vector3(55.5, 0, 6.5)
	turn_to(blue, main.player.position)
	trolley_root.visible = true
	set_active(trolley_it, true)
	await ui.show_card(L("cards", "morning"))
	main.play("ding", -10.0, 1.4)
	await ui.think(L("morning", "beep"))
	await ui.say("Attendant", L("morning", "a1"))
	await ui.think(L("morning", "think"))
	await ui.say("Attendant", L("morning", "a2"))
	var i: int = await ui.choose(LA("morning", "choices"))
	if i == 1:
		await ui.think(L("morning", "silent"))
		await ui.say("Attendant", L("morning", "a3"))
		await ui.think(L("morning", "a3_think"))
	create_tween().tween_property(main.player, "crouch", 0.0, 0.8)
	await ui.think(L("morning", "nod"))
	ui.close()
	await ui.fade_to(1.0, 0.8)
	_room_door(false)
	_show(["base"])
	_tele(Vector3(-60.0, 0.1, 3.2), 0.0)
	blue.position = Vector3(-58.9, 0, 3.0)
	turn_to(blue, main.player.position)
	await ui.fade_to(0.0, 0.8)
	await ui.say("Attendant", L("morning", "a4"))
	await ui.think(L("hole", "room"))
	await main.player.face(HOLE, 1.0)
	await ui.say("Attendant", L("hole", "a1"))
	await ui.say("Attendant", L("hole", "a2"))
	await ui.think(L("hole", "a2_think"))
	await ui.say("Carl", L("hole", "carl"))
	await ui.say("Attendant", L("hole", "a3"))
	await ui.say("Attendant", L("hole", "a4"))
	ui.close()
	main.play("door", -8.0, 0.8)
	blue.visible = false
	var tw := create_tween().set_parallel(true)
	tw.tween_property(base_white, "light_energy", 0.0, 2.0)
	tw.tween_property(base_orange, "light_energy", 0.8, 2.5)
	for fl: Node3D in base_fluor:
		fl.visible = false
	await ui.think(L("hole", "gone"))
	ui.close()
	_hole_t = 0.0
	f.erase("cinematic")
	main.update_hud()


## The hole. Frames off: a hole. Frames on: boiling light, and the double.
func _hole() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("spa_hole_jumped"):
		await ui.think(L("hole", "tiles_after"))
		return
	if not f.has("spa_morning"):
		return
	if main.frames_on and _double_k > 0.0:
		if _double_k < 0.97:
			await ui.think(L("hole", "climbing"))
			return
		await ui.think(L("hole", "stare"))
		var i: int = await ui.choose(LA("hole", "face_choices"))
		if i == 1:
			await ui.think(L("hole", "charge"))
			await _dream(true)
		else:
			await ui.think(L("hole", "not_yet"))
		return
	await ui.think(L("hole", "edge"))
	var j: int = await ui.choose(LA("hole", "edge_choices"))
	if j == 0:
		await ui.think(L("hole", "jump"))
		await _dream(false)
	else:
		await ui.think(L("hole", "step_back"))


## The frames see it first: the light boils and the double climbs.
func _reveal() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	f["cinematic"] = true
	main.play("glitch", -6.0, 0.7)
	await ui.think(L("hole", "boil"))
	ui.close()
	await get_tree().create_timer(2.5).timeout
	await ui.think(L("hole", "climb"))
	ui.close()
	f["spa_double_seen"] = true
	main.log_line("event", L("hole", "double_log"))
	f.erase("cinematic")


## The jump is a dream (ch.21): white light, the fractal, Mira. +5.
func _dream(charged: bool) -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	f["cinematic"] = true
	f["spa_hole_jumped"] = true
	ui.close()
	if charged:
		await _walk([HOLE + Vector3(0, 0, 0.6)], 4.5)
	main.player.shake(1.2)
	main.play("static", -2.0, 0.7)
	dream_mat.set_shader_parameter("frac", 0.0)
	dream_mat.set_shader_parameter("dark", 0.0)
	dream_rect.modulate.a = 1.0
	dream_rect.visible = true
	await get_tree().create_timer(0.5).timeout
	_silence(true)
	await ui.think(L("dream", "d1"))
	await ui.think(L("dream", "d2"))
	create_tween().tween_method(func(v: float): dream_mat.set_shader_parameter("frac", v), 0.0, 1.0, 3.0)
	await ui.think(L("dream", "d3"))
	await ui.think(L("dream", "d4"))
	await ui.think(L("dream", "d5"))
	await ui.say("Mira", "[color=#f6e8ff]" + L("dream", "mira") + "[/color]")
	ui.close()
	main.add_connection(5.0, "the hole")
	main.log_line("event", L("dream", "log"))
	dream_mat.set_shader_parameter("dark", 1.0)
	_silence(false)
	main.play("slam", -10.0, 0.6)
	hole_disc.visible = false
	boil_disc.visible = false
	boil_light.light_energy = 0.0
	double.visible = false
	_double_k = 0.0
	_gas_mode = ""
	_gas = 0.0
	_tele(HOLE + Vector3(0.3, 0.1, 0.4), 180.0)
	main.player.crouch = 1.15
	await ui.think(L("dream", "snap"))
	ui.close()
	var tw := create_tween()
	tw.tween_property(dream_rect, "modulate:a", 0.0, 1.6)
	await tw.finished
	dream_rect.visible = false
	await ui.think(L("dream", "wake"))
	blue.visible = true
	blue.position = Vector3(-60.0, 0, 3.3)
	turn_to(blue, main.player.position)
	main.play("door", -8.0, 0.8)
	await main.player.face(blue.global_position + Vector3(0, 1.6, 0), 0.8)
	await ui.say("Attendant", L("dream", "a1"))
	await ui.say("Attendant", L("dream", "a2"))
	ui.close()
	await ui.fade_to(1.0, 0.8)
	blue.visible = false
	main.player.crouch = 0.0
	_show(["up"])
	_tele(Vector3(57.4, 0.1, 4.4), 90.0)
	await ui.show_card(L("cards", "ch22"))
	await ui.think(L("ch22", "t1"))
	await ui.think(L("ch22", "t2"))
	ui.close()
	_pulse_on = true
	set_active(pulse_it, true)
	main.player.face(PULSE_PATH[0], 1.0)
	f.erase("cinematic")
	main.update_hud()


## True silence for the dream: every loop paused.
func _silence(on: bool) -> void:
	for k in main.amb:
		var ap = main.amb[k]
		if is_instance_valid(ap):
			ap.stream_paused = on
	_violin.stream_paused = on
	_whine.stream_paused = on


## Chapter 22: the light walks to the door; the lock; Lynx.
func _lynx_in() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	f["cinematic"] = true
	await ui.think(L("ch22", "pulse"))
	if main.frames_on:
		await ui.think(L("ch22", "pulse_frames"))
	await ui.think(L("ch22", "move"))
	ui.close()
	set_active(pulse_it, false)
	_pulse_moving = true
	var tw := create_tween()
	for k in range(1, PULSE_PATH.size()):
		tw.tween_property(pulse, "position", PULSE_PATH[k], 1.4)
	main.player.face(ROOM_DOOR + Vector3(0, 1.0, 0), 3.0)
	await tw.finished
	await ui.think(L("ch22", "lock"))
	ui.close()
	for k in 3:
		main.play("keys", -6.0, 0.9 + k * 0.1)
		await get_tree().create_timer(0.45).timeout
	_pulse_on = false
	_pulse_moving = false
	pulse.visible = false
	_room_door(true)
	lynx.position = ROOM_DOOR + Vector3(0, 0, 0.9)
	lynx.visible = true
	set_active(lynx_it, true)
	turn_to(lynx, main.player.position)
	await main.player.face(lynx.global_position + Vector3(0, 1.6, 0), 0.6)
	await ui.think(L("ch22", "enter"))
	await ui.say("Lynx", L("ch22", "l1"))
	await ui.say("Carl", L("ch22", "c1"))
	await ui.say("Lynx", L("ch22", "l2"))
	await ui.think(L("ch22", "l2_think"))
	await ui.say("Lynx", L("ch22", "l3"))
	await ui.think(L("ch22", "sleepwalk"))
	await ui.think(L("ch22", "shadow"))
	ui.close()
	f["spa_lynx"] = true
	main.log_line("event", "Lynx came for me at the spa: \"Carl, let's get you the fuck out of here.\"")
	lynx_state = "follow"
	f.erase("cinematic")
	main.update_hud()


## The way out: the front (Lynx's spoof and "we", if Carl knows the word),
## the laundry (sneak), or his badge (suspended; the spa has no Badge route).
func _route() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	f["cinematic"] = true
	await ui.think(L("route", "ask"))
	await ui.say("Lynx", L("route", "lynx"))
	var opts: Array = []
	var keys: Array = []
	if "we" in main.lexicon:
		opts.append(L("route", "front"))
		keys.append("front")
	else:
		await ui.think(L("route", "no_we"))
	opts.append(L("route", "laundry"))
	keys.append("laundry")
	opts.append(L("route", "badge"))
	keys.append("badge")
	var k := "laundry"
	for n in 3:
		var i: int = 0
		if opts.size() > 1:
			i = await ui.choose(opts)
		k = str(keys[i])
		if k != "badge":
			break
		await ui.say("Lynx", L("route", "badge_l"))
		await ui.think(L("route", "badge_think"))
		f["spa_badge_tried"] = true
		opts.remove_at(i)
		keys.remove_at(i)
	ui.close()
	if k == "front":
		await _front_route()
	else:
		await _laundry_route()
	f.erase("cinematic")
	main.update_hud()


func _front_route() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	f["spa_route_front"] = true
	main.log_line("choice", "Out of the spa by the front, with Lynx's spoof.")
	await ui.fade_to(1.0, 0.7)
	_show(["lobby", "street"])
	attendant.position = DESK + Vector3(-0.6, 0, -1.0)
	attendant.rotation.y = PI
	lobby_guard.visible = true
	set_active(guard_it, true)
	_tele(Vector3(-6.0, 0.1, 1.3), 180.0)
	lynx.position = Vector3(-5.0, 0, 1.6)
	lynx_state = "follow"
	await ui.fade_to(0.0, 0.7)
	await ui.think(L("front", "in"))
	await ui.say("Lynx", L("front", "lynx"))
	await ui.think(L("front", "staff"))
	ui.close()
	lynx_state = "stand"
	lynx_target = Vector3(1.0, 0, 11.0)
	main.update_hud()


## At the front door: the spoof, and the word.
func _front_out() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	f["cinematic"] = true
	lynx.position = Vector3(1.0, 0, 11.0)
	await ui.think(L("front", "spoof"))
	main.play("tap", -8.0, 1.2)
	if not main.frames_on:
		main.toggle_frames()
	await main.player.face(lobby_guard.global_position + Vector3(0, 1.6, 0), 0.6)
	await ui.think(L("front", "we"))
	main.play("glitch", -8.0, 1.3)
	main.ui.glitch(0.5, 0.5)
	main.add_connection(2.0, "we")
	await ui.think(L("front", "we_2"))
	ui.close()
	_front_door(true)
	await ui.think(L("front", "out"))
	ui.close()
	main.log_line("event", L("front", "log"))
	await _walk([Vector3(0, 0, 11.0), Vector3(0, 0, 14.2)], 1.8)
	await _outside()


func _laundry_route() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	f["spa_route_laundry"] = true
	main.log_line("choice", "Out of the spa through the laundry corridor.")
	await ui.fade_to(1.0, 0.7)
	_show(["laundry"])
	_tele(LAUNDRY_START + Vector3(0, 0.1, 0), -90.0)
	lynx.position = LAUNDRY_START + Vector3(0.6, 0, 0.9)
	lynx_state = "stand"
	lynx_target = lynx.position
	for g: Dictionary in guards:
		_reset_guard(g)
	await ui.fade_to(0.0, 0.7)
	await ui.think(L("laundry", "in"))
	await ui.say("Lynx", L("laundry", "lynx"))
	ui.close()
	ui.show_toast(L("laundry", "cue"), 6.0)
	lynx.position = BACK_DOOR + Vector3(-0.9, 0, 0.9)
	lynx_target = lynx.position
	main.update_hud()


func _reset_guard(g: Dictionary) -> void:
	var fig: Node3D = g["fig"]
	fig.position = g["a"]
	g["to_b"] = true
	g["wait"] = 0.0
	turn_to(fig, g["b"])


## The guard's frames: a cone of 40 degrees, nine metres, and no wall between.
func _sees(g: Dictionary) -> bool:
	var fig: Node3D = g["fig"]
	var eye_p := fig.global_position + Vector3(0, 1.6, 0)
	var pp: Vector3 = main.player.global_position + Vector3(0, 1.4, 0)
	var d := pp - eye_p
	if d.length() > 9.0:
		return false
	var fwd := -fig.global_transform.basis.z
	fwd.y = 0.0
	var dir := Vector3(d.x, 0, d.z).normalized()
	if fwd.normalized().dot(dir) < cos(deg_to_rad(40.0)):
		return false
	var q := PhysicsRayQueryParameters3D.create(eye_p + dir * 0.35, pp, 1)
	var hit := get_world_3d().direct_space_state.intersect_ray(q)
	return hit.is_empty()


## Seen: the hand on the elbow, back to the stair door. No game over.
func _caught(g: Dictionary) -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	_seen_busy = true
	f["spa_seen"] = int(f.get("spa_seen", 0)) + 1
	main.add_pressure(5.0, "seen by spa security")
	f["cinematic"] = true
	g["wait"] = 99.0
	var fig: Node3D = g["fig"]
	turn_to(fig, main.player.global_position, 0.3)
	main.play("sting", -10.0, 1.1)
	await main.player.face(fig.global_position + Vector3(0, 1.6, 0), 0.4)
	await ui.say("Attendant", L("laundry", "seen_a" if int(f["spa_seen"]) % 2 == 1 else "seen_b"))
	await ui.think(L("laundry", "seen_think"))
	ui.close()
	main.log_line("event", L("laundry", "seen_log"))
	await ui.fade_to(1.0, 0.5)
	_tele(LAUNDRY_START + Vector3(0, 0.1, 0), -90.0)
	for gg: Dictionary in guards:
		_reset_guard(gg)
	await ui.fade_to(0.0, 0.5)
	f.erase("cinematic")
	_seen_busy = false


func _laundry_out() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	f["cinematic"] = true
	await ui.think(L("laundry", "back_door"))
	ui.close()
	main.play("door", -6.0, 0.8)
	await ui.fade_to(1.0, 0.6)
	_show(["street", "lobby"])
	area = "street"
	_tele(ALLEY + Vector3(0, 0.1, 0), 180.0)
	lynx.position = ALLEY + Vector3(-0.6, 0, 1.2)
	lynx_state = "follow"
	await ui.fade_to(0.0, 0.6)
	await ui.think(L("laundry", "out"))
	ui.close()
	main.log_line("event", L("laundry", "log"))
	await _outside()


## The street again, and the car.
func _outside() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	f["spa_out"] = true
	f["cinematic"] = true
	area = "street"
	_car_crew()
	await ui.think(L("car", "out"))
	await ui.think(L("car", "out_2"))
	ui.close()
	set_active(car_it, true)
	lynx_state = "stand"
	lynx_target = CAR_AT + Vector3(-2.6, 0, -1.4)
	f.erase("cinematic")
	main.update_hud()


func _car_crew() -> void:
	var f: Dictionary = main.flags
	car.visible = true
	var crew := f.has("lushons_done")
	turan.visible = crew
	emmet.visible = crew
	turan.position = CAR_AT + Vector3(0.6, 0, -1.4)
	emmet.position = CAR_AT + Vector3(2.4, 0, -1.3)
	turn_to(turan, Vector3(0, 0, 13.0))
	turn_to(emmet, Vector3(4.0, 0, 12.0))
	for ci: CollisionObject3D in crew_its:
		set_active(ci, crew)


func _car() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if _ended or not f.has("spa_out"):
		await ui.think(L("car", "car"))
		return
	_ended = true
	f["cinematic"] = true
	await main.player.face(car.global_position + Vector3(0, 1.0, 0), 0.6)
	if f.has("lushons_done"):
		await ui.think(L("car", "crew"))
		await ui.say("Turan", L("car", "t1"))
		await ui.think(L("car", "t1_think"))
		await ui.say("Carl", L("car", "c1"))
		await ui.say("Turan", L("car", "t2"))
		await ui.think(L("car", "missing"))
		await ui.say("Carl", L("car", "c2"))
		await ui.say("Turan", L("car", "t3"))
		await ui.say("Emmet", L("car", "e1"))
		await ui.say("Turan", L("car", "t4"))
	else:
		await ui.think(L("car", "alone"))
		await ui.say("Lynx", L("car", "l1"))
		await ui.say("Lynx", L("car", "l2"))
	ui.close()
	main.play("door", -6.0, 1.0)
	await ui.fade_to(1.0, 0.8)
	main.play("engine", -10.0, 1.0)
	ui.caption(L("cards", "drive_cap"), 3.0)
	main.log_line("event", L("car", "log"))
	main.log_line("time", "Day 6, 09:10: out of the spa, to Cognizo.")
	f["spa_done"] = true
	f.erase("cinematic")
	main.update_hud()
	if not main._selftest:
		main.load_level("Cognizo")
	else:
		await ui.fade_to(0.0, 0.3)


# ------------------------------------------------------------------ HUD

func objective() -> String:
	var f: Dictionary = main.flags
	var o: Dictionary = LINES["objective"]
	if f.has("spa_done"):
		return o["done"]
	if f.has("spa_out"):
		return o["car"]
	if f.has("spa_route_laundry"):
		return o["laundry"]
	if f.has("spa_route_front"):
		return o["front"]
	if f.has("spa_lynx"):
		return o["stairs"]
	if _pulse_on:
		return o["pulse"]
	if f.has("spa_hole_jumped"):
		return o["wait"]
	if f.has("spa_morning"):
		return o["hole"] if main.frames_on else o["hole_frames"]
	if _praying or f.has("spa_prayer_done"):
		return o["prayer"]
	if _gas_mode == "refused":
		return o["gas"]
	if f.has("spa_room"):
		return o["room"]
	if f.has("spa_checked_in"):
		return o["room_in"]
	if f.has("spa_arrived") and main.player.position.z < 12.2:
		return o["desk"]
	return o["street"]


func phone() -> String:
	var f: Dictionary = main.flags
	var ph: Dictionary = LINES["phone"]
	if f.has("spa_lynx"):
		return ph["escape"]
	if f.has("spa_morning"):
		return ph["morning"]
	if _gas_mode == "refused":
		return ph["gas"]
	return ph["night"]


# ------------------------------------------------------------------ the frame loop

func tick(delta: float) -> void:
	if main == null or main.player == null:
		return
	var f: Dictionary = main.flags
	var pp: Vector3 = main.player.global_position
	_tick_violin(delta)
	_tick_gas(delta)
	_tick_street(delta)
	_tick_people(delta, pp)
	_tick_hole(delta, pp)
	if _pulse_on:
		var on := fmod(_t, 0.55) < 0.12
		pulse.visible = on
		pulse_light.light_energy = 2.5 if on else 0.0
	if area == "laundry" and f.has("spa_route_laundry") and not f.has("spa_out"):
		_tick_guards(delta)
		if not _seen_busy and not main.ui.busy and not f.has("cinematic"):
			for g: Dictionary in guards:
				if _sees(g):
					_caught(g)
					break
	if f.has("spa_arrived") and not f.has("spa_checked_in") and area == "street" and pp.z < 11.8:
		area = "lobby"
		main.update_hud()
	elif area == "lobby" and pp.z > 12.5:
		area = "street"


## The lavender: refused, it comes harder for a minute and then the prayer
## happens anyway; in the tiled room it pushes. A slow tint, a high whine.
func _tick_gas(delta: float) -> void:
	var f: Dictionary = main.flags
	if _gas_mode == "refused":
		_gas_t += delta
		_gas = clampf(_gas_t / 60.0, 0.0, 1.0) * 0.85
		var cues := [[12.0, "Tablet: " + L("prayer", "wait_1")], [24.0, L("prayer", "gas_1")], [36.0, "Tablet: " + L("prayer", "wait_2")], [48.0, L("prayer", "gas_2")]]
		for c: Array in cues:
			if _gas_t - delta < float(c[0]) and _gas_t >= float(c[0]):
				main.ui.caption(str(c[1]), 3.5)
				main.player.shake(0.15)
		if _gas_t >= 60.0 and not _praying and not main.ui.busy and not f.has("cinematic"):
			_prayer(true)
	_gas_v = move_toward(_gas_v, _gas, delta * 0.12)
	gas_rect.color.a = _gas_v * 0.4
	_whine.volume_db = -80.0 if _gas_v < 0.02 else lerpf(-44.0, -14.0, _gas_v)
	# the gas breathes the room in and out a little
	main.player.cam.fov = lerpf(main.player.cam.fov, 72.0 + (sin(_t * 0.7) * 3.0 * _gas_v if _gas_v > 0.4 else 0.0), 0.05)


func _tick_street(delta: float) -> void:
	if not (areas["street"] as Node3D).visible:
		return
	for d: Array in drones:
		var n: Node3D = d[0]
		var base: Vector3 = d[1]
		if float(d[3]) <= 0.0:
			n.position = base + Vector3(sin(_t * 0.3) * 2.0, sin(_t * 1.3) * 0.15, cos(_t * 0.23) * 1.2)
			n.rotation.y = sin(_t * 0.2) * 0.8
		else:
			n.position = Vector3(-60.0 + fmod(base.x + 60.0 + _t * float(d[3]), 120.0), base.y + sin(_t + float(d[2])) * 0.3, base.z)
			n.rotation.y = -PI / 2.0
	for h: Array in hover:
		var c: Node3D = h[0]
		c.position.x += float(h[1]) * delta
		if c.position.x > 70.0:
			c.position.x = -70.0
		elif c.position.x < -70.0:
			c.position.x = 70.0


func _tick_people(delta: float, pp: Vector3) -> void:
	var head := pp + Vector3(0, 1.6, 0)
	if attendant.visible:
		Anim.idle(attendant, _t, 0.4)
		Anim.look(attendant, head, 0.9 if pp.distance_to(attendant.global_position) < 8.0 else 0.0, 0.05)
	if blue.visible:
		Anim.idle(blue, _t, 1.3)
		Anim.look(blue, head, 0.8, 0.05)
	if lobby_guard.visible:
		Anim.idle(lobby_guard, _t, 2.1)
		Anim.look(lobby_guard, head, 1.0, 0.06)
	for fig: Node3D in [turan, emmet]:
		if fig.visible:
			Anim.idle(fig, _t, 0.7)
			Anim.look(fig, head, 0.7 if pp.distance_to(fig.global_position) < 9.0 else 0.0, 0.04)
	_tick_lynx(delta, pp)


## Lynx, as in Southtown: a pace behind Carl, kept inside the room he is in.
func _tick_lynx(delta: float, pp: Vector3) -> void:
	if lynx_state == "hidden" or not lynx.visible:
		return
	var target := lynx_target
	if lynx_state == "follow":
		var p = main.player
		target = pp + Basis(Vector3.UP, p.yaw) * Vector3(-0.8, 0, 1.3)
		var r := Rect2(-48.0, 12.8, 96.0, 18.0)
		match area:
			"up":
				r = Rect2(50.6, 6.5, 18.8, 1.4) if pp.z > 6.0 else Rect2(53.4, -0.5, 5.2, 6.1)
			"lobby":
				r = Rect2(-8.5, 0.6, 17.0, 11.0)
			"laundry":
				r = Rect2(-51.5, -40.6, 33.0, 1.8)
		target.x = clampf(target.x, r.position.x, r.end.x)
		target.z = clampf(target.z, r.position.y, r.end.y)
	target.y = 0.0
	var d := target - lynx.position
	d.y = 0.0
	var dist := d.length()
	if dist > 0.4:
		var speed := clampf(dist * 2.0, 1.1, 4.6)
		lynx.position += d.normalized() * minf(speed * delta, dist)
		lynx.rotation.y = lerp_angle(lynx.rotation.y, atan2(-d.x, -d.z), minf(1.0, delta * 8.0))
		Anim.walk(lynx, _t, speed / 2.4, 0.0, 1.0)
	else:
		Anim.idle(lynx, _t, 1.0)
		Anim.look(lynx, pp + Vector3(0, 1.6, 0), 0.8, 0.05)


## The tiled room: the frames buzz, the gas pushes, and with the frames on
## the hole boils and the double climbs out of it.
func _tick_hole(delta: float, pp: Vector3) -> void:
	var f: Dictionary = main.flags
	if area != "base" or not f.has("spa_morning") or f.has("spa_hole_jumped"):
		return
	if not f.has("cinematic"):
		_hole_t += delta
		if _hole_t - delta < 5.0 and _hole_t >= 5.0 and not main.frames_on:
			main.ui.show_toast(L("hole", "buzz"), 4.0)
			main.play("tap", -10.0, 0.6)
		if _hole_t - delta < 25.0 and _hole_t >= 25.0:
			_gas_mode = "hole"
			_gas = 0.45
			main.ui.caption(L("hole", "gas"), 5.0)
		if _hole_t - delta < 18.0 and _hole_t >= 18.0 and not main.frames_on:
			main.ui.show_toast(L("hole", "buzz"), 4.0)
			main.play("tap", -8.0, 0.6)
	var on: bool = main.frames_on
	boil_disc.visible = on
	boil_light.light_energy = 0.7 + sin(_t * 3.0) * 0.25 if on else 0.0
	if on:
		if not _double_seen and not main.ui.busy and not f.has("cinematic"):
			_double_seen = true
			_reveal()
		_double_k = move_toward(_double_k, 1.0, delta / 7.0)
	double.visible = on and _double_k > 0.0
	if double.visible:
		var e := smoothstep(0.0, 1.0, _double_k)
		double.position = HOLE + Vector3(0, lerpf(-1.95, 0.0, e), 0)
		turn_to(double, pp)
		var arm_k := clampf((_double_k - 0.55) / 0.45, 0.0, 1.0)
		for a: Node3D in double.get_meta("arms"):
			a.rotation.x = lerpf(-2.9, -0.15, arm_k)
			a.rotation.z = (0.25 if a.position.x > 0.0 else -0.25) * (1.0 - arm_k)
		Anim.look(double, pp + Vector3(0, 1.6, 0), 1.0, 0.2)
		var body: Node3D = double.get_meta("body")
		body.rotation.x = lerpf(0.5, 0.0, arm_k)


func _tick_guards(delta: float) -> void:
	for g: Dictionary in guards:
		var fig: Node3D = g["fig"]
		if float(g["wait"]) > 0.0:
			g["wait"] = float(g["wait"]) - delta
			Anim.idle(fig, _t, 0.3)
			if float(g["wait"]) <= 0.0:
				g["to_b"] = not bool(g["to_b"])
			continue
		var target: Vector3 = g["b"] if bool(g["to_b"]) else g["a"]
		var d := target - fig.position
		d.y = 0.0
		if d.length() < 0.08:
			g["wait"] = 1.8
			continue
		fig.position += d.normalized() * minf(float(g["speed"]) * delta, d.length())
		fig.rotation.y = lerp_angle(fig.rotation.y, atan2(-d.x, -d.z), minf(1.0, delta * 5.0))
		Anim.walk(fig, _t, 0.9, 0.0, 1.0)


# ------------------------------------------------------------------ selftest

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
	if not cond.call():
		print("WARN wait timed out after ", secs)


func _frames(on: bool) -> void:
	if main.frames_on != on:
		main.toggle_frames()


func selftest() -> void:
	var f: Dictionary = main.flags
	var p = main.player
	f["pip_active"] = true
	# the car with Turan and Emmet first (Lushon's happened), Lynx alone later
	var had: bool = f.has("lushons_done")
	f["lushons_done"] = true
	# the shared machine renders this at a few frames a second; the test is of
	# the script, so the level is hidden while it runs (as Observatory does)
	visible = false
	await intro()
	print("ok intro")
	for id in ["reader", "sign", "trees", "mist", "ad", "street"]:
		await _by_id(id)
	await _by_id("spa_door")
	p.position = Vector3(0, 0.1, 9.0)
	for id in ["diffuser", "eren", "violin", "kiosk", "plaque", "notice", "guestbook", "rug", "stair_door"]:
		await _by_id(id)
	await _by_id("attendant")
	print("ok checkin room=", f.has("spa_room"), " area=", area)
	for id in ["window", "room_door", "tv", "freudbot", "vent", "mat", "tablet"]:
		await _by_id(id)
	print("ok prompted=", _prompted, " gas=", _gas_mode)
	# the selftest refused (choice 2): the gas, then the prayer forced at 60 s
	await _wait(func() -> bool: return _praying or f.has("spa_prayer_done"), 90.0)
	print("ok forced praying=", _praying, " gas_v=", snappedf(_gas_v, 0.01))
	await _wait(func() -> bool: return f.has("mira_voice_heard"), 160.0)
	print("ok mira conn=", main.connection)
	await _wait(func() -> bool: return area == "base" and not f.has("cinematic"), 160.0)
	print("ok morning area=", area)
	for id in ["tile_door", "tiles"]:
		await _by_id(id)
	_frames(false)
	await _by_id("hole")  # frames off: step back (choice 2)
	await _wait(func() -> bool: return _hole_t > 26.0, 40.0)
	print("ok hole gas=", _gas_mode)
	_frames(true)
	await _wait(func() -> bool: return _double_k >= 0.99 and not f.has("cinematic"), 40.0)
	print("ok double seen=", f.has("spa_double_seen"))
	await _by_id("hole")  # frames on: charge it (choice 2)
	print("ok dream jumped=", f.has("spa_hole_jumped"), " conn=", main.connection)
	await _wait(func() -> bool: return _pulse_on and not f.has("cinematic"), 60.0)
	await _by_id("pulse")
	print("ok lynx=", f.has("spa_lynx"))
	p.position = Vector3(66.0, 0.1, 7.2)
	for id in ["trolley", "hall_doors", "lynx"]:
		await _by_id(id)
	await _by_id("stairs")  # with "we" known choice 2 is the laundry; else the badge, then the laundry
	print("ok route laundry=", f.has("spa_route_laundry"), " front=", f.has("spa_route_front"), " badge=", f.has("spa_badge_tried"))
	if not f.has("spa_route_laundry"):
		f.erase("spa_route_front")
		await _laundry_route()
	# seen: stand in front of the first attendant
	for id in ["washers", "carts", "shelves", "guard0"]:
		await _by_id(id)
	_reset_guard(guards[0])
	var seen0 := int(f.get("spa_seen", 0))
	p.position = Vector3(-42.0, 0.1, -40.0)
	await _wait(func() -> bool: return int(f.get("spa_seen", 0)) > seen0 and not _seen_busy, 30.0)
	print("ok seen=", f.get("spa_seen", 0), " at=", p.position)
	p.position = BACK_DOOR + Vector3(-1.4, 0.1, 0.0)
	for g: Dictionary in guards:
		g["wait"] = 999.0
	await _by_id("back_door")
	print("ok out=", f.has("spa_out"), " area=", area)
	await _by_id("car")
	print("ok car done=", f.has("spa_done"), " crew=", turan.visible)
	# the front way out, for the script's sake
	f.erase("spa_out")
	f.erase("spa_done")
	f.erase("spa_route_laundry")
	_ended = false
	main.learn("we")
	await _front_route()
	for id in ["lobby_reader", "lobby_guard", "attendant"]:
		await _by_id(id)
	await _by_id("front_door")
	print("ok front out=", f.has("spa_out"), " conn=", main.connection)
	# and the car without Lushon's: Lynx alone
	f.erase("lushons_done")
	_car_crew()
	_ended = false
	await _by_id("car")
	print("ok car alone done=", f.has("spa_done"))
	if had:
		f["lushons_done"] = true
	# the accepted prayer path's lines, and the badge route refused
	_praying = false
	f.erase("cinematic")
	await main.selftest_all_interactables()
	visible = true
	print("SPA flags: ", f.keys())
