extends Node2D
var MAP = load("res://Maps/" + GLOBAL.NEXT_MAP + ".tscn")

var PLAYER = preload("res://Entities/player.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	var map_object = MAP.instantiate()
	map_object.name = "Map"
	add_child(map_object)
	map_object.owner = self
	
	var player = PLAYER.instantiate()
	player.position = $Map/PlayerSpawn.position
	add_child(player)
	player.owner = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
