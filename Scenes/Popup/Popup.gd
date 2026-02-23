extends Control

@onready var reinvested_margin_container: MarginContainer = $Modal/ReinvestedMarginContainer
@onready var modal: NinePatchRect = $Modal
@onready var radio_button: Control = $Modal/RadioButtonMarginContainer/RadioButton
@onready var amount_label: Label = $Modal/FirstInputMarginContainer/VBoxContainer/FirstInputLabels/AmountLabel
@onready var face_value_label: Label = $Modal/FirstInputMarginContainer/VBoxContainer/FirstInputLabels/FaceValueLabel
@onready var rate_label: Label = $Modal/SecondInputMarginContainer/VBoxContainer/SecondInputLabels/RateLabel
@onready var actual_cost_label: Label = $Modal/SecondInputMarginContainer/VBoxContainer/SecondInputLabels/ActualCostLabel

const OFFSITE_ADJUSTMENT = 40

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	radio_button.type_changed.connect(_on_type_changed)


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
