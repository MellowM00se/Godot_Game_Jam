extends "res://Actors/Inherited/PlayerBase.gd"

const POOP_BASE = preload("res://Actors/Player/Poop.tscn")

onready var poop_pos = $Action1/PoopPos.position

func _move_player(delta):
	._move_player(delta)
	if _get_x_movement() != 0:
		if sign(poop_pos.x) != sign(_get_x_movement()):
			poop_pos.x = abs(poop_pos.x) * sign(_get_x_movement())


func _use_action1():
	if Input.is_action_just_pressed("action1"):
		if $Action1/WaitTimer.is_stopped():
			_throw_poop()
			$Action1/WaitTimer.start()

func _throw_poop():
	var poop = POOP_BASE.instance()
	get_parent().add_child(poop)
	poop.global_position = position + poop_pos
	poop.throw($Sprite.flip_h)
