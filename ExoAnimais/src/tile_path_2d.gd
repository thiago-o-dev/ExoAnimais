extends Path2D
class_name TilePath2D
@export var tile_spacing : float = 43.4
@export var base_line2d : Line2D
@export var start_position : Marker2D
@export var end_position : Marker2D

@export var debug : bool  = true

var path_positions : PackedVector2Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var latest_position : Vector2 = start_position.position
	path_positions.append(latest_position)
	var diference : float = 0
	
	for point in base_line2d.points:
		diference += latest_position.distance_to(point)
		_log(diference)
		
		latest_position = point
		
		if diference >= tile_spacing:
			path_positions.append(point)
			diference -= tile_spacing
	
	path_positions.append(end_position.position)
	
	_log(path_positions)
	queue_redraw()

func _draw():
	for pos in path_positions:
		#draw_string_outline(SystemFont.new(), position, "2", HORIZONTAL_ALIGNMENT_CENTER,-1,10,1,Color.BLANCHED_ALMOND)
		#draw_circle(pos, 2, Color.SADDLE_BROWN)
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _log(text):
	if debug:
		print(text)
