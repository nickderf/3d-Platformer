extends Spatial


var upper_limit = 10.0
var lower_limit = 0.0
var delta_rate = 5

var climb = true
#the counter for the climb 
var current_y = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	delta = delta * delta_rate
	if climb:
		self.transform.origin.y += delta
		current_y += delta
	else:
		self.transform.origin.y -= delta
		current_y -= delta
	if current_y >= upper_limit:
		climb = false
	elif current_y <= lower_limit:
		climb = true
		
		
func is_floor():
	return true
