extends "res://Scripts/Classes/StateMachine.gd"



# Called when the node enters the scene tree for the first time.
func _ready():
	add_state("idle")
	add_state("run")
	add_state("attack")
	add_state("hurt")
	add_state("die")
	add_state("turn")
#	yield(get_tree(),"idle_frame")
#	yield(get_tree(),"idle_frame")
#	yield(get_tree(),"idle_frame")
	
	call_deferred("set_state",states.run)
	pass # Replace with function body.



func _state_logic(delta):

	match state:
		states.idle:
			parent.applyGravity()
			parent.stopMovement()
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
		states.turn:
			parent.turnCharacter()
			parent.applyGravity()
			parent.stopMovement()


func _get_transition(delta):

	match state:
		states.idle:
			if parent.is_on_floor():
				if parent.hurt:
					return states.hurt
				elif parent.playerDetected :
					return states.attack
				elif parent.turn and parent.can_turn:
					return states.turn
				
		states.run:
			if parent.is_on_floor():
				if parent.hurt:
					return states.hurt
				elif parent.playerDetected :
					return states.attack
				elif parent.turn or parent.can_turn:
					return states.idle
				
		states.attack:
			if not parent.playerDetected :
				return states.run
		states.turn:
			if not parent.turn or not parent.can_turn:
				return states.run
		states.hurt:
			if not parent.hurt:
				return states.run
		states.die:
			pass

func _enter_state(new_state, old_state):

	match new_state:
		states.idle:
			parent.get_node("Sprite").play("idle")
			if get_parent().turn:
				get_parent().get_node("turnTimer").start()
		states.attack:
			pass
		states.run:
			parent.get_node("Sprite").play("run")
			
		states.turn:
			pass
	pass


func _exit_state(old_state, new_state):
	pass
