extends Area2D
class_name CardUI

signal selected(card: CardData)
signal alt_selected(card: CardData)

@export var referenced_card: CardData
@export var img: Sprite2D
@onready var hitbox: CollisionShape2D = $Hitbox
var hovered: bool = false
var scale_params: Vector2 = Vector2(0.25, 0.25 * 1.25)
var chosen: bool = false

func _ready():
	refresh()
	mouse_entered.connect(func():
		hovered = true
		var tween = get_tree().create_tween()
		tween.tween_property(img, "scale", Vector2(scale_params.y, scale_params.y), 0.1)
	)
	mouse_exited.connect(func(): 
		hovered = false
		if not chosen:
			var tween = get_tree().create_tween()
			tween.tween_property(img, "scale", Vector2(scale_params.x, scale_params.x), 0.1)
	)

## Set image and info
## Hook into card effects from the UI here?
func initialize(card: CardData, state: GameState):
	referenced_card = card

func refresh():
	# Draw to the card
	if not referenced_card:
		return
	$Container/CardImage.texture = referenced_card.image
	$Container/Title.clear()
	$Container/PT.clear()
	$Container/Description.clear()
	$Container/Title.append_text(referenced_card.title)
	$Container/Cost.append_text(str(referenced_card.cost))
	$Container/Description.append_text(referenced_card.text)
	$Container/PT.append_text(str(referenced_card.power) + " / " + str(referenced_card.defense))

func _unhandled_input(event: InputEvent):
	if !hovered:
		return
	if event.is_action_released("Select"):
		selected.emit(referenced_card)
		var tween = get_tree().create_tween()
		tween.tween_property(img, "scale", Vector2(scale_params.y, scale_params.y), 0.1)
	if event.is_action_released("Alt Select"):
		alt_selected.emit(referenced_card)
		var tween = get_tree().create_tween()
		tween.tween_property(img, "scale", Vector2(scale_params.x, scale_params.x), 0.1)
		chosen = false
