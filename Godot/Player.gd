extends KinematicBody
var count = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var GRAVITY = .1
var ACCELERATION = 5
var DE_ACCELERATION = 1
var SPEED = .1
var JUMPS = -1
var MAX_JUMPS = 2
var DOUBLE_JUMP_AVAILABLE = false
var TURN_ANGLE = .1
var JUMP_DELTA = 5
var velocity = Vector3(0,0,0)
var idle = true
var is_dynamic_moving = false
var has_fallen = true
var current_jumps = 0
var previous_y = 0

#axis vectors
var x_axis = Vector3(1,0,0)
var y_axis = Vector3(0,1,0)
var z_axis = Vector3(0,0,1)

#materiaLs that can be placed
var accessible_materials = Dictionary()

onready var inv = get_node("Inventory")

onready var anim = self.get_node("AnimationPlayer") 

# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.

func initialize_player(gravity,speed,jumps):
	GRAVITY = gravity
	SPEED = speed
	JUMPS = jumps
	
func _physics_process(delta):
	var dir = Vector3(0,0,0)
	velocity = Vector3(0,0,0)
	previous_y = self.transform.origin.y
	#jumping
	
	self.transform.origin.y -= GRAVITY
	
	if not anim.is_playing():
		anim.play("Idle")
		idle = true
		#release swing
	if not anim.current_animation == "Place":
		if Input.is_action_pressed("right"):
			self.Walk()
			rotate_object_local(y_axis,-TURN_ANGLE )
	
	
		if Input.is_action_pressed("left"):
			self.Walk()
			rotate_object_local(y_axis,TURN_ANGLE )
	
		if Input.is_action_pressed("fwd"):
			if not is_dynamic_moving:
				self.Walk()
			velocity += transform.basis.z
		elif Input.is_action_pressed("bwd"):
			if not is_dynamic_moving:
				self.Walk()
			velocity += -transform.basis.z
	
		else:
			if not is_dynamic_moving:
				if idle == false:
					self.Walk()
				if velocity.z == 0 and not idle == true:
						self.Idle()
	
		
		if Input.is_action_just_pressed("jump"):
			print("Jump")
			var successful_jump = false
			
			#only jump if we have the capacity to jump
			if JUMPS > 0:
				successful_jump = true
			
			if successful_jump:
				current_jumps += 1
				if not current_jumps > MAX_JUMPS:
					if not  DOUBLE_JUMP_AVAILABLE and current_jumps > 1:
						pass
					else:
						has_fallen = true
						self.transform.origin.y += JUMP_DELTA
						is_dynamic_moving = true
			JUMPS -= 1
					
		if Input.is_action_just_pressed("place"):
			if not is_dynamic_moving:
				anim.play("Place")
				place_item()
				is_dynamic_moving = true
			
	
	var collision = move_and_collide(velocity * SPEED )
	
	#check dynamic movement
	var cur_anim = anim.current_animation
	if cur_anim == "Place":
		if not anim.is_playing():
			is_dynamic_moving = false

	if on_ground(collision,delta):
		is_dynamic_moving = false
		current_jumps = 0
		if DOUBLE_JUMP_AVAILABLE:
			JUMPS = 2
		else:
			JUMPS = 1

	
	
#place the currently selected item in the inventory directly in front of the player
func place_item():
	var x_buffer = 1
	var z_buffer = 1
	var y_buffer = 1
	var new_pos = Vector3()
	var player_position = self.transform.origin
	
	#potential that i need to get the direction the player is facing to adjust the buffer
	new_pos.x = player_position.x + x_buffer
	new_pos.z = player_position.z + z_buffer
	new_pos.y = player_position.y + y_buffer
	
	#the name of the material
	var mat = inv.get_selected()
	var parent = get_parent()
	print("Available Materials: ",parent.AVAILABLE_MATERIALS)
	print("Material: ",mat)

	if mat in parent.AVAILABLE_MATERIALS:
		var node = parent.AVAILABLE_MATERIALS[mat].instance()
		parent.add_child(node)
		node.transform.origin = new_pos
		inv.remove_from_inventory(inv.selected_space())
	
#if the object has just fallen then it is not on the ground and vice versa
func on_ground(collision,delta):
	
	if collision :
		var ObjectCollidedWith = collision.collider as StaticBody

		if not ObjectCollidedWith.is_floor() == null:
			#if on a horizontal material, then player needs to move with it
			if ObjectCollidedWith.name == "Horizontal":
				var delta_rate = ObjectCollidedWith.delta_rate
				if ObjectCollidedWith.climb:
					self.transform.origin.x += delta * delta_rate
				else:
					self.transform.origin.x -= delta * delta_rate		
			return true
			
	return false
#	has_fallen = true
#var y_epsilon = 0
#var y = self.transform.origin.y
#y = stepify(y,0.001)
#previous_y = stepify(previous_y,.001
#)
#if y == previous_y:
#
#	has_fallen = false
#return not has_fallen

func Walk():
	if idle == true:
		anim.stop(true)
	anim.play("Float",-1,1 + (SPEED * .1))
	idle = false
func Idle():
	anim.play("Idle")
	idle = true
func Place():
	anim.play("Place")
	idle = false

