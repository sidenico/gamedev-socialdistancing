extends Node2D

@onready var canvas_layer = $CanvasLayer
@onready var player = $Player

func _ready():
	# Load and instance the health bar scene
	var health_bar_scene = preload("res://scenes/health_bar.tscn")
	var health_bar = health_bar_scene.instantiate()
	
	# Add it to the CanvasLayer
	canvas_layer.add_child(health_bar)
	
	# Initialize it
	health_bar.set_max_health(player.max_health)
	health_bar.set_health(player.health)
	
	 # Option A: Give the player a reference to update
	player.set_health_bar(health_bar)
