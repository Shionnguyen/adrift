extends Node2D

@onready var fishingUI = $FishingUI;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fishingUI.visible = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start fishing"):
		fishingUI.visible = true;
		#get_tree().paused = true; # pause the main when fishing is running
