extends Area2D

var position_v2 = Vector2.ZERO
var is_frozen_b = false
var speed_fall_f = 100

func _on_body_enter(body):
	if body.is_in_group("Player"):
		get_node("/root/Node2D/GameManager").add_gold()
		queue_free()
	elif !body.has_method("take_damage"):
		is_frozen_b = true
		position_v2 = position

func _physics_process(delta):
	if is_frozen_b:
		position = position_v2
		return
	
	position += Vector2.DOWN * delta * speed_fall_f
