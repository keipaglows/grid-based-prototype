extends TileMap
export (bool) var RENDER_GRID_LINES = false

enum { EMPTY = -1, GRID_LINE }


func _ready():
	if RENDER_GRID_LINES:
		var main_grid = get_node("/root/Game/GridPrimary")
		
		for x in range(main_grid.WIDTH):
			for y in range(main_grid.HEIGTH):
				set_cell(x, y, GRID_LINE)
