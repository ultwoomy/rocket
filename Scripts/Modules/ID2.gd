extends BaseModule
class_name ID2

@onready var crit_chance_label : Label = $Panel/CritChance
@onready var crit_fuel : Label = $Panel/CritFuel
@onready var prices : Label = $Panel/Panel/Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	FuelManager.ID2_data.crits_enabled = true
	_on_h_slider_value_changed(FuelManager.ID2_data.critical_chance)
	FuelManager.fuel_crits_changed.connect(self.update_prices)
	update_prices()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_h_slider_value_changed(value: float) -> void:
	FuelManager.ID2_data.critical_chance = value
	FuelManager.ID2_calculate_final_crit()
	update_prices()

func update_prices():
	prices.text = "Cost:\n" + str(NumberManager.get_scientific(FuelManager.ID2_data.COST_fuel_critical_modifier)) + " fuel\nOR
				" + str(NumberManager.get_scientific(FuelManager.ID2_data.COST_crit_critical_modifier)) + " critical fuel"
	crit_fuel.text = "Critical Fuel: " + str(NumberManager.get_scientific(FuelManager.ID2_data.crits))
	crit_chance_label.text = "Crit Chance: " + str(NumberManager.get_scientific(FuelManager.ID2_data.critical_chance * 100)) + "%
							Crit Multiplier: " + str(NumberManager.get_scientific(FuelManager.ID2_data.final_crit))

func _on_refine_crit_pressed() -> void:
	if (FuelManager.subtract_fuel(FuelManager.ID2_data.COST_fuel_critical_modifier)) and enabled:
		FuelManager.ID2_refine_crit_fuel()
		
	if(FuelManager.ID2_subtract_crits(FuelManager.ID2_data.COST_crit_critical_modifier)) and enabled:
		FuelManager.ID2_refine_crit_crit()
	update_prices()
