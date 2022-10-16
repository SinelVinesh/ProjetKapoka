extends Node2D

export var score := {"seeker":0,"hider":0}
var seeker_list = []
var hidden_list = []
const seeker_spawn = Vector2(30,250)
var init_distance
var camera_lock = false
var started = false
var kapoaka
var delay_freeze
var players = []

onready var seeker_scene = preload("res://scenes/Seeker.tscn")
onready var hider_scene = preload("res://scenes/Hider.tscn")
onready var kapoaka_scene = preload("res://scenes/Kapoaka.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Kapoaka.connect("entered_cercle",self,"_on_kapoaka_reached")
	$Kapoaka.connect("exited_cercle",self,"_on_kapoaka_exited")
	randomize()
	spawnKapoka()

func update_score():
	$HUD/SeekerScore.text = "Team Seeker : "+str(score.get("seeker"))
	$HUD/HiddenScore.text = "Team Hidden : "+str(score.get("hider"))

func _on_GameTimer_count_down(count):
	var minutes = count/60
	var secondes = count%60
	var text = "%d : %0-2d" % [minutes,secondes]
	$HUD/TimerLabel.text =  text

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
	seeker.connect("idTab",self,"_on_kapoaka_shaken")
	init_distance = seeker.position.distance_to($KapokaSpawn.position)
	
func spawnHider(id):
	var follow = $SpawnPath/SpawnFollow
	follow.unit_offset = randf()
	var hidden = hider_scene.instance()
	hidden.name = str(id)
	hidden.set_network_master(id)
	hidden_list.append(hidden)
	hidden.set_index_play(len(hidden_list))
	hidden.add_to_group("hider")
	print($Kapoaka.position)
	hidden.position = follow.position
	$Hidden.add_child(hidden)
	hidden.connect("kapoka_hit",self,"_on_kapoaka_hit")
	
func spawnKapoka():
	$Kapoaka.init_position($KapokaSpawn.position)

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
func _on_kapoaka_reached(node):
	if(node.is_in_group("seeker") && !started) :
		$GameTimer.start()
		started = true
	if(node.is_in_group("seeker") && started) :
		node.set_kasika(true)
	if(node.is_in_group("hider") && started) :
		node.set_hit(true)
	
func _on_kapoaka_exited(node):
	if(node.is_in_group("seeker")) :
		node.set_kasika(false)
	if(node.is_in_group("hider")) :
		node.set_hit(false)

# called when a hider hit the kapoka
func _on_kapoaka_hit(name):
	win_round("hider")
	rpc("win_round","hider")
	
# called when a seeker touch the kapoka to guess a found player
func _on_kapoaka_shaken(ids):
	# freeze every mouvement
	# toogle_player_process(false)
	# give the seeker an amount of time to choose the correct pseudo
	# the time is bound to the seeker, he will get a malus if the timer times out
	# $SeekerGuessTimer.start()
	rpc("eliminate",ids)
	
	
	
remotesync func eliminate(id) :
	for hidder in $Hidden.get_children():
		if hidder.name in id:
			hidder.queue_free()
	if len($Hidden.get_children()) ==1 :
		rpc("win_round","seeker")

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
	win_round("hider")
	rpc("win_round","hider")
	
remotesync func win_round(group: String):
	if(group == "hider") :
		$Kapoaka.animate_voadaka()
		$Kapoaka.get_node("animation").connect("animation_finished",self,"freeze_game")
		delay_freeze = true
	score[group] = score[group] + 1
	win_game(group)

func reset_game():
	pass
	
remotesync func win_game(group: String):
	if group == "seeker" :
		$HUD/VictoryPanel/VictoryText.text = "Victoire du Seeker"
	else :
		$HUD/VictoryPanel/VictoryText.text = "Victoire des Hiders"
	$HUD/VictoryPanel.show()
	$GameSong.fade_out()
	$VictorySound.play()
	if !delay_freeze:
		freeze_game("")

remotesync func freeze_game(anim_name):
	for seeker in $Seekers.get_children():
		seeker.set_physics_process(false)
		seeker.set_process(false)
	for hider in $Hidden.get_children():
		hider.set_physics_process(false)
		hider.set_process(false)

func add_player(id) :
	players.append(id)
	
func loadGameSound():
	$MenuTheme.fade_out()
	$GameSong.fade_in()
