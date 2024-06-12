extends Node

var score_i = 0

@onready var ui_manager_o = %UIManager

func add_gold():
	score_i += 1
	ui_manager_o.update_gold(score_i)
