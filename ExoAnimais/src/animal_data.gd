extends Node
class_name AnimalData

@export_category("General Info")
@export var image: Texture2D = null
@export var title: String = ""
@export var subtitle: String = ""
@export_multiline var description: String = ""
@export_multiline var success_text: String = ""
@export_multiline var incorrect_text: String = "Você retornou o animal exótico fora de sua fauna natural."

@export_category("Position Pairs")
@export var exotic_at: PositionPairs = PositionPairs.new([])
@export var native_at: PositionPairs = PositionPairs.new([])
