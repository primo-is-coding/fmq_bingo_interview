extends TextureRect

class_name CardSlot

var number : int

func hit():
	self.modulate = Color.AQUAMARINE

func reset():
	self.modulate = Color.WHITE
