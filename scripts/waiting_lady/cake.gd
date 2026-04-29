# cake.gd
extends Area2D

signal hit_player

var speed: float = 180.0
var screen_height: float

func _ready() -> void:
	screen_height = get_viewport_rect().size.y
	
	body_entered.connect(func(body):
		#print("something entered cake: ", body.name)
		
		if body.is_in_group("player"):
			emit_signal("hit_player")
			queue_free()
	)

func _process(delta: float) -> void:
	position.y += speed * delta
	if position.y > screen_height + 50:
		queue_free()  # gone, no longer a threat
