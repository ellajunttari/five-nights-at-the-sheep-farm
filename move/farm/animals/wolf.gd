extends CharacterBody2D

#Wolf has a 10% change of standing still (sheep 20%) and the range of movement 
#is 60-120 (sheep 60-90) 

#Variables
var speed : float = 60.0
var move_direction : Vector2 = Vector2.ZERO

################################
#Sprite handling
##############################
#sprite sheet for different variations
#This allows you to drag as many different sheep sprites as you want into a single list in the Inspector.
@export var variations: Array[Texture2D] = []
# --->
# 3. How to set it up in the Editor
# 	Select your NPC in the Scene tree.
#
# 	In the Inspector, find the Variations array.
#
# 	Change the Size from 0 to 5 (or however many sheep sprites you have).
#
# 	Drag each unique .png file into the empty slots.

#Tracking where head and tail is
@export var head_offset: Vector2 = Vector2.ZERO
@export var tail_offset: Vector2 = Vector2.ZERO
# 2. Finding the Values in the EditorYou don't need to guess the coordinates. 
# Follow these steps for each animal:
#	Open your Sheep scene.
#
#	Select the Sprite2D.
#
#	Hover your mouse over the sheep's head in the viewport.
#
#	Look at the bottom-left of the editor; it will show the $x$ and $y$ coordinates.
#
#	Select the Sheep root node and type those $x$ and $y$ values into the head_offset in the Inspector.


func _ready():
	# Start the first move immediately
	_on_timer_timeout()
	
	#Sprite variation
	if variations.size() > 0:
		# Pick one random image from your list
		var random_sprite = variations.pick_random()
		$Sprite2D.texture = random_sprite
		
func get_head_position():
	# If the sprite is flipped, we have to flip the X offset too
	var current_offset = head_offset
	if $Sprite2D.flip_h:
		current_offset.x = -head_offset.x
	
	# Return the NPC position + the offset
	return global_position + current_offset
################################################3
	
func _physics_process(delta):
	
	if global_position.distance_to(get_global_mouse_position()) < 200:
		# Scared state: overrides the wander direction
		move_direction = (global_position - get_global_mouse_position()).normalized()
		speed = 200 
	else:
		# Calm state: uses the speed/direction from the Timer
		# No need to change move_direction here; it keeps the last random value
		pass 

	velocity = move_direction * speed
	move_and_slide()

func _on_timer_timeout():
	# 1. Roll a "dice" from 0 to 100
	var chance = randf_range(0, 100)
	
	# 2. 10% chance to stand still (Idle)
	if chance < 10:
		move_direction = Vector2.ZERO
		speed = 0
	# 3. 90% chance to walk
	else:
		speed = randf_range(60.0, 150.0)
		var random_x = randf_range(-1.0, 1.0)
		var random_y = randf_range(-1.0, 1.0)
		move_direction = Vector2(random_x, random_y).normalized()
