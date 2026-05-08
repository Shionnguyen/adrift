extends Node

# ---------------------------------------------------------------------------
# FishData — single source of truth for all fish in the game.
# Add new fish here. main.gd pulls from this pool randomly.
# ---------------------------------------------------------------------------

static func getFirstFish() -> Fish:
	return firstFish();

static func getGentlePool() -> Array:
	var pool = [];
	
	if not GameState.tutorial_complete:
		pool.append(grumpyOldMan())  # tutorial only
	else:
		if GameState.soul_tier == 2:
			pool.append(kidFish());
			pool.append(loverFish());
		elif GameState.soul_tier == 3:
			pass # add more gentle fish here
		
	return filterPool(pool);
	
static func getHeavyPool() -> Array:
	var pool = [];
	
	if not GameState.tutorial_complete:
		pool.append(waitingLady());
	else:
		if GameState.soul_tier == 2:
			pass; # add more heavy hearted fish here
		#else:
			#pass
		
	return filterPool(pool);

static func filterPool(pool: Array) -> Array:
	return pool.filter(func(f): return not GameState.freed_souls.has(f.fish_id))

# ---------------------------------------------------------------------------
# How the dialogue per fish works: 
# Fish -> Player (always next line or element)
# Player element includes a "label" key with text and a "next" key with jump to line
# 		-1 : fish resolved / good end
#		-2 : fish escapes  / bad end
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# COMMON SOUL  (gentle — linear, no choices)
# ---------------------------------------------------------------------------
static func firstFish() -> Fish:
	var f = Fish.new()
	f.fish_name = "???";
	f.fish_id = "first_fish";
	f.portraits = {
		"default": preload("res://assets/fish portrait/first/plain.PNG"),
	}
	f.dialogue = [
		{
			"speaker": "fish",
			"text": "...Oh. You can see me? That's new. It has been ages since I saw a person."
		},
		{
			"speaker": "player",
			"text": "",
			"choices": [
				{ "label": "...",        "next": 2 },
				{ "label": "Who are you?", "next": 2 }
			]
		},
		{
			"speaker": "fish",
			"text": "I was... No. That part isn't important. But I will give you advice, kiddo. You shouldn't hold on too tight. It hurts more when you do that.",
			"next": -1  # escape (good end)
		}
	]
	return f

# ---------------------------------------------------------------------------
# GRUMPY OLD MAN  (heavy — branches, one bad end)
# ---------------------------------------------------------------------------
static func grumpyOldMan() -> Fish:
	var f = Fish.new()
	f.fish_name = "Grumpy Man"
	f.fish_id = "grumpy_old_man";
	f.portraits = {
		"default": preload("res://assets/fish portrait/grumpy-man/man.PNG"),
		"angry": preload("res://assets/fish portrait/grumpy-man/man_angry.PNG"),
	}
	
	f.dialogue = [
		# 0
		{
			"speaker": "fish",
			"text": "Humph! Careful with that line! Kids these days have no respect at all. Where are your parents? I need to talk to them!",
		},
		# 1 — first choice
		{
			"speaker": "player",
			"text": "",
			"choices": [
				{ "label": "Sorry...",       "next": 2 },
				{ "label": "You seem upset.", "next": 6 }
			]
		},
		# --- BRANCH A: apologize ---
		# 2
		{
			"speaker": "fish",
			"text": "At least you know when to apologize. That's rare, these days.",
		},
		# 3
		{
			"speaker": "player",
			"text": "",
			"choices": [
				{ "label": "I didn't mean to hurt you.", "next": 4 },
				{ "label": "I'll be more careful.",      "next": 5 }
			]
		},
		# 4
		{
			"speaker": "fish",
			"text": "Hmph. Well. Intentions matter, I suppose.",
			"next": -1,
		},
		# 5
		{
			"speaker": "fish",
			"text": "Good. That's all I ever asked of anyone.",
			"next": -1
		},
		# --- BRANCH B: you seem upset ---
		# 6
		{
			"speaker": "fish",
			"text": "OF COURSE I AM UPSET! You yanked me out like I was nothing!",
			"emotion": "angry",
		},
		# 7
		{
			"speaker": "player",
			"text": "",
			"choices": [
				{ "label": "You're not nothing.",          "next": 8 },
				{ "label": "You talk a lot for a fish.", "next": 9 }
			]
		},
		# 8 — good end from branch B
		{
			"speaker": "fish",
			"text": "Hah. Well, that's better than most. Maybe you're not as careless as you look. Very well. Just this once. And your grip needs to be better.",
			"next": -1
		},
		# 9 — bad end
		{
			"speaker": "fish",
			"text": "THIS CHILD— no manners, no patience, no— ugh. I don't have time for this.",
			"emotion": "angry",
			"next": -2  # fish runs away
		}
	]
	return f

# ---------------------------------------------------------------------------
# THE WAITING LADY  (heavy — cake gag + flower minigame)
# Phase 1: conversation. Cake path = blackout. Flower path = minigame signal.
# ---------------------------------------------------------------------------
static func waitingLady() -> Fish:
	var f = Fish.new()
	f.fish_name = "A Lady"
	f.fish_id = "waiting_lady"
	f.portraits = {
			"default": preload("res://assets/waiting-lady-assets/lady.png"),
		}
	f.dialogue = [
		# 0
		{
			"speaker": "fish",
			"text": "...Ah. There you are. I was starting to think no one would come and the invitation had dissolved in the water."
		},
		# 1 — first choice
		{
			"speaker": "player",
			"text": "",
			"choices": [
				{ "label": "I hope you have some cake.",  "next": 2 },
				{ "label": "Who are you waiting for?",   "next": 4 }
			]
		},
		# --- CAKE PATH A (instant blackout) ---
		# 2
		{
			"speaker": "fish",
			"text": "Of course, silly. A tea party without cake is just a meeting, isn't it? I have a slice right here... saved just for the first person kind enough to sit with me."
		},
		# 3 — eating the cake triggers a blackout, signalled by "next": "blackout"
		{
			"speaker": "player",
			"text": "",
			"choices": [
				{ "label": "Eat the cake.", "next": "blackout"}
			],
			"next": -3 # TODO: blackout is saying the fish got freed ? or away. i think something is wrong with the emit signal when blackout
		},
		# --- PATH B: who are you waiting for ---
		# 4
		{
			"speaker": "fish",
			"text": "It was silly, really. I set the table too early. The tea went cold... I thought if I waited properly, they would arrive properly too. But anyway — you should have some cake."
		},
		# 5
		{
			"speaker": "player",
			"text": "",
			"choices": [
				{ "label": "Eat the cake.",          "next": "blackout" },
				{ "label": "No, thank you. I'm not hungry.", "next": 6 }
			]
		},
		# 6 — refusal leads to emotional reveal
		{
			"speaker": "fish",
			"text": "...Why not? You think I'm strange, don't you. Just like the others. You all leave eventually. You smile, you sit, you say nothing is wrong — and then you go. I made all of this for you. I am ALWAYS waiting for you."
		},
		# 7 — triggers flower minigame, signalled by "next": "minigame"
		{
			"speaker": "player",
			"text": "",
			"choices": [
				{ "label": "Back away slowly.", "next": "minigame" }
			]
		}
	]
	return f
	
static func kidFish():
	var f = Fish.new()
	f.fish_name = "Kid"
	f.fish_id = "kid_fish"
	f.potraits = {
			"default"
		}
	f.dialogue = [
		# 0
		{
			"speaker": "fish",
			"text": "...Oh. You're not carrying a folder.",
			"delay": 1.2
		},
		# 1
		{
			"speaker": "fish",
			"text": "You look tired though. Are you one of my tutors?",
			"delay": 0.8
		},
		# 2 - first choice
		{
			"speaker": "player",
			"text": "",
			"choices": [
				{"label": "No, I am not.", "next": 3},
				{"label": "Do I look like I would grade you?", "next": 4}
			]
		},
		# ---OP1---
		# 3
		{
			"speaker": "fish",
			"text": "You're NOT my tutor?",
			"delay": 0.5
		},
		{
			"speaker": "fish",
			"text": "Are you here to play with me instead???",
			"delay": 0.4
		},
		{
			"speaker": "fish",
			"text": "Because I can play. And I always win. Hehe.",
			"delay": 0.6,
			"next": 6
		},
		# ---OP2---
		# 4
		{
			"speaker": "fish",
			"text": "...Hahaha. probably not, honestly.",
			"delay": 0.8
		}, 
		# 5
		{
			"speaker": "fish",
			"text": "My papers are like... a hundred pages long. And they keep adding more. It's fine though - you don't have to. We should play instead. That sounds way more fyn than grading anyway.",
			"delay": 1.0,
			"next": 6
		},
		# ---BOTH PATHS MEET HERE---
		# 6
		{
			"speaker": "fish",
			"text": "Okay. But if we are playing - there are rules.",
			"delay": 1.0
		},
		# 7
		{
			"speaker": "fish",
			"text": "No stopping halfway. No giving up. And no pretending you undersyand when you dont.",
			"delay": 1.2
		},
		# 8
		{
			"speaker": "fish",
			"test": "I called it...the MEGA ULTRA SURPEME FUN AND FRIENDLY TRIVIA QUESTIONS TO REDEEM YOUR WORTHY OR NOT.",
			"delay": 0.6
		},
		# 9
		{
			"speaker": "fish",
			"text": "There 's a prize at then edn/ So you'd better stay. And tget them all right.",
			"delay": 0.6
		},
		# 10 - second choice
		{
			"speaker": "player",
			"test": "",
			"choices": [
				{ "label": "...the what. you take games really seriouasly, huh.", "next": 11 },
				{"label": "Okay. I'm in. Show me what you got.",                  "next": 11}
			]
		},
		# 11 - both lead to game start
		{
			"speaker": "fish",
			"text": "Good. Then let's begin.",
			"delay": 1.5,
			"next": "minigame_trivia"
		}
	]
	
	return f
	
	# for when the kid fish is freed:
	# GameState.collected_items["kid_soundtrack"] = true
	# GameState.freed_souls.append("kid_fish")
	pass

static func loverFish() -> Fish:
	var f = Fish.new()
	f.fish_name = "Lover Fish";
	f.fish_id = "lover_fish";
	
	# dialogue changes based on world state
	if GameState.collected_items.get("kid_soundtrack", false):
		#f.dialogue = loverDialogue_withSong()
		f.fish_id = "lover_fish_return";
		pass
	else:
		#f.dialogue = loverDialogue_default()
		pass
	
	return f
