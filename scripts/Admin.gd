extends Node2D

export var score := {"seeker":0,"hidden":0}
var player_scene
var seeker_list = []
var hidden_list = []
const seeker_spawn = Vector2(30,250)
var init_distance
var camera_lock = false
var started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	update_score()
	player_scene = preload("res://scenes/Player.tscn")
	start_game()
	

func update_score():
	$HUD/SeekerScore.text = "Team Seeker : "+str(score.get("seeker"))
	$HUD/HiddenScore.text = "Team Hidden : "+str(score.get("hidden"))

func _on_GameTimer_count_down(count):
	var minutes = count/60
	var secondes = count%60
	var text = "%d : %0-2d" % [minutes,secondes]
	$HUD/TimerLabel.text =  text

func start_game():
	spawnSeekers()
	spawnHidden()
	spawnKapoka()

func spawnSeekers():
	var seeker = player_scene.instance() as Player
	var cam = Camera2D.new()
	seeker_list.append(seeker)
	$Seekers.add_child(seeker)
	seeker.get_node("ColorRect").color = Color.dodgerblue
	seeker.position = seeker_spawn
	seeker.add_to_group("seeker")
	init_distance = seeker.position.distance_to($KapokaSpawn.position)
	pass
	
func spawnHidden():
	var hidden_count = 3
	for i in range(0,hidden_count):
		$Path2D/PathFollow2D.unit_offset = randf()
		var hidden = player_scene.instance() as Player
		hidden_list.append(hidden)
		hidden.get_node("ColorRect").color = Color.red
		hidden.position = $Path2D/PathFollow2D.position
		print("path : " + str($Path2D/PathFollow2D.position) + "; Hidden : "+ str(hidden.position))
		$Hidden.add_child(hidden)
		hidden.set_process(false)
	pass
	
func spawnKapoka():
	var kapoka = player_scene.instance() as Player
	kapoka.get_node("ColorRect").color = Color.yellow
	kapoka.scale = Vector2(0.3,0.3)
	kapoka.position = $KapokaSpawn.position
	add_child(kapoka)
	kapoka.set_process(false)

func _process(delta):
	handleCamera(delta)

func handleCamera(delta):
	var seeker = seeker_list[0] as Player
	var distance = seeker.position.distance_to($KapokaSpawn.position)
	var zoom = clamp(distance/ init_distance,0.3,1)
	if(!camera_lock) :
		$GameCamera.set_zoom(Vector2(zoom,zoom))
	if(zoom == 0.3) :
		camera_lock = true
	if(camera_lock):
		$GameCamera.position.x = seeker_list[0].position.x
		$GameCamera.position.y = seeker_list[0].position.y 

# called when the seekers reach the kapoka at the start of the game
func _on_kapoka_reached(body: Node):
	if(body.is_in_group("seeker") && !started) :
		$GameTimer.start()
		started = true
	
# called when a hider hit the kapoka
func _on_kapoka_hit():
	# add 1 to hider points
	# start next round
	pass
	
# called when a seeker touch the kapoka to guess a found player
func _on_kapoka_shaken():
	# freeze every mouvement
	# give the seeker an amount of time to choose the correct pseudo
	pass
	
# called when a seeker make a guess
func _on_seeker_guess():
	# check seeker's guess
	# if correct : 
		# put the hider in jail
	# if incorrect :
		# add 1 to hier points
		# start next round
	pass

# called when a hider touch a seeker
func _on_seeker_touched():
	# free an hider
	pass
	
# called when the timer is out
func _on_count_down_ends():
	# add 1 to hider points
	# start next round
	pass
	

