class_name Fish
extends Resource

enum Type { GENTLE, HEAVY }

enum Outcome { ESCAPED, RAN_AWAY }

@export var fish_name: String = ""
@export var type: Type = Type.GENTLE
@export var portrait: Texture2D

# Each step is a Dictionary:
# {
#   "speaker": "fish" | "player" | "monologue",
#   "text": String,
#   "choices": [{ "label": String, "next": int }]  -- optional
# }
# If no choices, dialogue advances automatically on input.
# "next": -1 means the fish escapes (good end).
# "next": -2 means the fish runs away (bad end).
@export var dialogue: Array[Dictionary] = []
