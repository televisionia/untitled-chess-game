extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D

const SPEED = 100.0
const JUMP_VELOCITY = -250.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var counter = 1

func _on_animated_sprite_2d_frame_changed():
	if _animated_sprite.animation == "walk":
		if counter >= 1:
			get_node("Sounds/Step").play()
			counter = 0
		else:
			counter += 1
	

func _process(delta):
	if Input.is_action_pressed("move_left") and is_on_floor():
		_animated_sprite.scale.x = 1
		_animated_sprite.play("walk")
	elif Input.is_action_pressed("move_right") and is_on_floor():
		_animated_sprite.scale.x = -1
		_animated_sprite.play("walk")
	else:
		_animated_sprite.scale.x = 1
		_animated_sprite.play("default")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("move_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		get_node("Sounds/Step").play()

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

