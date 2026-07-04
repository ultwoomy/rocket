extends Node
class_name Dialogue

@export var dialogue_sections : Dictionary
var i = 0
var x = 0
var wait_time

func setup():
	x = 0
	i = 0

func set_text_interval(y : float):
	wait_time = y
	
func find_text(name_):
	return dialogue_sections[name_]
	
func find_face(name_):
	return dialogue_sections[name_ + "_face"]

func find_options(name_):
	return dialogue_sections[name_ + "_options"]
	
func set_text(_flags : int,text : String, label : Label):
	label.text = text
	
func get_options_by_index(dialog, index) -> Array[String]:
	var ret : Array[String]
	ret.append_array(dialogue_sections[dialog + "_options"][index])
	return ret
	
func set_face(_flags: int, face : int, sprite : AnimatedSprite2D):
	sprite.frame = face
	
func set_options(_flags: int, options : Array[String], buttons : Array[Button]):
	print(options)
	if buttons.size() < 3:
		return
	for j in range(3):
		if options.size() < j + 1:
			buttons[j].hide()
		elif options[j] == "":
			buttons[j].hide()
		else:
			buttons[j].text = options[j]
			buttons[j].show()
			
func find_three_default():
	var ret : Array[String]
	ret.append_array(find_default())
	if ret.size() > 3:
		ret = ret.slice(0,3)
	return ret
	
func find_default():
	var ret : Array
	var i = 0
	for d in dialogue_sections["default_options"]:
		if dialogue_sections["default_options_active"][i]:
			ret.append(d)
		i+=1
	return ret
	
func find_actions(name_of_dialogue,index):
	return dialogue_sections[name_of_dialogue + "_options"][index]
	
	
func disable_default_option(i):
	if i < 0:
		return
	dialogue_sections["default_options_active"][i] = false
	
	
func reset_default():
	for d in dialogue_sections["default_options_active"]:
		d = true
		
func parse_selection(x : String):
	# This will be filled by each individual dialogue container
	pass
	
func next_char():
	if (x > 0):
		i += 1
