extends Control

export(Color) var color := Color(255, 255, 255) setget _set_color
export(Array, Texture) var numbers: Array
export var value := 0 setget _set_value

func _ready():
	value = 0


func _set_value(number: int):
	value = clamp(number, 0, len(numbers))
	$'pivot/NumLarge0'.texture = numbers[value]
	

func _set_color(value: Color):
	color = value
	$'pivot/NumLarge0'.modulate = color
