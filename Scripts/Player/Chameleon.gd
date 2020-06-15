extends "res://Actors/Inherited/PlayerBase.gd"

# built-in methods
func _setup():
	state_anim = $AnimationPlayer/AnimationTree.get("parameters/playback")
