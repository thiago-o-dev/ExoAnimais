extends Node
class_name PositionComponent

var current_index_position = 0
@export var movement_delay = 0.1
@export var tileCharacterBody2D : TileCharacterBody2D
var current_delay = 0
var tile_path : TilePath2D

func request_movement_to_index(index : int):
	index = clamp(index, 0, len(tile_path.path_positions))
	current_index_position = index
	
	tileCharacterBody2D._on_movement_update(index)
	
func request_movement_increment(increment : int):
	var index = current_index_position + increment
	request_movement_to_index(index)
