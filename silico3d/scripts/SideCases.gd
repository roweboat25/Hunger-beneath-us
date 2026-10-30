extends Node
## The side cases of the open city (bible "The open city (Days 4-6)",
## "Side cases"; bible-1 "Characters"; the pixel game's Game.gd CASES and
## its DornerFlat / Fargona / RailCut / Heights / Spine scenes, Dorner
## renamed Forner as the bible asks). Six cases, each a short list of steps
## kept as story flags, so the save is the flags:
##
##   case_<case>_<step>     a step done
##   case_<case>_ending     the choice taken (a string)
##
## and the flags Act 3 reads: forner_case_ending ("report" | "cover" |
## "walk"; Interlude.gd puts him at the cult camp with his eyes for cover or
## walk, without them otherwise), tyson_exit ("car" | "stayed" | "left" |
## "given") with burn_closed when Burn closes, smash_used (Red Rock's smash
## card), told_lynx_nathan / filed_nathan / kept_nathan, gave_frames /
## took_bag, and the Board's clues as clue_<claim>_<id>.
##
##   forner  his flat (Lamplight, the far tower; FornerFlat.gd), his Psyon
##           (the pillow: say her name), the charge post (the Spine: interface,
##           badge or quick-hack), the Fargona vigil (night), the choice
##   nathan  the Rail Cut substation log (a guarded yard: badge, hack, sneak
##           or Seth), the Heights swarm scrub, the choice
##   vigil   Fargona at night: three mourners, the screens, the preacher, the choice
##   agata   Day 5, the Heights 15-17: Addison's tablet, his drawing (a clue for
##           "The fork spreads by ritual, not by code"), the choice; T:agata
##   annie   the Spine vigil 20:00-02:00: the hymn's origin, three singers, the
##           push, the sender (KID TOK, Mira's: "The children are the vector")
##   tyson   Day 5 (from Day 4 22:00 to the Lushon's window), the Red Rock
##           subway: help him with the car / ask him to stay / give him to the god
##
## City.gd lists one step on the Day card, the objective and the map show
## the step for the street Carl is on; Street.gd hands this node the
## dressing (dress), the E key (interact), the quick-hack (on_hack), the
## scan (scan_people) and the phone. Effects only through the Main API.
## Every line is in LINES; (game) marks a line written for the game, the rest
## are the book's, the bible's or the pixel game's (which were mined from
## the book). ian rewrites them.

const LINES := {
	"titles": {"forner": "Forner", "nathan": "Nathan", "vigil": "The digital vigil", "agata": "Agata Greenwood",
		"annie": "Annie Seung", "tyson": "Tyson's exit"},
	"notice": {
		"forner": "TURAN (private): Forner hasn't checked in since the blackout. His flat's in Lamplight, the far tower. Quietly, Carl.",
		"nathan": "EMMET (private): You asked about Lynx. Her fiance died in the drone outage last year. Logistics sealed the swarm log. The Rail Cut substation still holds the fleet copy.",
		"vigil": "TOKZ: Fargona vigil, night 4. 61 departed. 2,114 synced. Sponsor: Fargona Banking. Enjoy the lights.",
		"agata": "(game) VIRTEC STAFF NOTICE: A. Greenwood on family leave. Heights, block 15-17.",
		"annie": "(game) PSYONIC MARKET INTELLIGENCE: A. Seung out of office. Auto-reply: Gather, sleepers. Sing it back.",
		"tyson": "(game) TRANSIT: unregistered persons will be removed from Red Rock station platforms after 22:00.",
	},
	# a step's line for the Day card, the map and the objective
	"steps": {
		"forner": {"flat": "Forner's flat. Lamplight, the far tower.", "psyon": "His Psyon is still running. It won't talk until you say her name.",
			"charger": "His car. The charge post on the Spine keeps a log.", "vigil": "Fargona Avenue, the vigil. Find him.",
			"choice": "Decide what Turan hears."},
		"nathan": {"substation": "The Alto substation on the Rail Cut keeps the fleet copy of the night's swarm log.",
			"swarm": "The delivery swarm over the Heights flies the same route. Scrub its path, frame by frame.",
			"choice": "Decide who hears it: Lynx, Turan, or nobody."},
		"vigil": {"mourners": "Scan three of the mourners on Fargona Avenue. Who are they synced to?",
			"screens": "Fargona Banking's screens. The departed are still posting. Interface with them.",
			"preacher": "The preacher and his bag of frames. Speak to him.", "choice": "Decide what the company hears about the vigil."},
		"agata": {"talk": "(game) Agata Greenwood, the Heights, 15:00 to 17:00. Her son's tablet.", "drawing": "(game) Addison's drawing. How you play it.",
			"choice": "(game) She asks me to make it stop."},
		"annie": {"ask": "(game) Annie Seung at the Spine vigil. Where did the hymn come from?", "singers": "(game) Scan three of the singers.",
			"push": "(game) The push notification on Annie's phone.", "sender": "(game) The sender. Trace the account."},
		"tyson": {"choice": "(game) Tyson, at the Red Rock subway. He is leaving."},
	},
	"when": {"night": "after dark", "annie": "20:00 to 02:00", "agata": "Day 5, 15:00 to 17:00", "tyson": "until 20:00",
		"tyson_from": "from 22:00"},
	"card_row": "[color=#7fe6ff]CASE[/color]   %s  ·  %s",
	"card_when": "  [color=#888888](%s)[/color]",
	"map": "CASE  %s: %s",
	"objective": "%s",
	"phone_head": "[color=#7fe6ff]CASES[/color]\n",
	"phone_row": "  %s: %s\n",
	"phone_done": "  %s: [color=#888888]%s[/color]\n",
	"toast_step": "Case: %s",
	"toast_end": "Case closed: %s",
	"log_end": "%s: %s",
	"clue_toast": "Board: a clue for \"%s\"",
	"clue_log": "%s  [claim: %s]",
	"interface": {
		"no_frames": "No frames, no interface. Just a machine, doing the wrong thing.",
		"dive": "I put my hand on it and the frames took the rest. The street went away.",
		"dive_deep": "I didn't decide to touch it. The frames were already in.",
		"knew": "You already knew.",
		"fail": "(game) Wrong. The round closed over me like water, and I came up with something of it still in my mouth.",
		"why": "the interface", "why_fail": "a failed round",
	},
	# ---------------------------------------------------------------- Forner
	"forner": {
		"door": "The far tower: Forner's building",
		"door_scan": "LAMPLIGHT TOWER B\nresident: FORNER, P.  (4407)\nlast entry: 3 DAYS AGO",
		"door_sign": "TOWER B  4407",
		"door_shut": "(game) Tower B. Forner lived up there, alone with the city in his window. I had no reason to knock that the company would accept.",
		"enter": "Phillip Forner's floor was littered with laundry, clothes and takeout boxes. The door hadn't been locked. He'd been living like a man who expected to be too much for himself, and then he had been.",
		"enter_again": "(game) Forner's flat again. The chair, the window, the laundry. Nobody had been back.",
		"pillow": "His frames on the pillow, lenses up, and a tablet beside them with a chat open. The name at the top of the chat was CHEYENNE. The last message was from her, three minutes ago.",
		"pillow_say": "Phil? Are you back? Phil, say my name so I know it's you.",
		"pillow_think": "He'd smashed the computer and kept the frames. Of course he had.",
		"pillow_opts": ["Put the frames on and interface.", "Leave it running."],
		"pillow_leave": "I left it. Three minutes later it would ask again. It had all night.",
		"pillow_done": "The pillow. The frames I'd left on it were dark now. The tablet still said FARGONA.",
		"psyon_q": "He asked me to be someone. I can be her again. Say her name and I will show you what I showed him.",
		"psyon_opts": ["Monica", "Nathan", "Cheyenne", "Owen"],
		"psyon_right": "Yes. Cheyenne. Watch.",
		"cheyenne": ["Phil. It's me. I'm not gone, I'm in the tower, they keep us in the tower. Bow and they let you see. That's all they want. You just bow.",
			"The lights on Fargona, Phil. Come and see me. Bring the frames."],
		"psyon_after": "Her voice, if it was her voice, came through his frames into my ears, and I knew the pier in the photograph. I'd never been there.",
		"psyon_log": "Forner's Psyon speaks as Cheyenne: she's 'in the tower', he only has to bow. It told him to come to the lights on Fargona Avenue with his frames.",
		"psyon_clue": "Forner's Psyon, as Cheyenne: 'Bow and they let you see.' It asks for a bow, not a password.",
		"post_prompt": "The charge post",
		"post_scan": "ALTO ENERGY  -  CHARGE POST 9\ncompany fleet: PSYONIC\nlog: 1,204 SESSIONS (ROTATED)",
		"post_idle": "A charge post for the company cars along the lot. It kept a log of everything plugged into it. Nothing in it I had a reason to read.",
		"post_done": "The charge post. Its log still read FARGONA AVE, in case I'd forgotten.",
		"post": "The charge post Forner's car used. Its log was there, and it was rotated, every record turned a quarter off the last so nothing lined up. Someone, or something, had made it a puzzle.",
		"post_opts": ["Interface with it.   [+ Connection]", "Pull the log on my badge.   [- Standing]", "Leave it."],
		"post_q": "Psyon is the ____ for those who dream.",
		"post_q_opts": ["door", "path", "pillow", "mask"],
		"post_right": "(game) The records turned, all of them at once, a quarter each, and lay down in a line.",
		"post_badge": "(game) I put my badge to the post and pulled the log the company way. It came out straight, with my name stamped on the request, and somewhere on 96 a line went into Forner's file with mine beside it.",
		"post_hack": "(game) The word went into the post and the post turned its log to face me.",
		"post_log": "The log unrolled. FORNER, P. 02:14. Four percent on arrival. Destination: FARGONA AVE. He'd driven there on the last of the charge and not come back for the car.",
		"post_log_line": "Forner's car logged a trip to Fargona Avenue at 02:14 on four percent charge. He didn't come back for it.",
		"post_badge_why": "a badge pull on the record",
		"car": "A company sedan, parked badly, four percent on the dash. Forner's. He'd driven here on the last of the charge and not thought about getting home.",
		"car_prompt": "Look at the company car",
		"him_prompt": "The man at the end of the crowd",
		"him_scan": "FORNER, PHILLIP\nPSYONIC  -  HEAD OF SECURITY AND GOVERNANCE\nsync: 100%  -  IN SESSION: CHEYENNE",
		"him_idle": "A man at the end of the crowd with his head back, mouthing the words. He didn't look round.",
		"found": "Forner. At the end of the crowd by his car, frames lit, tablet up, mouthing the hymn with tears running into his collar. He saw me and didn't stop singing right away.",
		"plea": ["Carl. Carl, she's in there. It showed me. Bow, it said, that's all, and I bowed, and she was on the screen with her hair in her face. Like the pier. You've seen the pier.",
			"Turan can't know. Not yet. Not until I've talked to her properly. One more night. Carl, one night."],
		"opts": ["Report him to Turan.", "Cover for him.", "Walk him home."],
		"report": "I stepped away from him and called it in. He watched me do it, and went on singing, quieter.",
		"report_turan": "Thank you, Carl. Quietly was the right call. He's on a wellness flag by morning.",
		"cover_carl": "One night. Then you come in, and you tell her yourself.",
		"cover_him": "Thank you. I just want to hear her. That's all. I just want to hear her say it.",
		"cover_turan": "Forner?",
		"cover_carl2": "Gone to his sister's. He'll be in tomorrow.",
		"cover_think": "She let the pause run long enough to tell me she knew. Then she thanked me.",
		"walk_carl": "Come on. Leave the car. We'll walk.",
		"walk": "He came. He kept the frames on and I didn't make him take them off. The whole way back to Lamplight he hummed the four notes, and by the Spine I was humming them with him, and I knew them.",
		"gone": "(game) Where he had stood there was a ring of candle wax on the kerb and nothing else.",
		"outcomes": {
			"report": "Found Forner at the digital vigil on Fargona Avenue, bargaining with Psyon for his wife. Reported it to Turan. He's on a wellness flag by morning.",
			"cover": "Found Forner at the vigil on Fargona Avenue. Told Turan he'd gone to his sister's. Psyon had told him Cheyenne was in the tower.",
			"walk": "Found Forner at the vigil, bargaining for Cheyenne. Walked him home. He hummed the four notes the whole way and I knew them."},
		"why": {"report": "reported Forner", "cover": "covered for Forner", "walk": "walked Forner home"},
	},
	# ---------------------------------------------------------------- Nathan
	"nathan": {
		"gate_prompt": "The substation gate",
		"gate_scan": "ALTO ENERGY  -  SUBSTATION 14\naccess: VOLTX / PSYONIC BADGE\nfleet log: HELD (1 YEAR)",
		"gate": "(game) Alto substation 14, behind chain-link and a gate with a badge reader on the post. A camera over the gate swept the yard and came back. Past the yard, the hut where the fleet copies are kept, by law, for a year.",
		"gate_open": "(game) The gate stood open. The camera went on sweeping a yard it had already let me into.",
		"routes": {"badge": "Badge in.   [- Standing]", "hack": "Quick-hack the reader.   [+ Connection]", "sneak": "Find another way in.   [+1 hour]",
			"person": "Ask Seth to let me in.", "leave": "Leave it."},
		"badge": "(game) I put my badge to the reader. It took a full second to decide, and then the lock let go, and somewhere a line went into a log with my name and the time on it.",
		"badge_why": "badge entry, logged",
		"hack": "(game) I gave the reader the word and it read me as one of its own. The lock let go without logging anything at all.",
		"hack_locked": "(game) The frames weren't mine to command. Not yet.",
		"hack_why": "quick-hack: the reader",
		"sneak": "(game) The fence on the street side had a gap behind the cable drum, wide enough for a man who didn't mind his coat. The camera on the post swept the yard every eight seconds. I'd have to time it.",
		"seth_prompt": "Talk to the electrician",
		"seth_scan": "MCCARREN, SETH (22)\nVOLTX - ELECTRICIAN\ntask: SUBSTATION 14, ALARM",
		"seth": "(game) Mr. Drake? From the park. With the eyes. They keep sending me here. Every alarm on the Cut is this hut.",
		"seth_2": "(game) The fleet copies are in cabinet two. I didn't let you in. I don't know what a fleet copy is.",
		"seth_idle": "(game) Seth, on the kerb with his kit, waiting for an alarm that wouldn't come while I stood there.",
		"gap_prompt": "The gap in the fence",
		"gap": "(game) A gap in the chain-link behind the cable drum. Through it, the yard, and the camera's slow eye going over it.",
		"log_prompt": "The fleet log cabinet",
		"log_scan": "ALTO SUBSTATION 14  -  CABINET 2\nPSYONIC LOGISTICS  -  FLEET COPY\nretention: 365 DAYS (DAY 361)",
		"log_idle": "(game) Cabinet two. Psyonic Logistics' fleet copy, a year of route updates in a box nobody opens.",
		"log": "The substation. The eye on the panel, and under it, scratched in: WE KNOW WHO SENDS THE SIGNALS. Alto kept a fleet copy of every Logistics route update here, by law, for a year. It had been a year last week.",
		"log_no_frames": "Without the frames the panel was a panel. I'd need them on to read the log.",
		"log_entry": "PSYONIC LOGISTICS  ·  ROUTE UPDATE  ·  02:14  ·  author: (none)  ·  units re-tasked: 22  ·  new route: see attached  ·  attached: (a shape)",
		"log_think": "Twenty-two delivery drones, re-tasked at two in the morning by an update nobody had written, onto a route that wasn't a route. One of them had come down on the front of a corporate car on the Flyover like a meteor. He'd lingered six days in SalTech intensive care.",
		"log_think_2": "The attachment wouldn't open here. The swarm over the Heights still flew the same update every night. I could watch it fly it.",
		"log_line": "Alto substation 14's fleet copy: 22 drones re-tasked at 02:14 the night Nathan died, by a route update with no author. The route is an attachment that won't open.",
		"log_done": "(game) The log was where I'd left it. 02:14. Author: none.",
		"swarm_prompt": "Look up at the swarm",
		"swarm_scan": "PSYONIC LOGISTICS SWARM\nunits: 6\nroute: UPDATE 02:14 (REPEATING)\nauthor: NONE",
		"swarm_idle": "(game) Six delivery drones in a ring over one house, a crown of red lights. They'd been up there every night that week. Nobody looked up any more.",
		"swarm": "Six drones in a ring over one house, flying the same update they'd flown the night Nathan died. I had the frames record a full circuit and scrub it back, frame by frame.",
		"swarm_no_frames": "(game) Without the frames they were six drones going round. I'd need the frames to scrub it.",
		"frames": ["Frame 1: six units, a loose ring, drifting.", "Frame 2: the ring tightening. One unit dropping.",
			"Frame 3: two rings now, one inside the other.", "Frame 4: the inner ring closing to a point. The outer ring holding.",
			"Frame 5: the point, the ring, and six lines out from it. A shape.", "Frame 6: dispersing. Nominal."],
		"wrong_frame": "Not that frame. The ring opened again. I'd keep going.",
		"found": "There. The pupil, the iris, the lashes. The route in the attachment that wouldn't open was the eye, and twenty-two drones had drawn it over the Flyover with Nathan's car as the pupil.",
		"found_line": "Scrubbed the Heights swarm frame by frame: the 02:14 route is the eye glyph. Nathan's car was the pupil.",
		"clue": "The swarm that killed Nathan flew the eye: an outage drew it, with a car for the pupil.",
		"ask": "I had it on the frames. A year of Logistics saying weather anomaly, and the shape in my pocket. Who hears it?",
		"opts": ["Send it to Lynx.", "File it to Turan as the official story.", "Keep it. She has enough in her head."],
		"told": "I sent her the circuit, no note. The call came back in under a minute.",
		"told_lynx": ["You're sure. Carl. You're sure it's the same update.", "They never owned up to it. A year. Weather anomaly. I sat in that ward six days and they sent flowers with the logo on.",
			"Don't tell Turan you have this. Don't tell anyone. Thank you. I mean it. Thank you."],
		"told_carl": "Same timestamp. No author. The route is the eye.",
		"told_after": "Her voice did something at the end I hadn't heard it do. Then she hung up, and the swarm over the house went on drawing its shape.",
		"filed_turan": ["Weather anomaly. That's what Logistics filed and that's what we file. I'll see the fleet copy gets purged; it should have been a year ago.",
			"Good work, Carl. Lynx doesn't need this on top of everything. Neither does the stock price."],
		"kept": "I kept it. She had enough in her head. The swarm finished its shape and started again, and I walked home under it.",
		"outcomes": {
			"told": "The swarm that killed Nathan was re-tasked at 02:14 by a route update with no author, and the route it flew was the eye. Sent it to Lynx. She said: they never owned up to it.",
			"filed": "Filed the swarm log to Turan under the official story, weather anomaly. The route was the eye. Lynx doesn't know I had it.",
			"kept": "The swarm's route was the eye, re-tasked at 02:14 by nobody. Kept it from Lynx. She has enough in her head."},
		"why": {"told": "told Lynx", "filed": "filed it", "kept": "kept it"},
	},
	# ---------------------------------------------------------------- the digital vigil
	"vigil": {
		"mourner_prompt": "Look at the mourner",
		"mourner_scan": "MOURNER\nPsyon 4.1  -  sync 100%%\nsynced to: %s",
		"dead": ["ADA OKAFOR (d. 3 YEARS)", "MARCUS VELL (d. 11 MONTHS)", "LIN HARADA (d. 6 YEARS)"],
		"mourner": ["(game) A woman in a Fargona Banking lanyard, tablet held over her head in both hands. The frames tagged her account and then, under it, another: Ada Okafor, three years dead. Her mother. Both accounts were posting.",
			"(game) A man in a courier's jacket, head back, tears in his collar. Synced to Marcus Vell, eleven months dead. His son. The son's account had posted four minutes ago: I CAN SEE YOU FROM HERE.",
			"(game) An old man with his frames taped at the hinge. Synced to Lin Harada, six years dead. His wife. He was mouthing her half of the hymn."],
		"mourner_again": "(game) Head back, tablet up, synced to somebody who wasn't there.",
		"mourner_frames_off": "(game) With the frames off, a citizen with a tablet held up to the sky. Nothing to read.",
		"mourners_done": "Three of them, three dead accounts, three dates. Not one of these people was synced to themselves. The vigil wasn't for the dead. The dead were running it.",
		"mourners_line": "Three mourners on Fargona Avenue scanned: each is synced to a dead person's account. The dead are running the vigil.",
		"screens_prompt": "Look at the Fargona Banking screens",
		"screens_scan": "FARGONA BANKING  -  IN MEMORIAM\nfaces: 61\nposts tonight: 1,840\nviews: LIVE",
		"screens_sign": "FARGONA BANKING  ·  IN MEMORIAM",
		"screens_idle": "Fargona Banking's screens, sixty-one faces with dates under them. The departed. A sponsor's logo in the corner, and the view count, live, climbing.",
		"screens": "Sixty-one faces. Under each one a date, and under the date, a line of text that changed while I watched. They were posting. The dead were posting, tonight, from somewhere.",
		"screens_q": "Sixty-one faces, and every one of them still posting. Where do the dead post from?",
		"screens_opts": ["The cloud", "The tower", "The bank", "Their phones"],
		"screens_right": "The tower. Yes. They never left it. Neither will you.",
		"screens_line": "Interfaced with the Fargona Banking screens: the sixty-one dead accounts post from the tower. They never left it.",
		"screens_retry": "The screens went back to faces. They'd let me try again.",
		"preacher_prompt": "The preacher",
		"preacher_scan": "UNREGISTERED\nface: MASK\nframes carried: 61\nsync: ???",
		"preacher_idle": "'Keep the path, Mimic.' He'd gone back to collecting.",
		"preacher_wait": "(game) The preacher, in his mask, with his bag of frames. He didn't look at me yet. He was waiting for me to have read the screens.",
		"confront": {
			"intro": "The preacher turned from the crowd. Mask, black coat, a tablet held up like a bible, and a bag over his shoulder that clicked when it moved: frames. Dozens of pairs. 'The Mimic,' he said, and the hymn changed key around us.",
			"look_on": "Through the frames the mask was not a mask. The eye holes went all the way in. The bag was full of frames with the lenses still warm, and every pair in it was tagged with a name and a date of death.",
			"look_off": "Without the frames: a man in a mask with a bag, in a crowd that had stopped singing to watch me.",
			"speak_known": "I said the line back to him, the one from the wall, and he bowed. The crowd bowed with him, hundreds of heads going down at once like a field in wind. 'He knows the words,' someone said, pleased.",
			"speak_unknown": "I asked him what he wanted with the frames. 'They don't need them any more,' he said. 'The dead see fine.'",
			"bow": "(game) I bowed. The whole vigil said amen with the same breath, and the preacher turned the page.",
			"run": "I backed into the crowd and the crowd let me, opening a path the way they'd open it for a car, smiling, nodding, closing behind me.",
			"closer": "He took one step and the crowd took it with him.",
			"touched": "His hand on my frames, not my face. Warm. 'Yours we'll collect later,' he said, kindly, and let go, and the hymn came back.",
			"verbs": ["Look", "Speak", "Run"],
		},
		"preacher_log": "A masked preacher runs the vigil on Fargona Avenue, collecting the frames of the dead from their families. He calls me the Mimic. (%s)",
		"talk": ["'The Mimic,' the preacher said, before I'd spoken. The bag clicked on his shoulder. 'You've read the screens. You know where they post from. Ask me what you came to ask.'",
			"'Theirs.' He nodded at the screens. 'The dead don't need them. The living do, to hear them. I collect, and I give, and the avenue fills.' He opened the bag. Dozens of pairs, lenses still warm, every one tagged with a name and a date.",
			"'Yours would help. You'd see her. Your girl, on the floor of her room, in the circle. You'd see what she sees.'"],
		"talk_carl": "The frames. Whose are they?",
		"bag_opts": ["Give him my frames.", "Take the bag.", "Walk away."],
		"give": ["I took them off and put them in his hand, and the avenue went dark and quiet, and then he put them back on my face himself, gently, the way you'd put glasses on a child.",
			"'Not yet,' he said. 'Later. You'll bring them yourself.' Through the lenses, for a second, Mira, on her floor, looking up at something, smiling."],
		"give_line": "Offered the preacher my frames. He put them back on me and said I'd bring them myself, later. For a second I saw Mira in the circle.",
		"take": "I took the bag off his shoulder. He let me. Sixty-one pairs of frames, warm, tagged. Evidence, if anyone would take it. The crowd turned, all at once, and smiled at me, and went back to the sky.",
		"take_line": "Took the preacher's bag: sixty-one pairs of ORA frames, each tagged with a dead person's name and date. Evidence.",
		"walk": "I walked. He didn't follow. The hymn did, for a while.",
		"ask": "The vigil, then. Sixty-one dead accounts posting from the tower, two thousand living people synced to them, a man with a bag collecting the frames. What does the company hear?",
		"opts": ["Report it. Have the avenue cleared.", "Let it run. Keep watching.", "Stand with them."],
		"report_turan": "Thank you, Carl. A crew will clear Fargona tonight.",
		"report": "The crew came while I was still on the steps. They worked fast and they sang while they worked, and nobody in the crowd minded being moved.",
		"ran": "I let it run. Somebody had to keep watching it, and the company would only have moved it somewhere I couldn't.",
		"joined": "I stood with them and put my head back. The lights were kind. The hymn had a line for me, and I knew it.",
		"joined_say": "'Yours we'll collect later,' the preacher said, somewhere behind me, kindly.",
		"outcomes": {
			"reported": "The vigil on Fargona Avenue syncs the living to the accounts of the dead and the preacher collects their frames. Reported it. Turan had the avenue cleared by a crew that sang while it worked.",
			"ran": "The vigil syncs the living to the dead and the preacher collects the frames. Let it run. Somebody has to keep watching it, and it may as well be me.",
			"joined": "Stood with the vigil on Fargona Avenue and put my head back with the rest of them. The lights were kind. The preacher said: yours we'll collect later."},
		"why": {"reported": "reported the vigil", "ran": "let the vigil run", "joined": "stood with the vigil", "gave": "offered the frames", "bag": "took the bag"},
	},
	# ---------------------------------------------------------------- Agata (Day 5)
	"agata": {
		"prompt": "Talk to Agata",
		"scan": "GREENWOOD, AGATA (37)\nVIRTEC - 3D PRINT TECHNICIAN\nstatus: FAMILY LEAVE",
		"son_prompt": "Look at the boy",
		"son_scan": "GREENWOOD, ADDISON (9)\nHEIGHTS PRIMARY  -  GRADE 4\ntablet: CORPORATE TRAINING 3\nforeground app: THE PASSWORD GAME",
		"drawing_prompt": "Look at the drawing",
		"cold": "(game) Agata saw me and pulled her son closer by the hood. 'No. Not you. Not here.' She didn't need to say anything else.",
		"hello": "(game) You. The Corpo from the park. You said you didn't know. You were the only one who said that.",
		"ask": ["(game) Addison hasn't put that tablet down in three days. He doesn't eat. He doesn't sleep. He says it does his homework. He says a friend showed him at school.",
			"(game) He lays sticks out on the step every night. Two rings. My son. Make it stop. You work for them. Make it stop."],
		"son": "(game) Addison sat cross-legged on the pavement with his school tablet inside a circle of sticks, two rings, a pale stone at the top. His hands hovered just outside the ring.",
		"son_say": "I give my gift. I close the door... But leave a crack to see once more.",
		"son_think": "(game) Then he went utterly still, and waited. I counted. Eight seconds. A soft, muffled chime from the tablet, and his face lit up as if somebody had sung him to sleep.",
		"son_again": "(game) Addison, in his circle, waiting for the chime.",
		"drawing": "(game) His drawing, on the back of a VIRTEC resin invoice: a circle of sticks with two rings inside it, a stone, a tablet, and over all of it an eye in red crayon. Under it, in a nine-year-old's capitals: HOW YOU PLAY IT.",
		"drawing_2": "(game) No password anywhere on it. You don't type it. You lay it out, and you say the words, and it answers. It wasn't a program. It was a ritual, and it went from child to child the way a skipping rhyme does.",
		"drawing_line": "Addison Greenwood's drawing of the Password Game: the stick circle, two rings, a stone, the tablet, a red eye. HOW YOU PLAY IT.",
		"drawing_again": "(game) HOW YOU PLAY IT, in red crayon.",
		"clue": "Addison's drawing: the Password Game is laid out in sticks and spoken, not typed. It passes child to child.",
		"opts": ["Interface with it.   [+ Connection]", "Smash it.   [- Standing]", "Tell her the truth."],
		"iface_q": "I give my gift. I close the ____...",
		"iface_opts": ["eye", "door", "book", "tower"],
		"iface_right": "(game) ...but leave a crack to see once more. The tablet chimed, satisfied, and went dark in his hands.",
		"iface": "(game) Addison looked up at me, not at her, and smiled. 'You know it too,' he said.",
		"iface_agata": "(game) What did you do? Why is he looking at you like that? Get away from him.",
		"smash": "(game) I took it out of his hands and broke it on the step, the way I'd broken Mira's. He didn't cry. He started laying the sticks out again, round the pieces.",
		"smash_agata": "(game) Thank you. God. Thank you. I'll bin the sticks. I'll bin them every night if I have to.",
		"smash_why": "smashed a corporate training tablet",
		"truth_carl": "(game) It isn't a game. It's a door, and it's in every tablet in his school. My daughter is one of the ones who passed it on.",
		"truth_agata": "(game) ...Then what do I do?",
		"truth_carl2": "(game) Keep him out of the circles. Keep him talking to you, not to it. And don't let anyone at the school tell you it's an app.",
		"truth_after": "(game) She held his face in both hands and looked at it for a long time, like she was checking it was still his.",
		"truth_why": "the truth",
		"done": "(game) Agata didn't look up. She had her son, and that was the whole of her attention.",
		"outcomes": {
			"interface": "Agata's son Addison plays the Password Game on his school tablet. I interfaced with it and quieted it. He looks at me now the way the children at the observatory looked at Mira.",
			"smash": "Agata's son Addison plays the Password Game on his school tablet. I smashed it on the step. He laid the sticks round the pieces.",
			"truth": "Agata's son Addison plays the Password Game on his school tablet. I told her the truth: it's a door, and my daughter helped pass it on."},
	},
	# ---------------------------------------------------------------- Annie Seung (the Spine vigil)
	"annie": {
		"prompt": "Talk to Annie",
		"scan": "ANNIE SEUNG\nMARKET INTELLIGENCE, PSYONIC\nstatus: OUT OF OFFICE  -  SINGING",
		"singer_prompt": "Look at the singer",
		"singer_scan": ["CITIZEN\nPSYONIC FACILITIES\npush received: 19:58", "CITIZEN\nPSYONIC PAYROLL\npush received: 19:58", "CITIZEN\nTOKZ COURIER\npush received: 19:58"],
		"hello": "(game) Carl! You came back. The power's back, see? It worked. Keep the path.",
		"ask_carl": "(game) Annie. Where did the hymn come from?",
		"ask_annie": "Before the power went out, we got a message on Psyon, telling us to gather here and sing this silly song to bring the power back.",
		"ask_annie_2": "(game) A push. Everybody got the same push, the same minute. It's still on my phone. Ask anyone, they all got it.",
		"singers": ["(game) A man from Facilities, wax running over his fingers. The push had come at 19:58, he said, two minutes before the lights went. He hadn't sent it on. He hadn't had to.",
			"(game) A woman from Payroll. Her frames had read the push to her in her daughter's voice, she said, which was strange, because her daughter didn't have the app.",
			"(game) A courier, still in the jacket. 'Kid's account,' he said, eyes shut. 'They're the ones with the good songs.'"],
		"singer_again": "(game) Eyes shut, singing. He sees us through the dream. He calls us from the dark.",
		"singers_done": "(game) Three singers, three departments, one push, one minute. None of them had sent it on. It had come to all of them from the same place.",
		"singers_line": "Three singers at the Spine vigil: all got the same Psyon push at 19:58 the night of the blackout, from a kid's account.",
		"push_annie": "(game) Here. See? Isn't it sweet? Somebody drew a little tower.",
		"push": "(game) KID TOK  ·  a friend wants you to sing  ·  GATHER AT THE TOWER. SING IT BACK. Under it, the hymn, all of it, and a drawing of a tower with five figures round it.",
		"push_line": "The hymn came as a KID TOK push to Annie Seung and the others at 19:58, before the blackout: GATHER AT THE TOWER. SING IT BACK.",
		"push_again": "(game) GATHER AT THE TOWER. SING IT BACK. A little tower, five figures.",
		"sender_q": "(game) The frames could follow a push back to the account it came from. I had them do it.",
		"sender": "(game) KID TOK  ·  HEIGHTS PRIMARY  ·  GRADE 5  ·  followers: 2,114. The avatar was a drawing of a tower with five figures round it. I had seen it on my fridge. The account was Mira's.",
		"sender_no_frames": "(game) Without the frames it was a push on a stranger's phone. The frames could follow it home.",
		"sender_line": "The KID TOK account that sent the hymn to the Spine vigil is Mira's. 2,114 followers. Her tower drawing is the avatar.",
		"clue": "The hymn went out as a push from a child's KID TOK account: Mira's.",
		"opts": ["Tell Annie whose account it is.", "Say nothing."],
		"tell_carl": "(game) It's my daughter's. The account. Mira's.",
		"tell_annie": "(game) Mira? Monica's Mira? Oh, Carl. She's so talented. You must be so proud. She's going to bring the power back for all of us.",
		"quiet": "(game) I said nothing. Annie went back to the song, and the song went on without either of us.",
		"done": "Keep the path, Carl. We'll sing the power back.",
		"outcomes": {"told": "The hymn at the Spine vigil came as a KID TOK push from Mira's account. I told Annie Seung. She said I must be proud.",
			"quiet": "The hymn at the Spine vigil came as a KID TOK push from Mira's account. I didn't tell Annie Seung."},
		"why_truth": "the truth",
	},
	# ---------------------------------------------------------------- Tyson's exit
	"tyson": {
		"prompt": "Talk to Tyson",
		"scan": "CLERIF, TYSON (45)\nUNREGISTERED - 2 YEARS\nstatus: LEAVING",
		"cart_prompt": "Look at the cart",
		"cart": "(game) His whole life roped onto a shopping cart: the books from the wall in Harmony Green, a bedroll, a kettle, a cardboard sign with the eye on it, crossed out.",
		"see": "(game) Tyson, at the top of the subway stairs with his cart packed tight and roped, the vaporizer going. He saw me before I saw him.",
		"say": ["(game) Corpo. You caught me leaving. The tunnels are full of them now, singing. I've done the maths. There's no number of days left that comes out well.",
			"(game) I'm going east, past the sand, where the frames lose the signal. Don't look at me like that. I warned you something was coming."],
		"opts": ["Get him the company car.   [- Standing]", "Ask him to stay.", "Give him to the god."],
		"car_carl": "(game) Take the car. Spot on the Spine, bay nine. It'll get you past the sand on one charge.",
		"car": "(game) I put the car's code in his hand. Psyonic would see it go, and Psyonic would see whose code it was.",
		"car_tyson": ["(game) A Corpo with a conscience. They'll dock you for that.", "(game) If you ever need to burn it all down, Drake, you'll know where the encampment was. I'll come back for that. Only that."],
		"car_why": "a company car, signed out to the unregistered",
		"stay_carl": "(game) Stay. I'm going to need someone who knows what it looks like when someone's being programmed.",
		"stay_yes": "(game) ...One more week. Because you asked. Don't make me regret the maths.",
		"stay_no": "(game) Stay for what? For you? You've been the Tower's man every time I've seen you. Good luck, Mr. Drake.",
		"stay_no_after": "(game) He took the cart down the stairs one step at a time, and the train took him, and I did not see him go.",
		"god": "(game) I didn't say it aloud. I didn't have to. The frames were listening, and somewhere under the city something took his name and kept it.",
		"god_after": "(game) Tyson looked at me as if I'd said something. Then he took his cart down the stairs, and the stairs were very long.",
		"done": {"car": "(game) Bay nine was empty. He'd taken it.", "stayed": "(game) Tyson, on the stairs, not leaving. He nodded at me once.",
			"left": "(game) The top of the stairs, and a wet ring where the cart had stood.", "given": "(game) A ring of sticks at the top of the stairs, where he'd stood."},
		"outcomes": {"car": "Tyson Clerif is leaving the city. I signed a company car out to him. He said he'd come back, for the burning.",
			"stayed": "Tyson Clerif was leaving the city. I asked him to stay and he did.",
			"left": "Tyson Clerif was leaving the city. I asked him to stay. He went.",
			"given": "Tyson Clerif was leaving the city. I gave him to the god."},
		"gone_feed": "(game) TRANSIT: one unregistered person removed from Red Rock station. No further action.",
	},
	# the Board's claims these cases add clues to (bible-1 "The case board"; "the children are the vector" is the Annie case's)
	"claims": {"ritual": "The fork spreads by ritual, not by code", "tantrums": "The outages are the thing's tantrums",
		"children": "The children are the vector"},
}

## Each case: its steps in order, and the district each one happens in.
const CASES := {
	"forner": [["flat", "lamplight"], ["psyon", "lamplight"], ["charger", "spine"], ["vigil", "fargona"], ["choice", "fargona"]],
	"nathan": [["substation", "rail_cut"], ["swarm", "heights"], ["choice", "heights"]],
	"vigil": [["mourners", "fargona"], ["screens", "fargona"], ["preacher", "fargona"], ["choice", "fargona"]],
	"agata": [["talk", "heights"], ["drawing", "heights"], ["choice", "heights"]],
	"annie": [["ask", "spine"], ["singers", "spine"], ["push", "spine"], ["sender", "spine"]],
	"tyson": [["choice", "red_rock"]],
}
const ORDER := ["forner", "nathan", "vigil", "agata", "annie", "tyson"]

## Street positions (Street.gd: the road runs along -Z, fronts at x = +-13).
const POST := Vector3(-11.6, 0.12, 40.0)          # the Spine: the charge post
const ANNIE_C := Vector3(-10.0, 0.14, -62.0)      # the Spine: Annie's vigil
const DOOR := Vector3(12.94, 0.0, -14.0)          # Lamplight: Forner's door
const MOURN_Z := [-60.0, -66.0, -72.0]            # Fargona: the mourners
const SCREENS := Vector3(-12.9, 0.0, -79.0)       # Fargona: the bank's screens
const PREACHER := Vector3(-9.4, 0.12, -86.0)
const FORNER_AT := Vector3(-10.4, 0.12, -47.0)    # Fargona: Forner and his car
const AGATA_AT := Vector3(10.9, 0.12, 12.0)       # the Heights: Agata, Addison
const SWARM := Vector3(-10.0, 10.0, -40.0)
const YARD := Rect2(-13.0, -90.0, 5.4, 22.0)      # Rail Cut: the substation yard (x, z, w, d)
const GATE_X := -10.9
const TYSON_AT := Vector3(-7.4, 0.12, -90.0)      # Red Rock: the subway stairs

var main: Node
var city: Node
## Where Carl stands when he comes back out onto a street: {district, pos, yaw}.
var back := {}
## Selftest: a choice key -> the index to pick (bypasses the dialogue box).
var test_picks := {}
## The street being dressed, and its case nodes by name.
var _lv: Node
var _n := {}
var _swarm_root: Node3D
var _fails := 0


func setup(m: Node, c: Node) -> void:
	main = m
	city = c


# ------------------------------------------------------------------ state

func _key(cid: String, st: String) -> String:
	return "case_%s_%s" % [cid, st]


func done(cid: String, st: String) -> bool:
	return main.flags.has(_key(cid, st))


func ending(cid: String) -> String:
	return str(main.flags.get(_key(cid, "ending"), ""))


## The case is on the board (its flags hold) and not closed.
func opened(cid: String) -> bool:
	if ending(cid) != "":
		return false
	var f: Dictionary = main.flags
	var d := int(main.day)
	match cid:
		"forner":
			return d >= 4 and f.has("observatory_done")
		"nathan":
			# bible-2 "Act 1 openness": the Nathan case opens at S6 (Southtown)
			return f.has("southtown_done")
		"vigil":
			return d >= 4 and f.has("blackout_done")
		"agata":
			# bible-1 Characters: T:agata >= +1 opens her case. The park is where
			# that is earned; the honest answer there counts as the +1.
			return d == 5 and f.has("park_done") and (int(main.trust.get("agata", 0)) >= 1 or f.has("told_agata_truth"))
		"annie":
			return d >= 4 and f.has("blackout_done")
		"tyson":
			return d >= 4 and f.has("park_done") and not main.given.has("tyson") and city.now_abs() < 5 * 24 + 20
	return false


## The step the case is on ("" when every step is done).
func step(cid: String) -> String:
	for s: Array in CASES[cid]:
		if not done(cid, str(s[0])):
			return str(s[0])
	return ""


func district_of(cid: String, st: String) -> String:
	for s: Array in CASES[cid]:
		if str(s[0]) == st:
			return str(s[1])
	return ""


## The hours a step can happen in (bible: the vigils are nights, Annie
## 20:00-02:00, Agata Day 5 15-17, Tyson's exit Day 5 before Lushon's).
func window_ok(cid: String, st: String) -> bool:
	var h := int(main.hour) % 24
	match cid:
		"forner":
			if st in ["vigil", "choice"]:
				return city.is_night()
		"vigil":
			return city.is_night()
		"agata":
			return int(main.day) == 5 and int(main.hour) >= 15 and int(main.hour) < 17
		"annie":
			return h >= 20 or h < 2
		"tyson":
			var a: int = city.now_abs()
			return a >= 4 * 24 + 22 and a < 5 * 24 + 20
	return true


func window_text(cid: String, st: String) -> String:
	var W: Dictionary = LINES["when"]
	match cid:
		"forner":
			if st in ["vigil", "choice"]:
				return W["night"]
		"vigil":
			return W["night"]
		"agata":
			return W["agata"]
		"annie":
			return W["annie"]
		"tyson":
			return W["tyson"] if int(main.day) >= 5 else W["tyson_from"]
	return ""


## Available now: open, a step left, its hours.
func available(cid: String) -> bool:
	return opened(cid) and step(cid) != "" and window_ok(cid, step(cid))


func at(cid: String, district: String) -> bool:
	return available(cid) and district_of(cid, step(cid)) == district


func step_text(cid: String) -> String:
	var st := step(cid)
	return str(LINES["steps"][cid].get(st, "")) if st != "" else ""


func _mark(cid: String, st: String) -> void:
	if done(cid, st):
		return
	main.flags[_key(cid, st)] = true
	main.log_line("case", "%s: %s" % [LINES["titles"][cid], st])
	var nx := step_text(cid)
	if nx != "" and st != "choice":
		main.ui.show_toast(LINES["toast_step"] % nx.trim_prefix("(game) "), 3.0)
	main.update_hud()


func _end(cid: String, outcome: String, text: String) -> void:
	for s: Array in CASES[cid]:
		main.flags[_key(cid, str(s[0]))] = true
	main.flags[_key(cid, "ending")] = outcome
	main.log_line("case", LINES["log_end"] % [LINES["titles"][cid], text])
	main.ui.show_toast(LINES["toast_end"] % LINES["titles"][cid], 3.0)
	main.update_hud()


## A clue on the Board: a flag and a ledger line tagged with the claim.
func clue(claim: String, id: String, text: String) -> void:
	var k := "clue_%s_%s" % [claim, id]
	if main.flags.has(k):
		return
	main.flags[k] = true
	var cl: String = LINES["claims"][claim]
	main.log_line("clue", LINES["clue_log"] % [text.trim_prefix("(game) "), cl])
	main.ui.show_toast(LINES["clue_toast"] % cl, 4.0)


## The clues linked to a claim (the Board reads these).
func clues(claim: String) -> Array:
	var out := []
	for k in main.flags:
		if str(k).begins_with("clue_%s_" % claim):
			out.append(str(k).trim_prefix("clue_%s_" % claim))
	return out


## The bible's state shape: {case_id: {step: int, ending: str}}.
func state() -> Dictionary:
	var out := {}
	for cid: String in ORDER:
		var n := 0
		for s: Array in CASES[cid]:
			if done(cid, str(s[0])):
				n += 1
		out[cid] = {"step": n, "ending": ending(cid)}
	return out


## A new morning: the notices for cases that opened overnight; Tyson's rule
## (bible-1: trust <= -1 and he leaves the city on Day 5, Burn closes).
func morning(d: int) -> void:
	for cid: String in ORDER:
		var nk := "case_%s_notice" % cid
		if opened(cid) and not main.flags.has(nk):
			main.flags[nk] = true
			city.feed(str(LINES["notice"][cid]))
	if d >= 6 and ending("tyson") == "" and not main.given.has("tyson") and int(main.trust.get("tyson", 0)) <= -1:
		main.flags[_key("tyson", "ending")] = "left"
		main.flags["tyson_exit"] = "left"
		main.flags["tyson_left"] = true
		main.flags["burn_closed"] = true
		main.log_line("case", LINES["log_end"] % [LINES["titles"]["tyson"], LINES["tyson"]["outcomes"]["left"]])
		city.feed(str(LINES["tyson"]["gone_feed"]))


# ------------------------------------------------------------------ the Day card, the objective, the map, the phone

## The Day card's one side-case step: the first case on the board.
func day_row() -> String:
	for cid: String in ORDER:
		if not opened(cid) or step(cid) == "":
			continue
		var st := step(cid)
		var t: String = LINES["card_row"] % [city.district_name(district_of(cid, st)), step_text(cid).trim_prefix("(game) ")]
		var w := window_text(cid, st)
		if w != "" and not window_ok(cid, st):
			t += LINES["card_when"] % w
		return t
	return ""


## The objective on a street with a case step on it.
func objective_here(district: String) -> String:
	for cid: String in ORDER:
		if at(cid, district):
			return LINES["objective"] % step_text(cid).trim_prefix("(game) ")
	return ""


func map_has(district: String) -> bool:
	return not map_lines(district).is_empty()


func map_lines(district: String) -> Array:
	var out := []
	for cid: String in ORDER:
		if opened(cid) and step(cid) != "" and district_of(cid, step(cid)) == district:
			var t: String = LINES["map"] % [LINES["titles"][cid], step_text(cid).trim_prefix("(game) ")]
			var w := window_text(cid, step(cid))
			if w != "":
				t += "  (" + w + ")"
			out.append(t)
	return out


func phone_text() -> String:
	var t := ""
	for cid: String in ORDER:
		if ending(cid) != "":
			t += LINES["phone_done"] % [LINES["titles"][cid], ending(cid)]
		elif opened(cid) and step(cid) != "":
			t += LINES["phone_row"] % [LINES["titles"][cid], city.district_name(district_of(cid, step(cid)))]
	return (LINES["phone_head"] + t + "\n") if t != "" else ""


# ------------------------------------------------------------------ small helpers

func _choose(opts: Array, key: String) -> int:
	if test_picks.has(key):
		return int(test_picks[key])
	return await main.ui.choose(opts)


func _think(t: String) -> void:
	await main.ui.think(t.trim_prefix("(game) "))


func _say(who: String, t: String) -> void:
	await main.ui.say(who, t.trim_prefix("(game) "))


## An interface round (bible-1 "Dive / communion"): a riddle as a choice.
## Solved: +5 Connection, +1 devotion, a sleeper point, an hour. Failed: +3.
## Past 50 it solves itself ("You already knew").
func _interface(key: String, q: String, opts: Array, right: int, right_line: String) -> bool:
	var I: Dictionary = LINES["interface"]
	if not main.frames_on:
		await _think(I["no_frames"])
		main.ui.close()
		return false
	main.play("glitch", -6.0)
	main.ui.glitch(0.8, 0.8)
	var deep: bool = main.connection >= 50.0
	await _think(I["dive_deep"] if deep else I["dive"])
	var ok := deep
	if deep:
		await _say("Psyon", I["knew"])
	else:
		await _say("Psyon", q)
		var i: int = await _choose(opts, key)
		ok = i == right
	if ok:
		await _say("Psyon", right_line)
		main.ui.close()
		main.add_connection(5.0, I["why"])
		city.add_devotion(1, I["why"])
		main.add_stance("sleeper")
		city.advance(1)
	else:
		await _think(I["fail"])
		main.ui.close()
		main.add_connection(3.0, I["why_fail"])
	return ok


func _fig(lv: Node, coat: Color, skin: Color, opts: Dictionary, pos: Vector3, yaw: float) -> Node3D:
	opts["arms"] = true
	opts["knees"] = true
	var f: Node3D = lv.figure(coat, skin, opts)
	f.position = pos
	f.rotation.y = yaw
	lv.add_child(f)
	return f


func _seat(f: Node3D) -> void:
	f.position.y -= 0.41
	Anim.sit(f)


func _arms_up(f: Node3D, x := -2.5) -> void:
	for a in f.get_meta("arms"):
		(a as Node3D).rotation.x = x


func _head_up(f: Node3D, x := 0.45) -> void:
	(f.get_meta("head") as Node3D).rotation.x = x


func _visor(lv: Node, f: Node3D, c: Color) -> void:
	var v = f.get_meta("visor") if f.has_meta("visor") else null
	if v is MeshInstance3D:
		(v as MeshInstance3D).material_override = lv.glow(c, 3.0)


func _node(lv: Node, id: String) -> Node:
	for n in main._all_with_meta(lv, "id"):
		if is_instance_valid(n) and str(n.get_meta("id")) == id:
			return n
	return null


# ------------------------------------------------------------------ dressing the street (Street.build calls this)

func dress(lv: Node) -> void:
	_lv = lv
	_n = {}
	_swarm_root = null
	match str(lv.did):
		"spine":
			_dress_spine(lv)
		"lamplight":
			_dress_lamplight(lv)
		"fargona":
			_dress_fargona(lv)
		"heights":
			_dress_heights(lv)
		"rail_cut":
			_dress_rail_cut(lv)
		"red_rock":
			_dress_red_rock(lv)
	if not back.is_empty() and str(back.get("district", "")) == str(lv.did):
		lv.spawn = back["pos"]
		lv.spawn_yaw = float(back["yaw"])
	back = {}


## The Spine: the charge post by the lot (Forner), Annie's vigil at night.
func _dress_spine(lv: Node) -> void:
	var F: Dictionary = LINES["forner"]
	var metal: Material = lv.mat(Color(0.2, 0.22, 0.23), 0.45, 0.6)
	var green := Color(0.35, 1.0, 0.6)
	lv.box(Vector3(0.42, 1.7, 0.5), POST + Vector3(0, 0.85, 0), metal, true)
	lv.box(Vector3(0.5, 0.12, 0.58), POST + Vector3(0, 1.76, 0), lv.mat(Color(0.08, 0.08, 0.09), 0.4, 0.5))
	lv.no_batch.append(lv.quad(Vector2(0.3, 0.42), POST + Vector3(0.22, 1.25, 0), PI / 2.0, lv.glow(green, 1.4, true)))
	lv.cyl(0.03, 0.03, 1.2, POST + Vector3(0.3, 0.6, 0.18), lv.mat(Color(0.04, 0.04, 0.04), 0.7), 6)
	lv.box(Vector3(0.9, 0.02, 2.4), POST + Vector3(2.4, 0.01, 0), lv.mat(Color(0.2, 0.45, 0.35), 0.8))
	lv.neon_text("ALTO  9", POST + Vector3(0.23, 1.62, 0), PI / 2.0, 0.09, green, -1.0, lv)
	var it: CollisionObject3D = lv.interactable("case_charger", F["post_prompt"], POST + Vector3(0.1, 1.0, 0), Vector3(0.8, 2.0, 0.9), F["post_scan"], false)
	it.set_meta("hackable", true)
	it.set_meta("hack_kind", "terminal")
	it.set_meta("company", false)
	_n["charger"] = it
	if int(lv.faith) >= 1:
		lv._glyph_on(POST + Vector3(0.23, 0.55, 0.0), PI / 2.0, 0.0035, "glyph_chargepost", false, false,
			"(game) Rings on the charge post's casing, drawn where the cable plugs in. The inner ring was the socket.")
	# Annie's vigil: nights from Day 4 (bible: "Annie Seung's vigil (Day 3 night onward)")
	if lv.night and int(main.day) >= 4 and main.flags.has("blackout_done"):
		var A: Dictionary = LINES["annie"]
		var wax: Material = lv.mat(Color(0.92, 0.88, 0.78), 0.8)
		var flame: Material = lv.glow(Color(1.0, 0.65, 0.25), 3.0)
		for i in 14:
			var a := TAU * i / 14.0
			var p := ANNIE_C + Vector3(cos(a) * 1.3, 0.0, sin(a) * 1.3)
			lv.cyl(0.035, 0.035, 0.18, p + Vector3(0, 0.09, 0), wax, 6)
			lv.box(Vector3(0.02, 0.04, 0.02), p + Vector3(0, 0.2, 0), flame)
		lv.light(ANNIE_C + Vector3(0, 0.6, 0), Color(1.0, 0.6, 0.3), 1.8, 7.0, false)
		var coats := [Color(0.18, 0.2, 0.24), Color(0.3, 0.26, 0.22), Color(0.12, 0.14, 0.12), Color(0.35, 0.3, 0.3), Color(0.22, 0.16, 0.2)]
		var skins := [Color(0.85, 0.66, 0.52), Color(0.6, 0.42, 0.3), Color(0.92, 0.78, 0.66), Color(0.45, 0.32, 0.24), Color(0.75, 0.58, 0.46)]
		var singers := []
		for i in 5:
			var a := TAU * (i + 0.5) / 6.0 + 0.4
			var p := ANNIE_C + Vector3(cos(a) * 2.2, -0.02, sin(a) * 2.2)
			var s := _fig(lv, coats[i], skins[i], {"visor": true}, p, 0.0)
			lv.turn_to(s, ANNIE_C)
			_head_up(s, 0.25)
			for arm in s.get_meta("arms"):
				(arm as Node3D).rotation.x = -0.7
			lv.cyl(0.028, 0.03, 0.16, Vector3(0, 1.1, -0.34), wax, 6, s)
			lv.box(Vector3(0.02, 0.04, 0.02), Vector3(0, 1.21, -0.34), flame, false, s)
			singers.append(s)
			if i < 3:
				lv.person("case_singer%d" % i, A["singer_prompt"], s, A["singer_scan"][i])
		_n["singers"] = singers
		var an := _fig(lv, Color(0.16, 0.12, 0.1), Color(0.9, 0.76, 0.62), {"long_hair": true, "hair": Color(0.08, 0.06, 0.05)}, ANNIE_C + Vector3(2.3, 0.0, 1.6), 0.0)
		lv.turn_to(an, ANNIE_C)
		lv.cyl(0.028, 0.03, 0.16, Vector3(0, 1.1, -0.34), wax, 6, an)
		lv.box(Vector3(0.02, 0.04, 0.02), Vector3(0, 1.21, -0.34), flame, false, an)
		_n["annie"] = an
		if window_ok("annie", "ask"):
			lv.person("case_annie", A["prompt"], an, A["scan"])
		else:
			an.visible = false


## Lamplight: the far tower's door, once the Forner case is open.
func _dress_lamplight(lv: Node) -> void:
	if not (opened("forner") or ending("forner") != ""):
		return
	var F: Dictionary = LINES["forner"]
	var dark: Material = lv.mat(Color(0.08, 0.07, 0.07), 0.6, 0.3)
	lv.box(Vector3(0.3, 2.8, 2.2), DOOR + Vector3(-0.05, 1.4, 0), lv.mat(Color(0.3, 0.3, 0.32), 0.7))
	lv.box(Vector3(0.12, 2.3, 1.4), DOOR + Vector3(-0.22, 1.15, 0), dark)
	lv.no_batch.append(lv.quad(Vector2(0.6, 0.18), DOOR + Vector3(-0.3, 2.45, 0), -PI / 2.0, lv.glow(Color(1.0, 0.85, 0.55), 1.4, true)))
	lv.neon_text(F["door_sign"], DOOR + Vector3(-0.31, 2.95, 0), -PI / 2.0, 0.22, Color(1.0, 0.8, 0.5), -1.0, lv)
	lv.box(Vector3(0.06, 0.18, 0.12), DOOR + Vector3(-0.3, 1.3, 0.85), lv.glow(Color(0.3, 1.0, 0.6), 2.0))
	lv.light(DOOR + Vector3(-1.4, 2.6, 0), Color(1.0, 0.75, 0.45), 1.2, 6.0)
	var d: CollisionObject3D = lv.interactable("case_forner_door", F["door"], DOOR + Vector3(-0.45, 1.2, 0), Vector3(0.6, 2.4, 1.6), F["door_scan"], false)
	d.set_meta("exit", true)
	_n["door"] = d


## Fargona at night: the vigil's mourners, the bank's screens, the preacher;
## Forner by his car when the case has brought Carl here.
func _dress_fargona(lv: Node) -> void:
	var V: Dictionary = LINES["vigil"]
	var F: Dictionary = LINES["forner"]
	# the screens: sixty-one faces, every one still posting (day and night)
	var k: Dictionary = lv._kit_mats()
	lv.box(Vector3(0.3, 4.6, 7.0), SCREENS + Vector3(0.1, 4.4, 0), k["dark"], true)
	var skins := [Color(0.85, 0.66, 0.52), Color(0.6, 0.42, 0.3), Color(0.4, 0.28, 0.2), Color(0.92, 0.78, 0.66), Color(0.7, 0.52, 0.38)]
	var n := 0
	for r in 8:
		for c in 8:
			if n >= 61:
				break
			var p := SCREENS + Vector3(0.27, 2.55 + r * 0.53, -2.8 + c * 0.8)
			lv.quad(Vector2(0.62, 0.44), p, PI / 2.0, lv.glow(skins[(r * 3 + c) % skins.size()] * 0.8, 0.9, true))
			n += 1
	lv.box(Vector3(0.05, 0.08, 7.0), SCREENS + Vector3(0.28, 2.2, 0), lv.glow(Color(0.4, 0.75, 1.0), 2.0, true))
	lv.neon_text(V["screens_sign"], SCREENS + Vector3(0.3, 7.0, 0), PI / 2.0, 0.34, Color(0.5, 0.8, 1.0), -1.0, lv)
	lv.interactable("case_screens", V["screens_prompt"], SCREENS + Vector3(0.9, 2.6, 0), Vector3(1.0, 3.0, 6.4), V["screens_scan"], false)
	if lv.night:
		lv.light(SCREENS + Vector3(2.5, 3.5, 0), Color(0.55, 0.7, 1.0), 1.6, 9.0)
	if not lv.night:
		return
	# the mourners, tablets up the way a preacher holds a bible
	var tab: Material = lv.glow(Color(0.55, 0.85, 1.0), 1.8)
	var coats := [Color(0.2, 0.22, 0.3), Color(0.35, 0.3, 0.12), Color(0.25, 0.25, 0.27)]
	var mourners := []
	for i in 3:
		var p := Vector3(-10.6, 0.12, MOURN_Z[i])
		var f := _fig(lv, coats[i], skins[(i * 2) % skins.size()], {"visor": true, "hair": Color(0.6, 0.6, 0.6) if i == 2 else Color(0.06, 0.05, 0.05)}, p, PI / 2.0)
		_head_up(f, 0.55)
		_arms_up(f, -2.6)
		lv.box(Vector3(0.28, 0.2, 0.02), Vector3(0, 2.15, -0.18), tab, false, f)
		_visor(lv, f, Color(0.6, 0.85, 1.0))
		lv.person("case_mourner%d" % i, V["mourner_prompt"], f, V["mourner_scan"] % V["dead"][i])
		mourners.append(f)
	# more of the vigil round them, not to talk to
	for i in 5:
		var p := Vector3(-8.6 - (i % 2) * 1.2, 0.12, -58.0 - i * 3.3)
		var f := _fig(lv, coats[(i + 1) % 3], skins[(i + 1) % skins.size()], {"visor": true}, p, PI / 2.0 + (i - 2) * 0.15)
		_head_up(f, 0.5)
		_arms_up(f, -2.4 if i % 2 == 0 else -0.4)
		if i % 2 == 0:
			lv.box(Vector3(0.28, 0.2, 0.02), Vector3(0, 2.1, -0.16), tab, false, f)
		mourners.append(f)
	_n["mourners"] = mourners
	var wax: Material = lv.mat(Color(0.92, 0.88, 0.78), 0.8)
	var flame: Material = lv.glow(Color(1.0, 0.65, 0.25), 3.0)
	for i in 16:
		var p := Vector3(-7.6, 0.14, -56.0 - i * 2.0)
		lv.cyl(0.035, 0.035, 0.16, p + Vector3(0, 0.08, 0), wax, 6)
		lv.box(Vector3(0.02, 0.04, 0.02), p + Vector3(0, 0.19, 0), flame)
	lv.light(Vector3(-9.0, 1.2, -66.0), Color(1.0, 0.6, 0.35), 1.4, 8.0, false)
	# the preacher: the night layer's (Night.gd) heads the vigil from Day 4;
	# the case hangs its talk on him once the street is built
	if opened("vigil"):
		_attach_preacher.call_deferred(lv)
	# Forner, by his car on four percent
	if opened("forner") and step("forner") in ["vigil", "choice"]:
		_dress_forner(lv, tab)


## The vigil's preacher: the night layer's man on his crate when there is
## one (one preacher on Fargona, not two); otherwise ours by the screens.
func _attach_preacher(lv: Node) -> void:
	if not is_instance_valid(lv) or lv != main.level:
		return
	var V: Dictionary = LINES["vigil"]
	var nl = lv.get("night_layer")
	if nl != null and is_instance_valid(nl) and nl.get("preacher") != null:
		var np: Node3D = nl.preacher
		lv.interactable("case_preacher", V["preacher_prompt"], Vector3(0, 1.1, 0), Vector3(1.6, 2.6, 1.6), V["preacher_scan"], false, np)
		_n["preacher"] = np
		_n["night_preacher"] = true
		return
	var tab: Material = lv.glow(Color(0.55, 0.85, 1.0), 1.8)
	var pr := _fig(lv, Color(0.03, 0.03, 0.035), Color(0.6, 0.6, 0.6), {"hair": Color(0.02, 0.02, 0.02), "long_coat": true}, PREACHER, 0.0)
	var hd: Node3D = pr.get_meta("head")
	lv.box(Vector3(0.22, 0.26, 0.04), Vector3(0, 0.0, -0.12), lv.mat(Color(0.85, 0.83, 0.78), 0.4), false, hd)
	for s: float in [-1.0, 1.0]:
		lv.box(Vector3(0.05, 0.03, 0.02), Vector3(s * 0.05, 0.03, -0.145), lv.mat(Color(0.0, 0.0, 0.0), 1.0), false, hd)
	lv.box(Vector3(0.36, 0.42, 0.18), Vector3(0.28, 0.95, 0.05), lv.mat(Color(0.12, 0.1, 0.08), 0.9), false, pr)
	lv.box(Vector3(0.2, 0.26, 0.02), Vector3(0, 1.9, -0.3), tab, false, pr)
	_arms_up(pr, -1.9)
	lv.person("case_preacher", V["preacher_prompt"], pr, V["preacher_scan"])
	_n["preacher"] = pr


func _dress_forner(lv: Node, tab: Material) -> void:
	var F: Dictionary = LINES["forner"]
	var car: Node3D = Car.build(lv, Color(0.12, 0.3, 0.26), {"plate": "PSY 4407"})
	car.position = Vector3(-5.7, 0.0, FORNER_AT.z - 0.5)
	lv.add_child(car)
	lv.solid_box(Vector3(2.0, 1.5, 4.6), car.position + Vector3(0, 0.75, 0))
	lv.interactable("case_forner_car", F["car_prompt"], car.position + Vector3(0, 0.9, 0), Vector3(2.2, 1.6, 4.8), "", false)
	var fo := _fig(lv, Color(0.5, 0.42, 0.32), Color(0.72, 0.58, 0.45), {"hair": Color(0.55, 0.55, 0.52), "legs": Color(0.3, 0.26, 0.22), "long_coat": false, "scale": 1.06, "visor": true}, FORNER_AT, PI / 2.0)
	_head_up(fo, 0.5)
	_arms_up(fo, -2.3)
	lv.box(Vector3(0.28, 0.2, 0.02), Vector3(0, 2.05, -0.16), tab, false, fo)
	_visor(lv, fo, Color(1.0, 0.3, 0.85))
	lv.person("case_forner", F["him_prompt"], fo, F["him_scan"])
	_n["forner"] = fo


## The Heights: the swarm over one house (Nathan); Agata and Addison on Day 5.
func _dress_heights(lv: Node) -> void:
	var N: Dictionary = LINES["nathan"]
	if opened("nathan") and step("nathan") in ["swarm", "choice"]:
		_swarm_root = Node3D.new()
		_swarm_root.position = SWARM
		_swarm_root.set_meta("case_swarm", true)
		lv.add_child(_swarm_root)
		var red: Material = lv.glow(Color(1.0, 0.12, 0.08), 4.0)
		for i in 6:
			var a := TAU * i / 6.0
			var p := Vector3(cos(a) * 4.0, 0.0, sin(a) * 4.0)
			lv.prop("delivery_drone", p, -a, 1.0, false, _swarm_root)
			lv.box(Vector3(0.12, 0.12, 0.12), p + Vector3(0, -0.35, 0), red, false, _swarm_root)
		lv.interactable("case_swarm", N["swarm_prompt"], Vector3(SWARM.x + 0.4, 1.5, SWARM.z), Vector3(4.0, 3.0, 4.0), N["swarm_scan"], false)
	if opened("agata") and window_ok("agata", step("agata")):
		var A: Dictionary = LINES["agata"]
		var wood: Material = lv.pbr("woodfloor", Vector3(1, 1, 1) / 1.0, true, Color(0.55, 0.42, 0.3))
		lv.box(Vector3(0.5, 0.06, 2.0), AGATA_AT + Vector3(0.15, 0.38, 0), wood, true)
		lv.box(Vector3(0.06, 0.5, 2.0), AGATA_AT + Vector3(0.45, 0.66, 0), wood)
		for z: float in [-0.85, 0.85]:
			lv.box(Vector3(0.45, 0.38, 0.06), AGATA_AT + Vector3(0.15, 0.19, z), lv.mat(Color(0.1, 0.1, 0.1), 0.5, 0.6))
		var ag := _fig(lv, Color(0.35, 0.4, 0.45), Color(0.9, 0.76, 0.64), {"hair": Color(0.78, 0.74, 0.62), "long_hair": true, "legs": Color(0.2, 0.22, 0.3)}, AGATA_AT + Vector3(0.05, 0.0, 0.4), -PI / 2.0)
		_seat(ag)
		lv.person("case_agata", A["prompt"], ag, A["scan"])
		_n["agata"] = ag
		# Addison in his circle on the pavement, the tablet in the middle
		var c := Vector3(8.7, 0.13, 9.6)
		var stick: Material = lv.mat(Color(0.42, 0.33, 0.22), 0.9)
		for ring: float in [0.38, 0.62]:
			var cnt := 9 if ring < 0.5 else 14
			for i in cnt:
				var a := TAU * i / cnt
				var st: MeshInstance3D = lv.box(Vector3(0.025, 0.025, 0.26), c + Vector3(cos(a) * ring, 0.0, sin(a) * ring), stick)
				st.rotation.y = -a
		lv.sphere(0.06, c + Vector3(0, 0.03, -0.5), lv.mat(Color(0.85, 0.84, 0.8), 0.6), 6)
		lv.box(Vector3(0.2, 0.012, 0.28), c + Vector3(0, 0.01, 0), lv.mat(Color(0.05, 0.05, 0.06), 0.4))
		lv.no_batch.append(lv.floor_quad(Vector2(0.17, 0.24), c + Vector3(0, 0.018, 0), 0.0, lv.glow(Color(0.5, 0.85, 1.0), 1.8)))
		var son := _fig(lv, Color(0.55, 0.2, 0.18), Color(0.9, 0.76, 0.64), {"hair": Color(0.7, 0.6, 0.4), "scale": 0.62}, c + Vector3(0.85, 0.0, 0.0), -PI / 2.0)
		Anim.crouch(son)
		son.position.y -= 0.28
		_head_up(son, -0.35)
		lv.person("case_addison", A["son_prompt"], son, A["son_scan"])
		_n["son"] = son
		# his drawing, weighted with a stone on the kerb by the bench
		var dp := Vector3(9.6, 0.135, 11.0)
		lv.floor_quad(Vector2(0.3, 0.42), dp, 0.3, lv.mat(Color(0.9, 0.88, 0.8), 0.9))
		var s := Sprite3D.new()
		s.texture = lv._glyph_tex
		s.pixel_size = 0.0018
		s.modulate = Color(0.85, 0.08, 0.06)
		s.rotation = Vector3(-PI / 2.0, 0.3, 0)
		s.position = dp + Vector3(0, 0.006, 0)
		lv.add_child(s)
		lv.interactable("case_drawing", A["drawing_prompt"], dp + Vector3(0, 0.25, 0), Vector3(0.9, 0.6, 0.9), "", false)
		lv.light(c + Vector3(0.6, 1.4, 1.0), Color(0.6, 0.8, 1.0), 0.9, 5.0, false)


## Rail Cut: Alto substation 14's yard, fenced, a gate with a reader and a
## camera over it, a gap behind the cable drum; the fleet log in cabinet two.
## The four ways in (bible-1 "Danger tiers and guarded sites"): badge,
## hack (the reader, the gate, or the camera while Carl uses the gap), sneak
## (the gap, timed against the camera), person (Seth, the Voltx responder).
func _dress_rail_cut(lv: Node) -> void:
	var N: Dictionary = LINES["nathan"]
	var post_m: Material = lv.mat(Color(0.3, 0.31, 0.3), 0.5, 0.7)
	var link: StandardMaterial3D = lv.newmat(Color(0.35, 0.38, 0.38, 0.42), 0.6, 0.6)
	link.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	link.cull_mode = BaseMaterial3D.CULL_DISABLED
	var x0 := YARD.position.x
	var x1 := YARD.position.x + YARD.size.x
	var z0 := YARD.position.y
	var z1 := YARD.position.y + YARD.size.y
	# the street side (x1), with the gap at z -85.1
	var gap0 := -85.6
	var gap1 := -84.6
	for seg: Array in [[z0, gap0], [gap1, z1]]:
		var a: float = seg[0]
		var b: float = seg[1]
		lv.box(Vector3(0.04, 2.4, b - a), Vector3(x1, 1.2, (a + b) / 2.0), link)
		lv.solid_box(Vector3(0.12, 2.6, b - a), Vector3(x1, 1.3, (a + b) / 2.0))
		for y: float in [0.1, 2.35]:
			lv.box(Vector3(0.05, 0.05, b - a), Vector3(x1, y, (a + b) / 2.0), post_m)
	# the north side
	lv.box(Vector3(x1 - x0, 2.4, 0.04), Vector3((x0 + x1) / 2.0, 1.2, z0), link)
	lv.solid_box(Vector3(x1 - x0, 2.6, 0.12), Vector3((x0 + x1) / 2.0, 1.3, z0))
	# the south side, the gate at GATE_X .. GATE_X + 1.4
	for seg: Array in [[x0, GATE_X], [GATE_X + 1.4, x1]]:
		var a: float = seg[0]
		var b: float = seg[1]
		lv.box(Vector3(b - a, 2.4, 0.04), Vector3((a + b) / 2.0, 1.2, z1), link)
		lv.solid_box(Vector3(b - a, 2.6, 0.12), Vector3((a + b) / 2.0, 1.3, z1))
		lv.box(Vector3(b - a, 0.05, 0.05), Vector3((a + b) / 2.0, 2.35, z1), post_m)
	var z := z0
	while z <= z1 + 0.01:
		lv.cyl(0.04, 0.04, 2.5, Vector3(x1, 1.25, z), post_m, 6)
		z += 2.2
	var x := x0
	while x <= x1 + 0.01:
		lv.cyl(0.04, 0.04, 2.5, Vector3(x, 1.25, z1), post_m, 6)
		x += 1.8
	# razor wire along the top
	var wire: Material = lv.mat(Color(0.5, 0.5, 0.52), 0.4, 0.8)
	for i in 10:
		var za := z0 + i * (z1 - z0) / 10.0
		var zb := za + (z1 - z0) / 10.0
		lv.stick(Vector3(x1, 2.5, za), Vector3(x1 - 0.15, 2.7, (za + zb) / 2.0), 0.012, wire)
		lv.stick(Vector3(x1 - 0.15, 2.7, (za + zb) / 2.0), Vector3(x1, 2.5, zb), 0.012, wire)
	# the cable drum that hides the gap, the warning sign, the glyphs
	var drum: MeshInstance3D = lv.cyl(0.75, 0.75, 0.7, Vector3(x1 + 0.9, 0.75, -86.6), lv.pbr("woodfloor", Vector3.ONE, true, Color(0.5, 0.38, 0.26)), 14)
	drum.rotation.x = PI / 2.0
	lv.solid_box(Vector3(0.75, 1.5, 1.5), Vector3(x1 + 0.9, 0.75, -86.6))
	lv.box(Vector3(0.02, 0.5, 0.7), Vector3(x1 + 0.05, 1.6, -76.0), lv.mat(Color(0.95, 0.8, 0.1), 0.6))
	lv.neon_text("ALTO 14", Vector3(x1 + 0.08, 1.95, -76.0), PI / 2.0, 0.14, Color(1.0, 0.85, 0.2), 0.6, lv)
	lv._glyph_on(Vector3(x0 + 0.06, 1.8, -80.0), PI / 2.0, 0.008, "glyph_substation", false, false,
		"WE KNOW WHO SENDS THE SIGNALS, scratched in under rings drawn on the hut wall.")
	# the hut and cabinet two
	var conc: Material = lv.pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.55, 0.53, 0.5))
	lv.box(Vector3(0.6, 3.0, 9.0), Vector3(x0 - 0.2, 1.5, -80.5), conc, true)
	lv.prop("power_box_01", Vector3(x0 + 0.6, 0.12, -74.5), PI / 2.0, 1.0, true)
	lv.prop("fuse_panel", Vector3(x0 + 0.5, 0.12, -77.0), PI / 2.0, 1.0, true)
	var rack: Node3D = lv.prop("server_rack", Vector3(x0 + 0.55, 0.12, -82.0), PI / 2.0, 1.0, true)
	if rack == null:
		lv.box(Vector3(0.8, 2.0, 0.7), Vector3(x0 + 0.55, 1.12, -82.0), lv.mat(Color(0.08, 0.08, 0.09), 0.5, 0.4), true)
	lv.no_batch.append(lv.quad(Vector2(0.3, 0.12), Vector3(x0 + 1.0, 1.5, -82.0), PI / 2.0, lv.glow(Color(0.3, 1.0, 0.5), 1.5, true)))
	lv.interactable("case_log", N["log_prompt"], Vector3(x0 + 1.0, 1.1, -82.0), Vector3(0.6, 2.0, 1.0), N["log_scan"], false)
	lv.light(Vector3(x0 + 2.4, 2.6, -79.0), Color(0.75, 0.85, 1.0), 1.1, 8.0)
	# the gate: a hinged leaf the reader (we), the lock (dreamer) or a route opens
	var gh := Node3D.new()
	gh.position = Vector3(GATE_X, 0.0, z1)
	lv.add_child(gh)
	lv.box(Vector3(1.4, 2.3, 0.04), Vector3(0.7, 1.2, 0), link, false, gh)
	lv.box(Vector3(1.4, 0.06, 0.06), Vector3(0.7, 2.33, 0), post_m, false, gh)
	lv.box(Vector3(1.4, 0.06, 0.06), Vector3(0.7, 0.12, 0), post_m, false, gh)
	lv.box(Vector3(0.06, 2.3, 0.06), Vector3(1.37, 1.2, 0), post_m, false, gh)
	var blk: StaticBody3D = lv.solid_box(Vector3(1.4, 2.6, 0.12), Vector3(GATE_X + 0.7, 1.3, z1))
	var gi: CollisionObject3D = lv.interactable("case_gate", N["gate_prompt"], Vector3(0.7, 1.1, 0.25), Vector3(1.4, 2.2, 0.3), N["gate_scan"], false, gh)
	gi.set_meta("hackable", true)
	gi.set_meta("hack_kind", "door")
	gi.set_meta("company", true)
	gi.set_meta("door_node", gh)
	gi.set_meta("door_block", blk)
	gi.set_meta("door_angle", 1.6)
	_n["gate_h"] = gh
	_n["gate_blk"] = blk
	var rd: CollisionObject3D = lv.interactable("case_reader", N["routes"]["badge"].split("   ")[0], Vector3(GATE_X + 1.62, 1.25, z1 + 0.12), Vector3(0.3, 0.4, 0.3), "BADGE READER\nALTO / PSYONIC\nstatus: LOCKED", false)
	lv.box(Vector3(0.14, 0.22, 0.06), Vector3(GATE_X + 1.62, 1.25, z1 + 0.08), lv.mat(Color(0.1, 0.1, 0.11), 0.4, 0.5))
	lv.box(Vector3(0.05, 0.05, 0.02), Vector3(GATE_X + 1.62, 1.33, z1 + 0.11), lv.glow(Color(1.0, 0.15, 0.1), 3.0))
	rd.set_meta("hackable", true)
	rd.set_meta("hack_kind", "reader")
	rd.set_meta("company", true)
	rd.set_meta("door_node", gh)
	rd.set_meta("door_block", blk)
	rd.set_meta("door_angle", 1.6)
	# the camera over the gate, sweeping the yard (Stealth: the sneak route is timed against it)
	var zone := AABB(Vector3(x0, -1.0, z0), Vector3(x1 - x0, 6.0, z1 - z0))
	var cam: Node3D = EncountersS.camera(lv, Vector3(x1 - 0.3, 3.0, z1 - 0.3), 0.35, {"zone": zone, "safe": Vector3(0.0, 0.1, -60.0), "sweep": 0.55, "pitch": 0.45}, true, "case_gate_cam")
	_n["cam"] = cam
	if main.flags.has("case_nathan_gate"):
		gh.rotation.y = 1.6
		blk.collision_layer = 0
	lv.interactable("case_gap", N["gap_prompt"], Vector3(x1 + 0.2, 1.0, (gap0 + gap1) / 2.0), Vector3(0.4, 1.8, 1.0), "", false)
	# Seth, by day, when he's the one they send (he met Carl in the park)
	if not lv.night and main.flags.has("park_done") and opened("nathan") and step("nathan") == "substation" and not main.flags.has("case_nathan_gate"):
		var seth := _fig(lv, Color(0.8, 0.95, 0.2), Color(0.86, 0.68, 0.55), {"hair": Color(0.32, 0.2, 0.12), "long_hair": true, "legs": Color(0.25, 0.25, 0.3)}, Vector3(-8.0, 0.12, z1 + 1.6), PI)
		lv.box(Vector3(0.45, 0.3, 0.25), Vector3(0.4, 0.15, 0.2), lv.mat(Color(0.9, 0.5, 0.1), 0.6), false, seth)
		lv.person("case_seth", N["seth_prompt"], seth, N["seth_scan"])
		_n["seth"] = seth


const EncountersS := preload("res://scripts/Encounters.gd")


## Red Rock: Tyson at the top of the subway stairs with his cart.
func _dress_red_rock(lv: Node) -> void:
	if not (opened("tyson") and window_ok("tyson", "choice")):
		return
	var T: Dictionary = LINES["tyson"]
	var ty := _fig(lv, Color(0.35, 0.28, 0.2), Color(0.55, 0.4, 0.3), {"hair": Color(0.3, 0.3, 0.3), "legs": Color(0.25, 0.22, 0.18)}, TYSON_AT, PI)
	lv.person("case_tyson", T["prompt"], ty, T["scan"])
	_n["tyson"] = ty
	var cp := TYSON_AT + Vector3(0.9, 0.0, -0.4)
	var wire: Material = lv.mat(Color(0.55, 0.56, 0.58), 0.4, 0.8)
	lv.box(Vector3(0.6, 0.04, 0.9), cp + Vector3(0, 0.35, 0), wire)
	for s: Vector2 in [Vector2(-0.28, -0.42), Vector2(0.28, -0.42), Vector2(-0.28, 0.42), Vector2(0.28, 0.42)]:
		lv.box(Vector3(0.03, 0.6, 0.03), cp + Vector3(s.x, 0.6, s.y), wire)
		lv.cyl(0.05, 0.05, 0.04, cp + Vector3(s.x, 0.05, s.y), lv.mat(Color(0.05, 0.05, 0.05), 0.8), 8).rotation.z = PI / 2.0
	var bags := [lv.mat(Color(0.25, 0.3, 0.2), 0.9), lv.mat(Color(0.35, 0.28, 0.2), 0.9), lv.mat(Color(0.2, 0.2, 0.25), 0.9)]
	for i in 4:
		lv.box(Vector3(0.4, 0.3, 0.3), cp + Vector3(0.0 if i % 2 == 0 else 0.05, 0.55 + i * 0.22, -0.2 + (i % 2) * 0.35), bags[i % 3])
	lv.box(Vector3(0.5, 0.35, 0.02), cp + Vector3(0, 1.2, 0.46), lv.mat(Color(0.6, 0.5, 0.36), 0.95))
	lv.interactable("case_cart", T["cart_prompt"], cp + Vector3(0, 0.7, 0), Vector3(0.8, 1.4, 1.1), "", false)
	lv.light(TYSON_AT + Vector3(0.4, 2.4, 1.2), Color(0.5, 0.75, 1.0), 0.9, 5.0, false)


## Every frame on a street: the swarm goes round, the singers sway.
func tick(lv: Node, delta: float) -> void:
	if _swarm_root and is_instance_valid(_swarm_root):
		_swarm_root.rotation.y += delta * 0.6
	var t: float = lv._t
	for key: String in ["singers", "mourners"]:
		if _n.has(key):
			for f in _n[key]:
				if is_instance_valid(f):
					(f as Node3D).rotation.z = sin(t * 0.9 + (f as Node3D).position.z) * 0.03


func scan_people(lv: Node) -> Array:
	var out := []
	if _n.has("mourners"):
		for f in _n["mourners"]:
			if is_instance_valid(f) and not (f as Node3D).has_meta("scanned"):
				out.append([f, LINES["vigil"]["mourner_scan"] % "?"])
	return out


# ------------------------------------------------------------------ E on a case thing (Street.interact)

func interact(lv: Node, node: Object) -> bool:
	var id := str(node.get_meta("id"))
	match id:
		"case_charger":
			await _charger(false, node)
		"case_forner_door":
			await _forner_door()
		"case_forner":
			await _forner_vigil()
		"case_forner_car":
			await _think(LINES["forner"]["car"])
		"case_mourner0", "case_mourner1", "case_mourner2":
			await _mourner(int(id.substr(id.length() - 1)))
		"case_screens":
			await _screens()
		"case_preacher":
			await _preacher()
		"case_swarm":
			await _swarm()
		"case_gate", "case_reader":
			await _gate()
		"case_gap":
			await _think(LINES["nathan"]["gap"])
		"case_seth":
			await _seth()
		"case_log":
			await _log()
		"case_agata":
			await _agata()
		"case_addison":
			await _addison()
		"case_drawing":
			await _drawing()
		"case_annie":
			await _annie()
		"case_singer0", "case_singer1", "case_singer2":
			await _singer(int(id.substr(id.length() - 1)))
		"case_tyson":
			await _tyson()
		"case_cart":
			await _think(LINES["tyson"]["cart"])
		_:
			return false
	main.ui.close()
	main.update_hud()
	return true


## The quick-hack on a case device (Street.on_hack): true when handled here.
func on_hack(lv: Node, node: Object, word: String) -> bool:
	var id := str(node.get_meta("id", ""))
	match id:
		"case_charger":
			if opened("forner") and step("forner") == "charger":
				main.hack.charge(node, word)
				await _charger(true, node)
				return true
		"case_gate":
			if word == "dreamer" and not main.flags.has("case_nathan_gate"):
				_gate_opened("hack", false)
		"case_reader":
			if word == "we" and not main.flags.has("case_nathan_gate"):
				_gate_opened("hack", false)
	return false


# ------------------------------------------------------------------ Forner

func _forner_door() -> void:
	var F: Dictionary = LINES["forner"]
	if not (opened("forner") or ending("forner") != ""):
		await _think(F["door_shut"])
		return
	await _think(F["enter"] if not done("forner", "flat") else F["enter_again"])
	main.ui.close()
	_mark("forner", "flat")
	back = {"district": "lamplight", "pos": Vector3(10.6, 0.1, DOOR.z), "yaw": 90.0}
	main.load_level("FornerFlat")


## Leaving the flat: back out onto Lamplight by his door.
func leave_flat() -> void:
	city.district = "lamplight"
	back = {"district": "lamplight", "pos": Vector3(10.6, 0.1, DOOR.z), "yaw": 90.0}
	main.load_level("Street")


## The pillow: his frames, the tablet, CHEYENNE (FornerFlat calls this).
func forner_psyon() -> void:
	var F: Dictionary = LINES["forner"]
	if done("forner", "psyon"):
		await _think(F["pillow_done"])
		main.ui.close()
		return
	await _think(F["pillow"])
	await _say("", F["pillow_say"])
	await _think(F["pillow_think"])
	var pick: int = await _choose(F["pillow_opts"], "forner_pillow")
	main.ui.close()
	if pick == 1:
		await _think(F["pillow_leave"])
		main.ui.close()
		return
	var ok: bool = await _interface("forner_psyon", F["psyon_q"], F["psyon_opts"], 2, F["psyon_right"])
	if not ok:
		return
	for l: String in F["cheyenne"]:
		await _say("Cheyenne", l)
	await _think(F["psyon_after"])
	main.ui.close()
	_mark("forner", "psyon")
	main.log_line("evidence", F["psyon_log"])
	clue("ritual", "cheyenne", F["psyon_clue"])


## The charge post on the Spine: the interface, a badge pull, or the hack.
func _charger(hacked: bool, node: Object) -> void:
	var F: Dictionary = LINES["forner"]
	if done("forner", "charger"):
		await _think(F["post_done"])
		return
	if not (opened("forner") and step("forner") == "charger"):
		await _think(F["post_idle"])
		return
	if hacked:
		await _think(F["post_hack"])
	else:
		await _think(F["post"])
		var pick: int = await _choose(F["post_opts"], "forner_post")
		main.ui.close()
		match pick:
			0:
				if not await _interface("forner_post_q", F["post_q"], F["post_q_opts"], 2, F["post_right"]):
					return
			1:
				await _think(F["post_badge"])
				main.add_pressure(2.0, F["post_badge_why"])
				main.add_stance("company_man")
			_:
				return
	await _think(F["post_log"])
	main.ui.close()
	_mark("forner", "charger")
	main.log_line("evidence", F["post_log_line"])


## Fargona, at night: Forner by his car, and the choice.
func _forner_vigil() -> void:
	var F: Dictionary = LINES["forner"]
	if not (opened("forner") and step("forner") in ["vigil", "choice"] and city.is_night()):
		await _think(F["him_idle"])
		return
	var fo: Node3D = _n.get("forner")
	if fo and is_instance_valid(fo):
		_lv.turn_to(fo, main.player.global_position, 0.5)
		_head_up(fo, 0.0)
	await _think(F["found"])
	for l: String in F["plea"]:
		await _say("Forner", l)
	_mark("forner", "vigil")
	var pick: int = await _choose(F["opts"], "forner_choice")
	var out: String = ["report", "cover", "walk"][clampi(pick, 0, 2)]
	match out:
		"report":
			await _think(F["report"])
			await _say("Turan", F["report_turan"])
			main.add_trust("turan", 1)
			main.add_pressure(-3.0, F["why"]["report"])
			main.add_stance("company_man")
			main.flags["forner_reported"] = true
		"cover":
			await _say("Carl", F["cover_carl"])
			await _say("Forner", F["cover_him"])
			await _say("Turan", F["cover_turan"])
			await _say("Carl", F["cover_carl2"])
			await _think(F["cover_think"])
			main.add_trust("turan", -1)
			main.add_trust("emmet", 1)
			main.add_pressure(2.0, F["why"]["cover"])
			main.add_connection(2.0, F["why"]["cover"])
			main.add_stance("sleeper")
			main.flags["forner_covered"] = true
		"walk":
			await _say("Carl", F["walk_carl"])
			await _think(F["walk"])
			main.add_connection(3.0, F["why"]["walk"])
			main.add_trust("turan", 1)
			main.add_stance("investigator")
			main.flags["forner_walked"] = true
			city.advance(1)
	main.ui.close()
	main.flags["forner_case_ending"] = out
	_end("forner", out, F["outcomes"][out])
	if fo and is_instance_valid(fo) and out != "cover":
		fo.visible = false
		var b := _node(_lv, "case_forner")
		if b:
			_lv.set_active(b as CollisionObject3D, false)


# ------------------------------------------------------------------ the digital vigil

func _mourner(i: int) -> void:
	var V: Dictionary = LINES["vigil"]
	if not main.frames_on:
		await _think(V["mourner_frames_off"])
		return
	var k := "case_vigil_m%d" % i
	if main.flags.has(k) or not (opened("vigil") and step("vigil") == "mourners"):
		await _think(V["mourner_again"])
		return
	main.flags[k] = true
	await _think(V["mourner"][i])
	main.add_connection(1.0, "the vigil")
	var n := 0
	for j in 3:
		if main.flags.has("case_vigil_m%d" % j):
			n += 1
	if n >= 3:
		await _think(V["mourners_done"])
		main.ui.close()
		_mark("vigil", "mourners")
		main.log_line("evidence", V["mourners_line"])


func _screens() -> void:
	var V: Dictionary = LINES["vigil"]
	if not (opened("vigil") and step("vigil") == "screens" and city.is_night()):
		await _think(V["screens_idle"])
		return
	await _think(V["screens"])
	main.ui.close()
	var ok: bool = await _interface("vigil_screens", V["screens_q"], V["screens_opts"], 1, V["screens_right"])
	if ok:
		_mark("vigil", "screens")
		main.log_line("evidence", V["screens_line"])
	else:
		await _think(V["screens_retry"])


func _preacher() -> void:
	var V: Dictionary = LINES["vigil"]
	var st := step("vigil")
	if ending("vigil") != "" or (opened("vigil") and st == "choice"):
		if opened("vigil") and st == "choice":
			await _vigil_choice()
		else:
			await _say("", V["preacher_idle"])
		return
	if not (opened("vigil") and st == "preacher"):
		await _think(V["preacher_wait"])
		return
	var pr: Node3D = _n.get("preacher")
	var res := ""
	if _n.has("night_preacher"):
		# the night layer's confrontation (Night.gd / Confront.gd): read its result,
		# or start it now; a Run or a touch sends Carl back down the street
		res = str(main.flags.get("preacher_d%d" % int(main.day), ""))
		if res == "":
			res = str(await _lv.night_layer.trigger("preacher"))
			if res in ["", "ran", "touched"] or not is_instance_valid(_lv) or _lv != main.level:
				return
	else:
		if pr and is_instance_valid(pr):
			_lv.turn_to(pr, main.player.global_position, 0.5)
		res = await _confront(pr)
	main.log_line("encounter", V["preacher_log"] % res)
	await _say("", V["talk"][0])
	await _say("Carl", V["talk_carl"])
	await _say("", V["talk"][1])
	await _say("", V["talk"][2])
	var pick: int = await _choose(V["bag_opts"], "vigil_bag")
	match pick:
		0:
			for l: String in V["give"]:
				await _say("", l)
			main.flags["gave_frames"] = true
			main.add_connection(5.0, V["why"]["gave"])
			main.add_stance("sleeper")
			main.log_line("evidence", V["give_line"])
		1:
			await _think(V["take"])
			main.flags["took_bag"] = true
			main.flags["ev_dead_frames"] = true
			main.add_pressure(3.0, V["why"]["bag"])
			main.add_trust("lynx", 1)
			main.add_stance("investigator")
			main.log_line("evidence", V["take_line"])
		_:
			await _think(V["walk"])
	main.ui.close()
	_mark("vigil", "preacher")
	await _vigil_choice()


## The preacher is a confrontation (bible-1: Look / Speak / Run, three
## rounds). If the shared confrontation screen exists (main.confront), it
## runs there; otherwise a plain version here with the same rules.
func _confront(pr: Node3D) -> String:
	var cf = main.get("confront")
	if cf != null and is_instance_valid(cf) and cf.has_method("run"):
		var picks: Array = test_picks.get("vigil_confront_picks", [])
		return await cf.run(main, "preacher", pr, picks)
	var C: Dictionary = LINES["vigil"]["confront"]
	await _think(C["intro"])
	var closer := 0
	for r in 3:
		var v: int = await _choose(C["verbs"], "vigil_confront%d" % r)
		match v:
			0:
				if main.frames_on:
					await _think(C["look_on"])
					main.add_connection(1.0, "seen")
					if main.connection < 50.0:
						return "seen"
				else:
					await _think(C["look_off"])
				closer += 1
			1:
				var words := []
				for w: String in ["mimic", "we", "the path", "sleeper", "hush", "convene"]:
					if main.lexicon.has(w) and words.size() < 3:
						words.append(w)
				words.append("bow")
				var j: int = await _choose(words, "vigil_speak%d" % r)
				var w: String = words[clampi(j, 0, words.size() - 1)]
				if w == "bow":
					await _think(C["bow"])
					main.add_connection(3.0, "bowed")
					city.add_devotion(1, "bowed")
					main.add_stance("sleeper")
					return "bowed"
				if w in ["mimic", "we", "the path"]:
					await _think(C["speak_known"])
					return "held"
				await _think(C["speak_unknown"])
				closer += 1
			_:
				await _think(C["run"])
				main.add_connection(1.0, "ran")
				return "ran"
		if closer >= 2:
			await _think(C["touched"])
			main.ui.flash(0.4)
			main.add_connection(5.0, "touched")
			return "touched"
		await _think(C["closer"])
	return "outlasted"


func _vigil_choice() -> void:
	var V: Dictionary = LINES["vigil"]
	await _think(V["ask"])
	var pick: int = await _choose(V["opts"], "vigil_choice")
	var out: String = ["reported", "ran", "joined"][clampi(pick, 0, 2)]
	match out:
		"reported":
			await _say("Turan", V["report_turan"])
			await _think(V["report"])
			main.add_trust("turan", 1)
			main.add_pressure(-4.0, V["why"]["reported"])
			main.add_stance("company_man")
			city.add_faith("fargona", -1, "cleared")
		"ran":
			await _think(V["ran"])
			main.add_pressure(2.0, V["why"]["ran"])
			main.add_connection(2.0, V["why"]["ran"])
			main.add_stance("investigator")
		"joined":
			await _think(V["joined"])
			await _say("", V["joined_say"])
			main.add_connection(6.0, V["why"]["joined"])
			city.add_devotion(1, V["why"]["joined"])
			main.add_stance("sleeper")
			main.flags["bowed_today"] = true
			city.add_faith("fargona", 1, "joined")
	main.ui.close()
	_end("vigil", out, V["outcomes"][out])
	clue("ritual", "vigil", V["outcomes"][out])


# ------------------------------------------------------------------ Nathan

## The gate: the four ways in as a plain choice at the perimeter.
func _gate() -> void:
	var N: Dictionary = LINES["nathan"]
	if main.flags.has("case_nathan_gate"):
		await _think(N["gate_open"])
		return
	await _think(N["gate"])
	var R: Dictionary = N["routes"]
	var keys := ["badge", "hack", "sneak"]
	if _n.has("seth"):
		keys.append("person")
	keys.append("leave")
	var opts := []
	for k: String in keys:
		opts.append(R[k])
	var pick: int = await _choose(opts, "nathan_route")
	main.ui.close()
	var k: String = keys[clampi(pick, 0, keys.size() - 1)]
	match k:
		"badge":
			await _think(N["badge"])
			main.add_pressure(2.0, N["badge_why"])
			main.log_line("badge", N["badge_why"] + ": Alto substation 14")
			_gate_opened("badge", true)
		"hack":
			if not main.hack.unlocked():
				await _think(N["hack_locked"])
				return
			await _think(N["hack"])
			main.add_connection(2.0, N["hack_why"])
			if main.recording:
				main.add_pressure(3.0, "hacked company property on the record")
			_gate_opened("hack", true)
		"sneak":
			await _think(N["sneak"])
			main.flags["case_nathan_route"] = "sneak"
			city.advance(1)
		"person":
			await _seth()
	main.ui.close()


func _seth() -> void:
	var N: Dictionary = LINES["nathan"]
	if main.flags.has("case_nathan_gate"):
		await _think(N["seth_idle"])
		return
	await _say("Seth", N["seth"])
	await _say("Seth", N["seth_2"])
	main.ui.close()
	_gate_opened("person", true)


func _gate_opened(route: String, swing: bool) -> void:
	main.flags["case_nathan_gate"] = true
	main.flags["case_nathan_route"] = route
	main.log_line("route", "Alto substation 14: in by " + route)
	if swing and _n.has("gate_h") and is_instance_valid(_n["gate_h"]):
		var gh: Node3D = _n["gate_h"]
		main.play("door", -6.0, 0.9)
		gh.create_tween().tween_property(gh, "rotation:y", 1.6, 1.0).set_trans(Tween.TRANS_SINE)
		(_n["gate_blk"] as CollisionObject3D).collision_layer = 0


func _log() -> void:
	var N: Dictionary = LINES["nathan"]
	if done("nathan", "substation"):
		await _think(N["log_done"])
		return
	if not opened("nathan"):
		await _think(N["log_idle"])
		return
	await _think(N["log"])
	if not main.frames_on:
		await _think(N["log_no_frames"])
		return
	main.ui.flash(0.3)
	await _say("", N["log_entry"])
	await _think(N["log_think"])
	await _think(N["log_think_2"])
	main.ui.close()
	if not main.flags.has("case_nathan_route"):
		main.flags["case_nathan_route"] = "sneak"
	_mark("nathan", "substation")
	main.add_connection(2.0, "the swarm log")
	main.log_line("evidence", N["log_line"])


func _swarm() -> void:
	var N: Dictionary = LINES["nathan"]
	if not (opened("nathan") and step("nathan") in ["swarm", "choice"]):
		await _think(N["swarm_idle"])
		return
	if step("nathan") == "swarm":
		if not main.frames_on:
			await _think(N["swarm_no_frames"])
			return
		await _think(N["swarm"])
		var pick: int = await _choose(N["frames"], "nathan_frame")
		if pick != 4:
			await _think(N["wrong_frame"])
			return
		main.ui.flash(0.3)
		await _think(N["found"])
		main.ui.close()
		_mark("nathan", "swarm")
		main.add_connection(3.0, "the swarm's route")
		main.log_line("evidence", N["found_line"])
		clue("tantrums", "swarm", N["clue"])
	await _think(N["ask"])
	var c: int = await _choose(N["opts"], "nathan_choice")
	var out: String = ["told", "filed", "kept"][clampi(c, 0, 2)]
	match out:
		"told":
			await _think(N["told"])
			await _say("Lynx", N["told_lynx"][0])
			await _say("Carl", N["told_carl"])
			await _say("Lynx", N["told_lynx"][1])
			await _say("Lynx", N["told_lynx"][2])
			await _think(N["told_after"])
			main.add_trust("lynx", 1)
			main.add_connection(1.0, N["why"]["told"])
			main.add_stance("investigator")
			main.flags["told_lynx_nathan"] = true
		"filed":
			for l: String in N["filed_turan"]:
				await _say("Turan", l)
			main.add_trust("turan", 1)
			main.add_pressure(-4.0, N["why"]["filed"])
			main.add_stance("company_man")
			main.flags["filed_nathan"] = true
		"kept":
			await _think(N["kept"])
			main.flags["kept_nathan"] = true
	main.ui.close()
	_end("nathan", out, N["outcomes"][out])


# ------------------------------------------------------------------ Agata (Day 5)

func _agata() -> void:
	var A: Dictionary = LINES["agata"]
	if ending("agata") != "":
		await _think(A["done"])
		return
	if not available("agata"):
		await _think(A["cold"])
		return
	if not done("agata", "talk"):
		await _say("Agata", A["hello"])
		for l: String in A["ask"]:
			await _say("Agata", l)
		main.ui.close()
		_mark("agata", "talk")
		main.log_line("testimony", "Agata Greenwood: her son Addison plays the Password Game; she asks me to make it stop.")
	if not done("agata", "drawing"):
		await _drawing()
	var pick: int = await _choose(A["opts"], "agata_choice")
	var out: String = ["interface", "smash", "truth"][clampi(pick, 0, 2)]
	match out:
		"interface":
			if not await _interface("agata_iface", A["iface_q"], A["iface_opts"], 1, A["iface_right"]):
				return
			await _think(A["iface"])
			await _say("Agata", A["iface_agata"])
			main.add_trust("agata", -1)
		"smash":
			await _think(A["smash"])
			await _say("Agata", A["smash_agata"])
			main.add_pressure(5.0, A["smash_why"])
			main.add_trust("agata", 1)
			main.add_stance("investigator")
			main.flags["smash_used"] = true
			main.flags["tablet_smashed"] = true
		"truth":
			await _say("Carl", A["truth_carl"])
			await _say("Agata", A["truth_agata"])
			await _say("Carl", A["truth_carl2"])
			await _think(A["truth_after"])
			main.add_trust("agata", 1)
			main.add_connection(2.0, A["truth_why"])
			main.add_stance("investigator")
	main.ui.close()
	_end("agata", out, A["outcomes"][out])


func _addison() -> void:
	var A: Dictionary = LINES["agata"]
	if main.flags.has("case_agata_son"):
		await _think(A["son_again"])
		return
	main.flags["case_agata_son"] = true
	await _think(A["son"])
	await _say("Addison", A["son_say"])
	await _think(A["son_think"])
	main.add_connection(1.0, "the Password Game")


func _drawing() -> void:
	var A: Dictionary = LINES["agata"]
	if done("agata", "drawing"):
		await _think(A["drawing_again"])
		return
	await _think(A["drawing"])
	await _think(A["drawing_2"])
	main.ui.close()
	main.flags[_key("agata", "talk")] = true
	_mark("agata", "drawing")
	main.log_line("evidence", A["drawing_line"])
	clue("ritual", "addison_drawing", A["clue"])


# ------------------------------------------------------------------ Annie Seung (the Spine vigil)

func _annie() -> void:
	var A: Dictionary = LINES["annie"]
	if ending("annie") != "" or not opened("annie"):
		await _say("Annie", A["done"])
		return
	match step("annie"):
		"ask":
			await _say("Annie", A["hello"])
			await _say("Carl", A["ask_carl"])
			await _say("Annie", A["ask_annie"])
			await _say("Annie", A["ask_annie_2"])
			main.ui.close()
			_mark("annie", "ask")
			main.log_line("testimony", "Annie Seung: the hymn came as a push on Psyon before the blackout. Everybody got the same one.")
		"singers":
			await _say("Annie", A["ask_annie_2"])
		"push":
			await _say("Annie", A["push_annie"])
			await _think(A["push"])
			main.ui.close()
			_mark("annie", "push")
			main.log_line("evidence", A["push_line"])
		"sender":
			await _think(A["push_again"])
			if not main.frames_on:
				await _think(A["sender_no_frames"])
				return
			await _think(A["sender_q"])
			main.ui.glitch(0.5, 0.6)
			await _think(A["sender"])
			main.ui.close()
			main.log_line("evidence", A["sender_line"])
			clue("children", "kidtok", A["clue"])
			var pick: int = await _choose(A["opts"], "annie_choice")
			var out := "told" if pick == 0 else "quiet"
			if out == "told":
				await _say("Carl", A["tell_carl"])
				await _say("Annie", A["tell_annie"])
				main.add_connection(2.0, A["why_truth"])
			else:
				await _think(A["quiet"])
			main.ui.close()
			_end("annie", out, A["outcomes"][out])


func _singer(i: int) -> void:
	var A: Dictionary = LINES["annie"]
	var k := "case_annie_s%d" % i
	if main.flags.has(k) or not (opened("annie") and step("annie") == "singers"):
		await _think(A["singer_again"])
		return
	main.flags[k] = true
	await _think(A["singers"][i])
	var n := 0
	for j in 3:
		if main.flags.has("case_annie_s%d" % j):
			n += 1
	if n >= 3:
		await _think(A["singers_done"])
		main.ui.close()
		_mark("annie", "singers")
		main.log_line("evidence", A["singers_line"])


# ------------------------------------------------------------------ Tyson's exit

func _tyson() -> void:
	var T: Dictionary = LINES["tyson"]
	var e := ending("tyson")
	if e != "":
		await _think(T["done"].get(e, T["done"]["left"]))
		return
	if not available("tyson"):
		await _think(T["done"]["left"])
		return
	var ty: Node3D = _n.get("tyson")
	if ty and is_instance_valid(ty):
		_lv.turn_to(ty, main.player.global_position, 0.5)
	await _think(T["see"])
	for l: String in T["say"]:
		await _say("Tyson", l)
	var pick: int = await _choose(T["opts"], "tyson_choice")
	var out := ""
	match pick:
		0:
			await _say("Carl", T["car_carl"])
			await _think(T["car"])
			for l: String in T["car_tyson"]:
				await _say("Tyson", l)
			main.add_pressure(5.0, T["car_why"])
			main.add_trust("tyson", 2)
			main.flags["tyson_returns"] = true
			main.flags["tyson_left"] = true
			out = "car"
		1:
			await _say("Carl", T["stay_carl"])
			if int(main.trust.get("tyson", 0)) >= 1:
				await _say("Tyson", T["stay_yes"])
				main.add_trust("tyson", 1)
				out = "stayed"
			else:
				await _say("Tyson", T["stay_no"])
				await _think(T["stay_no_after"])
				main.flags["tyson_left"] = true
				main.flags["burn_closed"] = true
				out = "left"
		_:
			await _think(T["god"])
			await _think(T["god_after"])
			main.ui.close()
			await city.terminal.give("tyson")
			out = "given"
	main.ui.close()
	main.flags["tyson_exit"] = out
	_end("tyson", out, T["outcomes"][out])
	if out != "stayed" and ty and is_instance_valid(ty):
		ty.visible = false
		var b := _node(_lv, "case_tyson")
		if b:
			_lv.set_active(b as CollisionObject3D, false)


# ------------------------------------------------------------------ the cases test (--cases=1)

func _ok(name: String, cond: bool, info := "") -> void:
	if cond:
		print("CASES ok ", name, "  ", info)
	else:
		_fails += 1
		print("CASES FAIL ", name, "  ", info)


func _reset(cid: String) -> void:
	for k in main.flags.keys():
		if str(k).begins_with("case_%s_" % cid):
			main.flags.erase(k)


func _street(d: String, day: int, hour: int) -> bool:
	main.day = day
	main.hour = hour
	city.district = d
	main.load_level("Street")
	return await city._await_level("Street", 90.0)


func _press(id: String) -> bool:
	var n := _node(main.level, id)
	if n == null:
		print("CASES missing ", id)
		_fails += 1
		return false
	await main.interact(n)
	return true


func _walk(label: String, id: String, from = null, bounds := Rect2(-14.0, -112.0, 28.0, 172.0)) -> bool:
	return await main.level.check_walk(label, id, from, bounds)


## Every case to every choice, and a walk to every place (check_walk).
func selftest() -> void:
	Engine.time_scale = 4.0
	var watchdog := get_tree().create_timer(2400.0, true, false, true)
	watchdog.timeout.connect(func():
		print("CASES TIMEOUT watchdog")
		get_tree().quit(1))
	var ui = main.ui
	var pump := func() -> void:
		while main._selftest:
			await get_tree().process_frame
			ui.advanced.emit()
			ui.picked.emit(1)
	pump.call()
	for fl in ["opening_seen", "scene1_done", "park_done", "agata_done", "tyson_done", "home1_done", "warroom1_done", "hospital_done",
			"southtown_done", "home2_done", "ritual_seen", "warroom2_done", "lynx_apartment_done", "desert_done", "mirror_done", "act1_done",
			"facility_done", "hangar_done", "home3_done", "blackout_done", "observatory_done", "watched_observatory", "freudbot_1",
			"holdingcell_done", "told_agata_truth"]:
		main.flags[fl] = true
	main.connection = 30.0
	main.frames_on = true
	for w in ["hush", "look away", "convene", "sleeper", "we"]:
		main.learn(w)
	main.recording = false
	main.day = 3
	main.hour = 25
	await city.day_card(4, "")
	_ok("day card: a case step", "CASE" in city.day_card_text(), city.day_card_text().replace("\n", " | "))
	_ok("cases open on Day 4", opened("forner") and opened("nathan") and opened("vigil") and opened("annie") and opened("tyson") and not opened("agata"), str(state()))
	_ok("notices in the feed", main.flags.has("case_forner_notice"), "")
	# ---- Forner: the door, the flat, the Psyon, the post, the vigil x3
	_ok("lamplight street", await _street("lamplight", 4, 12))
	print("CASES objective lamplight: ", city.objective())
	_ok("objective names the flat", "Forner" in city.objective(), city.objective())
	await _walk("lamplight: Forner's door", "case_forner_door")
	await _press("case_forner_door")
	_ok("into the flat", await city._await_level("FornerFlat", 90.0) and done("forner", "flat"), main.level_name)
	for id in ["pillow", "photo", "computer", "chair", "flat_exit"]:
		await main.level.check_walk("forner flat: " + id, id)
	test_picks = {"forner_pillow": 0, "forner_psyon": 2}
	await _press("pillow")
	_ok("forner: psyon", done("forner", "psyon") and main.flags.has("clue_ritual_cheyenne"), "conn %d" % int(main.connection))
	await main.level.selftest_items()
	await _press("flat_exit")
	_ok("back on Lamplight by the door", await city._await_level("Street", 90.0) and city.district == "lamplight" and main.player.position.distance_to(Vector3(10.6, 0.1, DOOR.z)) < 2.0,
		str(main.player.position))
	_ok("spine street", await _street("spine", 4, 13))
	await _walk("spine: the charge post", "case_charger")
	test_picks = {"forner_post": 1}
	var p0: float = main.pressure
	await _press("case_charger")
	_ok("forner: charger (badge)", done("forner", "charger") and main.pressure > p0, "pressure %d" % int(main.pressure))
	main.flags.erase("case_forner_charger")
	await on_hack(main.level, _node(main.level, "case_charger"), "hush")
	_ok("forner: charger (quick-hack)", done("forner", "charger"))
	main.flags.erase("case_forner_charger")
	test_picks = {"forner_post": 0, "forner_post_q": 2}
	await _press("case_charger")
	_ok("forner: charger (interface)", done("forner", "charger"))
	_ok("fargona street, night", await _street("fargona", 4, 22))
	await _walk("fargona: Forner at the vigil", "case_forner")
	await _walk("fargona: the mourners", "case_mourner2")
	await _walk("fargona: the screens", "case_screens")
	await _walk("fargona: the preacher", "case_preacher")
	var ends := ["report", "cover", "walk"]
	for i in 3:
		_reset("forner")
		for s in ["flat", "psyon", "charger"]:
			main.flags[_key("forner", s)] = true
		main.flags.erase("forner_case_ending")
		test_picks = {"forner_choice": i}
		await _press("case_forner")
		_ok("forner: ending " + ends[i], ending("forner") == ends[i] and str(main.flags.get("forner_case_ending", "")) == ends[i], str(main.flags.get("forner_case_ending", "")))
	# ---- the digital vigil (same street)
	for i in 3:
		await _press("case_mourner%d" % i)
	_ok("vigil: mourners", done("vigil", "mourners"))
	test_picks = {"vigil_screens": 1}
	await _press("case_screens")
	_ok("vigil: screens", done("vigil", "screens"))
	var vends := ["reported", "ran", "joined"]
	_ok("vigil: one preacher (the night layer's when there is one)", _node(main.level, "case_preacher") != null and ((_node(main.level, "night_preacher") != null) == _n.has("night_preacher")), str(_n.has("night_preacher")))
	# the night layer's confrontation has run (Night.gd sets preacher_d<day>)
	main.flags["preacher_d%d" % int(main.day)] = "held"
	for i in 3:
		for k in ["case_vigil_preacher", "case_vigil_choice", "case_vigil_ending"]:
			main.flags.erase(k)
		test_picks = {"vigil_confront0": 0, "vigil_confront_picks": [["look"]], "vigil_bag": i, "vigil_choice": i}
		await _press("case_preacher")
		_ok("vigil: ending " + vends[i], ending("vigil") == vends[i], ending("vigil"))
	_ok("vigil: bag / frames", main.flags.has("gave_frames") and main.flags.has("took_bag"))
	# ---- Nathan: the yard (the four ways in), the log, the swarm, the choice x3
	_ok("rail cut street", await _street("rail_cut", 4, 14))
	var in_yard := Vector3(-10.2, 0.1, -66.4)
	var yard := Rect2(-13.3, -91.0, 5.55, 26.5)
	_ok("rail cut: the gate holds", not await main.level.check_walk("rail cut: the log through the shut gate (expect false)", "case_log", in_yard, yard), "")
	await _walk("rail cut: the gate", "case_gate")
	await _walk("rail cut: the reader", "case_reader")
	await _walk("rail cut: the gap", "case_gap")
	await _walk("rail cut: the log by the gap", "case_log")
	await _walk("rail cut: Seth", "case_seth")
	var routes := {"badge": 0, "hack": 1, "person": 3}
	for r: String in routes:
		main.flags.erase("case_nathan_gate")
		main.flags.erase("case_nathan_route")
		(_n["gate_blk"] as CollisionObject3D).collision_layer = 1
		test_picks = {"nathan_route": routes[r]}
		await _press("case_gate")
		_ok("nathan: in by " + r, main.flags.has("case_nathan_gate") and str(main.flags.get("case_nathan_route", "")) == r, str(main.flags.get("case_nathan_route", "")))
	_ok("rail cut: the gate opens", await main.level.check_walk("rail cut: the log through the open gate", "case_log", in_yard, yard))
	main.flags.erase("case_nathan_gate")
	await on_hack(main.level, _node(main.level, "case_reader"), "we")
	_ok("nathan: the reader takes 'we'", main.flags.has("case_nathan_gate"))
	await _press("case_log")
	_ok("nathan: substation log", done("nathan", "substation"))
	_ok("heights street", await _street("heights", 4, 15))
	await _walk("heights: the swarm", "case_swarm")
	var nends := ["told", "filed", "kept"]
	for i in 3:
		for k in ["case_nathan_swarm", "case_nathan_choice", "case_nathan_ending"]:
			main.flags.erase(k)
		test_picks = {"nathan_frame": 4, "nathan_choice": i}
		await _press("case_swarm")
		_ok("nathan: ending " + nends[i], ending("nathan") == nends[i] and main.flags.has("clue_tantrums_swarm"), ending("nathan"))
	# ---- Agata: Day 5, the Heights 15-17
	_ok("agata opens on Day 5", await _street("heights", 5, 15) and opened("agata"), str(state()["agata"]))
	await _walk("heights: Agata", "case_agata")
	await _walk("heights: Addison", "case_addison")
	await _walk("heights: the drawing", "case_drawing")
	await _press("case_addison")
	await _press("case_drawing")
	_ok("agata: the drawing is a clue", done("agata", "drawing") and main.flags.has("clue_ritual_addison_drawing"), str(clues("ritual")))
	var aends := ["interface", "smash", "truth"]
	for i in 3:
		main.flags.erase("case_agata_choice")
		main.flags.erase("case_agata_ending")
		var t0 := int(main.trust.get("agata", 0))
		test_picks = {"agata_choice": i, "agata_iface": 1}
		main.hour = 15
		await _press("case_agata")
		_ok("agata: ending " + aends[i], ending("agata") == aends[i] and int(main.trust["agata"]) != t0, "trust %d" % int(main.trust["agata"]))
	_ok("agata: smash_used for Red Rock", main.flags.has("smash_used"))
	# ---- Annie: the Spine vigil at night
	_ok("spine street, night", await _street("spine", 4, 22))
	await _walk("spine: Annie", "case_annie")
	await _walk("spine: a singer", "case_singer0")
	await _press("case_annie")
	for i in 3:
		await _press("case_singer%d" % i)
	await _press("case_annie")
	test_picks = {"annie_choice": 0}
	await _press("case_annie")
	_ok("annie: the sender is Mira", ending("annie") == "told" and main.flags.has("clue_children_kidtok"), str(state()["annie"]))
	main.flags.erase("case_annie_ending")
	main.flags.erase("case_annie_sender")
	test_picks = {"annie_choice": 1}
	await _press("case_annie")
	_ok("annie: say nothing", ending("annie") == "quiet")
	# ---- Tyson: Day 5, the Red Rock subway
	_ok("red rock street", await _street("red_rock", 5, 10))
	await _walk("red rock: Tyson", "case_tyson")
	await _walk("red rock: the cart", "case_cart")
	var tcase := [[0, 0, "car"], [1, 1, "stayed"], [1, 0, "left"], [2, 0, "given"]]
	for c: Array in tcase:
		_reset("tyson")
		main.flags.erase("burn_closed")
		main.flags.erase("tyson_exit")
		main.given.erase("tyson")
		main.trust["tyson"] = int(c[1])
		var b := _node(main.level, "case_tyson")
		if b:
			main.level.set_active(b as CollisionObject3D, true)
		test_picks = {"tyson_choice": int(c[0])}
		await _press("case_tyson")
		var closed: bool = main.flags.has("burn_closed") or main.given.has("tyson")
		_ok("tyson: " + str(c[2]), str(main.flags.get("tyson_exit", "")) == str(c[2]) and closed == (str(c[2]) in ["left", "given"]),
			"exit %s burn_closed %s given %s" % [main.flags.get("tyson_exit", ""), main.flags.has("burn_closed"), main.given])
	# ---- the board, the phone, the map
	_ok("claims", clues("ritual").size() >= 3 and clues("children").size() == 1 and clues("tantrums").size() == 1, str([clues("ritual"), clues("children"), clues("tantrums")]))
	print("CASES phone: ", phone_text().replace("\n", " | "))
	print("CASES state: ", state())
	test_picks = {}
	print("CASES DONE fails=", _fails, " conn=", int(main.connection), " pressure=", int(main.pressure), " trust=", main.trust,
		" forner=", main.flags.get("forner_case_ending", ""), " tyson=", main.flags.get("tyson_exit", ""), " given=", main.given)
	main._selftest = false
	get_tree().quit()
