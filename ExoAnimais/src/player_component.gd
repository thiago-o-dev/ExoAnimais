extends Node2D
class_name PlayerComponent

@export var active_players : Array[TileCharacterBody2D]
@export var current_player_index : int = 0
@export var active_player_indicator : Node2D 
@export var camera : TileCamera2D
var player_positions : Array[int]
var latest_indicator_set : int = 0

# Utility =================================================================
func _hide_all_active_players():
	for player in active_players:
		player.visible = false

func start_players(quantity : int):
	if 1 > quantity or quantity > 4:
		push_warning("Invalid ammount of players requested, changing to four")
		quantity = 4
	
	_hide_all_active_players()
	
	active_players = active_players.slice(0, quantity)
	player_positions.assign(Array(range(0, quantity).map(func (_x): return 0)))
	
	for player in active_players:
		_activate_player(player)
		
	_send_camera_to_player(0)

func _activate_player(character : TileCharacterBody2D):
	character._ready()
	character.visible = true
	character.position_component.request_movement_to_index(0)

func _send_camera_to_player(player_index : int):
	# Deprecated
	camera.position = active_players[player_index].position
	set_indicator_to_player(player_index)

func _set_camera_to_follow_player(player_index : int):
	camera.set_to_follow(active_players[player_index])
	set_indicator_to_player(player_index)

# Turn Management =========================================================
func _update_player_position(player_index : int, quantity : int) -> float:
	var time_till_end : float = active_players[player_index].position_component.request_movement_increment(quantity)
	player_positions[player_index] += quantity
	
	return time_till_end

func increment_current_player_position(quantity : int):
	_set_camera_to_follow_player(current_player_index)
	return _update_player_position(current_player_index, quantity)

func get_current_player_position() -> int:
	return player_positions[current_player_index]

func switch_to_next_player():
	current_player_index = (current_player_index+1) % active_players.size()

func set_indicator_to_player(player_index : int):
	latest_indicator_set = player_index

func _process(_delta):
	active_player_indicator.global_position = lerp(active_player_indicator.global_position, active_players[latest_indicator_set].global_position, .5)
