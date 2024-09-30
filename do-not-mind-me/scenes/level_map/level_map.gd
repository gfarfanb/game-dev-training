extends Node2D

@onready var pick_ups = $PickUps
@onready var game_ui = $CanvasLayer/GameUI

var _pick_ups_count: int = 0
var _collected: int = 0


func _ready():
	_pick_ups_count = pick_ups.get_child_count()
	game_ui.update_score(_collected, _pick_ups_count)
	SignalManager.on_pickup.connect(on_pickup)
	SignalManager.on_exit.connect(on_exit)
	SignalManager.on_game_over.connect(on_game_over)


func check_show_exit():
	if _collected == _pick_ups_count:
		SignalManager.on_show_exit.emit()
		print("on_show_exit")


func on_pickup():
	print("on_pickup")
	_collected += 1
	game_ui.update_score(_collected, _pick_ups_count)
	check_show_exit()


func stop_all_nodes():
	for bullet in get_tree().get_nodes_in_group("bullet"):
		bullet.queue_free()
	
	var player = get_tree().get_first_node_in_group("player")
	player.set_physics_process(false)
	
	for npc in get_tree().get_nodes_in_group("npc"):
		npc.stop_action()


func on_exit():
	stop_all_nodes()


func on_game_over():
	stop_all_nodes()
