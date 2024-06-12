extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var timer = $TimerDeath
@onready var timer_hit = $TimerHit
@onready var timer_attack = $TimerAttack
@onready var collision_shape_2d = $CollisionShape2D
@onready var kill_zone = $KillZone
@onready var attack_detection_area_2d = $AttackDetectionArea2D

var projectile_prefab_o = null
var gold_prefab_o = null

const SPEED_f = 30
const ATTACK_DISTANCE_f = 50

@export var life_i = 1
@export var gold_drop_i = 3

var player_to_damage_o = null

#Taken hit
var hit_b = false
var is_attacking_b = false

func _ready():
	projectile_prefab_o = load("res://Prefabs/batProjectile.tscn")
	gold_prefab_o = load("res://Prefabs/coin.tscn")

func _process(delta):
	if life_i <= 0:
		return
	elif hit_b:
		return
	elif is_attacking_b:
		return
	
	if !player_to_damage_o:
		return
	
	var dir_v2 = player_to_damage_o.position - position
	
	if position.distance_to(player_to_damage_o.position) <= ATTACK_DISTANCE_f:
		is_attacking_b = true
		animated_sprite_2d.play("attack")
		timer_attack.start()
		var projectile_instantiated_o = projectile_prefab_o.instantiate()
		projectile_instantiated_o.position = position + dir_v2.normalized() * 10
		projectile_instantiated_o.set_sender(self)
		projectile_instantiated_o.set_direction(dir_v2.normalized())
		get_tree().root.add_child(projectile_instantiated_o)
		return
	
	position += delta * SPEED_f * dir_v2.normalized()
	animated_sprite_2d.play("idle")
	
	if player_to_damage_o.position.x < position.x:
		animated_sprite_2d.flip_h = true 
	if player_to_damage_o.position.x > position.x:
		animated_sprite_2d.flip_h = false

func take_damage(in_instant_kill_b, sender):
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
	for i in range(gold_drop_i):
		var gold_instantiated_o = gold_prefab_o.instantiate()
		gold_instantiated_o.position = position + Vector2.RIGHT * randf_range(-10, 10)
		get_tree().root.add_child(gold_instantiated_o)
	queue_free()

func _on_timer_hit_timeout():
	timer_hit.stop()
	hit_b = false

func _on_timer_attack_timeout():
	timer_attack.stop()
	is_attacking_b = false

func _on_attack_detenction_area_2d_body_entered(body):
	if life_i <= 0:
		return
	if body.has_method("player"):
		player_to_damage_o = body

func _on_attack_detection_area_2d_body_exited(body):
	if life_i <= 0:
		return
	if body.has_method("player"):
		player_to_damage_o = null
