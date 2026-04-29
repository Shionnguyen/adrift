extends CharacterBody2D

const SPEED = 280.0

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED
	velocity.y = 0  # no gravity, boat stays on water
	
	# clamp to screen edges
	var screen_width = get_viewport_rect().size.x
	position.x = clamp(position.x, -120, screen_width - 200)
	
	move_and_slide()
