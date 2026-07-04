extends BaseModule
class_name ID3

@onready var sacrificed_fuel : Label = $Panel/Label
@onready var fuel_per_sec : Label = $Panel/Label2
@onready var sacrificed_lines : Label = $Panel/Label3
@onready var lines_per_sec : Label = $Panel/Label4
@onready var timer : Timer = $Panel/Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = FuelManager.ID3_data.tick_rate
	print(timer.wait_time)
	update_text()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	FuelManager.tick_fuel()
	timer.wait_time = FuelManager.ID3_data.tick_rate
	

func update_text():
	sacrificed_fuel.text = "Fuel Burnt:\n" + str(NumberManager.get_scientific(FuelManager.ID3_data.fuel_spent))
	fuel_per_sec.text = "Fuel Per Second:\n" + str(NumberManager.get_scientific(FuelManager.ID3_data.fuel_per_second))
	sacrificed_lines.text = "Fuel Lines Burnt:\n" + str(NumberManager.get_scientific(FuelManager.ID3_data.fuel_lines_spent))
	lines_per_sec.text = "Fuel Lines Per Second:\n" + str(NumberManager.get_scientific(FuelManager.ID3_data.fuel_lines_per_second))


func _on_fuel_pressed() -> void:
	if enabled:
		FuelManager.ID3_refine_fuel_per_second()
		update_text()
	

func _on_fuel_lines_pressed() -> void:
	if enabled:
		FuelManager.ID3_refine_fuel_lines_per_second()
		update_text()
