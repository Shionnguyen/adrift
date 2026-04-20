extends Node2D

# fishing assets
@onready var fishingUI = $Game/FishingUI;
@onready var fishingStatus = $Game/FishStatus;

# visual effects / assets (?)
@onready var animations = $Game/CharacterBody2D;

# scenes
@onready var skyScene = $Sky;
@onready var gameScene = $Game;

# dialogue
var dialogue_scene = preload("res://scenes/fish_dialogue.tscn");

# states
var onSkyScene: bool = true;
var currentFish: Fish = null;


# ---------------------------------------------------------------------------
# Startup
# ---------------------------------------------------------------------------
func _ready() -> void:
	gameScene.visible = false;
	skyScene.visible = true;
	onSkyScene = true;
	playSkyScene();

# ---------------------------------------------------------------------------
# Input
# ---------------------------------------------------------------------------
func _input(event: InputEvent) -> void:
	if onSkyScene: # beginning
		if event.is_action_pressed("ui_accept"):
			onSkyScene = false;
			skyScene.visible = false
			gameStarts();
		return;
	
	if event.is_action_pressed("start fishing"):
		startFishing();

# ---------------------------------------------------------------------------
# Scene flow
# ---------------------------------------------------------------------------
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
	$Sky/Dialogue.visible = true;

func startFishing():
	fishingUI.resetState();
	fishingUI.visible = true;
	
	# change fishing hut to be more in the background
	$Game/FishingHut.modulate = Color(0.5, 0.5, 0.5, 1.0);
	animations.playerAnimate("fishing", 0.8);
	animations.reactionSprite.stop();
	animations.reactionSprite.visible = false;


# ---------------------------------------------------------------------------
# Fishing result → pick a fish → show dialogue
# ---------------------------------------------------------------------------
func onFishingEnd(results):
	fishingStatus.visible = true;
	$Game/FishingHut.modulate = Color(1.0, 1.0, 1.0, 1.0);
	animations.playerAnimate("hooked", 1)
	animations.playerAnimate("idle", 0.5)
	
	if results == 1:
		fishingStatus.text = "You caught a fish!";
		currentFish = pickRandomFish();
		
		showDialogue();
	else:
		fishingStatus.text = "The fish got away...";
		
func pickRandomFish():
	var pool = FishData.getPool();
	return pool[randi() % pool.size()];
	
func showDialogue():
	var dialogue_instance = dialogue_scene.instantiate();
	add_child(dialogue_instance);
