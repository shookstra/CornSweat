extends Node3D
class_name WeaponManager

signal weapon_changed(_weapon: Weapon)
signal weapon_manager_started(status: String, _weapon: Weapon)
signal weapon_manager_finished(status: String)


@export var weapons: Array[Weapon]
var current_weapon: Weapon
var current_weapon_model: WeaponModel
var action_queue: Callable
var change_weapon_wait_time: float = 0.0
var reload_weapon_wait_time: float = 0.0
var shoot_weapon_wait_time: float = 0.0

func _ready() -> void:
	if weapons.is_empty():
		return
	current_weapon = weapons[0]
	#set_weapon_wait_time(current_weapon)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("weapon_up"):
		var weapon_index: int = weapons.find(current_weapon)
		weapon_index = min(weapon_index+1, weapons.size()-1)
		change_weapon(weapon_index)
	if event.is_action_pressed("weapon_down"):
		var weapon_index: int = weapons.find(current_weapon)
		weapon_index = max(weapon_index-1, 0)
		change_weapon(weapon_index)

func on_combat_status_changed(status: String) -> void:
	match status:
		"non_combat":
			weapon_manager_finished.emit(status, weapons.is_empty())
			pass
		"combat":
			start_weapon_manager(status)

func start_weapon_manager(status: String) -> void:
	var weapon_index: int = 0
	weapon_manager_started.emit(status, weapons[weapon_index])

func set_current_weapon_model(_weapon: Weapon) -> void:
	var new_model: WeaponModel = _weapon.weapon_model.instantiate()
	current_weapon_model = new_model

func change_weapon(weapon_index: int) -> void:
	print(weapon_index)
	current_weapon = weapons[weapon_index]
	weapon_changed.emit(current_weapon)
