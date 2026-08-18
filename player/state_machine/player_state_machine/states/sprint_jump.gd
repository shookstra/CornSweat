extends Motion

func _enter() -> void:
	jump()
	return super._enter()
	
func _update(delta: float) -> void:
	set_direction()
	calculate_gravity(delta)
	calculate_velocity(sprint_speed, direction, PLAYER_MOVEMENT_STATS.in_air_acceleration, delta)
	
	sprint_remaining -= delta
	
	if velocity.y <= 0:
		finished.emit("SprintFall")
	
func jump() -> void:
	velocity.y = jump_velocity
