extends Motion

@export var floor_ray_cast: RayCast3D

func _enter() -> void:
	return super._enter()

func _update(delta: float) -> void:
	set_direction()
	calculate_gravity(delta)
	calculate_velocity(speed, direction, PLAYER_MOVEMENT_STATS.in_air_acceleration, delta)
	
	if floor_ray_cast.is_colliding():
		if direction != Vector3.ZERO:
			animation_state_changed.emit("run")
		else:
			animation_state_changed.emit("idle")
	
	if is_on_floor():
		if direction != Vector3.ZERO:
			finished.emit("Run")
		else:
			finished.emit("Idle")
		
	input_direction_changed.emit(input_dir)
