extends CanvasLayer

@onready var actualScoreLabel: Label
@export var gameoverSound: AudioStreamPlayer3D
@export var blocksFreeSound: AudioStreamPlayer3D
@export var bgm: AudioStreamPlayer3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	actualScoreLabel = $"./Container/ActualScore"
	GameManager.connect("change_score", self.change_score)
	GameManager.connect("gameover", self.show_gameover)
	
func change_score():
	actualScoreLabel.text = str(GameManager.current_score)
	blocksFreeSound.play()

func show_gameover():
	gameoverSound.play()
	get_tree().paused = true
	$"./Gameover".visible = true
	$"./ResetButton".visible = true

func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
