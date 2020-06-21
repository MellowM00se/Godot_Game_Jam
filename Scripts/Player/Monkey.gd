extends "res://Actors/Inherited/PlayerBase.gd"

const POOP_BASE = preload("res://Actors/Player/Poop.tscn")

onready var poop_pos = $Action1/PoopPos.position

var throw_now = false

func _move_player(delta):
	._move_player(delta)
	if _get_x_movement() != 0:
		if sign(poop_pos.x) != sign(_get_x_movement()):
			poop_pos.x = abs(poop_pos.x) * sign(_get_x_movement())


func _anim_state():
	._anim_state()
	if throw_now:
		state_anim.travel("Throw")
		throw_now = false



func _use_action1():
	if Input.is_action_just_pressed("action1"):
		if $Action1/WaitTimer.is_stopped():
			_throw_poop()
			$Action1/WaitTimer.start()

func _throw_poop():
	throw_now = true
	yield(get_tree().create_timer(0.2), "timeout")
	var poop = POOP_BASE.instance()
	get_parent().add_child(poop)
	poop.global_position = position + poop_pos
	poop.throw($Sprite.flip_h)
