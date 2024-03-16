extends Node2D



func _on_pin_1_moved(new_position):
	$Wire.set_point_position(0, new_position)


func _on_pin_2_moved(new_position):
	$Wire.set_point_position(1, new_position)
