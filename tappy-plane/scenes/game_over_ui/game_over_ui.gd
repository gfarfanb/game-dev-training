extends Control

@onready var game_over_label = $GameOverLabel
@onready var space_label = $SpaceLabel
@onready var timer = $Timer
@onready var sound = $Sound


func _ready():
	hide()
	SignalManager.on_plane_died.connect(_on_plane_died)


func _process(delta):
	if space_label.visible and Input.is_action_just_pressed("fly"):
		GameManager.load_main_scene()


func _on_plane_died():
	show()
	timer.start()
	sound.play()


func _on_timer_timeout():
	game_over_label.hide()
	space_label.show()
