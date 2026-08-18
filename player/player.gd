extends CharacterBody3D

@export var has_pistol: bool = false

func set_velocity_from_motion(vel: Vector3) -> void:
	velocity = vel

func _physics_process(_delta: float) -> void:
	move_and_slide()
