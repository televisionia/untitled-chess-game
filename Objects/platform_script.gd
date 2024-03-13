extends AnimatableBody2D

@export var end_offset = Vector2(0,0)
@export var move_weight = 0.1

var start
var end

var current_goal

var time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	start = Vector2(position.x, position.y)
	end = start + end_offset

func _process(delta):
	if current_goal != null:
		if time >= move_weight:
			if current_goal == end:
				time = 0.0
				current_goal = start
			else:
				time = 0.0
				current_goal = end
	else:
		time = 0.0
		current_goal = end

func _physics_process(delta):
	time += delta * move_weight
	
	if current_goal != null:
		position = position.lerp(current_goal, time)
