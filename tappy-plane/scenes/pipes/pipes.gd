extends Node2D

class_name Pipes

@onready var score_sound = $ScoreSound

const OFF_SCREEN: float = -500.0


func _ready():
	SignalManager.on_plane_died.connect(_on_plane_died)


func _process(delta):
	position.x -= delta * GameManager.SCROLL_SPEED
	
	check_off_screen()


func check_off_screen():
	if position.x < OFF_SCREEN:
		queue_free()


func _on_screen_exited():
	queue_free()


func _on_plane_died():
	set_process(false)


func _on_pipe_body_entered(body):
	if body is Tappy:
		body.die() 


func _on_laser_body_entered(body):
	if body is Tappy:
		score_sound.play()
