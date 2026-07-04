extends Node
var fmat = preload("res://Scripts/FormatNo.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func get_scientific(val : float):
	if(val > 1000):
		return fmat.scientific(val,2)
	else :
		return snapped(val,0.01)
