extends Control
class_name HpAndFuel

func _ready():
	Server.fetch_hp_and_fuel_level()

func load_fuel_level(fuel: int):
	$"fuel/counter".value = fuel


func load_hp(hp: int):
	$"hp/counter".value = hp
