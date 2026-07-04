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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == "charging":
		prog_bar.value = FuelManager.ID5_data.rush_interval - timer.time_left
	elif state == "rushing":
		prog_bar.value = rush_timer.time_left
		label.text = "Current fuel multiplier: " + str(NumberManager.get_scientific(FuelManager.ID5_data.rush_multiplier)) + "
		\nCurrent tick rate multiplier: " + str(NumberManager.get_scientific(FuelManager.ID5_data.rush_tick_multiplier))
	else: # Fully charged
		prog_bar.value = FuelManager.ID5_data.rush_interval


func _on_button_pressed() -> void:
	if state == "fully_charged" and enabled:
		rush_timer.wait_time = FuelManager.ID5_data.rush_duration
		prog_bar.max_value = FuelManager.ID5_data.rush_duration
		rush_timer.start()
		FuelManager.ID5_activate_rush()
		button.text = "Rushing production!"
		state = "rushing"


func _on_rush_timer_timeout() -> void:
	timer.wait_time = FuelManager.ID5_data.rush_interval
	prog_bar.max_value = FuelManager.ID5_data.rush_interval
	FuelManager.ID5_deactivate_rush()
	timer.start()
	button.text = "Rush is charging..."
	state = "charging"
	label.text = "Current fuel multiplier: " + str(NumberManager.get_scientific(FuelManager.ID5_data.rush_multiplier)) + "
	\nCurrent tick rate multiplier: " + str(NumberManager.get_scientific(FuelManager.ID5_data.rush_tick_multiplier))


func _on_timer_timeout() -> void:
	button.text = "Activate Rush"
	state = "fully_charged"
