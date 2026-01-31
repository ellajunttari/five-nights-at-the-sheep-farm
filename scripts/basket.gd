extends Area2D

# Inside the Basket script
func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Loop through the group and only drop the one that is actually being held
		for ball in get_tree().get_nodes_in_group("draggables"):
			if ball.is_held: 
				ball.drop()
				# Optional: Move it into the basket position
				ball.global_position = global_position
