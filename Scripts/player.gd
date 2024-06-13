extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D

const SPEED_f = 130.0
const JUMP_VELOCITY_f = -450.0
const MIN_JUMP_VELOCITY_f = -300.0
const JUMP_VELOCITY_ACC_f = -3000

var current_jump_input_f = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity_f = ProjectSettings.get_setting("physics/2d/default_gravity")

var arrow_prefab_o = null

var current_direction_f = 1

@onready var ui_manager_o = %UIManager

@export var arrows_in_stock_i = 2
@export var life_i = 3

func player():
	pass

func increase_arrow():
	arrows_in_stock_i += 1
	ui_manager_o.update_arrow(arrows_in_stock_i)

func can_get_arrow():
	if arrows_in_stock_i < 2:
		return true
	return false

func _ready():
	# Godot loads the Resource when it reads this very line.
	arrow_prefab_o = load("res://Prefabs/arrow.tscn")

func handle_movement(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity_f * delta
		
	# Handle jump.
	if Input.is_action_pressed("Jump") and is_on_floor():
		current_jump_input_f += delta * JUMP_VELOCITY_ACC_f
		if current_jump_input_f <= JUMP_VELOCITY_f:
			current_jump_input_f = 0
			velocity.y = JUMP_VELOCITY_f
	
	if Input.is_action_just_released("Jump") and is_on_floor():
		if current_jump_input_f > MIN_JUMP_VELOCITY_f:
			current_jump_input_f = MIN_JUMP_VELOCITY_f
		velocity.y = current_jump_input_f
		current_jump_input_f = 0
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_f = Input.get_axis("MoveLeft", "MoveRight")
	
	if direction_f > 0:
		animated_sprite_2d.flip_h = false
		current_direction_f = 1
	elif direction_f < 0:
		animated_sprite_2d.flip_h = true
		current_direction_f = -1
	
	if is_on_floor():
		if direction_f == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("jump")
		
	if direction_f:
		velocity.x = direction_f * SPEED_f
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED_f)

	move_and_slide()	
	
func handle_shoot():
	if Input.is_action_just_pressed("Shoot") && arrows_in_stock_i > 0:
		
		var direction_horizontal_f = Input.get_axis("MoveLeft", "MoveRight")
		var direction_vertical_f = Input.get_axis("MoveUp", "MoveDown")
		
		var dir = Vector2(direction_horizontal_f, direction_vertical_f)
		if dir == Vector2.ZERO:
			dir.x = current_direction_f
		
		arrows_in_stock_i -= 1
		ui_manager_o.update_arrow(arrows_in_stock_i)
		var arrow_instantiated_o = arrow_prefab_o.instantiate()
		arrow_instantiated_o.position = position + dir * 20
		arrow_instantiated_o.set_direction(dir)
		get_tree().root.add_child(arrow_instantiated_o)

func _physics_process(delta):
	handle_movement(delta)
	
	handle_shoot()

func take_damage(instant_kill_b, sender	):
	if instant_kill_b:
		reload_scene.call_deferred()
		return
	
	life_i -= 1
	ui_manager_o.update_life(life_i)
	if life_i <= 0:
		reload_scene.call_deferred()

func reload_scene():
	get_tree().reload_current_scene()
