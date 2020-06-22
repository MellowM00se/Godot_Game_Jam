extends Node

var transition_time = 0.5

func _ready():
	$Calm.play()
	$Tense.volume_db = linear2db(0)

func transition(to):
	var from
	if to == "Calm":
		from = get_node("Tense")
	if to == "Tense":
		from = get_node("Calm")
	to = get_node(to)
	to.play()
	$Tween.interpolate_property(
		from, "volume_db", linear2db(1), linear2db(0), transition_time
	)
	$Tween.interpolate_property(
		to, "volume_db", linear2db(0), linear2db(1), transition_time
	)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	from.stop()
