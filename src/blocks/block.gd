extends RigidBody3D

var is_on_ground = false
var touching_n_other_blocks = 0  # apparently touching itself counts as 1, so we need to check for > 1
@onready var block_color: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	block_color = str(self.get_child(1).material_override.albedo_color)
	GameManager.connect("self_destruct", self.i_cant_take_this_no_mo)

func i_cant_take_this_no_mo(color: String):
	if (color == block_color and self.touching_n_other_blocks > 1):
		self.queue_free()
		GameManager.emit_signal("change_score")


func _on_area_3d_body_entered(body: Node3D) -> void:
	var collision_body = body.get_child(1)
	if collision_body is MeshInstance3D and str(body.block_color) == self.block_color:
		self.touching_n_other_blocks += 1


func _on_area_3d_body_exited(body: Node3D) -> void:
	var collision_body = body.get_child(1)
	if collision_body is MeshInstance3D and str(body.block_color) == self.block_color:
		self.touching_n_other_blocks -= 1
