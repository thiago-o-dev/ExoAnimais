extends HBoxContainer

@export var dice_left : AnimatedDiceButton
@export var dice_right : AnimatedDiceButton
# Called when the node enters the scene tree for the first time.
func _ready():
	#dice_left.focus_entered.connect(select_dice_value(dice_left))
	
	#dice_left.focus_mode
	#dice_right.focus_entered.connect(select_dice_value(dice_right))
	pass
	
func select_dice_value(dice : AnimatedDiceButton):
	# select the dice button send a player movement event 
	pass
	
func desselect_dice_value(dice : AnimatedDiceButton):
	# desselect the dice button
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
