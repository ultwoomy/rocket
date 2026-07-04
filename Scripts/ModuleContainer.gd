extends Node
class_name ModuleContainer
@export var mod_scene : PackedScene
@export var xp : int
@export var level : int = 1
@export var ID : int = 0
@export var LEVEL1DESC : String = ""
@export var LEVEL2DESC : String = ""
@export var LEVEL3DESC : String = ""
var thresh2 : int = 0
var thresh3 : int = 0

func instant():
	return mod_scene.instantiate()

func check_xp():
	if level == 1 and xp >= thresh2:
		level += 1
	if level == 2 and xp >= thresh3:
		level += 1
	return xp

func return_text():
	if level == 1:
		return LEVEL1DESC
	elif level == 2:
		return LEVEL2DESC
	elif level == 3:
		return LEVEL3DESC
	else:
		return LEVEL1DESC
