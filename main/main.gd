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
const WIN_SOUND = preload("res://main/win_sound.mp3")
const GROUPS = [
	"Top",
	"Right",
	"Bottom",
	"Left"
]
const INVALID_SOUND = preload("res://main/invalid_pattern.wav")
const FAIL_SOUND = preload("res://main/tele_fail_sound2.wav")

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

@onready var customers = [
	$Line/Customer1, 
	$Line/Customer2, 
	$Line/Customer3,
]

var correct_patterns = null

var flag_id = null

var customer_id: int = 0

var trust: int = 50

var input_pattern = null

var wrong_player_state: int = 0

func _ready():
	randomize_flag()

#func _unhandled_key_input(_event):
	#trust = 90
	#$TrustMeter.value = trust


func _on_teleport_button_pressed():
	#Validate input
	var group_color_ids = []
	var valid: bool = true
	var id: int = 0
	for group in GROUPS:
		group_color_ids = get_tree().get_nodes_in_group(group).map(get_color_id)
		for i in 2:
			id = group_color_ids.pop_back()
			#Check if socket is plugged first, and then if there are other in the group with the same color ids
			if id and group_color_ids.has(id):
				valid = false
				if not valid:
					break
		if not valid:
			break
	if valid:
		$WireBox/TeleportButton.disabled = true
		$TeleportEffect.visible = true
		$TeleportPlayer.play()
		$TeleportEffect.play()
		$Bubble.visible = false
	else:
		play_wrong_player(1)


func randomize_flag():
	flag_id = randi_range(0, 16)
	correct_patterns = PATTERNS[flag_id]
	$Bubble/Border/Flag.frame = flag_id


func _on_animation_player_animation_finished(_main):
	move_line()


func move_line():
	var CurrentCustomer: AnimatedSprite2D = $Line.get_child((customer_id))
	var NextCustomer: AnimatedSprite2D = $Line.get_child((customer_id + 1)%3)
	var OnDeckCustomer: AnimatedSprite2D = $Line.get_child((customer_id + 2)%3)
	for customer in customers:
		customer.play("walk")
	var tween = create_tween()
	tween.tween_property(NextCustomer, "position", Vector2(136,-80), 0.5)
	tween.parallel().tween_property(OnDeckCustomer, "position", Vector2(0,-80), 0.5)
	tween.parallel().tween_property(CurrentCustomer, "position", Vector2(416,-80), 0.75)
	tween.tween_callback(NextCustomer.set_animation.bind("idle"))
	tween.tween_callback(OnDeckCustomer.set_animation.bind("idle"))
	tween.tween_property(CurrentCustomer, "position", Vector2(416,-149), 0.25)
	tween.tween_callback(CurrentCustomer.set_animation.bind("idle"))
	tween.tween_callback($Bubble.set_visible.bind(true)).set_delay(0.5)
	tween.tween_callback($WireBox/TeleportButton.set_disabled.bind(false))


func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://title_screen/title_screen.tscn")


func _on_teleport_effect_animation_finished():
	var done: bool = false
	#Check input against correct patterns
	input_pattern = sockets.map(get_color_id)
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
			done = true
	else:
		play_wrong_player(0)
		trust -= 10
		if not trust:
			get_tree().paused = true
			$EndScreen.visible = true
			$EndSoundPlayer.play()
			done = true
	$TrustMeter.value = trust
	$Line.get_child(customer_id).position = Vector2(-136,-80)
	#Set new customer
	customer_id = (customer_id + 1)%3
	randomize_flag()
	$TeleportEffect.visible = false
	#Move line
	if not done:
		move_line()


func get_color_id(socket: Area2D):
	return socket.color_id


func play_wrong_player(new_state: int):
	if new_state != wrong_player_state:
		wrong_player_state = new_state
		match new_state:
			0:
				$WrongPlayer.stream = FAIL_SOUND
				$WrongPlayer.pitch_scale = 1
				$WrongPlayer.volume_db = -5
			1:
				$WrongPlayer.stream = INVALID_SOUND
				$WrongPlayer.pitch_scale = 1.5
				$WrongPlayer.volume_db = -15
	$WrongPlayer.play()


func _on_rules_button_toggled(toggled_on):
	$Rules.visible = toggled_on
	$WireBox/TeleportButton.disabled = toggled_on
