extends Node

class Cabin:
	var attributes: DataTypes.CabinVehiclePart
	var name: String
	
	func _init(name: String):
		self.name = name
		self.attributes = ServerData.get_cabin(name)




class Chassis:
	var attributes: DataTypes.ChassisVehiclePart
	var name: String
	
	func _init(name: String):
		self.name = name
		self.attributes = ServerData.get_chassis(name)




class Basket:
	var attributes: DataTypes.BasketVehiclePart
	var name: String
	
	func _init(name: String):
		self.name = name
		self.attributes = ServerData.get_basket(name)



class Wheel:
	var attributes: DataTypes.WheelVehiclePart
	var name: String
	
	func _init(name: String):
		self.name = name
		self.attributes = ServerData.get_wheel(name)




class Car:
	var cabin: Cabin
	var chassis: Chassis
	var basket: Basket
	var wheel: Wheel

	var fuel: int
	var helth: int


	func _init(chassis: String, cabin: String, basket: String, wheel: String):
		self.cabin = Cabin.new(cabin)
		self.chassis = Chassis.new(chassis)
		self.basket = Basket.new(basket)
		self.wheel = Wheel.new(wheel)
		
		self.fuel = self.chassis.attributes.max_fuel
		self.helth = self.chassis.attributes.max_health
