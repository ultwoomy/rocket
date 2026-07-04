extends BaseModule
class_name ID0

@onready var fuel_button = $Panel/Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	FuelManager.fuel_changed.emit()
	fuel_button.on_pressed.connect(self.add_fuel)

func add_fuel():
	if enabled:
		FuelManager.gain_fuel()
		FuelManager.gain_clicks()
