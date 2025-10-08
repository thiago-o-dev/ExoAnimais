extends Node
class_name PositionComponent

@export var tile_path : TilePath2D

var current_index_position = 0

@export var movement_delay = 0.1
var current_delay = 0

signal movement_update(position, player_number)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_delay = max(0, current_delay - delta)
	var direction : int = Input.get_axis("ui_left", "ui_right")
	
	if !tile_path.path_positions.is_empty():
		if direction != 0 and current_delay <= 0:
			current_index_position += direction
			current_index_position = clamp(current_index_position, 0, len(tile_path.path_positions)-1)
			current_delay = movement_delay
			emit_signal("movement_update", tile_path.path_positions[current_index_position])
	else:
		push_warning("TILEPATH NOT INSTANCIATED")
