extends Node
class_name AnimalManager

var animal_datas : Array[AnimalData] = []

func _get_exotic_animals_in(pos_index : int) -> Array[AnimalData]:
	var datas : Array = []
	var typed_datas : Array[AnimalData] = []
	
	for data in animal_datas:
		if data.exotic_at.contains(pos_index):
			datas.append(data)
	
	typed_datas.assign(datas)
	return typed_datas

func _get_native_animals_in(pos_index : int) -> Array[AnimalData]:
	var datas : Array = []
	var typed_datas : Array[AnimalData] = []
	
	for data in animal_datas:
		if data.native_at.contains(pos_index):
			datas.append(data)
	
	typed_datas.assign(datas)
	return typed_datas

func return_animal_in(pos_index : int, is_native_search : bool = false) -> AnimalData:
	var animals : Array[AnimalData]

	if is_native_search:
		animals = _get_native_animals_in(pos_index)
	else:
		animals = _get_exotic_animals_in(pos_index)
	
	if animals.is_empty():
		return null
	
	return animals[randi_range(0, len(animals))]
	

func _ready():
	var children = get_children()
	
	animal_datas.assign(children)
