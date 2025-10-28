extends CharacterBody2D

var direction_x: float
var speed := 50
@export var jump_strenght := 10
@export var gravity := 10
var can_shoot := true
const SHOOT_COOLDOWN := 0.5

signal shoot(pos: Vector2, dir: Vector2)

func get_input():
	direction_x = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("jump"):
		velocity.y = -jump_strenght
	if Input.is_action_just_pressed("shoot") and $ReloadTimer.time_left == 0:
		emit_signal("shoot", global_position, (get_global_mouse_position() - global_position).normalized())
		$ReloadTimer.start()
		
func apply_gravity(delta):
	velocity.y += gravity * delta
 
func _physics_process(delta: float) -> void:
	get_input()
	velocity.x = direction_x * speed
	apply_gravity(delta)
	move_and_slide()
