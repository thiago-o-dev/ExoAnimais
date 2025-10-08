extends Node2D
class_name PlayerComponent

@export var active_players : Array[TileCharacterBody2D]
@export var current_player_index : int = 0

# Utility =================================================================
func _hide_all_active_players():
	for player in active_players:
		player.visible = false

func start_players(quantity : int):
	if 1 > quantity or quantity > 4:
		push_warning("Invalid ammount of players requested, changing to four")
		quantity = 4
	
	_hide_all_active_players()
	
	active_players = active_players.slice(0, quantity-1)
	
	for player in active_players:
		_activate_player(player)

func _activate_player(character : TileCharacterBody2D):
	character.visible = true

func _send_camera_to_player(player_index_position : int):
	pass

# Turn Management =========================================================
func _update_player_position(player_index_position : int, quantity : int):
	pass

func update_current_player_position(quantity : int):
	_update_player_position(current_player_index, quantity)





func _process(_delta):
	pass
