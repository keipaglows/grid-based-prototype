extends TileMap
export(bool) var hide_base_tiles = true

enum { EMPTY = -1, ACTOR, OBJECT, OBSTACLE }


func _ready():
	if hide_base_tiles:
		self.hide_base_tiles()
	
	var ObstacleScene = load("res://entities/Obstacle.tscn")

	for child in get_children():
		set_cellv(world_to_map(child.position), child.type)
	
	for cell_coordinates in get_used_cells_by_id(OBSTACLE):
		var obstacle = ObstacleScene.instance()
		obstacle.position = map_to_world(cell_coordinates) + cell_size / 2

		add_child(obstacle)
		

func get_cell_pawn(coordinates):
	for node in get_children():
		if world_to_map(node.position) == coordinates:
			return(node)

func request_move(pawn, direction):
	var cell_start = world_to_map(pawn.position)
	var cell_target = cell_start + direction
	
	var cell_target_type = get_cellv(cell_target)
	match cell_target_type:
		EMPTY:
			return update_pawn_position(pawn, cell_start, cell_target)
		OBJECT:
			var object_pawn = get_cell_pawn(cell_target)
			object_pawn.queue_free()
			return update_pawn_position(pawn, cell_start, cell_target)
		ACTOR:
			var pawn_name = get_cell_pawn(cell_target).name
			print("Cell %s contains %s" % [cell_target, pawn_name])

func update_pawn_position(pawn, cell_start, cell_target):
	set_cellv(cell_target, pawn.type)
	set_cellv(cell_start, EMPTY)
	return map_to_world(cell_target) + cell_size / 2

func hide_base_tiles():
	self._set_tile_invisible(ACTOR)
	self._set_tile_invisible(OBJECT)
	self._set_tile_invisible(OBSTACLE)

func _set_tile_invisible(tile_id):
	# reduciing tile_set region/size to possible minimum rectangle
	tile_set.tile_set_region(tile_id, Rect2(Vector2(), Vector2(0, 1)))
