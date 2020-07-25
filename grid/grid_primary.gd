extends TileMap
export (bool) var HIDE_BASE_TILES = true
export (int) var WIDTH = 20
export (int) var HEIGTH = 12

enum { EMPTY = -1, ACTOR, OBJECT, OBSTACLE }


func _ready():
	if HIDE_BASE_TILES:
		self.hide_base_tiles()

	# filling up the GAME_MAP
	for x in range(WIDTH):
		for y in range(HEIGTH):
			if (x in [0, WIDTH-1] or y in [0, HEIGTH-1]):
				var tree_obtascle = Entities.TreeObstacle.new(Vector2(x, y))
				tree_obtascle.add_to_tile_map(self)


func request_move(pawn, direction):
	var cell_start = world_to_map(pawn.position)
	var cell_target = cell_start + direction
	var target_object = GameGlobals.GAME_MAP.get(cell_target)

	# update and return pawn position if no object present in a way
	if not target_object:
		return update_pawn_position(pawn, cell_start, cell_target)
		
	match target_object.type:
		'obstacle':
			target_object.destroy(self)
	
#	var cell_target_type = get_cellv(cell_target)
#	match cell_target_type:
#		EMPTY:
#			return update_pawn_position(pawn, cell_start, cell_target)
#		OBJECT:
#			var object_pawn = get_cell_pawn(cell_target)
#			object_pawn.queue_free()
#			return update_pawn_position(pawn, cell_start, cell_target)
#		ACTOR:
#			var pawn_name = get_cell_pawn(cell_target).name
#			print("Cell %s contains %s" % [cell_target, pawn_name])

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
