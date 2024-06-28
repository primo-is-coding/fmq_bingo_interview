extends Panel

class_name Card

signal last_ball_extracted

var card_slot = preload("res://Scenes/card_slot.tscn")

@onready var gameManager = $".." as GameManager
@onready var miss_sound = $MissSound
@onready var hit_sound = $HitSound
@onready var bingo_sound = $BingoSound

var card_slots : Array[CardSlot]
var current_numbers : Array
var ball_counter = 1
var hits : Array
var cols : BoxContainer
var rows : BoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	cols = get_child(0)
	rows = cols.get_child(0)


# Creates the card on game opening
func generate_card(numbers, number_of_cols, number_of_rows):
	current_numbers = numbers
	current_numbers.sort()
	if number_of_cols > 1:
		for i in number_of_cols:
			cols.add_child(rows.duplicate())
	# Set card size
	var new_panel_size = Vector2(number_of_cols*125 + (number_of_cols-1) * 15,number_of_rows*125 + (number_of_rows-1) * 15)
	self.size = new_panel_size
	# Create card slots
	var count = 0
	for i in number_of_cols:
		for j in number_of_rows:
			card_slots.append(card_slot.instantiate() as CardSlot)
			card_slots[count].get_child(0).text = str(current_numbers[count])
			cols.get_child(i).add_child(card_slots[count])
			count+=1


func check_hit(number):

	if number in current_numbers:
		hits.append(number)
		card_slots[current_numbers.find(number)].hit()
		hit_sound.play()
	else:
		miss_sound.play()

	ball_counter += 1
	if ball_counter == gameManager.number_of_balls:
		last_ball_extracted.emit()
		ball_counter = 1


		
	if hits.size() == current_numbers.size():
		bingo_sound.play()


#reset the card by getting a new set of numbers, reseting hits, unmarking cards and updating labels
func _on_bingo_reset_game():
	current_numbers = gameManager.generate_numbers(current_numbers.size())
	current_numbers.sort()
	hits.clear()
	var count = 0
	for slot in card_slots:
		slot.reset()
		slot.number = current_numbers[count]
		slot.get_child(0).text = str(current_numbers[count])
		count += 1
