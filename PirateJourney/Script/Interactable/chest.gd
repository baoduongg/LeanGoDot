extends Node2D

class_name Chest
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("close")
	
func handle_open():
	$AnimationPlayer.play("open")
