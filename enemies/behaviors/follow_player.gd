extends Node

@export var speed: float = 1

var enemy: Enemy
var sprite: AnimatedSprite2D

var input_vector: Vector2 = Vector2(0,0)



func _ready():
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")

func _physics_process(delta):
	if GameManager.is_game_over: return
	if enemy.behavior == 0 || enemy.behavior == 1: return
	# Calcular direção
	var player_position = GameManager.player_position
	var difference = player_position - enemy.position
	input_vector = difference.normalized()
	enemy.velocity = input_vector * (speed * 100.0)
	enemy.move_and_slide()
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
