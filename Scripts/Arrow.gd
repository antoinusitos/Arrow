extends Area2D

@onready var arrow_dody_collision_shape_2d = $ArrowDodyCollisionShape2D

var must_freeze_b = false

var force_f = 300
var rotation_f = 0
var position_v3 = Vector3.ZERO
var is_frozen_b = false

@export var mass_f = 0.25
var velocity_v2 = Vector2.ZERO

@export var start_frozen_b = false

var gravity_f = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction_v2 = Vector2.ZERO

func _ready():
	velocity_v2 = direction_v2 * force_f
	if start_frozen_b:
		must_freeze_b = true
		rotation_f = rotation
		position_v3 = position

func _on_body_entered(body):
	if body.has_method("take_damage") && !is_frozen_b:
		body.take_damage(false, self)
		return
	if body.has_method("increase_arrow") && body.can_get_arrow():
		queue_free()
		body.increase_arrow()
		return
	if !is_frozen_b:
		must_freeze_b = true
		rotation_f = rotation
		position_v3 = position

func _process(_delta):
	arrow_dody_collision_shape_2d.disabled = false
	if is_frozen_b:
		rotation = rotation_f
		position = position_v3

func _physics_process(delta):
	if is_frozen_b:
		return
		
	if must_freeze_b:
		must_freeze_b = false
		rotation = rotation_f
		position = position_v3
		velocity_v2 = Vector2.ZERO
		is_frozen_b = true
	else:
		position += velocity_v2 * delta
		velocity_v2.y += gravity_f * delta
		rotation = velocity_v2.angle()

func set_direction(in_direction_v2):
	direction_v2 = in_direction_v2
	direction_v2 = direction_v2.normalized()
