extends Node

signal gained_coins()

var current_checkpoint: Checkpoint
var player : Player
var coins : int
func respawn_player():
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position

func gain_coins(coins_gained : int):
	coins += coins_gained
	emit_signal("gained_coins")
