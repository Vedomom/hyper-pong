extends Control

@export var p1_left : Button
@export var p1_right :Button
@export var p2_left :Button
@export var p2_right :Button
@export var p1_header : Label
@export var p2_header : Label

var p1_list : Array
var p2_list : Array
var player_1 : Player_1
var player_2 : Player_2
var p2_can_move := false

func _ready() -> void:

	p1_left.finished_job.connect(p1_ready)
	p1_right.finished_job.connect(p1_ready)

	p2_left.finished_job.connect(p2_ready)
	p2_right.finished_job.connect(p2_ready)


	
	var folder = DirAccess.open("Resources/Upgrades/")
	if get_parent().get_parent():
		for node in get_parent().get_parent().get_children():
			if node is Player_1:
				player_1 = node
			elif node is Player_2:
				player_2 = node

	if folder != null:
		folder.list_dir_begin()
		get_upgrades_list(player_1, folder, p1_list)
		get_upgrades_list(player_2, folder, p2_list)

	else :
		print("folder empty")
		return
	
	
	if p1_list and p2_list:
		get_random_upgrades(p1_left, p1_right, p1_list)
		get_random_upgrades(p2_left, p2_right, p2_list)

	else :
		print("list empty")
	
	p2_left.hide()
	p2_right.hide()
	p2_header.text = "Waiting for P1"

		

func _process(_delta: float) -> void:

	if p2_can_move:
		if Input.is_action_just_pressed("P2_Left"):
			p2_left.call_deferred("grab_focus")
		elif Input.is_action_just_pressed("P2_Right"):
			p2_right.call_deferred("grab_focus")
	else :
		if Input.is_action_just_pressed("P1_Left"):
			p1_left.call_deferred("grab_focus")
		elif Input.is_action_just_pressed("P1_Right"):
			p1_right.call_deferred("grab_focus")


func get_random_upgrades(upgrade_left:Button, upgrade_right:Button, list):
		list.shuffle()
		var ugd_left = list[0]
		var ugd_right = list[1]

		upgrade_left.title.text = ugd_left.title
		upgrade_left.description.text = ugd_left.description
		upgrade_left.ugd_scene = ugd_left.scene 

		upgrade_right.title.text = ugd_right.title
		upgrade_right.description.text = ugd_right.description
		upgrade_right.ugd_scene = ugd_right.scene 

func get_upgrades_list(player, folder, player_list):
	for file:String in folder.get_files():
		if player:
			if not player.can_dash and file.contains("Recovery"):
				pass
			elif player.speed >= player.MAX_SPEED and file.contains("Speed"):
				pass
			else :
				player_list.append(load(folder.get_current_dir() + "/" + file))


func p1_ready():
	p1_header.text = "Ready"
	p1_left.hide()
	p1_right.hide()

	p2_header.text = "Player 2 Upgrades"
	p2_left.show()
	p2_right.show()
	p2_can_move = true

func p2_ready():
	player_1.round_up.emit()
	queue_free()
