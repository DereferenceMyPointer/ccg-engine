extends Container
class_name CardContainer

## Cool use case: open one of these dynamically for selecting cards (like master duel)
@export_category("Details")
@export var zone: GameState.Zone
@export var flip := false

@export_category("Config")
@export var max_card_rotation: float = 20
@export var maximum_separation: int = 128
@export var vertical_scale: int = 8
@export var tween_time: float = 0.1
@export var rows: int = 1 # TODO: Implement this

@export_category("Requisites")
@export var card_ui: PackedScene
@export var default_spawn: Node2D

func populate(state: GameState, index: int):
	print("Fetching cards in player ", index, "'s ", zone)
	var existing_cards: Array[CardData] = []
	for child: CardUI in get_children():
		if not state.get_player_zone(index, zone).has(child.referenced_card):
			child.queue_free()
		else:
			existing_cards.append(child.referenced_card)
			child.chosen = false
			child.img.scale = Vector2(child.scale_params.x, child.scale_params.x)
	# TODO: Make opponent's hand hidden and without play listeners
	for card in state.get_player_zone(index, zone):
		if existing_cards.has(card): continue
		var ui: CardUI = card_ui.instantiate()
		ui.initialize(card, state)
		add_child(ui)
		ui.global_position = default_spawn.global_position
		if flip:
			ui.img.rotate(PI)
	await get_tree().process_frame
	await set_locations()
	for ui: CardUI in get_children():
		ui.selected.connect(func(card: CardData):
			_select_card_hook(card, state, index))
		ui.alt_selected.connect(func(card: CardData):
			_alt_select_card_hook(card, state, index))

func set_locations():
	# If board: leave cards in original position for a beat for clear communication
	if zone == GameState.Zone.Field:
		await get_tree().create_timer(tween_time * 4).timeout
	var children: Array = get_children()
	var center = children.size() / 2.0
	var center_point = size / 2
	var separation = mini(maximum_separation, size.x / (children.size() + 1))
	# Waiting only for the final tween since they're all the same and there shouldn't be any issues
	# even if some cards finish tweening later
	# Sanity check: if the last_tween node gets removed somehow this might never finish
	var last_tween: Tween
	for index in children.size():
		if children[index].is_queued_for_deletion():
			continue
		# Want to offset each card from the center based on its position in the array
		# Also want to rotate based on distance from center
		var card_offset = index - center
		var target_position = center_point + Vector2(card_offset * separation, abs(card_offset + 0.5) * vertical_scale)
		var target_rotation = (card_offset + 0.5) / children.size() * max_card_rotation
		var tween = get_tree().create_tween()
		tween.set_parallel()
		tween.tween_property(children[index], "position", target_position, tween_time)
		tween.tween_property(children[index], "rotation_degrees", target_rotation, tween_time)
		last_tween = tween
	if last_tween: await last_tween.finished
	print("Passed location set (CardContainer)")

func _select_card_hook(card: CardData, state: GameState, index: int):
	pass

func _alt_select_card_hook(card: CardData, state: GameState, index: int):
	# Should make this display by default
	pass
