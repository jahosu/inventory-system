@tool

extends Control
class_name Inventory

var inventory_item_scene = preload("res://Inventory/InventorySlot/InventoryItem/InventoryItem.tscn")

@export var rows: int = 3
@export var cols: int = 6

@export var inventory_grid: GridContainer

@export var inventory_slot_scene: PackedScene
var slots: Array[InventorySlot]

@export var tooltip: Tooltip # Must be shared among all instanesself

static var selected_item: Item = null



func _ready():
	inventory_grid.columns = cols
	for i in range(rows * cols):
		var slot = inventory_slot_scene.instantiate()
		slots.append(slot)
		inventory_grid.add_child(slot)
		slot.slot_pressed.connect(self._on_slot_pressed) # binding not necessary as
		slot.slot_hovered.connect(self._on_slot_hovered) # it does while emit() call
		
	tooltip.visible = false



# OUTSIDE TO INVENTORY:
# Calling thius func impies that item is not already in inventory
func add_item(item: Item, amount: int):
	var _item: InventoryItem = inventory_item_scene.instantiate() # Duplicate
	_item.set_data(
		item.item_name, item.icon, item.is_stackable, amount
	)
	
	item.queue_free() # Consume the item by inventory
	
	for slot in slots:
		if slot.item and slot.item.item_name == _item.item_name:
			slot.set_item(_item)
			return
	for slot in slots:
		if slot.item == null:
			slot.set_item(_item)
			return



func _on_slot_pressed(which: InventorySlot):
	# If selected_item != null, it measn that previous call to this func was made
	# and we are trying to move the item to another slot
	if not selected_item: # if not item already selected
		selected_item = which.select_item()
	else:
		selected_item = which.deselect_item(selected_item)




func _on_slot_hovered(which: InventorySlot, is_hovering: bool):
	if which.item:
		print(is_hovering)
		tooltip.set_text(which.item.item_name)
		tooltip.visible = is_hovering



func _process(delta):
	# While item is selected, move it with the mouse
	#if selected_item:
	#	selected_item.global_position = get_global_mouse_position()
	tooltip.global_position = get_global_mouse_position() + Vector2.ONE * 8
	
	if selected_item:
		tooltip.visible = false
		selected_item.global_position = get_global_mouse_position()




