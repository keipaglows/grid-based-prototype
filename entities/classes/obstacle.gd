class BaseObstacle extends BaseEntity:

	var has_collision: bool = true
	var type: int = EntityType.OBSTACLE
	var scene_class: PackedScene = Entities.ObstacleScene

	func _init(_position: Vector2).(_position):
		pass


class TreeObstacle extends BaseObstacle:

	var frame: int = 1
	var h_frames: int = 2
	var sprite: String = 'res://entities/sprites/obstacle/trees.png'

	func _init(_position: Vector2).(_position):
		pass
