extends Node
class_name ID4Data

var click_multiplier : float = 1
var click_multiplier_enabled : bool = false
var click_multiplier_exponent : float = 0.85
var fuel_line_exponent : float = 1
var fuel_line_exponent_enabled : bool = false
var critical_fuel_gain_multiplier : float = 1
var critical_fuel_gain_multiplier_enabled : bool = false
var passive_fuel_multiplier : float = 1
var passive_fuel_multiplier_enabled : bool = false
var rush_overcharge_enabled : bool = false

func reset_buffs():
	click_multiplier = 1
	fuel_line_exponent = 1
	critical_fuel_gain_multiplier = 1
	passive_fuel_multiplier = 1
	
	click_multiplier_enabled = false
	fuel_line_exponent_enabled = false
	critical_fuel_gain_multiplier_enabled = false
	passive_fuel_multiplier_enabled = false
	rush_overcharge_enabled = false
	
	click_multiplier_exponent = 0.85
