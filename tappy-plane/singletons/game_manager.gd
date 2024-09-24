extends Node

const GAME: PackedScene = preload("res://scenes/game/game.tscn")
const MAIN = preload("res://scenes/main/main.tscn")

const SCROLL_SPEED: float =  120.0

func load_game_scene():
	get_tree().change_scene_to_packed(GAME)


func load_main_scene():
	get_tree().change_scene_to_packed(MAIN)
	
