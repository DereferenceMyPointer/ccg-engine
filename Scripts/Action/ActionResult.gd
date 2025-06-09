extends RefCounted
class_name ActionResult

var selected_cards: Array[CardData]
var selected_players: Array[int]
var selected_actions: Array[Action]

## Maybe do it like this for the UI?
var destroyed_cards: Array[CardData]
var banished_cards: Array[CardData]
var drawn_cards: Array[CardData]
var added_from_deck_cards: Array[CardData]
var added_from

static func Empty() -> ActionResult:
	return ActionResult.new()

func withSource(index: int) -> ActionResult:
	var out = ActionResult.new()
	out.source_player_index = index
	return out
