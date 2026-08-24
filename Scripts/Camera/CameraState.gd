extends RefCounted
class_name CameraState


#@ Public Variables
var transitional: bool = true


#@ Private Variables
var _camera: CameraManager


#@ Virtual Methods
func _init(camera: CameraManager) -> void:
	_camera = camera


func start() -> void:
	pass


func update(delta: float) -> void:
	pass


func exit() -> void:
	pass


func input(event: InputEvent) -> void:
	pass
