extends Area2D

signal voadaka(val)
signal entered_cercle(joueur)

func _ready():
	position.x=get_viewport().x/2
	position.y=get_viewport().y/2

func voadaka(joueur):
	emit_signal("voadaka")
	
func animate_voadaka():
	
	pass


func _on_cercle_body_entered(body):
	#print(body. )
	emit_signal("entered_cercle",body )
	pass # Replace with function body.
