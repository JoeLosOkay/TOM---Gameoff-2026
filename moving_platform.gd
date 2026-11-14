extends AnimatableBody2D

@onready var MovePointA:Vector2 = Vector2($"../PlatformPointA".position)
@onready var MovePointB:Vector2 = Vector2($"../PlatformPointB".position)
@export var MoveTime:float = 0.1

var is_at_point_b:bool = false
var active_tween: Tween
var is_moving:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Calls for the function to move platforms
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Move Platforms"):
		move_position()


func move_position():
	# Changes platforms move target and prevents movement
	if is_moving == false:
		is_moving = true
		is_at_point_b = !is_at_point_b
	
		var target = MovePointB if not is_at_point_b else MovePointA
		
		
		# Tween to move the platform and allows movement again when finished
		active_tween = create_tween()
		#active_tween.set_trans(Tween.TRANS_SINE)
		#active_tween.set_ease(Tween.EASE_IN_OUT)
		active_tween.tween_property(self, "position", target, MoveTime)
		await active_tween.finished
		is_moving = false
	
	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if Input.is_key_pressed(KEY_SHIFT):
		#var target = MovePointB if not is_at_point_b else MovePointA
		#position = position.move_toward(target, MoveSpeed * delta)
		#if position.distance_to(target) <= 0:
			#is_at_point_b = not is_at_point_b
