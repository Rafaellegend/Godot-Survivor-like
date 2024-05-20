extends CharacterBody2D

@export var speed: float = 1

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var input_vector: Vector2 = Vector2(0,0)

func _physics_process(delta):
	# Calcular direção
	var player_position = GameManager.player_position
	var difference = player_position - position
	input_vector = difference.normalized()
	velocity = input_vector * (speed * 100.0)
	move_and_slide()
	rotate_sprite()
	
func rotate_sprite():
	# Girar Sprite
	if input_vector.x > 0:
		#desmarcar o flip H do sprite2D
		sprite.flip_h = false
		pass
	elif input_vector.x < 0:
		#marcar o flip H do sprite2D
		sprite.flip_h = true
		pass
