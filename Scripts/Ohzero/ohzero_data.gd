extends Node
var first_sighting
var dialogue : ohzero_dialogue = ohzero_dialogue.new()
var tutorial_progress : int
var module_explanation_explained : bool = false
var explained_module : int = -1

var dict

func _ready() -> void:
	add_to_group("Savables")

func save_data():
	dict = {
			"name" = "OhzeroData",
			"first_sighting" = first_sighting,
			"default_options_active" = dialogue.dialogue_sections["default_options_active"],
			"tutorial_progress" = tutorial_progress,
			"module_explanation_explained" = module_explanation_explained,
			"explained_module" = explained_module
		}
	return dict
	
func load_data(dict):
	dialogue.setup()
	first_sighting = dict.get("first_sighting",true)
	dialogue.dialogue_sections["default_options_active"] = dict.get("default_options_active",[true,true,true,true])
	tutorial_progress = dict.get("tutorial_progress",0)
	module_explanation_explained = dict.get("module_explanation_explained",false)
	explained_module = dict.get("explained_module",-1)
	
