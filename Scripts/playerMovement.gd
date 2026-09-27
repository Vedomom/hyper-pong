extends CharacterBody2D


const SPEED = 500.0
const ACC = 5


func _physics_process(delta: float) -> void:
	
	#var direction_H := Input.get_axis("Left", "Right")
	var direction_V := Input.get_axis("Up", "Down")
	if direction_V:
		#velocity.x = lerp(velocity.x, direction_H * SPEED, ACC * delta)
		velocity.y = lerp(velocity.y, direction_V * SPEED, ACC * delta)
	else:
		#velocity.x = move_toward(velocity.x, 0, 20)
		velocity.y = move_toward(velocity.y, 0, 20)

	move_and_slide()
