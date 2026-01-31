extends Node

const SCENE_PATHS: Dictionary = {
	"wolf" : "uid://cgxnugrgqgk3",
	"sheep": "uid://ivi1rrcsyx26"
}

# Signals allow other nodes (like UI or NPCs) to react to changes
signal day_changed(_current_day)
signal time_toggled(_is_morning)
signal FOUND_WOLF(wolf_count)
signal MORE_SHEEPS(sheeps_in)
signal MORE_WOLVES(wolves_in)

#how many days
var _current_day : int = 1

#is it morning or evening
var _is_morning : bool = true

#how many wolves have been found
var wolf_count : int = 0:
	get:
		return wolf_count
	set(value):
		wolf_count += 1
		FOUND_WOLF.emit(wolf_count)

#how many sheep in aitaus
var sheeps_in : int = 0:
	get:
		return sheeps_in
	set(value):
		sheeps_in += value
		MORE_SHEEPS.emit(sheeps_in)

#how many wolves in aitaus
var wolves_in: int = 0:
	get:
		return wolves_in
	set(value):
		wolves_in += value
		MORE_WOLVES.emit(wolves_in)

func next_day():
	_current_day += 1
	_is_morning = true

func toggle_time():
	_is_morning = !_is_morning
