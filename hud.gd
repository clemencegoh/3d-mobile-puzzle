extends CanvasLayer

@onready var actualScoreLabel: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	actualScoreLabel = $"./Container/ActualScore"
	GameManager.connect("change_score", self.change_score)
	GameManager.connect("gameover", self.show_gameover)
	
func change_score():
	actualScoreLabel.text = str(GameManager.current_score)

func show_gameover():
	get_tree().paused = true
	$"./Gameover".visible = true
