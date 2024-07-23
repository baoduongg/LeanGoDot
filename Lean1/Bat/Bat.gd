extends CharacterBody2D


const SPEED = 3000.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var ap = $Container/AnimationPlayer
@onready var sprite = $Sprite2D
@onready var container = $Container
@onready var player = $"../Player"
var player_in_sight
func _physics_process(delta):
	if player_in_sight:
		velocity =(player.position - self.position).normalized() * SPEED * delta;
		print("bat",self.position.x)
		print("player",player.position.x)
		if self.position.x > player.position.x:
			sprite.flip_h =false;
		elif self.position.x < player.position.x:
			sprite.flip_h =true;
		move_and_slide()


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene_to_file("res://game_over.tscn")
	pass # Replace with function body.


func _on_player_in_sight(body):
	if body.name == "Player":
			player_in_sight = true;
	pass # Replace with function body.


func _on_sight_body_exited(body):
	if body.name == "Player":
			player_in_sight = false;
	pass # Replace with function body.
