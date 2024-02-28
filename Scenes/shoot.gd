extends Area2D

class_name Shoot

var Life_time = 4
var Life_spawn = 0
@export var speed = -300

func _process(delta):
	position.y += speed * delta
	Life_spawn += delta
	if Life_spawn > Life_time:
		queue_free()
