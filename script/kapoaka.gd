extends Area2D

signal voadaka(val)
signal entered_cercle(joueur)


func _ready():
	position.x=100
	position.y=100

func voadaka(joueur):
	emit_signal("voadaka")
	
func animate_voadaka():
	$animation.play("tomber")
	pass

func _on_cercle_body_entered(body):
	emit_signal("entered_cercle",body)
	pass


func _on_collision_self_child_entered_tree(node):
	emit_signal("voadaka")
	pass # Replace with function body.
