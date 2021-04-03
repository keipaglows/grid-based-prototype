extends Node2D
export (Texture) var texture setget _set_texture


var tile_sections
var mini_map_texture

const GAME_MAP_SECTIONS_WIDTH = 5
const GAME_MAP_SECTIONS_HEIGHT = 3
const SECTION_SIZE = GameGlobals.SECTION_SIZE

var RNG = RandomNumberGenerator.new()

#const TOP_SIDE = 0
#const RIGHT_SIDE = 1
#const BOTTOM_SIDE = 2
#const LEFT_SIDE = 3


#class SectionSide:
#
#	func _init()

func _ready():
	mini_map_texture = ImageTexture.new()
	tile_sections = Image.new()

	RNG.randomize()
	tile_sections.load("map_generator/sprites/forest.png")

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
			var section_x = RNG.randi_range(0, MAX_SECTION_X)
			var section_y = RNG.randi_range(0, MAX_SECTION_Y)
			var section = get_section(tile_sections, section_x, section_y)

			# drawing current section to mini_map
			mini_map.blit_rect(section,
							   Rect2(0, 0, SECTION_SIZE, SECTION_SIZE),
							   Vector2(X * SECTION_SIZE, Y * SECTION_SIZE))
			GameGlobals.GAME_MAP_SECTIONS[Vector2(X, Y)] = section

	# creating from image without any default flags
	mini_map_texture.create_from_image(mini_map, 0)
	texture = mini_map_texture


func get_section(tile_sections: Image, x: int, y: int):
	var start_x = x * SECTION_SIZE
	var start_y = y * SECTION_SIZE

	var section = tile_sections.get_rect(
		Rect2(start_x, start_y, SECTION_SIZE, SECTION_SIZE)
	)
#	section.resize(9, 9, Image.INTERPOLATE_NEAREST)

	return section


func get_side_colors(section: Image, side):
	pass


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
