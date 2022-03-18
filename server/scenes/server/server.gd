extends Node

var network := NetworkedMultiplayerENet.new()
var max_players := 20
var port := 2137
var player_state_collection := {}

onready var player_verification_process = get_node('player-verification')

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
	player_verification_process.start(player_id)


func _peer_disconnected(player_id):
	print("User " + str(player_id) + " disconnected")
	get_node(str(player_id)).queue_free()
	player_state_collection.erase(player_id)
	rpc_id(0, 'despawn_player', player_id)


remote func fetch_hp_and_fuel_level():
	print_debug('fetch_hp_and_fuel_level')
	var player_id := get_tree().get_rpc_sender_id()
	var helth = get_node(str(player_id)).car.helth
	var fuel = get_node(str(player_id)).car.fuel
	print_debug('fetch_hp_and_fuel_level')	
	rpc_id(player_id, 'return_hp_and_fuel_level', helth, fuel)


func spawn_player(player_id: float):
	rpc_id(0, 'spawn_player', player_id, Vector3(0, 0, 0), Basis(Vector3.ZERO, Vector3.ZERO, Vector3.ZERO))
	
	
remote func recive_player_state(state):
	var player_id := get_tree().get_rpc_sender_id()
	
	if not player_state_collection.has(player_id):
		player_state_collection[player_id] = state
	
	if player_state_collection[player_id]['T'] < state['T']:
		player_state_collection[player_id] = state


func send_word_state(state):
	rpc_unreliable_id(0, 'recive_word_state', state)
