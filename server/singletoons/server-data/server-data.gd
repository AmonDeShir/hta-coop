extends Node

var vehicle_parts: Array
var cabins: Array
var chassis: Array
var baskets: Array
var wheels: Array

func _ready():
	var json = _load_json_file('res://hta-data/gamedata/gameobjects/vehicleparts.json')
	
	print_debug('loading vehicle data...')
	for types in json.Prototypes.Folder:
		print_debug('loading type: ', types._attributes.Name)
		
		for part in types.Prototype:
			vehicle_parts.append(DataTypes.VehiclePart.new(part))
			
			if part._attributes.Class == "Chassis":
				chassis.append(DataTypes.ChassisVehiclePart.new(part))
			
			if part._attributes.Class == "Cabin":
				cabins.append(DataTypes.CabinVehiclePart.new(part))
				
			if part._attributes.Class == "Basket":
				baskets.append(DataTypes.BasketVehiclePart.new(part))
				
			if part._attributes.Class == "Wheel":
				wheels.append(DataTypes.WheelVehiclePart.new(part))
				
	print_debug('Vehicle data loaded')


func _load_json_file(path: String):
	var file := File.new()
	file.open(path, File.READ)
	var json := JSON.parse(file.get_as_text())
	file.close()
	
	return json.result


func get_part(name: String) -> DataTypes.VehiclePart:
	for part in vehicle_parts:
		if part.name == name:
			return part
	return null


func get_cabin(name: String) -> DataTypes.CabinVehiclePart:
	for part in cabins:
		if part.name == name:
			return part
	return null


func get_chassis(name: String) -> DataTypes.ChassisVehiclePart:
	for part in chassis:
		if part.name == name:
			return part
	return null


func get_basket(name: String) -> DataTypes.BasketVehiclePart:
	for part in baskets:
		if part.name == name:
			return part
	return null


func get_wheel(name: String) -> DataTypes.WheelVehiclePart:
	for part in wheels:
		if part.name == name:
			return part
	return null
