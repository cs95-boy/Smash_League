extends Node3D

#@onready var player_scene = preload("res://Data/scenes/player.tscn")
#
#func _ready():
	# Handle multiplayer connections
#	multiplayer.peer_connected.connect(_add_player)
#	multiplayer.peer_disconnected.connect(_remove_player)
#	
#	# Add host player
#	if multiplayer.is_server():
#		_add_player(1)
#
#func _add_player(peer_id):
#	var player = player_scene.instantiate()
#	player.name = str(peer_id)
#	player.set_multiplayer_authority(peer_id)
#	$Players.add_child(player)
#	
#	# Position players
#	var spawn_points = $Players.get_children()
#	if spawn_points.size() > 0:
#		player.global_position = spawn_points[0].global_position
#
#func _remove_player(peer_id):
#	var player = $Players.get_node_or_null(str(peer_id))
#	if player:
#		player.queue_free()
