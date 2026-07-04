extends Control
var module_preview : BaseModule
var id0 = preload("res://Scenes/Modules/ID0.tscn")
var id1 = preload("res://Scenes/Modules/ID1.tscn")
var id2 = preload("res://Scenes/Modules/ID2.tscn")
var id3 = preload("res://Scenes/Modules/ID3.tscn")
var id4 = preload("res://Scenes/Modules/ID4.tscn")
@onready var label : Label = $Label
@onready var ohzero_text : Label = $OhzeroText
@onready var next_button : Button = $NextButton
var current_explanation : Array
var index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OhzeroData.explained_module == 0:
		module_preview = id0.instantiate()
	elif OhzeroData.explained_module == 1:
		module_preview = id1.instantiate()
	elif OhzeroData.explained_module == 2:
		module_preview = id2.instantiate()
	elif OhzeroData.explained_module == 3:
		module_preview = id3.instantiate()
	elif OhzeroData.explained_module == 4:
		module_preview = id4.instantiate()
	else:
		return
	add_child(module_preview)
	module_preview.enabled = false
	module_preview.position = Vector2(100,100)
	var container : ModuleContainer = ModuleManager.module_list[OhzeroData.explained_module]
	label.text = "ID: " + str(container.ID) + "\n\nDevelopment Level: " + str(container.level) + "." + str(container.check_xp())
	current_explanation = OhzeroData.dialogue.find_text("explain_module_" + str(container.ID))
	set_text()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_next_button_pressed() -> void:
	set_text()
	
func set_text():
	if index + 1 <= current_explanation.size():
		OhzeroData.dialogue.set_text(0,current_explanation[index],ohzero_text)
		index += 1
		if index == current_explanation.size():
			next_button.hide()


func _on_back_button_pressed() -> void:
	SceneHandler.changeSceneToFilePath(SceneHandler.OHZERO)
