extends Control

@onready var highscore_label = $MarginContainer/HighscoreLabel


func _ready():
	highscore_label.text = str(ScoreManager.get_high_scode())


func _process(delta):
	if Input.is_action_just_pressed("fly"):
		GameManager.load_game_scene()
