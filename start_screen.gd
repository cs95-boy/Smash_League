extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		get_tree().change_scene_to_file("res://Data/scenes/arena.tscn")
