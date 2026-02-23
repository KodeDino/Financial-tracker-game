extends Control

signal value_changed(date_type: String, value: int)

@export var date_type: String

@onready var value_label: Label = $NinePatchRect/ValueLabel

const YEAR = 'year'
const MONTH = 'month'
const DAY = 'day'

var values: Array = []
var current_index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var today = Time.get_date_dict_from_system()
	if date_type == YEAR:
		var current_year = today["year"]
		setup_date(current_year - 10, current_year + 11, 10)
	elif date_type == MONTH:
		var current_month = today["month"]
		setup_date(1, 13, current_month - 1)
	elif date_type == DAY:
		var current_day = today["day"]
		setup_date(1, 32, current_day - 1)
	else:
		value_label.text = "Err"

func setup_date(start: int, end: int, current: int) -> void:
	for i in range(start, end):
		values.append(i)
	current_index = current
	update_label()


func _on_up_button_pressed() -> void:
	if current_index < values.size() - 1:
		current_index += 1
		update_label()
		value_changed.emit(date_type, values[current_index])


func _on_down_button_pressed() -> void:
	if current_index > 0:
		current_index -= 1
		update_label()
		value_changed.emit(date_type, values[current_index])


func update_label() -> void:
	value_label.text = str(values[current_index])
