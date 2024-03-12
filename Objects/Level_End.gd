extends Area2D

@onready var VIEW_3D = preload("res://chess_3d.tscn")

func _on_body_entered(body):
	var get_root = get_node("/root")
	var parent = get_node("/root/InsidePiece")
	get_root.remove_child(parent)
	parent.call_deferred("free")
	
	get_root.add_child(VIEW_3D.instantiate())

func _ready():
	var get_root = get_node("/root")
	var parent = get_node("/root/InsidePiece")
	get_root.remove_child(parent)
	parent.call_deferred("free")
	
	get_root.add_child(VIEW_3D.instantiate())
