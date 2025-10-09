extends Camera2D
class_name TileCamera2D

@export var target_zoom = Vector2(2,2)
@export var zoom_speed: float = 1
@export var following_player : TileCharacterBody2D = null

func set_to_follow(player_ref : TileCharacterBody2D):
	following_player = player_ref

func _process(delta):
	if Input.is_key_pressed(KEY_C):
		target_zoom = Vector2(6,6)
	elif Input.is_key_pressed(KEY_Z):
		target_zoom = Vector2(2,2)
	else:
		target_zoom = Vector2(3,3)
	
	if following_player != null:
		position = following_player.current_position
	
	zoom = zoom.lerp(target_zoom, zoom_speed * delta)
		
