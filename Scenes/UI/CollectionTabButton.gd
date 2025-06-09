extends Button

@export var root: Control
@onready var to_load: PackedScene = load("res://Scenes/UI/collection_manager.tscn")

func _pressed():
	root.add_sibling(to_load.instantiate())
	root.queue_free()
