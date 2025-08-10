extends CharacterBody2D


const SPEED = 5000.0

const tile_size: Vector2 = Vector2(32,32)
var sprite_node_pos_tween: Tween


func _physics_process(delta):
	var direction: Vector2 = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	velocity = direction*SPEED*delta
	#if !sprite_node_pos_tween or !sprite_node_pos_tween.is_running():
		#up, 

	move_and_slide()

#func _move(dir: Vector2):
	#pass
