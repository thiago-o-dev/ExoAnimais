extends Control

@export var buttons : Array[Button]

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(len(buttons)):
		var value : int = i+2
		buttons[i].pressed.connect(send_to_main_scene.bind(value))

func send_to_main_scene(value : int):
	globals.player_quantity = value
	get_tree().change_scene_to_file("res://scenes/tabletop.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
