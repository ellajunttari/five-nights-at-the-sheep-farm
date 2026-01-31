class_name	BaseClass
extends CharacterBody2D

#Variables
@export var base_speed: float = 60.0
var move_direction = Vector2.ZERO

#This should set the sprite
@export var npc_texture: Texture2D

func _ready():
	if npc_texture:
		# This finds your Sprite2D child and sets its image
		$Sprite2D.texture = npc_texture
	
	_on_timer_timeout()

#Movement
func _physics_process(delta):
	
	if global_position.distance_to(get_global_mouse_position()) < 200:
		# Scared state: overrides the wander direction
		move_direction = (global_position - get_global_mouse_position()).normalized()
		base_speed = 200 
	else:
		# Calm state: uses the speed/direction from the Timer
		# No need to change move_direction here; it keeps the last random value
		pass 
	
	velocity = move_direction * base_speed
	move_and_slide()

func _on_timer_timeout():
	# 1. Roll a "dice" from 0 to 100
	var chance = randf_range(0, 100)
	
	# 2. 20% chance to stand still (Idle)
	if chance < 20:
		move_direction = Vector2.ZERO
		base_speed = 0
	# 3. 80% chance to walk
	else:
		base_speed = randf_range(60.0, 100.0)
		var random_x = randf_range(-1.0, 1.0)
		var random_y = randf_range(-1.0, 1.0)
		move_direction = Vector2(random_x, random_y).normalized()
