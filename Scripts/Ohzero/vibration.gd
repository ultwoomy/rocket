extends AnimatedSprite2D
var rand : RandomNumberGenerator
var rang : Vector2
var current_pos
var speed : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rand = RandomNumberGenerator.new()
	current_pos = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rang = Vector2(rand.randf_range(-5,5) * speed,rand.randf_range(-5,5) * speed)
	position = current_pos + rang

func _set_speed(x):
	speed = x
