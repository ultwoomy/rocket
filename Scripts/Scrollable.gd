extends Control
class_name Scrollable


#@ Public Variables
var offset: float = 0.0
var step: float = 5.0


#@ Onready Variables
@onready var content: Control = $Content  # Scrollable will move nodes that are children of content.


#@ Virtual Methods
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	content.position.y = BaseData.current_position.y
	offset = BaseData.current_position.y
	Savefile.save_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("scroll_faster"):
		step = 16
	else:
		step = 8
	if Input.is_action_pressed("scroll_up"):
		if offset < 0:
				offset += step
	if  Input.is_action_pressed("scroll_down"):
		if offset > -1260:
				offset -= step
	content.position.y = offset


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if offset > -1260:
				offset -= step
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if offset < 0:
				offset += step


#@ Public Methods


#@ Private Methods
func _on_timer_timeout() -> void:
	Savefile.save_game()


func _on_ohzero_button_pressed() -> void:
	BaseData.current_position = content.position  
	SceneHandler.changeSceneToFilePath(SceneHandler.OHZERO)
