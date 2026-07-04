extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	FuelManager.fuel_changed.connect(self.update_count)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_count():
	text = str(NumberManager.get_scientific(FuelManager.fuel_count))
