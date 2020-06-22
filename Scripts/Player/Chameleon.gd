extends "res://Actors/Inherited/PlayerBase.gd"

export(float, 0, 5, 0.25) var hide_duration = 1
export(float, 0, 5, 0.25) var hide_restore_factor = 1.0

var action1 := {
	"hide_current_timer": null,
	"hide_anim_time": 0.1,
	"hide_move_modifier": 0.5,
	"can_hide": true,
	"is_hiding": false,
}

# built-in methods
func _process(delta):
	if not action1.is_hiding and action1.can_hide:
		_restore_hiding(delta)
	_adjust_action1_bar()


# private methods
func _setup():
	action1.hide_current_timer = hide_duration
	$Action1/ProgressBar.max_value = hide_duration


func _use_action1():
	if Input.is_action_just_pressed("action1"):
		if action1.hide_current_timer > 0 and action1.can_hide:
			$Action1/HideTimer.start(action1.hide_current_timer)
			_show_bar()
			_hide()
	elif Input.is_action_just_released("action1") and action1.is_hiding:
		action1.hide_anim_time = $Action1/HideTimer.time_left
		$Action1/HideTimer.stop()
		_unhide()


func _restore_hiding(delta):
	if action1.hide_current_timer < hide_duration:
		action1.hide_current_timer += delta * hide_restore_factor
	elif action1.hide_current_timer > hide_duration:
		action1.hide_current_timer = hide_duration
	elif $Action1/ProgressBar.modulate == Color.white:
		_hide_bar()


func _hide():
	remove_from_group("player")
	action1.is_hiding = true
	_modulate($Sprite, Color(1, 1, 1, 0.3))


func _unhide():
	add_to_group("player")
	action1.is_hiding = false
	_modulate($Sprite, Color.white)


func _adjust_action1_bar():
	if $Action1/HideTimer.is_stopped() == false:
		action1.hide_current_timer = $Action1/HideTimer.time_left
	$Action1/ProgressBar.value = action1.hide_current_timer


func _hide_bar():
	_modulate($Action1/ProgressBar, Color(1, 1, 1, 0))


func _show_bar():
	_modulate($Action1/ProgressBar, Color.white)


func _limit_velocity() -> Vector2:
	var new_vel = ._limit_velocity()
	if action1.is_hiding:
		if abs(new_vel.x) > walk_speed * action1.hide_move_modifier:
			new_vel.x = sign(new_vel.x) * walk_speed * action1.hide_move_modifier
	return new_vel


func _get_jump() -> float:
	var jump = ._get_jump()
	if action1.is_hiding:
		return jump * action1.hide_move_modifier
	else:
		return jump


func _modulate(obj: CanvasItem, to: Color):
	var _s = tween.stop(obj, "modulate")
	_s = tween.interpolate_property(
		obj, "modulate", $Sprite.modulate, to, action1.hide_anim_time
	)
	_s = tween.start()


func _on_HideTimer_timeout():
	action1.can_hide = false
	action1.hide_current_timer = 0
	_unhide()
	$Action1/HideDisableTimer.start()


func _on_HideDisableTimer_timeout():
	action1.can_hide = true
