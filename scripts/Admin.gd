extends Node2D

export var score := {"seeker":0,"hidden":0}
var seeker_list = []
var hidden_list = []
const seeker_spawn = Vector2(30,250)
var init_distance
var camera_lock = false
var started = false

onready var seeker_scene = preload("res://scenes/Seeker.tscn")
onready var hider_scene = preload("res://scenes/Hider.tscn")
onready var player_scene = preload("res://scenes/PlayerVinesh.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	update_score()
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
	spawnKapoka()

func spawnSeeker(id):
	var seeker = seeker_scene.instance()
	seeker.name = str(id)
	seeker.set_network_master(id)
	var cam = Camera2D.new()
	seeker_list.append(seeker)
	$GameCamera.make_current()
	$Seekers.add_child(seeker)
	seeker.position = seeker_spawn
	seeker.add_to_group("seeker")
	init_distance = seeker.position.distance_to($KapokaSpawn.position)
	
func spawnHider(id):
	$Path2D/PathFollow2D.unit_offset = randf()
	var hidden = hider_scene.instance()
	hidden.name = str(id)
	hidden.set_network_master(id)
	hidden_list.append(hidden)
	hidden.set_index_play(len(hidden_list))
	hidden.position = $Path2D/PathFollow2D.position
	$Hidden.add_child(hidden)
	hidden.set_process(false)
	pass
	
func spawnKapoka():
	var kapoka = player_scene.instance() as PlayerVinesh
	kapoka.get_node("ColorRect").color = Color.yellow
	kapoka.scale = Vector2(0.3,0.3)
	kapoka.position = $KapokaSpawn.position
	add_child(kapoka)
	kapoka.set_process(false)

func _process(delta):
	handleCamera(delta)

func handleCamera(delta):
	if(len(seeker_list) == 0) :
		return
	var seeker = seeker_list[0]
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
	win_round("hidden")
	pass
	
# called when a seeker touch the kapoka to guess a found player
func _on_kapoka_shaken():
	# freeze every mouvement
	toogle_player_process(false)
	# give the seeker an amount of time to choose the correct pseudo
	# the time is bound to the seeker, he will get a malus if the timer times out
	$SeekerGuessTimer.start()
	
func toogle_player_process(state: bool):
	for seeker in $Seekers.get_children():
		seeker.set_process(state)
	for hidden in $Hidden.get_children():
		hidden.set_process(state)
	
# called when a seeker make a guess
func _on_seeker_guess(true_ids,guess_ids):
	# check seeker's guess
	for i in len(true_ids) :
		if true_ids[i] != guess_ids[i] :
			win_round("seeker")
			pass
	for hider in $Hidden.get_children():
		if hider.getId() in true_ids :
			put_in_jail(hider)
	pass

func put_in_jail(hider):
	pass

# called when a hider touch a seeker
func _on_seeker_touched():
	# free an hider
	pass
	
# called when the timer is out
func _on_count_down_ends():
	win_round("hidden")
	
	
func win_round(group: String):
	score[group] = score[group] + 1
	reset_game()

func reset_game():
	pass
