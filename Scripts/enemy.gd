extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0
const LAUNCH_MULTIPLIER = .5
@export var ledge_ray_offset_x: float = 16


var dir: int = 1

@onready var ledge_raycast: RayCast2D = $LedgeRaycast



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		velocity.x = 0.0
	else:
		velocity.x = dir * SPEED
		if is_on_wall() or not ledge_raycast.is_colliding():
			dir *= -1
			_update_facing()
			
			
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is AnimatableBody2D:
			var platform_velocity: Vector2 = get_platform_velocity()
			
			if platform_velocity.length() > 10.0:
				velocity = platform_velocity * LAUNCH_MULTIPLIER
	
	move_and_slide()
	
func _update_facing():
	ledge_raycast.position.x = abs(ledge_ray_offset_x) * dir


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.Kill()
		
		
func Kill():
	queue_free()
