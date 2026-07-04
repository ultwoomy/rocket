extends BaseModule
class_name EmptySlot
var cost : float
signal save_position
@onready var cost_display = $Panel/Cost

func init(c):
	cost = c
	cost_display.text = "Open new mod?\nCost: " + str(NumberManager.get_scientific(cost))


func _on_button_pressed() -> void:
	if OhzeroData.tutorial_progress <= 3 and OhzeroData.tutorial_progress > -1:
		OhzeroData.tutorial_progress = 4
	if FuelManager.subtract_fuel(cost):
		SceneHandler.changeSceneToFilePath(SceneHandler.MODULEPICK)
		save_position.emit()
