extends Node

@export var interaction_raycast: RayCast3D
@export var camera: Camera3D
@export var pickup_range: int = 6
@export var interaction_label: Label

# Item you're currently looking at
var current_item: Item

signal picked_up_item(item: Item)

func _process(_delta: float) -> void:
	perform_hitscan()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && current_item != null:
		picked_up_item.emit(current_item)

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
		if result.collider is Item:
			current_item = result.collider
			interaction_label.text = current_item.name
	else:
		interaction_label.text = ""
		current_item = null
