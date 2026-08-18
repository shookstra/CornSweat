extends Node3D
class_name WeaponManager

signal weapon_changed(_weapon: Weapon)

@export var weapons: Array[Weapon]
var current_weapon: Weapon

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("weapon_up"):
		var weapon_index: int = weapons.find(current_weapon)
		weapon_index = min(weapon_index+1, weapons.size()-1)
		change_weapon(weapon_index)
	if event.is_action_pressed("weapon_down"):
		var weapon_index: int = weapons.find(current_weapon)
		weapon_index = min(weapon_index-1, 0)
		change_weapon(weapon_index)

func on_combat_status_changed(status: String) -> void:
	match status:
		"non_combat":
			pass
		"combat":
			start_weapon_manager()

func start_weapon_manager() -> void:
	var weapon_index: int = 0
	weapon_changed.emit(weapons[weapon_index])

func change_weapon(weapon_index: int) -> void:
	if weapons[weapon_index] == current_weapon:
		current_weapon = weapons[weapon_index]
		weapon_changed.emit(current_weapon)
