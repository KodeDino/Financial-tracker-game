class_name Investment
extends Resource

@export var id: String
@export var start_date: String
@export var type: String
# only for CD type
@export var rate: float
@export var amount: float
# only for tbill type
@export var actual_cost: float
@export var reinvested_amount: float

func to_dict() -> Dictionary:
	return {
		"id": id,
		"start_date": start_date,
		"type": type,
		"rate": rate,
		"amount": amount,
		"actual_cost": actual_cost,
		"reinvested_amount": reinvested_amount
	  }
	
static func from_dict(dict: Dictionary) -> Investment:
	var investment = Investment.new()
	var id_val = dict.get("id", "")
	if id_val == "":
		id_val = str((dict.get("start_date", "") + dict.get("type", "") + str(dict.get("amount", 0.0))).hash())
	investment.id = id_val
	investment.start_date = dict.get("start_date", "")
	investment.type = dict.get("type", "")
	investment.rate = dict.get("rate", 0.0)
	investment.amount = dict.get("amount", 0.0)
	investment.actual_cost = dict.get("actual_cost", 0.0)
	investment.reinvested_amount = dict.get("reinvested_amount", 0.0)
	return investment

func get_interest_earned() -> float:
	if type == "cd" && rate:
		var start_unix = Time.get_unix_time_from_datetime_string(start_date + "T00:00:00")
		var end_unix = Time.get_unix_time_from_datetime_string(get_end_date() + "T00:00:00")
		var days = round((end_unix - start_unix) / 86400.0)
		return amount * (rate / 100.0) * (days / 365.0)
	elif type == "tbill" && actual_cost:
		return amount - actual_cost
	else:
		return 0.0

func get_matured_value() -> float:
	if type == "cd":
		return amount + get_interest_earned()
	else:
		return amount

func get_fresh_principal() -> float:
	return amount - reinvested_amount
	
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
