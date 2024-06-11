extends Area2D

@onready var game_manager = %GameManager

func _on_body_enter(body):
	queue_free()
	game_manager.add_point()
