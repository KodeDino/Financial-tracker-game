extends Control

@onready var v_box_container: VBoxContainer = $ScrollContainer/MarginContainer/VBoxContainer
@onready var popup: Control = $Popup

const INVESTMENT_CARD = preload("uid://bmhpiel1ax4rp")

func _ready() -> void:
	popup.investment_submitted.connect(_on_investment_submitted)
	var saved_investments: Array[Investment] = DataManager.load_investments()
	for investment in saved_investments:
		v_box_container.add_child(_create_card(investment))
	_sort_cards()

func _create_card(investment: Investment) -> InvestmentCard:
	var card: InvestmentCard = INVESTMENT_CARD.instantiate()
	card.start_date = investment.start_date
	card.end_date = investment.get_end_date()
	card.type = investment.type
	card.rate = investment.rate
	card.amount = investment.amount
	card.actual_value = investment.actual_cost
	card.interest_earned = investment.get_interest_earned()
	card.matured_value = investment.get_matured_value()
	card.is_active = investment.get_status()
	card.id = investment.id
	card.remove_requested.connect(_on_remove_requested)
	return card

func _sort_cards() -> void:
	var cards = v_box_container.get_children()
	cards.sort_custom(func(a, b): return a.start_date > b.start_date)
	for i in cards.size():
		v_box_container.move_child(cards[i], i)

func _on_investment_submitted(investment: Investment) -> void:
	v_box_container.add_child(_create_card(investment))
	_sort_cards()

func _on_remove_requested(id: String, is_active: bool) -> void:
	if is_active:
		var investments = DataManager.load_investments()
		investments = investments.filter(func(inv): return inv.id != id)
		DataManager.save_investments(investments)

	for card in v_box_container.get_children():
		if card.id == id:
			card.queue_free()
			break

func _on_add_button_pressed() -> void:
	popup.show()
