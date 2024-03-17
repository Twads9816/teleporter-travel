extends Control
@onready var button = $StartGame
@onready var timer = $Flash

func _on_start_game_mouse_entered():
	timer.wait_time = 0.1


func _on_start_game_mouse_exited():
	timer.wait_time = 1


func _on_start_game_pressed():
	pass # Replace with function body.


func _on_flash_timeout():
	button.modulate = Color(randf(), randf(), randf(), 1)
