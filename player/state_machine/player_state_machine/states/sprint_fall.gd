extends Motion

signal sprint_ended

@export var floor_ray_cast: RayCast3D

func _enter() -> void:
	return super._enter()

func _update(delta: float) -> void:
	set_direction()
	calculate_gravity(delta)
	calculate_velocity(sprint_speed, direction, PLAYER_MOVEMENT_STATS.in_air_acceleration, delta)
	
	sprint_remaining -= delta
	
	input_direction_changed.emit(input_dir)
	
	if is_on_floor():
		if Input.is_action_pressed("sprint"):
			finished.emit("Sprint")
		elif direction != Vector3.ZERO:
			sprint_ended.emit()
			finished.emit("Run")
		else:
			sprint_ended.emit()
			finished.emit("Idle")
