extends Action
class_name Effect

@export var types: Array[CardData.EffectTypes]

func is_of_type(type: CardData.EffectTypes):
	return types.has(type)

func is_requirement_fulfilled(ctx: GameState):
	return true
