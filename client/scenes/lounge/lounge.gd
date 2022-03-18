extends Spatial

onready var main_scene := preload("res://scenes/main-scene/main.tscn")

func _ready():
	pass # Replace with function body.


func load_main_scene():
	get_parent().add_child(main_scene.instance())

