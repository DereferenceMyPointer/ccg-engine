extends Button

@export var opponent: FreeOpponent
@export var root: Control
@export var game: PackedScene
@export var profile: PlayerProfile

func _on_pressed():
	var game_scene = game.instantiate() as GamePlayer
	root.visible = false
	root.add_sibling(game_scene)
	game_scene.new_game(profile, opponent)
