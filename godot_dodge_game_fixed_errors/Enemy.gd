extends Area2D

var direction = Vector2.ZERO
var speed = 200.0

func _ready():
	body_entered.connect(_on_body_entered)

func setup(start_pos: Vector2, target_direction: Vector2, enemy_speed: float):
	position = start_pos
	direction = target_direction.normalized()  
	speed = enemy_speed

func _process(delta):
	position += direction * speed * delta

	# Remove when off screen (with margin)
	if position.x < -50 or position.x > 690 or position.y < -50 or position.y > 530:
		queue_free()

func _on_body_entered(body):
	if body.name == "Player":
		print("Player hit! Game Over!")
		get_tree().reload_current_scene()
