extends CharacterBody2D

@export var SPEED = 100

var dir: float
var spawnPos: Vector2
var spawnRot: float
var zdex: int

func _ready() -> void:
	global_position = spawnPos
	global_rotation = spawnRot
	z_index = zdex
	
func _physics_process(delta):
	velocity = Vector2(0, -SPEED).rotated(dir)
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	queue_free()
	if body.is_in_group("Player"):
		body.Kill()


func _on_life_timeout() -> void:
	queue_free()
