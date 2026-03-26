class_name InvestmentCard

extends NinePatchRect

const CARD_INACTIVE = preload("uid://8p36o5buxeaw")
const CARD_ACTIVE = preload("uid://dne8c8kj7rawq")

@onready var close_button: TextureButton = $TextureButton
@onready var start_date_value_label: Label = $GeneralInfoGrid/StartDateValueLabel
@onready var end_date_value_label: Label = $GeneralInfoGrid/EndDateValueLabel
@onready var type_value_label: Label = $GeneralInfoGrid/TypeValueLabel
@onready var rate_label: Label = $GeneralInfoGrid/RateLabel
@onready var rate_value_label: Label = $GeneralInfoGrid/RateValueLabel
@onready var amount_value_label: Label = $AmountInfoGrid/AmountValueLabel
@onready var actual_label: Label = $AmountInfoGrid/ActualLabel
@onready var actual_value_label: Label = $AmountInfoGrid/ActualValueLabel
@onready var earned_value_label: Label = $AmountInfoGrid/EarnedValueLabel
@onready var final_value_label: Label = $AmountInfoGrid/FinalValueLabel

var id: String = ''
var start_date = ''
var end_date = ''
var type = ''
var rate = 0.0
var amount = 0.0
var actual_value = 0.0
var interest_earned = 0.0
var matured_value = 0.0
var is_active = true

signal remove_requested(id: String, is_active: bool)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	close_button.pressed.connect(_on_close_button_pressed)
	setup()
	if is_active:
		texture = CARD_ACTIVE
	else:
		texture = CARD_INACTIVE

func _on_close_button_pressed() -> void:
	remove_requested.emit(id, is_active)

func setup() -> void:
	start_date_value_label.text = start_date
	end_date_value_label.text = end_date
	type_value_label.text = type
	amount_value_label.text = '$' + str(amount)
	earned_value_label.text = '$' + str(snapped(interest_earned, 0.01))
	final_value_label.text = '$' + str(snapped(matured_value, 0.01))

	if type == "cd":
		rate_label.show()
		rate_value_label.show()
		rate_value_label.text = str(rate) + '%'
		actual_label.hide()
		actual_value_label.hide()
	elif type == "tbill":
		actual_label.show()
		actual_value_label.show()
		actual_value_label.text = '$' + str(actual_value)
		rate_label.hide()
		rate_value_label.hide()
