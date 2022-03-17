extends Spatial

export(NodePath) var path_to_target: NodePath
export var follow_acceleration := 0.15
export var vertical_min := -55.0
export var vertical_max := 75.0
export var horizontal_sensitivity := 0.1
export var vertical_sensitivity := 0.1
export var horizontal_acceleration := 0.25
export var vertical_acceleration := 0.25

var camera_rotation_h := 0.0
var camera_rotation_v := 0.0
var target: Spatial
var current_position := Vector3(0, 0, 0)
var ideal_offset := Vector3(0, 0, 0)


func _ready():
	set_physics_process(true);
	set_as_toplevel(true);
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	
	target = get_node(path_to_target)
	ideal_offset = (target.translation - translation).abs()
	$"h/v/camera".add_exception(target)


func _input(event):
	if event is InputEventMouseMotion:
		camera_rotation_h += -event.relative.x * horizontal_sensitivity
		camera_rotation_v -= event.relative.y * vertical_sensitivity


func _physics_process(delta):
	_follow_target(delta)
	_apply_mouse_rotation(delta)


func _follow_target(delta: float):
	var acceleration = _make_fps_independent(follow_acceleration, delta)
	var offset := ideal_offset + target.translation

	current_position = current_position.linear_interpolate(offset, acceleration)
	self.translation = 	current_position


func _make_fps_independent(variable: float, delta_time: float):
	return variable * pow(0.001, delta_time)


func _apply_mouse_rotation(delta: float):
	var time_h = _make_fps_independent(horizontal_acceleration, delta)
	var time_v = _make_fps_independent(vertical_acceleration, delta)
	
	camera_rotation_v = clamp(camera_rotation_v, vertical_min, vertical_max)
	
	$"h".rotation_degrees.y = lerp($"h".rotation_degrees.y, camera_rotation_h, time_h)
	$"h/v".rotation_degrees.x = lerp($"h/v".rotation_degrees.x, camera_rotation_v, time_v)
