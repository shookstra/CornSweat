extends Motion

func _state_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		finished.emit("Jump")
	
	if event.is_action_pressed("sprint") and sprint_remaining > 0.1:
		finished.emit("Sprint")
		
	if event.is_action_pressed("aim"):
		finished.emit("AimIdle")

func _update(delta: float) -> void:
	set_direction()
	calculate_velocity(speed, direction, PLAYER_MOVEMENT_STATS.acceleration, delta)
	replenish_sprint(delta)
	
	if direction != Vector3.ZERO:
		finished.emit("Run")
		
	if not is_on_floor():
		finished.emit("Fall")
