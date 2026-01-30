class_name InvestmentCard

extends NinePatchRect

const CARD_INACTIVE = preload("uid://8p36o5buxeaw")
const CARD_ACTIVE = preload("uid://dne8c8kj7rawq")

@onready var start_date_value_label: Label = $GeneralInfoGrid/StartDateValueLabel
@onready var end_date_value_label: Label = $GeneralInfoGrid/EndDateValueLabel
@onready var type_value_label: Label = $GeneralInfoGrid/TypeValueLabel
@onready var rate_value_label: Label = $GeneralInfoGrid/RateValueLabel
@onready var amount_value_label: Label = $AmountInfoGrid/AmountValueLabel
@onready var actual_value_label: Label = $AmountInfoGrid/ActualValueLabel
@onready var earned_value_label: Label = $AmountInfoGrid/EarnedValueLabel
@onready var final_value_label: Label = $AmountInfoGrid/FinalValueLabel

var start_date = ''
var end_date = ''
var type = ''
var rate = 0.0
var amount = 0.0
var actual_value = 0.0
var interest_earned = 0.0
var matured_value = 0.0
var is_active = true



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()
	if is_active:
		texture = CARD_ACTIVE
	else:
		texture = CARD_INACTIVE

func setup() -> void:
	start_date_value_label.text = start_date
	end_date_value_label.text = end_date
	type_value_label.text = type
	rate_value_label.text = str(rate) + '%'
	amount_value_label.text = '$' + str(amount)
	actual_value_label.text = '$' + str(actual_value)
	earned_value_label.text = '$' + str(interest_earned)
	final_value_label.text = '$' + str(matured_value)
