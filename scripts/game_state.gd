# game_state.gd  (add as Autoload in Project Settings → "GameState")

extends Node

var soul_fragments: int = 0
var seen_fish: Array[String] = []      # fishes you've talked to (can't see again)
var escaped_fish: Array[String] = []   # fishes that escaped (second chance pool)
