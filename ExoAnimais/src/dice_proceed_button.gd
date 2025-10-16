extends Button

@export var dices : Array[AnimatedDiceButton]
#map(func (x): return x + Vector2(0, -8))
func _on_pressed():
	if (dices.any(_check_dice_state)):
		return
	
	print("success")

func _check_dice_state(x): 
	return x.is_spinning

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	connect("pressed", Callable(self, "_on_pressed"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
