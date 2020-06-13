extends Node2D
# Base actor - player and enemies inherit from here
# it handles health and death

var health := 0 setget set_health, get_health

signal has_died

func set_health(value):
	health = value
	if value <= 0:
		die()


func get_health():
	return health


func die():
	emit_signal("has_died")
	queue_free()
