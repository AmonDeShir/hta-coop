extends Node

var network := NetworkedMultiplayerENet.new()
var max_players := 20
var port := 2137


func _ready():
	start_server()


func start_server():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print("Start server")
	
	network.connect("peer_connected", self, "_peer_connected")
	network.connect("peer_disconnected", self, "_peer_disconnected")


func _peer_connected(player_id):
	print("User " + str(player_id) + " connected")


func _peer_disconnected(player_id):
	print("User " + str(player_id) + " disconnected")
