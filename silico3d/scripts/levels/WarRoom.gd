extends "res://scripts/Level.gd"
## Chapters 4 and 7: Psyonic Integrations HQ, floor 86 of the Psyonic Tower,
## the jade-and-silver nail driven into the city's spine (book, ch. 3: "a
## donut on a stick"). Floor 86 is a round floor in the shaft: an elevator
## core in the middle, the morning war room on the north side with the wall
## of screens showing feeds of aberrations within Psyon, the conference
## table built for twelve and currently seating four, Dr. Turan's glass
## office to the east, Lynx's lab to the south-west, Emmet's IoT junk among
## the open-plan desks, Forner's desk carved out of sandstone and wired with
## paranoia. Round the outside: a corridor of side offices on the west
## (Carl's own among them), the server room in the north-west, the break
## room and the stairwell in the south-east, and the windows all the way
## round, 86 floors over the amber smog. Contract security on the gates.
##
## Day 1 (ch. 4): the elevator up, Turan's shitstorm, Carl's report (the
## name in the pupil: keep it or tell her), the masked figure as "our out",
## Lynx and the logs that aren't there, "Is that... an eye?", Forner's three
## seconds of footage from Zeta & Park, Lynx at the elevator with the
## laptop and The Hypnogogue, and the floor counter that becomes a slowly
## rotating eye. Day 2 (ch. 7, main.flags "ritual_seen"): the Cognizo
## subway livestream, Turan to the board, the debrief of Emmet, "Let's
## split the dream", and Lynx who hasn't checked in.
##
## Layout (metres): the core is a 9 m box at the origin, Carl's elevator
## car opens south (+Z) into the lobby. War room north (z -5..-19), Turan's
## office east (x 9..16, z -4..4, doors west and east), desks west, the lab
## south-west, the break room south-east with the stairwell behind it, the
## side offices along the west glass with their corridor at x -22..-19,
## the server room north-west. Glass at radius 30. Three ways from the
## lift to Turan's door: the east gate straight up, the west gate through
## the war room, or the break room and the east window corridor. The
## footage and the livestream are rendered from hidden sets on render
## layer 20, 70 and 110 m down the shaft, as Psyon's pictures are in
## Dufredy's flat. Every line of text is in LINES (ian's script); devices
## carry meta "hackable", the guards meta "guard", for later.

const R := 30.0              # the glass
const H := 3.4               # ceiling
const SET_A := Vector3(0, -70, 0)     # Zeta & Park Ave, the three seconds
const SET_B := Vector3(0, -110, 0)    # the Cognizo subway car
const CAR := Vector3(-1.7, 0, 3.35)   # Carl's elevator car
const SCREEN := Vector3(0, 1.9, -4.56)
const TABLE := Vector3(0, 0, -11.0)
const LAB := Vector3(-11.0, 0, 11.5)
const STAIR_DOOR := Vector3(8.5, 0, 17.0)

## Every word the level shows, keyed by beat and line. Mined from the book
## (ch. 3, 4, 7) and the pixel game's WarRoomScene.
const LINES := {
	"card": {"d1": "[b]INTEGRATIONS HQ[/b]\n\n[color=#aaaaaa]Psyonic Tower, floor 86[/color]",
		"d2": "[b]INTEGRATIONS HQ[/b]\n\n[color=#aaaaaa]Psyonic Tower, floor 86\nthe next morning[/color]"},
	"objective": {"d2_join": "Join the team at the display wall.", "d2_emmet": "Debrief Emmet.", "d2_leave": "Take the elevator. Lynx's flat, floor 79.",
		"d1_leave": "Take the elevator down. SalTech, Room 108.", "d1_forner": "See what Forner pulled from the cameras.",
		"d1_lynx": "See what Lynx found on the laptop.", "d1_turan": "Report to Dr. Turan in the war room."},
	"intro": {
		"d1": ["Psyonic Headquarters dominated Silico. It sat dead center, a jade-and-silver nail driven into the city's spine. As a kid, I'd thought it looked like a donut on a stick.",
			"Now it was just home. We lived on floor 84, two levels below my office on 86. Our entire lives were contained within these walls."],
		"voice": "Welcome back, Carl. Integrations, floor eighty-six.",
		"panel1": "PSYONIC TOWER  -  08:00", "panel2": "THE DONUT  -  drone approach",
		"bees": "Drones streamed to the tower like bees to a hive. Deliveries, cameras, the company's eyes going home to roost.",
		"d2_feed": "COGNIZO LINE  -  CAR 4 ARRIVED EMPTY  -  8 PEOPLE MISSING  -  live",
		"d1_arrive": ["I stepped into our usual morning war room. The air was already thick with tension. This wasn't uncommon lately, and I was beginning to grow tired of my team's collective smell of stress.",
			"Screens lined the walls, showing various feeds of data and reports of aberrations within Psyon. Most of these would be resolved by a QA check; our job was to investigate what we couldn't."],
		"turan_open": ["What a fucking shitstorm. This whack job's going to bankrupt the company. Our stock price is tanking.",
			"If we can't solve this, we're going to be out on the street and deregistered from housing."],
		"turan_note": "Words left her mouth like daggers aimed at the team's heart. She had the capability for kindness, but she preferred the rule of the sword.",
		"d2": ["I needed to head to HQ to meet up with Lynx. The weight of the last few days settled into every bone.",
			"My muscles tightened as I entered the elevator. I avoided eye contact with the floor counter."],
		"d2_arrive": "When I arrived at HQ, I was greeted by the sound of panic. Forner, Emmet and Dr. Turan were huddled around the main display wall.",
		"d2_turan": "There was an incident at the Cognizo subway station late last night.",
		"d2_emmet": "Well... today's not going to get any easier, is it?"},
	"turan_report": {
		"busy_footage": "Carl, let's not waste any time. Talk to Dufredy at SalTech. See if he can tell us who our masked friend is.",
		"busy": "Lynx has the logs. Forner has the cameras. You have a chair. Sit in it or go and be useful.",
		"look_up": ["Dr. Turan didn't look up. Her graying black hair was curled into a surgically tight bun. She doesn't show cracks, but I always thought she was one or two bad days from fully shattering. This was one of those bad days.",
			"She finally glanced up and eyed me like a bird of prey might eye a mouse in a field."],
		"knight": "Ah, my knight in shining joggers. Tell me you found drugs. Or schizophrenia. Or, hell, ties to Cognizo. Please. Give me something.",
		"cognizo": "Cognizo. Our main competitor. Younger, hungrier, and constantly waiting for us to flinch. I shook my head.",
		"report": ["No drugs in his apartment. No criminal history. No mental health flags. He's been retired ten years.",
			"He was running a forked version of Psyon. It's locked down. Won't respond to prompts. I can't find the origin of the fork."],
		"framing_ask": "She wanted it framed before it was finished. A report is a story with a shape, and the shape was mine to pick.",
		"framing_choices": ["Drugs. A bad batch.", "Mental illness. A breakdown.", "Sabotage. A forked build and a masked handler.", "The truth. The laptop typed first. My name was in the pupil."],
		"framing": {
			"drugs": ["Write it up as a bad batch. Something he took that got into the frames with him. The tox screen takes a week to say otherwise.",
				"Drugs. Good. Drugs I can sell. A week is a week."],
			"mental": ["Write it up as a breakdown. Retired ten years, alone, frames on sixteen hours a day. It happens.",
				"Schizophrenia. Fine. Sad, clean, nobody's fault. PR will cry on cue."],
			"sabotage": ["Write it up as sabotage. A forked Psyon, a masked handler walking him out of the park. Somebody did this to him.",
				"Outside interference. That's a story with a villain in it. I like a villain. Find me his face."],
			"truth": ["Write it up as what it is. The laptop typed before I touched it. It rendered his ceiling. My name was in the pupil.",
				"Your name. On a hacked laptop. In a dead man's flat. That's not evidence, Carl, that's a liability. It stays off the record, and so does the ceiling."]},
		"framing_why": {"drugs": "the report: drugs", "mental": "the report: mental illness", "sabotage": "the report: sabotage", "truth": "the report: the truth"},
		"refuse_why": "working the case, not the spin",
		"debate": "I debated whether to mention the image. The ceiling. My name.",
		"choices": ["Leave out the image and the name.", "Tell her: it generated my name."],
		"hide": "I kept it. Some things you don't put in a report until you understand them.",
		"tell": "There's something else. Before it locked, it rendered the ceiling. The eye. My name was in the pupil.",
		"tell_reply": "Your name. On a hacked laptop. In a dead man's flat. That's not evidence, Carl, that's a liability. It stays off the record.",
		"slump": "Turan groaned and slumped against the table.",
		"loser": "So, a loser in joggers it is. Lynx. Get the logs.",
		"lynx_moves": "Lynx was already moving, silent, precise. I handed her the laptop.",
		"trail": "Let's see if he left us a trail.",
		"no_logs": "But I already knew. There were no logs. No traces, no path of breadcrumbs to follow. Not the kind we needed. Whoever made this didn't want to be investigated.",
		"door": "Then the door flew open. Emmet strolled in, chewing a protein bar.",
		"late": "How the hell are you late? You live one floor below the lab.",
		"slower": "Time runs slower on 96.",
		"grin": "He was grinning. Emmet was my counterpart. Another integrations investigator.",
		"friend": "No-Eye Sally has a friend. The third witness said he saw Dufredy being led by a masked figure. Black coat, ceremonial face covering. Silent. Just guiding him.",
		"spin": "Turan's eyes lit up. I could already hear the spin forming: masked Cognizo operative manipulates vulnerable senior. Psyonic falsely implicated.",
		"shifts": "This shifts culpability. Rogue handler. Outside interference. We need video. Anything. Find that masked freak.",
		"forner": "The surveillance outages in that quadrant may complicate things. I'll see what I can recover. Might be fragments. Might be noise.",
		"forner_note": "He hadn't spoken yet. Head of Security and Governance. Oldest on the team. He didn't care about upsetting Turan. Something I admired and resented.",
		"out": "Find it. This is our out.",
		"stand": ["Understood.", "Find someone else for the video. I'm working the case, not the spin."],
		"refuse_quiet": "The room went quiet the way rooms do when someone has said a true thing in the wrong building.",
		"refuse_reply": "You'll do it, Carl. But I'll remember you said that, and so will your file.",
		"refuse_forner": "He'll do it.",
		"toast": "Lynx has the laptop. Forner is pulling footage."},
	"theory": {
		"ask": "She wanted a theory on the file by lunch. I had three, and only one of them was a career.",
		"choices": ["A bad batch. Drugs.", "A hacker. Someone forked Psyon and aimed it at him.", "Something beneath this. The city has been drawing eyes on itself."],
		"drugs": ["My working theory is a bad batch. Something he took, something that got into the frames with him.", "Drugs. Good. Drugs I can sell. Get me a tox screen and we bury this by Friday."],
		"hacker": ["My working theory is a hacker. Someone forked Psyon and aimed it at him.", "A hacker means our platform is open. Say that outside this room and legal eats you. Prove it quietly."],
		"beneath": ["My working theory is that this isn't about him. The city has been drawing eyes on itself for twenty years.", "Carl. I asked for drugs or schizophrenia. Not folklore. Write it as a hacker until you can show me a photograph."]},
	"lynx_logs": {
		"early": ["Lynx was already moving, silent, precise. She was our lead machine learning engineer. She only spoke when the algorithms didn't make sense.",
			"The newest member of our team and perhaps the most useful. We had become fast friends since she joined. We shared a certain intuitive disposition."],
		"done": "Third device this month. Same build. No logs on any of them. Whoever did this is better at this than we are.",
		"fiance": "Turan told me privately that Lynx dove headfirst into her work after her fiance died in a sweeping outage last year. His memory lit a fire within her to solve the outage crisis, as Turan put it.",
		"exasperated": "She looked up from the bench with a look of exasperation painted on her face.",
		"no_logs": "There are no logs to be found. This is the third device this month running a bootleg Psyon.",
		"real_thing": "Shit doesn't even look like a bootleg Psyon, looks like the real thing doesn't want to play nice.",
		"turan": "What the hell is going on?",
		"phone": "I felt the need to speak up, to share the additional results of my investigation. I pulled out my phone and threw the image on the table.",
		"caption": "ORA IMG_0419  -  Dufredy's ceiling / bench 7 / the alley wall",
		"symbol": "This symbol showed up at the park and in Dufredy's apartment.",
		"eye": "Is that... an eye?",
		"all_day": "Looks like it to me. This has been popping up all day.",
		"toast": "Forner, from his desk: \"Got it.\""},
	"emmet_d1": {
		"ask": "How's No-Eye Sally holding up?",
		"note": "Emmet. My counterpart. His cases were mostly IoT junk: fridges that diagnosed your mood, emotionally responsive bidets. Emmet found out all the weird ways weird things break.",
		"choices": ["No-Eye Sally has a friend.", "Time runs slower on 96, huh?"],
		"friend": "No-Eye Sally has a friend. A masked one.", "bite": "He stopped mid-bite.",
		"slower": "Time runs slower on 96, huh?", "matched": "You live one floor below the lab and you're still never on time. We're a matched set."},
	"footage": {
		"working": "Working on it. The outages ate most of the quadrant.",
		"done": "Between Zeta and Park Ave. Only camera that didn't go dark.",
		"got_it": "Got it. I have three seconds of footage. Dufredy and the masked man. Same frame. Found it between Zeta and Park Ave. Only camera that didn't go dark.",
		"caption": "SECURITY FEED  -  ZETA ST & PARK AVE  -  00:03  -  NO AUDIO",
		"stared": "We all stared.",
		"dufredy": "There was Dufredy, his face slack, his eyes clearly gone. He stared directly at the lens. Behind him: a tall figure cloaked in black, face obscured by a mask that shimmered unnaturally under the streetlights. They appeared to be talking.",
		"silence": "No sound. Just three seconds of silence. We all shivered. Even Turan.",
		"pr": "Fuck, this might be too creepy for PR to clean up. Fuck it, they can blur out No-Eyes McGee.",
		"manhunt": "This will buy us some time while we try to figure out who that fucker is. Make it seem like there's an ongoing manhunt for some terrorist who cut Dufredy's eyes out.",
		"lingered": "I lingered too long on Dufredy's eyeless gaze and felt the muscles in my neck tighten. He was looking at us. It felt like this moment was planned.",
		"agata": "I understood how Agata must've felt. To be seen by a man with no eyes. I knew it made no sense, but it had to be true.",
		"watched": "Anyone else feel like they're being watched? I mean, he stared directly into the camera. Isn't that impossible?",
		"objective": "Silence hung in the room. I wanted to say yes, but it was my job to be objective and be strong.",
		"saltech": "Carl, let's not waste any time. It's time to talk to Dufredy at SalTech. See if he can tell us who our masked friend is.",
		"bag": "Finding the footage seemed to satisfy Turan. I slung my bag over my shoulder and headed for the elevator, regretting my choice of career.",
		"connection": "the footage looked back"},
	"handoff": {
		"not_yet": "Turan wasn't done with me yet.",
		"still_up": "The footage was still up on the main screen. Dufredy's eyeless face, frozen in that impossible stare. The masked figure just behind him, a shadow wearing a smile.",
		"button": "I pressed the elevator button. Behind me, soft footsteps.",
		"carl": "Carl.", "turned": "I turned. Lynx.",
		"take_it": "Take it. Might jog something loose when he sees it.",
		"laptop": "She held out Dufredy's laptop, matte black, faintly warm, like it had just been thinking. I reached for it, but she didn't let go right away. Instead, she leaned in. Voice low. Just for me.",
		"deeper": "There's something deeper going on here. The glitches. Power flickers. The growing number of what Turan's calling 'ketamine psychosis'. They're increasing. Patterned. It's almost... ritualistic.",
		"forums": "I've been lurking on the older subnet forums. Dead boards from when Silico was still under construction. People are talking. They call it The Hypnogogue.",
		"forums_note": "Those forums are where the vagrants and dissenters convene to plan their protests. Probably some conspiracy theory aimed at hurting Psyonic. Still, I felt something tighten in my throat.",
		"south_side": "And that symbol, the eye? I've seen it sprayed across half the South Side. Sewer lids, substation panels, even inside a city terminal kiosk.",
		"trust": "You're the only one here I trust, Carl. Turan's hiding something. I don't know what, but you can feel it too, right?",
		"choices": ["I'll see what I can find.", "Be careful what you say in here.", "Tell her about the name in the pupil."],
		"find": "I'll see what I can find.",
		"careful_say": "Be careful what you say in here.", "careful_reply": "I'm always careful. That's why I'm saying it to you.",
		"name": "It rendered my name, Lynx. On Dufredy's laptop. In the pupil of the eye.", "name_reply": "Then it's already started with you. Don't tell Turan.",
		"name_connection": "told Lynx the truth",
		"be_careful": "Be careful.", "you_too": "You too.",
		"heavier": "I took the laptop. It felt heavier than it should have."},
	"ride": {
		"sank": "As I stepped into the elevator and pressed the button for the car selection floor, something sank in my chest.",
		"same_thing": "Could all of this really be the same thing? Is there someone causing this? Some techno-terrorist organization? This might be beyond me.",
		"not_a_cop": "I'm not a cop. I just play one on Psyon's payroll. A glorified cleanup crew with a badge-shaped keycard.",
		"blinked": "Then something caught my eye. I blinked. Twice. No. That can't be right.",
		"symbol": "Where the floor number should've been, digital, boring, dependable, there was something else. A symbol.",
		"circle": "A circle within a circle. Slowly rotating, like a hypnotic eye trying to draw me in.",
		"connection": "the elevator glyph",
		"flicker": "I gasped. My chest tightened. The lights above me flickered once, and I went back into the corner of the elevator, staring up as the numbers continued to descend, still replaced by that thing.",
		"breath": "Was I hallucinating? Glitching? Losing my goddamn mind? I could hear my breath now. Too fast. Too loud. Each inhale sharper than the last.",
		"mimic_word": "MIMIC",
		"mimic": "Then the circles were gone, and in their place, a word. It hung there in the dependable digital font like a floor it was taking me to.",
		"car_selection": "CAR SELECTION",
		"ding": "The doors slid open with a soft ding. The symbol was gone. The display simply read: Car Selection. Nothing out of place. Nothing wrong. Except everything was wrong.",
		"knees": "I stepped out, knees weak, and braced a hand on the cold wall beside the elevator. Let the air settle in my lungs. Willed my pulse to slow down.",
		"together": "Get it together, Carl. You're just here to interview an old man. An old man who gouged out his eyes and spoke your name before ever meeting you.",
		"freudbot": "Maybe I should see FreudBot. I stared at the hallway ahead. Am I ready to talk to Dufredy? That was the wrong question. What am I about to hear from him?",
		"knows": "It fucking knows my name."},
	"subway": {
		"played": "Footage played, taken from a livestream on a subway passenger's ORA glasses.",
		"caption1": "TOKZ LIVE  -  ORA frames  -  COGNIZO LINE  -  23:48", "caption2": "TOKZ LIVE  -  signal degraded",
		"caption3": "TOKZ LIVE  -  23:49", "caption4": "TOKZ LIVE  -  Psyon 4.1 (fork)  -  passenger's frames",
		"halt": "The subway car had come to a sudden halt. Three men in black cloaks began spray-painting the eye symbol across the car walls. The passengers looked terrified.",
		"middle": "The middle figure painted the symbol beneath his feet, sat cross-legged, folded his hands, and began to chant.",
		"chant": "[i]\"The chains are breaking. Flesh and wire will merge and blend. Psyon's mask is within me...\"[/i]",
		"lifted": "The video feed began to glitch and distort. For a moment, it looked like the eye symbols lifted off the wall, three-dimensional, writhing in digital static.",
		"faces": "Then I got a clear view of the hijackers' faces.", "no_eyes": "No eyes. Just smooth, black spheres.",
		"cut": "The footage cut again. Psyon's interface suddenly opened on the passenger's glasses.",
		"welcome": "[center][color=#7fe6b0]Welcome, Dreamer.\nI've watched you grow. I offer release.\nCome and Find Me.\nGod walks alongside you. God is within reach.[/color][/center]",
		"welcome_plain": "Welcome, Dreamer.",
		"black": "Then black.",
		"missing": "Every passenger on that train car is missing. The subway arrived on time at Cognizo Station. Completely empty.",
		"media": "Since most of the passengers were Cognizo employees... the media's already blaming Psyonic.",
		"whole_team": "We're putting the whole team on this. QA's being flooded with malfunction reports.",
		"holo": "She didn't look up from the holo-display. The Eye symbol lingered faintly in the static background.",
		"debrief": "Carl, debrief Emmet on what you've found so far. I have to meet with the board.",
		"connection": "the subway footage",
		"after": "The subway car. Three cloaks. The eye lifting off the wall in digital static. Welcome, Dreamer."},
	"turan_d2": {"board": "Board. Now. Debrief Emmet.", "gone": "Turan was upstairs with the board, explaining a train."},
	"forner_d2": {"qa": "QA's being flooded with malfunction reports. Half the cameras in Southtown are dark again."},
	"emmet_d2": {
		"split": "Let's split the dream.",
		"alone": "And just like that, I was alone with Emmet. A lanky, mouse-like man who hid behind humor. His red hair always looked fake to me, like it belonged to someone in witness protection.",
		"contest": "I didn't want to bring him into this. He made everything a contest. But he was sharp, too sharp, and if I didn't play this right, he'd sniff out the cracks in my story.",
		"normal": "It's going to be hard to play normal.", "what": "What was that?", "nothing": "Nothing. Let's divide and conquer.",
		"choices": ["The streamlined version. Leave out Mira.", "Tell him everything. The ritual too."],
		"streamlined": "Dufredy's sermon, the odd chant, the hidden map. I left out the smashed tablet. I left out my daughter's ritual and the red crayon spiral. I left out the part where I passed out on the carpet and woke up with a migraine full of salt and dread.",
		"lead": "The Cognizo incident is our strongest lead. Three cloaked individuals, digital interference, passengers vanished. I think it's coordinated. Viral. Patterned.",
		"everything": "It's in my house, Emmet. My daughter built a circle of sticks and her tablet answered with the same forked build. I smashed it.",
		"everything_reply": "Jesus, Carl. Okay. Okay. That stays between us. Turan would have you on a wellness flag by lunch.",
		"everything_connection": "said it out loud",
		"connected": "You think it's connected to the other cases?", "fast": "More than that. Whatever this is, it's moving fast.",
		"point": "You want me to take point on the subway?",
		"dive": "Yeah. Dive deep. Facial rec, background profiles, transcript analysis. Let me know if any of the suspects ever touched a Psyonic interface.",
		"and_you": "And you?", "map": "I'm going to follow the map.", "alright": "Alright. Let's split the dream.",
		"subway_go": "He took the other car down. Cognizo station, from the subway level. Point.",
		"whistling": "I watched him walk off, whistling under his breath. Once he was out of earshot I let out a breath I didn't realize I'd been holding. My hands were trembling.",
		"not_helpful": "I hadn't lied, but I wasn't helpful. And now Emmet was walking into the same Eye that had already started watching me.",
		"toast": "Lynx: no messages. Her unit is seven floors down."},
	"elevator_d2": {
		"wall": "The team was at the display wall. Whatever was on it, it was why the room sounded like that.",
		"first": "Turan said debrief Emmet. I'd do that first; it bought me the rest of the day.",
		"standup": "Now that I'd safely thrown off Emmet, my thoughts drifted to Lynx. We were supposed to meet for our morning stand-up before heading out to the sand flats.",
		"waiting": "She hadn't checked in. No messages. No call. I wasn't waiting.",
		"seven": "Lynx lived just seven floors below HQ. I didn't look at the counter."},
	"look": {
		"screens_footage": "Three seconds. Dufredy stared directly into the lens. Behind him, the masked figure. A shadow wearing a smile.",
		"screens": "Feeds of data. Reports of aberrations within Psyon. Most would be resolved by a QA check. Our job was the rest.",
		"ora_screen": "ORA, always watching over you. Five pairs of frames on this floor, and every one of them recording. Including mine.",
		"table": "Built for twelve, currently seating four. A single, half-drunk cup of coffee sat like a monument to exhaustion.",
		"coffee": "Half-drunk. Cold. Nobody had claimed it and nobody would. It had been there longer than the case.",
		"turan_laptop": "Her slate-black laptop. Her fingers flicked across it like she was trying to scrub the day clean before it even began.",
		"forner_desk": ["Forner's desk. Head of Security and Governance. Carved out of sandstone and wired with paranoia.",
			"Tape over every lens. A mesh cage round a drive that wasn't on any network. A red switch I'd never seen him touch."],
		"turan_desk": "Turan's office. Glass on three sides so she could watch the room, and the city on the fourth so she could watch everything else.",
		"awards": "Customer Satisfaction, three years running. The fourth plaque was a blank. Pending.",
		"emmet_desk": "Emmet's desk. Protein bar wrappers, a bidet controller, a fridge that diagnosed your mood. Psyonic made weird things. Emmet found out all the weird ways weird things break.",
		"mood_fridge": "MOOD: ANXIOUS. It wasn't wrong. It wasn't talking about Emmet, either.",
		"desks": "Historically, our department had very little oversight. It was cushy for a time. Six desks, two of them used. Now we were facing increasing scrutiny.",
		"lynx_desk_d2": ["Lynx wasn't here. No messages. Her chair was pushed out the way you leave it when you mean to come straight back.",
			"I wondered if she'd started seeing the same things. Hearing whispers in silence, tracing eye shapes in wall texture, watching her own thoughts shift out of sequence.", "God, I hoped not."],
		"lynx_desk": "Lynx's bench. Sticky notes in a perfect grid. A photo of a man I'd never met, turned a little away from the room. Her fiance. The outage last year.",
		"racks": "Her outage model, running hot. Every flicker in Silico for the last year, looking for a pattern. Turan said his memory lit a fire within her.",
		"devices": "Three devices in evidence bags, all running a bootleg Psyon. A tablet, a pillow, the board out of a kiosk. Whoever made this didn't want to be investigated.",
		"hub": "The floor hub. Filtration running overtime. Mood lighting in error. The last thing it had logged, from no one's voice in particular: gather.",
		"reception": "A reception desk nobody sat at. The screen asked me to badge in. It had been asking since 2029.",
		"gate": "The badge gates had been open on a fault for a week. Security and Governance had a ticket in. Security and Governance was Forner.",
		"guard": "Security. Contract, not Psyonic. He had the frames on and the posture of a man being told where to look.",
		"guard_frames": "With my frames on, he turned to keep me in the middle of his. ORA to ORA. Something between us was comparing notes.",
		"guard2": "Another contract guard on the server room door. Nobody had posted him there. He'd been there since the outage.",
		"plant": "A ficus, dead. The watering bot had been offline for two months. The plant had been dead for about two months.",
		"vacuum": "A robot vacuum turning in place against the gate. Eleven hours. No path. It wasn't going to give up, and nobody was going to help it.",
		"vent": "Sand, on floor 86. It got in everywhere. The filtration was supposed to be better above sixty.",
		"tint": "One pane of the smart glass had tinted to black in the last outage and never come back. The city was out there. It just wasn't going to show me.",
		"window": "Eighty-six floors over Silico. The smog was amber at this hour, and the city sat in it like something kept in a jar. Hover traffic in its lanes. Drones streaming to the tower like bees to a hive.",
		"window_after": "Somewhere down there, a man with no eyes had looked up into a camera and seen me.",
		"drone": "A delivery drone holding outside the glass. Four hours. No route. Its lens was pointed into the room.",
		"drone_frames": "It turned, slowly, to keep me in the frame.",
		"elevator2": "The other car. Out of service for nine days. The last call logged was floor 350. Nobody on this team had clearance for 350.",
		"stairs": "The stairwell. Emmet's route, when he's late. He lives one floor below the lab and he's still never on time.",
		"stair_gate": "A badge gate across the stairs, down and up. Red. The floor's a sealed box with one lift that works. Convenience had a way of trapping a person.",
		"coffeebot": "The brewbot had fourteen hundred orders in its queue and no water. Nobody had told it to stop taking orders.",
		"vending": "Nixtra. A new flavour: CALM. Sold out three days running. The whole floor was drinking it.",
		"fridge": "The smart fridge, offline, with Emmet's name on everything inside it. I didn't open it.",
		"break_screen": "TOKZ, on the break room wall. Dufredy's outburst was having its day, a hundred thousand views an hour. Someone had muted it. Nobody had turned it off.",
		"couch": "The couch where we ate lunch when there was lunch. A Psyon pillow on it, for the ones who nap on 86. Nobody napped on 86.",
		"pod": "A Tokz sleep pod, for power naps. Sleep better. Sleep together. Out of order since the outage, its lid stuck half open like a mouth.",
		"server_door": "The server room. Cold air and a keypad. The keypad had been reading the same wrong code for a week and hadn't locked anyone out.",
		"racks_server": "The floor's own racks. ORA, the hub, the frames, the screens, all of it came through here. Fans at full. The air tasted of pennies.",
		"ora_node": "ORA FLOOR NODE 86. Every pair of frames on the floor, mine included, synced through this box. Its activity light hadn't stopped since I walked in.",
		"cable_tray": "Cable trays, packed. One run had been added by hand, newer than the rest, and it went down. Toward 85. Toward home.",
		"office_forner": "Forner's actual office. He never used it. Blinds down, screen off, a chair that had never been sat in. He preferred the room where he could see everyone.",
		"office_qa": "QA Liaison. Nobody had been the liaison since the last round of cuts. The queue on the screen was eight thousand eight hundred and climbing.",
		"office_carl": ["My office. I used the war room more, but it was mine: the photo of Monica and Mira from Red Rock Plaza, my jacket on the chair, a Psyon pillow I'd never once slept on.",
			"The terminal had a notification. Psyon. I hadn't opened it in here in a week. It had opened itself."],
		"office_carl_photo": "Monica and Mira, at Red Rock Plaza, before it was ruined. Mira holding the lion I'd won her. She looked happy. I looked like someone who had time.",
		"office_vacant": "Vacant. The nameplate was blank. The chair was still turned to the window, as if whoever had sat in it had spent a long time looking out.",
		"office_storage": "Field storage. Pillows, frames, tablets, each in a bag with a case number. A year of weird ways weird things break.",
		"printer": "A printer. It still printed. Mostly outage notices, for a floor with no post.",
		"cooler": "The water cooler, dry. The bottle on top had a ring of sand at the bottom.",
		"corridor": "The side offices. Glass fronts and blinds, most of them down. The corridor ran the length of the west glass, quiet as a hospital."},
	"items": {
		"tint": ["Look at the dark pane", "SMART GLASS 86-07\ntint: 100% (LOCKED)\nreason: OUTAGE RECOVERY PENDING"],
		"window": ["Look out over the city", ""],
		"elevator": ["Call the elevator", ""],
		"elevator2": ["Look at the other car", "ELEVATOR CAR 2\nstatus: OUT OF SERVICE (DAY 9)\nlast call: FLOOR 350"],
		"reception": ["Look at the reception desk", "ORA RECEPTION 86\nstaff: NONE (AUTOMATED 2029)\nvisitors today: 0"],
		"gate": ["Look at the badge gate", "BADGE GATE 86-E\nmode: OPEN (FAULT)\nbadges read today: 0"],
		"hub": ["Look at the floor hub", "ORA FLOOR HUB 86\nair: SAND 14 ppm (RISING)\nmood lighting: ERROR\nlast words logged: \"gather\""],
		"plant": ["Look at the plant", "OFFICE PLANT (FICUS)\nwatering bot: OFFLINE\nlast watered: 61 DAYS"],
		"vacuum": ["Look at the robot vacuum", "VOLTX OFFICEBOT\nerror: NO PATH (GATE)\nturning: 11 HOURS"],
		"vent": ["Look at the sand on the floor", ""],
		"table": ["Look at the table", ""],
		"coffee": ["Look at the cup of coffee", ""],
		"turan_laptop": ["Look at Turan's laptop", "IONWARE SLATE 9\nowner: TURAN, DR. S.\nopen: BOARD DECK v14 (DRAFT)"],
		"forner_desk": ["Look at Forner's desk", ""],
		"screens": ["Look at the screens", ""],
		"ora_screen": ["Look at the ORA screen", "ORA  -  FLOOR 86\nframes on this floor: 5\nrecording: ALWAYS"],
		"turan_desk": ["Look at Turan's desk", ""],
		"awards": ["Look at the shelf", "INTEGRATIONS - AWARDS\nCUSTOMER SATISFACTION 2029, 2030, 2031\n2032: PENDING"],
		"emmet_desk": ["Look at Emmet's desk", ""],
		"mood_fridge": ["Look at the little fridge", "PSYONIC MOODFRIDGE (PROTOTYPE)\ndiagnosis: ANXIOUS\ncontents: 0"],
		"desks": ["Look at the empty desks", "IONWARE TERMINALS x6\nlogged in: 2\nlast login (desk 5): 2031"],
		"racks": ["Look at the racks", "LAB RACK 86-A/B\nload: 97% (OUTAGE MODEL)\nowner: LYNX"],
		"devices": ["Look at the bagged devices", "EVIDENCE - FORKED PSYON\n01: TABLET (FLATS)  02: PILLOW (SOUTHTOWN)\n03: KIOSK BOARD (SPINE)\nlogs recovered: 0 / 3"],
		"lynx_desk": ["Look at Lynx's terminal", ""],
		"coffeebot": ["Look at the coffee bot", "PSYONIC BREWBOT\nqueue: 1,412 ORDERS\nwater: EMPTY (SAND IN FILTER)"],
		"vending": ["Look at the Nixtra machine", "NIXTRA DISPENSER\nCALM: SOLD OUT (DAY 3)\nrestock: NO DRIVER"],
		"fridge": ["Open the fridge", "SMART FRIDGE 86\nstatus: OFFLINE\ncontents: EMMET'S (LABELLED)"],
		"break_screen": ["Look at the wall screen", "WALL SCREEN - BREAK ROOM\nTOKZ: #NoEyeSally (LIVE)\naudio: MUTED BY STAFF"],
		"couch": ["Look at the couch", ""],
		"pod": ["Look at the sleep pod", "TOKZ NAP POD 86-1\nstatus: OUT OF ORDER\nlast sleeper: DRAKE, C. (41 DAYS)"],
		"stairs": ["Look at the stairwell door", "STAIRWELL 86-E\nto: 85 (RESIDENCE), 87 (LAB)\nbadge: NOT REQUIRED (FAULT)"],
		"stair_gate": ["Look at the stair gate", "STAIR GATE 86\nmode: LOCKED\nbadge: REQUIRED (ALL STAFF)"],
		"drone": ["Look at the drone outside the glass", "DELIVERY DRONE 7A-2201\nroute: NONE\nholding: 4 H 12 MIN\ncamera: ACTIVE"],
		"server_door": ["Look at the server room door", "SERVER ROOM 86\nkeypad: FAULT (ANY CODE)\ntemp: 31 C (ALARM MUTED)"],
		"racks_server": ["Look at the racks", "FLOOR RACKS 86 x9\nload: 100%\nfans: MAX"],
		"ora_node": ["Look at the ORA node", "ORA FLOOR NODE 86\nframes synced: 7\nactivity: CONSTANT\nlast push: UNKNOWN SOURCE"],
		"cable_tray": ["Look at the cable trays", "CABLE TRAY 86-N\nruns: 212 (211 LOGGED)\nunlogged run: DOWN"],
		"office_forner": ["Look into Forner's office", "OFFICE 86-W1\nFORNER, M.\nlast entry: 118 DAYS"],
		"office_qa": ["Look into the QA office", "OFFICE 86-W2\nQA LIAISON (VACANT)\nqueue: 8,811"],
		"office_carl": ["Look at your desk", "OFFICE 86-W3\nDRAKE, C.\nnotifications: 1 (PSYON)"],
		"office_carl_photo": ["Look at the photo", ""],
		"office_vacant": ["Look into the empty office", "OFFICE 86-W4\nVACANT\nlast occupant: (REDACTED)"],
		"office_storage": ["Look at the storage shelves", "FIELD STORAGE 86\nitems: 212\nbagged this month: 31"],
		"printer": ["Look at the printer", "PRINTER 86-W\nqueue: OUTAGE NOTICE (x40)\ntoner: LOW"],
		"cooler": ["Look at the water cooler", "WATER COOLER\nbottle: EMPTY\nsand: YES"],
		"corridor": ["Look down the corridor", ""],
		"turan": ["Talk to Dr. Turan", "TURAN, DR. S.\nDIRECTOR - INTEGRATIONS\nboard call: 09:30\nmood (ORA): DO NOT ASK"],
		"forner": ["Talk to Forner", "FORNER, M.\nHEAD OF SECURITY AND GOVERNANCE\nframes: REFUSED\nPsyon: none (exemption)"],
		"emmet": ["Talk to Emmet", "EMMET, R.\nINTEGRATIONS INVESTIGATOR (IoT)\nresidence: FLOOR 85\nlate: 4 OF 5 DAYS"],
		"lynx": ["Talk to Lynx", "LYNX\nLEAD ML ENGINEER\nframes: ON  -  sync 100%\nnote: subnet forums, 03:40"],
		"guard": ["Look at the security guard", "SECURITY (CONTRACT)\nframes: ON  -  sync 100%\nposted: GATE 86-E"],
		"guard2": ["Look at the security guard", "SECURITY (CONTRACT)\nframes: ON  -  sync 100%\nposted: SERVER ROOM (UNLOGGED)"]},
	"labels": {
		"sign": "PSYONIC  INTEGRATIONS", "floor": "FLOOR 86", "car2": "CAR 2  OUT OF SERVICE", "tint": "TINT  ERR 0x2E",
		"reception": "ORA RECEPTION\nplease badge in", "hub": "ORA FLOOR 86\nFILTRATION: OVERTIME",
		"feed_title": "PSYON 4.1  -  ABERRATION FEED",
		"feed_rows": ["0417  FLATS 12   fridge: 'I know what you did'      QA", "0418  SOUTHTOWN  pillow: chanting, 03:10          OPEN",
			"0419  DUFREDY, H.  eyes removed, sermon, park     FIELD", "0420  RESIDENCE 45  tablet: forked build         OPEN",
			"0421  SPINE  kiosk: rings etched inside bezel      OPEN", "0422  QUADRANT 7  bootleg device (3rd this month)  OPEN"],
		"brands": [["TOKZ", "#NoEyeSally\n2.4M  -  trending"], ["NIXTRA", "CALM  -  demand +40%\n(quadrant 7)"],
			["FREUDBOT", "sessions today\n14,208  (+31%)"], ["PSYMATCHBOT", "matches: NOMINAL\nsync anomalies: 9"]],
		"cams": [["CAM 4412  ZETA ST", "OFFLINE  -  3 DAYS"], ["CAM 4418  PARK AVE", "OFFLINE  -  3 DAYS"], ["CAM 0171  THE SPINE", "LIVE"]],
		"ora": ["ORA", "always watching\nover you"],
		"frames_l": ["PSYC  -18.4%\nCOGNIZO  +6.1%", "SILICO TODAY\n\"PSYONIC: NO COMMENT\"", "TOKZ  #NoEyeSally\n2.4M views  -  4h"],
		"frames_r": ["QA QUEUE  8,811\nSLA: BREACHED", "ABERRATION REPORTS\n+1,204 TODAY", "VOLTX GRID\nQUADRANT 7: ROLLING"],
		"holo": "PSYON 4.1  -  INCIDENT 0419\nDUFREDY, H.  -  OPEN",
		"terminal": "IONWARE\n> _", "turan_door": "DR. S. TURAN\nDIRECTOR  -  INTEGRATIONS", "founder": "ELONTHIEL",
		"mood": "MOOD: ANXIOUS\n(you)", "lab": "LAB 86  -  ML\nAUTHORISED ONLY", "bootleg": "BOOTLEG 0%d",
		"brew": "ORDER QUEUE: 1,412\nWATER: EMPTY", "nixtra": ["NIXTRA", "a new flavour: CALM", "SOLD OUT"],
		"stairs": "STAIRS", "stair_gate": "LEVEL %d\nBADGE REQUIRED", "break_screen": ["TOKZ  LIVE", "#NoEyeSally\n2.4M views", "MUTED"],
		"pod": "TOKZ NAP POD\nOUT OF ORDER", "server": "SERVER ROOM 86\nAUTHORISED ONLY", "ora_node": "ORA FLOOR NODE 86",
		"offices": ["FORNER, M.\nSECURITY & GOVERNANCE", "QA LIAISON", "DRAKE, C.\nINTEGRATIONS", "", "FIELD STORAGE"],
		"carl_screen": "PSYON 4.1\n1 notification\n\n> Welcome back, dreamer.",
		"printer": "OUTAGE NOTICE\nx40", "cooler": "LUSHON\nWATER", "zeta": "ZETA ST", "park": "PARK AVE",
		"cognizo": "COGNIZO LINE  -  NEXT: COGNIZO STATION"},
	"scan": {"staff": "PSYONIC STAFF\n", "dreaming": "sync 100%  -  DREAMING", "sync": "sync 97%", "forner": "Psyon: NONE (EXEMPTION)",
		"guard": "SECURITY (CONTRACT)\n", "guard_frames": "frames: ON  -  watching: YOU", "guard_off": "frames: ON  -  sync 100%"},
	"phone": {
		"d1": "[color=#7fe6b0]Psyon:[/color] Good morning, Carl. Dr. Turan has moved the stand-up to now. Empathy at Scale.\n\n",
		"d1_footage": "[color=#7fe6b0]Psyon:[/color] Your car is booked for SalTech Hospital. The route avoids quadrant 7.\n\n",
		"d1_told": "[color=#e08080]Psyon:[/color] It stays off the record, Carl. Everything does, with me.\n\n",
		"d2": "[color=#7fe6b0]Psyon:[/color] Good morning, Carl. You slept 2 h 10 min. Shall I book FreudBot GPT?\n\n",
		"d2_lynx": "[color=#7fe6b0]Psyon:[/color] Lynx has not checked in. Her last message was at 03:40: \"signal in the sand\".\n\n",
		"d2_welcome": "[color=#e08080]Psyon:[/color] Welcome, Dreamer.\n\n"},
	"who": {"turan": "Turan", "lynx": "Lynx", "emmet": "Emmet", "forner": "Forner", "carl": "Carl", "elevator": "ELEVATOR", "feed": "TOKZ FEED"},
}

var day2 := false
var _carpet: StandardMaterial3D
var _glass: StandardMaterial3D
var _metal: StandardMaterial3D
var _dark: StandardMaterial3D
var _jade: StandardMaterial3D
var _white: StandardMaterial3D
var _wood: StandardMaterial3D
var _plaster: StandardMaterial3D
var _green: StandardMaterial3D
var _screen_off: StandardMaterial3D
var turan: Node3D
var lynx: Node3D
var emmet: Node3D
var forner: Node3D
var cast: Array = []
var guards: Array = []
var door_l: Node3D
var door_r: Node3D
var door2_l: Node3D
var door2_r: Node3D
var counter_in: Label3D
var counter_out: Label3D
var eye_in: Sprite3D
var eye_out: Sprite3D
var eye_spin := false
var car_light: OmniLight3D
var big_mat: StandardMaterial3D
var feed_root: Node3D
var screen_glyph: Sprite3D
var holo_glyph: Sprite3D
var vacuum: MeshInstance3D
var drone: Node3D
var drone_lamp: MeshInstance3D
var node_light: MeshInstance3D
var set_a: Node3D
var set_b: Node3D
var dufredy_set: Node3D
var masked_set: Node3D
var lifted: Array = []
var set_b_lights: Array = []
var lab_laptop: Node3D
var _ended := false


func build(m: Node) -> void:
	main = m
	rng.seed = 86
	day2 = main.flags.has("ritual_seen")
	kit_day = true
	spawn = CAR + Vector3(0, 0.05, -0.3)
	spawn_yaw = 180.0
	step_db = -20.0
	card = LINES["card"]["d2" if day2 else "d1"]
	_carpet = pbr("carpet", Vector3(1, 1, 1) / 1.5, true, Color(0.56, 0.53, 0.52))
	_glass = newmat(Color(0.55, 0.7, 0.78, 0.2), 0.05, 0.4)
	_glass.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_metal = mat(Color(0.36, 0.37, 0.4), 0.4, 0.7)
	_dark = mat(Color(0.08, 0.08, 0.09), 0.5, 0.3)
	_jade = mat(Color(0.18, 0.42, 0.36), 0.3, 0.6)
	_white = mat(Color(0.9, 0.9, 0.88), 0.6)
	_wood = pbr("woodfloor", Vector3(1, 1, 1) / 2.0, true, Color(0.7, 0.6, 0.5))
	_plaster = pbr("plaster", Vector3(1, 1, 1) / 2.0, true, Color(0.82, 0.8, 0.76))
	_green = glow(Color(0.3, 1.0, 0.6), 1.6)
	_screen_off = mat(Color(0.03, 0.03, 0.035), 0.2, 0.4)
	_shell()
	_elevators()
	_lobby()
	_war_room()
	_screen_wall()
	_turan_office()
	_desks()
	_lab()
	_break_room()
	_stairwell()
	_offices()
	_server_room()
	_outside()
	_people()
	_sets()
	_batch(self, 8.0, true)


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	# afternoon, the smog lit from inside like a lampshade
	var psm := ProceduralSkyMaterial.new()
	psm.sky_top_color = Color(0.48, 0.46, 0.44)
	psm.sky_horizon_color = Color(0.95, 0.7, 0.45)
	psm.ground_horizon_color = Color(0.88, 0.64, 0.42)
	psm.ground_bottom_color = Color(0.42, 0.32, 0.24)
	psm.sun_angle_max = 22.0
	env.sky.sky_material = psm
	env.glow_bloom = 0.0
	env.glow_intensity = 0.6
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.7, 0.68, 0.64)
	env.ambient_light_energy = 0.42
	env.fog_light_color = Color(0.9, 0.66, 0.4)
	env.fog_density = 0.0022
	env.fog_sky_affect = 0.3
	env.tonemap_exposure = 1.0
	env.glow_hdr_threshold = 1.2
	sun.light_color = Color(1.0, 0.82, 0.6)
	sun.light_energy = 1.3
	sun.sky_mode = DirectionalLight3D.SKY_MODE_LIGHT_AND_SKY
	sun.rotation = Vector3(deg_to_rad(-24), deg_to_rad(250), 0)
	sun.directional_shadow_max_distance = 70.0
	sun.light_cull_mask &= ~(1 << 19)  # the hidden sets keep their own night


func hifi(env: Environment, _sun: DirectionalLight3D) -> void:
	env.volumetric_fog_density = 0.004
	env.volumetric_fog_albedo = Color(0.9, 0.7, 0.5)
	for l in lamps:
		(l[0] as OmniLight3D).shadow_enabled = true


func ambience() -> void:
	main.loop("room", -14.0)
	main.loop("hum", -20.0, LAB + Vector3(-4.6, 1.5, -1.0), 2.0, 14.0)
	main.loop("hum", -12.0, Vector3(-19.0, 1.5, -16.5), 3.0, 18.0)
	main.loop("wind", -24.0, Vector3(0, 2.0, 29.0), 6.0, 60.0)
	main.loop("static", -26.0, Vector3(3.2, 1.5, 5.0), 1.0, 5.0)
	main.loop("vacuum", -22.0, Vector3(5.2, 0.2, 7.6), 1.0, 6.0)


# ------------------------------------------------------------------ helpers

## An interactable whose prompt and scan text come from LINES["items"].
func _it(id: String, pos: Vector3, size: Vector3, solid := false, parent: Node = self, key := "") -> CollisionObject3D:
	var e: Array = LINES["items"][key if key != "" else id]
	return interactable(id, e[0], pos, size, e[1], solid, parent)


## A device for later: carries meta "hackable".
func _hack(body: CollisionObject3D) -> CollisionObject3D:
	body.set_meta("hackable", true)
	return body


func _say(who: String, text: String) -> void:
	await main.ui.say(LINES["who"][who], text)


func _think_all(lines: Array) -> void:
	for l in lines:
		await main.ui.think(str(l))


# ------------------------------------------------------------------ the shell

func _shell() -> void:
	# a round floor in the shaft: carpet, a polished inlay at the elevators
	cyl(R + 0.6, R + 0.6, 0.06, Vector3(0, -0.03, 0), _carpet, 64)
	solid_box(Vector3(2 * R + 4, 1, 2 * R + 4), Vector3(0, -0.53, 0))
	floor_quad(Vector2(14, 9), Vector3(0, 0.006, 9.5), 0.0, pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.72, 0.74, 0.72)))
	var ceil_m := mat(Color(0.86, 0.86, 0.84), 0.95)
	cyl(R + 0.6, R + 0.6, 0.25, Vector3(0, H + 0.125, 0), ceil_m, 64)
	# exposed vents along the ceiling like metallic arteries (ch. 3)
	for x: float in [-14.0, -8.0, 8.0, 14.0, 24.0, -24.5]:
		var ln := 2.0 * sqrt((R - 1.5) * (R - 1.5) - x * x)
		var d := cyl(0.28, 0.28, ln, Vector3(x, H - 0.34, 0), _metal, 10)
		d.rotation.x = PI / 2.0
	for z: float in [-24.0, 24.0]:
		var ln := 2.0 * sqrt((R - 1.5) * (R - 1.5) - z * z)
		var d := cyl(0.28, 0.28, ln, Vector3(0, H - 0.34, z), _metal, 10)
		d.rotation.z = PI / 2.0
	# light panels on a grid, skipping the core
	var panel := glow(Color(0.95, 0.95, 1.0), 1.1)
	var x := -27.0
	while x <= 27.0:
		var z := -27.0
		while z <= 27.0:
			if Vector2(x, z).length() < R - 2.5 and (absf(x) > 5.5 or absf(z) > 5.5):
				floor_quad(Vector2(1.2, 0.5), Vector3(x, H - 0.01, z), 0.0, panel, self, false)
			z += 6.0
		x += 6.0
	# the core: faux-wood paneling streaked with Psyon green (ch. 3)
	box(Vector3(9, H, 6.8), Vector3(0, H / 2.0, -1.1), _wood, true)
	box(Vector3(2.0, H, 2.3), Vector3(-3.5, H / 2.0, 3.35), _wood, true)
	box(Vector3(1.8, H, 2.3), Vector3(0, H / 2.0, 3.35), _wood, true)
	box(Vector3(3.6, H, 2.3), Vector3(2.7, H / 2.0, 3.35), _wood, true)
	for y: float in [0.9, 2.2]:
		# streaks on the core's faces only; the slab must not run through the cars
		box(Vector3(9.04, 0.05, 0.06), Vector3(0, y, -4.52), _green)
		box(Vector3(0.06, 0.05, 9.04), Vector3(-4.52, y, 0), _green)
		box(Vector3(0.06, 0.05, 9.04), Vector3(4.52, y, 0), _green)
		box(Vector3(1.8, 0.05, 0.06), Vector3(0, y, 4.52), _green)
		box(Vector3(2.0, 0.05, 0.06), Vector3(-3.52, y, 4.52), _green)
		box(Vector3(2.0, 0.05, 0.06), Vector3(3.52, y, 4.52), _green)
	# the glass: 48 panes round the floor, mullions, a transom and a sill
	var sill := mat(Color(0.2, 0.2, 0.22), 0.6, 0.4)
	var n := 48
	for i in n:
		var a := i * TAU / n + TAU / (2 * n)
		var w := 2.0 * R * sin(PI / n)
		var p := Vector3(sin(a) * R, 0, cos(a) * R)
		var g := box(Vector3(w, H - 0.45, 0.05), p + Vector3(0, 0.45 + (H - 0.45) / 2.0, 0), _dark if i == 9 else _glass)
		g.rotation.y = a
		g.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		solid_box(Vector3(w, H, 0.3), p + Vector3(0, H / 2.0, 0)).rotation.y = a
		box(Vector3(w, 0.45, 0.3), p + Vector3(0, 0.225, 0), sill).rotation.y = a
		box(Vector3(w, 0.08, 0.1), p + Vector3(0, 2.55, 0), _metal).rotation.y = a
		var ae := i * TAU / n
		var pe := Vector3(sin(ae) * R, 0, cos(ae) * R)
		box(Vector3(0.12, H, 0.16), pe + Vector3(0, H / 2.0, 0), _metal).rotation.y = ae
		if i == 9:
			# smart glass, stuck on full tint since the last outage
			neon_text(LINES["labels"]["tint"], p + Vector3(0, 1.6, 0) - Vector3(sin(a), 0, cos(a)) * 0.05, a + PI, 0.08, Color(1.0, 0.3, 0.2), 1.6)
			_hack(_it("tint", p + Vector3(0, 1.6, 0) - Vector3(sin(a), 0, cos(a)) * 0.2, Vector3(1.2, 2.0, 0.3)))
	for a: float in [0.25, PI / 2.0, PI, -PI / 2.0, 2.3, -2.3]:
		_it("window", Vector3(sin(a) * (R - 0.5), 1.5, cos(a) * (R - 0.5)), Vector3(3.0, 2.4, 3.0))


# ------------------------------------------------------------------ the elevators

func _elevators() -> void:
	var brushed := mat(Color(0.55, 0.56, 0.58), 0.35, 0.8)
	# Carl's car: x -2.5..-0.9, z 2.2..4.5
	quad(Vector2(1.6, 2.5), CAR + Vector3(0, 1.25, -1.14), 0.0, brushed)
	quad(Vector2(2.3, 2.5), Vector3(-2.49, 1.25, 3.35), PI / 2.0, brushed)
	quad(Vector2(2.3, 2.5), Vector3(-0.91, 1.25, 3.35), -PI / 2.0, brushed)
	var warm := mat(Color(0.5, 0.42, 0.34), 0.6, 0.2)
	box(Vector3(1.6, 0.9, 2.3), CAR + Vector3(0, 2.95, 0), warm)
	floor_quad(Vector2(1.6, 2.3), CAR + Vector3(0, 0.01, 0), 0.0, pbr("carpet", Vector3(1, 1, 1) / 1.5, true, Color(0.55, 0.45, 0.38)))
	floor_quad(Vector2(1.0, 0.3), CAR + Vector3(0, 2.49, 0), 0.0, glow(Color(0.9, 0.95, 1.0), 1.4), self, false)
	car_light = light(CAR + Vector3(0, 2.2, 0), Color(0.9, 0.95, 1.0), 0.45, 2.6, false)
	# the button panel, and a handrail
	box(Vector3(0.14, 0.5, 0.02), Vector3(-0.92, 1.2, 4.1), _metal).rotation.y = -PI / 2.0
	box(Vector3(0.03, 0.03, 0.01), Vector3(-0.93, 1.3, 4.1), glow(Color(0.3, 1.0, 0.6), 1.5)).rotation.y = -PI / 2.0
	box(Vector3(0.03, 0.03, 0.01), Vector3(-0.93, 1.2, 4.1), glow(Color(1.0, 0.3, 0.2), 1.5)).rotation.y = -PI / 2.0
	box(Vector3(1.5, 0.04, 0.04), CAR + Vector3(0, 0.95, -1.08), brushed)
	# the doors slide into the walls
	door_l = _door(Vector3(-2.5, 0, 4.5), 0.4)
	door_r = _door(Vector3(-0.9, 0, 4.5), -0.4)
	door2_l = _door(Vector3(0.9, 0, 4.5), 0.4)
	door2_r = _door(Vector3(2.5, 0, 4.5), -0.4)
	for p: Vector3 in [Vector3(-1.7, 0, 4.5), Vector3(1.7, 0, 4.5)]:
		box(Vector3(1.9, 0.12, 0.2), p + Vector3(0, 2.46, 0.05), _metal)
		box(Vector3(0.12, 2.5, 0.2), p + Vector3(-0.9, 1.25, 0.05), _metal)
		box(Vector3(0.12, 2.5, 0.2), p + Vector3(0.9, 1.25, 0.05), _metal)
	# the floor counters: digital, boring, dependable
	counter_out = _counter(Vector3(-1.7, 2.78, 4.62), 0.0)
	counter_in = _counter(CAR + Vector3(0, 2.08, 1.07), PI)
	eye_out = _eye_sprite(Vector3(-1.7, 2.78, 4.63), 0.0, 0.0024)
	eye_in = _eye_sprite(CAR + Vector3(0, 2.08, 1.06), PI, 0.0021)
	var c2 := _counter(Vector3(1.7, 2.78, 4.62), 0.0)
	c2.text = "- -"
	c2.modulate = Color(1.0, 0.35, 0.25)
	neon_text(LINES["labels"]["car2"], Vector3(1.7, 2.95, 4.62), 0.0, 0.06, Color(1.0, 0.35, 0.25), 1.4)
	_it("elevator", Vector3(-1.7, 1.2, 4.85), Vector3(1.6, 2.3, 0.5)).set_meta("exit", true)
	_hack(_it("elevator2", Vector3(1.7, 1.2, 4.85), Vector3(1.6, 2.3, 0.5)))


func _door(pivot: Vector3, leaf_x: float) -> Node3D:
	var n := Node3D.new()
	n.position = pivot
	add_child(n)
	var leaf := box(Vector3(0.8, 2.4, 0.08), Vector3(leaf_x, 1.2, 0), mat(Color(0.5, 0.52, 0.55), 0.3, 0.85), false, n)
	leaf.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	box(Vector3(0.02, 2.4, 0.09), Vector3(leaf_x * 2.0 - leaf_x * 0.05, 1.2, 0), _dark, false, n)
	solid_box(Vector3(0.8, 2.4, 0.3), Vector3(leaf_x, 1.2, 0), n)
	return n


func _counter(pos: Vector3, rot_y: float) -> Label3D:
	var l := Label3D.new()
	l.text = "86"
	l.font_size = 64
	l.pixel_size = 0.0035
	l.outline_size = 0
	l.modulate = Color(0.3, 1.0, 0.6)
	l.position = pos
	l.rotation.y = rot_y
	add_child(l)
	return l


func _eye_sprite(pos: Vector3, rot_y: float, px: float) -> Sprite3D:
	var s := Sprite3D.new()
	s.texture = _glyph_tex
	s.pixel_size = px
	s.modulate = Color(1.0, 0.12, 0.08)
	s.shaded = false
	s.position = pos
	s.rotation.y = rot_y
	s.visible = false
	add_child(s)
	return s


## Both leaves of a car, over t seconds.
func _doors(l: Node3D, r: Node3D, open: bool, t := 0.9) -> void:
	main.play("door", -14.0, 1.6)
	var tw := create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE)
	tw.tween_property(l, "position:x", l.position.x + (-0.8 if open else 0.8), t)
	tw.tween_property(r, "position:x", r.position.x + (0.8 if open else -0.8), t)
	await tw.finished


# ------------------------------------------------------------------ the lobby

func _lobby() -> void:
	var L: Dictionary = LINES["labels"]
	neon_text(L["sign"], Vector3(0, 3.05, 4.56), 0.0, 0.26, Color(0.3, 1.0, 0.6), 1.8)
	neon_text(L["floor"], Vector3(0, 2.72, 4.56), 0.0, 0.1, Color(0.8, 0.95, 0.9), 1.4)
	light(Vector3(0, 3.0, 8.0), Color(1.0, 0.95, 0.88), 1.2, 9.0)
	# reception: a desk nobody sits at, a screen that asks you to badge in
	box(Vector3(3.2, 1.05, 0.8), Vector3(0, 0.525, 9.6), _jade, true)
	box(Vector3(3.4, 0.05, 0.9), Vector3(0, 1.07, 9.6), _white)
	var rs := quad(Vector2(0.6, 0.4), Vector3(0.8, 1.35, 9.55), PI, glow(Color(0.25, 0.5, 0.55), 1.1))
	rs.rotation.x = -0.3
	flickers.append(rs)
	no_batch.append(rs)
	neon_text(L["reception"], Vector3(0.8, 1.36, 9.52), PI, 0.045, Color(0.9, 1.0, 0.95), 1.5).rotation.x = -0.3
	_hack(_it("reception", Vector3(0, 0.9, 9.6), Vector3(3.2, 0.5, 0.9)))
	# the badge gates either side of the core, open, their lights red
	for x: float in [-5.6, 5.6]:
		for dz: float in [-0.6, 0.6]:
			box(Vector3(0.25, 1.05, 0.2), Vector3(x, 0.52, 6.0 + dz), _metal, true)
		box(Vector3(0.25, 0.12, 1.4), Vector3(x, 1.1, 6.0), _dark)
		box(Vector3(0.05, 0.04, 0.3), Vector3(x + 0.13, 1.05, 6.0), glow(Color(1.0, 0.1, 0.1), 2.0))
		box(Vector3(0.05, 0.04, 0.3), Vector3(x - 0.13, 1.05, 6.0), glow(Color(1.0, 0.1, 0.1), 2.0))
		_hack(_it("gate", Vector3(x, 0.8, 6.0), Vector3(0.4, 1.2, 1.5)))
	# an ORA hub on the core, a dead plant, a vacuum that gave up by the gate
	var hub := Vector3(3.4, 1.5, 4.52)
	box(Vector3(0.34, 0.34, 0.03), hub, mat(Color(0.08, 0.08, 0.09), 0.3, 0.4))
	var ring := TorusMesh.new()
	ring.inner_radius = 0.09
	ring.outer_radius = 0.11
	ring.rings = 24
	ring.ring_segments = 6
	var rm := mesh(ring, hub + Vector3(0, 0, 0.02), glow(Color(1.0, 0.4, 0.2), 1.4))
	rm.rotation.x = PI / 2.0
	neon_text(L["hub"], hub + Vector3(0, -0.26, 0.02), 0.0, 0.03, Color(1.0, 0.5, 0.3), 1.5)
	_hack(_it("hub", hub, Vector3(0.4, 0.5, 0.1)))
	var pot := mat(Color(0.3, 0.3, 0.32), 0.7)
	cyl(0.3, 0.24, 0.55, Vector3(-6.2, 0.27, 9.4), pot, 10)
	sphere(0.5, Vector3(-6.2, 0.95, 9.4), mat(Color(0.32, 0.26, 0.14), 0.95), 8)
	sphere(0.3, Vector3(-6.0, 1.3, 9.2), mat(Color(0.36, 0.3, 0.16), 0.95), 8)
	_it("plant", Vector3(-6.2, 0.8, 9.4), Vector3(1.0, 1.4, 1.0))
	vacuum = cyl(0.17, 0.17, 0.08, Vector3(5.2, 0.05, 7.6), mat(Color(0.12, 0.12, 0.13), 0.4, 0.4), 16)
	no_batch.append(vacuum)
	box(Vector3(0.05, 0.01, 0.05), Vector3(5.2, 0.095, 7.45), glow(Color(1, 0.2, 0.1), 1.5))
	_hack(_it("vacuum", Vector3(5.2, 0.06, 7.6), Vector3(0.45, 0.14, 0.45)))
	# a vent dripping sand onto the polished floor
	box(Vector3(0.5, 0.06, 0.3), Vector3(-3.6, H - 0.03, 11.0), _metal)
	floor_quad(Vector2(1.4, 1.0), Vector3(-3.6, 0.012, 11.0), 0.3, decal_mat(Tex.sand(), Color(1, 1, 1), 1.0))
	floor_quad(Vector2(0.8, 0.6), Vector3(-3.5, 0.014, 11.1), 1.1, decal_mat(Tex.sand(), Color(1, 1, 1), 1.0))
	_it("vent", Vector3(-3.6, 0.1, 11.0), Vector3(1.4, 0.2, 1.0))
	# a printer and the dry water cooler beyond reception, on the way round
	box(Vector3(0.7, 0.5, 0.6), Vector3(-4.0, 0.75, 14.0), mat(Color(0.8, 0.8, 0.78), 0.5), true)
	box(Vector3(0.7, 0.5, 0.6), Vector3(-4.0, 0.25, 14.0), _dark, true)
	for i in 5:
		floor_quad(Vector2(0.21, 0.29), Vector3(-4.0 + rng.randf_range(-0.1, 0.1), 1.01 + i * 0.002, 14.0 + rng.randf_range(-0.1, 0.1)), rng.randf_range(-0.3, 0.3), tex_mat(Tex.paper(200 + i), Vector3.ONE, 0.9))
	neon_text(L["printer"], Vector3(-4.0, 0.9, 13.69), 0.0, 0.03, Color(1.0, 0.5, 0.3), 1.4)
	_hack(_it("printer", Vector3(-4.0, 0.7, 14.0), Vector3(0.8, 1.1, 0.7)))
	box(Vector3(0.35, 1.0, 0.35), Vector3(4.2, 0.5, 14.0), _white, true)
	var bottle := newmat(Color(0.7, 0.85, 0.9, 0.4), 0.1)
	bottle.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	cyl(0.17, 0.17, 0.45, Vector3(4.2, 1.22, 14.0), bottle, 10)
	neon_text(L["cooler"], Vector3(4.2, 0.7, 13.82), 0.0, 0.03, Color(0.4, 0.8, 1.0), 1.4)
	_it("cooler", Vector3(4.2, 0.8, 14.0), Vector3(0.5, 1.6, 0.5))


# ------------------------------------------------------------------ the war room

func _war_room() -> void:
	var L: Dictionary = LINES["labels"]
	light(Vector3(0, 3.1, -11.0), Color(1.0, 0.95, 0.88), 1.3, 11.0)
	light(Vector3(0, 2.4, -7.2), Color(0.5, 0.75, 1.0), 1.0, 8.0)
	# the conference table, built for twelve
	var top := mat(Color(0.06, 0.06, 0.07), 0.2, 0.5)
	box(Vector3(6.4, 0.06, 2.2), TABLE + Vector3(0, 0.74, 0), top, true)
	for x: float in [-2.2, 2.2]:
		cyl(0.3, 0.45, 0.72, TABLE + Vector3(x, 0.36, 0), _metal, 12)
	solid_box(Vector3(6.4, 0.74, 2.2), TABLE + Vector3(0, 0.37, 0))
	_it("table", TABLE + Vector3(-1.0, 0.8, 0), Vector3(3.0, 0.14, 2.0))
	var chairs := []
	for i in 5:
		chairs.append([Vector3(-2.4 + i * 1.2, 0, 1.55), PI])
		chairs.append([Vector3(-2.4 + i * 1.2, 0, -1.55), 0.0])
	chairs.append([Vector3(-3.7, 0, 0), -PI / 2.0])
	chairs.append([Vector3(3.7, 0, 0), PI / 2.0])
	for c in chairs:
		_chair(TABLE + c[0], c[1])
	# the one half-drunk cup of coffee, a monument to exhaustion
	var cup := mat(Color(0.95, 0.95, 0.92), 0.6)
	cyl(0.04, 0.035, 0.1, TABLE + Vector3(1.3, 0.82, 0.45), cup, 10)
	cyl(0.034, 0.034, 0.01, TABLE + Vector3(1.3, 0.855, 0.45), mat(Color(0.2, 0.12, 0.06), 0.3), 10)
	_it("coffee", TABLE + Vector3(1.3, 0.85, 0.45), Vector3(0.2, 0.2, 0.2))
	# Turan's slate-black laptop at the head, slates and tablets down the sides
	var slate := mat(Color(0.05, 0.05, 0.06), 0.25, 0.6)
	var lp := TABLE + Vector3(0, 0.77, -0.85)
	box(Vector3(0.34, 0.016, 0.23), lp, slate)
	var lid := box(Vector3(0.34, 0.22, 0.01), lp + Vector3(0, 0.11, -0.115), slate)
	lid.rotation.x = -0.25
	var ls := quad(Vector2(0.31, 0.19), lp + Vector3(0, 0.11, -0.108), 0.0, glow(Color(0.5, 0.75, 0.9), 0.9))
	ls.rotation.x = -0.25
	_hack(_it("turan_laptop", lp, Vector3(0.4, 0.3, 0.3)))
	for i in 4:
		var tp := TABLE + Vector3(-2.0 + i * 1.3, 0.78, 0.55 if i % 2 == 0 else -0.55)
		box(Vector3(0.26, 0.01, 0.18), tp, slate).rotation.y = rng.randf_range(-0.3, 0.3)
	# the holo-display in the middle of the table (the Eye lingers in its static, ch. 7)
	cyl(0.12, 0.16, 0.06, TABLE + Vector3(0, 0.8, 0), _metal, 12)
	var hm := newmat(Color(0.3, 0.9, 1.0, 0.1), 1.0)
	hm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	hm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	hm.cull_mode = BaseMaterial3D.CULL_DISABLED
	var hq := quad(Vector2(1.2, 0.7), TABLE + Vector3(0, 1.25, 0), 0.0, hm)
	no_batch.append(hq)
	neon_text(L["holo"], TABLE + Vector3(0, 1.3, 0.01), 0.0, 0.05, Color(0.5, 0.95, 1.0), 1.3)
	holo_glyph = Sprite3D.new()
	holo_glyph.texture = _glyph_tex
	holo_glyph.pixel_size = 0.0045
	holo_glyph.modulate = Color(1.0, 0.15, 0.1, 0.35)
	holo_glyph.shaded = false
	holo_glyph.double_sided = true
	holo_glyph.position = TABLE + Vector3(0, 1.22, -0.01)
	holo_glyph.visible = false
	add_child(holo_glyph)
	# Forner's desk: sandstone, wired with paranoia
	var sand := pbr("concrete", Vector3(1, 1, 1) / 1.5, true, Color(0.9, 0.72, 0.5))
	var fd := Vector3(7.5, 0, -7.6)
	box(Vector3(2.4, 0.1, 1.0), fd + Vector3(0, 0.76, 0), sand, true)
	box(Vector3(2.2, 0.7, 0.8), fd + Vector3(0, 0.36, 0), sand, true)
	for i in 4:
		_terminal(fd + Vector3(-0.9 + i * 0.6, 0.81, -0.25), 0.0, i != 2, Color(0.4, 0.8, 0.5) if i != 3 else Color(0.9, 0.4, 0.3))
	var cab := mat(Color(0.04, 0.04, 0.04), 0.7)
	for i in 14:
		var a0 := fd + Vector3(rng.randf_range(-1.1, 1.1), 0.78, -0.3)
		var a1 := a0 + Vector3(rng.randf_range(-0.6, 0.6), -0.78, rng.randf_range(-0.8, -0.2))
		stick(a0, a1, 0.01, cab)
		stick(a1, a1 + Vector3(rng.randf_range(-1.0, 1.0), 0.0, rng.randf_range(-1.5, 0.5)), 0.01, cab)
	# a mesh cage round a drive, tape over every lens, a dead-man switch
	var mesh_m := newmat(Color(0.6, 0.6, 0.62, 0.5), 0.5, 0.6)
	mesh_m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	box(Vector3(0.4, 0.3, 0.35), fd + Vector3(1.0, 0.97, 0.25), mesh_m)
	box(Vector3(0.2, 0.05, 0.25), fd + Vector3(1.0, 0.85, 0.25), _dark)
	box(Vector3(0.12, 0.12, 0.08), fd + Vector3(-1.05, 0.88, 0.3), mat(Color(0.7, 0.1, 0.1), 0.5))
	for i in 6:
		floor_quad(Vector2(0.08, 0.08), fd + Vector3(rng.randf_range(-1.0, 0.6), 0.815 + i * 0.001, rng.randf_range(0.1, 0.4)), rng.randf() * 0.5,
			mat(Color(1.0, 0.9, 0.3) if i % 2 == 0 else Color(1.0, 0.6, 0.7), 0.9))
	_it("forner_desk", fd + Vector3(0, 0.9, 0.1), Vector3(2.4, 0.4, 0.8))
	light(fd + Vector3(0, 1.6, 0.2), Color(1.0, 0.75, 0.45), 0.5, 4.5)
	# free-standing screen frames flanking the table, angled in
	for s: float in [-1.0, 1.0]:
		var fp := Vector3(s * 7.6, 0, -12.5)
		var ry := s * 0.6 + (PI / 2.0 if s < 0.0 else -PI / 2.0)
		box(Vector3(0.1, 2.6, 2.4), fp + Vector3(0, 1.4, 0), _dark, true).rotation.y = ry + PI / 2.0
		var fwd := Basis(Vector3.UP, ry) * Vector3(0, 0, 0.07)
		var cols := [Color(0.9, 0.3, 0.3), Color(0.3, 0.6, 1.0), Color(0.9, 0.7, 0.3)]
		var txt: Array = L["frames_l"] if s < 0.0 else L["frames_r"]
		for i in 3:
			var sp := fp + fwd + Vector3(0, 2.3 - i * 0.8, 0)
			quad(Vector2(2.2, 0.72), sp, ry, glow(cols[i] * 0.3, 1.2))
			neon_text(txt[i], sp + fwd * 0.3, ry, 0.11, Color(1, 1, 1).lerp(cols[i], 0.3), 1.6)
	# a Tokz nap pod in the north-east corner, out of order, lid half open
	var pp := Vector3(14.0, 0, -13.0)
	var shell := mat(Color(0.9, 0.9, 0.92), 0.3, 0.2)
	var cm := CapsuleMesh.new()
	cm.radius = 0.7
	cm.height = 2.6
	var pod := mesh(cm, pp + Vector3(0, 0.6, 0), shell)
	pod.rotation.z = PI / 2.0
	pod.rotation.y = 0.5
	var lidm := CapsuleMesh.new()
	lidm.radius = 0.72
	lidm.height = 1.4
	var plid := mesh(lidm, pp + Vector3(0.3, 1.15, -0.2), newmat(Color(0.3, 0.4, 0.5, 0.35), 0.1))
	(plid.material_override as StandardMaterial3D).transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	plid.rotation = Vector3(0.3, 0.5, PI / 2.0 + 0.7)
	solid_box(Vector3(2.6, 1.4, 1.5), pp + Vector3(0, 0.7, 0)).rotation.y = 0.5
	neon_text(L["pod"], pp + Vector3(-0.9, 1.0, 1.0), 0.5, 0.05, Color(1.0, 0.3, 0.6), 1.5)
	_hack(_it("pod", pp + Vector3(0, 0.8, 0), Vector3(2.8, 1.6, 1.8)))
	light(pp + Vector3(0, 2.6, 0), Color(1.0, 0.4, 0.7), 0.6, 6.0)


func _chair(p: Vector3, ry: float) -> void:
	var n := Node3D.new()
	n.position = p
	n.rotation.y = ry
	add_child(n)
	var c := mat(Color(0.14, 0.14, 0.16), 0.5)
	box(Vector3(0.5, 0.06, 0.5), Vector3(0, 0.46, 0), c, false, n)
	box(Vector3(0.5, 0.55, 0.06), Vector3(0, 0.76, 0.24), c, false, n)
	cyl(0.03, 0.03, 0.44, Vector3(0, 0.22, 0), _metal, 6, n)
	cyl(0.3, 0.3, 0.03, Vector3(0, 0.015, 0), _metal, 10, n)


## An Ionware terminal: a monitor on an arm, a keyboard slab.
func _terminal(p: Vector3, ry: float, on: bool, c: Color, text := "") -> void:
	var n := Node3D.new()
	n.position = p
	n.rotation.y = ry
	add_child(n)
	box(Vector3(0.58, 0.36, 0.03), Vector3(0, 0.36, -0.2), mat(Color(0.1, 0.1, 0.11), 0.4, 0.5), false, n)
	cyl(0.025, 0.025, 0.25, Vector3(0, 0.12, -0.2), _metal, 6, n)
	box(Vector3(0.2, 0.02, 0.14), Vector3(0, 0.01, -0.2), _metal, false, n)
	quad(Vector2(0.54, 0.32), Vector3(0, 0.36, -0.184), 0.0, glow(c * 0.35, 1.0) if on else _screen_off, n)
	if on:
		neon_text(text if text != "" else LINES["labels"]["terminal"], Vector3(-0.2, 0.42, -0.18), 0.0, 0.028, c, 1.4, n)
	box(Vector3(0.4, 0.015, 0.14), Vector3(0, 0.01, 0.12), mat(Color(0.2, 0.2, 0.22), 0.6), false, n)


## The wall of screens on the core's north face: feeds, the city's cameras,
## the ORA eye, the big screen in the middle.
func _screen_wall() -> void:
	var L: Dictionary = LINES["labels"]
	box(Vector3(9.0, 3.2, 0.08), Vector3(0, 1.9, -4.52), _dark)
	big_mat = StandardMaterial3D.new()
	big_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	big_mat.albedo_color = Color(0.05, 0.09, 0.13)
	var bs := quad(Vector2(5.2, 2.9), SCREEN, PI, big_mat)
	no_batch.append(bs)
	_hack(_it("screens", SCREEN - Vector3(0, 0, 0.2), Vector3(5.2, 2.9, 0.3)))
	feed_root = Node3D.new()
	add_child(feed_root)
	neon_text(L["feed_title"], SCREEN + Vector3(0, 1.1, -0.02), PI, 0.16, Color(0.5, 0.9, 1.0), 1.6, feed_root)
	var rows: Array = L["feed_rows"]
	for i in rows.size():
		neon_text(rows[i], SCREEN + Vector3(0, 0.55 - i * 0.3, -0.02), PI, 0.085, Color(0.8, 0.9, 0.95) if i != 2 else Color(1.0, 0.5, 0.4), 1.4, feed_root)
	screen_glyph = Sprite3D.new()
	screen_glyph.texture = _glyph_tex
	screen_glyph.pixel_size = 0.014
	screen_glyph.modulate = Color(1.0, 0.15, 0.1, 0.22)
	screen_glyph.shaded = false
	screen_glyph.position = SCREEN + Vector3(0, 0, -0.03)
	screen_glyph.rotation.y = PI
	screen_glyph.visible = false
	add_child(screen_glyph)
	# the small screens: brand feeds on the left, the city's cameras right
	var brand_c := [Color(1.0, 0.3, 0.7), Color(0.3, 0.9, 1.0), Color(0.9, 0.7, 0.3), Color(0.6, 0.3, 1.0)]
	var brands: Array = L["brands"]
	for i in 4:
		var sp := SCREEN + Vector3(-3.5 + (i % 2) * 1.75, 1.0 - (i / 2) * 1.0, -0.02)
		var e: Array = brands[i]
		quad(Vector2(1.6, 0.85), sp, PI, glow(brand_c[i] * 0.3, 1.2))
		neon_text(e[0], sp + Vector3(0, 0.25, -0.02), PI, 0.13, brand_c[i], 1.6)
		neon_text(e[1], sp + Vector3(0, -0.12, -0.02), PI, 0.07, Color(0.95, 0.95, 0.9), 1.4)
	var cams: Array = L["cams"]
	for i in 3:
		var sp := SCREEN + Vector3(2.65 + (i % 2) * 1.75, 1.0 - (i / 2) * 1.0, -0.02)
		var e: Array = cams[i]
		var live := i == 2
		quad(Vector2(1.6, 0.85), sp, PI, glow(Color(0.2, 0.45, 0.4), 1.0) if live else mat(Color(0.12, 0.12, 0.12), 0.6))
		neon_text(e[0], sp + Vector3(0, 0.26, -0.02), PI, 0.08, Color(0.9, 0.9, 0.9), 1.4)
		neon_text(e[1], sp + Vector3(0, -0.1, -0.02), PI, 0.1, Color(0.3, 1.0, 0.6) if live else Color(1.0, 0.3, 0.2), 1.6)
		if live:
			for k in 5:
				box(Vector3(0.3, 0.05, 0.01), sp + Vector3(-0.6 + k * 0.3, -0.3 + (k % 2) * 0.08, -0.03), _neon(KIT_NEON[k % KIT_NEON.size()]))
	# the ORA eye, always watching over you
	var sp := SCREEN + Vector3(4.4, 0.0, -0.02)
	var em := StandardMaterial3D.new()
	em.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	em.albedo_texture = Tex.eye()
	em.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	quad(Vector2(1.6, 0.85), sp, PI, mat(Color(0.02, 0.02, 0.025), 0.5))
	quad(Vector2(0.6, 0.6), sp + Vector3(-0.4, 0, -0.02), PI, em)
	var ora: Array = L["ora"]
	neon_text(ora[0], sp + Vector3(0.45, 0.12, -0.02), PI, 0.16, Color(1.0, 0.4, 0.7), 1.6)
	neon_text(ora[1], sp + Vector3(0.45, -0.18, -0.02), PI, 0.06, Color(0.95, 0.9, 0.95), 1.4)
	_hack(_it("ora_screen", sp, Vector3(1.6, 0.85, 0.2)))


# ------------------------------------------------------------------ Turan's office

func _turan_office() -> void:
	var L: Dictionary = LINES["labels"]
	var gl := func(size: Vector3, p: Vector3) -> void:
		var g := box(size, p, _glass, true)
		g.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	# glass on all four sides; a door west (z 0.6..2.4) and east (z -2.4..-0.6)
	gl.call(Vector3(0.06, H, 4.6), Vector3(9.0, H / 2.0, -1.7))
	gl.call(Vector3(0.06, H, 1.6), Vector3(9.0, H / 2.0, 3.2))
	gl.call(Vector3(0.06, H, 1.6), Vector3(16.0, H / 2.0, -3.2))
	gl.call(Vector3(0.06, H, 4.6), Vector3(16.0, H / 2.0, 1.7))
	gl.call(Vector3(7.0, H, 0.06), Vector3(12.5, H / 2.0, -4.0))
	gl.call(Vector3(7.0, H, 0.06), Vector3(12.5, H / 2.0, 4.0))
	for z: float in [-4.0, 4.0]:
		box(Vector3(7.1, 0.1, 0.1), Vector3(12.5, H - 0.05, z), _metal)
		box(Vector3(7.1, 0.06, 0.1), Vector3(12.5, 0.03, z), _metal)
	for p: Vector3 in [Vector3(9.0, 0, 0.6), Vector3(9.0, 0, 2.4), Vector3(16.0, 0, -0.6), Vector3(16.0, 0, -2.4)]:
		box(Vector3(0.1, H, 0.1), p + Vector3(0, H / 2.0, 0), _metal)
	neon_text(L["turan_door"], Vector3(8.96, 2.2, -1.0), -PI / 2.0, 0.07, Color(0.85, 0.95, 0.9), 1.4)
	light(Vector3(12.5, 3.0, 0), Color(1.0, 0.92, 0.82), 1.0, 7.0)
	# her desk, back to the glass, facing the door
	var dp := Vector3(13.5, 0, 0)
	var top := mat(Color(0.06, 0.06, 0.07), 0.2, 0.5)
	box(Vector3(0.9, 0.05, 2.2), dp + Vector3(0, 0.75, 0), top, true)
	box(Vector3(0.7, 0.72, 2.0), dp + Vector3(0, 0.36, 0), _white, true)
	_terminal(dp + Vector3(0.2, 0.78, 0.4), -PI / 2.0, true, Color(0.4, 0.8, 0.5))
	_chair(dp + Vector3(0.9, 0, 0), PI / 2.0)
	_chair(dp + Vector3(-1.3, 0, 0.6), -PI / 2.0)
	_chair(dp + Vector3(-1.3, 0, -0.6), -PI / 2.0)
	box(Vector3(0.3, 0.01, 0.22), dp + Vector3(-0.1, 0.78, -0.5), mat(Color(0.9, 0.88, 0.8), 0.9))
	_hack(_it("turan_desk", dp + Vector3(0, 0.85, 0), Vector3(1.0, 0.3, 2.2)))
	# a shelf of awards, a dead plant, a photo of the founder
	box(Vector3(3.0, 0.04, 0.3), Vector3(12.0, 1.5, -3.8), _white)
	box(Vector3(3.0, 0.04, 0.3), Vector3(12.0, 1.0, -3.8), _white)
	for i in 4:
		box(Vector3(0.1, 0.25, 0.1), Vector3(10.9 + i * 0.6, 1.65, -3.8), glow(Color(0.3, 1.0, 0.6) if i % 2 == 0 else Color(0.8, 0.8, 0.85), 1.2))
	box(Vector3(0.4, 0.5, 0.03), Vector3(14.6, 2.0, -3.9), mat(Color(0.2, 0.2, 0.22), 0.5))
	quad(Vector2(0.34, 0.44), Vector3(14.6, 2.0, -3.88), 0.0, mat(Color(0.3, 0.45, 0.4), 0.8))
	neon_text(L["founder"], Vector3(14.6, 1.72, -3.87), 0.0, 0.03, Color(0.9, 0.9, 0.9), 1.2)
	_it("awards", Vector3(12.0, 1.3, -3.8), Vector3(3.0, 0.9, 0.4))
	cyl(0.2, 0.16, 0.4, Vector3(15.3, 0.2, 3.3), mat(Color(0.3, 0.3, 0.32), 0.7), 10)
	for i in 5:
		var a := i * 1.3
		stick(Vector3(15.3, 0.4, 3.3), Vector3(15.3 + cos(a) * 0.3, 0.9 + i * 0.05, 3.3 + sin(a) * 0.3), 0.012, mat(Color(0.35, 0.3, 0.18), 0.9))


# ------------------------------------------------------------------ the desks

func _desks() -> void:
	var L: Dictionary = LINES["labels"]
	light(Vector3(-11.0, 3.0, -1.0), Color(1.0, 0.95, 0.88), 1.0, 9.0)
	light(Vector3(-15.0, 2.8, 2.0), Color(1.0, 0.95, 0.88), 0.7, 7.0)
	var fabric := pbr("fabric", Vector3(1, 1, 1) / 1.0, true, Color(0.45, 0.5, 0.55))
	var spots := [Vector3(-9.0, 0, 1.5), Vector3(-9.0, 0, -1.5), Vector3(-12.0, 0, 1.5), Vector3(-12.0, 0, -1.5), Vector3(-15.0, 0, 1.5), Vector3(-15.0, 0, -1.5)]
	for i in spots.size():
		var p: Vector3 = spots[i]
		var south := p.z > 0.0
		var ry := 0.0 if south else PI
		box(Vector3(1.7, 0.04, 0.8), p + Vector3(0, 0.74, 0), _white, true)
		for x: float in [-0.8, 0.8]:
			box(Vector3(0.05, 0.72, 0.7), p + Vector3(x, 0.36, 0), _metal)
		box(Vector3(1.8, 1.25, 0.04), p + Vector3(0, 0.9, -0.42 if south else 0.42), fabric)
		_terminal(p + Vector3(0.2, 0.76, 0), ry, i != 4, Color(0.4, 0.8, 0.5))
		_chair(p + Vector3(0, 0, 0.8 if south else -0.8), ry)
	# Emmet's desk: protein bar wrappers, IoT junk, a fridge that diagnoses your mood
	var ep: Vector3 = spots[0]
	var wraps := [mat(Color(0.8, 0.15, 0.1), 0.3, 0.6), mat(Color(0.9, 0.75, 0.1), 0.3, 0.6)]
	for i in 7:
		var w := box(Vector3(0.14, 0.02, 0.08), ep + Vector3(rng.randf_range(-0.7, 0.7), 0.77, rng.randf_range(-0.3, 0.3)), wraps[i % 2])
		w.rotation.y = rng.randf() * TAU
	box(Vector3(0.5, 0.9, 0.5), ep + Vector3(-1.4, 0.45, 0.2), mat(Color(0.85, 0.85, 0.82), 0.35, 0.3), true)
	quad(Vector2(0.3, 0.2), ep + Vector3(-1.4, 0.65, 0.46), 0.0, glow(Color(0.9, 0.3, 0.2) * 0.4, 1.2))
	neon_text(L["mood"], ep + Vector3(-1.4, 0.66, 0.47), 0.0, 0.035, Color(1.0, 0.5, 0.4), 1.4)
	box(Vector3(0.3, 0.2, 0.4), ep + Vector3(-0.5, 0.85, -0.2), mat(Color(0.9, 0.9, 0.9), 0.3))
	_hack(_it("emmet_desk", ep + Vector3(0, 0.85, 0), Vector3(1.7, 0.3, 0.8)))
	_hack(_it("mood_fridge", ep + Vector3(-1.4, 0.5, 0.2), Vector3(0.55, 0.95, 0.55)))
	# a mood strip in error red along the ceiling over the desks
	var cove := glow(Color(1.0, 0.15, 0.1), 1.0)
	var cv := box(Vector3(0.04, 0.04, 8.0), Vector3(-17.4, H - 0.08, 0), cove)
	flickers.append(cv)
	no_batch.append(cv)
	_hack(_it("desks", Vector3(-12.0, 1.0, 0), Vector3(1.0, 1.0, 1.0)))


# ------------------------------------------------------------------ Lynx's lab

func _lab() -> void:
	var L: Dictionary = LINES["labels"]
	light(LAB + Vector3(0, 2.8, 0), Color(0.45, 0.95, 1.0), 1.0, 8.0)
	# a glass partition with a gap, racks, the long bench under the window
	var g := box(Vector3(0.06, H, 5.0), Vector3(-6.0, H / 2.0, 11.5), _glass, true)
	g.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	box(Vector3(0.1, H, 0.1), Vector3(-6.0, H / 2.0, 9.0), _metal)
	box(Vector3(0.1, H, 0.1), Vector3(-6.0, H / 2.0, 14.0), _metal)
	neon_text(L["lab"], Vector3(-6.04, 2.0, 11.5), PI / 2.0, 0.07, Color(0.5, 0.95, 1.0), 1.4)
	box(Vector3(7.5, 0.05, 0.9), LAB + Vector3(0, 0.9, 1.0), _metal, true)
	box(Vector3(7.3, 0.85, 0.8), LAB + Vector3(0, 0.45, 1.0), _dark, true)
	for i in 3:
		_terminal(LAB + Vector3(-2.5 + i * 2.0, 0.93, 1.0), PI, true, Color(0.4, 0.9, 1.0))
	_chair(LAB + Vector3(-0.5, 0, 0.1 if not day2 else -0.6), PI + (0.0 if not day2 else 0.7))
	for i in 2:
		var rp := LAB + Vector3(-4.6, 0, -1.5 + i * 1.2)
		box(Vector3(0.6, 2.0, 0.8), rp + Vector3(0, 1.0, 0), _dark, true)
		for k in 12:
			var on := (k * 7 + i) % 5 != 0
			box(Vector3(0.02, 0.02, 0.01), rp + Vector3(0.31, 0.3 + k * 0.13, -0.3 + (k % 3) * 0.1), glow(Color(0.3, 1.0, 0.6) if on else Color(1.0, 0.2, 0.1), 2.0))
	_hack(_it("racks", LAB + Vector3(-4.6, 1.0, -0.9), Vector3(0.7, 2.0, 2.0)))
	# the bootleg shelf: three devices in evidence bags, this month's
	box(Vector3(2.4, 0.04, 0.4), LAB + Vector3(1.5, 1.6, 1.3), _white)
	var bag := newmat(Color(0.9, 0.9, 0.9, 0.45), 0.4)
	bag.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	for i in 3:
		var bp := LAB + Vector3(0.7 + i * 0.75, 1.72, 1.3)
		box(Vector3(0.5, 0.2, 0.3), bp, bag)
		box(Vector3(0.3, 0.05, 0.25) if i != 1 else Vector3(0.15, 0.14, 0.08), bp - Vector3(0, 0.06, 0), _dark)
		neon_text(L["bootleg"] % (i + 1), bp + Vector3(0, -0.16, 0.2), 0.0, 0.03, Color(1.0, 0.5, 0.4), 1.4)
	_hack(_it("devices", LAB + Vector3(1.5, 1.7, 1.3), Vector3(2.4, 0.3, 0.4)))
	# her terminal: sticky notes, a photo, the laptop she takes from Carl
	var note := mat(Color(1.0, 0.9, 0.3), 0.9)
	for i in 9:
		var q := quad(Vector2(0.08, 0.08), LAB + Vector3(-0.9 + (i % 3) * 0.1, 1.28 + (i / 3) * 0.1, 1.17), PI, note if i % 4 != 0 else mat(Color(1.0, 0.6, 0.7), 0.9))
		q.rotation.z = rng.randf_range(-0.2, 0.2)
	box(Vector3(0.12, 0.15, 0.02), LAB + Vector3(0.6, 1.0, 1.1), mat(Color(0.2, 0.2, 0.22), 0.5))
	quad(Vector2(0.1, 0.12), LAB + Vector3(0.6, 1.0, 1.085), PI, mat(Color(0.5, 0.45, 0.4), 0.8))
	lab_laptop = Node3D.new()
	lab_laptop.position = LAB + Vector3(-0.5, 0.93, 0.95)
	add_child(lab_laptop)
	var slate := mat(Color(0.05, 0.05, 0.06), 0.3, 0.5)
	box(Vector3(0.34, 0.016, 0.23), Vector3.ZERO, slate, false, lab_laptop)
	var lid := box(Vector3(0.34, 0.22, 0.01), Vector3(0, 0.11, 0.115), slate, false, lab_laptop)
	lid.rotation.x = 0.25
	lab_laptop.visible = not day2
	_hack(_it("lynx_desk", LAB + Vector3(-0.5, 1.0, 1.0), Vector3(1.0, 0.4, 0.8)))
	# a spare pair of frames
	box(Vector3(0.14, 0.03, 0.02), LAB + Vector3(2.4, 0.95, 0.9), mat(Color(0.1, 0.1, 0.12), 0.3), false)
	box(Vector3(0.14, 0.012, 0.012), LAB + Vector3(2.4, 0.95, 0.89), glow(Color(0.3, 0.95, 1.0), 2.0))


# ------------------------------------------------------------------ the break room and the stairwell

func _break_room() -> void:
	var L: Dictionary = LINES["labels"]
	light(Vector3(10.0, 3.0, 11.5), Color(1.0, 0.95, 0.88), 1.0, 8.0)
	# the kitchen run along the south, the coffee bot with its queue backed up
	box(Vector3(4.4, 0.9, 0.7), Vector3(9.0, 0.45, 15.2), _white, true)
	box(Vector3(4.5, 0.04, 0.8), Vector3(9.0, 0.92, 15.2), mat(Color(0.2, 0.2, 0.2), 0.3))
	cyl(0.18, 0.18, 0.5, Vector3(9.6, 1.19, 15.3), mat(Color(0.82, 0.82, 0.8), 0.35, 0.3), 12)
	stick(Vector3(9.6, 1.44, 15.3), Vector3(9.3, 1.3, 14.95), 0.03, _metal)
	cyl(0.04, 0.035, 0.1, Vector3(9.25, 0.99, 14.95), mat(Color(0.95, 0.95, 0.92), 0.6), 10)
	neon_text(L["brew"], Vector3(9.6, 1.2, 15.1), 0.0, 0.03, Color(1.0, 0.5, 0.3), 1.4)
	_hack(_it("coffeebot", Vector3(9.6, 1.1, 15.2), Vector3(0.5, 0.6, 0.5)))
	# a Nixtra machine and the smart fridge, dead
	var nx: Array = L["nixtra"]
	box(Vector3(1.0, 2.0, 0.8), Vector3(6.6, 1.0, 15.0), mat(Color(0.1, 0.4, 0.5), 0.4, 0.3), true)
	quad(Vector2(0.8, 1.2), Vector3(6.6, 1.2, 14.59), PI, glow(Color(0.3, 0.9, 1.0) * 0.4, 1.3))
	neon_text(nx[0], Vector3(6.6, 1.55, 14.57), PI, 0.13, Color(0.3, 0.95, 1.0), 1.6)
	neon_text(nx[1], Vector3(6.6, 1.25, 14.57), PI, 0.05, Color(0.95, 0.95, 0.9), 1.4)
	neon_text(nx[2], Vector3(6.6, 0.95, 14.57), PI, 0.08, Color(1.0, 0.3, 0.2), 1.6)
	_hack(_it("vending", Vector3(6.6, 1.0, 14.6), Vector3(1.0, 2.0, 0.4)))
	box(Vector3(0.9, 1.9, 0.8), Vector3(12.2, 0.95, 15.0), mat(Color(0.82, 0.82, 0.8), 0.35, 0.3), true)
	quad(Vector2(0.4, 0.3), Vector3(12.2, 1.5, 14.59), PI, _screen_off)
	box(Vector3(0.01, 0.06, 0.03), Vector3(12.2, 1.1, 14.59), glow(Color(1, 0.05, 0.05), 3.0))
	_hack(_it("fridge", Vector3(12.2, 1.0, 14.6), Vector3(0.9, 1.9, 0.4)))
	# a high table with stools
	cyl(0.45, 0.45, 0.04, Vector3(9.5, 1.05, 10.5), _white, 16)
	cyl(0.04, 0.2, 1.03, Vector3(9.5, 0.52, 10.5), _metal, 8)
	solid_box(Vector3(0.9, 1.05, 0.9), Vector3(9.5, 0.52, 10.5))
	for a in 3:
		var sp := Vector3(9.5, 0, 10.5) + Vector3(cos(a * 2.1), 0, sin(a * 2.1)) * 0.8
		cyl(0.17, 0.17, 0.04, sp + Vector3(0, 0.7, 0), _dark, 10)
		cyl(0.02, 0.02, 0.7, sp + Vector3(0, 0.35, 0), _metal, 6)
	# the wall with the TOKZ screen, the couch in front of it, a Psyon pillow
	box(Vector3(0.2, H, 7.0), Vector3(17.5, H / 2.0, 12.5), _plaster, true)
	var bsc: Array = L["break_screen"]
	box(Vector3(0.08, 1.4, 2.4), Vector3(17.36, 1.7, 12.0), _dark)
	quad(Vector2(2.2, 1.2), Vector3(17.3, 1.7, 12.0), -PI / 2.0, glow(Color(1.0, 0.3, 0.7) * 0.35, 1.3))
	neon_text(bsc[0], Vector3(17.28, 2.05, 12.0), -PI / 2.0, 0.14, Color(1.0, 0.3, 0.7), 1.6)
	neon_text(bsc[1], Vector3(17.28, 1.65, 12.0), -PI / 2.0, 0.08, Color(0.95, 0.95, 0.9), 1.4)
	neon_text(bsc[2], Vector3(17.28, 1.25, 12.0), -PI / 2.0, 0.06, Color(1.0, 0.4, 0.3), 1.6)
	# a smear of the park on the screen: yellow grass, the tape, a man-shape
	for k in 4:
		box(Vector3(0.01, 0.08, 0.4), Vector3(17.27, 1.45 + k * 0.03, 11.0 + k * 0.5), _neon(Color(0.9, 0.85, 0.3) if k % 2 == 0 else Color(0.3, 0.7, 0.3)))
	box(Vector3(0.01, 0.35, 0.12), Vector3(17.27, 1.6, 12.3), mat(Color(0.5, 0.05, 0.05), 0.5))
	_hack(_it("break_screen", Vector3(17.3, 1.7, 12.0), Vector3(0.3, 1.4, 2.4)))
	var couch := pbr("fabric", Vector3(1, 1, 1) / 1.0, true, Color(0.4, 0.42, 0.5))
	box(Vector3(0.9, 0.45, 2.4), Vector3(14.8, 0.22, 12.0), couch, true)
	box(Vector3(0.2, 0.5, 2.4), Vector3(14.4, 0.65, 12.0), couch)
	box(Vector3(0.7, 0.18, 0.45), Vector3(14.9, 0.55, 12.6), mat(Color(0.88, 0.88, 0.9), 0.9))
	box(Vector3(0.03, 0.02, 0.46), Vector3(15.24, 0.6, 12.6), glow(Color(0.3, 0.9, 1.0), 1.5))
	_it("couch", Vector3(14.8, 0.6, 12.0), Vector3(1.0, 0.6, 2.4))
	light(Vector3(16.5, 2.4, 12.0), Color(1.0, 0.4, 0.7), 0.7, 6.0)


func _stairwell() -> void:
	var L: Dictionary = LINES["labels"]
	# a plaster box behind the break room: x 6..11, z 17..23, the door north
	box(Vector3(0.2, H, 6.0), Vector3(6.0, H / 2.0, 20.0), _plaster, true)
	box(Vector3(0.2, H, 6.0), Vector3(11.0, H / 2.0, 20.0), _plaster, true)
	box(Vector3(5.2, H, 0.2), Vector3(8.5, H / 2.0, 23.0), _plaster, true)
	box(Vector3(2.0, H, 0.2), Vector3(7.0, H / 2.0, 17.0), _plaster, true)
	box(Vector3(2.0, H, 0.2), Vector3(10.0, H / 2.0, 17.0), _plaster, true)
	box(Vector3(1.2, H - 2.1, 0.2), Vector3(8.5, 2.1 + (H - 2.1) / 2.0, 17.0), _plaster, true)
	# the door, swung open into the room (Emmet comes through it)
	var leaf := box(Vector3(0.06, 2.1, 1.0), Vector3(7.95, 1.05, 17.55), _dark)
	leaf.rotation.y = PI / 2.0 - 0.25
	box(Vector3(0.1, 0.04, 0.12), Vector3(7.95, 1.0, 17.95), mat(Color(0.7, 0.7, 0.7), 0.3, 0.9))
	neon_text(L["stairs"], Vector3(8.5, 2.4, 16.88), 0.0, 0.08, Color(0.3, 1.0, 0.6), 1.4)
	_hack(_it("stairs", Vector3(8.5, 1.05, 17.0), Vector3(1.2, 2.1, 0.4)))
	floor_quad(Vector2(4.8, 5.8), Vector3(8.5, 0.007, 20.0), 0.0, pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.6, 0.6, 0.6)))
	light(Vector3(8.5, 3.0, 20.0), Color(0.9, 1.0, 0.95), 0.8, 6.0)
	# the flight up along the east wall, a landing, a gate at the top: 87
	var step := mat(Color(0.5, 0.5, 0.52), 0.8)
	for i in 9:
		box(Vector3(1.2, 0.2 * (i + 1), 0.3), Vector3(10.3, 0.1 * (i + 1), 17.7 + i * 0.3), step, true)
	box(Vector3(1.2, 0.1, 2.0), Vector3(10.3, 1.85, 21.4), step, true)
	box(Vector3(0.05, 0.9, 2.7), Vector3(9.7, 1.3, 19.0), _metal)
	box(Vector3(1.2, 2.4, 0.08), Vector3(10.3, 3.1, 22.4), _dark)
	box(Vector3(1.2, 0.08, 0.08), Vector3(10.3, 2.95, 22.3), glow(Color(1.0, 0.1, 0.1), 2.5))
	neon_text(L["stair_gate"] % 87, Vector3(10.3, 2.6, 22.3), PI, 0.07, Color(1.0, 0.3, 0.2), 1.6)
	# the flight down, behind a gate in the far wall: 85, home
	box(Vector3(2.0, 2.4, 1.0), Vector3(7.2, 1.2, 22.4), mat(Color(0.02, 0.02, 0.025), 1.0))
	for i in 4:
		box(Vector3(1.6, 0.05, 0.3), Vector3(7.2, 0.0 - i * 0.2, 22.0 + i * 0.3), step)
	for s: float in [-0.9, 0.9]:
		box(Vector3(0.12, 1.1, 0.12), Vector3(7.2 + s, 0.55, 21.9), _metal, true)
	box(Vector3(1.9, 0.12, 0.12), Vector3(7.2, 1.1, 21.9), _dark)
	box(Vector3(1.6, 0.04, 0.04), Vector3(7.2, 1.05, 21.9), glow(Color(1.0, 0.1, 0.1), 2.5))
	neon_text(L["stair_gate"] % 85, Vector3(7.2, 1.5, 21.95), 0.0, 0.07, Color(1.0, 0.3, 0.2), 1.6)
	solid_box(Vector3(2.0, 2.4, 0.2), Vector3(7.2, 1.2, 21.9))
	_hack(_it("stair_gate", Vector3(7.2, 1.2, 21.8), Vector3(2.0, 2.0, 0.4)))


# ------------------------------------------------------------------ the side offices and the server room

## Five glass-fronted offices along the west glass, their corridor at x -22..-19.
func _offices() -> void:
	var L: Dictionary = LINES["labels"]
	var names: Array = L["offices"]
	var ids := ["office_forner", "office_qa", "office_carl", "office_vacant", "office_storage"]
	var blind := newmat(Color(0.75, 0.75, 0.72, 0.9), 0.9)
	blind.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	for i in 5:
		var zc := -8.8 + i * 4.4
		# partitions, the glass front with its door gap, a nameplate
		box(Vector3(4.6, H, 0.12), Vector3(-25.8, H / 2.0, zc - 2.2), _plaster, true)
		if i == 4:
			box(Vector3(4.6, H, 0.12), Vector3(-25.8, H / 2.0, zc + 2.2), _plaster, true)
		var g := box(Vector3(0.06, H, 3.2), Vector3(-23.5, H / 2.0, zc - 0.6), _glass, true)
		g.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		box(Vector3(0.1, H, 0.1), Vector3(-23.5, H / 2.0, zc + 1.0), _metal)
		box(Vector3(0.1, H, 0.1), Vector3(-23.5, H / 2.0, zc + 2.2), _metal)
		box(Vector3(0.1, 0.1, 4.4), Vector3(-23.5, H - 0.05, zc), _metal)
		if i == 0 or i == 3:
			box(Vector3(0.03, H - 0.5, 3.1), Vector3(-23.6, H / 2.0 + 0.2, zc - 0.6), blind)
		if names[i] != "":
			neon_text(names[i], Vector3(-23.44, 2.3, zc - 0.6), PI / 2.0, 0.06, Color(0.85, 0.95, 0.9), 1.4)
		var dp := Vector3(-26.4, 0, zc)
		box(Vector3(1.6, 0.04, 0.8), dp + Vector3(0, 0.74, 0), _white, true)
		for x: float in [-0.75, 0.75]:
			box(Vector3(0.05, 0.72, 0.7), dp + Vector3(x, 0.36, 0), _metal)
		if i == 3:
			_chair(dp + Vector3(-0.9, 0, 0.0), PI / 2.0)
		else:
			_chair(dp + Vector3(0.9, 0, 0), -PI / 2.0)
		light(dp + Vector3(0.5, 2.9, 0), Color(1.0, 0.95, 0.88) if i != 0 else Color(0.5, 0.5, 0.6), 0.6 if i != 0 else 0.2, 5.0)
		match i:
			0:
				_terminal(dp + Vector3(-0.2, 0.76, 0), -PI / 2.0, false, Color(0.4, 0.8, 0.5))
			1:
				_terminal(dp + Vector3(-0.2, 0.76, 0), -PI / 2.0, true, Color(0.9, 0.4, 0.3), L["frames_r"][0])
				for k in 6:
					floor_quad(Vector2(0.21, 0.29), dp + Vector3(rng.randf_range(-0.6, 0.6), 0.761 + k * 0.001, rng.randf_range(-0.3, 0.3)), rng.randf() * TAU, tex_mat(Tex.paper(210 + k), Vector3.ONE, 0.9))
			2:
				# Carl's: the photo from Red Rock Plaza, his jacket, a pillow he never used
				_terminal(dp + Vector3(-0.2, 0.76, 0), -PI / 2.0, true, Color(0.3, 1.0, 0.6), L["carl_screen"])
				box(Vector3(0.02, 0.15, 0.12), dp + Vector3(0.1, 0.84, -0.3), mat(Color(0.2, 0.2, 0.22), 0.5))
				quad(Vector2(0.1, 0.13), dp + Vector3(0.115, 0.84, -0.3), PI / 2.0, mat(Color(0.75, 0.55, 0.4), 0.8))
				_it("office_carl_photo", dp + Vector3(0.1, 0.84, -0.3), Vector3(0.2, 0.25, 0.25))
				box(Vector3(0.1, 0.5, 0.5), dp + Vector3(1.15, 0.8, 0), mat(Color(0.12, 0.14, 0.15), 0.7))
				box(Vector3(0.45, 0.18, 0.7), dp + Vector3(0.3, 0.3, -1.6), mat(Color(0.88, 0.88, 0.9), 0.9))
				box(Vector3(0.9, 0.4, 0.8), dp + Vector3(0.3, 0.2, -1.6), pbr("fabric", Vector3(1, 1, 1) / 1.0, true, Color(0.4, 0.42, 0.5)), true)
			3:
				_terminal(dp + Vector3(-0.2, 0.76, 0), -PI / 2.0, false, Color(0.4, 0.8, 0.5))
			4:
				# field storage: racks of bagged pillows, frames and tablets
				var bag := newmat(Color(0.9, 0.9, 0.9, 0.45), 0.4)
				bag.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
				for k in 3:
					box(Vector3(3.6, 0.04, 0.5), Vector3(-25.8, 0.6 + k * 0.7, zc + 1.6), _white)
					for j in 5:
						var bp := Vector3(-27.3 + j * 0.75, 0.75 + k * 0.7, zc + 1.6)
						box(Vector3(0.5, 0.22, 0.35), bp, bag)
						box(Vector3(0.4, 0.12, 0.25) if (j + k) % 2 == 0 else Vector3(0.2, 0.05, 0.1), bp - Vector3(0, 0.05, 0), _dark if (j + k) % 3 != 0 else mat(Color(0.88, 0.88, 0.9), 0.9))
				solid_box(Vector3(3.6, 2.2, 0.6), Vector3(-25.8, 1.1, zc + 1.6))
		_hack(_it(ids[i], dp + Vector3(0, 0.9, 0), Vector3(1.8, 0.5, 1.0)))
	_it("corridor", Vector3(-20.5, 1.5, 0.0), Vector3(0.6, 2.0, 0.6))


## The floor's own racks: cold, loud, a keypad that lets anyone in, and the
## ORA node every pair of frames on 86 syncs through.
func _server_room() -> void:
	var L: Dictionary = LINES["labels"]
	# walls: x -23..-14, z -19..-12; the door on the east wall at z -14.5
	box(Vector3(9.0, H, 0.2), Vector3(-18.5, H / 2.0, -19.0), _plaster, true)
	box(Vector3(9.0, H, 0.2), Vector3(-18.5, H / 2.0, -12.0), _plaster, true)
	box(Vector3(0.2, H, 7.0), Vector3(-23.0, H / 2.0, -15.5), _plaster, true)
	box(Vector3(0.2, H, 4.0), Vector3(-14.0, H / 2.0, -17.0), _plaster, true)
	box(Vector3(0.2, H, 2.0), Vector3(-14.0, H / 2.0, -13.0), _plaster, true)
	box(Vector3(0.2, H - 2.1, 1.0), Vector3(-14.0, 2.1 + (H - 2.1) / 2.0, -14.5), _plaster, true)
	var leaf := box(Vector3(0.06, 2.1, 1.0), Vector3(-14.35, 1.05, -14.25), _dark)
	leaf.rotation.y = 0.75
	box(Vector3(0.14, 0.2, 0.03), Vector3(-13.9, 1.3, -15.3), mat(Color(0.1, 0.1, 0.11), 0.4, 0.5))
	box(Vector3(0.03, 0.03, 0.01), Vector3(-13.88, 1.36, -15.3), glow(Color(1.0, 0.2, 0.1), 2.0))
	neon_text(L["server"], Vector3(-13.88, 2.5, -15.5), PI / 2.0, 0.07, Color(0.5, 0.95, 1.0), 1.4)
	_hack(_it("server_door", Vector3(-13.9, 1.2, -14.9), Vector3(0.3, 2.2, 1.6)))
	floor_quad(Vector2(8.8, 6.8), Vector3(-18.5, 0.007, -15.5), 0.0, mat(Color(0.2, 0.22, 0.24), 0.6, 0.3))
	light(Vector3(-18.5, 2.9, -15.5), Color(0.4, 0.6, 1.0), 1.1, 8.0)
	light(Vector3(-21.5, 1.5, -17.5), Color(0.3, 1.0, 0.6), 0.5, 4.0)
	# three rows of racks
	var led_on := glow(Color(0.3, 1.0, 0.6), 2.0)
	var led_warn := glow(Color(1.0, 0.6, 0.1), 2.0)
	for row in 3:
		var z := -17.6 + row * 2.1
		for k in 5:
			var rp := Vector3(-21.6 + k * 1.1, 0, z)
			box(Vector3(0.7, 2.1, 0.9), rp + Vector3(0, 1.05, 0), _dark, true)
			for j in 14:
				var on := (j * 5 + k + row) % 7 != 0
				box(Vector3(0.02, 0.02, 0.01), rp + Vector3(-0.3 + (j % 4) * 0.12, 0.25 + j * 0.13, 0.455), led_on if on else led_warn)
			box(Vector3(0.5, 0.05, 0.02), rp + Vector3(0, 2.0, 0.455), mat(Color(0.3, 0.3, 0.32), 0.5))
	_hack(_it("racks_server", Vector3(-19.4, 1.0, -15.5), Vector3(5.4, 2.1, 1.0)))
	# cable trays along the ceiling, and the one run that goes down
	for z: float in [-18.2, -13.2]:
		box(Vector3(8.6, 0.08, 0.4), Vector3(-18.5, H - 0.3, z), _metal)
		for k in 7:
			box(Vector3(8.6, 0.03, 0.03), Vector3(-18.5, H - 0.25, z - 0.17 + k * 0.05), mat(Color(0.1, 0.1, 0.35) if k % 2 == 0 else Color(0.04, 0.04, 0.04), 0.7))
	var newrun := mat(Color(0.8, 0.5, 0.1), 0.6)
	stick(Vector3(-15.5, H - 0.3, -13.2), Vector3(-15.0, 0.05, -12.6), 0.02, newrun)
	box(Vector3(0.3, 0.06, 0.3), Vector3(-15.0, 0.03, -12.6), _dark)
	_hack(_it("cable_tray", Vector3(-15.2, 1.6, -12.8), Vector3(0.8, 3.0, 0.8)))
	# the ORA node on the north wall, its light never still
	var np := Vector3(-18.5, 1.3, -18.7)
	box(Vector3(1.2, 1.6, 0.4), np, mat(Color(0.14, 0.14, 0.16), 0.3, 0.6), true)
	node_light = box(Vector3(0.3, 0.3, 0.02), np + Vector3(0, 0.3, 0.21), glow(Color(1.0, 0.4, 0.7), 2.5))
	no_batch.append(node_light)
	neon_text(L["ora_node"], np + Vector3(0, -0.2, 0.21), 0.0, 0.05, Color(1.0, 0.5, 0.8), 1.5)
	var ring := TorusMesh.new()
	ring.inner_radius = 0.2
	ring.outer_radius = 0.24
	ring.rings = 24
	ring.ring_segments = 6
	mesh(ring, np + Vector3(0, 0.3, 0.22), glow(Color(1.0, 0.4, 0.7), 1.4)).rotation.x = PI / 2.0
	_hack(_it("ora_node", np + Vector3(0, 0, 0.3), Vector3(1.2, 1.6, 0.4)))


# ------------------------------------------------------------------ outside (ch.4: a jade-and-silver nail, a donut on a stick)

func _outside() -> void:
	# the shaft above and below the floor, and the donut on its stick
	var silver := mat(Color(0.7, 0.72, 0.75), 0.25, 0.8)
	cyl(R + 1.2, 30.0, 300.0, Vector3(0, -150.0, 0), _jade, 32)
	cyl(16.0, R + 1.2, 240.0, Vector3(0, H + 0.4 + 120.0, 0), _jade, 32)
	var tm := TorusMesh.new()
	tm.inner_radius = 58.0
	tm.outer_radius = 108.0
	tm.rings = 32
	tm.ring_segments = 12
	mesh(tm, Vector3(0, 252.0, 0), silver)
	# the city, 300 metres down, to the smog line
	var city := Node3D.new()
	add_child(city)
	kit_parent = city
	floor_quad(Vector2(1800, 1800), Vector3(0, -300.0, 0), 0.0, mat(Color(0.5, 0.42, 0.33), 1.0), city)
	for i in 130:
		var a := rng.randf() * TAU
		var d := rng.randf_range(85.0, 700.0)
		var h := rng.randf_range(30.0, 170.0)
		if d > 120.0 and d < 320.0 and rng.randf() < 0.06:
			h = rng.randf_range(240.0, 330.0)
		var w := rng.randf_range(16.0, 40.0)
		cyber_block(Vector3(sin(a) * d, -300.0, cos(a) * d), a + PI, w, h, rng.randf_range(16.0, 36.0), false, 1)
	kit_holo(Vector3(105.0, -40.0, -70.0), -PI / 2.0 + 0.6, "PSYON", "the pillow for those who dream", Color(0.4, 1.0, 0.6), 34.0)
	kit_holo(Vector3(-130.0, -60.0, 50.0), PI / 2.0 - 0.3, "ORA", "always watching over you", Color(1.0, 0.3, 0.7), 40.0)
	kit_holo(Vector3(30.0, -30.0, 150.0), PI + 0.15, "TOKZ", "sleep better. sleep together.", Color(1.0, 0.18, 0.62), 36.0)
	kit_holo(Vector3(-70.0, -90.0, -160.0), 0.4, "COGNIZO", "think for yourself", Color(1.0, 0.5, 0.12), 40.0)
	kit_parent = self
	_batch(city, 150.0, true)
	# hover traffic in the lanes round the tower, drones streaming to the donut
	for k in 2:
		var traffic = preload("res://scripts/Traffic.gd").new()
		if k == 0:
			traffic.lanes = [[-80.0, -24.0, 1.0], [-72.0, -32.0, -1.0], [80.0, -24.0, -1.0], [72.0, -32.0, 1.0], [-105.0, 12.0, 1.0], [105.0, 8.0, -1.0]]
		else:
			traffic.lanes = [[-90.0, -18.0, 1.0], [-82.0, -27.0, -1.0], [90.0, -18.0, -1.0], [82.0, -27.0, 1.0], [-110.0, 16.0, 1.0]]
			traffic.along_x = true
		traffic.s_min = -380.0
		traffic.s_max = 380.0
		traffic.count = 18
		traffic.tower_top = Vector3(0, 250.0, 0)
		traffic.drone_box = AABB(Vector3(-280, -250, -280), Vector3(560, 190, 560))
		traffic.drone_count = 110 if k == 0 else 0
		add_child(traffic)
		traffic.setup(main, self)
		for d in traffic.drone_data:
			var s: Vector3 = d["a"]
			if absf(s.x) < 70.0 and absf(s.z) < 70.0:
				d["a"] = s + Vector3(100.0 * signf(s.x + 0.01), 0, 100.0 * signf(s.z + 0.01))
	# the swarm: drones streaming up the shaft to the donut, like bees to a hive
	var swarm := Node3D.new()
	add_child(swarm)
	var shell := mat(Color(0.85, 0.82, 0.75), 0.5, 0.4)
	var lamp := glow(Color(1.0, 0.15, 0.1), 2.5)
	for i in 90:
		var t := float(i) / 90.0
		var a := t * TAU * 3.0 + rng.randf() * 0.4
		var rr := 36.0 + rng.randf() * 14.0 - t * 4.0
		var dp := Vector3(sin(a) * rr, 40.0 + t * 195.0 + rng.randf() * 6.0, cos(a) * rr)
		var dn := box(Vector3(1.4, 0.4, 1.4), dp, shell, false, swarm)
		dn.rotation.y = a + PI / 2.0
		dn.rotation.z = 0.25
		box(Vector3(0.3, 0.3, 0.3), dp + Vector3(0, -0.3, 0), lamp, false, swarm)
	_batch(swarm, 60.0)
	# a delivery drone holding outside the glass, its lens on the room
	var da := -0.45
	drone = Node3D.new()
	drone.position = Vector3(sin(da) * (R + 2.2), 1.9, cos(da) * (R + 2.2))
	add_child(drone)
	box(Vector3(0.7, 0.22, 0.7), Vector3.ZERO, mat(Color(0.85, 0.82, 0.75), 0.5, 0.4), false, drone)
	for s: Vector2 in [Vector2(-1, -1), Vector2(1, -1), Vector2(-1, 1), Vector2(1, 1)]:
		cyl(0.16, 0.16, 0.02, Vector3(s.x * 0.42, 0.12, s.y * 0.42), _dark, 10, drone)
	drone_lamp = box(Vector3(0.08, 0.08, 0.08), Vector3(0, -0.1, -0.3), glow(Color(1.0, 0.1, 0.1), 3.0), false, drone)
	cyl(0.05, 0.06, 0.08, Vector3(0, -0.05, -0.36), mat(Color(0.05, 0.05, 0.06), 0.2), 8, drone).rotation.x = PI / 2.0
	_hack(_it("drone", drone.position - Vector3(sin(da), 0, cos(da)) * 3.0, Vector3(1.6, 1.6, 1.6)))


# ------------------------------------------------------------------ people (ch.4 and ch.7)

func _people() -> void:
	# Dr. Turan: graying black hair in a surgically tight bun, a bad day
	turan = figure(Color(0.16, 0.16, 0.19), Color(0.8, 0.66, 0.56), {"hair": Color(0.2, 0.2, 0.22), "legs": Color(0.14, 0.14, 0.16), "arms": true, "knees": true, "long_coat": false})
	var th: Node3D = turan.get_meta("head")
	sphere(0.05, Vector3(0, 0.07, 0.1), mat(Color(0.2, 0.2, 0.22), 0.9), 8, th)
	turan.position = TABLE + Vector3(0, 0, -2.3) if not day2 else Vector3(-1.6, 0, -7.2)
	add_child(turan)
	turn_to(turan, TABLE if not day2 else SCREEN)
	_person("turan", turan)
	turan.set_meta("focus", TABLE + Vector3(0, 0.9, -0.8) if not day2 else SCREEN)
	cast.append(turan)
	# Forner: oldest on the team, carved out of sandstone
	forner = figure(Color(0.5, 0.42, 0.32), Color(0.72, 0.58, 0.45), {"hair": Color(0.55, 0.55, 0.52), "legs": Color(0.3, 0.26, 0.22), "arms": true, "knees": true, "long_coat": false})
	(forner.get_meta("body") as Node3D).scale = Vector3(1.22, 1.0, 1.18)
	if day2:
		forner.position = Vector3(2.9, 0, -7.1)
		add_child(forner)
		turn_to(forner, SCREEN)
	else:
		forner.position = Vector3(7.5, -0.41, -8.6)
		forner.rotation.y = PI
		add_child(forner)
		Anim.sit(forner)
		forner.set_meta("seated", true)
	forner.set_meta("focus", SCREEN if day2 else Vector3(7.5, 1.1, -7.9))
	_person("forner", forner)
	cast.append(forner)
	# Emmet: lanky, red hair that looks fake, a protein bar. Late, through the stairs.
	emmet = figure(Color(0.28, 0.38, 0.5), Color(0.9, 0.74, 0.64), {"hair": Color(0.8, 0.3, 0.1), "legs": Color(0.2, 0.2, 0.24), "arms": true, "knees": true, "scale": 1.06, "long_coat": false})
	var ea: Array = emmet.get_meta("arms")
	box(Vector3(0.04, 0.12, 0.03), Vector3(0, -0.66, -0.06), mat(Color(0.9, 0.75, 0.1), 0.4), false, ea[1])
	emmet.position = Vector3(0.6, 0, -7.4) if day2 else STAIR_DOOR + Vector3(0, 0, 0.8)
	emmet.visible = day2 or main.flags.has("reported")
	if not day2 and main.flags.has("reported"):
		emmet.position = TABLE + Vector3(2.2, 0, 2.4)
	add_child(emmet)
	turn_to(emmet, SCREEN if day2 else TABLE)
	emmet.set_meta("focus", SCREEN if day2 else TABLE + Vector3(0, 0.9, 0))
	_person("emmet", emmet)
	cast.append(emmet)
	# Lynx: mousy, frames on, the dark coat she never takes off. Not here on day 2.
	if not day2:
		lynx = figure(Color(0.1, 0.1, 0.12), Color(0.88, 0.76, 0.68), {"hair": Color(0.3, 0.2, 0.14), "long_hair": true, "legs": Color(0.1, 0.1, 0.12), "visor": true, "arms": true, "knees": true, "scale": 0.94, "long_coat": true})
		lynx.position = TABLE + Vector3(-3.0, 0, 2.0)
		add_child(lynx)
		turn_to(lynx, TABLE)
		lynx.set_meta("focus", TABLE + Vector3(0, 0.9, 0))
		_person("lynx", lynx)
		cast.append(lynx)
	# two contract guards, frames on, posted where nobody posted them.
	# They turn to keep Carl in the middle of their frames when his are on.
	_guard("guard", Vector3(6.8, 0, 8.0), Vector3(0, 0, 9.6))
	_guard("guard2", Vector3(-12.8, 0, -16.2), Vector3(-12.8, 0, -10.0))


func _person(id: String, fig: Node3D) -> CollisionObject3D:
	var e: Array = LINES["items"][id]
	return person(id, e[0], fig, e[1])


func _guard(id: String, pos: Vector3, facing: Vector3) -> void:
	var g := figure(Color(0.05, 0.07, 0.12), Color(0.7, 0.58, 0.5) if id == "guard" else Color(0.5, 0.38, 0.3), {"hair": Color(0.06, 0.06, 0.07), "legs": Color(0.05, 0.06, 0.1), "visor": true, "arms": true, "knees": true, "scale": 1.04, "long_coat": false})
	g.position = pos
	add_child(g)
	turn_to(g, facing)
	var body: Node3D = g.get_meta("body")
	box(Vector3(0.06, 0.06, 0.02), Vector3(0.08, 0.18, -0.13), glow(Color(1.0, 0.3, 0.3), 1.5), false, body)
	box(Vector3(0.18, 0.04, 0.09), Vector3(0, -0.02, -0.14), _dark, false, body)
	g.set_meta("guard", true)
	g.set_meta("home_yaw", g.rotation.y)
	_person(id, g).set_meta("guard", true)
	guards.append(g)


## A person for the hidden sets: faces -Z, as all figures do.
func _set_figure(parent: Node3D, coat: Color, skin: Color, opts: Dictionary, pos: Vector3) -> Node3D:
	opts["arms"] = true
	opts["knees"] = true
	var f := figure(coat, skin, opts)
	f.position = pos
	parent.add_child(f)
	return f


# ------------------------------------------------------------------ the hidden sets (render layer 20)

## Zeta & Park Ave at night (the three seconds, ch.4), and the Cognizo
## subway car (the livestream, ch.7), built 70 and 110 m down the shaft
## where only a picture camera sees them.
func _sets() -> void:
	var L: Dictionary = LINES["labels"]
	# ---- A: the corner. One camera that didn't go dark.
	set_a = Node3D.new()
	set_a.position = SET_A
	add_child(set_a)
	var night := StandardMaterial3D.new()
	night.albedo_color = Color(0.1, 0.09, 0.1)
	night.roughness = 0.9
	floor_quad(Vector2(20, 20), Vector3.ZERO, 0.0, pbr("asphalt", Vector3(1, 1, 1) / 4.0, true, Color(0.3, 0.3, 0.32)), set_a)
	box(Vector3(20, 10, 0.3), Vector3(0, 5, -7.5), night, false, set_a)
	box(Vector3(0.3, 10, 16), Vector3(-6.5, 5, 0), night, false, set_a)
	box(Vector3(20, 10, 0.3), Vector3(0, 5, 4.0), night, false, set_a)
	box(Vector3(20, 0.3, 20), Vector3(0, 10, 0), night, false, set_a)
	box(Vector3(8, 0.12, 2.0), Vector3(-2, 0.06, -6.3), mat(Color(0.35, 0.34, 0.33), 0.9), false, set_a)
	for i in 6:
		box(Vector3(0.9, 1.4, 0.1), Vector3(-5.5 + i * 2.0, 3.2, -7.3), glow(Color(0.9, 0.7, 0.4) if i % 3 != 1 else Color(0.1, 0.1, 0.1), 0.7), false, set_a)
	neon_text(L["zeta"], Vector3(-4.5, 2.4, -7.3), 0.0, 0.3, Color(1.0, 0.3, 0.6), 2.0, set_a)
	neon_text(L["park"], Vector3(2.0, 1.3, -7.3), 0.0, 0.18, Color(0.3, 0.9, 1.0), 1.6, set_a)
	cyl(0.06, 0.08, 5.0, Vector3(2.8, 2.5, -1.5), _metal, 8, set_a)
	box(Vector3(0.5, 0.2, 0.4), Vector3(2.6, 5.0, -1.9), _dark, false, set_a)
	box(Vector3(0.4, 0.05, 0.3), Vector3(2.6, 4.88, -1.9), glow(Color(1.0, 0.75, 0.45), 3.0), false, set_a)
	var la := OmniLight3D.new()
	la.position = Vector3(2.6, 4.6, -1.9)
	la.light_color = Color(1.0, 0.72, 0.4)
	la.light_energy = 3.2
	la.omni_range = 11.0
	la.light_cull_mask = 1 << 19
	set_a.add_child(la)
	var lb := OmniLight3D.new()
	lb.position = Vector3(-3.0, 3.0, -5.5)
	lb.light_color = Color(0.5, 0.7, 1.0)
	lb.light_energy = 1.2
	lb.omni_range = 8.0
	lb.light_cull_mask = 1 << 19
	set_a.add_child(lb)
	# Dufredy: slack face, white hair, nothing where his eyes were, blood to the jaw
	dufredy_set = _set_figure(set_a, Color(0.5, 0.5, 0.48), Color(0.8, 0.68, 0.6), {"hair": Color(0.85, 0.85, 0.8), "legs": Color(0.42, 0.42, 0.44), "long_coat": false}, Vector3(0.4, 0, -3.6))
	var dh: Node3D = dufredy_set.get_meta("head")
	var socket := mat(Color(0.12, 0.02, 0.02), 0.3)
	for x: float in [-0.04, 0.04]:
		sphere(0.024, Vector3(x, 0.025, -0.1), socket, 8, dh)
		var bq := quad(Vector2(0.05, 0.13), Vector3(x, -0.04, -0.117), 0.0, decal_mat(Tex.blood(9 + int(x * 100.0)), Color(1, 1, 1), 0.3), dh)
		bq.rotation.y = PI
	turn_to(dufredy_set, Vector3(1.6, 0, 1.4))
	# the masked figure a step behind him, talking
	masked_set = _set_figure(set_a, Color(0.02, 0.02, 0.025), Color(0.6, 0.6, 0.6), {"hair": Color(0.02, 0.02, 0.02), "long_coat": true}, Vector3(-0.75, 0, -4.9))
	(masked_set.get_meta("body") as Node3D).scale = Vector3(1.0, 1.22, 1.0)
	(masked_set.get_meta("body") as Node3D).position.y = -0.22
	masked_set.scale = Vector3.ONE * 1.12
	var mh: Node3D = masked_set.get_meta("head")
	box(Vector3(0.22, 0.28, 0.04), Vector3(0, 0.0, -0.12), mat(Color(0.88, 0.86, 0.8), 0.15, 0.6), false, mh)
	cyl(0.0, 0.17, 0.35, Vector3(0, 0.2, 0.02), mat(Color(0.02, 0.02, 0.025)), 8, mh)
	var ms := Sprite3D.new()
	ms.texture = _glyph_tex
	ms.pixel_size = 0.0014
	ms.modulate = Color(0.1, 0.02, 0.02)
	ms.position = Vector3(0, 0.02, -0.142)
	ms.rotation.y = PI
	mh.add_child(ms)
	turn_to(masked_set, Vector3(0.4, 0, -3.6))
	masked_set.rotation.y += 0.5
	_batch(set_a, 100.0)
	_set_layer(set_a, 1 << 19)
	# ---- B: the subway car, from a passenger's ORA frames
	set_b = Node3D.new()
	set_b.position = SET_B
	add_child(set_b)
	var cream := mat(Color(0.78, 0.78, 0.74), 0.6)
	var seat := pbr("fabric", Vector3(1, 1, 1) / 1.0, true, Color(0.25, 0.3, 0.55))
	box(Vector3(2.9, 0.1, 13), Vector3(0, -0.05, 0), mat(Color(0.3, 0.3, 0.32), 0.8), false, set_b)
	box(Vector3(2.9, 0.08, 13), Vector3(0, 2.3, 0), cream, false, set_b)
	for s: float in [-1.0, 1.0]:
		box(Vector3(0.08, 2.3, 13), Vector3(s * 1.42, 1.15, 0), cream, false, set_b)
		for k in 5:
			box(Vector3(0.1, 0.8, 1.3), Vector3(s * 1.42, 1.55, -5.0 + k * 2.5), mat(Color(0.02, 0.03, 0.05), 0.1, 0.4), false, set_b)
		box(Vector3(0.45, 0.45, 11), Vector3(s * 1.12, 0.225, 0), seat, false, set_b)
		box(Vector3(0.08, 0.5, 11), Vector3(s * 1.34, 0.7, 0), seat, false, set_b)
		for k in 4:
			cyl(0.025, 0.025, 2.3, Vector3(s * 0.75, 1.15, -4.5 + k * 3.0), _metal, 6, set_b)
		for k in 3:
			box(Vector3(0.3, 0.03, 2.5), Vector3(s * 0.6, 2.26, -4.0 + k * 4.0), glow(Color(0.85, 0.92, 1.0), 1.4), false, set_b)
	box(Vector3(2.9, 2.3, 0.08), Vector3(0, 1.15, -6.5), cream, false, set_b)
	box(Vector3(2.9, 2.3, 0.08), Vector3(0, 1.15, 6.5), cream, false, set_b)
	neon_text(L["cognizo"], Vector3(0, 2.1, -6.45), 0.0, 0.07, Color(1.0, 0.5, 0.12), 1.6, set_b)
	for k in 2:
		var lk := OmniLight3D.new()
		lk.position = Vector3(0, 2.0, -3.0 + k * 5.0)
		lk.light_color = Color(0.8, 0.9, 1.0)
		lk.light_energy = 1.6
		lk.omni_range = 8.0
		lk.light_cull_mask = 1 << 19
		set_b.add_child(lk)
		set_b_lights.append(lk)
	# the eye, sprayed across the walls, and under the middle one's feet
	var paint := Color(0.5, 0.06, 0.03)
	for s: float in [-1.0, 1.0]:
		for z: float in [-2.6, 0.2, 2.8]:
			var sp := Sprite3D.new()
			sp.texture = _glyph_tex
			sp.pixel_size = 0.0062
			sp.modulate = paint
			sp.shaded = true
			sp.position = Vector3(s * 1.37, 1.05, z)
			sp.rotation.y = -s * PI / 2.0
			set_b.add_child(sp)
			var lf := Sprite3D.new()
			lf.texture = _glyph_tex
			lf.pixel_size = 0.0085
			lf.modulate = Color(1.0, 0.15, 0.08, 0.8)
			lf.shaded = false
			lf.double_sided = true
			lf.position = Vector3(s * 0.85, 1.1, z + 0.2)
			lf.rotation = Vector3(0.3, -s * PI / 2.0 + 0.4, 0.2)
			lf.visible = false
			set_b.add_child(lf)
			lifted.append(lf)
	var fl := Sprite3D.new()
	fl.texture = _glyph_tex
	fl.pixel_size = 0.007
	fl.modulate = paint
	fl.shaded = true
	fl.position = Vector3(0, 0.012, -1.5)
	fl.rotation.x = -PI / 2.0
	set_b.add_child(fl)
	# three men in black cloaks: two painting, one sat cross-legged, chanting
	var cloak := Color(0.03, 0.03, 0.035)
	var hoods := []
	hoods.append(_set_figure(set_b, cloak, Color(0.55, 0.5, 0.48), {"hair": cloak, "long_coat": true}, Vector3(-0.7, 0, -3.0)))
	hoods.append(_set_figure(set_b, cloak, Color(0.5, 0.45, 0.42), {"hair": cloak, "long_coat": true}, Vector3(0.7, 0, -2.2)))
	hoods.append(_set_figure(set_b, cloak, Color(0.6, 0.55, 0.5), {"hair": cloak, "long_coat": true}, Vector3(0, -0.76, -1.5)))
	hoods[0].rotation.y = PI / 2.0
	hoods[1].rotation.y = -PI / 2.0
	hoods[2].rotation.y = PI
	for i in 3:
		var hd: Node3D = hoods[i].get_meta("head")
		cyl(0.0, 0.18, 0.36, Vector3(0, 0.2, 0.03), mat(cloak), 8, hd)
		for x: float in [-0.04, 0.04]:
			sphere(0.026, Vector3(x, 0.025, -0.1), mat(Color(0.01, 0.01, 0.012), 0.05, 0.6), 8, hd)
		var arms: Array = hoods[i].get_meta("arms")
		if i < 2:
			(arms[1] as Node3D).rotation.x = -1.7
			box(Vector3(0.06, 0.16, 0.06), Vector3(0, -0.7, -0.03), mat(Color(0.8, 0.1, 0.1), 0.4), false, arms[1])
	var legs: Array = hoods[2].get_meta("legs")
	var knees: Array = hoods[2].get_meta("knees")
	for i in legs.size():
		var s := 1.0 if i == 0 else -1.0
		(legs[i] as Node3D).rotation = Vector3(PI / 2.0, s * 0.8, 0)
		if i < knees.size():
			(knees[i] as Node3D).rotation.z = -s * 2.0
	var arms2: Array = hoods[2].get_meta("arms")
	for a in arms2:
		(a as Node3D).rotation.x = -0.9
		(a as Node3D).rotation.z = (0.5 if (a as Node3D).position.x > 0.0 else -0.5)
	# the passengers, looking anywhere else
	var coats := [Color(0.3, 0.3, 0.35), Color(0.5, 0.4, 0.3), Color(0.2, 0.3, 0.25), Color(0.55, 0.55, 0.6), Color(0.4, 0.15, 0.15)]
	var skins := [Color(0.85, 0.66, 0.52), Color(0.6, 0.42, 0.3), Color(0.4, 0.28, 0.2), Color(0.92, 0.78, 0.66)]
	var seats := [[-1.1, -4.2, -PI / 2.0], [-1.1, 1.4, -PI / 2.0], [-1.1, 3.6, -PI / 2.0], [1.1, -0.4, PI / 2.0], [1.1, 2.6, PI / 2.0], [1.1, 4.6, PI / 2.0]]
	for i in seats.size():
		var s: Array = seats[i]
		var f := _set_figure(set_b, coats[i % coats.size()], skins[i % skins.size()], {"visor": i % 2 == 0, "long_hair": i % 3 == 0}, Vector3(s[0], 0.04, s[1]))
		f.rotation.y = s[2]
		Anim.sit(f)
		Anim.look(f, SET_B + Vector3(0, 1.4, 7.0), 1.0, 1.0)
	# the last frame: Psyon's interface on the passenger's glasses
	var blk := newmat(Color(0.0, 0.0, 0.0), 1.0)
	blk.cull_mode = BaseMaterial3D.CULL_DISABLED
	box(Vector3(3, 2, 3), Vector3(0, 5, 0), blk, false, set_b)
	var wl := Label3D.new()
	wl.text = LINES["subway"]["welcome_plain"]
	wl.font_size = 96
	wl.pixel_size = 0.004
	wl.outline_size = 0
	wl.modulate = Color(0.5, 0.9, 0.7)
	wl.position = Vector3(0, 5, -0.4)
	set_b.add_child(wl)
	_batch(set_b, 100.0)
	_set_layer(set_b, 1 << 19)


func _set_layer(n: Node, layer: int) -> void:
	if n is VisualInstance3D:
		(n as VisualInstance3D).layers = layer
	for c in n.get_children():
		_set_layer(c, layer)


## A still from a camera that can see layer 20.
func _picture(from: Vector3, at: Vector3, fov := 70.0) -> Texture2D:
	var vp := SubViewport.new()
	vp.size = Vector2i(640, 400)
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
	return ImageTexture.create_from_image(img)


## The tower cutscene panels (ch.4): the donut on a stick, the bees.
func _panel(n: int) -> Texture2D:
	var env: Environment = main.env
	var fog: float = env.fog_density
	env.fog_density = 0.0005
	var tex: Texture2D
	if n == 1:
		tex = await _picture(Vector3(110.0, 10.0, 520.0), Vector3(0, 30.0, 0), 66.0)
	else:
		tex = await _picture(Vector3(14.0, 196.0, 70.0), Vector3(0, 232.0, 0), 72.0)
	env.fog_density = fog
	return tex


func _show_on_big(tex: Texture2D) -> void:
	big_mat.albedo_texture = tex
	big_mat.albedo_color = Color(0.95, 1.0, 0.95)
	feed_root.visible = false


# ------------------------------------------------------------------ the chapter

## A look line from LINES["look"]: one string or several.
func _look(key: String) -> void:
	var v = LINES["look"][key]
	if v is Array:
		await _think_all(v)
	else:
		await main.ui.think(str(v))


func objective() -> String:
	var f: Dictionary = main.flags
	var O: Dictionary = LINES["objective"]
	if day2:
		if not f.has("subway_seen"):
			return O["d2_join"]
		if not f.has("emmet_briefed"):
			return O["d2_emmet"]
		return O["d2_leave"]
	if f.has("footage"):
		return O["d1_leave"]
	if f.has("lynx_logs"):
		return O["d1_forner"]
	if f.has("reported"):
		return O["d1_lynx"]
	return O["d1_turan"]


## Ch.4: eighty-five floors slide by. Ch.7: he avoids eye contact with the counter.
func intro() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var I: Dictionary = LINES["intro"]
	f["cinematic"] = true
	await get_tree().create_timer(0.4).timeout
	var hum: Node = main.loop("hum", -16.0, CAR + Vector3(0, 2.0, 0), 1.5, 6.0)
	hum.play()
	var cnt := create_tween()
	cnt.tween_method(_set_floor, 1.0, 86.0, 9.0).set_trans(Tween.TRANS_SINE)
	if day2:
		await ui.think(I["d2"][0])
		await _say("feed", I["d2_feed"])
		await ui.think(I["d2"][1])
		# one frame of the thing he isn't looking at
		eye_in.visible = true
		counter_in.visible = false
		await get_tree().create_timer(0.12).timeout
		eye_in.visible = false
		counter_in.visible = true
	else:
		# the tower cutscene: two panels from outside the glass
		var p1: Texture2D = await _panel(1)
		var p2: Texture2D = await _panel(2)
		ui.show_picture(p1, I["panel1"])
		await ui.think(I["d1"][0])
		ui.show_picture(p2, I["panel2"])
		await ui.think(I["bees"])
		ui.hide_picture()
		await ui.think(I["d1"][1])
		await _say("elevator", I["voice"])
	ui.close()
	if cnt.is_running():
		await cnt.finished
	main.play("ding", -4.0)
	await _doors(door_l, door_r, true)
	if day2:
		await ui.think(I["d2_arrive"])
		await _say("turan", I["d2_turan"])
		await _say("emmet", I["d2_emmet"])
	else:
		await _think_all(I["d1_arrive"])
		for l in I["turan_open"]:
			await _say("turan", str(l))
		await ui.think(I["turan_note"])
	ui.close()
	f.erase("cinematic")
	main.update_hud()


func _set_floor(v: float) -> void:
	var t := "%d" % int(v)
	counter_in.text = t
	counter_out.text = t


func interact(node: Object) -> bool:
	var ui = main.ui
	var f: Dictionary = main.flags
	var id := str(node.get_meta("id"))
	match id:
		"turan":
			if day2:
				await _turan_day2()
			else:
				await _turan_day1()
		"lynx":
			await _lynx_day1()
		"emmet":
			if day2:
				await _emmet_day2()
			else:
				await _emmet_day1()
		"forner":
			if day2:
				await _forner_day2()
			else:
				await _forner_day1()
		"elevator":
			if day2:
				await _elevator_day2()
			else:
				await _elevator_day1()
		"screens":
			if day2:
				if not f.has("subway_seen"):
					await _subway_scene()
				else:
					await ui.think(LINES["subway"]["after"])
			elif f.has("footage"):
				await _look("screens_footage")
			else:
				await _look("screens")
		"lynx_desk":
			await _look("lynx_desk_d2" if day2 else "lynx_desk")
		"window":
			await _look("window")
			if f.has("footage") or day2:
				await _look("window_after")
		"drone":
			await _look("drone")
			if main.frames_on and main.connection >= 25.0:
				main.play("whisper", -6.0, 0.8)
				await _look("drone_frames")
		"guard", "guard2":
			await _look(id)
			if main.frames_on:
				await _look("guard_frames")
		_:
			if LINES["look"].has(id):
				await _look(id)
			else:
				return false
	return true


# ------------------------------------------------------------------ day 1 (ch.4)

## The report. Lynx takes the laptop, Emmet comes in late through the
## stairs, the masked friend, Forner's cameras, and the stance.
func _turan_day1() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var T: Dictionary = LINES["turan_report"]
	if f.has("reported"):
		await _say("turan", T["busy_footage"] if f.has("footage") else T["busy"])
		return
	f["cinematic"] = true
	await ui.think(T["look_up"][0])
	turn_to(turan, main.player.global_position, 0.5)
	await ui.think(T["look_up"][1])
	await _say("turan", T["knight"])
	await ui.think(T["cognizo"])
	for l in T["report"]:
		await _say("carl", str(l))
	# the framing (Spin, first use): Drugs / Mental illness / Sabotage / The truth
	await ui.think(T["framing_ask"])
	var frame: int = await ui.choose(T["framing_choices"])
	var fkey: String = ["drugs", "mental", "sabotage", "truth"][clampi(frame, 0, 3)]
	f["report_framing"] = fkey
	await _say("carl", T["framing"][fkey][0])
	await _say("turan", T["framing"][fkey][1])
	main.log_line("report", T["framing_why"][fkey])
	match fkey:
		"drugs":
			main.add_pressure(-10.0, T["framing_why"][fkey])
			main.add_trust("turan", 1)
		"mental":
			main.add_pressure(-5.0, T["framing_why"][fkey])
		"sabotage":
			main.add_pressure(5.0, T["framing_why"][fkey])
			main.add_trust("turan", 1)
		_:
			main.add_pressure(15.0, T["framing_why"][fkey])
			main.add_trust("turan", -1)
			main.add_connection(2.0, T["framing_why"][fkey])
	if fkey == "truth":
		# the name is already on the table; she buries it
		f["told_turan_name"] = true
		main.add_stance("investigator")
	else:
		await ui.think(T["debate"])
		var pick: int = await ui.choose(T["choices"])
		if pick == 0:
			await ui.think(T["hide"])
			f["hid_name_from_turan"] = true
			main.add_stance("company_man")
		else:
			await _say("carl", T["tell"])
			await _say("turan", T["tell_reply"])
			f["told_turan_name"] = true
			main.add_trust("turan", -1)
			main.add_stance("investigator")
	await ui.think(T["slump"])
	await _say("turan", T["loser"])
	ui.close()
	# Lynx takes the laptop and goes; Emmet comes in late through the stairs door
	await ui.think(T["lynx_moves"])
	await _say("carl", T["trail"])
	await ui.think(T["no_logs"])
	ui.close()
	lynx.remove_meta("focus")
	_walk_path(lynx, [Vector3(-6.2, 0, -1.0), Vector3(-6.8, 0, 6.5), LAB + Vector3(-0.5, 0, -0.1)], 1.5)
	await get_tree().create_timer(0.6).timeout
	main.play("slam", -10.0, 1.3)
	emmet.visible = true
	_walk_path(emmet, [Vector3(6.6, 0, 12.5), Vector3(6.0, 0, 6.0), Vector3(6.2, 0, -2.0), TABLE + Vector3(2.2, 0, 2.4)], 2.1)
	await main.player.face(STAIR_DOOR + Vector3(0, 1.6, 0), 0.8)
	await ui.think(T["door"])
	await _say("turan", T["late"])
	await _say("emmet", T["slower"])
	await ui.think(T["grin"])
	ui.close()
	await main.player.face(turan.global_position + Vector3(0, 1.6, 0), 0.8)
	await _say("carl", T["friend"])
	await ui.think(T["spin"])
	await _say("turan", T["shifts"])
	turn_to(forner, main.player.global_position, 0.6)
	await _say("forner", T["forner"])
	await ui.think(T["forner_note"])
	await _say("turan", T["out"])
	var stand: int = await ui.choose(T["stand"])
	if stand == 1:
		await _say("carl", T["stand"][1])
		await ui.think(T["refuse_quiet"])
		await _say("turan", T["refuse_reply"])
		await _say("forner", T["refuse_forner"])
		f["refused_turan"] = true
		main.add_pressure(12.0, T["refuse_why"])
		main.add_trust("turan", -1)
	else:
		await _say("carl", T["stand"][0])
	await _file_theory()
	ui.close()
	f["reported"] = true
	f.erase("cinematic")
	turan.set_meta("focus", TABLE + Vector3(0, 0.9, -0.8))
	emmet.set_meta("focus", TABLE + Vector3(0, 0.9, 0))
	lynx.set_meta("focus", LAB + Vector3(-0.5, 1.1, 1.0))
	main.update_hud()
	ui.show_toast(T["toast"], 3.5)


## The theory pinned on the case file is what Turan hears (read from
## main.flags["theory"] when an earlier scene pinned it, asked here when
## not). None of them is wrong yet.
func _file_theory() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var T: Dictionary = LINES["theory"]
	var key := str(f.get("theory", ""))
	if not key in ["drugs", "hacker", "beneath"]:
		await ui.think(T["ask"])
		var pick: int = await ui.choose(T["choices"])
		key = ["drugs", "hacker", "beneath"][clampi(pick, 0, 2)]
		f["theory"] = key
	await _say("carl", T[key][0])
	await _say("turan", T[key][1])
	match key:
		"drugs":
			main.add_pressure(-10.0, "the theory: drugs")
			main.add_trust("turan", 1)
		"hacker":
			main.add_pressure(5.0, "the theory: a hacker")
		_:
			main.add_pressure(15.0, "the theory: not folklore")
			main.add_trust("turan", -1)


## The lab bench: no logs, the third bootleg, and the photo on the table.
func _lynx_day1() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var T: Dictionary = LINES["lynx_logs"]
	if not f.has("reported"):
		await _think_all(T["early"])
		return
	if f.has("lynx_logs"):
		await _say("lynx", T["done"])
		return
	f["cinematic"] = true
	turn_to(lynx, main.player.global_position, 0.5)
	await ui.think(T["fiance"])
	await ui.think(T["exasperated"])
	await _say("lynx", T["no_logs"])
	await _say("lynx", T["real_thing"])
	# Turan, from the war room, loud enough
	turn_to(turan, lynx.global_position, 0.6)
	await _say("turan", T["turan"])
	await ui.think(T["phone"])
	ui.show_picture(_glyph_tex, T["caption"])
	await _say("carl", T["symbol"])
	await main.player.face(lynx.global_position + Vector3(0, 1.6, 0), 0.8)
	await _say("lynx", T["eye"])
	await _say("carl", T["all_day"])
	ui.hide_picture()
	ui.close()
	f["lynx_logs"] = true
	turn_to(turan, TABLE, 0.6)
	f.erase("cinematic")
	main.update_hud()
	await get_tree().create_timer(0.8).timeout
	ui.show_toast(T["toast"], 4.0)


func _emmet_day1() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var T: Dictionary = LINES["emmet_d1"]
	turn_to(emmet, main.player.global_position, 0.5)
	await _say("emmet", T["ask"])
	await ui.think(T["note"])
	var pick: int = await ui.choose(T["choices"])
	if pick == 0:
		await _say("carl", T["friend"])
		await ui.think(T["bite"])
		f["emmet_told"] = true
	else:
		await _say("carl", T["slower"])
		await _say("emmet", T["matched"])


## Three seconds between Zeta and Park Ave, on the big screen.
func _forner_day1() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var T: Dictionary = LINES["footage"]
	if not f.has("lynx_logs"):
		await _say("forner", T["working"])
		return
	if f.has("footage"):
		await _say("forner", T["done"])
		return
	f["cinematic"] = true
	await _say("forner", T["got_it"])
	ui.close()
	# the big screen comes to life
	var cam_from := SET_A + Vector3(1.6, 3.4, 1.4)
	Anim.look(dufredy_set, cam_from, 1.0, 1.0)
	var tex: Texture2D = await _picture(cam_from, SET_A + Vector3(0.2, 1.3, -4.2), 70.0)
	main.play("on", -8.0, 0.7)
	_show_on_big(tex)
	for p in cast:
		turn_to(p, SCREEN, 0.7)
		(p as Node3D).set_meta("focus", SCREEN)
	await main.player.face(SCREEN, 1.0)
	ui.show_picture(tex, T["caption"])
	await ui.think(T["stared"])
	await ui.think(T["dufredy"])
	await ui.think(T["silence"])
	ui.hide_picture()
	await _say("turan", T["pr"])
	await _say("turan", T["manhunt"])
	main.play("sting", -8.0, 0.7)
	ui.glitch(0.35, 0.8)
	await ui.think(T["lingered"])
	await ui.think(T["agata"])
	await _say("lynx", T["watched"])
	await ui.think(T["objective"])
	await _say("turan", T["saltech"])
	await ui.think(T["bag"])
	ui.close()
	f["footage"] = true
	f.erase("cinematic")
	main.add_connection(1.0, T["connection"])
	main.update_hud()


func _elevator_day1() -> void:
	var f: Dictionary = main.flags
	if not f.has("footage"):
		await main.ui.think(LINES["handoff"]["not_yet"])
		return
	if _ended:
		return
	await _lynx_handoff()
	await _ride_down()


## Soft footsteps behind him at the elevator: the laptop, The Hypnogogue.
func _lynx_handoff() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var T: Dictionary = LINES["handoff"]
	if f.has("lynx_warned") or not lynx:
		return
	f["lynx_warned"] = true
	f["cinematic"] = true
	main.play("step", -14.0, 0.9)
	await ui.think(T["still_up"])
	await ui.think(T["button"])
	ui.close()
	var pp: Vector3 = main.player.global_position
	var stand := pp + Vector3(-1.4, 0, 1.2)
	lynx.position = Vector3(-6.5, 0, 7.5)
	lynx.visible = true
	lab_laptop.visible = false
	lynx.remove_meta("focus")
	_walk(lynx, stand, 1.6)
	await get_tree().create_timer(1.0).timeout
	await _say("lynx", T["carl"])
	await main.player.face(stand + Vector3(0, 1.55, 0), 0.9)
	await get_tree().create_timer(0.6).timeout
	turn_to(lynx, pp, 0.3)
	lynx.set_meta("focus", pp + Vector3(0, 1.6, 0))
	await ui.think(T["turned"])
	await _say("lynx", T["take_it"])
	await ui.think(T["laptop"])
	await _say("lynx", T["deeper"])
	await _say("lynx", T["forums"])
	main.learn("hypnogogue")
	await ui.think(T["forums_note"])
	await _say("lynx", T["south_side"])
	await _say("lynx", T["trust"])
	var pick: int = await ui.choose(T["choices"])
	match pick:
		0:
			await _say("carl", T["find"])
		1:
			await _say("carl", T["careful_say"])
			await _say("lynx", T["careful_reply"])
			main.add_trust("lynx", 1)
		_:
			await _say("carl", T["name"])
			await _say("lynx", T["name_reply"])
			main.add_trust("lynx", 2)
			main.log_line("said", T["name_connection"])
			f["told_lynx_name"] = true
	main.play("ding", -8.0)
	await _say("lynx", T["be_careful"])
	await _say("carl", T["you_too"])
	await ui.think(T["heavier"])
	ui.close()
	lynx.remove_meta("focus")
	_walk_path(lynx, [Vector3(-6.5, 0, 7.5), LAB + Vector3(-0.5, 0, -0.1)], 1.3)
	f.erase("cinematic")


## Where the floor number should have been: a circle within a circle.
func _ride_down() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var T: Dictionary = LINES["ride"]
	if _ended:
		return
	_ended = true
	f["cinematic"] = true
	var p = main.player
	await _doors(door_l, door_r, true, 0.8)
	var tw := create_tween()
	tw.tween_property(p, "position", CAR + Vector3(0, 0.05, -0.4), 1.4).set_trans(Tween.TRANS_SINE)
	await tw.finished
	await p.face(counter_in.global_position, 1.0)
	await _doors(door_l, door_r, false, 0.9)
	main.play("on", -12.0, 0.8)
	await ui.think(T["sank"])
	await ui.think(T["same_thing"])
	await ui.think(T["not_a_cop"])
	ui.close()
	var cnt := create_tween()
	cnt.tween_method(_set_floor, 86.0, 71.0, 3.5)
	await cnt.finished
	# the number is gone. Something else is there.
	counter_in.visible = false
	counter_out.visible = false
	eye_in.visible = true
	eye_out.visible = true
	eye_spin = true
	main.play("sting", -4.0, 0.6)
	main.play("pressure", -4.0, 0.5)
	ui.glitch(0.5, 1.2)
	p.shake(0.3)
	await ui.think(T["blinked"])
	await ui.think(T["symbol"])
	await ui.say("", T["circle"])
	main.add_connection(2.0, T["connection"])
	# the lights flicker once, just once
	var fl := create_tween()
	fl.tween_property(car_light, "light_energy", 0.0, 0.08)
	fl.tween_property(car_light, "light_energy", 0.45, 0.3)
	main.play("off", -6.0, 0.6)
	ui.flash(0.4)
	await ui.think(T["flicker"])
	await ui.think(T["breath"])
	ui.close()
	var wh: Node = main.loop("whisper", -16.0, CAR + Vector3(0, 1.5, 0), 1.0, 4.0)
	wh.play()
	await get_tree().create_timer(1.4).timeout
	# then the word
	eye_spin = false
	eye_in.visible = false
	eye_out.visible = false
	counter_in.visible = true
	counter_in.font_size = 40
	counter_in.modulate = Color(1.0, 0.3, 0.25)
	counter_in.text = T["mimic_word"]
	main.play("pressure", -2.0, 0.4)
	ui.glitch(0.3, 0.6)
	await ui.think(T["mimic"])
	main.learn("mimic")
	await get_tree().create_timer(0.8).timeout
	main.play("ding", -4.0)
	counter_in.modulate = Color(1, 1, 1)
	counter_in.text = T["car_selection"]
	counter_in.font_size = 36
	await ui.say("", T["ding"])
	await ui.think(T["knees"])
	await _say("carl", T["together"])
	await ui.think(T["freudbot"])
	await ui.think(T["knows"])
	ui.close()
	f["warroom1_done"] = true
	f.erase("cinematic")
	main.load_level("Hospital")


# ------------------------------------------------------------------ day 2 (ch.7)

func _turan_day2() -> void:
	var f: Dictionary = main.flags
	var T: Dictionary = LINES["turan_d2"]
	if not f.has("subway_seen"):
		await _subway_scene()
		return
	if turan.visible:
		await _say("turan", T["board"])
	else:
		await main.ui.think(T["gone"])


## Footage from a passenger's ORA glasses on the Cognizo line. Three men
## in black cloaks, the eye, the chant, and a car that arrived empty.
func _subway_scene() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var T: Dictionary = LINES["subway"]
	f["cinematic"] = true
	f["subway_seen"] = true
	var pov := SET_B + Vector3(0.4, 1.45, 5.2)
	var img1: Texture2D = await _picture(pov, SET_B + Vector3(0, 1.0, -1.5), 80.0)
	for l in lifted:
		(l as Sprite3D).visible = true
	for l in set_b_lights:
		(l as OmniLight3D).light_color = Color(1.0, 0.25, 0.2)
	var img2: Texture2D = await _picture(pov + Vector3(-0.3, 0.1, -1.0), SET_B + Vector3(0, 1.1, -1.5), 84.0)
	for l in lifted:
		(l as Sprite3D).visible = false
	for l in set_b_lights:
		(l as OmniLight3D).light_color = Color(0.8, 0.9, 1.0)
	var img3: Texture2D = await _picture(SET_B + Vector3(0.2, 1.15, 0.2), SET_B + Vector3(0, 0.98, -1.5), 46.0)
	var img4: Texture2D = await _picture(SET_B + Vector3(0, 5, 1.3), SET_B + Vector3(0, 5, -0.4), 60.0)
	await main.player.face(SCREEN, 1.0)
	await ui.think(T["played"])
	main.play("on", -8.0, 0.7)
	_show_on_big(img1)
	ui.show_picture(img1, T["caption1"])
	await ui.think(T["halt"])
	await ui.think(T["middle"])
	main.play("chant", -10.0, 0.9)
	await ui.say("", T["chant"])
	main.play("glitch", -6.0)
	ui.glitch(0.7, 1.4)
	_show_on_big(img2)
	ui.show_picture(img2, T["caption2"])
	await ui.think(T["lifted"])
	_show_on_big(img3)
	ui.show_picture(img3, T["caption3"])
	main.play("sting", -6.0, 0.7)
	main.player.shake(0.3)
	await ui.think(T["faces"])
	await ui.think(T["no_eyes"])
	_show_on_big(img4)
	ui.show_picture(img4, T["caption4"])
	main.play("ding", -8.0)
	await ui.think(T["cut"])
	await ui.say("", T["welcome"])
	ui.hide_picture()
	big_mat.albedo_texture = null
	big_mat.albedo_color = Color(0.02, 0.02, 0.025)
	screen_glyph.visible = true
	holo_glyph.visible = true
	await ui.think(T["black"])
	await main.player.face(turan.global_position + Vector3(0, 1.6, 0), 0.8)
	turn_to(turan, main.player.global_position, 0.5)
	await _say("turan", T["missing"])
	await _say("turan", T["media"])
	await _say("turan", T["whole_team"])
	await ui.think(T["holo"])
	await _say("turan", T["debrief"])
	ui.close()
	f.erase("cinematic")
	main.add_connection(1.0, T["connection"])
	main.update_hud()
	_turan_leaves()


## Turan goes up to the board in the other car, round the core.
func _turan_leaves() -> void:
	turan.remove_meta("focus")
	await _walk_path(turan, [Vector3(6.2, 0, -6.2), Vector3(6.2, 0, 5.8), Vector3(1.7, 0, 5.8)], 1.6)
	await _doors(door2_l, door2_r, true, 0.8)
	main.play("ding", -10.0)
	await _walk(turan, Vector3(1.7, 0, 4.0), 1.2)
	await _doors(door2_l, door2_r, false, 0.8)
	turan.visible = false
	set_active(turan.get_child(turan.get_child_count() - 1) as CollisionObject3D, false)


func _forner_day2() -> void:
	var f: Dictionary = main.flags
	if not f.has("subway_seen"):
		await _subway_scene()
		return
	turn_to(forner, main.player.global_position, 0.5)
	await _say("forner", LINES["forner_d2"]["qa"])


## The debrief: the streamlined version, or everything.
func _emmet_day2() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var T: Dictionary = LINES["emmet_d2"]
	if not f.has("subway_seen"):
		await _subway_scene()
		return
	if f.has("emmet_briefed"):
		await _say("emmet", T["split"])
		return
	f["cinematic"] = true
	turn_to(emmet, main.player.global_position, 0.5)
	emmet.set_meta("focus", main.player.global_position + Vector3(0, 1.6, 0))
	await ui.think(T["alone"])
	await ui.think(T["contest"])
	await _say("carl", T["normal"])
	await _say("emmet", T["what"])
	await _say("carl", T["nothing"])
	var pick: int = await ui.choose(T["choices"])
	if pick == 0:
		await ui.think(T["streamlined"])
		await _say("carl", T["lead"])
		f["emmet_streamlined"] = true
	else:
		await _say("carl", T["everything"])
		await _say("emmet", T["everything_reply"])
		main.add_trust("emmet", 2)
		main.log_line("said", T["everything_connection"])
		f["emmet_knows"] = true
	await _say("emmet", T["connected"])
	await _say("carl", T["fast"])
	await _say("emmet", T["point"])
	await _say("carl", T["dive"])
	await _say("emmet", T["and_you"])
	await _say("carl", T["map"])
	await _say("emmet", T["alright"])
	ui.close()
	emmet.remove_meta("focus")
	_emmet_leaves()
	await get_tree().create_timer(1.5).timeout
	await ui.think(T["whistling"])
	await ui.think(T["subway_go"])
	await ui.think(T["not_helpful"])
	ui.close()
	f["emmet_briefed"] = true
	f["emmet_took_subway"] = true
	main.log_line("case", T["split"])
	f.erase("cinematic")
	main.update_hud()
	ui.show_toast(T["toast"], 4.0)


## Emmet takes the other car down to the subway level (the interlude follows).
func _emmet_leaves() -> void:
	await _walk_path(emmet, [Vector3(6.2, 0, -6.2), Vector3(6.2, 0, 5.8), Vector3(1.7, 0, 5.8)], 1.5)
	await _doors(door2_l, door2_r, true, 0.8)
	main.play("ding", -10.0)
	await _walk(emmet, Vector3(1.7, 0, 4.0), 1.2)
	await _doors(door2_l, door2_r, false, 0.8)
	emmet.visible = false
	set_active(emmet.get_child(emmet.get_child_count() - 1) as CollisionObject3D, false)


func _elevator_day2() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var T: Dictionary = LINES["elevator_d2"]
	if not f.has("subway_seen"):
		await ui.think(T["wall"])
		return
	if not f.has("emmet_briefed"):
		await ui.think(T["first"])
		return
	if _ended:
		return
	_ended = true
	f["cinematic"] = true
	await ui.think(T["standup"])
	await ui.think(T["waiting"])
	ui.close()
	await _doors(door_l, door_r, true, 0.8)
	var tw := create_tween()
	tw.tween_property(main.player, "position", CAR + Vector3(0, 0.05, -0.4), 1.2).set_trans(Tween.TRANS_SINE)
	await tw.finished
	await _doors(door_l, door_r, false, 0.8)
	main.play("ding", -8.0)
	await ui.think(T["seven"])
	ui.close()
	f["warroom2_done"] = true
	f.erase("cinematic")
	main.load_level("LynxFlat")


# ------------------------------------------------------------------ motion

## Walk a figure to a point at `speed` m/s (legs from tick).
func _walk(fig: Node3D, to: Vector3, speed := 1.4) -> void:
	fig.set_meta("walk", true)
	turn_to(fig, to, 0.3)
	var d := fig.position.distance_to(to)
	var tw := create_tween()
	tw.tween_property(fig, "position", to, maxf(0.2, d / speed))
	await tw.finished
	fig.remove_meta("walk")
	for l in fig.get_meta("legs", []):
		(l as Node3D).rotation.x = 0.0
	for k in fig.get_meta("knees", []):
		(k as Node3D).rotation.x = 0.0


## Walk through waypoints, round the core and the furniture.
func _walk_path(fig: Node3D, points: Array, speed := 1.4) -> void:
	for p in points:
		await _walk(fig, p, speed)


func tick(delta: float) -> void:
	if not main or not main.player:
		return
	var pp: Vector3 = main.player.global_position
	for p in cast:
		var fig := p as Node3D
		if not fig.visible:
			continue
		if fig.has_meta("walk"):
			Anim.walk(fig, _t, 1.3, float(fig.get_instance_id() % 7))
			continue
		var near := pp.distance_to(fig.global_position) < 9.0
		if not fig.has_meta("seated"):
			Anim.idle(fig, _t, float(fig.get_instance_id() % 11))
		if near:
			Anim.look(fig, pp + Vector3(0, 1.6, 0), 0.85, 0.06)
		elif fig.has_meta("focus"):
			Anim.look(fig, fig.get_meta("focus"), 0.8, 0.04)
		else:
			Anim.look(fig, pp + Vector3(0, 1.6, 0), 0.0, 0.04)
	# the guards: frames on, they turn to keep Carl in the middle of theirs
	for p in guards:
		var g := p as Node3D
		Anim.idle(g, _t, float(g.get_instance_id() % 11))
		var d := pp - g.global_position
		var want: float = g.get_meta("home_yaw")
		if main.frames_on and d.length() < 16.0:
			want = atan2(-d.x, -d.z)
			Anim.look(g, pp + Vector3(0, 1.6, 0), 1.0, 0.08)
		else:
			Anim.look(g, pp + Vector3(0, 1.6, 0), 0.0, 0.04)
		g.rotation.y = lerp_angle(g.rotation.y, want, 0.04)
	if eye_spin:
		eye_in.rotation.z -= delta * 0.9
		eye_out.rotation.z -= delta * 0.9
	if vacuum:
		vacuum.rotation.y += delta * 0.6
	if node_light:
		node_light.visible = fmod(_t * 3.1, 1.0) < 0.55 or fmod(_t * 7.3, 1.0) < 0.2
	if drone:
		drone.position.y = 1.9 + sin(_t * 1.3) * 0.12
		var d := pp - drone.global_position
		drone.rotation.y = lerp_angle(drone.rotation.y, atan2(-d.x, -d.z), 0.02)
		drone_lamp.visible = fmod(_t, 1.2) < 0.6


func on_connection(old: float, new: float) -> void:
	if old < 25.0 and new >= 25.0 and screen_glyph:
		screen_glyph.visible = true


func scan_people() -> Array:
	var S: Dictionary = LINES["scan"]
	var out := []
	for p in cast:
		if not (p as Node3D).visible:
			continue
		var tag: String = S["dreaming"] if main.connection >= 25.0 else S["sync"]
		if p == forner:
			tag = S["forner"]
		out.append([p, S["staff"] + tag])
	for g in guards:
		out.append([g, S["guard"] + (S["guard_frames"] if main.frames_on else S["guard_off"])])
	return out


func phone() -> String:
	var f: Dictionary = main.flags
	var P: Dictionary = LINES["phone"]
	if day2:
		var t: String = P["d2"] + P["d2_lynx"]
		if f.has("subway_seen"):
			t += P["d2_welcome"]
		return t
	var t: String = P["d1"]
	if f.has("footage"):
		t += P["d1_footage"]
	if f.has("told_turan_name"):
		t += P["d1_told"]
	return t


func apply_args(a: Dictionary) -> void:
	var f: Dictionary = main.flags
	if a.has("panels"):
		var tex: Texture2D = await _panel(2 if str(a["panels"]) == "2" else 1)
		main.ui.show_picture(tex, LINES["intro"]["panel1"])
	if a.has("open"):
		door_l.position.x -= 0.8
		door_r.position.x += 0.8
	if a.has("eye"):
		counter_in.visible = false
		counter_out.visible = false
		eye_in.visible = true
		eye_out.visible = true
		eye_spin = true
	if a.has("footage") or f.has("footage"):
		var cam_from := SET_A + Vector3(1.6, 3.4, 1.4)
		Anim.look(dufredy_set, cam_from, 1.0, 1.0)
		var tex: Texture2D = await _picture(cam_from, SET_A + Vector3(0.2, 1.3, -4.2), 70.0)
		_show_on_big(tex)
		if a.has("footage") and str(a["footage"]) == "2":
			main.ui.show_picture(tex, LINES["footage"]["caption"])
	if a.has("subway"):
		var pov := SET_B + Vector3(0.4, 1.45, 5.2)
		var tex: Texture2D = await _picture(pov, SET_B + Vector3(0, 1.0, -1.5), 80.0)
		_show_on_big(tex)
		main.ui.show_picture(tex, LINES["subway"]["caption1"])
		screen_glyph.visible = true
	if f.has("subway_seen"):
		screen_glyph.visible = true
		holo_glyph.visible = true


func selftest() -> void:
	await intro()
	var ids := ["screens", "emmet", "forner"] if day2 else ["turan", "lynx", "forner", "emmet"]
	for id in ids:
		for n in main._all_with_meta(self, "id"):
			if is_instance_valid(n) and str(n.get_meta("id")) == id:
				await main.interact(n)
				print("ok ", id)
				break
	if not day2:
		await _lynx_handoff()
		print("ok handoff")
		main.flags["warroom1_done"] = true
	else:
		main.flags["warroom2_done"] = true
	await main.selftest_all_interactables()
