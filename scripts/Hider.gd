extends Player
class_name Hider

var hitkpoka = false
signal idHiderHit(idHit)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
	
