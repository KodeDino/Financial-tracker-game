extends Control

@onready var v_box_container: VBoxContainer = $ScrollContainer/MarginContainer/VBoxContainer

const HISTORICAL_GOAL_CARD = preload("uid://bicbctuv0w084")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var goals = DataManager.load_goals()
	for goal in goals:
		v_box_container.add_child(_create_card(goal))


func _create_card(goal: Goal) -> GoalCard:
	var goal_card: GoalCard = HISTORICAL_GOAL_CARD.instantiate()
	goal_card.goal_name = "Goal-" + goal.id 
	goal_card.goal_value = goal.target_amount
	return goal_card
