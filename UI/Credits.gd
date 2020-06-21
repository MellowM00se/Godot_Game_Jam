extends "res://Scripts/UI/TitleScreen.gd"

func _on_option_selected(index):
	match options_list[index]:
		"Back":
			# warning-ignore:return_value_discarded
			get_tree().change_scene("res://UI/TitleScreen.tscn")
