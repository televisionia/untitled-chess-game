extends Control

# For identifying what sprite to render on each slot
enum SLOT_ID {EMPTY, SQUARE_LIGHT, SQUARE_DARK,
LIGHT_PIECE_PAWN, LIGHT_PIECE_ROOK, LIGHT_PIECE_KNIGHT, LIGHT_PIECE_BISHOP, LIGHT_PIECE_QUEEN, LIGHT_PIECE_KING,
DARK_PIECE_PAWN, DARK_PIECE_ROOK, DARK_PIECE_KNIGHT, DARK_PIECE_BISHOP, DARK_PIECE_QUEEN, DARK_PIECE_KING}

var SLOT_OBJECTS = [
preload("res://Board_Components/Base/Empty.tscn"),
	
preload("res://Board_Components/Base/Square_Light.tscn"), preload("res://Board_Components/Base/Square_Dark.tscn"),

preload("res://Board_Components/Pieces/Light_Piece_Pawn.tscn"), preload("res://Board_Components/Pieces/Light_Piece_Rook.tscn"),
preload("res://Board_Components/Pieces/Light_Piece_Knight.tscn"), preload("res://Board_Components/Pieces/Light_Piece_Bishop.tscn"),
preload("res://Board_Components/Pieces/Light_Piece_Queen.tscn"), preload("res://Board_Components/Pieces/Light_Piece_King.tscn"),

preload("res://Board_Components/Pieces/Dark_Piece_Pawn.tscn"), preload("res://Board_Components/Pieces/Dark_Piece_Rook.tscn"),
preload("res://Board_Components/Pieces/Dark_Piece_Knight.tscn"), preload("res://Board_Components/Pieces/Dark_Piece_Bishop.tscn"),
preload("res://Board_Components/Pieces/Dark_Piece_Queen.tscn"), preload("res://Board_Components/Pieces/Dark_Piece_King.tscn")
]

# Size of board
var BOARD_ROWS = 8
var BOARD_COLUMNS = 8

# Holds board data for each layer (no layer limit)
var LAYERS = []
var LAYER_OBJECT = preload("res://Layer.tscn")

func make_layer(layer):
	var board = LAYER_OBJECT.instantiate()
	board.name = "Layer" + str(layer)
	board.columns = BOARD_COLUMNS
	add_child(board)
	board.set_owner(self)
	LAYERS.insert(layer, [])

	board.anchor_left = 0.5
	board.anchor_right = 0.5
	board.anchor_top = 0.5
	board.anchor_bottom = 0.5
	
	
	board.size.x = 400
	var square_height = size.x / BOARD_COLUMNS
	board.size.y = square_height * BOARD_ROWS
	
	return board


func setup_base(layer):
	make_layer(layer)
	var layer_slots = LAYERS[layer]

	for row in range(BOARD_ROWS):
		layer_slots.insert(row, [])
		for column in range(BOARD_COLUMNS):
			if (column + row) % 2 == 0:
				layer_slots[row].insert(column, SLOT_ID.SQUARE_LIGHT)
			else:
				layer_slots[row].insert(column, SLOT_ID.SQUARE_DARK)

func setup_pieces(layer):
	make_layer(layer)
	var layer_slots = LAYERS[layer]
	var light_pawns = BOARD_ROWS - 2
	var light_other = BOARD_ROWS - 1

	for row in range(BOARD_ROWS):
		layer_slots.insert(row, [])
		for column in range(BOARD_COLUMNS):
			match row:
				0:
					match column:
						0:
							layer_slots[row].insert(column, SLOT_ID.DARK_PIECE_ROOK)
						1:
							layer_slots[row].insert(column, SLOT_ID.DARK_PIECE_KNIGHT)
						2:
							layer_slots[row].insert(column, SLOT_ID.DARK_PIECE_BISHOP)
						3:
							layer_slots[row].insert(column, SLOT_ID.DARK_PIECE_QUEEN)
						4:
							layer_slots[row].insert(column, SLOT_ID.DARK_PIECE_KING)
						5:
							layer_slots[row].insert(column, SLOT_ID.DARK_PIECE_BISHOP)
						6:
							layer_slots[row].insert(column, SLOT_ID.DARK_PIECE_KNIGHT)
						7:
							layer_slots[row].insert(column, SLOT_ID.DARK_PIECE_ROOK)
				1:
					layer_slots[row].insert(column, SLOT_ID.DARK_PIECE_PAWN)
				light_pawns:
					layer_slots[row].insert(column, SLOT_ID.LIGHT_PIECE_PAWN)
				light_other:
					match column:
						0:
							layer_slots[row].insert(column, SLOT_ID.LIGHT_PIECE_ROOK)
						1:
							layer_slots[row].insert(column, SLOT_ID.LIGHT_PIECE_KNIGHT)
						2:
							layer_slots[row].insert(column, SLOT_ID.LIGHT_PIECE_BISHOP)
						3:
							layer_slots[row].insert(column, SLOT_ID.LIGHT_PIECE_QUEEN)
						4:
							layer_slots[row].insert(column, SLOT_ID.LIGHT_PIECE_KING)
						5:
							layer_slots[row].insert(column, SLOT_ID.LIGHT_PIECE_BISHOP)
						6:
							layer_slots[row].insert(column, SLOT_ID.LIGHT_PIECE_KNIGHT)
						7:
							layer_slots[row].insert(column, SLOT_ID.LIGHT_PIECE_ROOK)
				_:
					layer_slots[row].insert(column, SLOT_ID.EMPTY)

func clear_layer(layer):
	var grid = get_node("Layer" + str(layer))
	for object in grid.get_children():
		grid.remove_child(object)
		object.queue_free()

func draw_board():
	var i = 0
	for layer in LAYERS:
		clear_layer(i)
		for row in layer:
			for column in row:
				get_node("Layer" + str(i)).add_child(SLOT_OBJECTS[column].instantiate())
		i += 1


# Called when the node enters the scene tree for the first time.
func _ready():
	setup_base(0)
	setup_pieces(1)
	draw_board()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
