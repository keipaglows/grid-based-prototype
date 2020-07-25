class BaseObstacle extends BaseEntity:
	
	func _init(_position).(_position):
		self.type = "obstacle"
		self.has_collision = true


class TreeObstacle extends BaseObstacle:
	
	func _init(_position).(_position):
		self.scene = Entities.ObstacleScene.instance()
		self.scene.get_node("Sprite").frame = 1
