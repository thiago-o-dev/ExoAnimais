extends Node

@export_category("Components and Managers")
@export var animals_manager : AnimalManager
@export var player_component : PlayerComponent
@export var objects_manager : ObjectsManager
@export var tile_path_2D : TilePath2D
@export var ui_manager : UIManager

@export_category("Game State Configurations")
@export var current_turn : int = 1
@export var points_to_add_when_won : int = 30
@export var points_to_add_when_right : int = 5
@export var points_to_add_when_wrong : int = -1
var is_player_moving = false
var animation_delay : float = 0
var object_type_to_act_on_move_end : ObjectGroup.ObjectType = ObjectGroup.ObjectType.NONE
var player_already_moved : bool = false
var game_end_reached : bool = false

@export_category("Player Configurations")
@export var player_quantity : int = 1
@export var filled_inventory_queue : Array[int] = [0,0,0,0]
@export var player_points : Array[int] = [0,0,0,0]
@export var is_returning : bool = false

class InventoryGroup:
	var slots : Array[AnimalData] = [null, null, null, null]

var inventory_datas : Array[InventoryGroup] = [
		InventoryGroup.new(), InventoryGroup.new(), InventoryGroup.new(), InventoryGroup.new()
	]

@export_category("Information")
@export var debug : bool = true


var movement_delay = 0.3
var current_delay = 0

func _ready():
	player_component.start_players(player_quantity)
	ui_manager.dice_button.connect("pressed", Callable(self, "_on_dice_button_click"))
	ui_manager.animated_dice_manager.on_proceed_clicked.connect(_selected_dice_movement)
	#ui_manager.inventory_slots.on_animal_slot_pressed.connect(_on_inventory_slot_pressed)
	ui_manager.end_turn_button.pressed.connect(_end_button_pressed)
	
	ui_manager.confirm_selection.pressed.connect(_on_confirm_selection_slot_pressed)
	ui_manager.skip_selection.pressed.connect(_on_skip_selection_slot_pressed)
	
	ui_manager.ranking.set_tracked_players(player_quantity)

func _update_end_button_visual():
	if player_already_moved and !is_player_moving:
		ui_manager.end_turn_button.modulate.a = 1
	else:
		ui_manager.end_turn_button.modulate.a = .5

func _end_button_pressed():
	if player_already_moved and !is_player_moving and current_delay == 0 and animation_delay == 0:
		_start_next_turn()
		player_already_moved = false
		current_delay = .2
		return


func _on_dice_button_click():
	if player_already_moved:
		return
	
	if ui_manager.is_ui_frozen:
		return
	
	ui_manager.is_ui_frozen = true
	
	print("Dice button was clicked")
	ui_manager.roll_dices([-1, -1])
	
	ui_manager.animated_dice_manager.proceed_button.set_pressed_no_signal(false)
	
func _selected_dice_movement(pos_increment : int):
	player_already_moved = true
	ui_manager.is_ui_frozen = false
	_move_player_to(pos_increment)

func _roll_dice(direction : int = 1, from : int = 1, to : int = 6):
	var dice_result : int = randi_range(from, to)
	
	_move_player_to(dice_result * direction)

func _move_player_to(pos_increment : int):
	animation_delay = player_component.increment_current_player_position(pos_increment)
	is_player_moving = true
	
	var player_position = _check_player_landed_position()
	if player_position == len(tile_path_2D.path_positions):
		game_end_reached = true
		player_points[get_curr_player()] += points_to_add_when_won
		
	print("is moving to ",player_position)
	object_type_to_act_on_move_end = objects_manager.get_object_in_pos(player_position)

func _check_player_landed_position():
	return player_component.get_current_player_position()

func _send_players_to_game_won_screen():
	print("game ended")

func _start_next_turn():
	current_turn += 1
	player_component.switch_to_next_player()
	
	var i = player_component.current_player_index
	
	ui_manager.set_inventory(inventory_datas[i].slots, true)
	
	if game_end_reached and current_turn % player_quantity == 1:
		_send_players_to_game_won_screen()
	
	player_component.set_indicator_to_player(get_curr_player())
	player_component._set_camera_to_follow_player(get_curr_player())
	

func _process(delta):
	for i in range(player_quantity):
		ui_manager.ranking.set_player_ranking(i, player_points[i])
	
	current_delay = max(0, current_delay - delta)
	animation_delay = max(0, animation_delay - delta)
	
	_update_end_button_visual()
	
	if ui_manager.is_ui_frozen:
		return
	
	var direction : int = int(Input.get_axis("ui_left", "ui_right"))
	
	if tile_path_2D.path_positions.is_empty():
		push_warning("TILEPATH NOT INSTANCIATED")
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
				_landed_on_forest()
		return

	#if direction != 0 and current_delay == 0 and animation_delay == 0 and !player_already_moved:
		#player_already_moved = true
		#_roll_dice(-direction)
		#current_delay = movement_delay
		#is_player_moving = true
		#return
		

func _log(text):
	if debug:
		print(text)

func get_curr_player():
	return player_component.current_player_index

func get_player_inv():
	return inventory_datas[get_curr_player()].slots

func get_player_inv_size():
	return len(get_player_inv().filter(func (x): return x))

func add_animal_data(data : AnimalData) -> bool:
	var free_position = inventory_datas[get_curr_player()].slots.find(null)
	
	if free_position == -1:
		return false
	
	inventory_datas[get_curr_player()].slots[free_position] = data
	return true

func _on_confirm_selection_slot_pressed():
	print(is_returning)
	if !is_returning:
		return
	
	var selected_in_inventory = ui_manager.inventory_slots.buttons_select.find(true)
	
	if selected_in_inventory == -1:
		return
	
	var animal = inventory_datas[get_curr_player()].slots[selected_in_inventory]
	
	var is_sucess = animals_manager.return_if_animal_is_native_from(animal, _check_player_landed_position())
	
	ui_manager.open_animal_data(animal, true, is_sucess)
	inventory_datas[get_curr_player()].slots.remove_at(selected_in_inventory)
	inventory_datas[get_curr_player()].slots.push_back(null)
	ui_manager.set_inventory(inventory_datas[get_curr_player()].slots)
	
	if is_sucess:
		player_points[get_curr_player()] += points_to_add_when_right
	else:
		player_points[get_curr_player()] += points_to_add_when_wrong
	
	is_returning = false
	ui_manager.ask_selection_set_active(false)
	
func _on_skip_selection_slot_pressed():
	if !is_returning:
		return
	
	is_returning = false
	ui_manager.ask_selection_set_active(false)

func _landed_on_forest():
	print("Landed on Forest")
	
	ui_manager.is_ui_frozen = true
	is_returning = true
	
	ui_manager.ask_selection_set_active(true)
	

func _landed_on_danger():
	# adicionar AnimalData ao inventario do jogador
	print("Landed on Danger")
	var animal : AnimalData = animals_manager.return_animal_in(_check_player_landed_position())
	
	print(animal)
	
	if !add_animal_data(animal):
		return
	
	ui_manager.set_inventory(get_player_inv())
	ui_manager.open_animal_data(animal)
	print(get_player_inv_size())
