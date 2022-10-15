extends Control


onready var multi_config_ui = $Multiplayer_configure
onready var server_ip_adress = $Multiplayer_configure/Server_ip_adress
onready var device_ip_adress = $CanvasLayer/Device_ip_adress


func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	
	device_ip_adress.text = Network.ip_adress

func _player_connected(id):
	print(str(id) + " connected")
	
func _player_disconected(id):
	print(str(id) + " disconnected")

func _on_Create_server_pressed():
	multi_config_ui.hide()
	Network.create_server()


func _on_Join_server_pressed():
	var ip = server_ip_adress.text
	if ip != "":
		multi_config_ui.hide()
		Network.ip_adress = ip
		Network.join_server()
