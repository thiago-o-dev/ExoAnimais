extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta):
	#var direction = Input.get_axis("ui_left", "ui_right")
	var direction: Vector2 = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	velocity = direction*SPEED

	move_and_slide()
