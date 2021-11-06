extends Node2D

enum TraverAlgorithms {LINEAR, FLOWER}

export (Texture) var texture setget _set_texture
export (TraverAlgorithms) var TRAVERSE_ALGORITHM


const GAME_MAP_SECTIONS_WIDTH = GameGlobals.GAME_MAP_SECTIONS_WIDTH
const GAME_MAP_SECTIONS_HEIGHT = GameGlobals.GAME_MAP_SECTIONS_HEIGHT
const SECTION_SIZE = GameGlobals.SECTION_SIZE

var WHOLE_SET: Array
var ALLOWED_SECTION_SET: Dictionary = {}

var RNG: RandomNumberGenerator = RandomNumberGenerator.new()
var MINI_MAP: Image
var TRAVERSE_ALGORITHMS = {
	TraverAlgorithms.LINEAR: funcref(self, 'traverse_linear'),
	TraverAlgorithms.FLOWER: funcref(self, 'traverse_flower')
}


func _ready():
	RNG.randomize()
	self.set_whole_section_set()
	self.set_mini_map()

	TRAVERSE_ALGORITHMS[TRAVERSE_ALGORITHM].call_func()
	self.draw_mini_map(1)  # Draw and scale mini map

# Traversing from top to bottom, from left to right
func traverse_linear():
	for X in GAME_MAP_SECTIONS_WIDTH:
		for Y in GAME_MAP_SECTIONS_HEIGHT:
			self.place_section(X, Y)

# Traversing from center in flower like fashion
func traverse_flower():
	var CENTER_X = GAME_MAP_SECTIONS_WIDTH / 2
	var CENTER_Y = GAME_MAP_SECTIONS_HEIGHT / 2
	var MAX_SIDE = [GAME_MAP_SECTIONS_WIDTH, GAME_MAP_SECTIONS_HEIGHT].max()
	var MAX_DISTANCE = MAX_SIDE - 2
	print('Center: %s, %s, Max Distance: %s' % [CENTER_X, CENTER_Y, MAX_DISTANCE])

	for distance in MAX_DISTANCE:
		if distance == 0:
			self.traverse_flower_segment(CENTER_X, CENTER_Y, 0)
		else:
			self.traverse_flower_segment(CENTER_X, CENTER_Y, distance, ImageSection.AT_TOP_SIDE)
			self.traverse_flower_segment(CENTER_X, CENTER_Y, distance, ImageSection.AT_RIGHT_SIDE)
			self.traverse_flower_segment(CENTER_X, CENTER_Y, distance, ImageSection.AT_BOTTOM_SIDE)
			self.traverse_flower_segment(CENTER_X, CENTER_Y, distance, ImageSection.AT_LEFT_SIDE)


func traverse_flower_segment(x: int, y: int, distance: int, direction: String = ''):
	var current_x = x
	var current_y = y
	var section
	var allowed_set
	var ignore_sides = {}
	var arch_distance = distance - 1

	if direction == ImageSection.AT_TOP_SIDE:
		current_x = x
		current_y = y - distance
		ignore_sides[ImageSection.AT_BOTTOM_SIDE] = true
		
	if direction == ImageSection.AT_RIGHT_SIDE:
		current_x = x + distance
		current_y = y
		ignore_sides[ImageSection.AT_LEFT_SIDE] = true
		
	if direction == ImageSection.AT_BOTTOM_SIDE:
		current_x = x
		current_y = y + distance
		ignore_sides[ImageSection.AT_TOP_SIDE] = true
		
	if direction == ImageSection.AT_LEFT_SIDE:
		current_x = x - distance
		current_y = y
		ignore_sides[ImageSection.AT_RIGHT_SIDE] = true

	self.place_section(current_x, current_y, ignore_sides)
	
	for arch_step in arch_distance:
		if direction == ImageSection.AT_TOP_SIDE:
			current_x += 1
			current_y += 1
			ignore_sides = {
				ImageSection.AT_BOTTOM_SIDE: true,
				ImageSection.AT_LEFT_SIDE: true
			}

		if direction == ImageSection.AT_RIGHT_SIDE:
			current_x -= 1
			current_y += 1
			ignore_sides = {
				ImageSection.AT_LEFT_SIDE: true,
				ImageSection.AT_TOP_SIDE: true
			}

		if direction == ImageSection.AT_BOTTOM_SIDE:
			current_x -= 1
			current_y -= 1
			ignore_sides = {
				ImageSection.AT_TOP_SIDE: true,
				ImageSection.AT_RIGHT_SIDE: true
			}

		if direction == ImageSection.AT_LEFT_SIDE:
			current_x += 1
			current_y -= 1
			ignore_sides = {
				ImageSection.AT_RIGHT_SIDE: true,
				ImageSection.AT_BOTTOM_SIDE: true
			}

		self.place_section(current_x, current_y, ignore_sides)


func set_whole_section_set():
	var tile_sections = Image.new()
	tile_sections.load("map_generator/sprites/sections_a.png")

	var _whole_set = []
	var section_index = 0
	var MAX_TILE_SECTION_X = (tile_sections.get_width() / 3)
	var MAX_TILE_SECTION_Y = (tile_sections.get_height() / 3)

	for X in MAX_TILE_SECTION_X:
		for Y in MAX_TILE_SECTION_Y:
			var section = tile_sections.get_rect(
				Rect2(X * SECTION_SIZE, Y * SECTION_SIZE, SECTION_SIZE, SECTION_SIZE)
			)
			
			_whole_set.append(ImageSection.new(section, section_index))
			section_index += 1

	ALLOWED_SECTION_SET[self.get_set_index_hash(_whole_set)] = _whole_set
	WHOLE_SET = _whole_set


func set_mini_map():
	MINI_MAP = Image.new()
	MINI_MAP.create(GAME_MAP_SECTIONS_WIDTH * SECTION_SIZE,
					GAME_MAP_SECTIONS_HEIGHT * SECTION_SIZE,
					false,
					Image.FORMAT_RGBA8)


func draw_mini_map(scale: int):
	MINI_MAP.resize(
		GAME_MAP_SECTIONS_WIDTH * SECTION_SIZE * scale,
		GAME_MAP_SECTIONS_HEIGHT * SECTION_SIZE * scale,
		0
	)
	# creating from image without any default flags
	var mini_map_texture = ImageTexture.new()
	mini_map_texture.create_from_image(MINI_MAP, 0)
	texture = mini_map_texture


func place_section(x: int, y: int, ignore_sides: Dictionary = {}):
	# Choosing random section from allowed ones and placing it on map
	var allowed_set = GameGlobals.GAME_MAP_ALLOWED_SECTIONS.get(Vector2(x, y), WHOLE_SET)
	var section = self.get_section_from_allowed_set(allowed_set, x, y)

	GameGlobals.GAME_MAP_SECTIONS[Vector2(x, y)] = section
	self.update_allowed_set_around(section, x ,y, ignore_sides)

	# drawing current section to mini_map
	MINI_MAP.blit_rect(section,
					   Rect2(0, 0, SECTION_SIZE, SECTION_SIZE),
					   Vector2(x * SECTION_SIZE, y * SECTION_SIZE))


func update_allowed_set(around_section: ImageSection,
						set_coordinate: Vector2,
						at_which_side: String):
	var allowed_set = GameGlobals.GAME_MAP_ALLOWED_SECTIONS.get(set_coordinate, WHOLE_SET)
	var new_allowed_set = []

	for allowed_section in allowed_set:
		if around_section.has_match(allowed_section, at_which_side):
			new_allowed_set.append(allowed_section)

	var new_set_hash = self.get_set_index_hash(new_allowed_set)

	if not ALLOWED_SECTION_SET.get(new_set_hash):
		ALLOWED_SECTION_SET[new_set_hash] = new_allowed_set

	GameGlobals.GAME_MAP_ALLOWED_SECTIONS[set_coordinate] = new_allowed_set


func update_allowed_set_around(section: ImageSection,
							   x: int,
							   y: int,
							   ignore_sides: Dictionary = {}):
	if not ignore_sides.get(ImageSection.AT_TOP_SIDE):
		self.update_allowed_set(section, Vector2(x, y - 1), ImageSection.AT_TOP_SIDE)
	if not ignore_sides.get(ImageSection.AT_RIGHT_SIDE):
		self.update_allowed_set(section, Vector2(x + 1, y), ImageSection.AT_RIGHT_SIDE)
	if not ignore_sides.get(ImageSection.AT_BOTTOM_SIDE):
		self.update_allowed_set(section, Vector2(x, y + 1), ImageSection.AT_BOTTOM_SIDE)
	if not ignore_sides.get(ImageSection.AT_LEFT_SIDE):
		self.update_allowed_set(section, Vector2(x - 1, y), ImageSection.AT_LEFT_SIDE)
	

func get_section_from_allowed_set(allowed_set: Array, X: int, Y: int):
	if len(allowed_set):
		return allowed_set[RNG.randi_range(0, len(allowed_set) - 1)]
	else:
		print('X: %s, Y: %s' % [X, Y])
		# TODO: add mechanism to choose a more appropriate section
		return WHOLE_SET[0]


func get_set_index_hash(section_set: Array):
	var set_index_hash = ''

	for section in section_set:
		if not set_index_hash:
			set_index_hash += str(section.section_index)
		else:
			set_index_hash += '_%s' % str(section.section_index)
		
	return set_index_hash


func _set_texture(value):
	# If the texture variable is modified externally,
	# this callback is called.
	texture = value  # Texture was changed.
	update()  # Update the node's visual representation.


func _draw():
	draw_texture(texture, Vector2())
