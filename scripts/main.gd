extends Node2D

@onready var fishingUI = $FishingUI;
@onready var fishingStatus = $FishStatus;

@onready var animations = $CharacterBody2D;

# dialogue
var dialogue_scene = preload("res://scenes/fish_dialogue.tscn");

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fishingUI.visible = false;
	fishingStatus.visible = false;
	fishingUI.fishingResults.connect(onFishingEnd);
	animations.playerAnimate("idle", 0.3);
	animations.reactionAnimate("waiting", 0.2)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("start fishing"):
		fishingUI.resetState();
		fishingUI.visible = true;
		
		# change fishing hut to be more in the background
		$FishingHut.modulate = Color(0.5, 0.5, 0.5, 1.0);
		animations.playerAnimate("fishing", 0.8);
		animations.reactionSprite.stop();
		animations.reactionSprite.visible = false;
		
func onFishingEnd(results):
	fishingStatus.visible = true;
	$FishingHut.modulate = Color(1.0, 1.0, 1.0, 1.0);
	
	if results == 1:
		fishingStatus.text = "You caught a fish!";
		showDialogue();
	else:
		fishingStatus.text = "The fish got away...";
	
	animations.playerAnimate("hooked", 1);
	animations.playerAnimate("idle", 0.5);
	
func showDialogue():
	var dialogue_instance = dialogue_scene.instantiate();
	add_child(dialogue_instance);
