extends Node

@export_category("Components and Managers")
@export var animals_manager : AnimalManager
@export var player_component : PlayerComponent
@export var objects_manager : ObjectsManager
@export var tile_path_2D : TilePath2D

@export_category("Game State Configurations")
@export var current_turn : int = 1
var is_player_moving = false
var animation_delay : float = 0
var object_type_to_act_on_move_end : ObjectGroup.ObjectType = ObjectGroup.ObjectType.NONE
var is_ui_frozen : bool = false

@export_category("Player Configurations")
@export var player_quantity : int = 1
@export var player_inventory_capacity : int = 4

@export_category("Information")
@export var debug : bool = true


var movement_delay = 0.3
var current_delay = 0

func _ready():
	player_component.start_players(player_quantity)

func _roll_dice(direction : int = 1, from : int = 1, to : int = 6):
	var dice_result : int = randi_range(from, to)
	
	_move_player_to(dice_result * direction)

func _move_player_to(pos_increment : int):
	animation_delay = player_component.increment_current_player_position(pos_increment)
	is_player_moving = true
	
	var player_position = _check_player_landed_position()
	print("is moving to ",player_position)
	object_type_to_act_on_move_end = objects_manager.get_object_in_pos(player_position)

func _check_player_landed_position():
	return player_component.get_current_player_position()

func _start_next_turn():
	player_component.switch_to_next_player()
	current_turn += 1

func _process(delta):
	current_delay = max(0, current_delay - delta)
	animation_delay = max(0, animation_delay - delta)
	
	if is_ui_frozen:
		return
	
	var direction : int = Input.get_axis("ui_left", "ui_right")
	
	if tile_path_2D.path_positions.is_empty():
		push_warning("TILEPATH NOT INSTANCIATED")
		return
	
	if direction != 0 and current_delay == 0 and animation_delay == 0:
		_roll_dice(-direction)
		current_delay = movement_delay
		is_player_moving = true
		return
	
	if is_player_moving and animation_delay == 0:
		is_player_moving = false
		
		print("Landed on ", object_type_to_act_on_move_end)
		
		match(object_type_to_act_on_move_end):
			ObjectGroup.ObjectType.NONE:
				pass
			ObjectGroup.ObjectType.DANGER:
				_landed_on_danger()
			ObjectGroup.ObjectType.FOREST:
				pass
		
		_start_next_turn()
		return

func _log(text):
	if debug:
		print(text)
		
func _landed_on_danger():
	# adicionar AnimalData ao inventario do jogador
	print("Landed on Danger")
	print(animals_manager.return_animal_in(_check_player_landed_position()))
