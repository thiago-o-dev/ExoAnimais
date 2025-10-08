@tool
extends Line2D
@export var render_on_water : bool = false
@export var path_node : Path2D
@export var water_area_2d : Area2D

func _draw():	
	if path_node:
		var baked_points : PackedVector2Array = path_node.curve.get_baked_points()
		
		if not render_on_water and water_area_2d:
			baked_points = remove_points_in_water(baked_points, water_area_2d)
		
		points = baked_points

func remove_points_in_water(points : PackedVector2Array, water_area : Area2D):
	var colision_polygons : Array[CollisionPolygon2D] = get_colision_polygons(water_area)
	var to_remove : Array[int] = []
	
	for i in range(points.size()):
		var flag = false
		for shape in colision_polygons:
			if Geometry2D.is_point_in_polygon(points[i], shape.polygon) and not flag:
				to_remove.append(i)
				flag = true
				
	to_remove.sort_custom(func(a,b): return a > b)
	for i in to_remove:
		points.remove_at(i)
		
	return points
	
func get_colision_polygons(parent_node: Node) -> Array[CollisionPolygon2D]:
	var filtered_children: Array[CollisionPolygon2D] = []
	for child in parent_node.get_children():
		if is_instance_of(child, CollisionPolygon2D):
			filtered_children.append(child)
	return filtered_children

func _ready():
	_draw()
	queue_redraw()

func _process(_delta):
	if Engine.is_editor_hint():
		queue_redraw()
		
