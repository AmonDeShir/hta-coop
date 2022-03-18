extends Node


class JSONObject:
	var json
	
	
	func _init(json):
		self.json = json
	
	
	func load_attribute(name: String):
		if name in json._attributes:
			return json._attributes[name]
		else:
			return null
	
	
	func load_string(name: String) -> String:
		var data = load_attribute(name)
		return str(data) if data != null else Nulls.NULL_STRING
	
	
	func load_int(name: String) -> int:
		var data = load_attribute(name)
		return int(data) if data != null else Nulls.NULL_INT
	
	
	func load_float(name: String) -> float:
		var data = load_attribute(name)
		return float(data) if data != null else Nulls.NULL_FLOAT
	
	
	func load_boolean(name: String, default: bool) -> bool:
		var data = load_string(name)
		
		if data == 'false':
			return false
		
		if data == 'true':
			return true
		
		return default
	
	
	func load_string_array(name: String):
		var data = load_string(name)
		
		if Nulls.is_null(data):
			return []
		
		return data.split(' ')
	
	
	func load_int_array(name: String):
		var data = load_string_array(name)
		var result = []
		
		if Nulls.is_null(data):
			return []
		
		for item in data:
			result.append(int(item))
		
		return result
	
	
	func load_float_array(name: String):
		var data = load_string_array(name)
		var result = []
		
		if Nulls.is_null(data):
			return []
		
		for item in data:
			result.append(float(item))
		
		return result




class VehiclePart extends JSONObject:
	var _class: String
	var name: String
	var resource_type: String
	var model_file: String
	var node_scale: Array
	
	func _init(json).(json):
		self._class = load_string('Class')
		self.name = load_string('Name')
		self.resource_type = load_string('ResourceType')
		self.model_file = load_string('ModelFile')
		self.node_scale = load_int_array('NodeScale')


class ChassisVehiclePart extends VehiclePart:
	var nullable: Nullable
	var mass: int
	var max_health: int
	var max_fuel: int
	var braking_sound: String
	var pneumo_sound: String
	var gear_shift_sound: String
	var load_points: Array
	
	class Nullable:
		var visible_in_encyclopedia: bool
		var blow_effect: String
		var price: int
		var repair_coef: float


	func _init(json).(json):
		self.nullable = Nullable.new()
		self.mass = load_int('Mass')
		self.max_health = load_int('MaxHealth')
		self.max_fuel = load_int('MaxFuel')
		self.braking_sound = load_string('BrakingSound')
		self.pneumo_sound = load_string('PneumoSound')
		self.gear_shift_sound = load_string('GearShiftSound')
		self.load_points = load_string_array('LoadPoints')
		self.nullable.visible_in_encyclopedia = load_boolean('VisibleInEncyclopedia', true)
		self.nullable.blow_effect = load_string('BlowEffect')
		self.nullable.price = load_int('Price')
		self.nullable.repair_coef = load_float('RepairCoef')




class CabinVehiclePart extends VehiclePart:
	var nullable: Nullable
	var durability: int
	var dur_coeffs_for_damage_types: Array
	var mass: int
	var max_power: int
	var max_torque: int
	var engine_high_sound: String
	var max_speed: int
	var blow_effect: String
	
	class Nullable:
		var visible_in_encyclopedia: bool
		var price: int
		var load_points: Array
		var fuel_consumption: float
		var repair_coef: float


	func _init(json).(json):
		self.nullable = Nullable.new()
		self.durability = load_int('Durability')
		self.dur_coeffs_for_damage_types = load_int_array('DurCoeffsForDamageTypes')
		self.mass = load_int('Mass')
		self.max_power = load_int('MaxPower')
		self.max_torque = load_int('MaxTorque')
		self.engine_high_sound = load_string('EngineHighSound')
		self.max_speed = load_int('MaxSpeed')
		self.blow_effect = load_string('BlowEffect')
		self.nullable.visible_in_encyclopedia = load_boolean('VisibleInEncyclopedia', true)
		self.nullable.price = load_int('Price')
		self.nullable.load_points = load_string_array('LoadPoints')
		self.nullable.fuel_consumption = load_float('FuelConsumption')
		self.nullable.repair_coef = load_float('RepairCoef')




class BasketVehiclePart extends VehiclePart:
	var nullable: Nullable
	var durability: int
	var dur_coeffs_for_damage_types: Array
	var price: int
	var repair_coef: float
	var mass: int
	
	class Nullable:
		var visible_in_encyclopedia: bool
		var blow_effect: String
		var load_points: Array


	func _init(json).(json):
		self.nullable = Nullable.new()
		self.durability = load_int('Durability')
		self.dur_coeffs_for_damage_types = load_int_array('DurCoeffsForDamageTypes')
		self.price = load_int('Price')
		self.repair_coef = load_float('RepairCoef')
		self.mass = load_int('Mass')
		self.nullable.visible_in_encyclopedia = load_boolean('VisibleInEncyclopedia', true)
		self.nullable.blow_effect = load_string('BlowEffect')
		self.nullable.load_points = load_string_array('LoadPoints')




class WheelVehiclePart extends VehiclePart:
	var mass: int
	var suspension_model_file: String
	var suspension_c_f_m: float
	var suspension_e_r_p: float
	var suspension_range: float
	var m_u: int
	var effect_type: String
	
	
	func _init(json).(json):
		self.mass = load_int('Mass')
		self.suspension_model_file = load_string('SuspensionModelFile')
		self.suspension_c_f_m = load_float('SuspensionCFM')
		self.suspension_e_r_p = load_float('SuspensionERP')
		self.suspension_range = load_float('SuspensionRange')
		self.m_u = load_int('mU')
		self.effect_type = load_string('EffectType')

