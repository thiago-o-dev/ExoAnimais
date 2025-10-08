extends Node

@export_category("Game State configurations")
@export var current_turn : int = 1
var on_turn_end

@export_category("Player configurations")
@export var PlayerComponent : PlayerComponent
@export var player_quantity : int = 1
var player_positions : Array = Array(range(0, player_quantity).map(func (_x): return 0))

@export_category("Information")
@export var debug : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	_log(player_positions)
	PlayerComponent.start_players(player_quantity)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _log(text):
	if debug:
		print(text)
