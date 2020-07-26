extends Node


class_name BaseEntity

var type: int = EntityType.BASE
var has_collision: bool = false

var position: Vector2
var scene: Node = null


func _init(_position: Vector2):
	self.position = _position

	GameGlobals.GAME_MAP[self.position] = self


func destroy(tile_map: TileMap):
	GameGlobals.GAME_MAP.erase(self.position)

	tile_map.remove_child(self.scene)
	self.queue_free()


func add_to_tile_map(tile_map: TileMap):
	self.scene.position = tile_map.map_to_world(self.position) + GameGlobals.CELL_SIZE / 2
	tile_map.add_child(self.scene)
