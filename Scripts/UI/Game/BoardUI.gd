extends Node2D
class_name BoardUI

@export_category("Children")
@export var player_hand: CardContainer # Can actually combine these two and call by index for full flexibility
@export var opponent_hands: Array[CardContainer]
@export var fields: Array[CardContainer]
var is_populating := false

func setup(state: GameState):
	state.updated.connect(handle_update)

func handle_update(state: GameState):
	if is_populating:
		print("nah")
		return
	print("Board update")
	is_populating = true
	await update_hands(state)
	await update_field(state)
	await get_tree().process_frame
	is_populating = false
	print("Calling resume")
	state.resume()

func update_hands(state: GameState):
	print("Pre hand update")
	for i in opponent_hands.size():
		opponent_hands[i].populate(state, i + 1)
	await player_hand.populate(state, 0)
	print("Post hand update")

func update_field(state: GameState):
	for i in fields.size():
		await fields[i].populate(state, i)
