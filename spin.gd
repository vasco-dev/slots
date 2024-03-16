extends ToolButton

var _roll_manager

var balance = 10000
var current_bet = 1
var total_bet = 0

var auto_bet = false


func _ready():
	_set_balance(balance)
	_set_total_bet(total_bet)

func _on_Spin_pressed():
	
	# wait a bit so that focus is not on the bet input box, or else the value wont be updated
	yield(get_tree().create_timer(0.1), "timeout")
	
	# make sure all conditions are met:
	# current bet is not bigger than balance
	# another roll is not already happening
	if balance >= current_bet and _roll_manager.is_rolling == false:
				
		_set_balance(balance - current_bet)
		_set_total_bet(total_bet + current_bet)		
		_roll_manager._do_all_rolls()
		$RollSound.play()
		
	# endif
	
	# if auto_bet is on wait a bit and keep betting 
	if(auto_bet):
		yield(get_tree().create_timer(1), "timeout")
		_on_Spin_pressed()
		
# toggle auto_bet value when auto_bet button is pressed
func _on_Auto_pressed():
	auto_bet = !auto_bet

# go all in when max button is pressed
func _on_Max_pressed():
	current_bet = balance
	$"SpinBox".value = current_bet

# when roll_manager is ready
func _on_GAME_ready():
	# get ref to roll manager and set self ref to it
	_roll_manager = get_node("../../../GAME LAYER/GAME")
	_roll_manager = _roll_manager.get_node("ROLL_MANAGER")		
	_roll_manager._set_spin_manager(self)

# assign new current bet when spinbox value changes
func _on_SpinBox_value_changed(value):
	
	# keep waiting until roll stops
	while _roll_manager.is_rolling == true:
		yield(get_tree().create_timer(0.1), "timeout")
	
	# update current bet value
	current_bet = value
	
	
# set new value for balance
func _set_balance(var ammount = 0):
	balance = ammount
	$"../BALANCE".text = str("BALANCE: ", balance)

# set new value for total bet
func _set_total_bet(var ammount = 0):
	total_bet = ammount
	$"../TOTALBET".text = str("TOTAL BET: ", total_bet)

# win
func _win_with_multiplier(var multiplier = 1):
	print("WON: ",current_bet*multiplier)
	$WinSound.play()
	_set_balance(balance + current_bet*multiplier)





