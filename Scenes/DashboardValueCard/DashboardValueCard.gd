extends NinePatchRect

@onready var title: Label = $Title
@onready var value: Label = $Value

@export var title_param: String
@export var value_param: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title.text = title_param
	value.text = value_param
