class_name GoalCard
extends NinePatchRect

@onready var goal_name_label: Label = $GridContainer/GoalNameLabel
@onready var goal_value_label: Label = $GridContainer/GoalValueLabel

var goal_name: String = ''
var goal_value: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	goal_name_label.text = goal_name
	goal_value_label.text = '$' + str(goal_value)
