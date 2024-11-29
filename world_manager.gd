extends Node3D


@onready var block_holder: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.connect("check_blocks", do_check_for_suicidal_blocks)
	block_holder = %"BlockHolder"
	print('block holder', block_holder)
	
func do_check_for_suicidal_blocks():
	print("CHECKING")
	# we're only interested in blocks that are children of the blockholder
	var store = {}
	var blocks = block_holder.get_children()
	
	for i in range(len(blocks)):
		var child = blocks[i]
		if child.touching_n_other_blocks > 1:
			var child_color = str(child.block_color)
			if child_color not in store:
				store[child_color] = 0
			store[child_color] += 1
			if store[child_color] >= 3:
				# explode them all
				GameManager.emit_signal("self_destruct", child_color)
