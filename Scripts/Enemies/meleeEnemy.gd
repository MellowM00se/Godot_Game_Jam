extends KinematicBody2D

export var gravity = 10
export var speed = 100
export var attackDamage = 1
export var health = 2


var hurt = false
var playerDetected = false
var can_attcak = true
var direction =  1
var motion = Vector2()




const UP = Vector2(0,-1)

# Called when the node enters the scene tree for the first time.

func _process(delta):
	
	
	match $stateMachine.state:
		
		0:
			
			$Label.text  = "idle"
		
		1:
			
			$Label.text = "run"




func _ready():
	pass # Replace with function body.


func applyGravity():
	
	motion.y += gravity


func applyMovement():
	
	
	if not $rightRay.is_colliding():
		direction = -1
		$Sprite.flip_h = true
		$pivot.scale.x = -1
	elif not $leftRay.is_colliding():
		direction = 1
		$Sprite.flip_h = false
		$pivot.scale.x = 1
	motion.x = direction * speed


func _physics_process(delta):
	
	
	
	motion = move_and_slide(motion,UP)


func stopMovement():
	
	
	motion.x  = 0
