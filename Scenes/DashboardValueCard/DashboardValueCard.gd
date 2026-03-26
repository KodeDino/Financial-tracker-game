extends NinePatchRect

@onready var title: Label = $Title
@onready var value: Label = $Value

@export var title_param: String 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title.text = title_param

func set_value(newValue: float) -> void:
	value.text = "$" + str(snapped(newValue, 0.01))
