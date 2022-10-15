extends KinematicBody2D
class_name PlayerVinesh

var velocity : Vector2
export var speed = 200.0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	velocity = Vector2.ZERO
	if(Input.is_action_pressed("ui_left")):
		velocity.x = -1
	if(Input.is_action_pressed("ui_right")):
		velocity.x = 1
	if(Input.is_action_pressed("ui_down")):
		velocity.y = 1
	if(Input.is_action_pressed("ui_up")):
		velocity.y = -1
		
	move_and_collide(velocity.normalized()*speed*delta)
