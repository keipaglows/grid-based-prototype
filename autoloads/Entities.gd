extends Node

# entities

## obstacles
var obstacles = load("res://entities/classes/obstacles.gd")
var TreeObstacle = obstacles.TreeObstacle

## objects
var objects = load("res://entities/classes/objects.gd")
var MoneyObject = objects.MoneyObject

## npc
var npcs = load("res://entities/classes/npcs.gd")
var MouseNPC = npcs.MouseNPC


# entity scenes
var ObstacleScene = load("res://entities/scenes/Obstacle.tscn")
var ObjectScene = load("res://entities/scenes/Object.tscn")
var NPCScene = load("res://entities/scenes/NPC.tscn")
