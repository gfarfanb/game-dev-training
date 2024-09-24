extends Control


func _ready():
	pass


func _process(delta):
	if Input.is_action_just_pressed("fly"):
		GameManager.load_game_scene()
