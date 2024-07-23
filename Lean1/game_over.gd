extends Node2D



func _on_btn_restart_pressed():
	get_tree().change_scene_to_file("res://world.tscn")
	pass # Replace with function body.


func _on_btn_home_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
	pass # Replace with function body.
