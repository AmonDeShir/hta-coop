extends Node

var NULL_STRING := '__NULL__STRING__'
var NULL_FLOAT := NAN
var NULL_INT := NAN

func is_null(value) -> bool:
	if typeof(value) == TYPE_NIL:
		return true
	
	if typeof(value) == TYPE_STRING:
		return value == Nulls.NULL_STRING
		
	if typeof(value) == TYPE_REAL:
		return value == Nulls.NULL_FLOAT
		
	if typeof(value) == TYPE_INT:
		return value == Nulls.NULL_INT
	
	return false
