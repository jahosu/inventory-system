extends Item
class_name InventoryItem

# NOTE: IT IS not SLOT AMOUNT, but currently carried amount
var amount: int = 0 # Amount that is being carried in inventory

@export var sprite: Sprite2D
@export var label: Label

func set_data(_name: String, _icon: Texture2D, _is_stackable: bool, _amount: int):
	self.item_name = _name
	self.name = _name
	self.icon = _icon
	self.is_stackable = _is_stackable
	self.amount = _amount

func _process(delta):
	self.sprite.texture = self.icon
	self.label.text = str(self.amount)

func set_sprite_size_to(sprite: Sprite2D, size: Vector2):
	var texture_size = sprite.texture.get_size()
	var scale_factor = Vector2(size.x / texture_size.x, size.y / texture_size.y)
	sprite.scale = scale_factor
