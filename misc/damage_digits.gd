extends Node2D

var value: int = 0
var critical: bool = false

func _ready():
	%Label.text = str(value)
	if critical:
		$AnimationPlayer.play("critical")
	else:
		$AnimationPlayer.play("default")
	
