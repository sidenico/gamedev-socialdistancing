extends CharacterBody2D

enum State { HEALTHY, SICK }
@export var state: State = State.HEALTHY
@export var speed: float = 100.0


func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	update_color()

func _physics_process(delta):
	var direction: Vector2
	if velocity == Vector2.ZERO or randf() < 0.01:
		# Pick new random direction
		direction = Vector2(randi_range(-1, 1), randi_range(-1, 1))   
		velocity = direction.normalized() * speed
	
	if direction.y == 1:
		$AnimatedSprite2D.play("walk_down")
	
	if direction.y == -1:
		$AnimatedSprite2D.play("walk_up")
		
	if direction.x == 1:
		$AnimatedSprite2D.play("walk_right")
		
	if direction.x == -1:
		$AnimatedSprite2D.play("walk_left")
	
	move_and_slide()

func infect():
	if state == State.HEALTHY:
		state = State.SICK
		update_color()

func update_color():
	if state == State.HEALTHY:
		$AnimatedSprite2D.modulate = Color(0, 1, 0) # green
	else:
		$AnimatedSprite2D.modulate = Color(1, 0, 0) # red

func _on_body_entered(body):
	if body.is_in_group("player"):
		if state == State.HEALTHY:
			body.apply_slowdown()
		elif state == State.SICK:
			body.apply_slowdown()
			body.apply_damage(10)
	if body.is_in_group("npc"):
		if state == State.SICK and body.state == State.HEALTHY:
			if randf() < 0.2:
				body.infect()
