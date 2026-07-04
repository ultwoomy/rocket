extends Control
var mod1 : ModuleContainer = ModuleManager.module_list[0]
var mod2 : ModuleContainer = ModuleManager.module_list[0]
var mod3 : ModuleContainer = ModuleManager.module_list[0]
var random_list : Array[ModuleContainer]
@onready var button1 : TextureButton = $ModContainer
@onready var button2 : TextureButton = $ModContainer2
@onready var button3 : TextureButton = $ModContainer3
@onready var tutorial : Control = $Tutorial
@onready var tutorial_text : Label = $Tutorial/Label
var mod_group : Array[ModuleContainer] = [mod1,mod2,mod3]
var button_group : Array[TextureButton]
@onready var desc : Label = $NinePatchRect/Panel/Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OhzeroData.tutorial_progress == 4:
		tutorial.show()
	elif OhzeroData.tutorial_progress == 5:
		tutorial.show()
		tutorial_text.text = "Pick anything. They will all help you gain fuel in various ways"
		OhzeroData.tutorial_progress = 6
	else:
		tutorial.hide()
	button_group.append(button1)
	button_group.append(button2)
	button_group.append(button3)
	if ModuleManager.active_modules.size() == 0:
		button1.hide()
		button3.hide()
		button1.disabled = true
		button3.disabled = true
	else:
		random_list = ModuleManager.module_list.duplicate()
		print(random_list)
		for m in ModuleManager.active_modules:
			for n in random_list:
				print(str(m.ID) + " " + str(n.ID))
				if m.ID == n.ID:
					random_list.erase(n)
		print(random_list)
		random_list.shuffle()
		var i = 0
		while i < 3:
			if random_list.size() <= i:
				button_group[i].hide()
				button_group[i].disabled = true
				mod_group[i] = ModuleManager.module_list[0]
			else:
				mod_group[i] = random_list[i]
			i += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mod_container_mouse_entered(id: int) -> void:
	button_group[id - 1].scale = Vector2(1.1,1.1)
	desc.text = "\nID: " + str(mod_group[id - 1].ID) + "\n\n" + mod_group[id - 1].return_text()
	
func _on_mod_container_mouse_exited(id: int) -> void:
	button_group[id - 1].scale = Vector2(1,1)

func _on_mod_container_pressed(id: int) -> void:
	ModuleManager.active_modules.append(mod_group[id - 1])
	BaseData.buildAdjList(ModuleManager.active_modules.size() - 1, mod_group[id - 1].ID)
	mod_group[id - 1].xp += 1
	for b in button_group:
		b.disabled = true
	SceneHandler.changeSceneToFilePath(SceneHandler.MAIN)
