extends Node2D

@onready var projectile = load("res://Scenes/projectile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func shoot():
	var instance = projectile.instantiate()
	instance.dir = rotation
	instance.spawnPos = global_position
	instance.spawnRot = rotation
	instance.zdex = z_index -1
	add_child.call_deferred(instance)


func _on_cooldown_timeout() -> void:
	shoot()
