extends "res://scripts/PlayerSteven.gd"
var kasyKpoka = false
signal idTab(idKasyKapoka) 
func _ready():
	speed *= 1.2
	pass 

func _process(delta):
	kasyKpoka()
	
func canKasika(can):
	kasyKpoka = can
	
func getKasyKpoka():
	return kasyKpoka
	
func kasyKpoka():
	if (kasyKpoka):
		$ChampVision.getIdTab()
		if Input.is_action_just_pressed("kpoka"):
			emit_signal("idTab",$ChampVision.getIdTab())
			print($ChampVision.getIdTab())
