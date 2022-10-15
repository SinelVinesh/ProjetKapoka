extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _draw():
	var s = $Detection_hider/CollisionShape2D.shape.extents
	draw_rect(Rect2($Detection_hider.position-s, s * 2), Color(0, 1, 1, 0.1))
