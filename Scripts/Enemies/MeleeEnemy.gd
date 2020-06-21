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
var turn = false
var can_turn = false


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
		turn = true
		direction = -1
		deactivateRaycast()
	elif not $leftRay.is_colliding():
		turn = true
		direction = 1
		deactivateRaycast()
	elif $rightWall.is_colliding():
		turn = true
		direction =  -1
		deactivateRaycast()
	elif $leftWall.is_colliding():
		turn =  true
		direction = 1
		deactivateRaycast()
	motion.x = direction * speed

func activateRaycast():
	
	$rightRay.enabled = true
	$leftRay.enabled = true
	$rightWall.enabled = true
	$leftWall.enabled = true

	


func deactivateRaycast():
	
	$rightRay.enabled = false
	$leftRay.enabled = false
	$rightWall.enabled = false
	$leftWall.enabled = false


func turnCharacter():
	if direction == 1:
		$Sprite.flip_h = false
		$pivot.scale.x = direction
	elif direction == -1:
		$Sprite.flip_h = true
		$pivot.scale.x = direction
	can_turn = false
	turn = false
	
	yield(get_tree(),"idle_frame")
	activateRaycast()
	

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


func _on_turnTimer_timeout():
	can_turn = true
