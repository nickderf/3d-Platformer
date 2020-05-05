extends Spatial


var upper_limit = 10.0
var lower_limit = 0.0
var delta_rate = .9

var climb = true
#the counter for the climb 
var current_x = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	delta = delta * delta_rate
	if climb:
		self.transform.origin.x += delta
		current_x += delta
	else:
		self.transform.origin.x -= delta
		current_x -= delta
	if current_x >= upper_limit:
		climb = false
	elif current_x <= lower_limit:
		climb = true
		
		
func is_floor():
	return true
