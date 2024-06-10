class_name Player
extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sword_area: Area2D = $SwordArea
@onready var hitbox_area: Area2D = $HitboxArea
@onready var health_progress_bar:ProgressBar = $HealthProgressBar 

@export_category("Flags")
@export_enum("Neutral", "Passive", "Hostile") var behavior: int

@export_category("Movement")
@export var speed: float = 3

@export_category("Sword")
@export var sword_damage: float = 2
@export var critical_multiplier: float = 1

@export_category("Ritual")
@export var ritual_damage: float = 1
@export var ritual_interval: float = 30
@export var ritual_scene:PackedScene
@export_color_no_alpha var ritual_color: Color

@export_category("Life")
@export var health: float = 100
@export var max_health: float = 100
@export var death_prefab: PackedScene


var input_vector: Vector2 = Vector2(0,0)
var is_running: bool = false
var is_attacking: bool = false
var was_running: bool = false
var attack_cooldown: float = 0.0
var attack_combo: int = 0
var hitbox_cooldown: float = 0.0
var ritual_cooldown: float = 0

var gold_pouch: int = 0

signal meat_collected(value: int)
signal gold_collected(value: int)
signal health_state(actual: int, max:int)

func _ready():
	GameManager.player = self

func _process(delta:float):
	GameManager.player_position = position
	GameManager.ritual_color = ritual_color
	GameManager.player_critical_multiplier = critical_multiplier
	read_input()
	# Temporizador do ataque
	update_attack_cooldown(delta)
	# Ataque
	if Input.is_action_just_pressed('Action_1'):
		attack()
	# Tocar animação
	play_run_idle_animation()
	# Girar Sprite
	if not is_attacking:
		rotate_sprite()
		
	update_hitbox(delta)
	
	update_ritual(delta)
	
	# Atualizar Healt Bar
	health_progress_bar.max_value = max_health
	health_progress_bar.value = health
	
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
	if attack_combo > 1:
		attack_combo = 0
	if attack_combo == 0:
		animation_player.play('attack_side_A')
	elif attack_combo == 1:
		animation_player.play('attack_side_B')
	
	attack_combo += 1
	attack_cooldown = 0.6
	
	# Marcar ataque
	is_attacking = true
	
func read_input():
	# obter o input_vector
	input_vector = Input.get_vector("move_left","move_right","move_up","move_down")
	
	#Apagar deadzone do input vector
	var deadzone = 0.15
	if abs(input_vector.x) < deadzone:
		input_vector.x = 0.0
	if abs(input_vector.y) < deadzone:
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

func update_ritual(delta):
	ritual_cooldown-=delta
	if ritual_cooldown> 0: return
	ritual_cooldown = ritual_interval
	
	var ritual = ritual_scene.instantiate()
	ritual.damage_amount = ritual_damage
	add_child(ritual)
		
	pass
func deal_damage():
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var enemy_direction = (enemy.position - position).normalized()
			var attack_direction: Vector2
			if sprite.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			var dot_product = enemy_direction.dot(attack_direction)
			if dot_product >= 0.4:
				if randi_range(0,1) == 0:
					enemy.damage(sword_damage)
				else:
					enemy.critical_damage = true
					enemy.damage(sword_damage+(sword_damage * critical_multiplier))
			print(dot_product)
			
func update_hitbox(delta):
	hitbox_cooldown -= delta
	if hitbox_cooldown > 0: return
	
	hitbox_cooldown = 0.5
	
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var damage_amount = enemy.attack_damage
			damage(damage_amount)
			pass
	pass
func damage(amount: float):
	if health <= 0: return
	health -= amount
	print("Player recebeu dano de ", amount, ". A vida total é de ", health)
	
	# Piscar inimigo
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	health_state.emit(health,max_health)
	# Processar dano
	if health <= 0:
		die()

func die():
	GameManager.end_game()
	
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	queue_free()

func heal(amount:int):
	health += amount
	if health > max_health:
		health = max_health
	print("Player recebeu cura de ", amount," e está com ", health, " de vida.")
	return health
	
