extends Action
class_name PlayCardAction

static func Create(_source: CardData, _result: ActionResult = ActionResult.Empty()) -> Action:
	var out := PlayCardAction.new()
	out.source = _source
	out.result = _result
	return out

func resolve(state: GameState, result: ActionResult = ActionResult.Empty()):
	# Find the hand to play the card from and play the card for that player
	var index: int = 0
	for i in state.players.size():
		for j in state.players[i].hand.size():
			if state.players[i].hand[j] == source and state.players[i].mana >= source.cost:
				state.players[i].hand.remove_at(j)
				state.players[i].field.append(source)
				state.players[i].mana -= source.cost
				print("Card played, new player mana: ", state.players[i].mana)
				break
	super(state, result)
