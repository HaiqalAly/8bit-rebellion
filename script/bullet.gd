extends Area2D

var direction: Vector2

func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Bullets, "scale", Vector2(1, 1), 0.1).set_ease(Tween.EASE_OUT)
	
func setup(pos: Vector2, dir: Vector2):
	position = pos + dir * 17
	direction = dir
	
func _physics_process(delta: float) -> void:
	position += direction * 120 * delta
	
