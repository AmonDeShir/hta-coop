extends Node

var network := NetworkedMultiplayerENet.new()
var port := 2137
var ip := "127.0.0.1"

func _ready():
	connect_to_server()


func connect_to_server():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_succeeded", self, "_connection_successs")
	network.connect("connection_failed", self, "_connection_failed")


func _connection_successs():
	print("Connection success")


func _connection_failed():
	print("Connection failed")
