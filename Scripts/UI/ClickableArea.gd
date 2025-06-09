extends Area2D
class_name ClickableArea

@onready var title = $Title

signal selected
signal alt_selected

var hovered := false

func _ready():
	mouse_entered.connect(func():
		hovered = true
	)
	mouse_exited.connect(func(): 
		hovered = false
	)

func _unhandled_input(event: InputEvent):
	if !hovered:
		return
	if event.is_action_released("Select"):
		selected.emit()
	if event.is_action_released("Alt Select"):
		alt_selected.emit()
