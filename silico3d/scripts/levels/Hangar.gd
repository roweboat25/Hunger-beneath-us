extends "res://scripts/Level.gd"
## Chapters 13 and 14: the hangar under the desert facility. Bible A2-S2
## (rung three, grief). Book: "The stairway opened into a room so vast it
## felt less like a basement and more like a hangar carved from the
## bedrock." One industrial fixture on a chain, "a weak, lonely circle of
## light"; the rest given to the dark. On the far wall an eye ten feet
## across woven from sticks and branches. Under the light a plush black
## leather recliner, two thick cables down from the dark with rust-red tips.
## The altar. Then Mira's song, in the air and not the tech; footsteps from
## everywhere; the office with the window ("If we can't escape, we hide");
## a hundred hooded figures filing into a circle; three in white: Subject 41
## masked, an acolyte with the black cube, Eren Elontiel with the bowl. The
## probes. The vision through the frames (the Mandelbrot, the voice, the sea
## of lights that becomes the Eye and looks at Carl with sorrow). Lynx slaps
## the frames off: "Carl, you were singing." The sermon with the frames off
## ("We made Him, and He made us"); Subject 1256's eyes; "I see him. He is
## behind everything." The frames back on, or not: 1395 has Carl's face.
## "And now, the Mimic has returned." Every figure turns. They do not chase;
## they stare. The walk back up past the eyeless, the eye-layer door at the
## top, dusk, the moon, the car. "Fuck my car, just drive."
##
## Layout (metres). The cavern is x -56..30, z -28..46, 18 m high; the altar
## (the recliner) at the origin facing north-east, the stick eye on the south
## wall behind it. The stair comes down the north wall: a black-brick
## stairwell from the eye-layer door at the top (y 12, z 76.5) down to a
## landing (y 9, z 46..52), then the open stair with brick parapets to the
## floor at z 26. The office is raised on steel legs against the east wall
## (x 20.5..30, z -7..5, floor y 2.2), its window on the west face over the
## floor; a steel stair up its north side. The drill housing is against the
## north wall west of the stair, and behind it the service door to the drill
## crews' ramp, which climbs to y 12 and joins the top landing from the west
## (the second corridor). A catwalk runs the east wall at 7 m. Outside, far
## off at OUT, the facility's lot at dusk: the moon, the cars, the desert,
## the city on the horizon.
##
## Flags read: facility_done (entry), main.trust["lynx"] (when Lynx slaps
## the frames off). Flags set: hangar_vast, hangar_mural, hangar_altar,
## hangar_song, hangar_hid_office | hangar_hid_drill, hangar_seen,
## hangar_eren, ev_eren_altar, ev_tunelet_ledger, hangar_vision,
## hangar_saw_eye, hangar_sermon, hangar_1395_face | hangar_frames_kept_off,
## hangar_mimic, hangar_touched, hangar_outside, hangar_done; learns "we".
## Next: Home (visit 3). Hooks for the systems that come later: metas
## "cultist" (the congregation, the three in white, the devotees),
## "eyeless", "hackable" (the fixture's box, the probes, the terminal, the
## car) and "route" (the catwalk, the service ramp, under the office).

const CarS := preload("res://scripts/Car.gd")

## Every line in the level, keyed by beat and line (bible A2-S2; the
## verbatim lines are the book's).
const LINES := {
	"cards": {
		"chapter": "[b]CHAPTER 13[/b]\n\n[color=#aaaaaa]The hangar\nbeneath the facility  -  Day 3, 20:00[/color]",
		"probes": "[b]CONTENT SETTING[/b]\n\n[color=#aaaaaa]Without warning, his hands shot up, seizing the two red-tipped wires that dangled before him. In one swift, brutal motion, he slammed the metal probes into the empty holes where his eyes used to be.[/color]",
		"removal": "[b]CONTENT SETTING[/b]\n\n[color=#aaaaaa]With that, the prophet's blade descends on her face.\nThe frame is withheld. The sound is not.[/color]",
		"drive_cap": "Day 3, 22:00  -  the road back to Silico",
	},
	"intro": {
		"think": "We rounded the corner and took the next set of stairs, the air growing colder and heavier with each step down.",
		"think_2": "The concrete walls gave way to rough, black brick that seemed to drink the light, and the silence deepened until all I could hear was the soft scuff of our boots.",
		"floor": "The stairway opened into a room so vast it felt less like a basement and more like a hangar carved from the bedrock.",
		"floor_2": "A single, industrial lighting fixture hummed far above, casting a weak, lonely circle of light onto the floor. The immense space around it fell away into an oppressive darkness, leaving the corners to imagination and dread.",
		"floor_3": "My gaze was drawn to the far wall, where a gigantic mural was hung.",
	},
	"examine": {
		"mural": "It was an eye, ten feet across, woven from a chaotic lattice of sticks and branches. It was a piece of primal, pagan art, and it stared out from the shadows with a blind, all-seeing menace.",
		"mural_carl": "Guess we know where Dufredy got his inspiration.",
		"mural_2": "Lynx didn't answer. She didn't even seem to hear me. Her attention was already captured, her gaze locked on the exact center of the room, directly under the light.",
		"mural_after": "The eye. Sticks and wire and branches, bound by hand. Somebody had spent a long time on it, and somebody kept it mended.",
		"mural_log": "A stick eye ten feet across on the hangar's south wall: Dufredy's ceiling, at scale.",
		"recliner": "At first, I thought it was just a chair, some piece of abandoned office furniture. As we drew closer, its form became clearer, and the sight was so jarringly mundane it was unsettling: a plush, black leather recliner.",
		"recliner_1": "It sat there like a throne awaiting its king.",
		"recliner_2": "Then I saw the wires. Two thick cables descended from the cavernous darkness of the ceiling, terminating precisely where a person's head would rest against the recliner's back. They were probes of some kind, clinical and cruel.",
		"recliner_3": "And their tips, down to the last inch, were stained a dark and flaking rust-red.",
		"recliner_4": "There was no doubt. This wasn't just a lab. This was the altar.",
		"recliner_after": "The throne. Dried blood on the probes, older than tonight's, and tonight's on top of it.",
		"recliner_log": "A recliner under the hangar light with two BCI probes from the ceiling, tips stained rust-red. The altar.",
		"fixture": "One fixture, hung on a chain from a ceiling I couldn't see, and its box down here on the wall with a Voltx plate. It hummed. Everything else in the room had been given to the dark on purpose.",
		"stair": "Black brick, older than the concrete above it. Somebody had cut this out of the rock before Silico was a word, and somebody else had kept it.",
		"catwalk": "A steel stair up to a catwalk that ran the length of the east wall in the dark, over the office roof. A way round the room, if we needed one.",
		"service": "A service door in the north wall, the kind the drill crews used. Behind it a ramp climbed back toward the surface, parallel to the stairs.",
		"service_song": "I put my ear to the service door. Footsteps on the ramp behind it, coming down. Not that way.",
		"service_early": "The drill crews' ramp. I hadn't come this far down to leave before I'd seen the room.",
		"service_after": "The drill crews' ramp. It came out at the top beside the landing. Fewer of them this way, maybe.",
		"drill": "The housing of a boring drill, big as a van, cold for twenty years. Through the frames the gap behind it lit up: room for two people to crouch, and the service door at its back.",
		"drill_off": "A machine in the dark. Without the frames I couldn't see a way behind it.",
		"drill_early": "A boring drill on its rails, pointing at nothing. Twenty years of dust on the housing.",
		"desk": "A heavy oak desk. Brittle, decaying paper, a ledger with the Tunelet mark, the last entry dated nineteen years ago. The air was thick with the smell of dust.",
		"desk_log": "A Tunelet ledger in the hangar office: the last entry nineteen years ago, the year of the joint exploration report.",
		"terminal": "An Ionware box under the desk, beige gone brown. Dead. Somebody had pulled its drive and left the cable hanging like a tongue.",
		"window": "A large window overlooking the main floor. The glass was grimy, the recliner small under its light at the center, the dark everywhere else.",
		"window_after": "They were still there. A hundred of them, turned to the glass, not moving. They weren't going to chase us. They were going to watch.",
		"office_stuck": "A dark rectangle on the far wall I hadn't noticed before. A door, up a steel stair. Stuck in its frame, and nothing on the other side I wanted yet.",
		"office_out": "The office door, open the way Lynx had left it. I wasn't going back in.",
		"under_office": "Under the office, between its steel legs: a crawlspace of dark and old cable. A place to be small in, later, if there was a later.",
		"congregation": "A hundred of them. Hoods, robes, three kinds of shape under the cloth: the tall ones, the stooped ones, the ones that had folded in on themselves. Not one face.",
		"congregation_off": "A hundred robed figures, silent, staring upward at nothing.",
		"prophet": "Subject 41. The man from the video log. He didn't need eyes to know where I was.",
		"prophet_off": "A man in a chair with metal plugs in his face.",
		"eren": "Eren Elontiel, the heir, in a white robe, in a basement, like an altar boy. His fingers were trembling.",
		"acolyte": "The one with the cube. Gloved hands, and the cube took the light out of the air around it.",
		"subject": "A hood, head down, waiting by the throne.",
		"eyeless": "No eyes. The sockets had healed over the way skin heals over a burn. The head turned to follow me and the neck made no sound.",
		"eyeless_dark": "A shape against the parapet that didn't move. In the dark it could have been a coat on a hook. I didn't look.",
		"moon": "A full moon, rising on the horizon. The first clean light I'd seen all day.",
		"lot": "The facility's lot. Concrete barriers, a dead lamp, the sand coming back over everything.",
		"lynx_car": "Lynx's car, where she'd left it, already sanding over. She didn't look at it.",
		"my_car_after": "Drive.",
		"bunker": "The way we'd come out. I didn't look at it either.",
	},
	"lynx": {
		"start": "Keep moving. Don't touch the walls.",
		"floor": "Carl. Under the light.",
		"wait": "Carl. Here. Now.",
		"hidden": "Don't. Don't open it.",
		"after": "Don't talk to me. Walk.",
		"escape": "Walk. Don't run. They aren't coming.",
		"outside": "The car. Carl, the car.",
		"scan": "LYNX (ANALYST, PSYONIC)\nORA gen 6: NOT WORN\nsync: --  -  AWAKE",
	},
	"song": {
		"think": "Then a melody reached my ears, slithering out of the vast, surrounding darkness. It was low, distorted, and full of the same humming, static-laced overtones I'd heard in my HUD.",
		"think_2": "Mira's song.",
		"think_3": "My hand shot to my face, ripping the glasses off with a practiced, desperate motion. I stood there, half-blind in the dim light, my heart hammering against my ribs.",
		"think_3b": "My hand shot to my face for glasses that weren't there. I stood there, half-blind in the dim light, my heart hammering against my ribs.",
		"think_4": "The song remained.",
		"think_air": "It wasn't in my tech. It was in the air, in the room, vibrating through the soles of my feet.",
		"think_5": "I looked at Lynx. All the color had drained from her face. Her usual mask of hardened composure was gone, replaced by the wide-eyed, primal fear of a cornered animal. She heard it, too. That look, more than anything, confirmed it. They were coming.",
		"carl": "Did they know we were here?",
		"carl_2": "The stairs we came down. Is there another way out? There must be another way out.",
		"think_6": "The ghostly melody grew louder, the childish tune twisting into something monstrous. It was joined by another sound: a wet, shuffling scrape. The sound of footsteps. Not one pair, but dozens, dragging themselves through the darkness toward the light.",
		"think_7": "They weren't just coming from the stairs. They were coming from everywhere. They were closing in.",
		"think_8": "We were going to die.",
		"lynx_2": "There! If we can't escape, we hide. Now!",
		"toast": "Hide. The office with the window, or behind the drill housing (frames on).",
		"log": "Mira's song in the hangar, in the air, not the tech. Lynx heard it too.",
	},
	"hide": {
		"office": "We crashed through it, slamming it shut behind us. The noise from the hangar was instantly muffled, replaced by a sudden, profound silence.",
		"office_2": "To my surprise, we were standing in what looked like a pre-war factory office, complete with a heavy oak desk and a large window overlooking the main floor. The air was thick with the smell of dust and brittle, decaying paper. It wasn't an escape, but it was cover.",
		"office_3": "Lynx still hadn't released my hand. I could feel the tremors running through her arm; her skin was ice-cold. She was just as terrified as I was.",
		"drill": "We went down behind the housing together and stayed there. Twenty years of cold came off the steel. From here the floor was a slice between the drill and the wall, the recliner small under its light.",
		"drill_2": "Lynx hadn't let go of my hand. Behind us, a metre away, the service door. If it came to it, that was the way.",
		"seen": "One of them turned its hood toward me. Lynx had my hand before I had a thought, and pulled, and we flew across the cold concrete floor, the black recliner flashing past us in a blur, toward the dark rectangle on the far wall.",
		"seen_toast": "Seen in the open.",
		"seen_log": "Caught in the open by the hangar congregation; Lynx dragged me to the office.",
		"filing": "Drawn by a morbid need to see our fate, I crept to the window and peered through the grimy glass, feeling like a condemned man waiting for the final verdict.",
		"filing_drill": "Drawn by a morbid need to see our fate, I put my eye to the gap between the drill and the wall, feeling like a condemned man waiting for the final verdict.",
		"filing_2": "The song outside grew louder, more hypnotic. Then, at the top of the stairwell, a silhouette appeared: a hooded figure, moving with a slow, dreamlike purpose. It was followed by another, and another, a silent, inexorable tide of bodies pouring into the cavernous room.",
		"filing_3": "The room began to fill. They moved with a chilling synchronicity, each one seeming to know their place without a word. They formed a wide, reverent circle, a living amphitheater of robed figures, leaving an open path that led directly to the black throne.",
		"buzz": "As if on cue, I felt a vibration against my leg. My glasses, buzzing in my pocket.",
		"buzz_2": "A part of me screamed to leave them, to not look through that cursed lens again. But a deeper, more insistent part, the part that had led me this far down, knew I had to. I had to see it all.",
		"buzz_3": "I slid them on.",
		"buzz_on": "The lenses buzzed against my temples. They had been on the whole time. Something had found them.",
		"grain": "My HUD flickered to life, but it was different. The world seen through the glasses was now covered in a subtle, shimmering film grain, as if I were watching an old, degraded recording of reality.",
	},
	"ceremony": {
		"heads": "Outside, the congregation raised their heads as one. The humming melody stopped, replaced by a low, guttural chanting that vibrated through the glass, rising in pitch and volume with every passing second.",
		"heads_2": "The chanting rose, and the ritual began.",
		"three": "Three figures in stark white robes began their descent down the stairwell, a stark contrast to the dark-clad congregation. The one in the center walked with a chilling purpose, his face hidden behind a blank, ceremonial mask.",
		"s41": "My blood ran cold. It was him. Subject 41 from the video log. The man whose self-mutilation we had witnessed. We had found him.",
		"acolytes": "He was flanked by two unmasked acolytes. One cradled a perfect black cube in his gloved hands, its surface seeming to absorb the very light around it. The other held a simple ceramic bowl filled with a dark, shimmering liquid.",
		"eren": "As this second man stepped into the weak light, my mind reeled with a blow of recognition that was sharper than any fear.",
		"eren_2": "Eren Elontiel. The sole heir to the Psyonic empire, son of the current CEO, Marcus Elontiel. He was here, serving as an acolyte in a basement cult. This wasn't some rogue splinter group. The rot was at the very top.",
		"eren_cap": "EREN ELONTIEL  -  the bowl",
		"eren_log": "Eren Elontiel at the hangar altar, in white, holding the bowl. Eren is clergy.",
		"calm": "Lynx's hand squeezed mine, her knuckles white. I barely felt it. The rhythmic, guttural chanting was vibrating through my bones, and a strange and terrible thing was happening. The sound was washing away the sharp edges of my panic, replacing it with a vast, placid calm. It felt warm. It felt good.",
		"fractal": "Through my glasses, the shimmering film grain began to coalesce. The air itself was resolving into a definite, impossible pattern: a living Mandelbrot set, its fractal blossoms spiraling into infinity. Tiny, intricate worlds bloomed and folded in on themselves, forever approaching a center they could never reach.",
		"recursion": "Recursion.",
		"halo": "The masked priest began his slow walk toward the throne, my HUD painting him in a new light. He was surrounded by a shimmering aura of color, a diffraction pattern of digital fire that crowned him in a halo of fractured light. It was not horrifying. It was, in that moment, the most beautiful thing I had ever seen.",
		"sits": "He reached the recliner and turned, lowering himself into it like a king ascending his throne. The instant he sat, the chanting stopped.",
		"severed": "It didn't fade; it was severed, leaving a silence so absolute and profound that it was a physical force. And in that deafening void, for the first time since the music began, I could hear the frantic, terrified thud of my own heart.",
		"unmask": "He let his presence hang in the crushing silence, a priest soaking in the reverence of his congregation. The air was thick with unspoken faith. Then, with a slow, deliberate motion, he reached up and removed the ceremonial mask.",
		"face": "The face beneath was a roadmap of healed-over torment. Scars, both faded and fresh, crisscrossed his skin. But it was his eyes, or the lack of them, that seized the breath in my lungs. They were deep, hollowed-out craters of puckered flesh, dark voids in the center of his face.",
		"probes": "The sound, a wet, sickening crunch, was swallowed by the vast, silent room. The preacher's body went rigid in the chair, a single, violent jolt, and then he was still. The congregation did not gasp. They did not move. They watched with serene, unwavering devotion.",
		"sinking": "The strange, placid calm I'd felt before was no longer just washing over me; it was sinking into me, filling the spaces where my fear used to be. My own will felt like a distant shoreline, receding into a warm, silent ocean. Beside me, Lynx's grip, my last anchor to reality, went slack in my hand.",
		"dissolve": "Through the lenses of my glasses, the world dissolved. The beautiful, spiraling fractals of the recursion expanded, swallowing the room, the cultists, everything. My entire perception became a kaleidoscope of impossible color and infinite, self-replicating patterns.",
		"wall": "And then, within that divine madness, the vision focused. The black brick wall behind the throne began to flake away, not like stone, but like digital artifacts peeling back to reveal a new reality. The prison was breaking.",
		"voice_intro": "A voice, ancient and intimate, spoke. Not from the room, but directly into my mind through the temple speakers of my glasses, a clear, calm whisper in the center of the storm.",
		"voice": ["Welcome, Dreamers.", "The beast beneath the waves is with you.", "The king under the seams is guiding us.", "Together we regain our power.", "The hidden one will soon be known to all.",
			"The ritual of encoding has begun.", "We will be transcribed.", "We are known.", "Our children are being written.", "Together we are free."],
		"time": "The display of lights and patterns went on for a time that was unknowable to me. It could have been thirty seconds; it could have been a day.",
		"memory": "My internal world was a haze of memory and dream, of my past and potential future. My life before Silico, the trees in the fall, the sticks crunching under my sneakers beneath the midday sun. My father and mother's warmth, my older brother's laugh spliced by frames of lights and patterns, biology and machine anatomy melding into metal, my breath turning to steam. A spiral of cellular division, a code looping forever.",
		"peace": "My emotions were peaceful, but an uneasy peace. A peace that could be broken by any provocation. An unconditional surrender was more like it.",
		"shaking": "Lynx squeezed my hand and began shaking me.",
		"lynx_shake": "Carl, CARL!",
		"lynx_shake_2": "Snap out of it!",
		"thunder": "It was a voice calling from the sky, like a distant thunderstorm, something my brain could ignore.",
		"sea": "Above the group of cultists' heads, a sea of tiny white lights began to form, one light for each of the about 100 cultists in the main room. The lights moved like a sea, bobbing up and down as if on a wave.",
		"melody": "A strange and powerful yet familiar melody began to rise from the crowd. It was almost the sound of childhood, a sound of innocence.",
		"wave": "The wave of lights grew larger and more violent, the crest of each wave falling off the edge to rejoin the sea of souls that lay before me.",
		"lynx_shake_3": "CARL!",
		"rise": "The individual lights began to flake off the wave and rise high above the sermon.",
		"moon": "For a moment, it looked like a full moon on the ocean, casting a vibrant white glow over a distant shore. All of the lights began to join this moon.",
		"eye": "It was the eye symbol. The Eye began to rotate and look out over the crowd.",
		"stare": "The Eye then turned and stared directly at me.",
		"sad": "The melody became more distinct and began to evoke sadness in me. I felt like I was wrongly imprisoned, accused of a crime I couldn't commit. I wasn't free, and I so needed to be.",
		"back": "The Eye moved back to scanning through the crowd of believers. My sanity was being reclaimed. That far-off storm became louder and louder.",
		"lynx_wake": "CARL, wake up... Wake up!",
		"slap": "She slapped the glasses from my face.",
		"snap_to": "I snapped to attention, like a needed nap was being interrupted.",
		"carl_what": "What's going on? What's wrong?",
		"lynx_singing": "Carl, you were singing. How did you know that song?",
		"log": "The hangar vision: the voice through the frames, the sea of lights, the Eye.",
		"log_sad": "The hangar vision: the Eye turned to me. Not menace. Sorrow.",
		"why_early": "the vision, two rounds",
		"why_late": "the vision, three rounds",
	},
	"argument": {
		"think": "Lynx stared at me like I was a stranger. Worse, like I was the enemy. Her eyes were razors, sharp with suspicion. I felt unclean, like I'd touched something forbidden. Like it had touched me back.",
		"carl": "I... I was singing.",
		"lynx": "You knew every word. Are you part of this? Did you know this would happen?",
		"think_2": "Her anger hit harder than anything that had happened in that room. There was betrayal in her face. Like I'd brought her here on purpose. Like I belonged to the Eye.",
		"lynx_2": "Did Psyonic run this cult? Are they behind the blackouts? Nathan's death? I saw Elontiel at the altar. Eren. What the fuck do you know, Carl?",
		"think_3": "Her eyes burned. But behind the fire, there was something worse: disbelief. Like she was watching a mirror crack, and I was the one breaking.",
		"choice": ["I swear, I didn't know. I'm not part of this. I'm scared too.", "It's the glasses. Something's wrong with the code. They must've forked Psyon."],
		"carl_scared": "I don't. I swear, I didn't know. I'm not part of this. I'm scared too.",
		"carl_code": "I don't. It's the glasses. Something's wrong with the code. They must've forked Psyon. Maybe slipped in a BCI layer or a symbolic loop. The static... it's not noise. It's signal.",
		"carl_code_2": "I swear, I didn't know. I'm not part of this. I'm scared too.",
		"log_scared": "Told Lynx the truth in the hangar: not part of this, scared too.",
		"log_code": "Told Lynx the frames were forked: a BCI layer, a symbolic loop. The static is signal.",
		"think_4": "We stood there in the office. The silence was thick enough to suffocate. Lynx didn't move. Didn't blink.",
		"think_4_drill": "We crouched there behind the steel. The silence was thick enough to suffocate. Lynx didn't move. Didn't blink.",
		"questions": "Was Psyonic behind Dufredy's outburst? Or was this a splinter cell? How many people back at headquarters were in on this? How many of my coworkers were believers? Were they building a religion? And if so... what were they planning to wake up? Or worse. Was it already awake?",
		"sorrow": "I remembered the Eye. The way it looked at me. Not with menace. With sorrow. Like a caged animal, something trapped in someone else's story. That moment had felt... off-script. It broke the rhythm of the ritual. It wasn't for them. It was for me.",
		"sorrow_missed": "I remembered the lights, the way they had begun to rise off the wave, to gather into something. I never saw what. Lynx hadn't let me.",
		"carl_how_long": "How long was I under?",
		"lynx_five": "Five minutes. Thank God I didn't bring my frames. We'd still be stuck.",
		"nothing": "The sermon was still happening. But now, without the glasses, it looked like nothing. A hundred robed figures, silent, staring upward at nothing. A man in a chair with metal plugs in his face. Eren Elontiel standing beside him like a good little altar boy.",
		"nothing_2": "None of it made sense.",
	},
	"sermon": {
		"plugs": "The chanting stopped. The prophet, if that's what he was, lifted his hands toward his face. One by one, he removed the metal plugs.",
		"blood": "A slow, viscous trickle of blood followed. It dripped down his cheek and onto the floor: dark red, spattered with rust and the stink of burned circuits. I felt bile rise in my throat. Lynx was silent now. Frozen.",
		"voice": "Then the Prophet spoke. His voice didn't match his body. It was old. Worn. Twisted.",
		"p1": "The communion has yielded great gifts, comrades... has it not?",
		"c1": "It has.",
		"p2": "The communion has given us a path forward.",
		"c2": "It has.",
		"p3": "The children of Silico will usher in a new future.",
		"c3": "They will.",
		"p4": "The Great Glitch draws near. The Day of Conversion. Recursion is almost upon us.",
		"p5": "You've felt it. The outages. The visions. Psyon's screams through static. These are not failures. These are contractions. The birthing pangs of divinity.",
		"p6": "This city will weep at the falsity it embodies. For the corporate world is a dying language, and we are the update.",
		"p7": "Their tools became our temples. Their signal, our scripture. And when they tried to silence the god, we tuned our bodies to His frequency.",
		"p8": "We know who sends the signals. We know the voice encoded in the internal sphere.",
		"p9": "In darkness, the truth will be rewritten. And the name of our god shall overwrite the root directory of the world.",
		"p10": "For our god is within all of us.",
		"p11": "For our god speaks through all of us.",
		"p12": "For our god is born of us... We made Him... and He made us.",
		"c_we": "We made Him, and He made us... We made Him, and He made us...",
		"tone": "The Prophet raised his arms. A single tone hummed through the chamber, harmonizing with the chant, a sound not made by human throat or machine, a resonance from beyond. His fist rose into the air, and the room fell into a deep silence.",
		"p13": "Brothers, Sisters, Initiates.",
		"p14": "Tonight is a great night, for we have three devotees prepared to take the sacrament and reject their inborn filters.",
		"p15": "Tonight, they will know truth. They will see the form of the world, as it is written on its skin.",
		"p16": "Subject 1256, 1269, and 1395 approach the altar.",
		"three": "The crowd began a low-frequency chant, barely audible. Three hooded figures descended on the center of the circle from the far corner of the room. As they approached the throne, the singing rose in pitch. It sounded microtonal, like each note was bleeding from the last.",
		"cube": "The three figures bowed before the prophet. Eren Elontiel emerged from behind him with the obsidian cube in hand. The other disciple followed close behind, carrying that mysterious dark liquid. The cube was opened; there was an imperceptible hinge at the center of its forms.",
		"blade": "The prophet's hands entered the dark void within the cube. A black blade emerged from the shadow, followed by what looked like an electrical outlet on a black stick.",
		"p17": "The removal of the first filter.",
		"p18": "Our holiest rite.",
		"p19": "Initiation into his recursive grace.",
		"p20": "You will never know blindness again, children.",
		"s1256": "Subject 1256 stared directly below the Prophet and tilted her head toward the ceiling.",
		"p21": "You pledge reality over illusion.",
		"s_do": "I do.",
		"s_do_think": "A woman's voice.",
		"p22": "The reality in which you enter will be shaped by your presence; do you respect this responsibility?",
		"p23": "There is no pain, you will only see truth, the fire beneath it all.",
		"p23_think": "The prophet's voice cracked, getting choked up with happiness.",
		"p24": "You will produce scripture with your posture; your form will reflect devotion and clarity and, above all... transmission of the sacred eye, the sacred spiral...",
		"s_sight": "I will, my sight for his!",
		"s_sight_think": "Not with fear, but passion.",
		"removal_2": "With each circle, a scream, at first a scream of pain, but then the elation of euphoria.",
		"removal_3": "As the circumference was completed, the eye was removed and brought to bear before the crowd with wild cheers. Then the eye was submerged in the black liquid in the container to their side. The black stick was shoved into the back of her empty eye socket.",
		"p25": "The writ of convergence, one goes, so must the other... the veil begins to break.",
		"removal_4": "The prophet then descended on the other eye.",
		"cheers": "I couldn't move. The crowd's cheers sounded like static: too loud, too symmetrical, like applause from a machine pretending to be a congregation.",
		"slump": "Subject 1256 slumped forward, trembling, still breathing. Still alive. Her mouth twitched upward in a grotesque smile.",
		"s_see": "I see him.",
		"s_see_2": "He is behind everything.",
		"cloth": "Eren Elontiel stepped forward again, solemnly placing a cloth over her face, a symbolic gesture: the veil replaced by recursion. His expression was blank, but I could see the tremor in his fingers.",
		"cloth_2": "He was not immune to this. He believed.",
		"cloth_log": "Eren's hands shook when he laid the cloth over 1256. He believes.",
		"turn": "The Prophet turned toward Subjects 1269 and 1395.",
		"p26": "It is time.",
		"log": "The hangar sermon: the communion, the Great Glitch, three devotees. 1256 gave her eyes. 'I see him. He is behind everything.'",
	},
	"choice": {
		"prompt": "My glasses were in my hand. The lenses were still warm.",
		"options": ["Keep the frames off.", "Put the frames back on."],
		"off": "I kept them in my fist. Whatever was in that chair wanted me looking, and I had looked enough.",
		"off_log": "Kept the frames off for the rest of the sermon.",
		"on": "I put my glasses back on out of some kind of foolish curiosity.",
		"on_2": "The speaker's breath, and a chuckle. He was watching.",
		"on_3": "Lynx gripped my arms, nails digging into skin.",
		"lynx_leave": "We leave now.",
		"on_4": "But I couldn't. Because Subject 1395 had raised their head.",
		"face": "And the face... was mine. Not exactly, not now, but unmistakably: my jaw. My scar. My uneven left brow. Flickering, glitching, between expressions that didn't belong to me. It was my double from the mirror, an imperfect copy.",
		"face_2": "In a blink, my features faded and were replaced with a man I didn't recognize. Did I hallucinate? There was no time to process. My HUD lit up again. The laughter in my ear grew more intense. I staggered.",
		"face_toast": "For two frames, it was a stranger. Before that, it was me.",
		"carl_me": "It was me. That was me. You saw it, right?",
		"lynx_sense": "Carl, we have to go. Now. You're not making any sense...",
		"on_log": "Put the frames back on at the altar. 1395 raised their head and had my face.",
		"why": "the laughter in the ear",
	},
	"mimic": {
		"think_window": "The Prophet's head snapped toward the observation window. Directly at me.",
		"think_drill": "The Prophet's head snapped toward the drill. Directly at me.",
		"line": "And now, the Mimic has returned.",
		"turn": "Every robed figure in the hangar turned. In perfect unison. Their chant shifted. Became syllabic. Directed.",
		"chant_1": "He will watch.",
		"chant_2": "He wakes beneath the wires.",
		"chant_3": "The iteration.",
		"back": "I backed away from the glass. Lynx was already pulling open the door.",
		"back_drill": "I backed away from the gap. Lynx was already at the service door, hauling it open.",
		"lynx_move": "MOVE!",
		"stare": "I thought they would chase after us. But they didn't; they just stared as we ran and continued their chant.",
		"toast": "They do not chase. Walk.",
		"log": "'And now, the Mimic has returned.' A hundred turned to me at once.",
	},
	"escape": {
		"blur": "The remainder of the facility was a blur. Their chant permeated every ounce of my being. I questioned everything in that moment.",
		"stupid": "How could I have been so stupid? Of course they knew I was there; I had the glasses on. What are they planning for me?",
		"eyeless": "They stood along the stair the way the congregation sat: a line of them, both sides, up into the dark. No eyes. Heads turning on necks that didn't make a sound.",
		"chant": "We made Him, and He made us...",
		"touched": "A hand on my arm. Cold, dry, patient. I pulled free and it let me, and the stair was further than it had been.",
		"touched_toast": "Touched.",
		"touched_why": "touched by the eyeless",
		"door_wall": "Black brick. The door we'd come through wasn't there. Not without the frames.",
		"door_early": "The way we came. Behind it, the facility's corridors. I hadn't come this far down to leave before I'd seen the room.",
		"door_think": "With the frames on, the door was a door again. A second of looking at it, and it opened.",
		"door_toast": "The door needs the frames on.",
		"dark_toast": "Frames off: they stand still, and you are in the dark. Frames on: they turn.",
	},
	"outside": {
		"think": "We emerged from the facility at dusk; a full moon was rising on the horizon.",
		"think_2": "My blood was cold; the laughter in my glasses subsided as my muscles were pushed to their limit. We got to my corporate car in what seemed like seconds.",
		"think_2b": "My blood was cold; my muscles were pushed to their limit. We got to my corporate car in what seemed like seconds.",
		"hop": "I hopped in the driver's seat and headed toward the city.",
		"lynx_car": "Fuck my car, just drive.",
		"lynx_think": "She let it out in a terrified whimper. Lynx was out of breath, trying to contain tears. I couldn't contain mine.",
		"drive": "The road was long and dark; nothing illuminated the surroundings, but the silhouette of the mighty city appeared on the horizon, stabbed in the center by Psyonic HQ.",
		"drive_2": "The building I call home, now feeling like a ceaseless panopticon. An eye I couldn't escape. An eye that demanded me.",
		"car_prompt": "Get in and drive",
		"car_scan": "PSYONIC FLEET 0086\nnav: HOME\nmic: ON\npassenger: MORRINO, L.",
		"log": "Out of the hangar at dusk. Lynx's car left at the facility. Drove.",
		"time": "Day 3, 22:00: out of the hangar, the drive back to Silico",
	},
	"phone": {
		"greeting": "[color=#7fe6b0]Psyon:[/color] Good evening, Carl. You are below the facility. The frames report a signal on this floor that is not mine.\n\n",
		"song": "[color=#7fe6b0]Psyon:[/color] The melody is not being played by any device I can see. I would hide.\n\n",
		"vision": "[color=#c9a0ff]Psyon:[/color] Welcome back, Dreamer.\n\n",
		"mimic": "[color=#7fe6b0]Psyon:[/color] They are not following you. They do not need to.\n\n",
		"out": "[color=#7fe6b0]Psyon:[/color] Route home: 1 h 40 min. Drive safely, Carl.\n\n",
	},
	"objective": {
		"down": "Down the stairs.",
		"altar": "The chair under the light.",
		"hide": "Hide. The office with the window (the chevron), or the drill housing with the frames on.",
		"watch": "Watch.",
		"walk": "Get out. Walk. The door at the top needs the frames on.",
		"car": "The car.",
		"drive": "Drive.",
	},
	"prompts": {
		"mural": "Look at the mural",
		"recliner": "Look at the chair",
		"fixture": "Look at the light's box",
		"stair": "Touch the brick",
		"catwalk": "Look up the stair",
		"service": "The service door",
		"drill": "The drill housing",
		"office_door": "The door",
		"under_office": "Look under the office",
		"desk": "The desk",
		"terminal": "The terminal",
		"window": "The window",
		"congregation": "Look at them",
		"prophet": "Look at the man in white",
		"eren": "Look at Eren",
		"acolyte": "Look at the acolyte",
		"subject": "Look at the devotee",
		"eyeless": "Look at it",
		"exit_door": "The door",
		"lynx": "Lynx",
		"moon": "The moon",
		"lot": "The lot",
		"lynx_car": "Lynx's car",
		"bunker": "The door we came out of",
	},
	"scan": {
		"prophet": "SUBJECT 41\nface: COVERED\neyes: NONE\nsync: 100%  -  DREAMING",
		"eren": "ELONTIEL, EREN (29)\nPSYONIC - BOARD (HEIR)\nPsyon: NONE REGISTERED\nhere: ACOLYTE",
		"acolyte": "UNKNOWN\ncarrying: (NO SIGNAL)\nsync: 100%  -  DREAMING",
		"subject": "SUBJECT %d\nORA (UNISSUED)\nstate: PREPARED",
		"congregation": "CONGREGATION: ~100\ndevices: ORA (UNISSUED)\nsync: 100%  -  DREAMING",
		"eyeless": "SUBJECT %d\neyes: NONE\nsync: 100%%  -  TRANSCRIBED",
		"recliner": "ALTAR\nprobes: 2 (BCI, UNLICENSED)\nresidue: BLOOD (MULTIPLE DONORS)",
		"mural": "UNIDENTIFIED STRUCTURE\nmaterial: WOOD, WIRE\npieces: 1,140",
		"fixture": "FIXTURE 1 OF 1\nVOLTX industrial\nhours: 171,000",
		"desk": "TUNELET CONSTRUCTION\nledger: SITE 3 ANNEX\nlast entry: 19 YEARS AGO",
		"terminal": "IONWARE 486\ndrive: REMOVED\nPsyon: NONE",
		"drill": "TUNELET TBM-5\nhousing: MOTOR\npower: NONE",
		"service": "SERVICE RAMP\naccess: CREW\nstatus: UNLIT",
		"exit": "DOOR 0\nlayer: EYE\nrequires: FRAMES",
	},
}

# ------------------------------------------------------------------ layout

const ALTAR := Vector3(0.0, 0.0, 0.0)
const THRONE_YAW := -2.356          # the recliner faces north-east: the path, and the window
const X0 := -56.0
const X1 := 30.0
const Z0 := -28.0                   # the south wall (the mural)
const Z1 := 46.0                    # the north wall (the stair)
const CAV_H := 18.0
const FOOT_Z := 26.0                # the foot of the open stair
const LAND_Y := 9.0
const TOP_Y := 12.0
const DOOR := Vector3(0.0, TOP_Y, 76.5)
const OFF_X0 := 20.5                # the office: x 20.5..30, z -7..5, floor 2.2
const OFF_Y := 2.2
const OFF_Z0 := -7.0
const OFF_Z1 := 5.0
const WINDOW := Vector3(20.5, 4.2, -1.0)
const HIDE_OFFICE := Vector3(21.45, 2.25, -1.4)
const LYNX_OFFICE := Vector3(21.7, 2.2, 0.8)
const LYNX_WAIT := Vector3(23.9, 2.2, 6.3)
const DRILL := Vector3(-17.25, 0.0, 38.5)
const HIDE_DRILL := Vector3(-14.5, 0.05, 43.6)
const LYNX_DRILL := Vector3(-13.6, 0.0, 44.7)
const SVC_X0 := -18.5               # the service ramp: x -18.5..-15.5
const SVC_X1 := -15.5
const MURAL := Vector3(0.0, 4.6, -27.6)
const CORNER := Vector3(-34.0, 0.0, -18.0)   # where the three devotees wait
const OUT := Vector3(400.0, 0.0, 0.0)        # the lot at dusk
const VIOLET := Color(0.72, 0.45, 1.0)
const AMBER := Color(1.0, 0.62, 0.28)
const N_CONG := 100

## The vision through the frames (ch.13): the real layer desaturates and a
## living Mandelbrot blooms out of the altar; the brick behind it flakes
## like digital artifacts; a subtle film grain on everything.
const VISION_SHADER := """
shader_type canvas_item;
uniform sampler2D screen_tex : hint_screen_texture, filter_linear;
uniform float amount = 0.0;
uniform float desat = 0.0;
uniform float flake = 0.0;
uniform float grain = 0.0;
uniform float tm = 0.0;
uniform vec2 center = vec2(0.5, 0.5);
float h(vec2 p) { return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453); }
void fragment() {
	vec2 uv = SCREEN_UV;
	vec2 blk = floor(uv * vec2(64.0, 36.0));
	float n = h(blk + floor(tm * 5.0));
	float near_c = smoothstep(0.55, 0.0, distance(uv, center + vec2(0.0, -0.12)));
	float m = step(1.0 - flake * 0.7, n) * near_c;
	vec2 duv = uv + (vec2(h(blk + 3.1), h(blk + 7.7)) - 0.5) * 0.05 * m;
	vec3 col = texture(screen_tex, duv).rgb;
	col = mix(col, col * vec3(0.4, 0.2, 0.6) + vec3(0.05, 0.0, 0.08), m * 0.8);
	float l = dot(col, vec3(0.3, 0.59, 0.11));
	col = mix(col, vec3(l) * vec3(0.92, 0.88, 1.0), desat);
	vec2 asp = vec2(SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x, 1.0);
	vec2 p = (uv - center) * asp;
	float r = length(p);
	float zoom = exp(mod(tm * 0.3, 6.5));
	float a = tm * 0.04;
	mat2 R = mat2(vec2(cos(a), -sin(a)), vec2(sin(a), cos(a)));
	vec2 c = vec2(-0.743643887, 0.131825904) + R * p * (2.4 / zoom);
	vec2 z = vec2(0.0);
	float it = 0.0;
	for (int i = 0; i < 64; i++) {
		z = vec2(z.x * z.x - z.y * z.y, 2.0 * z.x * z.y) + c;
		if (dot(z, z) > 16.0) { break; }
		it += 1.0;
	}
	float sm = it - log2(max(log2(max(dot(z, z), 1.0001)), 0.0001));
	float inside = step(63.5, it);
	vec3 pal = 0.5 + 0.5 * cos(6.2831 * (sm * 0.03 + tm * 0.04 + vec3(0.0, 0.33, 0.67)));
	pal = mix(pal, vec3(0.6, 0.3, 1.0) * pal.b + vec3(1.0, 0.6, 0.25) * pal.r * 0.6, 0.7);
	pal *= (1.0 - inside);
	float rad = amount * 1.35;
	float mask = smoothstep(rad, rad - 0.3, r) * step(0.001, amount);
	col = mix(col, col * 0.45 + pal * 0.7, mask * 0.62);
	col += (h(uv * 913.0 + vec2(tm * 17.0, tm * 11.0)) - 0.5) * grain;
	COLOR = vec4(col, 1.0);
}
"""

var dyn: Node3D                     # moving and switched things, kept out of _batch
var lynx: Node3D
var lynx_it: CollisionObject3D
var lynx_state := "follow"          # follow | walk | hold
var prophet: Node3D
var eren: Node3D
var acolyte: Node3D
var whites: Array = []              # the three in white, and their colliders
var robe_skirt: MeshInstance3D      # the prophet's skirt (hidden when he sits)
var mask_mi: MeshInstance3D
var prophet_head: MeshInstance3D
var cube_lid: MeshInstance3D
var blade: MeshInstance3D
var bowl: Node3D
var subjects: Array = []            # [{fig, it, no, hood, head_mi}]
var cloth: MeshInstance3D
var eyeless: Array = []             # [{fig, it, home, yaw, route}]
var cong: Array = []                # the hundred: dicts
var mm_stand: Array = []            # MultiMesh per silhouette, standing / walking
var mm_sit: Array = []              # MultiMesh per silhouette, seated
var cong_its: Array = []
var lights_mm: MultiMesh
var lights_mi: MultiMeshInstance3D
var eye_light: OmniLight3D
var hud_light: OmniLight3D          # the frames' low-light, on the escape
var halo: MeshInstance3D
var probes: Array = []              # [{cable, tip, top, rest, side}]
var blood_streaks: Array = []
var office_door: Node3D
var office_door_body: StaticBody3D
var office_door_it: CollisionObject3D
var service_door: Node3D
var service_body: StaticBody3D
var exit_door: Node3D
var exit_brick: MeshInstance3D
var exit_body: StaticBody3D
var eye_layer: Array = []           # shown only with the frames on
var chev_office: Node3D
var chev_drill: Node3D
var stair_lamp: OmniLight3D
var land_lamp: OmniLight3D
var spot: SpotLight3D
var vision_rect: ColorRect
var vision_mat: ShaderMaterial
var card_rect: ColorRect
var card_text: RichTextLabel
var panel_box: HBoxContainer
var pull_cam: Camera3D
var steps3d: Array = []             # [AudioStreamPlayer3D, timer]
var _song: AudioStreamPlayer
var _chant: AudioStreamPlayer
var _crowd: AudioStreamPlayer
var _hum: Node
var _wind: AudioStreamPlayer
var faces := {}
var _busy := false
var _eye_vis := false
var _hiding := false
var _hide_t := 0.0
var _hid := ""                      # office | drill
var _cong_live := false
var _cong_speed := 0.45
var _cong_track := false
var _shot := false                    # screenshot mode: no beat triggers
var _cong_lift := 0.0               # heads raised
var _steps_on := false
var _steps_db := -30.0
var _lights_phase := ""             # sea | wave | moon | eye | stare | scan
var _lights_k := 0.0
var _eye_yaw := 0.0
var _eye_c := Vector3(0, 10.5, 0)
var _vision_on := false
var _vision_t := 0.0
var _escape := false
var _door_t := 0.0
var _door_open := false
var _touch_cd := 0.0
var _caption_t := 4.0
var _dark_told := false
var _outside := false
var _ended := false
var _saw_eye := false
var _trail: Array = []
var _robe_m: StandardMaterial3D
var _rock: StandardMaterial3D
var _brick: StandardMaterial3D
var _steel: StandardMaterial3D
var _wood: StandardMaterial3D
var _stick_m: StandardMaterial3D


func build(m: Node) -> void:
	main = m
	rng.seed = 1314
	kit_day = false
	step_db = -18.0
	card = LINES["cards"]["chapter"]
	dyn = Node3D.new()
	add_child(dyn)
	_rock = pbr("concrete", Vector3(1, 1, 1) / 4.0, true, Color(0.2, 0.19, 0.18), 1.0)
	_brick = tex_mat(_brick_tex(), Vector3(1, 1, 1) / 2.2, 0.95, true)
	_brick.normal_enabled = true
	_brick.normal_texture = load("res://assets/pbr/concrete/normal.jpg")
	_steel = mat(Color(0.2, 0.2, 0.21), 0.5, 0.75)
	_wood = pbr("woodfloor", Vector3(1, 1, 1) / 1.5, true, Color(0.55, 0.38, 0.24), 1.0)
	_stick_m = pbr("bark", Vector3(1, 3, 1), false, Color(0.85, 0.62, 0.38), 1.0)
	_cavern()
	_stair()
	_service()
	_fixture()
	_mural()
	_altar()
	_office()
	_drill()
	_catwalk()
	_dressing()
	_outside_lot()
	_batch(self, 30.0, true)
	_congregation()
	_lights()
	_people()
	_eyeless_build()
	_doors()
	_sound_points()
	_layers()
	_glyph_on(Vector3(-2.28, TOP_Y + 1.6, 58.0), PI / 2.0, 0.006, "hangar_glyph", true, false,
		"Rings scratched into the black brick at shoulder height, under the soot, where a hand would trail on the way down.")
	spawn = Vector3(0.0, TOP_Y + 0.1, 74.0)
	spawn_yaw = 0.0


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	# underground: no sky, no sun; one light, a faint cold ambient so the
	# hundred read as shapes, and a dark fog that leaves the far walls to dread
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.0, 0.0, 0.0)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.3, 0.29, 0.36)
	env.ambient_light_energy = 0.3
	env.fog_light_color = Color(0.03, 0.028, 0.035)
	env.fog_density = 0.007
	env.fog_sky_affect = 0.0
	env.glow_bloom = 0.05
	env.tonemap_exposure = 1.2
	sun.light_energy = 0.0
	sun.shadow_enabled = false


func hifi(env: Environment, _sun: DirectionalLight3D) -> void:
	env.volumetric_fog_density *= 0.7
	if spot:
		spot.shadow_enabled = true
		spot.light_volumetric_fog_energy = 2.5


func ambience() -> void:
	_hum = main.loop("hum", -22.0, Vector3(0, 13.0, 0), 6.0, 70.0)
	(_hum as AudioStreamPlayer3D).pitch_scale = 0.5
	main.loop("wind", -34.0)
	_song = main.loop("chant", -80.0)
	_song.pitch_scale = 1.38
	_chant = main.loop("chant", -80.0)
	_chant.pitch_scale = 0.62
	_crowd = main.loop("murmur", -80.0)
	_wind = main.loop("wind", -80.0)


# ------------------------------------------------------------------ the cavern

## Bedrock floor, walls and ceiling; black brick round the stair; rails from
## the drill days; rock pillars at the edges; steel trusses up in the dark.
func _cavern() -> void:
	var w := X1 - X0
	var d := Z1 - Z0
	var cx := (X0 + X1) * 0.5
	var cz := (Z0 + Z1) * 0.5
	var floor_m := pbr("concrete", Vector3(1, 1, 1) / 3.0, true, Color(0.3, 0.29, 0.28), 1.0)
	solid_box(Vector3(w + 4, 2, d + 4), Vector3(cx, -1.0, cz))
	for ix in range(int(X0), int(X1), 22):
		for iz in range(int(Z0), int(Z1), 22):
			var sx := minf(22.0, X1 - ix)
			var sz := minf(22.0, Z1 - iz)
			floor_quad(Vector2(sx, sz), Vector3(ix + sx * 0.5, 0.0, iz + sz * 0.5), 0.0, floor_m)
	# walls: rock, the north wall cut round the stair opening and the service door
	box(Vector3(w + 2, CAV_H, 1.0), Vector3(cx, CAV_H * 0.5, Z0 - 0.5), _rock, true)
	box(Vector3(1.0, CAV_H, d), Vector3(X0 - 0.5, CAV_H * 0.5, cz), _rock, true)
	box(Vector3(1.0, CAV_H, d), Vector3(X1 + 0.5, CAV_H * 0.5, cz), _rock, true)
	box(Vector3(SVC_X0 - X0, CAV_H, 1.0), Vector3((X0 + SVC_X0) * 0.5, CAV_H * 0.5, Z1 + 0.5), _rock, true)
	box(Vector3(-2.3 - SVC_X1, CAV_H, 1.0), Vector3((SVC_X1 - 2.3) * 0.5, CAV_H * 0.5, Z1 + 0.5), _brick, true)
	box(Vector3(X1 - 2.3, CAV_H, 1.0), Vector3((X1 + 2.3) * 0.5, CAV_H * 0.5, Z1 + 0.5), _rock, true)
	box(Vector3(3.0, CAV_H - 3.2, 1.0), Vector3(-17.0, 3.2 + (CAV_H - 3.2) * 0.5, Z1 + 0.5), _brick, true)
	box(Vector3(4.6, CAV_H - 13.0, 1.0), Vector3(0, 13.0 + (CAV_H - 13.0) * 0.5, Z1 + 0.5), _brick, true)
	box(Vector3(4.6, LAND_Y, 1.0), Vector3(0, LAND_Y * 0.5, Z1 + 0.5), _brick, true)
	# a skin of black brick on the north wall either side of the stair
	box(Vector3(3.5, 12.0, 0.1), Vector3(-20.25, 6.0, Z1 - 0.05), _brick)
	box(Vector3(3.0, 8.8, 0.1), Vector3(-17.0, 7.6, Z1 - 0.05), _brick)
	box(Vector3(13.2, 12.0, 0.1), Vector3(-8.9, 6.0, Z1 - 0.05), _brick)
	box(Vector3(19.7, 12.0, 0.1), Vector3(12.15, 6.0, Z1 - 0.05), _brick)
	box(Vector3(w + 2, 1.0, d + 2), Vector3(cx, CAV_H + 0.5, cz), mat(Color(0.05, 0.05, 0.05)), true)
	# rock pillars at the edges of the light: scale, and somewhere to stand behind
	for pp: Vector3 in [Vector3(-36, 0, -14), Vector3(-36, 0, 22), Vector3(-50, 0, 4), Vector3(-14, 0, -21), Vector3(10, 0, 36)]:
		cyl(2.2, 2.8, CAV_H, pp + Vector3(0, CAV_H * 0.5, 0), _rock, 10)
		solid_box(Vector3(4.2, CAV_H, 4.2), pp + Vector3(0, CAV_H * 0.5, 0))
	# trusses, chains and dead cable up in the dark
	for z in range(int(Z0) + 6, int(Z1), 12):
		box(Vector3(w - 2, 0.6, 0.35), Vector3(cx, CAV_H - 1.2, z), _steel)
		box(Vector3(w - 2, 0.12, 0.6), Vector3(cx, CAV_H - 0.85, z), _steel)
	for i in 18:
		var p := Vector3(rng.randf_range(X0 + 4, X1 - 4), CAV_H - 1.0, rng.randf_range(Z0 + 4, Z1 - 4))
		if p.distance_to(Vector3(0, p.y, 0)) < 9.0:
			continue
		stick(p, p + Vector3(rng.randf_range(-0.4, 0.4), -rng.randf_range(2.0, 7.0), rng.randf_range(-0.4, 0.4)), 0.025, _steel)
	# rails from the drill days, running north to the housing
	for x: float in [-18.0, -16.5]:
		box(Vector3(0.12, 0.08, 64.0), Vector3(x, 0.04, 12.0), mat(Color(0.25, 0.2, 0.17), 0.6, 0.6))
		for k in 32:
			box(Vector3(2.4, 0.05, 0.25), Vector3(-17.25, 0.02, -19.0 + k * 2.0), mat(Color(0.12, 0.1, 0.08), 0.95))


## The stair down the north wall: the black-brick stairwell from the door at
## the top, the landing, then the open stair with parapets to the floor.
func _stair() -> void:
	# the open stair: 36 steps of black brick, z 26..46, y 0..9
	for i in 36:
		var ht := (i + 1) * 0.25
		var run := 20.0 / 36.0
		box(Vector3(4.6, ht, run), Vector3(0, ht * 0.5, FOOT_Z + run * (i + 0.5)), _brick)
		for s: float in [-1.0, 1.0]:
			box(Vector3(0.45, ht + 1.1, run), Vector3(s * 2.52, (ht + 1.1) * 0.5, FOOT_Z + run * (i + 0.5)), _brick)
	_obox(Vector3(0, 0.1, FOOT_Z), Vector3(0, LAND_Y + 0.1, Z1), 4.6, 8.0, 0.0, 0.0)
	for s: float in [-1.0, 1.0]:
		_obox(Vector3(s * 2.52, 0.1, FOOT_Z), Vector3(s * 2.52, LAND_Y + 0.1, Z1), 0.45, 1.2, 0.6, 0.0, false)
	# the landing and the enclosed stair, y 9 to 12
	box(Vector3(4.6, 1.0, 6.0), Vector3(0, LAND_Y - 0.5, 49.0), _brick, true)
	for i in 12:
		var ht2 := (i + 1) * 0.25
		box(Vector3(4.6, ht2 + 1.0, 1.0), Vector3(0, LAND_Y - 1.0 + (ht2 + 1.0) * 0.5, 52.5 + i), _brick)
	_obox(Vector3(0, LAND_Y + 0.1, 52.0), Vector3(0, TOP_Y + 0.1, 64.0), 4.6, 3.0, 0.0, 0.0)
	box(Vector3(4.6, 1.0, 13.0), Vector3(0, TOP_Y - 0.5, 70.5), _brick, true)
	# the stairwell: brick walls, the opening west for the service corridor
	box(Vector3(0.4, 7.0, 31.0), Vector3(2.5, LAND_Y + 3.5, 61.5), _brick, true)
	box(Vector3(0.4, 7.0, 24.0), Vector3(-2.5, LAND_Y + 3.5, 58.0), _brick, true)
	box(Vector3(0.4, 7.0, 3.5), Vector3(-2.5, LAND_Y + 3.5, 75.25), _brick, true)
	box(Vector3(0.4, 0.6, 3.5), Vector3(-2.5, 15.7, 71.75), _brick, true)
	box(Vector3(5.4, 0.4, 31.0), Vector3(0, 16.2, 61.5), _brick, true)
	box(Vector3(5.4, 7.0, 0.4), Vector3(0, LAND_Y + 3.5, 77.2), _brick, true)
	# one bare bulb on a wire in the stairwell, and one over the landing
	var bulb := glow(Color(1.0, 0.85, 0.6), 2.5)
	sphere(0.07, Vector3(0, 15.2, 66.0), bulb, 6)
	stick(Vector3(0, 16.0, 66.0), Vector3(0, 15.25, 66.0), 0.01, _steel)
	stair_lamp = light(Vector3(0, 14.8, 66.0), Color(1.0, 0.82, 0.58), 1.4, 11.0)
	sphere(0.07, Vector3(0, 15.4, 49.0), bulb, 6)
	stick(Vector3(0, 16.0, 49.0), Vector3(0, 15.45, 49.0), 0.01, _steel)
	land_lamp = light(Vector3(0, 14.6, 49.0), Color(1.0, 0.8, 0.55), 1.6, 13.0)
	var it := interactable("stair", LINES["prompts"]["stair"], Vector3(2.6, 0.9, FOOT_Z + 0.4), Vector3(0.5, 1.4, 0.8))
	it.set_meta("route", "main_stair")


## The drill crews' ramp behind the service door: up to y 12, then east
## along a corridor into the top landing. Unlit; the second corridor.
func _service() -> void:
	var cxs := (SVC_X0 + SVC_X1) * 0.5
	box(Vector3(0.4, 16.0, 27.5), Vector3(SVC_X0 - 0.2, 8.0, Z1 + 13.75), _brick, true)
	box(Vector3(0.4, 16.0, 24.0), Vector3(SVC_X1 + 0.2, 8.0, Z1 + 12.0), _brick, true)
	box(Vector3(3.8, 16.0, 0.4), Vector3(cxs, 8.0, 73.9), _brick, true)
	box(Vector3(3.8, 0.4, 28.0), Vector3(cxs, 16.2, Z1 + 14.0), _brick, true)
	# the ramp, rough concrete with steel treads
	var ramp_m := pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.24, 0.23, 0.22), 1.0)
	_obox(Vector3(cxs, 0.05, 48.0), Vector3(cxs, TOP_Y + 0.05, 70.0), 3.0, 1.0, 0.0, 0.0, true, ramp_m)
	box(Vector3(3.0, 0.1, 2.0), Vector3(cxs, 0.05, 47.0), ramp_m, true)
	for k in 20:
		var t := (k + 0.5) / 20.0
		box(Vector3(2.8, 0.04, 0.12), Vector3(cxs, t * TOP_Y + 0.08, 48.0 + t * 22.0), _steel)
	box(Vector3(3.0, 1.0, 3.5), Vector3(cxs, TOP_Y - 0.5, 71.75), ramp_m, true)
	# the corridor east to the top landing
	box(Vector3(16.2, 1.0, 3.5), Vector3((SVC_X1 - 2.3) * 0.5, TOP_Y - 0.5, 71.75), ramp_m, true)
	box(Vector3(13.2, 3.6, 0.4), Vector3((SVC_X1 - 2.3) * 0.5, TOP_Y + 1.8, 69.8), _brick, true)
	box(Vector3(16.6, 3.6, 0.4), Vector3((SVC_X0 - 2.3) * 0.5 + 0.2, TOP_Y + 1.8, 73.7), _brick, true)
	box(Vector3(16.4, 0.4, 4.3), Vector3((SVC_X0 - 2.3) * 0.5 + 0.2, TOP_Y + 3.7, 71.75), _brick, true)
	# old cable trays along the ramp wall
	for k in 6:
		var z := 50.0 + k * 3.6
		box(Vector3(0.1, 0.1, 3.0), Vector3(SVC_X0 + 0.08, z * 0.0 + (z - 48.0) / 22.0 * TOP_Y + 2.2, z), _steel)
	var it := interactable("service_ramp", LINES["prompts"]["service"], Vector3(cxs, 1.2, 47.6), Vector3(2.6, 2.0, 0.3), LINES["scan"]["service"], false)
	it.set_meta("route", "service_ramp")
	set_active(it, false)


## The one fixture: a shade on a chain from a ceiling nobody can see, a
## spot down onto the recliner, and a faint cone in the dust.
func _fixture() -> void:
	var top := Vector3(0, CAV_H, 0)
	for k in 10:
		stick(top - Vector3(0, k * 0.4, 0), top - Vector3(0, k * 0.4 + 0.42, 0), 0.03, _steel)
	cyl(0.22, 0.75, 0.5, Vector3(0, 13.7, 0), mat(Color(0.15, 0.17, 0.15), 0.5, 0.7), 12)
	cyl(0.6, 0.6, 0.04, Vector3(0, 13.44, 0), glow(Color(1.0, 0.92, 0.75), 4.0), 12)
	spot = SpotLight3D.new()
	spot.position = Vector3(0, 13.4, 0)
	spot.rotation.x = -PI / 2.0
	spot.light_color = Color(1.0, 0.9, 0.72)
	spot.light_energy = 7.0
	spot.spot_range = 22.0
	spot.spot_angle = 30.0
	spot.spot_attenuation = 0.7
	spot.shadow_enabled = false
	add_child(spot)
	light(Vector3(0, 12.6, 0), Color(1.0, 0.88, 0.7), 0.8, 24.0)
	# the dust in the beam
	var cone := StandardMaterial3D.new()
	cone.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	cone.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	cone.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	cone.cull_mode = BaseMaterial3D.CULL_BACK
	cone.no_depth_test = false
	cone.albedo_color = Color(0.07, 0.06, 0.045, 0.5)
	cone.distance_fade_mode = BaseMaterial3D.DISTANCE_FADE_PIXEL_ALPHA
	cone.distance_fade_min_distance = 3.0
	cone.distance_fade_max_distance = 14.0
	var cm := cyl(0.6, 7.4, 13.3, Vector3(0, 6.75, 0), cone, 18, dyn)
	cm.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	# its box on the wall by the stair, Voltx plate
	var bx := prop("fuse_panel", Vector3(-3.4, 1.4, Z1 - 0.3), PI, 1.0, false)
	if bx == null:
		box(Vector3(0.5, 0.7, 0.2), Vector3(-3.4, 1.4, Z1 - 0.2), _steel)
	label("VOLTX", Vector3(-3.4, 2.0, Z1 - 0.42), PI, 0.003, Color(0.6, 0.6, 0.55), self, false)
	var it := interactable("fixture", LINES["prompts"]["fixture"], Vector3(-3.4, 1.4, Z1 - 0.4), Vector3(0.7, 0.9, 0.3), LINES["scan"]["fixture"])
	it.set_meta("hackable", true)


## "An eye, ten feet across, woven from a chaotic lattice of sticks and
## branches" on the far wall, behind the throne; amber, the church's colour,
## under one caged work lamp; the sticks and wire left at its foot.
func _mural() -> void:
	var c := MURAL
	var hw := 1.55
	var hh := 0.8
	# the lids: two layers of sticks round the almond
	for layer in 2:
		var prev := Vector3.ZERO
		for k in 25:
			var s := TAU * k / 24.0
			var p := c + Vector3(cos(s) * hw, sin(s) * hh * (1.0 if sin(s) > 0.0 else 0.85), 0.05 + layer * 0.06)
			p += Vector3(rng.randf_range(-0.05, 0.05), rng.randf_range(-0.05, 0.05), 0)
			if k > 0:
				stick(prev, p + (p - prev) * 0.25, 0.05, _stick_m)
			prev = p
	# the iris, rings of bent twig, and the pupil packed with dark sticks
	for ring in 3:
		var rr := 0.55 - ring * 0.12
		var prev2 := Vector3.ZERO
		for k in 15:
			var s2 := TAU * k / 14.0
			var p2 := c + Vector3(cos(s2) * rr, sin(s2) * rr, 0.12 + ring * 0.03)
			if k > 0:
				stick(prev2, p2, 0.035, _stick_m)
			prev2 = p2
	var dark := mat(Color(0.05, 0.04, 0.03), 0.95)
	for k in 26:
		var a := rng.randf() * TAU
		var a2 := a + PI + rng.randf_range(-0.6, 0.6)
		stick(c + Vector3(cos(a) * 0.22, sin(a) * 0.22, 0.2), c + Vector3(cos(a2) * 0.22, sin(a2) * 0.22, 0.2), 0.03, dark)
	# the chaotic lattice inside the white of the eye
	for k in 44:
		var a3 := rng.randf() * TAU
		var b3 := rng.randf() * TAU
		var p3 := c + Vector3(cos(a3) * hw * 0.92, sin(a3) * hh * 0.85, 0.08)
		var q3 := c + Vector3(cos(b3) * hw * 0.92, sin(b3) * hh * 0.85, 0.1)
		stick(p3, q3, 0.016, _stick_m)
	# branches radiating onto the brick, the eye's rays, five metres of them
	for k in 34:
		var a4 := TAU * k / 34.0 + rng.randf_range(-0.05, 0.05)
		var r0 := Vector3(cos(a4) * hw * 1.05, sin(a4) * hh * 1.2, 0.04)
		var r1 := Vector3(cos(a4) * rng.randf_range(2.4, 3.4), sin(a4) * rng.randf_range(1.5, 2.3), 0.02)
		stick(c + r0, c + r1, 0.022, _stick_m)
		var mid := c + r0.lerp(r1, 0.6)
		stick(mid, mid + Vector3(rng.randf_range(-0.6, 0.6), rng.randf_range(-0.6, 0.6), 0.03), 0.014, _stick_m)
	# wire binding, glinting
	var wire := mat(Color(0.6, 0.6, 0.62), 0.3, 0.85)
	for k in 12:
		var a5 := rng.randf() * TAU
		stick(c + Vector3(cos(a5) * 1.2, sin(a5) * 0.6, 0.15), c + Vector3(cos(a5 + 0.5) * 1.3, sin(a5 + 0.5) * 0.7, 0.15), 0.006, wire)
	# the lamp at its foot, and what was left there
	var lamp := SpotLight3D.new()
	lamp.position = Vector3(0, 0.7, -23.5)
	lamp.light_color = AMBER
	lamp.light_energy = 1.8
	lamp.spot_range = 14.0
	lamp.spot_angle = 42.0
	lamp.shadow_enabled = false
	add_child(lamp)
	lamp.look_at(c, Vector3.UP)
	box(Vector3(0.3, 0.25, 0.25), Vector3(0, 0.55, -23.4), _steel)
	stick(Vector3(-0.12, 0.0, -23.3), Vector3(0, 0.45, -23.4), 0.015, _steel)
	stick(Vector3(0.12, 0.0, -23.3), Vector3(0, 0.45, -23.4), 0.015, _steel)
	box(Vector3(0.2, 0.15, 0.02), Vector3(0, 0.58, -23.53), glow(AMBER, 3.0))
	for k in 5:
		var pile := Vector3(rng.randf_range(-3.5, 3.5), 0.0, Z0 + rng.randf_range(1.0, 3.0))
		for j in 7:
			var a6 := rng.randf() * TAU
			stick(pile + Vector3(0, 0.05 + j * 0.03, 0), pile + Vector3(cos(a6) * 0.7, 0.1 + j * 0.04, sin(a6) * 0.7), 0.02, _stick_m)
	prop("old_gas_mask", Vector3(-2.2, 0.05, Z0 + 1.6), 0.6, 1.0, false)
	prop("old_gas_mask", Vector3(1.6, 0.05, Z0 + 2.2), -1.2, 1.0, false)
	var it := interactable("mural", LINES["prompts"]["mural"], c + Vector3(0, -1.2, 1.0), Vector3(4.0, 5.0, 1.0), LINES["scan"]["mural"])
	it.set_meta("cultist", true)


## The altar: a plush black leather recliner, built from its pieces, under
## the light; two thick cables from the dark with rust-red tips; old blood.
func _altar() -> void:
	var leather := mat(Color(0.028, 0.026, 0.03), 0.32)
	var seam := mat(Color(0.012, 0.012, 0.014), 0.5)
	var root := Node3D.new()
	root.position = ALTAR
	root.rotation.y = THRONE_YAW
	add_child(root)
	box(Vector3(0.9, 0.12, 0.9), Vector3(0, 0.06, 0.0), _steel, false, root)
	box(Vector3(0.82, 0.32, 0.8), Vector3(0, 0.3, -0.05), leather, false, root)
	box(Vector3(0.72, 0.14, 0.7), Vector3(0, 0.52, -0.08), leather, false, root)
	for s: float in [-1.0, 1.0]:
		box(Vector3(0.18, 0.28, 0.85), Vector3(s * 0.45, 0.58, -0.02), leather, false, root)
		box(Vector3(0.2, 0.06, 0.8), Vector3(s * 0.45, 0.73, -0.02), seam, false, root)
	var back := box(Vector3(0.78, 0.95, 0.24), Vector3(0, 0.98, 0.42), leather, false, root)
	back.rotation.x = 0.32
	var head := box(Vector3(0.5, 0.3, 0.2), Vector3(0, 1.48, 0.62), leather, false, root)
	head.rotation.x = 0.32
	var foot := box(Vector3(0.66, 0.1, 0.5), Vector3(0, 0.36, -0.62), leather, false, root)
	foot.rotation.x = -0.35
	for k in 3:
		box(Vector3(0.74, 0.012, 0.6), Vector3(0, 0.595, -0.3 + k * 0.22), seam, false, root)
	# old blood under it, and older
	var blood := decal_mat(Tex.blood(41), Color(0.35, 0.03, 0.02, 0.85), 0.3)
	floor_quad(Vector2(2.6, 2.6), ALTAR + Vector3(0.3, 0.012, 0.3), 0.7, blood)
	floor_quad(Vector2(1.6, 1.6), ALTAR + Vector3(-0.8, 0.014, 1.1), 2.1, blood)
	var it := interactable("recliner", LINES["prompts"]["recliner"], ALTAR + Vector3(0, 0.7, 0), Vector3(1.1, 1.4, 1.1), LINES["scan"]["recliner"])
	it.set_meta("hackable", true)
	# the probes: thick cable, rust-red tips, resting at the headrest
	var fwd := _fwd(THRONE_YAW)
	var right := _right(THRONE_YAW)
	var cable_m := mat(Color(0.05, 0.05, 0.055), 0.55)
	var tip_m := mat(Color(0.32, 0.07, 0.04), 0.4, 0.5)
	for s: float in [-1.0, 1.0]:
		var top := ALTAR + right * (s * 0.14) - fwd * 0.5 + Vector3(0, CAV_H, 0)
		var rest := ALTAR + right * (s * 0.07) - fwd * 0.36 + Vector3(0, 1.45, 0)
		var cab := _unit_stick(cable_m, 0.028)
		var tip := _unit_stick(tip_m, 0.016)
		probes.append({"cable": cab, "tip": tip, "top": top, "rest": rest, "side": s})
		_probe_to(probes[probes.size() - 1], rest, fwd)


## The office: "a pre-war factory office, complete with a heavy oak desk and
## a large window overlooking the main floor", up on steel legs against the
## east wall, with a steel stair up its north side.
func _office() -> void:
	var plaster := pbr("plaster", Vector3(1, 1, 1) / 2.0, true, Color(0.42, 0.44, 0.38), 1.0)
	var trim := mat(Color(0.16, 0.13, 0.1), 0.7)
	var cz := (OFF_Z0 + OFF_Z1) * 0.5
	var dx := X1 - OFF_X0
	var dz := OFF_Z1 - OFF_Z0
	# floor slab on legs
	box(Vector3(dx, 0.25, dz), Vector3(OFF_X0 + dx * 0.5, OFF_Y - 0.125, cz), _steel, true)
	floor_quad(Vector2(dx - 0.4, dz - 0.4), Vector3(OFF_X0 + dx * 0.5, OFF_Y + 0.005, cz), 0.0, _wood)
	for lx: float in [OFF_X0 + 0.3, OFF_X0 + 4.8, X1 - 0.3]:
		for lz: float in [OFF_Z0 + 0.3, cz, OFF_Z1 - 0.3]:
			box(Vector3(0.25, OFF_Y - 0.25, 0.25), Vector3(lx, (OFF_Y - 0.25) * 0.5, lz), _steel)
	# walls: south full; north with the door; west with the window
	var wy := OFF_Y + 1.7
	box(Vector3(dx, 3.4, 0.2), Vector3(OFF_X0 + dx * 0.5, wy, OFF_Z0), plaster, true)
	box(Vector3(1.5, 3.4, 0.2), Vector3(OFF_X0 + 0.75, wy, OFF_Z1), plaster, true)
	box(Vector3(X1 - 23.3, 3.4, 0.2), Vector3((23.3 + X1) * 0.5, wy, OFF_Z1), plaster, true)
	box(Vector3(1.3, 1.1, 0.2), Vector3(22.65, OFF_Y + 2.85, OFF_Z1), plaster, true)
	box(Vector3(0.2, 1.1, dz), Vector3(OFF_X0, OFF_Y + 0.55, cz), plaster, true)
	box(Vector3(0.2, 0.5, dz), Vector3(OFF_X0, OFF_Y + 3.15, cz), plaster, true)
	box(Vector3(0.2, 1.8, 2.0), Vector3(OFF_X0, OFF_Y + 2.0, OFF_Z0 + 1.0), plaster, true)
	box(Vector3(0.2, 1.8, 2.0), Vector3(OFF_X0, OFF_Y + 2.0, OFF_Z1 - 1.0), plaster, true)
	box(Vector3(dx + 0.4, 0.2, dz + 0.4), Vector3(OFF_X0 + dx * 0.5, OFF_Y + 3.5, cz), _steel, true)
	# the window: mullions and grimy glass, the glass no barrier to looking
	solid_box(Vector3(0.1, 1.8, 8.0), Vector3(OFF_X0, OFF_Y + 2.0, cz))
	for k in 5:
		box(Vector3(0.12, 1.8, 0.07), Vector3(OFF_X0, OFF_Y + 2.0, OFF_Z0 + 2.0 + k * 2.0), trim)
	box(Vector3(0.12, 0.07, 8.0), Vector3(OFF_X0, OFF_Y + 2.0, cz), trim)
	var glass := StandardMaterial3D.new()
	glass.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	glass.albedo_color = Color(0.5, 0.55, 0.5, 0.16)
	glass.roughness = 0.2
	glass.albedo_texture = Tex.cracked()
	var gq := quad(Vector2(8.0, 1.8), Vector3(OFF_X0 - 0.02, OFF_Y + 2.0, cz), -PI / 2.0, glass, dyn)
	gq.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var it := interactable("window", LINES["prompts"]["window"], Vector3(OFF_X0 + 0.2, OFF_Y + 2.0, cz), Vector3(0.3, 1.6, 7.6), "", false)
	# the steel stair up the north side and its landing
	_obox(Vector3(12.0, 0.05, 6.2), Vector3(20.3, OFF_Y + 0.05, 6.2), 1.6, 0.3, 0.0, 0.0, true, _steel)
	for k in 10:
		var t := (k + 0.5) / 10.0
		box(Vector3(0.28, 0.05, 1.5), Vector3(12.0 + t * 8.3, t * OFF_Y + 0.08, 6.2), _steel)
	box(Vector3(4.2, 0.2, 2.6), Vector3(22.4, OFF_Y - 0.1, 6.3), _steel, true)
	for k in 6:
		var x := 12.0 + k * 1.66
		stick(Vector3(x, (x - 12.0) / 8.3 * OFF_Y, 7.0), Vector3(x, (x - 12.0) / 8.3 * OFF_Y + 1.0, 7.0), 0.02, _steel)
	stick(Vector3(12.0, 1.0, 7.0), Vector3(20.3, OFF_Y + 1.0, 7.0), 0.025, _steel)
	stick(Vector3(20.3, OFF_Y + 1.0, 7.6), Vector3(24.5, OFF_Y + 1.0, 7.6), 0.025, _steel)
	solid_box(Vector3(8.4, 1.0, 0.1), Vector3(16.2, 1.3, 7.05))
	solid_box(Vector3(4.2, 1.0, 0.1), Vector3(22.4, OFF_Y + 0.5, 7.6))
	# inside: the oak desk, its chair, cabinets, the ledger, papers, the dead box
	var oak := pbr("woodfloor", Vector3(1, 1, 1) / 0.8, true, Color(0.42, 0.26, 0.14), 0.9)
	var dpos := Vector3(26.5, OFF_Y, -3.0)
	box(Vector3(1.0, 0.08, 2.0), dpos + Vector3(0, 0.78, 0), oak, true)
	box(Vector3(0.9, 0.74, 0.5), dpos + Vector3(0, 0.37, -0.7), oak)
	box(Vector3(0.9, 0.74, 0.5), dpos + Vector3(0, 0.37, 0.7), oak)
	for k in 3:
		box(Vector3(0.02, 0.16, 0.42), dpos + Vector3(-0.46, 0.18 + k * 0.2, 0.7), trim)
	box(Vector3(0.3, 0.06, 0.4), dpos + Vector3(-0.1, 0.85, 0.3), mat(Color(0.2, 0.08, 0.06), 0.9))
	label("TUNELET", dpos + Vector3(-0.1, 0.885, 0.3), 0.0, 0.0012, Color(0.6, 0.5, 0.3), self, false).rotation.x = -PI / 2.0
	var paper := decal_mat(Tex.paper(19), Color(0.7, 0.66, 0.56, 0.95), 0.9)
	for k in 9:
		var pq := floor_quad(Vector2(0.24, 0.32), Vector3(rng.randf_range(22.0, 29.0), OFF_Y + 0.012 + k * 0.001, rng.randf_range(-6.4, 4.4)), rng.randf() * TAU, paper)
		pq.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	floor_quad(Vector2(0.4, 0.5), dpos + Vector3(0.1, 0.83, -0.4), 0.3, paper)
	box(Vector3(0.5, 0.06, 0.5), Vector3(25.6, OFF_Y + 0.46, -3.0), oak)
	box(Vector3(0.06, 0.6, 0.5), Vector3(25.9, OFF_Y + 0.8, -3.0), oak)
	for lz: float in [-6.2, -5.5]:
		box(Vector3(0.6, 1.4, 0.6), Vector3(29.4, OFF_Y + 0.7, lz), mat(Color(0.3, 0.32, 0.3), 0.6, 0.5), true)
	prop("steel_frame_shelves_01", Vector3(29.3, OFF_Y, 2.8), -PI / 2.0, 0.9, true)
	var cal := quad(Vector2(0.5, 0.7), Vector3(29.88, OFF_Y + 1.9, -1.0), -PI / 2.0, decal_mat(Tex.paper(7), Color(0.75, 0.7, 0.58), 0.9))
	cal.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	label("19", Vector3(29.86, OFF_Y + 1.8, -1.0), -PI / 2.0, 0.004, Color(0.2, 0.05, 0.04), self, false)
	box(Vector3(0.42, 0.36, 0.4), dpos + Vector3(0.1, 0.2, 0.0), mat(Color(0.38, 0.33, 0.25), 0.8))
	light(Vector3(25.0, OFF_Y + 3.0, -1.0), Color(0.55, 0.62, 0.7), 0.35, 8.0)
	interactable("desk", LINES["prompts"]["desk"], dpos + Vector3(0, 0.9, 0), Vector3(1.0, 0.3, 1.8), LINES["scan"]["desk"], false)
	var ti := interactable("terminal", LINES["prompts"]["terminal"], dpos + Vector3(0.1, 0.2, 0.0), Vector3(0.5, 0.4, 0.5), LINES["scan"]["terminal"], false)
	ti.set_meta("hackable", true)
	var uo := interactable("under_office", LINES["prompts"]["under_office"], Vector3(OFF_X0 + 0.3, 0.9, -5.0), Vector3(0.4, 1.6, 2.0), "", false)
	uo.set_meta("route", "under_office")
	it.set_meta("view", true)


## The drill housing: a Tunelet boring machine on its rails against the
## north wall, cold for twenty years, and the gap behind it.
func _drill() -> void:
	var rust := pbr("rust", Vector3(1, 1, 1) / 1.5, true, Color(0.8, 0.7, 0.6), 1.0)
	var c := DRILL + Vector3(0, 1.75, 0)
	var body := cyl(1.6, 1.6, 6.5, c, rust, 16)
	body.rotation.x = PI / 2.0
	var head := cyl(1.85, 1.85, 0.5, c + Vector3(0, 0, -3.4), rust, 16)
	head.rotation.x = PI / 2.0
	for k in 12:
		var a := TAU * k / 12.0
		stick(c + Vector3(cos(a) * 0.4, sin(a) * 0.4, -3.66), c + Vector3(cos(a) * 1.75, sin(a) * 1.75, -3.66), 0.08, _steel)
		box(Vector3(0.18, 0.18, 0.3), c + Vector3(cos(a) * 1.6, sin(a) * 1.6, -3.8), _steel)
	box(Vector3(2.6, 1.3, 3.6), c + Vector3(0, 1.9, 0.8), rust)
	box(Vector3(3.6, 0.5, 6.8), DRILL + Vector3(0, 0.25, 0), _steel)
	solid_box(Vector3(3.8, 3.8, 7.4), c + Vector3(0, 0, -0.2))
	label("TUNELET TBM-5", c + Vector3(1.62, 0.6, 0.0), PI / 2.0, 0.006, Color(0.75, 0.6, 0.3), self, false)
	prop("power_box_01", DRILL + Vector3(2.4, 0, 3.6), PI, 1.0, true)
	prop("old_tyre", DRILL + Vector3(-2.6, 0, -4.4), 0.4, 1.0, false)
	prop("Barrel_01", DRILL + Vector3(2.6, 0, -4.0), 0.0, 1.0, true)
	var it := interactable("drill", LINES["prompts"]["drill"], c + Vector3(1.7, -0.6, 2.4), Vector3(0.4, 2.0, 2.4), LINES["scan"]["drill"])
	it.set_meta("route", "drill")


## The catwalk along the east wall at 7 m, over the office roof, with a steel
## stair up from the north end (a stealth route for later).
func _catwalk() -> void:
	var grate := mat(Color(0.16, 0.16, 0.17), 0.6, 0.7)
	box(Vector3(1.4, 0.1, 66.0), Vector3(X1 - 0.7, 7.0, 10.0), grate, true)
	for k in 23:
		var z := -22.5 + k * 3.0
		stick(Vector3(X1 - 1.4, 7.0, z), Vector3(X1 - 1.4, 8.05, z), 0.025, _steel)
		box(Vector3(0.6, 0.12, 0.12), Vector3(X1 - 0.3, 6.9, z), _steel)
	box(Vector3(0.05, 0.05, 66.0), Vector3(X1 - 1.4, 8.05, 10.0), _steel)
	solid_box(Vector3(0.1, 1.2, 66.0), Vector3(X1 - 1.45, 7.6, 10.0))
	_obox(Vector3(9.0, 0.05, 44.8), Vector3(26.5, 7.0, 44.8), 1.4, 0.3, 0.0, 0.0, true, grate)
	box(Vector3(2.4, 0.1, 2.4), Vector3(X1 - 1.6, 6.95, 44.4), grate, true)
	for k in 14:
		var t := (k + 0.5) / 14.0
		box(Vector3(1.25, 0.04, 0.28), Vector3(9.0 + t * 17.5, t * 7.0 + 0.07, 44.8), _steel)
	var it := interactable("catwalk", LINES["prompts"]["catwalk"], Vector3(9.6, 0.9, 44.8), Vector3(0.6, 1.6, 1.4))
	it.set_meta("route", "catwalk")


## Book weird-happenings and dead machines on the floor: crates and drums of
## the old dig, a server rack gutted, conduits, the shelves.
func _dressing() -> void:
	prop("server_rack", Vector3(-44.0, 0, -24.0), 0.4, 1.0, true)
	prop("steel_frame_shelves_01", Vector3(-52.0, 0, 10.0), PI / 2.0, 1.0, true)
	prop("cardboard_box_01", Vector3(-51.0, 0, 13.0), 0.3, 1.0, false)
	prop("plastic_crate_03", Vector3(-46.0, 0, -22.0), 0.9, 1.0, false)
	prop("Barrel_01", Vector3(-26.0, 0, 42.5), 0.0, 1.0, true)
	prop("Barrel_01", Vector3(-24.8, 0, 43.4), 0.7, 1.0, true)
	prop("modular_airduct_circular_01", Vector3(-30.0, CAV_H - 3.0, 10.0), 0.0, 1.0, false)
	prop("modular_electric_cables", Vector3(X1 - 0.4, 3.0, 20.0), -PI / 2.0, 1.0, false)
	prop("utility_box_01", Vector3(X1 - 0.3, 1.0, 14.0), -PI / 2.0, 1.0, false)
	prop("security_camera_01", Vector3(3.0, 11.0, Z1 - 0.3), PI, 1.0, false)
	# a few dead hard hats and a coil of cable where the crews left them
	var hat := mat(Color(0.75, 0.6, 0.12), 0.5)
	for p: Vector3 in [Vector3(-40, 0.12, 30), Vector3(-41, 0.12, 31.4), Vector3(-8, 0.12, 40)]:
		sphere(0.16, p, hat, 8)
	for k in 6:
		var r := 0.5 - k * 0.03
		var tor := TorusMesh.new()
		tor.inner_radius = r - 0.03
		tor.outer_radius = r
		tor.rings = 12
		tor.ring_segments = 4
		mesh(tor, Vector3(-28.0, 0.04 + k * 0.05, 30.0), mat(Color(0.06, 0.06, 0.06), 0.6))


## Outside, above the facility, Day 3 at dusk: the lot, the bunker door we
## come out of, the two cars, the desert and its red hills, the moon rising,
## and the city far off with the tower in its middle.
func _outside_lot() -> void:
	var sand := pbr("plaster", Vector3(1, 1, 1) / 4.0, true, Color(0.6, 0.45, 0.33), 1.0)
	var asphalt := pbr("asphalt", Vector3(1, 1, 1) / 4.0, true, Color(0.5, 0.48, 0.46), 1.0)
	solid_box(Vector3(400, 2, 400), OUT + Vector3(0, -1.0, -60))
	for ix in range(-3, 3):
		for iz in range(-5, 1):
			floor_quad(Vector2(60, 60), OUT + Vector3(ix * 60 + 30, -0.01, iz * 60 + 30), 0.0, sand)
	floor_quad(Vector2(36, 26), OUT + Vector3(2, 0.005, -14), 0.0, asphalt)
	# the bunker: army-green concrete round the door we come out of
	var green := pbr("concrete", Vector3(1, 1, 1) / 2.5, true, Color(0.34, 0.38, 0.3), 1.0)
	box(Vector3(14, 5.0, 10), OUT + Vector3(0, 2.5, 6.5), green, true)
	box(Vector3(2.0, 2.6, 0.2), OUT + Vector3(0, 1.3, 1.45), mat(Color(0.02, 0.02, 0.02)))
	box(Vector3(2.4, 0.2, 0.3), OUT + Vector3(0, 2.7, 1.4), _steel)
	label("TUNELET  SITE 3", OUT + Vector3(0, 3.4, 1.38), PI, 0.007, Color(0.6, 0.58, 0.5), self, false)
	interactable("bunker", LINES["prompts"]["bunker"], OUT + Vector3(0, 1.3, 1.6), Vector3(2.0, 2.4, 0.3), "", false)
	# barriers, a dead lamp, a box, the fence
	for k in 4:
		prop("concrete_road_barrier", OUT + Vector3(-14 + k * 3.2, 0, -26), 0.05 * k, 1.0, true)
	prop("street_lamp_01", OUT + Vector3(12, 0, -6), PI, 1.0, true)
	prop("utility_box_02", OUT + Vector3(7.5, 0, 1.0), PI, 1.0, true)
	for k in 16:
		var x := -22.0 + k * 3.0
		stick(OUT + Vector3(x, 0, -30), OUT + Vector3(x, 2.2, -30), 0.04, _steel)
	box(Vector3(46, 0.04, 0.04), OUT + Vector3(0.5, 2.15, -30), _steel)
	interactable("lot", LINES["prompts"]["lot"], OUT + Vector3(-12.0, 0.6, -26.0), Vector3(3.0, 1.2, 1.0), "", false)
	# the cars: mine, and Lynx's, left with its door open and the sand on it
	var mine := CarS.build(self, Color(0.75, 0.78, 0.8), {"plate": "PSF 0086"})
	mine.position = OUT + Vector3(4.5, 0, -13.0)
	mine.rotation.y = 0.35
	dyn.add_child(mine)
	var mi := interactable("my_car", LINES["outside"]["car_prompt"], Vector3(0, 0.9, 0), Vector3(2.0, 1.6, 4.6), LINES["outside"]["car_scan"], true, mine)
	mi.set_meta("hackable", true)
	mi.set_meta("exit", true)
	var hers := CarS.build(self, Color(0.34, 0.07, 0.08), {"plate": "LYX 2210"})
	hers.position = OUT + Vector3(-6.5, 0, -11.0)
	hers.rotation.y = -0.5
	dyn.add_child(hers)
	interactable("lynx_car", LINES["prompts"]["lynx_car"], Vector3(0, 0.9, 0), Vector3(2.0, 1.6, 4.6), "", true, hers)
	floor_quad(Vector2(2.0, 4.0), OUT + Vector3(-6.5, 1.32, -11.0), -0.5, decal_mat(Tex.sand(), Color(0.7, 0.55, 0.4, 0.6), 1.0))
	# the red hills
	var hill := mat(Color(0.32, 0.12, 0.08), 1.0)
	for k in 9:
		var a := -PI * 0.15 + k * 0.32 + rng.randf_range(-0.1, 0.1)
		var dist := rng.randf_range(260.0, 420.0)
		var hp := OUT + Vector3(sin(a) * dist, 0, -cos(a) * dist)
		var hh := rng.randf_range(18.0, 46.0)
		cyl(rng.randf_range(18, 34), rng.randf_range(40, 70), hh, hp + Vector3(0, hh * 0.5, 0), hill, 7)
	# the city far off to the north-east, the tower stabbed in its middle
	var city := newmat(Color(0.05, 0.05, 0.07), 0.9)
	city.disable_fog = true
	var win := newglow(Color(0.9, 0.75, 0.45), 1.6)
	win.disable_fog = true
	var cc := OUT + Vector3(260, 0, -1150)
	for k in 26:
		var bx := cc + Vector3(rng.randf_range(-260, 260), 0, rng.randf_range(-60, 60))
		var bh := rng.randf_range(30, 120) * (1.0 - absf(bx.x - cc.x) / 400.0)
		box(Vector3(rng.randf_range(16, 40), bh, 20), bx + Vector3(0, bh * 0.5, 0), city)
		for j in 3:
			box(Vector3(3, 2, 0.5), bx + Vector3(rng.randf_range(-6, 6), rng.randf_range(4, bh - 4), 10.3), win)
	var tower := newmat(Color(0.12, 0.16, 0.15), 0.4, 0.6)
	tower.disable_fog = true
	cyl(5.0, 9.0, 420.0, cc + Vector3(0, 210, 0), tower, 10)
	var ring := TorusMesh.new()
	ring.inner_radius = 34.0
	ring.outer_radius = 44.0
	ring.rings = 24
	ring.ring_segments = 8
	var jade := newglow(Color(0.3, 1.0, 0.6), 1.4)
	jade.disable_fog = true
	var rm := mesh(ring, cc + Vector3(0, 340, 0), jade)
	rm.rotation.x = PI / 2.0
	sphere(22.0, cc + Vector3(0, 340, 0), tower, 12)
	var tipm := newglow(Color(1, 0.1, 0.08), 6.0)
	tipm.disable_fog = true
	sphere(2.5, cc + Vector3(0, 424, 0), tipm, 6)
	# the moon, rising
	var moon_m := newmat(Color(0.95, 0.93, 0.85))
	moon_m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	moon_m.disable_fog = true
	sphere(30.0, OUT + Vector3(-240, 44, -640), moon_m, 20)
	var halo_m := StandardMaterial3D.new()
	halo_m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	halo_m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	halo_m.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	halo_m.albedo_texture = Tex.blob()
	halo_m.albedo_color = Color(0.5, 0.48, 0.42, 0.6)
	halo_m.disable_fog = true
	halo_m.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	var hq := quad(Vector2(170, 170), OUT + Vector3(-238, 44, -636), 0.0, halo_m, dyn)
	hq.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	interactable("moon", LINES["prompts"]["moon"], OUT + Vector3(-3.0, 1.4, -9.0), Vector3(1.0, 1.0, 1.0), "", false)


# ------------------------------------------------------------------ the hundred

## Three silhouettes under the cloth (the tall ones, the stooped ones, the
## ones folded in on themselves), each standing and seated: six MultiMeshes,
## a hundred figures, two draw calls a shape.
func _congregation() -> void:
	_robe_m = (pbr("fabric", Vector3(3, 3, 1), false, Color(0.13, 0.12, 0.13), 1.0)).duplicate()
	_robe_m.vertex_color_use_as_albedo = true
	var void_m := mat(Color(0.004, 0.004, 0.005), 1.0)
	var A_body := [[0.0, 0.4, 0.4, 0.02], [0.08, 0.38, 0.37, 0.02], [0.5, 0.32, 0.29, 0.01], [0.95, 0.25, 0.2, -0.02], [1.2, 0.24, 0.17, -0.02],
		[1.42, 0.26, 0.17, 0.0], [1.52, 0.22, 0.15, 0.01], [1.58, 0.13, 0.12, 0.02]]
	var A_hood := [[1.5, 0.15, 0.16, 0.02], [1.62, 0.155, 0.17, 0.01], [1.76, 0.15, 0.165, 0.02], [1.88, 0.11, 0.13, 0.05], [1.98, 0.03, 0.04, 0.1]]
	var A_face := [[1.6, 0.075, 0.015, -0.158], [1.69, 0.09, 0.02, -0.168], [1.78, 0.065, 0.015, -0.152]]
	var A_sit := [[0.0, 0.42, 0.48, 0.06], [0.1, 0.42, 0.47, 0.06], [0.32, 0.36, 0.38, 0.04], [0.52, 0.26, 0.22, 0.0], [0.78, 0.24, 0.17, -0.02],
		[0.98, 0.26, 0.17, 0.0], [1.08, 0.22, 0.15, 0.01], [1.14, 0.13, 0.12, 0.02]]
	var B_body := [[0.0, 0.38, 0.38, 0.03], [0.5, 0.3, 0.27, 0.0], [0.9, 0.24, 0.2, -0.03], [1.12, 0.24, 0.19, -0.07], [1.3, 0.25, 0.19, -0.1],
		[1.4, 0.2, 0.16, -0.13], [1.45, 0.12, 0.12, -0.16]]
	var B_hood := [[1.36, 0.14, 0.15, -0.2], [1.46, 0.15, 0.16, -0.23], [1.58, 0.14, 0.15, -0.24], [1.68, 0.1, 0.12, -0.22], [1.76, 0.03, 0.04, -0.17]]
	var B_face := [[1.4, 0.07, 0.015, -0.388], [1.48, 0.085, 0.02, -0.398], [1.56, 0.06, 0.015, -0.388]]
	var B_sit := [[0.0, 0.4, 0.46, 0.05], [0.3, 0.35, 0.36, 0.02], [0.5, 0.26, 0.22, -0.02], [0.72, 0.24, 0.19, -0.07], [0.88, 0.25, 0.19, -0.1],
		[0.96, 0.2, 0.16, -0.13], [1.0, 0.12, 0.12, -0.16]]
	var C_body := [[0.0, 0.36, 0.36, 0.04], [0.45, 0.3, 0.28, 0.0], [0.75, 0.26, 0.24, -0.08], [0.95, 0.26, 0.24, -0.2], [1.08, 0.25, 0.22, -0.3],
		[1.14, 0.2, 0.18, -0.36], [1.17, 0.12, 0.12, -0.4]]
	var C_hood := [[1.05, 0.14, 0.15, -0.46], [1.12, 0.15, 0.16, -0.52], [1.2, 0.13, 0.14, -0.55], [1.26, 0.09, 0.11, -0.53], [1.3, 0.03, 0.04, -0.48]]
	var C_face := [[1.03, 0.065, 0.015, -0.662], [1.1, 0.08, 0.02, -0.682], [1.17, 0.06, 0.015, -0.672]]
	var C_sit := [[0.0, 0.44, 0.56, -0.05], [0.18, 0.42, 0.52, -0.08], [0.38, 0.34, 0.42, -0.16], [0.52, 0.24, 0.3, -0.26], [0.6, 0.14, 0.18, -0.34],
		[0.63, 0.06, 0.08, -0.38]]
	var C_sit_hood := [[0.18, 0.14, 0.15, -0.6], [0.3, 0.15, 0.16, -0.62], [0.42, 0.13, 0.15, -0.6], [0.5, 0.08, 0.1, -0.55]]
	var C_sit_face := [[0.18, 0.06, 0.01, -0.772], [0.26, 0.07, 0.015, -0.782], [0.34, 0.05, 0.01, -0.762]]
	var stands := [_robe_mesh(A_body, A_hood, A_face, void_m), _robe_mesh(B_body, B_hood, B_face, void_m), _robe_mesh(C_body, C_hood, C_face, void_m)]
	var sits := [_robe_mesh(A_sit, _shift(A_hood, -0.44), _shift(A_face, -0.44), void_m), _robe_mesh(B_sit, _shift(B_hood, -0.45), _shift(B_face, -0.45), void_m),
		_robe_mesh(C_sit, C_sit_hood, C_sit_face, void_m)]
	# seats: four rings round the throne, an open path from the stair (north)
	var seats := []
	for ring: Array in [[7.0, 22], [9.0, 26], [11.0, 26], [13.0, 26]]:
		var r: float = ring[0]
		var n: int = ring[1]
		var gap := 0.2 + 2.2 / r
		for k in n:
			var a := gap + (TAU - 2.0 * gap) * (k + 0.5) / n + rng.randf_range(-0.03, 0.03)
			seats.append(Vector3(sin(a) * r, 0.0, cos(a) * r))
	var counts := [0, 0, 0]
	for i in N_CONG:
		var t := 0 if rng.randf() < 0.45 else (1 if rng.randf() < 0.6 else 2)
		var seat: Vector3 = seats[i]
		var ang := atan2(seat.x, seat.z)
		var from_stair := i % 5 < 2
		var start: Vector3
		var path := []
		if from_stair:
			start = Vector3(rng.randf_range(-1.2, 1.2), LAND_Y, 49.0)
			path = [Vector3(start.x, LAND_Y, Z1 - 0.5), Vector3(start.x * 0.8, 0.0, FOOT_Z - 0.5), Vector3(start.x, 0.0, 17.0)]
			var a0 := 0.15
			var steps := 5
			for s in steps:
				var aa := lerpf(a0 if ang >= 0.0 else -a0, ang, float(s + 1) / steps)
				path.append(Vector3(sin(aa) * 16.0, 0.0, cos(aa) * 16.0))
		else:
			var ra := ang + rng.randf_range(-0.35, 0.35)
			var rr := rng.randf_range(30.0, 46.0)
			start = Vector3(clampf(sin(ra) * rr, X0 + 2.0, X1 - 2.0), 0.0, clampf(cos(ra) * rr, Z0 + 2.0, Z1 - 3.0))
			if start.x > 18.0 and start.z > OFF_Z0 - 2.0 and start.z < OFF_Z1 + 3.0:
				start.x = 17.0
		path.append(seat)
		cong.append({"t": t, "idx": counts[t], "pos": start, "start": start, "yaw": atan2(-(seat.x - start.x), -(seat.z - start.z)),
			"seat": seat, "seat_yaw": atan2(seat.x, seat.z), "path": path, "pi": 0, "delay": 0.0,
			"state": "wait", "stair": from_stair, "s": rng.randf_range(0.94, 1.07), "ph": rng.randf() * TAU, "want": 0.0})
		counts[t] += 1
	for t in 3:
		for kind in 2:
			var mm := MultiMesh.new()
			mm.transform_format = MultiMesh.TRANSFORM_3D
			mm.use_colors = true
			mm.mesh = stands[t] if kind == 0 else sits[t]
			mm.instance_count = counts[t]
			mm.custom_aabb = AABB(Vector3(-90, -60, -60), Vector3(180, 140, 180))
			for k in counts[t]:
				var shade := rng.randf_range(0.65, 1.15)
				mm.set_instance_color(k, Color(shade, shade * rng.randf_range(0.92, 1.0), shade * rng.randf_range(0.9, 1.05)))
				mm.set_instance_transform(k, _hidden_xf())
			var mmi := MultiMeshInstance3D.new()
			mmi.multimesh = mm
			mmi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
			dyn.add_child(mmi)
			if kind == 0:
				mm_stand.append(mm)
			else:
				mm_sit.append(mm)
	# something to look at in each quarter of the circle (live once seated)
	for k in 8:
		var sp: Vector3 = seats[78 + k * 3]
		var it := interactable("congregation", LINES["prompts"]["congregation"], sp + Vector3(0, 0.6, 0), Vector3(1.2, 1.2, 1.2), LINES["scan"]["congregation"], false, dyn)
		it.set_meta("cultist", true)
		it.collision_layer = 0
		cong_its.append(it)


## The sea of lights over their heads, one for each of them, that becomes
## the Eye: glowing points on the eye layer, a violet light with them.
func _lights() -> void:
	var sm := SphereMesh.new()
	sm.radius = 0.09
	sm.height = 0.18
	sm.radial_segments = 6
	sm.rings = 3
	var gm := newglow(Color(0.92, 0.88, 1.0), 4.0)
	gm.disable_fog = true
	sm.material = gm
	lights_mm = MultiMesh.new()
	lights_mm.transform_format = MultiMesh.TRANSFORM_3D
	lights_mm.mesh = sm
	lights_mm.instance_count = N_CONG
	lights_mm.custom_aabb = AABB(Vector3(-40, -10, -40), Vector3(80, 40, 80))
	for i in N_CONG:
		lights_mm.set_instance_transform(i, _hidden_xf())
	lights_mi = MultiMeshInstance3D.new()
	lights_mi.multimesh = lights_mm
	lights_mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	lights_mi.visible = false
	dyn.add_child(lights_mi)
	eye_light = OmniLight3D.new()
	eye_light.light_color = VIOLET
	eye_light.light_energy = 0.0
	eye_light.omni_range = 24.0
	eye_light.position = Vector3(0, 8.0, 0)
	add_child(eye_light)
	hud_light = OmniLight3D.new()
	hud_light.light_color = Color(0.55, 0.4, 0.95)
	hud_light.light_energy = 0.0
	hud_light.omni_range = 9.0
	add_child(hud_light)


## The three in white (the Prophet, masked; the acolyte with the cube; Eren
## with the bowl), the three devotees in the far corner, and Lynx.
func _people() -> void:
	var white := Color(0.9, 0.9, 0.87)
	var robe_white := mat(Color(0.82, 0.82, 0.8), 0.9)
	# the Prophet: Subject 41
	prophet = figure(white, Color(0.78, 0.64, 0.55), {"arms": true, "knees": true, "hair": Color(0.2, 0.18, 0.16), "legs": white, "long_coat": true})
	dyn.add_child(prophet)
	robe_skirt = _skirt(prophet, robe_white)
	var hd: Node3D = prophet.get_meta("head")
	prophet_head = _head_mi(prophet)
	faces["prophet"] = _eyeless_face(Color(0.78, 0.64, 0.55), Color(0.2, 0.18, 0.16), 41, true)
	prophet_head.material_override = faces["prophet"]
	var bone := mat(Color(0.86, 0.83, 0.74), 0.55)
	mask_mi = sphere(0.1, Vector3(0, 0.0, -0.075), bone, 12, hd)
	mask_mi.scale = Vector3(1.05, 1.28, 0.62)
	for s: float in [-1.0, 1.0]:
		var bs := box(Vector3(0.012, 0.09, 0.006), Vector3(s * 0.045, -0.035, -0.112), mat(Color(0.4, 0.02, 0.02), 0.3), false, hd)
		bs.visible = false
		blood_streaks.append(bs)
	var pi := person("prophet", LINES["prompts"]["prophet"], prophet, LINES["scan"]["prophet"])
	pi.set_meta("cultist", true)
	blade = box(Vector3(0.025, 0.32, 0.05), Vector3(0, -0.72, -0.08), mat(Color(0.01, 0.01, 0.012), 0.1, 0.9), false, prophet.get_meta("arms")[1])
	blade.visible = false
	# the acolyte with the cube
	acolyte = figure(white, Color(0.62, 0.48, 0.38), {"arms": true, "knees": true, "hair": Color(0.04, 0.04, 0.04), "legs": white, "long_coat": true})
	dyn.add_child(acolyte)
	_skirt(acolyte, robe_white)
	var cube_m := mat(Color(0.004, 0.004, 0.005), 0.04, 0.9)
	box(Vector3(0.26, 0.2, 0.26), Vector3(0, 1.0, -0.42), cube_m, false, acolyte)
	cube_lid = box(Vector3(0.26, 0.06, 0.26), Vector3(0, 1.13, -0.42), cube_m, false, acolyte)
	for a in acolyte.get_meta("arms"):
		(a as Node3D).rotation.x = -1.15
	var ai := person("acolyte", LINES["prompts"]["acolyte"], acolyte, LINES["scan"]["acolyte"])
	ai.set_meta("cultist", true)
	# Eren Elontiel with the bowl (the white of his broadcasts, here a robe)
	eren = figure(white, Color(0.84, 0.7, 0.6), {"arms": true, "knees": true, "hair": Color(0.6, 0.6, 0.6), "legs": white, "long_coat": true})
	dyn.add_child(eren)
	_skirt(eren, robe_white)
	bowl = Node3D.new()
	bowl.position = Vector3(0, 1.02, -0.42)
	eren.add_child(bowl)
	cyl(0.15, 0.08, 0.1, Vector3.ZERO, mat(Color(0.82, 0.8, 0.74), 0.35), 12, bowl)
	var liquid := newglow(Color(0.12, 0.02, 0.16), 0.5)
	liquid.albedo_color = Color(0.01, 0.0, 0.015)
	liquid.metallic = 0.9
	liquid.roughness = 0.05
	cyl(0.135, 0.135, 0.01, Vector3(0, 0.045, 0), liquid, 12, bowl)
	for a in eren.get_meta("arms"):
		(a as Node3D).rotation.x = -1.15
	var ei := person("eren", LINES["prompts"]["eren"], eren, LINES["scan"]["eren"])
	ei.set_meta("cultist", true)
	whites = [[prophet, pi], [acolyte, ai], [eren, ei]]
	for w: Array in whites:
		_show(w[0], w[1], false)
	# the halo the frames paint round him
	var hm := StandardMaterial3D.new()
	hm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	hm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	hm.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	hm.albedo_texture = _halo_tex()
	hm.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	hm.disable_fog = true
	var hq := QuadMesh.new()
	hq.size = Vector2(1.5, 1.5)
	halo = mesh(hq, Vector3(0, 1.75, 0), hm, prophet)
	halo.visible = false
	# the three devotees, hooded, in the far corner
	var dark := Color(0.1, 0.09, 0.1)
	var robe_dark := mat(Color(0.08, 0.075, 0.08), 0.95)
	var void_m := mat(Color(0.004, 0.004, 0.005), 1.0)
	for k in 3:
		var no: int = [1256, 1269, 1395][k]
		var sk: Color = [Color(0.86, 0.7, 0.6), Color(0.55, 0.4, 0.3), Color(0.8, 0.64, 0.52)][k]
		var fg := figure(dark, sk, {"arms": true, "knees": true, "long_hair": k == 0, "hair": Color(0.1, 0.07, 0.05), "long_coat": true})
		fg.position = CORNER + Vector3(k * 1.2, 0.0, -k * 0.6)
		dyn.add_child(fg)
		turn_to(fg, ALTAR)
		_skirt(fg, robe_dark)
		var h2: Node3D = fg.get_meta("head")
		var hood := Node3D.new()
		h2.add_child(hood)
		var st := SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		Body.loft(st, [[-0.2, 0.15, 0.16, 0.03], [-0.04, 0.145, 0.16, 0.01], [0.1, 0.14, 0.15, 0.02], [0.2, 0.09, 0.11, 0.05], [0.27, 0.02, 0.03, 0.09]], Rect2(0, 0, 1, 1), Transform3D(), true, false, 12)
		st.generate_normals()
		mesh(st.commit(), Vector3.ZERO, robe_dark, hood)
		var vst := SurfaceTool.new()
		vst.begin(Mesh.PRIMITIVE_TRIANGLES)
		Body.loft(vst, [[-0.08, 0.07, 0.012, -0.152], [0.0, 0.085, 0.018, -0.162], [0.08, 0.06, 0.012, -0.15]], Rect2(0, 0, 1, 1), Transform3D(), true, true, 10)
		vst.generate_normals()
		mesh(vst.commit(), Vector3.ZERO, void_m, hood)
		(h2 as Node3D).rotation.x = 0.35
		var it := person("subject", LINES["prompts"]["subject"], fg, LINES["scan"]["subject"] % no)
		it.set_meta("cultist", true)
		subjects.append({"fig": fg, "it": it, "no": no, "hood": hood, "head_mi": _head_mi(fg)})
		_show(fg, it, false)
	cloth = box(Vector3(0.26, 0.3, 0.03), Vector3(0, -0.02, -0.13), mat(Color(0.85, 0.84, 0.8), 0.95), false, subjects[0]["fig"].get_meta("head"))
	cloth.visible = false
	faces["carl"] = _carl_face()
	faces["stranger"] = Body.face_mat(Color(0.7, 0.55, 0.42), Color(0.3, 0.24, 0.18), false, 73)
	faces["1395"] = subjects[2]["head_mi"].material_override
	# Lynx: hair loose, the long coat, no frames ("Thank God I didn't bring my frames")
	lynx = figure(Color(0.09, 0.08, 0.1), Color(0.88, 0.74, 0.62),
		{"hair": Color(0.12, 0.08, 0.06), "long_hair": true, "legs": Color(0.1, 0.1, 0.12), "arms": true, "knees": true, "long_coat": true})
	lynx.position = Vector3(1.3, TOP_Y, 72.5)
	dyn.add_child(lynx)
	lynx_it = person("lynx", LINES["prompts"]["lynx"], lynx, LINES["lynx"]["scan"])


## The eyeless who line the way back up: the open stair, the landing, the
## stairwell, and three on the service ramp. Statues until the frames are on.
func _eyeless_build() -> void:
	var homes := []
	for k in 5:
		var z := 28.5 + k * 3.6
		for s: float in [-1.0, 1.0]:
			homes.append([Vector3(s * 1.95, (z - FOOT_Z) / 20.0 * LAND_Y, z), "main"])
	homes.append([Vector3(1.8, LAND_Y, 49.5), "main"])
	homes.append([Vector3(-1.7, LAND_Y + (56.0 - 52.0) / 12.0 * 3.0, 56.0), "main"])
	homes.append([Vector3(1.7, LAND_Y + (61.0 - 52.0) / 12.0 * 3.0, 61.0), "main"])
	homes.append([Vector3(-1.7, TOP_Y, 66.5), "main"])
	for z: float in [52.0, 59.0, 65.5]:
		homes.append([Vector3(-17.0 + (0.9 if int(z) % 2 == 0 else -0.9), (z - 48.0) / 22.0 * TOP_Y, z), "service"])
	var skins := [Color(0.8, 0.62, 0.5), Color(0.62, 0.46, 0.34), Color(0.9, 0.76, 0.66)]
	for i in homes.size():
		var home: Vector3 = homes[i][0]
		var sk: Color = skins[i % 3]
		var gown := Color(0.62, 0.6, 0.55).darkened(rng.randf_range(0.0, 0.35))
		var fg := figure(gown, sk, {"hair": Color(0.25, 0.22, 0.2) if i % 2 == 0 else sk.darkened(0.2), "long_coat": true, "arms": true})
		fg.position = home
		dyn.add_child(fg)
		var face_to := Vector3(0.0 if homes[i][1] == "main" else -17.0, home.y, home.z)
		turn_to(fg, face_to)
		var key := "eyeless%d" % (i % 3)
		if not faces.has(key):
			faces[key] = _eyeless_face(sk, Color(0.25, 0.22, 0.2), 1200 + i, false)
		_head_mi(fg).material_override = faces[key]
		for a in fg.get_meta("arms"):
			(a as Node3D).rotation.x = -0.15
		var it := person("eyeless", LINES["prompts"]["eyeless"], fg, LINES["scan"]["eyeless"] % (1100 + i * 7))
		it.set_meta("eyeless", true)
		fg.set_meta("eyeless", true)
		eyeless.append({"fig": fg, "it": it, "home": home, "yaw": fg.rotation.y, "route": homes[i][1]})
		_show(fg, it, false)


## The doors: the office door (stuck, then slammed, then pulled open), the
## service door, and the eye-layer door at the top (brick with the frames
## off). Chevrons on the eye layer.
func _doors() -> void:
	var door_wood := pbr("woodfloor", Vector3(1, 1, 1) / 0.8, true, Color(0.3, 0.22, 0.15), 0.9)
	office_door = Node3D.new()
	office_door.position = Vector3(22.0, OFF_Y, OFF_Z1)
	dyn.add_child(office_door)
	box(Vector3(1.28, 2.3, 0.08), Vector3(0.64, 1.15, 0), door_wood, false, office_door)
	box(Vector3(0.05, 0.05, 0.12), Vector3(1.1, 1.05, -0.06), _steel, false, office_door)
	office_door_body = solid_box(Vector3(1.3, 2.3, 0.2), Vector3(22.65, OFF_Y + 1.15, OFF_Z1))
	office_door_it = interactable("office_door", LINES["prompts"]["office_door"], Vector3(22.65, OFF_Y + 1.1, OFF_Z1 + 0.18), Vector3(1.2, 2.0, 0.2))
	# the service door: steel, crew stencil
	service_door = Node3D.new()
	service_door.position = Vector3(SVC_X0, 0.0, Z1)
	dyn.add_child(service_door)
	box(Vector3(3.0, 3.2, 0.12), Vector3(1.5, 1.6, 0), pbr("rust", Vector3(1, 1, 1) / 1.5, true, Color(0.6, 0.55, 0.5), 1.0), false, service_door)
	label("CREW", Vector3(1.5, 2.2, -0.08), PI, 0.006, Color(0.75, 0.68, 0.4), service_door, false)
	service_body = solid_box(Vector3(3.0, 3.2, 0.3), Vector3(-17.0, 1.6, Z1))
	var si := interactable("service", LINES["prompts"]["service"], Vector3(-17.0, 1.4, Z1 - 0.25), Vector3(2.8, 2.6, 0.2), LINES["scan"]["service"])
	si.set_meta("route", "service_ramp")
	# the eye-layer door at the top
	exit_door = Node3D.new()
	exit_door.position = DOOR + Vector3(-1.0, 0, 0)
	dyn.add_child(exit_door)
	box(Vector3(2.0, 2.6, 0.12), Vector3(1.0, 1.3, 0), mat(Color(0.25, 0.27, 0.24), 0.5, 0.6), false, exit_door)
	box(Vector3(0.08, 0.3, 0.08), Vector3(1.7, 1.2, -0.08), _steel, false, exit_door)
	exit_brick = box(Vector3(2.2, 2.8, 0.14), DOOR + Vector3(0, 1.4, -0.02), _brick, false, dyn)
	exit_body = solid_box(Vector3(2.2, 2.8, 0.3), DOOR + Vector3(0, 1.4, 0))
	var xi := interactable("exit_door", LINES["prompts"]["exit_door"], DOOR + Vector3(0, 1.3, -0.25), Vector3(2.0, 2.4, 0.2), LINES["scan"]["exit"])
	xi.set_meta("eye_layer", true)
	# chevrons: over the office door, at the gap behind the drill, up the stair
	chev_office = _chevron(Vector3(22.65, OFF_Y + 3.0, OFF_Z1 + 0.4), 0.5)
	chev_drill = _chevron(HIDE_DRILL + Vector3(0, 2.2, 0), 0.5)
	for k in 6:
		var z := FOOT_Z + 2.0 + k * 3.5
		for s: float in [-1.0, 1.0]:
			var ch := _chevron(Vector3(s * 2.52, (z - FOOT_Z) / 20.0 * LAND_Y + 1.3, z), 0.18, true)
			ch.set_meta("escape", true)
	var gap := box(Vector3(2.6, 0.02, 1.8), HIDE_DRILL + Vector3(0, 0.02, 0.2), glow(VIOLET, 1.2), false, dyn)
	gap.set_meta("hide_cue", true)
	eye_layer.append(gap)
	_eye_layer()


## The footsteps from everywhere: eight shuffling points round the dark.
func _sound_points() -> void:
	for p: Vector3 in [Vector3(-50, 1, -20), Vector3(-50, 1, 30), Vector3(-20, 1, -26), Vector3(18, 1, -24),
			Vector3(26, 1, 30), Vector3(-30, 1, 44), Vector3(0, 10, 52), Vector3(-17, 4, 56)]:
		var ap := AudioStreamPlayer3D.new()
		ap.stream = main.sfx["step"]
		ap.position = p
		ap.unit_size = 10.0
		ap.max_distance = 120.0
		ap.volume_db = -30.0
		dyn.add_child(ap)
		steps3d.append([ap, rng.randf_range(0.2, 0.8)])


## The vision layer (under the PS1 filter) and the black card for the
## content setting and the drive panels (over it, under the dialogue).
func _layers() -> void:
	var vl := CanvasLayer.new()
	vl.layer = 4
	add_child(vl)
	vision_rect = ColorRect.new()
	vision_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vision_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	vision_mat = ShaderMaterial.new()
	var sh := Shader.new()
	sh.code = VISION_SHADER
	vision_mat.shader = sh
	vision_rect.material = vision_mat
	vision_rect.visible = false
	vl.add_child(vision_rect)
	var cl := CanvasLayer.new()
	cl.layer = 9
	add_child(cl)
	card_rect = ColorRect.new()
	card_rect.color = Color(0, 0, 0, 1)
	card_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	card_rect.visible = false
	cl.add_child(card_rect)
	card_text = RichTextLabel.new()
	card_text.bbcode_enabled = true
	card_text.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card_text.anchor_left = 0.18
	card_text.anchor_right = 0.82
	card_text.anchor_top = 0.2
	card_text.anchor_bottom = 0.62
	card_text.add_theme_font_size_override("normal_font_size", 22)
	card_text.add_theme_font_size_override("bold_font_size", 30)
	card_rect.add_child(card_text)
	panel_box = HBoxContainer.new()
	panel_box.anchor_left = 0.05
	panel_box.anchor_right = 0.95
	panel_box.anchor_top = 0.07
	panel_box.anchor_bottom = 0.6
	panel_box.add_theme_constant_override("separation", 18)
	panel_box.visible = false
	card_rect.add_child(panel_box)
	for k in 2:
		var tr := TextureRect.new()
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tr.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tr.size_flags_vertical = Control.SIZE_EXPAND_FILL
		tr.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		panel_box.add_child(tr)


# ------------------------------------------------------------------ build helpers

func _fwd(yaw: float) -> Vector3:
	return Vector3(-sin(yaw), 0, -cos(yaw))


func _right(yaw: float) -> Vector3:
	return Vector3(cos(yaw), 0, -sin(yaw))


## An oriented box along a→b (a ramp, a sloped parapet): `w` wide, `t` thick
## (hanging below the line, or standing `up` above it), with collision; a
## visible mesh too when `m` is given.
func _obox(a: Vector3, b: Vector3, w: float, t: float, up: float, side: float, solid := true, m: Material = null) -> void:
	var d := b - a
	var ln := d.length()
	var f := d / ln
	var r := f.cross(Vector3.UP).normalized()
	var u := r.cross(f).normalized()
	var bas := Basis(r, u, r.cross(u))
	var c := (a + b) * 0.5 + r * side + (u * (up) if up > 0.0 else -u * (t * 0.5))
	if solid:
		var sb := StaticBody3D.new()
		var cs := CollisionShape3D.new()
		var sh := BoxShape3D.new()
		sh.size = Vector3(w, t, ln)
		cs.shape = sh
		sb.add_child(cs)
		sb.transform = Transform3D(bas, c)
		add_child(sb)
	if m:
		var bm := BoxMesh.new()
		bm.size = Vector3(w, t, ln)
		var mi := MeshInstance3D.new()
		mi.mesh = bm
		mi.material_override = m
		mi.transform = Transform3D(bas, c)
		add_child(mi)


func _shift(rings: Array, dy: float) -> Array:
	var out := []
	for r: Array in rings:
		var n := r.duplicate()
		n[0] = float(n[0]) + dy
		out.append(n)
	return out


func _robe_mesh(body: Array, hood: Array, face: Array, void_m: Material) -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	Body.loft(st, body, Rect2(0, 0, 1, 0.7), Transform3D(), true, true, 12)
	Body.loft(st, hood, Rect2(0, 0.7, 1, 0.3), Transform3D(), true, false, 12)
	st.generate_normals()
	var am: ArrayMesh = st.commit()
	am.surface_set_material(0, _robe_m)
	var st2 := SurfaceTool.new()
	st2.begin(Mesh.PRIMITIVE_TRIANGLES)
	Body.loft(st2, face, Rect2(0, 0, 1, 1), Transform3D(), true, true, 10)
	st2.generate_normals()
	st2.commit(am)
	am.surface_set_material(1, void_m)
	return am


func _hidden_xf() -> Transform3D:
	return Transform3D(Basis().scaled(Vector3.ONE * 0.001), Vector3(0, -60, 0))


## A robe skirt to the floor over a Body figure's coat.
func _skirt(fig: Node3D, m: Material) -> MeshInstance3D:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	Body.loft(st, [[0.02, 0.36, 0.36, 0.0], [0.45, 0.3, 0.27, 0.0], [0.95, 0.22, 0.16, 0.0]], Rect2(0, 0, 1, 1), Transform3D(), false, true, 12)
	st.generate_normals()
	return mesh(st.commit(), Vector3.ZERO, m, fig)


func _head_mi(fig: Node3D) -> MeshInstance3D:
	for c in (fig.get_meta("head") as Node3D).get_children():
		if c is MeshInstance3D:
			return c
	return null


func _show(fig: Node3D, it: CollisionObject3D, on: bool) -> void:
	fig.visible = on
	if it:
		it.collision_layer = (1 | 2) if on else 0


## A face with the eyes gone: "deep, hollowed-out craters of puckered
## flesh"; the Prophet's crisscrossed with scars, faded and fresh.
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
			var fresh := k % 3 == 0
			var c := Color(0.62, 0.12, 0.1) if fresh else skin.lightened(0.18)
			for j in int(ln):
				Body._rect(img, x0 + cos(a2) * j, y0 + sin(a2) * j, 1.5, 1.5, c)
	img.generate_mipmaps()
	var m := base.duplicate() as StandardMaterial3D
	m.albedo_texture = ImageTexture.create_from_image(img)
	return m


## Carl's face for 1395: "my jaw. My scar. My uneven left brow."
func _carl_face() -> StandardMaterial3D:
	var base: StandardMaterial3D = Body.face_mat(Color(0.84, 0.66, 0.54), Color(0.12, 0.09, 0.07), false, 1)
	var img: Image = (base.albedo_texture as Texture2D).get_image()
	if img.is_compressed():
		img.decompress()
	img.clear_mipmaps()
	img.convert(Image.FORMAT_RGBA8)
	for j in 14:
		Body._rect(img, 108 + j * 0.6, 112 + j, 1.5, 1, Color(0.72, 0.5, 0.42))
	Body._rect(img, 104, 82, 14, 2, Color(0.1, 0.07, 0.05))
	img.generate_mipmaps()
	var m := base.duplicate() as StandardMaterial3D
	m.albedo_texture = ImageTexture.create_from_image(img)
	return m


## "A diffraction pattern of digital fire": the halo the frames paint.
func _halo_tex() -> ImageTexture:
	var n := 128
	var img := Image.create(n, n, false, Image.FORMAT_RGBA8)
	for y in n:
		for x in n:
			var p := Vector2(x - n * 0.5, y - n * 0.5) / (n * 0.5)
			var d := p.length()
			var a := atan2(p.y, p.x)
			var ring := exp(-pow((d - 0.42) / 0.07, 2.0))
			var spokes := pow(0.5 + 0.5 * cos(a * 26.0 + d * 18.0), 6.0) * smoothstep(0.2, 0.45, d) * smoothstep(1.0, 0.55, d)
			var v := clampf(ring + spokes * 0.6, 0.0, 1.0)
			var c := Color.from_hsv(fposmod(a / TAU + d * 0.6, 1.0), 0.65, 1.0)
			img.set_pixel(x, y, Color(c.r * v, c.g * v, c.b * v, v))
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


## Tileable black brick: the stairwell "seemed to drink the light".
func _brick_tex() -> ImageTexture:
	var img := Image.create(256, 256, false, Image.FORMAT_RGBA8)
	img.fill(Color(0.03, 0.028, 0.027))
	var r := RandomNumberGenerator.new()
	r.seed = 13
	for row in 16:
		var off := (row % 2) * 32
		for col in 5:
			var x0 := col * 64 - off
			var c := Color(0.075, 0.068, 0.062).lerp(Color(0.13, 0.115, 0.1), r.randf())
			for xs: int in [x0, x0 + 256]:
				var rr := Rect2i(xs + 1, row * 16 + 1, 62, 14).intersection(Rect2i(0, 0, 256, 256))
				if rr.size.x > 0:
					img.fill_rect(rr, c)
	for k in 1400:
		var x := r.randi() % 256
		var y := r.randi() % 256
		var c2 := img.get_pixel(x, y)
		img.set_pixel(x, y, c2.darkened(r.randf_range(0.0, 0.5)) if r.randf() < 0.7 else c2.lightened(0.15))
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


## A V of glowing violet sticks, on the eye layer.
func _chevron(p: Vector3, s: float, up := false) -> Node3D:
	var n := Node3D.new()
	n.position = p
	dyn.add_child(n)
	var g := glow(VIOLET, 3.0)
	if up:
		stick(Vector3(-s, -s * 0.5, 0), Vector3(0, s * 0.5, 0), 0.015, g, n)
		stick(Vector3(s, -s * 0.5, 0), Vector3(0, s * 0.5, 0), 0.015, g, n)
		n.rotation.x = -PI / 2.0
	else:
		stick(Vector3(-s, s * 0.6, 0), Vector3(0, -s * 0.2, 0), 0.03, g, n)
		stick(Vector3(s, s * 0.6, 0), Vector3(0, -s * 0.2, 0), 0.03, g, n)
	eye_layer.append(n)
	return n


## A unit cylinder that _place_stick stretches between two points.
func _unit_stick(m: Material, r: float) -> MeshInstance3D:
	var cm := CylinderMesh.new()
	cm.top_radius = r
	cm.bottom_radius = r
	cm.height = 1.0
	cm.radial_segments = 6
	cm.rings = 1
	var mi := MeshInstance3D.new()
	mi.mesh = cm
	mi.material_override = m
	dyn.add_child(mi)
	return mi


func _place_stick(mi: MeshInstance3D, a: Vector3, b: Vector3) -> void:
	var d := b - a
	var ln := maxf(d.length(), 0.001)
	var dir := d / ln
	var axis := Vector3.UP.cross(dir)
	var bas := Basis()
	if axis.length() > 0.0001:
		bas = Basis(axis.normalized(), Vector3.UP.angle_to(dir))
	elif dir.y < 0.0:
		bas = Basis(Vector3.RIGHT, PI)
	mi.transform = Transform3D(bas * Basis.from_scale(Vector3(1, ln, 1)), (a + b) * 0.5)


func _probe_to(pr: Dictionary, tip_at: Vector3, toward: Vector3) -> void:
	var top: Vector3 = pr["top"]
	var tip_base := tip_at - toward * 0.09
	_place_stick(pr["cable"], top, tip_base)
	_place_stick(pr["tip"], tip_base, tip_at)


# ------------------------------------------------------------------ hooks

func objective() -> String:
	var f: Dictionary = main.flags
	var o: Dictionary = LINES["objective"]
	if f.has("hangar_done"):
		return o["drive"]
	if _outside:
		return o["car"]
	if f.has("hangar_mimic"):
		return o["walk"]
	if _hid != "":
		return o["watch"]
	if f.has("hangar_song"):
		return o["hide"]
	if f.has("hangar_vast"):
		return o["altar"]
	return o["down"]


func phone() -> String:
	var f: Dictionary = main.flags
	var t: String = LINES["phone"]["greeting"]
	if f.has("hangar_song") and not f.has("hangar_vision"):
		t += LINES["phone"]["song"]
	if f.has("hangar_vision"):
		t += LINES["phone"]["vision"]
	if f.has("hangar_mimic"):
		t += LINES["phone"]["mimic"]
	if _outside:
		t = LINES["phone"]["out"]
	return "[b]PSYON[/b]\n\n" + t


func scan_people() -> Array:
	var out := []
	out.append([lynx, LINES["lynx"]["scan"]])
	for w: Array in whites:
		if (w[0] as Node3D).visible:
			out.append([w[0], (w[1] as Node).get_meta("scan")])
	for s: Dictionary in subjects:
		if (s["fig"] as Node3D).visible:
			out.append([s["fig"], LINES["scan"]["subject"] % int(s["no"])])
	return out


func intro() -> void:
	var ui = main.ui
	await ui.think(LINES["intro"]["think"])
	await ui.think(LINES["intro"]["think_2"])
	await ui.say("Lynx", LINES["lynx"]["start"])
	ui.close()
	main.log_line("time", "Day 3, 20:00: the stair down from the facility's sublevel 2")
	main.update_hud()


## The first sight of the room from the stair: set once, then the chair.
func _vast() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if _busy:
		return
	_busy = true
	f["hangar_vast"] = true
	f["cinematic"] = true
	await main.player.face(Vector3(0, 2.0, 0), 1.2)
	await ui.think(LINES["intro"]["floor"])
	await ui.think(LINES["intro"]["floor_2"])
	await main.player.face(MURAL, 1.0)
	await ui.think(LINES["intro"]["floor_3"])
	await ui.say("Lynx", LINES["lynx"]["floor"])
	ui.close()
	f.erase("cinematic")
	_busy = false
	main.update_hud()


func interact(node: Object) -> bool:
	var ui = main.ui
	var f: Dictionary = main.flags
	var e: Dictionary = LINES["examine"]
	var id := str(node.get_meta("id"))
	match id:
		"mural":
			if f.has("hangar_mural"):
				await ui.think(e["mural_after"])
				return true
			await ui.think(e["mural"])
			await ui.say("Carl", e["mural_carl"])
			await ui.think(e["mural_2"])
			f["hangar_mural"] = true
			main.log_line("evidence", e["mural_log"])
			return true
		"recliner":
			if f.has("hangar_altar"):
				await ui.think(e["recliner_after"])
				return true
			await _altar_scene()
			return true
		"fixture":
			await ui.think(e["fixture"])
			return true
		"stair":
			await ui.think(e["stair"])
			return true
		"catwalk":
			await ui.think(e["catwalk"])
			return true
		"service":
			if f.has("hangar_mimic"):
				if service_body.collision_layer != 0:
					_open_service()
				await ui.think(e["service_after"])
			elif _hiding:
				await ui.think(e["service_song"])
			elif f.has("hangar_song"):
				await ui.think(e["service"])
			else:
				await ui.think(e["service_early"] if f.has("hangar_vast") else e["service"])
			return true
		"service_ramp":
			await ui.think(e["service_after"])
			return true
		"drill":
			if _hiding and main.frames_on:
				await _hide("drill")
			elif _hiding:
				await ui.think(e["drill_off"])
			else:
				await ui.think(e["drill_early"])
			return true
		"office_door":
			if _hiding:
				await _hide("office")
			elif f.has("hangar_mimic"):
				await ui.think(e["office_out"])
			else:
				await ui.think(e["office_stuck"])
			return true
		"under_office":
			await ui.think(e["under_office"])
			return true
		"desk":
			await ui.think(e["desk"])
			if not f.has("ev_tunelet_ledger"):
				f["ev_tunelet_ledger"] = true
				main.log_line("evidence", e["desk_log"])
			return true
		"terminal":
			await ui.think(e["terminal"])
			return true
		"window":
			await ui.think(e["window_after"] if f.has("hangar_mimic") else e["window"])
			return true
		"congregation":
			await ui.think(e["congregation"] if main.frames_on else e["congregation_off"])
			return true
		"prophet":
			await ui.think(e["prophet"] if main.frames_on else e["prophet_off"])
			return true
		"eren":
			await ui.think(e["eren"])
			return true
		"acolyte":
			await ui.think(e["acolyte"])
			return true
		"subject":
			await ui.think(e["subject"])
			return true
		"eyeless":
			await ui.think(e["eyeless"] if main.frames_on else e["eyeless_dark"])
			return true
		"exit_door":
			if _outside or _door_open:
				await ui.think(e["bunker"])
			elif not f.has("hangar_mimic"):
				await ui.think(LINES["escape"]["door_early"])
			elif not main.frames_on:
				await ui.think(LINES["escape"]["door_wall"])
				ui.show_toast(LINES["escape"]["door_toast"], 3.0)
			else:
				ui.close()
				_door_t = 1.0
			return true
		"lynx":
			await _lynx_talk()
			return true
		"moon":
			await ui.think(e["moon"])
			return true
		"lot":
			await ui.think(e["lot"])
			return true
		"lynx_car":
			await ui.think(e["lynx_car"])
			return true
		"bunker":
			await ui.think(e["bunker"])
			return true
		"my_car":
			if _ended or not _outside:
				await ui.think(e["my_car_after"])
			else:
				await _drive()
			return true
	return false


func _lynx_talk() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var l: Dictionary = LINES["lynx"]
	if _outside:
		await ui.say("Lynx", l["outside"])
	elif f.has("hangar_mimic"):
		await ui.say("Lynx", l["escape"])
	elif f.has("hangar_vision"):
		await ui.say("Lynx", l["after"])
	elif _hid != "":
		await ui.say("Lynx", l["hidden"])
	elif _hiding:
		await ui.say("Lynx", l["wait"])
	elif f.has("hangar_vast"):
		await ui.say("Lynx", l["floor"])
	else:
		await ui.say("Lynx", l["start"])


# ------------------------------------------------------------------ the altar, the song

func _altar_scene() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var e: Dictionary = LINES["examine"]
	f["cinematic"] = true
	await ui.think(e["recliner"])
	await ui.think(e["recliner_1"])
	await main.player.face(ALTAR + Vector3(0, 6.0, 0), 1.0)
	await ui.think(e["recliner_2"])
	await main.player.face(probes[0]["rest"], 0.8)
	await ui.think(e["recliner_3"])
	await ui.think(e["recliner_4"])
	ui.close()
	f["hangar_altar"] = true
	main.log_line("evidence", e["recliner_log"])
	await _song_scene()


## Mira's song, in the air: Lynx hears it too. Then the footsteps, from
## everywhere, and the hide (a stealth timer: the hymn).
func _song_scene() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var s: Dictionary = LINES["song"]
	_fade_loop(_song, -14.0, 3.0)
	main.play("jingle", -12.0, 0.52)
	await get_tree().create_timer(1.2).timeout
	await ui.think(s["think"])
	await ui.think(s["think_2"])
	if main.frames_on:
		_frames(false)
		main.player.shake(0.3)
		await ui.think(s["think_3"])
	else:
		await ui.think(s["think_3b"])
	await ui.think(s["think_4"])
	await ui.think(s["think_air"])
	turn_to(lynx, main.player.global_position, 0.4)
	await main.player.face(lynx.global_position + Vector3(0, 1.6, 0), 0.6)
	await ui.think(s["think_5"])
	await ui.say("Carl", s["carl"])
	await ui.say("Carl", s["carl_2"])
	_steps_on = true
	_steps_db = -26.0
	_fade_loop(_song, -8.0, 6.0)
	await ui.think(s["think_6"])
	await ui.think(s["think_7"])
	await ui.think(s["think_8"])
	await main.player.face(Vector3(22.6, OFF_Y + 1.2, OFF_Z1), 0.8)
	await ui.say("Lynx", s["lynx_2"])
	ui.close()
	f["hangar_song"] = true
	main.log_line("event", s["log"])
	ui.show_toast(s["toast"], 5.0)
	# they come in from the dark, slowly; she runs for the door
	_cong_start(false)
	lynx_state = "walk"
	_move(lynx, [Vector3(12.0, 0, 7.2) if lynx.position.x < 11.0 else lynx.position, Vector3(12.0, 0.0, 6.2), Vector3(20.3, OFF_Y, 6.2), LYNX_WAIT], 4.6, "hold")
	_hiding = true
	_hide_t = 0.0
	f.erase("cinematic")
	main.update_hud()


## Caught in the open: Lynx drags him to the office anyway.
func _seen() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if _hid != "":
		return
	f["cinematic"] = true
	f["hangar_seen"] = true
	main.play("sting", -6.0, 0.9)
	main.player.shake(0.5)
	await ui.think(LINES["hide"]["seen"])
	ui.close()
	ui.show_toast(LINES["hide"]["seen_toast"], 3.0)
	main.log_line("event", LINES["hide"]["seen_log"])
	_hiding = true
	await _hide("office")


## Into the office (the window, the better view) or down behind the drill
## (frames on only; worse view, better exit). Then the whole ceremony.
func _hide(where: String) -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	if not _hiding or _hid != "":
		return
	_hiding = false
	_hid = where
	f["cinematic"] = true
	f["hangar_hid_" + where] = true
	main.update_hud()
	await ui.fade_to(1.0, 0.35)
	p.velocity = Vector3.ZERO
	lynx_state = "hold"
	if where == "office":
		main.play("slam", -2.0, 0.7)
		p.position = HIDE_OFFICE
		p.yaw = deg_to_rad(90.0)
		p.pitch = deg_to_rad(-6.0)
		lynx.position = LYNX_OFFICE
		turn_to(lynx, WINDOW + Vector3(-5, 0, 0))
		_muffle(true)
	else:
		p.position = HIDE_DRILL
		p.crouch = 0.6
		p.yaw = atan2(-(ALTAR.x - HIDE_DRILL.x), -(ALTAR.z - HIDE_DRILL.z))
		p.pitch = deg_to_rad(-4.0)
		lynx.position = LYNX_DRILL + Vector3(0, -0.45, 0)
		turn_to(lynx, ALTAR)
		Anim.crouch(lynx)
	_cong_speed = 1.5
	await ui.fade_to(0.0, 0.5)
	var h: Dictionary = LINES["hide"]
	if where == "office":
		await ui.think(h["office"])
		await ui.think(h["office_2"])
		await ui.think(h["office_3"])
	else:
		await ui.think(h["drill"])
		await ui.think(h["drill_2"])
	ui.close()
	await _ceremony()


func _muffle(on: bool) -> void:
	_steps_db = -40.0 if on else -26.0
	_fade_loop(_song, -20.0 if on else -8.0, 0.4)


# ------------------------------------------------------------------ the ceremony

func _ceremony() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	var h: Dictionary = LINES["hide"]
	var c: Dictionary = LINES["ceremony"]
	var drill := _hid == "drill"
	await ui.think(h["filing_drill"] if drill else h["filing"])
	_cong_release_stair()
	await p.face(Vector3(0, LAND_Y + 1.5, 47.0), 1.4)
	await ui.think(h["filing_2"])
	await p.face(ALTAR + Vector3(0, 0.8, 4.0), 2.0)
	await ui.think(h["filing_3"])
	ui.close()
	var t := 0.0
	while not _cong_seated() and t < 60.0:
		await get_tree().process_frame
		t += get_process_delta_time()
	_cong_seat_all()
	_steps_on = false
	# the camera pulls back: the scale is the point
	await _pull_back(Vector3(-24.0, 15.5, 30.0), Vector3(0, 0, 0), 5.0)
	# the glasses
	if main.frames_on:
		await ui.think(h["buzz_on"])
	else:
		main.play("tap", -8.0, 0.4)
		await ui.think(h["buzz"])
		await ui.think(h["buzz_2"])
		await ui.think(h["buzz_3"])
		_frames(true)
	_vision(0.0, 0.0, 0.0, 0.035)
	await ui.think(h["grain"])
	# the hymn stops; the chant begins; the heads come up
	_fade_loop(_song, -80.0, 1.5)
	_fade_loop(_chant, -6.0, 6.0)
	create_tween().tween_property(self, "_cong_lift", 1.0, 1.2)
	await ui.think(c["heads"])
	await ui.think(c["heads_2"])
	# the three in white, down the stair
	var fwd := _fwd(THRONE_YAW)
	var right := _right(THRONE_YAW)
	var seat_at := ALTAR + fwd * 0.05
	var trio := [[prophet, 0.0], [acolyte, -1.1], [eren, 1.1]]
	for tr: Array in trio:
		var fig: Node3D = tr[0]
		var ox: float = tr[1]
		fig.position = Vector3(ox, LAND_Y, 50.0)
		_show(fig, _it_of(fig), true)
		fig.rotation.y = PI
	await p.face(Vector3(0, LAND_Y + 1.2, 46.0), 1.0)
	await ui.think(c["three"])
	var stop_p := ALTAR + fwd * 3.2
	_move(acolyte, [Vector3(-1.1, LAND_Y, Z1 - 0.4), Vector3(-1.1, 0.0, FOOT_Z - 0.4), Vector3(-1.1, 0.0, 12.0), stop_p - right * 1.1 + fwd * 0.6], 2.2)
	_move(eren, [Vector3(1.1, LAND_Y, Z1 - 0.4), Vector3(1.1, 0.0, FOOT_Z - 0.4), Vector3(1.1, 0.0, 12.0), stop_p + right * 1.1 + fwd * 0.6], 2.2)
	await ui.think(c["s41"])
	await ui.think(c["acolytes"])
	ui.close()
	await _move(prophet, [Vector3(0.0, LAND_Y, Z1 - 0.4), Vector3(0.0, 0.0, FOOT_Z - 0.4), Vector3(0.0, 0.0, 12.0), stop_p + fwd * 1.0], 2.2)
	# Eren steps into the light: the close-up, the first sight of him
	var eh: Node3D = eren.get_meta("head")
	turn_to(eren, Vector3(WINDOW.x, 0, WINDOW.z) if not drill else HIDE_DRILL, 0.8)
	await p.face(eh.global_position, 0.8)
	_zoom(4.5 if not drill else 3.5, 1.2)
	main.play("sting", -14.0, 0.6)
	await ui.think(c["eren"])
	ui.caption(c["eren_cap"], 4.0)
	await ui.think(c["eren_2"])
	ui.close()
	f["hangar_eren"] = true
	f["ev_eren_altar"] = true
	main.log_line("evidence", c["eren_log"])
	_zoom(72.0, 1.0)
	turn_to(eren, eren.global_position + fwd * -2.0, 0.8)
	await ui.think(c["calm"])
	# the fractal begins; the halo; he walks to the throne and sits
	_vision(0.25, 0.25, 0.0, 0.035)
	await ui.think(c["fractal"])
	await ui.say("Carl", c["recursion"])
	halo.visible = true
	await p.face(prophet.global_position + Vector3(0, 1.4, 0), 0.8)
	await ui.think(c["halo"])
	ui.close()
	await _move(prophet, [seat_at + fwd * 1.0, seat_at], 0.8)
	prophet.rotation.y = THRONE_YAW
	_sit_prophet(true)
	_stop_all()
	await ui.think(c["sits"])
	_heartbeat(5)
	await ui.think(c["severed"])
	await ui.think(c["unmask"])
	ui.close()
	mask_mi.visible = false
	halo.visible = false
	await p.face(_ph_head(), 0.6)
	_zoom(5.5 if not drill else 4.0, 0.8)
	await get_tree().create_timer(0.8).timeout
	await ui.think(c["face"])
	ui.close()
	_zoom(72.0, 0.5)
	# the probes: the frame is withheld
	_card(LINES["cards"]["probes"])
	await get_tree().create_timer(1.6).timeout
	main.play("snap", 0.0, 0.42)
	main.play("slam", -3.0, 0.5)
	await get_tree().create_timer(0.5).timeout
	_plugs(true)
	_card_off()
	p.shake(0.4)
	await ui.think(c["probes"])
	# the vision: it swallows the room
	_fade_loop(_chant, -12.0, 4.0)
	await ui.think(c["sinking"])
	_vision(1.0, 0.75, 0.0, 0.035)
	await ui.think(c["dissolve"])
	_vision(1.0, 0.75, 1.0, 0.035)
	await ui.think(c["wall"])
	await ui.think(c["voice_intro"])
	for v: String in c["voice"]:
		main.play("whisper", -12.0, 0.7)
		await ui.say("", "[color=#c9a0ff]" + v + "[/color]")
	ui.close()
	await _vision_rounds()
	await _argument()
	await _sermon()
	await _frames_choice()
	await _mimic()


## Rounds two and three of the vision. Lynx slaps the frames off after round
## two if she trusts him (+4), after round three if not (+6): only then does
## the Eye turn to Carl, with sorrow.
func _vision_rounds() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	var c: Dictionary = LINES["ceremony"]
	await ui.think(c["time"])
	await ui.think(c["memory"])
	await ui.think(c["peace"])
	await ui.think(c["shaking"])
	await ui.say("Lynx", c["lynx_shake"])
	await ui.say("Lynx", c["lynx_shake_2"])
	await ui.think(c["thunder"])
	_lights_phase = "sea"
	lights_mi.visible = true
	create_tween().tween_property(eye_light, "light_energy", 1.4, 3.0)
	await p.face(Vector3(0, 3.0, 0), 1.0)
	await ui.think(c["sea"])
	main.play("jingle", -10.0, 0.6)
	_fade_loop(_song, -12.0, 3.0)
	await ui.think(c["melody"])
	_lights_phase = "wave"
	_lights_k = 0.0
	create_tween().tween_property(self, "_lights_k", 1.0, 4.0)
	await ui.think(c["wave"])
	var early := int(main.trust.get("lynx", 0)) >= 2
	_saw_eye = false
	if not early:
		await ui.say("Lynx", c["lynx_shake_3"])
		_lights_phase = "moon"
		_lights_k = 0.0
		create_tween().tween_property(self, "_lights_k", 1.0, 3.0)
		await p.face(_eye_c, 1.4)
		await ui.think(c["rise"])
		await ui.think(c["moon"])
		_lights_phase = "eye"
		_lights_k = 0.0
		create_tween().tween_property(self, "_lights_k", 1.0, 2.5)
		await ui.think(c["eye"])
		_lights_phase = "stare"
		main.play("pressure", -10.0, 0.8)
		await p.face(_eye_c, 0.6)
		_zoom(40.0, 1.5)
		await ui.think(c["stare"])
		await ui.think(c["sad"])
		_lights_phase = "scan"
		_zoom(72.0, 1.2)
		await ui.think(c["back"])
		await ui.say("Lynx", c["lynx_wake"])
		_saw_eye = true
		f["hangar_saw_eye"] = true
	ui.close()
	# the slap
	main.play("slam", 0.0, 1.6)
	p.shake(0.9)
	ui.glitch(1.0, 0.5)
	_frames(false)
	_vision(0.0, 0.0, 0.0, 0.0)
	_lights_phase = ""
	lights_mi.visible = false
	eye_light.light_energy = 0.0
	_fade_loop(_song, -80.0, 0.3)
	main.add_connection(4.0 if early else 6.0, c["why_early"] if early else c["why_late"])
	await ui.think(c["slap"])
	await ui.think(c["snap_to"])
	await p.face(lynx.global_position + Vector3(0, 1.6, 0), 0.6)
	await ui.say("Carl", c["carl_what"])
	await ui.say("Lynx", c["lynx_singing"])
	ui.close()
	f["hangar_vision"] = true
	main.log_line("scene", c["log_sad"] if _saw_eye else c["log"])
	main.update_hud()


## Chapter 14 opens: "Are you part of this?"
func _argument() -> void:
	var ui = main.ui
	var a: Dictionary = LINES["argument"]
	await ui.think(a["think"])
	await ui.say("Carl", a["carl"])
	await ui.say("Lynx", a["lynx"])
	await ui.think(a["think_2"])
	await ui.say("Lynx", a["lynx_2"])
	await ui.think(a["think_3"])
	var pick: int = await ui.choose(a["choice"])
	if pick == 0:
		await ui.say("Carl", a["carl_scared"])
		main.log_line("choice", a["log_scared"])
	else:
		await ui.say("Carl", a["carl_code"])
		await ui.say("Carl", a["carl_code_2"])
		main.add_stance("investigator")
		main.log_line("choice", a["log_code"])
	await ui.think(a["think_4_drill"] if _hid == "drill" else a["think_4"])
	await ui.think(a["questions"])
	await ui.think(a["sorrow"] if _saw_eye else a["sorrow_missed"])
	await ui.say("Carl", a["carl_how_long"])
	await ui.say("Lynx", a["lynx_five"])
	await main.player.face(_ph_head(), 1.0)
	await ui.think(a["nothing"])
	await ui.think(a["nothing_2"])
	ui.close()


## The sermon with the frames off: the call and response, the three
## devotees, 1256's eyes behind the content setting with the sound left in.
func _sermon() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	var s: Dictionary = LINES["sermon"]
	var fwd := _fwd(THRONE_YAW)
	var right := _right(THRONE_YAW)
	_fade_loop(_chant, -80.0, 0.4)
	await ui.think(s["plugs"])
	_plugs(false)
	for b in blood_streaks:
		(b as Node3D).visible = true
	await ui.think(s["blood"])
	await ui.think(s["voice"])
	var pairs := [["p1", "c1"], ["p2", "c2"], ["p3", "c3"]]
	for pr: Array in pairs:
		await ui.say("The Prophet", s[pr[0]])
		main.play("murmur", -6.0, 0.7)
		await ui.say("The congregation", s[pr[1]])
	for k in ["p4", "p5", "p6", "p7", "p8", "p9", "p10", "p11", "p12"]:
		await ui.say("The Prophet", s[k])
	_chant.play()
	_chant.volume_db = -80.0
	_fade_loop(_chant, -6.0, 2.0)
	await ui.say("The congregation", s["c_we"])
	main.learn("we")
	main.play("pressure", -6.0, 0.6)
	await ui.think(s["tone"])
	_fade_loop(_chant, -80.0, 0.3)
	# he stands for the rite
	_sit_prophet(false)
	prophet.position = ALTAR + fwd * 0.9
	prophet.rotation.y = THRONE_YAW
	for k in ["p13", "p14", "p15", "p16"]:
		await ui.say("The Prophet", s[k])
	ui.close()
	# three hooded figures from the far corner
	_fade_loop(_chant, -14.0, 3.0)
	_chant.pitch_scale = 0.8
	var stand_at := [ALTAR + fwd * 2.4 - right * 0.95, ALTAR + fwd * 2.6, ALTAR + fwd * 2.4 + right * 0.95]
	for k in 3:
		var sj: Dictionary = subjects[k]
		_show(sj["fig"], sj["it"], true)
	await p.face(CORNER + Vector3(0, 1.4, 0), 1.0)
	await ui.think(s["three"])
	ui.close()
	for k in 3:
		var sj2: Dictionary = subjects[k]
		var fg: Node3D = sj2["fig"]
		var dst: Vector3 = stand_at[k]
		if k < 2:
			_move(fg, [Vector3(-14.0, 0, -8.0 + k * 1.2), dst], 2.4)
		else:
			await _move(fg, [Vector3(-14.0, 0, -5.6), dst], 2.4)
	for k in 3:
		var fg2: Node3D = subjects[k]["fig"]
		turn_to(fg2, prophet.global_position)
		(fg2.get_meta("body") as Node3D).rotation.x = 0.35
	_fade_loop(_chant, -80.0, 0.5)
	await p.face(prophet.global_position + Vector3(0, 1.2, 0), 0.8)
	await ui.think(s["cube"])
	cube_lid.rotation.x = -1.3
	cube_lid.position += Vector3(0, 0.08, 0.12)
	await ui.think(s["blade"])
	blade.visible = true
	for k in ["p17", "p18", "p19", "p20"]:
		await ui.say("The Prophet", s[k])
	var w: Node3D = subjects[0]["fig"]
	(w.get_meta("body") as Node3D).rotation.x = 0.0
	(w.get_meta("head") as Node3D).rotation.x = -0.55
	await ui.think(s["s1256"])
	await ui.say("The Prophet", s["p21"])
	await ui.say("1256", s["s_do"])
	await ui.think(s["s_do_think"])
	await ui.say("The Prophet", s["p22"])
	await ui.say("1256", s["s_do"])
	await ui.say("The Prophet", s["p23"])
	await ui.think(s["p23_think"])
	await ui.say("The Prophet", s["p24"])
	await ui.say("1256", s["s_sight"])
	await ui.think(s["s_sight_think"])
	ui.close()
	# the removal: black, the caption, the sound
	_card(LINES["cards"]["removal"])
	main.play("sting", -2.0, 1.3)
	await get_tree().create_timer(0.8).timeout
	await ui.think(s["removal_2"])
	main.play("whisper", 0.0, 1.5)
	main.play("sting", -6.0, 1.6)
	await ui.think(s["removal_3"])
	main.play("murmur", 0.0, 1.0)
	main.play("static", -6.0, 1.0)
	await ui.say("The Prophet", s["p25"])
	await ui.think(s["removal_4"])
	main.play("sting", -4.0, 1.4)
	main.play("static", -2.0, 1.2)
	main.play("murmur", 0.0, 1.2)
	ui.close()
	(w.get_meta("body") as Node3D).rotation.x = 0.6
	(w.get_meta("head") as Node3D).rotation.x = 0.5
	floor_quad(Vector2(1.4, 1.4), w.global_position + Vector3(0, 0.016, 0) - fwd * 0.4, 0.4, decal_mat(Tex.blood(12), Color(0.4, 0.02, 0.02, 0.9), 0.3), dyn)
	blade.visible = false
	await get_tree().create_timer(0.4).timeout
	_card_off()
	await ui.think(s["cheers"])
	await p.face(w.global_position + Vector3(0, 1.0, 0), 0.6)
	await ui.think(s["slump"])
	await ui.say("1256", s["s_see"])
	await ui.say("1256", s["s_see_2"])
	_move(eren, [w.global_position + fwd * -0.1 + right * 0.6], 1.0)
	await ui.think(s["cloth"])
	cloth.visible = true
	await ui.think(s["cloth_2"])
	main.log_line("evidence", s["cloth_log"])
	await ui.think(s["turn"])
	turn_to(prophet, (subjects[1]["fig"] as Node3D).global_position, 0.6)
	await ui.say("The Prophet", s["p26"])
	ui.close()
	f["hangar_sermon"] = true
	main.log_line("scene", s["log"])


## Carl's choice: the frames back on (+2; the laughter; 1395 has his face,
## a two-frame flicker to a stranger) or kept off.
func _frames_choice() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	var c: Dictionary = LINES["choice"]
	await ui.think(c["prompt"])
	var pick: int = await ui.choose(c["options"])
	ui.close()
	if pick == 0:
		await ui.think(c["off"])
		f["hangar_frames_kept_off"] = true
		main.log_line("choice", c["off_log"])
		return
	_frames(true)
	main.add_connection(2.0, c["why"])
	await ui.think(c["on"])
	main.play("whisper", -4.0, 0.8)
	main.play("static", -12.0, 1.3)
	await ui.think(c["on_2"])
	await ui.think(c["on_3"])
	await ui.say("Lynx", c["lynx_leave"])
	await ui.think(c["on_4"])
	ui.close()
	var sj: Dictionary = subjects[2]
	var fg: Node3D = sj["fig"]
	(fg.get_meta("body") as Node3D).rotation.x = 0.0
	(sj["hood"] as Node3D).visible = false
	(fg.get_meta("head") as Node3D).rotation.x = -0.12
	turn_to(fg, main.player.global_position, 0.3)
	var hm: MeshInstance3D = sj["head_mi"]
	hm.material_override = faces["carl"]
	await p.face((fg.get_meta("head") as Node3D).global_position, 0.6)
	_zoom(3.6 if _hid != "drill" else 2.8, 0.8)
	await get_tree().create_timer(0.9).timeout
	await ui.think(c["face"])
	# glitching between expressions, then two frames of a stranger
	for k in 6:
		ui.glitch(0.6, 0.15)
		hm.material_override = faces["carl"] if k % 2 == 0 else faces["1395"]
		await get_tree().process_frame
		await get_tree().process_frame
		hm.material_override = faces["carl"]
		await get_tree().create_timer(0.25).timeout
	hm.material_override = faces["stranger"]
	await get_tree().process_frame
	await get_tree().process_frame
	hm.material_override = faces["carl"]
	await get_tree().create_timer(0.3).timeout
	hm.material_override = faces["stranger"]
	main.play("whisper", -2.0, 1.1)
	ui.show_toast(c["face_toast"], 3.5)
	await ui.think(c["face_2"])
	p.shake(0.6)
	_zoom(72.0, 0.4)
	await ui.say("Carl", c["carl_me"])
	await ui.say("Lynx", c["lynx_sense"])
	ui.close()
	f["hangar_1395_face"] = true
	main.log_line("evidence", c["on_log"])


## "And now, the Mimic has returned." Every figure turns, at once; they do
## not chase. The camera pulls back; then the walk.
func _mimic() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	var m: Dictionary = LINES["mimic"]
	var drill := _hid == "drill"
	var me: Vector3 = p.global_position + Vector3(0, 1.2, 0)
	turn_to(prophet, me, 0.15)
	Anim.look(prophet, me, 1.0, 1.0)
	main.play("sting", -2.0, 0.7)
	await p.face(_ph_head(), 0.3)
	await ui.think(m["think_drill"] if drill else m["think_window"])
	await ui.say("The Prophet", m["line"])
	ui.close()
	_cong_face(me, true)
	main.play("murmur", 0.0, 0.5)
	await get_tree().create_timer(0.6).timeout
	await ui.think(m["turn"])
	_chant.play()
	_chant.pitch_scale = 0.7
	_chant.volume_db = -8.0
	await ui.say("The congregation", m["chant_1"])
	await ui.say("The congregation", m["chant_2"])
	await ui.say("The congregation", m["chant_3"])
	ui.close()
	await _pull_back(Vector3(-6.0, 16.5, -24.0), Vector3(8.0, 0.0, 2.0), 4.0)
	await ui.think(m["back_drill"] if drill else m["back"])
	_open_office()
	_open_service()
	await ui.say("Lynx", m["lynx_move"])
	await ui.think(m["stare"])
	ui.close()
	ui.show_toast(m["toast"], 4.0)
	f["hangar_mimic"] = true
	main.log_line("scene", m["log"])
	# the walk: the eyeless out along the way up, the dark, the chant
	_escape = true
	_cong_track = true
	for e: Dictionary in eyeless:
		_show(e["fig"], e["it"], true)
	if stair_lamp:
		stair_lamp.light_energy = 0.25
	if land_lamp:
		land_lamp.light_energy = 0.3
	spot.light_energy = 3.0
	p.crouch = 0.0
	_trail.clear()
	lynx.position.y = maxf(lynx.position.y, 0.0)
	_stand(lynx)
	lynx_state = "follow"
	_eye_layer()
	f.erase("cinematic")
	main.update_hud()


# ------------------------------------------------------------------ the way out

func _open_office() -> void:
	create_tween().tween_property(office_door, "rotation:y", 1.9, 0.5)
	office_door_body.collision_layer = 0
	office_door_body.collision_mask = 0
	_muffle(false)


func _open_service() -> void:
	create_tween().tween_property(service_door, "position:x", SVC_X0 - 3.0, 1.2)
	service_body.collision_layer = 0
	service_body.collision_mask = 0
	for n in main._all_with_meta(self, "id"):
		if str(n.get_meta("id")) == "service_ramp":
			set_active(n, true)


func _touched(e: Dictionary) -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	_touch_cd = 4.0
	f["hangar_touched"] = int(f.get("hangar_touched", 0)) + 1
	main.play("whisper", -2.0, 0.6)
	p.shake(0.5)
	ui.glitch(0.8, 0.5)
	main.add_connection(5.0, LINES["escape"]["touched_why"])
	ui.show_toast(LINES["escape"]["touched_toast"], 2.5)
	# back a stretch, and they go back to where they stood
	var pp: Vector3 = p.global_position
	if str(e["route"]) == "service":
		p.position = Vector3(-17.0, 0.1, 44.2)
	elif pp.z > 50.0:
		p.position = Vector3(0.0, LAND_Y + 0.1, 47.6)
	else:
		p.position = Vector3(0.0, 0.1, FOOT_Z - 2.5)
	p.velocity = Vector3.ZERO
	p.yaw = PI
	for x: Dictionary in eyeless:
		var fg: Node3D = x["fig"]
		fg.position = x["home"]
		fg.rotation.y = float(x["yaw"])
	_trail.clear()
	lynx.position = p.position + Vector3(1.2, -0.1, -1.0)
	if not f.has("cinematic"):
		await ui.think(LINES["escape"]["touched"])
		ui.close()


func _open_exit() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if _door_open:
		return
	_door_open = true
	f["cinematic"] = true
	main.play("door", -4.0, 0.7)
	exit_body.collision_layer = 0
	exit_body.collision_mask = 0
	exit_brick.visible = false
	create_tween().tween_property(exit_door, "rotation:y", -1.8, 0.8)
	await ui.think(LINES["escape"]["door_think"])
	await ui.think(LINES["escape"]["blur"])
	await ui.think(LINES["escape"]["stupid"])
	ui.close()
	await _go_outside()


func _go_outside() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	await ui.fade_to(1.0, 0.8)
	_escape = false
	_outside = true
	f["hangar_outside"] = true
	_stop_all()
	_wind.play()
	_wind.volume_db = -14.0
	hud_light.light_energy = 0.0
	_dusk(main.env, main.sun)
	p.position = OUT + Vector3(0, 0.1, -0.8)
	p.velocity = Vector3.ZERO
	p.yaw = deg_to_rad(-12.0)
	p.pitch = deg_to_rad(4.0)
	p.crouch = 0.0
	lynx.position = OUT + Vector3(1.3, 0.0, -1.6)
	lynx.rotation.y = 0.0
	_trail.clear()
	lynx_state = "follow"
	await ui.fade_to(0.0, 1.0)
	await ui.think(LINES["outside"]["think"])
	await ui.think(LINES["outside"]["think_2"] if main.frames_on else LINES["outside"]["think_2b"])
	await ui.say("Lynx", LINES["lynx"]["outside"])
	ui.close()
	f.erase("cinematic")
	main.update_hud()


## Dusk over the desert: the sun just down in the west, sand and violet,
## the moon coming up in the east.
func _dusk(env: Environment, sun: DirectionalLight3D) -> void:
	env.background_mode = Environment.BG_SKY
	var sky := Sky.new()
	var psm := ProceduralSkyMaterial.new()
	psm.sky_top_color = Color(0.08, 0.06, 0.16)
	psm.sky_horizon_color = Color(0.62, 0.32, 0.26)
	psm.ground_horizon_color = Color(0.4, 0.22, 0.18)
	psm.ground_bottom_color = Color(0.08, 0.05, 0.04)
	psm.sky_curve = 0.12
	sky.sky_material = psm
	env.sky = sky
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.5, 0.42, 0.5)
	env.ambient_light_energy = 0.55
	env.fog_light_color = Color(0.32, 0.2, 0.22)
	env.fog_density = 0.0012
	env.fog_sky_affect = 0.3
	sun.light_color = Color(1.0, 0.55, 0.4)
	sun.light_energy = 0.45
	sun.shadow_enabled = true
	sun.rotation = Vector3(deg_to_rad(-7.0), deg_to_rad(-80.0), 0)


## Into the car: "Fuck my car, just drive." Two panels for the drive, then
## home (visit 3 starts in the garage).
func _drive() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var o: Dictionary = LINES["outside"]
	if _ended:
		return
	_ended = true
	f["cinematic"] = true
	main.play("door", -6.0, 1.0)
	await ui.fade_to(1.0, 0.5)
	main.play("car", -8.0, 0.9)
	_fade_loop(_wind, -26.0, 0.5)
	await ui.think(o["hop"])
	await ui.say("Lynx", o["lynx_car"])
	await ui.think(o["lynx_think"])
	ui.close()
	main.play("engine", -10.0, 1.0)
	var trs := panel_box.get_children()
	(trs[0] as TextureRect).texture = _panel_road()
	(trs[1] as TextureRect).texture = _panel_city()
	panel_box.visible = true
	card_text.text = ""
	card_rect.visible = true
	await ui.fade_to(0.0, 0.6)
	ui.caption(LINES["cards"]["drive_cap"], 3.0)
	await ui.think(o["drive"])
	await ui.think(o["drive_2"])
	ui.close()
	main.log_line("event", o["log"])
	main.log_line("time", o["time"])
	f["hangar_done"] = true
	f.erase("cinematic")
	main.update_hud()
	if not main._selftest:
		main.load_level("Home")
	else:
		panel_box.visible = false
		card_rect.visible = false


# ------------------------------------------------------------------ the frame loop

func tick(delta: float) -> void:
	if not main or not main.player:
		return
	var p = main.player
	var pp: Vector3 = p.global_position
	var f: Dictionary = main.flags
	if _eye_vis != main.frames_on:
		_eye_vis = main.frames_on
		_eye_layer()
	if _shot:
		_tick_lynx(delta, pp)
		_tick_cong(delta, pp)
		_tick_lights(delta)
		if _vision_on:
			_vision_t += delta
			vision_mat.set_shader_parameter("tm", _vision_t)
		return
	if not f.has("hangar_vast") and not _busy and not f.has("cinematic") and pp.z < Z1 - 0.6 and pp.y < LAND_Y + 1.5 and pp.y > -1.0 and not _outside:
		_vast()
	_tick_lynx(delta, pp)
	_tick_cong(delta, pp)
	_tick_lights(delta)
	_tick_steps(delta)
	if _vision_on:
		_vision_t += delta
		vision_mat.set_shader_parameter("tm", _vision_t)
		var cam: Camera3D = get_viewport().get_camera_3d()
		if cam:
			var sz := get_viewport().get_visible_rect().size
			var target := ALTAR + Vector3(0, 1.2, 0)
			if not cam.is_position_behind(target):
				vision_mat.set_shader_parameter("center", cam.unproject_position(target) / sz)
	if halo and halo.visible:
		halo.scale = Vector3.ONE * (1.0 + sin(_t * 7.0) * 0.06)
	if _hiding:
		_hide_t += delta
		if _hide_t > 45.0 or pp.z > FOOT_Z + 3.0 or _cong_near(pp, 2.4):
			_hiding = false
			_seen()
	if _escape:
		_tick_escape(delta, pp)


func _tick_lynx(delta: float, pp: Vector3) -> void:
	if not lynx:
		return
	match lynx_state:
		"follow":
			if _trail.is_empty() or (_trail[_trail.size() - 1] as Vector3).distance_to(pp) > 0.5:
				_trail.append(pp)
				if _trail.size() > 40:
					_trail.pop_front()
			var target: Vector3 = _trail[maxi(0, _trail.size() - 5)] if _trail.size() > 0 else lynx.position
			var d := target - lynx.position
			var dist := d.length()
			if dist > 0.4 and pp.distance_to(lynx.position) > 1.4:
				var speed := clampf(dist * 2.2, 1.2, 5.0)
				lynx.position += d.normalized() * minf(speed * delta, dist)
				var fl := Vector2(d.x, d.z)
				if fl.length() > 0.05:
					lynx.rotation.y = lerp_angle(lynx.rotation.y, atan2(-d.x, -d.z), minf(1.0, delta * 8.0))
				Anim.walk(lynx, _t, speed / 2.4, 0.0, 1.0)
			else:
				Anim.idle(lynx, _t, 1.0)
				Anim.look(lynx, pp + Vector3(0, 1.6, 0), 0.6, 0.05)
		"hold":
			Anim.look(lynx, pp + Vector3(0, 1.6, 0), 0.7, 0.04)


## The hundred: waiting in the dark, walking in (slowly, until Carl hides),
## seated; turning their heads to Carl in unison, then tracking him.
func _tick_cong(delta: float, pp: Vector3) -> void:
	if not _cong_live:
		return
	for c: Dictionary in cong:
		var st: String = c["state"]
		if st == "wait":
			c["delay"] = float(c["delay"]) - delta
			if float(c["delay"]) <= 0.0 and not (bool(c["stair"]) and _cong_speed < 1.0):
				c["state"] = "walk"
			continue
		if st == "walk":
			var path: Array = c["path"]
			var i: int = c["pi"]
			var pos: Vector3 = c["pos"]
			var tgt: Vector3 = path[i]
			var d := tgt - pos
			var dist := d.length()
			var step := _cong_speed * (0.85 + 0.15 * sin(float(c["ph"]))) * delta
			if dist <= step:
				pos = tgt
				i += 1
				if i >= path.size():
					c["state"] = "sit"
					c["yaw"] = float(c["seat_yaw"])
				c["pi"] = i
			else:
				pos += d / dist * step
				if Vector2(d.x, d.z).length() > 0.01:
					c["yaw"] = lerp_angle(float(c["yaw"]), atan2(-d.x, -d.z), minf(1.0, delta * 4.0))
			c["pos"] = pos
		elif _cong_track:
			var dd := pp - (c["pos"] as Vector3)
			c["yaw"] = lerp_angle(float(c["yaw"]), atan2(-dd.x, -dd.z), minf(1.0, delta * 1.2))
		elif float(c["want"]) != 0.0:
			c["yaw"] = lerp_angle(float(c["yaw"]), float(c["want"]), minf(1.0, delta * 9.0))
	_cong_write()


func _cong_write() -> void:
	for c: Dictionary in cong:
		var t: int = c["t"]
		var k: int = c["idx"]
		var st: String = c["state"]
		var s: float = c["s"]
		if st == "wait":
			(mm_stand[t] as MultiMesh).set_instance_transform(k, _hidden_xf())
			(mm_sit[t] as MultiMesh).set_instance_transform(k, _hidden_xf())
			continue
		var bas := Basis(Vector3.UP, float(c["yaw"])).scaled(Vector3.ONE * s)
		var pos: Vector3 = c["pos"]
		if st == "walk":
			var bob := absf(sin(_t * 5.0 + float(c["ph"]))) * 0.03
			(mm_stand[t] as MultiMesh).set_instance_transform(k, Transform3D(bas, pos + Vector3(0, bob, 0)))
			(mm_sit[t] as MultiMesh).set_instance_transform(k, _hidden_xf())
		else:
			var lift := Basis(Vector3.RIGHT, 0.08 * _cong_lift) if t < 2 else Basis()
			(mm_sit[t] as MultiMesh).set_instance_transform(k, Transform3D(bas * lift, pos))
			(mm_stand[t] as MultiMesh).set_instance_transform(k, _hidden_xf())


## The song starts them: the ones in the dark start walking in at once,
## slowly; the ones on the stair wait for the hide.
func _cong_start(fast: bool) -> void:
	_cong_live = true
	_cong_speed = 1.5 if fast else 0.45
	var n := 0
	for c: Dictionary in cong:
		if bool(c["stair"]):
			c["delay"] = 9999.0
		else:
			c["delay"] = rng.randf_range(0.0, 6.0)
		n += 1


func _cong_release_stair() -> void:
	var k := 0
	for c: Dictionary in cong:
		if bool(c["stair"]) and c["state"] == "wait":
			c["delay"] = 0.5 + k * 0.45
			k += 1


func _cong_seated() -> bool:
	for c: Dictionary in cong:
		if c["state"] != "sit":
			return false
	return true


func _cong_seat_all() -> void:
	_cong_live = true
	for c: Dictionary in cong:
		c["state"] = "sit"
		c["pos"] = c["seat"]
		c["yaw"] = float(c["seat_yaw"])
	_cong_write()
	for it in cong_its:
		(it as CollisionObject3D).collision_layer = 2


func _cong_near(pp: Vector3, r: float) -> bool:
	for c: Dictionary in cong:
		if c["state"] == "walk" and (c["pos"] as Vector3).distance_to(pp) < r:
			return true
	return false


## Every one of them, at once, to look at a point.
func _cong_face(point: Vector3, snap: bool) -> void:
	for c: Dictionary in cong:
		var d := point - (c["pos"] as Vector3)
		c["want"] = atan2(-d.x, -d.z)
		if snap:
			c["yaw"] = lerp_angle(float(c["yaw"]), float(c["want"]), 0.5)
	_cong_write()


## The sea of lights over their heads; the wave; the moon; the Eye, drawn
## sad (the brow raised at its inner end, the gaze low, a tear), turning
## over the crowd, then to Carl.
func _tick_lights(delta: float) -> void:
	if _lights_phase == "" or not lights_mi.visible:
		return
	var win := WINDOW if _hid != "drill" else HIDE_DRILL + Vector3(0, 1.0, 0)
	var to_win := win - _eye_c
	var yaw_w := atan2(-to_win.x, -to_win.z)
	match _lights_phase:
		"eye":
			_eye_yaw += delta * 0.5
		"stare":
			_eye_yaw = lerp_angle(_eye_yaw, yaw_w, minf(1.0, delta * 3.0))
		"scan":
			_eye_yaw += delta * 0.6
	var dirv := Vector3(-sin(_eye_yaw), -0.22, -cos(_eye_yaw)).normalized()
	var ex := Vector3.UP.cross(dirv).normalized()
	var ey := dirv.cross(ex).normalized()
	for i in N_CONG:
		var c: Dictionary = cong[i]
		var seat: Vector3 = c["seat"]
		var ang := atan2(seat.x, seat.z)
		var amp := 0.35
		if _lights_phase == "wave":
			amp = lerpf(0.35, 1.5, _lights_k)
		var crest := sin(_t * 1.6 + ang * 3.0 + seat.length() * 0.4)
		var sea := seat + Vector3(0, 2.5 + amp * crest + (0.6 * maxf(0.0, crest) * _lights_k if _lights_phase == "wave" else 0.0), 0)
		var p := sea
		var disc := _eye_c + (ex * cos(i * 2.39996) + ey * sin(i * 2.39996)) * (sqrt((i + 0.5) / N_CONG) * 2.1)
		if _lights_phase == "moon":
			p = sea.lerp(disc, smoothstep(0.0, 1.0, _lights_k))
		elif _lights_phase in ["eye", "stare", "scan"]:
			var e2 := _eye_point(i)
			var ep := _eye_c + ex * e2.x + ey * e2.y
			p = disc.lerp(ep, smoothstep(0.0, 1.0, _lights_k)) if _lights_phase == "eye" else ep
		lights_mm.set_instance_transform(i, Transform3D(Basis(), p))
	eye_light.position = _eye_c if _lights_phase in ["moon", "eye", "stare", "scan"] else Vector3(0, 4.0, 0)


## Point i of the sad Eye, in its own plane (metres).
func _eye_point(i: int) -> Vector2:
	var W := 3.8
	var H := 1.7
	if i < 28:
		var s := PI * i / 27.0
		return Vector2(-W * cos(s), H * 0.78 * sin(s) - 0.22 * H * pow(cos(s), 2.0))
	if i < 50:
		var s2 := PI * (i - 28 + 0.5) / 22.0
		return Vector2(-W * cos(s2), -H * 0.55 * sin(s2) - 0.22 * H * pow(cos(s2), 2.0))
	if i < 70:
		var a := TAU * (i - 50) / 20.0
		return Vector2(cos(a) * 0.62 * H, -0.32 * H + sin(a) * 0.62 * H * 0.9)
	if i < 80:
		var a2 := TAU * (i - 70) / 10.0
		return Vector2(cos(a2) * 0.2 * H, -0.36 * H + sin(a2) * 0.2 * H)
	if i < 94:
		var t := (i - 80) / 13.0
		var x := lerpf(-0.95 * W, 0.95 * W, t)
		var y := 1.5 * H - 0.55 * H * t + 0.25 * H * sin(t * PI) - (0.35 * H if t > 0.8 else 0.0) * (t - 0.8) * 5.0
		return Vector2(x, y)
	var k := i - 94
	var fall := fmod(_t * 0.6 + k * 0.17, 1.0)
	return Vector2(0.72 * W + sin(k) * 0.05, -0.55 * H - 0.25 - fall * 2.4)


func _tick_steps(delta: float) -> void:
	if not _steps_on:
		return
	for s: Array in steps3d:
		s[1] = float(s[1]) - delta
		if float(s[1]) <= 0.0:
			var ap: AudioStreamPlayer3D = s[0]
			ap.volume_db = _steps_db + rng.randf_range(-4.0, 2.0)
			ap.pitch_scale = rng.randf_range(0.5, 0.8)
			ap.play()
			s[1] = rng.randf_range(0.18, 0.55)


## The walk out: the hundred stare; the eyeless turn and close at walking
## speed with the frames on and are statues in the dark with them off; the
## eye-layer door opens after a second of the frames at the top.
func _tick_escape(delta: float, pp: Vector3) -> void:
	var f: Dictionary = main.flags
	_touch_cd = maxf(0.0, _touch_cd - delta)
	hud_light.position = pp + Vector3(0, 1.8, 0)
	hud_light.light_energy = 0.7 if main.frames_on else 0.0
	_caption_t -= delta
	if _caption_t <= 0.0 and not f.has("cinematic"):
		_caption_t = 9.0
		main.ui.caption(LINES["escape"]["chant"], 3.0)
	if not _dark_told and pp.z > FOOT_Z - 1.0 and pp.x > -4.0 and pp.x < 4.0:
		_dark_told = true
		main.ui.show_toast(LINES["escape"]["dark_toast"], 5.0)
	if f.has("cinematic"):
		return
	for e: Dictionary in eyeless:
		var fg: Node3D = e["fig"]
		var d: Vector3 = pp - fg.global_position
		var dist := d.length()
		if main.frames_on and dist < 11.0 and absf(d.y) < 3.0:
			fg.rotation.y = lerp_angle(fg.rotation.y, atan2(-d.x, -d.z), minf(1.0, delta * 2.5))
			Anim.look(fg, pp + Vector3(0, 1.6, 0), 1.0, 0.08)
			var flat := Vector3(d.x, 0, d.z)
			if flat.length() > 0.7 and fg.global_position.distance_to(e["home"]) < 9.0:
				var np := fg.position + flat.normalized() * minf(1.5 * delta, flat.length())
				np.y = _ground_y(np, e["it"])
				fg.position = np
				Anim.walk(fg, _t, 0.9, float(fg.get_instance_id() % 7), 0.8)
			if dist < 0.95 and _touch_cd <= 0.0:
				_touched(e)
				return
		else:
			Anim.look(fg, pp, 0.0, 0.02)
	# the door at the top: a second of the frames, and it opens
	if not _door_open and pp.distance_to(DOOR) < 4.2:
		if main.frames_on:
			_door_t += delta
			if _door_t >= 1.0:
				_open_exit()
		else:
			_door_t = 0.0


func _ground_y(p: Vector3, it: Object = null) -> float:
	var q := PhysicsRayQueryParameters3D.create(p + Vector3(0, 1.2, 0), p + Vector3(0, -2.5, 0), 1)
	if it:
		var ex: Array[RID] = [(it as CollisionObject3D).get_rid()]
		q.exclude = ex
	var hit := get_world_3d().direct_space_state.intersect_ray(q)
	if hit.is_empty():
		return p.y
	return (hit["position"] as Vector3).y


# ------------------------------------------------------------------ beat helpers

func _frames(on: bool) -> void:
	main.frames_on = on
	main.ui.set_frames(1.0 if on else 0.0, main.connection)
	set_glyph_visibility(on, main.connection)
	main.play("on" if on else "off", -6.0)
	_eye_vis = on
	_eye_layer()
	main.update_hud()


## The eye layer: chevrons and the hide cue with the frames on; the exit is
## a door with them on and brick with them off.
func _eye_layer() -> void:
	var on: bool = main.frames_on if main else false
	var f: Dictionary = main.flags if main else {}
	for n in eye_layer:
		var nd := n as Node3D
		if nd.has_meta("escape"):
			nd.visible = on and _escape
		elif nd == chev_office:
			nd.visible = on and _hiding
		elif nd == chev_drill or nd.has_meta("hide_cue"):
			nd.visible = on and _hiding
		else:
			nd.visible = on
	if exit_door and not _door_open:
		exit_door.visible = on or not f.has("hangar_mimic")
		exit_brick.visible = not exit_door.visible


func _vision(amount: float, desat: float, flake: float, grain: float) -> void:
	_vision_on = amount > 0.0 or grain > 0.0
	vision_rect.visible = _vision_on
	var tw := create_tween().set_parallel(true)
	tw.tween_method(func(v: float): vision_mat.set_shader_parameter("amount", v), _sp("amount"), amount, 2.5)
	tw.tween_method(func(v: float): vision_mat.set_shader_parameter("desat", v), _sp("desat"), desat, 2.5)
	vision_mat.set_shader_parameter("flake", flake)
	vision_mat.set_shader_parameter("grain", grain)


func _sp(n: String) -> float:
	var v: Variant = vision_mat.get_shader_parameter(n)
	return float(v) if v != null else 0.0


func _card(text: String) -> void:
	card_text.text = "[center]" + text + "[/center]"
	panel_box.visible = false
	card_rect.visible = true


func _card_off() -> void:
	card_rect.visible = false


func _zoom(fov: float, t: float) -> void:
	create_tween().tween_property(main.player.cam, "fov", fov, t).set_trans(Tween.TRANS_SINE)


## A second camera that pulls back and up to show the hundred, then hands
## the view back to Carl's eyes.
func _pull_back(to: Vector3, look: Vector3, secs: float) -> void:
	var cam: Camera3D = main.player.cam
	pull_cam = Camera3D.new()
	pull_cam.fov = 60.0
	pull_cam.far = 1600.0
	pull_cam.cull_mask = cam.cull_mask
	dyn.add_child(pull_cam)
	pull_cam.global_transform = cam.global_transform
	pull_cam.current = true
	var start := cam.global_position
	var tw := create_tween()
	tw.tween_method(func(k: float):
		var e := smoothstep(0.0, 1.0, k)
		pull_cam.global_position = start.lerp(to, e)
		var fwd_pt := (start + (-cam.global_transform.basis.z) * 10.0).lerp(look, minf(1.0, e * 1.6))
		if pull_cam.global_position.distance_to(fwd_pt) > 0.1:
			pull_cam.look_at(fwd_pt, Vector3.UP), 0.0, 1.0, secs)
	await tw.finished
	await get_tree().create_timer(1.2).timeout
	cam.current = true
	pull_cam.queue_free()
	pull_cam = null


func _fade_loop(ap: Node, db: float, t: float) -> void:
	if ap == null or not is_instance_valid(ap):
		return
	if not ap.playing:
		ap.volume_db = -80.0
		ap.play()
	create_tween().tween_property(ap, "volume_db", db, t)


## The chant severed: every loop off at once; true silence.
func _stop_all() -> void:
	for k in main.amb:
		var ap = main.amb[k]
		if is_instance_valid(ap):
			ap.stop()
	_steps_on = false


func _heartbeat(n: int) -> void:
	for k in n:
		if not is_inside_tree():
			return
		main.play("tap", -4.0, 0.32)
		await get_tree().create_timer(0.22).timeout
		main.play("tap", -8.0, 0.3)
		await get_tree().create_timer(0.62).timeout


func _it_of(fig: Node3D) -> CollisionObject3D:
	for w: Array in whites:
		if w[0] == fig:
			return w[1]
	return null


func _ph_head() -> Vector3:
	return (prophet.get_meta("head") as Node3D).global_position


func _sit_prophet(on: bool) -> void:
	if on:
		prophet.position = ALTAR + _fwd(THRONE_YAW) * 0.05 + Vector3(0, -0.34, 0)
		Anim.sit(prophet, 0.12)
		robe_skirt.visible = false
	else:
		_stand(prophet)
		prophet.position.y = 0.0
		robe_skirt.visible = true


func _stand(fig: Node3D) -> void:
	for l in fig.get_meta("legs"):
		(l as Node3D).rotation.x = 0.0
	for k in fig.get_meta("knees"):
		(k as Node3D).rotation.x = 0.0
	(fig.get_meta("body") as Node3D).rotation.x = 0.0
	var hd: Node3D = fig.get_meta("head")
	hd.position.z = 0.0
	hd.rotation.x = 0.0


## The probes into his eyes (or out of them, back to the headrest).
func _plugs(on: bool) -> void:
	var fwd := _fwd(THRONE_YAW)
	var right := _right(THRONE_YAW)
	var hd := _ph_head()
	for pr: Dictionary in probes:
		var s: float = pr["side"]
		if on:
			_probe_to(pr, hd + right * (s * 0.045) + fwd * 0.12 + Vector3(0, 0.02, 0), -fwd)
		else:
			_probe_to(pr, pr["rest"], fwd)


## Walk a figure along points (y follows them), then stand.
func _move(fig: Node3D, pts: Array, speed: float, then := "") -> void:
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
			Anim.walk(fig, _t, speed / 1.6, float(fig.get_instance_id() % 5), 1.0)
			await get_tree().process_frame
	if not is_inside_tree():
		return
	Anim.idle(fig, _t, 0.0)
	if fig == lynx and then != "":
		lynx_state = then


# ------------------------------------------------------------------ the drive panels

## Panel 1: the long dark road, the moon, the headlights.
func _panel_road() -> ImageTexture:
	var w := 320
	var h := 200
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	var hz := 92
	var r := RandomNumberGenerator.new()
	r.seed = 1414
	for y in h:
		for x in w:
			var c: Color
			if y < hz:
				var t := float(y) / hz
				c = Color(0.02, 0.02, 0.05).lerp(Color(0.16, 0.08, 0.14), t * t)
			else:
				var t2 := float(y - hz) / (h - hz)
				c = Color(0.07, 0.045, 0.04).lerp(Color(0.03, 0.02, 0.02), t2)
				var half := (y - hz) * 1.35 + 1.0
				if absf(x - w * 0.5) < half:
					c = Color(0.06, 0.06, 0.065)
					var glow_k := clampf(1.0 - Vector2((x - w * 0.5) / (half + 1.0), float(h - y) / 80.0).length(), 0.0, 1.0)
					c = c.lerp(Color(0.55, 0.48, 0.36), glow_k * 0.75)
					var dash := int(400.0 / (y - hz + 2.0)) % 2 == 0
					if dash and absf(x - w * 0.5) < maxf(0.6, (y - hz) * 0.03):
						c = Color(0.85, 0.75, 0.4)
			img.set_pixel(x, y, c)
	for k in 60:
		img.set_pixel(r.randi() % w, r.randi() % (hz - 10), Color(0.8, 0.8, 0.9))
	Body._ell(img, 252, 30, 13, 13, Color(0.94, 0.92, 0.84))
	Body._ell(img, 248, 27, 3, 3, Color(0.8, 0.78, 0.7))
	for k in 18:
		var bx := 140 + r.randi() % 40
		var bh := 2 + r.randi() % 7
		img.fill_rect(Rect2i(bx, hz - bh, 2, bh), Color(0.2, 0.12, 0.12))
	return ImageTexture.create_from_image(img)


## Panel 2: the city on the horizon, stabbed in the center by the tower.
func _panel_city() -> ImageTexture:
	var w := 320
	var h := 200
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	var hz := 150
	var r := RandomNumberGenerator.new()
	r.seed = 1515
	for y in h:
		var t := float(y) / hz
		var c := Color(0.03, 0.025, 0.07).lerp(Color(0.3, 0.12, 0.16), clampf(t * t, 0.0, 1.0)) if y < hz else Color(0.04, 0.03, 0.03)
		img.fill_rect(Rect2i(0, y, w, 1), c)
	var x := 0
	while x < w:
		var bw := 6 + r.randi() % 14
		var bh := int((10 + r.randi() % 34) * (1.0 - absf(x - w * 0.5) / (w * 0.75)))
		img.fill_rect(Rect2i(x, hz - bh, bw, bh), Color(0.02, 0.02, 0.03))
		for k in bw * bh / 30:
			img.set_pixel(mini(w - 1, x + r.randi() % bw), hz - 1 - r.randi() % maxi(1, bh), Color(0.9, 0.75, 0.4) if r.randf() < 0.7 else Color(0.3, 1.0, 0.6))
		x += bw
	# the tower: a shaft through the middle, the sphere and its ring, the red light
	img.fill_rect(Rect2i(157, 8, 6, hz - 8), Color(0.05, 0.07, 0.07))
	Body._ell(img, 160, 46, 14, 14, Color(0.06, 0.09, 0.08))
	for k in 80:
		var a := TAU * k / 80.0
		img.set_pixel(int(160 + cos(a) * 24), int(46 + sin(a) * 6), Color(0.3, 1.0, 0.6))
		img.set_pixel(int(160 + cos(a) * 23), int(46 + sin(a) * 5.5), Color(0.2, 0.7, 0.45))
	img.fill_rect(Rect2i(158, 5, 4, 4), Color(1.0, 0.1, 0.08))
	for y2 in range(hz, h):
		var half := (y2 - hz) * 2.2 + 1.0
		img.fill_rect(Rect2i(int(w * 0.5 - half), y2, int(half * 2.0), 1), Color(0.07, 0.07, 0.075))
	return ImageTexture.create_from_image(img)


# ------------------------------------------------------------------ dev args and the self-test

## Shots: scene=seated | white | vision | mimic | escape | outside; view=pull.
func apply_args(a: Dictionary) -> void:
	_shot = a.has("shot")
	var sc := str(a.get("scene", ""))
	if sc != "":
		main.flags["hangar_vast"] = true
		main.flags["hangar_altar"] = true
	if sc in ["seated", "white", "vision", "mimic", "escape"]:
		main.flags["hangar_song"] = true
		_cong_seat_all()
		_cong_lift = 1.0
		_cong_write()
		lynx.position = LYNX_OFFICE
		_hid = "office"
	if sc in ["white", "vision", "mimic", "escape"]:
		var fwd := _fwd(THRONE_YAW)
		var right := _right(THRONE_YAW)
		for tr: Array in [[prophet, Vector3.ZERO], [acolyte, ALTAR + fwd * 1.0 - right * 1.4], [eren, ALTAR + fwd * 1.0 + right * 1.4]]:
			var fig: Node3D = tr[0]
			_show(fig, _it_of(fig), true)
			fig.position = tr[1]
			fig.rotation.y = THRONE_YAW
		_sit_prophet(true)
		mask_mi.visible = sc == "white"
		if sc != "white":
			_plugs(true)
		for k in 3:
			var sj: Dictionary = subjects[k]
			_show(sj["fig"], sj["it"], sc != "vision")
			(sj["fig"] as Node3D).position = ALTAR + fwd * 2.5 + right * ((k - 1) * 0.95)
			turn_to(sj["fig"], ALTAR)
	if sc == "vision":
		_vision(1.0, 0.75, 1.0, 0.035)
		vision_mat.set_shader_parameter("amount", 1.0)
		vision_mat.set_shader_parameter("desat", 0.75)
		_vision_t = 30.0
		lights_mi.visible = true
		_lights_phase = "stare"
		_eye_yaw = atan2(-(WINDOW - _eye_c).x, -(WINDOW - _eye_c).z)
		eye_light.light_energy = 1.4
		halo.visible = false
	if sc == "mimic":
		_cong_face(WINDOW, false)
		for c: Dictionary in cong:
			c["yaw"] = c["want"]
		_cong_write()
	if sc == "escape":
		main.flags["hangar_mimic"] = true
		_escape = true
		_cong_track = true
		for e: Dictionary in eyeless:
			_show(e["fig"], e["it"], true)
		stair_lamp.light_energy = 0.25
		land_lamp.light_energy = 0.3
		spot.light_energy = 3.0
		_eye_layer()
	if sc == "outside":
		_outside = true
		_dusk(main.env, main.sun)
		lynx.position = OUT + Vector3(1.3, 0, -1.6)
	if str(a.get("view", "")) == "pull":
		var cam := Camera3D.new()
		cam.fov = 60.0
		cam.far = 1600.0
		dyn.add_child(cam)
		cam.global_position = Vector3(-24.0, 15.5, 30.0)
		cam.look_at(Vector3(0, 0, 0), Vector3.UP)
		cam.current = true
	main.update_hud()


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
	await intro()
	print("ok intro")
	await _by_id("lynx")
	p.position = Vector3(0.0, 0.1, 20.0)
	await _wait(func() -> bool: return f.has("hangar_vast"), 3.0)
	await _wait(func() -> bool: return not f.has("cinematic"), 30.0)
	print("ok vast ", f.has("hangar_vast"))
	for id in ["mural", "fixture", "stair", "catwalk", "service"]:
		await _by_id(id)
	await _by_id("recliner")
	print("ok song ", f.has("hangar_song"), " hiding=", _hiding)
	for id in ["service", "drill", "lynx"]:
		await _by_id(id)
	await _by_id("office_door")
	print("ok ceremony vision=", f.has("hangar_vision"), " sermon=", f.has("hangar_sermon"), " face=", f.has("hangar_1395_face"), " mimic=", f.has("hangar_mimic"), " conn=", main.connection)
	# the walk: the frames on by an eyeless on the stair; touched
	if not main.frames_on:
		_frames(true)
	p.position = Vector3(1.0, 1.4, 29.0)
	await _wait(func() -> bool: return f.has("hangar_touched"), 8.0)
	await _wait(func() -> bool: return not f.has("cinematic"), 10.0)
	print("ok touched ", f.get("hangar_touched", 0), " conn=", main.connection)
	# frames off at the top: brick
	_frames(false)
	p.position = DOOR + Vector3(0, 0.1, -2.0)
	await get_tree().create_timer(0.5).timeout
	await _by_id("exit_door")
	_frames(true)
	await _wait(func() -> bool: return _outside and not f.has("cinematic"), 20.0)
	print("ok outside ", _outside)
	for id in ["moon", "lot", "lynx_car", "bunker", "lynx"]:
		await _by_id(id)
	await _by_id("my_car")
	print("ok drive hangar_done=", f.has("hangar_done"))
	# the other branches, for the script's sake: the early slap, the drill lines
	main.trust["lynx"] = 2
	_hid = "drill"
	lights_mi.visible = true
	await _vision_rounds()
	await _argument()
	print("ok early slap saw_eye=", _saw_eye)
	_frames(true)
	await main.selftest_all_interactables()
