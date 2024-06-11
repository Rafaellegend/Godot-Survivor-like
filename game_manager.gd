extends Node

signal game_over

var player: Player
var player_position: Vector2
var ritual_color: Color
var player_critical_multiplier: float
var is_game_over: bool = false

var timelapsed: float = 0.0
var timelapsed_string: String 
var meat_counter: int = 0
var gold_counter: int = 0
var moster_defeated_counter: int = 0

func _process(delta):
	timelapsed += delta
	var timelapsed_in_seconds: int = floori(timelapsed)
	var seconds:int = timelapsed_in_seconds % 60
	var minutes:int = timelapsed_in_seconds / 60
	timelapsed_string = "%02d:%02d" %[minutes,seconds]	
	
func end_game():
	if is_game_over:return
	is_game_over = true
	game_over.emit()

func reset():
	player = null
	player_position = Vector2.ZERO
	ritual_color = Color.WHITE
	player_critical_multiplier = 0
	is_game_over = false
	
	timelapsed = 0.0
	meat_counter= 0
	gold_counter= 0
	moster_defeated_counter = 0
	
	for connection in game_over.get_connections():
		game_over.disconnect(connection.callable)
	
