extends Control

@export var inv_ui : Control
const inv_ui_max_x : float = -32.0
const inv_ui_min_x : float = -691.0
const inv_slots : int = 4

var step = abs((inv_ui_max_x - inv_ui_min_x)/inv_slots) # 164.75
@export var filled_inv_slots : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var filled_slots_queue : Array[int]
func add_to_filled_slots_queue(quantity : int):
	filled_slots_queue.append(quantity)

func set_filled_slots_data():
	# pegar array animal data até 4
	pass

func _process(_delta):
	if (!filled_slots_queue.is_empty() and inv_ui.position.x == inv_ui_min_x + step * filled_inv_slots):
		filled_inv_slots = filled_slots_queue.pop_front()
	
	inv_ui.position.x = lerp(inv_ui.position.x, inv_ui_min_x + step * filled_inv_slots, 0.1)
	
	#TODO: animar dados 
