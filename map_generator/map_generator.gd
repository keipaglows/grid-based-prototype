extends Node2D
export (Texture) var texture setget _set_texture


var tile_sections
var mini_map_texture

const GAME_MAP_SECTIONS_WIDTH = GameGlobals.GAME_MAP_SECTIONS_WIDTH
const GAME_MAP_SECTIONS_HEIGHT = GameGlobals.GAME_MAP_SECTIONS_HEIGHT
const SECTION_SIZE = GameGlobals.SECTION_SIZE

var RNG = RandomNumberGenerator.new()
var ALLOWED_SECTION_SET = {
	0: null
}


func _ready():
	mini_map_texture = ImageTexture.new()
	tile_sections = Image.new()

	RNG.randomize()
	tile_sections.load("map_generator/sprites/forest.png")
	var whole_set = self.get_whole_section_set(tile_sections)

	var mini_map = Image.new()
	var MAX_SECTION_X = (tile_sections.get_width() / 3) - 1
	var MAX_SECTION_Y = (tile_sections.get_height() / 3) - 1

	mini_map.create(GAME_MAP_SECTIONS_WIDTH * SECTION_SIZE,
					GAME_MAP_SECTIONS_HEIGHT * SECTION_SIZE,
					false,
					Image.FORMAT_RGBA8)

	# Filling GAME_MAP_SECTIONS with sections
	for X in GAME_MAP_SECTIONS_WIDTH:
		for Y in GAME_MAP_SECTIONS_HEIGHT:
			GameGlobals.GAME_MAP_ALLOWED_SECTIONS[Vector2(X, Y)] = whole_set
			
			var section_x = RNG.randi_range(0, MAX_SECTION_X)
			var section_y = RNG.randi_range(0, MAX_SECTION_Y)
			var section = get_section(tile_sections, section_x, section_y)
			GameGlobals.GAME_MAP_SECTIONS[Vector2(X, Y)] = section

			###
			var has_top_match = section.has_match(whole_set[3], ImageSection.WITH_RIGHT_SIDE)
			
			if has_top_match:
				print('X: %s, Y: %s, HAS_TOP_MATCH: %s' % [X, Y, has_top_match])
			###

			# drawing current section to mini_map
			mini_map.blit_rect(section,
							   Rect2(0, 0, SECTION_SIZE, SECTION_SIZE),
							   Vector2(X * SECTION_SIZE, Y * SECTION_SIZE))

	# scailing up resulted mini_map to better see it on screen
	mini_map.resize(
		GAME_MAP_SECTIONS_WIDTH * SECTION_SIZE * 2,
		GAME_MAP_SECTIONS_HEIGHT * SECTION_SIZE * 2,
		0
	)
	# creating from image without any default flags
	mini_map_texture.create_from_image(mini_map, 0)
	texture = mini_map_texture


func get_section(tile_sections: Image, x: int, y: int):
	var start_x = x * SECTION_SIZE
	var start_y = y * SECTION_SIZE
#	return tile_sections.get_rect(
#		Rect2(start_x, start_y, SECTION_SIZE, SECTION_SIZE)
#	)
	var section = tile_sections.get_rect(
		Rect2(start_x, start_y, SECTION_SIZE, SECTION_SIZE)
	)
	
	return ImageSection.new(section)
	


func get_whole_section_set(tile_sections: Image):
	var whole_set = []

	for X in GAME_MAP_SECTIONS_WIDTH:
		for Y in GAME_MAP_SECTIONS_HEIGHT:
			var section = tile_sections.get_rect(
				Rect2(X * SECTION_SIZE, Y * SECTION_SIZE, SECTION_SIZE, SECTION_SIZE)
			)
			
			whole_set.append(ImageSection.new(section))
	
	return whole_set


func get_image_colors(image: Image):
	var width = image.get_width()
	var height = image.get_height()
	image.lock()

	for x in width:
		print('x is ', x)
		for y in height:
			print(image.get_pixel(x, y))

	image.unlock()


func _set_texture(value):
	# If the texture variable is modified externally,
	# this callback is called.
	texture = value  # Texture was changed.
	update()  # Update the node's visual representation.


func _draw():
	draw_texture(texture, Vector2())
