extends Node3D
class_name AnimationController

enum CombatStatus {COMBAT, NONCOMBAT}

@export var animation_tree: AnimationTree
@export var right_hand: Node3D
@export var armature: Node3D
@export var turn_rate: float = 0.1

var current_mouse_rotation: Vector2
var input_dir: Vector2
var current_combat_status: CombatStatus = CombatStatus.NONCOMBAT
var next_weapon_to_load: PackedScene

func on_state_machine_animation_state_changed(state: String) -> void:
	match current_combat_status:
		CombatStatus.NONCOMBAT:
			animation_tree["parameters/unarmed_movement/transition_request"] = state
		CombatStatus.COMBAT:
			animation_tree["parameters/armed_movement/transition_request"] = state

func on_combat_status_changed(status: String) -> void:
	match status:
		"non_combat":
			input_dir = Vector2.UP
			current_combat_status = CombatStatus.NONCOMBAT
		"combat":
			current_combat_status = CombatStatus.COMBAT
			rotate_model(Vector2.UP, current_mouse_rotation)
	animation_tree["parameters/combat_transition/transition_request"] = status

func on_character_input_direction_changed(dir: Vector2) -> void:
	input_dir = input_dir.lerp(dir, turn_rate)
	
	match current_combat_status:
		CombatStatus.NONCOMBAT:
			rotate_model(input_dir, current_mouse_rotation)
		CombatStatus.COMBAT:
			animation_tree["parameters/walk_blend/blend_position"] = input_dir
			animation_tree["parameters/run_blend/blend_position"] = input_dir

func rotate_model(angle: Vector2 = Vector2.ZERO, _rotation: Vector2 = Vector2.ZERO) -> void:
	var new_angle: float = atan2(angle.x, angle.y) - _rotation.x
	armature.basis = Basis()
	armature.rotate_object_local(Vector3(0,1,0,), new_angle)


func _on_camera_camera_rotated(_rotation: Vector2) -> void:
	current_mouse_rotation = _rotation
	
	match current_combat_status:
		CombatStatus.NONCOMBAT:
			transform.basis = Basis()
			rotate_object_local(Vector3(0,1,0), current_mouse_rotation.x)

func _on_weapon_manager_weapon_changed(_weapon: Weapon) -> void:
	load_new_weapon(_weapon)

func load_new_weapon(_weapon: Weapon) -> void:
	right_hand.position = _weapon.hand_position
	right_hand.rotation = _weapon.hand_rotation
	
	animation_tree.tree_root.get_node("weapon_idle_animation").set_animation(_weapon.weapon_idle_animation.resource_name)
	animation_tree.tree_root.get_node("weapon_shoot_animation").set_animation(_weapon.weapon_shoot_animation.resource_name)
	animation_tree.tree_root.get_node("weapon_reload_animation").set_animation(_weapon.weapon_reload_animation.resource_name)
	animation_tree.tree_root.get_node("weapon_change_animation").set_animation(_weapon.weapon_change_animation.resource_name)
	
	animation_tree["parameters/change_weapon/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	next_weapon_to_load = _weapon.weapon_model
	attach_weapon_to_hand()

func attach_weapon_to_hand() -> void:
	if next_weapon_to_load:
		var new_weapon: Node3D = next_weapon_to_load.instantiate()
		right_hand.add_child(new_weapon)
		next_weapon_to_load = null

func remove_weapon_attachment() -> void:
	if right_hand.get_child_count() > 0:
		var current_weapon_attachment: Node3D = right_hand.get_child(0)
		current_weapon_attachment.queue_free()


func _on_weapon_manager_weapon_manager_finished(status: String) -> void:
	on_combat_status_changed(status)
	remove_weapon_attachment()

func _on_weapon_manager_weapon_manager_started(status: String, _weapon: Weapon) -> void:
	on_combat_status_changed(status)
	load_new_weapon(_weapon)
