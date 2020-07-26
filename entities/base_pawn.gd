extends Node2D

enum PAWN_TYPES { ACTOR, OBJECT, OBSTACLE }
export (PAWN_TYPES) var type = PAWN_TYPES.ACTOR
