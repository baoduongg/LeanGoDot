extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var ap = $Container/AnimationPlayer
@onready var sprite = $Sprite2D
@onready var container = $Container
@onready var collision = $CollisionShape2D
@onready var raycat1 = $playerRaycat1
@onready var raycat2 = $playerRaycat2

var is_crouching = false;
var crouch_cshape = preload("res://assets/resources/player_crouch_cshape.tres")
var stand_cshape = preload("res://assets/resources/player_stand_cshape.tres")
var stuck_under_object = false;

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == 1 or direction == -1:
		velocity.x = direction * SPEED
		switch_direction(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
		
	update_animation(direction)
	if Input.is_action_just_pressed("Attack"):
		ap.play("Attack")
	if Input.is_action_just_pressed("ui_down"):
			crouching()
	elif Input.is_action_just_released("ui_down"):
		if is_empty_ahead():
			stand()
		else:
			stuck_under_object = true
			print("not stand")
			
	if stuck_under_object && is_empty_ahead():
		if !Input.is_action_just_pressed("ui_down"):
			stuck_under_object = false;
			stand()
	move_and_slide()
	
func is_empty_ahead() -> bool:
	return !raycat1.is_colliding() && !raycat2.is_colliding()
	
func update_animation(direction):
	if is_on_floor():
		if direction == 0:
			if is_crouching:
				ap.play("Crouch")
			else:
				ap.play("Idle")
		else:
			if is_crouching:
				ap.play("Crouch_Walk")
			else:
				ap.play("Run")
	else:
		if !is_crouching:
			if velocity.y < 0:
				ap.play("Jump")
			elif velocity.y > 0:
				ap.play("Fall")
		else:
			ap.play("Crouch")
			
func switch_direction(direction):
	sprite.flip_h = direction == -1
	sprite.position.x = direction*4

func crouching():
	if is_crouching:
		return
	is_crouching = true
	collision.shape = crouch_cshape
	collision.position.y = 3.938
	collision.position.x = 3.5
	raycat1.position.x = -8
	raycat2.position.x = 15
func stand():
	is_crouching = false
	collision.shape = stand_cshape
	collision.position.y = -0.625
	collision.position.x = 0.5
	raycat1.position.x= -6
	raycat2.position.x = 7
	
