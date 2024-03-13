extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Explode").play()
	play("explode")
	await animation_finished
	var parent = get_parent()
	parent.remove_child(self)
	queue_free()
