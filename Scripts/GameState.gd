extends RefCounted
class_name GameState

enum Phase {
	Start,
	Main,
	Combat,
	End
}

enum Zone {
	Hand,
	Field,
	Grave,
	Deck,
	Banish
}

var phases: Array[Phase] = [
	Phase.Start,
	Phase.Main,
	Phase.Combat,
	Phase.End
] # TODO: Game params struct (for game type modification)

var params: GameParams

var players: Array[PlayerState]
var turn_player: int

## -1 if neither player has priority
var priority_player: int

var turn_number: int = 0
var phase: Phase = Phase.Start

var stack: Array[Action] = []
var queued_triggers: Array[Action] = []

signal updated(state: GameState)
signal update_finished

## decks[0] is the player's deck
static func create(decks: Array[Deck], settings: GameParams = GameParams.Default()) -> GameState:
	var out := GameState.new()
	out.players = []
	out.params = settings
	for deck in decks:
		var player = PlayerState.Create(deck)
		out.players.append(player)
	out.turn_player = randi_range(0, decks.size() - 1)
	out.priority_player = out.turn_player
	return out

func get_player_zone(index: int, zone: Zone) -> Array[CardData]:
	match zone:
		Zone.Hand:
			return players[index].hand
		Zone.Field:
			return players[index].field
		Zone.Grave:
			return players[index].grave
		Zone.Deck:
			return players[index].deck
		Zone.Banish:
			return players[index].banishment
	return []

## Returns the winning player index
# -1 if draw
func run() -> int:
	for player in players:
		for i in range(params.start_hand_size):
			player.hand.append(player.deck.pop_back())
	await update()
	while !is_game_over():
		await take_turn()
		turn_player = next_turn_player()
		priority_player = turn_player
	return 0

## Make sure this actually works
func take_turn():
	print("Starting turn...")
	var this_action: Action
	players[turn_player].mana = params.turn_mana_available[mini(turn_number, params.turn_mana_available.size())]
	print("Player mana ", players[turn_player].mana)
	turn_number += 1
	if turn_number != 1:
		players[turn_player].draw(self, 1)
		print("Player hand ", turn_player, " ", players[turn_player].hand.size(), "turn ", turn_number)
		await update()
	## Turn
	for phase in phases:
		this_action = null
		while this_action is not PassAction:
			## Phase change
			while this_action is not PassAction:
				## Phase end check
				while this_action is not PassAction:
					## Stack
					this_action = await resolve_stack()
					print("Phase " + str(phase))
				priority_player = next_player()
				this_action = await resolve_stack()
			phase = next_phase()
			priority_player = turn_player
			this_action = await resolve_stack()
			priority_player = next_player()
			this_action = await resolve_stack()
	print(turn_number)

func resolve_stack() -> Action:
	stack.clear()
	players[priority_player].give_priority(self)
	var this_action: Action = await players[priority_player].action_taken
	stack.append(this_action)
	while this_action is not PassAction:
		priority_player = next_player()
		players[priority_player].give_priority(self)
		this_action = await players[priority_player].action_taken
		stack.append(this_action)
	stack.reverse()
	for action in stack:
		print(action is PlayCardAction)
		action.resolve(self)
		this_action = action
		await update()
		print("Stack resolved")
	stack.clear()
	priority_player = turn_player
	if queued_triggers.size() > 0:
		for action in queued_triggers:
			stack.append(action)
		this_action = await resolve_stack()
	return this_action

func is_game_over() -> bool:
	for player in players:
		if player.won:
			return true
	return false

func update():
	var temp = priority_player
	priority_player = -1
	updated.emit(self)
	# Hook in UI and wait for the update animations to occur?
	print("Pre update")
	await update_finished
	print("Post update")
	priority_player = temp

func resume():
	print("resume")
	update_finished.emit()

func next_player() -> int:
	return (priority_player + 1) % players.size()

func next_turn_player() -> int:
	return (turn_player + 1) % players.size()

func next_phase()-> Phase:
	return min(phase + 1, Phase.size() - 1)
