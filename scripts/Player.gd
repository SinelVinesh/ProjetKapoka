extends KinematicBody2D
class_name Player

var speed = 200
var velocity = Vector2.ZERO
var footsteps = []
var step = 0
var tween
var play_footstep = true

puppet var puppet_position = Vector2.ZERO setget puppet_position_set
puppet var puppet_velocity = Vector2()

func _ready():
	if tween == null :
		tween = $Tween
	var paths = ["res://assets/sound/foot_l.mp3","res://assets/sound/foot_r.mp3"]
	for path in paths:
		var file = File.new()
		if file.file_exists(path):
			file.open(path, file.READ)
			var buffer = file.get_buffer(file.get_len())
			var stream = AudioStreamMP3.new()
			stream.data = buffer
			footsteps.append(stream)
	get_node('Footstep').connect("finished",self,"_on_footstep_finished")
	

func _physics_process(delta):
	if is_network_master():
		move(delta)
	else:
		if not tween.is_active():
			move_and_collide(puppet_velocity * speed)
	
	
func get_velocity(delta):
	var x_input = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	var y_input = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	velocity = Vector2(x_input, y_input).normalized() * speed
	
	return velocity

func analyse_col(col):
	pass
	
	
func move (delta):
	var velocity = get_velocity(delta)
	var col = move_and_collide(velocity * delta)
	if(play_footstep and velocity != Vector2.ZERO) :
		step = (step + 1) % 2
		var audio = get_node("Footstep");
		audio.stream = footsteps[step]
		audio.play()
		play_footstep = false
	analyse_col(col)
	

func puppet_position_set(new_value):
	puppet_position = new_value
	tween.interpolate_property(self, "global_position", global_position, puppet_position, 0.1)
	tween.start()


func _on_Network_tick_rate_timeout():
	if is_network_master():
		rset_unreliable("puppet_position", global_position)
		rset_unreliable("puppet_velocity", velocity)

func _on_footstep_finished():
	play_footstep = true
