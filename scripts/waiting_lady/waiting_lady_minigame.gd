# waiting_lady_minigame.gd
extends Node2D

signal minigame_finished(outcome: String);

# sprite spawner
@onready var cake_spawner = $CakeSpawner;
@onready var present_spawner = $PresentSpawner;

# hp
@onready var heart1 = $HBoxContainer/Hearts
@onready var heart2 = $HBoxContainer/Hearts2
var lives: int = 2;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cake_spawner.cake_hit_player.connect(_on_cake_hit)
	present_spawner.all_collected.connect(_on_stage_cleared)
	start_stage(1)
	
func start_stage(s: int) -> void:
	$CakeSpawner.start(s)
	$PresentSpawner.spawn(s)
	
func _on_cake_hit() -> void:
	lives -= 1
	_update_hearts()
	if lives <= 0:
		_lose()

func _update_hearts() -> void:
	heart2.visible = lives >= 2
	heart1.visible = lives >= 1

func _on_stage_cleared() -> void:
	print("stage cleared!")  # hook up stage progression here next

func _lose() -> void:
	cake_spawner.stop()
	print("you died")
	emit_signal("minigame_finished", "dead")
