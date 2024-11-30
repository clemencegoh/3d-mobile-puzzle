extends Node

# Global signals
signal self_destruct
signal check_blocks
signal change_score
signal gameover

var current_score = 0

func _ready() -> void:
	DisplayServer.screen_set_orientation(DisplayServer.SCREEN_PORTRAIT)
	self.connect("change_score", self.add_to_score)
	
func add_to_score():
	self.current_score += 1
