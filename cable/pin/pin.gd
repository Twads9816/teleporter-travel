extends Area2D

signal moved(new_position: Vector2)

var _picked: bool = false
var Socket = null

func _input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("click"):
		_picked = true
		get_viewport().set_input_as_handled()


func _unhandled_input(event):
	if _picked:
		if event.is_action_released("click"):
			_picked = false
			if Socket:
				global_position = Socket.global_position
				moved.emit(position)
			get_viewport().set_input_as_handled()
		elif event is InputEventMouseMotion:
			global_position = get_global_mouse_position()
			moved.emit(position)
			get_viewport().set_input_as_handled()


func _on_area_entered(area):
	Socket = area


func _on_area_exited(_area):
	Socket = null
