extends CameraState
class_name FocusCS


#@ Private Methods
var _focus_target: Control
var _offset: Vector2


#@ Virtual Methods
func _init(camera: CameraManager, focus_target: Control, offset: Vector2 = Vector2.ZERO) -> void:
	_camera = camera
	_focus_target = focus_target
	_offset = offset


func start() -> void:
	var tween: Tween = _camera.get_tree().create_tween()
	tween.tween_property(_camera, "zoom", _camera.ZOOM_IN_VECTOR, _camera.ZOOM_DURATION).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel()
	tween.tween_property(_camera, "position", _focus_target.global_position + _offset, _camera.ZOOM_DURATION).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func update(delta: float) -> void:
	pass


func exit() -> void:
	var tween: Tween = _camera.get_tree().create_tween()
	tween.tween_property(_camera, "zoom", _camera.DEFAULT_ZOOM, _camera.ZOOM_DURATION).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel()
	tween.tween_property(_camera, "position", _camera.DEFAULT_POSITION, _camera.ZOOM_DURATION).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		_camera.changeState(UnfocusCS.new(_camera))
