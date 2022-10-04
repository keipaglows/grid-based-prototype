extends Node

# entities

## roads
var roads = load("res://entities/classes/road.gd")
var DirtRoad = roads.DirtRoad

## obstacles
var obstacles = load("res://entities/classes/obstacle.gd")
var TreeObstacle = obstacles.TreeObstacle

## objects
var objects = load("res://entities/classes/object.gd")
var MoneyObject = objects.MoneyObject

## npc
var npcs = load("res://entities/classes/npc.gd")
var MouseNPC = npcs.MouseNPC

# entity scenes
var RoadScene = load("res://entities/scenes/Road.tscn")
var ObstacleScene = load("res://entities/scenes/Obstacle.tscn")
var ObjectScene = load("res://entities/scenes/Object.tscn")
var NPCScene = load("res://entities/scenes/NPC.tscn")
