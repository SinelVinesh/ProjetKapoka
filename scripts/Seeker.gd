extends "res://scripts/Player.gd"

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move(delta)

func move(delta):
	var velocity = get_velocity(delta)
	var col = move_and_collide(velocity * delta)
