# General 'Item' class
extends Node
class_name Item

# The item name will be used for comparison
@export var item_name: String = ""
@export var icon: Texture2D
@export var is_stackable: bool = false

func _ready():
	add_to_group("items")
	self.name = item_name
