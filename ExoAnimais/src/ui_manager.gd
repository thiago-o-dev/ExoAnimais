extends Control
class_name UIManager

@export_category("Components")
@export var inventory_slots : InventorySlots
@export var animal_panel : AnimalPanel

@export_category("Configurations")
@export var filled_inv_slots : int = 0
@export var is_ui_frozen : bool = false

func add_animal_data_to_inventory(data : AnimalData):
	if !data:
		return
	
	if !inventory_slots.add_animal_data(data):
		return false
	open_animal_data(data)
	return true

func open_animal_data(data : AnimalData):
	if !data:
		inventory_slots.deselect_all()
		return
	
	animal_panel.set_animal_data(data)
	animal_panel.show_animal_panel()

func close_animal_datas():
	animal_panel.close_animal_panel()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_inventory_slots_fill(quantity : int):
	filled_inv_slots = quantity

func _process(_delta):
	is_ui_frozen = false
	
	if animal_panel._is_opened:
		is_ui_frozen = true
	
	inventory_slots.filled_inv_slots = filled_inv_slots
