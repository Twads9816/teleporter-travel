extends Area2D

var color_id: int = 0

var Pin: Area2D

func plug(new_pin: Area2D):
	if Pin and Pin != new_pin:
		Pin.swap()
	Pin = new_pin
	color_id = new_pin.color_id


func unplug():
	Pin = null
	color_id = 0

