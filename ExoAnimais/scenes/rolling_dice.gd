extends Button

var end_position : int = 1
var scales : Vector2 = Vector2(1, 0) #Vector2(x, y) where x + y = 1
@export var rotations_rand_len : Vector2i = Vector2i(4,7)

@export var left_side : TextureRect
var left_side_value : int = -1
@export var right_side : TextureRect

@export var dice_textures_folder : String = "res://assets/ui/dice_sprites"
var folder_ref : RefCounted
var dice_sprites

var right_side_value : int = -1

var time : float = 2.0 #seconds
var dice_queue : Array[int] = []

var is_spinning : bool = false

func when_scale_reaches_right():
	scales = Vector2(0, 1)
	

func _dice_roll():
	randi_range(1, 6)

func _create_dice_queue():
	for i in range(randi_range(rotations_rand_len.x, rotations_rand_len.y)):
		var roll : int = _dice_roll()
		
		if !dice_queue.is_empty():
			while roll == dice_queue[i-1]:
				print(roll, "==", dice_queue[i-1])
				roll = _dice_roll()
		
		dice_queue.append(roll)

func _switch_sides():
	if right_side_value == -1:
		right_side_value = dice_queue.pop_front()
	else:
		right_side_value = left_side_value
	left_side_value = dice_queue.pop_front()
	_refresh_dice_textures()
	
func _refresh_dice_textures():
	right_side.texture = dice_sprites[right_side_value-1]
	left_side.texture = dice_sprites[left_side_value-1]

func _ready():
	folder_ref = DirAccess.open(dice_textures_folder)
	
	dice_sprites = folder_ref.get_files()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
