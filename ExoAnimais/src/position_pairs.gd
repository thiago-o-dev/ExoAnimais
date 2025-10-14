extends Resource
class_name PositionPairs

@export var ranges: Array[Vector2i] = []

func _init(ranges: Array[Vector2i] = []):
	for pair in ranges:
		_add_range(pair)

func _add_range(pair: Vector2i) -> void:
	var start := pair.x
	var end := pair.y
	if start > end:
		push_error("Intervalo inválido: (%d:%d). O início não pode ser maior que o fim." % [start, end])
		return
	ranges.append(Vector2i(start, end))

func contains(value: int) -> bool:
	for pair in ranges:
		if value >= pair.x and value <= pair.y:
			return true
	return false

func _to_string() -> String:
	var parts: Array[String] = []
	for pair in ranges:
		parts.append("(%d–%d)" % [pair.x, pair.y])
	return "[" + ", ".join(parts) + "]"
