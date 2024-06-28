extends Node2D

class_name BallPool

var ball = preload("res://Scenes/ball.tscn")

@onready var gameManager = $".." as GameManager
@onready var extraction_path = $ExtractionPath
@onready var extraction_timer = $ExtractionTimer

var ball_values_array: Array
var ball_array: Array[Ball]
var current_ball = 0
var extracting = false
var waiting = false
var pause = false


func _process(delta):
	if extracting and !waiting and !pause:
		if current_ball < ball_array.size():
			extraction_path.get_child(current_ball).move = true
			waiting = true
			extraction_timer.start()
			current_ball+=1
		else:
			extracting = false


func create_ball_pool(numbers, et, tbb, bo):
	ball_values_array = numbers
	extraction_timer.wait_time = tbb
	for index in ball_values_array.size():
		ball_array.append(ball.instantiate() as Ball)
		extraction_path.add_child(ball_array[index])
		var number = ball_values_array[index]
		ball_array[index].get_child(0).get_child(0).text = str(ball_values_array[index])
		ball_array[index].set_attributes(number, index, et, bo)
		ball_array[index].modulate = gameManager.color_array[int(number/10) - 1]


# Refreshes the values, labels and colors for the balls
func refresh_balls():
	ball_values_array = gameManager.generate_numbers(ball_values_array.size())
	var count = 0
	for ball in ball_array:
		var number = ball_values_array[count]
		ball.progress_ratio = 0
		ball.number = number
		ball.get_child(0).get_child(0).text = str(number)
		ball.modulate = gameManager.color_array[int(number/10) - 1]
		ball.move = false
		count += 1
		


func _on_extraction_timer_timeout():
	waiting = false


func _on_bingo_begin_extraction():
	current_ball = 0
	waiting = false
	extracting = true


func _on_bingo_pause_resume_extraction():
	pause = !pause
	extraction_timer.paused = pause
	for i in current_ball:
		extraction_path.get_child(i).pause = pause


func _on_bingo_reset_game():
	refresh_balls()

