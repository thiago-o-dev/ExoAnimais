extends Panel
class_name AnimalPanel

@export_category("Parts")
@export var image : TextureRect
@export var title : Label
@export var subtitle : Label
@export var description : Label
@export var proceed_button : Button

@export_category("Configurations")
@export var selected_border_color : Color = Color(0.2, 0.8, 1.0)
@export var hover_border_color : Color = Color(0.3,0.3,.7)
@export var border_thickness : int = 4

@export var _is_opened : bool = false

@export var open_x_position : float = 1021.0
@export var closed_x_position : float = 1621.0
@export var weight : float = 0.1
var is_ui_frozen : bool = false
var is_reopening : bool = false

func close_animal_panel():
	_is_opened = false

func set_animal_data(data : AnimalData, is_return : bool = false, is_return_success : bool = true):
	if _is_opened:
		is_reopening = true
		close_animal_panel()
		await get_tree().create_timer(.3).timeout
		is_reopening = false
		show_animal_panel()
	
	image.texture = data.image
	title.text = data.title
	subtitle.text = data.subtitle
	if !is_return:
		description.text = data.description
	else:
		if is_return_success:
			description.text = data.success_text
		else:
			description.text = data.incorrect_text

func show_animal_panel():
	if !is_reopening:
		_is_opened = true

func _on_proceed_pressed():
	close_animal_panel()

func _style_proceed_button():
	var stylebox := StyleBoxFlat.new()
	stylebox.bg_color = Color(0, 0, 0, 0)
	
	stylebox.border_color = selected_border_color
	stylebox.set_border_width_all(border_thickness)
	stylebox.set_expand_margin_all(border_thickness)

	proceed_button.add_theme_stylebox_override("pressed", stylebox)
	
	var stylebox2 := StyleBoxFlat.new()
	stylebox.bg_color = Color(0, 0, 0, 0)
	
	stylebox.border_color = selected_border_color
	stylebox.set_border_width_all(border_thickness)
	stylebox.set_expand_margin_all(border_thickness)
	
	proceed_button.add_theme_stylebox_override("hover", stylebox2)

# Called when the node enters the scene tree for the first time.
func _ready():
	_style_proceed_button()
	proceed_button.connect("pressed", Callable(self, "_on_proceed_pressed"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var window_size = DisplayServer.window_get_size()
	
	var desired_position = closed_x_position
	
	if _is_opened:
		desired_position = open_x_position
		
	position.x = lerp(position.x, desired_position, weight)
	
