extends Area2D
class_name Player

@export var speed = 200

signal player_destroyed

var direction = Vector2.ZERO
@onready var collision_rect: CollisionShape2D = $CollisionShape2D


var bounding_size_x 
var start_bound
var end_bound
var HP = 3
var reload = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	bounding_size_x = collision_rect.shape.get_rect().size.x / 2
	var rect = get_viewport().get_visible_rect()
	var camera = get_viewport().get_camera_2d()
	var camera_position = camera.position
	start_bound = 40
	end_bound = camera_position.x + 525
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	reload -= delta
	var screen_bounding_box = get_viewport_rect().end.x
	var input = Input.get_axis("ui_left", "ui_right")
	if input > 0:
		direction = Vector2.RIGHT
	elif  input < 0:
		direction = Vector2.LEFT
	else:
		direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_accept") && reload <= 0:
		reload = 1
		fire()
	
	var deltaMovement = speed * delta * direction.x
	# limit the movement to the screen
#	bounding_size_x * transform.get_scale().x
	if position.x + deltaMovement < start_bound || position.x + deltaMovement > end_bound:
		return
	position.x += deltaMovement


func fire():
	var bullet = preload("res://Scenes/shoot.tscn")
	var firebuller = bullet.instantiate() as Shoot
	firebuller.position = Vector2(position.x, position.y-30)
	get_parent().get_tree().root.add_child(firebuller)
	#get_parent().call_deferred("add_child", firebuller)


func on_player_destroyed():
	speed = 0
	HP -= 1
	await get_tree().create_timer(1).timeout
	speed = 200
	player_destroyed.emit()
	if (HP == 0):
		queue_free()
	




