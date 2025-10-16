extends Button
class_name AnimatedDiceButton

func _on_pressed():
	is_selected = !is_selected
	_update_visual_state()

func _update_visual_state():
	var stylebox := StyleBoxFlat.new()
	
	if is_selected:
		stylebox.border_color = selected_border_color
		stylebox.set_border_width_all(border_thickness)
		stylebox.set_expand_margin_all(border_thickness) 
	else:
		stylebox.set_border_width_all(0)
		stylebox.set_expand_margin_all(0)

	# Apply style to all states
	add_theme_stylebox_override("normal", stylebox)
	add_theme_stylebox_override("hover", stylebox)
	add_theme_stylebox_override("pressed", stylebox)
	add_theme_stylebox_override("focus", stylebox)

# -----------------------------
# Exported / tunable variables
# -----------------------------
@export var spin_direction : int = 1            # 1 = left -> right (left expands), -1 = right -> left (right expands)
@export var max_scale : float = 1.0            # maximum scale for the expanding side
@export var rotations_rand_len : Vector2i = Vector2i(3, 6) # (min, max) random number of rotations
@export var left_side : TextureRect
@export var left_side_dice : TextureRect
@export var right_side : TextureRect
@export var right_side_dice : TextureRect
@export var dice_textures_folder : String = "res://assets/ui/dice_sprites"
@export var animation_time : float = 2      # total animation time across all rotations
@export var selected_border_color : Color = Color(0.2, 0.8, 1.0) # light blue border when selected
@export var border_thickness : int = 4


# -----------------------------
# Internal / runtime variables
# -----------------------------
var is_selected : bool = false
var scales : Vector2 = Vector2(max_scale, 0)   # Vector2(x, y) where x + y = 1 (initially left full)
var end_position : int = 1                     # not strictly required but kept for compatibility (1 = right, -1 = left)
var left_side_value : int = -1
var right_side_value : int = -1

var rps : float = 1.0                          # rates per second (computed after queue built)
var can_spin : bool = true
var folder_ref : RefCounted
var dice_sprites : Array = []
var time : float = 2.0                         # seconds (not used directly; kept for compatibility)
var dice_queue : Array[int] = []

var is_spinning : bool = false
var value : int = 1

# -----------------------------
# Utilities / lifecycle
# -----------------------------
func _ready():
	# enforce spin_direction to be either -1 or 1
	connect("pressed", Callable(self, "_on_pressed"))
	_update_visual_state()
	
	if spin_direction >= 0:
		spin_direction = 1
	else:
		spin_direction = -1

	# load dice sprites (keeps same default list as before)
	dice_sprites = [
		load("res://assets/ui/dice_sprites/1.svg"),
		load("res://assets/ui/dice_sprites/2.svg"),
		load("res://assets/ui/dice_sprites/3.svg"),
		load("res://assets/ui/dice_sprites/4.svg"),
		load("res://assets/ui/dice_sprites/5.svg"),
		load("res://assets/ui/dice_sprites/6.svg")
	]

	folder_ref = DirAccess.open(dice_textures_folder)

	# initialize queue and initial side values
	create_dice_queue(4)
	_init_side_values()
	_update_dice_scales()
	_refresh_dice_textures()

func _init_side_values():
	# If sides are empty, fill them from queue if available
	if left_side_value == -1 and dice_queue.size() > 0:
		left_side_value = dice_queue.pop_front()
	if right_side_value == -1 and dice_queue.size() > 0:
		right_side_value = dice_queue.pop_front()

	# Set initial scales according to spin direction:
	# spin_direction == 1 -> left is "expanded" side initially (left scale = max)
	# spin_direction == -1 -> right is expanded initially
	if spin_direction == 1:
		scales = Vector2(max_scale, 0)
	else:
		scales = Vector2(0, max_scale)

# -----------------------------
# Dice queue / random helpers
# -----------------------------
func _dice_roll() -> int:
	return randi_range(1, 6)

func create_dice_queue(last: int = -1):
	can_spin = true
	dice_queue.clear()
	for i in range(randi_range(rotations_rand_len.x, rotations_rand_len.y)):
		var roll : int = _dice_roll()
		# avoid immediate duplicate with previous queued value
		if !dice_queue.is_empty():
			# re-roll until different from last queued
			while roll == dice_queue[dice_queue.size() - 1]:
				roll = _dice_roll()
		dice_queue.append(roll)
	
	if last != -1:
		# append a final forced value
		if dice_queue.size() == 0 or dice_queue[dice_queue.size() - 1] != last:
			dice_queue.append(last)
		
	value = dice_queue.back()

	# compute rate relative to animation_time
	if animation_time > 0:
		rps = float(dice_queue.size()) / animation_time
	else:
		rps = 1.0

# -----------------------------
# Switch / update sides logic
# -----------------------------
func _on_scale_reached_target():
	_switch_sides()

func _switch_sides():
	# If nothing queued, stop
	if dice_queue.is_empty():
		can_spin = false
		return

	# Directional behavior:
	# If spin_direction == 1, the left side just finished expanding.
	# If spin_direction == -1, the right side just finished expanding.
	if spin_direction == 1:
		# left finished expanding: shift values so right becomes previous left,
		# and left receives the next queued value
		if left_side_value == -1:
			# first-time fill
			left_side_value = dice_queue.pop_front()
		else:
			# move previous left to right, pop next into left
			right_side_value = left_side_value
			left_side_value = dice_queue.pop_front()
		# reset scales for next rotation: left collapsed, right full
		scales = Vector2(0, max_scale)
	else:
		# right finished expanding: shift values so left becomes previous right,
		# and right receives the next queued value
		if right_side_value == -1:
			right_side_value = dice_queue.pop_front()
		else:
			left_side_value = right_side_value
			right_side_value = dice_queue.pop_front()
		# reset scales for next rotation: left full, right collapsed
		scales = Vector2(max_scale, 0)

	_refresh_dice_textures()
	_update_dice_scales()

func _refresh_dice_textures():
	# guard in case values are still -1
	if right_side_value > 0:
		right_side_dice.texture = dice_sprites[right_side_value - 1]
	if left_side_value > 0:
		left_side_dice.texture = dice_sprites[left_side_value - 1]

func _update_dice_scales():
	left_side.scale.x = scales.x
	right_side.scale.x = scales.y

# -----------------------------
# Frame update (direction-aware)
# -----------------------------
func _process(delta):
	if !can_spin:
		return

	# Apply directional scaling: when spin_direction == 1, left grows and right shrinks.
	# When spin_direction == -1, right grows and left shrinks.
	if spin_direction == 1:
		scales.x = clamp(scales.x + delta * rps, 0.0, max_scale)
		scales.y = clamp(scales.y - delta * rps, 0.0, max_scale)
		# trigger when left reached max
		if scales.x >= max_scale:
			_on_scale_reached_target()
	else:
		scales.x = clamp(scales.x - delta * rps, 0.0, max_scale)
		scales.y = clamp(scales.y + delta * rps, 0.0, max_scale)
		# trigger when right reached max
		if scales.y >= max_scale:
			_on_scale_reached_target()

	_update_dice_scales()
