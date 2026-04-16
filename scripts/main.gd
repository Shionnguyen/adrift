extends Node2D

@onready var fishingUI = $Game/FishingUI;
@onready var fishingStatus = $Game/FishStatus;

@onready var animations = $Game/CharacterBody2D;

# screens to display
@onready var skyScene = $Sky;
@onready var gameScene = $Game;

var onSkyScene;

# dialogue
var dialogue_scene = preload("res://scenes/fish_dialogue.tscn");

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameScene.visible = false;
	skyScene.visible = true;
	onSkyScene = true;
	playSkyScene();

func _input(event: InputEvent) -> void:
	if onSkyScene:
		if event.is_action_pressed("ui_accept"): # go to next dialogue
			onSkyScene = false;
			skyScene.visible = false
			gameStarts();
		return;
			
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

func gameStarts():
	gameScene.visible = true;
	fishingUI.visible = false;
	fishingStatus.visible = false;
	fishingUI.fishingResults.connect(onFishingEnd);
	animations.playerAnimate("idle", 0.3);
	animations.reactionAnimate("waiting", 0.2);

func playSkyScene():
	# player will wake up looking at the sky
	# dialogue appears  [ ... ]
	$Sky/Dialogue/Label.text = "..."
	$Sky/Dialogue.visible = true
