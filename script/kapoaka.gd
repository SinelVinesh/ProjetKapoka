extends Area2D

signal voadaka(val)
signal entered_cercle(joueur)
onready var anim=$animation

func _ready():
	position.x=200
	position.y=200

func voadaka(joueur):
	emit_signal("voadaka")
	
func animate_voadaka():
	$animation.play("tomber")
	pass



func _on_cercle_body_entered(body):
	#print(body. )
	emit_signal("entered_cercle",body)
	pass # Replace with function body.


func _on_Button_pressed():
	animate_voadaka()
	pass # Replace with function body.


