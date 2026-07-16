extends Control


#@ Public Variables
var offset : int = 0
var step = 5


#@ Onready Variables
@onready var background : SetModules = $Background
@onready var pre_tutorial : Control = $Background/Control
@onready var settings : Panel = $SettingsPanel


#@ Virtual Methods
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settings.hide()
	background.position.y = BaseData.current_position.y
	background.save_position.connect(self.save_position)
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
	background.position.y = offset

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if offset > -1260:
				offset -= step
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if offset < 0:
				offset += step


#@ Public Methods
func save_position():
	BaseData.current_position = background.position


#@ Private Methods
func _on_timer_timeout() -> void:
	Savefile.save_game()


func _on_ohzero_button_pressed() -> void:
	save_position()
	SceneHandler.changeSceneToFilePath(SceneHandler.OHZERO)
	



func _on_settings_pressed() -> void:
	if settings.visible:
		settings.hide()
	else:
		settings.show()
