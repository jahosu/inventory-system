extends CharacterBody2D

var speed = 200

@export var inventory: Inventory

@export var test_hint_item: InventoryItem

func _ready():
	test_hint_item.get_parent().remove_child.call_deferred(test_hint_item)
	test_hint_item.name = "test"
	inventory.slots[0].set_item_hint.call_deferred(test_hint_item)


func _process(delta):
	velocity *= 0
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1

	velocity = velocity.normalized() * speed
	move_and_slide()
	
	if Input.is_action_just_pressed("ui_home"):
		inventory.visible = not inventory.visible
	
	if Input.is_action_just_pressed("ui_end"):
		var item: Item = inventory.retrieve_item("Amulet")


func _on_area_2d_body_entered(body):
	if body in get_tree().get_nodes_in_group("items"):
		self.inventory.add_item(body as Item, 1)


func _on_area_2d_area_entered(area):
	if area in get_tree().get_nodes_in_group("items"):
		self.inventory.add_item(area as Item, 1)
