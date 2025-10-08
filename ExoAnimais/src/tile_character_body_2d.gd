extends CharacterBody2D
class_name TileCharacterBody2D

@export_category("Components")
@export var _position_component : PositionComponent

@export_category("Configurations")
@export var _animation_speed_ms : float = 300 # in ms

const tile_size: Vector2 = Vector2(32,32)
var sprite_node_pos_tween: Tween

func _ready():
	_position_component.movement_update.connect(_on_movement_update)

func _physics_process(delta):
	pass

func _animated_movement(target_position, steps : int = 2):
	""" 
	y = abs(sin((x * steps * PI) / position.distance_to(target_position))), 
	ou
	x 0 -> 1, pos.y = abs(sin(x*PI*steps)), pos.x = x->target_position
	pegar distancia atual e calcular periodo em x para dar um numero especifico de passos em base da distancia
	"""
	#var x = 0
	#var movement_direction = position.angle_to(target_position)
	#var y = abs(sin((x * steps * PI) / position.distance_to(target_position)))
	pass

func _on_movement_update(pos : Vector2):
	print("Signal received with value:", position)
	
	position = pos + Vector2(0, -8)
