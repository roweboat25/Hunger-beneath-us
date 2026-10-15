class_name World
## The map of Silico: which exit of which map leads where, and where Carl
## lands when he arrives. Streets and routes are open; interiors only open
## when they are the next plot beat (see StreetScene).

## map -> exit id -> [target map, spawn tile in the target]
const EXITS := {
	"Lamplight": {"exit:east": ["Spine", Vector2i(2, 11)], "exit:south": ["CanalWalk", Vector2i(20, 2)],
		"door:Apartment": ["Apartment", Vector2i(3, 13)]},
	"Spine": {"exit:west": ["Lamplight", Vector2i(45, 11)], "exit:east": ["ZetaPark", Vector2i(2, 11)],
		"exit:south": ["Underpass", Vector2i(20, 2)], "door:WarRoom": ["WarRoom", Vector2i(14, 14)],
		"door:Home": ["Home", Vector2i(3, 14)], "door:Hospital": ["Hospital", Vector2i(3, 13)]},
	"ZetaPark": {"exit:west": ["Spine", Vector2i(61, 11)], "door:LynxApartment": ["LynxApartment", Vector2i(3, 13)]},
	"CanalWalk": {"exit:north": ["Lamplight", Vector2i(20, 17)], "exit:south": ["Park", Vector2i(3, 14)]},
	"Underpass": {"exit:north": ["Spine", Vector2i(35, 19)], "exit:south": ["Southtown", Vector2i(3, 6)]},
	"Apartment": {"exit": ["Lamplight", Vector2i(8, 10)]},
	"Park": {"exit": ["CanalWalk", Vector2i(20, 13)]},
	"Home": {"exit": ["Spine", Vector2i(21, 10)]},
	"WarRoom": {"exit": ["Spine", Vector2i(35, 10)]},
	"Hospital": {"exit": ["Spine", Vector2i(50, 10)]},
	"Southtown": {"exit": ["Underpass", Vector2i(20, 13)]},
	"LynxApartment": {"exit": ["ZetaPark", Vector2i(11, 10)]},
}

## Outdoor maps. Anything else is an interior.
const STREETS := ["Lamplight", "Spine", "ZetaPark", "CanalWalk", "Underpass"]

const PLACE_NAMES := {
	"Apartment": "the Lamplight, Dufredy's building", "Park": "Harmony Green", "Home": "home",
	"WarRoom": "Psyonic HQ, the tower", "Hospital": "SalTech hospital", "Southtown": "Southwest Station",
	"LynxApartment": "Lynx's building", "Lamplight": "Lamplight", "Spine": "the Spine, downtown",
	"ZetaPark": "Zeta and Park", "CanalWalk": "Canal Walk", "Underpass": "the Underpass",
}

## What the objective line says to take, per map and exit.
const HINTS := {
	"Lamplight": {"exit:east": "East along the street to the Spine.", "exit:south": "The canal steps, bottom of the street.", "door:Apartment": "The grey building with the posters."},
	"Spine": {"exit:west": "West along the boulevard to Lamplight.", "exit:east": "East along the boulevard to Zeta and Park.", "exit:south": "The underpass stairs, bottom of the plaza.", "door:WarRoom": "The tower, centre of the boulevard.", "door:Home": "The flyover ramp, the red building west of the tower.", "door:Hospital": "The shuttle stop, the grey building east of the tower."},
	"ZetaPark": {"exit:west": "West, back to the Spine.", "door:LynxApartment": "The red building with the red eye beside it."},
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
