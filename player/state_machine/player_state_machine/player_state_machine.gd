extends StateMachine

@export var player_movement_stats: MovementStats
@export var animation_controller: AnimationController

func _ready() -> void:
	for child: Motion in get_children():
		child.animation_state_changed.connect(animation_controller.on_state_machine_animation_state_changed)
		child.input_direction_changed.connect(animation_controller.on_character_input_direction_changed)
	return super._ready()
