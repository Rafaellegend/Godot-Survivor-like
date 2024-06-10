extends Node2D

@export var max_gold_amount: int = 5
@export var min_gold_amount: int = 10
var gold_amount: int = 0

func _ready():
	$PickupArea.body_entered.connect(on_body_enter)
	if max_gold_amount >= min_gold_amount:
		gold_amount = randi_range(min_gold_amount,max_gold_amount)
	else:
		gold_amount = max_gold_amount

func on_body_enter(body: Node2D):
	print(body)
	if body.is_in_group("player"):
		var player:Player = body
		player.gold_pouch += gold_amount
		player.gold_collected.emit(gold_amount)
		queue_free()
