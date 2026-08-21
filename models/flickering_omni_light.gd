extends OmniLight3D

@export var min_energy: float = 0
@export var max_energy: float = 4
@export var min_wait_time: float = 0.1
@export var max_wait_time: float = 2
@export var flicker_frequency: float = 0.5
@export var lerp_weight: float = 0.3
@export var random_flicker: bool = true

var random_energy_value: float
var random_wait_time: float

func _ready() -> void:
	$Timer.wait_time = flicker_frequency

func _process(_delta: float) -> void:
	self.light_energy = lerp(self.light_energy, random_energy_value, lerp_weight)

func _on_timer_timeout() -> void:
	random_energy_value = randf_range(min_energy, max_energy)
	random_wait_time = randf_range(min_wait_time, max_wait_time)
	$Timer.wait_time = random_wait_time
