extends Node2D

@export var gem_scene: PackedScene

@onready var label = $Label
@onready var timer = $Timer
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

const EXPLODE = preload("res://assets/explode.wav")

var _score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_gem()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass # Replace with function body.


func spawn_gem():
	var new_gem: Gem = gem_scene.instantiate()
	var xpos: float = randf_range(70, 1050)
	
	new_gem.position = Vector2(xpos, -50)
	new_gem.on_gem_off_screen.connect(game_over)

	add_child(new_gem)


func stop_all():
	timer.stop()

	for child in get_children():
		child.set_process(false)


func play_dead():
	audio_stream_player_2d.stop()
	audio_stream_player_2d.stream = EXPLODE
	audio_stream_player_2d.play()


func game_over():
	stop_all()
	play_dead()


func _on_timer_timeout():
	spawn_gem()


func _on_paddle_area_entered(area):
	_score += 1
	label.text = "%05d" % _score

	audio_stream_player_2d.position = area.position
	audio_stream_player_2d.play()
	area.queue_free()
