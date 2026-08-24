## The default state for CameraManager.
## This state waits to focus on something, and has a minimum wait time before it can change state.
extends CameraState
class_name UnfocusCS


#@ Constants
const WAIT_DURATION: float = 0.25


#@ Private Variables



#@ Virtual Methods
func start() -> void:
	transitional = false
	var timer: SceneTreeTimer = _camera.get_tree().create_timer(WAIT_DURATION)
	await timer.timeout
	transitional = true


func update(delta: float) -> void:
	pass


func exit() -> void:
	pass


func input(event: InputEvent) -> void:
	pass
