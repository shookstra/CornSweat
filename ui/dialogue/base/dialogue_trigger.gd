extends Area3D

@export var dialogue: Dialogue
@export var trigger_camera: Camera3D

signal dialogue_triggered(dialogue: Dialogue, trigger_camera: Camera3D)

func _on_body_entered(_body: Node3D) -> void:
	dialogue_triggered.emit(dialogue, trigger_camera)
