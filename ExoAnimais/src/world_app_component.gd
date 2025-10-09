extends Node

@export_category("Game State configurations")
@export var current_turn : int = 1

@export_category("Player configurations")
@export var player_component : PlayerComponent
@export var player_quantity : int = 1

@export_category("Information")
@export var tile_path_2D : TilePath2D
@export var debug : bool = true

var movement_delay = 0.3
var current_delay = 0

func _ready():
	player_component.start_players(player_quantity)

func _roll_dice(direction : int = 1, from : int = 1, to : int = 6):
	var dice_result : int = randi_range(from, to)
	
	player_component.increment_current_player_position(dice_result * direction)

func _start_next_turn():
	player_component.switch_to_next_player()
	current_turn += 1

func _process(delta):
	current_delay = max(0, current_delay - delta)
	var direction : int = Input.get_axis("ui_left", "ui_right")
	
	if !tile_path_2D.path_positions.is_empty():
		if direction != 0 and current_delay <= 0:
			_roll_dice(-direction)
			current_delay = movement_delay
			_start_next_turn()
	else:
		push_warning("TILEPATH NOT INSTANCIATED")
	#pass

func _log(text):
	if debug:
		print(text)
