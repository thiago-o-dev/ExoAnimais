extends Control
class_name UIManager

@export_category("Components")
@export var inventory_slots : InventorySlots
@export var animal_panel : AnimalPanel
@export var animated_dice_manager : AnimatedDicesManager
@export var dice_button : Button
@export var dice_button_canvas : CanvasGroup
@export var end_turn_button : Button
@export var ask_selection : Panel
@export var skip_selection : Button
@export var confirm_selection : Button
@export var ranking : Ranking
var is_dice_button_used : bool = false

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

func open_animal_data(data : AnimalData, is_return : bool = false, is_success : bool = true):
	if !data:
		inventory_slots.deselect_all()
		return
	
	animal_panel.set_animal_data(data, is_return, is_success)
	animal_panel.show_animal_panel()

func tween_to(object, variable_name : String, target, duration: float) -> Tween:
	var t = create_tween()
	t.tween_property(object, variable_name, target, duration).set_trans(Tween.TRANS_QUAD)
	return t

func ask_selection_set_visible(value : bool):
	ask_selection.visible = value

func ask_selection_set_active(value : bool):
	ask_selection_set_visible(true)
	var t : Tween
	if value:
		t = tween_to(ask_selection, "modulate:a", 1, 2)
	else:
		t = tween_to(ask_selection, "modulate:a", 0, 1)

	t.finished.connect(ask_selection_set_visible.bind(value))
	
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

func update_dice_button_appearance():
	if is_dice_button_used:
		dice_button_canvas.self_modulate.a = .5
	else:
		dice_button_canvas.self_modulate.a = 1

func _process(_delta):
	is_ui_frozen = false
	
	if animal_panel._is_opened:
		is_ui_frozen = true
	
	inventory_slots.filled_inv_slots = filled_inv_slots
	update_dice_button_appearance()
