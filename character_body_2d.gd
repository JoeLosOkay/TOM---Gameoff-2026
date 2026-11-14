extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0
const LAUNCH_MULTIPLIER = .5

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is AnimatableBody2D:
			var platform_velocity: Vector2 = get_platform_velocity()
			
			if platform_velocity.length() > 10.0:
				velocity = platform_velocity * LAUNCH_MULTIPLIER
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		var platform_vel = get_platform_velocity()
		velocity.y = JUMP_VELOCITY
		velocity.x += platform_vel.x
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
