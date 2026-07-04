extends Node
var fuel_count : float
var fuel_gain_rate : float
var fuel_lines : float
var fuel_line_gain : float
var number_of_clicks : float
# ID1 MODIFIERS
# This affects the rate at which fuel lines affect fuel gain from module 1
var ID1_data : ID1Data
var ID2_data : ID2Data
var ID3_data : ID3Data
var ID4_data : ID4Data
var ID5_data : ID5Data

var rand : RandomNumberGenerator

signal fuel_changed
signal fuel_lines_changed
signal fuel_crits_changed
signal crit_modifier_changed
signal tick_completed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Savables")
	rand = RandomNumberGenerator.new()
	fuel_changed.connect(self.every_time_fuel_changes)
	fuel_lines_changed.connect(self.every_time_fuel_lines_change)
	fuel_crits_changed.connect(self.every_time_crit_fuel_changes)
	crit_modifier_changed.connect(self.every_time_crit_multiplier_changes)
	tick_completed.connect(self.every_tick_completed)
	SceneHandler.sceneChanged.connect(self.reset_scene_vars)
	
func gain_fuel():
	var i = rand.randf_range(0,1)
	var crit_mod = 1
	if i <= ID2_data.critical_chance and ID2_data.crits_enabled:
		crit_mod = ID2_data.final_crit
		ID2_data.crits += ID2_data.crit_gain_mod * ID4_data.critical_fuel_gain_multiplier
		fuel_crits_changed.emit()
	
	fuel_count += fuel_gain_rate * (fuel_lines + 1) * ID1_data.fuel_line_mod * crit_mod * ID4_data.click_multiplier * ID5_data.rush_multiplier
	fuel_changed.emit()

func subtract_fuel(compared_value) -> bool:
	if fuel_count >= compared_value:
		fuel_count -= compared_value
		fuel_changed.emit()
		return true
	return false

func gain_lines():
	fuel_lines += pow(fuel_line_gain * ID1_data.fuel_line_mult, ID4_data.fuel_line_exponent)
	fuel_lines_changed.emit()
	
func subtract_lines(compared_value):
	if fuel_lines >= compared_value:
		fuel_lines -= compared_value
		fuel_lines_changed.emit()
		return true
	return false
	

func ID2_subtract_crits(compared_value):
	if ID2_data.crits >= compared_value:
		ID2_data.crits -= compared_value
		fuel_crits_changed.emit()
		return true
	return false

func ID1_fuel_gain_mod():
	ID1_data.fuel_line_mod += ID1_data.STEP_line_mod
	ID1_data.COST_fuel_line_mod *= ID1_data.COSTSTEP_fuel_line_mod
	
func ID1_fuel_line_gain_mult():
	ID1_data.fuel_line_mult += ID1_data.STEP_line_mult
	ID1_data.COST_fuel_line_mult *= ID1_data.COSTSTEP_fuel_line_mult
	
func ID1_fuel_line_gain_rate_up():
	ID1_data.fuel_line_gain_rate += ID1_data.STEP_line_gain_rate
	ID1_data.COST_line_gain_rate *= ID1_data.COSTSTEP_line_gain_rate
	
func ID2_calculate_final_crit():
	ID2_data.final_crit = 1 + (ID2_data.critical_modifier/pow((10 * ID2_data.critical_chance),2 - 2 * ID2_data.critical_chance))
	crit_modifier_changed.emit()
	return ID2_data.final_crit
	
func ID2_refine_crit_fuel():
	ID2_data.critical_modifier += ID2_data.STEP_fuel_critical_modifier
	ID2_data.COST_fuel_critical_modifier *= ID2_data.COSTSTEP_fuel_critical_modifier
	ID2_calculate_final_crit()
	
func ID2_refine_crit_crit():
	ID2_data.critical_modifier += ID2_data.STEP_crit_critical_modifier
	ID2_data.COST_crit_critical_modifier *= ID2_data.COSTSTEP_crit_critical_modifier
	ID2_calculate_final_crit()
	
func ID3_refine_fuel_per_second():
	var f = fuel_count
	if subtract_fuel(fuel_count):
		ID3_data.fuel_spent += f
		ID3_data.fuel_per_second = pow(ID3_data.fuel_spent,ID3_data.fuel_burn_strength) *  ID3_data.fuel_lines_per_second
	
func ID3_refine_fuel_lines_per_second():
	var f = fuel_lines
	if subtract_lines(fuel_lines):
		ID3_data.fuel_lines_spent += f
		ID3_data.fuel_lines_per_second = pow(ID3_data.fuel_lines_spent,ID3_data.fuel_line_burn_strength)
		ID3_data.fuel_per_second = pow(ID3_data.fuel_spent,ID3_data.fuel_burn_strength) *  ID3_data.fuel_lines_per_second
		
func ID4_enable_click_multiplier():
	ID4_data.reset_buffs()
	ID4_data.click_multiplier_enabled = true
	
func ID4_enable_fuel_line_exponent():
	ID4_data.reset_buffs()
	ID4_data.fuel_line_exponent_enabled = true
	
func ID4_enable_critical_fuel_gain_multiplier():
	ID4_data.reset_buffs()
	ID4_data.critical_fuel_gain_multiplier_enabled = true
	
func ID4_enable_passive_fuel_multiplier():
	ID4_data.reset_buffs()
	ID4_data.passive_fuel_multiplier_enabled = true
	
func ID4_enable_global_rush_multiplier():
	ID4_data.reset_buffs()
	ID4_data.global_rush_enabled = true
	
func ID5_activate_rush():
	ID5_data.rush_multiplier = ID5_data.max_rush_multiplier
	ID5_data.rush_tick_multiplier = ID5_data.max_rush_tick_multiplier
	ID2_data.crits += ID5_data.base_crit_fuel
	
func ID5_deactivate_rush():
	ID5_data.rush_multiplier = 1
	ID5_data.rush_tick_multiplier = 1

func tick_fuel():
	var i = rand.randf_range(0,1)
	var crit_mod = 1
	if i <= ID2_data.critical_chance and ID2_data.crits_enabled:
		crit_mod = ID2_data.final_crit
	fuel_count += ID3_data.fuel_per_second * crit_mod
	if ID4_data.passive_fuel_multiplier_enabled:
		fuel_lines += ID3_data.fuel_lines_per_second * (1 + log(crit_mod)) * ID4_data.passive_fuel_multiplier
	else:
		fuel_lines += ID3_data.fuel_lines_per_second * (1 + log(crit_mod))
	fuel_changed.emit()
	fuel_lines_changed.emit()
	tick_completed.emit()
	
func reset_scene_vars():
	ID5_deactivate_rush()
	
	
	
# All value updates based on other resources should be here for simplicity's sake
func gain_clicks():
	number_of_clicks += 1
	if ID4_data.click_multiplier_enabled:
		ID4_data.click_multiplier = (number_of_clicks/5) + 1


func every_time_fuel_changes():
	if ID4_data.fuel_line_exponent_enabled:
		ID4_data.fuel_line_exponent = 1 + log(fuel_count)/(5 * log(100))
	
func every_time_fuel_lines_change():
	pass

func every_time_crit_fuel_changes():
	pass
	
func every_time_crit_multiplier_changes():
	if ID4_data.critical_fuel_gain_multiplier_enabled:
		ID4_data.critical_fuel_gain_multiplier = 1 + pow(ID2_data.critical_modifier,0.5)/8
	
func every_tick_completed():
	if ID4_data.passive_fuel_multiplier_enabled:
		ID4_data.passive_fuel_multiplier = 1/(log(ID3_data.number_of_ticks) + 1)
	ID3_data.number_of_ticks += 1
	ID3_data.tick_rate = 1 * ID4_data.passive_fuel_multiplier * ID5_data.rush_tick_multiplier






func set_vars(next : FuelManager):
	fuel_count = next.fuel_count
	fuel_gain_rate = next.fuel_gain_rate
	fuel_lines = next.fuel_lines
	fuel_line_gain = next.fuel_line_gain
	
	ID1_data = next.ID1_data
	ID2_data = next.ID2_data
	ID3_data = next.ID3_data
	ID4_data = next.ID4_data
	ID5_data = next.ID5_data
	
	
	
# SAVING AND LOADING
func save_data():
	var dict = {
		"name" : "FuelManager",
		"fuel_count" : fuel_count,
		"fuel_gain_rate" : fuel_gain_rate,
		"fuel_lines" : fuel_lines,
		"fuel_line_gain" : fuel_line_gain,
		"fuel_line_mod" : ID1_data.fuel_line_mod,
		"STEP_line_mod" : ID1_data.STEP_line_mod,
		"fuel_line_mult" : ID1_data.fuel_line_mult,
		"STEP_line_mult" : ID1_data.STEP_line_mult,
		"fuel_line_gain_rate" : ID1_data.fuel_line_gain_rate,
		"STEP_line_gain_rate" : ID1_data.STEP_line_gain_rate,
		"COST_fuel_line_mod" : ID1_data.COST_fuel_line_mod,
		"COST_fuel_line_mult" : ID1_data.COST_fuel_line_mult,
		"COST_line_gain_rate" : ID1_data.COST_line_gain_rate,
		"COSTSTEP_fuel_line_mod" : ID1_data.COSTSTEP_fuel_line_mod,
		"COSTSTEP_fuel_line_mult" : ID1_data.COSTSTEP_fuel_line_mult,
		"COSTSTEP_line_gain_rate" : ID1_data.COSTSTEP_line_gain_rate,
		"crits" : ID2_data.crits,
		"crits_enabled" : ID2_data.crits_enabled,
		"crit_gain_mod" : ID2_data.crit_gain_mod,
		"critical_chance" : ID2_data.critical_chance,
		"critical_modifier" : ID2_data.critical_modifier,
		"final_crit" : ID2_data.final_crit,
		"STEP_fuel_critical_modifier" : ID2_data.STEP_fuel_critical_modifier,
		"STEP_crit_critical_modifier" : ID2_data.STEP_crit_critical_modifier,
		"COST_fuel_critical_modifier" : ID2_data.COST_fuel_critical_modifier,
		"COST_crit_critical_modifier" : ID2_data.COST_crit_critical_modifier,
		"COSTSTEP_fuel_critical_modifier" : ID2_data.COSTSTEP_fuel_critical_modifier,
		"COSTSTEP_crit_critical_modifier" : ID2_data.COSTSTEP_crit_critical_modifier,
		"fuel_per_second" : ID3_data.fuel_per_second,
		"fuel_spent" : ID3_data.fuel_spent,
		"fuel_burn_strength" : ID3_data.fuel_burn_strength,
		"fuel_line_burn_strength" : ID3_data.fuel_line_burn_strength,
		"fuel_lines_per_second" : ID3_data.fuel_lines_per_second,
		"fuel_lines_spent" : ID3_data.fuel_lines_spent,
		"tick_rate" : ID3_data.tick_rate,
		"number_of_ticks" : ID3_data.number_of_ticks,
		"number_of_clicks" : number_of_clicks,
		"click_multiplier" : ID4_data.click_multiplier,
		"fuel_line_exponent" : ID4_data.fuel_line_exponent,
		"critical_fuel_gain_multiplier" : ID4_data.critical_fuel_gain_multiplier,
		"passive_fuel_multiplier" : ID4_data.passive_fuel_multiplier,
		"click_multiplier_enabled" : ID4_data.click_multiplier_enabled,
		"fuel_line_exponent_enabled" : ID4_data.fuel_line_exponent_enabled,
		"critical_fuel_gain_multiplier_enabled" : ID4_data.critical_fuel_gain_multiplier_enabled,
		"passive_fuel_multiplier_enabled" : ID4_data.passive_fuel_multiplier_enabled,
		"rush_overcharge_enabled" : ID4_data.rush_overcharge_enabled,
		"click_multiplier_exponent" : ID4_data.click_multiplier_exponent,
		"rush_duration" : ID5_data.rush_duration,
		"rush_interval" : ID5_data.rush_interval,
		"rush_multiplier" : ID5_data.rush_multiplier,
		"rush_tick_multiplier" : ID5_data.rush_tick_multiplier,
		"max_rush_multiplier" : ID5_data.max_rush_multiplier,
		"max_rush_tick_multiplier" : ID5_data.max_rush_tick_multiplier,
		"ID5_current_charge" : ID5_data.current_charge,
		"ID5_is_rushing" : ID5_data.is_rushing,
		"ID5_overcharge_enabled" : ID5_data.overcharge_enabled,
		"ID5_overcharge_multiplier" : ID5_data.overcharge_multiplier,
		"ID5_overcharge_stored" : ID5_data.overcharge_stored
	}
	return dict
	
func load_data(dict):
	ID1_data = ID1Data.new()
	ID2_data = ID2Data.new()
	ID3_data = ID3Data.new()
	ID4_data = ID4Data.new()
	ID5_data = ID5Data.new()
	fuel_count = dict.get("fuel_count", 0)
	fuel_gain_rate = dict.get("fuel_gain_rate", 1)
	fuel_lines = dict.get("fuel_lines", 0)
	fuel_line_gain = dict.get("fuel_line_gain", 1)

	ID1_data.fuel_line_mod = dict.get("fuel_line_mod", 1)
	ID1_data.STEP_line_mod = dict.get("STEP_line_mod", 0.2)
	ID1_data.fuel_line_mult = dict.get("fuel_line_mult", 1)
	ID1_data.STEP_line_mult = dict.get("STEP_line_mult", 1)
	ID1_data.fuel_line_gain_rate = dict.get("fuel_line_gain_rate", 1)
	ID1_data.STEP_line_gain_rate = dict.get("STEP_line_gain_rate", 0.1)

	ID1_data.COST_fuel_line_mod = dict.get("COST_fuel_line_mod", 80)
	ID1_data.COST_fuel_line_mult = dict.get("COST_fuel_line_mult", 5)
	ID1_data.COST_line_gain_rate = dict.get("COST_line_gain_rate", 50)

	ID1_data.COSTSTEP_fuel_line_mod = dict.get("COSTSTEP_fuel_line_mod", 1.3)
	ID1_data.COSTSTEP_fuel_line_mult = dict.get("COSTSTEP_fuel_line_mult", 1.5)
	ID1_data.COSTSTEP_line_gain_rate = dict.get("COSTSTEP_line_gain_rate", 1.2)
	
	ID2_data.crits = dict.get("crits",0)
	ID2_data.crit_gain_mod = dict.get("crit_gain_mod",1)
	ID2_data.crits_enabled = dict.get("crits_enabled",false)
	
	ID2_data.critical_chance = dict.get("critical_chance", 0.25)
	ID2_data.critical_modifier = dict.get("critical_modifier", 1)
	ID2_data.final_crit = dict.get("final_crit",ID2_calculate_final_crit())
	ID2_data.STEP_fuel_critical_modifier = dict.get("STEP_fuel_critical_modifier",0.3)
	ID2_data.STEP_crit_critical_modifier = dict.get("STEP_fuel_critical_modifier",0.5)

	ID2_data.COST_fuel_critical_modifier = dict.get("COST_fuel_critical_modifier",500)
	ID2_data.COST_crit_critical_modifier = dict.get("COST_crit_critical_modifier",8)
	ID2_data.COSTSTEP_fuel_critical_modifier = dict.get("COSTSTEP_fuel_critical_modifier",2)
	ID2_data.COSTSTEP_crit_critical_modifier = dict.get("COSTSTEP_crit_critical_modifier",1.5)
	
	ID3_data.fuel_per_second = dict.get("fuel_per_second",0)
	ID3_data.fuel_spent = dict.get("fuel_spent",0)
	ID3_data.fuel_burn_strength = dict.get("fuel_burn_strength",0.6)
	ID3_data.fuel_line_burn_strength = dict.get("fuel_line_burn_strength",0.2)
	ID3_data.fuel_lines_per_second = dict.get("fuel_lines_per_second",0)
	ID3_data.fuel_lines_spent = dict.get("fuel_lines_spent",0)
	ID3_data.tick_rate = dict.get("tick_rate",1)
	ID3_data.number_of_ticks = dict.get("number_of_ticks",0)
	
	number_of_clicks = dict.get("number_of_clicks",0)
	
	ID4_data.click_multiplier = dict.get("click_multiplier",1)
	ID4_data.fuel_line_exponent = dict.get("fuel_line_exponent",1)
	ID4_data.critical_fuel_gain_multiplier = dict.get("critical_fuel_gain_multiplier",1)
	ID4_data.passive_fuel_multiplier = dict.get("passive_fuel_multiplier",1)
	ID4_data.click_multiplier_enabled = dict.get("click_multiplier_enabled",false)
	ID4_data.critical_fuel_gain_multiplier_enabled = dict.get("critical_fuel_gain_multiplier_enabled",false)
	ID4_data.fuel_line_exponent_enabled = dict.get("fuel_line_exponent_enabled",false)
	ID4_data.passive_fuel_multiplier_enabled = dict.get("passive_fuel_multiplier_enabled",false)
	ID4_data.click_multiplier_exponent = dict.get("click_multiplier_exponent",0.85)
	ID4_data.rush_overcharge_enabled = dict.get("rush_overcharge_enabled",false)
	
	ID5_data.rush_duration = dict.get("rush_duration",10)
	ID5_data.rush_interval = dict.get("rush_interval",120)
	ID5_data.rush_multiplier = dict.get("rush_multiplier",1)
	ID5_data.rush_tick_multiplier = dict.get("rush_tick_multiplier",1)
	ID5_data.max_rush_multiplier = dict.get("max_rush_multiplier",36)
	ID5_data.max_rush_tick_multiplier = dict.get("max_rush_tick_multiplier",10)
	ID5_data.current_charge = dict.get("ID5_current_charge",0)
	ID5_data.is_rushing = dict.get("ID5_is_rushing",false)
	ID5_data.overcharge_enabled = dict.get("ID5_overcharge_enabled",false)
	ID5_data.overcharge_multiplier = dict.get("ID5_overcharge_multiplier",1)
	ID5_data.overcharge_stored = dict.get("ID5_overcharge_stored",0)
	ID5_data.base_crit_fuel = dict.get("ID5_base_crit_fuel", 50)
