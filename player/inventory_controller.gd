extends Node

@export var inventory_ui: Control
@export var inventory_slot_count: int = 5
@export var has_flashlight: bool = false
@export var flashlight: SpotLight3D

@onready var inventory_grid: GridContainer = %GridContainer

var inventory_slots: Array[InventorySlot] = []
var inventory_slot_prefab: PackedScene = load("res://interactions/inventory_slot/InventorySlot.tscn")
var inventory_full: bool = false

func _ready() -> void:
	for item_slot_index: int in inventory_slot_count:
		var new_slot: InventorySlot = inventory_slot_prefab.instantiate()
		inventory_grid.add_child(new_slot)
		new_slot.inventory_slot_id = item_slot_index
		#new_slot.on_item_swapped.connect(_on_item_swapped_on_slot)
		#new_slot.on_item_double_clicked.connect(_on_item_double_clicked)
		#new_slot.on_item_right_clicked.connect(_on_slot_right_click)
		inventory_slots.append(new_slot)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if inventory_ui.visible:
			inventory_ui.visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			inventory_ui.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
	if event.is_action_pressed("toggle_flashlight") && has_flashlight:
		flashlight.visible = !flashlight.visible

func _on_interaction_controller_picked_up_item(item: Item) -> void:
	pickup_item(item.item_data)
	item.queue_free()

func pickup_item(item_data: ItemData) -> void:
	for slot in inventory_slots:
		if not slot.slot_filled:
			slot.fill_slot(item_data)
			if item_data.name == "Flashlight":
				has_flashlight = true
			inventory_full = not has_free_slot()
			return
	inventory_full = true

## Helper method that returns true if there is any free inventory slots. False if the inventory is full
func has_free_slot() -> bool:
	for slot in inventory_slots:
		if slot.slot_data == null:
			return true
	return false
