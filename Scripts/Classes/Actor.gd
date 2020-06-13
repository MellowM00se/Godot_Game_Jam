extends KinematicBody2D
# Base actor - player and enemies inherit from here
# it handles health and death

export(int) var health = 1 setget set_health, get_health

signal has_died


# public methods
func set_health(value):
	health = value
	if value <= 0:
		emit_signal("has_died")
		die()


func get_health():
	return health


func die():
	queue_free()
