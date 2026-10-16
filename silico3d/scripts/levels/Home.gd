extends "res://scripts/Level.gd"
## Chapters 3 and 6: the Drake flat, Residence Hall 45C, floor 86 of the
## Psyonic Tower. Two evenings in one level, gated on main.flags.
##
## Book, ch. 3: badge on the door, "a mechanical sigh" (no hinges). Monica in
## the kitchen, arms crossed: "How can a man cut out his eyes like that?" PR
## pushing the drug-abuser narrative, five incidents and it's only March. The
## barely perceptible lens in the corner of the ceiling nobody admits to. Her
## watch chirps: 108, a statement for Marcus before midnight. The kids at the
## plasticky table over soy-loaf and synthetic chicken thighs, bickering. Mira's
## seminar project, "The Tower": "Please convene. I seek answers." Five
## floating figures in a hexagonal chamber. Ezra at the doorway: "Psyon is the
## gate for those who dream." Sleep, and the dream of Dufredy's desk in the
## woods near Carl's parents' house, the eye carved in it, pulsing.
##
## Book, ch. 6: "Dad's home!" Mira silent, shoulders hunched, fleeing to her
## room. Monica on Elonthiel and the rumours. Down the hall, Mira's door ajar:
## a nightlight the shape of a moon, a circle of snapped sticks with two inner
## rings at the foot of her bed, exactly Dufredy's ceiling; a pale stone, her
## tablet, a spiralling eye in red crayon. "I give my gift. I close the door..."
## Eight seconds. Psyon's entrance beep, muted, from beneath her. "We have never
## spoken before. There is nothing to show." The floor rushes up.
##
## Layout (metres): the front door is at the origin on the south wall, the
## Tower corridor beyond it (+Z). Living and dining x -6..6, z -9..0; the
## west wall (x -6) is glass, the balcony outside it, the city 86 floors down.
## The hall runs east from x 6 (z -7.2..-5.8). Mira's room is north of it
## (x 7.5..11.5, z -12..-7.2), Ezra's south (z -5.8..-1.0). Outside the door
## the residence corridor runs x -26..26 along z 0.2..3.8: the lift lobby at
## the east end (Carl arrives there), neighbours' doors 86A-86G, and the
## service stair at the west end, a flight down to a badge-locked landing.

const H := 2.7
const GROUND := -292.0                               # the street, 86 floors down
const TABLE := Vector3(2.5, 0.0, -6.0)
const CIRCLE := Vector3(9.5, 0.0, -9.15)             # the stick circle at the foot of Mira's bed
const MIRA_SPOT := Vector3(9.5, 0.0, -8.0)           # where she sits, back to the door
const MIRA_DOOR := Vector3(9.5, 0.0, -7.13)
const HALL_Y := 0.0

## Every line the level speaks or shows, keyed by beat and line, so the
## script can be edited without touching the scene logic. Runs of lines are
## [[who, text], ...]; who "" is one of Carl's thoughts. Choice labels are
## under "choices".
const LINES := {
	"card": {
		"first": "[b]RESIDENCE HALL 45C[/b]\n\n[color=#aaaaaa]Psyonic Tower, floor 86\n7 PM[/color]",
		"second": "[b]RESIDENCE HALL 45C[/b]\n\n[color=#aaaaaa]Psyonic Tower, floor 86\nthat evening[/color]",
	},
	"objective": {
		"badge": "Badge in at 86D, down the hall.",
		"dinner": "Dinner. Talk to Ezra and Mira.",
		"sleep": "Sleep. The couch, by the glass.",
		"monica2": "Sit with Monica at the table.",
		"mira2": "Check on Mira. Her room is off the hall, on the left.",
		"tablet": "Take the tablet.",
	},
	"prompt": {"leave": "Leave the flat"},
	"lift": {
		"first": [["Lift", "Welcome back, Carl."],
			["", "Eighty-five floors slid by like a screensaver. Not much of a line tonight. A small blessing, a brief reprieve from the enforced camaraderie of elevator small talk."],
			["", "Residence Hall 45C. Home sweet home. Or, at least, the designated unit. I walked down the hallway to 86D, my footsteps muffled by the plush, sound-dampening carpet."]],
		"second": [["Lift", "Welcome back, Carl."],
			["", "The lift knew my name. It always did. I wanted the door, the table, the kids. Tonight, Monica and the kids would be the antidote. They always were."]],
	},
	"arrive1": {
		"door": "Badge on the door. It slid open with a mechanical sigh. I still didn't know what was wrong with hinges. But I chose this. We all did.",
		"voice": "Before I could even shut the door behind me, a voice, sharp and edged with panic, cut through the quiet.",
	},
	"arrive2": {
		"door": "The apartment door slid open, a welcome gasp of familiar air. The sunset painted the dining room in muted orange, after a day of acid yellow and sterile white.",
	},
	"monica1": {
		"gone": "She was already up on 108, building a statement for Marcus out of nothing.",
		"open": "What the hell is going on? That shit is terrifying! How can a man cut out his eyes like that? Tell me what you know.",
		"talk": [["Carl", "Best guess? Bad ketamine. Or some new designer drug. I interview him tomorrow at the SalTech Psych Center. FreudBot's warming the seat."],
			["Monica", "I'm sorry, hon. I take it your day was just as magical as mine? PR's pushing the drug-abuser schizo narrative hard. But with the other incidents..."],
			["Carl", "People aren't buying it."],
			["Monica", "Not at all. There have been five incidents in the news this year, and it's only March. Do you think someone at the company is..."]],
		"lens": "There was a small, barely perceptible lens in the corner of the ceiling. HR swore there was no home surveillance. We all joked about it.",
		"choices": ["The company could never do anything wrong. (glance at the ceiling)", "Maybe. Something's off at Integrations.", "Not here."],
		"ask0": "The company could never do anything wrong.",
		"glance": "I flashed a quick, rehearsed smile and glanced pointedly at the corner of the ceiling. We both knew what I was doing.",
		"of_course": "Of course.",
		"ask1": "Maybe. Something's off at Integrations. Three bootleg builds this month and no logs on any of them.",
		"her_eyes": "Her eyes went to the ceiling corner before mine did. She didn't say anything. She didn't have to.",
		"ask2": "Not here.",
		"watch": [["", "Her watch beeped. A sharp, insistent chirp."],
			["Monica", "Shit, I need to head to 108. TOKZ is having a field day with Mr. Dufredy. We need a public statement for Marcus before midnight. Dinner's at the table, so are the kids. Don't wait up."],
			["Carl", "Damn performance reviews."]],
		"left": [["", "With that, she was out the door, the mechanical sigh of it closing behind her."],
			["", "It was time to see my kids. The thought offered a small, desperate flicker of normalcy."]],
	},
	"dinner1": {
		"serious": [["Mira", "Dad, he doesn't take anything seriously."], ["Ezra", "Do too!"],
			["", "Their bickering had always been a kind of rhythm. Sharp, familiar, almost comforting."]],
		"bicker": [["Mira", "You didn't even finish your prompt training. You don't deserve two."],
			["Ezra", "Convo AI said I was philosophically curious! That's why I got a free-thought pass."],
			["Mira", "That's because you interrupted the lesson with a butt joke, Ezra."],
			["Ezra", "It was a good one."],
			["Carl", "Alright. Mira, let him finish his dinner in peace. Ezra, no more butt jokes during philosophy modules, okay?"]],
		"biology": [["Ezra", "What about biology?"], ["Carl", "Especially biology."]],
		"laugh": "That got a laugh from both of them, and for a moment, things felt normal. Still a reason to keep going.",
	},
	"tower": {
		"again": "You should make a Tower, Dad. It will help with your job.",
		"pitch": [["Mira", "Dad, can I show you the project I've been working on for my Corporate Mental Health seminar? BreathBot said I did it perfectly. Better than the other students."],
			["Carl", "Of course, honey. I always knew you were a genius."],
			["Mira", "It's called 'The Tower'. It's a place I made. A way to split part of your personality into an AI bot to be more focused during the workday."],
			["", "Offloading emotions onto an AI. I thought that's what FreudBot was for."],
			["Mira", "The Tower is a virtual place where part of my personality lives. It has to be able to give Psyon grounding to keep the advice accurate. Watch."]],
		"header": "Mira's tablet  -  Psyonic Education  -  grade 6",
		"convene": "Please convene. I seek answers.",
		"greets": "Welcome back, young Mira. The council greets you. Are you ready for today's guidance?",
		"yes": "Yes",
		"chamber": "A chamber, hexagonal, warm, surreal. Five floating figures, slightly blurred, like they hadn't fully resolved into reality. A robed philosopher. A chrome-skinned child. A librarian with eyes made of stars.",
		"sensed": "We sensed your return. What weighs on your mind today, Mira?",
		"ask_it": "Ask it something, Dad. Anything.",
		"questions": ["Ask it about Dufredy.", "Ask it about stress.", "Ask it what the Tower is for."],
		"typed": ["What happened to Harold Dufredy?", "How do I manage stress during a group project?", "What is the Tower for?"],
		"replies": ["The council does not discuss the father's work. The father carries his name like a badge. Ask again, young Mira.",
			"Breathe in for four. Hold for seven. Out for eight. The philosopher says: the body is the first council.",
			"The librarian smiles. 'A good question. Sit with it until the morning, and the morning will answer.'"],
		"conferred": "The avatars conferred. They spoke with chilling empathy, each with a distinct tone and philosophy.",
		"you_gotta": [["Mira", "You should make one, Dad. It's been so helpful. You gotta."],
			["", "It wasn't my job to judge. But the words she chose felt off. Please convene."]],
		"choices": ["Dad already has a council: your mother.", "Maybe. Show me how later.", "I don't want you using that."],
		"council_mum": [["Carl", "Dad already has a council: your mother."], ["Mira", "Aww, Dad, come on. Try it."]],
		"later": "Maybe. Show me how later.",
		"not_that": [["Carl", "I don't want you using that. Not until I know who built it."], ["Mira", "BreathBot said it was perfect."]],
		"wash_up": "Go wash up. Then straight to bed. We've all had a long day.",
	},
	"gate": {
		"padded": "He slid off the chair and padded toward the hallway. At the doorway, he paused. Turned to me. His sleepy face broke into a wide, impossibly innocent grin.",
		"phrase": "[i]Psyon is the gate for those who dream.[/i]",
		"froze": [["", "I froze. The laughter died in my throat."], ["Carl", "Where'd you hear that?"], ["Ezra", "Mira dared me to say it."]],
		"mira": [["Carl", "Mira, get over here! How did you hear that phrase?"],
			["Mira", "I overheard it on Mom's phone. What does it mean? Mommy won't tell me."]],
		"choices": ["Truth is, baby, we have no idea.", "It's a bad word. Don't say it again.", "Can I see Mom's phone?"],
		"truth": "Truth is, baby, we have no idea. Go to bed.",
		"bad_word": "It's a bad word. Don't say it again. Go to bed.",
		"phone": [["Carl", "Can I see Mom's phone?"], ["Mira", "She took it to 108."]],
		"spreading": "Well, that couldn't be good. It was spreading.",
	},
	"sleep": {
		"not_yet1": "The kids were still at the table. I wasn't sleeping yet.",
		"not_yet2": "Not yet. Mira first.",
		"asleep": "I fell asleep before my head even hit the pillow.",
		"caption": "the woods near my parents' house",
		"dream": [["", "The woods near my parents' house. Pine and damp earth. Among the trees: Mr. Dufredy's desk, pristine, unblemished by rot or dust. The eye symbol carved into its surface, pulsing faintly."],
			["", "A breeze whispered something I almost heard. A fragmented melody. A promise. And then I woke."]],
		"morning": [["", "Nearly 7 AM. Monica was snoring next to me; it must have been a very late night. I needed to head to Integrations HQ and report to Turan."]],
	},
	"dinner2": {
		"home": [["Ezra", "Dad's home!"],
			["Monica", "Come join us at the table, honey. Ezra was just telling us about a fight at recess."],
			["", "Mira was an enigma at the table. Her gaze fixed on her plate, her small shoulders hunched. She had always been the quieter one. But this stillness felt different. Displaced."],
			["Carl", "What's wrong, Mira? You seem quiet."],
			["Mira", "Nothing's wrong."],
			["Carl", "You might feel better if we talk about it."],
			["", "Without another word, she pushed herself away from the table and fled toward her room."]],
		"space": [["Monica", "She's been like that since she got home. Something must've happened at school. Maybe give her some space."],
			["Carl", "I'll check on her in five."]],
		"nothing": "Nothing's wrong.",
		"recess": [["Ezra", "So he grabbed my lion and I went like THIS and I went like THAT and Convo AI said I showed 'conflict leadership'."],
			["", "He reenacted the whole thing, arms windmilling like a flamboyant villain from a forgotten Saturday morning cartoon. A prompt could reconstruct this scene. It could never capture that grin."],
			["Ezra", "Can I go play VR now?"],
			["Carl", "Yes. Thirty minutes."]],
	},
	"monica2": {
		"careful_short": "Please be careful, Carl.",
		"elonthiel": [["Monica", "I heard Elonthiel's getting anxious. There's a lot of talk floating around about Psyonic experimenting on users. People are starting to think these incidents aren't random."],
			["Carl", "He never gave a damn about Human-AI Integration until today. If he's circling, then 400 knows something they haven't told the rest of the company."]],
		"choices": ["Tell her about the map.", "Keep it vague. 'It's just a job.'"],
		"map": [["Carl", "Lynx and I found something today. Near the old Tunelet station in Southtown. We brought the forked Psyon to one of those eye symbols and it generated a map. An actual map. I guess I'm going on a treasure hunt."],
			["Monica", "I don't like where any of this is going. It feels like the city could go dark at any moment, and this time the lights wouldn't come back on."]],
		"vague": [["Carl", "It's just a job. Cleanup. I won't do anything you wouldn't do."],
			["", "A flimsy promise. She knew the shape of a lie better than anyone in the building; she built them for a living."]],
		"careful": [["Monica", "Please be careful, Carl. This sounds too complicated. I don't want you to get caught up in it."],
			["Carl", "I'll go check in with Mira."]],
	},
	"ritual": {
		"sound": "A soft sound drifted down the hall. Mira, talking to someone. Not in conversation. With a distinct, measured rhythm.",
		"verse1": "[i]The art you lost will speak through me,\nThe name you wore, the things you dream...[/i]",
		"through_gap": [["", "Her voice was unnaturally calm. Reverent. Her door was ajar, a sliver of dim light. Her room was bathed in the low amber light of a moon-shaped nightlight, casting long shadows against the far wall."],
			["", "She sat on the floor, cross-legged, her back to me, her gaze fixed on a circle at the foot of her bed. Sticks. Thin, brittle, snapped clean. Two inner rings. Exactly like Dufredy's ceiling."]],
		"inside": "Inside the circle: a pale, smooth stone, her school tablet, and a scrap of paper with a spiralling eye drawn in bright red crayon.",
		"choices": ["Barge in now.", "Wait. Watch."],
		"verse2": "[i]I give my gift. I close the door...\nBut leave a crack to see once more.[/i]",
		"still": "Then she went utterly still. Waiting. I counted.",
		"chime": [["", "Eight agonizing seconds. Then a soft, muffled chime. Psyonic's entrance beep, somehow muted, as if emanating from beneath her."],
			["", "Her face lit up with a serene smile, as if she had just heard a beloved lullaby. She sat back, radiating a calm I had never seen on her."],
			["", "I backed away slowly. The Eye. It was no longer confined to the city's walls. It had found its way into my home. And my daughter had welcomed it inside."]],
		"barge": "I barged through her door before she could finish the verse.",
		"what_is_this": [["Carl", "What are you doing? What is this?"],
			["Mira", "A friend showed me at school. He said if you play the passcode game with your device, it does your homework for you. I'm sorry, Dad. I didn't believe them when they told me it would work."]],
		"lit": "The tablet lay in the circle where she'd left it. Lit, now. Waiting, the way she had been.",
		"sorry": "I'm sorry, Dad. I'll do my homework. I just didn't believe them when they told me it would work.",
	},
	"tablet": {
		"snatched": "I snatched the tablet from the circle and fired a question at Psyon.",
		"history": "> history: 0 conversations. 0 messages.",
		"question": "What is the password game?",
		"never": "We have never spoken before. There is nothing to show.",
		"spin": "My world seemed to spin. The forked version of Psyon. Was it being transferred, transmitted, through a ritual? How could I explain this to anyone?",
		"choices": ["Smash the tablet.", "Pocket it. It's evidence."],
		"smash": [["", "I lifted the tablet high and smashed it against the floor. The sickening crunch echoed the fracture within me."], ["Mira", "[b]DAD![/b]"]],
		"pocket": "I shoved the tablet into my coat. Mira wailed anyway. To her it was the same thing.",
		"monica": "Monica appeared in the doorway, her face a portrait of shock. Stripped bare of my composure, I had no words.",
		"floor": "The floor rushed up to meet me.",
	},
	"morning": {
		"lines": [["", "I woke up in my bed the next day, a dull ache throbbing behind my eyes. It wasn't a dream. And now my wife thought I was losing my mind."],
			["Monica", "Hey, honey, rough night, huh? It's okay. Mira told me everything: you caught her trying to cheat on her schoolwork, then passed out."],
			["Monica", "I know you're under pressure from the boss, but we can't destroy our children's school devices. I need to head in early. Something about an incident on a Cognizo train. We'll talk later."],
			["", "A bit of relief, honestly. I wasn't ready to explain any of this yet. I felt like I was cracking around the edges. But I'd never been more curious in my life."]],
	},
	"toast": {
		"monica1": "Monica: PR's narrative isn't holding. Five incidents this year. Called up to 108 at 7 PM.",
		"tower": "Mira's school project: 'The Tower'. Five avatars, summoned with 'Please convene.'",
		"gate": "Ezra said the Dufredy phrase at bedtime. Mira heard it on Monica's phone.",
		"smashed": "Smashed Mira's tablet. Destroyed the second forked build yourself.",
		"ritual_log": "Mira built a stick circle with two inner rings and chanted a verse. Her tablet answered. Same forked build.",
		"humoured": "humoured the Tower",
		"phrase": "the phrase at home",
		"dream": "dreamed of the desk",
		"planters": "the planters",
		"nightlight": "the nightlight",
		"watched": "watched the ritual complete",
		"kept": "kept the tablet",
		"ritual": "Mira's ritual",
	},
	"examine": {
		"exit1": "It was 7 o'clock. The kids were at the table. I wasn't going anywhere tonight.",
		"exit2": "Mira first.",
		"window": "West-facing. We were lucky enough to get a unit that faced the west. The sunset made working in this tower, living in this cage, a little easier.",
		"window2": "Somewhere down there, past the Spine, was the old Tunelet station. The map was still in my coat.",
		"balcony1": "Child-safe lock, 86 floors up. The wind out there could take a plate off the table.",
		"balcony2": "Opened today at 15:40, the frames said. The kids got home at half past three.",
		"planters1": "The planters. Whatever Monica put in them died in the first storm; what the storms bring in instead are twigs, thin and brittle, off the desert fringe. I kept meaning to clear them.",
		"planters2": "The planters had been stripped. Every twig the dust storms had left in them, snapped off clean at the soil. Neat. Patient.",
		"planters2b": "I knew where they'd gone before I knew that I knew.",
		"kitchen": "Synth-dispenser, synth-oven. Everything in here was synth-something.",
		"table": "Soy-loaf and synthetic chicken thighs. The plasticky aftertaste was the taste of home.",
		"tv": "TOKZ had Dufredy on a loop. A hundred and twelve thousand views in four hours. Monica's day, in a number.",
		"hub": "ORA Home. It knew who was in, who was out, and what the oven was doing. Surveillance: none, per HR policy. It said so right there on the screen.",
		"lens": "A small, barely perceptible lens, embedded in the corner of the ceiling. Psyon HR swore there was no home surveillance. We joked about it. Everyone did. It was the only way to cope.",
		"lens2": "Tonight it blinked more than it used to.",
		"mira_door1": "A paper star on the door. Her name in pink. She'd been eight when she put it up and she wouldn't let me take it down.",
		"mira_door2": "The wood had scraped the floor when I went through it. The one door in this flat with a hinge, and I'd nearly taken it off.",
		"mira_back": "Her back was to me. She hadn't heard the door. She was listening to something else.",
		"mira_bed": "Mira's bed. The toy lion I won for her at Red Rock Plaza, years ago, before everything got so loud.",
		"nightlight": "Her nightlight. A moon. She'd asked for it last year. 'In case something looks at me,' she said. I'd laughed.",
		"sticks1": "A bundle of twigs on her shelf, tied with one of her hair-ties. Kids collect things. I collected bottle caps.",
		"tablet1": "Her school tablet. Psyonic Education, grade 6. BreathBot's gold star on the lock screen, and under it, a chat with something she called the council.",
		"circle": "Sticks. Snapped clean. Two inner rings. The crayon eye was still on the floor, a spiral wound tight. I didn't touch it.",
		"ezra_door": "Ezra's room. VR headset on the pillow, thirty minutes a night, managed and metered.",
		"ezra_bed": "Ezra's room. VR headset on the pillow, thirty minutes a night, managed and metered.",
		"bedroom1": "Our room. Not yet.",
		"bedroom2": "Our room. Mira first.",
		"shower": "The sonic shower. Forty seconds, no water, and you came out smelling of ozone.",
		"lift": "The lift. Eighty-five floors like a screensaver, and a voice that knew my name before I'd badged. Not much of a line tonight.",
		"lobby_screen": "The building's own screen. Customer satisfaction is our greatest priority. Under it, in orange: PR all-hands, 19:30. Monica's night, scheduled before she knew it.",
		"vent": "Exposed vents ran along the ceiling like metallic arteries. Designed to look modern, cutting-edge. It felt like a high-budget waiting room.",
		"stair_door": "The service stair. Badge-locked at every landing below 86. Nobody used it. The lift knew your name; the stairs didn't want to.",
		"stair_bottom": "85, service. My badge opened my flat, my office, and my car. Not this. Whoever came up these stairs came up from somewhere I wasn't cleared for.",
		"neighbour": "Another designated unit. Residence Hall 45C ran A to G on this floor and I'd never seen one of these doors open. Everyone was home. Nobody was in.",
	},
	"scan": {
		"monica": "DRAKE, MONICA\nPsyon 4.1  -  sync 71%\nmood: PERFORMANCE REVIEW",
		"mira1": "DRAKE, MIRA\nPsyon Junior  -  sync 94%",
		"mira2": "DRAKE, MIRA\nPsyon Junior  -  sync 100%  -  DREAMING",
		"ezra": "DRAKE, EZRA\nPsyon Junior  -  sync 62%\nfree-thought pass: ACTIVE",
	},
	"phone": {
		"home1": "[color=#7fe6b0]Psyon:[/color] Welcome home, Carl. 86D is at 21 degrees. Monica is on 108.\n\n",
		"home2": "[color=#7fe6b0]Psyon:[/color] Welcome home, Carl. 86D is at 21 degrees. Monica is home.\n\n",
		"council": "[color=#7fe6b0]Psyon:[/color] Mira's council session has been logged for BreathBot review. Well done, Dad.\n\n",
		"offline": "[color=#7fe6b0]Psyon:[/color] Mira's tablet has been offline since 15:52.\n\n",
		"never": "[color=#e08080]Psyon:[/color] We have never spoken before.\n\n",
	},
}


var second := false        # the second evening (ch. 6)
var _wall: StandardMaterial3D
var _trim: StandardMaterial3D
var _stick_m: StandardMaterial3D
var _glass: StandardMaterial3D
var _sky: ProceduralSkyMaterial
var _sun: DirectionalLight3D
var monica: Node3D
var mira: Node3D               # at the table
var mira_floor: Node3D         # cross-legged on her floor (second evening)
var ezra: Node3D
var ezra_vr: Node3D            # on his bed with the headset on
var movers: Array = []
var front_door: Node3D
var front_body: CollisionObject3D
var mira_door: Node3D
var coat: MeshInstance3D
var tablet: Node3D             # her tablet, in the circle
var tablet_screen: MeshInstance3D
var tablet_light: OmniLight3D
var tablet_body: CollisionObject3D
var shards: Node3D
var night_light: OmniLight3D
var sun_light: OmniLight3D
var tv_feed: Array = []
var lens_dot: MeshInstance3D
var council: Node3D
var woods: Node3D
var circle_body: CollisionObject3D
var planter_body: CollisionObject3D
var _ritual_started := false
var _ended := false


func build(m: Node) -> void:
	main = m
	rng.seed = 86
	second = main.flags.has("southtown_done")
	kit_day = false
	spawn = Vector3(30.0, 0.05, 0.6)
	spawn_yaw = 90.0
	step_db = -21.0
	card = LINES["card"]["second" if second else "first"]
	_wall = pbr("plaster", Vector3(1, 1, 1) / 2.2, true, Color(0.82, 0.8, 0.76))
	_trim = mat(Color(0.32, 0.26, 0.2), 0.55)
	_stick_m = mat(Color(0.42, 0.33, 0.22), 0.9)
	_glass = newmat(Color(0.55, 0.72, 0.85, 0.1), 0.04, 0.3)
	_glass.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_glass.cull_mode = BaseMaterial3D.CULL_DISABLED
	_shell()
	_living()
	_kitchen_and_table()
	_hall()
	_mira_room()
	_ezra_room()
	_balcony()
	_corridor()
	_city_outside()
	_hidden_scenes()
	_family()
	_batch(self, 6.0, true)


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	# sunset through the west glass: "the last golden rays streaming through
	# the west-facing apartment windows"
	_sky = ProceduralSkyMaterial.new()
	_sky.sky_top_color = Color(0.03, 0.03, 0.09)
	_sky.sky_horizon_color = Color(0.55, 0.22, 0.12)
	_sky.ground_horizon_color = Color(0.3, 0.12, 0.09)
	_sky.ground_bottom_color = Color(0.02, 0.015, 0.02)
	_sky.sky_curve = 0.12
	_sky.sun_angle_max = 40.0
	_sky.sun_curve = 0.2
	env.sky.sky_material = _sky
	env.ambient_light_color = Color(0.22, 0.18, 0.26)
	env.ambient_light_energy = 0.3
	env.fog_light_color = Color(0.12, 0.07, 0.09)
	env.fog_density = 0.0012
	env.fog_sky_affect = 0.25
	env.glow_hdr_threshold = 0.95
	sun.light_color = Color(1.0, 0.5, 0.25)
	sun.light_energy = 0.32 if not second else 0.22
	sun.sky_mode = DirectionalLight3D.SKY_MODE_LIGHT_AND_SKY
	sun.rotation = Vector3(deg_to_rad(-9), deg_to_rad(-88), 0)
	# 80 m so the stairwell's far wall still casts a shadow from the lift lobby;
	# on the web (gl_compatibility) light cull masks are ignored and the shadow
	# is all that keeps the sunset off the corridor walls
	sun.directional_shadow_max_distance = 80.0
	sun.light_cull_mask = sun.light_cull_mask & ~2
	_sun = sun


func _exit_tree() -> void:
	# give the sun back the layer the corridor borrowed
	if _sun:
		_sun.light_cull_mask = _sun.light_cull_mask | 2


func hifi(env: Environment, _sun2: DirectionalLight3D) -> void:
	for l in lamps:
		(l[0] as OmniLight3D).shadow_enabled = true
	if night_light:
		night_light.shadow_enabled = true
		night_light.shadow_blur = 1.8
		night_light.light_volumetric_fog_energy = 2.5
	env.volumetric_fog_density = 0.012
	env.volumetric_fog_albedo = Color(0.6, 0.45, 0.4)


func ambience() -> void:
	main.loop("room", -11.0)
	main.loop("hum", -21.0, Vector3(-2.0, 2.6, -9.0), 2.0, 12.0)
	main.loop("wind", -20.0, Vector3(-7.5, 1.5, -4.5), 3.0, 18.0)
	if second:
		main.loop("hum", -26.0, CIRCLE + Vector3(0, 0.1, 0), 0.8, 5.0)


# ------------------------------------------------------------------ the shell

func _wb(size: Vector3, pos: Vector3) -> void:
	box(size, pos, _wall, true)


func _shell() -> void:
	var t := 0.14
	# south wall with the sliding front door at the origin
	_wb(Vector3(5.4, H, t), Vector3(-3.3, H / 2, -0.07))
	_wb(Vector3(5.4, H, t), Vector3(3.3, H / 2, -0.07))
	_wb(Vector3(1.2, H - 2.15, t), Vector3(0, 2.15 + (H - 2.15) / 2, -0.07))
	# north wall (kitchen) and the east wall with the hall opening
	_wb(Vector3(12.3, H, t), Vector3(0, H / 2, -9.07))
	_wb(Vector3(t, H, 1.9), Vector3(6.0, H / 2, -8.1))
	_wb(Vector3(t, H, 5.8), Vector3(6.0, H / 2, -2.9))
	_wb(Vector3(t, H - 2.2, 1.4), Vector3(6.0, 2.2 + (H - 2.2) / 2, -6.5))
	# the west wall is glass from the sill up, a sliding section to the balcony
	_wb(Vector3(t, 0.12, 9.2), Vector3(-6.0, 0.06, -4.5))
	_wb(Vector3(t, 0.3, 9.2), Vector3(-6.0, H - 0.15, -4.5))
	var gl := box(Vector3(0.04, H - 0.42, 8.9), Vector3(-6.0, 0.12 + (H - 0.42) / 2, -4.5), _glass, true)
	gl.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	var frame := mat(Color(0.2, 0.2, 0.22), 0.4, 0.7)
	for z: float in [-8.9, -7.0, -5.0, -3.0, -1.0, -0.1]:
		box(Vector3(0.09, H, 0.07), Vector3(-6.0, H / 2, z), frame)
	box(Vector3(0.09, 0.07, 9.2), Vector3(-6.0, 2.2, -4.5), frame)
	interactable("window", "Look out over the city", Vector3(-5.9, 1.4, -5.5), Vector3(0.2, 2.2, 3.5),
		"WEST GLASS\nfloor: 86   wind: 41 KM/H\ntint: SUNSET (AUTO)")
	interactable("balcony_door", "Look at the balcony door", Vector3(-5.9, 1.2, -2.0), Vector3(0.2, 2.3, 1.8),
		"BALCONY DOOR\nlock: CHILD-SAFE\nlast opened: %s" % ("TODAY, 15:40" if second else "9 DAYS AGO"))
	# floors: pale boards in the living room, tile in the kitchen, carpet elsewhere
	var boards := pbr("woodfloor", Vector3(1, 1, 1) / 2.0, true, Color(0.95, 0.88, 0.78))
	floor_quad(Vector2(12, 9), Vector3(0, 0.0, -4.5), 0.0, boards)
	var tile := mat(Color(0.62, 0.63, 0.62), 0.25, 0.1)
	floor_quad(Vector2(7.5, 1.6), Vector3(-2.25, 0.004, -8.2), 0.0, tile)
	solid_box(Vector3(30, 1, 22), Vector3(3, -0.5, -5))
	var ceil_m := mat(Color(0.68, 0.67, 0.64), 0.95)
	box(Vector3(12.3, 0.2, 9.3), Vector3(0, H + 0.1, -4.55), ceil_m)
	# cove strips along the ceiling, Psyon green: "faux-wood panelling
	# streaked with the ubiquitous Psyon green"
	var cove := glow(Color(0.25, 0.95, 0.6), 0.9, true)
	box(Vector3(11.8, 0.03, 0.03), Vector3(0, H - 0.04, -8.95), cove)
	box(Vector3(11.8, 0.03, 0.03), Vector3(0, H - 0.04, -0.18), cove)
	var panel := pbr("woodfloor", Vector3(1, 1, 1) / 1.2, true, Color(0.55, 0.42, 0.3))
	box(Vector3(5.0, H - 0.3, 0.05), Vector3(-3.3, H / 2 - 0.1, -0.11), panel)
	box(Vector3(5.0, 0.02, 0.06), Vector3(-3.3, 1.9, -0.12), cove)
	# door frame and the sliding door, a heavy panel that glides sideways
	box(Vector3(0.1, 2.15, 0.2), Vector3(-0.6, 1.07, -0.07), _trim)
	box(Vector3(0.1, 2.15, 0.2), Vector3(0.6, 1.07, -0.07), _trim)
	box(Vector3(1.3, 0.1, 0.2), Vector3(0, 2.15, -0.07), _trim)
	front_door = Node3D.new()
	add_child(front_door)
	var dm := mat(Color(0.28, 0.3, 0.32), 0.4, 0.5)
	box(Vector3(1.1, 2.1, 0.06), Vector3(0, 1.05, -0.07), dm, false, front_door)
	box(Vector3(0.03, 0.5, 0.07), Vector3(0.42, 1.05, -0.07), glow(Color(0.3, 0.9, 1.0), 1.2), false, front_door)
	front_body = interactable("front_door", "Badge in at 86D", Vector3(0, 1.05, -0.07), Vector3(1.1, 2.1, 0.12),
		"86D\nresidents: DRAKE x4\nlock: BADGE (C. DRAKE, M. DRAKE)", true, front_door)
	front_body.set_meta("exit", true)
	for c in front_door.get_children():
		no_batch.append(c)
	# the lens in the corner of the ceiling that HR swears is not there
	var dome := sphere(0.035, Vector3(5.85, H - 0.03, -0.25), mat(Color(0.03, 0.03, 0.035), 0.15, 0.4), 10)
	dome.scale.y = 0.6
	lens_dot = box(Vector3(0.006, 0.006, 0.006), Vector3(5.85, H - 0.055, -0.26), glow(Color(1, 0.05, 0.05), 2.5))
	no_batch.append(lens_dot)
	interactable("lens", "Look at the corner of the ceiling", Vector3(5.8, H - 0.1, -0.25), Vector3(0.35, 0.2, 0.35),
		"UNREGISTERED DEVICE\ntype: OPTICAL (0.4 MM)\nowner: NONE ON RECORD", false).set_meta("hackable", true)


# ------------------------------------------------------------------ living room

func _living() -> void:
	# the couch faces the glass; the throw and the cushions; a long low table
	var fabric := pbr("fabric", Vector3(1, 1, 1) / 1.0, true, Color(0.5, 0.52, 0.6))
	var cushion := pbr("fabric", Vector3(1, 1, 1) / 0.6, true, Color(0.75, 0.6, 0.45))
	var cp := Vector3(-2.4, 0, -2.8)
	box(Vector3(0.95, 0.42, 2.4), cp + Vector3(0, 0.21, 0), fabric, true)
	box(Vector3(0.22, 0.95, 2.4), cp + Vector3(0.45, 0.47, 0), fabric, true)
	for z: float in [-1.3, 1.3]:
		box(Vector3(0.95, 0.62, 0.2), cp + Vector3(0, 0.31, z), fabric, true)
	for z: float in [-0.6, 0.6]:
		box(Vector3(0.8, 0.12, 1.1), cp + Vector3(-0.05, 0.47, z), fabric)
	box(Vector3(0.4, 0.4, 0.12), cp + Vector3(0.28, 0.7, -0.75), cushion).rotation.y = 0.2
	box(Vector3(0.4, 0.4, 0.12), cp + Vector3(0.28, 0.7, 0.7), cushion).rotation.y = -0.15
	box(Vector3(1.1, 0.03, 0.9), cp + Vector3(-0.1, 0.55, 0.3), pbr("fabric", Vector3(1, 1, 1) / 0.8, true, Color(0.35, 0.3, 0.3)))
	interactable("couch", "Lie down on the couch", cp + Vector3(0, 0.5, 0), Vector3(1.1, 0.5, 2.4), "", false)
	var wood := pbr("woodfloor", Vector3(1, 1, 1) / 1.0, true, Color(0.5, 0.4, 0.3))
	box(Vector3(0.6, 0.04, 1.6), Vector3(-4.2, 0.4, -2.8), wood, true)
	for z: float in [-0.7, 0.7]:
		box(Vector3(0.5, 0.38, 0.05), Vector3(-4.2, 0.19, -2.8 + z), mat(Color(0.15, 0.15, 0.16), 0.5))
	# the rug, a floor lamp, a tall plant, a side table with Monica's work
	floor_quad(Vector2(3.6, 4.2), Vector3(-3.4, 0.008, -2.8), 0.0, pbr("carpet", Vector3(1, 1, 1) / 1.4, true, Color(0.6, 0.55, 0.6)))
	var lamp_m := mat(Color(0.75, 0.72, 0.68), 0.5, 0.6)
	cyl(0.14, 0.14, 0.02, Vector3(-1.4, 0.01, -5.3), lamp_m, 12)
	cyl(0.015, 0.015, 1.6, Vector3(-1.4, 0.8, -5.3), lamp_m, 6)
	cyl(0.22, 0.17, 0.3, Vector3(-1.4, 1.7, -5.3), glow(Color(1.0, 0.82, 0.6), 1.1, true), 12)
	light(Vector3(-1.4, 1.6, -5.3), Color(1.0, 0.78, 0.55), 0.8, 5.5)
	var pot := mat(Color(0.3, 0.3, 0.32), 0.7)
	cyl(0.22, 0.18, 0.45, Vector3(-5.3, 0.22, -8.3), pot, 10)
	for i in 7:
		var a := i * TAU / 7.0
		var leaf := box(Vector3(0.08, 0.7, 0.02), Vector3(-5.3 + cos(a) * 0.15, 0.85, -8.3 + sin(a) * 0.15), mat(Color(0.12, 0.35, 0.18), 0.7))
		leaf.rotation = Vector3(0.5 * sin(a), a, 0.5 * cos(a))
	# the wall screen on the south wall: TOKZ, Dufredy on a loop
	var sp := Vector3(-3.3, 1.55, -0.16)
	box(Vector3(1.9, 1.08, 0.05), sp, mat(Color(0.02, 0.02, 0.02), 0.2, 0.3))
	var feed := quad(Vector2(1.8, 0.98), sp + Vector3(0, 0, 0.03), 0.0, glow(Color(0.12, 0.06, 0.1), 1.0))
	var t1 := neon_text("TOKZ  LIVE", sp + Vector3(-0.55, 0.3, 0.04), 0.0, 0.1, Color(1.0, 0.2, 0.5), 2.0, self)
	var t2 := neon_text("\"AM I DREAMING?\"", sp + Vector3(0, 0.0, 0.04), 0.0, 0.14, Color(0.95, 0.95, 0.9), 1.6, self)
	var t3 := neon_text("HARMONY GREEN  -  112K VIEWS  -  SILICO PD: NO COMMENT", sp + Vector3(0, -0.34, 0.04), 0.0, 0.05, Color(0.8, 0.8, 0.85), 1.4, self)
	tv_feed = [feed, t1, t2, t3]
	for n in tv_feed:
		no_batch.append(n)
		flickers.append(n)
	interactable("tv", "Look at the wall screen", sp, Vector3(1.9, 1.1, 0.2),
		"WALL SCREEN\nfeed: TOKZ (TRENDING)\ntopic: DUFREDY, H.  -  112,406 views", false).set_meta("hackable", true)
	# the ORA hub by the door, and a minimalist chair for a coat
	var hub := Vector3(1.3, 1.45, -0.13)
	box(Vector3(0.3, 0.3, 0.03), hub, mat(Color(0.9, 0.9, 0.88), 0.3, 0.2))
	var ring := TorusMesh.new()
	ring.inner_radius = 0.08
	ring.outer_radius = 0.1
	ring.rings = 24
	ring.ring_segments = 6
	mesh(ring, hub + Vector3(0, 0, 0.02), glow(Color(0.25, 0.95, 0.6), 1.6, true)).rotation.x = PI / 2.0
	neon_text("ORA HOME  86D", hub + Vector3(0, -0.21, 0.02), 0.0, 0.03, Color(0.3, 0.9, 0.6), 1.5, self)
	interactable("hub", "Look at the home hub", hub, Vector3(0.35, 0.4, 0.1),
		"ORA HOME HUB\nresidents: 4   present: %s\nsurveillance: NONE (PER HR POLICY)" % ("4" if second else "3"), false)
	var ch := mat(Color(0.85, 0.85, 0.82), 0.45, 0.2)
	box(Vector3(0.45, 0.04, 0.45), Vector3(2.6, 0.45, -0.6), ch, true)
	box(Vector3(0.45, 0.5, 0.04), Vector3(2.6, 0.72, -0.4), ch)
	for x: float in [-0.19, 0.19]:
		cyl(0.015, 0.015, 0.44, Vector3(2.6 + x, 0.22, -0.6 + x * 0.9), ch, 6)
	coat = box(Vector3(0.5, 0.5, 0.2), Vector3(2.6, 0.78, -0.5), mat(Color(0.12, 0.14, 0.15), 0.7))
	coat.rotation.x = -0.25
	coat.visible = false
	no_batch.append(coat)
	# a robot vacuum, docked and charging, that works
	cyl(0.17, 0.17, 0.08, Vector3(5.6, 0.05, -4.2), mat(Color(0.9, 0.9, 0.88), 0.4, 0.3), 16)
	box(Vector3(0.05, 0.01, 0.05), Vector3(5.6, 0.095, -4.05), glow(Color(0.2, 0.9, 0.4), 1.5, true))


# ------------------------------------------------------------------ kitchen and the table

func _kitchen_and_table() -> void:
	# the run along the north wall: units, a worktop, overhead cabinets, the
	# synth-oven and the synth-dispenser. "Everything in here was synth-something."
	var unit := mat(Color(0.88, 0.87, 0.84), 0.45, 0.1)
	var top := mat(Color(0.18, 0.18, 0.19), 0.3, 0.2)
	box(Vector3(7.2, 0.88, 0.62), Vector3(-2.4, 0.44, -8.72), unit, true)
	box(Vector3(7.3, 0.04, 0.68), Vector3(-2.4, 0.9, -8.72), top)
	box(Vector3(7.2, 0.8, 0.38), Vector3(-2.4, 2.2, -8.84), unit, true)
	for x: float in [-5.2, -4.0, -2.8, -1.6, -0.4, 0.8]:
		box(Vector3(0.02, 0.76, 0.02), Vector3(x, 2.2, -8.64), top)
	box(Vector3(7.2, 0.02, 0.4), Vector3(-2.4, 1.78, -8.84), glow(Color(1.0, 0.9, 0.75), 0.5, true))
	light(Vector3(-2.4, 1.7, -8.3), Color(1.0, 0.88, 0.7), 0.7, 4.5)
	# synth-oven: dark glass, a readout
	box(Vector3(0.7, 0.5, 0.04), Vector3(-1.6, 0.5, -8.4), mat(Color(0.05, 0.05, 0.06), 0.15, 0.4))
	neon_text("SYNTH-OVEN   READY", Vector3(-1.6, 0.68, -8.37), 0.0, 0.025, Color(1.0, 0.55, 0.2), 1.6, self)
	# synth-dispenser: a steel column with a nozzle and a blue readout
	var steel := mat(Color(0.7, 0.72, 0.74), 0.3, 0.8)
	cyl(0.11, 0.13, 0.5, Vector3(-4.2, 1.17, -8.75), steel, 12)
	box(Vector3(0.05, 0.05, 0.14), Vector3(-4.2, 1.25, -8.55), steel)
	neon_text("H2O  SYNTH  PROTEIN", Vector3(-4.2, 1.1, -8.61), 0.0, 0.022, Color(0.3, 0.8, 1.0), 1.5, self)
	interactable("kitchen", "Look at the kitchen", Vector3(-2.4, 1.0, -8.4), Vector3(5.0, 1.4, 0.8), "", false)
	# a fridge, a sink
	box(Vector3(0.75, 1.95, 0.65), Vector3(1.4, 0.97, -8.7), mat(Color(0.8, 0.8, 0.78), 0.3, 0.4), true)
	box(Vector3(0.5, 0.02, 0.4), Vector3(-3.0, 0.9, -8.72), steel)
	# the dining table, four chairs, dinner on it
	var tt := pbr("woodfloor", Vector3(1, 1, 1) / 1.0, true, Color(0.95, 0.92, 0.85))
	box(Vector3(1.7, 0.05, 0.95), TABLE + Vector3(0, 0.74, 0), tt, true)
	for x: float in [-0.75, 0.75]:
		for z: float in [-0.38, 0.38]:
			box(Vector3(0.05, 0.72, 0.05), TABLE + Vector3(x, 0.36, z), mat(Color(0.25, 0.25, 0.26), 0.5, 0.4))
	solid_box(Vector3(1.7, 0.74, 0.95), TABLE + Vector3(0, 0.37, 0))
	var ch := mat(Color(0.85, 0.85, 0.82), 0.45, 0.2)
	for c: Array in [[-0.45, -0.75, 0.0], [0.45, -0.75, 0.0], [-0.45, 0.75, PI], [0.45, 0.75, PI]]:
		var cp := TABLE + Vector3(c[0], 0, c[1])
		var seat := box(Vector3(0.44, 0.04, 0.44), cp + Vector3(0, 0.46, 0), ch, true)
		seat.rotation.y = c[2]
		var back := box(Vector3(0.44, 0.5, 0.04), cp + Vector3(0, 0.73, -0.2 if c[1] < 0 else 0.2), ch)
		back.rotation.y = c[2]
		for x: float in [-0.19, 0.19]:
			for z: float in [-0.19, 0.19]:
				cyl(0.014, 0.014, 0.45, cp + Vector3(x, 0.22, z), ch, 6)
	var plate := mat(Color(0.95, 0.95, 0.93), 0.3)
	var loaf := mat(Color(0.5, 0.35, 0.22), 0.8)
	var thigh := mat(Color(0.75, 0.55, 0.35), 0.6)
	for c: Array in [[-0.45, -0.25], [0.45, -0.25], [-0.45, 0.25], [0.45, 0.25]]:
		var pp := TABLE + Vector3(c[0], 0.78, c[1])
		cyl(0.13, 0.11, 0.015, pp, plate, 14)
		box(Vector3(0.08, 0.03, 0.06), pp + Vector3(-0.04, 0.025, 0.0), loaf).rotation.y = rng.randf()
		sphere(0.03, pp + Vector3(0.05, 0.03, 0.03), thigh, 8).scale = Vector3(1.4, 0.8, 1.0)
		cyl(0.03, 0.025, 0.1, pp + Vector3(0.18, 0.05, -0.12), _glass, 8)
	box(Vector3(0.3, 0.05, 0.2), TABLE + Vector3(0, 0.79, 0), mat(Color(0.75, 0.55, 0.35), 0.6))
	interactable("table", "Look at the table", TABLE + Vector3(0, 0.85, 0), Vector3(1.7, 0.25, 0.95), "", false)


# ------------------------------------------------------------------ the hall and the bedrooms

func _hall() -> void:
	var carpet := pbr("carpet", Vector3(1, 1, 1) / 1.3, true, Color(0.5, 0.48, 0.5))
	floor_quad(Vector2(7.0, 1.4), Vector3(9.5, 0.0, -6.5), 0.0, carpet)
	# hall walls: north (Mira's door at x 9.5), south (Ezra's door at x 9.5,
	# the shower at x 12), the end wall with our bedroom door
	_wb(Vector3(2.9, H, 0.14), Vector3(7.55, H / 2, -7.2))
	_wb(Vector3(2.0, H, 0.14), Vector3(12.0, H / 2, -7.2))
	_wb(Vector3(1.0, H - 2.05, 0.14), Vector3(9.5, 2.05 + (H - 2.05) / 2, -7.2))
	_wb(Vector3(2.9, H, 0.14), Vector3(7.55, H / 2, -5.8))
	_wb(Vector3(1.4, H, 0.14), Vector3(10.7, H / 2, -5.8))
	_wb(Vector3(1.0, H - 2.05, 0.14), Vector3(9.5, 2.05 + (H - 2.05) / 2, -5.8))
	_wb(Vector3(1.2, H - 2.05, 0.14), Vector3(12.0, 2.05 + (H - 2.05) / 2, -5.8))
	_wb(Vector3(0.6, H, 0.14), Vector3(12.7, H / 2, -5.8))
	_wb(Vector3(0.14, H, 1.6), Vector3(13.0, H / 2, -6.5))
	box(Vector3(7.2, 0.2, 1.6), Vector3(9.6, H + 0.1, -6.5), mat(Color(0.68, 0.67, 0.64), 0.95))
	light(Vector3(8.5, H - 0.2, -6.5), Color(1.0, 0.85, 0.7), 0.55, 4.5)
	light(Vector3(12.0, H - 0.2, -6.5), Color(1.0, 0.85, 0.7), 0.4, 3.5)
	# the doors we do not go through: ours, and the sonic shower
	var dm := mat(Color(0.86, 0.85, 0.82), 0.5)
	box(Vector3(0.06, 2.05, 1.0), Vector3(12.95, 1.02, -6.5), dm)
	interactable("bedroom_door", "Our bedroom", Vector3(12.9, 1.0, -6.5), Vector3(0.15, 2.0, 1.0), "", true)
	box(Vector3(1.0, 2.05, 0.06), Vector3(12.0, 1.02, -5.78), dm)
	neon_text("SONIC", Vector3(12.0, 1.6, -5.74), 0.0, 0.05, Color(0.3, 0.9, 1.0), 1.2, self)
	interactable("shower", "The sonic shower", Vector3(12.0, 1.0, -5.75), Vector3(1.0, 2.0, 0.15), "", true)
	# door frames
	for p: Vector3 in [Vector3(9.5, 0, -7.2), Vector3(9.5, 0, -5.8)]:
		box(Vector3(0.1, 2.05, 0.2), p + Vector3(-0.55, 1.02, 0), _trim)
		box(Vector3(0.1, 2.05, 0.2), p + Vector3(0.55, 1.02, 0), _trim)
		box(Vector3(1.2, 0.1, 0.2), p + Vector3(0, 2.05, 0), _trim)
	box(Vector3(0.1, 2.2, 0.2), Vector3(6.0, 1.1, -7.25), _trim)
	box(Vector3(0.1, 2.2, 0.2), Vector3(6.0, 1.1, -5.75), _trim)


func _mira_room() -> void:
	var carpet := pbr("carpet", Vector3(1, 1, 1) / 1.3, true, Color(0.72, 0.6, 0.68))
	floor_quad(Vector2(4.0, 4.8), Vector3(9.5, 0.0, -9.6), 0.0, carpet)
	_wb(Vector3(0.14, H, 4.8), Vector3(7.5, H / 2, -9.6))
	_wb(Vector3(0.14, H, 4.8), Vector3(11.5, H / 2, -9.6))
	_wb(Vector3(4.1, H, 0.14), Vector3(9.5, H / 2, -12.0))
	box(Vector3(4.1, 0.2, 4.9), Vector3(9.5, H + 0.1, -9.6), mat(Color(0.68, 0.67, 0.64), 0.95))
	# her door, hinged on the west jamb (the one door in the flat that scrapes)
	mira_door = Node3D.new()
	mira_door.position = MIRA_DOOR + Vector3(-0.5, 0, 0)
	add_child(mira_door)
	var dm := mat(Color(0.86, 0.85, 0.82), 0.5)
	box(Vector3(1.0, 2.05, 0.05), Vector3(0.5, 1.02, 0), dm, false, mira_door)
	box(Vector3(0.1, 0.03, 0.05), Vector3(0.85, 1.0, 0.04), mat(Color(0.7, 0.7, 0.7), 0.3, 0.9), false, mira_door)
	var star := box(Vector3(0.2, 0.2, 0.01), Vector3(0.5, 1.5, 0.03), glow(Color(1.0, 0.8, 0.3), 0.6), false, mira_door)
	star.rotation.z = 0.78
	neon_text("MIRA", Vector3(0.5, 1.27, 0.03), 0.0, 0.07, Color(1.0, 0.6, 0.8), 1.2, mira_door)
	interactable("mira_door", "Mira's door", Vector3(0.5, 1.02, 0), Vector3(1.0, 2.05, 0.1), "", true, mira_door)
	for c in mira_door.get_children():
		no_batch.append(c)
	mira_door.rotation.y = -1.85 if not second else -0.85   # open before bed; ajar, "a sliver of dim light", "a sliver of dim light"
	# the bed against the north wall, the lion on the pillow
	var bp := Vector3(9.5, 0, -11.05)
	var frame := mat(Color(0.9, 0.88, 0.85), 0.6)
	box(Vector3(1.05, 0.25, 1.9), bp + Vector3(0, 0.2, 0), frame, true)
	box(Vector3(1.0, 0.18, 1.85), bp + Vector3(0, 0.41, 0), mat(Color(0.95, 0.95, 0.93), 0.9))
	box(Vector3(1.0, 0.12, 1.4), bp + Vector3(0, 0.54, 0.2), pbr("fabric", Vector3(1, 1, 1) / 0.7, true, Color(0.85, 0.5, 0.7)))
	box(Vector3(0.6, 0.12, 0.4), bp + Vector3(0, 0.56, -0.65), mat(Color(0.97, 0.97, 0.95), 0.9))
	box(Vector3(1.05, 0.7, 0.06), bp + Vector3(0, 0.65, -0.95), frame)
	# the toy lion from Red Rock Plaza
	var lion := mat(Color(0.85, 0.62, 0.25), 0.9)
	var mane := mat(Color(0.5, 0.3, 0.12), 0.9)
	var lp := bp + Vector3(0.3, 0.68, -0.6)
	sphere(0.09, lp, lion, 10).scale = Vector3(1.0, 0.8, 1.3)
	sphere(0.07, lp + Vector3(0, 0.08, -0.1), lion, 10)
	sphere(0.095, lp + Vector3(0, 0.08, -0.08), mane, 10).scale = Vector3(1.0, 1.0, 0.5)
	for x: float in [-0.03, 0.03]:
		box(Vector3(0.012, 0.012, 0.005), lp + Vector3(x, 0.1, -0.17), mat(Color(0.02, 0.02, 0.02), 0.2))
	interactable("mira_bed", "Mira's bed", bp + Vector3(0, 0.6, 0), Vector3(1.1, 0.5, 1.9), "", false)
	# the moon nightlight on the east wall, amber. "In case something looks at me."
	var np := Vector3(11.42, 0.9, -10.2)
	sphere(0.09, np, glow(Color(1.0, 0.62, 0.25), 1.6, true), 12)
	sphere(0.085, np + Vector3(-0.015, 0.04, 0.06), mat(Color(0.86, 0.85, 0.82), 0.6), 12)
	night_light = light(np + Vector3(-0.3, -0.1, 0), Color(1.0, 0.6, 0.3), 1.3 if second else 0.7, 6.5, false)
	interactable("nightlight", "Look at the nightlight", np, Vector3(0.3, 0.3, 0.3), "", false)
	# her desk on the west wall, the shelf with what a child keeps
	var desk := mat(Color(0.92, 0.9, 0.86), 0.5)
	box(Vector3(0.5, 0.03, 1.1), Vector3(7.8, 0.72, -8.6), desk, true)
	for z: float in [-0.5, 0.5]:
		box(Vector3(0.45, 0.7, 0.03), Vector3(7.8, 0.36, -8.6 + z), desk)
	box(Vector3(0.4, 0.04, 0.4), Vector3(8.4, 0.44, -8.6), desk, true)
	box(Vector3(0.3, 0.03, 1.4), Vector3(7.72, 1.6, -10.3), desk)
	for i in 5:
		box(Vector3(0.05, 0.22, 0.03), Vector3(7.72, 1.73, -10.9 + i * 0.1), mat(Color(0.3 + i * 0.1, 0.4, 0.8 - i * 0.1), 0.8))
	sphere(0.07, Vector3(7.72, 1.69, -9.8), mat(Color(0.9, 0.3, 0.5), 0.7), 8)
	if not second:
		# a bundle of twigs on her shelf, tied with a hair-tie; her tablet on the desk
		for i in 6:
			var a := Vector3(7.72, 1.64, -9.6 + rng.randf_range(-0.02, 0.02))
			stick(a + Vector3(rng.randf_range(-0.1, -0.06), i * 0.006, 0), a + Vector3(rng.randf_range(0.06, 0.1), i * 0.006, 0), 0.006, _stick_m)
		box(Vector3(0.05, 0.02, 0.02), Vector3(7.72, 1.655, -9.6), mat(Color(0.9, 0.3, 0.5), 0.7))
		interactable("sticks1", "Look at the shelf", Vector3(7.75, 1.65, -9.8), Vector3(0.3, 0.3, 1.2), "", false)
		var tb := Vector3(7.8, 0.745, -8.5)
		box(Vector3(0.17, 0.012, 0.24), tb, mat(Color(0.9, 0.9, 0.92), 0.3, 0.4))
		quad(Vector2(0.15, 0.22), tb + Vector3(0, 0.007, 0), 0.0, glow(Color(0.1, 0.3, 0.25), 0.5)).rotation.x = -PI / 2.0
		interactable("tablet1", "Look at her tablet", tb, Vector3(0.3, 0.1, 0.35),
			"MIRA'S TABLET\nPsyonic Education - grade 6\nlast app: PSYON (THE TOWER)", false).set_meta("hackable", true)
	else:
		_circle()
	# a dim ceiling light, off in the second evening ("the low amber light")
	light(Vector3(9.5, H - 0.2, -9.6), Color(1.0, 0.9, 0.8), 0.0 if second else 0.6, 4.5)


## The circle at the foot of her bed: snapped sticks in a crude ring with
## two inner rings, exactly Dufredy's ceiling. In it a pale stone, her
## school tablet, and a scrap of paper with a spiralling eye in red crayon.
func _circle() -> void:
	var tape := mat(Color(0.95, 0.55, 0.7), 0.8)
	var dark_stick := mat(Color(0.3, 0.22, 0.13), 0.9)
	for ring: Array in [[0.74, 30], [0.47, 20], [0.24, 12]]:
		var r: float = ring[0]
		var n: int = ring[1]
		var prev := Vector3.ZERO
		for i in n + 1:
			var a := i * TAU / n
			var rr := r + rng.randf_range(-0.04, 0.04)
			var p := CIRCLE + Vector3(cos(a) * rr, 0.012, sin(a) * rr)
			if i > 0:
				var mid := prev.lerp(p, 0.5)
				var gap := rng.randf_range(0.0, 0.3)
				stick(prev + (prev - mid) * gap, p + (p - mid) * gap, rng.randf_range(0.011, 0.018), dark_stick)
				if i % 5 == 0 and r > 0.4:
					box(Vector3(0.03, 0.003, 0.05), mid + Vector3(0, 0.005, 0), tape).rotation.y = rng.randf() * TAU
			prev = p
	# the stone
	sphere(0.05, CIRCLE + Vector3(-0.1, 0.03, 0.1), mat(Color(0.82, 0.8, 0.76), 0.4), 10).scale = Vector3(1.2, 0.6, 0.9)
	# the crayon eye on a flattened scrap of paper
	var paper := decal_mat(_crayon_eye(), Color(1, 1, 1), 0.9)
	floor_quad(Vector2(0.17, 0.13), CIRCLE + Vector3(0.1, 0.014, 0.12), -0.3, paper)
	# the tablet, dark until it answers
	tablet = Node3D.new()
	tablet.position = CIRCLE + Vector3(0.0, 0.018, -0.12)
	tablet.rotation.y = 0.1
	add_child(tablet)
	box(Vector3(0.18, 0.012, 0.25), Vector3.ZERO, mat(Color(0.9, 0.9, 0.92), 0.3, 0.4), false, tablet)
	tablet_screen = quad(Vector2(0.16, 0.23), Vector3(0, 0.007, 0), 0.0, newglow(Color(0.02, 0.03, 0.03), 0.3), tablet)
	tablet_screen.rotation.x = -PI / 2.0
	tablet_body = interactable("tablet", "Take the tablet", Vector3(0, 0.02, 0), Vector3(0.3, 0.1, 0.35),
		"MIRA'S TABLET\nPsyon: OFFLINE SINCE 15:52\nhistory: 0 conversations", false, tablet)
	tablet_body.set_meta("hackable", true)
	set_active(tablet_body, false)
	tablet_light = light(CIRCLE + Vector3(0, 0.5, -0.1), Color(0.45, 0.95, 0.85), 0.0, 2.6, false)
	# what the tablet becomes if he smashes it
	shards = Node3D.new()
	shards.visible = false
	add_child(shards)
	var sm := mat(Color(0.9, 0.9, 0.92), 0.3, 0.4)
	var glass := mat(Color(0.05, 0.08, 0.08), 0.15, 0.3)
	for i in 14:
		var p := CIRCLE + Vector3(rng.randf_range(-0.35, 0.35), 0.014, rng.randf_range(-0.4, 0.2))
		var s := box(Vector3(rng.randf_range(0.03, 0.1), 0.008, rng.randf_range(0.03, 0.09)), p, sm if i % 3 == 0 else glass, false, shards)
		s.rotation.y = rng.randf() * TAU
	circle_body = interactable("circle", "Look at the circle", CIRCLE + Vector3(0, 0.05, 0), Vector3(1.6, 0.1, 1.6), "", false)
	set_active(circle_body, false)


## Crumpled paper with a spiralling eye in bright red crayon.
func _crayon_eye() -> ImageTexture:
	var n := 128
	var img := Image.create(n, n, false, Image.FORMAT_RGBA8)
	var r := RandomNumberGenerator.new()
	r.seed = 6
	for y in n:
		for x in n:
			var v := 0.86 + r.randf_range(-0.07, 0.05)
			img.set_pixel(x, y, Color(v, v * 0.98, v * 0.92, 1.0))
	var c := Vector2(n / 2.0, n / 2.0)
	var red := Color(0.85, 0.08, 0.05, 1.0)
	# the almond outline
	for i in 400:
		var a := i * TAU / 400.0
		var p := c + Vector2(cos(a) * 56.0, sin(a) * 30.0) + Vector2(r.randf_range(-1.5, 1.5), r.randf_range(-1.5, 1.5))
		for k in 3:
			var q := p + Vector2(r.randf_range(-1.5, 1.5), r.randf_range(-1.5, 1.5))
			if q.x >= 0 and q.y >= 0 and q.x < n and q.y < n:
				img.set_pixelv(q, red)
	# the spiral in the middle, wound tight
	var t := 0.0
	while t < 11.0 * TAU:
		var rr := t * 0.42
		var p := c + Vector2(cos(t), sin(t)) * rr + Vector2(r.randf_range(-1.2, 1.2), r.randf_range(-1.2, 1.2))
		if p.x >= 0 and p.y >= 0 and p.x < n and p.y < n:
			img.set_pixelv(p, red)
			img.set_pixelv(p + Vector2(1, 0), red)
		t += 0.03
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


func _ezra_room() -> void:
	var carpet := pbr("carpet", Vector3(1, 1, 1) / 1.3, true, Color(0.5, 0.58, 0.7))
	floor_quad(Vector2(4.0, 4.8), Vector3(9.5, 0.0, -3.4), 0.0, carpet)
	_wb(Vector3(0.14, H, 4.8), Vector3(7.5, H / 2, -3.4))
	_wb(Vector3(0.14, H, 4.8), Vector3(11.5, H / 2, -3.4))
	_wb(Vector3(4.1, H, 0.14), Vector3(9.5, H / 2, -1.0))
	box(Vector3(4.1, 0.2, 4.9), Vector3(9.5, H + 0.1, -3.4), mat(Color(0.68, 0.67, 0.64), 0.95))
	var dm := mat(Color(0.86, 0.85, 0.82), 0.5)
	var door := box(Vector3(1.0, 2.05, 0.05), Vector3(9.5 - 0.5 + 0.5 * cos(1.4), 1.02, -5.8 + 0.5 * sin(1.4)), dm)
	door.rotation.y = -1.4
	interactable("ezra_door", "Ezra's door", Vector3(9.5, 1.0, -5.78), Vector3(1.0, 2.0, 0.1), "", false)
	# bed on the south wall, the VR headset on the pillow
	var bp := Vector3(9.5, 0, -1.95)
	var frame := mat(Color(0.3, 0.32, 0.36), 0.6)
	box(Vector3(1.05, 0.25, 1.9), bp + Vector3(0, 0.2, 0), frame, true)
	box(Vector3(1.0, 0.18, 1.85), bp + Vector3(0, 0.41, 0), mat(Color(0.95, 0.95, 0.93), 0.9))
	box(Vector3(1.0, 0.12, 1.4), bp + Vector3(0, 0.54, -0.2), pbr("fabric", Vector3(1, 1, 1) / 0.7, true, Color(0.25, 0.4, 0.75)))
	box(Vector3(0.6, 0.12, 0.4), bp + Vector3(0, 0.56, 0.65), mat(Color(0.97, 0.97, 0.95), 0.9))
	box(Vector3(1.05, 0.7, 0.06), bp + Vector3(0, 0.65, 0.95), frame)
	box(Vector3(0.2, 0.09, 0.12), bp + Vector3(-0.2, 0.66, 0.65), mat(Color(0.95, 0.95, 0.95), 0.4, 0.2))
	box(Vector3(0.18, 0.02, 0.01), bp + Vector3(-0.2, 0.66, 0.585), glow(Color(0.3, 0.6, 1.0), 1.5, true))
	interactable("ezra_bed", "Ezra's bed", bp + Vector3(0, 0.6, 0), Vector3(1.1, 0.5, 1.9), "", false)
	# a lit poster, a robot toy, a shelf of exam prep
	box(Vector3(0.9, 1.2, 0.03), Vector3(11.44, 1.5, -3.2), mat(Color(0.05, 0.06, 0.1), 0.6))
	neon_text("PSYON\nJUNIOR", Vector3(11.42, 1.6, -3.2), -PI / 2.0, 0.17, Color(0.3, 0.95, 0.7), 1.6, self)
	neon_text("dream big, little dreamer", Vector3(11.42, 1.1, -3.2), -PI / 2.0, 0.05, Color(0.9, 0.9, 0.9), 1.3, self)
	light(Vector3(11.0, 1.5, -3.2), Color(0.3, 0.9, 0.75), 0.55, 4.0)
	var robot := mat(Color(0.85, 0.3, 0.2), 0.5, 0.3)
	box(Vector3(0.14, 0.18, 0.1), Vector3(8.0, 0.09, -4.4), robot)
	box(Vector3(0.1, 0.1, 0.1), Vector3(8.0, 0.23, -4.4), robot)
	box(Vector3(0.06, 0.01, 0.01), Vector3(8.0, 0.24, -4.455), glow(Color(0.3, 1.0, 0.9), 1.5))
	box(Vector3(0.3, 0.03, 1.4), Vector3(7.72, 1.6, -3.0), mat(Color(0.92, 0.9, 0.86), 0.5))
	for i in 6:
		box(Vector3(0.05, 0.24, 0.03), Vector3(7.72, 1.74, -3.6 + i * 0.09), mat(Color(0.2, 0.25 + i * 0.08, 0.45), 0.8))
	light(Vector3(9.5, H - 0.2, -3.4), Color(1.0, 0.9, 0.8), 0.5, 4.5)


# ------------------------------------------------------------------ the balcony

func _balcony() -> void:
	# a narrow balcony outside the glass, the rail, and the planters where the
	# dust storms leave their twigs
	var conc := pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.55, 0.52, 0.5))
	box(Vector3(2.0, 0.2, 9.4), Vector3(-7.0, -0.1, -4.5), conc, true)
	var rail := mat(Color(0.3, 0.3, 0.33), 0.4, 0.7)
	box(Vector3(0.04, 1.1, 9.4), Vector3(-7.98, 0.55, -4.5), _glass, true)
	box(Vector3(0.08, 0.06, 9.4), Vector3(-7.98, 1.12, -4.5), rail)
	for z: float in [-9.0, -4.5, 0.0]:
		box(Vector3(0.06, 1.12, 0.06), Vector3(-7.98, 0.56, z), rail)
	box(Vector3(2.0, 1.12, 0.05), Vector3(-7.0, 0.56, 0.2), _glass, true)
	box(Vector3(2.0, 1.12, 0.05), Vector3(-7.0, 0.56, -9.2), _glass, true)
	# the planters: soil, a dead shrub, and the twigs the storms bring in.
	# The second evening they have been stripped: snapped off clean.
	var soil := mat(Color(0.22, 0.16, 0.12), 1.0)
	for z: float in [-8.2, -5.5]:
		var pp := Vector3(-7.4, 0, z)
		box(Vector3(0.7, 0.45, 1.2), pp + Vector3(0, 0.22, 0), conc, true)
		box(Vector3(0.6, 0.04, 1.1), pp + Vector3(0, 0.43, 0), soil)
		var shrub := mat(Color(0.3, 0.28, 0.2), 0.9)
		for i in (4 if second else 14):
			var a := pp + Vector3(rng.randf_range(-0.25, 0.25), 0.44, rng.randf_range(-0.45, 0.45))
			var ln := rng.randf_range(0.04, 0.09) if second else rng.randf_range(0.2, 0.5)
			stick(a, a + Vector3(rng.randf_range(-0.15, 0.15), ln, rng.randf_range(-0.15, 0.15)), 0.008, shrub)
		if second:
			for i in 10:
				var a := pp + Vector3(rng.randf_range(-0.28, 0.28), 0.445, rng.randf_range(-0.5, 0.5))
				stick(a, a + Vector3(0, 0.02, 0), 0.006, _stick_m)
	planter_body = interactable("planters", "Look at the planters", Vector3(-7.4, 0.5, -6.85), Vector3(0.8, 0.6, 4.0), "", false)
	light(Vector3(-7.2, 1.6, -4.5), Color(1.0, 0.45, 0.6), 0.6, 7.0, false)
	sun_light = light(Vector3(-6.8, 1.8, -4.0), Color(1.0, 0.6, 0.35), 0.55 if not second else 0.35, 8.0, false)


# ------------------------------------------------------------------ the residence corridor

## Floor 86 outside the door. Book, ch. 3: the lobby "more tech office than
## home", exposed vents along the ceiling like metallic arteries, faux-wood
## panelling streaked with Psyon green, plush sound-dampening carpet, and a
## lift that purrs "Welcome back, Carl." The corridor runs the width of the
## hall; the lifts are at the east end, the service stair at the west.
func _corridor() -> void:
	var before := get_child_count()
	var carpet := pbr("carpet", Vector3(1, 1, 1) / 1.3, true, Color(0.35, 0.4, 0.42))
	var cw := pbr("plaster", Vector3(1, 1, 1) / 2.2, true, Color(0.5, 0.52, 0.5))
	var panel := mat(Color(0.3, 0.23, 0.17), 0.88)   # matt veneer: a glossy pbr here mirrors the sunset sky down the whole hall
	var cove := glow(Color(0.25, 0.95, 0.6), 1.1, true)
	var vent := mat(Color(0.42, 0.44, 0.47), 0.72, 0.25)   # dull galvanised duct, not a mirror for the sunset sky
	var ceil_m := mat(Color(0.36, 0.36, 0.38), 0.9)
	var dm := mat(Color(0.28, 0.3, 0.32), 0.4, 0.5)
	# the corridor itself: x -26..26, z 0.2..3.8
	floor_quad(Vector2(52, 3.6), Vector3(0, 0.0, 2.0), 0.0, carpet)
	solid_box(Vector3(70, 1, 12), Vector3(2, -0.5, 2))
	box(Vector3(52.3, 0.2, 3.8), Vector3(0, H + 0.1, 2.0), ceil_m)
	box(Vector3(20.0, H, 0.14), Vector3(-16.1, H / 2, 0.1), cw, true)
	box(Vector3(20.0, H, 0.14), Vector3(16.1, H / 2, 0.1), cw, true)
	box(Vector3(52.3, H, 0.14), Vector3(0, H / 2, 3.9), cw, true)
	for z: float in [0.2, 3.8]:
		var inward := 0.03 if z < 2.0 else -0.03
		box(Vector3(52.0, 1.0, 0.05), Vector3(0, 0.5, z + inward), panel)
		box(Vector3(52.0, 0.02, 0.06), Vector3(0, 1.0, z + inward * 1.3), cove)
	# the vents, running the length of the ceiling, and the lights
	for z: float in [1.0, 3.0]:
		var v := cyl(0.16, 0.16, 52.0, Vector3(0, H - 0.2, z), vent, 8)
		v.rotation.z = PI / 2.0
	for x: float in [-22.0, -15.0, -8.0, 0.0, 8.0, 15.0, 22.0]:
		box(Vector3(1.2, 0.03, 0.16), Vector3(x, H - 0.04, 2.0), glow(Color(1.0, 0.95, 0.85), 1.0, true))
		light(Vector3(x, H - 0.3, 2.0), Color(1.0, 0.9, 0.78), 0.55, 5.5)
	interactable("vent", "Look at the vents", Vector3(-4.0, H - 0.2, 1.0), Vector3(3.0, 0.4, 0.4), "", false)
	# the neighbours' doors, badge readers beside them, nobody home that you'd know
	for d: Array in [[-20.0, 3.83, "86A", 0.0], [-8.0, 3.83, "86B", 0.0], [-14.0, 0.17, "86C", PI],
			[14.0, 0.17, "86E", PI], [8.0, 3.83, "86F", 0.0], [20.0, 3.83, "86G", 0.0]]:
		var dp := Vector3(d[0], 0, d[1])
		var out := -1.0 if d[1] > 2.0 else 1.0
		box(Vector3(1.1, 2.1, 0.06), dp + Vector3(0, 1.05, 0), dm)
		box(Vector3(0.1, 2.15, 0.14), dp + Vector3(-0.6, 1.07, 0), _trim)
		box(Vector3(0.1, 2.15, 0.14), dp + Vector3(0.6, 1.07, 0), _trim)
		box(Vector3(1.3, 0.1, 0.14), dp + Vector3(0, 2.15, 0), _trim)
		box(Vector3(0.03, 0.5, 0.07), dp + Vector3(0.42, 1.05, out * 0.02), glow(Color(0.3, 0.9, 1.0), 1.2, true))
		box(Vector3(0.08, 0.12, 0.03), dp + Vector3(0.8, 1.3, out * 0.06), mat(Color(0.9, 0.9, 0.88), 0.3, 0.2))
		neon_text(d[2], dp + Vector3(0, 2.3, out * 0.08), d[3], 0.08, Color(0.3, 0.9, 0.6), 1.4, self)
		interactable("flat_" + d[2], "Door " + d[2], dp + Vector3(0, 1.05, 0), Vector3(1.1, 2.1, 0.2),
			"%s\nresidents: WITHHELD\nstatus: HOME" % d[2])
	neon_text("86D", Vector3(0, 2.3, 0.08), 0.0, 0.08, Color(0.3, 0.9, 0.6), 1.4, self)
	box(Vector3(0.08, 0.12, 0.03), Vector3(0.8, 1.3, 0.06), mat(Color(0.9, 0.9, 0.88), 0.3, 0.2))
	# the lift lobby at the east end: x 26..33, z -2.5..6.5
	floor_quad(Vector2(7, 9), Vector3(29.5, 0.0, 2.0), 0.0, carpet)
	box(Vector3(7.2, 0.2, 9.2), Vector3(29.5, H + 0.1, 2.0), ceil_m)
	box(Vector3(0.14, H, 2.7), Vector3(26.0, H / 2, -1.15), cw, true)
	box(Vector3(0.14, H, 2.7), Vector3(26.0, H / 2, 5.15), cw, true)
	box(Vector3(7.2, H, 0.14), Vector3(29.5, H / 2, -2.5), cw, true)
	box(Vector3(7.2, H, 0.14), Vector3(29.5, H / 2, 6.5), cw, true)
	box(Vector3(0.14, H, 9.2), Vector3(33.0, H / 2, 2.0), cw, true)
	var steel := mat(Color(0.6, 0.62, 0.64), 0.2, 0.8)
	for z: float in [0.5, 3.5]:
		box(Vector3(0.06, 2.2, 1.5), Vector3(32.9, 1.1, z), steel)
		box(Vector3(0.02, 2.2, 0.03), Vector3(32.85, 1.1, z), mat(Color(0.05, 0.05, 0.06), 0.5))
		box(Vector3(0.1, 2.35, 0.1), Vector3(32.9, 1.17, z - 0.8), _trim)
		box(Vector3(0.1, 2.35, 0.1), Vector3(32.9, 1.17, z + 0.8), _trim)
		box(Vector3(0.1, 0.1, 1.7), Vector3(32.9, 2.35, z), _trim)
		box(Vector3(0.03, 0.06, 0.7), Vector3(32.86, 2.5, z), glow(Color(0.25, 0.95, 0.6), 1.6, true))
		interactable("lift", "The lift", Vector3(32.9, 1.1, z), Vector3(0.2, 2.2, 1.5),
			"PSYONIC TOWER LIFT %d\nfloor: 86 (RESIDENCE)\nnext call: NONE" % int(z))
	neon_text("86", Vector3(32.86, 2.45, 2.0), -PI / 2.0, 0.22, Color(0.3, 0.95, 0.7), 2.0, self)
	box(Vector3(0.1, 0.08, 0.18), Vector3(32.9, 1.1, 2.0), mat(Color(0.9, 0.9, 0.88), 0.3, 0.2))
	box(Vector3(0.015, 0.015, 0.015), Vector3(32.84, 1.12, 2.0), glow(Color(0.3, 0.9, 1.0), 2.0, true))
	light(Vector3(31.5, H - 0.3, 2.0), Color(1.0, 0.92, 0.8), 0.9, 7.0)
	box(Vector3(2.4, 0.03, 0.2), Vector3(29.5, H - 0.04, 2.0), glow(Color(1.0, 0.95, 0.85), 1.0, true))
	# a bench, a plant in a trough, the building's own screen running its ads
	var bench := pbr("woodfloor", Vector3(1, 1, 1) / 1.0, true, Color(0.5, 0.4, 0.3))
	box(Vector3(2.0, 0.06, 0.45), Vector3(29.5, 0.45, -2.1), bench, true)
	for x: float in [-0.85, 0.85]:
		box(Vector3(0.06, 0.42, 0.4), Vector3(29.5 + x, 0.21, -2.1), steel)
	var pot := mat(Color(0.3, 0.3, 0.32), 0.7)
	box(Vector3(2.4, 0.5, 0.45), Vector3(29.5, 0.25, 6.2), pot, true)
	for i in 9:
		var leaf := box(Vector3(0.08, 0.7, 0.02), Vector3(28.5 + i * 0.25, 0.8, 6.2 + sin(i * 1.7) * 0.12), mat(Color(0.12, 0.35, 0.18), 0.7))
		leaf.rotation = Vector3(0.4 * sin(i * 2.1), i * 0.7, 0.4 * cos(i * 1.3))
	var ap := Vector3(26.07, 1.6, 2.0)
	box(Vector3(0.05, 0.9, 1.6), ap, mat(Color(0.02, 0.02, 0.02), 0.2, 0.3))
	quad(Vector2(1.5, 0.8), ap + Vector3(0.03, 0, 0), PI / 2.0, glow(Color(0.12, 0.2, 0.16), 1.0))
	neon_text("PSYONIC", ap + Vector3(0.04, 0.2, 0), PI / 2.0, 0.14, Color(0.4, 1.0, 0.6), 2.0, self)
	neon_text("customer satisfaction is our greatest priority", ap + Vector3(0.04, -0.1, 0), PI / 2.0, 0.045, Color(0.9, 0.9, 0.9), 1.5, self)
	neon_text("floor 108: PR all-hands, 19:30", ap + Vector3(0.04, -0.28, 0), PI / 2.0, 0.04, Color(1.0, 0.6, 0.3), 1.5, self)
	interactable("lobby_screen", "Look at the lobby screen", ap, Vector3(0.15, 0.9, 1.6), "", false).set_meta("hackable", true)
	# the west end: the service stair, a flight down to a landing that goes nowhere without a badge
	box(Vector3(0.14, H, 1.0), Vector3(-26.0, H / 2, 0.7), cw, true)
	box(Vector3(0.14, H, 1.0), Vector3(-26.0, H / 2, 3.3), cw, true)
	box(Vector3(0.14, H - 2.1, 1.6), Vector3(-26.0, 2.1 + (H - 2.1) / 2, 2.0), cw, true)
	box(Vector3(0.1, 2.15, 0.16), Vector3(-26.0, 1.07, 1.2), _trim)
	box(Vector3(0.1, 2.15, 0.16), Vector3(-26.0, 1.07, 2.8), _trim)
	var fire := box(Vector3(0.06, 2.1, 1.5), Vector3(-26.35, 1.05, 2.0 - 0.75 + 0.75 * cos(1.2)), mat(Color(0.55, 0.12, 0.1), 0.5, 0.3))
	fire.rotation.y = 1.2
	neon_text("SERVICE STAIR", Vector3(-25.9, 2.3, 2.0), PI / 2.0, 0.07, Color(1.0, 0.55, 0.2), 1.6, self)
	interactable("stair_door", "The service stair", Vector3(-26.0, 1.05, 2.0), Vector3(0.2, 2.1, 1.6), "", false)
	var conc := pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.5, 0.5, 0.5))
	var sw := Node3D.new()      # the stairwell: x -34..-26, down to y -1.7
	add_child(sw)
	box(Vector3(8.2, 6.0, 0.14), Vector3(-30.0, 0.0, 0.1), conc, true, sw)
	box(Vector3(8.2, 6.0, 0.14), Vector3(-30.0, 0.0, 3.9), conc, true, sw)
	box(Vector3(0.14, 6.0, 3.8), Vector3(-34.0, 0.0, 2.0), conc, true, sw)
	box(Vector3(8.2, 0.2, 3.8), Vector3(-30.0, H + 0.1, 2.0), conc, false, sw)
	box(Vector3(2.0, 0.2, 3.6), Vector3(-27.0, -0.1, 2.0), conc, true, sw)
	for i in 10:
		box(Vector3(0.28, 0.17, 1.7), Vector3(-28.0 - 0.14 - i * 0.28, -0.085 - i * 0.17, 1.15), conc, true, sw)
	box(Vector3(3.2, 0.2, 3.6), Vector3(-32.4, -1.8, 2.0), conc, true, sw)
	box(Vector3(2.9, 1.0, 0.05), Vector3(-29.4, -0.6, 2.0), steel, true, sw)
	box(Vector3(3.1, 0.06, 0.06), Vector3(-29.4, -0.1, 2.0), steel, false, sw)
	box(Vector3(2.9, 0.03, 0.03), Vector3(-29.4, -1.0, 2.0), steel, false, sw)
	for x: float in [-28.0, -30.8]:
		box(Vector3(0.05, 1.0, 0.05), Vector3(x, -0.2 - (x + 28.0) * -0.6, 2.0), steel, false, sw)
	var ld := Vector3(-33.0, -1.7, 2.9)
	box(Vector3(1.0, 2.05, 0.06), ld + Vector3(0, 1.02, 0.9), dm, false, sw)
	neon_text("85  -  SERVICE\nBADGE REQUIRED", ld + Vector3(0, 2.25, 0.86), PI, 0.05, Color(1.0, 0.3, 0.25), 1.6, sw)
	box(Vector3(0.08, 0.12, 0.03), ld + Vector3(0.7, 1.3, 0.86), mat(Color(0.9, 0.9, 0.88), 0.3, 0.2), false, sw)
	box(Vector3(0.015, 0.015, 0.015), ld + Vector3(0.7, 1.32, 0.84), glow(Color(1.0, 0.1, 0.1), 2.5), false, sw)
	interactable("stair_bottom", "Door to 85", ld + Vector3(0, 1.0, 0.9), Vector3(1.0, 2.0, 0.2),
		"SERVICE DOOR 85\nlock: BADGE (SERVICE ONLY)\nC. DRAKE: DENIED", true, sw)
	var reel := cyl(0.3, 0.3, 0.12, Vector3(-33.9, 1.3, 1.0), mat(Color(0.6, 0.1, 0.08), 0.5), 12, sw)
	reel.rotation.z = PI / 2.0
	box(Vector3(0.4, 0.04, 0.2), Vector3(-27.0, 0.02, 2.4), mat(Color(0.8, 0.75, 0.6), 0.9), false, sw)
	light(Vector3(-30.0, H - 0.3, 2.0), Color(0.9, 0.95, 1.0), 0.6, 6.0)
	light(Vector3(-32.5, -0.2, 2.0), Color(0.9, 0.95, 1.0), 0.5, 5.0)
	# the corridor is deep inside the tower: it goes on render layer 2, which
	# the sunset's light skips (setup_env, forward_plus only), so nothing leaks
	# down 60 m of hall
	var corr := Node3D.new()
	add_child(corr)
	var moved := []
	for i in range(before, get_child_count()):
		var c := get_child(i)
		if c != corr and c != sw and (c is MeshInstance3D or c is StaticBody3D or c is Area3D):
			moved.append(c)
	for c in moved:
		remove_child(c)
		corr.add_child(c)
	_batch(corr, 10.0, true)
	_batch(sw, 10.0)
	_set_layer(corr, 2)
	_set_layer(sw, 2)


# ------------------------------------------------------------------ the city, 86 floors down

func _city_outside() -> void:
	var city := Node3D.new()
	add_child(city)
	kit_parent = city
	# the tower's own face either side of the balcony, going down out of sight
	var face: StandardMaterial3D = _kit_mats()["walls"][1]
	box(Vector3(0.3, 120.0, 40.0), Vector3(-6.3, -57.0, -29.2), face, false, city)
	box(Vector3(0.3, 120.0, 40.0), Vector3(-6.3, -57.0, 20.2), face, false, city)
	box(Vector3(0.3, 118.0, 9.4), Vector3(-6.3, H + 59.2, -4.5), face, false, city)
	box(Vector3(0.3, 120.0, 9.4), Vector3(-6.3, -60.3, -4.5), face, false, city)
	box(Vector3(2.0, 0.3, 9.4), Vector3(-7.0, H + 0.3, -4.5), mat(Color(0.3, 0.3, 0.33), 0.5, 0.5), false, city)
	# the ground, the blocks: a sea of lit windows and signs to the horizon,
	# a few megablocks tall enough to put neon at eye level
	floor_quad(Vector2(1400, 1400), Vector3(-400, GROUND, -50), 0.0, mat(Color(0.1, 0.08, 0.09), 1.0), city)
	for i in 70:
		var px := rng.randf_range(-520.0, -40.0)
		var pz := rng.randf_range(-360.0, 300.0)
		var near := px > -140.0
		var h := rng.randf_range(40.0, 180.0)
		if rng.randf() < 0.2:
			h = rng.randf_range(230.0, 340.0)
		if near and h > 250.0:
			h = 250.0
		var w := rng.randf_range(16.0, 34.0)
		cyber_block(Vector3(px, GROUND, pz), PI / 2.0, w, h, rng.randf_range(16.0, 34.0), false, 1)
	for i in 5:
		var a := Vector3(rng.randf_range(-200, -40), rng.randf_range(-30, 20), rng.randf_range(-120, 80))
		cable(a, a + Vector3(rng.randf_range(-60, -20), rng.randf_range(-10, 10), rng.randf_range(-40, 40)), 3.0)
	skybridge(Vector3(-70, -20, -60), Vector3(-120, -24, -20), 5.0)
	skybridge(Vector3(-50, -62, 30), Vector3(-110, -58, 70), 5.0)
	kit_holo(Vector3(-60, -8, -30), PI / 2.0 + 0.25, "PSYON", "the pillow for those who dream", Color(0.4, 1.0, 0.6), 22.0)
	kit_holo(Vector3(-130, 12, 60), PI / 2.0 - 0.3, "TOKZ", "sleep better. sleep together.", Color(1.0, 0.25, 0.7), 26.0)
	kit_holo(Vector3(-260, 30, -120), PI / 2.0, "PSYMATCHBOT", "she already knows you", Color(0.2, 0.9, 1.0), 40.0)
	kit_holo(Vector3(-90, -40, 120), PI / 2.0 - 0.6, "NIXTRA", "a new flavour: CALM", Color(0.62, 0.28, 1.0), 20.0)
	# the tower's main shaft, jade and silver, the donut above us
	var jade := mat(Color(0.2, 0.45, 0.38), 0.3, 0.7)
	var silver := mat(Color(0.7, 0.72, 0.75), 0.25, 0.8)
	var tp := Vector3(-150, GROUND, -70)
	cyl(26, 30, 30, tp + Vector3(0, 15, 0), jade, 24, city)
	cyl(9, 16, 300, tp + Vector3(0, 165, 0), jade, 16, city)
	for i in 10:
		box(Vector3(0.6, 2.0, 0.6), tp + Vector3(cos(i * 0.6) * 10.0, 50 + i * 24, sin(i * 0.6) * 10.0), glow(Color(1, 0.05, 0.05), 3.0), false, city)
	var tm := TorusMesh.new()
	tm.inner_radius = 30
	tm.outer_radius = 58
	tm.rings = 32
	tm.ring_segments = 12
	mesh(tm, tp + Vector3(0, 340, 0), silver, city)
	var ring := TorusMesh.new()
	ring.inner_radius = 57.5
	ring.outer_radius = 59
	ring.rings = 32
	ring.ring_segments = 6
	mesh(ring, tp + Vector3(0, 340, 0), glow(Color(0.3, 0.95, 0.7), 2.4, true), city)
	kit_parent = self
	_batch(city, 80.0, true)
	# hover traffic in the gulf below the balcony, drones streaming to the tower
	var traffic = preload("res://scripts/Traffic.gd").new()
	traffic.along_x = true
	traffic.lanes = [[-40.0, -22.0, 1.0], [-55.0, -16.0, -1.0], [-30.0, -34.0, -1.0], [40.0, -28.0, 1.0], [60.0, -12.0, -1.0]]
	traffic.s_min = -420.0
	traffic.s_max = -30.0
	traffic.count = 12
	traffic.tower_top = tp + Vector3(0, 300, 0)
	traffic.drone_box = AABB(Vector3(-450, -120, -250), Vector3(430, 110, 450))
	traffic.drone_count = 160
	add_child(traffic)
	traffic.setup(main, self)


# ------------------------------------------------------------------ Psyon's pictures (layer 20)

## Two places only a camera on layer 20 can see: the hexagonal chamber of
## Mira's council, and the woods with Dufredy's desk in them.
func _hidden_scenes() -> void:
	# the Tower: a warm hexagonal chamber, five floating figures "like they
	# hadn't fully resolved into reality"
	council = Node3D.new()
	council.position = Vector3(0, -60, 220)
	add_child(council)
	var amber := glow(Color(1.0, 0.75, 0.4), 0.5)
	var sigil := glow(Color(1.0, 0.55, 0.2), 1.4)
	for i in 6:
		var a := i * TAU / 6.0
		var p := Vector3(cos(a) * 4.0, 2.0, sin(a) * 4.0)
		var facing := atan2(-cos(a), -sin(a))
		quad(Vector2(4.2, 4.0), p, facing, amber, council)
		for k in 3:
			var s := box(Vector3(0.3, 0.3, 0.02), p * 0.97 + Vector3(0, -1.2 + k * 1.1, 0), sigil, false, council)
			s.rotation.y = facing
			s.rotation.z = 0.78
	cyl(4.2, 4.2, 0.1, Vector3(0, -0.05, 0), glow(Color(0.9, 0.6, 0.3), 0.35), 6, council)
	cyl(4.2, 4.2, 0.1, Vector3(0, 4.0, 0), glow(Color(0.5, 0.3, 0.2), 0.3), 6, council)
	var ghost := StandardMaterial3D.new()
	ghost.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	ghost.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ghost.albedo_color = Color(0.9, 0.8, 0.7, 0.45)
	var figs := [
		figure(Color(0.45, 0.35, 0.25), Color(0.85, 0.7, 0.6), {"long_coat": true, "hair": Color(0.8, 0.8, 0.8)}),
		figure(Color(0.72, 0.74, 0.78), Color(0.75, 0.78, 0.82), {"scale": 0.6, "hair": Color(0.7, 0.72, 0.75)}),
		figure(Color(0.25, 0.2, 0.35), Color(0.85, 0.72, 0.62), {"long_hair": true, "long_coat": true}),
		figure(Color(0.6, 0.6, 0.62), Color(0.7, 0.6, 0.55), {"long_coat": true}),
		figure(Color(0.35, 0.3, 0.3), Color(0.8, 0.7, 0.65), {"long_coat": true}),
	]
	for i in figs.size():
		var f: Node3D = figs[i]
		var a := PI * 0.25 + i * PI * 0.5 / 4.0
		f.position = Vector3(cos(a) * 2.4, 0.35 + (i % 2) * 0.2, -sin(a) * 2.4)
		council.add_child(f)
		turn_to(f, council.position + Vector3(0, 0, 3.0))
		if i >= 3:
			_paint(f, ghost)
	# the librarian's eyes are stars
	var lib: Node3D = figs[2]
	for x: float in [-0.035, 0.035]:
		sphere(0.012, Vector3(x, 0.02, -0.105), glow(Color(1.0, 1.0, 0.9), 4.0), 6, lib.get_meta("head"))
	var cl := OmniLight3D.new()
	cl.light_color = Color(1.0, 0.75, 0.45)
	cl.light_energy = 2.5
	cl.omni_range = 7.0
	cl.light_cull_mask = 1 << 19
	cl.position = Vector3(0, 2.5, 0)
	council.add_child(cl)
	_batch(council, 20.0)
	_set_layer(council, 1 << 19)
	# the woods near his parents' house, pine and damp earth, the desk among
	# the trees, the eye carved into it pulsing with its own light
	woods = Node3D.new()
	woods.position = Vector3(0, -60, 300)
	add_child(woods)
	floor_quad(Vector2(40, 40), Vector3.ZERO, 0.0, pbr("grass", Vector3(1, 1, 1) / 2.0, true, Color(0.35, 0.4, 0.3)), woods)
	var bark := pbr("bark", Vector3(1, 1, 1) / 1.5, true)
	var leaves := [mat(Color(0.08, 0.2, 0.1), 0.9), mat(Color(0.1, 0.25, 0.12), 0.9), mat(Color(0.06, 0.16, 0.09), 0.9)]
	for p: Vector3 in [Vector3(-4, 0, -6), Vector3(4.5, 0, -7), Vector3(-6, 0, 1), Vector3(6, 0, 2), Vector3(0, 0, -10), Vector3(-2, 0, -14), Vector3(5, 0, -13)]:
		tree(p, rng.randf_range(5.0, 7.0), bark, leaves, woods)
	var dwood := pbr("woodfloor", Vector3(1, 1, 1) / 1.0, true, Color(0.7, 0.55, 0.4))
	box(Vector3(1.2, 0.04, 0.6), Vector3(0, 0.75, -3.0), dwood, false, woods)
	for x: float in [-0.56, 0.56]:
		for z: float in [-0.26, 0.26]:
			box(Vector3(0.04, 0.73, 0.04), Vector3(x, 0.365, -3.0 + z), dwood, false, woods)
	var eye := Sprite3D.new()
	eye.texture = _glyph_tex
	eye.pixel_size = 0.0038
	eye.modulate = Color(1.0, 0.3, 0.2)
	eye.position = Vector3(0, 0.775, -3.0)
	eye.rotation.x = -PI / 2.0
	woods.add_child(eye)
	var wl := OmniLight3D.new()
	wl.light_color = Color(1.0, 0.45, 0.3)
	wl.light_energy = 2.0
	wl.omni_range = 5.0
	wl.light_cull_mask = 1 << 19
	wl.position = Vector3(0, 1.2, -3.0)
	woods.add_child(wl)
	var ml := OmniLight3D.new()
	ml.light_color = Color(0.5, 0.6, 0.9)
	ml.light_energy = 1.2
	ml.omni_range = 18.0
	ml.light_cull_mask = 1 << 19
	ml.position = Vector3(2, 6, 0)
	woods.add_child(ml)
	_batch(woods, 20.0)
	_set_layer(woods, 1 << 19)


func _set_layer(n: Node, layer: int) -> void:
	if n is VisualInstance3D and not n is Light3D:
		(n as VisualInstance3D).layers = layer
	for c in n.get_children():
		_set_layer(c, layer)


func _paint(n: Node, m: Material) -> void:
	if n is MeshInstance3D:
		(n as MeshInstance3D).material_override = m
	for c in n.get_children():
		_paint(c, m)


## A still from a camera that can see layer 20.
func _picture(from: Vector3, at: Vector3) -> Texture2D:
	var vp := SubViewport.new()
	vp.size = Vector2i(640, 400)
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(vp)
	var cam := Camera3D.new()
	cam.fov = 62.0
	cam.near = 0.05
	vp.add_child(cam)
	cam.global_transform = Transform3D(Basis.looking_at(at - from, Vector3.UP), from)
	cam.current = true
	for i in 4:
		await RenderingServer.frame_post_draw
	var img := vp.get_texture().get_image()
	vp.queue_free()
	return ImageTexture.create_from_image(img)


# ------------------------------------------------------------------ the family

func _family() -> void:
	# Monica: curly black hair, dark brown eyes, the PR director's blouse
	monica = figure(Color(0.55, 0.18, 0.28), Color(0.86, 0.68, 0.56), {"hair": Color(0.06, 0.05, 0.05), "long_hair": true,
		"legs": Color(0.12, 0.12, 0.14), "arms": true, "knees": true, "long_coat": false})
	add_child(monica)
	person("monica", "Talk to Monica", monica, "DRAKE, MONICA (38)\nPSYONIC PR - DIRECTOR OF IMAGE DESIGN\nPsymatchbot: 97.87% (RECORD)")
	# Mira: raven curls, freckles, pyjamas. Ezra: his father's unruly brown curls
	mira = figure(Color(0.82, 0.6, 0.75), Color(0.86, 0.68, 0.56), {"hair": Color(0.06, 0.05, 0.05), "long_hair": true,
		"legs": Color(0.82, 0.6, 0.75), "arms": true, "knees": true, "scale": 0.62, "long_coat": false})
	add_child(mira)
	person("mira", "Talk to Mira", mira, "DRAKE, MIRA (11)\nPSYONIC EDUCATION - GRADE 6\nBreathBot: EXEMPLARY")
	ezra = figure(Color(0.2, 0.45, 0.32), Color(0.86, 0.68, 0.56), {"hair": Color(0.35, 0.22, 0.12),
		"legs": Color(0.25, 0.28, 0.4), "arms": true, "knees": true, "scale": 0.7, "long_coat": false})
	add_child(ezra)
	person("ezra", "Talk to Ezra", ezra, "DRAKE, EZRA (10)\nPSYONIC EDUCATION - GRADE 5\nConvo AI: FREE-THOUGHT PASS")
	# seated at the table: Mira north-west, Ezra north-east, facing the glass
	_seat(mira, TABLE + Vector3(-0.45, 0, -0.75), PI)
	_seat(ezra, TABLE + Vector3(0.45, 0, -0.75), PI)
	if second:
		_seat(monica, TABLE + Vector3(0.45, 0, 0.75), 0.0)
	else:
		# in the kitchen, arms crossed, before Carl can shut the door
		monica.position = Vector3(-2.2, 0, -7.9)
		monica.rotation.y = PI
		for a in monica.get_meta("arms"):
			(a as Node3D).rotation.x = 1.3
			(a as Node3D).rotation.z = (-0.5 if (a as Node3D).position.x > 0.0 else 0.5)
		monica.set_meta("crossed", true)
	# Mira cross-legged on her floor, back to the door, for the second evening
	mira_floor = figure(Color(0.82, 0.6, 0.75), Color(0.86, 0.68, 0.56), {"hair": Color(0.06, 0.05, 0.05), "long_hair": true,
		"legs": Color(0.82, 0.6, 0.75), "arms": true, "knees": true, "scale": 0.62, "long_coat": false})
	mira_floor.position = MIRA_SPOT + Vector3(0, -0.4, 0)
	mira_floor.rotation.y = 0.0
	add_child(mira_floor)
	var legs: Array = mira_floor.get_meta("legs")
	for i in legs.size():
		var side := -1.0 if i == 0 else 1.0
		(legs[i] as Node3D).basis = Basis(Vector3.UP, -side * 1.0) * Basis(Vector3.RIGHT, 1.5)
	for k in mira_floor.get_meta("knees"):
		(k as Node3D).rotation.x = -2.4
	(mira_floor.get_meta("body") as Node3D).rotation.x = -0.22
	for a in mira_floor.get_meta("arms"):
		(a as Node3D).rotation.x = 1.0
		(a as Node3D).rotation.z = (-0.25 if (a as Node3D).position.x > 0.0 else 0.25)
	(mira_floor.get_meta("head") as Node3D).rotation.x = -0.4
	mira_floor.set_meta("posed", true)
	person("mira_floor", "Mira", mira_floor, "DRAKE, MIRA (11)\nPsyon Junior: sync 100%\nstatus: DREAMING")
	_hide(mira_floor)
	# Ezra on his bed with the headset on, after he has been sent off
	ezra_vr = figure(Color(0.2, 0.45, 0.32), Color(0.86, 0.68, 0.56), {"hair": Color(0.35, 0.22, 0.12),
		"legs": Color(0.25, 0.28, 0.4), "arms": true, "knees": true, "scale": 0.7, "visor": true, "long_coat": false})
	ezra_vr.position = Vector3(9.5, 0.6 - 0.86 * 0.7, -2.0)
	ezra_vr.rotation.y = 0.0
	add_child(ezra_vr)
	Anim.sit(ezra_vr, 0.3)
	for a in ezra_vr.get_meta("arms"):
		(a as Node3D).rotation.x = 1.2
	box(Vector3(0.2, 0.09, 0.12), Vector3(0, 0.02, -0.08), mat(Color(0.95, 0.95, 0.95), 0.4, 0.2), false, ezra_vr.get_meta("head"))
	ezra_vr.set_meta("posed", true)
	ezra_vr.visible = false


## The talk collider person() wrapped round a figure.
func _body_of(f: Node3D) -> CollisionObject3D:
	for c in f.get_children():
		if c is CollisionObject3D:
			return c
	return null


func _hide(f: Node3D) -> void:
	f.visible = false
	var b := _body_of(f)
	if b:
		set_active(b, false)


func _seat(f: Node3D, pos: Vector3, rot: float) -> void:
	var s: float = f.scale.x
	f.position = pos + Vector3(0, 0.46 - 0.86 * s, 0)
	f.rotation.y = rot
	Anim.sit(f, 0.08)
	f.set_meta("seated", true)


## Send a figure along a path of floor points; tick walks it.
func _walk(f: Node3D, path: Array, speed := 1.1) -> void:
	for k: String in ["seated", "crossed"]:
		if f.has_meta(k):
			f.remove_meta(k)
	(f.get_meta("body") as Node3D).rotation.x = 0.0
	f.position.y = 0.0
	movers.append({"fig": f, "path": path, "i": 0, "speed": speed})
	f.set_meta("walking", true)


func _arrived(f: Node3D) -> void:
	while f.has_meta("walking"):
		await get_tree().process_frame


func _slide_door(open: bool) -> void:
	create_tween().tween_property(front_door, "position:x", -1.05 if open else 0.0, 0.9).set_trans(Tween.TRANS_SINE)
	main.play("door", -12.0, 1.4)


func tick(delta: float) -> void:
	if not main or not main.player or not main.started:
		return
	var pp: Vector3 = main.player.global_position
	var f: Dictionary = main.flags
	# walkers
	var done := []
	for mv in movers:
		var fig: Node3D = mv["fig"]
		var path: Array = mv["path"]
		var target: Vector3 = path[mv["i"]]
		var d := target - fig.position
		d.y = 0.0
		var step: float = mv["speed"] * delta
		if d.length() <= step:
			fig.position = target
			mv["i"] += 1
			if mv["i"] >= path.size():
				done.append(mv)
				continue
		else:
			fig.position += d.normalized() * step
			fig.rotation.y = lerp_angle(fig.rotation.y, atan2(-d.x, -d.z), minf(1.0, delta * 9.0))
		Anim.walk(fig, _t, mv["speed"] * 1.3, 0.0, 0.9)
	for mv in done:
		movers.erase(mv)
		(mv["fig"] as Node3D).remove_meta("walking")
		for l in (mv["fig"] as Node3D).get_meta("legs"):
			(l as Node3D).rotation.x = 0.0
	# the standing and seated ones breathe and watch Carl
	for fig: Node3D in [monica, mira, ezra]:
		if not fig.visible or fig.has_meta("walking"):
			continue
		if fig.has_meta("seated"):
			Anim.look(fig, pp + Vector3(0, 1.5, 0), 0.8 if pp.distance_to(fig.global_position) < 6.0 else 0.0, 0.06)
		elif fig.has_meta("crossed"):
			Anim.look(fig, pp + Vector3(0, 1.6, 0), 1.0, 0.08)
		else:
			Anim.idle(fig, _t, float(fig.get_instance_id() % 7))
			Anim.look(fig, pp + Vector3(0, 1.6, 0), 0.9, 0.06)
	if mira_floor.visible:
		var hd: Node3D = mira_floor.get_meta("head")
		if mira_floor.has_meta("turned"):
			Anim.look(mira_floor, pp + Vector3(0, 1.4, 0), 1.0, 0.08)
		else:
			# the measured rhythm: she rocks, very slightly, over the circle
			(mira_floor.get_meta("body") as Node3D).rotation.x = -0.22 + sin(_t * 1.7) * 0.03
			hd.rotation.x = -0.4 + sin(_t * 1.7) * 0.02
	# the lens: a red pinprick that is not always there
	if lens_dot:
		lens_dot.visible = fmod(_t, 7.0) < 0.12 or (second and fmod(_t, 2.3) < 0.08)
	# the hall outside her door, the second evening: the chant drifts down it
	if second and f.has("home_monica2") and not _ritual_started and not f.has("cinematic") \
			and pp.x > 7.8 and pp.x < 11.2 and pp.z > -7.3 and pp.z < -5.7:
		_ritual()


# ------------------------------------------------------------------ the chapters

## A line from the script: LINES[beat][key].
func L(beat: String, key: String) -> String:
	return LINES[beat][key]


## Play a run of lines from the script: [[who, text], ...]; who "" is a thought.
func _play(beat: String, key: String) -> void:
	for ln: Array in LINES[beat][key]:
		if ln[0] == "":
			await main.ui.think(ln[1])
		else:
			await main.ui.say(ln[0], ln[1])


func objective() -> String:
	var f: Dictionary = main.flags
	var o: Dictionary = LINES["objective"]
	if not f.has("home_in"):
		return o["badge"]
	if second:
		if _ended:
			return ""
		if f.has("ritual_in_room"):
			return o["tablet"]
		if f.has("home_monica2"):
			return o["mira2"]
		return o["monica2"]
	if f.has("home_mira1"):
		return o["sleep"]
	if f.has("home_monica1"):
		return o["dinner"]
	return ""


func intro() -> void:
	var ui = main.ui
	await get_tree().create_timer(0.5).timeout
	main.play("ding", -10.0, 1.2)
	await _play("lift", "second" if second else "first")
	ui.close()


## Badge on the door, in, and the evening starts.
func _enter() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	if f.has("home_in"):
		await ui.think(L("examine", "exit2" if second else "exit1"))
		return
	f["home_in"] = true
	f["cinematic"] = true
	main.play("ding", -12.0, 1.5)
	_slide_door(true)
	front_body.set_meta("prompt", L("prompt", "leave"))
	await get_tree().create_timer(0.9).timeout
	p.seated = true
	var tw := create_tween()
	tw.tween_property(p, "position", Vector3(1.0, 0.05, -1.5), 2.0).set_trans(Tween.TRANS_SINE)
	await p.face(Vector3(-2.0, 1.5, -7.5), 1.6)
	await tw.finished
	p.seated = false
	_slide_door(false)
	f.erase("cinematic")
	if second:
		await _intro_second()
	else:
		await _intro_first()


func scan_people() -> Array:
	var out := []
	var sc: Dictionary = LINES["scan"]
	if monica.visible:
		out.append([monica, sc["monica"]])
	if mira.visible:
		out.append([mira, sc["mira2"] if second else sc["mira1"]])
	if ezra.visible:
		out.append([ezra, sc["ezra"]])
	if mira_floor.visible:
		out.append([mira_floor, sc["mira2"]])
	return out


func phone() -> String:
	var f: Dictionary = main.flags
	var ph: Dictionary = LINES["phone"]
	var t: String = ph["home2" if second else "home1"]
	if not second and f.has("home_mira1"):
		t += ph["council"]
	if second:
		t += ph["offline"]
	if f.has("ritual_in_room"):
		t += ph["never"]
	return t


func interact(node: Object) -> bool:
	var ui = main.ui
	var f: Dictionary = main.flags
	var ex: Dictionary = LINES["examine"]
	var id := str(node.get_meta("id"))
	match id:
		"monica":
			if second:
				await _monica_second()
			else:
				await _monica_first()
		"mira":
			if second:
				await ui.say("Mira", L("dinner2", "nothing"))
			else:
				await _mira_first()
		"mira_floor":
			if f.has("ritual_in_room"):
				await ui.say("Mira", L("ritual", "sorry"))
			else:
				await ui.think(ex["mira_back"])
		"ezra":
			if second:
				await _ezra_second()
			else:
				await _ezra_first()
		"window":
			await ui.think(ex["window"])
			if second:
				await ui.think(ex["window2"])
		"balcony_door":
			await ui.think(ex["balcony2" if second else "balcony1"])
		"planters":
			if second:
				await ui.think(ex["planters2"])
				await ui.think(ex["planters2b"])
				main.add_connection(1.0, L("toast", "planters"))
			else:
				await ui.think(ex["planters1"])
		"lens":
			await ui.think(ex["lens"])
			if second:
				await ui.think(ex["lens2"])
		"mira_door":
			if second and not _ritual_started:
				await _ritual()
			elif second:
				await ui.think(ex["mira_door2"])
			else:
				await ui.think(ex["mira_door1"])
		"nightlight":
			await ui.think(ex["nightlight"])
			if second:
				main.add_connection(1.0, L("toast", "nightlight"))
		"tablet":
			if f.has("ritual_in_room") and not _ended:
				await _take_tablet()
		"bedroom_door":
			await ui.think(ex["bedroom2" if second else "bedroom1"])
		"front_door":
			await _enter()
		"couch":
			await _couch()
		"flat_86A", "flat_86B", "flat_86C", "flat_86E", "flat_86F", "flat_86G":
			await ui.think(ex["neighbour"])
		_:
			if ex.has(id):
				await ui.think(ex[id])
			else:
				return false
	return true


# ------------------------------------------------------------------ evening 1 (ch. 3)

func _intro_first() -> void:
	var f: Dictionary = main.flags
	f["cinematic"] = true
	await main.ui.think(L("arrive1", "door"))
	main.ui.close()
	await main.player.face(monica.global_position + Vector3(0, 1.55, 0), 1.0)
	await main.ui.think(L("arrive1", "voice"))
	f.erase("cinematic")
	await _monica_first()


func _monica_first() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	if f.has("home_monica1"):
		await ui.think(L("monica1", "gone"))
		return
	f["home_monica1"] = true
	f["cinematic"] = true
	await ui.say("Monica", L("monica1", "open"))
	coat.visible = true
	await _play("monica1", "talk")
	await ui.think(L("monica1", "lens"))
	var pick: int = await ui.choose(LINES["monica1"]["choices"])
	match pick:
		0:
			await ui.say("Carl", L("monica1", "ask0"))
			ui.close()
			await p.face(Vector3(5.85, H - 0.05, -0.25), 0.7)
			lens_dot.visible = true
			await get_tree().create_timer(0.6).timeout
			await p.face(monica.global_position + Vector3(0, 1.55, 0), 0.7)
			await ui.think(L("monica1", "glance"))
			await ui.say("Monica", L("monica1", "of_course"))
		1:
			await ui.say("Carl", L("monica1", "ask1"))
			await ui.think(L("monica1", "her_eyes"))
			f["told_monica_fork"] = true
		2:
			await ui.say("Carl", L("monica1", "ask2"))
			await ui.say("Monica", L("monica1", "of_course"))
	main.play("ding", -10.0, 1.6)
	await _play("monica1", "watch")
	ui.close()
	# she goes: past him, out the sliding door, down the hall
	_walk(monica, [Vector3(-0.6, 0, -4.6), Vector3(-0.4, 0, -1.3), Vector3(0, 0, 0.6), Vector3(0, 0, 3.2), Vector3(5.2, 0, 3.6)], 1.25)
	await get_tree().create_timer(2.6).timeout
	_slide_door(true)
	await _arrived(monica)
	_slide_door(false)
	_hide(monica)
	await _play("monica1", "left")
	ui.close()
	ui.show_toast(L("toast", "monica1"), 4.0)
	f.erase("cinematic")
	main.update_hud()


func _ezra_first() -> void:
	var f: Dictionary = main.flags
	if f.has("home_ezra1"):
		await _play("dinner1", "biology")
		return
	await _play("dinner1", "bicker")
	await _play("dinner1", "biology")
	await main.ui.think(L("dinner1", "laugh"))
	f["home_ezra1"] = true
	main.update_hud()


func _mira_first() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("home_mira1"):
		await ui.say("Mira", L("tower", "again"))
		return
	if not f.has("home_ezra1"):
		await _play("dinner1", "serious")
		return
	f["cinematic"] = true
	await _play("tower", "pitch")
	ui.close()
	# her tablet on the table: the council convenes
	ui.laptop_open(true)
	ui.smear.visible = false
	ui.laptop_log.append_text("[color=#556]%s[/color]\n\n" % L("tower", "header"))
	await get_tree().create_timer(0.6).timeout
	main.play("keys", -8.0, 1.3)
	ui.laptop_log.append_text("[color=#e0a0d0]Mira:[/color] %s\n\n" % L("tower", "convene"))
	await get_tree().create_timer(0.8).timeout
	await ui.laptop_line(L("tower", "greets"))
	main.play("keys", -8.0, 1.3)
	ui.laptop_log.append_text("[color=#e0a0d0]Mira:[/color] %s\n\n" % L("tower", "yes"))
	await get_tree().create_timer(0.5).timeout
	main.play("hum", -14.0, 0.7)
	var img: Texture2D = await _picture(council.global_position + Vector3(0, 1.3, 3.6), council.global_position + Vector3(0, 1.2, 0))
	await ui.laptop_image(img, 3.0)
	await ui.think(L("tower", "chamber"))
	ui.close()
	await ui.laptop_line(L("tower", "sensed"))
	await ui.say("Mira", L("tower", "ask_it"))
	var q: int = await ui.choose(LINES["tower"]["questions"])
	ui.close()
	main.play("keys", -8.0, 1.3)
	ui.laptop_log.append_text("[color=#e0a0d0]Mira:[/color] %s\n\n" % LINES["tower"]["typed"][q])
	await get_tree().create_timer(0.8).timeout
	await ui.laptop_line(LINES["tower"]["replies"][q])
	await ui.think(L("tower", "conferred"))
	ui.close()
	await get_tree().create_timer(0.4).timeout
	ui.laptop_open(false)
	await _play("tower", "you_gotta")
	var pick: int = await ui.choose(LINES["tower"]["choices"])
	match pick:
		0:
			await _play("tower", "council_mum")
		1:
			await ui.say("Carl", L("tower", "later"))
			main.add_connection(1.0, L("toast", "humoured"))
		2:
			await _play("tower", "not_that")
	await ui.say("Carl", L("tower", "wash_up"))
	ui.close()
	ui.show_toast(L("toast", "tower"), 4.0)
	await _ezra_line()
	f["home_mira1"] = true
	f.erase("cinematic")
	main.update_hud()


## Ezra at the doorway: "Psyon is the gate for those who dream."
func _ezra_line() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	_walk(ezra, [Vector3(4.2, 0, -6.5), Vector3(5.7, 0, -6.5)], 0.9)
	await ui.think(L("gate", "padded"))
	ui.close()
	await _arrived(ezra)
	turn_to(ezra, p.global_position, 0.5)
	await p.face(ezra.global_position + Vector3(0, 1.2, 0), 0.8)
	ui.glitch(0.25, 0.8)
	await ui.say("Ezra", L("gate", "phrase"))
	main.play("sting", -12.0, 0.7)
	await _play("gate", "froze")
	ui.close()
	_walk(ezra, [Vector3(9.5, 0, -6.5), Vector3(9.5, 0, -4.2)], 1.0)
	await p.face(mira.global_position + Vector3(0, 1.0, 0), 0.8)
	await _play("gate", "mira")
	var pick: int = await ui.choose(LINES["gate"]["choices"])
	match pick:
		0:
			await ui.say("Carl", L("gate", "truth"))
		1:
			await ui.say("Carl", L("gate", "bad_word"))
		2:
			await _play("gate", "phone")
			f["suspects_monica"] = true
	ui.close()
	await _arrived(ezra)
	_hide(ezra)
	ezra_vr.visible = true
	_walk(mira, [Vector3(4.2, 0, -6.5), Vector3(9.5, 0, -6.5), Vector3(9.5, 0, -8.6)], 0.85)
	await ui.think(L("gate", "spreading"))
	ui.close()
	ui.show_toast(L("toast", "gate"), 4.0)
	main.add_connection(1.0, L("toast", "phrase"))
	await _arrived(mira)
	_hide(mira)
	create_tween().tween_property(mira_door, "rotation:y", -0.12, 0.8)


func _couch() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	if second:
		await ui.think(L("sleep", "not_yet2"))
		return
	if not f.has("home_mira1"):
		await ui.think(L("sleep", "not_yet1"))
		return
	if _ended:
		return
	_ended = true
	f["cinematic"] = true
	# lie down: the eyes drop to the cushion, the city turns sideways
	p.seated = true
	var tw := create_tween().set_parallel(true)
	tw.tween_property(p, "position", Vector3(-2.3, 0.0, -2.6), 1.0)
	tw.tween_property(p, "crouch", 1.15, 1.2).set_trans(Tween.TRANS_SINE)
	await tw.finished
	await p.face(Vector3(-7.0, 1.4, -2.6), 1.0)
	await ui.think(L("sleep", "asleep"))
	ui.close()
	await ui.fade_to(1.0, 2.0)
	await get_tree().create_timer(0.8).timeout
	# the dream: the woods near his parents' house
	var img: Texture2D = await _picture(woods.global_position + Vector3(1.6, 1.3, 1.2), woods.global_position + Vector3(0, 0.75, -3.0))
	main.play("whisper", -8.0, 0.6)
	ui.show_picture(img, L("sleep", "caption"))
	await _play("sleep", "dream")
	ui.hide_picture()
	ui.close()
	main.add_connection(1.0, L("toast", "dream"))
	await get_tree().create_timer(0.6).timeout
	await _play("sleep", "morning")
	ui.close()
	f.erase("cinematic")
	f["home1_done"] = true
	if not main._selftest:
		main.load_level("WarRoom")


# ------------------------------------------------------------------ evening 2 (ch. 6)

func _intro_second() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	f["cinematic"] = true
	await ui.think(L("arrive2", "door"))
	ui.close()
	await p.face(TABLE + Vector3(0, 1.0, 0), 1.0)
	await _play("dinner2", "home")
	ui.close()
	_walk(mira, [Vector3(4.2, 0, -6.5), Vector3(9.5, 0, -6.5), Vector3(9.5, 0, -8.6)], 1.5)
	await get_tree().create_timer(1.2).timeout
	await _play("dinner2", "space")
	ui.close()
	await _arrived(mira)
	_hide(mira)
	main.play("door", -14.0, 0.8)
	mira_door.rotation.y = -0.85
	mira_floor.visible = true
	set_active(_body_of(mira_floor), true)
	f.erase("cinematic")
	main.update_hud()


func _monica_second() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("home_monica2"):
		await ui.say("Monica", L("monica2", "careful_short"))
		return
	f["cinematic"] = true
	await _play("monica2", "elonthiel")
	var pick: int = await ui.choose(LINES["monica2"]["choices"])
	if pick == 0:
		await _play("monica2", "map")
		f["told_monica_map"] = true
	else:
		await _play("monica2", "vague")
	await _play("monica2", "careful")
	ui.close()
	f["home_monica2"] = true
	f.erase("cinematic")
	# the sun goes while they talk
	_dusk(6.0)
	main.update_hud()


func _ezra_second() -> void:
	var f: Dictionary = main.flags
	if f.has("home_ezra2"):
		return
	await _play("dinner2", "recess")
	main.ui.close()
	f["home_ezra2"] = true
	_walk(ezra, [Vector3(4.2, 0, -6.5), Vector3(9.5, 0, -6.5), Vector3(9.5, 0, -4.2)], 1.4)
	await _arrived(ezra)
	_hide(ezra)
	ezra_vr.visible = true


## Night comes down over the city while the family talks.
func _dusk(t: float) -> void:
	var tw := create_tween().set_parallel(true)
	if _sun:
		tw.tween_property(_sun, "light_energy", 0.12, t)
		tw.tween_property(_sun, "light_color", Color(0.45, 0.5, 0.8), t)
	if _sky:
		tw.tween_property(_sky, "sky_horizon_color", Color(0.22, 0.08, 0.08), t)
		tw.tween_property(_sky, "ground_horizon_color", Color(0.14, 0.06, 0.07), t)
	if sun_light:
		tw.tween_property(sun_light, "light_energy", 0.0, t)


## The ritual. Book, ch. 6: the chant through the gap in the door, the circle,
## eight seconds, the muted chime, the tablet that has never spoken before.
func _ritual() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	if _ritual_started:
		return
	_ritual_started = true
	f["cinematic"] = true
	_dusk(3.0)
	main.play("whisper", -14.0, 0.5)
	await p.face(MIRA_DOOR + Vector3(0.3, 1.2, -0.5), 1.2)
	await ui.think(L("ritual", "sound"))
	ui.close()
	# to the gap in the door, quietly
	p.seated = true
	var tw := create_tween()
	tw.tween_property(p, "position", MIRA_DOOR + Vector3(0.55, 0.05, 0.85), 2.2).set_trans(Tween.TRANS_SINE)
	await tw.finished
	await p.face(MIRA_SPOT + Vector3(0, 0.6, 0), 1.0)
	await ui.say("Mira", L("ritual", "verse1"))
	await _play("ritual", "through_gap")
	await p.face(CIRCLE + Vector3(0, 0.05, 0), 1.0)
	await ui.think(L("ritual", "inside"))
	var pick: int = await ui.choose(LINES["ritual"]["choices"])
	if pick == 1:
		await p.face(MIRA_SPOT + Vector3(0, 0.6, 0), 0.8)
		await ui.say("Mira", L("ritual", "verse2"))
		await ui.think(L("ritual", "still"))
		ui.close()
		await get_tree().create_timer(2.6).timeout
		# the muted chime, from beneath her; her face lit by the tablet
		main.play("ding", -16.0, 0.55)
		(tablet_screen.material_override as StandardMaterial3D).emission = Color(0.35, 0.8, 0.7)
		(tablet_screen.material_override as StandardMaterial3D).emission_energy_multiplier = 1.6
		tablet_light.light_energy = 1.0
		(mira_floor.get_meta("head") as Node3D).rotation.x = -0.6
		await get_tree().create_timer(0.8).timeout
		await _play("ritual", "chime")
		f["ritual_watched"] = true
		main.add_connection(2.0, L("toast", "watched"))
	else:
		await ui.think(L("ritual", "barge"))
	ui.close()
	# the door scrapes the floor; in
	main.play("slam", -6.0, 0.8)
	p.shake(0.3)
	create_tween().tween_property(mira_door, "rotation:y", -1.85, 0.5).set_trans(Tween.TRANS_BACK)
	var tw2 := create_tween()
	tw2.tween_property(p, "position", MIRA_SPOT + Vector3(0.0, 0.05, 1.0), 1.0).set_trans(Tween.TRANS_SINE)
	await tw2.finished
	p.seated = false
	mira_floor.set_meta("turned", true)
	(mira_floor.get_meta("body") as Node3D).rotation.x = -0.05
	await p.face(mira_floor.global_position + Vector3(0, 0.9, 0), 0.6)
	await _play("ritual", "what_is_this")
	ui.close()
	await p.face(CIRCLE + Vector3(0, 0.05, 0), 0.8)
	await ui.think(L("ritual", "lit"))
	ui.close()
	f["ritual_in_room"] = true
	set_active(tablet_body, true)
	set_active(circle_body, true)
	set_active(_body_of(mira_floor), true)
	f.erase("cinematic")
	main.update_hud()


func _take_tablet() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	_ended = true
	f["cinematic"] = true
	var kneel := create_tween()
	kneel.tween_property(p, "crouch", 0.7, 0.8).set_trans(Tween.TRANS_SINE)
	await p.face(CIRCLE + Vector3(0, 0.05, -0.1), 0.8)
	await ui.think(L("tablet", "snatched"))
	ui.close()
	tablet.visible = false
	tablet_light.light_energy = 0.0
	set_active(tablet_body, false)
	ui.laptop_open(true)
	ui.smear.visible = false
	ui.laptop_log.append_text("[color=#556]%s[/color]\n[color=#556]%s[/color]\n\n" % [L("tower", "header"), L("tablet", "history")])
	await get_tree().create_timer(0.5).timeout
	main.play("keys", -6.0)
	await ui.laptop_line(L("tablet", "question"), true)
	await get_tree().create_timer(0.9).timeout
	await ui.laptop_line(L("tablet", "never"))
	main.play("sting", -4.0, 0.75)
	ui.glitch(0.7, 1.2)
	p.shake(0.3)
	await ui.think(L("tablet", "spin"))
	var pick: int = await ui.choose(LINES["tablet"]["choices"])
	ui.close()
	ui.laptop_open(false)
	var up := create_tween()
	up.tween_property(p, "crouch", 0.0, 0.5)
	if pick == 0:
		await get_tree().create_timer(0.5).timeout
		main.play("slam", 0.0, 1.1)
		main.play("snap", -2.0, 0.7)
		p.shake(0.6)
		shards.visible = true
		await _play("tablet", "smash")
		f["tablet_smashed"] = true
		ui.show_toast(L("toast", "smashed"), 4.0)
	else:
		await ui.think(L("tablet", "pocket"))
		f["tablet_kept"] = true
		main.add_connection(1.0, L("toast", "kept"))
	# Monica in the doorway
	monica.visible = true
	if monica.has_meta("seated"):
		monica.remove_meta("seated")
	(monica.get_meta("body") as Node3D).rotation.x = 0.0
	for l in monica.get_meta("legs"):
		(l as Node3D).rotation.x = 0.0
	for k in monica.get_meta("knees"):
		(k as Node3D).rotation.x = 0.0
	monica.position = MIRA_DOOR + Vector3(0.1, 0, 0.35)
	monica.rotation.y = 0.0
	await p.face(monica.global_position + Vector3(0, 1.55, 0), 0.9)
	await ui.think(L("tablet", "monica"))
	ui.close()
	main.play("pressure", -6.0)
	var fall := create_tween().set_parallel(true)
	fall.tween_property(p, "crouch", 1.5, 1.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	fall.tween_property(p, "pitch", -1.1, 1.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	ui.glitch(0.6, 1.2)
	await get_tree().create_timer(0.5).timeout
	await ui.think(L("tablet", "floor"))
	ui.close()
	p.shake(0.5)
	main.play("slam", -4.0, 0.6)
	await ui.fade_to(1.0, 1.0)
	main.add_connection(2.0, L("toast", "ritual"))
	ui.show_toast(L("toast", "ritual_log"), 4.0)
	await get_tree().create_timer(1.2).timeout
	# the morning after
	await _play("morning", "lines")
	ui.close()
	f.erase("cinematic")
	f["ritual_seen"] = true
	if not main._selftest:
		main.load_level("WarRoom")


# ------------------------------------------------------------------ dev and test

func apply_args(a: Dictionary) -> void:
	if a.has("ritual"):
		# the room as he sees it through the gap: the tablet lit, Mira still
		_hide(mira)
		mira_floor.visible = true
		mira_door.rotation.y = -0.85
		_dusk(0.1)
		if str(a["ritual"]) == "2":
			(tablet_screen.material_override as StandardMaterial3D).emission = Color(0.35, 0.8, 0.7)
			(tablet_screen.material_override as StandardMaterial3D).emission_energy_multiplier = 1.6
			tablet_light.light_energy = 1.0
	if a.has("gone"):
		_hide(monica)
		_hide(mira)
		_hide(ezra)
	if a.has("coat"):
		coat.visible = true
	if a.has("sun") and _sun:
		_sun.light_energy = float(a["sun"])


func _by_id(id: String) -> void:
	for n in main._all_with_meta(self, "id"):
		if is_instance_valid(n) and str(n.get_meta("id")) == id:
			await main.interact(n)
			print("ok ", id)
			return


func selftest() -> void:
	await intro()
	await _enter()
	print("ok enter")
	if second:
		for id in ["monica", "ezra", "mira_door"]:
			await _by_id(id)
		while main.flags.has("cinematic"):
			await get_tree().process_frame
		for id in ["circle", "nightlight", "mira_bed", "mira_floor", "tablet"]:
			await _by_id(id)
		print("ok ritual")
	else:
		for id in ["ezra", "mira", "couch"]:
			await _by_id(id)
		print("ok evening 1")
	await main.selftest_all_interactables()
