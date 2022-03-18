extends Node

var word_state := {}


func _physics_process(delta):
	if get_parent().player_state_collection.empty():
		return
	
	word_state = get_parent().player_state_collection.duplicate(true)
	_update_time()
	get_parent().send_word_state(word_state)


func _update_time():
	for player in word_state.keys():
		word_state[player].erase('T')
	word_state['T'] = OS.get_system_time_msecs()
