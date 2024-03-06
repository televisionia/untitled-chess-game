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

func update_board():
	var piece_list = GLOBAL.CHESS_BOARD_SETUP[1]
	var row_count = 0
	

	for row in piece_list:
		var column_count = 0
		for column in row:
			if PIECE_LIST[column] != null:
				var new_object = PIECE_LIST[column].duplicate()
				self.add_child(new_object)
				new_object.owner = self
				
				new_object.global_position = Vector3(START_POINT[0] + column_count * 5.25, 3, START_POINT[2] + row_count * 5.25)
				new_object.position = Vector3(START_POINT[0] + column_count * 5.25, 3, START_POINT[2] + row_count * 5.25)
				
				
			column_count += 1
		row_count += 1

func _ready():
	update_board()
