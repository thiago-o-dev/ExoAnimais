extends Node2D
class_name PlayerComponent

@export var active_players : Array[TileCharacterBody2D]
@export var current_player_index : int = 0
@export var active_player_indicator : Node2D 
@export var camera : TileCamera2D
var player_positions : Array[int]

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
	camera.position = active_players[player_index].position

func _set_camera_to_follow_player(player_index : int):
	camera.set_to_follow(active_players[player_index])

# Turn Management =========================================================
func _update_player_position(player_index : int, quantity : int):
	active_players[player_index].position_component.request_movement_increment(quantity)
	player_positions[player_index] += quantity
	_send_camera_to_player(player_index)

func increment_current_player_position(quantity : int):
	_update_player_position(current_player_index, quantity)
	_set_camera_to_follow_player(current_player_index)

func switch_to_next_player():
	current_player_index = (current_player_index+1) % active_players.size()
