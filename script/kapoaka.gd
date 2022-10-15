extends Area2D

signal voadaka(val)
signal entered_cercle(joueur)
onready var anim=$animation

func _ready():
	position.x=get_viewport().x/2
	position.y=get_viewport().y/2

func voadaka(joueur):
	emit_signal("voadaka")
	
func animate_voadaka():
	$animation.play("tombe")
	var t = Timer.new()
	t.set_wait_time(1)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	$animation.stop()
	pass



func _on_cercle_body_entered(body):
	#print(body. )
	emit_signal("entered_cercle",body)
	pass # Replace with function body.
