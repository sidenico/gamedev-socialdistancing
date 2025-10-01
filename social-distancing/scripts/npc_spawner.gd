extends Node2D

@export var npc_scene: PackedScene = preload("res://scenes/npc.tscn")

@export var spawn_interval: float = 5.0       # start with 1 npc every 5 seconds
@export var min_spawn_interval: float = 1.5   # fastest rate over time
@export var spawn_accel: float = 0.98         # how much faster spawning gets each time

@export var sick_chance: float = 0.1          # 10% of new NPCs spawn sick

var first_spawn: bool = false

var timer: float = 0.0

func _process(delta):
	timer -= delta
	if timer <= 0:
		spawn_npc()
		# Speed up spawning a little each time, but don’t go below minimum
		spawn_interval = max(min_spawn_interval, spawn_interval * spawn_accel)
		timer = spawn_interval

func spawn_npc():
	if npc_scene == null:
		return
	
	var npc = npc_scene.instantiate()
	npc.position = [$spawner_1.position, $spawner_2.position, $spawner_3.position, $spawner_4.position, $spawner_5.position, $spawner_6.position].pick_random()
	
	if not first_spawn:
		npc.infect()
		first_spawn = true
	elif randf() < sick_chance:
		npc.infect()
	
	add_child(npc)
