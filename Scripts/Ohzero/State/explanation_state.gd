extends State
class_name Explanation_State

func _enter():
	get_parent().clear_ui_elements()
	get_parent().id_info_panel.show()
	
func _exit():
	pass
	
func update(delta):
	pass
