extends Node2D

class_name InvaderSpawner

signal invader_destroyed(points: int)
signal game_won
signal game_lost


const ROWS = 5
const COLUMNS = 11
const HORIZONTAL_SPACING = 32
const VERTICAL_SPACING = 32
const INVADER_HEIGHT = 12

var invader_scene
const START_Y_POSITION = -50

const INVADERS_POSITION_X_INCREMENT = 8
const INVADERS_POSITION_Y_INCREMENT = 20
var movement_direction = 1


@onready var movement_timer: Timer = $MovementTimer
@onready var shoot_timer: Timer = $ShootTimer
var invader_shoot_scene = preload("res://Scenes/invader_shoot.tscn")

var invader_total_count = ROWS * COLUMNS
var invader_destroyed_count = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	
	movement_timer.timeout.connect(move_invaders)
	shoot_timer.timeout.connect(on_invader_shoot)
	
	var invader_1_res = preload("res://Resources/Invader_1.tres")
	var invader_2_res = preload("res://Resources/Invader_2.tres")
	var invader_3_res = preload("res://Resources/Invader_3.tres")
	invader_scene = preload("res://Scenes/invader.tscn")	

	var invader_config
	for row in ROWS:
		
		if row == 0:
			invader_config = invader_1_res
		elif  row < ROWS - 2 :
			invader_config = invader_2_res
		elif row >= ROWS - 2:
			invader_config = invader_3_res
			
		var row_width = (COLUMNS * invader_config.width * 3) + ((COLUMNS - 1) * HORIZONTAL_SPACING)

		var start_x_position = (position.x - row_width) / 2
		
		for col in COLUMNS:
			
			var x = start_x_position + (col * invader_config.width * 3) + (col * HORIZONTAL_SPACING)
			var y = START_Y_POSITION + (row * INVADER_HEIGHT) + (row * VERTICAL_SPACING)
			
			var spawn_position = Vector2(x, y)
			spawn_invader(invader_config, spawn_position)


func spawn_invader(invader_config, spawn_position:Vector2):
	var invader = invader_scene.instantiate() as Invader
	invader.config = invader_config
	invader.global_position = spawn_position
	invader.invader_destroyed.connect(on_invader_destroyed)
	add_child(invader)
	

func move_invaders():
	position.x += INVADERS_POSITION_X_INCREMENT * movement_direction


func on_invader_shoot():
	var random_child_position = get_children().filter(func (child ): return child is Invader).map(func (invader): return invader.global_position).pick_random()
	var invader_shoot = invader_shoot_scene.instantiate() as InvaderShoot
	invader_shoot.global_position = random_child_position
	get_tree().root.add_child(invader_shoot)



func on_invader_destroyed(points: int):
	invader_destroyed.emit(points)
	invader_destroyed_count += 1
	if invader_destroyed_count == invader_total_count:
		game_won.emit()
		shoot_timer.stop()
		movement_timer.stop()


func _on_wall_area_entered(area):
	if (movement_direction == -1):
		position.y += INVADERS_POSITION_Y_INCREMENT
		movement_direction *= -1


func _on_wall_2_area_entered(area):
	if (movement_direction == 1):
		position.y += INVADERS_POSITION_Y_INCREMENT
		movement_direction *= -1
