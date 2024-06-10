extends Node2D

@export var damage_amount: int = 4
@onready var area2d:Area2D = $Area2D

func _ready():
	var ritual_color = GameManager.ritual_color
	modulate = ritual_color
func deal_damage():
	var damage_multiplier = GameManager.player_critical_multiplier
	var bodies = area2d.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			if randi_range(0,1) == 0:
				enemy.damage(damage_amount)
			else:
				enemy.damage(damage_amount+(damage_amount*damage_multiplier))
	pass
