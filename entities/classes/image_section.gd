extends Image


class_name ImageSection

var TOP_SIDE: Image
var BOTTOM_SIDE: Image
var LEFT_SIDE: Image
var RIGHT_SIDE: Image

# consts to match two sections
const WITH_TOP_SIDE = 'TOP_SIDE'
const WITH_BOTTOM_SIDE = 'BOTTOM_SIDE'
const WITH_LEFT_SIDE = 'LEFT_SIDE'
const WITH_RIGHT_SIDE = 'RIGHT_SIDE'

var MATCH_SIDE_MAP = {
	WITH_TOP_SIDE: 'BOTTOM_SIDE',
	WITH_BOTTOM_SIDE: 'TOP_SIDE',
	WITH_LEFT_SIDE: 'RIGHT_SIDE',
	WITH_RIGHT_SIDE: 'LEFT_SIDE'
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


# TODO: store `get_data` value in `*_SIDE` attributes?
func has_match(match_section: ImageSection, matching_side: String):
	var match_section_side = match_section.get(MATCH_SIDE_MAP[matching_side])

	return self.get(matching_side).get_data() == match_section_side.get_data()
