extends Node2D

@onready var right_ray_cast_2d = $RightRayCast2D
@onready var left_ray_cast_2d = $LeftRayCast2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var timer = $TimerDeath
@onready var timer_hit = $TimerHit
@onready var timer_attack = $TimerAttack
@onready var timer_attack_end = $TimerAttackEnd
@onready var collision_shape_2d = $CollisionShape2D
@onready var kill_zone = $KillZone
@onready var attack_detection_area_2d = $AttackDetectionArea2D
@onready var attack_area_2d = $AttackArea2D

const SPEED_f = 30

var direction_i = 1

@export var life_i = 2

var player_to_damage_o = null

#Taken hit
var hit_b = false

@export var is_attacking_b = false

func _process(delta):
	if life_i <= 0:
		return
	elif hit_b:
		return
	elif is_attacking_b:
		return
	
	if right_ray_cast_2d.is_colliding():
		direction_i = -1
		animated_sprite_2d.flip_h = true 
		attack_area_2d.rotation_degrees = 180
		attack_detection_area_2d.rotation_degrees = 180
	if left_ray_cast_2d.is_colliding():
		direction_i = 1
		animated_sprite_2d.flip_h = false
		attack_area_2d.rotation_degrees = 0
		attack_detection_area_2d.rotation_degrees = 0
	
	position.x += delta * SPEED_f * direction_i
	
	animated_sprite_2d.play("hop")

func take_damage(in_instant_kill_b):
	if life_i <= 0:
		return
	elif hit_b:
		return
	
	life_i -= 1
	if life_i <= 0:
		collision_shape_2d.queue_free()
		animated_sprite_2d.play("death")
		kill_zone.queue_free()
		timer.start()
	else:
		hit_b = true
		animated_sprite_2d.play("hurt")
		timer_hit.start()

func _on_timer_timeout():
	queue_free()

func _on_timer_hit_timeout():
	timer_hit.stop()
	hit_b = false

func _on_timer_attack_timeout():
	timer_attack.stop()
	timer_attack_end.start()
	if player_to_damage_o:
		player_to_damage_o.take_damage(false)
		player_to_damage_o = null

func _on_attack_area_2d_body_entered(body):
	if body.has_method("player"):
		if is_attacking_b:
			body.take_damage(false)
		else:
			player_to_damage_o = body

func _on_timer_attack_end_timeout():
	timer_attack_end.stop()
	is_attacking_b = false

func _on_attack_detenction_area_2d_body_entered(body):
	if body.has_method("player"):
		is_attacking_b = true
		animated_sprite_2d.play("attack")
		timer_attack.start()

func _on_attack_area_2d_body_exited(body):
	if body.has_method("player"):
		player_to_damage_o = null
