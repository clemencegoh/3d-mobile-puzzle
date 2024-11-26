extends Node3D

var swipe_start = null
var minimum_drag = 100
var ROTATION_SPEED = 5
var current_angle = 0

func _physics_process(delta: float) -> void:
	var next_angle = deg_to_rad(current_angle)
	self.rotation.y = lerp_angle(self.rotation.y, next_angle, delta * ROTATION_SPEED)

func _unhandled_input(event):
	if event.is_action_pressed("press"):
		#if event.pressed:
		swipe_start = event.get_position()
		#else:
	if event.is_action_released("press"):
		_calculate_swipe(event.get_position())

func _calculate_swipe(swipe_end):
	if swipe_start == null: 
		return
	var swipe = swipe_end - swipe_start
	if abs(swipe.x) > minimum_drag:
		if swipe.x > 0:
			_right()
		else:
			_left()

func _right():
	self.current_angle -= 90

func _left():
	self.current_angle += 90
	
