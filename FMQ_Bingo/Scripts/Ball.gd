extends PathFollow2D

class_name Ball

signal finished_extracting(number:int)

var move = false
var pause = false
var number : int
var position_in_queue : int
var speed : float
var path : Path2D
var offset:int


func _ready():
	path = get_parent()


func set_attributes(n:int,piq:int,et:float,o:int):
	number = n
	position_in_queue = piq
	offset = o
	speed = (path.curve.get_baked_length() - (offset * position_in_queue)) / et


func _process(delta):
	if move and !pause:
		progress += delta * speed
		if progress + (offset * position_in_queue) > path.curve.get_baked_length():
			progress = path.curve.get_baked_length() - (offset * position_in_queue)
			move = false
			emit_signal("finished_extracting",number)


