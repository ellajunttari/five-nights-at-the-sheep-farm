extends Node2D

@onready var anim_player: AnimationPlayer = $Sprite2D/AnimationPlayer


func _enter_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

	# Listen for animation end
	anim_player.animation_finished.connect(_on_animation_finished)
	Global.Shears_Cursor = true


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
	and Global.Shears_Cursor == true\
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		anim_player.play("ClickingShears")

		var cursor_sound = get_tree().current_scene.find_child(
			"CursorAudio", true, false
		)
		if cursor_sound:
			cursor_sound.play()


func _on_animation_finished(anim_name: StringName) -> void:
	if Global.Shears_Cursor == false:
		anim_player.play("stooting")
