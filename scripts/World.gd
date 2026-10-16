class_name World
## The map of Silico: which exit of which map leads where, and where Carl
## lands when he arrives. Streets and routes are open; interiors only open
## when they are the next plot beat (see StreetScene).

## map -> exit id -> [target map, spawn tile in the target]
const EXITS := {
	"Lamplight": {"exit:east": ["Spine", Vector2i(2, 11)], "exit:south": ["CanalWalk", Vector2i(20, 2)],
		"door:Apartment": ["Apartment", Vector2i(3, 13)], "door:DornerFlat": ["DornerFlat", Vector2i(3, 13)]},
	"Spine": {"exit:west": ["Lamplight", Vector2i(45, 11)], "exit:east": ["ZetaPark", Vector2i(2, 11)],
		"exit:south": ["Underpass", Vector2i(20, 2)], "exit:north": ["Flyover", Vector2i(12, 25)],
		"door:WarRoom": ["WarRoom", Vector2i(14, 14)]},
	"ZetaPark": {"exit:west": ["Spine", Vector2i(61, 11)], "exit:east": ["ParkAve", Vector2i(2, 8)],
		"door:LynxApartment": ["LynxApartment", Vector2i(3, 13)]},
	"ParkAve": {"exit:west": ["ZetaPark", Vector2i(45, 11)], "exit:east": ["Cognizo", Vector2i(2, 11)], "door:Fargona": ["Fargona", Vector2i(20, 17)]},
	"Fargona": {"exit:south": ["ParkAve", Vector2i(20, 4)]},
	"DornerFlat": {"exit": ["Lamplight", Vector2i(41, 10)]},
	"Cognizo": {"exit:west": ["ParkAve", Vector2i(37, 8)], "exit:south": ["RailCut", Vector2i(37, 3)],
		"door:CognizoStation": ["CognizoStation", Vector2i(2, 8)]},
	"RailCut": {"exit:east": ["Cognizo", Vector2i(45, 17)], "exit:west": ["Southtown", Vector2i(48, 7)], "exit:south": ["RedRock", Vector2i(53, 12)]},
	"CognizoStation": {"exit": ["Cognizo", Vector2i(24, 10)], "exit:redrock": ["RedRock", Vector2i(5, 17)]},
	"RedRock": {"exit:subway": ["CognizoStation", Vector2i(26, 8)], "exit:east": ["RailCut", Vector2i(37, 13)],
		"door:Casino": ["Casino", Vector2i(10, 10)], "door:Lushon": ["Lushon", Vector2i(11, 10)], "door:Arcade": ["Arcade", Vector2i(14, 11)]},
	"Casino": {"exit": ["RedRock", Vector2i(8, 9)]},
	"Arcade": {"exit": ["RedRock", Vector2i(50, 9)]},
	"Lushon": {"exit": ["RedRock", Vector2i(23, 9)]},
	"CanalWalk": {"exit:north": ["Lamplight", Vector2i(20, 17)], "exit:south": ["Park", Vector2i(3, 14)]},
	"Underpass": {"exit:north": ["Spine", Vector2i(35, 19)], "exit:south": ["Southtown", Vector2i(3, 6)]},
	"Flyover": {"exit:south": ["Spine", Vector2i(21, 10)], "exit:north": ["Heights", Vector2i(23, 17)]},
	"Heights": {"exit:south": ["Flyover", Vector2i(12, 2)], "exit:west": ["HillRoad", Vector2i(37, 7)],
		"door:Home": ["Home", Vector2i(3, 14)]},
	"HillRoad": {"exit:east": ["Heights", Vector2i(2, 11)], "door:Hospital": ["Hospital", Vector2i(3, 13)]},
	"Apartment": {"exit": ["Lamplight", Vector2i(8, 10)]},
	"Park": {"exit": ["CanalWalk", Vector2i(20, 13)]},
	"Home": {"exit": ["Heights", Vector2i(17, 10)]},
	"WarRoom": {"exit": ["Spine", Vector2i(35, 10)]},
	"Hospital": {"exit": ["HillRoad", Vector2i(4, 7)]},
	"Southtown": {"exit": ["Underpass", Vector2i(20, 13)], "exit:east": ["RailCut", Vector2i(2, 12)],
		"exit:south": ["RestrictedRoad", Vector2i(2, 8)], "door:Factory": ["Factory", Vector2i(12, 14)]},
	"RestrictedRoad": {"exit:west": ["Southtown", Vector2i(47, 17)], "exit:east": ["Desert", Vector2i(3, 11)]},
	"Desert": {"exit:west": ["RestrictedRoad", Vector2i(37, 8)]},
	"Factory": {"exit": ["Southtown", Vector2i(21, 16)]},
	"LynxApartment": {"exit": ["ZetaPark", Vector2i(11, 10)], "drive": ["RestrictedRoad", Vector2i(2, 8)]},
	"Mirror": {"beyond": ["LabHall", Vector2i(12, 10)]},
	"LabHall": {"lift": ["LabOffice", Vector2i(9, 3)]},
	"LabOffice": {"stairs": ["LabPens", Vector2i(3, 3)]},
	"LabPens": {"stairs_down": ["Hangar", Vector2i(3, 4)]},
	"Hangar": {"exit:east": ["Spine", Vector2i(35, 10)]},
}

## Where the company car parks in each district, for fast travel.
const CAR_SPOTS := {"Spine": Vector2i(15, 15), "Heights": Vector2i(16, 14), "Lamplight": Vector2i(8, 10), "ZetaPark": Vector2i(11, 10), "Cognizo": Vector2i(10, 15), "RedRock": Vector2i(46, 16)}

## Interiors that are not plot beats: their doors are always open.
## Street exits that only open once the plot has reached them: map -> exit id -> [flag, line].
const EXIT_GATES := {
	"RestrictedRoad": {"exit:east": ["lynx_apartment_done", "The flats. Sand to the horizon, the checkpoint logging every step, and nothing out there I had a reason for. Not yet."]},
}

const SIDE_INTERIORS := ["CognizoStation", "Factory", "DornerFlat", "Casino", "Lushon", "Arcade"]

## Places that open only once a flag is set: target -> [flag, what Carl thinks at the door].
const GATES := {
	"DornerFlat": ["case_dorner", "A tower like the others. Nobody here I had business with."],
	"Fargona": ["case_dorner_charger", "Steps up to Fargona Avenue. Screens, and singing, and a line of people with their heads back. Not my street tonight.", "night"],
}

## Outdoor maps. Anything else is an interior.
const STREETS := ["Lamplight", "Spine", "ZetaPark", "CanalWalk", "Underpass", "Flyover", "Heights", "HillRoad", "Cognizo", "RailCut", "ParkAve", "Southtown", "RestrictedRoad", "Fargona", "RedRock"]

const PLACE_NAMES := {
	"Apartment": "the Lamplight, Dufredy's building", "Park": "Harmony Green", "Home": "home",
	"WarRoom": "Psyonic HQ, the tower", "Hospital": "SalTech hospital", "Southtown": "Southwest Station",
	"LynxApartment": "Lynx's building", "Lamplight": "Lamplight", "Spine": "the Spine, downtown",
	"ZetaPark": "Zeta and Park", "CanalWalk": "Canal Walk", "Underpass": "the Underpass",
	"Flyover": "the Flyover", "Heights": "the Heights", "HillRoad": "Hill Road",
	"Cognizo": "Cognizo Quarter", "CognizoStation": "Cognizo Station", "RailCut": "the Rail Cut", "ParkAve": "Park Avenue",
	"RestrictedRoad": "the Restricted Road", "Desert": "the sand flats", "Factory": "the factory",
	"Fargona": "Fargona Avenue", "DornerFlat": "Dorner's flat",
	"RedRock": "Red Rock Plaza", "Casino": "the casino on Red Rock Plaza", "Lushon": "Lushon Tavern", "Arcade": "the arcade under Red Rock Plaza",
	"Mirror": "the mirror chamber", "LabHall": "the facility, entrance hall", "LabOffice": "the facility, Sublevel 1", "LabPens": "the facility, Sublevel Two", "Hangar": "the hangar under the facility",
}

## What the objective line says to take, per map and exit.
const HINTS := {
	"Lamplight": {"exit:east": "East along the street to the Spine.", "exit:south": "The canal steps, bottom of the street.", "door:Apartment": "The grey building with the posters.", "door:DornerFlat": "The far tower, east end."},
	"Fargona": {"exit:south": "The steps down, bottom of the street, back to Park Avenue."},
	"Spine": {"exit:west": "West along the boulevard to Lamplight.", "exit:east": "East along the boulevard to Zeta and Park.", "exit:south": "The underpass stairs, bottom of the plaza.", "exit:north": "The flyover ramp, the red building west of the tower.", "door:WarRoom": "The tower, centre of the boulevard."},
	"Flyover": {"exit:north": "Up the ramp to the Heights.", "exit:south": "Down the ramp to the Spine."},
	"Heights": {"exit:south": "The ramp down, bottom of the street.", "exit:west": "West along Hill Road.", "door:Home": "The red house, middle of the street."},
	"HillRoad": {"exit:east": "East, back up to the Heights.", "door:Hospital": "The SalTech gate at the west end."},
	"ZetaPark": {"exit:west": "West, back to the Spine.", "exit:east": "East along Park Avenue.", "door:LynxApartment": "The red building with the red eye beside it."},
	"ParkAve": {"exit:west": "West, back to Zeta and Park.", "exit:east": "East into Cognizo Quarter.", "door:Fargona": "The steps in the top wall, middle of the avenue."},
	"Cognizo": {"exit:west": "West along Park Avenue.", "exit:south": "The steps down to the rail cut, bottom right.", "door:CognizoStation": "The dark building in the middle: the subway."},
	"RailCut": {"exit:east": "East along the cutting to Cognizo.", "exit:west": "West along the cutting to Southwest Station.", "exit:south": "The steps down at the bottom right, to Red Rock Plaza."},
	"RedRock": {"exit:east": "East, out of the plaza to the rail cut.", "exit:subway": "The subway stairs, bottom left.", "door:Casino": "The casino, west end of the plaza.", "door:Lushon": "Lushon's, under the red lanterns.", "door:Arcade": "The club stairs at the east end of the plaza, down."},
	"CognizoStation": {"exit": "The stairs up, left.", "exit:redrock": "The Red Rock line, far end of the platform."},
	"Southtown": {"exit": "The station front, bottom left, back to the Underpass.", "exit:east": "East, out along the rail cut.", "exit:south": "South past the overpass, the restricted road.", "door:Factory": "The factory, the red brick in the middle."},
	"RestrictedRoad": {"exit:west": "West, back to Southtown.", "exit:east": "East, into the flats."},
	"CanalWalk": {"exit:north": "North, up the steps to Lamplight.", "exit:south": "South along the canal to the park."},
	"Underpass": {"exit:north": "North, up the stairs to the Spine.", "exit:south": "South, out to Southtown."},
}


## Breadth-first search from one map to another. Returns the exit ids to take, in order.
static func route(from: String, to: String) -> Array:
	if from == to:
		return []
	var prev := {from: ["", ""]}
	var queue := [from]
	while not queue.is_empty():
		var cur: String = queue.pop_front()
		for exit_id in EXITS.get(cur, {}):
			var nxt: String = EXITS[cur][exit_id][0]
			if nxt in prev:
				continue
			prev[nxt] = [cur, exit_id]
			if nxt == to:
				var path := []
				var at := to
				while prev[at][0] != "":
					path.push_front(prev[at][1])
					at = prev[at][0]
				return path
			queue.append(nxt)
	return []


static func hint(map: String, exit_id: String) -> String:
	return HINTS.get(map, {}).get(exit_id, "")


static func place(map: String) -> String:
	return PLACE_NAMES.get(map, map)
