extends CharacterBody2D
class_name Player

@export var speed = 200.0
@export var jump_height = -400.0

@onready var animation = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var attack_area = $AttackArea/CollisionShape2D
var attacking = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	GameManager.player = self;
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"): #and is_on_floor():
		velocity.y = jump_height

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
		sprite.flip_h = direction == -1
		if direction == -1:
			attack_area.position.x = -25
		elif direction ==1:
			attack_area.position.x = 25
	else:
		#animation.play("Idle")
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if Input.is_action_just_pressed("attack"):
		handle_attack()
	update_animation(direction)
	move_and_slide()
	#if velocity.y >= 500:
		#die();
func update_animation(direction):
	if !attacking:
		if is_on_floor():
			if direction == 0:
				animation.play("Idle")
			else : 
				animation.play("Run")
		else: 
			if velocity.y < 0:
				animation.play("Jump")
			elif velocity.y > 0:
				animation.play("Fall")
func handle_attack():
	var overlapping_object = $AttackArea.get_overlapping_areas()
	#
	#for area in overlapping_object:
		#print("attack")
		#var parent = area.get_parent()
		#print(parent)
		#if parent is Chest
			#parent.handle_open();
	
	print("attack")
	attacking = true
	if not is_on_floor():
		animation.play("Attack_Air")
	elif is_on_floor():
		animation.play("Attack")
		
func die():
	sprite.flip_h = false
	GameManager.respawn_player()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Attack" or anim_name == "Attack_Air":
		attacking = false
