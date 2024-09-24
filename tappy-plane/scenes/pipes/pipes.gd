extends Node2D

class_name Pipes

@onready var score_sound = $ScoreSound
@onready var visible_on_screen = $VisibleOnScreenNotifier2D


func _ready():
	SignalManager.on_plane_died.connect(_on_plane_died)


func _process(delta):
	position.x -= delta * GameManager.SCROLL_SPEED

	check_off_screen()


func check_off_screen():
	if visible_on_screen.global_position.x < get_viewport_rect().position.x:
		queue_free()


func _on_plane_died():
	set_process(false)


func _on_pipe_body_entered(body):
	if body is Tappy:
		body.die() 


func _on_laser_body_entered(body):
	if body is Tappy:
		score_sound.play()
		ScoreManager.increment_score()
