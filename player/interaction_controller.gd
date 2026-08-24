extends Node

@export var interaction_raycast: RayCast3D
@export var camera: Camera3D
@export var pickup_range: int = 10
@export var interaction_label: Label

func _process(_delta: float) -> void:
	perform_hitscan()

func perform_hitscan() -> void:
	if not camera:
		print("no camera assigned!")
		return
	
	var space_state = camera.get_world_3d().direct_space_state
	var from = camera.global_position
	var forward = -camera.global_transform.basis.z
	var to = from + forward * pickup_range
	
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)
	
	if result:
		var collision_object = result.collider
		interaction_label.text = collision_object.name
	else:
		interaction_label.text = ""
