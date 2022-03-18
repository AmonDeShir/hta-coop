extends Control


export var value := 0 setget _setValue
export var color := Color(255, 255, 255) setget _set_color
export var unit := 10 setget _set_unit
export var display_unit := true setget _show_hide_unit

var _displayed_value := 0

func _ready():
	_set_unit(unit)
	_show_hide_unit(display_unit)
	_set_color(color)
	_setValue(value)


func _setValue(number: int):
	value = number
	$change.start()


func _set_color(c: Color):
	color = c
	
	if $hundred != null:
		$hundred.color = color
		$decad.color = color
		$digits.color = color
		$unit.color = color

func _on_change_timeout():
	var to_display = _divide_number(value)
	var displayed = _divide_number(_displayed_value)
	
	if to_display[0] > displayed[0]:
		_displayed_value += 100
		
	if to_display[1] > displayed[1]:
		_displayed_value += 10
		
	if to_display[2] > displayed[2]:
		_displayed_value += 1
	
	if to_display[0] < displayed[0]:
		_displayed_value -= 100
		
	if to_display[1] < displayed[1]:
		_displayed_value -= 10
		
	if to_display[2] < displayed[2]:
		_displayed_value -= 1
	
	if _displayed_value != value:
		$change.start()
	_display()


func _divide_number(number: int):
	var hundreds := floor(number / 100)
	var decads := floor((number % 100) / 10)
	var digits := floor(number % 10)
	
	return [ hundreds, decads, digits ]


func _display():
	var number = _divide_number(_displayed_value)
	
	$hundred.value = number[0]
	$decad.value = number[1]
	$digits.value = number[2]


func _show_hide_unit(value: bool):
	display_unit = value
	
	if display_unit == true:
		$unit.show()
	else:
		$unit.hide()


func _set_unit(value: int):
	unit = value
	$unit.value = value

