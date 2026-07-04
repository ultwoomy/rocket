extends State
class_name Dialogue_State

func _enter():
	get_parent().clear_ui_elements()
	get_parent().dialogue_box.show()
	get_parent().dialogue.def()
	
func _exit():
	pass
	
func update(delta):
	pass
