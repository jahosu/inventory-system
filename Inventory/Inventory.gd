@tool
extends GridContainer
class_name Inventory

var inventory_item_scene = preload("res://Inventory/InventorySlot/InventoryItem/InventoryItem.tscn")

@export var rows: int = 8
@export var cols: int = 4

@export var slot_scene: PackedScene
var slots: Array[InventorySlot]

@export var tooltip: Tooltip # Must be shared among all instanes
@export var cursor: Marker2D # To hold current position of picakble # Shared

static var selected_item: Item = null


# Called when the node enters the scene tree for the first time.
func _ready():
	self.columns = cols
	for i in range(rows * cols):
		var slot = slot_scene.instantiate()
		slots.append(slot)
		self.add_child(slot)
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
	if selected_item: # if item already selected
		if which.item: # if this slot is not empty
			if selected_item.item_name == which.item.item_name: # if both items are same
				var total_amount = selected_item.amount + which.item.amount
				which.item.amount = total_amount
				cursor.remove_child(selected_item)
				selected_item.free()
				selected_item = null
				print("Stacked items: ", which.item.item_name, which.item.amount)
			else:
				# If the items are different, we swap them
				cursor.remove_child(selected_item)
				var temp_item = selected_item
				selected_item = which.item
				which.remove_child(which.item)
				which.set_item(temp_item)
				cursor.add_child(selected_item)
				print("Swapped items: ", selected_item.item_name, which.item.item_name)
				# Update UI?
		else:
			# If the slot is empty, we move the item
			cursor.remove_child(selected_item)
			which.set_item(selected_item)
			selected_item = null
	else:
		# If selected_item == null, it means that we are selecting an item
		if which.item:
			selected_item = which.item
			which.remove_child(which.item)
			which.item = null
			cursor.add_child(selected_item)
			print("Selected item: ", selected_item.item_name)
		else:
			print("No item in slot")


func _on_slot_hovered(which: InventorySlot, is_hovering: bool):
	if which.item:
		print(is_hovering)
		tooltip.set_tooltip(which.item.item_name)
		tooltip.visible = is_hovering


func _process(delta):
	# While item is selected, move it with the mouse
	#if selected_item:
	#	selected_item.global_position = get_global_mouse_position()
	cursor.global_position = get_global_mouse_position()
	
	if selected_item:
		tooltip.visible = false
