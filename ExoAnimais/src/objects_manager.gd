extends Node2D
class_name ObjectsManager

var objects_dictionary : Dictionary[int, ObjectGroup.ObjectType]

func add_to_objects(type : ObjectGroup.ObjectType, index_positions : Array[int]):
	for pos in index_positions:
		objects_dictionary[pos] = type

func get_object_in_pos(pos : int) -> ObjectGroup.ObjectType:
	return objects_dictionary.get(pos, ObjectGroup.ObjectType.NONE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
