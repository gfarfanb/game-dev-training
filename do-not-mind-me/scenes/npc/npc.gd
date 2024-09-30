extends CharacterBody2D

enum EnemyState { PATROLLING, CHASING, SEARCHING }

const BULLET = preload("res://scenes/bullet/bullet.tscn")

const FIELD_OF_VIEW = {
	EnemyState.PATROLLING: 60.0,
	EnemyState.CHASING: 120.0,
	EnemyState.SEARCHING: 100.0
}

const SPEED = {
	EnemyState.PATROLLING: 60.0,
	EnemyState.CHASING: 100.0,
	EnemyState.SEARCHING: 80.0
}

@export var patrol_points: NodePath

@onready var navigation_agent = $NavigationAgent
@onready var sprite_2d = $Sprite2D
@onready var debug_label = $DebugLabel
@onready var player_detect = $PlayerDetect
@onready var ray_cast_2d = $PlayerDetect/RayCast2D
@onready var warning = $Warning
@onready var gasp_sound = $GaspSound
@onready var animation_player = $AnimationPlayer
@onready var shoot_timer = $ShootTimer

var _waypoints: Array = []
var _current_waypoint: int = 0
var _player_ref: Player
var _state: EnemyState = EnemyState.PATROLLING

func _ready():
	set_physics_process(false)
	create_waypoint()
	_player_ref = get_tree().get_first_node_in_group("player")
	call_deferred("late_setup")


func late_setup():
	await get_tree().physics_frame
	call_deferred("set_physics_process", true)


func create_waypoint():
	for c in get_node(patrol_points).get_children():
		_waypoints.append(c.global_position)


func _physics_process(delta):
	if Input.is_action_just_pressed("set_target"):
		navigation_agent.target_position = get_global_mouse_position()
	raycast_to_player()
	update_state()
	update_movement()
	update_navigation()
	set_label()


func is_player_in_field_of_view():
	return get_field_of_view_angle() < FIELD_OF_VIEW[_state]


func get_field_of_view_angle():
	var direction = global_position.direction_to(_player_ref.global_position)
	var dot_product = direction.dot(velocity.normalized())
	
	if dot_product >= -1.0 and dot_product <= 1.0:
		return rad_to_deg(acos(dot_product))
	
	return 0.0


func raycast_to_player():
	player_detect.look_at(_player_ref.global_position)


func is_player_detected():
	var collider = ray_cast_2d.get_collider()
	return collider != null and collider.is_in_group("player")


func can_see_player() -> bool:
	return is_player_in_field_of_view() and is_player_detected()


func update_navigation():
	if !navigation_agent.is_navigation_finished():
		var next_path_position: Vector2 = navigation_agent.get_next_path_position()
		sprite_2d.look_at(next_path_position)
		
		var init_velocity = global_position.direction_to(next_path_position) * SPEED[_state]
		navigation_agent.set_velocity(init_velocity)


func navigate_waypoint():
	if _current_waypoint >= len(_waypoints):
		_current_waypoint = 0
	navigation_agent.target_position = _waypoints[_current_waypoint]
	_current_waypoint += 1


func set_navigate_to_player():
	navigation_agent.target_position = _player_ref.global_position


func process_patrolling():
	if navigation_agent.is_navigation_finished():
		navigate_waypoint()


func process_chasing():
	set_navigate_to_player()


func process_searching():
	if navigation_agent.is_navigation_finished():
		set_state(EnemyState.PATROLLING)
	


func set_state(new_state: EnemyState):
	if new_state == _state:
		return
	
	if _state == EnemyState.SEARCHING:
		warning.hide()
	
	if new_state == EnemyState.SEARCHING:
		warning.show()
	elif new_state == EnemyState.CHASING:
		SoundManager.play_gasp(gasp_sound)
		animation_player.play("alert")
	elif new_state == EnemyState.PATROLLING:
		animation_player.play("RESET")
	
	_state = new_state


func update_movement():
	match _state:
		EnemyState.PATROLLING:
			process_patrolling()
		EnemyState.SEARCHING:
			process_searching()
		EnemyState.CHASING:
			process_chasing()

func update_state():
	var new_state = _state
	var can_see = can_see_player()

	if can_see:
		new_state = EnemyState.CHASING
	elif !can_see and new_state == EnemyState.CHASING:
		new_state = EnemyState.SEARCHING

	set_state(new_state)


func shoot():
	var target = _player_ref.global_position
	var bullet = BULLET.instantiate()
	bullet.init(target, global_position)
	get_tree().root.add_child(bullet)
	SoundManager.play_laser(gasp_sound)


func stop_action():
	set_physics_process(false)
	shoot_timer.stop()


func _on_shoot_timer_timeout():
	if _state != EnemyState.CHASING:
		return

	shoot()


func set_label():
	var debug_text: String = ""
	debug_text += "DONE:%s\n" % navigation_agent.is_navigation_finished()
	debug_text += "REACHED:%s\n" % navigation_agent.is_target_reached()
	debug_text += "TARGET:%s\n" % navigation_agent.target_position
	debug_text += "PLAYER-DETECTED:%s\n" % is_player_detected()
	debug_text += "PLAYER-IN-FIELD-OF-VIEW:%s\n" % is_player_in_field_of_view()
	debug_text += "FIELD-OF-VIEW:%.2f %s\n" % [get_field_of_view_angle(), EnemyState.keys()[_state]]
	debug_text += "FIELD-OF-VIEW:%s %s\n" % [is_player_in_field_of_view(), SPEED[_state]]
	debug_label.text = debug_text


func _on_hit_area_body_entered(body):
	SignalManager.on_game_over.emit()


func _on_navigation_agent_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()
