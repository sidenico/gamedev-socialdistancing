extends CharacterBody2D

@onready var slowdown_timer = $Timer

@export var speed : float = 150
@export var max_health: int = 100
var health: int = max_health
@export var slowdown_multiplier : float = 0.5
@export var slowdown_duration : float = 5.0
var base_speed : float

var last_direction = "down"

var is_hurt: bool = false
@export var hurt_duration: float = 0.3

var health_bar_ref: Node = null

func _ready():
	base_speed = speed

func _physics_process(_delta: float) -> void:
	if is_hurt:
		velocity = Vector2.ZERO  # optionally stop movement while hurt
		return  # skip normal animation updates while hurt

	# Input direction
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	if Input.is_action_pressed("down"):
		last_direction = "down"
		$AnimatedSprite2D.play("walk_down")
	
	if Input.is_action_pressed("up"):
		last_direction = "up"
		$AnimatedSprite2D.play("walk_up")
		
	if Input.is_action_pressed("right"):
		last_direction = "right"
		$AnimatedSprite2D.play("walk_right")
		
	if Input.is_action_pressed("left"):
		last_direction = "left"
		$AnimatedSprite2D.play("walk_left")
	
	if not Input.is_anything_pressed():
		$AnimatedSprite2D.play("idle_%s" % last_direction)
	
	# Update velocity
	velocity = input_direction * speed

	move_and_slide()

func apply_slowdown():
	speed = base_speed * slowdown_multiplier
	slowdown_timer.stop()      # stop any running timer
	slowdown_timer.start(slowdown_duration)  # start fresh

func set_health_bar(bar: Node):
	health_bar_ref = bar

func apply_damage(damage: int):
	health -= damage
	play_hurt_animation()
	if health_bar_ref:
		health_bar_ref.set_health(health)
	if health <= 0:
		game_over()

func game_over():
	queue_free()

func _on_timer_timeout():
	speed = base_speed

func play_hurt_animation():
	if is_hurt:
		return  # already playing hurt animation
	is_hurt = true

	# Play the correct directional hurt animation
	$AnimatedSprite2D.play("hurt_%s" % last_direction)

	# Restore normal animation after duration
	await get_tree().create_timer(hurt_duration).timeout
	is_hurt = false
