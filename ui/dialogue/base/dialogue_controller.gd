extends Node

@onready var player_camera = %Player.get_node("%PlayerCamera3D")
@onready var dialogue_ui = %Player.get_node("UI/DialogueUI")
@onready var irva_cam = $"../GasStationContainer/Irva/IrvaCamera3D"

var dialogue: Dialogue
var current_index: int = 0

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		current_index += 1
		if current_index < dialogue.dialogue.size():
			dialogue_ui.reset_visible_characters()
			move_to_index(current_index)
			return
		player_camera.current = true
		dialogue_ui.visible = false
		current_index = 0
			

func _on_trigger_dialogue_triggered(new_dialogue: Dialogue, trigger_camera: Camera3D) -> void:
	trigger_camera.current = true
	dialogue = new_dialogue
	move_to_index(current_index)

func move_to_index(index: int) -> void:
	dialogue_ui.set_speaker(dialogue.dialogue[index].speaker_name)
	dialogue_ui.set_text(dialogue.dialogue[index].speaker_text)
	dialogue_ui.visible = true
	dialogue_ui.scroll_text()
