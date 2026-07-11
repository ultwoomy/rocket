## UnitData keeps a reference to a Unit object and its stats.
extends RefCounted
class_name UnitData


#@ Public Variables
var unit: Unit


#@ Virtual Methods
func _init(_unit: Unit) -> void:
	unit = _unit
