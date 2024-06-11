extends Node

@export var game_ui: CanvasLayer
@export var game_over_ui_template: PackedScene


func _ready():
	GameManager.game_over.connect(trigger_game_over)

func trigger_game_over():
	if game_ui:
		game_ui.queue_free()
		game_ui = null
	
	var game_over_ui = game_over_ui_template.instantiate()
	game_over_ui.time_survived = GameManager.timelapsed_string
	game_over_ui.money_collected = GameManager.gold_counter
	game_over_ui.monsters_defeated = GameManager.moster_defeated_counter
	add_child(game_over_ui)
	
