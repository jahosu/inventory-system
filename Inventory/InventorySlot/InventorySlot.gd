extends Control
class_name InventorySlot

@export var item: Item

signal slot_pressed(which: InventorySlot)
signal slot_hovered(which: InventorySlot, is_hovering: bool)


func _ready():
	add_to_group("inventory_slots")


func set_item(new_item: InventoryItem):
	if self.item and self.item.item_name == new_item.item_name:
		self.item.amount += new_item.amount
	else:
		item = new_item
	update_slot()


func remove_item():
	item = null
	update_slot()


# Removes item from slot and returns it.
func select_item():
	var tmp := self.item
	if tmp:
		self.remove_child(self.item)
		self.item = null
	return tmp


# Is slot empty (has no item)
func is_empty():
	return self.item == null


# Has same kind of item?
func has_same_item(_item: InventoryItem):
	_item.item_name == self.item.item_name


func update_slot():
	if item:
		if not self.get_children().has(item):
			add_child(item)
		item.sprite.texture = item.icon
		item.set_sprite_size_to(item.sprite, Vector2(42, 42)) # make sure texture is 32x32
		item.label.text = str(item.amount) + " - " + str(item.name)


# On slot button pressed
func _on_texture_button_pressed():
	slot_pressed.emit(self)


func _on_texture_button_mouse_entered():
	slot_hovered.emit(self, true)


func _on_texture_button_mouse_exited():
	slot_hovered.emit(self, false)
