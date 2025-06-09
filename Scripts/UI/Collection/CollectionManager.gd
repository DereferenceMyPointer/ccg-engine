extends Node2D
class_name CollectionManager

@export var default_profile: PlayerProfile
@onready var menu_scene: PackedScene = load("res://Scenes/UI/main_menu.tscn")
@onready var profile: PlayerProfile = load(profile_string)
@onready var deck_select: DeckSelectionView = $DeckSelection
@onready var deck_builder = $DeckBuilder # TODO: type
@onready var exit_button: Button = $Exit

const profile_string = "user://profile.tres"

enum Mode {
	DeckSelection,
	DeckView
}

var state: Mode = Mode.DeckSelection

func _ready():
	exit_button.pressed.connect(exit)
	deck_select.profile_updated.connect(update_profile)
	if profile:
		print("Loading existing user profile: ", profile.username)
		print(profile.decks)
		deck_select.load_profile(profile)
		print("Finished loading user profile.")
	else:
		print("Loading default profile: ", default_profile.username)
		profile = default_profile
		ResourceSaver.save(profile, profile_string)
		deck_select.load_profile(profile)
		print("Finished loading default profile.")
	deck_select.deck_selected.connect(open_deck_builder)

func open_deck_builder(deck: Deck):
	ResourceSaver.save(profile, profile_string)
	state = Mode.DeckView
	deck_select.visible = false
	deck_builder.visible = true

func update_profile():
	ResourceSaver.save(profile, profile_string)

func exit():
	update_profile()
	match state:
		Mode.DeckSelection:
			add_sibling(menu_scene.instantiate())
			queue_free()
		Mode.DeckView:
			state = Mode.DeckSelection
			deck_select.visible = true
			deck_builder.visible = false
			deck_select.load_profile(profile)
