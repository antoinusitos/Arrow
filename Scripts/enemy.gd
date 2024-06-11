extends Node2D

const SPEED_f = 30

var direction_i = 1

@onready var right_ray_cast_2d = $RightRayCast2D
@onready var left_ray_cast_2d = $LeftRayCast2D
@onready var animated_sprite_2d = $AnimatedSprite2D

var life_i = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if right_ray_cast_2d.is_colliding():
		direction_i = -1
		animated_sprite_2d.flip_h = true 
	if left_ray_cast_2d.is_colliding():
		direction_i = 1
		animated_sprite_2d.flip_h = false
	
	position.x += delta * SPEED_f * direction_i
	
func take_damage(in_instant_kill_b):
	life_i -= 1
	if life_i <= 0:
		queue_free()
