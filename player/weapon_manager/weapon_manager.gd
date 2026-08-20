extends Node3D
class_name WeaponManager

enum WeaponManagerStatus { AVAILABLE, UNAVAILABLE }

signal weapon_changed(_weapon: Weapon, _weapon_model: WeaponModel)
signal weapon_manager_started(status: String, _weapon: Weapon, _weapon_model: WeaponModel)
signal weapon_manager_finished(status: String)
signal weapon_fired
signal weapon_reloaded
signal ammo_updated(_weapon: Weapon)

@export var weapons: Array[Weapon]
@export var weapon_status_timer: Timer

var current_status: WeaponManagerStatus = WeaponManagerStatus.UNAVAILABLE
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
	if current_status == WeaponManagerStatus.AVAILABLE:
		if event.is_action_pressed("weapon_up"):
			var weapon_index: int = weapons.find(current_weapon)
			weapon_index = min(weapon_index+1, weapons.size()-1)
			change_weapon(weapon_index)
		if event.is_action_pressed("weapon_down"):
			var weapon_index: int = weapons.find(current_weapon)
			weapon_index = max(weapon_index-1, 0)
			change_weapon(weapon_index)
			
		if event.is_action_pressed("shoot"):
			shoot()
			
		if event.is_action_pressed("reload"):
			reload()

func on_combat_status_changed(status: String) -> void:
	match status:
		"non_combat":
			weapon_manager_finished.emit(status, weapons.is_empty())
			set_weapon_manager_status(WeaponManagerStatus.UNAVAILABLE)
		"combat":
			start_weapon_manager(status)
			set_weapon_manager_status(WeaponManagerStatus.AVAILABLE)
			

func set_weapon_manager_status(status: WeaponManagerStatus) -> void:
	current_status = status

func start_weapon_manager(status: String) -> void:
	set_current_weapon_model(current_weapon)
	var weapon_index: int = 0
	weapon_manager_started.emit(status, weapons[weapon_index], current_weapon_model)

func set_current_weapon_model(_weapon: Weapon) -> void:
	var new_model: WeaponModel = _weapon.weapon_model.instantiate()
	current_weapon_model = new_model

func change_weapon(weapon_index: int) -> void:
	current_weapon = weapons[weapon_index]
	set_weapon_wait_time(current_weapon)
	set_current_weapon_model(current_weapon)
	weapon_changed.emit(current_weapon, current_weapon_model)
	ammo_updated.emit(current_weapon)

func wait_for_action_completion(wait_time: float) -> void:
	set_weapon_manager_status(WeaponManagerStatus.UNAVAILABLE)
	weapon_status_timer.start(wait_time)

func set_weapon_wait_time(_weapon: Weapon) -> void:
	reload_weapon_wait_time = _weapon.weapon_reload_animation.length
	shoot_weapon_wait_time = _weapon.weapon_shoot_animation.length
	change_weapon_wait_time = _weapon.weapon_change_animation.length
	
func shoot() -> void:
	if current_weapon.current_ammo:
		if current_weapon.current_ammo.amount > 0:
			weapon_fired.emit()
			wait_for_action_completion(shoot_weapon_wait_time)
			var _projectile: Projectile = get_projectile()
			add_child(_projectile)
			_projectile._set_weapon_projectile(current_weapon, current_weapon_model)
			current_weapon.current_ammo.amount -= 1
			ammo_updated.emit(current_weapon)
		else:
			reload()

func get_projectile() -> Projectile:
	var _projectile: Projectile
	_projectile = current_weapon.current_ammo.projectile.instantiate()
	return _projectile

func reload() -> void:
	if current_weapon.reserve_ammo.size() > 0:
		weapon_reloaded.emit()
		wait_for_action_completion(reload_weapon_wait_time)
		calculate_reload()

func calculate_reload() -> void:
	if current_weapon.current_ammo:
		if current_weapon.current_ammo.amount > 0:
			current_weapon.reserve_ammo.push_back(current_weapon.current_ammo)
	if current_weapon.reserve_ammo.size() > 0:
		current_weapon.current_ammo = current_weapon.reserve_ammo.pop_front().duplicate(true)
	
	ammo_updated.emit(current_weapon)

func _on_weapon_status_timer_timeout() -> void:
	set_weapon_manager_status(WeaponManagerStatus.AVAILABLE)
