extends GridContainer

# For identifying what sprite to render on each slot
enum SLOT_ID {SQUARE_DARK, SQUARE_LIGHT, PIECE_PAWN, PIECE_ROOK, PIECE_KNIGHT, PIECE_BISHOP, PIECE_QUEEN, PIECE_KING}

# Size of board
var BOARD_ROWS = 8
var BOARD_COLUMNS = 8

# Holds board data for each layer (no layer limit)
var LAYERS = []

func setup_base(layer):
	LAYERS.append([[],[]])
	var layer_rows = LAYERS[layer][0]
	var layer_columns = LAYERS[layer][1]


# Called when the node enters the scene tree for the first time.
func _ready():
	setup_base(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
