extends Player
class_name Hider

var hitkpoka = false
signal idHiderHit(idHit)
# Called when the node enters the scene tree for the first time.
func _ready():
	if is_network_master():
		$Camera.make_current()

func _process(delta):
	hitKpoka()
	
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
