extends Node2D

@export var enemy_scene = preload("res://Enemy.tscn")
@export var min_speed = 200.0
@export var max_speed = 400.0
@export var spawn_rate = 1.0

var screen_width = 640
var screen_height = 480

func _ready():
	$SpawnTimer.timeout.connect(_on_spawn_timer_timeout)
	$SpawnTimer.wait_time = spawn_rate

func _on_spawn_timer_timeout():
	spawn_enemy()

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	get_parent().add_child(enemy)

	# Random speed between min and max
	var random_speed = randf_range(min_speed, max_speed)

	# Choose random direction from 8 directions
	var directions = [
		Vector2(1, 0),    # Right
		Vector2(-1, 0),   # Left
		Vector2(0, 1),    # Down
		Vector2(0, -1),   # Up
		Vector2(1, 1),    # Down-Right
		Vector2(1, -1),   # Up-Right
		Vector2(-1, 1),   # Down-Left
		Vector2(-1, -1)   # Up-Left
	]

	var chosen_direction = directions[randi() % directions.size()]
	var spawn_position = get_spawn_position(chosen_direction)

	enemy.setup(spawn_position, chosen_direction, random_speed)

func get_spawn_position(direction: Vector2) -> Vector2:
	var spawn_pos = Vector2.ZERO
	var margin = 50

	# Spawn outside screen based on direction
	if direction.x > 0:  # Coming from left
		spawn_pos.x = -margin
		spawn_pos.y = randf_range(0, screen_height)
	elif direction.x < 0:  # Coming from right
		spawn_pos.x = screen_width + margin
		spawn_pos.y = randf_range(0, screen_height)

	if direction.y > 0:  # Coming from top
		spawn_pos.y = -margin
		if direction.x == 0:  # Pure vertical movement
			spawn_pos.x = randf_range(0, screen_width)
	elif direction.y < 0:  # Coming from bottom
		spawn_pos.y = screen_height + margin
		if direction.x == 0:  # Pure vertical movement
			spawn_pos.x = randf_range(0, screen_width)

	# For diagonal directions, adjust both coordinates
	if direction.x != 0 and direction.y != 0:
		if direction.x > 0 and direction.y > 0:  # Down-Right (from top-left)
			spawn_pos = Vector2(-margin, -margin)
		elif direction.x > 0 and direction.y < 0:  # Up-Right (from bottom-left)
			spawn_pos = Vector2(-margin, screen_height + margin)
		elif direction.x < 0 and direction.y > 0:  # Down-Left (from top-right)
			spawn_pos = Vector2(screen_width + margin, -margin)
		elif direction.x < 0 and direction.y < 0:  # Up-Left (from bottom-right)
			spawn_pos = Vector2(screen_width + margin, screen_height + margin)

	return spawn_pos
