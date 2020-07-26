class BaseObject extends BaseEntity:

	func _init(_position: Vector2).(_position):
		self.type = EntityType.OBJECT
		self.has_collision = true


class MoneyObject extends BaseObject:

	func _init(_position: Vector2).(_position):
		self.scene = Entities.ObjectScene.instance()
		self.scene.get_node("Sprite").frame = 0
