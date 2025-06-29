extends Node

const SPAWN_RANDOM:= 5.0

func _ready() -> void:
	print("level ready")
	
	if not multiplayer.is_server():
		return
	
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(del_player)
	
	for id in multiplayer.get_peers():
		add_player(id)
		
	if not OS.has_feature("dedicated_server"):
		add_player(1)

func add_player(id: int):
	print("add player:" + str(id))
	var character = preload("res://Data/scenes/player.tscn")
	character.player = id
	
	var pos := Vector2.from_angle(randf() * 2 * PI)
	character.position = Vector3(pos.x * SPAWN_RANDOM * randf(), 0, pos.y * SPAWN_RANDOM * randf())
	character.name = str(id)
	$Player.add_child(character, true)

func del_player(id: int):
	if not $Player.has_node(str(id)):
		return
	$Player.get_node(str(id)).queue_free()

func _exit_tree() -> void:
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(del_player)
