extends Node2D

@onready var sockets = [
	$WireBox/Socket1,
	$WireBox/Socket2,
	$WireBox/Socket3,
	$WireBox/Socket4,
	$WireBox/Socket5,
	$WireBox/Socket6,
	$WireBox/Socket7,
	$WireBox/Socket8,
	$WireBox/Socket9,
	$WireBox/Socket10,
	$WireBox/Socket11,
	$WireBox/Socket12,
]

var correct_pattern = []

var flag_id = null

const PATTERNS = [
	[1,2,3,0,0,0,3,2,1,0,0,0],
	[2,1,3,0,0,2,0,1,0,3,0,0],
	[1,3,2,0,0,1,0,3,0,2,0,0],
	[1,0,2,0,3,0,1,0,2,0,3,0],
	[0,0,0,3,2,1,0,0,0,1,2,3],
	[1,3,2,0,0,0,2,3,1,0,0,0],
	[3,2,1,0,0,1,0,2,0,3,0,0],
	[0,3,2,0,1,0,2,3,0,0,1,0],
	[3,1,2,2,0,0,0,1,0,0,0,3],
	[2,0,0,3,0,1,1,0,0,3,0,2],
	[2,0,0,3,0,1,1,0,0,3,0,2],
	[1,3,2,0,0,0,2,3,1,0,0,0],
	[0,0,0,1,3,2,0,0,0,2,3,1],
	[0,0,0,2,1,3,0,0,0,3,1,2],
	[2,1,3,0,0,0,3,1,2,0,0,0],
	[3,2,1,0,0,0,1,2,3,0,0,0],
	[0,0,0,3,1,2,2,0,0,1,3,0],
]

func _ready():
	randomize_flag()

func _unhandled_key_input(event):
	$Customer/AnimationPlayer.play("main")

func _on_button_pressed():
	if sockets.map(func(socket): return socket.color_id) == correct_pattern:
		$Trust.value += 10
	else:
		$Trust.value -= 10
	randomize_flag()

func randomize_flag():
	flag_id = randi_range(0, 16)
	correct_pattern = PATTERNS[flag_id]
	$Bubble/Border/Flag.frame = flag_id
