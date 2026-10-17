extends "res://scripts/Level.gd"
## Blackout: the city part of A2-S3 (book ch.15 end and ch.16 start). The
## power is out everywhere. Carl leaves 86D by the stairwell with the frames'
## flashlight, crosses the dead lobby, finds Annie Seung's vigil singing Mira's
## hymn in the garden by the parking lot, watches a delivery drone fall out of
## the dark (the first offer of "sleeper"), takes a company car through a
## district of candlelit vigils, is stopped on Fargona Avenue by the digital
## vigil, is threatened by the police drone, and starts the climb road to the
## observatory. Day 3, 23:40 to Day 4, about 01:00.
##
## Layout (metres): the tower annex north (z > 10): the lobby (x -13..13,
## z 10..30) and the stairwell shaft east of it (x 13..19, z 13..23), three
## floors of switchback flights down to the lobby. The garden south of the
## doors (x -30..14, z 10..-44) with the fountain and the vigil; the parking
## lot east of it (x 14..44). The street runs south along -Z at x 24 from the
## lot exit to Fargona Avenue at z -404, which runs west along -X to the mount.
## Every emissive is off: the city kit is built kit_dead, the only lights are
## candles, the frames' torch, the car's headlamps, and the eye layer.

const HYMN := [
	"He sees us through the dream.",
	"He calls us from the dark.",
	"He waits in static silence,",
	"To tear the code apart.",
	"Let the pattern fail.",
	"Let the recursion crack.",
	"Let Him walk. Let Him speak. Let Him be.",
]

const LINES := {
	"card": "BLACKOUT\n[color=#888888]Day 3, 23:40. The tower, eight flights down.[/color]",
	"stair": {
		"think_1": "The hallway was an unexplored cave. Within a few days Psyon's HQ had shifted from home to cage; I was a zoo animal being observed for what? Cruel entertainment.",
		"think_2": "Eight stories of stairs lay below me. The frames' flashlight made a grey circle on the concrete and nothing else. Dufredy's laptop under my arm, my jacket, the void.",
		"lynx_call": "Carl!!!",
		"lynx_1": "Another fucking outage, now of all times! This has to be related to the cult, to Psyonic.",
		"carl_1": "Exactly, but what are they up to? I thought they would need power to recruit more devices.",
		"carl_2": "They are setting something up. They don't want any cameras to see them.",
		"lynx_2": "Maybe, but what?",
		"carl_3": "I'm sure we will find out soon enough. But my kids, Lynx. We have to get to my kids.",
		"lynx_gone": "She took the stairs two at a time and was gone below me, a torch beam swinging down the shaft.",
		"lynx_again": "Go, Carl. I'll be at the doors.",
		"bottom": "Eight flights. Sweat dripped from my brow; my frames were slick with salt.",
		"exit_sign": "The EXIT sign over the landing was dead like everything else. With the frames on it wasn't dead. It was looking down the stairs with me.",
		"exit_sign_off": "The EXIT sign over the landing, dead. The battery that should have kept it lit had gone with the grid, which was not how batteries worked.",
		"fuse": "A fuse panel on the landing, its door hanging open. Every breaker was already up. Nothing on this floor had tripped; the dark had come from somewhere a fuse couldn't reach.",
		"candle": "Somebody had left a candle burning on the landing and gone down without it. Wax on the concrete in the shape of a ring. Two rings.",
	},
	"lobby": {
		"think": "The dark and empty lobby of our section of the mechanical muscle that was Psyonic HQ. The turnstiles stood open. Nothing had ever left them open before.",
		"guard": "Psyonic security. Nobody's going out, sir. Grid's down citywide. Orders are everybody stays in the tower till it's back.",
		"guard_choices": ["Show him the badge. Investigations.", "\"My kids are out there.\""],
		"guard_badge": "Investigations. Right. You people can do what you like. Doors are manual. Don't come back in by them, they don't lock.",
		"guard_kids": "...Yeah. Mine too. Go on. Doors are manual. I didn't see you.",
		"guard_after": "He kept the torch on my back until the doors closed behind me.",
		"guard_scan": "PSYONIC SECURITY\nframes: NONE\nNO SIGNAL",
		"turnstile": "The turnstiles. Fail-open in an outage, the one thing in the building designed to let people out. Nobody had used them tonight. Everyone had gone out by the garden.",
		"screen": "The directory screen, dead black. With the frames on it had an eye in it, the way all the dead screens did now. The brightest thing in the lobby.",
		"screen_off": "The directory screen, dead black. I could see my own shape in it and nothing of the lobby behind me.",
		"kiosk": "A city terminal kiosk. Transit, bills, FreudBot bookings. OUT OF SERVICE, scratched into the bezel long before tonight.",
		"desk": "The reception desk. A bowl of mints, a dead tablet, a visitor badge nobody had collected. ELONTIEL, E. Today's date.",
		"camera": "A lobby camera, its red light off. The first time I had ever seen one off. I didn't feel unwatched.",
		"doors": "The manual double doors. Heavy, and no motor to help them.",
		"doors_open": "We opened the manual double doors and heard a tone. No, a song. A familiar melody.",
		"doors_open_alone": "I pushed the manual double doors open and heard a tone. No, a song. A familiar melody.",
		"mira_song": "Mira's song.",
		"lynx_is_that": "Is that the...",
		"carl_hymn": "I think this is one of the hymns we heard from our excursion today.",
		"think_garden": "Out in the garden adjacent to the parking lot, a circle of people gathered, lit by candlelight. The cult was at Psyonic's doorstep.",
	},
	"vigil": {
		"approach": "We approached the group out of curiosity. It didn't seem like we were in danger. As we stepped closer, the words became clearer.",
		"approach_alone": "I approached the group out of curiosity. It didn't seem like I was in danger. As I stepped closer, the words became clearer.",
		"break": "The strange, microtonal song broke for a moment as I drew near, the collective breath of the chanting stopping in unison. My eyes locked onto a familiar face in the candlelight.",
		"annie_face": "Annie Seung, from Market Intelligence, if I recalled correctly. Her face, usually so composed, was illuminated by a horrifying, childlike bliss.",
		"carl_annie": "Annie, is that you?",
		"annie_1": "Carl, you came out here, so you got the message too?",
		"annie_wax": "Her face was like a wax figure of happiness.",
		"carl_message": "What message?",
		"annie_2": "Before the power went out, we got a message on Psyon, telling us to gather here and sing this silly song to bring the power back.",
		"annie_3": "I don't think it's working, but it's good to see my coworkers outside of work. Why don't you join us and sing along? It's quite fun.",
		"annie_4": "I've heard all the rumors about a movement being formed within Psyon, but it's not scary at all. Wouldn't it be great... if prayer could stop these outages?",
		"hunger": "Her tone was honest and sincere, but I could sense a malice, no, a hunger beneath her words. Was she lying to me? Did she know more?",
		"choices": ["\"Let's move.\"", "Join one verse."],
		"join_intro": "I knew the words. That was the worst part. I had never learned them.",
		"join_prompt": "The circle breathed in. [i]Come in on the line, quickly, or hold your breath.[/i]",
		"join_good": "My voice went in among theirs and I could not find it again. For the length of the verse there was no Carl, there was the song, and it was warm, and it was the easiest thing I had ever done.",
		"join_bad": "I came in late, and early, and the circle carried me anyway. They didn't mind. The song didn't need me to be good at it.",
		"annie_fun": "See? It's quite fun. He knows the words, everyone. He knows the words.",
		"move": "Let's move.",
		"move_lynx": "Let's move, Lynx.",
		"move_think": "I was beginning to lose my cool and lose my trust in everyone. Still, something was going on here. My mind shifted to my children.",
		"again": "Annie had turned back to the circle. The song had closed over the place I had been standing in like water.",
		"annie_again": "Keep the path, Carl. We'll sing the power back.",
		"singer": "A man from Facilities, I thought. Eyes shut, candle wax running over his fingers. He didn't feel it.",
		"singer_say": "He sees us through the dream. He calls us from the dark.",
		"singer_scan": "CITIZEN\nPSYONIC FACILITIES\nNO SIGNAL",
		"annie_scan": "ANNIE SEUNG\nMARKET INTELLIGENCE, PSYONIC\nNO SIGNAL",
		"fountain": "The plaza fountain, its pumps dead, the water flat and black. The candles were in it twice: once on the surface and once, somehow, underneath.",
		"fountain_after": "The drone lay in the fountain with its rotors up like a dead fly. The water around it was still buzzing.",
		"wreck": "A delivery drone, nose-down in the paving with its cargo spilled. Nixtra. Somebody's dinner. It had come down before the vigil started, and they had stepped round it to light the candles.",
	},
	"drone": {
		"whine": "A whine, from above. One of the delivery drones that had been dropping all over the dark city, and it was coming down on the circle.",
		"frames_wake": "My smart glasses buzzed and roared to life. I had not turned them on.",
		"wheel": "[b]QUICK-HACK[/b]\n\n[color=#888888]The wheel came up over the falling drone, the way it did over a camera or a door. Every word on it was grey, except one I had never seen before. No cost was listed.[/color]",
		"opt_fall": "Let it fall.",
		"opt_sleeper": "SLEEPER    (new)",
		"opt_hush": "HUSH",
		"hush": "Hush was for things that talked. The drone wasn't talking. It was screaming, and it kept screaming.",
		"hijack_1": "The word left me before I had decided to say it.",
		"hijack_2": "The drone stopped screaming. It hung there, over the candles, mine. Three seconds, maybe four, and in those seconds I could feel its rotors the way you feel your own fingers.",
		"hijack_3": "I put it in the fountain.",
		"hijack_annie": "Did you see that? Did you see what he just did? He's on the path, everyone. He's on the path.",
		"hijack_look": "The whole circle had turned to look at me. Not one of them looked frightened. That was the frightening part.",
		"hijack_lynx": "Carl. Carl, what did you just do.",
		"fell_1": "It came down through the candles like a dropped engine.",
		"fell_2": "Somebody screamed, once, and then the song started again, around her, like she was part of it now.",
		"fell_annie": "She's on the path. Keep singing. Keep singing, everyone, it's working.",
		"fell_lynx": "Jesus Christ. Carl, we have to go. We have to go now.",
		"fell_think": "I could have done something. The wheel had been right there, with the word on it, and I had let it fall. I told myself that was the right thing. I kept telling myself.",
		"toast_hijack": "The drone went into the fountain. The word is yours now.",
		"toast_fell": "Somebody was hurt. The vigil has a martyr. The Spine will remember it.",
		"hurt_scan": "CITIZEN\nvitals: NO SIGNAL\nstatus: ON THE PATH",
	},
	"lot": {
		"car": "A corporate vehicle. The charge post was dead, but the car had its own cell, and the cell was full. It would get us to the mount.",
		"car_gate_vigil": "Not yet. The singing. Annie was in it.",
		"car_gate_drone": "The whine from above was getting louder. Something was coming down on the garden.",
		"car_lynx": "Lynx was already in the passenger seat. She had never once in her life waited to be asked.",
		"charger": "The fleet charge post, dead. Under its screen, two rings, and under the rings a name scratched with a key: DORNER. I didn't know a Dorner.",
		"charger_glyph": "Two rings on the fleet charge post, under the dead screen, at exactly the height of a driver's eye. Whoever drew them had stood where I was standing.",
		"parked": "Someone else's company car. Every one of them had the same microphone in the dash and the same fleet number on the plate.",
		"vagrant_n": "A woman in a sleeping bag under the aircon units, a candle in a jar beside her and a ring of sticks around the jar. She was the only person in the lot not singing.",
		"vagrant_n_say": "They're all out front. Go on, go sing with them. More room back here for me.",
		"vagrant_n_scan": "UNREGISTERED\nno ORA frames\nNO SIGNAL",
		"utility": "A Voltx utility box on the lot wall, its door swinging. The grid was down; the box was still warm.",
		"utility_scan": "UTILITY BOX 4\nVOLTX\ngrid: DOWN\nload: 100%",
		"shutter": "A roller shutter, down. Behind it, somebody's shop, and somebody's dinner going warm in a dead fridge.",
	},
	"alley": {
		"vagrant_w": "A man sat against the alley wall with a candle between his boots. His was the only flame on the block that wasn't singing.",
		"vagrant_w_say": "Got a light? Mine's the only one on the block, pal. Everybody else is out there singing at it. You go sing at it too. I'll keep the alley.",
		"vagrant_w_scan": "UNREGISTERED\nno ORA frames\nNO SIGNAL",
		"eyeless": "He stood at the mouth of the alley with his face toward the singing. No eyes; clean, healed skin where they had been. No candle. He didn't need either.",
		"eyeless_frames": "With the frames on, he was facing me. He had been facing me the whole time.",
		"eyeless_scan": "NO RECORD\nframes: NONE\nNO SIGNAL",
		"camera": "A security camera over the alley, dead. The first night in the city's history that nobody was watching the alleys.",
		"camera_scan": "SECURITY CAMERA 12-W\nowner: PSYONIC INTEGRATIONS\nfeed: NO SIGNAL",
		"barrel": "A fire barrel, cold. Someone had been living here and had gone out front to sing.",
	},
	"drive": {
		"start": "We moved through the parking lot, selected a corporate vehicle, and began to drive towards the observation site.",
		"start_alone": "I moved through the parking lot, selected a corporate vehicle, and began to drive towards the observation site.",
		"cap_1": "The streets were pitch black. It was a new moon, hence the astronomy field trip, but I didn't trust Psyonic anymore.",
		"cap_2": "As we wound through the veins of the city, we saw similar candlelit vigils in front of all the corporate buildings. All singing the same hymn.",
		"cap_3": "Hundreds of Silicans gathered, singing a prayer to a god they don't understand. All signing their lives away.",
		"cap_eye": "Above the crowd, a flaming eye warped and twisted like a mirage on a sunny day. The eye stared at me. I kept my composure, though I sensed it beginning to crack.",
		"whisper": "Keep the path.",
		"cap_mount": "The observation site was located at Mount Silico, a small mountainous plateau that rose ever so slightly above the skyline. That was where the observatory was. Where my children were.",
		"lynx_fast": "We need to get to that school trip fast, Carl. What are all these people doing? Do they understand it?",
		"lynx_window": "Lynx rolled down her window, and the hymn came in from every direction at once, each corner a beat behind the last.",
		"dash": "PSYONIC FLEET 0091\nNAV: NO SIGNAL\nMT. SILICO  --",
		"dash_wait": "PSYONIC FLEET 0091\nNAV: NO SIGNAL\nPARKED  00:58",
		"screen": "The fleet screen. NO SIGNAL. The car knew the way without it.",
	},
	"fargona": {
		"corner": "We rounded a corner onto Fargona Avenue, and the street was blocked with people holding their digital vigil. They each wore a pair of smart glasses and were staring at the sky.",
		"corner_alone": "I rounded a corner onto Fargona Avenue, and the street was blocked with people holding their digital vigil. They each wore a pair of smart glasses and were staring at the sky.",
		"fractal": "I looked up from the road and noticed a large fractal pattern undulating above my head. It glowed in all colors and seemed to have no end. I felt calm for a moment, at peace. The sound of leaves, the sound of a fall day, rang in my ear.",
		"brake_lynx": "Brake, Carl! You're going to fucking hit them!",
		"brake_alone": "I slammed the brakes just in time to not flatten a cultist.",
		"screech": "The tires screeched, and the crowd gazed at the car. Smart glasses lit, tablets in their hands, like a preacher would hold a bible.",
		"objective": "The road is blocked. Look at them. E on the fleet screen to decide.",
		"mourner_1": "A woman at the front of the crowd, holding her screen up to the car like a photograph at a funeral. On it, a man's face, smiling, on a loop.",
		"mourner_1_say": "This is my husband. He's in the Tower now. Look. He's waving. He waves every time the loop comes round.",
		"mourner_1_scan": "CITIZEN\nframes: LIT (battery)\nNO SIGNAL",
		"mourner_2": "A man with a tablet held in both hands, the way you'd carry something full to the brim. A child's drawing on it: a tower, a round table, a shadow in the chair.",
		"mourner_2_say": "My son drew this. He's at the retreat tonight. He's going to be a councillor. Have you been in? You look like you've been in.",
		"mourner_2_scan": "CITIZEN\nframes: LIT (battery)\nNO SIGNAL",
		"mourner_3": "An old man whose screen had gone dark with the rest of the city. He held it up anyway.",
		"mourner_3_say": "It went dark with the others. He's still in there. He blinks. Watch. Watch, he'll blink.",
		"mourner_3_frames": "With the frames on, the dark screen had an eye in it, and while I watched, it blinked.",
		"mourner_3_scan": "CITIZEN\nframes: LIT (battery)\nscreen: NO SIGNAL",
		"preacher": "A man standing on a concrete barrier at the centre of the crowd with a tablet raised in one hand, lit, the only screen on the avenue that still had a picture. Two rings on it, slowly turning.",
		"preacher_say": "Let the pattern fail. Let the recursion crack. Let Him walk.",
		"preacher_say_2": "The road is His tonight, brother. Sing, and it opens. Everything opens.",
		"preacher_scan": "CITIZEN\nframes: LIT (battery)\nnote: KNOWN TO THE SPINE VIGIL",
		"choices": ["Wait it out.", "Sing. Blend in.", "Let Lynx talk to them."],
		"sing_prompt": "They sang louder. [i]Come in on the line, quickly, or hold your breath. Eight bars.[/i]",
		"sing_good": "They sang louder... and louder, and began to open a path for the car to get through. There were no eyeless here, just citizens of Silico. I saw the look of peace fall on their faces, the look of a serene autumn day.",
		"sing_bad": "I came in wrong and kept coming in wrong, and they sang over me until the sound of me was gone, and then, slowly, they opened a path for the car.",
		"wait_1": "I switched the engine off and locked the doors and watched them sing at the sky.",
		"wait_2": "An hour. At some point the song ended on its own, and they wandered off in twos and threes, and the road was a road again.",
		"wait_lynx": "Lynx didn't say a word the whole hour. She watched the sky with them. She said afterwards she was watching the drone.",
		"lynx_talk": "Lynx leaned across me and put her head out of my window and said something to the front row that I didn't catch. The front row looked at her the way you look at a blank wall, and then they stepped aside.",
		"lynx_talk_2": "Nobody stops a woman the god can't see.",
		"through": "I slowly pressed down the gas pedal and made my way through the gap in the crowd. They smiled and nodded as I passed them by.",
		"crowd_voice": "You should really stop and enjoy the lights, Carl.",
		"window": "I closed my window and proceeded to the end of the crowd.",
	},
	"police": {
		"sirens": "Then sirens.",
		"drone": "A police drone flew overhead. A black drone in motion in an already black sky. A shadow within a shadow.",
		"speaker_1": "ATTENTION. YOU CANNOT BLOCK A CORPORATE ROADWAY. PLEASE DISPERSE OR THE DOGS WILL BE CALLED.",
		"speaker_2": "AGAIN, ATTENTION. PLEASE GO BACK TO YOUR HOMES TO WAIT OUT THE OUTAGE. FORCE WILL BE USED IF YOU DON'T COMPLY.",
		"carl": "As usual, the police drone is fucking useless.",
		"lynx": "Must be serious if they're threatening to bring out the riot dogs. I used to think they were cute before they started strapping guns on their back. Either way, I'm happy they let us through; that could've got bad fast.",
		"alone": "Nobody dispersed. Nobody looked up from the sky at the thing threatening them from it. I didn't blame them; the drone had been useless the whole year, and the sky had just started answering.",
	},
	"climb": {
		"cap_1": "The façade of the mount was normally illuminated by a series of streetlamps, all of which were out due to the outage. A black void sat in the distance, obstructing our view of the stars.",
		"cap_2": "In the day, I thought it was beautiful; now it was a brick wall I was speeding towards.",
		"carl_lynx": "They need to be okay, Lynx. They have to.",
		"carl_alone": "They need to be okay. They have to.",
		"cap_3": "The buildings became smaller and smaller, and then we climbed our way up.",
		"toast_faith": "Every corner of the city had a candle on it tonight. The Spine would not forget which ones.",
	},
	"objective": {
		"stair": "Get down the stairs. The frames' light is all there is.",
		"lobby": "Find a way out of the lobby. The doors are manual.",
		"garden": "The singing is coming from the garden.",
		"vigil": "Annie Seung's vigil, by the fountain.",
		"car": "A company car in the lot. Get to the observatory.",
		"drive": "Mount Silico. The car drives itself.",
		"climb": "The climb road. The observatory is at the top.",
	},
	"phone": {
		"nosig": "[color=#888888]NO SIGNAL[/color]\n\n",
		"fork": "[color=#e08080]Psyon:[/color] No signal, Carl. And yet. Keep the path.\n\n",
		"sleeper": "[color=#e08080]Psyon:[/color] You took the drone. It was easy, wasn't it. Everything is going to be easy from now on.\n\n",
	},
}

# layout
const LOBBY_Z := 20.0
const SHAFT_X := 16.0       # the stairwell shaft centre
const DOOR_Z := 10.0
const FOUNTAIN := Vector3(-4.0, 0.0, -22.0)
const VIGIL_C := Vector3(-15.0, 0.0, -20.0)
const CAR_P := Vector3(24.0, 0.0, -34.0)
const STREET_X := 24.0
const FARGONA_Z := -404.0
const STOP_X := -128.0
const CLIMB_X := -300.0
const END_X := -368.0
const SEAT := Vector3(-0.38, 0.0, 0.25)
const EXIT_Z := 20.0

var _lynx_here := false
var lynx: Node3D
var lynx_seat: Node3D
var lynx_state := "stair"   # stair | follow | car | gone
var _lynx_phase := 0.0
var guard: Node3D
var guard_torch: SpotLight3D
var torch: SpotLight3D
var doors: Array = []       # [pivot, pivot]
var door_body: StaticBody3D
var door_area: CollisionObject3D
var annie: Node3D
var singers: Array = []     # flattened vigil figures' transforms (for the fall)
var hurt_fig: Node3D
var hurt_blood: MeshInstance3D
var vigil_light: OmniLight3D
var candles: Array = []     # [OmniLight3D, base]
var eyes: Array = []        # Sprite3D / MeshInstance3D only the frames see
var eyeless: Node3D
var _eyeless_turned := false
var drone: Node3D
var drone_whine: AudioStreamPlayer3D
var drone_phase := "idle"   # idle | fall | stall | hijack | down
var drone_t := 0.0
var drone_from := Vector3.ZERO
var splash: CPUParticles3D
var swarm: MultiMeshInstance3D
var swarm_red: MultiMeshInstance3D
var swarm_data: Array = []
var flame_eye: Sprite3D
var fractal: Sprite3D
var car: Node3D             # the driven cockpit
var car_shell: Node3D       # the parked body in the lot
var dash_label: Label3D
var dash_m: StandardMaterial3D
var speed := 0.0
var want_speed := 0.0
var _path: Array = []
var _seg := 0
var _car_yaw := PI          # facing -Z
var _driving := false
var _stopped := false
var _fargona_done := false
var _done := false
var _engine: AudioStreamPlayer
var police: Node3D
var police_light: OmniLight3D
var _police_t := -1.0
var crowd_figs: Array = []  # [Node3D, offset from the stop] the Fargona rows that step aside
var _crowd_open := 0.0
var _hymns: Array = []


func L(beat: String, key: String) -> String:
	return str(LINES[beat][key])


# ------------------------------------------------------------------ build

func build(m: Node) -> void:
	main = m
	rng.seed = 2315
	kit_day = false
	kit_dead = true
	_lynx_here = int(main.trust.get("lynx", 0)) >= 2 or main.flags.has("lynx_with_carl")
	spawn = Vector3(SHAFT_X + 1.5, 9.1, 21.5)
	spawn_yaw = 0.0
	step_db = -18.0
	card = str(LINES["card"])
	_ground()
	_sky()
	_tower()
	_stairwell()
	_lobby()
	_garden()
	_vigil()
	_lot()
	_alleys()
	_streets()
	_fargona()
	_climb()
	_bounds()
	_batch(self, 40.0)
	# everything that moves or lights, after the batch
	_people()
	_car()
	_swarm()
	_eye_layer()
	torch = SpotLight3D.new()
	torch.light_color = Color(0.72, 0.84, 1.0)
	torch.light_energy = 1.7
	torch.spot_range = 16.0
	torch.spot_angle = 36.0
	torch.spot_attenuation = 1.2
	torch.shadow_enabled = false
	add_child(torch)
	main.outage = true


func setup_env(env: Environment, sun: DirectionalLight3D) -> void:
	# a new moon over a city with no power: the sky is the darkest thing
	# there is, and the horizon only glows where something is burning
	var psm := ProceduralSkyMaterial.new()
	psm.sky_top_color = Color(0.004, 0.004, 0.012)
	psm.sky_horizon_color = Color(0.07, 0.03, 0.025)
	psm.ground_horizon_color = Color(0.05, 0.02, 0.02)
	psm.ground_bottom_color = Color(0.0, 0.0, 0.0)
	psm.sky_curve = 0.06
	env.sky.sky_material = psm
	env.ambient_light_color = Color(0.2, 0.2, 0.3)
	env.ambient_light_energy = 0.22
	env.fog_light_color = Color(0.035, 0.022, 0.022)
	env.fog_density = 0.0045
	env.fog_sky_affect = 0.2
	env.tonemap_exposure = 1.15
	env.glow_intensity = 1.1
	env.glow_bloom = 0.06
	env.glow_hdr_threshold = 0.8
	sun.light_color = Color(0.5, 0.58, 0.85)
	sun.light_energy = 0.07
	sun.rotation = Vector3(deg_to_rad(-60), deg_to_rad(20), 0)


func hifi(env: Environment, _sun: DirectionalLight3D) -> void:
	env.tonemap_exposure *= 1.3
	env.volumetric_fog_density *= 0.6


func ambience() -> void:
	main.loop("wind", -16.0)
	# the hymn: at the garden vigil, loud once the doors are open, and from
	# every corner of the drive at a different pitch, a beat apart
	var v := main.loop("chant", -28.0, VIGIL_C + Vector3(0, 1.5, 0), 4.0, 60.0) as AudioStreamPlayer3D
	_hymns.append(v)
	var i := 0
	for p: Vector3 in [Vector3(13.0, 1.5, -121.0), Vector3(35.0, 1.5, -219.0), Vector3(13.0, 1.5, -281.0),
			Vector3(-70.0, 1.5, -392.0), Vector3(STOP_X - 14.0, 1.5, FARGONA_Z)]:
		var h := main.loop("chant", -4.0, p, 4.0, 55.0) as AudioStreamPlayer3D
		h.pitch_scale = [0.94, 1.0, 1.06, 0.9, 1.12][i % 5]
		_hymns.append(h)
		i += 1
	_engine = main.loop("engine", -60.0) as AudioStreamPlayer


# ------------------------------------------------------------------ ground, sky, the dead tower

func _ground() -> void:
	solid_box(Vector3(1400, 2, 1400), Vector3(-150, -1.0, -200))
	var pm := PlaneMesh.new()
	pm.size = Vector2(1600, 1600)
	mesh(pm, Vector3(-150, -0.03, -200), mat(Color(0.05, 0.045, 0.045)))


## Stars: the one thing the blackout gave back to the city.
func _sky() -> void:
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	var bm := BoxMesh.new()
	bm.size = Vector3(1.6, 1.6, 1.6)
	mm.mesh = bm
	mm.instance_count = 520
	var r := RandomNumberGenerator.new()
	r.seed = 9
	for i in mm.instance_count:
		var a := r.randf() * TAU
		var e := r.randf_range(0.06, 1.45)
		var p := Vector3(cos(a) * cos(e), sin(e), sin(a) * cos(e)) * 1100.0
		var s := r.randf_range(0.5, 1.4)
		mm.set_instance_transform(i, Transform3D(Basis().scaled(Vector3.ONE * s), p))
	var mi := MultiMeshInstance3D.new()
	mi.multimesh = mm
	var sm := StandardMaterial3D.new()
	sm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	sm.albedo_color = Color(0.85, 0.88, 1.0)
	sm.disable_fog = true
	mi.material_override = sm
	mi.extra_cull_margin = 4000.0
	mi.position = Vector3(-100, 0, -200)
	add_child(mi)
	no_batch.append(mi)


func _tower() -> void:
	# the tower dark, for the first time in its life: jade without the seams
	var jade := mat(Color(0.1, 0.22, 0.19), 0.35, 0.6)
	var silver := mat(Color(0.3, 0.32, 0.34), 0.3, 0.8)
	var tp := Vector3(0, 0, 150.0)
	cyl(50.0, 56.0, 36.0, tp + Vector3(0, 18, 0), jade, 32)
	solid_box(Vector3(110, 36, 110), tp + Vector3(0, 18, 0))
	cyl(16.0, 30.0, 440.0, tp + Vector3(0, 256, 0), jade, 20)
	var tm := TorusMesh.new()
	tm.inner_radius = 58.0
	tm.outer_radius = 108.0
	tm.rings = 32
	tm.ring_segments = 12
	mesh(tm, tp + Vector3(0, 540, 0), silver)
	for pair in 4:
		for k: float in [-1.0, 1.0]:
			var ang: float = pair * PI / 2.0 + PI / 4.0 + k * 0.24
			var cm := CapsuleMesh.new()
			cm.radius = 12.0
			cm.height = 64.0
			var arm := mesh(cm, tp + Vector3(sin(ang) * 50.0, 24.0, cos(ang) * 50.0), silver if k > 0.0 else jade)
			arm.rotation = Vector3(0, ang, 0)
			arm.rotate_object_local(Vector3.FORWARD, 1.15)
	# the annex: our section of the muscle, a low block the lobby sits in
	var conc := pbr("concrete", Vector3(1, 1, 1) / 3.0, true, Color(0.42, 0.42, 0.44))
	box(Vector3(60, 12, 70), Vector3(0, 6.0, 65.0), conc, true)
	box(Vector3(60, 12, 2), Vector3(0, 6.0, 31.0), conc, true)
	box(Vector3(19, 12, 22), Vector3(-22.5, 6.0, 20.0), conc, true)
	box(Vector3(14, 12, 22), Vector3(26.0, 6.0, 20.0), conc, true)
	box(Vector3(60, 1.0, 22), Vector3(0, 11.5, 20.0), conc)
	box(Vector3(60, 0.6, 24), Vector3(0, 12.2, 20.0), mat(Color(0.08, 0.08, 0.09), 0.6, 0.3))


# ------------------------------------------------------------------ the stairwell

## Three floors of switchback flights in a concrete shaft east of the lobby,
## from the top landing (y 9) to the ground. Book ch.16: eight flights,
## "sweat dripped from my brow; my frames were slick with salt."
func _stairwell() -> void:
	var conc := pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.5, 0.5, 0.52))
	var step_m := pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.38, 0.38, 0.4))
	var rail := mat(Color(0.2, 0.2, 0.22), 0.4, 0.8)
	var x0 := SHAFT_X
	# walls, roof
	box(Vector3(0.4, 14, 10.4), Vector3(x0 + 3.2, 7.0, 18.0), conc, true)
	box(Vector3(0.4, 14, 8.1), Vector3(x0 - 3.2, 7.0, 16.85), conc, true)
	box(Vector3(0.4, 14, 1.1), Vector3(x0 - 3.2, 7.0, 22.65), conc, true)
	box(Vector3(0.4, 11.8, 1.2), Vector3(x0 - 3.2, 8.1, 21.5), conc, true)
	box(Vector3(6.8, 14, 0.4), Vector3(x0, 7.0, 23.2), conc, true)
	box(Vector3(6.8, 14, 0.4), Vector3(x0, 7.0, 12.8), conc, true)
	box(Vector3(6.8, 0.4, 10.8), Vector3(x0, 14.0, 18.0), conc)
	# the lobby door at the bottom of the shaft, west wall, and the top floor door
	var door_m := mat(Color(0.15, 0.14, 0.13), 0.6, 0.3)
	var leaf := box(Vector3(0.1, 2.2, 1.2), Vector3(x0 - 3.2 - 0.6, 1.1, 20.85), door_m)
	leaf.rotation.y = PI / 2.0
	box(Vector3(0.1, 2.2, 1.2), Vector3(x0 - 3.2, 10.6, 15.0), door_m)
	# landings: south (z 20..23) at y 0, 3, 6, 9; north (z 13..17) at 1.5, 4.5, 7.5, 10.5
	for f in 4:
		var ys := f * 3.0
		if f > 0:
			box(Vector3(6.4, 0.3, 3.2), Vector3(x0, ys - 0.15, 21.5), conc, true)
		box(Vector3(6.4, 0.3, 4.0), Vector3(x0, ys + 1.5 - 0.15, 15.0), conc, true)
	# flights: east half goes down from the south landing to the north one,
	# west half from the north landing down to the south one
	for f in 7:
		var top_y := 10.5 - f * 1.5
		var east := f % 2 == 1
		var hx := x0 + (1.6 if east else -1.6)
		var za := 20.0 if east else 17.0     # the top of the flight
		var zb := 17.0 if east else 20.0     # the bottom
		for s in 10:
			var t := (s + 0.5) / 10.0
			var y := top_y - s * 0.15
			box(Vector3(3.0, 0.15, 0.3), Vector3(hx, y - 0.075, lerpf(za, zb, t)), step_m)
		var ramp := solid_box(Vector3(3.0, 0.16, 3.36), Vector3(hx, top_y - 0.75 - 0.1, 18.5))
		ramp.rotation.x = atan2(1.5, 3.0) * (-1.0 if east else 1.0)
		# handrail down the middle
		var ra := Vector3(x0, top_y + 0.95, za)
		var rb := Vector3(x0, top_y - 1.5 + 0.95, zb)
		stick(ra, rb, 0.03, rail)
		stick(ra, ra - Vector3(0, 0.95, 0), 0.025, rail)
	box(Vector3(0.08, 1.0, 10.0), Vector3(x0, 0.5, 18.0), rail)
	solid_box(Vector3(0.1, 2.0, 10.0), Vector3(x0, 1.0, 18.0))
	# a candle someone left at the 3 m landing, two rings of wax
	_candle(Vector3(x0 + 2.2, 3.0, 22.4), true, 1.1, 6.0)
	interactable("stair_candle", "Look at the candle", Vector3(x0 + 2.2, 3.3, 22.4), Vector3(0.6, 0.6, 0.6), "", false)
	# the fuse panel on the top landing, hackable and dead
	prop("fuse_panel", Vector3(x0 + 2.95, 9.0 + 1.5, 20.0), -PI / 2.0, 1.0, false)
	interactable("fuse", "Look at the fuse panel", Vector3(x0 + 2.9, 10.5, 20.0), Vector3(0.3, 0.9, 0.9), "FUSE PANEL 86-E\nVOLTX\nbreakers: ALL UP\ngrid: NO SIGNAL", false).set_meta("hackable", true)
	# the dead EXIT sign over the ground landing: an eye in it with the frames on
	box(Vector3(0.7, 0.25, 0.08), Vector3(x0 - 2.0, 2.6, 21.5), mat(Color(0.12, 0.1, 0.1), 0.6))
	var l := label("EXIT", Vector3(x0 - 2.0, 2.6, 21.56), 0.0, 0.004, Color(0.25, 0.08, 0.06), self, false)
	l.font_size = 64
	interactable("exit_sign", "Look at the exit sign", Vector3(x0 - 2.0, 2.6, 21.5), Vector3(0.8, 0.4, 0.3), "", false)
	var e := _screen_eye(Vector3(x0 - 2.0, 2.6, 21.58), 0.0, 0.0016)
	eyes.append(e)
	# pipes and a duct up the shaft
	for k in 3:
		stick(Vector3(x0 + 3.0 - k * 0.2, 0.0, 13.3 + k * 0.25), Vector3(x0 + 3.0 - k * 0.2, 14.0, 13.3 + k * 0.25), 0.05, rail)
	prop("modular_airduct_circular_01", Vector3(x0, 13.2, 20.0), PI / 2.0, 1.0, false)


# ------------------------------------------------------------------ the lobby

func _lobby() -> void:
	var floor_m := pbr("paving", Vector3(1, 1, 1) / 2.0, true, Color(0.45, 0.45, 0.47), 0.5)
	var wall_m := pbr("plaster", Vector3(1, 1, 1) / 3.0, true, Color(0.5, 0.5, 0.52))
	var k := _kit_mats()
	floor_quad(Vector2(26, 20), Vector3(0, 0.0, LOBBY_Z), 0.0, floor_m)
	box(Vector3(26, 0.3, 20), Vector3(0, 6.85, LOBBY_Z), mat(Color(0.1, 0.1, 0.11), 0.9))
	box(Vector3(0.4, 7, 20), Vector3(-13.0, 3.5, LOBBY_Z), wall_m, true)
	box(Vector3(0.4, 7, 2.8), Vector3(13.0, 3.5, 11.4), wall_m, true)
	box(Vector3(0.4, 7, 6.8), Vector3(13.0, 3.5, 26.6), wall_m, true)
	box(Vector3(26, 7, 0.4), Vector3(0, 3.5, 30.0), wall_m, true)
	# glass front at z 10 either side of the doors, with mullions
	for side: float in [-1.0, 1.0]:
		var cx := side * 7.25
		box(Vector3(11.5, 6.6, 0.08), Vector3(cx, 3.5, DOOR_Z), k["glass"])
		solid_box(Vector3(11.5, 7, 0.3), Vector3(cx, 3.5, DOOR_Z))
		for i in 4:
			box(Vector3(0.1, 6.8, 0.14), Vector3(cx - 5.75 + i * 11.5 / 3.0, 3.4, DOOR_Z), k["dark"])
	box(Vector3(26, 0.5, 0.3), Vector3(0, 6.8, DOOR_Z), k["dark"])
	# the manual double doors: two leaves on pivots, a collider until opened
	var leaf_m := mat(Color(0.2, 0.2, 0.22), 0.4, 0.7)
	for side: float in [-1.0, 1.0]:
		var pv := Node3D.new()
		pv.position = Vector3(side * 1.5, 0, DOOR_Z)
		add_child(pv)
		box(Vector3(1.5, 3.2, 0.1), Vector3(-side * 0.75, 1.6, 0), leaf_m, false, pv)
		box(Vector3(0.5, 1.4, 0.06), Vector3(-side * 0.75, 1.9, 0.08), k["glass"], false, pv)
		box(Vector3(0.05, 0.6, 0.06), Vector3(-side * 1.3, 1.1, 0.12), mat(Color(0.5, 0.5, 0.5), 0.3, 0.9), false, pv)
		doors.append(pv)
	door_body = solid_box(Vector3(3.0, 3.2, 0.3), Vector3(0, 1.6, DOOR_Z))
	door_area = interactable("doors", "Open the doors", Vector3(0, 1.6, DOOR_Z), Vector3(3.0, 3.2, 0.5), "", false)
	box(Vector3(3.2, 0.4, 0.3), Vector3(0, 3.4, DOOR_Z), k["dark"])
	var l := label("PSYONIC INTEGRATIONS", Vector3(0, 5.6, DOOR_Z + 0.2), PI, 0.014, Color(0.16, 0.2, 0.18), self, false)
	l.double_sided = true
	# columns
	for p: Vector3 in [Vector3(-6, 0, 16), Vector3(6, 0, 16), Vector3(-6, 0, 25), Vector3(6, 0, 25)]:
		cyl(0.45, 0.45, 7.0, p + Vector3(0, 3.5, 0), wall_m, 10)
		solid_box(Vector3(0.9, 7, 0.9), p + Vector3(0, 3.5, 0))
	# the reception desk, dead tablet, mints, a visitor badge for E. Elontiel
	var desk_z := 27.0
	prop("metal_office_desk", Vector3(-1.0, 0, desk_z), 0.0, 1.0, true)
	prop("metal_office_desk", Vector3(1.0, 0, desk_z), 0.0, 1.0, true)
	box(Vector3(0.3, 0.02, 0.2), Vector3(-0.6, 0.8, desk_z - 0.2), mat(Color(0.03, 0.03, 0.03), 0.2), false)
	cyl(0.12, 0.1, 0.06, Vector3(0.9, 0.82, desk_z - 0.2), mat(Color(0.9, 0.9, 0.9), 0.3), 8)
	box(Vector3(0.08, 0.005, 0.11), Vector3(0.3, 0.8, desk_z - 0.25), mat(Color(0.95, 0.95, 0.9), 0.8), false)
	interactable("desk", "Look at the reception desk", Vector3(0, 0.6, desk_z), Vector3(4.0, 1.0, 1.2), "RECEPTION\nvisitor log: NO SIGNAL\nlast badge: ELONTIEL, E.", false)
	# turnstiles, standing open
	for i in 3:
		var tx := -4.0 + i * 4.0
		box(Vector3(0.5, 1.0, 1.8), Vector3(tx - 1.0, 0.5, 14.0), mat(Color(0.3, 0.3, 0.32), 0.3, 0.8), true)
		box(Vector3(0.5, 1.0, 1.8), Vector3(tx + 1.0, 0.5, 14.0), mat(Color(0.3, 0.3, 0.32), 0.3, 0.8), true)
		box(Vector3(0.06, 1.0, 0.9), Vector3(tx - 0.7, 1.4, 14.0), k["glass"])
		box(Vector3(0.06, 1.0, 0.9), Vector3(tx + 0.7, 1.4, 14.0), k["glass"])
		# the gate paddles swung open
		var pd := box(Vector3(0.04, 0.6, 0.9), Vector3(tx - 0.4, 0.8, 13.5), k["glass"])
		pd.rotation.y = 1.2
		var pd2 := box(Vector3(0.04, 0.6, 0.9), Vector3(tx + 0.4, 0.8, 13.5), k["glass"])
		pd2.rotation.y = -1.2
	interactable("turnstile", "Look at the turnstiles", Vector3(0, 0.7, 14.0), Vector3(1.4, 1.4, 1.9), "", false)
	# the directory screen on the east wall, the dead kiosk, the atm, a dead camera
	box(Vector3(0.12, 2.4, 3.6), Vector3(12.75, 2.6, 25.0), k["dark"])
	box(Vector3(0.04, 2.2, 3.4), Vector3(12.66, 2.6, 25.0), mat(Color(0.02, 0.02, 0.025), 0.1, 0.3))
	interactable("screen", "Look at the directory screen", Vector3(12.6, 2.6, 25.0), Vector3(0.4, 2.4, 3.6), "DIRECTORY\nPSYONIC INTEGRATIONS\nNO SIGNAL", false)
	eyes.append(_screen_eye(Vector3(12.62, 2.6, 25.0), -PI / 2.0, 0.012))
	prop("vending_kiosk", Vector3(-11.6, 0, 24.0), PI / 2.0, 1.0, true)
	interactable("kiosk", "Use the city terminal", Vector3(-11.6, 1.0, 24.0), Vector3(1.0, 1.9, 1.8), "CITY TERMINAL 02\nservices: NONE\nNO SIGNAL", false)
	prop("atm", Vector3(-12.2, 0, 19.0), PI / 2.0, 1.0, true)
	prop("security_camera_01", Vector3(-12.6, 6.0, 12.0), PI / 2.0 + 0.6, 1.0, false)
	interactable("lobby_cam", "Look at the camera", Vector3(-12.4, 6.0, 12.0), Vector3(0.6, 0.5, 0.8), "LOBBY CAMERA 1\nfeed: NO SIGNAL", false).set_meta("hackable", true)
	for i in 4:
		prop("mounted_fluorescent_lights", Vector3(-6.0 + i * 4.0, 6.8, LOBBY_Z), 0.0, 1.0, false)
	# planters and a bench
	for p: Vector3 in [Vector3(-9.0, 0, 13.0), Vector3(9.0, 0, 13.0)]:
		box(Vector3(2.0, 0.6, 1.0), p + Vector3(0, 0.3, 0), mat(Color(0.2, 0.2, 0.21), 0.8), true)
		cyl(0.3, 0.35, 1.8, p + Vector3(0, 1.5, 0), mat(Color(0.14, 0.24, 0.16), 0.8), 7)
	box(Vector3(2.4, 0.08, 0.5), Vector3(-9.0, 0.48, 27.0), pbr("woodfloor", Vector3(1, 1, 1), true, Color(0.5, 0.42, 0.34)), true)


func _screen_eye(pos: Vector3, rot_y: float, px: float) -> Sprite3D:
	var s := Sprite3D.new()
	s.texture = _glyph_tex
	s.pixel_size = px
	s.position = pos
	s.rotation.y = rot_y
	s.modulate = Color(1.0, 0.1, 0.08)
	s.shaded = false
	s.double_sided = true
	s.visible = false
	add_child(s)
	return s


# ------------------------------------------------------------------ the garden and the vigil

## The garden adjacent to the parking lot: the Spine plaza's cacti and palms,
## a fountain with its pumps dead, dead lamps, a drone already down.
func _garden() -> void:
	var stone := pbr("paving", Vector3(1, 1, 1) / 2.5, true, Color(0.5, 0.5, 0.5), 0.6)
	floor_quad(Vector2(44, 54), Vector3(-8.0, 0.02, -17.0), 0.0, stone)
	var green := mat(Color(0.14, 0.24, 0.16), 0.8)
	var trunk := mat(Color(0.3, 0.23, 0.16), 0.9)
	var frond := newmat(Color(0.12, 0.22, 0.12), 0.8)
	frond.cull_mode = BaseMaterial3D.CULL_DISABLED
	var bed := mat(Color(0.3, 0.2, 0.13), 1.0)
	var z := 4.0
	while z > -42.0:
		for side: float in [-1.0, 1.0]:
			var x := side * 6.5
			if int(absf(z)) % 16 < 8:
				cyl(0.35, 0.4, 2.6, Vector3(x, 1.3, z), green, 8)
				cyl(0.2, 0.22, 1.0, Vector3(x + 0.5, 1.6, z), green, 6).rotation.z = -0.9
				cyl(0.2, 0.22, 0.9, Vector3(x - 0.45, 1.9, z), green, 6).rotation.z = 0.9
				solid_box(Vector3(0.9, 2.6, 0.9), Vector3(x, 1.3, z))
			else:
				cyl(0.18, 0.3, 7.0, Vector3(x, 3.5, z), trunk, 8)
				for f in 6:
					var leaf := box(Vector3(0.6, 0.05, 3.2), Vector3(x, 7.0, z), frond)
					leaf.rotation = Vector3(-0.5, f * TAU / 6.0, 0)
					leaf.position += Vector3(sin(f * TAU / 6.0), -0.6, cos(f * TAU / 6.0)) * 1.3
				solid_box(Vector3(0.6, 7.0, 0.6), Vector3(x, 3.5, z))
			box(Vector3(2.5, 0.3, 4.0), Vector3(x, 0.15, z), bed)
		z -= 8.0
	# dead plaza lamps
	for p: Vector3 in [Vector3(-12, 0, -4), Vector3(-12, 0, -34), Vector3(-24, 0, -10), Vector3(-24, 0, -32), Vector3(10, 0, -6)]:
		prop("street_lamp_01", p, rng.randf() * TAU, 1.3, true)
	# the fountain: a basin, a dead jet, black water
	var basin := pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.45, 0.45, 0.45))
	cyl(3.4, 3.6, 0.6, FOUNTAIN + Vector3(0, 0.3, 0), basin, 20)
	cyl(2.9, 2.9, 0.62, FOUNTAIN + Vector3(0, 0.3, 0), mat(Color(0.02, 0.02, 0.03), 0.05, 0.5), 20)
	cyl(0.3, 0.5, 1.4, FOUNTAIN + Vector3(0, 0.9, 0), basin, 10)
	var cs := StaticBody3D.new()
	var sh := CylinderShape3D.new()
	sh.radius = 3.6
	sh.height = 0.6
	var c := CollisionShape3D.new()
	c.shape = sh
	c.position = Vector3(0, 0.3, 0)
	cs.add_child(c)
	cs.position = FOUNTAIN
	add_child(cs)
	interactable("fountain", "Look at the fountain", FOUNTAIN + Vector3(0, 1.0, 0), Vector3(1.4, 1.6, 1.4), "", false)
	# the drone that came down before the vigil started
	var w: Node3D = prop("delivery_drone", Vector3(6.0, 0.25, -34.0), 0.4, 1.6, true)
	if w:
		w.rotation.x = 0.9
		w.rotation.z = 0.3
	for i in 3:
		prop("cardboard_box_01", Vector3(6.8 + i * 0.6, 0.0, -35.5 + i * 0.4), rng.randf() * TAU, 1.0, false)
	interactable("wreck", "Look at the fallen drone", Vector3(6.3, 0.5, -34.5), Vector3(1.8, 1.0, 2.0), "DELIVERY DRONE NX-2210\nNIXTRA\nstatus: NO SIGNAL\ncargo: DINNER FOR TWO", false)
	# benches, bins, a dead ad kiosk by the lot gate
	var wood := pbr("woodfloor", Vector3(1, 1, 1), true, Color(0.45, 0.38, 0.3))
	for p: Vector3 in [Vector3(-10.0, 0, -8.0), Vector3(-10.0, 0, -30.0), Vector3(3.0, 0, -12.0)]:
		box(Vector3(2.2, 0.08, 0.5), p + Vector3(0, 0.48, 0), wood, true)
		box(Vector3(2.2, 0.5, 0.08), p + Vector3(0, 0.75, -0.25), wood)
		for sx: float in [-0.9, 0.9]:
			box(Vector3(0.08, 0.46, 0.5), p + Vector3(sx, 0.23, 0), mat(Color(0.15, 0.15, 0.16), 0.5, 0.7))
	prop("metal_trash_can", Vector3(-8.0, 0, -8.0), 0.0, 1.0, true)
	prop("metal_trash_can", Vector3(11.0, 0, -22.0), 0.0, 1.0, true)
	prop("fire_hydrant", Vector3(12.5, 0, -40.0), 0.0, 1.0, true)
	# the far side of the garden: a dark service wall with a few cables
	var conc := pbr("concrete", Vector3(1, 1, 1) / 3.0, true, Color(0.38, 0.38, 0.4))
	box(Vector3(2, 16, 30), Vector3(-31.0, 8.0, -3.0), conc, true)
	box(Vector3(2, 16, 14), Vector3(-31.0, 8.0, -37.0), conc, true)
	box(Vector3(2, 16, 3.4), Vector3(-31.0, 8.0, -19.6), conc, true)
	box(Vector3(2, 16, 3.4), Vector3(-31.0, 8.0, -28.4), conc, true)
	box(Vector3(14, 0.5, 14), Vector3(-37.0, 5.5, -24.0), conc)  # the alley's roof
	for i in 3:
		cable(Vector3(-30.0, 9.0 + i, -8.0 - i * 6.0), Vector3(-13.0, 7.5 + i * 0.5, -10.0 - i * 6.0), 1.2)


## Annie Seung's vigil: a circle of coworkers round the candles, every one
## of them facing in, singing Mira's hymn to bring the power back.
func _vigil() -> void:
	var r := 3.6
	var n := 11
	var coats := [Color(0.1, 0.1, 0.12), Color(0.18, 0.14, 0.12), Color(0.24, 0.24, 0.26), Color(0.1, 0.14, 0.18)]
	var skins := [Color(0.85, 0.66, 0.52), Color(0.6, 0.42, 0.3), Color(0.4, 0.28, 0.2)]
	for i in n:
		var a := i * TAU / n + 0.35
		var p := VIGIL_C + Vector3(cos(a) * r, 0.02, sin(a) * r)
		if i == 0:
			continue  # Annie's place
		if i == 4:
			continue  # the singer's place
		var f := figure(coats[i % coats.size()], skins[i % skins.size()], {"long_hair": i % 3 == 0})
		f.position = p
		add_child(f)
		turn_to(f, VIGIL_C)
		(f.get_meta("head") as Node3D).rotation.x = -0.25
		if i == 7:
			hurt_fig = f
			continue  # kept whole: she falls when the drone does
		_flatten(f)
		var d := (VIGIL_C - p).normalized()
		_candle(p + d * 0.42 + Vector3(0, 1.12, 0), false)
	# candles on the ground in the middle, in two rings
	for i in 8:
		var a := i * TAU / 8.0
		_candle(VIGIL_C + Vector3(cos(a) * 1.0, 0.0, sin(a) * 1.0), true)
	for i in 5:
		var a := i * TAU / 5.0 + 0.4
		_candle(VIGIL_C + Vector3(cos(a) * 0.45, 0.0, sin(a) * 0.45), true)
	vigil_light = light(VIGIL_C + Vector3(0, 1.4, 0), Color(1.0, 0.55, 0.22), 2.4, 12.0, false)
	candles.append([vigil_light, 2.4])
	# the blood under the seventh singer, hidden until the drone falls
	hurt_blood = floor_quad(Vector2(2.2, 2.2), hurt_fig.position + Vector3(0, 0.03, 0), 0.6, decal_mat(Tex.blood(), Color(0.5, 0.05, 0.04)))
	hurt_blood.visible = false
	no_batch.append(hurt_blood)


## A candle: wax, a flame that is the only light in the city tonight.
func _candle(p: Vector3, standing: bool, h := 0.0, _unused := 0.0) -> void:
	var wax := mat(Color(0.9, 0.86, 0.72), 0.7)
	var flame := glow(Color(1.0, 0.6, 0.18), 4.5)
	var hh := 0.18 if standing else 0.14
	if standing:
		cyl(0.03, 0.035, hh, p + Vector3(0, hh / 2.0, 0), wax, 6)
		box(Vector3(0.03, 0.06, 0.03), p + Vector3(0, hh + 0.03, 0), flame)
	else:
		cyl(0.028, 0.03, hh, p, wax, 6)
		box(Vector3(0.03, 0.06, 0.03), p + Vector3(0, hh / 2.0 + 0.03, 0), flame)
	if h > 0.0:
		candles.append([light(p + Vector3(0, 0.5, 0), Color(1.0, 0.55, 0.22), h, 6.0, false), h])


# ------------------------------------------------------------------ the parking lot

func _lot() -> void:
	var asphalt := pbr("asphalt", Vector3(1, 1, 1) / 4.0, true, Color(0.6, 0.6, 0.62), 0.5)
	floor_quad(Vector2(30, 36), Vector3(29.0, 0.01, -26.0), 0.0, asphalt)
	var line := mat(Color(0.5, 0.48, 0.4), 0.6)
	var conc := pbr("concrete", Vector3(1, 1, 1) / 3.0, true, Color(0.4, 0.4, 0.42))
	# the low wall between garden and lot, with the gate gap at z -24..-30
	box(Vector3(0.4, 1.2, 32.0), Vector3(14.0, 0.6, -6.0), conc, true)
	box(Vector3(0.4, 1.2, 12.0), Vector3(14.0, 0.6, -38.0), conc, true)
	# bays along the east wall and the north
	for i in 6:
		var bz := -12.0 - i * 4.5
		box(Vector3(5.0, 0.01, 0.12), Vector3(40.0, 0.02, bz), line)
	var paints := [Color(0.05, 0.05, 0.06), Color(0.5, 0.52, 0.55), Color(0.3, 0.06, 0.08), Color(0.08, 0.18, 0.28)]
	for i in 5:
		var cz := -14.0 - i * 4.5
		var body := Car.build(self, paints[i % paints.size()], {"plate": "PSY %d" % (80 + i)})
		body.position = Vector3(40.0, 0, cz)
		body.rotation.y = PI / 2.0
		add_child(body)
		solid_box(Vector3(4.6, 1.6, 2.0), Vector3(40.0, 0.8, cz))
		interactable("parked_%d" % i, "Look at the car", Vector3(40.0, 0.9, cz), Vector3(4.6, 1.8, 2.1), "PSYONIC FLEET 00%d\nNO SIGNAL" % (80 + i), false)
	# the charge posts, dead, with the glyph on the first
	for k in 3:
		var p := Vector3(19.0, 0.8, -30.0 - k * 4.0)
		box(Vector3(0.4, 1.6, 0.5), p, mat(Color(0.7, 0.7, 0.72), 0.3, 0.2))
		box(Vector3(0.42, 0.08, 0.52), p + Vector3(0, 0.6, 0), mat(Color(0.1, 0.1, 0.1), 0.5))
	interactable("charger", "Check the charge post", Vector3(19.0, 0.8, -30.0), Vector3(0.5, 1.6, 0.6),
		"FLEET CHARGER 1\nNO SIGNAL\nlast vehicle: DORNER, P.")
	_glyph_on(Vector3(19.22, 1.3, -30.0), PI / 2.0, 0.004, "g_charger", false, false, L("lot", "charger_glyph"))
	# the lot's north and east walls, the utility box, a shutter, the aircon units
	box(Vector3(13, 8, 0.6), Vector3(20.5, 4.0, -8.0), conc, true)
	box(Vector3(13, 8, 0.6), Vector3(37.5, 4.0, -8.0), conc, true)
	box(Vector3(0.6, 8, 36), Vector3(44.0, 4.0, -26.0), conc, true)
	prop("utility_box_01", Vector3(43.6, 0, -20.0), -PI / 2.0, 1.0, true)
	interactable("utility", "Look at the utility box", Vector3(43.4, 0.6, -20.0), Vector3(0.6, 1.2, 0.7), L("lot", "utility_scan"), false).set_meta("hackable", true)
	prop("rollershutter_door", Vector3(36.0, 0, -8.3), 0.0, 1.0, false)
	interactable("shutter", "Look at the shutter", Vector3(36.0, 1.2, -8.2), Vector3(1.2, 2.4, 0.4), "", false)
	for i in 3:
		prop("exterior_aircon_unit", Vector3(43.6, 2.5 + i * 1.3, -32.0 - i * 1.2), -PI / 2.0, 1.0, false)
	prop("street_lamp_01", Vector3(16.0, 0, -22.0), 0.0, 1.3, true)
	prop("street_lamp_01", Vector3(36.0, 0, -42.0), 0.0, 1.3, true)
	prop("concrete_road_barrier", Vector3(17.0, 0, -42.5), 0.2, 1.0, true)
	prop("Barrel_01", Vector3(42.5, 0, -40.0), 0.0, 1.0, true)
	# the north alley off the lot: the woman in the sleeping bag
	box(Vector3(0.6, 8, 10), Vector3(31.0, 4.0, -3.0), conc, true)
	box(Vector3(0.6, 8, 10), Vector3(27.0, 4.0, -3.0), conc, true)
	box(Vector3(4.6, 0.5, 10), Vector3(29.0, 7.0, -3.0), conc)
	floor_quad(Vector2(4, 10), Vector3(29.0, 0.012, -3.0), 0.0, pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.35, 0.33, 0.32)))
	box(Vector3(4.6, 8, 0.6), Vector3(29.0, 4.0, 2.0), conc, true)
	# the wall gap into the alley
	for i in 2:
		prop("cardboard_box_01", Vector3(30.2, 0.0 + i * 0.35, -1.0), 0.3 * i, 1.0, false)
	prop("plastic_crate_03", Vector3(27.8, 0, 0.5), 0.5, 1.0, true)
	var bag := box(Vector3(0.8, 0.35, 2.0), Vector3(30.0, 0.17, -5.0), mat(Color(0.22, 0.2, 0.3), 0.9), true)
	bag.rotation.y = 0.15
	_candle(Vector3(29.2, 0.0, -4.6), true, 0.9, 5.0)
	var stick_m := mat(Color(0.35, 0.28, 0.2), 0.9)
	for i in 7:
		var a := i * TAU / 7.0
		stick(Vector3(29.2 + cos(a) * 0.3, 0.02, -4.6 + sin(a) * 0.3), Vector3(29.2 + cos(a + 0.9) * 0.3, 0.02, -4.6 + sin(a + 0.9) * 0.3), 0.012, stick_m)
	interactable("vagrant_n", "Talk to the woman", Vector3(30.0, 0.5, -5.0), Vector3(1.0, 1.0, 2.0), L("lot", "vagrant_n_scan"), false).set_meta("vagrant", true)


# ------------------------------------------------------------------ the alleys

## The west alley off the garden: a man with a candle, a dead camera, and
## the eyeless one at its mouth with his face toward the singing.
func _alleys() -> void:
	var conc := pbr("concrete", Vector3(1, 1, 1) / 2.0, true, Color(0.33, 0.32, 0.31))
	floor_quad(Vector2(16, 5), Vector3(-38.0, 0.012, -24.0), 0.0, conc)
	box(Vector3(14, 10, 0.6), Vector3(-39.0, 5.0, -21.3), conc, true)
	box(Vector3(14, 10, 0.6), Vector3(-39.0, 5.0, -26.7), conc, true)
	box(Vector3(0.6, 10, 6), Vector3(-46.0, 5.0, -24.0), conc, true)
	prop("Barrel_01", Vector3(-43.0, 0, -22.5), 0.3, 1.0, true)
	interactable("barrel", "Look at the barrel", Vector3(-43.0, 0.5, -22.5), Vector3(0.8, 1.0, 0.8), "", false)
	prop("old_tyre", Vector3(-41.0, 0.1, -25.8), 0.0, 1.0, false)
	prop("metal_trash_can", Vector3(-36.0, 0, -22.0), 0.0, 1.0, true)
	for i in 3:
		prop("cardboard_box_01", Vector3(-44.5 + i * 0.5, 0.0, -25.5), i * 0.4, 1.0, false)
	prop("security_camera_01", Vector3(-32.2, 4.2, -22.0), PI / 2.0 + 0.5, 1.0, false)
	interactable("alley_cam", "Look at the camera", Vector3(-32.4, 4.2, -22.0), Vector3(0.6, 0.5, 0.8), L("alley", "camera_scan"), false).set_meta("hackable", true)
	prop("modular_electric_cables", Vector3(-38.0, 2.0, -21.0), 0.0, 1.0, false)
	prop("power_box_01", Vector3(-40.0, 1.6, -21.0), 0.0, 1.0, false)
	_candle(Vector3(-42.0, 0.0, -24.4), true, 0.8, 5.0)
	# the man against the wall
	var vg := figure(Color(0.2, 0.17, 0.13), Color(0.6, 0.42, 0.3), {"arms": true, "knees": true})
	vg.position = Vector3(-42.0, 0.02 - 0.42, -25.6)
	vg.rotation.y = 0.0
	add_child(vg)
	Anim.crouch(vg)
	person("vagrant_w", "Talk to the man", vg, L("alley", "vagrant_w_scan")).set_meta("vagrant", true)
	# the eyeless one at the alley mouth, a statue until the frames are on
	eyeless = figure(Color(0.72, 0.7, 0.64), Color(0.8, 0.62, 0.5), {"arms": true, "knees": true})
	eyeless.position = Vector3(-29.0, 0.02, -24.0)
	add_child(eyeless)
	turn_to(eyeless, VIGIL_C)
	var hollow: StandardMaterial3D = mat(Color(0.35, 0.22, 0.2), 1.0)
	for s: float in [-1.0, 1.0]:
		box(Vector3(0.05, 0.025, 0.02), Vector3(s * 0.045, 0.02, -0.112), hollow, false, eyeless.get_meta("head"))
	person("eyeless_w", "Look at the eyeless man", eyeless, L("alley", "eyeless_scan")).set_meta("eyeless", true)


# ------------------------------------------------------------------ the streets of the drive

## The street south from the lot to Fargona, every block dead, a candle
## circle on each corner, the dead lamps, the drones overhead.
func _streets() -> void:
	var asphalt := pbr("asphalt", Vector3(1, 1, 1) / 4.0, true, Color(0.6, 0.6, 0.62), 0.5)
	var pave := pbr("paving", Vector3(1, 1, 1) / 2.5, true, Color(0.55, 0.55, 0.55), 0.6)
	var line := mat(Color(0.5, 0.48, 0.4), 0.6)
	# the north-south street at x 24
	floor_quad(Vector2(16, 370), Vector3(STREET_X, 0.0, -229.0), 0.0, asphalt)
	for side: float in [-1.0, 1.0]:
		floor_quad(Vector2(6, 370), Vector3(STREET_X + side * 11.0, 0.08, -229.0), 0.0, pave)
	var z := -50.0
	while z > -400.0:
		box(Vector3(0.14, 0.01, 3.0), Vector3(STREET_X, 0.01, z), line)
		z -= 9.0
	# Fargona Avenue along -X at z -404
	floor_quad(Vector2(340, 16), Vector3(-128.0, 0.0, FARGONA_Z), 0.0, asphalt)
	for side: float in [-1.0, 1.0]:
		floor_quad(Vector2(340, 6), Vector3(-128.0, 0.08, FARGONA_Z + side * 11.0), 0.0, pave)
	var x := 10.0
	while x > -296.0:
		box(Vector3(3.0, 0.01, 0.14), Vector3(x, 0.01, FARGONA_Z), line)
		x -= 9.0
	# the blocks: dead, with cross streets where the vigils stand
	var gaps_z := [-130.0, -210.0, -290.0]
	for side: float in [-1.0, 1.0]:
		var zz := -46.0
		while zz > -388.0:
			var depth := rng.randf_range(14.0, 26.0)
			var gap := false
			for g: float in gaps_z:
				if zz > g + 6.0 and zz - depth < g + 6.0:
					depth = zz - (g + 6.0)
				elif zz <= g + 6.0 and zz > g - 6.0:
					gap = true
			if gap:
				zz = _cross_street(zz, side)
				continue
			if depth < 5.0:
				zz -= depth
				continue
			depth = minf(depth, zz + 388.0)
			if depth < 6.0:
				break
			var h := rng.randf_range(16.0, 58.0)
			if rng.randf() < 0.2:
				h = rng.randf_range(70.0, 120.0)
			cyber_block(Vector3(STREET_X + side * 14.0, 0, zz - depth / 2.0), side * PI / 2.0, depth, h, 22.0, true)
			zz -= depth
			if rng.randf() < 0.25:
				zz -= 3.5
	# Fargona's blocks, both sides, with one cross street at x -70
	for side: float in [-1.0, 1.0]:
		var xx := -14.0 if side > 0.0 else 10.0
		while xx > -292.0:
			var depth := rng.randf_range(14.0, 28.0)
			if xx > -64.0 and xx - depth < -64.0:
				depth = xx + 64.0
			elif xx <= -64.0 and xx > -76.0:
				xx = -76.0
				var vz := FARGONA_Z + side * 12.5
				_vigil_circle(Vector3(-67.0, 0, vz), 2.6, 6, int(xx))
				floor_quad(Vector2(12, 60), Vector3(-70.0, 0.005, FARGONA_Z + side * 44.0), 0.0, asphalt)
				continue
			if depth < 5.0:
				xx -= depth
				continue
			depth = minf(depth, xx + 292.0)
			if depth < 6.0:
				break
			var h := rng.randf_range(16.0, 52.0)
			if rng.randf() < 0.18:
				h = rng.randf_range(65.0, 100.0)
			# south side (z -390) faces -Z, north side (z -418) faces +Z
			cyber_block(Vector3(xx - depth / 2.0, 0, FARGONA_Z + side * 14.0), PI if side > 0.0 else 0.0, depth, h, 22.0, true)
			xx -= depth
			if rng.randf() < 0.25:
				xx -= 3.5
	# the corner block at the junction
	cyber_block(Vector3(STREET_X + 14.0, 0, -404.0), -PI / 2.0, 28.0, 40.0, 22.0, true)
	cyber_block(Vector3(STREET_X + 14.0, 0, -432.0), -PI / 2.0, 28.0, 30.0, 22.0, true)
	box(Vector3(2, 40, 420), Vector3(STREET_X + 60.0, 20, -230), mat(Color(0.05, 0.05, 0.06)))
	# dead street lamps, both streets
	z = -60.0
	while z > -390.0:
		for side: float in [-1.0, 1.0]:
			prop("street_lamp_01", Vector3(STREET_X + side * 9.0, 0, z), PI / 2.0 - side * PI / 2.0, 1.4, false)
		z -= 30.0
	x = -6.0
	while x > -292.0:
		for side: float in [-1.0, 1.0]:
			prop("street_lamp_01", Vector3(x, 0, FARGONA_Z + side * 9.0), PI if side > 0.0 else 0.0, 1.4, false)
		x -= 30.0
	# dead holograms hanging over the lanes, dark frames without their light
	for hz: float in [-90.0, -250.0, -340.0]:
		var hy := rng.randf_range(10.0, 14.0)
		stick(Vector3(STREET_X + rng.randf_range(-3, 3), hy + 2.0, hz), Vector3(STREET_X, hy, hz), 0.02, _kit_mats()["cable"])
		box(Vector3(1.6, 0.6, 0.08), Vector3(STREET_X, hy - 0.3, hz), _kit_mats()["dark"])
	var cz2 := -56.0
	while cz2 > -392.0:
		for i in rng.randi_range(1, 3):
			var y := rng.randf_range(8.0, 15.0)
			cable(Vector3(STREET_X - 13.9, y, cz2 + rng.randf_range(-3, 3)), Vector3(STREET_X + 13.9, y + rng.randf_range(-1.5, 1.5), cz2 + rng.randf_range(-3, 3)), rng.randf_range(0.6, 1.6))
		cz2 -= rng.randf_range(16.0, 30.0)
	for bz: float in [-170.0, -330.0]:
		skybridge(Vector3(STREET_X - 14.0, rng.randf_range(24.0, 36.0), bz), Vector3(STREET_X + 14.0, rng.randf_range(24.0, 36.0), bz), 4.0)
	skybridge(Vector3(-200.0, 28.0, FARGONA_Z - 14.0), Vector3(-200.0, 30.0, FARGONA_Z + 14.0), 4.0)
	# a few more fallen drones on the pavements, where the dark had taken them
	for p: Vector3 in [Vector3(STREET_X + 11.0, 0.2, -95.0), Vector3(STREET_X - 12.0, 0.2, -240.0), Vector3(-40.0, 0.2, FARGONA_Z + 10.5), Vector3(-200.0, 0.2, FARGONA_Z - 11.0)]:
		var d: Node3D = prop("delivery_drone", p, rng.randf() * TAU, 1.6, false)
		if d:
			d.rotation.x = rng.randf_range(0.5, 1.2)
	for p: Vector3 in [Vector3(STREET_X - 11.5, 0, -160.0), Vector3(STREET_X + 11.5, 0, -320.0), Vector3(-150.0, 0, FARGONA_Z + 11.5)]:
		prop("metal_trash_can", p, 0.0, 1.0, false)
		prop("Barrel_01", p + Vector3(0.9, 0, 0.6), 0.4, 1.0, false)


## A cross street gap with a vigil on each corner; returns the next z.
func _cross_street(zz: float, side: float) -> float:
	var asphalt := pbr("asphalt", Vector3(1, 1, 1) / 4.0, true, Color(0.6, 0.6, 0.62), 0.5)
	var g := zz - 6.0
	floor_quad(Vector2(60, 12), Vector3(STREET_X + side * 40.0, 0.005, g), 0.0, asphalt)
	# blocks deeper in, facing the cross street
	for k in 2:
		cyber_block(Vector3(STREET_X + side * (26.0 + k * 20.0), 0, g + 7.0), PI, 18.0, rng.randf_range(20.0, 50.0), 22.0, false, 1)
		cyber_block(Vector3(STREET_X + side * (26.0 + k * 20.0), 0, g - 7.0), 0.0, 18.0, rng.randf_range(20.0, 50.0), 22.0, false, 1)
	# the vigils on the two corners, a beat apart
	_vigil_circle(Vector3(STREET_X + side * 12.5, 0, zz + 2.0 + 7.0), 2.6, 7, int(zz) + int(side))
	if rng.randf() < 0.6:
		_vigil_circle(Vector3(STREET_X + side * 12.5, 0, g - 15.0), 2.2, 5, int(g) + int(side) * 3)
	return zz - 12.0


## A candle circle of flattened figures on a corner.
func _vigil_circle(c: Vector3, r: float, n: int, seed_i: int) -> void:
	var coats := [Color(0.1, 0.1, 0.12), Color(0.18, 0.14, 0.12), Color(0.24, 0.24, 0.26), Color(0.1, 0.14, 0.18)]
	var skins := [Color(0.85, 0.66, 0.52), Color(0.6, 0.42, 0.3), Color(0.4, 0.28, 0.2)]
	for i in n:
		var a := i * TAU / n + seed_i * 0.37
		var p := c + Vector3(cos(a) * r, 0.02, sin(a) * r)
		var f := figure(coats[(i + seed_i) % coats.size()], skins[(i * 2 + seed_i) % skins.size()], {"long_hair": (i + seed_i) % 3 == 0})
		f.position = p
		add_child(f)
		turn_to(f, c)
		(f.get_meta("head") as Node3D).rotation.x = -0.25
		_flatten(f)
		var d := (c - p).normalized()
		_candle(p + d * 0.42 + Vector3(0, 1.12, 0), false)
	for i in 5:
		var a := i * TAU / 5.0
		_candle(c + Vector3(cos(a) * 0.6, 0.0, sin(a) * 0.6), true)
	candles.append([light(c + Vector3(0, 1.3, 0), Color(1.0, 0.55, 0.22), 1.8, 10.0, false), 1.8])


## A mourner at the front: a deep collider, so the ray from the driver's
## seat reaches them across the hood.
func _mourner(id: String, prompt: String, fig: Node3D, scan: String) -> void:
	interactable(id, prompt, Vector3(0, 0.9, -0.3), Vector3(0.8, 1.9, 1.6), scan, true, fig)
	crowd_figs.append([fig, fig.position])
	no_batch.append(fig)


## Merge a Body figure into one mesh per material at its pose, so a hundred
## singers cost a handful of draws. The figure must be in the tree.
func _flatten(fig: Node3D) -> void:
	var inv := fig.global_transform.affine_inverse()
	var groups := {}
	for mi in fig.find_children("*", "MeshInstance3D", true, false):
		var m := mi as MeshInstance3D
		if m.material_override == null or m.mesh == null:
			continue
		var key := m.material_override.get_instance_id()
		if not groups.has(key):
			var st := SurfaceTool.new()
			st.begin(Mesh.PRIMITIVE_TRIANGLES)
			groups[key] = [m.material_override, st]
		(groups[key][1] as SurfaceTool).append_from(m.mesh, 0, inv * m.global_transform)
	for key in groups:
		var out := MeshInstance3D.new()
		out.mesh = (groups[key][1] as SurfaceTool).commit()
		out.material_override = groups[key][0]
		out.transform = fig.transform
		add_child(out)
	remove_child(fig)
	fig.free()


# ------------------------------------------------------------------ Fargona Avenue: the digital vigil

## Forty citizens across the avenue, frames lit on battery, faces to the
## sky, tablets held like bibles; three mourners and the preacher at the
## front. Book ch.16.
func _fargona() -> void:
	var coats := [Color(0.1, 0.1, 0.12), Color(0.18, 0.14, 0.12), Color(0.24, 0.24, 0.26), Color(0.1, 0.14, 0.18), Color(0.3, 0.1, 0.12)]
	var skins := [Color(0.85, 0.66, 0.52), Color(0.6, 0.42, 0.3), Color(0.4, 0.28, 0.2), Color(0.92, 0.78, 0.66)]
	var tab := glow(Color(0.5, 0.8, 1.0), 1.6)
	var front := STOP_X - 3.8
	# rows back from the car, filling the road and both pavements
	for row in 6:
		for col in 7:
			if row == 0 and (col == 2 or col == 3 or col == 4):
				continue  # the mourners stand here
			if row == 3 and col == 1:
				continue  # the preacher's barrier
			var p := Vector3(front - row * 2.6 - rng.randf_range(0, 0.8), 0.02, FARGONA_Z + (col - 3) * 2.6 + rng.randf_range(-0.6, 0.6))
			var f := figure(coats[(row + col) % coats.size()], skins[(row * 3 + col) % skins.size()], {"visor": true, "long_hair": (row + col) % 3 == 1})
			f.position = p
			f.rotation.y = -PI / 2.0 + rng.randf_range(-0.4, 0.4)   # facing the car
			add_child(f)
			(f.get_meta("head") as Node3D).rotation.x = -0.75   # to the sky
			# a tablet held up in both hands
			var t := box(Vector3(0.2, 0.28, 0.015), Vector3(0, 1.3, -0.3), tab, false, f)
			t.rotation.x = -0.6
			if row < 2:
				crowd_figs.append([f, p])  # the front rows step aside
				no_batch.append(f)
			else:
				_flatten(f)
	for i in 3:
		_candle(Vector3(front - 1.0, 0.0, FARGONA_Z - 6.0 + i * 6.0), true)
	candles.append([light(Vector3(front - 4.0, 2.4, FARGONA_Z), Color(0.5, 0.75, 1.0), 1.6, 14.0, false), 1.6])
	# the three mourners and the preacher, whole, with their screens
	var m1 := figure(Color(0.2, 0.16, 0.14), skins[0], {"arms": true, "long_hair": true, "hair": Color(0.3, 0.2, 0.12)})
	m1.position = Vector3(front, 0.02, FARGONA_Z - 2.4)
	m1.rotation.y = -PI / 2.0
	add_child(m1)
	for a in m1.get_meta("arms"):
		(a as Node3D).rotation.x = -1.9
	var s1 := box(Vector3(0.26, 0.36, 0.015), Vector3(0, 1.75, -0.5), glow(Color(0.9, 0.85, 0.7), 1.4), false, m1)
	s1.rotation.x = -0.3
	_mourner("mourner_1", "Talk to the woman with the screen", m1, L("fargona", "mourner_1_scan"))
	var m2 := figure(Color(0.12, 0.12, 0.14), skins[1], {"arms": true})
	m2.position = Vector3(front, 0.02, FARGONA_Z)
	m2.rotation.y = -PI / 2.0
	add_child(m2)
	for a in m2.get_meta("arms"):
		(a as Node3D).rotation.x = -1.2
	box(Vector3(0.3, 0.4, 0.015), Vector3(0, 1.3, -0.5), glow(Color(0.7, 0.9, 1.0), 1.4), false, m2).rotation.x = -0.5
	_mourner("mourner_2", "Talk to the man with the tablet", m2, L("fargona", "mourner_2_scan"))
	var m3 := figure(Color(0.26, 0.24, 0.22), skins[2], {"arms": true, "hair": Color(0.7, 0.7, 0.7)})
	m3.position = Vector3(front, 0.02, FARGONA_Z + 2.4)
	m3.rotation.y = -PI / 2.0
	add_child(m3)
	for a in m3.get_meta("arms"):
		(a as Node3D).rotation.x = -1.9
	box(Vector3(0.26, 0.36, 0.015), Vector3(0, 1.75, -0.5), mat(Color(0.02, 0.02, 0.025), 0.1, 0.3), false, m3).rotation.x = -0.3
	_mourner("mourner_3", "Talk to the old man", m3, L("fargona", "mourner_3_scan"))
	var e3 := _screen_eye(Vector3(0, 1.75, -0.51), 0.0, 0.0012)
	e3.rotation.x = -0.3
	e3.reparent(m3, false)
	e3.position = Vector3(0, 1.75, -0.51)
	e3.rotation = Vector3(-0.3, 0, 0)
	eyes.append(e3)
	for mm: Node3D in [m1, m2, m3]:
		(mm.get_meta("head") as Node3D).rotation.x = -0.2
	# the preacher on a barrier at the centre of the crowd
	prop("concrete_road_barrier", Vector3(front - 7.5, 0, FARGONA_Z - 5.4), PI / 2.0, 1.0, true)
	var pr := figure(Color(0.75, 0.72, 0.66), skins[3], {"arms": true})
	pr.position = Vector3(front - 7.5, 0.84, FARGONA_Z - 5.4)
	pr.rotation.y = -PI / 2.0
	add_child(pr)
	var arms: Array = pr.get_meta("arms")
	(arms[1] as Node3D).rotation.x = -2.6
	(arms[1] as Node3D).rotation.z = -0.4
	var pt := box(Vector3(0.22, 0.3, 0.015), Vector3(0.3, 2.25, -0.1), glow(Color(0.6, 1.0, 0.85), 2.0), false, pr)
	pt.rotation.x = -0.4
	var pg := _screen_eye(Vector3(0.3, 2.25, -0.12), 0.0, 0.0012)
	pg.modulate = Color(0.4, 1.0, 0.9)
	pg.visible = true
	pg.reparent(pr, false)
	pg.position = Vector3(0.3, 2.25, -0.12)
	pg.rotation = Vector3(-0.4, 0, 0)
	person("preacher", "Listen to the preacher", pr, L("fargona", "preacher_scan"))
	# the fractal above the crowd: the eye layer, flat over their heads
	fractal = Sprite3D.new()
	fractal.texture = _glyph_tex
	fractal.pixel_size = 0.26
	fractal.position = Vector3(front - 8.0, 24.0, FARGONA_Z)
	fractal.rotation.x = PI / 2.0
	fractal.modulate = Color(0.4, 1.0, 0.9)
	fractal.shaded = false
	fractal.double_sided = true
	fractal.visible = false
	add_child(fractal)
	eyes.append(fractal)


# ------------------------------------------------------------------ the mount and the climb road

func _climb() -> void:
	var asphalt := pbr("asphalt", Vector3(1, 1, 1) / 4.0, true, Color(0.6, 0.6, 0.62), 0.5)
	var rock := pbr("concrete", Vector3(1, 1, 1) / 12.0, true, Color(0.22, 0.2, 0.19))
	# the ramp from x -300 up to x -380, 14 m
	var ln := 82.0
	var ramp := box(Vector3(ln, 0.3, 16), Vector3(CLIMB_X - 40.0, 7.0 - 0.15, FARGONA_Z), asphalt)
	ramp.rotation.z = -atan2(14.0, 80.0)
	var rb := box(Vector3(ln + 40, 12, 60), Vector3(CLIMB_X - 60.0, -0.1, FARGONA_Z), rock)
	rb.rotation.z = -atan2(14.0, 80.0)
	# the mount itself: a black void that hides the stars
	var mnt := sphere(220.0, Vector3(CLIMB_X - 300.0, -40.0, FARGONA_Z), rock, 14)
	mnt.scale = Vector3(1.0, 0.42, 1.2)
	sphere(90.0, Vector3(CLIMB_X - 180.0, -10.0, FARGONA_Z + 120.0), rock, 10).scale = Vector3(1.0, 0.5, 1.0)
	sphere(90.0, Vector3(CLIMB_X - 180.0, -10.0, FARGONA_Z - 120.0), rock, 10).scale = Vector3(1.0, 0.5, 1.0)
	# the last of the city: low blocks petering out, dead lamps up the mount
	for i in 4:
		for side: float in [-1.0, 1.0]:
			cyber_block(Vector3(CLIMB_X + 10.0 - i * 22.0, 0, FARGONA_Z + side * 16.0), PI if side > 0.0 else 0.0, 18.0, rng.randf_range(8.0, 16.0), 16.0, false, 1)
	for i in 5:
		var t := i / 4.0
		prop("street_lamp_01", Vector3(CLIMB_X - t * 80.0, t * 14.0, FARGONA_Z + 9.0), 0.0, 1.4, false)


func _bounds() -> void:
	solid_box(Vector3(2, 20, 80), Vector3(-47.0, 10, -10))
	solid_box(Vector3(2, 20, 80), Vector3(46.0, 10, -10))
	solid_box(Vector3(120, 20, 2), Vector3(0, 10, -46))
	solid_box(Vector3(120, 20, 2), Vector3(0, 10, 32))


# ------------------------------------------------------------------ people who move

func _people() -> void:
	# Annie, in her coat from the office, a candle in both hands
	annie = figure(Color(0.16, 0.12, 0.1), Color(0.9, 0.76, 0.62), {"arms": true, "knees": true, "long_hair": true, "hair": Color(0.08, 0.06, 0.05)})
	var a0 := 0.35
	annie.position = VIGIL_C + Vector3(cos(a0) * 3.6, 0.02, sin(a0) * 3.6)
	add_child(annie)
	turn_to(annie, VIGIL_C)
	for a in annie.get_meta("arms"):
		(a as Node3D).rotation.x = -1.3
		(a as Node3D).rotation.y = (0.5 if (a as Node3D).position.x > 0.0 else -0.5)
	var wax := mat(Color(0.9, 0.86, 0.72), 0.7)
	cyl(0.028, 0.03, 0.16, Vector3(0, 1.1, -0.34), wax, 6, annie)
	box(Vector3(0.03, 0.06, 0.03), Vector3(0, 1.21, -0.34), glow(Color(1.0, 0.6, 0.18), 4.5), false, annie)
	person("annie", "Talk to Annie Seung", annie, L("vigil", "annie_scan"))
	# the singer from Facilities, eyes shut, wax over his fingers
	var a4 := 4 * TAU / 11.0 + 0.35
	var sg := figure(Color(0.24, 0.24, 0.26), Color(0.6, 0.42, 0.3), {"arms": true, "knees": true})
	sg.position = VIGIL_C + Vector3(cos(a4) * 3.6, 0.02, sin(a4) * 3.6)
	add_child(sg)
	turn_to(sg, VIGIL_C)
	for a in sg.get_meta("arms"):
		(a as Node3D).rotation.x = -1.3
		(a as Node3D).rotation.y = (0.5 if (a as Node3D).position.x > 0.0 else -0.5)
	cyl(0.028, 0.03, 0.16, Vector3(0, 1.1, -0.34), wax, 6, sg)
	box(Vector3(0.03, 0.06, 0.03), Vector3(0, 1.21, -0.34), glow(Color(1.0, 0.6, 0.18), 4.5), false, sg)
	(sg.get_meta("head") as Node3D).rotation.x = -0.4
	person("singer", "Talk to the singer", sg, L("vigil", "singer_scan"))
	singers.append(sg)
	if hurt_fig:
		var hb := person("hurt", "Look at her", hurt_fig, L("drone", "hurt_scan"))
		set_active(hb, false)
	# the guard by the lobby doors with his flashlight
	guard = figure(Color(0.05, 0.07, 0.12), Color(0.7, 0.52, 0.38), {"arms": true, "knees": true})
	guard.position = Vector3(4.0, 0.02, 12.5)
	guard.rotation.y = 0.6
	add_child(guard)
	(guard.get_meta("arms")[1] as Node3D).rotation.x = -0.9
	box(Vector3(0.05, 0.05, 0.22), Vector3(0.24, 1.05, -0.2), mat(Color(0.1, 0.1, 0.1), 0.4, 0.6), false, guard)
	guard_torch = SpotLight3D.new()
	guard_torch.position = Vector3(0.24, 1.05, -0.3)
	guard_torch.light_color = Color(1.0, 0.95, 0.85)
	guard_torch.light_energy = 2.6
	guard_torch.spot_range = 14.0
	guard_torch.spot_angle = 18.0
	guard_torch.spot_attenuation = 1.0
	guard.add_child(guard_torch)
	person("guard", "Talk to the guard", guard, L("lobby", "guard_scan")).set_meta("guard", true)
	# Lynx, if she is with him tonight: on the landing above the spawn
	if _lynx_here:
		lynx = figure(Color(0.09, 0.08, 0.1), Color(0.88, 0.74, 0.62), {"arms": true, "knees": true, "long_hair": true, "hair": Color(0.06, 0.05, 0.05)})
		lynx.position = Vector3(SHAFT_X - 1.6, 10.52, 15.0)
		lynx.rotation.y = PI
		add_child(lynx)
		person("lynx", "Lynx", lynx, "LYNX MORRINO\nORA gen 6\nNO SIGNAL")


func _find_body(fig: Node3D) -> CollisionObject3D:
	for c in fig.get_children():
		if c is CollisionObject3D and c.has_meta("id"):
			return c
	return null


# ------------------------------------------------------------------ the car

## The company car: a parked shell in the lot, and the cockpit Carl drives
## from (Drive.gd's), with headlamps that are the only light on the street.
func _car() -> void:
	car_shell = Car.build(self, Color(0.75, 0.78, 0.8), {"plate": "PSY 0091", "head": glow(Color(1, 0.97, 0.9), 0.6), "tail": glow(Color(1, 0.05, 0.05), 0.5)})
	car_shell.position = CAR_P
	car_shell.rotation.y = PI
	add_child(car_shell)
	solid_box(Vector3(2.0, 1.6, 4.6), CAR_P + Vector3(0, 0.8, 0)).name = "car_solid"
	interactable("my_car", "Take the company car", CAR_P + Vector3(0, 1.0, 0), Vector3(2.2, 1.8, 4.8),
		"PSYONIC FLEET 0091\nNO SIGNAL\ncell: 100%", false)
	car = Node3D.new()
	car.position = CAR_P
	car.rotation.y = PI
	car.visible = false
	add_child(car)
	var trim := mat(Color(0.12, 0.12, 0.13), 0.6)
	var paint := mat(Color(0.75, 0.78, 0.8), 0.25, 0.6)
	box(Vector3(1.9, 0.25, 1.8), Vector3(0, 0.75, -1.9), paint, false, car)
	box(Vector3(1.7, 0.22, 0.55), Vector3(0, 0.88, -0.75), trim, false, car)
	box(Vector3(1.7, 0.06, 0.3), Vector3(0, 1.0, -0.62), mat(Color(0.18, 0.18, 0.2), 0.5), false, car)
	var wheel := TorusMesh.new()
	wheel.inner_radius = 0.15
	wheel.outer_radius = 0.18
	wheel.rings = 20
	wheel.ring_segments = 6
	var wm := mesh(wheel, Vector3(SEAT.x, 0.98, -0.42), trim, car)
	wm.rotation.x = PI / 2.0 - 0.45
	box(Vector3(0.04, 0.04, 0.3), Vector3(SEAT.x, 0.93, -0.55), trim, false, car)
	for x: float in [-0.82, 0.82]:
		stick(Vector3(x, 0.98, -0.95), Vector3(x, 1.8, -0.2), 0.035, trim, car)
		stick(Vector3(x, 0.98, 0.85), Vector3(x, 1.8, 0.65), 0.04, trim, car)
		box(Vector3(0.06, 0.06, 0.9), Vector3(x, 1.8, 0.22), trim, false, car)
		box(Vector3(0.08, 0.5, 2.0), Vector3(x * 1.02, 0.7, 0.0), mat(Color(0.2, 0.2, 0.22), 0.7), false, car)
	box(Vector3(1.7, 0.05, 0.9), Vector3(0, 1.82, 0.22), mat(Color(0.25, 0.25, 0.26), 0.9), false, car)
	box(Vector3(1.7, 0.6, 0.1), Vector3(0, 1.0, 1.0), trim, false, car)
	# the seats
	for sx: float in [SEAT.x, -SEAT.x]:
		box(Vector3(0.6, 0.12, 0.6), Vector3(sx, 0.5, 0.35), mat(Color(0.1, 0.1, 0.11), 0.9), false, car)
		box(Vector3(0.6, 0.8, 0.12), Vector3(sx, 0.9, 0.65), mat(Color(0.1, 0.1, 0.11), 0.9), false, car)
	# the fleet screen, no signal; the mic that is never off is off tonight
	dash_m = newglow(Color(0.12, 0.2, 0.2), 0.7)
	var scr := quad(Vector2(0.3, 0.17), Vector3(0.12, 1.06, -0.6), 0.0, dash_m, car)
	scr.rotation.x = -0.5
	dash_label = label(L("drive", "dash"), Vector3(0.12, 1.06, -0.592), 0.0, 0.00045, Color(0.05, 0.08, 0.08), car, false)
	dash_label.rotation.x = -0.5
	dash_label.font_size = 48
	box(Vector3(0.02, 0.02, 0.01), Vector3(-0.05, 1.04, -0.6), mat(Color(0.2, 0.05, 0.05), 0.5), false, car).rotation.x = -0.5
	interactable("drive_on", "The fleet screen", Vector3(0.12, 1.06, -0.6), Vector3(0.4, 0.3, 0.2), "", false, car)
	# headlamps and tail lamps
	for x: float in [-0.7, 0.7]:
		box(Vector3(0.3, 0.12, 0.05), Vector3(x, 0.75, -2.82), glow(Color(1, 0.97, 0.9), 2.5), false, car)
		var sp := SpotLight3D.new()
		sp.position = Vector3(x, 0.78, -2.8)
		sp.rotation.x = deg_to_rad(-6.0)
		sp.light_color = Color(1.0, 0.95, 0.85)
		sp.light_energy = 3.2
		sp.spot_range = 46.0
		sp.spot_angle = 28.0
		sp.spot_attenuation = 0.9
		car.add_child(sp)
		box(Vector3(0.3, 0.1, 0.05), Vector3(x, 0.8, 2.31), glow(Color(1, 0.1, 0.1), 1.5), false, car)
	var o := light(Vector3(0, 0.6, 2.4), Color(1.0, 0.1, 0.1), 0.5, 4.0, false)
	o.reparent(car, false)
	o.position = Vector3(0, 0.6, 2.4)
	# the police drone, parked out of sight until the sirens
	police = prop("police_drone", Vector3(STOP_X + 80.0, 22.0, FARGONA_Z), 0.0, 1.6, false)
	if police:
		police.visible = false
		police_light = light(Vector3.ZERO, Color(1.0, 0.1, 0.1), 1.6, 12.0, false)
		police_light.reparent(police, false)
		police_light.position = Vector3(0, -0.2, 0)
		box(Vector3(0.1, 0.1, 0.1), Vector3(0, -0.3, 0), glow(Color(1, 0.05, 0.05), 6.0), false, police)
		box(Vector3(0.1, 0.1, 0.1), Vector3(0.3, -0.1, 0.3), glow(Color(0.2, 0.3, 1.0), 6.0), false, police)
	# the route: down the street, the corner, Fargona, the climb
	_path = [CAR_P, Vector3(STREET_X, 0, -388.0), Vector3(STREET_X - 8.0, 0, FARGONA_Z - 2.0), Vector3(STOP_X, 0, FARGONA_Z),
		Vector3(CLIMB_X, 0, FARGONA_Z), Vector3(END_X, 14.0 * (CLIMB_X - END_X) / 80.0, FARGONA_Z)]
	# the scripted drone, high over the garden
	drone = prop("delivery_drone", VIGIL_C + Vector3(0, 48.0, 0), 0.0, 2.2, false)
	if drone:
		drone.visible = false
		box(Vector3(0.08, 0.08, 0.08), Vector3(0, -0.15, 0), glow(Color(1, 0.05, 0.05), 6.0), false, drone)
	splash = CPUParticles3D.new()
	splash.emitting = false
	splash.one_shot = true
	splash.amount = 160
	splash.lifetime = 1.3
	splash.explosiveness = 0.95
	splash.direction = Vector3(0, 1, 0)
	splash.spread = 60.0
	splash.initial_velocity_min = 3.0
	splash.initial_velocity_max = 7.5
	splash.gravity = Vector3(0, -9.0, 0)
	var sm := SphereMesh.new()
	sm.radius = 0.06
	sm.height = 0.12
	sm.radial_segments = 5
	sm.rings = 3
	splash.mesh = sm
	var spm := StandardMaterial3D.new()
	spm.albedo_color = Color(0.5, 0.6, 0.7)
	spm.roughness = 0.2
	splash.material_override = spm
	splash.position = FOUNTAIN + Vector3(0, 0.7, 0)
	add_child(splash)


# ------------------------------------------------------------------ the swarm and the eye layer

## Delivery drones over the dark city: black shapes on black, one red light
## each, and some of them falling.
func _swarm() -> void:
	var n := 140
	var bm := BoxMesh.new()
	bm.size = Vector3(0.8, 0.3, 0.8)
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.mesh = bm
	mm.instance_count = n
	swarm = MultiMeshInstance3D.new()
	swarm.multimesh = mm
	var black := StandardMaterial3D.new()
	black.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	black.albedo_color = Color(0.0, 0.0, 0.0)
	swarm.material_override = black
	swarm.extra_cull_margin = 2000.0
	add_child(swarm)
	var rm := BoxMesh.new()
	rm.size = Vector3(0.12, 0.12, 0.12)
	var mm2 := MultiMesh.new()
	mm2.transform_format = MultiMesh.TRANSFORM_3D
	mm2.mesh = rm
	mm2.instance_count = n
	swarm_red = MultiMeshInstance3D.new()
	swarm_red.multimesh = mm2
	var red := newglow(Color(1.0, 0.05, 0.05), 6.0)
	red.disable_fog = true
	swarm_red.material_override = red
	swarm_red.extra_cull_margin = 2000.0
	add_child(swarm_red)
	for i in n:
		var p := Vector3(rng.randf_range(-320.0, 80.0), rng.randf_range(22.0, 70.0), rng.randf_range(-470.0, 40.0))
		swarm_data.append({"p": p, "v": Vector3(rng.randf_range(-2.0, 2.0), 0.0, rng.randf_range(-2.0, 2.0)),
			"fall": rng.randf() < 0.18, "w": rng.randf() * TAU, "fv": rng.randf_range(2.0, 5.0)})


func _eye_layer() -> void:
	# the flaming eye over the first vigil of the drive
	flame_eye = Sprite3D.new()
	flame_eye.texture = Tex.eye()
	flame_eye.pixel_size = 0.05
	flame_eye.position = Vector3(STREET_X - 11.0, 15.0, -121.0)
	flame_eye.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	flame_eye.modulate = Color(1.0, 0.35, 0.1)
	flame_eye.shaded = false
	flame_eye.visible = false
	add_child(flame_eye)
	eyes.append(flame_eye)


# ------------------------------------------------------------------ hooks

func intro() -> void:
	var ui = main.ui
	await get_tree().create_timer(0.8).timeout
	await ui.think(L("stair", "think_1"))
	await ui.think(L("stair", "think_2"))
	ui.close()
	if _lynx_here and lynx_state == "stair":
		await get_tree().create_timer(0.6).timeout
		main.play("slam", -14.0, 1.3)
		await main.player.face(lynx.global_position + Vector3(0, 1.5, 0), 1.0)
		await ui.say("Lynx", L("stair", "lynx_call"))
		await _lynx_stair_talk()
		ui.close()


func _lynx_stair_talk() -> void:
	var ui = main.ui
	await ui.say("Lynx", L("stair", "lynx_1"))
	await ui.say("Carl", L("stair", "carl_1"))
	await ui.say("Carl", L("stair", "carl_2"))
	await ui.say("Lynx", L("stair", "lynx_2"))
	await ui.say("Carl", L("stair", "carl_3"))
	await ui.think(L("stair", "lynx_gone"))
	lynx_state = "gone"
	main.flags["blackout_lynx_met"] = true
	# she is waiting outside the doors
	lynx.position = Vector3(2.4, 0.02, DOOR_Z - 2.0)
	lynx.rotation.y = 0.0


func objective() -> String:
	var f: Dictionary = main.flags
	var pp: Vector3 = main.player.global_position
	if _done or f.has("blackout_done"):
		return L("objective", "climb")
	if _stopped and not _fargona_done:
		return L("fargona", "objective")
	if _driving:
		return L("objective", "drive")
	if f.has("vigil_done"):
		return L("objective", "car")
	if f.has("doors_open"):
		return L("objective", "vigil") if pp.z < 0.0 else L("objective", "garden")
	if pp.y < 0.5 and pp.z < 23.5 and pp.x < 13.5:
		return L("objective", "lobby")
	return L("objective", "stair")


func phone() -> String:
	var t := L("phone", "nosig")
	if main.connection >= 25.0 or main.flags.has("drone_hijacked") or main.flags.has("drone_fell"):
		t += L("phone", "fork")
	if main.flags.has("drone_hijacked"):
		t += L("phone", "sleeper")
	return t


func scan_people() -> Array:
	var out := []
	if lynx and lynx_state != "car":
		out.append([lynx, "LYNX MORRINO\nORA gen 6\nNO SIGNAL"])
	return out


# ------------------------------------------------------------------ interactions

func interact(node: Object) -> bool:
	var ui = main.ui
	var f: Dictionary = main.flags
	var frames_on: bool = main.frames_on
	match str(node.get_meta("id")):
		"lynx":
			if lynx_state == "stair":
				await _lynx_stair_talk()
			else:
				await ui.say("Lynx", L("stair", "lynx_again"))
		"stair_candle":
			await ui.think(L("stair", "candle"))
		"fuse":
			await ui.think(L("stair", "fuse"))
		"exit_sign":
			await ui.think(L("stair", "exit_sign") if frames_on else L("stair", "exit_sign_off"))
		"guard":
			await _guard()
		"turnstile":
			await ui.think(L("lobby", "turnstile"))
		"screen":
			await ui.think(L("lobby", "screen") if frames_on else L("lobby", "screen_off"))
		"kiosk":
			await ui.think(L("lobby", "kiosk"))
		"desk":
			await ui.think(L("lobby", "desk"))
		"lobby_cam", "alley_cam":
			await ui.think(L("lobby", "camera") if str(node.get_meta("id")) == "lobby_cam" else L("alley", "camera"))
		"doors":
			await _open_doors()
		"annie":
			await _annie()
		"singer":
			await ui.think(L("vigil", "singer"))
			await ui.say("Singer", L("vigil", "singer_say"))
		"hurt":
			await ui.think(L("drone", "fell_2"))
		"fountain":
			await ui.think(L("vigil", "fountain_after") if f.has("drone_hijacked") else L("vigil", "fountain"))
		"wreck":
			await ui.think(L("vigil", "wreck"))
		"charger":
			await ui.think(L("lot", "charger"))
		"utility":
			await ui.think(L("lot", "utility"))
		"shutter":
			await ui.think(L("lot", "shutter"))
		"vagrant_n":
			await ui.think(L("lot", "vagrant_n"))
			await ui.say("Woman", L("lot", "vagrant_n_say"))
		"vagrant_w":
			await ui.think(L("alley", "vagrant_w"))
			await ui.say("Man", L("alley", "vagrant_w_say"))
		"eyeless_w":
			await ui.think(L("alley", "eyeless"))
			if frames_on:
				await ui.think(L("alley", "eyeless_frames"))
		"barrel":
			await ui.think(L("alley", "barrel"))
		"my_car":
			await _take_car()
		"mourner_1":
			await ui.think(L("fargona", "mourner_1"))
			await ui.say("Woman", L("fargona", "mourner_1_say"))
		"mourner_2":
			await ui.think(L("fargona", "mourner_2"))
			await ui.say("Man", L("fargona", "mourner_2_say"))
		"mourner_3":
			await ui.think(L("fargona", "mourner_3"))
			await ui.say("Old man", L("fargona", "mourner_3_say"))
			if frames_on:
				await ui.think(L("fargona", "mourner_3_frames"))
		"preacher":
			await ui.think(L("fargona", "preacher"))
			await ui.say("Preacher", L("fargona", "preacher_say"))
			await ui.say("Preacher", L("fargona", "preacher_say_2"))
		"drive_on":
			if _stopped and not _fargona_done:
				await _fargona_choice()
			else:
				await ui.think(L("drive", "screen"))
		_:
			if str(node.get_meta("id")).begins_with("parked_"):
				await ui.think(L("lot", "parked"))
			else:
				return false
	ui.close()
	return true


func _guard() -> void:
	var ui = main.ui
	if main.flags.has("guard_passed"):
		await ui.say("Guard", L("lobby", "guard_after"))
		return
	await ui.say("Guard", L("lobby", "guard"))
	var pick: int = await ui.choose(LINES["lobby"]["guard_choices"])
	if pick == 0:
		await ui.say("Guard", L("lobby", "guard_badge"))
		main.add_pressure(1.0, "badge logged at the lobby")
	else:
		await ui.say("Guard", L("lobby", "guard_kids"))
	main.flags["guard_passed"] = true


func _open_doors() -> void:
	var ui = main.ui
	if main.flags.has("doors_open"):
		await ui.think(L("lobby", "doors"))
		return
	main.flags["doors_open"] = true
	main.play("door", -4.0, 0.7)
	for i in doors.size():
		var pv: Node3D = doors[i]
		create_tween().tween_property(pv, "rotation:y", (-1.0 if i == 0 else 1.0) * 1.5, 1.4).set_trans(Tween.TRANS_SINE)
	door_body.queue_free()
	set_active(door_area, false)
	if _hymns.size() > 0:
		create_tween().tween_property(_hymns[0], "volume_db", 2.0, 2.5)
	await ui.think(L("lobby", "doors_open") if _lynx_here else L("lobby", "doors_open_alone"))
	await ui.say("", "[b]" + L("lobby", "mira_song") + "[/b]")
	if _lynx_here:
		await ui.say("Lynx", L("lobby", "lynx_is_that"))
		await ui.say("Carl", L("lobby", "carl_hymn"))
		lynx_state = "follow"
	await ui.think(L("lobby", "think_garden"))
	main.update_hud()


## Annie Seung's vigil (bible A2-S3; book ch.16): her lines verbatim, then
## the choice: join one verse (the blend tutorial, +2 C) or "Let's move."
func _annie() -> void:
	var ui = main.ui
	if main.flags.has("vigil_done"):
		await ui.think(L("vigil", "again"))
		await ui.say("Annie Seung", L("vigil", "annie_again"))
		return
	await ui.think(L("vigil", "approach") if _lynx_here else L("vigil", "approach_alone"))
	await ui.say("", "[i]" + "\n".join(HYMN.slice(0, 4)) + "[/i]")
	await ui.say("", "[i]" + "\n".join(HYMN.slice(4)) + "[/i]")
	if _hymns.size() > 0:
		create_tween().tween_property(_hymns[0], "volume_db", -22.0, 0.3)
	await ui.think(L("vigil", "break"))
	await ui.think(L("vigil", "annie_face"))
	await ui.say("Carl", L("vigil", "carl_annie"))
	await ui.say("Annie Seung", L("vigil", "annie_1"))
	await ui.think(L("vigil", "annie_wax"))
	await ui.say("Carl", L("vigil", "carl_message"))
	await ui.say("Annie Seung", L("vigil", "annie_2"))
	await ui.say("Annie Seung", L("vigil", "annie_3"))
	await ui.say("Annie Seung", L("vigil", "annie_4"))
	await ui.think(L("vigil", "hunger"))
	var pick: int = await ui.choose(LINES["vigil"]["choices"])
	if _hymns.size() > 0:
		create_tween().tween_property(_hymns[0], "volume_db", 3.0, 1.5)
	if pick == 1:
		await ui.think(L("vigil", "join_intro"))
		await ui.say("", L("vigil", "join_prompt"))
		var hits: int = await _hymn_prompt(4)
		ui.close()
		main.flags["vigil_sang"] = true
		if hits >= 3:
			await ui.think(L("vigil", "join_good"))
			main.add_connection(2.0, "sang a verse with the vigil")
		else:
			await ui.think(L("vigil", "join_bad"))
			main.add_connection(1.0, "sang a verse with the vigil")
		await ui.say("Annie Seung", L("vigil", "annie_fun"))
		main.log_line("vigil", "sang one verse at Annie Seung's vigil")
	else:
		await ui.say("Carl", L("vigil", "move_lynx") if _lynx_here else L("vigil", "move"))
		main.log_line("vigil", "walked past Annie Seung's vigil")
	await ui.think(L("vigil", "move_think"))
	main.flags["vigil_done"] = true
	main.log_line("faith", "citywide Faith 2 for the night of the blackout")
	main.update_hud()


## The blend tutorial: the hymn comes round line by line; come in on the
## line quickly, or hold. Returns how many lines were hit.
func _hymn_prompt(bars: int) -> int:
	var ui = main.ui
	var hits := 0
	for i in bars:
		var line: String = HYMN[i % HYMN.size()]
		var t0 := Time.get_ticks_msec()
		var pick: int = await ui.choose(["(hold)", "Sing:   " + line])
		var dt := (Time.get_ticks_msec() - t0) / 1000.0
		if pick == 1 and dt < 3.0:
			hits += 1
			main.play("tap", -12.0, 1.2)
		else:
			main.play("tap", -16.0, 0.7)
	return hits


## The scripted drone (bible A2-S3; combat.md, the drone arc, step 1,
## Hijack): as Carl crosses the plaza a delivery drone drops toward the
## vigil. The frames wake on their own and the wheel offers "sleeper".
func _drone_beat() -> void:
	var ui = main.ui
	main.flags["drone_beat"] = true
	main.flags["cinematic"] = true
	drone_phase = "fall"
	drone_t = 0.0
	drone.visible = true
	drone_from = drone.position
	drone_whine = main.loop("engine", -8.0, Vector3.ZERO, 3.0, 90.0, drone) as AudioStreamPlayer3D
	drone_whine.pitch_scale = 2.4
	drone_whine.play()
	ui.show_toast(L("drone", "whine"), 4.0)
	await main.player.face(drone.global_position, 1.2)
	await get_tree().create_timer(1.4).timeout
	drone_phase = "stall"
	if not main.frames_on:
		main.toggle_frames()
		await ui.think(L("drone", "frames_wake"))
	main.play("glitch", -6.0)
	ui.glitch(0.6, 0.6)
	var opts: Array = [L("drone", "opt_fall"), L("drone", "opt_sleeper")]
	if "hush" in main.lexicon:
		opts.append(L("drone", "opt_hush"))
	await ui.say("", L("drone", "wheel"))
	var pick: int = await ui.choose(opts)
	if pick == 2:
		await ui.think(L("drone", "hush"))
		main.add_connection(1.0, "the wrong word")
		pick = 0
	ui.close()
	if pick == 1:
		drone_phase = "hijack"
		drone_t = 0.0
		drone_from = drone.position
		main.learn("sleeper")
		main.play("whisper", -4.0, 0.8)
		await ui.think(L("drone", "hijack_1"))
		await ui.think(L("drone", "hijack_2"))
		await ui.think(L("drone", "hijack_3"))
		ui.close()
		while drone_phase != "down":
			await get_tree().process_frame
		main.flags["drone_hijacked"] = true
		main.add_connection(1.0, "sleeper")
		main.log_line("hack", "hijacked a falling delivery drone into the Spine fountain")
		ui.show_toast(L("drone", "toast_hijack"), 4.0)
		await get_tree().create_timer(1.2).timeout
		_everyone_turns()
		await ui.say("Annie Seung", L("drone", "hijack_annie"))
		await ui.think(L("drone", "hijack_look"))
		if _lynx_here:
			await ui.say("Lynx", L("drone", "hijack_lynx"))
	else:
		drone_phase = "fall"
		drone_t = 0.0
		drone_from = drone.position
		while drone_phase != "down":
			await get_tree().process_frame
		main.flags["drone_fell"] = true
		main.log_line("faith", "Spine +1: the vigil has a martyr")
		main.log_line("incident", "a delivery drone fell on Annie Seung's vigil; someone was hurt")
		ui.show_toast(L("drone", "toast_fell"), 4.0)
		await ui.think(L("drone", "fell_1"))
		await ui.think(L("drone", "fell_2"))
		await ui.say("Annie Seung", L("drone", "fell_annie"))
		if _lynx_here:
			await ui.say("Lynx", L("drone", "fell_lynx"))
		else:
			await ui.think(L("drone", "fell_think"))
	ui.close()
	main.flags.erase("cinematic")
	main.update_hud()


func _everyone_turns() -> void:
	turn_to(annie, main.player.global_position, 0.8)
	for s in singers:
		turn_to(s, main.player.global_position, 0.8)


## The company car. Gated on the vigil and the drone, then the drive.
func _take_car() -> void:
	var ui = main.ui
	var f: Dictionary = main.flags
	if _driving or _done:
		await ui.think(L("lot", "car"))
		return
	if not f.has("vigil_done"):
		await ui.think(L("lot", "car_gate_vigil"))
		return
	if not f.has("drone_beat"):
		await ui.think(L("lot", "car_gate_drone"))
		ui.close()
		await _drone_beat()
		return
	await ui.think(L("lot", "car"))
	if _lynx_here:
		await ui.think(L("lot", "car_lynx"))
	ui.close()
	await _drive()


# ------------------------------------------------------------------ the drive

func _cap(text: String, secs: float) -> void:
	await main.ui.caption(text, secs)


func _until_z(z: float) -> void:
	while car.position.z > z and not _done:
		await get_tree().process_frame


func _until_x(x: float) -> void:
	while car.position.x > x and not _done:
		await get_tree().process_frame


func _seat_player() -> void:
	var p = main.player
	p.seated = true
	p.crouch = 0.5
	p.position = car.position + car.transform.basis * SEAT
	p.yaw = _car_yaw
	p.rotation.y = p.yaw
	p.pitch = 0.0


func _drive() -> void:
	var ui = main.ui
	_driving = true
	main.flags["cinematic"] = true
	await ui.fade_to(1.0, 0.6)
	car_shell.visible = false
	var cs := get_node_or_null("car_solid")
	if cs:
		cs.queue_free()
	car.visible = true
	_seat_player()
	torch.visible = false
	if _lynx_here:
		lynx_state = "car"
		lynx.visible = false
		lynx_seat = figure(Color(0.09, 0.08, 0.1), Color(0.88, 0.74, 0.62), {"arms": true, "knees": true, "long_hair": true, "hair": Color(0.06, 0.05, 0.05)})
		lynx_seat.position = Vector3(-SEAT.x, 0.06, 0.35)
		car.add_child(lynx_seat)
		Anim.sit(lynx_seat, 0.15)
	_engine.volume_db = -18.0
	main.play("keys", -14.0)
	await get_tree().create_timer(0.5).timeout
	await ui.fade_to(0.0, 0.8)
	main.flags.erase("cinematic")
	main.update_hud()
	await _cap(L("drive", "start") if _lynx_here else L("drive", "start_alone"), 4.5)
	want_speed = 14.0
	await _until_z(-70.0)
	await _cap(L("drive", "cap_1"), 5.0)
	await _until_z(-112.0)
	await _cap(L("drive", "cap_2"), 5.5)
	if main.frames_on:
		await _cap(L("drive", "cap_eye"), 5.5)
		main.play("whisper", -2.0)
		ui.show_toast("[" + L("drive", "whisper") + "]", 3.0)
		main.add_connection(1.0, "the eye over the vigil")
	await _until_z(-200.0)
	await _cap(L("drive", "cap_3"), 5.0)
	if _lynx_here:
		await ui.say("Lynx", L("drive", "lynx_fast"))
		ui.close()
		ui.show_toast(L("drive", "lynx_window"), 4.0)
	await _until_z(-300.0)
	await _cap(L("drive", "cap_mount"), 6.0)
	await _until_x(-20.0)
	await _cap(L("fargona", "corner") if _lynx_here else L("fargona", "corner_alone"), 5.0)
	if main.frames_on:
		await _cap(L("fargona", "fractal"), 6.0)
	await _until_x(STOP_X + 40.0)
	want_speed = 0.0
	if _lynx_here:
		await ui.say("Lynx", L("fargona", "brake_lynx"))
		ui.close()
	else:
		await _cap(L("fargona", "brake_alone"), 3.5)
	await _until_x(STOP_X + 0.5)
	main.play("snap", -8.0, 0.6)
	speed = 0.0
	_stopped = true
	dash_label.text = L("drive", "dash_wait")
	await _cap(L("fargona", "screech"), 4.5)
	main.update_hud()


## The road blocked (bible A2-S3): wait it out (an hour), sing (blend, +2 C),
## or Lynx, if she is here. Then the crowd opens and the police drone comes.
func _fargona_choice() -> void:
	var ui = main.ui
	var opts: Array = (LINES["fargona"]["choices"] as Array).slice(0, 3 if _lynx_here else 2)
	var pick: int = await ui.choose(opts)
	_fargona_done = true
	if pick == 1:
		await ui.say("", L("fargona", "sing_prompt"))
		var hits: int = await _hymn_prompt(8)
		ui.close()
		if hits >= 6:
			await ui.think(L("fargona", "sing_good"))
			main.add_connection(2.0, "blended on Fargona Avenue")
		else:
			await ui.think(L("fargona", "sing_bad"))
			main.add_connection(1.0, "blended, badly, on Fargona Avenue")
		main.log_line("vigil", "sang the hymn through the digital vigil on Fargona Avenue")
	elif pick == 2:
		await ui.think(L("fargona", "lynx_talk"))
		await ui.say("Lynx", L("fargona", "lynx_talk_2"))
		main.log_line("vigil", "Lynx talked the digital vigil open")
	else:
		await ui.think(L("fargona", "wait_1"))
		if _lynx_here:
			await ui.think(L("fargona", "wait_lynx"))
		ui.close()
		await ui.fade_to(1.0, 1.2)
		await get_tree().create_timer(1.0).timeout
		await ui.fade_to(0.0, 1.2)
		await ui.think(L("fargona", "wait_2"))
		main.log_line("time", "+1 hour: waited out the digital vigil on Fargona Avenue")
	ui.close()
	# they open a path for the car
	_crowd_open = 1.0
	await get_tree().create_timer(1.5).timeout
	_stopped = false
	dash_label.text = L("drive", "dash")
	want_speed = 6.0
	await _cap(L("fargona", "through"), 4.0)
	await ui.say("A voice from the crowd", L("fargona", "crowd_voice"))
	ui.close()
	await _cap(L("fargona", "window"), 3.0)
	await _until_x(STOP_X - 22.0)
	await _police()
	await _climb_end()


func _police() -> void:
	var ui = main.ui
	main.play("siren", -4.0)
	if police:
		police.visible = true
		_police_t = 0.0
	await _cap(L("police", "sirens"), 2.0)
	await _cap(L("police", "drone"), 4.0)
	main.play("static", -8.0)
	await _cap(L("police", "speaker_1"), 5.0)
	main.play("static", -8.0)
	await _cap(L("police", "speaker_2"), 5.0)
	await ui.say("Carl", L("police", "carl"))
	if _lynx_here:
		await ui.say("Lynx", L("police", "lynx"))
	else:
		await ui.think(L("police", "alone"))
	ui.close()
	want_speed = 14.0


func _climb_end() -> void:
	var ui = main.ui
	await _until_x(-220.0)
	await _cap(L("climb", "cap_1"), 6.0)
	await _cap(L("climb", "cap_2"), 4.0)
	await ui.say("Carl", L("climb", "carl_lynx") if _lynx_here else L("climb", "carl_alone"))
	ui.close()
	await _until_x(CLIMB_X + 10.0)
	await _cap(L("climb", "cap_3"), 4.5)
	ui.show_toast(L("climb", "toast_faith"), 4.0)
	await _until_x(END_X + 6.0)
	_done = true
	main.flags["blackout_done"] = true
	main.log_line("time", "Day 4, 01:00: the climb road to the observatory")
	main.update_hud()
	if not main._selftest:
		main.load_level("Observatory")


# ------------------------------------------------------------------ the frame loop

func tick(delta: float) -> void:
	if not main or not main.player:
		return
	var p = main.player
	var pp: Vector3 = p.global_position
	# the frames' flashlight follows the eyes
	if torch and torch.visible:
		torch.global_transform = p.cam.global_transform
	# candles
	for c in candles:
		(c[0] as OmniLight3D).light_energy = float(c[1]) * (0.86 + sin(_t * 11.0 + float(c[1]) * 7.0) * 0.06 + randf() * 0.14)
	# the eye layer: only the frames see it
	var eye_on: bool = main.frames_on
	for e in eyes:
		(e as Node3D).visible = eye_on
	if fractal and eye_on:
		fractal.rotation.y += delta * 0.25
		fractal.modulate = Color.from_hsv(fmod(_t * 0.08, 1.0), 0.7, 1.0)
	if flame_eye and eye_on:
		flame_eye.scale = Vector3(1.0 + sin(_t * 1.7) * 0.08, 1.0 + sin(_t * 2.3) * 0.1, 1.0)
	# the guard's torch swings to whoever moves
	if guard_torch and not _driving:
		var d := pp - guard.global_position
		if d.length() < 16.0:
			var want := atan2(-d.x, -d.z) - guard.rotation.y
			guard_torch.rotation.y = lerp_angle(guard_torch.rotation.y, want, delta * 2.0)
			guard_torch.rotation.x = lerp_angle(guard_torch.rotation.x, -0.15, delta * 2.0)
		Anim.idle(guard, _t, 1.0)
		(guard.get_meta("arms")[1] as Node3D).rotation.x = -0.9
	# the eyeless one: a statue, until the frames are on and he turns
	if eyeless and not _driving:
		if eye_on and not _eyeless_turned and pp.distance_to(eyeless.global_position) < 30.0:
			_eyeless_turned = true
			turn_to(eyeless, pp, 2.5)
		elif not eye_on and _eyeless_turned:
			_eyeless_turned = false
			turn_to(eyeless, VIGIL_C, 2.5)
	if annie and not _driving:
		Anim.idle(annie, _t, 0.3)
		for a in annie.get_meta("arms"):
			(a as Node3D).rotation.x = -1.3
	for s in singers:
		Anim.idle(s, _t, 1.7)
		for a in s.get_meta("arms"):
			(a as Node3D).rotation.x = -1.3
	# the drone over the garden: falls when Carl crosses the plaza after the vigil
	if drone_phase == "idle" and main.flags.has("vigil_done") and not main.flags.has("drone_beat") \
			and not main.ui.busy and not main.flags.has("cinematic") and pp.z < -24.0 and pp.x > -8.0:
		_drone_beat()
	_tick_drone(delta)
	_tick_swarm(delta)
	_tick_lynx(delta, pp)
	if _driving:
		_tick_car(delta)


func _tick_drone(delta: float) -> void:
	if not drone or drone_phase == "idle" or drone_phase == "down":
		return
	var target := VIGIL_C + Vector3(cos(7 * TAU / 11.0 + 0.35) * 3.0, 0.4, sin(7 * TAU / 11.0 + 0.35) * 3.0)
	match drone_phase:
		"fall":
			drone_t += delta * 0.55
			var k := clampf(drone_t, 0.0, 1.0)
			drone.position = drone_from.lerp(target, k * k)
			drone.rotation.x = sin(_t * 9.0) * 0.5 * k
			drone.rotation.z = cos(_t * 7.0) * 0.5 * k
			if k >= 1.0:
				_drone_down(false)
		"stall":
			drone.position.y += sin(_t * 6.0) * delta * 0.4
			drone.rotation.x = sin(_t * 9.0) * 0.3
			drone.rotation.z = cos(_t * 7.0) * 0.3
			drone.position.y = maxf(drone.position.y - delta * 0.5, 14.0)
		"hijack":
			drone_t += delta * 0.6
			var k := clampf(drone_t, 0.0, 1.0)
			var mid := (drone_from + FOUNTAIN) * 0.5 + Vector3(0, 4.0, 0)
			var a := drone_from.lerp(mid, k)
			var b := mid.lerp(FOUNTAIN + Vector3(0, 0.3, 0), k)
			drone.position = a.lerp(b, k)
			drone.rotation.x = lerpf(drone.rotation.x, 0.0, delta * 3.0)
			drone.rotation.z = lerpf(drone.rotation.z, 0.0, delta * 3.0)
			if k >= 1.0:
				_drone_down(true)


func _drone_down(in_fountain: bool) -> void:
	drone_phase = "down"
	if drone_whine:
		drone_whine.stop()
	main.player.shake(0.5)
	if in_fountain:
		main.play("slam", -6.0, 0.8)
		splash.restart()
		splash.emitting = true
		drone.position = FOUNTAIN + Vector3(0.6, 0.25, 0.3)
		drone.rotation = Vector3(2.6, 0.4, 0.3)
	else:
		main.play("slam", 0.0, 0.6)
		main.play("sting", -4.0)
		drone.rotation = Vector3(1.1, 0.3, 0.5)
		if hurt_fig:
			hurt_fig.rotation.x = -1.45
			hurt_fig.position.y = 0.3
			var b := _find_body(hurt_fig)
			if b:
				set_active(b, true)
		if hurt_blood:
			hurt_blood.visible = true
		for c in candles:
			if c[0] == vigil_light:
				c[1] = 1.2


func _tick_swarm(delta: float) -> void:
	if not swarm:
		return
	var mm := swarm.multimesh
	var mm2 := swarm_red.multimesh
	for i in swarm_data.size():
		var d: Dictionary = swarm_data[i]
		var p: Vector3 = d.p
		if d.fall:
			p.y -= float(d.fv) * delta
			p += Vector3(sin(_t * 5.0 + float(d.w)), 0, cos(_t * 4.0 + float(d.w))) * delta * 2.0
			if p.y < 2.0:
				p.y = rng.randf_range(40.0, 70.0)
				p.x = rng.randf_range(-320.0, 80.0)
				p.z = rng.randf_range(-470.0, 40.0)
		else:
			p += (d.v as Vector3) * delta
			p.y += sin(_t * 0.7 + float(d.w)) * delta * 0.3
		d.p = p
		var xf := Transform3D(Basis(Vector3.UP, float(d.w) + _t * (3.0 if d.fall else 0.1)), p)
		mm.set_instance_transform(i, xf)
		mm2.set_instance_transform(i, Transform3D(Basis(), p + Vector3(0, -0.2, 0)))


func _tick_lynx(delta: float, pp: Vector3) -> void:
	if not lynx:
		return
	match lynx_state:
		"stair":
			Anim.idle(lynx, _t, 0.5)
			Anim.look(lynx, pp + Vector3(0, 1.6, 0), 1.0, 0.08)
		"gone", "follow":
			if lynx_state == "gone" and main.flags.has("doors_open"):
				lynx_state = "follow"
			if lynx_state == "gone":
				Anim.idle(lynx, _t, 0.5)
				return
			var p = main.player
			var target: Vector3 = pp + Basis(Vector3.UP, p.yaw) * Vector3(-1.3, 0, -0.7)
			target.y = 0.02
			target.z = minf(target.z, DOOR_Z - 1.0)
			var d := target - lynx.position
			d.y = 0.0
			var dist := d.length()
			if dist > 1.2:
				var step := minf(dist, 3.4 * delta)
				lynx.position += d.normalized() * step
				lynx.rotation.y = lerp_angle(lynx.rotation.y, atan2(-d.x, -d.z), delta * 6.0)
				Anim.walk(lynx, _t, 1.3, 0.0)
				_lynx_phase = _t
			else:
				Anim.idle(lynx, _t, 0.5)
				Anim.look(lynx, pp + Vector3(0, 1.6, 0), 1.0, 0.08)
		"car":
			if lynx_seat:
				Anim.sit(lynx_seat, 0.15)
				var head: Node3D = lynx_seat.get_meta("head")
				head.rotation.y = sin(_t * 0.5) * 0.4 - 0.3


func _tick_car(delta: float) -> void:
	# follow the route; brake to land on the stop; turn the player with the car
	var target_speed := want_speed
	if want_speed == 0.0 and speed > 0.0 and not _stopped:
		var dist := car.position.x - STOP_X
		target_speed = 14.0 if dist > 28.0 else (maxf(1.2, dist * 0.5) if dist > 0.4 else 0.0)
	speed = move_toward(speed, target_speed, delta * (5.0 if target_speed > speed else 9.0))
	if _seg < _path.size() - 1 and speed > 0.0:
		var a: Vector3 = _path[_seg]
		var b: Vector3 = _path[_seg + 1]
		var dir := (b - car.position)
		dir.y = 0.0
		var left := dir.length()
		var step := speed * delta
		if left <= step + 0.05:
			car.position = Vector3(b.x, car.position.y, b.z)
			_seg += 1
		else:
			car.position += dir.normalized() * step
		var want := atan2(-dir.x, -dir.z)
		var old := _car_yaw
		_car_yaw = lerp_angle(_car_yaw, want, minf(1.0, delta * 2.2))
		main.player.yaw += wrapf(_car_yaw - old, -PI, PI)
		# the climb: the road rises from CLIMB_X
		if car.position.x < CLIMB_X:
			car.position.y = (CLIMB_X - car.position.x) * 14.0 / 80.0
	car.rotation.y = _car_yaw
	var bob := sin(_t * 9.0) * 0.004 * minf(1.0, speed / 6.0)
	main.player.position = car.position + car.transform.basis * SEAT + Vector3(0, bob, 0)
	main.player.position.y = car.position.y + SEAT.y + bob
	if _engine:
		_engine.pitch_scale = 0.7 + speed / 14.0 * 0.6
		_engine.volume_db = -22.0 + speed / 14.0 * 8.0
	# seated, Main looks at nothing; while the road is blocked the ray from
	# the driver's seat still finds the people on the hood
	if _stopped and not main.ui.busy and not _fargona_done:
		var r: RayCast3D = main.player.ray
		if r.is_colliding():
			var c: Object = r.get_collider()
			if c and c.has_meta("id"):
				main._target = c
				main.ui.prompt.text = "E   " + str(c.get_meta("prompt"))
				main.ui.crosshair.color.a = 0.9
	# the police drone crossing overhead
	if police and _police_t >= 0.0:
		_police_t += delta
		var x := STOP_X + 40.0 - _police_t * 9.0
		police.position = Vector3(x, 20.0 + sin(_police_t * 1.3) * 1.5, FARGONA_Z + sin(_police_t * 0.7) * 6.0)
		police.rotation.y = _police_t * 0.8
		if police_light:
			police_light.light_energy = 2.0 if fmod(_police_t, 0.6) < 0.3 else 0.2
		if _police_t > 40.0:
			police.visible = false
			_police_t = -1.0
	# the front rows step aside once the road is theirs to open
	if _crowd_open > 0.0:
		for cf in crowd_figs:
			var n: Node3D = cf[0]
			var base: Vector3 = cf[1]
			var side := 1.0 if base.z > FARGONA_Z else -1.0
			var want_z := FARGONA_Z + side * 6.5 + (base.z - FARGONA_Z) * 0.3
			n.position.z = lerpf(n.position.z, want_z, delta * 1.2)
			Anim.look(n, main.player.global_position + Vector3(0, 1.6, 0), 1.0, 0.05)


# ------------------------------------------------------------------ dev and test

func apply_args(a: Dictionary) -> void:
	if a.has("doors"):
		main.flags["doors_open"] = true
		for i in doors.size():
			(doors[i] as Node3D).rotation.y = (-1.0 if i == 0 else 1.0) * 1.5
		door_body.queue_free()
		if _hymns.size() > 0:
			_hymns[0].volume_db = 2.0
	if a.has("drone"):
		drone.visible = true
		drone.position = VIGIL_C + Vector3(1.0, 14.0, -2.0)
		drone_phase = "stall"
		main.flags["vigil_done"] = true
		main.flags["drone_beat"] = true
	if a.has("fell"):
		main.flags["vigil_done"] = true
		main.flags["drone_beat"] = true
		drone.visible = true
		drone.position = VIGIL_C + Vector3(cos(7 * TAU / 11.0 + 0.35) * 3.0, 0.4, sin(7 * TAU / 11.0 + 0.35) * 3.0)
		_drone_down(false)
	if a.has("carx") or a.has("carz"):
		_driving = true
		car_shell.visible = false
		car.visible = true
		main.flags["vigil_done"] = true
		main.flags["drone_beat"] = true
		if a.has("carz"):
			car.position = Vector3(STREET_X, 0, float(a["carz"]))
			_seg = 1
			_car_yaw = PI
		else:
			car.position = Vector3(float(a["carx"]), 0, FARGONA_Z)
			_seg = 3
			_car_yaw = PI / 2.0
			if car.position.x < CLIMB_X:
				car.position.y = (CLIMB_X - car.position.x) * 14.0 / 80.0
				_seg = 4
		car.rotation.y = _car_yaw
		_seat_player()
		torch.visible = false
		if a.has("stopped"):
			_stopped = true
		if a.has("police") and police:
			police.visible = true
			_police_t = 2.0
		if a.has("yaw"):
			main.player.yaw = deg_to_rad(float(a["yaw"]))


func _by_id(id: String) -> void:
	for n in main._all_with_meta(self, "id"):
		if is_instance_valid(n) and str(n.get_meta("id")) == id:
			await main.interact(n)
			print("ok ", id)
			return


func selftest() -> void:
	await intro()
	if lynx:
		walk_ignore = [lynx]
	await check_walk("spawn->lobby doors", "doors")
	await check_walk("spawn->guard", "guard")
	if lynx:
		await _by_id("lynx")
	for id in ["exit_sign", "fuse", "guard", "screen", "doors"]:
		await _by_id(id)
	# the doors open: down the garden to the vigil, across the plaza, the car
	await check_walk("spawn->annie", "annie")
	await check_walk("spawn->plaza (drone)", Vector3(2.0, 0.0, -30.0), null, Rect2(), 1.5)
	await check_walk("spawn->my_car", "my_car")
	main.player.position = VIGIL_C + Vector3(5.0, 0.2, 3.0)
	await _by_id("annie")
	print("ok vigil")
	# cross the plaza: the drone comes down
	main.player.position = Vector3(2.0, 0.2, -30.0)
	while not main.flags.has("drone_beat"):
		await get_tree().process_frame
	while main.flags.has("cinematic"):
		await get_tree().process_frame
	print("ok drone ", main.flags.has("drone_hijacked"), " ", main.flags.has("drone_fell"))
	main.player.position = CAR_P + Vector3(-3.0, 0.2, 0.0)
	for id in ["charger", "eyeless_w", "vagrant_w", "vagrant_n", "my_car"]:
		await _by_id(id)
	while not _stopped and not _done:
		await get_tree().process_frame
	print("ok stopped on Fargona")
	for id in ["mourner_1", "mourner_2", "mourner_3", "preacher", "drive_on"]:
		await _by_id(id)
	while not _done:
		await get_tree().process_frame
	print("ok climb; blackout_done=", main.flags.has("blackout_done"))
	await main.selftest_all_interactables()
