extends Area2D

signal moved(new_position: Vector2)

var picked: bool = false
var Socket = null
var color_id = 0
var plugged: bool = false

func _input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("click"):
		picked = true
		get_viewport().set_input_as_handled()


func _unhandled_input(event):
	if picked:
		if event.is_action_released("click"):
			picked = false
			if Socket:
				#Move
				global_position = Socket.global_position
				moved.emit(position)
				#Plug
				Socket.color_id = color_id
				Socket.pin = self
				plugged = true
			get_viewport().set_input_as_handled()
		elif event is InputEventMouseMotion:
			#Move
			global_position = get_global_mouse_position()
			moved.emit(position)
			#Unplug
			if plugged:
				Socket.color_id = 0
				plugged = false
			get_viewport().set_input_as_handled()


func _on_area_entered(area):
	Socket = area


func _on_area_exited(_area):
	Socket = null
