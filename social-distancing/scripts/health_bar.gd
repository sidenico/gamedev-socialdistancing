extends Control

@onready var bar: TextureProgressBar = $TextureProgressBar

func init(player_max: int, player_current: int):
	set_max_health(player_max)
	set_health(player_current)

func set_health(value: int):
	bar.value = value

func set_max_health(max_value: int):
	bar.max_value = max_value
