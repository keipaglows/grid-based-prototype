class BaseNPC extends BaseEntity:

	var has_collision: bool = true
	var type: int = EntityType.NPC
	var scene_class: PackedScene = Entities.NPCScene

	func _init(_position: Vector2, _name: String = 'NPC').(_position):
		self.name = _name


class MouseNPC extends BaseNPC:

	var frame: int = 0
	var h_frames: int = 1
	var sprite: String = 'res://entities/sprites/npc/mouse.png'

	func _init(_position: Vector2, _name: String = 'Mouse').(_position, _name):
		self.name = _name
