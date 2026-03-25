class_name Goal
extends Resource

@export var id: String
@export var target_amount: float
@export var completed_date: String

func to_dict() -> Dictionary:
	return {
		"id": id,
		"target_amount": target_amount,
		"completed_date": completed_date
	  }

static func from_dict(dict: Dictionary) -> Goal:
	var goal = Goal.new()
	var id_val = dict.get("id", "")
	if id_val == "":
		id_val = str((dict.get('completed_date', "") + str(dict.get("target_amount", 0.0))).hash())
	goal.id = id_val
	goal.target_amount = dict.get("target_amount", 0.0)
	goal.completed_date = dict.get("completed_date", "")
	return goal
