extends Node
# Global script.


#@ Public Variables
var units: Array[Unit] = []  # All of the units the Player owns.
	# ALERT: BUG - EVERYTIME THE SCENE MOVES TO main.gd, UNITS ARE CREATED.
	# 	THESE UNITS ARE THEN MOVED INTO THIS ARRAY, AND THE PREVIOUS ONES ARE DELETED.


#@ Virtual Methods
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: Make this savable.
	#add_to_group("Savables")
	
	print("UnitManager is running!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#@ Public Methods
func save_data() -> void:
	return


func load_data(dict) -> void:
	return
