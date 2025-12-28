class_name Investment
extends Resource

@export var start_date: String
@export var type: String
# only for CD type
@export var rate: float
@export var amount: float
# only for tBill type
@export var actual_cost: float

func get_interest_earned() -> float:
	if type == "cd" && rate:
		return amount * (rate / 100) * (3.0 / 12.0)
	elif type == "tBill" && actual_cost:
		return amount - actual_cost
	else:
		return 0

func get_matured_value() -> float:
	if type == "cd":
		return amount + get_interest_earned()
	else:
		return amount
	
func get_status() -> bool:
	var today = Time.get_date_string_from_system(false)
	# compare if today > end date -> matured -> not active
	# compare if today < end_date -> not matured -> active
	return today < get_end_date()

func get_end_date() -> String:
	var date_dict = Time.get_datetime_dict_from_datetime_string(start_date + "T00:00:00", true)
	date_dict["month"] += 3
	if date_dict["month"] > 12:
		date_dict["month"] -= 12
		date_dict["year"] += 1
	var datetime_str = Time.get_datetime_string_from_datetime_dict(date_dict, true)
	return datetime_str.split("T")[0]
