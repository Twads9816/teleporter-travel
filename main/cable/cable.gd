@tool
extends Node2D

@export var color_id: int:
	set(value):
		var color: Color
		color_id = value
		match value:
			1:
				color = Color(1,1,1,1)
			2:
				color = Color(1,0,0,1)
			3:
				color = Color(0,0,1,1)
		$Wire.default_color = color


func _ready():
	if not Engine.is_editor_hint():
		$Pin1.color_id = color_id
		$Pin2.color_id = color_id

func _on_pin_1_moved(new_position):
	$Wire.set_point_position(0, new_position)


func _on_pin_2_moved(new_position):
	$Wire.set_point_position(1, new_position)
