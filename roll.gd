extends VBoxContainer

# start y position for the roll animation tween
export var startPosY = -5900;
# start y position for the roll animation tween
export var finalPosY = 70;
# time the the roll animation tween takes, in seconds
export var timeToRoll = 5;
# time to wait before starting the roll
export var timeToStart = 0.1;

# results of the roll
export var top_row_result = 0;
export var mid_row_result = 0;
export var bot_row_result = 0;

# file paths for the fruit png
export var filePath = ["res://CG ASSETS_Slot/S_Asset_001.png", "res://CG ASSETS_Slot/S_Asset_002.png", "res://CG ASSETS_Slot/S_Asset_003.png", "res://CG ASSETS_Slot/S_Asset_004.png", "res://CG ASSETS_Slot/S_Asset_005.png", "res://CG ASSETS_Slot/S_Asset_006.png", "res://CG ASSETS_Slot/S_Asset_007.png"]

# texture array
var fruitTex = []

# rng
var rng = RandomNumberGenerator.new()


func _ready():
	
	# loads and pushes all the possible fruit textures 
	# into the fruitTex array
	for imgPath in filePath:
		fruitTex.push_back(load(imgPath))
	
	# DEBUG 
	#_do_roll()
	
	pass 

# calcs for the random roll
func _do_roll():
	
	var i = 0
	var children = get_children()
	
	# for each child in the slot
	for currentChild in children:		
		# run the randomizer in the appropriate range
		rng.randomize()		
		var rnum = rng.randi_range(0,6)
		# create an empty imagetexture
		var imgTex = ImageTexture.new()
		# populate the newly created imagetexture
		imgTex = fruitTex[rnum]


		# set the objects img to the new image texture
		currentChild.set_texture(imgTex)
		
		# if the current child has the index of the row result, set row result
		match i:
			0:
				top_row_result = rnum
			1:
				mid_row_result = rnum
			2:
				bot_row_result = rnum

		i = 1+i

	# endfor #################################
	
	#rect_position = Vector2(rect_position.x, startPosY)
	#yield(get_tree().create_timer(timeToStart), "timeout")
	

	
	var this_tween = create_tween()
	this_tween.tween_property(self ,"rect_position:y", startPosY, timeToStart)
	this_tween.tween_property(self ,"rect_position:y", finalPosY, timeToRoll)
	
	yield(get_tree().create_timer(timeToRoll + timeToStart), "timeout")
	
	pass
