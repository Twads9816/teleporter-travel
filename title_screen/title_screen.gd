extends Control
@onready var button = $StartGame
@onready var timer = $Flash


func _ready():
	get_tree().paused = false


func _on_start_game_mouse_entered():
	timer.wait_time = 0.1


func _on_start_game_mouse_exited():
	timer.wait_time = 1


func _on_start_game_pressed():
	get_tree().change_scene_to_file("res://main/main.tscn")


func _on_flash_timeout():
	button.modulate = Color(randf(), randf(), randf(), 1)
