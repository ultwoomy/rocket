extends Node
var dict
var current_position : Vector2 = Vector2(0,-500)
var default_cost : Array[float] = [0,50,3600,900000,120000000]
var slotCoords : Array[Vector2] = [Vector2(360,50),Vector2(360,350),Vector2(0,350),Vector2(720,350),Vector2(360,650)]
var adj : Array[AdjList]
var cost : Array[float]
var music_volume : float
var sfx_volume : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("Savables")

func save_data():
	dict = {
		"current_position" = var_to_str(current_position),
		"name" = "BaseData"
	}
	var index = 0
	while index < cost.size():
		dict["cost_" + str(index)] = cost[index]
		index += 1
	dict["cost_size"] = cost.size()
	
	index = 0
	while index < adj.size():
		dict["adj_" + str(index) + "_top"] = adj[index].top
		dict["adj_" + str(index) + "_bottom"] = adj[index].bottom
		dict["adj_" + str(index) + "_left"] = adj[index].left
		dict["adj_" + str(index) + "_right"] = adj[index].right
		dict["adj_" + str(index) + "_center"] = adj[index].center
		index += 1
	dict["adj_size"] = adj.size()
	
	dict["music_volume"] = music_volume
	dict["sfx_volume"] = sfx_volume
	
	return dict
	
func load_data(dict):
	var x = dict.get("current_position",Vector2(0,-500))
	current_position = str_to_var(dict.get("current_position",var_to_str(Vector2(0,-500))))
	var index = 0
	cost.resize(dict.get("cost_size",default_cost.size()))
	print(cost.size())
	while index < cost.size():
		cost[index] = dict.get("cost" + str(index),default_cost[index])
		index += 1
		
	index = 0
	
	adj.resize(dict.get("adj_size",slotCoords.size()))
	while index < adj.size():
		adj[index] = AdjList.new()
		adj[index].top = dict.get("adj_" + str(index) + "_top",-1)
		adj[index].bottom = dict.get("adj_" + str(index) + "_bottom",-1)
		adj[index].left = dict.get("adj_" + str(index) + "_left",-1)
		adj[index].right = dict.get("adj_" + str(index) + "_right",-1)
		adj[index].center = dict.get("adj_" + str(index) + "_center",-1)
		index += 1
	
	music_volume = dict.get("music_volume",-16)
	sfx_volume = dict.get("sfx_volume",-16)

func buildAdjList(index, id):
	adj[index].center = id
	if index == 1:
		adj[0].bottom = adj[1].center
		adj[1].top = adj[0].center
	if index == 2:
		adj[1].left = adj[2].center
		adj[2].right = adj[1].center
	if index == 3:
		adj[1].right = adj[3].center
		adj[3].left = adj[1].center
	if index == 4:
		adj[1].bottom = adj[4].center
		adj[4].top = adj[1].center


func findIndexByID(id):
	var index = 0
	while index < adj.size():
		if adj[index].center == id:
			return index
		index += 1
	return -1
