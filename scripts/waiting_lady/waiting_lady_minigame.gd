extends Node2D

@onready var cake_spawner = $CakeSpawner;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cake_spawner.start(1);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
