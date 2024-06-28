extends Control

class_name GameManager

signal begin_extraction
signal pause_resume_extraction
signal reset_game

@onready var playButton = $Button

# General Variables
@export var min_number = 1
@export var max_number = 60
var numbers : Array
var color_array: Array[Color]

# Ball Variables
@export var ball_pool: BallPool
@export var number_of_balls = 30
@export var balls_per_color = 10
@export var extraction_time = 3.0
@export var time_between_balls = 0.25
@export var ball_offset = 100

# Card Variables
@export var cards: Array[Card]
@export var number_of_rows = 3
@export var number_of_cols = 5


# Makeshift State Machine stuff
const Stopped = "Stopped"
const Extracting = "Extracting"
const Paused = "Paused"
const Finished = "Finished"
var game_state = Stopped


func _ready():
	numbers = range(min_number,max_number+1)
	generate_color_array()
	ball_pool.create_ball_pool(generate_numbers(number_of_balls), extraction_time, time_between_balls, ball_offset)
	for card in cards:
		card.generate_card(generate_numbers(number_of_cols*number_of_rows),number_of_cols,number_of_rows)
		connect_ball_signals(card)


func generate_numbers(number_count):
	numbers.shuffle()
	return numbers.slice(0,number_count)


func generate_color_array():
	var color_array_size = max_number/balls_per_color
	for i in color_array_size:
		var new_color = Color.from_hsv(float(i)/color_array_size,0.8,0.75)
		color_array.append(new_color)


func connect_ball_signals(card:Card):
	for ball in ball_pool.ball_array:
		ball.finished_extracting.connect(card.check_hit)


func _on_play_button_pressed():
	match game_state:
		Stopped:
			emit_signal("begin_extraction")
			game_state = Extracting
		Extracting:
			emit_signal("pause_resume_extraction")
			game_state = Paused
		Paused:
			emit_signal("pause_resume_extraction")
			game_state = Extracting 
		Finished:
			emit_signal("reset_game")
			game_state = Stopped
	
	print(str(game_state))


func _on_card_last_ball_extracted():
	game_state = Finished
