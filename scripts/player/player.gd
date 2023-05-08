extends CharacterBody2D

@onready var sprite: Sprite2D = get_node("Texture")

var jump_count: int = 0

var is_on_double_jump: bool = false
var is_dead: bool = false
var on_knockback: bool = false

var knockback_direction: Vector2
var max_health: float = 0.0

@export var health: float = 25.0

@export var move_speed: float = 32.0
@export var jump_speed: float = -256.0
@export var gravity_speed: float = 512.0

func _ready() -> void:
	max_health = health


func _physics_process(delta: float) -> void:
	if is_dead: 
		return
	
	if on_knockback:
		knockback_move()
		return
		
	move()
	velocity.y += delta * gravity_speed
	var _move := move_and_slide()
	jump()
	
	sprite.animate(velocity)
			
func knockback_move() -> void:
		var _move := move_and_slide() 
		sprite.animate(velocity) 

func  move() -> void:
	var direction: float = get_direction()
	velocity.x = direction * move_speed


func get_direction() -> float:
		return (
			Input.get_axis("walk_left", "walk_right")
		) 

func jump() -> void: 
		if is_on_floor():
			jump_count = 0
			is_on_double_jump = false
			
		if Input.is_action_just_pressed("jump") and jump_count < 2:
			velocity.y = jump_speed
			jump_count += 1

		if jump_count == 2 and not is_on_double_jump:
			sprite.action_behavior("double_jump")
			is_on_double_jump = true


func update_health(target_position: Vector2, value: int, type: String) -> void: 
		if is_dead:
			return
	
		if type == "decrease":
			knockback_direction = (global_position - target_position).normalized()
			sprite.action_behavior("hit")
			on_knockback = true
		
			health = clamp(health - value,0, max_health)
			return
		if type == "increase":
			health = clamp(health + value, 0, max_health)
		
		if health == 0:
			is_dead = true
			sprite.action_behavior("dead")
