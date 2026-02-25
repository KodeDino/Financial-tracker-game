extends Control

var investments: Array[Investment] = []

@onready var v_box_container: VBoxContainer = $ScrollContainer/MarginContainer/VBoxContainer
@onready var popup: Control = $Popup

const INVESTMENT_CARD = preload("uid://bmhpiel1ax4rp")

func _ready() -> void:
	var saved_investments: Array[Investment] = DataManager.load_investments()
	for investment in saved_investments:
		var investment_card: InvestmentCard = INVESTMENT_CARD.instantiate()
		investment_card.start_date = investment.start_date
		investment_card.end_date = investment.get_end_date()
		investment_card.type = investment.type
		investment_card.rate = investment.rate
		investment_card.amount = investment.amount
		investment_card.actual_value = investment.actual_cost
		investment_card.interest_earned = investment.get_interest_earned()
		investment_card.matured_value = investment.get_matured_value()
		investment_card.is_active = investment.get_status()
		v_box_container.add_child(investment_card)


func _on_add_button_pressed() -> void:
	popup.show()
