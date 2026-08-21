#@ Global Script.
extends Camera2D


#@ Constants
const DEFAULT_POSITION: Vector2 = Vector2(640.0, 360.0)
const DEFAULT_ZOOM: Vector2 = Vector2.ONE
const ZOOM_IN_VECTOR: Vector2 = Vector2(2.0, 2.0)
const ZOOM_DURATION: float = 0.65


#@ Public Variables
var is_zoomed: bool


#@ Virtual Methods
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = DEFAULT_POSITION


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		zoom_out()


#@ Public Methods
func zoom_on_control(target: Control, offset: Vector2 = Vector2(0.0, 0.0)) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "zoom", ZOOM_IN_VECTOR, ZOOM_DURATION).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel()
	tween.tween_property(self, "position", target.global_position + offset, ZOOM_DURATION).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	is_zoomed = true


func zoom_out() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "zoom", DEFAULT_ZOOM, ZOOM_DURATION).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel()
	tween.tween_property(self, "position", DEFAULT_POSITION, ZOOM_DURATION).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	is_zoomed = false
