extends Player
class_name Hider

var index;

var hitkpoka = false
signal idHiderHit(idHit)
# Called when the node enters the scene tree for the first time.
func _ready():
	if is_network_master():
		$Camera.make_current()

func _process(delta):
	hitKpoka()
	play_correct_animation()
	
func _physics_process(delta):
	hitKpoka()
	play_correct_animation()
	
func canhit(can):
	hitkpoka = can

func getHitKpoka():
	return hitkpoka

func hitKpoka():
	if (hitkpoka):
		if Input.is_action_just_pressed("kpoka"):
			emit_signal("idHiderHit",name)
	


func _on_Network_tick_rate_timeout():
	._on_Network_tick_rate_timeout()
	
func set_index_play(i):
	index = i
	$AnimatedSprite.play("down_"+str(index))
	

func play_correct_animation():
	if is_network_master():
		if Input.is_action_pressed("move_down"):
			$AnimatedSprite.play("down_"+str(index))
		elif Input.is_action_pressed("move_left"):
			$AnimatedSprite.play("left_"+str(index))
		elif Input.is_action_pressed("move_right"):
			$AnimatedSprite.play("right_"+str(index))
		elif Input.is_action_pressed("move_up"):
			$AnimatedSprite.play("up_"+str(index))
