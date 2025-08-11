extends Path2D
@export var tile_spacing : float = 43.4
@export var base_line2d : Line2D
@export var start_position : Marker2D

var positions : PackedVector2Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var latest_position : Vector2 = start_position.position
	positions.append(latest_position)
	var diference : float = 0
	
	for point in base_line2d.points:
		diference += latest_position.distance_to(point)
		print(diference)
		
		latest_position = point
		
		if diference >= tile_spacing:
			positions.append(point)
			diference -= tile_spacing
	
	print(positions)
	queue_redraw()

func _draw():
	for position in positions:
		#draw_string_outline(SystemFont.new(), position, "2", HORIZONTAL_ALIGNMENT_CENTER,-1,10,1,Color.BLANCHED_ALMOND)
		draw_circle(position, 2, Color.SADDLE_BROWN)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
