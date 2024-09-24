extends Node2D

const PIPES = preload("res://scenes/pipes/pipes.tscn")

@onready var spawn_u = $SpawnU
@onready var spawn_l = $SpawnL
@onready var spawn_timer = $SpawnTimer
@onready var pipes_holder = $PipesHolder


func _ready():
	SignalManager.on_plane_died.connect(_on_plane_died)
	spawn_pipes()


func _process(delta):
	pass


func spawn_pipes():
	var new_pipes: Pipes = PIPES.instantiate()
	var y_position: float = randf_range(spawn_u.position.y, spawn_l.position.y)

	pipes_holder.add_child(new_pipes)
	new_pipes.global_position = Vector2(spawn_l.position.x, y_position)


func _on_spawn_timer_timeout():
	spawn_pipes()


func _on_plane_died():
	spawn_timer.stop()
