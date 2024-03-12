extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(2.0).timeout
	
	var get_root = get_node("/root")
	var parent = get_node("/root/Chess3D")
	get_root.remove_child(parent)
	parent.call_deferred("free")
	
	get_root.add_child(GLOBAL.CHESS_SCENE)
