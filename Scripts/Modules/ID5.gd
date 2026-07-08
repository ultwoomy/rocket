extends BaseModule
class_name ID5
@onready var timer : Timer = $Panel/Timer
@onready var rush_timer : Timer = $Panel/Rush_Timer
@onready var prog_bar : ProgressBar = $Panel/ProgressBar
@onready var label : Label = $Panel/Label
@onready var button : Button = $Panel/Button
var state : String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_rush_timer_timeout()
	_on_button_pressed()
	timer.start(FuelManager.ID5_data.rush_interval - FuelManager.ID5_data.current_charge)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == "charging":
		prog_bar.value = FuelManager.ID5_data.rush_interval - timer.time_left
		FuelManager.ID5_data.current_charge = prog_bar.value
	elif state == "rushing":
		prog_bar.value = rush_timer.time_left
	else: # Fully charged
		prog_bar.value = FuelManager.ID5_data.rush_interval
		if FuelManager.ID4_data.rush_overcharge_enabled:
			FuelManager.ID5_data.overcharge_stored += delta
			FuelManager.ID5_data.overcharge_multiplier = 1 + FuelManager.ID5_data.overcharge_stored/FuelManager.ID5_data.overcharge_buff_divisor
			update_text()


func _on_button_pressed() -> void:
	if state == "fully_charged" and enabled:
		rush_timer.wait_time = FuelManager.ID5_data.rush_duration
		prog_bar.max_value = FuelManager.ID5_data.rush_duration
		FuelManager.ID5_data.current_charge = 0
		rush_timer.start()
		timer.stop()
		FuelManager.ID5_activate_rush()
		button.text = "Rushing production!"
		state = "rushing"
	update_text()


func _on_rush_timer_timeout() -> void:
	prog_bar.max_value = FuelManager.ID5_data.rush_interval
	FuelManager.ID5_deactivate_rush()
	timer.start(FuelManager.ID5_data.rush_interval)
	rush_timer.stop()
	button.text = "Rush is charging..."
	state = "charging"
	update_text()

func _on_timer_timeout() -> void:
	var str = "Activate Rush"
	button.text = "Activate Rush"
	state = "fully_charged"
	update_text()

func update_text():
	var str
	str = "Current fuel multiplier: " + str(NumberManager.get_scientific(FuelManager.ID5_data.rush_multiplier))
	if FuelManager.ID3_data.fuel_spent > 0:
		str += "\nCurrent tick rate multiplier: " + str(NumberManager.get_scientific(FuelManager.ID5_data.rush_tick_multiplier))
	if FuelManager.ID2_data.crits_enabled:
		str += "\nGain " + str(NumberManager.get_scientific(FuelManager.ID5_data.base_crit_fuel * FuelManager.ID5_data.overcharge_multiplier)) + " critical fuel"
	label.text = str
