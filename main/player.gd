extends CharacterBody3D
class_name Player

@export_group("Movement")
@export var speed: float = 10
@export var sprint_speed: float = 20
@export var jump_vel: float = 25
@export var gravity: float = 100

@export_group("Look")
@export var cam: Camera3D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var move_dir: Vector3 = cam.global_basis * Vector3(input_dir.x, 0, input_dir.y)
	move_dir = move_dir.normalized()
	
	if move_dir:
		velocity.x = move_dir.x * _get_speed()
		velocity.z = move_dir.z * _get_speed()
	else:
		velocity.x = 0
		velocity.z = 0
	
	move_and_slide()


func _get_speed() -> float:
	if Input.is_action_pressed("sprint"):
		return sprint_speed
	else:
		return speed
