extends MultiplayerSynchronizer

@export var jumping := false

@export var input_direction := Vector2()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	input_direction = Input.get_vector("left", "right", "forward", "backward")
	if Input.is_action_just_pressed("ui_accept"):
		jump.rpc()

@rpc("call_local")
func jump():
	jumping = true
