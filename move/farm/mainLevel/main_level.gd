extends Node2D

enum State {MORNING, EVENING, END, RESULT}
var current_state = State.MORNING

const WOLF_SCENE: PackedScene = preload(GameManager.SCENE_PATHS.wolf)
const SHEEP_SCENE: PackedScene = preload(GameManager.SCENE_PATHS.sheep)

var spawn_this_many_sheep: int = 2
var spawn_this_many_wolf: int = 2

func _ready() -> void:
	pass

func _on_time_changed(is_morning: bool):
	# Map the boolean fact to a specific scene state
	if is_morning:
		change_state(State.MORNING)
	else:
		change_state(State.EVENING)

func change_state(new_state):
	current_state = new_state
	match current_state:
		State.MORNING:
			# Show the aitaus with sheeps (and wolves)
			
			# Show the bags
			#how many picks left
			var picks_left = 5
			
			#determine how many sheep and how many wolf to spawn
			
			# spawn x sheep and x wolves
			spawn_animal(SHEEP_SCENE, spawn_this_many_sheep)
			spawn_animal(WOLF_SCENE, spawn_this_many_wolf)
			
			# delete x sheep (can be 0-x)
			
			# Show what day it is
			
			# When all bags full (and something else) turn the day into evening
			pass
		State.EVENING:
			# Show sheeps (and wolves) in a line
			# Show show flashlight
			# pick one of the sheep
			# ask player if sure of their choice
			# move into the result
			pass
		State.RESULT:
			# Show that did player find wolf or sheep
			# if found wolf --> wolf.count + 1 --> somehow give to the morning 
			# how many sheep and how many wolf to  
			pass
		State.END:
			#Show the wolves having BBG + end
			pass
			

#Functions
func spawn_animal(animal_blueprint: PackedScene, count: int)-> void:
	for i in range(count):
		var animal = animal_blueprint.instantiate()
		add_child(animal)
