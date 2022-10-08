extends Node


class_name BaseEntity

# here goes child entities class atrrs as "interface"
# --------------------------------------------------
# var type: int = EntityType.BASE
# var has_collision: bool = false
# var scene_class: PackedScene = null

var position: Vector2
var scene: Node = null


func _init(_position: Vector2):
	self.scene = self.scene_class.instance()
	self._set_position(_position)
	self._set_sprite()


func destroy(tile_map: TileMap):
	GameGlobals.GAME_MAP.erase(self.position)

	tile_map.remove_child(self.scene)
	self.queue_free()


func _set_sprite():
	var sprite = self.scene.get_node('Sprite')

	self.scene.get_node('Sprite').hframes = self.h_frames
	self.scene.get_node('Sprite').frame = self.frame
	self.scene.get_node('Sprite').texture = load(self.sprite)


func _set_position(_position: Vector2):
	self.position = _position
	GameGlobals.GAME_MAP[self.position] = self


func add_to_tile_map(tile_map: TileMap):
	self.scene.position = tile_map.map_to_world(self.position) + GameGlobals.TILE_SIZE / 2
	tile_map.add_child(self.scene)
