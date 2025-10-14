extends CharacterBody2D
class_name TileCharacterBody2D

@export_category("Components")
@export var position_component : PositionComponent
@export var tile_path_component : TilePath2D

@export_category("Configurations")
@export var _animation_speed : float = 0.5 # in ms


const tile_size: Vector2 = Vector2(32,32)
var sprite_node_pos_tween: Tween
var target_position : Vector2
var current_position : Vector2 = position

func _ready():
	position_component.tile_path = tile_path_component
	target_position = position
	current_position = position

var y_offset : float = 0
var y_function_time = 0
var y_distance_to = 0
@export var y_step_height : float = 16

func _restart_y_function():
	y_distance_to = current_position.distance_to(target_position)
	y_function_time = 0

func _calc_y_offset(delta, steps : int = 2):
	""" 
	y = abs(sin((x * steps * PI) / position.distance_to(target_position))), 
	ou
	x 0 -> 1, pos.y = abs(sin(x*PI*steps)), pos.x = x->target_position
	pegar distancia atual e calcular periodo em x para dar um numero especifico de passos em base da distancia
	"""
	if y_function_time >= _animation_speed-0.01:
		return 0
	
	y_function_time += delta
	var movement_direction = position.angle_to(target_position)
	var y = abs(sin((y_function_time * steps * PI) / _animation_speed)) * y_step_height
	
	return y

@export var tile_position_index : int = 0
var position_queue : Array[Vector2] = []
func _on_movement_update(pos_index : int) -> float:
	print("From position:", tile_position_index,"\nSignal received with value:", pos_index)
	
	var all_points_between : Array = _get_movement_order(tile_path_component.path_positions, tile_position_index, pos_index)
	var next_in_queue : Array[Vector2] = []
	next_in_queue.assign(all_points_between.map(func (x): return x + Vector2(0, -8)))
	position_queue.append_array(next_in_queue)
	tile_position_index = pos_index
	
	return len(all_points_between) * _animation_speed

func _get_movement_order(arr, from : int, to : int) -> Array:
	if from > to:
		arr = arr.slice(to, from)
		arr.reverse()
		return arr
	return arr.slice(from, to+1)

func _get_next_queued_position():
	if position_queue != []:
		print("setting new position target")
		target_position = position_queue.pop_front()
		_restart_y_function()
		
		tween_to("current_position", target_position, _animation_speed)

func tween_to(variable_name : String, target: Vector2, duration: float) -> void:
	var t = create_tween()
	t.tween_property(self, variable_name, target, duration).set_trans(Tween.TRANS_LINEAR)
	#t.connect("finished", Callable(self, "_on_tween_finished"))

func _process(delta):
	#current_position = current_position.lerp(target_position, _animation_speed_ms/50 * delta)
	y_offset = _calc_y_offset(delta)
	
	if current_position.distance_to(target_position) < 2:
		_get_next_queued_position()
		
	position = current_position - Vector2(0, y_offset)
