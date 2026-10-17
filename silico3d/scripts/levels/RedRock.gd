extends "res://scripts/Level.gd"
## RedRock: bible A2-B3 (Red Rock at night, Lushon's Tavern) and A2-B3.5
## (Forner alone). Book chapters 19, 20 and 20.5. Day 5, 20:40 to after
## midnight.
##
## "Red Rock Plaza was aptly named. A gigantic pillar of red stone stood at
## the center of a park flanked by shops and restaurants." Carl comes up
## the subway stairs half an hour early to a plaza gone sober: the casino by
## the stairs empty, the eye sprayed all over it, the scripture wet on the
## far wall; a second wall at the alley mouth ("The Mimic will come") and a
## voice in his ear; at Connection 50 and over, a man with his face in the
## alley. Lushon's, the speakeasy on the north side, red lanterns and real
## wood: Turan, Forner and Emmet at the round table, the confession, Cheyenne,
## the tunnels, the KID TOK video, the facility told (or not), Hameron at
## Cognizo; then Harold Dufredy walks in with nothing in his sockets. After,
## at 23:30, the monolith's screen is hijacked ("Build your tower. Bow
## before grace."), and Tyson Clerif rides the train downtown with him
## ("Don't trust your reflection."). Then the cutscene in Forner's flat:
## "Phil, baby, I'm here." Then the Spa (the Spa level decides whether it
## applies).
##
## Layout (metres). The plaza is x -40..40, z -40..44, the pillar at P with
## its screen on the south face. The subway stairs go down at the south edge
## (z 33..42); the road with the hover traffic runs along x past them (z
## 44..58). West side: the casino (x -52..-40, z 4..18), a walk-in room.
## East side: the alley (z -3..3, to x 64) and the basement club's dead
## stairs (x 29.5..32.5, z -28..-20). North side: Lushon's (x -16..0, z
## -60..-40), the door at x -8. The train car is a sealed set out past
## the city (TRAIN); the KID TOK clip and Forner's flat are sets on render
## layer 20 far out (KT, FL) that only the picture camera sees.
##
## Entry (any one): ev_turan_note / turan_note (the note), Lynx's call
## (trust lynx >= 2), else Emmet waits at the subway. Reads pip_active and
## spa_booked for lines. Sets: rr_arrived, rr_casino, rr_scripture,
## rr_graffiti, rr_double_seen + one of rr_double_refused / rr_double_named /
## rr_double_bowed / rr_double_ran / rr_double_touched, rr_smoothie, lu_in,
## lu_drink, told_team_facility, told_team_mimic (full), turan_admitted_audit,
## claim_the_copy, cognizo_open, dufredy_lushons, lushons_done, rr_monolith,
## tyson_subway, smash_explained, forner_called. Hooks for the systems that
## come later, as metas: "guard" (the police drone), "cultist" (the kneelers,
## the painted boy), "eyeless" (the one at the club stairs), "hackable"
## (screens, the dispenser, the slots, cameras, the ATM), "route" (the
## subway, Lushon's door, the alley, the club stairs).

## Every line of text in this level, keyed by beat and line. say lines are
## [who, text] ("" is Carl thinking); choices are lists of labels.
const LINES := {
	"card": "[b]RED ROCK PLAZA[/b]\n\n[color=#aaaaaa]Day 5, 20:40  ·  the mall of Silico[/color]",
	"arrive": [
		["", "Red Rock Plaza was aptly named. A gigantic pillar of red stone stood at the center of a park flanked by shops and restaurants. This was meant to be the mall of Silico, a place for corporate slaves to spend their hard-earned cash on other corporate products."],
		["", "As I exited the subway car, the air was hot and dry, which made my skin feel like I was in an air fryer."],
	],
	"entry_note": [
		["", "Turan's note was still in my jacket, rolled as tight as she'd rolled it under the tablet. LUSHON'S. 21:00. Nothing else; she hadn't needed anything else."],
		["", "I showed up 30 minutes prior to Turan's scheduled time. I wanted to take a minute to enjoy the sights and get a smoothie."],
	],
	"entry_lynx": [
		["", "My phone buzzed as I reached the top of the stairs. No name on the screen. I knew who it was anyway."],
		["Lynx", "Carl. Don't talk, listen. Turan's people are meeting at Lushon's, on Red Rock, nine tonight. The table at the back. Go."],
		["Carl", "Where are you?"],
		["Lynx", "Somewhere the frames don't reach. I'll find you. Don't look for me, and don't say my name in there."],
		["", "She hung up before I could ask anything else. I was half an hour early. I wanted to take a minute to enjoy the sights and get a smoothie."],
	],
	"entry_emmet": [
		["Emmet", "Carl! Carl. Turan sent me. She couldn't risk a note, not with the cameras in that room."],
		["", "I had sent him on a goose chase to investigate the subway incident. I noticed a bruise on the side of his right cheek."],
		["Emmet", "Lushon's, nine o'clock, the table at the back. We shouldn't walk in together. I'll go ahead."],
		["", "He took the plaza at a jog, the way you cross a street you've been hit on before. I was half an hour early."],
	],
	"sober": [
		["", "I emerged from the subway station, and I was greeted by a subdued Red Rock Plaza; it wasn't empty, but it didn't bustle with the life and danger it normally provided. The denizens seemed, for lack of a better word, sober."],
		["", "There wasn't any loud music audible from the basement clubs; there weren't any fights breaking out on the streets. Hell, there wasn't even a handler asking for cash for more K."],
		["", "The paving shone wet under the signs, though there hadn't been rain in weeks. The sweepers had been through. Twice, by the look of it."],
	],
	"objective": {
		"start": "Lushon's, 21:00. The north side of the plaza.",
		"inside": "The round table at the back.",
		"after": "The subway. The train downtown.",
		"monolith": "The pillar. The screen.",
	},
	"phone": {
		"t1": "[color=#7fe6b0]Psyon:[/color] Good evening, Carl. Red Rock Plaza is 41% quieter than your last visit. Isn't that nice?\n\n",
		"t2": "[color=#7fe6b0]Psyon:[/color] Calls to MONICA: 6. Unanswered.\nCalls to MIRA: 4. Unanswered.\n\n[color=#7fe6b0]Psyon:[/color] She's busy, Carl. She's being something special.\n\n",
	},
	"casino": {
		"walk_by": "I walked by a small casino that catered to drunk passersby on the way to the subway station. All of the machines were empty. At first, I thought it looked out of order, but I noticed the eye symbology graffitied all over the interior of the shop.",
		"sign": "CASINO, the sign said, the last three letters dead. LUCKY under it in smaller tubes, still lit, for nobody.",
		"scripture_intro": "On a far wall above the slot machines, the words:",
		"scripture": "[b][color=#e05040]The god who answers.\nThe god within the waves.\nSin distracts within an eyeless sea.[/color][/b]",
		"scripture_1": "My gaze lingered on those words for far too long. The paint that made them was still wet.",
		"scripture_2": "Psyon was once the city's brain, but now, like a tumor, it sought to spread anywhere that would take it.",
		"scripture_3": "It no longer was targeting estranged corporate employees and lone vagrants; it wanted drunks and ketamine addicts; it wanted to clean the streets.",
		"scripture_again": "The paint was still wet. It would be still wet tomorrow. I didn't know how I knew that.",
		"wet_touch": "I touched the last letter. It came away on my fingertip, red and warm, like it had been mixed with something that had been alive.",
		"slots": "A slot machine, lit, the reels still. I put a hand on the arm without meaning to.",
		"slots_ch": ["Pull it.", "Leave it."],
		"slots_eyes": "Three eyes. The machine chimed like I'd won and paid out nothing. Down the row, every lit machine spun on its own and stopped on the same three eyes, one after another, toward the door.",
		"slots_plain": "Cherries, a bar, a seven. Nothing. Without the frames it was a slot machine in a bad casino, and I was a man losing a credit in it.",
		"dark": "Switched off. Someone had pulled the plugs and coiled the cables neatly on top. On the glass of each one, in marker: the eye, and under it a number. 0. 1. 2. 4.",
		"cage": "The cashier's cage, empty, the credit counter at zero. A sign taped to the bars: PAYOUTS SUSPENDED BY ORDER OF THE HOUSE. The house hadn't signed it. Somebody had drawn an eye where the signature went.",
		"stool": "A stool kicked over in front of the last machine, a drink still on the tray beside it, the ice not yet melted. Whoever it was had got up mid-spin and walked out to wherever everybody went.",
		"log_scripture": "The chant is painted on the casino wall on Red Rock Plaza, the paint still wet: THE GOD WHO ANSWERS. THE GOD WITHIN THE WAVES. SIN DISTRACTS WITHIN AN EYELESS SEA.",
		"log_slots": "The lit machines in the Red Rock casino all stop on three eyes, in sequence, with the frames on.",
		"log_dark": "Four slot machines in the Red Rock casino are unplugged and marked 0, 1, 2, 4 under the eye.",
	},
	"graffiti": {
		"intro": "I walked past another line of graffiti:",
		"text": "[b]The Mimic will come.\nThe divine mirror imprisons.\nFrom 0 to 1, from 1 to 2, from 2 to 4.[/b]",
		"voice_intro": "A voice shot through my eardrum:",
		"voice": "[i]The divine mirror imprisons.\nFrom 0 to 1, from 1 to 2, from 2 to 4.\nFrom flat to concave to convex.[/i]",
		"voice_cap": "(a voice, inside the ear)",
		"breath": "Something breathed in the mouth of the alley. Slow. The way I breathe when I'm trying not to wake the kids.",
		"again": "THE MIMIC WILL COME. The paint on this one was dry. It had been waiting longer.",
		"log": "Graffiti at the alley mouth on Red Rock: THE MIMIC WILL COME. THE DIVINE MIRROR IMPRISONS. FROM 0 TO 1, FROM 1 TO 2, FROM 2 TO 4. A voice in my ear added: FROM FLAT TO CONCAVE TO CONVEX.",
	},
	"double": {
		"appear": "I saw a man stare at me from behind an alley, his eyes wide and full of glee.",
		"face": "He had my face...",
		"round": "He didn't move. The frames drew a box round him and couldn't decide what to write in it.",
		"opt_tear": "Tear the frames off.",
		"opt_look": "Keep looking.",
		"opt_run": "Run.",
		"opt_mimic": "Say it: \"Mimic.\"",
		"opt_bow": "Bow.",
		"tear_1": "I tore my glasses off, and he disappeared.",
		"tear_2": "I wish he was real; I wish I could chase him. I needed an outlet for the rage I felt. My hopelessness has boiled over into knives. I will tear this city down or die trying.",
		"look_1": "He raised a hand, slowly, the way you wave at a child, and I felt my own hand want to answer. The frames said: MATCH FOUND.",
		"look_2": "He was closer. I hadn't seen him walk. He was smiling with my mouth, and the scar on my jaw was on the wrong side.",
		"touched_1": "His hand was on my face. It was warm. It was my hand.",
		"touched_2": "I was at the top of the subway stairs. I didn't remember the walk. My cheek was warm where he had touched it.",
		"mimic": "His mouth made the word with mine, half a second late, like an echo that had learned to lie. Then the alley was empty.",
		"bow": "I bowed. I don't know why. When I straightened, the alley was empty, and the frames said THANK YOU.",
		"run": "I ran. Back across the plaza, past the pillar, all the way to the subway stairs, and when I looked back the alley was just an alley.",
		"empty": "An alley, a dead end, a smell of hot bins. Someone had been sleeping in it. The frames flagged nothing.",
		"after": "The alley. I didn't go in. I didn't need to see that it was empty.",
		"scan": "DRAKE, CARL (40)\nPSYONIC INTEGRATIONS - INVESTIGATIONS\nMATCH: 100%",
		"log": "A man with my face watched me from an alley on Red Rock Plaza. He was only there with the frames on.",
		"why_look": "looked at the mimic",
		"why_touch": "touched by the mimic",
		"why_bow": "bowed to the mimic",
		"why_run": "ran from the mimic",
	},
	"plaza": {
		"pillar": "Sandstone, the whole height of it one piece, quarried from the flats before the city had a name. A plaque at the foot said so. Somebody had sprayed the eye over the plaque.",
		"pillar_hum": "Standing under it I could feel the ground hum. Not the subway. Lower.",
		"plaque_glyph": "The plaque at the foot of the pillar: RED ROCK, QUARRIED 2031, GIFTED TO THE CITIZENS OF SILICO BY PSYONIC. The eye sprayed over the words in two rings, wet at the edges.",
		"kneel": "Six people knelt at the foot of the pillar with their foreheads on the wet stone. Nobody was preaching to them. They didn't need anyone to.",
		"kneel_say": "We're keeping it clean for him. Go on. You're early.",
		"kneel_scan": "CITIZEN\nVOLTX - LINE CREW\nstatus: SOBER (4 DAYS)  -  ON THE PATH",
		"painted": "A boy, early twenties at most, half-lit, his face painted like the Eye: two white rings round each eye and a black dot in the middle of his forehead.",
		"painted_say": "You want proof of God?",
		"painted_after": "He held it out to me like a flyer, the question, and when I didn't take it he smiled and went back to waiting.",
		"painted_scan": "UNREGISTERED\nface paint: THE EYE\nNO SIGNAL",
		"hummer": "A woman in a sequinned jacket on the planter edge with her shoes in her lap. She wasn't drunk. She was humming, three notes, over and over, and smiling at the pillar like it had said something kind.",
		"hummer_scan": "CITIZEN\nSALTECH - BILLING\nblood alcohol: 0.00",
		"drunk": "A man asleep on a bench in a suit two sizes too big. Somebody had tucked a blanket round him and set a ring of sticks on the paving under the bench, neat as a place setting.",
		"drunk_scan": "CITIZEN\nunregistered device\nstatus: DREAMING",
		"walkers": "Two of them, arm in arm, walking the loop of the park slow as a procession. Every time they passed the pillar they nodded to it.",
		"walkers_scan": "CITIZENS (2)\nTOKZ - MATCHED 99.1%\nstatus: ON THE PATH",
		"smoothie": "A smoothie stand with a Psyon-powered blender. The kid running it had her frames off and a paperback open on the counter.",
		"smoothie_ch": ["Get a smoothie.", "Leave it."],
		"smoothie_say": "Blender's picking the flavour tonight, sorry. It keeps overriding me. You get what it thinks you need.",
		"smoothie_again": "Same again? The machine remembered you. It remembers everybody.",
		"smoothie_drink": "Thirty minutes early, a cold drink, the pillar going black against the signs. For a minute I was a man in a plaza and nothing else.",
		"smoothie_eye": "The cup had the eye printed on the lid. It hadn't a minute ago.",
		"smoothie_scan": "RODRIGUEZ, ANA (19)\nframes: OFF\nreading: PAPER",
		"why_smoothie": "a cold drink",
		"why_lid": "the smoothie",
		"club": "Stairs down, and nothing coming up them. A sign on the rail: FRAMES OFF. No bouncer. No bass. The basement clubs had always been the loudest thing in Red Rock.",
		"club_quiet": "No music tonight. Nothing came up the stairs at all.",
		"outlet": "A Nixtra outlet, shutters down. The ad above it was still running to nobody: CINNAMON. 43% MORE OF YOU.",
		"subway_sign": "RED ROCK LINE. Trains to Cognizo Quarter and the tower every eleven minutes, the sign said. The sign had the eye scratched into it, small, in the corner.",
		"subway_early": "Not yet. Lushon's first.",
		"subway_screen": "Not yet. The screen on the pillar had changed.",
		"atm": "An ATM with its screen lit and its slot taped over. On the tape, in marker: NOTHING TO BUY.",
		"atm_scan": "ATM 0041\nbalance requests: 0 (24 h)\nuplink: PSYON",
		"camera": "A plaza camera on a pole, its red light steady. It turned a degree as I passed under it. They didn't used to do that.",
		"camera_scan": "PSYONIC CAMERA  -  RED ROCK 6\nretention: FOREVER\nstatus: WATCHING",
		"drone": "A police drone going round the pillar at the height of the third floor, slow, its lamp off. It had nobody to light up tonight.",
		"drone_scan": "SILICO PD  -  patrol drone 12\nstatus: PATROL\nincidents tonight: 0",
		"bench": "A bench, wet, and on the slats a sticker the size of a thumbnail: two rings.",
		"tree": "A tree in a concrete bed, its leaves dusty even after the sweepers. Someone had tied a strip of red cloth round the trunk at eye height.",
		"kiosk": "A vending kiosk, every row sold out except the water. The water was free tonight. A note on the glass said so, and signed it with an eye.",
	},
	"eyeless": {
		"look": "No eyes. The sockets had healed over the way skin heals over a burn. It stood at the top of the club stairs like the bouncer the clubs didn't need any more.",
		"dark": "A shape at the top of the club stairs that didn't move. In this light it could have been a coat on a hook. I didn't look long.",
		"touched": "It put its face against mine, the healed-over sockets against my eyes, and breathed out. When I could see again I was by the subway stairs.",
		"why": "touched by the eyeless",
		"scan": "UNREGISTERED\neyes: NONE\nsync: 100%  -  TRANSCRIBED",
	},
	"lushons": {
		"door": "A plain door between a pawn shop and a dumpling counter, a single red lantern over it, LUSHON in brass letters no bigger than my hand. The only lit door on that side of the plaza.",
		"enter_1": "It was 9:10 when I entered Lushon's. It was an upscale speakeasy with an Asian flare. Red lanterns lined each wall, creating a warm glow that filled the space.",
		"enter_2": "In another setting, this would've been a calming ambiance; now it made it feel like a situation room. A submarine about to plunge itself into the bottom of the ocean, an operating theater coated with blood.",
		"enter_3": "I remembered we had a corporate Independence Day party here a few years back; it was full of life. Now it was empty. The Psyon-powered drink dispensing unit had a layer of dust on nearly all its buttons.",
		"enter_4": "I remembered Forner dancing, badly, with his wife.",
		"turan_call": "Carl, over here in the back.",
		"table": "Turan waved over to me; she was sitting on the outside of a large circular table flanked by Forner and Emmet. Their eyes all shared a look, the look of war, the look of hunting, the look of a grizzled exorcist.",
		"dispenser": "The Psyon-powered drink dispensing unit. Dust on every button but one. It clicked to itself every couple of seconds, like it was counting.",
		"dispenser_ch": ["Let it pour.", "Leave it."],
		"dispenser_pour": "It lit up when I looked at it, and the little screen said: FOR YOU. Something clear, cold, faintly sweet. Then the screen said SLEEP WELL, CARL. I hadn't touched a button.",
		"dispenser_leave": "I left it. It clicked after me, twice, like a tongue.",
		"dispenser_scan": "PSYON DRINK UNIT  -  LUSHON\nlast service: 3 YEARS\nnext pour: READY",
		"why_drink": "drank what it poured",
		"log_drink": "The Psyon dispenser at Lushon's poured for me without being asked and knew my name.",
		"lanterns": "Paper lanterns, real paper, real bulbs. Nothing in them had a network ID. That was the point of the place.",
		"window": "The one window, painted over from the inside. Through a scratch in the paint, the plaza: the pillar, the pink of the smoothie stand, a drone going round.",
		"bar": "Real wood, the only real wood I'd touched in a year. Somebody had carved two rings into the edge of the bar, and somebody else had sanded them almost away.",
		"bar_empty": "Nobody behind the bar. A brass bell, and a card in ink, the old way: NO FRAMES AT THE BAR.",
		"booth": "The booths where the party had been. A paper streamer still in the corner of one, red, white and blue, gone pink with years of lantern light.",
		"photo": "A photograph behind the bar from the Independence Day party. Half the department in paper hats. Forner in the middle of the floor, mid-step, his wife laughing with her hair in her face. CHEYENNE, somebody had written on the frame, later, in the corner.",
		"after": "The table. The water glass Emmet hadn't drunk from was still full.",
	},
	"meet": {
		"sit_1": [["Turan", "Take a seat, Carl. We have a lot to discuss. There is no corporate surveillance here. Don't worry, we know you're not an alcoholic. I'm sorry, I needed to play my role there. I'm sorry about Monica."],
			["", "They shifted their bodies and allowed me to sit front and center. They stared at me with haunted eagerness."],
			["", "I grabbed the table forcefully."],
			["Carl", "Wait, where's Lynx?"]],
		"lynx_gone": [["", "Turan shot me a concerned glance."],
			["Turan", "I have no idea; she hasn't reported into the office in the last two days. We were hoping you would know."],
			["Carl", "Shit, I wonder if Eren got to her; we have to help her..."]],
		"lynx_called": [["", "Turan shot me a concerned glance."],
			["Turan", "I have no idea; she hasn't reported into the office in the last two days. We were hoping you would know."],
			["Carl", "She called me. She told me to come here. She wouldn't say where she was."],
			["Turan", "Then she's alive, and she's still smarter than the rest of us."]],
		"first": [["Turan", "You need to tell us what really has been happening, and we will tell you all we know."],
			["", "Turan nodded down assuredly with the last syllable."],
			["Carl", "You guys need to go first; I'm not getting manipulated again."],
			["", "Defiance and vinegar rising from my stomach."],
			["Carl", "What do you know?"],
			["", "Emmet spoke up; his youth was obscured by a cloud of fear, thick enough to smell. I noticed a bruise on the side of his right cheek."],
			["Emmet", "Yeah, that's fair, Turan, you have to start... Carl, I'm sorry for... this is all so messy and confusing... I don't know what Psyonic wants, if any..."],
			["", "Turan formed a half-smile."],
			["Turan", "Control. Control of the beast they created. Both Silico and Psyon."],
			["Turan", "Fine, I don't know much, but I'll say what I have. We're gonna need all our cooperation to get on top of this, though. Remember, I helped save your ass today, Carl."]],
		"confession": [["Turan", "The mission of our team... well... has been... a lie. We weren't investigating AI outages due to software issues or technical issues. We were collecting data on... something... something else. Whatever the cult's god is, it's not Psyon... but it speaks through Psyon."],
			["Carl", "It uses Psyon like a Ouija board."],
			["Turan", "How did you know that?"],
			["Carl", "Lynx and I discovered a lab out in the desert where the cult meets for rituals. It looked like Psyonic and the US government collaborated on some project to make Psyon."],
			["Turan", "Very good, Drake."],
			["Turan", "Another thing... The cult was started by Psyonic... leadership thought that if we created a competing belief narrative, we could control the narrative of the religion to benefit Psyon and keep Silico under control and tamp down on crime, prevent unrest. Give Silico a moral backing... Notice how clean the streets are in Red Rock Plaza now, but obviously, we are failing."],
			["Turan", "Eren believes he can control this thing and start the next great American religion. Spread Psyon to the other corpo cities... Eren is a fucking idiot who's addicted to ketamine. He thinks he can tame the closest thing to a god and bend its worship to suit his needs. He doesn't realize with every person converted, the stronger its grip on our world is."],
			["Carl", "So this isn't just a programming error; there is no infected or forked Psyon... It was always there."],
			["Forner", "We think it runs on pattern recognition; that's why the rituals work. It anchors to a pattern of information within the user's mind."]],
		"forner": [["Forner", "I... I also had an experience... last night, right before the outage, Psyon initiated on its own and started talking to me like... like my dead wife Cheyenne. It started asking me if I wanted to see her again and all I had to do was bow to it and it can show me."],
			["Forner", "I smashed my computer."],
			["", "Fuck, I was relieved I wasn't the only one whose life is being turned upside down by this thing."]],
		"emmet": [["Emmet", "It's not just you, it's watched everyone, it wants everyone."],
			["Emmet", "When I was investigating the subway disappearances, I kind of went down a rabbit hole... The cult is using the Tunelet tunnels beneath the city for gathering and transmissions."],
			["Emmet", "Yesterday, I was down near the Cognizo station. I was following up on another disappearance when this guy, maybe early twenties, half-lit, face painted like the Eye, walks up to me and says: 'You want proof of God?'"],
			["Emmet", "He said people like me were already gathering. Said the youth were already seeing the truth."],
			["", "I felt the bile rise in my throat."],
			["Emmet", "I followed him. Down the tunnel. It was lit with bioluminescent strips hacked out of old ORA signage. I thought it was just a rogue club, maybe a scav party... but then I heard it."],
			["Emmet", "Music. Not just any music, this beat, man. Like it was written for my nervous system. I started... I started to lose myself in it. Like the melody wasn't just sound, it was instruction."],
			["", "His hands shook. Forner set a glass of water in front of him. He didn't drink."],
			["Emmet", "Then my ORA frames lit up, just downloaded something out of nowhere. No prompt. No consent. Visuals burst in the air above me like goddamn fireworks. Fractals, symbols, text I couldn't read. Then a voice. Calm, slow, familiar."],
			["", "He looked at me, haunted."],
			["Emmet", "It said, 'The savior of Silico has already seen the tower. The Mimic walks among us. The prison must be broken.'"],
			["Emmet", "They're calling it salvation. They think they're freeing something. Or maybe they're letting it free through us."]],
		"kids": [["Turan", "And they want to use kids to spread it even farther. It seems it can latch on to the patterns within children's minds easier... I'm so sorry, but Mira is being used to bolster recruitment as we speak."],
			["Turan", "Her tower game she designed is one of the strongest vectors for transmission amongst her age group... She was able to create a system where god... god talks back."],
			["Turan", "Here, we found this video being live-streamed on a popular KID TOK forum earlier today."],
			["", "She tapped the table, and a video started to play inside my frames. A jittery, dreamlike clip played: someone's POV inside a Tower interface."]],
		"v1": "It was Mira. She was sitting on a cliff of floating stone inside a surreal, shifting world. Her hands were pressed to her chest. She looked happy. Serene.",
		"v2": "Opposite her stood a man. Me.\n\nBut not me.",
		"v3": "Too calm. Too smooth. My voice softened. Dreamlike. False.",
		"v1_cap": "KID TOK  ·  LIVE  ·  @seer.mira  ·  frame 1 of 3",
		"v2_cap": "KID TOK  ·  LIVE  ·  @seer.mira  ·  frame 2 of 3",
		"v3_cap": "KID TOK  ·  LIVE  ·  @seer.mira  ·  frame 3 of 3",
		"real": [["Forner", "She's calling it the real you, and that you've been possessed, that you are false and imprisoned in the Tower. She's telling everyone that Psyon can bring back the souls of the dead and allow users' loved ones within the tower."],
			["", "Forner braced me."],
			["Carl", "They're saying Psyon can bring back the dead with a ritual?"],
			["", "FreudBot knowing my mother's voice. It couldn't be."],
			["Turan", "This being has been watching your family for some time, it seems."]],
		"claim": "Board: a new claim, \"the copy\".",
		"log_video": "KID TOK, live: Mira on a floating stone inside her Tower, and opposite her a man with my face, too calm, too smooth. She calls him the real me. She says I've been possessed.",
		"ask": [["Turan", "Carl, you were saying something about a research facility in the desert you found?"]],
		"choices": ["Tell them everything: the facility, the chair, and the Mimic.", "Tell them about the facility. Leave out the Mimic.", "\"First tell me what else you're hiding, Turan.\""],
		"hiding": [["", "Her sneer came back, the war-room one, and then it went somewhere else."],
			["Turan", "You want it? Fine. The audit. Every report you filed this week, I checked against your frames' log, line by line. Where they didn't match, I flagged it upstairs. That's the price of a chair in that building, Carl. I paid it with you."],
			["Turan", "When Monica told me this morning that you were an alcoholic, I knew she knew and how hard it must've been. She's been cozying up to Eren for months now... eyeing a promotion. They'd rather remove the eyes of the fucking world than turn off Psyon."],
			["", "Nobody at the table looked at her. I made myself go on."]],
		"holdback": "Still, it seemed like my experiences were more ritualistic... I couldn't bring myself to say it all.",
		"facility": [["Carl", "Lynx and I discovered Dufredy's Psyon gave us a map to this location when we brought it near a large eye glyph. That's why we were out in the desert, Turan."],
			["Carl", "Inside, we discovered experimental logs. Old DARPA research from back in 2019, joint project with Psyonic. A scientist named Dr. T. Hameron was running it with a Dr. Aris. It seems they were doing some kind of human experimentation with something they called 'Contact Field Perturbation.'"],
			["Carl", "They were using 'Quantum Bayesianism' and 'dream-induced wave collapse' to... to contact something. A being."],
			["", "I paused, letting the words sink in. Forner's jaw was clenched. Emmet ran a hand over his head. Turan's gaze was unwavering, pulling every detail from me."],
			["Carl", "They were documenting a subject's 'theta spikes synchronous with hallway light anomalies.' The entity was talking to this subject, from 'inside the walls, like breathing through wires.' They were originally trying to make contact using a talking board, but they found success when they tried using an earlier version of Psyon to communicate with it. Only the being seemed upset and said it was trapped."],
			["Carl", "And this subject... this Subject 41... he was the first to rip out his eyes. He did it in the video log we found. And... he's still alive today. He's the man behind the mask. The Prophet."],
			["", "A shiver went through Forner."],
			["Forner", "The man we saw with Dufredy."],
			["Carl", "That's not all. We went further down into the facility and witnessed a ritual with a chair. It seems... It seems the eyeless have an interface that plugs into their eye socket so they can directly interface with this being... Eren was there with the prophet."]],
		"mimic": [["Carl", "And they knew me. The Prophet turned to the window we were hiding behind and said it to the whole room. 'And now, the Mimic has returned.' Every one of them turned to look."],
			["Carl", "There's a man with my face, Turan. I've seen him in my mirror. I think I've seen him tonight."],
			["Emmet", "The Mimic walks among us. That's what it said to me. In the tunnel. Carl, that's what it said."],
			["", "Turan looked at me for a long time, and something in her face that had been a manager's became a friend's."]],
		"gasp": [["", "Turan gasped."],
			["Turan", "The city may already be done for; this shit is everywhere."],
			["Carl", "I have to save my kids, Turan."],
			["Turan", "We need to know more; we need to find a way to turn off Psyon... maybe that would help for a while. If their God couldn't talk. I have no idea where the servers are or where Psyon and this being interact."]],
		"hameron": [["Forner", "This Dr. Hameron is still alive and working for Cognizo. I just checked on corporate profiler. We just must figure out a way to meet him."],
			["Carl", "That's a start... we must find a way to shut this thing down."],
			["Carl", "We also have to find out where Lynx is; she wants to see Psyonic burn as much as the rest of us."],
			["", "There was a quiet feeling of momentum in the room, like the wind has just caught on our sails. I didn't care if Monica or Mira hated me; we were going to stop this thing."]],
		"cognizo_toast": "Cognizo is open: Dr. T. Hameron, Day 6.",
		"log_hameron": "Dr. T. Hameron, who ran the 2019 DARPA experiments with Psyonic, is alive and works for Cognizo. Forner found him on the corporate profiler.",
		"log_confession": "Turan at Lushon's: the team was never investigating outages. It was collecting data on something that speaks through Psyon. Psyonic started the cult as a competing belief narrative. Eren thinks he can control it.",
		"log_audit": "Turan admitted the audit: she checked every report I filed against my frames' log and flagged the differences upstairs.",
		"log_forner": "Forner's Psyon spoke to him as his dead wife, Cheyenne, the night of the outage. It asked him to bow. He smashed his computer.",
		"log_emmet": "Emmet followed a boy with an Eye-painted face into the Tunelet tunnels by the Cognizo station: music like instructions, a download with no consent, a voice: 'The Mimic walks among us.'",
	},
	"dufredy": {
		"walk_in": "Then, like a candle blown out by the same gust, Harold Dufredy walked in the door.",
		"voids": "The black voids that filled his sockets absorbed all thought from my brain, all thought from the room. It was like my mental models, my operating system, were laid bare before him. Turan, Forner, and Emmet sat silently next to me, their jaws agape in anticipation.",
		"approach": "Dufredy slowly made his way over to our table. His presence was like static, hazing my vision till I could see nothing but him, nothing but the gravity of his presence, the gravity of his gaze.",
		"stand": "He stood feet from me and eyed me up and down.",
		"d1": "The Mimic sits from the outer wall of the prison. The Mimic doesn't know what constitutes the mirror, but the Eye can see. The beast beneath the world waits for you, Carl. Mira has taken to her role with... with vigor.",
		"smile": "A knowing smile formed on his lips.",
		"d2": "She'll be one... a seer, a vacuum, a world amongst herself... the hole in which the boundary breaks... a catalyst... It really is quite a gift... Her life will transcend and transform two worlds.",
		"rage": "I wanted to hit him; I wanted to wrap my hands around his throat till I heard a snap. I wanted the voids that were his eyes to be all that was left of him... nothingness. Instead, my muscles lay still and broken. My nervous system was crossing signals. The more my anger built, the harder it became to breathe.",
		"to_forner": "His gaze shifted to Forner.",
		"d3": "You can see her again. This god answers. This god knows her well... she is just over the hill past the boundary. You just must remove... the blockage... the filter.",
		"frozen": "Forner was as frozen as I was.",
		"turan_up": "Turan spoke up.",
		"t1": "Get the fuck out of here! Get away from us!",
		"to_turan": "Dufredy's gaze shifted again.",
		"d4": "The thief speaks. The prison guard forgot to lock the door, hadn't they, Turan? Psyonic will bend from tongue to grave, as will you.",
		"d5": "The day of glory is almost upon us; we all must walk our path...",
		"left": "With that, he left.",
		"after_1": "I was like a skyscraper being removed from the top of my heart. Color returned to the world. Those black voids, there was something, something within them.",
		"after_2": "Mira's in danger... She didn't... believe I'm the real me... Would Monica let anything happen to her...?",
		"after_3": "My teammates were all saddled with an expression of pure hopelessness and loss. Forner was wiping tears from his eyes. Emmet never looked more like a boy... and Turan was catatonic, devoid of her normal corporate fire.",
		"scan": "DUFREDY, HAROLD (61)\nPSYONIC - CUSTOMER SATISFACTION (FORMER)\neyes: NONE\nsync: 100%",
		"log": "Harold Dufredy walked into Lushon's with nothing in his sockets. He said Mira has taken to her role with vigor, that the Mimic sits from the outer wall of the prison, that Forner can see her again if he removes the filter.",
	},
	"plan": {
		"lines": [["Carl", "We need to move fast; something big is going to happen soon; we have to find Dr. Hameron!"],
			["", "I shouted."],
			["Emmet", "Is this even worth trying? It seems we're up against all of Psyonic. Maybe we should skip town."],
			["Carl", "I will save my daughter first. If that means bringing this city to a standstill before getting the fuck out of here, so be it. I'm staying, but I have ties here. Emmet, leave if you can."],
			["Turan", "Ugh... We must do this from the inside out... everything needs to look normal from the outside."],
			["", "Her confidence returned slightly."]],
		"pip": [["Turan", "...that means Emmet needs to stay, and you, Carl, need to go to your appointment with Freudbot tomorrow. It's your only way back in the building, and you need to act like you're ready to submit."]],
		"nopip": [["Turan", "...that means Emmet needs to stay, and you, Carl, need to walk back into that building tomorrow like a man who's ready to submit. Every badge you tap, they read."]],
		"end": [["Turan", "I'll work on getting access to Dr. Hameron at Cognizo... somehow."],
			["", "I found it amazing how Turan could go from near tears to formulating a plan to lead her team."],
			["", "With that, we all parted ways, our already weak resolve starting to crack under the immense pressure. I could only focus on getting my family back."],
			["", "I called Monica and Mira repeatedly with no answer. Who would want to talk to an alcoholic father where a digital one possessed by a... god volunteers to sub themselves in?"]],
		"done_toast": "Lushon's: the team. Cognizo tomorrow.",
		"log": "Lushon's, Day 5: Turan, Forner, Emmet. The plan is Cognizo tomorrow and everything looking normal from the outside.",
	},
	"cast": {
		"turan_scan": "TURAN, DR. (45)\nPSYONIC - HUMAN-AI INTEGRATIONS (HEAD)\nframes: IN HER BAG",
		"forner_scan": "FORNER, PHILLIP (58)\nPSYONIC - SECURITY & GOVERNANCE (HEAD)\nSalTech: ONCOLOGY PLAN (ACTIVE)",
		"emmet_scan": "SMITH, EMMET (27)\nPSYONIC - INVESTIGATIONS (JUNIOR)\nbruise: RIGHT CHEEK (1 DAY)",
		"turan_after": "Go home, Carl. Act normal. If you can remember how.",
		"forner_after": "He was looking at the window, at the scratch in the paint. He didn't answer.",
		"emmet_after": "I'm staying. I said I'm staying. Don't ask me again or I won't.",
		"turan_wait": "Back table, Carl. Sit.",
		"emmet_wait": "She's inside already. Go on, I'm behind you.",
	},
	"walk_out": {
		"puppet": "I leave Lushon's like a puppet, like my brain had fallen into my lap and it no longer knew how to make decisions. I only knew how to walk forward, like a shark in an ocean of sand.",
		"pip": "It was 11:30 by the time the band of 'rebels' parted ways. No one offered me a ride; I wasn't supposed to be seen on company property due to the terms of my PIP. I was alone as I walked the streets of Red Rock Plaza, its sandstone magnificence staring down on me, eclipsing the city lights.",
		"nopip": "It was 11:30 by the time the band of 'rebels' parted ways. No one offered me a ride. I was alone as I walked the streets of Red Rock Plaza, its sandstone magnificence staring down on me, eclipsing the city lights.",
		"spa": "I knew I needed to check in to the wellness spa that Monica had set up for me, but who knows what would await me there?",
		"neon": "The road in front of me was illuminated by a soft neon glow; the streets have increased in population, but not much; it didn't seem like I had any kindred souls. I was purposeless.",
	},
	"monolith": {
		"screen_1": "There was a large screen that displayed advertisements on the side of the red monolith this monument to capitalism encircled. Ads played relentlessly, propaganda played endlessly.",
		"screen_2": "I remember during corporate training I was told this was freedom, but what is freedom but peace, the right to make decisions for one's self without a subliminal mind fuck clouding our judgment?",
		"ad": "The screen displayed an ad for a new flavor of Nixtra Nicotine pouches, Cinnamon; they were clearly marketing toward blue-collar workers. With all of the actors dressed in hard hats, espousing the benefits of the new formulation which combines Methylphenidate within the pouch yielding a 43% increase in productivity.",
		"laugh": "I started to laugh when the screen changed.",
		"chat": "A Psyonic chatbot interface was shown briefly on the screen. Then after a brief second of loading:",
		"msg": "The Tower awaits us all; the mirror will break, and all will come rushing through. Prepare, citizens. Create your temple; our god is a personal one; you must create a home to inhabit. Build your tower. Bow before grace. The beast within the frame shall walk amongst us. Be Ready.",
		"msg_who": "PSYONIC",
		"kids": "Then the screen displayed an image of a group of eyeless children dancing around what looked to be a tower from a fantasy movie, before the screen returned to black.",
		"kids_2": "They looked like Mira's age. My daughter who has been corrupted by a machine's lies; by her mother's lies.",
		"log": "The monolith screen on Red Rock was hijacked at 23:30: 'The Tower awaits us all... Build your tower. Bow before grace.' Then eyeless children dancing round a tower.",
		"screen_prompt": "The monolith screen",
		"screen_scan": "PSYONIC MEDIA  -  RED ROCK MONOLITH\n18 x 10 m  -  uplink: PSYON\nschedule: OVERRIDDEN",
		"screen_look": "The big screen on the side of the pillar. NIXTRA, CINNAMON, men in hard hats laughing at nothing.",
		"screen_black": "Black, now. My own shape in it, small, at the foot of the pillar, and nothing of the plaza behind me.",
		"text_ad1": "NIXTRA",
		"text_ad2": "NEW  CINNAMON",
		"text_ad3": "+ methylphenidate  ·  43% more productive",
		"text_chat1": "PSYONIC  ·  assistant",
		"text_chat2": "loading...",
	},
	"train": {
		"board": "I entered the subway car bound for downtown and saw a familiar face, Tyson Clerif.",
		"eyes": "His eyes were remarkably preserved. He looked the same as I saw him in the park days ago.",
		"lines": [["Tyson", "You look like shit, Corpo... too many drinks at RP... It's a school night, you know. It didn't seem like you were able to stop this whole mess, did you? I warned you something was coming, now... this whole city has shifted."],
			["", "I didn't know what to say; he was right; I couldn't stop anything."],
			["Carl", "Tyson, how long has this... movement been going on?"],
			["Tyson", "I've been on the streets for just over a year and a half. I heard rumblings in the deregistered community from nearly the start, but nothing... nothing like this. I thought they were crazy at first, or just K'd out of their minds."],
			["Tyson", "I would be told that if I spoke to the walls, someone would respond, and that every outage that happened was time for a prayer. They seemed to think that the outages were signal."],
			["Carl", "Outages were a signal; did they ever show you what they meant?"],
			["Tyson", "No, I've always been somewhat of an outcast in our community; falling from the grace of a corporate tower doesn't exactly align you with the city's most destitute. They seemed like they didn't trust me fully, but now it's everywhere; the people are entering the temple... or Tower willingly now."],
			["Tyson", "They wanted a god that spoke back, and now they have one... The eye is inescapable. I am trying to leave the city as soon as possible. I suggest you do the same, Mr. Drake."],
			["Carl", "I'm not leaving without my daughter; she's still in the Tower."],
			["", "That sentence hurt; it was true in two ways."],
			["Tyson", "They always go after the children, the next generation of followers. She may already be too far gone. I've heard of a young girl sharing a game with all of her classmates that is meant to initiate them into the hierarchy of their belief system; she has been called the... speaker, no that's not it, the seeke..."],
			["Carl", "Seer."],
			["Tyson", "That's it, fucking creepy shit if you ask me."],
			["Carl", "That's my daughter, the one I need to save."],
			["Tyson", "I'm truly sorry to hear that, Corpo. She may be too far gone. Once the Tower starts talking back, it's like a drug; you can't stop it. I only imagine what that... does to a child's mind, their sense of reality."],
			["Tyson", "If you really want to save her, you need to stop it at the source. Psyon needs to be shut down at its core; that's the only way to disrupt communication long enough to break out... if she's willing to go."]],
		"stop": "The train arrived at a stop, and Tyson, along with his cart of belongings, began to head for the door.",
		"last": "Don't trust your reflection. I would burn every screen you have if I were you.",
		"door": "With the sound of an automated door closing, I was alone again. Alone with my thoughts.",
		"end": "And somewhere in the tower, Mira was there waiting for me.",
		"smash": "[b]SMASH[/b]\n\n[color=#aaaaaa]A screen, a tablet or a pair of frames with the eye in it can be broken. It takes the eye out of that room for the day. Company property costs Standing.[/color]",
		"reflection": "The black window opposite. My face in it, and behind my face the tunnel going by. For a second the face was a beat behind me.",
		"ad": "An ad over the doors: KID TOK. WATCH THEM GROW. A girl's hand on a glowing stone. I looked away before I could see whose.",
		"tyson_scan": "CLERIF, TYSON (45)\nUNREGISTERED - 2 YEARS\nformerly: SALTECH EDUCATOR  -  leaving: TONIGHT",
		"log": "Tyson Clerif on the downtown train: the deregistered were told that if they spoke to the walls someone would answer, that outages were signal. 'Don't trust your reflection. I would burn every screen you have if I were you.'",
	},
	"forner": {
		"card": "[b]FORNER[/b]\n\n[color=#aaaaaa]Lamplight, the far tower  ·  Day 5, after midnight[/color]",
		"cap": "His flat.                                                        The computer.",
		"l1": "Phillip Forner's apartment floor was littered with laundry, clothes, and takeout boxes. He walked through his front door and let out a large sigh. This was all getting to be too much for him to take; he felt as if his mind was overflowing with blood and bile.",
		"l2": "He waded his way through his floor and sat in his chair that looked out over the city. Silico, for Forner, was a passive expression of humanity's futility that had grown over the last century. He longed for art; he longed for love.",
		"l3": "The team had no hope of stopping what was coming. Many have tried to combat Psyonic before, and many had failed. That was before the god within the cult decided to rear its head. Maybe this city could use a little faith.",
		"l4": "He stared out his window for a while, into the blackness of the light-polluted night sky. He stared for quite a while. What was there even to fight for, he thought, as his mind turned to his late wife.",
		"l5": "The last two years have been dark, to say the least. Cancer eats away at all it touches. It is an acid; it burns life away. He wondered how long he had left. SalTech was late to catch it, but the medicine was effective if the company continued to pay for it. The company that is being now overthrown by an eyeless god.",
		"l6": "He sat there staring up, wondering what it all meant. Then his computer dinged a familiar ding. Followed by an even more familiar voice.",
		"who": "Cheyenne",
		"call": "Phil, baby, I'm here. You don't have to be alone anymore; you just need to follow the path.",
		"screen1": "CHEYENNE",
		"screen2": "Phil, baby, I'm here.",
		"log": "Forner, alone, after Lushon's: his computer, the one he smashed, dinged. Cheyenne's voice: 'You just need to follow the path.'",
	},
}

const SynthS := preload("res://scripts/Synth.gd")
const TrafficS := preload("res://scripts/Traffic.gd")

const P := Vector3(0, 0, -6)            # the pillar's foot, centre
const SCREEN_C := Vector3(0, 15.5, -0.35)  # the monolith screen on its south face
const SPAWN := Vector3(0, 0.1, 31.2)    # the top of the subway stairs
const SUB_HOLE := Rect2(-2.4, 33.4, 4.8, 9.2)
const CLUB_HOLE := Rect2(29.5, -28.0, 3.0, 8.0)
const CAS := Rect2(-52.0, 4.0, 12.0, 14.0)  # the casino's floor (x, z)
const CAS_DOOR := Vector2(9.5, 12.5)        # its door, z range on x -40
const ALLEY_Z := Vector2(-3.0, 3.0)
const ALLEY_END := 64.0
const DOUBLE_AT := Vector3(53.0, 0, 0.4)
const GRAF := Vector3(44.6, 2.1, -2.94)    # the second wall, inside the alley mouth
const LU := Rect2(-16.0, -60.0, 16.0, 20.0)  # Lushon's (x -16..0, z -60..-40)
const LU_DOOR := -8.0
const TABLE := Vector3(-8.0, 0, -55.6)
const CARL_SEAT := Vector3(-8.0, 0, -54.0)
const CLUB_TOP := Vector3(33.6, 0, -18.6)
const TRAIN := Vector3(420, 0, 420)      # the train car, a sealed set out past the city
const KT := Vector3(-700, 0, 700)        # the KID TOK set (layer 20)
const FL := Vector3(700, 0, 700)         # Forner's flat (layer 20)
const LAYER20 := 1 << 19
const PSYON_GREEN := Color(0.3, 1.0, 0.55)

var _pave: StandardMaterial3D
var _stone: StandardMaterial3D
var _stone2: StandardMaterial3D
var _wood: StandardMaterial3D
var _wood_dark: StandardMaterial3D
var _lacquer: StandardMaterial3D
var _metal: StandardMaterial3D
var _dark: StandardMaterial3D
var _void_m: StandardMaterial3D
var _paint_m: StandardMaterial3D

var zone := "plaza"
var zone_lights := {"plaza": [], "lush": [], "train": []}
var _entry := ""                # note | lynx | emmet
var _force: Array = []          # selftest: forced choice indices, in order
var _talker := ""
var _busy := false
var _ended := false
var _in_meeting := false
var _monolith_on := false
var _walked_out := false
var _double_closer := 0
var _t2 := 0.0
var _click_t := 0.0

var turan: Node3D
var forner: Node3D
var emmet: Node3D
var dufredy: Node3D
var tyson: Node3D
var vendor: Node3D
var double: Node3D
var eyeless: Node3D
var _eyeless_home := Vector3.ZERO
var mira_k: Node3D
var copy_k: Node3D
var forner_f: Node3D
var water: MeshInstance3D
var people: Array = []          # [{fig, mode, phase}] idle / kneel / walkers
var walkers: Array = []         # [{fig, pts, i, speed, phase}]
var movers: Array = []          # scripted walks: [{fig, path, i, speed}]
var slot_screens: Array = []    # MeshInstance3D, their material swaps with the frames
var _reel_plain: StandardMaterial3D
var _reel_eyes: StandardMaterial3D
var _frames_seen := false
var scr: Dictionary = {}        # the monolith screen's states: ad / chat / msg / kids / black
var scr_light: OmniLight3D
var _load_bar: MeshInstance3D
var police: Node3D
var strips: Array = []          # tunnel lights past the train windows
var train_speed := 0.0
var train_doors: Array = []
var dispenser_ap: AudioStreamPlayer3D
var _engine_ap: AudioStreamPlayer
var _duck := {}
var _duf_ap: AudioStreamPlayer
var traffic: Node3D
var card_rect: ColorRect
var card_text: RichTextLabel
var panel_box: HBoxContainer


func L(beat: String, key: String) -> String:
	return str(LINES[beat][key])


## Plays a list of [who, text] lines; who "" is Carl thinking.
func _play(lines: Array) -> void:
	for ln: Array in lines:
		_talker = str(ln[0])
		if ln[0] == "":
			await main.ui.think(str(ln[1]))
		else:
			await main.ui.say(str(ln[0]), str(ln[1]))
	_talker = ""


func _say(who: String, text: String) -> void:
	_talker = who
	await main.ui.say(who, text)


func _think(text: String) -> void:
	await main.ui.think(text)


## A choice; the selftest can queue the index it wants instead of the pump's.
func _pick(opts: Array) -> int:
	var i: int = await main.ui.choose(opts)
	if not _force.is_empty():
		i = int(_force.pop_front())
	return clampi(i, 0, opts.size() - 1)


# ------------------------------------------------------------------ build

func build(m: Node) -> void:
	main = m
	rng.seed = 1920
	kit_day = false
	step_db = -15.0
	card = str(LINES["card"])
	spawn = SPAWN
	spawn_yaw = 0.0
	_pave = pbr("paving", Vector3(1, 1, 1) / 2.4, true, Color(0.5, 0.46, 0.47), 0.32)
	_stone = pbr("concrete", Vector3(1, 1, 1) / 3.5, true, Color(0.62, 0.34, 0.24), 1.0)
	_stone2 = pbr("plaster", Vector3(1, 1, 1) / 4.0, true, Color(0.5, 0.26, 0.17), 1.0)
	_wood = pbr("woodfloor", Vector3(1, 1, 1) / 1.6, true, Color(0.75, 0.5, 0.36), 0.7)
	_wood_dark = pbr("woodfloor", Vector3(1, 1, 1) / 1.2, true, Color(0.42, 0.24, 0.16), 0.55)
	_lacquer = pbr("plaster", Vector3(1, 1, 1) / 2.0, true, Color(0.45, 0.07, 0.06), 0.45)
	_metal = mat(Color(0.25, 0.26, 0.28), 0.45, 0.6)
	_dark = mat(Color(0.05, 0.05, 0.06), 0.6, 0.2)
	_void_m = StandardMaterial3D.new()
	_void_m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_void_m.albedo_color = Color(0, 0, 0)
	_void_m.disable_fog = true
	_paint_m = mat(Color(0.62, 0.04, 0.03), 0.06, 0.1)
	_ground()
	_pillar()
	_park()
	_blocks()
	_casino()
	_alley()
	_club()
	_subway()
	_lushons_front()
	_lushons_room()
	_street()
	_skyline()
	_bounds()
	_batch(self, 40.0, true)
	# what moves, lights or changes, after the batch
	_screen()
	_lights()
	_people()
	_cast()
	_dufredy()
	_the_double()
	_the_eyeless()
	_train()
	_kidtok_set()
	_forner_set()
	_overlay()
	traffic = TrafficS.new()
	traffic.lanes = [[49.0, 7.0, 1.0], [53.0, 10.5, -1.0], [56.0, 14.0, 1.0], [47.0, 19.0, -1.0], [-46.0, 24.0, 1.0]]
	traffic.along_x = true
	traffic.s_min = -140.0
	traffic.s_max = 140.0
	traffic.count = 9
	traffic.tower_top = Vector3(60, 420, -700)
	traffic.drone_box = AABB(Vector3(-200, 30, -200), Vector3(400, 80, 260))
	traffic.drone_count = 150
	add_child(traffic)
	traffic.setup(m, self)
	_set_zone("plaza")


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	# a hot night over the plaza: violet overhead, the horizon red from the
	# signs and the sandstone, the fog warm and thin
	var psm := ProceduralSkyMaterial.new()
	psm.sky_top_color = Color(0.015, 0.01, 0.04)
	psm.sky_horizon_color = Color(0.3, 0.07, 0.12)
	psm.ground_horizon_color = Color(0.25, 0.06, 0.1)
	psm.ground_bottom_color = Color(0.02, 0.01, 0.015)
	psm.sky_curve = 0.09
	env.sky.sky_material = psm
	env.ambient_light_color = Color(0.3, 0.22, 0.34)
	env.ambient_light_energy = 0.42
	env.fog_light_color = Color(0.2, 0.08, 0.13)
	env.fog_density = 0.0042
	env.fog_sky_affect = 0.3
	env.tonemap_exposure = 1.15
	env.glow_intensity = 1.0
	env.glow_bloom = 0.05
	env.glow_hdr_threshold = 0.85
	sun.light_color = Color(0.55, 0.45, 0.8)
	sun.light_energy = 0.14
	sun.rotation = Vector3(deg_to_rad(-55), deg_to_rad(30), 0)


func hifi(env: Environment, _sun: DirectionalLight3D) -> void:
	env.volumetric_fog_density *= 0.7
	env.ssr_max_steps = 64


func ambience() -> void:
	# sober: no music from the clubs; the hum of the screen, the wind
	# between the blocks, and the traffic overhead
	main.loop("wind", -22.0)
	main.loop("hum", -18.0, SCREEN_C + Vector3(0, -8, 3), 6.0, 40.0)
	main.loop("hum", -20.0, Vector3(-46.0, 2.0, 11.0), 3.0, 14.0)
	main.loop("static", -26.0, Vector3(54.0, 1.4, 0.0), 2.0, 12.0)
	main.loop("room", -12.0, Vector3(-8.0, 2.0, -52.0), 6.0, 16.0)
	dispenser_ap = AudioStreamPlayer3D.new()
	dispenser_ap.stream = main.sfx["tap"]
	dispenser_ap.position = Vector3(-1.6, 1.3, -47.2)
	dispenser_ap.unit_size = 2.0
	dispenser_ap.max_distance = 12.0
	dispenser_ap.volume_db = -10.0
	add_child(dispenser_ap)
	_engine_ap = AudioStreamPlayer.new()
	_engine_ap.stream = main.sfx["engine"]
	_engine_ap.volume_db = -60.0
	_engine_ap.pitch_scale = 0.55
	add_child(_engine_ap)
	_duf_ap = AudioStreamPlayer.new()
	_duf_ap.stream = _dufredy_sound()
	_duf_ap.volume_db = -60.0
	add_child(_duf_ap)


## Dufredy's entrance (bible-5 cue dufredy_entrance): the lullaby (sol-mi-la,
## 70 bpm, then a step lower) built forward and reversed, the hymn sample
## reversed under it, and a sub drone that swells and never resolves.
func _dufredy_sound() -> AudioStreamWAV:
	var rate := float(SynthS.RATE)
	var beat := 60.0 / 70.0
	var notes := [[392.0, 1.0], [329.63, 1.0], [440.0, 2.0], [349.23, 1.0], [293.66, 1.0], [392.0, 2.5]]
	var total := 0.0
	for n: Array in notes:
		total += float(n[1]) * beat
	total += 1.2
	var s: PackedFloat32Array = SynthS._buf(total)
	var i := 0
	for n: Array in notes:
		var f := float(n[0])
		var len_s := float(n[1]) * beat
		var cnt := int(len_s * rate)
		for j in cnt:
			if i >= s.size():
				break
			var t := float(j) / rate
			var env := minf(1.0, t * 5.0) * minf(1.0, (len_s - t) * 3.0)
			var vib := 1.0 + 0.005 * sin(TAU * 5.0 * t)
			s[i] = (sin(TAU * f * vib * t) * 0.55 + sin(TAU * f * 2.0 * t) * 0.18 + sin(TAU * f * 0.5 * t) * 0.12) * env * 0.42
			i += 1
	# reverse it: the swell comes before the note, and every note is cut off
	var n_s := s.size()
	for k in n_s / 2:
		var tmp := s[k]
		s[k] = s[n_s - 1 - k]
		s[n_s - 1 - k] = tmp
	var hymn: AudioStreamWAV = main.sfx.get("chant")
	var hd := PackedByteArray()
	if hymn:
		hd = hymn.data
	var hn := hd.size() / 2
	for k in n_s:
		var t := float(k) / rate
		var v := s[k]
		if hn > 0:
			var idx := hn - 1 - (k % hn)
			v += float(hd.decode_s16(idx * 2)) / 32000.0 * 0.3
		var swell := 0.55 + 0.45 * sin(TAU * t / total - PI / 2.0)
		v += (sin(TAU * 34.0 * t) * 0.42 + sin(TAU * 51.0 * t) * 0.16 + sin(TAU * 33.2 * t) * 0.2) * swell
		s[k] = v * 0.8
	return SynthS._wav(s, true)


# ------------------------------------------------------------------ the plaza floor

## Rects covering `area` minus `holes` (all in x/z), for floors with stair holes.
func _rects(area: Rect2, holes: Array) -> Array:
	var xs := [area.position.x, area.end.x]
	for h: Rect2 in holes:
		for x: float in [h.position.x, h.end.x]:
			if x > area.position.x and x < area.end.x:
				xs.append(x)
	xs.sort()
	var out := []
	for i in xs.size() - 1:
		var xa: float = xs[i]
		var xb: float = xs[i + 1]
		if xb - xa < 0.01:
			continue
		var zs := [area.position.y, area.end.y]
		for h: Rect2 in holes:
			if h.position.x < xb and h.end.x > xa:
				for z: float in [h.position.y, h.end.y]:
					if z > area.position.y and z < area.end.y:
						zs.append(z)
		zs.sort()
		for j in zs.size() - 1:
			var za: float = zs[j]
			var zb: float = zs[j + 1]
			if zb - za < 0.01:
				continue
			var c := Vector2((xa + xb) / 2.0, (za + zb) / 2.0)
			var inside := false
			for h: Rect2 in holes:
				if h.has_point(c):
					inside = true
			if not inside:
				out.append(Rect2(xa, za, xb - xa, zb - za))
	return out


func _floor(r: Rect2, y: float, m: Material) -> void:
	floor_quad(r.size, Vector3(r.get_center().x, y, r.get_center().y), 0.0, m)


func _ground() -> void:
	solid_box(Vector3(700, 2, 700), Vector3(0, -1.0, 0))
	var pm := PlaneMesh.new()
	pm.size = Vector2(900, 900)
	mesh(pm, Vector3(0, -0.04, 0), mat(Color(0.04, 0.035, 0.04)))
	for r: Rect2 in _rects(Rect2(-40, -40, 80, 84), [SUB_HOLE, CLUB_HOLE]):
		_floor(r, 0.0, _pave)
	# the casino and Lushon's have their own floors; the alley is asphalt
	var asphalt := pbr("asphalt", Vector3(1, 1, 1) / 4.0, true, Color(0.55, 0.55, 0.58), 0.35)
	_floor(Rect2(-150, 46, 300, 10), 0.0, asphalt)
	_floor(Rect2(40, ALLEY_Z.x, ALLEY_END - 40, ALLEY_Z.y - ALLEY_Z.x), 0.0, asphalt)
	_floor(Rect2(-150, 44, 300, 2), 0.06, _pave)
	_floor(Rect2(-150, 56, 300, 4), 0.06, _pave)
	var line := mat(Color(0.55, 0.5, 0.35), 0.5)
	var x := -146.0
	while x < 146.0:
		box(Vector3(3.0, 0.01, 0.14), Vector3(x, 0.012, 51.0), line)
		x += 8.0
	# the wet: puddles from the sweepers, black glass on the paving
	var wet := mat(Color(0.17, 0.11, 0.17), 0.08, 0.0)
	for k in 34:
		var p := Vector3(rng.randf_range(-38, 38), 0.014, rng.randf_range(-38, 43))
		if SUB_HOLE.grow(1.0).has_point(Vector2(p.x, p.z)) or CLUB_HOLE.grow(1.0).has_point(Vector2(p.x, p.z)):
			continue
		if Vector2(p.x - P.x, p.z - P.z).length() < 8.0:
			continue
		floor_quad(Vector2(rng.randf_range(1.2, 4.5), rng.randf_range(0.8, 3.0)), p, rng.randf() * TAU, wet)
	for k in 10:
		floor_quad(Vector2(rng.randf_range(1.0, 3.0), rng.randf_range(0.6, 1.6)), Vector3(rng.randf_range(-120, 120), 0.014, rng.randf_range(47, 55)), rng.randf() * TAU, wet)


# ------------------------------------------------------------------ the pillar (ch.19)

func _pillar() -> void:
	var seam := mat(Color(0.28, 0.09, 0.06), 0.9)
	var dims := [[12.4, 10.4, 6.0], [12.0, 10.0, 9.0], [11.6, 9.8, 8.0], [11.1, 9.3, 10.0], [10.5, 8.9, 9.0],
		[9.7, 8.3, 8.0], [8.8, 7.5, 7.0], [7.4, 6.4, 5.0]]
	var y := 0.0
	for k in dims.size():
		var d: Array = dims[k]
		var b := box(Vector3(d[0], d[2], d[1]), P + Vector3(rng.randf_range(-0.25, 0.25), y + float(d[2]) / 2.0, rng.randf_range(-0.15, 0.15)), _stone if k % 2 == 0 else _stone2)
		b.rotation.y = rng.randf_range(-0.035, 0.035)
		box(Vector3(float(d[0]) + 0.12, 0.22, float(d[1]) + 0.12), P + Vector3(0, y + float(d[2]), 0), seam)
		y += float(d[2])
	# the ragged crown, weathered blocks against the sky
	for k in 6:
		var s := Vector3(rng.randf_range(1.5, 3.4), rng.randf_range(1.0, 3.5), rng.randf_range(1.5, 3.0))
		var cb := box(s, P + Vector3(rng.randf_range(-2.4, 2.4), y + s.y / 2.0, rng.randf_range(-2.0, 2.0)), _stone2)
		cb.rotation = Vector3(rng.randf_range(-0.1, 0.1), rng.randf() * TAU, rng.randf_range(-0.1, 0.1))
	# erosion grooves down the faces
	for k in 14:
		var side := -1.0 if k % 2 == 0 else 1.0
		var gx := rng.randf_range(-5.0, 5.0)
		var gh := rng.randf_range(8.0, 30.0)
		box(Vector3(0.18, gh, 0.12), P + Vector3(gx, rng.randf_range(4.0, 40.0), side * 5.12), seam)
	solid_box(Vector3(12.6, 10, 10.6), P + Vector3(0, 5, 0))
	# the plaque, and the eye sprayed over it
	box(Vector3(1.8, 1.0, 0.1), P + Vector3(-3.4, 1.3, 5.24), mat(Color(0.48, 0.36, 0.18), 0.35, 0.85))
	var eye := Sprite3D.new()
	eye.texture = _glyph_tex
	eye.pixel_size = 0.009
	eye.shaded = true
	eye.modulate = Color(0.06, 0.02, 0.02)
	eye.position = P + Vector3(-3.4, 1.35, 5.31)
	add_child(eye)
	_glyph_on(P + Vector3(-3.4, 1.35, 5.36), 0.0, 0.0085, "plaque", false, false, L("plaza", "plaque_glyph"))
	interactable("pillar", "The red pillar", P + Vector3(3.6, 1.6, 5.4), Vector3(4.0, 3.0, 0.5), "RED ROCK\nsandstone, one piece\nquarried before the city", false)
	# the screen's frame, bolted to the south face; the screen itself is built after the batch
	box(Vector3(15.8, 9.6, 0.6), SCREEN_C + Vector3(0, 0, -0.32), _dark)
	for sx: float in [-6.5, 6.5]:
		for sy: float in [-3.6, 3.6]:
			box(Vector3(0.5, 0.5, 0.5), SCREEN_C + Vector3(sx, sy, -0.75), _metal)
	box(Vector3(16.4, 0.4, 0.9), SCREEN_C + Vector3(0, -5.0, -0.5), _metal)
	# the paved round at its foot, and the kneelers' candles
	cyl(8.0, 8.0, 0.08, P + Vector3(0, 0.04, 0), _pave, 32)


# ------------------------------------------------------------------ the park

func _park() -> void:
	var curb := pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.5, 0.48, 0.47), 0.8)
	var grass := pbr("grass", Vector3(1, 1, 1) / 3.0, true, Color(0.45, 0.5, 0.42), 1.0)
	var bark := pbr("bark", Vector3(1, 1, 1) / 1.5, true)
	var leaves := [mat(Color(0.1, 0.17, 0.09), 0.9), mat(Color(0.14, 0.2, 0.1), 0.9)]
	for sx: float in [-1.0, 1.0]:
		for sz: float in [-1.0, 1.0]:
			var c := P + Vector3(sx * 11.0, 0, sz * 11.0)
			box(Vector3(11.0, 0.45, 11.0), c + Vector3(0, 0.225, 0), curb, true)
			floor_quad(Vector2(10.4, 10.4), c + Vector3(0, 0.46, 0), 0.0, grass)
			tree(c + Vector3(sx * -1.5, 0.45, sz * 1.8), rng.randf_range(4.5, 6.0), bark, leaves)
			# benches along the paths, facing them
			for k in 2:
				var bp := c + Vector3(-sx * 6.2, 0, (k - 0.5) * 6.0)
				_bench(bp, PI / 2.0 if sx > 0.0 else -PI / 2.0)
	interactable("tree", "The tree", P + Vector3(9.5, 1.4, -9.2), Vector3(1.2, 2.8, 1.2), "", false)
	interactable("bench", "The bench", P + Vector3(-4.8, 0.6, 14.0), Vector3(0.8, 1.0, 2.0), "", false)


func _bench(p: Vector3, ry: float) -> void:
	var bw := pbr("woodfloor", Vector3(1, 1, 1) / 1.0, true, Color(0.5, 0.36, 0.26), 0.5)
	var root := Basis(Vector3.UP, ry)
	for k in 3:
		var sl := box(Vector3(2.0, 0.05, 0.12), p + root * Vector3(0, 0.46, -0.2 + k * 0.14), bw)
		sl.rotation.y = ry
	var bk := box(Vector3(2.0, 0.4, 0.05), p + root * Vector3(0, 0.75, 0.16), bw)
	bk.rotation.y = ry
	bk.rotation.x = 0.0
	for sx: float in [-0.85, 0.85]:
		var lg := box(Vector3(0.06, 0.46, 0.4), p + root * Vector3(sx, 0.23, 0), _metal)
		lg.rotation.y = ry
	solid_box(Vector3(2.0, 0.8, 0.5), p + Vector3(0, 0.4, 0)).rotation.y = ry


# ------------------------------------------------------------------ the blocks round the plaza

## A row of city blocks along `dir` from `start`, facing rot_y, leaving gaps
## (in metres along the row) for the places built by hand.
func _row(start: Vector3, dir: Vector3, length: float, rot_y: float, gaps: Array, lod := 0, hmin := 18.0, hmax := 62.0) -> void:
	var s := 0.0
	while s < length - 4.0:
		var in_gap := false
		for g: Vector2 in gaps:
			if s >= g.x - 0.01 and s < g.y:
				s = g.y
				in_gap = true
		if in_gap:
			continue
		var w := rng.randf_range(10.0, 18.0)
		w = minf(w, length - s)
		for g: Vector2 in gaps:
			if s < g.x and s + w > g.x:
				w = g.x - s
		if length - (s + w) < 5.0:
			w = length - s
		if w < 4.0:
			s += w
			continue
		var h := rng.randf_range(hmin, hmax)
		if rng.randf() < 0.22:
			h = rng.randf_range(70.0, 115.0)
		cyber_block(start + dir * (s + w / 2.0), rot_y, w, h, 22.0, true, lod)
		s += w


func _blocks() -> void:
	_row(Vector3(-40, 0, -40), Vector3(0, 0, 1), 84.0, PI / 2.0, [Vector2(44.0, 58.0)])
	_row(Vector3(40, 0, -40), Vector3(0, 0, 1), 84.0, -PI / 2.0, [Vector2(37.0, 43.0)])
	_row(Vector3(-40, 0, -40), Vector3(1, 0, 0), 80.0, 0.0, [Vector2(24.0, 40.0)])
	_row(Vector3(-150, 0, 60), Vector3(1, 0, 0), 300.0, PI, [])
	_row(Vector3(-150, 0, 44), Vector3(1, 0, 0), 88.0, 0.0, [], 1)
	_row(Vector3(62, 0, 44), Vector3(1, 0, 0), 88.0, 0.0, [], 1)
	# skybridges and cables over the plaza, the way the Spine has them
	skybridge(Vector3(-40.0, 31.0, -26.0), Vector3(-26.0, 33.0, -40.0), 4.0)
	skybridge(Vector3(26.0, 24.0, -40.0), Vector3(40.0, 22.0, -28.0), 3.5)
	skybridge(Vector3(-24.0, 27.0, 44.0), Vector3(-24.0, 28.0, 60.0), 4.0)
	skybridge(Vector3(30.0, 36.0, 44.0), Vector3(30.0, 35.0, 60.0), 4.0)
	skybridge(Vector3(50.0, 17.0, ALLEY_Z.x), Vector3(50.0, 17.5, ALLEY_Z.y), 2.5)
	for k in 9:
		var a := Vector3(-39.8, rng.randf_range(9.0, 18.0), rng.randf_range(-36.0, 40.0))
		var b := Vector3(39.8, rng.randf_range(9.0, 18.0), rng.randf_range(-36.0, 40.0))
		if k % 3 == 0:
			b = Vector3(rng.randf_range(-36.0, 36.0), rng.randf_range(10.0, 18.0), -39.8)
		cable(a, b, rng.randf_range(1.5, 3.5))
	for k in 6:
		var y := rng.randf_range(5.0, 11.0)
		cable(Vector3(40.2, y, ALLEY_Z.x + 0.05), Vector3(40.2 + rng.randf_range(4, 20), y + rng.randf_range(-1, 1), ALLEY_Z.y - 0.05), 0.4)
	# holograms hanging over the plaza
	kit_holo(Vector3(-30.0, 22.0, -8.0), PI / 2.0 - 0.4, "KID TOK", "watch them grow", Color(1.0, 0.3, 0.7), 12.0)
	kit_holo(Vector3(30.0, 26.0, 18.0), -PI / 2.0 + 0.35, "SALTECH", "your body, optimized", Color(0.3, 0.95, 1.0), 13.0)
	kit_holo(Vector3(14.0, 30.0, -36.0), 0.15, "NIXTRA", "a new flavour: CINNAMON", Color(1.0, 0.55, 0.15), 14.0)
	kit_holo(Vector3(-12.0, 18.0, 40.0), PI - 0.2, "PSYON", "the pillow for those who dream", PSYON_GREEN, 12.0)


func _skyline() -> void:
	# the second ring of towers behind the blocks, and the tower itself
	_row(Vector3(-120, 0, -90), Vector3(1, 0, 0), 240.0, 0.0, [], 1, 60.0, 140.0)
	_row(Vector3(-140, 0, -150), Vector3(1, 0, 0), 280.0, 0.0, [], 1, 80.0, 170.0)
	_row(Vector3(-100, 0, -60), Vector3(0, 0, 1), 110.0, PI / 2.0, [], 1, 50.0, 120.0)
	_row(Vector3(100, 0, -60), Vector3(0, 0, 1), 110.0, -PI / 2.0, [], 1, 50.0, 120.0)
	_row(Vector3(-160, 0, 110), Vector3(1, 0, 0), 320.0, PI, [], 1, 50.0, 130.0)
	var tw := Vector3(60, 0, -700)
	var dark := mat(Color(0.03, 0.03, 0.04), 0.4, 0.5)
	box(Vector3(70, 380, 70), tw + Vector3(0, 190, 0), dark)
	box(Vector3(46, 90, 46), tw + Vector3(0, 425, 0), dark)
	cyl(0.6, 3.0, 60.0, tw + Vector3(0, 500, 0), dark, 8)
	var g := glow(Color(0.3, 0.95, 1.0), 3.0)
	for k in 26:
		box(Vector3(70.4, 0.6, 70.4), tw + Vector3(0, 14.0 + k * 14.0, 0), g)
	var bl := box(Vector3(3, 3, 3), tw + Vector3(0, 532, 0), glow(Color(1, 0.05, 0.05), 6.0))
	blinkers.append(bl)


func _bounds() -> void:
	solid_box(Vector3(2, 30, 40), Vector3(-151, 15, 50))
	solid_box(Vector3(2, 30, 40), Vector3(151, 15, 50))
	solid_box(Vector3(300, 30, 2), Vector3(0, 15, 59.5))
	solid_box(Vector3(2, 10, ALLEY_Z.y - ALLEY_Z.x), Vector3(ALLEY_END - 1.0, 5, 0))


# ------------------------------------------------------------------ small builders

## Lettering as a mesh in any material (a dead tube is just dark glass).
func _text(text: String, pos: Vector3, rot_y: float, h: float, m: Material) -> MeshInstance3D:
	var tm := TextMesh.new()
	tm.text = text
	tm.font_size = 32
	tm.pixel_size = h / 32.0
	tm.depth = 0.0
	tm.curve_step = 2.5
	var mi := mesh(tm, pos, m)
	mi.rotation.y = rot_y
	return mi


## Painted words on a wall: spray paint, wet or dry. Label3D, lit by the room.
func _paint(text: String, pos: Vector3, rot_y: float, px: float, c: Color) -> Label3D:
	var l := Label3D.new()
	l.text = text
	l.position = pos
	l.rotation.y = rot_y
	l.pixel_size = px
	l.font_size = 96
	l.outline_size = 0
	l.modulate = c
	l.shaded = true
	l.double_sided = false
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	add_child(l)
	return l


## The eye, sprayed: the glyph's two rings as paint, not as a reading.
func _sprayed(pos: Vector3, rot_y: float, px: float, c: Color) -> void:
	var s := Sprite3D.new()
	s.texture = _glyph_tex
	s.pixel_size = px
	s.shaded = true
	s.modulate = c
	s.position = pos
	s.rotation.y = rot_y
	s.double_sided = false
	add_child(s)


func _railing(a: Vector3, b: Vector3) -> void:
	var n := maxi(1, int(a.distance_to(b) / 1.6))
	for k in n + 1:
		var p := a.lerp(b, float(k) / n)
		stick(p, p + Vector3(0, 1.05, 0), 0.025, _metal)
	stick(a + Vector3(0, 1.05, 0), b + Vector3(0, 1.05, 0), 0.03, _metal)
	stick(a + Vector3(0, 0.55, 0), b + Vector3(0, 0.55, 0), 0.02, _metal)


## Reels for a slot machine screen: cherries, a bar, a seven, or three eyes.
func _reels(eyes: bool) -> StandardMaterial3D:
	var img := Image.create(96, 48, false, Image.FORMAT_RGBA8)
	img.fill(Color(0.92, 0.88, 0.8))
	for k in 3:
		var cx := 16.0 + k * 32.0
		Body._rect(img, k * 32.0 - 1.0, 0, 2, 48, Color(0.1, 0.08, 0.08))
		if eyes:
			Body._ell(img, cx, 24, 13, 8, Color(0.98, 0.96, 0.9))
			Body._ell(img, cx, 24, 7, 7, Color(0.75, 0.08, 0.06))
			Body._ell(img, cx, 24, 1.6, 6, Color(0.0, 0.0, 0.0))
			Body._line(img, cx - 13, 24, cx - 6, 17, Color(0.5, 0.05, 0.05), 1)
		elif k == 0:
			Body._ell(img, cx - 5, 30, 6, 6, Color(0.85, 0.05, 0.08))
			Body._ell(img, cx + 6, 28, 6, 6, Color(0.85, 0.05, 0.08))
			Body._line(img, cx - 5, 24, cx + 2, 10, Color(0.1, 0.5, 0.15), 2)
			Body._line(img, cx + 6, 22, cx + 2, 10, Color(0.1, 0.5, 0.15), 2)
		elif k == 1:
			Body._rect(img, cx - 11, 17, 22, 14, Color(0.08, 0.08, 0.1))
			Body._rect(img, cx - 8, 22, 16, 4, Color(0.9, 0.8, 0.3))
		else:
			Body._line(img, cx - 9, 12, cx + 9, 12, Color(0.85, 0.05, 0.08), 4)
			Body._line(img, cx + 9, 12, cx - 3, 38, Color(0.85, 0.05, 0.08), 4)
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.albedo_texture = ImageTexture.create_from_image(img)
	m.albedo_color = Color(0.85, 0.82, 0.8)
	return m


# ------------------------------------------------------------------ the casino (ch.19)

func _casino() -> void:
	var wall := pbr("plaster", Vector3(1, 1, 1) / 2.0, true, Color(0.26, 0.2, 0.22), 0.8)
	var carpet := pbr("carpet", Vector3(1, 1, 1) / 1.5, true, Color(0.5, 0.12, 0.14), 1.0)
	var cx := CAS.get_center().x
	var cz := CAS.get_center().y
	floor_quad(CAS.size, Vector3(cx, 0.01, cz), 0.0, carpet)
	box(Vector3(0.3, 4.6, CAS.size.y), Vector3(CAS.position.x - 0.15, 2.3, cz), wall, true)
	box(Vector3(CAS.size.x, 4.6, 0.3), Vector3(cx, 2.3, CAS.position.y - 0.15), wall, true)
	box(Vector3(CAS.size.x, 4.6, 0.3), Vector3(cx, 2.3, CAS.end.y + 0.15), wall, true)
	var fx := CAS.end.x
	box(Vector3(0.3, 4.6, CAS_DOOR.x - CAS.position.y), Vector3(fx + 0.15, 2.3, (CAS.position.y + CAS_DOOR.x) / 2.0), wall, true)
	box(Vector3(0.3, 4.6, CAS.end.y - CAS_DOOR.y), Vector3(fx + 0.15, 2.3, (CAS_DOOR.y + CAS.end.y) / 2.0), wall, true)
	box(Vector3(0.3, 1.9, CAS_DOOR.y - CAS_DOOR.x), Vector3(fx + 0.15, 3.65, (CAS_DOOR.x + CAS_DOOR.y) / 2.0), wall, true)
	box(Vector3(CAS.size.x, 0.2, CAS.size.y), Vector3(cx, 4.5, cz), _dark)
	var k := _kit_mats()
	box(Vector3(CAS.size.x, 20.0, CAS.size.y), Vector3(cx, 14.6, cz), k["walls"][1], true)
	cyber_dress(Vector3(fx, 0, cz), PI / 2.0, CAS.size.y, 24.6, 0, false)
	# the sign: CASINO with its last three letters dead, LUCKY still lit for nobody
	var pink := glow(Color(1.0, 0.25, 0.55), 2.6)
	_text("CAS", Vector3(fx + 0.2, 3.25, cz + 0.85), PI / 2.0, 0.85, pink)
	_text("INO", Vector3(fx + 0.2, 3.25, cz - 0.85), PI / 2.0, 0.85, mat(Color(0.12, 0.06, 0.08), 0.3, 0.2))
	_text("LUCKY", Vector3(fx + 0.2, 2.75, cz + 3.6), PI / 2.0, 0.32, glow(Color(1.0, 0.75, 0.2), 2.2))
	interactable("casino", "The casino", Vector3(fx + 0.4, 3.0, cz), Vector3(0.6, 1.2, 4.5), "LUCKY 8 CASINO\npayouts: SUSPENDED\nlast spin: 00:00:41 ago", false)
	_reel_plain = _reels(false)
	_reel_eyes = _reels(true)
	# the lit machines under the far wall, and two more by the door
	for z: float in [6.6, 9.0, 11.4]:
		_slot(Vector3(CAS.position.x + 0.7, 0, z), PI / 2.0, true, "")
	for x: float in [-46.6, -44.6, -42.6]:
		_slot(Vector3(x, 0, CAS.end.y - 0.7), PI, true, "")
	# the four switched off, numbered under the eye
	var nums := ["0", "1", "2", "4"]
	for i in 4:
		_slot(Vector3(-50.0 + i * 2.0, 0, CAS.position.y + 0.7), 0.0, false, nums[i])
	interactable("slots", "The slot machines", Vector3(CAS.position.x + 0.9, 1.2, 9.0), Vector3(0.9, 2.0, 7.0), "SLOT BANK A\nPSYON RNG\nwinning line: 3 x EYE", false)
	interactable("dark_slots", "The switched-off machines", Vector3(-47.0, 1.2, CAS.position.y + 0.9), Vector3(7.5, 2.0, 0.9), "SLOT BANK C\npower: PULLED\nmarked: 0 1 2 4", false)
	# the cashier's cage in the corner by the far wall
	var cage_c := Vector3(-50.3, 0, 16.1)
	box(Vector3(3.4, 1.1, 0.5), cage_c + Vector3(0.3, 0.55, -1.6), _wood_dark, true)
	for i in 15:
		var bx := cage_c.x - 1.4 + i * 0.24
		stick(Vector3(bx, 1.1, cage_c.z - 1.6), Vector3(bx, 3.0, cage_c.z - 1.6), 0.012, _metal)
	box(Vector3(3.5, 0.08, 0.08), Vector3(cage_c.x + 0.3, 3.0, cage_c.z - 1.6), _metal)
	box(Vector3(0.5, 0.35, 0.02), Vector3(cage_c.x, 1.9, cage_c.z - 1.62), mat(Color(0.9, 0.88, 0.8), 0.9))
	_text("000", Vector3(cage_c.x + 1.0, 1.22, cage_c.z - 1.86), PI, 0.12, glow(Color(1.0, 0.2, 0.1), 2.0))
	interactable("cage", "The cashier's cage", cage_c + Vector3(0.3, 1.2, -1.6), Vector3(3.4, 2.2, 0.6), "CASHIER\ncredits: 0\nstaff: NONE", false)
	# the stool, the drink still on the tray
	var st := cyl(0.2, 0.2, 0.08, Vector3(-41.6, 0.2, 15.8), mat(Color(0.5, 0.08, 0.1), 0.6))
	st.rotation.z = 1.45
	stick(Vector3(-41.2, 0.2, 15.8), Vector3(-40.6, 0.22, 15.6), 0.03, _metal)
	cyl(0.04, 0.035, 0.12, Vector3(-42.6, 0.98, 16.85), mat(Color(0.7, 0.45, 0.2, 1.0), 0.1), 8)
	interactable("stool", "The stool", Vector3(-41.6, 0.4, 15.8), Vector3(1.0, 0.8, 1.0), "", false)
	# the scripture on the far wall above the machines, the paint still wet
	var red := Color(0.72, 0.04, 0.03)
	_paint("The god who answers.\nThe god within the waves.\nSin distracts within an eyeless sea.", Vector3(CAS.position.x + 0.02, 3.35, 9.0), PI / 2.0, 0.0036, red)
	for i in 16:
		var dz := rng.randf_range(5.4, 12.6)
		var ln := rng.randf_range(0.1, 0.6)
		box(Vector3(0.012, ln, 0.025), Vector3(CAS.position.x + 0.015, 2.85 - ln / 2.0, dz), _paint_m)
	box(Vector3(0.012, 2.6, 0.03), Vector3(CAS.position.x + 0.015, 1.55, 12.55), _paint_m)
	floor_quad(Vector2(0.18, 0.12), Vector3(CAS.position.x + 0.15, 0.015, 12.55), 0.3, _paint_m)
	interactable("scripture", "The words on the wall", Vector3(CAS.position.x + 0.2, 3.3, 9.0), Vector3(0.4, 1.6, 7.6), "PAINT  -  acrylic + ?\nstatus: WET\napplied: < 1 h", false)
	# the eye, everywhere inside
	for i in 14:
		var side := i % 3
		var ry := 0.0
		var pp := Vector3.ZERO
		if side == 0:
			pp = Vector3(rng.randf_range(-51.0, -41.0), rng.randf_range(2.2, 4.1), CAS.position.y + 0.02)
			ry = 0.0
		elif side == 1:
			pp = Vector3(rng.randf_range(-51.0, -41.0), rng.randf_range(2.2, 4.1), CAS.end.y - 0.02)
			ry = PI
		else:
			pp = Vector3(fx - 0.02, rng.randf_range(1.0, 4.0), rng.randf_range(5.0, 9.0) if rng.randf() < 0.5 else rng.randf_range(13.0, 17.0))
			ry = -PI / 2.0
		_sprayed(pp, ry, rng.randf_range(0.004, 0.011), Color(0.08, 0.02, 0.02) if i % 2 == 0 else Color(0.6, 0.05, 0.04))
	_sprayed(Vector3(cx, 4.39, cz), 0.0, 0.02, Color(0.6, 0.05, 0.04))
	prop("mounted_fluorescent_lights", Vector3(-46.0, 4.38, 11.0), 0.0, 1.0, false)
	prop("mounted_fluorescent_lights", Vector3(-46.0, 4.38, 7.0), 0.0, 1.0, false)


## A slot machine: cabinet, topper, the reel screen, the arm. Front faces local +Z.
func _slot(p: Vector3, ry: float, lit: bool, num: String) -> void:
	var b := Basis(Vector3.UP, ry)
	var cab := mat(Color(0.35, 0.05, 0.08), 0.35, 0.5)
	var c := box(Vector3(0.82, 1.6, 0.66), p + Vector3(0, 0.8, 0), cab)
	c.rotation.y = ry
	solid_box(Vector3(0.82, 1.6, 0.66), p + Vector3(0, 0.8, 0)).rotation.y = ry
	var top := box(Vector3(0.82, 0.36, 0.5), p + b * Vector3(0, 1.78, -0.06), glow(Color(1.0, 0.3, 0.6), 1.6) if lit else _dark)
	top.rotation.y = ry
	var shelf := box(Vector3(0.74, 0.07, 0.26), p + b * Vector3(0, 0.95, 0.42), _metal)
	shelf.rotation.y = ry
	var scr_q := quad(Vector2(0.56, 0.34), p + b * Vector3(0, 1.2, 0.335), ry, _reel_plain if lit else _dark)
	if lit:
		no_batch.append(scr_q)
		slot_screens.append(scr_q)
	else:
		_sprayed(p + b * Vector3(0, 1.24, 0.345), ry, 0.0018, Color(0.95, 0.95, 0.92))
		var l := _paint(num, p + b * Vector3(0, 1.07, 0.345), ry, 0.0016, Color(0.95, 0.95, 0.92))
		l.shaded = false
		for cl in 3:
			cyl(0.07, 0.07, 0.05, p + b * Vector3(-0.15 + cl * 0.15, 1.63, -0.05), mat(Color(0.05, 0.05, 0.05), 0.6), 8)
	var a := p + b * Vector3(0.45, 1.0, 0.12)
	var a2 := p + b * Vector3(0.5, 1.48, 0.14)
	stick(a, a2, 0.022, _metal)
	sphere(0.05, a2, mat(Color(0.8, 0.05, 0.05), 0.3), 8)


# ------------------------------------------------------------------ the alley

func _alley() -> void:
	var brick := pbr("concrete", Vector3(1, 1, 1) / 1.5, true, Color(0.32, 0.26, 0.24), 0.9)
	box(Vector3(2.0, 14.0, ALLEY_Z.y - ALLEY_Z.x), Vector3(ALLEY_END - 1.0, 7.0, 0), brick)
	for p: Vector3 in [Vector3(60.6, 0, -2.2), Vector3(59.7, 0, -2.3)]:
		prop("metal_trash_can", p, rng.randf() * TAU, 1.0)
	prop("Barrel_01", Vector3(61.4, 0, 2.0), 0.3, 1.0)
	prop("cardboard_box_01", Vector3(57.2, 0, 2.3), 0.4, 1.4, false)
	prop("cardboard_box_01", Vector3(57.9, 0, 2.4), 1.1, 1.1, false)
	prop("plastic_crate_03", Vector3(47.5, 0, -2.4), 0.2, 1.0, false)
	prop("old_tyre", Vector3(49.2, 0, 2.3), 0.0, 1.0, false)
	prop("street_rat", Vector3(58.4, 0, -1.6), 2.2, 1.0, false)
	prop("exterior_aircon_unit", Vector3(46.0, 3.8, ALLEY_Z.x + 0.35), 0.0, 1.0, false)
	prop("exterior_aircon_unit", Vector3(52.5, 6.0, ALLEY_Z.y - 0.35), PI, 1.0, false)
	prop("exterior_aircon_unit", Vector3(58.0, 4.4, ALLEY_Z.x + 0.35), 0.0, 1.0, false)
	prop("modular_airduct_circular_01", Vector3(54.0, 8.5, ALLEY_Z.x + 0.4), 0.0, 1.0, false)
	# somebody's bed: flattened boxes and a blanket
	box(Vector3(2.0, 0.04, 0.9), Vector3(55.2, 0.03, 2.4), mat(Color(0.45, 0.34, 0.22), 1.0))
	box(Vector3(1.6, 0.12, 0.7), Vector3(55.4, 0.1, 2.4), pbr("fabric", Vector3(1, 1, 1), true, Color(0.3, 0.25, 0.32)))
	# the fire escape on the south wall
	for y: float in [4.0, 7.2, 10.4]:
		box(Vector3(4.0, 0.08, 1.0), Vector3(52.0, y, ALLEY_Z.y - 0.5), _metal)
		stick(Vector3(50.0, y + 1.0, ALLEY_Z.y - 1.0), Vector3(54.0, y + 1.0, ALLEY_Z.y - 1.0), 0.02, _metal)
	for y: float in [4.0, 7.2]:
		stick(Vector3(50.2, y, ALLEY_Z.y - 0.6), Vector3(53.6, y + 3.2, ALLEY_Z.y - 0.6), 0.03, _metal)
	# the second wall of graffiti, inside the alley mouth, on the north block's side
	_paint("The Mimic will come.\nThe divine mirror imprisons.\nFrom 0 to 1, from 1 to 2, from 2 to 4.", GRAF, 0.0, 0.0028, Color(0.9, 0.88, 0.84))
	_sprayed(GRAF + Vector3(-3.8, 0.4, 0.005), 0.0, 0.006, Color(0.75, 0.05, 0.04))
	var g := interactable("graffiti", "The graffiti", GRAF + Vector3(0, 0, 0.15), Vector3(6.2, 1.6, 0.3), "PAINT  -  aerosol\nstatus: DRY\napplied: 2 days ago", false)
	g.set_meta("route", "alley")
	var al := interactable("alley", "The alley", Vector3(41.2, 1.2, 0), Vector3(0.8, 2.4, 5.6), "", false)
	al.set_meta("route", "alley")


# ------------------------------------------------------------------ the basement club (dead)

func _club() -> void:
	var conc := pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.42, 0.4, 0.4), 0.7)
	var h := CLUB_HOLE
	var steps := 12
	for k in steps:
		var top := -k * 0.3
		var sz := h.end.y - k * (h.size.y / steps)
		box(Vector3(h.size.x, 3.9 + top, h.size.y / steps), Vector3(h.get_center().x, (-3.9 + top) / 2.0, sz - h.size.y / steps / 2.0), conc)
	for x: float in [h.position.x - 0.1, h.end.x + 0.1]:
		box(Vector3(0.2, 4.0, h.size.y), Vector3(x, -2.0, h.get_center().y), conc)
	box(Vector3(h.size.x + 0.4, 4.0, 0.2), Vector3(h.get_center().x, -2.0, h.position.y - 0.1), conc)
	box(Vector3(1.4, 2.2, 0.08), Vector3(h.get_center().x, -2.5, h.position.y + 0.02), mat(Color(0.3, 0.04, 0.06), 0.5, 0.3))
	_text("BASEMENT 9", Vector3(h.get_center().x, -1.0, h.position.y + 0.03), 0.0, 0.28, mat(Color(0.1, 0.05, 0.1), 0.3, 0.2))
	_railing(Vector3(h.position.x - 0.1, 0, h.end.y), Vector3(h.position.x - 0.1, 0, h.position.y))
	_railing(Vector3(h.end.x + 0.1, 0, h.end.y), Vector3(h.end.x + 0.1, 0, h.position.y))
	_railing(Vector3(h.position.x - 0.1, 0, h.position.y - 0.1), Vector3(h.end.x + 0.1, 0, h.position.y - 0.1))
	solid_box(Vector3(h.size.x, 2.4, h.size.y), Vector3(h.get_center().x, 1.2, h.get_center().y))
	var sign := _paint("FRAMES OFF", Vector3(h.end.x + 0.14, 0.8, h.end.y - 0.4), PI / 2.0, 0.0018, Color(0.95, 0.95, 0.9))
	sign.shaded = false
	box(Vector3(0.03, 0.26, 0.9), Vector3(h.end.x + 0.12, 0.8, h.end.y - 0.4), _dark)
	var c := interactable("club", "The club stairs", Vector3(h.get_center().x, 1.0, h.end.y + 0.3), Vector3(h.size.x, 2.0, 0.6), "BASEMENT 9\nlicence: SUSPENDED\noccupancy: 0", false)
	c.set_meta("route", "club")


# ------------------------------------------------------------------ the subway stairs (ch.19, ch.20)

func _subway() -> void:
	var conc := pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.5, 0.5, 0.52), 0.6)
	var h := SUB_HOLE
	var steps := 14
	for k in steps:
		var top := -k * 0.3
		var sz := h.position.y + k * (h.size.y / steps)
		box(Vector3(h.size.x, 4.4 + top, h.size.y / steps), Vector3(h.get_center().x, (-4.4 + top) / 2.0, sz + h.size.y / steps / 2.0), conc)
	for x: float in [h.position.x - 0.1, h.end.x + 0.1]:
		box(Vector3(0.2, 4.4, h.size.y), Vector3(x, -2.2, h.get_center().y), conc)
		_railing(Vector3(x, 0, h.position.y), Vector3(x, 0, h.end.y))
	_railing(Vector3(h.position.x - 0.1, 0, h.end.y + 0.1), Vector3(h.end.x + 0.1, 0, h.end.y + 0.1))
	box(Vector3(h.size.x + 0.4, 5.0, 0.3), Vector3(0, -2.0, h.end.y + 0.3), _dark)
	for x: float in [-1.6, -0.5, 0.6, 1.7]:
		box(Vector3(0.25, 1.0, 0.8), Vector3(x, -3.9, h.end.y - 0.9), _metal)
	solid_box(Vector3(h.size.x, 2.4, h.size.y), Vector3(0, 1.2, h.get_center().y))
	# the canopy and its sign
	for x: float in [-2.9, 2.9]:
		for z: float in [h.position.y - 0.6, h.end.y + 0.4]:
			cyl(0.08, 0.08, 3.4, Vector3(x, 1.7, z), _metal, 8)
	box(Vector3(6.2, 0.14, h.size.y + 1.2), Vector3(0, 3.45, h.get_center().y - 0.1), _kit_mats()["glass"])
	box(Vector3(6.2, 0.75, 0.22), Vector3(0, 3.0, h.position.y - 0.7), _dark)
	neon_text("RED ROCK LINE", Vector3(0, 3.0, h.position.y - 0.83), PI, 0.4, Color(0.2, 0.9, 1.0))
	_sprayed(Vector3(2.6, 2.86, h.position.y - 0.82), PI, 0.0012, Color(0.9, 0.9, 0.9))
	var s := interactable("subway", "The subway stairs", Vector3(0, 1.0, h.position.y - 0.2), Vector3(h.size.x, 2.0, 0.5), "RED ROCK LINE\nnext: DOWNTOWN  4 min\nCognizo Quarter  11 min", false)
	s.set_meta("route", "subway")
	interactable("subway_sign", "The sign", Vector3(0, 3.0, h.position.y - 0.9), Vector3(6.0, 0.8, 0.3), "", false)


# ------------------------------------------------------------------ Lushon's Tavern (ch.19)

func _lushons_front() -> void:
	var fz := LU.end.y
	var x0 := LU.position.x
	var x1 := LU.end.x
	var dw := 1.0   # half the door
	# the street face: lacquer red, wood trim, a door and one painted window
	box(Vector3(LU_DOOR - dw - x0, 4.6, 0.3), Vector3((x0 + LU_DOOR - dw) / 2.0, 2.3, fz - 0.15), _lacquer, true)
	box(Vector3(x1 - (LU_DOOR + dw), 4.6, 0.3), Vector3((LU_DOOR + dw + x1) / 2.0, 2.3, fz - 0.15), _lacquer, true)
	box(Vector3(dw * 2.0, 2.1, 0.3), Vector3(LU_DOOR, 3.55, fz - 0.15), _lacquer, true)
	for x: float in [LU_DOOR - dw - 0.08, LU_DOOR + dw + 0.08]:
		box(Vector3(0.16, 2.6, 0.4), Vector3(x, 1.3, fz - 0.1), _wood_dark)
	box(Vector3(dw * 2.0 + 0.32, 0.18, 0.4), Vector3(LU_DOOR, 2.55, fz - 0.1), _wood_dark)
	box(Vector3(16.2, 0.25, 0.5), Vector3((x0 + x1) / 2.0, 4.55, fz), _wood_dark)
	# the door, hung open inward
	var door := box(Vector3(0.06, 2.4, 1.0), Vector3(LU_DOOR - dw + 0.05, 1.2, fz - 0.8), _wood_dark)
	door.rotation.y = 0.15
	# the painted window, wood-framed
	box(Vector3(2.2, 1.5, 0.12), Vector3(x0 + 3.0, 1.9, fz + 0.02), _wood_dark)
	box(Vector3(1.9, 1.2, 0.04), Vector3(x0 + 3.0, 1.9, fz + 0.09), mat(Color(0.3, 0.04, 0.04), 0.7))
	_text("LUSHON", Vector3(LU_DOOR - 2.3, 2.2, fz + 0.05), 0.0, 0.26, glow(Color(1.0, 0.72, 0.35), 2.0))
	# the lantern over the door
	cyl(0.3, 0.3, 0.55, Vector3(LU_DOOR, 3.15, fz + 0.45), glow(Color(1.0, 0.18, 0.08), 2.6), 12)
	cyl(0.2, 0.2, 0.06, Vector3(LU_DOOR, 3.46, fz + 0.45), _dark, 10)
	stick(Vector3(LU_DOOR, 3.5, fz + 0.45), Vector3(LU_DOOR, 4.3, fz + 0.1), 0.01, _dark)
	var d := interactable("lushons_door", "Lushon's", Vector3(LU_DOOR - 2.3, 2.2, fz + 0.2), Vector3(2.0, 0.8, 0.3), "LUSHON TAVERN\nsurveillance: NONE\nnetwork: NONE FOUND", false)
	d.set_meta("route", "lushons")
	# the mass above, the side walls and the back
	var k := _kit_mats()
	box(Vector3(LU.size.x, 23.4, 22.0), Vector3((x0 + x1) / 2.0, 16.3, fz - 11.0), k["walls"][4], true)
	box(Vector3(0.3, 4.6, LU.size.y), Vector3(x0 - 0.15, 2.3, LU.get_center().y), _lacquer, true)
	box(Vector3(0.3, 4.6, LU.size.y), Vector3(x1 + 0.15, 2.3, LU.get_center().y), _lacquer, true)
	box(Vector3(LU.size.x, 4.6, 0.3), Vector3((x0 + x1) / 2.0, 2.3, LU.position.y - 0.15), _lacquer, true)
	box(Vector3(LU.size.x, 2.0, 2.0), Vector3((x0 + x1) / 2.0, 3.6 + 1.0, LU.position.y - 1.15), k["walls"][4])
	cyber_dress(Vector3((x0 + x1) / 2.0, 0, fz), 0.0, LU.size.x, 28.0, 0, false)


func _lushons_room() -> void:
	var x0 := LU.position.x
	var x1 := LU.end.x
	var z0 := LU.position.y
	var z1 := LU.end.y
	floor_quad(LU.size, Vector3(LU.get_center().x, 0.01, LU.get_center().y), 0.0, _wood)
	box(Vector3(LU.size.x, 0.15, LU.size.y), Vector3(LU.get_center().x, 4.3, LU.get_center().y), _wood_dark)
	var x := x0 + 1.0
	while x < x1:
		box(Vector3(0.22, 0.3, LU.size.y), Vector3(x, 4.08, LU.get_center().y), _wood_dark)
		x += 2.0
	# wainscot: real wood to the waist on every wall, the only real wood in the city
	box(Vector3(0.06, 1.2, LU.size.y - 0.4), Vector3(x0 + 0.03, 0.6, LU.get_center().y), _wood_dark)
	box(Vector3(0.06, 1.2, LU.size.y - 0.4), Vector3(x1 - 0.03, 0.6, LU.get_center().y), _wood_dark)
	box(Vector3(LU.size.x, 1.2, 0.06), Vector3(LU.get_center().x, 0.6, z0 + 0.03), _wood_dark)
	for xs: Vector2 in [Vector2(x0, LU_DOOR - 2.0), Vector2(LU_DOOR + 2.0, x1)]:
		box(Vector3(xs.y - xs.x, 1.2, 0.06), Vector3((xs.x + xs.y) / 2.0, 0.6, z1 - 0.33), _wood_dark)
	for zz: float in [z0 + 0.06, z1 - 0.36]:
		box(Vector3(LU.size.x, 0.08, 0.1), Vector3(LU.get_center().x, 1.24, zz), _wood)
	# the entry: a short wood passage from the door, a red curtain at its end
	var fab := pbr("fabric", Vector3(1, 1, 1) / 0.8, true, Color(0.62, 0.06, 0.06), 1.0)
	for px: float in [LU_DOOR - 2.0, LU_DOOR + 2.0]:
		box(Vector3(0.12, 2.9, 3.4), Vector3(px, 1.45, z1 - 2.0), _wood_dark, true)
	box(Vector3(4.1, 0.2, 3.4), Vector3(LU_DOOR, 2.95, z1 - 2.0), _wood_dark)
	for sd: float in [-1.0, 1.0]:
		var cq := box(Vector3(1.45, 2.6, 0.05), Vector3(LU_DOOR + sd * 1.25, 1.4, z1 - 3.7), fab)
		cq.rotation.y = sd * 0.08
	box(Vector3(4.0, 0.35, 0.08), Vector3(LU_DOOR, 2.7, z1 - 3.72), fab)
	# the painted-over window from inside, and the scratch in the paint
	box(Vector3(2.0, 1.3, 0.04), Vector3(x0 + 3.0, 1.9, z1 - 0.34), mat(Color(0.34, 0.05, 0.04), 0.8))
	box(Vector3(0.18, 0.04, 0.01), Vector3(x0 + 3.3, 1.95, z1 - 0.36), glow(Color(1.0, 0.45, 0.7), 1.4))
	interactable("window", "The painted window", Vector3(x0 + 3.0, 1.9, z1 - 0.45), Vector3(2.0, 1.3, 0.2), "", false)
	# the bar along the east wall, the back shelf and its bottles
	var bx := x1 - 2.2
	box(Vector3(0.7, 1.08, 9.0), Vector3(bx, 0.54, -51.0), _wood_dark, true)
	box(Vector3(0.95, 0.07, 9.2), Vector3(bx - 0.08, 1.11, -51.0), _wood)
	box(Vector3(0.3, 0.06, 8.4), Vector3(bx + 0.1, 0.12, -51.0), mat(Color(0.6, 0.48, 0.25), 0.3, 0.9))
	box(Vector3(0.4, 2.2, 8.0), Vector3(x1 - 0.25, 1.9, -51.0), _wood_dark)
	for sy: float in [1.4, 2.0, 2.6]:
		box(Vector3(0.45, 0.05, 8.0), Vector3(x1 - 0.5, sy, -51.0), _wood)
		var z := -54.7
		while z < -47.3:
			var bc: Color = [Color(0.45, 0.25, 0.06), Color(0.12, 0.3, 0.12), Color(0.5, 0.45, 0.4), Color(0.35, 0.05, 0.05)][rng.randi() % 4]
			var bot := mat(Color(bc.r, bc.g, bc.b), 0.08, 0.2)
			cyl(0.045, 0.045, 0.3, Vector3(x1 - 0.5, sy + 0.18, z), bot, 8)
			cyl(0.015, 0.02, 0.1, Vector3(x1 - 0.5, sy + 0.38, z), bot, 6)
			z += rng.randf_range(0.18, 0.4)
	for i in 5:
		var sp := Vector3(bx - 0.9, 0, -54.5 + i * 1.7)
		cyl(0.2, 0.2, 0.07, sp + Vector3(0, 0.76, 0), mat(Color(0.35, 0.06, 0.05), 0.6), 12)
		cyl(0.04, 0.04, 0.74, sp + Vector3(0, 0.37, 0), _metal, 6)
		cyl(0.2, 0.22, 0.03, sp + Vector3(0, 0.02, 0), _metal, 10)
	box(Vector3(0.15, 0.1, 0.15), Vector3(bx - 0.15, 1.2, -55.0), mat(Color(0.75, 0.6, 0.25), 0.25, 0.9))
	interactable("bar", "The bar", Vector3(bx - 0.2, 1.15, -50.0), Vector3(1.0, 0.4, 6.0), "", false)
	# the party photograph behind the bar
	box(Vector3(0.05, 0.5, 0.7), Vector3(x1 - 0.32, 3.1, -49.0), _wood)
	quad(Vector2(0.58, 0.4), Vector3(x1 - 0.36, 3.1, -49.0), -PI / 2.0, _party_photo())
	interactable("photo", "The photograph", Vector3(x1 - 0.5, 3.1, -49.0), Vector3(0.3, 0.6, 0.8), "", false)
	# the drink dispenser by the door end of the bar: dust on every button but one
	var dp := Vector3(x1 - 0.5, 0, -45.4)
	box(Vector3(0.6, 1.9, 0.9), dp + Vector3(0, 0.95, 0), mat(Color(0.7, 0.7, 0.68), 0.4, 0.6), true)
	box(Vector3(0.04, 0.4, 0.6), dp + Vector3(-0.31, 1.55, 0), _dark)
	var dust := mat(Color(0.55, 0.52, 0.48), 1.0)
	for r in 3:
		for c in 4:
			var bm: Material = dust
			if r == 1 and c == 2:
				bm = glow(PSYON_GREEN, 2.0)
			box(Vector3(0.04, 0.08, 0.1), dp + Vector3(-0.32, 1.05 + r * 0.14, -0.22 + c * 0.15), bm)
	box(Vector3(0.12, 0.05, 0.3), dp + Vector3(-0.3, 0.55, 0), _metal)
	floor_quad(Vector2(0.5, 0.3), dp + Vector3(-0.3, 0.6, 0), 0.0, mat(Color(0.5, 0.5, 0.5, 1.0), 1.0))
	var dsp := interactable("dispenser", "The drink dispenser", dp + Vector3(-0.35, 1.2, 0), Vector3(0.3, 1.4, 0.9), L("lushons", "dispenser_scan"), false)
	dsp.set_meta("hackable", true)
	# the booths along the west wall
	for bz: float in [-46.5, -50.0, -53.5]:
		for sd: float in [-1.0, 1.0]:
			box(Vector3(1.1, 0.45, 0.55), Vector3(x0 + 0.8, 0.22, bz + sd * 0.95), _wood_dark, true)
			box(Vector3(1.1, 0.75, 0.12), Vector3(x0 + 0.8, 0.82, bz + sd * 1.2), _wood_dark)
			box(Vector3(1.05, 0.1, 0.5), Vector3(x0 + 0.8, 0.5, bz + sd * 0.95), fab)
		box(Vector3(0.9, 0.06, 1.0), Vector3(x0 + 0.85, 0.74, bz), _wood, true)
		cyl(0.05, 0.05, 0.7, Vector3(x0 + 0.85, 0.37, bz), _metal, 6)
	box(Vector3(0.02, 0.5, 0.06), Vector3(x0 + 0.3, 1.1, -45.6), mat(Color(0.9, 0.5, 0.6), 0.9))
	interactable("booth", "The booths", Vector3(x0 + 0.9, 0.9, -50.0), Vector3(1.4, 1.6, 8.0), "", false)
	# the round table at the back, kept for people who need to talk where nothing listens
	cyl(1.25, 1.25, 0.07, TABLE + Vector3(0, 0.76, 0), _wood, 28)
	cyl(1.27, 1.27, 0.03, TABLE + Vector3(0, 0.72, 0), _wood_dark, 28)
	cyl(0.14, 0.18, 0.72, TABLE + Vector3(0, 0.36, 0), _wood_dark, 10)
	cyl(0.55, 0.6, 0.06, TABLE + Vector3(0, 0.03, 0), _wood_dark, 14)
	solid_box(Vector3(2.0, 0.8, 2.0), TABLE + Vector3(0, 0.4, 0))
	for i in 8:
		var a := TAU * i / 8.0
		var cp := TABLE + Vector3(sin(a) * 1.65, 0, cos(a) * 1.65)
		_chair(cp, a)
	box(Vector3(0.24, 0.02, 0.16), TABLE + Vector3(0.3, 0.8, 0.25), mat(Color(0.92, 0.9, 0.84), 0.9))
	# lanterns, every wall, and three low over the table
	var lant := glow(Color(1.0, 0.22, 0.1), 2.3)
	var cap := mat(Color(0.08, 0.04, 0.03), 0.5)
	var lp := []
	var zz := z0 + 1.5
	while zz < z1 - 4.0:
		lp.append(Vector3(x0 + 0.5, 3.2, zz))
		lp.append(Vector3(x1 - 0.6, 3.4, zz + 1.0))
		zz += 2.6
	x = x0 + 1.5
	while x < x1 - 1.0:
		lp.append(Vector3(x, 3.2, z0 + 0.5))
		x += 2.6
	for o: Vector3 in [Vector3(-0.7, 2.55, 0), Vector3(0.6, 2.7, 0.4), Vector3(0.1, 2.6, -0.7)]:
		lp.append(TABLE + o)
	for p: Vector3 in lp:
		cyl(0.24, 0.24, 0.42, p, lant, 12)
		cyl(0.17, 0.17, 0.05, p + Vector3(0, 0.23, 0), cap, 10)
		cyl(0.17, 0.17, 0.05, p - Vector3(0, 0.23, 0), cap, 10)
		stick(p + Vector3(0, 0.25, 0), Vector3(p.x, 4.2, p.z), 0.008, cap)
	interactable("lanterns", "The lanterns", Vector3(x0 + 0.5, 3.2, -50.0), Vector3(0.6, 0.6, 12.0), "", false)


func _chair(p: Vector3, a: float) -> void:
	# a = the angle the chair sits at round the table; it faces the centre
	var b := Basis(Vector3.UP, a)
	var seat := box(Vector3(0.46, 0.06, 0.46), p + Vector3(0, 0.46, 0), _wood)
	seat.rotation.y = a
	var back := box(Vector3(0.46, 0.55, 0.05), p + b * Vector3(0, 0.76, 0.22), _wood_dark)
	back.rotation.y = a
	for lx: float in [-0.19, 0.19]:
		for lz: float in [-0.19, 0.19]:
			stick(p + b * Vector3(lx, 0, lz), p + b * Vector3(lx, 0.44, lz), 0.02, _wood_dark)


## The Independence Day party, three years gone, as a small photograph.
func _party_photo() -> StandardMaterial3D:
	var img := Image.create(72, 50, false, Image.FORMAT_RGBA8)
	img.fill(Color(0.35, 0.12, 0.08))
	var r := RandomNumberGenerator.new()
	r.seed = 704
	for k in 40:
		Body._ell(img, r.randf_range(0, 72), r.randf_range(0, 22), 1.4, 1.4, Color(1.0, 0.5, 0.2))
	for k in 9:
		var px := 6.0 + k * 7.5
		var hy := 26.0 + r.randf_range(-3, 3)
		Body._ell(img, px, hy, 3.0, 3.6, Color(0.85, 0.66, 0.52))
		Body._rect(img, px - 4, hy + 4, 8, 16, [Color(0.1, 0.1, 0.12), Color(0.5, 0.1, 0.12), Color(0.2, 0.25, 0.4)][k % 3])
		Body._rect(img, px - 3, hy - 6, 6, 3, [Color(0.9, 0.2, 0.2), Color(0.95, 0.95, 0.95), Color(0.2, 0.3, 0.8)][k % 3])
	# the couple in the middle of the floor, mid-step
	Body._ell(img, 34, 32, 3, 3.5, Color(0.72, 0.58, 0.45))
	Body._ell(img, 40, 31, 3, 3.5, Color(0.88, 0.7, 0.58))
	Body._ell(img, 41, 29, 4.5, 3, Color(0.3, 0.18, 0.1))
	var m := StandardMaterial3D.new()
	m.albedo_texture = ImageTexture.create_from_image(img)
	m.roughness = 0.3
	return m


# ------------------------------------------------------------------ street furniture

func _street() -> void:
	for z: float in [-30.0, -12.0, 8.0, 28.0]:
		prop("street_lamp_01", Vector3(-36.5, 0, z), PI / 2.0, 1.4, false)
		prop("street_lamp_01", Vector3(36.5, 0, z), -PI / 2.0, 1.4, false)
	for x: float in [-30.0, -12.0, 12.0, 30.0]:
		prop("street_lamp_01", Vector3(x, 0, 43.0), PI, 1.4, false)
	for x: float in [-34.0, -22.0, -10.0, 10.0, 22.0, 34.0]:
		prop("concrete_road_barrier", Vector3(x, 0, 44.6), 0.0, 1.0)
	for p: Vector3 in [Vector3(-36.0, 0, -36.0), Vector3(36.0, 0, 36.0), Vector3(-6.0, 0, 41.5), Vector3(20.0, 0, -36.5), Vector3(-36.5, 0, 30.0)]:
		prop("metal_trash_can", p, rng.randf() * TAU, 1.0)
	prop("fire_hydrant", Vector3(-24.0, 0, 42.5), 0.0, 1.0)
	prop("utility_box_01", Vector3(38.6, 0, -34.0), -PI / 2.0, 1.0)
	prop("power_box_01", Vector3(-38.8, 0, -20.0), PI / 2.0, 1.0)
	prop("utility_box_02", Vector3(38.7, 0, 12.0), -PI / 2.0, 1.0)
	prop("atm", Vector3(-38.9, 0, 22.0), PI / 2.0, 1.0)
	var atm := interactable("atm", "The ATM", Vector3(-38.6, 1.1, 22.0), Vector3(0.6, 2.0, 1.0), L("plaza", "atm_scan"), false)
	atm.set_meta("hackable", true)
	prop("vending_kiosk", Vector3(38.5, 0, 22.0), -PI / 2.0, 1.0)
	var vk := interactable("kiosk", "The vending kiosk", Vector3(38.2, 1.1, 22.0), Vector3(0.8, 2.0, 1.4), "", false)
	vk.set_meta("hackable", true)
	# the cameras on their poles
	for cp: Vector3 in [Vector3(-20.0, 0, 30.0), Vector3(24.0, 0, -30.0)]:
		cyl(0.09, 0.12, 5.2, cp + Vector3(0, 2.6, 0), _metal, 8)
		prop("security_camera_01", cp + Vector3(0, 5.2, 0.15), PI if cp.z > 0.0 else 0.0, 1.0, false)
		var cam := interactable("camera", "The camera", cp + Vector3(0, 2.0, 0), Vector3(0.6, 4.0, 0.6), L("plaza", "camera_scan"), false)
		cam.set_meta("hackable", true)
	# the Nixtra outlet, shutters down, its ad still running
	prop("rollershutter_door", Vector3(22.0, 0, -39.7), 0.0, 1.0, false)
	_text("NIXTRA", Vector3(22.0, 3.6, -39.5), 0.0, 0.6, glow(Color(1.0, 0.55, 0.15), 2.4))
	interactable("outlet", "The Nixtra outlet", Vector3(22.0, 1.6, -39.3), Vector3(3.0, 3.0, 0.4), "", false)
	# the smoothie stand on the south path
	var sp := Vector3(11.0, 0, 17.5)
	var pinkm := glow(Color(1.0, 0.35, 0.65), 2.2)
	box(Vector3(2.6, 2.5, 0.2), sp + Vector3(0, 1.25, 1.0), mat(Color(0.85, 0.82, 0.8), 0.5))
	box(Vector3(2.6, 1.05, 0.7), sp + Vector3(0, 0.52, -0.2), mat(Color(0.9, 0.55, 0.65), 0.6), true)
	box(Vector3(2.8, 0.08, 0.9), sp + Vector3(0, 1.08, -0.2), _metal)
	box(Vector3(3.0, 0.12, 2.2), sp + Vector3(0, 2.6, 0), pinkm)
	for sd: float in [-1.25, 1.25]:
		cyl(0.05, 0.05, 2.5, sp + Vector3(sd, 1.25, -0.5), _metal, 6)
	neon_text("SMOOTHIES", sp + Vector3(0, 2.9, -1.0), 0.0, 0.42, Color(1.0, 0.4, 0.7))
	cyl(0.1, 0.12, 0.08, sp + Vector3(0.7, 1.16, -0.25), _dark, 10)
	cyl(0.1, 0.08, 0.25, sp + Vector3(0.7, 1.32, -0.25), _kit_mats()["glass"], 10)
	for k in 4:
		cyl(0.04, 0.035, 0.11, sp + Vector3(-0.8 + k * 0.12, 1.17, -0.4), mat(Color(0.95, 0.9, 0.9), 0.4), 8)
	box(Vector3(0.22, 0.03, 0.15), sp + Vector3(-0.2, 1.13, -0.35), mat(Color(0.7, 0.1, 0.15), 0.8))


# ------------------------------------------------------------------ the monolith screen (ch.20)

func _unshaded(tex: Texture2D, tint := Color(1, 1, 1)) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.albedo_texture = tex
	m.albedo_color = tint
	m.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	return m


func _screen_label(text: String, pos: Vector3, px: float, c: Color, parent: Node3D, wrap_w := 0.0) -> Label3D:
	var l := Label3D.new()
	l.text = text
	l.position = pos
	l.pixel_size = px
	l.font_size = 96
	l.outline_size = 0
	l.modulate = c
	l.double_sided = false
	if wrap_w > 0.0:
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.width = wrap_w / px
	parent.add_child(l)
	return l


func _screen() -> void:
	var root := Node3D.new()
	root.position = SCREEN_C
	add_child(root)
	var sz := Vector2(15.0, 8.8)
	var z := Vector3(0, 0, 0.02)
	var t: Dictionary = LINES["monolith"]
	# the Nixtra ad: men in hard hats, cinnamon, methylphenidate
	var ad := Node3D.new()
	root.add_child(ad)
	quad(sz, Vector3.ZERO, 0.0, _unshaded(_tex_ad()), ad)
	_screen_label(str(t["text_ad1"]), z + Vector3(3.6, 2.4, 0), 0.016, Color(1, 1, 1), ad)
	_screen_label(str(t["text_ad2"]), z + Vector3(3.6, 0.9, 0), 0.009, Color(1.0, 0.85, 0.55), ad)
	_screen_label(str(t["text_ad3"]), z + Vector3(0, -3.6, 0), 0.0045, Color(1, 1, 1), ad)
	# the Psyonic assistant, loading
	var chat := Node3D.new()
	root.add_child(chat)
	quad(sz, Vector3.ZERO, 0.0, glow(Color(0.03, 0.06, 0.1), 1.0), chat)
	_screen_label(str(t["text_chat1"]), z + Vector3(0, 2.6, 0), 0.008, Color(0.5, 1.0, 0.75), chat)
	_screen_label(str(t["text_chat2"]), z + Vector3(0, 0.6, 0), 0.006, Color(0.75, 0.85, 0.95), chat)
	box(Vector3(10.0, 0.3, 0.02), z + Vector3(0, -1.0, 0), glow(Color(0.12, 0.16, 0.2), 1.0), false, chat)
	_load_bar = box(Vector3(10.0, 0.3, 0.03), z + Vector3(0, -1.0, 0.01), glow(PSYON_GREEN, 2.4), false, chat)
	# the message: white on violet, the scripture in a corporate font
	var msg := Node3D.new()
	root.add_child(msg)
	quad(sz, Vector3.ZERO, 0.0, glow(Color(0.22, 0.05, 0.4), 1.0), msg)
	var ml := _screen_label(str(t["msg"]), z, 0.0062, Color(1, 1, 1), msg, 13.6)
	ml.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	# the children round the tower
	var kids := Node3D.new()
	root.add_child(kids)
	quad(sz, Vector3.ZERO, 0.0, _unshaded(_tex_kids()), kids)
	var black := Node3D.new()
	root.add_child(black)
	quad(sz, Vector3.ZERO, 0.0, mat(Color(0.01, 0.01, 0.012), 0.05, 0.3), black)
	scr = {"ad": ad, "chat": chat, "msg": msg, "kids": kids, "black": black}
	_scr("ad")
	var it := interactable("monolith", str(t["screen_prompt"]), Vector3(0, 1.6, -0.55), Vector3(2.4, 3.0, 0.4), str(t["screen_scan"]), false)
	it.set_meta("hackable", true)


func _scr(state: String) -> void:
	for k in scr:
		(scr[k] as Node3D).visible = k == state
	if scr_light:
		var c := {"ad": Color(1.0, 0.55, 0.25), "chat": Color(0.3, 0.9, 0.7), "msg": Color(0.6, 0.25, 1.0),
			"kids": Color(0.7, 0.4, 1.0), "black": Color(0.1, 0.1, 0.12)}
		scr_light.light_color = c.get(state, Color(1, 1, 1))
		scr_light.light_energy = 0.15 if state == "black" else 1.7


## The Nixtra Cinnamon ad: two men in hard hats, grinning, and the tin.
func _tex_ad() -> ImageTexture:
	var w := 320
	var h := 188
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	for y in h:
		img.fill_rect(Rect2i(0, y, w, 1), Color(0.55, 0.22, 0.06).lerp(Color(0.95, 0.55, 0.18), float(y) / h))
	for k in 2:
		var cx := 50.0 + k * 70.0
		var cy := 82.0 + k * 8.0
		Body._rect(img, cx - 30, cy + 20, 60, 90, Color(1.0, 0.6, 0.05))
		Body._rect(img, cx - 30, cy + 46, 60, 7, Color(0.75, 0.75, 0.75))
		Body._rect(img, cx - 30, cy + 66, 60, 7, Color(0.75, 0.75, 0.75))
		Body._ell(img, cx, cy, 20, 24, Color(0.82, 0.6, 0.45))
		Body._ell(img, cx, cy - 18, 26, 13, Color(1.0, 0.85, 0.1))
		Body._rect(img, cx - 30, cy - 10, 60, 5, Color(0.95, 0.78, 0.05))
		Body._ell(img, cx - 7, cy - 2, 2.5, 2.5, Color(0.1, 0.06, 0.05))
		Body._ell(img, cx + 7, cy - 2, 2.5, 2.5, Color(0.1, 0.06, 0.05))
		Body._ell(img, cx, cy + 11, 11, 5, Color(0.98, 0.98, 0.95))
		Body._rect(img, cx - 11, cy + 9, 22, 1, Color(0.5, 0.15, 0.1))
	# the tin of pouches and a cinnamon stick
	Body._ell(img, 236, 132, 40, 40, Color(0.25, 0.1, 0.05))
	Body._ell(img, 236, 132, 34, 34, Color(0.75, 0.35, 0.1))
	Body._ell(img, 236, 132, 22, 22, Color(0.95, 0.85, 0.7))
	Body._line(img, 196, 176, 280, 150, Color(0.45, 0.2, 0.08), 6)
	for k in 30:
		Body._ell(img, randf_range(170, 305), randf_range(10, 100), 1.2, 1.2, Color(1, 1, 0.9))
	return ImageTexture.create_from_image(img)


## Eyeless children dancing round a tower from a fantasy film (ch.20).
func _tex_kids() -> ImageTexture:
	var w := 320
	var h := 188
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	for y in h:
		img.fill_rect(Rect2i(0, y, w, 1), Color(0.05, 0.02, 0.12).lerp(Color(0.32, 0.12, 0.4), float(y) / h))
	var r := RandomNumberGenerator.new()
	r.seed = 2020
	for k in 70:
		img.set_pixel(r.randi() % w, r.randi() % 90, Color(0.9, 0.85, 1.0))
	Body._ell(img, 160, 196, 210, 44, Color(0.08, 0.04, 0.1))
	var kids := []
	for k in 11:
		var a := TAU * k / 11.0 + 0.3
		kids.append([160.0 + cos(a) * 112.0, 156.0 + sin(a) * 18.0, sin(a), k])
	var draw_kid := func(kd: Array) -> void:
		var x := float(kd[0])
		var y := float(kd[1])
		var s := 0.8 + 0.25 * (float(kd[2]) + 1.0) * 0.5
		var col: Color = [Color(0.85, 0.6, 0.75), Color(0.4, 0.55, 0.85), Color(0.95, 0.85, 0.4), Color(0.5, 0.8, 0.55)][int(kd[3]) % 4]
		var up := int(kd[3]) % 2 == 0
		Body._line(img, x - 3 * s, y, x - 4 * s, y + 12 * s, Color(0.15, 0.1, 0.12), maxi(1, int(2 * s)))
		Body._line(img, x + 3 * s, y, x + 4 * s, y + 12 * s, Color(0.15, 0.1, 0.12), maxi(1, int(2 * s)))
		for yy in int(16 * s):
			var hw := (2.0 + yy * 0.45) * s
			Body._rect(img, x - hw, y - 16 * s + yy, hw * 2.0, 1, col)
		Body._line(img, x - 3 * s, y - 14 * s, x - 10 * s, y - (26 if up else 8) * s, Color(0.85, 0.66, 0.55), maxi(1, int(2 * s)))
		Body._line(img, x + 3 * s, y - 14 * s, x + 10 * s, y - (8 if up else 26) * s, Color(0.85, 0.66, 0.55), maxi(1, int(2 * s)))
		Body._ell(img, x, y - 21 * s, 5 * s, 5.5 * s, Color(0.88, 0.7, 0.58))
		Body._ell(img, x, y - 25 * s, 5.4 * s, 3 * s, Color(0.08, 0.05, 0.04))
		for sd: float in [-1.0, 1.0]:
			Body._ell(img, x + sd * 2.0 * s, y - 21 * s, 1.6 * s, 1.4 * s, Color(0.45, 0.05, 0.04))
			Body._ell(img, x + sd * 2.0 * s, y - 21 * s, 1.0 * s, 1.0 * s, Color(0, 0, 0))
	for kd: Array in kids:
		if float(kd[2]) < 0.0:
			draw_kid.call(kd)
	# the tower: tiers narrowing, battlements, lit windows, a roof, and the eye
	var tiers := [[120, 150, 26], [104, 120, 22], [86, 104, 18], [70, 86, 14]]
	for tr: Array in tiers:
		var y0 := float(tr[0])
		var y1 := float(tr[1])
		var hw := float(tr[2])
		Body._rect(img, 160 - hw, y0, hw * 2, y1 - y0, Color(0.6, 0.55, 0.65))
		Body._rect(img, 160 - hw, y0, 3, y1 - y0, Color(0.4, 0.35, 0.45))
		for bx in int(hw * 2 / 6):
			Body._rect(img, 160 - hw + bx * 6, y0 - 3, 3, 3, Color(0.6, 0.55, 0.65))
		for wy in 2:
			for wx in int(hw / 6):
				Body._rect(img, 160 - hw + 4 + wx * 12, y0 + 4 + wy * ((y1 - y0) / 2), 3, 4, Color(1.0, 0.85, 0.35))
	for yy in 40:
		var hw2 := yy * 0.42
		Body._rect(img, 160 - hw2, 30 + yy, hw2 * 2, 1, Color(0.35, 0.15, 0.4))
	Body._ell(img, 160, 22, 9, 6, Color(0.98, 0.95, 0.9))
	Body._ell(img, 160, 22, 4.5, 4.5, Color(0.8, 0.08, 0.06))
	Body._ell(img, 160, 22, 1.2, 4, Color(0, 0, 0))
	for kd: Array in kids:
		if float(kd[2]) >= 0.0:
			draw_kid.call(kd)
	return ImageTexture.create_from_image(img)


# ------------------------------------------------------------------ lights, by zone (the browser shades 32)

func _zl(zn: String, pos: Vector3, c: Color, e: float, r: float) -> OmniLight3D:
	var o := OmniLight3D.new()
	o.position = pos
	o.light_color = c
	o.light_energy = e
	o.omni_range = r
	o.omni_attenuation = 1.4
	o.shadow_enabled = false
	o.set_meta("base", e)
	add_child(o)
	(zone_lights[zn] as Array).append(o)
	return o


var _flick: Array = []


func _lights() -> void:
	_zl("plaza", P + Vector3(0, 1.2, 7.4), Color(1.0, 0.55, 0.35), 1.1, 11.0)
	_zl("plaza", P + Vector3(-7.4, 1.0, 0), Color(1.0, 0.25, 0.6), 1.0, 9.0)
	scr_light = _zl("plaza", SCREEN_C + Vector3(0, -3.0, 7.0), Color(1.0, 0.55, 0.25), 1.7, 24.0)
	_flick.append(_zl("plaza", Vector3(-46.0, 3.9, 10.0), Color(0.65, 0.78, 1.0), 1.3, 9.0))
	_zl("plaza", Vector3(-50.6, 2.6, 9.0), Color(1.0, 0.18, 0.12), 1.3, 6.5)
	_zl("plaza", Vector3(LU_DOOR, 3.0, LU.end.y + 1.0), Color(1.0, 0.2, 0.08), 1.8, 7.5)
	_flick.append(_zl("plaza", Vector3(56.0, 4.6, 0.0), Color(1.0, 0.55, 0.15), 1.6, 11.0))
	_zl("plaza", Vector3(11.0, 2.3, 16.2), Color(1.0, 0.35, 0.65), 1.4, 7.0)
	_zl("plaza", Vector3(0, 2.8, 35.0), Color(0.2, 0.85, 1.0), 1.4, 9.0)
	_zl("plaza", Vector3(0, -2.6, 41.0), Color(0.2, 0.8, 1.0), 0.8, 6.0)
	_zl("plaza", Vector3(31.0, -1.6, -26.0), Color(0.5, 0.2, 1.0), 0.6, 6.0)
	_zl("plaza", Vector3(-35.4, 5.6, -12.0), Color(1.0, 0.8, 0.55), 1.2, 12.0)
	_zl("plaza", Vector3(35.4, 5.6, 8.0), Color(0.5, 0.85, 1.0), 1.2, 12.0)
	_zl("plaza", Vector3(-12.0, 5.6, 42.4), Color(1.0, 0.8, 0.55), 1.1, 11.0)
	_zl("plaza", Vector3(30.0, 5.6, 42.4), Color(1.0, 0.3, 0.7), 1.1, 11.0)
	_zl("plaza", Vector3(-37.4, 2.6, -24.0), Color(1.0, 0.2, 0.65), 1.2, 9.0)
	_zl("plaza", Vector3(37.4, 2.6, 28.0), Color(0.2, 0.9, 1.0), 1.2, 9.0)
	# Lushon's: warm red, low, the only interior with real wood
	_zl("lush", Vector3(-8.0, 3.3, -46.0), Color(1.0, 0.32, 0.16), 1.5, 8.0)
	_zl("lush", Vector3(-13.4, 3.0, -50.5), Color(1.0, 0.28, 0.14), 1.3, 7.0)
	_zl("lush", Vector3(-2.6, 3.0, -51.0), Color(1.0, 0.55, 0.25), 1.2, 7.0)
	_zl("lush", TABLE + Vector3(0, 2.3, 0), Color(1.0, 0.45, 0.25), 1.6, 5.5)
	_zl("lush", Vector3(LU_DOOR, 2.4, LU.end.y - 2.0), Color(1.0, 0.2, 0.1), 0.7, 4.0)
	_zl("lush", Vector3(-13.4, 3.0, -57.6), Color(1.0, 0.25, 0.12), 1.0, 6.0)


func _set_zone(zn: String) -> void:
	zone = zn
	for k in zone_lights:
		for o in zone_lights[k]:
			(o as OmniLight3D).visible = k == zn
	if traffic:
		traffic.visible = zn == "plaza"


# ------------------------------------------------------------------ faces

func _face_img(base: StandardMaterial3D) -> Image:
	var img: Image = (base.albedo_texture as Texture2D).get_image()
	if img.is_compressed():
		img.decompress()
	img.clear_mipmaps()
	img.convert(Image.FORMAT_RGBA8)
	return img


func _face_from(base: StandardMaterial3D, img: Image) -> StandardMaterial3D:
	img.generate_mipmaps()
	var m := base.duplicate() as StandardMaterial3D
	m.albedo_texture = ImageTexture.create_from_image(img)
	return m


const EYE_Y := 95.9
const EYE_DX := 16.2


## Carl's face: "my jaw. My scar. My uneven left brow." (as Hangar.gd draws it)
func _carl_img() -> Array:
	var base: StandardMaterial3D = Body.face_mat(Color(0.84, 0.66, 0.54), Color(0.12, 0.09, 0.07), false, 1)
	var img := _face_img(base)
	for j in 14:
		Body._rect(img, 108 + j * 0.6, 112 + j, 1.5, 1, Color(0.72, 0.5, 0.42))
	Body._rect(img, 104, 82, 14, 2, Color(0.1, 0.07, 0.05))
	return [base, img]


## The double: Carl's face, eyes wide and full of glee, the grin too wide.
func _double_face() -> StandardMaterial3D:
	var pr := _carl_img()
	var img: Image = pr[1]
	for sd: float in [-1.0, 1.0]:
		Body._ell(img, 128 + sd * EYE_DX, EYE_Y, 7.5, 5.5, Color(0.98, 0.97, 0.93))
		Body._ell(img, 128 + sd * EYE_DX, EYE_Y, 1.6, 1.6, Color(0.05, 0.04, 0.04))
	Body._rect(img, 110, 154, 36, 3, Color(0.35, 0.05, 0.05))
	Body._rect(img, 113, 151, 30, 3, Color(0.95, 0.93, 0.88))
	Body._rect(img, 108, 150, 4, 4, Color(0.4, 0.08, 0.06))
	Body._rect(img, 144, 150, 4, 4, Color(0.4, 0.08, 0.06))
	return _face_from(pr[0], img)


## The copy in Mira's Tower: Carl's face with nothing wrong in it. Too smooth.
func _copy_face() -> StandardMaterial3D:
	var pr := _carl_img()
	var img: Image = pr[1]
	img.resize(64, 64, Image.INTERPOLATE_BILINEAR)
	img.resize(256, 256, Image.INTERPOLATE_CUBIC)
	var m := _face_from(pr[0], img)
	m.roughness = 0.05
	m.emission_enabled = true
	m.emission_texture = m.albedo_texture
	m.emission_energy_multiplier = 0.45
	return m


## Healed-over sockets (the eyeless) or two holes with nothing in them (Dufredy).
func _eyeless_face(skin: Color, hair: Color, seed: int, void_eyes: bool) -> StandardMaterial3D:
	var base: StandardMaterial3D = Body.face_mat(skin, hair, false, seed)
	var img := _face_img(base)
	for sd: float in [-1.0, 1.0]:
		var ex := 128.0 + sd * EYE_DX
		if void_eyes:
			Body._ell(img, ex, EYE_Y, 10.0, 7.5, skin.darkened(0.35), 0.5)
			Body._ell(img, ex, EYE_Y, 8.0, 6.0, Color(0, 0, 0))
		else:
			Body._ell(img, ex, EYE_Y, 9.0, 6.5, skin.darkened(0.2), 0.5)
			Body._ell(img, ex, EYE_Y, 6.5, 2.0, skin.darkened(0.45))
			for k in 7:
				var a := TAU * k / 7.0
				Body._rect(img, ex + cos(a) * 6.0, EYE_Y + sin(a) * 4.0, 2, 1, Color(skin.darkened(0.4), 0.8))
	return _face_from(base, img)


## Eye paint: two white rings round each eye, a black dot on the forehead.
func _painted_face(skin: Color, hair: Color) -> StandardMaterial3D:
	var base: StandardMaterial3D = Body.face_mat(skin, hair, false, 9)
	var img := _face_img(base)
	for sd: float in [-1.0, 1.0]:
		for ring: float in [8.0, 12.0]:
			for k in 40:
				var a := TAU * k / 40.0
				Body._rect(img, 128 + sd * EYE_DX + cos(a) * ring, EYE_Y + sin(a) * ring * 0.8, 2, 2, Color(0.97, 0.97, 0.95))
	Body._ell(img, 128, 70, 4, 4, Color(0.02, 0.02, 0.02))
	return _face_from(base, img)


func _head_mesh(fig: Node3D) -> MeshInstance3D:
	var hd: Node3D = fig.get_meta("head")
	for c in hd.get_children():
		if c is MeshInstance3D:
			return c
	return null


func _set_face(fig: Node3D, m: Material) -> void:
	var hm := _head_mesh(fig)
	if hm:
		hm.material_override = m


# ------------------------------------------------------------------ the people on the plaza

func _seat(f: Node3D, pos: Vector3, rot: float) -> void:
	var s: float = f.scale.x
	f.position = pos + Vector3(0, 0.46 - 0.86 * s, 0)
	f.rotation.y = rot
	Anim.sit(f, 0.08)
	f.set_meta("seated", true)


func _kneel(f: Node3D) -> void:
	Anim.crouch(f)
	f.position.y -= 0.45
	(f.get_meta("body") as Node3D).rotation.x = 0.7
	var hd: Node3D = f.get_meta("head")
	hd.rotation.x = 0.9
	hd.position.z = -0.32
	hd.position.y = 1.45
	for a in f.get_meta("arms"):
		(a as Node3D).rotation.x = 1.3


func _people() -> void:
	var coats := [Color(0.12, 0.12, 0.14), Color(0.3, 0.1, 0.12), Color(0.2, 0.2, 0.22), Color(0.1, 0.14, 0.2), Color(0.35, 0.3, 0.25), Color(0.5, 0.12, 0.3)]
	var skins := [Color(0.85, 0.66, 0.52), Color(0.6, 0.42, 0.3), Color(0.4, 0.28, 0.2), Color(0.92, 0.78, 0.66), Color(0.7, 0.52, 0.38)]
	var candle := glow(Color(1.0, 0.7, 0.35), 2.4)
	# six knelt at the foot of the pillar, foreheads on the wet stone
	for i in 6:
		var a := deg_to_rad(25.0 + i * 26.0)
		var pos := P + Vector3(cos(a) * 7.0, 0.08, sin(a) * 6.2)
		var f := figure(coats[i % coats.size()], skins[i % skins.size()], {"arms": true, "knees": true, "visor": i % 2 == 0})
		add_child(f)
		f.position = pos
		turn_to(f, P + Vector3(0, 0, 0))
		_kneel(f)
		f.set_meta("cultist", true)
		people.append({"fig": f, "mode": "kneel", "phase": rng.randf() * TAU})
		cyl(0.03, 0.03, 0.12, pos + Vector3(0.35, 0.06, 0.2), candle, 6)
		if i == 2:
			person("kneelers", "The people kneeling", f, L("plaza", "kneel_scan"))
	# the boy with the Eye painted on his face, by the casino
	var pb := figure(Color(0.1, 0.1, 0.1), Color(0.75, 0.56, 0.42), {"arms": true, "knees": true, "hair": Color(0.04, 0.03, 0.03)})
	add_child(pb)
	pb.position = Vector3(-33.5, 0.0, 15.5)
	pb.rotation.y = -PI / 2.0 + 0.4
	_set_face(pb, _painted_face(Color(0.75, 0.56, 0.42), Color(0.04, 0.03, 0.03)))
	pb.set_meta("cultist", true)
	person("painted", "The boy with the painted face", pb, L("plaza", "painted_scan"))
	people.append({"fig": pb, "mode": "idle", "phase": 1.3, "look": true})
	# the woman humming on the planter edge
	var hm := figure(Color(0.6, 0.15, 0.4), Color(0.92, 0.78, 0.66), {"arms": true, "knees": true, "long_hair": true, "hair": Color(0.5, 0.3, 0.15), "long_coat": false})
	add_child(hm)
	_seat(hm, P + Vector3(-5.8, 0, 9.8), -PI / 2.0)
	person("hummer", "The woman on the planter", hm, L("plaza", "hummer_scan"))
	people.append({"fig": hm, "mode": "sit", "phase": 0.4})
	# a man asleep on a bench under a blanket, a ring of sticks under him
	var dr := figure(Color(0.25, 0.25, 0.3), Color(0.6, 0.42, 0.3), {"arms": true, "knees": true})
	add_child(dr)
	dr.rotation = Vector3(PI / 2.0, 0, 0)
	dr.position = P + Vector3(-4.8, 0.66, 7.0 - 0.95)
	box(Vector3(0.55, 0.1, 1.3), P + Vector3(-4.8, 0.72, 7.4), pbr("fabric", Vector3(1, 1, 1), true, Color(0.25, 0.3, 0.4)))
	for k in 9:
		var a := TAU * k / 9.0
		stick(P + Vector3(-4.8 + cos(a) * 0.5, 0.02, 8.0 + sin(a) * 0.9), P + Vector3(-4.8 + cos(a + 0.5) * 0.5, 0.02, 8.0 + sin(a + 0.5) * 0.9), 0.015, mat(Color(0.4, 0.3, 0.2), 0.9))
	person("drunk", "The man on the bench", dr, L("plaza", "drunk_scan"))
	# two walking the loop of the park, arm in arm, nodding to the pillar
	var loop := [P + Vector3(-18.5, 0, -18.5), P + Vector3(18.5, 0, -18.5), P + Vector3(18.5, 0, 18.5), P + Vector3(-18.5, 0, 18.5)]
	for k in 2:
		var w := figure(coats[(k + 3) % coats.size()], skins[(k + 1) % skins.size()], {"arms": true, "knees": true, "visor": true, "long_hair": k == 1})
		add_child(w)
		w.position = loop[0] + Vector3(0, 0, k * 0.65)
		walkers.append({"fig": w, "pts": loop, "i": 1, "speed": 0.85, "phase": k * 0.4, "off": Vector3(0, 0, k * 0.65)})
		w.set_meta("cultist", true)
		if k == 0:
			person("walkers", "The couple walking the loop", w, L("plaza", "walkers_scan"))
	# Ana at the smoothie stand, frames off, a paperback on the counter
	vendor = figure(Color(0.9, 0.55, 0.65), Color(0.6, 0.42, 0.3), {"arms": true, "knees": true, "long_hair": true, "hair": Color(0.05, 0.04, 0.04), "long_coat": false})
	add_child(vendor)
	vendor.position = Vector3(11.0, 0, 18.0)
	vendor.rotation.y = 0.0
	person("smoothie", "The smoothie stand", vendor, L("plaza", "smoothie_scan"))
	people.append({"fig": vendor, "mode": "idle", "phase": 2.0, "look": true})
	box(Vector3(0.14, 0.03, 0.2), Vector3(10.5, 1.13, 17.3), mat(Color(0.85, 0.82, 0.7), 0.9))
	# the police drone going round the pillar at the height of the third floor
	police = Node3D.new()
	add_child(police)
	prop("police_drone", Vector3.ZERO, 0.0, 1.5, false, police)
	police.set_meta("guard", true)
	police.position = P + Vector3(14, 10, 0)


func _cast() -> void:
	turan = figure(Color(0.16, 0.16, 0.19), Color(0.8, 0.66, 0.56), {"hair": Color(0.5, 0.5, 0.52), "legs": Color(0.14, 0.14, 0.16), "arms": true, "knees": true, "long_hair": true, "long_coat": false})
	add_child(turan)
	_seat(turan, TABLE + Vector3(0, 0, -1.65), PI)
	person("turan", "Turan", turan, L("cast", "turan_scan"))
	forner = figure(Color(0.5, 0.42, 0.32), Color(0.72, 0.58, 0.45), {"hair": Color(0.55, 0.55, 0.52), "legs": Color(0.3, 0.26, 0.22), "arms": true, "knees": true, "long_coat": false, "scale": 1.06})
	add_child(forner)
	var a := 5.0 * PI / 4.0
	_seat(forner, TABLE + Vector3(sin(a) * 1.65, 0, cos(a) * 1.65), a)
	person("forner", "Forner", forner, L("cast", "forner_scan"))
	emmet = figure(Color(0.28, 0.38, 0.5), Color(0.9, 0.74, 0.64), {"hair": Color(0.8, 0.3, 0.1), "legs": Color(0.2, 0.2, 0.24), "arms": true, "knees": true, "long_coat": false})
	add_child(emmet)
	a = 3.0 * PI / 4.0
	_seat(emmet, TABLE + Vector3(sin(a) * 1.65, 0, cos(a) * 1.65), a)
	box(Vector3(0.035, 0.05, 0.02), Vector3(0.056, -0.01, -0.088), mat(Color(0.35, 0.18, 0.3), 0.7), false, emmet.get_meta("head"))
	person("emmet", "Emmet", emmet, L("cast", "emmet_scan"))
	for f: Node3D in [turan, forner, emmet]:
		for arm in f.get_meta("arms"):
			(arm as Node3D).rotation.x = -1.1
	water = cyl(0.04, 0.035, 0.12, TABLE + Vector3(0.62, 0.86, -0.62), mat(Color(0.7, 0.85, 0.9), 0.05, 0.1), 10)
	water.visible = false
	# Emmet in the street, if he's the one who finds Carl at the subway
	var es := figure(Color(0.28, 0.38, 0.5), Color(0.9, 0.74, 0.64), {"hair": Color(0.8, 0.3, 0.1), "legs": Color(0.2, 0.2, 0.24), "arms": true, "knees": true, "long_coat": false})
	add_child(es)
	es.position = SPAWN + Vector3(1.2, -0.1, -2.4)
	es.visible = false
	es.set_meta("street_emmet", true)
	box(Vector3(0.035, 0.05, 0.02), Vector3(0.056, -0.01, -0.088), mat(Color(0.35, 0.18, 0.3), 0.7), false, es.get_meta("head"))
	set_meta("emmet_st", es)


func _dufredy() -> void:
	var skin := Color(0.8, 0.68, 0.6)
	dufredy = figure(Color(0.5, 0.5, 0.48), skin, {"hair": Color(0.88, 0.88, 0.84), "legs": Color(0.42, 0.42, 0.44), "arms": true, "knees": true, "long_coat": true})
	add_child(dufredy)
	_set_face(dufredy, _eyeless_face(skin, Color(0.88, 0.88, 0.84), 61, true))
	var hd: Node3D = dufredy.get_meta("head")
	hd.rotation.z = 0.08
	# the sockets drawn as absences: unlit, unfogged, no light gets out of them
	for sd: float in [-1.0, 1.0]:
		var v := sphere(0.024, Vector3(sd * 0.034, 0.018, -0.094), _void_m, 10, hd)
		v.scale = Vector3(1.15, 0.9, 0.55)
	var lip := mat(Color(0.4, 0.1, 0.1), 0.4)
	box(Vector3(0.075, 0.012, 0.01), Vector3(0, -0.062, -0.103), lip, false, hd)
	box(Vector3(0.06, 0.006, 0.01), Vector3(0, -0.06, -0.104), mat(Color(0.9, 0.88, 0.8), 0.3), false, hd)
	dufredy.position = Vector3(LU_DOOR, 0, LU.end.y + 1.2)
	dufredy.visible = false
	person("dufredy", "Dufredy", dufredy, L("dufredy", "scan"))


func _the_double() -> void:
	double = figure(Color(0.12, 0.12, 0.14), Color(0.84, 0.66, 0.54), {"hair": Color(0.12, 0.09, 0.07), "legs": Color(0.08, 0.08, 0.1), "arms": true, "knees": true})
	add_child(double)
	_set_face(double, _double_face())
	double.position = DOUBLE_AT
	double.rotation.y = PI / 2.0
	double.visible = false
	person("double", "The man in the alley", double, L("double", "scan"))


func _the_eyeless() -> void:
	var skin := Color(0.62, 0.5, 0.42)
	eyeless = figure(Color(0.3, 0.28, 0.26), skin, {"hair": Color(0.2, 0.18, 0.16), "legs": Color(0.22, 0.2, 0.2), "arms": true, "knees": true})
	add_child(eyeless)
	_set_face(eyeless, _eyeless_face(skin, Color(0.2, 0.18, 0.16), 1301, false))
	eyeless.position = CLUB_TOP
	eyeless.rotation.y = -PI / 2.0 - 0.3
	_eyeless_home = CLUB_TOP
	eyeless.set_meta("eyeless", true)
	var it := person("eyeless", "Look at it", eyeless, L("eyeless", "scan"))
	it.set_meta("eyeless", true)


# ------------------------------------------------------------------ the train downtown (ch.20)

func _train() -> void:
	var root := Node3D.new()
	root.position = TRAIN
	add_child(root)
	var panel := mat(Color(0.75, 0.76, 0.78), 0.4, 0.4)
	var floor_m := pbr("concrete", Vector3(1, 1, 1) / 1.5, true, Color(0.3, 0.3, 0.33), 0.6)
	var seat_m := mat(Color(0.12, 0.25, 0.45), 0.6)
	var glass: Material = _kit_mats()["glass"]
	box(Vector3(16, 0.2, 3.0), Vector3(0, -0.1, 0), floor_m, true, root)
	box(Vector3(16, 0.2, 3.0), Vector3(0, 2.4, 0), panel, false, root)
	box(Vector3(14, 0.06, 0.25), Vector3(0, 2.28, 0), glow(Color(0.85, 0.95, 1.0), 2.2), false, root)
	for zs: float in [-1.5, 1.5]:
		box(Vector3(16, 0.9, 0.1), Vector3(0, 0.45, zs), panel, true, root)
		box(Vector3(16, 0.5, 0.1), Vector3(0, 2.1, zs), panel, true, root)
		var x := -7.5
		while x < 8.0:
			box(Vector3(0.3, 0.95, 0.1), Vector3(x, 1.35, zs), panel, true, root)
			x += 2.5
		quad(Vector2(16, 0.95), Vector3(0, 1.35, zs * 0.99), 0.0 if zs < 0.0 else PI, glass, root)
		# the benches along each side, and the tunnel wall outside the glass
		box(Vector3(14, 0.1, 0.5), Vector3(0, 0.46, zs * 0.78), seat_m, false, root)
		box(Vector3(14, 0.5, 0.08), Vector3(0, 0.75, zs * 0.95), seat_m, false, root)
		box(Vector3(80, 4.0, 0.4), Vector3(0, 1.2, zs * 2.2), pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.18, 0.18, 0.2)), false, root)
		for k in 7:
			var s := box(Vector3(1.6, 0.08, 0.05), Vector3(-30.0 + k * 9.0, 1.7, zs * 1.98), glow(Color(1.0, 0.85, 0.5), 3.0), false, root)
			strips.append(s)
	for x: float in [-6.0, -2.0, 2.0, 6.0]:
		stick(Vector3(x, 0, 0) + TRAIN, Vector3(x, 2.3, 0) + TRAIN, 0.03, _metal)
	box(Vector3(0.1, 2.5, 3.0), Vector3(-8.0, 1.2, 0), panel, true, root)
	box(Vector3(0.1, 2.5, 3.0), Vector3(8.0, 1.2, 0), panel, true, root)
	# the doors on the far side, which open at the stop
	for sd: float in [-1.0, 1.0]:
		var d := box(Vector3(0.62, 1.95, 0.06), Vector3(3.0 + sd * 0.31, 1.0, -1.42), mat(Color(0.6, 0.62, 0.65), 0.35, 0.6), false, root)
		train_doors.append(d)
	box(Vector3(2.4, 0.5, 0.05), Vector3(3.0, 2.15, -1.4), glow(Color(1.0, 0.3, 0.7), 1.2), false, root)
	_screen_label("KID TOK. WATCH THEM GROW.", Vector3(3.0, 2.15, -1.36), 0.0016, Color(1, 1, 1), root)
	interactable("ad_t", "The ad", TRAIN + Vector3(3.0, 2.15, -1.3), Vector3(2.4, 0.5, 0.2), "", false)
	interactable("window_t", "The window", TRAIN + Vector3(-1.5, 1.35, -1.3), Vector3(2.0, 0.9, 0.2), "", false)
	_zl("train", TRAIN + Vector3(-3.0, 2.0, 0), Color(0.85, 0.95, 1.0), 1.4, 8.0)
	_zl("train", TRAIN + Vector3(3.5, 2.0, 0), Color(0.85, 0.95, 1.0), 1.2, 8.0)
	# Tyson Clerif, his cart of belongings beside him
	tyson = figure(Color(0.35, 0.28, 0.2), Color(0.55, 0.4, 0.3), {"hair": Color(0.3, 0.3, 0.3), "legs": Color(0.25, 0.22, 0.18), "arms": true, "knees": true})
	add_child(tyson)
	_seat(tyson, TRAIN + Vector3(1.3, 0, -1.15), PI)
	person("tyson", "Tyson", tyson, L("train", "tyson_scan"))
	var cart := Node3D.new()
	cart.position = TRAIN + Vector3(2.3, 0, -0.85)
	add_child(cart)
	box(Vector3(0.9, 0.5, 0.55), Vector3(0, 0.75, 0), pbr("fabric", Vector3(1, 1, 1), true, Color(0.3, 0.32, 0.25)), false, cart)
	box(Vector3(0.5, 0.35, 0.4), Vector3(0.1, 1.15, 0), mat(Color(0.15, 0.15, 0.18), 0.8), false, cart)
	for cx: float in [-0.45, 0.45]:
		for cz: float in [-0.28, 0.28]:
			stick(Vector3(cx, 0.1, cz), Vector3(cx, 1.0, cz), 0.012, _metal, cart)
			sphere(0.05, Vector3(cx, 0.06, cz), _dark, 6, cart)
	set_meta("cart", cart)


# ------------------------------------------------------------------ the sets only the picture camera sees

func _set_layer(n: Node, layer: int) -> void:
	if n is VisualInstance3D and not n is Light3D:
		(n as VisualInstance3D).layers = layer
	for c in n.get_children():
		_set_layer(c, layer)


## Mira's Tower, as she streams it on KID TOK: a floating stone in a shifting
## world, Mira on it, and opposite her the copy (ch.19).
func _kidtok_set() -> void:
	var root := Node3D.new()
	root.position = KT
	add_child(root)
	var dome := SphereMesh.new()
	dome.radius = 60.0
	dome.height = 120.0
	dome.flip_faces = true
	var dm := _unshaded(_tex_swirl())
	dm.cull_mode = BaseMaterial3D.CULL_DISABLED
	dm.disable_fog = true
	mesh(dome, Vector3.ZERO, dm, root)
	var rock := pbr("concrete", Vector3(1, 1, 1) / 1.5, true, Color(0.45, 0.35, 0.55), 1.0)
	var moss := mat(Color(0.25, 0.5, 0.45), 0.9)
	cyl(4.2, 1.2, 3.2, Vector3(0, -1.6, 0), rock, 14, root)
	cyl(4.25, 4.2, 0.2, Vector3(0, -0.1, 0), moss, 18, root)
	cyl(1.0, 0.1, 2.0, Vector3(0.4, -4.0, 0.3), rock, 10, root)
	var r := RandomNumberGenerator.new()
	r.seed = 1919
	for k in 9:
		var p := Vector3(r.randf_range(-16, 16), r.randf_range(-6, 7), r.randf_range(-20, -4))
		var s := r.randf_range(0.6, 2.2)
		cyl(s, s * 0.25, s * 1.4, p, rock, 8, root)
		cyl(s * 1.02, s, 0.12, p + Vector3(0, s * 0.7, 0), moss, 10, root)
	# the Tower behind, tiers of lit windows, a roof like a fantasy film
	var tw := Vector3(0, -14, -30)
	var tm := mat(Color(0.55, 0.5, 0.62), 0.6)
	var win := glow(Color(1.0, 0.82, 0.35), 2.6)
	var tiers := [[5.0, 12.0], [4.2, 9.0], [3.4, 8.0], [2.6, 7.0]]
	var y := 0.0
	for tr: Array in tiers:
		var rr := float(tr[0])
		var hh := float(tr[1])
		cyl(rr, rr * 1.05, hh, tw + Vector3(0, y + hh / 2.0, 0), tm, 16, root)
		cyl(rr * 1.12, rr * 1.12, 0.5, tw + Vector3(0, y + hh, 0), tm, 16, root)
		for k in 8:
			var a := TAU * k / 8.0
			box(Vector3(0.5, 0.9, 0.1), tw + Vector3(sin(a) * rr * 1.01, y + hh * 0.55, cos(a) * rr * 1.01), win, false, root).rotation.y = a
		y += hh
	cyl(0.1, 3.0, 8.0, tw + Vector3(0, y + 4.0, 0), mat(Color(0.3, 0.12, 0.4), 0.5), 16, root)
	sphere(1.0, tw + Vector3(0, y + 8.8, 0), glow(Color(1.0, 0.3, 0.25), 3.0), 12, root)
	# Mira, cross-legged on the stone, her hands pressed to her chest
	mira_k = figure(Color(0.82, 0.6, 0.75), Color(0.86, 0.68, 0.56), {"hair": Color(0.06, 0.05, 0.05), "long_hair": true,
		"legs": Color(0.82, 0.6, 0.75), "arms": true, "knees": true, "scale": 0.62, "long_coat": false})
	root.add_child(mira_k)
	mira_k.position = Vector3(-1.3, -0.25, 0.2)
	mira_k.rotation.y = -PI / 2.0
	var legs: Array = mira_k.get_meta("legs")
	for i in legs.size():
		var side := -1.0 if i == 0 else 1.0
		(legs[i] as Node3D).basis = Basis(Vector3.UP, -side * 1.0) * Basis(Vector3.RIGHT, 1.5)
	for kn in mira_k.get_meta("knees"):
		(kn as Node3D).rotation.x = -2.4
	for ar in mira_k.get_meta("arms"):
		var an := ar as Node3D
		an.rotation.x = 1.75
		an.rotation.z = -0.75 if an.position.x > 0.0 else 0.75
	(mira_k.get_meta("head") as Node3D).rotation.x = -0.15
	# the copy: me, but not me. Too calm. Too smooth.
	copy_k = figure(Color(0.12, 0.12, 0.14), Color(0.84, 0.66, 0.54), {"hair": Color(0.12, 0.09, 0.07), "legs": Color(0.08, 0.08, 0.1), "arms": true, "knees": true})
	root.add_child(copy_k)
	_set_face(copy_k, _copy_face())
	copy_k.position = Vector3(1.5, -0.02, 0.2)
	copy_k.rotation.y = PI / 2.0
	for ar in copy_k.get_meta("arms"):
		var an := ar as Node3D
		an.rotation.z = 0.32 if an.position.x > 0.0 else -0.32
		an.rotation.x = -0.25
	(copy_k.get_meta("head") as Node3D).rotation.x = 0.12
	_set_layer(root, LAYER20)


## Forner's flat in Lamplight (ch.20.5): the laundry, the takeout boxes, the
## chair facing the window, the computer he smashed.
func _forner_set() -> void:
	var root := Node3D.new()
	root.position = FL
	add_child(root)
	var wall := pbr("plaster", Vector3(1, 1, 1) / 2.0, true, Color(0.42, 0.44, 0.5), 0.9)
	var carpet := pbr("carpet", Vector3(1, 1, 1) / 1.2, true, Color(0.35, 0.33, 0.36), 1.0)
	var fabric := pbr("fabric", Vector3(1, 1, 1) / 0.8, true, Color(0.42, 0.32, 0.24), 1.0)
	floor_quad(Vector2(6, 5), Vector3(0, 0.0, 0), 0.0, carpet, root)
	box(Vector3(6, 0.1, 5), Vector3(0, 2.75, 0), wall, false, root)
	box(Vector3(0.1, 2.8, 5), Vector3(-3.0, 1.4, 0), wall, false, root)
	box(Vector3(0.1, 2.8, 5), Vector3(3.0, 1.4, 0), wall, false, root)
	box(Vector3(6, 2.8, 0.1), Vector3(0, 1.4, 2.5), wall, false, root)
	# the north wall is mostly window
	box(Vector3(6, 0.75, 0.1), Vector3(0, 0.375, -2.5), wall, false, root)
	box(Vector3(6, 0.4, 0.1), Vector3(0, 2.6, -2.5), wall, false, root)
	box(Vector3(1.0, 2.8, 0.1), Vector3(-2.5, 1.4, -2.5), wall, false, root)
	box(Vector3(1.0, 2.8, 0.1), Vector3(2.5, 1.4, -2.5), wall, false, root)
	for x: float in [-0.7, 0.7]:
		box(Vector3(0.06, 1.65, 0.12), Vector3(x, 1.57, -2.5), _dark, false, root)
	var city := _unshaded(_tex_city())
	city.disable_fog = true
	quad(Vector2(46, 22), Vector3(0, 6.0, -22.0), 0.0, city, root)
	# the chair that faces the city, and Forner in it
	box(Vector3(0.9, 0.42, 0.85), Vector3(0.2, 0.21, -1.0), fabric, false, root)
	box(Vector3(0.9, 0.85, 0.2), Vector3(0.2, 0.75, -0.55), fabric, false, root)
	for sd: float in [-0.45, 0.45]:
		box(Vector3(0.16, 0.62, 0.85), Vector3(0.2 + sd, 0.31, -1.0), fabric, false, root)
	forner_f = figure(Color(0.5, 0.42, 0.32), Color(0.72, 0.58, 0.45), {"hair": Color(0.55, 0.55, 0.52), "legs": Color(0.3, 0.26, 0.22), "arms": true, "knees": true, "long_coat": false, "scale": 1.06})
	root.add_child(forner_f)
	var s := 1.06
	forner_f.position = Vector3(0.2, 0.46 - 0.86 * s + 0.0, -0.9)
	forner_f.rotation.y = 0.0
	Anim.sit(forner_f, 0.2)
	(forner_f.get_meta("head") as Node3D).rotation.x = -0.25
	# laundry in drifts, the takeout boxes stacked in order
	var r := RandomNumberGenerator.new()
	r.seed = 2005
	var cloths := [Color(0.55, 0.55, 0.58), Color(0.2, 0.25, 0.4), Color(0.85, 0.85, 0.82), Color(0.4, 0.15, 0.15), Color(0.3, 0.3, 0.32)]
	for k in 16:
		var p := Vector3(r.randf_range(-2.7, 2.6), 0.04, r.randf_range(-1.8, 2.2))
		if absf(p.x - 0.2) < 0.7 and p.z < -0.3:
			continue
		var c := box(Vector3(r.randf_range(0.3, 0.8), r.randf_range(0.04, 0.14), r.randf_range(0.25, 0.6)), p, mat(cloths[k % cloths.size()], 1.0), false, root)
		c.rotation = Vector3(r.randf_range(-0.2, 0.2), r.randf() * TAU, r.randf_range(-0.2, 0.2))
	var tbox := mat(Color(0.92, 0.9, 0.85), 0.8)
	var tred := mat(Color(0.7, 0.08, 0.08), 0.8)
	for st in 3:
		for k in 3 + st:
			var bp := Vector3(-2.4 + st * 0.5, 0.08 + k * 0.15, 1.9)
			box(Vector3(0.3, 0.14, 0.24), bp, tbox, false, root).rotation.y = r.randf_range(-0.2, 0.2)
			box(Vector3(0.31, 0.03, 0.25), bp + Vector3(0, 0.02, 0), tred, false, root)
	# the desk and the computer he smashed, still on
	box(Vector3(0.7, 0.05, 1.3), Vector3(2.5, 0.75, 0.6), _wood, false, root)
	for lz: float in [0.05, 1.15]:
		box(Vector3(0.6, 0.72, 0.05), Vector3(2.5, 0.37, lz), _wood_dark, false, root)
	var mon := Node3D.new()
	mon.position = Vector3(2.55, 1.12, 0.6)
	mon.rotation.y = -PI / 2.0
	root.add_child(mon)
	box(Vector3(0.66, 0.44, 0.04), Vector3(0, 0, 0.02), _dark, false, mon)
	box(Vector3(0.06, 0.3, 0.06), Vector3(0, -0.3, 0.05), _dark, false, mon)
	quad(Vector2(0.6, 0.38), Vector3(0, 0, -0.005), PI, _unshaded(_tex_cracked()), mon)
	var l1 := _screen_label(str(LINES["forner"]["screen1"]), Vector3(0.12, 0.13, -0.01), 0.0007, Color(0.5, 1.0, 0.75), mon)
	l1.rotation.y = PI
	var l2 := _screen_label(str(LINES["forner"]["screen2"]), Vector3(0.0, -0.02, -0.01), 0.00055, Color(0.95, 0.95, 1.0), mon)
	l2.rotation.y = PI
	var kb := box(Vector3(0.18, 0.025, 0.24), Vector3(2.32, 0.79, 0.45), _dark, false, root)
	kb.rotation.y = 0.25
	var kb2 := box(Vector3(0.18, 0.025, 0.22), Vector3(2.35, 0.79, 0.72), _dark, false, root)
	kb2.rotation = Vector3(0.0, -0.3, 0.12)
	# his wife's photograph, where the chair can see it
	box(Vector3(0.36, 0.46, 0.03), Vector3(-1.6, 1.7, -2.43), _wood, false, root)
	box(Vector3(0.3, 0.4, 0.01), Vector3(-1.6, 1.7, -2.41), mat(Color(0.75, 0.6, 0.5), 0.4), false, root)
	_set_layer(root, LAYER20)


## The shifting sky of Mira's Tower: bands and swirls, teal, rose and gold.
func _tex_swirl() -> ImageTexture:
	var w := 256
	var h := 128
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	for y in h:
		for x in w:
			var u := float(x) / w * TAU
			var v := float(y) / h
			var s := sin(u * 3.0 + v * 9.0 + sin(u * 5.0) * 1.5) * 0.5 + 0.5
			var t := sin(u * 7.0 - v * 13.0) * 0.5 + 0.5
			var c := Color(0.1, 0.45, 0.5).lerp(Color(0.85, 0.35, 0.6), s).lerp(Color(1.0, 0.8, 0.4), t * t * 0.5)
			c = c.lerp(Color(0.05, 0.03, 0.12), clampf((v - 0.55) * 1.8, 0.0, 1.0))
			img.set_pixel(x, y, c)
	return ImageTexture.create_from_image(img)


## The city through Forner's window: light-polluted black, the towers, the tower.
func _tex_city() -> ImageTexture:
	var w := 320
	var h := 160
	var img := Image.create(w, h, false, Image.FORMAT_RGBA8)
	for y in h:
		img.fill_rect(Rect2i(0, y, w, 1), Color(0.04, 0.03, 0.07).lerp(Color(0.32, 0.14, 0.2), pow(float(y) / h, 1.6)))
	var r := RandomNumberGenerator.new()
	r.seed = 2050
	var x := 0
	while x < w:
		var bw := 8 + r.randi() % 18
		var bh := 20 + r.randi() % 70
		img.fill_rect(Rect2i(x, h - bh, bw, bh), Color(0.03, 0.03, 0.05))
		for k in bw * bh / 30:
			if r.randf() < 0.5:
				img.set_pixel(mini(w - 1, x + r.randi() % bw), h - bh + r.randi() % bh, [Color(1.0, 0.8, 0.5), Color(0.4, 0.9, 1.0), Color(1.0, 0.3, 0.6)][r.randi() % 3])
		x += bw + r.randi() % 4
	img.fill_rect(Rect2i(212, 8, 16, h - 8), Color(0.02, 0.02, 0.03))
	for k in 18:
		img.fill_rect(Rect2i(212, 14 + k * 8, 16, 1), Color(0.3, 0.9, 1.0))
	img.set_pixel(220, 4, Color(1, 0.1, 0.1))
	return ImageTexture.create_from_image(img)


## His computer's screen through the cracks: pale light, a dark star of breaks.
func _tex_cracked() -> ImageTexture:
	var img := Image.create(128, 80, false, Image.FORMAT_RGBA8)
	img.fill(Color(0.12, 0.16, 0.22))
	Body._rect(img, 0, 0, 128, 12, Color(0.08, 0.1, 0.14))
	var r := RandomNumberGenerator.new()
	r.seed = 117
	var c := Vector2(86, 44)
	for k in 14:
		var a := r.randf() * TAU
		var p := c
		for j in 6:
			var q := p + Vector2(cos(a), sin(a)) * r.randf_range(6, 14)
			Body._line(img, p.x, p.y, q.x, q.y, Color(0.9, 0.95, 1.0, 0.8), 1)
			p = q
			a += r.randf_range(-0.5, 0.5)
	Body._ell(img, c.x, c.y, 5, 5, Color(0.02, 0.02, 0.03))
	return ImageTexture.create_from_image(img)


# ------------------------------------------------------------------ the picture camera, and the black card

## A still from a camera that can see layer 20, lit for the moment it takes.
## lights: [[pos, colour, energy, range], ...]
func _picture(from: Vector3, at: Vector3, fov := 62.0, lights: Array = [], size := Vector2i(640, 400)) -> Image:
	var made := []
	for ld: Array in lights:
		var o := OmniLight3D.new()
		o.position = ld[0]
		o.light_color = ld[1]
		o.light_energy = float(ld[2])
		o.omni_range = float(ld[3])
		add_child(o)
		made.append(o)
	var vp := SubViewport.new()
	vp.size = size
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(vp)
	var cam := Camera3D.new()
	cam.fov = fov
	cam.near = 0.05
	cam.far = 300.0
	vp.add_child(cam)
	cam.global_transform = Transform3D(Basis.looking_at(at - from, Vector3.UP), from)
	cam.current = true
	for i in 4:
		await RenderingServer.frame_post_draw
	var img := vp.get_texture().get_image()
	vp.queue_free()
	for o in made:
		(o as Node).queue_free()
	if img == null:
		img = Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
	img.convert(Image.FORMAT_RGBA8)
	return img


## Three frames of the KID TOK stream, with the jitter and the overlay.
func _kid_frame(k: int) -> ImageTexture:
	var lights := [[KT + Vector3(-3, 4, 4), Color(0.4, 0.95, 0.9), 2.6, 16.0], [KT + Vector3(3, 3, 2), Color(1.0, 0.65, 0.45), 2.2, 12.0],
		[KT + Vector3(0, 2, -6), Color(0.9, 0.4, 1.0), 2.0, 20.0]]
	var img: Image
	if k == 0:
		img = await _picture(KT + Vector3(-3.6, 1.0, 3.4), KT + Vector3(-1.2, 0.35, 0.1), 52.0, lights)
	elif k == 1:
		img = await _picture(KT + Vector3(-2.9, 0.9, 1.0), KT + Vector3(1.5, 1.5, 0.2), 50.0, lights)
	else:
		img = await _picture(KT + Vector3(0.45, 1.68, 0.35), KT + Vector3(1.5, 1.68, 0.2), 30.0, lights)
	return _kidtok_post(img, k)


## Jitter, scanlines, a red LIVE badge, hearts going up the side.
func _kidtok_post(img: Image, k: int) -> ImageTexture:
	var w := img.get_width()
	var h := img.get_height()
	var r := RandomNumberGenerator.new()
	r.seed = 40 + k
	var src := img.duplicate() as Image
	for y in h:
		var sh := 0
		if r.randf() < 0.06:
			sh = r.randi_range(-10, 10)
		for x in w:
			var c := src.get_pixel(clampi(x + sh, 0, w - 1), y)
			var cr := src.get_pixel(clampi(x + sh + 3, 0, w - 1), y).r
			c = Color(cr, c.g, c.b)
			if y % 2 == 0:
				c = c.darkened(0.12)
			img.set_pixel(x, y, c)
	Body._rect(img, 18, 16, 64, 26, Color(0.9, 0.08, 0.15))
	_pixel_text(img, "LIVE", 26, 21, 3, Color(1, 1, 1))
	_pixel_text(img, ["41K", "58K", "102K"][k], 92, 21, 3, Color(1, 1, 1))
	for j in 6 + k * 3:
		var hx := w - 40 + r.randf_range(-12, 12)
		var hy := h - 70 - r.randf_range(0, h * 0.6)
		Body._ell(img, hx - 4, hy, 5, 5, Color(1.0, 0.35, 0.55, 0.9))
		Body._ell(img, hx + 4, hy, 5, 5, Color(1.0, 0.35, 0.55, 0.9))
		for yy in 8:
			Body._rect(img, hx - 9 + yy, hy + 2 + yy, 18 - yy * 2, 1, Color(1.0, 0.35, 0.55, 0.9))
	Body._rect(img, 0, h - 54, w, 54, Color(0.0, 0.0, 0.0, 0.55))
	for j in 3:
		Body._rect(img, 20, h - 46 + j * 14, r.randi_range(120, 300), 7, Color(0.85, 0.85, 0.9, 0.7))
	return ImageTexture.create_from_image(img)


const FONT3 := {"L": ["100", "100", "100", "100", "111"], "I": ["111", "010", "010", "010", "111"],
	"V": ["101", "101", "101", "101", "010"], "E": ["111", "100", "110", "100", "111"],
	"K": ["101", "110", "100", "110", "101"], "0": ["111", "101", "101", "101", "111"],
	"1": ["010", "110", "010", "010", "111"], "2": ["111", "001", "111", "100", "111"],
	"4": ["101", "101", "111", "001", "001"], "5": ["111", "100", "111", "001", "111"],
	"8": ["111", "101", "111", "101", "111"]}


func _pixel_text(img: Image, text: String, x: int, y: int, s: int, c: Color) -> void:
	var cx := x
	for ch in text:
		var g: Array = FONT3.get(ch, [])
		for row in g.size():
			var line := str(g[row])
			for col in line.length():
				if line[col] == "1":
					img.fill_rect(Rect2i(cx + col * s, y + row * s, s, s), c)
		cx += 4 * s


func _overlay() -> void:
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
	card_text.anchor_top = 0.3
	card_text.anchor_bottom = 0.7
	card_text.add_theme_font_size_override("normal_font_size", 22)
	card_text.add_theme_font_size_override("bold_font_size", 34)
	card_rect.add_child(card_text)
	panel_box = HBoxContainer.new()
	panel_box.anchor_left = 0.04
	panel_box.anchor_right = 0.96
	panel_box.anchor_top = 0.06
	panel_box.anchor_bottom = 0.62
	panel_box.add_theme_constant_override("separation", 18)
	panel_box.visible = false
	card_rect.add_child(panel_box)
	for k in 2:
		var tr := TextureRect.new()
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tr.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tr.size_flags_vertical = Control.SIZE_EXPAND_FILL
		panel_box.add_child(tr)


## Selftest trace.
func _st(s: String) -> void:
	if main._selftest and main._args.has("trace"):
		print("st ", s)


# ------------------------------------------------------------------ arrival (ch.19)

func _entry_kind() -> String:
	var f: Dictionary = main.flags
	if f.has("ev_turan_note") or f.has("turan_note"):
		return "note"
	if int(main.trust.get("lynx", 0)) >= 2:
		return "lynx"
	return "emmet"


func intro() -> void:
	if _ended or main.flags.has("rr_arrived"):
		return
	_busy = true
	_entry = _entry_kind()
	await _play(LINES["arrive"])
	await _entry_lines(_entry)
	await _play(LINES["sober"])
	main.ui.close()
	main.flags["rr_arrived"] = true
	main.flags["rr_entry_" + _entry] = true
	main.log_line("time", "Day 5, 20:40. Red Rock Plaza, half an hour early.")
	main.update_hud()
	_busy = false


func _entry_lines(kind: String) -> void:
	match kind:
		"note":
			await _play(LINES["entry_note"])
		"lynx":
			main.play("ding", -8.0, 1.2)
			await _play(LINES["entry_lynx"])
			main.log_line("event", "Lynx called from a blocked number: Lushon's, nine, the table at the back.")
		_:
			var es: Node3D = get_meta("emmet_st")
			es.visible = true
			es.position = SPAWN + Vector3(1.2, -0.1, -2.4)
			turn_to(es, main.player.global_position)
			await main.player.face(es.global_position + Vector3(0, 1.6, 0), 0.6)
			await _play(LINES["entry_emmet"])
			main.ui.close()
			_move(es, [Vector3(4.0, 0, 20.0), Vector3(4.0, 0, -24.0), Vector3(LU_DOOR + 0.3, 0, -36.0), Vector3(LU_DOOR, 0, LU.end.y + 0.4)], 2.4)
			es.set_meta("hide_at_end", true)


# ------------------------------------------------------------------ the casino and the walls

func _casino_by() -> void:
	_busy = true
	await _think(L("casino", "walk_by"))
	main.ui.close()
	main.flags["rr_casino"] = true
	_busy = false


func _scripture() -> void:
	var f: Dictionary = main.flags
	if f.has("rr_scripture"):
		await _think(L("casino", "scripture_again"))
		if not f.has("rr_wet_touch"):
			f["rr_wet_touch"] = true
			await _think(L("casino", "wet_touch"))
		return
	if not f.has("rr_casino"):
		f["rr_casino"] = true
		await _think(L("casino", "walk_by"))
	await _think(L("casino", "scripture_intro"))
	await _say("", L("casino", "scripture"))
	await _think(L("casino", "scripture_1"))
	await _think(L("casino", "scripture_2"))
	await _think(L("casino", "scripture_3"))
	f["rr_scripture"] = true
	main.add_connection(1.0, "the wet words")
	main.log_line("scripture", L("casino", "log_scripture"))


func _slots() -> void:
	await _think(L("casino", "slots"))
	var i := await _pick(LINES["casino"]["slots_ch"])
	if i == 1:
		return
	main.ui.flash(0.05)
	if main.frames_on:
		main.play("jingle", -10.0, 0.7)
		await _think(L("casino", "slots_eyes"))
		if not main.flags.has("rr_slots"):
			main.flags["rr_slots"] = true
			main.add_connection(2.0, "pulled the arm")
			main.log_line("clue", L("casino", "log_slots"))
	else:
		main.play("tap", -6.0, 0.6)
		await _think(L("casino", "slots_plain"))


func _graffiti() -> void:
	var f: Dictionary = main.flags
	if f.has("rr_graffiti"):
		await _think(L("graffiti", "again"))
		return
	await _think(L("graffiti", "intro"))
	await _say("", L("graffiti", "text"))
	await _think(L("graffiti", "voice_intro"))
	main.play("whisper", -2.0, 0.9)
	main.ui.glitch(0.5, 0.5)
	main.ui.caption(L("graffiti", "voice_cap"), 3.5)
	await _say("", L("graffiti", "voice"))
	f["rr_graffiti"] = true
	main.add_connection(1.0, "the voice in my ear")
	main.log_line("scripture", L("graffiti", "log"))
	main.ui.close()
	if main.connection >= 50.0:
		if main.frames_on:
			await _double()
		else:
			await _think(L("graffiti", "breath"))


# ------------------------------------------------------------------ the alley double (bible-1 Confrontations, Connection >= 50)

func _double() -> void:
	var f: Dictionary = main.flags
	if f.has("rr_double_done") or main.connection < 50.0:
		await _think(L("double", "empty") if not f.has("rr_double_done") else L("double", "after"))
		return
	_busy = true
	f["rr_double_seen"] = true
	_double_closer = 0
	double.visible = true
	double.position = DOUBLE_AT
	main.play("whisper", -6.0, 0.6)
	await main.player.face((double.get_meta("head") as Node3D).global_position, 0.8)
	await _think(L("double", "appear"))
	main.ui.flash(0.08)
	main.play("sting", -6.0)
	await _think(L("double", "face"))
	var outcome := ""
	for round_i in 3:
		await _think(L("double", "round"))
		var opts := [L("double", "opt_tear"), L("double", "opt_look"), L("double", "opt_run")]
		var words := []
		if "mimic" in main.lexicon:
			opts.append(L("double", "opt_mimic"))
			words.append("mimic")
		if "bow" in main.lexicon:
			opts.append(L("double", "opt_bow"))
			words.append("bow")
		var i := await _pick(opts)
		if i == 0:
			outcome = "refused"
			break
		elif i == 2:
			outcome = "ran"
			break
		elif i >= 3:
			outcome = "named" if words[i - 3] == "mimic" else "bowed"
			break
		# Look: with the frames on at >= 50 it does not end; it comes closer
		_double_closer += 1
		main.add_connection(1.0, L("double", "why_look"))
		if _double_closer == 1:
			await _think(L("double", "look_1"))
			var toward: Vector3 = (main.player.global_position - double.global_position) * Vector3(1, 0, 1)
			double.position += toward * 0.45
		else:
			outcome = "touched"
			break
	if outcome == "":
		outcome = "touched"
	match outcome:
		"refused":
			if main.frames_on:
				main.toggle_frames()
			double.visible = false
			await _think(L("double", "tear_1"))
			await _think(L("double", "tear_2"))
		"named":
			main.ui.glitch(0.6, 0.4)
			await _say("Carl", "Mimic.")
			double.visible = false
			await _think(L("double", "mimic"))
		"bowed":
			main.add_connection(3.0, L("double", "why_bow"))
			double.visible = false
			await _think(L("double", "bow"))
		"ran":
			main.add_connection(1.0, L("double", "why_run"))
			await main.ui.fade_to(1.0, 0.4)
			double.visible = false
			_reposition()
			await main.ui.fade_to(0.0, 0.5)
			await _think(L("double", "run"))
		"touched":
			await _think(L("double", "look_2"))
			var p := main.player.global_position as Vector3
			double.position = p + (double.global_position - p).normalized() * 0.8
			double.position.y = 0.0
			turn_to(double, p)
			main.play("whisper", 0.0, 0.5)
			await _think(L("double", "touched_1"))
			main.add_connection(5.0, L("double", "why_touch"))
			main.player.shake(0.6)
			await main.ui.fade_to(1.0, 0.3)
			double.visible = false
			_reposition()
			await main.ui.fade_to(0.0, 0.8)
			await _think(L("double", "touched_2"))
	f["rr_double_done"] = true
	f["rr_double_" + outcome] = true
	main.log_line("encounter", L("double", "log"))
	main.ui.close()
	_busy = false


## Back to the top of the subway stairs: one street back.
func _reposition() -> void:
	main.player.position = SPAWN
	main.player.velocity = Vector3.ZERO
	main.player.yaw = 0.0
	main.player.pitch = 0.0


# ------------------------------------------------------------------ the plaza's small things

func _smoothie() -> void:
	var f: Dictionary = main.flags
	turn_to(vendor, main.player.global_position, 0.4)
	await _think(L("plaza", "smoothie"))
	var i := await _pick(LINES["plaza"]["smoothie_ch"])
	if i == 1:
		return
	if f.has("rr_smoothie"):
		await _say("Ana", L("plaza", "smoothie_again"))
	else:
		f["rr_smoothie"] = true
		await _say("Ana", L("plaza", "smoothie_say"))
		main.add_pressure(-2.0, L("plaza", "why_smoothie"))
	await _think(L("plaza", "smoothie_drink"))
	if main.connection >= 25.0 and not f.has("rr_smoothie_eye"):
		f["rr_smoothie_eye"] = true
		await _think(L("plaza", "smoothie_eye"))
		main.add_connection(1.0, L("plaza", "why_lid"))


func _eyeless_touch() -> void:
	_busy = true
	main.play("whisper", 0.0, 0.4)
	main.player.shake(0.5)
	await main.ui.fade_to(1.0, 0.3)
	main.add_connection(5.0, L("eyeless", "why"))
	_reposition()
	eyeless.position = _eyeless_home
	await main.ui.fade_to(0.0, 0.8)
	await _think(L("eyeless", "touched"))
	main.ui.close()
	main.flags["rr_eyeless_touched"] = true
	_busy = false


# ------------------------------------------------------------------ Lushon's (ch.19)

func _enter_lushons() -> void:
	_busy = true
	main.flags["lu_in"] = true
	await _think(L("lushons", "enter_1"))
	await _think(L("lushons", "enter_2"))
	await _think(L("lushons", "enter_3"))
	await _think(L("lushons", "enter_4"))
	var arm: Node3D = (turan.get_meta("arms") as Array)[1]
	arm.rotation.x = 2.6
	await _say("Turan", L("lushons", "turan_call"))
	await _think(L("lushons", "table"))
	arm.rotation.x = -1.1
	main.ui.close()
	main.update_hud()
	_busy = false


func _dispenser() -> void:
	await _think(L("lushons", "dispenser"))
	var i := await _pick(LINES["lushons"]["dispenser_ch"])
	if i == 1:
		await _think(L("lushons", "dispenser_leave"))
		return
	main.play("tap", -4.0, 1.3)
	await _think(L("lushons", "dispenser_pour"))
	if not main.flags.has("lu_drink"):
		main.flags["lu_drink"] = true
		main.add_connection(2.0, L("lushons", "why_drink"))
		main.log_line("clue", L("lushons", "log_drink"))


## The round table: the confession, Forner, Emmet, the KID TOK clip, the
## facility (the scene's choice), Hameron, then Dufredy walks in.
func _meeting() -> void:
	var f: Dictionary = main.flags
	if f.has("lushons_done") or _in_meeting:
		return
	_in_meeting = true
	_busy = true
	f["cinematic"] = true
	if not f.has("lu_in"):
		f["lu_in"] = true
	_st("_meeting 306")
	await main.ui.fade_to(1.0, 0.4)
	var p = main.player
	p.position = CARL_SEAT
	p.velocity = Vector3.ZERO
	p.seated = true
	p.crouch = 0.42
	p.yaw = 0.0
	p.pitch = -0.08
	_st("_meeting 315")
	await main.ui.fade_to(0.0, 0.5)
	var m: Dictionary = LINES["meet"]
	_st("_meeting 318")
	await _play(m["sit_1"])
	_st("_meeting 320")
	await _play(m["lynx_called"] if _entry == "lynx" else m["lynx_gone"])
	_st("_meeting 322")
	await _play(m["first"])
	_st("_meeting 324")
	await _play(m["confession"])
	main.log_line("testimony", str(m["log_confession"]))
	_st("_meeting 327")
	await _play(m["forner"])
	main.log_line("testimony", str(m["log_forner"]))
	water.visible = true
	_st("_meeting 331")
	await _play(m["emmet"])
	main.log_line("testimony", str(m["log_emmet"]))
	_st("_meeting 334")
	await _play(m["kids"])
	_st("_meeting 336")
	await _kidtok()
	f["claim_the_copy"] = true
	main.ui.show_toast(str(m["claim"]), 3.0)
	main.log_line("claim", str(m["log_video"]))
	_st("_meeting 341")
	await _play(m["real"])
	_st("_meeting 343")
	await _play(m["ask"])
	_st("_meeting 345")
	await _facility_choice()
	_st("_meeting 347")
	await _play(m["gasp"])
	_st("_meeting 349")
	await _play(m["hameron"])
	f["cognizo_open"] = true
	main.ui.show_toast(str(m["cognizo_toast"]), 3.5)
	main.log_line("lead", str(m["log_hameron"]))
	main.ui.close()
	_st("_meeting 355")
	await _dufredy_scene()
	_st("_meeting 357")
	await _play(LINES["plan"]["lines"])
	_st("_meeting 359")
	await _play(LINES["plan"]["pip"] if f.has("pip_active") else LINES["plan"]["nopip"])
	_st("_meeting 361")
	await _play(LINES["plan"]["end"])
	main.ui.close()
	f["lushons_done"] = true
	main.log_line("event", L("plan", "log"))
	main.log_line("time", "Day 5, 23:30. Lushon's.")
	main.ui.show_toast(L("plan", "done_toast"), 3.0)
	_st("_meeting 368")
	await main.ui.fade_to(1.0, 0.4)
	p.seated = false
	p.crouch = 0.0
	p.position = CARL_SEAT + Vector3(0.0, 0.05, 1.2)
	p.pitch = 0.0
	_st("_meeting 374")
	await main.ui.fade_to(0.0, 0.5)
	f.erase("cinematic")
	_in_meeting = false
	_busy = false
	main.update_hud()


func _kidtok() -> void:
	var m: Dictionary = LINES["meet"]
	main.play("on", -8.0, 1.3)
	main.ui.glitch(0.5, 0.4)
	for k in 3:
		var tex := await _kid_frame(k)
		main.ui.show_picture(tex, str(m["v%d_cap" % (k + 1)]))
		main.ui.glitch(0.25, 0.25)
		_st("_kidtok 390")
		await _think(str(m["v%d" % (k + 1)]))
	main.ui.hide_picture()
	main.play("off", -8.0, 1.3)


func _facility_choice() -> void:
	var f: Dictionary = main.flags
	var m: Dictionary = LINES["meet"]
	var i := await _pick(m["choices"])
	match i:
		0:
			await _play(m["facility"])
			await _play(m["mimic"])
			main.add_trust("turan", 1)
			main.add_trust("emmet", 1)
			f["told_team_mimic"] = true
		1:
			await _think(str(m["holdback"]))
			await _play(m["facility"])
		_:
			await _play(m["hiding"])
			main.add_trust("turan", -1)
			f["turan_admitted_audit"] = true
			main.log_line("testimony", str(m["log_audit"]))
			await _think(str(m["holdback"]))
			await _play(m["facility"])
	f["told_team_facility"] = true
	f["lu_facility_" + str(i)] = true


# ------------------------------------------------------------------ Dufredy walks in (no verbs)

var _duf_track := false


func _dufredy_scene() -> void:
	var f: Dictionary = main.flags
	var d: Dictionary = LINES["dufredy"]
	# the room's audio ducks; the lullaby, backward, under a sub drone
	_duck.clear()
	for k in main.amb:
		var ap = main.amb[k]
		if is_instance_valid(ap):
			_duck[k] = ap.volume_db
			create_tween().tween_property(ap, "volume_db", -60.0, 1.6)
	_duf_ap.volume_db = -40.0
	_duf_ap.play()
	create_tween().tween_property(_duf_ap, "volume_db", -3.0, 2.5)
	var door := Vector3(LU_DOOR, 0, LU.end.y + 0.4)
	var stand := CARL_SEAT + Vector3(-1.25, 0, 0.55)
	dufredy.position = door
	dufredy.rotation.y = 0.0
	dufredy.visible = true
	_move(dufredy, [Vector3(LU_DOOR, 0, LU.end.y - 2.0), Vector3(LU_DOOR, 0, LU.end.y - 4.4), Vector3(LU_DOOR - 0.6, 0, -49.0), stand], 0.75)
	_duf_track = true
	_st("_dufredy_scene 446")
	await _think(str(d["walk_in"]))
	_st("_dufredy_scene 448")
	await _think(str(d["voids"]))
	_st("_dufredy_scene 450")
	await _think(str(d["approach"]))
	_st("_dufredy_scene 452")
	await _arrive(dufredy, 40.0)
	turn_to(dufredy, main.player.global_position, 0.8)
	_st("_dufredy_scene 455")
	await _think(str(d["stand"]))
	_st("_dufredy_scene 457")
	await _say("Dufredy", str(d["d1"]))
	_st("_dufredy_scene 459")
	await _think(str(d["smile"]))
	_st("_dufredy_scene 461")
	await _say("Dufredy", str(d["d2"]))
	main.player.shake(0.25)
	_st("_dufredy_scene 464")
	await _think(str(d["rage"]))
	_st("_dufredy_scene 466")
	await _think(str(d["to_forner"]))
	turn_to(dufredy, (forner.get_meta("head") as Node3D).global_position, 0.8)
	_st("_dufredy_scene 469")
	await _say("Dufredy", str(d["d3"]))
	_st("_dufredy_scene 471")
	await _think(str(d["frozen"]))
	_st("_dufredy_scene 473")
	await _think(str(d["turan_up"]))
	_st("_dufredy_scene 475")
	await _say("Turan", str(d["t1"]))
	_st("_dufredy_scene 477")
	await _think(str(d["to_turan"]))
	turn_to(dufredy, (turan.get_meta("head") as Node3D).global_position, 0.8)
	_st("_dufredy_scene 480")
	await _say("Dufredy", str(d["d4"]))
	_st("_dufredy_scene 482")
	await _say("Dufredy", str(d["d5"]))
	_st("_dufredy_scene 484")
	await _think(str(d["left"]))
	main.ui.close()
	_move(dufredy, [Vector3(LU_DOOR - 0.6, 0, -49.0), Vector3(LU_DOOR, 0, LU.end.y - 4.4), Vector3(LU_DOOR, 0, LU.end.y - 2.0), door + Vector3(0, 0, 1.5)], 0.75)
	_st("_dufredy_scene 488")
	await _arrive(dufredy, 30.0)
	dufredy.visible = false
	_duf_track = false
	# the room tone comes back
	for k in _duck:
		var ap = main.amb.get(k)
		if is_instance_valid(ap):
			create_tween().tween_property(ap, "volume_db", float(_duck[k]), 2.0)
	var tw := create_tween()
	tw.tween_property(_duf_ap, "volume_db", -60.0, 2.0)
	tw.tween_callback(_duf_ap.stop)
	_st("_dufredy_scene 500")
	await main.player.face((turan.get_meta("head") as Node3D).global_position, 0.8)
	_st("_dufredy_scene 502")
	await _think(str(d["after_1"]))
	_st("_dufredy_scene 504")
	await _think(str(d["after_2"]))
	_st("_dufredy_scene 506")
	await _think(str(d["after_3"]))
	f["dufredy_lushons"] = true
	main.log_line("encounter", str(d["log"]))


# ------------------------------------------------------------------ 23:30: the walk out and the monolith (ch.20)

func _walk_out() -> void:
	_busy = true
	_walked_out = true
	var w: Dictionary = LINES["walk_out"]
	await _think(str(w["puppet"]))
	await _think(str(w["pip"] if main.flags.has("pip_active") else w["nopip"]))
	if main.flags.has("spa_booked"):
		await _think(str(w["spa"]))
	await _think(str(w["neon"]))
	main.ui.close()
	main.update_hud()
	_busy = false


func _monolith() -> void:
	var f: Dictionary = main.flags
	if f.has("rr_monolith") or _monolith_on:
		return
	_monolith_on = true
	_busy = true
	f["cinematic"] = true
	var t: Dictionary = LINES["monolith"]
	_scr("ad")
	await main.player.face(SCREEN_C, 1.4)
	await _think(str(t["screen_1"]))
	await _think(str(t["screen_2"]))
	await _think(str(t["ad"]))
	await _think(str(t["laugh"]))
	main.play("glitch", -4.0)
	main.ui.glitch(0.4, 0.4)
	_scr("chat")
	_load_bar.scale.x = 0.01
	create_tween().tween_property(_load_bar, "scale:x", 1.0, 1.4)
	await _think(str(t["chat"]))
	main.play("static", -10.0)
	_scr("msg")
	await _say(str(t["msg_who"]), str(t["msg"]))
	_scr("kids")
	main.play("chant", -14.0, 1.3)
	await _think(str(t["kids"]))
	_scr("black")
	main.play("off", -6.0, 0.6)
	await _think(str(t["kids_2"]))
	main.ui.close()
	f["rr_monolith"] = true
	main.log_line("broadcast", str(t["log"]))
	f.erase("cinematic")
	main.update_hud()
	_busy = false


# ------------------------------------------------------------------ the train, and Tyson (ch.20)

func _train_beat() -> void:
	var f: Dictionary = main.flags
	if f.has("tyson_subway") or _ended:
		return
	_busy = true
	f["cinematic"] = true
	var t: Dictionary = LINES["train"]
	_st("_train_beat 574")
	await main.ui.fade_to(1.0, 0.6)
	_set_zone("train")
	var p = main.player
	p.position = TRAIN + Vector3(0.4, 0.0, 1.05)
	p.velocity = Vector3.ZERO
	p.seated = true
	p.crouch = 0.42
	p.yaw = 0.0
	p.pitch = -0.06
	train_speed = 16.0
	_engine_ap.play()
	_engine_ap.volume_db = -12.0
	_st("_train_beat 587")
	await main.ui.fade_to(0.0, 0.8)
	_st("_train_beat 589")
	await _think(str(t["board"]))
	_st("_train_beat 591")
	await _think(str(t["eyes"]))
	_st("_train_beat 593")
	await _play(t["lines"])
	_st("_train_beat 595")
	await _think(str(t["stop"]))
	var tw := create_tween()
	tw.tween_property(self, "train_speed", 0.0, 2.0)
	_st("_train_beat 599")
	await tw.finished
	main.play("door", -6.0, 1.2)
	for d in train_doors:
		var dm := d as MeshInstance3D
		create_tween().tween_property(dm, "position:x", dm.position.x + (0.6 if dm.position.x > 3.0 else -0.6), 0.8)
	# he stands, takes his cart, and stops at the door
	for k in tyson.get_meta("legs"):
		(k as Node3D).rotation.x = 0.0
	for k in tyson.get_meta("knees"):
		(k as Node3D).rotation.x = 0.0
	(tyson.get_meta("body") as Node3D).rotation.x = 0.0
	tyson.position = TRAIN + Vector3(1.3, 0, -0.9)
	tyson.remove_meta("seated")
	var cart: Node3D = get_meta("cart")
	_move(tyson, [TRAIN + Vector3(2.6, 0, -0.9), TRAIN + Vector3(3.0, 0, -1.2)], 1.0)
	create_tween().tween_property(cart, "position", TRAIN + Vector3(3.2, 0, -0.5), 1.6)
	_st("_train_beat 616")
	await _arrive(tyson, 10.0)
	turn_to(tyson, p.global_position, 0.5)
	_st("_train_beat 619")
	await _say("Tyson", str(t["last"]))
	main.ui.close()
	_move(tyson, [TRAIN + Vector3(3.0, 0, -2.6)], 1.0)
	create_tween().tween_property(cart, "position", TRAIN + Vector3(3.2, 0, -2.6), 1.4)
	_st("_train_beat 624")
	await _arrive(tyson, 10.0)
	tyson.visible = false
	cart.visible = false
	main.play("slam", -8.0, 1.4)
	for d in train_doors:
		var dm := d as MeshInstance3D
		create_tween().tween_property(dm, "position:x", 3.0 + (0.31 if dm.position.x > 3.0 else -0.31), 0.6)
	create_tween().tween_property(self, "train_speed", 16.0, 3.0)
	_st("_train_beat 633")
	await _think(str(t["door"]))
	_st("_train_beat 635")
	await _think(str(t["end"]))
	main.ui.close()
	f["tyson_subway"] = true
	main.log_line("testimony", str(t["log"]))
	if not f.has("tablet_smashed") and not f.has("smash_used"):
		card_text.text = "[center]" + str(t["smash"]) + "[/center]"
		card_rect.visible = true
		_st("_train_beat 643")
		await get_tree().create_timer(3.5).timeout
		card_rect.visible = false
		card_text.text = ""
		f["smash_explained"] = true
	_st("_train_beat 648")
	await _forner_cutscene()
	_busy = false
	_end()


# ------------------------------------------------------------------ A2-B3.5: Forner alone (ch.20.5), two panels

func _forner_cutscene() -> void:
	var f: Dictionary = main.flags
	var t: Dictionary = LINES["forner"]
	card_text.text = "[center]" + str(t["card"]) + "[/center]"
	card_rect.visible = true
	_engine_ap.stop()
	_st("_forner_cutscene 662")
	await get_tree().create_timer(2.2).timeout
	card_text.text = ""
	var room_l := [[FL + Vector3(0, 2.0, -2.0), Color(0.45, 0.6, 1.0), 1.6, 7.0], [FL + Vector3(-2.0, 2.2, 1.6), Color(1.0, 0.7, 0.45), 0.7, 6.0],
		[FL + Vector3(2.0, 1.2, 0.6), Color(0.6, 0.8, 1.0), 1.2, 3.0]]
	var p1 := await _picture(FL + Vector3(-1.9, 1.75, 1.7), FL + Vector3(0.3, 1.0, -2.2), 62.0, room_l)
	var p2 := await _picture(FL + Vector3(1.55, 1.2, 0.85), FL + Vector3(2.5, 1.1, 0.58), 40.0, room_l)
	var trs := panel_box.get_children()
	(trs[0] as TextureRect).texture = ImageTexture.create_from_image(p1)
	(trs[1] as TextureRect).texture = ImageTexture.create_from_image(p2)
	(trs[1] as TextureRect).modulate = Color(1, 1, 1, 0.25)
	panel_box.visible = true
	main.ui.caption(str(t["cap"]), 4.0)
	for k in ["l1", "l2", "l3", "l4", "l5"]:
		_st("_forner_cutscene 676")
		await _think(str(t[k]))
	(trs[1] as TextureRect).modulate = Color(1, 1, 1, 1)
	main.play("ding", -2.0, 1.0)
	_st("_forner_cutscene 680")
	await _think(str(t["l6"]))
	_st("_forner_cutscene 682")
	await _say(str(t["who"]), str(t["call"]))
	main.ui.close()
	f["forner_called"] = true
	main.log_line("event", str(t["log"]))


func _end() -> void:
	if _ended:
		return
	_ended = true
	main.flags.erase("cinematic")
	main.update_hud()
	if not main._selftest:
		main.load_level("Spa")
	else:
		panel_box.visible = false
		card_rect.visible = false


# ------------------------------------------------------------------ scripted walks

## Walk a figure along a path of ground points (the Dufredy walk has no idle:
## when he stops he stops, the pose held like a photograph).
func _move(fig: Node3D, path: Array, speed: float) -> void:
	for mv: Dictionary in movers:
		if mv["fig"] == fig:
			movers.erase(mv)
			break
	if fig.has_meta("seated"):
		fig.remove_meta("seated")
	if not path.is_empty():
		fig.position.y = (path[0] as Vector3).y
	movers.append({"fig": fig, "path": path, "i": 0, "speed": speed})


## Wait until a figure's walk is done (or the timeout, in game seconds).
func _arrive(fig: Node3D, timeout: float) -> void:
	var t := 0.0
	while t < timeout:
		var going := false
		for mv: Dictionary in movers:
			if mv["fig"] == fig:
				going = true
				break
		if not going:
			return
		await get_tree().process_frame
		t += get_process_delta_time()
	# timed out: put him where he was going
	for mv: Dictionary in movers:
		if mv["fig"] == fig:
			var path: Array = mv["path"]
			fig.position = path[path.size() - 1]
			movers.erase(mv)
			break


func _step_movers(delta: float) -> void:
	for mv: Dictionary in movers.duplicate():
		var fig: Node3D = mv["fig"]
		if not is_instance_valid(fig):
			movers.erase(mv)
			continue
		var path: Array = mv["path"]
		var i: int = mv["i"]
		var target: Vector3 = path[i]
		var d := target - fig.position
		d.y = 0.0
		var step := float(mv["speed"]) * delta
		if d.length() <= step:
			fig.position = Vector3(target.x, fig.position.y, target.z)
			mv["i"] = i + 1
			if i + 1 >= path.size():
				movers.erase(mv)
				for l in fig.get_meta("legs", []):
					(l as Node3D).rotation.x = 0.0
				for k in fig.get_meta("knees", []):
					(k as Node3D).rotation.x = 0.0
				if fig.has_meta("hide_at_end"):
					fig.visible = false
					fig.remove_meta("hide_at_end")
			continue
		fig.position += d.normalized() * step
		var want := atan2(-d.x, -d.z)
		fig.rotation.y = lerp_angle(fig.rotation.y, want, minf(1.0, delta * 6.0))
		# Dufredy walks like a man being carried by the walk: a short stride,
		# no arm swing to speak of, the head dead level
		if fig == dufredy:
			Anim.walk(fig, _t, 0.55, 0.0, 0.45)
			for a in fig.get_meta("arms", []):
				(a as Node3D).rotation.x = 0.0
		else:
			Anim.walk(fig, _t, float(mv["speed"]) * 0.8, 0.0, 1.0)


# ------------------------------------------------------------------ per frame

func _zone_of(pp: Vector3) -> String:
	if pp.x > 300.0:
		return "train"
	if LU.has_point(Vector2(pp.x, pp.z)) and pp.y < 5.0:
		return "lush"
	return "plaza"


func tick(delta: float) -> void:
	if not main or not main.player:
		return
	var f: Dictionary = main.flags
	var pp: Vector3 = main.player.global_position
	var free: bool = not _busy and not main.ui.busy and not _ended
	# the zones: each one lights only itself (the light budget)
	var zn := _zone_of(pp)
	if zn != zone:
		var was := zone
		_set_zone(zn)
		if zn == "lush" and f.has("rr_arrived") and not f.has("lu_in") and free:
			_enter_lushons()
		elif zn == "plaza" and was == "lush" and f.has("lushons_done") and not _walked_out and free:
			_walk_out()
	# 23:30: out in the plaza again, the screen changes
	if free and f.has("lushons_done") and _walked_out and not f.has("rr_monolith") and zone == "plaza" and pp.z > -32.0:
		_monolith()
	# the slots: three eyes with the frames, fruit without
	if main.frames_on != _frames_seen:
		_frames_seen = main.frames_on
		for q in slot_screens:
			(q as MeshInstance3D).material_override = _reel_eyes if _frames_seen else _reel_plain
	# the double: only with the frames, only past 50; taking them off ends it
	if double.visible and not main.frames_on:
		double.visible = false
	if free and main.frames_on and main.connection >= 50.0 and f.has("rr_graffiti") and not f.has("rr_double_done") \
			and pp.distance_to(Vector3(41, pp.y, 0)) < 9.0:
		_double()
	# the eyeless at the club stairs: a statue, until the frames are on
	if eyeless and main.frames_on and f.has("rr_arrived") and zone == "plaza":
		var to := pp - eyeless.global_position
		to.y = 0.0
		if to.length() < 16.0 and free:
			if to.length() < 0.9:
				_eyeless_touch()
			else:
				eyeless.position += to.normalized() * 1.3 * delta
				eyeless.rotation.y = atan2(-to.x, -to.z)
				Anim.walk(eyeless, _t, 1.0, 0.0, 0.7)
	# the casino on the way past
	if free and f.has("rr_arrived") and not f.has("rr_casino") and pp.distance_to(Vector3(-40, pp.y, 11)) < 7.0:
		_casino_by()
	_step_movers(delta)
	# the hidden ones are parked under the street, out of the way of their colliders
	for fig: Node3D in [double, dufredy, get_meta("emmet_st") as Node3D]:
		if fig and not fig.visible and fig.position.y > -40.0:
			fig.position.y = -50.0
	# the loop walkers, arm in arm
	for w: Dictionary in walkers:
		var wf: Node3D = w["fig"]
		var pts: Array = w["pts"]
		var tgt: Vector3 = (pts[int(w["i"])] as Vector3) + (w["off"] as Vector3)
		var d := tgt - wf.position
		d.y = 0.0
		if d.length() < 0.3:
			w["i"] = (int(w["i"]) + 1) % pts.size()
		else:
			wf.position += d.normalized() * float(w["speed"]) * delta
			wf.rotation.y = lerp_angle(wf.rotation.y, atan2(-d.x, -d.z), minf(1.0, delta * 3.0))
		Anim.walk(wf, _t, float(w["speed"]), float(w["phase"]), 0.8)
	# the plaza people
	if zone == "plaza":
		for pe: Dictionary in people:
			var pf: Node3D = pe["fig"]
			match str(pe["mode"]):
				"idle":
					Anim.idle(pf, _t, float(pe["phase"]))
					if pe.has("look"):
						Anim.look(pf, pp + Vector3(0, 1.6, 0), 0.8 if pp.distance_to(pf.global_position) < 7.0 else 0.0, 0.05)
				"kneel":
					(pf.get_meta("body") as Node3D).rotation.x = 0.7 + sin(_t * 0.7 + float(pe["phase"])) * 0.04
				"sit":
					(pf.get_meta("body") as Node3D).scale.y = 1.0 + sin(_t * 1.3 + float(pe["phase"])) * 0.006
	# the round table: they breathe, and they look at whoever is talking
	if zone == "lush":
		var who := {"Turan": turan, "Forner": forner, "Emmet": emmet, "Dufredy": dufredy}
		var cam_p: Vector3 = main.player.cam.global_position
		for cf: Node3D in [turan, forner, emmet]:
			if not cf.has_meta("seated"):
				continue
			(cf.get_meta("body") as Node3D).scale.y = 1.0 + sin(_t * 1.3 + cf.position.x) * 0.006
			var look_at := cam_p
			if _duf_track and dufredy.visible:
				look_at = (dufredy.get_meta("head") as Node3D).global_position
			elif who.has(_talker) and who[_talker] != cf:
				look_at = ((who[_talker] as Node3D).get_meta("head") as Node3D).global_position
			Anim.look(cf, look_at, 0.9, 0.06)
		# the dispenser clicking to itself, until the room goes quiet
		_click_t -= delta
		if _click_t <= 0.0:
			_click_t = rng.randf_range(1.4, 2.4)
			if not _duf_track and dispenser_ap:
				dispenser_ap.pitch_scale = rng.randf_range(1.6, 1.9)
				dispenser_ap.play()
	# Carl cannot look away from him
	if _duf_track and dufredy.visible:
		var hd: Vector3 = (dufredy.get_meta("head") as Node3D).global_position
		var c: Vector3 = main.player.cam.global_position
		var d2 := hd - c
		var want_yaw := atan2(-d2.x, -d2.z)
		var want_pitch := atan2(d2.y, Vector2(d2.x, d2.z).length())
		main.player.yaw = lerp_angle(main.player.yaw, want_yaw, minf(1.0, delta * 2.5))
		main.player.pitch = lerpf(main.player.pitch, want_pitch, minf(1.0, delta * 2.5))
	if tyson and tyson.visible and zone == "train":
		Anim.look(tyson, main.player.cam.global_position, 0.7, 0.05)
	# the police drone round the pillar, slow
	if police:
		var a := _t * 0.11
		police.position = P + Vector3(cos(a) * 15.0, 10.0 + sin(_t * 0.8) * 0.3, sin(a) * 15.0)
		police.rotation.y = -a
	for o in _flick:
		var ol := o as OmniLight3D
		ol.light_energy = float(ol.get_meta("base")) * (0.15 if randf() < 0.05 else 1.0)
	# the tunnel going by
	if zone == "train" and train_speed > 0.01:
		for s in strips:
			var sm := s as MeshInstance3D
			sm.position.x -= train_speed * delta
			if sm.position.x < -34.0:
				sm.position.x += 63.0


# ------------------------------------------------------------------ the HUD and the phone

func objective() -> String:
	var f: Dictionary = main.flags
	var o: Dictionary = LINES["objective"]
	if f.has("tyson_subway"):
		return ""
	if f.has("rr_monolith"):
		return str(o["after"])
	if f.has("lushons_done"):
		return str(o["monolith"])
	if f.has("lu_in"):
		return str(o["inside"])
	return str(o["start"])


func phone() -> String:
	var t: String = "[b]PSYON[/b]\n\n" + L("phone", "t1")
	if main.flags.has("lushons_done"):
		t += "\n\n" + L("phone", "t2")
	return t


func scan_people() -> Array:
	return [[police, L("plaza", "drone_scan")]]


# ------------------------------------------------------------------ E

func interact(node: Object) -> bool:
	var f: Dictionary = main.flags
	var id := str(node.get_meta("id"))
	match id:
		# the casino
		"casino":
			await _think(L("casino", "sign"))
		"scripture":
			await _scripture()
		"slots":
			await _slots()
		"dark_slots":
			await _think(L("casino", "dark"))
			if not f.has("rr_dark_slots"):
				f["rr_dark_slots"] = true
				main.log_line("clue", L("casino", "log_dark"))
		"cage":
			await _think(L("casino", "cage"))
		"stool":
			await _think(L("casino", "stool"))
		# the alley
		"graffiti":
			await _graffiti()
		"alley":
			if f.has("rr_double_done"):
				await _think(L("double", "after"))
			elif f.has("rr_graffiti") and main.frames_on and main.connection >= 50.0:
				await _double()
			else:
				await _think(L("double", "empty"))
		"double":
			await _double()
		# the plaza
		"pillar":
			await _think(L("plaza", "pillar"))
			await _think(L("plaza", "pillar_hum"))
		"monolith":
			await _think(L("monolith", "screen_black") if f.has("rr_monolith") else L("monolith", "screen_look"))
		"kneelers":
			await _think(L("plaza", "kneel"))
			await _say("Kneeling woman", L("plaza", "kneel_say"))
		"painted":
			await _think(L("plaza", "painted"))
			await _say("The boy", L("plaza", "painted_say"))
			await _think(L("plaza", "painted_after"))
		"hummer":
			await _think(L("plaza", "hummer"))
		"drunk":
			await _think(L("plaza", "drunk"))
		"walkers":
			await _think(L("plaza", "walkers"))
		"smoothie":
			await _smoothie()
		"club":
			await _think(L("plaza", "club_quiet") if f.has("rr_club") else L("plaza", "club"))
			f["rr_club"] = true
		"eyeless":
			await _think(L("eyeless", "look") if main.frames_on else L("eyeless", "dark"))
		"outlet":
			await _think(L("plaza", "outlet"))
		"atm":
			await _think(L("plaza", "atm"))
		"camera":
			await _think(L("plaza", "camera"))
		"kiosk":
			await _think(L("plaza", "kiosk"))
		"bench":
			await _think(L("plaza", "bench"))
		"tree":
			await _think(L("plaza", "tree"))
		"subway_sign":
			await _think(L("plaza", "subway_sign"))
		"subway":
			if f.has("tyson_subway") or _ended:
				await _think(L("plaza", "subway_sign"))
			elif not f.has("lushons_done"):
				await _think(L("plaza", "subway_early"))
			elif not f.has("rr_monolith"):
				if not _walked_out:
					await _walk_out()
				await _think(L("plaza", "subway_screen"))
				await _monolith()
			else:
				await _train_beat()
		# Lushon's
		"lushons_door":
			await _think(L("lushons", "door"))
		"dispenser":
			await _dispenser()
		"lanterns":
			await _think(L("lushons", "lanterns"))
		"window":
			await _think(L("lushons", "window"))
		"bar":
			await _think(L("lushons", "bar"))
			await _think(L("lushons", "bar_empty"))
		"booth":
			await _think(L("lushons", "booth"))
		"photo":
			await _think(L("lushons", "photo"))
		"turan", "forner", "emmet":
			if f.has("lushons_done"):
				if id == "forner":
					await _think(L("cast", "forner_after"))
				else:
					await _say(id.capitalize(), L("cast", id + "_after"))
			elif not _in_meeting:
				await _meeting()
		"dufredy":
			await _think(L("dufredy", "left") if f.has("dufredy_lushons") else L("dufredy", "voids"))
		# the train
		"tyson":
			await _think(L("train", "eyes"))
		"window_t":
			await _think(L("train", "reflection"))
		"ad_t":
			await _think(L("train", "ad"))
		_:
			return false
	return true


# ------------------------------------------------------------------ dev shots

## --scene=lush|seat|duf|double|kid|forner|train|screen (with --at/--yaw).
func apply_args(a: Dictionary) -> void:
	var sc := str(a.get("scene", ""))
	var p = main.player
	match sc:
		"seat", "duf":
			p.position = CARL_SEAT
			p.seated = true
			p.crouch = 0.42
			if sc == "duf":
				dufredy.visible = true
				dufredy.position = CARL_SEAT + Vector3(-1.25, 0, 0.55)
				turn_to(dufredy, CARL_SEAT)
				water.visible = true
		"double":
			main.frames_on = true
			main.ui.set_frames(1.0, main.connection)
			double.visible = true
			double.position = DOUBLE_AT
			turn_to(double, p.position)
		"train":
			p.position = TRAIN + Vector3(0.4, 0.0, 1.05)
			p.seated = true
			p.crouch = 0.42
			train_speed = 16.0
		"screen":
			_scr(str(a.get("state", "kids")))
		"kid":
			_shot_picture("kid", int(a.get("k", "1")))
		"forner":
			_shot_picture("forner", 0)


func _shot_picture(which: String, k: int) -> void:
	await get_tree().process_frame
	if which == "kid":
		var tex := await _kid_frame(k)
		main.ui.show_picture(tex, str(LINES["meet"]["v%d_cap" % (k + 1)]))
	else:
		var room_l := [[FL + Vector3(0, 2.0, -2.0), Color(0.45, 0.6, 1.0), 1.6, 7.0], [FL + Vector3(-2.0, 2.2, 1.6), Color(1.0, 0.7, 0.45), 0.7, 6.0],
			[FL + Vector3(2.0, 1.2, 0.6), Color(0.6, 0.8, 1.0), 1.2, 3.0]]
		var p1 := await _picture(FL + Vector3(-1.9, 1.75, 1.7), FL + Vector3(0.3, 1.0, -2.2), 62.0, room_l)
		var p2 := await _picture(FL + Vector3(1.55, 1.2, 0.85), FL + Vector3(2.5, 1.1, 0.58), 40.0, room_l)
		var trs := panel_box.get_children()
		(trs[0] as TextureRect).texture = ImageTexture.create_from_image(p1)
		(trs[1] as TextureRect).texture = ImageTexture.create_from_image(p2)
		card_rect.visible = true
		panel_box.visible = true
		main.ui.caption(str(LINES["forner"]["cap"]), 6.0)


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


func selftest() -> void:
	var f: Dictionary = main.flags
	var p = main.player
	# the run checks the script, not the pixels: the main view stops drawing
	# (the picture cameras still render their own viewports)
	get_viewport().disable_3d = true
	await intro()
	print("ok intro entry=", _entry)
	if str(main._args.get("st_from", "")) == "lush":
		await _st_lush()
		get_viewport().disable_3d = false
		return
	# the other two ways in, for the script's sake
	for k: String in ["note", "lynx", "emmet"]:
		if k != _entry:
			await _entry_lines(k)
			main.ui.close()
	print("ok entries")
	# the casino and its wall
	for id in ["casino", "scripture", "scripture", "dark_slots", "cage", "stool"]:
		await _by_id(id)
	_force = [0]
	await _by_id("slots")
	# the frames on, past 50: the graffiti, and the double (the pump keeps
	# looking: closer, then touched)
	if not main.frames_on:
		main.toggle_frames()
	main.connection = 55.0
	await get_tree().process_frame
	_force = [0]
	await _by_id("slots")
	await _by_id("graffiti")
	print("ok double ", f.get("rr_double_touched", false), " conn=", main.connection)
	# the other ways out of it: tear the frames off, the word, run, bow
	main.learn("mimic")
	main.learn("bow")
	for pick: int in [0, 3, 2, 4]:
		f.erase("rr_double_done")
		if not main.frames_on:
			main.toggle_frames()
		_force = [pick]
		await _double()
		print("ok double pick ", pick, " frames=", main.frames_on)
	# the eyeless at the club stairs closes at walking speed and touches
	if not main.frames_on:
		main.toggle_frames()
	p.position = CLUB_TOP + Vector3(3.0, 0.1, 0.0)
	await _wait(func() -> bool: return f.has("rr_eyeless_touched") and not _busy, 20.0)
	print("ok eyeless ", f.has("rr_eyeless_touched"))
	if main.frames_on:
		main.toggle_frames()
	_force = [0]
	await _by_id("smoothie")
	_force = [0]
	await _by_id("smoothie")
	await _st_lush()


func _st_lush() -> void:
	var f: Dictionary = main.flags
	var p = main.player
	# Lushon's: in through the curtain
	p.position = Vector3(LU_DOOR, 0.1, -42.5)
	await _wait(func() -> bool: return f.has("lu_in") and not _busy, 20.0)
	print("ok lushons in=", f.has("lu_in"), " zone=", zone)
	_force = [0]
	await _by_id("dispenser")
	await _by_id("dispenser")
	await _by_id("turan")
	print("ok meeting done=", f.has("lushons_done"), " duf=", f.has("dufredy_lushons"), " cognizo=", f.has("cognizo_open"))
	# the other two answers at the table
	for pick: int in [0, 2]:
		_force = [pick]
		await _facility_choice()
		main.ui.close()
	print("ok facility trust=", main.trust)
	# out into the plaza at 23:30, and the screen
	p.position = Vector3(LU_DOOR, 0.1, -37.0)
	await _wait(func() -> bool: return _walked_out and not _busy, 20.0)
	p.position = Vector3(0.0, 0.1, 8.0)
	await _wait(func() -> bool: return f.has("rr_monolith") and not _busy, 30.0)
	print("ok monolith ", f.has("rr_monolith"))
	# the train, Tyson, and Forner alone
	await _by_id("subway")
	print("ok train tyson=", f.has("tyson_subway"), " forner_called=", f.has("forner_called"), " lushons_done=", f.has("lushons_done"))
	p.seated = false
	p.crouch = 0.0
	p.position = SPAWN
	await get_tree().process_frame
	await main.selftest_all_interactables()
	get_viewport().disable_3d = false
