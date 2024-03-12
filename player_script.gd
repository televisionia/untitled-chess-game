extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
@onready var RAYCAST_LEFT = $RayCastLeft
@onready var RAYCAST_RIGHT = $RayCastRight
@onready var BASE_LIGHT = $BaseLight
@onready var COLLIDING_LIGHT = $CollidingLight
@onready var WALL_JUMP_TIMER = $WallJumpTimer

const BASE_SPEED = 100.0
const MAX_SPEED = 120.0
var CURRENT_SPEED = 0
const JUMP_VELOCITY = -200.0
var CURRENT_JUMP_VELOCITY = 0
const WALL_JUMP_VELOCITY = 200

const WALL_JUMP_TIME = 0.2

var WALL_JUMP_COOLDOWN = false



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
		if Input.is_action_pressed("move_left"):
			_animated_sprite.scale.x = 1
			
			if is_on_floor():
				_animated_sprite.play("walk")
			elif RAYCAST_LEFT.is_colliding():
				_animated_sprite.play("on_wall")
			else:
				_animated_sprite.play("jump")
				
		elif Input.is_action_pressed("move_right"):
			_animated_sprite.scale.x = -1
			
			if is_on_floor():
				_animated_sprite.play("walk")
			elif RAYCAST_RIGHT.is_colliding():
				_animated_sprite.play("on_wall")
			else:
				_animated_sprite.play("jump")
				
		else:
			_animated_sprite.scale.x = 1
			_animated_sprite.play("default")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		if (RAYCAST_LEFT.is_colliding() and Input.is_action_pressed("move_left")) or (RAYCAST_RIGHT.is_colliding() and Input.is_action_pressed("move_right")):
			velocity.y -= velocity.y / 5
	
	var direction = Input.get_axis("move_left", "move_right")
	if direction and WALL_JUMP_COOLDOWN == false:
		velocity.x = move_toward(velocity.x, direction * CURRENT_SPEED, CURRENT_SPEED)
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, CURRENT_SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, delta)
	
	if Input.is_action_just_pressed("move_up") and CURRENT_JUMP_VELOCITY != 0:
		if is_on_floor():
			velocity.y = CURRENT_JUMP_VELOCITY
			get_node("Sounds/Step").play()
		else:
			if ((RAYCAST_LEFT.is_colliding() or RAYCAST_RIGHT.is_colliding()) and (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"))) and WALL_JUMP_COOLDOWN == false:
				get_node("Sounds/Step").play()
				velocity.y = JUMP_VELOCITY * 0.8
				WALL_JUMP_COOLDOWN = true
				WALL_JUMP_TIMER.start(WALL_JUMP_TIME)
				if RAYCAST_LEFT.is_colliding():
					velocity.x = WALL_JUMP_VELOCITY
				if RAYCAST_RIGHT.is_colliding():
					velocity.x = -WALL_JUMP_VELOCITY
					
	if GLOBAL.CURRENT_PLAYER_ITEM != null:
		GLOBAL.CURRENT_PLAYER_ITEM.position = Vector2(0, -20)
	
	move_and_slide()

func _on_wall_jump_timer_timeout():
	WALL_JUMP_COOLDOWN = false
