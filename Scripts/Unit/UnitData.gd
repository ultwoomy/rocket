## UnitData keeps a reference to a Unit object and its stats.
extends RefCounted
class_name UnitData


#@ Public Variables
var unit_name: String


#@ Private Variables
var _designated_room: InteriorRoom
	# ALERT - BUG: Because this is referencing an object, this will not work.
	# 	The designated_room will be freed when scene changes.


#@ Virtual Methods
