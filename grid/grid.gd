extends TileMap
export (bool) var HIDE_BASE_TILES = true
export (int) var WIDTH = 20
export (int) var HEIGTH = 12

enum { EMPTY = -1, ACTOR, OBJECT, OBSTACLE }


func _ready():
	if HIDE_BASE_TILES:
		self.hide_base_tiles()

	# filling up the GAME_MAP with obstacles
	for x in range(WIDTH):
		for y in range(HEIGTH):
			if (x in [0, WIDTH-1] or y in [0, HEIGTH-1]):
				var tree_obtascle = Entities.TreeObstacle.new(Vector2(x, y))
				tree_obtascle.add_to_tile_map(self)

	# filling up with objects
	var money_object = Entities.MoneyObject.new(Vector2(8, 4))
	money_object.add_to_tile_map(self)
	var money_object_ = Entities.MoneyObject.new(Vector2(9, 4))
	money_object_.add_to_tile_map(self)

	# filling up with NPC
	var mouse_npc = Entities.MouseNPC.new(Vector2(10, 6), "Some mouse")
	mouse_npc.add_to_tile_map(self)


func request_move(pawn, direction):
	var cell_start = world_to_map(pawn.position)
	var cell_target = cell_start + direction
	var entity = GameGlobals.GAME_MAP.get(cell_target)

	# update and return pawn position if no object present in a way
	if not entity:
		return update_pawn_position(pawn, cell_start, cell_target)

	match entity.type:
		EntityType.OBJECT:
			entity.destroy(self)
			return update_pawn_position(pawn, cell_start, cell_target)
		EntityType.NPC:
			print("%s at %s says 'Nihao'" % [entity.name, cell_target])
		EntityType.OBSTACLE:
			pass

#func get_cell_pawn(coordinates):
#	for node in get_children():
#		if world_to_map(node.position) == coordinates:
#			return(node)


func update_pawn_position(pawn, cell_start, cell_target):
	set_cellv(cell_target, pawn.type)
	set_cellv(cell_start, EMPTY)

	return map_to_world(cell_target) + cell_size / 2


func hide_base_tiles():
	self._set_tile_invisible(ACTOR)
	self._set_tile_invisible(OBJECT)
	self._set_tile_invisible(OBSTACLE)


func _set_tile_invisible(tile_id):
	# reduciing tile_set region / size to possible minimum rectangle
	tile_set.tile_set_region(tile_id, Rect2(Vector2(), Vector2(0, 1)))
