extends CharacterBody3D
class_name Player

@export_group("Movement")
@export var speed: float = 10
@export var sprint_speed: float = 20
@export var jump_vel: float = 25
@export var gravity: float = 100

@export_group("Look")
@export var cam_root: Node3D
@export var yaw: Node3D
@export var pitch: Node3D
@export var cam: Camera3D
@export var mouse_sens: float = 0.1
@export var rotate_speed: float = 10


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	cam_root.top_level = true


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Rotate horizontally
		yaw.rotation_degrees.y -= event.relative.x * mouse_sens
		
		# Rotate vertically
		pitch.rotation_degrees.x -= event.relative.y * mouse_sens
		pitch.rotation_degrees.x = clampf(pitch.rotation_degrees.x, -90, 90)


func _physics_process(delta: float) -> void:
	# Gravity and Jump
	if is_on_floor():
		velocity.y = 0
		
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_vel
	else:
		velocity.y -= gravity * delta
	
	# Movement
	var input_dir: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var move_dir: Vector3 = yaw.global_basis * Vector3(input_dir.x, 0, input_dir.y)
	move_dir = move_dir.normalized()
	
	if move_dir:
		velocity.x = move_dir.x * _get_speed()
		velocity.z = move_dir.z * _get_speed()
	else:
		velocity.x = 0
		velocity.z = 0
	
	move_and_slide()
	
	# Rotation
	if move_dir:
		var target_pos: Vector3 = global_position + (move_dir * 10)
		var target_transform: Transform3D = global_transform.looking_at(target_pos)
		
		global_basis = global_basis.slerp(
			target_transform.basis,
			rotate_speed * delta
		)
	
	cam_root.global_position = global_position


func _get_speed() -> float:
	if Input.is_action_pressed("sprint"):
		return sprint_speed
	else:
		return speed
