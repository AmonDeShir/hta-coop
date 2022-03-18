extends Node


onready var player_container_scene := preload("res://scenes/instances/player-container/player-container.tscn")

func start(player_id: int):
	"""
	AUTHENTICATE PLAYER THERE!!!!
	USE JWT TOKEN OR SOMETHING
	"""
	create_player_container(player_id)
	

func create_player_container(player_id: int):
	var container_scene := player_container_scene.instance()
	container_scene.name = str(player_id)
	get_parent().add_child(container_scene, true)
	
	var container_node = get_node('../' + str(player_id))
	fill_player_container(container_node)
	get_parent().spawn_player(player_id)


func fill_player_container(player_container: Node):
	player_container.car = CarTypes.Car.new('bugChassis', 'bugCab01', 'bugCargo01', 'bugWheel01')
