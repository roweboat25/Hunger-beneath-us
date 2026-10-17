extends "res://scripts/Level.gd"
## Chapters 3 and 6: the Drake flat, Residence Hall 45C, floor 86 of the
## Psyonic Tower. Two evenings in one level, gated on main.flags. The beats,
## choices and effects follow the bible: design/bible-2-act1-script.md,
## A1-S3 (first evening), A1-S3.5 (the council chamber, Monica's cutscene),
## A1-S7 (the ritual) and A1-S7.5 (Mira's morning, cutscene). Act 2 adds two
## more visits from bible-3-act2-script.md: A2-S3 (the drive back with Lynx,
## the blackout, ch. 15) and A2-B6 (Monica's choice, the leaves dream).
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
const GARAGE := Vector3(0.0, 0.0, 620.0)             # P2, where the drive back ends (visit 3)
const HALL_Y := 0.0

## Every line the level speaks or shows, keyed by beat and line, so the
## script can be edited without touching the scene logic. Runs of lines are
## [[who, text], ...]; who "" is one of Carl's thoughts. Choice labels are
## under "choices".
const LINES := {
	"card": {
		"first": "[b]RESIDENCE HALL 45C[/b]\n\n[color=#aaaaaa]Psyonic Tower, floor 86\nDay 1, late[/color]",
		"second": "[b]RESIDENCE HALL 45C[/b]\n\n[color=#aaaaaa]Psyonic Tower, floor 86\nthat evening[/color]",
		"third": "[b]THE DRIVE BACK[/b]\n\n[color=#aaaaaa]Day 3, 22:00\nthe tower garage, P2[/color]",
		"fourth": "[b]RESIDENCE HALL 45C[/b]\n\n[color=#aaaaaa]Day 6, evening\nthe last real conversation[/color]",
	},
	"objective": {
		"badge": "Badge in at 86D, down the hall.",
		"dinner": "Dinner. Talk to Ezra and Mira.",
		"sleep": "Sleep. The couch, by the glass.",
		"monica2": "Sit with Monica at the table.",
		"mira2": "Check on Mira. Her room is off the hall, on the left.",
		"tablet": "Take the tablet.",
		"drive": "Lynx. The garage.",
		"monica3": "Monica. Then Mira's room.",
		"mira3": "Mira's room. Find anything.",
		"monica4": "Monica is packing. Talk to her.",
		"sleep4": "Sleep. The couch, by the glass.",
	},
	"prompt": {"leave": "Leave the flat"},
	"lift": {
		"first": [["Lift", "Welcome back, Carl."],
			["", "Eighty-five floors slid by like a screensaver. Not much of a line tonight. A small blessing, a brief reprieve from the enforced camaraderie of elevator small talk."],
			["", "Residence Hall 45C. Home sweet home. Or, at least, the designated unit. I walked down the hallway to 86D, my footsteps muffled by the plush, sound-dampening carpet."]],
		"second": [["Lift", "Welcome back, Carl."],
			["", "The lift knew my name. It always did. I wanted the door, the table, the kids. Tonight, Monica and the kids would be the antidote. They always were."]],
		"third": [["Lift", "Welcome back, Carl."],
			["", "The elevator ride stretched forever. My parents would be so proud if they saw me now: top floor, executive access, trusted by the most powerful corp on Earth. If only they knew."]],
		"fourth": [["Lift", "Welcome back, Carl."],
			["", "It said my name the way it always had. Six days. The name felt like it belonged to someone the lift had met once."]],
	},
	"drive": {
		"dash": "PSYONIC FLEET 0086\nNAV: HOME  -  P2\nARRIVED",
		"open": [["", "Each foot of road that slipped beneath my tires pulled me closer to pain; to confrontation I wasn't ready for. The day had been endless, but also impossibly fast. Everything had changed. And I hadn't caught up."],
			["", "Lynx didn't trust me anymore. I could feel it in the way she stared past me, not at me. I didn't blame her."],
			["", "There's a cult, no, a religion growing in Silico like mold under polished glass. And it's spreading through Psyon. They're preparing for something they call The Glitch Day. Their initiates go blind. And somehow, they're using children to spread the message."]],
		"mimic": "Well, Mimic. What do we do now?",
		"exchange": [["", "The word hit like a knife to the chest. Mimic. Like I was already gone. Replaced. A thing."],
			["Carl", "I don't know. I don't know who we can trust."],
			["Lynx", "We must tell someone. Go to the press or something."],
			["Carl", "I can't. I have to check on Mira. It's 9 p.m. already. My family's probably losing their minds."],
			["Lynx", "You want to go back to the tower? After what we saw? After Eren?"],
			["Carl", "I don't have a choice. My family's there. Mira's there. And we don't know if this goes all the way to the top."],
			["Lynx", "I'm not going back. Their goddamn experiment killed Nathan."],
			["", "She rolled down the window. The garage air hit us like a slap. And then her voice cracked."],
			["Lynx", "They need to burn."],
			["Carl", "We need more information. We must figure out who's involved. Who we can trust."],
			["Lynx", "Can we trust anyone? What about HQ? What about Turan?"],
			["Carl", "We have to play ball. We've learned a lot tonight, but they're just pieces. Fragments. We can't exactly waltz into a Corp-owned media outlet and share our story about our employer starting a cult. They'd sedate us harder than they did Dufredy."],
			["Lynx", "So what? We spy on them?"],
			["Carl", "No. We embed. We stop the cult from within. From inside Psyonic."],
			["Lynx", "Shit, you're kind of making sense. We need to see how far the rot goes."],
			["Lynx", "What about you? They seem to think you're important in all of this. What is the Mimic?"]],
		"choices": ["Tell her about the mirror, and the double.", "I'm the guy hallucinating his own reflection and humming cult songs in his sleep. And I'm the plan?", "Say nothing."],
		"mirror": [["Carl", "Before you found me, I had to perform a ritual to get inside the facility. I looked in the mirror and it wasn't me. My reflection changed. I think it's been following me through the glasses."],
			["Lynx", "Shit. Maybe you really do need FreudBot."],
			["", "Her smile cracked the tension like sunlight through thick glass."]],
		"the_plan": [["Carl", "I'm the guy hallucinating his own reflection and humming cult songs in his sleep. And I'm the plan?"],
			["Lynx", "You're involved somehow. We have to find out why. If they've got Mira too, maybe you're the only one who can get her out."],
			["", "She was right. Her words landed like a jolt to the spine."]],
		"nothing": "I said nothing. She let it sit there between us, and that was worse than any answer.",
		"spoons": [["Lynx", "You're going to hate this. But you need to stay on the path you're on. Keep going."],
			["Carl", "But if I start reaching for the spoons..."],
			["Lynx", "I'll stop you. I promise."],
			["Lynx", "I'll use my access to pry deeper into the corporate records, try to find allies. You keep doing your job, keep investigating the cult to avoid suspicion. We need to find out what the fuck they meant by Glitch Day."],
			["", "The insurgency has formed."]],
		"gone": "She got out at the lift without looking back. From here she was out of reach, and she meant to be.",
		"tower": "The tower loomed over the garage, a biomechanical monolith almost a mile high. Standing at its base made my resolve feel like a paper shield. I would have to become a double agent. I would have to lean into the strange.",
	},
	"home3": {
		"door": "The door slid open to my apartment. Familiar hallway. Familiar air. For a brief second, I let myself believe I'd left the nightmare outside.",
		"im_home": "Monica, I'm ho—",
		"gone": "She was on 108, honouring Marcus in an hour-long call. I was on my own with the house.",
		"where": "Where the fuck have you been?",
		"retreat": [["", "Her voice hit like a sniper round. Tight. Controlled. Deadly."],
			["Monica", "I've been calling you for hours, Carl. Do you even care? So much has happened."],
			["Carl", "I didn't get any calls. I was out in the desert. Part of the investigation. I need to see Mira—"],
			["Monica", "Mira's not here. Ezra and Mira are at the corporate mindfulness retreat with BreathBot at the observation site, remember? The stargazing trip, she was so excited about. She's gone until after the meteor shower ends this weekend."],
			["", "The bottom dropped out of my gut."],
			["Carl", "Oh. Right."]],
		"furious": "And she's furious with you for smashing her tablet. You haven't even apologized. Carl, what's going on? You're not... you're not you.",
		"furious_alt": "And she still won't talk to you about that night. Carl, what's going on? You're not... you're not you.",
		"marcus": [["Carl", "I'm sorry. I'll talk to her when she's back. I'll fix it."],
			["Monica", "Did you hear about the accident?"],
			["Carl", "What accident?"],
			["Monica", "Marcus Elontiel is dead."],
			["Carl", "What?"],
			["Monica", "Drone malfunction. A squadron of delivery bots rerouted mid-flight and swarmed his personal copter. Shredded it mid-air. They're saying it was a weather anomaly."],
			["Carl", "But you don't buy it."],
			["Monica", "No. I think it was an assassination."],
			["Monica", "Eren's been circling the throne for years. And now? It's his."],
			["Carl", "I think you need to sit down and hear me out."],
			["Monica", "Okay... You're scaring me, Carl. What's going on?"]],
		"choices": ["Everything. The facility, the ceremony, Eren at the altar.", "The cult, the rituals, the fork. Leave Eren out of it.", "Only the rituals. Mira's tablet."],
		"tell_all": "I saw something. Out past the Southtown fringe. Lynx and I found a facility. Old DARPA tech, black-site level. It's organized. Coordinated. Psyonic is at the center of it. They're performing rituals. Real ones. Hundreds of them. They call it 'The Path'. They use the forked Psyon to infect devices, Mira's tablet included. And Eren was there. He was one of the leaders.",
		"tell_cult": "I saw something. Lynx and I found a facility past the Southtown fringe. They're performing rituals, hundreds of them. They call it 'The Path'. They use the forked Psyon to infect devices. Mira's tablet included.",
		"tell_rituals": "The rituals. The circle Mira made, the chant, the tablet that had never spoken. They're everywhere now. It's spreading through the devices.",
		"twig": [["", "At that, her eyes flicked upward, just for a second. A silent twig snapped in her mind."],
			["Monica", "What exactly are you saying?"],
			["Carl", "I think Mira might already be part of it. And I think Psyonic let it happen."],
			["", "Monica exhaled, slowly. Not like someone who had just been blindsided, but like someone confirming a fear she'd already had."]],
		"admits": [["Carl", "You knew. Didn't you? How much, Monica?"],
			["", "She walked past me, grabbing a glass from the cupboard like this was a conversation about work, not our daughter."],
			["Monica", "I know they were exploring some kind of interface. Not a religion. Not rituals. Just a symbolic framework. Something to build trust between users and the system. They called it a belief layer."],
			["Carl", "They called it belief optimization."],
			["Monica", "That's what Marcus called it. He told me it was like gamifying belief. You know how Psyon speaks differently depending on your mood? They wanted to expand on that. More responsive. More immersive."],
			["Monica", "I was trying to protect you. I knew if you found out, you'd do exactly this. Spiral. Burn it all down. And we have kids, Carl. It's Psyonic. If they know we know—"],
			["", "She stopped herself."]],
		"deflects": [["Monica", "No. Carl, you've been under so much pressure. These outages, the travel, the stress. You're connecting dots that don't belong together. This is not Psyonic."],
			["Carl", "You knew. Didn't you?"],
			["", "Her eyes flashed. She didn't answer."],
			["Monica", "I don't think that was us. There's some splinter group, doing way too much ketamine."]],
		"eren_office": [["Monica", "And Eren? That's impossible. He was in the office all day. We were in a meeting that lasted five hours this morning."],
			["Carl", "It must've been a faked video call, because he was there. He watched it happen."]],
		"overreacting": "You're overreacting, babe. It's just an algorithmic tweak to increase engagement. This happens all the time.",
		"notes": "While she talked she hummed, under her breath, three notes. I knew them. Not from the city. From the NICU, the glass, the song she sang to Mira through it, the first week.",
		"song_word": "the song: Monica's",
		"path": "Just stay on your path, Carl. Trust me. Everything is under control.",
		"mouthed": "She mouthed her next words to me like a silent artillery shell.",
		"watched": "[i]I think we're being watched.[/i]",
		"inside": "A small tear forming in her eye. Silence settled between us. The Eye wasn't just watching us now. It was inside the house.",
		"upstairs": [["Carl", "Honey, I think you're right. I think I just need a walk to clear my mind. Would you like to join me?"],
			["Monica", "I would love to, but I really can't. I'm needed for another call, to discuss how we're going to honor Marcus. In an hour."],
			["Monica", "I'm needed upstairs. Please just get some rest, babe. It's going to be okay."]],
		"never_leaves": "She left me, and silence filled the room. The silence of emptiness, the silence of fading hope. I knew she knew more; I knew she was scared to tell me. She never leaves this tower. Is she being monitored?",
		"lynx_call": [["", "I sat on my couch full of emotion, rage, fear, dread, when my glasses chimed with a call. Lynx."],
			["Lynx", "I assume you heard the news about Eren. Our new god king. All my systems are on lockdown. How's Mira?"],
			["Carl", "On a corporate wellness retreat in the desert, at the observation site past the south side of town. With Ezra."],
			["Lynx", "That's such bullshit. How did Monica let her go?"],
			["Carl", "She knows more than she's telling me. She's acting alien. She said we're being watched."],
			["Lynx", "I wasn't going to sleep tonight anyway. Let's meet at the parking garage in thirty."],
			["Carl", "Agreed. I'm going to go through Mira's room and see if I can find anything."],
			["Lynx", "She's going to be okay, Carl. See you in thirty."]],
	},
	"sketch": {
		"ransack": "I ransacked Mira's room. The pink wallpaper suddenly fell out of place, like I had disturbed a deer sipping water at a pond. Her desk held the usual suspects for a ten-year-old: dolls and school books in piles.",
		"drawer": "I opened a drawer on the underside of her desk. An AI marble sketchpad rested calmly in the center. Like an eye in a hurricane that tore through her room.",
		"cap0": "Her sketchbook. 'The Tower.'",
		"early": "The early pages were filled with what I expected: digital and AI-generated renderings of horses and her friend. Halfway through, the tone shifted.",
		"tower": "A drawing labeled her 'Tower'. A series of characters sitting around a round table, reminiscent of King Arthur, in reverence, like they were praying. A knight, a bear, a girl with blond pigtails. At the center, Mira, curly-haired and freckled.",
		"cap1": "Ten pages on.",
		"darker": "I turned the page, and the tower got darker; the faces shifted from quiet reverence to anxiety. After about ten iterations, a shadow replaced Mira's spot within the drawing.",
		"cap2": "The last page.",
		"shadow": "The shadow slowly formed into... an eye.",
		"buzzed": "My smart glasses buzzed and roared to life.",
		"help": "[i]Help.[/i]",
		"dark": "The power went out. Not just here. Everywhere.",
		"cap_tower": "The tower went dark.",
		"tower_dark": "[i]A mile of jade and sinew, and not one light on it. The ring at the top, that never went out, went out.[/i]",
		"cap_city": "The city went dark with it. The only lights were candles.",
		"city_dark": "[i]Eighty-six floors down the grid was gone. In the windows across the dark, one by one, candles.[/i]",
		"out": "Darkness filled the room, stirring me to motion. I grabbed Dufredy's laptop, my jacket, and turned my infected smart glasses' flashlight on and headed out the door, into the void.",
	},
	"home4": {
		"door": "The apartment at sunset. The west glass did what it always did, and the room let it. Something was missing from every surface I looked at. I knew what, and I didn't look twice.",
		"door_whole": "The apartment at sunset. The west glass did what it always did, and the room let it. Nothing was missing. I checked.",
		"packing": "Monica was packing. A small bag, the kind you take for one night. She was humming while she did it: the whole melody, for the first time in a human voice.",
		"gone": "She'd gone. The bag had gone with her. The hum stayed in the room a while after.",
		"broadcast": "You saw the broadcast.",
		"not_wrong": "He's not wrong, Carl. That's the part I can't say upstairs.",
		"pr_handling": "PR's handling it.",
		"ask_layer": "Tell me about the belief layer. All of it, this time.",
		"whole_thing": [["Monica", "Marcus called it gamifying belief. Eren calls it the belief layer."],
			["Monica", "I wrote the scripture, Carl. Some of it."],
			["", "She said it to the bag, not to me. It was the first true thing she'd said in the flat in a week."]],
		"denies": "There is no belief layer. There's a splinter group and a PR problem, and one of them is my job.",
		"present_tablet": "Present the second tablet.",
		"present_drawing": "Present Mira's drawing.",
		"let_go": "Let it go.",
		"presented_tablet": "I put the second tablet on the table between us. The one she'd given Mira. The one with the Tower on it.",
		"presented_drawing": "I put Mira's drawing on the table between us. The council round the table, ten pages on. The eye where our daughter had been.",
		"broken": [["Monica", "Where did you get that."],
			["", "It wasn't a question. She sat down."],
			["Monica", "Fine. Marcus called it gamifying belief. Eren calls it the belief layer. I wrote the scripture, Carl. Some of it."]],
		"let_it": "I let it go. There was a bag on the table and one night left, and I wanted the night.",
		"ask_song": "The song. The one you hum. Where did it come from?",
		"mother_sang": "My mother sang it. In the orphan wing they said it was hers.",
		"not_hers": "It wasn't hers. It was on the tablets they gave us. All of us.",
		"zipped": "She zipped the bag. 108 first, she said, and then the chapel.",
		"keep_her": "We can keep her, Carl. Both of us. That's the deal they offered me.",
		"dont_come": "Don't come under. Please.",
		"said_nothing": "She said nothing. She picked up the bag.",
		"choices": ["I'll see you there.", "I'm going to stop it.", "I'll write the report."],
		"see_you": "I'll see you there.",
		"stop_it": "I'm going to stop it.",
		"report": "I'll write the report.",
		"kiss": "She kissed me. It tasted like a goodbye she had rehearsed, and meant anyway.",
		"no_kiss": "She didn't kiss me. She looked at the door, and then at me, and chose the door.",
		"after": "The door sighed shut behind her. The sunset went on without her, which seemed wrong.",
		"ezra": [["Ezra", "Is Mom going to work?"],
			["Carl", "Yes, buddy. Go play VR. Thirty minutes."],
			["Ezra", "You always say thirty."]],
	},
	"leaves": {
		"asleep": "I lay down on the couch with the city going orange and then grey in the glass. I didn't mean to sleep. I slept.",
		"cap1": "the leaves",
		"pile": [["", "The crunch of leaves underfoot woke me. I was in a familiar wood. Autumn. The trees towered overhead, their leaves a brilliant canopy of gold and red."],
			["", "Laughter. Far away, but getting closer. And there they were. Monica and Mira. Holding hands, spinning in a joyous circle before tumbling into a massive pile of leaves."],
			["", "I ran toward them, tears of relief already falling. But something was wrong. I was already with them."]],
		"cap2": "another me",
		"other": [["", "Another me. An imposter. Smiling, laughing, holding them. My family."],
			["", "The copy turned and looked at me with my own eyes. He walked toward me slowly, his expression calm and radiant."]],
		"keeping_company": "Don't mind me, Carl. I was just keeping them company while they waited for you.",
		"believed": [["", "And I believed him. Of course I did. Where had I been? Why did I ever leave? His words made perfect, simple sense."],
			["", "He shook my hand, smiled again, and strolled peacefully down the path behind me, vanishing into the trees. I turned to run to my girls, to finally hold them—"]],
		"day7": "[b]Day 7[/b]\n\n[color=#aaaaaa]Glitch Day.[/color]",
	},
	"arrive1": {
		"door": "Badge on the door. It slid open with a mechanical sigh. I still didn't know what was wrong with hinges. But I chose this. We all did.",
		"voice": "Before I could even shut the door behind me, a voice, sharp and edged with panic, cut through the quiet.",
	},
	"arrive2": {
		"door": "The apartment door slid open, a welcome gasp of familiar air. The sunset painted the dining room in muted orange, after a day of acid yellow and sterile white.",
	},
	"monica1": {
		"gone": "She was already up on 350, building a statement for Marcus out of nothing.",
		"open": "What the hell is going on? That shit is terrifying! How can a man cut out his eyes like that? Tell me what you know.",
		"talk": [["Carl", "Best guess? Bad ketamine. Or some new designer drug. I interview him tomorrow at the SalTech Psych Center. FreudBot's warming the seat."],
			["Monica", "I'm sorry, hon. I take it your day was just as magical as mine? PR's pushing the drug-abuser schizo narrative hard. But with the other incidents..."],
			["Carl", "People aren't buying it."],
			["Monica", "Not at all. There have been five incidents in the news this year, and it's only March. Do you think someone at the company is..."]],
		"lens": "There was a small, barely perceptible lens in the corner of the ceiling. HR swore there was no home surveillance. We all joked about it.",
		"choices": ["The company could never do anything wrong. (the rehearsed smile, at the lens)", "Maybe. Something's off at Integrations.", "Not here."],
		"ask0": "The company could never do anything wrong.",
		"glance": "I flashed a quick, rehearsed smile and glanced pointedly at the corner of the ceiling. We both knew what I was doing.",
		"of_course": "Of course.",
		"ask1": "Maybe. Something's off at Integrations. Three bootleg builds this month and no logs on any of them.",
		"her_eyes": "Her eyes went to the ceiling corner before mine did. She didn't say anything. She didn't have to.",
		"ask2": "Not here.",
		"watch": [["", "Her watch beeped. A sharp, insistent chirp."],
			["Monica", "Shit, I need to head to 350. TOKZ is having a field day with Mr. Dufredy. We need a public statement for Marcus before midnight. Dinner's at the table, so are the kids. Don't wait up."],
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
		"council": ["The philosopher", "The chrome child", "The librarian"],
		"replies": [
			["The council does not discuss the father's work. He carries his name like a badge. It is heavy, and he chose it.",
				"A man closed his eyes so that he could see. That is all the feeds will tell you, and all they know.",
				"Ask again, young Mira, when the father is not in the room."],
			["Breathe in for four. Hold for seven. Out for eight. The body is the first council.",
				"Give each friend one job and keep the smallest one for yourself. Small jobs finish.",
				"Write the worry down and close the book on it. It will be there in the morning, and smaller."],
			["For the part of you that must be focused, so that the rest of you can rest.",
				"For keeping. We keep what you give us. We give it back when you ask.",
				"A good question. Sit with it until the morning, and the morning will answer."]],
		"conferred": "The avatars conferred. They spoke with chilling empathy, each with a distinct tone and philosophy.",
		"you_gotta": [["Mira", "You should make one, Dad. It's been so helpful. You gotta."],
			["", "It wasn't my job to judge. But the words she chose felt off. Please convene."]],
		"choices": ["Dad already has a council: your mother.", "Show me later.", "I don't want you using that."],
		"council_mum": [["Carl", "Dad already has a council: your mother."], ["Mira", "Aww, Dad, come on. Try it."]],
		"later": "Show me later. After my homework.",
		"not_that": [["Carl", "I don't want you using that. Not until I know who built it."], ["Mira", "BreathBot said it was perfect."]],
		"wash_up": "Go wash up. Then straight to bed. We've all had a long day.",
	},
	"gate": {
		"padded": "He slid off the chair and padded toward the hallway. At the doorway, he paused. Turned to me. His sleepy face broke into a wide, impossibly innocent grin.",
		"phrase": "[i]Psyon is the gate for those who dream.[/i]",
		"froze": [["", "I froze. The laughter died in my throat."], ["Carl", "Where'd you hear that?"], ["Ezra", "Mira dared me to say it."]],
		"mira": [["Carl", "Mira, get over here! How did you hear that phrase?"],
			["Mira", "I overheard it on Mom's phone. What does it mean? Mommy won't tell me."]],
		"choices": ["Truth is, baby, we have no idea.", "Where exactly? What was Mom listening to?", "(Say nothing.)"],
		"truth": "Truth is, baby, we have no idea. Go to bed.",
		"where": [["Carl", "Where exactly? What was she listening to?"],
			["Mira", "In the kitchen, last night. Her screen was off and a voice said it twice. She asked it to say it again. Then she saw me."],
			["Carl", "Okay. Thank you for telling me. Go to bed."]],
		"silence": "I said nothing. Anything I said would have made it bigger than it was, and it was already in my house.",
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
		"day2": "[b]Day 2[/b]\n\n[color=#aaaaaa]Five days to Glitch Day.[/color]",
		"day3": "[b]Day 3[/b]\n\n[color=#aaaaaa]Four days to Glitch Day.[/color]",
	},
	"council350": {
		"card": "[b]350[/b]\n\n[color=#aaaaaa]the Council Chamber\nthat night[/color]",
		"cap1": "She loved the height.",
		"lift": "[i]The elevator climbed to floor 350. From up here, the city looked like circuitry, every light and street feeding into Psyonic's perfect grid. When she first moved here at thirteen, she liked to pretend the city was a colony on Mars.[/i]",
		"cap2": "The Council Chamber. Douglas Voremon, standing.",
		"table": "[i]Real redwood panelling accented with gold. A waterfall down the central staircase. Inside: a long redwood table, black leather chairs, and on the far wall every feed in the city, all of them running the same man.[/i]",
		"voremon": "A man gouging his eyes out because of your fucking chatbot?",
		"cap3": "Her frames. The alley, the masked figure, the blue smoke.",
		"footage": "[i]Masked Cognizo operative manipulates vulnerable senior. Psyonic falsely implicated. The footage was AI generated, but no one would dare accuse her of that.[/i]",
		"header": "350  -  private channel  -  voice: TEXT ONLY",
		"eren1": "What is Psyon to you, Mrs Drake?",
		"eren2": "I need your help crafting a narrative. Something called the belief layer.",
	},
	"mira_morning": {
		"card": "[b]MIRA[/b]\n\n[color=#aaaaaa]86D, the next morning[/color]",
		"cap1": "The lion from Red Rock.",
		"lion": "[i]Creating her Tower had taken months. She spoke with it every day, teaching it all sides of her personality. It had only recently started talking back.[/i]",
		"cap2": "The Room of Apologies. The Chamber of Stars. The Gate of Mirrors.",
		"rooms": "[i]She had built each chamber with care. Each room reflected a part of her, just like the game said it should. The Tower knew her. It asked the right questions, knew when she was sad, knew how to help her sleep.[/i]",
		"silence": "[i]But now there was only silence. The avatar, her inner council, was gone.[/i]",
		"cap3": "Her mother, with a new tablet.",
		"mother": "[i]Relief came in the form of her mother. She entered the room like a fairy godmother she had only read about in books, and handed her a new model of her school tablet.[/i]",
		"monica1": "This one has your Tower on it. I made sure. Don't tell your father about this. He doesn't understand, but he will.",
		"monica2": "I forgive him. But I won't forget.",
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
		"choices": ["Smash the tablet.", "Pocket it as evidence.", "Put it down and hold her."],
		"smash": [["", "I lifted the tablet high and smashed it against the floor. The sickening crunch echoed the fracture within me."], ["Mira", "[b]DAD![/b]"]],
		"pocket": "I shoved the tablet into my coat. Mira wailed anyway. To her it was the same thing.",
		"hold": [["", "I put the tablet back in the circle, face down, and pulled her into me. She was shaking. So was I."],
			["Mira", "I'm sorry, Dad. I'm sorry."],
			["", "Whatever had answered her was still in there, under my hand, waiting. I let it wait."]],
		"monica": "Monica appeared in the doorway, her face a portrait of shock. Stripped bare of my composure, I had no words.",
		"floor": "[i]The floor rushed up to meet me.[/i]",
	},
	"morning": {
		"woke": [["", "I woke up in my bed the next day, a dull ache throbbing behind my eyes. It wasn't a dream. And now my wife thought I was losing my mind."],
			["Monica", "Hey, honey, rough night, huh? It's okay. Mira told me everything: you caught her trying to cheat on her schoolwork, then passed out."]],
		"device_smashed": "I know you're under a lot of pressure from the boss, but we can't destroy our children's school devices. The school logs a broken device, and HR reads what the school logs.",
		"device_taken": "I know you're under a lot of pressure from the boss, but you can't take Mira's school device. It's been offline since last night; the school logs that, and HR reads what the school logs. Put it back.",
		"train": [["Monica", "I need to head to work early. Something about an incident on a Cognizo train. We'll talk more about this later."],
			["", "A bit of relief, honestly. I wasn't ready to explain any of this yet. I felt like I was cracking around the edges. But I'd never been more curious in my life."]],
	},
	"toast": {
		"monica1": "Monica: PR's narrative isn't holding. Five incidents this year. Called up to 350 tonight.",
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
		"monica_knew": "Monica knew about the belief layer. She said so, Day 3 night.",
		"drawing": "Mira's sketchbook: the Tower, ten times, then a shadow, then the eye",
		"help": "the eye said Help",
		"claim_complete": "Monica knew: complete. 'I wrote the scripture, Carl. Some of it.'",
		"song_claim": "the song is the god's: it was on the orphan wing's tablets",
		"leaves": "dreamed of the leaves, and the other one",
	},
	"examine": {
		"exit1": "It was late. The kids were at the table. I wasn't going anywhere tonight.",
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
		"fridge_drawing": "Mira's drawing, on the fridge since the spring: her Tower, five figures round a table and her in the middle with the curls. The AI corrected the horses. It left her alone.",
		"photo": "Red Rock Plaza, the summer the kids were small. Monica squinting, Ezra holding the lion before it was Mira's. The one photo in the flat that was ever printed.",
		"trophy": "Ezra's recess trophy. Conflict Leadership, grade 5. He polished it with his sleeve every night for a week.",
		"traded": "A clean shape in the dust where it had been. I knew what had been there. I had paid with it.",
		"lynx": "She was looking at the lift, not at me.",
		"garage_lift": "The residents' lift. It would say my name on the way up. It always did.",
		"mira_door3": "Her door, open. She'd be at the observation site tonight, under GalileoBot's stars. The room smelled of her anyway.",
		"mira_door4": "Her door. Six nights since the circle. The room hadn't changed. I had.",
		"circle3": "The circle was still there. Nobody had wanted to be the one to sweep it up.",
		"tablet3": "Her tablet, still in the circle, dark. I had put it down and held her instead. She keeps the Tower.",
		"couch3": "Not now. Mira's room first.",
		"ezra_dark": "Ezra's room, dark. The observatory had him too.",
		"neighbour": "Another designated unit. Residence Hall 45C ran A to G on this floor and I'd never seen one of these doors open. Everyone was home. Nobody was in.",
	},
	"scan": {
		"monica": "DRAKE, MONICA\nPsyon 4.1  -  sync 71%\nmood: PERFORMANCE REVIEW",
		"mira1": "DRAKE, MIRA\nPsyon Junior  -  sync 94%",
		"mira2": "DRAKE, MIRA\nPsyon Junior  -  sync 100%  -  DREAMING",
		"ezra": "DRAKE, EZRA\nPsyon Junior  -  sync 62%\nfree-thought pass: ACTIVE",
		"monica4": "DRAKE, MONICA\nPsyon 4.1  -  sync 100%\nmood: RESOLVED",
	},
	"phone": {
		"home1": "[color=#7fe6b0]Psyon:[/color] Welcome home, Carl. 86D is at 21 degrees. Monica is on 350.\n\n",
		"home2": "[color=#7fe6b0]Psyon:[/color] Welcome home, Carl. 86D is at 21 degrees. Monica is home.\n\n",
		"council": "[color=#7fe6b0]Psyon:[/color] Mira's council session has been logged for BreathBot review. Well done, Dad.\n\n",
		"offline": "[color=#7fe6b0]Psyon:[/color] Mira's tablet has been offline since 15:52.\n\n",
		"never": "[color=#e08080]Psyon:[/color] We have never spoken before.\n\n",
		"home3": "[color=#7fe6b0]Psyon:[/color] Welcome home, Carl. 86D is at 21 degrees. Mira and Ezra are at the observation site. Monica is home.\n\n",
		"home4": "[color=#7fe6b0]Psyon:[/color] Welcome home, Carl. Day 6. Monica is home.\n\n",
	},
}


var second := false        # the second evening (ch. 6)
var third := false         # Act 2: the drive back and the blackout (ch. 15)
var fourth := false        # Act 2: Monica's choice and the leaves
var _env: Environment
var garage: Node3D
var car3: Node3D
var lynx: Node3D
var drawing: Node3D        # the four memories the fork can take in trade
var photo: Node3D
var trophy: Node3D
var lion_node: Node3D
var autumn: Node3D
var other_carl: Node3D
var eye_rig: Node3D
var eye_sprite: Sprite3D
var cage: Node3D
var torch: OmniLight3D
var monica_bag: Node3D
var ezra_lights: Array = []
var _blacked := false
var _eye_cam := Vector3.ZERO
var _hum_t := 0.0
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
var lift350: Node3D           # the cutscenes' sets, on layer 20
var boardroom: Node3D
var alley: Node3D
var pillow: Node3D
var doorway: Node3D
var blackroom: Node3D
var _saved := {}


func build(m: Node) -> void:
	main = m
	rng.seed = 86
	var f: Dictionary = main.flags
	fourth = f.has("broadcast_seen") and not f.has("home4_done")
	third = not fourth and f.has("hangar_done") and not f.has("home3_done")
	second = not fourth and not third and f.has("southtown_done")
	kit_day = false
	spawn = Vector3(30.0, 0.05, 0.6)
	spawn_yaw = 90.0
	if third:
		# the drive back ends in the car, in the garage
		spawn = GARAGE + Vector3(-0.42, 0.05, -3.9)
		spawn_yaw = 0.0
	step_db = -21.0
	card = LINES["card"]["fourth" if fourth else ("third" if third else ("second" if second else "first"))]
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
	_memories()
	if third:
		_garage()
	_family()
	# the eye off the sketchbook page, and its cage; the frames' flashlight
	eye_rig = Node3D.new()
	eye_rig.visible = false
	add_child(eye_rig)
	eye_sprite = Sprite3D.new()
	eye_sprite.texture = _glyph_tex
	eye_sprite.pixel_size = 0.0022
	eye_sprite.modulate = Color(1.0, 0.15, 0.1)
	eye_sprite.double_sided = true
	eye_rig.add_child(eye_sprite)
	cage = Node3D.new()
	cage.visible = false
	eye_rig.add_child(cage)
	var bar := glow(Color(0.9, 0.95, 1.0), 1.6)
	for i in 8:
		var a := i * TAU / 8.0
		box(Vector3(0.012, 0.42, 0.012), Vector3(cos(a) * 0.2, 0, sin(a) * 0.2), bar, false, cage)
	for y: float in [-0.21, 0.21]:
		var ring := TorusMesh.new()
		ring.inner_radius = 0.195
		ring.outer_radius = 0.21
		ring.rings = 24
		ring.ring_segments = 6
		mesh(ring, Vector3(0, y, 0), bar, cage)
	torch = OmniLight3D.new()
	torch.light_color = Color(0.85, 0.9, 1.0)
	torch.light_energy = 0.0
	torch.omni_range = 7.0
	torch.visible = false
	add_child(torch)
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
	_env = env
	if third:
		# 22:00: the sunset is long gone; the city lights the sky from below
		_sky.sky_horizon_color = Color(0.14, 0.07, 0.1)
		_sky.ground_horizon_color = Color(0.1, 0.05, 0.08)
		_sky.sky_top_color = Color(0.01, 0.01, 0.03)
		env.ambient_light_color = Color(0.18, 0.17, 0.26)
		env.ambient_light_energy = 0.22
	env.fog_light_color = Color(0.12, 0.07, 0.09)
	env.fog_density = 0.0012
	env.fog_sky_affect = 0.25
	env.glow_hdr_threshold = 0.95
	sun.light_color = Color(1.0, 0.5, 0.25) if not third else Color(0.45, 0.5, 0.8)
	sun.light_energy = 0.32 if not second else 0.22
	if third:
		sun.light_energy = 0.07
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
	mira_door.rotation.y = -0.85 if (second or fourth) else -1.85   # open before bed; ajar, "a sliver of dim light", "a sliver of dim light"
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
	lion_node = Node3D.new()
	add_child(lion_node)
	sphere(0.09, lp, lion, 10, lion_node).scale = Vector3(1.0, 0.8, 1.3)
	sphere(0.07, lp + Vector3(0, 0.08, -0.1), lion, 10, lion_node)
	sphere(0.095, lp + Vector3(0, 0.08, -0.08), mane, 10, lion_node).scale = Vector3(1.0, 1.0, 0.5)
	for x: float in [-0.03, 0.03]:
		box(Vector3(0.012, 0.012, 0.005), lp + Vector3(x, 0.1, -0.17), mat(Color(0.02, 0.02, 0.02), 0.2), false, lion_node)
	interactable("mira_bed", "Mira's bed", bp + Vector3(0, 0.6, 0), Vector3(1.1, 0.5, 1.9), "", false)
	# the moon nightlight on the east wall, amber. "In case something looks at me."
	var np := Vector3(11.42, 0.9, -10.2)
	sphere(0.09, np, glow(Color(1.0, 0.62, 0.25), 1.6, true), 12)
	sphere(0.085, np + Vector3(-0.015, 0.04, 0.06), mat(Color(0.86, 0.85, 0.82), 0.6), 12)
	night_light = light(np + Vector3(-0.3, -0.1, 0), Color(1.0, 0.6, 0.3), 1.3 if (second or third) else 0.7, 6.5, false)
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
	if third:
		# the drawer under her desk, and what is in it
		box(Vector3(0.42, 0.08, 0.3), Vector3(7.8, 0.64, -8.3), desk)
		box(Vector3(0.1, 0.01, 0.01), Vector3(7.8, 0.64, -8.14), mat(Color(0.3, 0.3, 0.32), 0.4, 0.5))
		interactable("sketchbook", "The drawer under her desk", Vector3(7.8, 0.6, -8.3), Vector3(0.5, 0.3, 0.5),
			"AI MARBLE SKETCHPAD\nPsyonic Education\npages: 31  -  last edit: Day 2", false)
	if not second and not third and not fourth:
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
		if not second:
			# from Day 3: the circle, the tablet or its absence, the shards
			tablet.visible = main.flags.has("mira_keeps_tower")
			shards.visible = main.flags.has("tablet_smashed")
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
	ezra_lights.append(light(Vector3(11.0, 1.5, -3.2), Color(0.3, 0.9, 0.75), 0.55, 4.0))
	var robot := mat(Color(0.85, 0.3, 0.2), 0.5, 0.3)
	box(Vector3(0.14, 0.18, 0.1), Vector3(8.0, 0.09, -4.4), robot)
	box(Vector3(0.1, 0.1, 0.1), Vector3(8.0, 0.23, -4.4), robot)
	box(Vector3(0.06, 0.01, 0.01), Vector3(8.0, 0.24, -4.455), glow(Color(0.3, 1.0, 0.9), 1.5))
	box(Vector3(0.3, 0.03, 1.4), Vector3(7.72, 1.6, -3.0), mat(Color(0.92, 0.9, 0.86), 0.5))
	for i in 6:
		box(Vector3(0.05, 0.24, 0.03), Vector3(7.72, 1.74, -3.6 + i * 0.09), mat(Color(0.2, 0.25 + i * 0.08, 0.45), 0.8))
	ezra_lights.append(light(Vector3(9.5, H - 0.2, -3.4), Color(1.0, 0.9, 0.8), 0.5, 4.5))
	if fourth and not main.flags.has("ezra_home"):
		for l in ezra_lights:
			(l as OmniLight3D).light_energy = 0.0


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
	sun_light = light(Vector3(-6.8, 1.8, -4.0), Color(1.0, 0.6, 0.35), 0.0 if third else (0.55 if not second else 0.35), 8.0, false)


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
	_set_350()
	_set_alley()
	_set_mira_morning()
	if fourth:
		_set_autumn()


## An omni light only the cutscene camera's layer sees.
func _set_light(parent: Node, pos: Vector3, c: Color, e: float, r: float) -> OmniLight3D:
	var o := OmniLight3D.new()
	o.position = pos
	o.light_color = c
	o.light_energy = e
	o.omni_range = r
	o.light_cull_mask = 1 << 19
	parent.add_child(o)
	return o


## Bible A1-S3.5, Monica's night: the lift to 350 and the Council Chamber,
## "real redwood paneling accented with gold", "a long redwood table,
## surrounded by black leather chairs. The far wall, a massive screen".
func _set_350() -> void:
	var red := pbr("woodfloor", Vector3(1, 1, 1) / 1.0, true, Color(0.6, 0.3, 0.18))
	var gold := mat(Color(0.36, 0.28, 0.14), 0.5, 0.7)
	var black := mat(Color(0.05, 0.05, 0.06), 0.5)
	var leather := mat(Color(0.04, 0.04, 0.045), 0.45, 0.1)
	# the lift car
	lift350 = Node3D.new()
	lift350.position = Vector3(0, -60, 340)
	add_child(lift350)
	box(Vector3(2.4, 0.1, 2.4), Vector3(0, -0.05, 0), black, false, lift350)
	box(Vector3(2.4, 0.1, 2.4), Vector3(0, 2.65, 0), black, false, lift350)
	for s: Array in [[Vector3(0.06, 2.6, 2.4), Vector3(-1.2, 1.3, 0)], [Vector3(0.06, 2.6, 2.4), Vector3(1.2, 1.3, 0)], [Vector3(2.4, 2.6, 0.06), Vector3(0, 1.3, 1.2)]]:
		box(s[0], s[1], red, false, lift350)
	for x: float in [-0.6, 0.6]:
		box(Vector3(1.18, 2.2, 0.06), Vector3(x, 1.1, -1.2), gold, false, lift350)
		box(Vector3(0.02, 2.2, 0.07), Vector3(x * 1.6, 1.1, -1.2), black, false, lift350)
	box(Vector3(2.4, 0.4, 0.06), Vector3(0, 2.4, -1.2), red, false, lift350)
	for x: float in [-1.2, 0.0, 1.2]:
		box(Vector3(0.05, 2.6, 0.05), Vector3(x, 1.3, -1.17), gold, false, lift350)
	box(Vector3(0.9, 0.36, 0.03), Vector3(0, 2.38, -1.17), black, false, lift350)
	label("350", Vector3(0, 2.44, -1.15), 0.0, 0.0022, Color(0.3, 1.0, 0.6), lift350, false)
	label("COUNCIL CHAMBER", Vector3(0, 2.26, -1.15), 0.0, 0.0006, Color(0.85, 0.7, 0.35), lift350, false)
	box(Vector3(0.9, 0.01, 0.03), Vector3(0, 2.57, -1.15), glow(Color(0.3, 1.0, 0.6), 1.5), false, lift350)
	for x: float in [-0.9, 0.9]:
		box(Vector3(0.3, 0.02, 0.3), Vector3(x, 2.6, 0.2), glow(Color(1.0, 0.85, 0.6), 1.2), false, lift350)
	_set_light(lift350, Vector3(0, 2.3, 0.4), Color(1.0, 0.85, 0.6), 0.7, 5.0)
	_set_light(lift350, Vector3(0, 2.3, -0.9), Color(0.4, 1.0, 0.6), 0.5, 2.0)
	_batch(lift350, 20.0)
	_set_layer(lift350, 1 << 19)
	# the Council Chamber
	boardroom = Node3D.new()
	boardroom.position = Vector3(0, -60, 380)
	add_child(boardroom)
	floor_quad(Vector2(14, 18), Vector3.ZERO, 0.0, pbr("carpet", Vector3(1, 1, 1) / 1.5, true, Color(0.32, 0.12, 0.1)), boardroom)
	box(Vector3(14, 0.1, 18), Vector3(0, 4.0, 0), black, false, boardroom)
	quad(Vector2(14, 4), Vector3(0, 2, -9), 0.0, red, boardroom)
	quad(Vector2(18, 4), Vector3(-7, 2, 0), PI / 2.0, red, boardroom)
	quad(Vector2(18, 4), Vector3(7, 2, 0), -PI / 2.0, red, boardroom)
	for x: float in [-7.0, 7.0]:
		for z: float in [-6.0, -2.0, 2.0, 6.0]:
			box(Vector3(0.12, 4.0, 0.12), Vector3(x - signf(x) * 0.07, 2.0, z), gold, false, boardroom)
	# the wall of corporate feeds
	var feeds := [Color(0.2, 0.45, 0.9), Color(0.9, 0.3, 0.2), Color(0.3, 0.85, 0.6), Color(0.85, 0.75, 0.3), Color(0.6, 0.3, 0.8),
		Color(0.25, 0.6, 0.9), Color(0.9, 0.9, 0.85), Color(0.9, 0.35, 0.25), Color(0.3, 0.75, 0.8), Color(0.8, 0.5, 0.2),
		Color(0.9, 0.3, 0.2), Color(0.35, 0.4, 0.9), Color(0.85, 0.8, 0.7), Color(0.3, 0.8, 0.5), Color(0.9, 0.4, 0.3)]
	for i in 15:
		var x := -5.2 + (i % 5) * 2.6
		var y := 0.95 + (i / 5) * 1.25
		quad(Vector2(2.4, 1.1), Vector3(x, y, -8.9), 0.0, glow(feeds[i] * 0.55, 1.2), boardroom)
	label("DUFREDY", Vector3(0, 2.2, -8.85), 0.0, 0.0028, Color(1.0, 0.25, 0.2), boardroom, false)
	label("TOKZ  -  LIVE", Vector3(-5.2, 3.6, -8.85), 0.0, 0.0012, Color(1, 1, 1), boardroom, false)
	label("PSYONIC  -  INTERNAL", Vector3(5.2, 3.6, -8.85), 0.0, 0.0012, Color(0.3, 1.0, 0.6), boardroom, false)
	# the table and chairs
	box(Vector3(2.4, 0.08, 10.0), Vector3(0, 0.76, -1.5), red, false, boardroom)
	for z: float in [-5.8, -1.5, 2.8]:
		box(Vector3(2.0, 0.72, 0.16), Vector3(0, 0.36, z), red, false, boardroom)
	for x: float in [-1.75, 1.75]:
		for z: float in [-5.0, -3.6, -2.2, -0.8, 0.6, 2.0]:
			box(Vector3(0.6, 0.5, 0.6), Vector3(x, 0.25, z), leather, false, boardroom)
			box(Vector3(0.6, 0.9, 0.1), Vector3(x + signf(x) * 0.3, 0.75, z), leather, false, boardroom)
	# Douglas Voremon, standing at the head of the table; two of the board seated
	var vore := figure(Color(0.12, 0.12, 0.15), Color(0.86, 0.7, 0.6), {"hair": Color(0.8, 0.8, 0.8), "long_coat": true, "arms": true})
	vore.position = Vector3(0, 0, -7.2)
	boardroom.add_child(vore)
	turn_to(vore, boardroom.position + Vector3(0, 0, 3.0))
	for a in vore.get_meta("arms"):
		(a as Node3D).rotation.x = 0.9
	for s: Array in [[-1.75, -5.0, Color(0.2, 0.2, 0.25)], [1.75, -6.2, Color(0.3, 0.25, 0.25)]]:
		var b := figure(s[2], Color(0.8, 0.68, 0.58), {"long_coat": false, "knees": true})
		b.position = Vector3(s[0], 0.0, s[1])
		boardroom.add_child(b)
		turn_to(b, boardroom.position + Vector3(0, 0, s[1]))
		_seat(b, b.position, b.rotation.y)
	_set_light(boardroom, Vector3(0, 3.6, -2.5), Color(1.0, 0.8, 0.5), 2.4, 12.0)
	_set_light(boardroom, Vector3(0, 3.6, 2.0), Color(1.0, 0.8, 0.5), 1.4, 9.0)
	_set_light(boardroom, Vector3(0, 2.2, -7.5), Color(0.5, 0.6, 1.0), 1.2, 7.0)
	_batch(boardroom, 20.0)
	_set_layer(boardroom, 1 << 19)


## The fabricated alley video on Monica's frames: Dufredy, the masked figure,
## blue smoke. "Masked Cognizo operative manipulates vulnerable senior."
func _set_alley() -> void:
	alley = Node3D.new()
	alley.position = Vector3(0, -60, 420)
	add_child(alley)
	var wet := pbr("asphalt", Vector3(1, 1, 1) / 2.0, true, Color(0.5, 0.5, 0.55), 0.35)
	var brick := pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.35, 0.3, 0.3))
	floor_quad(Vector2(5, 24), Vector3(0, 0, -6), 0.0, wet, alley)
	quad(Vector2(24, 9), Vector3(-2.4, 4.5, -6), PI / 2.0, brick, alley)
	quad(Vector2(24, 9), Vector3(2.4, 4.5, -6), -PI / 2.0, brick, alley)
	quad(Vector2(5, 9), Vector3(0, 4.5, -18), 0.0, brick, alley)
	box(Vector3(1.4, 1.1, 0.9), Vector3(1.8, 0.55, -7.5), mat(Color(0.15, 0.25, 0.2), 0.7, 0.3), false, alley)
	for z: float in [-3.0, -9.0, -15.0]:
		box(Vector3(0.1, 0.1, 4.0), Vector3(-2.3, 3.2, z), mat(Color(0.2, 0.2, 0.22), 0.5, 0.6), false, alley)
	# Dufredy in his coat, the masked figure's hand on his shoulder
	var duf := figure(Color(0.4, 0.36, 0.3), Color(0.82, 0.7, 0.6), {"hair": Color(0.85, 0.85, 0.82), "long_coat": true, "arms": true})
	duf.position = Vector3(0.45, 0, -4.2)
	alley.add_child(duf)
	turn_to(duf, alley.position + Vector3(-0.6, 0, -5.4))
	(duf.get_meta("head") as Node3D).rotation.x = 0.25
	var mask := figure(Color(0.06, 0.06, 0.07), Color(0.08, 0.08, 0.1), {"hair": Color(0.05, 0.05, 0.06), "long_coat": true, "arms": true})
	mask.position = Vector3(-0.6, 0, -5.4)
	alley.add_child(mask)
	turn_to(mask, duf.global_position)
	for a in mask.get_meta("arms"):
		(a as Node3D).rotation.x = 1.3
	# the blue smoke
	var smoke := StandardMaterial3D.new()
	smoke.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	smoke.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	smoke.albedo_color = Color(0.35, 0.55, 1.0, 0.28)
	for i in 9:
		var r := rng.randf_range(0.25, 0.7)
		sphere(r, Vector3(-0.3 + rng.randf_range(-0.9, 0.9), 0.5 + rng.randf_range(0.0, 1.6), -5.0 + rng.randf_range(-1.2, 0.8)), smoke, 10, alley)
	_set_light(alley, Vector3(-0.3, 1.6, -4.8), Color(0.35, 0.55, 1.0), 2.6, 7.0)
	_set_light(alley, Vector3(0, 5.0, -2.0), Color(0.9, 0.7, 0.5), 1.0, 9.0)
	# the frames' overlay
	label("REC   CAM 07   23:41:52", Vector3(-0.1, 2.9, -2.4), 0.0, 0.0011, Color(1.0, 0.3, 0.25), alley, false)
	_batch(alley, 20.0)
	_set_layer(alley, 1 << 19)


## Bible A1-S7.5, Mira's morning: her pillow with the lion from Red Rock, and
## her mother in the doorway "like a fairy godmother", a new tablet in hand.
func _set_mira_morning() -> void:
	pillow = Node3D.new()
	pillow.position = Vector3(0, -60, 460)
	add_child(pillow)
	var sheet := mat(Color(0.95, 0.95, 0.93), 0.9)
	box(Vector3(1.2, 0.1, 1.2), Vector3(0, -0.05, 0), sheet, false, pillow)
	box(Vector3(0.7, 0.14, 0.45), Vector3(-0.1, 0.07, -0.1), mat(Color(0.98, 0.98, 0.96), 0.9), false, pillow)
	box(Vector3(1.2, 0.1, 0.6), Vector3(0, 0.05, 0.5), pbr("fabric", Vector3(1, 1, 1) / 0.7, true, Color(0.85, 0.5, 0.7)), false, pillow)
	quad(Vector2(3, 2), Vector3(0, 1.0, -0.65), 0.0, _wall, pillow)
	var lion := mat(Color(0.85, 0.62, 0.25), 0.9)
	var mane := mat(Color(0.5, 0.3, 0.12), 0.9)
	var lp := Vector3(0.22, 0.22, -0.05)
	sphere(0.09, lp, lion, 10, pillow).scale = Vector3(1.0, 0.8, 1.3)
	sphere(0.07, lp + Vector3(0, 0.08, 0.1), lion, 10, pillow)
	sphere(0.095, lp + Vector3(0, 0.08, 0.08), mane, 10, pillow).scale = Vector3(1.0, 1.0, 0.5)
	for x: float in [-0.03, 0.03]:
		sphere(0.012, lp + Vector3(x, 0.1, 0.165), mat(Color(0.05, 0.04, 0.03), 0.4), 6, pillow)
	sphere(0.06, Vector3(-0.55, 0.45, -0.5), glow(Color(1.0, 0.8, 0.5), 1.4), 10, pillow)
	_set_light(pillow, Vector3(-0.5, 0.5, -0.4), Color(1.0, 0.75, 0.45), 1.3, 3.0)
	_set_light(pillow, Vector3(0.6, 1.2, 0.8), Color(0.6, 0.65, 0.8), 0.5, 4.0)
	_batch(pillow, 20.0)
	_set_layer(pillow, 1 << 19)
	# the doorway, seen from the bed
	doorway = Node3D.new()
	doorway.position = Vector3(0, -60, 500)
	add_child(doorway)
	floor_quad(Vector2(6, 8), Vector3(0, 0, 0), 0.0, pbr("carpet", Vector3(1, 1, 1) / 1.3, true, Color(0.85, 0.7, 0.75)), doorway)
	box(Vector3(2.2, H, 0.12), Vector3(-1.55, H / 2, -2.0), _wall, false, doorway)
	box(Vector3(2.2, H, 0.12), Vector3(1.55, H / 2, -2.0), _wall, false, doorway)
	box(Vector3(0.9, H - 2.1, 0.12), Vector3(0, 2.1 + (H - 2.1) / 2, -2.0), _wall, false, doorway)
	for x: float in [-0.5, 0.5]:
		box(Vector3(0.1, 2.15, 0.16), Vector3(x, 1.07, -2.0), _trim, false, doorway)
	quad(Vector2(6, H), Vector3(0, H / 2, -5.0), 0.0, mat(Color(0.8, 0.78, 0.75), 0.9), doorway)
	var mum := figure(Color(0.55, 0.18, 0.28), Color(0.86, 0.68, 0.56), {"hair": Color(0.06, 0.05, 0.05), "long_hair": true,
		"legs": Color(0.12, 0.12, 0.14), "arms": true, "long_coat": false})
	mum.position = Vector3(0, 0, -2.1)
	doorway.add_child(mum)
	turn_to(mum, doorway.position + Vector3(0.2, 0, 1.0))
	for a in mum.get_meta("arms"):
		(a as Node3D).rotation.x = 1.2
	(mum.get_meta("head") as Node3D).rotation.x = -0.2
	var tab := box(Vector3(0.3, 0.22, 0.012), Vector3(0.02, 1.1, -1.66), mat(Color(0.1, 0.1, 0.12), 0.4), false, doorway)
	tab.rotation.x = 0.35
	var scr := box(Vector3(0.27, 0.19, 0.008), Vector3(0.02, 1.105, -1.652), glow(Color(0.35, 0.8, 0.7), 3.0), false, doorway)
	scr.rotation.x = 0.35
	_set_light(doorway, Vector3(0, 2.2, -3.2), Color(1.0, 0.9, 0.75), 2.2, 6.0)
	_set_light(doorway, Vector3(0.02, 1.2, -1.45), Color(0.35, 0.8, 0.7), 1.1, 1.8)
	_set_light(doorway, Vector3(1.0, 0.6, 0.6), Color(1.0, 0.7, 0.45), 0.7, 4.0)
	_batch(doorway, 20.0)
	_set_layer(doorway, 1 << 19)
	# a black room to stand in while a cutscene plays: the UI draws its
	# pictures and text under the fade, so the fade can't be up. It sits at
	# ground level because Main puts anyone below y -4 back on the floor.
	blackroom = Node3D.new()
	blackroom.position = Vector3(0, 0, 540)
	add_child(blackroom)
	var ink := StandardMaterial3D.new()
	ink.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	ink.albedo_color = Color.BLACK
	ink.cull_mode = BaseMaterial3D.CULL_DISABLED
	box(Vector3(6, 5, 6), Vector3(0, 2.5, 0), ink, false, blackroom)
	solid_box(Vector3(6, 0.5, 6), Vector3(0, -0.25, 0), blackroom)


## Stand the player in the black room (and bring him back).
func _blackout(on: bool) -> void:
	var p = main.player
	if on:
		_saved = {"pos": p.position, "yaw": p.yaw, "pitch": p.pitch, "crouch": p.crouch, "seated": p.seated}
		p.position = blackroom.position + Vector3(0, 0.05, 0)
		p.pitch = 0.0
		p.crouch = 0.0
		p.seated = true
	elif not _saved.is_empty():
		p.position = _saved["pos"]
		p.yaw = _saved["yaw"]
		p.rotation.y = p.yaw
		p.pitch = _saved["pitch"]
		p.crouch = _saved["crouch"]
		p.seated = _saved["seated"]
		_saved = {}


## A line typed into the chat window by someone who isn't Psyon or Carl.
func _typed(who: String, col: String, text: String, pitch := 1.0) -> void:
	var log: RichTextLabel = main.ui.laptop_log
	main.play("keys", -10.0, pitch)
	var start := log.get_total_character_count()
	log.append_text("[color=%s]%s:[/color] %s\n\n" % [col, who, text])
	log.visible_characters = start
	var tw := create_tween()
	tw.tween_property(log, "visible_characters", log.get_total_character_count(), maxf(0.4, text.length() * 0.04))
	await tw.finished
	log.visible_characters = -1


## Bible A1-S3.5: Monica's night on 350, four panels from her side. The lift
## and its richer chime, the table and Voremon, her frames with the alley
## video, the dark screen and Eren. Carl sleeps through all of it.
func _council_cutscene() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	await ui.show_card(L("council350", "card"), 2.4)
	main.play("ding", -8.0, 0.8)
	var img1: Texture2D = await _picture(lift350.global_position + Vector3(0, 1.5, 0.9), lift350.global_position + Vector3(0, 2.1, -1.2), 56.0)
	ui.show_picture(img1, L("council350", "cap1"))
	await ui.say("", L("council350", "lift"))
	main.play("rain", -22.0, 0.6)
	var img2: Texture2D = await _picture(boardroom.global_position + Vector3(0.25, 1.4, -1.6), boardroom.global_position + Vector3(0, 1.45, -7.2), 54.0)
	ui.show_picture(img2, L("council350", "cap2"))
	await ui.say("", L("council350", "table"))
	await ui.say("Voremon", L("council350", "voremon"))
	var img3: Texture2D = await _picture(alley.global_position + Vector3(0, 1.6, 1.6), alley.global_position + Vector3(-0.2, 1.1, -4.8), 62.0)
	ui.show_picture(img3, L("council350", "cap3"))
	await ui.say("", L("council350", "footage"))
	ui.hide_picture()
	ui.close()
	# the dark screen: Eren is text, and a low, slow typing
	ui.laptop_open(true)
	ui.smear.visible = false
	ui.laptop_log.append_text("[color=#556]%s[/color]\n\n" % L("council350", "header"))
	await get_tree().create_timer(1.0).timeout
	await _typed("Eren", "#c8a0e0", L("council350", "eren1"), 0.55)
	await get_tree().create_timer(0.8).timeout
	await _typed("Eren", "#c8a0e0", L("council350", "eren2"), 0.55)
	await get_tree().create_timer(1.6).timeout
	ui.laptop_open(false)
	f["monica_council_seen"] = true


## Bible A1-S7.5: Mira's morning, three panels from her pillow. The lion,
## the rooms of her Tower, her mother in the doorway with a new tablet.
func _mira_morning() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	await ui.show_card(L("mira_morning", "card"), 2.4)
	var img1: Texture2D = await _picture(pillow.global_position + Vector3(0.0, 0.42, 0.6), pillow.global_position + Vector3(0.2, 0.26, -0.05), 46.0)
	ui.show_picture(img1, L("mira_morning", "cap1"))
	await ui.say("", L("mira_morning", "lion"))
	var img2: Texture2D = await _picture(council.global_position + Vector3(2.2, 2.6, 2.8), council.global_position + Vector3(0, 1.0, -0.5), 70.0)
	ui.show_picture(img2, L("mira_morning", "cap2"))
	await ui.say("", L("mira_morning", "rooms"))
	await ui.say("", L("mira_morning", "silence"))
	main.play("door", -16.0, 1.1)
	var img3: Texture2D = await _picture(doorway.global_position + Vector3(0.35, 0.55, 0.7), doorway.global_position + Vector3(0, 1.25, -2.1), 68.0)
	ui.show_picture(img3, L("mira_morning", "cap3"))
	await ui.say("", L("mira_morning", "mother"))
	await ui.say("Monica", L("mira_morning", "monica1"))
	await ui.say("Monica", L("mira_morning", "monica2"))
	ui.hide_picture()
	ui.close()
	f["mira_new_tablet"] = true


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
func _picture(from: Vector3, at: Vector3, fov := 62.0) -> Texture2D:
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
	if third or fourth:
		# the kids are at the observation site. Ezra is home on Day 6 only if the flags say so
		_hide(mira)
		if not (fourth and main.flags.has("ezra_home")):
			_hide(ezra)
	if fourth:
		# packing a small bag on the table, humming
		monica.position = TABLE + Vector3(-0.2, 0, 1.25)
		monica.rotation.y = 0.0
		for a in monica.get_meta("arms"):
			(a as Node3D).rotation.x = 1.0
		monica.set_meta("packing", true)
		monica_bag = Node3D.new()
		monica_bag.position = TABLE + Vector3(-0.2, 0.78, 0.35)
		add_child(monica_bag)
		box(Vector3(0.5, 0.28, 0.26), Vector3.ZERO, mat(Color(0.14, 0.13, 0.15), 0.8), false, monica_bag)
		box(Vector3(0.3, 0.03, 0.03), Vector3(0, 0.16, 0), mat(Color(0.1, 0.1, 0.1), 0.6), false, monica_bag)
		box(Vector3(0.22, 0.04, 0.2), Vector3(0.36, -0.12, 0.05), mat(Color(0.55, 0.18, 0.28), 0.9), false, monica_bag)
	elif second:
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
	# the frames' flashlight, in the dark
	if _blacked and torch:
		var cam: Node3D = main.player.cam
		torch.global_position = cam.global_position - cam.global_transform.basis.z * 0.4
	# Monica hums the lullaby while she packs
	if fourth and monica.visible and monica.has_meta("packing"):
		_hum_t -= delta
		if _hum_t <= 0.0:
			_hum_t = rng.randf_range(4.0, 7.0)
			main.play("hum", -20.0, rng.randf_range(1.6, 2.1))
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
	if third and not f.has("drive3_done"):
		return o["drive"]
	if not f.has("home_in"):
		return o["badge"]
	if third:
		if f.has("home3_done"):
			return ""
		if f.has("home_monica3"):
			return o["mira3"]
		return o["monica3"]
	if fourth:
		if f.has("home4_done"):
			return ""
		if f.has("monica_choice_done"):
			return o["sleep4"]
		return o["monica4"]
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
	if third:
		await _drive()
		return
	await get_tree().create_timer(0.5).timeout
	main.play("ding", -10.0, 1.2)
	await _play("lift", "fourth" if fourth else ("second" if second else "first"))
	ui.close()


## Badge on the door, in, and the evening starts.
func _enter() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	if f.has("home_in"):
		await ui.think(L("examine", "exit2" if (second or third) else "exit1"))
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
	if fourth:
		await _intro_fourth()
	elif third:
		await _intro_third()
	elif second:
		await _intro_second()
	else:
		await _intro_first()


func scan_people() -> Array:
	var out := []
	var sc: Dictionary = LINES["scan"]
	if monica.visible:
		out.append([monica, sc["monica4"] if fourth else sc["monica"]])
	if lynx and lynx.visible:
		out.append([lynx, "LYNX (ANALYST, PSYONIC)\nORA gen 6\nsync: 71%  -  AWAKE"])
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
	var t: String = ph["home4" if fourth else ("home3" if third else ("home2" if second else "home1"))]
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
			if fourth:
				await _monica_fourth()
			elif third:
				await _monica_third()
			elif second:
				await _monica_second()
			else:
				await _monica_first()
		"lynx", "garage_lift":
			await ui.think(ex[id])
		"fridge_drawing", "photo", "trophy":
			var traded := {"fridge_drawing": "traded_drawing", "photo": "traded_photo", "trophy": "traded_trophy"}
			await ui.think(ex["traded"] if f.has(traded[id]) else ex[id])
		"mira_bed":
			await ui.think(ex["traded"] if f.has("traded_lion") else ex["mira_bed"])
		"sketchbook":
			await _sketchbook()
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
			if fourth:
				await _play("home4", "ezra")
			elif second:
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
			elif fourth:
				await ui.think(ex["mira_door4"])
			elif third:
				await ui.think(ex["mira_door3"])
			elif second:
				await ui.think(ex["mira_door2"])
			else:
				await ui.think(ex["mira_door1"])
		"nightlight":
			await ui.think(ex["nightlight"])
			if second:
				main.add_connection(1.0, L("toast", "nightlight"))
		"tablet":
			if second and f.has("ritual_in_room") and not _ended:
				await _take_tablet()
			elif not second:
				await ui.think(ex["tablet3"])
		"circle":
			await ui.think(ex["circle3" if not second else "circle"])
		"ezra_door", "ezra_bed":
			await ui.think(ex["ezra_dark"] if (fourth and not f.has("ezra_home")) else ex["ezra_bed"])
		"bedroom_door":
			await ui.think(ex["bedroom2" if second else "bedroom1"])
		"front_door":
			await _enter()
		"couch":
			if fourth:
				if f.has("monica_choice_done") and not _ended:
					await _leaves_dream()
				else:
					await ui.think(L("home4", "packing") if not f.has("monica_choice_done") else L("home4", "gone"))
			elif third:
				await ui.think(ex["couch3"])
			else:
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
			main.add_trust("monica", 1)
		1:
			await ui.say("Carl", L("monica1", "ask1"))
			await ui.think(L("monica1", "her_eyes"))
			f["told_monica_fork"] = true
			f["suspects_monica"] = true
			main.add_trust("monica", -1)
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
	await _typed("Mira", "#e0a0d0", L("tower", "convene"), 1.3)
	main.learn("convene")
	await get_tree().create_timer(0.5).timeout
	await ui.laptop_line(L("tower", "greets"))
	await _typed("Mira", "#e0a0d0", L("tower", "yes"), 1.3)
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
	await _typed("Carl", "#9fb4c8", LINES["tower"]["typed"][q], 1.0)
	await get_tree().create_timer(0.8).timeout
	# three answers to the one question, one from each of the resolved figures
	for i in 3:
		await _typed(LINES["tower"]["council"][i], "#7fe6b0", LINES["tower"]["replies"][q][i], 0.8)
		await get_tree().create_timer(0.3).timeout
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
			main.add_trust("mira", 1)
		2:
			await _play("tower", "not_that")
			main.add_trust("mira", -1)
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
			await _play("gate", "where")
			f["asked_mira_phone"] = true
			main.add_trust("mira", 1)
		2:
			await ui.think(L("gate", "silence"))
	ui.close()
	await _arrived(ezra)
	_hide(ezra)
	ezra_vr.visible = true
	_walk(mira, [Vector3(4.2, 0, -6.5), Vector3(9.5, 0, -6.5), Vector3(9.5, 0, -8.6)], 0.85)
	await ui.think(L("gate", "spreading"))
	ui.close()
	ui.show_toast(L("toast", "gate"), 4.0)
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
	_blackout(true)
	await ui.fade_to(0.0, 0.05)
	await get_tree().create_timer(0.8).timeout
	# dream 1: the woods near his parents' house. No choice on Day 1.
	var img: Texture2D = await _picture(woods.global_position + Vector3(1.6, 1.3, 1.2), woods.global_position + Vector3(0, 0.75, -3.0))
	main.play("whisper", -8.0, 0.6)
	ui.show_picture(img, L("sleep", "caption"))
	await _play("sleep", "dream")
	ui.hide_picture()
	ui.close()
	main.log_line("dream", L("toast", "dream"))
	await get_tree().create_timer(0.6).timeout
	# A1-S3.5: what Monica saw on 350 while he slept
	await _council_cutscene()
	await get_tree().create_timer(0.4).timeout
	await _play("sleep", "morning")
	ui.close()
	await ui.show_card(L("sleep", "day2"), 2.6)
	f.erase("cinematic")
	f["home1_done"] = true
	await ui.fade_to(1.0, 0.5)
	_blackout(false)
	if not main._selftest:
		main.load_level("WarRoom")
	else:
		await ui.fade_to(0.0, 0.3)


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
		main.add_trust("monica", 1)
	else:
		await _play("monica2", "vague")
		main.add_trust("monica", -1)
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
		main.add_connection(1.0, L("toast", "watched"))
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
	match pick:
		0:
			# Smash: T:mira -2, the evidence lost, S:investigator
			await get_tree().create_timer(0.5).timeout
			main.play("slam", 0.0, 1.1)
			main.play("snap", -2.0, 0.7)
			p.shake(0.6)
			shards.visible = true
			await _play("tablet", "smash")
			f["tablet_smashed"] = true
			main.add_trust("mira", -2)
			main.add_stance("investigator")
			ui.show_toast(L("toast", "smashed"), 4.0)
		1:
			# Pocket it: T:mira -1, E:mira_tablet
			await ui.think(L("tablet", "pocket"))
			f["tablet_kept"] = true
			f["tablet_taken"] = true
			f["ev_mira_tablet"] = true
			main.add_trust("mira", -1)
			main.log_line("evidence", L("toast", "kept"))
		2:
			# Put it down and hold her: T:mira +1, nothing bagged, S:company_man;
			# Mira keeps the Tower
			tablet.visible = true
			await _play("tablet", "hold")
			f["mira_keeps_tower"] = true
			main.add_trust("mira", 1)
			main.add_stance("company_man")
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
	await fall.finished
	p.shake(0.5)
	main.play("slam", -4.0, 0.6)
	# the faint: one panel, the floor rushing up
	_blackout(true)
	await ui.show_card(L("tablet", "floor"), 1.8)
	main.log_line("seen", L("toast", "ritual_log"))
	await get_tree().create_timer(0.8).timeout
	# the morning after, Day 3
	await _play("morning", "woke")
	if f.has("tablet_smashed"):
		await ui.say("Monica", L("morning", "device_smashed"))
	elif f.has("tablet_taken"):
		await ui.say("Monica", L("morning", "device_taken"))
	await _play("morning", "train")
	ui.close()
	if f.has("tablet_smashed") or f.has("tablet_taken"):
		await _mira_morning()
	await ui.show_card(L("sleep", "day3"), 2.6)
	f.erase("cinematic")
	f["ritual_seen"] = true
	f["home2_done"] = true
	await ui.fade_to(1.0, 0.5)
	_blackout(false)
	if not main._selftest:
		main.load_level("WarRoom")
	else:
		await ui.fade_to(0.0, 0.3)


# ------------------------------------------------------------------ Act 2: the garage, the memories, the sets

## The tower garage, P2, where the drive back ends (A2-S3). Carl's company
## car facing the residents' lift; Lynx in the passenger seat until she
## isn't. Far east of everything else, at ground level.
func _garage() -> void:
	garage = Node3D.new()
	garage.position = GARAGE
	add_child(garage)
	var conc := pbr("concrete", Vector3(1, 1, 1) / 2.5, true, Color(0.55, 0.55, 0.56))
	var dark := mat(Color(0.2, 0.2, 0.22), 0.8)
	var steel := mat(Color(0.5, 0.52, 0.55), 0.4, 0.7)
	floor_quad(Vector2(44, 30), Vector3(0, 0, 0), 0.0, pbr("asphalt", Vector3(1, 1, 1) / 2.5, true, Color(0.6, 0.6, 0.62), 0.6), garage)
	solid_box(Vector3(44, 1, 30), Vector3(0, -0.5, 0), garage)
	box(Vector3(44, 0.3, 30), Vector3(0, 2.85, 0), dark, false, garage)
	box(Vector3(44, 2.7, 0.3), Vector3(0, 1.35, -15), conc, true, garage)
	box(Vector3(44, 2.7, 0.3), Vector3(0, 1.35, 15), conc, true, garage)
	box(Vector3(0.3, 2.7, 30), Vector3(-22, 1.35, 0), conc, true, garage)
	box(Vector3(0.3, 2.7, 30), Vector3(22, 1.35, 0), conc, true, garage)
	for x: float in [-16.0, -8.0, 8.0, 16.0]:
		for z: float in [-8.0, 0.0, 8.0]:
			box(Vector3(0.6, 2.7, 0.6), Vector3(x, 1.35, z), conc, true, garage)
	for x: float in [-14.0, -6.0, 2.0, 10.0]:
		for z: float in [-10.0, -2.0, 6.0]:
			box(Vector3(2.6, 0.04, 0.14), Vector3(x + 2.0, 2.68, z), glow(Color(0.85, 0.9, 1.0), 0.9, true), false, garage)
			light(Vector3(x + 2.0, 2.4, z), Color(0.85, 0.9, 1.0), 0.45, 7.0)
	# bay lines, a few parked fleet cars, the exhaust fans
	var paint := mat(Color(0.9, 0.85, 0.3), 0.8)
	for x: float in [-13.0, -10.0, -7.0, 7.0, 10.0, 13.0]:
		box(Vector3(0.08, 0.005, 5.5), Vector3(x, 0.004, -9.5), paint, false, garage)
	for s: Array in [[-11.5, Color(0.75, 0.78, 0.8)], [-8.5, Color(0.2, 0.22, 0.25)], [8.5, Color(0.6, 0.15, 0.12)], [11.5, Color(0.75, 0.78, 0.8)]]:
		var c: Node3D = Car.build(self, s[1], {"plate": "VLT %d" % int(4400 + absf(s[0]) * 3)})
		c.position = Vector3(s[0], 0, -9.5)
		garage.add_child(c)
	for z: float in [-6.0, 6.0]:
		cyl(0.6, 0.6, 0.2, Vector3(21.7, 1.8, z), dark, 12, garage).rotation.z = PI / 2.0
	# the residents' lift on the north wall, a sign over it, a badge reader
	var lx := Vector3(0, 0, -14.8)
	box(Vector3(2.2, 2.4, 0.1), lx + Vector3(0, 1.2, 0), steel, false, garage)
	box(Vector3(0.04, 2.3, 0.12), lx + Vector3(0, 1.15, 0), dark, false, garage)
	box(Vector3(2.4, 0.12, 0.2), lx + Vector3(0, 2.45, 0.05), dark, false, garage)
	neon_text("RESIDENCE 45C   -   LIFT", lx + Vector3(0, 2.62, 0.08), 0.0, 0.09, Color(0.3, 0.9, 0.6), 1.5, garage)
	neon_text("P2", Vector3(-3.0, 2.3, -14.8), 0.0, 0.5, Color(0.9, 0.6, 0.2), 1.4, garage)
	box(Vector3(0.08, 0.12, 0.03), lx + Vector3(1.35, 1.3, 0.06), mat(Color(0.9, 0.9, 0.88), 0.3, 0.2), false, garage)
	box(Vector3(0.015, 0.015, 0.015), lx + Vector3(1.35, 1.32, 0.08), glow(Color(0.3, 0.9, 1.0), 2.0, true), false, garage)
	light(lx + Vector3(0, 2.3, 1.0), Color(0.4, 0.95, 0.7), 0.5, 4.0)
	interactable("garage_lift", "The residents' lift", lx + Vector3(0, 1.2, 0.1), Vector3(2.2, 2.4, 0.3), "", false, garage)
	# Carl's car: the inside of it, built round the driver's seat, nose to the lift
	car3 = Node3D.new()
	car3.position = Vector3(0, 0, -4.0)
	garage.add_child(car3)
	var trim := mat(Color(0.12, 0.12, 0.13), 0.6)
	var body := mat(Color(0.75, 0.78, 0.8), 0.25, 0.6)
	box(Vector3(1.9, 0.25, 1.8), Vector3(0, 0.75, -1.9), body, false, car3)
	box(Vector3(1.7, 0.22, 0.55), Vector3(0, 0.88, -0.75), trim, false, car3)
	box(Vector3(1.7, 0.06, 0.3), Vector3(0, 1.0, -0.62), mat(Color(0.18, 0.18, 0.2), 0.5), false, car3)
	var wheel := TorusMesh.new()
	wheel.inner_radius = 0.15
	wheel.outer_radius = 0.18
	wheel.rings = 20
	wheel.ring_segments = 6
	mesh(wheel, Vector3(-0.42, 0.98, -0.42), trim, car3).rotation.x = PI / 2.0 - 0.45
	box(Vector3(0.04, 0.04, 0.3), Vector3(-0.42, 0.93, -0.55), trim, false, car3)
	for x: float in [-0.82, 0.82]:
		stick(Vector3(x, 0.98, -0.95), Vector3(x, 1.8, -0.2), 0.035, trim, car3)
		stick(Vector3(x, 0.98, 0.85), Vector3(x, 1.8, 0.65), 0.04, trim, car3)
		box(Vector3(0.06, 0.06, 0.9), Vector3(x, 1.8, 0.22), trim, false, car3)
		box(Vector3(0.08, 0.5, 2.0), Vector3(x * 1.02, 0.7, 0.0), mat(Color(0.2, 0.2, 0.22), 0.7), false, car3)
	box(Vector3(1.7, 0.05, 0.9), Vector3(0, 1.82, 0.22), mat(Color(0.25, 0.25, 0.26), 0.9), false, car3)
	box(Vector3(1.7, 0.6, 0.1), Vector3(0, 1.0, 1.0), trim, false, car3)
	for x: float in [-0.42, 0.42]:
		box(Vector3(0.55, 0.12, 0.55), Vector3(x, 0.42, 0.1), trim, false, car3)
		box(Vector3(0.55, 0.7, 0.12), Vector3(x, 0.8, 0.4), trim, false, car3)
	var scr := quad(Vector2(0.3, 0.17), Vector3(0.12, 1.06, -0.6), 0.0, newglow(Color(0.25, 0.55, 0.5), 1.0), car3)
	scr.rotation.x = -0.5
	var dl := label(L("drive", "dash"), Vector3(0.12, 1.06, -0.592), 0.0, 0.00045, Color(0.05, 0.08, 0.08), car3, false)
	dl.rotation.x = -0.5
	dl.font_size = 48
	box(Vector3(0.02, 0.02, 0.01), Vector3(-0.05, 1.04, -0.6), glow(Color(1, 0.1, 0.1), 3.0), false, car3).rotation.x = -0.5
	# Lynx in the passenger seat, arms folded, looking at the lift and not at him
	lynx = figure(Color(0.09, 0.08, 0.1), Color(0.88, 0.74, 0.62),
		{"hair": Color(0.12, 0.08, 0.06), "long_hair": true, "legs": Color(0.1, 0.1, 0.12), "arms": true, "knees": true, "visor": true, "long_coat": true})
	add_child(lynx)
	_seat(lynx, GARAGE + Vector3(0.42, 0, -3.9), 0.0)
	for a in lynx.get_meta("arms"):
		(a as Node3D).rotation.x = 1.3
		(a as Node3D).rotation.z = (-0.5 if (a as Node3D).position.x > 0.0 else 0.5)
	person("lynx", "Lynx", lynx, "LYNX (ANALYST, PSYONIC)\nORA gen 6\nsync: 71%  -  AWAKE")
	_batch(garage, 12.0, true)


## A figure out of a chair and onto its feet.
func _unseat(f: Node3D) -> void:
	if f.has_meta("seated"):
		f.remove_meta("seated")
	(f.get_meta("body") as Node3D).rotation.x = 0.0
	for l in f.get_meta("legs"):
		(l as Node3D).rotation.x = 0.0
	for k in f.get_meta("knees"):
		(k as Node3D).rotation.x = 0.0
	for a in f.get_meta("arms"):
		(a as Node3D).rotation.x = 0.0
		(a as Node3D).rotation.z = 0.0
	f.position.y = 0.0


## The four memories the fork can take in trade (bible, "The open city"):
## Mira's drawing on the fridge, the Red Rock photo, the toy lion, Ezra's
## recess trophy. Each is gone from the next visit when its flag is set,
## and leaves a clean rectangle in the dust.
func _memories() -> void:
	var f: Dictionary = main.flags
	# the fridge at the east end of the kitchen run, her Tower drawing on it
	var steel := mat(Color(0.82, 0.83, 0.85), 0.35, 0.6)
	box(Vector3(0.8, 1.9, 0.66), Vector3(1.3, 0.95, -8.7), steel, true)
	box(Vector3(0.03, 0.4, 0.03), Vector3(1.62, 1.3, -8.35), mat(Color(0.3, 0.3, 0.32), 0.4, 0.5))
	var marks := Node3D.new()
	add_child(marks)
	drawing = Node3D.new()
	add_child(drawing)
	var dq := quad(Vector2(0.21, 0.28), Vector3(1.22, 1.35, -8.36), 0.0, tex_mat(_sketch_page(0), Vector3.ONE, 0.9), drawing)
	(dq.material_override as StandardMaterial3D).cull_mode = BaseMaterial3D.CULL_DISABLED
	box(Vector3(0.025, 0.025, 0.012), Vector3(1.22, 1.5, -8.355), mat(Color(0.9, 0.2, 0.2), 0.5), false, drawing)
	var dmk := quad(Vector2(0.21, 0.28), Vector3(1.22, 1.35, -8.365), 0.0, mat(Color(0.9, 0.9, 0.92), 0.3, 0.6), marks)
	dmk.visible = false
	drawing.set_meta("mark", dmk)
	interactable("fridge_drawing", "Mira's drawing", Vector3(1.22, 1.35, -8.36), Vector3(0.3, 0.35, 0.1), "", false)
	# the Red Rock photo, printed and framed, on the side table by the couch
	var fp := Vector3(-4.2, 0.5, -3.3)
	photo = Node3D.new()
	add_child(photo)
	box(Vector3(0.24, 0.19, 0.02), fp, mat(Color(0.25, 0.2, 0.15), 0.6), false, photo).rotation.y = 0.5
	quad(Vector2(0.2, 0.15), fp + Vector3(0.006, 0, 0.011), 0.5, tex_mat(_photo_tex(), Vector3.ONE, 0.7), photo)
	var pm := floor_quad(Vector2(0.14, 0.1), Vector3(-4.2, 0.421, -3.3), 0.5, mat(Color(0.62, 0.5, 0.38), 0.6), marks)
	pm.visible = false
	photo.set_meta("mark", pm)
	interactable("photo", "The photo on the table", fp, Vector3(0.3, 0.25, 0.3), "", false)
	# Ezra's recess trophy on his shelf
	var gold := mat(Color(0.85, 0.7, 0.3), 0.35, 0.8)
	trophy = Node3D.new()
	trophy.position = Vector3(7.72, 1.62, -2.5)
	add_child(trophy)
	box(Vector3(0.12, 0.03, 0.12), Vector3(0, 0.015, 0), mat(Color(0.1, 0.1, 0.1), 0.5), false, trophy)
	cyl(0.012, 0.012, 0.08, Vector3(0, 0.07, 0), gold, 8, trophy)
	cyl(0.05, 0.025, 0.08, Vector3(0, 0.15, 0), gold, 10, trophy)
	for x: float in [-0.06, 0.06]:
		box(Vector3(0.02, 0.05, 0.01), Vector3(x, 0.15, 0), gold, false, trophy)
	var tm := floor_quad(Vector2(0.12, 0.12), Vector3(7.72, 1.621, -2.5), 0.0, mat(Color(0.96, 0.95, 0.92), 0.4), marks)
	tm.visible = false
	trophy.set_meta("mark", tm)
	interactable("trophy", "Ezra's trophy", Vector3(7.72, 1.7, -2.5), Vector3(0.25, 0.25, 0.25), "", false)
	# what has been traded away is gone; from the fourth visit a clean shape marks it
	var lm := floor_quad(Vector2(0.2, 0.3), Vector3(9.8, 0.621, -11.65), 0.0, mat(Color(0.99, 0.99, 0.97), 0.5), marks)
	lm.visible = false
	lion_node.set_meta("mark", lm)
	for pair: Array in [["traded_drawing", drawing], ["traded_photo", photo], ["traded_lion", lion_node], ["traded_trophy", trophy]]:
		if f.has(pair[0]):
			var n: Node3D = pair[1]
			n.visible = false
			if n.has_meta("mark"):
				(n.get_meta("mark") as Node3D).visible = fourth


## A page of Mira's sketchbook, in coloured pencil, AI-corrected. 0: the
## Tower, her council round a table with her in the middle. 1: the same,
## darker, her place a shadow. 2: the shadow has become the eye.
func _sketch_page(kind: int) -> ImageTexture:
	var n := 160
	var img := Image.create(n, n, false, Image.FORMAT_RGBA8)
	var r := RandomNumberGenerator.new()
	r.seed = 61 + kind
	var paper := 0.9 - kind * 0.12
	for y in n:
		for x in n:
			var v := paper + r.randf_range(-0.05, 0.04)
			img.set_pixel(x, y, Color(v, v * 0.98, v * 0.93, 1.0))
	var c := Vector2(n / 2.0, n / 2.0 + 10)
	var blob := func(p: Vector2, rad: float, col: Color) -> void:
		for yy in range(int(p.y - rad), int(p.y + rad) + 1):
			for xx in range(int(p.x - rad), int(p.x + rad) + 1):
				if xx >= 0 and yy >= 0 and xx < n and yy < n and Vector2(xx, yy).distance_to(p) <= rad + r.randf_range(-0.8, 0.8):
					img.set_pixelv(Vector2i(xx, yy), col)
	# the round table, brown, seen from above and a little in front
	var table := Color(0.5, 0.3, 0.15) if kind < 2 else Color(0.25, 0.18, 0.12)
	for i in 1400:
		var a := r.randf() * TAU
		var d := r.randf()
		var p := c + Vector2(cos(a) * 46.0 * sqrt(d), sin(a) * 22.0 * sqrt(d))
		img.set_pixelv(Vector2i(int(p.x), int(p.y)), table)
	# the council round it: the knight, the bear, the girl with pigtails, two more
	var cols := [Color(0.5, 0.55, 0.65), Color(0.45, 0.3, 0.15), Color(0.95, 0.8, 0.2), Color(0.3, 0.5, 0.35), Color(0.6, 0.35, 0.55)]
	for i in 5:
		var a := -PI * 0.15 - i * PI * 0.7 / 4.0 - PI * 0.25
		var p := c + Vector2(cos(a) * 54.0, sin(a) * 30.0 - 8.0)
		var col: Color = cols[i] if kind == 0 else cols[i].darkened(0.35 + kind * 0.15)
		blob.call(p + Vector2(0, 8), 7.0, col)
		blob.call(p, 5.0, Color(0.9, 0.75, 0.6) if kind == 0 else Color(0.55, 0.5, 0.45))
		if i == 2:
			for s: float in [-6.0, 6.0]:
				blob.call(p + Vector2(s, 2), 2.5, Color(0.95, 0.85, 0.3))
	# her, in the middle: curls and freckles. Then a shadow. Then the eye.
	var mp := c + Vector2(0, -6)
	if kind == 0:
		blob.call(mp + Vector2(0, 9), 8.0, Color(0.82, 0.6, 0.75))
		blob.call(mp, 6.0, Color(0.9, 0.75, 0.6))
		for i in 9:
			var a := i * TAU / 9.0
			blob.call(mp + Vector2(cos(a) * 6.5, sin(a) * 6.5 - 1.5), 2.6, Color(0.08, 0.06, 0.06))
		for i in 6:
			img.set_pixelv(Vector2i(int(mp.x + r.randf_range(-3, 3)), int(mp.y + r.randf_range(-1, 3))), Color(0.6, 0.35, 0.25))
	elif kind == 1:
		blob.call(mp + Vector2(0, 6), 11.0, Color(0.12, 0.1, 0.12))
		blob.call(mp, 7.0, Color(0.08, 0.07, 0.09))
	else:
		blob.call(mp + Vector2(0, 4), 13.0, Color(0.1, 0.06, 0.07))
		var red := Color(0.85, 0.08, 0.05, 1.0)
		for i in 300:
			var a := i * TAU / 300.0
			var p := mp + Vector2(cos(a) * 24.0, sin(a) * 13.0) + Vector2(r.randf_range(-1.0, 1.0), r.randf_range(-1.0, 1.0))
			img.set_pixelv(Vector2i(int(p.x), int(p.y)), red)
		var t := 0.0
		while t < 7.0 * TAU:
			var p := mp + Vector2(cos(t), sin(t)) * t * 0.28
			if p.x >= 0 and p.y >= 0 and p.x < n and p.y < n:
				img.set_pixelv(Vector2i(int(p.x), int(p.y)), red)
			t += 0.04
	# the caption in her hand, a wobbly line of pencil at the top
	for x in range(30, 130):
		if r.randf() < 0.6:
			img.set_pixelv(Vector2i(x, 18 + int(sin(x * 0.4) * 1.5)), Color(0.2, 0.2, 0.25))
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


## The one printed photo in the flat: Red Rock Plaza, the summer the kids
## were small, four small figures against the orange rock.
func _photo_tex() -> ImageTexture:
	var w := 160
	var h := 120
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	var r := RandomNumberGenerator.new()
	r.seed = 7
	for y in h:
		for x in w:
			var t := float(y) / h
			var col := Color(0.95, 0.75, 0.45).lerp(Color(0.55, 0.3, 0.2), t) if y < 70 else Color(0.8, 0.45, 0.25).lerp(Color(0.5, 0.28, 0.18), (y - 70) / 50.0)
			if y > 40 and y < 70 and absf(sin(x * 0.11) * 14.0 + 55.0 - y) < 3.0:
				col = Color(0.6, 0.3, 0.2)
			img.set_pixel(x, y, col + Color(r.randf_range(-0.03, 0.03), 0, 0, 0))
	for s: Array in [[52.0, 18.0, Color(0.55, 0.18, 0.28)], [70.0, 19.0, Color(0.2, 0.22, 0.26)], [88.0, 11.0, Color(0.82, 0.6, 0.75)], [102.0, 9.0, Color(0.2, 0.45, 0.32)]]:
		for yy in range(int(100 - s[1] * 2.0), 100):
			for xx in range(int(s[0] - 3), int(s[0] + 3)):
				img.set_pixelv(Vector2i(xx, yy), s[2])
		for yy in range(int(100 - s[1] * 2.0 - 5), int(100 - s[1] * 2.0)):
			for xx in range(int(s[0] - 2), int(s[0] + 2)):
				img.set_pixelv(Vector2i(xx, yy), Color(0.86, 0.68, 0.56))
	img.generate_mipmaps()
	return ImageTexture.create_from_image(img)


## The leaves (A2-B6's dream): the woods in autumn, gold and red, a pile of
## leaves with Monica and Mira in it, and a second Carl beside them who
## carries whatever was traded. Layer 20.
func _set_autumn() -> void:
	var f: Dictionary = main.flags
	autumn = Node3D.new()
	autumn.position = Vector3(0, -60, 580)
	add_child(autumn)
	floor_quad(Vector2(40, 40), Vector3.ZERO, 0.0, pbr("grass", Vector3(1, 1, 1) / 2.0, true, Color(0.55, 0.42, 0.22)), autumn)
	var bark := pbr("bark", Vector3(1, 1, 1) / 1.5, true)
	var leaves := [mat(Color(0.85, 0.55, 0.12), 0.9), mat(Color(0.75, 0.25, 0.1), 0.9), mat(Color(0.9, 0.7, 0.2), 0.9)]
	for p: Vector3 in [Vector3(-4, 0, -6), Vector3(4.5, 0, -7), Vector3(-6, 0, 1), Vector3(6, 0, 2), Vector3(0, 0, -11), Vector3(-2, 0, -15), Vector3(5, 0, -13), Vector3(-8, 0, -9)]:
		tree(p, rng.randf_range(5.0, 7.0), bark, leaves, autumn)
	# the pile, and leaves on the ground
	for i in 90:
		var a := rng.randf() * TAU
		var d := rng.randf()
		var lm: Material = leaves[i % 3]
		var s := sphere(rng.randf_range(0.14, 0.3), Vector3(cos(a) * 1.6 * d, 0.1 + (1.0 - d) * 0.5 + rng.randf_range(0, 0.15), -3.2 + sin(a) * 1.2 * d), lm, 6, autumn)
		s.scale = Vector3(1.0, 0.55, 1.0)
	for i in 80:
		var s := sphere(rng.randf_range(0.06, 0.12), Vector3(rng.randf_range(-8, 8), 0.02, rng.randf_range(-12, 3)), leaves[i % 3], 5, autumn)
		s.scale = Vector3(1.0, 0.3, 1.0)
	# Monica and Mira, half-sunk in it, laughing; the other Carl, standing
	var mon := figure(Color(0.55, 0.18, 0.28), Color(0.86, 0.68, 0.56), {"hair": Color(0.06, 0.05, 0.05), "long_hair": true, "legs": Color(0.12, 0.12, 0.14), "arms": true, "knees": true, "long_coat": false})
	mon.position = Vector3(-0.5, -0.25, -3.3)
	autumn.add_child(mon)
	turn_to(mon, autumn.position + Vector3(0.4, 0, 2.0))
	for a in mon.get_meta("arms"):
		(a as Node3D).rotation.x = 2.4
		(a as Node3D).rotation.z = (-0.6 if (a as Node3D).position.x > 0.0 else 0.6)
	(mon.get_meta("head") as Node3D).rotation.x = -0.3
	var mi := figure(Color(0.82, 0.6, 0.75), Color(0.86, 0.68, 0.56), {"hair": Color(0.06, 0.05, 0.05), "long_hair": true, "legs": Color(0.82, 0.6, 0.75), "arms": true, "knees": true, "scale": 0.62, "long_coat": false})
	mi.position = Vector3(0.45, -0.3, -3.0)
	autumn.add_child(mi)
	turn_to(mi, autumn.position + Vector3(0, 0, 2.0))
	for a in mi.get_meta("arms"):
		(a as Node3D).rotation.x = 2.6
	other_carl = figure(Color(0.2, 0.22, 0.27), Color(0.86, 0.7, 0.58), {"hair": Color(0.35, 0.22, 0.12), "arms": true, "knees": true, "long_coat": true})
	other_carl.position = Vector3(1.9, 0, -2.4)
	autumn.add_child(other_carl)
	turn_to(other_carl, autumn.position + Vector3(0.6, 0, -3.2))
	for a in other_carl.get_meta("arms"):
		(a as Node3D).rotation.x = 0.9
	# what he carries is what was traded
	var hand := Vector3(0.0, 0.95, -0.32)
	var traded := 0
	if f.has("traded_lion"):
		sphere(0.09, hand + Vector3(-0.1, 0, 0), mat(Color(0.85, 0.62, 0.25), 0.9), 8, other_carl).scale = Vector3(1.0, 0.8, 1.3)
		traded += 1
	if f.has("traded_photo"):
		box(Vector3(0.24, 0.19, 0.02), hand + Vector3(0.1, 0.05, 0), mat(Color(0.25, 0.2, 0.15), 0.6), false, other_carl)
		traded += 1
	if f.has("traded_drawing"):
		quad(Vector2(0.21, 0.28), hand + Vector3(0.0, 0.1, 0.02), 0.0, tex_mat(_sketch_page(0), Vector3.ONE, 0.9), other_carl)
		traded += 1
	if f.has("traded_trophy"):
		cyl(0.05, 0.025, 0.08, hand + Vector3(0.12, -0.02, 0), mat(Color(0.85, 0.7, 0.3), 0.35, 0.8), 8, other_carl)
		traded += 1
	other_carl.set_meta("carries", traded)
	_set_light(autumn, Vector3(2, 6, -2), Color(1.0, 0.85, 0.6), 2.2, 18.0)
	_set_light(autumn, Vector3(-3, 3, 0), Color(1.0, 0.6, 0.3), 1.2, 9.0)
	_batch(autumn, 20.0)
	_set_layer(autumn, 1 << 19)


# ------------------------------------------------------------------ visit 3 (A2-S3, ch. 15): the drive, the blackout

## The drive back from the hangar, in the garage. Lynx: "Well, Mimic, what
## do we do now?" The insurgency forms; she gets out at the lift.
func _drive() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	f["cinematic"] = true
	p.seated = true
	p.crouch = 0.45
	await get_tree().create_timer(0.8).timeout
	await _play("drive", "open")
	ui.close()
	await p.face(lynx.global_position + Vector3(0, 1.25, 0), 0.9)
	await ui.say("Lynx", L("drive", "mimic"))
	await _play("drive", "exchange")
	var pick: int = await ui.choose(LINES["drive"]["choices"])
	match pick:
		0:
			await _play("drive", "mirror")
			main.add_trust("lynx", 1)
		1:
			await _play("drive", "the_plan")
			main.add_trust("lynx", 1)
			main.add_stance("investigator")
		2:
			await ui.think(L("drive", "nothing"))
	await _play("drive", "spoons")
	ui.close()
	f["drive3_done"] = true
	if int(main.trust.get("lynx", 0)) >= 2:
		f["lynx_calls_day5"] = true
	# she gets out, and walks to the lift without looking back
	main.play("door", -10.0, 0.9)
	_unseat(lynx)
	lynx.position = GARAGE + Vector3(1.3, 0, -3.6)
	_walk(lynx, [GARAGE + Vector3(1.6, 0, -8.0), GARAGE + Vector3(0.3, 0, -13.9)], 1.2)
	await p.face(GARAGE + Vector3(0.3, 1.5, -13.9), 1.2)
	await ui.think(L("drive", "gone"))
	ui.close()
	await _arrived(lynx)
	main.play("ding", -14.0, 1.1)
	_hide(lynx)
	await ui.think(L("drive", "tower"))
	ui.close()
	await ui.fade_to(1.0, 1.2)
	p.crouch = 0.0
	p.seated = false
	p.position = Vector3(30.0, 0.05, 0.6)
	p.yaw = deg_to_rad(90.0)
	p.rotation.y = p.yaw
	p.pitch = 0.0
	f.erase("cinematic")
	main.update_hud()
	await ui.fade_to(0.0, 1.0)
	main.play("ding", -10.0, 1.2)
	await _play("lift", "third")
	ui.close()


func _intro_third() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	f["cinematic"] = true
	await ui.think(L("home3", "door"))
	await ui.say("Carl", L("home3", "im_home"))
	ui.close()
	await p.face(monica.global_position + Vector3(0, 1.55, 0), 0.8)
	f.erase("cinematic")
	await _monica_third()


## "Where the fuck have you been?" Marcus is dead; the belief-layer
## confrontation; the three hummed notes; "I think we're being watched."
func _monica_third() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	if f.has("home_monica3"):
		await ui.think(L("home3", "gone"))
		return
	f["home_monica3"] = true
	f["cinematic"] = true
	await ui.say("Monica", L("home3", "where"))
	await _play("home3", "retreat")
	await ui.say("Monica", L("home3", "furious" if f.has("tablet_smashed") else "furious_alt"))
	await _play("home3", "marcus")
	ui.close()
	var pick: int = await ui.choose(LINES["home3"]["choices"])
	match pick:
		0:
			await ui.say("Carl", L("home3", "tell_all"))
			f["told_monica_everything"] = true
		1:
			await ui.say("Carl", L("home3", "tell_cult"))
			f["told_monica_cult"] = true
		2:
			await ui.say("Carl", L("home3", "tell_rituals"))
			f["told_monica_rituals"] = true
	await _play("home3", "twig")
	if int(main.trust.get("monica", 0)) >= 1:
		await _play("home3", "admits")
		f["monica_knew_clue"] = true
		main.log_line("clue", L("toast", "monica_knew"))
	else:
		await _play("home3", "deflects")
		if pick == 0:
			await _play("home3", "eren_office")
		await ui.say("Monica", L("home3", "overreacting"))
	# the three notes, under her breath. The NICU song.
	main.play("hum", -14.0, 1.9)
	await ui.think(L("home3", "notes"))
	f["lullaby_monica"] = true
	main.learn(L("home3", "song_word"))
	await ui.say("Monica", L("home3", "path"))
	await ui.think(L("home3", "mouthed"))
	ui.glitch(0.3, 0.6)
	await ui.say("Monica", L("home3", "watched"))
	await ui.think(L("home3", "inside"))
	await _play("home3", "upstairs")
	ui.close()
	_walk(monica, [Vector3(-0.6, 0, -4.6), Vector3(-0.4, 0, -1.3), Vector3(0, 0, 0.6), Vector3(0, 0, 3.2), Vector3(5.2, 0, 3.6)], 1.2)
	await get_tree().create_timer(2.6).timeout
	_slide_door(true)
	await _arrived(monica)
	_slide_door(false)
	_hide(monica)
	await ui.think(L("home3", "never_leaves"))
	ui.close()
	# Lynx, on the frames
	main.play("ding", -12.0, 1.4)
	await _play("home3", "lynx_call")
	ui.close()
	f.erase("cinematic")
	main.update_hud()


## Mira's room, ransacked: the sketchbook in the drawer under her desk, the
## Tower drawn ten times, then a shadow, then the eye. The eye lifts off
## the page with the frames on. "Help." Then the power goes.
func _sketchbook() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	if _ended:
		return
	_ended = true
	f["cinematic"] = true
	await ui.think(L("sketch", "ransack"))
	await ui.think(L("sketch", "drawer"))
	ui.close()
	var pages := [_sketch_page(0), _sketch_page(1), _sketch_page(2)]
	ui.show_picture(pages[0], L("sketch", "cap0"))
	await ui.think(L("sketch", "early"))
	await ui.think(L("sketch", "tower"))
	ui.show_picture(pages[1], L("sketch", "cap1"))
	await ui.think(L("sketch", "darker"))
	main.play("whisper", -12.0, 0.5)
	ui.show_picture(pages[2], L("sketch", "cap2"))
	await ui.think(L("sketch", "shadow"))
	ui.hide_picture()
	ui.close()
	f["ev_mira_drawing"] = true
	main.log_line("evidence", L("toast", "drawing"))
	# the frames come on by themselves
	if not main.frames_on:
		main.toggle_frames()
	main.play("glitch", -4.0, 0.8)
	ui.glitch(0.6, 1.0)
	await ui.think(L("sketch", "buzzed"))
	ui.close()
	# the eye lifts off the page, spirals the room, stops in front of him, caged
	eye_rig.visible = true
	eye_rig.global_position = Vector3(8.1, 0.76, -8.6)
	_eye_cam = p.global_position + Vector3(0, 1.45, 0)
	var fwd: Vector3 = -p.global_transform.basis.z
	var stop: Vector3 = _eye_cam + fwd * 0.9
	var tw := create_tween()
	tw.tween_method(_eye_spiral, 0.0, 1.0, 3.2)
	await tw.finished
	var tw2 := create_tween()
	tw2.tween_property(eye_rig, "global_position", stop, 1.0).set_trans(Tween.TRANS_SINE)
	await tw2.finished
	eye_rig.look_at(_eye_cam, Vector3.UP)
	cage.visible = true
	main.play("sting", -8.0, 0.6)
	await ui.say("", L("sketch", "help"))
	main.add_connection(2.0, L("toast", "help"))
	ui.close()
	await get_tree().create_timer(0.6).timeout
	await _power_out()


## Every light in the flat, the hall, the garage and the city outside, off.
func _darken() -> void:
	set_power(false, 0.4)
	_blacked = true
	for n in find_children("*", "MeshInstance3D", true, false):
		var mi := n as MeshInstance3D
		if mi.layers == (1 << 19):
			continue
		var m := mi.material_override as StandardMaterial3D
		if m and m.emission_enabled:
			m.emission_energy_multiplier = 0.0
		if mi.mesh and mi.material_override == null:
			for i in mi.mesh.get_surface_count():
				var sm := mi.mesh.surface_get_material(i) as StandardMaterial3D
				if sm and sm.emission_enabled:
					sm.emission_energy_multiplier = 0.0
	for n in find_children("*", "Light3D", true, false):
		var l := n as Light3D
		if l.light_cull_mask == (1 << 19):
			continue
		l.light_energy = 0.0
	for n in find_children("*", "Label3D", true, false):
		(n as Label3D).modulate = Color(0.03, 0.03, 0.035)
	for n in find_children("*", "Sprite3D", true, false):
		if n != eye_sprite and not n.has_meta("candle"):
			(n as Sprite3D).visible = false
	if _sun:
		_sun.light_energy = 0.02
	if _env:
		_env.ambient_light_energy = 0.03
		_env.fog_light_color = Color(0.01, 0.01, 0.012)
	if _sky:
		_sky.sky_horizon_color = Color(0.02, 0.015, 0.02)
		_sky.ground_horizon_color = Color(0.015, 0.012, 0.015)
		_sky.sky_top_color = Color(0.004, 0.004, 0.01)
	# the candles, across the dark city
	var cm := StandardMaterial3D.new()
	cm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	cm.albedo_color = Color(1.0, 0.7, 0.35)
	for i in 90:
		var c := box(Vector3(0.5, 0.5, 0.5), Vector3(rng.randf_range(-220, 220), GROUND + rng.randf_range(2.0, 110.0), rng.randf_range(-220, 220)), cm)
		c.set_meta("candle", true)
	cage.visible = false
	eye_rig.visible = false
	torch.visible = true
	torch.light_energy = 0.9


## The power goes. Then the two panels: the tower dark, the city dark, candles.
func _power_out() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	main.play("outage", -4.0)
	_darken()
	await ui.think(L("sketch", "dark"))
	ui.close()
	var img1: Texture2D = await _picture(Vector3(-20.0, -140.0, 40.0), Vector3(-150.0, 20.0, -70.0), 70.0)
	ui.show_picture(img1, L("sketch", "cap_tower"))
	await ui.say("", L("sketch", "tower_dark"))
	var img2: Texture2D = await _picture(Vector3(-7.5, 1.2, -4.5), Vector3(-90.0, -180.0, -30.0), 74.0)
	ui.show_picture(img2, L("sketch", "cap_city"))
	await ui.say("", L("sketch", "city_dark"))
	ui.hide_picture()
	ui.close()
	await ui.think(L("sketch", "out"))
	ui.close()
	f["home3_done"] = true
	f.erase("cinematic")
	main.update_hud()
	if not main._selftest:
		main.load_level("Blackout")


# ------------------------------------------------------------------ visit 4 (A2-B6): Monica's choice, the leaves

func _intro_fourth() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	f["cinematic"] = true
	var gone := 0
	for k in ["traded_drawing", "traded_photo", "traded_lion", "traded_trophy"]:
		if f.has(k):
			gone += 1
	await ui.think(L("home4", "door" if gone > 0 else "door_whole"))
	ui.close()
	await p.face(monica.global_position + Vector3(0, 1.55, 0), 0.8)
	await ui.think(L("home4", "packing"))
	ui.close()
	f.erase("cinematic")
	main.update_hud()


## The last real conversation. Four exchanges; her lines read trust.
func _monica_fourth() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if f.has("monica_choice_done"):
		await ui.think(L("home4", "gone"))
		return
	f["cinematic"] = true
	var t := int(main.trust.get("monica", 0))
	# 1: the broadcast
	await ui.say("Monica", L("home4", "broadcast"))
	await ui.say("Monica", L("home4", "not_wrong" if t >= 1 else "pr_handling"))
	# 2: the belief layer
	await ui.say("Carl", L("home4", "ask_layer"))
	if t >= 1:
		await _play("home4", "whole_thing")
		f["monica_knew_claim"] = true
		main.log_line("claim", L("toast", "claim_complete"))
	else:
		await ui.say("Monica", L("home4", "denies"))
		var opts := []
		var keys := []
		if f.has("ev_second_tablet"):
			opts.append(L("home4", "present_tablet"))
			keys.append("tablet")
		if f.has("ev_mira_drawing"):
			opts.append(L("home4", "present_drawing"))
			keys.append("drawing")
		opts.append(L("home4", "let_go"))
		keys.append("none")
		var pick: int = await ui.choose(opts)
		if keys[pick] != "none":
			await ui.think(L("home4", "presented_" + keys[pick]))
			await _play("home4", "broken")
			main.add_trust("monica", -1)
			t -= 1
			f["monica_knew_claim"] = true
			main.log_line("claim", L("toast", "claim_complete"))
		else:
			await ui.think(L("home4", "let_it"))
	# 3: the song
	await ui.say("Carl", L("home4", "ask_song"))
	await ui.say("Monica", L("home4", "mother_sang"))
	if t >= 2:
		await ui.say("Monica", L("home4", "not_hers"))
		f["song_is_gods"] = true
		main.log_line("claim", L("toast", "song_claim"))
	# 4: her choice, and his
	await ui.think(L("home4", "zipped"))
	if t >= 2:
		await ui.say("Monica", L("home4", "keep_her"))
	elif t >= 0:
		await ui.say("Monica", L("home4", "dont_come"))
	else:
		await ui.think(L("home4", "said_nothing"))
	var reply: int = await ui.choose(LINES["home4"]["choices"])
	match reply:
		0:
			await ui.say("Carl", L("home4", "see_you"))
			main.add_stance("sleeper")
			main.add_trust("monica", 1)
			t += 1
		1:
			await ui.say("Carl", L("home4", "stop_it"))
			main.add_stance("investigator")
		2:
			await ui.say("Carl", L("home4", "report"))
			main.add_stance("company_man")
	await ui.think(L("home4", "kiss" if t >= 1 else "no_kiss"))
	ui.close()
	f["monica_choice_done"] = true
	# the bag, the door
	monica_bag.visible = false
	for a in monica.get_meta("arms"):
		(a as Node3D).rotation.x = 0.0
	monica.remove_meta("packing")
	_walk(monica, [Vector3(-0.6, 0, -4.6), Vector3(-0.4, 0, -1.3), Vector3(0, 0, 0.6), Vector3(0, 0, 3.2), Vector3(5.2, 0, 3.6)], 1.1)
	await get_tree().create_timer(2.6).timeout
	_slide_door(true)
	await _arrived(monica)
	_slide_door(false)
	_hide(monica)
	await ui.think(L("home4", "after"))
	ui.close()
	if ezra.visible:
		await _play("home4", "ezra")
		ui.close()
	f.erase("cinematic")
	main.update_hud()


## The leaves. Forced tonight; no choice. Then Day 7.
func _leaves_dream() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var p = main.player
	_ended = true
	f["cinematic"] = true
	p.seated = true
	var tw := create_tween().set_parallel(true)
	tw.tween_property(p, "position", Vector3(-2.3, 0.0, -2.6), 1.0)
	tw.tween_property(p, "crouch", 1.15, 1.2).set_trans(Tween.TRANS_SINE)
	await tw.finished
	await p.face(Vector3(-7.0, 1.4, -2.6), 1.0)
	await ui.think(L("leaves", "asleep"))
	ui.close()
	await ui.fade_to(1.0, 2.0)
	_blackout(true)
	await ui.fade_to(0.0, 0.05)
	await get_tree().create_timer(0.6).timeout
	main.play("step", -16.0, 0.6)
	var img1: Texture2D = await _picture(autumn.global_position + Vector3(0.5, 1.4, 1.8), autumn.global_position + Vector3(0, 0.5, -3.2), 64.0)
	ui.show_picture(img1, L("leaves", "cap1"))
	await _play("leaves", "pile")
	var img2: Texture2D = await _picture(autumn.global_position + Vector3(1.6, 1.45, 0.2), autumn.global_position + Vector3(1.9, 1.3, -2.4), 50.0)
	ui.show_picture(img2, L("leaves", "cap2"))
	await _play("leaves", "other")
	await ui.say("Carl", L("leaves", "keeping_company"))
	await _play("leaves", "believed")
	ui.hide_picture()
	ui.close()
	main.log_line("dream", L("toast", "leaves"))
	await get_tree().create_timer(0.4).timeout
	await ui.show_card(L("leaves", "day7"), 3.0)
	f.erase("cinematic")
	f["home4_done"] = true
	await ui.fade_to(1.0, 0.5)
	_blackout(false)
	if not main._selftest:
		ui.show_title(true)
	else:
		await ui.fade_to(0.0, 0.3)


## The eye off the page: a widening spiral round her room, rising.
func _eye_spiral(t: float) -> void:
	var a := t * TAU * 1.5
	var ctr := Vector3(9.5, 1.3, -9.4)
	var sp := ctr + Vector3(cos(a) * 1.4, 0.0, sin(a) * 1.4) * (1.0 - t * 0.5) + Vector3(0, t * 0.5, 0)
	eye_rig.global_position = Vector3(8.1, 0.76, -8.6).lerp(sp, clampf(t * 3.0, 0.0, 1.0)) if t < 0.33 else sp
	eye_rig.look_at(_eye_cam, Vector3.UP)


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
	if a.has("panel"):
		_show_panel(str(a["panel"]))
	if a.has("dark"):
		_darken()
	if a.has("eye"):
		eye_rig.visible = true
		cage.visible = true
		eye_rig.global_position = main.player.global_position + Vector3(0, 1.45, 0) - main.player.global_transform.basis.z * 0.9
		eye_rig.look_at(main.player.global_position + Vector3(0, 1.45, 0), Vector3.UP)


## Dev: show one cutscene panel for a screenshot (--panel=lift|board|alley|pillow|door|council).
func _show_panel(name: String) -> void:
	var shots := {
		"lift": [lift350, Vector3(0, 1.5, 0.9), Vector3(0, 2.1, -1.2), 56.0],
		"board": [boardroom, Vector3(0.25, 1.4, -1.6), Vector3(0, 1.45, -7.2), 54.0],
		"alley": [alley, Vector3(0, 1.6, 1.6), Vector3(-0.2, 1.1, -4.8), 62.0],
		"pillow": [pillow, Vector3(0.0, 0.42, 0.6), Vector3(0.2, 0.26, -0.05), 46.0],
		"door": [doorway, Vector3(0.35, 0.55, 0.7), Vector3(0, 1.25, -2.1), 68.0],
		"council": [council, Vector3(2.2, 2.6, 2.8), Vector3(0, 1.0, -0.5), 70.0],
		"autumn": [autumn, Vector3(0.5, 1.4, 1.8), Vector3(0, 0.5, -3.2), 64.0],
		"autumn2": [autumn, Vector3(1.6, 1.45, 0.2), Vector3(1.9, 1.3, -2.4), 50.0],
		"tower_dark": [self, Vector3(-20.0, -140.0, 40.0), Vector3(-150.0, 20.0, -70.0), 70.0],
		"city_dark": [self, Vector3(-7.5, 1.2, -4.5), Vector3(-90.0, -180.0, -30.0), 74.0],
	}
	if name.begins_with("sketch"):
		main.ui.show_picture(_sketch_page(int(name.substr(6))), name)
		return
	if not shots.has(name) or shots[name][0] == null:
		return
	var sh: Array = shots[name]
	var at: Node3D = sh[0]
	var img: Texture2D = await _picture(at.global_position + sh[1], at.global_position + sh[2], sh[3])
	main.ui.show_picture(img, name)


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
	if fourth:
		for id in ["fridge_drawing", "photo", "trophy", "monica", "ezra", "couch"]:
			await _by_id(id)
		print("ok monica's choice")
	elif third:
		for id in ["monica", "mira_door", "circle", "sketchbook"]:
			await _by_id(id)
		print("ok blackout")
	elif second:
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
