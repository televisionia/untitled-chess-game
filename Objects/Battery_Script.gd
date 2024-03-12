extends RigidBody2D

func _on_pickup_body_entered(body):
	if GLOBAL.CURRENT_PLAYER != null and GLOBAL.CURRENT_PLAYER_ITEM == null:
		if body == GLOBAL.CURRENT_PLAYER:
			GLOBAL.CURRENT_PLAYER_ITEM = self
			var parent = get_parent()
			parent.remove_child(self)
			GLOBAL.CURRENT_PLAYER.add_child(self)
			collision_layer = 0
			collision_mask = 0
			$Pickup.collision_layer = 0
			$Pickup.collision_mask = 0
			owner = GLOBAL.CURRENT_PLAYER
