extends "res://scripts/Level.gd"
## Chapters 17 and 18, the morning after the observatory: the holding cell
## and FreudBot, then the hallway. Bible A2-B2. Book: "Sounds of logs on a
## fire filled my nostrils with pleasantness. The sharp, cold air of fall
## filled my lungs" ... "I awoke in a padded room I'd never seen before;
## the room was white." Turan's performance ("It's 9:30 a.m. I know they
## don't have clocks in these rooms. You look like shit."), her eyes going to
## the corners, the tablet held too long, the thumb on the scanner and the
## sentence Carl has to type himself; then "Freudbot's newest model looked
## like a big TV strapped to an old RC car", his dead mother's voice coming
## out of it, "Lie detected.", "Did someone make you BOW, Carl?", the
## reflection in the dark glass that turns its head when he doesn't, and the
## concession. Ch. 18: Monica outside the door with her arms round his neck,
## "This is how we keep our home, Carl.", and the subway home: no company car.
##
## Layout (metres). The leaves dream is its own patch of autumn wood at
## DREAM (z +400), a trail running north (-Z) for 70 m. The tower floor with
## no number is at the origin: the padded cell is 4 x 4 (pads at |x|,|z| 2.0),
## its door in the +Z wall at x 0 onto the hallway (z 2.3 .. 5.5, x -19.6 ..
## 19.6). West end: the stairwell door and the FreudBot dock; the neighbour
## cell with the window at x -5; east end: the guard, the badge reader and
## the two lifts. South of the hallway, behind glass, the dead open-plan
## office (z 5.5 .. 13) with the Psyon eye screens on its back wall. The
## subway car is at SUBWAY (x +300), shown only for the ride.
##
## Reads: main.trust turan (>= 1: the note) and monica (>= 1: she mouths
## "Go to Lushon's"; <= -1: she has booked the spa), main.glyphs_found (a
## "No" to the hallucinations is a lie), the flags bowed / bowed_today or a
## bow in main.ledger (a "No" to BOW is a lie), charged_observatory (the
## restraint lines), and drank_mezcal / mezcal or "mezcal" in the ledger
## (Turan's extra line; no level sets one yet). Sets: hc_woke, hc_turan,
## ev_turan_note, hc_signed, freudbot_1, spa_booked, hc_hallway, pip_active.
## Figures and devices carry metas for the stealth pass: "guard" (the
## lift guard), "camera" + "hackable" (the hallway cameras, the badge
## reader), "route" (badge / hack / sneak / person) on the four ways off the
## floor.

const LINES := {
	"build": {
		"card": "[b]THE LEAVES[/b]\n\n[color=#aaaaaa]Day 4, before 09:30[/color]",
		"woke_cap": "PSYONIC TOWER  ·  FLOOR --  ·  RECONCILIATION  ·  DAY 4, 09:30",
		"subway_card": "[b]THE SUBWAY[/b]\n\n[color=#aaaaaa]the contractors' line  ·  PIP: no company car[/color]",
		"end_card": "[b]PIP ACTIVE[/b]\n\n[color=#aaaaaa]three FreudBot sessions  ·  limited access  ·  floors above 86 locked[/color]",
	},
	"objective": {
		"dream": "Follow the trail.",
		"awake": "The door.",
		"sign": "Sign the tablet.",
		"typing": "Type the statement.",
		"wait": "Wait for FreudBot.",
		"mirror": "The screen.",
		"leave": "Leave the cell.",
		"hall": "The lifts. Go home.",
	},
	"dream": {
		"c1": "Sounds of logs on a fire. The sharp, cold air of fall filled my lungs, and a strong peace took over.",
		"c2": "The leaves had just started to change. My feet snapped tiny twigs and sticks on a path that felt like home.",
		"c3": "There's nothing to do, nothing to worry about.",
		"c4": "Monica, Ezra, and Mira at the end of the trail. Laughing and smiling. A rush of warmth through my chest.",
		"c5": "I missed the fall of the East Coast so dearly. My first home, before the war destroyed half of the coast and killed my brother.",
		"c6": "Before the famine, before Psyonic ruled my life, before it pretended to be a god.",
		"c7": "I'm asleep. Their laughter seemed more distant now. So did the calm.",
		"c8": "I tried to run to catch up to them, but…",
		"c9": "The more I tried to fight it, the faster it faded away.",
	},
	"wake": {
		"think1": "I awoke in a padded room I'd never seen before; the room was white. My memory stirred from the night before. My head split with pain.",
		"think2": "How can this be happening? What did they expect me to do? Let them take her eyes?",
		"think2_quiet": "How can this be happening? I hadn't thrown a punch. I hadn't run down the hill. I'd come home. It didn't matter.",
		"think3": "How did I not notice the signs before it was too late? I really have lost myself.",
		"door": "No handle on this side. A strip of wired glass, the corridor beyond it, and a man in a visor who would not look at me.",
	},
	"turan": {
		"knock": "There was a knock on the door. Graying hair emerged, highlighted by magenta Ora frames. She wore a look of pity and confusion on her face.",
		"knew": "I wondered how much she knew; she had to know something, though it was her that led the charge in the Dufredy case.",
		"t1": ["Turan", "It's 9:30 a.m. I know they don't have clocks in these rooms. You look like shit. You've got yourself into one hell of a mess. You're lucky you have friends like me and your wife in high places, or you would've been deregistered for pulling that shit."],
		"water": "My mouth was dry and hoarse; I needed water.",
		"t2": ["Turan", "What the hell were you thinking leaving a company car out in the middle of the desert like that? What, you go on a joyride with Lynx and trash the car?"],
		"what": ["Carl", "Excuse me, what?"],
		"t3": ["Turan", "You abused company property and went on a drunken bender with Lynx last night and ruined your daughter's astronomy field trip. You ought to be ashamed. You would've been fired, out on the street."],
		"mezcal": ["Turan", "Mezcal, was it? That part's true, at least."],
		"t4": ["Turan", "Very lucky, Mr. Drake, you are very lucky… that our new CEO is such a forgiving man."],
		"play": "She gave me a knowing look. Her tone was weird, like it was the first time she was acting in a play.",
		"t5": ["Turan", "He only requested that you take a temporary leave of absence for the next week. During this time, our lovely CEO requires you to complete three sessions with Freudbot to talk about your alcoholism. You will have limited access to Psyonic's facilities during this time."],
		"t6": ["Turan", "Also, you're being placed on a PIP, so don't fuck up again, Mr. Drake; there won't be any additional chances."],
		"pip": "A fucking PIP, for fighting against my daughter's eyes from getting ripped out. Something is off; her tone is kind… that was foreign to Turan.",
		"pip_quiet": "A fucking PIP. For standing on a ridge and watching. Something is off; her tone is kind… that was foreign to Turan.",
		"ask": ["What about Mira and Ezra? Are they okay?", "What about Lynx?"],
		"kids_q": ["Carl", "What about Mira and Ezra? Are they okay?"],
		"kids": ["Turan", "That's more like you, Mr. Drake. They're safe and sound in your, may I remind you, company-issued home."],
		"eyes": "Her eyes gestured toward the corners of the room. It was a message: I'm being watched everywhere here.",
		"lynx_q": ["Carl", "What about Lynx?"],
		"lynx": ["Turan", "Same as you, but she's on thinner ice since the car was provisioned under her name."],
		"t7": ["Turan", "Maybe the both of you can get together and apologize to the people you've hurt."],
		"blink": "With a blink that ran too long.",
		"t8": ["Turan", "You need to leave this Dufredy case behind and get back on the right path."],
		"brow": "Her brow quivered nervously as she said \"Dufredy case.\" Dufredy was the least of our problems.",
		"t9": ["Turan", "You will have your first meeting with Freudbot today and then will be released back to the public. Understand your continued employment is contingent on you completing three sessions with Freudbot prior to returning to the office."],
		"t10": ["Turan", "Do you consent to these terms, Carl?"],
		"wink": "She gave me a nervous wink.",
		"t11": ["Turan", "Please sign this form saying that you understand the terms of your reconciliation."],
		"handoff": "She slid over a tablet to my hand but held onto it too long; her fingers moved under the tablet and slipped a rolled paper note into my hand.",
		"handoff_cap": "the tablet, held too long  ·  under it, rolled paper",
		"no_note": "She slid the tablet over to my hand and let go of it at once, like it was hot. Her eyes didn't go to the corners again.",
		"thumb": "I pressed my thumb onto the biometric scanner and verbally agreed to the conditions.",
		"agree": ["Carl", "I agree to my reconciliation process. Thank you for the opportunity. I am sincerely apologetic for my actions."],
		"slow": ["Turan", "Take your time, Mr. Drake. The camera isn't going anywhere."],
		"t12": ["Turan", "Perfect. A Freudbot will be brought into your cell shortly; after that, you are free to go and think about how you will make this up to the company."],
		"pocket": "With that, she left. I placed the note into my pocket, making sure to avoid the view of the camera. I couldn't read it here. If Turan has something to say, I'd rather keep it between us.",
		"left": "With that, she left. The door sealed behind her with the sound a fridge makes.",
		"note_log": "Turan slipped me a rolled paper note under the PIP tablet, out of the cameras' view.",
		"sign_log": "Signed the reconciliation terms. Typed it myself: \"I am sincerely apologetic for my actions.\"",
	},
	"typing": {
		"head": "PSYONIC  ·  HUMAN RESOURCES  ·  RECONCILIATION AGREEMENT",
		"sub": "BIOMETRIC ACCEPTED: DRAKE, C. (86-D)    ·    type the statement below to sign",
		"target": "I am sincerely apologetic for my actions.",
		"errors": "corrections: %d",
		"done": "SIGNED  ·  thank you for your cooperation",
	},
	"wait": [
		"Freudbot was the top-of-the-line application of computer knowledge of the human psyche, rated to support the mental health of over 25 distinct cultures and languages.",
		"When it worked, it was a valuable tool, but I've only investigated the malfunctioning units. One developed the neuroses of the patients it was trying to help.",
		"I once interviewed a version that tried to seduce me, convinced I was the ghost of its first patient. I'd prefer the lobotomy.",
		"How could Mira become so brainwashed so quickly? She looked at me like I wasn't her father. What the hell does \"the Mimic\" mean anyway?",
		"Alcoholic… I don't even drink; I haven't had in years, not since Ezra was born. A convenient way to silence us.",
		"Mira and Ezra need to get out of this place, even if that means leaving Silico. Would they let us go?",
	],
	"session": {
		"knock": "A knock came on the door. A nurse wheeled my robotic therapist in and left the room.",
		"model": "Freudbot's newest model looked like a big TV strapped to an old RC car. It was so much more; there was a study that humans found it easier to share their true emotions with the device rather than a person.",
		"judge": "People can judge; the only thing was Freudbot judged too, just not to your face. To your supervisors, to your boss, to whatever data scientist was trying to optimize his \"Empathy.\"",
		"stare": "Freudbot sat there and stared for a while, hidden cameras studying my every move, every muscle twitch, every potential thought I had.",
		"glass": "I stood perpendicular to FreudBot, not meeting its gaze but my own, reflected in its cold glass screen.",
		"voice": "Then I was greeted by a voice. Soft, calm, and comforting. Like a rainy September day, like it was from somewhere far away, somewhere where I was safe.",
		"mother1": "Carly… I heard you might need some help right now.",
		"mother2": "I'm here to help you.",
		"ten": "My head turned sideways; a dull pain ached through my brow; my throat became sand. Suddenly, I was ten years old again, in my parents' car on our move to Sillico. My eyes swelled with tears.",
		"id": ["FREUDBOT", "First, let's start with confirming your identity. Are you Carl Drake?"],
		"gruff": "The intonation changed; now it was that of a gruff man. It called me Carly; only my mother did that. My mother's been dead for five years now; I hadn't heard that voice for five years.",
		"id2": ["FREUDBOT", "Sir, can you hear me? Are you Carl Drake? If no answer is received within the next 30 seconds, medical staff will be alerted."],
		"id_choices": ["Yes, I'm Carl Drake.", "…Mom?"],
		"id_mom": ["FREUDBOT", "Please confirm your identity for the record."],
		"id_yes": ["Carl", "Yes, I'm Carl Drake."],
		"id_mom_log": "FreudBot spoke in my mother's voice. I answered to it.",
		"thanks": ["FREUDBOT", "Thank you, Carl. Your cooperation is key to your reconciliation and further success."],
		"suicide": ["FREUDBOT", "Firstly, have you been experiencing any suicidal thoughts or urges?"],
		"flat": "The effect of Freudbot remained flat.",
		"suicide_choices": ["No, I haven't.", "You locked me in a white room. Ask me tomorrow."],
		"good": ["FREUDBOT", "Good."],
		"interrupt": "It interrupted.",
		"anxiety": ["FREUDBOT", "Any moments of anxiety or extreme paranoia?"],
		"paranoia": "Was it paranoia, if it was justified?",
		"anxiety_choices": ["No.", "Is it paranoia, if it's justified?"],
		"next": ["FREUDBOT", "Good, next question."],
		"halluc": ["FREUDBOT", "Any hallucinations, seeing things that aren't there?"],
		"halluc_choices": ["No…", "Yes. Rings. Eyes where there shouldn't be eyes."],
		"lie": ["FREUDBOT", "I detected lies, Carl. Therapy only works if you're honest with me."],
		"lie_text": "The text displayed on the screen in a small font: \"Lie detected.\"",
		"honest": ["FREUDBOT", "Thank you for your honesty, Carl. That has been noted for your supervisor."],
		"halluc_lie_log": "FreudBot: \"Any hallucinations?\" I said no. Lie detected. It had the glyphs.",
		"yesterday": ["FREUDBOT", "Tell me about yesterday, Carl."],
		"bow": ["???", "[shake rate=24 level=12][b]Did someone make you BOW, Carl?[/b][/shake]"],
		"mud": "The voice changed again; it was the voice in the mirror room. The voice boomed and turned my legs to mud.",
		"dark": "The screen went dark so I could see my reflection again. It shifted and turned its head, not matching my movements.",
		"resolute": "I was getting sick of this; I stood strong and resolute.",
		"bow_choices": ["No, I have no idea what you're talking about.", "Yes. In the desert. On my knees."],
		"bow_lie_log": "FreudBot, in the mirror's voice: \"Did someone make you BOW?\" I said no. Lie detected. It had the desert.",
		"bow_yes": ["???", "[shake rate=24 level=8]Good. You remember the floor.[/shake]"],
		"bow_no": ["???", "[shake rate=24 level=8]Not yet.[/shake]"],
		"desert": ["???", "[shake rate=24 level=10]What happened out in the desert, Carl? Did you learn how to Bow?[/shake]"],
		"will_not": ["Carl", "No, I will not bow."],
		"submit": "You've done it before, Carly, just submit to it.",
		"mouth_choices": ["Get my mother's voice out of your mouth!", "…Mom? Is that you?"],
		"mouth": ["Carl", "Get my mother's voice out of your mouth!"],
		"mom_log": "I called the thing in the FreudBot \"Mom\". It liked that.",
		"closing": "Good, Carl… good… that'll do nicely… Psyonic is serving its purpose, but they seek to contain, to enslave… to hide… it's not enough… you should really see it, Carl, I think… you'll like it… the journey… the vision… the boundary…",
		"soon": "I'll talk with you soon, Carly.",
		"blink": "The screen blinked, and my reflection disappeared. The voice returned to normal. I felt the air in the room lighten and turn soft. My breath returned to me.",
		"alcohol": ["FREUDBOT", "How long have you suffered from alcoholism, Carl?"],
		"alcohol_choices": ["I'm sorry for my actions; it won't happen again.", "I don't drink; I haven't drank in over five years."],
		"alcohol_again": ["I don't drink.", "I'm sorry for my actions; it won't happen again."],
		"records": ["FREUDBOT", "My records show otherwise, Mr. Drake."],
		"reconcile": ["FREUDBOT", "You need to reconcile."],
		"give_in": "I realized I needed to give in.",
		"sorry": ["Carl", "I'm sorry for my actions; it won't happen again."],
		"step": ["FREUDBOT", "Recognizing the problem is the first step."],
		"progress": ["FREUDBOT", "We've made a lot of progress today, don't you think, Carl?"],
		"proud": ["FREUDBOT", "I think our next session will be full of breakthroughs. I'm proud of you, Mr. Drake."],
		"malfunction": "What kind of fucking malfunction was that?",
		"log": "FreudBot session 1 of 3. My mother's voice; the mirror's voice; conceded the alcoholism.",
		"screen_name": "FREUDBOT GPT",
		"screen_sub": "SALTECH × PSYONIC  ·  session 1 of 3",
		"screen_listen": "listening…",
		"screen_lie": "Lie detected.",
		"ledger_glyph": "LEDGER: glyphs examined %d",
		"ledger_bow": "LEDGER: %s",
	},
	"after": {
		"nurse": ["Nurse", "I hope you had an enlightening session, Mr. Drake. I do hope this helped. You are free to go now. Be sure to be back here tomorrow to continue your sessions as outlined in your PIP."],
		"tool": "Freudbot slipped out the room quietly, like a tool, not like a therapist that was possessed by a rogue piece of software. Not like a demon who stole my mother's voice, just wires and silicon, blood and bone.",
		"spire": "My mind swirled with thoughts of my mother, thoughts of last night and Mira. There was no one in this labyrinthian spire I fully trusted now.",
		"broken": "I sat in the center of the room, broken beyond repair. My credibility was gone with that alcohol story. I stood up, collected my brains into a bowl, and proceeded towards the door.",
	},
	"monica": {
		"soccer": "Monica stood directly outside the room, like a parent waiting to take their child home from soccer. Her face… looked kind, but in a waxy way… a way that told me this conversation was going to suck.",
		"m1": ["Monica", "Carl, honey… are you okay…?"],
		"viper": "She moved toward me like a viper about to strike. Her expressions looked real, like an old apartment, familiar, but I hadn't lived there in years.",
		"m2": ["Monica", "Ezra and Mira are worried sick about you. Last night… last night was deeply uncomfortable for them. They've never seen you that drunk."],
		"bite": "There it was, the bite from the grass. I wish I could say I didn't expect it.",
		"drink": ["Carl", "You know I don't drink. I hadn't been drunk since Ezra was born."],
		"mask": "Her face got serious; she dropped her mask. She wrapped her arms around my neck in a pseudo-romantic fashion and moved her head inches from my face.",
		"m3": ["Monica", "This is how we keep our home, Carl. Besides, you're good at keeping secrets. I'm sure you could keep a drinking habit from me."],
		"idea": ["Carl", "It was your idea, wasn't it?"],
		"smile": "Her lips slightly flared up in a half-smile and then dropped down. A moment of recognition that I was still her husband and I knew her mind.",
		"m4": ["Monica", "I'm happy you're okay, Carl. I had heard Eren's guard team had to restrain you, and you fought back. Be fortunate our illustrious new CEO recommended just a PIP for you. Other people would be out on the street."],
		"m4_quiet": ["Monica", "I'm happy you're okay, Carl. Be fortunate our illustrious new CEO recommended just a PIP for you. Other people would be out on the street."],
		"gone": "My wife was gone… replaced by this thing, this brain of corporate slogans and empathy-at-scale slide decks… always positioning for power. Or maybe I had changed, or something within me did.",
		"m5": ["Monica", "I think after last night's events, and your alcoholism, you should take some time away from the tower… I think it could help you get some… perspective."],
		"broke": "Her composed tone broke for a moment.",
		"m6": ["Monica", "To work on your strategy to get off your fucking PIP."],
		"spa": ["Monica", "I think Mira needs some time to cool off; you embarrassed her in front of all of her friends. I arranged for you to stay at a luxury rehabilitation spa in the center of town to help support your reconciliation. It's been highly recommended by senior leadership. Get a massage, Carl… clear your mind… we will be here waiting for you when you're better."],
		"spa_log": "Monica has booked me into the reconciliation spa downtown. \"Highly recommended by senior leadership.\"",
		"mouth_pre": "Her arms were still round my neck, her back to the camera. Her lips moved against my ear with no sound at all:",
		"mouthed": "[i]Go to Lushon's. Don't go to the spa.[/i]",
		"mouth_log": "Monica, mouthed, with her back to the camera: \"Go to Lushon's. Don't go to the spa.\"",
		"m7": ["Monica", "I love you, Carl. I'll meet you here tomorrow after your next Freudbot session."],
		"lost": "I had lost; whatever game I was playing, I lost. I thought I was doing my job; I was investigating. Tears began to fall down my face, like sand in an hourglass running out of time.",
		"plea_choices": ["Please don't let them take her eyes.", "Say nothing."],
		"plea": ["Carl", "Please don't let them take her eyes."],
		"silent": "I didn't say it. She answered it anyway.",
		"m8": ["Monica", "No one is going to take her eyes, Carl; that's an alcoholic delusion."],
		"take": "There was something off with the way she said \"take,\" like that was the most important word of the sentence, like that absolved responsibility. She turned and walked away.",
		"muscles": "I should've stayed in the padded room as my muscles tried to burst from my skin.",
		"log": "Monica outside the cell: \"No one is going to take her eyes, Carl; that's an alcoholic delusion.\" The alcoholism was her idea.",
	},
	"leave": {
		"guard": ["Guard", "Mr. Drake. The lift's keyed to the lobby for you. PIP access. Have a reconciled day."],
		"no_car": "With my PIP and leave of absence, my access to corporate amenities was limited. That means no company car. I had to take public transit.",
		"lifts_locked": "The lifts wouldn't come for me yet. Not until FreudBot had had its hour.",
		"blocks": "The subway was a few blocks from the metal musculature that was HQ. Contractors had to take it. They hadn't been blessed with the status of constant in-house surveillance and free car rides.",
		"sun": "This part of town directly outside of the tower was clean and showed less decay than the neighboring districts. Psyonic HQ was the sun, and all the energy trickled down and diminished as you left city center.",
		"note_pre": "Before entering the subway station, when I was obscured from the view of the cameras, I looked in my pocket and removed the note from Turan.",
		"note": "[i]Meet us at Lushon Tavern in the Red Rock District tonight at 9:15 p.m. It's a travesty what they're doing to us, Carl.[/i]",
		"note_cap": "Turan's handwriting  ·  pencil on a torn corner of a printout",
		"note_after": "I read those words like they were written in a foreign language… \"what they're doing to us.\" I hadn't realized how isolated I'd been feeling since this all started. Maybe Turan was on my side after all.",
		"note_log": "Turan's note: Lushon Tavern, Red Rock, tonight 9:15 p.m. \"It's a travesty what they're doing to us, Carl.\"",
		"no_note": "Out of the cameras' view I checked my pocket anyway. Nothing. Whatever Turan had wanted to say, she hadn't.",
		"ride1": "I tried to call Lynx on her frames, and there was no answer. I hope her Freudbot didn't have the same malfunction.",
		"ride2": "I still had to save my kids. I still needed to free this town from this cult. All that's changed is I know who the villains are.",
		"ride3": "I sure as hell wasn't going to some reconciliation spa to cool down; I was going to fight this. Even if it meant finding a way to shut off Psyon for good.",
		"log": "PIP active. Leave of absence, three FreudBot sessions, no company car. The subway home.",
	},
	"look": {
		"camera_dot": "A camera dot, black, the size of a fingernail, with a red pip in it that never blinked when I did. There was one in every corner.",
		"padding": "Quilted padding, every surface, buttoned every half metre. It smelled new. Somebody had built this floor for exactly this.",
		"pad_scan": "RECONCILIATION SUITE 04\nsurface: SOFT\nclock: NONE\nfloor: (NONE)",
		"cam_scan": "PSYONIC OPTICS  -  RC-04 / corner %d\nfeed: LIVE\nretention: FOREVER",
		"tablet_prompt": "Press your thumb to the scanner",
		"tablet_scan": "PSYONIC HR  -  PIP-7781\nemployee: DRAKE, C.\nstatus: AWAITING SIGNATURE",
		"tablet_done": "SIGNED. Thank you for your cooperation.",
		"freudbot_scan": "FREUDBOT GPT  -  unit RC-12\nvendor: SALTECH / PSYONIC\nsession: 1 of 3\npatient: DRAKE, C.",
		"freudbot_after": "Its screen was a mirror again. Just mine in it now, and I wasn't sure of that.",
		"turan_scan": "TURAN, DR. A.\nPSYONIC - HEAD OF HUMAN-AI INTEGRATIONS\nfloor: 86",
		"nurse_scan": "SALTECH CARE  -  RN, contract\nassigned: RECONCILIATION 04\nnext: RECONCILIATION 05",
		"monica_scan": "DRAKE, MONICA (38)\nPSYONIC PR - DIRECTOR OF CORPORATE IMAGE\nfloor: 108  (as of today)",
		"guard_scan": "PSYONIC SECURITY  -  floor --\nbadge: ACTIVE\nvisor: RECORDING",
		"guard": "He looked at the lift doors, not at me. His visor looked at me.",
		"hc_cam": "A dome camera on the ceiling. It turned when I walked, a half-second behind, like a dog that had been taught to.",
		"hc_cam_scan": "PSYONIC OPTICS  -  corridor %d\nfeed: LIVE (3 VIEWERS)\nhack: LOOK AWAY",
		"reader": "A badge reader by the lifts. My badge would get me down. That was all it would do for a week.",
		"reader_scan": "BADGE READER  -  floor --\naccepts: COMPANY BADGE\nDRAKE, C.: LOBBY ONLY (PIP)",
		"stairs": "STAIRS · ALARMED. The push bar had a seal on it, a little paper tongue with the Psyonic eye printed on it.",
		"stairs_scan": "FIRE STAIR B\nalarm: ARMED\nlast opened: NEVER",
		"vent": "A return-air grille in the ceiling tiles, bigger than it needed to be. The screws were the kind you turn with a coin.",
		"vent_scan": "HVAC RETURN  -  R-9\nduct: 0.6 m\nruns to: SERVICE CORE",
		"directory": "The floor directory by the lifts. 85, 86, 87, 88. Between 86 and 87 there was a line with no number on it, and a word: RECONCILIATION.",
		"directory_scan": "PSYONIC TOWER  -  directory\nthis floor: --\nlisted: NO",
		"neighbour": "Through the wired glass of the next door: a white room like mine. A man on his knees on the padding, forehead to the floor, in front of a FreudBot with a dark screen. It looked like he had been there a long time.",
		"neighbour_scan": "RECONCILIATION SUITE 03\noccupant: (WITHHELD)\nsession: 41 of 3",
		"door_other": "RECONCILIATION 0%d. The glass was blacked out from inside. A red light over it: IN SESSION.",
		"dock": "The FreudBot fleet, docked nose to the wall like dogs that had been punished. Their dark screens were reflecting the wall back at itself.",
		"dock_scan": "FREUDBOT DOCK B\nunits: 3 (CHARGING)\nsessions today: 214",
		"desk": "A smart desk in the dead office. The whole top was a screen, black, with a coffee ring burned into it where somebody's cup had sat on the same spot for a year.",
		"desk_scan": "VIRTEC SMARTDESK 3\nuser: (UNASSIGNED)\nlast login: 211 DAYS",
		"pillar": "A concierge pillar. ASK ORA. Its ring of light was dead; when I leaned close it said, very quietly, \"…welcome back.\"",
		"pillar_scan": "ORA CONCIERGE  -  floor --\nstatus: OFFLINE\nmicrophone: ON",
		"screens": "The wall of screens behind the glass. PSYON  ·  the pillow for those who dream. And between the slogans, for a frame at a time, the eye.",
		"screens_scan": "PSYONIC SIGNAGE  -  wall 6\ncontent: CORPORATE\nframes injected: UNKNOWN",
		"thermo": "SMART CLIMATE · 21°C · MOOD: CALM (LOCKED). The display was frozen on a smiling sun.",
		"thermo_scan": "IONWARE CLIMATE\nmood preset: CALM\nlocked by: HR",
		"water": "A hydration station. It had a face, two dots and a curve, and the face had been switched off.",
		"water_scan": "HYDRATION STATION\nlevel: 0%\nreminders sent: 4,112",
		"blinds": "Smart blinds, locked shut. 09:30 in the morning and not a sliver of the city. BLINDS: LOCKED (PIP).",
		"blinds_scan": "SMART GLASS  -  south\nmode: OPAQUE\noverride: HR",
	},
	"phone": {
		"text1": "[color=#7fe6b0]Psyon:[/color] Good morning, Carl. Your account is on a Performance Improvement Plan. Some features are limited.\n\n",
		"text2": "[color=#7fe6b0]Psyon:[/color] Reminder: FreudBot session 1 of 3 today. Honesty is the first step.\n\n",
		"text3": "[color=#7fe6b0]Psyon:[/color] Calling Lynx Morrino… no answer.\n\n",
	},
	"subway": {
		"ad1": ["FREUDBOT", "talk to someone who listens"],
		"ad2": ["PSYON", "the pillow for those who dream"],
		"ad3": ["SPA·RECONCILE", "senior leadership recommends"],
		"commuter_scan": "CONTRACTOR  -  VIRTEC PRINT\nfare: PAID\nfeed: KID TOK (muted)",
		"commuter": "A contractor, frames on, head down, watching something with the sound off. On the lens, very small: children in a circle.",
	},
}

const PSYON_GREEN := Color(0.2, 1.0, 0.45)
const DREAM := Vector3(0, 0, 400)
const SUBWAY := Vector3(300, 0, 0)
const DOOR_Z := 2.2
const HALL_Z0 := 2.3
const HALL_Z1 := 5.5
const HALL_X := 19.6
const CORNERS := [Vector3(-1.94, 2.5, -1.94), Vector3(1.94, 2.5, -1.94), Vector3(1.94, 2.5, 1.94), Vector3(-1.94, 2.5, 1.94)]
const FB_PARK := Vector3(0, 0, -1.05)
const DREAM_SECS := 40.0

signal dream_over
signal typed_done

var _env: Environment
var _sun: DirectionalLight3D
var dream_root: Node3D
var cell_root: Node3D
var hall_root: Node3D
var sub_root: Node3D
var pads: Node3D
var door_body: StaticBody3D
var door_open := false
var family: Array = []
var fam_z := -30.0
var leaves_fx: CPUParticles3D
var fire_light: OmniLight3D
var cell_light: OmniLight3D
var cell_fill: OmniLight3D
var cam_leds: Array = []
var turan: Node3D
var turan_it: CollisionObject3D
var nurse_it: CollisionObject3D
var monica_it: CollisionObject3D
var nurse: Node3D
var monica: Node3D
var guard: Node3D
var tablet: Node3D
var tablet_it: CollisionObject3D
var tablet_glow: StandardMaterial3D
var freudbot: Node3D
var fb_it: CollisionObject3D
var fb_wheels: Array = []
var fb_face: Node3D
var fb_lie: Label3D
var fb_ledger: Label3D
var fb_bars: Array = []
var mirror_vp: SubViewport
var mirror_cam: Camera3D
var mirror_anchor: Node3D
var twin: Node3D
var twin_hist: Array = []      # [[t, pos, yaw, pitch]]
var twin_mode := "lag"         # lag | own
var twin_lag := 0.6
var hall_cams: Array = []      # [pivot, offset]
var eye_screens: Array = []    # [slogan node, eye node]
var lift_doors: Array = []
var lift_label: Label3D
var commuters: Array = []
var tunnel_lights: Array = []
var movers: Array = []         # [{fig, path, i, speed, wheels}]
var _stage := "dream"
var _dream_on := false
var _dream_t := 0.0
var _receding := false
var _recede_t0 := 0.0
var _dream_caps: Array = []
var _door_knocked := false
var _wait_i := 0
var _session_started := false
var _monica_started := false
var _leaving := false
var _ended := false
var _riding := false
var _turan_look := Vector3.ZERO
var _turan_looking := false
var _turan_hold := false
var _typing_on := false
var _type_i := 0
var _type_errors := 0
var _type_layer: CanvasLayer
var _type_panel: PanelContainer
var _type_text: RichTextLabel
var _type_err: Label
var _serif: SystemFont
var _serif_i: SystemFont
var _tone: AudioStreamPlayer
var _room_tone: Node
var _force := -1               # selftest: forces the next _ask() pick
var _pad_breathe := 0.0


# ------------------------------------------------------------------ build

func build(m: Node) -> void:
	main = m
	rng.seed = 1718
	kit_day = true   # the dream is daylight; _wake() regrades for the tower
	step_db = -20.0
	card = LINES["build"]["card"]
	_serif = SystemFont.new()
	_serif.font_names = PackedStringArray(["DejaVu Serif", "Liberation Serif", "Noto Serif", "Times New Roman", "Georgia", "serif"])
	_serif_i = SystemFont.new()
	_serif_i.font_names = _serif.font_names
	_serif_i.font_italic = true
	_dream()
	_cell()
	_hall()
	_office()
	_subway()
	_people()
	_freudbot()
	_mirror()
	_typing_ui()
	_tone = AudioStreamPlayer.new()
	_tone.stream = _flat_tone()
	_tone.volume_db = -8.0
	add_child(_tone)
	sub_root.visible = false
	spawn = DREAM + Vector3(0, 0.2, 2.0)
	spawn_yaw = 0.0


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	_env = env
	_sun = sun
	_env_dream()


## An East Coast autumn morning that never existed in Silico: a pale sky,
## low gold sun, wood smoke in the air.
func _env_dream() -> void:
	var psm := ProceduralSkyMaterial.new()
	psm.sky_top_color = Color(0.36, 0.46, 0.62)
	psm.sky_horizon_color = Color(0.92, 0.74, 0.52)
	psm.ground_horizon_color = Color(0.6, 0.45, 0.3)
	psm.ground_bottom_color = Color(0.2, 0.14, 0.08)
	psm.sky_curve = 0.12
	_env.sky.sky_material = psm
	_env.ambient_light_color = Color(0.85, 0.72, 0.58)
	_env.ambient_light_energy = 0.7
	_env.fog_enabled = true
	_env.fog_light_color = Color(0.95, 0.82, 0.62)
	_env.fog_density = 0.012
	_env.fog_sky_affect = 0.5
	_env.glow_bloom = 0.0
	_env.tonemap_exposure = 1.05
	_sun.light_color = Color(1.0, 0.82, 0.6)
	_sun.light_energy = 1.1
	_sun.rotation = Vector3(deg_to_rad(-22), deg_to_rad(150), 0)


## The tower floor: no sun, no sky, the light of panels.
func _env_tower() -> void:
	_env.ambient_light_color = Color(0.62, 0.68, 0.72)
	_env.ambient_light_energy = 0.28
	_env.fog_enabled = true
	_env.fog_light_color = Color(0.12, 0.14, 0.15)
	_env.fog_density = 0.006
	_env.fog_sky_affect = 0.0
	_env.glow_bloom = 0.03
	_env.tonemap_exposure = 1.1
	_sun.light_energy = 0.0


func hifi(env: Environment, _s: DirectionalLight3D) -> void:
	env.volumetric_fog_density *= 0.4
	if cell_light:
		cell_light.shadow_enabled = true


func ambience() -> void:
	main.loop("fire", -14.0, DREAM + Vector3(-3.2, 0.4, -3.0), 3.0, 30.0)
	main.loop("wind", -24.0)
	_room_tone = main.loop("room", -60.0)


func _omni(parent: Node, pos: Vector3, c: Color, e: float, r: float) -> OmniLight3D:
	var o := OmniLight3D.new()
	o.position = pos
	o.light_color = c
	o.light_energy = e
	o.omni_range = r
	o.omni_attenuation = 1.3
	o.shadow_enabled = false
	parent.add_child(o)
	return o


func _set_layer(n: Node, layer: int) -> void:
	if n is VisualInstance3D and not n is Light3D:
		(n as VisualInstance3D).layers = layer
	for c in n.get_children():
		_set_layer(c, layer)


# ------------------------------------------------------------------ the leaves (ch.17 opening)

## The trail through the autumn wood, a fire at the start of it, and the
## family at the end of it. Built in its own root at DREAM; hidden on waking.
func _dream() -> void:
	dream_root = Node3D.new()
	dream_root.position = DREAM
	add_child(dream_root)
	var d := dream_root
	var ground := mat(Color(0.36, 0.22, 0.1), 1.0)
	box(Vector3(160, 0.2, 180), Vector3(0, -0.1, -40), ground, true, d)
	var dirt := mat(Color(0.26, 0.17, 0.11), 1.0)
	for i in 36:
		var z := 4.0 - i * 2.0
		var seg := floor_quad(Vector2(1.7, 2.1), Vector3(_trail_x(z), 0.012, z), sin(z * 0.06) * 0.1, dirt, d)
		seg.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var bark := pbr("bark", Vector3(1, 1, 1) / 1.5, true, Color(0.5, 0.42, 0.36))
	var autumn := [mat(Color(0.86, 0.5, 0.1), 0.9), mat(Color(0.72, 0.2, 0.08), 0.9), mat(Color(0.92, 0.72, 0.2), 0.9), mat(Color(0.55, 0.16, 0.06), 0.9)]
	var card_m := _autumn_card_mat()
	for i in 30:
		var z := 6.0 - i * 2.6
		var side := -1.0 if i % 2 == 0 else 1.0
		var x := _trail_x(z) + side * rng.randf_range(3.2, 8.5)
		_autumn_tree(Vector3(x, 0, z + rng.randf_range(-1.0, 1.0)), rng.randf_range(5.5, 8.0), bark, autumn, card_m, d)
	for i in 30:
		var z := 10.0 - i * 3.0
		_autumn_tree(Vector3(rng.randf_range(10.0, 30.0) * (-1.0 if i % 2 == 0 else 1.0), 0, z), rng.randf_range(7.0, 9.5), bark, autumn, card_m, d)
	# the fallen leaves: flat cards in four colours, thick at the edges of the trail
	for i in 900:
		var z := rng.randf_range(-70.0, 8.0)
		var off := rng.randf_range(-9.0, 9.0)
		if absf(off) < 0.7 and rng.randf() < 0.7:
			off *= 2.4
		var q := floor_quad(Vector2(0.24, 0.17) * rng.randf_range(0.8, 1.7), Vector3(_trail_x(z) + off, 0.02 + rng.randf() * 0.01, z), rng.randf() * TAU, autumn[i % 4], d)
		q.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	# twigs and sticks on the path, the ones he snaps
	var twig := mat(Color(0.32, 0.22, 0.14), 0.9)
	for i in 50:
		var z := rng.randf_range(-66.0, 6.0)
		var a := Vector3(_trail_x(z) + rng.randf_range(-0.9, 0.9), 0.025, z)
		var b := a + Vector3(rng.randf_range(-0.35, 0.35), 0.0, rng.randf_range(-0.35, 0.35))
		stick(a, b, 0.012, twig, d)
	# the fire: a ring of stones, split logs, embers; the smell he wakes up out of
	var fp := Vector3(-3.2, 0, -3.0)
	var stone := pbr("concrete", Vector3(1, 1, 1) / 0.6, true, Color(0.5, 0.48, 0.45))
	for k in 10:
		var a := TAU * k / 10.0
		sphere(0.16, fp + Vector3(cos(a) * 0.6, 0.08, sin(a) * 0.6), stone, 7, d).scale = Vector3(1.2, 0.7, 1.0)
	var log_m := pbr("bark", Vector3(1, 1, 1) / 0.8, true, Color(0.7, 0.6, 0.5))
	for k in 4:
		var a := TAU * k / 4.0 + 0.3
		stick(fp + Vector3(cos(a) * 0.45, 0.06, sin(a) * 0.45), fp + Vector3(cos(a) * 0.05, 0.32, sin(a) * 0.05), 0.06, log_m, d)
	sphere(0.22, fp + Vector3(0, 0.08, 0), glow(Color(1.0, 0.45, 0.12), 3.0), 8, d).scale = Vector3(1.4, 0.5, 1.4)
	fire_light = _omni(d, fp + Vector3(0, 0.6, 0), Color(1.0, 0.55, 0.25), 1.6, 7.0)
	# a split-rail fence along the first stretch, East Coast farm land
	var rail := pbr("woodfloor", Vector3(1, 1, 1) / 1.2, true, Color(0.55, 0.45, 0.35))
	for i in 9:
		var z := 6.0 - i * 3.0
		var x := _trail_x(z) + 2.2
		box(Vector3(0.1, 1.1, 0.1), Vector3(x, 0.55, z), rail, false, d)
		if i < 8:
			var z2 := z - 3.0
			stick(Vector3(x, 0.8, z), Vector3(_trail_x(z2) + 2.2, 0.8, z2), 0.04, rail, d)
			stick(Vector3(x, 0.45, z), Vector3(_trail_x(z2) + 2.2, 0.45, z2), 0.04, rail, d)
	# keep him on the trail: the wood closes in at x +-9
	solid_box(Vector3(0.4, 4, 110), Vector3(-9.5, 2, -35), d)
	solid_box(Vector3(0.4, 4, 110), Vector3(9.5, 2, -35), d)
	solid_box(Vector3(20, 4, 0.4), Vector3(0, 2, 8.5), d)
	solid_box(Vector3(20, 4, 0.4), Vector3(0, 2, -76), d)
	_omni(d, Vector3(0, 6, -20), Color(1.0, 0.85, 0.65), 0.8, 30.0)
	_batch(d, 20.0)
	# Monica, Mira and Ezra at the end of the trail, laughing
	var mon := figure(Color(0.55, 0.18, 0.28), Color(0.86, 0.68, 0.56), {"hair": Color(0.06, 0.05, 0.05), "long_hair": true, "legs": Color(0.12, 0.12, 0.14), "arms": true, "knees": true, "long_coat": true})
	var mi := figure(Color(0.85, 0.55, 0.2), Color(0.86, 0.68, 0.56), {"hair": Color(0.06, 0.05, 0.05), "long_hair": true, "legs": Color(0.25, 0.22, 0.3), "arms": true, "knees": true, "scale": 0.66, "long_coat": false})
	var ez := figure(Color(0.2, 0.45, 0.32), Color(0.86, 0.68, 0.56), {"hair": Color(0.35, 0.22, 0.12), "legs": Color(0.25, 0.28, 0.4), "arms": true, "knees": true, "scale": 0.7, "long_coat": false})
	var offs := [Vector3(0, 0, 0), Vector3(-0.9, 0, 0.3), Vector3(0.9, 0, 0.35)]
	var figs := [mon, mi, ez]
	for i in 3:
		var f: Node3D = figs[i]
		d.add_child(f)
		f.position = Vector3(_trail_x(fam_z), 0, fam_z) + offs[i]
		f.rotation.y = PI
		family.append([f, offs[i], float(i) * 1.7])
	# leaves falling round him wherever he walks
	leaves_fx = CPUParticles3D.new()
	leaves_fx.amount = 70
	leaves_fx.lifetime = 7.0
	leaves_fx.emission_shape = CPUParticles3D.EMISSION_SHAPE_BOX
	leaves_fx.emission_box_extents = Vector3(9, 0.5, 9)
	leaves_fx.direction = Vector3(0.3, -1, 0)
	leaves_fx.spread = 40.0
	leaves_fx.gravity = Vector3(0.2, -0.5, 0)
	leaves_fx.initial_velocity_min = 0.2
	leaves_fx.initial_velocity_max = 0.6
	leaves_fx.angular_velocity_min = -180.0
	leaves_fx.angular_velocity_max = 180.0
	leaves_fx.particle_flag_rotate_y = true
	var lq := QuadMesh.new()
	lq.size = Vector2(0.1, 0.07)
	var lm := StandardMaterial3D.new()
	lm.albedo_color = Color(0.9, 0.48, 0.12)
	lm.cull_mode = BaseMaterial3D.CULL_DISABLED
	lq.material = lm
	leaves_fx.mesh = lq
	leaves_fx.position = Vector3(0, 6, 0)
	d.add_child(leaves_fx)


## Pure white quilting: no colour in the cloth at all, just the weave's
## bumps from the fabric scan's normal map.
func _white_pad() -> StandardMaterial3D:
	if _mat_cache.has("whitepad"):
		return _mat_cache["whitepad"]
	var m := StandardMaterial3D.new()
	m.albedo_color = Color(0.93, 0.94, 0.93)
	m.roughness = 0.95
	m.normal_enabled = true
	m.normal_texture = load("res://assets/pbr/fabric/normal.jpg")
	m.normal_scale = 0.6
	m.uv1_scale = Vector3(2, 2, 2)
	m.uv1_triplanar = true
	m.uv1_world_triplanar = true
	_mat_cache["whitepad"] = m
	return m


func _trail_x(z: float) -> float:
	return sin(-z * 0.06) * 2.2


## A broadleaf in October: bark trunk, two limbs, a crown of red and gold
## blobs and a few cards of loose leaves round the edge.
func _autumn_tree(p: Vector3, h: float, bark: Material, leaf_m: Array, card_m: Material, parent: Node3D) -> void:
	cyl(0.22, 0.42, h, p + Vector3(0, h / 2.0, 0), bark, 8, parent)
	for k in 2:
		var a := rng.randf() * TAU
		var s := p + Vector3(0, h * 0.6, 0)
		stick(s, s + Vector3(cos(a) * 1.6, 1.2, sin(a) * 1.6), 0.09, bark, parent)
	for k in 4:
		var off := Vector3(rng.randf_range(-1.4, 1.4), h + rng.randf_range(-0.6, 1.0), rng.randf_range(-1.4, 1.4))
		sphere(rng.randf_range(1.3, 2.0), p + off, leaf_m[rng.randi() % leaf_m.size()], 7, parent)
	for k in 5:
		var off := Vector3(rng.randf_range(-2.0, 2.0), h + rng.randf_range(-1.0, 1.4), rng.randf_range(-2.0, 2.0))
		var q := quad(Vector2(2.6, 2.6) * rng.randf_range(0.8, 1.2), p + off, 0.0, card_m, parent)
		q.rotation = Vector3(rng.randf_range(-0.7, 0.7), rng.randf() * TAU, rng.randf_range(-0.5, 0.5))


func _autumn_card_mat() -> StandardMaterial3D:
	var img := Image.create(64, 64, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	var r := RandomNumberGenerator.new()
	r.seed = 17
	var cols := [Color(0.9, 0.5, 0.1), Color(0.75, 0.22, 0.08), Color(0.95, 0.75, 0.25), Color(0.6, 0.18, 0.06)]
	for i in 70:
		var cx := r.randi_range(4, 59)
		var cy := r.randi_range(4, 59)
		var c: Color = cols[i % 4]
		for yy in range(-3, 4):
			for xx in range(-2, 3):
				if absf(xx) + absf(yy) * 0.6 < 2.6:
					img.set_pixel(clampi(cx + xx, 0, 63), clampi(cy + yy, 0, 63), c)
	img.generate_mipmaps()
	var m := StandardMaterial3D.new()
	m.albedo_texture = ImageTexture.create_from_image(img)
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
	m.alpha_scissor_threshold = 0.5
	m.cull_mode = BaseMaterial3D.CULL_DISABLED
	m.roughness = 0.9
	return m


# ------------------------------------------------------------------ the cell (ch.17)

## Pure white. Quilted pads on every surface with a button at each seam, a
## light panel in the ceiling, a camera dot in each corner, a door with no
## handle on this side. Built round the origin.
func _cell() -> void:
	cell_root = Node3D.new()
	add_child(cell_root)
	var c := cell_root
	var shell := pbr("plaster", Vector3(1, 1, 1) / 2.0, true, Color(0.42, 0.43, 0.43))
	box(Vector3(4.6, 0.2, 4.6), Vector3(0, -0.1, 0), shell, true, c)
	box(Vector3(4.6, 0.2, 4.6), Vector3(0, 2.7, 0), shell, false, c)
	box(Vector3(0.2, 2.8, 4.6), Vector3(-2.2, 1.4, 0), shell, true, c)
	box(Vector3(0.2, 2.8, 4.6), Vector3(2.2, 1.4, 0), shell, true, c)
	box(Vector3(4.6, 2.8, 0.2), Vector3(0, 1.4, -2.2), shell, true, c)
	box(Vector3(1.8, 2.8, 0.2), Vector3(-1.4, 1.4, DOOR_Z), shell, true, c)
	box(Vector3(1.8, 2.8, 0.2), Vector3(1.4, 1.4, DOOR_Z), shell, true, c)
	box(Vector3(1.0, 0.65, 0.2), Vector3(0, 2.475, DOOR_Z), shell, true, c)
	# the pads: their own node so the walls can breathe during the session
	pads = Node3D.new()
	c.add_child(pads)
	var pad := _white_pad()
	var seam := mat(Color(0.78, 0.79, 0.78), 0.9)
	var button := mat(Color(0.86, 0.86, 0.85), 0.6)
	for wall in 4:
		for col in 8:
			var u := -1.75 + col * 0.5
			for row in 5:
				var y := 0.26 + row * 0.52
				if wall == 2 and absf(u) < 0.5 and y < 2.15:
					continue   # the door
				var pos: Vector3
				var sz: Vector3
				match wall:
					0:
						pos = Vector3(u, y, -2.05)
						sz = Vector3(0.47, 0.49, 0.1)
					1:
						pos = Vector3(2.05, y, u)
						sz = Vector3(0.1, 0.49, 0.47)
					2:
						pos = Vector3(u, y, 2.05)
						sz = Vector3(0.47, 0.49, 0.1)
					_:
						pos = Vector3(-2.05, y, u)
						sz = Vector3(0.1, 0.49, 0.47)
				box(sz, pos, pad, false, pads)
		# the buttons where four pads meet
		for col in 7:
			var u := -1.5 + col * 0.5
			for row in 4:
				var y := 0.52 + row * 0.52
				if wall == 2 and absf(u) < 0.6 and y < 2.2:
					continue
				var bp: Vector3
				match wall:
					0:
						bp = Vector3(u, y, -2.0)
					1:
						bp = Vector3(2.0, y, u)
					2:
						bp = Vector3(u, y, 2.0)
					_:
						bp = Vector3(-2.0, y, u)
				sphere(0.025, bp, button, 6, pads)
	for ix in 8:
		for iz in 8:
			box(Vector3(0.48, 0.07, 0.48), Vector3(-1.75 + ix * 0.5, 0.035, -1.75 + iz * 0.5), pad, false, pads)
	# floor seams and the ceiling pad, with the light panel in it
	for k in 9:
		box(Vector3(4.0, 0.075, 0.02), Vector3(0, 0.035, -2.0 + k * 0.5), seam, false, pads)
	box(Vector3(4.1, 0.06, 4.1), Vector3(0, 2.6, 0), pad, false, pads)
	box(Vector3(1.4, 0.03, 1.4), Vector3(0, 2.565, 0), glow(Color(1.0, 1.0, 0.97), 2.4), false, pads)
	_batch(pads, 10.0)
	# the camera dots, one per corner, each with a red pip
	var dot_m := mat(Color(0.02, 0.02, 0.025), 0.2, 0.4)
	for i in CORNERS.size():
		var p: Vector3 = CORNERS[i]
		sphere(0.05, p, dot_m, 10, c)
		var led := sphere(0.012, p + Vector3(-signf(p.x), -0.6, -signf(p.z)).normalized() * 0.045, glow(Color(1.0, 0.1, 0.08), 4.0), 6, c)
		cam_leds.append(led)
		interactable("camera_dot_%d" % i, "The camera dot", p, Vector3(0.25, 0.25, 0.25), LINES["look"]["cam_scan"] % (i + 1), false, c)
	# the door: white, padded inside, wired glass at head height, no handle
	door_body = StaticBody3D.new()
	door_body.position = Vector3(0, 1.075, DOOR_Z)
	var cs := CollisionShape3D.new()
	var bs := BoxShape3D.new()
	bs.size = Vector3(1.0, 2.15, 0.16)
	cs.shape = bs
	door_body.add_child(cs)
	c.add_child(door_body)
	box(Vector3(0.98, 2.13, 0.08), Vector3(0, 0, 0.04), mat(Color(0.86, 0.87, 0.86), 0.5, 0.2), false, door_body)
	# padded below the window only; the window itself framed in steel
	for row in 2:
		box(Vector3(0.46, 0.49, 0.08), Vector3(-0.24, -0.78 + row * 0.52, -0.08), pad, false, door_body)
		box(Vector3(0.46, 0.49, 0.08), Vector3(0.24, -0.78 + row * 0.52, -0.08), pad, false, door_body)
	box(Vector3(0.96, 0.06, 0.06), Vector3(0, 0.3, -0.06), mat(Color(0.7, 0.71, 0.72), 0.4, 0.6), false, door_body)
	for sx: float in [-0.13, 0.13]:
		box(Vector3(0.04, 0.4, 0.05), Vector3(sx, 0.55, -0.06), mat(Color(0.3, 0.31, 0.33), 0.4, 0.6), false, door_body)
	for sy: float in [0.35, 0.75]:
		box(Vector3(0.3, 0.04, 0.05), Vector3(0, sy, -0.06), mat(Color(0.3, 0.31, 0.33), 0.4, 0.6), false, door_body)
	var wire := StandardMaterial3D.new()
	wire.albedo_color = Color(0.5, 0.55, 0.58, 0.45)
	wire.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	wire.roughness = 0.1
	box(Vector3(0.22, 0.32, 0.2), Vector3(0, 0.55, 0.0), wire, false, door_body)
	label("04", Vector3(0, 0.95, 0.09), 0.0, 0.0016, Color(0.2, 0.2, 0.22), door_body, false)
	interactable("cell_door", "The door", Vector3(0, 1.1, 1.92), Vector3(1.0, 2.0, 0.2), LINES["look"]["pad_scan"], false, c)
	interactable("padding", "The padding", Vector3(-1.95, 1.2, -0.5), Vector3(0.15, 1.6, 2.0), LINES["look"]["pad_scan"], false, c)
	# scratched low in a seam where a man on the floor could reach it
	_glyph_on(Vector3(1.55, 0.36, -1.98), 0.0, 0.0022, "cell_glyph", false, false,
		"Scratched into the seam of the padding, low, where a man lying on the floor could reach: rings. Somebody had been here before me, and done it with a fingernail.")
	cell_light = _omni(c, Vector3(0, 2.2, 0), Color(1.0, 1.0, 0.97), 1.5, 7.5)
	cell_fill = _omni(c, Vector3(0, 0.6, 0.8), Color(0.92, 0.95, 1.0), 0.5, 5.0)


# ------------------------------------------------------------------ the hallway (ch.18)

## The floor with no number: grey carpet, plaster the colour of an old
## monitor, fluorescent panels, the doors of the other reconciliation suites,
## the FreudBot dock, the guard and the lifts at the east end.
func _hall() -> void:
	hall_root = Node3D.new()
	add_child(hall_root)
	var h := hall_root
	var carpet := pbr("carpet", Vector3(1, 1, 1) / 1.5, true, Color(0.42, 0.44, 0.46))
	var wall := pbr("plaster", Vector3(1, 1, 1) / 2.0, true, Color(0.62, 0.66, 0.64))
	var tile := pbr("plaster", Vector3(1, 1, 1) / 0.6, true, Color(0.74, 0.75, 0.74))
	var zc := (HALL_Z0 + HALL_Z1) / 2.0
	var zw := HALL_Z1 - HALL_Z0 + 0.2
	box(Vector3(HALL_X * 2.0, 0.2, zw), Vector3(0, -0.1, zc), carpet, true, h)
	box(Vector3(HALL_X * 2.0, 0.2, zw), Vector3(0, 3.3, zc), tile, false, h)
	# the north wall (the cells' side), with a hole for the window at x -5
	box(Vector3(HALL_X - 5.15, 3.2, 0.2), Vector3(-(HALL_X + 5.15) / 2.0, 1.6, DOOR_Z), wall, true, h)
	box(Vector3(2.55, 3.2, 0.2), Vector3(-3.575, 1.6, DOOR_Z), wall, true, h)
	box(Vector3(0.3, 1.35, 0.2), Vector3(-5.0, 0.675, DOOR_Z), wall, true, h)
	box(Vector3(0.3, 1.45, 0.2), Vector3(-5.0, 2.475, DOOR_Z), wall, true, h)
	box(Vector3(HALL_X - 2.3, 3.2, 0.2), Vector3((HALL_X + 2.3) / 2.0, 1.6, DOOR_Z), wall, true, h)
	box(Vector3(4.6, 0.4, 0.2), Vector3(0, 3.0, DOOR_Z), wall, false, h)
	# a skirting of brushed steel and a handrail, hospital-style
	var steel := mat(Color(0.55, 0.57, 0.6), 0.35, 0.8)
	for side: float in [-1.0, 1.0]:
		var x0 := 0.55 if side > 0.0 else -HALL_X
		var x1 := HALL_X if side > 0.0 else -0.55
		box(Vector3(x1 - x0, 0.1, 0.03), Vector3((x0 + x1) / 2.0, 0.05, HALL_Z0 + 0.015), steel, false, h)
		box(Vector3(x1 - x0, 0.05, 0.06), Vector3((x0 + x1) / 2.0, 0.95, HALL_Z0 + 0.06), steel, false, h)
	# the end walls
	box(Vector3(0.2, 3.2, zw), Vector3(-HALL_X, 1.6, zc), wall, true, h)
	box(Vector3(0.2, 3.2, zw), Vector3(HALL_X, 1.6, zc), mat(Color(0.3, 0.31, 0.33), 0.5, 0.4), true, h)
	# the south wall: solid at the ends, glass onto the office between
	box(Vector3(HALL_X - 10.0, 3.2, 0.2), Vector3(-(HALL_X + 10.0) / 2.0, 1.6, HALL_Z1), wall, true, h)
	box(Vector3(HALL_X - 12.0, 3.2, 0.2), Vector3((HALL_X + 12.0) / 2.0, 1.6, HALL_Z1), wall, true, h)
	var glass := StandardMaterial3D.new()
	glass.albedo_color = Color(0.2, 0.3, 0.3, 0.12)
	glass.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	glass.roughness = 0.05
	glass.metallic = 0.6
	box(Vector3(22.0, 3.2, 0.04), Vector3(1.0, 1.6, HALL_Z1), glass, true, h)
	no_batch.append(h.get_child(h.get_child_count() - 2))
	var mull := mat(Color(0.18, 0.19, 0.2), 0.4, 0.7)
	for i in 12:
		box(Vector3(0.06, 3.2, 0.1), Vector3(-10.0 + i * 2.0, 1.6, HALL_Z1), mull, false, h)
	# a frosted band across the glass with the company line etched in it
	var frost := StandardMaterial3D.new()
	frost.albedo_color = Color(0.85, 0.9, 0.9, 0.35)
	frost.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	box(Vector3(22.0, 0.35, 0.05), Vector3(1.0, 1.3, HALL_Z1 - 0.01), frost, false, h)
	label("RECONCILIATION IS A PROCESS  ·  PSYONIC CARES", Vector3(1.0, 1.3, HALL_Z1 - 0.05), PI, 0.0022, Color(0.3, 0.42, 0.4), h, false)
	# the ceiling panels: half of them dead, one stuttering
	for i in 13:
		var x := -18.0 + i * 3.0
		var dead := i % 3 == 1
		box(Vector3(1.2, 0.04, 0.5), Vector3(x, 3.18, zc), glow(Color(0.85, 0.95, 1.0), 0.05 if dead else 1.4), false, h)
	for x: float in [-16.0, -10.0, -4.0, 3.0, 9.0, 15.0]:
		var l := _omni(h, Vector3(x, 2.8, zc), Color(0.78, 0.9, 1.0), 0.75, 6.5)
		if x == -10.0:
			flickers.append(l)
	# the other suites' doors: blacked-out glass, IN SESSION
	var door_m := mat(Color(0.82, 0.83, 0.82), 0.5, 0.2)
	var black_glass := mat(Color(0.02, 0.02, 0.025), 0.1, 0.5)
	var n := 1
	for x: float in [-14.0, -9.0, 5.0, 9.5, 14.0]:
		box(Vector3(1.0, 2.15, 0.06), Vector3(x, 1.075, HALL_Z0 + 0.03), door_m, false, h)
		box(Vector3(0.22, 0.32, 0.02), Vector3(x, 1.63, HALL_Z0 + 0.07), black_glass, false, h)
		box(Vector3(0.3, 0.07, 0.03), Vector3(x, 2.32, HALL_Z0 + 0.06), glow(Color(1.0, 0.12, 0.08), 2.2), false, h)
		label("RECONCILIATION 0%d" % (n if n < 3 else n + 2), Vector3(x + 0.75, 1.55, HALL_Z0 + 0.02), 0.0, 0.0012, Color(0.25, 0.26, 0.28), h, false)
		interactable("suite_%d" % n, "The door", Vector3(x, 1.2, HALL_Z0 + 0.2), Vector3(1.0, 2.0, 0.3), "", false, h).set_meta("suite", n if n < 3 else n + 2)
		n += 1
	# our door's plate, and the neighbour's door with its wired window
	label("RECONCILIATION 04", Vector3(0.78, 1.55, HALL_Z0 + 0.02), 0.0, 0.0012, Color(0.25, 0.26, 0.28), h, false)
	box(Vector3(1.0, 2.15, 0.06), Vector3(-5.0, 1.075, HALL_Z0 + 0.03), door_m, false, h)
	label("RECONCILIATION 03", Vector3(-4.22, 1.55, HALL_Z0 + 0.02), 0.0, 0.0012, Color(0.25, 0.26, 0.28), h, false)
	box(Vector3(0.3, 0.07, 0.03), Vector3(-5.0, 2.32, HALL_Z0 + 0.06), glow(Color(1.0, 0.12, 0.08), 2.2), false, h)
	var wire := StandardMaterial3D.new()
	wire.albedo_color = Color(0.6, 0.65, 0.68, 0.3)
	wire.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	box(Vector3(0.3, 0.4, 0.02), Vector3(-5.0, 1.55, HALL_Z0 + 0.065), wire, false, h)
	no_batch.append(h.get_child(h.get_child_count() - 1))
	interactable("neighbour", "Look through the glass", Vector3(-5.0, 1.55, HALL_Z0 + 0.25), Vector3(0.8, 0.8, 0.3), LINES["look"]["neighbour_scan"], false, h)
	_neighbour()
	# the west end: the alarmed stair (sneak) and the vent (sneak)
	box(Vector3(0.06, 2.2, 1.1), Vector3(-HALL_X + 0.13, 1.1, zc), mat(Color(0.55, 0.12, 0.1), 0.6, 0.3), false, h)
	box(Vector3(0.08, 0.05, 0.9), Vector3(-HALL_X + 0.2, 1.05, zc), steel, false, h)
	label("STAIRS  ·  ALARMED", Vector3(-HALL_X + 0.14, 2.45, zc), -PI / 2.0, 0.0018, Color(0.95, 0.9, 0.85), h, false)
	box(Vector3(0.05, 0.12, 0.3), Vector3(-HALL_X + 0.15, 2.65, zc), glow(PSYON_GREEN, 2.0), false, h)
	interactable("stairs", "The stair door", Vector3(-HALL_X + 0.3, 1.1, zc), Vector3(0.3, 2.2, 1.1), LINES["look"]["stairs_scan"], false, h).set_meta("route", "sneak")
	var grille := mat(Color(0.3, 0.31, 0.32), 0.5, 0.6)
	box(Vector3(0.8, 0.03, 0.8), Vector3(-11.5, 3.18, zc), mat(Color(0.05, 0.05, 0.05)), false, h)
	for k in 7:
		box(Vector3(0.8, 0.05, 0.03), Vector3(-11.5, 3.16, zc - 0.36 + k * 0.12), grille, false, h)
	interactable("vent", "The ceiling grille", Vector3(-11.5, 3.0, zc), Vector3(0.9, 0.3, 0.9), LINES["look"]["vent_scan"], false, h).set_meta("route", "sneak")
	prop("fuse_panel", Vector3(-17.5, 1.2, HALL_Z1 - 0.12), PI, 1.0, false, h)
	# the FreudBot dock: three units nose to the wall, charging
	label("FREUDBOT  ·  SESSION FLEET  ·  DOCK B", Vector3(-15.0, 2.55, HALL_Z1 - 0.12), PI, 0.0018, Color(0.5, 0.75, 0.9), h, false)
	for i in 3:
		var u := _fb_unit(h, false)
		u.position = Vector3(-17.0 + i * 1.6, 0, HALL_Z1 - 0.75)
		u.rotation.y = PI
		stick(Vector3(-17.0 + i * 1.6, 0.2, HALL_Z1 - 0.3), Vector3(-17.0 + i * 1.6, 0.4, HALL_Z1 - 0.12), 0.012, mat(Color(0.05, 0.05, 0.05)), h)
		box(Vector3(0.25, 0.12, 0.04), Vector3(-17.0 + i * 1.6, 0.4, HALL_Z1 - 0.12), glow(Color(0.2, 0.6, 1.0), 1.4), false, h)
	interactable("dock", "The FreudBot dock", Vector3(-15.4, 0.9, HALL_Z1 - 0.8), Vector3(4.8, 1.8, 0.8), LINES["look"]["dock_scan"], false, h)
	# dead smart tech on the walls
	box(Vector3(0.3, 0.2, 0.03), Vector3(-7.0, 1.45, HALL_Z0 + 0.03), mat(Color(0.08, 0.09, 0.1), 0.3), false, h)
	label("21°C  CALM", Vector3(-7.0, 1.45, HALL_Z0 + 0.05), 0.0, 0.0009, Color(0.9, 0.75, 0.3), h, false)
	interactable("thermo", "The climate panel", Vector3(-7.0, 1.45, HALL_Z0 + 0.15), Vector3(0.4, 0.3, 0.2), LINES["look"]["thermo_scan"], false, h)
	var white := mat(Color(0.88, 0.89, 0.9), 0.4)
	box(Vector3(0.4, 1.1, 0.35), Vector3(12.8, 0.55, HALL_Z1 - 0.3), white, true, h)
	cyl(0.14, 0.14, 0.4, Vector3(12.8, 1.3, HALL_Z1 - 0.3), mat(Color(0.5, 0.6, 0.65, 1.0), 0.1), 10, h)
	box(Vector3(0.22, 0.14, 0.02), Vector3(12.8, 0.85, HALL_Z1 - 0.48), mat(Color(0.02, 0.02, 0.025), 0.2), false, h)
	interactable("water", "The hydration station", Vector3(12.8, 0.9, HALL_Z1 - 0.4), Vector3(0.5, 1.6, 0.5), LINES["look"]["water_scan"], false, h)
	# a screen by the lifts for the people waiting: Psyon, and its eye
	box(Vector3(1.8, 1.0, 0.06), Vector3(15.0, 1.75, HALL_Z1 - 0.13), mat(Color(0.01, 0.012, 0.015), 0.15, 0.3), false, h)
	var sl := Node3D.new()
	sl.position = Vector3(15.0, 1.75, HALL_Z1 - 0.17)
	h.add_child(sl)
	label("PSYON", Vector3(0, 0.15, 0), PI, 0.003, PSYON_GREEN, sl)
	label("reconciliation is a process", Vector3(0, -0.17, 0), PI, 0.0012, Color(0.6, 0.9, 0.7), sl)
	var heye := Sprite3D.new()
	heye.texture = _glyph_tex
	heye.pixel_size = 0.0032
	heye.modulate = PSYON_GREEN
	heye.position = Vector3(15.0, 1.75, HALL_Z1 - 0.18)
	heye.rotation.y = PI
	heye.visible = false
	h.add_child(heye)
	eye_screens.append([sl, heye])
	_omni(h, Vector3(15.0, 1.7, HALL_Z1 - 0.8), Color(0.3, 1.0, 0.5), 0.35, 3.5)
	_lifts()
	_hall_cameras()
	_batch(h, 12.0, true)


## Suite 03, through the wire glass: a white room like his, a man on his
## knees on the padding with his forehead down, a FreudBot with a dark screen.
func _neighbour() -> void:
	var h := hall_root
	var white := _white_pad()
	box(Vector3(4.0, 0.1, 4.0), Vector3(-5.0, 0.05, 0.0), white, false, h)
	box(Vector3(4.0, 2.6, 0.1), Vector3(-5.0, 1.3, -2.0), white, false, h)
	box(Vector3(0.1, 2.6, 4.0), Vector3(-3.0, 1.3, 0.0), white, false, h)
	box(Vector3(0.1, 2.6, 4.0), Vector3(-7.0, 1.3, 0.0), white, false, h)
	box(Vector3(4.0, 0.1, 4.0), Vector3(-5.0, 2.65, 0.0), white, false, h)
	box(Vector3(1.0, 0.03, 1.0), Vector3(-5.0, 2.59, 0.0), glow(Color(1.0, 1.0, 0.97), 2.0), false, h)
	_omni(h, Vector3(-5.0, 2.0, 0.2), Color(1.0, 1.0, 0.97), 1.0, 5.0)
	var man := figure(Color(0.75, 0.78, 0.8), Color(0.78, 0.62, 0.52), {"hair": Color(0.25, 0.2, 0.15), "legs": Color(0.75, 0.78, 0.8), "arms": true, "knees": true, "long_coat": false})
	h.add_child(man)
	man.position = Vector3(-5.0, -0.42, 0.2)
	man.rotation.y = 0.0
	Anim.crouch(man)
	(man.get_meta("body") as Node3D).rotation.x = 1.2
	for a in man.get_meta("arms"):
		(a as Node3D).rotation.x = 1.9
	var u := _fb_unit(h, false)
	u.position = Vector3(-5.0, 0.0, -1.2)


func _lifts() -> void:
	var h := hall_root
	var steel := mat(Color(0.62, 0.64, 0.66), 0.25, 0.9)
	var frame := mat(Color(0.2, 0.21, 0.22), 0.4, 0.7)
	for z: float in [3.1, 4.75]:
		box(Vector3(0.12, 2.5, 1.3), Vector3(HALL_X - 0.08, 1.25, z), frame, false, h)
		for s: float in [-1.0, 1.0]:
			var leaf := box(Vector3(0.05, 2.3, 0.54), Vector3(HALL_X - 0.16, 1.15, z + s * 0.275), steel, false, h)
			lift_doors.append([leaf, z + s * 0.275, s])
			no_batch.append(leaf)
		var ind := label("--", Vector3(HALL_X - 0.16, 2.65, z), -PI / 2.0, 0.003, Color(1.0, 0.6, 0.15), h)
		if lift_label == null:
			lift_label = ind
	# the call panel and the badge reader between the doors
	box(Vector3(0.05, 0.4, 0.18), Vector3(HALL_X - 0.12, 1.15, 3.92), frame, false, h)
	sphere(0.035, Vector3(HALL_X - 0.15, 1.2, 3.92), glow(Color(0.9, 0.95, 1.0), 1.5), 8, h)
	var btn := interactable("lift", "Call the lift", Vector3(HALL_X - 0.3, 1.2, 3.92), Vector3(0.3, 0.5, 0.4), "", false, h)
	btn.set_meta("exit", true)
	btn.set_meta("route", "badge")
	box(Vector3(0.05, 0.16, 0.1), Vector3(HALL_X - 0.12, 1.5, 3.92), mat(Color(0.05, 0.05, 0.06), 0.3), false, h)
	box(Vector3(0.03, 0.03, 0.06), Vector3(HALL_X - 0.15, 1.56, 3.92), glow(PSYON_GREEN, 2.0), false, h)
	var rd := interactable("reader", "The badge reader", Vector3(HALL_X - 0.3, 1.5, 3.92), Vector3(0.3, 0.25, 0.3), LINES["look"]["reader_scan"], false, h)
	rd.set_meta("hackable", true)
	rd.set_meta("route", "hack")
	# the floor directory: 85, 86, a line with no number, 87, 88
	box(Vector3(1.0, 1.3, 0.03), Vector3(16.6, 1.6, HALL_Z0 + 0.02), mat(Color(0.1, 0.11, 0.12), 0.3, 0.5), false, h)
	var txt := "88  OPERATIONS\n87  LEGAL\n--  RECONCILIATION\n86  HUMAN-AI INTEGRATIONS\n85  SALTECH LIAISON"
	var dl := label(txt, Vector3(16.6, 1.6, HALL_Z0 + 0.04), 0.0, 0.0011, Color(0.85, 0.88, 0.9), h, false)
	dl.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	interactable("directory", "The floor directory", Vector3(16.6, 1.6, HALL_Z0 + 0.2), Vector3(1.0, 1.3, 0.2), LINES["look"]["directory_scan"], false, h)
	_omni(h, Vector3(18.5, 2.6, 3.9), Color(1.0, 0.85, 0.7), 0.8, 5.0)


## Three dome cameras that follow Carl down the corridor, a half second late.
func _hall_cameras() -> void:
	var h := hall_root
	var i := 1
	for p: Vector3 in [Vector3(-12.0, 2.86, HALL_Z1 - 0.3), Vector3(4.0, 2.86, HALL_Z0 + 0.3), Vector3(16.0, 2.86, HALL_Z1 - 0.3)]:
		var pivot := Node3D.new()
		pivot.position = p
		h.add_child(pivot)
		var cam := prop("security_camera_01", Vector3.ZERO, 0.0, 1.0, false, pivot)
		if cam == null:
			box(Vector3(0.12, 0.1, 0.4), Vector3(0, 0.1, 0), mat(Color(0.85, 0.85, 0.86), 0.4), false, pivot)
		stick(p + Vector3(0, 0.2, 0), p + Vector3(0, 0.36, 0), 0.02, mat(Color(0.2, 0.2, 0.22), 0.5, 0.6), h)
		var led := sphere(0.015, Vector3(0, 0.12, -0.31), glow(Color(1.0, 0.1, 0.08), 4.0), 6, pivot)
		blinkers.append(led)
		hall_cams.append(pivot)
		var it := interactable("hall_cam_%d" % i, "The camera", p + Vector3(0, 0.1, 0), Vector3(0.4, 0.4, 0.4), LINES["look"]["hc_cam_scan"] % i, false, h)
		it.set_meta("camera", true)
		it.set_meta("hackable", true)
		i += 1


# ------------------------------------------------------------------ the dead office

## Behind the glass: open plan, nobody in it, every surface a screen and
## every screen off, except the back wall, where Psyon says good morning and,
## for a frame at a time, opens its eye.
func _office() -> void:
	var o := Node3D.new()
	add_child(o)
	var carpet := pbr("carpet", Vector3(1, 1, 1) / 1.5, true, Color(0.34, 0.36, 0.38))
	var wall := pbr("plaster", Vector3(1, 1, 1) / 2.0, true, Color(0.55, 0.58, 0.57))
	box(Vector3(22, 0.2, 7.7), Vector3(1.0, -0.1, 9.25), carpet, true, o)
	box(Vector3(22, 0.2, 7.7), Vector3(1.0, 3.3, 9.25), pbr("plaster", Vector3(1, 1, 1) / 0.6, true, Color(0.6, 0.62, 0.62)), false, o)
	box(Vector3(22, 3.2, 0.2), Vector3(1.0, 1.6, 13.1), wall, true, o)
	box(Vector3(0.2, 3.2, 7.7), Vector3(-10.0, 1.6, 9.25), wall, true, o)
	box(Vector3(0.2, 3.2, 7.7), Vector3(12.0, 1.6, 9.25), wall, true, o)
	# the screens on the back wall
	var black := mat(Color(0.01, 0.012, 0.015), 0.15, 0.3)
	for i in 5:
		var x := -7.5 + i * 4.0
		box(Vector3(2.4, 1.36, 0.08), Vector3(x, 1.85, 12.95), black, false, o)
		var slogan := Node3D.new()
		slogan.position = Vector3(x, 1.85, 12.9)
		o.add_child(slogan)
		label("PSYON", Vector3(0, 0.18, 0), PI, 0.004, PSYON_GREEN, slogan)
		label("the pillow for those who dream", Vector3(0, -0.22, 0), PI, 0.0016, Color(0.6, 0.9, 0.7), slogan)
		var eye := Sprite3D.new()
		eye.texture = _glyph_tex
		eye.pixel_size = 0.0042
		eye.modulate = PSYON_GREEN
		eye.position = Vector3(x, 1.85, 12.89)
		eye.rotation.y = PI
		eye.visible = false
		o.add_child(eye)
		eye_screens.append([slogan, eye])
		if i % 2 == 0:
			_omni(o, Vector3(x, 1.8, 12.0), Color(0.3, 1.0, 0.5), 0.5, 4.5)
	interactable("screens", "The screens", Vector3(0.5, 1.85, 12.7), Vector3(18.0, 1.4, 0.3), LINES["look"]["screens_scan"], false, o)
	# desks: smart tops gone dark, a coffee ring, chairs pushed in as if for inspection
	var top := mat(Color(0.03, 0.035, 0.04), 0.12, 0.4)
	var chair := pbr("fabric", Vector3(1, 1, 1) / 0.5, true, Color(0.25, 0.27, 0.3))
	var leg := mat(Color(0.2, 0.2, 0.22), 0.4, 0.8)
	var k := 0
	for row in 2:
		for col in 4:
			var p := Vector3(-7.0 + col * 4.5, 0, 7.6 + row * 2.8)
			prop("metal_office_desk", p, 0.0, 1.0, true, o)
			box(Vector3(1.3, 0.02, 0.65), p + Vector3(0, 0.77, 0), top, false, o)
			box(Vector3(0.6, 0.36, 0.03), p + Vector3(0, 1.1, 0.22), top, false, o)
			box(Vector3(0.05, 0.25, 0.05), p + Vector3(0, 0.88, 0.25), leg, false, o)
			box(Vector3(0.48, 0.08, 0.48), p + Vector3(0, 0.46, -0.7), chair, false, o)
			box(Vector3(0.48, 0.55, 0.07), p + Vector3(0, 0.8, -0.95), chair, false, o)
			cyl(0.03, 0.03, 0.4, p + Vector3(0, 0.22, -0.7), leg, 6, o)
			if k == 2:
				cyl(0.045, 0.045, 0.005, p + Vector3(0.3, 0.785, -0.1), mat(Color(0.2, 0.13, 0.08), 0.6), 12, o)
				interactable("desk", "The smart desk", p + Vector3(0, 0.8, 0), Vector3(1.4, 0.3, 0.7), LINES["look"]["desk_scan"], false, o)
			k += 1
	# the concierge pillar and a planter of something that was alive at onboarding
	cyl(0.25, 0.3, 1.3, Vector3(9.5, 0.65, 7.0), mat(Color(0.86, 0.87, 0.88), 0.3), 16, o)
	cyl(0.26, 0.26, 0.04, Vector3(9.5, 1.22, 7.0), mat(Color(0.15, 0.18, 0.2), 0.2, 0.6), 16, o)
	label("ASK ORA", Vector3(9.5, 0.95, 6.73), 0.0, 0.0016, Color(0.4, 0.45, 0.5), o, false)
	interactable("pillar", "The concierge pillar", Vector3(9.5, 0.8, 7.0), Vector3(0.7, 1.4, 0.7), LINES["look"]["pillar_scan"], false, o)
	box(Vector3(0.9, 0.6, 0.9), Vector3(-8.6, 0.3, 6.6), mat(Color(0.9, 0.9, 0.9), 0.3), true, o)
	var dead := mat(Color(0.35, 0.28, 0.16), 0.9)
	for i in 6:
		var a := TAU * i / 6.0
		stick(Vector3(-8.6, 0.6, 6.6), Vector3(-8.6 + cos(a) * 0.35, 1.2 + (i % 2) * 0.2, 6.6 + sin(a) * 0.35), 0.015, dead, o)
	prop("server_rack", Vector3(10.6, 0, 12.3), PI, 1.0, true, o)
	box(Vector3(0.05, 0.05, 0.05), Vector3(10.4, 1.6, 11.9), glow(Color(0.2, 1.0, 0.4), 3.0), false, o)
	# the blinds on the windows: locked, no city, no morning
	box(Vector3(0.05, 2.4, 6.0), Vector3(11.88, 1.5, 9.3), mat(Color(0.75, 0.77, 0.78), 0.6), false, o)
	for i in 30:
		box(Vector3(0.06, 0.02, 6.0), Vector3(11.85, 0.35 + i * 0.08, 9.3), mat(Color(0.62, 0.64, 0.65), 0.5), false, o)
	interactable("blinds", "The blinds", Vector3(11.7, 1.5, 9.3), Vector3(0.2, 2.4, 6.0), LINES["look"]["blinds_scan"], false, o)
	_batch(o, 10.0, true)


# ------------------------------------------------------------------ the subway (ch.18 end)

## The contractors' line: a lit tube in a dark tunnel, ads that talk, three
## commuters lit by their own frames. Hidden until the ride.
func _subway() -> void:
	sub_root = Node3D.new()
	sub_root.position = SUBWAY
	add_child(sub_root)
	var s := sub_root
	var floor_m := pbr("concrete", Vector3(1, 1, 1) / 1.0, true, Color(0.35, 0.36, 0.38))
	var shell := mat(Color(0.7, 0.72, 0.74), 0.4, 0.3)
	box(Vector3(2.9, 0.2, 14), Vector3(0, -0.1, 0), floor_m, true, s)
	box(Vector3(2.9, 0.2, 14), Vector3(0, 2.45, 0), shell, false, s)
	box(Vector3(2.0, 0.04, 13), Vector3(0, 2.33, 0), glow(Color(0.85, 0.95, 1.0), 1.8), false, s)
	var win := StandardMaterial3D.new()
	win.albedo_color = Color(0.02, 0.03, 0.04, 0.35)
	win.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	win.roughness = 0.2
	for side: float in [-1.0, 1.0]:
		box(Vector3(0.1, 0.9, 14), Vector3(side * 1.45, 0.45, 0), shell, true, s)
		box(Vector3(0.1, 0.5, 14), Vector3(side * 1.45, 2.15, 0), shell, false, s)
		box(Vector3(0.04, 1.0, 14), Vector3(side * 1.47, 1.4, 0), win, false, s)
		var seat := pbr("fabric", Vector3(1, 1, 1) / 0.5, true, Color(0.2, 0.25, 0.5))
		box(Vector3(0.5, 0.12, 12), Vector3(side * 1.15, 0.45, 0), seat, false, s)
		box(Vector3(0.1, 0.5, 12), Vector3(side * 1.38, 0.75, 0), seat, false, s)
	# the tunnel walls outside: wet concrete, cable trays
	var tun := pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.22, 0.22, 0.24))
	for side: float in [-1.0, 1.0]:
		box(Vector3(0.3, 4.0, 40), Vector3(side * 2.6, 1.6, 0), tun, false, s)
		box(Vector3(0.15, 0.08, 40), Vector3(side * 2.4, 2.3, 0), mat(Color(0.12, 0.12, 0.13), 0.6, 0.5), false, s)
	box(Vector3(5.5, 0.3, 40), Vector3(0, 3.3, 0), tun, false, s)
	box(Vector3(2.9, 2.6, 0.1), Vector3(0, 1.3, -7.0), shell, true, s)
	box(Vector3(2.9, 2.6, 0.1), Vector3(0, 1.3, 7.0), shell, true, s)
	var pole := mat(Color(0.8, 0.8, 0.82), 0.2, 0.9)
	for z: float in [-4.0, 0.0, 4.0]:
		cyl(0.025, 0.025, 2.3, Vector3(0, 1.15, z), pole, 8, s)
	# the ads above the windows
	var ads := ["ad1", "ad2", "ad3"]
	for i in 3:
		var z := -4.5 + i * 4.5
		var a: Array = LINES["subway"][ads[i]]
		box(Vector3(0.04, 0.4, 1.4), Vector3(-1.42, 2.1, z), mat(Color(0.02, 0.03, 0.04)), false, s)
		label(str(a[0]), Vector3(-1.39, 2.17, z), PI / 2.0, 0.0018, Color(0.5, 0.85, 1.0) if i != 1 else PSYON_GREEN, s)
		label(str(a[1]), Vector3(-1.39, 2.02, z), PI / 2.0, 0.001, Color(0.8, 0.85, 0.9), s)
	var eye := Sprite3D.new()
	eye.texture = _glyph_tex
	eye.pixel_size = 0.0018
	eye.modulate = PSYON_GREEN
	eye.position = Vector3(1.39, 2.1, -2.0)
	eye.rotation.y = -PI / 2.0
	s.add_child(eye)
	_omni(s, Vector3(0, 2.0, -3.0), Color(0.85, 0.95, 1.0), 1.0, 6.0)
	_omni(s, Vector3(0, 2.0, 3.0), Color(0.85, 0.95, 1.0), 1.0, 6.0)
	_batch(s, 7.0)
	# the tunnel outside: lights that stream past
	for i in 10:
		var l := box(Vector3(0.05, 0.08, 0.7), Vector3(-2.42, 1.5, -12.0 + i * 2.6), glow(Color(1.0, 0.75, 0.4), 3.0), false, s)
		tunnel_lights.append(l)
		var r := box(Vector3(0.05, 0.08, 0.7), Vector3(2.42, 1.5, -12.0 + i * 2.6 + 1.3), glow(Color(1.0, 0.75, 0.4), 3.0), false, s)
		tunnel_lights.append(r)
	# commuters: contractors, frames on, faces in the glow
	var coats := [Color(0.3, 0.32, 0.28), Color(0.45, 0.4, 0.36), Color(0.22, 0.24, 0.3)]
	var spots := [Vector3(1.15, 0, -3.2), Vector3(1.15, 0, 1.4), Vector3(-1.15, 0, 3.6)]
	for i in 3:
		var c := figure(coats[i], Color(0.78, 0.62, 0.5), {"visor": true, "arms": true, "knees": true, "long_hair": i == 1, "long_coat": false})
		s.add_child(c)
		var sp: Vector3 = spots[i]
		c.position = sp + Vector3(0, -0.02, 0)
		c.rotation.y = PI / 2.0 if sp.x > 0.0 else -PI / 2.0
		Anim.sit(c, 0.15)
		(c.get_meta("head") as Node3D).rotation.x = 0.35
		person("commuter_%d" % i, "A commuter", c, LINES["subway"]["commuter_scan"])
		commuters.append(c)


# ------------------------------------------------------------------ people

func _people() -> void:
	# Turan: grey hair, the magenta Ora frames, a suit with no give in it
	turan = figure(Color(0.16, 0.16, 0.19), Color(0.8, 0.66, 0.56), {"hair": Color(0.55, 0.55, 0.56), "legs": Color(0.14, 0.14, 0.16), "visor": true, "arms": true, "knees": true, "long_coat": false})
	add_child(turan)
	var v: MeshInstance3D = turan.get_meta("visor")
	if v:
		v.material_override = glow(Color(1.0, 0.2, 0.75), 0.9)
	turan.position = Vector3(1.5, 0, 4.0)
	turan.visible = false
	turan_it = person("turan", "Turan", turan, LINES["look"]["turan_scan"])
	set_active(turan_it, false)
	# the tablet she brings, with the thumb pad
	tablet = Node3D.new()
	add_child(tablet)
	box(Vector3(0.26, 0.012, 0.19), Vector3.ZERO, mat(Color(0.08, 0.08, 0.09), 0.3, 0.5), false, tablet)
	box(Vector3(0.23, 0.002, 0.15), Vector3(0, 0.007, 0), glow(Color(0.5, 0.8, 0.6), 0.9), false, tablet)
	tablet_glow = newglow(Color(0.2, 0.9, 1.0), 1.2)
	var pad := box(Vector3(0.05, 0.003, 0.05), Vector3(0.08, 0.009, 0.04), tablet_glow, false, tablet)
	no_batch.append(pad)
	label("PIP-7781", Vector3(-0.03, 0.009, -0.04), 0.0, 0.00035, Color(0.1, 0.2, 0.15), tablet, false).rotation.x = -PI / 2.0
	tablet.visible = false
	tablet_it = interactable("tablet", LINES["look"]["tablet_prompt"], Vector3(0, 0.05, 0), Vector3(0.45, 0.3, 0.4), LINES["look"]["tablet_scan"], false, tablet)
	set_active(tablet_it, false)
	# the nurse: SalTech contract, pale teal, a lanyard
	nurse = figure(Color(0.45, 0.68, 0.66), Color(0.7, 0.55, 0.45), {"hair": Color(0.1, 0.08, 0.06), "long_hair": true, "legs": Color(0.45, 0.68, 0.66), "arms": true, "knees": true, "long_coat": false})
	add_child(nurse)
	nurse.position = Vector3(-3.0, 0, 4.0)
	nurse.visible = false
	nurse_it = person("nurse", "The nurse", nurse, LINES["look"]["nurse_scan"])
	set_active(nurse_it, false)
	# Monica, waiting outside; the PR blazer in blood red
	monica = figure(Color(0.55, 0.06, 0.1), Color(0.86, 0.68, 0.56), {"hair": Color(0.06, 0.05, 0.05), "long_hair": true, "legs": Color(0.12, 0.12, 0.14), "arms": true, "knees": true, "long_coat": false})
	add_child(monica)
	monica.position = Vector3(0.9, 0, 3.9)
	monica.rotation.y = deg_to_rad(20.0)
	monica.visible = false
	monica_it = person("monica", "Monica", monica, LINES["look"]["monica_scan"])
	set_active(monica_it, false)
	# the guard at the lifts: company security, visor down (a person route, later)
	guard = figure(Color(0.05, 0.07, 0.12), Color(0.7, 0.58, 0.5), {"hair": Color(0.06, 0.06, 0.07), "legs": Color(0.05, 0.06, 0.1), "visor": true, "arms": true, "knees": true, "scale": 1.04, "long_coat": false})
	add_child(guard)
	guard.position = Vector3(17.8, 0, 5.0)
	guard.rotation.y = PI / 2.0
	guard.set_meta("guard", true)
	guard.set_meta("route", "person")
	person("guard", "The guard", guard, LINES["look"]["guard_scan"])


# ------------------------------------------------------------------ FreudBot

## "A big TV strapped to an old RC car." A unit facing -Z: a toy-red chassis
## on knobbed tyres, an antenna, two struts and the screen lashed to them
## with ratchet straps. `live` adds the screen's face and the lie readout.
func _fb_unit(parent: Node3D, live: bool) -> Node3D:
	var u := Node3D.new()
	parent.add_child(u)
	var red := mat(Color(0.62, 0.08, 0.06), 0.3, 0.2)
	var tyre := mat(Color(0.05, 0.05, 0.05), 0.95)
	var metal := mat(Color(0.4, 0.4, 0.42), 0.35, 0.8)
	box(Vector3(0.46, 0.12, 0.66), Vector3(0, 0.17, 0), red, false, u)
	box(Vector3(0.36, 0.07, 0.3), Vector3(0, 0.26, 0.1), mat(Color(0.08, 0.08, 0.09), 0.4), false, u)
	box(Vector3(0.5, 0.03, 0.12), Vector3(0, 0.14, -0.36), mat(Color(0.12, 0.12, 0.12), 0.5), false, u)
	label("SALTECH", Vector3(0, 0.19, -0.335), 0.0, 0.0007, Color(0.95, 0.9, 0.85), u, false).rotation.y = PI
	var wheels := []
	for sx: float in [-0.27, 0.27]:
		for sz: float in [-0.22, 0.22]:
			var w := Node3D.new()
			w.position = Vector3(sx, 0.11, sz)
			u.add_child(w)
			var t := cyl(0.11, 0.11, 0.1, Vector3.ZERO, tyre, 10, w)
			t.rotation.z = PI / 2.0
			var hub := cyl(0.05, 0.05, 0.105, Vector3.ZERO, metal, 8, w)
			hub.rotation.z = PI / 2.0
			wheels.append(w)
	stick(Vector3(0.18, 0.25, 0.28), Vector3(0.22, 0.85, 0.34), 0.006, metal, u)
	sphere(0.015, Vector3(0.22, 0.86, 0.34), red, 6, u)
	for sx: float in [-0.14, 0.14]:
		box(Vector3(0.04, 0.95, 0.04), Vector3(sx, 0.7, 0.05), metal, false, u)
	# the TV: bezel, back, and the strap round it
	var tv := Node3D.new()
	tv.position = Vector3(0, 1.32, 0.0)
	u.add_child(tv)
	box(Vector3(0.92, 0.6, 0.08), Vector3.ZERO, mat(Color(0.06, 0.06, 0.07), 0.3, 0.3), false, tv)
	box(Vector3(0.6, 0.4, 0.06), Vector3(0, 0, 0.07), mat(Color(0.1, 0.1, 0.11), 0.6), false, tv)
	var strap := mat(Color(0.75, 0.6, 0.1), 0.8)
	for sx: float in [-0.25, 0.25]:
		box(Vector3(0.04, 0.58, 0.08), Vector3(sx, 0, 0.05), strap, false, tv)
		for sy: float in [-0.285, 0.285]:
			box(Vector3(0.04, 0.035, 0.1), Vector3(sx, sy, 0.0), strap, false, tv)
		box(Vector3(0.05, 0.06, 0.04), Vector3(sx, -0.22, 0.1), metal, false, tv)
	var dark := mat(Color(0.015, 0.018, 0.022), 0.05, 0.7)
	var scr := box(Vector3(0.84, 0.52, 0.005), Vector3(0, 0, -0.042), dark, false, tv)
	u.set_meta("tv", tv)
	u.set_meta("wheels", wheels)
	u.set_meta("screen", scr)
	if live:
		u.set_meta("tv_node", tv)
	return u


func _freudbot() -> void:
	freudbot = _fb_unit(self, true)
	freudbot.position = Vector3(0, 0, 4.2)
	freudbot.rotation.y = 0.0
	freudbot.visible = false
	fb_wheels = freudbot.get_meta("wheels")
	var tv: Node3D = freudbot.get_meta("tv")
	# the face: SalTech's soft blue, two eyes, a smile you could invoice for
	fb_face = Node3D.new()
	fb_face.position = Vector3(0, 0, -0.05)
	tv.add_child(fb_face)
	var face_q := quad(Vector2(0.84, 0.52), Vector3.ZERO, PI, glow(Color(0.28, 0.48, 0.66), 1.1), fb_face)
	face_q.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	for sx: float in [-0.12, 0.12]:
		box(Vector3(0.05, 0.07, 0.004), Vector3(sx, 0.06, -0.003), glow(Color(0.95, 0.97, 1.0), 2.0), false, fb_face)
	var mouth := box(Vector3(0.16, 0.018, 0.004), Vector3(0, -0.07, -0.003), glow(Color(0.95, 0.97, 1.0), 2.0), false, fb_face)
	mouth.rotation.z = 0.0
	for sx: float in [-0.095, 0.095]:
		var c := box(Vector3(0.04, 0.018, 0.004), Vector3(sx, -0.058, -0.003), glow(Color(0.95, 0.97, 1.0), 2.0), false, fb_face)
		c.rotation.z = 0.5 if sx > 0.0 else -0.5
	label(LINES["session"]["screen_name"], Vector3(0, 0.2, -0.004), PI, 0.0009, Color(0.9, 0.95, 1.0), fb_face, false)
	label(LINES["session"]["screen_sub"], Vector3(0, -0.21, -0.004), PI, 0.0005, Color(0.75, 0.85, 0.95), fb_face, false)
	for i in 5:
		var b := box(Vector3(0.025, 0.05, 0.004), Vector3(-0.1 + i * 0.05, -0.15, -0.004), glow(Color(0.85, 0.92, 1.0), 1.6), false, fb_face)
		b.visible = false
		fb_bars.append(b)
	fb_lie = label(LINES["session"]["screen_lie"], Vector3(0, 0.0, -0.06), PI, 0.0008, Color(0.95, 0.95, 0.95), tv, false)
	fb_lie.visible = false
	fb_ledger = label("", Vector3(0, -0.06, -0.06), PI, 0.0004, Color(0.8, 0.8, 0.8), tv, false)
	fb_ledger.visible = false
	fb_it = interactable("freudbot", "FreudBot", Vector3(0, 0.9, 0), Vector3(0.7, 1.8, 0.7), LINES["look"]["freudbot_scan"], false, freudbot)
	set_active(fb_it, false)


## The dark screen as a mirror: a camera in the bezel looking back at the
## room, flipped, dim, and a Carl only it can see (layer 20) who stands where
## the player stands, half a second behind.
func _mirror() -> void:
	var tv: Node3D = freudbot.get_meta("tv")
	mirror_anchor = Node3D.new()
	mirror_anchor.position = Vector3(0, 0, -0.06)
	tv.add_child(mirror_anchor)
	mirror_vp = SubViewport.new()
	mirror_vp.size = Vector2i(320, 200)
	mirror_vp.render_target_update_mode = SubViewport.UPDATE_DISABLED
	add_child(mirror_vp)
	mirror_cam = Camera3D.new()
	mirror_cam.fov = 40.0
	mirror_cam.near = 0.05
	mirror_cam.far = 30.0
	mirror_vp.add_child(mirror_cam)
	var mm := StandardMaterial3D.new()
	mm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mm.albedo_texture = mirror_vp.get_texture()
	mm.albedo_color = Color(0.16, 0.17, 0.2)
	mm.uv1_scale = Vector3(-1, 1, 1)
	mm.uv1_offset = Vector3(1, 0, 0)
	var mq := quad(Vector2(0.84, 0.52), Vector3(0, 0, -0.046), PI, mm, tv)
	mq.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	# Carl, as the glass sees him
	twin = figure(Color(0.24, 0.26, 0.3), Color(0.8, 0.62, 0.5), {"arms": true, "knees": true, "visor": true, "hair": Color(0.12, 0.09, 0.07), "long_coat": true})
	add_child(twin)
	twin.position = Vector3(0, 0, 0.8)
	_set_layer(twin, 1 << 19)
	twin.visible = false


# ------------------------------------------------------------------ the typing panel

## Psyonic HR's agreement: the sentence in grey, typed over in white one key
## at a time. Wrong keys flash red and count as corrections.
func _typing_ui() -> void:
	_type_layer = CanvasLayer.new()
	_type_layer.layer = 11
	_type_layer.visible = false
	add_child(_type_layer)
	_type_panel = PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.11, 0.12, 0.12, 0.96)
	sb.border_color = Color(0.2, 1.0, 0.45, 0.8)
	sb.set_border_width_all(2)
	sb.set_content_margin_all(26)
	_type_panel.add_theme_stylebox_override("panel", sb)
	_type_layer.add_child(_type_panel)
	var vb := VBoxContainer.new()
	vb.add_theme_constant_override("separation", 14)
	_type_panel.add_child(vb)
	var head := Label.new()
	head.text = LINES["typing"]["head"]
	head.add_theme_font_size_override("font_size", 16)
	head.add_theme_color_override("font_color", PSYON_GREEN)
	vb.add_child(head)
	var sub := Label.new()
	sub.text = LINES["typing"]["sub"]
	sub.add_theme_font_size_override("font_size", 14)
	sub.add_theme_color_override("font_color", Color(0.6, 0.65, 0.62))
	vb.add_child(sub)
	_type_text = RichTextLabel.new()
	_type_text.bbcode_enabled = true
	_type_text.fit_content = true
	_type_text.scroll_active = false
	_type_text.custom_minimum_size = Vector2(700, 50)
	_type_text.add_theme_font_size_override("normal_font_size", 30)
	vb.add_child(_type_text)
	_type_err = Label.new()
	_type_err.add_theme_font_size_override("font_size", 14)
	_type_err.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
	vb.add_child(_type_err)


func _type_draw(bad := false) -> void:
	var t: String = LINES["typing"]["target"]
	var done := t.substr(0, _type_i)
	var cur := t.substr(_type_i, 1)
	var rest := t.substr(_type_i + 1)
	var cc := "#ff4a3a" if bad else "#ffffff"
	var s := "[color=#f2f2ea]" + done + "[/color]"
	if cur != "":
		s += "[bgcolor=#2a3a30][color=%s][u]%s[/u][/color][/bgcolor]" % [cc, cur if cur != " " else "_"]
	s += "[color=#555a58]" + rest + "[/color]"
	_type_text.text = s
	_type_err.text = LINES["typing"]["errors"] % _type_errors


func _type_open() -> void:
	_type_i = 0
	_type_errors = 0
	_typing_on = true
	main.ui.busy = true
	_type_layer.visible = true
	var vs: Vector2 = get_viewport().get_visible_rect().size
	_type_panel.reset_size()
	_type_panel.position = Vector2((vs.x - 760.0) / 2.0, vs.y * 0.3)
	_type_panel.custom_minimum_size = Vector2(760, 0)
	_type_draw()


## One key from the player (or the self-test). Punctuation types itself.
func _type_key(ch: String) -> void:
	if not _typing_on:
		return
	var t: String = LINES["typing"]["target"]
	if ch.to_lower() == t.substr(_type_i, 1).to_lower():
		_type_i += 1
		main.play("tap", -18.0, 1.3)
		while _type_i < t.length() and ".,;:!?'".contains(t.substr(_type_i, 1)):
			_type_i += 1
		_type_draw()
		if _type_i >= t.length():
			_typing_on = false
			_type_text.text = "[color=#f2f2ea]" + t + "[/color]"
			_type_err.text = LINES["typing"]["done"]
			main.play("ding", -10.0, 0.9)
			await get_tree().create_timer(0.9).timeout
			_type_layer.visible = false
			main.ui.busy = false
			typed_done.emit()
	else:
		_type_errors += 1
		main.play("tap", -10.0, 0.6)
		_type_draw(true)


func _input(e: InputEvent) -> void:
	if not _typing_on:
		return
	if e is InputEventKey and e.pressed and not e.echo:
		var k := e as InputEventKey
		if k.unicode > 0:
			_type_key(char(k.unicode))
		get_viewport().set_input_as_handled()


func _autotype() -> void:
	var t: String = LINES["typing"]["target"]
	await get_tree().create_timer(0.3).timeout
	_type_key("x")   # one correction, for the test's sake
	var guard_n := 0
	while _typing_on and guard_n < 200:
		_type_key(t.substr(_type_i, 1))
		guard_n += 1
		await get_tree().create_timer(0.02).timeout


# ------------------------------------------------------------------ sound and text helpers

## "Lie detected" is a flat UI tone: one pitch, no envelope to speak of.
func _flat_tone() -> AudioStreamWAV:
	var rate := 22050
	var n := int(rate * 0.42)
	var data := PackedByteArray()
	data.resize(n * 2)
	for i in n:
		var t := float(i) / rate
		var env := minf(1.0, t * 200.0) * minf(1.0, (0.42 - t) * 200.0)
		var v := sin(TAU * 740.0 * t) * 0.28 * env
		data.encode_s16(i * 2, int(v * 32767.0))
	var w := AudioStreamWAV.new()
	w.format = AudioStreamWAV.FORMAT_16_BITS
	w.mix_rate = rate
	w.stereo = false
	w.data = data
	return w


## The mother's voice: the only serif in the game, a soft room tone under
## it, the speaker shown as MOTHER and then, a beat later, as FREUDBOT.
func _mother(text: String) -> void:
	var ui = main.ui
	ui.body.add_theme_font_override("normal_font", _serif)
	ui.body.add_theme_font_override("italics_font", _serif_i)
	ui.name_l.add_theme_font_override("font", _serif)
	if _room_tone and is_instance_valid(_room_tone):
		var ap := _room_tone as AudioStreamPlayer
		if not ap.playing:
			ap.play()
		create_tween().tween_property(ap, "volume_db", -18.0, 0.8)
	for b in fb_bars:
		(b as Node3D).visible = true
	get_tree().create_timer(1.6).timeout.connect(func():
		if ui.name_l.text == "MOTHER":
			ui.name_l.text = "FREUDBOT"
			ui.glitch(0.25, 0.3))
	await ui.say("MOTHER", "[i]" + text + "[/i]")
	ui.body.remove_theme_font_override("normal_font")
	ui.body.remove_theme_font_override("italics_font")
	ui.name_l.remove_theme_font_override("font")
	for b in fb_bars:
		(b as Node3D).visible = false
	if _room_tone and is_instance_valid(_room_tone):
		create_tween().tween_property(_room_tone, "volume_db", -60.0, 1.2)


## The mirror's voice: the caption shakes, the frames tear, Carl's legs go.
func _mirror_voice(line: Array) -> void:
	var ui = main.ui
	main.play("pressure", -6.0, 0.7)
	ui.glitch(0.9, 1.0)
	main.player.shake(0.6)
	await ui.say(str(line[0]), str(line[1]))


func _say(line: Array) -> void:
	await main.ui.say(str(line[0]), str(line[1]))


## A choice, unless the self-test has forced one.
func _ask(opts: Array) -> int:
	if _force >= 0:
		var f := _force
		_force = -1
		return clampi(f, 0, opts.size() - 1)
	var i: int = await main.ui.choose(opts)
	return clampi(i, 0, opts.size() - 1)


func _wait(secs: float) -> void:
	await get_tree().create_timer(secs).timeout


func _lie(ledger_text: String, log_text: String) -> void:
	var ui = main.ui
	_tone.play()
	fb_face.visible = false
	fb_lie.visible = true
	fb_ledger.text = ledger_text
	fb_ledger.visible = true
	ui.flash(0.3)
	await _say(LINES["session"]["lie"])
	await ui.think(LINES["session"]["lie_text"])
	main.add_connection(2.0, "lie detected")
	main.log_line("freudbot", log_text)
	await _wait(0.6)
	fb_lie.visible = false
	fb_ledger.visible = false
	fb_face.visible = true


func _truth() -> void:
	main.add_pressure(-1.0, "honest with FreudBot")


func _bowed() -> bool:
	var f: Dictionary = main.flags
	if f.has("bowed") or f.has("bowed_today"):
		return true
	for e in main.ledger:
		var d: Dictionary = e
		var t := str(d.get("text", "")).to_lower()
		if str(d.get("kind", "")) == "bow" or t.contains("bowed") or t.contains("bowing"):
			return true
	return false


func _bow_entry() -> String:
	for e in main.ledger:
		var d: Dictionary = e
		var t := str(d.get("text", ""))
		if t.to_lower().contains("bowed") or str(d.get("kind", "")) == "bow":
			return t.substr(0, 40)
	return "bowed (desert door)"


func _drank_mezcal() -> bool:
	var f: Dictionary = main.flags
	for k in ["drank_mezcal", "mezcal", "ev_mezcal"]:
		if f.has(k):
			return true
	for e in main.ledger:
		if str((e as Dictionary).get("text", "")).to_lower().contains("mezcal"):
			return true
	return false


func _charged() -> bool:
	return main.flags.has("charged_observatory") or not (main.flags.has("watched_observatory") or main.flags.has("sang_observatory"))


# ------------------------------------------------------------------ walking people

func _walk(fig: Node3D, path: Array, speed := 1.2, wheels := false) -> void:
	for mv in movers:
		if mv["fig"] == fig:
			movers.erase(mv)
			break
	movers.append({"fig": fig, "path": path, "i": 0, "speed": speed, "wheels": wheels})


func _arrive(fig: Node3D, secs := 25.0) -> void:
	var t := 0.0
	while t < secs:
		var busy := false
		for mv in movers:
			if mv["fig"] == fig:
				busy = true
		if not busy:
			return
		await get_tree().process_frame
		t += get_process_delta_time()
	# deadline: put it where it was going
	for mv in movers:
		if mv["fig"] == fig:
			var path: Array = mv["path"]
			fig.position = path[path.size() - 1]
			movers.erase(mv)
			return


func _move_people(delta: float) -> void:
	var done := []
	for mv in movers:
		var fig: Node3D = mv["fig"]
		var path: Array = mv["path"]
		var target: Vector3 = path[int(mv["i"])]
		var d := target - fig.position
		d.y = 0.0
		var step := float(mv["speed"]) * delta
		if d.length() <= step:
			fig.position = Vector3(target.x, fig.position.y, target.z)
			mv["i"] = int(mv["i"]) + 1
			if int(mv["i"]) >= path.size():
				done.append(mv)
			continue
		fig.position += d.normalized() * step
		var want := atan2(-d.x, -d.z)
		fig.rotation.y = lerp_angle(fig.rotation.y, want, minf(1.0, delta * 6.0))
		if mv["wheels"]:
			for w in fig.get_meta("wheels"):
				(w as Node3D).rotation.x -= step / 0.11
		else:
			Anim.walk(fig, _t, float(mv["speed"]) / 1.2)
	for mv in done:
		movers.erase(mv)


## Carl steps back from the door to let someone in.
func _step_back(to: Vector3) -> void:
	var p = main.player
	if p.position.distance_to(to) < 0.4:
		return
	var tw := create_tween()
	tw.tween_property(p, "position", to, 0.7).set_trans(Tween.TRANS_SINE)
	await tw.finished


func _door(open: bool) -> void:
	if door_open == open:
		return
	door_open = open
	main.play("door", -8.0, 1.3)
	var tw := create_tween()
	tw.tween_property(door_body, "position:x", 1.05 if open else 0.0, 0.9).set_trans(Tween.TRANS_SINE)
	await tw.finished


# ------------------------------------------------------------------ the scenes

func intro() -> void:
	await _run_dream()
	await _wake()


## Forty seconds of the leaves, then white. No choice in it.
func _run_dream() -> void:
	var l: Dictionary = LINES["dream"]
	_stage = "dream"
	main.update_hud()
	_dream_caps = [[1.0, l["c1"]], [8.0, l["c2"]], [14.0, l["c3"]]]
	_dream_t = 0.0
	_dream_on = true
	await dream_over


func _wake() -> void:
	var ui = main.ui
	var p = main.player
	var f: Dictionary = main.flags
	if f.has("hc_woke"):
		return
	f["cinematic"] = true
	ui.fade.color = Color(1, 1, 1, ui.fade.color.a)
	await ui.fade_to(1.0, 1.4)
	dream_root.visible = false
	leaves_fx.emitting = false
	kit_day = false
	main.retro.tune(false)
	_env_tower()
	for k in main.amb:
		var ap = main.amb[k]
		if is_instance_valid(ap) and ap != _room_tone:
			ap.stop()
	var rt := _room_tone as AudioStreamPlayer
	if rt:
		rt.volume_db = -30.0
		rt.play()
	# on the floor of the cell, looking at the ceiling panel
	p.position = Vector3(-0.6, 0.05, -0.4)
	p.velocity = Vector3.ZERO
	p.yaw = deg_to_rad(-30.0)
	p.pitch = 1.3
	p.crouch = 1.25
	p.rotation.y = p.yaw
	await ui.fade_to(0.0, 2.2)
	ui.fade.color = Color(0, 0, 0, ui.fade.color.a)
	ui.caption(LINES["build"]["woke_cap"], 4.0)
	await ui.think(LINES["wake"]["think1"])
	var tw := create_tween().set_parallel(true)
	tw.tween_property(p, "crouch", 0.0, 1.6).set_trans(Tween.TRANS_SINE)
	tw.tween_property(p, "pitch", 0.0, 1.6)
	await ui.think(LINES["wake"]["think2"] if _charged() else LINES["wake"]["think2_quiet"])
	await ui.think(LINES["wake"]["think3"])
	ui.close()
	p.crouch = 0.0
	f["hc_woke"] = true
	f.erase("cinematic")
	_stage = "awake"
	main.update_hud()
	# Turan comes when Carl goes to the door, or after a while anyway
	await _wait_or_door(14.0)
	await _turan()


func _wait_or_door(secs: float) -> void:
	_door_knocked = false
	var t := 0.0
	while t < secs and not _door_knocked:
		await get_tree().process_frame
		t += get_process_delta_time()


func _knock() -> void:
	for i in 3:
		main.play("tap", -4.0, 0.55)
		await _wait(0.28)


## "It's 9:30 a.m." The play she is acting in, and the message in her eyes.
func _turan() -> void:
	var ui = main.ui
	var p = main.player
	var f: Dictionary = main.flags
	var l: Dictionary = LINES["turan"]
	if f.has("hc_turan"):
		return
	f["hc_turan"] = true
	f["cinematic"] = true
	await _knock()
	await _step_back(Vector3(-0.7, 0.05, -0.6))
	await _door(true)
	turan.visible = true
	turan.position = Vector3(0.0, 0, 4.0)
	_walk(turan, [Vector3(0.0, 0, 2.6), Vector3(0.1, 0, 1.0)], 1.1)
	await p.face(Vector3(0, 1.6, 2.0), 0.9)
	await ui.think(l["knock"])
	await _arrive(turan)
	turan_face_carl()
	await p.face(turan.global_position + Vector3(0, 1.62, 0), 0.6)
	await ui.think(l["knew"])
	await _say(l["t1"])
	await ui.think(l["water"])
	await _say(l["t2"])
	await _say(l["what"])
	await _say(l["t3"])
	if _drank_mezcal():
		await _say(l["mezcal"])
	await _say(l["t4"])
	await ui.think(l["play"])
	await _say(l["t5"])
	await _say(l["t6"])
	await ui.think(l["pip"] if _charged() else l["pip_quiet"])
	var first: int = await _ask(l["ask"])
	if first == 0:
		await _turan_kids()
		await _say(l["lynx_q"])
		await _say(l["lynx"])
	else:
		await _say(l["lynx_q"])
		await _say(l["lynx"])
		await _turan_kids()
	await _say(l["t7"])
	await ui.think(l["blink"])
	await _say(l["t8"])
	await ui.think(l["brow"])
	await _say(l["t9"])
	await _say(l["t10"])
	await ui.think(l["wink"])
	await _say(l["t11"])
	ui.close()
	# she holds the tablet out; the thumb pad is lit
	_hold_tablet()
	f.erase("cinematic")
	_stage = "sign"
	main.update_hud()


func turan_face_carl() -> void:
	turan_look_reset()
	turn_to(turan, main.player.global_position, 0.4)


func turan_look_reset() -> void:
	_turan_looking = false


## "Her eyes gestured toward the corners of the room." She looks at each
## camera dot in turn; Carl's eyes follow hers to one of them.
func _turan_kids() -> void:
	var ui = main.ui
	var l: Dictionary = LINES["turan"]
	await _say(l["kids_q"])
	await _say(l["kids"])
	ui.close()
	_turan_looking = true
	for i in 4:
		_turan_look = CORNERS[[0, 1, 3, 2][i]]
		main.play("tap", -26.0, 2.0)
		await _wait(0.55)
	await main.player.face(CORNERS[1], 0.7)
	await ui.think(l["eyes"])
	_turan_looking = false
	await main.player.face(turan.global_position + Vector3(0, 1.62, 0), 0.6)


func _hold_tablet() -> void:
	_turan_hold = true
	tablet.visible = true
	tablet.position = turan.position + Vector3(0, 1.08, 0) + (main.player.position - turan.position).normalized() * 0.42
	tablet.rotation.y = turan.rotation.y
	set_active(tablet_it, true)


## Pressing the thumb pad: the hand-off (or not), the press, the sentence.
func _sign() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var l: Dictionary = LINES["turan"]
	if f.has("hc_signed") or _typing_on:
		return
	f["cinematic"] = true
	set_active(tablet_it, false)
	await _handoff(int(main.trust.get("turan", 0)) >= 1)
	await ui.think(l["thumb"])
	tablet_glow.emission = PSYON_GREEN
	main.play("on", -8.0, 1.2)
	await _say(l["agree"])
	ui.close()
	_stage = "typing"
	main.update_hud()
	_type_open()
	if main._selftest:
		_autotype()
	await typed_done
	if _type_errors >= 3:
		await _say(l["slow"])
	f["hc_signed"] = true
	main.log_line("scene", l["sign_log"])
	await _say(l["t12"])
	await ui.think(l["pocket"] if f.has("ev_turan_note") else l["left"])
	ui.close()
	tablet.visible = false
	_turan_hold = false
	_walk(turan, [Vector3(0.0, 0, 2.6), Vector3(-2.0, 0, 4.0), Vector3(-9.0, 0, 4.0)], 1.2)
	await _wait(1.6)
	await _door(false)
	f.erase("cinematic")
	_stage = "wait"
	main.update_hud()
	await _arrive(turan, 12.0)
	turan.visible = false
	await _wait_freudbot()


## At T:turan >= +1, the close-up of her fingers under the tablet and the
## rolled note going into his palm. Otherwise she lets go at once.
func _handoff(note: bool) -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var l: Dictionary = LINES["turan"]
	if note:
		ui.show_picture(_handoff_tex(), l["handoff_cap"])
		main.play("shutter", -14.0, 0.8)
		await ui.think(l["handoff"])
		ui.hide_picture()
		if not f.has("ev_turan_note"):
			f["ev_turan_note"] = true
			f["turan_note"] = true
			main.log_line("evidence", l["note_log"])
			ui.show_toast("Evidence: Turan's note", 3.0)
	else:
		await ui.think(l["no_note"])


## While the cell waits for its therapist: what Carl knows about FreudBot,
## as captions he can walk around in. The door brings it sooner.
func _wait_freudbot() -> void:
	var t := 0.0
	var next := 1.0
	_door_knocked = false
	while t < 26.0 and not _door_knocked:
		if t >= next and _wait_i < LINES["wait"].size():
			main.ui.caption(LINES["wait"][_wait_i], 4.6)
			_wait_i += 1
			next += 5.2
		await get_tree().process_frame
		t += get_process_delta_time()
	await _session()


## The dive: FreudBot wheels in and the ledger is read back to Carl.
func _session() -> void:
	var ui = main.ui
	var p = main.player
	var f: Dictionary = main.flags
	var s: Dictionary = LINES["session"]
	if _session_started:
		return
	_session_started = true
	f["cinematic"] = true
	_stage = "wait"
	await _knock()
	await _step_back(Vector3(0.5, 0.05, 0.9))
	await _door(true)
	nurse.visible = true
	nurse.position = Vector3(-1.2, 0, 4.0)
	freudbot.visible = true
	freudbot.position = Vector3(0, 0, 4.2)
	_walk(freudbot, [Vector3(0, 0, 2.5), FB_PARK], 0.7, true)
	_walk(nurse, [Vector3(-0.5, 0, 3.0), Vector3(-0.5, 0, 2.0)], 0.8)
	await p.face(Vector3(0, 1.2, 2.0), 0.8)
	await ui.think(s["knock"])
	await _arrive(freudbot)
	turn_to(freudbot, p.global_position, 0.6)
	_walk(nurse, [Vector3(-0.5, 0, 3.4), Vector3(-6.0, 0, 4.0)], 1.1)
	await _wait(1.6)
	await _door(false)
	set_active(fb_it, true)
	await p.face(freudbot.global_position + Vector3(0, 1.3, 0), 0.8)
	await ui.think(s["model"])
	await ui.think(s["judge"])
	await ui.think(s["stare"])
	nurse.visible = false
	# the glass: dark first, a mirror; the twin stands where Carl stands
	_mirror_on(true)
	fb_face.visible = false
	await ui.think(s["glass"])
	await ui.think(s["voice"])
	fb_face.visible = true
	await _mother(s["mother1"])
	await _mother(s["mother2"])
	await ui.think(s["ten"])
	await _say(s["id"])
	await ui.think(s["gruff"])
	await _say(s["id2"])
	var who: int = await _ask(s["id_choices"])
	if who == 1:
		main.add_connection(1.0, "answered to her")
		main.log_line("freudbot", s["id_mom_log"])
		await _say(s["id_mom"])
	await _say(s["id_yes"])
	await _say(s["thanks"])
	await _say(s["suicide"])
	await ui.think(s["flat"])
	await _ask(s["suicide_choices"])
	await _say(s["good"])
	await ui.think(s["interrupt"])
	await _say(s["anxiety"])
	await ui.think(s["paranoia"])
	await _ask(s["anxiety_choices"])
	await _say(s["next"])
	await _round_hallucinations()
	await _say(s["yesterday"])
	await _round_bow()
	await _closing()
	await _alcohol()
	await _after()


## "Any hallucinations?" The detector has the glyphs he examined.
func _round_hallucinations() -> void:
	var s: Dictionary = LINES["session"]
	await _say(s["halluc"])
	var pick: int = await _ask(s["halluc_choices"])
	var yes := pick == 1
	if not yes and main.glyphs_found > 0:
		await _lie(s["ledger_glyph"] % main.glyphs_found, s["halluc_lie_log"])
	elif yes:
		_truth()
		await _say(s["honest"])
	else:
		_truth()
		await _say(s["next"])


## "Did someone make you BOW, Carl?" The mirror's voice; the screen goes
## dark and the reflection stops keeping time. The detector has the desert.
func _round_bow() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var s: Dictionary = LINES["session"]
	fb_face.visible = false
	cell_light.light_color = Color(0.85, 0.82, 1.0)
	await _mirror_voice(s["bow"])
	await ui.think(s["mud"])
	await ui.think(s["dark"])
	ui.close()
	# a moment to look: the reflection lags, then turns its head on its own
	_stage = "mirror"
	twin_mode = "lag"
	twin_lag = 0.7
	f.erase("cinematic")
	main.update_hud()
	var t := 0.0
	var start: Vector3 = main.player.position
	var start_yaw: float = main.player.yaw
	while t < 7.0:
		if t > 3.5 or main.player.position.distance_to(start) > 0.6 or absf(main.player.yaw - start_yaw) > 0.5:
			twin_mode = "own"
		await get_tree().process_frame
		t += get_process_delta_time()
	f["cinematic"] = true
	twin_mode = "own"
	await main.player.face(freudbot.global_position + Vector3(0, 1.3, 0), 0.5)
	await ui.think(s["resolute"])
	var pick: int = await _ask(s["bow_choices"])
	var yes := pick == 1
	if not yes and _bowed():
		await _lie(s["ledger_bow"] % _bow_entry(), s["bow_lie_log"])
		fb_face.visible = false
	elif yes:
		_truth()
		await _mirror_voice(s["bow_yes"])
	else:
		_truth()
		await _mirror_voice(s["bow_no"])
	await _mirror_voice(s["desert"])
	await _say(s["will_not"])
	await _mother(s["submit"])
	var mom: int = await _ask(s["mouth_choices"])
	if mom == 1:
		main.add_connection(1.0, "Mom?")
		main.log_line("freudbot", s["mom_log"])
	else:
		await _say(s["mouth"])


func _closing() -> void:
	var ui = main.ui
	var s: Dictionary = LINES["session"]
	await _mother(s["closing"])
	await _mother(s["soon"])
	# the blink: the reflection goes, the voice goes back to being a product
	main.play("off", -6.0, 0.6)
	_mirror_on(false)
	cell_light.light_color = Color(1.0, 1.0, 0.97)
	fb_face.visible = true
	twin_mode = "lag"
	await ui.think(s["blink"])


## "How long have you suffered from alcoholism, Carl?" No way out but the
## concession.
func _alcohol() -> void:
	var ui = main.ui
	var s: Dictionary = LINES["session"]
	await _say(s["alcohol"])
	var opts: Array = s["alcohol_choices"]
	var guard_n := 0
	while guard_n < 8:
		guard_n += 1
		var i: int = await _ask(opts)
		if str(opts[i]) == str(s["sorry"][1]):
			break
		await _say(s["records"])
		await _say(s["reconcile"])
		await ui.think(s["give_in"])
		opts = s["alcohol_again"]
	await _say(s["sorry"])
	await _say(s["step"])
	await _say(s["progress"])
	await _say(s["proud"])
	await ui.think(s["malfunction"])
	main.flags["freudbot_1"] = true
	main.log_line("freudbot", s["log"])


## Ch.18: the nurse, FreudBot rolling out, the door left open.
func _after() -> void:
	var ui = main.ui
	var p = main.player
	var f: Dictionary = main.flags
	var a: Dictionary = LINES["after"]
	await _door(true)
	nurse.visible = true
	nurse.position = Vector3(-0.4, 0, 3.6)
	turn_to(nurse, p.global_position)
	await _say(a["nurse"])
	ui.close()
	set_active(fb_it, false)
	_walk(freudbot, [Vector3(0, 0, 2.6), Vector3(-1.0, 0, 3.9), Vector3(-8.0, 0, 3.9)], 0.8, true)
	_walk(nurse, [Vector3(-1.4, 0, 3.6), Vector3(-8.6, 0, 3.6)], 0.9)
	await ui.think(a["tool"])
	await ui.think(a["spire"])
	await ui.think(a["broken"])
	ui.close()
	monica.visible = true
	set_active(monica_it, true)
	f.erase("cinematic")
	_stage = "leave"
	main.update_hud()
	await _arrive(freudbot, 14.0)
	freudbot.visible = false
	nurse.visible = false


## Monica outside the door. Fires when Carl steps out (only once FreudBot
## has had him), or when he talks to her.
func _monica() -> void:
	var ui = main.ui
	var p = main.player
	var f: Dictionary = main.flags
	var l: Dictionary = LINES["monica"]
	if _monica_started or not f.has("freudbot_1"):
		return
	_monica_started = true
	f["cinematic"] = true
	turn_to(monica, p.global_position, 0.5)
	await p.face(monica.global_position + Vector3(0, 1.58, 0), 0.7)
	await ui.think(l["soccer"])
	await _say(l["m1"])
	_walk(monica, [p.position + (monica.position - p.position).normalized() * 0.55], 0.9)
	await ui.think(l["viper"])
	await _say(l["m2"])
	await ui.think(l["bite"])
	await _say(l["drink"])
	await _arrive(monica, 4.0)
	# the arms round his neck
	for a in monica.get_meta("arms"):
		(a as Node3D).rotation.x = 2.1
		(a as Node3D).rotation.z = (-0.55 if (a as Node3D).position.x > 0.0 else 0.55)
	await ui.think(l["mask"])
	await _say(l["m3"])
	await _say(l["idea"])
	await ui.think(l["smile"])
	var trust_m := int(main.trust.get("monica", 0))
	if trust_m >= 1:
		await ui.think(l["mouth_pre"])
		await ui.say("Monica", l["mouthed"])
		main.log_line("scene", l["mouth_log"])
	await _say(l["m4"] if _charged() else l["m4_quiet"])
	for a in monica.get_meta("arms"):
		(a as Node3D).rotation.x = 0.0
		(a as Node3D).rotation.z = 0.0
	await ui.think(l["gone"])
	await _say(l["m5"])
	await ui.think(l["broke"])
	await _say(l["m6"])
	if trust_m <= -1:
		await _say(l["spa"])
		f["spa_booked"] = true
		main.log_line("scene", l["spa_log"])
	await _say(l["m7"])
	await ui.think(l["lost"])
	var plea: int = await _ask(l["plea_choices"])
	if plea == 0:
		await _say(l["plea"])
	else:
		await ui.think(l["silent"])
	await _say(l["m8"])
	await ui.think(l["take"])
	ui.close()
	set_active(monica_it, false)
	_walk(monica, [Vector3(3.0, 0, 4.4), Vector3(18.6, 0, 4.0)], 1.2)
	await ui.think(l["muscles"])
	ui.close()
	f["hc_hallway"] = true
	main.log_line("scene", l["log"])
	f.erase("cinematic")
	_stage = "hall"
	main.update_hud()
	await _arrive(monica, 20.0)
	monica.visible = false


## The lift down, the walk to the subway out of the cameras' view, the note
## (if there is one), the ride. Then Red Rock.
func _leave() -> void:
	var ui = main.ui
	var p = main.player
	var f: Dictionary = main.flags
	var l: Dictionary = LINES["leave"]
	if _leaving:
		return
	if not f.has("hc_hallway"):
		await ui.think(l["lifts_locked"])
		return
	_leaving = true
	f["cinematic"] = true
	turn_to(guard, p.global_position, 0.4)
	await _say(l["guard"])
	await ui.think(l["no_car"])
	ui.close()
	main.play("ding", -8.0, 1.0)
	lift_label.text = "L"
	await _lift_doors(true)
	await ui.fade_to(1.0, 1.0)
	f["pip_active"] = true
	main.log_line("scene", l["log"])
	await ui.show_card(LINES["build"]["subway_card"], 2.4)
	await _subway_ride()


func _lift_doors(open: bool) -> void:
	var tw := create_tween().set_parallel(true)
	for d in lift_doors:
		var leaf: Node3D = d[0]
		var z0: float = d[1]
		var s: float = d[2]
		if absf(z0 - 3.1) < 0.6:
			tw.tween_property(leaf, "position:z", z0 + (s * 0.5 if open else 0.0), 1.0)
	await tw.finished


func _subway_ride() -> void:
	var ui = main.ui
	var p = main.player
	var f: Dictionary = main.flags
	var l: Dictionary = LINES["leave"]
	cell_root.visible = false
	hall_root.visible = false
	sub_root.visible = true
	_riding = true
	p.position = SUBWAY + Vector3(-1.1, 0.05, -1.0)
	p.seated = true
	p.crouch = 0.5
	p.yaw = deg_to_rad(-90.0)
	p.rotation.y = p.yaw
	p.pitch = -0.05
	_env.ambient_light_energy = 0.4
	_env.background_mode = Environment.BG_COLOR
	_env.background_color = Color(0, 0, 0)
	var eng: AudioStreamPlayer = main.loop("engine", -18.0)
	eng.pitch_scale = 0.6
	eng.play()
	await ui.fade_to(0.0, 1.2)
	await ui.think(l["blocks"])
	await ui.think(l["sun"])
	if f.has("ev_turan_note"):
		await ui.think(l["note_pre"])
		ui.show_picture(_note_tex(), l["note_cap"])
		await ui.say("", l["note"])
		ui.hide_picture()
		await ui.think(l["note_after"])
		main.log_line("evidence", l["note_log"])
	else:
		await ui.think(l["no_note"])
	ui.close()
	await ui.caption(l["ride1"], 4.0)
	await ui.caption(l["ride2"], 4.0)
	await ui.caption(l["ride3"], 4.5)
	await _end()


func _end() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if _ended:
		return
	_ended = true
	f["pip_active"] = true
	f["holdingcell_done"] = true
	f.erase("cinematic")
	await ui.show_card(LINES["build"]["end_card"], 2.6)
	main.player.seated = false
	main.player.crouch = 0.0
	if not main._selftest:
		main.load_level("RedRock")


# ------------------------------------------------------------------ the mirror

func _mirror_on(on: bool) -> void:
	twin.visible = on
	mirror_vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS if on else SubViewport.UPDATE_DISABLED
	twin_hist.clear()


func _update_twin(delta: float) -> void:
	var p = main.player
	twin_hist.append([_t, p.position, float(p.yaw), float(p.pitch)])
	while twin_hist.size() > 2 and float(twin_hist[1][0]) < _t - 2.0:
		twin_hist.pop_front()
	var want: Array = twin_hist[twin_hist.size() - 1]
	for h in twin_hist:
		if float(h[0]) >= _t - twin_lag:
			want = h
			break
	var pos: Vector3 = want[1]
	twin.position = Vector3(pos.x, 0.0, pos.z)
	var head: Node3D = twin.get_meta("head")
	if twin_mode == "own":
		# it turns its head to the side and tilts it, studying him
		twin.rotation.y = lerp_angle(twin.rotation.y, float(want[2]), delta * 2.0)
		head.rotation.y = lerp_angle(head.rotation.y, 0.9 + sin(_t * 0.7) * 0.15, delta * 1.5)
		head.rotation.z = lerp_angle(head.rotation.z, 0.35, delta * 1.5)
		head.rotation.x = lerp_angle(head.rotation.x, 0.15, delta * 1.5)
	else:
		twin.rotation.y = float(want[2])
		head.rotation.y = lerp_angle(head.rotation.y, 0.0, delta * 4.0)
		head.rotation.z = lerp_angle(head.rotation.z, 0.0, delta * 4.0)
		head.rotation.x = -float(want[3]) * 0.6
	Anim.idle(twin, _t)
	mirror_cam.global_transform = mirror_anchor.global_transform


# ------------------------------------------------------------------ interaction

func interact(node: Object) -> bool:
	var ui = main.ui
	var f: Dictionary = main.flags
	var lk: Dictionary = LINES["look"]
	var id := str(node.get_meta("id"))
	if id.begins_with("camera_dot_"):
		await ui.think(lk["camera_dot"])
		return true
	if id.begins_with("hall_cam_"):
		await ui.think(lk["hc_cam"])
		return true
	if id.begins_with("suite_"):
		await ui.think(lk["door_other"] % int(node.get_meta("suite")))
		return true
	if id.begins_with("commuter_"):
		await ui.think(LINES["subway"]["commuter"])
		return true
	match id:
		"cell_door":
			if _stage == "awake" or _stage == "wait":
				await ui.think(LINES["wake"]["door"])
				_door_knocked = true
			elif door_open:
				await ui.think(lk["padding"])
			else:
				await ui.think(LINES["wake"]["door"])
		"padding":
			await ui.think(lk["padding"])
		"tablet":
			if f.has("hc_turan") and not f.has("hc_signed"):
				await _sign()
			else:
				await ui.think(lk["tablet_done"])
		"turan":
			await ui.think(LINES["turan"]["play"])
		"nurse":
			await _say(LINES["after"]["nurse"])
		"freudbot":
			await ui.think(lk["freudbot_after"])
		"monica":
			if f.has("freudbot_1") and not _monica_started:
				await _monica()
			else:
				await ui.think(LINES["monica"]["gone"])
		"guard":
			await ui.think(lk["guard"])
		"lift":
			await _leave()
		"reader":
			await ui.think(lk["reader"])
		"stairs":
			await ui.think(lk["stairs"])
		"vent":
			await ui.think(lk["vent"])
		"directory":
			await ui.think(lk["directory"])
		"neighbour":
			main.play("whisper", -18.0, 0.8)
			await ui.think(lk["neighbour"])
		"dock":
			await ui.think(lk["dock"])
		"desk":
			await ui.think(lk["desk"])
		"pillar":
			main.play("whisper", -22.0, 1.3)
			await ui.think(lk["pillar"])
		"screens":
			await ui.think(lk["screens"])
		"thermo":
			await ui.think(lk["thermo"])
		"water":
			await ui.think(lk["water"])
		"blinds":
			await ui.think(lk["blinds"])
		_:
			return false
	return true


# ------------------------------------------------------------------ the frame loop

func tick(delta: float) -> void:
	var p = main.player
	_move_people(delta)
	if _dream_on:
		_tick_dream(delta)
	if twin and twin.visible:
		_update_twin(delta)
		_pad_breathe += delta
		var s := 1.0 - (0.012 + sin(_pad_breathe * 1.6) * 0.012)
		pads.scale = Vector3(s, 1.0, s)
	elif pads and pads.scale.x != 1.0:
		pads.scale = Vector3.ONE
	# Turan's eyes on the corners
	if turan and turan.visible:
		if _turan_looking:
			Anim.look(turan, _turan_look, 1.0, 0.25)
		else:
			Anim.look(turan, p.global_position + Vector3(0, 1.6, 0), 1.0, 0.1)
		if not _moving(turan):
			Anim.idle(turan, _t, 0.4)
			if _turan_hold:
				var arms: Array = turan.get_meta("arms")
				for i in arms.size():
					(arms[i] as Node3D).rotation.x = 0.95
	for fig in [nurse, monica]:
		var n: Node3D = fig
		if n and n.visible and not _moving(n):
			Anim.idle(n, _t, 1.3)
			Anim.look(n, p.global_position + Vector3(0, 1.6, 0), 0.8, 0.08)
	# the guard watches the lifts; his head follows Carl anyway
	if guard:
		Anim.idle(guard, _t, 2.1)
		Anim.look(guard, p.global_position + Vector3(0, 1.6, 0), 0.7, 0.04)
	# the corridor cameras track him, half a second late
	for c in hall_cams:
		var pv: Node3D = c
		var d: Vector3 = p.global_position - pv.global_position
		var want := atan2(-d.x, -d.z)
		pv.rotation.y = lerp_angle(pv.rotation.y, want, minf(1.0, delta * 1.8))
	# the eye screens: the slogan, and for a frame at a time the eye
	for es in eye_screens:
		var eye: Sprite3D = es[1]
		if eye.visible:
			if randf() < delta * 6.0:
				eye.visible = false
				(es[0] as Node3D).visible = true
		elif randf() < delta * (0.08 + main.connection / 400.0):
			eye.visible = true
			(es[0] as Node3D).visible = false
	# the cell's camera pips glare during the mirror
	for led in cam_leds:
		(led as Node3D).visible = true if _stage != "mirror" else fmod(_t, 0.3) < 0.18
	# Monica waits; the beat is hers once FreudBot has had him and he steps out
	if monica and monica.visible and not _monica_started and main.flags.has("freudbot_1") and not main.flags.has("cinematic"):
		if p.global_position.z > 2.7 and p.global_position.distance_to(monica.global_position) < 2.6:
			_monica()
	if _riding:
		for l in tunnel_lights:
			var n := l as Node3D
			n.position.z += delta * 22.0
			if n.position.z > 13.0:
				n.position.z -= 26.0
		p.shake(0.05)
		for c in commuters:
			(c as Node3D).position.y = -0.02 + sin(_t * 9.0) * 0.004


func _moving(fig: Node3D) -> bool:
	for mv in movers:
		if mv["fig"] == fig:
			return true
	return false


## The dream's clock. Running makes it go faster: "The more I tried to
## fight it, the faster it faded away."
func _tick_dream(delta: float) -> void:
	var p = main.player
	var l: Dictionary = LINES["dream"]
	var speed := Vector2(p.velocity.x, p.velocity.z).length()
	_dream_t += delta * (1.0 + (0.9 if _receding and speed > 3.4 else 0.0))
	leaves_fx.position = Vector3(p.position.x - DREAM.x, 6.0, p.position.z - DREAM.z - 3.0)
	fire_light.light_energy = 1.4 + sin(_t * 13.0) * 0.25 + randf() * 0.2
	if speed > 0.5 and randf() < delta * 1.4:
		main.play("snap", -20.0, randf_range(0.8, 1.3))
	while _dream_caps.size() > 0 and _dream_t >= float(_dream_caps[0][0]):
		main.ui.caption(str(_dream_caps[0][1]), 3.4)
		_dream_caps.pop_front()
	var lz: float = p.position.z - DREAM.z
	if not _receding and (lz < fam_z + 13.0 or _dream_t > 17.0):
		_receding = true
		_recede_t0 = _dream_t
		var t0 := _dream_t
		var span := DREAM_SECS - 4.0 - t0
		_dream_caps = []
		var keys := ["c4", "c5", "c6", "c7", "c8", "c9"]
		var at := [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
		for i in keys.size():
			_dream_caps.append([t0 + 0.2 + span * float(at[i]), l[keys[i]]])
	# the family: laughing, and once it starts, always further off
	if _receding:
		fam_z = maxf(-72.0, fam_z - maxf(1.6, speed + 0.6) * delta)
	for fm in family:
		var fig: Node3D = fm[0]
		var off: Vector3 = fm[1]
		fig.position = Vector3(_trail_x(fam_z), 0, fam_z) + off
		Anim.idle(fig, _t * 1.6, float(fm[2]))
		for a in fig.get_meta("arms"):
			var arm := a as Node3D
			arm.rotation.x = 0.6 + sin(_t * 3.0 + float(fm[2])) * 0.5
		var head: Node3D = fig.get_meta("head")
		head.rotation.x = -0.25 + sin(_t * 5.0 + float(fm[2])) * 0.12
	if _receding:
		var k := clampf((_dream_t - _recede_t0) / maxf(1.0, DREAM_SECS - _recede_t0), 0.0, 1.0)
		_env.fog_density = lerpf(0.012, 0.32, k * k)
		_env.fog_light_color = Color(0.95, 0.82, 0.62).lerp(Color(1, 1, 1), k)
		for fm in family:
			(fm[0] as Node3D).visible = k < 0.92
	if _dream_t >= DREAM_SECS:
		_dream_on = false
		dream_over.emit()


# ------------------------------------------------------------------ HUD

func objective() -> String:
	if _ended or _riding:
		return ""
	if main.flags.has("cinematic") and _stage != "typing":
		return ""
	return str(LINES["objective"].get(_stage, ""))


func phone() -> String:
	var t: String = LINES["phone"]["text1"]
	if main.flags.has("hc_signed") and not main.flags.has("freudbot_1"):
		t += LINES["phone"]["text2"]
	if main.flags.has("hc_hallway"):
		t += LINES["phone"]["text3"]
	return t


func scan_people() -> Array:
	var out := []
	for pr in [[turan, "turan_scan"], [nurse, "nurse_scan"], [monica, "monica_scan"], [guard, "guard_scan"], [freudbot, "freudbot_scan"]]:
		var n: Node3D = pr[0]
		if n and n.visible:
			out.append([n, LINES["look"][pr[1]]])
	return out


## Dev args for screenshots: --stage=dream|cell|turan|session|mirror|hall|subway.
func apply_args(a: Dictionary) -> void:
	var st := str(a.get("stage", "dream"))
	var p = main.player
	if st == "dream":
		if a.has("recede"):
			_receding = true
			fam_z = -40.0
		return
	dream_root.visible = false
	leaves_fx.emitting = false
	main.retro.tune(false)
	_env_tower()
	main.flags["hc_woke"] = true
	if not a.has("at"):
		p.position = Vector3(0.0, 0.05, 1.3)
		p.yaw = 0.0
	match st:
		"turan":
			turan.visible = true
			turan.position = Vector3(0.1, 0, 0.6)
			turan.rotation.y = PI
			main.flags["hc_turan"] = true
			_hold_tablet()
			_stage = "sign"
		"session", "mirror":
			freudbot.visible = true
			freudbot.position = FB_PARK
			freudbot.rotation.y = PI
			_session_started = true
			if st == "mirror":
				_mirror_on(true)
				fb_face.visible = false
				twin_mode = "own"
				_stage = "mirror"
		"hall":
			main.flags["freudbot_1"] = true
			_monica_started = true
			door_body.position.x = 1.05
			door_open = true
			monica.visible = true
			monica.position = Vector3(1.2, 0, 4.2)
			if not a.has("at"):
				p.position = Vector3(-8.0, 0.05, 3.9)
				p.yaw = deg_to_rad(-90.0)
			_stage = "hall"
		"subway":
			cell_root.visible = false
			hall_root.visible = false
			sub_root.visible = true
			_riding = true
			_env.background_mode = Environment.BG_COLOR
			_env.background_color = Color(0, 0, 0)
			if not a.has("at"):
				p.position = SUBWAY + Vector3(-1.1, 0.05, -1.0)
				p.yaw = deg_to_rad(-90.0)
			p.seated = true
			p.crouch = 0.5
	p.rotation.y = p.yaw


func _node_by_id(id: String) -> Node:
	for n in main._all_with_meta(self, "id"):
		if is_instance_valid(n) and str(n.get_meta("id")) == id:
			return n
	return null


# ------------------------------------------------------------------ close-ups

func _rect(img: Image, x: int, y: int, w: int, h: int, c: Color) -> void:
	img.fill_rect(Rect2i(clampi(x, 0, img.get_width() - 1), clampi(y, 0, img.get_height() - 1), maxi(1, mini(w, img.get_width() - x)), maxi(1, mini(h, img.get_height() - y))), c)


func _disc(img: Image, cx: int, cy: int, r: int, c: Color) -> void:
	for y in range(cy - r, cy + r + 1):
		for x in range(cx - r, cx + r + 1):
			if x >= 0 and y >= 0 and x < img.get_width() and y < img.get_height() and (x - cx) * (x - cx) + (y - cy) * (y - cy) <= r * r:
				img.set_pixel(x, y, c)


## The hand-off, close: the white padding, the black tablet slab, her
## fingers under it, and the rolled paper going into his palm.
func _handoff_tex() -> ImageTexture:
	var w := 320
	var h := 200
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	var r := RandomNumberGenerator.new()
	r.seed = 1717
	img.fill(Color(0.88, 0.89, 0.88))
	for y in range(0, h, 40):
		_rect(img, 0, y, w, 2, Color(0.76, 0.77, 0.76))
	for x in range(0, w, 40):
		_rect(img, x, 0, 2, h, Color(0.76, 0.77, 0.76))
	# Carl's hand from the right, palm up
	var skin_c := Color(0.78, 0.6, 0.48)
	_rect(img, 200, 120, 120, 50, skin_c.darkened(0.08))
	for i in 4:
		_rect(img, 150 - i * 4, 112 + i * 13, 60, 11, skin_c)
	# the tablet slab, held between them
	_rect(img, 40, 64, 190, 54, Color(0.05, 0.05, 0.06))
	_rect(img, 48, 70, 174, 40, Color(0.22, 0.42, 0.32))
	_rect(img, 186, 96, 18, 10, Color(0.3, 1.0, 0.5))
	# her hand from the left; the fingers curled under the slab
	var her := Color(0.8, 0.66, 0.56)
	_rect(img, 0, 96, 60, 40, her.darkened(0.1))
	for i in 4:
		_rect(img, 40, 118 + i * 8, 110 + i * 6, 7, her)
	_rect(img, 0, 90, 30, 50, Color(0.16, 0.16, 0.19))
	# the rolled note, cream, between her fingertips and his palm
	for x in range(130, 196):
		for y in range(124, 136):
			img.set_pixel(x, y, Color(0.93, 0.9, 0.78).darkened(0.12 * absf(y - 130.0) / 6.0))
	_disc(img, 196, 130, 6, Color(0.85, 0.82, 0.7))
	_disc(img, 196, 130, 3, Color(0.7, 0.66, 0.55))
	for i in 400:
		var x := r.randi_range(0, w - 1)
		var y := r.randi_range(0, h - 1)
		img.set_pixel(x, y, img.get_pixel(x, y).darkened(r.randf_range(0.0, 0.12)))
	img.resize(w * 2, h * 2, Image.INTERPOLATE_NEAREST)
	return ImageTexture.create_from_image(img)


## The note: a torn printout corner, pencil, three cramped lines.
func _note_tex() -> ImageTexture:
	var w := 320
	var h := 200
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	var r := RandomNumberGenerator.new()
	r.seed = 915
	img.fill(Color(0.1, 0.1, 0.11))
	for y in range(30, 172):
		var x0 := 34 + int(sin(y * 0.4) * 3.0)
		var x1 := 290 - int(absf(sin(y * 0.23)) * 6.0)
		for x in range(x0, x1):
			img.set_pixel(x, y, Color(0.92, 0.9, 0.82).darkened(r.randf() * 0.05))
	# the printout's grey header the note was torn from
	_rect(img, 46, 38, 120, 6, Color(0.7, 0.7, 0.68))
	# pencil strokes in three lines
	for line in 3:
		var x := 52
		var y0 := 70 + line * 30
		var x_end := 210 if line == 2 else 270
		while x < x_end:
			var wl := r.randi_range(10, 34)
			for k in wl:
				var yy := y0 + int(sin((x + k) * 0.9) * 3.0)
				img.set_pixel(x + k, yy, Color(0.25, 0.25, 0.28))
				img.set_pixel(x + k, yy + 1, Color(0.35, 0.35, 0.38))
			x += wl + r.randi_range(5, 9)
	img.resize(w * 2, h * 2, Image.INTERPOLATE_NEAREST)
	return ImageTexture.create_from_image(img)


# ------------------------------------------------------------------ self-test

## Headless: the dream (its forty seconds), waking, Turan (the pump picks
## "What about Lynx?" first), signing with the sentence typed by _autotype,
## the FreudBot session with the pump's picks (the truths, "Mom?", the
## concession on the second ask), Monica, the lift and the ride; then the
## branches the pump can't reach: the note hand-off, both lies (a glyph
## examined, a bow in the ledger), Monica at +1 and -1, the mezcal line.
func selftest() -> void:
	# llvmpipe on a shared machine renders this floor at a frame or two a
	# second, and every line of dialogue costs a frame; the test is of the
	# script, so the level is hidden while it runs (as Observatory.gd does)
	visible = false
	var f: Dictionary = main.flags
	f["charged_observatory"] = true
	var t := 0.0
	# the trail through the leaves, after the family
	await check_walk("dream spawn->trail 40 m on", DREAM + Vector3(_trail_x(-40.0), 0, -40.0), null, Rect2(), 1.5)
	# the dream
	_stage = "dream"
	_dream_caps = [[1.0, LINES["dream"]["c1"]]]
	_dream_t = 0.0
	_dream_on = true
	main.player.position = DREAM + Vector3(0, 0.2, -12.0)
	while _dream_on and t < 120.0:
		await get_tree().process_frame
		t += get_process_delta_time()
	_dream_on = false
	print("ok dream receding=", _receding, " t=", snappedf(_dream_t, 0.1))
	# waking runs straight into Turan; the door brings her at once
	_door_knocked = true
	_wake_and_turan_only()
	t = 0.0
	while _stage != "sign" and t < 240.0:
		await get_tree().process_frame
		t += get_process_delta_time()
		if f.has("hc_woke"):
			_door_knocked = true
	print("ok turan stage=", _stage)
	# signing; _sign() flows into the wait and the session and the nurse
	var tb := _node_by_id("tablet")
	if tb:
		_sign_and_rest()
	t = 0.0
	while _stage != "leave" and t < 600.0:
		await get_tree().process_frame
		t += get_process_delta_time()
		if _stage == "wait":
			_door_knocked = true
	print("ok session signed=", f.has("hc_signed"), " freudbot_1=", f.has("freudbot_1"), " conn=", main.connection, " pressure=", main.pressure)
	# the door is open: out to Monica in the hallway, and on to the lifts
	walk_ignore = [monica, nurse, freudbot]
	await check_walk("cell->monica (hallway)", "monica", Vector3(0, 0.05, 0))
	await check_walk("cell->lift", "lift", Vector3(0, 0.05, 0))
	# Monica, outside the door
	await _monica()
	print("ok monica hallway=", f.has("hc_hallway"), " spa=", f.has("spa_booked"))
	await _arrive(monica, 30.0)
	# the lift, the ride, the end (no load in the self-test)
	await _leave()
	print("ok leave pip_active=", f.has("pip_active"), " done=", f.has("holdingcell_done"))
	# the branches the pump does not take
	await _handoff(true)
	print("ok note ev=", f.has("ev_turan_note"))
	freudbot.visible = true
	main.glyphs_found = maxi(1, main.glyphs_found)
	f["bowed"] = true
	var c0: float = main.connection
	_force = 0
	await _round_hallucinations()
	_mirror_on(true)
	_force = 0
	await _round_bow_answer_only()
	_mirror_on(false)
	print("ok lies conn ", c0, " -> ", main.connection)
	f.erase("cinematic")
	main.trust["monica"] = 1
	_monica_started = false
	monica.visible = true
	monica.position = Vector3(0.9, 0, 3.9)
	await _monica()
	main.trust["monica"] = -1
	_monica_started = false
	monica.visible = true
	monica.position = Vector3(0.9, 0, 3.9)
	await _monica()
	print("ok monica branches spa_booked=", f.has("spa_booked"))
	f["drank_mezcal"] = true
	print("ok mezcal=", _drank_mezcal(), " bowed=", _bowed())
	f.erase("drank_mezcal")
	f.erase("cinematic")
	sub_root.visible = false
	cell_root.visible = true
	hall_root.visible = true
	_riding = false
	main.player.seated = false
	main.player.crouch = 0.0
	main.player.position = Vector3(0.0, 0.05, 3.6)
	await main.selftest_all_interactables()
	visible = true


func _wake_and_turan_only() -> void:
	await _wake()


func _sign_and_rest() -> void:
	await _sign()


## The BOW answer and its consequence, without the mirror's free moment.
func _round_bow_answer_only() -> void:
	var s: Dictionary = LINES["session"]
	var pick: int = await _ask(s["bow_choices"])
	if pick == 0 and _bowed():
		await _lie(s["ledger_bow"] % _bow_entry(), s["bow_lie_log"])
	else:
		_truth()
