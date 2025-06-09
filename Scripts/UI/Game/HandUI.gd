extends CardContainer
class_name HandUI

@export var player_index: int
# @onready var hidden_card: PackedScene * TODO! *

func _ready():
	set_locations()

func _select_card_hook(card: CardData, state: GameState, index: int):
	print("Select callback")
	state.players[index].action_taken.emit(PlayCardAction.Create(card))
