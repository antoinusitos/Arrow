extends Node2D

const SPEED_f = 60

var direction_i = 1

@onready var right_ray_cast_2d = $RightRayCast2D
@onready var left_ray_cast_2d = $LeftRayCast2D
@onready var animated_sprite_2d = $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if right_ray_cast_2d.is_colliding():
		direction_i = -1
		animated_sprite_2d.flip_h = true
	if left_ray_cast_2d.is_colliding():
		direction_i = 1
		animated_sprite_2d.flip_h = false
	
	position.x += delta * SPEED_f * direction_i

func take_damage():
	queue_free()
