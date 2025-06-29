extends Control

var peer = ENetMultiplayerPeer.new()
const PORT = 9999

func _on_host_pressed():
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	_start_game()

func _on_join_pressed():
	var ip = "127.0.0.1"
	peer.create_client(ip, PORT)
	multiplayer.multiplayer_peer = peer
	_start_game()

func _start_game():
	hide()
	var arena = preload("res://Data/scenes/arena.tscn").instantiate()
	get_tree().root.add_child(arena)
