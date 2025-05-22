extends CharacterBody2D

# Movement parameters
@export var max_speed := 300.0
@export var acceleration := 2000.0
@export var friction := 2000.0
@export var air_resistance := 500.0

# Jump parameters
@export var jump_force := 500.0
@export var gravity := 1000.0
@export var max_fall_speed := 800.0
@export var coyote_time := 0.1
@export var jump_buffer_time := 0.1

# State variables
var coyote_timer := 0.0
var jump_buffer_timer := 0.0
var is_jumping := false

# Sprint system
@onready var sprint_system := SprintSystem.new(max_speed)

func _ready():
	gravity = ProjectSettings.get_setting("physics/2d/default_gravity", gravity)
	sprint_system.initialize(max_speed)

func _physics_process(delta):
	var input_direction = Input.get_axis("move_left", "move_right")
	var is_sprinting = Input.is_action_pressed("sprint")
	# Update systems first
	sprint_system.update(self, is_sprinting, delta)
	sprint_system.tilt(self, input_direction, is_sprinting)
	# Handle physics in order
	apply_gravity(delta)
	handle_jump()  # Handle jump before movement
	handle_movement(input_direction, delta)

	self.move_and_slide()
	update_animations(input_direction, is_sprinting)

func apply_gravity(delta):
	if not self.is_on_floor():
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_fall_speed)
		
		# Coyote time only when moving downward
		if velocity.y >= 0 and coyote_timer > 0:
			coyote_timer -= delta
	else:
		is_jumping = false
		coyote_timer = coyote_time  # Reset coyote time when grounded

func handle_jump():
	# Update jump buffer timer
	if jump_buffer_timer > 0:
		jump_buffer_timer -= self.get_physics_process_delta_time()
	
	# Set jump buffer when jump is pressed
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	
	# Execute jump if conditions are met
	if can_jump():
		perform_jump()

func can_jump():
	# Can jump if either:
	# 1. On ground with jump buffer, or
	# 2. In coyote time with jump buffer
	return (self.is_on_floor() or coyote_timer > 0) and jump_buffer_timer > 0

func perform_jump():
	velocity.y = -jump_force
	is_jumping = true
	coyote_timer = 0.0  # Consume coyote time
	jump_buffer_timer = 0.0  # Consume jump buffer

func handle_movement(input_direction, delta):
	var current_max_speed = sprint_system.current_max_speed
	
	if input_direction != 0:
		# Apply movement - different acceleration in air vs ground
		var current_acceleration = acceleration if is_on_floor() else acceleration * 0.6
		velocity.x = move_toward(velocity.x, input_direction * current_max_speed, current_acceleration * delta)
	else:
		# Apply friction - different in air vs ground
		var current_friction = friction if is_on_floor() else air_resistance
		velocity.x = move_toward(velocity.x, 0, current_friction * delta)

func update_animations(input_direction, is_sprinting):
	if input_direction != 0:
		$WeepingAngelSmall.flip_h = input_direction > 0
