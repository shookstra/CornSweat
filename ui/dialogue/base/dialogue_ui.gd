extends Control

@export var text_scroll_speed: float = .01
@export var dialogue: Dialogue

@onready var speaker_text = $BackgroundPanel/SpeakerNameRichTextLabel
@onready var dialogue_text = $BackgroundPanel/DialogueRichTextLabel

func set_speaker(text: String) -> void:
	speaker_text.text = text
	
func set_text(text: String) -> void:
	dialogue_text.text = text
	
func scroll_text() -> void:
	for i in dialogue_text.text:
		dialogue_text.visible_characters += 1
		await get_tree().create_timer(text_scroll_speed).timeout

func set_visible_characters_to_max() -> void:
	dialogue_text.visible_characters = dialogue_text.text.length()

func reset_visible_characters() -> void:
	dialogue_text.visible_characters = 0
