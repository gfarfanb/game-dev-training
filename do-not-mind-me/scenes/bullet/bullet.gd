extends Area2D

const BOOM: PackedScene = preload("res://scenes/boom/boom.tscn")
const SPEED: float = 250.0

@onready var timer = $Timer

var _direction_of_travel: Vector2 = Vector2.ZERO
var _target_position: Vector2 = Vector2.ZERO


func _ready():
	look_at(_target_position)


func _process(delta):
	position += SPEED * delta * _direction_of_travel


func init(target: Vector2, start_pos: Vector2):
	_target_position = target
	_direction_of_travel = start_pos.direction_to(target)
	global_position = start_pos


func create_boom():
	var boom = BOOM.instantiate()
	boom.global_position = global_position
	get_tree().root.add_child(boom)
	queue_free()


func _on_timer_timeout():
	create_boom()


func _on_body_entered(body):
	if body.is_in_group("player"):
		timer.stop()
		SignalManager.on_game_over.emit()
	else:
		create_boom()
