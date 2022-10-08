class BaseObject extends BaseEntity:

	var has_collision: bool = true
	var type: int = EntityType.OBJECT
	var scene_class: PackedScene = Entities.ObjectScene

	func _init(_position: Vector2).(_position):
		pass


class MoneyObject extends BaseObject:

	var frame: int = 0
	var h_frames: int = 1
	var sprite: String = 'res://entities/sprites/object/money.png'

	func _init(_position: Vector2).(_position):
		pass
