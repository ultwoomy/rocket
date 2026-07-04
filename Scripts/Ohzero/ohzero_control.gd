extends Control

# Ohzero is the first of the automata bots. Their purpose is to help you build the rocket. They assume you already know why you're building it
# Ohzero will explain the functions associated with its modules. This can be any phase 1 module (ID0 through 6). 
# You will be able to see said modules various stats here as well. 
# Ohzero will also explain the beginning of the story

@onready var state_manager = $State_Manager
@onready var talk = $Ohzero_Talking


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	talk.switch_to_default.connect(self.to_default)
	talk.switch_to_talking.connect(self.to_talking)
	talk.switch_to_explain.connect(self.to_explain)
	if OhzeroData.tutorial_progress < 1 and OhzeroData.tutorial_progress > -1:
		OhzeroData.tutorial_progress = 1
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_pressed() -> void:
	Savefile.save_game()
	SceneHandler.changeSceneToFilePath(SceneHandler.MAIN)
	if OhzeroData.tutorial_progress < 2 and OhzeroData.tutorial_progress > -1:
		OhzeroData.tutorial_progress = 2

func to_default():
	state_manager.switch_default()
	
func to_talking():
	state_manager.switch_talking()
	
func to_explain():
	state_manager.switch_explain()


func _on_choice_pressed(extra_arg_0: int) -> void:
	pass # Replace with function body.
