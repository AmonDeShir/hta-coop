extends Spatial

onready var player_template := preload("res://scenes/player-template/player-template.tscn")
var last_word_state := 0

func despawn_player(player_id: int):
	$players.get_node(str(player_id)).queue_free()


func spawn_player(player_id: int, location, rotation):
	if not is_client(player_id):
		var player = player_template.instance()
		player.name = str(player_id)
		player.translation = location
		player.rotation = rotation
		$players.add_child(player)


func is_client(player_id):
	return get_tree().get_network_unique_id() == player_id or $players.has_node(str(player_id))


func update_word_state(state):
	if last_word_state >= state['T']:
		return

	last_word_state = state['T']
	state.erase('T')
	state.erase(get_tree().get_network_unique_id())
	
	for player in state.keys():
		if $players.has_node(str(player)):
			$players.get_node(str(player)).move_player(state[player]['P'])
			$players.get_node(str(player)).rotate_player(state[player]['WB'])
		else:
			spawn_player(player, state[player]['P'], state[player]['WB'])
			
