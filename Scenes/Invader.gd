extends Area2D

class_name Invader

signal invader_destroyed(points: int)

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
var config: Resource

func _ready():
	sprite_2d.texture = config.sprite
	animation_player.play(config.animation)


func _on_area_entered(area):
	if area is Shoot:
		invader_destroyed.emit(config.points)
		area.queue_free()
		queue_free()


