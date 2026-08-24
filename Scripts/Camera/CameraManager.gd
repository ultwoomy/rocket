#@ Global Script.
extends Camera2D


#@ Constants
const DEFAULT_POSITION: Vector2 = Vector2(640.0, 360.0)
const DEFAULT_ZOOM: Vector2 = Vector2.ONE
const ZOOM_IN_VECTOR: Vector2 = Vector2(2.0, 2.0)
const ZOOM_DURATION: float = 0.65


#@ Public Variables
var state: CameraState


#@ Virtual Methods
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = DEFAULT_POSITION
	
	changeState(UnfocusCS.new(self))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	state.input(event)


#@ Public Methods
func changeState(camera_state: CameraState) -> void:
	if state:
		if not state.transitional:  # NOTE: The current state will set transitional itself.
			return
		state.exit()
	state = camera_state
	state.start()
