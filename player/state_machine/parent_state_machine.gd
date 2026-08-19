extends StateMachine

@export var weapon_manager: WeaponManager

func _ready() -> void:
	for child in get_children():
		child.combat_status_changed.connect(weapon_manager.on_combat_status_changed)
	return super._ready()
