extends Node
class_name State
signal transitioned(new_state_name : String)


func _enter():
	pass
	
func _exit():
	pass
	
func update(delta):
	pass

func signal_state(new_state):
	transitioned.emit(new_state)
