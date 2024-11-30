extends Node3D

@export var block: PackedScene
var box_size = 4
var positions = [
	[4, 4, 4], [4, -4, 4], [4, -4, -4], [4, 4, -4],
	[-4, 4, 4], [-4, -4, 4], [-4, -4, -4], [-4, 4, -4]
]
var materials = []

var swipe_start = null
@onready var frozen_blocks = []
@onready var block_holder: Node3D

var yellowMaterial: StandardMaterial3D;
var blueMaterial: StandardMaterial3D;
var purpleMaterial: StandardMaterial3D; 

func _ready():
	yellowMaterial = StandardMaterial3D.new()
	yellowMaterial.albedo_color = Color("#fca034")
	blueMaterial = StandardMaterial3D.new()
	blueMaterial.albedo_color = Color("#00cbfc")
	purpleMaterial = StandardMaterial3D.new()
	purpleMaterial.albedo_color = Color("#e98fff")
	materials = [ yellowMaterial, yellowMaterial, blueMaterial, blueMaterial, 
					purpleMaterial, purpleMaterial, yellowMaterial, purpleMaterial
				]
	block_holder = %"BlockHolder"
	spawn()

# randomly spawns 2 boxes within the confines of 2x2
func spawn():
	var spawn_number = randi_range(2, 3)
	# add blocks here as we need
	var blocks = []
	for i in range(spawn_number):
		blocks.append(block.instantiate())
	var temp_positions = positions.duplicate(true)
	temp_positions.shuffle()
	var temp_materials = materials.duplicate(true)
	temp_materials.shuffle()
	
	for i in range(len(blocks)):
		var block_pos = temp_positions.pop_back()
		var block_material = temp_materials.pop_back()
		var block = blocks[i]
		block.get_child(1).material_override = block_material
		block.global_transform.origin = Vector3(block_pos[0], block_pos[1], block_pos[2])
		block.freeze = true
		frozen_blocks.push_back(block)
		self.add_child(block)


# This is when we check for game state and update stuff
func unfreeze_all():
	var temp_blocks = []
	for i in range(len(frozen_blocks)):
		var frozen_block = frozen_blocks.pop_back()
		frozen_block.reparent(block_holder)
		frozen_block.freeze = false
		temp_blocks.append(frozen_block)
	await get_tree().create_timer(1.5).timeout
	for i in range(len(temp_blocks)):
		temp_blocks.pop_back().is_on_ground = true
	GameManager.emit_signal("check_blocks")


func _unhandled_input(event):
	if event.is_action_pressed("press"):
		swipe_start = event.get_position()
	if event.is_action_released("press"):
		var difference = swipe_start - event.get_position()
		if difference.length() < 100:
			await unfreeze_all()
			spawn()
			
