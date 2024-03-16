extends Node

# ref to spin manager
var spin_manager = null

# ref to all rollers
var all_rollers = []

# array to store the result of every roller
var roller_results = [	[0,1,2],
						[0,1,2],
						[0,1,2],
						[0,1,2],
						[0,1,2]	]
						
# roller_results [0,	 1,		 2,		 3,		 4]

#				 [0,	[0,	   	[0, 	[0,  	[0,
#				  1,	 1,		 1,		 1,		 1,
#				  2]	 2]		 2]		 2]		 2]

# matches per row and column
var col_matches = [false,false,false,false,false]
var row_matches = [false,false,false]

# are rollers currently rolling
var is_rolling = false

func _ready():
	#get refs for rollers
	all_rollers = get_children()


# make all rollers do a roll
func _do_all_rolls():
	
	# check if it is already rolling
	if !is_rolling:
		
		is_rolling = true
		
		# roller number
		var i = 0
		
		# run through each roller
		for roller in all_rollers:
			# roll current roller
			roller._do_roll()
			
			# save roller results
			roller_results[i][0] = roller.top_row_result
			roller_results[i][1] = roller.mid_row_result
			roller_results[i][2] = roller.bot_row_result
			
			i = 1+i
		
		# endfor
		
		# wait until the roll animation has finished playing
		yield(all_rollers[4]._do_roll(), "completed")
		
		# reset previous matches and check if there are any valid new matches
		col_matches = [false,false,false,false,false]
		row_matches = [false,false,false]
		_check_for_matches()
		
		is_rolling = false
	
	#endif


# checks if there are any valid matches
func _check_for_matches():
	
	# outer loop iteration
	var j = 0
	
	# loop to check each row
	while(j<roller_results[0].size()):
		
		# number of matched fruits in the current row 
		var row_match_nr = 0
		
		# inner loop iteration
		var i = 0	
		
		# check each column
		while(i<roller_results.size()-1):
			#print("checking ", i, j)
			
			# check if all rows in the same column
			if roller_results[i][0] == roller_results[i][1] and roller_results[i][1] == roller_results[i][2]:
				match_col(i)
			# endif
			
			# check item by item in each collumn for the same row
			if (roller_results[i][j] == roller_results[i+1][j]):
				row_match_nr = 1 + row_match_nr
			# endif
			
			i = 1 + i
			
		#end COLUMN while
		
		# if nr of matches in a row is equal to the number of columns in that row
		if row_match_nr == roller_results.size():
			match_row(j)
		# endif
		
		j = 1 + j
		
	#end ROW while


# func to run when a column matches
func match_col(var col_id = -1):	
	# if the matched column is not already matched 
	# (to avoid winning multiple times for the same column)
	if col_matches[col_id] != true:
		# set this column to already matched
		col_matches[col_id] = true
		# win
		_win_multiplier(3)
	#endif

# func to run when a row matches
func match_row(var row_id = -1):
	# if the matched row is not already matched 
	# (to avoid winning multiple times for the same row)
	if row_matches[row_id] != true:
		# set this row to already matched
		row_matches[row_id] = true	
		# win
		_win_multiplier(5)
	#endif
	
# send the winning multiplier back to spin manager
func _win_multiplier(var multiplier = 0):
	spin_manager._win_with_multiplier(multiplier)

# receive spin manager ref
func _set_spin_manager(var new_spin_manager):
	spin_manager = new_spin_manager
