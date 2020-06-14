extends KinematicBody2D

export var gravity = 10
export var speed = 100
export var attackDamage = 1
export var health = 2


var hurt = false
var playerDetected = false
var can_attack = true
var direction =  1
var motion = Vector2()
var knockBack = 200



const UP = Vector2(0,-1)

# Called when the node enters the scene tree for the first time.

func _process(delta):
	
	
	match $stateMachine.state:
		
		0:
			
			$Label.text  = "idle"
		
		1:
			
			$Label.text = "run"
		2:
			
			$Label.text = "attack"



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
	elif $rightWall.is_colliding():
		direction = -1
		$Sprite.flip_h = true
		$pivot.scale.x = -1
	elif $leftWall.is_colliding():
		direction = 1
		$Sprite.flip_h = false
		$pivot.scale.x = 1
	motion.x = direction * speed


func _physics_process(delta):
	
	
	
	motion = move_and_slide(motion,UP)


func stopMovement():
	
	
	motion.x  = lerp(motion.x, 0, 0.2)


func _on_detectorPlayer_body_entered(body):
	
	var groups = body.get_groups()
	
	if groups.has("player"):
		playerDetected = true


func _on_detectorPlayer_body_exited(body):
	
	var groups = body.get_groups()
	
	if groups.has("player"):
		playerDetected = false


func _on_attackBox_body_entered(body):
	var groups = body.get_groups()
	
	if groups.has("player"):
		pass
