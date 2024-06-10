extends CanvasLayer

@onready var timer_label: Label = %TimerLabel
@onready var meat_label: Label = %MeatLabel
@onready var gold_label: Label = %GoldLabel
@onready var life_label: Label = %LifeLabel



func _ready():
	GameManager.player.meat_collected.connect(on_meat_collected)
	GameManager.player.gold_collected.connect(on_gold_collected)
	meat_label.text = str(GameManager.meat_counter)
	gold_label.text = str(GameManager.gold_counter)

func _process(delta):
	
	timer_label.text = GameManager.timelapsed_string
	
func on_meat_collected(regeneration_value:int):
	GameManager.meat_counter += 1
	if GameManager.meat_counter > 9999: GameManager.meat_counter = 9999
	meat_label.text = str(GameManager.meat_counter)
	
func on_gold_collected(gold_amount:int):
	GameManager.gold_counter += gold_amount
	if GameManager.gold_counter > 9999: GameManager.gold_counter = 9999
	gold_label.text = str(GameManager.gold_counter)

