extends Panel
class_name AnimatedDicesManager

@export var dices : Array[AnimatedDiceButton]
@export var proceed_button : Button
@onready var d_range = range(len(dices))
var alpha : float = 0
@export var fade_duration : float = 3
# Called when the node enters the scene tree for the first time.
signal on_proceed_clicked(total_sum)

func _ready():
	visible = false
	modulate.a = 0
	proceed_button.connect("pressed", Callable(self, "_on_proceed_clicked"))

func tween_to(variable_name : String, target, duration: float) -> Tween:
	var t = create_tween()
	t.tween_property(self, variable_name, target, duration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	return t

func roll_dices(values : Array[int]):
	visible = true
	tween_to("alpha", 1, fade_duration)
	
	for i in d_range:
		dices[i].create_dice_queue(values[i])
	
func _on_proceed_clicked():
	var t = tween_to("alpha", 0, fade_duration/2)
	t.finished.connect(tween_ended)
	
	emit_signal("on_proceed_clicked", get_selected_dices_value()) 

func tween_ended():
	visible = false

func get_selected_dices_value() -> int:
	var selected_dices = dices.filter(func (x : AnimatedDiceButton): return x.is_selected)
	var values : Array[int]
	values.assign(selected_dices.map(func (x : AnimatedDiceButton) -> int: return x.value)) 
	
	if values.is_empty():
		return dices.map(func (x : AnimatedDiceButton) -> int: return x.value).reduce(func (x, y): return x+y)
	return values.reduce(func (x, y): return x+y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	modulate.a = alpha
