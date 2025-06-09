extends Resource
class_name GameParams

@export var start_hand_size: int = 5
@export var max_hand_size: int = 6
@export var turn_mana_available: Array[int] = [
	3, 4, 4, 5
]

static func Default() -> GameParams:
	return GameParams.new()
