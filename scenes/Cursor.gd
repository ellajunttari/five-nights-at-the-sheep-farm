extends Node2D

@onready var anim_player: AnimationPlayer = $Sprite2D/AnimationPlayer


func _enter_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _process(_delta: float) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_HIDDEN:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _physics_process(delta: float) -> void:
	global_position = lerp(
		global_position,
		get_global_mouse_position(),
		16.5 * delta
	)


func _input(event) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		anim_player.play("ClickingShears")
		
