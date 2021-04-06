extends TileMap
export (bool) var RENDER_GRID_LINES = false


enum { EMPTY = -1, GRID_LINE }

const GAME_MAP_SECTIONS_WIDTH = GameGlobals.GAME_MAP_SECTIONS_WIDTH
const GAME_MAP_SECTIONS_HEIGHT = GameGlobals.GAME_MAP_SECTIONS_HEIGHT
const SECTION_SIZE = GameGlobals.SECTION_SIZE


func _ready():
	if RENDER_GRID_LINES:
		for x in range(GAME_MAP_SECTIONS_WIDTH * SECTION_SIZE):
			for y in range(GAME_MAP_SECTIONS_HEIGHT * SECTION_SIZE):
				set_cell(x, y, GRID_LINE)
