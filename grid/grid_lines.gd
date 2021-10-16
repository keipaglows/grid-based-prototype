extends TileMap
export (bool) var RENDER_GRID_LINES = false
export (bool) var HIGHLIGHT_SECTION_LINES = false
export (bool) var RENDER_SECTION_COORDINATES = false


enum {EMPTY = -1, GRID_LINE, GRID_LINE_SECTION_X, GRID_LINE_SECTION_Y, GRID_LINE_SECTION_XY}

const GAME_MAP_SECTIONS_WIDTH = GameGlobals.GAME_MAP_SECTIONS_WIDTH
const GAME_MAP_SECTIONS_HEIGHT = GameGlobals.GAME_MAP_SECTIONS_HEIGHT
const SECTION_SIZE = GameGlobals.SECTION_SIZE


func _ready():
	if RENDER_GRID_LINES:
		for X in range(GAME_MAP_SECTIONS_WIDTH * SECTION_SIZE):
			for Y in range(GAME_MAP_SECTIONS_HEIGHT * SECTION_SIZE):
				var grid_cell = GRID_LINE

				# TODO: add an option to render section coordinate
				# if RENDER_SECTION_COORDINATES: ...
				if HIGHLIGHT_SECTION_LINES:
					if (Y % SECTION_SIZE == 0):
						grid_cell = GRID_LINE_SECTION_X

					if (X % SECTION_SIZE == 0):
						grid_cell = GRID_LINE_SECTION_Y

					if (X % SECTION_SIZE == 0) and (Y % SECTION_SIZE == 0):
						grid_cell = GRID_LINE_SECTION_XY

						if RENDER_SECTION_COORDINATES:							
							var coordinates_label = ZLabel.new(
								'%s, %s' % [X / 3, Y / 3],
								GameGlobals.TILE_WIDTH * X + 2,
								GameGlobals.TILE_WIDTH * Y
							)
							
							coordinates_label.add_to_scene(self)

				set_cell(X, Y, grid_cell)
