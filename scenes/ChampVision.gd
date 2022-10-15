extends Area2D
var idTab = Array()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	pass
	
func getIdTab():
	return idTab

func _on_ChampVision_body_entered(body):
	if body.is_in_group("Hider"):
		if !idTab.has(body.name):
			idTab.append(body.name)
	
