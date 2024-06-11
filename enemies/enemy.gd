class_name Enemy
extends Node2D

@onready var damage_digit_marker = $DamageDigitsMarker

@export_category("Flags")
@export_enum("Neutral", "Passive", "Hostile") var behavior: int

@export_category("Life")
@export var health: float = 10
@export var death_prefab: PackedScene

@export_category("Damage")
@export var attack_damage: float = 2
var damage_digits_prefab: PackedScene
var critical_damage:bool = false

@export_category("Drops")
@export var drop_rate: float = 0.1
@export var drop_items: Array[PackedScene]
@export var drop_chances: Array[float]

func _ready():
	damage_digits_prefab = preload("res://misc/damage_digits.tscn")

func damage(amount: float):
	if behavior == 0: behavior = 2 
	health -= amount
	print("Inimigo recebeu dano de ", amount, ". A vida total é de ", health)
	
	# Piscar inimigo
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	
	var damage_digit = damage_digits_prefab.instantiate()
	damage_digit.value = amount
	if damage_digit_marker:
		damage_digit.global_position = damage_digit_marker.global_position
	else:
		damage_digit.global_position = global_position
	if critical_damage:
		damage_digit.critical = true
		critical_damage= false
	get_parent().add_child(damage_digit)
	
	# Processar dano
	if health <= 0:
		die()

func die():
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
		drop_item()
	GameManager.moster_defeated_counter += 1
	queue_free()

func drop_item():
	if drop_items:
		if randf() <= drop_rate:
			var drop = get_random_drop_item().instantiate()
			drop.position = position
			get_parent().add_child(drop)

func get_random_drop_item() -> PackedScene:	
	if drop_items.size() == 1:
		return drop_items[0]
	###
	var max_chance: float = 0.0
	for drop_chance in drop_chances:
		max_chance += drop_chance
	###
	var random_value = randf() * max_chance
	###
	var needle: float = 0.0
	for i in drop_items.size():
		var drop_item = drop_items[i]
		var drop_chance = drop_chances[i] if i < drop_chances.size() else 1
		if random_value <= drop_chance + needle:
			return drop_item
		needle += drop_chance
	return drop_items[0]
			
	
		
