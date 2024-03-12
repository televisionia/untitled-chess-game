extends Area2D

var activated = false

@onready var VIEW_3D = preload("res://chess_3d.tscn")
@onready var animation = $AnimatedSprite2D

func _on_body_entered(body):
	if GLOBAL.CURRENT_PLAYER != null:
		if body == GLOBAL.CURRENT_PLAYER:
			if GLOBAL.CURRENT_PLAYER_ITEM != null:
				if GLOBAL.CURRENT_PLAYER_ITEM.name == "Battery":
					GLOBAL.CURRENT_PLAYER.remove_child(GLOBAL.CURRENT_PLAYER_ITEM)
					GLOBAL.CURRENT_PLAYER_ITEM.queue_free()
					GLOBAL.CURRENT_PLAYER_ITEM = null
					animation.play("activate")
					await animation.animation_finished
					animation.play("activated")
					var get_root = get_node("/root")
					var parent = get_node("/root/InsidePiece")
					get_root.remove_child(parent)
					parent.call_deferred("free")
					get_root.add_child(VIEW_3D.instantiate())
					GLOBAL.CURRENT_PLAYER = null
