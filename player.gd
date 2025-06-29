extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const PUSH_FORCE = 0.01

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var player_pos = Vector3.ZERO

@onready var target: Node3D = $Player_target
var i_target_pos:Vector3

@onready var racket: Node3D = $Racket/badminton
var racket_action: String = ""

@onready var power_meter: Sprite3D = $Power_meter
@onready var camera = $"../../Camera/Player_camera"

# Multiplayer control
func _ready():
	i_target_pos = target.position
	#if is_multiplayer_authority():
	#	camera.current = true

func _physics_process(delta):
	#if not is_multiplayer_authority(): 
	#	return
	 
	# Add gravity
	#if not is_on_floor():
	#	velocity.y -= gravity * delta
	
	# Handle Jump
	#if Input.is_action_just_pressed("jump") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY
	# Get input direction
	#var input_dir = Input.get_vector("left", "right", "forward", "backward")
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#if direction:
	#	velocity.x = direction.x * SPEED
	#	velocity.z = direction.z * SPEED
	#else:
	#	velocity.x = move_toward(velocity.x, 0, SPEED)
	#	velocity.z = move_toward(velocity.z, 0, SPEED)
	player_move()
	move_and_slide()
	
	racket_move()

func player_move()->void :
	#Logic for player movement
	if Input.is_action_pressed("forward") and Input.is_action_pressed("backward") :
		velocity.x = 0
	elif Input.is_action_pressed("forward"):
		velocity.z = 0
		velocity.x = -SPEED
		if Input.is_action_pressed("left"):
			velocity.z = SPEED/2
		elif Input.is_action_pressed("right"):
			velocity.z = -SPEED/2
	elif Input.is_action_pressed("backward"):
		velocity.z = 0
		velocity.x = SPEED
		if Input.is_action_pressed("left"):
			velocity.z = SPEED/2
		elif Input.is_action_pressed("right"):
			velocity.z = -SPEED/2
	elif Input.is_action_pressed("left") and Input.is_action_pressed("right") :
		velocity.z = 0
	elif Input.is_action_pressed("left"):
		velocity.x = 0
		velocity.z = SPEED
	elif Input.is_action_pressed("right"):
		velocity.x = 0
		velocity.z = -SPEED
	else:
		velocity.x = 0
		velocity.z = 0

func racket_move()-> void:
	#logic to make racket swing
	#making the power meter face the camera
	power_meter.rotation.x = camera.rotation.x
	
	#racket_movement
	if Input.is_action_pressed("racket_up") and Input.is_action_pressed("racket_down"):
		pass
	elif Input.is_action_pressed("racket_up"):
		rotate_racket(1, "racket_up")
		racket_action = "racket_up"
	elif Input.is_action_pressed("racket_down"):
		rotate_racket(1, "racket_down")
		racket_action = "racket_down"
	elif Input.is_action_pressed("racket_left") and Input.is_action_pressed("racket_right"):
		pass
	elif Input.is_action_pressed("racket_left"):
		racket.rotation.x = lerp_angle(racket.rotation.x, deg_to_rad(90), 0.15)
		racket_action = "racket_left"
	elif Input.is_action_pressed("racket_right"):
		racket.rotation.x = lerp_angle(racket.rotation.x, deg_to_rad(-90), 0.15)
		racket_action = "racket_right"
	elif Input.is_action_pressed("reset"):
		racket.rotation.x = lerp_angle(racket.rotation.x, deg_to_rad(0), 0.2)
		racket.rotation.y = lerp_angle(racket.rotation.y, deg_to_rad(0), 0.2)
		racket.rotation.z = lerp_angle(racket.rotation.z, deg_to_rad(0), 0.2)
		racket_action = ""
	else:
		racket_action = ""
	simple_shots(racket_action)

func rotate_racket(rot: int, key: String):
	
	if racket.rotation.x>=deg_to_rad(360)-0.1:
		racket.rotation.x = racket.rotation.x - deg_to_rad(360)
	#first checking if there is any previous rotation
	if rot==1 and (racket.rotation.x>0.0002 or racket.rotation.x<-0.0002):
		if key=="racket_up":
			racket.rotation.x = lerp_angle(racket.rotation.x, deg_to_rad(0), 0.15)
		else:
			racket.rotation.x = lerp_angle(racket.rotation.x, deg_to_rad(180), 0.15)
	else:
		if key=="racket_up":
			racket.rotation.z = lerp_angle(racket.rotation.z, deg_to_rad(0), 0.15)
		else:
			racket.rotation.z = lerp_angle(racket.rotation.z, deg_to_rad(170), 0.15)

func simple_shots(racket_action: String)->void:
	
	if racket_action!="":
		pass
	if Input.is_action_pressed("shift"):
		racket.rotation.z = lerp_angle(racket.rotation.z, -deg_to_rad(60), 0.35)
	elif !(Input.is_action_pressed("shift") and Input.is_action_pressed(racket_action)):
		racket.rotation.z = lerp_angle(racket.rotation.z, deg_to_rad(25), 0.42)

func interact():
	#Logic for Kinematic Body 3D(player) to Rigid Body 3D interactions
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			var push_dir = -c.get_normal()
			
			var vel_diff = self.velocity.dot(push_dir) - c.get_collider().linear_velocity.dot(push_dir)
			
			vel_diff = max(0.0, vel_diff/0.5)
			
			const player_mass = 80
			
			var mass_ratio = min(1.0, player_mass/c.get_collider().mass)
			
			push_dir.y = 0
			
			var push_force = mass_ratio * 3.0
			
			c.get_collider().apply_impulse(push_dir * vel_diff * push_force, c.get_position() - c.get_collider().global_position)
