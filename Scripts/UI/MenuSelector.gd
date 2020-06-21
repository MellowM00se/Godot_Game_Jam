extends Node
# Class to handle selection in menus
# Instantiate it declaring its caller and set functions for
# both signals (_on_option_changed, _on_option_selected), then
# define how many options and add the selector's "check selection"
# to caller's _process

signal option_selected(index)
signal option_changed(index)

enum {NEXT = 1, PREV = -1}

# public variables
var can_select := false

# private variables
var max_options := 0
var current := 0


# built-in methods
func _ready() -> void:
	for i in ["option_changed", "option_selected"]:
		if get_parent().has_method("_on_" + i):
			# warning-ignore:return_value_discarded
			connect(i, get_parent(), "_on_" + i)
		else:
			print("Warning: Selector can't find method _on_" + i + "!")


func _process(_delta) -> void:
	if can_select:
		if Input.is_action_just_pressed("ui_select"):
			_select_option()
		elif Input.is_action_just_pressed("ui_up"):
			_change_option(PREV)
		elif Input.is_action_just_pressed("ui_down"):
			_change_option(NEXT)


# private methods
func _select_option() -> void:
	emit_signal("option_selected", current)
	can_select = false


func _change_option(to) -> void:
	current = wrapi(current + to, 0, max_options)
	emit_signal("option_changed", current)
