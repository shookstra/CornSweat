extends Resource
class_name ItemData

enum ItemType { CONSUMABLE, EQUIPPABLE, INSPECTABLE }

@export var name: String
@export var description: String
@export var single_use: bool = true
@export var item_icon: Texture2D
@export var item_model_prefab: PackedScene
