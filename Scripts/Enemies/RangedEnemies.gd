extends KinematicBody2D

export var gravity = 10
export var speed = 150





var bulletPath = preload("res://Actors/Enemies/Bullet.tscn")
var hurt = false
var playerDetected = false
var canAttack = true



var direction = 1
var motion =  Vector2()
const UP = Vector2(0,-1)





# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func fireBullet():
	var bullet = bulletPath.instance()

	bullet.position =  $pivot/attackPos.global_position
	bullet.direction = direction
	get_parent().add_child(bullet)
	canAttack = false
	$reload.start()


func _physics_process(delta):




	motion = move_and_slide(motion,UP)



func applyGravity():
	motion.y += gravity





func applyMovement():

	if not $rightGroundRay.is_colliding():
		direction = -1
		$Sprite.flip_h = true
		$pivot.scale.x = -1
	elif not $leftGroundRay.is_colliding():
		direction = 1
		$Sprite.flip_h = false
		$pivot.scale.x = 1
	elif $rightWallRay.is_colliding():
		direction = -1
		$Sprite.flip_h = true
		$pivot.scale.x = -1
	elif $leftWallRay.is_colliding():
		direction = 1
		$Sprite.flip_h = false
		$pivot.scale.x = 1



	motion.x = speed *direction




func stopMovement():

	motion.x = lerp(motion.x ,0,0.2)


func _on_detector_body_entered(body):

	var groups = body.get_groups()

	if groups.has("player"):
		playerDetected = true


func _on_detector_body_exited(body):

	var groups = body.get_groups()

	if groups.has("player"):
		playerDetected = false


func _on_reload_timeout():
	canAttack = true
