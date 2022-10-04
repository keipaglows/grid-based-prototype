class BaseRoad extends BaseEntity:

	func _init(_position: Vector2).(_position):
		self.type = EntityType.ROAD


class DirtRoad extends BaseRoad:

	func _init(_position: Vector2).(_position):
		self.scene = Entities.RoadScene.instance()
		self.scene.get_node("Sprite").frame = 0
