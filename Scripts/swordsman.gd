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

var player_entered_o = null

var is_blocking_b = false

#Taken hit
var hit_b = false

@export var is_attacking_b = false
var can_deal_damage = false

func _process(delta):
	if life_i <= 0:
		return
	elif hit_b:
		return
	elif is_attacking_b:
		return
	elif is_blocking_b:
		if player_entered_o:
			if player_entered_o.position.x < position.x:
				handle_flip_h(-1)
			else:
				handle_flip_h(1)
		return

	if right_ray_cast_2d.is_colliding():
		direction_i = -1
	if left_ray_cast_2d.is_colliding():
		direction_i = 1
	
	handle_flip_h(direction_i)
	
	position.x += delta * SPEED_f * direction_i
	
	animated_sprite_2d.play("walk")

func handle_flip_h(dir):
	if dir == 1:
		animated_sprite_2d.flip_h = false
		attack_area_2d.rotation_degrees = 0
		attack_detection_area_2d.rotation_degrees = 0
	elif dir == -1:
		animated_sprite_2d.flip_h = true 
		attack_area_2d.rotation_degrees = 180
		attack_detection_area_2d.rotation_degrees = 180

func take_damage(in_instant_kill_b, sender):
	if life_i <= 0:
		return
	elif hit_b:
		return
	
	if sender.is_in_group("arrow") && is_blocking_b:
		sender.velocity_v2 = Vector2(0, -1)
		return
	
	life_i -= 1
	if life_i <= 0:
		is_attacking_b = false
		is_blocking_b = false
		timer_attack.stop()
		timer_attack_end.stop()
		collision_shape_2d.queue_free()
		animated_sprite_2d.play("default")
		kill_zone.queue_free()
		timer.start()
	else:
		hit_b = true
		animated_sprite_2d.play("hurt")
		timer_hit.start()

func _on_timer_death_timeout():
	queue_free()

func _on_timer_hit_timeout():
	hit_b = false
	timer_hit.stop()

func _on_timer_attack_timeout():
	timer_attack.stop()
	timer_attack_end.start()
	can_deal_damage = true
	if player_to_damage_o:
		player_to_damage_o.take_damage(false, self)
		player_to_damage_o = null

func _on_attack_area_2d_body_entered(body):
	if life_i <= 0:
		return
	if body.has_method("player"):
		if can_deal_damage:
			body.take_damage(false, self)
		else:
			player_to_damage_o = body

func _on_timer_attack_end_timeout():
	timer_attack_end.stop()
	can_deal_damage = false
	is_attacking_b = false
	if life_i <= 0:
		return
	if player_entered_o:
		is_blocking_b = true
		animated_sprite_2d.play("block")

func _on_attack_detection_area_2d_body_entered(body):
	if life_i <= 0:
		return
	if body.has_method("player"):
		print("attack")
		is_attacking_b = true
		is_blocking_b = false
		animated_sprite_2d.play("attack")
		timer_attack.start()

func _on_attack_area_2d_body_exited(body):
	if body.has_method("player"):
		player_to_damage_o = null

func _on_player_detection_area_2d_body_entered(body):
	if life_i <= 0:
		return
	if body.has_method("player"):
		player_entered_o = body
		is_blocking_b = true
		animated_sprite_2d.play("block")

func _on_player_detection_area_2d_body_exited(body):
	if body.has_method("player"):
		player_entered_o = null
		is_blocking_b = false
