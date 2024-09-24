extends Node

const GAME: PackedScene = preload("res://scenes/game/game.tscn")
const MAIN: PackedScene = preload("res://scenes/main/main.tscn")
#const SIMPLE_TRANSITION: PackedScene = preload("res://scenes/simple_transition/simple_transition.tscn")
const COMPLEX_TRANSITION = preload("res://scenes/complex_transition/complex_transition.tscn")

const SCROLL_SPEED: float =  120.0

var next_scene: PackedScene


func load_next_scene():
	get_tree().change_scene_to_packed(next_scene)


func load_scene(scene: PackedScene):
	next_scene = scene
	#get_tree().change_scene_to_packed(SIMPLE_TRANSITION)
	add_child(COMPLEX_TRANSITION.instantiate())
	


func load_game_scene():
	load_scene(GAME)


func load_main_scene():
	load_scene(MAIN)
	
