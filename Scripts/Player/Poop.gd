extends KinematicBody2D


const UNIT_SIZE = 64

export(float, 0.5, 20, 0.5) var throw_height = 5
export(float, 0.5, 20, 0.5) var throw_width = 8
export(float, 0.5, 20, 0.5) var throw_arc_time = 1.5

var velocity := Vector2()
var gravity: float
var collided = false

func _ready():
	throw_height = _unit_to_px(throw_height)
	var throw_time = throw_arc_time / 2
	velocity.y -= (2 * throw_height) / throw_time
	velocity.x = _unit_to_px(throw_width / throw_arc_time)
	gravity = (2 * throw_height) / pow(throw_time, 2)


func _physics_process(delta):
	if not collided:
		velocity.y += gravity * delta
		#velocity = _limit_velocity()
		var col = move_and_collide(velocity * delta)
		if col != null:
			_collide(col.collider)



func throw(flip_direction: bool):
	if flip_direction:
		velocity.x *= -1
	$AnimationPlayer.play("Fly")


func _collide(obj: Node2D):
	collided = true
	if obj.is_in_group("Enemy"):
		print("hit enemy")
	$CollisionShape2D.disabled = true
	$AnimationPlayer.play("Hit")
	yield($AnimationPlayer, "animation_finished")
	queue_free()

func _unit_to_px(value) -> float:
	return value * UNIT_SIZE
