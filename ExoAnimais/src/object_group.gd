@tool
extends Node2D

enum ObjectType {
	DANGER,
	FOREST
}
@export_category("Components")
@export var tile_path : TilePath2D

@export_category("Information")
@export var type : ObjectType
@export var assign_radius : float = 32.0
@export var draw_gizmos : bool = false
var children : Array[Node2D] = []

func _draw() -> void:
	if not draw_gizmos:
		return
	
	for child in children:
		draw_circle(child.position, assign_radius, Color.RED, false)

func _ready() -> void:
	children.assign(self.get_children())
	
	queue_redraw()
	
	if Engine.is_editor_hint():
		return
	
	print(type, "=======================")
	for child in children:
		print(child.name)
		for point in tile_path.path_positions:
			if child.position.distance_to(point) < assign_radius:
				print(point)

func _process(_delta):
	if Engine.is_editor_hint():
		if children.is_empty():
			children.assign(self.get_children())
		
		queue_redraw()
	#pass
