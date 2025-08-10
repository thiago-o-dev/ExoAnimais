@tool
extends Line2D

func _draw():
	var path_node : Path2D = get_parent()
	
	if path_node:
		var baked_points : PackedVector2Array = path_node.curve.get_baked_points()
		points = baked_points

func _ready():
	_draw()
	queue_redraw()

func _process(_delta):
	if Engine.is_editor_hint():
		queue_redraw()
		
