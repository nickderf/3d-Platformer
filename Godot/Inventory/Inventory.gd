extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var inventory = ["","",""]
export var materials = ["STATICPU","HORIZONTALPU","VERTICALPU"]
#spaces and their selected outlines
onready var space1 = get_node("HBoxContainer/Bars/Bar/Space1")
onready var so1 = get_node("HBoxContainer/Bars/Bar/Space1/Background/SelectedOutline")

onready var space2 = get_node("HBoxContainer/Bars/Bar/Space2")
onready var so2 = get_node("HBoxContainer/Bars/Bar/Space2/Background/SelectedOutline")

onready var space3 = get_node("HBoxContainer/Bars/Bar/Space3")
onready var so3 = get_node("HBoxContainer/Bars/Bar/Space3/Background/SelectedOutline")

var spaces = []

#thumbnails
var INV_DEFAULT = load("IMAGES/Goal.png")
var INV_STATIC =  load("IMAGES/StaticSymbol.png")
var INV_HORIZONTAL =  load("IMAGES/HorizontalSymbol.png")
var INV_VERTICAL = load("IMAGES/UpSymbol.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	so1.visible = false
	so2.visible = false
	so3.visible = false
	spaces = [space1,space2,space3]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_key_pressed(KEY_1):
		enable(so1)
		disable(so2)
		disable(so3)
	
	elif Input.is_key_pressed(KEY_2):
		enable(so2)
		disable(so1)
		disable(so3)
	elif Input.is_key_pressed(KEY_3):
		enable(so3)
		disable(so2)
		disable(so1)

func enable(obj):
	if not obj.visible == null:
		obj.visible = true

func disable(obj):
	if not obj.visible == null:
		obj.visible = false
func selected_space():
	if so1.visible == true:
		return 1
	elif so2.visible == true:
		return 2
	elif so3.visible == true:
		return 3
	else:
		return null

func get_space_material(space):
	if not space == null:
		if space > 0 and space < 4:
			return inventory[space - 1]
		else:
			return ""
			
#quick get function for the item in the currently selected space
func get_selected():
	return get_space_material(selected_space())
func add_to_inventory(material):
	if not material in inventory:
		var space = 1
		for item in inventory:
			if not item == "":
				space += 1
		if not space - 1 > 2:
			inventory[space - 1] = material
			print("space: ",space)
			if material == "HORIZONTALPU":
				(spaces[space - 1] as MarginContainer).get_node("Background").texture = INV_HORIZONTAL
			elif material == "VERTICALPU":
				(spaces[space - 1] as MarginContainer).get_node("Background").texture = INV_VERTICAL
			elif material == "STATICPU":
						(spaces[space - 1] as MarginContainer).get_node("Background").texture = INV_STATIC
				
func remove_from_inventory(space):
	inventory[space - 1] = ""
	(spaces[space - 1] as MarginContainer).get_node("Background").texture = INV_DEFAULT
