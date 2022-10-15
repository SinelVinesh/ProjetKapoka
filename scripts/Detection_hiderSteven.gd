extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	pass
	
func _on_Detection_hider_body_entered(body):
	if body.is_in_group("Hider"):
		body.canhit(true)
	if body.is_in_group("Seeker"):
		body.canKasika(true)
func _on_Detection_hider_body_exited(body):
	if body.is_in_group("Hider"):
		body.canhit(false)
	if body.is_in_group("Seeker"):
		body.canKasika(false)
