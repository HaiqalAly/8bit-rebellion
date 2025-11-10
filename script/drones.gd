extends CharacterBody2D

var direction: Vector2
var speed := 80
var player: CharacterBody2D
var health := 5

func _on_detection_area_body_entered(body: CharacterBody2D) -> void:
	player = body

func _physics_process(_delta: float) -> void:
	if player:
		var player_direction = (player.position - position).normalized()
		velocity = player_direction * speed
		move_and_slide()


func _on_detection_area_body_exited(_body: Node2D) -> void:
	player = null


func _on_collision_area_body_entered(_body: Node2D) -> void:
	explode()

func hit():
	health -= 1
	if health <= 0:
		explode()
	
func explode():
	speed = 0
	$Drone.hide()
	$ExplosionSprite.show()
	$AnimationPlayer.play("explode")
	await $AnimationPlayer.animation_finished
	queue_free()

func chain_reaction():
	for drone in get_tree().get_nodes_in_group('Drone'):
		if position.distance_to(drone.position) < 20:
			drone.explode()
