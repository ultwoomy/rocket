extends Control
class_name Main


#@ Onready Variables
@onready var settings : Panel = $SettingsPanel


#@ Virtual Methods
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settings.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#@ Private Methods
func _on_settings_pressed() -> void:
	if settings.visible:
		settings.hide()
	else:
		settings.show()
