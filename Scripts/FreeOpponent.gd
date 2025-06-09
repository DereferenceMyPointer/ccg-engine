extends Resource
class_name FreeOpponent

@export var deck: Deck
var index: int

func add_to_game(game: GamePlayer, state: GameState, _index: int):
	index = _index
	state.players[index].priority_received.connect(func(_state):
		await game.get_tree().process_frame
		pass_back(_state))

func pass_back(state: GameState):
	print("Opponent passing back...")
	state.players[index].action_taken.emit(PassAction.new())
