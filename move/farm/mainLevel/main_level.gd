extends Node2D

enum State {MORNING, EVENING, END, RESULT}
var current_state = State.MORNING

const WOLF_SCENE: PackedScene = preload(GameManager.SCENE_PATHS.wolf)
const SHEEP_SCENE: PackedScene = preload(GameManager.SCENE_PATHS.sheep)

var spawn_this_many_sheep: int = 2
var spawn_this_many_wolf: int = 2

func _ready() -> void:
	# Show what day it is
	var my_label = Label.new()
	my_label.text = "Day " + str(GameManager._current_day)
	add_child(my_label)
	my_label.position = Vector2(50, 50)
	
	var my_label2 = Label.new()
	my_label2.text = str(GameManager._is_morning)
	add_child(my_label2)
	my_label2.position = Vector2(50, 80)
	
	#GameManager.time_toggled.connect(_on_time_changed)
	
	#yritän ymmärtää tätä JA
	#GameManager.day_changed.connect(_on_day_updated)
	
	# Force initial state display
	change_state(State.MORNING)
	
	var button = Button.new()
	button.text = "change"
	button.pressed.connect(_on_time_changed.bind(button_pressed()))
	add_child(button)
	
func button_pressed():
	GameManager.toggle_time()
	#_on_time_changed(GameManager._is_morning)

func _on_time_changed(is_morning: bool):
	# Map the boolean fact to a specific scene state
	change_state(State.MORNING if is_morning else State.EVENING)
		
#JA TÄTÄ
func _on_day_updated(new_day: int):
	# If the day changes, you might want to show a 'Day X' screen
	change_state(State.RESULT)


func change_state(new_state):
	current_state = new_state
	match current_state:
		State.MORNING:
			# Show the aitaus with sheeps (and wolves)
			# Show the bags
			#how many picks left
			var picks_left = 5
			
			#determine how many sheep and how many wolf to spawn
			
			
			var my_label = Label.new()
			my_label.text = "It's now Morning!"
			add_child(my_label)
			my_label.position = Vector2(500, 300) # Move it to the center of the screen
			# spawn x sheep and x wolves
			spawn_animal(SHEEP_SCENE, spawn_this_many_sheep)
			spawn_animal(WOLF_SCENE, spawn_this_many_wolf)
			
			# delete x sheep (can be 0-x)
			
			# When all bags full (and something else) turn the day into evening
			#if():
				#GameManager.toggle_time()
			
		State.EVENING:
			# Show sheeps (and wolves) in a line
			# Show show flashlight
			# pick one of the sheep
			# ask player if sure of their choice
			# move into the result
			
			var my_label = Label.new()
			my_label.text = "It's now Evening!"
			add_child(my_label)
			my_label.position = Vector2(500, 300) # Move it to the center of the screen
			
		State.RESULT:
			# Show that did player find wolf or sheep
			# if found wolf --> wolf.count + 1 --> somehow give to the morning 
			# how many sheep and how many wolf to  
			
			#if (not dead):
				#GameManager.next_day()
			pass
		State.END:
			#Show the wolves having BBG + end
			pass
			

#Functions
func spawn_animal(animal_blueprint: PackedScene, count: int)-> void:
	# Get the center of the screen dynamically
	var screen_center = get_viewport_rect().size / 2
	
	for i in range(count):
		var animal = animal_blueprint.instantiate()
		add_child(animal)
		animal.position = screen_center + Vector2(randf_range(-50, 50), randf_range(-50, 50))
		animal.scale = Vector2(0.1, 0.1)
