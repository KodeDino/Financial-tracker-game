extends Control

@onready var reinvested_margin_container: MarginContainer = $Modal/ReinvestedMarginContainer
@onready var modal: NinePatchRect = $Modal
@onready var radio_button: Control = $Modal/RadioButtonMarginContainer/RadioButton
@onready var amount_label: Label = $Modal/FirstInputMarginContainer/VBoxContainer/FirstInputLabels/AmountLabel
@onready var face_value_label: Label = $Modal/FirstInputMarginContainer/VBoxContainer/FirstInputLabels/FaceValueLabel
@onready var rate_label: Label = $Modal/SecondInputMarginContainer/VBoxContainer/SecondInputLabels/RateLabel
@onready var actual_cost_label: Label = $Modal/SecondInputMarginContainer/VBoxContainer/SecondInputLabels/ActualCostLabel
@onready var year_picker: Control = $Modal/YearPicker
@onready var month_picker: Control = $Modal/MonthPicker
@onready var day_picker: Control = $Modal/DayPicker

const OFFSITE_ADJUSTMENT = 40

var date_dict: Dictionary[String, int]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var today = Time.get_datetime_dict_from_system()
	date_dict = { "year": today['year'], "month": today['month'], "day": today['day'] }
	signal_setup()

func _on_checkbox_toggled(toggled_on: bool) -> void:
	if toggled_on:
		reinvested_margin_container.show()
		modal.offset_top -= OFFSITE_ADJUSTMENT 
		modal.offset_bottom += OFFSITE_ADJUSTMENT
	else:
		reinvested_margin_container.hide()
		modal.offset_top += OFFSITE_ADJUSTMENT
		modal.offset_bottom -= OFFSITE_ADJUSTMENT


func _on_cancel_button_pressed() -> void:
	hide()

func _on_type_changed(type: String) -> void:
	if type == 'cd':
		show_hide_cd_labels(true)
		show_hide_tbill_labels(false)
	elif type == 'tbill':
		show_hide_cd_labels(false)
		show_hide_tbill_labels(true)
		

func show_hide_cd_labels(show: bool) -> void:
	if show:
		amount_label.show()
		rate_label.show()
	else:
		amount_label.hide()
		rate_label.hide()
		

func show_hide_tbill_labels(show: bool) -> void:
	if show:
		face_value_label.show()
		actual_cost_label.show()
	else:
		face_value_label.hide()
		actual_cost_label.hide()


func signal_setup() -> void:
	radio_button.type_changed.connect(_on_type_changed)
	year_picker.value_changed.connect(_date_updater)
	month_picker.value_changed.connect(_date_updater)
	day_picker.value_changed.connect(_date_updater)
	

func _date_updater(date_type: String, value: int) -> void:
	date_dict[date_type] = value
	if date_type == 'year' or date_type == 'month':
		var max_days = get_max_days(date_dict['year'], date_dict['month'])
		day_picker.set_max(max_days)
		date_dict['day'] = day_picker.values[day_picker.current_index]


func get_max_days(year: int, month: int) -> int:
	# Days in each month, 1-indexed (index 0 unused)
	var days_in_month = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	if month == 2 and _is_leap_year(year):
		return 29
	return days_in_month[month]

func _is_leap_year(year: int) -> bool:
	return (year % 4 == 0 and year % 100 != 0) or (year % 400 == 0)

func _on_submit_button_pressed() -> void:
	var max_days = get_max_days(date_dict['year'], date_dict['month'])
	date_dict['day'] = mini(date_dict['day'], max_days)
	print("date_dict: ", date_dict)
