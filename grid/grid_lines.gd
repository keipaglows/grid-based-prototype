extends TileMap
export (bool) var render_grid_lines = false

enum { EMPTY = -1, GRID_LINE }


func _ready():
	if render_grid_lines:
		var main_grid = get_node("/root/Game/GridPrimary")
		var grid_rect = main_grid.get_used_rect()
		
		for x in range(grid_rect.size[0]):
			for y in range(grid_rect.size[1]):
				set_cell(x, y, GRID_LINE)
