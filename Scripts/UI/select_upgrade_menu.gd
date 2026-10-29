extends Control

@export var upgrade_left : Button
@export var upgrade_right :Button

var upgrades_list : Array
var player : Player

func _ready() -> void:
	var folder = DirAccess.open("Resources/Upgrades/")
	if get_parent().get_parent():
		for node in get_parent().get_parent().get_children():
			if node is Player:
				player = node

	if folder != null:
		folder.list_dir_begin()
		for file:String in folder.get_files():
			if not player.can_dash and file.contains("Recovery"):
				pass
			elif player.speed >= player.MAX_SPEED and file.contains("Speed"):
				pass
			else :
				upgrades_list.append(load(folder.get_current_dir() + "/" + file))

	else :
		print("folder empty")
		return
	
	
	if upgrades_list:
		upgrades_list.shuffle()

		

		var ugd_left = upgrades_list[0]
		var ugd_right = upgrades_list[1]

		upgrade_left.title.text = ugd_left.title
		upgrade_left.description.text = ugd_left.description
		upgrade_left.ugd_scene = ugd_left.scene 

		upgrade_right.title.text = ugd_right.title
		upgrade_right.description.text = ugd_right.description
		upgrade_right.ugd_scene = ugd_right.scene 

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Left"):
		upgrade_left.call_deferred("grab_focus")
	elif Input.is_action_just_pressed("Right"):
		upgrade_right.call_deferred("grab_focus")
