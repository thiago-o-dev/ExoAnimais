extends Control
class_name UIManager

@export_category("Components")
@export var inventory_slots : InventorySlots
@export var animal_panel : AnimalPanel
@export var animated_dice_manager : AnimatedDicesManager
@export var dice_button : Button

@export_category("Configurations")
@export var filled_inv_slots : int = 0
@export var is_ui_frozen : bool = false

func _ready():
	filled_inv_slots = 0

func roll_dices(values : Array[int]):
	animated_dice_manager.roll_dices(values)

func add_animal_data_to_inventory(data : AnimalData):
	if !data:
		return
	
	if !inventory_slots.add_animal_data(data):
		return false
	open_animal_data(data)
	return true

func open_animal_data(data : AnimalData, is_return : bool = false):
	if !data:
		inventory_slots.deselect_all()
		return
	
	animal_panel.set_animal_data(data, is_return)
	animal_panel.show_animal_panel()

func close_animal_datas():
	animal_panel.close_animal_panel()

func update_inventory_slots_fill(quantity : int):
	filled_inv_slots = quantity

func set_inventory(datas : Array[AnimalData], is_full_refresh : bool = false):
	if is_full_refresh:
		var last = filled_inv_slots
		update_inventory_slots_fill(0)
		await get_tree().create_timer(.4*last).timeout
	
	filled_inv_slots = len(datas.filter(func (x): return x))
	print("this is the fill: ",filled_inv_slots)
	inventory_slots.set_all_slots(datas)

func _process(_delta):
	is_ui_frozen = false
	
	if animal_panel._is_opened:
		is_ui_frozen = true
	
	inventory_slots.filled_inv_slots = filled_inv_slots
