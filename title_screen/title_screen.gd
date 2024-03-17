extends Control
@onready var button = $StartGame
var speed = 5
var time = 0
var sin_time = 0
var pulsed = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta*speed
	sin_time = sin(time*speed)

	if sin_time > 0 and pulsed == false:
		pulsed = true
		button.modulate = Color(randf(), randf(), randf(), 1)
	elif sin_time < 0 and pulsed == true:
		pulsed = false


func _on_start_game_mouse_entered():
	speed = 10
	

func _on_start_game_mouse_exited():
	speed = 5


func _on_start_game_pressed():
	pass # Replace with function body.

