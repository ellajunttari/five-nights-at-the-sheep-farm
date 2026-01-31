extends Area2D

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Tell all furballs to drop!
			get_tree().call_group("draggables", "drop")
			print("Basket clicked! Wool dropping...")
