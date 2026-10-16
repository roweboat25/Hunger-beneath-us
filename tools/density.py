"""The people and machines of Silico: a density pass laid over every street.

Each entry is placed near the asked-for tile, nudged to the nearest free cell
that Carl can reach, so the maps can change under it. Everything here comes
from the book: the rolling outages, Voltx crews against the sand, delivery
drones that reroute, police drones like carrion flies, FreudBot booths,
Nixtra and TOKZ ads, the eye in the kiosks and on the substation panels.

Entry kinds:
  N(id, x, y, facing, sprite, say, scan=..., speaker=..., scan_name=..., bad=False)
  P(name, x, y, id=..., say=..., scan=..., lift=0, meta=..., on_wall=False)
  PAIR(name, x, y, id, say, scan)        a screen or kiosk with its static twin
  DRONE(name, x, y, id, say, scan)       hovers; bobs in the scene
  D(name, x, y)                          a decal
"""
import json
import os

PROPS = json.load(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "assets", "props", "props.json")))
TILE = 32


def N(id, x, y, facing, sprite, say, scan=None, speaker=None, scan_name=None, bad=False, min_connection=None):
    return dict(kind="npc", id=id, x=x, y=y, facing=facing, sprite=sprite, say=say, scan=scan,
                speaker=speaker, scan_name=scan_name, bad=bad, min_connection=min_connection)


def P(name, x, y, id=None, say=None, scan=None, lift=0, meta=None, on_wall=False, bad=False, scan_name=None):
    return dict(kind="prop", name=name, x=x, y=y, id=id, say=say, scan=scan, lift=lift, meta=meta or {},
                on_wall=on_wall, bad=bad, scan_name=scan_name)


def PAIR(name, x, y, id, say, scan, on_wall=False, scan_name=None):
    return dict(kind="pair", name=name, x=x, y=y, id=id, say=say, scan=scan, on_wall=on_wall, scan_name=scan_name)


def DRONE(name, x, y, id, say, scan, lift=60, bad=False, scan_name=None):
    return dict(kind="drone", name=name, x=x, y=y, id=id, say=say, scan=scan, lift=lift, bad=bad, scan_name=scan_name)


def D(name, x, y):
    return dict(kind="decal", name=name, x=x, y=y)


AD_PSYONIC = ("A Psyonic ad, looping. A family asleep, smiling, under the logo. Neural harmony, AI-assisted actualisation. The same ad as the vending machines.",
              "PSYONIC DISPLAY\nloop: FAMILY ASLEEP\nviews today: 2,001,114", "Psyonic display")
AD_NIXTRA = ("Nixtra Nicotine. A new flavour, Calm. The woman in the ad had her eyes closed and was smiling the way Dufredy had been smiling.",
             "NIXTRA DISPLAY\nloop: CALM\nskin contact today: 3,402", "Nixtra display")
AD_TOKZ = ("A TOKZ ad. Sleep better. Sleep together. The couple in it faced the same way in the dark, eyes shut, and the camera held on them too long.",
           "TOKZ DISPLAY\nloop: SLEEP TOGETHER\nviews today: 414,009", "TOKZ display")
KIOSK = ("A city terminal kiosk. Transit, bills, FreudBot bookings. Someone had scrawled the eye on the inside of the screen bezel, from the inside.",
         "CITY TERMINAL\nuptime: 0d 0h\nlast query: WHERE IS THE DOOR", "City terminal")

DENSITY = {
    "Lamplight": [
        N("resident_4b", 20, 8, "down", "tyson",
          "'You from Psyonic? Then tell them the hallway lights have been on for three nights. All night. Nobody on four can sleep, and nobody on four can stop smiling about it.'",
          "RESIDENT 4B - LAMPLIGHT\nPsyon 4.1 - sync 61%\nsleep debt: 31h", scan_name="Resident, 4B"),
        N("kid_lamplight", 30, 16, "up", "ezra",
          "'Mister. My tablet says please convene. What's convene?'",
          "MINOR - corporate training, year 2\nPsyon JUNIOR - sync 88%\nforeground app: THE PASSWORD GAME", scan_name="Minor"),
        N("voltx_lamplight", 6, 16, "right", "seth",
          "Voltx, on his knees at a sand-choked port with a dustbuster. 'Gets in overnight. Every night. You'd think a city this smart could keep its mouth shut.'",
          "VOLTX FIELD TECH\nPsyon: none (company policy)\nshift: 14h\nports cleared: 212", scan_name="Voltx tech"),
        PAIR("kiosk", 36, 8, "kiosk_lamplight", KIOSK[0], KIOSK[1], scan_name=KIOSK[2]),
        PAIR("ad_screen", 10, 4, "ad_lamplight", AD_PSYONIC[0], AD_PSYONIC[1], on_wall=True, scan_name=AD_PSYONIC[2]),
        DRONE("drone_police", 26, 11, "pd_drone_lamplight",
              "A police drone, low over the boulevard, its camera pointed at the same square of asphalt for the whole time I watched. Carrion flies, Lynx called them.",
              "SILICO PD DRONE 2\nassignment: NONE\nholding: 6h 12m\ntarget: THE GROUND", scan_name="Police drone"),
        D("sewer_lid", 18, 12), D("coffee_cup", 22, 9), D("coffee_cup", 40, 16),
    ],
    "Spine": [
        P("pylon", 10, 9, id="pylon_spine_w",
          say="A transit tube pylon. The elevated tubes all ran to the tower; from up there, Turan liked to say, the city looked like circuitry.",
          scan="TRANSIT PYLON 41\nline: TOWER LOOP\nload: 12%\nterminus: THE TOWER", scan_name="Transit pylon"),
        P("pylon", 58, 9, id="pylon_spine_e", say="Another pylon, another tube, the same destination.",
          scan="TRANSIT PYLON 43\nline: TOWER LOOP\nterminus: THE TOWER", scan_name="Transit pylon"),
        N("press_1", 28, 9, "up", "forner",
          "The media scrum, waiting under the tower for a statement. 'They said nine. It's eleven. They always say nine.'",
          "PRESS - CHANNEL 4\nPsyon 4.1 - sync 94%\nstory: EYELESS MAN BLAMES PRODUCT", scan_name="Reporter"),
        N("press_2", 30, 9, "up", "tyson",
          "'Is it true he said it told him to? The eyeless guy? Off the record. Everything's off the record, nothing records any more.'",
          "PRESS - THE SILICO LEDGER\nPsyon 3.9 - sync 70%\nrecorder: NOT RECORDING", scan_name="Reporter"),
        N("sweeper_spine", 45, 16, "left", "bot",
          "A Voltx cleaning bot, sweeping the same square metre of sidewalk. A perfect ring, over and over, and the sand came straight back.",
          "VOLTX SWEEPER 9\ntask: CLEAR SAND\nprogress: 0%\nloop count: 1,340", scan_name="Sweeper bot"),
        N("cop_spine", 20, 16, "right", "officer",
          "'Psyonic. Course you are. Shame no surveillance is working on this whole block. Course it isn't.'",
          "SILICO PD - BADGE 2211\nPsyon: none (opted out)\nnote: has been here since the first incident", scan_name="Officer"),
        PAIR("ad_screen", 50, 4, "ad_spine", AD_NIXTRA[0], AD_NIXTRA[1], on_wall=True, scan_name=AD_NIXTRA[2]),
        P("charging_post", 12, 15, id="charger_spine",
          say="A charging post for the company fleet. It logged every charge, every trip, every passenger. Free car rides, they'd called it in the offer letter.",
          scan="FLEET CHARGER 3\nlast vehicle: DRAKE, C.\ntrips logged: ALL OF THEM", scan_name="Fleet charger"),
        D("sewer_lid", 30, 13), D("coffee_cup", 27, 8), D("sewer_lid", 54, 11),
    ],
    "ZetaPark": [
        N("doorman_zeta", 14, 8, "down", "tyson",
          "'Mr Drake. Ms Lynx said you'd come by. She said you'd come by last week, too.' He said it kindly, the way you'd say something for the ninth time.",
          "BUILDING STAFF - ZETA TOWER\nPsyon 4.1 - sync 99%\nnote: same sentence, 9 times today", scan_name="Doorman"),
        N("resident_parkave", 36, 16, "up", "emmet",
          "'The corner's bad. Everyone knows. You stand on it with the frames on and they show you your own back.'",
          "RESIDENT - PARK AVE\nPsyon 4.0 - sync 55%\nflag: HIGH REPORTER", scan_name="Resident"),
        PAIR("kiosk", 40, 8, "kiosk_zeta",
             "City terminal. The transit map on it had the lines drawn in the wrong colours, and every one of them still ran to the tower.",
             "CITY TERMINAL 206\nmap version: UNKNOWN\nlines: ALL TO TOWER", scan_name="City terminal"),
        DRONE("drone", 22, 11, "drone_zeta",
              "A delivery drone holding over the intersection, package still clipped under it. Nobody coming for it. Nobody left to.",
              "PSYONIC LOGISTICS UNIT\npackage: ORA FRAMES x1\nrecipient: DUFREDY, H.\nstatus: UNDELIVERABLE", bad=True, scan_name="Delivery drone"),
        D("sewer_lid", 20, 13), D("coffee_cup", 16, 9),
    ],
    "CanalWalk": [
        P("substation", 12, 7, id="filtration",
          say="A Voltx filtration unit, humming. Sand on the walk around it, in rings.",
          scan="VOLTX FILTRATION UNIT 7\nstatus: RUNNING\nintake: NORMAL\nlast service: 20 years", scan_name="Filtration unit"),
        N("voltx_canal", 14, 8, "left", "seth",
          "'Fourth time this week. I clear it, it comes back in rings. You're Psyonic? Then you tell me why a filter makes shapes.'",
          "VOLTX FIELD TECH - S. OKAFOR\nPsyon: none (company policy)\non his knees today: 6h", scan_name="Voltx tech"),
        P("drone_pole", 30, 5, id="pole_canal",
          say="A rusted drone pole, crooked, its camera housing empty. The voice assistant speaker hissed static, and under the static, slower than speech, something keeping time.",
          scan="CIVIC ASSISTANT POLE\ncamera: MISSING\naudio: BROADCASTING\nsource: UNKNOWN", bad=True, scan_name="Drone pole"),
        N("canal_woman", 6, 10, "right", "nurse",
          "'My husband walks here at night. Says the canal's talking. It's dry. It's been dry twenty years.'",
          "RESIDENT - LAMPLIGHT\nPsyon 3.8 - sync 40%\nsleep debt: 12h\nspouse: ON THE PATH", scan_name="Resident"),
        D("sewer_lid", 24, 9),
    ],
    "Underpass": [
        N("bot_fallen", 8, 12, "left", "bot",
          "A maintenance bot on its side, legs going. Its speaker said 'please' every eleven seconds. I counted.",
          "VOLTX MAINT UNIT 22\nstatus: FALLEN\nrequest: PLEASE\nrequest: PLEASE", bad=True, scan_name="Maintenance bot"),
        P("substation", 30, 12, id="sub_underpass",
          say="A substation panel. Warning stripes, a padlock, and the eye in marker over the lock. Sewer lids, substation panels, even inside a city terminal kiosk. They'd said it was everywhere.",
          scan="ALTO ENERGY SUBSTATION 9\nload: 140%\nfeed: BENEATH", bad=True, scan_name="Substation"),
        D("sewer_lid", 14, 8), D("sewer_lid", 26, 8),
    ],
    "Heights": [
        DRONE("drone", 34, 4, "swarm_1", "", "", lift=80), DRONE("drone", 38, 4, "swarm_2", "", "", lift=80),
        DRONE("drone", 33, 6, "swarm_3", "", "", lift=80), DRONE("drone", 39, 6, "swarm_4", "", "", lift=80),
        DRONE("drone", 34, 8, "swarm_5", "", "", lift=80), DRONE("drone", 38, 8, "swarm",
              "Six delivery drones over one house, in a ring. They didn't drift. Nobody was home, and the ring was waiting for someone to be.",
              "PSYONIC LOGISTICS SWARM\nunits: 6\nroute: NOMINAL", lift=80, scan_name="Delivery swarm"),
        N("mother_heights", 10, 16, "right", "nurse",
          "'They put a nightlight in every room. Corporate training sent them home with it. She sleeps with her eyes open now. Is that normal? You'd know. You're Psyonic.'",
          "RESIDENT - HEIGHTS\nPsyon 4.1 - sync 97%\ndependents: 1, enrolled", scan_name="Resident"),
        N("kid_heights", 24, 16, "up", "ezra",
          "'We did the breathing today. You close your eyes and you count the rings. I got to eleven.'",
          "MINOR - corporate training, year 1\nPsyon JUNIOR - sync 100%", scan_name="Minor"),
        N("security_heights", 6, 8, "down", "officer",
          "'Gated community, sir. You're on the list.' He hadn't looked at anything. 'Everyone's on the list.'",
          "PRIVATE SECURITY - HEIGHTS\nPsyon 4.1 - sync 91%\nlist: EVERYONE", scan_name="Security"),
        PAIR("ad_screen", 20, 4, "ad_heights", AD_TOKZ[0], AD_TOKZ[1], on_wall=True, scan_name=AD_TOKZ[2]),
        P("charging_post", 15, 15, id="charger_heights",
          say="The charging post outside the house. The car was always full. The car always knew where I'd been.",
          scan="FLEET CHARGER 118\nlast vehicle: DRAKE, C.\nlast trip: HOME, 03:12", scan_name="Fleet charger"),
        D("coffee_cup", 28, 9),
    ],
    "Flyover": [
        N("walker_flyover", 12, 14, "down", "emmet",
          "'Don't look at the boards too long. The old ones, top of the ramp. They look back.' He kept his own eyes on the asphalt the whole way down.",
          "PEDESTRIAN\nPsyon 2.2 (legacy)\nsync: 12%\nflag: DISSENTER FORUM", scan_name="Pedestrian"),
        DRONE("drone_police", 12, 20, "pd_drone_flyover",
              "A police drone over the ramp. Carrion flies, Lynx called them, the night she told me about Nathan.",
              "SILICO PD DRONE 7\nassignment: FLYOVER\ntarget: DRAKE, C.", lift=70, bad=True, scan_name="Police drone"),
        P("pylon", 4, 10, id="pylon_flyover",
          say="A transit tube pylon. The tube overhead ran dead straight to the tower, a thread in the circuitry.",
          scan="TRANSIT PYLON 12\nline: HEIGHTS EXPRESS\nterminus: THE TOWER", scan_name="Transit pylon"),
    ],
    "HillRoad": [
        P("freudbot", 20, 5, id="freudbot",
          say="A FreudBot GPT booth. A seat, a screen with a face on it. Any residual trauma should be looked after by FreudBot GPT. I was required to end every interview that way.",
          scan="FREUDBOT GPT - BOOTH 12\nsession: none\nmood: CHEERFUL\nmalfunction reports: RISING", scan_name="FreudBot booth"),
        N("orderly_hill", 30, 9, "left", "tyson",
          "'Five of them humming on the ward. Five. None of them have met. You want to know what it sounds like?' He didn't wait. 'It sounds like a lullaby.'",
          "SALTECH ORDERLY\nPsyon 4.0 - sync 80%\nshift: 19h", scan_name="Orderly"),
        N("patient_hill", 8, 6, "left", "emmet",
          "An old man in a gown and slippers, walking downhill away from the hospital. 'Discharged,' he said. 'Discharged.' He was humming it.",
          "SALTECH PATIENT 1181\ndischarged: NO\nPsyon 4.1 - sync 100%\nheading: THE TOWER", bad=True, scan_name="Patient"),
    ],
    "Cognizo": [
        N("intern_cognizo", 30, 16, "up", "carl_noglasses",
          "'Cognizo frames don't do this, you know. Ours don't talk. That's the whole pitch.' A pause. 'Then why did mine?'",
          "COGNIZO - ASSOCIATE\nframes: COGNIZO v2\nPsyon: NONE DETECTED\nPsyon: DETECTED", bad=True, scan_name="Cognizo associate"),
        N("greeter_cognizo", 14, 8, "down", "bot",
          "'Welcome to Cognizo Quarter. Please mind the gap. Please mind the gap. Please.'",
          "COGNIZO GREETER UNIT\nscript: WELCOME\nscript: PLEASE", scan_name="Greeter bot"),
        P("pylon", 8, 9, id="pylon_cognizo_w", say="A transit pylon. Even Cognizo's tubes ran to the tower.",
          scan="TRANSIT PYLON 61\nline: COGNIZO LOOP\nterminus: THE TOWER", scan_name="Transit pylon"),
        P("pylon", 40, 9, id="pylon_cognizo_e", say="A pylon. The tube hummed overhead; nothing was running on it.",
          scan="TRANSIT PYLON 62\nline: COGNIZO LOOP\nload: 0%", scan_name="Transit pylon"),
        PAIR("ad_screen", 26, 4, "ad_cognizo",
             "A Cognizo ad. Clean lines, no faces. OURS DON'T TALK. Under it, in marker, two rings.",
             "COGNIZO DISPLAY\nloop: OURS DON'T TALK\nnote: it does", on_wall=True, scan_name="Cognizo display"),
        PAIR("kiosk", 36, 16, "kiosk_cognizo", KIOSK[0], "CITY TERMINAL 301\nuptime: 0d 0h\nlast query: WHERE IS THE DOOR", scan_name=KIOSK[2]),
        D("coffee_cup", 20, 9), D("sewer_lid", 24, 12),
    ],
    "RedRock": [
        N("handler", 30, 6, "down", "tyson",
          "'You holding? No? You want to be.' He had the frames pushed up on his head like sunglasses. 'K's cheaper than a Psyon session, and it doesn't talk back.'",
          "UNREGISTERED\nORA frames: DISABLED\nPsyon: none\nwarrants: 3", bad=True, scan_name="A handler"),
        N("partier_a", 44, 10, "right", "ezra",
          "'Lushon's is dead tonight. Basement's where it's at. Don't go down there with those on, though.' She tapped her own temple. 'They don't like it when the frames are watching.'",
          "TOKZ - CREATOR\nPsyon 4.1 - sync 74%\nfollowers: 2,114\nlast post: 11 min ago", scan_name="A partier"),
        N("partier_b", 45, 10, "left", "seth",
          "'Every weekend, man. The plaza's the only place the tower lets you forget the tower. Then Monday the frames go back on and you're a brand again.'",
          "SALTECH - ORDERLY\nPsyon 4.1 - sync 61%\nshift: 06:00", scan_name="A partier"),
        N("fighter_a", 41, 14, "right", "tyson",
          "'Say it again. SAY IT AGAIN.' He had the other one by the collar. 'He said my frames were talking to his. Like they know each other. Like we're not even here.'",
          "VOLTX - LINEMAN\nPsyon 4.1 - sync 93%\npaired: FIGHTER_B", bad=True, scan_name="A lineman"),
        N("fighter_b", 42, 14, "left", "ezra",
          "'They ARE talking. Listen. Listen to them. Mine's saying your name.' She wasn't fighting back. She was smiling.",
          "NIXTRA - COURIER\nPsyon 4.1 - sync 93%\npaired: FIGHTER_A", bad=True, scan_name="A courier"),
        N("drunk", 9, 8, "down", "forner",
          "'Three eyes. Three eyes on every machine in there. I've been putting money in all night and it just keeps showing me the same thing.'",
          "UNREGISTERED\nORA frames: CRACKED\ncredit: 0", scan_name="A drunk"),
        N("bouncer", 51, 8, "down", "officer",
          "'Frames off downstairs. House rule.' He looked at mine. 'Company frames, double. It's an arcade, not a church. Take them off or go and gamble.'",
          "LUSHON GROUP - SECURITY\nPsyon: none\nframes: NONE", scan_name="The bouncer"),
        DRONE("drone_police", 20, 9, "drone_plaza",
              "A police drone circling the pillar at the height of the plaque, the way the book of the city says they do, like carrion flies.",
              "SILICO PD DRONE 77\npatrol: RED ROCK\nflag: NONE\nflag: SUBJECT DRAKE", bad=True, scan_name="Police drone"),
        PAIR("kiosk", 44, 16, "kiosk_plaza", KIOSK[0], "CITY TERMINAL 414\nuptime: 2d 3h\nlast query: WHERE IS THE FUN", scan_name=KIOSK[2]),
        PAIR("ad_screen", 32, 4, "ad_plaza",
             "A Nixtra ad over the shut outlet. SLEEP BETTER. SLEEP TOGETHER. The woman in it had her eyes closed and was smiling at me anyway.",
             "NIXTRA DISPLAY\nloop: SLEEP TOGETHER\nviewers tonight: 1,206", on_wall=True, scan_name="Nixtra display"),
        D("coffee_cup", 35, 15), D("sewer_lid", 18, 10),
    ],
    "RailCut": [
        N("signalman_rail", 10, 10, "right", "seth",
          "'Empty train came through at walking pace. Faces in every window, nobody on the platform, nobody off. Cognizo says it was a test run. Of what, I said.'",
          "COGNIZO RAIL - SIGNALMAN\nPsyon: none\nframes: COGNIZO v1\nnote: saw the faces", scan_name="Signalman"),
        DRONE("drone", 20, 9, "drone_rail",
              "A delivery drone following the rails at walking pace, low, like it was riding them.",
              "PSYONIC LOGISTICS UNIT\nroute: RAIL\nnote: not a rail route", scan_name="Delivery drone"),
        P("substation", 30, 13, id="sub_rail",
          say="A substation. The eye on the panel, and under it, scratched in with something sharp: WE KNOW WHO SENDS THE SIGNALS.",
          scan="ALTO ENERGY SUBSTATION 14\nfeed: TOWER\nfeed: BENEATH", bad=True, scan_name="Substation"),
    ],
    "ParkAve": [
        N("commuter_a", 12, 6, "down", "tyson",
          "Adults clutched paper coffee cups and stared at nothing. This one didn't blink while I talked to him. 'Fine,' he said. 'Fine. Fine.'",
          "PSYONIC - MARKET INTELLIGENCE\nPsyon 4.1 - sync 99%\nblink rate: 0", bad=True, scan_name="Commuter"),
        N("commuter_b", 14, 6, "down", "nurse",
          "'Sorry, I'm on a call.' She wasn't holding anything. Her lips kept moving after I'd walked on.",
          "FARGONA BANKING - ANALYST\nPsyon 4.1 - sync 98%\ncall: NONE", scan_name="Commuter"),
        PAIR("kiosk", 24, 9, "kiosk_parkave", KIOSK[0], "CITY TERMINAL 212\nuptime: 0d 0h\nlast query: WHERE IS THE DOOR", scan_name=KIOSK[2]),
        D("coffee_cup", 11, 7), D("coffee_cup", 16, 7), D("coffee_cup", 30, 9),
    ],
    "RestrictedRoad": [
        DRONE("drone_police", 20, 6, "pd_drone_gate",
              "A police drone holding at the gate. Beyond it, no drones at all. The sky over the flats was empty, and that was worse.",
              "SILICO PD DRONE 11\nassignment: PERIMETER\nbeyond: NO COVERAGE", lift=70, scan_name="Police drone"),
        N("voltx_gate", 12, 10, "right", "seth",
          "'Nobody goes past the gate. Filtration's dead out there; the sand's winning. Psyonic marked it restricted. Restricted from what, I asked. They said from the sand.'",
          "VOLTX - PERIMETER CREW\nPsyon: none\nnote: wants to go home", scan_name="Voltx crew"),
        P("substation", 30, 10, id="sub_gate",
          say="The last substation before the flats. The eye on this one wasn't drawn. It was stamped into the panel at the factory.",
          scan="ALTO ENERGY SUBSTATION 0\nfeed: BENEATH\nmark: FACTORY STAMP", bad=True, scan_name="Substation"),
    ],
    "Southtown": [
        N("resident_south", 10, 16, "up", "emmet",
          "'Voltx recruits from here. Scrappy, they call us. They mean cheap.' He nodded at the tower, visible from everywhere. 'They mean we'll go underneath.'",
          "RESIDENT - SOUTHTOWN\nPsyon: none\nframes: NONE\nnote: unmonitored", scan_name="Resident"),
        P("drone_pole", 30, 8, id="pole_south",
          say="Another drone pole, the speaker torn out of this one. Someone had wedged a stick in the empty camera housing, and tied two rings of twine around it.",
          scan="CIVIC ASSISTANT POLE\ncamera: STICK\naudio: NONE", scan_name="Drone pole"),
        PAIR("kiosk", 40, 16, "kiosk_south", "A city terminal, screen cracked, still lit. The eye on the inside of the glass here too.",
             "CITY TERMINAL 7\nuptime: 0d 0h\nlast query: WHERE IS THE DOOR", scan_name="City terminal"),
        D("sewer_lid", 20, 12),
    ],
    "Fargona": [
        N("mourner_a", 10, 13, "up", "tyson",
          "'You should really stop and enjoy the lights.' He didn't look down from the sky to say it.",
          "MOURNER\nPsyon 4.1 - sync 100%\nsynced to: OKAFOR, D. (deceased)\nstatus: ON THE PATH", scan_name="Mourner", bad=True),
        N("mourner_b", 15, 14, "up", "nurse",
          "'She's in the tower. They let me talk to her on Tuesdays. She sounds like herself. She sounds exactly like herself.'",
          "MOURNER\nPsyon 4.1 - sync 100%\nsynced to: VASS, M. (deceased)\nstatus: ON THE PATH", scan_name="Mourner", bad=True),
        N("mourner_c", 20, 12, "up", "ezra",
          "'Do you hear the leaves? It's autumn in there. It's always autumn.' A tablet held up in both hands, the way you'd hold a book you believed.",
          "MOURNER\nPsyon 4.1 - sync 100%\nsynced to: PELL, J. (deceased, aged 9)\nstatus: ON THE PATH", scan_name="Mourner", bad=True),
        N("mourner_d", 27, 14, "up", "forner",
          "'Bow and it shows you. That's all. You just bow.' He said it to the sky, not to me.",
          "MOURNER\nPsyon 4.1 - sync 100%\nsynced to: FORNER, A. (deceased)\nstatus: ON THE PATH", scan_name="Mourner", bad=True),
        N("mourner_e", 32, 12, "up", "seth",
          "A boy of twelve or so with his frames lit, singing the hymn in a voice too low for him. Nobody near him was his parent.",
          "MOURNER\nPsyon 4.1 - sync 100%\nsynced to: a friend showed me\nstatus: ON THE PATH", scan_name="Mourner", bad=True),
        N("mourner_f", 36, 13, "up", "emmet",
          "'The Mimic walks among us.' He said it the way people say good evening, and then he smiled at me, and then he looked back up.",
          "MOURNER\nPsyon 4.1 - sync 100%\nsynced to: DRAKE, C.\nstatus: ON THE PATH", scan_name="Mourner", bad=True),
        N("mourner_g", 6, 14, "up", "officer",
          "A patrol officer, frames lit, singing with the rest. His cruiser's lights were still going somewhere behind the crowd.",
          "SILICO PD - OFF SHIFT\nPsyon 4.1 - sync 100%\nsynced to: REYES, T. (deceased)\nstatus: ON THE PATH", scan_name="Officer", bad=True),
        PAIR("ad_screen", 4, 4, "bank_screen",
             "Fargona Banking's screens, every one of them showing a face, and under each face a date. The departed. Views climbing in the corner, live.",
             "FARGONA BANKING - VIGIL SPONSOR\nloop: THE DEPARTED\nfaces tonight: 61\nviews: 9,114,002", on_wall=True, scan_name="Bank display"),
        PAIR("ad_screen", 14, 4, "bank_screen2",
             "Another screen. The face on it was Dufredy's, the outburst at the tower, looping. The view count under it climbed while I watched.",
             "TOKZ - LIVE\nclip: DUFREDY OUTBURST\nviews: 2,004,117\nsentiment: AWE", on_wall=True, scan_name="TOKZ display"),
        DRONE("drone_police", 30, 9, "drone_fargona",
              "A police drone holding over the crowd with its light on nobody. It had been told to disperse them. It was singing too.",
              "SILICO PD DRONE 7\norder: DISPERSE\nstatus: HOLDING\naudio out: HYMN", bad=True, scan_name="Police drone"),
        D("coffee_cup", 24, 15), D("sewer_lid", 16, 12),
    ],
    "Park": [
        P("drone_pole", 30, 6, id="pole_park",
          say="A rusted drone pole stood crooked near the sandbox, its camera housing empty, its voice assistant speaker hissing faintly with static.",
          scan="CIVIC ASSISTANT POLE - HARMONY GREEN\ncamera: MISSING\naudio: STATIC\nclimate: 72F, always", scan_name="Drone pole"),
    ],
}


def _footprint(name, tx, ty):
    pw = max(1, PROPS[name]["w"] // TILE)
    return [(tx + dx, ty) for dx in range(pw)]


def _place(m, blocked, x, y, cells=1):
    """Nearest reachable free cell to (x, y) with `cells` free cells to its right."""
    seen = {m.player}
    stack = [m.player]
    while stack:
        cx, cy = stack.pop()
        for nx, ny in ((cx + 1, cy), (cx - 1, cy), (cx, cy + 1), (cx, cy - 1)):
            if 0 <= nx < m.w and 0 <= ny < m.h and not blocked[ny][nx] and (nx, ny) not in seen:
                seen.add((nx, ny))
                stack.append((nx, ny))
    for c in sorted(seen, key=lambda c: abs(c[0] - x) + abs(c[1] - y)):
        if all((c[0] + d, c[1]) in seen for d in range(cells)):
            return c
    return (x, y)


def _mark(blocked, name, tx, ty):
    for cx, cy in _footprint(name, tx, ty):
        if 0 <= cy < len(blocked) and 0 <= cx < len(blocked[0]):
            blocked[cy][cx] = True


def densify(m):
    entries = DENSITY.get(m.name)
    if not entries:
        return
    blocked = m.blocked_grid()
    # keep a lane: never block the row Carl starts on
    for e in entries:
        kind = e["kind"]
        if kind == "decal":
            m.decal(e["name"], e["x"], e["y"])
            continue
        meta = {}
        if e.get("scan"):
            meta["scan"] = e["scan"]
        if e.get("scan_name"):
            meta["scan_name"] = e["scan_name"]
        if e.get("bad"):
            meta["scan_bad"] = True
        if kind == "npc":
            x, y = _place(m, blocked, e["x"], e["y"])
            blocked[y][x] = True
            nm = dict(meta, say=e["say"])
            if e.get("speaker"):
                nm["speaker"] = e["speaker"]
            if e.get("min_connection") is not None:
                nm["min_connection"] = e["min_connection"]
            m.npc(e["id"], x, y, e["facing"], sprite=e["sprite"], meta=nm)
        elif kind in ("prop", "pair", "drone"):
            name = e["name"]
            solid = PROPS[name]["solid"] and kind != "drone"
            if e.get("on_wall"):
                x, y = e["x"], e["y"]
                tx, ty = x, y + 2  # the trigger sits in the wall's bottom row, reachable from the sidewalk
            elif solid:
                x, y = _place(m, blocked, e["x"], e["y"], cells=max(1, PROPS[name]["w"] // TILE))
                _mark(blocked, name, x, y)
                tx, ty = x, y
            else:
                x, y = _place(m, blocked, e["x"], e["y"])
                tx, ty = x, y
            tw = max(1, PROPS[name]["w"] // TILE)
            pmeta = {}
            if kind == "drone":
                pmeta["drone"] = True
            if kind == "pair":
                pmeta["pair"] = name
                m.prop(name, x, y, id=e["id"], meta=pmeta)
                m.prop(name + "_static", x, y, id=e["id"] + "_static", visible=False, solid=0, meta={"pair": name + "_static"})
            else:
                m.prop(name, x, y, lift=e.get("lift", 0), id=e["id"], solid=0 if kind == "drone" else None, meta=pmeta)
            if e.get("say"):
                m.trigger(e["id"], tx, ty, tw, 1, meta=dict(meta, say=e["say"]))
