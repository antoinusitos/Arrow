extends Area2D

@onready var timer = $Timer

@export var instant_kill_b = false

func _on_body_enter(body):
	if body.has_method("player"):
		body.take_damage(instant_kill_b, self)

func _on_timer_timeout():
	get_tree().reload_current_scene()
