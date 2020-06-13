extends "res://Scripts/Classes/Actor.gd"
# Basic player script
# handles general actions and setups player

enum Move {JUMP, FALL, STAND}

const GRAVITY = 1000.0
const FALL_MODIFIER = 2.0
const FRICTION = 500.0
const MAX_SPEED = 200.0

export(int) var walk_speed = 100
export(int) var jump_speed = 500

var velocity = Vector2()
var can_move = true
var move_state = Move.STAND


# built-in methods
func _physics_process(delta):
	if can_move:
		_move_player(delta)


# private methods
func _move_player(delta):
	velocity.x += _get_x_movement() * walk_speed
	velocity.y -= _get_jump() * jump_speed
	velocity.y += _get_gravity() * delta
	velocity = _limit_velocity()
	velocity = move_and_slide(velocity, Vector2.UP)
	move_state = _set_move_state()
	_set_coyote_jump()
	_set_buffer_jump()


func _get_x_movement() -> int:
	var movement := 0
	if Input.is_action_pressed("move_left"):
		movement -= 1
	if Input.is_action_pressed("move_right"):
		movement += 1
	return movement


func _get_jump() -> int:
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			return 1
		elif $BufferJumpTimer.is_stopped() == false:
			return 1
	elif $CoyoteTimer.is_stopped() == false and Input.is_action_just_pressed("jump"):
			return 1
	return 0


func _get_gravity() -> float:
	if move_state == Move.JUMP and not Input.is_action_pressed("jump"):
		return GRAVITY * FALL_MODIFIER
	else:
		return GRAVITY


func _limit_velocity() -> Vector2:
	if velocity.y > 0 and velocity.length() > MAX_SPEED:
		return velocity.normalized() * MAX_SPEED
	else:
		return velocity


func _set_move_state():
	if is_on_floor() and move_state != Move.STAND:
		return Move.STAND
	elif not is_on_floor():
		if velocity.y <= 0:
			return Move.JUMP
		else:
			return Move.FALL


func _set_coyote_jump():
	if not is_on_floor() and move_state == Move.STAND:
		move_state = Move.FALL
		$CoyoteTimer.start()


func _set_buffer_jump():
	if not is_on_floor():
		if $CoyoteTimer.is_stopped() and $BufferJumpTimer.is_stopped():
			if Input.is_action_just_pressed("jump"):
				$BufferJumpTimer.start()




