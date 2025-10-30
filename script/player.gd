extends CharacterBody2D

var direction_x: float
var speed := 70
@export var jump_strenght := 350
@export var gravity := 600
var can_shoot := true
const SHOOT_COOLDOWN := 0.3
const gun_direction = {
	Vector2i(1,0):   0,
	Vector2i(1,1):   1,
	Vector2i(0,1):   2,
	Vector2i(-1,1):  3,
	Vector2i(-1,0):  4,
	Vector2i(-1,-1): 5,
	Vector2i(0,-1):  6,
	Vector2i(1,-1):  7,
}

signal shoot(pos: Vector2, dir: Vector2)

func get_input():
	direction_x = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("jump"):
		velocity.y = -jump_strenght
	if Input.is_action_just_pressed("shoot") and $ReloadTimer.time_left == 0:
		emit_signal("shoot", global_position, (get_global_mouse_position() - global_position).normalized())
		$ReloadTimer.start()
		$Crosshair.scale = Vector2(0.5, 0.5)
		var tween = get_tree().create_tween()
		tween.tween_property($Crosshair, "scale", Vector2(0.1, 0.1), 0.2)
		tween.tween_property($Crosshair, "scale", Vector2(0.5, 0.5), 0.3).set_ease(Tween.EASE_OUT)
		
func apply_gravity(delta):
	velocity.y += gravity * delta
 
func _physics_process(delta: float) -> void:
	get_input()
	velocity.x = direction_x * speed
	apply_gravity(delta)
	move_and_slide()
	animation()
	
func animation():
	$Legs.flip_h = direction_x < 0
	if is_on_floor():
		$AnimationPlayer.current_animation = 'run' if direction_x else 'idle'
	else:
		$AnimationPlayer.current_animation = 'jump'
	var raw_direction = get_global_mouse_position() - global_position
	var adjusted_dir = Vector2i(round(raw_direction.normalized().x), round(raw_direction.normalized().y))
	$Torso.frame = gun_direction[adjusted_dir]
	
	$Crosshair.position = (get_global_mouse_position() - global_position) * 1
