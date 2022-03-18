extends Control


export var value := 0 setget _setValue
export var color := Color(255, 255, 255) setget _set_color

var _displayed_value := 0

func _ready():
	_set_color(color)
	_setValue(value)


func _setValue(number: int):
	value = number
	$change.start()


func _set_color(c: Color):
	color = c
	
	if $thousand != null:
		$thousand.color = color
		$hundred.color = color
		$decad.color = color
		$digits.color = color


func _on_change_timeout():
	var to_display = _divide_number(value)
	var displayed = _divide_number(_displayed_value)
	
	if to_display[0] > displayed[0]:
		_displayed_value += 1000
		
	if to_display[1] > displayed[1]:
		_displayed_value += 100
		
	if to_display[2] > displayed[2]:
		_displayed_value += 10
		
	if to_display[3] > displayed[3]:
		_displayed_value += 1
	
	if to_display[0] < displayed[0]:
		_displayed_value -= 1000
		
	if to_display[1] < displayed[1]:
		_displayed_value -= 100
		
	if to_display[2] < displayed[2]:
		_displayed_value -= 10
		
	if to_display[3] < displayed[3]:
		_displayed_value -= 1
	
	if _displayed_value != value:
		$change.start()
	_display()


func _divide_number(number: int):
	var thousand := floor(number / 1000)
	var hundreds := floor((number % 1000) / 100)
	var decads := floor((number % 100) / 10)
	var digits := floor(number % 10)
	
	return [ thousand, hundreds, decads, digits ]


func _display():
	var number = _divide_number(_displayed_value)
	
	$thousand.value = number[0]
	$hundred.value = number[1]
	$decad.value = number[2]
	$digits.value = number[3]
