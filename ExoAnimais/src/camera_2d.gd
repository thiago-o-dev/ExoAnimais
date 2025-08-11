extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_C):
		set_zoom(Vector2(2,2))
	elif Input.is_key_pressed(KEY_Z):
		set_zoom(Vector2(.5,.5))
	else:
		set_zoom(Vector2(1,1))
		
