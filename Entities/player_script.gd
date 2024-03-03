extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D

const BASE_SPEED = 100.0
var CURRENT_SPEED = 0
const JUMP_VELOCITY = -200.0
var CURRENT_JUMP_VELOCITY = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var counter = 1

func _ready():
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($BaseLight, "texture_scale", 3, 1)
	tween.tween_property($CollidingLight, "texture_scale", 3, 3)
	visible = true
	await tween.finished
	CURRENT_JUMP_VELOCITY = JUMP_VELOCITY
	CURRENT_SPEED = BASE_SPEED

func _on_animated_sprite_2d_frame_changed():
	if _animated_sprite.animation == "walk":
		if counter >= 1:
			get_node("Sounds/Step").play()
			counter = 0
		else:
			counter += 1

func _process(delta):
	if CURRENT_SPEED > 0:
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

	if Input.is_action_just_pressed("move_up") and is_on_floor() and CURRENT_JUMP_VELOCITY != 0:
		velocity.y = CURRENT_JUMP_VELOCITY
		get_node("Sounds/Step").play()

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * CURRENT_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, CURRENT_SPEED)

	move_and_slide()

