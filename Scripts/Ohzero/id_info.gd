extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_id_pressed(extra_arg_0: int) -> void:
	if extra_arg_0 > 5:
		return
	Savefile.save_game()
	OhzeroData.explained_module = extra_arg_0
	SceneHandler.changeSceneToFilePath(SceneHandler.EXPLANATION)
