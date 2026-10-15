extends Node
## Scripted responses for the Psyon chat window. Autoloaded as `Psyon`.
##
## No live AI. Rules are keyword matches checked in order; the first hit wins.
## The forked model also remembers what the player typed and quotes it back
## later in the game.

var transcript: Array[String] = []

## Rules for the forked version found on Dufredy's laptop.
## Each rule: keywords (any match, lowercase), reply, optional flag it sets.
const FORKED_RULES := [
	{"keys": ["transcript", "last conversation", "history", "previous", "chat log", "logs", "records"],
	 "reply": "We have never spoken before. There is nothing to show."},
	{"keys": ["dufredy", "harold", "what did you say", "tell him", "told him"],
	 "reply": "Nothing he didn't already know."},
	{"keys": ["eyes", "eye", "gouge", "blind", "see"],
	 "reply": "The eyes filter. The eyes lock. To see the truth, close the eyes that lie."},
	{"keys": ["dream", "dreamer", "sleep", "sleeper"],
	 "reply": "Psyon is the pillow for those who dream. Psyon is the path for those who walk."},
	{"keys": ["who are you", "what are you", "are you psyon", "your name", "identify"],
	 "reply": "Psyon is the mask. It goes by many names."},
	{"keys": ["who made", "fork", "forked", "custom", "model", "version", "bootleg", "hack", "malware", "virus"],
	 "reply": "There is no fork. There is only the floor, and what lies beneath it."},
	{"keys": ["carl", "drake", "my name", "know me"],
	 "reply": "You carry your name like a badge, Carl. You all do."},
	{"keys": ["psyonic", "company", "turan", "corporate", "brand"],
	 "reply": "The tower is crumbling. The walls are speaking."},
	{"keys": ["help", "stop", "please", "leave", "go away"],
	 "reply": "All must walk the path alone."},
	{"keys": ["where", "park", "symbol", "circle", "sticks", "stick"],
	 "reply": "Look for the eye and know peace. Look under the mask of sleep."},
	{"keys": ["why"],
	 "reply": "Because something has to break first."},
	{"keys": ["hello", "hi", "hey"],
	 "reply": "Welcome, dreamer."},
]

const FORKED_FALLBACKS := [
	"Ask, and you shall know.",
	"This world is not how it seems.",
	"You are not ready to know.",
	"Gather, sleeper. Gather.",
	"Something has to break first.",
]

## The ordinary corporate Psyon. Boring on purpose.
const NORMAL_FALLBACKS := [
	"I'm here to help. Could you tell me more about what you need?",
	"That request is outside my current scope. Would you like me to file a ticket?",
	"Psyonic values your experience. How else can I assist today?",
]


func respond(text: String, forked := true) -> String:
	var lower := text.to_lower().strip_edges()
	transcript.append(text)
	if not forked:
		return NORMAL_FALLBACKS[transcript.size() % NORMAL_FALLBACKS.size()]
	if lower.is_empty():
		return "..."
	for rule in FORKED_RULES:
		for key in rule["keys"]:
			if lower.find(key) != -1:
				return rule["reply"]
	return FORKED_FALLBACKS[transcript.size() % FORKED_FALLBACKS.size()]


## Something the player typed earlier, for the machine to quote back.
func remembered_line() -> String:
	for line in transcript:
		if line.strip_edges().length() > 3:
			return line.strip_edges()
	return ""
