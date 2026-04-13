extends Node2D

@onready var fishingUI = $FishingUI;
@onready var fishingStatus = $FishStatus;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fishingUI.visible = false;
	fishingStatus.visible = false;
	fishingUI.fishingResults.connect(onFishingEnd);

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start fishing"):
		fishingUI.visible = true;
		#get_tree().paused = true; # pause the main when fishing is running

func onFishingEnd(results):
	fishingStatus.visible = true;
	if results == 1:
		fishingStatus.text = "You caught a fish!";
	else:
		fishingStatus.text = "The fish got away...";
	
