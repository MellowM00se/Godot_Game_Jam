extends "res://Scripts/Classes/Actor.gd"
# Basic player script
# handles general actions and setups player

enum Move {JUMP, FALL, STAND}

const FALL_MODIFIER := 2.5
const FRICTION := 5.0
const UNIT_SIZE := 64.0

export(float, 0.5, 20, 0.5) var jump_height = 1
export(float, 0.5, 20, 0.5) var jump_width = 1
export(float, 0.5, 20, 0.5) var walk_speed = 1

var velocity = Vector2()
var can_move = true
var move_state = Move.STAND
var jump_velocity: float
var gravity: float

onready var state_anim = $AnimationPlayer/AnimationTree.get("parameters/playback")
onready var tween: Tween = $Tween

# built-in methods
func _ready():
	_setup()
	$AnimationPlayer/AnimationTree.active = true
	jump_height = _unit_to_px(jump_height) + (UNIT_SIZE / 4)
	jump_width = _unit_to_px(jump_width)
	walk_speed = _unit_to_px(walk_speed)
	var jump_peak_width = jump_width / 2
	var jump_peak_time = jump_peak_width / walk_speed
	jump_velocity = (2 * jump_height) / jump_peak_time
	gravity = (2 * jump_height) / pow(jump_peak_time, 2)


func _physics_process(delta):
	if can_move:
		_move_player(delta)
		_use_action1()
		_use_action2()
		_anim_state()

# private methods
func _setup():
	pass


func _move_player(delta):
	velocity.x += _get_x_movement() * walk_speed
	velocity.x = _apply_friction(delta)
	velocity.y -= _get_jump() * jump_velocity
	velocity.y += _get_gravity() * delta
	velocity = _limit_velocity()
	velocity = move_and_slide(velocity, Vector2.UP)
	move_state = _set_move_state()
	_set_coyote_jump()
	_set_buffer_jump()


func _anim_state():
	if _get_x_movement() < 0 and $Sprite.flip_h == false:
		$Sprite.flip_h = true
	elif _get_x_movement() > 0 and $Sprite.flip_h == true:
		$Sprite.flip_h = false
	if is_on_floor():
		if _get_x_movement() == 0:
			state_anim.travel("Idle")
		else:
			state_anim.travel("Walk")
	else:
		state_anim.travel("Jump")


func _get_x_movement() -> float:
	var movement := 0.0
	if Input.is_action_pressed("move_left"):
		movement -= 1
	if Input.is_action_pressed("move_right"):
		movement += 1
	return movement


func _get_jump() -> float:
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			return 1.0
		elif $BufferJumpTimer.is_stopped() == false:
			return 1.0
	elif $CoyoteTimer.is_stopped() == false and Input.is_action_just_pressed("jump"):
			return 1.0
	return 0.0


func _get_gravity() -> float:
	if not Input.is_action_pressed("jump"):
		return gravity * FALL_MODIFIER
	else:
		return gravity


func _limit_velocity() -> Vector2:
	var new_vel = velocity
	if abs(new_vel.x) > walk_speed:
		new_vel.x = sign(new_vel.x) * walk_speed
	if new_vel.y > jump_velocity:
		new_vel.y = jump_velocity
	return new_vel


func _apply_friction(delta) -> float:
	var xlen = abs(velocity.x)
	var xsign = sign(velocity.x)
	if is_on_floor() and _get_x_movement() == 0:
		xlen = max(0, xlen - walk_speed * FRICTION * delta)
	return xlen * xsign


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


func _use_action1():
	pass


func _use_action2():
	pass


func _unit_to_px(value) -> float:
	return value * UNIT_SIZE
