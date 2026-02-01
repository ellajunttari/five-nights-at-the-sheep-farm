extends RigidBody2D

var is_held = false
var can_be_picked_up = true # New variable

func _ready():
	# Ensure the wool doesn't fall off the sheep immediately
	freeze = true
	add_to_group("draggables")

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Check BOTH if it's not held AND if it's allowed to be picked up
			if not is_held and can_be_picked_up and not Global.is_mouse_busy:
				#Checks if player is able to pickup the furball
				if Global.picks_left > 0: 
					pickup()

func pickup():
	if get_parent().name == "fur": 
		Global.is_mouse_busy = true # Lock the mouse
		var fur = get_parent()
		var animal = fur.get_parent()
		if animal.animal_type == "wolf":
			print("PhysicsWulf")
			animal.picked_fur += 1
			if animal.picked_fur == 5:
				surprise()
		else:
			pass
		is_held = true
		freeze = true
		z_index = 100
		reparent.call_deferred(get_tree().current_scene)
		#reduce the global variable picks_left if its not 0
		if(Global.picks_left > 0): Global.picks_left -= 1
		
func surprise():
	print("surprise")
	var overlay_node = get_tree().current_scene.find_child("overlay", true, false)
	var surprise_node = overlay_node.get_node("surprise")
	surprise_node.visible = true
	var background_music = get_tree().current_scene.find_child("BackgroundMusic", true, false)
	background_music.stop()
	var surprise_music = get_tree().current_scene.find_child("SurpriseMusic", true, false)
	surprise_music.play()
	print("surprise")
	#jotenkin niin, että päivä alkaa alusta. Nyt pelaaja joutuu sulkemaan ja avaaamaan pelin uudestaan
	
	var shake_intensity = 20.0
	var tween = create_tween()
	
	for i in range(10):
		# We create a random direction
		var random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * shake_intensity
		
		# 1. Move AWAY from the center (relative to current position)
		tween.tween_property(surprise_node, "position", random_direction, 0.01).as_relative()
		
		# 2. Move BACK to the center (the exact opposite move)
		tween.tween_property(surprise_node, "position", -random_direction, 0.01).as_relative()

func drop():
	is_held = false
	freeze = false
	z_index = 0
	Global.is_mouse_busy = false
	
	# Disable future pick-ups
	can_be_picked_up = false 
	
	# Optional: Remove from the group so it's no longer "draggable"
	remove_from_group("draggables")
	if Global.picks_left <= 0:
		Global.picks_left = -1

func _physics_process(_delta):
	if is_held:
		# The ball follows the mouse perfectly
		global_position = get_global_mouse_position()
		
		# Reset velocity so it doesn't build up "gravity speed" while held
		linear_velocity = Vector2.ZERO
