extends Area2D

var direction = 1
var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):

	if direction ==1:
		$Sprite.flip_h = true
	elif direction == -1:
		$Sprite.flip_h = false



	position.x += (direction * speed)
