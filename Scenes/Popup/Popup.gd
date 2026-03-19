extends Control

signal investment_submitted(investment: Investment)

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
@onready var amount_face_value_input_field_line_edit: Control = $Modal/FirstInputMarginContainer/VBoxContainer/AmountFaceValueInputField/LineEdit
@onready var rate_actual_cost_input_field_line_edit: Control = $Modal/SecondInputMarginContainer/VBoxContainer/RateActualCostInputField/LineEdit
@onready var reinvested_input_field_line_edit: Control = $Modal/ReinvestedMarginContainer/VBoxContainer/ReinvestedInputField/LineEdit
@onready var checkbox: TextureButton = $Modal/CheckboxMarginContainer/HBoxContainer/Checkbox


const OFFSITE_ADJUSTMENT = 40

var investment_type: String = 'cd'
var date_dict: Dictionary[String, int]
var input_values: Dictionary[String, float]
var is_checkbox_checked: bool = false

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
		is_checkbox_checked = true
	else:
		reinvested_margin_container.hide()
		modal.offset_top += OFFSITE_ADJUSTMENT
		modal.offset_bottom -= OFFSITE_ADJUSTMENT
		is_checkbox_checked = false


func _on_cancel_button_pressed() -> void:
	clear_form()
	hide()
	

func clear_form() -> void:
	var today = Time.get_datetime_dict_from_system()
	year_picker.set_value(today['year'])
	month_picker.set_value(today['month'])
	day_picker.set_value(today['day'])
	date_dict = { "year": today['year'], "month": today['month'], "day": today['day'] }
	input_values.clear()
	radio_button.reset()
	_on_type_changed('cd')


func clear_out_inputs() -> void:
	amount_face_value_input_field_line_edit.text = ""
	rate_actual_cost_input_field_line_edit.text = ""
	reinvested_input_field_line_edit.text = ""
	checkbox.button_pressed = false
	

func _on_type_changed(type: String) -> void:
	input_values.clear()
	clear_out_inputs()
	if type == 'cd':
		show_hide_cd_labels(true)
		show_hide_tbill_labels(false)
		investment_type = 'cd'
	elif type == 'tbill':
		show_hide_cd_labels(false)
		show_hide_tbill_labels(true)
		investment_type = 'tbill'

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
	if investment_type == "cd":
		input_values['amount'] = float(amount_face_value_input_field_line_edit.text)
		input_values['rate'] = float(rate_actual_cost_input_field_line_edit.text)
	elif investment_type == "tbill":
		input_values['face_value'] = float(amount_face_value_input_field_line_edit.text)
		input_values['actual_value'] = float(rate_actual_cost_input_field_line_edit.text)
		
	if is_checkbox_checked:
		input_values['reinvested_amount'] = (float(reinvested_input_field_line_edit.text))
	
	var start_date = "%04d-%02d-%02d" % [date_dict['year'], date_dict['month'], date_dict['day']]

	var investment = Investment.new()
	investment.id = str(Time.get_unix_time_from_system())
	investment.start_date = start_date
	investment.type = investment_type

	if investment_type == "cd":
		investment.amount = input_values['amount']
		investment.rate = input_values['rate']
	elif investment_type == "tbill":
		investment.amount = input_values['face_value']
		investment.actual_cost = input_values['actual_value']

	investment.reinvested_amount = input_values.get('reinvested_amount', 0.0)

	var investments = DataManager.load_investments()
	investments.append(investment)
	DataManager.save_investments(investments)

	investment_submitted.emit(investment)
	clear_form()
	hide()
