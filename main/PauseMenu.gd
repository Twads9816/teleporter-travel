extends Sprite2D


func _unhandled_key_input(event):
	if event.is_action_released("pause"):
		toggle_pause()
		get_viewport().set_input_as_handled()


func toggle_pause():
	get_tree().paused = not get_tree().paused
	visible = not visible

func _on_resume_button_pressed():
	toggle_pause()


func _on_quit_button_pressed():
	get_tree().paused  = false
	get_tree().change_scene_to_file("res://title_screen/title_screen.tscn")
