extends "res://Scripts/Classes/stateMachine.gd"



# Called when the node enters the scene tree for the first time.
func _ready():
	add_state("idle")
	add_state("run")
	add_state("attack")
	add_state("hurt")
	add_state("die")
	call_deferred("set_state",states.idle)
	pass # Replace with function body.



func _state_logic(delta):
	
	match state:
		states.idle:
			parent.applyGravity()
			parent.applyMovement()
		states.run:
			parent.applyGravity()
			parent.applyMovement()
		states.attack:
			parent.applyGravity()
			parent.stopMovement()
		states.hurt:
			parent.stopMovement()
		states.die:
			parent.stopMovement()


func _get_transition(delta):
	
	match state:
		states.idle:
			if parent.is_on_floor():
				if parent.hurt:
					return states.hurt
				elif parent.playerDetected and parent.can_attack:
					return states.attack
				elif parent.motion.x != 0:
					return states.run
		states.run:
			if parent.is_on_floor():
				if parent.hurt:
					return states.hurt
				elif parent.playerDetected and parent.can_attack:
					return states.attack
				elif parent.motion.x == 0:
					return states.idle
		states.attack:
			if not parent.playerDectected or not parent.can_attack:
				return states.idle
		states.hurt:
			if not parent.hurt:
				return states.idle
		states.die:
			pass

func _enter_state(new_state, old_state):
	pass


func _exit_state(old_state, new_state):
	pass
