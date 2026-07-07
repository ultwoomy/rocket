extends Node
# Global script.


#@ Virtual Methods
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Savables")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#@ Public Methods
func save_data() -> void:
	return


func load_data(dict) -> void:
	return
