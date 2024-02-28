extends Area2D

class_name InvaderShoot
var Life_time = 3
var Life_spawn = 0
@export var speed = 200

func _process(delta):
	position.y += speed * delta
	Life_spawn += delta
	if Life_spawn > Life_time:
		queue_free()


func _on_area_entered(area):
	if area is Player:
		(area as Player).on_player_destroyed()
		queue_free()
