extends Control

var player = load("res://scenes/Player.tscn");
var my_group = ""

onready var multi_config_ui = $Multiplayer_configure
onready var server_ip_adress = $Multiplayer_configure/Server_ip_adress
onready var device_ip_adress = $CanvasLayer/Device_ip_adress
onready var seeker_scene = preload("res://scenes/Seeker.tscn")
onready var hider_scene = preload("res://scenes/Hider.tscn")

signal spawn_seeker(id)

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	rpc_config("instance_puppet",MultiplayerAPI.RPC_MODE_REMOTE)
	device_ip_adress.text = Network.ip_adress


func _player_connected(id):
	print(str(id) + " connected")
	rpc_id(id,"instance_puppet",my_group)

func instance_puppet(group):
	if group == "seeker":
		instance_seeker(get_tree().get_rpc_sender_id())
	else :
		instance_hider(get_tree().get_rpc_sender_id())
	
func _player_disconected(id):
	print(str(id) + " disconnected")
	if Admin.has_node("Seekers/"+str(id)) :
		Admin.get_node("Sdeekers/"+str(id)).queue_free()
	elif Admin.has_node("Hidden/"+str(id)) :
		Admin.get_node("Hidden/"+str(id)).queue_free()


func _on_Create_server_pressed():
	multi_config_ui.hide()
	Network.create_server()
	
	instance_seeker(get_tree().get_network_unique_id())
	my_group = "seeker"


func _on_Join_server_pressed():
	var ip = server_ip_adress.text
	if ip != "":
		multi_config_ui.hide()
		Network.ip_adress = ip
		Network.join_server()


func _connected_to_server():
	yield(get_tree().create_timer(0.1), "timeout")
	instance_hider(get_tree().get_network_unique_id())
	my_group = "hider"
	
	
func instance_seeker(id):
	Admin.spawnSeeker(id)
	Admin.loadGameSound()
	
func instance_hider(id):
	Admin.spawnHider(id)
	Admin.loadGameSound()

