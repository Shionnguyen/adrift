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
var firstFishSeen: bool = false; # so that the first fish displays once
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
	
	if event.is_action_pressed("start fishing"): # f is pressed
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
		#fishingStatus.text = "You caught a fish!";
		currentFish = pickRandomFish();
		
		showDialogue();
	else:
		fishingStatus.text = "The fish got away...";
		
func pickRandomFish():
	if not firstFishSeen:
		firstFishSeen = true;
		return FishData.getFirstFish();
	
	# weighted roll: 70% common, 30% heavy, or whatever feels right
	if randf() < 0.7:
		var pool = FishData.getGentlePool();
		return pool[randi() % pool.size()];
	else:
		var pool = FishData.getHeavyPool();
		return pool[randi() % pool.size()];
	
func showDialogue():
	var dialogue_instance = dialogue_scene.instantiate(); # create the dialogue ; create an address
	add_child(dialogue_instance); # add to tree ; placing address to visible land
	
	dialogue_instance.dialogue_finished.connect(onDialogueFinished);
	dialogue_instance.setup(currentFish); # puts Fish into instance ; putting furniture into house
	
func onDialogueFinished(outcome: String) -> void:
	match outcome:
		"escaped":
			fishingStatus.text = "The soul dissolves into light..."
			# TODO: play dissolve VFX, award soul fragment
			print("SOUL FREED — good end")

		"ran_away":
			fishingStatus.text = "The fish got away."
			# No reward
			print("FISH got AWAY — bad end")

		"blackout":
			# Waiting Lady — player ate the cake
			doBlackout("YOU PASSED OUT.\nWhy would you eat something offered by a stranger :/")

		"minigame":
			# Waiting Lady — flower collect minigame
			# TODO: load flower minigame scene, pass _current_fish back in
			fishingStatus.text = "Something is happening..."
			print("MINIGAME TRIGGERED")

# ---------------------------------------------------------------------------
# Blackout -> fade into minigame
# ---------------------------------------------------------------------------
func doBlackout(message: String) -> void:
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var label = Label.new()
	label.text = message
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment   = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	label.add_theme_font_size_override("font_size", 18)
	label.modulate.a = 0.0

	overlay.add_child(label)

	var canvas = CanvasLayer.new()
	canvas.layer = 10
	canvas.add_child(overlay)
	add_child(canvas)

	var t = create_tween()
	t.tween_property(overlay, "color:a", 1.0, 1.2)
	t.tween_property(label,   "modulate:a", 1.0, 0.5)
	t.tween_interval(3.0)
	t.tween_property(overlay, "color:a", 0.0, 1.0)
	t.tween_callback(canvas.queue_free)
