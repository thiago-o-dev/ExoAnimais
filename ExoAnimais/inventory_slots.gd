extends Panel
class_name InventorySlots

@export_category("Components")
@export var ui_manager : UIManager

@export_category("Informations")
@export var slot_buttons : Array[Button]
@export var slots_datas : Array[AnimalData] = [null, null, null, null]
@export var buttons_select : Array[bool] = [false, false, false, false]
@export var selected_border_color : Color = Color(0.2, 0.8, 1.0) # light blue border when selected
@export var border_thickness : int = 4

func deselect_all():
	for i in range(0,4):
		buttons_select[i] = false
	
	_update_visual_states()
	
	ui_manager.close_animal_datas()

func _on_pressed(index):
	var range = range(0,4)
	range.remove_at(index)
	
	for i in range:
		buttons_select[i] = false
	
	buttons_select[index] = !buttons_select[index]
	
	_update_visual_states()
	
	print(buttons_select)
	
	if buttons_select[index]:
		ui_manager.open_animal_data(slots_datas[index])
	else:
		ui_manager.close_animal_datas()

func _update_visual_states():
	for i in range(0,4):
		var stylebox := StyleBoxFlat.new()
		stylebox.bg_color = Color(0, 0, 0, 0)
		if buttons_select[i]:
			stylebox.border_color = selected_border_color
			stylebox.set_border_width_all(border_thickness)
			stylebox.set_expand_margin_all(border_thickness)
		else:
			stylebox.set_border_width_all(0)
			stylebox.set_expand_margin_all(0)
		
		slot_buttons[i].add_theme_stylebox_override("normal", stylebox)
		slot_buttons[i].add_theme_stylebox_override("hover", stylebox)
		slot_buttons[i].add_theme_stylebox_override("pressed", stylebox)
		slot_buttons[i].add_theme_stylebox_override("focus", stylebox)

func _ready():
	for i in range(0,4):
		var value : int = i
		slot_buttons[i].connect("pressed", Callable(self, "_on_pressed").bind(value))
	
	_update_visual_states()

func send_clicked_button_to_manager():
	ui_manager.on_inventory_button_clicked_event()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
