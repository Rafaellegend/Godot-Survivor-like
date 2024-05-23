extends Node2D

@export var regen_amount: int = 10


func _ready():
	$PickupArea.body_entered.connect(on_body_enter)

func on_body_enter(body: Node2D):
	print(body)
	if body.is_in_group("player"):
		var player:Player = body
		player.heal(regen_amount)
		queue_free()
