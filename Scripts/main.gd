extends Node2D

var level: int = 1
var current_level_root: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_level_root = get_node("LevelRoot")
	_load_level(level)
	
#
# Level Management
#
func _load_level(level_number: int):
	if current_level_root:
		current_level_root.queue_free()
	
	# Change Level
	var level_path =  "res://Scenes/Levels/Level%s.tscn" %level_number
	current_level_root = load(level_path).instantiate()
	add_child(current_level_root)
	current_level_root.name = "LevelRoot"
	_setup_level(current_level_root)

func _setup_level(level_root: Node):
	# Connect Endpoint
	var Endpoint = level_root.get_node_or_null("EndPoint")
	if Endpoint:
		Endpoint.body_entered.connect(_on_exit_body_entered)
	
	var collectables = level_root.get_node_or_null("Collectables")
	if collectables:
		for collectable in collectables.get_children():
			collectable.collected.connect(_on_player_collect)





# 
# Signal Handlers
# 
func _on_exit_body_entered(body: Node2D):
	if body.name == "Player":
		level += 1
		call_deferred("_load_level" ,level)
	
func _on_player_collect():
	pass
