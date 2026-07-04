extends Control
class_name ohzero_talking
@export var text : Label
@export var sprite : AnimatedSprite2D
@export var buttons : Array[Button]
@onready var red_arrow : Sprite2D = $RedArrow
enum faces {HAPPY, NEUTRAL, NERVOUS, PEEVED}
var faces_index = {faces.NEUTRAL : 1, faces.HAPPY : 0, faces.NERVOUS : 2, faces.PEEVED : 3}
var current_dialogue : String
var dialogue_index = 0
var button_options

signal switch_to_default
signal switch_to_talking
signal switch_to_explain


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	red_arrow.hide()
	if OhzeroData.first_sighting:
		switch_to_talking.emit()
		OhzeroData.first_sighting = false
		var x = OhzeroData.dialogue.find_text("intro_a")
		current_dialogue = "intro_a"
		button_options = OhzeroData.dialogue.get_options_by_index(current_dialogue,dialogue_index)
		OhzeroData.dialogue.set_text(0,x[0],text)
		OhzeroData.dialogue.set_face(0,faces.HAPPY,sprite)
		OhzeroData.dialogue.set_options(0,button_options,buttons)
	else:
		switch_to_default.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func def():
	OhzeroData.dialogue.set_text(0,"Perfect weather for launching!",text)
	OhzeroData.dialogue.set_face(0,faces.NEUTRAL,sprite)
	OhzeroData.dialogue.set_options(0,OhzeroData.dialogue.find_three_default(),buttons)

func parse_action(y : String):
	print(y)
	if y == "next":
		var x : Array = OhzeroData.dialogue.find_text(current_dialogue)
		dialogue_index += 1
		if dialogue_index < x.size():
			button_options = OhzeroData.dialogue.get_options_by_index(current_dialogue,dialogue_index)
			OhzeroData.dialogue.set_text(dialogue_index,x[dialogue_index],text)
			OhzeroData.dialogue.set_face(0,OhzeroData.dialogue.find_face(current_dialogue)[dialogue_index],sprite)
			OhzeroData.dialogue.set_options(0,button_options,buttons)
		else:
			switch_to_default.emit()
			dialogue_index = 0
	elif y == "open_explain_module_menu":
		switch_to_explain.emit()
	elif y == "tutorial":
		red_arrow.show()
		OhzeroData.tutorial_progress = 3
		def_next(y)
	elif y == "no need":
		OhzeroData.tutorial_progress = -1
		switch_to_default.emit()
	else:
		def_next(y)


func def_next(y):
	var x : Array = OhzeroData.dialogue.find_text(y)
	current_dialogue = y
	button_options = OhzeroData.dialogue.get_options_by_index(current_dialogue,dialogue_index)
	OhzeroData.dialogue.set_text(0,x[0],text)
	OhzeroData.dialogue.set_face(0,faces.HAPPY,sprite)
	OhzeroData.dialogue.set_options(0,button_options,buttons)

func _on_choice_pressed(button_id: int) -> void:
	var action = OhzeroData.dialogue.parse_selection(buttons[button_id].text)
	parse_action(action)
