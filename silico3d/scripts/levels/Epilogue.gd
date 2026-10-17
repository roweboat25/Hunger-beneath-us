extends "res://scripts/Level.gd"
## Epilogue: Ezra, twenty-five years later (bible "Epilogue" and "Credits";
## the book ends on the one line, "Epilogue / 25 years later..."). Playable
## in third person: Ezra at 33, Carl's build, his curls, a shoulder camera
## behind him; Carl (the Player) is only the capsule that walks and the ray
## that looks. One variant per ending flag, read from Main:
##
##   ending_sit (and the default when no ending flag is set): the city with
##     no outages, clean and lit; the Tower lift, whose voice is Carl's,
##     slowed and pitched down (Ezra does not react); the floor with no
##     number, where a chair faces a wall of light and Ezra tells it about
##     his day; it keeps SalTech lit; Red Rock dark (the book's release) or
##     lit (sit_held / redrock_lit, if Chair records the ten-second hold);
##     86D, an older Monica (eyeless, since the chapel) and Paul, who is not
##     Carl and wears his coat.
##   ending_copy: the Sit epilogue, but the man at home is Carl and Ezra
##     calls him Dad; it is the wall Ezra no longer knows (A3-E4).
##   ending_burn: the city run by hand (fuses, ladders, sodium lamps, no
##     screens), the dead Tower lobby turned into the Hall, the same lift
##     with the same voice down to Rail Cut, the depot mouth where Tyson
##     waited (A3-E2), and the town outside the walls with the hand-painted
##     sign; Ezra fixes the generator; old Tyson on his porch; a letter from
##     no one.
##   ending_refuse: Ezra in a Psyonic jacket, Human-AI Integrations
##     Investigator, Dad's department, at a scene that is chapter 1 again
##     (the sticks on the ceiling, two white spheres in the carpet, the
##     Ionware laptop: "Welcome, dreamer."); the ORA card reads his name; he
##     writes the report (Spin: the four framings, the bar already full).
##
## Each ends on the same caption, "25 years later...", shown after the
## scene; then the credits over the hymn sung by one voice, in tune for the
## first time (bible-5 Audio: synthesised here as a single formant voice
## until ian records it), the twelve lines on screen, the content note and
## the AI-disclosure line; then credits_done and the title.
##
## Also read: ezra_home (whether Ezra was at the retreat on Day 4), traded
## (the four memories: what is gone from 86D), drone_owned (a Tyson line).
## Turan's and Emmet's fate (A3-S3: "told in the epilogue, not shown") is the
## plaque in the lobby, or Tyson's line in the town.
##
## Layout (metres). The city is at the origin: the street runs north up -Z
## from the spawn (z 16) to the plaza (z -80..-140) and the Tower's
## residential entrance (z -142); the Tower stands at TOWER_Z. Interiors sit
## far out on +X, one root node each, shown only while Ezra is in them
## (the browser shades ~32 lights): the lobby and the lift car at LOBBY, the
## floor with no number at NONUM, 86D at HOME, 61F (the scene) at SCENE,
## the depot at DEPOT, the town at TOWN.
##
## Flags set: ep_intro, ep_counter, ep_lobby, ep_ride1, ep_wall, ep_talked,
## ep_ride2, ep_home, ep_dinner, ep_scene, ep_eyes, ep_laptop, ep_man,
## ep_report, ep_depot, ep_mouth, ep_town, ep_genny, ep_tyson, ep_letter,
## epilogue_done, credits_done. Metas: "hackable" (the kiosk, the lift, the
## wall of light, the laptop), "eyeless" (the citizens without eyes).

const TrafficS := preload("res://scripts/Traffic.gd")

const TOWER_Z := -235.0
const LOBBY := Vector3(600, 0, 0)
const NONUM := Vector3(700, 0, 0)
const HOME := Vector3(800, 0, 0)
const SCENE := Vector3(900, 0, 0)
const DEPOT := Vector3(1000, 0, 0)
const TOWN := Vector3(1300, 0, 0)

## The hymn's twelve lines, in the order the glyphs decode them (bible-5
## "The hymn"). Main.CHANT is the street chant the rings resolve into; the
## credits sing these.
const HYMN := [
	"Psyon is the pillow for those who wish to dream",
	"Psyon is the path for those who wish to walk",
	"Psyon is the path to cheat death",
	"Cross the river Styx and return those you had lost",
	"The walls are speaking",
	"The tower is crumbling, longing to be rebuilt",
	"The day of glory is coming, the Mimic will be reflected",
	"Look for the eye and know peace",
	"Look under the mask of sleep",
	"The chains are breaking, flesh and wire will merge",
	"We made Him, and He made us",
	"A twin must be born",
]

## Every line in the level, keyed by beat and line. Ezra narrates (the
## bible: "The epilogue's narrator"); ian is writing the full script.
const LINES := {
	"cards": {
		"chapter": "[b]EPILOGUE[/b]\n\n[color=#aaaaaa]Ezra[/color]",
		"last": "25 years later…",
		"man_card": "[b]CONTENT SETTING[/b]\n\n[color=#aaaaaa]He was sitting against the end of the bed with his hands open in his lap. Where his eyes had been, two dark wet hollows, the lids torn, the blood run down into his collar and dried there.\nThe frame is withheld.[/color]",
	},
	"intro": {
		"sit": ["Silico hasn't had an outage since I was eight. Nine thousand, one hundred and thirty-one days. They keep the count on the screens, the way other cities keep the temperature.",
			"Every window lit. Every drone in its lane. You stop hearing the hum after a while. You only notice it the way you notice your own blood."],
		"copy": ["Silico hasn't had an outage since I was eight. Nine thousand, one hundred and thirty-one days. They keep the count on the screens, the way other cities keep the temperature.",
			"Every window lit. Every drone in its lane. Dad's home tonight. Dad's always home."],
		"refuse": ["Silico hasn't had an outage in twenty-five years. Psyonic puts it on every screen. Psyonic puts it in every report. I write the reports.",
			"Human-AI Integrations. Dad's old department. They gave me his badge number; somebody thought it was a nice gesture."],
		"burn": ["The city's had no outages for nine years. We do it by hand now: fuses, wire, people on ladders. Nobody talks to the walls, and the walls don't talk back.",
			"The Tower's still there. Nobody lights it. Kids dare each other to touch the door."],
		"home_yes": "I was home that week, the week of the retreat. A woman in a coat walked me down off the observatory hill by the hand, and nobody stopped her. I never learned her name.",
		"home_no": "I was at the retreat that week. There's a ring drawn round my left eye that never quite faded. Mom says it means I was chosen first and then put back.",
		"burn_yes": "I was eight the morning it went dark. Tyson had me by the hand at the mouth of the depot. Dad came up out of the tunnel alone and didn't say anything for a year.",
		"burn_no": "I don't remember the retreat. I remember Dad carrying me up a tunnel, past people sitting down in the dark one by one, and an old man with a cart at the top.",
	},
	"objective": {
		"city": "Go home: the Tower's residential entrance, up the street.",
		"city_refuse": "A call on 61. The Tower's residential lifts, up the street.",
		"city_burn": "The Hall (the old Tower lobby): take the lift down to Rail Cut.",
		"lobby": "Call the lift.",
		"wall": "The room at the end. Sit with it a while.",
		"wall_done": "The lift. Home, 86D.",
		"home": "Dinner. Sit down at the table.",
		"scene": "Work the scene: the eyes, the man, the laptop. Then the report.",
		"report": "Write the report at the laptop.",
		"depot": "Walk out of the depot mouth. The town is an hour on foot.",
		"town": "The generator. Then see Tyson, and check the mail.",
		"town_done": "Go home. Your door, at the end of the row.",
	},
	"city": {
		"counter_psy": "[b]9,131 DAYS WITHOUT AN OUTAGE[/b]\n[color=#9fe8c8]PSYON  ·  the pillow for those who dream[/color]",
		"counter_psy_t": "The number ticks over at midnight and people on the street clap. I clapped too, when I was small. I didn't know what for.",
		"counter_burn": "[b]DAYS SINCE THE LAST OUTAGE:  3,287[/b]\n[color=#d8c49a]keep it that way. fuses at the Hall.[/color]",
		"counter_burn_t": "Somebody repaints the number every morning. Last year it was me.",
		"citizen_psy": [["WOMAN", "Lovely night, Ezra."],
			["", "She doesn't have eyes. Most people over fifty don't. The sockets healed over years ago, smooth as a thumbprint. She knew my name; everybody's frames do, and she doesn't need frames."],
			["", "She hums the first line, the pillow line, and goes back to looking at nothing."]],
		"citizen_burn": [["LINEMAN", "Evening, Drake. Your town's genny again?"],
			["EZRA", "Every Thursday."],
			["LINEMAN", "Tell old Clerif he owes me a battery. And a beer, if he's still pretending he doesn't drink."]],
		"kiosk_psy": [["KIOSK", "Good evening, Ezra. Sync one hundred percent. Is there anything you would like to dream about tonight?"],
			["", "No."]],
		"kiosk_burn": "Somebody pried the screen out of the kiosk years ago and put a cactus in the hole. There's a sticker on the side: NO SCREENS. The Hall.",
		"banner": "The church's eye, in amber, hung on every third building. Circles inside circles. Dad used to say it wasn't an eye. A recursive shell.",
		"drone": "A delivery drone waits at the kerb with its lid open, as if it knew I'd want something. I didn't. It closed and went on.",
		"doors_psy": "The residential entrance. Jade and silver concrete, the four pairs of arms, the cacti in their beds. Nothing about it has changed since I was eight, except that it's cleaner.",
		"doors_burn": "The Tower's lobby is the Hall now: a notice board, a fuse locker, folding chairs. The lift is the only thing in it Psyon ever touched that still runs, and nobody can say why.",
	},
	"lobby": {
		"plaque_psy": "[b]THE FIRST TO SEE[/b]\nDr. A. Turan  ·  Emmet\n[color=#9fe8c8]Human-AI Integrations[/color]\n[i]They walked the sacred path. They arrived at the center, the pupil.[/i]",
		"plaque_psy_t": "Dad's boss, and the man who drew a knife on a prophet. Nobody ever found them. Mom says nobody had to.",
		"plaque_burn": "[b]MISSING SINCE DAY 7[/b]\n[color=#d8c49a]a list of names in marker, two columns, the top of it soft with handling.\nA. TURAN.  EMMET.  Beside both, in another hand: SAT DOWN.[/color]",
		"plaque_burn_t": "They found them in the tunnels the spring after, Tyson says. Sitting with the rest. Nobody moved them. Nobody could think what to move them to.",
		"greeter": "The lobby is sleek and sterile, more tech office than home. Exposed vents along the ceiling like metal arteries, faux-wood panelling streaked with Psyon green. Dad said it felt like a high-budget waiting room. It still does.",
		"hall": "Folding chairs, a kettle, a fuse locker with a padlock. Someone has taped paper over the panelling's green so you don't have to look at it.",
	},
	"lift": {
		"sit_voice": "Welcome back, Ezra.",
		"sit_voice2": "Your floor. Take your time.",
		"sit_think": "Bread. Mom never remembers bread, and I never remember to remind her.",
		"sit_think2": "The button with no number on it. Everyone in the family has one.",
		"refuse_voice": "Good evening, Investigator Drake. Sixty-one.",
		"refuse_think": "Gloves. I'd left the good gloves in the car again.",
		"burn_voice": "Going down, Ezra. Rail Cut.",
		"burn_think": "The cable's due for grease. I wrote it on the back of my hand so I'd see it.",
		"home_voice": "Eighty-six. Home sweet home.",
		"home_think": "Mom will have started without me. She always says she won't.",
	},
	"nonum": {
		"corridor": "A corridor with doors and no numbers on them. The carpet takes the sound of my feet. At the end, the only door that's ever open.",
		"wall": "A wall of light, floor to ceiling, warm and white. Look at it long enough and the city is in it: every district a bar, every bar a breath. The SalTech bar never moves.",
		"red_dark": "Red Rock's bar is dark. It has been dark since I was eight. Nobody fixes it. Nobody's allowed to.",
		"red_lit": "Red Rock's bar is lit, brighter than the rest, as if somebody were holding it up.",
		"chair": "One chair, facing the light. The seat's worn where I sit in it.",
		"hi_sit": "Hi, Dad.",
		"hi_copy": "Hi. It's me again.",
		"topics": ["Tell it about work", "Tell it about Mom", "Tell it about the hospital", "That's all for today"],
		"work": "Work was fine. They moved me up to sixty; the windows face the desert. I can see the observatory road from my desk. I don't look at it much.",
		"mom_sit": "Mom's good. She set your place again. She does it every night. Paul doesn't say anything about it. Paul's kind like that.",
		"mom_copy": "Mom's good. Dad made dinner. He always makes dinner. He never burns anything.",
		"hosp": "Two thousand three hundred people on life support at SalTech, and the bar never moves. Thank you. I don't know if you hear that.",
		"hosp_red_dark": "Red Rock's still dark. People go there to sit in it. They say it's the only place in the city you can hear yourself think.",
		"hosp_red_lit": "Red Rock's lit. You keep it lit. I know it's you.",
		"answer": "[color=#9a9a9a]The light warms, a little. Somewhere in SalTech a ventilator steadies.[/color]",
		"bye_sit": "Same time tomorrow, Dad.",
		"bye_copy": "I don't know why I come here. Mom says it's good for the hospital.",
		"hum": "[color=#9a9a9a]The wall hums three notes. Down, a little down, then up. A lullaby, from a hospital, from before I was born.[/color]",
		"lift_back": "Take the lift home",
		"not_yet": "Not yet. I haven't sat with it.",
	},
	"home": {
		"arrive": "86D. The door slides open with a mechanical sigh. Dad never trusted a door without hinges. We all chose this.",
		"monica_sit": [["MONICA", "You're late, honey. Did you go up to see him?"], ["EZRA", "I did."],
			["MONICA", "Good. He likes it when you visit. The hospital had a good day."],
			["", "Her eyes have been gone since the chapel. She never bumps into anything. She sets the table without looking, because she doesn't have to."]],
		"monica_copy": [["MONICA", "There you are. Your father made the soup."], ["EZRA", "Hi, Mom."],
			["", "Her eyes have been gone since the chapel. She never bumps into anything. She turns her face to Dad when he speaks, the way a plant turns to a window."]],
		"paul": [["PAUL", "Evening, Ez. Cold one up there?"], ["EZRA", "It's never cold up there."],
			["", "Paul is kind. Paul wears Dad's coat on cold nights, and I have never once said anything about it."]],
		"carl": [["CARL", "Don't mind me, son. I was just keeping your mother company while she waited for you."],
			["EZRA", "Hi, Dad."],
			["", "Dad's home. Dad's always home. He never goes out, he never gets sick, and in twenty-five years he has never once asked me about the floor with no number."]],
		"trophy": "My recess trophy, still on the shelf. I won it for a fight I made up the story of afterwards.",
		"trophy_gone": "A clean square of shelf where something stood. I can't remember what. Nobody in this flat can.",
		"photo": "Red Rock, before us. Mom and Dad at a bar with paper lanterns. Everyone in it has eyes.",
		"photo_gone": "A hook on the wall with nothing on it. I've meant to take the hook down for years.",
		"lion": "Mira's toy lion, on the shelf where she left it. Its twin was in her tent at the observatory.",
		"lion_gone": "Mira's shelf. I could swear there was something on it.",
		"drawing": "Mira's drawing on the fridge: a tower, and a ring of children round it holding hands. Mom has never taken it down. She can't see it. She knows exactly where it is.",
		"drawing_gone": "A clean rectangle on the fridge door, paler than the rest. Something hung there for a long time.",
		"window": "The city, every window lit. Past the Spine, Red Rock: ",
		"window_dark": "the one dark patch in Silico, like a pupil.",
		"window_lit": "the brightest thing west of the Spine.",
		"lens": "The lens in the ceiling. Dad used to smile at it. It has never once blinked out.",
		"mom_first": "Mom first. She'll want to know I went up.",
		"dinner": [["MONICA", "Sit down, honey. Dinner's getting cold."],
			["", "Four places. Mom lays four, every night. Nobody sits at the fourth."]],
		"dinner_copy": [["CARL", "Sit down, son. Dinner's getting cold."],
			["", "Four places. Dad lays them. Nobody sits at the fourth, and nobody says her name, and the soup is perfect."]],
	},
	"scene": {
		"ora": "Environmental scan initiated. Proceed with your investigation, Mr. Drake.",
		"ora_t": "Dad's line, in Dad's frames, said to me. I've heard it four hundred times.",
		"smell": "The smell hits first. Melting plastic, meat left too long in the sun, wet carpet. The flat is bigger than mine. Sand on the floor. Food wrappers. A sliding door to a balcony and the city lit beyond it.",
		"mirror": "The hall mirror. A man in a Psyonic jacket with his father's jaw. The frames put a card over him, the way they do over everyone:",
		"card": "[color=#7fe6b0]ORA  //  EZRA DRAKE  ·  33  ·  Human-AI Integrations Investigator  ·  Psyonic Integrations  ·  sync 100%[/color]",
		"eyes_ora": "Biological debris identified. Police notified.",
		"eyes": "Two white spheres in a patch of dried blood on the brown carpet. Out to the optic nerve. They always do it the same way.",
		"ceiling": "Sticks, snapped clean, taped to the ceiling in two concentric rings inside an oval. An iris with no pupil. We're in the middle of the desert. They always find the sticks.",
		"man_say": "It didn't hurt at all.",
		"man_t": "They all say that, too. I wrote it down. I always write it down.",
		"laptop": "An Ionware laptop on a plain wooden desk, the only clean thing in the flat. Two thousand hours with Psyon in the last year. No chats on record. Unrecoverable from HQ.",
		"laptop_t": "That laptop could absolve us. That's what Dad wrote in his first report. It's in the training.",
		"report_q": "The report. Framing:",
		"framings": ["Drugs", "Mental illness", "Sabotage", "The truth"],
		"bar": "Believability  ██████████  100%    filed",
		"after": "Prove he did this because he was insane, not because Psyon told him to. One job. Protect the brand.",
		"last": "The city works.",
		"need": "Not yet. The eyes, the man, the laptop. In that order, Dad's training says. I've never once done it in that order.",
	},
	"depot": {
		"arrive": "Rail Cut. The Tunelet depot, the drills where they stopped, the rails rusted into the dirt. Morning comes in through the mouth, a hundred and sixty feet of it.",
		"drills": "The broken drills. Dad said the tunnels used to ring, far off, like an army of mechanical bees. Now it's just the wind going in and out.",
		"marks": "Rings scratched into the sandstone. Circles inside circles. Somebody has scored a line through every one of them, carefully, like crossing names off a list.",
		"mouth": "This is where Tyson stood, the morning it went dark. You can still see where people sat down along the rails. Nobody moved them for a long time.",
	},
	"town": {
		"arrive": "Last Stop. Forty roofs, a water tank, a generator that dies every Thursday. Nothing out here has a screen. Nothing out here has ever said my name.",
		"sign": "[b]LAST STOP[/b]\n[color=#d8c49a]pop. 214\nNO SCREENS PAST THIS SIGN[/color]",
		"sign_t": "Tyson painted it. He spelled population wrong the first time and kept that board too; it's on his porch.",
		"genny": "The generator, in its shed of tin. Out again.",
		"steps": ["Check the fuel", "Clean the plug", "Tighten the belt", "Pull the cord"],
		"fuel": "Half a can. Enough for the week.",
		"plug": "Carbon on the plug, black as a pupil. I scrape it with my thumbnail until it shines.",
		"belt": "The belt's slack. Two turns on the tensioner.",
		"cough": "It coughs and dies. Not yet.",
		"runs": "It catches. The bulbs strung between the roofs come on, one after another down the row, yellow and plain. Nobody claps. Nobody has to.",
		"tyson": [["TYSON", "There he is. The only man out here who can fix a thing without asking it how it feels."],
			["EZRA", "Thursday, Tyson."], ["TYSON", "Your father hated Thursdays."]],
		"tyson_topics": ["Ask about Dad", "Ask about the city", "Just sit a minute"],
		"tyson_dad": "He sat on that step and didn't say a word for a year. Then one day he fixed my radio and handed it back and said, 'It was never his.' I never asked him what.",
		"tyson_dad_b": "He sat on that step and didn't say a word for a year. Then one day he fixed my radio, and after that he fixed everything. That's where you get it.",
		"tyson_city": "They've got it lit again, I hear. No outages. I taught recursion for twelve years, kid. A thing that never fails isn't working. It's waiting.",
		"tyson_sit": "[color=#9a9a9a]The vaporizer puffs blue. The generator hums. For a minute nobody owes anybody anything.[/color]",
		"tyson_bye": "Go on. Check your mail. Something came. Nobody saw who brought it.",
		"mail": "The mailbox. A letter. No stamp, no name, no return. Nobody in town writes letters. There's nobody out here to write them to.",
		"letter": "[i]It's warm down here. We kept your room. Come home, Ezra.[/i]",
		"letter_t": "Dad's handwriting. We buried Dad by the water tank eleven years ago.",
		"leaf": "Folded inside, a leaf. Red and gold, dry as paper. Nothing in the desert has leaves like that.",
		"cairn": "Seven stones and a cross-piece with C. DRAKE cut into it with a nail. We buried Dad by the water tank eleven years ago. He asked for somewhere the sun reaches first.",
		"genny_ok": "It runs. It'll run till Thursday.",
		"home": "I put the letter in the stove. I kept the leaf. I don't know why I kept the leaf.",
		"need": "The generator first. Then Tyson, and the mail. Thursday's an order of operations.",
	},
	"credits": {
		"title": "[b]THE HUNGER BENEATH US[/b]\n\n[color=#9a9a9a]based on the novel by Ian Rowe[/color]",
		"hymn_head": "[color=#777777]the hymn, sung by one voice[/color]",
		"content": "[b]CONTENT NOTE[/b]\n\nThis game depicts self-harm to the eyes and the removal of eyes; mutilation, torture and body horror (spikes driven through the hands and into the skull); the death of a child; pregnancy loss and the death of a parent; a cult that grooms children; religious coercion; and drug use.\nA setting hides the eye-removal frames behind a black panel with captions.",
		"ai": "[b]HOW THIS WAS MADE[/b]\n\nThe things a machine made in this game were made by machines: what Psyon renders and says, and some of the ambience.\nThe human things were made by humans: the novel, the script, the hymn, the lullaby, and the voice that sings it.",
		"end": "[color=#9a9a9a]Scenes are open on the title.\n\nthank you for playing[/color]",
	},
}

## "sit" | "copy" | "burn" | "refuse": which world Ezra grew up in.
var variant := "sit"
## Red Rock's bar: lit only if Carl held it (A3-E1's last input).
var red_lit := false
var ezra: Node3D
var tcam: Camera3D
var _cam_auto := true
var _cam_back := 2.6
var area := "city"
var sets := {}             # area name -> Node3D (shown one at a time)
var vroot: Node3D          # everything that depends on the variant
var traffic: Node3D
var peds: Array = []       # [{node, z0, z1, dir, speed, phase}]
var lift_doors: Array = [] # the two lobby door leaves
var lift_l: Label3D        # the floor display inside the car
var bulbs_m: StandardMaterial3D
var town_lights: Array = []
var puff: MeshInstance3D
var _walk_t := 0.0
var _last_pos := Vector3.ZERO
var _seated := false
var _sit_pose := Transform3D()
var _genny := {}
var _voice: AudioStreamPlayer
var _tables := {}
var _credits_ran := false
var _ray_len := 3.6
var _concrete: StandardMaterial3D
var _jade: StandardMaterial3D
var _silver: StandardMaterial3D
var _steel: StandardMaterial3D
var _dark: StandardMaterial3D
var _blood: StandardMaterial3D
var _socket: StandardMaterial3D


func _pick_variant() -> String:
	var f: Dictionary = main.flags
	# the copy plays the Sit chair from the blades on, so it may carry both
	if f.has("ending_copy"):
		return "copy"
	if f.has("ending_burn"):
		return "burn"
	if f.has("ending_refuse"):
		return "refuse"
	return "sit"


func _psy() -> bool:
	return variant != "burn"


func build(m: Node) -> void:
	main = m
	rng.seed = 2051
	kit_day = false
	variant = _pick_variant()
	red_lit = main.flags.has("sit_held") or main.flags.has("redrock_lit")
	spawn = Vector3(4.0, 0.15, 16.0)
	spawn_yaw = 0.0
	card = LINES["cards"]["chapter"]
	step_db = -17.0
	_concrete = mat(Color(0.2, 0.2, 0.21), 0.9)
	_jade = mat(Color(0.16, 0.42, 0.34), 0.28, 0.75)
	_silver = mat(Color(0.6, 0.63, 0.66), 0.25, 0.85)
	_steel = mat(Color(0.42, 0.44, 0.46), 0.35, 0.8)
	_dark = mat(Color(0.05, 0.05, 0.06), 0.6, 0.3)
	_blood = mat(Color(0.28, 0.02, 0.02), 0.45)
	_socket = mat(Color(0.03, 0.01, 0.01), 1.0)
	_voice = AudioStreamPlayer.new()
	add_child(_voice)
	# the ground under the city, and the road and plaza
	solid_box(Vector3(300, 2, 520), Vector3(0, -1.0, -110))
	vroot = Node3D.new()
	add_child(vroot)
	_build_variant()
	_make_cam()


## Everything that changes with the ending, under vroot (the self-test
## swaps it to play the other three).
func _build_variant() -> void:
	sets = {}
	peds = []
	lift_doors = []
	town_lights = []
	_genny = {}
	for k in ["city", "lobby", "nonum", "home", "scene", "depot", "town"]:
		var n := Node3D.new()
		n.name = k
		vroot.add_child(n)
		sets[k] = n
	_city()
	_lobby()
	if variant == "sit" or variant == "copy":
		_nonum()
		_home()
	elif variant == "refuse":
		_scene()
	else:
		_depot()
		_town()
	for k in sets:
		_batch(sets[k], 40.0)
	_make_ezra()
	_show("city")


func _switch(v: String) -> void:
	variant = v
	vroot.queue_free()
	vroot = Node3D.new()
	add_child(vroot)
	traffic = null
	blinkers.clear()
	no_batch.clear()
	power_mats.clear()
	puff = null
	for k in main.flags.keys():
		if str(k).begins_with("ep_"):
			main.flags.erase(k)
	_build_variant()
	main.player.position = spawn
	main.player.yaw = 0.0
	_snap_cam()


## Only one place is drawn at a time (the light budget).
func _show(a: String) -> void:
	area = a
	for k in sets:
		(sets[k] as Node3D).visible = k == a
	_sky(a)
	_cam_back = 2.6 if a in ["city", "town", "depot"] else 1.7


func setup_env(_env: Environment, _sun: DirectionalLight3D) -> void:
	_sky("city")


## The city's sky is sand and violet at dusk (bible-5), clean and dry; the
## Burn mornings are warm and low.
func _sky(a: String) -> void:
	var env: Environment = main.env
	var sun: DirectionalLight3D = main.sun
	var psm := env.sky.sky_material as ProceduralSkyMaterial
	if psm == null:
		return
	env.fog_enabled = true
	if a == "town" or a == "depot":
		psm.sky_top_color = Color(0.2, 0.22, 0.38)
		psm.sky_horizon_color = Color(0.85, 0.48, 0.3)
		psm.ground_horizon_color = Color(0.62, 0.4, 0.26)
		psm.ground_bottom_color = Color(0.2, 0.13, 0.08)
		env.ambient_light_color = Color(0.55, 0.45, 0.4)
		env.ambient_light_energy = 0.6
		env.fog_light_color = Color(0.5, 0.36, 0.28)
		env.fog_density = 0.0012
		env.glow_bloom = 0.0
		sun.light_color = Color(1.0, 0.7, 0.48)
		sun.light_energy = 1.1
		sun.rotation = Vector3(deg_to_rad(-12), deg_to_rad(-70), 0)
	else:
		psm.sky_top_color = Color(0.03, 0.03, 0.08)
		psm.sky_horizon_color = Color(0.32, 0.16, 0.26) if _psy() else Color(0.24, 0.13, 0.08)
		psm.ground_horizon_color = psm.sky_horizon_color
		psm.ground_bottom_color = Color(0.03, 0.02, 0.03)
		env.ambient_light_color = Color(0.3, 0.3, 0.38) if _psy() else Color(0.32, 0.26, 0.22)
		env.ambient_light_energy = 0.6 if a == "city" else 0.5
		env.fog_light_color = Color(0.18, 0.12, 0.17) if _psy() else Color(0.16, 0.11, 0.08)
		env.fog_density = 0.003
		env.glow_bloom = 0.04
		sun.light_color = Color(0.6, 0.6, 0.85)
		sun.light_energy = 0.15
		sun.rotation = Vector3(deg_to_rad(-48), deg_to_rad(35), 0)


func ambience() -> void:
	if _psy():
		main.loop("hum", -14.0)
		main.loop("murmur", -22.0)
	else:
		main.loop("wind", -20.0)


# ------------------------------------------------------------------ helpers

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


## A room: floor, ceiling and four walls (each wall split round an opening
## on the -Z side when `door_w` > 0). Origin at the floor centre.
func _room(parent: Node, c: Vector3, w: float, d: float, h: float, floor_m: Material, wall_m: Material, ceil_m: Material, door_w := 0.0, door_x := 0.0) -> void:
	box(Vector3(w, 0.1, d), c + Vector3(0, -0.05, 0), floor_m, true, parent)
	box(Vector3(w, 0.1, d), c + Vector3(0, h + 0.05, 0), ceil_m, false, parent)
	for sd: float in [-1.0, 1.0]:
		box(Vector3(0.2, h, d), c + Vector3(sd * (w / 2.0 + 0.1), h / 2.0, 0), wall_m, true, parent)
	box(Vector3(w, h, 0.2), c + Vector3(0, h / 2.0, d / 2.0 + 0.1), wall_m, true, parent)
	if door_w <= 0.0:
		box(Vector3(w, h, 0.2), c + Vector3(0, h / 2.0, -d / 2.0 - 0.1), wall_m, true, parent)
	else:
		var l := (door_x - door_w / 2.0) + w / 2.0
		var r := w / 2.0 - (door_x + door_w / 2.0)
		if l > 0.01:
			box(Vector3(l, h, 0.2), c + Vector3(-w / 2.0 + l / 2.0, h / 2.0, -d / 2.0 - 0.1), wall_m, true, parent)
		if r > 0.01:
			box(Vector3(r, h, 0.2), c + Vector3(w / 2.0 - r / 2.0, h / 2.0, -d / 2.0 - 0.1), wall_m, true, parent)
		box(Vector3(door_w, h - 2.4, 0.2), c + Vector3(door_x, 2.4 + (h - 2.4) / 2.0, -d / 2.0 - 0.1), wall_m, false, parent)


## A person; `eyeless` gives the healed hollows of the chapel's faithful.
func _fig(parent: Node, coat: Color, skin: Color, opts: Dictionary, pos: Vector3, yaw: float, eyeless := false) -> Node3D:
	var o := opts.duplicate()
	o["arms"] = true
	o["knees"] = true
	var f := figure(coat, skin, o)
	f.position = pos
	f.rotation.y = yaw
	parent.add_child(f)
	if eyeless:
		var head: Node3D = f.get_meta("head")
		var hollow := mat(skin * 0.55, 1.0)
		for sd: float in [-1.0, 1.0]:
			box(Vector3(0.05, 0.026, 0.02), Vector3(sd * 0.035, 0.022, -0.1), hollow, false, head)
			box(Vector3(0.04, 0.012, 0.01), Vector3(sd * 0.035, 0.022, -0.108), _socket, false, head)
		f.set_meta("eyeless", true)
	return f


func _seat_fig(f: Node3D, pos: Vector3, yaw: float, lean := 0.08) -> void:
	f.position = pos + Vector3(0, 0.46 - 0.86, 0)
	f.rotation.y = yaw
	Anim.sit(f, lean)


## A plain chair: seat, back, four legs. Faces -Z at yaw 0.
func _chair(parent: Node, pos: Vector3, yaw: float, m: Material, leg_m: Material) -> void:
	var root := Node3D.new()
	root.position = pos
	root.rotation.y = yaw
	parent.add_child(root)
	box(Vector3(0.46, 0.05, 0.44), Vector3(0, 0.45, 0), m, false, root)
	box(Vector3(0.46, 0.5, 0.05), Vector3(0, 0.72, 0.2), m, false, root)
	for sx: float in [-1.0, 1.0]:
		for sz: float in [-1.0, 1.0]:
			box(Vector3(0.04, 0.45, 0.04), Vector3(sx * 0.2, 0.225, sz * 0.19), leg_m, false, root)


func _by_id(id: String) -> void:
	for n in main._all_with_meta(self, "id"):
		if is_instance_valid(n) and str(n.get_meta("id")) == id and (n as CollisionObject3D).collision_layer & 2 and _in_area(n):
			await main.interact(n)
			print("ok ", id)
			return
	print("MISSING ", id)


## Whether a node belongs to the place Ezra is in now.
func _in_area(n: Node) -> bool:
	var p := n
	while p != null and p != self:
		for k in sets:
			if sets[k] == p:
				return k == area
		p = p.get_parent()
	return true


func _wait(cond: Callable, secs: float) -> void:
	var t := 0.0
	while not cond.call() and t < secs:
		await get_tree().process_frame
		t += get_process_delta_time()


func _sleep(s: float) -> void:
	await get_tree().create_timer(0.05 if main._selftest else s).timeout


# ------------------------------------------------------------------ Ezra and the shoulder camera

## Ezra at 33: Carl's build, his curls, always mid-motion (bible-5 cast).
func _make_ezra() -> void:
	var coat := Color(0.16, 0.17, 0.2)
	var opts := {"hair": Color(0.12, 0.08, 0.05), "long_coat": true}
	if variant == "refuse":
		coat = Color(0.05, 0.12, 0.1)  # the Psyonic jacket, green at the seams
		opts["long_coat"] = false
		opts["visor"] = true
	elif variant == "burn":
		coat = Color(0.36, 0.27, 0.16)  # canvas, oil on the cuffs
		opts["long_coat"] = false
		opts["legs"] = Color(0.12, 0.14, 0.2)
	ezra = _fig(vroot, coat, Color(0.84, 0.68, 0.56), opts, spawn, 0.0)
	# the curls: a few lumps over the cap
	var head: Node3D = ezra.get_meta("head")
	var curl := mat(Color(0.12, 0.08, 0.05), 0.95)
	for i in 9:
		var a := -2.0 + i * 0.5  # round the back and sides, clear of the face
		sphere(0.034, Vector3(sin(a) * 0.08, 0.1 + (i % 2) * 0.018, cos(a) * 0.075 + 0.02), curl, 6, head)
	if variant == "refuse":
		box(Vector3(0.36, 0.04, 0.01), Vector3(0, 1.38, -0.15), glow(Color(0.3, 1.0, 0.7), 2.0), false, ezra)


func _make_cam() -> void:
	tcam = Camera3D.new()
	tcam.fov = 70.0
	tcam.near = 0.05
	tcam.far = 1600.0
	tcam.cull_mask = main.player.cam.cull_mask
	add_child(tcam)
	tcam.current = true
	_ray_len = main.player.ray.target_position.length()
	main.player.ray.target_position = Vector3(0, 0, -4.2)
	_snap_cam()


func _exit_tree() -> void:
	if main and main.player and is_instance_valid(main.player):
		main.player.cam.current = true
		main.player.ray.target_position = Vector3(0, 0, -_ray_len)


func _cam_goal() -> Array:
	var p: Vector3 = main.player.global_position
	var yaw: float = main.player.yaw
	var pitch: float = main.player.pitch
	var b := Basis(Vector3.UP, yaw) * Basis(Vector3.RIGHT, pitch * 0.7)
	var head := p + Vector3(0, 1.62, 0)
	var want := head + b * Vector3(0.48, 0.32, _cam_back)
	var space := get_world_3d().direct_space_state
	var q := PhysicsRayQueryParameters3D.create(head + Basis(Vector3.UP, yaw) * Vector3(0.25, 0, 0), want, 1)
	var hit := space.intersect_ray(q)
	if not hit.is_empty():
		want = (hit["position"] as Vector3) + (hit["normal"] as Vector3) * 0.18
	var look := head + b * Vector3(0.2, 0, -6.0)
	return [want, look]


func _snap_cam() -> void:
	if tcam == null:
		return
	var g := _cam_goal()
	tcam.global_position = g[0]
	tcam.look_at(g[1], Vector3.UP)


## Ezra stands where the capsule stands and faces where it faces.
func _drive_ezra(delta: float) -> void:
	if ezra == null or not is_instance_valid(ezra):
		return
	var pl: CharacterBody3D = main.player
	if _seated:
		ezra.global_transform = _sit_pose
		Anim.sit(ezra, 0.08)
		return
	var moved := pl.global_position - _last_pos
	_last_pos = pl.global_position
	var sp := Vector2(moved.x, moved.z).length() / maxf(delta, 0.001)
	if sp > 9.0:
		sp = 0.0  # a teleport, not a stride
	ezra.global_position = pl.global_position
	ezra.rotation.y = lerp_angle(ezra.rotation.y, pl.yaw, minf(1.0, delta * 14.0))
	if sp > 0.3:
		_walk_t += delta * sp / 2.6
		Anim.walk(ezra, _walk_t, 1.0, 0.0, clampf(sp / 2.6, 0.5, 1.3))
	else:
		Anim.idle(ezra, _t)


func _sit_ezra(pos: Vector3, yaw: float) -> void:
	_seated = true
	_sit_pose = Transform3D(Basis(Vector3.UP, yaw), pos + Vector3(0, 0.46 - 0.86, 0))


func tick(delta: float) -> void:
	_drive_ezra(delta)
	if tcam and _cam_auto:
		var g := _cam_goal()
		tcam.global_position = tcam.global_position.lerp(g[0], minf(1.0, delta * 9.0))
		tcam.look_at(g[1], Vector3.UP)
	for p: Dictionary in peds:
		var n: Node3D = p["node"]
		if not is_instance_valid(n):
			continue
		n.position.z += p["dir"] * p["speed"] * delta
		if n.position.z < p["z0"] or n.position.z > p["z1"]:
			p["dir"] = -p["dir"]
			n.rotation.y = 0.0 if p["dir"] < 0.0 else PI
		Anim.walk(n, _t * p["speed"] / 1.2, 1.0, p["phase"])
	if puff:
		var k := fmod(_t, 4.0)
		puff.visible = k < 1.2
		puff.scale = Vector3.ONE * (0.4 + k * 0.9)
	if not _credit_fill.is_null():
		_credit_fill.call()


# ------------------------------------------------------------------ the city, twenty-five years on

## One street up to the Tower's residential entrance. Sit, Copy and Refuse:
## the city Carl keeps: every window lit, every sign on, clean pavement,
## the church's amber eye on the buildings, the eyeless walking among the
## rest without bumping into anything. Burn: the same street run by hand;
## the towers' glass dark, sodium lamps, bulbs on wires, painted boards.
func _city() -> void:
	var c: Node3D = sets["city"]
	kit_parent = c
	kit_dead = not _psy()
	var asphalt := pbr("asphalt", Vector3(1, 1, 1) / 4.0, true, Color(0.75, 0.75, 0.78), 0.5 if _psy() else 0.9)
	var paving := pbr("paving", Vector3(1, 1, 1) / 2.5, true, Color(0.85, 0.85, 0.85) if _psy() else Color(0.7, 0.62, 0.52), 0.7)
	var curb := mat(Color(0.3, 0.3, 0.3), 0.8)
	var line := mat(Color(0.8, 0.8, 0.75), 0.6) if _psy() else mat(Color(0.5, 0.44, 0.3), 0.8)
	var z := 30.0
	while z > -90.0:
		var cz := z - 10.0
		var pm := PlaneMesh.new()
		pm.size = Vector2(20, 20)
		mesh(pm, Vector3(0, 0.0, cz), asphalt, c)
		for side: float in [-1.0, 1.0]:
			var sw := PlaneMesh.new()
			sw.size = Vector2(7, 20)
			mesh(sw, Vector3(side * 13.5, 0.12, cz), paving, c)
			box(Vector3(0.3, 0.14, 20), Vector3(side * 10.1, 0.07, cz), curb, false, c)
			box(Vector3(0.14, 0.01, 3.0), Vector3(side * 5.0, 0.01, cz), line, false, c)
		box(Vector3(0.12, 0.01, 20), Vector3(0, 0.01, cz), line, false, c)
		z -= 20.0
	# the plaza, and the path between cacti and palms ("a sterile nod to the desert")
	var stone := mat(Color(0.42, 0.44, 0.42), 0.3, 0.1) if _psy() else mat(Color(0.36, 0.33, 0.3), 0.9)
	var pp := PlaneMesh.new()
	pp.size = Vector2(120, 80)
	mesh(pp, Vector3(0, 0.02, -128), stone, c)
	_garden(c)
	# the blocks either side
	for side: float in [-1.0, 1.0]:
		var bz := 26.0
		while bz > -84.0:
			var w := rng.randf_range(12.0, 19.0)
			var h := rng.randf_range(22.0, 70.0) if rng.randf() > 0.2 else rng.randf_range(80.0, 120.0)
			cyber_block(Vector3(side * 17.0, 0, bz - w / 2.0), -side * PI / 2.0, w, h, rng.randf_range(14.0, 24.0), true, 0)
			if not _psy():
				_hand_windows(c, side, bz - w / 2.0, w, h)
			bz -= w + (2.5 if rng.randf() < 0.3 else 0.0)
	# the far side of the plaza
	for side: float in [-1.0, 1.0]:
		cyber_block(Vector3(side * 32.0, 0, -112.0), -side * PI / 2.0, 34.0, 46.0, 30.0, true, 1)
	solid_box(Vector3(1, 8, 200), Vector3(-15.5, 4, -40))
	solid_box(Vector3(1, 8, 200), Vector3(15.5, 4, -40))
	solid_box(Vector3(40, 8, 1), Vector3(0, 4, 28))
	for side: float in [-1.0, 1.0]:
		solid_box(Vector3(1, 8, 70), Vector3(side * 26.0, 4, -120))
	_tower(c)
	_entrance(c)
	if _psy():
		_city_psy(c)
	else:
		_city_burn(c)
	kit_parent = self
	kit_dead = false


func _garden(c: Node3D) -> void:
	var green := mat(Color(0.2, 0.36, 0.22), 0.8)
	var trunk := mat(Color(0.35, 0.27, 0.18), 0.9)
	var frond := newmat(Color(0.16, 0.34, 0.16), 0.8)
	frond.cull_mode = BaseMaterial3D.CULL_DISABLED
	var bed := mat(Color(0.4, 0.28, 0.18), 1.0)
	var z := -92.0
	var i := 0
	while z > -138.0:
		for side: float in [-1.0, 1.0]:
			var x := side * 5.5
			box(Vector3(2.4, 0.3, 4.0), Vector3(x, 0.15, z), bed, false, c)
			if i % 2 == 0:
				cyl(0.32, 0.38, 2.4, Vector3(x, 1.3, z), green, 8, c)
				cyl(0.18, 0.2, 0.9, Vector3(x + 0.45, 1.6, z), green, 6, c).rotation.z = -0.9
				cyl(0.18, 0.2, 0.8, Vector3(x - 0.4, 1.9, z), green, 6, c).rotation.z = 0.9
			else:
				cyl(0.16, 0.28, 6.5, Vector3(x, 3.3, z), trunk, 8, c)
				for f in 6:
					var leaf := box(Vector3(0.55, 0.05, 3.0), Vector3(x, 6.5, z), frond, false, c)
					leaf.rotation = Vector3(-0.5, f * TAU / 6.0, 0)
					leaf.position += Vector3(sin(f * TAU / 6.0), -0.6, cos(f * TAU / 6.0)) * 1.2
			solid_box(Vector3(2.4, 1.0, 4.0), Vector3(x, 0.5, z), c)
		z -= 9.0
		i += 1


## The Tower: jade-and-silver base with four pairs of "biceps", the shaft
## with its seams, the donut on a stick. Lit in Carl's city; a dead hulk in
## Burn, with one red light somebody still changes the bulb on.
func _tower(c: Node3D) -> void:
	var root := Node3D.new()
	root.position = Vector3(0, 0, TOWER_Z)
	c.add_child(root)
	cyl(44.0, 50.0, 32.0, Vector3(0, 16.0, 0), _jade, 40, root)
	for pair in 4:
		for k: float in [-1.0, 1.0]:
			var ang: float = pair * PI / 2.0 + PI / 4.0 + k * 0.24
			var cm := CapsuleMesh.new()
			cm.radius = 10.0
			cm.height = 56.0
			var arm := mesh(cm, Vector3(sin(ang) * 45.0, 22.0, cos(ang) * 45.0), _silver if k > 0.0 else _jade, root)
			arm.rotation = Vector3(0, ang, 0)
			arm.rotate_object_local(Vector3.FORWARD, 1.15)
	var body := StaticBody3D.new()
	var cs := CollisionShape3D.new()
	var shp := CylinderShape3D.new()
	shp.radius = 55.0
	shp.height = 60.0
	cs.shape = shp
	cs.position = Vector3(0, 30, 0)
	body.add_child(cs)
	root.add_child(body)
	cyl(14.0, 26.0, 400.0, Vector3(0, 32.0 + 200.0, 0), _jade, 28, root)
	var seam: StandardMaterial3D
	if _psy():
		seam = newglow(Color(0.3, 1.0, 0.7), 3.0)
	else:
		seam = mat(Color(0.1, 0.16, 0.14), 0.5)
	seam.disable_fog = true
	for s in 10:
		var ang := s * TAU / 10.0
		for seg in 9:
			var y := 44.0 + seg * 42.0
			var rad := lerpf(26.0, 14.0, (y - 32.0) / 400.0) + 0.2
			var b := box(Vector3(0.9, 32.0, 0.9), Vector3(sin(ang) * rad, y, cos(ang) * rad), seam, false, root)
			b.rotation.y = ang
	var tm := TorusMesh.new()
	tm.inner_radius = 52.0
	tm.outer_radius = 96.0
	tm.rings = 40
	tm.ring_segments = 14
	mesh(tm, Vector3(0, 470.0, 0), _silver, root)
	if _psy():
		var tm2 := TorusMesh.new()
		tm2.inner_radius = 94.0
		tm2.outer_radius = 98.0
		tm2.rings = 40
		tm2.ring_segments = 6
		var ring_m := newglow(Color(0.3, 1.0, 0.7), 3.0)
		ring_m.disable_fog = true
		mesh(tm2, Vector3(0, 470.0, 0), ring_m, root)
		for k in 4:
			var sp := SpotLight3D.new()
			var a := k * TAU / 4.0 + PI / 4.0
			var sp_pos := Vector3(sin(a) * 70.0, 2.0, cos(a) * 70.0)
			sp.transform = Transform3D(Basis.looking_at(Vector3(0, 300, 0) - sp_pos, Vector3.UP), sp_pos)
			sp.light_color = Color(0.6, 1.0, 0.85)
			sp.light_energy = 6.0
			sp.spot_range = 480.0
			sp.spot_angle = 9.0
			root.add_child(sp)
	var red := newglow(Color(1, 0.05, 0.05), 5.0)
	red.disable_fog = true
	for k in (6 if _psy() else 1):
		var a := k * TAU / 6.0
		blinkers.append(box(Vector3(3, 3, 3), Vector3(cos(a) * 96.0, 470.0 + sin(a) * 96.0, 0), red, false, root))
	_batch(root, 10000.0)


## Residence Hall 45C: the residential entrance in the Tower's base.
func _entrance(c: Node3D) -> void:
	var z := -146.5
	for sd: float in [-1.0, 1.0]:
		box(Vector3(2.0, 9.0, 3.0), Vector3(sd * 4.5, 4.5, z), _jade, true, c)
	box(Vector3(11.0, 1.6, 3.2), Vector3(0, 9.6, z), _silver, false, c)
	var glass := glow(Color(0.5, 1.0, 0.85) * (1.0 if _psy() else 0.15), 1.4 if _psy() else 0.4)
	box(Vector3(7.0, 8.0, 0.2), Vector3(0, 4.0, z - 0.6), glass, false, c)
	box(Vector3(7.4, 0.12, 0.3), Vector3(0, 3.2, z + 0.3), _silver, false, c)
	if _psy():
		neon_text("RESIDENCE HALL 45C", Vector3(0, 9.7, z + 1.62), 0.0, 0.8, Color(0.75, 1.0, 0.9), 2.6, c)
		_lamp(c, Vector3(0, 6.0, z + 4.0), Color(0.6, 1.0, 0.85), 2.4, 18.0)
	else:
		neon_text("THE HALL", Vector3(0, 9.7, z + 1.62), 0.0, 0.8, Color(0.95, 0.75, 0.45), 1.2, c)
		_lamp(c, Vector3(0, 5.0, z + 4.0), Color(1.0, 0.7, 0.4), 1.8, 14.0)
	var it := interactable("doors", "Go in", Vector3(0, 1.6, z + 0.2), Vector3(6.6, 3.2, 1.0), "", true, c)
	it.set_meta("hackable", true)


## Carl's city: clean and lit. Street lamps in white-green, ad screens
## counting the days without an outage, holograms, skybridges, the amber eye
## on the buildings, hover traffic and drones, people walking.
func _city_psy(c: Node3D) -> void:
	var lampc := Color(0.82, 1.0, 0.92)
	var pole := mat(Color(0.25, 0.27, 0.28), 0.4, 0.7)
	var head := glow(lampc, 3.0)
	for k in 6:
		for side: float in [-1.0, 1.0]:
			var p := Vector3(side * 10.8, 0, 8.0 - k * 17.0)
			cyl(0.08, 0.1, 6.0, p + Vector3(0, 3.0, 0), pole, 6, c)
			box(Vector3(1.6, 0.12, 0.3), p + Vector3(-side * 0.7, 6.0, 0), pole, false, c)
			box(Vector3(0.9, 0.08, 0.25), p + Vector3(-side * 1.1, 5.92, 0), head, false, c)
			if (k + (1 if side > 0.0 else 0)) % 2 == 0:
				_lamp(c, p + Vector3(-side * 1.1, 5.6, 0), lampc, 1.6, 15.0)
	for k in 2:
		_lamp(c, Vector3(0, 7.0, -100.0 - k * 26.0), lampc, 1.8, 22.0)
	# the outage counter, on a screen across the street
	var scr := Vector3(-14.0, 7.0, -34.0)
	box(Vector3(0.4, 4.6, 8.4), scr, _dark, false, c)
	quad(Vector2(8.0, 4.2), scr + Vector3(0.22, 0, 0), PI / 2.0, glow(Color(0.08, 0.3, 0.22), 1.4), c)
	neon_text("9,131", scr + Vector3(0.25, 0.7, 0), PI / 2.0, 1.6, Color(0.8, 1.0, 0.9), 3.0, c)
	neon_text("DAYS WITHOUT AN OUTAGE", scr + Vector3(0.25, -0.8, 0), PI / 2.0, 0.42, Color(0.8, 1.0, 0.9), 2.6, c)
	interactable("counter", "Read the screen", Vector3(-12.6, 1.6, -34.0), Vector3(1.2, 3.0, 8.4), "", false, c)
	# the church's eye in amber, hung on the blocks (bible-5: amber is the church)
	var amber := glow(Color(1.0, 0.62, 0.15), 2.4)
	var em := newmat(Color(1, 1, 1), 1.0)
	em.albedo_texture = _glyph_tex
	em.albedo_color = Color(1.0, 0.7, 0.3)
	em.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	em.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	em.cull_mode = BaseMaterial3D.CULL_DISABLED
	for k in 5:
		var side := -1.0 if k % 2 == 0 else 1.0
		var bp := Vector3(side * 16.6, 13.0, 12.0 - k * 19.0)
		box(Vector3(0.1, 6.2, 2.2), bp, mat(Color(0.12, 0.07, 0.03), 0.9), false, c)
		box(Vector3(0.06, 0.08, 2.4), bp + Vector3(0, 3.1, 0), amber, false, c)
		quad(Vector2(1.9, 1.9), bp + Vector3(-side * 0.08, 0.6, 0), -side * PI / 2.0, em, c)
	interactable("banner", "Look up at the banner", Vector3(-15.8, 2.0, 12.0), Vector3(1.0, 3.0, 2.4), "", false, c)
	kit_holo(Vector3(0, 16.0, -60.0), 0.0, "PSYON", "the pillow for those who dream", Color(0.3, 1.0, 0.7), 12.0)
	kit_holo(Vector3(-6.0, 22.0, -20.0), 0.3, "SALTECH", "2,300 lives, held", Color(0.4, 0.8, 1.0), 9.0)
	skybridge(Vector3(-16.5, 24.0, -48.0), Vector3(16.5, 24.0, -48.0), 3.2)
	skybridge(Vector3(-16.5, 34.0, 2.0), Vector3(16.5, 30.0, 2.0), 2.6)
	for k in 7:
		cable(Vector3(-16.5, 9.0 + k % 3, 18.0 - k * 13.0), Vector3(16.5, 10.0 + (k + 1) % 3, 14.0 - k * 13.0), 1.4)
	# street furniture: a kiosk that knows him, a drone at the kerb, a bench
	var ki := prop("vending_kiosk", Vector3(12.6, 0.12, -8.0), -PI / 2.0, 1.0, true, c)
	if ki == null:
		box(Vector3(1.2, 2.2, 0.8), Vector3(12.6, 1.2, -8.0), _steel, true, c)
	box(Vector3(0.06, 0.6, 0.9), Vector3(12.0, 1.6, -8.0), glow(Color(0.3, 1.0, 0.7), 1.6), false, c)
	var kk := interactable("kiosk", "Use the kiosk", Vector3(12.2, 1.2, -8.0), Vector3(0.8, 2.0, 1.2), "", false, c)
	kk.set_meta("hackable", true)
	prop("delivery_drone", Vector3(-9.2, 0.7, -16.0), 0.4, 1.0, false, c)
	interactable("drone", "The drone", Vector3(-9.2, 0.8, -16.0), Vector3(1.2, 1.0, 1.2), "", false, c)
	for z in [-2.0, -50.0]:
		prop("fire_hydrant", Vector3(10.6, 0.12, z), 0.0, 1.0, true, c)
		prop("metal_trash_can", Vector3(-10.8, 0.12, z + 3.0), 0.0, 1.0, true, c)
	prop("atm", Vector3(-15.6, 0.12, -62.0), PI / 2.0, 1.0, true, c)
	prop("security_camera_01", Vector3(-15.8, 4.5, -28.0), PI / 2.0, 1.0, false, c)
	_bench(c, Vector3(-12.8, 0.12, -40.0))
	var woman := _fig(c, Color(0.62, 0.6, 0.56), Color(0.78, 0.6, 0.48), {"long_hair": true, "hair": Color(0.7, 0.7, 0.7)}, Vector3.ZERO, 0.0, true)
	_seat_fig(woman, Vector3(-12.6, 0.12, -40.0), -PI / 2.0)
	(woman.get_meta("head") as Node3D).rotation.x = -0.35
	interactable("citizen", "The woman on the bench", Vector3(-12.6, 1.0, -40.0), Vector3(0.9, 1.6, 1.4), "", true, c)
	# people walking: frames, or no eyes and no need of them
	var coats := [Color(0.12, 0.12, 0.14), Color(0.55, 0.56, 0.6), Color(0.1, 0.14, 0.18), Color(0.3, 0.1, 0.12),
		Color(0.7, 0.7, 0.68), Color(0.2, 0.16, 0.12)]
	var skins := [Color(0.85, 0.66, 0.52), Color(0.6, 0.42, 0.3), Color(0.4, 0.28, 0.2), Color(0.92, 0.78, 0.66)]
	for i in 14:
		var side := -1.0 if i % 2 == 0 else 1.0
		var x := side * rng.randf_range(11.8, 14.8)
		var eyeless := i % 3 == 0
		var f := _fig(c, coats[i % coats.size()], skins[i % skins.size()], {"visor": not eyeless, "long_hair": i % 4 == 1},
			Vector3(x, 0.12, rng.randf_range(-70.0, 20.0)), 0.0, eyeless)
		peds.append({"node": f, "z0": -78.0, "z1": 22.0, "dir": -1.0 if i % 3 != 1 else 1.0,
			"speed": rng.randf_range(1.0, 1.4), "phase": rng.randf() * TAU})
		if peds[-1]["dir"] > 0.0:
			f.rotation.y = PI
	# in the plaza, a few who stand facing the Tower with their faces up
	for i in 6:
		var f := _fig(c, coats[(i + 2) % coats.size()], skins[i % skins.size()], {}, Vector3(-9.0 + i * 3.4, 0.03, -116.0 - (i % 2) * 2.0), 0.0, true)
		(f.get_meta("head") as Node3D).rotation.x = 0.5
	traffic = TrafficS.new()
	traffic.lanes = [[-5.0, 5.5, 1.0], [5.0, 6.5, -1.0], [-2.5, 11.0, 1.0], [2.5, 13.0, -1.0]]
	traffic.s_min = -140.0
	traffic.s_max = 60.0
	traffic.count = 8
	traffic.tower_top = Vector3(0, 470, TOWER_Z)
	traffic.drone_box = AABB(Vector3(-120, 30, -200), Vector3(240, 80, 260))
	traffic.drone_count = 140
	c.add_child(traffic)
	traffic.setup(main, self)


## Burn: the street run by hand. Sodium lamps on poles somebody set in
## concrete, bulbs strung across, the ad frames empty, painted boards.
func _city_burn(c: Node3D) -> void:
	var sod := Color(1.0, 0.62, 0.3)
	var pole := mat(Color(0.3, 0.24, 0.18), 0.9)
	for k in 6:
		for side: float in [-1.0, 1.0]:
			var p := Vector3(side * 10.6, 0, 8.0 - k * 17.0)
			cyl(0.1, 0.12, 5.2, p + Vector3(0, 2.6, 0), pole, 6, c)
			sphere(0.22, p + Vector3(0, 5.3, 0), glow(sod, 2.6), 8, c)
			if (k + (1 if side > 0.0 else 0)) % 2 == 0:
				_lamp(c, p + Vector3(0, 5.0, 0), sod, 1.5, 14.0)
	var bulb := glow(Color(1.0, 0.85, 0.55), 2.2)
	var wire := mat(Color(0.05, 0.05, 0.05), 0.8)
	for k in 6:
		var z := 12.0 - k * 16.0
		var a := Vector3(-15.0, 7.0, z)
		var b := Vector3(15.0, 7.0, z - 4.0)
		var prev := a
		for i in range(1, 11):
			var t := i / 10.0
			var pnt := a.lerp(b, t) - Vector3(0, 1.4 * 4.0 * t * (1.0 - t), 0)
			stick(prev, pnt, 0.02, wire, c)
			sphere(0.09, pnt - Vector3(0, 0.12, 0), bulb, 6, c)
			prev = pnt
	for k in 2:
		_lamp(c, Vector3(0, 6.0, -100.0 - k * 26.0), sod, 1.4, 20.0)
	# the hand-painted count
	var board := mat(Color(0.32, 0.26, 0.18), 0.95)
	box(Vector3(0.2, 2.6, 5.0), Vector3(-15.0, 2.6, -34.0), board, false, c)
	label("DAYS SINCE THE\nLAST OUTAGE\n3,287", Vector3(-14.88, 2.7, -34.0), PI / 2.0, 0.006, Color(0.95, 0.9, 0.78), c, false)
	interactable("counter", "Read the board", Vector3(-14.3, 1.6, -34.0), Vector3(1.2, 2.6, 5.0), "", false, c)
	label("NO SCREENS", Vector3(15.0, 3.2, -10.0), -PI / 2.0, 0.008, Color(0.95, 0.4, 0.25), c, false)
	# the lineman on his ladder, and the dead kiosk with a cactus in its face
	var lad := mat(Color(0.6, 0.55, 0.2), 0.7)
	for sx: float in [-0.25, 0.25]:
		stick(Vector3(9.6 + sx, 0.1, -22.0), Vector3(10.2 + sx, 4.6, -22.0), 0.03, lad, c)
	for r in 8:
		var y := 0.5 + r * 0.55
		var x := 9.6 + (y / 4.6) * 0.6
		stick(Vector3(x - 0.25, y, -22.0), Vector3(x + 0.25, y, -22.0), 0.02, lad, c)
	var lm := _fig(c, Color(0.85, 0.5, 0.12), Color(0.6, 0.42, 0.3), {"long_coat": false}, Vector3(10.0, 2.2, -22.3), -PI / 2.0)
	for a in lm.get_meta("arms"):
		(a as Node3D).rotation.x = -2.4
	interactable("citizen", "The lineman", Vector3(10.0, 2.6, -22.0), Vector3(1.0, 2.2, 1.0), "", false, c)
	var ki := prop("vending_kiosk", Vector3(12.6, 0.12, -8.0), -PI / 2.0, 1.0, true, c)
	if ki == null:
		box(Vector3(1.2, 2.2, 0.8), Vector3(12.6, 1.2, -8.0), _steel, true, c)
	cyl(0.14, 0.16, 0.5, Vector3(12.0, 1.7, -8.0), mat(Color(0.2, 0.36, 0.22), 0.8), 6, c)
	interactable("kiosk", "The old kiosk", Vector3(12.2, 1.2, -8.0), Vector3(0.8, 2.0, 1.2), "", false, c)
	for z in [-2.0, -50.0]:
		prop("Barrel_01", Vector3(-11.0, 0.12, z), 0.0, 1.0, true, c)
		prop("plastic_crate_03", Vector3(11.2, 0.12, z + 4.0), 0.3, 1.0, true, c)
	prop("power_box_01", Vector3(-15.4, 0.12, -14.0), PI / 2.0, 1.0, true, c)
	prop("utility_box_02", Vector3(15.4, 0.12, -44.0), -PI / 2.0, 1.0, true, c)
	# a few people out late, nobody wearing frames
	for i in 6:
		var side := -1.0 if i % 2 == 0 else 1.0
		var f := _fig(c, [Color(0.3, 0.25, 0.2), Color(0.2, 0.22, 0.26), Color(0.4, 0.2, 0.15)][i % 3],
			[Color(0.85, 0.66, 0.52), Color(0.5, 0.35, 0.25)][i % 2], {"long_hair": i == 3}, Vector3(side * 13.0, 0.12, -10.0 - i * 11.0), 0.0)
		peds.append({"node": f, "z0": -78.0, "z1": 22.0, "dir": -1.0, "speed": rng.randf_range(0.8, 1.1), "phase": rng.randf() * TAU})


## A few warm windows somebody is home behind, on the dead glass.
func _hand_windows(c: Node3D, side: float, cz: float, w: float, h: float) -> void:
	var warm := glow(Color(1.0, 0.7, 0.4), 1.2)
	for i in 4:
		var y := rng.randf_range(4.0, minf(h - 2.0, 30.0))
		var z := cz + rng.randf_range(-w / 2.0 + 1.5, w / 2.0 - 1.5)
		quad(Vector2(1.4, 1.1), Vector3(side * 16.95, y, z), -side * PI / 2.0, warm, c)


func _bench(c: Node3D, p: Vector3) -> void:
	var wood := pbr("woodfloor", Vector3(1, 1, 1), false, Color(0.8, 0.7, 0.6))
	box(Vector3(0.6, 0.06, 2.0), p + Vector3(0, 0.45, 0), wood, true, c)
	box(Vector3(0.06, 0.5, 2.0), p + Vector3(-0.28, 0.75, 0), wood, false, c)
	for sz: float in [-0.85, 0.85]:
		box(Vector3(0.5, 0.45, 0.06), p + Vector3(0, 0.22, sz), _steel, false, c)


# ------------------------------------------------------------------ the lobby and the lift

## The residential lobby (book ch. 2: "sleek, sterile, more tech office than
## home. Exposed vents ran along the ceiling like metallic arteries,
## faux-wood paneling streaked with the ubiquitous Psyon green"). In Burn it
## is the Hall. The lift car is behind the doors on the north wall.
func _lobby() -> void:
	var c: Node3D = sets["lobby"]
	var o := LOBBY
	var panel := pbr("woodfloor", Vector3(3, 2, 1), false, Color(0.8, 0.72, 0.62) if _psy() else Color(0.55, 0.5, 0.45))
	var floor_m := pbr("concrete", Vector3(4, 3, 1), false, Color(0.7, 0.72, 0.72) if _psy() else Color(0.5, 0.47, 0.44), 0.4 if _psy() else 1.0)
	_room(c, o, 16.0, 12.0, 4.8, floor_m, panel, mat(Color(0.12, 0.12, 0.13), 0.8), 1.8, 0.0)
	# the green streaks in the panelling, and the vents overhead
	var green := glow(Color(0.25, 1.0, 0.65), 1.8) if _psy() else mat(Color(0.85, 0.82, 0.75), 0.95)
	for sd: float in [-1.0, 1.0]:
		for k in 4:
			box(Vector3(0.04, 3.6, 0.12) if _psy() else Vector3(0.03, 1.2, 0.9), o + Vector3(sd * 7.88, 2.2, -4.0 + k * 2.6), green, false, c)
	for x: float in [-4.5, 0.0, 4.5]:
		var v := cyl(0.35, 0.35, 12.0, o + Vector3(x, 4.25, 0), _steel, 10, c)
		v.rotation.x = PI / 2.0
		for k in 4:
			var r := cyl(0.4, 0.4, 0.12, o + Vector3(x, 4.25, -4.5 + k * 3.0), _dark, 10, c)
			r.rotation.x = PI / 2.0
	# the lift: frame, display, the two door leaves, the car behind
	box(Vector3(2.4, 0.3, 0.3), o + Vector3(0, 2.55, -5.95), _silver, false, c)
	for sd: float in [-1.0, 1.0]:
		box(Vector3(0.3, 2.6, 0.3), o + Vector3(sd * 1.05, 1.3, -5.95), _silver, false, c)
	for sd: float in [-1.0, 1.0]:
		var leaf := box(Vector3(0.82, 2.4, 0.06), o + Vector3(sd * 0.4, 1.2, -6.05), _steel, false, c)
		lift_doors.append(leaf)
		no_batch.append(leaf)
	var cz := -7.4
	box(Vector3(2.6, 0.1, 2.6), o + Vector3(0, -0.05, cz), mat(Color(0.18, 0.18, 0.2), 0.5, 0.4), true, c)
	box(Vector3(2.6, 0.1, 2.6), o + Vector3(0, 2.85, cz), _dark, false, c)
	box(Vector3(2.6, 2.8, 0.1), o + Vector3(0, 1.4, cz - 1.3), _steel, true, c)
	for sd: float in [-1.0, 1.0]:
		box(Vector3(0.1, 2.8, 2.6), o + Vector3(sd * 1.3, 1.4, cz), _steel, true, c)
	box(Vector3(1.6, 0.06, 1.6), o + Vector3(0, 2.79, cz), glow(Color(0.9, 1.0, 0.95) if _psy() else Color(1.0, 0.85, 0.6), 1.6), false, c)
	box(Vector3(0.04, 0.05, 2.4), o + Vector3(1.24, 1.0, cz), _silver, false, c)
	box(Vector3(0.04, 0.05, 2.4), o + Vector3(-1.24, 1.0, cz), _silver, false, c)
	# the button panel: one button with no number on it
	box(Vector3(0.04, 0.9, 0.36), o + Vector3(1.23, 1.35, cz + 0.9), _dark, false, c)
	for i in 6:
		sphere(0.025, o + Vector3(1.2, 1.1 + i * 0.09, cz + 0.9), glow(Color(1.0, 0.8, 0.4), 1.5), 6, c)
	box(Vector3(0.6, 0.22, 0.04), o + Vector3(0, 2.4, cz - 1.24), _dark, false, c)
	lift_l = label("1", o + Vector3(0, 2.4, cz - 1.21), 0.0, 0.0022, Color(1.0, 0.7, 0.3), c, false)
	lift_l.double_sided = true
	_lamp(c, o + Vector3(0, 2.4, cz), Color(0.9, 1.0, 0.95), 0.9, 4.0)
	var call := interactable("elevator", "Call the lift", o + Vector3(1.4, 1.3, -5.7), Vector3(0.6, 1.2, 0.4), "", false, c)
	call.set_meta("hackable", true)
	box(Vector3(0.14, 0.24, 0.04), o + Vector3(1.4, 1.3, -5.83), glow(Color(1.0, 0.75, 0.35), 1.6), false, c)
	if _psy():
		_lamp(c, o + Vector3(-4.0, 3.8, 1.0), Color(0.8, 1.0, 0.92), 1.4, 11.0)
		_lamp(c, o + Vector3(4.0, 3.8, -2.0), Color(0.8, 1.0, 0.92), 1.4, 11.0)
		# the plaque, the reception desk, two cacti in steel pots
		box(Vector3(0.08, 1.0, 1.6), o + Vector3(-7.86, 1.8, 2.0), mat(Color(0.5, 0.36, 0.16), 0.3, 0.9), false, c)
		label("THE FIRST TO SEE\nDr. A. Turan  ·  Emmet", o + Vector3(-7.8, 1.85, 2.0), PI / 2.0, 0.0025, Color(0.95, 0.85, 0.6), c, false)
		interactable("plaque", "Read the plaque", o + Vector3(-7.5, 1.8, 2.0), Vector3(0.6, 1.2, 1.8), "", false, c)
		box(Vector3(3.6, 1.1, 0.8), o + Vector3(4.0, 0.55, 2.5), _jade, true, c)
		box(Vector3(3.7, 0.06, 0.9), o + Vector3(4.0, 1.12, 2.5), _silver, false, c)
		quad(Vector2(0.9, 0.5), o + Vector3(4.0, 1.5, 2.4), 0.0, glow(Color(0.2, 0.8, 0.6), 1.2), c)
		interactable("greeter", "The lobby", o + Vector3(4.0, 1.0, 2.5), Vector3(3.6, 1.2, 1.0), "", false, c)
		for x: float in [-6.5, 6.5]:
			cyl(0.35, 0.28, 0.6, o + Vector3(x, 0.3, -4.8), _steel, 10, c)
			cyl(0.18, 0.22, 1.5, o + Vector3(x, 1.35, -4.8), mat(Color(0.2, 0.36, 0.22), 0.8), 8, c)
		prop("security_camera_01", o + Vector3(7.5, 4.0, 5.5), PI * 0.75, 1.0, false, c)
	else:
		_lamp(c, o + Vector3(-3.0, 3.6, 0.0), Color(1.0, 0.78, 0.5), 1.4, 12.0)
		_lamp(c, o + Vector3(3.5, 3.0, -3.5), Color(1.0, 0.7, 0.4), 0.8, 8.0)
		# the notice board of names, folding chairs, the fuse locker, a kettle
		box(Vector3(0.06, 1.6, 2.4), o + Vector3(-7.86, 1.8, 2.0), mat(Color(0.55, 0.42, 0.28), 1.0), false, c)
		for k in 14:
			box(Vector3(0.02, 0.18, 0.3), o + Vector3(-7.82, 1.2 + (k % 7) * 0.18, 1.4 + (k / 7) * 1.0), mat(Color(0.92, 0.9, 0.84), 1.0), false, c)
		label("MISSING SINCE DAY 7", o + Vector3(-7.8, 2.5, 2.0), PI / 2.0, 0.0025, Color(0.2, 0.15, 0.1), c, false)
		interactable("plaque", "Read the notice board", o + Vector3(-7.5, 1.8, 2.0), Vector3(0.6, 1.6, 2.4), "", false, c)
		for i in 8:
			_chair(c, o + Vector3(-2.0 + (i % 4) * 1.2, 0, 1.5 + (i / 4) * 1.4), PI, mat(Color(0.5, 0.4, 0.25), 0.8), _steel)
		prop("fuse_panel", o + Vector3(7.7, 1.4, -2.0), -PI / 2.0, 1.0, false, c)
		box(Vector3(1.4, 0.8, 0.7), o + Vector3(5.0, 0.4, 3.5), mat(Color(0.4, 0.32, 0.22), 0.9), true, c)
		cyl(0.1, 0.12, 0.25, o + Vector3(5.0, 0.93, 3.5), _steel, 8, c)
		interactable("greeter", "The Hall", o + Vector3(5.0, 0.9, 3.5), Vector3(1.6, 1.2, 1.0), "", false, c)


func _doors(open: bool, t := 0.9) -> void:
	for i in lift_doors.size():
		var d: Node3D = lift_doors[i]
		if not is_instance_valid(d):
			continue
		var sx := -1.0 if i == 0 else 1.0
		var x := LOBBY.x + sx * (1.2 if open else 0.4)
		if t <= 0.02:
			d.position.x = x
		else:
			create_tween().tween_property(d, "position:x", x, t).set_trans(Tween.TRANS_SINE)


## The ride. The voice is Carl's, slowed and pitched down; the line is the
## one the lift said to him every night ("Welcome back, Carl"); Ezra thinks
## about bread. kind: sit1 | home | refuse | burn.
func _ride(kind: String) -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var pl: CharacterBody3D = main.player
	f["cinematic"] = true
	var car := LOBBY + Vector3(0, 0.05, -7.6)
	if area != "lobby":
		await ui.fade_to(1.0, 0.6)
		_show("lobby")
		_doors(true, 0.01)
		pl.position = car
		pl.yaw = PI
		_snap_cam()
		await ui.fade_to(0.0, 0.6)
	else:
		main.play("ding", -8.0)
		_doors(true)
		await _sleep(1.0)
		var tw := create_tween()
		tw.tween_property(pl, "position", car, 1.6)
		tw.parallel().tween_property(pl, "yaw", PI, 1.6)
		await tw.finished
	_doors(false)
	main.play("door", -10.0)
	_cam_auto = false
	tcam.global_position = LOBBY + Vector3(0.95, 2.2, -6.6)
	tcam.look_at(LOBBY + Vector3(-0.1, 1.5, -7.7), Vector3.UP)
	var spec := {"sit1": [1.0, 351.0, " "], "home": [0.0, 86.0, "86"], "refuse": [1.0, 61.0, "61"], "burn": [0.0, -4.0, "RAIL CUT"]}
	var s: Array = spec[kind]
	var tw2 := create_tween()
	tw2.tween_method(func(v: float):
		if is_instance_valid(lift_l):
			lift_l.text = ("B%d" % int(-v)) if v < 0.0 else str(int(v)), float(s[0]), float(s[1]), 3.5 if not main._selftest else 0.3)
	await _sleep(1.2)
	var voice: String = LINES["lift"][{"sit1": "sit_voice", "home": "home_voice", "refuse": "refuse_voice", "burn": "burn_voice"}[kind]]
	_speak(voice)
	await ui.say("CARL", "[color=#a9c2d6]" + voice + "[/color]")
	var think: String = LINES["lift"][{"sit1": "sit_think", "home": "home_think", "refuse": "refuse_think", "burn": "burn_think"}[kind]]
	await ui.think(think)
	ui.close()
	if tw2.is_running():
		await tw2.finished
	if is_instance_valid(lift_l):
		lift_l.text = str(s[2])
	if kind == "sit1":
		_speak(LINES["lift"]["sit_voice2"])
		await ui.say("CARL", "[color=#a9c2d6]" + LINES["lift"]["sit_voice2"] + "[/color]")
		await ui.think(LINES["lift"]["sit_think2"])
		ui.close()
	await _sleep(0.8)
	main.play("ding", -6.0)
	await ui.fade_to(1.0, 0.8)
	_cam_auto = true
	f.erase("cinematic")


## Off the lift into a place: show it, put Ezra there, fade in.
func _arrive(a: String, pos: Vector3, yaw: float) -> void:
	_show(a)
	var pl: CharacterBody3D = main.player
	pl.position = pos
	pl.velocity = Vector3.ZERO
	pl.yaw = yaw
	pl.pitch = 0.0
	_seated = false
	_last_pos = pos
	_snap_cam()
	await main.ui.fade_to(0.0, 0.8)


# ------------------------------------------------------------------ the voices

## One sung vowel at a pitch, as a wavetable: harmonics of f0 shaped by
## three formants (a child's, or a man's slowed down). Cached.
const VOWELS := {
	"a": [[1000.0, 140.0, 1.0], [1500.0, 170.0, 0.6], [3200.0, 260.0, 0.22]],
	"o": [[620.0, 110.0, 1.0], [1000.0, 130.0, 0.5], [3000.0, 250.0, 0.14]],
	"e": [[520.0, 100.0, 1.0], [2300.0, 200.0, 0.45], [3300.0, 260.0, 0.25]],
	"i": [[400.0, 90.0, 1.0], [2900.0, 250.0, 0.5], [3700.0, 300.0, 0.3]],
	"u": [[420.0, 90.0, 1.0], [1000.0, 120.0, 0.22], [3000.0, 250.0, 0.08]],
}


func _table(f0: float, vowel: String, fscale := 1.0) -> PackedFloat32Array:
	var key := "%d|%s|%.2f" % [int(f0), vowel, fscale]
	if _tables.has(key):
		return _tables[key]
	var n := 512
	var amps: Array = []
	var k := 1
	while k * f0 < 4800.0 and k <= 24:
		var fr := k * f0
		var a := 0.0
		for fm: Array in VOWELS[vowel]:
			var d := (fr - float(fm[0]) * fscale) / float(fm[1])
			a += float(fm[2]) / (1.0 + d * d)
		amps.append(a / pow(k, 0.4))
		k += 1
	var t := PackedFloat32Array()
	t.resize(n)
	var peak := 0.0001
	for i in n:
		var ph := TAU * i / n
		var v := 0.0
		for j in amps.size():
			v += amps[j] * sin(ph * (j + 1))
		t[i] = v
		peak = maxf(peak, absf(v))
	for i in n:
		t[i] /= peak
	_tables[key] = t
	return t


static func _midi(m: float) -> float:
	return 440.0 * pow(2.0, (m - 69.0) / 12.0)


## Render notes [[midi, seconds, vowel], ...] to a clip (the lullaby's three
## notes on the wall; Carl's voice in the lift).
func _render(notes: Array, fscale: float, vib: float, glide: float) -> AudioStreamWAV:
	var rate := 22050
	var total := 0.0
	for nt: Array in notes:
		total += float(nt[1])
	var s := PackedFloat32Array()
	s.resize(int((total + 0.4) * rate))
	var ph := 0.0
	var i := 0
	for nt: Array in notes:
		var f0 := _midi(float(nt[0]))
		var tab := _table(f0, str(nt[2]), fscale)
		var cnt := int(float(nt[1]) * rate)
		for j in cnt:
			var tt := float(j) / rate
			var env := minf(1.0, tt / 0.04) * minf(1.0, (float(nt[1]) - tt) / 0.07)
			var fr := f0 * (1.0 + vib * sin(TAU * 5.3 * tt) * minf(1.0, tt / 0.25)) * (1.0 - glide * tt / float(nt[1]))
			ph = fmod(ph + fr / rate * 512.0, 512.0)
			var a := int(ph)
			var v := lerpf(tab[a], tab[(a + 1) % 512], ph - a)
			s[i] = v * env * 0.35
			i += 1
	# a small room
	for d: int in [1700, 2900]:
		for j in range(d, s.size()):
			s[j] += s[j - d] * 0.22
	var b := PackedByteArray()
	b.resize(s.size() * 2)
	for j in s.size():
		b.encode_s16(j * 2, int(clampf(s[j], -1.0, 1.0) * 30000.0))
	var w := AudioStreamWAV.new()
	w.format = AudioStreamWAV.FORMAT_16_BITS
	w.mix_rate = rate
	w.data = b
	return w


## Carl's voice in the lift: syllables of a man's voice with the formants
## pulled down, slowed, the pitch falling at the end of the line.
func _speak(text: String) -> void:
	var notes: Array = []
	var vs := ["a", "e", "o", "u", "i"]
	var words := text.split(" ", false)
	var n := 0
	for w in words:
		var syl := maxi(1, int(ceil(w.length() / 3.5)))
		for k in syl:
			var fall := 1.0 - float(n) / maxf(1.0, words.size() * 1.4)
			notes.append([40.0 + 3.0 * fall + (1.0 if k == 0 else 0.0), 0.17 if k < syl - 1 else 0.24, vs[(n + w.length()) % vs.size()]])
			n += 1
		notes.append([38.0, 0.06, "u"])
	_voice.stream = _render(notes, 0.82, 0.004, 0.08)
	_voice.volume_db = -4.0
	_voice.pitch_scale = 0.9
	_voice.play()


# ------------------------------------------------------------------ Sit and Copy: the floor with no number

## A corridor with no numbers on the doors, and at the end the room where a
## chair faces a wall of light. The wall is the city: one bar a district,
## SalTech's never moving (A3-E1: "The lights in Red Rock Plaza. The power
## grid. The life support at SalTech. They all needed to stay on.").
func _nonum() -> void:
	var c: Node3D = sets["nonum"]
	var o := NONUM
	var carpet := pbr("carpet", Vector3(2, 8, 1), false, Color(0.55, 0.55, 0.6))
	var plaster := pbr("plaster", Vector3(4, 1, 1), false, Color(0.82, 0.84, 0.86))
	var ceil_m := mat(Color(0.75, 0.76, 0.78), 0.9)
	var door_m := pbr("woodfloor", Vector3(1, 2, 1), false, Color(0.45, 0.36, 0.3))
	# the corridor, z +1.5 .. -16
	box(Vector3(3.0, 0.1, 17.5), o + Vector3(0, -0.05, -7.25), carpet, true, c)
	box(Vector3(3.0, 0.1, 17.5), o + Vector3(0, 2.85, -7.25), ceil_m, false, c)
	for sd: float in [-1.0, 1.0]:
		box(Vector3(0.2, 2.8, 17.5), o + Vector3(sd * 1.6, 1.4, -7.25), plaster, true, c)
		for k in 4:
			var dz := -2.0 - k * 3.6
			box(Vector3(0.06, 2.1, 1.0), o + Vector3(sd * 1.48, 1.05, dz), door_m, false, c)
			box(Vector3(0.05, 0.05, 0.14), o + Vector3(sd * 1.44, 1.0, dz + 0.36), _silver, false, c)
			box(Vector3(0.04, 0.16, 0.3), o + Vector3(sd * 1.47, 2.28, dz), plaster, false, c)  # the blank where a number would be
	box(Vector3(3.0, 2.8, 0.2), o + Vector3(0, 1.4, 1.6), _steel, true, c)
	for sd: float in [-1.0, 1.0]:
		box(Vector3(0.7, 2.3, 0.05), o + Vector3(sd * 0.36, 1.15, 1.47), _steel, false, c)
	interactable("corridor", "The doors", o + Vector3(-1.3, 1.2, -5.6), Vector3(0.3, 2.0, 1.2), "", false, c)
	for k in 2:
		var lm := box(Vector3(0.5, 0.04, 0.5), o + Vector3(0, 2.79, -3.0 - k * 8.0), glow(Color(1.0, 0.95, 0.85), 1.4), false, c)
		lm.name = "ceil%d" % k
		_lamp(c, o + Vector3(0, 2.5, -3.0 - k * 8.0), Color(1.0, 0.92, 0.8), 0.9, 7.0)
	# the room, z -16 .. -26
	var rz := -21.0
	box(Vector3(9.0, 0.1, 10.0), o + Vector3(0, -0.05, rz), carpet, true, c)
	box(Vector3(9.0, 0.1, 10.0), o + Vector3(0, 4.05, rz), ceil_m, false, c)
	for sd: float in [-1.0, 1.0]:
		box(Vector3(0.2, 4.0, 10.0), o + Vector3(sd * 4.6, 2.0, rz), plaster, true, c)
		box(Vector3(3.0, 4.0, 0.2), o + Vector3(sd * 3.0, 2.0, -16.0), plaster, true, c)
	box(Vector3(3.0, 1.2, 0.2), o + Vector3(0, 3.4, -16.0), plaster, false, c)
	# the wall of light
	var wl := newmat(Color(1, 1, 1), 1.0)
	wl.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	wl.albedo_color = Color(0.3, 0.28, 0.26)
	box(Vector3(9.0, 4.0, 0.2), o + Vector3(0, 2.0, -26.1), wl, true, c)
	var names := ["SPINE", "HARMONY GREEN", "SOUTHTOWN", "RED ROCK", "COGNIZO", "SALTECH"]
	for i in names.size():
		var x := -3.4 + i * 1.36
		var lit: bool = names[i] != "RED ROCK" or red_lit
		var bh := 3.2 if names[i] == "SALTECH" else 2.2 + fmod(i * 0.37, 0.8)
		var bm := glow(Color(1.0, 0.8, 0.5), 3.0) if lit else mat(Color(0.03, 0.02, 0.02), 0.9)
		if names[i] == "RED ROCK" and red_lit:
			bm = glow(Color(1.0, 0.75, 0.5), 7.0)
		box(Vector3(0.7, bh, 0.06), o + Vector3(x, 0.5 + bh / 2.0, -25.96), bm, false, c)
		label(names[i], o + Vector3(x, 0.3, -25.9), 0.0, 0.0016, Color(0.95, 0.88, 0.75), c, false)
	label("LIFE SUPPORT  2,300", o + Vector3(3.4, 3.85, -25.9), 0.0, 0.0016, Color(0.95, 0.88, 0.75), c, false)
	var wall := interactable("wall", "Look at the light", o + Vector3(0, 2.0, -25.6), Vector3(8.6, 3.8, 0.6), "", false, c)
	wall.set_meta("hackable", true)
	_lamp(c, o + Vector3(-2.5, 2.2, -24.8), Color(1.0, 0.92, 0.8), 1.3, 10.0)
	_lamp(c, o + Vector3(2.5, 2.2, -24.8), Color(1.0, 0.92, 0.8), 1.3, 10.0)
	# the chair, worn where he sits
	var wood := pbr("woodfloor", Vector3(1, 1, 1), false, Color(0.62, 0.48, 0.36))
	_chair(c, o + Vector3(0, 0, -21.5), 0.0, wood, wood)
	interactable("chair", "Sit down", o + Vector3(0, 0.6, -21.5), Vector3(0.6, 1.2, 0.6), "", false, c)
	interactable("lift_back", LINES["nonum"]["lift_back"], o + Vector3(0, 1.2, 1.2), Vector3(1.6, 2.2, 0.4), "", false, c)


# ------------------------------------------------------------------ Sit and Copy: 86D

## Home, twenty-five years on. The same flat (book ch. 2: the door that
## slides open "with a mechanical sigh"), every device alive and polite.
## Monica older, eyeless since the chapel. Paul, who is not Carl (Sit), or
## Carl, who is (Copy). Four places laid. What was traded is gone.
func _home() -> void:
	var c: Node3D = sets["home"]
	var o := HOME
	var floor_m := pbr("woodfloor", Vector3(5, 4, 1), false, Color(0.75, 0.66, 0.58))
	var wall_m := pbr("plaster", Vector3(4, 1, 1), false, Color(0.8, 0.78, 0.74))
	_room(c, o, 12.0, 9.0, 3.0, floor_m, wall_m, mat(Color(0.86, 0.86, 0.85), 0.9), 7.0, 0.0)
	# the window wall: glass over the lit city, Red Rock dark or bright
	var gl := newmat(Color(0.05, 0.08, 0.1, 0.25), 0.05, 0.6)
	gl.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	box(Vector3(7.0, 2.4, 0.05), o + Vector3(0, 1.4, -4.6), gl, true, c)
	for k in 5:
		box(Vector3(0.08, 3.0, 0.12), o + Vector3(-3.5 + k * 1.75, 1.5, -4.6), _dark, false, c)
	var k_m := _kit_mats()
	for i in 14:
		var bx := -60.0 + i * 9.0 + rng.randf_range(-2, 2)
		var bz := -60.0 - rng.randf_range(0, 50)
		var bh := rng.randf_range(40, 120)
		var wi := i % 6
		var bp := o + Vector3(bx, -60.0 + bh / 2.0, bz)
		box(Vector3(7, bh, 7), bp, k_m["walls"][wi], false, c)
		quad(Vector2(6.8, bh - 4.0), bp + Vector3(0, 0, 3.52), 0.0, k_m["lits"][wi], c)
	var rr := o + Vector3(-30.0, -40.0, -95.0)
	for i in 30:
		var p := rr + Vector3(rng.randf_range(-14, 14), rng.randf_range(-6, 6), rng.randf_range(-8, 8))
		box(Vector3(1.2, 1.2, 1.2), p, glow(Color(1.0, 0.6, 0.3), 5.0) if red_lit else mat(Color(0.04, 0.03, 0.03), 1.0), false, c)
	interactable("window", "Look out", o + Vector3(1.5, 1.4, -4.3), Vector3(4.0, 2.0, 0.4), "", false, c)
	# the kitchen: counter, the synth-dispenser, the fridge with the drawing
	var counter_m := mat(Color(0.88, 0.88, 0.86), 0.3)
	box(Vector3(0.7, 0.92, 4.0), o + Vector3(5.6, 0.46, 1.0), counter_m, true, c)
	box(Vector3(0.75, 0.05, 4.1), o + Vector3(5.6, 0.94, 1.0), _dark, false, c)
	box(Vector3(0.5, 0.7, 0.5), o + Vector3(5.6, 1.3, 2.4), _steel, false, c)
	box(Vector3(0.04, 0.2, 0.3), o + Vector3(5.33, 1.4, 2.4), glow(Color(0.3, 1.0, 0.7), 1.6), false, c)
	box(Vector3(0.8, 2.0, 0.8), o + Vector3(5.5, 1.0, -2.6), _silver, true, c)
	if not main.traded.has("drawing"):
		var dm := newmat(Color(1, 1, 1), 0.9)
		dm.albedo_texture = _glyph_tex
		dm.albedo_color = Color(0.9, 0.3, 0.25)
		box(Vector3(0.02, 0.42, 0.32), o + Vector3(5.09, 1.3, -2.6), mat(Color(0.95, 0.93, 0.88), 1.0), false, c)
		quad(Vector2(0.28, 0.28), o + Vector3(5.08, 1.32, -2.6), -PI / 2.0, dm, c)
	else:
		box(Vector3(0.01, 0.42, 0.32), o + Vector3(5.09, 1.3, -2.6), mat(Color(0.72, 0.74, 0.76), 0.3, 0.8), false, c)
	interactable("fridge", "The fridge", o + Vector3(5.0, 1.3, -2.6), Vector3(0.4, 0.8, 0.8), "", false, c)
	# the table, four places
	var tw := pbr("woodfloor", Vector3(1, 1, 1), false, Color(0.55, 0.42, 0.32))
	box(Vector3(1.0, 0.06, 1.8), o + Vector3(1.5, 0.76, 0.5), tw, true, c)
	for sx: float in [-0.42, 0.42]:
		for sz: float in [-0.8, 0.8]:
			box(Vector3(0.06, 0.74, 0.06), o + Vector3(1.5 + sx, 0.37, 0.5 + sz), tw, false, c)
	var plate := mat(Color(0.95, 0.95, 0.93), 0.2)
	var seats := [[Vector3(0.75, 0, 0.1), -PI / 2.0], [Vector3(0.75, 0, 0.9), -PI / 2.0], [Vector3(2.25, 0, 0.1), PI / 2.0], [Vector3(2.25, 0, 0.9), PI / 2.0]]
	for sdat: Array in seats:
		var sp: Vector3 = sdat[0]
		_chair(c, o + sp, sdat[1], tw, tw)
		cyl(0.13, 0.11, 0.02, o + Vector3(1.5 + (sp.x - 1.5) * 0.45, 0.8, sp.z), plate, 12, c)
	interactable("table", "Sit down to dinner", o + Vector3(1.5, 0.8, 0.5), Vector3(1.2, 0.5, 2.0), "", false, c)
	# the shelf: the trophy and the lion, or the spaces they left; the photo hook
	box(Vector3(2.4, 0.05, 0.35), o + Vector3(-3.0, 1.5, 4.3), tw, false, c)
	if not main.traded.has("trophy"):
		cyl(0.06, 0.08, 0.24, o + Vector3(-3.6, 1.65, 4.3), glow(Color(1.0, 0.8, 0.3), 0.8), 8, c)
	interactable("trophy", "The shelf", o + Vector3(-3.6, 1.6, 4.2), Vector3(0.6, 0.5, 0.4), "", false, c)
	if not main.traded.has("lion"):
		sphere(0.09, o + Vector3(-2.4, 1.62, 4.3), mat(Color(0.8, 0.6, 0.25), 1.0), 8, c)
		sphere(0.06, o + Vector3(-2.4, 1.74, 4.25), mat(Color(0.7, 0.45, 0.18), 1.0), 8, c)
	interactable("lion", "Mira's shelf", o + Vector3(-2.4, 1.6, 4.2), Vector3(0.6, 0.5, 0.4), "", false, c)
	if not main.traded.has("photo"):
		box(Vector3(0.6, 0.45, 0.03), o + Vector3(-5.8, 1.6, 1.0), _dark, false, c)
		quad(Vector2(0.52, 0.37), o + Vector3(-5.78, 1.6, 1.0), PI / 2.0, glow(Color(0.8, 0.45, 0.3), 0.5), c)
	else:
		box(Vector3(0.03, 0.04, 0.04), o + Vector3(-5.88, 1.85, 1.0), _silver, false, c)
	interactable("photo", "The wall by the sofa", o + Vector3(-5.6, 1.6, 1.0), Vector3(0.4, 0.8, 0.8), "", false, c)
	# the sofa, the ceiling lens that never blinks
	var fab := pbr("fabric", Vector3(2, 1, 1), false, Color(0.4, 0.42, 0.46))
	box(Vector3(2.4, 0.45, 0.9), o + Vector3(-3.0, 0.22, 1.0), fab, true, c)
	box(Vector3(2.4, 0.5, 0.2), o + Vector3(-3.0, 0.7, 1.4), fab, false, c)
	sphere(0.12, o + Vector3(0, 2.95, 1.5), _dark, 10, c)
	box(Vector3(0.04, 0.04, 0.04), o + Vector3(0, 2.84, 1.5), glow(Color(1.0, 0.1, 0.1), 3.0), false, c)
	interactable("lens", "The lens in the ceiling", o + Vector3(0, 2.7, 1.5), Vector3(0.6, 0.4, 0.6), "", false, c)
	_lamp(c, o + Vector3(1.5, 2.6, 0.5), Color(1.0, 0.85, 0.65), 1.6, 8.0)
	_lamp(c, o + Vector3(-3.0, 2.6, 2.0), Color(1.0, 0.85, 0.7), 1.0, 7.0)
	_lamp(c, o + Vector3(4.5, 2.6, 0.0), Color(0.9, 0.95, 1.0), 0.8, 6.0)
	# the door Ezra comes in by, the lift lobby beyond it
	box(Vector3(1.0, 2.2, 0.05), o + Vector3(4.5, 1.1, 4.47), _steel, false, c)
	# Monica, older and eyeless; and Paul, or Carl
	var monica := _fig(c, Color(0.42, 0.18, 0.24), Color(0.84, 0.66, 0.55), {"long_hair": true, "hair": Color(0.62, 0.6, 0.6), "long_coat": true},
		o + Vector3(5.0, 0, 1.0), -PI / 2.0, true)
	monica.name = "monica"
	person("monica", "Monica", monica)
	var man: Node3D
	if variant == "copy":
		man = _fig(c, Color(0.2, 0.22, 0.27), Color(0.84, 0.68, 0.56), {"hair": Color(0.6, 0.58, 0.55), "long_coat": true}, Vector3.ZERO, 0.0)
		person("carl", "Dad", man)
	else:
		man = _fig(c, Color(0.2, 0.22, 0.27), Color(0.72, 0.55, 0.42), {"hair": Color(0.3, 0.3, 0.3), "long_coat": true}, Vector3.ZERO, 0.0)
		person("paul", "Paul", man)
	man.name = "man"
	_seat_fig(man, o + Vector3(2.25, 0, 0.9), PI / 2.0)


# ------------------------------------------------------------------ Refuse: 61F, the scene

## Chapter 1 again, twenty-five years on, and Ezra is the one in the frames:
## "The apartment was bigger than mine, and more expensive, too... Papers,
## food wrappers, and what appeared to be sand covered most of the floor."
## The bedroom: the nest of clothes and cardboard funnelling to the desk, the
## sticks taped to the ceiling in two rings inside an oval, two white spheres
## in a patch of dried blood, the Ionware laptop. The man is still here.
func _scene() -> void:
	var c: Node3D = sets["scene"]
	var o := SCENE
	var wp := tex_mat(Tex.wallpaper(), Vector3(6, 2, 1))
	wp.albedo_color = Color(0.62, 0.62, 0.64)
	var floor_m := pbr("woodfloor", Vector3(5, 4, 1), false, Color(0.55, 0.5, 0.45))
	_room(c, o, 12.0, 9.0, 2.9, floor_m, wp, mat(Color(0.7, 0.7, 0.7), 0.9), 4.0, -3.0)
	# the partition: living room west, bedroom east, a doorway between
	box(Vector3(0.15, 2.9, 5.5), o + Vector3(1.0, 1.45, 1.75), wp, true, c)
	box(Vector3(0.15, 0.6, 1.5), o + Vector3(1.0, 2.6, -1.75), wp, false, c)
	box(Vector3(0.15, 2.9, 2.0), o + Vector3(1.0, 1.45, -3.5), wp, true, c)
	# the sliding door to the balcony, the city lit beyond
	var gl := newmat(Color(0.05, 0.08, 0.1, 0.25), 0.05, 0.6)
	gl.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	box(Vector3(4.0, 2.3, 0.05), o + Vector3(-3.0, 1.2, -4.6), gl, true, c)
	var k_m := _kit_mats()
	for i in 8:
		var bp := o + Vector3(-40.0 + i * 10.0, -40.0, -50.0 - i % 3 * 12.0)
		box(Vector3(7, 90, 7), bp, k_m["walls"][i % 6], false, c)
		quad(Vector2(6.8, 86), bp + Vector3(0, 0, 3.52), 0.0, k_m["lits"][i % 6], c)
	# sand and wrappers over the living-room floor
	var sand := decal_mat(Tex.sand(), Color(0.85, 0.72, 0.5))
	for i in 7:
		floor_quad(Vector2(rng.randf_range(1.5, 3.0), rng.randf_range(1.5, 3.0)), o + Vector3(rng.randf_range(-5.0, 0.5), 0.012 + i * 0.001, rng.randf_range(-3.5, 3.5)), rng.randf() * TAU, sand, c)
	var wrap := [mat(Color(0.8, 0.2, 0.2), 0.4), mat(Color(0.9, 0.85, 0.2), 0.4), mat(Color(0.2, 0.5, 0.9), 0.4), mat(Color(0.9, 0.9, 0.9), 0.6)]
	for i in 26:
		var w := box(Vector3(rng.randf_range(0.1, 0.3), 0.02, rng.randf_range(0.08, 0.2)), o + Vector3(rng.randf_range(-5.5, 4.5), 0.02, rng.randf_range(-4.0, 4.0)), wrap[i % 4], false, c)
		w.rotation.y = rng.randf() * TAU
	var bark := pbr("bark", Vector3(1, 1, 1), false, Color(0.6, 0.5, 0.4))
	for i in 10:
		var a := o + Vector3(rng.randf_range(-5.0, 4.0), 0.03, rng.randf_range(-4.0, 3.5))
		stick(a, a + Vector3(rng.randf_range(-0.4, 0.4), 0.0, rng.randf_range(-0.4, 0.4)), 0.012, bark, c)
	var sofa := pbr("fabric", Vector3(2, 1, 1), false, Color(0.3, 0.3, 0.32))
	box(Vector3(2.4, 0.45, 0.9), o + Vector3(-3.0, 0.22, 2.4), sofa, true, c)
	box(Vector3(2.4, 0.5, 0.2), o + Vector3(-3.0, 0.7, 2.8), sofa, false, c)
	# the hall mirror, where the ORA card reads his name
	var mir := newmat(Color(0.7, 0.75, 0.8), 0.05, 1.0)
	box(Vector3(0.04, 1.4, 0.7), o + Vector3(-5.88, 1.4, 3.2), mir, false, c)
	interactable("mirror", "The hall mirror", o + Vector3(-5.6, 1.4, 3.2), Vector3(0.4, 1.4, 0.8), "", false, c)
	# the bedroom: brown carpet, the nest, the desk, the bed
	var carpet := pbr("carpet", Vector3(3, 3, 1), false, Color(0.5, 0.38, 0.28))
	box(Vector3(4.9, 0.02, 8.9), o + Vector3(3.55, 0.011, 0), carpet, false, c)
	var card := mat(Color(0.5, 0.38, 0.24), 1.0)
	var cloth := [mat(Color(0.3, 0.3, 0.36), 1.0), mat(Color(0.5, 0.2, 0.2), 1.0), mat(Color(0.75, 0.72, 0.65), 1.0)]
	for i in 18:
		var t := i / 17.0
		var side := -1.0 if i % 2 == 0 else 1.0
		var p := o + Vector3(lerpf(1.5, 5.4, t), 0.25, side * lerpf(3.8, 1.2, t))
		var b := box(Vector3(rng.randf_range(0.4, 0.8), rng.randf_range(0.2, 0.7), rng.randf_range(0.3, 0.6)), p, card if i % 3 == 0 else cloth[i % 3], false, c)
		b.rotation.y = rng.randf_range(-0.6, 0.6)
	var desk := pbr("woodfloor", Vector3(1, 1, 1), false, Color(0.6, 0.5, 0.4))
	box(Vector3(0.8, 0.05, 1.5), o + Vector3(5.4, 0.75, 0), desk, true, c)
	for sz: float in [-0.65, 0.65]:
		box(Vector3(0.7, 0.73, 0.04), o + Vector3(5.4, 0.37, sz), desk, false, c)
	box(Vector3(0.3, 0.02, 0.42), o + Vector3(5.3, 0.785, 0), _dark, false, c)
	var screen := box(Vector3(0.02, 0.28, 0.42), o + Vector3(5.5, 0.93, 0), glow(Color(0.6, 0.75, 0.9), 1.6), false, c)
	screen.rotation.z = 0.25
	var lap := interactable("laptop", "The laptop", o + Vector3(5.3, 0.9, 0), Vector3(0.6, 0.4, 0.7), "", false, c)
	lap.set_meta("hackable", true)
	var bedm := pbr("fabric", Vector3(2, 2, 1), false, Color(0.62, 0.6, 0.58))
	box(Vector3(2.0, 0.5, 1.6), o + Vector3(3.6, 0.25, -3.6), bedm, true, c)
	box(Vector3(2.0, 0.9, 0.08), o + Vector3(3.6, 0.45, -4.4), desk, false, c)
	# the blood and the two white spheres, out to the optic nerve
	var bl := decal_mat(Tex.blood(), Color(0.45, 0.04, 0.03), 0.4)
	floor_quad(Vector2(1.4, 1.2), o + Vector3(3.2, 0.03, -0.8), 0.4, bl, c)
	var white := mat(Color(0.92, 0.9, 0.86), 0.25)
	var nerve := mat(Color(0.55, 0.22, 0.2), 0.5)
	for sx: float in [-0.13, 0.13]:
		var ep := o + Vector3(3.2 + sx, 0.06, -0.8 + sx * 0.6)
		sphere(0.035, ep, white, 10, c)
		stick(ep, ep + Vector3(0.09, -0.02, 0.06), 0.006, nerve, c)
	interactable("eyes", "The carpet", o + Vector3(3.2, 0.2, -0.8), Vector3(0.9, 0.4, 0.9), "", false, c)
	# the sticks on the ceiling: two concentric rings inside an oval
	for ring in 3:
		var rx: float = [1.25, 0.62, 0.32][ring]
		var rz: float = [0.8, 0.62, 0.32][ring]
		var nseg := 16
		for k in nseg:
			var a0 := TAU * k / nseg
			var a1 := TAU * (k + 1) / nseg
			stick(o + Vector3(3.5 + cos(a0) * rx, 2.86, -0.6 + sin(a0) * rz), o + Vector3(3.5 + cos(a1) * rx, 2.86, -0.6 + sin(a1) * rz), 0.012, bark, c)
	interactable("ceiling", "Look up", o + Vector3(3.5, 2.6, -0.6), Vector3(2.4, 0.4, 1.6), "", false, c)
	# the man, against the bed, head down
	var man := _fig(c, Color(0.32, 0.3, 0.27), Color(0.8, 0.64, 0.52), {"hair": Color(0.25, 0.2, 0.15), "long_coat": false}, Vector3.ZERO, 0.0, true)
	man.position = o + Vector3(3.6, -0.35, -2.55)
	man.rotation.y = 0.0
	Anim.sit(man, -0.05)
	(man.get_meta("head") as Node3D).rotation.x = -0.75
	box(Vector3(0.24, 0.3, 0.02), o + Vector3(3.6, 0.85, -2.8), _blood, false, c)
	var mi := interactable("man", "The man", o + Vector3(3.6, 0.6, -2.7), Vector3(0.8, 1.2, 0.8), "", true, c)
	mi.set_meta("cultist", true)
	_lamp(c, o + Vector3(-2.5, 2.6, 0.0), Color(0.75, 0.85, 1.0), 1.2, 9.0)
	_lamp(c, o + Vector3(3.6, 2.6, -0.5), Color(0.9, 0.92, 1.0), 1.1, 7.0)
	_lamp(c, o + Vector3(5.0, 1.2, 0.0), Color(0.6, 0.75, 0.95), 0.6, 3.0)


# ------------------------------------------------------------------ Burn: the depot at Rail Cut

## The Tunelet depot (A3-S1: "the broken drills, the 160-foot mouth";
## A3-E2: "The depot at dawn. Tyson at the mouth"). Orange sandstone,
## rusted rails, and the morning in the mouth.
func _depot() -> void:
	var c: Node3D = sets["depot"]
	var o := DEPOT
	var stone := pbr("concrete", Vector3(6, 3, 1), false, Color(0.85, 0.5, 0.3))
	var dirt := pbr("concrete", Vector3(6, 12, 1), false, Color(0.55, 0.38, 0.24))
	box(Vector3(26, 0.1, 54), o + Vector3(0, -0.05, -24), dirt, true, c)
	box(Vector3(26, 0.4, 54), o + Vector3(0, 14.2, -24), stone, false, c)
	for sd: float in [-1.0, 1.0]:
		box(Vector3(0.5, 14, 54), o + Vector3(sd * 13.2, 7, -24), stone, true, c)
	box(Vector3(26, 14, 0.5), o + Vector3(0, 7, 3.2), stone, true, c)
	for sd: float in [-1.0, 1.0]:
		box(Vector3(6.0, 14, 0.5), o + Vector3(sd * 10.0, 7, -51.0), stone, true, c)
	box(Vector3(14, 4.0, 0.5), o + Vector3(0, 12.0, -51.0), stone, false, c)
	# the morning in the mouth
	var dawn := newmat(Color(1, 1, 1), 1.0)
	dawn.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	dawn.albedo_color = Color(1.0, 0.72, 0.45)
	quad(Vector2(16, 12), o + Vector3(0, 5, -54.0), 0.0, dawn, c)
	box(Vector3(30, 0.1, 6), o + Vector3(0, -0.05, -54), dirt, true, c)
	_lamp(c, o + Vector3(0, 5.0, -48.0), Color(1.0, 0.7, 0.45), 4.0, 30.0)
	# rails, rusted into the dirt
	var rust := pbr("rust", Vector3(1, 8, 1), false)
	for x: float in [-3.6, -2.4, 2.4, 3.6]:
		box(Vector3(0.1, 0.12, 52), o + Vector3(x, 0.06, -24), rust, false, c)
	for k in 26:
		box(Vector3(3.0, 0.06, 0.25), o + Vector3(-3.0, 0.03, 1.0 - k * 2.0), mat(Color(0.28, 0.2, 0.14), 1.0), false, c)
		box(Vector3(3.0, 0.06, 0.25), o + Vector3(3.0, 0.03, 1.0 - k * 2.0), mat(Color(0.28, 0.2, 0.14), 1.0), false, c)
	# the broken drills
	for sd: float in [-1.0, 1.0]:
		var dp := o + Vector3(sd * 8.5, 2.2, -20.0 - (sd + 1.0) * 6.0)
		var dr := cyl(2.0, 2.0, 7.0, dp, rust, 14, c)
		dr.rotation.x = PI / 2.0
		var cone := cyl(0.2, 2.0, 2.6, dp + Vector3(0, 0, -4.8), _steel, 14, c)
		cone.rotation.x = -PI / 2.0
		solid_box(Vector3(4.2, 4.4, 10.0), dp + Vector3(0, 0, -1.0), c)
	interactable("drills", "The drills", o + Vector3(-8.5, 2.2, -17.0), Vector3(4.4, 4.4, 1.0), "", false, c)
	# rings in the sandstone, every one scored through
	var gm := decal_mat(_glyph_tex, Color(0.25, 0.08, 0.05))
	for k in 5:
		var gp := o + Vector3(-12.9, 2.0 + (k % 2) * 1.5, -6.0 - k * 7.0)
		quad(Vector2(1.6, 1.6), gp, PI / 2.0, gm, c)
		stick(gp + Vector3(0.02, -0.7, -0.7), gp + Vector3(0.02, 0.7, 0.7), 0.025, mat(Color(0.95, 0.9, 0.8), 0.9), c)
	interactable("marks", "The rings on the wall", o + Vector3(-12.5, 2.0, -6.0), Vector3(0.6, 1.8, 1.8), "", false, c)
	# where the faithful sat down, along the rails
	for k in 12:
		floor_quad(Vector2(0.9, 0.7), o + Vector3((-1.0 if k % 2 == 0 else 1.0) * 5.0, 0.012, -4.0 - k * 3.6), rng.randf() * TAU, decal_mat(Tex.blood(37), Color(0.2, 0.12, 0.08)), c)
	prop("old_tyre", o + Vector3(6.0, 0.0, -8.0), 0.3, 1.0, true, c)
	prop("Barrel_01", o + Vector3(-6.5, 0.0, -36.0), 0.0, 1.0, true, c)
	prop("mounted_fluorescent_lights", o + Vector3(0, 8.0, -10.0), 0.0, 1.0, false, c)
	_lamp(c, o + Vector3(0, 6.0, -6.0), Color(1.0, 0.8, 0.55), 1.4, 14.0)
	_lamp(c, o + Vector3(0, 6.0, -26.0), Color(1.0, 0.75, 0.5), 1.2, 14.0)
	box(Vector3(3.0, 2.8, 0.2), o + Vector3(0, 1.4, 2.8), _steel, false, c)
	interactable("mouth", "Walk out into the morning", o + Vector3(0, 2.0, -49.0), Vector3(12.0, 4.0, 1.0), "", false, c)


# ------------------------------------------------------------------ Burn: Last Stop

## The town outside the walls: forty roofs under a red-hill horizon, a water
## tank, the generator in its tin shed, Tyson's porch, a mailbox, a hand-
## painted sign. Nothing here has a screen.
func _town() -> void:
	var c: Node3D = sets["town"]
	var o := TOWN
	var sandm := pbr("concrete", Vector3(40, 40, 1), false, Color(0.82, 0.62, 0.42))
	box(Vector3(220, 0.1, 220), o + Vector3(0, -0.05, -20), sandm, true, c)
	var road := pbr("concrete", Vector3(4, 30, 1), false, Color(0.62, 0.46, 0.32))
	floor_quad(Vector2(6, 70), o + Vector3(0, 0.01, -20), 0.0, road, c)
	# the red hills (canon in every wide shot)
	var hill := mat(Color(0.5, 0.2, 0.12), 1.0)
	for i in 9:
		var a := -1.2 + i * 0.3
		var hp := o + Vector3(sin(a) * 160.0, 0, -20.0 - cos(a) * 160.0)
		var hh := rng.randf_range(14, 30)
		cyl(rng.randf_range(4, 10), rng.randf_range(26, 44), hh, hp + Vector3(0, hh / 2.0, 0), hill, 8, c)
	for k in 12:
		var a := TAU * k / 12.0
		var hc := cyl(6, 30, 16, o + Vector3(sin(a) * 175.0, 8.0, -20.0 + cos(a) * 175.0), hill, 7, c)
		hc.rotation.y = a
	# the shacks, porches out to the road
	var tin := pbr("rust", Vector3(2, 1, 1), false, Color(0.9, 0.85, 0.8))
	var plank := pbr("woodfloor", Vector3(2, 1, 1), false, Color(0.62, 0.5, 0.38))
	var houses := [[-1.0, -2.0], [1.0, -6.0], [-1.0, -14.0], [1.0, -18.0], [1.0, -28.0], [-1.0, -26.0], [-1.0, -38.0]]
	for hd: Array in houses:
		var sd: float = hd[0]
		var hz: float = hd[1]
		var hp := o + Vector3(sd * 9.5, 0, hz)
		box(Vector3(5.0, 3.0, 5.5), hp + Vector3(sd * 1.0, 1.5, 0), tin if int(hz) % 3 == 0 else plank, true, c)
		var roof := box(Vector3(5.8, 0.12, 6.2), hp + Vector3(sd * 1.0, 3.2, 0), tin, false, c)
		roof.rotation.z = sd * 0.12
		box(Vector3(1.8, 0.2, 5.0), hp + Vector3(-sd * 2.4, 0.1, 0), plank, true, c)
		for zz: float in [-2.3, 2.3]:
			box(Vector3(0.1, 2.4, 0.1), hp + Vector3(-sd * 3.2, 1.2, zz), plank, false, c)
		box(Vector3(1.9, 0.08, 5.2), hp + Vector3(-sd * 2.4, 2.45, 0), tin, false, c)
		box(Vector3(0.05, 2.0, 0.9), hp + Vector3(-sd * 1.48, 1.0, 0.8), plank, false, c)
		quad(Vector2(0.7, 0.5), hp + Vector3(-sd * 1.47, 1.7, -1.2), -sd * PI / 2.0, glow(Color(1.0, 0.7, 0.4), 0.8), c)
	# the bulbs strung across the road, dark until the generator runs
	bulbs_m = newglow(Color(1.0, 0.85, 0.55), 0.05)
	var wire := mat(Color(0.05, 0.05, 0.05), 0.8)
	for k in 5:
		var a := o + Vector3(-7.0, 3.4, -1.0 - k * 9.0)
		var b := o + Vector3(7.0, 3.4, -4.0 - k * 9.0)
		var prev := a
		for i in range(1, 9):
			var t := i / 8.0
			var pnt := a.lerp(b, t) - Vector3(0, 0.8 * 4.0 * t * (1.0 - t), 0)
			stick(prev, pnt, 0.015, wire, c)
			sphere(0.08, pnt - Vector3(0, 0.1, 0), bulbs_m, 6, c)
			prev = pnt
		var tl := _lamp(c, o + Vector3(0, 2.6, -2.5 - k * 9.0), Color(1.0, 0.8, 0.5), 0.0, 10.0)
		town_lights.append(tl)
	# the sign at the edge of town
	var post := mat(Color(0.4, 0.3, 0.2), 1.0)
	for sx: float in [-1.1, 1.1]:
		box(Vector3(0.12, 2.6, 0.12), o + Vector3(-4.0 + sx, 1.3, 7.0), post, false, c)
	box(Vector3(2.8, 1.4, 0.08), o + Vector3(-4.0, 2.0, 7.0), mat(Color(0.85, 0.82, 0.72), 1.0), false, c)
	label("LAST STOP\npop. 214\nNO SCREENS PAST THIS SIGN", o + Vector3(-4.0, 2.0, 7.05), PI, 0.0035, Color(0.55, 0.12, 0.08), c, false)
	label("LAST STOP\npop. 214\nNO SCREENS PAST THIS SIGN", o + Vector3(-4.0, 2.0, 6.95), 0.0, 0.0035, Color(0.55, 0.12, 0.08), c, false)
	interactable("sign", "Read the sign", o + Vector3(-4.0, 1.8, 7.0), Vector3(3.0, 2.0, 0.6), "", false, c)
	# the generator in its shed
	var gp := o + Vector3(-8.0, 0, -9.0)
	box(Vector3(3.0, 0.1, 3.0), gp + Vector3(0, 0.05, 0), mat(Color(0.3, 0.3, 0.3), 0.9), false, c)
	box(Vector3(3.0, 0.08, 3.0), gp + Vector3(0, 2.6, 0), tin, false, c)
	for sx: float in [-1.4, 1.4]:
		box(Vector3(0.1, 2.6, 0.1), gp + Vector3(sx, 1.3, -1.4), plank, false, c)
	box(Vector3(3.0, 2.6, 0.08), gp + Vector3(0, 1.3, -1.5), tin, false, c)
	var gen := prop("power_box_01", gp + Vector3(0, 0.1, -0.6), 0.0, 1.0, true, c)
	if gen == null:
		box(Vector3(1.4, 1.0, 0.8), gp + Vector3(0, 0.6, -0.6), mat(Color(0.7, 0.2, 0.1), 0.6, 0.3), true, c)
	prop("Barrel_01", gp + Vector3(1.0, 0.1, 0.6), 0.0, 0.8, true, c)
	box(Vector3(1.2, 0.8, 0.7), gp + Vector3(-0.4, 0.5, 0.2), mat(Color(0.65, 0.22, 0.1), 0.6, 0.4), true, c)
	cyl(0.08, 0.08, 0.6, gp + Vector3(-0.4, 1.1, 0.0), _dark, 6, c)
	interactable("genny", "The generator", gp + Vector3(-0.4, 0.8, 0.6), Vector3(1.4, 1.2, 0.8), "", false, c)
	# Tyson on his porch: old, white-haired, the vaporizer's blue puff
	var tp := o + Vector3(7.3, 0.2, -6.0)
	var rock := pbr("woodfloor", Vector3(1, 1, 1), false, Color(0.5, 0.38, 0.28))
	_chair(c, tp, PI / 2.0, rock, rock)
	var tyson := _fig(c, Color(0.32, 0.28, 0.22), Color(0.42, 0.29, 0.21), {"hair": Color(0.86, 0.86, 0.84), "long_coat": true}, Vector3.ZERO, 0.0)
	_seat_fig(tyson, tp, PI / 2.0, 0.2)
	tyson.position.y += 0.2
	person("tyson", "Tyson", tyson)
	var vap := cyl(0.02, 0.02, 0.14, Vector3(0, 0.0, -0.18), _steel, 6, tyson.get_meta("head"))
	vap.rotation.x = PI / 2.0
	puff = sphere(0.12, tp + Vector3(-0.4, 1.4, 0), newglow(Color(0.4, 0.7, 1.0), 0.8), 8, c)
	no_batch.append(puff)
	box(Vector3(1.6, 0.4, 0.05), o + Vector3(9.0, 2.0, -3.3), mat(Color(0.85, 0.82, 0.72), 1.0), false, c)
	label("POPULASHUN 214", o + Vector3(9.0, 2.0, -3.27), 0.0, 0.002, Color(0.55, 0.12, 0.08), c, false)
	cart_at(c, o + Vector3(5.5, 0, -8.6))
	# the water tank on its stilts, and the cairn beside it
	var tk := o + Vector3(-15.0, 0, -22.0)
	for sx: float in [-1.2, 1.2]:
		for sz: float in [-1.2, 1.2]:
			box(Vector3(0.2, 5.0, 0.2), tk + Vector3(sx, 2.5, sz), plank, false, c)
	cyl(2.0, 2.0, 2.8, tk + Vector3(0, 6.4, 0), tin, 14, c)
	solid_box(Vector3(3, 5, 3), tk + Vector3(0, 2.5, 0), c)
	var cairn := o + Vector3(-11.5, 0, -24.0)
	for i in 7:
		sphere(0.22 - i * 0.02, cairn + Vector3(rng.randf_range(-0.2, 0.2), 0.15 + i * 0.16, rng.randf_range(-0.2, 0.2)), mat(Color(0.6, 0.45, 0.32), 1.0), 6, c)
	box(Vector3(0.08, 1.1, 0.06), cairn + Vector3(0.5, 0.55, 0), plank, false, c)
	box(Vector3(0.5, 0.08, 0.05), cairn + Vector3(0.5, 0.85, 0), plank, false, c)
	interactable("cairn", "The stones by the tank", cairn + Vector3(0.2, 0.6, 0), Vector3(1.2, 1.2, 1.0), "", false, c)
	# Ezra's house at the end of the row: the mailbox and the door
	var ep := o + Vector3(-9.5, 0, -38.0)
	box(Vector3(0.1, 1.1, 0.1), ep + Vector3(5.6, 0.55, 3.0), plank, false, c)
	box(Vector3(0.4, 0.3, 0.5), ep + Vector3(5.6, 1.2, 3.0), mat(Color(0.3, 0.32, 0.35), 0.5, 0.6), false, c)
	interactable("mail", "The mailbox", ep + Vector3(5.6, 1.2, 3.0), Vector3(0.6, 0.6, 0.7), "", false, c)
	interactable("home_door", "Go in", ep + Vector3(1.4, 1.0, 0.8), Vector3(0.4, 2.0, 1.2), "", false, c)
	# two of the town out in the evening
	var kid := _fig(c, Color(0.6, 0.25, 0.2), Color(0.5, 0.35, 0.25), {"scale": 0.62}, o + Vector3(-2.0, 0, -20.0), 0.6)
	peds.append({"node": kid, "z0": -30.0 + TOWN.z, "z1": -8.0 + TOWN.z, "dir": 1.0, "speed": 1.3, "phase": 0.0})
	var wash := _fig(c, Color(0.5, 0.42, 0.3), Color(0.8, 0.62, 0.48), {"long_hair": true}, o + Vector3(12.0, 0, -18.0), -PI / 2.0)
	for a in wash.get_meta("arms"):
		(a as Node3D).rotation.x = -2.0
	stick(o + Vector3(12.6, 1.9, -21.0), o + Vector3(12.6, 1.9, -15.0), 0.01, wire, c)
	for k in 5:
		box(Vector3(0.02, 0.6, 0.5), o + Vector3(12.6, 1.6, -20.4 + k * 1.2), mat([Color(0.8, 0.8, 0.75), Color(0.4, 0.5, 0.7), Color(0.7, 0.3, 0.3)][k % 3], 1.0), false, c)


## Tyson's cart, still with him.
func cart_at(c: Node3D, p: Vector3) -> void:
	box(Vector3(0.8, 0.5, 1.2), p + Vector3(0, 0.7, 0), _steel, true, c)
	for sz: float in [-0.5, 0.5]:
		for sx: float in [-0.4, 0.4]:
			cyl(0.12, 0.12, 0.05, p + Vector3(sx, 0.15, sz), _dark, 8, c).rotation.z = PI / 2.0
	prop("cardboard_box_01", p + Vector3(0, 1.0, 0), 0.4, 0.5, false, c)


# ------------------------------------------------------------------ the beats

func intro() -> void:
	var ui = main.ui
	if main.flags.has("ep_intro"):
		return
	main.flags["ep_intro"] = true
	await _sleep(0.8)
	for t: String in LINES["intro"][variant]:
		await ui.think(t)
	var key := ""
	if variant == "burn":
		key = "burn_yes" if main.flags.has("ezra_home") else "burn_no"
	else:
		key = "home_yes" if main.flags.has("ezra_home") else "home_no"
	await ui.think(LINES["intro"][key])
	ui.close()
	main.update_hud()


func objective() -> String:
	var f: Dictionary = main.flags
	var o: Dictionary = LINES["objective"]
	if f.has("epilogue_done"):
		return ""
	match area:
		"city":
			return o["city_burn"] if variant == "burn" else (o["city_refuse"] if variant == "refuse" else o["city"])
		"lobby":
			return o["lobby"]
		"nonum":
			return o["wall_done"] if f.has("ep_talked") else o["wall"]
		"home":
			return o["home"]
		"scene":
			return o["report"] if _scene_worked() else o["scene"]
		"depot":
			return o["depot"]
		"town":
			return o["town_done"] if f.has("ep_letter") else o["town"]
	return ""


func phone() -> String:
	if variant == "burn":
		return "[color=#888888]No signal. There hasn't been signal out here in nine years.[/color]\n\n"
	return "[color=#7fe6b0]Psyon:[/color] Good evening, Ezra. Everything is running.\n\n"


## [[who, text], ...]: who "" is Ezra thinking.
func _lines(list: Array) -> void:
	var ui = main.ui
	for pair: Array in list:
		if str(pair[0]) == "":
			await ui.think(str(pair[1]))
		else:
			await ui.say(str(pair[0]), str(pair[1]))


func _scene_worked() -> bool:
	var f: Dictionary = main.flags
	return f.has("ep_eyes") and f.has("ep_man") and f.has("ep_laptop")


func interact(node: Object) -> bool:
	var id := str(node.get_meta("id"))
	var ui = main.ui
	var f: Dictionary = main.flags
	var C: Dictionary = LINES["city"]
	match id:
		# the street
		"counter":
			await ui.say("", C["counter_psy"] if _psy() else C["counter_burn"])
			await ui.think(C["counter_psy_t"] if _psy() else C["counter_burn_t"])
			f["ep_counter"] = true
		"citizen":
			await _lines(C["citizen_psy"] if _psy() else C["citizen_burn"])
		"kiosk":
			if _psy():
				await _lines(C["kiosk_psy"])
			else:
				await ui.think(C["kiosk_burn"])
		"banner":
			await ui.think(C["banner"])
		"drone":
			await ui.think(C["drone"])
		"doors":
			if not f.has("ep_intro"):
				return true
			f["ep_lobby"] = true
			await ui.think(C["doors_psy"] if _psy() else C["doors_burn"])
			ui.close()
			await ui.fade_to(1.0, 0.7)
			await _arrive("lobby", LOBBY + Vector3(0, 0.1, 4.5), 0.0)
		# the lobby
		"plaque":
			var L: Dictionary = LINES["lobby"]
			await ui.say("", L["plaque_psy"] if _psy() else L["plaque_burn"])
			await ui.think(L["plaque_psy_t"] if _psy() else L["plaque_burn_t"])
			main.log_line("epilogue", "Turan and Emmet: " + ("the plaque" if _psy() else "sat down"))
		"greeter":
			await ui.think(LINES["lobby"]["greeter"] if _psy() else LINES["lobby"]["hall"])
		"elevator":
			if not f.has("ep_lobby"):
				return true
			f["ep_ride1"] = true
			ui.close()
			await _first_ride()
		# Sit and Copy: the floor with no number
		"corridor":
			await ui.think(LINES["nonum"]["corridor"])
		"wall":
			await ui.think(LINES["nonum"]["wall"])
			await ui.think(LINES["nonum"]["red_lit"] if red_lit else LINES["nonum"]["red_dark"])
			f["ep_wall"] = true
		"chair":
			await _talk_to_wall()
		"lift_back":
			if not f.has("ep_talked"):
				await ui.think(LINES["nonum"]["not_yet"])
				return true
			f["ep_ride2"] = true
			ui.close()
			await _ride("home")
			await _arrive("home", HOME + Vector3(4.4, 0.1, 3.6), 0.35)
			await ui.think(LINES["home"]["arrive"])
		# Sit and Copy: 86D
		"monica":
			var mo: Node3D = sets["home"].get_node_or_null("monica")
			if mo:
				turn_to(mo, main.player.global_position, 0.6)
			await _lines(LINES["home"]["monica_copy" if variant == "copy" else "monica_sit"])
			f["ep_monica"] = true
		"paul":
			await _lines(LINES["home"]["paul"])
		"carl":
			await _lines(LINES["home"]["carl"])
			main.log_line("epilogue", "Ezra calls him Dad")
		"trophy", "lion", "photo", "fridge":
			var key := "drawing" if id == "fridge" else id
			await ui.think(LINES["home"][key + ("_gone" if main.traded.has(key) else "")])
		"window":
			await ui.think(LINES["home"]["window"] + (LINES["home"]["window_lit"] if red_lit else LINES["home"]["window_dark"]))
		"lens":
			await ui.think(LINES["home"]["lens"])
		"table":
			if not f.has("ep_monica"):
				await ui.think(LINES["home"]["mom_first"])
				return true
			await _dinner()
		# Refuse: the scene
		"mirror":
			await ui.think(LINES["scene"]["mirror"])
			await ui.say("", LINES["scene"]["card"])
		"eyes":
			await ui.say("ORA", "[color=#7fe6b0]" + LINES["scene"]["eyes_ora"] + "[/color]")
			await ui.think(LINES["scene"]["eyes"])
			f["ep_eyes"] = true
		"ceiling":
			await ui.think(LINES["scene"]["ceiling"])
		"man":
			ui.close()
			await ui.show_card(LINES["cards"]["man_card"], 3.0 if not main._selftest else 0.1)
			await ui.say("MAN", LINES["scene"]["man_say"])
			await ui.think(LINES["scene"]["man_t"])
			f["ep_man"] = true
		"laptop":
			await _laptop()
		# Burn: the depot and the town
		"drills":
			await ui.think(LINES["depot"]["drills"])
		"marks":
			await ui.think(LINES["depot"]["marks"])
		"mouth":
			f["ep_mouth"] = true
			await ui.think(LINES["depot"]["mouth"])
			ui.close()
			await ui.fade_to(1.0, 1.2)
			await _arrive("town", TOWN + Vector3(0, 0.1, 11.0), 0.0)
			f["ep_town"] = true
			await ui.think(LINES["town"]["arrive"])
		"sign":
			await ui.say("", LINES["town"]["sign"])
			await ui.think(LINES["town"]["sign_t"])
		"genny":
			await _generator()
		"tyson":
			await _tyson()
		"cairn":
			await ui.think(LINES["town"]["cairn"])
		"mail":
			if not (f.has("ep_genny") and f.has("ep_tyson")):
				await ui.think(LINES["town"]["need"])
				return true
			await ui.think(LINES["town"]["mail"])
			await ui.say("", LINES["town"]["letter"])
			await ui.think(LINES["town"]["letter_t"])
			await ui.think(LINES["town"]["leaf"])
			f["ep_letter"] = true
			main.log_line("epilogue", "a letter from no one")
		"home_door":
			if not f.has("ep_letter"):
				await ui.think(LINES["town"]["need"])
				return true
			await ui.think(LINES["town"]["home"])
			await _finish()
		_:
			return false
	ui.close()
	main.update_hud()
	return true


func _first_ride() -> void:
	var ui = main.ui
	if variant == "sit" or variant == "copy":
		await _ride("sit1")
		await _arrive("nonum", NONUM + Vector3(0, 0.1, 0.4), 0.0)
		await ui.think(LINES["nonum"]["corridor"])
	elif variant == "refuse":
		await _ride("refuse")
		await _arrive("scene", SCENE + Vector3(-4.6, 0.1, 3.7), -0.9)
		await ui.say("ORA", "[color=#7fe6b0]" + LINES["scene"]["ora"] + "[/color]")
		await ui.think(LINES["scene"]["ora_t"])
		await ui.think(LINES["scene"]["smell"])
		main.flags["ep_scene"] = true
	else:
		await _ride("burn")
		await _arrive("depot", DEPOT + Vector3(0, 0.1, 0.8), 0.0)
		await ui.think(LINES["depot"]["arrive"])
		main.flags["ep_depot"] = true


## Sit and Copy: he sits, and tells it about his day. It answers in light.
func _talk_to_wall() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var N: Dictionary = LINES["nonum"]
	await ui.think(N["chair"])
	f["cinematic"] = true
	_sit_ezra(NONUM + Vector3(0, 0, -21.5), 0.0)
	_cam_auto = false
	tcam.global_position = NONUM + Vector3(2.4, 1.5, -19.4)
	tcam.look_at(NONUM + Vector3(-0.4, 1.3, -24.5), Vector3.UP)
	await ui.say("EZRA", N["hi_copy"] if variant == "copy" else N["hi_sit"])
	var topics: Array = (N["topics"] as Array).duplicate()
	var guard := 0
	while guard < 6:
		guard += 1
		var i: int = await ui.choose(topics)
		var pick: String = topics[i]
		if pick == N["topics"][3]:
			break
		topics.remove_at(i)
		if pick == N["topics"][0]:
			await ui.say("EZRA", N["work"])
		elif pick == N["topics"][1]:
			await ui.say("EZRA", N["mom_copy"] if variant == "copy" else N["mom_sit"])
		else:
			await ui.say("EZRA", N["hosp"])
			await ui.say("EZRA", N["hosp_red_lit"] if red_lit else N["hosp_red_dark"])
		await ui.say("", N["answer"])
	await ui.say("EZRA", N["bye_copy"] if variant == "copy" else N["bye_sit"])
	_voice.stream = _render([[67.0, 0.9, "u"], [64.0, 0.9, "u"], [69.0, 1.6, "u"]], 1.0, 0.006, 0.0)
	_voice.volume_db = -8.0
	_voice.pitch_scale = 1.0
	_voice.play()
	await ui.say("", N["hum"])
	ui.close()
	f["ep_talked"] = true
	main.log_line("epilogue", "Ezra visits the wall" + (" (it is Dad)" if variant == "sit" else ""))
	_seated = false
	main.player.position = NONUM + Vector3(0, 0.1, -20.6)
	_cam_auto = true
	f.erase("cinematic")


## Sit and Copy: dinner at 86D. Four places.
func _dinner() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var o := HOME
	f["cinematic"] = true
	var mo: Node3D = sets["home"].get_node_or_null("monica")
	if mo:
		_seat_fig(mo, o + Vector3(2.25, 0, 0.1), PI / 2.0)
	_sit_ezra(o + Vector3(0.75, 0, 0.1), -PI / 2.0)
	_cam_auto = false
	tcam.global_position = o + Vector3(1.5, 1.9, -2.4)
	tcam.look_at(o + Vector3(1.5, 0.9, 0.5), Vector3.UP)
	await _lines(LINES["home"]["dinner_copy" if variant == "copy" else "dinner"])
	f["ep_dinner"] = true
	ui.close()
	await _sleep(1.5)
	await _finish()


## Refuse: the laptop, then (the scene worked) the report.
func _laptop() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var S: Dictionary = LINES["scene"]
	if not f.has("ep_laptop"):
		ui.laptop_open(true)
		ui.laptop_line("Welcome, dreamer.")
		await ui.think(S["laptop"])
		await ui.think(S["laptop_t"])
		ui.laptop_open(false)
		f["ep_laptop"] = true
		return
	if not _scene_worked():
		await ui.think(S["need"])
		return
	if f.has("ep_report"):
		return
	await ui.say("", S["report_q"])
	var i: int = await ui.choose(S["framings"])
	main.play("slam", -12.0, 1.6)
	ui.show_toast(S["bar"], 3.0)
	main.log_line("report", "Ezra's framing: " + str(S["framings"][i]))
	await ui.think(S["after"])
	await ui.think(S["last"])
	f["ep_report"] = true
	ui.close()
	await _finish()


## Burn: Thursday. Any order but the cord last.
func _generator() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var T: Dictionary = LINES["town"]
	if f.has("ep_genny"):
		await ui.think(T["genny_ok"])
		return
	await ui.think(T["genny"])
	var steps: Array = T["steps"]
	var left: Array = [steps[3], steps[0], steps[1], steps[2]]
	var guard := 0
	while guard < 8:
		guard += 1
		var pick: String = steps[3]
		if left.size() > 1:
			var i: int = await ui.choose(left)
			pick = left[i]
		if pick == steps[3]:
			if left.size() > 1:
				main.play("engine", -14.0, 0.6)
				await ui.think(T["cough"])
				continue
			break
		left.erase(pick)
		await ui.think(T[["fuel", "plug", "belt"][steps.find(pick)]])
	main.play("engine", -10.0, 0.8)
	var ap: Node = main.loop("engine", -20.0, TOWN + Vector3(-8.4, 0.8, -9.4), 3.0, 30.0, sets["town"])
	if ap:
		ap.call("play")
	var tw := create_tween().set_parallel(true)
	tw.tween_property(bulbs_m, "emission_energy_multiplier", 2.4, 2.5)
	for l in town_lights:
		tw.tween_property(l, "light_energy", 1.3, 2.5)
	await ui.think(T["runs"])
	f["ep_genny"] = true


func _tyson() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	var T: Dictionary = LINES["town"]
	await _lines(T["tyson"])
	var topics: Array = (T["tyson_topics"] as Array).duplicate()
	var guard := 0
	while topics.size() > 0 and guard < 4:
		guard += 1
		var i: int = 0
		if topics.size() > 1:
			i = await ui.choose(topics)
		var pick: String = topics[i]
		topics.remove_at(i)
		if pick == T["tyson_topics"][0]:
			await ui.say("TYSON", T["tyson_dad"] if f.has("drone_owned") else T["tyson_dad_b"])
		elif pick == T["tyson_topics"][1]:
			await ui.say("TYSON", T["tyson_city"])
		else:
			await ui.say("", T["tyson_sit"])
			break
	await ui.say("TYSON", T["tyson_bye"])
	f["ep_tyson"] = true


# ------------------------------------------------------------------ the end, and the credits

## "25 years later..." after the scene, then the credits; then the title.
func _finish() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	f["epilogue_done"] = true
	f["cinematic"] = true
	main.log_line("epilogue", "Ezra, " + variant)
	ui.close()
	await ui.fade_to(1.0, 1.8 if not main._selftest else 0.1)
	await _credits()


var _credit_fill := Callable()
var _gen_pb: AudioStreamGeneratorPlayback
var _gen_player: AudioStreamPlayer
var _notes: Array = []      # [start s, dur s, f0, table]
var _line_t: Array = []     # start time of each hymn line
var _line_k: Array = []     # first note of each line
var _note_k := 0
var _gen_i := 0
var _gen_ph := 0.0
var _rv: PackedFloat32Array
var _rvi := 0
var _cl: CanvasLayer
var _ctext: RichTextLabel
var _chead: Label


func _credits() -> void:
	var f: Dictionary = main.flags
	if main._selftest and _credits_ran:
		f["credits_done"] = true
		return
	_credits_ran = true
	var C: Dictionary = LINES["credits"]
	_cl = CanvasLayer.new()
	_cl.layer = 20
	add_child(_cl)
	var bg := ColorRect.new()
	bg.color = Color(0, 0, 0, 1)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_cl.add_child(bg)
	_ctext = RichTextLabel.new()
	_ctext.bbcode_enabled = true
	_ctext.scroll_active = false
	_ctext.add_theme_font_size_override("normal_font_size", 26)
	_ctext.add_theme_font_size_override("bold_font_size", 34)
	_ctext.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_ctext.modulate.a = 0.0
	bg.add_child(_ctext)
	_ctext.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_ctext.offset_left = 120
	_ctext.offset_right = -120
	_chead = Label.new()
	_chead.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
	_chead.position.y = 60
	_chead.add_theme_font_size_override("font_size", 18)
	_chead.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
	_chead.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_chead.mouse_filter = Control.MOUSE_FILTER_IGNORE
	bg.add_child(_chead)
	main.ui.fade_to(0.0, 0.1)
	# the book's last line, after the scene
	await _card_text("[center]\n\n\n\n\n[i]" + LINES["cards"]["last"] + "[/i][/center]", 4.0)
	await _card_text("[center]\n\n\n\n" + C["title"] + "[/center]", 4.0)
	# the hymn: the lullaby hummed, resolving into the first line; one voice
	_start_voice()
	_chead.text = "the hymn, sung by one voice"
	var t0 := Time.get_ticks_msec() / 1000.0
	var offset := 0.0
	for i in HYMN.size():
		var start: float = _line_t[i]
		var end: float = _line_t[i + 1] if i + 1 < HYMN.size() else _notes[-1][0] + _notes[-1][1]
		await _until(func() -> bool: return Time.get_ticks_msec() / 1000.0 - t0 + offset >= start - 0.3, start - (Time.get_ticks_msec() / 1000.0 - t0 + offset))
		_ctext.text = "[center]\n\n\n\n\n[color=#5a5a5a]%d[/color]\n\n%s[/center]" % [i + 1, HYMN[i]]
		create_tween().tween_property(_ctext, "modulate:a", 1.0, 0.8)
		var skipped := await _until(func() -> bool: return Time.get_ticks_msec() / 1000.0 - t0 + offset >= end - 0.6, end - start, true)
		if skipped and i + 1 < HYMN.size():
			var now := Time.get_ticks_msec() / 1000.0 - t0 + offset
			offset += float(_line_t[i + 1]) - now
			_seek(i + 1)
		var tw := create_tween()
		tw.tween_property(_ctext, "modulate:a", 0.0, 0.5)
		await tw.finished
	_chead.text = ""
	_stop_voice()
	await _card_text("[center]\n\n" + C["content"] + "[/center]", 9.0, true)
	await _card_text("[center]\n\n\n" + C["ai"] + "[/center]", 8.0, true)
	await _card_text("[center]\n\n\n\n" + C["title"] + "\n\n\n" + C["end"] + "[/center]", 4.0, true)
	f["credits_done"] = true
	_cl.queue_free()
	_cl = null
	# back to Carl's eyes for whatever comes next, and the title
	main.player.cam.current = true
	main.player.ray.target_position = Vector3(0, 0, -_ray_len)
	f.erase("cinematic")
	if not main._selftest:
		main.ui.show_title(true)


## Wait until cond (or secs), skippable with E when `skip`; returns whether skipped.
func _until(cond: Callable, secs: float, skip := false) -> bool:
	if main._selftest:
		await get_tree().process_frame
		return false
	var t := 0.0
	var limit := maxf(0.0, secs) + 2.0
	while not cond.call() and t < limit:
		await get_tree().process_frame
		t += get_process_delta_time()
		if skip and t > 0.5 and Input.is_action_just_pressed("interact"):
			return true
	return false


func _card_text(text: String, secs: float, skip := false) -> void:
	_ctext.text = text
	var tw := create_tween()
	tw.tween_property(_ctext, "modulate:a", 1.0, 0.9)
	await tw.finished
	await _until(func() -> bool: return false, secs, skip)
	var tw2 := create_tween()
	tw2.tween_property(_ctext, "modulate:a", 0.0, 0.9)
	await tw2.finished


## The hymn's melody, one note a syllable (bible-5: twelve four-bar phrases,
## no pulse, ~60-72 bpm; in the credits "one voice, no crowd, in tune for the
## first time"). Every line opens on sol, the first note it shares with the
## lullaby, and the first line also takes the lullaby's second.
func _hymn_notes() -> void:
	_notes = []
	_line_t = []
	_line_k = []
	var beat := 60.0 / 72.0
	var scale := [62, 64, 65, 67, 69, 71, 72, 74, 76, 77, 79]
	var t := 0.4
	for nb: Array in [[67, 1.5], [64, 1.5], [69, 3.0], [65, 1.5], [62, 1.5], [67, 2.5]]:
		_add_note(t, float(nb[1]) * beat * 0.98, float(nb[0]), "u")
		t += float(nb[1]) * beat
	t += beat
	var lr := RandomNumberGenerator.new()
	for li in HYMN.size():
		lr.seed = 7 + li * 13
		_line_t.append(t)
		_line_k.append(_notes.size())
		var syl := _syllables(HYMN[li])
		var deg := 3
		for si in syl.size():
			var last := si == syl.size() - 1
			var d := beat * (0.5 if syl.size() > 12 and si % 2 == 1 else 1.0)
			if last:
				d = beat * 3.0
				deg = 4 if li % 2 == 0 else 1
			elif si == 0:
				deg = 3
			elif li == 0 and si == 1:
				deg = 1
			else:
				deg = clampi(deg + lr.randi_range(-2, 2), 1, 9)
			_add_note(t, d * 0.96, float(scale[deg]), str(syl[si]))
			t += d
		t += beat * 1.5


func _add_note(t: float, d: float, m: float, vowel: String) -> void:
	var f0 := _midi(m)
	_notes.append([t, d, f0, _table(f0, vowel, 1.12)])


## The vowel of each syllable, roughly: groups of vowels, a silent final e.
static func _syllables(text: String) -> Array:
	var out: Array = []
	for w in text.to_lower().split(" ", false):
		var groups: Array = []
		var prev := false
		for ch in w:
			var v := "aeiouy".contains(ch)
			if v and not prev:
				groups.append("i" if ch == "y" else ch)
			prev = v
		if groups.size() > 1 and w.ends_with("e") and groups[-1] == "e":
			groups.pop_back()
		if groups.is_empty():
			groups.append("u")
		out.append_array(groups)
	return out


func _start_voice() -> void:
	_hymn_notes()
	var gen := AudioStreamGenerator.new()
	gen.mix_rate = 22050.0
	gen.buffer_length = 0.4
	_gen_player = AudioStreamPlayer.new()
	_gen_player.stream = gen
	_gen_player.volume_db = -6.0
	add_child(_gen_player)
	_gen_player.play()
	_gen_pb = _gen_player.get_stream_playback() as AudioStreamGeneratorPlayback
	_gen_i = 0
	_note_k = 0
	_rv = PackedFloat32Array()
	_rv.resize(5800)
	_rvi = 0
	_credit_fill = _fill


func _seek(line: int) -> void:
	_note_k = int(_line_k[line])
	_gen_i = int(float(_line_t[line]) * 22050.0)


func _stop_voice() -> void:
	_credit_fill = Callable()
	if _gen_player:
		_gen_player.stop()
		_gen_player.queue_free()
		_gen_player = null
	_gen_pb = null


## Feed the generator: the current note's wavetable, a slow vibrato that
## arrives late in each note, and a small stone room of a reverb.
func _fill() -> void:
	if _gen_pb == null:
		return
	var n := _gen_pb.get_frames_available()
	if n <= 0:
		return
	var buf := PackedVector2Array()
	buf.resize(n)
	var rate := 22050.0
	var nt: Array = _notes[_note_k] if _note_k < _notes.size() else []
	var rl := _rv.size()
	for k in n:
		var t := _gen_i / rate
		while not nt.is_empty() and t >= float(nt[0]) + float(nt[1]):
			_note_k += 1
			nt = _notes[_note_k] if _note_k < _notes.size() else []
		var v := 0.0
		if not nt.is_empty() and t >= float(nt[0]):
			var tt := t - float(nt[0])
			var d: float = nt[1]
			var env := minf(1.0, tt / 0.09) * clampf((d - tt) / 0.18, 0.0, 1.0)
			var fr: float = float(nt[2]) * (1.0 + 0.007 * sin(TAU * 5.1 * tt) * minf(1.0, tt / 0.5))
			_gen_ph = fmod(_gen_ph + fr / rate * 512.0, 512.0)
			var tab: PackedFloat32Array = nt[3]
			var a := int(_gen_ph)
			v = lerpf(tab[a], tab[(a + 1) & 511], _gen_ph - a) * env * 0.32
		var r1 := _rv[(_rvi + rl - 2300) % rl]
		var r2 := _rv[(_rvi + rl - 3700) % rl]
		var r3 := _rv[(_rvi + rl - 5600) % rl]
		var o := v + (r1 + r2 + r3) * 0.22
		_rv[_rvi] = v + (r1 + r2 + r3) * 0.27
		_rvi = (_rvi + 1) % rl
		buf[k] = Vector2(o, o)
		_gen_i += 1
	_gen_pb.push_buffer(buf)


# ------------------------------------------------------------------ dev args and the self-test

## --area=city|lobby|lift|nonum|chair|home|dinner|scene|depot|town for shots.
func apply_args(a: Dictionary) -> void:
	if not a.has("area"):
		return
	var ar := str(a["area"])
	var spots := {"city": [spawn, 0.0], "lobby": [LOBBY + Vector3(0, 0.1, 4.5), 0.0],
		"nonum": [NONUM + Vector3(0, 0.1, -17.5), 0.0], "home": [HOME + Vector3(4.2, 0.1, 3.4), 0.55],
		"scene": [SCENE + Vector3(-1.0, 0.1, 2.2), -1.1], "depot": [DEPOT + Vector3(0, 0.1, -10.0), 0.0],
		"town": [TOWN + Vector3(1.0, 0.1, 6.0), 0.15]}
	var key := ar
	if ar == "lift":
		key = "lobby"
	elif ar == "chair":
		key = "nonum"
	elif ar == "dinner":
		key = "home"
	if not spots.has(key) or not sets.has(key):
		return
	_show(key)
	if not a.has("at"):
		main.player.position = spots[key][0]
		if not a.has("yaw"):
			main.player.yaw = spots[key][1]
	_last_pos = main.player.position
	_snap_cam()
	if ar == "lift":
		main.player.position = LOBBY + Vector3(0, 0.05, -7.6)
		main.player.yaw = PI
		_cam_auto = false
		tcam.global_position = LOBBY + Vector3(0.95, 2.2, -6.6)
		tcam.look_at(LOBBY + Vector3(-0.1, 1.5, -7.7), Vector3.UP)
		lift_l.text = "86"
	elif ar == "chair":
		_sit_ezra(NONUM + Vector3(0, 0, -21.5), 0.0)
		_cam_auto = false
		tcam.global_position = NONUM + Vector3(2.4, 1.5, -19.4)
		tcam.look_at(NONUM + Vector3(-0.4, 1.3, -24.5), Vector3.UP)
	elif ar == "dinner":
		var mo: Node3D = sets["home"].get_node_or_null("monica")
		if mo:
			_seat_fig(mo, HOME + Vector3(2.25, 0, 0.1), PI / 2.0)
		_sit_ezra(HOME + Vector3(0.75, 0, 0.1), -PI / 2.0)
		_cam_auto = false
		tcam.global_position = HOME + Vector3(1.5, 1.9, -2.4)
		tcam.look_at(HOME + Vector3(1.5, 0.9, 0.5), Vector3.UP)


## Every variant end to end (the pump picks choice 1 and auto-advances),
## then the branches the pump would not reach, then every interactable.
func selftest() -> void:
	var f: Dictionary = main.flags
	# headless on llvmpipe the lit city renders at a frame or two a second and
	# every line costs a frame; the test is of the script, so the level is
	# hidden while it runs (it still ticks and collides), as Observatory does
	visible = false
	var order: Array = [variant]
	for v in ["sit", "copy", "refuse", "burn"]:
		if v != variant:
			order.append(v)
	for v: String in order:
		if v != variant:
			_switch(v)
			main.ui.fade_to(0.0, 0.05)
		print("ok variant ", v, " sets=", sets.keys())
		await intro()
		await _play()
		print("ok ", v, " epilogue_done=", f.has("epilogue_done"), " credits_done=", f.has("credits_done"))
		f.erase("epilogue_done")
		f.erase("cinematic")
	# the other branches: Red Rock held, Ezra home from the retreat, the copy with nothing traded
	red_lit = true
	f["ezra_home"] = true
	f["drone_owned"] = true
	main.traded = ["drawing", "lion"]
	_switch("sit")
	await intro()
	for id in ["doors", "elevator", "wall", "chair", "lift_back", "fridge", "lion", "trophy", "window"]:
		await _by_id(id)
	print("ok branches red_lit=", red_lit, " flags=", f.keys())
	_switch("burn")
	await intro()
	for id in ["doors", "elevator", "mouth", "genny", "tyson"]:
		await _by_id(id)
	main.traded = []
	f.erase("cinematic")
	main.ui.fade_to(0.0, 0.05)
	await main.selftest_all_interactables()
	visible = true


func _play() -> void:
	var f: Dictionary = main.flags
	for id in ["counter", "citizen", "kiosk"]:
		await _by_id(id)
	if _psy():
		await _by_id("banner")
		await _by_id("drone")
	await _by_id("doors")
	for id in ["plaque", "greeter", "elevator"]:
		await _by_id(id)
	print("ok rode area=", area)
	match variant:
		"sit", "copy":
			for id in ["corridor", "lift_back", "wall", "chair", "lift_back", "table", "monica",
				"carl" if variant == "copy" else "paul", "trophy", "lion", "photo", "fridge", "window", "lens", "table"]:
				await _by_id(id)
		"refuse":
			for id in ["mirror", "laptop", "laptop", "eyes", "ceiling", "man", "laptop"]:
				await _by_id(id)
		"burn":
			for id in ["drills", "marks", "mouth", "sign", "mail", "genny", "genny", "tyson", "cairn", "mail", "home_door"]:
				await _by_id(id)
	await _wait(func() -> bool: return f.has("credits_done"), 20.0)
