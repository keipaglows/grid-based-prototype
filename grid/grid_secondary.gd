extends TileMap


func _ready():
	var main_grid = get_node("/root/Game/GridPrimary")
	var ObstacleScene = load("res://entities/Obstacle.tscn")

	for cell_coordinates in main_grid.get_used_cells_by_id(main_grid.OBSTACLE):
		var obstacle = ObstacleScene.instance()
		obstacle.position = map_to_world(cell_coordinates) + cell_size / 2
		# TODO: handle some sort of algorithm to decide which obstacle to draw
		obstacle.get_node("Sprite").frame = 1

		add_child(obstacle)
