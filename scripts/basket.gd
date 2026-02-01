extends Area2D

var is_full := false
@onready var sprite: Sprite2D = $Sprite2D
		
# Inside the Basket script
func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Loop through the group and only drop the one that is actually being held
			# HARD BLOCK: basket already has a ball
		if is_full:
			return
		for ball in get_tree().get_nodes_in_group("draggables"):
			if ball.is_held: 
				ball.drop()
				var bag_pop_sound = get_tree().current_scene.find_child("BagPop", true, false)
				bag_pop_sound.play()
				# Optional: Move it into the basket position
				ball.global_position = global_position
				is_full = true
				ball.queue_free()
				sprite.texture = preload("res://assets/sprites/sack_closed.png")
				break
				
func reset_basket():
	is_full = false
	sprite.texture = preload("res://assets/sprites/sack_open.png")
