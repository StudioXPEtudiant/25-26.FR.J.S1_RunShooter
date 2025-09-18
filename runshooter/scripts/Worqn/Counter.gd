extends Node

@export var initial_value :int
@export var max_value :int
@export var min_value :int

var value :int

signal on_min()
signal on_max()
signal on_value_change(new_value :int)


func _ready():
	set_curent_value(initial_value)

func set_curent_value(new_value :int):
	value = new_value
	
	if value >= max_value:
		value = max_value
		on_max.emit()
	
	if value <= min_value:
		value = min_value
		on_min.emit()
	
	on_value_change.emit(value)

func increment():
	value += 1
	
	if value >= max_value:
		value = max_value
		on_max.emit()
	
	on_value_change.emit(value)

func decrementBy(valueDec):
	value -= valueDec
	
	if value <= min_value:
		value = min_value
		on_min.emit()
	
	on_value_change.emit(value)

func decrement():
	decrementBy(1)
