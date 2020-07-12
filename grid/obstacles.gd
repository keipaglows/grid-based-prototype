extends TileMap


func _ready():
	var Grid = get_node("/root/Game/Grid")
	var ObstacleScene = load("res://entities/Obstacle.tscn")

	for cell_coordinates in Grid.get_used_cells_by_id(Grid.OBSTACLE):
		var obstacle = ObstacleScene.instance()
		obstacle.position = map_to_world(cell_coordinates) + cell_size / 2
		# TODO: handle some sort of algorithm to decide which obstacle to draw
		obstacle.get_node("Sprite").frame = 1

		add_child(obstacle)
