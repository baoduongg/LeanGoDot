extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var ani = $Container/AnimatedSprite2D
@onready var aniPlay = $Container/AnimatedSprite2D/AnimationPlayer
@onready var containerAni  = $Container
@onready var swordHit = $SwordHitArea
var attacking= false;
var rolling = false;

func _handle_death():
	ani.play("death")

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
		containerAni.scale.x = direction
		swordHit.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("attack"):
		handleAttack()
	elif Input.is_action_just_pressed("roll"):
		rolling = true;
		
	updateAnimation(direction)
	move_and_slide()

func updateAnimation(direction):
	if !attacking:
		if not is_on_floor():
			rolling = false
			if velocity.y < 1:
				ani.play("jump_up")
			elif velocity.y > 1:
				ani.play("jump_down")
		elif direction == 1 or direction == -1:
			if rolling:
				ani.play("roll") 
			elif !rolling:
				ani.play("run") 
		else:
			if rolling:
				ani.play("roll") 
			elif !rolling:
				ani.play("idle")

func handleAttack():
	attacking = true;
	print(velocity.y)
	if velocity.y < 0:
		aniPlay.play("Attack_Air")
	elif velocity.y == 0:
		aniPlay.play("Attack")
	
func handleRoll():
	rolling = true;
	
func _on_animated_sprite_2d_animation_finished():
	print(" finished"+ani.animation)
	if ani.animation == "attack" or ani.animation == "attack_air" :
		attacking = false
	elif ani.animation == "roll":
		rolling = false;


func _sword_hit_area_entered(body):
	if body.name == "Bat":
		print("hit bat")
		body._handle_death()
	pass # Replace with function body.


func _on_area_body_entered(body):
	if body.name == "Bat":
		_handle_death()
	pass # Replace with function body.
