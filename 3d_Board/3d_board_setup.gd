extends Node3D

enum SLOT_ID {EMPTY, SQUARE_LIGHT, SQUARE_DARK, PATH,
LIGHT_PIECE_PAWN, LIGHT_PIECE_ROOK, LIGHT_PIECE_KNIGHT, LIGHT_PIECE_BISHOP, LIGHT_PIECE_QUEEN, LIGHT_PIECE_KING,
DARK_PIECE_PAWN, DARK_PIECE_ROOK, DARK_PIECE_KNIGHT, DARK_PIECE_BISHOP, DARK_PIECE_QUEEN, DARK_PIECE_KING}

var START_POINT = [-21, 10, -21]

@onready var PIECE_STORAGE = get_node("PiecesStorage")

@onready var PIECE_HOLDER = get_node("Pieces")

@onready var PIECE_LIST = [null, null, null, null,
	PIECE_STORAGE.get_node("Light_Pawn"),
	PIECE_STORAGE.get_node("Light_Rook"),
	PIECE_STORAGE.get_node("Light_Knight"),
	PIECE_STORAGE.get_node("Light_Bishop"),
	PIECE_STORAGE.get_node("Light_Queen"),
	PIECE_STORAGE.get_node("Light_King"),
	PIECE_STORAGE.get_node("Dark_Pawn"),
	PIECE_STORAGE.get_node("Dark_Rook"),
	PIECE_STORAGE.get_node("Dark_Knight"),
	PIECE_STORAGE.get_node("Dark_Bishop"),
	PIECE_STORAGE.get_node("Dark_Queen"),
	PIECE_STORAGE.get_node("Dark_King")
]

var MOVING_OBJECT
var REMOVING_OBJECT
var MOVE_TO_POS

func update_board():
	var piece_list = GLOBAL.CHESS_BOARD_SETUP[1]
	var row_count = 0
	var board_pos = self.position
	var board_pos_global = self.global_position
	var rng = RandomNumberGenerator.new()
	
	for row in piece_list:
		var column_count = 0
		for column in row:
			var c_column = column_count
			var c_row = row_count
			var slot_id = column
			if PIECE_LIST[slot_id] != null:
				
				var new_object = PIECE_LIST[slot_id].duplicate()
				
				if GLOBAL.TO_MOVE[0][0] == c_column and GLOBAL.TO_MOVE[0][1] == c_row:
					MOVING_OBJECT = new_object
				elif GLOBAL.TO_MOVE[1][0] == c_column and GLOBAL.TO_MOVE[1][1] == c_row:
					REMOVING_OBJECT = new_object
				
				self.add_child(new_object)
				new_object.owner = PIECE_HOLDER
				
				#new_object.global_position = board_pos_global + Vector3(START_POINT[0] + column_count * 5.25, 3, START_POINT[2] + row_count * 5.25)
				self.position = Vector3(0,0,0)
				new_object.position = Vector3(START_POINT[0] + c_column * 6, new_object.position.y, START_POINT[2] + c_row * 6)
				
				
			if GLOBAL.TO_MOVE[1][0] == c_column and GLOBAL.TO_MOVE[1][1] == c_row:
				MOVE_TO_POS = Vector3(START_POINT[0] + c_column * 6, 0, START_POINT[2] + c_row * 6)
			column_count += 1
		row_count += 1

func move_pieces():
	var camera = get_parent().get_node("Camera3D")
	print("getting cam")
	print(GLOBAL.TO_MOVE[1][0])
	print(GLOBAL.TO_MOVE[1][1])
	camera.transform.origin = MOVE_TO_POS + Vector3(0,10,0)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	match rng.randi_range(0,3):
		0:
			camera.transform.origin += Vector3(-10, 0, -10)
		1:
			camera.transform.origin += Vector3(10, 0, -10)
		2:
			camera.transform.origin += Vector3(-10, 0, 10)
		3:
			camera.transform.origin += Vector3(10, 0, 10)
	camera.look_at_from_position(camera.position, MOVE_TO_POS, Vector3.UP)
	
	await get_tree().create_timer(0.2).timeout
	
	if MOVING_OBJECT != null:
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property(MOVING_OBJECT, "position", MOVE_TO_POS + Vector3(0, MOVING_OBJECT.position.y, 0), 1)
		if REMOVING_OBJECT != null:
			await get_tree().create_timer(0.5).timeout
			var tween2 = get_tree().create_tween()
			tween2.set_parallel(true)
			tween2.tween_property(REMOVING_OBJECT, "position", REMOVING_OBJECT.position + Vector3(0,20,0), 0.5)
			await get_tree().create_timer(0.5).timeout
			PIECE_HOLDER.remove_child(REMOVING_OBJECT)
			REMOVING_OBJECT.queue_free()
	

func _ready():
	update_board()
	move_pieces()
