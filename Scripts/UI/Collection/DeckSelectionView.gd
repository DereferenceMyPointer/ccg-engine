extends Area2D
class_name DeckSelectionView

@export var columns: int = 4
@export var separation: Vector2i = Vector2i(512, 512)
@export var deck_scene: PackedScene
@export var new_deck_scene: PackedScene
var loaded_decks: Array[ClickableArea]

signal deck_selected(deck: Deck)
signal profile_updated

func load_profile(profile: PlayerProfile):
	for deck in loaded_decks:
		deck.queue_free()
	loaded_decks.clear()
	for i in profile.decks.size():
		print("Loading deck: ", profile.decks[i].title)
		var deck = deck_scene.instantiate() as ClickableArea
		deck.selected.connect(func(): deck_select(profile.decks[i]))
		# TODO: HACKY. Replace with functionality in Builder
		deck.alt_selected.connect(func():
			profile.decks.remove_at(i)
			profile_updated.emit()
			load_profile(profile)
		)
		add_child(deck)
		deck.position = get_pos(i) * separation
		deck.title.text = profile.decks[i].title
		loaded_decks.append(deck)
	var new_deck = new_deck_scene.instantiate() as ClickableArea
	add_child(new_deck)
	new_deck.selected.connect(func():
		add_deck_and_edit(profile)
	)
	new_deck.position = get_pos(profile.decks.size()) * separation
	new_deck.title.text = "Add Deck"
	loaded_decks.append(new_deck)

func deck_select(deck: Deck):
	deck_selected.emit(deck)

func get_pos(index: int) -> Vector2i:
	var row = index / columns
	var column = index % columns
	return Vector2i(column, row)

func add_deck_and_edit(profile: PlayerProfile):
	var deck := Deck.new()
	profile.decks.append(deck)
	deck_select(deck)
