extends Node
class_name State_Manager
@export var init_state : State
@export var dialogue_box : Control
@export var dialogue_label : Label
@export var id_info_panel : Panel
@export var ohzero_sprite : AnimatedSprite2D
@export var dialogue : ohzero_talking
var states:Dictionary = {}
var current_state : State
		
signal state_changed

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(_on_child_transition)

	if init_state:
		init_state._enter()
		current_state = init_state

func _on_child_transition(new_state_name):
	#if state != current_state:
		#return
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	if current_state:
		current_state._exit()
	new_state._enter()
	current_state = new_state
	state_changed.emit() 

func _process(delta: float) -> void:
	current_state.update(delta)
	
func clear_ui_elements():
	dialogue_box.hide()
	id_info_panel.hide()

func switch_default():
	current_state.signal_state("Default_State")
	
func switch_talking():
	current_state.signal_state("Dialogue_State")
	
func switch_explain():
	current_state.signal_state("Explanation_State")
