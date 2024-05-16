extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var speed = 3
var is_running: bool = false

func _physics_process(delta: float):
	# obter o input_vector
	var input_vector = Input.get_vector("move_left","move_right","move_up","move_down",0.15)
	
	# Modificar a velocidade
	var target_velocity = input_vector * (speed * 100.0)
	velocity = lerp(velocity, target_velocity,0.05)
	move_and_slide()
	
	# Atualizar o is_running
	var was_running = is_running
	is_running = not input_vector.is_zero_approx()
	
	# Tocar animação
	if was_running != is_running:
		if is_running:
			animation_player.play("Run")
		else:
			animation_player.play("Idle")
		
	# Girar Sprite
	if input_vector.x > 0:
		#desmarcar o flip H do sprite2D
		sprite.flip_h = false
		pass
	elif input_vector.x < 0:
		#marcar o flip H do sprite2D
		sprite.flip_h = true
		pass
	
