extends GridContainer

# For identifying what sprite to render on each slot
enum SLOT_ID {SQUARE_LIGHT, SQUARE_DARK,
LIGHT_PIECE_PAWN, LIGHT_PIECE_ROOK, LIGHT_PIECE_KNIGHT, LIGHT_PIECE_BISHOP, LIGHT_PIECE_QUEEN, LIGHT_PIECE_KING,
DARK_PIECE_PAWN, DARK_PIECE_ROOK, DARK_PIECE_KNIGHT, DARK_PIECE_BISHOP, DARK_PIECE_QUEEN, DARK_PIECE_KING}

var SLOT_OBJECTS = [preload("res://Board_Components/Base/Square_Light.tscn"), preload("res://Board_Components/Base/Square_Dark.tscn"),
preload("res://Board_Components/Pieces/Light_Piece_Pawn.tscn")
]

# Size of board
var BOARD_ROWS = 8
var BOARD_COLUMNS = 8

# Holds board data for each layer (no layer limit)
var LAYERS = []

func setup_base(layer):
	LAYERS.insert(0, [])
	var layer_slots = LAYERS[layer]
	
	size.x = 400
	var square_height = size.x / BOARD_COLUMNS
	size.y = square_height * BOARD_ROWS

	for row in range(BOARD_ROWS):
		layer_slots.insert(row, [])
		for column in range(BOARD_COLUMNS):
			if (column + row) % 2 == 0:
				layer_slots[row].insert(column, SLOT_ID.SQUARE_LIGHT)
			else:
				layer_slots[row].insert(column, SLOT_ID.SQUARE_DARK)

func clear_board():
	for object in self.get_children():
		self.remove_child(object)
		object.queue_free()

func draw_board():
	clear_board()
	for layer in LAYERS:
		for row in layer:
			for column in row:
				add_child(SLOT_OBJECTS[column].instantiate())


# Called when the node enters the scene tree for the first time.
func _ready():
	columns = BOARD_COLUMNS
	setup_base(0)
	draw_board()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
