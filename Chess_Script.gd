extends Control

# For identifying what sprite to render on each slot
enum SLOT_ID {EMPTY, SQUARE_LIGHT, SQUARE_DARK, PATH,
LIGHT_PIECE_PAWN, LIGHT_PIECE_ROOK, LIGHT_PIECE_KNIGHT, LIGHT_PIECE_BISHOP, LIGHT_PIECE_QUEEN, LIGHT_PIECE_KING,
DARK_PIECE_PAWN, DARK_PIECE_ROOK, DARK_PIECE_KNIGHT, DARK_PIECE_BISHOP, DARK_PIECE_QUEEN, DARK_PIECE_KING}

var SLOT_OBJECTS = [
preload("res://Board_Components/Base/Empty.tscn"),
	
preload("res://Board_Components/Base/Square_Light.tscn"), preload("res://Board_Components/Base/Square_Dark.tscn"),

preload("res://Board_Components/Base/Path.tscn"),

preload("res://Board_Components/Pieces/Light_Piece_Pawn.tscn"), preload("res://Board_Components/Pieces/Light_Piece_Rook.tscn"),
preload("res://Board_Components/Pieces/Light_Piece_Knight.tscn"), preload("res://Board_Components/Pieces/Light_Piece_Bishop.tscn"),
preload("res://Board_Components/Pieces/Light_Piece_Queen.tscn"), preload("res://Board_Components/Pieces/Light_Piece_King.tscn"),

preload("res://Board_Components/Pieces/Dark_Piece_Pawn.tscn"), preload("res://Board_Components/Pieces/Dark_Piece_Rook.tscn"),
preload("res://Board_Components/Pieces/Dark_Piece_Knight.tscn"), preload("res://Board_Components/Pieces/Dark_Piece_Bishop.tscn"),
preload("res://Board_Components/Pieces/Dark_Piece_Queen.tscn"), preload("res://Board_Components/Pieces/Dark_Piece_King.tscn")
]

var PIECE_BUTTON = preload("res://Piece_Control.tscn")

var PATH_BUTTON = preload("res://Path_Control.tscn")

var SELECTED_PIECE = null

# Size of board
var BOARD_ROWS = 8
var BOARD_COLUMNS = 8

# Holds board data for each layer (no layer limit)
var LAYERS = []
var LAYER_OBJECT = preload("res://Layer.tscn")

var BASE_LAYER = 0
var PIECE_LAYER = 1
var OVERLAY_LAYER = 2



func make_layer(layer):
	if get_node("Layer" + str(layer)) == null:
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
	return null


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

func setup_overlay(layer):
	make_layer(layer)
	var layer_slots = LAYERS[layer]

	for row in range(BOARD_ROWS):
		layer_slots.insert(row, [])
		for column in range(BOARD_COLUMNS):
			layer_slots[row].insert(column, SLOT_ID.EMPTY)

func clear_layer(layer):
	var grid = get_node("Layer" + str(layer))
	for object in grid.get_children():
		grid.remove_child(object)
		object.queue_free()

func draw_layer(layer_id):
	var layer = LAYERS[layer_id]
	clear_layer(layer_id)
	
	var layer_object = get_node("Layer" + str(layer_id))
	for row in layer:
		for column in row:
			var new_object = SLOT_OBJECTS[column].instantiate()
			new_object.add_to_group(str(new_object.name))
			layer_object.add_child(new_object)
			new_object.owner = layer_object
			new_object.mouse_filter = 2
			if column >= SLOT_ID.LIGHT_PIECE_PAWN and column <= SLOT_ID.DARK_PIECE_KING:
				var new_button = PIECE_BUTTON.instantiate()
				
				new_object.add_child(new_button)
				new_button.owner = new_object
				new_button.pressed.connect(self._piece_selected.bind(new_object))
			elif column == SLOT_ID.PATH:
				var new_button = PATH_BUTTON.instantiate()
				
				new_object.add_child(new_button)
				new_button.owner = new_object
				new_button.pressed.connect(self._path_selected.bind(new_object))

func draw_board():
	var i = 0
	for layer in LAYERS:
		draw_layer(i)
		i += 1
		
func create_paths(piece, path_list, diag_path_list, attack_list, diag_attack_list):
	setup_overlay(OVERLAY_LAYER)
	draw_layer(OVERLAY_LAYER)
	if path_list == null and diag_path_list == null:
		return
	var piece_slots = LAYERS[PIECE_LAYER]
	var overlay_slots = LAYERS[OVERLAY_LAYER]
	
	
	var origin_index = piece.get_index()
	var origin_column = origin_index % BOARD_COLUMNS
	var origin_row = (origin_index - origin_index % BOARD_COLUMNS) / BOARD_ROWS
	
	var blocked_list = []
	
	if path_list != null:
		for path in path_list:
			var column = path[0]
			var row = path[1]
			if row + origin_row >= 0 and row + origin_row < BOARD_ROWS and column + origin_column >= 0 and column + origin_column < BOARD_COLUMNS:
				if piece_slots[row + origin_row][column + origin_column] == SLOT_ID.EMPTY:
					if (path in blocked_list) or ([path[0], path[1] + 1] in blocked_list) or ([path[0], path[1] - 1] in blocked_list) or ([path[0] + 1, path[1]] in blocked_list) or ([path[0] - 1, path[1]] in blocked_list):
						blocked_list.append(path)
					else:
						overlay_slots[row + origin_row][column + origin_column] = SLOT_ID.PATH
				else:
					blocked_list.append(path)
	
	blocked_list = []
	
	if diag_path_list != null:
		for path in diag_path_list:
			var column = path[0]
			var row = path[1]
			if row + origin_row >= 0 and row + origin_row < BOARD_ROWS and column + origin_column >= 0 and column + origin_column < BOARD_COLUMNS:
				if piece_slots[row + origin_row][column + origin_column] == SLOT_ID.EMPTY:
					if (path in blocked_list) or ([path[0] + 1, path[1] + 1] in blocked_list) or ([path[0] - 1, path[1] - 1] in blocked_list) or ([path[0] + 1, path[1] - 1] in blocked_list) or ([path[0] - 1, path[1] + 1] in blocked_list):
						blocked_list.append(path)
					else:
						overlay_slots[row + origin_row][column + origin_column] = SLOT_ID.PATH
				else:
					blocked_list.append(path)
	
	blocked_list = []
	
	if attack_list != null:
		for path in attack_list:
			var column = path[0]
			var row = path[1]
			if row + origin_row >= 0 and row + origin_row < BOARD_ROWS and column + origin_column >= 0 and column + origin_column < BOARD_COLUMNS:
				if (path in blocked_list) or ([path[0], path[1] + 1] in blocked_list) or ([path[0], path[1] - 1] in blocked_list) or ([path[0] + 1, path[1]] in blocked_list) or ([path[0] - 1, path[1]] in blocked_list):
					blocked_list.append(path)
				else:
					if piece_slots[row + origin_row][column + origin_column] >= SLOT_ID.DARK_PIECE_PAWN and piece_slots[row + origin_row][column + origin_column] <= SLOT_ID.DARK_PIECE_KING:
						overlay_slots[row + origin_row][column + origin_column] = SLOT_ID.PATH
						blocked_list.append(path)
					elif piece_slots[row + origin_row][column + origin_column] >= SLOT_ID.LIGHT_PIECE_PAWN and piece_slots[row + origin_row][column + origin_column] <= SLOT_ID.LIGHT_PIECE_KING:
						blocked_list.append(path)

	blocked_list = []
	
	if diag_attack_list != null:
		for path in diag_attack_list:
			var column = path[0]
			var row = path[1]
			if row + origin_row >= 0 and row + origin_row < BOARD_ROWS and column + origin_column >= 0 and column + origin_column < BOARD_COLUMNS:
				if (path in blocked_list) or ([path[0] + 1, path[1] + 1] in blocked_list) or ([path[0] - 1, path[1] - 1] in blocked_list) or ([path[0] + 1, path[1] - 1] in blocked_list) or ([path[0] - 1, path[1] + 1] in blocked_list):
					blocked_list.append(path)
				else:
					if piece_slots[row + origin_row][column + origin_column] >= SLOT_ID.DARK_PIECE_PAWN and piece_slots[row + origin_row][column + origin_column] <= SLOT_ID.DARK_PIECE_KING:
						overlay_slots[row + origin_row][column + origin_column] = SLOT_ID.PATH
						blocked_list.append(path)
					elif piece_slots[row + origin_row][column + origin_column] >= SLOT_ID.LIGHT_PIECE_PAWN and piece_slots[row + origin_row][column + origin_column] <= SLOT_ID.LIGHT_PIECE_KING:
						blocked_list.append(path)

	draw_layer(OVERLAY_LAYER)

func _piece_selected(piece):
	SELECTED_PIECE = piece
	var piece_index = SELECTED_PIECE.get_index()
	var piece_type = SELECTED_PIECE.get_groups()[0]
	match piece_type:
		"LIGHT_PAWN":
			create_paths(
				piece,
			[
				[0,-1]
			],
			
			null,
			
			null,
			
			[
				[1,-1],
				[-1,-1]
			]
			)
		
		"LIGHT_ROOK":
			create_paths(
				piece,
			[
				[0,-1],
				[0,-2],
				[0,-3],
				[0,-4],
				[0,-5],
				[0,-6],
				[0,-7],
				[0,-8],
				[0,1],
				[0,2],
				[0,3],
				[0,4],
				[0,5],
				[0,6],
				[0,7],
				[0,8],
				[-1,0],
				[-2,0],
				[-3,0],
				[-4,0],
				[-5,0],
				[-6,0],
				[-7,0],
				[-8,0],
				[1,0],
				[2,0],
				[3,0],
				[4,0],
				[5,0],
				[6,0],
				[7,0],
				[8,0]
			],
			
			null,
			
			[
				[0,-1],
				[0,-2],
				[0,-3],
				[0,-4],
				[0,-5],
				[0,-6],
				[0,-7],
				[0,-8],
				[0,1],
				[0,2],
				[0,3],
				[0,4],
				[0,5],
				[0,6],
				[0,7],
				[0,8],
				[-1,0],
				[-2,0],
				[-3,0],
				[-4,0],
				[-5,0],
				[-6,0],
				[-7,0],
				[-8,0],
				[1,0],
				[2,0],
				[3,0],
				[4,0],
				[5,0],
				[6,0],
				[7,0],
				[8,0]
			],
			
			null
			
			)
			
		"LIGHT_KNIGHT":
			create_paths(
				piece,
			[
				[2,-1],
				[-2,-1],
				[2,1],
				[-2,1],
				[1,-2],
				[-1,-2],
				[1,2],
				[-1,2]
			],
			
			null,
			
			[
				[2,-1],
				[-2,-1],
				[2,1],
				[-2,1],
				[1,-2],
				[-1,-2],
				[1,2],
				[-1,2]
			],
			
			null
			
			)
		
		"LIGHT_BISHOP":
			create_paths(
				piece,
				
			null,
			
			[
				[1,1],
				[2,2],
				[3,3],
				[4,4],
				[5,5],
				[6,6],
				[7,7],
				[8,8],
				[-1,1],
				[-2,2],
				[-3,3],
				[-4,4],
				[-5,5],
				[-6,6],
				[-7,7],
				[-8,8],
				[1,-1],
				[2,-2],
				[3,-3],
				[4,-4],
				[5,5],
				[6,-6],
				[7,-7],
				[8,-8],
				[-1,-1],
				[-2,-2],
				[-3,-3],
				[-4,-4],
				[-5,-5],
				[-6,-6],
				[-7,-7],
				[-8,-8]
			],
			
			null,
			
			[
				[1,1],
				[2,2],
				[3,3],
				[4,4],
				[5,5],
				[6,6],
				[7,7],
				[8,8],
				[-1,1],
				[-2,2],
				[-3,3],
				[-4,4],
				[-5,5],
				[-6,6],
				[-7,7],
				[-8,8],
				[1,-1],
				[2,-2],
				[3,-3],
				[4,-4],
				[5,5],
				[6,-6],
				[7,-7],
				[8,-8],
				[-1,-1],
				[-2,-2],
				[-3,-3],
				[-4,-4],
				[-5,-5],
				[-6,-6],
				[-7,-7],
				[-8,-8]
			]
			
			)
		
		"LIGHT_QUEEN":
			create_paths(
				piece,
				
			[
				[0,-1],
				[0,-2],
				[0,-3],
				[0,-4],
				[0,-5],
				[0,-6],
				[0,-7],
				[0,-8],
				[0,1],
				[0,2],
				[0,3],
				[0,4],
				[0,5],
				[0,6],
				[0,7],
				[0,8],
				[-1,0],
				[-2,0],
				[-3,0],
				[-4,0],
				[-5,0],
				[-6,0],
				[-7,0],
				[-8,0],
				[1,0],
				[2,0],
				[3,0],
				[4,0],
				[5,0],
				[6,0],
				[7,0],
				[8,0]
			],
			
			[
				[1,1],
				[2,2],
				[3,3],
				[4,4],
				[5,5],
				[6,6],
				[7,7],
				[8,8],
				[-1,1],
				[-2,2],
				[-3,3],
				[-4,4],
				[-5,5],
				[-6,6],
				[-7,7],
				[-8,8],
				[1,-1],
				[2,-2],
				[3,-3],
				[4,-4],
				[5,5],
				[6,-6],
				[7,-7],
				[8,-8],
				[-1,-1],
				[-2,-2],
				[-3,-3],
				[-4,-4],
				[-5,-5],
				[-6,-6],
				[-7,-7],
				[-8,-8]
			],
			
			[
				[0,-1],
				[0,-2],
				[0,-3],
				[0,-4],
				[0,-5],
				[0,-6],
				[0,-7],
				[0,-8],
				[0,1],
				[0,2],
				[0,3],
				[0,4],
				[0,5],
				[0,6],
				[0,7],
				[0,8],
				[-1,0],
				[-2,0],
				[-3,0],
				[-4,0],
				[-5,0],
				[-6,0],
				[-7,0],
				[-8,0],
				[1,0],
				[2,0],
				[3,0],
				[4,0],
				[5,0],
				[6,0],
				[7,0],
				[8,0]
			],
			
			[
				[1,1],
				[2,2],
				[3,3],
				[4,4],
				[5,5],
				[6,6],
				[7,7],
				[8,8],
				[-1,1],
				[-2,2],
				[-3,3],
				[-4,4],
				[-5,5],
				[-6,6],
				[-7,7],
				[-8,8],
				[1,-1],
				[2,-2],
				[3,-3],
				[4,-4],
				[5,5],
				[6,-6],
				[7,-7],
				[8,-8],
				[-1,-1],
				[-2,-2],
				[-3,-3],
				[-4,-4],
				[-5,-5],
				[-6,-6],
				[-7,-7],
				[-8,-8]
			]
			
			)
		
		"LIGHT_KING":
			create_paths(
				piece,
			[
				[1,0],
				[-1,0],
				[0,1],
				[0,-1]
			],
			
			[
				[1,1],
				[-1,-1],
				[-1,1],
				[1,-1]
			],
			
			[
				[1,0],
				[-1,0],
				[0,1],
				[0,-1]
			],
			
			[
				[1,1],
				[-1,-1],
				[-1,1],
				[1,-1]
			]
			
			)
		_:
			create_paths(piece_index, null, null, null, null)

func _path_selected(path):
	if SELECTED_PIECE == null:
		return
	
	var location_index = path.get_index()
	var location_column = location_index % BOARD_COLUMNS
	var location_row = (location_index - location_index % BOARD_COLUMNS) / BOARD_ROWS
	
	var piece_slots = LAYERS[PIECE_LAYER]
	var piece_index = SELECTED_PIECE.get_index()
	var piece_column = piece_index % BOARD_COLUMNS
	var piece_row = (piece_index - piece_index % BOARD_COLUMNS) / BOARD_ROWS
	
	piece_slots[location_row][location_column] = piece_slots[piece_row][piece_column]
	piece_slots[piece_row][piece_column] = SLOT_ID.EMPTY
	setup_overlay(OVERLAY_LAYER)
	draw_board()

# Called when the node enters the scene tree for the first time.Piece_Control
func _ready():
	setup_base(BASE_LAYER)
	setup_pieces(PIECE_LAYER)
	setup_overlay(OVERLAY_LAYER)
	draw_board()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



