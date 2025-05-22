class_name SprintSystem

# Sprint parameters
@export var sprint_speed_multiplier := 3.0
@export var sprint_acceleration_time := 0.5
@export var sprint_deceleration_time := 0.8

var base_max_speed: float
var current_max_speed: float
var target_max_speed: float
var acceleration_rate: float
var deceleration_rate: float

func _init(base_speed: float):
	initialize(base_speed)

func initialize(base_speed: float):
	base_max_speed = base_speed
	current_max_speed = base_max_speed
	target_max_speed = base_max_speed
	acceleration_rate = (base_max_speed * sprint_speed_multiplier - base_max_speed) / sprint_acceleration_time
	deceleration_rate = (base_max_speed * sprint_speed_multiplier - base_max_speed) / sprint_deceleration_time

func update(char: CharacterBody2D, is_sprinting: bool, delta: float):
	# Update target speed
	if is_sprinting:
		target_max_speed = base_max_speed * sprint_speed_multiplier
	else:
		target_max_speed = base_max_speed
	
	# Smoothly transition to target speed
	if current_max_speed < target_max_speed:
		# Accelerating to sprint speed
		current_max_speed = min(current_max_speed + acceleration_rate * delta, target_max_speed)
	elif current_max_speed > target_max_speed:
		# Decelerating from sprint speed
		current_max_speed = max(current_max_speed - deceleration_rate * delta, target_max_speed)

func reset():
	current_max_speed = base_max_speed
	target_max_speed = base_max_speed
	
func tilt(char, input_direction, is_sprinting):
	if is_sprinting:
		if input_direction > 0:
			char.get_node("WeepingAngelSmall").rotation = PI/6
		elif input_direction < 0:
			char.get_node("WeepingAngelSmall").rotation = -PI/6
	else:
		char.get_node("WeepingAngelSmall").rotation = 0
