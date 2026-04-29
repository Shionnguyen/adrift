# present.gd
extends Area2D

signal collected

var velocity: Vector2
var screen_size: Vector2
var speed: float = 280.0

func _ready() -> void:
	screen_size = get_viewport_rect().size
	
	# random initial direction
	var angle = randf_range(0, TAU)
	velocity = Vector2(cos(angle), sin(angle)) * speed
	
	body_entered.connect(func(body):
		if body.is_in_group("player"):
			emit_signal("collected")
			queue_free()
	)

func _process(delta: float) -> void:
	position += velocity * delta
	
	# bounce off left/right edges
	if position.x <= 30 or position.x >= screen_size.x - 30:
		velocity.x *= -1
	
	# bounce off top edge
	if position.y <= 30:
		velocity.y *= -1
	
	# bounce off bottom — keep presents in upper portion so player can reach
	if position.y >= screen_size.y * 0.75:
		velocity.y *= -1
