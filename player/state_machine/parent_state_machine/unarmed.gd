extends CombatTransitionState

func _state_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("holster_weapon"):
		finished.emit("Armed")
