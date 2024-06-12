extends Area2D

@onready var body_collision_shape_2d = $BodyCollisionShape2D

var force_f = 75
var velocity_v2 = Vector2.ZERO
var direction_v2 = Vector2.ZERO

var sender_o = null

func _ready():
	velocity_v2 = direction_v2 * force_f

func _on_body_entered(body):
	if body == self || body == sender_o:
		return
		
	if body.has_method("take_damage"):
		body.take_damage(false, self)
	print(body.name)
	queue_free()

func _process(_delta):
	body_collision_shape_2d.disabled = false

func _physics_process(delta):
	position += velocity_v2 * delta

func set_direction(in_direction_v2):
	direction_v2 = in_direction_v2
	direction_v2 = direction_v2.normalized()

func set_sender(in_sender_o):
	sender_o = in_sender_o
