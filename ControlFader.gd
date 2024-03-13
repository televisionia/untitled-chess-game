extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	if GLOBAL.CURRENT_TURN == 0:
		await get_tree().create_timer(6).timeout
		$ControlsLabel.text = "Use WASD to move and wall jump."
		visible = true
		await get_tree().create_timer(10).timeout
		visible = false
		await get_tree().create_timer(3).timeout
		$ControlsLabel.text = "The machine needs an energy source."
		visible = true
		await get_tree().create_timer(8).timeout
		$ControlsLabel.text = "Find it."
		await get_tree().create_timer(4).timeout
		visible = false
