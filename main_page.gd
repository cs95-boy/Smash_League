extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_settings_button_pressed() -> void:
	$MarginContainer/VBoxContainer/HBoxContainer2/Control/Settings_button/TextureButton/AnimationPlayer.play("settings_clicked")


func _on_texture_button_pressed() -> void:
	_on_settings_button_pressed()


func _on_exit_button_pressed() -> void:
	get_tree().quit()
