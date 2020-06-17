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
	if $Action1/HideTimer.is_stopped() == false:
		action1.hide_current_timer = $Action1/HideTimer.time_left
	$Action1/ProgressBar.value = action1.hide_current_timer


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


func _get_x_movement() -> float:
	var new_mov = ._get_x_movement()
	if action1.is_hiding:
		return new_mov * action1.hide_move_modifier
	else:
		return new_mov


func _restore_hiding(delta):
	if action1.hide_current_timer < hide_duration:
		action1.hide_current_timer += delta * hide_restore_factor
	elif action1.hide_current_timer > hide_duration:
		action1.hide_current_timer = hide_duration
	elif $Action1/ProgressBar.modulate == Color.white:
		_hide_bar()


func _hide():
	action1.is_hiding = true
	_modulate($Sprite, Color(1, 1, 1, 0.3))


func _unhide():
	action1.is_hiding = false
	_modulate($Sprite, Color.white)


func _hide_bar():
	_modulate($Action1/ProgressBar, Color(1, 1, 1, 0))


func _show_bar():
	_modulate($Action1/ProgressBar, Color.white)


func _modulate(obj: CanvasItem, to: Color):
	var _s = tween.stop($Sprite, "modulate")
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
