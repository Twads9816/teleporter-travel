extends Area2D

signal moved(new_position: Vector2)
signal inserted()

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
				insert()
			get_viewport().set_input_as_handled()
		elif event is InputEventMouseMotion:
			move(get_global_mouse_position())
			#Unplug
			if plugged:
				Socket.unplug()
				plugged = false
			get_viewport().set_input_as_handled()


func _on_area_entered(area):
	Socket = area


func _on_area_exited(_area):
	Socket = null


func swap():
	plugged = false
	move(global_position.lerp(Vector2(894,290), 0.25))


func move(new_position: Vector2):
	global_position = new_position
	moved.emit(position)


func insert():
	move(Socket.global_position)
	Socket.plug(self)
	plugged = true
