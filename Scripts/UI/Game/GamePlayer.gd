extends Node2D
class_name GamePlayer

var state: GameState
@export var board: BoardUI
@export var mode: GameParams = GameParams.Default()

func new_game(player, opponent):
	state = GameState.create([player.deck, opponent.deck], mode)
	opponent.add_to_game(self, state, 1)
	board.setup(state)
	state.run()

func _unhandled_input(event: InputEvent):
	if state and event.is_action_pressed("Submit"):
		print("Player is passing...")
		state.players[0].action_taken.emit(PassAction.new())
