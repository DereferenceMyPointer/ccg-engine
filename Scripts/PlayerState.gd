extends RefCounted
class_name PlayerState

signal action_taken(action: Action)
signal priority_received(state: GameState)

@export var won: bool = false
@export var hero: CardData
@export var deck: Array[CardData]
@export var hand: Array[CardData] = []
@export var field: Array[CardData] = []
@export var grave: Array[CardData] = []
@export var banishment: Array[CardData] = []

@export var health: int = 15
@export var mana: int = 0

static func Create(_deck: Deck) -> PlayerState:
	var out := PlayerState.new()
	for card in _deck.main:
		var copy = card.duplicate(true)
		out.deck.append(card.duplicate(true))
	out.deck.shuffle()
	return out

func give_priority(state: GameState):
	priority_received.emit(state)

func draw(state: GameState, num: int):
	for i in num:
		hand.append(deck.pop_back())
