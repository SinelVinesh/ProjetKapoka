extends Node2D
class_name Kapoaka

signal voadaka(val)
signal entered_cercle(joueur)
signal exited_cercle(joueur)


func _ready():
	pass
func init_position(position) :
	self.position = position
	
func voadaka(joueur):
	emit_signal("voadaka")
	
func animate_voadaka():
	$object.mode = RigidBody2D.MODE_RIGID
	$object.add_force(Vector2.ZERO,Vector2(0,-20))
	$VodakaSound.play()
	$animation.play("tomber")

func _on_cercle_body_entered(body):
	emit_signal("entered_cercle",body)


func _on_collision_self_child_entered_tree(node):
	emit_signal("voadaka")


func _on_cercle_body_exited(body):
	emit_signal("exited_cercle",body)
