extends OmniLight3D

@export var random_energy_value: float

func _process(delta: float) -> void:
	self.light_energy = lerp(self.light_energy, random_energy_value, .5)

func _on_timer_timeout() -> void:
	if random_energy_value:
		random_energy_value = randf_range(0, 2)
