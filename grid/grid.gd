extends TileMap
export (bool) var HIDE_BASE_TILES = true
export (int) var WIDTH = 20
export (int) var HEIGTH = 12


enum {EMPTY = -1, ACTOR, OBJECT, OBSTACLE}

const GAME_MAP_SECTIONS_WIDTH = GameGlobals.GAME_MAP_SECTIONS_WIDTH
const GAME_MAP_SECTIONS_HEIGHT = GameGlobals.GAME_MAP_SECTIONS_HEIGHT
const SECTION_SIZE = GameGlobals.SECTION_SIZE

# Obstacle colors
const TREE_COLOR = Color("#99e550")
const MOUNTAIN_COLOR = Color("#c28144")
# Object colors
const ALTAR_COLOR = Color("#44b0c2")
# Road colors
const ROAD_COLOR = Color("#9d611d")

onready var RENDER_MAP = {
	TREE_COLOR: Entities.TreeObstacle,
	ROAD_COLOR: Entities.DirtRoad
}


func _ready():
	# Populating grid from section data
	for x in GAME_MAP_SECTIONS_WIDTH:
		for y in GAME_MAP_SECTIONS_HEIGHT:
			var section = GameGlobals.GAME_MAP_SECTIONS.get(Vector2(x, y))

			if section:
				section.lock()
				render_section(section, x, y)
				section.unlock()

	if HIDE_BASE_TILES:
		self.hide_base_tiles()


func render_section(section: Image, map_section_x: int, map_section_y: int) -> void:
	for x in SECTION_SIZE:
		var section_x = x + (map_section_x * SECTION_SIZE)

		for y in SECTION_SIZE:
			var section_y = y + (map_section_y * SECTION_SIZE)
			var render_entity = RENDER_MAP.get(section.get_pixel(x, y))

			if render_entity:
				render_entity.new(Vector2(section_x, section_y)).add_to_tile_map(self)


func request_move(pawn, direction):
	var cell_start = world_to_map(pawn.position)
	var cell_target = cell_start + direction
	var entity = GameGlobals.GAME_MAP.get(cell_target)

	# update and return pawn position if no object present in a way
	if not entity:
		return update_pawn_position(pawn, cell_start, cell_target)

	# TODO: check for has_collision
	match entity.type:
		EntityType.ROAD:
			return update_pawn_position(pawn, cell_start, cell_target)
		EntityType.OBJECT:
			entity.destroy(self)
			return update_pawn_position(pawn, cell_start, cell_target)
		EntityType.NPC:
			print("%s at %s says 'Nihao'" % [entity.name, cell_target])
		EntityType.OBSTACLE:
			pass


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
