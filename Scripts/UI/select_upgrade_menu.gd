extends Control

@export var upgrade_left : Button
@export var upgrade_right :Button



var upgrades_list : Array
var player : Player

func _ready() -> void:
	if get_parent().get_parent():
		for node in get_parent().get_parent().get_children():
			if node is Player:
				player = node
	if Resources.PLAYER_UPGRADES != null:
		for file in Resources.PLAYER_UPGRADES:
			print(file)
			if not player.can_dash and file.contains("Recovery"):
				pass
			elif player.speed >= player.MAX_SPEED and file.contains("Speed"):
				pass
			elif file.contains("downsize") and player.can_downsize:
				pass
			else :
				var ugd = ResourceLoader.load("Resources/Upgrades/" + file) as Upgrade_selection
				
				upgrades_list.append(ugd)

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
	
	TextAnimation.slide_in(self, Vector2(0, 3000), 2.7)

	upgrade_left.pressed.connect(UIpressSfx.play)
	upgrade_right.pressed.connect(UIpressSfx.play)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Left"):
		upgrade_left.call_deferred("grab_focus")
		UIfocusSfx.play()
	elif Input.is_action_just_pressed("Right"):
		upgrade_right.call_deferred("grab_focus")
		UIfocusSfx.play()
