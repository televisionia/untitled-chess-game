extends Area2D



func _on_body_entered(body):
	var get_root = get_node("/root")
	var parent = get_node("/root/InsidePiece")
	get_root.remove_child(parent)
	parent.call_deferred("free")
	
	get_root.add_child(GLOBAL.CHESS_SCENE)
