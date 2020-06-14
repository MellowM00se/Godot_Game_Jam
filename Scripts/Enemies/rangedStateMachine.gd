extends "res://Scripts/Classes/stateMachine.gd"




# Called when the node enters the scene tree for the first time.
func _ready():
	add_state("idle")
	add_state("patrol")
	add_state("attack")
	add_state("reload")
	add_state("hurt")
	add_state("die")
	call_deferred("set_state", states.idle)
	pass # Replace with function body.



func _state_logic(delta):
	
	
	match state:
		
		states.idle:
			
			parent.applyGravity()
			parent.applyMovement()
		states.patrol:
			parent.applyGravity()
			parent.applyMovement()
		
		states.attack:
			
			parent.applyGravity()
			parent.stopMovement()
		
		states.reload:
			
			parent.applyGravity()
			parent.stopMovement()
		
		states.hurt:
			
			parent.applyGravity()
			parent.stopMovement()
		
		states.die:
			
			parent.applyGravity()
			parent.stopMovement()


func _get_transition(delta):
	
	
	match state:
		
		states.idle:
			if parent.playerDetected and parent.can_attack:
				return states.attack
			elif parent.playerDetected and not parent.can_attack:
				return states.reload
			elif parent.motion.x != 0:
				return states.patrol
		states.patrol:
			if parent.playerDetected and parent.can_attack:
				return states.attack
			elif parent.playerDetected and not parent.can_attack:
				return states.reload
			elif parent.motion.x == 0:
				return states.idle
		states.attack:
			if not parent.can_attack:
				return states.reload
			elif not parent.playerDetected:
				return states.idle
			
			
		states.reload:
			
			if not parent.playerDetected:
				return states.idle
			elif parent.can_attack:
				return states.attack
		
		states.hurt:
			return null
		states.die:
			return null

func _enter_state(new_state, old_state):
	
	
	match  new_state:
		
		states.idle:
			parent.get_node("AnimationPlayer").play("idle")
		states.attack:
			parent.get_node("AnimationPlayer").play("attack")
		states.patrol:
			parent.get_node("AnimationPlayer").play("idle")
		states.reload:
			parent.get_node("AnimationPlayer").play("reload")


func _exit_state(old_state, new_state):
	pass
