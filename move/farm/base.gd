extends CharacterBody2D

#This should set the sprite
@export var npc_texture: Texture2D

func _ready():
	# This finds your Sprite2D child and sets its image
	$Sprite2D.texture = npc_texture


func _on_timer_timeout() -> void:
	pass # Replace with function body.
