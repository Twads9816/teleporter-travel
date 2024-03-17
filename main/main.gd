extends Node

const PATTERNS = [
	[1,2,3,0,0,0,3,2,1,0,0,0],
	[
		[2,1,3,0,0,2,0,1,0,3,0,0],
		[0,1,0,3,0,2,0,1,0,3,0,2],
	],
	[
		[1,3,2,0,0,1,0,3,0,2,0,0],
		[0,3,0,2,0,1,0,3,0,2,0,1],
	],
	[1,0,2,0,3,0,1,0,2,0,3,0],
	[0,0,0,3,2,1,0,0,0,1,2,3],
	[1,3,2,0,0,0,2,3,1,0,0,0],
	[3,2,1,0,0,1,0,2,0,3,0,0],
	[
		[0,3,2,0,1,0,2,3,0,0,1,0],
		[1,3,2,0,0,0,2,3,1,0,0,0],
		[0,3,2,1,0,0,2,3,0,0,0,1],
		[0,3,2,0,0,1,2,3,0,1,0,0],
	],
	[
		[3,1,2,2,0,0,0,1,0,0,0,3],
		[3,0,2,2,1,0,0,0,0,0,1,3],
		[3,0,2,2,0,1,0,0,0,1,0,3],
	],
	[
		[2,0,0,3,0,1,1,0,0,3,0,2],
		[2,0,0,0,3,1,1,0,0,0,3,2],
	],
	[2,0,0,3,0,1,1,0,0,3,0,2],
	[1,3,2,0,0,0,2,3,1,0,0,0],
	[0,0,0,1,3,2,0,0,0,2,3,1],
	[0,0,0,2,1,3,0,0,0,3,1,2],
	[2,1,3,0,0,0,3,1,2,0,0,0],
	[3,2,1,0,0,0,1,2,3,0,0,0],
	[
		[0,0,0,3,1,2,2,0,0,1,3,0],
		[0,0,3,1,0,2,2,0,0,1,3,0],
	],
]

const WIN_SCREEN = preload("res://main/win_screen.png")
const WIN_SOUND = preload("res://win_sound.mp3")

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

var correct_patterns = []

var flag_id = null

var customer_id: int = 0

var trust: int = 50

var input_pattern = []

func _ready():
	randomize_flag()

func _unhandled_key_input(_event):
	trust = 90
	$TrustMeter.value = trust


func _on_teleport_button_pressed():
	$WireBox/TeleportButton.disabled = true
	#Teleport customer
	$TeleportEffect.visible = true
	$TeleportPlayer.play()
	$TeleportEffect.play()
	$Bubble.visible = false


func randomize_flag():
	flag_id = randi_range(0, 16)
	correct_patterns = PATTERNS[flag_id]
	$Bubble/Border/Flag.frame = flag_id


func _on_animation_player_animation_finished(_main):
	move_line()


func move_line():
	var tween = create_tween()
	tween.tween_property($Line.get_child((customer_id + 1)%3), "position", Vector2(136,-80), 0.5)
	tween.parallel().tween_property($Line.get_child((customer_id + 2)%3), "position", Vector2(0,-80), 0.5)
	tween.parallel().tween_property($Line.get_child(customer_id), "position", Vector2(416,-80), 0.75)
	tween.tween_property($Line.get_child(customer_id), "position", Vector2(416,-148), 0.25)
	tween.tween_callback($Bubble.set_visible.bind(true)).set_delay(0.5)
	tween.tween_callback($WireBox/TeleportButton.set_disabled.bind(false))


func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://title_screen/title_screen.tscn")


func _on_teleport_effect_animation_finished():
	#Check input against correct patterns
	input_pattern = sockets.map(func(socket): return socket.color_id)
	if correct_patterns == input_pattern or correct_patterns.has(input_pattern):
		trust += 10
		if trust == 100:
			get_tree().paused = true
			$EndScreen.texture = WIN_SCREEN
			$EndScreen/WinButton.visible = true
			$EndScreen/LoseButton.visible = false
			$EndScreen.visible = true
			$EndSoundPlayer.stream = WIN_SOUND
			$EndSoundPlayer.play()
	else:
		trust -= 10
		if not trust:
			get_tree().paused = true
			$EndScreen.visible = true
			$EndSoundPlayer.play()
	$TrustMeter.value = trust
	$Line.get_child(customer_id).position = Vector2(-136,-80)
	#Set new customer
	customer_id = (customer_id + 1)%3
	randomize_flag()
	#Move line
	move_line()
	$TeleportEffect.visible = false
