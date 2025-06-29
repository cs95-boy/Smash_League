extends Node3D

@onready var shuttle_cock: RigidBody3D = $shuttlecock
const FORCE = 0.3 # force applied on the shuttle_cock
var shot_angle: float = 60 # shot angle for the shuttle cock
var force_dir:Vector3 = Vector3(-FORCE*cos((deg_to_rad(shot_angle))), FORCE*sin(deg_to_rad(shot_angle)), 0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		force_dir.x = -force_dir.x
		shuttle_cock.apply_impulse(force_dir , shuttle_cock.position - shuttle_cock.global_position)
		if floor(shuttle_cock.rotation.z)==90:
			shuttle_cock.rotation.z = 0
		elif floor(shuttle_cock.rotation.z)==0:
			shuttle_cock.rotation.z = 90
