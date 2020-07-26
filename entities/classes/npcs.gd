class BaseNPC extends BaseEntity:

	func _init(_position: Vector2, _name: String = 'NPC').(_position):
		self.type = EntityType.NPC
		self.has_collision = true

		self.name = _name


class MouseNPC extends BaseNPC:

	func _init(_position: Vector2, _name: String = 'Mouse').(_position, _name):
		self.scene = Entities.NPCScene.instance()
		self.scene.get_node("Sprite").frame = 0

		self.name = _name
