extends Motion

func _enter() -> void:
	print(name)
	jump()
	return super._enter()
	
func _update(delta: float) -> void:
	set_direction()
	calculate_gravity(delta)
	calculate_velocity(speed, direction, PLAYER_MOVEMENT_STATS.in_air_acceleration, delta)
	
	if velocity.y <= 0:
		finished.emit("Fall")
		
	input_direction_changed.emit(input_dir)
	
func jump() -> void:
	velocity.y = jump_velocity
