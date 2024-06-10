class_name GameOverUI
extends CanvasLayer

@onready var time_count: Label = %TimeCount
@onready var monster_count: Label = %MonsterCount
@onready var money_count: Label = %MoneyCount

@export var restart_delay: float = 5.0
var restart_colldown:float
var time_survived: String
var monsters_defeated: int 
var money_collected: int 

func _ready():
	time_count.text = time_survived
	monster_count.text = str(monsters_defeated)
	money_count.text = str(money_collected)
	restart_colldown = restart_delay

func _process(delta):
	restart_colldown -= delta
	if restart_colldown <= 0.0:
		restart_game()
		
func restart_game():
	GameManager.reset()
	get_tree().reload_current_scene()
	print("Restart game")
