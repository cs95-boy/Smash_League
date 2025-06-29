extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if Input.is_action_pressed("forward"):
		velocity.z = 2
		animation_player.play("Armature|mixamo_com|Layer0")
	else:
		velocity.z = lerp(velocity.z, 0.0, 0.2)

	move_and_slide()
