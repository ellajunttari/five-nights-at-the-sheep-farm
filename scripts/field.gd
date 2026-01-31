extends Node2D

#Handles what state of a cycle it is
enum State {MORNING, EVENING, RESULT, END}

############# Variables #################

#how many days
var _current_day : int = 1
#is it morning or evening
var _is_morning : bool = true
#how many wolves have been found
var wolf_count : int = 0
#how many sheep in aitaus
var sheeps_in : int = 0
#how many wolves in aitaus
var wolves_in: int = 0
#how many sheep to spawn
var spawn_this_many_sheep: int = 2
#How many wolves to spawn
var spawn_this_many_wolf: int = 2
#how many picks left aka how many sacks left
var picks_left = Global.picks_left
#current state
var current_state = State.MORNING
#How many sheep to delete
var delete_this_many_sheep = 0

############ Function ###############

#go to the next day
func next_day():
	_current_day += 1
	

#function to delete sheeps
func deleteSheep(how_many):
	#reduce sheep count
	if (how_many != 0):
		sheeps_in -= how_many


#function to reduce picks
func reduce_picks():
	if (picks_left == 0):
		return
	picks_left -= 1
#function to restart picks
func restart_picks():
	picks_left = 5

####################################

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Show what day it is
	var my_label = Label.new()
	my_label.text = "Day " + str(_current_day)
	add_child(my_label)
	my_label.position = Vector2(50, 50)
	my_label.z_index = 999
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
