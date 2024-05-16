extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var speed = 3
var input_vector: Vector2 = Vector2(0,0)
var is_running: bool = false
var is_attacking: bool = false
var was_running: bool = false
var attack_cooldown:float = 0.0

func _process(delta:float):
	read_input()
	# Temporizador do ataque
	update_attack_cooldown(delta)
	# Ataque
	if Input.is_action_just_pressed('Action_1'):
		attack()
	# Tocar animação
	play_run_idle_animation()
	# Girar Sprite
	rotate_sprite()
		
func _physics_process(delta: float):
	# Modificar a velocidade
	var target_velocity = input_vector * (speed * 100.0)
	
	if is_attacking:
		target_velocity *= 0.25
		
	velocity = lerp(velocity, target_velocity,0.05)
	move_and_slide()

func attack():
	if is_attacking:
		return
		
	# Tocar animação
	animation_player.play('attack_side_A')
	attack_cooldown = 0.6
	
	# Marcar ataque
	is_attacking = true

func read_input():
	# obter o input_vector
	input_vector = Input.get_vector("move_left","move_right","move_up","move_down")
	
	#Apagar deadzone do input vector
	var deadzone = 0.15
	if abs(input_vector.x) < 0.15:
		input_vector.x = 0.0
	if abs(input_vector.y) < 0.15:
		input_vector.y = 0.0
	
	# Atualizar o is_running
	was_running = is_running
	is_running = not input_vector.is_zero_approx()

func play_run_idle_animation():
	# Tocar animação
	if was_running != is_running:
		if is_running:
			animation_player.play("run")
		else:
			animation_player.play("idle")
		
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

func update_attack_cooldown(delta: float):
	# Temporizador do ataque
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")
