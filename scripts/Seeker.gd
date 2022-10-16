extends Player
class_name Seeker

var kasyKpoka = false
signal idTab(idKasyKapoka) 
func _ready():
	speed *= 1.2
	pass 

func _process(delta):
	kasyKpoka()
	play_correct_animation()
	
func set_kasika(state):
	kasyKpoka = state
	
func getKasyKpoka():
	return kasyKpoka
	
func kasyKpoka():
	if (kasyKpoka):
		$ChampVision.getIdTab()
		if Input.is_action_just_pressed("action_button") && is_network_master():
			emit_signal("idTab",$ChampVision.getIdTab())
			print($ChampVision.getIdTab())
		
func play_correct_animation():
	if is_network_master():
		if Input.is_action_pressed("move_down"):
			$Sprite.play("down")
		elif Input.is_action_pressed("move_left"):
			$Sprite.play("left")
		elif Input.is_action_pressed("move_right"):
			$Sprite.play("right")
		elif Input.is_action_pressed("move_up"):
			$Sprite.play("up")



func _on_Network_tick_rate_timeout():
	._on_Network_tick_rate_timeout()
