extends Node3D
class_name AnimationController

@export var animation_tree: AnimationTree
@export var armature: Node3D
@export var turn_rate: float = 0.1

var current_mouse_rotation: Vector2
var input_dir: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func on_state_machine_animation_state_changed(state: String) -> void:
	print(state)
	animation_tree["parameters/unarmed_movement/transition_request"] = state

func on_character_input_direction_changed(dir: Vector2) -> void:
	input_dir = input_dir.lerp(dir, turn_rate)
	rotate_model(input_dir, current_mouse_rotation)

func rotate_model(angle: Vector2 = Vector2.ZERO, _rotation: Vector2 = Vector2.ZERO) -> void:
	var new_angle: float = atan2(angle.x, angle.y) - _rotation.x
	armature.basis = Basis()
	armature.rotate_object_local(Vector3(0,1,0,), new_angle)


func _on_camera_camera_rotated(_rotation: Vector2) -> void:
	current_mouse_rotation = _rotation
	
	transform.basis = Basis()
	rotate_object_local(Vector3(0,1,0), current_mouse_rotation.x)
