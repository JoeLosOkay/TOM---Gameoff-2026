#extends CharacterBody2D
#
#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
#var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")
#
#@export var character_weight: float = 100.0 # Force applied downward
#
#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
		#
	## Check everything the character is currently colliding with
	#for i in get_slide_collision_count():
		#var collision = get_slide_collision(i)
		#var collider = collision.get_collider()
		#
		## If we are standing on a RigidBody2D, push it down
		#if collider is RigidBody2D:
			## Apply a downward force proportional to where we are standing
			#collider.apply_force(Vector2.DOWN * character_weight, collision.get_position() - collider.global_position)
#
	## Handle left/right movement
	## TODO replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()

extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var character_weight: float = 200.0 # Force applied downward
@export var slide_friction: float = 0.3      # Lower = slicker slope, Higher = more grip

func _physics_process(delta: float) -> void:
	# 1. Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# 3. Handle left/right movement AND natural slope sliding
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		if is_on_floor():
			var floor_normal = get_floor_normal()
			
			# SL_THRESHOLD: The character won't slide unless the angle is steeper than this.
			# 0.1 means roughly a 5-6 degree tilt. Increase this if you want them more stable!
			var slope_threshold : float = 0.15 
			
			if abs(floor_normal.x) > slope_threshold:
				# Calculate slide force, subtracting friction so it's not a sudden drop
				var slide_force = floor_normal.x * GRAVITY * (1.0 - slide_friction)
				
				# Accelerate down the hill smoothly
				velocity.x = move_toward(velocity.x, slide_force, SPEED * delta)
			else:
				# If the tilt is flat or very mild, bring the player to an absolute stop!
				velocity.x = move_toward(velocity.x, 0, SPEED * 2.0 * delta)
		else:
			# Decelerate normally if we are in the air
			velocity.x = move_toward(velocity.x, 0, SPEED)

	# 4. Move the character (This must happen AFTER setting velocity.x)
	move_and_slide()

	# 5. Push the rigid body beam down (This runs safely AFTER move_and_slide collects collisions)
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is RigidBody2D:
			collider.apply_force(Vector2.DOWN * character_weight, collision.get_position() - collider.global_position)
