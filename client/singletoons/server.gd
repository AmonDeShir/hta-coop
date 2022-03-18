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
	get_node("/root/lounge").load_main_scene()


func _connection_failed():
	print("Connection failed")


func fetch_hp_and_fuel_level():
	print_debug('fetch_hp_and_fuel_level')
	rpc_id(1, "fetch_hp_and_fuel_level")


remote func return_hp_and_fuel_level(hp: int, fuel: int):
	print_debug('return_hp_and_fuel_level')
	get_node('/root/main/gui/hp-and-fuel').load_hp(hp)
	get_node('/root/main/gui/hp-and-fuel').load_fuel_level(fuel)


remote func despawn_player(player_id: int):
	get_node('/root/main/entity-manager').despawn_player(player_id)


remote func spawn_player(player_id: int, location: Vector3):
	get_node('/root/main/entity-manager').spawn_player(player_id, location)


func send_player_state(state):
	print_debug(state)
	rpc_unreliable_id(1, 'recive_player_state', state)


remote func recive_word_state(state):
	get_node('/root/main/entity-manager').update_word_state(state)
