extends Node


const TILE_WIDTH = 16
const TILE_SIZE = Vector2(TILE_WIDTH, TILE_WIDTH)

const DEFAULT_LAYER = 0
const OBJECTS_LAYER = 100
const GUI_LAYER = 200
const PLAYER_LAYER = 300

const GAME_MAP_SECTIONS_WIDTH = 18
const GAME_MAP_SECTIONS_HEIGHT = 10
const SECTION_SIZE = 3

var GAME_MAP_ALLOWED_SECTIONS = {}
var GAME_MAP_SECTIONS = {}
var GAME_MAP = {}
