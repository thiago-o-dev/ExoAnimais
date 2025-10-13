extends Node2D
class_name ObjectsManager

var objects_dictionary : Dictionary[int, Array[ObjectGroup.ObjectType]]

func add_to_objects(type : ObjectGroup.ObjectType, index_pos : Array[int]):
	objects_dictionary

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
