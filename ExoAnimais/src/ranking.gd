extends Control
class_name Ranking

@export var player_tracked : Array[Control]
@export var player_values : Array[Label]

func set_player_ranking(index, value):
	player_values[index].text = str(value)

func set_tracked_players(quantity):
	for player in player_tracked:
		player.visible = false
	
	for i in range(quantity):
		player_tracked[i].visible = true
