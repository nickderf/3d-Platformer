extends Spatial

var count = 0

#levels

#objects 
onready var player = get_node("Player")
onready var camera = get_node("Camera")
#environmental variables
var JUMPS_AVAILABLE = 1
var NEXT_LEVEL = null
var GOAL = null

#when a level is loaded, the powerups in that level will need to be initialized here
onready var CURRENT_POWERUPS = [get_node("Goal"),get_node("DoubleJumpPu"), get_node("HorizontalPU"),get_node("verticalPU"),get_node("StaticPU")]
var AVAILABLE_MATERIALS = Dictionary()

#Inventory
var double_jump = "DoubleJumpPu"
onready var inv = player.get_node("Inventory")
onready var materials = inv.materials


# Called when the node enters the scene tree for the first time.
func _ready():
	NEXT_LEVEL = preload("res://Levels/Level2.tscn")
	
	add_child(inv)
	
	#initailize materials used in this level
	initialize_materials()

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	check_pu_collision()

#called when a new level is loaded up
func load_level():
	#bring in the level.tscn
	
	#load in objects
	#CURRENT_POWERUPS = null
	#var walls = null
	#GOAL = nullvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv6c
	#get_tree().change_scene_to(CURRENT_LEVEL
	get_tree().change_scene_to(NEXT_LEVEL)


#POWERUP COLLISIONS (Includes double jump and the goal because they have similar behavior)
func check_pu_collision():
	#if collide with material power up, call add_to_inventory, with the corresponding material in the materials list
	for powerup in CURRENT_POWERUPS:
		if player_collided_with_powerup(powerup):
			if powerup.name == double_jump:
				if player.JUMPS < 2:
					player.JUMPS += 1
				player.DOUBLE_JUMP_AVAILABLE = true
			add_to_inventory(powerup.name)
	pass
	
#my own collision function using box collision	
func player_collided_with_powerup(object):
	
	if not object == null:
		var mesh = null
		
		#special case for the horizontal powerup because im dumb
		if object.name == "HorizontalPU":
			mesh = object.get_node("HPowerup/HPowerupSymbol")
		elif object.name == "Goal":
			mesh = object.get_node("Powerup")
		else:
			mesh = object.get_node("Powerup/PowerupSymbol")
			
		var aabb = mesh.mesh.get_aabb()#bounding box of powerup
		var size = aabb.size.x #since powerups are all cubes, the size can be represented by the length of one of the edges
		size = size/2 #in order to be useful for calculations from the center
		
		var center = object.transform.origin
		
		#left wall of the powerup, which is represented by the x value
		var left_x = center.x - size
		
		#right wall of powerup
		var right_x = center.x + size
		
		#front wall of powerup represented by z position
		var front_z = center.z - size
		
		#back wall of powerup
		var back_z = center.z + size
		
		var player_x = player.transform.origin.x
		var player_z = player.transform.origin.z
		
		if player_x >= left_x and player_x <= right_x:
			if player_z >= front_z and player_z <= back_z:
				#if an actual powerup, add to inventory
				if object.name == "Goal":
					if count == 0:
						print("Winner!")
						load_level()
						count += 1
						#go to next level
						
				elif not object.name == "DoubleJumpPu:":
					add_to_inventory(object.name.to_upper())
				object.translate(Vector3(-100,-100,-100))
				return true
				

	return false

func add_to_inventory(material):
	
	if material in materials:
		inv.add_to_inventory(material)
		
func initialize_materials():
	#static
	var s = load("res://Materials/Static.tscn")
	AVAILABLE_MATERIALS["STATICPU"] = s
	
	#vertical
	var v = load("res://Materials/Vertical.tscn")
	AVAILABLE_MATERIALS["VERTICALPU"] = v
	
	#horizontal
	var h = load("res://Materials/Horizontal.tscn")
	AVAILABLE_MATERIALS["HORIZONTALPU"] = h
