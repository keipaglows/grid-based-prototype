extends Image


class_name ImageSection

var TOP_SIDE: Image
var BOTTOM_SIDE: Image
var LEFT_SIDE: Image
var RIGHT_SIDE: Image

# consts to match two sections
const AT_TOP_SIDE = 'TOP_SIDE'
const AT_BOTTOM_SIDE = 'BOTTOM_SIDE'
const AT_LEFT_SIDE = 'LEFT_SIDE'
const AT_RIGHT_SIDE = 'RIGHT_SIDE'

var MATCH_SIDE_MAP = {
	AT_TOP_SIDE: 'BOTTOM_SIDE',
	AT_BOTTOM_SIDE: 'TOP_SIDE',
	AT_LEFT_SIDE: 'RIGHT_SIDE',
	AT_RIGHT_SIDE: 'LEFT_SIDE'
}


func _init(section: Image).():
	self.create_from_data(
		GameGlobals.SECTION_SIZE,
		GameGlobals.SECTION_SIZE,
		false,
		Image.FORMAT_RGBA8,
		section.get_data()
	)

	self.TOP_SIDE = self.get_rect(Rect2(0, 0, 3, 1))
	self.BOTTOM_SIDE = self.get_rect(Rect2(0, 2, 3, 1))
	self.LEFT_SIDE = self.get_rect(Rect2(0, 0, 1, 3))
	self.RIGHT_SIDE = self.get_rect(Rect2(2, 0, 1, 3))

# returns `true` if `matching_side` of `ImageSection` is a match to opposing side of `match_section` 
func has_match(match_section: ImageSection, matching_side: String):
	var match_section_side = match_section.get(MATCH_SIDE_MAP[matching_side])

	# TODO: store `get_data` value in `*_SIDE` attributes?
	return self.get(matching_side).get_data() == match_section_side.get_data()
