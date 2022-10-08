class BaseRoad extends BaseEntity:

	var has_collision: bool = false
	var type: int = EntityType.ROAD
	var scene_class: PackedScene = Entities.RoadScene

	func _init(_position: Vector2).(_position):
		pass


class DirtRoad extends BaseRoad:

	var frame: int = 0
	var h_frames: int = 1
	var sprite: String = 'res://entities/sprites/road/dirt.png'

	func _init(_position: Vector2).(_position):
		pass
