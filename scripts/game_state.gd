# game_state.gd  (add as Autoload in Project Settings → "GameState")

extends Node

var soul_fragments: int = 0
var freed_souls: Array[String] = []      # fish_ids of freed souls
var collected_items: Dictionary = {}     # "kid_soundtrack" : true
var player_flags: Dictionary = {}        # freeform story flags
