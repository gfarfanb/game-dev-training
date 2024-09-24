extends Control

@onready var score_label = $ScoreLabel

func _ready():
	SignalManager.on_score_updated.connect(_on_score_updated)


func _on_score_updated(score):
	score_label.text = str(score)
