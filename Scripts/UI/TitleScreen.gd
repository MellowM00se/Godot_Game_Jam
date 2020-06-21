extends Control

var options_list := []

onready var selector := $MenuSelector
onready var options := $Options

func _ready():
	for opt in $Options.get_children():
		options_list.append(opt.name)
	selector.max_options = options_list.size()
	_on_option_changed(0)
	selector.can_select = true


func _on_option_changed(index):
	for i in options.get_children():
		if i.name == options_list[index]:
			i.get_node("Pointer").visible = true
		else:
			i.get_node("Pointer").visible = false


func _on_option_selected(index):
	match options_list[index]:
		"ChameleonMode":
			# warning-ignore:return_value_discarded
			get_tree().change_scene("res://Environment/Main.tscn")
		"MonkeyMode":
			# warning-ignore:return_value_discarded
			get_tree().change_scene("res://Environment/Main_Monkey.tscn")
		"Credits":
			# warning-ignore:return_value_discarded
			get_tree().change_scene("res://UI/Credits.tscn")
		"Quit":
			get_tree().quit()

